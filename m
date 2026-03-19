Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE563109024D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2179A6B0532; Thu, 19 Mar 2026 12:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 104506B0534; Thu, 19 Mar 2026 12:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0EA26B0535; Thu, 19 Mar 2026 12:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D55E86B0532
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:08:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A16831B85DE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:08:24 +0000 (UTC)
X-FDA: 84563294928.26.04523AD
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id C7D64C0004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:08:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BaFqk0Jk;
	spf=pass (imf10.hostedemail.com: domain of 3dB-8aQgKCPciZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3dB-8aQgKCPciZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PW5D3P/yH7ZM4fd9U5FDHBCN6E6TiesVaLAHRbrJtkU=;
	b=0R6q4uIth981XfIfPA2hp2SkfiIVxx9Pm7dg1sj0JSR1EampKg22ZTrZyhqV/n7xHu+gQX
	RxSWBy63sEcB5V772Dduj2M39pipHiCjPnILSghJ/tfntHPF/QA2+tA3w+gGxZ/E46fWPp
	Efu1rwzYZXDuynwzKxv54njSaUQccJI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BaFqk0Jk;
	spf=pass (imf10.hostedemail.com: domain of 3dB-8aQgKCPciZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3dB-8aQgKCPciZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773936502; a=rsa-sha256;
	cv=none;
	b=Bu4pMhhPfTq0g4edZSzEpvByk41RFgL7v3mNQ/NtWkg/fCsOznF70FmCZN7bv1VoCXs/Gy
	xcQpoOqInSA5vMblc834CVhTlvvcEI28l5ySHDmPk0Pww6MdZ38KCEBp0w++R8lG57Qn43
	R5Gcyt1PrefoaDxE6dRgXgRPQQGeJqA=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853466655dso13756295e9.3
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773936501; x=1774541301; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PW5D3P/yH7ZM4fd9U5FDHBCN6E6TiesVaLAHRbrJtkU=;
        b=BaFqk0JkZ5aOKJbgB0drT8RbpfEE6BOYXF8HKkGCcLyFIFk49XxF4SVIyir/vwoFZY
         ZxTOfczKgOcRBN6VonLTbQkNoAkaAaHHXtlk6/BpTzifEHxWb6Msoz30996eN0m6qZ4R
         NI1G4D3XPrc9kAGEOyyssb2vMRVsKZc6D5sWeKNP9OzEtXt4IYXoLvfFw/+BStCecma9
         tP34Su8p+7pG8VGZAM8LTcakvgF6YhEz6fFYqWjsoilq8v+Ytf4l4sId0rrb+ipRrzcT
         N3WaIfVRxuM7y5DMuyHwAWk8or1EDuMRT05pL63lWZ6dS64Y4zmL6Gx8nNBkyFySd9yT
         mRLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773936501; x=1774541301;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PW5D3P/yH7ZM4fd9U5FDHBCN6E6TiesVaLAHRbrJtkU=;
        b=bQSFW5TZuC/OcqY0hulIsqzmymnZna1qmPYfd5PcHkevOdPz6e0rE+moBC3ToKc16m
         +swJ8UD5Ix0iTtgsyIeiI5RZFhJpuwnaLhupVWTbiif2bdo+TiqJnD+Rqqde0NFBuHOr
         NNJkiVimwR/2B51cjwqN3W8BprxP9Spzmlk8RYZnzRFZUCD3MyqqviPRKV+ClFnTB72n
         YLiwctehsUVnn5Jf1rLtc71tH8y1nKLg6mptHgXnd0Vd0SVkqpso+qBjMDR3dIey8cSv
         WLH3mgIiHkM9nbPCSiUJn5Ju/ULAjjUNddKR91kPvzU5FYYAB3dIh1kT1Zjx1i0YnaSI
         l5jw==
X-Forwarded-Encrypted: i=1; AJvYcCUDWc/5dJUBfDbmKNsE4JRshcOCFXB3CS/ln3zR1AZiseOv1lBCvZ36vi3vx4rwVtRo67M0liGvag==@kvack.org
X-Gm-Message-State: AOJu0YynQc2GKatfxOx+sADHzF8aXQ6EXJTh9dO8toWkwkPUt+AKCas3
	5ghDNyJJkksWBOSJtKMC49goqoQHKvcSD8zYV/wJZNFxtMEJz12RpnBO1NPsYiEE+QZlbBkXICE
	78ChAfVGiM3Npcg==
X-Received: from wmaj7.prod.google.com ([2002:a05:600c:6c07:b0:480:4a03:7b6f])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f8d:b0:485:3f65:94a1 with SMTP id 5b1f17b1804b1-486f4572a00mr138603915e9.18.1773936500294;
 Thu, 19 Mar 2026 09:08:20 -0700 (PDT)
Date: Thu, 19 Mar 2026 16:03:24 +0000
In-Reply-To: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
Mime-Version: 1.0
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260319-gfp64-v1-1-2c73b8d42b7f@google.com>
Subject: [PATCH 1/5] drm/managed: Use special gfp_t format specifier
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: C7D64C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: ekm36mwy3d4ridtj3e48xzagzbh6ia7s
X-Rspam-User: 
X-HE-Tag: 1773936502-696817
X-HE-Meta: U2FsdGVkX1+KP/HmL1KAcpPmhHP/nx2UN1jNnw7eCs3l0iSduPy+VuggcAW4FtHMxr3ibJDdRlFyPqmYhLTbPTRliNnPKniSPEjoGzTj0HhFvU4aN6vLOlFNXbkMERU6Ti60PlmJ0bWpFU/Eug7AvsNAvUOfdVmHZcaouts2EeAeGkohsEBC7v6/Mio8joalhGkdUDcJPXfdYdKiegxhsBSnjYZvb6F6UHSE3+hpzkR+wHjDE5xPJ7aU1Ie1qSFNkeT0gZhiHo/Z9SBpOY2+x4R00nw7169hJVbO9iLBKj6eB+nf5s1bgMbqFvlKtf3VQ3I+btHpqOxiJUJC2U1rHD4QOk2aK5SsrU8rTjw84zSISt2eeS2hPfQXcDOjsxEY8LexVUg9j6nu9V0UngMB8W3mKLqxOxIf+gE0YDSBFTZEoMMhhXj/TA1Fso/YkaG5PmcAy6iAyfKJYX1ao697GekvR+Y0hkE/77WLPRazlJb8HB+tmx9M71scttyn8m1CUwjUawVqkp4nBuDRELgPc0ONcsbp3LTddJ8OlovxZUAf7EFjWZl6gUySKm4n4vwmIJbeZExhLpbmUHC7F66wvrI6k0SptLDD5/krQsJPImZQ6nQbP/uXEE9+N4EOj+GJd3RAWQyl6O2aV+lJ0Goea1/1tryol5bZIdgmBU3v1brmOmQHniltp7UxUkBCCUKDd/7R59pEL1vSOp87SZ3bFfJEkaOLeKPftQVZ5ucIP0JjqZQ6WSLmmNDE+Dsu+L1wgXilOSanxQRd/N3aQ59Cm3yN+1Df4FrE41ihIBTqcier2nsDHEVMqGUAD5C4cZTePIC2klpPfjMd4kQ4wqHm6aITP+UV0v86vovJ/uOA/34XozZ5SFjQf0JFyPsIYBJNFUE2vfdEcEloMF5wiYSM8G6m34h+XVOsYPfExQ/DftNrOVAMptyAlLrZCfJwr/2Kb559tGrcD6JdAFFqHDQ
 RpNSbbG7
 KDU4VPNTrnci23jj9ahGt+UGC2+Zvo7rqXMbS8hm/aBUt7N5St2Tl8pD30srcnMpVfoFeRZAZbHWEHIek+Wd36A8cXHqVoj+G996UmP3XM90m8LEwTq/hM+IeCsETwi9cJ1GCCv3B+4/PBZ0IURG/C0BwbOvkXHyugDWYGwPzeVmESn4zNp+46HucyDj6VuoHZU9/Art/8tfJX4DQ/q6v7yCeu9wXjnZ15hpEshbs81SuRILHriqQuk21s1cDv/sBh+TH8CQE6CmvDkHuhUwnGKOHqmuwaPLkdfY2FoAlu5G3DTCyPqz4m7owLtJMH0Tvv6xDdyABwvworuMajahjRdySamfrYwKDbjKsKKvFfhsSMNP/tTSVSo00xkWflIqS5liBWfkZzkXeG94GYTFnV9+G5nL2dyqKk54hY/iaAlYnRdncCEQ3IVmY3NjbAnSlgLbgS6XBH7EXO1/VINjPvOP2aTyTD/GTMVZNysU5bFrJWF6ZGkvDtyjHVlCvzzpFBWfSuja4sczn1FTdVAEoCWopXnW/i/0IHkc8AF424XWvH3uFxJV+gKKr8XGS6xJNmG6wkk6cYBweISJkvSf/maYCuQihxSJnIUAVNDerH9D/YFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

%pGg produces nice readable output and decouples the format string from
the size of gfp_t.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 drivers/gpu/drm/drm_managed.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_managed.c b/drivers/gpu/drm/drm_managed.c
index 247f468731de0..a9da94319b052 100644
--- a/drivers/gpu/drm/drm_managed.c
+++ b/drivers/gpu/drm/drm_managed.c
@@ -232,8 +232,8 @@ void *drmm_kmalloc(struct drm_device *dev, size_t size, gfp_t gfp)
 
 	dr = alloc_dr(NULL, size, gfp, dev_to_node(dev->dev));
 	if (!dr) {
-		drm_dbg_drmres(dev, "failed to allocate %zu bytes, %u flags\n",
-			       size, gfp);
+		drm_dbg_drmres(dev, "failed to allocate %zu bytes, %pGg\n",
+			       size, &gfp);
 		return NULL;
 	}
 	dr->node.name = kstrdup_const("kmalloc", gfp);

-- 
2.51.2


