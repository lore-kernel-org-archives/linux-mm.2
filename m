Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79880F3C24C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92DC6B0088; Mon,  9 Mar 2026 09:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6A866B0089; Mon,  9 Mar 2026 09:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76AC6B008A; Mon,  9 Mar 2026 09:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 977606B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:20:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4352F1A0165
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:20:10 +0000 (UTC)
X-FDA: 84526582980.05.674CF02
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 29AEF40013
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:20:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ed1Vvsgb;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773062408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ci1jZfU6aTkLeWV05/+SHmS749eIRj39gDJyYKzcDBY=;
	b=pSUD8Lb6EdRPMVX7/WSpq0hFAQwmEJLaiG7tp5mHUMJCrpz0/aBh3DhsCAyfR+u82diB2r
	uwXqXb418FWhfdxSbl8ImQ7z2ky0ZXThiQVQXCXr4XoAu9+rqhYfIQS6rRC2QSfSxI3+DH
	j/HE5aoL5mayLN3M/X6Znrn3HtooyYk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ed1Vvsgb;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773062408; a=rsa-sha256;
	cv=pass;
	b=wNBb6ChMghPP8zsY5IoIbLno3F/QNhGZ5MFZkE8pLJcs9YBGl5uxCdecQ+BsKEM7ilAStq
	fw06UR1y6pt+augBIbzOZlSntoVGc8EmwobBDhtSvD2R3kCQTWfoak1Tl10aWvG0Bt1cZo
	J2tGPNPR+ZoiUV3iGsDYX83C25NyzAw=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-662abedbeb7so266547a12.3
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 06:20:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773062406; cv=none;
        d=google.com; s=arc-20240605;
        b=BKXw5zTIZj/Fg9cmxTN8ZeFGwThgjCaG6moXcMsbIxSrlMP7XoFT8NAMlnj5vjrMfU
         gfjOWJUYoYVYvQvsxRtOpn8NIWgCKYTwUFC2iWcAPcws7kfdsGqjpICtoKBhki7yj1LW
         SpZGRjYr2WA0KhM3Rjmmih4odQ9qcfYsE5fMgbKIE+NMaGjQExnzqQ15xsK8uU7FIkzM
         Ao9dyIGrhpyZ1n14AQTSHx/REf1Alrg7NSaUQojk38NvKo9IZErQ6ekB8sCdRl6Rge5+
         0apl4S1uLoHCjqGxqOFFN+b8OJ6y0vrQVPJ44dqr0SyxoNQ8coS/kyvHY4MBXdMfLHgT
         KSGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ci1jZfU6aTkLeWV05/+SHmS749eIRj39gDJyYKzcDBY=;
        fh=clb6PayVMQ/UzAP2r09ibws9a2HDQVEwhsmDqjcps9U=;
        b=bhZ0jn1tNmpdXCuZgKGBz1bKgk0ck7GyNy6DI1G5NLg7+YloAbypcXPcV6+iDkpaUO
         yF5TwiyHMUldSSGf7z+BTyOT3DLKCKGCcMazI6qP40Tn7nMCq7GS1RJ7PEpFXcQof3Qf
         IKieiHUZYr9+L8TCL5SyZwImRGikKsta3rWgB8HT34XzDDHE151d6fPH6dyqkEe52BpY
         YcgpaaXk4zQT4RCG0zWrOAt314Vw/zwTd5am0c/EOpOPpVfJZbzj85opVeAQzR5i+PYc
         42QFvDhyWVanQd3g1dTbgxY3FezIzbSk8MjPR0gy+fnT/TyvKxIrUxXC9Hdohh73Hf+g
         u47Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773062406; x=1773667206; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ci1jZfU6aTkLeWV05/+SHmS749eIRj39gDJyYKzcDBY=;
        b=Ed1VvsgbLZhtJ1TEhKS8PcYrN+IuHXVU/mrmt4h6zv7Fph/arqg1Y5DNqroT2D/7Ig
         o/aIMPKu/aObps+SMNaOxblW1nZ3xEscmOxAYOGFeGzBrB4sFjA5g8kQoabSklA/Dvof
         gdxvINpxvBVQwDw/vi6psetj7mLNCtt9ErsKyQP5eLowTbF2wjFIVImEmPfbFeIWTeNj
         S06jQSgZvQ22fNBoHBG47ecR2N167QZbi9Yp5Q/Iv8vwSTbPpwOGlE6zffGdZN5/a/4f
         2+EwgCDqIWUbwk+rKmOeAVsI5l3s6D4egj4q2BiHmOh3Bikhe6jl90iv9El9lEg0Psz2
         1zEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773062406; x=1773667206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ci1jZfU6aTkLeWV05/+SHmS749eIRj39gDJyYKzcDBY=;
        b=hDcU2GTrg1yn4O+Qwk0O2xceRkroRijRyYFe9v35xF6ShxQa9kuvqZmdBs2wDod/h6
         RpZ/gQqLpSPj2A06t7YEPti/lwq9/qGTnoGjHYzIV4QoDK4MINpU9g5wZQbR1eRNqbax
         PCGAEzuQ/G3FKJSajRtM2j0p51LOQHSAauv6VOi7yeQxtnpm4/G3MzU7TZsNtJXTUtr7
         LvP0WljcDBv5cI+yQhpsVKklDbN+3Oj30KERD0Ide2htwtnnUpBsCqI5y82HIBSSSnEt
         sRgUTw1gkeMr/VrT76H91HqRS4SyEfM7cXpzXMRIzNBH1OroMsPcKHiWjmOw4k7MZvTn
         Z0vQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3am0dQF2CjLH0TTUUHQlqy+up85Ir6uqLEBjAFgr3MiFHD5Twc3CUl1cKqSiwe5t+83AgAypsfQ==@kvack.org
X-Gm-Message-State: AOJu0YyD8heodTUWCZgoqgGOg7DAIXfzGAP2yb4zNuY5GwTH7iunB9gx
	U9gVP0Sip5Ce3O8G/TyGoYkJ9JIcOkIp2lO/Y9i5tbD6hayRkYLSMfRUdNne95zUi5W50kB4qs7
	mEj49qWHC+C8xGRM1u/jOHrRs/90nqjA=
X-Gm-Gg: ATEYQzzO4qcNQAn9TFc0M0UadUT9/RYpzisyM7STL0ucNc4btAj6wlcXfr1DWPbOZG0
	S9XKcCzITHP3BfhSVF5u3helIgrT/OdzFxmjCo6E5ORr1NBxoWLPgj6NY92GbD20C1csndOERMu
	AH4i4YQdUt50DPSPqnrIa6oSXu8r8rjyLKQNYr0AvM1yscrXYxcWFR7IILUA8RnAlp/m+EbthEM
	Nn+2GaIXgs4fyYVLK/z4LbsPdTUy69GQap4E5laWZ0N76Fh9avNicxQUniD9mExUDUtZMOccjtc
	RgpCNFPNnphwtvWWGBxR4szTzetI9uzbAgoBFOj/
X-Received: by 2002:a05:6402:5112:b0:660:39f:1cce with SMTP id
 4fb4d7f45d1cf-6619d524ab1mr5318402a12.20.1773062406105; Mon, 09 Mar 2026
 06:20:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260309-batch-tlb-flush-v1-2-eb8fed7d1a9e@icloud.com> <20260309122939.723610-1-usama.arif@linux.dev>
In-Reply-To: <20260309122939.723610-1-usama.arif@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 9 Mar 2026 21:19:29 +0800
X-Gm-Features: AaiRm50W6OJ5k5KSjUf7eUvHNCMCxhRe6HX5ExR-RPxyQNwG5S7i_a_0u1OfGhg
Message-ID: <CAMgjq7C-gisq454qu9Eo62baTpf+cLFcpMnEbv3Z6ZH9jH9kmw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm, vmscan: flush TLB for every 31 folios evictions
To: Zhang Peng <bruzzhang@tencent.com>, Usama Arif <usama.arif@linux.dev>
Cc: Zhang Peng via B4 Relay <devnull+zippermonkey.icloud.com@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 29AEF40013
X-Rspamd-Server: rspam08
X-Stat-Signature: 7uokbb3duer63jswmtxpfwwm95anoi3e
X-HE-Tag: 1773062407-432802
X-HE-Meta: U2FsdGVkX19pwz1UNWSYn+xmzJzTfCeDxrcIQtrmXQfbgD3cKLqp62H6Y2PIsk1AkuXRmWJ48k4P4TKfLicodxo4QxVlxT6bcbx45Y9+bnS8mc8o+jgK2//aVCAA4OUtVMeobR009XuBrVptpUdq1mnKpKEXczmO8Hzv9qjV83PwZD0FfP9x66BEtbKErKjzRdpwIS7NpXE5olicG0xVLDbHjqdOk3NidA55FkSsd7+5l5jQC0hT4HWWJ/mPwpuLYWTDMQ4BBvl5XAwEgXgDDgUXHHDDku8x/nQ9zCmZzykYWsxGnYFPnoJ1ZykoNB0yHN8vBfdLdzaT6aHefHzblp6+llJyW89ItafAPE65xMLTnrIm+UWMYJ7JFY7j14mbo0SARnERkY1r7+BmS+HdZGC8zHvZMCw6OVOPRefuLvK3jQli2qzc9TYJSC8EV/zFAKbOBm0QXgOTFRTaPEQsdFI4PZ+KmOvfwxPqCNZnpg3M6lMNqRhjJ5wVEgK2jSFrMIlq3Rn1kqdF3VFj8e4DlLoT9zN7+W5FJ6J8b7EhPma9+o/RZIVbP0I0wL6FJxr5knEkYR3lt0Nm2Rpf6eaoinZJvk4fy3iUZRggaAFtX1I7vdw4S1Qz4+jQFTJI6odQstppJN2R/soUSGyRjrdXBnFZrs39vynsiT9FZvdFzDW4XPaDdlETwAmJwxA6sq/YBzCbX82eWT7KKjammULm4Xeg/P2kqgFo3Fpfztt1ZFKec8nr0iS65oHPJCXM091kfolTHFsWE/R9rUoKjZTvWG3tLTX4+Hynlp54YetTzPVfukZxQyEMe1S1Mh+tPrGMUXxtWX1CRGdbn06mwLkYk/pJPFGN5AQWWOyOGMvRBajqNbZD3gE0aHE+fBJreqNOVTw/g+409iWOic+8q218ypLz4o9F1BfSS7fbLSZaGHD7YUUGzqwVeVV3AIHixWRqJ8nOXS93qK/NQNyj0Ym
 vGSlSDrZ
 8faAGxqhL+IQZc2GhEgGmxC1b3GSDopKMSMzAKxt0ZpPCiS9wwNBp/w/q22iMAK8om1KSSVlTgWC8gyMB4Bhx0+q54ylIiou5yotslhXprFF1z051zL96aglpBvWHRIo9Yb95r/YQjXA29NAr9SVshkBffezYdL4F2Z7o53X1LNx73OyBzMEfquWC+Vz0H7QnMHjacI919xnBWfFkRowChkNB+S3Pxby78Ew6X+tTVuIKXD/BnMWVWm8VJkT5Sj4MVzQgHVtTzZIhfGk335XcYwExPuFpmzKpKP+LmAc9NQOtpP6FOlFgcvVzVLz7MRFwIk2zH2dBRw3BIxMzi0SCgcMPbaBcMWNpMY58VJvNeEf139jaCVEFoNmVKdzN5mIKDBtTJRsDrCehyySoWW2oEMMlAYDXEbJkG5mZzgNfg2NThuTYIiu/p3Qld1qJ3plchQ2vaY/zxVPyJE7J6gAkavKMeY+5XS5PAslRrzXwZ8SOiD5DQKMELQvxZEBgRgte3aLnyCLR390AAtb993sb4Cx7GfiAGPpPMmjuHZ3is48p871JlkuRkOHyU3T4QW0T5EJXUVDH6rrm3+6hNUC531Hj6kzwOpa8/WYIMjq9bUgTB25aYDNKptji20ri7s4rAQll
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 9, 2026 at 8:42=E2=80=AFPM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> On Mon, 09 Mar 2026 16:17:42 +0800 Zhang Peng via B4 Relay <devnull+zippe=
rmonkey.icloud.com@kernel.org> wrote:
>
> > From: bruzzhang <bruzzhang@tencent.com>
> >
> > Currently we flush TLB for every dirty folio, which is a bottleneck for
> > systems with many cores as this causes heavy IPI usage.
> >
> > So instead, batch the folios, and flush once for every 31 folios (one
> > folio_batch). These folios will be held in a folio_batch releasing thei=
r
> > lock, then when folio_batch is full, do following steps:
> >
> > - For each folio: lock - check still evictable - unlock
> >   - If no longer evictable, return the folio to the caller.
> > - Flush TLB once for the batch
> > - Pageout the folios (refcount freeze happens in the pageout path)
> >
> > Note we can't hold a frozen folio in folio_batch for long as it will
> > cause filemap/swapcache lookup to livelock. Fortunately pageout usually
> > won't take too long; sync IO is fast, and non-sync IO will be issued
> > with the folio marked writeback.
> >
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: bruzzhang <bruzzhang@tencent.com>
> > ---
> >  mm/vmscan.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++=
+-------
> >  1 file changed, 61 insertions(+), 7 deletions(-)

...

> >       folio_batch_init(&free_folios);
> > +     folio_batch_init(&flush_folios);
> > +
> >       memset(stat, 0, sizeof(*stat));
> >       cond_resched();
> >       do_demote_pass =3D can_demote(pgdat->node_id, sc, memcg);
> > @@ -1578,15 +1624,19 @@ static void shrink_folio_list(struct list_head =
*folio_list,
> >                               goto keep_locked;
> >                       if (!sc->may_writepage)
> >                               goto keep_locked;
> > -
> >                       /*
> > -                      * Folio is dirty. Flush the TLB if a writable en=
try
> > -                      * potentially exists to avoid CPU writes after I=
/O
> > -                      * starts and then write it out here.
> > +                      * For anon, we should only see swap cache (anon)=
 and
> > +                      * the list pinning the page. For file page, the =
filemap
> > +                      * and the list pins it. Combined with the page_r=
ef_freeze
> > +                      * in pageout_batch ensure nothing else touches t=
he page
> > +                      * during lock unlocked.
> >                        */
>
> page_ref_freeze happens inside pageout_one() -> pageout() -> __remove_map=
ping(),
> which runs after the folio is re-locked and after the TLB flush.  During
> the unlocked window, the refcount is not frozen. Right?
>
> With this patch, the folio is unlocked before try_to_unmap_flush_dirty() =
runs
> in pageout_batch(). During this window, TLB entries on other CPUs could a=
llow
> writes to the folio after it has been selected for pageout. My understand=
ing
> is that the original code intentionally flushed TLB while the folio was l=
ocked
> to prevent this? Could there be data corruption can result if a write thr=
ough
> a stale TLB entry races with the pageout I/O?

Hi Usama,

Thanks for the review. Yeah the comment here seems wrong, I agree with you.

Hi, Peng, I think you might have used some stall comment, at least
page_ref_freeze doesn't exist here and that doesn't seem to be how
this patch works currently. Can you help double check and update?

These folios are kept in the batch unlocked and unfreeze. Also,
unmapped. They could get mapped again or touched, so the batch flush
should relocks the folios and redo some routines before that unmap
before, and if they are still in a ready to be freed status, then
flush and do the IO, then free.

BTW some checks seem missing in the batch check? eg. folio_maybe_dma_pinned=
.

