Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88FA7CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC216B008A; Thu,  4 Jun 2026 15:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA32C6B008C; Thu,  4 Jun 2026 15:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB92C6B0092; Thu,  4 Jun 2026 15:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA5656B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:26:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 799E61C0EF5
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:26:34 +0000 (UTC)
X-FDA: 84843211908.10.4EB60A3
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 73DD8180003
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:26:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QMoT+Xxa;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780601192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W244zF0LrajchLI6hQjM9YMPBGg1nmKsffDjR7F4q1E=;
	b=G024ZCeBigQwAY799V9nKz/2Mcykyut+K/KyZGVRQWq7oWeXAzv0ccqP8157LELeY28ydI
	LQjaNwwsxZ9yhXW9pKstOkXKkI1vbHOENk6by4NgwPbzrOY8inIphAIkhEtWH/vT1Jzb4p
	Q4AemftfLr3QZ0PTv4VGV7wmh/dg92I=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780601192;
	b=zcp9g9cf/MyeUYDdzu3xxVRoU2dYB2ydtQC+Qb39WfM3tSuLnX1UbuTHFWvxubLNeWwtKd
	AgkK19MBgF53HGxo1tpJawDkzPHAVNBUvcH4TD6805Y2FZA/pZDWLwd0+rMpueLpLHuUGg
	4WPxQp1IXkYYdj1MVCAA83dQQTFfVIA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QMoT+Xxa;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51765331535so6831cf.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 12:26:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780601191; cv=none;
        d=google.com; s=arc-20240605;
        b=k1LzROpr/OTnjtFOdXN8UvoYOB3mJ7JXyO1ln0zTibz6joxu6PdGs0tS5I1gzQ1NBv
         AZhDCOF0R9pV2UfnVjV+8NWYbBOVi7jadkZGHV5O4GQISRl/1eEv8Yzr9bovu16bXC+d
         v10LVsqhisQRyy3fzM91MRF2LRzR09vmzOe6BNBULCmHjKm5STjTuWcHKKG8TJ5CfFZF
         8x7TgUGs1FrXrUevmlgKbsiI7uUuHUOxSaoUt/QkylMOb1UD+mw2jK5kPb6TwqhHgANA
         1b0TCq3MFafjpJgkRjutveqrZRRy2QFj73rSyUIGREGRxwnofsPpL9hyQJ4XQQYMaxRq
         tvaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W244zF0LrajchLI6hQjM9YMPBGg1nmKsffDjR7F4q1E=;
        fh=G1DercB6Mc7b4mLxZdm+5JLCXBNs5gIvIeiqilm6fts=;
        b=fIaSTmHKBKW1+a6KYhpD4weiM2xU7zIuEnkhQiDCinPxPjuXBgU4s28qQ85QRSDNki
         IX7UsAN56dxQmLQA4wJAX2Ugxx5dK/Gk+k2WKsspmROrcBDiAaSqqp/YTO99Hp1W9Kv2
         vwfWx4ENbb/G86fGsoyTzQ23wyJJhYq/T1MS4rbQ1vLI3ORd1SfJyhVA60xL0G0ZHnW9
         RQlR2iYJNhZ0r9lTcU2BxZtpO37Kr3W4UFbgYMRjOllv4yqz+5IiSd9YTuZqce5fKTc7
         duUpn9TWVjhVOnNDtzVfMtdj+9yMsSPeuJ/ysH+CiBFajfIni7s7htKHum2Scf+uyYaO
         Q8ZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780601191; x=1781205991; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W244zF0LrajchLI6hQjM9YMPBGg1nmKsffDjR7F4q1E=;
        b=QMoT+Xxaw5GnPBcUxmRLunRVmsKyrZokeRLeDqPZWxlhcK8GFCIldJDy9VzimFxEos
         2GF9/RzVegxn//cdAe63FSlhxDzTwQcW7rk3iWN7+b4u9UbsJW2wqYCd15w8V3z8AIOj
         SOecupwT3YRoMLIdQza/SxAc6tgIojytlRCVHGpnLVXy85NSlzWWv2oP84UfdeAgD4QW
         c4EDkL7THwtyCtiKM+SH9bgriTGfjv76VahJlehtWh+YWMcWBBHWGIk1VJ/ZQBx0GX54
         rVLI/z5LjPq9jqJm6eFlHzT72WtHh5g/HfACRTLtk1oOoSReqt1C9PSKJpXVTD26y+8u
         a12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780601191; x=1781205991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W244zF0LrajchLI6hQjM9YMPBGg1nmKsffDjR7F4q1E=;
        b=tOftalIeJ7R6MZTqGrDm0T4F/TklJ01BGQnVbQrCtcgWel1U5l2epUDpzUYGKkTRb7
         SOI9sM9X4SgqC0DihBfc3H3F7pXgI6U6P9dZf0+xC1dgNDMYhbvrsn5HKcSxw6k3nGPt
         Woa2XGOIkqxdGuIrZBlKG7hLatl5NcLZP/E6iLShENbyfVVR5II/gRnqxgk16x/XMWSN
         9cCbk7Nb9ySvIRdueE3FSDSCGVE1gVl2QmLTiah8qKRXg9jLW1XOXhhrnmJUJCergyFl
         WFCDgDntmmGpLSGgfDffnaf7EHlrsBq0PV4kiJEyGUxGXuDsQVYaegcDoPlJWWLSMsdV
         vyeg==
X-Forwarded-Encrypted: i=1; AFNElJ+7lTURAYHFss+T6bm7X+Gti5G5Cnd2leIwpImIymtR4pzqLCOPL3tqhyWi1a8Mc53ge03ysPBo5g==@kvack.org
X-Gm-Message-State: AOJu0Yxe2cMO5Wc4m8SedoytV794gnVNpIw8zEiOUwGh0dt6h3je7r9+
	E9ol4kBTeyKJXOr4+jm0gy6aejjEkw2gjvzUsqFknNFEWpbXM0gPsycxaqU4aWFSrY/F3YZI0mA
	ADCPPFI071nckZJOWv9deTBNxyyO0oXOFVPp4Cn+d
X-Gm-Gg: Acq92OGAGx4GllIhMobNYvggdSUNY4o0LZs0ud0pXfkDmkOkeD9+JDPkWB8t94sP2Ep
	L7T3ZaW6DvMKro1+2Pf+9sIA3r5zdxh5z8+70VR12JatU/PQz8BY0Pn88EMn9ud7h6RJy1MBKqS
	Rih55crjYjegSNX5f0oJXLlai6w6i2ShrbjNRz+nWrdXA0Y3dB4cRt0z/8h6Q9m7CZ0Ckq2IcEQ
	2Wlz8v8+vnRLixDqPQ3RYBqDSe66JfzJJPKQq2m2fuSC3CI7dwiazCfYo03742EVYrv6S2cWyuO
	ZGYA2YlSz0QJiBulGRRNujmUeS22h+KsnYeYYqV7kV/mrVT9siJ8ec1iew==
X-Received: by 2002:a05:622a:a950:b0:510:fa1:73c5 with SMTP id
 d75a77b69052e-5179542f418mr1158581cf.16.1780601186114; Thu, 04 Jun 2026
 12:26:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260426062718.1238437-1-surenb@google.com> <20260426062718.1238437-2-surenb@google.com>
 <ahhMEBYM9bixF2Lg@lucifer> <CAJuCfpFJvuFZkgKwJ11RjDXYhTz-a31HO9-5C+Yc=KxbsGvB-w@mail.gmail.com>
 <aiElxkLHn2yC3W_3@lucifer>
In-Reply-To: <aiElxkLHn2yC3W_3@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 4 Jun 2026 12:26:14 -0700
X-Gm-Features: AVVi8Cc-CWjsfctvx8_6qqwKKd85h79SSC-SUCCSMuyGDG9ngwwbB7Bwu_Kzo5E
Message-ID: <CAJuCfpGWeLz7RBVYHTnMpH2O77yb9MtjMKRK1LrgijafC_0mSw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] fs/proc/task_mmu: read proc/pid/{smaps|numa_maps}
 under per-vma lock
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com, 
	richard.weiyang@gmail.com, reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 73DD8180003
X-Stat-Signature: i9kcwwcqti3kf13hcfow6b9g7s3x4kpd
X-HE-Tag: 1780601192-307368
X-HE-Meta: U2FsdGVkX19yNu+ILj3WHh5Tc20pADzR8AAxqR5lK/wFIjYYewRdaV9jNNTikM818KjtE1EL1FvQpOFYER0FGQEMCBU2WThFT/g/weIuaAdPDyBykHM19TYv3q+jQJp9kikZheXSdMMK7J1XfSkkniauGaUnHdVH/4lVeyg25Xwwxflff0aVZWjaf7iWhhhFiWiYZdW8TtnVf62Z3d4jDmsWnVIlUvFcSHP5Ukv0CmWHoNRYS7B+b9b3ZJ7qwQfXxSMlUljCiQtwuE8O8C1ZFwly+ZMlJlBmaFH1Euww2oAs2L0Zt50gpELBGaNWeUvKtOTyiDh4j4ANIAmUaDBuxbOaC/jg19PTPJssvDsNm0ECNvI+QVjwdDDlzBnpJHSSIu7I09pChhyCja1CUCrzDFSl9AAQezzuLocbdaOw1K0OB4Z1nyNaZCewX/GZtCmo9Wm7nSgTcHJYvPDLclHD1Bxid1wv0YlTDvoEUZsDv7h6V39OYYV8CEI4zrCLRk8btx6DslJJ2ZAcVRWpKD0gzbw+Uudcz51rq4T1+ew+Y10PYoYyWQSByC/VNuPmEDKGOJP9yHyydI3zHMTAHxxdwKFqRPVwREt4x4VTLSbTDQSeExKvEyYvjBv7dyy0M+XHqfYFNCQmG2bNM8yUtLdUXiDKhJuaQucEi7Sgq+D92u83ylB0DwPlOtGKZRIJk6GUC8sJ7h6/jcJyi9SfJuDS3NxeQFm/nhK/uZuv4aUoBE6/FtcncT7HZYE6kwawNEO6hkw8ofZtP5Hs8zZ6eYiLvGASanFEZ22Uei12nuT91C2WtYDRjQ1wUTrrKeQ/yo7ovjE+5a9fv9FQ9wVWo2T3WUd0WtyKmoQts/u6s6YP+boAzCWKfftBNklVqLfgmmoRu7NM85wfzk9o4BQNGY9OIcPObx0wBednJbvw/Ti6/saHL8LGDUvgz6FpB9glFBGYp4S5SiPH7UYHTMJWXkF
 txc2H9kI
 IHB6om87gUHFYF7SnWmTH0Q84yQjtEfjMyESWQlvQ8e7ERXITZfnDzmfyhWB/kJ9dyR0N39X7U6SYlOYTB0sKF/cJ5r+DM1OD4qMoZbgmUd84mlrp2ZS+EEYISbbDU1We7aM5WRo2idgrc0CUJxdj83jOVeiBSDe/5jOAe7V7z9u9wRkxh5RXiUZFSPLRsAxIULaxpjPoANltsoKd6DJJj1u1J+Lcxc27zu8O8do3zpRM6mW7178/j5rST+GAUg1w7KD0m5zeJMjJAjjKt2n45Nrwl/1QN09HBQhubfm0Vpk8u6tg5IV16uLl7h71lX4N7BkBVhWk0Dm0UplBq7DAg8a55GfT84s1SHjFleSdyyAhJLQO3doNVbbCN66zc+ciE/K7DyFAmKqt21QK555y/1HbQiYLyowC3ptLG8nHBTSeWlyYsou49bVRzlj3ByIRNXv/LmDM9dq1dKE5Wfz0r47r1mNei5Jg15mPTsmDpeMnifbu496rL0d1PhjmBg+fI/R7sTDBT8+fcyZzNhO6kIT1KA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 4, 2026 at 12:14=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Wed, Jun 03, 2026 at 04:49:48PM -0700, Suren Baghdasaryan wrote:
> > On Thu, May 28, 2026 at 8:17=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org=
> wrote:
> > >
> > > On Sat, Apr 25, 2026 at 11:27:16PM -0700, Suren Baghdasaryan wrote:
> > > > proc/pid/{smaps|numa_maps} can be read using the combination of RCU=
 and
> > > > VMA read locks, similar to proc/pid/maps. RCU is required to safely
> > > > traverse the VMA tree and VMA lock stabilizes the VMA being process=
ed
> > > > and the pagetable walk.
> > > >
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > Reviewed-by: Liam R. Howlett <liam@infradead.org>
> > >
> > > The logic LGTM, some nitty things below but in general:
> > >
> > > Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> >
> > Thanks!
> >
> > >
> > > > ---
> > > >  fs/proc/task_mmu.c | 195 ++++++++++++++++++++++++++++++++++++-----=
----
> > > >  1 file changed, 156 insertions(+), 39 deletions(-)
> > > >
> > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > index 751b9ba160fb..1e3a15bf46f4 100644
> > > > --- a/fs/proc/task_mmu.c
> > > > +++ b/fs/proc/task_mmu.c
> > > > @@ -132,6 +132,22 @@ static void release_task_mempolicy(struct proc=
_maps_private *priv)
> > > >
> > > >  #ifdef CONFIG_PER_VMA_LOCK
> > > >
> > > > +static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_c=
tx)
> > >
> > > NIT: But these inlines are unnecessary in a C file. At the kernel opt=
imisation
> > > level the compiler already decides whether to inline or not.
> > >
> > > However in the kernel we redefine this so we lose function tracing an=
d also we
> > > don't get warnings about unused functions [0], so this is actually a =
bit harmful
> > > - you can end up with dead code and not know abou tit.
> > >
> > > Same goes for all the other static inline's in task_mmu.c.
> >
> > I see. There are a bunch of these small inline functions. Once the
> > dust settles, I can clean them up. Dave's series and my folloup patch
> > to change smaps_rollup will be changing this code. Maybe after all
> > that is done?
>
> Yeah that's fine this obviously isn't urgent! :) tiny nits really.
>
> >
> > >
> > > [0]: https://elixir.bootlin.com/linux/v7.0.10/source/include/linux/co=
mpiler_types.h#L235
> > >
> > > > +{
> > > > +     int ret =3D mmap_read_lock_killable(lock_ctx->mm);
> > > > +
> > > > +     if (!ret)
> > > > +             lock_ctx->mmap_locked =3D true;
> > > > +
> > > > +     return ret;
> > > > +}
> > > > +
> > > > +static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *loc=
k_ctx)
> > > > +{
> > > > +     mmap_read_unlock(lock_ctx->mm);
> > > > +     lock_ctx->mmap_locked =3D false;
> > > > +}
> > > > +
> > > >  static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
> > > >  {
> > > >       lock_ctx->locked_vma =3D NULL;
> > > > @@ -146,25 +162,11 @@ static void unlock_ctx_vma(struct proc_maps_l=
ocking_ctx *lock_ctx)
> > > >       }
> > > >  }
> > > >
> > > > -static const struct seq_operations proc_pid_maps_op;
> > > > -
> > > >  static inline bool lock_vma_range(struct seq_file *m,
> > > >                                 struct proc_maps_locking_ctx *lock_=
ctx)
> > > >  {
> > > > -     /*
> > > > -      * smaps and numa_maps perform page table walk, therefore req=
uire
> > > > -      * mmap_lock but maps can be read with locking just the vma a=
nd
> > > > -      * walking the vma tree under rcu read protection.
> > > > -      */
> > > > -     if (m->op !=3D &proc_pid_maps_op) {
> > > > -             if (mmap_read_lock_killable(lock_ctx->mm))
> > > > -                     return false;
> > > > -
> > > > -             lock_ctx->mmap_locked =3D true;
> > > > -     } else {
> > > > -             rcu_read_lock();
> > > > -             reset_lock_ctx(lock_ctx);
> > > > -     }
> > > > +     rcu_read_lock();
> > > > +     reset_lock_ctx(lock_ctx);
> > > >
> > > >       return true;
> > > >  }
> > > > @@ -172,7 +174,7 @@ static inline bool lock_vma_range(struct seq_fi=
le *m,
> > > >  static inline void unlock_vma_range(struct proc_maps_locking_ctx *=
lock_ctx)
> > > >  {
> > > >       if (lock_ctx->mmap_locked) {
> > > > -             mmap_read_unlock(lock_ctx->mm);
> > > > +             unlock_ctx_mm(lock_ctx);
> > > >       } else {
> > > >               unlock_ctx_vma(lock_ctx);
> > > >               rcu_read_unlock();
> > > > @@ -213,17 +215,45 @@ static inline bool fallback_to_mmap_lock(stru=
ct proc_maps_private *priv,
> > > >       return true;
> > > >  }
> > > >
> > > > +static inline void drop_rcu(struct proc_maps_private *priv)
> > > > +{
> > > > +     if (priv->lock_ctx.mmap_locked)
> > > > +             return;
> > > > +
> > > > +     rcu_read_unlock();
> > > > +}
> > > > +
> > > > +static inline void reacquire_rcu(struct proc_maps_private *priv)
> > > > +{
> > > > +     if (priv->lock_ctx.mmap_locked)
> > > > +             return;
> > > > +
> > > > +     rcu_read_lock();
> > > > +     /* Reinitialize the iterator. */
> > > > +     vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
> > >
> > > OK good that we reset this :)
> > >
> > > > +}
> > > > +
> > > >  #else /* CONFIG_PER_VMA_LOCK */
> > > >
> > >
> > > We need to pull out the patches from Dave's series and remove this op=
tion and
> > > default VMA locks on by default :)
> >
> > I didn't see any followup after Dave posted his v1. I agree it would
> > make things much simpler but I don't want to delay these changes too
> > much.
> > I'll ask Dave if he plans to continue his cleanup. If not, I'll pick it=
 up.
>
> Great thanks!

I checked with Dave and he will post the next version in a week or so.

>
> >
> >
> > >
> > > > +static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_c=
tx)
> > > > +{
> > > > +     return mmap_read_lock_killable(lock_ctx->mm);
> > > > +}
> > > > +
> > > > +static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *loc=
k_ctx)
> > > > +{
> > > > +     mmap_read_unlock(lock_ctx->mm);
> > > > +}
> > > > +
> > > >  static inline bool lock_vma_range(struct seq_file *m,
> > > >                                 struct proc_maps_locking_ctx *lock_=
ctx)
> > > >  {
> > > > -     return mmap_read_lock_killable(lock_ctx->mm) =3D=3D 0;
> > > > +     return lock_ctx_mm(lock_ctx) =3D=3D 0;
> > > >  }
> > > >
> > > >  static inline void unlock_vma_range(struct proc_maps_locking_ctx *=
lock_ctx)
> > > >  {
> > > > -     mmap_read_unlock(lock_ctx->mm);
> > > > +     unlock_ctx_mm(lock_ctx);
> > > >  }
> > > >
> > > >  static struct vm_area_struct *get_next_vma(struct proc_maps_privat=
e *priv,
> > > > @@ -238,6 +268,9 @@ static inline bool fallback_to_mmap_lock(struct=
 proc_maps_private *priv,
> > > >       return false;
> > > >  }
> > > >
> > > > +static inline void drop_rcu(struct proc_maps_private *priv) {}
> > > > +static inline void reacquire_rcu(struct proc_maps_private *priv) {=
}
> > > > +
> > > >  #endif /* CONFIG_PER_VMA_LOCK */
> > > >
> > > >  static struct vm_area_struct *proc_get_vma(struct seq_file *m, lof=
f_t *ppos)
> > > > @@ -538,12 +571,10 @@ static int query_vma_setup(struct proc_maps_l=
ocking_ctx *lock_ctx)
> > > >
> > > >  static void query_vma_teardown(struct proc_maps_locking_ctx *lock_=
ctx)
> > > >  {
> > > > -     if (lock_ctx->mmap_locked) {
> > > > -             mmap_read_unlock(lock_ctx->mm);
> > > > -             lock_ctx->mmap_locked =3D false;
> > > > -     } else {
> > > > +     if (lock_ctx->mmap_locked)
> > > > +             unlock_ctx_mm(lock_ctx);
> > > > +     else
> > > >               unlock_ctx_vma(lock_ctx);
> > > > -     }
> > > >  }
> > > >
> > > >  static struct vm_area_struct *query_vma_find_by_addr(struct proc_m=
aps_locking_ctx *lock_ctx,
> > > > @@ -1280,21 +1311,75 @@ static const struct mm_walk_ops smaps_shmem=
_walk_ops =3D {
> > > >       .walk_lock              =3D PGWALK_RDLOCK,
> > > >  };
> > > >
> > > > +#ifdef CONFIG_PER_VMA_LOCK
> > > > +
> > > > +static const struct mm_walk_ops smaps_walk_vma_lock_ops =3D {
> > > > +     .pmd_entry              =3D smaps_pte_range,
> > > > +     .hugetlb_entry          =3D smaps_hugetlb_range,
> > > > +     .walk_lock              =3D PGWALK_VMA_RDLOCK_VERIFY,
> > > > +};
> > > > +
> > > > +static const struct mm_walk_ops smaps_shmem_walk_vma_lock_ops =3D =
{
> > > > +     .pmd_entry              =3D smaps_pte_range,
> > > > +     .hugetlb_entry          =3D smaps_hugetlb_range,
> > > > +     .pte_hole               =3D smaps_pte_hole,
> > > > +     .walk_lock              =3D PGWALK_VMA_RDLOCK_VERIFY,
> > > > +};
> > > > +
> > > > +static inline const struct mm_walk_ops *
> > > > +get_smaps_walk_ops(struct proc_maps_private *priv)
> > > > +{
> > > > +     if (priv->lock_ctx.mmap_locked)
> > > > +             return &smaps_walk_ops;
> > > > +     return &smaps_walk_vma_lock_ops;
> > > > +}
> > > > +
> > > > +static inline const struct mm_walk_ops *
> > > > +get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> > > > +{
> > > > +     if (priv->lock_ctx.mmap_locked)
> > > > +             return  &smaps_shmem_walk_ops;
> > > > +     return &smaps_shmem_walk_vma_lock_ops;
> > > > +}
> > > > +
> > > > +#else /* CONFIG_PER_VMA_LOCK */
> > > > +
> > > > +static inline const struct mm_walk_ops *
> > > > +get_smaps_walk_ops(struct proc_maps_private *priv)
> > > > +{
> > > > +     return &smaps_walk_ops;
> > > > +}
> > > > +
> > > > +static inline const struct mm_walk_ops *
> > > > +get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> > > > +{
> > > > +     return &smaps_shmem_walk_ops;
> > > > +}
> > > > +
> > > > +#endif /* CONFIG_PER_VMA_LOCK */
> > > > +
> > > >  /*
> > > >   * Gather mem stats from @vma with the indicated beginning
> > > >   * address @start, and keep them in @mss.
> > > >   *
> > > >   * Use vm_start of @vma as the beginning address if @start is 0.
> > > >   */
> > > > -static void smap_gather_stats(struct vm_area_struct *vma,
> > > > -             struct mem_size_stats *mss, unsigned long start)
> > > > +static void smap_gather_stats(struct proc_maps_private *priv,
> > > > +                           struct vm_area_struct *vma,
> > > > +                           struct mem_size_stats *mss, unsigned lo=
ng start)
> > > >  {
> > > > -     const struct mm_walk_ops *ops =3D &smaps_walk_ops;
> > > > +     const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv);
> > > >
> > > >       /* Invalid start */
> > > >       if (start >=3D vma->vm_end)
> > > >               return;
> > > >
> > > > +     if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> > > > +             return;
> > > > +
> > > > +     /* Might sleep. Drop RCU read lock but keep the VMA locked. *=
/
> > > > +     drop_rcu(priv);
> > > > +
> > > >       if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
> > > >               /*
> > > >                * For shared or readonly shmem mappings we know that=
 all
> > > > @@ -1312,15 +1397,16 @@ static void smap_gather_stats(struct vm_are=
a_struct *vma,
> > > >                                       !(vma->vm_flags & VM_WRITE)))=
 {
> > > >                       mss->swap +=3D shmem_swapped;
> > > >               } else {
> > > > -                     ops =3D &smaps_shmem_walk_ops;
> > > > +                     ops =3D get_smaps_shmem_walk_ops(priv);
> > > >               }
> > > >       }
> > > >
> > > > -     /* mmap_lock is held in m_start */
> > > >       if (!start)
> > > >               walk_page_vma(vma, ops, mss);
> > > >       else
> > > >               walk_page_range(vma->vm_mm, start, vma->vm_end, ops, =
mss);
> > > > +
> > > > +     reacquire_rcu(priv);
> > >
> > > OK I was going to say that this RCU lock dance is a bit iffy, but I s=
ee
> > > that we're sharing code such that this is necessary.
> > >
> > > >  }
> > > >
> > > >  #define SEQ_PUT_DEC(str, val) \
> > > > @@ -1369,10 +1455,11 @@ static void __show_smap(struct seq_file *m,=
 const struct mem_size_stats *mss,
> > > >
> > > >  static int show_smap(struct seq_file *m, void *v)
> > > >  {
> > > > +     struct proc_maps_private *priv =3D m->private;
> > > >       struct vm_area_struct *vma =3D v;
> > > >       struct mem_size_stats mss =3D {};
> > > >
> > > > -     smap_gather_stats(vma, &mss, 0);
> > > > +     smap_gather_stats(priv, vma, &mss, 0);
> > > >
> > > >       show_map_vma(m, vma);
> > > >
> > > > @@ -1413,7 +1500,7 @@ static int show_smaps_rollup(struct seq_file =
*m, void *v)
> > > >               goto out_put_task;
> > > >       }
> > > >
> > > > -     ret =3D mmap_read_lock_killable(mm);
> > > > +     ret =3D lock_ctx_mm(&priv->lock_ctx);
> > > >       if (ret)
> > > >               goto out_put_mm;
> > > >
> > > > @@ -1425,7 +1512,7 @@ static int show_smaps_rollup(struct seq_file =
*m, void *v)
> > > >
> > > >       vma_start =3D vma->vm_start;
> > > >       do {
> > > > -             smap_gather_stats(vma, &mss, 0);
> > > > +             smap_gather_stats(priv, vma, &mss, 0);
> > > >               last_vma_end =3D vma->vm_end;
> > > >
> > > >               /*
> > > > @@ -1434,8 +1521,8 @@ static int show_smaps_rollup(struct seq_file =
*m, void *v)
> > > >                */
> > > >               if (mmap_lock_is_contended(mm)) {
> > > >                       vma_iter_invalidate(&vmi);
> > > > -                     mmap_read_unlock(mm);
> > > > -                     ret =3D mmap_read_lock_killable(mm);
> > > > +                     unlock_ctx_mm(&priv->lock_ctx);
> > > > +                     ret =3D lock_ctx_mm(&priv->lock_ctx);
> > > >                       if (ret) {
> > > >                               release_task_mempolicy(priv);
> > > >                               goto out_put_mm;
> > > > @@ -1484,14 +1571,14 @@ static int show_smaps_rollup(struct seq_fil=
e *m, void *v)
> > > >
> > > >                       /* Case 1 and 2 above */
> > > >                       if (vma->vm_start >=3D last_vma_end) {
> > > > -                             smap_gather_stats(vma, &mss, 0);
> > > > +                             smap_gather_stats(priv, vma, &mss, 0)=
;
> > > >                               last_vma_end =3D vma->vm_end;
> > > >                               continue;
> > > >                       }
> > > >
> > > >                       /* Case 4 above */
> > > >                       if (vma->vm_end > last_vma_end) {
> > > > -                             smap_gather_stats(vma, &mss, last_vma=
_end);
> > > > +                             smap_gather_stats(priv, vma, &mss, la=
st_vma_end);
> > > >                               last_vma_end =3D vma->vm_end;
> > > >                       }
> > > >               }
> > > > @@ -1505,7 +1592,7 @@ static int show_smaps_rollup(struct seq_file =
*m, void *v)
> > > >       __show_smap(m, &mss, true);
> > > >
> > > >       release_task_mempolicy(priv);
> > > > -     mmap_read_unlock(mm);
> > > > +     unlock_ctx_mm(&priv->lock_ctx);
> > > >
> > > >  out_put_mm:
> > > >       mmput(mm);
> > > > @@ -3291,6 +3378,31 @@ static const struct mm_walk_ops show_numa_op=
s =3D {
> > > >       .walk_lock =3D PGWALK_RDLOCK,
> > > >  };
> > > >
> > > > +#ifdef CONFIG_PER_VMA_LOCK
> > > > +static const struct mm_walk_ops show_numa_vma_lock_ops =3D {
> > > > +     .hugetlb_entry =3D gather_hugetlb_stats,
> > > > +     .pmd_entry =3D gather_pte_stats,
> > > > +     .walk_lock =3D PGWALK_VMA_RDLOCK_VERIFY,
> > > > +};
> > > > +
> > > > +static inline const struct mm_walk_ops *
> > > > +get_show_numa_ops(struct proc_maps_private *priv)
> > > > +{
> > > > +     if (priv->lock_ctx.mmap_locked)
> > > > +             return &show_numa_ops;
> > > > +     return &show_numa_vma_lock_ops;
> > > > +}
> > > > +
> > > > +#else /* CONFIG_PER_VMA_LOCK */
> > > > +
> > > > +static inline const struct mm_walk_ops *
> > > > +get_show_numa_ops(struct proc_maps_private *priv)
> > > > +{
> > > > +     return &show_numa_ops;
> > > > +}
> > > > +
> > > > +#endif /* CONFIG_PER_VMA_LOCK */
> > > > +
> > > >  /*
> > > >   * Display pages allocated per node and memory policy via /proc.
> > > >   */
> > > > @@ -3335,8 +3447,13 @@ static int show_numa_map(struct seq_file *m,=
 void *v)
> > > >       if (is_vm_hugetlb_page(vma))
> > > >               seq_puts(m, " huge");
> > > >
> > > > -     /* mmap_lock is held by m_start */
> > > > -     walk_page_vma(vma, &show_numa_ops, md);
> > > > +     /* Skip walking pages if gate VMA */
> > > > +     if (vma !=3D get_gate_vma(proc_priv->lock_ctx.mm)) {
> > > > +             /* Might sleep. Drop RCU read lock but keep the VMA l=
ocked. */
> > > > +             drop_rcu(proc_priv);
> > > > +             walk_page_vma(vma, get_show_numa_ops(proc_priv), md);
> > > > +             reacquire_rcu(proc_priv);
> > > > +     }
> > > >
> > > >       if (!md->pages)
> > > >               goto out;
> > > > --
> > > > 2.54.0.545.g6539524ca2-goog
> > > >

