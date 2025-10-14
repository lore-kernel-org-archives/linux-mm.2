Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF3C5CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2C068E00B0; Tue, 14 Oct 2025 04:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE5638E004B; Tue, 14 Oct 2025 04:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB8E8E00B0; Tue, 14 Oct 2025 04:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C5C558E004B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:34:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C5915A1F9
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:34:14 +0000 (UTC)
X-FDA: 83996057628.01.13B05AA
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9B43816000C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:34:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760430852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AKUCHW/MBIZsUc3ODKKtWIaDlEQsfe7hY3IvRmB8i8o=;
	b=T8FkV3c9S4eZ5r46VIZciMqfgQcDnCwB7/RU5s2EHn3BTzEyjFCkbFqXXlENd8eTSJ71Qt
	OCeza1drC2yLiMyahHPqjBgEz5WOs7MeWNG2GTObHo0HNhSTCx1QGqa5SzGjvSbLwwxAwt
	GhbPWX4gaat5TFRuU9aW+gXag6uusCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760430852; a=rsa-sha256;
	cv=none;
	b=l5Kt3MsWs/xBH+9vWJV+AWTTTBl+M7IiKXuuVDjlejhihIXPkSCxmSbw2FEfalPSngt3Dk
	vYsoXVRyoYDhA7FdPBEKgGSUhTKfQSYU6Ji3+yQwE1mmQwantijyk4req5+nI6wl550OAY
	8ukRV+5vlSBocSOpfhwmqpt3XLG1Kpg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-63bdc7d939fso251289a12.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760430851; x=1761035651;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AKUCHW/MBIZsUc3ODKKtWIaDlEQsfe7hY3IvRmB8i8o=;
        b=UOnsLUjuhQVZqpkgDvWFguIHLU4OVEnlQ9EQMWqEbSCXZFiw7RGhM7sDIVp6Un9+No
         hOtmaLEisimex6F1bkZn2OEH5c76ls8xXY2EyX7uGSKZeJh1jYfzShw23nm0f9FvZZul
         QF3q60Fra4+fz5FgpKVSO2LKZpjtfUNpnbRxW+OKS+AdNnU2r9u4v0jIlYVT3LikHRb9
         9Pv4HQs8bpzhAVaYGHuLY4Fz37UBh785N/DcvbyILzF5Wz/ULO9k3MHDjPPAsuzOZKrm
         SDJldU319neRnCKtkkvKGwifXxwwg/LzldU481i7Uy2OKuKZ0pp3e2yu3zMNTKtBTStU
         9Ifg==
X-Forwarded-Encrypted: i=1; AJvYcCXSdIfVXnF9LHDrPmsCkPds9cqJ2a+lk1i1OuK+nIAyRaBHozZC4TxobbigOX3svNoJfI9Y/HzxHw==@kvack.org
X-Gm-Message-State: AOJu0YySGr8a+Wd1iOEcYBU49M0a2Oy9vovmYnVQkHvObZCXFCBXYBW4
	4u5nlkMhNZ+Ii30UmojaaIZyDpQlK4KP5Wqk9BC/NhN/dLL/AWjlrxO5
X-Gm-Gg: ASbGnctz9eJydsCCKF1OeRL3ZGl4hj5r3OajyUqyKO8WyufN3NxxQaG6QKi18WXQgZ5
	ApWIg+3zD9nuChdunfQ2YbLoQZAr4ZfwuGgdNeH3fsL+9xpd+ovFfifjjGsbXjKba64/arSvCDn
	C0Ehrlk+gKdo5DjEEHfi1KwSxzTgd6diZqL++Dn+rqUXjlLykZDwvXPtVJxuQiacMVdsLqfuNZA
	ye8WFvm7OIEe1BMjsMzdQHz3UaXnLn9P3NjJdeUNR/LW8jFrbj1E6brKWmSDxIYW96RV7VUd2Ud
	FUoAIKDBqrPl+uDJnJkFH83xA39MInI24kaG/IcOHODhUfoEP0auo3wjKSoM3QtMvYmHHeZtMyB
	LyrUN7Dki4E6gnSWricxwmbXdvvpsq+g1yBKw
X-Google-Smtp-Source: AGHT+IH9yDBhkiPY34+r8L4QfGlETNuwKEKExxU3npIvUrJ6TVQTuSdRSJEPMfeufN3cm41sP9BTrQ==
X-Received: by 2002:a05:6402:50c6:b0:632:930c:ed60 with SMTP id 4fb4d7f45d1cf-639d5c57a9cmr20902180a12.30.1760430850785;
        Tue, 14 Oct 2025 01:34:10 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:70::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63a5c322e91sm10304155a12.45.2025.10.14.01.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 01:34:10 -0700 (PDT)
Date: Tue, 14 Oct 2025 01:34:07 -0700
From: Breno Leitao <leitao@debian.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Changyuan Lyu <changyuanl@google.com>, rppt@kernel.org, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, anthony.yznaga@oracle.com, 
	arnd@arndb.de, ashish.kalra@amd.com, benh@kernel.crashing.org, bp@alien8.de, 
	catalin.marinas@arm.com, corbet@lwn.net, dave.hansen@linux.intel.com, 
	devicetree@vger.kernel.org, dwmw2@infradead.org, ebiederm@xmission.com, graf@amazon.com, 
	hpa@zytor.com, jgowans@amazon.com, kexec@lists.infradead.org, krzk@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org, 
	mark.rutland@arm.com, mingo@redhat.com, pasha.tatashin@soleen.com, pbonzini@redhat.com, 
	peterz@infradead.org, robh@kernel.org, rostedt@goodmis.org, saravanak@google.com, 
	skinsburskii@linux.microsoft.com, tglx@linutronix.de, thomas.lendacky@amd.com, will@kernel.org, 
	x86@kernel.org
Subject: Re: [PATCH v8 01/17] memblock: add MEMBLOCK_RSRV_KERN flag
Message-ID: <2ege2jfbevtunhxsnutbzde7cqwgu5qbj4bbuw2umw7ke7ogcn@5wtskk4exzsi>
References: <20250509074635.3187114-1-changyuanl@google.com>
 <20250509074635.3187114-2-changyuanl@google.com>
 <ef6wfr72set5wa5el3wbbu4yd5tnc4p2rhtjpb5kpmncv3xs5d@i3c5v3ciioi3>
 <mafs0wm4yluej.fsf@kernel.org>
 <mafs0h5w2lpqu.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0h5w2lpqu.fsf@kernel.org>
X-Rspamd-Server: rspam05
X-Stat-Signature: cwg8wnzf9goyczw3bu89e5fzr58q8p7c
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B43816000C
X-HE-Tag: 1760430852-72101
X-HE-Meta: U2FsdGVkX19Iuj1bVU7mhgIM/iKYTNCEQezuDAMKFg6xngCX1iNFvM1i7q274LYNKQvt8/AVJluElN6yHT4Y8bFA0prlqcr1RJ9PYHU+EGz5DUS5V18fZHSnWLlt1JLp2WLpfZhhYFHldPXx3gveCoPPuzV2mK0qgp+330e0yU3Uv/0Kx9GGtglJ57OrrWQulShED0C4C0axML743zkR1YGcE2KccVeEsQ8Ln9j+sblDUAs5b/iBrcSdtgN4sx9yfJsa6Ag0KHDPZSPn3M1bSCNKmeOl0nuu3bzFCi7oA7j5P3ftKlDYd9b0q8imvV0yPauzByln6smCPOLCTHnShwHREkPuyCoYV5RnyPAwGZmYGW5nDGBLscgu9OL02mHsfEh8O189DzODvPieIT8Fp8mLDBUaCrVY4UhTiiaPcjz5s2yevgP+iKQd7f+S0a4/zZOGj6Z61ccJkoDqHPRWaA7n/qJxhgpwWxqAjUrFUWLH23BCzdJAXLeaiLclm4f3iYTxs9Vbk6onQbxHN6vS7R6mYbDexH9h673ZdpBrg9BKbxiIKe9j3jD3hu63imRDLaf+yqik/YB7K6vD7AotcR/vatlVtMbCwowqiZzYRNGFJzx2LcZMaECQW9ubF+2C/WScFEV/ltYM3B5JHYUxBcQFxlY4dkD9mZ63Ix8yoyEAPJr8limyjvwSgXajz4efXMIqbmETgkxJ9TH+V9dgf9L6DrRBkPFF7RyPeahFzBMMHUFHpAopjSeHUN9SLlz2VGdcMJfotHPsVeuIOA6URIMKKQThISL4T3AKJCZPECkA/iTV/qh9bjFKGTtY2+9YVwg3TJ07O9gfID4drDuJs4mS/12CgxoDOXugUeLSSt5mkXBl2kiL2ahdjfh1AawokoU1EPlXLQlyxFFrYP5k46rS/bQmTuTBb3l5Kvoua6WJL+zy/qM5qJHCZTqHyw9Tvr6WbjSQHgrnY15TCdb
 IaJVVnd+
 Z1pmNBd66sB1Agxnaiex2MyMQXUygQ5I4xRoqEJa1c1vqGmHdyuELH046hok8zlb98b3HDHkBfJ7QEJWq1G2CDb8r8qdxtO2ISFBun7cUb/zOJF4KtRGv/Wi2VwwGzHSjgDOtA3yk7pzj9uWcSOEkPfycPKniTjXZ+gbO4wbbd3V3+z306fwaKDuixviPUK09tE1bD/cHCF0wkWvy8o/I8xnl5zrWJMdXZKhIij6TIbhZ+0k6zKnHG3hNZXlyuLO2eLBf23KVtrphCyeC38ufvUBLPZLMMwpZVCFVPz0RmWyo0j9AswpfsxofAAXuCStlq8A/fzVvU4G4lfanThUm2cEN/aKcN9N0HlrCRoTVGBqOFad8jtw270eugQ9s5ya2//MeLsD+/QHLKQx7KGF6uB7Jizhiz7hvJ+Vr49MEa89O24WYgKvbwFRQKOTyGWf/cd+fg10L22zS7Qo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Pratyush,

On Mon, Oct 13, 2025 at 06:40:09PM +0200, Pratyush Yadav wrote:
> On Mon, Oct 13 2025, Pratyush Yadav wrote:
> >
> > I suppose this would be useful. I think enabling memblock debug prints
> > would also be helpful (using the "memblock=debug" commandline parameter)
> > if it doesn't impact your production environment too much.
> 
> Actually, I think "memblock=debug" is going to be the more useful thing
> since it would also show what function allocated the overlapping range
> and the flags it was allocated with.
> 
> On my qemu VM with KVM, this results in around 70 prints from memblock.
> So it adds a bit of extra prints but nothing that should be too
> disrupting I think. Plus, only at boot so the worst thing you get is
> slightly slower boot times.

Unfortunately this issue is happening on production systems, and I don't
have an easy way to reproduce it _yet_.

At the same time, "memblock=debug" has two problems:

 1) It slows the boot time as you suggested. Boot time at large
    environments is SUPER critical and time sensitive. It is a bit
    weird, but it is common for machines in production to kexec
    _thousands_ of times, and kexecing is considered downtime.

    This would be useful if I find some hosts getting this issue, and
    then I can easily enable the extra information to collect what
    I need, but, this didn't pan out because the hosts I got
    `memblock=debug` didn't collaborate.

 2) "memblock=debug" is verbose for all cases, which also not necessary
    the desired behaviour. I am more interested in only being verbose
    when there is a known problem.

That said, my suggestion is to only dump extra information when something goes
wrong, not affecting the boot time neither boot verbosity.

