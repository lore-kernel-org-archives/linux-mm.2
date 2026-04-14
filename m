Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B1C6F9D0EC
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 18:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33D626B0088; Tue, 14 Apr 2026 14:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EDF96B0089; Tue, 14 Apr 2026 14:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD2E6B0092; Tue, 14 Apr 2026 14:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0AE206B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:14:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABED416020F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 18:14:30 +0000 (UTC)
X-FDA: 84657961500.12.54D890D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C1171C0006
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 18:14:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H6RKP1kL;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776190468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjRXOlP63bi6r43IaxSjTQ7mvOrlg6+fG/UK4CKQONI=;
	b=JB+IHHR0bs29JgIFR4XA+OibLALckcCdD+BYjpegz7/lVbjc7RGbxXpfgaZLQlVvreebhC
	0sgtNxXxU1pCuCmdet/HR1G9MzW4ixR3JteWUJPWYNTYO8ZBl1UWM7t9iEkwhYG7BbnHdL
	ylgev19KJLGLpP0PA50erlUtzPcDByI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H6RKP1kL;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776190469; a=rsa-sha256;
	cv=none;
	b=KisPN60LDT5YdZ2iIDx8dbU67SPkaDyDKZ5ttukPc8hQrxxnRn+27+1UVozsUeWCy+sRQ3
	M2qdQwVAYSSvD0xPrE/nvTdphJqsfNHN/sBhdRHDPCuhloqWUi/2NkXkqiH7qlLFa/gfI7
	vcJ308MCpPUcKSVbCwF6+UcAPhrTqiY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8769D404A3;
	Tue, 14 Apr 2026 18:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB7CC19425;
	Tue, 14 Apr 2026 18:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776190467;
	bh=Z4HGX+p1oC7UDoxzy1/j2oHi4zOZxdvu80w/Oa61Zwg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H6RKP1kL9+7/lmHTtOJHlroWlBzsbOvVdrDeOG8IoEVdSGKimga1C43MIFqM/lXF3
	 yzZORLNQ1wzwpl6/WtUo4TuWYQHBA9uzlacRCVJbuxaaAUI0aiMjGl5JqpF3CQahzc
	 M3Qps9zGFRunzFN4cjpOWgLwgG2XERX7bsCaF2UOPAzcuvZvSIvZvhd9R5OJhzeF4H
	 d20AY9mOo8nwRRS4vTE2n5/ZLt3gZTfLT0WZrp0YSYnZYJTMZUyYZZ0siEdEfIkOpJ
	 ynr+69pf5pk5B7RKwx6FcaseTv+BSDWYfZBjX3KV0Sz3DnbhYbQWYa6HNuzB42FyR6
	 tXmxoC1b4Nqzg==
Message-ID: <998c02b6-2612-42c1-8099-d65ae275d1a2@kernel.org>
Date: Tue, 14 Apr 2026 20:14:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
To: Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 Nico Pache <npache@redhat.com>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
 <ad1TMjF1L3usYIC5@casper.infradead.org>
 <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
 <a4d477a8-71d8-4219-9cb3-153f2c01e184@kernel.org>
 <84B8F641-A3DF-4219-AA57-6BA48E9B4998@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <84B8F641-A3DF-4219-AA57-6BA48E9B4998@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C1171C0006
X-Stat-Signature: ugsq18tj1cw3k4mjj5r5sguh8c8wum96
X-HE-Tag: 1776190468-99048
X-HE-Meta: U2FsdGVkX18X1njKT4PiBdXKiRkETckpz8mZVmDHTZjCnZw5ZPtE6rkUak5fc6O/NCY9R/kg3NClIsV20K3UMvZE2DlMKuZ4T4RWh6w5TMZuamRyo89WE6Vzrqaafubfd0ukGCPkmQ+5REcBbUtwzD28PDoV3VDE+rK6yd5/SSc3ZSb1aQiR565ePUhMfKdmdHP1iaMgyNYTx1dbW5sszfriwWfb7W5a8fBY+ZikYnlpmQsIkUVrp/tCJDSiYx4UkVJ8bGFTG+m+FKINH45rDmSZjkEn+pMJ/yBs+hq0Srjtj8F7n1q6GxeOV7nobAq97Vpb6kPV9bBHaiRzEvNZHSptIOlmcuSoLCxZfJOeNSr6VdmJc51/BOb6JJsOIHiuQquMxtklB3T7LCMQM27ZqBlzmZZs4+PdY/WarCF9+3yEbVXAkQhzBg7njr4ZFMufu2+YYulkL019uo3/rPuoPGEhTAtnhT3dmmztCj8bpEB09cYk7Sf8+Xt1812qJEEWBDltV3nhiHIyOwHAJi3wRRqHZC7DIuYMo57XhgKbgElUBhQBwq51EJzRLJ0MfbGp8ouldMUB5XRucwtNDOw4tYlDwN7u0uLSZhBz1K9XZlC4tCvLOzWUOjrv9d8nlboBoNx8KaOEDnSIdw15qCRmaqPvwhQj7AjAgY2H30ZhnH6LNaT0iZO53W4A0NZ5n0h9LN1AWB1e0ELj4p7K2uMBTVLBp9fD3Hs3YfX/OdnxdbwVGn0Pn8p4CQuAeXky5Ingxvb9Q1UGtNwSOgoxILePMiuBGkcOmMjO72H0VKiLA+ePbKc8lUbLTSDuOe0ZQaZTPjW+ZXeOpP0Sczsi8dluevpbXYd/B7Jw9tS+nLudgb7pe59YQHy1e6GAX0xODjaVRg0DKt7mA0+gewtgD1d7Qy712c3WWrvNw4sR5B20lVdIYWlbgHPE39fgn6uZDwYx+ebg045XHHj/IVukD2O
 SG/vZM0C
 QNe+VNfXOZX7YxoFU2CZwG6eeQ4y+2Qqr3XCnUj1nk3ZzRxoV2untjsybTbaD+F8tQfubjqXygr7P8lhCjxudTvg9p+nXAWD5onJJL5yidzOFcuHh078ICpak8KFGJARyU0wT97jPxqyQ+7I7k6KdlNtN3EEXUszLPEfV0jXI8OlDqM4uH2B6Rl1jMYz9NgAJoAy2SjPV4GReKrqDi6J8HatOz7nPftQOqSUtSXQv9mzkaf5y3e1jEAvsEP7CwGluXCb70pbpGdI70asYVAuthVXhncky3bxIx0LdWXVqsUjB50PDYDTSi1TqNyqjPkRbRpKYjXQprkrDjlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 18:30, Zi Yan wrote:
> On 14 Apr 2026, at 7:02, David Hildenbrand (Arm) wrote:
> 
>> On 4/13/26 22:42, Zi Yan wrote:
>>>
>>>
>>
>> I assume such a change should come before patch #4, as it seems to affect
>> the functionality that depended on CONFIG_READ_ONLY_THP_FOR_FS.
> 
> If the goal is to have a knob of khugepaged for all files, yes I will move
> the change before Patch 4.
> 
>>
>>> I thought about this, but it means khugepaged is turned on regardless of
>>> anon and shmem configs. I tend to think the original code was a bug,
>>> since enabling CONFIG_READ_ONLY_THP_FOR_FS would enable khugepaged all
>>> the time.
>>
>> There might be some FS mapping to collapse? So that makes sense to
>> some degree.
>>
>> I really don't like the side-effects of "/sys/kernel/mm/transparent_hugepage/enabled".
>> Like, enabling khugepaged+PMD for files.
>>
> 
> I am not a fan either, but I was not sure about another sysfs knob.
> 

Yeah, it would be better if we could avoid it. But the dependency on the
global toggle as it is today is a bit weird.

>>>
>>>
>>> Alternatives could be:
>>> 1. to add a file-backed khhugepaged config, but another sysfs?
>>
>> Maybe that would be the time to decouple file THP logic from
>> hugepage_global_enabled()/hugepage_global_always().
>>
>> In particular, as pagecache folio allocation doesn't really care about __thp_vma_allowable_orders() IIRC.
>>
>> I'm thinking about something like the following:
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index b2a6060b3c20..fb3a4fd84fe0 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -184,15 +184,6 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>                                                    forced_collapse);
>>
>>         if (!vma_is_anonymous(vma)) {
>> -               /*
>> -                * Enforce THP collapse requirements as necessary. Anonymous vmas
>> -                * were already handled in thp_vma_allowable_orders().
>> -                */
>> -               if (!forced_collapse &&
>> -                   (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
>> -                                                   !hugepage_global_always())))
>> -                       return 0;
>> -
>>                 /*
>>                  * Trust that ->huge_fault() handlers know what they are doing
>>                  * in fault path.
> 
> Looks reasonable.

I don't think there is other interaction with FS and the global toggle
besides this and the one you are adjusting, right?

> 
>>
>> Then, we might indeed just want a khugepaged toggle whether to enable it at
>> all in files. (or just a toggle to disable khugeapged entirely?)
>>
> 
> I think hugepage_global_enabled() should be enough to decide whether khugepaged
> should run or not.

That would also be an option and would likely avoid other toggles.

So __thp_vma_allowable_orders() would allows THPs in any case for FS,
but hugepage_global_enabled() would control whether khugepaged runs (for
fs).

It gives less flexibility, but likely that's ok.

> 
> Currently, we have thp_vma_allowable_orders() to filter each VMAs and I do not
> see a reason to use hugepage_pmd_enabled() to guard khugepaged daemon. I am
> going to just remove hugepage_pmd_enabled() and replace it with
> hugepage_global_enabled(). Let me know your thoughts.

Can you send a quick draft of what you have in mind?

> 
> BTW, this conflicts with Patch 12 from Nico’s khugepaged for mTHP patchset.

Right. I guess it can be handled.

-- 
Cheers,

David

