Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFA4110A3D8E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C983B6B0093; Thu, 26 Mar 2026 08:32:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C71E26B0095; Thu, 26 Mar 2026 08:32:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87026B0096; Thu, 26 Mar 2026 08:32:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACB1A6B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:32:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B3821B9346
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:32:37 +0000 (UTC)
X-FDA: 84588152754.07.490300E
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 93D02C000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:32:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K3Sms3bT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3YSfFaQgKCBo902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3YSfFaQgKCBo902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774528355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PnUmSvdGrdA8wXtaJVKX+3lGQinclElGewhzWnJqPks=;
	b=sKlsrc2AWlN979VQImk3X5oM0j5NMFCJVm/dx5s2sYB+JCi5NGYFNaOBV+sqUTAsT70DGE
	LWobTxSpFTvTewfHVU7LDZJWBGqcFAXt1a/5iu+uFss6tcZiTzZTefxaM0PJQGg0W6dsBQ
	XRj6B0Q5Bq3Vd/MI2bdQGDKsl5PJpms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774528355; a=rsa-sha256;
	cv=none;
	b=U4Sl0f16LmXSsX0SlG8P1wIcJ2p2k+8MZfqwIfM+W6MYJI6RbSutRNS/4jx+eJqVpdjj55
	RkrESR3yyGEVduigoyYVsTWjoZIPEsQEs6WaYDhFLkn2Peh8WMdLlVv8/4xCqIJWQBykiW
	x4iOreR1nG/itWhhv+JAOqy//5iEaZc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K3Sms3bT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3YSfFaQgKCBo902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3YSfFaQgKCBo902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48532df52c5so8896575e9.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774528354; x=1775133154; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PnUmSvdGrdA8wXtaJVKX+3lGQinclElGewhzWnJqPks=;
        b=K3Sms3bTbeu2N7ZovzyVDv21IwDAzRVrC2sdreSXPxN6hitRf1iT48pDCehiD2crH8
         L4E5Pd8OMpXgAjuVLcobVRhYVKsXs8nhmCNJr5tIQQRwO/KSzUlDbt2d3dupX6TKnWBD
         6HIg0ccvfLapvbLZ5va79U8fv2XnCbTsyH/RN6TDTjccCPrTqoSUG3Hd0UEffGKwb4zw
         aHsPoaKcprDr76KeFx4gFtn788652lXP6Rvpp1cOqaZougWhf0zb7q0mu5wPZ0GoU6Pm
         mGv5tIWBcmacfnFWhuP2oPcYLoItySn77SJyvAPkH8pm/qyY8yOCgnaLQ/u2fs5NP8hb
         My3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774528354; x=1775133154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PnUmSvdGrdA8wXtaJVKX+3lGQinclElGewhzWnJqPks=;
        b=qCzQULUiOn/r2r/0UsGkPHRsRehxW24KifMtN102uGBHMW3zXvmHgrRxFwX/sS+mMj
         Bk+/XKt+TGy2h3KrWpvrfqU6Ske5028bnyUSLknQj+cjf4D1Hz9WGU3w/G71qrlgvRS5
         FTmqpOx9rEue8Kktl0u+nLDCkoT3MnK/O5jj2EWRs/JPKs+EWgAe6pQ8BlruIhi3ylTp
         s+pGCea7u55epOr1Nz4WWOrGFQOaIAICn2Vej14dQDyh/R8RWzjeQPub5TrS6Fvwg7iv
         Im0BsUL8fkee2MtDqMfZhdKDt9uHrouGUS4EkKDQK+h9pSjgsZ6LDsbBcf0l6LhEdEVt
         BzTw==
X-Forwarded-Encrypted: i=1; AJvYcCWhosaGFM+ya6k7GJ3MF8Ue8ug75HWgC8wQi6jpktNegpclTPLzVPyciK/QXm29RvsRIr0qvbRtZg==@kvack.org
X-Gm-Message-State: AOJu0YzEVKXofiPToHRXhGxs6iLcPcTB1lU1y95j62Q2CS6D+qOqc7+C
	QRY9aBebk3dCymudEi+UKTNX372r6XBgWO1OEfwleSJ2gGAdv0QJ0W2vDLBCFQUnfWMx+UEV+py
	gv2CxSwP5sTq0KA==
X-Received: from wmbjr7.prod.google.com ([2002:a05:600c:5607:b0:485:3682:6cf6])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f95:b0:486:f308:94ec with SMTP id 5b1f17b1804b1-4871606d88cmr107670785e9.24.1774528353854;
 Thu, 26 Mar 2026 05:32:33 -0700 (PDT)
Date: Thu, 26 Mar 2026 12:32:00 +0000
In-Reply-To: <20260326-gfp64-v2-0-d916021cecdf@google.com>
Mime-Version: 1.0
References: <20260326-gfp64-v2-0-d916021cecdf@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260326-gfp64-v2-4-d916021cecdf@google.com>
Subject: [PATCH v2 4/4] net/rds: Use special gfp_t format specifier
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
X-Rspamd-Queue-Id: 93D02C000C
X-Stat-Signature: byuruce4iggdnxxazocni1u1wqb653gp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774528355-8414
X-HE-Meta: U2FsdGVkX18Gi3v6sskoBvc8Me6md2Nie3Rp+hcBhnnoXnY7Ow5x2M1kBSod3qeliuJABEOg9FmbJ5NbVphNvCAp87sajwy6iSELUzFPHbX+ZTE1M/xNW0P3g7fJLCJbWcfZJw4D/P58Nd4N+N/LZx1bb+bWFHeOBuD9C8Q+Ui6l2dc0+DACvvitOQ2y/iBPQ0/3TxCxR1Uni1AWgl4ne2gvc+lkA4zsgTBrup5lEC1E2hMAqzj55gczps4WGoIVAf1y111Yxq3ZSS9wTP12VzsOV/Z+BNRUQoO+UIbfe0va53bqlrHD4xb4aJCDJzi15ry99J3/fuGXq6yZ+pIZnZdoKM6zyn/gzMU0f+Ju18eskl0V0DsSMGxEQKUEC8J1OhVKbCVjHAmvBQddAMw5exWkINlb5LMvolBHJYQdnzkfvNHePIAdorT6d7JRHFmKc9W4ADDzBwELlRyMA1iLR1hcZNKxmKk5iHtSzjZUX04ZivSzUiFZzuAlrcFh9Ngwsi8uuV7Kkag9hqwnospMzszOG7uAkntF39372FXft6zYrDPj9C4Xs/zdymaCIfM/RWydwmeI4msCHBaFGw389lty/rebYvznedcioyDcL8gVOv2SiWWwyxNyV+Mxk6RywSfO+UEjXYBcyfJMvqZIZEJ2Iw7EMClrDdlpTdwt+gvTrmy8vQ82DCL0LUZYas/5OapHe27f/afcG8pKLBsER43LwRH0fi3sYo0cpQBqhha9v8+Vqrb1nclZJJL+qoCOcYzgFXKlmx0we2T7bF9PLtKAhKX9Pqol0zUWuJTFvi5Ggb7N8UEDFRzEim2Qa8jLRROXZZwheoof2l5q3UPidEtkbQ0yLZPr8tfVu2P2eYDTCLRYtFq/DZsHIqz2hX9YQERUSSF4rfzGELLubt32gDALkpa8a0G7YFSiF2qKTO/QK4lz/dYWWIqXLX3vGsWqQLLTWXd8aEf5W15dNJR
 9Bikk3Or
 ciCeHTkelEqb3OpRh5Q/V+vv2KAEK0FH7/CtUivl1P0IVN0etkep1aB/7K60Zw2bQ32BoIECRKKL3XhHARKDAxUZZ+7rqy78G4a08ky2+gftm+kPoRzjBiwhXAAXvZwKTnB91FBeowbOCkp/xkuE0rgBNRllhi9fjQ2C+Ekrlpkfyqg17jR2Oz1Y6HTapAHj91XFMtbVf4vEVFB2MDS2FW6pfdIkPvbtZQYsTw/dpwk0vuqfnvXuALO6Aiq2NpFLh4KkgoLKv3v/9xBR+a0zDtVG6+5kfe2ps5x62kDmej32R2EwxzpFW0Ny2dhUWiwyNoKZ+emkxbYvXuSDv3eRkxYzLBC6zgBThqO3u0p1+h55qU/6Ito9/pTxOwa+FkGa19Y8/lOYbyJ72vsgqnA0kfXkzMKXC1Zo4t1waoTw/DCAQXLx9DOOTi0i6DRa6ebuN00vogklUxLXx4eBLS4ZJOGikw2Dt++qbxaul8xTB7HinXKB1FtP8Y8PrxoY1uAEa5mg+7WKQceWTSXxCAC9BXdjXMySK+LCVLAZE04etGry8mfEdu9GBwk0dukO4PMrJa6OnX008+PIkFgDFUPGxYlPiA3PU4tjQ7r+hWwOX0FmgMywOlVA1B4eVy5aH+zMDdd1oCVEUTxMPHIEF23awlF4PpDprDRY0Z4XJ360kxbYZul9eB3ZdCBqFtUduGn3uE2Cu
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
 net/rds/tcp_recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
index 49f96ee0c40f6..ffe843ca219c7 100644
--- a/net/rds/tcp_recv.c
+++ b/net/rds/tcp_recv.c
@@ -275,7 +275,7 @@ static int rds_tcp_read_sock(struct rds_conn_path *cp, gfp_t gfp)
 	desc.count = 1; /* give more than one skb per call */
 
 	tcp_read_sock(sock->sk, &desc, rds_tcp_data_recv);
-	rdsdebug("tcp_read_sock for tc %p gfp 0x%x returned %d\n", tc, gfp,
+	rdsdebug("tcp_read_sock for tc %p gfp %pGg returned %d\n", tc, &gfp,
 		 desc.error);
 
 	if (skb_queue_empty_lockless(&sock->sk->sk_receive_queue) &&

-- 
2.51.2


