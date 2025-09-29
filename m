Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7399CAC5B9
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 18:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAADE8E001D; Mon, 29 Sep 2025 14:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5DB38E0002; Mon, 29 Sep 2025 14:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A128E001D; Mon, 29 Sep 2025 14:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80E958E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:17:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30C0C1604CE
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 18:17:46 +0000 (UTC)
X-FDA: 83943096132.17.69D3D5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2412FC0007
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 18:17:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uIoeEo7m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759169864; a=rsa-sha256;
	cv=none;
	b=jwptP9pwwXnUSbdpuIi6SQnZg70xzu7uJfNM1NXcUtW4cGYQ+Czy5DbtPIVaT502Ml/9+6
	HxQ8v/QPjKis/KdDNbCI/LBIXyBkqPHX3ZGS741ZaFKIlZTCkWYRFLLp2BcU5VPn21j235
	AJjYPMe1GC1AZAlFpG3nnAm2geKEJeE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uIoeEo7m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759169864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rbR40gIwz1eWno2qORrORtHBF7WKzEwOSgZS9A7bK9A=;
	b=OPSd6cEDnFuId3ou9dv00VL78EPpdCb0I7Fa6UmkSZ2SEA1/J7YnsQ2Z0s09b/bXURQF3T
	MTM4SeovTbTC2Yi+XlDjLDt1xlcWWJNESIwkQencvdt1uGiHq88P88oz5JzJR+tDIUA6pL
	oWxSaOvm564DGeNsrQs7AxfVrxBc78Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 13E08438B6
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 18:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D214CC4CEF5
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 18:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759169862;
	bh=hs7ZhVlHpDODW1RPNhtz1c+38OKVM5QvKR3052eMTDQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uIoeEo7mGSTCHG/lio9VDSkXsYXlroEDH/7bLKHQn3QhFujgwLWgZlE1S+fW603a3
	 4/OBmnFFLBg6KIFpqNRAlFtoDXSKciv7nZu3tRd/Hu3BvhNILloLW13jL+iY4UyqQo
	 I83P70NBjlLwGf048MLderCIzopJFhYGnYBwyElIpIyCxVvKh/ouSsw3G6V6u38YqQ
	 FdlKVxfETz60mgjihClr2aOeBqbM4vtFosi+GXpC6WrNCbrZcjfiD4GkXVlDGGrFtB
	 rREO6YIYJWzm6vpJpSrm6D4FcFUWluv6Lxw9YpneVp3S2j6zpaFc0wxP8k5O7EqowQ
	 3OhuxPaEtVrDw==
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-633b6595287so3611411d50.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:17:42 -0700 (PDT)
X-Gm-Message-State: AOJu0YzlUdKQajIYi2FwhNHt7ZsQ0Tio+bSMD3WNxm44P57sZEv3zAQZ
	t4gF/HS0hVzDiHufveFjkNRu31eh+IKPbcSQY/LA8LKokh+NNP/x3PrriuFa50yh3TcSULPAF6a
	tNkxpdNloIJhPqYSBFaKtvIpa6s+cKjPM4jYuuW7Bvw==
X-Google-Smtp-Source: AGHT+IGE6kd5xs0icSEEZdS7pVFN0cuwPwOYJEJUqimZ27ahOuuNINX3pZfMIADUMTyMWhWu/yapJRXNXT5lGOAZgi4=
X-Received: by 2002:a53:ea42:0:b0:63a:183:ffda with SMTP id
 956f58d0204a3-63a01a28749mr3923965d50.26.1759169862055; Mon, 29 Sep 2025
 11:17:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250927080635.1502997-1-jianyungao89@gmail.com>
In-Reply-To: <20250927080635.1502997-1-jianyungao89@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 29 Sep 2025 11:17:31 -0700
X-Gmail-Original-Message-ID: <CACePvbWkr79j-ogkp+-Eehx=pssTmb2Cb4npKGd0ehZE-qudcg@mail.gmail.com>
X-Gm-Features: AS18NWDO3sHve2jnUkOqUEozfH6mTV1MNP6z6MOxPopzdQLUYhEQ7K_wVAWGfWA
Message-ID: <CACePvbWkr79j-ogkp+-Eehx=pssTmb2Cb4npKGd0ehZE-qudcg@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix some typos in mm module
To: "jianyun.gao" <jianyungao89@gmail.com>
Cc: linux-mm@kvack.org, SeongJae Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"open list:DATA ACCESS MONITOR" <damon@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>, 
	"open list:KMSAN" <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2412FC0007
X-Stat-Signature: j8eskbr6ri151aeqsejt9eqkhd8o4acq
X-Rspam-User: 
X-HE-Tag: 1759169863-718057
X-HE-Meta: U2FsdGVkX1/b2g+/dWs7QGb7MOXlU4+qKkAJMd3+Ct8JCoQti8tOTtpSHynJZ4pCrpr82j6ff102QrH1IN4DVPSkeasBgmvQoZ4xDUq/pBeIojH0Xn3yEWTpKvbh7Ji6ALQznjFlPPVS6fBJZi3pvdbARTJK/m/YAF8vmAloYhGi2i5FIpYMAfSALhMdipEaYzgG3qkOILIt6ffkcAeRkZ/5tkvt1YM/xWY9ouzRNWUXDW4MIs1SRwa0ebL5rxeMJfkfTu38uJGXKuhSQWkAZHv+ivtydSh8pm2oFpYinmaE9YnaAx3K4JfYyTUN+KC+UsNtLygVR+u8ozzvWX4M21uiHEG3XWZsJ9VEnQ6SE7bzwAFuFYHsNh7xWYA0+6XHECNPfQ1IpqdGnCz7x51U4HQfN0dOpQfz1Lh1bydixh6koMcOJvcrSvtnxKAayvUXXzOkss5aziMSXoulWY9zegVm+yfUnmoNCwgcGFCRjSZNx+neRi2DVePrRKa5UzWN1s4nMWa1LPeFydcRXinU6Etjf+CXEaDZCMVoyhUfb/hIR1ZSlVKYHK75UwKeFbHaLtgJqwbOi/7jeSp1GxDKL0z8QcZNam5gN0MRAttZ60jAj0ZEordW9oNAKg6tV9SBXtTMU5AZGycJzrDhy8jBLsWumMXVDW3HUjBvYgCfiWm4B8PYRRKYxX1BrUxYy8o8m7IVdnlhzS72doLGksuMxLxDkpSR6TST+YuEMjoUb7AyExJ83Bn2VsTI+HCYx91t2OcUNBaUuJ468C57edixXv3iiwQGFLbZQA9EyNBxf+BNSEu1H2BCO0zNhGF8YNLpT00cS8/qLZukv1an+P82Be4dt+s2tokAHoWG95mnDEo1bORsI5TUp5B/JfKef2+aUnbDO+GN0LtsRv9Px8+mctKyd7XecJN/CYTJDj4mPVtK9Y05cncYyNY+O85z3qYJ+idjmahvtm+Dd6RGv8d
 5N4fDsgm
 hxunoEpiC/rxbW9gK5Nrj+d5gH3OiqQt17bfsbyI97ATPehQCjfKieHypmy7Leogmz5PY9RPTJxsnLNjkzPv7aKZc9H+ZrNc/7ka0vJyfxOcKUwg3Q9me58J/5QkDQFyrUgc9ZjpqPhENUrWNEizpIkCKzNM3YP0ceyTb+IpItiPYQ9JifWMwk4Caitkft6B/lCZelvrP1nOL7Hwl6UJ6Xwpz4HcvLmkxITpoZvw6jYZRILn7ZShkXRd2sOgDUoiIJ8QPz3t8iJbWezWYuIslErznpLLJ7V4t9PlMvqxA8jcAL0osGQMcNhAI2ZQ8nj1rWb+3y/Lp8e+MnWnVbPE52TQwz7j0jUWSMTQ/ng551oxSfzU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Sat, Sep 27, 2025 at 1:07=E2=80=AFAM jianyun.gao <jianyungao89@gmail.com=
> wrote:
>
> Below are some typos in the code comments:
>
>   intevals =3D=3D> intervals
>   addesses =3D=3D> addresses
>   unavaliable =3D=3D> unavailable
>   facor =3D=3D> factor
>   droping =3D=3D> dropping
>   exlusive =3D=3D> exclusive
>   decription =3D=3D> description
>   confict =3D=3D> conflict
>   desriptions =3D=3D> descriptions
>   otherwize =3D=3D> otherwise
>   vlaue =3D=3D> value
>   cheching =3D=3D> checking
>   exisitng =3D=3D> existing
>   modifed =3D=3D> modified
>
> Just fix it.
>
> Signed-off-by: jianyun.gao <jianyungao89@gmail.com>
> ---
>  mm/damon/sysfs.c  | 2 +-
>  mm/gup.c          | 2 +-
>  mm/kmsan/core.c   | 2 +-
>  mm/ksm.c          | 2 +-
>  mm/memory-tiers.c | 2 +-
>  mm/memory.c       | 4 ++--
>  mm/secretmem.c    | 2 +-
>  mm/slab_common.c  | 2 +-
>  mm/slub.c         | 2 +-
>  mm/swapfile.c     | 2 +-
>  mm/userfaultfd.c  | 2 +-
>  mm/vma.c          | 4 ++--
>  12 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index c96c2154128f..25ff8bd17e9c 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1232,7 +1232,7 @@ enum damon_sysfs_cmd {
>         DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS,
>         /*
>          * @DAMON_SYSFS_CMD_UPDATE_TUNED_INTERVALS: Update the tuned moni=
toring
> -        * intevals.
> +        * intervals.
>          */
>         DAMON_SYSFS_CMD_UPDATE_TUNED_INTERVALS,
>         /*
> diff --git a/mm/gup.c b/mm/gup.c
> index 0bc4d140fc07..6ed50811da8f 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2730,7 +2730,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>   *
>   *  *) ptes can be read atomically by the architecture.
>   *
> - *  *) valid user addesses are below TASK_MAX_SIZE
> + *  *) valid user addresses are below TASK_MAX_SIZE
>   *
>   * The last two assumptions can be relaxed by the addition of helper fun=
ctions.
>   *
> diff --git a/mm/kmsan/core.c b/mm/kmsan/core.c
> index 1ea711786c52..1bb0e741936b 100644
> --- a/mm/kmsan/core.c
> +++ b/mm/kmsan/core.c
> @@ -33,7 +33,7 @@ bool kmsan_enabled __read_mostly;
>
>  /*
>   * Per-CPU KMSAN context to be used in interrupts, where current->kmsan =
is
> - * unavaliable.
> + * unavailable.
>   */
>  DEFINE_PER_CPU(struct kmsan_ctx, kmsan_percpu_ctx);
>
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 160787bb121c..edd6484577d7 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -389,7 +389,7 @@ static unsigned long ewma(unsigned long prev, unsigne=
d long curr)
>   * exponentially weighted moving average. The new pages_to_scan value is
>   * multiplied with that change factor:
>   *
> - *      new_pages_to_scan *=3D change facor
> + *      new_pages_to_scan *=3D change factor
>   *
>   * The new_pages_to_scan value is limited by the cpu min and max values.=
 It
>   * calculates the cpu percent for the last scan and calculates the new
> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> index 0382b6942b8b..f97aa5497040 100644
> --- a/mm/memory-tiers.c
> +++ b/mm/memory-tiers.c
> @@ -519,7 +519,7 @@ static inline void __init_node_memory_type(int node, =
struct memory_dev_type *mem
>          * for each device getting added in the same NUMA node
>          * with this specific memtype, bump the map count. We
>          * Only take memtype device reference once, so that
> -        * changing a node memtype can be done by droping the
> +        * changing a node memtype can be done by dropping the
>          * only reference count taken here.
>          */
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 0ba4f6b71847..d6b0318df951 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4200,7 +4200,7 @@ static inline bool should_try_to_free_swap(struct f=
olio *folio,
>          * If we want to map a page that's in the swapcache writable, we
>          * have to detect via the refcount if we're really the exclusive
>          * user. Try freeing the swapcache to get rid of the swapcache
> -        * reference only in case it's likely that we'll be the exlusive =
user.
> +        * reference only in case it's likely that we'll be the exclusive=
 user.
>          */
>         return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio)=
 &&
>                 folio_ref_count(folio) =3D=3D (1 + folio_nr_pages(folio))=
;
> @@ -5274,7 +5274,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct =
folio *folio, struct page *pa
>
>  /**
>   * set_pte_range - Set a range of PTEs to point to pages in a folio.
> - * @vmf: Fault decription.
> + * @vmf: Fault description.
>   * @folio: The folio that contains @page.
>   * @page: The first page to create a PTE for.
>   * @nr: The number of PTEs to create.
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 60137305bc20..a350ca20ca56 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -227,7 +227,7 @@ SYSCALL_DEFINE1(memfd_secret, unsigned int, flags)
>         struct file *file;
>         int fd, err;
>
> -       /* make sure local flags do not confict with global fcntl.h */
> +       /* make sure local flags do not conflict with global fcntl.h */
>         BUILD_BUG_ON(SECRETMEM_FLAGS_MASK & O_CLOEXEC);
>
>         if (!secretmem_enable || !can_set_direct_map())
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index bfe7c40eeee1..9ab116156444 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -256,7 +256,7 @@ static struct kmem_cache *create_cache(const char *na=
me,
>   * @object_size: The size of objects to be created in this cache.
>   * @args: Additional arguments for the cache creation (see
>   *        &struct kmem_cache_args).
> - * @flags: See the desriptions of individual flags. The common ones are =
listed
> + * @flags: See the descriptions of individual flags. The common ones are=
 listed
>   *         in the description below.
>   *
>   * Not to be called directly, use the kmem_cache_create() wrapper with t=
he same
> diff --git a/mm/slub.c b/mm/slub.c
> index d257141896c9..5f2622c370cc 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2412,7 +2412,7 @@ bool slab_free_hook(struct kmem_cache *s, void *x, =
bool init,
>                 memset((char *)kasan_reset_tag(x) + inuse, 0,
>                        s->size - inuse - rsize);
>                 /*
> -                * Restore orig_size, otherwize kmalloc redzone overwritt=
en
> +                * Restore orig_size, otherwise kmalloc redzone overwritt=
en
>                  * would be reported
>                  */
>                 set_orig_size(s, x, orig_size);
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index b4f3cc712580..b55f10ec1f3f 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1545,7 +1545,7 @@ static bool swap_entries_put_map_nr(struct swap_inf=
o_struct *si,
>
>  /*
>   * Check if it's the last ref of swap entry in the freeing path.
> - * Qualified vlaue includes 1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM.
> + * Qualified value includes 1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM.
>   */
>  static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
>  {
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index aefdf3a812a1..333f4b8bc810 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1508,7 +1508,7 @@ static int validate_move_areas(struct userfaultfd_c=
tx *ctx,
>
>         /*
>          * For now, we keep it simple and only move between writable VMAs=
.
> -        * Access flags are equal, therefore cheching only the source is =
enough.
> +        * Access flags are equal, therefore checking only the source is =
enough.
>          */
>         if (!(src_vma->vm_flags & VM_WRITE))
>                 return -EINVAL;
> diff --git a/mm/vma.c b/mm/vma.c
> index 3b12c7579831..2e127fa97475 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -109,7 +109,7 @@ static inline bool is_mergeable_vma(struct vma_merge_=
struct *vmg, bool merge_nex
>  static bool is_mergeable_anon_vma(struct vma_merge_struct *vmg, bool mer=
ge_next)
>  {
>         struct vm_area_struct *tgt =3D merge_next ? vmg->next : vmg->prev=
;
> -       struct vm_area_struct *src =3D vmg->middle; /* exisitng merge cas=
e. */
> +       struct vm_area_struct *src =3D vmg->middle; /* existing merge cas=
e. */
>         struct anon_vma *tgt_anon =3D tgt->anon_vma;
>         struct anon_vma *src_anon =3D vmg->anon_vma;
>
> @@ -798,7 +798,7 @@ static bool can_merge_remove_vma(struct vm_area_struc=
t *vma)
>   * Returns: The merged VMA if merge succeeds, or NULL otherwise.
>   *
>   * ASSUMPTIONS:
> - * - The caller must assign the VMA to be modifed to @vmg->middle.
> + * - The caller must assign the VMA to be modified to @vmg->middle.
>   * - The caller must have set @vmg->prev to the previous VMA, if there i=
s one.
>   * - The caller must not set @vmg->next, as we determine this.
>   * - The caller must hold a WRITE lock on the mm_struct->mmap_lock.
> --
> 2.34.1
>

