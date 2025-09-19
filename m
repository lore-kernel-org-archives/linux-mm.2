Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3DDECA1013
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 05:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5E528003E; Fri, 19 Sep 2025 01:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A69628000F; Fri, 19 Sep 2025 01:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0965528003E; Fri, 19 Sep 2025 01:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E716928000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:45:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B706B59736
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:45:37 +0000 (UTC)
X-FDA: 83904912714.04.362983D
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id EB38440005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:45:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YpH7haql;
	spf=pass (imf27.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758260736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9QFV5KUaaHxn5Z+Mu6f039n9KMAZGTTLsVbnmKplSM=;
	b=6h6cHqVsXkKeYi1mOa9BjZOkZZOBnIn5oLBYrvqOSBoPxRqpyyq1gBe6bcE3JDBPHlUt4M
	ReROwnjf3Kb7RAgLLYjReap8oJMYwN2A1eAixHrvHlSKhviMDpmRkr9AC8VbTyNVQdt8HI
	elHhCwjD/dBRv+iolqy8LDRgRmsk55o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YpH7haql;
	spf=pass (imf27.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758260736; a=rsa-sha256;
	cv=none;
	b=r79nCTmDJUzbVNyh+kqys2VwRqNBCCGnYh3OAnRlJPTGdPN8+9YLKrXZmsI7Fe6EknLPa0
	uzXXNgy/7rjyI00mZSo4RXXcRwKn/0argecWF6wv1+0CJcEcsGiyAgx6pQ6GTuYuI+fw3c
	D/fXrfVw2IeefBVaIaBUj7OHev4i/Yw=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-62fa84c6916so8775a12.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758260734; x=1758865534; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J9QFV5KUaaHxn5Z+Mu6f039n9KMAZGTTLsVbnmKplSM=;
        b=YpH7haqlkYnDwvqTnt82khYF6ompsxQq3Gk07VyqB9CLwm15wN4YUpfVAk4xFdE/d3
         E/DWbvV3LbmCBqkUhhmL3lXCvzt3ln2Aq6klPVGcTJEPpxZo3rku7dtSo/qQglJSDoNG
         fz6ZdaH81x18Uw+TNYEXAeOI7Aw4XhfnHdrpg2WJ1JInFQtF1KqqThU8n/4+jK0syGcn
         YUMNnznh9IodAmuWMZNdCl7fALm7aD0W/4aBCuRHHYsP8Y5cHKrKQ01EoJ2YAXVFaI2+
         9LwjlgogmFTU+pEcI3gF0NCIvGXoD3LPfovGZrMfAw4EL/+TZPTD21t0a7G0qsTnnicd
         LleA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758260734; x=1758865534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J9QFV5KUaaHxn5Z+Mu6f039n9KMAZGTTLsVbnmKplSM=;
        b=S3srQstl8mj1polg4O5g8OqK7l2g2/9lkuvO3ocCMS0diMs5be/5KC9737EqLabyQ3
         6qqCuzSxC+a6qk0GNmLORXFu+vOcrE/UCpdyFpb3jPS9dNRpJEmi2/cHjUl68HkFMe3f
         X01pZWp2OTfxqwPD6AieKHCggzea2I+OU7HZhzT3IM6ZiQgPEASTPeUE7paZDBlwLz9S
         dC9oNFcJnKQjyFjldKeOQ/uHKzDZ0GBBR95h5L2snc0ihgXiIjNBtaTsdBo74lfqZtHq
         B6hs5BpeXGFV/lCGsUrdvPOAjBJgLMZ7NiOIPWZjegaKP9hZNpfKoK/8MRAT3WVqDSd6
         PPSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhBFZ/KbKOakHUoW/lq9TWe8X7/GvPQ2FWsTHvPCwCMQX2slPWXzrJ3fZSgZewuwuMB/DSTH85AA==@kvack.org
X-Gm-Message-State: AOJu0Yy2ydGYTHLIKNOrY4VOrA3uA2QlnfAQRKKegaqW6KoR4w0q+Dr4
	AZcmqPVl4bDKMdCjYMgWtRPMQhCexbLj48qstAvLlHj9PZFQavbIO/9NvS19dpKPFEQNyg0n020
	Ugq/PdF0tojqKCyC/SKipqzd/V8krGdS838KbKw3d
X-Gm-Gg: ASbGnctFRU4mP365B27Aub9q6w8kTnDMBiwb9+EuxdPMybYilQZBKM5nHuxS+aov8jr
	obZDFUYS3HiCmdOrCcr1KJabh61/HFF5MaDx0UdIrHbTRhg7wF0hJ11dm/AH3/PjyScXLw1T+lv
	9ucYoeX6Rgvw1AW+sjAqi/G6DgebbfFl3BamSLTimymIo4bjC06i2VH+cHXr6rO0354lK0Ac2M7
	GBa5pAv958g3i+I3xaskz6atDkLnYtM89rBYoPD3dfofg==
X-Google-Smtp-Source: AGHT+IFhY6QYDsY+elVK4a+/xir506Ptre5Hi/i8tUSwpyXEBqRgmlXIU++7fk5B4Ty84hoIyHwInCHgn7upG7ZT6s8=
X-Received: by 2002:a05:6402:28a9:b0:62f:c78f:d0d4 with SMTP id
 4fb4d7f45d1cf-62fc78fd2b5mr15532a12.6.1758260733935; Thu, 18 Sep 2025
 22:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com> <0ea92729-2403-4de8-9ddc-a1c7bb2121c3@lucifer.local>
In-Reply-To: <0ea92729-2403-4de8-9ddc-a1c7bb2121c3@lucifer.local>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Thu, 18 Sep 2025 22:45:21 -0700
X-Gm-Features: AS18NWAeql10q9hLa4gqqQibeblMAi2TbvIRupMpmGvYTECczPCogqwbhqMbBaY
Message-ID: <CA+EESO7yyhNH6TYza+j7h9JZb1_1eHdd1x3ASmuNga2yYng4JQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, jannh@google.com, David Hildenbrand <david@redhat.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EB38440005
X-Stat-Signature: rrc6ozkf13gbatpt7euix61d11tycudx
X-HE-Tag: 1758260735-966605
X-HE-Meta: U2FsdGVkX1+1+UmgBJhJhPFSOLAaQUc/8IP5qq6JGokoAxEnD7VqPFe7+T5zaXWIpzSnhSurpdyd7mub7DTcDTVFmEHnV1Po7EVslaY9FvobCcIFq6uAGoJggGOX9G9EZlffLF7yfAl/VDFegYNk9VvWmtQDmOC4y66OKAl+cyqjg2/aWrdZHEy+q74P2/UGdbLXY0+nfXX5qz6dFFDxXu34nCDhJGuI/bffEZvHMM/0metQqwAe1txye2W8+phHEcChXiXBBr2NFPijMAUWjXRhixYtfOrpVmQu4jAAYXI8BQiQjWMoGZXRG54VyveL552H19T44uMhjY00eirxCZTDYiI3lUtL2GYFgac7Rukq34BK2U1z+vLi+VEyFeb44bDPxctKZfmVKdiB51BcFNM7TRr5A8cwhbOSSqlSsIUlMUxbGcw1aEm61mpwTZAmOcNwGJesh7+sung2JsKH/f4exhTYGFZbllxkNdqHfKFKJGXCsrzGKRtSh+7ncSVdBEIGlHCU5CN1zDEskjGR8XZ3yItpUjP/uojZ5ux+ayE8LQW3EXPEoqDh1qLhrlyqSaSMavsaGnyOvfpwsXl+B3p5Vkku9ngyFW8hf6LyR3HBfcZKxkG7NtD3+kUda1+epmZlgZIBgrGuhkOTeaYbmyvkc71VVk9A1coYXuhyOvZ6lzI5fmYwOWxJPmEBtOlYE0fLsQNF8B4j+bfxw7+L0B9PISG7EU4r3IF4baU7Fk3s+WzMfUzCCrFzQ692liTc9y5sZh6hWzqt/51FsTR5rarrzKU/tgvj7I4KwOanq4TUEVkPIfnLvyygCnWY0XScCorzz1kFrnAFVR1RxGOON+1qdTB7L8erjo9Ri42mzQt4sRnQCSjuixr7g4eytvpFawSc6JToiTsPv+XN1LDLJGvLNNN8QCVnTNHqcKY/LE5ckZEeaojPu4tatI2sYEnCjumfSDjRdUY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 4:57=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Sep 17, 2025 at 10:51:34PM -0700, Lokesh Gidra wrote:
> > Guarantee that rmap_walk() is called on locked folios so that threads
> > changing folio->mapping and folio->index for non-KSM anon folios can
> > serialize on fine-grained folio lock rather than anon_vma lock. Other
> > folio types are already always locked before rmap_walk().
>
> Be good to explain why you're doing certain things, like adding the folio
> lock to kill_procs_now().

Agreed! I'll add in the next version.
>
> Also worth noting that you're going from _definitely_ locking non-KSM ano=
n
> to _not necessarily_ locking it.

Will do. But, just to be clear, you mean the opposite right?
>
> You should explain why you think this is fine (in general - rmap callers =
do
> some other check to see if what is expected to mapped did happen so it's
> fine, or otherwise treat things as best-effort).

Sure thing.
>
> You should probably also put some information about performance impact
> here, I think Barry provided some?
>
I added that in the cover letter. Basically the impact of trylocking
non-KSM anon folios (in folio_referenced()) on active_shrink_list().
I'll move it here.
> >
> > This is in preparation for removing anon_vma write-lock from
> > UFFDIO_MOVE.
>
> Thanks for mentioning this :)
>
I got your message loud and clear the last time :)
> >
> > CC: David Hildenbrand <david@redhat.com>
> > CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > CC: Harry Yoo <harry.yoo@oracle.com>
> > CC: Peter Xu <peterx@redhat.com>
> > CC: Suren Baghdasaryan <surenb@google.com>
> > CC: Barry Song <baohua@kernel.org>
> > CC: SeongJae Park <sj@kernel.org>
> > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
>
> OK so you're making:
>
> folio_lock_anon_vma_read()
> folio_get_anon_vma()
>
> Require folio locks.
>
> folio_lock_anon_vma_read() is called from:
>
> connect_procs_anon() - changed to take folio lock.
> page_idle_clear_pte_refs() - changed to take folio lock.
> damon_folio_mkold() - changed to take folio lock.
> damon_folio_young() - changed to take folio lock.
> folio_referenced() - changed to take folio lock.
> try_to_unmap() - ???
> try_to_migrate() - ???
>
> 9I note that we allow a TTU_RMAP_LOCKED walk in the above unmap, migrate
> cases too, wonder how these will interact?)
>
> folio_get_anon_vma() is called from:
>
> move_pages_huge_pmd() - already holds folio lock.
> __folio_split() - already holds folio lock.
> move_pages_ptes() [uffd] - already holds folio lock.
> migrate_folio_unmap() - already holds folio lock.
> unmap_and_move_huge_page() - already holds folio lock.
>
> Can you:
>
> a. Confirm the try_to_unmap() and try_to_migrate() cases take the folio
>    lock. Explicitly list the callers and how they acquire the folio lock.
>
Description comments of both try_to_migrate() and try_to_unmap() say
that the caller must hold folio lock. But just to be safe, I went
through all the callers, and all of them are holding the folio lock:

try_to_unmap() is called from:
unmap_folio()
collapse_file()
shrink_folio_list()
shink_folio_list()->unmap_poisoned_folio()
do_migrate_range()->unmap_poisoned_folio()
try_memory_failure_hugetlb()->hwpoison_user_mappings()->unmap_poisoned_foli=
o()
memory_failure()->hwpoison_user_mappings()->unmap_poisoned_folio()

try_to_migrate() is called from:
unmap_folio()
unmap_and_move_huge_page()
migrate_folio_unmap()
migrate_vma_collect()->migrate_vma_collect_pmd() acquires in case of
migrate_vma_setup()->migrate_vma_unmap()->migrate_device_unmap()
migrate_device_pfn_lock() acquires folio locks in the following cases:
migrate_device_range()->migrate_device_unmap()
migrate_device_pfns()->migrate_device_unmap()

All the callers of rmap_walk()/rmap_walk_locked() are already covered
in the folio_lock_anon_vma_read() list that you added, except
remove_migration_ptes(), which is called from:
__folio_split()->remap_page()
migrate_device_unmap()
__migrate_device_finalize()
unmap_and_move_huge_page()
migrate_folio_unmap() locks the folio for the following two in
migrate_pages_batch():
migrate_folio_move()
migrate_folio_undo_src()

> b. Update the commit message to include the above. You're making a _very_
>    sensitive locking change here, it's important to demonstrate that you'=
ve
>    considered all cases.
Certainly, will do.
>
> Thanks!
>
> > ---
> >  mm/damon/ops-common.c | 16 ++++------------
> >  mm/memory-failure.c   |  3 +++
> >  mm/page_idle.c        |  8 ++------
> >  mm/rmap.c             | 42 ++++++++++++------------------------------
> >  4 files changed, 21 insertions(+), 48 deletions(-)
> >
> > diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> > index 998c5180a603..f61d6dde13dc 100644
> > --- a/mm/damon/ops-common.c
> > +++ b/mm/damon/ops-common.c
> > @@ -162,21 +162,17 @@ void damon_folio_mkold(struct folio *folio)
> >               .rmap_one =3D damon_folio_mkold_one,
> >               .anon_lock =3D folio_lock_anon_vma_read,
> >       };
> > -     bool need_lock;
> >
> >       if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
> >               folio_set_idle(folio);
> >               return;
> >       }
> >
> > -     need_lock =3D !folio_test_anon(folio) || folio_test_ksm(folio);
> > -     if (need_lock && !folio_trylock(folio))
> > +     if (!folio_trylock(folio))
> >               return;
>
> This _seems_ to be best effort and not relying on anon always
> succeeding. So should be fine.
>
> >
> >       rmap_walk(folio, &rwc);
> > -
> > -     if (need_lock)
> > -             folio_unlock(folio);
> > +     folio_unlock(folio);
> >
> >  }
> >
> > @@ -228,7 +224,6 @@ bool damon_folio_young(struct folio *folio)
> >               .rmap_one =3D damon_folio_young_one,
> >               .anon_lock =3D folio_lock_anon_vma_read,
> >       };
> > -     bool need_lock;
> >
> >       if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
> >               if (folio_test_idle(folio))
> > @@ -237,14 +232,11 @@ bool damon_folio_young(struct folio *folio)
> >                       return true;
> >       }
> >
> > -     need_lock =3D !folio_test_anon(folio) || folio_test_ksm(folio);
> > -     if (need_lock && !folio_trylock(folio))
> > +     if (!folio_trylock(folio))
> >               return false;
>
> Same as above here.
>
> >
> >       rmap_walk(folio, &rwc);
> > -
> > -     if (need_lock)
> > -             folio_unlock(folio);
> > +     folio_unlock(folio);
> >
> >       return accessed;
> >  }
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index a24806bb8e82..f698df156bf8 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -2143,7 +2143,10 @@ static void kill_procs_now(struct page *p, unsig=
ned long pfn, int flags,
> >  {
> >       LIST_HEAD(tokill);
> >
> > +     folio_lock(folio);
> >       collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
> > +     folio_unlock(folio);
> > +
>
> Good. I hate how this works.
>
> >       kill_procs(&tokill, true, pfn, flags);
> >  }
> >
> > diff --git a/mm/page_idle.c b/mm/page_idle.c
> > index a82b340dc204..9bf573d22e87 100644
> > --- a/mm/page_idle.c
> > +++ b/mm/page_idle.c
> > @@ -101,19 +101,15 @@ static void page_idle_clear_pte_refs(struct folio=
 *folio)
> >               .rmap_one =3D page_idle_clear_pte_refs_one,
> >               .anon_lock =3D folio_lock_anon_vma_read,
> >       };
> > -     bool need_lock;
> >
> >       if (!folio_mapped(folio) || !folio_raw_mapping(folio))
> >               return;
> >
> > -     need_lock =3D !folio_test_anon(folio) || folio_test_ksm(folio);
> > -     if (need_lock && !folio_trylock(folio))
> > +     if (!folio_trylock(folio))
> >               return;
>
> This checks folio idle bit after so that's fine for anon to not succeed d=
ue
> to contention.
>
> >
> >       rmap_walk(folio, &rwc);
> > -
> > -     if (need_lock)
> > -             folio_unlock(folio);
> > +     folio_unlock(folio);
> >  }
> >
> >  static ssize_t page_idle_bitmap_read(struct file *file, struct kobject=
 *kobj,
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 34333ae3bd80..90584f5da379 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -489,17 +489,15 @@ void __init anon_vma_init(void)
> >   * if there is a mapcount, we can dereference the anon_vma after obser=
ving
> >   * those.
> >   *
> > - * NOTE: the caller should normally hold folio lock when calling this.=
  If
> > - * not, the caller needs to double check the anon_vma didn't change af=
ter
> > - * taking the anon_vma lock for either read or write (UFFDIO_MOVE can =
modify it
> > - * concurrently without folio lock protection). See folio_lock_anon_vm=
a_read()
> > - * which has already covered that, and comment above remap_pages().
> > + * NOTE: the caller should hold folio lock when calling this.
> >   */
> >  struct anon_vma *folio_get_anon_vma(const struct folio *folio)
> >  {
> >       struct anon_vma *anon_vma =3D NULL;
> >       unsigned long anon_mapping;
> >
> > +     VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> > +
> >       rcu_read_lock();
> >       anon_mapping =3D (unsigned long)READ_ONCE(folio->mapping);
> >       if ((anon_mapping & FOLIO_MAPPING_FLAGS) !=3D FOLIO_MAPPING_ANON)
> > @@ -546,7 +544,8 @@ struct anon_vma *folio_lock_anon_vma_read(const str=
uct folio *folio,
> >       struct anon_vma *root_anon_vma;
> >       unsigned long anon_mapping;
> >
> > -retry:
> > +     VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> > +
> >       rcu_read_lock();
> >       anon_mapping =3D (unsigned long)READ_ONCE(folio->mapping);
> >       if ((anon_mapping & FOLIO_MAPPING_FLAGS) !=3D FOLIO_MAPPING_ANON)
> > @@ -557,17 +556,6 @@ struct anon_vma *folio_lock_anon_vma_read(const st=
ruct folio *folio,
> >       anon_vma =3D (struct anon_vma *) (anon_mapping - FOLIO_MAPPING_AN=
ON);
> >       root_anon_vma =3D READ_ONCE(anon_vma->root);
> >       if (down_read_trylock(&root_anon_vma->rwsem)) {
> > -             /*
> > -              * folio_move_anon_rmap() might have changed the anon_vma=
 as we
> > -              * might not hold the folio lock here.
> > -              */
> > -             if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
=3D
> > -                          anon_mapping)) {
> > -                     up_read(&root_anon_vma->rwsem);
> > -                     rcu_read_unlock();
> > -                     goto retry;
> > -             }
> > -
> >               /*
> >                * If the folio is still mapped, then this anon_vma is st=
ill
> >                * its anon_vma, and holding the mutex ensures that it wi=
ll
> > @@ -602,18 +590,6 @@ struct anon_vma *folio_lock_anon_vma_read(const st=
ruct folio *folio,
> >       rcu_read_unlock();
> >       anon_vma_lock_read(anon_vma);
> >
> > -     /*
> > -      * folio_move_anon_rmap() might have changed the anon_vma as we m=
ight
> > -      * not hold the folio lock here.
> > -      */
> > -     if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=3D
> > -                  anon_mapping)) {
> > -             anon_vma_unlock_read(anon_vma);
> > -             put_anon_vma(anon_vma);
> > -             anon_vma =3D NULL;
> > -             goto retry;
> > -     }
> > -
> >       if (atomic_dec_and_test(&anon_vma->refcount)) {
> >               /*
> >                * Oops, we held the last refcount, release the lock
> > @@ -1005,7 +981,7 @@ int folio_referenced(struct folio *folio, int is_l=
ocked,
> >       if (!folio_raw_mapping(folio))
> >               return 0;
> >
> > -     if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(foli=
o))) {
> > +     if (!is_locked) {
> >               we_locked =3D folio_trylock(folio);
> >               if (!we_locked)
> >                       return 1;
> > @@ -2815,6 +2791,12 @@ static void rmap_walk_anon(struct folio *folio,
> >       pgoff_t pgoff_start, pgoff_end;
> >       struct anon_vma_chain *avc;
> >
> > +     /*
> > +      * The folio lock ensures that folio->mapping can't be changed un=
der us
> > +      * to an anon_vma with different root.
> > +      */
> > +     VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> > +
> >       if (locked) {
> >               anon_vma =3D folio_anon_vma(folio);
> >               /* anon_vma disappear under us? */
> > --
> > 2.51.0.384.g4c02a37b29-goog
> >
> >
>
> All of the above actual changes to the locking logic looks ok to me thoug=
h.
Awesome! :)

