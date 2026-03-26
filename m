Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02CB910A3D8D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F74B6B00A5; Thu, 26 Mar 2026 08:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A7826B00A6; Thu, 26 Mar 2026 08:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348206B00A7; Thu, 26 Mar 2026 08:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 24AC26B00A5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:32:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E50021A0CFE
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:32:33 +0000 (UTC)
X-FDA: 84588152586.18.7A68DAB
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1B8441A0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:32:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BDF+ESqR;
	spf=pass (imf19.hostedemail.com: domain of 3XifFaQgKCBc6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3XifFaQgKCBc6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774528352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PW5D3P/yH7ZM4fd9U5FDHBCN6E6TiesVaLAHRbrJtkU=;
	b=EEZu1D5lLpv2+yp8H8KHNx+Pp989NbpMh0k1lVLNKapPtcpOCVCJ2cuzCz0gve+O0PH1gX
	+NQgyu5o2nGUI54GSBDHg4dDWD4HbFIMkJNNiDrx6DPniicP43nxzs5fRBBf0gd2ZSI0Jw
	BkJmrW9nl2o/Fnewp67SDm3Io9ebaLE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BDF+ESqR;
	spf=pass (imf19.hostedemail.com: domain of 3XifFaQgKCBc6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3XifFaQgKCBc6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774528352; a=rsa-sha256;
	cv=none;
	b=PkBNsmiUyNrd2fmr1M/haWvk0EvaPnLa8p+93PCu9LBGamH70C8FVFR4W+SeylREYXY20T
	jQd/OwrsoS5Ao7ulW15TMjym2tt+YNj4iIbLrd89wjnr+RM1qna2BAe4v3av2w7WSSv6l2
	xhePAX8tvBp+nvqFBeD37ucJTLfQVL4=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-486fa35b005so12040505e9.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774528351; x=1775133151; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PW5D3P/yH7ZM4fd9U5FDHBCN6E6TiesVaLAHRbrJtkU=;
        b=BDF+ESqR3vSC77hexKkAoh5iHyK1lYzlzTIttYhcLpMkb4myz6gP2SeJjWhop45vW+
         Kx6CLI8FgeOAuPcNYmLi+mrPACrhKlPLNZR9mt4F0U8R5K3zFa3hjbk0tks4DCUytiz7
         TI1rYa1LpeTZP3MJqMg7ZZd7JunK7D8bxb0Y0hJExhkV3yApPoNvCN89upp4TeUAmqh1
         4OV7yu2QkhEt1SKlbhwhwqnlRHyO8BRIvxufB31dn0Fb0KcodCQthH0Pn4jcOYfI0yBy
         Ih75yeXeP18RjiBcxotKqPnQ4PkBLfHVR+965DxGVxW16XEMBt3ke7JU09VaBaZXxgw1
         8nFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774528351; x=1775133151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PW5D3P/yH7ZM4fd9U5FDHBCN6E6TiesVaLAHRbrJtkU=;
        b=PfGvookpyBZz3bj4ci7Ew6Jy0bS+RmsrZP0eu9RVFmAJX6/Q4CIgvLqtYtk4bYoJcG
         IBshjFZTkhTBZMiXPylQaJDjdYGL1Rweqa/bAO+gbMF08ydsUCG1YiHfwAp20fhQzsSd
         yV2vz6m+GpiEjcwQ1TTdyHFJH9LsGkYuimbEWvHQ4PM13IYyKHZiJU25eHUqsObMrqm6
         6BXTIZ+bQod/bxaKD8fjM+OpF8e9x45TpEYinzInmzQtVCgwg2CU9Mz4cgXxUofhEeMZ
         CzdFr26vftyE/t+qgoyChu9qa3pOmVrvx6yziU115qQjJunWrzek+EEWikgTANi16g8f
         +RDA==
X-Forwarded-Encrypted: i=1; AJvYcCWU4VzlEDLi9NQyPGrW6ssWe2Jx0sbFtJR1ca/CwweOKhbBrIE+ggFc9TcFJouB3hjxlquhWN+Yqw==@kvack.org
X-Gm-Message-State: AOJu0Ywiq+pbbjjYZ9SCTiM7RXcaQ6Yi0Os5Sc3AF+kmxESvAcpF7aDN
	Q82qr7jhN0SwAtfCqj/qu1WuPSHwKs0TtPbDZxBWM9oLcDiEdshGiob095WA1lEi40S+sxQYT3b
	Ywt4KDSAGSS4yUw==
X-Received: from wmoq3.prod.google.com ([2002:a05:600c:46c3:b0:482:ef72:5793])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1394:b0:485:4388:348b with SMTP id 5b1f17b1804b1-48715f0389dmr114277655e9.0.1774528350455;
 Thu, 26 Mar 2026 05:32:30 -0700 (PDT)
Date: Thu, 26 Mar 2026 12:31:57 +0000
In-Reply-To: <20260326-gfp64-v2-0-d916021cecdf@google.com>
Mime-Version: 1.0
References: <20260326-gfp64-v2-0-d916021cecdf@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260326-gfp64-v2-1-d916021cecdf@google.com>
Subject: [PATCH v2 1/4] drm/managed: Use special gfp_t format specifier
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B8441A0005
X-Stat-Signature: t5xi4rh8zznotcocxg4rzfhtejidatpy
X-Rspam-User: 
X-HE-Tag: 1774528351-154016
X-HE-Meta: U2FsdGVkX18/Mdy73eQImfdIn/fJDQ2WKs2foYGDW8fXXytuwQ040H/FHOawIt84sTBs/wVPap8BOl3eSorPxkJZjGFV78eHtamgPw/ZevRVbmU44VhT4Kt0N3a2+udRUiYM1DmQ0hH9lADKQ6FZiOVb8TfVgcVRfpxmVrEYgWpsudSS9fE9mBrtaDaRewxFVDpv1qG4OvHjhohxrkcvP4i3Z3059kj/4e5DpJcXQiAONIN8UwBw6WBb+jGMsvPMHjl7CJLlpD726ZRc8ckPyibDq/CgCdxK1poH2ihJR4+4D1dImVGHCUN2oYFoJ2bBgdRPgj4NsnghVi9gKg8IUvBf43zF3L3M1iQdBawvQKyILK0avlN7wqAN17zxG6YcZt1RfysS0T1xmlLIQjHuuZD+LuQwsGOd5Ul1e5iR+0Hp2x//1qq6xi2Lff4AtzqgxBSI27GCN4WzW1uiQg/lKZzG3ebNI8LtK/3sAtf6W0vRMbYhuRQ1/kzqS5yimPmxBWUWuQucuuPS7316cxZejp6r7rOspDUwwR34iu2yb7IOsw6EnnEfyNhTkJXqZGF3tMtzFewldNCSeOUv05TBrcYobBTDdT3dvSOaMCH5k3ra8ym9+7IqLmMkTMbCJ6EJ9/2dx6mOGmcVETpTA0bL7UZWNeURHswYlaENWrj5giJFB+HFJS8J27S0kF+0W7DN7AJFNmdW3/Oj4duNwc5+xb17UDQhCX+N00OJ3B3sTTprvbE5JJwcFA5Z7a0QGYbd33w31dd0eJTlyPJZssxPjv3r05TXou1gdMvPEl9/tQcAWvsEtIHIjMp+sxxHDYgplLd1Vzc+U/aND2ArunLhzmHDe9A09v59JhhGBL+O4DW9g5GOj1As+mNg8ehLgmYnfznMhJ51PAfCbq9cU8GCQz3ZxfZmEJcSSqEJ4qDVXO22Vln319LrRxyI9hyd4J56HxD+4MHkTyFWLpYPkUg
 L0Hzhuom
 KzjCqTT2yIjQ/h1oUY9WzMRxCwpwjalRZaan43KYkqmlT4PiaZqlBue9f3wVmtHKEVL+5SMF1znaKNqXVW1E8ZetIxvJL47ja8R3QaJ/Z0DX9yHwd8zKwsu6TxHVvC+LmZR4NtaM8pZ6NNb9/QYwnhAlwyT1bVK/O+o/3EScXbQrpVGz9uAtlPn019m5t1mvkEJJ7qs4b53Exd5rCKiEXPcTmQGB2lcltigoqpy7bw2bCUL48be1IXYVpbJPv30x0r/C9VZvpzQCTnA0wslbdnsMNIRcj2QgeDNyQMbQhxLE+twl634NNNw5OzcrVuDN2wHn+Ah3vPjQatTXvAStfRUovk7J6UojyPJ6gGUTzqgw6E4aYj4qc3jb7NcKbjbqvnPnH70RVYYL3poppVEVLa6H1IoBgizE541449HJbucAECvLV3z5sElHBcZxs5k7elXIBCaeGQNnSH02HN1G/9o17iZ9e7sfZRkV3zthKTKAEq0oP+UlZ6HUZzjiDRLwV4XkkIv1y5olsUrTvnVyWm7NdXdEzw2RtBMLpwxS3XhTYWPRUFSIn6fENRc//rWddHDXOP+YgvHJicd45dquVqZ+Gt7Vd2a/WvdyV81Nm6agX/WA=
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


