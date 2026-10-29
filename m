Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29949606A322
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OQBViomQ
Received: by kanga.kvack.org (Postfix)
	id EE82E6B05D2; Thu, 29 Oct 2026 06:46:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E700A6B05D1; Thu, 29 Oct 2026 06:46:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D874B6B05D2; Thu, 29 Oct 2026 06:46:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD1086B05D0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:46:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39AEEA7AF8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:46:06 +0000 (UTC)
X-FDA: 85375333932.21.EBC75FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6439F20006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:46:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OQBViomQ;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWtxWJ8Mj0Rtl84/opbh6HrMgPdbznSuYDREGzIgtS8=;
	b=YOmU+Fmj+UyhQERFbZEcYLbp60KscUy223iuPclQqnYmbE3rrysIAYkBVXRJm/O8iBVXaZ
	VXc/8EKC5Zozw7bA77zp6vOn5e6/n/MCrwCQzBEhAS5DRYD+HRCChZSNi8XPEzS8gLVNHI
	mfMeVt1ERuho7xCCdtRCZ7UZMazzw9w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270764;
	b=oivlvzDfZ9QgThHq7PiPqmZd4Hlg3xHQQHGQuh/jGyaQFKWm9jT7WAOeXl4w7KAe9bOMHD
	GqXJ067frGnw8yZHbFHlRpEOg6boviR7ulZRe/MP+IFu62UQCjUvRCKyJ6ybtjGBHTQSfd
	CbKHCg1xyoe3Q7jkiKvdcCn9lBRdZ8E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OQBViomQ;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9F3E43EBA;
	Thu, 29 Oct 2026 10:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A31C1F01828;
	Thu, 29 Oct 2026 10:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270763;
	bh=RWtxWJ8Mj0Rtl84/opbh6HrMgPdbznSuYDREGzIgtS8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OQBViomQbwp7bZgr67nFX4bXyVvdihnfsX4qqLIJhw5cov8NwRlowbCfqCeB8B/TG
	 vRZdctp8HDzZf5+MMfLQfGaLx8sLKTz+QD97JA9f/3ve2QDgYhC0hLH6dMJLQPhAiB
	 mpAIGWRyRX/AroWWwl7GdtzWL5pw2DZ1FbKhQM1DCalokfCGrAWcRTTp67JDSuhVxS
	 AQ4zKkwFJ5SSSBy1TDC7mw2jzppsjjBq202u+cwgkOE+I4z0mm1dat/+NS26OofQzA
	 iIFxxdkBxEBRu6djTiz9092I9boXtgjVKklvBdRnPHpOicl4m8X4/d0eOZ3LVk21Ob
	 sxvnPpw0oYzGA==
Message-ID: <acfd9678-fa48-4610-ba90-278cab92ee9c@kernel.org>
Date: Thu, 29 Oct 2026 11:45:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlbfs: emit hugetlbfs_free_inode from
 ->destroy_inode()
To: Joas Antonio dos Santos <joasantonio108@gmail.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Hongbo Li <lihongbo22@huawei.com>,
 syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <179324176522.32673.7602596908234555806@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179324176522.32673.7602596908234555806@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6439F20006
X-Stat-Signature: oh1y1n63irt9aoqthdg8g7tywiomf6nh
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793270764-222768
X-HE-Meta: U2FsdGVkX19X7BBtHGmwM8JODb7eHQZ4awWpICBpjDrU1Yi7zwynRhJSVHVZmS7We516IaAxbb4a4SZWW0s+t7fVs06xfV1XbQxiv2wEUl0RlSfphVejtZddgimMmZ+Ftt551zJFBSpsYfwAO3p3UFPORuG4045lHlUuLWmipyCnxBNU/FKXY0qRnpJEgtgadp3rX4lxrltLvDD6VC/y/hXtpFSdn+zyaMcPm+sYTsdeNT9evz8dWXLDJ4acs1giegwYOwBek3B2w2sICnn7m4pkHjP6Yx9Q/JrmXxu0B6lQ5srz8Q0urD7/jkFz8ZU+A6pywXSSugV5HljhxN1w1HBzKOldeBrFM80ev6/5n6UlIHy/5JxAygBUPhkj2Xt0aulzELIEkSkTTdm6SaqPOZjFDpIiT5XbqKOfqyF/W+NsGR/0VMYxc7bCdRcJ1tnS0/7hQC1k5PXGZm92sZHWRrYCXUxEgIdLFG+wQw2H6t5QZmxLZl1B+8JAEaqlVmH6W2MY/BCTI8MuitXS5E+HnXOfdV31sj8EA5da2jyu0YcRHlqVUyf2+06ivnCR4/wFCGhNWguMOYYc6QeCildVlRxhWdVWW2cE3Ub7kMIqr6CFH0BbDejJ4wiFmiSbnQyRD7ZLWle1r4vakW+I98y46yPyVRs6B9nq3gxZ/LYSEBRBuqAsRkdZZfL5AQqkgJK2IDQDOgT4qClKAXok092VLrFh+7uqrOS8v6U+HSq0/nW+84cskvdJVqw2w8OxjWEzCkjMmwXKycfVutdWl3pwGX6qbxRZgEq62DEUKmeasnf2t5JDT3YbnYPfqiJsJg7QvqzzFPztvNDde5UpGPze4RXYV9eGhRl+SK8Z3E0AmbODvIPr8jfhXJc9rSldcJb09Cimy1fjBarkTp8xR3E52q9/HDRCyU/VdPYopF7Q8+gWNwZ/AoLF0QTjfTUCYVATfQrv1GwgFp15mKPiFnt
 WQ4iYDBV
 tmrY/zIE7xHZkQpy8DtHxScBFSix/LQuCfOS/5Lp9vHpxnDVMn2pl45q29enxAA9wq0wclCuqHsCP2Qrh/n5nXMU8b7wAbC3K48GNl2DBmH3Eh+q2PYB3ldBa5c7VtlK5uxOa8RiGLspR1ltIiQSgYACIYu9au5rC9IgaIIl4Gv/MZB6G9G1q+uQZfUlh0/AhtcLUyREjN9SXMpBKg6R6n4qrP3gy4zfGw56tgSi8QWtoMDySQkZjq80dOKBHJnLIBi07FfW0M+2t8zLRc7TNpiSOWgd8FlEklxYMmpxXBRQUfKua70mfYnthiooANtd1R233FF3oLoezXNxCKEWNAmKslgaXjvMk5LhLsNkoTksbK0l40KccDIwt0xoTq60juzyc0snqsnpxpnnNRTN4+JBRV/2UP/pHAdViBYcMeBHv0MsEw3zBlOik/9hSZNkgtTUEwr0lJjz/Ck/DFWGbhwdUpzwAzLAuCtQOrOSwBH0b+skAEyutsA5U3nvYNIp8ZaXqZ/r9rarhm6jX/rol+OALutIZ+ic2jdQOKkP/eXbCNc94dKFCkwwUSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 03:42, Joas Antonio dos Santos wrote:
> hugetlbfs_free_inode() calls trace_hugetlbfs_free_inode(), and the
> hugetlbfs__inode event class records inode->i_sb->s_dev.  ->free_inode()
> runs from an RCU callback (destroy_inode() queues i_callback() with
> call_rcu()), and Documentation/filesystems/porting.rst says that this
> callback "is *NOT* ordered wrt superblock destruction; as the matter of
> fact, the superblock and all associated structures might be already
> gone".  put_super() frees the superblock with call_rcu() followed by a
> workqueue item (destroy_super_rcu() -> destroy_super_work()).  syzbot
> hit this with the event enabled:
> 
>   BUG: KASAN: slab-use-after-free in trace_event_raw_event_hugetlbfs__inode+0x45b/0x4c0 include/trace/events/hugetlbfs.h:36
>   Read of size 4 at addr ffff888038850010 by task syz-executor952/6134
>    hugetlbfs_free_inode+0x15e/0x1f0 fs/hugetlbfs/inode.c:1182
>    i_callback+0x46/0x80 fs/inode.c:317
>    rcu_do_batch kernel/rcu/tree.c:2650 [inline]
>    rcu_core+0x5f0/0x1220 kernel/rcu/tree.c:2919
>   Allocated by task 6134:
>    alloc_super fs/super.c:326 [inline]
>    sget_fc+0x1ba/0x1f60 fs/super.c:874
>    hugetlbfs_get_tree+0x1e7/0x2b0 fs/hugetlbfs/inode.c:1431
>   Freed by task 855:
>    kfree+0x22b/0x6d0 mm/slub.c:6923
>    process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495
> 
> Emit the event from hugetlbfs_destroy_inode() instead.  destroy_inode()
> calls ->destroy_inode() synchronously, before it queues the RCU
> callback, while the superblock is still alive; hugetlbfs_destroy_inode()
> already dereferences inode->i_sb there.  ->free_inode() is left with
> only the kmem_cache_free().
> 
> Fixes: 014ad7c42a69 ("hugetlbfs: use tracepoints in hugetlbfs functions.")
> Reported-by: syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6ae27525.5451848c.f7707.0001.GAE@google.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
> Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
> ---
> Tested on net/main 94cea342e891 (arm64, QEMU, generic KASAN, tracing
> enabled) with the syzbot C reproducer, which enables
> events/hugetlbfs/hugetlbfs_free_inode and races hugetlbfs mounts and
> lazy unmounts with open + unlink.  Without this patch KASAN reports the
> slab-use-after-free in trace_event_raw_event_hugetlbfs__inode() from
> hugetlbfs_free_inode() <- i_callback() during the first 10 second run,
> on 3 of 3 boots.  With it, 12 runs over 2 boots are clean, and the trace
> buffer still holds the hugetlbfs_free_inode events (about 46k per boot)
> with valid dev numbers.  fs/hugetlbfs/inode.o builds cleanly with W=1.
> 
> The event now fires when the inode is destroyed instead of when its
> memory goes back to the slab cache, one RCU grace period earlier; the
> recorded fields are the same.
> 
>  fs/hugetlbfs/inode.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 6656807..27a3937 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -1179,12 +1179,16 @@ static struct inode *hugetlbfs_alloc_inode(struct super_block *sb)
>  
>  static void hugetlbfs_free_inode(struct inode *inode)
>  {
> -	trace_hugetlbfs_free_inode(inode);
>  	kmem_cache_free(hugetlbfs_inode_cachep, HUGETLBFS_I(inode));
>  }
>  
>  static void hugetlbfs_destroy_inode(struct inode *inode)
>  {
> +	/*
> +	 * Not in ->free_inode(): that runs from an RCU callback, when the
> +	 * superblock the event reads may already be freed.
> +	 */
> +	trace_hugetlbfs_free_inode(inode);
>  	hugetlbfs_inc_free_inodes(HUGETLBFS_SB(inode->i_sb));
>  }
>  

Should we rename the tracepoint then?

-- 
Cheers,

David

