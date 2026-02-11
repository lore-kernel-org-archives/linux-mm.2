Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E340DE9E31B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 15:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3E436B0005; Wed, 11 Feb 2026 10:38:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29626B0089; Wed, 11 Feb 2026 10:38:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2C436B008A; Wed, 11 Feb 2026 10:38:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C336E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:38:50 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 627A21A0401
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:38:50 +0000 (UTC)
X-FDA: 84432583620.14.B0D34AE
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 64A104000C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:38:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EJCFXRhR;
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770824328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YjD27gw3z2l0V4U+puCKvq8s4it1mD8vS15+HZDUwi8=;
	b=mzTOtfMuE60xkaKgWFkcI7ktWZMu874cncJFMyinZhEGoCdnS/znLE09pxzxCfq7r1oPPJ
	iP5S5OsB41hVbvz35zzKusZAvkx+iI4vMyIL6t6MTeL4QXA+u5ZjYR4M6BqTsKGKo5c1Wz
	vR9LoZkXuaxFEuU5MyT3v3iojbbPKWA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EJCFXRhR;
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770824328; a=rsa-sha256;
	cv=pass;
	b=YeEfU12E/bxxiGBD/JVgDKQPzh01BY0fdj8F2w9YXWQzenj643+gyuxCeOtN2JX5vjoCX1
	lrWfJ38In+Ytuo9sTU4jr9MWV0BnhflZE9+XIVg1Dhn5ADXt5oB3uIe9RzRgu0/elilPRb
	4Ov7vpMB3qroNYbfCsLB24OdbYWyhJY=
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5636784884eso794760e0c.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:38:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770824327; cv=none;
        d=google.com; s=arc-20240605;
        b=IN+pyFqBCDsckSYAOWr2roGxxTMgDfFD0WdlkGAE7LN3QEgu/oDy6Yz6OqUskZII+H
         ovD3ZUwNCyfyqrnSqEYOy3bW19dqjxCD08CoqCJ6prqWc8Ma1PGdNGLy7HOYhhmv77BR
         w+Jk+hHbGiFN1g90+o6KSw2FZcPD7YhpSrcZgrUgIaxQ5bfUhjaVx2LS2cZ1rpWXb5D5
         N0jNkkFNB5TAKahNZrhONpepFpg00+Tt3E+D5R0y0QhqmH5pQ2vdGjo2Ujcdj4NSnFWg
         O/d8lYsVAbTpIpRk8nIbSDxE5weyCQnWNHWuNn2QCv1aV4QheudgdkdWz53OTgRMQdqU
         uYww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=YjD27gw3z2l0V4U+puCKvq8s4it1mD8vS15+HZDUwi8=;
        fh=FTH9xgmeIKsV4wgI9X5vIozomD9fLrE9yTxVl2XFCsE=;
        b=lgXHVKpUqZeIWhOnCP+8lr5/uz6lKy9jE68q/WIZG9QYRc0PujY76zAvOT9gzPk/hQ
         IOGAn/e5weMNf2EbqSI+NLfBLYdq6aADj3XiTZOW/PtoDE+ZGt3egDZ16M/pTR8tfij6
         er/5OS6Ve1XOa8jn9jd/ixMpMeq4MswHQoWRFfkJM2DKEtyIGq0X6h4VWX/8VKPJBTRb
         iUSi2SC8dzdXAnPPsr3rROqsju0mvIBA2NblokaY7b/Pajx7N0aIuN5kwv02WrNfHf2h
         gu52Ib6jTSNeb3k2uoACdx/Lr8hEP3EdTVnvKRzHI+XbrXMAegUT2goay0It3DfVCXsn
         WJSg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770824327; x=1771429127; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=YjD27gw3z2l0V4U+puCKvq8s4it1mD8vS15+HZDUwi8=;
        b=EJCFXRhR8RKSNicU85xwA4aZORUycs0zzr1Vax/l9hWGdwR80XqDsiyHL+WTvpco+S
         bPZcwzDT2amvhVFsIqhUx11yymli6jBv2Gu90ZAN6MW6y60WCodw5/eDD/QZDtm6+nDb
         1KTuu5gESi+4VJDBeWI31SrugpPo9MdIMJuq12oYzZ81q8cWZr7R/AX0dsA0WVDulG4Y
         VeS9aFuXYah9agWB1+FeMPG5QQoxz5u+SsylhZKpLn8X8snrZzgmfS8DxjXPpvylFrJn
         1geRtpfx7q/qdsvRHc9u5WgbgcWnPq3y9x6aBqio6VEAHR1jBS2C+Nfzv1XAXCk7t4t7
         SrTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770824327; x=1771429127;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YjD27gw3z2l0V4U+puCKvq8s4it1mD8vS15+HZDUwi8=;
        b=r0t920ARU46nlc6HT1hiPQ4Obrk+U4emjC80yXaP11+6cnzK4zTax8kdHKGzyVaHAV
         jtOLn1GIncBpx4K+g8B8UfbH3KPtTC8lXha9bYeYjQVr2iScEO2GklpgG1KoprXPFQ16
         E+IRmPJmkBdh+r/Nyf7cg9Kj9lh7nMvDVDmxlDrPKFFptFA9l4cEh9iBM0o8NLnS7T9p
         tK4i/E1mXwAQlmMTRNF4hQprPh9yKSqzFEjTayux+QdUTq7u0cxaNTgzN3pIJYGX4Cex
         Yf4jG7lpTAXRaAPtWAyfCDnWD/A9CTq682lhOfbSF2J++9DX9emCG2reCKuyayiPfRpN
         vHLg==
X-Forwarded-Encrypted: i=1; AJvYcCVWX/rGfAe8780vzT9mrPIqPEd8Gke377WtqBBRKqiebD4HhzJGDN4lfi19TVHY/YWAZXfBzS2a+g==@kvack.org
X-Gm-Message-State: AOJu0YzltVWuGSjI7DL/+WsWaS0e6R/DJELG52ecXlkj0ynrTsPWT9cX
	AcJgSmPAbwBW4KQv9f2pNVrNXLG4IPJmi9sGmCskYdpwjU+4K3VTnbj2Ko79QdSdLrQ6iNRXfcS
	COP3vlt7XS7fU5s3L7StudPn/5oADBuwZKvhTi8aj
X-Gm-Gg: AZuq6aK0Hy4TG0I+cL2dXXhrxTKjKR4fka4tXqmmPUyFMbBmQQtcvaUg4OiKxi+kQwg
	OciTj2Vqg2Ps0n+fIipcyBF9xVZw4yFJTbneBkaAsmWGqKEdzumeGQNg1QTNCUTsJxxoHOu4A/T
	GkItaFUJV/oADLfh4R5DUMZS9q15KRsVBpSYdlhx2vhWcpahoty98d7dD8qmUrT0C0nWYlIOVSv
	URtCTF2OvxoEmo1EjgMKKlxD7nFxhbg59tE2LPQ5RjgeAhks35Ew4SrnIwztZeTdd54VYnjAObb
	SFUNsGcNTV823+Ew3UuwMTF6W9/7rYs7wutYzg==
X-Received: by 2002:a05:6122:4682:b0:55b:1a1b:3273 with SMTP id
 71dfb90a1353d-56705ed3a2fmr5185292e0c.6.1770824326907; Wed, 11 Feb 2026
 07:38:46 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 11 Feb 2026 07:38:46 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 11 Feb 2026 07:38:46 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <bac19363-0705-4bb2-b022-66054e1f28cd@kernel.org>
References: <20260209033558.22943-1-kartikey406@gmail.com> <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org> <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org> <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org> <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
 <bac19363-0705-4bb2-b022-66054e1f28cd@kernel.org>
MIME-Version: 1.0
Date: Wed, 11 Feb 2026 07:38:46 -0800
X-Gm-Features: AZwV_QgGZH12m21fGUVyYGZpg5CmsnOM8AuD3uD1FWC8AN8BWpumGJ7ecXqMRn8
Message-ID: <CAEvNRgH6yfFtOK3E3__hCjkNTQr55y-_N=SpBBr0i9_q6E2_8g@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, seanjc@google.com, 
	pbonzini@redhat.com, michael.roth@amd.com, vannapurve@google.com, 
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, 
	Fangrui Song <i@maskray.me>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 64A104000C
X-Stat-Signature: p4958mqcan8e8yrg56an3aswoqwebzn4
X-Rspam-User: 
X-HE-Tag: 1770824328-888099
X-HE-Meta: U2FsdGVkX1+yf5QYO8QkcQuIDaaask7ANTpWdnWwMgpoz3Ney7eilC2ha3jWQJPY0da+ZZ5zQg4hUCOnZMu+l9bMkYeOW6jDyF0Nluq9uupJVvJfFwbUIpfDQbluP0OY/DC1HmdnqPwbRJw6gLYRH6R3Y9uwCx2l582bfngotwr1iKUWZKSUmSG8EDsIspRQa7R2qoRqDLLUMbRhSAXeVEqzb9FzIh1YABv3Grr7/UA6x/UbtJb8hZtlMrvvJmooXcf1KqHpakYs+H0OkfaPQe6x3F+O0EgqHtwdRTOOcPg6xGQbVZITTPPA5VYwNUXG6QBCLlfuh1LtjuQz5w9Aw0KIzour4azsPDcW9gOaza68qEpzR+pSC4uno1ov2MIXockYYn2oIDa8Jfk2RkvAAmGB4g31e7xjnwjhTMjL+X4q/RuI8pSeISDUOpGyfUpDNOQM3s9NM5e+4hckuZ7wbVpSCc/uxwKBlW4mZS6BlUGqhSemPJL5IrsyRfhNJ1P1Kb/eVkp3X+ymuBoH1Ssi8ZmQBh89OPjnWmiKGpfMLg9RoDxxctG/h96hbbnt8zKvY7zW7hAzWcebe+an+YZ1SryirbmJdAbFBtN/cOYjjPWFfweUQ8KOBCt+oLhSEjTYH/Svx8IAieErrL6hJEighrMvore0GmWsJRvWgf7Abe1XrVxUlyK7CBa9oBNSrZzh8V5lGKV361ZBMEjtXqyvtgQjHLNJ+VFxbxA0TIqZLsqfgqlhgx9gqpPfaUj7p1xVKEoCuSENHqMA29cKAqUgzwgTPU49BhRcvchhijLJ/c0Uw74Y0sLY1fhtkNOZhG/BNzTcSP55O6UVxMGV0G4puNGCXOHmsnsWBAydzN5vYcwDB7Dli8aGj8EF2D0khXJHIs1JuxtGI9VrDh6vK3nAPzMniJLLN9Xmn+DfOAtNzpOZAEv2cr6YDAoMMBhNsXiXqBzcG8n1tHccjKhgKeP
 fT5OFFwD
 2FqUSk3d1FbVJy+Q3+qbymgvTCgIS5JWzj/9vsPPItmknYuag+XIypzVFInG0j9e4YKNvzTMDEBNYaMrQwrHUF1tBucuoKMWtMLIHSgBE9Mi1lSz1SD42UE9m20ss8hvikBMamukWZgrYbIBb1Dh8hinkTdJuH2k5+/6vo4tLdgX2EVgwRe7J1u024bbmFxaui3RU457ogbpT3y6HdR+Pc1/t5JYxfxjd/gmv5RHPO1YCVguyIQGPVlhkNSG5uO3rNs/fsPs+N1o5RxED0JIsmOJcFj0YtwG7C5hFp9jDBWkdpliFHlwJ/B0HXXwbdvboCwNmWIKTL2+adh4IEHOkCBe1XNqaJrFOwwQdUvpriQa2TKxwAoMUfkZkJpuQAIKEc11GcABe4Yl3+vW7QHNpGEJ6HIZOd55/f6RCchvloFF0B2W6FHLg6+m7xexOr1gaWRKEVlCa85MsgrtFj3Z+tzAmNtRgndGUzgyak50u5cOSw19cB8ih3rCeUfnRlE09JNvV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 2/11/26 00:00, Ackerley Tng wrote:
>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>>
>>>>
>>>> I could give this a shot. 5.15.199 doesn't have AS_INACCESSIBLE. Should
>>>> we backport AS_INACCESSIBLE there or could the fix for 5.15.199 just be
>>>> special-casing secretmem like you suggested below?
>>>
>>> Yes. If there is no guest_memfd we wouldn't need it.
>>>
>>
>> Seems like on 5.15.199 there's a hugepage_vma_check(), which will return
>> false since secretmem has vma->vm_ops defined [1], so secretmem VMAs are
>> skipped.
>
> Are you sure? We check for CONFIG_READ_ONLY_THP_FOR_FS before that:
>

Ah... I was working on a reproducer then I realized 5.15 doesn't have
MADV_COLLAPSE, then I tried to hack in an ioctl to trigger
khugepaged. That turned out to be awkward but it got me to look at
hugepage_vma_check(), and then I went down the rabbit hole to keep
looking for the similar check function throughout the other stable
kernels... and amongst all of that forgot that
CONFIG_READ_ONLY_THP_FOR_FS was unset :(

You're probably right about VM_EXEC.

Here's the reproducer for 6.12, I put this in
tools/testing/selftests/mm/memfd_secret.c and called repro() from
main(). This time I enabled CONFIG_READ_ONLY_THP_FOR_FS :).

void repro(void)
{
	uint8_t *mem;
	int ret;
	int fd;
	int i;

	printf("%d triggering secretmem\n", __LINE__);

	fd = memfd_secret(0);
	if (fd < 0) {
		if (errno == ENOSYS)
			ksft_exit_skip("memfd_secret is not supported\n");
		else
			ksft_exit_fail_msg("memfd_secret failed: %s\n",
					   strerror(errno));
	}

	if (ftruncate(fd, SZ_2M))
		ksft_exit_fail_msg("ftruncate failed: %s\n", strerror(errno));

#define ALIGNED_ADDRESS ((void*)0x400000000UL)

	mem = mmap(ALIGNED_ADDRESS, SZ_2M, PROT_READ | PROT_WRITE, MAP_FIXED
| MAP_SHARED, fd, 0);
	if (mem != ALIGNED_ADDRESS)
		ksft_exit_fail_msg("Couldn't allocate memory\n");

	ret = madvise(mem, SZ_2M, MADV_HUGEPAGE);
	if (ret)
		ksft_exit_fail_msg("MADV_HUGEPAGE failed mem=%p ret=%d errno=%d\n",
mem, ret, errno);

#define READ_ONCE(x) (*(volatile typeof(x) *) &(x))
	for (i = 0; i < SZ_2M; i += getpagesize())
		READ_ONCE(mem[i]);

	ret = madvise(mem, SZ_2M, MADV_COLLAPSE);
	if (ret)
		ksft_exit_fail_msg("MADV_COLLAPSE failed ret=%d errno=%d\n", ret, errno);

	munmap(mem, SZ_2M);
	close(fd);
}

This reproducer gets us to madvise_collapse() ->
hpage_collapse_scan_file() -> collapse_file(), and copy_mc_highpage()
fails because copy_mc_to_kernel() returns 4096.

memory_failure_queue() causes this to be printed on the console

[ 1068.322578] Memory failure: 0x106d96f: recovery action for clean
unevictable LRU page: Recovered

No crash :) Is a crash the requirement for a backport to stable kernels?

> 	/* Only regular file is valid */
> 	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && vma->vm_file &&
> 	    (vm_flags & VM_EXEC)) {
> 		struct inode *inode = vma->vm_file->f_inode;
>
> 		return !inode_is_open_for_write(inode) &&
> 			S_ISREG(inode->i_mode);
> 	}
>
>
> So if you have VM_EXEC on the VMA (mmaped with PROT_EXEC), it would work.
> I think secretmem sets SB_I_NOEXEC, which prevents that. Same for guest_memfd.
>
> v6.6.123 still has that VM_EXEC check in file_thp_enabled().
>
> The check was dropped in commit:
>
> commit 7fbb5e188248c50f737720825da1864ce42536d1
> Author: Fangrui Song <i@maskray.me>
> Date:   Tue Dec 19 21:41:23 2023 -0800
>
>      mm: remove VM_EXEC requirement for THP eligibility
>
>      Commit e6be37b2e7bd ("mm/huge_memory.c: add missing read-only THP checking
>      in transparent_hugepage_enabled()") introduced the VM_EXEC requirement,
>      which is not strictly needed.
>
>      lld's default --rosegment option and GNU ld's -z separate-code option
>      (default on Linux/x86 since binutils 2.31) create a read-only PT_LOAD
>      segment without the PF_X flag, which should be eligible for THP.
>
>
> So that one broke secretmem.
>
>
> So when we fix it, we should
>
> Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
>
>
> What about the following:
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 44ff8a648afd..9fbe5c28a6bc 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -94,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>
>          inode = file_inode(vma->vm_file);
>
> +       if (IS_ANON_FILE(inode))
> +               return false;
> +
>          return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>   }
>
>
>
> --
> Cheers,
>
> David

