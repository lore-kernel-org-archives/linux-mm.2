Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DAC8FF885A
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 06:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBEC96B0088; Fri,  1 May 2026 02:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F526B008A; Fri,  1 May 2026 02:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12756B008C; Fri,  1 May 2026 02:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3FA6B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 02:49:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 349461C0405
	for <linux-mm@kvack.org>; Fri,  1 May 2026 06:49:55 +0000 (UTC)
X-FDA: 84717925950.28.867C294
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49603160009
	for <linux-mm@kvack.org>; Fri,  1 May 2026 06:49:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ffn2Pqie;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777618193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZBY4/4/8iCDI6nYC6l9X5OWQq39koUCCdyr9GPoyKU=;
	b=iEStmhaGeYMQ/gllB2mUiYbGdgRsevXjoSxwgENGu14jzEbVBrZKF7r857EUNFDpWif0Vk
	jMI/LtruBykg7IWXot0/3Nl4kAEfyWmV4bUlcqfhctYNPNb1B0Tfm8/8QmOazJ2rvl1+MC
	/JHj3bdHxfzzpetcFfNfVTYSHJR3AvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777618193; a=rsa-sha256;
	cv=none;
	b=aTEi4L8OlKWSWoKUq6ntCtSVovmJRjUmydxCcSfzUarhVA5xKhKidNbOUCj5L4Dw/IrQ1q
	b1jv/6xpiF6uJdAKOApFzikZD8jov96Arbfg2rbMaFbvSBdrUT/BbERcgm0Wp7KfGBwG+C
	6qGlJjzjdifNCkyTuOy4LvmcKWOKPpQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ffn2Pqie;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F3954039E;
	Fri,  1 May 2026 06:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB845C2BCB7;
	Fri,  1 May 2026 06:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777618191;
	bh=z8eCVsUhlLmlW30jiO7Aj4uHtxm18V1RXfcy7kxXkqk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ffn2PqieHHbE0tk28vxpJZVuU4TSyBI1pd1/MA9JSjCt+PJ+fav5VX9GBKU16RaxL
	 ukvGJn6YhKFWo6NwbSxacntzhWcRUufOAnOOJ4XoZZV0PQ9mbwqHbFUIs2QaM27+dy
	 oGatIbtTnYdtBRUIEqQnoKZIROVMphC8u7VBPzeXrYSkyKCQVo1731WA2zeKIM0eNw
	 3zPYAL0Lh1iJvIHnwZIFAoJNIeDxYIVoQ22V/nmcHV/vL3Tg5d3frQaq9ceuG9eitD
	 wbKpd1lpyJYRsrOZMvKdU802jT20NhMPxTJjyb4zhST/NCNMSig3rbpDnb14vEOSR0
	 o1SblmQooOyWQ==
Message-ID: <761b47b6-c2f1-4fef-bfab-48ee1d0bbe47@kernel.org>
Date: Fri, 1 May 2026 08:49:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] mm/damon: introduce DAMOS failed region quota
 charge ratio
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Brendan Higgins <brendan.higgins@linux.dev>,
 David Gow <davidgow@davidgow.net>, Jonathan Corbet <corbet@lwn.net>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, kunit-dev@googlegroups.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260501015604.83041-1-sj@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260501015604.83041-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 49603160009
X-Stat-Signature: oyp1g55ssb6srsmz99s6cq44ptg884px
X-Rspam-User: 
X-HE-Tag: 1777618193-123380
X-HE-Meta: U2FsdGVkX1/RsgD8XYyurxsP/GJXdbP0UT0AuB2ITahUuF1Ql1g6S7X6LJe3OAqByXfBidm5o6gjACk44loyjqrQ74uf6G+LEi4mNbpBgZZX4HiE78iUjllDcfWrl+clUnp/ORLW5LMypKqCw6gk8ZyRV99Ts2XU74CfR8fY76QhRJuwQ7NcAVgQyXR+Mo3o2ek0/4F0SqwWnmgUB441aMgGqgFtb2VObFohMNx21VI+Q9xWwaFweF78k3pR9lFv/W5YoAtMIxG2VsrDpskPlNVNWu5Aw+l8DsPkM0igtFSqMAjGNn/8cbr0UwFsZ/0c1n8PaQeJr2veQB+7c03sY5zP/SalWmCMe+4Vzz2jdztrOIefTm0+SGqZl6ClQRszWdl+DsmMTLurk7NZSezqVFAdGop60kjFs3UJDd2J/oL1n9rOFRO3D3WCwvMd6D6H5aDepafu3CUgumQ9Kx0Sc/0QH5pWMwBB76PM/MGhje4RV3oj+KOcRhUARa1G9A5BjJEfpv6oEI3oOVaEmo0OnoegnaqC7WgVQ7r2rqN4UL2eIiIF1o8GATigSc3yxzOGTK42OBhH2hqBVsBHx/JwgtE2s8Gcc1FZJYH+CHgHtPz2F4y2vMhsr0Ey7RL3r/8UhxrkDsIfW42G973Spz7zF86INME1Nn+lrToJaQ+XqI5c8GKTdZHRvSVAXoj6vAU3NcfhplM4o1eYvvbPMfg+kBcMdXDgKcQcN+Mb4gStxsxWFWCHJbgAnVkN50n0R2uNx0HCYiwhb2tXr8srKTZ1YRZKRgIYX9ItMfUAT0R5mZj9D/c7KUl6CS33uirSseg+ck/vBwW4igkpeAEnofNpGJt03xHHAw/KZNEHRBuAW3pHtwENT+c+dfz6Z/qgz15+6tZDe5zr10F9Gx9vvCvgXAw61uh/gUaFqdoVQqbS2HFLgajj2JYNB+Mx6vTjezjDLOHHZH5pgBeBOvc+b/l
 PRAy3dgx
 pGuBe0t8pxFgKrXo5DPFoKLP7A1vRcqO4a7WJ67Xh205ynW61iSlePq9E8JJuNXDRuv84o+99P2YG8dXyyMGY4HDtxZ0jLAZAuNOIqjDdUjBqgbN7J2gq1QYeqV4PT9vVRI122lDm24n4LOSG74dc8J3+hzkhwUhBI6CT/CGLLaMMxPwGKo/IiTA8CBvxEa4ZbpP1iEx+bcFes0jbgmzCcSSlfRxZnKZfluH9VDRwGuXp0Iy9McpYXWE/Ck2a4zAyuXjR25Vl4szp6b53jfC62KSAVQIlDmH17j5ZRRFhlBky92u/j3sF7UYqE3SLZCIgZrYbmrvKKbA0bg0tEKTbruF2lSEV1vqHmGwzneuU7AZI84HfHkguQ8vW/BLoqs8sFkF962MVflangnyaxrdwgrzv4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/26 03:56, SeongJae Park wrote:
> On Tue, 28 Apr 2026 08:24:24 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
>> Hello Andrew,
>>
>> On Tue, 28 Apr 2026 07:48:37 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>>
>>>
>>> Add, thanks.
>>>
>>> As mentioned provately, Sashiko claims to have found things which it
>>> didn't see in the RFC.
>>>
>>> 	https://sashiko.dev/#/patchset/20260428013402.115171-1-sj@kernel.org
>>
>> TL; DR: I find no blocker for this patch series from the Sashiko reviews.
>>
>> Now sashiko replies its reviews for DAMON patches to authors and
>> damon@lists.linux.dev.  So I replied [1,2,3] my review of the reviews to those
>> on damon@lists.linux.dev mailing list.  As I mentioned on the TL;DR, I find no
>> blocker for this series.
>>
>> And I think you didn't see those because those are sent to only authors and
>> damon@lists.linux.dev.
>>
>> I nowadays reply-all to original recipients only if Sashiko found a blocker.  I
>> will also add short notice for non-RFC patches if Sashiko found zero issue.
> 
> ... Now I think the short notice is only redundant and silly, as the full
> review is available on damon@ list and the one who primarily interested in
> (Andrew) understands that.  I feel like the short-notice reply-all only
> increase unnecessary traffic and my redundant typing.  I will not do the short
> notice broadcasting, unless someone makes a diffeernt voice.

For Damon Andrew should for now just trust your ACKs. If it has your ACK, it's
good to go.

In the future, I expect you would pick up the patches yourself, which is where
you as the component maintainer would look for any blockers.

So for Damon patches I don't think we need the AI review notices from Andrew.

-- 
Cheers,

David

