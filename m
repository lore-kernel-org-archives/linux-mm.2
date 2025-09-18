Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2740CAC5A8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2A08E00EF; Thu, 18 Sep 2025 07:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CAD18E0093; Thu, 18 Sep 2025 07:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107F48E00EF; Thu, 18 Sep 2025 07:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F37768E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:10:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F75C1A014A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:10:41 +0000 (UTC)
X-FDA: 83902103082.20.BC6ADDD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4987A2000E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:10:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758193839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9W/35xDyao7Q93HxkG0BcxGfVn+G1OWU71z2k4M7ArM=;
	b=sn0SBtJ4owbgPNeD8DU9I+IWt4cheJW7vbGxWLTH54jrSX8Gz2ccntU8Rro54uFKOKMjht
	jd2WAyTTx0CZ4eDtE/BD849+04/J4YXoHoJnw1DLGATzpc4Sp8UP1yFW/VpdzDPvGxxJEA
	EgpDFjT2gfx8P2HGlkNbnHbTM1bBdK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758193839; a=rsa-sha256;
	cv=none;
	b=VpRjo6MEWhQSqc1byJy8zoUH2c6JRd6hLOoqysH6JBCyuLICOWH7WV3ectpCtUoq4u8iLq
	y8yQVu9GbFVJ8gpMZguL+RmDYpUVvJOxNvKLeZHN7P5CgN7NbtICaT8j+LIemLkYTFoS5u
	f1hfvBov1P2yHJMj8dnM1uTXj5UbP3g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D57A21762;
	Thu, 18 Sep 2025 04:10:29 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7873B3F66E;
	Thu, 18 Sep 2025 04:10:33 -0700 (PDT)
Message-ID: <482fb9e1-7def-48c4-b6b2-e3a5ea2ac36e@arm.com>
Date: Thu, 18 Sep 2025 16:40:30 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 2/2] mm/khugepaged: abort collapse scan on guard
 PTEs
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 kirill@shutemov.name, hughd@google.com, mpenttil@redhat.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-3-lance.yang@linux.dev>
 <f6073afe-a604-485a-8cea-7aa08e46a0cf@arm.com>
 <db182c88-04d6-408a-b36e-a708dc7eb3de@linux.dev>
 <7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8pp4dciyfrqx3iqhj7r8a49ke8njujrq
X-Rspamd-Queue-Id: 4987A2000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758193839-175270
X-HE-Meta: U2FsdGVkX1/D6g0uAl+9//pTJNeHiFJMZtI0+QePuHDM3N8Zz99aXTdJ729tqxLavaGR48lQDZiS9BuPQyyUZUiPm+SvolGAtaeMYB2UF4u5TF7GCDx+XdwIaU3kmt9zPUjPwbv/kgDHpnO0dUd+kHacDYZXm+W/oratnWOrbID1kTvagOOyWOEvGzst3vrBZ7tSDg1zd0+KIR05JMnIc11+Rl73QBjDs0w9G+xjRaqXezvMw+hUD+A/HHJyKCZud5Qg5FV0xq/Viqd+nGWW3sLpZlyAlv92TVGfj/wQ6vf/StWlk0CH4zRtvCnfbGPb5HkZlSrr5+PMKi2rGldsSXZxNxr90aXv4FB99bmloyXvfMQPAas5P5V9+vJYC9shKz7L2XZ+8AsQhJLxiAeV42QL1lfHfah6dVDNvkFaNF3tEZjjxy1XeQDYPf9Ms+aRjpSt4nmgngFBCWVyTZDidfYLUelflqk5XXQmTreuuTA2rtduki9y+XlE/AK5yY8r8sIpW469fbq7NRa+lEQ+mg18UeZVp85Ukn2Csitm6FIdojuLNM7XfRe2JB+rNuLGOJ6EHophR9fSRi3D/Fh3XcFJQOIpwVG2dSnJHNC7HKe1DnsxSBbLnjaW3gSoBWs671uPTZ6Qyye5zdzkK0bMh+TPOkW+ocGzm08d4xmjIvpH0Jym2m7TEIKg0eINCPCMifj2il/KnNReIGsuHXo5pfoaG3GdGvTyHzLB2jSE6kefMQu6r2IremAxLurXPii3ia2h6iKOA2wJkjDexwZSHqYcTUAoxXe1C3Clzpl0BM9Xe9Tbcq76TSiAE7gvEViGYa3SQBsphBtkcapp5/kRXfOPBG286nZIEZHzr4SbQVF4FcME0SANZSMOhXi7Sb1txFqSEwdGsQUZvQgJUzzO+6Hi6C6Oh663L/3Q7zM/qmr79OZJICxCqesUgRq7jCjlCLrrf/fUH/Xm1uBys46
 SguAQUF3
 vYMKQT2hCb4mtwXi4eA2akcquyG9uloOMBfwDtJLmWVuL1owUzgrUfbdPr66sN6k12aHDo6OKuZhKSG1s0+b7+WlZP/CJvBKdMuQs0/RvMmgzW1po5ZXlcBSgDZDIlyXCAPj+gsYOKiQs8L32yk7LIAydBqxZAhMelKuRAzlLbNu0sQIbfMOFGf6NS9fgaQqRzDCOvruCE95NcW9CHWcL7Lv4tORo6TMb1im/at3x4LoEPNg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 18/09/25 3:36 pm, Lorenzo Stoakes wrote:
> On Thu, Sep 18, 2025 at 04:11:21PM +0800, Lance Yang wrote:
>>
>> On 2025/9/18 15:37, Dev Jain wrote:
>>> On 18/09/25 10:34 am, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> Guard PTE markers are installed via MADV_GUARD_INSTALL to create
>>>> lightweight guard regions.
>>>>
>>>> Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail when
>>>> encountering such a range.
>>>>
>>>> MADV_COLLAPSE fails deep inside the collapse logic when trying to swap-in
>>>> the special marker in __collapse_huge_page_swapin().
>>>>
>>>> hpage_collapse_scan_pmd()
>>>>    `- collapse_huge_page()
>>>>        `- __collapse_huge_page_swapin() -> fails!
>>>>
>>>> khugepaged's behavior is slightly different due to its max_ptes_swap
>>>> limit
>>>> (default 64). It won't fail as deep, but it will still needlessly scan up
>>>> to 64 swap entries before bailing out.
>>>>
>>>> IMHO, we can and should detect this much earlier.
>>>>
>>>> This patch adds a check directly inside the PTE scan loop. If a guard
>>>> marker is found, the scan is aborted immediately with
>>>> SCAN_PTE_NON_PRESENT,
>>>> avoiding wasted work.
>>>>
>>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>>    mm/khugepaged.c | 10 ++++++++++
>>>>    1 file changed, 10 insertions(+)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index 9ed1af2b5c38..70ebfc7c1f3e 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -1306,6 +1306,16 @@ static int hpage_collapse_scan_pmd(struct
>>>> mm_struct *mm,
>>>>                        result = SCAN_PTE_UFFD_WP;
>>>>                        goto out_unmap;
>>>>                    }
>>>> +                /*
>>>> +                 * Guard PTE markers are installed by
>>>> +                 * MADV_GUARD_INSTALL. Any collapse path must
>>>> +                 * not touch them, so abort the scan immediately
>>>> +                 * if one is found.
>>>> +                 */
>>>> +                if (is_guard_pte_marker(pteval)) {
>>>> +                    result = SCAN_PTE_NON_PRESENT;
>>>> +                    goto out_unmap;
>>>> +                }
>>>>                    continue;
>>>>                } else {
>>>>                    result = SCAN_EXCEED_SWAP_PTE;
>>>>
>>>>
>>> I would like to hear everyone else's thoughts on
>>> https://lore.kernel.org/linux-mm/750a06dc-db3d-43c6-
>>> b234-95efb393a9df@arm.com/
>>> wherein I suggest that we should not continue to try collapsing other
>>> regions
>>> but immediately exit. The SCAN_PTE_NON_PRESENT case does not exit.
>> Yes! Let's hear what other folks think on that[1].
>>
>> [1] https://lore.kernel.org/linux-mm/c9d4d761-202f-48ce-8e3d-fb9075671ff3@linux.dev
> Since the code has changed let's discuss on this thread.
>
> Dev - You can have guard regions in a range that prevent one PMD from being
> collapsed, I'm struggling to understand why you'd want to abort the whole
> thing?
>
> Your reasoning there isn't clear at all, so if I had a guard region in one
> page in a giant range I was trying to collapse, you're saying we should
> just abort the whole thing?

My reasoning was that it doesn't seem correct that the user will operate in
any capacity on a guard region when it knows it is a guard region.

But, as you say, we then won't be able to collapse a large region in one go
and will have to do multiple madvise() calls to prevent overlapping with a
guard region. So I agree with you.

>
> I really don't understand why we would do that? You just skip over what you
> can't collapse right?
>
> There's no reason at all to assume that overlapping regions here matter, we
> can't predict how users will use this.

True.

>
> As Lance says, it's best effort. And also note we already do this with UFFD
> WP. And note this is also a non-present, PTE marker.
>
> And also this would change existing behaviour which treats this as a swap
> entry then just fails later down the line right?
>
> So yeah I don't agree, I think it's fine as is, unless I'm missing
> something here.

Thanks for your explanation!

>
> Cheers, Lorenzo

