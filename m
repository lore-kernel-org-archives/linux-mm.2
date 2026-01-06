Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C8B5CE9D42
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DCB26B0088; Tue,  6 Jan 2026 10:01:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2D56B008A; Tue,  6 Jan 2026 10:01:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3A56B0093; Tue,  6 Jan 2026 10:01:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79BB46B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:01:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1BC091396D6
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:01:23 +0000 (UTC)
X-FDA: 84301852446.13.3EBF968
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id ECD36180006
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:01:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O0WqH4rJ;
	spf=pass (imf24.hostedemail.com: domain of aha310510@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=aha310510@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767711681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BX1iSwakFLYH5DOXYbVZ88iw6U0ecyhjIT7LpZtyg9Q=;
	b=Glz8Qessvxyb+wY0d0X5Ks8iTqhC2Vz+U4vLI2QzLSw8x1Hz4Tb/f3/m2N8KmSMz1QR3Um
	lU6PNFtiRtEtOPQsqRV5Y4OFwT47NvQo5NvXC0q5jQQHgdK2AK9WWzoxbKvHWuIqbYyuSD
	d4B2zrgLSLeofaH5N5qlEJckoWPhp+A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O0WqH4rJ;
	spf=pass (imf24.hostedemail.com: domain of aha310510@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=aha310510@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767711681; a=rsa-sha256;
	cv=none;
	b=iAfxvQVb60KgDxihX1Nh8hQqA04xASCEL67qsw6787QQvlM8SdZ5NXkaBhwckgVUBLEZGb
	2YfVBOl4im9jiKM1RDgljW1DImbA2VPrbtO76Ju3F5a/i6dKblIUz4NBS7Z2/hx/0Dgv0z
	qZI6b8/Ao4p6GS1afalN5bI1SryUBZg=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34abc7da414so932482a91.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 07:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767711680; x=1768316480; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BX1iSwakFLYH5DOXYbVZ88iw6U0ecyhjIT7LpZtyg9Q=;
        b=O0WqH4rJ+U36VVzSeDRR1SC+5MDkWFa1pBYsSXvpdxXORGrrelVV44QCRqjiHNUPuP
         li+9/ZMh+slzLCetmRnelciGZhpNlPqh6NFeAThWfg9lNLnDjFatrfDjmuxhy75fmYVI
         PxHMdVnRESZqRdJzlXSb5oF17vH5ski1fmCCfgikgp2U1O3R8FEQwKySq5fy34tqTnWF
         4ZEevz5yvO+OE6pWE1LtkrcR0FXhqCLj0uYURFkOfa7UgRxCkNdZSn2bVIfjoLfgvtaT
         XwAu2BiXcbz/fcIbbq3xjn5G29tbccvyRWeILov4sK4wT+WsJE6i5BJPa12ZOTo6XmYT
         wABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767711680; x=1768316480;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BX1iSwakFLYH5DOXYbVZ88iw6U0ecyhjIT7LpZtyg9Q=;
        b=vUcno8HgMakN1jVq6RzA5Mywu9XYJ1TuR1pqwzxQb9HPI+lR3urcKaFgsdxiwgeJ1Y
         uQOppDP/7lpRTjMa6Uw5EnFdmXZVOvX2CUxd8Da6RIorS3YKfHXT/gm2JArKPfnzapdL
         o4tmFisC4iWGn79rc6Paswy+hPPFH5Jpcb6zKNxzyMPkzeYjNe1mW3TJ7J9026oSl3el
         kraCdwejeu6fIvAcgaYqEf+8d6VXHmYlcn94bMzIk3WlRp+qT7NuHQFzNNN6gtspHnKK
         487w5xwUStNYqtB+Yi+RHWa3PIegabvoOtsGPqkrfJvYSqy99ogN/nRMQ1XHxvPwn0Ap
         6yAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUGKYTuUWZlMA78OJ+CpfaU21YKNYy4YkHfsYkbGrqGPlYgdmC6njYTPaduFOMyBAL3XUy5C6X6A==@kvack.org
X-Gm-Message-State: AOJu0Yz159iYRN6QrRjRLDg95ydnD61sL8PxndJjLXaeET+j9qYmCEU9
	+1lx/qsHBCStv8lkfFNFrEWeydoa3vRZtdA59ZzE4uwSRW4vicFqDLXZkuG0vhbelTLqn+RBj27
	N0JGpsZSLGAo+vfOk4v3aMO4OsFvIjbI=
X-Gm-Gg: AY/fxX69snioXkV6cjl/sMUCpPLC73jPxgyEx2bS308DBuM7RRpSZN3bm0D6u65AJGh
	wFv9WcGcwT5u1FQoDkkCuX1NYMhXW1FDwDwGdQINKjBod7NX2sDzVkcpXjBu2TN7xyePeJkDZYB
	VVL+D7HadO//Vfh9WtReqISVAslvmyDsNMlmprMZ22HINIDTTeCaUIwye7ITSrBTK2WwjUQagg3
	9SZrvLpds3aN4djnSXypSXRYH7INi3PhTYnynj984PGz2LDYsn0KwaK9LXb6suOX7g6vdUvog==
X-Google-Smtp-Source: AGHT+IGbZ+lyJ1RsxhGICcMBZjanW7y055u9n1ZitG/oeCljjh+GitxLRYpbh+1Qtvn3XE85qTbUfqamiGtEbNwJ1co=
X-Received: by 2002:a17:90b:49:b0:343:edb0:1012 with SMTP id
 98e67ed59e1d1-34f5f3019f8mr2285451a91.21.1767711679141; Tue, 06 Jan 2026
 07:01:19 -0800 (PST)
MIME-Version: 1.0
References: <cover.1767638272.git.lorenzo.stoakes@oracle.com> <b7930ad2b1503a657e29fe928eb33061d7eadf5b.1767638272.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <b7930ad2b1503a657e29fe928eb33061d7eadf5b.1767638272.git.lorenzo.stoakes@oracle.com>
From: Jeongjun Park <aha310510@gmail.com>
Date: Wed, 7 Jan 2026 00:01:10 +0900
X-Gm-Features: AQt7F2rJ2dmsfXp-dTcOgVOKKyh_tKVEYyzVPQ_bPH9wNjWB3vFj-OrHbqm7cfY
Message-ID: <CAO9qdTF=sH85WJafsgWF0iww9MVq__Z6KdZVLO4JwJVt5op1+Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm/vma: fix anon_vma UAF on mremap() faulted,
 unfaulted merge
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ECD36180006
X-Stat-Signature: tp1rkzyby17pg1okgk15u7usga73mthf
X-Rspam-User: 
X-HE-Tag: 1767711680-813992
X-HE-Meta: U2FsdGVkX18FvcVlx4CNOK+pKgk3nPOs+KH6P0GjpFKIYMDXIo14iFP2uoecW60anYJugO9GAAnfQZwChzQqaLPtsTGnYY9jLw6eW5Y6lXZL2ONyh41rUv/D5TNwxE/ItVqB46i7EbkLEQSNYwukYffAthynaFM4elGDWBAk8M3QHGFYk26mES+8HnYfE4PkMVtvdPtTGXoAP3gWDZQww8CESNQ08tZ98ihBc3VzmSpEBABvYqJFtut8GF0GuXj4fgI2CjbFi6nl8SHVjqGKFzFF8E1biQkPZgWa3sZ4EISiypa3mRWBf2s+Z95ZI3DpDqxd1qEKD7HpcgJ/4Yhcq9/nNDkYFbRPjIEuTlzg2yP2bVwxo0UMjkkSmMGkYLnv3Bq7AAjY7v8f4qJNAlJyzw34t2nHbPLe7vO6dpALpkgnyRxhxBEdaeTyDz5QRwC06wjt+UZs+BoS5HksAkDVWbREtwwARPpHBU4nVSabGBrj30L49lB4Pm88p4O8aF65d0onj7DxR3tw5izaBGGwjZT9XkBfYagczgCyyH7C4AeRyOl1xWxYo+mGT2YiwqIGOns+x1Ww9Rtr4ryypeaVUumgBElc/UT7TncMgE4c3c3xXjXkmDZPZaa3RZLXEuWW5GDWohZmZS+8QMp60r920fh7CX+t+sqfPlva4cezXTvk+wZnTHxqSzngNz9luw/tPfNHE0tvnrGRV0GgS0yYHJmvbtOlLIOTdH4ZTL2M8c93fe5qsshVDY1HULbYmBDcJQG3zj8grkqNi93f/o8iyhskcrHaF75tVZ7vIvYgHRnRT2m6Z4Piq7Ow802LO1p0lM07WM2jeOZAX5zr+J5izjdMjYdx1+INzbK/qVQXQ4PzzXLMKapCVVK/9g7QjQ5sOG7Za36/FzUN30foj+Sfc1BY1d+WIkspF9Z6MksTuvydc4q3tl1SyjcIDcfQHkSoNV3Zuql5TPQt4Rv9ZBc
 tBZmRRPE
 ImbF/zVL42m3eZYii+S+ID+Nkj8gMygZBty/LEip/ONkMVzOtEWmxXw/Quu+fbJJcFo59lprZc2LQYxuAY066dzTYZCMhxG7Jq7CAa+UcwuYBYPGyoX4ddZeens7WCplREdqwXybQhniygGBbZRpNMd8n50ZUrFDqBDL/r5WyN8wLIwzBkPoa6HOXj06VwPJ1gl8kc0/hsmbELYjqAbsVxMsAI7OXwZqJlM6uTxWYogSktWbBvJZBM6HTfeQ8YkIVYnLlXKw5KGVKeTwJlxDBjI+RLQn40esyXqJS7/qYHYgfRDYVLpT3uiOwWdhUp133+M+S1+wtAp4qQmQDd3IFfOwcBPg435USpXXIGeDJ/oywYkDSqZAZPp8aJouorwWpIOZMVhUW+qinClNZZZ33srBnQcP1tRutd8PoJSYJU4owkxF+F8kZhZ2fyaisf148+yF7yue5W3L0n0wNbnH78Vfc7Q6/uV0HaCjXRPb1PX4MAZyx5fFYSXXannbP+dzSYR/2TDRpKfaNq4LbA9/rDHsL9YdlS4h1WX4auBBkocw0JFbjFd6pg4i+jA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> Commit 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA
> merges") introduced the ability to merge previously unavailable VMA merge
> scenarios.
>
> The key piece of logic introduced was the ability to merge a faulted VMA
> immediately next to an unfaulted VMA, which relies upon dup_anon_vma() to
> correctly handle anon_vma state.
>
> In the case of the merge of an existing VMA (that is changing properties
> of a VMA and then merging if those properties are shared by adjacent
> VMAs), dup_anon_vma() is invoked correctly.
>
> However in the case of the merge of a new VMA, a corner case peculiar to
> mremap() was missed.
>
> The issue is that vma_expand() only performs dup_anon_vma() if the target
> (the VMA that will ultimately become the merged VMA): is not the next VMA,
> i.e.  the one that appears after the range in which the new VMA is to be
> established.
>
> A key insight here is that in all other cases other than mremap(), a new
> VMA merge either expands an existing VMA, meaning that the target VMA will
> be that VMA, or would have anon_vma be NULL.
>
> Specifically:
>
> * __mmap_region() - no anon_vma in place, initial mapping.
> * do_brk_flags() - expanding an existing VMA.
> * vma_merge_extend() - expanding an existing VMA.
> * relocate_vma_down() - no anon_vma in place, initial mapping.
>
> In addition, we are in the unique situation of needing to duplicate
> anon_vma state from a VMA that is neither the previous or next VMA being
> merged with.
>
> dup_anon_vma() deals exclusively with the target=unfaulted, src=faulted
> case. This leaves four possibilities, in each case where the copied VMA is
> faulted:
>
> 1. Previous VMA unfaulted:
>
>               copied -----|
>                           v
>         |-----------|.............|
>         | unfaulted |(faulted VMA)|
>         |-----------|.............|
>              prev
>
> target = prev, expand prev to cover.
>
> 2. Next VMA unfaulted:
>
>               copied -----|
>                           v
>                     |.............|-----------|
>                     |(faulted VMA)| unfaulted |
>                     |.............|-----------|
>                                       next
>
> target = next, expand next to cover.
>
> 3. Both adjacent VMAs unfaulted:
>
>               copied -----|
>                           v
>         |-----------|.............|-----------|
>         | unfaulted |(faulted VMA)| unfaulted |
>         |-----------|.............|-----------|
>              prev                      next
>
> target = prev, expand prev to cover.
>
> 4. prev unfaulted, next faulted:
>
>               copied -----|
>                           v
>         |-----------|.............|-----------|
>         | unfaulted |(faulted VMA)|  faulted  |
>         |-----------|.............|-----------|
>              prev                      next
>
> target = prev, expand prev to cover. Essentially equivalent to 3, but with
> additional requirement that next's anon_vma is the same as the copied
> VMA's. This is covered by the existing logic.
>
> To account for this very explicitly, we introduce vma_merge_copied_range(),
> which sets a newly introduced vmg->copied_from field, then invokes
> vma_merge_new_range() which handles the rest of the logic.
>
> We then update the key vma_expand() function to clean up the logic and make
> what's going on clearer, making the 'remove next' case less special, before
> invoking dup_anon_vma() unconditionally should we be copying from a VMA.
>
> Note that in case 3, the if (remove_next) ... branch will be a no-op, as
> next=src in this instance and src is unfaulted.
>
> In case 4, it won't be, but since in this instance next=src and it is
> faulted, this will have required tgt=faulted, src=faulted to be compatible,
> meaning that next->anon_vma == vmg->copied_from->anon_vma, and thus a
> single dup_anon_vma() of next suffices to copy anon_vma state for the
> copied-from VMA also.
>
> If we are copying from a VMA in a successful merge we must _always_
> propagate anon_vma state.
>
> This issue can be observed most directly by invoked mremap() to move
> around a VMA and cause this kind of merge with the MREMAP_DONTUNMAP flag
> specified.
>
> This will result in unlink_anon_vmas() being called after failing to
> duplicate anon_vma state to the target VMA, which results in the anon_vma
> itself being freed with folios still possessing dangling pointers to the
> anon_vma and thus a use-after-free bug.
>
> This bug was discovered via a syzbot report, which this patch resolves.
>
> We further make a change to update the mergeable anon_vma check to assert
> the copied-from anon_vma did not have CoW parents, as otherwise
> dup_anon_vma() might incorrectly propagate CoW ancestors from the next VMA
> in case 4 despite the anon_vma's being identical for both VMAs.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
> Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/694a2745.050a0220.19928e.0017.GAE@google.com/
> Cc: stable@kernel.org
> ---

Wow, I didn't know there would be this many problems. LGTM
Reviewed-by: Jeongjun Park <aha310510@gmail.com>

And this syzbot report seems to have the same root cause.
Reported-by: syzbot+5272541ccbbb14e2ec30@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/694e3dc6.050a0220.35954c.0066.GAE@google.com/

>  mm/vma.c | 84 +++++++++++++++++++++++++++++++++++++++-----------------
>  mm/vma.h |  3 ++
>  2 files changed, 62 insertions(+), 25 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 6377aa290a27..660f4732f8a5 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -829,6 +829,8 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
>         VM_WARN_ON_VMG(middle &&
>                        !(vma_iter_addr(vmg->vmi) >= middle->vm_start &&
>                          vma_iter_addr(vmg->vmi) < middle->vm_end), vmg);
> +       /* An existing merge can never be used by the mremap() logic. */
> +       VM_WARN_ON_VMG(vmg->copied_from, vmg);
>
>         vmg->state = VMA_MERGE_NOMERGE;
>
> @@ -1098,6 +1100,33 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
>         return NULL;
>  }
>
> +/*
> + * vma_merge_copied_range - Attempt to merge a VMA that is being copied by
> + * mremap()
> + *
> + * @vmg: Describes the VMA we are adding, in the copied-to range @vmg->start to
> + *       @vmg->end (exclusive), which we try to merge with any adjacent VMAs if
> + *       possible.
> + *
> + * vmg->prev, next, start, end, pgoff should all be relative to the COPIED TO
> + * range, i.e. the target range for the VMA.
> + *
> + * Returns: In instances where no merge was possible, NULL. Otherwise, a pointer
> + *          to the VMA we expanded.
> + *
> + * ASSUMPTIONS: Same as vma_merge_new_range(), except vmg->middle must contain
> + *              the copied-from VMA.
> + */
> +static struct vm_area_struct *vma_merge_copied_range(struct vma_merge_struct *vmg)
> +{
> +       /* We must have a copied-from VMA. */
> +       VM_WARN_ON_VMG(!vmg->middle, vmg);
> +
> +       vmg->copied_from = vmg->middle;
> +       vmg->middle = NULL;
> +       return vma_merge_new_range(vmg);
> +}
> +
>  /*
>   * vma_expand - Expand an existing VMA
>   *
> @@ -1117,46 +1146,52 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
>  int vma_expand(struct vma_merge_struct *vmg)
>  {
>         struct vm_area_struct *anon_dup = NULL;
> -       bool remove_next = false;
>         struct vm_area_struct *target = vmg->target;
>         struct vm_area_struct *next = vmg->next;
> +       bool remove_next = false;
>         vm_flags_t sticky_flags;
> -
> -       sticky_flags = vmg->vm_flags & VM_STICKY;
> -       sticky_flags |= target->vm_flags & VM_STICKY;
> -
> -       VM_WARN_ON_VMG(!target, vmg);
> +       int ret = 0;
>
>         mmap_assert_write_locked(vmg->mm);
> -
>         vma_start_write(target);
> -       if (next && (target != next) && (vmg->end == next->vm_end)) {
> -               int ret;
>
> -               sticky_flags |= next->vm_flags & VM_STICKY;
> +       if (next && target != next && vmg->end == next->vm_end)
>                 remove_next = true;
> -               /* This should already have been checked by this point. */
> -               VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> -               vma_start_write(next);
> -               /*
> -                * In this case we don't report OOM, so vmg->give_up_on_mm is
> -                * safe.
> -                */
> -               ret = dup_anon_vma(target, next, &anon_dup);
> -               if (ret)
> -                       return ret;
> -       }
>
> +       /* We must have a target. */
> +       VM_WARN_ON_VMG(!target, vmg);
> +       /* This should have already been checked by this point. */
> +       VM_WARN_ON_VMG(remove_next && !can_merge_remove_vma(next), vmg);
>         /* Not merging but overwriting any part of next is not handled. */
>         VM_WARN_ON_VMG(next && !remove_next &&
>                        next != target && vmg->end > next->vm_start, vmg);
> -       /* Only handles expanding */
> +       /* Only handles expanding. */
>         VM_WARN_ON_VMG(target->vm_start < vmg->start ||
>                        target->vm_end > vmg->end, vmg);
>
> +       sticky_flags = vmg->vm_flags & VM_STICKY;
> +       sticky_flags |= target->vm_flags & VM_STICKY;
>         if (remove_next)
> -               vmg->__remove_next = true;
> +               sticky_flags |= next->vm_flags & VM_STICKY;
>
> +       /*
> +        * If we are removing the next VMA or copying from a VMA
> +        * (e.g. mremap()'ing), we must propagate anon_vma state.
> +        *
> +        * Note that, by convention, callers ignore OOM for this case, so
> +        * we don't need to account for vmg->give_up_on_mm here.
> +        */
> +       if (remove_next)
> +               ret = dup_anon_vma(target, next, &anon_dup);
> +       if (!ret && vmg->copied_from)
> +               ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
> +       if (ret)
> +               return ret;
> +
> +       if (remove_next) {
> +               vma_start_write(next);
> +               vmg->__remove_next = true;
> +       }
>         if (commit_merge(vmg))
>                 goto nomem;
>
> @@ -1828,10 +1863,9 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
>         if (new_vma && new_vma->vm_start < addr + len)
>                 return NULL;    /* should never get here */
>
> -       vmg.middle = NULL; /* New VMA range. */
>         vmg.pgoff = pgoff;
>         vmg.next = vma_iter_next_rewind(&vmi, NULL);
> -       new_vma = vma_merge_new_range(&vmg);
> +       new_vma = vma_merge_copied_range(&vmg);
>
>         if (new_vma) {
>                 /*
> diff --git a/mm/vma.h b/mm/vma.h
> index e4c7bd79de5f..d51efd9da113 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -106,6 +106,9 @@ struct vma_merge_struct {
>         struct anon_vma_name *anon_name;
>         enum vma_merge_state state;
>
> +       /* If copied from (i.e. mremap()'d) the VMA from which we are copying. */
> +       struct vm_area_struct *copied_from;
> +
>         /* Flags which callers can use to modify merge behaviour: */
>
>         /*
> --
> 2.52.0
>

