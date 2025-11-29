Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B439CD116EA
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 03:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC746B0011; Fri, 28 Nov 2025 22:37:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AE3D6B0012; Fri, 28 Nov 2025 22:37:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4546B0023; Fri, 28 Nov 2025 22:37:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 47E8F6B0011
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 22:37:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA690C075B
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 03:37:31 +0000 (UTC)
X-FDA: 84162234702.27.8AA6C4F
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id E692BA0005
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 03:37:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=RM2AAmHb;
	spf=none (imf25.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764387450;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpznAaRjUo2w7LZxf6lAxjAHm9eksDcdz1NUq6/1gPM=;
	b=2SyuKywfz/3fCEdo4M2QeDrzRAW8P1MRwWv2nBaojPnRYYW67K0vAjM3rntACmOPo0JJhS
	HKdiyb9Yb3jv5kFomgUFC3BQSB3GN2R10CKhVlYUOgc3hHKvSg89z7LAVMajYjxESkFwbg
	Zcjl2MvykVtu8ZsqjKlYL3P10/eN/A8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764387450; a=rsa-sha256;
	cv=none;
	b=MtJCs3Nc0hS6vcJwpfxuj6l6hQ7bvVf6mXPOD0Fgq6wSpXpsdfA7Bvy+Ckmw0h0TNpoOw4
	Z3pYtKdY6xOCN71N9bel7QCbBe0LqTTK9kCvxIyvfPxuZnXzn1vhh3GaMNqoLTjqAVDjId
	4FYPgoIFNvTHFngPetfPUSH1NMyS6nM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=RM2AAmHb;
	spf=none (imf25.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=DpznAaRjUo2w7LZxf6lAxjAHm9eksDcdz1NUq6/1gPM=; b=RM2AAmHbiWWjdBAvIAJPpFqKzC
	w+Imm2LS97uAx/g//eMP3HpFYUydE6Y+w3JM2a8/zUe++dKTeDANZDiDhhpz9RQhopbF5FS4u59BP
	PE1d3GCCezRATySQWYeccgXjEG2ISRJhV3jEJRAJQYUiOg1uEdQI1PcGSSQoXR3sE3gEGjYo6X1b0
	ZZAydgZNX+ONMdWvNoVHkaZNl6k/IZqlWnoW2ttA3YJ+Rq3v6tUpaDiuCU6m1/7ylKfhX+vhWnevn
	rwQhQ8i4Asi+235RfCe1TE0fqCW9cuyaCfk0NCspPUUaeA0kvHilMf+ySBiCfQyouT10czoJRpVrE
	xFYsYKig==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPBm4-000000008wo-3AES;
	Sat, 29 Nov 2025 03:37:28 +0000
Date: Sat, 29 Nov 2025 03:37:28 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: torvalds@linux-foundation.org, jack@suse.com, brauner@kernel.org,
	hch@lst.de, akpm@linux-foundation.org, linux@armlinux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	yangerkun@huawei.com, wangkefeng.wang@huawei.com,
	pangliyuan1@huawei.com, xieyuanbin1@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
Message-ID: <20251129033728.GH3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126185545.GC3538@ZenIV>
 <c375dd22-8b46-404b-b0c2-815dbd4c5ec8@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c375dd22-8b46-404b-b0c2-815dbd4c5ec8@huaweicloud.com>
X-Rspamd-Queue-Id: E692BA0005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: dnjo3k9pkx81k14fap4xuuc69nn1rdrf
X-HE-Tag: 1764387449-491693
X-HE-Meta: U2FsdGVkX1+XGPW8tXKDcW+unzo8uh6KLCEu55G/Gr4KtTJcUrM7ExvH2rVHJsbOPKqwO1E+fxZpdf4BzF3dzRRDfzEMnj0DdnSUPLOLeUkBNjoI0W+qvuryKfPaAuh0XYkHuzg35f9oMzFLJfudRJ8xPleWcxXxBPeldOmRGsCugg7mtuc9YmX9UnSFMvPgeKaUqOSiExNtpFivQfWMoiqmWkoi0vJ+hmFVGFoC6bd73Zp1GvOcOPoMcL/DwKBIakN0sZ64x0UclKI9pfmrbdLBEbyffvWr/4Ksy40oXue/DjaFKO2mdw9OAn/DqoQlvdCBtQwjffDDdAcNZSYkHxMSyUQdAVRxfN2UFKelHKcWLaOsOMVHPkJMSgYqezYwRNgeTK/csdB/oDwkZwWnPZucBGJSaibjE0fONkQm5rtH3RTwREG+xnkTmPW9W2YWeGDBqzF4lDDvvfIxK0JgUqK1SSuEv1fe7wtcG/v+uwv0zaHIVftnTzdDT95xsYxkpt63WTsF6Ri1EwRBPX6iKCvnrzVKoxq2TtNXkfk6ultYGivLgmZQMYfvdabhJmoMgI65LT7Qt0oy2X8EyGh69raqHHnGZF86aboe5PGrdJ3xv0CmrxA3zJfG1ikIekIwaR8qJno+VDNzCllG0hewbC+rlxnV2+7bOr4hFOBIpwsvSvhBP0M7/VGYGxuZGlUfhWcwriVDDbP8eAak+wSCU66qR1w2pXVTppjgBnWINFyQV5TL8bMpJoVW6oVmPgsHIEA7Mz63tqmlZnMipa8AmX8Nse/DvvFzCK41QllMUMUHqSFzNHu2lLvwKFEiBXgiM910L/7VBZ1jdCkEGKMjBe09W8bp3w+bjYR/0SEMOnNinNrRep9UWpMV7QSWDLY/u0ly77j+aemtrogZHPuQu9p3OvADtDKQOWOez0W4cajLwsMlr8AqsyBR0t4lfggfkqlQVb9WjxzH6tD03EH
 dKYFgSjQ
 2NK4paMwDbI+Aeuv60LHEmmNKoyZN1nOpTi+yGtJMU8NEBEecDzsZUHTLnKVxIafAjzYGmn/fsB/tE53hO9kUE6cuqviRir4/3zUVF76qIAMuljQK6mkN7uyjriMl8+/ragPc2tPuBZkDs3QBSCITpEZydED7G3l/XK4ypCG8Y+8N9Jo/0t6Pa1XmZdbljXNFF59dch9fhEuwpHeXVChtqFKwmXY5oN5aWFnM9zqQB7ZilG5X1Rq7CXBP2f41F2+NaavXXGQt8bYD2+ZwHeAElFwrrQuV2WHRi9y+rgL2Tyh/wptrMM7KGEdD4p0edZzJnG9ygAhemwvsRQLSJnHGJW5IC6Ko8tU00RUhtiC3iZOXM7P8MZYuky19TNZ+x8Q6EjqYgLfSSQAmAxukf1gbJ11gwqdDw7WYg/gbHZaz21+hUewex512JYVn0S09UCy9u3GXr5rSfQD/gYx2z94FAjyC4cqA64Dxt2/l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 10:24:19AM +0800, Zizhi Wo wrote:

> Why does x86 have special handling in do_kern_addr_fault(), including
> logic for vmalloc faults? For example, on CONFIG_X86_32, it still takes
> the vmalloc_fault path. As noted in the x86 comments, "We can fault-in
> kernel-space virtual memory on-demand"...
> 
> But on arm64, I don’t see similar logic — is there a specific reason
> for this difference? Maybe x86's vmalloc area is mapped lazily, while
> ARM maps it fully during early boot?

x86 MMU uses the same register for kernel and userland top-level page
tables; arm64 MMU has separate page tables for those - TTBR0 and TTBR1
point to the table to be used for translation, depending upon the bit
55 of virtual address.

vmalloc works with page table of init_mm (see pgd_offset_k() uses in
there).  On arm64 that's it - TTBR1 is set to that and it stays that way,
so access to vmalloc'ed area will do the right thing.

On 32bit x86 you need to propagate the change into top-level page tables
of every thread.  That's what arch_sync_kernel_mappings() is for; look for
the calls in mm/vmalloc.c and see the discussion of race in the comment in
front of x86 vmalloc_fault().  Nothing of that sort is needed of arm64,
since all threads are using the same page table for kernel part of the
address space.

The reason why 64bit x86 doesn't need to bother is different - there we
fill all relevant top-level page table slots in preallocate_vmalloc_pages()
before any additional threads could be created.  The pointers in those
slots are not going to change and they will be propagated to all subsequent
threads by pgd_alloc(), so the page tables actually modified by vmalloc()
are shared by all threads.

AFAICS, 32bit arm is similar to 32bit x86 in that respect; propagation
is lazier, though - there arch_sync_kernel_mappings() bumps a counter
in init_mm and context switches use that to check if propagation needs
to be done.  No idea how well does that work on vfree() side of things -
hadn't looked into that rabbit hole...

