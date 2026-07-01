Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D680C43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 12:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B966B00A6; Wed,  1 Jul 2026 08:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4696B00A8; Wed,  1 Jul 2026 08:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532FC6B00A9; Wed,  1 Jul 2026 08:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BDD46B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:26:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5990D4036C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:26:22 +0000 (UTC)
X-FDA: 84940130604.13.64D7FB1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5D3D01C000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:26:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=j6b5h+ZG;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782908780;
	b=UAcXH1KqS9j/7FWwZ885zjXubagotLVthUamYR3o6y0ogoULbG5bBuHQLSqnru0cHunk02
	Ux7EK3tE8Nr7ffmwfL03uTj0aD+X0UrN7n0xa6sMyXorkwh4swkzFYwSL9HlxsZpJ9SfFL
	kg0DYfmcjkmsdgXUP8qwmU8iGHvTxq0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782908780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqZzw3fk5Trld6qsPgk4jV8ZlP2OanPJhul2/SuIXUU=;
	b=xH93dFOTsjXlyHx/Ks9WoheWVlD66ey/BXfHGv6CBm2wmWC3KRks2KHvbFeBLRXwLteuxW
	Qb/d/lv/uvoxr3O+C4WbDypplPFmNJrPxux9uIziXjd1w/4pwpF42Kb+cVNkpwB1FcsIm8
	138XoQD5ys7tiNyI2ym2B4qqBHom7ik=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=j6b5h+ZG;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA0682309;
	Wed,  1 Jul 2026 05:26:14 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D84A53F85F;
	Wed,  1 Jul 2026 05:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782908779; bh=U3DO0j/dmUnuT8V0sMZSGlJWF7PRalEy3TBu9TEA4Gg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j6b5h+ZGlYet+l8RJqC7C3JtqgHXxikuUKU4RoK4Fcmi8iZkKNQcMim54FA961tjF
	 tAeeIFIg1H0dRzCh5JM/daTl7Cy/a6PArfhnY52jopb1oYOGQ6KcOo/fKN3z61RTKG
	 ztgWBrC1porMMbL48pZGQJBXP8T6B6zTVQHMs06Y=
Message-ID: <5158500d-0a30-4b2f-9b0f-f10e01dabd4d@arm.com>
Date: Wed, 1 Jul 2026 17:56:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: pgtable: free kernel page tables via RCU to fix
 ptdump UAF
To: David CARLIER <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
References: <20260630041012.5975-1-devnexen@gmail.com>
 <c3ea35e4-833f-487f-8a8b-6f8f95b7ba95@arm.com>
 <CA+XhMqzErBiN5w56fO2_2T3Yj=-L+dPUDjoMvNdK9PcF37nsbw@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CA+XhMqzErBiN5w56fO2_2T3Yj=-L+dPUDjoMvNdK9PcF37nsbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mwhenzotozkgiwweui6o3brbpb1pxk55
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5D3D01C000A
X-HE-Tag: 1782908780-689623
X-HE-Meta: U2FsdGVkX1+bq681mx3YSMKpalzfhxAB/sOWN57zqhcEPsLEg3x/ug/6+D8tHEwhty5YBAFyAsSENA0w2sSAKtkZ22KhKCLXRJJHjUZKeeK6XtQFin6kzMypkglaV74vMb2hTFJ30QpZ8rxd/Xro3kSeI981PQ62tB4u2CZmAmQdUK5KRlphWaU9qHPLtdN3XpNMmM62f3VHabMvxAYxqobb3xbelTP2yCj3Mrj2eX5GSi2cDY9b9801XQbzwWx4WBhYmNaolUxKu4Q7E2Vbr8kpeRmQqK5Eaz7JN7pvbmKsHYOG8YYalSlnDrM6G0uaSabopJvQTNZVyq4wmwuBwHEBW197UHkGXxpzJfoL3uZO55q6OqXuvo4aw2HrE28IhBu6RUGCkBzTnxSK2lpxUtqRkVM16Nk+6WFa8yflzAxTuUrMH7h05AAB7mv15f+/IDTDtHj+ybz/XIQXXDIVJtLG87YSM1GvVsKGHudQoP5kx7JUABCEyJNSFPSQlTPo9cZs9A4BYREN5as3gDk3LdHuSgDPtM3WUWvSSduHyeWglrt85vSeiOp7UYNhqusxH4wL2IGOOKLVLUY0G3SQ+oUcut3NGiw0pTuyJCve0KyTCiu9Ng9iI+TVLIbtuTjUXPKhKzhAblfmWPM/WbLsfobxkNwBR6usds/xb+1uWfkurwrqOozOjmPqA2GWfCAeF9cxvdYyxMVLTlIfyZ84jLCaIMdn43ruPipmcyrMisqYqgtlmz+GXxapPHc3iHJ1n7eaedYBsUc5TQBhjPqzdgjdrlMR6CsztC+i0/ByEz+ENHpAqgj1+icwNiCL+ngr2tmlgTyuvSfIo/ISWyLE91/MjrZgiccDE5AfSjXypIPvZmCGCeRtBgu7643c50/hyEWDEXb1tob65g+kYzCZx5veAutoo7jyazSGH0NRQbs45d0gc+EU+fY+CH1qAbTnxkxebyoUhomM0Zje7o5
 WWn9x9y3
 XyqWMqIEDMHkvmjICvM4WnK76c2Cr4qmsmLeG+pTrGyKo5fr0tyDZjAakzDr+2oRHnsLyFMNGXk9hxF9OQ7qLVHN5p0mR0impRH5aQ3gME5GZ91F57B4wfMLxqJJAzD/uQ/YImc6JPDU5TExvmojEG/nHv8aJF1aAovC8pP+ryUE0+Rbz+NUKeI5z4qBbRZOVNxwVl7i+H2DOr/6htTnJMBBExFm3BYIUOkJyI9suUaYLyinPWctmAzj5pANY5dXMOIf+HGAVrO3Dcyca1px0CXBh2/9wJ+C+9jHFDb/TXtTgJEvnszTBxaDJZW5FDWJSkruNbyl+cNte1yVjCj7SFHX8I8O+uJ0XI+tQUFYl0oiOnUeki9h0UwMBYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/07/26 11:27 am, David CARLIER wrote:
> Hi Dev,
> 
> Yes, the RCU deferral covers arm64 too, so the static key and the
> mmap_lock in pud_free_pmd_page()/pmd_free_pte_page() are now
> redundant. Keep the arch_vmap_*_supported() changes though.

Sorry I should have mentioned in my previous email that I had a comment
below, on the code :) could you please see below.

[--- snip ---]


>>> diff --git a/mm/ptdump.c b/mm/ptdump.c
>>> index 973020000096..50cd96a33dfd 100644
>>> --- a/mm/ptdump.c
>>> +++ b/mm/ptdump.c
>>> @@ -178,11 +178,13 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
>>>
>>>       get_online_mems();
>>>       mmap_write_lock(mm);
>>
>> mmap write lock is not required anymore no?

^
>>
>>
>>> +     rcu_read_lock();
>>
>> Is there a possibility of RCU stall here? For example a system with
>> lots of physical memory will have a huge linear map.

^


>>
>>>       while (range->start != range->end) {
>>>               walk_page_range_debug(mm, range->start, range->end,
>>>                                     &ptdump_ops, pgd, st);
>>>               range++;
>>>       }
>>> +     rcu_read_unlock();
>>>       mmap_write_unlock(mm);
>>>       put_online_mems();
>>>
>>


