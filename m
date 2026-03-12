Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8E6CFED2E4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 08:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D578E6B0088; Thu, 12 Mar 2026 04:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05286B0089; Thu, 12 Mar 2026 04:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBC856B008A; Thu, 12 Mar 2026 04:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A795B6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:26:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32BB4C30CF
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:26:13 +0000 (UTC)
X-FDA: 84536728626.10.6F6323B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6F7E2140006
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:26:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fz1J6g5F;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773303971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wAb7k5mvqHw9/aqZpcXZyf7BzYoeWrYI8Q7rG9n3ym4=;
	b=38ZamT0ytf+kZ8XzGj2T/kT1pgNQWnbhVdKYOHnHVOBQ2LcAkb+cgeVMItXIFsvT8Vi86C
	KpgYu/tkKP0I1g2VxDjpENrLT5NOOiEt0HUu2qXbTp7Hw895+SAc7b5Oh5dicCRvS+L3rC
	tpNfu6ceNT8oKt3Pb5M3swREwDfGCSA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fz1J6g5F;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773303971; a=rsa-sha256;
	cv=none;
	b=Cc/aOZgH4jOUErWUg82B7NhishFGRUzO0A1wS6+FFw8TT3Xg62KXW3gzyrBnLxi9ylFEPp
	kgQFnZzovT2ugT8cCTAKMJkiuhYSv2y5IjUY6ZwaSwENpQkuOzoa7QCkFEO0TnqfP+ThcR
	1NLia02YFbDTcdTxW9WaW6GOQHNraik=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C125660054;
	Thu, 12 Mar 2026 08:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F604C4CEF7;
	Thu, 12 Mar 2026 08:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773303970;
	bh=xZibF95cdQn3VPiOBxZvA/wo6LUPkv6y1GlNkUEs+zU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Fz1J6g5FPq2kdTVJCyroElAsGH7tIdNBJr0gOKHUlXb0iJ9D8w5fL7bZV9y/uYEuL
	 3/7qg+iqqHDUw7GOdA5OdT5KIc8eU9hoh7LOn4zBnk97CMLc88h/G0FwOEjgdt9g9I
	 ynZncZLJfn26q8akPOsJoQHZdybS07NAgZQixItiPxRjU5vd4QeiUfrpuobydiZoPJ
	 AtKDcBNXJ/0njtH6AINL9p3iuj/ZnCgpNRKj7KMibVqJYRPn2C6H/aTXaNZinSU9jI
	 EN/ZhgdqDG4lggg7AdNjTwQC7dZ7hyopY3y96T5vI8lwQBmHStPAJPCh0sFp3FkB64
	 PXkvpp9a+wznw==
Message-ID: <42273acc-7ad2-4832-a154-20fd49a460d0@kernel.org>
Date: Thu, 12 Mar 2026 09:26:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: migrate: requeue destination folio on deferred
 split queue
To: Wei Yang <richard.weiyang@gmail.com>, Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 ziy@nvidia.com, willy@infradead.org, linux-mm@kvack.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260310105419.3256755-1-usama.arif@linux.dev>
 <20260312031831.xb6rvrelhw54cmio@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260312031831.xb6rvrelhw54cmio@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F7E2140006
X-Rspamd-Server: rspam08
X-Stat-Signature: beu7tce5o3w615xaych7x3wdmmexpet3
X-HE-Tag: 1773303971-13062
X-HE-Meta: U2FsdGVkX1882prIqQWgv33kN2s32Tdb3eQK1V3pyeCpZ0YpODe3ay/Uix5K57veO4X4rVhRgXCeOweSUPcO5kxKvWbqHL/0rtttRl75u1D6tNbeda5I03CH2cYVD/e57xgSq7mK1CJgvuoTmj49KNeG8pB0VO2GizzJrYNaWQviRwqP/X+HGFtEI0cbfYcHgzTZ10x9i76yqMiz+QUvSHOygIQi6uzCKACUUwpBlrojj5Drf7/04VMhWShy09w2WBa7vBdGzkpywlvnm6a55csZu/qTLvdufUK2QaXd8bkTz7riVheTfKxqOhnYltfrjTB5pTyH9dkJHVtwoivfj1DhiS5ASRmYoibMLobQ0/xMQps552uWUuXLILehq64ydqwgvVTjzyZkUIl0GT+cT8ZEQF/ev4yuVA6DTpadUiCboXJxHNxE2eGXPj3x+8LNDsEsoriNSffnsPzwjgERgBzzVZFIOhWxLLMTAXm+fX6wRmTi0rkmA6g3NSlj8opdrUgauq29DXMJogb/twc2TehRS6OBPtSCnSDXCKJef+scQifjKKTPFJq3soS6xS1VoQPPuzUcCP3tr8vDIUzuuYw07OviRID82aDVuXjqDQWJL3hTeFKEQw9tE/PgWdGk7P5C48sPuSA09bLhI0dibid3pkC2NpjkN8emJwU76AmdrthPrh9YNrOQrddJi2nMiGfhqM/HjolhAGSIgy0zDqok1qo/m7s2WO9aKN5oCe1d3ovNroHbebvK1/kiCKZspL3335bMWBh/pWqO2fBLPoIwtYWfP2HSLxZWgiA2xeyuamnLMYZlZxIJlb01V1o2mbw0Pw3ET0zt8jsjgWSy+Jn6z9cQx8XK2MpnecMHrJmZP9KKMKkJJjnF9yC92NTOjRFZnG7OtrAOk5OfYTn4ryU62RK6Zsmbt1lTAnyXB2icWZxSK5bfJAlMZnX9AF4JNVgHNCKIGiYPBP/1RYm
 2qlxzvTv
 9/IS00lG4sQoarYKZrVhSpK0/PK+AwpVDFtDeEYTxgESJ/cGHwuN/LwwuLOu6u9FL84VQ0j5A+eIZNNck5w7tAzVslAtYIB7UK+v2A8E3ONnQNzQQRxCuE+xvm4f9v6s55rDe/qRiNjPU9Ozs4EMj0m7xWPcoTp+jvEV4CjQh9UZO+Jl6n9qG8tRlkN/0EFPcX8DUCNhLHlTB64glk9hM/4SaToReKN7QW/nG1fvFbcBOKUVcfPJOY+21npXphdLhk0Nbx29Nj0KeFjJesCuIn5lzMNdrNoBNVi2njQp9gPym8YOW0vN+23dbQCTysCQBAZnpj7G8Y3o5JiqzJ0jRFujep2iS7qE80GGOxyUnVcH0pr/WtdgtlQ2mw4T11l1hu5gP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 04:18, Wei Yang wrote:
> On Tue, Mar 10, 2026 at 03:54:19AM -0700, Usama Arif wrote:
>> During folio migration, __folio_migrate_mapping() removes the source
>> folio from the deferred split queue, but the destination folio is never
>> re-queued.  This causes underutilized THPs to escape the shrinker after
>> NUMA migration, since they silently drop off the deferred split list.
>>
>> Fix this by recording whether the source folio was on the deferred split
>> queue and its partially mapped state before move_to_new_folio() unqueues
>> it, and re-queuing the destination folio after a successful migration if
>> it was.
>>
>> By the time migrate_folio_move() runs, partially mapped folios without a
>> pin have already been split by migrate_pages_batch().  So only two cases
>> remain on the deferred list at this point:
>>  1. Partially mapped folios with a pin (split failed).
>>  2. Fully mapped but potentially underused folios.
>> The recorded partially_mapped state is forwarded to deferred_split_folio()
>> so that the destination folio is correctly re-queued in both cases.
>>
>> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>> v1 -> v2:
>> - record whether source folio was on the deferred split queue before
>>  move_to_folio() (David)
>> - record partially mapped state and update commit message (Zi)
>> ---
>> mm/migrate.c | 17 +++++++++++++++++
>> 1 file changed, 17 insertions(+)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index ece77ccb2ec0..61013d258eb4 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -1360,6 +1360,8 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>> 	int rc;
>> 	int old_page_state = 0;
>> 	struct anon_vma *anon_vma = NULL;
>> +	bool src_deferred_split = false;
>> +	bool src_partially_mapped = false;
>> 	struct list_head *prev;
>>
>> 	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
>> @@ -1373,6 +1375,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>> 		goto out_unlock_both;
>> 	}
>>
>> +	if (folio_test_large(src) && folio_test_large_rmappable(src) &&
>> +	    !data_race(list_empty(&src->_deferred_list))) {
> 
> We usually check order > 1, before accessing _deferred_list, because it is in
> subpage 2.
> 
> I am not sure why we don't do it here. Do I miss something?

Valid point! non-anon folios could trigger that.

-- 
Cheers,

David

