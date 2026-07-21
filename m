Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F76EC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 20:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F16B6B007B; Tue, 21 Jul 2026 16:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A2C46B008A; Tue, 21 Jul 2026 16:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB366B008C; Tue, 21 Jul 2026 16:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D38B86B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:36:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 628A61A0266
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:36:40 +0000 (UTC)
X-FDA: 85013942160.02.0F8E04F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9BCF24000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:36:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XLQwPvZ9;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784666198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75nElkeyX/1rftfHH9IMo3FcFB/4yMecwRs8lFAe3OE=;
	b=CC5TjbnOWyNcSMR9buoIzDk7qO43faOylRXShRKXgARIhCXah3InVbR/t0WM0HH47fhM+o
	Gu32+MxV4bmaZYiSQ9Ry7YvsoAuBgBv1sErcpfme9WNL8OriO6fPagu0hpFmkwQDvNEmDJ
	sHivTMKaj8sBpoZUfYc7muiJ6wtB6NM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XLQwPvZ9;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784666198;
	b=pGpFqLoeR6kUd7yDoa+FcPigwzElNE4DzUm6NQ1GWAb2kPiD8GzLPsVrnXL+6UaAHpX0IZ
	z5CPX8XuoxhsPWVJkwqGSAy+bGdS9ON0Jfxf/ZqXozSs8PSCo8f7G8s/tqaRMhxVb78+uL
	a2zZ6Q7uJ/t3f8Y0nrTbQNQVUA2MbXo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F33A3601D9;
	Tue, 21 Jul 2026 20:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9AC1F00A3A;
	Tue, 21 Jul 2026 20:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784666197;
	bh=75nElkeyX/1rftfHH9IMo3FcFB/4yMecwRs8lFAe3OE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XLQwPvZ9xtGdL+DY6bGaWTnkoRGbd9wQqD5w1Arm5TIeVUGypID8HUCBGnz9J8BB0
	 Yo5uCAe6oRTZsXgu4C8V9DsfiA5c8LCvitKVd4cAK1Bd9q5+aNkMoju59xFum2nqUX
	 G4MuLqf+yYanRswvoRSguhUqrQUGE3l3AbfRt5AA=
Date: Tue, 21 Jul 2026 13:36:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Deacon <will@kernel.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, ljs@kernel.org,
 david@kernel.org, liam@infradead.org, Dev Jain <dev.jain@arm.com>,
 catalin.marinas@arm.com, kernel-team@android.com, riel@surriel.com,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, apopple@nvidia.com, rcampbell@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, ak@linux.intel.com, nao.horiguchi@gmail.com,
 mel@csn.ul.ie, j-nomura@ce.jp.nec.com, pfalcato@suse.de, tglx@kernel.org,
 dave.hansen@intel.com, jpoimboe@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
Subject: Re: [PATCH v3 0/6] Fix incorrect access of hugetlb pte entries
Message-Id: <20260721133636.df1a012df895054d3fd34a2e@linux-foundation.org>
In-Reply-To: <178464737122.1305746.12295190523058911270.b4-ty@kernel.org>
References: <20260703114202.365553-1-dev.jain@arm.com>
	<178464737122.1305746.12295190523058911270.b4-ty@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9BCF24000A
X-Stat-Signature: abby87temrz5wjgau9m1drcwn3iqa76g
X-HE-Tag: 1784666198-297859
X-HE-Meta: U2FsdGVkX19ccOyKvIiENaXnjuC2eBSGIX+CqiBvMac5C9CBol5rFKQGkBKpEzhwcgA+vGXh99ozf6SXlqUaUcWUy1tNg7eJb1d5OEGxLfYxZEJ06wneuN2MYPUuLtDU2nEjdKIqWvMiRA624f++RKbIx0DYUtuSvO0c7nA4urxFn2hxJbROsNfO5iEpqdQnIN3VBFld9cNsEKE6eFvxazz2kIg1GOgjABv+FFlEzQQGzQnO62fZq+jgWcJciWFWqt0LLVQI0Kex5qvs5RKg9WnHNyB/oA4CxUoRFg7u4vmJCPsjML1lJAiYvCAvBbfKhlfkuOlsP+cBGYbwPmlyL2TJ4VYuUSqin9wkOITpV6ota3xaT7XTHhmxDiycoRt/cDzPRFSDdlXXragDFjcdwQmfF/mCqBQAFxW0uMjNxIXWRhteNjTyEkyXaULmMM0uEeApbA5N0s1g6v7G8GH4nO1P2Z/4ZQH2p6qOZT7y7ipq9ugVYHadQkLn8qQmxmawV64Lfw8I6IdFjZyyHDYtF3OdjuXBGo25ERBbtSKh4Hwqx3cuoj6LjCyba5lyHA3XXIQYGhVZR5IBvk2/D3pxh1cS9EDC7ZJ6KzIEGAwpH5xaynLFhAHfUPIQMGG85FDMSCVX8oXn5sd4mrwR5VcZRNxmqlROZCQSO1QVPjFQVmfM261sb/0BMvwJsj5xsK127kridqAZotqrM/enfUOsGgm5Jwuc5SduuyU8pBdo+CUp6GtU5Gw0rbmpAyr3CUgiEXW5AS1ga5KuKN/bXcfv7iEuC2v6CA9O3oKauHnWniYhs0BYKdCm1+Uh+O94JVV+lU7MOg1E7m1xGpuLXOLCnLN4QzrgUtSEp2Fdog3X58D8DpNTHDS1MnGsUh8tb5S435wcoseNXiK+p32sqqmW1deHhMvvsYuUx+pctG2vIWltJsJSwbzWeMsiIZO7cLsfHgFuXo2VVRx96GUgVYi
 yPc/7UNh
 UZDprPkg2NJdVZFfYEkAfvT3nK8j6mh4L9AGS2kgW9I6Ar8ev9uuC7v2EkpF9OGWk7anx96IxDWkDJ8PdWFMe8gC3qGX/CBs0WLuMJ2v7FV2iY5c8tmWiBNrJ2AmhS75zp1tuCcqRER1yZ8lsCHClQa0gsg/D8USb1he33vs/wbfvfgjeso2/8bDvGVfPxTcumhtvv6B/A/Tn5x/nGGHTJYxpkwRnInqDp0gT4iyCaQu1/mDpTc1wSPGWcVeyTLij640x0OXDBW3q54Ju8/jrGcCg47HSMSDYX7MwWivVOpwwbGop6bI3ijHjjT4qwglPmiPpl8l4IhLL0RZ/i21yVXavhiwuK8oKc4N9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 18:18:38 +0100 Will Deacon <will@kernel.org> wrote:

> On Fri, 03 Jul 2026 11:41:53 +0000, Dev Jain wrote:
> > There are various places which use ptep_get() to get the pte entry
> > corresponding to a hugetlb folio. Some arches (like s390) have special
> > handling to compute the pteval, so they provide huge_ptep_get(). Use this
> > helper consistently.
> > 
> > Additionally, some code paths may provide huge_ptep_get with an unaligned
> > address. This is a problem on arm64 (I checked other arches and it looks
> > fine for them), which is fixed in patch 1. The fix is made to be
> > to huge_ptep_get() - that is wider churn and we can do that later.
> > 
> > [...]
> 
> Applied first patch to arm64 (for-next/fixes), thanks!
> 
> [1/6] arm64: make huge_ptep_get handled unaligned addresses
>       https://git.kernel.org/arm64/c/9175a8c7cfe88
> 
> I'm hoping Andrew can drop this from the mm tree to avoid a duplicate,
> but I didn't hear back yet and I'd like to land the fix.

I can redo Dev's series to omit [1/6].  The patches apply that way, but
there might be build-time or runtime issues running the other patches
without [1/6] present, haven't looked.

Also, review indicates that the changelog requires updating
(https://lore.kernel.org/all/2b9d60a2-8698-46b0-80ae-b8747a66a85b@kernel.org/)
and I believe that Dev plans to do that.

IOW, it would be better to carry this in mm.git with your ack.

Do you plan to upstream this in 7.2-rcX?  If so then I can hang onto
this patch until it appears in mainline.  Or something.

