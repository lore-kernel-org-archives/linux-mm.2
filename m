Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49383CCFA04
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8608E00B9; Mon,  3 Nov 2025 13:04:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F588E00B8; Mon,  3 Nov 2025 13:04:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F90F8E00B9; Mon,  3 Nov 2025 13:04:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 708A38E00B8
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:04:01 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32E9613A43D
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:04:01 +0000 (UTC)
X-FDA: 84070069482.24.A740480
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4D60D100003
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:03:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=s3J5KePd;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762193039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujCAlHRtnZ3VH1PG4tAmYYBdMy+Y+4wRsZJBrxPwNPM=;
	b=iMsXVs+5/6KCoBYdRGE8y6F2p6btczyERpPnscpnGGkWOP4dFCJE/IzrYVBpqFKntGKk+L
	GzjP8fgE+gIHlk/qm3/dlwVeCkbsaSKDa8UT7/19nMsuaQR1VGVmI2IfjzRNpq4ruinxPx
	v/peYNvMMvHuNZsIKkLjLgzmDZFYUY0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=s3J5KePd;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762193039; a=rsa-sha256;
	cv=none;
	b=peQ8LXo4DgLRhW69J95JAvn3E69acybsrQt7r1vjEUiNzcszg2XrIaPpt2qsTWTmYz6/o/
	KExZBHJgfXOZ/Ji52/WDDqPX7funSoIF3EEjjoL1Ikh8G7XZzY7tc4cMrNJ+RW4KZN7ZdF
	Q2AdnH+Ux6nUub4E1ISWO1Ind6FND6Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ujCAlHRtnZ3VH1PG4tAmYYBdMy+Y+4wRsZJBrxPwNPM=; b=s3J5KePd0QfKcjOZ79qJ8xdoRV
	PJdUor9RF4NOGA9gG5Gkm4dUoqvoajoDGPaxUxmiR4dhnyCE3PVmyVI2kdVl43ugSin/SA6paPBfS
	kCPqKFgZnaYUlXBPAt99nkitbCcNGgAC+yGRURHME6u+NQuOzAuhyyp3Q5ZE6AdFzBRgMalEyhBI6
	s7++GXboyoYZVVk2J4hplXH0ie9I0hGg3Gd83kElM9YvfRDz08/8e+pbXvYE/F2+07xEBL7WhZGT2
	TNmTaKENSIKYk1gZkQenUypuVcrXBXWLOQ2v6uex4Y7MkspmJbctoiUtCy6r49nXr97atTp7zUeJ7
	I0Kh4S9A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vFyuF-0000000E8Rh-15CU;
	Mon, 03 Nov 2025 18:03:51 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Chris Li <chriscli@google.com>
Subject: [PATCH 2/2] mm: Use vma_start_write_killable() in dup_mmap()
Date: Mon,  3 Nov 2025 18:03:46 +0000
Message-ID: <20251103180348.3368668-3-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103180348.3368668-1-willy@infradead.org>
References: <20251103180348.3368668-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D60D100003
X-Stat-Signature: dyb6g59uuopfjkbdojf4hzbnoij7eupn
X-Rspam-User: 
X-HE-Tag: 1762193039-898557
X-HE-Meta: U2FsdGVkX18f1U30KOlyEF6KmwAgUN48lrBJKMEP94zSCTjoSxcm3DZwEdPielYKljwwYa+6oCqDfkvu+2Vjr0Lp28ObxP1hC3JnAtnbHUZuu8kDc0rffKjHPULCFjQDqWr8ONhbigX7bOMPXBSsicc5nNCmUvSq54LOgP4Z02xVNIIS4fGtGOnS6+dgT4rKuXyalHt8DV7lZqHbCjF+us+0gWkCWqyJQDTDRzH/mzGqO4ekHpBo3V1r23D3aYMvPHWjsmOFhgKvSFsjetZCHmM0r+GksUoO7WWSJXGQH7/Br9y1N0LH8OsgOGWINicj8YuPTahbhBuIi0DM5pFIDCShjWC6ZNOzb9Z5f+VbzbeyqS8iHdC6eXjIV0WGK8XJRu5x2v42/l/OG6QweSe+ht3GjOuQikywZbNnzQMVBLSh1CpXmBq2Glf88Rmj/uDMmvaMKr+OCmYUSteTHkB21QEj0e4Le6CrroYFpfcM6xg3/uoPjSyQmLzAsGsLPgVpL9ZkI0NReMvahf3LBQmfekzhXaMCsmX6HjCsH4F6aVp96WijYcNahX9YjGE3PnNSaVE5vUzdZ14QmNfY0KoO4XSAy0j1XHVAhuk9esucXfpy2TjBUSp8ZTnW2AyPauDAOyW3SjcUJ0j0eYYaRZ77/7vrmtu8ukdnqKKMELoRvuAk2SddlurL7czYX0fvgG+mrUkRMB0AvWQheYH0idLwpinztIsOkrr8ssyGhlDLZp2qyoQsRvnWHYPgoaKYjKPnRNMRYcK9T7EvwDu4ypES0ngdLSmIUQJiqmWrr5VZ86u90P9BRoNnRN5B8f0MzhbTL2mLNy0AVNEZ2r8AXcrLLFP8lTsXf9jxhXahC6IQoqMeC0KcGw3Boin6c4o59yR9vOMPJgVj5+CEjczYS2G5D+grN54Ksif7yO32zpCgJUsX6sP8sEvMKvL1RXuzPbqmlPkNXaHsvp5/vxszzb/
 4XjyvprA
 Km0CocgD5/SAnvxwphfVfI2EDPNIehnJzcP/VOQUtnznJLqHj3t7GL/nYHQtfhehcxTy071SpZkLqY7RO0q+uwgpgtYijzCRv/994hTMFYRP3SydBCPCGiKuN2DV9aj0LhCOQG77U3RTUIqYcgK0Kg1hAaWSu2eCG13BoN4m8T4UGYvm59VYTQIE8JBedoMALvlRsBcRaGjBRRgRnjNZtvFG7WJUvz7XL8Nko9rMIzU7XB97KMT6/OTI69VeRhPPyBrIItjy8mltDXoYXAmusqtvZ5ffberT9NPaN13qjd4Wq7OAyOBAxPYMDR0n1QRuklm8GeEo+/SQJWSx5VnHSL0NeBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow waiting for the VMA write lock to be interrupted by fatal signals.
We can remove the explicit check for fatal_signal_pending() as we will
check it during vma_start_write_killable().  This is an improvement as
we will not wait for the reader to finish before checking for signals.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/mmap.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 5fd3b80fda1d..03773fe777b7 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1750,7 +1750,9 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	for_each_vma(vmi, mpnt) {
 		struct file *file;
 
-		vma_start_write(mpnt);
+		retval = vma_start_write_killable(mpnt);
+		if (retval < 0)
+			goto loop_out;
 		if (mpnt->vm_flags & VM_DONTCOPY) {
 			retval = vma_iter_clear_gfp(&vmi, mpnt->vm_start,
 						    mpnt->vm_end, GFP_KERNEL);
@@ -1761,14 +1763,6 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			continue;
 		}
 		charge = 0;
-		/*
-		 * Don't duplicate many vmas if we've been oom-killed (for
-		 * example)
-		 */
-		if (fatal_signal_pending(current)) {
-			retval = -EINTR;
-			goto loop_out;
-		}
 		if (mpnt->vm_flags & VM_ACCOUNT) {
 			unsigned long len = vma_pages(mpnt);
 
-- 
2.47.2


