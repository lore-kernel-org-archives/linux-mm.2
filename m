Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 050CFCD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381586B0005; Thu, 11 Jun 2026 08:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3321A6B0088; Thu, 11 Jun 2026 08:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248206B008C; Thu, 11 Jun 2026 08:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1760C6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:51:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B1474064A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:51:40 +0000 (UTC)
X-FDA: 84867618360.06.8D22EC0
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id CB2CF160012
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:51:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eesZ0NDn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781182298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9S9SdGtbm1JyTfljX6WLjQs95rf1oKktzDq3rIIBuu0=;
	b=XIXqirXhRPe3d+5WII+ugKZ5VVoYpKXSYubbipr+3fe5fvRlMd2H6Qt246zhzm2Us7fHqr
	uaE6+dTCd0VimaitXI6p05ZxnT1T4DuWnjUeYUyu31Jy9V0MRfai4sNJAYopus5HR8j60c
	nmx9p248yzJfRx/i3qJBy61hmalU53Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eesZ0NDn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781182298;
	b=6ZXuOmZBTxuJ4X16skMSzOH811Uce9lAYV5HsZRCW5uUBrT6xzwALY89lcKBupvAxutm+P
	8yNuvU9o3YtlSZ2QfxVrg2llyv4sMc7ZnbL88FJWvpMUMO4a1q5V2/83r9R6YZY8eJ5yCz
	cgD0K51wsabwj2VOUmr8WZecfLcglkE=
Message-ID: <1a547b9b-dd6a-40fb-8669-3bb307eb05e2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781182291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9S9SdGtbm1JyTfljX6WLjQs95rf1oKktzDq3rIIBuu0=;
	b=eesZ0NDn4arZq1eS4Me+sKBxmY7/1zh2Xohy+gcqQwOvoaQoEOYaxTNVbuV3UrqYxOYMgS
	+wiEuiiDOgD4QpWz/uuqRw3jEL3Lso9r4Qc9VpX9LdZmf0E7EYh7LcKERuNt/hVveKmu5R
	QXn3GY34ZpXtYuPfbBLNl5hnkucIye0=
Date: Thu, 11 Jun 2026 20:50:04 +0800
MIME-Version: 1.0
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero
 folio read-only
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, xueyuan.chen21@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, hpa@zytor.com, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, yang@os.amperecomputing.com, jannh@google.com,
 dave.hansen@intel.com
References: <8c36a91d-288f-4ffb-b2ec-41e3ef789d72@kernel.org>
 <20260611115817.59353-1-lance.yang@linux.dev>
 <d943a03e-bf28-4086-8907-5a24665fb2f5@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <d943a03e-bf28-4086-8907-5a24665fb2f5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CB2CF160012
X-Rspam-User: 
X-Stat-Signature: xy19hiaaprzbjx636qgygi4xu3491djp
X-Rspamd-Server: rspam09
X-HE-Tag: 1781182297-803509
X-HE-Meta: U2FsdGVkX1/jP4z5ugr9HGKhDv7QreJ1gnQKvpYjyNLqnc3btqE09d0tTZxBShTy0+atZdk7ZKizfmmtt7OzoYlUyzgMMcxq7e1sKh+/kroe27EDwM/0wlxDLK3HL0KSN+5AmH1glzgE6qUiReva23h62AkgHXMM/O8twlnBIbTfTa269Gh8921ekJaLRrklsRuwfWcddk58Sf4OEn31NfPhhHacbccpwR8vQte9jF9PzEDhUOMU0PYlkE+qnEYCLfbhE4mjOq85Xx+Ezvn5FdIIVBCGY+LXtVgEiHDXBAYtQb4U4q18uS3vLMGtixKTPe6+WofHXgdSSJTZfZFQoliQ0i7HK5LIj5tS7LfqvzzJsOlh2L88/hqP+LEWzwG8rJLBDc37P10PxkWxq1QaqOmunhEGGo17G0a6PJHRknWXdjcZFEX+3BdUMcT7hqVA4RrhXuukGWdlwkeLdrfA60SwVaafb7xdSgfeSxj6UEQGj2tQwTUzR4iJnpTPOt1DINaf5ev8V6ZlcupUl+HmAYCU9DPKh8J2d8J2wkzV0QJFaExb/V2TCfV66M6NngAVdIzm0KCGGIFBePWO3R9S6o46fOHPEUzusMrBADpty9lizROAtW+QKjzaqam47/Ki8jINGg86msF8HF+DYNLoBTx364RzjWDqOAy0bzV7uKeTowqA9UafR0G+M+fOAimLHnKEdrYcHRIDSUKQs2T9sqvBf1gLnFqvMDdooWz3Hwrx5HmActwLhFqWqWDjzZwDiMSZRoEp0G551HOj1+sByx7UyjX4uoo8bI5mNMwtxQPmUk/vIPD5NNlesFIMntYol335EbFXlZNSkRiYOwrrYSZ3Q7EYtcQGTK8kkjxQDb6rvDHJdG2XzWpew2YC9oVXpkf2he0emjkrUu4jHNSRvUnTJhmE8s0tM4lv9nTVgxGzLtbiQRuU8/nFSVrdJ4kAglpX4kLbBqacBxP/9BU
 srxJOIK7
 wtdHUwkqwxPStE+Dtmt1hFx7+r2fW7biRyJIPENErp6C440CIonAKVC4n5FGwChC9zzkG2NJYecwjvkEPfRBSuAGQaLdu0LEaWapSEIjDewBiu/zZrXB29Q4ZA/ydycwPsCmCe1emp6rQQ/iB/cGNpCpe7niH4sgOJk9h6CtlK1IMvw5B5PTEPzxg2+3jCv5OQUrmK+Sggkn4bwXeWj4nsnd8xoePym46/f0achZ4eVb8ymC7LXTlmjlkcMfefO3+6UqE2HnfKawU0mx1/8Q6lWu/6CLpNjtEcxjse8OaeXZ5GI8JxmPhdciQFB5ARVm09UQ6RjZbHwzMihU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/11 20:21, David Hildenbrand (Arm) wrote:
> On 6/11/26 13:58, Lance Yang wrote:
>>
>> On Thu, Jun 11, 2026 at 01:28:58PM +0200, David Hildenbrand (Arm) wrote:
>>> On 6/10/26 04:15, Lance Yang wrote:
>>>>
>>>>
>>>> Right, this came from the RFC v1 discussion[1]. David preferred a page-
>>>> range helper for possible future non-folio callers, not something folio-
>>>> only.
>>>>
>>>> Of course, we could also add a folio wrapper on top of that if needed :)
>>>
>>> Best to document that as part of the patch description: we don't really expect
>>> to have a lot of read-only folios in the near future (zero page is rather
>>> special; maybe it won't even be a folio in the future).
>>
>> Ah, good to know, thanks. Will spell that out in RFC v3.
>>
>> Maybe something like this?
>>
>> The huge zero page is pretty special case, and maybe it won't even be a
>> folio in the future. Since read-only folios are unlikely to become a
>> common thing, a page-range helper is the cleaner fit.
> 
> Right. And if read-only folios in FSes become a real thing, we can always add
> infrastructure for that.

Got it, that draws the line nicely :P

