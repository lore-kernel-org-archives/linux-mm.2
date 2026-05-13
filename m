Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D24BBCD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 18:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9CB96B0096; Wed, 13 May 2026 14:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74C16B009B; Wed, 13 May 2026 14:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A246B009D; Wed, 13 May 2026 14:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C630F6B0096
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:39:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DA0F1C0170
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:39:23 +0000 (UTC)
X-FDA: 84763259406.03.53F3B5A
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 69CCA1A000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:39:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BKxgU40G;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of olvaffe@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=olvaffe@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778697561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNjIBxdTI24J4nuaX+mtueI54MsI3QKTiFzpbMRC0CE=;
	b=W93dIByyG8MCqlDKtAsa44VpSPFvflZgHmbWx3U6GF5+iXiuqRP8cx0pjfqwL8I8It/MIv
	T4XOmnh4SClPmyOwJ2b2Cynvos0+fERtOjircXWKB0kzVP0HuQtQfAdnRds7ajpplBAtzT
	mFl+lAxAEUQgxp+ZEWibkPm2dZqynFs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778697561; a=rsa-sha256;
	cv=pass;
	b=f+zlHrecXurWgbuqkx+cm1X99SbAOh4PI4SkVQSKBhoyCo2RuJx5D3Gk6n4fwG2DhHV0jF
	eOiYxXfw257aAbD0iiMc//h8UBUGhpevwSvGMK2KA18FC8dX0GAJnSrqW79GBNpt7Dp2Mo
	qhTPns4FOCnIJ29eh1rGs5raFHPGizo=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BKxgU40G;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of olvaffe@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=olvaffe@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-65318dafbcbso8017642d50.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 11:39:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778697560; cv=none;
        d=google.com; s=arc-20240605;
        b=RTtu/V7sC9AjP9CNZ7TPDtus4BpGfbkBsXgRw8EBcjJjs5950HMvAkVtM/FC2jM2Rk
         Fi+iUXxoh+0VRZvaevxTAtB1sjDvkQDunRO7Qin3CC8jXE0/kc/FCEc9rHg4WK2XPWYh
         ozngaRspdVeXC6VoxuWEiSccBs7Vgdgkt2zpl+DDDtxAAxbOjNA5woUkBN3+xLGGLTTk
         K+hO4KwTAHaV1IVC/1VUf2zZBjBBNf6QP189ZhypKyA3RvsFX62Cs0836ODhcA1i9fRk
         fi5McPjWO7rgTevl+oLRlg1ejTv9PMxXjyMa8Ag43Tc8BT60RBaISAfTj6NlLoB4mVXE
         YaDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QNjIBxdTI24J4nuaX+mtueI54MsI3QKTiFzpbMRC0CE=;
        fh=ry5jIhsBBKW1PRutHOXu0A7Ac9PK/mAMBZuHR54/ufQ=;
        b=OTtp/5dxLp5uQp7jK/t/ittttjj/J1uniOdYJsZMGmkWrQh6tECvaVrzz5dAYeP721
         28JkCZ6Q+IZSmhctzLD/Fd5ki8PqrKwKeTpA8507oMZa5fQblAXwPt8TuCNndO+MdyR1
         qQ3B/cChQBWBYpNwuKwwkS27TdOJ+aZSSWs/a3hgb9y7RKxJ/VY8pYq8H7aZJ1ir1gGa
         5WLkggW/zhBdyn5CvIT3vaRz9ydgIf5EZIlaRJcQJcLbCzxLFs0U21rlu9jl9veIjO/G
         pEPhJ/xu8ZhVlWB/jlQtBis+pumgcgqbpJPE+A+8bTCH0xIZqxd48FLyUDPw5dZ6+xcx
         lpcw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778697560; x=1779302360; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNjIBxdTI24J4nuaX+mtueI54MsI3QKTiFzpbMRC0CE=;
        b=BKxgU40G872suwu13LZkm92ducpnxnIj5HDi52raR0m2Yf2yKrrxN4eEp1Zzi/KZBm
         6KwTNDE8u+lZ/B3NezqNuGkkPtOUPXkgmk+r6sv5pXs6bYXuj/rZVPBxoEm2eBvKT0KR
         6jQ5oc9Gqp0yh4vfTaqsQ1iVZ0EhT5QXmRc1qX0GakU7TOKYI7hcBRDZLrGni2WfFfqE
         s37bmClEPxSF+6tj8mqZB6kQ6bxP7aBL9nUW193332NYmg2qZ3pRYU/n9U0/C0BBKx+F
         TdtaY+fKtk8/5fvFqedEDY5t3RgKvwR5ySjtJUz4qaaubC6UTFxlDGVHMjYnJbZ1adSM
         WrcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778697560; x=1779302360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QNjIBxdTI24J4nuaX+mtueI54MsI3QKTiFzpbMRC0CE=;
        b=GgED2VIpex0QTn2MLi9xph+RMRJqvPQb0mjJE8EzA+mKoJuKNchK6nAoDTE7sd7RRO
         l+qX2NJtN73/x3Ua5EKppaE9qeflDclYNSwPN1SU44htlAdK4RLXISxaKWF7IbAGY588
         anX+k4B9FFeW8H+i1uNdsynds1RuzZe+ZLYhMTJwq67ZKkiHHUVAsAVLRjuqNGVWCi0L
         oSEYdgnwUAvMDXtR8cp+0x0uHlbqczcrRK67sxsKg4WVTS8bFWQaugssXZyqSWVrnoU6
         vbEtuh3rTa1F3I+NtekxzyArP+ce9MvTy+VCQK9fpOaiQRHCjPCGFkWEsjjb5dR2ylkH
         58tA==
X-Forwarded-Encrypted: i=1; AFNElJ+ejuJ2S3+yvFCk0tyGD0KhD96JUB77U+c6cJS+0ykQI106a1CweZ2/6QN4P9ofiv/HXU7KD/GI+A==@kvack.org
X-Gm-Message-State: AOJu0YwmblG6TsUtp2QuB4u2Bw1tfigS/5U8N+irgPXBli+2y1L9o58p
	UNtlCUEjOq86wUAmZQw3YlJnTPnMbb1D/5zON2p4NmezSjUJHPX3jmV2/8J6c6M/9u6Y49sNlzR
	F9fZ189IY7dw0wc10dcOuowG8sgIK2fo=
X-Gm-Gg: Acq92OGpmFaHTQ5E3fqUHlbJ9WsEIeGx+2fvaHPNakUBxOYGg/IVPFRLzenfmC468EW
	zr/1DfU/tD/Ice2Sa2pD0XxxhikljH2bS4gknJMBJ32elOGx458Pg8yiTsTYrFOqdMP3bUa9JhT
	dB+vCj+KbXgHb/B9KFVkFqsDH09rNjs8xXX15ELQUJPv1J0qTCYEuMuQwnAfJNCtAuO6wgxQUr9
	65NMjkx1bhlS9Es37a7r9HG3Kg1Q2qUf4zZAIDWC1DivuunC9ID5unUMfWUrGU1hpq/y3UK817w
	momoqQy0rfTGLRZN93I8sZML1i51pUVIxen4HCWxEvkBdU0U1Vctx5pK/6ILLGYDlmt41viEqeQ
	qAt/sKlcz
X-Received: by 2002:a05:690c:86:b0:7b2:136d:2436 with SMTP id
 00721157ae682-7c6d924d638mr37588517b3.8.1778697560337; Wed, 13 May 2026
 11:39:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-panthor-kasan-v1-1-d8d3e275d71b@gmail.com> <20260513111100.3b2e080d@fedora>
In-Reply-To: <20260513111100.3b2e080d@fedora>
From: Chia-I Wu <olvaffe@gmail.com>
Date: Wed, 13 May 2026 11:39:09 -0700
X-Gm-Features: AVHnY4KdY32-E70JuFOOj5gszczZhcuozJZplwr54_LWaLyRlAdvTym_0krE_CA
Message-ID: <CAPaKu7RkKuGF4nGbOPhXtRWvJzf0njR6c=hn-CG2nTdEa1-DMw@mail.gmail.com>
Subject: Re: [PATCH] drm/panthor: set __GFP_SKIP_KASAN
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Chia-I Wu via B4 Relay <devnull+olvaffe.gmail.com@kernel.org>, 
	Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 69CCA1A000A
X-Rspamd-Server: rspam04
X-Stat-Signature: q5z8qoj9wa4cuospkmqz7bjwfh7umesf
X-HE-Tag: 1778697561-744561
X-HE-Meta: U2FsdGVkX1967rHiZrmF3n6klN0MffEAtCornpZLSJUbEg1f24TpqVGHiJ0SP8Jykv+fZRBftH+hJ7A1QNACBqmNwZkb+ateFv2pB1zMN/vIJRfH0EnzeXzZtoKIW1dE/7gwaejyZL5tZZw6QSeDbKBga1HvAjzFgYDpckYx9L+h1SBZlSM2A23l4psGFL4EP69r4KeahwRDBrK2wP4BxyKN2z07rc6Id60Aay3MZmeV6RNBsIarwGSMtwRB89W6rE9h3sTdO9AB35OJLDYCxfHSHAQ1eCKorgy4k//STugS5SBzyKAIJBSWLtN1jRjbh9Vla4lo5LXxpfDPbcnm7um+qBOWuUAjKEp23hQxTr8G5v4taxY/jWnTOhj9yckdr10JJly1xLVzxCXJsLpRpP5HcA1xJ3iS/3+urEdWHERe/tV5ytiG7pNTffyNfxwYFv4PDW0/h6vrUxaFYd4BSYEZvDdm9pwicUjlNQnS4JDvIysvHoYEfamCv0cGlNI1QaSmv7jOU+LBNFrAjJCww1fop0jKiZIutIuh6Cbj8lnVlgrrvlYbww08BLXTmPTN4NNKj780Xv6fIB5Cfr5cmhayjm4gbHqhB2Z0yxxd4ln+OhwVnv93DYEwExXIWeIEXZuOlKwuAfiSt96Ou89H+nyros8qkVQApGWIfo0v6FHVgrnkj+Uc+U+NUHjV21gbzmz2XWchRd20CCen7WjDnSlu0gfoJBGr7t390GnTb84lkuyvPPUxtHJvWer+ISkN/+8evRkfX+3vPoT4tmXD3rYGQfdXHDFVBjhhTXLKZbk2U+seV+HWoZhq3v5WwUosA9M5QBGMzIfUKaDYtkqCQDgmDNnQhagFSxTtlsEcY4wKecZR17pWOnSKERSeQ1CKU2W/jMERf+p349H5y8J9IZOkYp6d8178gHMvuG85K4PIBq7jtv0ywFX0qy35PQUiSJu3eGyOvKWvz/r+Du8
 CQM17DYB
 wqzLTKiquqC16Fj5nbkSRvZW9fUy4Z7MrIqFbcOlAVsXxZD6aNujedFivqXWAsJE668nDc2Yl9bohaXbNJbJUw7tT7zcQOJhf8arORAJpgdGzZ7kJr5kCoTP8tjs3W6uoCEJ4BCkTztH89O0Npq29fDHC3+s199a8PGtJY8nv4EV/PtP/BJ0HCfv606Oh0szDVne6RFYEBx9+L6yEpCqT0OQPBzXyY0V4tjCI9qLlgURgIzB3/8hCW7XNlqlZEFfKRsDSxX6p6e4abTP87nOy74fjDzbKcwZifgOc3LwgxlTaGMRI8Djc7aGfss4sjqOMAS72qo4HJmn5hsZk9uZV6RGoS6PgCsiYtHYWYKobQkND6Ze44r5fpivQOhUUNDCh4XzdTN86//UlF5E5gSzRAwgTOGVhViiCOdbwtrOqTxNM2GCr2DmOHulC7/CUtoh2Z+zeLU9s9RY/Rj13HtHJm6oIZ8Ye2QRDXS/TPt/0Szie0bGTOr2lMqlHPo5207Zbig6iv4ACSxFWSG1/WRSUa1CBOua7ZbnM9+TCuY6Esk3UoO57DrVDLyjQ/k6X7YPJRoLfxBqgTDzVMRsJ7VU/0wZ0sg2k6YjuMXzgv7gcNS0UCWGUisjSJSo+6bk9fIl5YiDgoIaTnDc8bxo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+KASAN and shmem maintainers

On Wed, May 13, 2026 at 2:11=E2=80=AFAM Boris Brezillon
<boris.brezillon@collabora.com> wrote:
>
> On Tue, 12 May 2026 10:36:28 -0700
> Chia-I Wu via B4 Relay <devnull+olvaffe.gmail.com@kernel.org> wrote:
>
> > From: Chia-I Wu <olvaffe@gmail.com>
> >
> > Pages that can be swapped out should be allocated with __GFP_SKIP_KASAN=
.
> > Rather than setting the flag directly, replace GFP_HIGHUSER by
> > (GFP_HIGHUSER_MOVABLE & ~__GFP_MOVABLE) instead, which should match the
> > preceding comment better.
>
> I'm not too sure GFP_HIGHUSER_MOVABLE & ~__GFP_MOVABLE is clearer than
> GFP_HIGHUSER (without MOVABLE in the name) to reflect we don't want the
> MOVABLE property.
>
> >
> > On a CONFIG_KASAN_HW_TAGS=3Dy system, without __GFP_SKIP_KASAN, the pag=
e
> > allocator assigns a valid tag to both the kernel mapping and MTE,
> > instead of assigning the match-all KASAN_TAG_KERNEL tag to the kernel
> > mapping. If userspace also maps the page with PROT_MTE and modifies the
> > MTE tag, accessing the page via the kernel mapping results in KASAN
> > invalid-access, such as
> >
> >   BUG: KASAN: invalid-access in swap_writepage+0xb0/0x21c
> >   Read at addr f5ffff81aa71dff8 by task WM.task-4/6956
> >   Pointer tag: [f5], memory tag: [f9]
> >
> > While userspace cannot map drm gem objects with PROT_MTE, the problem i=
s
> > shmem_swapin_cluster. When it swaps in a cluster of pages using our gfp
> > flags, some of the pages might belong to other mappings that have
> > PROT_MTE.
>
> Okay, let me see if I get this right. The gfp flags we set right now
> do what we want for out GEM mappings, it's only when swap readahead is
> involved that this becomes problematic:
>
> 1. swapin folio for GEM inode X
> 2. shmem layer optimistically does a readahead on the global swap, with
>    our GEM gfp flags
> 3. the next swap entry belongs to some other tmpfs/anonymous mapping
>    (not even something on the same GEM mountpoint actually)
> 4. because it's our gfp flags that get used for the folio allocation,
>   the KASAN poisoning takes place, thus messing up with the original
>   user-request PROT_MTE
Yes, that's right. At least that's what I observed.

A little more on the last point. shmem readahead allocates a folio for
an unrelated mapping using our gfp flags. It unpoisons both the page
tag and mte tag for the folio because our gfp flags do not have
__GFP_SKIP_KASAN.

When the unrelated mapping is an anonymous one, and when do_swap_page
maps the folio, arch_swap_restore restores the mte tag. This creates
mismatching page tag and mte tag. When, for example, swap_writepage
tries to access the folio, kasan triggers a false positive error.

>
> To me, this looks like a bad isolation of the readahead logic: we
> shouldn't cross the inode boundary, because gfp flags for one inode
> might be completely different from gfp flags for a different inode.
> Let alone the fact the boundary being crossed here is not just inode,
> it's basically the entire tmpfs mountpoint.
>
> TLDR; I strongly believe we're papering over some more fundamental
> issue in the shmem swap readahead logic: with MTE, we can no longer
> assume gfp flags are interchangeable, they have to be enforced and
> match exactly what the user of the swap entry expects, meaning
> readahead should be constrained by the inode boundary.
I totally agree. shmem should not readahead past its inode. Or perhaps
it should force __GFP_SKIP_KASAN when it does.

Adding shmem and kasan maintainers for suggestions/corrections.

>
> >
> > Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> > ---
> > The latest snapdragons appear to have MTE support. drm/msm might need
> > the same treatment.
> > ---
> >  drivers/gpu/drm/panthor/panthor_gem.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/pa=
nthor/panthor_gem.c
> > index 13295d7a593df..08c03aa0db2f7 100644
> > --- a/drivers/gpu/drm/panthor/panthor_gem.c
> > +++ b/drivers/gpu/drm/panthor/panthor_gem.c
> > @@ -1013,7 +1013,8 @@ panthor_gem_create(struct drm_device *dev, size_t=
 size, uint32_t flags,
> >        * going to pin these pages.
> >        */
> >       mapping_set_gfp_mask(bo->base.filp->f_mapping,
> > -                          GFP_HIGHUSER | __GFP_RETRY_MAYFAIL | __GFP_N=
OWARN);
> > +                          (GFP_HIGHUSER_MOVABLE & ~__GFP_MOVABLE) |
> > +                                  __GFP_RETRY_MAYFAIL | __GFP_NOWARN);
> >
> >       ret =3D drm_gem_create_mmap_offset(&bo->base);
> >       if (ret)
> >
> > ---
> > base-commit: 6101f78b684895d5860a96322e607e0f46f433ad
> > change-id: 20260512-panthor-kasan-10477239bad1
> >
> > Best regards,
> > --
> > Chia-I Wu <olvaffe@gmail.com>
> >
> >
>

