Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C29CCD18C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 01:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3156B8E0003; Sun, 12 Oct 2025 21:48:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6D58E0002; Sun, 12 Oct 2025 21:48:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC3C8E0003; Sun, 12 Oct 2025 21:48:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CA588E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 21:48:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95A981DE54E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 01:48:49 +0000 (UTC)
X-FDA: 83991407178.08.B75E7E9
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9BBAA14000D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 01:48:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bXX03/8s";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760320128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gj2RUXsmZP7PFmKR9Hbs9L37/EeDx8LOSN13TezBQY=;
	b=IV3fhncZlbitPxMvwyZsC382zwWl4h8TlVccitC7XLfAwPA+RL2/XZLD+kq2OE+Q8Hrm7i
	4q9FhA5xB14sq9ofnOPk/+xZNxY9XLdwh9llPvIOeucziJDb8GZgbQoCTvrVznkS7Nf5Su
	0WQNoiP8Vyzhy3J1sIQdgCx8qKd+tNc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760320128; a=rsa-sha256;
	cv=none;
	b=u/Mwj38NAvEBZD7R1on18Lmm+B2gdvRBQXLjkTLMxpS0alt1PB6toQSqlj2I3hNt0YPzze
	H/SPCjj3gb/kp9Z0nVO9TFYdz56NBaf7RYoFoBLbg6yMhFbp/fvQxOZ8XoMjHihY5WLC8V
	zeTPrkeD6xRkxJSuyYl8po2a94lEh8A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bXX03/8s";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <83492e9c-3f17-42e5-8897-9c0ed5aa76e7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760320125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8gj2RUXsmZP7PFmKR9Hbs9L37/EeDx8LOSN13TezBQY=;
	b=bXX03/8sypLzEqxjMgSLg6S6KJ4kx88F2oJNJoY6wtz8ODzWzwFRiwv3G4HvihQLWuiaDt
	q+Ms2lDX8Ihlvl+anmvX0mKnUGSooXoDL0DkZ2LxLt38QiCGv6rOwsg2pSk49MIw/U8I2i
	UYzxgrVRyXndoEgLT2uTa1/GMhKbM2I=
Date: Mon, 13 Oct 2025 09:48:35 +0800
MIME-Version: 1.0
Subject: Re: [v7 03/16] mm/huge_memory: add device-private THP support to PMD
 operations
Content-Language: en-US
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, akpm@linux-foundation.org,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
 <20251001065707.920170-4-balbirs@nvidia.com>
 <CABzRoyYg1o8Oyjx1AQ8or-Vxm94zQXeAx7mWco2qs7=w4mBcMw@mail.gmail.com>
 <1b311458-957a-4f0d-b7f9-51e75bbabd55@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <1b311458-957a-4f0d-b7f9-51e75bbabd55@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BBAA14000D
X-Rspamd-Server: rspam02
X-Stat-Signature: ub3tmxkyckf9h9ue1id8zfqoesaxb4qo
X-HE-Tag: 1760320127-213406
X-HE-Meta: U2FsdGVkX1/V4GR8lFl6Uahr0JNZIo31dKTsv9s0t0MJCHx3Y6y+3bkpxixqClgUG2E++2a0HmkoroqB9I4mRkBIhwaNEV/Kas+GRVDaVJvU7KFs8Vd2HDq3h1oObJIg5My/diiwGbQfw1ERG3Yc+ND/yv6JbU3hdmw1OwBtaKic9GWv3ijtj3X70nenj2DBSwHwtriwqv4Cia5Gfqmqd0OVD5VwFg+Eb+XWL5/X/uoE89Sqy5ha+Le+zRBM0nCxypFlw+dNcQSWtj6lIcSc6Frl9e+6DPqhUk7E/o3BnrsvEER5tOlM03YkPEvTIbxWr8JUZcMHbIaRRQ2tLx1VEFwSUdHs9gyf6R01sKka64aAr2uGChrXpbSBqlksBGdaPmLllF/RmFzJNkd4f6mAkiJ5nvzslDsupC6j2j+vDjHD0QDTDCC1KR1Y667arasssGEBZ+hsuRlvMp+RAlL1DqUVeH84s42tfev2BTUrMq8aeoLeg1YpN9YRjVupktpoeXia8FSmhy4zabzcetcu30a+QskwFwl3q18rsUU7URXjj0nHGJ/1qpUBtsMmVnLmOtZe1rxmwkM8yTCDyXC/1eU9q8LCylYf4YxFMb6ZcUcVBFmZvMnuqZjadaDxqofAbIiMQrYqgkmvfwk+KdMatFU1Rv5Ndiaz33XyTK0D57+lBwMjF5L96vcu5XPrHNWGOxraqNrYSXyn2qZLhLK7hJQ+G4aHKaMGivjuqmKofB82vcyviLua+TCAwQCYMMIxo1OmSZt+NprdqN9ZSQyjLDgEiajAMLec7vycQmc7Yirp8pv7/uvS6wQqjo0C/lhlSV6MElbAUZfq1XVuV8z9Y423l2AXuxNEIw4OqcPtmBvfenzClGgi0DQJ3tCkk6VP2PBQCR9bu0p/Zj/gNDPf1xQhSDzd2w1A16Ilu3sVrS6br4JjtcfNme8BW8IlIVPdiVfiu+pnEO6789JSMbS
 kFU035Ap
 Ry6wIMdImfJhFnHB1RwpUoTKuYMKYeZ5bLT0fT8kbkIuIIVP7UUBOAhDRurphXR9zm9udr0q21ABmjT4TgfrZIPwhABeBzj77YJVefQM6LFJOM5+sPRwxJcOV/9M17Pj4rzHysTmKZ77VyzCrc1sZeS1qRY6k9SU2JdNznMRyvxiVboAvGYPgFCZQiUpoJ2tBdU1pWMZ8ktYbcCuHtGfruJXSBt4Z8uf2j568fgED15R2FpEKL0FVl2q52iAdaPLpiqe6ZmKZC+brlDBb/mXa696IP4yw/CL6KfNyn6EgaQ43jMxcdo/6fQbnMOzqHMfQiAtFql3BMyfICrivTcOGlIQgG8U7rruyQSZ4cWyf+/1rzlqMYHUZTn3o1BzoaAEUartv+6b8OGFhcbVZKZluYqmeeXZri7s1JO3kVPlraD9AhiSY+t6GuY2WM1q7T/x6D7ImAhEljWc/nGjV0HRad5b80Dwe/2tIxxk7XFAHvussfx3kpN9XX7kyyiNB02wIz8KA4N9DgHOPX44WWeUxmHlVbpYST21gIyiK3rW+gIV5oJlYcyl7RXHXVwmDt+VDAMSuxz8Ttf+ksTCDIxxpci+lpnCp7Z4zHR+Qacm8b0hOS6e33jdjRehEUsCRTnmXbvQgZIB+jggpGIDqd8WAulYeEH4JdR+WyYV8fvgziIdbMlVGLPkZ3Belsg/nJNYO9j5rPbkuaer60K4jfGZZKaVQ8asHnVmi7ptmIh1LYDSGv3PUUM22BjqRd5Phhkr1nKkOePzK8srlK5fp7KNBHZw0tvp0Rk7vwer6q2IZgvhJiLphB6t5wfKRUTzUXdV3j1cEBSj2yxFMQ9nV8qkfiHrRjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/13 08:01, Balbir Singh wrote:
> On 10/13/25 02:46, Lance Yang wrote:
>> On Wed, Oct 1, 2025 at 4:20 PM Balbir Singh <balbirs@nvidia.com> wrote:
>>>
>>> Extend core huge page management functions to handle device-private THP
>>> entries.  This enables proper handling of large device-private folios in
>>> fundamental MM operations.
>>>
>>> The following functions have been updated:
>>>
>>> - copy_huge_pmd(): Handle device-private entries during fork/clone
>>> - zap_huge_pmd(): Properly free device-private THP during munmap
>>> - change_huge_pmd(): Support protection changes on device-private THP
>>> - __pte_offset_map(): Add device-private entry awareness
>>>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>> Cc: Byungchul Park <byungchul@sk.com>
>>> Cc: Gregory Price <gourry@gourry.net>
>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>> Cc: Alistair Popple <apopple@nvidia.com>
>>> Cc: Oscar Salvador <osalvador@suse.de>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>> Cc: Nico Pache <npache@redhat.com>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Dev Jain <dev.jain@arm.com>
>>> Cc: Barry Song <baohua@kernel.org>
>>> Cc: Lyude Paul <lyude@redhat.com>
>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>> Cc: David Airlie <airlied@gmail.com>
>>> Cc: Simona Vetter <simona@ffwll.ch>
>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Acked-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>> ---
>>>   include/linux/swapops.h | 32 +++++++++++++++++++++++
>>>   mm/huge_memory.c        | 56 ++++++++++++++++++++++++++++++++++-------
>>>   mm/pgtable-generic.c    |  2 +-
>>>   3 files changed, 80 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
>>> index 64ea151a7ae3..2687928a8146 100644
>>> --- a/include/linux/swapops.h
>>> +++ b/include/linux/swapops.h
>>> @@ -594,10 +594,42 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
>>>   }
>>>   #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>>>
>>> +#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
>>> +
>>> +/**
>>> + * is_pmd_device_private_entry() - Check if PMD contains a device private swap entry
>>> + * @pmd: The PMD to check
>>> + *
>>> + * Returns true if the PMD contains a swap entry that represents a device private
>>> + * page mapping. This is used for zone device private pages that have been
>>> + * swapped out but still need special handling during various memory management
>>> + * operations.
>>> + *
>>> + * Return: 1 if PMD contains device private entry, 0 otherwise
>>> + */
>>> +static inline int is_pmd_device_private_entry(pmd_t pmd)
>>> +{
>>> +       return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
>>> +}
>>> +
>>> +#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
>>> +
>>> +static inline int is_pmd_device_private_entry(pmd_t pmd)
>>> +{
>>> +       return 0;
>>> +}
>>> +
>>> +#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
>>> +
>>>   static inline int non_swap_entry(swp_entry_t entry)
>>>   {
>>>          return swp_type(entry) >= MAX_SWAPFILES;
>>>   }
>>>
>>> +static inline int is_pmd_non_present_folio_entry(pmd_t pmd)
>>> +{
>>> +       return is_pmd_migration_entry(pmd) || is_pmd_device_private_entry(pmd);
>>> +}
>>> +
>>>   #endif /* CONFIG_MMU */
>>>   #endif /* _LINUX_SWAPOPS_H */
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 1b81680b4225..8e0a1747762d 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -1703,17 +1703,45 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>>          if (unlikely(is_swap_pmd(pmd))) {
>>>                  swp_entry_t entry = pmd_to_swp_entry(pmd);
>>>
>>> -               VM_BUG_ON(!is_pmd_migration_entry(pmd));
>>> -               if (!is_readable_migration_entry(entry)) {
>>> -                       entry = make_readable_migration_entry(
>>> -                                                       swp_offset(entry));
>>> +               VM_WARN_ON(!is_pmd_non_present_folio_entry(pmd));
>>> +
>>> +               if (is_writable_migration_entry(entry) ||
>>> +                   is_readable_exclusive_migration_entry(entry)) {
>>> +                       entry = make_readable_migration_entry(swp_offset(entry));
>>>                          pmd = swp_entry_to_pmd(entry);
>>>                          if (pmd_swp_soft_dirty(*src_pmd))
>>>                                  pmd = pmd_swp_mksoft_dirty(pmd);
>>>                          if (pmd_swp_uffd_wp(*src_pmd))
>>>                                  pmd = pmd_swp_mkuffd_wp(pmd);
>>>                          set_pmd_at(src_mm, addr, src_pmd, pmd);
>>> +               } else if (is_device_private_entry(entry)) {
>>> +                       /*
>>> +                        * For device private entries, since there are no
>>> +                        * read exclusive entries, writable = !readable
>>> +                        */
>>> +                       if (is_writable_device_private_entry(entry)) {
>>> +                               entry = make_readable_device_private_entry(swp_offset(entry));
>>> +                               pmd = swp_entry_to_pmd(entry);
>>> +
>>> +                               if (pmd_swp_soft_dirty(*src_pmd))
>>> +                                       pmd = pmd_swp_mksoft_dirty(pmd);
>>> +                               if (pmd_swp_uffd_wp(*src_pmd))
>>> +                                       pmd = pmd_swp_mkuffd_wp(pmd);
>>> +                               set_pmd_at(src_mm, addr, src_pmd, pmd);
>>> +                       }
>>> +
>>> +                       src_folio = pfn_swap_entry_folio(entry);
>>> +                       VM_WARN_ON(!folio_test_large(src_folio));
>>> +
>>> +                       folio_get(src_folio);
>>> +                       /*
>>> +                        * folio_try_dup_anon_rmap_pmd does not fail for
>>> +                        * device private entries.
>>> +                        */
>>> +                       folio_try_dup_anon_rmap_pmd(src_folio, &src_folio->page,
>>> +                                                       dst_vma, src_vma);
>>>                  }
>>> +
>>>                  add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>>>                  mm_inc_nr_ptes(dst_mm);
>>>                  pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
>>> @@ -2211,15 +2239,16 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>>                          folio_remove_rmap_pmd(folio, page, vma);
>>>                          WARN_ON_ONCE(folio_mapcount(folio) < 0);
>>>                          VM_BUG_ON_PAGE(!PageHead(page), page);
>>> -               } else if (thp_migration_supported()) {
>>> +               } else if (is_pmd_non_present_folio_entry(orig_pmd)) {
>>>                          swp_entry_t entry;
>>>
>>> -                       VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
>>>                          entry = pmd_to_swp_entry(orig_pmd);
>>>                          folio = pfn_swap_entry_folio(entry);
>>>                          flush_needed = 0;
>>> -               } else
>>> -                       WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
>>> +
>>> +                       if (!thp_migration_supported())
>>> +                               WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
>>> +               }
>>>
>>>                  if (folio_test_anon(folio)) {
>>>                          zap_deposited_table(tlb->mm, pmd);
>>> @@ -2239,6 +2268,12 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>>                                  folio_mark_accessed(folio);
>>>                  }
>>>
>>> +               if (folio_is_device_private(folio)) {
>>> +                       folio_remove_rmap_pmd(folio, &folio->page, vma);
>>> +                       WARN_ON_ONCE(folio_mapcount(folio) < 0);
>>> +                       folio_put(folio);
>>> +               }
>>
>> IIUC, a device-private THP is always anonymous, right? would it make sense
>> to move this folio_is_device_private() block inside the folio_test_anon()
>> check above?
>>
> Yes, they are, there is discussion on file-backed mapping at
> https://lwn.net/Articles/1016124/. I don't see a benefit from moving it, do you?

Ah, I see. Never mind :)

Cheers,
Lance


