Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B0BCCD37AC
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 03:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4571B6B0005; Thu, 14 May 2026 23:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4084C6B0088; Thu, 14 May 2026 23:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7056B008A; Thu, 14 May 2026 23:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0C06B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 23:04:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B06E1140694
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:04:10 +0000 (UTC)
X-FDA: 84768160260.02.84B9FA3
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4914D2000F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:04:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zrNDrXNs;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778814248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1kImyxqEbaAy8kSJvIICJ2cSXsdXwlWP4COYny/KSg=;
	b=liJkadmiYYsACtnRMPCFmP73eU65uebyqe9L6TH1w/17Jji9HQowGYpYG0KAXEEQPc0tw2
	AtltXWL24mDZtlcPtGTd2n96XZaBhQ18FrAhrjh52GsICYFV3CSkVEiA8a80YTpk545wAE
	j1BVj+RPudY1I4tkoGHtzft+QYF9Lvc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zrNDrXNs;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778814248; a=rsa-sha256;
	cv=none;
	b=mzMwCZrhyNHxbz6M9LcuvqKSXPg9fK6aOVnXR8iObevwXOiH9R3Gukgr7EQ59AoHHPfY3f
	I7hO4RIK10hEIMAxlszIoh6L0oPvB7llhfKMEWcOf/rV1YisO65ccgWf9x5hLDjGTCdC1g
	ZSc/64g+qoRiOAwA3JZRVgtPqU0Hp0k=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=c1kImyxqEbaAy8kSJvIICJ2cSXsdXwlWP4COYny/KSg=;
	b=zrNDrXNsSOpvDcQyNoICT4sJcco3E5Wsi/O9iHpDKfEX9XEWUf/G4XkITj7GNXEmCI/idJPfP
	P4UGl/4Oun+rHqHdIN28evtQ5auEfY+bkcrQEAnCVTqBcNINbAhTUGsW0k0T2fek/MYR3cF4Ai1
	3WMtGlCqyQAslPSg+eDFPV4=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gGsL46BLFznTZY;
	Fri, 15 May 2026 10:57:00 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id A0C4240539;
	Fri, 15 May 2026 11:04:02 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 May 2026 11:04:02 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 May 2026 11:04:01 +0800
Subject: Re: [PATCH v7 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <kernel-team@meta.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>
References: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
 <20260513-ecc_panic-v7-2-be2e578e61da@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <5cbb6038-72e3-9eda-7d1a-464f879fabb9@huawei.com>
Date: Fri, 15 May 2026 11:04:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260513-ecc_panic-v7-2-be2e578e61da@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4914D2000F
X-Stat-Signature: edrts6rtca8qryce3y48q74asypfzugm
X-HE-Tag: 1778814246-80501
X-HE-Meta: U2FsdGVkX18EQFn977RbPH1STGgkVuESssB2z2RbABRmQ9AldOSu9R4mH2pdaQjkslm23ZRdkz+wDnmJx/1rPjaWuWfUgKVZkSAI559BeQnfgmiz62cxmVYkQ264uwraYGGyWD3bFa+OqR9vsgj3+HnVexMij30w3hu5ShKqqs0u8ymM3YJlzWMnKtXL3w5JgUcFlQIpN094uNc7H7VZZqWRyzagDeYRunjHKtamukADqIT9WybcC05Nh/P+bVnJT8Rd0WIJkQNFu26WBLMYUE5DoHwq4EOj/78LR1fvtpMVU5G8Ei5/4+q0iqE2XNymL0VBCRefOsm45aj1QUOBKxpMaDLS6002yERs4BLa+PAKGWqeStulrA+I7QdMEWLlYbVKjxukafrjoZMgVFd/DznJyjSefmJLqxweNoSDN9ThjFlOdZjg/NBFqW3yDs/nvXaXp+pvvgZBO8Cnl3v8oh7TsUwRml/2pn/JVBLPoJhmywaBFwcrX/ZF9YeK4/2swO0gazoGrrr5QPVIZsJ/9J7xenadcD9tZ82yBg2k04yBI7NIter+PlD6sLVRqTGFionkyBH6QjLXowls+G+wj7iE+yOcPe8g/tqbiaJiPWQ91uuuLLIhBu3DSDe5lmrA6DxCfnwv5rS8vs1Bc8glEFesHYc264g/iSsfEnp+1ZWyb3vJQBztryTjzFdKbyltPhh8ejEDQjssVlBIOv8YGCKUn3ByModUVful6qnc3in5miHbsi3OjmtgGGemauUjZ3jlLiXVtmDcyEy4ooNWwBxWoftI+bIGIX+4syWlgrURZ4sRtTNY+hhJ2i4YN+WqW0Dn524YLPmUjOxkcQLbH+eLpKr91uLUf5q3c9ISqX0OGkhgtTXuW/R7eZjXh5y09g2Peg0k9tx8zIwS//w10fHwMaCpNNLmQx1IG5h4dDl/RmbN8rWy6XHIZpcLCzWIoDhkaWUQmfbEwUBWTPJ
 u81ynb6y
 KGj8Ntfri/zRIzPBft/5H7o33KPTqF6MZ5qlSsC5vpT01gOz1SUUKoB+Ilkj3N6D82yLcBRUv1VOWJFTUgOd1c/Ez7otjmExvYl2LLxvW8TLWZl3XSr2s8m7tw6q+OMTsFrIIJ2xUiTiEXUQP3t1AIm0FJBZXKN2V87cjDazG7MOx5RXK68tIiaHKNugF8+OOvep89Eq8qn4x1bostJvwnhw+A2AaSEFKeOLhS6/JahfGrbwT5mSmn1E8HGwufS2x2jV4RiDpQvqpTcXYjd0i5aPLdl3r/OTss0ThUHZ0fwKO53pdyzGYSVtYZ+A88cpla477Cix8+ImajV4RSDW7+4ypmdV7TrnFIsRRffhqFhMKYlDxb6o4EWyVxhIfoCJGy6gBJPkyaVXIIl2ApsCgGwmzFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/13 23:39, Breno Leitao wrote:
> get_any_page() collapses three different failure modes into a single
> -EIO return:
> 
>   * the put_page race in the !count_increased path;
>   * the HWPoisonHandlable() rejection that bounces out of
>     __get_hwpoison_page() with -EBUSY and exhausts shake_page() retries;
>   * the HWPoisonHandlable() rejection that goes through the
>     count_increased / put_page / shake_page retry loop.
> 
> The first is transient (the page is racing with the allocator).  The
> second can be either transient (a userspace folio briefly off LRU
> during migration/compaction) or stable (slab/vmalloc/page-table/
> kernel-stack pages).  The third describes a stable kernel-owned page
> that the count_increased=true caller already held a reference on.
> 
> Distinguish them on the return path: keep -EIO for both the put_page
> race and the -EBUSY-after-retries branch (shake_page() cannot drag a
> folio back from active migration, so we cannot prove the page is
> permanently kernel-owned from there), keep -EBUSY for the allocation
> race (unchanged), and return -ENOTRECOVERABLE only from the
> count_increased-true HWPoisonHandlable() rejection that exhausts its
> retries -- the caller's reference is structural evidence that the
> page is owned by the kernel.
> 
> Extend the unhandlable-page pr_err() to fire for either errno and
> update the get_hwpoison_page() kerneldoc.
> 
> memory_failure() still folds every negative return into
> MF_MSG_GET_HWPOISON via its existing "else if (res < 0)" branch, so
> this patch is a no-op for users of memory_failure() and only changes
> the errno that soft_offline_page() can propagate to its callers.  A
> follow-up wires the new return code through memory_failure() and
> reports MF_MSG_KERNEL for the unrecoverable cases.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory-failure.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 49bcfbd04d213..bae883df3ccb2 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1408,6 +1408,15 @@ static int get_any_page(struct page *p, unsigned long flags)
>  				shake_page(p);
>  				goto try_again;
>  			}
> +			/*
> +			 * Return -EIO rather than -ENOTRECOVERABLE: this
> +			 * branch is also reached for pages that are merely
> +			 * off-LRU transiently (e.g. a folio in the middle
> +			 * of migration or compaction), which shake_page()
> +			 * cannot drag back.  The caller cannot prove the
> +			 * page is permanently kernel-owned from here, so
> +			 * keep it on the recoverable errno.
> +			 */
>  			ret = -EIO;
>  			goto out;
>  		}
> @@ -1427,10 +1436,10 @@ static int get_any_page(struct page *p, unsigned long flags)
>  			goto try_again;
>  		}
>  		put_page(p);
> -		ret = -EIO;
> +		ret = -ENOTRECOVERABLE;

Theoretically, pages that are merely off-LRU transiently as you commented above could
reach here too? Or am I miss something?

Thanks.
.

>  	}
>  out:
> -	if (ret == -EIO)
> +	if (ret == -EIO || ret == -ENOTRECOVERABLE)
>  		pr_err("%#lx: unhandlable page.\n", page_to_pfn(p));
>  
>  	return ret;
> @@ -1487,7 +1496,10 @@ static int __get_unpoison_page(struct page *page)
>   *         -EIO for pages on which we can not handle memory errors,
>   *         -EBUSY when get_hwpoison_page() has raced with page lifecycle
>   *         operations like allocation and free,
> - *         -EHWPOISON when the page is hwpoisoned and taken off from buddy.
> + *         -EHWPOISON when the page is hwpoisoned and taken off from buddy,
> + *         -ENOTRECOVERABLE for stable kernel-owned pages the handler
> + *         cannot recover (PG_reserved, slab, vmalloc, page tables,
> + *         kernel stacks, and similar non-LRU/non-buddy pages).
>   */
>  static int get_hwpoison_page(struct page *p, unsigned long flags)
>  {
> 


