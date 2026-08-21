Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 467AFC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42B536B00A1; Fri, 21 Aug 2026 05:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402C46B00A3; Fri, 21 Aug 2026 05:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3185B6B00A4; Fri, 21 Aug 2026 05:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7E06B00A1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:54:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F65F1C1703
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:54:06 +0000 (UTC)
X-FDA: 85124815692.01.AE4A8B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E0F74100002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:54:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SVJrWNLC;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787306045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjPLxJNysrCM3XRTjy0rjnsBt7BAmnyP4ZMFpEcN1Sw=;
	b=VeOAD9KWzRp+gNoYHiHlDcJShQ5mEIOqJd396Kj3U6Pcj61B3CiCF7fcgGDb1OrqHgkW8F
	4irN0WQ6KSuLWMZEUX0kewxvmH5J10Le+O7bhzCVY4GXYeZouzr24T+0pIUtNp4w3tVIqL
	ODAWtAwQw//VeSDZXjWRNsDtvuHzHZU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787306045;
	b=b343U1quQEu0/F9nKz2D7XZEx7I8HtJBqlE6GrDX7rXyR20EB1N/WKYLdTEo1E35+e5LDT
	lwUwEGbVe03c3Jfpse+OO2n06ahxaey1Jyfy5c0LyRfFsrjseeDMU5s13jBG/QLB/WFuCu
	FXPMQ0PuZ/zHF0/gTyhRnn6+zFnJgSg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SVJrWNLC;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14A4843C81;
	Fri, 21 Aug 2026 09:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97B51F000E9;
	Fri, 21 Aug 2026 09:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787306044;
	bh=TjPLxJNysrCM3XRTjy0rjnsBt7BAmnyP4ZMFpEcN1Sw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SVJrWNLCMys4aydRPUHIVTuX7TEEsk2EQ1EQ4KNIWMxdspWLnKdBwX8GiAsWuIA+3
	 xeetpygDIYQhcq5Cx/zuvud0+6wiM3d5sexk5Q/bK3+8Mml/0oCrHplnLlt0S8ybqi
	 /v20kjxrlHkWTxETU19UioaRAE7YVc5VVJXmYwwOfl3DsT46cDmwqSH4k6xoBskYkV
	 MM9QjlqvBNeACDehdIfoTTS8XLm8SOGTTMipmrUM3VLqcNI6GqRjHcn3oIa3Rck1Yj
	 Bd7E7KVogJmt1BFhraC9rsxas26BHTa4+xJtYY3vX38LN7DVocCouQGFjByCEAwPGG
	 fm5ZyV0GW0Mbg==
Message-ID: <59525a3e-6003-4ab1-bd75-e0c7dcc8a257@kernel.org>
Date: Fri, 21 Aug 2026 11:53:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] selftests: mm: introduce page allocation stall
 reproducer
To: Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>
Cc: Shuah Khan <shuah@kernel.org>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260819070538.2404983-1-jasonmiu@google.com>
 <20260820170348.48f04ed654dce5193ca3a532@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260820170348.48f04ed654dce5193ca3a532@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: z1s534wg8xc63ms451r676m7ijkfgy4a
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E0F74100002
X-HE-Tag: 1787306044-532972
X-HE-Meta: U2FsdGVkX18fN518bIZg/ve+W6bf2/uXDmGb0EX3rZN46TGcSJzonHptf7OoE6n0ummr2ynQAW4+kJAT6k1z3QBiXRuApCuTP7T/b3Oha3J1Yb/4QVN3aCeKRvcMZI3+tzPntPul1n1O8FWhEZ5zd4jtlbOPeU2KexPCo6E68gQ7qMgJqH1f60Gc0PTdf4e8xQG8idbtA5kEfJ1wVq0dUVjB6M5RofQnJqpJQxtoSTHzoBl1875KbltVWazcgr29JTd5PsENO7WkWPpjyQas3WLCbGKu+HYDAHkbOWznsyE4hCFz4rSoL5vEzZZJbKy+nEkRFwI0d44SwAX3JixKx7NI8FhRIbz3HC1o/hkG5B4YgfhYhINqDUFKTHLsvq58fE6MSNQNXniG0e+bvakcfmtZnz7V2u2BHrd4YhJOrv5bFijJ3KsTwH7KNB7+ZIjMxYtwXJz87K1RSO6rF9L8mfWdfSoIixoO5gbL+u00kNLLSt1JkTx7vCgaVt3twxhdobW8h02gN6NmlR2jsTjYtaGDoxHgb2ZkKTplIQXYoOmXO2P+YS4tW+MhSvsb3tuLA8Ak3dmTXQsMB4Y6Qiyfd7lGMYNAKCybeKhgZd9dMgqa78+vtlWNni+CoUy6UaWUE/Fznsa6EkdJ+ohuHX99Kkzg22R1MrOkowcKoo75LIWOv2zK69mO275+Pqx1uRED+SCaPFiLMGQrmO4DBFtxlrMXFGiFTQqAcEBXOXM9ZQLPqJPqSB8Yr1zY4gxSyk4IhUEqzmFPxmKqYB+aYCiFhD7BaUjwRICbuczwIkv7JlAUOuxgq9li+9iyDcGer07tBCXSY7EYqZSVUzroTkbYDg6jzJJMtyXCXZafQvCFoPTYoihd3WF8dZpdReuPLk9a/AoDwsSVlwMsXA91CRrX5ho1EfJF3jGMEEcartr+qPD4vGCOnhia8TDzpXWJPVcnDYH9l+TUPUT8VOrOqeh
 V3sSKcSu
 X+GVjRN4IqaS69wk/b/uRkuRp6HCM2qD+J4F+CebGOHHRww8ZkRCKwzhjp/HOPlX8B91GOiLRMFb710ISJ7hQWBKnAmiQsiMKvUcv+QGpcvz0mFEV2FV7qCiNCfhyskjCAS0TpbZU+71iqgB+W9UWkCOcQzt0EbGJ/H0tJoNmHLEQJxQDM9UJDMrJg+mIJqW5cuSqLmc6GJIwvU3rFjcw0222MSrYHWUe3PnXiz6nVOGx3nbEHD726Yc5Coj0G74Cf4i4+CnfdXXRqFgVx696Y5Z4cb6QvHO4wDXb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/26 02:03, Andrew Morton wrote:
> On Wed, 19 Aug 2026 00:05:35 -0700 Jason Miu <jasonmiu@google.com> wrote:
> 
>> Background
>> ==========
>> Under severe system memory pressure, system unresponsiveness often 
>> occurs due to page allocation stalls. In commit 94e0bcde055e ("mm, 
>> page_alloc: reintroduce page allocation stall warning"), David Rientjes 
>> introduced a warning mechanism to emit a kernel log when a page 
>> allocation takes longer than 10 seconds. This log is used to correlate
>> a frozen system with the system memory state at the time of failure.
>>
>> To further debug and analyze these allocation stalls, we need a 
>> reproducible test case. This patch series introduces a new selftest 
>> designed to artificially mimic the severe memory pressure scenarios 
>> seen in production, allowing us to observe the resulting allocation 
>> stalls.
> 
> Interesting.
> 
>>  lib/Kconfig.debug                             |  11 +
>>  lib/Makefile                                  |   1 +
>>  lib/test_mempress_timer.c                     | 140 +++++++++++
>>  .../testing/selftests/mm/page_alloc_stall.sh  |  80 ++++++
>>  .../selftests/mm/page_alloc_stall_pressure.py | 235 ++++++++++++++++++
>>  5 files changed, 467 insertions(+)
>>  create mode 100644 lib/test_mempress_timer.c
>>  create mode 100644 tools/testing/selftests/mm/page_alloc_stall.sh
>>  create mode 100644 tools/testing/selftests/mm/page_alloc_stall_pressure.py
> 
> Nothing fits very well, does it?
> 

Why are we mixing python and sh?

> 
> 
> selftests is for quick tests which are run by run_kselftest.sh.  You
> had to place it in selftests because there isn't anywhere obvious for
> it to live.
> 
> So I suggest a brand new tools/testing/stresstests/mm.  If we create
> this, people will jump on it and start adding things which presently
> reside in their personal collections.

There was recently a discussion around performance tests, and one thought was to
not carry these in the kernel tree at all.

Stresstests, not sure.

So agreed, that this shouldn't be an ordinary selftests (nothing we would want
to run autoamtically), but I am also not 100% sure about having performance /
stress tests in the kernel tree. It's all stuff we have to maintain and drag along.

> 
> 
> 
> I can't say I like "mempress".  Is "memory_pressure" too wordy?
> 
> 
> 
> All of lib/test*.c shouldn't be in lib/.  lib/ is for library code! 
> Again, we put them there because people are shy about doing mkdir.

There were recent discussions where I raised the same. I would prefer if testing
kernel modules are somewhere in tools/testing/ if possible.


-- 
Cheers,

David

