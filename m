Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BADC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510E86B009D; Thu,  7 Aug 2025 08:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1746B00A0; Thu,  7 Aug 2025 08:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B09F6B00A3; Thu,  7 Aug 2025 08:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2ADF56B009D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:16:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2A995CBD6
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:16:30 +0000 (UTC)
X-FDA: 83749859340.06.E110DD6
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id EAD0B40012
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:16:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EV19x45X;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754568989; a=rsa-sha256;
	cv=none;
	b=nLkmn3V3tqmjz36/ia+mQ1QYCljCydb73ZSL58qa5qf43/G4XZU3WNrClqakOKdx6H4MMB
	lL7prqM/9HBBfpg8Tr2tMQIRZ8aQi22SNYbmujr4OjfoEsxO6H1RPBrKWfwBrMHhHK7FSZ
	s/MF9IqCXk0HPW6g74lYXqEhc1G7ntI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EV19x45X;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754568989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHVxavGBrjI2mC/mT+iovNRLtR2msFcHcq0N4dnm4w4=;
	b=Pt8aA9JtBTNY3dY6ZEFe3z4o7qJ65wVrDoCArPa433NhzkF13sZWPbHuLieFEMXwL4CAQn
	5bcZgzziyvKRjGOmTuGYUfan+Ia7AiaNo+8L/sRufRDoCbc1iZAc8ln+7i1HhJYsup3lkp
	BThbeUgaS6uwcq8LvnWVWjq7dWJ9Gv4=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-458b2d9dba5so5994705e9.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 05:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754568987; x=1755173787; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GHVxavGBrjI2mC/mT+iovNRLtR2msFcHcq0N4dnm4w4=;
        b=EV19x45Xxi3K0Ths0Jl/H7x/SexlygkBobhUOG8tS5M9+/JdntT7mfe4mSbsGymMvD
         7aMJBA8nda8S8hrsk9Vyr6BGgFjAbKEsxWK+jSBwj2hzfNWBaXy5lUOa8tba3a5b93lv
         KhOKc86qOb5bFehBh4IxW7DEiDZT7FUvMotFRRMpK7MM+M29Qqt4vAh02nf++hCPEO7B
         T4cUUcUJpqfSObu56yt/+pCxbE5x1pBzjPwB3kkiFV75EDvfyWaFiHLCz3sxiea/CbiN
         EFpWl23AfZV40ItILvFCtUm6Wp452s7PomHn4bZmw1OYYyLjAgSNe0Le5YdTQiwHMztq
         iAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754568987; x=1755173787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GHVxavGBrjI2mC/mT+iovNRLtR2msFcHcq0N4dnm4w4=;
        b=JTT0aDW2fPvLjM3mLLx8a/4uz/cqgbziss36REy9uG32hYwRneGREZdU0EA7YU0Pwi
         PgPbXwSHrL4dwqwxkNf8wAUKkaF31uOoGOm8DvGlLkKrMgNkSoYIRQSwSYxAE6GmRY76
         iihZf2qHjVR1P3V/Q0I5j6F3eyf2nrF4UnDbYYj3C+sboFilhU0D/Y2XSQsWl97+1+em
         nJeiLHpdTV+39vTbYohrtmInreLIXdNMQULBtpHYT8vYzXt4d9toqtfyNeA0p3Zy1WXx
         KtoOISgJX1JAHf8+azknhH9tiJjWyvWZZmHVdEaGYCbPOXRwKZjl4YH8EpKnu5Cl9NGc
         8dfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgqjRSAw/TrhwTWUNawqjs+FCLW7TDVkv2f1r3KrshGiC5/4IRj76Su7BP4Xl3KIv1RpYUQv8Yxg==@kvack.org
X-Gm-Message-State: AOJu0YziCG6+6OhLYO3DyVAgwHWEUna+szD53yH8pfBCwSqHKCELq7yk
	a841kNXk7vfXnQ/8XhrhPa3a6D/z4hOWnWOkllL3hQwwlHkG67CuxOGU
X-Gm-Gg: ASbGncuzgcExtQ4sdfoMupFasENvqjZwszPUQSyhedtKq6eWuxxEe/edHWm/P9CUl5g
	nPPEiJkd8U8SXiwO22myYWQ7BN7ATXHFGPVdBnaxktZ0287IjsnREV8124f2o1Q1oDtD8On4chD
	MOycjoFLYKjOfK5qVP8PpCA/hNGoHbxR+ATQWLm7bXB1kq2pli3tiC1nqBujyhzktTy7qjesqDf
	a9UYTXUSukSJwcRL5+drPmIrJoobsr3kW9ZHZFmHXjVn5l/qNo4EZ9LZQuDQkIJiQsxdjWZ27We
	b1wIRiUHPfRazi0RkVEU6wQPTvHfH7N4JqVDhbmijMNnLf09KpYSDs/1U4xWMOac8w03x9Z8P2e
	YRLnh1ePzLIqTNfmnQ7mFqbQgXs0bMx7+0sCcruqG+ALOctyREi+Tqu6DnUFs
X-Google-Smtp-Source: AGHT+IEOgiOG7X+/+74Nfd3tZumZZr82xYQBn2+nD/Q2k2sFIFigqmAXZC4pBSX/xsQ8vrDeLg+6aQ==
X-Received: by 2002:a05:600c:5486:b0:456:43c:dcdc with SMTP id 5b1f17b1804b1-459e7136bfbmr57298345e9.33.1754568987042;
        Thu, 07 Aug 2025 05:16:27 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e0e70218sm120028755e9.20.2025.08.07.05.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 05:16:26 -0700 (PDT)
Date: Thu, 7 Aug 2025 13:16:11 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: wang lian <lianux.mm@gmail.com>, akpm@linux-foundation.org,
 broonie@kernel.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 sj@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 brauner@kernel.org, gkwang@linx-info.com, jannh@google.com,
 Liam.Howlett@oracle.com, ludovico.zy.wu@gmail.com, p1ucky0923@gmail.com,
 richard.weiyang@gmail.com, ryncsn@gmail.com, shuah@kernel.org,
 vbabka@suse.cz, zijing.zhang@proton.me
Subject: Re: [PATCH 1/2] selftests/mm: reuse FORCE_READ to replace "asm
 volatile("" : "+r" (XXX));"
Message-ID: <20250807131611.430a097a@pumpkin>
In-Reply-To: <22169C82-5701-4ABB-811F-075D22CE6FCD@nvidia.com>
References: <20250717131857.59909-1-lianux.mm@gmail.com>
	<20250717131857.59909-2-lianux.mm@gmail.com>
	<22169C82-5701-4ABB-811F-075D22CE6FCD@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EAD0B40012
X-Stat-Signature: izpenkwajoycaboj8roheqw6ft171kj1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754568988-123534
X-HE-Meta: U2FsdGVkX19AktGUn0ggUAJn7SVFF2yVcHH1oWXGfTp6tVvAG2yWfsYiUjTxH0PQk3DzBwpNxleHSoUF4BV0s7jBdD6K3Una7u8o3KnOw15F2qQXDb8dIbk6ck3pEYm8JMSDzYn3hehp5sCVH0SpWo/Vpk3VDmPmcYmt3T++/OVz0fA1FR//4/TV0zwq6Q0Lb7Y5uyXk8Btvf0k1pmyrs9JyAWbtIFpHUR8cjODfYjL5rzSqjI1mSg3njrVdHEpG4YmqffrlUvxEVmQREIB20HJiD/nhBL6Jq2J7CyV8gsO3rTtC21bTuY7D8dDjEs0HTTADf9Rz09d99nTdqI9tbmXDZVjjzQQqtjjMvnD5SYCQMKiRlcdWuM+DceLoW8+o39KOyjgDbwvrcH0B/JxHzCVBZP61mcOifBhW4c1cOW6wbvA/i79WoTVy6Ke27Quj5pmZX8xGr1H8kr1HWnzam6WNvSNftjWdMYme+uWhZ0OjfZsup6hHCHF/tAjgC7Of67jaz9sWAA0u0yaaCR8w/LhfhwtmvWJodCsaIcoDNbm8z/KD9SjwIWCi33oIf4i+QZJ72h6bA0qgGmu/kEYGt3KPOZ64COazfLtG0/s1qDFdnn738cbx7jl7DlBeUveot+o6a2TjFup4yeyNeqifRB0tN/e1p0m/2PezhCMg9jNyizCo0/ZBjLOmgQMVBI1Z57aKN/NXjc2FeJMPK0odYJY+2EnYwr26Obx4CX2i/NJEyPJDAVjjivKOHMpuymDiN1Bg9p9AU8owc192T4fbM/KC13kxszSm77c/DmKkg+N6fm/2vqXRVLzvz9liWbL5UMuK+Wig39/EKYyCkffw/MuhmLzRqBTX3Ec7t9SyYwIcmOi+iIFjXRnsLhgCdJVMEYKLXovIMKVRdRZ2N/+BqzNfhlbqBciZFThPZoIhwtYZr1sl0j968zdJUqnwoV/AYG8ohKvn3dl8a/Ji6Zs
 k/mvdoUZ
 ONzG5qry3pZ8YbWDv7CxZg9mjt0jjKYRbyqQQMSv9Y/TiXOC+WPZiWnT9FX2bQ+pDQ7nHCDIZ11LVehbGr2leg8TwW9ZaBs+7EtzlOPFCBVQx3h42ZyJpR7DSjn1G0akamtyNG4EZ4JF+QfN6fJZMgzwlJe1GtcHBdPNkbLPKGytPQK+gG3VXb/3zpvpoVmYcqVVmeVqzTtR1NLYLh1HpXMxNmSnP1/j3ubWGBvJjkz/KVOaZytA0rFVupxp1mXEyTfRYBIIcqbF2rBg641BWlb4tVULc6oxv3Jnzp2B62PhkPhGFKsposhOk5ts8f2RU17daANTKz5PI7/bI6zN5gDpZCk68UbrcRk+Ot4yqaNhH8GUkkmen/0dsNWWWqe7smfmcnJe1O2OEAYJtByZfsSBNH4jBSD53/qhTgBNxcoNLWJHLHYqzVF0g/6wFWxy740yYdUuGa/yCz2iQEHhHBxNiPmLXfHPEiDk4jIc58SuDPRFk5EEHt5hbl9t8FD8+UtDcc4u36mshV86NCLIyGRb8Pc844Oe+5DnpSgWloaqv0s9tsTr6gkM1g/NVc+lzLF3oMLBJfzFYQzw+XF6mIdISalOs1UocGZIjem1q9zGYj3LbtZfpWTmOPsBE2FT+SVyVSyOSwN+6TMw7jjjSF9r5w6REInMB0KXG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 05 Aug 2025 10:26:17 -0400
Zi Yan <ziy@nvidia.com> wrote:

> On 17 Jul 2025, at 9:18, wang lian wrote:
> 
> > Several mm selftests use the `asm volatile("" : "+r" (variable));`
> > construct to force a read of a variable, preventing the compiler from
> > optimizing away the memory access. This idiom is cryptic and duplicated
> > across multiple test files.
> >
> > Following a suggestion from David[1], this patch refactors this
> > common pattern into a FORCE_READ() macro
> >
> > [1] https://lore.kernel.org/lkml/4a3e0759-caa1-4cfa-bc3f-402593f1eee3@redhat.com/
> >
> > Signed-off-by: wang lian <lianux.mm@gmail.com>
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  tools/testing/selftests/mm/cow.c              | 30 +++++++++----------
> >  tools/testing/selftests/mm/guard-regions.c    |  7 -----
> >  tools/testing/selftests/mm/hugetlb-madvise.c  |  5 +---
> >  tools/testing/selftests/mm/migration.c        | 13 ++++----
> >  tools/testing/selftests/mm/pagemap_ioctl.c    |  4 +--
> >  .../selftests/mm/split_huge_page_test.c       |  4 +--
> >  tools/testing/selftests/mm/vm_util.h          |  7 +++++
> >  7 files changed, 31 insertions(+), 39 deletions(-)
> >  
> 
> <snip>
> 
> > diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> > index f0d9c035641d..05de1fc0005b 100644
> > --- a/tools/testing/selftests/mm/split_huge_page_test.c
> > +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> > @@ -399,7 +399,6 @@ int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size, int *fd,
> >  		char **addr)
> >  {
> >  	size_t i;
> > -	int dummy = 0;
> >  	unsigned char buf[1024];
> >
> >  	srand(time(NULL));
> > @@ -441,8 +440,7 @@ int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size, int *fd,
> >  	madvise(*addr, fd_size, MADV_HUGEPAGE);
> >
> >  	for (size_t i = 0; i < fd_size; i++)
> > -		dummy += *(*addr + i);
> > -	asm volatile("" : "+r" (dummy));
> > +		FORCE_READ((*addr + i));  
> 
> I encountered a segfault when running the test on x86_64.
> i is 4194297 and fd_size is 4194304.
> It seems that FORCE_READ() is reading (*addr + i) in 8 byte size
> and i is only 7 bytes away from the end of the memory address.
> This led to segfault.
> 
> (*(volatile char*)(*addr + i)); works fine.
> 
> Both gcc-12 and gcc-14 have the issue.

The definition of FORCE_READ in 6.16 is:
#define FORCE_READ(x) (*(volatile typeof(x) *)x)
this is clearly bogus.
'x' is a pointer - follow it through.
Possibly:
#define FORCE_READ(x) (*(volatile typeof(*(x)) *)(x))
is better,
But why not use READ_ONCE(*addr[i]) ?

	David

> 
> >
> >  	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
> >  		ksft_print_msg("No large pagecache folio generated, please provide a filesystem supporting large folio\n");
> > diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> > index 2b154c287591..c20298ae98ea  100644
> > --- a/tools/testing/selftests/mm/vm_util.h
> > +++ b/tools/testing/selftests/mm/vm_util.h
> > @@ -18,6 +18,13 @@
> >  #define PM_SWAP                       BIT_ULL(62)
> >  #define PM_PRESENT                    BIT_ULL(63)
> >
> > +/*
> > + * Ignore the checkpatch warning, we must read from x but don't want to do
> > + * anything with it in order to trigger a read page fault. We therefore must use
> > + * volatile to stop the compiler from optimising this away.
> > + */
> > +#define FORCE_READ(x) (*(volatile typeof(x) *)x)
> > +  
> 
> Also, look at FORCE_READ again, it converts x to a pointer to x and
> deferences x as a point. It does not seem right to me.
> 
> Best Regards,
> Yan, Zi
> 


