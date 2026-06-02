Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAE12CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 09:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2495D6B00A3; Tue,  2 Jun 2026 05:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2219E6B00AC; Tue,  2 Jun 2026 05:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137C36B00AE; Tue,  2 Jun 2026 05:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 011BF6B00A3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:41:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BACAC2ABB
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:41:58 +0000 (UTC)
X-FDA: 84834481116.01.F868F95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id CE6C940010
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:41:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NB4tv7lD;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780393316;
	b=OUYKa136yYa6fzuqlGv6leJalS38Sj1pthTiQx+T4Wstj7XL3tusNI1yJIuKgO7P+DV5BX
	rvkkPOngALFZuOAHUWOZNQiFoPAHH/Py4/uCBxkjcafV8GWeUUL3xLlCQEIgphCwSgpJdy
	xarsCwrpz/BjurJjialuMeNO5Abvvjg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NB4tv7lD;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780393316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vT4GhybZ63q/C77icFjfDw2+SgkthJIdZFmZoFl7XsQ=;
	b=vZIzVudhgelFcq7QikIa6Q1f9U63ylPfiZhOvXwxO7Vn+Mv2PqhWcnhQ7UsTKuzBY/5YHO
	c0dGqKR7zUpBfasw3VygXQ+3Q1WpLmzzV50uWBa1K5I06+n2/LIadxrN6DD+zPhOZpMJoy
	JNwon+sCSy3uqRZhLD+lVUNmJNxK+eQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 317C36001A;
	Tue,  2 Jun 2026 09:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727E01F00893;
	Tue,  2 Jun 2026 09:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780393315;
	bh=vT4GhybZ63q/C77icFjfDw2+SgkthJIdZFmZoFl7XsQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NB4tv7lD0sn2xWMbkfISkEKc9+jTV/l+aDD2meGk9UhivS0/j4YBKNhZDevi7M0Hq
	 qnao6MXfp6z9UH1rB+ftvHDJtJJ2KhlbvD64xsvjyeSeRvoLWGGiAonzpitEYoJjZH
	 NPU4azq1xakAFt8Io5EAj7o1BEiJRy2iNquMic1cAgj/CgQyTBj5ffPr37OxMGy8cv
	 7nLLRmwioFPYLpV8oPN6pYDl7a7SmRyzXZz2f3MdMT7qBcsh8oF1nmqr0t6guwiK55
	 O8pEYPH4wDyKPzpRcgHHm/LE4HY8cavsevtuqm/AjlJZuMzeld5kaVBY9Uo6buYPmq
	 cNS2kxQTNcTTA==
Message-ID: <21732071-14a1-486a-951c-34de97b7c757@kernel.org>
Date: Tue, 2 Jun 2026 11:41:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
To: Miaohe Lin <linmiaohe@huawei.com>, Breno Leitao <leitao@debian.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com,
 Lance Yang <lance.yang@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Liam R. Howlett" <liam@infradead.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-2-9ea0cfa16bb0@debian.org>
 <19f968f5-1289-f573-4406-e5c91dcd8923@huawei.com>
 <e3d023f1-ab6e-4424-b304-55f1294480c3@kernel.org>
 <33ef8821-c809-b7d1-ea77-6e8a07a6e784@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <33ef8821-c809-b7d1-ea77-6e8a07a6e784@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CE6C940010
X-Stat-Signature: 388qbmuja5nownhoxpf836jtkxkhpaym
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780393316-261345
X-HE-Meta: U2FsdGVkX1/8G9DPHT1kUiFsDt0MbRvrq6Wu6OhKbEUCvRlV+cNaYSOyutQjMuU4PfBGc5kQ9aaOdDJe+hOd01PuY3BMiGx4IVBcBCzXqpsuQq4QBLrNtDlS0R4Mdy0G4cZb99bLJrvKkwo/BIyCZM0ryGXcbuuoZ4oy3EUmd5uav6+YtRS3hE2dMqvUIB6/L81pxWHY8r2jGL0YASJqtGzkaqDmScOZSnknn9Mff3rV5af43BkdddtmTaN0p7waUiWqa0QO4Ab9lN4oM/xWPixFI0XG9Ua0FVWWyZ2HtkXRznbZAvxNkYxzzTz0k1H5T/eGPvcDs//xo8EqEK7H30CnKKqG8xZEV2xxPLQdS3ZfBhdosCClO8vKt9MFtSrnEM4cFTc+bAZX2/gNzijT8USp078RsgdB+JNH/aCRZhoJy36J+KdTs6UgkoEoFaVzbdZ4I6ZuRzve04kJ0pqp3ScrKPoJ6S7lDhf3MkOzDlu8lubyckkvTnAPdX/ByuMtH8DhVHckcKgQbatGrVSLhXecIvjlerHAojqz8mrjuPyJ6GFmB6brMc8scwc65NePFdsUFDnLf74kwinbC82EtmwaL6OjxNMfEA7k/mkb0BFzVLWiFPVHFKmTDYRS11PZBkajJFgY2dl0cDx3UmX5dHoVaH6U94CNyLcuhIDzb7FxaaDYjycsaj0SaFjufdqlM070ogGC61qjpEDZKlVK1vPxEz+7XSRTyzaAhpwXzt1Pir7jN4Yu6mYU28jqoY8z/FJqd8vg8Z90sL3HgqOserPUyjyGOW8WrvO8wMts4qGWUShZd2I80bIQwzOtXzX3U25Q02JKysPzK/ug6HJgu0ba4HkLGe1TSJGJXVpWKK2XcwNhCTBZ+I6zpRIk+D9cmZs+55wzgKeSuYfJh5GONXU0XYN7IWQjVKuqYwzAuGoGMT2sqixS2M0466ZQdeeAh1f70M5YNXXGfGKboSe
 zSo5cDM1
 IE2kYIGXm6du8wOGeyh7JFT1aGCplgw04CmU4r+DXM4N9dsy2XD9OCFxUFFIKFum1ZTb3dajqEw6lDlUm0NKBnzIhD+CK8lZGkuwXSQihuiyqIv1FOMkHSNWKH6v5ha0N9bbGBV1GK52jYpqmkEEB02XDkn5v+Yrf+Ojy93hSZv1821eSGJQ8Xej2oqrB77nQROSG6Yfhv5tSM+llST//mfPUFrPz0qdMCkU7YWZUCkXtV0tiRVNcBz5GKmO7yDnAfPSG0IB18qo9g5M70kXnWyAO7Mh1jy1awKuqjMUIuty6aZ6Da6KLd8EZpMhWXzboJP8wVPTL+2SKR+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 05:08, Miaohe Lin wrote:
> On 2026/6/1 21:22, David Hildenbrand (Arm) wrote:
>> On 6/1/26 14:28, Miaohe Lin wrote:
>>>
>>> Thanks for your patch.
>>>
>>>
>>> Once shake_page finds a lightweight range-based way to shrink slab, slab pages could be freed
>>> into buddy and above PageSlab test should be removed then. Maybe add a TODO or XXX here?
>>>
>>>
>>> I'm not sure but is it safe or a common way to test PageReserved, PageSlab,
>>> PageTable and PageLargeKmalloc without extra page refcnt?
>>
>> Checking typed pages in a racy fashion is fine (PageSlab, PageTable,
>> PageLargeKmalloc).
> 
> Got it. Thanks.
> 
>> Checking PageReserved in a racy fashion is fine as well. TESTPAGEFLAG() will
>> allow checking it on compound pages.
> 
> It seems PageReserved is not intended to be set on compound pages. I see there are PF_NO_COMPOUND
> in its definition: PAGEFLAG(Reserved, reserved, PF_NO_COMPOUND).
> 
>>
>> For PageLargeKmalloc, we would want to check the head page, though. The page
>> type is only stored for the head page.
> 
> Maybe we should check the head page for PageSlab and PageTable too? alloc_slab_page only
> set PageSlab on the head page and __pagetable_ctor uses __folio_set_pgtable to set PageTable
> on folio.
> 
>>
>> So maybe we want to lookup the compound head (if any) and perform the type
>> checks against that?
> 
> Maybe we should or we might miss some pages that could have been handled. And
> if compound head is required, should we hold an extra page refcnt to guard against
> possible folio split race?

Races are fine. We might miss some pages, but that can happen on races either way.


I'd just do something like

if (PageReserved(page))
	return true;

head = compound_head(page);
return PageSlab(head) || ...;
	

-- 
Cheers,

David

