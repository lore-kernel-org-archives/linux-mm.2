Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4A50D637AE
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF79F6B0088; Tue, 16 Dec 2025 16:19:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5A06B0089; Tue, 16 Dec 2025 16:19:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB1036B008A; Tue, 16 Dec 2025 16:19:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 958866B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:19:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E38956F94
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:19:28 +0000 (UTC)
X-FDA: 84226600416.06.C5B61B8
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6E47F180004
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:19:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AKT2B8xX;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765919966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=u+8dVyQBwp3ZyKp4kKSktDbrZYNV7A3Vfkv90WVBbxo=;
	b=k0PeWd1vzfRLe338paGbq2F4InGPefTDsLAX7OguiJ/wM66D9LNLdU61aumMnCAxff9azR
	MnK/omuyPkr+qQR4VoOxsehUuD8l5d6/iE9m4kHKXruIe+a7zqhLFnbRyrnuRfxvL6CR4n
	/MEz0t0RzdZSyNX+WvLSduvYRrS51Ew=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765919966; a=rsa-sha256;
	cv=none;
	b=GezCmA19124zSSEHlfy04JrS6NxHhx7Z+5UJHX3E5xz9J0uFvVVcqhF4Cr0gPGmbj6DOr4
	+s6kXXm0oHHu46ScVJnJduk5V7tdCu7tONmmcRhtPu1vGV6za+0Fz5wBhD2E7Dg36pylHu
	ps6oPSxF1kis2GCQB4n4DVGp8DSwPo4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AKT2B8xX;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-37a415a22ecso36950071fa.0
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765919964; x=1766524764; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u+8dVyQBwp3ZyKp4kKSktDbrZYNV7A3Vfkv90WVBbxo=;
        b=AKT2B8xXECGs/BimFCyDXZ0vvFbFMOHwVWbVQMbZMSmrOH3wcsrDMTK/atSzN+XBaJ
         vHC7YTtT5HK5ij7v0gFs7HTsdFlV6sCzseeZEAVdCZ+T8Xfth55ldgKjEjKTFNT5FQAc
         OMrWYaCH9Lh/H2HrYpCbDnB281z0NUc3mi0eIObETPNh90DtsolJZ7Rkuw3iyWtgc0aY
         /HifZv7ON99ExwEgFath3zbrSzgUnm+FJt3r3g4qyAafXeoxO7viXVRRa2QjFqWc6hWC
         UA9wK+Q5H4YKiudKhzZr3L8hBB+kG8rcdoVN1ba6g9Ew18wsWiJaV0Gx4Y6BRGNnLhPs
         +IDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765919964; x=1766524764;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u+8dVyQBwp3ZyKp4kKSktDbrZYNV7A3Vfkv90WVBbxo=;
        b=T7mN8HXPX+hPZYl5EKAC8GWh+lAyGVXHzfS3qNlrOD15YfaPR6oY/6gd22dLGD5WDk
         WYuPNbMtthnHJS7ZoQyGlGncPHOGR+fPZkH9tinC1nv5+m4+Fchy72wDK8VE76ttne7e
         rXOweBDUChoR9SjQ/mHgmZ92bIDVhFWlrerssYCN+FQomCaO47GQx220ClY7VaVSHX+1
         sfCjsz8k2AhUebPLg6Fe1u51lxtvgcA4xSvj9u4ikGVkh44Qf8WGIxn6ErlGgUebQMaG
         JV3jiUGyMDNIwlUiWlGX8IgR/yG22W0uE7uMQ2jeyJ9VdWtPDOGszXMMws/Zb6FRygUq
         crRQ==
X-Gm-Message-State: AOJu0Yy7t90mJxFRZ5vJ25GmvQw6+d/B32zhBwd6LSaq9hjRlpnOAU9n
	/cp5Bl+g8rltUvvxBdaacZz6MfXY2++WyEpIKsiYgViH4VhjvOlUDqCVLPYAIoCz
X-Gm-Gg: AY/fxX6dBSE3icIrJHAer/jR6FHC+kjb33vmKKYtsVXs1rhwO0RuB5iQylKfCNo9TW/
	VskgF/BiyWGt9cj7YwgP/5fL60Sva4KYJjwkHzsS+cOPh6LwfvmI7x7Pb8hb79SeMch0fN6/g5L
	GoYapFZhjWDLyS/Pfv8qW42tknUZb9M05Kc9zMkCWmQhaAbjZLCWET/R2xgVLqLHvIS00S1SmL9
	9vNHke5Zu9ghM6NwXV0Nrx+d0EM/Z0jOlc/+s8kra8snoUo0lT7GGl8mvWu7q45veT3s94wi/b+
	vbqTzZRBpwNKS61VsXuDtSByB6ut5o5nI2GRF7f4nEXuiSNydE65puHcfZ9pFOyQHWWDsVuMShm
	a10YLOyR86MKxjk4IOtyCtlXCLHipUaB28VM7yu3ANQ11c+m7HZ4td4cdky3+k6Jn1sODQyOO9q
	SU0iM=
X-Google-Smtp-Source: AGHT+IEZ/CxeH4/uXyMJT/As4DsgFewxgY9ubVlm3jlaijdvRnSqayer72IxzctOT0FoALGEDcXwEg==
X-Received: by 2002:a05:651c:1502:b0:336:b891:18db with SMTP id 38308e7fff4ca-37fd087a8bamr53294561fa.2.1765919964040;
        Tue, 16 Dec 2025 13:19:24 -0800 (PST)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37fdee05901sm40926971fa.43.2025.12.16.13.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 13:19:23 -0800 (PST)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vishal Moola <vishal.moola@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH 1/2] mm/vmalloc: Add large-order allocation helper
Date: Tue, 16 Dec 2025 22:19:20 +0100
Message-ID: <20251216211921.1401147-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j6zb33s46qpa4aangqfcrporaxgrjer8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6E47F180004
X-Rspam-User: 
X-HE-Tag: 1765919966-166074
X-HE-Meta: U2FsdGVkX19ZnR/NjYvFz9Q+k9tWa24asLXqFRxvNYWrSFk4AAJXl+9Pb+KYMDvjJAH4W+vAcqVaFWISkPpN/pFITBbFm8CbIt0oldo3B/NlGGBBJpQOvORFZCvjKeB6E5iXuv9vD15QhmAEmLB07JrtSO2ew2CfJzdg3tAuPJEsrhU3tZJszX1Z1DAYQtXTCU+BuUvginyerNxzcUjdHFmJLzTXPAPmS4YTV7Xz13VuJxeHsa62CP4qS28VwPbkYO1vmpfwNJevDV44xUIeuwBexXZnIPvnVSM2txQcrsh8n+CjHoraItUb48DGHw1SnI3z8RJCtCTOJyV4+l/N5Si/Ww3X1e17AgcWECkgYyycmDzi50ZAIaGDccjTiNtP1E7o921i2f55fjm44lEKKHLjzSZJ60RfYVecq0w0bAaxbJZuj0Dr79hVhrI+tyW4Ps0lfCNFiTdfU//JBhsptEF4maoAVQxD66OE9Nxjlgm2IP4S/vY2LAW76ZgA2OQLszmT5hKtO4OkDWClVoz2dRuhwHftKI8Vuwpuy/X93FnFTBNXk/PSMKW/uQLdKHrk3WyYEM4LFxndwPioZBTq6YkNfsdoZ8hjKsxlSu1ra/08nw5SPfu8zX/0dY2K6bvLTR9tBMwzBpxX0sFDxnKCBYWcaiyjtPf6JV7HT0tg3tmusnowm0mTdjZgreMHrXt30IqKhKGl++QHDfHw59SqA+BE2ViU54jkJDr0IBTPSbbqc+jtHTBv9NH6ShkR+f7PgnvqaHBXNgC5lvtMxA8CTVsHOKfLYJHOjlshPkZmEqmwNgvBPD7H876b1ftPopa45VbTm1BjAuF88JoQOUJvi5CIwzT+a4M80UQY5dCflaEwEEoLmlOkcy8De+5SpMA8W4vEnVBNDGZmOIkT0NA+mgytcakJ7B0RAL++u5lRc3owczE4yniGBvp6iy0EBTrYP1+dmy2zm1h7Tktyx5o
 pMSX9/Sv
 g0DFUAjviqYKe7ajXyIuPvk+EOHnsFKScz/Itn8lJWZ/JlVpn0/m6GSkLJZDhgo1ey6y2YyEDQl1cKkJDe0TytMTw51uoxcNXfOD5Cet6rqXGm5PxexzLFwquNy2Em3cowliPzPY9zVOU8bToKWR65vnnQD7Exg63a8At4OVHBE/+O6YoAiuzO9MKjkCTF/McpgIqLzefva8H/cd1vqoNCbzbydqi8HqRHsTuZeLSBNoZ3Lzc8dtnWOmvppfHBwn6jGnFLMbgoCr51MVIyeC0iEIIg9+MgVYbe5ENyC9H8m0p9FTj+BUVfumGejSxc8oCUxJvXgwjX0X1q6Nn+n8u+Lcdcbn+eTKxybRILMdTl34pyh4PTiivgWTjknxNWC2L0XpXTFXvxNGeAj7D/SamaCv0NmG6nJvZhkwR2vcCAvFmh5MXi9vzFVgGveZl7C+jeb/rAkwdME7uvofdJOky3MmAl1cIpesPFQc7NcSPEKdf+sg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor vm_area_alloc_pages() by moving the high-order allocation
code into a separate function, vm_area_alloc_pages_large_order().

No functional changes.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ecbac900c35f..d3a4725e15ca 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3624,18 +3624,20 @@ static inline gfp_t vmalloc_gfp_adjust(gfp_t flags, const bool large)
 	return flags;
 }
 
-static inline unsigned int
-vm_area_alloc_pages(gfp_t gfp, int nid,
-		unsigned int order, unsigned int nr_pages, struct page **pages)
+static unsigned int
+vm_area_alloc_pages_large_order(gfp_t gfp, int nid, unsigned int order,
+		unsigned int nr_pages, struct page **pages)
 {
 	unsigned int nr_allocated = 0;
 	unsigned int nr_remaining = nr_pages;
 	unsigned int max_attempt_order = MAX_PAGE_ORDER;
 	struct page *page;
+	unsigned int large_order;
+	gfp_t large_gfp;
 	int i;
-	unsigned int large_order = ilog2(nr_remaining);
-	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
 
+	large_order = ilog2(nr_remaining);
+	large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
 	large_order = min(max_attempt_order, large_order);
 
 	/*
@@ -3666,6 +3668,20 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		large_order = min(max_attempt_order, large_order);
 	}
 
+	return nr_allocated;
+}
+
+static inline unsigned int
+vm_area_alloc_pages(gfp_t gfp, int nid,
+		unsigned int order, unsigned int nr_pages, struct page **pages)
+{
+	unsigned int nr_allocated = 0;
+	struct page *page;
+	int i;
+
+	nr_allocated = vm_area_alloc_pages_large_order(gfp, nid,
+		order, nr_pages, pages);
+
 	/*
 	 * For order-0 pages we make use of bulk allocator, if
 	 * the page array is partly or not at all populated due
-- 
2.47.3


