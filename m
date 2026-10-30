Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D0A606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 01:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XCq4Acgu
Received: by kanga.kvack.org (Postfix)
	id 5BB6F6B05B2; Thu, 29 Oct 2026 21:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547EE6B05B3; Thu, 29 Oct 2026 21:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D136B05B4; Thu, 29 Oct 2026 21:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3226B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:03:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 176581C36A1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:03:30 +0000 (UTC)
X-FDA: 85377494580.20.11B1C1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 35766180005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:03:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XCq4Acgu;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793322208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iLjjIJoENlE5NAFUdiFmod8tblyrc0j45UpKCHBEwzg=;
	b=5n86k3aiEa2zWmEkfkTkCdZ5M4lgyh99RuJcytgR1wdms8RCqCa9SG/Ndyz920oY+C/c21
	wCT2xwQubpLFtC9GVQ2H08OR68JqGyrzyTBxJr6nSYWZbxy07z45Kip4g3yGJJyW3CxX8K
	AaE/IXOEbXxYQOAtIzskXPylN8teJMI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XCq4Acgu;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793322208;
	b=H7sVnLi6N/f5JbBd+BhSm/DSwTbXYbijdHX87bS9vFdNaLTOjeNBo9GBkpSULFSGTMYaFn
	tG/dyd/BnY2GCuSGFfIww49KPaMKeOvRvn9PbRcc5pBpDppdTEzPbimE/jntIPntb/tO65
	niI81Xm+rPQSdakpCdTlikRRBBt5dRg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BF5E43C24;
	Fri, 30 Oct 2026 01:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11E41F000C1;
	Fri, 30 Oct 2026 01:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793322207;
	bh=iLjjIJoENlE5NAFUdiFmod8tblyrc0j45UpKCHBEwzg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XCq4AcguHeTD9dQitt4/EBRovli7cQL1uJTwLuRvZE1p+o809ocaZ1bZmPb/kNEwn
	 otpAwCQ5AWfGVSWI/cmYJNW5EgmwSZSCW5TI9U5cjA9mBfK47eGK9CfARrgwqQoGDA
	 IgbBkX2LLa9w8zBTzG/fpmaHPFcDgsR6rNWLRrbA=
Date: Thu, 29 Oct 2026 18:03:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew
 Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying
 Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Boris Burkov <boris@bur.io>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Shivank Garg
 <shivankg@amd.com>, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH mm-new] mm/migrate: move NR_KERNEL_FILE_PAGES on
 cross-node migration
Message-Id: <20261029180326.84ae7b2c1f63f016c66bd28e@linux-foundation.org>
In-Reply-To: <20261027043214.2248986-1-ridong.chen@linux.dev>
References: <20261027043214.2248986-1-ridong.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 35766180005
X-Stat-Signature: qak18gybc5jsf3bkhmdyfair1mmcjypk
X-Rspam-User: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793322208-294544
X-HE-Meta: U2FsdGVkX18g470JUbWzt82aetDjK689I8nMqDTNFBjEWJFw6ovZ9j8+bChXLnRcNNIX/OJwZSQTnaAwiAj838R/Xe+watC0STMKOfaU01nCLhNxEIhS3gdEt0WlJXXjP43yyC5nW8hyRwVmN1YbBVO4FjUEUChpc/j+BhgxrY/HexUKNSNteakQv5QAtZy/Uwjahru+TUae8ds10kDUov6sWkA+UtYzdjoqVtJfmRIfjlH488hpUq5hSMZebGzBtrrCHDj8THpuWD9tpPzpBadG9EK9Gi3WsJBwH9aNUcDPAusjkM3H7z5owlnnOyCO9GPabzzLpAQix6ppftnzH2X1tiu87koJn0HJqaV3J/TUR9FIrWZjtyozpNrBHzyJoHv/sxYYI5wMC7ECptXyTC2nNvt+MtvuTdzVmykAxJavOqcAP+gthdTxtw8IIugsmc+7DWiV1hWgoUJWgq0fEzAGJjPq5CKxjpOTsJiLRmCXC1UBz/PEEgEJIJbAu12dmx1I3BdCKPBF0Ou9ZlXkQo7o9EgoFXNzJGrA0E3WuxAHsD+ePmx7SXLQhFAN2ayVAOatK1Op+ff+2e7K1P2z4WR6/HIF0hfcv28mCeCPFg2gPIBdszU6N6DI6R1SJzH12G42+Z+88dYWna3ZwLEW0menLoXQ/9Bcs2RbPshGocvHUoVU2KNpu/mRCtzU8QFj3h14tELTrOvGA9NrRrfmMQLBDts688Shxt5+614p1L8HewG6PMyyAN2sne5wd94ZcamQk9lUfkDDFowtF8M886R3ReAsf4olLQI3A4EVQrl7vtYOuv07mwkotmWbu2d5YooznvV6gDbHXx+zcaoU9da7y6lS84MzivJWdwkllsWDVkYEPVhhSvh2kVj/hS0lGzONRNV94Tdq/DtxPSHr9nnQDcHGwOUE7n9pPbjndemoR1xxXuvD5wO3nU7aH3MTb0Ng7/0oPrauNDjUxZu
 fUn/fkaX
 qruJAgb7NhIuLsRSwDL8VHYZv3iV8AiRcJYypSJ8ZxUtYum6pjoTiklo3fxg7IBdWVXKzefOgOu9oFKayjnbDL7KdGwFxAFd11yFfbD1zc1K3VZxgPQkPoTrZy1/yZBYqoGbzKipgObFmm3tEHpyO6Rhzg8lKGst4yT4r0lLh0h9+XzkdMs4dNIqdOHzz8PmlqihvsB6p4CdNS1RpC3IlwBazgyGZYZH0nonCbh/SsKqzCsfCCSXyFuymdifMe89DvmkxIlnRcd5/JAVRvPrG2L6SOPPpjUXs4G1nRnOMTTff7RtaUleuHIV4huSFD902FwjJnXO6aWSESzR2QeyroEX9eko6+YZOtF2F6+ocreie8G22f2G6KuBtY3BnsYMblbrvrXE5ObTjPa0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 12:32:14 +0800 Ridong Chen <ridong.chen@linux.dev> wrote:

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

Thanks.

This and your "mm/migrate: move NR_FILE_THPS on cross-node migration"
"only" address accounting errors, but a bug is a bug and these bugs
might mess up people's memory-monitoring and NUMA-management tools.  So
I think cc:stable.

What do people think?

