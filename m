Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3423FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 09:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10AFC6B009D; Tue,  7 Jul 2026 05:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1B46B009E; Tue,  7 Jul 2026 05:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F8F6B009F; Tue,  7 Jul 2026 05:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D37F96B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:07:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A4D1C1FE5
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:07:41 +0000 (UTC)
X-FDA: 84961402722.24.9DB3DF5
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9708940005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:07:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xQXJCbKA;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783415259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xr6g3bVCDzcHhHO6pC/xBWOeuWudquosOcZYH5S6bcw=;
	b=aZ3Ij0pHWrefvPhPTosY61q0+b2q5pNIvnwBuwm6IeBbkNjlIxGhBev6q3g6OErJZw7fob
	X+QIF4+/yV06yfz02exul7io9lZyKKNWuJNUlYTCgK335P60c7+MRDQyEqE98pQ9QCzmYA
	Ai+0Om5HCQ8OnT4FPHAJUGi4fEHwMd0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xQXJCbKA;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783415259;
	b=PfKqzcaObMegegZPg6OIdGRkn6sZNSCo3l9OiWsEc7wyCstLgVOxSx0Fme9MhGVdpZDwT9
	guG3VXVEU0+7SqJT4/G9lBgu7lOYSEo5CkXrdq35u19U9zp9aOc95ML7by8x/nAmnacwQU
	y5a4K9I6LvF8cryUWBPnkUeabIhBrtM=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783415257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xr6g3bVCDzcHhHO6pC/xBWOeuWudquosOcZYH5S6bcw=;
	b=xQXJCbKAWMmYOnxQ+DB6kohB54dGQKI+UC+Zllio7pzZV4FSW94xuJt3hYJTpHXgVaRur/
	BGvqlZk/gjTX5rAcHSBfmQ2+RxaeRAouBb9E5+a5un9CxUL1x00wcLXjDcUQT+nMhL46YA
	YHD71ej/Jbe34Gdc2tJsgdDOvRYpkCA=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v5] mm/sparse-vmemmap: flush_cache_vmap() after
 hotplugging vmemmap
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <99eac2ba-a4e5-4885-aa81-b0c43f6fc4b2@iscas.ac.cn>
Date: Tue, 7 Jul 2026 17:07:00 +0800
Cc: Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 linux-riscv@lists.infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <77B0BBBA-0CDF-49F4-9B07-D35D0D864612@linux.dev>
References: <20260707-mark-after-vmemmap-populate-v5-1-77d1ded3cae3@iscas.ac.cn>
 <99eac2ba-a4e5-4885-aa81-b0c43f6fc4b2@iscas.ac.cn>
To: Vivian Wang <wangruikang@iscas.ac.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9708940005
X-Stat-Signature: h7kqhx8j9g4tbzfw8t7mc6yj6uimxs37
X-HE-Tag: 1783415259-194417
X-HE-Meta: U2FsdGVkX19R6i6LYugK+HKHieqUMs5C5ps0ELmO5aCstHJYCE3lrTHbygrFbaFARwU9tw0NcdJXoRyBWW4y98uI2mqDCvLSDLglW48OXlfDr1BTvzoZt2JQoYKNj9Qcb2En2+waEnidr/0Z3G+L+rmci0xB5pnPbmBCN77zYDDRw7MVxV9RLgE47FS75ZeJELMqNp/6RQ1DDMVVNvKCqaZlX5UKwNgMEwix7subV8qRd63QAnNHGmsEeJTPYIvh4hphm2WWYcccZv2IJaymZ+y8NMf0SsYV1xcHdQRe/o+4qsHzNMDASgZ7YZ2csOtMFvhH2/C2M1gVOHumWfzVjyGxVyoYcpL8JF0IFSAO/kvO4+OnZNGd6q4lQJgf9wkc8sCOBYLI71t0kb+IM/u39SWMmF1luYYOMYnU3ztbfyQxBCCycixq9P+khJ0lbGXwX9p7uZPCa/usB/OIu1bK0lN3OwafVVNButojS0FLXswCJ+iJGKuuVKr+cWhRnOOwDrzzCrRT2IdIhWpv0JUxbSPsVxM9gymK/HFBrWP0z+8M5tQL2MMIWwgDk9llO7OYQwOKtEEevcI9Hdrgg4A4pZPrbORowc51TPPAE6j6PrpOi8eHN4I7uIShSJUxyhyL/Ms0R1NjzdwGkk8fMbD49hz6qLGXGyPEnol11sjwlh3Kq8YU9ItYqViJAfR57+4ZpcQSf84y+V9ey920qTRw0GVjekNsKhCLtMyXtJTtusQyGSOZIHreGNBDwD2ENGzfBeXPkUFaLP6SzQh8BowbbwfppGunIgOUrIvxvMDRnfVKVlg0H5ZBbYwjlVu4Wl+ysbQu/5P6hZNJXAFGLvBvDygnPyrFrMzCmrMGyPpDyjeHbOMdErNypNsHUs2vx7dNkvD16mWhPLoY6tDynYKfjyrQ5GXRrXkUv3cNDe3Axwu2nUwm6kX6zlNiOCQaY30RM4MiRqEGCZ2iX41lbrZ
 SIvATD/Y
 UGIYlNz3GM1ViArP25lfYdKitA7mjGrPOF6up2EUfrM8AEQr3wT74joRnfPFqldlAZXQqi3Oz357Hd5pz+35ZwTJ10+iR5cCG1BC81ppVE5dzBy0yOWpWAuRkRW7g3qFpAPUGNzN7IiCmCHBZKFhGwlhb2jRQsoNIJXGd+Um+SULHpkWBYTR5T759TTBY1s9A6cJ1DigUNoFQ/0o0nv+r4CxRiyD04jOg86vnr4tkC55t6Qk+0FS7yTIKEtVEg88FBRDkR2W2NHdZCNl+c72qSIvB2Sczr4BPJ1+F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 7, 2026, at 13:03, Vivian Wang <wangruikang@iscas.ac.cn> wrote:
> 
> Please disregard. I made a mistake while submitting this patch.
> 
> I'll send a fixed v6 later. Sorry.

Please fix issues reported by Sashiko excluding pre-existing ones.

Thanks.

> 
> On 7/7/26 12:10, Vivian Wang wrote:
>> section_activate() does not flush TLB after populating new vmemmap
>> pages. On most architectures, this is okay. However it is a problem on
>> RISC-V since there the TLB caching non-present entries is permitted,
>> which causes spurious faults on some hardwares.
>> 
>> This seems to be most easily reproduced with DEBUG_VM=y and
>> PAGE_POISONING=y, which causes these newly mapped struct pages to be
>> poisoned i.e. written to immediately after mapping.
>> 
>> Extend the RISC-V flush_cache_vmap() to also handle the vmemmap range,
>> and call it after hotplugging vmemmap, which gets the possible spurious
>> fault handled in the exception handler.
>> 
>> At least for now, the only other architecture with both
>> SPARSEMEM_VMEMMAP and flush_cache_vmap() is PowerPC, which has a similar
>> problem with newly valid PTEs. But there flush_cache_vmap() is just a
>> ptesync. So it should be safe to do this for generic code while having
>> minimal performance impact.
>> 
>> Suggested-by: Muchun Song <muchun.song@linux.dev>
>> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
>> ---
> [...]



