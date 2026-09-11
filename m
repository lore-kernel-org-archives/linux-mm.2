Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E575C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57BFE6B0093; Fri, 11 Sep 2026 14:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B7C6B0095; Fri, 11 Sep 2026 14:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43A596B0096; Fri, 11 Sep 2026 14:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18F956B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:15:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACE50802BA
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:15:37 +0000 (UTC)
X-FDA: 85202284314.09.6557970
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf31.hostedemail.com (Postfix) with ESMTP id B6D5B20002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:15:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GD8x6hhP;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789150535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsUdzBV0WoHiJJ6Nt8zSUSskXe/EFmoaeRcNUlFxtf4=;
	b=QmxqmWQbFkFdWjjOwYJ7qt6GJXs9RsqR05hoWGE4bphpkudWro11CBpZ+zNp71hiL1bnuf
	iulcVYhgZLJUtNQo3CkQUmXsJ6vHBREIFMxVdZLdgRkdlZayd5R5UO4YhSr1PeF7nPoJL4
	KJV9pinfYKjk3Rfk+LV3QF9YvSlFGMU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789150535;
	b=o8SudhdLCd9ysEuLVWt8p8NyxPVU7iS79bFPQkynS+18CUhHJhmyzp8w+YguJ/R0q0hhqI
	0G6Yzw2OacfqGoLx2wzElYI7hjQCKxxEhsHIehbfTdL4gqe7af3U5DcM6dSUOt0U7TtHZM
	dlJ6TNMy2f4IC1Db65tEJdAm3nI60XI=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GD8x6hhP;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so95511cf.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:15:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789150535; cv=none;
        d=google.com; s=arc-20260327;
        b=SmIoPU11DcICv/ww6+qsLnYnbaCsqdyjRJw99k+YgTI5zkp3TGaJHdrmPPFTfH3qwV
         K63iLpsiVIxWi4m9ZZyFq50VXneUWvuVc8vVtv0Vbtq3bWtRMmoVYbvyK0zBi9dIXQnf
         Oj5C5qlNiS0tcsuY4N34PaXzmwPtwIipIiX9iDw2ic8ey9ZV/5NTK45JxoePr/uifDLz
         3bclmdGB1wo2frSZxxqSFfuLru4+SAQVlCDdzUxexwAnmxxgCyibVHAE4lNbbUXekDyg
         uIpkUDBiTguPzSzjsx/JubNQ5kKmOi/Jr8dF8gpXRt1lW7gJ1Zbaw2JOXC1zU3H6aBDp
         7iVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SsUdzBV0WoHiJJ6Nt8zSUSskXe/EFmoaeRcNUlFxtf4=;
        fh=C8rbP0hkWVu49hxfZrmEpUVqlI1Lr5hZHwK0a6rHc6M=;
        b=DZKBcrgwr246n9Og8vS28v+w8fsSRFXGrxIJVggmuOyIzvXQjRXenUJ7usuA4MvcFZ
         Nb5BSXDaamXQcYfpX3UHvXENb6MbZrNKntxx+ct6eU5IA9YX4rl4JPQr3w68vLnPJzSS
         06GVGB10eIz9urWu2WDGbwc0nHGUYcy+DbSmmLAAf3hDidjTulCUioFCHKy+am4ACGni
         0R8gPE/zRvedFofP5pBvaebabWL7KddUDykCDRKXuADNdCuI2mcV1/ee152qBVoEU7jq
         9i+SfA9L7HuT9prEo2h4w8wGOPoC0KPRlgmYWdj6QpduK8Kd9g2HedfQ1mLid+2+IIMd
         pR+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789150535; x=1789755335; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SsUdzBV0WoHiJJ6Nt8zSUSskXe/EFmoaeRcNUlFxtf4=;
        b=GD8x6hhPVV/K0p8cWBdFzXUE8yy2hk8wpJLtu5Fiyz12QUQw0OKAmx88T9VAnG2x1J
         /40KpmaXF6LxrFaW3peKf21m6dm1lT/Ss60VtOxwdXsD2BvWfMgh1CNzwcOvx1fhQtlf
         1G+oh28hYr104GAuwuEBsAPhP8XzGyPQZdPOIrYylNTeMYu3dBWrPHmvWBh/SDn864pN
         SpkT6UuNESlxWT9+NvA0yOL1b5Y/tL91cIU34YhnXcqc/gUWhl5SO73RPfrdrT6RSP7q
         kyuUjdCS9NhZNauhpBLvvSN0lMQhWQU1S7xn0491nNDOeyoRkTTpvG2H/9oa1m3m206U
         0yjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789150535; x=1789755335;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SsUdzBV0WoHiJJ6Nt8zSUSskXe/EFmoaeRcNUlFxtf4=;
        b=eDIGXz6yTdbG6FUeijuk7h2OONTwUjCKQ8Ro5E291193ZOeVB1Uf4uS5uuNppHs0ew
         nmnUHqj+dS+9VKzhtm50kk30q54j+fnCvqYEd2g0wW0JMcGnTTSLjeaOXlK0GcLYcLF5
         fHxBEUKRYXo4IwKwDGjfzH0iqBIEOp14/8yXBb7CMAo7CzslQ6nKe9a2slHu2eL9oFC6
         r2fjGFeAsGEVvh/PlFeU6CHreKtgfSWKbtoE6oq6GiWYctwjspHiFcLgUmmD6vnxd/dI
         LKTAKnIAHhEoOB6V1nPREDK8yWQLGzG5sAPrW5nYY9PaI59eD/4P6b/7w0/tfaLdVIUP
         WkjA==
X-Forwarded-Encrypted: i=1; AKwUvByQ4l5ZQHQVvQxBcsqYN9ux6T1zhn2zMN2lJD2ifxXGoOszNyTs/M4u45g39Uw9dBYVKB93fu3KnQ==@kvack.org
X-Gm-Message-State: AFuF++m3NaK1C+BkntJ90RevE4ydw54RJ5yT43yhiSZOdt1VjjtJ7a4K
	TnkSNkNW9ZoeGsFa/LiXoDccJ8kN2xykU0U7HYws8vh25u3LEXN/mOPTumhFye4NieASrcJquxI
	hW5H5RA0VEzq7AunnJQo+Hv/cYbadTx6QpH5umDS+
X-Gm-Gg: AYBFou3WrcUClKBWozp3QGVbnsOBKMlpibkH7CR7DgoYsWBGSyk/JEeFJfOgZrvAHU6
	AYd/Pu90LhXAX6Gy1K8cCCMXbkC4VUItqE/Dp24qvV1UsLl5YF60roF6R1aU3jCY4+tDfb0Q3VK
	Pyjl/4XcgTbfK/UlgdFn/ODBn4U+kGprIayYvd7axleLKT9WT8IiIJhul7mfucRrlrVi0FKiOdo
	h+8Ro7Or6YqxsNIHQFF/i2JgG8yegKDZhZlQDqPToQJavS9FADklTq5NW5nI+cPCMaMoztD8q/r
	kONPiuVuzojtNOTi0VjUIys5p8LLC17wHYUD2QPQ1mC9cISsGnBSeueVDNBvmyKsOPDOKovKtYA
	pxQt+oN6EJw==
X-Received: by 2002:a05:622a:1b07:b0:527:f08f:56a2 with SMTP id
 d75a77b69052e-530e4652848mr1537081cf.8.1789150534090; Fri, 11 Sep 2026
 11:15:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com> <20260910234737.1340642-5-surenb@google.com>
 <aqQsWNfrBSp4DY_N@gremlin> <CAJuCfpEEi-9ZqhKR536tJHywprb9RFcx92gK00qp_ecBGH9Fvw@mail.gmail.com>
 <aqQ2M5bZv4k43j91@gremlin> <CAJuCfpG21qzef-yag3A9d22BUXnx2EFmbSvT=Zi5uRx_h7BxbA@mail.gmail.com>
 <aqREAsJK72xwXSzK@gremlin>
In-Reply-To: <aqREAsJK72xwXSzK@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 11:15:22 -0700
X-Gm-Features: AcwNN1WgElVhcS2wqqourqlrpP3HGCgXdW4_YR2F2gcH7VKNhfp3ud7rRD_kq_g
Message-ID: <CAJuCfpGxoFPgs2pN96VsTtWJE+aN5e94woAGCeyp92+geVxOrA@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: k9khnhtc3533ja8rkxpb6ct1g5r158rb
X-Rspamd-Queue-Id: B6D5B20002
X-HE-Tag: 1789150535-558271
X-HE-Meta: U2FsdGVkX18tle3Q6PMIGbsG/Y03mhMCtaVI/78HvVTrm5FP4Em5lLJGHn0jwkm42A3Go9octAsY06QRnyT1m5By5uW9CE7GpG3wsgvicCmPXbLy8PPj5Ap2gHWZY76VCYFhhG/0NOFALKviQyXzyLIWb/S0FBntPzQMJAZSH3zbfpFxSZB+X42Sp01Tvqo+IdOdCrF7Hw/sOljzt5RCYjEEKsjR3+TpSpy6lTf9cFLvaa5iNEOnbMjOHfhM/3zL1A01GBK0ZIST9+0f/48YrsaAYP393lNP5qMp6FU1YhR0ksvUZ0Pwht9X+raLCilAZgiXhiUf6p+pgrRYsb2RrmKCm+ggMEvBRrfXX/1cSOH5Y4wtSs0VRg7JsvBQUji+k/RnQZXZ8pGtTuu4a4mDQzymZgUbZASm2NNK0eZEpV6R6VcXjzuV/UrpEZCXnWOLnM6gT0SgcMAHWeHj6rNau4MozH1quZPRe/stelfdHix4FRGqKAsjfTRYEhK8esKtv1xS+KBU/M54AoiuYSdSfcOOcIKEsDVzH2+BEnbBzF2pO37wLJ8TB0MzVhce7aHZEBFEU/2WU2Ax5DFXhsxO5BbQNEkZIhkM0D3ds6q0Ot8gsj1PitNk7DsZCpdor3ebqVs4FqkvHz54Mcn4Bm9vlaJO/4uYkA8k+8bcRQ5qXWbbeJyWenc9TVNa/UsQ3cVrp7lQFRxYvA5tQ6UAz3H6ClYL3VyN/ds8CMNjnURRXJBNxLHWZEjr1jee2ToPzbBXwxPhde1FkpHF4BDVVUdWdFfhamdI9+ru1DHYcfs3hkaZ2IWF96L9Uuk+oqHKkeA3kwiqoDPabnnD+Qg9ylrPhUK/pCqVBJvuviOCto/Fi5h9w4jgbdhmYW3a5euxqiZ4p/V6F5YhWqcYWvFG0LYivilSuqGB3bd+etPxDHYL8CEQgDtADWIfZ/m3tGCRtvRbM/Wg24Rhxq1mC0E9tTB
 AHQeZUQu
 m8NDDrAHdmai6rkqKx0W6Bnn7EsSbXiL96x8NwJI3SrJNtHZ+mrCbyXfLF/IWTprF5hdJFZSBZK7tQQGG/lsvlPfhC3V9Xlcytw0KcyP7uRAefdPMds+WyN+fcB3GC20tFDVtqtr5K7QqjTXOrcU83RUHbPsiSWwalFSUezgf0tCQoFjFhGSTfZlF6Dt5F3kEtYOw2ivwz1wT2GekLX60kFOvVwL2NFQts0WLNyYV3SdaT+m7oadk6uNitVXJwMlrI1znRbT94oFoujTNRf/n6Ly4qyWVugvf1joYf2u5qD6xMl913id7ujZkJDyaYH/aMyj+BkpENNcrFYHEnxIEZqlpIqGMISTgPJRy34mejhCQ7YviCXYyG4ZpvitAbFQm3n9PKoKh/a2r/bfjxWwygOvGvenDVvxttAV0EltcAsvrzwVVVwBHxIxpi9uTspyHxI5fWHxOlc47u4RsMH7Xn+CJGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 11:11=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Fri, Sep 11, 2026 at 11:06:28AM -0700, Suren Baghdasaryan wrote:
> > On Fri, Sep 11, 2026 at 10:49=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@ker=
nel.org> wrote:
> > >
> > > On Fri, Sep 11, 2026 at 05:07:48PM +0000, Suren Baghdasaryan wrote:
> > > > On Fri, Sep 11, 2026 at 4:39=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@=
kernel.org> wrote:
> > > > >
> > > > > On Thu, Sep 10, 2026 at 04:47:34PM -0700, Suren Baghdasaryan wrot=
e:
> > > > > > smap_gather_stats() interprets its start parameter to mean vma-=
>vm_start
> > > > > > when it's set to 0. Eliminate this special interpretation and p=
ass
> > > > > > vma->vm_start explicitly when needed.
> > > > > >
> > > > > > Since smap_gather_stats() operates within a single VMA, we can =
replace
> > > > > > walk_page_vma()/walk_page_range() calls with walk_page_range_vm=
a()
> > > > > > which is simpler and also can be called while holding per-VMA l=
ock.
> > > > > >
> > > > > > No functional change intended.
> > > > > >
> > > > > > Suggested by: Lorenzo Stoakes <ljs@kernel.org>
> > > > >
> > > > > Hmm did I? Where did I suggest this?... I guess a while ago?
> > > >
> > > > In [1] on June 9, 2026.
> > > >
> > > > [1] https://lore.kernel.org/all/aifO_rCurVhFRTcl@lucifer/
> > >
> > > Yup a while ago :)
> > >
> > > >
> > > > >
> > > > > I mean I also happen to suggest it in the previous patch review :=
) but that was
> > > > > sent after you sent this...
> > > > >
> > > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > > Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
> > > > >
> > > > > I don't love hacking a hack for a patch and then unhack it in the=
 next in a
> > > > > slightly roundabout way.
> > > > >
> > > > > Feels like this should be squashed. And a wrapper function for
> > > > > start=3Dvma->vm_start should be used rather than duplicating that=
 param
> > > > > constantly.
> > > > >
> > > > > > ---
> > > > > >  fs/proc/task_mmu.c | 29 ++++++++++++++++-------------
> > > > > >  1 file changed, 16 insertions(+), 13 deletions(-)
> > > > > >
> > > > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > > > index 3c40c9cbb9c9..ecce7ce116cb 100644
> > > > > > --- a/fs/proc/task_mmu.c
> > > > > > +++ b/fs/proc/task_mmu.c
> > > > > > @@ -1246,21 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_ma=
ps_private *priv)
> > > > > >       return &smaps_shmem_walk_vma_lock_ops;
> > > > > >  }
> > > > > >
> > > > > > -/*
> > > > > > - * Gather mem stats from @vma with the indicated beginning
> > > > > > - * address @start, and keep them in @mss.
> > > > > > +/**
> > > > > > + * smap_gather_stats() - Gather mem stats from @vma.
> > > > > > + * @priv: proc maps private state.
> > > > > > + * @vma: The VMA to gather stats for.
> > > > > > + * @mss: The accumulated stats.
> > > > > > + * @start: The address from which to start.
> > > > > >   *
> > > > > > - * Use vm_start of @vma as the beginning address if @start is =
0.
> > > > > > + * This gathers stats for the whole of the VMA unless the lock=
 was dropped
> > > > > > + * and VMA grew or got merged and we found it again, in which =
case we only
> > > > > > + * gather stats for the remainder of the VMA range.
> > > > >
> > > > > This seems to be describing what callers do not what the function=
 does unless
> > > > > I'm missing something? So that's really the wrong place for it.
> > > > >
> > > > > I think the description of why it might be a partial walk belongs=
 to the bit of
> > > > > code that actually tries to do a partial walk.
> > > > >
> > > > > Anyway as per below I think separate partial/full functions make =
sense and there
> > > > > it can simply be described as walking either the full or part of =
the VMA.
> > > >
> > > > This is verbatim of what you wrote at the end of [1]
> > >
> > > OK, I guess I disagree with myself of 3 months ago?
> > >
> > > The technical point being made here, which I think is the more constr=
uctive one
> > > to engage with, is that this is a function that can be called with di=
fferent
> > > parameters for whatever reason.
> > >
> > > Somebody might decide to call it for another reason, putting somethin=
g in the
> > > description of the function that assumes what callers will do when th=
at code can
> > > change is asking for bit rot.
> >
> > Yeah, that makes sense.
>
> Thanks.
>
> >
> > >
> > > So as I suggested above:
> > >
> > >         I think the description of why it might be a partial walk bel=
ongs to the
> > >         bit of code that actually tries to do a partial walk.
> > >
> > > I.e. I guess past me's description is apt, but belongs with the parti=
al case.
> >
> > Ok, sounds like you want two separate functions supporting complete or
> > partial walk. I don't have a strong preference here and it's easy to
> > do like this:
> >
> > staic void smap_gather_stats_range(priv, vma, &mss, start)
> > {
> >         ....
> > }
> >
> > staic void smap_gather_stats(priv, vma, &mss)
> > {
> >         smap_gather_stats_range(priv, vma, &mss, vma->vm_start);
> > }
> >
> > Does that sound good?
>
> Yeah that's the idea.
>
> >
> > >
> > > >
> > > > >
> > > > > >   */
> > > > > >  static void smap_gather_stats(struct proc_maps_private *priv,
> > > > > >                             struct vm_area_struct *vma,
> > > > > > -                           struct mem_size_stats *mss, unsigne=
d long start)
> > > > > > +                           struct mem_size_stats *mss,
> > > > > > +                           unsigned long start)
> > > > > >  {
> > > > > >       const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv=
);
> > > > > >       const bool is_partial =3D start > vma->vm_start;
> > > > > >
> > > > > >       /* Invalid start */
> > > > > > -     if (start >=3D vma->vm_end)
> > > > > > +     if (start < vma->vm_start || start >=3D vma->vm_end)
> > > > > >               return;
> > > > > >
> > > > > >       if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> > > > > > @@ -1285,10 +1291,7 @@ static void smap_gather_stats(struct pro=
c_maps_private *priv,
> > > > > >                       mss->swap +=3D shmem_swapped;
> > > > > >       }
> > > > > >
> > > > > > -     if (!start)
> > > > > > -             walk_page_vma(vma, ops, mss);
> > > > > > -     else
> > > > > > -             walk_page_range(vma->vm_mm, start, vma->vm_end, o=
ps, mss);
> > > > > > +     walk_page_range_vma(vma, start, vma->vm_end, ops, mss);
> > > > >
> > > > > I mean obviously am in favour of this as I suggested it in the la=
st patch :)
> > > > >
> > > > > >
> > > > > >       reacquire_rcu(priv);
> > > > > >  }
> > > > > > @@ -1343,7 +1346,7 @@ static int show_smap(struct seq_file *m, =
void *v)
> > > > > >       struct vm_area_struct *vma =3D v;
> > > > > >       struct mem_size_stats mss =3D {};
> > > > > >
> > > > > > -     smap_gather_stats(priv, vma, &mss, 0);
> > > > > > +     smap_gather_stats(priv, vma, &mss, vma->vm_start);
> > > > > >
> > > > > >       show_map_vma(m, vma);
> > > > > >
> > > > > > @@ -1396,7 +1399,7 @@ static int show_smaps_rollup(struct seq_f=
ile *m, void *v)
> > > > > >
> > > > > >       vma_start =3D vma->vm_start;
> > > > > >       do {
> > > > > > -             smap_gather_stats(priv, vma, &mss, 0);
> > > > > > +             smap_gather_stats(priv, vma, &mss, vma->vm_start)=
;
> > > > > >               last_vma_end =3D vma->vm_end;
> > > > > >
> > > > > >               /*
> > > > > > @@ -1455,7 +1458,7 @@ static int show_smaps_rollup(struct seq_f=
ile *m, void *v)
> > > > > >
> > > > > >                       /* Case 1 and 2 above */
> > > > > >                       if (vma->vm_start >=3D last_vma_end) {
> > > > > > -                             smap_gather_stats(priv, vma, &mss=
, 0);
> > > > > > +                             smap_gather_stats(priv, vma, &mss=
, vma->vm_start);
> > > > >
> > > > > I mean this is all horrible, having to pass vma->vm_start explici=
tly.
> > > > >
> > > > > Although better than the hack that gets compounded in patch 3.
> > > > >
> > > > > There 4 invocations of smap_gather_stats(), only one of them pass=
es a
> > > > > non-vma->vm_start start.
> > > > >
> > > > > So it'd make more sense to just make smap_gather_stats() lose its=
 3rd param and
> > > > > have it call smap_gather_stats_range(), then have 1 invocation of
> > > > > smaps_gather_stats_range() directly, as per suggestion in last pa=
tch.
> > > > >
> > > > > Or something similar to that.
> > > >
> > > > Hmm. Ok, I'll wait for you to read your previous suggestions in [1]
> > > > and after that let's discuss what the final version should look lik=
e.
> > >
> > > I don't really think that's hugely constructive.
> >
> > I wasn't trying to offend in any way. Just wanted to give you some
> > time to recall previous conversation and consolidate your position.
> >
> > >
> > > I'm sorry I'm (mildly) disagreeing with my past self, I've sent tens =
of
> > > thousands of words of review since then so I think it can be forgiven=
.
> >
> > Definitely. Again, I wasn't trying to blame or anything like that.
> > Just pointing out our previous discussion and want to make sure we are
> > on the same page (while having some fun in the process).
> >
> > >
> > > In any case, I really do think:
> > >
> > >         smap_gather_stats(priv, vma, &mss);
> > >         smap_gather_stats(priv, vma, &mss);
> > >         smap_gather_stats(priv, vma, &mss);
> > >         smap_gather_stats_range(priv, vma, &mss, last_vma_end);
> > >
> > > Works better than:
> > >
> > >         smap_gather_stats(priv, vma, &mss, vma->vm_start);
> > >         smap_gather_stats(priv, vma, &mss, vma->vm_start);
> > >         smap_gather_stats(priv, vma, &mss, vma->vm_start);
> > >         smap_gather_stats(priv, vma, &mss, last_vma_end);
> > >
> > > ?
> > >
> > > I usually come back on review very quickly so I don't think this seri=
es
> > > will be held up with any such change.
> > >
> > > But let me know if you think it's not a good idea technically.
> >
> > TBH I don't have strong preference but if you like it this way, it will=
 be done.
> > I'll post an update today since I don't think there will be more
> > controversial parts. The biggest blunder on my part was the way I
> > split patch 3 and 4.
> > Thanks for the review!
>
> I'd quite like to have a look through the rest of the series first.

Ok, I'll wait for you to finish.

>
> >
> > >
> > > > Thanks,
> > > > Suren.
> > >
> > > --
> > > Cheers, Lorenzo
>
> --
> Cheers, Lorenzo

