Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C614D12691
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 10:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E016B0028; Wed,  3 Dec 2025 05:03:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745DA6B0029; Wed,  3 Dec 2025 05:03:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C096B002F; Wed,  3 Dec 2025 05:03:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 548FD6B0028
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 05:03:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03418132F14
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 10:03:38 +0000 (UTC)
X-FDA: 84177722958.08.7A963A9
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7F33914000F
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 10:03:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=pNkqxamR;
	spf=pass (imf09.hostedemail.com: domain of "prvs=42586a9f2=kalyazin@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=42586a9f2=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764756216;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7odRi39//eUzQHPeI9r1ot7neXJJbQK2cDuxp8n8TI=;
	b=GsbtWlnZCyKJPmDueMnFdRSWBncz9v1cWCteeIi4lUwF/8Xa7TwH2zJFNhSn3jffANGvCl
	rZQ0+jKDidgRlYe9z0kQR3FpH1pLUzsPUT0lwJ5NJVXYbe1z7j82ENba7HUhom2+GsDoFD
	TqOLgg3/KHHkt30oF18tBGgdoO2Iyr0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764756216; a=rsa-sha256;
	cv=none;
	b=7TJjU0WCrZsh4nYjAwhlwMUA6oLzLL1vwL34D8xpor0KA1ZzEa0hacYxs9pW8eD2o9zHyj
	ig2akylpQxK0TsjywU5VE3382jB2KlKsj9LdkrKtWw30QAA870JVMbPGYVVpPgW/XUpBQC
	bInR01TRGFYOJzMNLlL2g6igiUId5nc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=pNkqxamR;
	spf=pass (imf09.hostedemail.com: domain of "prvs=42586a9f2=kalyazin@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=42586a9f2=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764756216; x=1796292216;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=s7odRi39//eUzQHPeI9r1ot7neXJJbQK2cDuxp8n8TI=;
  b=pNkqxamRyMiDFMRwisEs2WYfYCwcrYwa4zBOG+oat/hSsXGLpTtvh6Rh
   c/r+PTO7x+kNPwtcKTXF0hk8Sk7BQdCHl4+HvXUbCb/2ZyWREPQq3H3XM
   yDEqyvB/mXzDrNDsGPQ7vOBE8mgdQg7MHlLIhWi0FJwMxmetiDUzI/qNT
   7oH+U15/NDNWOY3dxiwpLvi5YTZ02S1s3OD7Dluty8rmvRlrgbZzBwa3K
   A+Zh/Dol/nzvbsLLY+dFCK3iR76E9+JLZNaWbM9Gz6QPDWZigc4X/pkh5
   A4T6qXYxKXs4qiX7KNGfKoLjIugP4O1sPtuwj7LQ+RXZ4kqiamxmj2hge
   g==;
X-CSE-ConnectionGUID: y+zHd3gVTkuBmjeZewQSHw==
X-CSE-MsgGUID: co2givXqS36NxzqAzRiVyg==
X-IronPort-AV: E=Sophos;i="6.20,245,1758585600"; 
   d="scan'208";a="5853166"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 10:03:19 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:6533]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.44.247:2525] with esmtp (Farcaster)
 id 082a07bd-3f7a-43be-a7c1-2fe7936d9f9f; Wed, 3 Dec 2025 10:03:19 +0000 (UTC)
X-Farcaster-Flow-ID: 082a07bd-3f7a-43be-a7c1-2fe7936d9f9f
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Wed, 3 Dec 2025 10:03:18 +0000
Received: from [192.168.6.49] (10.106.82.29) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Wed, 3 Dec 2025
 10:03:17 +0000
Message-ID: <6b21d20c-447f-4059-8cbd-76a8eeebe834@amazon.com>
Date: Wed, 3 Dec 2025 10:03:16 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Peter Xu
	<peterx@redhat.com>
CC: Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>, Andrea Arcangeli
	<aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, "James
 Houghton" <jthoughton@google.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
 <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
 <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
 <553c64e8-d224-4764-9057-84289257cac9@amazon.com> <aS3f_PlxWLb-6NmR@x1.local>
 <76e3d5bf-df73-4293-84f6-0d6ddabd0fd7@amazon.com> <aS4BVC42JiUT51rS@x1.local>
 <415a5956-1dec-4f10-be36-85f6d4d8f4b4@amazon.com>
 <69bfdffd-8aa3-4375-9caf-b3311ff72448@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <69bfdffd-8aa3-4375-9caf-b3311ff72448@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.82.29]
X-ClientProxiedBy: EX19D001EUB003.ant.amazon.com (10.252.51.38) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Queue-Id: 7F33914000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: f4ph359wjqu9ispqgit7brwuiyfbwzsn
X-HE-Tag: 1764756216-928801
X-HE-Meta: U2FsdGVkX19N9izNwM6wm6cAz7NGi0cu6QttuNUKgVd+PRe10+xWcuBASdU/CZ6eVE7yYSprA1Udy4zWdLahBDHs2Qo+yUGx17HG1IjUho7BLoCtTmFGELSsAxPQ5BIWT7+t4UWWynZlrUTh8Ga62F6/GgCE8+T1GjMS5/yNHvubkysBu/F4f4JFNTYWSXkH76zCsLxXxh0qz/2zGZzsjyNkjjUi++KU93PiQa8U7C3He/SN1WH9BJVnoGr1txZ76fKqnaQOXRpBnW3nAluTsI+yQMnhCtia7AVsAk/Zn3iWLW5AyBzd3QG2Lfgx5rXAjb4TcYPpQ4/49XvZLSSosUNnnAtydfGYpBbZvsvcAxtsvojoYu7wWcJevaNy+SDoYy3ZZSphpISehqQjRerSAlB343QCYhHc0LYaChp1a/Vbch3phP7EO0K82xYnf8NLrAy2zQ+mYOsjyDDg+xWv9zUKrLhY5/NdFb3fep8D/aXw6uobCp7TzTztcPuc/yeWvP+lNVO2tRz2JG9o6jOFGuNSiW3izDmAn/y+nc+SDL1xOC2W3v1aX04OMS0TEPFuqKflWIl5T2UVwBX8d68WXbe//G9w+qtpg8nQHKr9JuizQT40NnFTmPAXP5+J1GBK8p0vUW3iq1Xuz8GbPEtshpDZv7iDCf48HF9ELiR2MyuBIlFgKLVeuAP4YlOEC8dN5G9hMWK53T4izdBumXtBN18p+EJPme3lcHM3kzwGTvdr7YcEtwKzzrvLMEmnS6yD5LeuQCfA5VpRAW5f6Q+7KbUZIvHxwyMx717BhM23RQqAy3t3UxlAvDBMlHB1ToKxkBmI/Z1pec77MqNtHx8SY+BMtZ6j9S/oL36e/Hi4zXGdZn4Z8Gb8FIBpomPQrKhZvfScj4vhLEVhJvd3ktru1XpuZy2/ncKnrKMpshEExlXPwVafM/PIuS4ykqX8GK5cN/ej4JQN3p9Q7xggmBt
 6FoZTx5k
 RbpsnVR2Jr6VIxDkfRaWlDp8WijXE9H3J6+DfnijSZa4Ea7toaBVcunlDsBA0FeB9VNBgwSbxxAVFK/xU8HmVE2PEcendGg5N8WkjIOXo9gQg2lVJ7yJ9bSQFML3befy9mzRfgramjQiweUpt6l1E4+FZCeMwAqDfbUlYtAPnNfJjKl3R9OpdXT+sU6k4oah73vClO55hz/ez2KZQBorwNDnKIXOXeAlcifm2gjXdFK8/UkKMTy07Z/INQUuqGmDSQHZ2gAwxd81p5eu1N6lyvpVAAxpTE7BT3QP09N71a88frmcY5IEdDeh2Iz+szH/122tfq/oJsn7SWxXMEBSEdzBBhiWqSUEWlVfKQ48tf9Ah2C7ins9+Dzaw6H7wy/vmuDDu5rf8c1bvQYI/fBxYPuaCr18pzer7b8udD0F90+/KHti11a5XtiZjPiLAX/G38e9RiHATwMyOFPGVYWN9z/pEVCH82CNpR7Hvgp8BnFYS7GLYQDUuM5d4GaJvUaa9AEtx2QrYu2Ieg9LlDBEvH1JgHtsXCriFCDvTOOx9MtevR+jUv2ZO0lYx6n27VhGVl+QSgOEk1xBvPpwZcV0UEeWjLsltApnuXMPm/tovTE+pcIhS4rSfZAD+UfExQRG68zA2ZsBchz+580Wi7eO+LdqTGhxoaUya82C9yAQkHx4JMzhdBtgUSkMxAqMAxgaXTidVKt9eOIZFbZpQ/y6NC/BXMXJ2lpP51inBbKoron8sl53bXVHs737cdsjNJrDsWmrMcV8GCvU6OptnCvzFMuM+vqnsM2lASLH/DZHHM7bbWxguxC1CBNqTDqfnxudUyLGheUUgk1ToduWuyonZPfvunAvbLWcFHO8zGKX317hKXRWL+yGbQ9FzQ5e9FNBKsUMN00elLM2jjCc1P/lE5mkKwLn91cfgWpoi1f4ShH5XLF9KLA6Q15qVFMmoB5nsnivhepdyBKRzmkhn7ypE4IIiRwhd
 gVV9sp0J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/12/2025 09:23, David Hildenbrand (Red Hat) wrote:
> On 12/2/25 12:50, Nikita Kalyazin wrote:
>>
>>
>> On 01/12/2025 20:57, Peter Xu wrote:
>>> On Mon, Dec 01, 2025 at 08:12:38PM +0000, Nikita Kalyazin wrote:
>>>>
>>>>
>>>> On 01/12/2025 18:35, Peter Xu wrote:
>>>>> On Mon, Dec 01, 2025 at 04:48:22PM +0000, Nikita Kalyazin wrote:
>>>>>> I believe I found the precise point where we convinced ourselves 
>>>>>> that minor
>>>>>> support was sufficient: [1].  If at this moment we don't find that 
>>>>>> reasoning
>>>>>> valid anymore, then indeed implementing missing is the only option.
>>>>>>
>>>>>> [1] https://lore.kernel.org/kvm/Z9GsIDVYWoV8d8-C@x1.local
>>>>>
>>>>> Now after I re-read the discussion, I may have made a wrong statement
>>>>> there, sorry.  I could have got slightly confused on when the write()
>>>>> syscall can be involved.
>>>>>
>>>>> I agree if you want to get an event when cache missed with the 
>>>>> current uffd
>>>>> definitions and when pre-population is forbidden, then MISSING trap is
>>>>> required.  That is, with/without the need of UFFDIO_COPY being 
>>>>> available.
>>>>>
>>>>> Do I understand it right that UFFDIO_COPY is not allowed in your 
>>>>> case, but
>>>>> only write()?
>>>>
>>>> No, UFFDIO_COPY would work perfectly fine.  We will still use write()
>>>> whenever we resolve stage-2 faults as they aren't visible to UFFD.  
>>>> When a
>>>> userfault occurs at an offset that already has a page in the cache, 
>>>> we will
>>>> have to keep using UFFDIO_CONTINUE so it looks like both will be 
>>>> required:
>>>>
>>>>    - user mapping major fault -> UFFDIO_COPY (fills the cache and 
>>>> sets up
>>>> userspace PT)
>>>>    - user mapping minor fault -> UFFDIO_CONTINUE (only sets up 
>>>> userspace PT)
>>>>    - stage-2 fault -> write() (only fills the cache)
>>>
>>> Is stage-2 fault about KVM_MEMORY_EXIT_FLAG_USERFAULT, per James's 
>>> series?
>>
>> Yes, that's the one ([1]).
>>
>> [1]
>> https://lore.kernel.org/kvm/20250618042424.330664-1-jthoughton@google.com
>>
>>>
>>> It looks fine indeed, but it looks slightly weird then, as you'll 
>>> have two
>>> ways to populate the page cache.  Logically here atomicity is indeed not
>>> needed when you trap both MISSING + MINOR.
>>
>> I reran the test based on the UFFDIO_COPY prototype I had using your
>> series [2], and UFFDIO_COPY is slower than write() to populate 512 MiB:
>> 237 vs 202 ms (+17%).  Even though UFFDIO_COPY alone is functionally
>> sufficient, I would prefer to have an option to use write() where
>> possible and only falling back to UFFDIO_COPY for userspace faults to
>> have better performance.
> 
> Just so I understand correctly: we could even do without UFFDIO_COPY for
> that scenario by using write() + minor faults?

We still need major fault notifications as well (which we were 
accidentally generating until this version).  But we can resolve them 
with write() + UFFDIO_CONTINUE instead of UFFDIO_COPY.

> 
> But what you are saying is that there might be a performance benefit in
> using UFFDIO_COPY for userspace faults, to avoid the write()+minor fault
> overhead?

UFFDIO_COPY _may_ be faster to resolve userspace faults because it's a 
single syscall instead of two, but the amount of userspace faults, at 
least in our scenario, is negligible compared to the amount of stage-2 
faults, so I wouldn't use it as an argument for supporting UFFDIO_COPY 
if it can be avoided.

> 
> -- 
> Cheers
> 
> David


