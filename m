Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAE87C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 18:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6B06B018D; Tue, 18 Aug 2026 14:41:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA77B6B02D1; Tue, 18 Aug 2026 14:41:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBDDE6B0593; Tue, 18 Aug 2026 14:41:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B36A16B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:41:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BF85A02E7
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:41:41 +0000 (UTC)
X-FDA: 85115258802.06.236BDA5
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5CF00120006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:41:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UeehXGpo;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787078499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pyYJI0TNCEOKN/gsnOgTV5eL5yphEPrCvzUhCQngc4=;
	b=S5v1BvKSiNaNoFCG/b1ak58HaK6Tj6ELiKU//cy7faSoAGKR+lWUVM5Kju5Brsb/nW10Tj
	mMwsfJIlPzNtnxW8qWAR46EmArojVBjLxfqB83ZJyxqM/3NCOwdT7JCK6AA1Nu3CEUSrqj
	07DhdXY+hacjRSEE3mwHBcOIfXhSx+o=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UeehXGpo;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787078499;
	b=vLpJS8INGo6CgC7O32CPgXY2MR3gQROIztumFJfb0f9OZzje3kCG2x6DTFAhA+cWoXVsw9
	9SsA9Gw2I6kcR3Bg7sMkYhXH6OPtgIX4JldVJeRB6gA50NhOkrHJJ07lbFX0jnCCOw8EqU
	aEffL/TBUGqVF+IX2Gulx4znh4MBBgM=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47f633e6058so111350f8f.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:41:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787078498; cv=none;
        d=google.com; s=arc-20260327;
        b=P63jIE6Uhv21b31Wg3O92F0/5vIW36PTkPYH5CJGO0GqyfCqtw+2d1262JnsHcXdg3
         jsfEvHFInAsB2zjrRlJS/eQE9sL3AFymmFaL6ipYCwTC+j0rWcd75+sXSej/Sh6pkpFR
         CU8QzeqNahhMMv4FVtCHWGHaArjS4XQM3lxD/1c1HJRfXLZxUXHGWmmmXjGhylTjwBXC
         kTtusJ9T97QSiWo0dKW394YiC5bOGXSKHK+qAfxsNsJGTRQAAJrmxBYbWMvZWYH4kMz5
         4Ya3gSuU6yo5LoBIbW/VDNqGbyY+IhHxKg2UuHI+CZbxndVvSiDm5bN+cSMp0UECpOxH
         8hsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6pyYJI0TNCEOKN/gsnOgTV5eL5yphEPrCvzUhCQngc4=;
        fh=vORJx92KSCRxIqLdqWYV6GqIb59x8ZxZomWw/jTjBv0=;
        b=eu/pY6xjypKnvflEPbDcrwBlG+ZnFynRTVWGcMtoQYhGeG+QeN6RFzSkITqpEeSKOz
         fKFkcpmu9fsNTFbytxGmEyhkFCzLNSM7WuAaFi1eW0lYhltlNzmoXWxgpfeWSis5VZj2
         zbf6JFq8blONjGvW6fEMn8JmFfu69HJh+vKjMM4r8KCNYjR9g6/fA2Aj3ge0b1UiN/DD
         NwTKiKWcbkvCuW5fnjMactCCz377zgAJJvpictlRL/PWbJ88pw29/vMnrZMGAv2gCNiB
         oQmkTQdYeuNEzmFpWKlHTsB0401SzM0DUW5W2w3x7CJ4N+2HRaRPI/4xs08mZsH5KqBx
         czJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787078498; x=1787683298; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6pyYJI0TNCEOKN/gsnOgTV5eL5yphEPrCvzUhCQngc4=;
        b=UeehXGpoUpgphwAxFmOGkaalyhnwDkpdRI4I5v3I13sMdVH+X0HWyGGdOQBQPlE8fD
         8sH+0EjMCC/2y+04qFdMu9v8cnDm/+UsKIV6xbhNy6KP0wfeHGl5wqTosPvncY0INS6O
         9jPm0TGqipi66qmTT1tPP9nrkkeKWdHJJDh9hKCxafFH5vrw54YcsxwrXOTqJn0/MLD7
         YlKzMEfuIzvytv4svHOKIQBcB3IiHwf9ZwsGRPeFedDiw+mcqyziv5dC3LZaVrd6Bao2
         9kSuq3yw4Vt/pmhblzpXGk7Ane5nqkOWzjSJmRO3xJzIQuARClA2vj6Q6/aPoaiwuwLX
         MSzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787078498; x=1787683298;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6pyYJI0TNCEOKN/gsnOgTV5eL5yphEPrCvzUhCQngc4=;
        b=J9nal+KmgFBDkbLOMKLiiVxtgIWS3tAd72QFX/d6Oz9fiX98pYcBDur4grP7+tWlpV
         A6FYSiIpjV4EPlU0yMTCD11tDKonh9HhuE04moP09Acrxocyf9B2DOXYrB6YbmSodK6G
         IdKPjbXuP8FKtooM7KwaadRfdKKMiiWcuWoZGSes9kgAgbw03UZbjbE/B1twB+EqULSi
         obuq2asEUuerVJhIuiYp1pnWBLJxnAjvN2HBWZmCYVpuFJ9fNEQKb8Tk7sfmhDoMasJ0
         r5i0m0MCVYTcJoiafMvvxyKYg6b14CK1rp6kkrNrkMhdgOSTn2Ydhp9jTYSnZJzba/am
         y0BA==
X-Forwarded-Encrypted: i=1; AHgh+Rrm3PSNcokXFZaa7i2GNuj0BpPVgtsuajXmdABSJvSE04XFoHENTSMimcO5JM8udUqXNCCn434KTQ==@kvack.org
X-Gm-Message-State: AOJu0YwLrikCQ3WOTWQj+wByxw9lKEc+2JxgDrQB4Uu5fDRje7B6G+Qx
	r5KgWLUpFwahgKqPinxvhRIrjfRbzkWJT+92pV8UUuve3slJw+v9jxt149AA2JbsDvKgStWmIY6
	L6J+W2GmGUDulnhbahh21JTzZHISd+Es=
X-Gm-Gg: AR+sD13jtKIl1ZIvIkeOhKMFDq8o8NYMj8IQM7yIib01PcFcsN9mFWmeGA7+9+5+0dO
	uXGuwEolZLVB0UCaylOVAlFBqhkyByPzDa7vEQ+gQUCiNAUmyMEZOWPqF1f1ey6fHGChJV60YpI
	LP0tsPe3YzWiv8nErfEUKwZQ2hVcYjFFP66BACq3Y2wqo3/Gvbv7LjVviM4Dnm7URwDeedC2vUU
	NrTgBocgGNZqUnHQWYrSAu4m2O4Dr4XfyvPZW2C6n8xa/ypQrym+pX/VKqZ7mU10nJ/fFQEivus
	xnmqi24XBr52V89uqKpSk2DpC4l9uc7h+X+y7zGvLf5LUjeVxI8/NEINkZX4Uy8mHh3VvGH6yTq
	B
X-Received: by 2002:a5d:5d86:0:b0:481:5f3c:39d4 with SMTP id
 ffacd0b85a97d-482b07d03e4mr120191f8f.1.1787078497580; Tue, 18 Aug 2026
 11:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <20260806184254.3790858-2-nphamcs@gmail.com>
 <anX-ga41DMNWF6-2@cmpxchg.org>
In-Reply-To: <anX-ga41DMNWF6-2@cmpxchg.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 18 Aug 2026 11:41:25 -0700
X-Gm-Features: AcwNN1VHimYofVoIsN8UQymuxDsdfQrRmhj9S6ClyvLCQWRkK5fYio35kYdGPrc
Message-ID: <CAKEwX=MmqyWdqfrp8kxeuucNFhU2e6Hk2TdANUGhNFHhvtSPwg@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CF00120006
X-Rspamd-Server: rspam07
X-Stat-Signature: 4z6o866ntuk3xfuj9dyg6qwyfuw719uu
X-HE-Tag: 1787078499-938099
X-HE-Meta: U2FsdGVkX1/ixBSJXq9xKo27hq8C4VomxJoIoszic0lDiro5N+Gh7SCAmDFuyTQM7CiIsYfvoaMDsh9tVABlBKSgDszD+pW4iYwq/Yhyz9ZJKD6Ouwk9XwSqmXf2sDyY7s9Rk7y7cbLoz3LRagGZ9NfJiKk+C2my6mfh+GynRl0JoG/hzsq440N423G1LO1Gu7lM4NsEXxsu43AY6w5qvAVY+ZZhGMZMKy2+5hixzpCTkkYso04ahYTvKreVofJhO4DmuI07oYWIhiDKRcT9nOlawg0GZKIurkpomzx6R+I+Gmb0vRmyN8ig3VO3AX/4/1MyinN7VRDmQvRhHdNRBf5Y8YfBlTHm/l5opGt/SejhlCYXKsohBx8dZof4N0lrYsA5Uqhu0cuA/dCLovpFmdDi8B7ocda8w3BhSsQC/KQhyja9s/ClNHjBKiKm/2AXt3m5ct9USWSbDAYrDAUFyscHBdW52lTY5d3v+llAjVGwx3pNMc9ZZp4YaVABtU1HG7+dHB8mG0bsiwJGNjWnycjONxuYALipBiafC/fOMSM2md2T0288Ft0knovjP9Pg2/MYak+qflCkmcVmoRCrIy6aQ+rFFiIxryIvvkd6Du0cnn/hmSwDtBEYe0EqwZ8SVr2a1ufm94hrH0/x9sOfAFMWz0WJwRlSevGi4dKa1hxdV+EqBPK8ApH7+BX92cDIF+z+Krs1uh1F2zWf+pCpGvsXcT+LZjWflVkY0SGBHYgnuhGFADADbDrpYRl3cy1Dttes9zB7LEHBH+QO5spz5B9TsHPRNW+fVx6PboQbVi4kXYETGj2nzyvZNRBmC+5yzJunguq9l0UP1cENwCEBrax5wbbtNLKeB3t+Uu7FaiJ24Q23sv2HnrPUv584B5HHqCqJwJQ/9Iw4NZK8PCFaX3Mzjtw/fSAEsrGgGm94LOHwA13DMlK5p/nKITxJrlj9gGRoaY3MFeCV+7+O45/
 DyaFVfCi
 /Igggt/OUdpBEODQs51X02jg2b9zd9UiQ1KcMwsh9hLkFnuHzNQRXdiHKiXabMqKlxEKSnprc2JYUFZIQl9qK4+Od1iRXJjidbmNNy0j3vxzZ0Z0YQwpkEkxg8rZyCSXZwC+35HLWJDNlRXHamZpTblMI3yjSrxqjoJg6QgkZBJEWwbtqxKNbMdgzkOkW85SP7cllJf4hJiZ70Xi/mPBljcirIC0S1rNIuoC61ZlqMkIvoFx/Cqc1gIddlUVXkvf+ZFioDftnRRiVjGeeqKoFT8UfFx6LhsQr/DQ8U94CX/886xjr7dJj5AVhzvrDoVOvuh9QrzzLXiP6DUUqd8cyaUqM6i55mKoJJg5KImRwF08y+ViPXLjXsnl817vCUKqAJJJE9HvzjhxAQ1Mv/mEONVlDahoHLn32UR5enr0SBdKghALmLSfByL0HV5HWpOWCJt7z8DT7sNRGvMtWWXrWeOUV9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 7, 2026 at 8:49=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org>=
 wrote:

Hi Johannes,

My apologies for the delayed response. I saw and read your email, but
I wanted to stew on it, code things out, and stare at things before
responding.

I think most of our suggestions here make sense. I coded most of them
out already, and I'm stress testing them - will report back if there
are surprises.

>
> Hello Nhat,
>
> This looks pretty clean to me overall. Nice. A few comments inline:
>
> On Thu, Aug 06, 2026 at 11:42:44AM -0700, Nhat Pham wrote:
> > @@ -276,8 +277,21 @@ struct swap_info_struct {
> >       struct list_head discard_clusters; /* discard clusters list */
> >       struct plist_node avail_list;   /* entry in swap_avail_head */
> >       const struct swap_ops *ops;
> > +     struct xarray cluster_info_pool; /* Xarray for vswap dynamic clus=
ter info */
> >  };
> >
> > +#ifdef CONFIG_VSWAP
> > +static inline bool swap_is_vswap(struct swap_info_struct *si)
> > +{
> > +     return si->flags & SWP_VSWAP;
> > +}
> > +#else
>
> I think what could make sense is have
>
> - CONFIG_VSWAP
> - CONFIG_VSWAP_DEFAULT_ENABLED
> - a boot flag that's =3D CONFIG_VSWAP_DEFAULT_ENABLED
>
> Then you can use jump labels to cut runtime overhead to 0 if it isn't
> enabled at boot.
>
> This way distributions can ship it with no overhead out of the box,
> while allowing users to opt in for early testing.
>
> IMO this is more valuable than a runtime toggle.
>
> It should be part of this patch if you add it.

I've been thinking about this and your other suggestions regarding
removing CONFIG_VSWAP. I've coded them out - it does indeed look
cleaner :)

Let me test things first to make sure I did not introduce some weird
bugs, but to recap:

1. CONFIG_VSWAP gone (along with most of the !CONFIG_VSWAP stubs,
saving 100 LoCs or so).

2. Runtime param gone, replaced by a boot param.

3. CONFIG_VSWAP_DEFAULT_ENABLED only decides the default value of the
boot param (still gated by 64bit config).

4. If we detect that the system is 32 bit, we ignore bootparam
selection by users (with a small warn).

If the boot param is false (either because of user selection, the
build config, or because the system is 32 bit), we don't allocate the
vswap device, and bypass all vswap code paths. There should be
negligible overhead here.

>
> > +static inline bool swap_is_vswap(struct swap_info_struct *si)
> > +{
> > +     return false;
> > +}
> > +#endif
> > +
> >  static inline swp_entry_t page_swap_entry(struct page *page)
> >  {
> >       struct folio *folio =3D page_folio(page);
> > @@ -402,6 +416,8 @@ void swap_free_hibernation_slot(swp_entry_t entry);
> >
> >  static inline void put_swap_device(struct swap_info_struct *si)
> >  {
> > +     if (swap_is_vswap(si))
> > +             return;
> >       percpu_ref_put(&si->users);
> >  }
> >
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 331daf7fcfab..32d38b552845 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -19,6 +19,16 @@ menuconfig SWAP
> >         used to provide more virtual memory than the actual RAM present
> >         in your computer.  If unsure say Y.
> >
> > +config VSWAP
> > +     bool "Virtual swap device"
> > +     depends on SWAP && 64BIT
> > +     help
> > +       Adds a virtual swap layer that decouples swap entries in page
> > +       tables from physical backing storage. Swap entries are allocate=
d
> > +       from a virtual swap device and can be backed by zswap, a physic=
al
> > +       swapfile, or kept in memory - with the backing changeable at
> > +       runtime without invalidating page table entries.
>
> IMO this is difficult for a user to decide.
>
> If we want to make this as a config, then IMO the help text should be
> about not requiring a swapfile to use zswap, zerofill pages etc.
>
> From where I'm standing, though, this code is no longer a separate
> vswap.c feature like it used to be. It's pretty integrated into the
> swapcode, and it looks like a good chunk of the core datastructures
> aren't conditional either.
>
> At that point, the usefulness of the config option is limited. If you
> go with the jump label and there is no runtime overhead, it might make
> sense to just keep the option on what the JL should default to.
>
> > @@ -143,9 +150,19 @@ static inline struct swap_info_struct *__swap_entr=
y_to_info(swp_entry_t entry)
> >  static inline struct swap_cluster_info *__swap_offset_to_cluster(
> >               struct swap_info_struct *si, pgoff_t offset)
> >  {
> > +     unsigned int cluster_idx =3D offset / SWAPFILE_CLUSTER;
> > +
> >       VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swa=
poff */
> >       VM_WARN_ON_ONCE(offset >=3D roundup(si->max, SWAPFILE_CLUSTER));
> > -     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> > +
> > +     if (swap_is_vswap(si)) {
> > +             struct swap_cluster_info_dynamic *ci_dyn;
> > +
> > +             ci_dyn =3D xa_load(&si->cluster_info_pool, cluster_idx);
> > +             return ci_dyn ? &ci_dyn->ci : NULL;
> > +     }
> > +
> > +     return &si->cluster_info[cluster_idx];
> >  }
>
> This now requires rcu. IMO a kdoc explaining that would be good.

Good point yeah.

>
> > @@ -733,6 +765,11 @@ static void free_cluster(struct swap_info_struct *=
si, struct swap_cluster_info *
> >               return;
> >       }
> >
> > +     if (swap_is_vswap(si)) {
> > +             vswap_free_cluster(si, ci);
> > +             return;
> > +     }
> > +
> >       __free_cluster(si, ci);
>
> Should this be part of __free_cluster() instead?
>
> - swap_cluster_assert_empty() seems useful.
> - move_cluster() handles the list linkage and could do the list_del().
> - swap_cluster_free_table() is the same.
>
> The other caller is the discard path. That one isn't relevant, but it
> shouldn't hurt. The layering would still be a bit cleaner this way.

I think this should work.

>
> > @@ -835,14 +872,21 @@ static int swap_cluster_setup_bad_slot(struct swa=
p_info_struct *si,
> >   * stolen by a lower order). @usable will be set to false if that happ=
ens.
> >   */
> >  static bool cluster_reclaim_range(struct swap_info_struct *si,
> > -                               struct swap_cluster_info *ci,
> > +                               struct swap_cluster_info **pcip,
> >                                 unsigned long start, unsigned int order=
,
> >                                 bool *usable)
> >  {
> > +     struct swap_cluster_info *ci =3D *pcip;
> >       unsigned int nr_pages =3D 1 << order;
> >       unsigned long offset =3D start, end =3D start + nr_pages;
> >       unsigned long swp_tb;
> >
> > +     /*
> > +      * Take RCU read lock before releasing the cluster lock to keep c=
i
> > +      * alive - for vswap dynamic clusters, ci is freed via kfree_rcu
> > +      * and the grace period could otherwise elapse in the window.
> > +      */
> > +     rcu_read_lock();
> >       spin_unlock(&ci->lock);
>
> Since you replace the naked spin_lock() below with
> swap_cluster_lock(), change this to swap_cluster_unlock() as well?

Good point in the renaming, yeah.

On a related note, I'm thinking of just removing this piece of code in
cluster_reclaim_range(). We have no signal to trigger
cluster_reclaim_range() (i.e swap-cache-only reclamation) for vswap
clusters, and vswap (similar to swap-sync-io devices such as zram)
already try to free swap slots (and swap cache) when the last PTE
reference of the swap entry is dropped. I don't think this code path
is triggered at all in my benchmarks.

Let's keep cluster_reclaim_range() for phys swap device only.


>
> >       do {
> >               swp_tb =3D swap_table_get(ci, offset % SWAPFILE_CLUSTER);
> > @@ -852,7 +896,15 @@ static bool cluster_reclaim_range(struct swap_info=
_struct *si,
> >                       if (__try_to_reclaim_swap(si, offset, TTRS_ANYWAY=
) < 0)
> >                               break;
> >       } while (++offset < end);
> > -     spin_lock(&ci->lock);
> > +     rcu_read_unlock();
> > +
> > +     /* Re-lookup: dynamic cluster may have been freed while lock was =
dropped */
> > +     ci =3D swap_cluster_lock(si, start);
> > +     *pcip =3D ci;
> > +     if (!ci) {
> > +             *usable =3D false;
> > +             return false;
> > +     }
> >
> >       /*
> >        * We just dropped ci->lock so cluster could be used by another
>
> > @@ -1146,6 +1239,12 @@ static unsigned long cluster_alloc_swap_entry(st=
ruct swap_info_struct *si,
> >                       goto done;
> >       }
> >
> > +     if (swap_is_vswap(si)) {
> > +             found =3D alloc_swap_scan_dynamic(si, folio);
> > +             if (found)
> > +                     goto done;
> > +     }
>
> The name and the composability look off to me.
>
> Can you make this a pure allocation function - vswap_alloc_cluster()
> or something - that links it to &si->free_clusters, then jump back and
> use the existing alloc_swap_scan_list() sites?

That name was vestigial from Kairui's RFC, but yeah I agree
vswap_alloc_cluster sounds better.

Regarding the linkage of the newly allocated cluster to the free list
- I'm a bit hesitant to introduce new surface for these clusters,
mostly because I'm afraid I might mess up the handling of these
clusters (when I unlink them from the free list), but I can give it a
shot.

>
> There is a new_cluster: label upstream you could use for the retry.
>
> > +
> >       if (!(si->flags & SWP_PAGE_DISCARD)) {
> >               found =3D alloc_swap_scan_list(si, &si->free_clusters, fo=
lio, false);
> >               if (found)
> > @@ -1264,6 +1363,13 @@ static void add_to_avail_list(struct swap_info_s=
truct *si, bool swapon)
> >                       goto skip;
> >       }
> >
> > +     /*
> > +      * Keep vswap off the avail list - it is not allocated from by
> > +      * the physical swap allocator (swap_alloc_fast/slow).
> > +      */
> > +     if (swap_is_vswap(si))
> > +             goto skip;
>
> This is describing what the code does, followed by a why not.
>
> Describe the why: Vswap space is only allocated through [...], not [...]
>
> > @@ -3528,10 +3668,43 @@ static int setup_swap_clusters_info(struct swap=
_info_struct *si,
> >                                   unsigned long maxpages)
> >  {
> >       unsigned long nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLU=
STER);
> > -     struct swap_cluster_info *cluster_info;
> > +     struct swap_cluster_info *cluster_info =3D NULL;
> > +     struct swap_cluster_info_dynamic *ci_dyn;
> >       int err =3D -ENOMEM;
> >       unsigned long i;
> >
> > +     /* For SWP_VSWAP files, initialize Xarray pool instead of static =
array */
> > +     if (swap_is_vswap(si)) {
> > +             /*
> > +              * Pre-allocate cluster 0 and mark slot 0 (header page)
> > +              * as bad so the allocator never hands out page offset 0.
> > +              */
> > +             ci_dyn =3D kzalloc_obj(*ci_dyn, GFP_KERNEL);
> > +             if (!ci_dyn)
> > +                     goto err;
> > +             spin_lock_init(&ci_dyn->ci.lock);
> > +             INIT_LIST_HEAD(&ci_dyn->ci.list);
> > +
> > +             nr_clusters =3D 0;
>
> But it's one, not zero. And only the first slot is bad. Why is the
> rest not usable and the cluster on the nonfull_clusters list?
>
> I think you can make the integration a bit more organic in general:
>
> Don't do the DIV_ROUND_UP per default only to overwrite it here again
> e.g.
>
> If you come out of this branch with cluster_info =3D=3D &ci_dyn->ci, you
> should be able to reuse the existing swap_cluster_setup_bad_slot(0).
>
> swap_header && i < swap_header->info.nr_badpages should skip that loop
> as well.
>
> Your maxpages is SWAPFILE_CLUSTER aligned, so that
>
>         for (i =3D maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i+=
+) {
>
> loop is skipped as well.
>
> > +             xa_init_flags(&si->cluster_info_pool, XA_FLAGS_ALLOC);
> > +             err =3D xa_insert(&si->cluster_info_pool, 0, ci_dyn, GFP_=
KERNEL);
> > +             if (err) {
> > +                     kfree(ci_dyn);
> > +                     goto err;
> > +             }
> > +
> > +             err =3D swap_cluster_setup_bad_slot(si, &ci_dyn->ci, 0, f=
alse);
> > +             if (err) {
> > +                     xa_erase(&si->cluster_info_pool, 0);
> > +                     swap_cluster_free_table(&ci_dyn->ci);
> > +                     kfree(ci_dyn);
>
> IMO it would be nicer to make this part of free_swap_cluster_info()
> instead of duplicating it.
>
> > +                     xa_destroy(&si->cluster_info_pool);
>
> That one probably doesn't matter. If these allocations fail at boot,
> the system is in trouble.
>
> > +                     goto err;
> > +             }
> > +
> > +             goto setup_cluster_info;
> > +     }
> > +
> >       cluster_info =3D kvzalloc_objs(*cluster_info, nr_clusters);
> >       if (!cluster_info)
> >               goto err;
> > @@ -3556,6 +3729,10 @@ static int setup_swap_clusters_info(struct swap_=
info_struct *si,
> >       err =3D swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
> >       if (err)
> >               goto err;
> > +
> > +     if (!swap_header)
> > +             goto setup_cluster_info;
>
> Is this reachable?
>
> > @@ -3949,3 +4127,51 @@ static int __init swapfile_init(void)
> >       return 0;
> >  }
> >  subsys_initcall(swapfile_init);
> > +
> > +#ifdef CONFIG_VSWAP
> > +struct swap_info_struct *vswap_si;
> > +
> > +/* vswap does no IO on its own. */
> > +static const struct swap_ops vswap_ops =3D { };
> > +
> > +static int __init vswap_init(void)
> > +{
> > +     struct swap_info_struct *si;
> > +     unsigned long maxpages;
> > +     int err;
> > +
> > +     si =3D alloc_swap_info();
> > +     if (IS_ERR(si))
> > +             return PTR_ERR(si);
> > +
> > +     maxpages =3D min(swapfile_maximum_size,
> > +                    ALIGN_DOWN((unsigned long)UINT_MAX, SWAPFILE_CLUST=
ER));
> > +     si->flags |=3D SWP_VSWAP | SWP_SOLIDSTATE | SWP_WRITEOK;
>
> Please add a comment on the flag choices besides SWP_VSWAP.

Will do yeah. I tend to forget them myself too :) SWP_SOLIDSTATE is
mostly to opt-in to the cluster-based allocaiton algo. SWP_WRITEOK is
checked in a couple of places to allow allocation.

