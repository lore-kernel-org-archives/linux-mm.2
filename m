Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDEDCE9D83C
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 05:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A08686B0088; Mon,  6 Apr 2026 01:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B95F6B0089; Mon,  6 Apr 2026 01:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F68F6B008A; Mon,  6 Apr 2026 01:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 810896B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 01:35:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B04531B7405
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:35:51 +0000 (UTC)
X-FDA: 84627019302.28.35508E3
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id E426B40006
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:35:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YHD3aSbE;
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YHD3aSbE;
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775453750; a=rsa-sha256;
	cv=none;
	b=dty5VkMlTFXp+VmV3nIhcSwp2vt6FAK8wE59JL2YCWGIG5W6/lFI2g15Rndr08BSktcJWW
	l3+XCzrSQ5+hiKtYuS8NUP/7blb8E4VIULzbS8H9tjsoJoq4g5xfhMGHnpHpqgCufNPp1+
	9DjNvWIPI/J1R03CriVssb6u8ZGbFIc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775453750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FJme28X6M+hpI3k7xxHy5T5VcxdI3tFo8G0ICpt4XA=;
	b=hp/1+7V8rqX1WHjNzmCu4m/ZhGwnIF/MDDF8gSS5GgHtQJZun2KDzgxb7e4zeU+kVoSn5v
	WNteOo4Enc89QQIdEttMx1td0cXkf3KSSc2p9LMLzpfPjO/ABgTykulumqZuqpc4pgeYpG
	hA0gkFWu0Gz9eWNDjnNfddmZ2JahnR4=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-79a74765703so26877797b3.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 22:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775453749; x=1776058549; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9FJme28X6M+hpI3k7xxHy5T5VcxdI3tFo8G0ICpt4XA=;
        b=YHD3aSbEwzw0fr8AY1DoevNvc8eqOmOqaLReS/X5o3lntdlneZhCAWTS2t6lx28jYh
         SvILspik8XJi38m9Wwm2rLGJY/08lzwknPH37aqqxCOci6KCa7NOhd49+xhyx2KDLUSg
         ithtMAH49xCzKmJVf/FgC+U6BLOt3JPxcLP12qq4kMNispqbX/hPsirr2oV2C+GY6ndm
         Y7OMedbUNF9pEG1BQpqTsCmcdCdbHYjTvV8z8z/Z4ChmgD/vEnlTAnGo1zslB4nWUTNF
         byhRsaqH09Od8IteoJ9Yo0o8BtsRIClffe1MafVrdRquPV0v7EQaK+f2h5nODKDOnYya
         VZLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775453749; x=1776058549;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9FJme28X6M+hpI3k7xxHy5T5VcxdI3tFo8G0ICpt4XA=;
        b=TV+FQjrgGDLnhtj0bRuyHLfOx48NLpD8Kz2/CKcEb71pDEy+QWU+56KJmV+Lq+fZdl
         lhTMwiZTpLhrZQNLvL/S/ypA5Qhbhw6R0H0vVaHt/b+Ge2x2uzUZRJ8KAgGjpm04fYri
         ++VaNRnvU5j9E/FlSone3wTZQoSw/rjjpOZ5SJFZrJkgVYunsS5rXShKBy4WN58gYP2L
         pe56uShV8JRhc68TZdjjbMtdPyOvOjuTPx5EaSq5SYndU57oq6xX2Rr2sXD/T9QMVhoE
         OfatFZltDuoTGGL9P0SUtoOxzg5iSyYR6bmnVl06/8E0kXbVFNLBuJ02Y2IaWE9BSVqV
         flew==
X-Forwarded-Encrypted: i=1; AJvYcCWcZnFF+hJSEK/sVq7VAjy3gKZwxSN05vw9pDw6g6Qq2bE+dmODJGqAW0pS7i0z7WCjGEnStQagaQ==@kvack.org
X-Gm-Message-State: AOJu0YwwojlkvNixlAIOuwepTEGpfkHw1QpLBfFr5vcEIz1b4YLnj6W4
	p3LFl561UrKsMzGqLU7i+lq5EA5xa6OemdDtvF4ASuWvaGUwQHz/p/2k+LV9XbcoqQ==
X-Gm-Gg: AeBDietT4iut8T3RSJkqxsL2xq0Up2ZIWV7TLONUs51Hlg97ZkSWD8AZyMbGLe14NBG
	IeuTaj5klJW5OdECUyOybRGfn9ktauI1d7BCeHtfUNiEjdXf7il0BKzfH8s879XblvdBsD5Bys/
	YU/V1l4baCFg2ncSX1Rn9ao+1N1qYUH55MMHjFWMJyxTYotF00r2D+RlS1OxwlweZAZU2WQkY9g
	MJCfi0fgWr6R6N9pw015kXLji6/oMf6OqAfXSbnPmHn/8yUtWrZGd6Fpo/x9tGU4tp7RlQX1EfM
	YIt8s7oMOZ3mWdqpebHd86ewNMlzNG4R4tZkIBVzd4ojC6OBaCJq3llXnm0EhcRydL/wCRZvEID
	uXEBvKthq5sOrqpQRLk6MgEeO6KKLuWqDh1E5h9VjD3ioOLBmw6T3wnKDLNqd4rHZT/lS9+xVld
	tgeQMDPXOEzpf5GlNY4z54OVXRv4iijXcoaTE6t6jyawjO7baMxA1wx+e2NTfKtZMFF97cqyv6s
	8uma3UQ7yU=
X-Received: by 2002:a05:690c:e4d6:b0:7a4:db43:c1da with SMTP id 00721157ae682-7a4db43cc17mr88182507b3.0.1775453748466;
        Sun, 05 Apr 2026 22:35:48 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7a370901513sm49673367b3.29.2026.04.05.22.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 22:35:47 -0700 (PDT)
Date: Sun, 5 Apr 2026 22:35:35 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: xu.xin16@zte.com.cn
cc: hughd@google.com, akpm@linux-foundation.org, david@kernel.org, 
    chengming.zhou@linux.dev, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, 
    michel@lespinasse.org, ljs@kernel.org, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
In-Reply-To: <20260406095804589iRP1BCGrNX3DviT29nv2O@zte.com.cn>
Message-ID: <9950c6c1-f960-58c0-4312-e4f5ac122043@google.com>
References: 20260212192820223O_r2NQzSEPG_C56cs-z4l@zte.com.cn,20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn,02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com <20260406095804589iRP1BCGrNX3DviT29nv2O@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E426B40006
X-Stat-Signature: rd175m9f1d5sz8u4ekpihkqfen5z873q
X-Rspam-User: 
X-HE-Tag: 1775453749-554348
X-HE-Meta: U2FsdGVkX1/ypJHIe33veXI1UpghXpFbqJGRfOQGG/z9l+UANYXM0zOZIQ2bY7inbFy6x+pwHCTZxAaVGLnA9/bhDBLHGKLmdoZYc9iCNqraxTR2YUYT/Q/BrNjLYtblRF60R0nxKUmoPYIUTOuFpHsdGkawzm6p2xDtheyPu9OSbULktn5YacfdGXDTa2cyjnrAw9kiUHAn07X9+oupNopsF8McVFBMbXhGtlal9z7AbJv17atpm7ZLz9AHPrMv101z+tMhQ27TRNMpBGX8UuVTrWIJmKKm5bbjvWwWTfDXNXM6bPqX4woqWGUdb//5N4FcydeTJJeBM0uCXjiDbB4YMPWG7RqqWsugvhQYdTI4+f9GHcovERlhQs34TIBPnofRxOOkTFHkYKdf3M621qF1QdqbtrNJcyb9KOEbLWuPJp3HNgCYrw9oWNdWMGa4oDCQ4CU25Sj5vvqcPuPKx6spVX64YeWv1cQHgwsQLXHgKgudEhKpa1pyszUnjFKrtcSg7/3CLjcocIgEdtxqoYpC3fMzQwgRyv0UB2RWXDRb3Ul/PTubQa88GZ9Ue+u3gvf4MMmkaCIAOKtUJ8CWjBf7r0fVFUDJqE9r8G1KKcsDG1Tbzbeik7Em/rVVmGz9Ce2HZwhIShHVC6BJfmMF6VNGIF6IPxdLOok9wII1/8dphGuztXMeyvc9gwhGZ4Djf9DmDdNyWVZLfIiGvlebPqqvxXWbXohHZSRLn8pYlLHMhg5NUM6SUxr1jlIVQveyDZaI4uWsAbz+r+yGlI0RNduJv4PM/dKYjYXt9jR4MoH4VIoG/imhkje/VXphyrjdgDGf+FPczbK2jOyCOi5ks54fOKx5OykzCmsllYi3x9c9SKk3D7Awj/uzkt0gAzh/Q7hdfXcEN0CnSCOkLj99M+Ja9Poezty0TnhEsnMQLeF0/iIGU2AEZK+BxgrCR19vIuPuVB4otHoY3KCpRiO
 iPyaVQ4N
 gSm3P3lZsoNZX6FQZFcNpUVK26LDbVTLREE8hxQ91FX/GN792wf5AvgC2T7U9sjugDpnPiBgEGindfAnVicx5KPBW5gNtbNPIg6nP/woY71L6pxe63GJF5QLqp2R2CHRzG7l/dfM1DqU7VMGINGGykQ6pJurBhcYqHjeb8R8VF6MhxC0vaI9f8zUZ35ObL3PRRqNBVht0nQCaJpJM4s2iwWxwpZJwLBuHRY+SSnFqQb5LDG693AAGT8rRhjU6LxeKV2SfSXL80BdRAIiQ97Fo/1nhVTQzgROpBrzW3IDqQGjwgIYTJ8XF7JR28HKeev6G5emiy66KDuInEelTZWPp1Qw2S90y3ELSJlzEFjzggXO4qjS1Yj5rUZLXs3FiwsMt/dz6kk4mHeDdEdInMIPCIZhiTE7SFRD+bcD5lCW8jSGYXx1FhzN3SjfF7CdUhgpCLlLWjrTZubGMccz8c1oe1BiQXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Apr 2026, xu.xin16@zte.com.cn wrote:
> > 
> > But it's years since I worked on KSM or on anon_vma, so I may be confused
> > and my belief wrong.  I have tried to test it, and my testcase did appear
> > to show 7.0-rc6 successfully swapping out even mremap-moved KSM folios,
> > but mm.git failing to do so.  
> 
> Thank you very much for providing such detailed historical context. However,
> I'm curious about your test case: how did you observe that KSM pages in mm.git
> could not be swapped out, while 7.0-rc6 worked fine?  
> 
> From the current implementation of mremap, before it succeeds, it always calls
> prep_move_vma() -> madvise(MADV_UNMERGEABLE) -> break_ksm(), which splits KSM pages
> into regular anonymous pages, which appears to be based on a patch you introduced
> over a decade ago, 1ff829957316(ksm: prevent mremap move poisoning). Given this,
> KSM pages should already be broken prior to the move, so they wouldn't remain as
> mergeable pages after mremap. Could there be a scenario where this breaking mechanism
> is bypassed, or am I missing a subtlety in the sequence of operations?

I'd completely forgotten that patch by now!  But it's dealing with a
different issue; and note how it's intentionally leaving MADV_MERGEABLE
on the vma itself, just using MADV_UNMERGEABLE (with &dummy) as an
interface to CoW the KSM pages at that time, letting them be remerged after.

The sequence in my testcase was:

boot with mem=1G
echo 1 >/sys/kernel/mm/ksm/run
base = mmap(NULL, 3*PAGE_SIZE, PROT_READ|PROT_WRITE,
		MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
madvise(base, 3*PAGE_SIZE, MADV_MERGEABLE);
madvise(base, 3*PAGE_SIZE, MADV_DONTFORK); /* in case system() used */
memset(base, 0x77, 2*PAGE_SIZE);
sleep(1); /* I think not required */
mremap(base + PAGE_SIZE, PAGE_SIZE, PAGE_SIZE,
	MREMAP_MAYMOVE|MREMAP_FIXED, base + 2*PAGE_SIZE);
base2 = mmap(NULL, 512K, PROT_READ|PROT_WRITE,
		MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
madvise(base2, 512K, MADV_DONTFORK); /* in case system() used */
memset(base2, 0x77, 512K);
print pages_shared pages_sharing /* 1 1 expected, 1 1 seen */
run something to mmap 1G anon, touch all, touch again, exit 
print pages_shared pages_sharing /* 0 0 expected, 1 1 seen */
exit

Those base2 lines were a late addition, to get the test without mremap
showing 0 0 instead of 1 1 at the end; just as I had to apply that
pte_mkold-without-folio_mark_accessed patch to the kernel's mm/ksm.c.

Originally I was checking the testcase's /proc/pid/smaps manually
before exit; then found printing pages_shared pages_sharing easier.

Hugh

