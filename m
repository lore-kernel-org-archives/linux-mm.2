Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 344C6C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6286B0095; Thu, 10 Sep 2026 05:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6EC6B0098; Thu, 10 Sep 2026 05:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC926B0099; Thu, 10 Sep 2026 05:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC8D26B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:38:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA4C412045D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:38:58 +0000 (UTC)
X-FDA: 85197353556.20.4ACB3D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3FF2C40007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:38:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YXcqGxKO;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789033137;
	b=vcu+XZQnjanUDd9NJEFtLPKcYW0U5y3T3QXa28Nukk6XfO/nbhAJDq9UznkWQCVg98lMkj
	b/cNs0RramCrhNp9hYMSxwl3LnrDSPSnHwJ4sAFP1wbFBFaCzCwYBej3+BzkZJnprlBz1Q
	1ju5wphJ0DRU2shsi/MIqGZqOxcrIVU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YXcqGxKO;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789033137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtpC6H1ULndfbNFZ13FE1fDkMZRvAQ+CwTcYhQHI6N8=;
	b=M49D9de1PRJjvMLxIhge9gb59sGvZKBhIal7Iyb29nLMeNz/qi9a04xHHJX+vHQzxJW//Y
	A1bPP9RSLki2voUFYXl7Uu0RMXH6b32BLvEgoG2n0jhF2mKTh/FAm+I5UUfvK33lz++9uX
	8ARJdpjbf10p2+R2Bkb6pM1vLzi9V/s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF123600CB;
	Thu, 10 Sep 2026 09:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108A11F000FF;
	Thu, 10 Sep 2026 09:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789033136;
	bh=rtpC6H1ULndfbNFZ13FE1fDkMZRvAQ+CwTcYhQHI6N8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YXcqGxKOJIL+3bo3p+fRwNz7JFxdbXFMSdnakPLo8wv5JmHZgITn/QHj4u9aRMv7l
	 yMlZfDi7aDzzNvcYRbN5fPlZwwsrG1NU0qDpi9wx36duR5dsh/bigu3bK2rTS19Zuy
	 +L0ciI8kAGkmXGKxrOTkB8d9ZSxHTGyV4XjPDn9jQgPxjJDUU7SUrDqSqP31Vx7b7A
	 JUY8BFS/7CFd24Nw8ESRCRDCGe6FwleGixN7bUzYOVY8W2j0EqZpPFfRAPGFwkyD5Q
	 /kF0un6VhVjZOFuZye9arimqlF6VO+6ttZ2SMxbVRTWkVK6bq75eowcsRTsYnWXP70
	 tDwrdkAGLsyAg==
Message-ID: <707b26ac-7f73-430a-a473-cd3409c4505c@kernel.org>
Date: Thu, 10 Sep 2026 11:38:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 0/3] lib: add synthetic MM benchmarks
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>
References: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com>
 <cec6f48d-8857-49d6-a24d-b072482bf0c8@kernel.org>
 <c76621a4-cc8c-b6a7-732f-633d372477ff@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c76621a4-cc8c-b6a7-732f-633d372477ff@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3FF2C40007
X-Rspam-User: 
X-Stat-Signature: x8btbgrzzmsrysmia7imo3m4qx4wus6x
X-HE-Tag: 1789033137-358171
X-HE-Meta: U2FsdGVkX1+ZH1ggj1weIOHaYjJJvvjbHEwe+Jyf22f3c1EsoRttCpAp4qpwAqdVbS9x4FPrqDrhLIglLuOu5f8bdjGKzHSfHCKyWQx0QdwoOC1g7C5Wtefa7zJb6s3/U2bVL5P9MrpRkQxbnbHpkDsvEt/hmzH8UUtpfReO7H8/4nKTXO9/WeZg/VD1SOMxAP80aT5wamWfICLg3uSRB14Kut6rteXUz5aVyWk2SAB8TsowVRsGo9Ijf6QGIGUV6OTW1wWqWQJpXgo1YAAtlZDB4v2Iz2dx1EANaRIAdq4gnrZq5/F3l6N+yBZoqPmOXr+fu3gy/XNcyMTy++1HUCsm8gBFW9PL656Tht0RHWOMJdSYaULOcMpIJ7Sw/S3yJqde8b3HXwhAa5zHY5NtnN6cnIs/sKB/h7pqDMtPaOZrON1V8F839az0i37u1TtY3qjRo1BHiVc0XD2wXpoI8NB2NqW1mkqm8DXIWYy5V3pjHp0dyk4jUhd4NfSHgCAUb43Cx5kZtnlKVeonDJd8gmY//WSZGJqaeWVSTLxYr/DPttbv93KEbe9PlREty/m7T64ChStJ7zo1Xw4IIOu1gRVv9B7bx6DbA2KByB93IR2xTcFWmkQ0TXq28ZTAefJoX59R5krRCRURHyg8eR/N1IcLy0IXkKCWXGkVmo2V9ANN1XobFYQQsHrIJBPeSLk9BwZW9aTaW/OuNSIk+kvqRF9bN5PA09deORN/pxgkIA7MiuX6wK3p21D3ddM7o6ow/JigoeAohCAMmqAoQxOilGp0MoTtc6+x95qN47UQy5xAA0+k69LdO4GqR8ZJyVJdmgbhmiuTyRTf4C3mHjtmtu4oGAhCj6iurEX/+JhuhCzFWf6kb5Ejv/J7VC+Vz1wLU0PO+Km2nBBTNtJqwIqAO3fQ881VHT72FZ0m9y4dFcMDsSaB2pVKbAGKBijaiE5vB6ODfnFOiVkv7YAgniB
 Z3DwFfIV
 1TIzAmTfSaLTjbL8fnLEG55gxzrYfVNb8AFbIzlp3BupgfSOzaLtlN5zOPzEt5Bu7tgTQ0DIp+Mzjf/uf9rcdJgXQilGdFv/5HZEd4M3OTYB2EfTjHx22qPYl65yNTgAFuX+0O3NvGNgT6ofuzxl2VFgh2LTPkJeGljKCn6wxlMhPbGav3nQLmXwWUQUwjyknQy2WqCyIIngjknpdCkM9OFNgkwYo73/0gnNLtsrytyb8OqXH4V96ht7ZKkoNBWuCXs05
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 00:19, David Rientjes wrote:
> On Fri, 31 Jul 2026, David Hildenbrand (Arm) wrote:
> 
>> On 7/31/26 06:26, David Rientjes wrote:
>>> A blast to the past :)
>>>
>>
>> :)
>>
>>> We've been carrying these synthetic benchmarks in our kernel tree since 
>>> 2009 because they've been helpful to identify regressions in hot paths, as 
>>> well as quantifying any improvements that have been made for new changes.  
>>> Hopefully they can be useful to others as well.
>>>
>>> The synthetic benchmarks are run by loading the module at runtime.  The 
>>> modprobe will fail intentionally so that the module gets insta-unloaded.  
>>> The test results are emitted to the kernel log.
>>
>>
>> Ideally we'd have an easy way to actually use them in autoamtic tests.
>>
>> E.g., loading fails -> error, loading works -> no error (and unload)
>>
>>>
>>> Proposed with permission from Christoph.
>>> ---
>>>  lib/Kconfig.debug    |  30 ++++
>>>  lib/Makefile         |   3 +
>>>  lib/test_pagealloc.c | 337 ++++++++++++++++++++++++++++++++++++++
>>>  lib/test_slab.c      | 375 +++++++++++++++++++++++++++++++++++++++++++
>>>  lib/test_vmstat.c    |  95 +++++++++++
>>>  5 files changed, 840 insertions(+)
>>>  create mode 100644 lib/test_pagealloc.c
>>>  create mode 100644 lib/test_slab.c
>>>  create mode 100644 lib/test_vmstat.c
>>
>> This looks similar to tools/testing/selftests/mm/test_vmalloc.sh and friends,
>> that can actually be executed as part of our selftests and do a modprobe.
>>
>> Can we have similar scripts to execute them?
>>
> 
> Thanks for looking at these tests!
> 
> Good call, I agree these could be loaded with a wrapper similar to 
> test_vmalloc.sh.
> 
> All three of these tests don't take module parameters (yet?) so right now 
> this wrapper would just do the equivalent of check_test_requirements(), 
> usage(), and run_test() where we'd pass in a single option for now, 
> "performance".
> 
>> But I also wonder if these test modules could be placed then in
>> tools/testing/selftests/mm/ instead (or some subdirectory for test modules).
>>
> 
> I thought about the same and just followed what appears to be the standard 
> convention (like test_vmalloc above) for lib/ for now.  If they should all 
> be moved under tools/ somewhere, perhaps we handle that in a separate 
> series?

Yes. lib/ is just absolutely the wrong place for that.

Maybe lib/tests/mm

But then, I wonder if they could just be somewhere in tests/ directly ...

Anyhow, it was also raised whether some of these could be written as kunit
tests. It's been a long time since I worked on these, so just mentioning it.

-- 
Cheers,

David

