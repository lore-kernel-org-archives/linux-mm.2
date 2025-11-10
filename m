Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC64CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A61568E0028; Mon, 10 Nov 2025 11:08:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11258E0003; Mon, 10 Nov 2025 11:08:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9A98E0028; Mon, 10 Nov 2025 11:08:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 721E68E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:08:33 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39A7E1394B7
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:08:33 +0000 (UTC)
X-FDA: 84095180106.08.E67DC7A
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 188D5C000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:08:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RxRpTNpc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762790911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsROCixNOuApxHyZK7gXdF4l+D+ySewC5WOa3I1V+Os=;
	b=A152+ftJyl/Sj8BCHUFNHjJ4uDh5TdR90Upl/4fLWlfYwS17xreb17cxKQdXFGr1RjBo/2
	LPqcCesplzwxQh2X3lFIUuNXCx/w5BAKin3nrU2zECcRda9A6tWqZysbySbFc0l9Rd79Ry
	sQjEv4Yi1KDbJrzeTHS9iaQKeVSs/pw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762790911; a=rsa-sha256;
	cv=none;
	b=qxteBphFqBNvP3c6Dy1SAFdwqC02LiZus5ZPn+ysw6/PbbLOHSuyFd96zHhQiRnadkecV5
	dRK+X1Vk9uDq78N0csaPNPVu1rBuuilF8vYYSwiQrvWxy4TwoL0WezLTjkGRr3D4f2kE12
	ODK4UKAgp/QTFQUB0YOAyvTv8khkaCE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RxRpTNpc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3418ac74bffso2258394a91.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762790910; x=1763395710; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qsROCixNOuApxHyZK7gXdF4l+D+ySewC5WOa3I1V+Os=;
        b=RxRpTNpc+XHfB4uM7yM3b6931eRV+Eu3vBak/rimkahuas5ZNydDkQzyU7i1zIdPzT
         hQeANOBzbDLOpLdz7Ll3l5kNPMfVuSrA6khrKwVLkdDTHSF2D9EwJS4FpWjtn6QOrfcc
         rsys1TLyoD31yC2TwyZmWqmApHuzxVUrcXeCQpc3Pim+WhRyZnSruKxVRyMFY71026EV
         lwM6z00j7xJLjo7JgQ6rNEjT1NFAsH+qhgYo36Qn3EEmbJ65c5dkO21paaE0eLIbfZdC
         07MHAbXKJRzDdX2fLDjKphjd2Rx43Oxk9nG9oltRf1sSeaViE0q3d8/gpzxUzQKBf9JF
         LfRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762790910; x=1763395710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qsROCixNOuApxHyZK7gXdF4l+D+ySewC5WOa3I1V+Os=;
        b=oRBIPlWvKSUwPz68IsDnqUW50ti5QiLWd6RkifvVWfq8HkOuJ6CDLXIdjq7+kPGVgo
         Qj2JM5G4WW7QqAOY702UFPyowZTujQf1kyPjhBTd8VzokZV+AbmvDQQlsl9NDArbGyus
         VIpSNcpq6iNyp/+jPW+qPHAv714G0IU8peUyWIsqraGwjtOFq3aAb+C62klT9Fv/npAA
         pKJwc+ww3/srdzVS9DS9dzuBD4GounC7u4Hf4RJFOPSUuBLa3d3dDYSkSxnakuhKoW2V
         YYnrvlMmb+4jFe8ONsuRihk4cnUEdxySl5Rt93SMiSEtNGlK7U/6pGww1hZaBVevgMN4
         pmkA==
X-Forwarded-Encrypted: i=1; AJvYcCXRvBWG8zZ2UqrNdW8iGktPB0bLeAxPgSD/e8LMvIeELSzrrXdlTXNBNLhzzelo63NFFD+IEFXTXA==@kvack.org
X-Gm-Message-State: AOJu0YzheQ6/rnUqyQ4OmC5G4elSsEk0apTcZ7sxgUSINBRG7KIw+jL1
	nVqZxyLaMvjT+XKBiGHG3FUjXa/8kS7/xAMyCzE9mU16TB16SqeSgIZYcfHiZIjL
X-Gm-Gg: ASbGnct4qhz0jgRq/R7I2AoX/RQwod+ykpzgpuK0A++YmTveUU+I2WmL7sNWOXSGzH/
	bAEws/crgU5Bfpf8NO365DvV5K1b5+tPL41h0CQFWYxsIywTaYT/3nALFHKb3ApDbVA18zYlGmP
	HNiU+3IucSzl9wAt52tWkxNybsJa+KtkSSHd8c/MnGo/htO3l4807FeUq5PWsaIxeEHw7OKLZvL
	BOQrGW1r43zYG00QBHiuBlvOdZYgph3N42RbFmBf7Jps9onlJ8yojrUT7ScuHJjKSpdrfIjxFJd
	FV0qbeAuwKh0/FVaOzRq80dpc/GHxOpHTPID54RxP3GoJAXiJNbdOUm2pe+EDc+kruX1FJH5QQS
	Wr3iOVNPasO6ACOw8c+qg+IWBho+V9ECmHyfBGhMrAcKXfV2CekgQXka31dPhX2tzEsNFYs3ydg
	DRgBV2ntZt2D7LN+WFSO+xGPpHuaB8UgNIIjSTq3387mg=
X-Google-Smtp-Source: AGHT+IE0p9n8dZRGN9vzgSNrFPz/vcuJc13wQOFI6Ed74ktnG3oB8JYFFwon7pTE9YKVzLQLoDtHJg==
X-Received: by 2002:a17:90b:5103:b0:336:bfce:3b48 with SMTP id 98e67ed59e1d1-3436cb8e372mr12915080a91.9.1762790909887;
        Mon, 10 Nov 2025 08:08:29 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-34362f1f231sm9308893a91.10.2025.11.10.08.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:08:29 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Date: Mon, 10 Nov 2025 08:04:54 -0800
Message-ID: <20251110160457.61791-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251110160457.61791-1-vishal.moola@gmail.com>
References: <20251110160457.61791-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i83wyc5ieum1rmndjifqskcca79ocn6s
X-Rspam-User: 
X-Rspamd-Queue-Id: 188D5C000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1762790910-880176
X-HE-Meta: U2FsdGVkX19Hf0zRR9sSEl5LG+iukI6MM0nVpQmIJ8JGRsYalVCMZyasx+3eaCDa84oIe8W/arZzk1FpxwxDQMNpCJiv+39o/O3K4VpLtZjjTJYMkPVRppunwOSFicmZbwytJ3SA/+A6gRHPMoZQRJyFjnJUDnX2VHVyPPCm052TtLCd4iM22t9W5Ng+XR6lVA0SaPwBQwju+TOiNfqLslRSnFQICiCLB8GBAoQ0uDr//SvvohpCJ3vH7+aXe+t2CYb67IVXfQN6vAfBih0Y/MSncYqObNdKofHGYkFhE6MkJRss11E7Z+bEH1TnhduGzs4cj3PMfjuA8bsQVdzJ5FxIiMi46Kxn6c5vZ0kxg+F4D0cbfb3DqJXndAcwRbOALD0xrkTqbdE7ZENZgQi+xtiwzwwf0/02udDQwmcg3iyPVGwy2M4DAuvyByZpSmFxcuf10p7b/cBa5nCguAIkzsMUajZ8x20mqWe6+BijFFgzefBb2uqDd8tqr3KC4rbMgRzI7AwA2Au9hXLznytPsU1bmuoz8yyil+jH8TWBfwpZbWBjJElUkJ6wJ0AS8Em39rANNit7zEohCeAGcroZLe/wjvvbcqhe5hdvJHv6+aO8cDg8WiGkVgWg+BUZG0SuFqp0a3+1Dhp6Vr8BtBPoE2VM4pZUEPAAa2nurY8Rn9u+TH3sn8bHE2STwXvANrKyfjFEl8H9NW4jkqkP5mi2Ha/yRRTL1MBw9meTwU6OfScpsFNuFfdtSh21q7v/mR6hOhBxODtUcIUel8eRBafxhbljjYHdvqCYvdq+USFcTKbKGKPNCp9a9lprUNeHXpuPl+p/P6Y0fz34Sw7H+QW027VfUbuvc/9aIffj619WN1N66seOm6Hbt4PlpfuYvICsnXyGPqVEgrq1LMQQNi7RExHbspIXVFFvZJPeIthONvbnwYMmhu7B5F3lFQynEoc8mpXZt9Q20L0GVpC12ME
 K/p64pAO
 rbKku+VP4biYJcF0HNfMxmSTqK1b9vW85KD/vRM9tC9jrvFk03uZ+kutPCDkVEgNNj3b29IZAfu5TG6il3GKQV5KTJiTH01MHC3PgdLO4uMV9jeITP3/cl+2kFQWYNil96FdQ9Pl7kGRhOzMhWp665ZyjfNwGBoQIfAdwVuxtFYKRJojndFtR8klPiBsdqZ7vUCyYndA0jYua9ckqGGyohdn1ReXN2+werchQeDugiAfJt0NK1K5bkHq+s4lQgnWnQIhb8Iol7x2yxUe3TIOw9KnpTnj3kURrPFQiq6bh3W6nr0TQIQBIehLqn1EY18e5bTh8tN/oV5zdBp8rekxFhLBDwsPTnPtaUYdtbuvtxb8PdIV3DaBRWPgJnmdJA7937QyBZBFa0NWn5V0HGeETqk5dhv4iJZ6hVvhqt10vvVCIObCQqZj8WbDCktzs1cQOuwR01osnmZc972CeKzgpHodGZBwdduHDseSdsDkWDNxf/mvIc9gbvZeyasxxYI2UMJ2mGp8KoRCzL7qC2jTVYNZbSpiKMHAJVrGfY6i53Ts/gLMGaLiGcnk2xBRW1Ozqmpih
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
 mm/vmalloc.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0832f944544c..40d4bdcadb6d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3911,6 +3911,24 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	return NULL;
 }
 
+/*
+ * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
+ * This gfp lists all flags currently passed through vmalloc. Currently,
+ * __GFP_ZERO is used by BFP and __GFP_NORETRY is used by percpu.
+ */
+#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
+				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY)
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
@@ -4092,6 +4110,8 @@ EXPORT_SYMBOL_GPL(__vmalloc_node_noprof);
 
 void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
 {
+	if (unlikely(gfp_mask & ~GFP_VMALLOC_SUPPORTED))
+		gfp_mask = vmalloc_fix_flags(gfp_mask);
 	return __vmalloc_node_noprof(size, 1, gfp_mask, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
@@ -4131,6 +4151,8 @@ EXPORT_SYMBOL(vmalloc_noprof);
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


