Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B5AAED7B96
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84BEB6B0088; Tue, 14 Apr 2026 06:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823456B008A; Tue, 14 Apr 2026 06:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737C76B0092; Tue, 14 Apr 2026 06:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 620A86B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:02:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20420E3871
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:02:06 +0000 (UTC)
X-FDA: 84656720652.08.BEDD529
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4812D4000A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:02:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cTkwm5Ak;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776160924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30LCvQz0sz4GC0ta6lANaxX7E73TEk9I11XK5FIwcWI=;
	b=4WbYLOlsMiAUenpX9UhKZyqsUNH1LXJ3UEx3I3e1L5sfopR22w5NykXc54Cia1dqdMR8SQ
	pGGB5WXitKza3VGgC5NkCp9CXi5Mr6a+VtBs3H6Od1aa7q1OgaM0JtVTSmdD8YlqWIZfcK
	Cb/lIgpO2gefeaU8RMg1Rh/k9zTHUZE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776160924; a=rsa-sha256;
	cv=none;
	b=4I8FhHcPy5X8B78w+FAIFsnPFi663hnZT7n795iVLUMqNIwHfcSX4HdX8U8QdLGVEPwuaR
	tWJreJmdHoQRRrNzjK9s/U6hMrMhqdcnFlKi7fMacg2hOtuMNzmxYT+iFIOX/xK84y4vg0
	kDW6HlAeOCqzOuqqP/OCq9HFDeRPGNc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cTkwm5Ak;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A711160018;
	Tue, 14 Apr 2026 10:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B43BC19425;
	Tue, 14 Apr 2026 10:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776160923;
	bh=hEMZcMIZS6WzhX6ssC5Ou6uax693W51NviYWtwo2rRA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cTkwm5AkJiR1Kcxa/iRawXT6asz/JNVsLox7hbLmD9WpHY7NrEJd0Np2KuvxhcZDz
	 sMaAP+k4X0urnbfFoLZQpcaU4aNgNC0XwfdcCQD+ESiBBIxU+ZvoszTRtcjUI65D8S
	 yrFLpaZnwOKgbWmUofGYDgDBEW2J63ChT28SH9ICE6sUVeQgJ/y3qlXLYHwUIYsiAQ
	 E7TWJseSLHDOHWVwq7qHeySCAlKpIVrSmgG4vBwSHFoD8R6Q67XHPHvoUmZVbL7UCb
	 +kcIQBbMgItyBP0yzr0beiuX9rKIeGi7QmP4ON+0eabVuxDAiL0MuLwp5JsV/gvthf
	 nGppsJGfgIE0w==
Message-ID: <f1cfb1c4-9b7b-40db-9105-570936b61203@kernel.org>
Date: Tue, 14 Apr 2026 12:01:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] selftests/mm: verify droppable mappings cannot be
 locked
To: anthony.yznaga@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
References: <20260409234915.11723-1-anthony.yznaga@oracle.com>
 <20260409234915.11723-3-anthony.yznaga@oracle.com>
 <7a318c3c-7ccb-4f95-a416-19d09f42c97f@kernel.org>
 <38fd3d86-f080-4b3a-a931-8ddae1a420ae@oracle.com>
 <b579517c-e739-4db5-ab0b-4db3d579807c@kernel.org>
 <ae78cbdd-e9b3-4586-b492-89ecffae30fc@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ae78cbdd-e9b3-4586-b492-89ecffae30fc@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: dqgagwz7chnpbzxoqskuknxkxhp11zte
X-Rspamd-Queue-Id: 4812D4000A
X-Rspam-User: 
X-HE-Tag: 1776160924-988338
X-HE-Meta: U2FsdGVkX18uKFe/WjUxXPV+WjBjcQz4291amOBRMS8iKqeAVKCrkPqxvqTwo7Yr7XGu7B5GxxM3BfYaagcYRTwNnQh8lNhAJ1+SLZ2K/ma+shgOfn1SqUieAA5fBVajC8BigpQUVtUOaANooLhpY13lSAx7BoFns89i5yjTmtbetoORKMCF/Q/Azfnbb7zwqDGePxyeuW+87gptvVZcjpijNSsx0hMQInXLlTohAXrvUhsopoz8ctQ7DHYGlyCdNvzFSA9rRJNLhwQQqbbco39W0IyrcOAsyXyKVL2e/tQmYRUrSkEYo1xENnrAp4YIRbSyWHPA5/U2yWjOl1i4bAtgvGd6qTPbk0Ls07XV5/LF2wBnsOynWF/BGMZaIu8Pq5glmes9cHG5f3APyIsCQyXJC7Pj6EjC0gKMOWoT+hQC53xShEOk1M6EB11OU3bkJiIwE28Z5184cnohQ22+zT3OdzUxAQc5ocgbf/crO/Sd7EchdDcnpl2pfCEaFibKVIqPg0WGzJAH2w3cFSaOUPb/C9VkIdT7NNUKh2KY6vaDEeMQJ1SD96AAkm0uIa/B0Wcsi3ezQtqU6v70BwvQOtF1pWVnVWVInKizjzZ19Zmh18VLJzOrDKkf8Qx40yxsY1vYGqrqB6YiYzTKSFxh/viBh0lq/tKsDWbmyvudNC150tDw2Q5uUmo5CcOjrVnnjq3igv3aoaNLfjZOL/v06E+cFitRtWyqWmSvRik1UbUbvGAEBZS+DyvNil1ttbRZtnPEeqw19OHV/6GuqUSu32VtSGZ8HRM9nAPXVr5ZkHjmpzLqGbcDqvzocFMXzXENViGlP4KEVPiPA08WWmdvxYMqXMhPF9hr0NztlILohRYMA2plgZ+6psyiFqJNEs1U/D1BIkuwq0Da2wSIZzy56cdqaLCN/+Z6A1XZpYqgqee9+bYD8bWI+RfgJ/pfZEsNfD227BBKehkIc0KM8Wz
 piY1nWG2
 O/ZPBYpU/0AzCbz/tQ8qg/SygbL63Bf7EwuzYBhyLuOSnkPy4QIN34xd1N2TDAW/XsOn1ACcTWse1sAiXEyexaIYo7Hn6OPxtbX6EukrhuDDkjJnEm0Ovtzh/XjXXEDuDDtnyTs0d/G56pkrCzylljls74z4gzXAsgKeaazlRIEG2CAGUajy1qE235MdPYcETVa0UCjPXebkRjr2oAC3b73lUaYUxdzGg114K0H+YyM/MaPmZTFlZmHloGKqTAVCmg8mdniGaH8vJlzaTxRvnkWroaE+9kLUcG2vVDp66Utgj3J80NCpsbsQCOOxMMtZtehjtPASARfslDrg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 23:54, anthony.yznaga@oracle.com wrote:
> 
> On 4/13/26 12:46 PM, David Hildenbrand (Arm) wrote:
>>> It's correct though mlock2 would also work since it's been in glibc for
>>> several years now. I just matched the existing tests. mlock2_ is a
>>> simple wrapper around syscall in tools/testing/selftests/mm/mlock2.h,
>>> and it was introduced when the mlock2 syscall was introduced. A trailing
>>> rather than a preceding underscore is...unfortunate.
>> Interesting ... and confusing :)
>>
>>>
>>> The intent was to skip the tests if compiled with headers where
>>> MAP_DROPPABLE isn't defined rather than force the value and get EINVAL
>>> because the kernel doesn't know about it. This way EINVAL can be flagged
>>> as a test failure and not skipped since it would likely indicate a test
>>> or kernel bug.
>> Note that the kernel headers you are compiling against don't imply
>> anything about the kernel that is actually running! So the argument
>> regarding EINVAL doesn't really hold.
> 
> Yes, I see that now.
> 
> 
>>
>> But note that we, in general, try to compile against the in-tree headers.
>>
>> See
>>
>> commit 75d60eb30daafb966db0e45f38e4cdeb5e5ed79c
>> Author: Lorenzo Stoakes <ljs@kernel.org>
>> Date:   Mon Oct 28 14:13:30 2024 +0000
>>
>>      tools: testing: update tools UAPI header for mman-common.h
>>
>>      Import the new MADV_GUARD_INSTALL/REMOVE madvise flags.
>>
>> And looking into it, I already see MAP_DROPPABLE there as well, so is
>> any special handling here even needed?
>>
> I'd say no special handling is needed.

Right, so the #ifdef is not required at all.

> If this test is compiled on with
> a kernel that has MAP_DROPPABLE but run on an older kernel without
> MAP_DROPPABLE, should it fail? Or should it interpret the EINVAL as a
> sufficient reason to assume MAP_DROPPABLE is not supported and to skip
> the result? My current thinking is it should fail because the EINVAL
> could have another cause.
Ah, you want to sense for MAP_DROPPABLE support in older kernels.

I guess treating -EINVAL as "not supported on old kernel" is good enough.

Looking at tools/testing/selftests/mm/droppable.c, we seem to not
perform any such checks ... unfortunately.

-- 
Cheers,

David

