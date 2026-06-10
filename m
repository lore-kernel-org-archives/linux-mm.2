Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B78AECD8CA8
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 02:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E094E6B0005; Tue,  9 Jun 2026 22:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBA606B0088; Tue,  9 Jun 2026 22:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCFD26B008A; Tue,  9 Jun 2026 22:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8FCD6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 22:10:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D5BE1C2A33
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 02:10:50 +0000 (UTC)
X-FDA: 84862374660.09.9D8890D
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 79B24140009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 02:10:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YZc8iYLm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781057448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1WcCUjQkrpK9ZWAZN05MiNwQO2ME50pCdKbF3ttu3U=;
	b=8eeVmGYwKHlbqghKJSdZMCr9rixXzRupse+3V5f+cvQ3IH0zYCPER4+4MeTkQKdQe5AN+e
	QG6osO60c8shworAGUH2O0BvBy8Ha9Qa7cYW8W35bHdqOM898vjF/kzIICPaNWLek6rosN
	Yloh5TGPsbF5qDYkPGK/Fmn7SaKpki0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YZc8iYLm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781057448;
	b=eH+tQM6kzGg1oqVYWSVsTF8KkaoDircg/EBIfN60WfaAD8d7gLd1j6u0Zk+NLsHuGh8m+t
	6X9DFJ1SN9lIVEy4n5s1xYzWEEzhtAVIgbGd3Cu2NbCnVCd6ocrD4IEiSvA2gC9n+Di49Z
	pUxnDDiE0+ZPaTGqSGdfLzzzxYDZZ9M=
Message-ID: <0814499d-f758-49cd-ba24-6549fc5b8906@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781057446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p1WcCUjQkrpK9ZWAZN05MiNwQO2ME50pCdKbF3ttu3U=;
	b=YZc8iYLmWxTVo9WJUGXSO5mWH2P032QOR4X4eXjsmDIY7cTTbPLkQiE/AWQJ7Xd3CQxrBL
	PqdOpyeMsgMnI+ZLEBRCAVN8YRDC95V6T1IpROCDeq98fw/5U2mLSfSBBOKcM9g4YOjHmm
	7peqTREkHmtMhapijFKhY67imQ2S07k=
Date: Wed, 10 Jun 2026 10:10:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap PTE
 accounting
Content-Language: en-US
To: Nico Pache <npache@redhat.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260609120443.71864-1-lance.yang@linux.dev>
 <7d081256-5b30-4e3c-b948-85ba76ad0e1d@kernel.org>
 <CAA1CXcD83db7L0K3F1qndP1CeAaYHK8Sy2TNTi8RJXnrdvf6HA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CAA1CXcD83db7L0K3F1qndP1CeAaYHK8Sy2TNTi8RJXnrdvf6HA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 94rkxj9y6t14dtxcoab49141ckbg1aky
X-Rspamd-Queue-Id: 79B24140009
X-HE-Tag: 1781057448-584850
X-HE-Meta: U2FsdGVkX195sBnkVaWCCHFKzQQw/JbB30GW2rk1ZcWjG8iEls6hEJD6mRCuFltsQbPjq+tPbmLzyGq9aAIp4/kEJqhGLl6+LhssqTTiUZDbd/USzv07K2+SiVbIxqzDxrbt2WvLTd2/Fq2IXlkJI0Xq4rqMX2NYTDOWxTCO6UslAARO9BB1K3g390RY68pNJXdvgMvfLAEIJ8xG7A6GopiDARUejtEVx+sOG/cQiCjY9YT+rvkFtqVn2hWaixpDSDF5kNAUvXq9UqLJZ1Tz6ZakbFUk5at+96A4s4N8kFBY0f5P1sAFcOq5ljkxgIjg+0yPioZParKI45ULU9CRSCS/lzzPSAfwGvlRro8/6ELysCf2azt6D7ZlaG6hW1ecViJZ+FGGSemHqAM2e7ZDP28pBglsE1ELigiVinwl5MTBPVByfDxExWphj8GQvaPAGMgdxSKjlBFsHhf/Rj2/LnzGgNWhTl9UV/tPKBUHSywJXsWV+HFa8chbRctdH/wJbb47KoyvbdVRSgRudB/zHyYJL69GU+8amOYAUHaT7smN2m4SXJVQZj49n8JAGS5j8p8DdYZfzDjJlRLlpLIoyas1aEeWeqdVl6wNFTm/RVokAJIOYHj/mWgg6TY86zQLbwe/j4U83+wy39P44LKutmo2AK4Bo1qMzX+cN4Mjcrr51qMMX9Fncp0wJEOjCYgyqeGn/5mOeY8Gv+GZQXgLd/lF9hViHj3hmU1V9IB4K8zDKfGriLU2E1IOZLQrbt9WtgoWBnOvw+hJSx6TIexEvXYmStT6zDyzzkSfJKq/jvrhHROLn3KeUCBdrKPmFN1qUkhevs/Kd011lplzkCwwc+XVijaYXP8qR8LJi8Ubugtv7y6k6cnqh215b8eXf00zZ7J/i0fg43y7r+zdEJv4cjf2C1lzL2e2Sf4Dm2SZoIgA1ZltG8vbuMeYMt9HF+P6wupe+oAki5XPymAm0+8
 multoS7V
 OtwaU5fW0kH4ZwzxJ8jsnp3wlUEYtxav4TZuxlbQJmsvpe+GbTxHUHhlPlPuifUqq8NVgRWAJe5q8KixtQ/tx63S8p2qIDYwjdpLzGpGprWJPti1xN09obYfGDm0fBpwZf1BqE75FR/X3/zEvwZ6D9Z/7OLOMrqy8IL5svl/yTbYGBl6XIAkSeU8M3jaxIJwgJ4PkuWhcyvkSEajVppr0qCdPn8xqc3UWmUyLNorT71C2xtnVLaw2QPSr86DWYukuQdXHbIjKv3etQ45NOLCOocGJ9qfKrwdjeMNy/flw/bqXhxj0e4/Vc4JSIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/10 01:04, Nico Pache wrote:
> On Tue, Jun 9, 2026 at 7:16 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 6/9/26 14:04, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> mthp_collapse() uses mthp_present_ptes to decide whether a range has
>>> enough occupied PTEs to try collapse. Swap PTEs accepted by
>>> collapse_scan_pmd() are counted in unmapped, but are not represented in
>>> mthp_present_ptes.
>>>
>>> When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_none
>>> so the scan can cover the whole PMD and build the bitmap. mthp_collapse()
>>> then checks the PMD-order candidate using the bitmap.
>>>
>>> With max_ptes_none set to 0, a range with 511 present PTEs and one swap
>>> PTE no longer reaches collapse_huge_page(), even though PMD collapse can
>>> handle swap PTEs up to max_ptes_swap.
>>>
>>> Account unmapped PTEs only for PMD order. PMD collapse supports swap PTEs
>>> through max_ptes_swap, while lower-order mTHP collapse does not currently
>>> support non-present PTEs. Keep non-present PTEs out of the lower-order
>>> eligibility check.
>>>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>> Sent separately, as discussed in [1], to spell out the PMD-order swap PTE
>>> case. Patch [2] is still only in mm-unstable, so no Fixes: tag.
>>>
>>> [1] https://lore.kernel.org/linux-mm/CAA1CXcD7WAiA1b9GTLAuNZ+kHaFx0SzZwpBkqAZ=s+RHsTUaow@mail.gmail.com/
>>> [2] https://lore.kernel.org/linux-mm/20260605161422.213817-12-npache@redhat.com/
>>>
>>>   mm/khugepaged.c | 8 ++++++++
>>>   1 file changed, 8 insertions(+)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index b12187709f6d..617bca76db49 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1508,6 +1508,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>>>                nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
>>>                                                      offset + nr_ptes);
>>>
>>> +             /*
>>> +              * Swap PTEs accepted during the scan are counted in @unmapped,
>>> +              * not in the present-PTE bitmap. Account them for the PMD-order
>>> +              * candidate.
>>> +              */
>>> +             if (is_pmd_order(order))
>>> +                     nr_occupied_ptes += unmapped;
>>> +
>>
>> LGTM, there is a bit of opportunity for cleanup in the future :)
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>>
>> For example, as we no longer have the VMA here, collapse_max_ptes_none is
>> imprecise in uffd VMAs. We might try collapsing where there sure is nothing to
>> collapse.
>>
>> We could likely handle the userfaultfd_armed() part easier: some indication that
>> we must not have any pte_none() would be sufficient.
>>
>> Also, I don't see a good reason why uffd would not be allowed to collapse with
>> zeropages ... it's really just about missing faults due to pte_none().
> 
> I have some patches exactly for this :) so far 2-3 patches for better
> uffd handling

Neat, I'll leave that to you then :) Looking forward to seeing
those patches!

Cheers, Lance

