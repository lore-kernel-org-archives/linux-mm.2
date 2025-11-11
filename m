Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 710DECCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59B18E0016; Tue, 11 Nov 2025 04:01:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B314C8E0002; Tue, 11 Nov 2025 04:01:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47238E0016; Tue, 11 Nov 2025 04:01:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 966EF8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:01:40 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41E144C0A0
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:01:40 +0000 (UTC)
X-FDA: 84097733160.11.2428D03
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 61AE4100012
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:01:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ekxp3x5O;
	spf=pass (imf14.hostedemail.com: domain of glider@google.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762851698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3GiAAjmzQ/VspCqloDpIt+ugCtvSToogOEL/VpV0Ws=;
	b=gnx7Os/lH1ksEjRIh6UV6y6chHPuCl+BrSi/itLpSYJj4KCQi25uVfN+sehlJQ9YK5q2JD
	/ZG0cd2N9Xx4emFGDa4OFyFYbGTBxz2NDcTjNRonVYdCPIPJpBHmtZs/x26kleI7ZuY9zM
	vASD0ux2fKO7nWdNNCBGczj6yIEfUKY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ekxp3x5O;
	spf=pass (imf14.hostedemail.com: domain of glider@google.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762851698; a=rsa-sha256;
	cv=none;
	b=zHqTV/rhD1hGYhWF5/Qvj34J4gSG6LdjaiqfgNsYErdIJzw3A5d/9HsXU1rvF74oHfjHP5
	BU98go/MmcFzAFnehTd9XsMDFni1Kx3JwmO3UfwZbEr6NYQUa7NzdNxaJZ8DOZmcbK6bO6
	CwWQi5VCuzPugVtpe8/pdVtJF/MmFno=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8b272a4ca78so308360985a.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762851697; x=1763456497; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s3GiAAjmzQ/VspCqloDpIt+ugCtvSToogOEL/VpV0Ws=;
        b=ekxp3x5OzTA8aOoPtYGtXXRucGZuAN0JzaZttM9u6aCLheoGR7xRck+iKP8VsD6fCE
         GC/UAtzUfO9EyraMuLOJWezwvNQQfKZraHq997p7IBokwhtAH6X7T6VVFAUESweZZ3HW
         iD4RbX+HrgW9el/xIGd7upX5Q7IEvake3tNUDZcplyWH271ns8zVy84J7ncmYF6lcwng
         HgiF+/3YzJ1yOfjVe4Evv7wzexe1vSoyT88m7ExwSNpsHD+EwbBUtJeC+h60xPMseAN5
         VaDEpNS+vZdOB/Quu/dt0OQgbJVuh3eNrWe4e5sS31DnGAHopKfPeXSzKSmWUA30jHHd
         F4Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762851697; x=1763456497;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s3GiAAjmzQ/VspCqloDpIt+ugCtvSToogOEL/VpV0Ws=;
        b=ixERqRSCo77+Jb3DmDBaZNIeui196/UevcR0kK/G6Nw5TXML8I6BSA9AaSj/qfReWV
         XQrc9AfZvBBX9iRLawwnvG8Q0cHA/ufe2rmnkwyVgT7V3Xiqgd4VQeDPpTm4GVg5PmfS
         IYE2YetVbtn+J7izNWSFIXIR5J/Zl0uPmvxWeTucrShr6Rc9myH8v4f1Zm1ificjcho5
         Ly1dVr+elLrlHlTOOgyBqU5XC1UfPaU5EbwIbuMjSU+RuvzT0WB0bxQgstxOfUaB+f25
         bWcBmve6qTzdiwSK6A2m2B+VNWuG3r++AxtCiTQTiNR/APB8HqP4lp1jNcc9WhwWu0tx
         cHMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhBGXdINoVhEzCfpUNVU/a+nNeAbS/z8O1Gko3DHW6ZYvZe5gztnTaZLSzGsnjyx906n2n8/q9IQ==@kvack.org
X-Gm-Message-State: AOJu0YwOa0jR04aHN6sP510X95J3KlYEv/jTLThylFKmE53XT3WT3h+G
	kKKcPKOf2821cmDnBq/9IIuxMqVPoQ9JrlpWYuqKf2TMiBEA8UIBZCWgFy8ZUS7/apokTTrQy8P
	LPlZ2gywvk1mKjfQjsmBErjP93GiQzzejvZUMlx5z
X-Gm-Gg: ASbGnct6pxjJ4ntYlVM1pWSWIHc9fHwvMkdVavdV7wb5uExeYcVda+hqN59lGaxnt+o
	DB5fI/6a/VGYz8mg377wmUHvy5yrauvnaQ+g4y8Fa8NudvhhyZtnsLPsf6aGy0rctJe+UdifJ5v
	o9P55P8oprPcXhGEZ0yosIvw7sogf3qyYP8O+ZUENIQWZQNbhATgi3Gi4qKnE2QOxjO/51W6iUH
	XWaVAOrZEcnJiZ1QC0/EBKrepikROgBi4hDVbI03A/vkp6UZjYuitG1A5zclsjX6PmmPzjZ/spP
	3dmnn+6Fe2swWesbdcE8eV+BLfBSWMtLonKB
X-Google-Smtp-Source: AGHT+IHmbNWz4nrBYzIA6dULAnEplmbnkhIWWkrftwGIkZuDmlgOtFs93CqEkgKXIfWxtOJB7Fa7kj8HnLkgxuZShy0=
X-Received: by 2002:ad4:5f07:0:b0:880:42a7:7730 with SMTP id
 6a1803df08f44-88238731aaamr156015206d6.53.1762851696507; Tue, 11 Nov 2025
 01:01:36 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <d98f04754c3f37f153493c13966c1e02852f551d.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <d98f04754c3f37f153493c13966c1e02852f551d.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 11 Nov 2025 10:00:59 +0100
X-Gm-Features: AWmQ_bku8cq-CFmbh2Cbwbizm47o3PsCv7pQitKRdKmveqfrADnJlpnymR3GFhA
Message-ID: <CAG_fn=WPQZ4ti3Lb+A3jSXFWLtn6291sTKJBwKBiLD2E9YbuKA@mail.gmail.com>
Subject: Re: [PATCH v6 18/18] x86/kasan: Make software tag-based kasan available
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 61AE4100012
X-Stat-Signature: xnjne8qrntbc4rpgdzjncf4gjhbeaju9
X-Rspam-User: 
X-HE-Tag: 1762851698-357124
X-HE-Meta: U2FsdGVkX19X84zW4B4lSGCUCt2kpWRx3smOC7M4hs0QTTWrNKpSgaEAk18F41y/X1YOECp+sqFreLNGoA0bH7e+UNGDjccJ9Shj6uWsVXNVsGUopbelN/AMjmsReYErZ5Q5dw6lhmUaxGsIi0PHPuQjPPZycNRuiwqmhmPQsC/NutTwRhH5dcRX6uDpE/qOry0yq79h9I6Wxps5oOUUTzndnYAMfC7YwzSZ9wkEdYymP3jI4m6GF2NVhY24xXjtXbTZom+Ce/hPKgr4oI1RyP7NCQwzFNMHjOp+HlIsGWOCiM7sDTKPHJ5TRPUChF3qputzuO7bodXESec4fJJckEG4TJz3n+BdClAfJl8hqxZl/L+1/eXiqLkdPoCaxL6PLmMR0M1N7WBg6IAlgK7f4oQ9m7vfv+DAxafS95AZ1swHAkR8xHhsREeQrtUg4q3m7hTh+m4+lAoD0VokbPyu44Qi1x4UPMYAwg/mG8qD96o0BNCVXhfn/momtitXGGeyflYYpbuzF9wBLmraIwF1O8RPa54pDOKG6w/uGN9uwSG44fKzttWTgBDV5l7hhP/2N6XiPOdejLO+LJcOOgQDsZxGiqypvrTgx5WmSBGpXXDEHLx+sImnxia2nUr6sbZypo4xX7D3/zmG97N4LLeR+0y36jJiVmOPgQPx2uIGkexZqi1HkbXXsgFS0JVKWekmDQN79oM2lII44dkg+6Htt6ZBM6j/nN+KdH7HgHKdCJkCYH3IzATpno7FTv0su0LXTXotm1iNFxWSv5uRWTWc9TTtifo8SNfKWKNfl0MM9ahG9T7Fl+uR5ukhonBmMDhCQnd438SrYTraNAm0LBYebBLDLbYoGU5C+cd1m4LQHGOOl3iZ/ilbwhHb3q9XZWBm+S80bjULRfAV88BC9HavpXXMDBpUaNwRGYJe37GVQiwmQxNGGZ667+qm30u6EF49iTOPS0vCTYA1YWDFRdD
 9BCK439V
 Ch/u8gGJFHHoFju9lHC6i2gXbMuyv687MC6msSkOHTt677NkgOwiefxuspmH9I0Rjf+jdHYd3LmQGKOW9Hl/zOwa0eOmYabtv7gTIuyxVTAoMyV3kjSYiczcqL8L5yQ6K7zlJbVaCi9jaazrMYspdha0ErGLNCasQAPLj+DjsICeHLXMcGfI/6n+lDYeJdjMOdnBfcF0vvKyfu0Xu2Q0zaZHOWZTskzIaYNUmYi7LFNGICVK1+zSkY/SXINnbSK/7VUUIYaq0n0JaSfY6XEZf1zSRL7a7FE33V95Trv9Zwn4ymVo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 9:11=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>

> -   ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN sh=
adow memory
> +   ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN sh=
adow memory (generic mode)
> +   fffff40000000000 |   -8    TB | fffffbffffffffff |    8 TB | KASAN sh=
adow memory (software tag-based mode)
>    __________________|____________|__________________|_________|_________=
___________________________________________________


> +   ffdf000000000000 |   -8.25 PB | fffffbffffffffff |   ~8 PB | KASAN sh=
adow memory (generic mode)
> +   ffeffc0000000000 |   -6    PB | fffffbffffffffff |    4 PB | KASAN sh=
adow memory (software tag-based mode)
>    __________________|____________|__________________|_________|_________=
___________________________________________________

> +       default 0xeffffc0000000000 if KASAN_SW_TAGS
>         default 0xdffffc0000000000

Please elaborate in the patch description how these values were picked.

