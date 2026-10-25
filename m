Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0394606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 14:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ZUVhuG+W
Received: by kanga.kvack.org (Postfix)
	id EE1FB6B05B0; Sun, 25 Oct 2026 10:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E930F6B05B1; Sun, 25 Oct 2026 10:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A826B05B2; Sun, 25 Oct 2026 10:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A7EF86B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:56:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27648C0555
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 14:56:04 +0000 (UTC)
X-FDA: 85361448648.04.D888BDD
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3948F40004
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 14:56:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZUVhuG+W;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792940162;
	b=iPXM7ouZmAZ5i/O9WtBSYlQZP7b8EAymFSzniB8iZdwtdFnGD3udXpKc9WIIxwuPYuU0qF
	OTg7Sgd/pH8e3EfV1f5qI1S/0v9xxYKvmGdXAw1n3J6gUzY+SW+p2h8nVuuAoIzCkZO1+U
	C7aKIqCQ/rId+1U2cufhKavVq0w5/E8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZUVhuG+W;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792940162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edJydXO8eM7QbcwRvjK6Scc5idFapwpqQSUYWRShZ90=;
	b=dKRoFL/vefK85djEZ0C6lcA/UoYYV3dCkeiEKLl/pu99wAvZArKj1QNkHaVWg3wJn473an
	9mYTEVGO/QyxVcbOqTrlu6rpVaJ16IUR9tX3FAyQaeNh0S8vplzVF4/HFtGcPRexsFOZEP
	Ouii/zsvoUhxiYoXhrsWt/6umPOfXaM=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-535f598d126so184441cf.1
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 07:56:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792940161; cv=none;
        d=google.com; s=arc-20260327;
        b=F258VLeNO5JDeW6TEjfp+EJra6uqhjEPth4ROKgZC30UEm/QCjerLMlqMekK6H53qu
         UBGjmF8hCW0EXOGqghSbenBgw2hid6JVEW0V1/f2w8hTm8Z0DwRBEEJ6a5uRj1VCF0yH
         88ybJfAMC71/PHLmtbY3eM8SsdtQ/R/mEZQJ7K8ccFZwRBmyOq52sAuSeLDZyGX1YWfC
         MhKlBSosSogfDu5p5w1wm9IozgVeYTY7xXA0VGUGubIY7HERc2BsZ6zT/VkQCVa0nlTx
         n0rlSAlI8JGLMHQjwyd6CWN0wh1pFhsrPmK0LnkR2HxNv4hP5Hiau7dSKtSof3GaMZMt
         7+tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=edJydXO8eM7QbcwRvjK6Scc5idFapwpqQSUYWRShZ90=;
        fh=kpk1IgaPFViz1vZlJfJaZ9y8+N1jyol6FBgzTjRdSl0=;
        b=P+UzgSOMWpfwJdhgREd8lM1ATFFLcsos7xUTybtzS7HlIQPs9n3qwvNmg5IlrgQSqB
         BFfYHmKS+2/7kmjsoAuI/milCupwd3EB8kUWrvCnLAN4wBZvBEHymISxMVkzRxMxDLOW
         EAm3OBSBZDmHNu69OWREA1jVrx7wYFwzAGGpDhWfTsRLtjULtRTtS2dG2kk1Fut+Dkgu
         Gwupj+HI+edVLzyS8bGmQYvvNGqopGV7ihobYzd45GWOgMXnvkz9w+kXE4NyWeMvXb6n
         46zdH9dKXvYSmcOI/fz6ShCxZzKDL3G0IPwsO9qIe7dp+kw18A+9ESUKNbcz6tVnBH41
         OBIg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792940161; x=1793544961; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=edJydXO8eM7QbcwRvjK6Scc5idFapwpqQSUYWRShZ90=;
        b=ZUVhuG+W4Hy7g+VMn4vFnG9Zgknbvfg2Odvq1PiMy0TsgDyObvMQNzjpfWX5aUHZ2e
         9PdK2VgmLvdtUDzAZ6URnjXtQw0yHPwiWbym/5yHbB47SS8YYceEsb2xQAcZj4N0SdGp
         WbHi5t0dsGwSgW3QfLt2wFkhSFTbVYbgRkE0p2I5pk4Bbz7PcP6jU06p9V72hC9p6Pg3
         lmqEvqm1dBSh8R9/XBV3VcrUKBSFpI+wiCoBQRMICGqo/qZ1cEJWXv1T1XZbJJUIH8Zj
         tpGKtdI71vLr8swMlQs52Bd6Ztg0WjwKPmWUEuGjWSJZ8VFckpKp7rjK8Cpb9p72HyXe
         vlfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792940161; x=1793544961;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=edJydXO8eM7QbcwRvjK6Scc5idFapwpqQSUYWRShZ90=;
        b=bZ2yZZ4RtOfc5JVcgARJRNvlNUSjnU5EzNKm9/HU3VHLU2jDHckNG/taQClCG0A7qI
         er/5QN6LYwbrt5hP9h74p6G7RsEAZ+JCF9PoorjcYIcT6e2VqBOT5gENFr5WMkJWSTk+
         unetv82p6sXWbbWIst6DQWC33llGNSthaN271J+RKBz7OSmhO8qFdfuhgnh98iHZWC2J
         0IKNSaEHEs9HYx1EOmG7VjWdZtubnpMhN+JtShHWpYeSOudxIQAV2h6OHWuHU4Z/BEHk
         27d6WAzjuU/sJ3cM6nGHWyf2vfVX2/tQ5Ik2A7ZH3KyL2zCBczMXvN6SicNtnQtEKI/F
         +Kzg==
X-Forwarded-Encrypted: i=1; AKwUvBytQ7EulYoLSzynK3LpeIcpdSF/7ILutN0V+QoAGCgkpdwtUsr2yK/edTHT/nHPuWaf7ELJLzxiwA==@kvack.org
X-Gm-Message-State: AFq9FYLOTm4FpcoBoxy57Pcy9crO0bmAzXZOxa2Z4mgLD1eZeCNWMPRb
	F8O/b0mQ1Xk6NqZlgW0iknBLRp9oQnefVG0beXq75S+2AUg800OaIk96fvmlfcbw/6F7wIrWJ9T
	GeQpI70UJElU4Zf6V594kAD9x4Zx/aaIrB8aM0TSh
X-Gm-Gg: AYBFou2mbTIAPmIA4VuOUloF5lFlIoopyk4vu2qsKOYq2niSgLZlygrlr8tzuTqgcIJ
	HQ4AGUgUrsqaBb8BqoMjvCbxfcFpUdn60Bl0Ag7bzYU4cQbCvwdsI0sXGynxsGba6FjDHhRc6as
	Wm+o6rndz0pkEr5tFtxVqYG2cmnTZZGc08pTmrjci1bVR26b7JsRlFKOuzcaHL5W82JzxaPkZzb
	+Aq296IsyNtaEwRcOx56kxUvKbrq1Yn1nfRujZrp3lfQiLqIqTexeuiSizwthXT9mlOj8wU4O99
	twwjGXCLCfIosCh1z20pbob3XfCATfcgMlrM6K3elFqNlFUc2t52rj2ampFRr9blfZaabwqZ8d2
	cbCnYEQA65wsN0UVp5mnVGfYL71VArPWIHLY=
X-Received: by 2002:a05:622a:1f12:b0:535:30a:76c7 with SMTP id
 d75a77b69052e-5383b47236amr21034181cf.3.1792940160515; Sun, 25 Oct 2026
 07:56:00 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261025-per_vma_maps-v1-1-c4eec45b9387@kernel.org>
In-Reply-To: <20261025-per_vma_maps-v1-1-c4eec45b9387@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 25 Oct 2026 07:55:48 -0700
X-Gm-Features: AclHuK8uFqepEAvLNHa3DmgUKJrQNAsjl4cEFXBDYXl8QDdPza9TmJXOwbUbspw
Message-ID: <CAJuCfpEk6H-wJvNqxSXTwj2NCjEMEzYr6MyHjRNRZjPC2AV2wA@mail.gmail.com>
Subject: Re: [PATCH] fs/proc/task_mmu: fix missed VMAs when reading
 /proc/PID/maps and friends
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3948F40004
X-Stat-Signature: 63zmtqgwacqyux6f3nnhhooarx8z1ziz
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792940162-685249
X-HE-Meta: U2FsdGVkX1+b4y87eSKOailQfFn3oJQEqotdNzl6c/MNTKEC6n+kKszeFZF6uKHBL1zahPDr3TkC1SvSRS3DhM03V0SIifOly3g3FNBx4MBFeEDCVSFEOMkLbo9ZCJoQWZ5Be1/f+d+NLOd8aZEUikiUoYkvuq8I8OhXzVFG8KHv8XMhKHSOYbaVRE89UvMzAvqmLh6ZElzxJ4POkV994RWwn2RIdlZDgfq7zMlP8VGrzWJ89b6fl547U9uP7AS+/lScHtpHkscrNKcTx8CO7BkQRVII1KfLnA8WfnqTGds9881H1VI17A069kw8/IgnPmEOJCZJWX6qLQhw7xNkNeTxy995r6OhPdy5oTklfQExUMHLfNUgjljfja2FjNROaQjXL/39WDnRHZWXJu3orVj/GAszE7yTAebniwpkA43xGL39xlhOnIte5qbSR2p2OXpTPdmK8WzxVHa9Ru5oxkNOklHC+xd8pg3GyrrrsoFR2ujULF7cdC30PPKF0Ll59i2JBakH4nQeZP0RqfKokIPT4f4/E+EEyRaw3jj+eekZTQCVtbRe5wp1wvLIkafJUJWJniKGFIymx5BW54z6wqzmjD0SgQZg9mrVUIDs6BI3xrwZqk6jGM/SZkGmP6P86T3+ojAXr7VT/wm1lVzTgupwpN4rAd91ewN1qeTxtabDTb+jyYVTkYyDQjHizvO31ZM1ojF9Mu7fkCSFbksxNuarzktOyWnefSWu/arKitATAsqyNZTgM02I/TIl2IIzN/1ANv7L6gD/Iqta/yvKFW8rdn80tExhzWWflubH2DJbnOP1TrGrsWG2Fv9jBwFAXR67kVNTJ+z2qT1Q4WKreEGYuWquPl9G3Wn2k3nm1zlrbnFmSDg1e8RwIw34ycOTlFuTNIs6PczXOa4KEPFGnJ9VCVcukb3QNL7hMqERvx/Nvx3uTJR4GsNNtntMxqmJNTRh5WsennP9nV60K7y
 H6GN2lJs
 P/AxXIwODzca19YjYbZhKurmZnLiI8CmgzcoJ1yGR4fA9HBiSo2j8cUjRT66tr1z3bSbeFv6Qlggob5ySi4JX30VVyrut8x/bAG7p8km0qqeLaVxxna27ttzdxlWVlVp6QIiE6aiPp0xSPomrqW4SHpW7te3f8kpt7hkbyGqlRu1oiiJVIKTA3+0aP0Vjfj/yTDs3VC89QYLNyUwjNLauH5h74Iw+r2pn4Yc+O7VBnXgFymR1fhsxF2WHQyneROtIfS6YUuaT6GT8zVEmLXlYNKxdhMj4jrqiAIHApZWuXAt5MpDU48LTnGBzXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 3:43=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> Reading /proc/PID/maps under per-VMA locks can skip continuously mapped
> address ranges during concurrent VMA splits or merges. This violates the
> guarantee in Documentation/filesystems/proc.rst:
>
>   "If there is something at a given vaddr during the entirety of the
>    life of the smaps/maps walk, there will be some output for it."
>
> lock_next_vma() reuses a tree iterator across calls under RCU. The iterat=
or
> remembers the range of its last entry. When its node is replaced,
> mas_next_slot() walks the tree again at the last index of that range, the=
n
> advances past the entry containing that index. If VMA boundaries changed,
> this can skip a range that has not been reported:
>
>  - A lookup finds [A, C), then mprotect() splits it into [A, B) and [B, C=
)
>    before vma_start_read() locks the first VMA. The reader reports [A, B)=
,
>    but the iterator still covers [A, C). The next call starts from B yet
>    advances past C, omitting [B, C).
>
>  - The reader reports [A, B) and unlocks it. A concurrent mprotect() then
>    merges it with [B, C). On the next call, the iterator resumes at B - 1=
,
>    which now belongs to [A, C), and advances past C. Again, [B, C) is los=
t.
>
> Checking the mmap_lock sequence only within the next call misses writers
> that completed before that call began. Also, a NULL result is currently
> accepted without validation, so a race can terminate the walk early.
>
> Even a fresh lookup can skip a mapping. Suppose it finds a gap before
> [B, C). A writer inserts an adjacent VMA at the end of that gap, then
> merges it into [B, C), replacing the node. The lookup resumes at the old
> gap's last index, now inside the merged VMA, and steps past it. The
> original [B, C) remains mapped throughout. Repeating the forward lookup
> is insufficient: another merge can make it skip the same mapping again,
> returning the same later VMA or NULL.
>
> The fresh-lookup race also affects /proc/PID/smaps, numa_maps and
> smaps_rollup. Resetting the iterator after gathering each VMA's statistic=
s
> does not prevent a merge during the next lookup. Fixing lock_next_vma()
> also prevents omitted entries and incomplete rollup statistics.
>
> Keep a saved sequence in the proc maps locking context and validate it
> before each lookup with mmap_lock_speculate_retry(). If it is even (no
> pending writer) and still matches, reuse both the iterator and the saved
> sequence. Otherwise, restart at from_addr and sample the current sequence
> before looking up the VMA. Only refresh the sample when resetting the
> iterator, so a writer between validation and the lookup cannot go
> undetected.
>
> The smp_rmb() in mmap_lock_speculate_retry() orders the previous lookup
> before rereading the sequence. It pairs with smp_wmb() in
> do_raw_write_seqcount_begin(), which separates the sequence increment in
> mmap_write_lock() from subsequent tree updates.
>
> Validate detected gaps (from_addr < vma->vm_start) and NULL from
> vma_next() against the sequence. If there were concurrent writes, use
> mas_walk() to check if the writer could have interfered with the range
> of interest. If the range is not empty, something interfered concurrently
> so we retry under mmap_lock. Checking for empty ranges avoids taking the
> mmap_lock just because an unrelated writer changed the sequence.
>
> Original fix generated by an LLM and sent by Josef Bacik in private.
>
> Fixes: 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma =
lock")
> Fixes: ea3085dd7a4e ("fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} u=
nder per-vma lock")
> Fixes: 0e985559d72a ("proc/task_mmu: read proc/pid/smaps_rollup under per=
-vma lock")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks for the report and the fix! Let me take a closer look. I took
extra care to ensure we do not skip any VMA but maybe I missed
something here.

> ---
> I neither understood nor liked the original LLM generated fix that was
> provided to me, and I (and codex) think it was incomplete. So I tried to
> come up with a better fix that avoids additional fallbacks to the mmap_lo=
ck
> while trying to keep it simple.
>
> I won't claim that I am now an expert on the code, or that this is the
> most elegant fix. It is quite complicated what we built ... too
> complicated. So if this goes into the wrong direction I'll be happy
> if someone else wants to take over ;)
>
> I reproduced the races with /proc/PID/maps, and with this patch they are
> resolved. I did not manage to reproduce the races with the new
> smaps/smaps_rollup, but the races are slightly different and harder to
> trigger.
>
> There is the issue with seqcount overflows that Lorenzo is tackling. It
> probably interacts here as well? Likely, but that's an independent issue
> to resolve.
> ---
>  fs/proc/internal.h        |  1 +
>  fs/proc/task_mmu.c        |  6 +++--
>  include/linux/mmap_lock.h |  5 ++--
>  mm/mmap_lock.c            | 58 +++++++++++++++++++++++++++++++++++------=
------
>  4 files changed, 51 insertions(+), 19 deletions(-)
>
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index df873df9afc56..f3e846b574d79 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -386,6 +386,7 @@ struct mem_size_stats;
>  struct proc_maps_locking_ctx {
>         struct mm_struct *mm;
>         bool mmap_locked;
> +       unsigned int mm_wr_seq;
>         struct vm_area_struct *locked_vma;
>  };
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index ee9fc2fd2b2fe..dc3adcffb6d9c 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -148,6 +148,7 @@ static void reset_lock_ctx(struct proc_maps_locking_c=
tx *lock_ctx)
>  {
>         lock_ctx->locked_vma =3D NULL;
>         lock_ctx->mmap_locked =3D false;
> +       lock_ctx->mm_wr_seq =3D UINT_MAX;
>  }
>
>  static struct vm_area_struct *get_next_vma(struct proc_maps_private *pri=
v,
> @@ -160,7 +161,8 @@ static struct vm_area_struct *get_next_vma(struct pro=
c_maps_private *priv,
>                 return vma_next(&priv->iter);
>
>         unlock_ctx_vma(lock_ctx);
> -       vma =3D lock_next_vma(lock_ctx->mm, &priv->iter, last_pos);
> +       vma =3D lock_next_vma(lock_ctx->mm, &priv->iter, last_pos,
> +                           &lock_ctx->mm_wr_seq);
>         if (!IS_ERR_OR_NULL(vma))
>                 lock_ctx->locked_vma =3D vma;
>
> @@ -523,7 +525,7 @@ static struct vm_area_struct *query_vma_find_by_addr(=
struct proc_maps_locking_ct
>         unlock_ctx_vma(lock_ctx);
>         rcu_read_lock();
>         vma_iter_init(&vmi, mm, addr);
> -       vma =3D lock_next_vma(mm, &vmi, addr);
> +       vma =3D lock_next_vma(mm, &vmi, addr, &lock_ctx->mm_wr_seq);
>         rcu_read_unlock();
>
>         if (!vma)
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 28e3696ce9ff3..e33d15ce6a876 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -511,12 +511,13 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm=
_struct *mm,
>   * Locks next vma pointed by the iterator. Confirms the locked vma has n=
ot
>   * been modified and will retry under mmap_lock protection if modificati=
on
>   * was detected. Should be called from read RCU section.
> + * *last_seq must initially be odd and is kept across calls.
>   * Returns either a valid locked VMA, NULL if no more VMAs or -EINTR if =
the
>   * process was interrupted.
>   */
>  struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
> -                                    struct vma_iterator *iter,
> -                                    unsigned long address);
> +               struct vma_iterator *vmi, unsigned long from_addr,
> +               unsigned int *last_seq);
>
>  static inline void vma_assert_can_modify(struct vm_area_struct *vma)
>  {
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 2f94ee0fdee2a..0f3a4e0c5520d 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -400,21 +400,50 @@ static struct vm_area_struct *lock_next_vma_under_m=
map_lock(struct mm_struct *mm
>         return vma;
>  }
>
> +static bool vma_range_is_empty(struct mm_struct *mm, unsigned long start=
,
> +               unsigned long last)
> +{
> +       MA_STATE(mas, &mm->mm_mt, start, start);
> +
> +       return !mas_walk(&mas) && mas.last >=3D last;
> +}
> +
>  struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
> -                                    struct vma_iterator *vmi,
> -                                    unsigned long from_addr)
> +               struct vma_iterator *vmi, unsigned long from_addr,
> +               unsigned int *last_seq)
>  {
>         struct vm_area_struct *vma;
> -       unsigned int mm_wr_seq;
>         bool mmap_unlocked;
>
>         RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu read lock held");
>  retry:
> -       /* Start mmap_lock speculation in case we need to verify the vma =
later */
> -       mmap_unlocked =3D mmap_lock_speculate_try_begin(mm, &mm_wr_seq);
> +       /*
> +        * Restart by address if a writer could have changed the cached r=
ange.
> +        * The retry check's smp_rmb() orders the previous lookup before =
reading
> +        * the sequence and pairs with smp_wmb() in do_raw_write_seqcount=
_begin().
> +        *
> +        * The vma_range_is_empty() checks below avoid unnecessary mmap_l=
ock
> +        * fallbacks.
> +        */
> +       mmap_unlocked =3D !(*last_seq & 1);
> +       if (!mmap_unlocked || mmap_lock_speculate_retry(mm, *last_seq)) {
> +               vma_iter_set(vmi, from_addr);
> +               mmap_unlocked =3D mmap_lock_speculate_try_begin(mm, last_=
seq);
> +       }
> +
>         vma =3D vma_next(vmi);
> -       if (!vma)
> -               return NULL;
> +       if (!vma) {
> +               /*
> +                * There is no reason to fallback if there really isn't a=
nything
> +                * in the remaining range.
> +                */
> +               if ((mmap_unlocked && !mmap_lock_speculate_retry(mm, *las=
t_seq)) ||
> +                   vma_range_is_empty(mm, from_addr, ULONG_MAX))
> +                       return NULL;
> +
> +               rcu_read_unlock();
> +               goto fallback;
> +       }
>
>         vma =3D vma_start_read(mm, vma);
>         if (IS_ERR_OR_NULL(vma)) {
> @@ -442,15 +471,14 @@ struct vm_area_struct *lock_next_vma(struct mm_stru=
ct *mm,
>          * it was not shrunk after we found it and another vma has not be=
en
>          * installed ahead of it. Otherwise we might observe a gap that s=
hould
>          * not be there.
> +        *
> +        * If speculation fails, avoid taking the mmap_lock when a direct=
 lookup
> +        * confirms that the gap is empty.
>          */
> -       if (from_addr < vma->vm_start) {
> -               /* Verify only if the address space might have changed si=
nce vma lookup. */
> -               if (!mmap_unlocked || mmap_lock_speculate_retry(mm, mm_wr=
_seq)) {
> -                       vma_iter_set(vmi, from_addr);
> -                       if (vma !=3D vma_next(vmi))
> -                               goto fallback_unlock;
> -               }
> -       }
> +       if (from_addr < vma->vm_start &&
> +           (!mmap_unlocked || mmap_lock_speculate_retry(mm, *last_seq)) =
&&
> +           !vma_range_is_empty(mm, from_addr, vma->vm_start - 1))
> +               goto fallback_unlock;
>
>         return vma;
>
>
> ---
>
> base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
>
> change-id: 20261025-per_vma_maps-ceab0eb860d5
>
> --
>
> Cheers,
>
> David
>

