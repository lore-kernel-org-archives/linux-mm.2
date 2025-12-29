Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6239E92724
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 14:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04F236B008C; Mon, 29 Dec 2025 09:13:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022B56B0092; Mon, 29 Dec 2025 09:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E918F6B0093; Mon, 29 Dec 2025 09:13:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D79106B008C
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:13:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0902141335
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:13:35 +0000 (UTC)
X-FDA: 84272701590.19.E53B71E
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id E08C3180002
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:13:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf06.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767017614; a=rsa-sha256;
	cv=none;
	b=sCsyyEmZx5Rq3qYA+4eJcVTGj9fJNwd2TifUdwygUGIc4itMXZQ2Xz/QRO/GXJa0LKc1f0
	pNnI+j0mCWiXG6B97lsTTl2+aRs6EThitVeOO8PBYMd1UMrC3pGkY2jrTE7CtKCGS8vjvg
	j2PansycNmSPAPyNKK3Bl7WbFvOUlVg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf06.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767017613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K2pBV4vyT2c4GBUcrUp/G3rP2JcNWZOiRH8LtGLdyis=;
	b=iKke4blnDI7mf0/JURUFfc35GVeYigDK+j1byL4OJf8ScLvwHpXceRPjy1zzuGqRcLlpj4
	gt36+cxf3UY+lBNqTZP8LBkw0Yt8r4PSI1Xz1DQ29VCMAWWV1siJ3UjxWumPicPobSFcUg
	BiK/3bAbhMmZOblev3I/7qCsuBajhLE=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so9486783b3a.1
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:13:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767017613; x=1767622413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K2pBV4vyT2c4GBUcrUp/G3rP2JcNWZOiRH8LtGLdyis=;
        b=MDqgmulkJ+e1R1eD1ABXVDVlBzIrVc6mc9R5+mDJ+zbrOyoAfP0TetOeCis3WXTT8t
         lI96tFX8c/ZC5cCfcgoVQo17s1o8lM0pw5aVAOAYHSziVybq8RU3F/Lk+49dhL+eig7U
         WPGK3q1avLE1S3QW1qVnzkapoYnmT0FYhjdI+dZSRbKYxS9xRVGhRUP7xUz3C+Ik5kcs
         XsfAlwJVd3vA4tOXmk/G8rIrx5TpC6RpHavVKyEMlXBAqjzFm6HlN5AGgO2O3a1cxnfX
         YLDeojgUbw462XFEesxwagMk5zMv4gEep+3Ziq9x/mEMuAKoiejqsnoVhdDiOhXJPOv5
         dMmw==
X-Forwarded-Encrypted: i=1; AJvYcCWKzS3MfbT4+jr6je0tfCgFExD2wKQqDV0bfIuQp0/KqFDp+L/L9iSd784/poK2dNE8Eav8DfGCcw==@kvack.org
X-Gm-Message-State: AOJu0YzRk6PXJB6aNUFcRQHbHPci4b+KWh0uuRajsETpSWjhNnXfk1jp
	ap5U0mNt5s/I6R2i47qOOw7InSeyXvZbHujs6r6b+/yElJn3f9xikcCK
X-Gm-Gg: AY/fxX4aGGWGGb5mOWl4KN4RiYpldiMBay1kcbUXVPDHiHxCtW2EZlZksnyXVMKDzWW
	XAtP+2+5Yca954/Mmns18JsSbo3zDcA5Igokn3iPSrLabE4s2jPJJacY4eumT00UXfICewGP3r8
	l+tijNx5a/JQfx5KhTjakuoR4hw7Obb9SknIHeODNTUc7KWWyPoAwEKMaN1i39kXf88kBioqmod
	gutwr6F4HZx3cBztChZPnhIZ1SKMvCFGjTCzvBIW2XaDgMb6ZfR6/T+fTNDlgITp578iF8MMQ67
	M2GS0bN+FutneR1jN/Q8+Vi7tiW13p4BZ1+qYn2F4kXnHxcfWk3X+lu58zN4acQBD1bx4GIoZdV
	aYXA+E1zErPieLyged4Rg5zk4nal+AcbznXBz+f0UGymNu+kjJl/2MRCJg24jCqVfVFI9o59fmY
	sBzHtkiBGAYQNp5AyV9I8F
X-Google-Smtp-Source: AGHT+IEQcka9ib1s/U4Ml1PaEUtFGR87vhYFW2tWQf/4rd0WuelWAoKlS5mhRUJT7d3+jGEwNTk6bw==
X-Received: by 2002:a05:6a00:450c:b0:7e8:4398:b373 with SMTP id d2e1a72fcca58-7ff66d5f557mr25343417b3a.70.1767017612759;
        Mon, 29 Dec 2025 06:13:32 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([103.88.46.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a93ab3csm29472636b3a.7.2025.12.29.06.13.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:13:32 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v1 3/3] mm: embed TLB flush IPI check in tlb_remove_table_sync_one()
Date: Mon, 29 Dec 2025 22:12:45 +0800
Message-ID: <20251229141246.63435-4-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251229141246.63435-1-lance.yang@linux.dev>
References: <20251229141246.63435-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E08C3180002
X-Stat-Signature: rhapfknoymjinire5kje4iqgfosh8jag
X-HE-Tag: 1767017613-108547
X-HE-Meta: U2FsdGVkX1+5/Mnh5nE/kfVOtEzzJxC1F2+Nxzq50SWxJjZXMev3GRla9ElRYgpjJpfjSOfNfv/jco5QN+iaeuPJi9H5GfHalhvn3qCV+ySECHEnu7+wFj1q6WURUSdS6wfPynO7nIuQeQi0842JOqpSeubFzRkf9eJp1X32SS9zBb9E47OEDqYJRGl4fx1EHZIL/7gDgnfnrozxtv6RGuW9H3hiWo1fJHsdkPywf1+SxVw0k8/sJWfO+0ubyrnS6PEvHb53Lu6rAOopJ8+9nNcQakR+PSVW6HMO72ta1H4dvcygk+0FKw+BYjxd4jWF79kRhTsr8kgqKynJt5Kf91npPP6UAv/exWRUFhDJo22OUWaSku+nqLCKgTFq5zWSVgvK4iSTo5abm+z7H18TuxyVfwltKcdTEfRGyHxtwf2aguVqs4Bxru9vbnw65jewqSjHfdkJYVJj+38Dhpk9Ek6ocCi7XeEFK/k7rggRpX5ofJ1oxgYcZilOtlGtg3Y0SWKawROs7Ug4fREQA61VJQTZqNT9deP+KiVOFYhwyxWIBvbP9+HvBtHXQwpYHRBpcJXWBwuAGFLhB0eV+0FRDQOD3vYr3LX2DKdp3RIZrgz7fOpXHfYPecJXrGucAnJ5Pg9mcnH0jtb+6UQLMuXXSu5leMGMdfYvx4jTubLD7AS+VaOLi3ZRzwJgtS6NsKHZmMmamMYfT8NJ92I+5PsXHzbc7+HA9wVb/8h8RFAiCXcNVNyJvgS7TG1kcT5eIrKxNyrU96aHsLUMQQST2wCeDsnq96cIAq3IovVrsYhGD3YTjMS44M8C/z7wBBAdvmXrE4PVSU9lySk4nQ/2ydDFJojrLim6x8XOVJkdGam0CpJVqsFsandiwkkGh4K5mybMtheH/PdyAROoNhSAgjgNLR2fYUm/A7Ogw54H6/+cy6XSjjQaZ+v6PLHFvi+1dHs1oolKq+UCUZ4TDrPHg5M
 3R9jKUu7
 FdlVYYQmQWzxy827g5GbJf3B+y2lUkTBFP2ABvhwwEsT6VT2dpzICkiPQT5ujpl7w4kJt4marv5w+1eyaZ3Zp708IO6AOJZjxGes177hrQT3IiSPR4KoaZPpz3J2Bb0joc9e59okgNOfaWtimUMptDZE15rvLk32QZ88fgrQl3GnNq07GEn57qGN9PZ1d+5cm0qWYNp6Rqbd8XbalBuy/yer32YUJyRG1kC/mMgWDveKrBy+Py2L9lA4XGkSfo2cFTrBGo6Hq6AoDk1in/miQdKsBfGjVGg7sOfxjs8LfJ/wSGNrCBQCfwTZoeLSnDwpZTgLgWDJLd+QMsJO5PLNCyBOjIbp89yuPPS/MivDAaoHxyRKqXrycj2ogvsfZU6gYLYlabfgi1iCmKkEb4JdOsnoK/Mt0MYm2Oq3zYjYN+v8BGarP5v/AL7R+ag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Embed the tlb_table_flush_implies_ipi_broadcast() check directly inside
tlb_remove_table_sync_one() instead of requiring every caller to check
it explicitly. This relies on callers to do the right thing: flush with
freed_tables=true or unshared_tables=true beforehand.

All existing callers satisfy this requirement:

1. mm/khugepaged.c:1188 (collapse_huge_page):

   pmdp_collapse_flush(vma, address, pmd)
   -> flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE)
      -> flush_tlb_mm_range(mm, ..., freed_tables = true)
         -> flush_tlb_multi(mm_cpumask(mm), info)

   So freed_tables=true before calling tlb_remove_table_sync_one().

2. include/asm-generic/tlb.h:861 (tlb_flush_unshared_tables):

   tlb_flush_mmu_tlbonly(tlb)
   -> tlb_flush(tlb)
      -> flush_tlb_mm_range(mm, ..., unshared_tables = true)
         -> flush_tlb_multi(mm_cpumask(mm), info)

   unshared_tables=true (equivalent to freed_tables for sending IPIs).

3. mm/mmu_gather.c:341 (__tlb_remove_table_one):

   When we can't allocate a batch page in tlb_remove_table(), we do:

   tlb_table_invalidate(tlb)
   -> tlb_flush_mmu_tlbonly(tlb)
      -> flush_tlb_mm_range(mm, ..., freed_tables = true)
         -> flush_tlb_multi(mm_cpumask(mm), info)

   Then:
   tlb_remove_table_one(table)
   -> __tlb_remove_table_one(table) // if !CONFIG_PT_RECLAIM
      -> tlb_remove_table_sync_one()

   freed_tables=true, and this should work too.

   Why is tlb->freed_tables guaranteed? Because callers like
   pte_free_tlb() (via free_pte_range) set freed_tables=true before
   calling __pte_free_tlb(), which then calls tlb_remove_table().
   We cannot free page tables without freed_tables=true.

   Note that tlb_remove_table_sync_one() was a NOP on bare metal x86
   (CONFIG_MMU_GATHER_RCU_TABLE_FREE=n) before commit a37259732a7d
   ("x86/mm: Make MMU_GATHER_RCU_TABLE_FREE unconditional").

4-5. mm/khugepaged.c:1683,1819 (pmdp_get_lockless_sync macro):

   Same as #1. These also use pmdp_collapse_flush() beforehand.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/mmu_gather.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 7468ec388455..7b588643cbae 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -276,6 +276,10 @@ static void tlb_remove_table_smp_sync(void *arg)
 
 void tlb_remove_table_sync_one(void)
 {
+	/* Skip the IPI if the TLB flush already synchronized with other CPUs. */
+	if (tlb_table_flush_implies_ipi_broadcast())
+		return;
+
 	/*
 	 * This isn't an RCU grace period and hence the page-tables cannot be
 	 * assumed to be actually RCU-freed.
-- 
2.49.0


