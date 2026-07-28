Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46297C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465EB6B007B; Tue, 28 Jul 2026 11:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4177B6B0088; Tue, 28 Jul 2026 11:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32E046B008C; Tue, 28 Jul 2026 11:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA7676B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:17:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B375A16044C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:17:30 +0000 (UTC)
X-FDA: 85038539460.07.357244D
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id C807D80006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:17:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qdxJJmMd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785251849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJOfNjImE/vhHrHHh6wGaW6sGg3JuvKUdiSVtRAfDKs=;
	b=isv7oshXpF5AVziRbd0/CMDhXogLFH2q+qtZkV3f16UZage3G2zzcXKnm38VDtln/pHsqE
	Tf6oZ5YAwiLZVPMGHD6/50XwagqA/5DxueHZQTWcKkcFof9r5sr3hAa+9dJs9c1an/wTyl
	1i/4ZA7WGgFgACBK9Jvfz3TYm4+dtOM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qdxJJmMd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785251849;
	b=Cec7BOXf99sFGyGnQ0vckxUBpGPIpL4q4JrX3m1lYM/RSHf4gG71CixXX/At3X7CLAJg76
	aAKfpktF7e4bO2ULfg2RZb3j8onRzuMjuZBD/n0H+znZIMOxGPZqS8UYD9SisgIwjCstrY
	6EFFUlktrmpXKYC6ZRuir6A+Vagj/z0=
Message-ID: <1c815b59-915a-414c-9029-eaac11dcf804@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785251847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JJOfNjImE/vhHrHHh6wGaW6sGg3JuvKUdiSVtRAfDKs=;
	b=qdxJJmMdA2yv0M5hrtFZeB6eH1ubg2oqLU/AaY0cpynGN7ks7FUkH2orUeGww/ktQ97oJF
	PSNEd1Bkin+HPizo6fvj4Fa1TocVW1gu2dqF46otndcbC3Q4jSppWgMaopKp0F0ZlYv3sC
	cYMpYoAqObCI9iY1kuGpIKmxEX27FUg=
Date: Tue, 28 Jul 2026 23:17:01 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mm/damon/core: cover discrete System RAM areas with
 per-range regions
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20260728143046.95229-1-sj@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260728143046.95229-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C807D80006
X-Rspam-User: 
X-Stat-Signature: gwdczb4hj63rt3q185n3c5sn9ky4wue3
X-HE-Tag: 1785251848-23941
X-HE-Meta: U2FsdGVkX1+UpmujWnvYBLSao8uydka842SkswOlIHiuCgArOBEH0mehYd321AbZe12a9hb4VEIjpaBNn8ZflHifA/eTMZKVfBG5L2aP20+nkkLRXW6IcXKXhrIHEf92dD16gBTyZ6Awy+zjuA8FjhjRJzmt0+cpf5oUtRdvuZppXgpLlhbg9WWhsVuZUXI+fNLxn/nIeOq9DKjOUklM7jqg/ZhKzlqE/YlQkYgWXmRnrJFCZaiMbNKk1zlZjt1/9nfOu9D6+Z5WCXiOhmpNHF3gBwizC/+CN8lHIvdDrHFg+hQc31X179zgM2nHqCAEcLVJeEu+4RSkKl5l7xaStpfek67TAZf0FrKU92OwBO35+2mIIzeTSRt2ydK4h4yHfWopyuWf712386PxRvD/IQH4EfVTFwm/AeuxrfofRih3E7WliouVg/uqZrvg+Ki6Rpt40rmrLMG2n87wGBZIgJOZL/AESDJSp9hKgEPoi5YwCDqnxpAHXTttQkNjukOfWVP4MpMXMqJxs5iZ5tsl1TzMztUEIwSt3gNRTeOtAWiICH2RsEIgiqwLJ/LwELtQUZLgB4NzAxWXhrCRvaJt7u//IVUnnQBoJGHKY93KaM59keelGw3yVgiGgTMRwpmypJUSEuPc5oJp2ndLbH5SH+bi/hqHYEi+wOnykrrZOSk19a4YPWE10KKHuuAjDO9Sbr5/QFtFu5lrnCDARGYEklvtWxakqW1fsNoIiWWhpcTUpMNgxUsXQ1G6qqExISKHt6gPVUhYd/W1LtMDRKS/BiiMuZQPi8GQ//hXSyVQqIK0qFLFE8p4ZtUVJmxMJfcFG+PU1+S9EuEGQC7Xh0z4U5mCbsey8GeqovFYcvy676jiBFuypIP6MPSzcUUzSfv/uzB2nevKhHUrUaku6sEo48461yLSkrlcl9BOuFIJ14aYtPctYRW/Yb37k3WAS8gVEDhyLQm8bobV3kdlaBR
 ERCL8f1W
 HJpKl10HEK6m1jhDjN7bGZbo4xYm9xasYwzE0G2X3txFv9/f1ko9hvdxNoaEwpZJ7XPNnWHErBL3QBGUSbI7awYsSQ3656t/rggZI7ALJCCOw8B/TA1ByTEHwqhZoMTICcxVwQxXARhO3mY2i8BUlTF49J3KIXBHSkvmwaL0XJmBLhSuJ7/AlA8UZDgwdgNt+QTH4S8qcqG1Z3Cn+5AVf49005w09es2Zhe5u+AogvUbHnilrXFqZsn3P8nVhLDahW5kqp//2GWDBXR1kDZa+2yEvthnoPDELvL8vQz3jSUg2Q/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/28/26 10:30 PM, SJ Park wrote:
> On Tue, 28 Jul 2026 18:06:48 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>
>> On 7/27/26 10:26 PM, SJ Park wrote:
>>> Hello Jiayuan,
>>>
>>> On Mon, 27 Jul 2026 17:54:22 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>>>
>>>> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>>>>
>>>> damon_set_region_system_rams_default(), introduced by commit 70d8797c15d6
>>>> ("mm/damon: introduce damon_set_region_system_rams_default()"), is used by
>>>> DAMON_RECLAIM, DAMON_LRU_SORT and DAMON_STAT to set the default monitoring
>>>> target address range covering all 'System RAM' when the user does not
>>>> specify a range.  It walks the 'System RAM' resources but keeps only the
>>>> start of the first resource and the end of the last one, and then sets a
>>>> single monitoring region spanning that whole [first_start, last_end] range.
>>>>
>>>> On systems whose RAM is split into discrete areas that are far apart in the
>>>> physical address space, that single region also covers the holes between
>>>> them.  For example:
>>>>
>>>>     $ sudo cat /proc/iomem | grep RAM
>>>>     00001000-0009ffff : System RAM
>>>>     00100000-4848c017 : System RAM
>>>>     4848c018-48550c57 : System RAM
>>>>     48550c58-48551017 : System RAM
>>>>     48551018-48615c57 : System RAM
>>>>     48615c58-48616017 : System RAM
>>>>     48616018-486dac57 : System RAM
>>>>     486dac58-4e563017 : System RAM
>>>>     4e563018-4e627c57 : System RAM
>>>>     4e627c58-4ef39017 : System RAM
>>>>     4ef39018-4ef3f057 : System RAM
>>>>     4ef3f058-4efe6017 : System RAM
>>>>     4efe6018-4efec057 : System RAM
>>>>     4efec058-50247fff : System RAM
>>>>     50317000-56720fff : System RAM
>>>>     56722000-59c19fff : System RAM
>>>>     6bbfe000-6bbfefff : System RAM
>>>>     6bc00000-777fffff : System RAM
>>>>     100000000-1007effffff : System RAM
>>>>     67e80000000-77e7fffffff : System RAM
>>>>
>>>> Here the last two areas (about 1TB starting at 4GiB, and about 1.1TB
>>>> starting at ~6.5TB) are separated by a ~5.5TB hole, and the single-region
>>>> setup makes DAMON treat that entire hole as if it were memory.
>>>>
>>>> This is harmful in a few ways.  The monitoring target regions are limited
>>>> by max_nr_regions, so regions that fall into the hole waste that budget and
>>>> leave fewer regions for the real RAM, coarsening the adaptive regions and
>>>> degrading the monitoring accuracy.
>>> The hole would look like not accessed.  As a result, the whole region will be a
>>> few regions that very cold.  That wouldn't waste the budget that much.  Do you
>>> have some specific setups that this cannot help?
>> It's my mistake.
>>
>> I first saw the kdamond CPU go up, and I assumed it was the number of
>> regions. I was wrong.
>>
>> I re-tested and profiled it with perf. It's not the region count — it's
>> the page-by-page walk of the hole.
>>
>> On a VM with a 116GiB hole and a single [first,last] span, I enabled
>> DAMON_LRU_SORT and ran perf on its kdamond:
>>     30.15%  damon_get_folio
>>     17.09%  pfn_to_online_page
>>      2.24%  __nr_to_section
>>      ...
>>      0.07%  damon_split_region_at
>>      0.06%  damon_merge_two_regions
>>
>> Almost all of it is the per-page folio lookup. Merge and split are ~0.1%.
>> The cold scheme targets cold, old regions. The hole is never accessed, so
>> it's always cold and old, and it matches. Then the action walks its whole
>> empty span page by page, every apply. RECLAIM and LRU_SORT do this by
>> default. It scales with the hole size, so on the real 5.5TiB machine the
>> kdamond can't keep up.
> Makes sense, thank you for investigating and sharing this!
>
>>
>>>> In addition, DAMOS actions on the paddr
>>>> operations set walk such a region page by page, so a region that covers the
>>>> hole is walked for its entire (empty) span on every application.
>>> That makes sense.
>>>
>>>> Set a separate monitoring region for each discrete System RAM area instead,
>>>> coalescing only truly adjacent (no gap in between) resources into one
>>>> range, so holes between the areas are excluded.  The reported *start and
>>>> *end still carry the overall first-start and last-end, so the user-visible
>>>> default range reported via the module parameters is unchanged.
>>> I'm concerned if this could result in having too many regions.  The gap between
>> On the region count: can't we just coalesce any hole smaller than
>> min_region_sz?
> I'm not fully understanding your point.  min_region_sz is only 4 KiB by
> default, and anyway DAMON cannot create regions of size smaller than
> min_region_sz.  I cannot get how this helps.
>
>> After that, the number of ranges is just the number of
>> discrete
>> System RAM areas
> I'm still not convinced with this.  What if the number of discrete system ram
> areas is larger than max_nr_regions?
>
> Actually I was also thinking about this problem for in the past.  One of my
> idea at that time was, handle only a few largest holes that practically being
> problems.  That is, while reading the system ram layout, find the holes, sort
> those by size, and do make holes in DAMON regions layout for the biggest N
> (say, 2) holes.  This may handle most cases including your 5 TiB hole.
> Actually vaddr is doing this, so we may be able to reuse some of the code.
>
> If it makes sense to you, I will try to implement this.

One worry with a fixed N is that it's a magic number. If a machine has more
than N big holes (more sockets / NUMA nodes, or several CXL devices), the
extra ones are silently not excluded and get walked again.

And making N configurable just moves the per-machine tuning back to the
user, which is exactly what I'm trying to avoid.

vaddr over-includes the gaps into its regions too, but it can skip them
cheaply: it walks the VMA tree (find_vma / maple tree), it's cheap.
paddr has no such structure, so an included hole is walked in full.

That's why a fixed N is safe for vaddr but risky for paddr.


>>> user-visible parameters and internal state is also a concern.
>>
>> I think monitor_region_start/end is meant to expose the overall range, and
>> skipping the holes inside it is an implementation detail. Even if we didn't
>> skip them, the adaptive region count is never 1 anyway — DAMON already
>> splits [first,last] into many regions. The holes just add a few more, so
>> the param never matched the internal state exactly to begin with.
> It is arguable, but I believe this also makes sense in my opinion.
>
>>
>>> A quick workaround would be adjusting the memory layout in BIOS, using DAMON
>>> sysfs interface instead, or setting the monitor_region_{start,end} to cover
>>> only the single area.  Have you considered such workarounds?
>>>
>>> Let's complete this high level discussion first.
>>
>> Right, this is doable today — the DAMON sysfs interface can set multiple
>>
>> regions manually. This patch is only about convenience.
> Are you actually running DAMON_LRU_SORT or DAMON_RECLAIM in a production system
> having 5 TiB hole?  Or, planning to do?  If the above idea makes sense to you,
> I could prioritize implementation of it depending on this.


I'm not actually running DAMON_LRU_SORT or DAMON_RECLAIM on such a machine.
I ran into this while working on per-cgroup hot/cold page tracking, where I
was comparing performance and accuracy across setups — that's where these
numbers came from.


>
> Thanks,
> SJ
>
> [...]



And to be clear, I'm not trying to land a patch here — I just noticed this
as a possible optimization. If you have a better idea, I'm happy to go with
it :).


