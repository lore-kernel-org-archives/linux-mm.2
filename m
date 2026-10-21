Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 515D2606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 03:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=bjlIvEcG
Received: by kanga.kvack.org (Postfix)
	id 3F28D6B05E5; Tue, 20 Oct 2026 23:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A36A6B05E6; Tue, 20 Oct 2026 23:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B99D6B05E7; Tue, 20 Oct 2026 23:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6DF6B05E5
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:11:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74662802F4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 03:11:38 +0000 (UTC)
X-FDA: 85345158276.05.EC5EB57
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf14.hostedemail.com (Postfix) with ESMTP id E4D32100003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 03:11:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=bjlIvEcG;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792552296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ufXaEJ5FT5/RcC09d0BBVVpoSwGEekPNmNdSpG+1s5Q=;
	b=yF6MZrYH38Xr2BuS5GCVc0T8ZNQiWosR2DAcVndnxI98QxuRcmebWkkyVdwWVA/eSaSFeJ
	P75Ud533qGWPSkZi1EAZXScAGcViDyRcTSWs28PY46SQFFv0m1G8Q1j/dCKa5A4oFiKJWl
	V0vkMDj0T1fHG2YXAvN3W1f7Yw+5nns=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=bjlIvEcG;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792552296;
	b=aNXO2K7K+1lRwMr/9QYMM9AIVF0Gt6XQ+2X68w0VsXnbcCSnHnL3og8X4R3tTTC0md7zOB
	8JgR+kmrLYk/O6WSSkHwU0Xby4mj/9UgU59BA868a3OU2PGUvC14HRk+ABgp8STzIY9MIW
	tg1nvfmebBkKoE/YUqqMt3ESuw3rGtw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792552286; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ufXaEJ5FT5/RcC09d0BBVVpoSwGEekPNmNdSpG+1s5Q=;
 b=bjlIvEcG7mR9NgMp+3NsPYPUmhmOvkQUGRjzhjrU1BdLdiXA4xNxdAFq853+S/ajbBMLCW
 0yO7aSHtUDiGlWupdjY/g9W9JpBeXiCclLhpoXoQ+IZp/6fzk5Z4bBMeRTsYWhdXlrKYDy
 gXNTYc0XYFTcmgqryLHqHrdRNH3R9qEoXJ8JIrZLpSbtSXw1KNYK+5PeDUtq/it6IjlDKV
 FrvX4oUed1tucv0GGBasEY1kjU/+5CqhvkGDB8/R3mTALh753iX3AHRYpo2DDpfLWQhHyJ
 2QQb9jWOXXRTwXu/NVv7IwrmGd9GrAHxr8bYMCsk+dNPSJCOo3i/tiTUKIDpug==
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 21 Oct 2026 11:11:05 +0800
In-Reply-To: <baf5943f-b3fc-4a8d-85cf-bd897bb9a08a@kernel.org>
Subject: Re: [PATCH V2 2/3] mm/hugetlb: disable PMD sharing for UFFD missing mode
References: <20261019113034.97690-1-lizhe.67@bytedance.com> <20261019113034.97690-3-lizhe.67@bytedance.com> <atc-PW2PirXZzNZh@kernel.org> <baf5943f-b3fc-4a8d-85cf-bd897bb9a08a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, 
	<akpm@linux-foundation.org>, <peterx@redhat.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26ad82d58+a6dc5c+kvack.org+lizhe.67@bytedance.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Mike Rapoport" <rppt@kernel.org>
Message-Id: <904487b4-a838-4d57-a297-12163136279d@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
X-Rspamd-Queue-Id: E4D32100003
X-Stat-Signature: of3u9mfqsb4pgefkhkofunz63icg5jj9
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792552295-314918
X-HE-Meta: U2FsdGVkX19BPbS6e3K3Y9VxtvRWcE2wSocOR0MLaWYqULYb4tmK8hm3k4BBuPkkY9J9Fm5WUTgtc3PFNwBQLfAjoO7Qa0yca726MovrkORuAGAY8NL7YL27PM56br//JCdGhb+QnmO65062gEFW7Pvv54npU91+lcR0gPWL70BIg9AXuCiE+AtfHEeG4EFCJDibXONQruXyBhDRqS4ak/mEReaZQvKzZKz5LuK6j9wfvhZiJtqfDo3XM2nCVpkTl2/kd33YJjI1e8kKUozqxmhFr1djFQkQyuwPW/g9MK2pxLYXubRDMbpHihr9JkDqf0hItjUJHjH94WaMCgmu4UOoDkUDvsEIudU79HxEakaOWWQdv5RvQfpvv0qXU7OAEYjjrOtfH6F0HD+nTNQg3OSLgTUrmySYY4hK99KEqRrxT5u9hcIfNKh0AogEIkDQWLgNtMa5XBVxA7DU7bJET0vJWzReziNBy1O+6SQqnmQlNZG13P1AzFe6agxEU8i2iBFTqopckUJ4pdcwZ+aVQ2/nQEVMM+ycP03Pdl++FOrCam21ZV3m1PyQ0//r/C4NYifTXzPq4ppWrFw7P9dTnw6y9RIesT9LwWiuwbUwJzEVYBMfpINFmvk3HelCfw3mVc1aEaW8Lb6u7Av6g+oTBL8k+HGTrVxMp0q7vlq2ZWjYMbyQSDHRV26bIXviquUH33fYUx9jZcedQJ6GxlhUsvVwz5HdkaxrTj4oMXUJ99IaOF9Ie9LcYwQxCax6O7RiPngb1mWXA/rQcxbuhQoeNm24767hp8QhnZFlkAPDPGksg69A/S3dFbJSXCGdlpOiukFjLwfJ6mQcD2i5ckuHZQJnr+1CuXu7o9LCf9gex1H5qQMCmiwAP5ecGv/QwbhMhYvo7UikmBqffJ0XyhAh8B+LFAsBmQVWvD8ub3GaLMZfWrVI1zRXRNgD8j2uxHkOj2DKo8mfGDwKfncKm9y
 lJ/Plhks
 /hOla9iqVVLpAKcNZ3GbFXnBhcLipj91ICqYwBjcffG//7pqA3DW4JPjE9WlloQlebvfCmTjs43ZGa2vlrQsyVmV67C9fPYiAGRo16IbGDNusDandWaviuxyT+OzuJZO0EWx4MTX8HLwoDAUNiu80yS42FRyx7PQfwGIgtRXYoWx40nRtfsobFe0y2ufjvlb7cFuqmUlXupP4Z0Ii5iLbdRgj3GL0CN5YioYN2aNPAtwRwXxHc+WhbBv14jvYhykYuRrnl5Yjbht0gP7VsYcg2hq2olMq7pqGYYLdb672+d2jqPUmCmhKhTsmQLH3QGLjL+ga
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/20/26 6:33 PM, David Hildenbrand (Arm) wrote:
> On 10/20/26 12:11, Mike Rapoport wrote:
>> On Mon, Oct 19, 2026 at 07:30:33PM +0800, Li Zhe wrote:
>>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>>>
>>> For UFFDIO_POISON to install a poison marker in a hugetlb mapping, it is
>>> sufficient to have the VMA registered for missing mode.
>>>
>>> However, UFFD missing mode does currently not block PMD table sharing, so
>>> installing the marker will be visible to everyone using the shared PMD
>>> table, which is wrong as UFFDIO_POISON must stay local to the process.
>>>
>>> To fix it, include VM_UFFD_MISSING in uffd_disable_huge_pmd_share(). Add
>>> a debug check on the marker installation path.
>>>
>>> The existing registration path will then unshare PMD tables, and
>>> subsequent faults will not share them while the mapping remains
>>> registered.
>>>
>>> The alternative would be to unshare PMD tables selectively when
>>> installing poison markers, which results in way more complexity. Or
>>> alternatively, simply failing the marker installation, which might break
>>> some use cases.
>>>
>>> This effectively disables PMD sharing for missing-mode registrations
>>> that never use UFFDIO_POISON.
>>>
>>> Suggested-by: Li Zhe <lizhe.67@bytedance.com>
>>> Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>> ---
>>>   include/linux/userfaultfd_k.h | 13 +++++++++----
>>>   mm/hugetlb.c                  |  1 +
>>>   2 files changed, 10 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
>>> index a4351cffc60c..fe78ba14dc68 100644
>>> --- a/include/linux/userfaultfd_k.h
>>> +++ b/include/linux/userfaultfd_k.h
>>> @@ -169,7 +169,10 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>>>   }
>>>   
>>>   /*
>>> - * Never enable huge pmd sharing on some uffd registered vmas:
>>> + * Never enable huge pmd sharing on the following VMAs:
>>> + *
>>> + * - VM_UFFD_MISSING VMAs, because UFFDIO_POISON may install markers and we
>>> + *   want PMD tables to be unshared when installing these markers already.
>>>    *
>>>    * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
>>>    *   tracking information is per pgtable entry.
>>> @@ -182,9 +185,11 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>>>    */
>>>   static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
>>>   {
>>> -	return vma_test_any_mask(vma,
>>> -		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
>>> -					VMA_UFFD_MINOR));
>>> +	const vma_flags_t uffd_flags =
>>> +		mk_vma_flags_from_masks(VMA_UFFD_MISSING, VMA_UFFD_WP,
>>> +					VMA_UFFD_RWP, VMA_UFFD_MINOR);
>> Since this essentially disable pmd sharing for any uffd mode, maybe replace
>> the flags check with the check for non-NULL userfaultfd_ctx?
> That would likely even better and we can just simplify the comments as well.


Agreed, thanks Mike and David.

I will update uffd_disable_huge_pmd_share() in v3 to check whether the
VMA has a userfaultfd context instead of checking the individual UFFD
mode flags, and simplify the comment accordingly.

Thanks,
Zhe


