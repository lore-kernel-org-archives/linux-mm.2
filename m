Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9639BCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0732B6B00B2; Wed, 20 May 2026 02:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26756B00B3; Wed, 20 May 2026 02:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED426B00B4; Wed, 20 May 2026 02:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB5636B00B2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:41:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C66B1A0195
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:41:08 +0000 (UTC)
X-FDA: 84786851016.23.4706A0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B27F8140003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:41:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="C4/u22s+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779259266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5aueIOO+B8O30BYhpyvaYfeaMnbRo9gO1SHqe+cDh4=;
	b=MDz9ioWPmz0MTGwrzfptin59IQ4mDYl+CnacoYYH1hxLso76StKUkXjbnBhi4zcG2y8Z/u
	2iIyX6yJSNfjt4kXXiFIcqnJkJet9ayg9zfIbIHWCQ4QLlJ1KvKFieyty8yMhu69TxBggy
	9kmcrjlHpXJBsaUHIvIIf90HiFt3wZk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779259266; a=rsa-sha256;
	cv=none;
	b=eqxXshiUDbS8PcqsYa7i+bvTXNpH85T1fDV+TawSAb9ZwSmCIZ17JI0gtzZpJ9wSFj1bfh
	K64uMSZYKb80Ot0Hxn8adLnkfLcbUn3EZJ2IQ3A29/tiECsQqAq2+y4dicWMBim4DFKvIv
	qeQt9CoTRFk7Mz0PdxLYHtFiugCbb/Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="C4/u22s+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 301AD60129;
	Wed, 20 May 2026 06:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F7B1F000E9;
	Wed, 20 May 2026 06:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779259265;
	bh=t5aueIOO+B8O30BYhpyvaYfeaMnbRo9gO1SHqe+cDh4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C4/u22s+iJFOhW8pgObb0RVr2N7kMXeXpEl4lUPTaIi091OJPb//FrxSwEW27oqJa
	 kHiNRf/Fno0ECc+vLbk9XIKE7v1l2xgxVIW6MYYN9c3yd7o0RNEKKuRfuWyUKy2Rzg
	 ESBM8FWYeBZfp6Q38Q5WDpZQT2oLGFKfHNbplVVcUVDadUdZUnOA6HwKpFTVcCbvrJ
	 1CjqJoM0qw6+qu81E3bEMdSsAs1Mh4XVWuULqgZKfURJ8u2WSq0XuJ9z5KTCAYKWDQ
	 U8GqsjzlJvCXZnnU2EN4MCjgJXecH/V4L/Df2WBqNISK/mPa4l1BOkTJk63H6ZJPpQ
	 3miapLDvgPAbg==
Message-ID: <98578d1a-a1fa-4d4b-91ee-921cf07dd09d@kernel.org>
Date: Wed, 20 May 2026 15:41:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] memcg: uint16_t for nr_bytes in obj_stock_pcp
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
 <20260520053123.2709959-3-shakeel.butt@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260520053123.2709959-3-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B27F8140003
X-Rspamd-Server: rspam04
X-Stat-Signature: 4a3383wj3w3o9u6pb1hcej7o6rge4bxg
X-HE-Tag: 1779259266-770786
X-HE-Meta: U2FsdGVkX1/RCE+NW/F667GfeXikwm2FjNM5oCyGqXkvOLbeIvxGyPCZDtb6z0NjW2jAG660VH9sJ4EsKQoGr0L4mlkq9nujP0pnxhFIuIvkwjlnmhm+pUgx4JmADHHq/MFVnxrmvmZvpxBMi+Qi9YdVe9ttWHP2W3e6384+fJltBFERhoy7DoF0lBBK9ntZ5PZh2sZ8zNn/AEJ3l/I3Rs0MoDY7x1DuuaJN4SrOtOwKkTdkOEK/k7iDtV3MgzqeInM6tcqkIr4EU05X/q8qXo2mndwdxW7MvrjfkyQeqFHsM4sSwWezU+emUDNteGVY8t7HGxJVm4a/aMl+nZih4VTGhIE893wUF7OoWRtNzesl/Dbae4EgeTBpCcLvuLAaMLtuBpaaMdBwoY3vxF+BCLQEwAcQw4tc0mUsgIDFf2z43fthVU5KlyFmK8kUf1RmsnpUWAbi4QXDbOxH7VSj3I0d5ljouAzEPBF7kWiFxRljnHWfCOrF5orHoYAG25t9rYNnP0dRgvXUhCUeQB7d/7cg0YpzsPr14/JCo5CNKHEvKXQHIWHqnJYzmoLzDETQe0EJOge4KOTY86a/ZsvDTUfsWx3Me3gRtmXs6AJYBSrBaXDUkptzqZVbxhNemmWdwfuh4ji2pbocTpopT1Zbvj0TRk6D4K/bqSMa1HINXNQu3zykkFvjdVoed5VfVRtYpX6FlaSq8mDB4ABqFBaWgHM7Kl0O8bWTxVgQYjhUlyCYUl9E4KhgUcafj8f9t5rlNeh9ecmOI4jS1c/5PB5Nbj1LBoyCb2BAbuCj+eabgkgZIxgQls5hmC1O1z9zuxZDnxPlww7EibwdTSBApGOH7TDgXCBjJukgqqg2EeldWky2ZS7PYRRftn+Jl839R7R0+huPzpZ9FBgMG2Q9DI8kN/v2NLcW1SagnJczzjLNmtFGl76sAXgiF+iVEPO86l9qSKpvKarTP4k+4UlnN66
 H4oe8Qtl
 3AjSnrAJwiV3NrBEKGq/Lln2PsTktGrDr9Ul+qUw1TSFJFOALlSVu7K4bJi1RTljqFxjbeaxGNL7SeLBsbyRPMmGlA9/usCmVCYipdsJ5+p+yTyB1MXmjKMd9zVrTPDUtbVDr2zEYinm5tefRaf6yhnKhqgGesiAeRqiIbujF7WyClWAr7/miYXSJsR2CT3rvf8qyfyEEd8o7UwgvcCAuYIGlh5LI6w+jTEKay7wAEmZ4CBLVx5kfCsxGo5rmfTjFE60VKWF4/cewRWabbCNwVmZA3DoD8OUpD0QaGBnGGqrCxa3McX/KLj/G5IkKshozlZnwKq73QEf7fn4dj4Qnn3xfql8JRZA1/7GIPL8OJ0crGBZCCQBh2NLEbc50v7zp+xq3Fz+nuwv/5b6xbyjzpGHDRtgntrLG8j7bjOHoZJGp6pE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/20/26 2:31 PM, Shakeel Butt wrote:
> Currently struct obj_stock_pcp stores nr_bytes in an 'unsigned int'
> which is 4 bytes on 64-bit machines. Switch the field to uint16_t to
> shrink the per-CPU cache.
> 
> The kernel supports PAGE_SIZE_4KB, _8KB, _16KB, _32KB, _64KB and
> _256KB (see HAVE_PAGE_SIZE_* in arch/Kconfig). After the
> PAGE_SIZE-aligned flush in __refill_obj_stock(), the sub-page
> remainder fits in uint16_t up through 64KiB pages where PAGE_SIZE - 1
> == U16_MAX, but on 256KiB pages PAGE_SIZE - 1 == 0x3FFFF exceeds
> U16_MAX. The accumulator also needs to stay within uint16_t between
> page-aligned flushes on 64KiB pages where PAGE_SIZE itself is
> U16_MAX + 1.
> 
> Accumulate the new total in an 'unsigned int' local, then:
> 
>    1. Flush whenever the accumulator would hit U16_MAX. Together with
>       the existing allow_uncharge flush at PAGE_SIZE, this keeps the
>       uint16_t safe on PAGE_SIZE <= 64KiB.
> 
>    2. On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on hexagon and
>       powerpc 44x), push any sub-page remainder above U16_MAX into
>       objcg->nr_charged_bytes via atomic_add before storing back, so
>       the store cannot silently truncate. The PAGE_SHIFT > 16 guard
>       folds the branch out at compile time on smaller page sizes.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Tested-by: kernel test robot <oliver.sang@intel.com>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon


