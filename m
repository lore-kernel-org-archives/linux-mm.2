Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FEED606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 02:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=q9EpBH5V
Received: by kanga.kvack.org (Postfix)
	id 3202E6B00EF; Thu, 29 Oct 2026 22:02:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D2016B05B1; Thu, 29 Oct 2026 22:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1646B05B2; Thu, 29 Oct 2026 22:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0FA46B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:02:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81C72A8160
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:02:19 +0000 (UTC)
X-FDA: 85377642798.17.70CAB57
Received: from mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	by imf20.hostedemail.com (Postfix) with ESMTP id 765691C000C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:02:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q9EpBH5V;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793325737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I2goAa7rOJG9DFPTs3OAS354gRoMeX0w/v8rucPDrlI=;
	b=LvjamAsHFd7oqFjBl0R6a3am7nCNei7Plh2ZkhFm3Kb8HP8LpOMJLGHHA7d/hwtNbqJk8K
	sLRE1T5C8SQdolZg0P329RRDWqKHwW2lYaQcsCjYRrcBnR2de+AUnZ0Q48bUfNw9NE5UZZ
	+US27salPsMKzFfsOdNaucFiscLZ/jU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q9EpBH5V;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793325737;
	b=NbJ3jw94+YROLpoYb3xvZMHHKWv6H/P17445Pr/+ulcmINzlZ0uHSI+nRqWKRGXaB46zhO
	yZF9BL5d/4T/ksNUUI4uZYdrHAp3a+4aFL8a2a1u0fnek/Cj7X9nd0mMelcReoQ9I36wPk
	Fncf4d5c53V+Chmqq49TD3/pv3QM7VQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2iq7XbvFNbuK31FsnFvQrU97laf+/qBVznGg0D8pQ80=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793325736; v=1; x=1793930536;
 b=q9EpBH5VBPZJt0TZllqPryjm2JMjhAUSGuya+bK2nrFbfYnsxKUIcM9NF/tGd5TFbqsZHGIg
 EthPMMOk5zDSrBi+MjTM+Wi/1YbfVqTbB485djr52OmMHUF4AmqmMwHTTSXzTY1GAXb4EY5FicU
 8dyf4rNsFZ682r5XSdsGtIwE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fee4872bd9a223aa;
	Fri, 30 Oct 2026 02:02:15 +0000
X-Mizu-Trace-ID: fee4872bd9a223aa
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 19:02:13 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Boris Burkov <boris@bur.io>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Shivank Garg <shivankg@amd.com>, 
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH mm-new] mm/migrate: move NR_KERNEL_FILE_PAGES on
 cross-node migration
Message-ID: <auP6jNHELlVhqmBY@linux.dev>
References: <20261027043214.2248986-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027043214.2248986-1-ridong.chen@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 765691C000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: nkhpcacyf93ncxj8m4ir4mgr5crdbn8y
X-HE-Tag: 1793325737-957185
X-HE-Meta: U2FsdGVkX19c+zaaKu6tkN0WTRwgWeMRnSBX29HaRaUJ8LWHEqvtgtK+rGJ3bz4z9izX3OwyKpRdzssYEd/wMPvfJX0F13KtJuaclm6aSr2xTGYU2gEqGbuUcyTLfrsDKzzCtRclm/ttoOny94bTBU0dQ3ERrMB1pL+IHB7kr9S5/uWq1MhfW2RS0Tg1UrELjRVHYTPCaq5uMfsmUN29GS9xCKaob/aV/khe5fCjBJ246oGjKOMH568/rLSZLFig3hAighRkDkPa/T3rxcki1OvW7FqvFa6WxOkuK3zmVn4uusnuWMsc32cVlfwA2mlydN45LFGinKLANdtRxvn6C75q8GJgxvTqJ9AUZaJRHV0cXeECQ0txl00g5zEMPRsSfJzlV78IcnljVEygBjxB+mFunZMBMxTbWeLOlxtnSE1cRjgaZzOIkbGshtQbp+p4VzSXNq/oFbMlBT1uTWXH8lyPI0s5mcMhR7Q7AE+klPO44J3hKvp1GsnMQo5MF9jlTySH1iWfsDkCX78j5tbeaDneEh59D3JwyoNiRmHZL/MQOb4m+5Q4gWCtztA05zfdm8m/QPprLZaWwGs01j9GDgQ5BrG+fWGD/cHMob+81jBdhk1jcXq1eZVRzkUvmGyP5m5cZ8ACcr1JlzPCC/WGSRoKDr0mPBCIXNvI/M7lzh0FgXMNmeC9WbbAMuHNx3R/My75mByZ3WZ7sxTF8UhAJqRNh662M6zYr4A73NqoYOUXfSbwjboZNEIgO2kzwfEKVyZdZ6TAQbxQn9jtQNPWMxBAmT4zSCtM1FC1iU6hnLHGLHnQDiLJFcFYZc83UeiXtIDKDZi5tV5/cQvOEWUodRaAvoCG+llwkXWr7xy2A50Ovma0F9ETR6t7MzVDoSsMGbr5LJYFfAsIJDy2z2lzaxMNj6LGpnJhVVK/3LFEPqEtk7dvLd1tc3YizkTLIstqLAnAfHh1ExZw28jgl5i
 JYbq10Pv
 ZhcA90PX/2PqX87WaQI6a10jSF6mtlrtMgpHsk9xTfICSZ4GVMNXQMErjjB+Vm/iE6QQNkoOzCpYWImP4e2iTeA9BZNtNipyXD1K2o3+ysxAYnWVH/Vz33uMHaf2QSiRZS4wq1RWnKL6ArdK8BlpYEyXZUYcaaU/lEbjRZJ0+G/JiQCqeKsAqTjN4UpgOrLF1iqSFzoEhvlMYWZMDPoxUyrI8ds06b6oWluEYUA/WsMVoWPfQtN3QXfKvyLiJ2kbBEeygjQDMQO9ycbN68o1rgc8VEwTo101sGLaVEN35BLat0+leI1BpdUqF6o8Xhsv3Ovx2OQtMddZetCTuoZsyMO/cap/r5BpxPrDsxJv19tn/z76lcgOCQ56GtbYjvr9x7Sj71pwQBBoymmow743FHhqB0PQhz1dIM3WbaLee1EO8ctIDwsBtgtaEeB+B6wX8RK+i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:32:14PM +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> NR_KERNEL_FILE_PAGES counts page cache folios of mappings flagged
> AS_KERNEL_FILE (currently the btrfs btree inode).  It is a per-node
> counter: filemap_add_folio() adds to folio_pgdat() of the new folio and
> filemap_unaccount_folio() subtracts from folio_pgdat() of the folio
> being removed.
> 
> __folio_migrate_mapping() does not move it when such a folio is
> migrated to another node, so the source node keeps the count forever
> and the destination node underflows once the folio is freed.  btree
> folios are migratable through btree_migrate_folio(), so demotion,
> DAMON-based migration (DAMOS_MIGRATE_{HOT,COLD}) or memory offlining
> all hit this.
> 
> Reproducer, on a QEMU guest with two memory tiers (node0 is DRAM with
> all CPUs, node1 is a CPU-less slower node described via HMAT) and
> /sys/kernel/mm/numa/demotion_enabled set:
> 
>   1. mount a btrfs and create 20000 empty files, so that btree folios
>      are cached on node0;
>   2. echo 2G > /sys/devices/system/node/node0/reclaim, which demotes
>      them to node1;
>   3. umount and drop caches.
> 
> nr_kernel_file_pages in /sys/devices/system/node/nodeN/vmstat after
> each step:
> 
>                   without this patch     with this patch
>                    node0     node1       node0     node1
>   1. cached         1868         0        1868         0
>   2. demoted        1868         0          36      1832
>   3. dropped        1832         0 (*)       0         0
> 
>   (*) the counter has underflowed to -1832; negative values read as 0.
> 
> The global value in /proc/vmstat is 0 after step 3 in both cases.
> 
> Move it together with the other node-keyed page cache counters.  It is
> a node-only counter, so use the node accessor, matching how it is
> accounted elsewhere.  Interrupts are disabled here, as for the zone
> counters below.
> 
> This was pointed out by Shivank while reviewing the NR_FILE_THPS fix
> for the same function.
> 
> Fixes: e3a9ac4e866e ("mm: add vmstat for kernel_file pages")
> Suggested-by: Shivank Garg <shivankg@amd.com>
> Assisted-by: LLM
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Thanks for fixing this.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

