Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90E24F3026E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 15:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4D86B0095; Sun, 15 Mar 2026 11:16:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7CB76B0096; Sun, 15 Mar 2026 11:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88AA6B0098; Sun, 15 Mar 2026 11:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 968CF6B0095
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 11:16:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B40E35CDB2
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 15:16:34 +0000 (UTC)
X-FDA: 84548649108.28.330AEC2
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf08.hostedemail.com (Postfix) with ESMTP id AD2C3160005
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 15:16:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EwAlJNi3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773587793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFUEeOE40dUbmpNmOseZzqA/dkA/x7XhqP12l7OJCEw=;
	b=0viTgH4UvgLyCNRA90R5+7hj1MdlQBS+dUoUFRjqkE+Q99bka29gGXkwylvbgSojmk5yPr
	iUjfexU53xUhmQkipH+Lvu9zrWYE9jlvPAcPAI08PfA+Me09NvW47o85q5vxP4YTo8onEa
	NKCZBzSkivGzBdwK+kwBSdSiAutQcD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773587793; a=rsa-sha256;
	cv=none;
	b=r/Rh/b193r+ah8GqHIiLn+M7+7vXN049hXQOm3EOQWJoQl642HLsiOKif+fwOT9WS5UJ7u
	jUXMa76BH8yORNiv2u9AUaI7tf3+mbvSkwWfxcoryo36+OPz1EYpVk+OPt3YEGsXlkWXFG
	R3vMCvljy44fVy+VDP55T5B7SQ5+LbU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EwAlJNi3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773587789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UFUEeOE40dUbmpNmOseZzqA/dkA/x7XhqP12l7OJCEw=;
	b=EwAlJNi3CDgDSDQ/bmR+8tHhWfFADikcQ8X3kT+FZHI6WU8bhvOTcpenGxM4vlz4hg5rCN
	5vgAqxC9F6Xn/PoCQFPwkGplqXe0XtSagqtGRifhfTsbPAkZZ+mwD4kLhBKUo0ZO9xS8gA
	QyUS0VoPam+6VxVSrW5aNhxmZuuiVJo=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jackmanb@google.com,
	jack@suse.cz,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH mm-unstable v3 5/5] mm/khugepaged: unify khugepaged and madv_collapse with collapse_single_pmd()
Date: Sun, 15 Mar 2026 23:16:20 +0800
Message-Id: <20260315151620.30552-1-lance.yang@linux.dev>
In-Reply-To: <20260311211315.450947-6-npache@redhat.com>
References: <20260311211315.450947-6-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AD2C3160005
X-Stat-Signature: f4mu35oubta7k6r6bkyguxcg6bcghd1c
X-Rspam-User: 
X-HE-Tag: 1773587792-581037
X-HE-Meta: U2FsdGVkX1+Tksja4MnuYJHJMdXbwDTZpYtNL+g/wBcoYCD1hFBwFvI8x5tLaKoHFdMctNfwZozVNDiiCCQSBZxvgBIieC5Uv2wgARrR0TOjusEZVV1TBz0KTPt7T3e0IYS50QXwOd99A+2uOMruQw7nGMkXvTvbxckx0HtvyWJy4MzUCyywXmx2PPrH6xBx8cRN6iUvhsOiuYa2F5qmKXLbS8yCAeaMbBUCaVfCVk31/3Nqq804DZLmXZGk1b13Ws6Ju/DW2tCF8in45GuunDIeQ9BbUV82P2v1qzPbXQNsB861F0nNaa6uenmvUYpYTFGhA8kMM5Ft/IxDUELxaokQW39ALTPJWvbtoELoZmrobZzpCI+/hMfO+oXt9a3z3dal0T4JHMD9BrnolwhikA/m6dxr0gQ6scloq51IdhoUKxgZYrx6PFYmfBKkJRofCdDKVTsazwrpMldJJ2hEj+aczDBnaitNRodWussVZzFNibZuLJr5Zdb0xzFSpXaLcM0phlJtOylmN/Fu2fqcLWQfwRh1oGpNeiqu8DVQ5OJGa8JF7U4p8wH9iRSjLaumLwFUXVfCnxBno96O4G2K+zVontAJIr8U0d19l6qolnOt42N6KGWizH33phk/Vfpk/ZiOwO0c5eeACY6YKECmCsRo31LRoC0v2w0S/TWCkjaBEXCXrR+rCdesbtYZK+lYUsw4DuyJxb8dhiq2o2RXEmGTXb9+043X/ifD8sIkaBSHff7yR91ZkmZCOB4V2XrDhz4FDcPPQnt6cMGUe4MjZrmH/axSGqzdVfosjmnAgpzD1kMbF/AXAhz9SeIyiuNzJWAWOrzt0RRHv641upPa9+82J4ootF6EgZXXDUFR7SqTYt66RWJERQC62eiG03uxj2muc7b/JsiS2lTDESs/VduI2jAOB7YBnzb+I8dVDX4H4SA8htewB1aKlvVzBlfXjrf87p+30XkHNQZQ3+T
 B0IGjyYb
 J0rcFWu1wO+9Hh13rh6XRWaSmlsEU6+uVxgLQqGsWCzry/lJy2G66Ob37DW8p0NDmvqL4MO3jiACNf9r4494J2kQMHpsfmD1//3xaECDgSoEYBe5GPn/8BRaoB9J24WzsNYMIF2Z1VrU/gh3ya+AITwAavNtY8WbSOsQ545z3o2VrA+ZCxaYGRZpZ8KgE4qRJ0cewGmVKnpt3qt5KDCgcIFm8fl6Sunf6PzDQQOHXDI4RbfNwKSh3K9MuRlDMjf6MQ1kJnECzH4/OWCVCvMoEM8Qesw+hWwlOAXAfx5Q4mgms+urqyQrn1PFBf0g6VVWyff3Isc/8R/RKfgdAZ2DQgaVYf9H4c6Hy96iqfDb9RvVEv5ljHl8a1yo7wZA4fDV0uHD+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Mar 11, 2026 at 03:13:15PM -0600, Nico Pache wrote:
>The khugepaged daemon and madvise_collapse have two different
>implementations that do almost the same thing. Create collapse_single_pmd
>to increase code reuse and create an entry point to these two users.
>
>Refactor madvise_collapse and collapse_scan_mm_slot to use the new
>collapse_single_pmd function. This introduces a minor behavioral change
>that is most likely an undiscovered bug. The current implementation of
>khugepaged tests collapse_test_exit_or_disable before calling
>collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
>case. By unifying these two callers madvise_collapse now also performs
>this check. We also modify the return value to be SCAN_ANY_PROCESS which
>properly indicates that this process is no longer valid to operate on.
>
>By moving the madvise_collapse writeback-retry logic into the helper
>function we can also avoid having to revalidate the VMA.
>
>We also guard the khugepaged_pages_collapsed variable to ensure its only
>incremented for khugepaged.
>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---
> mm/khugepaged.c | 120 +++++++++++++++++++++++++-----------------------
> 1 file changed, 63 insertions(+), 57 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 33ae56e313ed..733c4a42c2ce 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -2409,6 +2409,65 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> 	return result;
> }
> 
>+/*
>+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
>+ * the results.
>+ */
>+static enum scan_result collapse_single_pmd(unsigned long addr,
>+		struct vm_area_struct *vma, bool *mmap_locked,
>+		struct collapse_control *cc)
>+{
>+	struct mm_struct *mm = vma->vm_mm;
>+	bool triggered_wb = false;
>+	enum scan_result result;
>+	struct file *file;
>+	pgoff_t pgoff;
>+
>+	if (vma_is_anonymous(vma)) {
>+		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
>+		goto end;
>+	}
>+
>+	file = get_file(vma->vm_file);
>+	pgoff = linear_page_index(vma, addr);
>+
>+	mmap_read_unlock(mm);
>+	*mmap_locked = false;
>+retry:
>+	result = collapse_scan_file(mm, addr, file, pgoff, cc);
>+
>+	/*
>+	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
>+	 * then retry the collapse one time.
>+	 */
>+	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
>+	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
>+		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>+		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>+
>+		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>+		triggered_wb = true;
>+		goto retry;

While the old retry path did go back through hugepage_vma_revalidate(),
the retry itself is not relying on the original VMA remaining unchanged
IIUC.

After dropping mmap_lock, the code still holds a reference to the file,
so no lifetime issue should arise here :)

So, LGTM!
Reviewed-by: Lance Yang <lance.yang@linux.dev>

Cheers,
Lance

