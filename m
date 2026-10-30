Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02653606A324
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 01:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lukwMlAI
Received: by kanga.kvack.org (Postfix)
	id 1264D6B00EF; Thu, 29 Oct 2026 21:42:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D83A6B05B1; Thu, 29 Oct 2026 21:42:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F7B6B05B2; Thu, 29 Oct 2026 21:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D78406B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:42:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F996805A2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:42:54 +0000 (UTC)
X-FDA: 85377593868.18.C4A333E
Received: from mta1.migadu.com (out-159.mta1.migadu.com [95.215.58.159])
	by imf03.hostedemail.com (Postfix) with ESMTP id EFC2120003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:42:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lukwMlAI;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793324572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBxZXYh+rnyuptLvE+V7HHrJXUSfiI1BqVTzYuv0qLg=;
	b=JdxN3X6Z06+ZPjPHbqmlTQfSImioNEylhtxsFrqNpC1atxorcKZhLTM02CZXDzvMf3XmpI
	K6453GSrSh5ml80nnKuIoF9+1t4hm3F7AZryfx5UigOaocC+pNiOub2iSK2rQEFDiZQ/Ub
	o2Ed4/IEvBze/nKmwif9/MB3FEbE7ZE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793324572;
	b=7eyMDTxjzVchp5k/OYWnKYieKEpWCCBsipXxtByxGUrdFQ0QmNxeCzXqnUxs9vzLU4JzUf
	7ggKxovXqRi424c50U+6XodVKWSIGN2ihubRk/XBcHD/UOVnwUQ6ZKcNZrVXixhw+Em9tH
	o3pBeR+TurMAf5FUsXntcN4TyQBbRUU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lukwMlAI;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XomdjP+6ikw1iX4kxUba8UKw1CJW8x9SToeoXhnrG8A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793324570; v=1; x=1793929370;
 b=lukwMlAITGr9IA/sK8T0syVHmcChoj5Q/uek9rr6NPuA2s/7JdlUejj3nZSXe3FU/XQsCCZd
 ZJyT6kRSoGfSvGlJqzHWpru2mjJgnjgkSR/ZJbTbcTXibKs2UK/Lspguz0WXIKi3lhf2OsIxTaI
 +1bl73qDjF6btvPR7E9iO5hA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 304e299b05c364b4;
	Fri, 30 Oct 2026 01:42:50 +0000
X-Mizu-Trace-ID: 304e299b05c364b4
X-Migadu-Flow: FLOW_OUT
Message-ID: <eed3526e-9cda-45da-98f6-6473238ce4ef@linux.dev>
Date: Fri, 30 Oct 2026 09:42:45 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new] mm/migrate: move NR_KERNEL_FILE_PAGES on
 cross-node migration
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Boris Burkov <boris@bur.io>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Shivank Garg <shivankg@amd.com>, Ridong Chen <chenridong@xiaomi.com>
References: <20261027043214.2248986-1-ridong.chen@linux.dev>
 <20261029180326.84ae7b2c1f63f016c66bd28e@linux-foundation.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261029180326.84ae7b2c1f63f016c66bd28e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EFC2120003
X-Stat-Signature: wydk75j3a9xpu8y1hywdefj67aisn1u5
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793324571-209852
X-HE-Meta: U2FsdGVkX1+Oft82zH37b0+hmDKCYblUs5pRrNsAqOFmLJhTKsW+QHbwEUIZ1GD38jZGvQPpI7TWXFx3dzz4qzAKqNMbeeDYcu67VqbhriOUP34240zP8FcXt2t4bsUCI89zoBIR3kBDs1ny1d+4s//QIL3ggXSZb7zR5MuQgw8TE/CWCyScQdC/f2MC2QuVLmHVHuYNxvJFeFMFE1cbQrP3qPH4+CRb+Ru/V3dFAODCfET6K43BvgX0+8zcRPDZbwAoBBg3+c7UD5t3FGh20UlgirJJ6/M/dfyhfT+lAn757fUvsBhRamhjJzL+2INog84Ml8s89YaEvWDx3UvlEr0unKTYjKDDzflMqG9xoL5JHUIxuMPoMNqnaJ9t78sv4o7FAYTazzzDPUbBjF5YVaO9C+uyK1g9A0VuP5IgUZPh0u6XrkZhKldvyKg1kkNeFuwE1Jdf+LvPS5BRY2TaS1JoOyIQIgv2u4lCSks+VDP6PkZdrfb04tb8po/zEYrW3ZjN4cXBtXt9YZ8FteQU1elwHPMbCTT44Kv9U86KlJfP+0LcJpfidAAcyhTUIQWS0KisaXx2C6uyKxI4IycU/67LSWSPpfxK3Xb4Am2ZAQCQIoVMsH8CWC7Ptzf/7MJl9EQHM0ujW0YQNODE5wUiASNDGKg3VDwnv1JXj9dhlcoHVlXA3iU1UJzbssBMTeI6W610ogHv230y3p2f/257wefmAMVFOj7mzKyYdKuPojGmpw8fYQuUekzgKIQtQLPg8Hai6gLozRdJfW2i4s1RimsUxk61UiE5n7S7J1gI5dwu2DeFvpYJAe0RH5M9n9MrYxcElaExGWumLnX2C9OfXv+P6hqisnpEpew0ZCgFlUFY967MslRsuwwQ3SXcEyjh+Rpizc4FNMhlmqMtY2/+HBCYGWKVasIjNkCi85OE7GO7Jwtc04OdswE580xToJPwXhYLIQVGQUcvjrUD3O+
 DZhX9tTM
 uzbSumZehUvCI1LkcWFYVjtjPAJhRMHmp7vaV7dK02kc46Ssw6Q0rivEPjcWPcD7fv1pF/3NNQPUejBsoUJJidiQhPo8YibRB0nMovK/uyemNZm7EHgPLdqBzjN7xeiIEiDkQ6rXxbAt15KsLsQFq0zi13fv6neOJPYPfBtEVrIaT61WtY3OJMSQkNLyOvfTD3GKRAAKvhLAxUhtEJevP9LF/kxkic8xMUXEOUM0mYiMEFUe0JBz731nlIIO8nsfJXyUVE8O7XFQlmudN8kuWkNWjA4bQTq4g2YuN4AKOUg93PLHmfZdfp8g5DVCGvPQY2j6CQzdF0w6TJ1nI3990nz4IkhAXAVNNE2WoeS/MeDxa8rJrbhtDzArkzRr4KXSrG5N1Hzjjb7WT2axc+TJ/bYl6VpHvSLblhPMKoiPVXEkfvoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/30/2026 9:03 AM, Andrew Morton wrote:
> On Tue, 27 Oct 2026 12:32:14 +0800 Ridong Chen <ridong.chen@linux.dev> wrote:
> 
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> NR_KERNEL_FILE_PAGES counts page cache folios of mappings flagged
>> AS_KERNEL_FILE (currently the btrfs btree inode).  It is a per-node
>> counter: filemap_add_folio() adds to folio_pgdat() of the new folio and
>> filemap_unaccount_folio() subtracts from folio_pgdat() of the folio
>> being removed.
>>
>> __folio_migrate_mapping() does not move it when such a folio is
>> migrated to another node, so the source node keeps the count forever
>> and the destination node underflows once the folio is freed.  btree
>> folios are migratable through btree_migrate_folio(), so demotion,
>> DAMON-based migration (DAMOS_MIGRATE_{HOT,COLD}) or memory offlining
>> all hit this.
>>
>> Reproducer, on a QEMU guest with two memory tiers (node0 is DRAM with
>> all CPUs, node1 is a CPU-less slower node described via HMAT) and
>> /sys/kernel/mm/numa/demotion_enabled set:
>>
>>    1. mount a btrfs and create 20000 empty files, so that btree folios
>>       are cached on node0;
>>    2. echo 2G > /sys/devices/system/node/node0/reclaim, which demotes
>>       them to node1;
>>    3. umount and drop caches.
>>
>> nr_kernel_file_pages in /sys/devices/system/node/nodeN/vmstat after
>> each step:
>>
>>                    without this patch     with this patch
>>                     node0     node1       node0     node1
>>    1. cached         1868         0        1868         0
>>    2. demoted        1868         0          36      1832
>>    3. dropped        1832         0 (*)       0         0
>>
>>    (*) the counter has underflowed to -1832; negative values read as 0.
>>
>> The global value in /proc/vmstat is 0 after step 3 in both cases.
>>
>> Move it together with the other node-keyed page cache counters.  It is
>> a node-only counter, so use the node accessor, matching how it is
>> accounted elsewhere.  Interrupts are disabled here, as for the zone
>> counters below.
>>
>> This was pointed out by Shivank while reviewing the NR_FILE_THPS fix
>> for the same function.
>>
> 
> Thanks.
> 
> This and your "mm/migrate: move NR_FILE_THPS on cross-node migration"
> "only" address accounting errors, but a bug is a bug and these bugs
> might mess up people's memory-monitoring and NUMA-management tools.  So
> I think cc:stable.
> 
> What do people think?

Agreed, thanks.

-- 
Best regards
Ridong


