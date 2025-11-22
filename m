Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C75CFC51E
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 10:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DE4E6B0008; Sat, 22 Nov 2025 05:00:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38C266B000A; Sat, 22 Nov 2025 05:00:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A1D86B000C; Sat, 22 Nov 2025 05:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4186B0008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 05:00:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20280BB52A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 10:00:24 +0000 (UTC)
X-FDA: 84137797968.17.486201A
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 141D8140008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 10:00:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U8LrK1QN;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763805622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BtUhURY21R3SR3y/kjXDJLvZVfnu6xy++/X51pwabkY=;
	b=1/uScDQg47um2oAiAHcFjgr1aFStEIY+ipn+k9mafZBZsf4SBC7G498yGA8jw0DFmyPjVo
	hjRmGhkgCL+GEvoTeKujTA/KBBABIt0uMMLf8XCQQtmtYxL1hjlo7YYjJys1so2m30irJp
	hkhWFcjcvfqxCr00N3utlMiC5U8T2Jw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763805622; a=rsa-sha256;
	cv=none;
	b=pfK1dweynXi5/554QbIy69PzMTVPVxDYg7CprCQtwCecoAsuzrj8q31v27ZcV2R3ftWUsw
	n7P9cnBMZmshtn0VLsyG43iCkH5bT8gO9nkrfuyucNTuezN0P3wfAGTSJItFtwU0HYtdQF
	8aqXOf9CJ6NGZ9fVQf1gU2W3vMinafU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U8LrK1QN;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64088c6b309so4908022a12.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763805620; x=1764410420; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BtUhURY21R3SR3y/kjXDJLvZVfnu6xy++/X51pwabkY=;
        b=U8LrK1QNWjn65fiQDdA4H2HAFKUFOaJM58ALO2NzzgrkO1uyiHFxdExFZN624VvNS/
         X759BqCfeunBse1DljiSvVzJEQ9v0B9BCwbPld26LE39zDzpMFMu7noq9FV70ZCRGPP2
         0doxIL13psBWv5Y+at6fpblE2LDZ1sOSB6HUdFn7T+x0WxcbenYd0zzwZQEzJeksax0B
         mZXzEzgdQ33H6e2JmOqsJNcg7hsAzYBXfPCiTL7gHjGBGEm79SBt/+OmJYTDha20SOrD
         UXSUb1WoLcFt+QcbY83eyWV/tmKGfRMtDG1V+uFQb/ZStJxa7SRbp7irVo3WbEmlvGoB
         MwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763805620; x=1764410420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BtUhURY21R3SR3y/kjXDJLvZVfnu6xy++/X51pwabkY=;
        b=ig0V/UXeI+F/qXEULs3idW6WD8eAMGAwPEDqnt8zTDBxvq4FpQ8QmC4++Dk6iSv1ps
         ktXFe49VfHiH1dI853Gq0VjFp9BxwTtEODbYOxVkoBP8lRXAVAftnxRFCEd+jR8n0Eb9
         uPvMDl/ULBgveQr3E9zmEI0m5bY2K/IbhIfjaxazJ8DvMACdxlZH0PRBLbMp3wV8KzbK
         WBdiPyKAnZlp9RbDG891wt0n45rKA45Fs7zMb29eFd9KgAt0WdY6BmOvACxt4bCHTK5T
         OKKrs/kn6MAx/h4eIwTr39/di3Qtky3406bCR7DaPWFd5bqK30d9IUxWzaZXjB84IAkA
         jazA==
X-Forwarded-Encrypted: i=1; AJvYcCWyd0qjrdKGDRl0VfuvukYiQMCRbHNPvtqZGBbC2PlP7srPugg51SMJ/19ptO54KMm3XLowsWv8Cg==@kvack.org
X-Gm-Message-State: AOJu0YyYm0w9AuNGr6CsOqdF4XT95iTnb+IBGovRhORlX/bWz2gr727x
	Rhj0a8zeOkZBQTw92KFXJ+TYQE4z6UQGnEszRYa6TT5AU6nkc41DRm0S/QEhEh6jvEiYIdOz5Ia
	umu3hinD6GuL5uTnfcWOrGwAfv7eRH3Y=
X-Gm-Gg: ASbGncumV6Xktui4jRnAL9MhhLh+Uw44GIPig+Q4BmFj+boiHGjXh0/El0iBDoGM1GL
	WdQH5AdBOTNj2VJ87CA616pWPR2SicdHjt4KVOMvDD2eo605Mt59brpSgr+8cFzqvhDbCD0qvf0
	kBfJLlI8FjmHbioVs0P/ILcjIWxSA/4con06ACsNVQ4KQuXqlHxwQTigxzNAUXTGBER1y5VeAY9
	ggvb37L9xpjc1mNd+lzmdhK6u8INnUae9wgpUQ0XtH/VAaL9S9z5yHuoJXVlqr/w8ozer8jL1k2
	2XQw+P8CIzQdrsVxsVZOvXogsfHycoo=
X-Google-Smtp-Source: AGHT+IH3ZuPYi+dUtZGEPjByZlrhsjcoUnq5YmwHitt/PbWSIDI55PHPc+Kj9r8Q7+8xCb+egqmzs2U9dWQ7/iZMTS4=
X-Received: by 2002:a17:906:fe0a:b0:b70:b7f8:868f with SMTP id
 a640c23a62f3a-b767173d7dcmr607957666b.27.1763805620087; Sat, 22 Nov 2025
 02:00:20 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
In-Reply-To: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 22 Nov 2025 17:59:42 +0800
X-Gm-Features: AWmQ_bniwFJ_zUG-pwYYQ3d5F1bc1m806-y6TO4fdhun3EeT0ltGXVQPvJQVPjk
Message-ID: <CAMgjq7BgCocnkJAYd-BBBvzbu9zxmv4QCj+k62kcA3ThZcNv2A@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gnauobsnrfhj3j113pj75n83xktxx6ue
X-Rspam-User: 
X-Rspamd-Queue-Id: 141D8140008
X-Rspamd-Server: rspam01
X-HE-Tag: 1763805621-307830
X-HE-Meta: U2FsdGVkX195PLotIzdiIRnoqeQmNuiWPviZKNhbV5SlNaqnGySg2+n54ZE4ZDSCnUXEYXt59uvWIS0aqWPC3HBQ5XPD6gOq1mTN9QhT7huMQqykrAzf3SEVfvlhBnIXCL+8aazOhQxPYjS2sjnyXntFahwxS+dhj2rAI9ltMN6Mq7ZwEUSh4jgaxT0CHIxbh385asCQNzsKYl7Ex84GsRWwZKs2+YHm7VgoBVbtHrgpQB9XuHwmIzuJR3I6+w94g3j2YaG99GNSM++4OiUc3xi2xvfGz+RSZ7qkAUaY75dixRq3DPtWShrzbv2tDGsEj4y1/4ObSzGPb3LNKA5rsxGiyQS9xzD3EeInfFxMqgYR/hXqKzDOo281syALrD0l1WDbpEpqzilVmTEx8QjEfVw8ZMstcmZfRrwH0UZOrLGXe9qamy+gLWadEerJpBYZgeMUjfcmCR1PndWX/Puq0BcTj8f1C4mGBp6ofTSmGPAfv7mTV0W9vQO2b3Ad0KxgCCFDCM0uueu5QLktxetcp/KLnVK0Bxx+jzgsyP0pwXLDc5TlBv9lpEv7nxyzlIageLhigB/8kL6VYlTmRpVVi8O7a0hwkLwcGVVKOdRrwaDBoqgKhba70c9fisycER1qbHicJmJ9CZDHYERowcxGzwjD5WwmRWfX6YRdRChzsy9cZrR1kP8Jy0ry2WULOrmUOmTbi5boFmdxp5BZ49ClkQIFNNeVjHZAaZFGfUKC6jdio59dVgzIcaidGkn7Q1dMdG+S4JViIKX2YKpaGdBCfWmrFt0wAcw5rmIEUwo7xJfU86Aid1uvgvTIHEhLXRi+j5wu0a19lgUdW4/RfboXntt5Xae2SDB/Diss+qzl3kodqj8Fd7CWCXaFOrFAU5p/H02fvUG8Hs+2lt3bxzy4vxrjl4cqIsmcnVo898WI7/Pyl664danJ7xYLzNeHuGOm+xF4MwKgK5HJRcxLVwd
 6bqNCtKR
 XMNNoiIZH5nWDWzsWNR7PismqGYZ8p1rI+Xg7VBM71M3AmMM1KHMjccvZMAdaxWbDqZ6wntrmPW40V7QP+p9KNwCLgX9KriI44KyV//ml0D0jRevjmcCHNzodlw1HFAxPYvQIVGX62/6g+XQd3S4B03823RLufCyOkv8f4mDbJXxXQEwA+bAR4amWT/OvAeUnrc5MKRHi9+huGlgy81K4SedB3Dw4081CPbOTLvd3Olo/7mk4sQplAhGgjC4va2079nqoAiZdAkaHVFYW8PuCVRcAH7mKDGfC7UYut5ypc9YesKwlT4bTi9ef6rvZjhcse4WdbIWlXjye+SXcRgGCEp/utWJ1kkU/lxdLtWSLVovqo//Dx42YkJ3Tgre72L5P+0JAFGNH5uwf6OgOflRL7skxZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 5:52=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> The current zswap requires a backing swapfile. The swap slot used
> by zswap is not able to be used by the swapfile. That waste swapfile
> space.
>
> The ghost swapfile is a swapfile that only contains the swapfile header
> for zswap. The swapfile header indicate the size of the swapfile. There
> is no swap data section in the ghost swapfile, therefore, no waste of
> swapfile space.  As such, any write to a ghost swapfile will fail. To
> prevents accidental read or write of ghost swapfile, bdev of
> swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> flag because there is no rotation disk access when using zswap.
>
> The zswap write back has been disabled if all swapfiles in the system
> are ghost swap files.

Thanks for sharing this, I've been hearing about the ghost swapfile
design for a long time, glad to see it finally got posted.

>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> ---
>  include/linux/swap.h |  2 ++
>  mm/page_io.c         | 18 +++++++++++++++---
>  mm/swap.h            |  2 +-
>  mm/swap_state.c      |  7 +++++++
>  mm/swapfile.c        | 42 +++++++++++++++++++++++++++++++++++++-----
>  mm/zswap.c           | 17 +++++++++++------
>  6 files changed, 73 insertions(+), 15 deletions(-)

In general I think this aligns quite well with what I had in mind and
an idea that was mention during LSFMM this year (the 3rd one in the
"Issues" part, it wasn't clearly described in the cover letter, more
details in the slides):
https://lore.kernel.org/all/CAMgjq7BvQ0ZXvyLGp2YP96+i+6COCBBJCYmjXHGBnfisCA=
b8VA@mail.gmail.com/

The good part is that we will reuse everything we have with the
current swap stack, and stay optional. Everything is a swap device, no
special layers required. All other features will be available in a
cleaner way.

And /etc/fstab just works the same way for the ghost swapfile.

Looking forward to see this RFC get more updates.

>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 38ca3df68716042946274c18a3a6695dda3b7b65..af9b789c9ef9c0e5cf98887ab=
2bccd469c833c6b 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -216,6 +216,7 @@ enum {
>         SWP_PAGE_DISCARD =3D (1 << 10),   /* freed swap page-cluster disc=
ards */
>         SWP_STABLE_WRITES =3D (1 << 11),  /* no overwrite PG_writeback pa=
ges */
>         SWP_SYNCHRONOUS_IO =3D (1 << 12), /* synchronous IO is efficient =
*/
> +       SWP_GHOST       =3D (1 << 13),    /* not backed by anything */
>                                         /* add others here before... */
>  };
>
> @@ -438,6 +439,7 @@ void free_folio_and_swap_cache(struct folio *folio);
>  void free_pages_and_swap_cache(struct encoded_page **, int);
>  /* linux/mm/swapfile.c */
>  extern atomic_long_t nr_swap_pages;
> +extern atomic_t nr_real_swapfiles;
>  extern long total_swap_pages;
>  extern atomic_t nr_rotate_swap;
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 3c342db77ce38ed26bc7aec68651270bbe0e2564..cc1eb4a068c10840bae0288e8=
005665c342fdc53 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -281,8 +281,7 @@ int swap_writeout(struct folio *folio, struct swap_io=
cb **swap_plug)
>                 return AOP_WRITEPAGE_ACTIVATE;
>         }
>
> -       __swap_writepage(folio, swap_plug);
> -       return 0;
> +       return __swap_writepage(folio, swap_plug);
>  out_unlock:
>         folio_unlock(folio);
>         return ret;
> @@ -444,11 +443,18 @@ static void swap_writepage_bdev_async(struct folio =
*folio,
>         submit_bio(bio);
>  }
>
> -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
> +int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
>  {
>         struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>
>         VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> +
> +       if (sis->flags & SWP_GHOST) {
> +               /* Prevent the page from getting reclaimed. */
> +               folio_set_dirty(folio);
> +               return AOP_WRITEPAGE_ACTIVATE;
> +       }
> +
>         /*
>          * ->flags can be updated non-atomicially (scan_swap_map_slots),
>          * but that will never affect SWP_FS_OPS, so the data_race
> @@ -465,6 +471,7 @@ void __swap_writepage(struct folio *folio, struct swa=
p_iocb **swap_plug)
>                 swap_writepage_bdev_sync(folio, sis);
>         else
>                 swap_writepage_bdev_async(folio, sis);
> +       return 0;
>  }
>
>  void swap_write_unplug(struct swap_iocb *sio)
> @@ -637,6 +644,11 @@ void swap_read_folio(struct folio *folio, struct swa=
p_iocb **plug)
>         if (zswap_load(folio) !=3D -ENOENT)
>                 goto finish;
>
> +       if (unlikely(sis->flags & SWP_GHOST)) {
> +               folio_unlock(folio);
> +               goto finish;
> +       }
> +
>         /* We have to read from slower devices. Increase zswap protection=
. */
>         zswap_folio_swapin(folio);
>
> diff --git a/mm/swap.h b/mm/swap.h
> index d034c13d8dd260cea2a1e95010a9df1e3011bfe4..bd60bf2c5dc9218069be0ada5=
d2d843399894439 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -195,7 +195,7 @@ static inline void swap_read_unplug(struct swap_iocb =
*plug)
>  }
>  void swap_write_unplug(struct swap_iocb *sio);
>  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
> -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)=
;
> +int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
>
>  /* linux/mm/swap_state.c */
>  extern struct address_space swap_space __ro_after_init;
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index b2230f8a48fc2c97d61d4bfb2c25e9d1e2508805..f01a8d8f32deb956e25c3c248=
97b0e3f6c5a735c 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -632,6 +632,13 @@ struct folio *swap_cluster_readahead(swp_entry_t ent=
ry, gfp_t gfp_mask,
>         struct swap_iocb *splug =3D NULL;
>         bool page_allocated;
>
> +       /*
> +        * The entry may have been freed by another task. Avoid swap_info=
_get()
> +        * which will print error message if the race happens.
> +        */
> +       if (si->flags & SWP_GHOST)
> +               goto skip;
> +
>         mask =3D swapin_nr_pages(offset) - 1;
>         if (!mask)
>                 goto skip;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 94e0f0c54168759d75bc2756e7c09f35413e6c78..a34d1eb6908ea144fd8fab122=
4f1520054a94992 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -66,6 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
>  static DEFINE_SPINLOCK(swap_lock);
>  static unsigned int nr_swapfiles;
>  atomic_long_t nr_swap_pages;
> +atomic_t nr_real_swapfiles;
>  /*
>   * Some modules use swappable objects and may try to swap them out under
>   * memory pressure (via the shrinker). Before doing so, they may wish to
> @@ -1158,6 +1159,8 @@ static void del_from_avail_list(struct swap_info_st=
ruct *si, bool swapoff)
>                         goto skip;
>         }
>
> +       if (!(si->flags & SWP_GHOST))
> +               atomic_sub(1, &nr_real_swapfiles);
>         plist_del(&si->avail_list, &swap_avail_head);
>
>  skip:
> @@ -1200,6 +1203,8 @@ static void add_to_avail_list(struct swap_info_stru=
ct *si, bool swapon)
>         }
>
>         plist_add(&si->avail_list, &swap_avail_head);
> +       if (!(si->flags & SWP_GHOST))
> +               atomic_add(1, &nr_real_swapfiles);
>
>  skip:
>         spin_unlock(&swap_avail_lock);
> @@ -2677,6 +2682,11 @@ static int setup_swap_extents(struct swap_info_str=
uct *sis, sector_t *span)
>         struct inode *inode =3D mapping->host;
>         int ret;
>
> +       if (sis->flags & SWP_GHOST) {
> +               *span =3D 0;
> +               return 0;
> +       }
> +
>         if (S_ISBLK(inode->i_mode)) {
>                 ret =3D add_swap_extent(sis, 0, sis->max, 0);
>                 *span =3D sis->pages;
> @@ -2910,7 +2920,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         if (p->flags & SWP_CONTINUED)
>                 free_swap_count_continuations(p);
>
> -       if (!p->bdev || !bdev_nonrot(p->bdev))
> +       if (!(p->flags & SWP_GHOST) &&
> +           (!p->bdev || !bdev_nonrot(p->bdev)))
>                 atomic_dec(&nr_rotate_swap);
>
>         mutex_lock(&swapon_mutex);
> @@ -3030,6 +3041,19 @@ static void swap_stop(struct seq_file *swap, void =
*v)
>         mutex_unlock(&swapon_mutex);
>  }
>
> +static const char *swap_type_str(struct swap_info_struct *si)
> +{
> +       struct file *file =3D si->swap_file;
> +
> +       if (si->flags & SWP_GHOST)
> +               return "ghost\t";
> +
> +       if (S_ISBLK(file_inode(file)->i_mode))
> +               return "partition";
> +
> +       return "file\t";
> +}
> +
>  static int swap_show(struct seq_file *swap, void *v)
>  {
>         struct swap_info_struct *si =3D v;
> @@ -3049,8 +3073,7 @@ static int swap_show(struct seq_file *swap, void *v=
)
>         len =3D seq_file_path(swap, file, " \t\n\\");
>         seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
>                         len < 40 ? 40 - len : 1, " ",
> -                       S_ISBLK(file_inode(file)->i_mode) ?
> -                               "partition" : "file\t",
> +                       swap_type_str(si),
>                         bytes, bytes < 10000000 ? "\t" : "",
>                         inuse, inuse < 10000000 ? "\t" : "",
>                         si->prio);
> @@ -3183,7 +3206,6 @@ static int claim_swapfile(struct swap_info_struct *=
si, struct inode *inode)
>         return 0;
>  }
>
> -
>  /*
>   * Find out how many pages are allowed for a single swap device. There
>   * are two limiting factors:
> @@ -3229,6 +3251,7 @@ static unsigned long read_swap_header(struct swap_i=
nfo_struct *si,
>         unsigned long maxpages;
>         unsigned long swapfilepages;
>         unsigned long last_page;
> +       loff_t size;
>
>         if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
>                 pr_err("Unable to find swap-space signature\n");
> @@ -3271,7 +3294,16 @@ static unsigned long read_swap_header(struct swap_=
info_struct *si,
>
>         if (!maxpages)
>                 return 0;
> -       swapfilepages =3D i_size_read(inode) >> PAGE_SHIFT;
> +
> +       size =3D i_size_read(inode);
> +       if (size =3D=3D PAGE_SIZE) {
> +               /* Ghost swapfile */
> +               si->bdev =3D NULL;
> +               si->flags |=3D SWP_GHOST | SWP_SOLIDSTATE;
> +               return maxpages;
> +       }

Here if we push things further, it might be a good idea to make better
use of the swap file header for detecting this kind of device, and
maybe add support for other info too. The header already has version
info embedded in case it will be extended.

