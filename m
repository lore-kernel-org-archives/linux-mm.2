Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 961DD10A3D81
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F2C6B00A6; Thu, 26 Mar 2026 08:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6386B00A8; Thu, 26 Mar 2026 08:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E25A6B00A6; Thu, 26 Mar 2026 08:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 257D76B00A6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:32:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E6DCE140D09
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:32:34 +0000 (UTC)
X-FDA: 84588152628.13.37DEBD1
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 23622100005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:32:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pFCZUwl6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3XyfFaQgKCBg7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3XyfFaQgKCBg7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774528353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44Rl4IuwAjVXDZrVO8Bc7181pdJEclCn1gduNsTGsBw=;
	b=PO5DjKArFPE6cdz36cAWlgfAvsclfNLwoKjsuE6BwEgS74tKN85oz0SstBEld/ECPJq3rZ
	5+NVfMpgfwFOx+iLyEWqt1+1ez1m7q6XXd6lnWJpipHeTz1Z55X7aKSuwN7y2Y+X0GS0qU
	YdTFx6w7vBMitsd52o+Tcgx1GjGNCIA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774528353; a=rsa-sha256;
	cv=none;
	b=nrWH1gzW75Qn9woHhHPKft5mawEjZvQHfOxdCH+2uRLsXCMFfJWkVN0vrITLkJdMYIjWUE
	rbtuLIsGyn0KOgyK60EIOby7Wbef8ZRUGlp0uyPcBUuaad1sc8bTMiptRiVvnT1toETZGG
	5WoL5LO9LeZIjgQ33HMa/zSRjZ+6xYE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pFCZUwl6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3XyfFaQgKCBg7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3XyfFaQgKCBg7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48542d5aa9eso7395715e9.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774528352; x=1775133152; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=44Rl4IuwAjVXDZrVO8Bc7181pdJEclCn1gduNsTGsBw=;
        b=pFCZUwl68C/J4doqhnLo6Z9WF/TX5TENU6ZyFn50K370PlmQaVOr3I/+K6FQHrKlC8
         j3kALg3DNqBoEN/Yvn7ArHHlKZaXXyaLkCMWI3A86Xnna44VfaLOahkJ1ifrf6RETQJs
         JETuglxVnR0zIY52ZsczIiS3t/h4/1vgQUZjgH8CJaB5CJI5MUP9XZ1LcBT1b6d1lIiI
         HbrxC4s4zSiG3+1YdRhPm9DViAMn2mZvWfFoKBGe68JNdNRaSZMaGu391GuRR5GG3Fq9
         p5cb1P/DWY/jsH0MvL/gTU2oRQWwUqNi+VNHlIbCNwsiQ9/Z29Lk+ZrcdHdXROlntJ+g
         Dd5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774528352; x=1775133152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=44Rl4IuwAjVXDZrVO8Bc7181pdJEclCn1gduNsTGsBw=;
        b=HOB+rdU1PVhtm5pBBaIWZBxHVUX4HZK8PpmK4YGeo1ITLaqV32Gqh/N5Wru9EI6b+q
         KOv/q0tAQAWH62TlO13s/Y2bn/lTghiHbxpbhhMQFiV64bn93xRRnPRKkGDqaWH1zBIi
         cr176bnhjM+CdDNkgfr+DuxrU0PD4Ofuc6wolzRAqPuwbqqkiK9qp056O/H8btjYe39x
         Nf+OWGwYwEP14QNRi+pAVOweXkf8t6ZCImoFRoUfnBKdDPrVvM065GjqNVsMvPXt/yxG
         ahcpRu4Sp0+HSy+t6PqUma+9STGJBnoqCdASqnAlhdB2HqPe1Y0HQukXmRSGLFtMvykh
         xdbA==
X-Forwarded-Encrypted: i=1; AJvYcCU6R49hLl3juyP+HdRVkamngREHvUxFEtexuYV40ujYOovJiXSns1VhaNBhk8tYQRb55+6IMdpa/w==@kvack.org
X-Gm-Message-State: AOJu0YwcW8L6yngUNcoo2LZM/fBf6s8rC9f+OAkV4Y2sAKUqIzRlieG5
	RdeWBrl9zIvZ0+oJrnPW65xCvNRKaJF2/EO96IRpCTSjUYEMw1anLeLP/yio7xASPFgOOu/EHfz
	KcYWE9kSl9B9wyw==
X-Received: from wmcq12.prod.google.com ([2002:a05:600c:c10c:b0:487:247f:cb9e])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5296:b0:483:7783:537b with SMTP id 5b1f17b1804b1-4871605bde7mr108915255e9.24.1774528351509;
 Thu, 26 Mar 2026 05:32:31 -0700 (PDT)
Date: Thu, 26 Mar 2026 12:31:58 +0000
In-Reply-To: <20260326-gfp64-v2-0-d916021cecdf@google.com>
Mime-Version: 1.0
References: <20260326-gfp64-v2-0-d916021cecdf@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260326-gfp64-v2-2-d916021cecdf@google.com>
Subject: [PATCH v2 2/4] iwlegacy: 3945-mac: Fixup allocation failure log
From: Brendan Jackman <jackmanb@google.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Stanislaw Gruszka <stf_xl@wp.pl>, Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Allison Henderson <allison.henderson@oracle.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 23622100005
X-Stat-Signature: sst6a33ia4meih66bo9ark84jw3xghju
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774528352-909323
X-HE-Meta: U2FsdGVkX19geXkxWSMqWS08GQfUtg76OXkLfz9itAODpmDc+02gYTMDX6f/C9z4tPBJf+WVuKpXbPVvgnrqih0PQlQfSXhWMWcGWhpkjwIere6x1aKuTr717Gf9BfzzLI1UDe53XYT4jlCQ8fD5YzNe6xYJbYwS95RHpsmrUqwpziHuYc3sgC7b147wb0tbLZq7iGRjumncf1pYsvt/gKMzJ6YbWnosIjJTHw5dveRxh8YK8PLmHdKqb6LNHafuIVOneE1wldoNhRNCaBri4jpMSn78F3OSTxFnB4yz36B5MD4YQM0wdVfJ6ws89ILoN9dzgcMi6L9IC1Q2FEJq9OWehEP7AE2ei4nrNB2zyRCOZM0/YPKIbAklkySwk9aPj9NwEswVyXPaYe6qATLAVI4a/pbAs0eIix1F+bfJa3qhw8mp9OQhIKO6f060PCg9AWRiSXUTEmrApncBrGE7NixNgRXrTYKA9UTg26kwwDRJ86C5GY4oC2wMLx2HrsvsXmXgi2HFiL6oKCC0FLoT9wv3EFfRprEOQS7FO7rttvsekQeZCwdbo/qcZ0eunV3icApm1fr6Q+raoFvdSFD3BIZi30nIptTAlbuYdaOt3P0N8+gj21E0WD4AozMq+T82HiiRmBzwpT7AI5x9UWfHNOZ1/j3qmI7WVWfUXYTeIdjcCyP7lFEsJTByVNhVgcXcWhJRJxnQFxhIYoVrm0vzID8ILF88wXDB7VneaotGRiHGmBaxYM/EsKKs1cX/b6T3M/Rb78GxFQ8Z9t+TCTwbFmfZqHM04OlG16XPvbkiMFMtcYRpewsSXVWvB3WFsrrcZvcTooQUxAUFg+t8JfBj8Ut0xdSKOIIpCleqGQCqCdYfvJvBA7AKEbmyXLwkz8/Te+2UHBpoL8Xlqhys2HIgE4buzbExesE+6pgumWh2ARdNTiO1VqnWO8Lzw6Ye/Et8EHyReXxJPyTEu1da31n
 eHPfjME9
 4KJjEFIQiP9n7q796dV5nKrIf9gWf8nSwvvhJzTGjQ1UsVM1DYvVngw9t0Zn7ywapuozgsPnaC0p4H6E9MAhz6v/orM5ciGHJqyrJiCEPqIU4OHq6yi4VB/rw0Ar5ZQtARAmnlaTUWRfVXdNAzQ8OytJXdIKvq3sM2UKGj30n5t7KDEvoetBXQKGHrtpVBdvamNqTTW6938NSyf1GJqkb8e6ILa/ijS1PaR/SDMNWdAQ4wJ6r7GZVvqb3mkDSb7YlwZdC1mDzOyiREIsS7mP6IipD0xJR4B4tfi2tTPSNepXqSuFMlH4twjdbvjuN6NazmM4Tuq5XR9s64N5lsHDU5d55Apdu4So7MF4swbXrpeHQnRhEQLBkZeKkS4ZOBOQxNES05VuSkou+veDGpmgdAZDYGdnVBe2rqKp660VJeV0BEby/jOazCEMvlhBt+ry8askvlkvvxbVry+P9/eQr/Pr1SKvGfJ123QDC/WBHRMOyZArlQnNK/U6jCNrM2ytvnikNV+KHQ73dqQul47rY5ZsAcbT00zB0BzpjdJbYj2eULs3YnMnnwEULQeG/v7VoWKqztsdiOVSNYybQ9mFj57S3z++jpY8at8FELN/TsqpTy2tjBLq9BEgkHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix 2 issues spotted by AI[0]:

1. Missing space after the full stop.

2. Wrong GFP flags are printed.

And also switch to %pGg for the GFP flags. This produces nice readable
output and decouples the format string from the size of gfp_t.

[0] https://sashiko.dev/#/patchset/20260319-gfp64-v1-0-2c73b8d42b7f%40google.com

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index c148654aa9533..88b31e0b9568c 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -1002,9 +1002,9 @@ il3945_rx_allocate(struct il_priv *il, gfp_t priority)
 				D_INFO("Failed to allocate SKB buffer.\n");
 			if (rxq->free_count <= RX_LOW_WATERMARK &&
 			    net_ratelimit())
-				IL_ERR("Failed to allocate SKB buffer with %0x."
+				IL_ERR("Failed to allocate SKB buffer with %pGg. "
 				       "Only %u free buffers remaining.\n",
-				       priority, rxq->free_count);
+				       &gfp_mask, rxq->free_count);
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */

-- 
2.51.2


