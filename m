Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4CE9CA9EBB
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 02:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89E126B008A; Fri,  9 Oct 2026 22:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853686B008C; Fri,  9 Oct 2026 22:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766696B0095; Fri,  9 Oct 2026 22:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48AEB6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 22:28:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6F2640726
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:28:24 +0000 (UTC)
X-FDA: 85305132528.16.D33FF7D
Received: from mta0.migadu.com (out-37.mta0.migadu.com [91.218.175.37])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8F41E1C0005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:28:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sL10LDRK;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.37 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791599303;
	b=VNCee7hdMbrJz7dnxujMH+cxFJEV4AtOhPPU2h4L25p0Ct6oUT5/yUIQz7tp9mflUA5icG
	gRfqg5whrOPWZF/ILBcxwAKAuff0wC3fiXi4dV5krsK+Mmd3OCCUAohQQmkQ4wXjXtF3kH
	h+6aaxT5GlJzwcd45QG4tHnQTGaiWLo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sL10LDRK;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.37 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791599303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X1iCmf+DztuofC3HQ3EbJguh8N7md3mHD7lnU7/7Q0E=;
	b=cq51+p5jRCuHVZ1VvDSDuZOnXDwXzFUD9EJKPScixQhlCHOxKu109lsEL7JDyQsvRpntaU
	Bp8cgXyK0EtJWc+G1bUYIwnZSYqxlTD9TgrVlZdrCl2yBDTQpsChbNVPLYW2YqXnwS7R1V
	oED8jT5Z8J1OE4TxpAJJgKOB8Oi/BRE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=urJSlmWLmOnQ+/BmKriYgMubc8WR+Lejmxapcnw2+94=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791599299; v=1; x=1792204099;
 b=sL10LDRKcHejZyQIyETDMoBzjubpk1/6dYH5dPLw5KgpbvatKglQIRv6K4R3xnzuo0SZ57Ov
 O2LKuM9SPJFAHS5b0l7Q62x5TwddqJDG2i128vL0Y/66XPqfRQIdTbZqoEoDVgprF16lqrFWLch
 S+MpROm9Em3sZ9458WNUrAhg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9ec6e0e12739ee80;
	Sat, 10 Oct 2026 02:28:19 +0000
X-Mizu-Trace-ID: 9ec6e0e12739ee80
X-Migadu-Flow: FLOW_OUT
Message-ID: <0d2f9386-fe3f-4714-8204-9d6c710ac09d@linux.dev>
Date: Sat, 10 Oct 2026 10:28:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: don't discard lazyfree THPs at PMD level
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: stable@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Harry Yoo <harry@kernel.org>, Kyle Zeng <kylebot@openai.com>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
References: <20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3p77i9fp3xize6fh93fcxnsm9rshhmqt
X-Rspamd-Queue-Id: 8F41E1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791599302-92062
X-HE-Meta: U2FsdGVkX18637YIIb3v+ibblxHIBQ8BzYExwqS9bbM6auh7tNWaX4y2Wic1SNEyq2yBU1ae/CLmLT+CQuzVoOnN/3rc/LfI4N0QIgT2omrZXwVpFLlO5BHYGHzesq4dZKWz4K/ZA1gHwhc5Sgnm1Rd59MR6h+CPhjueHeP61bwrusEIqKNLkJDDEGpP7juQq9iABa+fP2RupsNvkZ/f0lYR9u/AqVJHddfWAPyLdlcfuLUbh74ET0Rj/iseXqiA/Zy+6k71DyVqQKJw8JNw6Urn6vpe74iE7Enu4PzSqZt428H1Ng3wTsV686roqhLUSPLJ0WFlrWGALqN77w3N2KsvPXq+31+XVc2fLaLZy76xTzTtG6A5rudyMXqxAV97Ll0FRSvnwRgn65HZ18w8zfvxCQnzPQTm19av5Rgs74fO81tb+ZZTzrHDTy3quoDa3CLhg8FpApbcUSTd4i1Y/IEu5CXHhKIH2xxfqSAkRcSTccNFQ1AY32vJCC5BQftO59F/zxJhSEW0jX54UZRJiErCDpewh4/1DCXOc9f9uRUBvT6SlhRDbSlBmZIutODJRmvVNcjRRoQOkmT7Xrf16vZeeT93HVC5dZPKt1AEgmgyOT4pp1kYnYUMnKgdDEuUDgx6Q0EezkNj905MkQloF9gT4IT6aEOFYzKAu+Dd77T0i77dRCYlFGO8NP6Kfa8QWO1lhNDJBWWEcdrgCHu+/8ElkAtyA54Hb1reZMuLvclL3M4+83okV2f8+WyplIZjxUNsk6XhU9A/jiiAdunGGuVPdI91P4XRKUUIvYY3MMSlDNTSnWtvTxvc4Yy99N4M29MlJq0rmh48nek5PLQw+insB5Jkv6gYh3uh9R18wbnlu/qsGsQUHTv0xpjtRwCd4ZZzAGXJIsQHnFNIeSnSjSBUEP5ZdyVARs6oYaCZBykjmBFbyyJc0dijM7RbJOQxrd23pRN8tNNDihc4VZZ
 rPNpHjrc
 ZEPwDskmSZxJM7uzDO7PYjsVYZ9OaFNWijxfYG1d/h6Tli9Tss8kclL1het9kNBvwd+IGcWkBCyLKYqCbh1N5Zr3d4B1qP6+Nnkw3tvRcOhC3H5k56KwVCZuMpd6nfG0dg1/fxj3mgC+nW3FrBytyxtYHusAr0GcLdt16rVYo4+8RoLENSQ0H6//BUiuOraZaZL6o1W9IVASWBx6l9KStMdfDGAMCh9KzHQXsBkPNG/cmSOSVX9MviND1Tf5sbCOl8KLRcu+uaD32EfsIbCQWK7pEwfOJdE7YiyLQzPj846NuECn1kVpBOho6mgFgH2gsnvwT3IixQqyuf7JoIbo9ANl5WcmqKSSQkSuN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/10 10:08, Zi Yan wrote:
> __discard_anon_folio_pmd_locked() clears a lazyfree THP PMD before it knows
> whether the folio can be discarded, and restores it if the folio was
> redirtied or has extra references. A concurrent munmap() or
> MREMAP_DONTUNMAP skips the temporary none PMD and unlinks the VMA from its
> anon_vma, so the folio stays mapped after the anon_vma is freed and a later
> rmap walk uses the freed anon_vma.
> 
> Using an invalidated PMD instead of a cleared one requires additional arch
> code fixes. Instead, disable the PMD level discard of lazyfree THPs, as
> before commit 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during
> shrink_folio_list()").
> 
> Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shrink_folio_list()")
> Reported-by: Kyle Zeng <kylebot@openai.com>
> Closes: https://lore.kernel.org/r/20261009165214.40212-2-kylebot@openai.com
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

