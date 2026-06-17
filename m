Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84A24CD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 02:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680C56B00A4; Tue, 16 Jun 2026 22:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631C46B00A6; Tue, 16 Jun 2026 22:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520C36B00A7; Tue, 16 Jun 2026 22:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E03F6B00A4
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:01:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63D4F1C4069
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:01:09 +0000 (UTC)
X-FDA: 84887751858.24.234A7BA
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf06.hostedemail.com (Postfix) with ESMTP id E9AE6180006
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:01:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=51qWupXg;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781661667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PEGy/0Yc6RbsNR1CzoCHl4JOysn72pcydBscXTJDoAQ=;
	b=7QquvTjLw1QJfqvvvaPqAnSBEGq/9+LVhSCsDVeYqcpPKRiLTF7mTOWs5OknhA3HhkWwnd
	QYqVjE/OUH2ZGkLFLk9c2vbUGU7rSeORFdFfCak21KilcZsYXTFlKrpi2WPdRole63ey1i
	cfHIR21x96VHz4SzVBxt1Bgu/F+6Ii0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=51qWupXg;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781661667;
	b=DfEpASSEU8fWu5L7Q9aDi9qkpCHlFUFbi18KkfLoPr+hq1XiACDm4z5pNS4KNE+p0sATlX
	/YcPp2173uFuKI39xtsTW/D18eA1KrXKZEfhtmuEqZP5JGID/ZEaB2taeFDHQrF5SYlzM2
	RlGTdAN9dzBSTrNy/u96iIA3mgIGMz8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PEGy/0Yc6RbsNR1CzoCHl4JOysn72pcydBscXTJDoAQ=;
	b=51qWupXghRRLKpqModGwC5GnkF8kkTXCULtk3m9It+i4OCKHMIewFucRgdC5g8QFFlzVLTJtu
	JiaSZYnzi+im7StBV2h2xUCSrA97KbJzrlAOGZPhU9X18HvDsDFLEf32okPeJk3c2yU3cVHOjPZ
	Wxo3w+5IJ7BkFjJe46yNpNk=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gg6M35ckQzLlSc;
	Wed, 17 Jun 2026 09:53:03 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id B775C405D0;
	Wed, 17 Jun 2026 10:01:01 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 17 Jun
 2026 10:01:00 +0800
Message-ID: <8a4caadc-f414-4874-97d4-2fbaebe2af39@huawei.com>
Date: Wed, 17 Jun 2026 10:00:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: khugepaged: free xarray nodes left behind by failed
 collapse_file()
To: Matthew Wilcox <willy@infradead.org>, Rik van Riel <riel@surriel.com>,
	<ziy@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Hugh Dickins <hughd@kernel.org>, Zi Yan
	<ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R.
 Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>
References: <20260616145413.1491961-1-riel@surriel.com>
 <ajFrxhGf7loEHUeX@casper.infradead.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <ajFrxhGf7loEHUeX@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E9AE6180006
X-Stat-Signature: yjkicywzwwybyi1hekodkq8o9udx7c9i
X-Rspam-User: 
X-HE-Tag: 1781661665-782185
X-HE-Meta: U2FsdGVkX1+nUXLkGQwPVTjW4c6F2H+emsW9SmPwZb2ETegvcXeqacDcF0B31Xxtk+9g4Mqjnhw+KFpkYkjNBzY03KSgucOiUZXRg4czKFqx42YPtInzVSBhmTiuTyRbHyD8f6M+BUv9GmgfI8njY2kMFIq4FoMGgcBnkqhzRfLZVC/da5tlNTWm+bcy2JY9TAbX2AlLZCqS3AxfHl9DCWrTF3sQXoURA7lgLZs1Odx5qDw9gHAwoFch5PsEgy3etoZDGGcq8vBg+upH1fLElfS5nf5Ieng+xd6ldVTGiPgGviKy0q0IQR4isQQJOVoenLxhovYTGW9ThmBsxBf+RIJWNZNPkCyx5JA6TeTCmU8pd6D6o75+rZgYNmxyIowNAhhq+rtbW1wyw6t7xzsRimVYcK1+RqK/ngO3BTY/7qH+x/8k1IQ40Y5svrhOoaQhvqmDHw1NOH95+Th/dizMCIBJyU9ZGLGC1FsyWEQNmeLmQfJWM2zJsvQsBoMlfDJjjqPw9spBOiC6+xHPNYvkUnv2i4DgLKnql2FvNvEt2mf8AVKsdnUynruGs3FUiMYcRKPt0GPB3eJnXl3K439fOD+2Fr5b+0ftNnXammuiB47ToWS2GyQ6ENk8WpKxuL4+6W7ZDANo6JzrdTSfpUWgtsRM/wWsaEiwUJ+ow8YmbT1lSMffbw7QNgVxRdzu8WxjbBIWdKMEIwKUfHHBTQQ4ChPgQUURTX5vjkfeweYzbwQDyeNmj0WwKdQ9OkAZg1qiTbkgj0xRNWTVwUxGCkgAtr0eT+yjxPRuAus0abf6Bfrk0OQ05r5JSCZGZc+GhwOMCCLyy0vLIfMOwTR54kyu0I2ZMncck1SPTDfQ7WgEALfUUPCSU9IWInRI+v1wOiqSVPkIFecAucLlMRmxsElE+1Hsz4SUDc6EZ1siB/dRidSw4kBpOK+KN6YRfdASq31AZociDi73wEp/ZFp1/K1
 l5dibxRs
 TW4WyMKoPUo5RZmQmU1MEGnjRLoZbO8EzAhmvI7UrEhB8ZJf3A0tTx2ZkLn29IeU/rtwowsqcb8G5adnXQoiPCe78QqscSzdabE2AYlCGkD3nmqjoe6wwWsluoRinwiNNOtCmxKHprjaPB/J5e+VIL7zItEt7kiKGycSQ/SB4LiJ2/tko5dGtTanSN/eeTJe0VZU0a0P1NqfW9J0eK+O/IdYu77W8HUOOkdt3uu8PQyYVDMUaglrXrvlwlmIZsuSObNusyBDXwmRKLWJkzQ+ZGU8gFcdepJHyHTX8l2O7+CG1B5C3FHtEImHuua4o/ZrB8KSuzdf3t/2ydZPGhm5/T1357h+gIFCd7uCgnWAjW3Lqsrva4lG3rYyFtofTB6l0/gnCG9K6xKFRZMThHP1TArjkJo1aLZyjFNCNdHsCtAc5Am6CacD9PdGw9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/6/16 23:29, Matthew Wilcox 写道:
> On Tue, Jun 16, 2026 at 10:54:13AM -0400, Rik van Riel wrote:
>> syzkaller reproduces it trivially with MADV_COLLAPSE on a sparse shmem
>> mapping (collapse aborts with SCAN_TRUNCATED because the range is empty),
>> and also via slab fault injection, which forces xas_create_range() down
>> the xas_nomem() path before the same abort.  kmemleak then reports the
>> 576-byte struct xa_node objects allocated in xas_alloc()/xas_nomem().
> I think the ways to produce this problem are sufficiently rare/unlikely

I can reproduce it easily with following steps. [1]
1) create file /tmp/test_madvise_collapse and ftruncate to 4MB size, and
then mmap the file
2) memset for the first 2MB
3) madvise(MADV_COLLAPSE) for the second 2MB
4) unlink the file

This might be the only path easy to trigger; all other failure paths seem to be difficult to trigger.

[1] https://lore.kernel.org/all/20260121062243.1893129-1-tujinjiang@huawei.com/

> to not merit this level of cleanup.  Why don't we defer it to
> clear_inode() instead?
>
> reasons not to:
>
> 1. the page cache is not the only user of xarrays and
> theoretically either of these things could happen elsewhere
>
> 2. can a user do this on purpose to screw other users over?  i don't
> think so, any more than they can dos the system by bringing a lot of
> inodes into memory; we have cgroups and ulimits to protect against that
>
> diff --git a/fs/inode.c b/fs/inode.c
> index 6a3cbc7dcd28..d92c5a296504 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -779,21 +779,20 @@ void clear_inode(struct inode *inode)
>   		fsverity_cleanup_inode(inode);
>   
>   	/*
> -	 * We have to cycle the i_pages lock here because reclaim can be in the
> -	 * process of removing the last page (in __filemap_remove_folio())
> -	 * and we must not free the mapping under it.
> +	 * We have to cycle the i_pages lock here because reclaim
> +	 * can be in the process of removing the last page (in
> +	 * __filemap_remove_folio()) and we must not free the mapping
> +	 * under it.  We also remove nodes which are empty; these
> +	 * can occur in two different ways.  The first is that radix
> +	 * tree expansion can fail partway and the second is that THP
> +	 * collapse_file() can allocate some temporary nodes and not
> +	 * clean them up.
>   	 */
>   	xa_lock_irq(&inode->i_data.i_pages);
>   	BUG_ON(inode->i_data.nrpages);
> -	/*
> -	 * Almost always, mapping_empty(&inode->i_data) here; but there are
> -	 * two known and long-standing ways in which nodes may get left behind
> -	 * (when deep radix-tree node allocation failed partway; or when THP
> -	 * collapse_file() failed). Until those two known cases are cleaned up,
> -	 * or a cleanup function is called here, do not BUG_ON(!mapping_empty),
> -	 * nor even WARN_ON(!mapping_empty).
> -	 */
> +	__xa_destroy(&inode->i_data.i_pages);
>   	xa_unlock_irq(&inode->i_data.i_pages);
> +
>   	BUG_ON(!(inode_state_read_once(inode) & I_FREEING));
>   	BUG_ON(inode_state_read_once(inode) & I_CLEAR);
>   	BUG_ON(!list_empty(&inode->i_wb_list));
> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> index be850174e802..d776a6e9ad18 100644
> --- a/include/linux/xarray.h
> +++ b/include/linux/xarray.h
> @@ -571,6 +571,7 @@ int __must_check __xa_alloc_cyclic(struct xarray *, u32 *id, void *entry,
>   		struct xa_limit, u32 *next, gfp_t);
>   void __xa_set_mark(struct xarray *, unsigned long index, xa_mark_t);
>   void __xa_clear_mark(struct xarray *, unsigned long index, xa_mark_t);
> +void __xa_destroy(struct xarray *);
>   
>   /**
>    * xa_store_bh() - Store this entry in the XArray.
> diff --git a/lib/xarray.c b/lib/xarray.c
> index 9a8b4916540c..ee2459ecdc9b 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
> @@ -2370,6 +2370,21 @@ void xa_delete_node(struct xa_node *node, xa_update_node_t update)
>   }
>   EXPORT_SYMBOL_GPL(xa_delete_node);	/* For the benefit of the test suite */
>   
> +void __xa_destroy(struct xarray *xa)
> +{
> +	XA_STATE(xas, xa, 0);
> +	void *entry;
> +
> +	xas.xa_node = NULL;
> +	entry = xa_head_locked(xa);
> +	RCU_INIT_POINTER(xa->xa_head, NULL);
> +	xas_init_marks(&xas);
> +	if (xa_zero_busy(xa))
> +		xa_mark_clear(xa, XA_FREE_MARK);
> +	if (xa_is_node(entry))
> +		xas_free_nodes(&xas, xa_to_node(entry));
> +}
> +
>   /**
>    * xa_destroy() - Free all internal data structures.
>    * @xa: XArray.
> @@ -2382,21 +2397,11 @@ EXPORT_SYMBOL_GPL(xa_delete_node);	/* For the benefit of the test suite */
>    */
>   void xa_destroy(struct xarray *xa)
>   {
> -	XA_STATE(xas, xa, 0);
>   	unsigned long flags;
> -	void *entry;
>   
> -	xas.xa_node = NULL;
> -	xas_lock_irqsave(&xas, flags);
> -	entry = xa_head_locked(xa);
> -	RCU_INIT_POINTER(xa->xa_head, NULL);
> -	xas_init_marks(&xas);
> -	if (xa_zero_busy(xa))
> -		xa_mark_clear(xa, XA_FREE_MARK);
> -	/* lockdep checks we're still holding the lock in xas_free_nodes() */
> -	if (xa_is_node(entry))
> -		xas_free_nodes(&xas, xa_to_node(entry));
> -	xas_unlock_irqrestore(&xas, flags);
> +	xa_lock_irqsave(xa, flags);
> +	__xa_destroy(xa);
> +	xa_unlock_irqrestore(xa, flags);
>   }
>   EXPORT_SYMBOL(xa_destroy);
>   
>

