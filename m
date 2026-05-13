Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA4CCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955266B0093; Wed, 13 May 2026 00:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DECD6B0095; Wed, 13 May 2026 00:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77ED46B0096; Wed, 13 May 2026 00:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 61BA56B0093
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:30:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7B5B8DE8E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:30:23 +0000 (UTC)
X-FDA: 84761119926.15.C41BE9A
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id EBF38A0002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:30:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T3fsBY6p;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778646622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=++51JgwlPF+KIP2CEdwk0uQUy+dDgmow5m8zecagfeg=;
	b=bRU/V17ArX04kaR+5hM1PtC9bnvp7Q2LstSxKI5ihziPtSUwGF7azKrzzAzS5e/90LeoXa
	YXDtfc/Z06RRLOtssAE9CoLXAGDJRP+YLoPIRaEy7OutVN8iFYdvOZV4RF8QLz3w60SsRl
	DOU0IZJw3BaKwxx25Xl5wB9npsweFoM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778646622; a=rsa-sha256;
	cv=pass;
	b=vMXL7XEowdUS6cTUUsmZAX4E9gU5wWbw2Ein76j6awbMQGL6KkKgNA11JD+x4SCLeTLfUj
	vSsTmLGhHu8ilCVwZ0xstRI0VUblSGCjJcVIcksXvUAMxIyB6K3lXeMKZotCiWpAEn/CFI
	WHWxXvxK9974rF0UeebYrBRoOpHStYM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T3fsBY6p;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50d864c23bdso3841cf.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 21:30:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778646621; cv=none;
        d=google.com; s=arc-20240605;
        b=XeiJWf9gbQ3LXkR/YTbPKZYAeUGvLWyKyAHBHUouq0Z6pUlORCMMxZgjaZf2fbMbXF
         OvUS89hKGGMAyuDpPFaYoqnj9/rOqu90TC2LJAeAOq0i/bcYhJ6J7JyHo1C/7yrOEhOa
         mkeBoDNt5Csm/McIsHwUDp/Fx+umQ73gPq+M1pCqfwdiO0y18Bq49ravumvQtnT7S3Lm
         bE0tkhOWmTmVVJ2bSGqJd9+RUPazbCCsbcCQRW80MZv7txjbJBCDsS/Sr6x/1BZiGcfU
         xvOFHbI8bIz1EHBm9Oab05KYgb1HFzCrnDBxrcmmzGh/dr5EZOofPl+EMvT15TdwCCZ4
         WbkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=++51JgwlPF+KIP2CEdwk0uQUy+dDgmow5m8zecagfeg=;
        fh=RJZEkEVSYRdSA5SS8Q78UOJWyMczrPZdG7zZ4DajGJA=;
        b=MaNw1iet9c+81O9/nwgfsf19b9Wf2DNJD4VYgp716zBJ0Hp4YsyXPFwu60G3yBGOtr
         3lCN8R1HQRi1ssMhOJqEW1+45SjZVYpbT9aWKd0abELxHaO+WTadU1F3OxY2OgRoHE6r
         OkPhTI7/dL288EHbTxBaMI7x2yhjRdjrJB0sSgH845oFc0OtlZThuaczeWfHC1/okqc7
         E2ITrA6XRrKSThPVCpF6EDrHG7kljfYScaP4ECdTtVRWmsVnB7oaGBKpcq0QG4/lJCQ5
         YHWdLA7CgizasMVh0f163ULDSw/UXSXukKpoz1ipFBEgh8oY45OB5rk/c5FM3xMI1yIJ
         Efag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778646621; x=1779251421; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=++51JgwlPF+KIP2CEdwk0uQUy+dDgmow5m8zecagfeg=;
        b=T3fsBY6pv6IAC+XSw5+jQFYceSQhdU6au4u3sNuFXduMwMLYnno/y6xNXj0a71VsID
         350tPyHbKpTnvZjgTNj3JnNPvWpvPeRagnHXQOe791CCmNVLsaXwgXOOH7f7IGzDl/1N
         glzJm8YHa8NGs5fAyauTz3/+oXtHaLUzQFKwFgEDutjpLxz3xgEcSL0T55OLkifo7Imm
         9RZvHHdBAtSfa8KL7x8zEkALT39xzfT+SyoV87KqnRFxy00Rg3SKFurGa5zzq8wTnAJ0
         sDLvOLjMrjRXvfw3nayaCunJMuUDaz8vXf6dHG1/byQrMgzH2CS0n6aTdEX/mZIOYxLD
         qo5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778646621; x=1779251421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=++51JgwlPF+KIP2CEdwk0uQUy+dDgmow5m8zecagfeg=;
        b=ZVzMvYOn/Y3fuf23BZRL+QSSf4A3nQoHMU9NE83zvaVy3e7dgI6oRkNunukRitxSZj
         nWE4c6pp4SRGd26MS9IFhiW1kyzVbPKJt++K6E3bgyXgZQLjO6+sLTrjHtkkbYG3HApN
         /Jjv+Cyg5yNZqMgn0e0KmuRRteo887co26noILJCRmUe0l8Cdv/4vT2C6uI0S+Xat3tf
         0iXIf3GdEfZe+w4Luqhipc0os+pz9mEGnlU1hLUzWhGB2aotMXcmcjMF4daI39AFGpRm
         u7fqvguIciEcXprOIa/6wH+SJobNgL+ur8sgadFXiUudNYjXIQMDG3kkLUULX6yP2Dye
         Yrfg==
X-Forwarded-Encrypted: i=1; AFNElJ/Pmu745LCt295vTmNZok+SOUIVwKJbNwYuxQCw25SP+n/9Pmz/eoVKfwqAP185mkWLPzVaNBUkww==@kvack.org
X-Gm-Message-State: AOJu0Yyoin86v2osbHJdHD+nxZDTVrdWvcgfV940krqShOdUxQgglPXS
	NjRzNyOm/h2FCCiQv++pYhzsmSdoDu4zmGGvKZPIqQmsG3dSruoKuiuuUMfs4F9rbRBChhwHS8r
	Ym6dX6RMEwag52hi+0TBfM2OeN1BAuKb8LsN7ObJu
X-Gm-Gg: Acq92OFoU7ML+1k5+94LF0G9nanT/JoVkGC8WxETvmoNCALaIfiIteBozzFWQXQ+1hu
	B4bdr00fvqtKtfPp5dBo3Ms2WRbm7zK+whM9ko9S2RB8RvRlWo7X2zbCZv9cMp7rtw1/xxrV23h
	lgiqOkeOqQnnW4eiCKSXKo4TGO8Mt4hyZL34s5cRSOgxn0QSR+c+QK5iMhvo8pfbk4NTwOdtVHI
	7PG4FPKmzqbfQ4mrfLdmZot1Ex2pA7jf6YIKFE9Pxc8qComGMy1vzC2OQVnMuaWPDvX5C8PfsAu
	/dHwg3FR00aEbfaA
X-Received: by 2002:a05:622a:5885:b0:50e:5e19:587a with SMTP id
 d75a77b69052e-5162f6cdb43mr7087031cf.3.1778646620581; Tue, 12 May 2026
 21:30:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <af4QC2It_jgSgCGd@lucifer> <ebc08803-17ba-47e5-8297-c040240665ed@intel.com>
In-Reply-To: <ebc08803-17ba-47e5-8297-c040240665ed@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 12 May 2026 21:30:09 -0700
X-Gm-Features: AVHnY4Lk0ra_Zt5keDwtCQrnOg9NzT2UBtKwGuBFvhqnx2xhHr0TiXTburkVuiM
Message-ID: <CAJuCfpEHv=On8M5o82OMPQDTJEae+w-o68Lb5-kYLNnmbSrkSA@mail.gmail.com>
Subject: Re: [PATCH 0/6] mm: Make per-VMA locks available in all builds
To: Dave Hansen <dave.hansen@intel.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EBF38A0002
X-Stat-Signature: bjy6c615b4cn8feui5pykzs13uaqi6fm
X-Rspam-User: 
X-HE-Tag: 1778646621-672045
X-HE-Meta: U2FsdGVkX19EMl1S9qrNtcVyB1WCewmcPOCoNYTuU/WSksROXomVWqPx9Zga0CKdFIe1BHTRwlsMO0MVpueQuB4ALJHMQynd1+UjJYSWFV8vI1a74K2hcpX5L630cNV55r+FwTe+DLPjYnumLDC4PyNxH8qEGHzGA+5anC2Q64KHqvjRwUqVgHWNwazaBReHHJQaieP1M8S9ihDHDmeGfwDzm3nbvFwYrtuNiJvaC3dXdXc/qzJzyULs8FfhPz2dZO1+Rc6txFFIptRaG2XEmrX8t3Hf+7DyOhM3h9QBubvFFXWhlc9JosIYSe89YdztG/3T6NGvjmRTIb1/4MyhkdDZxd1Ne8h43n7sfDdHAP6jy2lPTPbKvngdbUMQMLKONlbLZCPKCIGEJuhjZyOdPH/7Xvm0XX7aPL923oQjzrndjQIk7WBKaGJ/k+FS3GcToUkXhE+m80xU2dsbc4PdhcyhxnM5rpGuuXmWs2yao5Gu5vlQyKnw9pxYeHg3O0D0zWTnrxhvjSoFFcuRMJAPpq64n+OYdU0mb9Bg2iAFMAVSt2c2oouFPu8zvEUQWHxLEKd+W8hFx9+vRRto7/G9hukJbCF6gj6JJwUApFVrsvqORCIESi9lYXoJhvC0JK+PcSpa9P0DQTpuAT7ZWSfb1z5ORR0TPumsYfffJDHrAFfNeHeV2ClfbSJOjmw2MyrtzEKz646nOL5tTs/tNNNR6BGfTigsh+gMzFAM6ca/Xo6NDASLG9m1C8MlBdDNZ3bRrUl2y4gCnDsFv5+aGfPrw6W3vVs1bx7ggO4U83ctLnSHeSKZWKOmobSGLLOdw4FIhIVVyvscwJv4owiqmNjiHU2e+MOg3DfG8IP/98qUuWQNLGXKwwkqp2c8XZCpwbeLo2IUGDeiMIfSWhZ/k59ZkrmzcPPO2BpTMfMogwjlfrLr2A1YhT3VtPJ61GZFx7f98CsbSGNFpD+dfckRr/4
 w+rABpXZ
 Aux0xQKvV36cocoO4uTaMbVuW/Sw00NIWaOWGL5Jt1FvRQZWh9oIeoRYhpGpjPMyS2QhKccIR/biSE1sw5nwKerFJC+5kPZeq+2AGiArmIQ01y06NYVkz282IU1I/8+ysGveTmxm+jJX8vbY7cf4PaNpdFERMjjZ455HtBtyQ06SDAbE6YmikBevSfYuQBzTOFHxmvqbz4h+MRTrQuSU6tsmTjCQ+YZl2AuGmOnyTywLzR0AlfewpizBWmnK6nxmFjjrI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 10:01=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 5/8/26 09:52, Lorenzo Stoakes wrote:
> ...
> >>  * Can the helper avoid the goto, maybe by taking the VMA refcount
> >>    while holding mmap_lock?
> >
> > Surely that'd defeat the purpose of VMA locks though? you'd hold the mm=
ap lock
> > for less time but you're still contending vs. _any_ VMA write locks whi=
lst
> > trying to get a VMA read lock?
> >
> > Unless it's on a slow path... hmm :)
>
> Yup. It's in a slow path. the example helper I had here does:
>
> retry:
>         vma =3D lock_vma_under_rcu(mm, address);
>         if (vma)
>                 return vma;
>         mmap_read_lock(mm);
>         vma =3D vma_lookup(mm, address);
>         mmap_read_unlock(mm);
>         goto retry;
>
> It avoids mmap_lock in the common, fast case. I was hoping to replace it
> with something like:
>
>         vma =3D lock_vma_under_rcu(mm, address);
>         if (vma)
>                 return vma;
>         mmap_read_lock(mm);
>         vma =3D vma_lookup(mm, address);
>         vma_start_read(vma->vm_mm, vma); // Is this safe?

It is safe if you use vma_start_read_locked() instead. That fallback
part is very similar to lock_next_vma_under_mmap_lock() but instead of
locking the next VMA you are locking the VMA at a given address.
uffd_lock_vma() is very close to the whole operation you described
here.

>         mmap_read_unlock(mm);
>         return vma;
>
> Which still uses mmap_lock, but avoids the goto. I'm pretty sure the
> first one doesn't have any locking problems. The second one, I need to
> think about a _lot_ more.
>
>

