Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DD6DCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 06:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5032C6B0088; Mon, 11 May 2026 02:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA846B008A; Mon, 11 May 2026 02:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417716B008C; Mon, 11 May 2026 02:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CCF76B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:21:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B6A111205FF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:21:52 +0000 (UTC)
X-FDA: 84754143264.16.213BAA6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id D5D30A0002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:21:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YKTZmFga;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778480511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pgSeMyRqOedf4yG4oik3LdrMvNehPVDEiKl+jOI3u28=;
	b=QzoqckbzgM1KvjKGHo7YhqCbODhQG8F8YtdDUHE1D/XeQ5tfRQCkISgAdiOqmKu6WUWZSe
	ZWzjRJR1EQGnrtwMbVuhuEnvAWC1WbYe1ewmZ3bkhQ/FSlhRt6Vb9X7Q7HnriF0fYDqZ2u
	qFYMH2Wu/d1gxFfA1UgGw7UII74y3zo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YKTZmFga;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778480511; a=rsa-sha256;
	cv=none;
	b=s5lYzdxb/VmdjEfNBZMJPknhuouqHsfPMISxD6wkH9oyrf3K38B7HbOCznSrX8ywnBHypr
	ByGn4ChqvYoSnfo0gzc9VrD6nOpgXm34kYWBFEXJ+LbzQ0YjN7HkbKyyI0qJQtITNoU6of
	DUXeJC6IlBDqrgl9+a3GY3/+3ZS/nT0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90BB31713;
	Sun, 10 May 2026 23:21:44 -0700 (PDT)
Received: from [10.164.148.37] (MacBook-Pro.blr.arm.com [10.164.148.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 960D33F99C;
	Sun, 10 May 2026 23:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778480509; bh=p4dh3XaPvO0uUNJECHapVoh5/ObuTHsNDW6l7cexbq0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YKTZmFgaTqSycAvb1igwsE4xyD+ujnbAw8sP9X9y1SqxLNfz0kQGVolTukibmNRoC
	 6MbV6offkR1jt3xM5f0oNdPJPhlzVPHQ/Cdvw33NfuD+nUsS2uwXkRirxuaxuPm/Zl
	 FG2jkSbTAxKSoZopXblN/gEeb6Hl4fADcnwMhDio=
Message-ID: <7afc8a77-5b37-470f-b4f8-c0632a4e2311@arm.com>
Date: Mon, 11 May 2026 11:51:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/9] Optimize anonymous large folio unmapping
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, hughd@google.com, chrisl@kernel.org,
 kasong@tencent.com, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260508163842.ad2b2202f827d3f86228758d@linux-foundation.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260508163842.ad2b2202f827d3f86228758d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zar4icd4mdr8nh3s1st3io981zj65nch
X-Rspamd-Queue-Id: D5D30A0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778480510-543124
X-HE-Meta: U2FsdGVkX19vQwGJoB6nsQ4BifYXrkltPsdT0ZwEMPCuL3PvJ2BRzltJIpLXlDG/Yl0h/Igqe7lCjd/WiD3DkNjytJU/AT5TNihCu8jQyfw2TVlCtZPhnydteDLyojR+Vk79Y6nXYfjq4czQsHlSKyE/4YQ307AxIi1zn/Yc9jpHFv9ToavRLVK6B8uhrtQRgYPDNaKvk2Uq0By7FllEO0OyJo6iIZHAl8x0J1ly724xDZc18W1f+msvHAi6xhv+FHcFQPjN7GcpuLscjKTslwi+iucqHtwvvYgR3vXSXYIylvL2tYDHrIWGkaXxgb+jn74J8MsPGCUmMbojzDQ5NgjyADATXmem0p5KL5KPKENXUEQmVxIq4hC5f/rzq1uQb1PiP7tYYnoxCfIP0tqJ9FO6/CXyx3M5IylfzpQRsz5p3fspvBXytT/MngeB48msWqJG249/ZnZSaYYXGdeGDYRQttA5kv+GGjFtTa2pQ5rQH1GjTgF5jMsdUsX581ZeGb9LyKw7+n+CENUvZhx0mcbyr3jQ+9RjDGKKDhhb0KgB+bZIuTx9YqaaWxDBF8viSA9l3QSKkDEMfcQe3t88gPZm7cUoHTnKneXfN1WUwWIEpEW0eQGmWmg6wmSSsX7W3M/nBMJVS2Q+gyg8OZSj7iM17kJvLyMH6vfCQRdj9Q2mkXrfoVGdihycWwIGxRjBNX5Vw4SwPh56GSCd4Pt3ztiQxRY6ir+Cs1ZTiu/ScRXS4Yddj6f7RAWapy9Qht5Y6wn3nt6quAlYURKrYZz3YobkVQsio2NFCcp4D+CLb8w9y+E3ARzlDSB7YYs9e8IZgYWv04GP6U1/fAUif1TkEBPb4n19AkiYP4tRDPKOZtajlQS+JHR4IGUZIxX5AJ+D/RB8mbLD6Ofjkc1kVGnvAh8yfkSABeUMxHW1N79g9TwaYh0AzpIN2RX8bRescQ21TWCvwPkpQNFbIVjMro+
 h+rF3IMa
 Yt3Nv9SKwJu6inb8rpNkEYNssk5RzbaYykeI/kZNTpgTeHV28mOjL4vTn/zpW4GiNEAu6O17kMMmkA7d5TTXRxWeAIrQDydumKmJix7Ehfyh5cO33cXHk1jd48PxQPM1EvekdPNsnagNoYOupTAp0+iVArx133r86Db0tWGIKg1+13JT1yQYg+MQE/PdnoUDw9elgyG/9/JJZmkf6LpC4LOkfM1/U8k0FqHPniCJJmAzisV5Pu6t3IM+Ym6nKgtP2S0Aru3arirdhkVXICCCZkop6QhehrTA4mYrkWT+mhwdO8vZ1QEZ0hgWLvYgBlkMqxUjQTMFC8lUa5l0AKZEO6jQlLNiMvsnuJG3S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/05/26 5:08 am, Andrew Morton wrote:
> On Wed,  6 May 2026 15:14:55 +0530 Dev Jain <dev.jain@arm.com> wrote:
> 
>> Speed up unmapping of anonymous large folios by clearing the ptes, and
>> setting swap ptes, in one go.
>>
>> ...
>>
>> Performance as measured on a Linux VM on Apple M3 (arm64):
>>
>> Vanilla - Mean: 37401913 ns, std dev: 12%
>> Patched - Mean: 17420282 ns, std dev: 11%
>>
>> No regression observed on 4K folios.
>>
>> Performance as measured on bare metal x86:
>>
>> Vanilla - mean: 54986286 ns, std dev: 1.5%
>> Patched - mean: 51930795 ns, std dev: 3%
> 
> That looks nice.
> 
> I'll pass at this time, wait for reviewer input.  Most reviewers are
> jetlagged and exhausted, so a resend might be needed ;)
> 
> Saskiko said a few things:
> 	https://sashiko.dev/#/patchset/20260506094504.2588857-1-dev.jain@arm.com

Patch 2:

"In the original code, failing hugetlb_vma_trylock_write() triggered a
goto walk_abort, leaving ret set to true."

That is wrong.

Patch 9:

"Since __HAVE_ARCH_UNMAP_ONE is typically defined without a value on sparc64,
__is_defined() will evaluate to 0 because it is primarily designed for Kconfig
symbols that explicitly evaluate to 1."

Which is again wrong?

Patch 9:

"What happens to the remaining pages in the batch? Since get_and_clear_ptes()
cleared all of them upfront, and the loop aborts early without restoring them,
it appears the remaining PTEs are left cleared in the page tables and their
references are not released"

Yes this is valid. I did see it on the v2 Sashiko review but misread it : )

When unmap fails for a sub-batch, I need to restore all the cleared ptes,
not only those of the sub-batch.

This should work:

diff --git a/mm/rmap.c b/mm/rmap.c
index fc953f36d4527..e54c15a82c504 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2023,10 +2023,8 @@ static inline bool __unmap_anon_folio_range(struct vm_area_struct *vma, struct f
 	swp_entry_t entry = page_swap_entry(subpage);
 	struct mm_struct *mm = vma->vm_mm;

-	if (folio_dup_swap_pages(folio, subpage, nr_pages) < 0) {
-		set_ptes(mm, address, ptep, pteval, nr_pages);
+	if (folio_dup_swap_pages(folio, subpage, nr_pages) < 0)
 		return false;
-	}

 	/*
 	 * arch_unmap_one() is expected to be a NOP on
@@ -2036,16 +2034,13 @@ static inline bool __unmap_anon_folio_range(struct vm_area_struct *vma, struct f
 	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
 		VM_WARN_ON(nr_pages != 1);
 		folio_put_swap_pages(folio, subpage, nr_pages);
-		set_pte_at(mm, address, ptep, pteval);
 		return false;
 	}

 	/* See folio_try_share_anon_rmap(): clear PTE first. */
-	if (anon_exclusive && folio_try_share_anon_rmap_ptes(folio, subpage, nr_pages)) {
+	if (anon_exclusive && folio_try_share_anon_rmap_ptes(folio, subpage, nr_pages))
 		folio_put_swap_pages(folio, subpage, nr_pages);
-		set_ptes(mm, address, ptep, pteval, nr_pages);
 		return false;
-	}

 	if (list_empty(&mm->mmlist)) {
 		spin_lock(&mmlist_lock);
@@ -2075,8 +2070,10 @@ static inline bool unmap_anon_folio_range(struct vm_area_struct *vma, struct fol
 						    first_page, expected_anon_exclusive);
 		ret = __unmap_anon_folio_range(vma, folio, first_page + sub_batch_idx,
 					       address, ptep, pteval, len, expected_anon_exclusive);
-		if (!ret)
+		if (!ret) {
+			set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
 			return ret;
+		}

 		nr_pages -= len;
 		if (!nr_pages)



> 
> 


