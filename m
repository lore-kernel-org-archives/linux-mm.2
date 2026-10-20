Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6BE606A327
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 07:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=QpsDNKnL
Received: by kanga.kvack.org (Postfix)
	id 817EA6B012F; Tue, 20 Oct 2026 03:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8246B0131; Tue, 20 Oct 2026 03:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE646B0133; Tue, 20 Oct 2026 03:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1FB6B012F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:47:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D69B216094F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:47:14 +0000 (UTC)
X-FDA: 85342223988.04.709E89F
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf03.hostedemail.com (Postfix) with ESMTP id 662CA20005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:47:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=QpsDNKnL;
	spf=pass (imf03.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792482433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trYzjDokCMDLNCP43C8CigBtVifE7/eaaedTzK6la4E=;
	b=gv9XHnYLq3mkxQ1c3bXcawlrPdjewNuCRxUFtgs1cvaUwogs5BAQT682YMyLZ1o39K7JAq
	o95sKdc+clilAg29hEW1M4JWoYUnNVnnx6AwriEiYhXaQ2eePfdZ4Xt3u8edls+NfFxLvO
	ZgtdT66GfozZdUP/8XliitpU0rFDlQY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792482433;
	b=Qfbtu4QHeqABvYZdxSQc8goUVRRwCKm1Rb29LFLLaRQw7Z+28sQJ/6BwldkODxY6mUGDg8
	4g8IxG1fEn3kWRv9Z4V26/f41hqHQMSns+Za2cq68ygu3zfe4Qjo/9Gqx0NpsE89EpSxjD
	8C5Mb6N7me3T954RVACuquXy1WZkt2k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=QpsDNKnL;
	spf=pass (imf03.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792482426; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=trYzjDokCMDLNCP43C8CigBtVifE7/eaaedTzK6la4E=;
 b=QpsDNKnLDpbaKF+XEQb6inm+69+cYd0DSS0wITGcHb97StDYsFzHx77HHZAoxm52y0SRWB
 t9uWCQ56FYzxC1fpMU9ur5AEuqlrz9ZJ9u8AoC82PTn3lshVXDeosVENgucuXAD3aCFqW0
 FqBE+wB8Jor6sr8JlqQtKMmmXuOw4UZ49jRrMVEEEoKqNS3jCl0JNGT4IZf02ibRmzry5R
 ZZCEILDkoSDPfpf5tUphkRU0czK9D9WLFyWKPVbewljT6Lg7tzBXUud5mG8ystmQYKX1bQ
 ieHJkxXYW8+4e6an4+PsFI/oek5Y2DLrHysp2opNgIwhI5e9afUlAMACXIbvtA==
Cc: "Qi Zheng" <qi.zheng@linux.dev>, <osalvador@suse.de>, 
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
In-Reply-To: <1eff2f1a-b7bc-4541-82f0-9836d0a5db5c@kernel.org>
Content-Transfer-Encoding: 7bit
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com> <FA455F0C-0A46-4B5B-AB50-E9968001D2C9@linux.dev> <4a7ad39d-fee6-4390-beff-d40ecf49cbdc@bytedance.com> <BEADD50D-94AA-4B05-B9AD-136E37247FDD@linux.dev> <988249c7-abf0-4f4f-9386-27e835a4d2de@gmail.com> <EE02C2AF-E4BD-4854-B235-928842456253@linux.dev> <1385f5a1-b842-45e6-8986-fec4123037f1@gmail.com> <1eff2f1a-b7bc-4541-82f0-9836d0a5db5c@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	"Muchun Song" <muchun.song@linux.dev>
Subject: Re: [PATCH 0/5] mm: hugetlb: add CMA support for PMD-sized page
Date: Tue, 20 Oct 2026 15:46:49 +0800
Message-Id: <76a568ec-a23f-4a8b-ba14-e5a40083e1e4@bytedance.com>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26ad71c79+a9a4e7+kvack.org+zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 662CA20005
X-Stat-Signature: tawszw6qstbj8dp4bbyq7scgnmrehg3d
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792482432-338933
X-HE-Meta: U2FsdGVkX1+UHrAWQoplvA3AUBpUYpu2C485sqyMlwrBznhyknSmk0GJ7/qvMJ4OucSReEsclS1jIeSTZVpYCTf3wez3j5NoWcZKulsG32FOgr2mIXjdnjjDfEW8mrw9mkF3zOQl4Xg8TwUMfgF6e5QL7JayTaEA6oTI1Pvg7BxtLUyM9a7pauq1pWWKKDfxJX5zcNAPppw7giRG6IKqW+dkZJlb666LrXNyVwbVH40CAS8m6PPhy6Gq71En9evEr27wIW6BoXW4gowg+uubrJl02fUQ5SchzcXRIC9HrIgj46ZAA+ipafdM8FM8JEIiti0rr3ADzDFHJOtNRuo9HPWH8du3vtj2PXCbpsDz7n/fs7Ckrzsmz84jpOiJZLoCROu4bp6prQupbVvRF+kmgGIKTObQGgxCDq6Hq1PSMl/G2my/IwuS2RNVqbdQvQDrgiE1BPWLDwdpK8xFYNB57ZeXIoqFl6jFkIHiFV4OhDLJlqdhQvXOi8Je8GJXo1nJMs2CFaYMD/hF0uYaZLCyB8buIVsLtkm04wKTMOfvzEV49KJSE8rwZdU1t/2T7Tg7Orep4QqfXLvhkbmpjElQoKKpx3sC2q7MGzLVd81QuWxoH6YNdGmgrtFYhxPjgYFtZTZXoRSZ4xE2EVlfCbmg7/hUvq4MszgVmmA1WnKtZ1YGHpn2woMUZfxO1Vd7hJ1Y4nub0nQxhPiFuJ0oyqnuF8b0O0+IjojDvJ+Dhe8UCA0YIgoBlRMJv4EmL1i0P2S9FH3sfr5GFMyOIiGDBJwsftU3/ULaDZuQYehyoy0dlOuGe0r/tzpZ5og1eSbB/RhA1REs1moqmFeH7rDJuv1BADjnvj6PoowNnHL+MFELJVQh6tJwfz34bhhYdy54bxJzs99uZgdBjfnysAhbs9Ugjf3nUOa7bxaJjTkTURBX2tTwkNcxgrLlgGVfvw4/9MEHKj56786PCRdDibx537M
 RYQcqo1U
 p6dUQss4Og68jlLS4W19GkfFT6j9c7FiXK5NTg9ZqHD/DFzupTIp/gDeObNnX4Xl8Pd/A6/4+vXA82xo8AMImmCf1Vl6STlYIkbU6yOg8bXpXOtPGM7zqQMGCn/c5n7qrllCJsVc6wi6mtfCit5OH+hEULiVVnCpWv8hBR9uLdcznla+ZR07/5a4vDAvEyYBvnjKK7KthNrncJhr+wfOejM4CJC6ANP81mONDdGMpdusvY/+ZYIVJWmCqiOiHLYg8ISmPXgcdF92jZlVR0gg4WNEPJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/19/26 8:18 PM, David Hildenbrand (Arm) wrote:
> On 10/19/26 11:17, Jose A. Perez de Azpillaga wrote:
>> On 10/19/26 10:43 AM, Muchun Song wrote:
>>>
>>>
>>>>
>>>>
>>>> wouldn't a shared pool still be sized and aligned for 1G? then the 2M
>>>> headroom stays a multiple of 1G and the 1G-aligned reservation can still
>>>> fail, which is what the series is trying to avoid.
>>>
>>> If we decide to use a shared pool, I think the current alignment strategy
>>> should be adapted as well, it should be changed to align with the minimal
>>> acquirement, like 2M.
>>>
>>> For example, if a user reserves 1G+2M through hugetlb_cma, then the memory
>>> reserved by the pool is also 1G+2M, except that the starting address needs
>>> to be aligned to the largest gigantic page (1G). Therefore, this pool is
>>> suitable for both 1GB and 2MB allocation. The only problem I see with a
>>> shared pool is that it may not support mixed-use scenarios very well.
>>>
>>> What do you think?
>>
>> makes sense to me. existing hugetlb_cma= users with WM pages would get
>> mixed use without asking for it though.
> 
> Yeah, my intuition tells me that having 1 allocation size per CMA area might be
> cleaner.

Agree.

> 
> Assume you allocate 512 2 MiB hugetlb folios. You'd think that you would then be
> able to allocate 1 GiB hugetlb folio less. But that's not guaranteed, as CMA
> might just fallback to other areas fairly easily.
> 
> If someone wants to convert from 1 GiB to 512 x 2MiB, I think the demotion
> interface allows for that.

For this series, I'd like to use a separate CMA pool for the newly
supported PMD-sized pages, while keeping the existing sharing among
gigantic sizes unchanged.

If there are no objections, I'll update v2.

Thanks,
Qi


