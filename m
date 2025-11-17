Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF55CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B408E002D; Mon, 17 Nov 2025 12:37:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243148E0002; Mon, 17 Nov 2025 12:37:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180B58E002D; Mon, 17 Nov 2025 12:37:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0685F8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:37:33 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0E93128CD
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:37:32 +0000 (UTC)
X-FDA: 84120805944.07.9FF2A0E
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id AAAB618000F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:37:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mVHdmF1w;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763401050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5C9LjYYrJflrSHBkOuvUe5rS+MjPzFDPPc1TMJZwtTo=;
	b=3OobhNLuIp4X4zJaI6Tpb53Py0+xzy03GpXbBf112Omr4rhOFEldCNRBsT3shN6YqpvnHL
	er5KnRy9VoQET1Pu0lmZxdXmH4lx5GzM9yGT9UKrfmUYU86jf1II9/DF0qcWWXRPMaj7aA
	mTe3+IOv3qdAq/3Cirt4bBvyBw/6amE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763401050; a=rsa-sha256;
	cv=none;
	b=dI1hv/jrNszCnlnXC0My5J/TbQzdjKHCv54sfnui3j2fcbuOs/JUYWMb09dC9RPD6ZFHv9
	Klayw1eGJMflC8C+Ym+haKRDzMMc5P9pnPnF6tVBMD5571U0Z9F38N3umWGj0Z4moJuH5L
	cwQzy6K3GDSnHnfTmKpC7Mwr5Cxft/w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mVHdmF1w;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so4353636b3a.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763401049; x=1764005849; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5C9LjYYrJflrSHBkOuvUe5rS+MjPzFDPPc1TMJZwtTo=;
        b=mVHdmF1wX+Nc85psMkVlqjvhDILtLmPSMSNXFp/v/sNGb3ExO7V5AeEqIPvJTgZeJi
         4FetuVgKyGJFFqrGiyx8cF6NrXQrVakMTqyY7KL2IFPipOW0YyUAOjF4E9pYmKRPczp+
         tc+SL+SuQ75JBcf1BMdiAix3AHaDDw1kscywQ3ogupATKI2HHIJlFdDk3kTnQNW530k/
         y8CY9kUjP46MrkdnpjDSS3pjN3Q2Ggam2aZBZuECSgpjqeyaogfnFy206x0go5TvLI5Z
         SOtL2Rkgv7dZlGOA+7ta6NCDzLHm0tGkFKWlv9z87r4cy1gLM/bODnxGUL0WHbF5OH17
         PqKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763401049; x=1764005849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5C9LjYYrJflrSHBkOuvUe5rS+MjPzFDPPc1TMJZwtTo=;
        b=lsb2sJiD1Idc2eou6wANvRLg4305O/DbHC70FCnufCgSjOqwotxkOmXXJPcOK2byox
         z8mp7nrYezXJXbGtQ1ejhJKfAyMWup1piJSrXMq9Hngdr0SmCr9jIsNrVmzGHCo8grqZ
         91s4+eBm6d3rwWpcSNX5Ujgm0s4iz+0JKq8be1UpIuOlHQ7WUeCnD2uP47/1OqLJdvNL
         rplvFG0D00VC3c6VfHGymTEhzwUwEfoVQibUYG0AlU9Lx8vSWWs6yDVg+tdRY4A3LYEM
         ZlgOCsN3rFBzHRpL+K5ZhtpOPB9kmlNYjMPJpalGqv/YvHGa1rD4/Qy5HfTSxfCrrwU5
         /1Vw==
X-Forwarded-Encrypted: i=1; AJvYcCWkQwlMK0PiwcCU5JRimAwWpYKQHAVn/mUzoPbEouS+jazrEsbd5BEO+tG/+a2gMuOKKLgesaf1pA==@kvack.org
X-Gm-Message-State: AOJu0YyK3Nn3Zo16Gc2DxqY6Ts7F1tSQksEn5x8klDE7JA3eqEJv30PP
	qkhOqUyuM1Y6OLgaOLpm05s17yyYXUdP+2NWANiBTERjOBiaPkwkGMQf
X-Gm-Gg: ASbGnctxJ74xA9osTrdoYJIQiVBLsgO35MRfG4oJIxlaxRmgDJk6q4yss+gt5iK+NIU
	YOlpbSXdFxjUBVPO9pFUpq00mXg4d6c08DZZ78dEyDFigxFOrW31egj4DAN/uQJxHIaWPbYOdPF
	vFvVFpWL5uAyVg8LT/fae08zLHcCSBL+FCx8BmaQXYmR4FfvJbcvHAV6pS9YXgnOp1ZGRonyD2p
	zdfa0lyt9lfxXlRiA/XdmduNwru1hzOmnbmO2teIdy5pBmFVelXm4gZAHp1gw+FKNMujqLwvudW
	ohA8Liwdp7Vl77egmA9YDSsjMHrm0GE5/TQcSB+UvM/iG2oXkR1Xu9fP5i6BUtsu19MkD5a6A+g
	8twgD/TVcXnv67sYVSQxkls70wFtlQfP5X+9uQxStwBJAIu0ZPJxWJOxxSTBT/cE8ycuhGfvDoH
	7MV+krO0N5J83uz3E5obebhMhtlthlyYrM/lb3SJhOYBM=
X-Google-Smtp-Source: AGHT+IEtmyLNGF6+QflVUQjGtJXEUw+OJH0XXFljr1HmNZzIfgfyYe60Ql4OLIvcBVf84mkOlBoDZQ==
X-Received: by 2002:a05:7022:b90d:b0:11b:8fc9:9f5d with SMTP id a92af1059eb24-11b8fc9ae93mr2387442c88.30.1763401049333;
        Mon, 17 Nov 2025 09:37:29 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-11bf23d6967sm17190077c88.3.2025.11.17.09.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 09:37:26 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Date: Mon, 17 Nov 2025 09:35:27 -0800
Message-ID: <20251117173530.43293-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251117173530.43293-1-vishal.moola@gmail.com>
References: <20251117173530.43293-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AAAB618000F
X-Stat-Signature: b6jqqj9a1azj8au7g55coa5rcaxo699m
X-Rspam-User: 
X-HE-Tag: 1763401050-205948
X-HE-Meta: U2FsdGVkX1/MlUCH7FJSe9BztzIu9YeFMcHWblIxEDgCmWoJNjpiIT4QYXDB/aFDSiDCgAoN5Yjh6AC5FLKoVEHUh+lCFgE8Gb5A6WKa9CwXvUfBnm/b52/rAup6f++7MjdD1g9z8w9EtTGj3h6+jETtDcjEEgLRdbiKiXBN5J0lFtFV1TMc/GZwWgrYUg1ENrkLkeTA3owh+jLuRp21Awe0rn9IrAaZrDt+hvtv2+ujch9BHcTg+VqCc5r6YlPbko8JDd0wPWGZKTpqoDdvKIKfUwYXUYwHGwwdSFQt9IwlEGTUe/mok8j/Q3Ykym12RMB86/dsbIAHZbf1y1TESYYqfM+VkI/TD/NYY1JJ0soD7qoDCr1gIb7I6OY/CJd6wptMqzsESYwPHXv4nG4PEIlPuGHIRmQjC6keaQxiETQmB5DDr1OnjLzcA/CYf3qH9XmcWqGMGsG7R1mJxirvNNN0Y6MeLRzYDVvVo66tp1cTgs/GTArsQX+Naf6+LlA5wxmU/G4YijI5qmPx8k6Pdi6k0FdMylw2m8CBSMBXCwxeEUmV2oCIVeHFiRIkukWZIlMM/1tPULRbhYawjSEl72Se7iw6KRYWfgHqOhDcXgSGtp6FXunHKhPovYmeBFIOqB06BmXQqi4+VFcNPbMNVESxTbWCOCTy5D64/Bu7vfuJCct6GFflQlmuEUNlfqvhhwyKHsZ8XCAazpe6CL0A69gYZqGGwHAeatTx6IMxtYvQoM2Olvhs84jhaYcEMskcik6npwljnseaM2EYPjOwyYhUYVLakJ2ai9jEBoH5cNuLL6EMCa9QJ52JaqQd/XERJaM2z/o+97nAyS0LWWh/50XgIH5W71coHM7Ja51CWpIWX5t64hnrOupdrTTqOG9g9lhMyRHD5FKze6goQPBkJ4l0A0bktRGoT+GlCsabv2XU3GZFDHHOfrj+ZBYPtw8P3lL2Ca5/yIETp/poUOE
 uvL2x95v
 HegsBfUjnFVa1y3o7s/dYKv+0cyVrLi6DNR4zC5ZP/udPAV2/svdrgdB29gPiOOrd3l5w2JYB6IUccLvdfytfUSiNinHIuzJRvpdQVXsvcNbyqMUYbseda+WEyiOsyzA0+I2RwoorZ3Ohcnzs2eJEQbp/LWNHDzJCy5jI8GaohdWTC68mFnFTjS+2UC++er8JwxssWtgT4KxUGRKLDCvNPqyqniaWZ7MdQb5C18EdB015lSKTnJJ0yVWUvxg+33KdAREZ6FDv3syIN3sw8ATWZiSJgFX0dPg+W8IxSYoeiYaReTpHGch6WytWS5Oh337usXzYQT+toucpjxLD9AziFaXY2lZlcqqW753+1X56N6ePLzI4AfxpmkzZqBr3bkl6E/OIskC9fQeHR8Bsfae7NxwLRCUosItHI8CWkNAagSQnlRTBZEEpZVnbStUcA5bBlTA/G6qVi8OnJqCfB2tPWPTKEgl0yj3MXgOE89kJSGfvLpvEfy+hsPTBmbR83yOh9CNDktzDdutm0jTf5PAv4gLA0wcYa7IQpfleW7jptGe+lvxmNNuDqMpVNd7uYLllQhVUl9/QL7cP/flCITgX/ddo3SVMivYb+JEK
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
 mm/vmalloc.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0832f944544c..5dc467c6cab4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3911,6 +3911,28 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	return NULL;
 }
 
+/*
+ * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
+ * This gfp lists all flags currently passed through vmalloc. Currently,
+ * __GFP_ZERO is used by BPF and __GFP_NORETRY is used by percpu. Both drm
+ * and BPF also use GFP_USER. Additionally, various users pass
+ * GFP_KERNEL_ACCOUNT.
+ */
+#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
+				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
+				GFP_USER)
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
@@ -4092,6 +4114,8 @@ EXPORT_SYMBOL_GPL(__vmalloc_node_noprof);
 
 void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
 {
+	if (unlikely(gfp_mask & ~GFP_VMALLOC_SUPPORTED))
+		gfp_mask = vmalloc_fix_flags(gfp_mask);
 	return __vmalloc_node_noprof(size, 1, gfp_mask, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
@@ -4131,6 +4155,8 @@ EXPORT_SYMBOL(vmalloc_noprof);
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


