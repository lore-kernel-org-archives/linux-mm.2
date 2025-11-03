Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 938C9CCFA04
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE828E005D; Mon,  3 Nov 2025 13:02:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696A58E0057; Mon,  3 Nov 2025 13:02:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D35A8E005D; Mon,  3 Nov 2025 13:02:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 386448E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:02:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F1F671A02A7
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:02:45 +0000 (UTC)
X-FDA: 84070066290.02.058657C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5615620005
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:02:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CP85rxHj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762192964; a=rsa-sha256;
	cv=none;
	b=Lm8QyPnkIwvlSr7LqBQbZb26hMlm9rOrHsGaJ9iW6Ds23nbKfscQunTpA+lbMmm902wruK
	kU/qni3xwTyb3CS/D3SuTv5S+ZFCua4xPwcDh+eIXnslpexP+8jdgKAkr8sad/Fu/hzn5i
	TObkGcSsMr9iZCBe65AGm+DCEAZceXM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CP85rxHj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762192964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8b6TjRMt+dyAXz7YM2WBrHqiTyR0VEpvl9wTYXPD+M=;
	b=F76XjOPEk4KS1D3PzhWBf3KQG5JSx993MUesgju7sDUnhRZfXM4zC28zuwL3YtCQdO2IoE
	YxwqvWtYjeyiQ6U/xYqQS0R82IUjPGG8maHjQ2oxn1S+lJCPd+Rbue5rsUQWn7CwlT909q
	fb7bqZZ6BrN4CWLax0C6W0cGNIFGorg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6ADA143D2E;
	Mon,  3 Nov 2025 18:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FBBC16AAE;
	Mon,  3 Nov 2025 18:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762192963;
	bh=BW3nIFF3ejh4ARubY8O9vgvGP+ux/Zl54hpiB5TaeKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CP85rxHj43C1QmClK8ydP/bgZqswAFc42oKCQ54TrICWgUj7GK2OkmKpGHZLFDuuv
	 14CnmrqrWsbN0Tc2NEsq4z4VD1Smh+jmRndB98xJzaJ6Hrqaq3a2QBhNTBQC0vbi2d
	 9KCzSphtvVWw5jHiwPGcYSxyw9awUJOT/B9B4ruG98mvH8AW6c03H7qnUZGiPc+YsJ
	 K5Uw1ebrjxDlVFP5DYUcL5niMxwv5foGeTmX3JjUh+7YKh06RG1SbV75BqgHSvdX7P
	 o2JO+UpEXblcyaVwJdlve7y55XjhQER/XqgbzXiSDlx9hmbknSJSiEh7O/750ReEi7
	 +rrOUX2DFlXIQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kho: fix unpreservation of higher-order vmalloc preservations
Date: Mon,  3 Nov 2025 19:02:31 +0100
Message-ID: <20251103180235.71409-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251103180235.71409-1-pratyush@kernel.org>
References: <20251103180235.71409-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5615620005
X-Stat-Signature: dgsns8t48e58jscz8ms4bsshq3m365tg
X-Rspam-User: 
X-HE-Tag: 1762192964-664510
X-HE-Meta: U2FsdGVkX1+WGrVRPrrWjaxv+CfmDpLV3Csu5iFziGskx25jt2kbNgJ/FYHjCiR1CaM3WolmCXOXQPySq6YQi5do11Ni2qRZEjhlwp634pPQXLfEI87hqGFR0TLleNr84qg8069LA/bMKm14tvTXxUjYkn+Wm0rYHd9BLz3n3lpMNrJfHKheU9kdPu0DyyoHsQYIxYOmsqMOD4ePRtfKFump3VvtssG8W2pmnIYP72wu7JqWEli7u9k5hxXH2zHSgaxXDU1Fu50UUfTR3rlvIhp019DGqw4cD1AH6fXlT9j4lbON8ZaZ9js6OnAWWBQAbDZ3VDuXym9psYbo9mrtKGjm7v978cKfktbaGdYvY1q2Ik8mORfzal0yfWeor7zKOXOfuRo8FrdEjQ1mQ2EYMVgcD+VBtcqPwFfC5hBAlYfgwbzpnks6Ya55j2rJ2LuJtXvQdX/vGduWHBjuFjAFjTJb8Maspt0PRhLOLPnvBnQDbgGigrIL+nDa9mbv6piQcxH0Acy53AEey+luOOR5/QFSOtn//57Ow7zwAoTEST9sPy6LjagSnN0rKI1K13hwv+3iT5fH/UhR8jReHZVK6UZYeLvFwYabUf1/Cld/Z3bGAf78AFuBr+MmZcZJZyPCVLtySZHZyZ5vgNK1/9rkft54a7wGPd+ino/qCnN5iDWuyXWEDYdBrAFq2x8e/2uwakc/b77mcykLkehmeZKldfODDJmO0g5vxmr3DZFY+Y1ifZtJiPsW3XUxyfl2LuZsQMdgj6dLrrDd0IAqeoA6D3+Pph/mhcjAqYYSilg0zYNmuzFhQOdFVPBnlBN9FJGga8hGGV+MDweWDs9xh3EBHsztzwimTe17Jqo9X/qZDzgcL5A3RW9GPtiW0K7apALEz2CKLAtgZV7mJqK0IZoln6z99qav5BJTtk2VuYNTAttZEtg6hdPus9+d52kP4949u6/+ZkDuSwKaWpd0eBc
 BpoBC1h3
 tUvoBXmzN7vQ5J5yaIBP63RWSGATcSBjBVT03cAu1ei5KFtE+5pYbNPcFFBoldeXg0V2bKtIK6b1yBmfGJTKcZvJ3Hv5o3AZCCumHPuwChTedm5o+6BOhV/NQVZNGLs7mteo7xRAHMgFhqs5mrA1Ce7Vsya55AYKIYqMcwTMcsvmTSnOhYE4m5rmpGRMZ8lj15X/xx5BioEl5pXGDpmedn2vF0GePHkdaMxNSIeF2HV4lq4b923Vxg4GztXjh85nmGT98pFV4Abetwfd7V9+7O48npyxzzXKKLyWF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kho_vmalloc_unpreserve_chunk() calls __kho_unpreserve() with end_pfn as
pfn + 1. This happens to work for 0-order pages, but leaks higher order
pages.

For example, say order 2 pages back the allocation. During preservation,
they get preserved in the order 2 bitmaps, but
kho_vmalloc_unpreserve_chunk() would try to unpreserve them from the
order 0 bitmaps, which should not have these bits set anyway, leaving
the order 2 bitmaps untouched. This results in the pages being carried
over to the next kernel. Nothing will free those pages in the next boot,
leaking them.

Fix this by taking the order into account when calculating the end PFN
for __kho_unpreserve().

Fixes: a667300bd53f2 ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---

Notes:
    When Pasha's patch [0] to add kho_unpreserve_pages() is merged, maybe it
    would be a better idea to use kho_unpreserve_pages() here? But that is
    something for later I suppose.
    
    [0] https://lore.kernel.org/linux-mm/20251101142325.1326536-4-pasha.tatashin@soleen.com/

 kernel/kexec_handover.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index cc5aaa738bc50..c2bcbb10918ce 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -862,7 +862,8 @@ static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur
 	return NULL;
 }
 
-static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk)
+static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk,
+					 unsigned short order)
 {
 	struct kho_mem_track *track = &kho_out.ser.track;
 	unsigned long pfn = PHYS_PFN(virt_to_phys(chunk));
@@ -871,7 +872,7 @@ static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk)
 
 	for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
 		pfn = PHYS_PFN(chunk->phys[i]);
-		__kho_unpreserve(track, pfn, pfn + 1);
+		__kho_unpreserve(track, pfn, pfn + (1 << order));
 	}
 }
 
@@ -882,7 +883,7 @@ static void kho_vmalloc_free_chunks(struct kho_vmalloc *kho_vmalloc)
 	while (chunk) {
 		struct kho_vmalloc_chunk *tmp = chunk;
 
-		kho_vmalloc_unpreserve_chunk(chunk);
+		kho_vmalloc_unpreserve_chunk(chunk, kho_vmalloc->order);
 
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
 		free_page((unsigned long)tmp);
-- 
2.47.3


