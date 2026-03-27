Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2620710F2840
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22CA56B0092; Fri, 27 Mar 2026 11:20:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 204556B0095; Fri, 27 Mar 2026 11:20:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B106B0096; Fri, 27 Mar 2026 11:20:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F34B36B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:20:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 771DA13C63B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:20:26 +0000 (UTC)
X-FDA: 84592204452.21.DB235F6
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7A867180013
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:20:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZY17SOkv;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774624824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKhu93BuzYLCwxer4AzRyyN7NkaB4dHaDEvLGg/9pRE=;
	b=UdIq/RzJJjWw69zwyC3k3+ZMH6NQMrHhao6LlsYUWQyR/OJmeOwxqBvC2jI04h8wGwYd+k
	tMnGB4QWotxfmCX8cz9cVfa9f9gVIoWaukHnovqYC6WpB7knsUwfuktxfu/gR1sDqJJb5J
	6JH84+iyq9zBTxLwGi6vzyBu+AOZXmk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774624824; a=rsa-sha256;
	cv=pass;
	b=0ShJeKRmvw63zJVgqTJk9jDay09rFhz1XpjGQZUpyb3+7e4o9q3/gAtoQzP3ou1BoMCJn6
	mL75lPIs7m4moI09EcW1zLXBDpymhxDk6Vt8Pc2pq6/4zBLilL81V7BBK6h8HJdhXsRZPX
	bIA1qz10923tTL10u+nE2G0flSj5Rt4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZY17SOkv;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5091ed02c54so485071cf.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:20:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774624818; cv=none;
        d=google.com; s=arc-20240605;
        b=fU6p19C2Qg6GP42rcfMxd8AVlsSHrWQih1Fsd/y1FNJL/IcyICentfamebGetoyJ3P
         GYjiWpXfoEg+IjkF3MDAFwTw+VqYQS0xOAy8vfypOg4NYHcV9U81l3TkdMHLeZPPY1wb
         Gf+y2jfPlcgibCG5lFJMTPuHFGavy18PJg8fW6f9i56sjh/cAMgiD5BhmGC4XrjOjJcO
         Gi3XfUsmDG4F2cUUqqKzH9DLIN6WgYbKyduPByEOa8guxQKxbSWsrHHC1e0JmRz0dEFQ
         i8eZ0jsqAdBQwS8SXnuBSuoAqQDTOV5X7j3BkBCWhRtW2FG2Ykg5o1XY13IMoxOxjkfq
         WNAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KKhu93BuzYLCwxer4AzRyyN7NkaB4dHaDEvLGg/9pRE=;
        fh=qmSQidEYQqNxmppLke6l72kjmtFtn0z8G+mU8QAiyXs=;
        b=ed33GYvY1uw1+jsdSUC46esTz/QX70cBWN0Wsdc/i9qgHFreMXXfxFqLVh7Zn1+UWF
         f4c71vqvB9MTzkTsratfAqUob+NRUnMzuKEBgXhynXWm9UMj6YmkhynzFkZk4uFnjf7r
         AWgiw8gIg4Fus1JzVbEVmFiCXGrdpPxX4hgORY9H0K5nrCFzns8vKZkk7l5EbgEejqgz
         lvziH7/Acw/4aNNuvz3SWusAMhEdQbKw2ucKHqa0vtvcJQnfQo9CFt9UzrXIMnu+8VYx
         5uHp0+q+KdamGaeE2jST+qSK2UJAano8p6n8FrRwylHPm0wJEoEjz1ezvOS/7Q+Lii+h
         rtkw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774624818; x=1775229618; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KKhu93BuzYLCwxer4AzRyyN7NkaB4dHaDEvLGg/9pRE=;
        b=ZY17SOkv3j73Qv2T9s8xSyq+cKKWKUnG9mTPWFKHp5KxXpwmZcYDz81EaoS4A14VrC
         djeuFtOSmnp09cPcmZMIETRl2erb/zW7qFpW2ld2VR6HzabVDh/Y9eClGZqgZWJx4WIr
         RZQo/F6h2P5fZ2ZvAOSZMa2Uqy91xJ3j4rjfoiW4bNBndrMHRvpJg9adHfjfS036LBDm
         5d3zbjFVLLS2KFpHk+GZdS0B6Md76LrtbzzlmkXGzy04U5ga7d9/fTcCJqNaLZIzulnZ
         5E3JHu94KfBBQR9h98wruza8ay68qVfbpQ9DJnONn+TURbZQ/vzx8ig6CONoZaaKznhE
         gVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774624818; x=1775229618;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KKhu93BuzYLCwxer4AzRyyN7NkaB4dHaDEvLGg/9pRE=;
        b=LVP+KrgiWr3t/Q8dmF0G/fd4Fc4eRYSYMlIvhLkKFnnG1U3mHGxibY+ZhVxZi+DNtR
         7qF32HGtyX/2tmLSLHRlm+sJ9zIYTqW9zsLsxWtOXPT5LJ7xjw4rg3+Gcy2ENequi0hw
         W8vUvGVyieVB5jL2LRKg3U1eqrDfp+1Z7DYRXDyS1IXM1IH82/1YQNQIhAP0iIv3oWjK
         iKS3FOTegj4Im/eNcQLbrQ3h9DXCP9wef3yrkIKR3BWjo43wlop64PRTMlwrdQCpKGlF
         8XD4pHzL4g3LHnkLwwabr/8LSIotjAVp6DUiWyAfp7IwUL0JsXU71c/J8eTVM5+2qUwF
         tKig==
X-Forwarded-Encrypted: i=1; AJvYcCWmPa+olrERI0My4b29pPKpTdPe3cAYkRR/uUDssX8NNgMSJZPoGwUVrxvZFP7tCIpWh6MbROZBTQ==@kvack.org
X-Gm-Message-State: AOJu0YwQpagg22cqG0RgQnGgR4WPxdTICvs9hioNDcTc9fOaekLmEJtD
	cLIfZGObH7IFt9t3ZFat3uFXCVtE5sIW8Kr4a9eqcIipTNARan6rxdD1fabx+Ecf01ONbur7gc2
	xJ6MCJc1i4BEe571FtCOEAg8lfqTLjaJyBblHmblE
X-Gm-Gg: ATEYQzwWSYw2r+Yg1pCJVnFFoB4L4DDfWXRrHQd76hV6EgSAZwy87b9N63cy9ukj7RP
	vcCUT2MQeN7xwwfrmGxly8kBfQ1kyRVdsb2xFlN+fJjvkk/mYhEBnyHgWkpfM/9+7oxaOmi9Gni
	hgCeUTjGemCH7Q48rDhf83GJOLmNv1f5HiKkJKPEtiVfeL7551tGrgjPZB6M+uLV7tCN5JtefUX
	10aM1lu2ZDHLF5W3fI0SMZcZ3+D3Mv+3yX4yJYYOUgDbH0zX8uS+lkJnmQvIfSmN4b2HHkbH2yA
	ZwWHWw==
X-Received: by 2002:a05:622a:a19:b0:509:1eca:6d24 with SMTP id
 d75a77b69052e-50ba1b651f0mr16529651cf.2.1774624817781; Fri, 27 Mar 2026
 08:20:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260322070843.941997-1-surenb@google.com> <f22cb9d9-7fc8-4a79-ada8-02d66a1155b2@lucifer.local>
 <CAJuCfpFqz3OvOrJOnYG8NF0gjzkzmSaiM0LZKD_aLoW9Br2srA@mail.gmail.com> <0f599835-9b99-4457-9ba7-a3eaeb0768d1@lucifer.local>
In-Reply-To: <0f599835-9b99-4457-9ba7-a3eaeb0768d1@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 27 Mar 2026 08:20:06 -0700
X-Gm-Features: AQROBzABNpYAqqAhmYAb2bLxEmyPmxbiMOw-LGEwz_O0-ZycUPJ7JomeGCLytBk
Message-ID: <CAJuCfpFrQQDipONQN-ie-tWVNx7m_=jxyqsh0gGD9CE7HN7RLA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/vmscan: prevent MGLRU reclaim from pinning address space
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, yuzhao@google.com, 
	shakeel.butt@linux.dev, willy@infradead.org, Liam.Howlett@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7A867180013
X-Stat-Signature: bqpx4eozwq6rewa7fw7sfdudt7f5atj7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774624824-359815
X-HE-Meta: U2FsdGVkX18eJEr8i4jAStjNVCwjf7wwRcTRuALZMcPwgGHUD/vVXeOQvjFH9N8HCRc2k1zhb9OuC583tO0OLtjUE6h7HIc6Ju4MvWCAN6AxBH2GyWyGWy3SAOPE5AqtIiuhQnqbouhYYvRJqlUpRmGUp1cDdPrXm/bq4KlSI1suJ+kG/hFlZtlh2k8KBO74ygDasFLV+EeoEL5V0cmbK1YMct12EavHnj0F6HQFzobXyDFEGZomxzZR+wk/BLqZZvU+AhVOcSCyUgDitwbw/s2+E3LoiyPYAXnSOziGLC+IKfm3rOLUhWqOWyG2zR6UVQG98hCRl0xw1nHoLd/wfitdUd1pvkrAbcjYoTUCeElQ+qYpzuf0+I3ADLjL3VfB0DwAIX2O6VaA3Z3oEHB/7vYjUHxWp/1sHcLv0bZbtYfwzfAwXZOodbaQEqRMhe+fI7eaXS2tOGRJhEBD1PRvd87zWJ5mUME4v3xUgnXRiVHJTMmewMXXQ7ZAIGPppmizlU7vxyZ/9yCvPynaldDOF5wk9xxexCHv1XKujEWSDhGfgP6rk/QFOzC4r6eJ5c+F9td6+lL1NZSyqROsf+QaPdgxemDjQHaXSfjdjS9if5wm0Nbhp4kTwt201yF3FfX4CorUI+ZZT+MY64kEDNlFBKnW1z5D0nug/YkSAaFrnQaTT52O2W59yvCy/siCoVqMVeNO+3SBLveVioATowS9dTzGOncuqNMZt++QfLngg+IMkf78MvNhHlqKrAW2sI1U+M2oouJVFjtLvBK/jPVfBjf/YzetJyOgYoyGt3W0AV3BVCEsqgPwEKlxdTYkrF45Duj0auVwoMUdXCVspidz5lXq0ERHiJnWMCOCD+RAZgNdhFBF/ORlibi3kfpvCNLYXX1GiAfkq3Nb3UBmeSS8KSCEPgQeuwH1sLMrJ3yNFATcZlnQCq/8Kap9k26/tOT7y55J1n2mim8jxfznHLz
 bk5SEWYr
 n6i6XcnyqFurNKupb7ietO4W74Dmo7YcBZo4psP63TgcJOgbxF0wq4vV5vyRPfXlMAtr++zu0sD1n3yqX6kWUoLE3DrdiKcpLL3Yg12/c4tlKTjzl+dJQonTj+9BTw4/f4Z9+F0usafv3R4jStK4ywKYiK8kt3RAINonPTxXj+wLEBSI6DpBbHoZVXgnZsEw76yT48ev/gqCGix5CzLn+F5GjRfy8ODFKKKCx2oXlkJVhvMRcpVJXi2Wi++gpuEqbtAr7o4wueAYSIdY39WCwA4HWSOfzOY57L3cctRKfoZBwt6fGBs8HvHRd9A3KVmfvVDkw6/wOwORoTgsO33AhgzWB4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 10:06=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> On Mon, Mar 23, 2026 at 09:19:04AM -0700, Suren Baghdasaryan wrote:
> > On Mon, Mar 23, 2026 at 6:43=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@k=
ernel.org> wrote:
> > >
> > > On Sun, Mar 22, 2026 at 12:08:43AM -0700, Suren Baghdasaryan wrote:
> > > > When shrinking lruvec, MGLRU pins address space before walking it.
> > > > This is excessive since all it needs for walking the page range is
> > > > a stable mm_struct to be able to take and release mmap_read_lock an=
d
> > > > a stable mm->mm_mt tree to walk. This address space pinning results
> > >
> > > Hmm, I guess exit_mmap() calls __mt_destroy(), but that'll just destr=
oy
> > > allocated state and leave the tree empty right, so traversal of that =
tree
> > > at that point would just do nothing?
> >
> > Correct. And __mt_destroy() happens under mmap_write_lock while
> > traversal under mmap_read_lock, so they should not race.
>
> Yeah that's fair.
>
> >
> > >
> > > > in delays when releasing the memory of a dying process. This also
> > > > prevents mm reapers (both in-kernel oom-reaper and userspace
> > > > process_mrelease()) from doing their job during MGLRU scan because
> > > > they check task_will_free_mem() which will yield negative result du=
e
> > > > to the elevated mm->mm_users.
> > > >
> > > > Replace unnecessary address space pinning with mm_struct pinning by
> > > > replacing mmget/mmput with mmgrab/mmdrop calls. mm_mt is contained
> > > > within mm_struct itself, therefore it won't be freed as long as
> > > > mm_struct is stable and it won't change during the walk because
> > > > mmap_read_lock is being held.
> > > >
> > > > Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Given you have cleared up my concerns, this LGTM, so:
>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Hi Andrew,
Any concerns about this patch or do you want someone maintaining MGLRU
to Ack it before pulling into your tree?
The change is quite simple and I explain in my reply why it's safe,
Sashiko seems to like it and I extensively tested it on Android.
Please let me know if anything else is needed.
Thanks,
Suren.



>
> > > > ---
> > > >  mm/vmscan.c | 5 +++--
> > > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > index 33287ba4a500..68e8e90e38f5 100644
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -2863,8 +2863,9 @@ static struct mm_struct *get_next_mm(struct l=
ru_gen_mm_walk *walk)
> > > >               return NULL;
> > >
> > > Not related to this series, but I really don't like how coupled MGLRU=
 is to
> > > the rest of the 'classic' reclaim code.
> > >
> > > Just in the middle of vmscan you walk into generic mm walker logic an=
d the
> > > only hint it's MGLRU is you see lru_gen_xxx stuff (I'm also annoyed t=
hat we
> > > call it MGLRU but it's called lru_gen_xxx in the kernel :)
> >
> > I don't have a strong opinion on this. Perhaps the naming can be
> > changed outside of this series.
>
> I was thinking more of a new file for mglru :>)
>
> I believe we also need some more active maintainership also... but that's
> another issue ;)
>
> >
> > >
> > > >
> > > >       clear_bit(key, &mm->lru_gen.bitmap);
> > > > +     mmgrab(mm);
> > >
> > > Is the mm somehow pinned here or, on destruction, would move it from =
the mm
> > > list meaning that we can safely assume we have something sane in mm->=
 to
> > > grab? I guess this must have already been the case for mmget_not_zero=
() to
> > > have been used before though.
> >
> > Yes, mm is stable because it's fetched from mm_list. When mm is added
> > to this list via lru_gen_add_mm(mm) it is referenced and that
> > reference is dropped only after lru_gen_del_mm(mm) removes the mm from
> > this list (see https://elixir.bootlin.com/linux/v7.0-rc4/source/kernel/=
fork.c#L1185
> > and https://elixir.bootlin.com/linux/v7.0-rc4/source/kernel/fork.c#L118=
7).
> > Addition, removal and retrieval from that list happen under
> > mm_list->lock which prevents races.
>
> Ack, thanks!
>
> >
> > >
> > > >
> > > > -     return mmget_not_zero(mm) ? mm : NULL;
> > > > +     return mm;
> > > >  }
> > > >
> > > >  void lru_gen_add_mm(struct mm_struct *mm)
> > > > @@ -3064,7 +3065,7 @@ static bool iterate_mm_list(struct lru_gen_mm=
_walk *walk, struct mm_struct **ite
> > > >               reset_bloom_filter(mm_state, walk->seq + 1);
> > > >
> > > >       if (*iter)
> > > > -             mmput_async(*iter);
> > > > +             mmdrop(*iter);
> > >
> > > This will now be a blocking call that could free the mm (via __mmdrop=
()),
> > > so could take a while, is that ok?
> >
> > mmdrop() should not be a heavy-weight operation. It simply destroys
> > the metadata associated with mm_struct. mmput() OTOH will call
> > exit_mmap() if it drops the last reference and that can take a while
> > because that's when we free the memory of the process. I believe
> > that's why mmput_async() was used here.
>
> Yeah that's fair enough! Thanks.
>
> >
> > >
> > > If before the code was intentionally deferring work here, doesn't tha=
t
> > > imply that being slow here might be an issue, somehow? Or was it just
> > > because they could? :)
> >
> > I think the reason was the possibility of calling mmput() -> __mmput()
> > -> exit_mmap(mm) which could indeed block us for a while.
>
> Yeah fair :)
>
> >
> > >
> > > >
> > > >       *iter =3D mm;
> > > >
> > > >
> > > > base-commit: 8c65073d94c8b7cc3170de31af38edc9f5d96f0e
> > > > --
> > > > 2.53.0.1018.g2bb0e51243-goog
> > > >
> > >
> > > Thanks, Lorenzo
>
> Cheers, Lorenzo

