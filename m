Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E33FC9830E
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 03:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1244F6B0088; Tue, 29 Sep 2026 23:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5A56B008A; Tue, 29 Sep 2026 23:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2E4F6B008C; Tue, 29 Sep 2026 23:36:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3ACC6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 23:36:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A74A1606B1
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 03:36:43 +0000 (UTC)
X-FDA: 85269016686.07.170DF65
Received: from mta1.migadu.com (out-211.mta1.migadu.com [95.215.58.211])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6BD701C0005
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 03:36:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="VvU+1/Vn";
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.211 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790739401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GaukmM70bz4gv8YLyrONjoJJu3qhnIAvGdHMKYlbNUE=;
	b=LcFW+WAGwgp+7x/kSNQTHHrbuDYDn8SGD4jHBIiZcDrrMfDh8BJBxZvTJQksMh5zPfykWZ
	1uYaLPb0p/Jda2t44+Lv8L97Fi5SAkblK5sbBY/xun2ZFGI31YzJDBRa7fRpESk+NZXm0E
	uIgNh6lREfUFwdKdB3AFz4epInWzoC4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790739401;
	b=GOf/3iTc21fVsZ5p9ALx8NPvdZSVcZm2wWUE0gRl8i1hnvsJ45bpdB31dnyebjJ8Y4ALBh
	vKcX2s312ArO1oceMNMcI01ADZm95O9N5BLLuIHf+mTNCZNY3YgJ+RG4Hc9jHzAkGiEQrb
	PrnS+5ctVKchlbFXhHQ7/XZTfq7GW9E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="VvU+1/Vn";
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.211 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UGu6hnp7zOzIji6/SbzCysLcwMM7yV0BdKnkgtzfNIQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790739398; v=1; x=1791344198;
 b=VvU+1/VnbPIh/soOlHQ3yAjfFdjnE05G4a6JM3kzNVkS3xXrPEIeaBD61771dm0Zmp234NjV
 9qdtKPRd8uIc3Xu+mbZMgaDYyVXOWS3g0DEZ8f4ZnI50BKpzZ1EhAqxgbGEL5e7pMroJuex7rH/
 nnA9j4+F/DeUPIBYsHmqYrBM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 9bc00279546608ff;
	Wed, 30 Sep 2026 03:36:37 +0000
X-Mizu-Trace-ID: 9bc00279546608ff
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <aruyFPzEe3pS_Qzx@XiangdeMacBook-Pro.local>
Date: Wed, 30 Sep 2026 11:36:23 +0800
Cc: Jialiang Huang <huang-jl@deepseek.com>,
 lance.yang@linux.dev,
 baohua@kernel.org,
 damon@lists.linux.dev,
 david@kernel.org,
 kunwu.chan@gmail.com,
 lianux.mm@gmail.com,
 linux-mm@kvack.org,
 mst@redhat.com,
 ryncsn@gmail.com,
 sj@kernel.org,
 virtualization@lists.linux.dev,
 xueyuan.chen21@gmail.com
Content-Transfer-Encoding: 7bit
Message-Id: <AA71E56E-F29A-44B2-B5A0-7806CD684B21@linux.dev>
References: <20260925054408.10431-1-lance.yang@linux.dev>
 <20260929123241.1408414-1-huang-jl@deepseek.com>
 <aruyFPzEe3pS_Qzx@XiangdeMacBook-Pro.local>
To: Gao Xiang <xiang@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspam-User: 
X-Stat-Signature: t1b6mq8bzbbe87jnpury1a679aafojqh
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6BD701C0005
X-HE-Tag: 1790739401-178043
X-HE-Meta: U2FsdGVkX19bKwSsCn7LsLw6xEf9svcUMdSNj3JJws/baa6CoHiNGrAb11PCG0RmDpvTnqeRSu1CeuZfNUff2SXCkbBjYn3Z5L8Tfj1UetpbQLOHlzk52MTFQHw7zwy5KsDJ6VZ+Xoknaq06OcQ3um1vun1Wd92cSQKGu9/49/egnncWVykXKAoRxyED46OECOJfIKr0RPEsJPjch6fBUQVjYs3j+wexL9quwSjn5pWsTpOfhlIL9YCSqRKovHqLrnTjikbMrXMw3eEowTX4ZXwZIJIrFDKx4u9Pp8t5uP2DXD6QK1+AeDarEAUI5xkBbj9LzQylJFoHlG/mgmNaOFgLBdiEykjVIytqs9tybS3xOek77oaOrOr8NhIPiqCq3FuzvqTDSvifaoGVxSdhjJAgRzmlSWOkVp6KaBrW4ZV9ntAnCDWtYAo4Uy4cgfArGxRms4QeUvLMZzRpIZ+pY07GiLGFKaO07HxGYjT6cnBjuKF0LTFGvjJDmYBjo8ik3y2eEJ6m64BEtzHPjLXSWpzQFJ30yRtEjdgQOZ5lwVhUNx+Bp3IhoV5HUZ00ikSCWGnLm1SiET3gTTSkL62Ow2HSqVCcVzM6XTaa5uEFz2ZoUB5WnEl/4M0cK5m4QgITuyDeKCG3k94lNGQKvjBw52qxYIjR2S3mCaELk22wPl3GHizJ36nRie54grHik5EJnwSvyedqJALil73sb17mrGL4gcn58X82Kwdi3n7Mb9DCoxakIrkVbInpJpuY1LvoxfVDDgufE0jDlwniQba45OWNGlPIZD4im/XngNL68WdDKJt1Fv4KCHi3BKBvLe/rPRd9o0tUKOwLRQXjdpOftrQWYzsFp2hWj91mHitBUYR6kkvXi91MNDrHfh4tkxTSzliAWOC3nAuYu8ooJkIk/v06RNqoOD20c492NrSRUwQh6BByqVgbp9l/ogBFw9oY0+nmMY40haQeAs4kSJr
 XWBWyv3m
 kLjLSwmwMsDdfMjI6nzM4jzM2g/xF3Ew9N5W/B+a986mbZ/WTirSzIH01e+Y/bFV4cNoo2pQEoYPMOfu7O1gccfSo78/exW07c/sPbPbGiGx8bXUcoUyJ88wBpG80ibu7/PwT82/teNCNuiHmaErdOIKy2PP3C8qFLyIdgd6YERi0VQqhFxKP5SsN7zpyE3jIfGV8KyVy3T5/dvpQxA1gSakH7kLxp8bKz01YWELZxvJ4BMip9ZSO3S4R4eENN3qkt4ycCQA0hWGeZvUx+hAGkkO5kwlKNj6lp06vmFxFNybvAofJp8QnpY2vWoLVgV1yDldUDurYgk336P7cNQUT5yuG+Ai0I5cIoCfsnAIasuYKgyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 29, 2026, at 20:41, Gao Xiang <xiang@kernel.org> wrote:
> 
> On Tue, Sep 29, 2026 at 08:32:41PM +0800, Jialiang Huang wrote:
>> Hi all,
>> 
>> I'm an engineer at DeepSeek. Thanks for the discussion, and thanks
>> to everyone working on DAMON and virtio-balloon free-page reporting.
>> They have been very useful for our workloads.
>> 
>> Gao Xiang wrote:
>>> It can cause sync 4K faults on the host in the worst case
>> 
>> This is one of our concerns with virtio-pmem as well: moving I/O onto
>> the page-fault path can introduce performance trade-offs. The other
>> concern is the substantial struct page overhead for large images.
>> 
>> For now, we enable virtio-pmem only for moderately sized, frequently
>> used read-only images, where there is more opportunity to share the
>> same host page cache across sandboxes, as Gao pointed out.
>> 
>> Muchun's vmemmap work is also interesting to us. My understanding is
>> that it allocates private backing for struct page metadata on demand,
>> which could help reduce the upfront memory overhead for large images.
> 
> Although I haven't had a chance and time to look into that, the main
> concern from me is that mmap() access will call
> "dax_fault_iter->vmemmap_materialize_page()", and malicious sandbox
> workloads (or not malicious, just valid mmap workloads) can cause guest
> memory OOMs due to "struct page balloon" for large rootfs in the worst
> cases and cause the follow-up mmap access failure, because the guest
> memory size may not even fulfill "struct page" for large rootfs.

I agree that this is a real issue with v1.

One detail is that merely establishing the mapping does not materialize
the metadata. Materialization happens when a fault resolves to an
allocated DAX extent, before its PFN is inserted into a userspace
mapping. However, that distinction does not remove the problem.

In the worst case, a workload can fault enough of the pmem range to
restore the full vmemmap cost, about 1.56% of the pmem size. Since v1
does not dematerialize private vmemmap pages, even a one-time scan can
retain that cost until the device is removed.

The follow-up mentioned in the cover letter is intended to make the
optimization reversible. One possible direction would be to invalidate
clean DAX entries under memory pressure and zap their userspace
mappings. Once a DAX entry has been removed and the corresponding PFNs
have no remaining mappings, references, or pins that require private
metadata, the associated vmemmap backing could be remapped to the
shared read-only page. A later access would fault and materialize it
again.

This would address the persistent ballooning caused by a one-time scan,
but it would not help while a large DAX working set remains actively
used or pinned.

As a separate policy mechanism for that case, one possible direction
would be to account the faulted pmem range to the faulting mm's memory
cgroup: PAGE_SIZE for a PTE mapping and PMD_SIZE for a PMD mapping.
This would intentionally account the mapped DAX capacity.

Such accounting could be explicitly enabled through a cgroup v2 mount
option, following the opt-in model of memory_hugetlb_accounting, so the
existing FS-DAX accounting semantics would remain unchanged by default.

With such accounting, an active or pinned DAX working set could still
reach its cgroup limit, but it could not grow private vmemmap without
corresponding cgroup usage. This is only a possible direction for
bounding the peak working set, though, and I have not worked through
all of its implementation details yet.

Thanks,
Muchun

> 
> Thanks,
> Gao Xiang
> 
>> 
>> For disks without virtio-pmem, DAMON with virtio-balloon free-page
>> reporting lets us reclaim cold guest page-cache pages and return
>> the memory to the host, without those virtio-pmem-specific issues.
>> The two approaches complement each other in our setup.
>> 
>> We have not yet fully explored how best to tune the DAMON and free-page
>> reporting parameters for our workloads. For example, the kernel's default
>> free-page reporting granularity is 2 MiB, which is fairly coarse:
>> reclaiming cold pages does not necessarily produce free blocks of that
>> size. We still need to evaluate how finer reporting granularity and
>> different DAMON settings affect memory savings and workload performance.
>> 
>> Best,
>> Jialiang Huang
> 
> 


