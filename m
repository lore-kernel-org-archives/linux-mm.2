Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12E87C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1530E6B0095; Wed, 14 Oct 2026 14:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B406B0098; Wed, 14 Oct 2026 14:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0401D6B0099; Wed, 14 Oct 2026 14:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D11E16B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:44:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47EEA1C3E25
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:44:26 +0000 (UTC)
X-FDA: 85322107332.01.87FA5D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6F5B21C0003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:44:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kjAPCYaW;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792003464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g6JScfSsWgesg/1WtK9RTmCPMl1xA6BFFNt/w568P2w=;
	b=6bd41TvdJxLXzrtLm1Nn1RfUO2LVTcmn31SJvaT4T0U7AmfWPpbHQ4nBPrOJqEPXgSI+FF
	qqKypwfRhJlsVbf8rIS8uXFAuH8/nbkCqyya38LzGi5IzVVf1N2xqJFJX+TpMNOLQOKSoV
	LYrOWjRIrYgu+QW/KDr16sQr1pBz0RA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kjAPCYaW;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792003464;
	b=d0pL0vgvAL97EOT8NuCoDE3a02w8iIp0V1CnsKSCa8YFqaq6LSaPaWdnI7/a14euZiaCbb
	GoJbnuxZQ8RjMrWHF3noWIT2jOF9r8D5/enUOTnQhgxx/uSko6q3sJRQolPV3uEt5/Sn8E
	flBFDpuPcLSSd/y8n4+1VJSd9GbD4t4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 94B0E42BA3;
	Wed, 14 Oct 2026 18:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699221F000C4;
	Wed, 14 Oct 2026 18:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792003463;
	bh=g6JScfSsWgesg/1WtK9RTmCPMl1xA6BFFNt/w568P2w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kjAPCYaWrnOUgSCE1ZkOd4MPnsmhx/r5WxajxxuYFxUwucAaSttKAE/IXJCG+DuP2
	 i/SbALVGceqTj/O05V3UuqRooghqrq8qL+BxPEdjUQKfWV77/MLHM+3iZNY5Je4i6e
	 1TiNwuVqtJ+3R9EX8yfrLMrClw09i73W3EqwQRhBgPVNPYI0J0B2m/2nDvAPcfFy0u
	 P+6h5mWmutCGtz1tL/lOJYTp5SP+vlc6SFLRrjtGyBnZhaTM2t4str2ceBkB2C+a+N
	 DKe5k5FXge8ZMCjl6JOlheL3z1BqQXPRDCzup1q0YeajxmoC1X6unntHCovU3s4/m9
	 7xi8UByzUQgUw==
Message-ID: <08a0907f-8e3a-4071-a2e4-fd1411c446f3@kernel.org>
Date: Wed, 14 Oct 2026 20:44:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: memory: fix truncation removing mapped folios
To: Pedro Falcato <pfalcato@suse.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com>
 <8245424a-f068-4be5-9e58-713cbff1f8ae@kernel.org>
 <405811f5-ee36-4b3c-80d0-7dc6827ab5d4@linux.alibaba.com>
 <6660d3bb-3485-4c34-8734-3ea99df920f1@kernel.org>
 <as-L6bGPpGRiF4-Q@pedro-suse.tail5790ac.ts.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <as-L6bGPpGRiF4-Q@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6F5B21C0003
X-Rspam-User: 
X-Stat-Signature: zye4utkfubuh96r4xiuc3khymjc3whx6
X-HE-Tag: 1792003464-886865
X-HE-Meta: U2FsdGVkX1//e4H/itisHqzvhwJqkoBRIkLunpAvtMCqE0Es8H9rrMoXBIz3mAz9fWSjmrkBq1i3iPdtfwVsqygbjzxM0L3zGLXB2TJUldhIKEDACL9hRKh1Q/ndlsi672jSK6B3dF6d+rHfQuNx1lwICvqgcEp3n8coHbFVXANGMhGrPC+3SC0SzcZLmufJFc0W7Wyltat1RNLNLXL86voIsMgt9apKfXR2VOKHENJMzCQV1QzZqMJDy9mcjoS5z/4dd9LyZUEvrn63BUAjKHhoS8S6TxEcvcu01FqQpgPCzlqQ5UaiY5LrW8rlu3+vBrQrRdqk4NS3eySYiJ4VzCdayHYP5UBaZH5/XkN4ElmzCI+KbkbpOEUPFcmllsjP0UscxCYvo4uSMesGAY7DfSn+1aFYTNOZlSG+6DceZSecM5FM+SFvxubC13ZqNilKY1xDv18M0tUOtP8kBLBNdepmTXsUe098Q1n8HS4rA5R1STjlHInwzjej+g936kw//tw18UcAHS7IH/7vXqjUE3+ATtiQbbxYNjrF3plqyVqLccv+tuL4k4v2TaBr0RZZZYWDglJToK+txMTJPUXU7klnQxAjYqz6a5ybc4XtIxaJK/XC2kWKhR7U1XW9ThLa8O/aKb8L0szbbyoKBQA7kEWi33r1OOzKBj3V9T+FnLGawnadtOqdpENUJzA/Wm+on5JCejCrxPyYaSwdAVmfzJEM4nvTjxLbDimjC67HGMMoWHNwgmjdqihtolIFwS1yLeISXQnV32OmFFEAWADuD9UIDEzcIhcegh9pqlsmw2j4MGSs7suM69JhI3rZ5uPQ3krqM6rJrv3UrlLfxQG1MZlcrqOLIBJ+fHprXpYbqWt7BL+1qz55i1uLR76QfzCTaR9JoyNjwkSYLVdbe9N8fzttjuiw8M3K91O+ZtR4oof10N0aTyMBiiXUxkco/Os9QjNqp8dGt2BytUR4qr7
 jFN4dSVl
 e2Kw7kEsRVsKD14DvRB0xQjG7wvv1piEBmsVHc4wlQs1zrhYFyTtdIRqXoWpaNrA+uPFt/so16h8OeO1wE2G14NMaHPmh29mXQhtRNLDrMse0RBbPsTo3I8DItIgFbDSsK5ccL4e6JPVdaxLAmbmPAAQ2TvcZXt33TW92TvU92TY/+K1xz3XrRfWuq4lQPlQfwrMnDDtawclcIRhT/1ljvuasseRZSRwG3IQiqtjSHOrp9/M6n6gtnRkkW02wcbc3qQq9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 16:05, Pedro Falcato wrote:
> On Wed, Oct 14, 2026 at 03:25:33PM +0200, David Hildenbrand (Arm) wrote:
>> On 10/13/26 11:36, Baolin Wang wrote:
>>>
>>>
>>>
>>> I had considered this approach before, but it is not feasible. IIUC, the
>>> sync_with_folio_pmd_zap() is used to address the race with zap_huge_pmd(), and
>>> both the PMD clear and the folio mapcount decrement are performed under the PMD
>>> lock in zap_huge_pmd().
>>
>> Just to be clear, I am thinking about something like the following on the
>> zap_pmd_range() side:
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 38b1165212c94..a8820ad7e2f21 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -584,14 +584,15 @@ void free_pgtables(struct mmu_gather *tlb, struct
>> unmap_desc *desc);
>>  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>
>>  /**
>> - * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
>> + * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>>   * @mm: The mm_struct.
>>   * @pmdp: Pointer to the pmd that was found to be pmd_none().
>>   *
>>   * When we find a pmd_none() while unmapping a folio without holding the PTL,
>> - * zap_huge_pmd() may have cleared the PMD but not yet modified the folio to
>> - * indicate that it's unmapped. Skipping the PMD without synchronization could
>> - * make folio unmapping code assume that unmapping failed.
>> + * zap_huge_pmd() or zap_empty_pte_table() may have cleared the PMD but not
>> + * yet modified the mapped folios to indicate they are unmapped. Skipping the
>> + * PMD without synchronization could make folio unmapping code assume that
>> + * unmapping failed.
>>   *
>>   * Wait for concurrent zapping to complete by grabbing the PTL.
>>   */
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 8b0c2c735d3de..c585f5eb255c9 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -2139,9 +2139,7 @@ static inline unsigned long zap_pmd_range(struct
>> mmu_gather *tlb,
>>                                 continue;
>>                         }
>>                         /* fall through */
>> -               } else if (details && details->single_folio &&
>> -                          folio_test_pmd_mappable(details->single_folio) &&
>> -                          next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
>> +               } else if (details && details->single_folio && pmd_none(*pmd)) {
>>                         sync_with_folio_pmd_zap(tlb->mm, pmd);
>>                 }
>>                 if (pmd_none(*pmd)) {
>>
>>>
>>> However, the race here is different: tlb_flush_rmaps() is under the PTE lock,
>>> while zap_empty_pte_table() is under the PMD lock, and reordering between the
>>> two functions is also possible. That is, the folio mapcount operation could
>>> execute after the acquire barrier (spin_lock()) of zap_empty_pte_table(),
>>> allowing a reader on CPU 0 to incorrectly observe that the PMD is none while
>>> mapcount > 0.
>>
>> I think we really just have to make sure to flush rmaps before zapping the PMD.
>> Then it's really just the same thing we had before with sync_with_folio_pmd_zap().
> 
> Hmm, could we viably replace sync_with_folio_pmd_zap() with the memory barriers
> instead? Seems lighter-weight and functionally equivalent?

For the ordinary PMD zap case it's really:

1) Clear PMD

2) Drop refcount+mapcount

So I don't think it's a direct replacement. If we had a proper way to invalidate
+ adjust + clear it could work. Like

1) Invalidate

2) Drop refcount+mapcount

3) Clear


But in general I think:

a) Likely all places where we have existing sync_with_folio_pmd_zap() have this
   problem (2).

b) I don't want us to throw around memory barriers that way. This all belongs
   into a helper (like sync_with_folio_pmd_zap()) which we only call when
   required (e.g., details && details->single_folio) and that properly documents
   all the nasty details.

c) Maybe there is some smart way to decide whether we need a memory barrier or a
   proper lock for now inside sync_with_folio_pmd_zap(). Based on the folio size
   should do (PMD vs. < PMD). But I assume grabbing the PMD lock briefly is not
   really a concern: if there would be something mapped we would have to lock
   it, and if it would be a PTE table we would lock that instead.

[insert rant about our PMD table locking]

-- 
Cheers,

David

