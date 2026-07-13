Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34AC1C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1616B009F; Mon, 13 Jul 2026 05:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272A36B00A0; Mon, 13 Jul 2026 05:38:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164506B00A2; Mon, 13 Jul 2026 05:38:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1A7A6B009F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:38:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68051C739D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:38:20 +0000 (UTC)
X-FDA: 84983252760.20.6E107E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id BC8FF1A0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:38:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wp5DhGVJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783935498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GpIWDL0FgH5lEtbQIWAV66P0Vbrd9mYJbhObPbGXVGU=;
	b=T6DCKyMgApoCCIrUxCj7e2Basa5MG+ozgQu15cFJA8e8cUk7AQphZAkcsUXoNDAFvrscVM
	tRZU2PDMBel0ER4Un5lszLZugyOMHXcuzg1rBAbNKKUBO/TC413Sr/lcupjmwMgT0gfNvm
	CktRPzizF6KZw9GKNq2HyuIUgFmS7F8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wp5DhGVJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783935498;
	b=qS1mFpzZGjNxYCJSMJvQJiqUfrLnjdknJGWDU5te600RNYUuq5MwQ1+2LZnl7py6fK0jXs
	s3Da0QmwQk2fxCikkunIR6fbtAA+hVGkiz4vBFt0N+3k+z8kS+EsTC8ESCKHbCKZSBNhAC
	A+3YaRu82ryd7XaBM2+O6KVe5qAaP3U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57373600AA;
	Mon, 13 Jul 2026 09:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150881F000E9;
	Mon, 13 Jul 2026 09:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783935498;
	bh=GpIWDL0FgH5lEtbQIWAV66P0Vbrd9mYJbhObPbGXVGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Wp5DhGVJo+ej9UpS+M+sWk5WRdlmWHGOMylZaVoBIGrprFmVh9e/Yx8agLZf6sXBb
	 l6BUgExWTQ2ZDKWfXJiV98ivQ2BTv1hGuW3vBV+xyTMNZkM7INYACfflZ76LRX16Zg
	 pcsuSdN7CRftaus7t5v8+IouTmPE/0uwoxcRQeTyx+/W/yaAEbGA1w77wPKazyi1eq
	 VrR+nPAZTyBj0BwmmRqkQT7kpq90Br66it2oOI9IYV+F26VGYXGzF6e8IZNV0NUfi3
	 mcwYL7NP/d5SyCC1h8I5KUNueeOtAnBYhbPUsfJn7ZMnHeAIlPd0smlpe0TeGHJcsc
	 uVm5kPsjsBCAQ==
Message-ID: <63c1b697-5c18-482b-8128-0ad172f9ecf6@kernel.org>
Date: Mon, 13 Jul 2026 11:38:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Fix memleak in migration benchmark
To: Hongfu Li <lihongfu@kylinos.cn>, Lorenzo Stoakes <ljs@kernel.org>
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 hongfu.li@linux.dev
References: <20260708103705.840679-1-lihongfu@kylinos.cn>
 <alHxLNTQFJlb3cLV@lucifer> <1c0644c0-36e4-454b-adf0-47845036b39d@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1c0644c0-36e4-454b-adf0-47845036b39d@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: od1gyrppfnyum1dm6bndw7rqozakmw7f
X-Rspamd-Queue-Id: BC8FF1A0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783935498-89715
X-HE-Meta: U2FsdGVkX1+Xt2cgSYH2EwwiJmBkJUThH9nxaQ3obNYQDDSa56+hnSVaf92LAH7FaOB/8PaNktVwHJSTseI216xmwV7KZSQORZ6fYZES3WdN/b/XvP+ZMp7tD1qdDB2fvnSztWNP7au7+zJIALkgmYv5YLqBZY4Iu2sjHaSJ+hXc5ZSIG4EZxQTR5EVDAn9G7asmz0ueUUKb5IC029sxtDYvjKKk6GTix4HMg+CPmf0g8QjQXulWMihkxiFxm9URn0y6FZ8lRReDinJKRgTDY03nSRVHigAJUzeeMyJvwv4AZIHgesft1+FpRUm3bg0S0FJ5hCwFjWygDF6QZ/Bc6sG28Rj4TSf34KCx5U8l8+qM4JlTyWGa9fCjtiHr5Yjn3Po4yh9D6Xk8WtzkAhv4CGtFgStRJYBIee2ZSDeDO/f+u6zxwus9qkRECfDZTvdXGqFNkcYU1Q5ooZK+JZlsXXTJlfRzMzTiYpT3w91npXKSqS0BbYDTxMDojLrvv97O75J70lVGAe8YL1EX2KfA+p9BR3brYPcqRP+Fbpi+XGROdkU9am/XYDAW6WMCu0Hk5LLKm+hy4qY9ddRyHNqFAEeJmiOXkAhHDNFGW23yYdDUVjVS4UHeJISWhZTvSsv7vhxOEHs0rRUBLkrqPCyNt9Bz7fN6bBN1JFzbxUhpcBlI1p0zuwpqQb6mfI+VpjPCC3U7ycmElNz4Xna+ZjyuMT343Cmx88tH+vbZ3kTTZkLfjY0Ydn31ApLYeNUhi+JFF+cDUKgF3redf3QU/Y+c0n5mwz8+DIN/BCGiWsgc8gC6a8Y54lOdkbSim/Q7j4ytpa440ok5LTBhkEzfTi0MO9zmDFpUsHc30BcHJBmZDaa9DiVD/astR/KiiAStiLyvLjzewo7b5EasLFTCrDyiN/2V/z2FhX6LQQgvvszrFAebTHWIU3MMcma+JFBt4ud1k1C0OjwhWXEB8G0TO0U
 llJVNmjZ
 2MBFbrwFvMX0SS+cvvZHmjUEpNLUkRd63+IErl8TKFO5YlUUk6/+MToWlO6i5Q2d65amjLLSBG+9NJa4PSEnpjgvhbg3eDpH7y/srAoOHoQI56eobrpT2zUhuGj1qPuris2Z3pdHDGw71RpvBOyTZ85YaUhEuw8T9G877zR77I2dyO1UbIByno4U4pXM9kSYgySK+/K4YATx2xDbR28uRVWPvkMwXQNEgeFRmnZqMDwFro8rNJbmjMkmK+NKiUhb5TW0M28SowIscHRvnPowc2GftAAaQ9mDP5p3K5XQQNqercU7BnrVm3W6oLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 10:07, Hongfu Li wrote:
> Hi, Lorenzo
> 
> On 7/11/26 3:31 PM, Lorenzo Stoakes wrote:
>> On Wed, Jul 08, 2026 at 06:37:05PM +0800, Hongfu Li wrote:
>>> Several early return paths in run_migration_benchmark() skip
>>> hmm_buffer_free(), leaking the buffer. Replace with a single cleanup
>>> label.
>>>
>>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>> LGTM. With the Fixes tag added as requested by David, feel free to add:
>>
>> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> 
> 
> Thank you for your review.
> 
> As suggested by David, I have added the Fixes tag in v2. The patch
> has now been applied to the mm-new branch. 
> 
> Since the patch has already been merged into the public branch, I am
> unable to modify the commit message to add your Reviewed-by tag 
> after merging. However, I truly appreciate your review.

If it's not in mm-stable / mm-hotfixes-stable or upstream, Andrew can always
modify the commit (which I assume he will do) or you can resend.

So far this patch seems to only be in mm-new ... which is far, far away from
upstream.

-- 
Cheers,

David

