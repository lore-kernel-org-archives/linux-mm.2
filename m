Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43088606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cwuehG8n
Received: by kanga.kvack.org (Postfix)
	id DD0066B084E; Wed, 21 Oct 2026 22:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32266B0850; Wed, 21 Oct 2026 22:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49766B0851; Wed, 21 Oct 2026 22:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A26C6B084E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:37:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05870120743
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:37:32 +0000 (UTC)
X-FDA: 85348701144.16.0940124
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 79D3FA0007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:37:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwuehG8n;
	spf=pass (imf25.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792636650;
	b=WforLqK2+QbpsoBIaPXcC4SornZm9NVtgyYmb2y59hK6WSPu4cDdgulCPojoPO7421g3yD
	CJ9moduo2UzzaJ/fSBLQrfl2HjKBzsEEvMiY5cUqiWKlgmunJhMtdxev2p6rxktAup/yKS
	HmOdlWeCQpc4Yn0qX6uZZYzU1kqS86Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwuehG8n;
	spf=pass (imf25.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792636650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HE+3rCvUY47UpTl2ZHSutTG/UW4Ug8nC9fT+NbrJFCg=;
	b=N5mIuhHj+LMSy5Nms8QP+iEj+vijunKEHZVCWXOa1mqT+4cazVSOH0tFMDDeLi/12jEkdH
	uzBfP5E4UdkA4mIpBxYDYRVN16fwoS73AK1zWe8zxGbgL26P77S/ObEJob0K4qUq8sFkZz
	vGCLj5DT3Qs/HEQf3zwow3I/C9E96WU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 038A360AAB;
	Thu, 22 Oct 2026 02:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325D61F000C8;
	Thu, 22 Oct 2026 02:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792636649;
	bh=HE+3rCvUY47UpTl2ZHSutTG/UW4Ug8nC9fT+NbrJFCg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=cwuehG8nqKWmnvGciE5SgD1NChwhoKyhe8hO/5bLbdtgMQSD9gOzOacuMpdSdcUXw
	 w8RY7uwhgwnhYOHDDIvulKZjtAHPTeuuITqZtzmBlRY2JD+sbhBwI0uBFVDQ5+Hlxv
	 2sb/ZKQ7jyOH+L43lzkRv01jGrVCAxdacxSDxKHmlcqMEIyhboUqNhp04IrfVjFaot
	 DIdigI8sECfJpdoWEhpAScd6llt+gzcmHSDFYevbbmlV9ak5mDiR3CSo5SHQ7EZf6X
	 M9/cVYgLYdQVyy85ZTZRBsZ/fhJCfVW9faFU8a9D2eZ+sN1clB+n9hekMS+tGoCTLF
	 p7YS7HbM04O+w==
Content-Type: multipart/mixed; boundary="===============7594496370134435936=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <778cae554b4280123e66d54fd1a7a92759259acc26f80e41c8779fce9b268ac7@mail.kernel.org>
In-Reply-To: <20261022015712.1297331-6-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-6-alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next 5/9] uprobes: Don't sleep on mmap_lock under dup_mmap_sem
From: bot+bpf-ci@kernel.org
To: alexei.starovoitov@gmail.com,bpf@vger.kernel.org
Cc: daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,oleg@redhat.com,peterz@infradead.org,mhiramat@kernel.org,jolsa@kernel.org,akpm@linux-foundation.org,liam@infradead.org,ljs@kernel.org,surenb@google.com,david@kernel.org,vbabka@kernel.org,jannh@google.com,hughd@google.com,kees@kernel.org,mingo@redhat.com,tglx@kernel.org,x86@kernel.org,linux-trace-kernel@vger.kernel.org,linux-mm@kvack.org,linux-perf-users@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 22 Oct 2026 02:37:29 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Queue-Id: 79D3FA0007
X-Stat-Signature: 1xkugcrnp77t4oigupiyuumrkr3766g1
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792636650-947872
X-HE-Meta: U2FsdGVkX199aHSbdHGXEnhVlwvvY5zi45yZrcNeu8xjFcNRK+v2CpKURf7pYTvkoxoAP0W9sgxEcRC+YJaoMG4cXBDa8dFngGNjAg2swkCBhnjZghE1U0Djd1ABNz8c5NMP2ZaA6QAtEtczDQZlLewgvtquL39kotSMJUXiVF6X4X9nQV3/hpURm0wsq93tFxFOSkgpuZ/gJT3BIKx+rPERw64JdS8PTaD5kaX9mhiRH3q/0My/1HTsIt4mPfzhAOsBMF/SCiT4qiy4ff8URntR1HY49vTmSdimhDPxC2aGzfcg1el9nY3RNP6CqJ/UccyT5RVNm5UlCmdv9LxJ90Y2jmV2YKlzEEtDq/4MzJ0usFebumAkgdQr86e5GuaBkA566Ei/qN1CLyZLz0hFS7wcqo6IZ0IhVewokGqsW8lgmRDlEZSHA+ocyEjyPHp9DokdOLe20UvW+fux/T0tGsdJoi95GOnNeA12OQ6vPcAASn2vEu/8clCWf8A+4F/alBJXojwo/jM2bHPQ2xgU9vZIumgclT0KAtKlJ4E9zvWFPah1kddz18AXXmxpI487K7eiFTod1htQgCOq919Vag5UkLuq4J0LbRThlliUrv35p6u+AkLUQjXw0BxcWDE3WoafXMoewmCjHaYE7VNFttwZbXbLxXmaITsEmH3etGGxo4YTU0BYkJQ+oZOKxibkDWn8nI9ZgaNnST0YB88diHVROqjJMTiqvnoRgDfK/h9Wf+thsKd8/XSA8u+u3u5pUAabzHBM7BHT9tb5hoDgute/TEJ41U+zvgpeG7CzfLS3kmwDEXzAiNiy6OMHI2F1+ba8QTT2fyEgJsGqQ/sLydn1WdjcnEIXgdpWZ6px3jVaL01UKjmZlO2ISCLSwDQ0brMGldAUFlI+stdbRwZmTmAxW28HOX0LjGrIL6MpX8gzSFDxXNORoOTf2OQBZQpZqNywp/qo8ta+Bus+LJb
 90YNmlCY
 8xMvwC8T+LtDQLycr6h8dAxw8wZSAgav9oSMY/Hb0LLAlX+cD5y75OHByUdbmsNKg4/4NypRHS//sf0bZva0a2pMuFvinyhOLY5jRNnhNqspSo0fr4pyjSZTzorZMdENbqbAj8goa3YALOczuLamoPKSzbD9T7uRZCF8LbNF8jgWsCWQlCADWe5x5a69j/eW9qsUARqGPjLHd9NzqyfeMqXhVL343UvLRq28zmyMLOxCBvwyQX3p6+hUzJ9FOjxSUdeeAQ19G2tHTeNdUwy3uPhSPNTSnFKAd69CE/t3JVfbeL80kPkJy3KZug9VEUQkig5zMYpOSTV+CYehWwj1FlfjnDAoKNmohY5a8dzh6dUhBBsPRMlbpXFww9QnsFkQac4YsRl/sgMOK+npwWVJ4wS1GmvnbmuzenbbZf4GXqe3rXYy7zw1uyCtbiVlyHx54webxA8I/wye1h+xJSyX4185Fk2bjDbdZEYycjPweVfiKkGxxchuzWjh0Ds9cj76fhKNPcnyBZTGHHjlmNJiZky3J1N541ypkN7U5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============7594496370134435936==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> uprobes: Don't sleep on mmap_lock under dup_mmap_sem

TL;DR: Question, possibly not a bug: uprobe_dup_mmap() edits oldmm page tables
inside dup_mmap() before vma_start_write(), so it may race with per-VMA read
lockers (page fault, MADV_DONTNEED); the review suspects it is safe.

> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c

[ ... ]

>  void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm)
>  {
> +	struct uprobe_walk *walk;
> +	struct map_info *info;
> +
> +	list_for_each_entry(walk, &uprobe_walks, list) {
> +		/*
> +		 * fork() that is being killed fails in copy_process().
> +		 * There will be no child. Leave oldmm to the walk.
> +		 */
> +		if (fatal_signal_pending(current))
> +			break;
> +		for (info = walk->busy; info; info = info->next)
> +			if (info->mm == oldmm)
> +				register_one_mm(walk, info, true);
> +	}
> +

A subsystem pattern flags this call as potentially concerning, so this may
not be a bug.

uprobe_dup_mmap() is called from dup_mmap() with mmap_write_lock_killable()
held on oldmm, and before the copy loop reaches vma_start_write_killable()
on each vma:

dup_mmap()
    mmap_write_lock_killable(oldmm)
    uprobe_dup_mmap(oldmm, mm)
        register_one_mm(walk, info, true)
            install_breakpoint() / remove_breakpoint()
                set_swbp() / set_orig_insn()
                    uprobe_write()
                        get_user_pages_remote()
                        folio_walk_start() + __uprobe_write()
                        collapse_pte_mapped_thp()   (unregister path)
                            try_collapse_pte_mapped_thp()
                                pmdp_collapse_flush() + pte_free_defer()
    ...
    vma_start_write_killable(mpnt)

The guide for the VMA locking code says to report functions that hold
mmap_write_lock and access page tables or PTE pages before calling
vma_start_write(vma), because other threads of the forking process may
still hold per-VMA read locks on the same vma, for example in a page fault
or in MADV_DONTNEED with CONFIG_PT_RECLAIM.

Can uprobe_write() and collapse_pte_mapped_thp() run against oldmm here
while another thread of the forking process holds a per-VMA read lock on
the same vma?

For context, the existing register_for_each_vma() -> register_one_mm()
walk already did this with only mmap_write_lock held.  What this patch adds
is a second caller of that code inside dup_mmap(), which did no page table
access on oldmm before vma_start_write().

On the other side, uprobe_write() takes the page table lock through
folio_walk_start() and retries when fw.page does not match the expected
page, and try_collapse_pte_mapped_thp() re-checks pmd_same() under the
locks before pmdp_collapse_flush().  khugepaged's retract_page_tables()
also retracts page tables without mmap_lock at all.  So it may be that
this access is safe without the per-VMA write lock.

Could you confirm whether the vma_start_write() rule is meant to apply to
the uprobe_write() path called from uprobe_dup_mmap()?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/39710454342
--===============7594496370134435936==--

