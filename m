Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD33606A335
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b=CH0ELNzD
Received: by kanga.kvack.org (Postfix)
	id EF8736B05B1; Wed, 18 Nov 2026 05:27:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9886B05B8; Wed, 18 Nov 2026 05:27:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE68F6B05BA; Wed, 18 Nov 2026 05:27:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFE396B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:27:04 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 500371606DF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:27:04 +0000 (UTC)
X-FDA: 85447861968.30.D7E7D12
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	by imf25.hostedemail.com (Postfix) with ESMTP id 16D45A0003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:27:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b=CH0ELNzD;
	spf=pass (imf25.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 178.154.239.72 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru;
	dmarc=pass (policy=none) header.from=yandex-team.ru
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794997622;
	b=PSvIBDsZUGegOhW1G1ABJRkmNWlJqVf54gEhF0iov2L/QeTV5QwQ8SJqHPMe2nS6LmcU7G
	WSsClK6pG8LrIwW9ZvR6FYt5IKo9omvqXeTavbBujgWG/HPMMRk7OJOu9YCNo/LODElrF8
	NdWfPo6XW5F2pMWWqRXXXy6Jws4xRYo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b=CH0ELNzD;
	spf=pass (imf25.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 178.154.239.72 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru;
	dmarc=pass (policy=none) header.from=yandex-team.ru
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794997622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgBgYjBwxx/0h1itT1vxtcD9+XMGMAnJpI+uws+wlmE=;
	b=EOOmttxksOvgV6PPkLNesyu+gC80m4C5kplDXjCDCFBAv/eqQ9JEjqtMKGVKm9RYyLmMa3
	c7yucZ57wFnO3X4UjI3Z7df3XatzJUMto5bqUAvjZNjYdScXiDPFGRAQxT7AnWiramroqZ
	U8XVtxzqElAsQjUfClayFw6sz+W2Sgs=
Received: from mail-nwsmtp-smtp-corp-main-66 (unknown)
	by forwardcorp1a.mail.yandex.net (postfix) with ESMTPS id 01BB4C01B0;
	Wed, 18 Nov 2026 13:27:00 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:d4b::1:2a]
	by mail-nwsmtp-smtp-corp-main-66 with ESMTPSA id vQXVM51WmuQ0-e6VOJhIF;
	Wed, 18 Nov 2026 13:26:59 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1794997619;
	bh=lgBgYjBwxx/0h1itT1vxtcD9+XMGMAnJpI+uws+wlmE=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=CH0ELNzDFEWRRsummb5x9cX8/IIhLQzKFNgUrby7/D8EmYSyal4QdK+xgpE5LwmFl
	 d0Bk6WhzDFrRRCp/MXhw3KeJX4DeLQ+XCwG4LBqO5Ot0Ygte360VyPZ3DPQggYC5DR
	 LK/Cfw4d/OxxMFyqsiaUmkbGGrilmrwMp9/Jtqn4=
Message-ID: <464d793e-19e5-42d2-b695-c8124fbb9b34@yandex-team.ru>
Date: Wed, 18 Nov 2026 13:26:57 +0300
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: don't undo another caller's pageblock
 isolation
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261118000014.1474617-1-d-tatianin@yandex-team.ru>
 <17456889-f94b-438f-85b3-45e9d51272ee@kernel.org>
Content-Language: en-US
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
In-Reply-To: <17456889-f94b-438f-85b3-45e9d51272ee@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 16D45A0003
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8e4mt6pcm1hkpcjdifhx4pijg46aqx7s
X-Rspam-User: 
X-HE-Tag: 1794997621-833327
X-HE-Meta: U2FsdGVkX19nLuBVqv065QC1XEe2zP2WjzWxo0P+DoPD8sMDq4gwnekXAeVbi3jJoRtI6ou2GkkDaP2udhELbjhs+bXV0QGT9Z7RxHQJgNOnQM7LpSSLOCH+vYzqHOCVpfMwzTo/6JQpP8Cvv/i9oygGGo2AAy4dwH9Mj1NoDvj3bBS612N4MaomLu7AyZvVeAELxA1xM7ns/eK35upEuorjdmiqRaUnSMRHBQm269N7M2nl+5ko4b1joLLUW1QB1+8paXQrXd1gSCQn57W3JFX3kbDqHp4pGV8iKB7XIllt8C9JPFLgw+8+zGigneVonJ9XCxLE0ZKsc6CgB6hV+GlrxS7+iCdQiqRfXLMlic0pQ+bmfoeTxqz+XD4vE5m3uKOiQE9XKjkwJhSMUcMYE54lN2/C3ecTBi8hPjoF2v9JI8FVRbqHzvj9GSjiOSDh4XHp5s7yOdF68QBVAgjVn41t3OC3YdNlPjsNzI+w9wCQVFRtNlWZQCIlM9zcFvSYtfAXpjfY4nUBJMHzdiV8tirnfkgYMv7ZiC2Ucvf4v8Mty03WcFfQY/ZS5PbmTzgp1SfJKl7v7u1Dqw7pbSkf2L1ETXYBCTGacET95ff9LdzKtQATtTWphAraQzTHenSkomrrzulJ9f8P+y28oFaRL69n6ePWKMG4N/4eyDHaaxXKr/RF3qDgAJZ4MKAr8fG8ll44AWH+OQsq+kwZzz7JH2uDpBpCl0tf1p2+6ZIvqRWDsuiGkjKqKAvoX3IRuz4eFjL2Xh6WfGdIa4dKpY956vk29Tnh6ZtpQ8ng4Kclhuq5npsVOxB/NZoR1FAL8i77XLY1xGrPFXgRC+Cj/ibbq9GQ2A41WgrxyClItafeug0NCwQzOTP0ojp3A1gyPQaCSMz4IvS2KdAIEyMKp9qCBWySKKXUdOJaafnw3RSjZJx4SWR+i7WxJV4ri27U7cK97u7EVZKq2AtXMjrLA/Y
 Io/OHJr/
 J0oDLAI7Na87tgagbgHMXTO+xEaxv7sXMDL/dqz6LW5yC3mA4KvuP8EV1abm1D+lotO+NF40enlW5hVVro/LEi1ZcMazvq9QEC+pNLkFs/Lh9ffCIPMJ5wxX/9Kl/WEP+cmnj54Soecgtuz3N/vdFNdljas29/hjzc6EAqsyfS5kUj6FD87pb/nI7S3B9grTPF0oAAxPx9i/23B7R5e1kWSQPhxllaQoPRmk48BHqtWBsgIDk0bgh1U17+KBz2bJJngmnnR4Q6PWzQhNyHFL1peBMfvr46iIZ+1w9ncT9qtjz9PnmjsZjUng/W7BEhvozJpPp73hQ2Nz3z/kmrLubSNip+YR4FyhrXU1yYYVXrGHMr5jtbc3paoHON/HK+FTMYaNMIzZ3dpsygwEwzyPPLVAHuVaCWktz3ocmO535Vy/bJED8UVfZVZ0TCK4lGQVEdVsbVr+S7N0fY/blZ1ijHf9evQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 12:50 PM, David Hildenbrand (Arm) wrote:

> On 11/18/26 01:00, Daniil Tatianin wrote:
>> start_isolate_page_range() fails with -EBUSY when a pageblock in the
>> range is already isolated, after it has undone the isolation it did
>> itself. Commit 2c7452a075d4 ("mm/page_isolation.c: make
>> start_isolate_page_range() fail if already isolated") made it work this
>> way, so that users of overlapping ranges, such as CMA, memory offlining
>> and gigantic hugetlb pages, can use pageblock isolation to stay out of
>> each other's way.
>>
>> Since commit b2c9e2fbba32 ("mm: make alloc_contig_range work at
>> pageblock granularity"), alloc_contig_frozen_range() handles this
>> failure by jumping to its common exit path, which calls
>> undo_isolate_page_range() on the whole range. What is still isolated
>> there at this point belongs to the other user, so this takes the
>> isolation away while that user is still working on the pageblock. The
>> page allocator can then hand out its free pages again.
>>
>> Return right away instead, like offline_pages() does when
>> start_isolate_page_range() fails.
>>
>> Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
>> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
>> ---
>>   mm/page_alloc.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 12fac9084c48..151a8d64783d 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -7335,8 +7335,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>>   	 */
>>   
>>   	ret = start_isolate_page_range(start, end, mode);
>> +	/* After a failure, whatever is still isolated belongs to someone else */
>>   	if (ret)
>> -		goto done;
>> +		return ret;
>>   
>>   	drain_all_pages(cc.zone);
>>   
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7d9c29ed8feec8bfbe5e5f673ba2b5926da11375

Oops, my bad, should've checked. Thanks



