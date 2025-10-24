Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B457DCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 21:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37A18E0116; Fri, 24 Oct 2025 17:42:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0F898E0112; Fri, 24 Oct 2025 17:42:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4CBF8E0116; Fri, 24 Oct 2025 17:42:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9513D8E0112
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:42:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42D94C0FB9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 21:42:24 +0000 (UTC)
X-FDA: 84034331808.03.A016AA5
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 496F3140010
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 21:42:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BW6OgXOM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of jannh@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761342142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itCXHl8ctepPB+HiWwLJlZEZIs1mP5PEgmq+YmuTNg8=;
	b=U1I6syAWLFrpRNWoCCqXxZVEgtHRMtVqCccgslc8wyy/RWr4r4btiwhJpXf9jVD3b5jNEf
	aaBoKVImh9G2BUBhxtm5+Te9e/9cc1mtaBpqcVJNUS/22eZox6X2ym3FELBp8fN+i8nTQd
	RIvOuH4SdEeJ6fqD7SPKwS2nmgJZg/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761342142; a=rsa-sha256;
	cv=none;
	b=009jjYXC4gI4Vit2HBxAenSrWb720t4jtv49NmWDGLYOww2gFp36SJeN5lLKOgMWN/ZIKp
	ieNzfMYubOF5CUXd2F+SgjPoyEyKzlM2eCvYiBZkS6MhnIG/JDPYtMIT52gUxEqBxwicCK
	kHDfwLB0fY+LriaNfSn/lv2gxYA7JOM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BW6OgXOM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of jannh@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=jannh@google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-63c2b48c201so1351a12.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761342140; x=1761946940; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=itCXHl8ctepPB+HiWwLJlZEZIs1mP5PEgmq+YmuTNg8=;
        b=BW6OgXOM8JD1bz7g6yN8XeVl8y+bXebGo0lmP8IYaaiHe2TvyEN2z4pTJ7dpNcwiUJ
         t588yixT0xIinKR6snKx2lgALuvOgrZLbxOnpZFtz27Z8tNpAkJNgemT1mHDNt5utze5
         yOF9Dv1BH3Y8k9KPGu0ahB4JDVi/pa1RubVfsdauP/R7s6WwKoWh7GG/+Kia0DIUwc4j
         +384CY2D5W9npgROkper9oAGOX4qDiNu3wpX+Q36k9sAu5v/b5OgrAYhuyU1FuzmZmbr
         UojYamDl/9hGwNKXveilZRZ0Cwu/wzMXN39ywit2+mr1IQAS+QsXAzFxixDXO7q8zjSP
         Lcyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761342140; x=1761946940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=itCXHl8ctepPB+HiWwLJlZEZIs1mP5PEgmq+YmuTNg8=;
        b=lZHvqeRid/Gmm3HawzlGHhAZRxnzLJdaVw+m7Grf24gWei77DuOxo1UdohF93VBBcv
         1YgHzFq0v9ryvNdOPDysgxjrHoH+2BlDDAQSUEpkV2iiargJiodeLq+QwQreQHILOWkN
         eg9ScfMVEnajnjFImvCQ43t0f43g77HjH5pqkDDM+htxQwf2pYvEa28C29/nQ60yIqx3
         3zo2RWtrS00WZCewq1enYQPUvbdM+Rvui52uHZDyyTL02fBGzEtSplIGZ81/c9qQY0BY
         FIaaGEbW18bM1ckf2v70kLs1UukrGw/CweXlzIQPNdVzg+/sxSfE66R+Cja5T7+e9Mat
         UzsA==
X-Forwarded-Encrypted: i=1; AJvYcCXbgcvRlThs7VOSQJZEmDM/arFic1OO2TYxIZkKFeP6jLxl7ORg4xUpMUXGqsp+utlYP+qB411dtg==@kvack.org
X-Gm-Message-State: AOJu0YxOdmilk0w4SJRrdhRfH0Vp+rZ3QxmU9aDTsdpqV6JRh5srjjS5
	N98HimwyZIb8fGNFbArxUirGkYR4Vs25iejZm0O7GjCdOvMoUhs21/RZNSJ7fHVW66Fy/D++lUV
	aTuWyotHWRBRr03ffUOewlgKsshInT4DTFRYa6RMn
X-Gm-Gg: ASbGncvAiwEUF4gkvwNVjqXMEoEKLTtUzvslS+v+8+ZUumgJP+w5/QezqkP5uqknb5n
	/R4QG0H0hRPpch5N01Nnn6ewQDgg5PWbCGJk7IPWKtmPKZNQ4tmhp81QuNxecsSgs5nwclHPhLL
	KK/lM23PoF+AHD2rS8cyd9+4nNZdm/s3myrhdAl43QwiYyeF8Wg+Ducy5Dz4SpuojoMGrXH7Xdh
	KZgfz42uQWpSeH74y5Z2wc4v/VsZxjLw3dlLOd3AvvJqaMnHqWoMwIG+QJyOAqezWTKXOP94AuP
	JTDocQArbSvDAszTZWRWebXS
X-Google-Smtp-Source: AGHT+IHEuDP7kJ05dEUklq0wZaHOnZX/AiJqjI2fMghi+Fp4GpS8e4Y9NafWThm7bIW+IZ3n3rPeb0fMkN98q6HdgEk=
X-Received: by 2002:a50:d6d4:0:b0:63e:447d:6aee with SMTP id
 4fb4d7f45d1cf-63e7bd47b8bmr31664a12.0.1761342140312; Fri, 24 Oct 2025
 14:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de> <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com> <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <81d096fb-f2c2-4b26-ab1b-486001ee2cac@lucifer.local> <CAG48ez3paQTctuAO1bXWarzvRK33kyLjHbQ6zsQLTWya8Y1=dQ@mail.gmail.com>
 <a317657d-5c4a-4291-9b53-4435012bd590@lucifer.local> <CAG48ez0ubDysSygbKjUvjR2JU6_UmFJzzXtQfk0=zQeGMPwDEA@mail.gmail.com>
 <4ebbd082-86e3-4b86-bb01-6325f300fc9c@lucifer.local> <CAG48ez1JEerijaUxDRad6RkVm3TLm8bSuWGxQYs+fc_rsJDpAQ@mail.gmail.com>
 <6e939a0f-3011-4a69-a725-6fb09880a51f@lucifer.local>
In-Reply-To: <6e939a0f-3011-4a69-a725-6fb09880a51f@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Fri, 24 Oct 2025 23:41:43 +0200
X-Gm-Features: AWmQ_bk9DtfKbZlK3w2vk9xKo4DqXkFq3shnFSr-R9L5r3HK7JG_GFbXKw4dH9c
Message-ID: <CAG48ez2kinjCP2y6q9sOqNyVAiAC_UDS+w4NCdtKvidLQ6+zdQ@mail.gmail.com>
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, "Uschakow, Stanislav" <suschako@amazon.de>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com" <trix@redhat.com>, 
	"nathan@kernel.org" <nathan@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"muchun.song@linux.dev" <muchun.song@linux.dev>, "liam.howlett@oracle.com" <liam.howlett@oracle.com>, 
	"osalvador@suse.de" <osalvador@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 496F3140010
X-Rspamd-Server: rspam02
X-Stat-Signature: t9mfj643kfah3pnj3gh76hnefrt53mqg
X-HE-Tag: 1761342142-668651
X-HE-Meta: U2FsdGVkX1/J0QuJtvz9m+i5b0+u+AeX4F/JxFXX6jJ/s5iDXUj0rLv6f2W1s8gf9ckHwptQLpiIeX+HwangdtkFXdNPPKMGcmAKu/GWsCzbnNHn67Gb9+T8R0+pcvKWwOWkEgdsgBc/4gV74sWI8cihQ4XXLGc1prx5z/oE4rr25A8PHaPr/cqdPEL7Mwy/qnspL/AAw1SSvPcZ+ysC9ab4+s8qqbMFioFdFBRU9A+32VfUwDAxD1UOIU19B5hIsyXj0sZQtXcK3iNUneL6Br1mhLlEsE/8lYXYZ3nI+1wNXykc+B/Q78ce0RXQvWTqxcWb7Ea4+ksS6xyrpRGZF/J6GPYQSeZTuuTxPdyhsOyqUkHqOExvgWxNV7Lq4nBIM4H4CovA3cv0yPyS4KdM3aN/MeSmXVmNsx/SjWNLcDVm7+d/TG/931T+Dael1yrbhAcyJpIp0JuL+rywl4EqK50QLT8PQ7wDMf8qvgtX9w+xbyQlqzWb9tqgc3lx++AWx/OJlyi2fdxihmVYIU+IjwTW8KOHmG/SSFbEr5wfiTa57SJuoBsfMunkskHI4KGg2W5D2XBEoQS6cxYEXGlhBFQ6N6a5Pitr9pPNj3ZzL0xulgH0KgfyaimNQJSGeBHlGrdvI9OcgJXmRU6tqQVPUc9MdzS3YGNQcBFFax2DLpj04hvPhfDamA4lbgRn2kD2OXojLYXolnk77kP1gpyBQfn2YfFYTb7VYqhXDUKng0cfApKUfflesESAixiPjqpVWtB5iP+EM3JjUNdjr1tORopIL3aeG0sLWqdmC9v73CNNOzxsaz6voGpuqvS7u7WP7miyMowBnTlOaXM4FPLTaHPtgJAseq1cGsOM6Dv8KAq++O+nMXbh3JeC3oJ9+XAI6rOWdkxXdmVbr5EwxGJoA8i34oFi4rCQeFWWfm6emwukvXDv5RAiX9cMu34guszQRpW+cRUxS2XjzjtElsk
 5PcO69/c
 oOAyGSapZk3qPHqBbenzsP7DAeVCuiEhFSr1D/j9D67ZhVZSTV0Z7KmISMjzcF31/M1P2vAyDyNoJMDSUi5+PwX8pPy6wlVVg5x/eatptQStVJkoTj0CZnTphsU6BPt34WChD3Pd01EdSU3x+TzZjpqxrrJkCxkwOju7IxVJlsjz2wFrt+HDDG/wQRWy7HgpGSSBRE5fHphzTdy5oX419HRnRbh1rPX99J4Gz2qJ/GCuLcwI7aSDH4Ozxc0ZaKgA4iHlbt5Z9snhWRx2zzbeH+UmXTOCGol5cigR/FDZqqTXOVf0GimheZ3dZZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 9:59=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Fri, Oct 24, 2025 at 09:43:43PM +0200, Jann Horn wrote:
> > > So my question is - would it be reasonable to consider this at the ve=
ry
> > > least a vanishingly small, 'paranoid' fixup? I think it's telling you
> > > couldn't come up with a repro, and you are usually very good at that =
:)
> >
> > I mean, how hard this is to hit probably partly depends on what
> > choices hypervisors make about vCPU scheduling. And it would probably
> > also be easier to hit for an attacker with CAP_PERFMON, though that's
> > true of many bugs.
> >
> > But yeah, it's not the kind of bug I would choose to target if I
> > wanted to write an exploit and had a larger selection of bugs to
> > choose from.
> >
> > > Another question, perhaps silly one, is - what is the attack scenario=
 here?
> > > I'm not so familiar with hugetlb page table sharing, but is it in any=
 way
> > > feasible that you'd access another process's mappings? If not, the at=
tack
> > > scenario is that you end up accidentally accessing some other part of=
 the
> > > process's memory (which doesn't seem so bad right?).
> >
> > I think the impact would be P2 being able to read/write unrelated data
> > in P1. Though with the way things are currently implemented, I think
> > that requires P1 to do this weird unmap of half of a hugetlb mapping.
> >
> > We're also playing with fire because if P2 is walking page tables of
> > P1 while P1 is concurrently freeing page tables, normal TLB flush IPIs
> > issued by P1 wouldn't be sent to P2. I think that's not exploitable in
> > the current implementation because CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > unconditionally either frees page tables through RCU or does IPI
> > broadcasts sent to the whole system, but it is scary because
> > sensible-looking optimizations could turn this into a user-to-kernel
> > privilege escalation bug. For example, if we decided that in cases
> > where we already did an IPI-based TLB flush, or in cases where we are
> > single-threaded, we don't need to free page tables with Semi-RCU delay
> > to synchronize against gup_fast().
>
> Would it therefore be reasonable to say that this is more of a preventati=
ve
> measure against future kernel changes (which otherwise seem reasonable)
> which might lead to exploitable bugs rather than being a practiclaly
> exploitable bug in itself?

I would say it is a security fix for theoretical userspace that either
intentionally partially unmaps hugetlb mappings (which would probably
be weird), or maps and partially unmaps attacker-supplied file
descriptors (without necessarily expecting them to be hugetlb). (I
know of userspace that mmap()s file descriptors coming from untrusted
code, though I don't know examples that would then partially unmap
them.) Admittedly there is some perfectionism involved here on my
part. In particular, it irks me to make qualitative distinctions
between bugs based on how hard to hit the timing requirements for them
are.

But yes, a large part of my motivation for writing this patch was to
prevent reasonable future changes to the rest of MM from making this a
worse bug.

