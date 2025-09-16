Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A1E1CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 06:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9078E000C; Tue, 16 Sep 2025 02:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698B08E0001; Tue, 16 Sep 2025 02:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587E08E000C; Tue, 16 Sep 2025 02:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 474F88E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:21:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9876813BD8A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:21:41 +0000 (UTC)
X-FDA: 83894117202.24.DC2DF80
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F8B7140002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:21:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Seh2nPtJ;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758003699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5O2cdufxu/AELj6UvYc8/DQeqBxhvUUJJsLRMzLjvpQ=;
	b=2RAqv9roDIndb/qSHiVFueaJP4mZyvnEowOu68Lw63K9nZmZa09KLLkB9cQOTAAwiLxvM5
	iGJm3NUCdrCZzmEx1DjEua2OEfwPpGGbmbLxIVyW6nFAhV9wu5j8St3TwrX3nSj1wm1oC7
	VTIsWQehH6UeGJoHdHZYY5dKJPJVsAo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758003699; a=rsa-sha256;
	cv=none;
	b=X9VHGUo5gpenvy1mq6CEyKCUJDxy91iTt0a4LKVK/2PDVbpwHsdhmDQ6etRJRd3Zz42Pq5
	TkToxxAucQlbUXItb8dcYEG8mjtg/jYWRsYFGOXr6EkcSTcOB0iuszJuiI/30HojA6VbyX
	5oXyyrjoi4RX8tZQGREj/YPSX3jYoAo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Seh2nPtJ;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <a0ec4014-384b-4c04-bf0b-777c989eabcb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758003697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5O2cdufxu/AELj6UvYc8/DQeqBxhvUUJJsLRMzLjvpQ=;
	b=Seh2nPtJk5tjHCOFVUre7hDuVjTO3aRsfIaSULTWr44UoY7sHbVGCOXPV2M04onztQZg31
	8aRG70vfaPmxLj0M/oC/NuWjSEuGRzfOWWhjw7MfJuINp3TXMG1rq2dQk/1mhr0cjR+T/S
	jRmorKRDUbX9/tmYmPyaAl6DETdO1nc=
Date: Tue, 16 Sep 2025 14:21:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/3] mm/khugepaged: skip unsuitable VMAs earlier in
 khugepaged_scan_mm_slot()
Content-Language: en-US
To: Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-2-lance.yang@linux.dev>
 <bc86d5f7-5b23-14fb-0365-b47f5a6f13c9@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <bc86d5f7-5b23-14fb-0365-b47f5a6f13c9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F8B7140002
X-Stat-Signature: g1f3q37qhzmtbhpwhzxmwmcgnybo5oeq
X-Rspam-User: 
X-HE-Tag: 1758003699-708763
X-HE-Meta: U2FsdGVkX18kpgXjRPPIZhNAy5uiI+cSYsVNS1e0auh5672CNfRwOCZEQyoicfkpKIqXAlXhRy9mcI9jGm3Ny2PvBOQF4oO3s7bTlFqeN+KLEnQzgxtfU6zMfT5S/x2C9EeVVGJ5blRPaOWbHdOPmNLW3J5ZKAVliA8PoQLYgow2/3b+JK1UHKgBVveW0iWTpEdm8kBhVQM/ygLFlCFC4xnu0nBFbZ+I7Rz5jFF+vrDscVp/qqXnSE8eslEbo7oYXA11iARYAdtn5pyWgfwN7iylw3vrXS5a+zhS7CT6Z/yWXEc92uR+nQ6kBwrAcuAnHPctF2tSdVFcfCrE6Czq2aGysLU7qE8tXrJ/R9pziXIVWv+/PB28nH+Dj3R/4/dOTot+rHSUTIzvIQIHEA7dEVEvCPpwl1bOD1JULaUmkrtoXaISZ9t4vk6/eYllAcAU7jtOOdZWCdBv7ygFRbw57UyacLhU/XySCAK5R61TWdW8P7YQ29cUp2JqiZJMFCJlIx2s06bFe77IXIDmH62I/KFl5B4TyFZYgPxJnIoCUMSi43+seV7h5PYg6g2BqOge50+UkMkWpB2iAFaGQy77OmA47RnSkP4WDR6rb5wSTNLcWrtLlsH5qaND6YyDu+CfuCIvtA8FkYuefYHC8OCh4Fs2ThMG7AEBNebeyrGmlkFEIBKhh6Qg4htxy9oFavnXPKU4HoQ1OE5GtU6f6sCW9lSf1tHbYlczOUDQKiPCw2Ld6PbSRvIinbPHp97JvxYMDkRHpj/23Fdffd/jm+NJYHLx7L0JSdLg44ERl+XSLS++n1EuxHKvtfavnVQut9QPhja3rANd2OrCVTYx6udsz3vqRD3/ixUt52Rq1OpPBWZvSRisYlgknth628CDh8ZOk0y+VNiyTVXNm1BdVgifEvlqCKoqHESBlAg716byhXIaEk5yif2w0kb1Uh3rr2Fuj3t3FFAu5/OMsKMVTPd
 EUJBUroX
 zbaG2gwRKM1sD6qu2HMSVVOHnZ6Hzho/O9XuQZb/3aoNYsfk1Zjbr+epAQqfCtXOPwuub3EiRyfPgYknsE9zRezJUIqx0dqGeKV277czTVdXjOQqVJXXy+0+j2kK0OVolsFD3zB/Jet1OSiZn1PDim7g06cL0X2YIGbnUOq3lYHeCTdUNRshUxx14O9WQ5NLAc6ztqCbgl7dseq/ayLtsn/PDmiw9NarOV4KNgkoG+uLaNHab2blkz3okp8u/3vITcTFC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hugh,

Thanks for taking a look and for raising this important point!

On 2025/9/16 13:32, Hugh Dickins wrote:
> On Sun, 14 Sep 2025, Lance Yang wrote:
> 
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Let's skip unsuitable VMAs early in the khugepaged scan; specifically,
>> mlocked VMAs should not be touched.
> 
> Why?  That's a change in behaviour, isn't it?
> 
> I'm aware that hugepage collapse on an mlocked VMA can insert a fault
> latency, not universally welcome; but I've not seen discussion, let
> alone agreement, that current behaviour should be changed.
> Somewhere in yet-to-be-read mail?  Please give us a link.
> 
> Hugh

You're right, this is indeed a change in behaviour. But it's specifically
for khugepaged.

Users of mlock() expect low and predictable latency. THP collapse is a
heavy operation that introduces exactly the kind of unpredictable delays
they want to avoid. It has to unmap PTEs, copy data from the small folios
to a new THP, and then remap the THP back to the PMD ;)

IMO, that change is acceptable because THP is generally transparent to
users, and khugepaged does not guarantee when THP collapse or split will
happen.

Well, we don't have a discussion on that, just something I noticed.

Thanks,
Lance



