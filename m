Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C97C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 21:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5370E6B00A0; Mon,  4 Aug 2025 17:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BFB56B00A1; Mon,  4 Aug 2025 17:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387BE6B00A2; Mon,  4 Aug 2025 17:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 224956B00A0
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 17:48:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C10E48197E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 21:48:46 +0000 (UTC)
X-FDA: 83740415052.25.4911917
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 00D19100006
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 21:48:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cohGgp+i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754344125; a=rsa-sha256;
	cv=none;
	b=mjpRl9KF5NUvhkJKENcmve+RDBAaWekuSHPiyJVjN7Pp8Hef4KWZkgD0xpsw5o0sfkxoBu
	xEeiHfKrz/Co+e4D8Eu0ISUq6Nx4AIg/ZyZY4yY9d77tR8FUmJgika9RNfTrpF2DEdbmYp
	C/iIG1ED2GLZxR6RNy1ttyOB/ecSi64=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cohGgp+i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754344125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkVWykS6hCsn+sBU+xav7wxsK66ozGOyeXXP9ZKMhQY=;
	b=KzqPxk0f1VH1fMjEZ2vwJQwwobi43DIqhkIWz7savhmcT6CaU4ykW/7PFFqLErY0nhJSRu
	9cMIrWPq8PSse9rSRmD1/N66pShF15RPP2dO7mYPiHRzhG5kX2n3WO8UySGV4857t+NqA1
	TMsBFcIwv9nPfEmprnxW1w3uOnHbpWc=
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-88bc87958d3so1990223241.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 14:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754344124; x=1754948924; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PkVWykS6hCsn+sBU+xav7wxsK66ozGOyeXXP9ZKMhQY=;
        b=cohGgp+idYg2Gkut3AiRZpdXsgz2e2p823KICFWmKJMSGEvByRBRLaQUqRG629wRme
         HVuNpnx2JzrFgb3O97zEIJBJYOIX1O8dZVpLeL4Gs8Gh3Ih2qpQKZRj+Y32VGGqI2Y2q
         ve4HZQeG25ZNBEP1ewWgDdI+WkcUEeiVhnsyikyqgsgsQCnKg0hocYqYZbqAvK05xM9a
         if0F4rcKUZkJJvy7V8Msdb1wEIx7vhTuq0He15NoLFCIJt2DrKpw/SSYpUCLnkKPWcoY
         DxGHdvqzJJ+bpG5BWtKVasg6TVLZRcIj/y2N+EW8szjNoPt3BgG4Z+7Irj3CsjT5hxSu
         Cw+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754344124; x=1754948924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PkVWykS6hCsn+sBU+xav7wxsK66ozGOyeXXP9ZKMhQY=;
        b=NPKv+xGm6cyGj30BWc8oCE4jkXPdDVYW/93hP2FURbvqukEqIji/DRnOC9n60cAz73
         dp3dR5d0zoGeobCK071fi9ma3mpBpDjWcr4K4XGaR0fWZQc63V+8we3+OFbNtnrOsGq5
         DOuIMIXm/1nDBCiFuDyJUc1y9kq0lGKMhU9fzkq7yfuV0C7cgMwMG+ZXYAkOYlyRBwyQ
         MVRmkvpEw1pHw2XGzyA+dcPr0aKCnoLSMu9WafXpu8oupar2sd0r7AejgyStTnhfgea3
         OeTZO3xUjn43qaczOhgsno/rQqFw8ykBaeDj3IIjJfaP75ZVapQUHKTAJzsAtquG4alg
         gnGA==
X-Forwarded-Encrypted: i=1; AJvYcCWBjRpzZOx72tIyw0zLZb/0vwYDS8rcAgjWOXxNMMpB+vM7dWIIDhBefx06WNuoa6T1y5gNgFXDuw==@kvack.org
X-Gm-Message-State: AOJu0YylK9ZffspYe/7E9SVWgK01+hyM+jq51tloGC9C/yZ9sZ0drvHu
	AtPZg5q3B7XvXQdem1mV4vujrbNOWtVqFFOZ986LYc5FGwfB9vCogsCSBhUz3UVPof3ifWMYTRI
	X8vdE51i3hlkIKnwmz6yKgUSNs0itsAk=
X-Gm-Gg: ASbGncuU+kKGH/BSCQ8e3qc7/AOhPF/iyUh0MXIW4mwKFJQCW7BhrSzftG2ygfo4Nh7
	oGZhf8fwhlrVawULLju3SzPvrRAfJ1M2kNShuUX/mImsuXH2MFVetd583KeDKJmaGzsgEueK58G
	VNATr1e6THVJp9WBb4wi37qGX41m3GP/4wrbbjtp0AdOmXK9em6zkqyNxyVK3Ts1MRHt9qAcvM4
	6HgJCY=
X-Google-Smtp-Source: AGHT+IHpRjfMrlG9ZlCq5AhjD8/HSKNvGraWFA12xbDdMtQQsEay8IeUKx9EaEgk778U6wfDNaXD5a6q9Pbd7E8y2SY=
X-Received: by 2002:a05:6102:26d3:b0:4fc:156e:1046 with SMTP id
 ada2fe7eead31-4fdc4212c13mr4980106137.20.1754344123908; Mon, 04 Aug 2025
 14:48:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250607220150.2980-1-21cnbao@gmail.com> <aJAFrYfyzGpbm+0m@ly-workstation>
 <1d1d97f9-2a67-4920-850e-accf4c82440e@redhat.com>
In-Reply-To: <1d1d97f9-2a67-4920-850e-accf4c82440e@redhat.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 5 Aug 2025 09:48:32 +1200
X-Gm-Features: Ac12FXwWuOB4aHDWxv82Z-ff62MNcG24p5-GDgdLvCO-VcGPJBIhpHkcI52g-pg
Message-ID: <CAGsJ_4ypaAySaWyatH4Vu_dz--gEXUWk3yAQwM_8JTdR6U3fQA@mail.gmail.com>
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
To: David Hildenbrand <david@redhat.com>, "Lai, Yi" <yi1.lai@linux.intel.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra <lokeshgidra@google.com>, 
	Tangquan Zheng <zhengtangquan@oppo.com>, Qi Zheng <zhengqi.arch@bytedance.com>, yi1.lai@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 00D19100006
X-Stat-Signature: iny7txmdmqiag6nx9rs5zjyjwrc4kum7
X-Rspam-User: 
X-HE-Tag: 1754344124-785238
X-HE-Meta: U2FsdGVkX1+gxpp5yKP2JW4i2WiNvAoapXM7lo5cIf6kpJvfTHf7o4ZWU/5zSSJJjN0kSxeNrS7yaZCH4Nit1kjTHE6d5vdfU/uPZuabuSnHjj8oGDfQ6C750pRYBHFd145Fj5Z7gF1CzUwy/259VFFW65QtI4gZLfM4+Lei7iw/GkvCG5+sHxmcL3og6tyrqtXu4YSEKGcE2gN43Q0M170tzNY5mFoBTXFtOIi7IG1zNNSYiYNxpuy7ZymfG9L6t2GIJLUHpPSEMKXW/eKy0fcrap4KhoFqpl2qYFV6XuKgZKutxf1nVo5+8RMNo1nmOYuPwTS5LU7SjIEPk75Vcnz2+ovpYrPx+7eAUwYLfRw6TgvIy9UVBAiEWO2P6EPGPu8LfNcaenFCXbm5WZ2rrcLhR4Oe67f3gyRnfZQJW7Btnv9G6zzq5FGtxJZUbW7Hcfo5AIB078//P3SGc04L+VgmEoQla2oCbjnCrcL5bcvp7Jnut7CUpP82dUtehC9MfBiyUqOrIawutcI1ngTFCvmU9NbIgM3Iyas+nh+H8BUGJiZoBQLtO0z8X6gNyAwfw6PizkM9cvrAFa9IScMUq9qdC5faP7dxQhdUMlxb+0AUiU387Mfk3sRK8H/XjK+gptQ4WR788R4SIK7ThPoeVY1sgLDs/bi0FG1Ds+fuF5bxHJZAXpzUeIIrxs4Cqq05h7FypwWh/krijEFQTATF1RPyLnq9p5sXEMwMEEIGuJUabXn6UxQ6C3h0S43YdqSqBPo830RqyCssVeKeMptYVBE01R2tG1iArhf1ErOqUICOaOjJuVKb5fSjWh3696448jCpxA9zetty8z+JAJd55H48UUOPBz3X2NP6PhQRymRyIZp6J+o3Ieb8/MSqWM+Iw5QrjPIE0rA5rTCTpsix3RwRxI65CHyVWOPJKs1A8K1OzWSXsjX8F436b/QgRVRJ7lJQyJJ2JEMBjsDCDgf
 uWNGEr+a
 bOI5ntKdg9pzsXqdT/GhgusN1myonfRJE6BgWEqBTl1vlhycXbQD4xo02D0PtybNd4hRp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 4, 2025 at 7:57=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 04.08.25 02:58, Lai, Yi wrote:
> > Hi Barry Song,
> >
> > Greetings!
> >
> > I used Syzkaller and found that there is general protection fault in __=
pte_offset_map_lock in linux-next next-20250801.
> >
> > After bisection and the first bad commit is:
> > "
> > a6fde7add78d mm: use per_vma lock for MADV_DONTNEED
> > "
> >
> > All detailed into can be found at:
> > https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___p=
te_offset_map_lock
> > Syzkaller repro code:
> > https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___p=
te_offset_map_lock/repro.c
> > Syzkaller repro syscall steps:
[...]
>
> Skimming over the reproducer, we seem to have racing MADV_DONTNEED and
> MADV_COLLAPSE on the same anon area, but the problem only shows up once
> we tear down that MM.
>

This seems to be where the race happens.
Hi Lai, can you also double check if the below diff fixes the problem?

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 374a6a5193a7..6b40bdfd224c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1172,11 +1172,11 @@ static int collapse_huge_page(struct mm_struct
*mm, unsigned long address,
        if (result !=3D SCAN_SUCCEED)
                goto out_up_write;
        /* check if the pmd is still valid */
+       vma_start_write(vma);
        result =3D check_pmd_still_valid(mm, address, pmd);
        if (result !=3D SCAN_SUCCEED)
                goto out_up_write;

-       vma_start_write(vma);
        anon_vma_lock_write(vma->anon_vma);

        mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,

> If I would have to guess, I'd assume it's related to PT_RECLAIM
> reclaiming empty page tables during MADV_DONTNEED -- but the kconfig
> does not indicate that CONFIG_PT_RECLAIM was set.
>
> --
> Cheers,
>
> David / dhildenb
>

Thanks
Barry

