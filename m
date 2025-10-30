Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9242DCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 16:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD471280019; Thu, 30 Oct 2025 12:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAAE6280003; Thu, 30 Oct 2025 12:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A45280019; Thu, 30 Oct 2025 12:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B9671280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:43:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B0E51A01D7
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:43:46 +0000 (UTC)
X-FDA: 84055352052.06.43F169F
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8EEAF40010
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:43:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gCOZ2m6m;
	spf=pass (imf01.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761842624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rJR2QNXI8LxWN+nXgPzLnA8HQF9631natZVXu0HRJo=;
	b=8VulHB4Jw2szU6gqnN2B0V3vQhQtf77fgTThYAfelS+8GmTjC0Auqm8bmKfwFCqHrpvSMq
	hO2IL1jHgyOoet4NM2f2jXAdv+L2+kaJ0BetqN0a1KDS+xZo2TmpIWgBiImMcp6q/r4c28
	HoOBrvjCdw0veVz8TVnujaGCSfT91eU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gCOZ2m6m;
	spf=pass (imf01.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761842624; a=rsa-sha256;
	cv=none;
	b=jC/Lz6B5hIlytfegawx57DOpTVaJmzKnghlNP9yIWgrPjwfN825JV4424SItBv3Bo9zhQl
	W59nUX6+/BLZUV51CH85uh5C+L0zILIlBv1u55RNvMlik45ISxk1FboxDYxuGVG74Pd+t0
	gH0zRR2zMCefJ+11xjT+UrV5/i6WVW4=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-426fd62bfeaso613078f8f.2
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761842623; x=1762447423; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8rJR2QNXI8LxWN+nXgPzLnA8HQF9631natZVXu0HRJo=;
        b=gCOZ2m6my/RbjU7u4cAAoHrld2ZQ3bbolBdIrR4u/3E2u+peH30+U29l/hrZZ1jLHD
         vfG95Iicuae8VFcdvk8OAgLxG9gnVKzcCgpAKMbQZ6Q8IJXHCWnvg377LkcxaFFjG1To
         uJ/SDGMtCHg3lGND+VZBABu8g4w+fp+/Fj6h0DkOW8BQXQHfFv2cIT3qPrIdiYUkjDXU
         nE8rgJ04nXBh3CRJK+fIOEfaLTm7EDUXbx34aRmsTsp/i1BA6lbCn9zaSiH50ZUJmEy3
         lZAb7pMfkn9M9ElfnAAm98+sC8srd8xIHX6qDKX6TNd66Td5AmqHc5eODJAE/8lLFUdd
         ZseQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761842623; x=1762447423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8rJR2QNXI8LxWN+nXgPzLnA8HQF9631natZVXu0HRJo=;
        b=FcH49iAs84lWjcehhCF0eBrxwoH4IHvO0IrSK5C5HAzSbKZqhSANdQr2YP4CG3gbzg
         rEx//6oJn1FmLRMT1z2nMd19sslLMJJgcHhsihp4FyiSs8UWMwlqDsM0IvE5lL7g96FV
         lbWvB+xhTyiRuqFeQJF+4EEqp9GuVMlfMD5ptjW4kKctBEBHaflXiTOd26bSyuGCDK1Q
         SbqxwQg/cYIGYabCqfW5oaDuyni5De3YEPaoZZ5xwygHFIsvx3CWsGE/a/gNMbK1GFAR
         yLLOVwbHBySVBBFIQKzPFnexBGVDnsrNPp8XdMdJkRFsxzhM1mi4Ox949Ld4cqvDbHt0
         D8iA==
X-Forwarded-Encrypted: i=1; AJvYcCWklmMYVagy5MNkorPWkSBoG9F1b9eUEjgJ0X+bWejDuPrDpD36o5HPnKHJu4Ok/0tJttbGD4xX5Q==@kvack.org
X-Gm-Message-State: AOJu0YxGfXDGM67UfhfVgX47j72C2fJYLQtZXwOejbUw7lyNxIsM2qGD
	vXrcepHgARyp5Z8f5Nl1cFYjZWraKsYsADHD7GpekQh6D6n8qsdzZYxl
X-Gm-Gg: ASbGncvZDe+2spVQ/y6I7tL86K2NW1tbK/IswIA6QDdLjLo9M55Cx4BGEwLm+Az4Q+8
	0XtxWta2pHs9l3ZfGUa8wZy7hqtOq93ZyyMuibYajOVf2sUq6Zj9w0t7ErWG7oc4amusqGixK0E
	yrXPBgXb0l9ZTtUwG6zcJJBI2u16GGLkZ1U3vbkfEKgnhkUBNghV86WyS+seMfdBi04WzKkk5DW
	/RWii0n2626sRICkQoxdVeGdqLBZNp4LSKYqsDO/pyQPkonsharBM+YyxSOrzWsYD5RuMW3X5Wg
	qpKXqoN4uGg6i8pCSr4jpMfdV/T+ubB6A8LPKm8A1To6jHPac/WU3FcRLQBA25ILn0ZZJv9lhiM
	Tg7PRBZNRKfGb5Kn59Vmo5LvXutkcLUO3KP2/qQE14oRpk1uNkeDwcq9uJxR5QeDXjfzg3HNOIx
	nfe6ydYP4qg+xCoNJ2CuZa+BLKEa+5j8ThObkfcD885pa3AcwKCzw=
X-Google-Smtp-Source: AGHT+IFa/gh3+Fp0odQqkPcLPVFbb3qYZsshUGdgRE0/AtPjK60ClOXH6LeV96AFHVdSxao7UDWNdQ==
X-Received: by 2002:a05:6000:186c:b0:427:490:68d2 with SMTP id ffacd0b85a97d-429bd6887d2mr229192f8f.10.1761842622808;
        Thu, 30 Oct 2025 09:43:42 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-429952df62dsm36796839f8f.45.2025.10.30.09.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 09:43:42 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RFC PATCH 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Date: Thu, 30 Oct 2025 09:43:27 -0700
Message-ID: <20251030164330.44995-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251030164330.44995-1-vishal.moola@gmail.com>
References: <20251030164330.44995-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8EEAF40010
X-Stat-Signature: mpbwrfmf9ddw465bmyaczkehi1jugeqm
X-Rspam-User: 
X-HE-Tag: 1761842624-539251
X-HE-Meta: U2FsdGVkX19dKfFZrBi56e70jBY8a4BmXlVkMHibsPJKwB+Yj82mGSbkN6ey3gemzmXYX6eVgBgVihGlqkKnnp23g4v0I0yNlmnrd7I0sd7dpiN8N6KpMCOb1gZvOATwjGCkhaubrAcN0HaG70JSjyv0nKhlJM0Ay/HdkULMsl45Ft+tgoctps2Tmd+jjhCtiME8jqlVDEEQhJEsdiogjh0e/riZwENAl9ONn55Gdk+sUIktxhrySrAyneFMhdrvOG0+ctCtPl2GqsOxSJ3lR+LAZd/usdoYHw+EP0Ia62o3ckc3U8l3RSgBa7yTwSKotn1HAAF3cOW5nA0rSeyWYG09p1lsIqaoRLLM+bUwUuJIMOpWQkAb3YwsWaKTaAHSj/RmMP0nnpeFE6G9xEeBoHCTOtSKCWTXsqx1p+M6wNJnaXfJTzzlw4HXM9C4Aa+8gt+XVNiPbJQPRJrHOSKBblyvGeggBLCPWIOGa0GFSV9GZPHf6t99e0HwpRoleiV1tYQ59F/c4HM0hXKmwOv0hf8szEP5a07Wq8PouV1zhAFef8qv1Y4IPSxop9UeFM6X5cEUeKfH6wI42hWiNfDxTsAhiIVqbhnfF0kif20k9doNiVA7I5lhWPPBWvMo6C/Co2B+JLZVucZ5VOZw6kEMTYr6noRqjnEIYSwoNFHs9q3LGJL/fTSDymqsX/R+PTotrqU8+uMuuir7/nmQhqAfMhJqMVITC+pH0gOfzvHKpAbT7gErtAs+LSDXgUTvhRH/i6OaRhVWYQY4ujEOpoWJZuRHUXbzJYwTY86+f+l1AWiBCisss3vQu+1+0F4gOfTM9hbx7xkQRloc8QtqkYkXJ9wi/Oh9NlhcywTMdCbgyq2vC0Ktbx8MnBDpi+it0hBriPSfXC1JZjqz80cYvqKm5Yrmh4uoHD5tH1BSC2BWN2u63doLpGau6dB/gw7JikD6k6xme405QkdITglrtLs
 /hc7UDa8
 Rt2vL77lVOFkps+6wYe1KM6hNXG7cGUMdQJ/QkunXfyZkXzL0YPtTC5QeeW/jMiOg7jJziI0xuHpRfhnl3xvlDxrxsXM1wzaKCSEr8YWfbk0bI2yC3ONwej202gTXjWE/GviQ22fsOvG3rMAMiOStMFMlbTIq+yB70LXtp4/PwcYG9sMnrjBILKbLW2oGeDZk+tuKDqa5itnZWVogT8hT+ajC+Wgbzb98p9RLupTKQt3pI94YLlZa5bGS7xcMbA2jP8UxjLIgRM7fpronFQ2wqmoDeaW9c9hYTFX2M0chlyhcJx4hLgL5dzTaqcIgGMFgsSDiDjA+FJ1sQX9CHtmpC760XfoRqPSM5wdN0JIWlNELJBoQAp+STWKu4dl+JsPBPR0D6U0ig4vVIPTmut4u8skQtxLpoa8IBum3lyBpptt8u+91VKFLH+mp/e2/6o23AYe0sgZpnYEW2lujN8ObNQAc+rw1ObXJv2p2LHKVqU/0LLiEDuiHP9sDGgcBOMqv2Xdv0e7MBmyFxFe5JlOoyGofEeEQ1ZNcbd37dj/qXtZ/p078iCEuUSCoxR5Iilxz+WAJenI4oZWnGZcgde0aVpVsDATSE3lDhYdL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are some gfp flags that are not supported by vmalloc.
vmalloc has been trying to handle these by clearing and setting flags
wherever necessary. This is messy and makes the code harder to
understand, when we could simply check for these unsupported flags
immediately.

Define a helper mask and function telling callers they have passed in
invalid flags, and clear those unsupported vmalloc flags.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/vmalloc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0832f944544c..b86c36d51833 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3911,6 +3911,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	return NULL;
 }
 
+#define GFP_VMALLOC_BUG_MASK (__GFP_COMP|__GFP_RETRY_MAYFAIL|\
+			      ~__GFP_BITS_MASK)
+static gfp_t vmalloc_fix_flags(gfp_t flags)
+{
+	gfp_t invalid_mask = flags & GFP_VMALLOC_BUG_MASK;
+
+	flags &= ~GFP_VMALLOC_BUG_MASK;
+	pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+			invalid_mask, &invalid_mask, flags, &flags);
+	dump_stack();
+
+	return flags;
+}
+
 /**
  * __vmalloc_node_range - allocate virtually contiguous memory
  * @size:		  allocation size
@@ -3961,6 +3975,9 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		return NULL;
 	}
 
+	if (unlikely(gfp_mask & GFP_VMALLOC_BUG_MASK))
+		gfp_mask = vmalloc_fix_flags(gfp_mask);
+
 	if (vmap_allow_huge && (vm_flags & VM_ALLOW_HUGE_VMAP)) {
 		/*
 		 * Try huge pages. Only try for PAGE_KERNEL allocations,
-- 
2.51.1


