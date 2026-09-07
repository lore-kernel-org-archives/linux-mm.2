Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47F91C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B766B0098; Mon,  7 Sep 2026 10:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524C26B0099; Mon,  7 Sep 2026 10:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ECDB6B00A3; Mon,  7 Sep 2026 10:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1DC466B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:36:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABC5CA01BA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:36:23 +0000 (UTC)
X-FDA: 85187216646.06.DE97F28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1820D100003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:36:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kwZ4Y3EA;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788791782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3Kg5n837DJ3J6t9BGAhbWn48bBIjiawWgKaQGRPoBU=;
	b=KxPvOJXGhIDJLjLIforrM/fOc8aqTBY/WYOYPgr+ZUpgHuF3CE925IT0QljdbvD0YgzAKF
	WmPimAr8LwApy8vuQP33kuffAGYnVoMVhU22to4ScQygVBB3fwS9heU3snBIJP7J0n52/L
	bJDtXs0g+EZWBxeKjTx6wsSNfD0cLwA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788791782;
	b=z1ULM/4T4IN/b2vdHI6DLzHiDPzv8YeBXyrPUkzxcykTOC4nDGPM9bwcy9uYO5oGm2mDpM
	Y+RW4hIlGPTlhoHVuDCHt4S0JMo4rX6F7UzDvwaQX0xizjkp5UOSQGng15g/qhyjHY9qh9
	H9gJTobNqaQQItdUxdqr9EcP7baKNyQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kwZ4Y3EA;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8818D60AB5;
	Mon,  7 Sep 2026 14:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0641F00A3D;
	Mon,  7 Sep 2026 14:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788791781;
	bh=P3Kg5n837DJ3J6t9BGAhbWn48bBIjiawWgKaQGRPoBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kwZ4Y3EAFDceBci5/+JDost4FCO6v6ExEQloPZiqRWJa6DrOpq59BDlANcRZ5W9Da
	 0YkGiIrhMIM0Y4oA3bJVAPkVAkMh2ZDVas7JYI4vB/gxTsPFEuUMoap5+zn8l201ss
	 vIrebluu5TiTYiThICUXUVwuBhTr2+8j6uG17pIcaC1Lj4tVaIfDE0cv0ER0HX98uz
	 BePxSlC+haHMQiO2On7vvkPHUFeyRxeSZw75yBTaFsekJcP5eIqD1cV86KrTa3gu2b
	 J4NCub9aTVDwfl0AlDdoa8TdACemyKWz1brmqYF2P1K9hN4ToS6wnUkW4CYRGUNcuN
	 N3/1cVUgAH0IQ==
Date: Mon, 7 Sep 2026 17:36:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, usama.arif@linux.dev, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, liam@infradead.org,
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, kas@kernel.org,
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	peterz@infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
Message-ID: <ap7L2UEriz6DJfif@kernel.org>
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
 <apk8ZRr6do_YAlzf@kernel.org>
 <CA+qSx6wqd5VSR=9yarFFmyN1SyvLJqEHpA7BwmzuxNQTHbS=Xg@mail.gmail.com>
 <ap05ue1pq3TgHOS6@kernel.org>
 <CA+qSx6y=OaMsvTKUbPP2DOan3Ym6c8L5z60512-tCYeUjLZz3w@mail.gmail.com>
 <ap5Tqu5yswJrj5UM@kernel.org>
 <69db9546-d14d-4107-96b7-30963292c2bd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69db9546-d14d-4107-96b7-30963292c2bd@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1820D100003
X-Stat-Signature: cjef5xihq9jkppbb1aaajmwyb6gybcwc
X-HE-Tag: 1788791781-90163
X-HE-Meta: U2FsdGVkX1+MNJ+xYLkfNJTHPm5l/aSjkQdYqdVmBpGGHi/EmmTRm5Eal8z34vIQ33YwCm4NGRzXPjPJU8J0q5aqOfOUM+/MXXUkHZ5Ja28cuT44d5buD6Z2SnZBIfGYmaemrrKxt0nmkM8H7uJOC+A2Gmsk9f2OrZmtvEM0BBNrAPIzT5uG+hQ1FiEoGeIEdq5Uuqu1v/0vwt6IOelqtXXs9N+mdHelgRHGhHt+0dlQjkyLpcxiWEhNW1SKRJff+7y0jxRaIqLcP0N8wBn8QwcTgMvcSgSz8+p/fO2RVnTGPR2efaKcBd2w4Rt+KVfRNsqJFjOv1BxAD5WTOKtd6owHwAx9HHRltguLXNuoee9xtf6KpPuXZs9sMmswqEWOHUaTC2K3yw/s/ONEkuSSX8lN/zev8YgXzNeVEuW19XCOJ9k8HtI9bYY1N6BFHAE8w+hd1LoYQYrN/uqSOtJMXN4Sb9Axnbbw+U5COPDaJX0n43qZXypr3B8OESToFpzuTPAMa/Nvzsu0C/P4Igqe2W2FCXMqC2m6n2qDiuJkP7wuDjD2Wg140BIbVcRLTgvnz3uEJ7tQNE5ChHe0N04PKXq9xVr1ZbPD64t9FyBj/pNPU0zO0p0Ito3rPIu5iGHNCny+Ruh3VrVZuZ2Yz12Qhl6a7IbU0r2ZgYtdqL0ot6zYT8x+fTuPgluZ5ByisfVVK5Jsq7HltQ3KHway9ofHVsBqiKUb5LXeD9o0j+R04VOj/a7kZZL18/62te6Wrb3izNpIeLcRZJNMmm+1yuvD63W1/mCt5gkiJ6bJ1Ut/bDPW2MvCMo/Mh2e531UkBLFjujBwkJy1mQcCnhf+77YQHliWUkYDjn31U4ksG9UDaBOCYvnAWqdhm0F1+xl4FT5zFRHxNVFrAY5979heIYPbVS9R4JdT89GZscRn9QojbzsxqQY9bnOedw4Lj3lIA3de1Au5fQd42BEDsIeYYco
 U23b7Rxh
 /6dvi/olzOSrfMAbNtx2hLShKA9omy/FK2l9ZceMejIuvjm/QLvGpKCtET6F+4TDHXTnEJ+uvhwYLhxGQ/oK3MW2BXs+LUzRWZ52d2KAZ0Ts3BUwX16lX8+qgCRY3NANarJq4CbvU4MVwPt+yjF6EoGtzeoJu7etI2UsqzIIl1G67VSEHtDO0g90HCyciif7NAAKJyRqxqqOAU/uXtyBQS2F6pCv+F8Divw28QbQ9hhsZYMV52wn1PFMggpS+MtRcue20Yjj4w7OXLgLsnrh7LoR3Js9fFzx/W/QGzkvEX30HO3Xz19abzM3yjAmu5DqIcTUT+bGBOzp1nH1bwsk7aLNCvFhPqQ03kol9eBuXk9Exdxc5vLgId9LDsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 01:18:42PM +0200, David Hildenbrand (Arm) wrote:
> On 9/7/26 08:03, Mike Rapoport wrote:
> > Hi Xueyuan,
> > 
> > On Mon, Sep 07, 2026 at 09:11:14AM +0800, Xueyuan Chen wrote:
> >> On Sun, Sep 6, 2026 at 6:00 PM Mike Rapoport <rppt@kernel.org> wrote:
> >>>
> >>>
> >>> I believe this is an historical artifact. change_memory_common() already
> >>> updates the linear map when a vmalloc mapping switches to RO and the system
> >>> supports it.
> >>
> >> On x86, set_memory_ro() does work on direct-map addresses.
> >>
> >>>
> >>> I believe arm64::set_memory_ro() can change the linear map in the general
> >>> case as well as long as can_set_direct_map() is true.
> >>>
> >>
> >> On arm64, I'm reading arch/arm64/mm/pageattr.c, and the linear-map
> >> update in change_memory_common() is only reachable for vmalloc
> >> addresses:
> >>
> >>   set_memory_ro
> >>     change_memory_common
> >>        area = find_vm_area((void *)addr);
> >>        if (!area || ...)
> >>           return -EINVAL;
> >>
> >> So set_memory_ro() on a linear-map address returns -EINVAL on arm64.
> > 
> > And I believe this is an historical artifact rather than necessity. For
> > configurations that allow set_direct_map on arm64, change_memory_common can
> > update direct map too, it just need to be implemented there.
> > 
> 
> Are we sure the other architectures do what we want in their set_memory_ro?

It's a zoo right now :(
Although most of them do.

But we need to sort it out anyway because of increasingly growing demand
for modifications of the kernel page tables.

I started something here:
https://lore.kernel.org/linux-mm/20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org/

Now that x86 CPA is nearly fixed, I can look into the next iteration.

> Having a dedicated set_direct_map_ro() with clear (documented ;)) semantics does
> not sound too crazy to me.

It's not too crazy, no.

Still making arm64 more aligned with x86 and other arches that update the
direct/linear map in the set_memory_ro() seem a good thing on it's own.
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

