Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31796C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BED46B00AF; Mon, 14 Sep 2026 10:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E2B6B00B0; Mon, 14 Sep 2026 10:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4A56B00B1; Mon, 14 Sep 2026 10:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 112816B00AF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:25:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D5268011A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:25:03 +0000 (UTC)
X-FDA: 85212589686.09.BDD96D7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 45E3A120008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:25:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=B7TumlXZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x9CZQ0Pj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vaaBcSqQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Uwq1rmkf;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395901;
	b=fASp4rLPLWNsIt6VkE4rGEygJquMDJRVm3w2okvvJePVr9dmkQbshFxAZeSO49jTxD/mB7
	xpgDumjvXhOqG7FiOzr2Y6a2pz7MFHo6ndwNDbUZ/p8mZlLaHU5sZMlWKwicufjuGDzqQ3
	ChZcbQ7CZ/37Do1mjFLoJvsQSfMbEeU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=B7TumlXZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x9CZQ0Pj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vaaBcSqQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Uwq1rmkf;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8uOj8JF+OXNiF3/lX/wOUKSXh6iShm8a7pD7w4hGuZU=;
	b=EDhi8e5UQfW5GYlMSTwgpL7cdDyohba4K4ARS0cVUWYWjRc7UVBM1XViW3riZ0pwfgSxmY
	zv9/tf9LCRkIr37uW15r84owlnBxEXTP2Tw3q5OVzfOdiITKtdGw98f9aZvjdAM7M5OOLf
	LsHb+n7AawNOFm4Lwwl+vet7IzZyTOE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 961E11F7CC;
	Mon, 14 Sep 2026 14:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789395895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8uOj8JF+OXNiF3/lX/wOUKSXh6iShm8a7pD7w4hGuZU=;
	b=B7TumlXZuUgGz8VjLurNKO7izc1TfFv8NJEctpHJOPJRHufMNEv+HX8LtLk2B5BmqwbNlZ
	pyzkJgH9qhorq/wGPsDhexgsy55RMMXLnXXN0xjbIoCv7+QBM+6owxs+cbM/iMp83jYHV0
	XTwMzblBD335lpftNi9itDFC+KyykCc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789395895;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8uOj8JF+OXNiF3/lX/wOUKSXh6iShm8a7pD7w4hGuZU=;
	b=x9CZQ0PjijFGqKV1O9k+iefqFpgaoZ2l7WtaiYGwo7DysyBEL3RmV//+q4sr2Qr8nO2BWO
	S/3Do4AyKibBDoAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789395891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8uOj8JF+OXNiF3/lX/wOUKSXh6iShm8a7pD7w4hGuZU=;
	b=vaaBcSqQj8snDhc8qRaxmqEJZKhXIBMTOp+PgxtOIVcSkarXJTFuTa4y3nu0Sf1b5Uxau2
	lVxae7lr2QKHS5nusb5UGz7BhMmTdV58KvmNE1Y49OqiIGzjAzkXVWlc3rBxKz3cjWNivw
	JMtn+BrUxNlPSFPRrGH22rd2EI14nso=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789395891;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8uOj8JF+OXNiF3/lX/wOUKSXh6iShm8a7pD7w4hGuZU=;
	b=Uwq1rmkfn+6a1S2IjEA6QTh2AIoOJNYhyciTeu5akf3wNltNhSX6cY0DjRksGKyTK/It9M
	dpjQbr9nRMHC71BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6081513515;
	Mon, 14 Sep 2026 14:24:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bylAFLEDqGodHwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 14 Sep 2026 14:24:49 +0000
Date: Mon, 14 Sep 2026 15:24:47 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Subject: Re: [PATCH v2] mm: implement and use vma_anon_tracked(), silence
 KCSAN
Message-ID: <aqgC9iVHtB1fMWS2@pedro-suse.tail5790ac.ts.net>
References: <20260910-vma-is-faulted-v2-1-e81ebc7d146b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910-vma-is-faulted-v2-1-e81ebc7d146b@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 45E3A120008
X-Stat-Signature: 9ty1m5s8ww8qrsjqgortxqektqur1df6
X-Rspam-User: 
X-HE-Tag: 1789395901-652
X-HE-Meta: U2FsdGVkX190857xKCPqbAs2opTOC6nuUN0ajZLjz2p0NgcC1DqoV57NrNuGISpl5PI+M8pSxOE9sTyDgeAGSS08kibIxMW8g+2jXFr8c9hr2by80ah7R790LqyQpEP18InlEi5W/+YA3OA/UrPglBb+GVo4nPCLROusuwRe2kwv4YcAPhjrRJVMPE+7OIXg0QTd1tv5TkzZDLyn/4gbvJuGJM/dEKLCxTdojM8hddtpcVET4bHtkXnrVHZHrr57KA/hICOuC4KY70PqnBUSlRAARw9ebBLq2TEk81Jgr6DBVHvtgtjgHvvelWS9IP+1MIEsQHDl13c1jA3q/8rtQaUnAsKws7TypeRo2JqaNFMTTwbPPYivZnjMz/l9oBbKPW1Cxt86Npesjz0QTecOXajgCqS2A8cf2VYPGy7zxiav99k7Z5xwWi5w2tI/YkHy2QrG7eqvGfJBIfFoRT2BUNxMsYPuE0fanQzoP0A/EPRR5GrOhbP7uLgt6mppOHpkmPrCKhTov+BOJlzhj/lhkihq2jTPy9ZtoZ7UfDHYGPF2sHZdX4TQ7g+8PVjz1j9md3OOkTlXmNqGE4sj/jaEpq5eNLmOawVCvo51bMlN0n/5SijFPXy361zpNbSZolI9ypsH0zRyZOBQcbrJCkM0EPvkuZg9yV2tH/uGomAY/X9enIJeHzWwm8Dltn/KnFNCPrlT0WITddibXJLscpWG2aA3j/8EBi0uxhrH/LqA51cAAtx0iOu3Z931l7aeV/+FyItlD49n7JzDNUNtC/yp/NKDfF6MpgOzSDtVNIfzT+HkPMKIADLpkXFcbhm3cKQqvsIGw7NnVPh6Lj+765UzNplcICJdToVQ3h8hNn/y/PeZ9hklhNwgUfvZk0gis80zJAsRc7dR7d8ZQeKJ9ze98cNTbmHLaK0emxZxlHdwDtttEU9wqFnMJeVnCGno9aJeHZKkDv9VryIKaO9tMJX
 5nYZfSbT
 ytvsC8YipoFzyt09ngI8cS/ikwUiasJid7Z67+wcjaz3fBP8D6rP6/vxOw32kPdxaXGYv8Hpghpq2gEVsJWNpgDYWSu98giXg0hDyXPbfeCZ/Iz25vRX7Rq1EDzsjLJziQDsA8SuXxegsyZ57bKwgp2aG/u93dPTBSM4eSjiypC6pPjhYbudjRlo28jMpWYMVPdI63zHgp4gcLGsM+ucoKF9KTPy9Q4a6Y1GryDZ5JgyPpb2QCBUBxLU0IlHwdEZqBn9+mUETM6mwOa6ZBdnh1Kk5aJq6+Wm19YOSq/T6JeTcxO93P/wN1g8c1jhl2wirqRpBEHno+vDbvoE54i7R/P973fT9mZF+F3MVpv8EpybdSBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 02:18:35PM +0100, Lorenzo Stoakes (ARM) wrote:
> Provide a function to abstract the common task of checking whether
> a VMA is faulted in or not.
> 
> A VMA or mmap lock must be held when calling this function. For an attached
> VMA the transitions between unfaulted/faulted state are:
> 
>        Transition        |              VMA/mmap Lock state
>  ------------------------|-----------------------------------------------
>    unfaulted to faulted  | write lock OR read lock + mm->page_table_lock
>    faulted to unfaulted  | write lock
> 
> So vma_anon_tracked() never provides a false positive (the lock precludes
> it), but if only a read lock is held, a negative result must be re-checked
> with mm->page_table_lock held.
> 
> Detached VMAs cannot be concurrently manipulated as they are removed from
> the maple tree so require no guarantees.
> 
> Use data_race() to silence KCSAN about non-existent data races between
> concurrent vma->anon_vma read/write on optimistic fault tests.
> 
> Also while here, const-ify vma_is_attached(), vma_assert_stabilised() and
> dependants.
> 
> Finally, update the core VMA merge/split, rmap, mremap, KSM and fault
> preparation callers which test vma->anon_vma directly to use
> vma_anon_tracked() instead.
> 
> Note that the lockless read in reusable_anon_vma() is doing more than
> checking whether the VMA is faulted - it is returning the anon_vma to be
> used on fault, so this check is not altered.
> 
> There is one odd one out - file_backed_vma_is_retractable() - which holds
> neither a VMA nor mmap lock and is stabilised by the file rmap lock only.
> 
> Therefore just add a comment to explain why the direct vma->anon_vma check
> is required.
> 
> Reported-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
> Closes: https://lore.kernel.org/all/20260829100034.423064-1-trintaeoitogc@gmail.com/
> Closes: https://lore.kernel.org/all/20260909115723.528501-1-trintaeoitogc@gmail.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> v2:
> - Renamed vma_is_faulted() to vma_anon_tracked() as per David.
> 
> v1:
> https://lore.kernel.org/r/20260909-vma-is-faulted-v1-1-3a701f48984a@kernel.org
> ---
>  include/linux/mmap_lock.h         | 12 ++++++------
>  mm/huge_memory.c                  |  4 ++--
>  mm/internal.h                     |  2 +-
>  mm/khugepaged.c                   |  3 +++
>  mm/ksm.c                          | 10 +++++-----
>  mm/madvise.c                      |  4 ++--
>  mm/memory.c                       |  2 +-
>  mm/mprotect.c                     |  2 +-
>  mm/mremap.c                       |  4 ++--
>  mm/rmap.c                         | 22 +++++++++++-----------
>  mm/swapfile.c                     |  2 +-
>  mm/userfaultfd.c                  |  2 +-
>  mm/vma.c                          | 29 +++++++++++++++--------------
>  mm/vma.h                          | 22 +++++++++++++++++++++-
>  tools/testing/vma/include/dup.h   |  2 +-
>  tools/testing/vma/include/stubs.h |  4 ++++
>  16 files changed, 77 insertions(+), 49 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 00eae65b74bd..03e1eb136111 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -273,7 +273,7 @@ static inline void vma_end_read(struct vm_area_struct *vma)
>  	vma_refcount_put(vma);
>  }
>  
> -static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
> +static inline unsigned int __vma_raw_mm_seqnum(const struct vm_area_struct *vma)
>  {
>  	const struct mm_struct *mm = vma->vm_mm;
>  
> @@ -288,7 +288,7 @@ static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
>   *
>   * Returns true if write-locked, otherwise false.
>   */
> -static inline bool __is_vma_write_locked(struct vm_area_struct *vma)
> +static inline bool __is_vma_write_locked(const struct vm_area_struct *vma)
>  {
>  	/*
>  	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
> @@ -344,7 +344,7 @@ int vma_start_write_killable(struct vm_area_struct *vma)
>   * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
>   * @vma: The VMA to assert.
>   */
> -static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> +static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
>  {
>  	if (!IS_ENABLED(CONFIG_MMU)) {
>  		mmap_assert_write_locked(vma->vm_mm);
> @@ -359,7 +359,7 @@ static inline void vma_assert_write_locked(struct vm_area_struct *vma)
>   * lock and is not detached.
>   * @vma: The VMA to assert.
>   */
> -static inline void vma_assert_locked(struct vm_area_struct *vma)
> +static inline void vma_assert_locked(const struct vm_area_struct *vma)
>  {
>  	unsigned int refcnt;
>  
> @@ -410,7 +410,7 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
>   * With lockdep disabled we may sometimes race with other threads acquiring the
>   * mmap read lock simultaneous with our VMA read lock.
>   */
> -static inline void vma_assert_stabilised(struct vm_area_struct *vma)
> +static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
>  {
>  	/*
>  	 * If another thread owns an mmap lock, it may go away at any time, and
> @@ -445,7 +445,7 @@ static inline void vma_assert_stabilised(struct vm_area_struct *vma)
>  	vma_assert_locked(vma);
>  }
>  
> -static inline bool vma_is_attached(struct vm_area_struct *vma)
> +static inline bool vma_is_attached(const struct vm_area_struct *vma)
>  {
>  	return refcount_read(&vma->vm_refcnt);
>  }

nit: I would suggest you do all of this constification in a separate patch,
otherwise it can become tricky for backports. Things can naturally start depending
on const correctness, and you either need to manually adjust those future patches,
or try to backport this one.

The rest looks vaguely good to me. I admit I'm not a gigantic fan of the name,
but I suspect it fits better with your future anon rmap ideas :)

Reviewed-by: Pedro Falcato <pfalcato@suse.de>


-- 
Pedro

