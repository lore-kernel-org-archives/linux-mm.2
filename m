Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1019606A320
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=libQm8pj
Received: by kanga.kvack.org (Postfix)
	id DAEBB6B05BE; Sun,  8 Nov 2026 03:50:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85616B05BF; Sun,  8 Nov 2026 03:50:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9CBE6B05C0; Sun,  8 Nov 2026 03:50:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A47D66B05BE
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:50:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E23540343
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:50:33 +0000 (UTC)
X-FDA: 85411330746.01.ED97383
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5840A20007
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:50:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=libQm8pj;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794127831;
	b=oEmCEiVTkNqgvVie/BskcsFrMltEVKLZXgzrSokO2OaqgVFWij6QdVX+BPy4VTyC83hFH0
	Je3jUa51/0zx1FrMFJuPaax3rU50FKajTESSUgqcpl8dx+JIgR/63zHchnQPZu69tojaxn
	6FeDJj4WHGVruFTgPHZQE8EfBPn7sF8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=libQm8pj;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794127831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsg9qX9Duh1bo4M1Tai5hv+Sz6R+aE86ukM/XtuRQf4=;
	b=W1Ssn74eo/mCu17/2/I70jDG581I273QxqVSstGfoqAcDObACft2rtc1atfD6LLpTZcw90
	n2fgyR60ugNG77p1Dfpa4dNANRlb6FbNTrz2jUISw9uaYk9NPOzKz5JBSl1S4LO1T70ps1
	Cpc6GbEHsEZpc5bTDKYOqpMiUy2F838=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F030E614A9
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2F01F008A2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794127830;
	bh=wsg9qX9Duh1bo4M1Tai5hv+Sz6R+aE86ukM/XtuRQf4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=libQm8pjncVDF9r5oQpLQrQ6mfnG4HOrJBoGbS7Dj8OJp537IN50lfPP4MrtCKvp2
	 ptckO2iqHV7zY4sGWiz05zQ8vnW5pcPDbog4n+/NKNZDred+dHlL1iRBaUXq6w0H7v
	 2825HJaguuesy7OkyxQB/KM4aNReLCt7YTBEpGEeHX+ueHbOUA4+1vDWBeIM7w9Z0b
	 jboCkhI44cAXMQQsVqB04DUf3n8UaHV7QvcQgHIbzAYJTra36sWCkqnQgan/hLXZEM
	 Lebu2j2wRQ0ydjGrUTt3y1Uf6pK3rdUF7UNTaodLupZfB07D+luvMLBJpNBhKzR7HV
	 p48mUAqcaD19A==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93f30660e69so19477285a.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 00:50:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEaB1ECqjjn/k8rFvvRDm/ccs9XrU97Usyqgmay+UMSLpfVzrWTzeAODyfZa0BKz/J5OZ+aAhc23g==@kvack.org
X-Gm-Message-State: APuU4Z/NlzbPQc1O5s1S+GTKOC3S4CVa8PWIK3ZeVItR4SN8n6kKH7My
	O1QFKTOvxQIIpZlca1wIZIO2El+RF7uswAFyae32hPJvkwQE9siU83QVDFssSw3AHTH4hbJbz3e
	+RgeaR5AliqwSUDwHG+VAGIuXnjY2JdI=
X-Received: by 2002:a05:620a:2682:b0:945:b967:475f with SMTP id
 af79cd13be357-947841e9160mr121270285a.16.1794127830086; Sun, 08 Nov 2026
 00:50:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105132220.2233677-1-ridong.chen@linux.dev> <20261105132220.2233677-3-ridong.chen@linux.dev>
In-Reply-To: <20261105132220.2233677-3-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 8 Nov 2026 16:50:18 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wQC+d1ruhf+i6cETunK+h94z32-EHB=ghBQJ_rqVLNvg@mail.gmail.com>
X-Gm-Features: AclHuK--owIMPJ3Qjv3IT-ieNsbO9hCgnmZEQdRZt5zyNNTmndKmiQfuNxQFhKo
Message-ID: <CAGsJ_4wQC+d1ruhf+i6cETunK+h94z32-EHB=ghBQJ_rqVLNvg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] mm/mglru: skip the flags cmpxchg when nothing changes
To: Ridong Chen <ridong.chen@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Joanne Koong <joannelkoong@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: he35aoh87ac6yrhxxki8gzzq8i3uduc6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5840A20007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794127831-452433
X-HE-Meta: U2FsdGVkX18Igzgoh9WhW45EyrnUAT8hPB5bENSr66EMsAqqjF/9Z1Ag44qe+xEUkBoDrkW0oOM7mAV5tOLanky7qBTvLvidlrwxyPwPgtwlb0p3kI8JtEEA1jvs/u6eHIFaUG008uffrqx3C36cNY8aGaT89HyrpZr62IkQ4PerIuIJMW+uwRdBY5gTNKK2iIODqOdV1TppthSp5Nu+cgnj925dp17h4/l9ryfIOUpjjAnj90B8e6abEuSVLT5Oq/+OkpBDavhZGYNaz0gFjhjXulouOs6jUgasOikOq36FHXlZKLJ9cf9w9TaWYdC5R8+njIZMP4kqGsTNb13vqDrxzj97+8yuCdKY4p3VMPdogBqDiiOoR+ALLDD/X2wlvfBf+dFkLxyJTGf81053YZk4gH3+LwaZ42stZA5ljyxta9NVYC8bNFebdreY0CiuKR/BwIsPOMvXxnlGiiG2GB0w+Q6fALDiFHaf3jamKZzDdFtVhT4uFUrVtEUqbA8jqUvPRCPDKv3D4O4MbSRGxpnPFM+uQb56IGVDoCS2Xgho6S2TZONLCwBIuCxt2LTvc59Q3FouBvZeh+AbhZR1oxT7j/5qviKckDZBYXWBiz2LmfHKWeQOtgrC9eVtfKBXi/3kZyakWLXDSAhK3L47gznLcl8ALNIHnqYB5X6HkiIBrBQFiHHKE5Chhn7J5Zqbwm9hH1pST/Q4BouLgr7hiQg63+ANILx4qBojGIe8/NWn4fgJBAT4GBYrIwm9IsquztukkDjGaeif8OWZVtF0FH59Lam/fK253x+QK8YTzbC4VSS/cJuNiKoz+jS89hMzaAxKDAHn84ndnJqmVA8AOcsWokcJvDkNsLaLCffCtmMuF+gm64OJ26iABLHd1KPzprqKB89LPrmjUrjHx4mGJfWdLuN7D7r4rq+HKEP9AwgKNslY+TWtiNd4u0D/rzqpU8fJi9YdcEVj7+KHSKK
 4fCmdxRJ
 ST/pdfbaMcmEUMBTlUYiovY94GoEd/wZ8YzaqIFqkIppeIIy+OkDaDVxfwAvLM+uSKvTThIDJ0y9EdgN77oFymtej1FoUTal2TLJ2NBz14eq1Mhy9mSnn/CJ+JkVvdfvMgvqSrDSxrfbbo9ZPM/qrWtI9/bDhGEsKhCqC5WvPCSHz6pMQrd/8HHzA6CfG+ncJaQizoblfFuzMeY9Qx4pSWFnutrJ2XXj+OwjvmskwQNRw2zZxU4bBAU1jUdhaGzfET7M4sYzrrS88PzEiW5l0Z10TGyBY6vR5zdrRQ2BVy8xBVGKJMa4bZh4HKNp7ZSImwUavk3UX559vWJPoLP68DBrsYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 9:23=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev> =
wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> folio_update_gen() and folio_set_lru_refs() always end with a
> try_cmpxchg() on folio->flags, even when the new value equals the old
> one. The locked instruction still takes the struct page cacheline in
> exclusive state.
>
> That is common in practice: a folio mapped by many processes is visited
> once per mm during a page table walk, and after the first visit it is
> already in the youngest generation with refs cleared and PG_workingset
> set. isolate_folio() and the eviction paths also call
> folio_set_lru_refs(folio, 0) on folios whose refs are already zero.
>
> Break out of the loop when the flags would not change. The result is
> the same as a successful no-op cmpxchg. The only difference is that the
> full barrier implied by the locked instruction is gone on that path.

Hi Ridong,

I'm not quite sure this is an accurate description. The
atomic operation checks whether folio_flags(folio, 0)
has changed. If it has, we need to recompute new_flags
based on the updated old_flags.

For example:

CPU 0                          CPU 1
-----                          -----
read old_flags =3D A
                               change flags A -> B
new_flags =3D A
new_flags =3D=3D old_flags
break

This is how the CAS loop works. Whether we strictly
need the guarantees provided by CAS is a separate
question :-)

But skipping the CAS logic might slightly underestimate a
folio's hotness if it gets promoted twice? Perhaps the
race window is so small that the reduced CAS overhead
outweighs the impact on hotness tracking.

> No caller relies on it: the eviction and isolation callers run under
> the LRU lock, and the others (page table walks, folio_mark_accessed(),
> lru_gen_clear_refs()) only care about the resulting flags value, which
> is already in place. Note that lru_gen_inc_refs() already returns
> without any atomic when refs is at LRU_REFS_MAX and the folio is in
> the workingset.
>
> Tested on an i7-13700HX with turbo disabled and the performance
> governor. N processes map the same 2GiB tmpfs file (huge=3Dnever) and
> read every page, then one aging pass is triggered on their memcg
> through /sys/kernel/debug/lru_gen ("+ <memcg_id> 0 <max_seq> 200 1").
> Time per aging pass in ms, median of 5 runs of 10 passes each, averaged
> over 2 boots of each kernel:
>
>   processes    base   patched
>           1    32.9      31.7   -3.5%
>           8   195.1     160.2  -17.9%
>          32   755.8     592.2  -21.7%
>          64  1597.2    1260.6  -21.1%

Could we post the microbenchmark code here if it's
short enough?

>
> With one process, every visit changes the generation, so there is
> nothing to skip. Before the patch, perf annotate attributes 53-58% of
> the walk_update_folio() samples to the lock cmpxchg in the inlined
> folio_update_gen() in this test.
>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  include/linux/mm_inline.h | 2 ++
>  mm/vmscan.c               | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index b3d85fe91385..4ba9079f4dc8 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -244,6 +244,8 @@ static inline void folio_set_lru_refs(struct folio *f=
olio, unsigned int refs)
>         do {
>                 new_flags =3D old_flags;
>                 lru_set_refs_flags(&new_flags, refs);
> +               if (new_flags =3D=3D old_flags)
> +                       break;
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>  }
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 50c352e9ffef..3fa76715382d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3398,6 +3398,8 @@ static int folio_update_gen(struct folio *folio, in=
t new_gen, int *type,
>                 lru_set_gen_flags(&new_flags, new_gen);
>                 lru_set_refs_flags(&new_flags, 0);
>                 new_flags |=3D BIT(PG_workingset);
> +               if (new_flags =3D=3D old_flags)
> +                       break;
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
>         *type =3D folio_flags_is_file_lru(&old_flags);
> --
> 2.34.1
>

Thanks
Barry

