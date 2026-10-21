Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63954606A338
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 12:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oTb0PsEY
Received: by kanga.kvack.org (Postfix)
	id 821996B06F9; Wed, 21 Oct 2026 08:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9AC6B06FA; Wed, 21 Oct 2026 08:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70EE76B06FB; Wed, 21 Oct 2026 08:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 506146B06F9
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:02:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB65080519
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:02:13 +0000 (UTC)
X-FDA: 85346495346.29.7807B2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3D58540018
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:02:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oTb0PsEY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792584132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TB7v9N/W2xTmNch7MkNivf/9UIfr6xOKYhQd3i+ONPg=;
	b=o6fcqd72MVzDFt0Tk5TwGEse+78m7MLcAEBrejvXR22HE5TU3JCquHpv4ZwSHUfGze1+ug
	HsodnBmk5TaVAud/GCSbhrBTM9Cex3eEOC6O7Zg3122STMFemhVHewSatWF8wEOUFHXpBO
	EEmtDKrvDqCfau6CFlM3zqmxg8lQULc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oTb0PsEY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792584132;
	b=jpFAYsUFJM4CG3ONBsrEnW/oVrib6Piz4txlIoCMHAFSy/Ya6SQ4v+vwiob5DVxYvzDtmf
	xp2+WS9j0RzpPeFs21RJi9DCdgwVP1UQQ2PihBmUfLlo7xGFGj7O6BzUz9nPFC7e8n5nXp
	ntlrL9wSntnoy1MxZLCmKlPZr1WkZwY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5081B40F47;
	Wed, 21 Oct 2026 12:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDDE1F000C9;
	Wed, 21 Oct 2026 12:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792584131;
	bh=TB7v9N/W2xTmNch7MkNivf/9UIfr6xOKYhQd3i+ONPg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=oTb0PsEYgwLw1y9tW1PiZ51FoiwOLqMvmA1ZNC242x9QOenanDFnyvuYdUAeVQ/Rn
	 c2yAVy2IuhgPC35XIHJrcGXEWcQtaCr7K9R8jWFIWJx6OJh+luQtc1j/qEMlyU0ydt
	 ZLOGzrVG5IDe9cyrOfb1infJBUv6P4UVyHzvYtDhWsiZNAlrkAtb6ApxrtB8TQrWxa
	 tkTzQPC5PNL+3JMw9qPYvjZv2DD/sg4njywHCpRYzue+MLWOpZMqP326KSW7dDmF80
	 3/SsINkZNkwf4y74LDrfjP69m8FuI48RDqx7JM+ZxAHvVDxjPcEG3AZO5R3/EXlMea
	 n5YtHaDeqWe/g==
Content-Type: multipart/mixed; boundary="===============5182620710229058046=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <c4c7baf05581e93321e536d935a27b4c1da8b7d8879852664864bff8d3b269a2@mail.kernel.org>
In-Reply-To: <20261021112437.1799213-3-zhen.ni@easystack.cn>
References: <20261021112437.1799213-3-zhen.ni@easystack.cn>
Subject: Re: [PATCH v3 2/7] mm/page_owner: protect page access with mem-hotplug read lock
From: bot+bpf-ci@kernel.org
To: zhen.ni@easystack.cn,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,akpm@linux-foundation.org,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,brendan.jackman@linux.dev,hannes@cmpxchg.org,ziy@nvidia.com,shuah@kernel.org
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,zhen.ni@easystack.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 21 Oct 2026 12:02:10 +0000 (UTC)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3D58540018
X-Stat-Signature: x7ww9jo3hkqyq4q5hgyp1ge6rfiq14k3
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792584132-959232
X-HE-Meta: U2FsdGVkX1+hHt6AMAi5K7Merr2FdoixJ6BvZCQ4RtR8TR8b9Vq6pyWrhcrR89cCV9EWN6l+8VaqQ5He8eujI9gCvcaFjOKfhk4RuVE83karFcejkdSuWY4Ph+Os7pmIIdiBfAv7N89ZMQO0lbnZu/Wmk2Jxhw6q4k03quitPX2ZXo8FL2jQpBvWMWklXmndcPjtTx0A5PfDIFTBb3waRtSG+oX8BFd20a661ORpNr1Hdt3nflt9+L17PzqQrosSxJ7+jnOUfsYhKA9WyS5vejVCIFYeaWunzmuCN5MbbbUQzi0CeQz35jsZv694wRqYgt7z7BswmMhPNVlnaOcnU9YLWHGCW1LBMtd8ASLTAxVP8thOk7ZnmfpqaNnImC3uIVFgi3qIVbBux6nB741WZwgA73HKn39SchIIGtSadmtPiYULEjsNCMwsSdtjSpDGiQucINSsytNXqSRUuArl7ND9s0ry3Zxd7+EATRTmiANT1igB6Hsc2/fUde5CzovbwgM/ZvfcK7NXUiPhtzZcSZ5t2601GLI3+o6m4RniclLx27UXs0MHTkl8nHNoqKkyij5c9I+5bOjdMEpUV6oUzZnMS2w4eKpEASPRggzJdL2vjfXCGiokpBsJPOoOclGA/Wkm9AcImUDLcYvTjXpLUmgHonsL/y0+GFSAi2wVfQIWbmkYCLBTXQdCNptqdbwB8pz+eVulsHXG6Cgt7ifz2/5Hy/1pB82cXs3ZtUUioawG7YPtF9/pqjkAagWEM2OiJNcyUD7pnNByKW+5LSAfuVF9KGCNEC52gS466ySSJ5zXMCKdoGgS0YS3dAxPIO9h9KJc4N0ChgN9t9Wi2Yl2QB2EKy0W0kUbej0d1WqPoI4NGzYN/nulBpKz2xO+N07xMAEv5RNyQV4vfwc+r3d6kbIK2s5Qu+UTYFsxusmZK9UWdKHAO9OLEwTH8OhMQwqimRyinNYflntmt1/5aRd
 Sk6/OUlr
 pMsHInWruhgZxi2f+QZkaJGwSozxO1r8dhj82PGGLvtyV4rS6+zuk1zRJJ7zyPNwUw+jK8RlBRWv4NeCpHm4ES8E9p/mfEtvE7W+IhT1NuwltGyRdD51+hyGnFWWmgio2LS20AU16RBIqdpge6P1KaqFxVEQAZ+cMu5BKMmZiaeS4d07B4BlTn1RtuKKK3UKh26JjLpVwhtX8iUqkXNmG6+j7FaIzEDUJOwFPAp109+DDaIHjUJtT5AxSikNBSUuh2Y7zQUvgrTKZBrt0+EGS1M8wWsFxJKaBb3Sjz10De29lJNscRWjRA45VXCfxjtSV+J3tDzSBF7EetwOGWsNXULLN/gu6KOEoVV12wGPs+RQgQqFVgRXHDpJHXQOpFQ4WBC1s/KZBL8obgEOdzBaVYWEMZURkl2hp0wtFjD0Z0Zg+nvQdVQ9kOZzcspyk2JovnHiLCzytr4XJvoZcie7xyElz/FDtzyIj+0uakn0jnl8am15mGEn3c43vr5c+PKj2I5VsxyPEq6yqCfJCkabWb1toeZAHt/Deh+VK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============5182620710229058046==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> mm/page_owner: protect page access with mem-hotplug read lock

TL;DR: read_page_owner() holds the mem-hotplug read lock across
copy_to_user(); a page fault there may deadlock against mmap_lock (lock-order
inversion with memremap_pages callers) and userspace can stall hot-remove
indefinitely.

> diff --git a/mm/page_owner.c b/mm/page_owner.c
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c

[ ... ]

> @@ -831,7 +843,17 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>
>  	/* Find an allocated page */
>  	while (page_owner_next_eligible(&scan)) {
> -		struct page *page = pfn_to_page(scan.pfn);
> +		struct page *page;
> +		ssize_t ret;
> +
> +		/*
> +		 * The scan is lockless. Re-resolve the page under a mem-hotplug
> +		 * read-side lock so that we never access a hot-removed section.
> +		 */
> +		get_online_mems();
> +		page = pfn_to_online_page(scan.pfn);
> +		if (!page)
> +			goto skip_continue;

[ ... ]

> @@ -851,10 +873,13 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  		/* Record the next PFN to read in the file offset */
>  		*ppos = scan.pfn + 1;
>
> -		return print_page_owner(buf, count, scan.pfn, page,
> +		ret = print_page_owner(buf, count, scan.pfn, page,
>  				&scan.po_snap, scan.po_snap.handle, state);
> +		put_online_mems();
> +		return ret;
                ^^^^

Can this deadlock against mmap_lock?  read_page_owner() now holds the
mem_hotplug_lock reader across the whole print_page_owner() call, and that
includes the copy_to_user() of the formatted record:

print_page_owner()
    ...
    if (copy_to_user(buf, kbuf, ret))
            ret = -EFAULT;

Once kbuf is formatted, nothing in that copy touches struct page, so the
reader isn't needed there.  A user page fault on buf taken inside this
region takes current->mm->mmap_lock for read (on x86 a fault from
kernel-mode uaccess always does, see the 'goto lock_mmap' path in
arch/x86/mm/fault.c for !FAULT_FLAG_USER), and __might_fault() records that
dependency for lockdep.  That creates the lock order:

mem_hotplug_lock(R) -> mmap_lock(R)

The opposite order already exists in the tree.  Code that hotplugs device
memory while holding mmap_read_lock goes through memremap_pages() ->
pagemap_range() -> mem_hotplug_begin(), which does cpus_read_lock() and then
percpu_down_write(&mem_hotplug_lock):

nouveau_svmm_bind()
    mmap_read_lock(mm)
    nouveau_dmem_migrate_vma()
      nouveau_dmem_migrate_chunk()
        nouveau_dmem_migrate_copy_one()
          nouveau_dmem_page_alloc_locked()
            nouveau_dmem_chunk_alloc()
              memremap_pages()

lib/test_hmm.c:dmirror_migrate_to_device()
    mmap_read_lock(mm)
    dmirror_migrate_alloc_and_copy()
      dmirror_devmem_alloc_page()
        dmirror_allocate_chunk()
          memremap_pages()

With three threads sharing one mm, could this sequence occur?

T1 read(page_owner):
    get_online_mems(), then copy_to_user() faults on buf
T2 SVM bind ioctl:
    holds mmap_read_lock(mm), blocks in percpu_down_write(&mem_hotplug_lock)
    waiting for T1
T3 mmap()/munmap():
    queues on mmap_write_lock(mm) behind T2
T1 fault:
    mmap_read_lock(mm) blocks behind T3

None of these waits has a timeout.  While T2 waits it also holds
cpus_read_lock(), so CPU hotplug writers and every later get_online_mems()
caller stall too.

Even without that cycle, the reader can now be held for as long as
userspace wants.  A buf backed by userfaultfd or by a slow or remote file
mapping could stall memory hot-remove for an unbounded time.  Does that
match the commit message claim:

    "Taking the lock per-page bounds the writer's wait to a single page's
    check-and-deref, keeping hot-remove stalls brief while all accesses stay
    protected."

For comparison, ptdump_walk_pgd() already takes get_online_mems() followed
by mmap_write_lock(current->mm).  This new instance sits on a much more
commonly used debug path, and here the lock isn't needed around
copy_to_user() at all.

Would it work to format the record under the reader (or snapshot the
page-derived fields: pageblock migratetype, page->flags, memcg info), call
put_online_mems(), and only then call copy_to_user()?  The kmalloc() in
print_page_owner() could also move outside the locked region.

The last commit in the series (5b123f2cd336 "selftests/bpf: add tests for
the page_owner bpf_iter target") still calls print_page_owner() under the
reader, so the series does not address this later.

>
>  skip_continue:
> +		put_online_mems();
>  		scan.pfn++;
>  		cond_resched();
>  	}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/39593164040
--===============5182620710229058046==--

