Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B20FBCD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296A36B008A; Wed,  3 Jun 2026 07:41:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26E736B008C; Wed,  3 Jun 2026 07:41:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB686B0092; Wed,  3 Jun 2026 07:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0CE6B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:41:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD4D41C1600
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:41:52 +0000 (UTC)
X-FDA: 84838412064.26.FE9211B
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf14.hostedemail.com (Postfix) with ESMTP id BFE2410000C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:41:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M4Wz5t/G";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780486911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UL4u4uRmoBKLAhYy0Fqp9Y3r55rWdaL145K+bUKWQuc=;
	b=cWkq7DOUzDFIsNxmSc7DYB2HmYxoUzEXNjFsuSYO2fn4JGbnjfSA2aLL4XmCYGc0AiV/zQ
	7BJ2LACgybqn/a6T9DFCrwIyNWtOzzO35YbKxGglf9lr0YFsjwi0+f/PIsiBo3+VilcIVt
	6rz8X5/vMcie2EhS3kH0wcLDwyg+7EA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M4Wz5t/G";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780486911;
	b=j0wL36zYHfsME2C+OKt8P8GYwnF+C1DQmtTrjQTNOWDReXFx0s88q4L3U6bHMu6vQY8OhC
	9zuXKjz+t4s7fRIxlMefNChd7Jfj0P4hmN4ePu2pa8/GgnvEAcU325q2xUQNB3Yc6isbbq
	Ir1HrYPaswRWU8P9JkgT3bbjsz/jwVE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780486908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UL4u4uRmoBKLAhYy0Fqp9Y3r55rWdaL145K+bUKWQuc=;
	b=M4Wz5t/GibhfnNJucsvpMWybJ8N37f+NtPwNfqQbWUp/F2WviagIn1AYil01IjdZrdH1qZ
	KvJ02tTXvO8DRDlAUekPBpw55zsTAYV6lHYBRuG98UTQkk6MtthrQqBvLyNVCWplx6l9cx
	goCRkPNpH4YfnMx953wYvBWXY59ao1U=
From: Lance Yang <lance.yang@linux.dev>
To: rppt@kernel.org
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xueyuan.chen21@gmail.com,
	ioworker0@gmail.com
Subject: Re: [RFC PATCH 1/2] mm/secretmem: try to restore large page mappings in direct map
Date: Wed,  3 Jun 2026 19:41:34 +0800
Message-Id: <20260603114134.3010-1-lance.yang@linux.dev>
In-Reply-To: <aiAJG7gdey4oNr4a@kernel.org>
References: <aiAJG7gdey4oNr4a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 616soyqqxz9ikmgtfwsuyemuw6b7bpxn
X-Rspamd-Queue-Id: BFE2410000C
X-HE-Tag: 1780486910-836686
X-HE-Meta: U2FsdGVkX19K+7zqKe8NjyFvOXmPt4kXxEzNfmkEuma8m+iu1irHm1yRU9jtjzKE8iwXvPeHhQNq+oqwBonNqegZ/QHSQmBvNnBxlOY6iNsS0zy1QuXaxnjlo638MePcSS7QEXtD3PJfkoLvqq44qldGYvoMpu4NfL7aCglVsqxxiLjoY/KuHCItnQ6HqAhsuHI4yNnrUXEXMPOiaDM+kkcJVefW9DgrrtxEL6AoQJh10rEFRu3u6weyGKpDc6YyiyMb3pt4Ug9OPc1Ay7ObxD5oEFfnJjk7wgwXPTy2cw4Es82QRWbO1NY4CznjJ2MFapf0ymiuc91ipYZNHNmOL9s3OkEF8+qa14AAodzuDQ3LcgmBxiiVpVhiPYqhzwtWS8WqpU961uDczBBLlNOhtgQpv0Sqt4SQSNZpNXlJWOzeQHUfZlUApUC2e4TmduDBJIYIcYYHFOLd7/L285EFfI6/9wmu1QwnMGn0srLuL3/EI1BL4GXIO8G4Xf/ZYjO0RElI8JWwY2/oa5h8eRau5yx3Y3ZH/M13LAHE3NWQsWS0D+yvjfjIk9ebtMupy4grHKuJf6/9b7f+lfzrXPCwOgOG85OcFwvpm16c1yHQSY4RdOJsZE3ryA3ZxYHUy22XvgRQFlehKvRNCYbV2oq46EOkJGkrpVC2yW8gNFL4d0geUDl+LwOgDcCEjd76zz5OZoktiej9D4KHOqe9PGg5CifTYgApuCPwn1+7jODhQWi0xshWrvUW4YYm5aX+VxWVQ0q21wEEQlSfaX141J5nK/ZbDCP5d9xOSR/y0poYqGB2XhwfI1AkleIMV8HxUeiJnM7yH+u2THuvd9/pOysZj7Mk/aKgBSEasCLrCavVN/uvDfOaiPbvl4+3TPq+j2ZJMl+zlh0YWSBsRqAKidg/tLZ4GXvNbqf4HxHVyyQVx2MHVs2nPxbaw4GIlAy2QO+8H/9YIu6WYeAeWg7BWG0
 1ki35ho1
 55xjdbmT0ULYd4TGqP1o85bwBD2CnO/C59j+lWyGIWO/qbkhaV0HnKOmL/oo0CINcRfMxPXobnMkqW/GtuZjtdIx5X4J3oU3/qBmgaIhS/F7Y4g+eyEna+o+zv6QC5tnueOCAd0mncZCbPb4HoC3S8GquIS0oZKUfDfCseObBwYI+4Z+6y8+OvPpkAet5HuRmQFLAdSUIPMJkIiHpk8GRAY5xUNuYhNfCdNfSTJMiAZeN68iKms6+ZKd+8d1cX4KBY52fB1Kug4XsSargrTdy5EVp7Oq8qudpRqGnUD/pxeo2er+BCM4IFj0xNbRwBrkn3QjAJlv2AQ4djZc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jun 03, 2026 at 01:59:39PM +0300, Mike Rapoport wrote:
>Hi Lance,

Hey Mike,

>On Wed, Jun 03, 2026 at 06:46:23PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>> 
>> secretmem removes the pages backing secretmem mappings from the direct map.
>> 
>> Removing one base page from the direct map can split the covering large
>> mapping down to PTE mappings. Repeated splits can leave more of the direct
>> map mapped with PTEs, meaning more TLB entries for the same range and
>> potentially more TLB pressure.
>> 
>> So let's try to restore large page mappings whenever secretmem restores a
>> folio to the direct map.
>> 
>> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>  include/linux/set_memory.h |  6 ++++++
>>  mm/secretmem.c             | 12 ++++++++++--
>>  2 files changed, 16 insertions(+), 2 deletions(-)
>> 
>> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
>> index 3030d9245f5a..ad2fa414a22d 100644
>> --- a/include/linux/set_memory.h
>> +++ b/include/linux/set_memory.h
>> @@ -58,6 +58,12 @@ static inline bool can_set_direct_map(void)
>>  #endif
>>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>>  
>> +#ifndef arch_try_collapse_direct_map
>> +static inline void arch_try_collapse_direct_map(struct page *page)
>> +{
>> +}
>> +#endif
>
>Did you explore what would it mean to hook collapse_large_pages() into
>set_direct_map_default_noflush()?

Good point, I kept it separate on purpose :)

Putting collapse into set_direct_map_default_noflush() would change the
semantics of that helper a bit, IMHO.

I would expect arch_try_collapse_direct_map() to also be useful for cases
where a direct-map permission change could split a large maping first,
and the user wants to try restoring the large mapping after changing it
back. One example[1] is making a direct-map range read-only for security,
which I am also working on :)

[1] https://lore.kernel.org/linux-mm/9979fa87-88ef-4baf-8592-502ff4888085@kernel.org/

Cheers, Lance

