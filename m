Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B1FF45A0D
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 00:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27AD6B0089; Fri, 10 Apr 2026 20:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFF296B008A; Fri, 10 Apr 2026 20:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14B16B0092; Fri, 10 Apr 2026 20:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF94A6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 20:24:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 732721406A4
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:24:42 +0000 (UTC)
X-FDA: 84644379204.11.1D2AE6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5962E4000D
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:24:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aV0OuPL/";
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775867080; a=rsa-sha256;
	cv=none;
	b=jhkvpZGceJSgBFnst/J5xxN+Acv3XCA9VCYTDkzwlP8gRZPA3vjnWFi6qUtb2c1/6ExYkN
	NimRLDOBdM92YLZjfDBPkpiTM108XB2hMJ8EvZIpwMyefylpKKfyyvllnJPuh4wrYxYpEK
	/yPrL2KItxFxHJ4pxgBYIRUPW2a0MHc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775867080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9E9SILDGWVlj9W/Mi5ACa4j0pegdKos8v/oASm09ho=;
	b=avtk+jEjRI/t9UmTSikuoWsfiz+3HPubN2NYaMVKMXxnq07RcQUCcNnDQG7Aau0WQvrs1i
	cS36tKuUAjkP/BgDJNLPsqX1A+2sQ6BVoEYAYmKBeSMPAVkqi1ubZ2PEaBVoOylenKK2s6
	bYeiTc5aukkkRriXWvSiTo2HJy8DuGg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aV0OuPL/";
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 324C8440B8
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05706C2BCB2
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775867079;
	bh=Vp5dtVrPnlTekmrSK+oFMs0RH9FoAF0Kb+EgrrShMCI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aV0OuPL/Lyv3dHDUxwcemlWEMYo3vOlicxoq2S9cLeyOntPYpdFvBWy34l8ReMb5R
	 HpS9PV/1x9FgfY4gNirLOer9z9LXK/0OfluLq2wRFnII4VSYRNC5/qxfTcgR2280Wg
	 xA/znOaHbitRI43e0hPIsliGD+JKBlWgYheHiJHFDvpLZV3tQkaWp+63fdRzNK0Mua
	 o3yAGoMneFQaGdMFpZ93iKP7lGQs2dDI4MTQ8Il5PlvodcQ2/XCvNzKHIcWviMJ9Pv
	 arPz8S602Tr34ZTyRVpwIYz6FiT5dVElP8eVG3EN2GkkzdM7zLbgfD1fOhxRSw16Qk
	 z1zxiu308POYQ==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-89fc4147f2eso30603526d6.3
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:24:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWosLTv9nwYvMxw/GsmBeHzI+DYR2fammOKt/qrV8veb5hUI2uT2KFX8Z58AVpmG4CoQw6fz/vn1w==@kvack.org
X-Gm-Message-State: AOJu0YyfYV5M2qACkammv1VqBcXi8cwx+PwFHG6/WkceYrahMPkj0guE
	kwldiZ4IeSO+ZqXj/cV2Vmnb1Z5QGh/tZFaGuKFhUvfWB0/chpSXt7aJDDnngwgbhxpf4LeZBRJ
	HJnt3pUja8TZT+G8sp+V5F+sYRk+DfT4=
X-Received: by 2002:a05:6214:4119:b0:89c:e4c3:dc1a with SMTP id
 6a1803df08f44-8ac86160004mr79807276d6.1.1775867078143; Fri, 10 Apr 2026
 17:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com> <20260410-batch-tlb-flush-v3-3-ff0b9d3a351a@icloud.com>
In-Reply-To: <20260410-batch-tlb-flush-v3-3-ff0b9d3a351a@icloud.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 11 Apr 2026 08:24:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xvnBSRyi9OkRwfRDDM6QcxUfhdrf32R45+GMJ=ZpEerQ@mail.gmail.com>
X-Gm-Features: AQROBzBMP6XFzrMTkpmMPWppaighw-MFIJicxGc9XFWJpKcctFB-YaMeg8mwyrQ
Message-ID: <CAGsJ_4xvnBSRyi9OkRwfRDDM6QcxUfhdrf32R45+GMJ=ZpEerQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] mm/vmscan: extract folio_free() and pageout_one()
To: Zhang Peng <zippermonkey@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5962E4000D
X-Stat-Signature: cg8zmo8ejez41fg5oadc4w4xbgdehmji
X-HE-Tag: 1775867080-556526
X-HE-Meta: U2FsdGVkX19M6ZHtzJb7ufjIgURlNzOeHYqqEG7yr3rup4Eoaz4+uBb7xF22nWwgbOtLckQA1KJFgb/WNOI9Iu/GCNnrCH8XwdU1G+QeIZXVWu0rk/8WtXFQuVLvrDl10NUFuLbVCor8k3FEK2dk8gDPw5793ii1GqissdRYDeGZMWGkOqP3ABmuT8v6nOewi1ZXQmqCExhRBZyizmKAPVyX+/4HvCssI5bL4UaS3/s5NHqJ5rrJ3kkGjmPVsJ10fRVPW6oYhKrSW9pHA44ITeJQ2CzwA/DPEnqH0MKu9Y67i7mKgScG1fD4TwIBDk/ZC9IFUNLwrwo215q4q7Gfpe9vD2RDOtP6jr16AbC6a58D81eCHVBdxvaoH2ecW1FnnwUY+d5bDKLcx7a5Cf7i+8F9ACR1IB02OMdG87AJbKv0JKE6Yyy8muUQHlEFxlsV0H21YzQYFK9FS/WnlqAq1EiNYKlfeaHIJYOoA1SPAzJAkh3VJ+YrRkcwqqrNtfKOlNWjmEX6pFByaGqciwz7OB/BlGcGNLhKCNKdAGbQBApLrNYmcmcqhAfaq6uXTVC6tlZR//TZc/InGWJLPbQfYNep5oRCIW05uqTAGjDwbIXDDdn/ubB6U1mgU/kFCcgGPAQ1aOhoc5nK/+xAvlxyjQX+H+K6MCVCi5MWLwZpnEaXhLUP33s3ao4FM+jRRh1LPPY6obX0yy/85H4TEnD2dCamYMxegdUxatJFolm5wpw373KLlMJ3N1OQpgjPxtPrlDQlOsefQ3Ju2YjtEfHyLPqbmJv05nN9z/fVmLPLx5VAq5AgABr3MO87ctEU7iJxr0otTqpWtUFf1KcKbYE9Mug8dvdkaMSVmtZo2TgrAxbrrAgEW5AFmu/W04pqXXoe/Lp1urODew+AByr/qFl7N2wPsSvweLQKDD6hEHvi18LL27GAbk8U5TXUJdfBMyWvYEvtzrRSuTVLXw0yCSe
 fVnXYLV9
 LLzNd1h5QIZYEy+ppYZ/skj7bDzuIGaPmqkTm53IMmDS5YuVmPjBsjZJoaz8sqf5DL3z8lHaqR6wgo54iksGPU/K8Oe21WdWdPywHUZF/WOOknMqZbE70J1d9fljiKSd58hP4wMfFMDoIwzUd/RD+Wx0KFiod16dBsuCGdC7l9WhEirax7Er0ljTgDI/FQLvv5edPe4ZRlnn85Z7VevE2k0r4IaZmWaSQ3qMGEmEadhtHpeM2qX8MfSlzoARw/GsUMxkLWX+TPw23qL5smbBJ8WOnucMKZDLifPtoX/cJ/+C5GrUH+B3OfLoSAAPnvUMmdqdc5Wn4fzeRnBSaAV0EMx7pk2N06Vpzlwq1AS7vQJxtxwspBHI5OSnIb6SjZ4RXeLdb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 8:47=E2=80=AFPM Zhang Peng <zippermonkey@icloud.com=
> wrote:
>
> From: Zhang Peng <bruzzhang@tencent.com>
>
> shrink_folio_list() contains two large self-contained sections:
> the pageout() dispatch state machine and the folio-freeing path
> (buffer release, lazyfree, __remove_mapping, folio_batch). Extract
> them into pageout_one() and folio_free() respectively to reduce the
> size of shrink_folio_list() and make each step independently readable.

This one looks good, but:

>
> No functional change
>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
> ---
>  mm/vmscan.c | 270 ++++++++++++++++++++++++++++++++++--------------------=
------
>  1 file changed, 155 insertions(+), 115 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0860a48d5bf3..c8ff742ed891 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1070,6 +1070,153 @@ static void folio_active_bounce(struct folio *fol=
io, struct reclaim_stat *stat,
>         }
>  }
>
> +static bool folio_free(struct folio *folio, struct folio_batch *free_fol=
ios,
> +               struct scan_control *sc, struct reclaim_stat *stat)
> +{
> +       unsigned int nr_pages =3D folio_nr_pages(folio);
> +       struct address_space *mapping =3D folio_mapping(folio);
> +
> +       /*
> +        * If the folio has buffers, try to free the buffer
> +        * mappings associated with this folio. If we succeed
> +        * we try to free the folio as well.
> +        *
> +        * We do this even if the folio is dirty.
> +        * filemap_release_folio() does not perform I/O, but it
> +        * is possible for a folio to have the dirty flag set,
> +        * but it is actually clean (all its buffers are clean).
> +        * This happens if the buffers were written out directly,
> +        * with submit_bh(). ext3 will do this, as well as
> +        * the blockdev mapping.  filemap_release_folio() will
> +        * discover that cleanness and will drop the buffers
> +        * and mark the folio clean - it can be freed.
> +        *
> +        * Rarely, folios can have buffers and no ->mapping.
> +        * These are the folios which were not successfully
> +        * invalidated in truncate_cleanup_folio().  We try to
> +        * drop those buffers here and if that worked, and the
> +        * folio is no longer mapped into process address space
> +        * (refcount =3D=3D 1) it can be freed.  Otherwise, leave
> +        * the folio on the LRU so it is swappable.
> +        */
> +       if (folio_needs_release(folio)) {
> +               if (!filemap_release_folio(folio, sc->gfp_mask)) {
> +                       folio_active_bounce(folio, stat, nr_pages);
> +                       return false;
> +               }
> +
> +               if (!mapping && folio_ref_count(folio) =3D=3D 1) {
> +                       folio_unlock(folio);
> +                       if (folio_put_testzero(folio))
> +                               goto free_it;
> +                       else {
> +                               /*
> +                                * rare race with speculative reference.
> +                                * the speculative reference will free
> +                                * this folio shortly, so we may
> +                                * increment nr_reclaimed here (and
> +                                * leave it off the LRU).
> +                                */
> +                               stat->nr_reclaimed +=3D nr_pages;
> +                               return true;
> +                       }
> +               }
> +       }
> +
> +       if (folio_test_lazyfree(folio)) {
> +               /* follow __remove_mapping for reference */
> +               if (!folio_ref_freeze(folio, 1))
> +                       return false;
> +               /*
> +                * The folio has only one reference left, which is
> +                * from the isolation. After the caller puts the
> +                * folio back on the lru and drops the reference, the
> +                * folio will be freed anyway. It doesn't matter
> +                * which lru it goes on. So we don't bother checking
> +                * the dirty flag here.
> +                */
> +               count_vm_events(PGLAZYFREED, nr_pages);
> +               count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
> +       } else if (!mapping || !__remove_mapping(mapping, folio, true,
> +                                                       sc->target_mem_cg=
roup))
> +               return false;
> +
> +       folio_unlock(folio);
> +free_it:
> +       /*
> +        * Folio may get swapped out as a whole, need to account
> +        * all pages in it.
> +        */
> +       stat->nr_reclaimed +=3D nr_pages;
> +
> +       folio_unqueue_deferred_split(folio);
> +       if (folio_batch_add(free_folios, folio) =3D=3D 0) {
> +               mem_cgroup_uncharge_folios(free_folios);
> +               try_to_unmap_flush();
> +               free_unref_folios(free_folios);
> +       }
> +       return true;
> +}
> +
> +static void pageout_one(struct folio *folio, struct list_head *ret_folio=
s,
> +                       struct folio_batch *free_folios,
> +                       struct scan_control *sc, struct reclaim_stat *sta=
t,
> +                       struct swap_iocb **plug, struct list_head *folio_=
list)
> +{
> +       struct address_space *mapping =3D folio_mapping(folio);
> +       unsigned int nr_pages =3D folio_nr_pages(folio);
> +
> +       switch (pageout(folio, mapping, plug, folio_list)) {
> +       case PAGE_ACTIVATE:
> +               /*
> +                * If shmem folio is split when writeback to swap,
> +                * the tail pages will make their own pass through
> +                * this function and be accounted then.
> +                */
> +               if (nr_pages > 1 && !folio_test_large(folio)) {
> +                       sc->nr_scanned -=3D (nr_pages - 1);
> +                       nr_pages =3D 1;
> +               }
> +               folio_active_bounce(folio, stat, nr_pages);
> +               fallthrough;
> +       case PAGE_KEEP:
> +               goto locked_keepit;
> +       case PAGE_SUCCESS:
> +               if (nr_pages > 1 && !folio_test_large(folio)) {
> +                       sc->nr_scanned -=3D (nr_pages - 1);
> +                       nr_pages =3D 1;
> +               }
> +               stat->nr_pageout +=3D nr_pages;
> +
> +               if (folio_test_writeback(folio))
> +                       goto keepit;
> +               if (folio_test_dirty(folio))
> +                       goto keepit;
> +
> +               /*
> +                * A synchronous write - probably a ramdisk.  Go
> +                * ahead and try to reclaim the folio.
> +                */
> +               if (!folio_trylock(folio))
> +                       goto keepit;
> +               if (folio_test_dirty(folio) ||
> +                       folio_test_writeback(folio))
> +                       goto locked_keepit;
> +               mapping =3D folio_mapping(folio);
> +               fallthrough;
> +       case PAGE_CLEAN:
> +               ; /* try to free the folio below */
> +       }
> +       if (folio_free(folio, free_folios, sc, stat))
> +               return;
> +locked_keepit:
> +       folio_unlock(folio);
> +keepit:
> +       list_add(&folio->lru, ret_folios);
> +       VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
> +                       folio_test_unevictable(folio), folio);
> +}

Can we at least move the =E2=80=9Cresult=E2=80=9D out of the function=E2=80=
=94
whether to =E2=80=9Ckeep=E2=80=9D it or not?

Can we have pageout() report its result to shrink_folio_list()?
If everything is hidden inside, it=E2=80=99s hard to tell what
happened to the folio.

This hides too many details that should be exposed to
shrink_folio_list(), making the reclamation flow harder
to understand.

Thanks
Barry

