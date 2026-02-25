Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58C95F4BB9F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B941F6B00AE; Wed, 25 Feb 2026 06:05:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68886B00AF; Wed, 25 Feb 2026 06:05:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88236B00B0; Wed, 25 Feb 2026 06:05:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95A236B00AE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:05:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 531D78BFE0
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:19 +0000 (UTC)
X-FDA: 84482697558.23.5903D69
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 747DC80003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f5jQQLOg;
	spf=pass (imf02.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772017517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IYLULRhfZbKBR4o+fRX9v875nH1I/a89WdoHn6t4e60=;
	b=rMsTx1l3ylLd/yCrLVsRJaxi2RWVioMFUfI0UOnwLyPt/xfb7G46tsFnmOp73rU/uefjyM
	Mhs6sm8rMk3tvNGS5vudulLZ8/9QgUc/M4YD7ybIOHQoCfU9OrvvWxFI3Wg9nKVqaqsLFs
	Qsz/9BnvI+elYhNEdvoQk7UTqPBRFTg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772017517; a=rsa-sha256;
	cv=none;
	b=U0basUNgSRWdqOtFdg/5i/6ReaEK04XTdv1dPFtzpL96qHgNjWI5MYiloaI8N8rGHXdkeo
	hxRdw/ytH38d7ka5OiSESGn/S4N9slGwMLjz4hRiyirEe/A8xFIHtWrTA9fEXtz6C7nLd4
	Bna8yDdSthh/2Tb9LhMWNAj6I0vOKy0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f5jQQLOg;
	spf=pass (imf02.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2aae146b604so46026305ad.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772017516; x=1772622316; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYLULRhfZbKBR4o+fRX9v875nH1I/a89WdoHn6t4e60=;
        b=f5jQQLOgKM67CZOBneKwoBZmuYIPbsK/a+WbusVwt5TwLm8gefCTUn33LwbrXrDltm
         02OgCG49rnNGVdeUFp5i01GB4jACmIfAr9gEZTjvnzKVSMiPivf71Tj6A8yA1MQgKm3S
         PZ4twcrCRI85vsunK08PX9luN77Ul/40bH8WEy3T3V6WDpZ1TK3uOv9uQMfWFAHpERhM
         qCk7K/y7vC8pbnuE3LBrCqRL7KcOyFzS+lABNG/mK7yulF/sDbiU9Z9ydeMkma0PSUif
         YCKN1p7A5d3tU4hcNGrXVfSBp8y4nonP5G7LlNXy+SDg+s5fyv6f+80AjRSn2UL+EWYV
         8Ghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772017516; x=1772622316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IYLULRhfZbKBR4o+fRX9v875nH1I/a89WdoHn6t4e60=;
        b=Bx+oNew/ktLdTC7frGzLuyneBfoEluz5WOcBwwE1JlFQ+1PbGYmZaf3QFTcgx3e509
         JqabujNlGGzYYcLGc3yJ2s2pDxxUwe9wcHP/yLEAz2B0La8oRR7zvG/VNf5KPm8v7iq3
         u+5vZBkmd+hQ/lsc1UMm+Qywzdn9Zm5/e9QAiWQKrzM/rhsByu8Eb8lEnMq7j4+8C+AZ
         5qpsweJH87O/OqVO5p5Ym+8CXR1a/kviMGSXvSU5z8FJMMSH9aFSKmnZ3JKjtsh/twuR
         +ZM0uCyOqNnwkavw6kRAwXEaO/SxamD2c9h+384p8tE4LkdjpBUuVJJmkjMkPh2R/u8d
         C8ag==
X-Gm-Message-State: AOJu0YzIKM7Os8tjvx/47aHu02QsdzGHPV9MKWoU86uTCBBZ9hBmXmZQ
	h5FZzZCWPOqjg/C5VwXzF04Au0Vw/+t2rch9vorSGjw/UEsXOeFDrZ5M
X-Gm-Gg: ATEYQzyaQDzLMRNYZ+Lj9NF+7DkVV0qqE9X5NaGY4jU4PLoVYEPliKN83u83MCjYXMh
	0GOKMKSDYpeWzp7E4ZwcHF4gfP2zz1ZkW3qYY5ANxeVOsnK+c5ssSpyQYA4trqUM6Y0mZjrqaMK
	2yMhuxay0BzmAmTPhGv0cI8If3LelwlhUqtmYneuXxf5VwaWjs5dzMv2gc35hrsnlRh+kDJ64bY
	pOKC9/c3W3fbxHFr6YUeWZY/OrDFDI2BRYX0a53nGsmYO5oTKGFtFSApxnlB4J/iksB/vIaYxCZ
	mW5ZnmR+rhBpN9WSu2OJl9DDuURctaydPR/YU2+xxQDmJrqasVMcKbgxFhozE7ywTnVkO9QVbrc
	px0MxKyc1VM3zcEQ5X0RFSvnmQC54Dor392CClZhZ+T/RLroq037sy1RA1p/+eIN5d2jTJwybyS
	u9keZQHycSiqOMQtLZXHOZHU8L1PIyKW4=
X-Received: by 2002:a17:903:41cb:b0:2ad:b957:e7fd with SMTP id d9443c01a7336-2adb957eeacmr39272785ad.50.1772017516378;
        Wed, 25 Feb 2026 03:05:16 -0800 (PST)
Received: from dw-tp.ibmuc.com ([203.81.242.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f9f5sm138365975ad.77.2026.02.25.03.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 03:05:15 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC v1 07/10] powerpc: book3s64: Rename tlbie_va_lpid to tlbie_va_pid_lpid
Date: Wed, 25 Feb 2026 16:34:28 +0530
Message-ID: <465a2aac31f00d395be0d551574de37786ace094.1772013273.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772013273.git.ritesh.list@gmail.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: ncmy7xsryaptuyyywqzpk8xdc3jsacnu
X-Rspamd-Queue-Id: 747DC80003
X-Rspam-User: 
X-HE-Tag: 1772017517-508046
X-HE-Meta: U2FsdGVkX1/fWyTcTQ8HL33SBSz+DnPMMKFqWaQDMlp7uywnzlQMsBYl5NKsEuQKqrrSKvlXTiSa7qaZ24N7mjiCIzSgYpOa0tHIhp5eP8WA7xxKPLy96tB1rX+HSBE62XYnBpKt3ZRZvuk6lOYYgC041uEjqmzGRfAWgm1AG9msZ+6VvtINrIldUDi+UnG5IR6HNi2E2cw8N5i3XgMPplOwsWH6Hasgrt97M/vg4zjQySOlBeaonW700mr91ycHLzx2r/+cNgvyl3yG/S6ssPkW5uO4G6sdtMZj/+n/3nxC38wlPecyO3vXV3aTmeSGMhBmeEZiRUxtMAbAxqMIkRZloOl6jG+4YX0etpNReIUke38+1n1GB/gLw/yLak3+UWrGr5H3qQxAfzLiL9vi8EXLocSkCgkLLvj7KQkW9Xd9+U4sXODsgVYiCSkP8SQPQTvsoX4t1UzpiCzhcYfGdxpdKT0TF497qHynt11M7I70VGXjVGg4LCkjQMQSsucsbnfBencW5S5JLlhE2dx9hEorWjvr1iHY0NpVpy+hMDM+kMS6+lCJog6bJmTvNnRZ3oF8qKihlPR9UwI1SMIQnb1Hd0Ph3LiDJ7ZzKYxVrwRBJESHal1yP3y1vaWTvaQ2HqcRLXp1qrZw7b1/4wgY5CBEkdjlke078WvzBo13gV3Uu5NMaECzUuRXAgC5jcDslGk5lWtJmYuCuCnht8UPotlQgWa0hqTjFoC6Ta/nKRfJZuHGDzdyz7q+d5FItxbJuYx4cjp94MCOF8Atkk7k+O2bPnwwSRDxfUtTgtuIqkzohwhkL6U9rGdQo/ZZNkTMhPpShbepHgEjkADpROO4Q7f3U8Yw16E7ZGD3CSUACE7qBGeerJoPRQkYJzvf/oG8LxLWxfvpo/Ydx5Wpz+MLQpF0oD6PZ+vLNqMkPVDwnZiZYhcYqRFYhdSfcDZM1wcbulleVqjmedFayAhMCEb
 FHWwnJEt
 pcZRcCEU4Hnl+GDmL6KzriSC5mW7JXa+v6d4KWfrfNpF2+Dn3Xh7X8XKSDtFI/i0ZNafteyqDf1heoSer/o2T+KwVZhqJ/fLV9GrPiPbhzviQ4Rx3WYJd1b/9h0Zjzv0v8OyVkxc5XCBMbOKGCxEtHM520ng6KYolQGNIDTvkaUDm7dUhyPqBfHo4RAD/2k9b147hivchL3rRFyQIdQgUsPhdMHEOw8Rfq+RQKk1/hOrW6xArAyof7IpixG4n1vR3T+k0TBPMlZDpJDJ7G9nQJMKPUyVbogZ8Wtmyga1OJON/2dxYNAU8kxb8TG4BW9AxioxPllvK+XDCc5kPmRK99XVJI9KRYtIrZlfMWKpKVuUkMLbduFylGBfg+8d+mk2cuyHE60hoVxBfnUjiWGy0AgfOqPAxtHu0GKlwNV4MB1KrglQgOWCHZ4jzXCywr4DGhEldphEdHrfxdfJtcpP6XzoUz6Aas/JqHpNbOodpDMHoFyg5AvPystG8fk0rB3CU/bb0RauP49Uvk5PRu7xOqOnvk/w4MBbH+TeJQKXpfztNEArTp6LqXaXYwGkZrC17F6+XbQ5rpvgM0m/HYZHXZF9WPEPZS3wW0xUVDib/5xZJhPf4aUnJ+5FQyJ6mcmsrLOsW31choE2bILU5I5BLTykOfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It only make sense to rename these functions, so it's better reflect what
they are supposed to do. For e.g. __tlbie_va_pid_lpid name better reflect
that it is invalidating tlbie using VA, PID and LPID.

No functional change in this patch.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/mm/book3s64/radix_tlb.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
index 339bd276840b..1adf20798ca6 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -1411,7 +1411,7 @@ static __always_inline void __tlbie_pid_lpid(unsigned long pid,
 	trace_tlbie(0, 0, rb, rs, ric, prs, r);
 }
 
-static __always_inline void __tlbie_va_lpid(unsigned long va, unsigned long pid,
+static __always_inline void __tlbie_va_pid_lpid(unsigned long va, unsigned long pid,
 					    unsigned long lpid,
 					    unsigned long ap, unsigned long ric)
 {
@@ -1443,7 +1443,7 @@ static inline void fixup_tlbie_pid_lpid(unsigned long pid, unsigned long lpid)
 
 	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		asm volatile("ptesync" : : : "memory");
-		__tlbie_va_lpid(va, pid, lpid, mmu_get_ap(MMU_PAGE_64K),
+		__tlbie_va_pid_lpid(va, pid, lpid, mmu_get_ap(MMU_PAGE_64K),
 				RIC_FLUSH_TLB);
 	}
 }
@@ -1474,7 +1474,7 @@ static inline void _tlbie_pid_lpid(unsigned long pid, unsigned long lpid,
 	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
 }
 
-static inline void fixup_tlbie_va_range_lpid(unsigned long va,
+static inline void fixup_tlbie_va_range_pid_lpid(unsigned long va,
 					     unsigned long pid,
 					     unsigned long lpid,
 					     unsigned long ap)
@@ -1486,11 +1486,11 @@ static inline void fixup_tlbie_va_range_lpid(unsigned long va,
 
 	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		asm volatile("ptesync" : : : "memory");
-		__tlbie_va_lpid(va, pid, lpid, ap, RIC_FLUSH_TLB);
+		__tlbie_va_pid_lpid(va, pid, lpid, ap, RIC_FLUSH_TLB);
 	}
 }
 
-static inline void __tlbie_va_range_lpid(unsigned long start, unsigned long end,
+static inline void __tlbie_va_range_pid_lpid(unsigned long start, unsigned long end,
 					 unsigned long pid, unsigned long lpid,
 					 unsigned long page_size,
 					 unsigned long psize)
@@ -1499,12 +1499,12 @@ static inline void __tlbie_va_range_lpid(unsigned long start, unsigned long end,
 	unsigned long ap = mmu_get_ap(psize);
 
 	for (addr = start; addr < end; addr += page_size)
-		__tlbie_va_lpid(addr, pid, lpid, ap, RIC_FLUSH_TLB);
+		__tlbie_va_pid_lpid(addr, pid, lpid, ap, RIC_FLUSH_TLB);
 
-	fixup_tlbie_va_range_lpid(addr - page_size, pid, lpid, ap);
+	fixup_tlbie_va_range_pid_lpid(addr - page_size, pid, lpid, ap);
 }
 
-static inline void _tlbie_va_range_lpid(unsigned long start, unsigned long end,
+static inline void _tlbie_va_range_pid_lpid(unsigned long start, unsigned long end,
 					unsigned long pid, unsigned long lpid,
 					unsigned long page_size,
 					unsigned long psize, bool also_pwc)
@@ -1512,7 +1512,7 @@ static inline void _tlbie_va_range_lpid(unsigned long start, unsigned long end,
 	asm volatile("ptesync" : : : "memory");
 	if (also_pwc)
 		__tlbie_pid_lpid(pid, lpid, RIC_FLUSH_PWC);
-	__tlbie_va_range_lpid(start, end, pid, lpid, page_size, psize);
+	__tlbie_va_range_pid_lpid(start, end, pid, lpid, page_size, psize);
 	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
 }
 
@@ -1563,7 +1563,7 @@ void do_h_rpt_invalidate_prt(unsigned long pid, unsigned long lpid,
 			_tlbie_pid_lpid(pid, lpid, RIC_FLUSH_TLB);
 			return;
 		}
-		_tlbie_va_range_lpid(start, end, pid, lpid,
+		_tlbie_va_range_pid_lpid(start, end, pid, lpid,
 				     (1UL << def->shift), psize, false);
 	}
 }
-- 
2.53.0


