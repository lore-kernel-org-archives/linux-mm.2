Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2E0606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 23:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=U2QBgEvy
Received: by kanga.kvack.org (Postfix)
	id 7A4916B0919; Tue, 27 Oct 2026 19:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C8D6B091B; Tue, 27 Oct 2026 19:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644AD6B091C; Tue, 27 Oct 2026 19:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 319EA6B0919
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:11:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BC6280B82
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:11:39 +0000 (UTC)
X-FDA: 85369955118.23.E888B93
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9F4B3C0008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:11:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=U2QBgEvy;
	spf=pass (imf28.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793142697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhl2geudcbOZICdrGNLpkxL+lbiX8RJZUOCOaZhyCBY=;
	b=HxFVT7SSQqz6buup2P7JY1iJ4h0BGZqOkHQsc9YD3QeYVd9xVUUctQ0GSZhRNPuwL38bwd
	8q8EHsni4L53/T1hUGPRo41JwUB9vF96DAn+V2wmeyFT1k6Rs28TgWBN3xXw/lXgJ4LgUb
	+ZJjmUWQFBZpG+I04O7h+7qKsklWisg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793142697;
	b=dEz1cPzreM+M5SY23KZjpvyEggf2tIGX6SJY5JuADWv6KLJ8/SlSo6o+fwxtQrlGqRny5R
	k5g8x7qDEdGOTxOuyALSHpi2V2skHMqq3h93idYKgBKTT3CFI4eYdI7w5KfBRKT2tru5zj
	9i5OWFsWvM2R4NTDrxHdfCN/FJu6eVA=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=U2QBgEvy;
	spf=pass (imf28.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a54bba0442so8965e9.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:11:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793142696; cv=none;
        d=google.com; s=arc-20260327;
        b=AVVErmM+dD5lS1hJ4Hu+O+Mo0Voyz15AKqJdO6R62F43k+PVM5UB4eoWCQSHQLT7hG
         T88ac84qWHUFTqm+FuviiIwABcDegWys3DdwWtH3+G36IR7a7QLvZzzDyoUBFRvPmkjV
         k+fEh4uWKVxXZ3PlCNa6YIMQJ+3B9347Y3lZFcA60Ml6RiVpFU1pAA/DtuT/80JEhk1C
         PxS5pt+YYFEtNOVltnYdeAnfviLG7YHJ8dEvIBmkC6pU2Dm2tnC/xXMaLMY0Xse/UqBU
         7vEBiphnL/1l9H+m0sFZGy/ZtkjhrnX1E8fs0qLRSQP9+1O7uLb1ufnYaiSvGZ2ZQox4
         mxFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rhl2geudcbOZICdrGNLpkxL+lbiX8RJZUOCOaZhyCBY=;
        fh=5litsH4LzBlQJSt8Vn2vb9d5ATZE/b/dJCVrvVjL6uo=;
        b=Ip4cNa30q9HtYo8GHosdSKNiX7KS41sw7LV33V3em0BfUve0Q+z7CUhRJ05i17MCTq
         Olp+mrjb/xds1zzaByQmMpdBhyf02yx6FyOHAYqgFrhGl+z9bOHQTQ/nhQmLhwilPKz4
         bCNdXGQ+7ANt9cijbos9l9c37kLQbFFO1uBWe6zlvT3nLF9E+NHmyRZr4a/waxsCdL0b
         Q5xJimmH44t8uFGtifrRg854hl5lIexiBjo2NK5yYTxh8lFIgu4JVTLFrlVKQyeOmo3S
         kJb22EFUqR5ktdM+JlC42CI321NYeG6i982cTd8hoQWnn6AosqpXvGae63lf3QR2rWml
         /0Vw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793142696; x=1793747496; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rhl2geudcbOZICdrGNLpkxL+lbiX8RJZUOCOaZhyCBY=;
        b=U2QBgEvytz0OVdB7qVAyFYOnYxqCTNNZXzaEfDPW7sgpgQPWe9F9hIPg3izyZcpZPg
         Nv0+2DwogCW5teGBxwoBT60LGvNDTC3f8a4Yi5KYVVo1A3VZdnVi2NJqHH/qyLxT7mHO
         aaig0IgFlM36GVxz8ktRYa3zLAbZUazNlV/RYFOVr6+FO/d0ZbW85WNZbKhIHCFV5FrO
         utLE8WreiIr0bXi3qjYXmfmziA+3XNVQgT8Pd9PztF2owoMfF2xksWu1E1EZTNgjs/w6
         n1WsxSyruGxx8brwtTfIm4zB5FxP+kZuziD0Xs2u9fQagMQLkMBlVapETYRu8sFqXRqc
         xTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793142696; x=1793747496;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rhl2geudcbOZICdrGNLpkxL+lbiX8RJZUOCOaZhyCBY=;
        b=ZM6PZCJtVMUT+YB4ECjiSqPxP2pnS/W8kE7ePYsX94kj+jYNlSdmZ67eO8JU7sByeL
         joTCR2U61uA1I56xPJXlysKbUraXv+T6PknqvqbWNgofceLuDCMCvunQ8lpuLvy8eO++
         y06OX9oDc1T6ln67zzGDB8rG6jhQSP3j0Ow56gChcw42vZued8+D2l30547COFVUD8vs
         AxfqwRGPKSOEwMSmAqASdTRuveiuZPkJmTUxzg51VwwKMzzitfss8SFJKca//lJhA2cO
         K6zVRdQ3oPdAwv5gFQe/yrPyygA8rUI6x9jtkOLt5SZ0gkFVg2WwOwXP3otbIJ5pLu+T
         ME3w==
X-Forwarded-Encrypted: i=1; AKwUvByap8F3QiGcGxFIsasF+0Ju9inNn1oGI1+ljR8DkSSnPwr4pDYbR+8XtWsz2GNSXr5EdHj8LPUYUQ==@kvack.org
X-Gm-Message-State: AFq9FYKaQYYhsYzxEbq4+wC5inoBhgVaZc4V6ir+6AhYoSaJzct5u3CE
	YX/GYzEi/SGrPegsPqBCCgfKCjCTzlA75epLb9nKFqmvcd7wWyB1cigAN3v35JOOs9jW6ZOSbI8
	2+8zBGrcVMQYoXuzpEroVChje6cO3g3jSpAe55hBZ
X-Gm-Gg: AYBFou3gsdniEK96eK1HAyvn+GTkrIWExQTGJY8gnDvFxuYKyYl89JpdT9mMeAy9Zl6
	0VF9oeFpCIK297++TGa4VLJioSLdjw+Onm/g9dnzY9sx6l89bLpA3j2LPIKFxfhyR7E/b6EoBGc
	A05Dv2ZpE/AU8u9fcHdz+3oP4FDNhL+x2w/BxqUOX4s8zo2Vplz8JcOi4m4zqWhkrF916PN3880
	EXnKQJrdN+9RKxPtzfPK2W/X8pAon+hNGFrCCNHLE0KmoKTW+VBm7AWNyHoQbMU50rv48ZX8BOn
	2Nq1w3dF3R1jm6NoWQmQNQrfQ8GTWaqoOSrEz0w2QgMfa6lbwiNJ+9bzTbbYprfj0OHGnFnUHQQ
	SL7Zykkl3MQx6l1QPcZ8dYbtWEcQZkvF6nsd0JtilmA8H04pkdRHvNBS4LVYE2PKOsZSVy8uz4C
	Grn+dYt6jsOtgcb17Dx13U44uegWGSekjil9dsiaxf7pJk
X-Received: by 2002:a05:600c:3227:b0:4a1:eb11:489d with SMTP id
 5b1f17b1804b1-4a96036cebemr122195e9.16.1793142695725; Tue, 27 Oct 2026
 16:11:35 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261023222313.3979455-1-tjmercier@google.com>
 <DF7DBE4B-E0BA-423B-BDA7-DB07D1C9E564@linux.dev> <CABdmKX3-XKWXwZe5f=VwZeSuKH6xM0dsK7TvY7u9B1hgaPOm4g@mail.gmail.com>
In-Reply-To: <CABdmKX3-XKWXwZe5f=VwZeSuKH6xM0dsK7TvY7u9B1hgaPOm4g@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Tue, 27 Oct 2026 16:11:23 -0700
X-Gm-Features: AclHuK84iU4LGcBkObjk5TD5SSpvHPSR8JadqDMoPlQEagyX_MXN3xEU-MBo_ZY
Message-ID: <CABdmKX3DEDwgO_wj3JDYvx15FYPKGCav8HKvHC-u_EHdGhWwLg@mail.gmail.com>
Subject: Re: [PATCH] mm: memcontrol: fix NULL pointer deref in
 high_work_func() on dying memcg
To: Muchun Song <muchun.song@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, zhengqi.arch@bytedance.com, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F4B3C0008
X-Stat-Signature: roj3huwkcejpf59656nnwd9k6kc38eok
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793142697-35798
X-HE-Meta: U2FsdGVkX18+gbsN0PXn9MflQAr6kQ6jxfkZ8+0EhVNmvIvvY8D5Q/92KYxREoqi26iefbj5u+souKByf7CjPaXNvI4i7lv/54XkQ7Ijjn0PINharryRy4Q5J536rMz5FdVRdxh/vL89itIYKw8F/27lWFk+O7MvYxKQehPBqNdDBhtSehCZup5LjRM50sHecGJdcIDxaCkunpKxpDQKtPJAq5EqVgxqnb347G5ipV2n2+ELkwb5KlK7bre5Vh9YGA1hg48hGJN4T80B6xo7d4wZGaDU8yc7L3yCO4CHYfpU+p0xZjzGwfYRkAVRAZyPUpAhcPGf8Fm5yMFfFD300DwyEX9EkrtHzRVGLJ/Atchxfz5t7MySjRbmRcURbt2ffVnFI/bZLLLjRIaNM0Dq/YFZ4Sg5whqIyno+d5HxXl7ky87WWjwJtXsQ8G951cm5EsD961L0zMb452F2pPSbM7H2oToAIiBWZqTGHjuYc01CsNHBOMd8ddYUsvWPYWNn8BB7RtxABEjLtSJLXXetRrIhEyt9dfI4PKcIW3PyuYctQo3ZOMYSWEvViA+2LbZ/vhvTOSQWIWOWquheDKuL8dcPkBiLka9HHiKqwp1VM9O0Xw4JbBwLe2EzmSixiTqO5sOA34OueGFPB0YFoKBNrUpI03bqVBomdUhNh4UsaOk1uOoDcqAhNx5kXbEDj9VSKmrgtEInOjCifPzRoxxxtQeRgHtpCdz+ek49RF8OGNAAqrB7vPT2oa7yJKGy8XeSO/p8eMcv5CLrD84cRYNNuMYg5sn6Kxl/1Szz+CYlyeIDgR+rdSn2VY+XudChc1qHgTeZnGCXQLGkKPygMBOPeV1khYGvS77t2e1xJ688hCX7QYOY8tfOP+PZxveGMbVbYcsthy/MjmctlCA8DmSdBryWL4zHACu8bjB1sjzjWVhvusPc/msbin+Ae8xeEVKwP9XkvD0antluy67NWmk
 QX47CuNY
 XAMJ9pY7h3l+IEBuPApFb1u14svQ13mdTW7RBFA89eTc4Mu8HyXvzFZeus6Ia43O7+26Nx13CbJbN3dsld7FWHH9TlEC7dPMzrf0YgsizLsaJJlMpZPe9lnn3N1ghScUflx2rqSdlDJ1qMRXHLdmpDIe0vobaQSEu/gYm5WPzEHYyDDCU9xY/Xi1Jz/WZljrYkn2z3+D+CUhRL7PBh7g9HrLlU4n905pQtatoU0rxWhS4vz9+kmr76sAxxOkGxJ2PybNp1FyLJeDa0970JvgX+PsTVuaiDM6GnqqBMVdSHeA/eaZNjHSDu+rOag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 10:42=E2=80=AFAM T.J. Mercier <tjmercier@google.com=
> wrote:
>
> On Mon, Oct 26, 2026 at 7:42=E2=80=AFPM Muchun Song <muchun.song@linux.de=
v> wrote:
> >
> >
> >
> > > On Oct 24, 2026, at 06:23, T.J. Mercier <tjmercier@google.com> wrote:
> > >
> > > When memory.high is exceeded in non-task context, try_charge_memcg()
> > > schedules memcg->high_work without taking a CSS reference on the memc=
g,
> > > and high_work_func() invokes reclaim_high() without pinning the memcg=
.
> > >
> > > Before commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> > > dying memory cgroup for LRU folios"), memory usage above memory.high
> > > kept the memcg's refcount non-zero. With reparenting, folios and objc=
gs
> > > charged to a child memcg are reparented to its parent in
> > > mem_cgroup_css_offline(), leaving the offlined child's memory usage
> > > permanently above its memory.high even after its last reference is
> > > dropped.
> > >
> > > cancel_work_sync(&memcg->high_work) only runs at the end of teardown =
in
> > > mem_cgroup_css_free(), so high_work_func() can start or still be runn=
ing
> > > reclaim_high() after mem_cgroup_css_released() or shrink_many() has
> > > called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. This
> > > causes lru_gen_rotate_memcg() to dereference a NULL pprev pointer.
> > >
> > > Fix this by acquiring a reference with css_tryget_online() in
> > > high_work_func() before calling reclaim_high(), and by resetting
> > > memory.high and swap.high to PAGE_COUNTER_MAX in
> > > mem_cgroup_css_offline() so that charges via references on an offline=
d
> > > memcg do not trigger high_work on the dead child or skip checking liv=
e
> > > ancestors in try_charge_memcg().
> > >
> > > Oops: general protection fault, probably for non-canonical address 0x=
dffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> > > KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007=
]
> > > CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W          =
 7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full) <- Taint from lru_gen_rotate_me=
mcg() VM_WARN_ON_ONCE
> > > Tainted: [B]=3DBAD_PAGE, [W]=3DWARN
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-de=
bian-1.17.0-1 04/01/2014
> > > Workqueue: events high_work_func
> > > RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
> > > Code: fd 7f 09 45 84 ed 0f 85 64 0c 00 00 48 89 cf c6 83 6a 07 00 00 =
00 48 c1 ef 03 88 83 69 07 00 00 48 b8 00 00 00 00 00 fc ff df <80> 3c 07 0=
0 0f 85 ec 0b 00 00 48 89 31 40 f6 c6 01 0f 85 4e 00
> > > RSP: 0018:ffa00000001ef4c8 EFLAGS: 00010046
> > > RAX: dffffc0000000000 RBX: ff1100000779e440 RCX: 0000000000000000
> > > RDX: 0000000000000001 RSI: ff1100000779b9b0 RDI: 0000000000000000
> > > RBP: ff110000bffd8e40 R08: 0000000000000000 R09: ff1100000779ebb8
> > > R10: ff1100000779ebb0 R11: 0000000000000246 R12: 0000000000000000
> > > R13: 0000000000000000 R14: ffa00000001efb30 R15: 0000000000000002
> > > FS:  0000000000000000(0000) GS:ff1100011c0e7000(0000) knlGS:000000000=
0000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 000000000251ac88 CR3: 0000000009d6c000 CR4: 0000000000751ef0
> > > PKRU: 55555554
> > > Call Trace:
> > > <TASK>
> > > ? read_ctrl_pos+0x22f/0x3f0
> > > shrink_lruvec+0x16cb/0x1b80
> > > ? ret_from_fork_asm+0x1a/0x30
> > > ? lapic_next_event+0x15/0x20
> > > ? clockevents_program_event+0x2bb/0x6f0
> > > ? lapic_next_event+0x15/0x20
> > > ? __pfx_shrink_lruvec+0x10/0x10
> > > ? __pfx_clockevents_program_event+0x10/0x10
> > > ? _raw_spin_lock+0x84/0xe0
> > > ? __pfx__raw_spin_lock+0x10/0x10
> > > ? kasan_save_stack+0x30/0x50
> > > ? psi_group_change+0x381/0x740
> > > ? __pfx_sched_clock_cpu+0x10/0x10
> > > ? save_fpregs_to_fpstate+0xc4/0x2c0
> > > ? finish_task_switch.isra.0+0x1de/0xac0
> > > ? __schedule+0xf62/0x42c0
> > > ? __pfx___schedule+0x10/0x10
> > > ? __pfx___irq_work_queue_local+0x10/0x10
> > > ? shrink_node+0x626/0x31e0
> > > shrink_node+0x626/0x31e0
> > > ? ring_buffer_unlock_commit+0x11d/0x5c0
> > > ? kswapd_clear_hopeless+0xa0/0x150
> > > ? __pfx_shrink_node+0x10/0x10
> > > ? 0xffffffffc0000095
> > > do_try_to_free_pages+0x255/0x13b0
> > > ? ring_buffer_unlock_commit+0x11d/0x5c0
> > > ? reclaim_high+0x10a/0x1b0
> > > try_to_free_mem_cgroup_pages+0x1f9/0x5a0
> > > ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
> > > ? irqentry_exit+0xc6/0x670
> > > reclaim_high+0x10a/0x1b0
> > > ? __pfx_reclaim_high+0x10/0x10
> > > ? process_one_work+0x5ff/0x1030
> > > ? __pfx_high_work_func+0x10/0x10
> > > process_one_work+0x6e2/0x1030
> > > ? __pfx___schedule+0x10/0x10
> > > ? __pfx_process_one_work+0x10/0x10
> > > worker_thread+0x422/0xbb0
> > > ? __pfx_worker_thread+0x10/0x10
> > > kthread+0x2cd/0x3a0
> > > ? recalc_sigpending+0x15c/0x200
> > > ? __pfx_kthread+0x10/0x10
> > > ret_from_fork+0x368/0x590
> > > ? __pfx_ret_from_fork+0x10/0x10
> > > ? __switch_to+0x588/0xf50
> > > ? __pfx_kthread+0x10/0x10
> > > ret_from_fork_asm+0x1a/0x30
> > > </TASK>
> > >
> > > Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying =
memory cgroup for LRU folios")
> >
> > Hi T.J.,
> >
> > Thanks for fixing this.
> >
> > I have one question about the Fixes tag.
> >
> > The changelog says that, before f1cf8d2f36dc, memory usage above
> > memory.high kept the memcg reference count non-zero. This is true for
> > LRU folios: before that commit, each charged LRU folio held a CSS
> > reference until it was uncharged.
> >
> > However, I wonder whether objcg-based kmem already provided a reachable
> > path before f1cf8d2f36dc.
> >
> > In particular, BPF alloc_bulk() mostly runs from irq_work. It obtains a
> > temporary memcg reference from a persistent objcg, uses set_active_memc=
g()
> > while performing __GFP_ACCOUNT allocations, and drops the temporary
> > reference after the allocation. The charge can therefore queue
> > memcg->high_work in non-task context without transferring a CSS
> > reference to the work item.
> >
> > If this races with memcg offlining, objcg reparenting can redirect the
> > objcg to the parent while the old child's page-counter usage remains
> > above memory.high. Once the temporary CSS reference is dropped,
> > mem_cgroup_css_released() can call lru_gen_release_memcg() before the
> > queued high_work runs. The worker can then enter reclaim_high() and
> > rotate an already removed lrugen.list.
> >
> > This path appears to have all the required pieces after:
> >
> >   e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> >
> > Commit 6867c7a33206 later changed the release operation to
> > hlist_nulls_del_init_rcu(), which explains the exact NULL pprev seen in
> > the reported crash. Before that, the same invalid second deletion would
> > instead encounter LIST_POISON2.
> >
> > So f1cf8d2f36dc clearly broadens the problem to ordinary LRU folios, bu=
t
> > I am not very sure it is the first commit after which the underlying ra=
ce is
> > reachable.
> >
> > Is there an additional lifetime guarantee that prevents the pre-f1cf
> > objcg/kmem path above? If no, would the following be more appropriate?
> >
> > Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> >
> > Thanks,
> > Muchun
>
> Hi Muchun,
>
> Everything you said sounds correct to me. I don't think there's
> anything preventing kmem from keeping the memcg above high while the
> refcount hits 0, and hitting the same problem in
> lru_gen_rotate_memcg() from lru_gen_shrink_lruvec().
>
> So using Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node
> lru_gen_folio lists") sounds good to me.
>
> Thanks,
> T.J.

I was able to get a reproduction on e4dde56cd208. Fortunately this
patch applies cleanly on e4dde56cd208, so I expect the stable
backports to be straightforward.

general protection fault, probably for non-canonical address
0xfbd59c0000000024: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: maybe wild-memory-access in range [0xdead000000000120-0xdead00000000=
0127]
CPU: 1 PID: 37 Comm: kworker/1:1 Not tainted 6.2.0-rc4-00108-ge4dde56cd208 =
#1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.17.0-debian-1.17.0-1 04/01/2014
Workqueue: events high_work_func
RIP: 0010:lru_gen_rotate_memcg+0x147/0xef0
Code: 49 c1 ea 03 41 80 3c 3a 00 0f 85 a5 09 00 00 48 89 f7 4c 8b 93
08 07 00 00 48 c1 ef 03 48 89 fa 48 bf 00 00 00 00 00 fc ff df <80> 3c
3a 00 0f 85 2a 07 00 00 4c 89 16 41 f6 c2 01 0f 85 72 00
RSP: 0018:ffa00000002a75e0 EFLAGS: 00010206
RAX: ff11000008d46701 RBX: ff11000008d46000 RCX: 0000000000000000
RDX: 1bd5a00000000024 RSI: dead000000000122 RDI: dffffc0000000000
RBP: ff110000bfe54000 R08: ff11000008d46708 R09: ff11000008d46710
R10: ff11000009a5a708 R11: 0000000000000000 R12: 0000000000000006
R13: 0000000000000004 R14: 1ff4000000054ee4 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ff110000a3480000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000007d5c000 CR4: 0000000000751ee0
PKRU: 55555554
Call Trace:
 <TASK>
 ? reset_ctrl_pos+0x10f/0x460
 shrink_lruvec+0x19e0/0x2000
 ? kasan_set_track+0x25/0x30
 ? __kasan_slab_alloc+0x66/0x80
 ? kmem_cache_alloc+0x165/0x310
 ? __kernfs_new_node+0xd3/0x590
 ? __kernfs_create_file+0x2d/0x280
 ? sysfs_add_file_mode_ns+0x12b/0x3a0
 ? internal_create_group+0x286/0x940
 ? internal_create_groups+0x84/0x110
 ? really_probe+0x223/0x690
 ? unwind_next_frame+0xa9a/0x2040
 ? arch_stack_walk+0x7a/0x110
 ? unwind_next_frame+0xa9a/0x2040
 ? arch_stack_walk+0x7a/0x110
 ? __pfx_shrink_lruvec+0x10/0x10
 ? preempt_count_add+0x83/0x180
 ? unwind_next_frame+0xb2/0x2040
 ? unwind_next_frame+0x212/0x2040
 ? ret_from_fork+0x2c/0x50
 ? __pfx_stack_trace_consume_entry+0x10/0x10
 ? arch_stack_walk+0xa2/0x110
 ? sched_clock_local+0x132/0x210
 ? __pfx_sched_clock_local+0x10/0x10
 ? unwind_next_frame+0x212/0x2040
 ? __pfx_shrink_slab+0x10/0x10
 ? sched_clock_cpu+0x232/0x2c0
 ? __pfx_sched_clock_local+0x10/0x10
 ? __pfx_sched_clock_cpu+0x10/0x10
 ? mem_cgroup_iter+0x269/0x600
 ? vmpressure+0x30/0x3b0
 shrink_node+0xb39/0x26a0
 ? __pfx_shrink_node+0x10/0x10
 ? kasan_save_stack+0x42/0x60
 ? ring_buffer_lock_reserve+0x2fb/0xe30
 do_try_to_free_pages+0x31a/0x1880
 ? __pfx_do_try_to_free_pages+0x10/0x10
 try_to_free_mem_cgroup_pages+0x282/0x5f0
 ? try_to_free_mem_cgroup_pages+0x4/0x5f0
 ? reclaim_high.constprop.0+0x191/0x250
 ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
 ? try_to_free_mem_cgroup_pages+0x9/0x5f0
 reclaim_high.constprop.0+0x191/0x250
 ? __pfx_reclaim_high.constprop.0+0x10/0x10
 ? __pfx_high_work_func+0x10/0x10
 process_one_work+0x641/0x1010
 worker_thread+0x424/0xec0
 ? __kthread_parkme+0x89/0x160
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x26c/0x300
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2c/0x50
 </TASK>

