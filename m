Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED3EDC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 20:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00DBF6B0088; Mon, 31 Aug 2026 16:42:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00F96B008A; Mon, 31 Aug 2026 16:42:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEFD86B008C; Mon, 31 Aug 2026 16:42:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B81E86B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:42:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0A70C026A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:42:33 +0000 (UTC)
X-FDA: 85162737786.28.8D14D9E
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id B51DAA0008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:42:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jfC5AFVe;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788208951;
	b=CR8yUv+ikZGBKILSwWxt711Hcqn80uvsRhxHdFY2GLE2FUyTeoezp5vDv3RJ6GD9QFapXc
	D5JaLe5D/qFwjLPNHBbUWILDjJw+5cbNmp9lDv8cpM1O1C5vlkr2jkOjgXXtCfkPLAzQjM
	TVuWckvvW+gOt/nszi8Ftt/++UjQed0=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jfC5AFVe;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788208951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jezNBELpt51SbHBtmRmjdqZRoyOEfGekJU8Ocm74OA=;
	b=wSS3W42MGNmZyhnpaB9DnPyxcmcT+wKpjJ/5CxBX3GjJJ7AnO5Ui4+uuocuVf7kD7+pwdp
	2MGmIAaQaJ7o1qykO/Bocv5ohq348b7sEZaKn422fF6GC9XtSH1+YfITjin0LzLibzImAt
	KUtuc9+tz/Vd35nDBfr6ldQB88hRpck=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c01c79467so88761cf.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:42:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788208951; cv=none;
        d=google.com; s=arc-20260327;
        b=BDJRk1N2ZVbFwfk1p+Ns16DszD/126xULpubpLq9OKKPqsaB8ZuETk/3yhf+jF9UZ+
         jqBHkMuH1e71H42PhKdQWtCIAb4ciICiMkbYe9IQ5NcVtPD2g8ODwZA3UlBSo6NrJL6k
         syZPmhoMf3qrl9vD0IyZF9OXoo+OULbIj0F89OrLDpAZe+r8xFkmd8aIksjwFr8cdZd+
         JHTENh1FWKnxdaIv3bWLTZKwC1/CKBfG7tmsZQv8FvjxdM5Ydu7YJhBHVXeYyFDW1LK0
         gT50EuLKz7u3TdJxMIPRJK9vHHnOflf6L0yQ1WnSTJjCFx8VzrAhp1zB9OUmo+ucWTZf
         Z0CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3jezNBELpt51SbHBtmRmjdqZRoyOEfGekJU8Ocm74OA=;
        fh=EpynythzprbH263bIYdXYi2N/CR/g4z30/h1E+BGXZI=;
        b=UN6zCRGx0N6jEGmg727ATBvvmSW8gLLp0rCgUJzmYZTCHQ24NdrJ6LZ6mROMOMQzQB
         +tkYF1Kk5beu82ij21068OADaT9wPCB4PO98zZv/BETCufDEmX4YlwEVwoef7tWOX91h
         B0O4jLhk4K69lzsjd0HmBysf9kEa0qVuFlQXKUNyAVBb1f4YPzUADPsBp9efph3Ra82n
         4M0CKdHdepF6+2eLQnJSXDYLmjXsXHMltzKXKhVIKy72/5R0kNTH9SECh7nMq/7QtN0x
         F4pVp5pJHM2cYjsltfOx3hp/K42t0TbIgK3FQAl4KmeD8K5W7sghA1G9keH+ae1XPaur
         qYYA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788208951; x=1788813751; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3jezNBELpt51SbHBtmRmjdqZRoyOEfGekJU8Ocm74OA=;
        b=jfC5AFVeIDG2578M/9bMyWqilvElJ9XR77nR9fzvcRpac6YPYxfn4RqKaE+dB3N55C
         OJPXVE+uBy++AEQpxrJ8MDalHbv7V0Ks9MkdvwxNtGJqC4wk0cV7lkiKgmn5CigD15RR
         QTfkcBXXJfwWySXNgVtgKUvqPAd//GRZ32ug18dRcjIVlwtPDQ9l5dQ7c3g7vG0ncwHH
         2iTmONC+T5wbVp2zIoBmT2/NFYKhgWii8+GuZbKU8zypyB9bLufHrSHlIA5OHfP96DbS
         RpKshZOE7TCj6I973fAGh9sVST630ecpW/SPqBb14lhfucOhT3sRaPJIk+RKv7Lu7yoC
         /Q7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788208951; x=1788813751;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3jezNBELpt51SbHBtmRmjdqZRoyOEfGekJU8Ocm74OA=;
        b=IHSjXJsX5FTwILX7XSqYqxuJa1gyl49BkrQkfg+prRVYeQgfLELZBrRR3VC+8JQuky
         nuwD6Y+3kUehvgQJRdU2CBfZE1tCdc9WK2Ai9hX80EU4jokNeW5Hu66xk6fER8V51/23
         jmVmFb3krEz77KMzu3LIiLLb2w0TxcNRoxAFlzzfCdthbst42CJTH3A3ZSyDUAsdx0dc
         xiK3hfPrkpP8W74wwF72JV7bjhPBjTJEyCEY0sIkBuC7FMT1xJMXNfLvOmF4stNrREcN
         zkhh43lPCxX1LPJw0jVdGig4PwBRfvSnZJYFiwo+XxjNWHNxTx8io4tAsKyoTZ36x2n5
         xWYg==
X-Forwarded-Encrypted: i=1; AHgh+RoqvCD8cVBKsu8tPHRxMV+nFCv7vJWTT//QkrW2xKzsH6gHyEsL+nYng15XmJvSjqYeY/IhqKRxdg==@kvack.org
X-Gm-Message-State: AFuF++kq60hGQZZloQ4/bv85oKdQFqzgF5fnFw6PM9dPIxCZevPWWsXG
	YpKIRqj/3rzYDZjqQvVXkSvaKP7jviHLSJLgxeFcaGR36aj7jjIf4of1QaW+T32EmfLFSc382EH
	8IdPYFqWtsoYKsIeGEdo1c1XMkz1rZcccu3MDj9LU
X-Gm-Gg: AR+sD13sWj4Y2xQUY/VihzO8YFiBifkrfLqavXo5X8mSBC16xYF559igLd90DUJq/3s
	2od89d0XmmoSMDHp6z3DavAjNun2LwWuTJqt83xh6SX9JhHSPK9gTQpvY+ZO5fb/h+5NzFmV30+
	yrQ3yBo1veL4/KID0Dz0M9NmgaV7sM+uLt/GoX+UHzeagT5gvMGjh3UjQ7Lcx6N3FpieI/fqc5K
	dTpgoQmTC0wmzsa6gesDOHvGJa6LinAx7ErvgeL25q2/HCCTaWNC4vSJtP9xJBtvgMYyHE/7bwK
	xdt0mgsXCuHdqXn6zpe4GmV8QL+zSav74/FKANlwCR4=
X-Received: by 2002:a05:622a:229c:b0:517:64f6:3365 with SMTP id
 d75a77b69052e-53024d4656cmr4002881cf.4.1788208950057; Mon, 31 Aug 2026
 13:42:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260813193433.3318288-1-surenb@google.com> <20260829185625.f5ee1b2931818843a78af88d@linux-foundation.org>
 <apVhzM2501wSiGGg@google.com>
In-Reply-To: <apVhzM2501wSiGGg@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 31 Aug 2026 13:42:19 -0700
X-Gm-Features: AcwNN1Va5-U2p_HBt_SoCk7IUhZqXMl0RB6eAwv2hmO5Zse_aoEhwTkiwxqTQpI
Message-ID: <CAJuCfpFLwkYWAsK8GrHwmHT06egrMmNaKYU+WY=5Qc+HnacWxA@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] mm: Unconditional per-VMA locks and cleanups
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@redhat.com, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	jannh@google.com, arve@android.com, cmllamas@google.com, christian@brauner.io, 
	tkjos@android.com, dsahern@kernel.org, davem@davemloft.net, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: o6z5p6iueqk9e8ap88me8i8zgwzs51iq
X-Rspamd-Queue-Id: B51DAA0008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788208951-33185
X-HE-Meta: U2FsdGVkX1/k+F0UwP3ms3E5BYYZ9ASiPYogOICgt1nBDkfpsQ9afQR7DmMFln1UPzk3QrG39t2oUwNO4M3EWg+dJBpUCmOuONbx06e+u7ibzcYfa3GA9u0tDaPKT22yAghyYovGv8w1Wm1ABHcAwBTya33+kSeYmTspNCQb+fme6kpVybuxf36tnqkc5zYkJlb4XWkSTtHfK8GPxgEEUbxH/lXt4RRVtevNFSc/GbNuzmpQKS/u8/X0o6zxg0xDGSfPnqCF4w26FZqEFsmLeLhMntdAkPIGkx6Hxr+/7wc1Nty9Im0qNMQhGrE/q6zSNybwsnMThU1JxUSrA64x3lhtaTBcZM+X8plWEE2AC866Ar/dKkhso3MSwvmemj6HMdHK8FZqWBLtfSStYFsUbVefRK9jvi/DvWB/XgfYSKvwytWbLbIWaZPDhZFLhsWtjolOB07pw63zFSQToToyltmNM6xpqom5th+DW1rryDvtTm2d7qXlJrkYNuHrzXZQhGsyHvV+N6856cGaLf7saORPe0H8zd8HQCDLNDXUm86cxE4ylpFNWHcCIt23F42pjclJLHycxT5dWjyuqcoh54Ru39ohovT2OfilnxgzlmeL7sgiYflvM3K4iCCg0uqtqXrfHHFBDgrmcCetOZZ3BKGct4bnl2cH9jrDCGeSkJWnuGH/sKhJDh1tEloxYfnVIkOCue2KGcqxDbJqtF+6mFQSMDl5+scQg07ghzyUp9IN62oPTZMmz60lJmM26TIB3Xma2JQv3beCVXar9cV3Lmd6chkBxUPsPHWyl9SM+FroXOJ1+fjCklz0I+pU264juVNRGYZlTiiFHNKuhMh0/xos0x4EYoxQfzHxWYrG5HZ9cnONhEPtYGRqCO97DjbolcGuuevITTcGAFk59xk9quFlTeMCyapH/ZNYh9uJIU+8kWkbcge8dT8vSIHK6MFcW91Cdt1d7aJqZupiwJv
 ZY8baJgu
 +JMb9T/kztyyRfpSlHHLs3QVKKt6nJF7T4Lbq+qmMp3eYoE90n+ac+Bj/xAP/nwUQ8LLPMOqRj0j60eIRg/Xm5gmSFKYS8YY89LUYHNZYdJStyeQBseS2def1lBj7ozJlS3y3ArgtCARaDl3NvRWESuv//GuXkFOWrqoI5rOzo/ZKs7u0oJ3JEBAgYCPoFRWA28Ac98z9SM6O+DMnPXJE8GzSw6IUgwinOPXZ5ZK3CLvEP+wR+HLH+KwwDkYeZPuX+ExGjgeew0vRhvUACWJT5026JP0sOIrOicXy6ROnWf4rTj87Scxim+GX8SRkA4urfjM/T2xxP/TSdHvu83Nc2af9Vz2Wzay8VOvMLheITI+FGLWsBjuLJbi91hrNcHruWxQX8VOyC5KJqUpUsVHe4Rodcz0Pc39YJn4A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 4:13=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> On Sat, Aug 29, 2026 at 06:56:25PM -0700, Andrew Morton wrote:
> > On Thu, 13 Aug 2026 12:34:28 -0700 Suren Baghdasaryan <surenb@google.co=
m> wrote:
> >
> > > v2 version of this patchset [1] was written by Dave Hansen and per hi=
s
> > > request, I'm taking over this series.
> > >
> > > tl;dr: Make per-VMA locks available in all configs. Simplify some
> > > of the per-VMA lock users now that they can rely on them being
> > > always available.
> >
> > It's been 2+ weeks so perhaps a refresh-and-remind would be helpful.
> >
> > But it applies well enough and is adequately reviewed so I put it in
> > there for testing, thanks.
> >
> > AI review might have found a couple of pre-existing binder bugs:
> >
> >       https://sashiko.dev/#/patchset/20260813193433.3318288-1-surenb@go=
ogle.com
> >
> > and a small rusty thing which you might wish to attend to.
>
> The binder bug is not actually a bug. When using VM_MIXEDMAP and
> vm_insert_page(), the vma takes a refcount on the page, so there is no
> use-after-free even if free_page() is invoked without removing it from
> the vma.
>
> Adding an INVARIANT: comment to the Rust code SGTM.

Posted v7 with these fixups at:
https://lore.kernel.org/all/20260831203056.838265-1-surenb@google.com/
Thanks!
>
> Alice

