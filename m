Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 702B9E9E305
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 13:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D7F6B0005; Wed, 11 Feb 2026 08:42:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10EA6B0089; Wed, 11 Feb 2026 08:42:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D9F6B008C; Wed, 11 Feb 2026 08:42:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A0CF66B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:42:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5388C1B36F8
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:42:31 +0000 (UTC)
X-FDA: 84432290502.26.A84F1FA
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 59EBF140003
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:42:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PZLy2fAq;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770817349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3Ctt+BiEBkUfTwW8vlPQdhY++dZ5Wjo7IuFQ8gmzwY=;
	b=Kdo7RQpPE+RUaZUKKYyGq32A2mm9Bsk1tcAFr2Q458vhK9VNN/D3TlKdURMJT7ZwX+Bs5M
	dYZvNGFDCE7FdMfErf1zcM6bvaDXfzhbt1SZxImlAvE025I/ow753Eq8SdTI2Cli1KL/I/
	rwNGpxVgaXkXs3txCJ6h7IiSugP4Rtk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PZLy2fAq;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770817349; a=rsa-sha256;
	cv=none;
	b=eDMDgCNwRIFGVsjXk1FSIz+v86BmxMWMhjx8lU0C+SdXZ5ssAqeV8FHPkj33ogBKt5lyU1
	3KJb/lWC8STjgPqS1k4L75Cp3Hyw87JY+IN9PotGi7hQIkzkDbi6wXfafsuoDScY0CVQ6f
	u+7HtFtPkk6vPP+hgecHuTVEPpka+8A=
Message-ID: <bc39dc5c-7156-4c0b-872c-ecc9d5c15358@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770817346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R3Ctt+BiEBkUfTwW8vlPQdhY++dZ5Wjo7IuFQ8gmzwY=;
	b=PZLy2fAqbqesw3HRJoMeWdo09ZsfG4IbsZCabZm/x/dmHKuE07rUE875NaY0R0exilxmbe
	BR6sfse3m1uaie7xcnyAXn15a0XlBkSLUMhfhVcfwFmjR84hEotHsegk+XOQ/Td3L6dF8V
	8P9hCFWIHnxE9kmcg2b+wvOTHHp5T0Y=
Date: Wed, 11 Feb 2026 13:42:24 +0000
MIME-Version: 1.0
Subject: Re: [RFC 2/2] mm: thp: add THP_SPLIT_PMD_PTE_ALLOC_FAILED counter
Content-Language: en-GB
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
 willy@infradead.org, linux-mm@kvack.org
Cc: fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260211125507.4175026-1-usama.arif@linux.dev>
 <20260211125507.4175026-3-usama.arif@linux.dev>
 <b980ef1c-2dc2-4853-a873-7338e2d36178@kernel.org>
 <7790f69d-7406-4535-994b-8f4b240269ba@linux.dev>
 <c722e14f-a16f-439c-92f0-1318fae2cf4c@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <c722e14f-a16f-439c-92f0-1318fae2cf4c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: dp9abyarjzg91xx44gzm7growrjeknoo
X-Rspamd-Queue-Id: 59EBF140003
X-Rspam-User: 
X-HE-Tag: 1770817349-461361
X-HE-Meta: U2FsdGVkX1/COc6inoalmGSRv+GO+81eW5S3QQttFpyFgKwSNh05h2J2pcye3NyJJ7bmTvXrTC+GbXjwWXkKCOILG4jQCqXtKOhg4XRPZkdQFcY2zmNTcKj0xDFdm1FT9yyPrOIIQJ7xIro1rkDW2oEnG+D4bdr8pVXCwfUaiK1WJn6mYitNWCRFaqs0ElSSB8OEfLlOSyWEtR+4y1iBA1c8Vjf09dXCBF/gYEIWP7pq6vlIMiHp2ZRfP+NXAUOOtyKlrJTdmUpMieXmRcMlYiOl4FCWoFQiHbkzTwyD2trJW/QhlemLoPmPbjTfIKFcVtCBVrSbGmx+sGsmEX8i+0r6eXHt20XCeH13yG6cjkHuf+4Q3Zh6BRQoxZEU5Ys3V2fZDg2ssXsAEN5/dRl4zHOPZkimDoU6lzIyYwuAtHF/mwsvXKO3UlOfC99WG/bwhMAKHR1IjO6aqwN8ISi1erPV9k6p2eIAzkTsdStkyQUb8i1wzNX7+AlUawqkt/g0FdEW2+l0wp7TEatW+xfYcrAN7SJl2kUtKyPKwF3JQWycMDYHXnZ1/uG87GFUETGceZm3UEchV+4S7NHbTpFXoqAKacY5gHJb7IHPZKbiKOhsQ/di9e7e5mkpplbkg9uekMmcPB6fIX0k5cUe7d/dFpiUHZiVOzN7rSFnnbZ+kmexhQTHxrMBIlvYupuhfDWWluDZc/ayCTmkXcR5F4WNXE/KHreYiPyqQfJ+AfttCzAkvlZHA0r/NUQz0BCzQVfFb37pD+XrfQS8Us1p8eMyECsQ96NgwH5983fyvSoB4RJOmMrXxiTe0P6nH8ztBW86lpKOwZrbikhyJPwjdiPtdl18CIgSx1RoSRR6JvEwGQrJa9ghJdWEs396Mr27yJtSi7pF0JdTe6IqZ9wKbVh1vXMVolDIlr9LqhF8CeEUnbBqwuauDY4+Vb4x+87NfiUCIR844TApvjjtVyWvppO
 O2xRSvYQ
 oKrcGGkmKRkoYZZhUUxOOL1+FFSAmHPFafyuI0xEGRUEaSSKZSqmcamFiLgeywk1wwpAZUoUbQf+fQIRqZYyQvoWtB8Hp5xffpDHx410KbA8/YIF0LuMvGkPvziyLjXcH0t+ZZWUMH8BBrBKYQXMRxJtDy0pEJlZ7k3W1qhL3lhZqup9FBU1UzOuYAI3X3g8R5Cm8ap5VhVqL+9TxtSZw6hYruUlvuNTFBm2IYyjmWieSjuh6lRTLKyGB0iLiP2hXZ31QQ/gtuIPLrzWYuWLAi0pBbMFnuwbd5SFm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/02/2026 13:36, David Hildenbrand (Arm) wrote:
> On 2/11/26 14:31, Usama Arif wrote:
>>
>>
>> On 11/02/2026 13:27, David Hildenbrand (Arm) wrote:
>>> On 2/11/26 13:49, Usama Arif wrote:
>>>> Add a vmstat counter to track PTE allocation failures during PMD split.
>>>> This enables monitoring of split failures due to memory pressure after
>>>> the lazy PTE page table allocation change.
>>>>
>>>> The counter is incremented in three places:
>>>> - __split_huge_pmd(): Main entry point for splitting a PMD
>>>> - try_to_unmap_one(): When reclaim needs to split a PMD-mapped THP
>>>> - try_to_migrate_one(): When migration needs to split a PMD-mapped THP
>>>>
>>>> Visible via /proc/vmstat as thp_split_pmd_pte_alloc_failed.
>>>>
>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>> ---
>>>>    include/linux/vm_event_item.h | 1 +
>>>>    mm/huge_memory.c              | 1 +
>>>>    mm/rmap.c                     | 3 +++
>>>>    mm/vmstat.c                   | 1 +
>>>>    4 files changed, 6 insertions(+)
>>>>
>>>> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
>>>> index 22a139f82d75f..827c9a8c251de 100644
>>>> --- a/include/linux/vm_event_item.h
>>>> +++ b/include/linux/vm_event_item.h
>>>> @@ -111,6 +111,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>>>>            THP_DEFERRED_SPLIT_PAGE,
>>>>            THP_UNDERUSED_SPLIT_PAGE,
>>>>            THP_SPLIT_PMD,
>>>> +        THP_SPLIT_PMD_PTE_ALLOC_FAILED,
>>>
>>> Probably sufficient to call this THP_SPLIT_PMD_FAILED and count any (future) failures (if any) as well.
>>>
>>
>> Makes sense. This was just a patch I was using for testing and I wanted to share.
>> It was always 0 as I couldnt get split to fail :) But I can rename it as THP_SPLIT_PMD_FAILED
>> as suggested and we can use for future split failures (hopefully none).
> 
> I guess it might be reasonable to have because I am sure it will fail at some point and maybe provoke weird issues we didn't think of. In that case, having an indication that splitting failed at some point might be reasonable.
> 
ack


