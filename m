Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30141CCFA1E
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 18:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A4D8E0009; Wed, 12 Nov 2025 13:58:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A60B8E0002; Wed, 12 Nov 2025 13:58:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC158E0009; Wed, 12 Nov 2025 13:58:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67DA98E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:58:47 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31CF81A0645
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:58:47 +0000 (UTC)
X-FDA: 84102866694.02.871DAD4
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 58D9E180011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:58:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S2SGhzMq;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762973925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOzeYRhvW6xlaG+pSPr/FnesrhCbCiDgfjq3/z1PcaI=;
	b=BphZYZJPEV7vE9R4iCsBGI6WsUENAycDyFhRAcCHM+mzjEErn1XFICWfbZ1d86Th7tpQro
	PpnF03vmnbZTd3BSgPVezom7IRXqqr/EPagPLO4YXBAzJTVN2vo8wLOzLApA82U9qMwROr
	kuSIWBV4N2b+TVpH5tXy3iCst0Y7RIE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S2SGhzMq;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762973925; a=rsa-sha256;
	cv=none;
	b=4+fS2Y/17llPIZfTcqBeZ7HJusY9nQzybVAb/kz+ybLodNBxDhrCAJfi061bOSTH8DEQYe
	6IAE/110DrrFnlw+7D32ycIw7b0clMwj6bYT3oxHBOkARvNCQvkdECUgJchKDpgS+fhy/O
	TpQyk2gGNGM2jwD67PF26iMLYYYl/4c=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29808a9a96aso11655195ad.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762973924; x=1763578724; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FOzeYRhvW6xlaG+pSPr/FnesrhCbCiDgfjq3/z1PcaI=;
        b=S2SGhzMqbDlxzvHFMWUUALsWiOeHi3dXm50fTw9ZK1EDD0W8sK813wNMrTFPbYfKJg
         5EIQffhFklEZfEfXy14yE3wywlL5Qai9mqg2ZyDTHOq1Itwd9bwJa6E5gX1//evobzQJ
         dNeSZ4Q3LZrltUBE1I9fsApP8Ab/rvlkbleVQvNoiHrK/PKzkq6El6cnj8rJ+R0KLL3Q
         iz/ccwYVzRqPOe0Istio5MeqfKr7b1TC+Ywwu+6Su2vsk9CrcpgfoN0c/8PieKusRbKT
         pAAIZhISMO9RAIWdKMfq+jMxb5xpdsQDVofIwk0gbJheX+euSw3I152e9F6+92EgDcmm
         1J8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762973924; x=1763578724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FOzeYRhvW6xlaG+pSPr/FnesrhCbCiDgfjq3/z1PcaI=;
        b=C69dkAGdyMryLjHDLmfOpdPCXbLbWXREQ3pOkiXl6u6zKdTk7JQjJ3HVIQf88jJAiK
         utODOwxhvBrC+ODKt0YX17hsuG5rD9NLrQJprgoeBaEcmicjr8glicGiWiVXTnHl7LkN
         S2V0+aZr3lCn4AQRnO3p8zRVgGZnQv0pDQZkWXQNb8C1qdX0rpDZYRq5GTO0BQFlyCus
         8UAgT4FDLfKknwbFD9xgLL7LONgFXN32lkGWGdDj5McMqp7AtKw0Q+WWomiXUaLEmOyB
         u4hIy8JhSp4t6JDCW9CMtDU3/fJzVSiARo/GD6JjvcjSyjgIIVFwMosLkhSm9Lbks3SA
         E0iw==
X-Gm-Message-State: AOJu0YzIWbpwTaJuwu6IftbLqCSpLvFKPDM5mZFCR0P0umawibnsafXq
	+1iIv9o6f0X3KMjhy5ssec7MwrFxHl7afAbwCycku0RYtUnlEHAl1Nqc3Aeu89jt
X-Gm-Gg: ASbGnctkAA5wbjN8Ds3Fl2Ei1Adt9+pF3/Phzkvgf+DnZc26KebY192uFiA5V8dlR5i
	wwuOQz68q4pDMTOmwo9XkJrtITwT4YuFYkbECuPV//P3hYI2rlPsWWpWd8g5B6EMjdCFEdc8MqC
	ZKwmTiAD5kIaJ6Zu8dMwSXaLsKI06mfcNgqESQy3MxjA0WkdPzfnlNa3fvPEyofu0Ue8qtrPJNM
	iTxzY2lfAF5rbZYkjYcpqBOdQknmuJH4lQzZqcdcXn9TaW3YamrPIigbO6FnBWaHuiny8MRX2+H
	/Oj0T+wrnkbMt691X9ZPcyuWHlHUpKZfVVQGAY2N1MSoloWrIRgVDfWx7IZhfCFbvXjt/rZvCpA
	aEGp429eD9vzClpY0t+YXJKJjZvbEhhbwQfy+6//3+IrJaPIL1NZtQCu2CIetTEdmmHy5kn7Hlw
	wBq8UqCLOakMxe1tdLIhIoAFAPRvTUjiGs
X-Google-Smtp-Source: AGHT+IEJrBaRK17BHWcJTyjM/w29/bLHBps6owC9QTOW3jaEO5KXlOYxTfBkyQVQ+DswKdhsHIpiAA==
X-Received: by 2002:a17:902:dac3:b0:27e:ec72:f67 with SMTP id d9443c01a7336-2984ed27ec5mr50621645ad.6.1762973923702;
        Wed, 12 Nov 2025 10:58:43 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-343e06fe521sm3491565a91.1.2025.11.12.10.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:58:42 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Date: Wed, 12 Nov 2025 10:58:30 -0800
Message-ID: <20251112185834.32487-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112185834.32487-1-vishal.moola@gmail.com>
References: <20251112185834.32487-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 58D9E180011
X-Stat-Signature: rku3yxqbu69c98ge69x4i9ozgg65k1e9
X-Rspam-User: 
X-HE-Tag: 1762973925-124374
X-HE-Meta: U2FsdGVkX19Kd+InbTdLObKKZR/31VT5dbw+E/Jz037Lh0CVxnx4P0lvO6J2muHxU5ZrHlAQj3sazaU2sbg+MaqsP1Po6WKDpUGuw+uFhMyGPG2BmW5WZw1QZcXbJjc9TW/LFAFR7hOIyfSnZ2EkMNDfptg3qpcx2ie2747ckHhYgD5AsxFxhvlzMFhTh9ECQthiHt1EDRIPad7jGPLvtFHUPrf3eLqON1yq6biSFtrP0cQngbSPN6GI14jFyLCK8/h0CaV1k+UAQN+oL4z4wqqz01WaG35J82l5Iu3/Ec4pDuMu47H7/DWpM0aVDX1gJaeV2d5J4eGzy7EKQCpoE0iGvJKP+n2ySwSDpQuZ+YvqLMYWfEpAi7CJrWdtHN2ON1Wl1aDHjlz3f5SxsLV5ihBb8HMvWzy+kiO4sMBfIum4DZ7hrelAqmZaw6eM1tmeBkRz9qNrANPjWBFX1tdOObF1nbBkFfyxgvsXK8Yay6KHyPqfBfP+lJDH0lOlBrITt7jk7gZ9BagsgVIC8CXuptiLKUbiSPzKfLwNtGpsE/aSSFvpzUXxY7yLySjdtT1RWPU3Pn+J6zsh2JLa9j7lvIfZd+9vCQ5kA2ZC0iLcmuT5I3r9u8bMfLi6oZADz4FxDkmEzS8PA13ezr777qpfejunW0Yyj4AnOLprzaj+xYgNeG5AgC0WhknPXUZaJRcAMcsKSbIcBrqkEcIlPT/YmWMezi5hE2I/aEFIwAYECilPIAfJtfUMBqhYuttlvukz0osYKMhdfPkY0KbuzW9RcBiiR+m76AjiQGHwjHCUZu9v8nJzRv1gkEbs2v2Ote2BvHs2hK5xN5eT1VKu8jl5J6w3YqUj4eJlNjNavDW7Clwn2W/MJncQziQX0vGTOnpttpDj2gy9A5yMuFr303HpD2q1mfdgvU7LxxRsAyLlGZd9+Tye2jGwAfzQ6KGIWbyX/nsi4vn2AO6Zv9CdWTK
 +tUcCjeU
 XLDOGaK1qyvJikvbATeF2T0YwHI1BBHL45I4ucK7Uf3PoXYsf12XcNu1BRs16wzRmGXfhXILbytH4ZXosIMPgHZHvlv1UJVSLVSAuVYxoBz0p1UmxeDlS5POJTYUKYkwsYymakKnSoik/xhEHjZPwQoXUgZVZv2L+zV6A/4ItOtsBdckI/mGaMJFCy+Itp1pVc+wW1SCiXnGOUpTfbOYSrl2fwWCs0SB8CzBGWrBJb0Jk5GC2vB62wMr1eFx71pzf3KhYBTvTOEVZcJXTpW5wnwv5cYHXXwyadpkzTsJkC+H5GCvLgjGi6wqLxjYvUKXe+JaK4Tkw5dS/l9i9iEnDKcn6lSKyPLFz0vMM9oZshrQfwUdUbeMR5hKlu89lYUR40XzWCRNaroIEUZ2DUZMS/0rjQRSenXbJbjoy3BBphDGp5P5Rh07T53zJLANXScQ1pCQ7RHuXf2f3SYPdwnEgay50SEnUoDBoVrVANPYWpWQLJIP7I9zsiqVbGN8s+8x7MxcKi/N5zyS4StyEdRpTLwMHs28WbVkPYB/pwP8l0NlRhXxPkjHHeB0zixOS62yGmu/H10D+qWxBxr0YYv7oyBK8r1YfrRNfSPo6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vmalloc explicitly supports a list of flags, but we never enforce them.
vmalloc has been trying to handle unsupported flags by clearing and
setting flags wherever necessary. This is messy and makes the code
harder to understand, when we could simply check for a supported input
immediately instead.

Define a helper mask and function telling callers they have passed in
invalid flags, and clear those unsupported vmalloc flags.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mm/vmalloc.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0832f944544c..802a189f8d83 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3911,6 +3911,26 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	return NULL;
 }
 
+/*
+ * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
+ * This gfp lists all flags currently passed through vmalloc. Currently,
+ * __GFP_ZERO is used by BPF and __GFP_NORETRY is used by percpu. Both drm
+ * and BPF also use GFP_USER, which is GFP_KERNEL | __GFP_HARDWALL.
+ */
+#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
+				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				__GFP_HARDWALL)
+
+static gfp_t vmalloc_fix_flags(gfp_t flags)
+{
+	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
+
+	flags &= GFP_VMALLOC_SUPPORTED;
+	WARN(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+			invalid_mask, &invalid_mask, flags, &flags);
+	return flags;
+}
+
 /**
  * __vmalloc_node_range - allocate virtually contiguous memory
  * @size:		  allocation size
@@ -4092,6 +4112,8 @@ EXPORT_SYMBOL_GPL(__vmalloc_node_noprof);
 
 void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
 {
+	if (unlikely(gfp_mask & ~GFP_VMALLOC_SUPPORTED))
+		gfp_mask = vmalloc_fix_flags(gfp_mask);
 	return __vmalloc_node_noprof(size, 1, gfp_mask, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
@@ -4131,6 +4153,8 @@ EXPORT_SYMBOL(vmalloc_noprof);
  */
 void *vmalloc_huge_node_noprof(unsigned long size, gfp_t gfp_mask, int node)
 {
+	if (unlikely(gfp_mask & ~GFP_VMALLOC_SUPPORTED))
+		gfp_mask = vmalloc_fix_flags(gfp_mask);
 	return __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VMALLOC_END,
 					   gfp_mask, PAGE_KERNEL, VM_ALLOW_HUGE_VMAP,
 					   node, __builtin_return_address(0));
-- 
2.51.1


