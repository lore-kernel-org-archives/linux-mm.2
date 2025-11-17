Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54DF8CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 04:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD68E8E0045; Sun, 16 Nov 2025 23:39:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE268E0002; Sun, 16 Nov 2025 23:39:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C37F8E0045; Sun, 16 Nov 2025 23:39:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 89D3E8E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 23:39:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BB13C0B78
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 04:39:46 +0000 (UTC)
X-FDA: 84118845972.09.401CFD8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 487B3140004
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 04:39:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763354384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bB0JrgIt+WdCJjlUhCH3IRPVdYnGt+gcykmSzqvytv4=;
	b=mvr9w9om0EJfbYAjCj7AS9HQoIzUqa4+hsW+DTINmXmLhfalIhNEhnGBbsX2MjQ5M6kCLR
	RsWb1DUL/hMZZQ93W/3E7dwAEh/7NPjHlSWAtulSxtuSJwm69vD5CCVxwvil6BCv3tB8sX
	IDbRezVzKUoZsCKruPY3FzNCTS/cq9w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763354384; a=rsa-sha256;
	cv=none;
	b=ZrOKPyTs8DQSc+C3Tms+85BIcngEpcdENI6HYvGvOjiKv1N5bu+x+7cptzJlnnHs/nMIjr
	CJ6c1uhRWf6Qh4jbIctniY/LhAxgm99gkVKL2Qujop4q3qo5FCQ+R/Tq1gy/zxWELAVQBz
	vhmFV+WwhxDSsZwGOKee8oqcABCXpdk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C693DFEC;
	Sun, 16 Nov 2025 20:39:35 -0800 (PST)
Received: from [10.164.18.52] (unknown [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 284213F63F;
	Sun, 16 Nov 2025 20:39:39 -0800 (PST)
Message-ID: <f016fc4a-8b95-4064-8808-5ce61bf5b7ec@arm.com>
Date: Mon, 17 Nov 2025 10:09:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: propagate VM_SOFTDIRTY on merge
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <addc338c8b33aea3c31202180448ea32ef37956b.1763142412.git.lorenzo.stoakes@oracle.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <addc338c8b33aea3c31202180448ea32ef37956b.1763142412.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 487B3140004
X-Stat-Signature: m3qbqtynkk6dh4rdk3wmp53k5f66jj5k
X-Rspam-User: 
X-HE-Tag: 1763354384-555602
X-HE-Meta: U2FsdGVkX1/SlRFLZtU2XBmH6ayHbw/u/ok/682eIno18jczHae/oOTpXGGJCUHDGMjCvaS9Q7hMmEbRtCNX9F+N0nuDCyrCJBk6rPGzEm5tB6daC+377/dnkWX6+AcODEPqtply4yrqbAzR0RRZrEHxmAiRUxQBtkXnILCfELwi2HEDLhv4kiO4CYUscZ/F615oOOAAIrkY63hUogVLeYrfYyT8fp0YM2T6niu9fWUlPnocDVsAR7oUOC/PtJSy/u1gwTNsFlu5HRMWmMcMgBK6DJMjnhPj8XkcEuROjp8DQ0CK0JiSZevHiEK502YsfQLBP5PvQC2Qom5cIV9IYm9k/gldxM2WNRdp2wRrBGJwdQngj5knoFBBpLufmZbe4jMhxsWZnEHzlpJ+xNjJDWGJ3x2q5JmWdrx3msrygsWfBzywVyjoCaqj3daNooPbovvo8cHHsUqu1ynt/8rdk5MifEh7k+oD0vVEdiNU8MgrYe0rEQh3+xz8/TIfKh1C9y/n5yoAoSgPWwfQsG+2FIqFbGs5iAqixmxvmWjF48ZOT8hR0kEatDDE73NUxiAgNC0Abqi3s7RFTTWCSicqpk7fcmFxmMCdIQWQeaL7CBx4BjvcLwmqIYUMqhr9TSBMKYMcLP0UgWa2Pd0nlyzIXyWCGF1jf3etPZQCZkFyvw4Dxq4GtKIR+s1cfcDMqq8izFAvfiqQeSSpMZ9OAKkDa/o7/mVfJVQzp0TUTZKkv7k1iPXWi7H6C4bJbd0/cuv9ex7NMWjrcTUns+iuVrDbFVrx0SFKkC7UE7xwBP7OypSB6Fkj89CGWiTaB1FepkP8neG7M2v9nWvTYrqlc4cFYTzJy/fKM+90VZiWapvcV10ks3foKpXNfVD7oeeVZqiwu3kVjcrelbx7lujKa0bMzn/TT/Ce0i9lQCGDFOmPSt9i36B3EgRWYTCBVOqwmDJGsOiDcrASaNW/aDSjP/z
 mA+OE20f
 Sz+OVSYWAJWZxh9DXBv5UZT9Mlm7khOYXQDXZP45tpy4hgKlRlhvcnY5BUGMaqVpKOEXn6kzWZeHBBb8HZisl718HyNyNnKNTdjQANMrQ424wGnKbECakhAbpqbGxx6U1ikxyUq46b39J3itNNi0ozYo9LTcMHl24WI4ASrWcdiPEYcBcv0rCQeoFAZshey7kSJ+cdbAa7Hg33HD8YCEsLrwpvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/11/25 11:23 PM, Lorenzo Stoakes wrote:
> Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> establishing a new VMA, or via merge) as implemented in __mmap_complete()
> and do_brk_flags().
> 
> However, when performing a merge of existing mappings such as when
> performing mprotect(), we may lose the VM_SOFTDIRTY flag.
> 
> This is because currently we simply ignore VM_SOFTDIRTY for the purposes of
> merge, so one VMA may possess the flag and another not, and whichever
> happens to be the target VMA will be the one upon which the merge is
> performed which may or may not have VM_SOFTDIRTY set.
> 
> Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
> which solves this issue.
> 
> Additionally update VMA userland tests to propagate changes.
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/mm.h               | 23 +++++++++++------------
>  tools/testing/vma/vma_internal.h | 23 +++++++++++------------
>  2 files changed, 22 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 43eec43da66a..fd9eeff07eb5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -532,29 +532,28 @@ extern unsigned int kobjsize(const void *objp);
>   * possesses it but the other does not, the merged VMA should nonetheless have
>   * applied to it:
>   *
> + *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
> + *                  references cleared via /proc/$pid/clear_refs, any merged VMA
> + *                  should be considered soft-dirty also as it operates at a VMA
> + *                  granularity.
> + *
>   * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
>   *                  mapped page tables may contain metadata not described by the
>   *                  VMA and thus any merged VMA may also contain this metadata,
>   *                  and thus we must make this flag sticky.
>   */
> -#define VM_STICKY VM_MAYBE_GUARD
> +#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
>  
>  /*
>   * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
>   * of these flags and the other not does not preclude a merge.
>   *
> - * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
> - *                dirty bit -- the caller should mark merged VMA as dirty. If
> - *                dirty bit won't be excluded from comparison, we increase
> - *                pressure on the memory system forcing the kernel to generate
> - *                new VMAs when old one could be extended instead.
> - *
> - *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
> - *                which should propagate to all VMAs, but the other does not,
> - *                the merge should still proceed with the merge logic applying
> - *                sticky flags to the final VMA.
> + * VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
> + *             which should propagate to all VMAs, but the other does not,
> + *             the merge should still proceed with the merge logic applying
> + *             sticky flags to the final VMA.
>   */
> -#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
> +#define VM_IGNORE_MERGE VM_STICKY

Logically VM_STICKY should be the only flag qualifying for VM_IGNORE_MERGE. In that
case should not VM_IGNORE_MERGE flag be dropped all together ?

