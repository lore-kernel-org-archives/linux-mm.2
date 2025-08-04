Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77976C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 09:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D39E6B0095; Mon,  4 Aug 2025 05:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ABD16B0096; Mon,  4 Aug 2025 05:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8F16B0098; Mon,  4 Aug 2025 05:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 027226B0095
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:15:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82F71115E84
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:15:22 +0000 (UTC)
X-FDA: 83738516484.04.A445531
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id A788DC000D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:15:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ASfGq2r0;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754298920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFCaoHMm1VnEL10gVvLpdTFhZneV4lwru6bNk9ymWOs=;
	b=pODrG3ovJrabVZj7fCFFovWz2DbUUDeEz6cs4BMCO5rnhzrXNqg2A2GgJ+O1dHswnCXwgm
	YeoEpGD31HvAUJkfq6Y0hp7NvSllTl5OZzv5kKlT+aGUK36icS5mhRyH64wJiEk+EKUjnl
	rffK8WRxz7dNqKlN16vd4OhnSP2qs2s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ASfGq2r0;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754298920; a=rsa-sha256;
	cv=none;
	b=8gUmrvDsNzl1OUapv9S8+vEE1IAOitHBEH7jAfvHC0GfpdtVuIN5gp/aXW1jPdubI3UhQd
	NkZ9gFRs0mqpmjy6AYWV1+GPz9K/D6VKskq8kGTjXjXgXcJkAOgSOhskFcJYWDl1nxd5PV
	f9MxqcJgO2w49t2MPzq4B8Cc0wKopp4=
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5397c00ad9eso134183e0c.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 02:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754298920; x=1754903720; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qFCaoHMm1VnEL10gVvLpdTFhZneV4lwru6bNk9ymWOs=;
        b=ASfGq2r06JOig3Oc2lXQH1FWjRRmJjlR8+co/x4vfKbB3vzc7sxMWIJ+DBNUqauM/W
         wSUatZqYlei/qd2Z2A2Des/jh96GNGqOSy/Fv0qJFqnZcr/bKRoTIR7oGoLR/3uEdIea
         YHuRNHWF679zcMGBmav1UMl+ty9Z+uizLXC5X5AuKjJg2J0E2kllVcKTGCLQCWSRn27/
         qCnAOvkOGe7qMlJFONGDzmo4/lBJ8Hv11vmyvTcpkVb3NHQAqS9JQqlI19wQbS56Er8Q
         wxm69BR4TMjX2Q6iEtOPesngvXWk6MPT/kRFV9B6E3sEdHMObSD2Xa7xHeW5cCICYNDL
         mJIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754298920; x=1754903720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qFCaoHMm1VnEL10gVvLpdTFhZneV4lwru6bNk9ymWOs=;
        b=FQT7ZZ+2kfitAC5czrakJhSvUDnzRTE6TszxX+9koF+0Mry2ljaQemDkvhzfOy4PYT
         UEIy5TuN8sQaO6SH3OQU2fPi+Ki64egE3c1bvp88MHdjDnaDUO6T2CX9yLuBcsCYA0RA
         5JGWbvMOTRyhVa+aIgBsx8gZ+xD0/MUAeVVA66pHvH2RqaAhnFN2+gqbn9uETClWeoGQ
         c9pSrZhwa5VakidYx9ImwBf384NRJ2EMcRdV0mQCjMOXhpehVT4JCjvqEFPVczao5SOR
         hTNSERISZ0XuMoMSNTDovK2SaGiXB1dXbEOHsnEiHmX4CiXFUYEObxrF4323Zqp1Hsz7
         Ukdw==
X-Forwarded-Encrypted: i=1; AJvYcCWQAAcWXvQDnT0DFYLRhVf9Mivq9YxSlVE1V8OVjKdo5EAgNIWbjSISEslKc3mCWTn3H5K7zo+XNw==@kvack.org
X-Gm-Message-State: AOJu0YzIxEMvMGr9KSLVwb5IzVhLXuGsAy6QxI8/NOO3vDEo5dy7T7KB
	MGNtWYxpUrenzxatSsuLqVwx9yX7t6pQGLJUz3yIRwlboQ1EhdJKbF2578I1/OioEOUOP0olLuD
	WSLdqb9WA/K3dB1+G4YpiI8x6XNsfi70=
X-Gm-Gg: ASbGncvGre6Bwd1QWDm1pNlEs2rbfHxhf9SdeszIr2lt9lHaRzgyOsbQ5p3pfTS1Co/
	DFwLwuo1/xA8bEx/r2DrYOQzGYS1rd9xTH4iz8cCMLBgtGntgmiofNtR4g0nUIjrO2dMZO8/vwf
	R2OhO8X8psT5Ar4RYXI/oqk6XiW9n149mW3lPKS9kkwdSptPdnzhSl5isgQJAYTZurbIijqHUyS
	DpfYzQ=
X-Google-Smtp-Source: AGHT+IHydI6tDwWrpJjm9ELbGuWexGkYUn4GA18Pb/Ya3WOz9/wbanIAiL1QtWy60boNRaFhWPj5D1x1XXru/XojMOc=
X-Received: by 2002:a05:6102:2908:b0:4f1:7946:ed52 with SMTP id
 ada2fe7eead31-4fdc25487f8mr2740340137.12.1754298919609; Mon, 04 Aug 2025
 02:15:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250607220150.2980-1-21cnbao@gmail.com> <aJAFrYfyzGpbm+0m@ly-workstation>
 <1d1d97f9-2a67-4920-850e-accf4c82440e@redhat.com> <4fa8f492-c7ef-451c-8dc7-38b031c8a092@bytedance.com>
 <d9d0890e-2837-49dc-9ca8-1d6c28e95a21@redhat.com> <aJB0Kdc6cx1lGkdb@ly-workstation>
In-Reply-To: <aJB0Kdc6cx1lGkdb@ly-workstation>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 4 Aug 2025 21:15:07 +1200
X-Gm-Features: Ac12FXydsBD0TuZFpNyEUYcRbrcCg6kekPWWmL9gnPJlShdvwC4LshInjY3gdRQ
Message-ID: <CAGsJ_4yw4Qn7OWmUJeJZYuOHLjJ7L8kov3Th3vFPa3h4y0ur_A@mail.gmail.com>
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
To: "Lai, Yi" <yi1.lai@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Barry Song <v-songbaohua@oppo.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra <lokeshgidra@google.com>, 
	Tangquan Zheng <zhengtangquan@oppo.com>, yi1.lai@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4pg4kuy98yf567yg9oihmc48g8pfqfhe
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A788DC000D
X-Rspam-User: 
X-HE-Tag: 1754298920-217581
X-HE-Meta: U2FsdGVkX1+zaUvKpQzQo5eDj/Ro47MKO7fFmOfrsE6/KNKp5YvM+qvVfzF5Q9gnitj1Pqns4l/0/DHPeJ+QvKHax8+chSIpAw6bS3E0sNmFCD2sRS0fTN/YZaL3ZaOn8VYl406GfWIuAwFrz/scqzVxNRV8Iwx1GGqOAZ3Z2JN3FuxiuQi4GLfmOmnNHup9MwRcI4rfXBU2tekwxqZwcbEnY++VLlhonz5ynhbWa7Jj7BK7d8zZqg+kD8JVvYSVQbujAagURYz6aO6HOb5zXscSXZxLicH1X23ix85+gW0X05mpSZruvaOlN6z+CeWhIsNbPv/eR8iN6BW2fzk644I+e1VeCp5RnWLfpnlWgGczNmhwXF4/6jHUojhFbSTWdi7nc77hykAdfWmHZKzQNSkq0Uyz9NLCq0w4okvHeI34MwESUtjLixbFGMbUFDkBqpEnjnrHpGW0DkN9zuMbm/Ufslq9zrOIXDlSIXGx8iUiLSEv0BZsvHkFLxfWKasl/kEM7HyzFlLDHp+HIS/jzoqNfqzFso1kCJ7BmkYqZgPnGzRemVNCyV2pp0MidB4NCb+fxUosDsHFSNpSHSyfGFzgBLZof8iJutsydE/bM2NbHdM7wTGmznLFZZDzMleX5q2LNgTXAKVvMN5yEQ/ABvH5SrCCkWUcSKNz7zfj9Odm/lnV5jX1GXRc/ZGae/sy97+9CFHKyDo8FTxIS552d/xWLcMpVfGBePKhjLap9zb7oUE/CZqvpFtfqqdH/H2O4zpDk8rCQ+uUNEBmwuW8adVhB0WwY1tqBpYB7BJaYCFM3oKdEI9z2vNLTkaBeZlyKOV8Mz4PXuWGCaV0qbTv5qLPMvOU+zwzrCO9AaQPdnOTZefWz7vWVzHvWbpo+lJQDrIyq45BXvfqqbIa2mbIP+ZAN9rS3P5EW2dCyb2a11is+urokVzwOUoRb6TTSkNWktSXJia6PRwxMOm8jBS
 Jo7an3/P
 RxmaolXj70S/uS178gxKAo3vQA6KMFDtwBmUNZNVLTSsXnBKHEbKwmj+ks3vEAw6BjYDsjhbMdfNg5kiXtSsHq3JLpJyzcoaDthHFBQE9nsfsV2ssqXdeRrD7uGkcJnfQ432MRLFw/AsMxbLEb/Eoty3Hc1q1j107buXu53qvQqtwzXAXio9QFf6uDRra7HMAJL7l+9NlYV4tHq8tXVxbTd0aLW4/ISdzyhdLJRl0rBDxXLfhnOnE5GwLsVkCGwJaGIHQdv4iqr+ggwpae3wjpI0xe6mhBKvE/buzyqEh9mw1mfm+DmmYCHaWVHSmP0A6d3eyo3EUR+J5E2x4WrzYcbig1pxEZSGHkAN0fwpreoLAAAOZvDQKNpgfjmRs2nTidI+GjCTX6vUDn0TDoBZuf9w7VxxjJkSSlfsPY7dIXnZ2z90hUsJ/bMN/klFrBS4cQankwSd/7aE8LC9UFwsmjUH22us06uG0f/lariXD7pFhzPu+tlQojZZiSkmEcPA3yAEzvreYH22/jdPrX5Vo+NY9o5FOLV1E3iLn7TwCR9r6so0wpPwFqgseNqu5qjlJWL60hh7MEblndZLZPQ3y/vV/5KI2zxLgpNWZwpx2/a+CT8A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 4, 2025 at 8:49=E2=80=AFPM Lai, Yi <yi1.lai@linux.intel.com> wr=
ote:
>
> On Mon, Aug 04, 2025 at 10:30:45AM +0200, David Hildenbrand wrote:
> > On 04.08.25 10:26, Qi Zheng wrote:
> > >
> > >
> > > On 8/4/25 3:57 PM, David Hildenbrand wrote:
> > > > On 04.08.25 02:58, Lai, Yi wrote:
> > > > > Hi Barry Song,
> > > > >
> > > > > Greetings!
> > > > >
> > > > > I used Syzkaller and found that there is general protection fault=
 in
> > > > > __pte_offset_map_lock in linux-next next-20250801.
> > > > >
> > > > > After bisection and the first bad commit is:
> > > > > "
> > > > > a6fde7add78d mm: use per_vma lock for MADV_DONTNEED
> > > > > "
> > > > >
> > > > > All detailed into can be found at:
> > > > > https://github.com/laifryiee/syzkaller_logs/tree/
> > > > > main/250803_193026___pte_offset_map_lock
> > > > > Syzkaller repro code:
> > > > > https://github.com/laifryiee/syzkaller_logs/tree/
> > > > > main/250803_193026___pte_offset_map_lock/repro.c
> > > > > Syzkaller repro syscall steps:
> > > > > https://github.com/laifryiee/syzkaller_logs/tree/
> > > > > main/250803_193026___pte_offset_map_lock/repro.prog
> > > > > Syzkaller report:
> > > > > https://github.com/laifryiee/syzkaller_logs/tree/
> > > > > main/250803_193026___pte_offset_map_lock/repro.report
> > > > > Kconfig(make olddefconfig):
> > > > > https://github.com/laifryiee/syzkaller_logs/tree/
> > > > > main/250803_193026___pte_offset_map_lock/kconfig_origin
> > > > > Bisect info:
> > > > > https://github.com/laifryiee/syzkaller_logs/tree/
> > > > > main/250803_193026___pte_offset_map_lock/bisect_info.log
> > > > > bzImage:
> > > > > https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/
> > > > > main/250803_193026___pte_offset_map_lock/bzImage_next-20250801
> > > > > Issue dmesg:
> > > > > https://github.com/laifryiee/syzkaller_logs/blob/
> > > > > main/250803_193026___pte_offset_map_lock/next-20250801_dmesg.log
> > > >
> > > > Skimming over the reproducer, we seem to have racing MADV_DONTNEED =
and
> > > > MADV_COLLAPSE on the same anon area, but the problem only shows up =
once
> > > > we tear down that MM.
> > > >
> > > > If I would have to guess, I'd assume it's related to PT_RECLAIM
> > > > reclaiming empty page tables during MADV_DONTNEED -- but the kconfi=
g
> > > > does not indicate that CONFIG_PT_RECLAIM was set.
> > >
> > > On the x86_64, if PT_RECLAIM is not manually disabled, PT_RECLAIM sho=
uld
> > > be enabled
> >
> > That's what I thought: but I was not able to spot it in the provided co=
nfig
> > [1].
> >
> > Or is that config *before* "make olfconfig"? confusing. I would want to=
 see
> > the actually used config.
> >
> >
> >
> My kernel compiling steps:
> 1. copy kconfig_origin to kernel_source_folder/.config
> 2. make olddefconfig
> 3. make bzImage -jx
>
> I have also uploaded the actual .config during compiling.
> [2] https://github.com/laifryiee/syzkaller_logs/blob/main/250803_193026__=
_pte_offset_map_lock/.config
> CONFIG_ARCH_SUPPORTS_PT_RECLAIM=3Dy
> CONFIG_PT_RECLAIM=3Dy

Thanks! I can reproduce the issue within one second.
After disabling PT_RECLAIM in .config, the issue disappears.
The reason it doesn't occur on arm64 is that x86 is the only platform
that supports ARCH_SUPPORTS_PT_RECLAIM.

>
> > [1] https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026=
___pte_offset_map_lock/kconfig_origin
> >
> > --
> > Cheers,
> >
> > David / dhildenb
> >

Thanks
Barry

