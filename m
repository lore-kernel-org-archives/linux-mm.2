Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D39BFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73FBD6B0095; Mon, 27 Apr 2026 11:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716C86B0099; Mon, 27 Apr 2026 11:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653FE6B009B; Mon, 27 Apr 2026 11:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 583ED6B0095
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:20:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7923640537
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:14:28 +0000 (UTC)
X-FDA: 84704682216.09.AAE94BC
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id 60D334000E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:14:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lOr3L0Tr;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6UgDbcmIJGZlRjzn8XIrNR1a7hkzoZAPPy0uySZ/X8o=;
	b=NF15HCEAG29DfY4w18XIU8WD61kVqiDsJv+n9XH8uZjaZpIWqZOHPjhyZVh7bP8lUQGpbs
	yh7aRBq+emNi8ESntJenp0fsm8VieFs1L4FM1Cea0axSsY+8iGVy/vSTxv2ZZj2j2qJAK0
	4BJFS77MIXHOMlryf6Vnh/DHolg8D9E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302866; a=rsa-sha256;
	cv=none;
	b=khC7FffWrLm+5+88yBCiUyxLBn/9O0Ux/7H6chK2SKq7TVNdbl2XPenK4JiAgjzKQJRRnI
	u0nYW4Khobd0DPzWhlm8TMecUKMw0oKwlSCg23S7Rs0cB31hkffpmXqbM5GTDAEOrpZtu3
	3OAQtBmv9U6vAtH7pC8UiOfdbhMEXDQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lOr3L0Tr;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <b2c0fedc-0641-4c51-9426-879c6878a2e5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777302864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6UgDbcmIJGZlRjzn8XIrNR1a7hkzoZAPPy0uySZ/X8o=;
	b=lOr3L0TrmrYswkMnhmVGOjNxRAxxODxJ+wIm/s2Pa5435yehAW/WXL7l7sreR9iNnPs28P
	xtQ8QSqfCzL3to5dmce73+RBVowv255ePLqtsPGWDWy9Ome+rt/c7JeckpVBkXQ6ZNcjW9
	vxZ4jiONxJWFr2Up/G+bVKbnvQlvAVI=
Date: Mon, 27 Apr 2026 23:14:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 1/4] mm/memory-failure: report MF_MSG_KERNEL for
 reserved pages
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>
Cc: linmiaohe@huawei.com, nao.horiguchi@gmail.com, akpm@linux-foundation.org,
 corbet@lwn.net, skhan@linuxfoundation.org, david@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com
References: <20260424-ecc_panic-v5-1-a35f4b50425c@debian.org>
 <20260427123330.92847-1-lance.yang@linux.dev> <ae92WpsjxQ71BE9Q@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ae92WpsjxQ71BE9Q@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 60D334000E
X-Stat-Signature: 4q65s3yxh5ekbsd79hb3gkw9jj1hcw85
X-Rspam-User: 
X-HE-Tag: 1777302866-587362
X-HE-Meta: U2FsdGVkX1+SBW56yMmvIcxXfuoEANBz73gynS8TmW+mi2Oq5ZO0ssY7i8Nkzvwu+PDLkOgrCNnYInYSdR3xCYDCIgMkwLq1roW336Ewm7otWJy4W1BEQrT/xpN0fxhvd79xBdx9HcwsCP+pVF3SRpsCfZZMr79eZ+g+dQLKAQtugAr3/TEMAVwrmgRA3+i3SBCaiLFqP7QfFyVzK55xzOy/du4PLtUseWvRAIAyj9AJFVSBbggExHRjO5TXMqjzNpofAKTVppgAJ3tw4lb9YmiR7yXSXwyHVNIiuy7rbnQBR6P0qJP7Bbqms4w34+WxOu+9R9VQU2E1cjCMgJwmhOo8lDQJn8dqLJk6ZmOpBz+O/CScuv62j9sw+wl0/JN4lAm5BrNe4RKeQkBwwJmmKC+lcwQIbPWfEqk8BvafGhf2Xf3ws9DFmAMVl9ELraIv4lMeFIrdYNUS5MW2o9Non9IC17xe4uibcPWcHOObsCgcAhWbIwffP7Hx8hayzL91FpVYFmb9UAri7V/nxtW6Jxc7R1kLzl4uS59SHb/wnZqHWolgBivAKg/GpY8wqr7RXhGo90z2wCd6ckjlPNpR7psGDhjY8tZZAIzdDs3Ephf01FOBgpeCbnqBY9tEED9LhC752GHNdvmTnLeoekN3nS+6/WUV6cOs/aDgUVztFpJWXRcUCguQ5ELtDzFROlom1kx4CIKuigoqzS8hFbbCIdxxpVO7vqQf9fSVwp1C1s3dC8B2GFxqItOYW8TKpD1iT6LOZz5gJFZAzb6CPxHhsoYsjmzJkoPzDGTuYbLh131mruTrGo8E6C5kNw9LxyhmHI1/mT+OJz/2LtEPMqh5/uvLihacDVGQtOP73EPMvDmL7IOnqmnISOVZy/HaOPMPjk5wfVRU9ZhkTDtlAqwE61flJBh9qA05tqnGCbk8pOcoFYrcqLI/6ElpPe4qjluDKm7480pq850X6jUtwFa
 g2J4OYat
 SThiBdrnBC7g+f3M+SHZ31A8MgRe+kqH9z9FxPjSEUoO7/vwVHT3rKeWLTg3VPX6X2j9+dTqBZCbglOvp22BDigBKkL4QbhJQ8vIWaNmEg7y5GmCKVRDgRliHATKQMCzPdXGOTmIFJ8nLQqMkyKfCaJB9XXqEyMwtEMiKZi/6cEVI9ukwL3y1CodoRy6dhEnRAri4eBD8FP1mmSWZwEpsw3Uq+oELQdrbUR78YeUiheFsZupkx5Y7NiJ0RF3nyIrZ3F4wBkGrDsmMZE7ysp64a7N6mX+t7+zHIiZkPwpa5U5zBNQnMng5GEkiebHT9I4DoNKQxnEukfneiTvWJpIQGv76Hmnb9jaKYMfatgFQ5oHMiIOQ68oUnGxs6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/27 22:45, Breno Leitao wrote:
> On Mon, Apr 27, 2026 at 08:33:30PM +0800, Lance Yang wrote:
>>
>> On Fri, Apr 24, 2026 at 05:23:59AM -0700, Breno Leitao wrote:
>>> When get_hwpoison_page() returns a negative value, distinguish
>>> reserved pages from other failure cases by reporting MF_MSG_KERNEL
>>> instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
>>> and should be classified accordingly for proper handling.
>>>
>>> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>> ---
>>> mm/memory-failure.c | 11 ++++++++++-
>>> 1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index ee42d43613097..7b67e43dafbd1 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -2432,7 +2432,16 @@ int memory_failure(unsigned long pfn, int flags)
>>> 		}
>>> 		goto unlock_mutex;
>>> 	} else if (res < 0) {
>>> -		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
>>> +		/*
>>> +		 * PageReserved is stable here: reserved pages have
>>> +		 * PG_reserved set at boot or by drivers and are never
>>> +		 * freed through the page allocator.
>>> +		 */
>>
>> Not necessarily. PG_reserved is not a permanent lifetime property for
>> every page that has carried it.
>>
>> page-flags.h says early reserved pages may later have PG_reserved
>> cleared and then be given to the page allocator :)
>>
>> At least some drivers also clear PG_reserved when releasing pages they
>> marked reserved.
>>
>> Would it be clearer to say that pages with PG_reserved set are not
>> currently managed by the page allocator, rather than saying reserved
>> pages are never freed through the page allocator?
> 
> Would a comment like the following look better?
> 
>    /*
>     * Pages with PG_reserved set are not currently managed by the
>     * page allocator (memblock-reserved memory, driver reservations,
>     * etc.), so classify them as kernel-owned for reporting.
>     */
>    if (PageReserved(p))
>        res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);

Works for me, thanks.

