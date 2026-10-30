Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 926F8606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 02:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=e/raf/wY
Received: by kanga.kvack.org (Postfix)
	id 82ACD6B05B2; Thu, 29 Oct 2026 22:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8037F6B05B3; Thu, 29 Oct 2026 22:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7405D6B05B4; Thu, 29 Oct 2026 22:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 540436B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:02:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E02D8A8162
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:02:41 +0000 (UTC)
X-FDA: 85377643722.01.C4BCFB1
Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	by imf21.hostedemail.com (Postfix) with ESMTP id B49051C000D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:02:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="e/raf/wY";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.119 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793325760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvgzEb2UEt0lDkhOWoviEIQi70A0ynQFKu+41cMZqRI=;
	b=DH20NqH3XDQJvoVjtV/n12pk1N+H2imBIJntssD648rTnBT+8kUk0ZwYrKSMeUrl1U5SR6
	G32oVoe8S5OUmllnR/vLcBJE9dPNMe3Zcr3luaIj2Ljc/IxKSM1zYUB9teHm0n3bzOXIoL
	qgXnFtPSsX8ESJYFS0Wynkc6zu4+L9Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="e/raf/wY";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.119 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793325760;
	b=rp4pDADVMtq9ZhMccs9sxV3Vl7aorCDWcCW1EQOFnXk79aUKy0q0VC4HnZ1BgxuXiuxhPx
	cgokFFy7QLeNtS45SOEjG2bmkxxvcouKTJQ4ArCCaBeg6u9rYoD5Bl0rzS0NC1dlFVbEBo
	oZVJYN2zH12j6eXJBYWgEad5UgM+vjg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PiJyayPM7vNnZ3shaWarAAoNfXv1NQQo8Z036gp8oXY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793325757; v=1; x=1793930557;
 b=e/raf/wYx+rPGSeQcvsrcHQ7+PkBnUZFvmo7noB9g27irMErcBBYqoO9GjeV7RwG/rj9zNaq
 AesCK9qXnEyaco5DJ/ntUWjM0d0BQKVUBDAhD3n+xk4Yz9GkMRoIOu2cT0EGOjUefLV0ZRPRTZA
 spOb4mIHn6xipogGm1zUk/t4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 387f32f4a38555bf;
	Fri, 30 Oct 2026 02:02:37 +0000
X-Mizu-Trace-ID: 387f32f4a38555bf
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 19:02:35 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ridong Chen <ridong.chen@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Boris Burkov <boris@bur.io>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Shivank Garg <shivankg@amd.com>, 
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH mm-new] mm/migrate: move NR_KERNEL_FILE_PAGES on
 cross-node migration
Message-ID: <auP6rl655zYaJkIi@linux.dev>
References: <20261027043214.2248986-1-ridong.chen@linux.dev>
 <20261029180326.84ae7b2c1f63f016c66bd28e@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029180326.84ae7b2c1f63f016c66bd28e@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B49051C000D
X-Stat-Signature: eth1eggfkqwrs6sd8d1u8k5itrwxxoc9
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793325759-787919
X-HE-Meta: U2FsdGVkX19ZYULd1byP0+Qk2hSasrFZIaGY/qRmlmEpFu9ZrY4ww7bZF+ObYZrWdZ0KTVejzLFlQifTIn7sl5XEonwu6WN6Z4+q+8iGizgNiI20HmCEvGWwF+uGLFFJHGB4Z4ji8+kSZs+Z917v4T4fOInEBE7VZF7kvQGqshXjs7Pj6rRZaTvjXFwrMG3eBwMGcKg43aAFlBJcYSILTnEOJp/WY62mSNnz7qd+zpmmqR7MZYVIxW/8Rt9eNN+ruQnhSbB48/8bDSXi9rlxppUB6bGTtwSASv06r/7+/E7aQ5Lp9sFqunaqp0udfjJl0mwlUJIq+p25l8EiT2buz1EI5BphuEbASoxbJ27jeJ32yBMtfmwxkjstr2rKVWXEBmZbYS9p5ClZPyqPrYjl3sDcY+sd86kbRTdNJ9kYrlzvEjrKZ05CszevMK51CQUtvq/IL9GPpg2YrEb1ZPBTAlika0t8tkWdaLV8ZibpXu/TrDK5I0JW2ZjQsLPV0IgEH5IKLlXiKzGV6nGfdkGWMeOJHThzFUQkzLvG3Ofxi9mlQN5iQJceKUNxB0ZiffBR6THnlyTMZU1/xUKLZA3uMYxvP7LZSSuiAG4vUhieuTIxyxTf0gP/3i9YXbyALDg3zO8Y7ETPz6gVjgDuYmf6cSIhHC7bF8qhkSFI6ZWHtmDayM06h9uUK43TZoCzIuVQn487p3u2+jQdmF6jGdqVBE7pUv9/EHfu/yx+jeFNrAr+DlR+SgeiXX7AKAe+lBM1Mf+vTqVdW96cmmIAke2GNgFCKaP87nh7Fzxu/R6ZtTdlEmO8KXtn1CVP2eyvFF3shP2XZ8E//190bkcENnkGgmVl60IGEW/tF6h1IrhOup1IGXmYUZQpqo5fyulbkwy52JW1rwx7ekV83gntwjS7/t+lg258OvngJF0OEMMJhx4wrhGDfBz6y7K2wpBZo3BFy0UpLatmKzKVRjIOe8T
 MAZaI+vR
 2Hg0fNd+OiXnlmKDHd29ce/idLR7b/4ps9cwdDeVbVQ975e1tTn75W1/W0SIMXAdyTZHRBZNca1Ltc3DJN/BfIdPgq4FB5GBrQE1F8vvncYHDeQ9w6q9hq19p7DtMzwrBSthll6WqGhg2JIGbKRAkC2g58k+VEc0OqtbzD/qRiQorMsoYnosNSAhdRfu3SZXTGkOk4BCprTfOEdP+5QrYd7NfQQ1eOQeE0A79QRhEnQen1qF07K4Itx1oZ8iubay/cSbMrd132GptUdQU4+JrtHp7qlcumsbqyj88zwwG0kfSEPRi4wNRwQxsLj1/Zfarvdk1v4srXrwjc4sViuExjITou9XZLJnZ+u522c4ePbhWTaTohNdHbtd3ke0HcZYkuydCyIO5y8XL4WP8S3azpOmC6VeME0GqD7PJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 06:03:26PM -0700, Andrew Morton wrote:
> On Tue, 27 Oct 2026 12:32:14 +0800 Ridong Chen <ridong.chen@linux.dev> wrote:
> 
> > From: Ridong Chen <chenridong@xiaomi.com>
> > 
> > NR_KERNEL_FILE_PAGES counts page cache folios of mappings flagged
> > AS_KERNEL_FILE (currently the btrfs btree inode).  It is a per-node
> > counter: filemap_add_folio() adds to folio_pgdat() of the new folio and
> > filemap_unaccount_folio() subtracts from folio_pgdat() of the folio
> > being removed.
> > 
> > __folio_migrate_mapping() does not move it when such a folio is
> > migrated to another node, so the source node keeps the count forever
> > and the destination node underflows once the folio is freed.  btree
> > folios are migratable through btree_migrate_folio(), so demotion,
> > DAMON-based migration (DAMOS_MIGRATE_{HOT,COLD}) or memory offlining
> > all hit this.
> > 
> > Reproducer, on a QEMU guest with two memory tiers (node0 is DRAM with
> > all CPUs, node1 is a CPU-less slower node described via HMAT) and
> > /sys/kernel/mm/numa/demotion_enabled set:
> > 
> >   1. mount a btrfs and create 20000 empty files, so that btree folios
> >      are cached on node0;
> >   2. echo 2G > /sys/devices/system/node/node0/reclaim, which demotes
> >      them to node1;
> >   3. umount and drop caches.
> > 
> > nr_kernel_file_pages in /sys/devices/system/node/nodeN/vmstat after
> > each step:
> > 
> >                   without this patch     with this patch
> >                    node0     node1       node0     node1
> >   1. cached         1868         0        1868         0
> >   2. demoted        1868         0          36      1832
> >   3. dropped        1832         0 (*)       0         0
> > 
> >   (*) the counter has underflowed to -1832; negative values read as 0.
> > 
> > The global value in /proc/vmstat is 0 after step 3 in both cases.
> > 
> > Move it together with the other node-keyed page cache counters.  It is
> > a node-only counter, so use the node accessor, matching how it is
> > accounted elsewhere.  Interrupts are disabled here, as for the zone
> > counters below.
> > 
> > This was pointed out by Shivank while reviewing the NR_FILE_THPS fix
> > for the same function.
> > 
> 
> Thanks.
> 
> This and your "mm/migrate: move NR_FILE_THPS on cross-node migration"
> "only" address accounting errors, but a bug is a bug and these bugs
> might mess up people's memory-monitoring and NUMA-management tools.  So
> I think cc:stable.
> 
> What do people think?

Yes this is stable material.

