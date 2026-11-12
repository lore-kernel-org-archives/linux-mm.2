Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2B4606A33C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 04:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bU/bmCnS
Received: by kanga.kvack.org (Postfix)
	id 6704D6B00EF; Wed, 11 Nov 2026 23:09:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647AC6B05B2; Wed, 11 Nov 2026 23:09:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55CED6B05B3; Wed, 11 Nov 2026 23:09:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29D476B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:09:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84AAFA79D9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:09:13 +0000 (UTC)
X-FDA: 85425136986.15.9E39E52
Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7446D1A0007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:09:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bU/bmCnS";
	spf=pass (imf19.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794456551;
	b=Do02ot6Rdvlb6kwqvmVSl89UiHhPrf7DeJnLALk2XrYW3bZKACLEhctw6BTg5O5RTYV6o2
	PaVPeEuCoVTMn8O8g2fFxXIgd6/Oec9KLmrLl/Gvr1yh14SUNhi7GdaD7z14pGb8mdOcPe
	ujREQUDIx5pkkkirYCaT4sXV+NXAgio=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bU/bmCnS";
	spf=pass (imf19.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794456551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VS8RosQ7Mux59cIuf5XHj4vRHRXjMhFY96bD3y9PkDE=;
	b=aqm2Ct4WYfiuQ6NBcGX7l/Wm1Y0VQ3EJVXuKjhPYcQXsrqZRdy7ekXjm7l244QVZPFNn9h
	VKAI6T85a4jqfKne37HUCd1aGboOlXB/PMU5u6HMMU6IsxNxp1YTZC5nYVhzXvq2FMfR6q
	05mgO6ZAsTWl4hCfZilL2TO6nbxxoJI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=s6A3fpSYhAtucJpRw/v86R3GejerzlqSOIV0sEbV3eM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794456550; v=1; x=1795061350;
 b=bU/bmCnSogtNUVhuglG9ylXP9j9Ie58pDajvVJufRM4fTFHQMo7SS1K3IFNUQgCpA6rKOVKD
 JW6W9cO0GoGjAeqLjOHgRo55A9Dl+GZAAXky7pXMO1daisA2XBr9+bM+OxTmDFAkjA5OgDCJAQ9
 zuwiMDMN4KC8QiBThDZLEH44=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 90e30105e541158b;
	Thu, 12 Nov 2026 04:09:09 +0000
X-Mizu-Trace-ID: 90e30105e541158b
X-Migadu-Flow: FLOW_OUT
Message-ID: <d4ccbdc4-bb85-4301-a6e3-e5e1e2f0d299@linux.dev>
Date: Thu, 12 Nov 2026 12:09:05 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] selftests/mm: mlock2-tests: fix fclose(NULL) in
 is_vmflag_set()
To: "Liam R. Howlett" <liam@infradead.org>
References: <20261104-for-mlock2-v1-1-57e6dd74c2bd@kylinos.cn>
 <t4vjvdkdvmqcagvhw7z3p2x67p3iopcjqllrapwrzd7qyothb4@un6bq6otzb7w>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <t4vjvdkdvmqcagvhw7z3p2x67p3iopcjqllrapwrzd7qyothb4@un6bq6otzb7w>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7446D1A0007
X-Stat-Signature: bkhzzgo6xpy1u6t4wzztt4ueuztcy1nu
X-Rspam-User: 
X-HE-Tag: 1794456551-750875
X-HE-Meta: U2FsdGVkX19BzwPTtmth60xKoGNnI5zw+f1AlCyqrmJby76u33ENUENzhocusfdhcwjqPz87gUox1WrS6wJ+wgRK8oywGXrp4vtOHeFxrOpvP49/EsU7up0Esls2u7VUiS7O7MBu+4mKp8gcE0i3u/n0Gk45cIgHehlJ8WXB75Vcb8P0qJIxZ9kuG2kUSY21QbFwHyvvE2QJyjfXlQQSGPvrgN0+hfJpOwZEI8Qy1uw9vFLfg7Lx3/09FF+4HCuqBTGpay/WvBIW6cZSzDT3hUwt6///uIzJf+koiHV8ybJrP0RfBdx4yNaQoXzzLfdNZZ9rTlhxqG2etbja47mxSixkSmM7mGesRhjmY4ynUXwgpMasySAxVKBshgzasUdZSLcF7a6mv08gecmRGdL7h+dbsrC7OhWieQdFzxmiPYNRg2Lsv8KlW7hzYCE6Zg/tHDAkHRNgnDd58hCJMLvoBBJn79M3x/w+Qe763YrVuT5e+vccrfdN2OUm31tGAirJ1nsKWYr4zPrfIEDBnp4eASAg0yRc80UKPYYTXA6n00O5I1lMdhfuZVoL2fFPpEQSbGBuyWsAUpxSOd7vI6QxLJuUENIdR+t1wV9UwSgE8buftzwJW/GN4JVOT70wT0tPcntsAK1ifG12CQUb7W5bnSWDvrTqJAZJKyQGMkjeuZl8paOA8W6FLnzIYZKksOnZ8lZZHp18BKWBbnDpfIXr9y/fltjZEiI7dYCrTYLjMP/Ib7tRUBFpGOrqbryRFbPwd3LnBEFz7zWL61q3cXggVoO7Yz/gFeIqbS9vfkfU1qu4Y3ebG34BRdDuo1eNUxOEs4TVml8Iy7RuAemnAqj6kKUztwiaUoBsygXrBUBLiBZheSJxy3fwArmeph6/Jw9XAwqgvOYyrvs1AHBqmxyhTU9Lra+kXXis/BgrXDrmP4rFWaSHCD7wz6dYisHbEQdRNweZ7WQrPtI2h13QZF9
 TLSD0wMu
 e7/j8fd5MF/Lv2od/XVys5weFBq+WX7SNWnaWN+Y+gx5lyR3unhwTz1sRrvweHXuClVL/zBz/RWRJKkBKngsOvOVhZjebVb1kFMkC8j5xXpjGjXSdpbU7Gz3HAD7wROHxrpyAeicYOGm0aUXkMuCZaTBK74tJcOmnICj4KWQbmNd7yrrAkskQexi97EC0K0RvhRdHjtkxKf9Xry/EI7xZ4tWJZR/4SsuZo3w/19GWElJYWr6G0Ic2fyli88/t5ajGTC0Gg2Xhmaon+wqGrgKvzE5o3c6vzaiEYgwsESFxii2a2qIwkUZ+y+vO0H4Fctx7JDyTdCvW4DthA/LeHPcAPv5UuNle5GST+4Qd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 11/12/26 03:49, Liam R. Howlett 写道:
> On 26/11/04 04:49PM, Hongfu Li wrote:
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> is_vmflag_set() jumps to the shared 'out' label when
>> seek_to_smaps_entry() fails. smaps is NULL on that path, and the
>> code at the 'out' label calls fclose(smaps) unconditionally.
>> fclose(NULL) is undefined behaviour, so the test crashes before
>> it can report a test result.
>>
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> The sending address should match the sign off.

Sure, I'll send a follow-up from the same address.

>> ---
>>   tools/testing/selftests/mm/mlock2-tests.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
>> index 144b550813a6..85e6cd24515a 100644
>> --- a/tools/testing/selftests/mm/mlock2-tests.c
>> +++ b/tools/testing/selftests/mm/mlock2-tests.c
>> @@ -66,7 +66,7 @@ static bool is_vmflag_set(unsigned long addr, const char *vmflag)
>>   	smaps = seek_to_smaps_entry(addr);
>>   	if (!smaps) {
>>   		ksft_print_msg("Unable to parse /proc/self/smaps\n");
>> -		goto out;
>> +		return false;
>>   	}
> This looks better.
>
> The next function is also messy with the goto usage/ordering of
> unrolling and should probably be changed in the same way.

Thanks for the review.

Agreed, get_value_for_name() has the same pattern. I'll handle it in
the same way in v2.

>>   
>>   	while (getline(&line, &size, smaps) > 0) {
>>
>> ---
>> base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282
>> change-id: 20261104-for-mlock2-a67f86dad498
>>
>> Best regards,
>> --
>> Hongfu Li <lihongfu@kylinos.cn>
>>
-- 
Best regards,
Hongfu


