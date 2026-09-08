Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C408C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 05:38:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F213B6B008A; Tue,  8 Sep 2026 01:38:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1E16B008C; Tue,  8 Sep 2026 01:38:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8176B0092; Tue,  8 Sep 2026 01:38:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B12676B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:38:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4400E140379
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:38:24 +0000 (UTC)
X-FDA: 85189489728.03.777BDF6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 205BE100002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:38:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ui0+1jMz;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788845902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKAqucLIpiaQiGlBcG5qw8Y0T29OPfyQkqx31sWDnYM=;
	b=TOCh2qBb+cPM123hnpH1Zt+ncveI6Iqc2kilFTSDEEY24uBoc/Erpjc3aVqE3vNADTPd/6
	XF7WrTuj7bFrRQYaD7kr2JBfLEqP6Kjnr09m64r6sNDn2RbjrONOIoC90kjy4RyW3QO275
	GjtbY8knyYlqfwHWRoG7R+j20XtEZC4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ui0+1jMz;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788845902;
	b=IfB+Eq/25CgZcx1mh95h0aI190MxmpW/YG9UExGh05LY1Iagq4WHUOyNd+SHt0QPpUckix
	ezSh+PBbTMTyEAUrbIiI1N1hIVF1h3Lu7MIxpXxZuQJUPt3UuMU6+7F7HW9T2Py1AkiMoZ
	xt6YOS3rn88nr8pUxzZ5XqNmE79cG/4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F1481476;
	Mon,  7 Sep 2026 22:38:17 -0700 (PDT)
Received: from [10.164.19.55] (unknown [10.164.19.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 49A183F86C;
	Mon,  7 Sep 2026 22:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788845900; bh=9xo2d/f1FvcfQH5bT3nqJ1JKECxz53ZfQJY8y160y1k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ui0+1jMzj/HFyPwLgMd+uu8A17z2Fo19bUnzQ5WOHpHIC0Jrw9bc5Tc/l2+1wFYSM
	 NyY8mzr1NED4iwaPd1f2p1sF/Y9r+rk9+M3NOG6S23iLNBA2sL7TdnAtF4wS4uLCV2
	 ydynjooP7qcvFNkL+EivMXciyB0dfeGzBeCgkWzA=
Message-ID: <8cc0b340-9526-47ac-abd4-3f5724963409@arm.com>
Date: Tue, 8 Sep 2026 11:08:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] mm/internal: rename swap offset helpers to
 softleaf offset
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260901054358.4049095-1-dev.jain@arm.com>
 <20260901054358.4049095-6-dev.jain@arm.com>
 <CAGsJ_4yigbhqkrnufJKC2+rW7StraQvD0gr=4HQkTjKGQ9siGQ@mail.gmail.com>
 <12efdc7f-ff82-412b-b79d-bff211d34218@arm.com>
 <CAGsJ_4y7V40CnTTh=84=Ek6T3tPTyLXsUtgO81O1zyZpmQcbug@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4y7V40CnTTh=84=Ek6T3tPTyLXsUtgO81O1zyZpmQcbug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jskw5a4pf83ujxkkaeisq8qs9nqua8rf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 205BE100002
X-Rspam-User: 
X-HE-Tag: 1788845901-689065
X-HE-Meta: U2FsdGVkX19GY2HsYs5wurCTOHPjlKQBb9w6QIqZaM6p5aIyFJxf9w5qB/jfhwjri7XZWs+8Sqscjuu2ps05UFrNWTbkm0rZ/hkNtUG0pXTqGzUdyKH5SfBBoGaijSCiS5RmcLpV3B524+Ql3VlH4OHRT1E1PECheP8/XJoq/X0HLrn0DS8mlWD+4fx/mok+O/XdTuo1bwCVlDZRNjkR0CdTsMtZvA5J5tY3/do0th7vKUEHGK2fej1gn7ZQVH+erm0klTDrZyO1Hjeq+5vC6C8TXVr+f7F+cYx87cLV/6JyhkE+NviSWH5cm7+CW5owqQ7LwhlMv18u6yrVUZJKPt378HFHOUwOaG3VhMyC8DvaLTDuHZPNMImXLojLXIuL8zsNcXDUbQBfS3777oLVCjBcqah92BrRMhZ9/31XPfJ/o4Sc8m5TDwJ7k1VicND5qeBkLHtxxkOSQ8woGvSGdx/Pth4t1LK0dflG+Dq7C8xoCicokpgHRYVCsrpsMGZJbacLeJHnfbRHtvpMBEJU2wPpT/P46DcpQ5Dg5CAa1BD96Uc6ZEKMCmpwVSYyLJtYE3S34AZevUudrXmTdMKZSLs1Cp35/o9qfQsjUMo40ezWufjzoQegAn2Eg0F3zVn2n6x3L0I1mut+AlColFS9xxcOe2SUe6cl7FpYa5lMivwOBeF0VrZ2e6iIqXzE1E6hjFDOVDZ+1zSnIyOhbYsSOLw65r1feaew19073MTCNdrAt6YUnENSXYYPoJ7nb8tvkp38ILiqGahSZm5d2vmghfaOGq4aIBWN/qhLVS24gW9cc0t7p2GUN7pafoNrdxfNn+bwk5x5wbd7+LuQ2z5UAM8Tuj5Rla/Buhoz839CidKlwWUdD6pfhwB2cS+FY1VbDUs77+O4Qdb7mI+GoUNaDVravL6f8r8NB4MoNBKPpQcnhB2FPZpx+m2S4w05VneDNQnrG9FogZ8Ihbmaeij
 gL/pSWI8
 ALm1gn2Wa8NxFEPPXC4RHqf7BJN4paf3nJRCYQNrWuLlHR3KTYvXdvgyBS/Re/p9To1raoCGQ3fqjzlBCbhdCmwRjDkfLYCJGgd6V6M+1sRXW+XLIPaxIic3XiK9YX1+n51kEJVGF1mvKzpbIS06hkBIIBHiCXAlvmhvV3vGrJyRqyvcflNJCUGMsCy+Ms22petAOD5JUWqMbbPyxZ2Hw4lucxQF2Zku/2dQOGygS18xrFil0cqqgWHwpxL8xYT5XpexQvue2JATjzOXBRFvyBbXREXS70ogH/g1zY+FpI4AjNPbAHNuXo5WkrhE/Mh3vcaXz1XL5aZ9bKxtAQNyMTTszZPeul7ILD5Uhs1ZBuE+7nSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/09/26 3:03 am, Barry Song wrote:
> On Mon, Sep 7, 2026 at 1:38 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 05/09/26 4:12 pm, Barry Song wrote:
>>> On Tue, Sep 1, 2026 at 1:44 PM Dev Jain <dev.jain@arm.com> wrote:
>>>>
>>>> In preparation for adding a helper to set softleaf ptes in one go,
>>>> generalize the swap entry helpers shifting the swap offset by delta,
>>>> for softleaves.
>>>>
>>>> Note that the soft-dirty bit, exclusive bit and uffd bit preservation
>>>> will still work for non-swap softleaves, since a softleaf entry is
>>>> constructed out of a type and offset, and those bits are ahead of
>>>> the soft-dirty, exclusive and uffd bits.
>>>>
>>>> For example, for a migration entry, pte_swp_exclusive() will return
>>>> false, as the exclusivity is encoded in the type itself
>>>> (SOFTLEAF_MIGRATION_READ_EXCLUSIVE).
>>>
>>> I don't quite understand why you mention this. Is anyone calling
>>> `pte_swp_exclusive()` on a migration entry? Shouldn't it only be called
>>> when `softleaf_is_swap()` is true?
>>
>> You are right. I just wanted to emphasize the second paragraph - that the
>> pte_move_swp_offset will also work for softleaf entries. But I think
>> the third para confuses more, I'll drop it.
> 
> I would rather interpret this as meaning that
> `pte_move_softleaf_offset` will also work for swap softleafs,
> since `pte_move_softleaf_offset` will call some pure-swap
> functions？

Yes, so if you see remove_migration_pte, there pte_swp_uffd and
pte_swp_soft_dirty are being used. Same with restore_exclusive_pte
(for device-exclusive stuff).

Which means that pte_swp_exclusive is the only one being used
*only* for swap entries.


> 
> Would it be possible to use `if (softleaf_is_swap())` for
> these cases to make the intent clearer? or we can
> keep both pte_move_softleaf_offset and pte_move_swap_offset?

So in my patch I can do

if (softleaf_is_swap(entry) && pte_swp_exclusive(pte))

That would make the intent clear.


> 
> As `pte_move_softleaf_offset()` is getting a bit weird now,
> a generic softleaf function has a lot of swap-specific code in it:
> 
> static inline pte_t pte_move_softleaf_offset(pte_t pte, long delta)
> {
>         const softleaf_t entry = softleaf_from_pte(pte);
>         pte_t new = __swp_entry_to_pte(__swp_entry(swp_type(entry),
>                                                    (swp_offset(entry)
> + delta)));
> 
>         if (pte_swp_soft_dirty(pte))
>                 new = pte_swp_mksoft_dirty(new);
>         if (pte_swp_exclusive(pte))
>                 new = pte_swp_mkexclusive(new);
>         if (pte_swp_uffd(pte))
>                 new = pte_swp_mkuffd(new);
> 
>         return new;
> }
> 
> Am I missing something here?
> 
>>
>>>
>>>>
>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>
>>> Reviewed-by: Barry Song <baohua@kernel.org>
>>
>> Thanks.
>>
>>
>>>
>>>> ---
>>>>  mm/internal.h | 29 +++++++++++++++--------------
>>>>  mm/memory.c   |  4 ++--
>>>>  2 files changed, 17 insertions(+), 16 deletions(-)
>>>>
>>> [...]
>>>>
>>>>  /**
>>>> @@ -523,7 +524,7 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
>>>>   */
>>>>  static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
>>>>  {
>>>
>>> We might find a user for this in the future, in which case we might
>>> want to rename `swap_pte_batch()` to `swap_softleaf_batch()`?
>>
>> That is what is being done here:
>> https://lore.kernel.org/all/20260813-migrate-rmap-batch-v2-1-3c5424c555c7@amd.com/
>>
>> I don't have a strong opinion, I can also generalize this right now.
> 
> I don't know how you and Shivank are collaborating,
> since you're both changing the same thing at the same time :-)

We are not collaborating really : ) he should have ideally waited
for my patchset to go in first since I was doing big changes in
rmap.c.


> 
> Hopefully, we can get one of yours into mm-new first,
> and the other one can find a way to resolve the conflicts.

Yes.


> 
>>
>>
>>>
>>>> -       pte_t expected_pte = pte_next_swp_offset(pte);
>>>> +       pte_t expected_pte = pte_next_softleaf_offset(pte);
>>>
> 
> Best Regards
> Barry


