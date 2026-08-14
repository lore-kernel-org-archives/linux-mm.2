Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C01EFC5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 02:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8119B6B02E3; Thu, 13 Aug 2026 22:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA836B02E5; Thu, 13 Aug 2026 22:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693E86B02E6; Thu, 13 Aug 2026 22:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34B706B02E3
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:55:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 821AB1401C8
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:55:31 +0000 (UTC)
X-FDA: 85098359262.27.B3AC11E
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf25.hostedemail.com (Postfix) with ESMTP id D77E7A0002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:55:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=PC1yFBTJ;
	spf=pass (imf25.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786676129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5QOcvwE+F6mgiRV6cDZvj6pc+a7dUoPydsJAnpmxLoo=;
	b=B6Z/jXZRaKPEV/uplPBIxhq1d/igkVdxkijOy1xh9o844o/7pCBXLvNydH1wdphv0G17O2
	pJvT74ndZ8sUYoq7PvqlPspQ62OjTWdWfIUjjKd/bQubpdk6aEGe9VTS3YHk4+/kPI52Cd
	O1kJ2O4NDZZVAyDECKDzQmTCvUhnmLE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786676129;
	b=8ZKjLYD+SpPkponNTH+d2FvRjJJMTOClSni4lyIzmwgGZHhdr7iENs0mWT0GtqGdQtZwhV
	Fki0VOYhFY1QbU7o1OtjJEN9M58yJlycEx+L/C/VN0DOOyNC5BboFnMQ05E6FzroB5AvPS
	E4fV0C83n8CG1qrORqVc7TB/zH+flZs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=PC1yFBTJ;
	spf=pass (imf25.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=5QOcvwE+F6mgiRV6cDZvj6pc+a7dUoPydsJAnpmxLoo=;
	b=PC1yFBTJjAPQc1grgzibGOFxINjHq1tMwF4EvTBCLj5+xu18NIhP6o0+VYwOSA
	R7nZg9Cjt84ItLBGzzgU1cIsvrEsuTac6GfcuQFRsd2jHVHMqj4Z0++6ThfucRuz
	07paMOh8YpCphdlXRzQXt9txaq7vCE+4Wzzk49L3+3MAU=
Received: from [198.18.0.1] (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgD3vwqMg35q7GDfMw--.16540S2;
	Fri, 14 Aug 2026 10:55:10 +0800 (CST)
Message-ID: <44eb0883-c49a-4d02-b330-914cd167840c@163.com>
Date: Fri, 14 Aug 2026 10:55:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/swap: publish cluster tables after full initialization
To: Kairui Song <ryncsn@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>, stable@vger.kernel.org
References: <20260813150316.2793642-1-xialonglong2025@163.com>
 <an3xnGPBCASWuS1w@KASONG-MC4>
From: Longlong Xia <xialonglong2025@163.com>
In-Reply-To: <an3xnGPBCASWuS1w@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgD3vwqMg35q7GDfMw--.16540S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3JF4DKF47CrW8GryxGFWruFg_yoW7Zw1rpF
	WrGas8KF4SqrnrWrsxJw4DtFyrJ3y8Gr1DGr1xt3Wa93Z8Zr1fGayktry3uF9rCF1DJwn0
	vr15Kwnrur4Fy37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UO2-5UUUUU=
X-Originating-IP: [240e:46d:1800:11e5:a033:614b:75d3:82d7]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9w8+N2p+g4+5ZgAA32
X-Rspam-User: 
X-Stat-Signature: d88sz4yz3qsfqr94ukmxkytkz8o6pdx8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D77E7A0002
X-HE-Tag: 1786676128-758073
X-HE-Meta: U2FsdGVkX19FXQ473D8GPrXSgvg9jU0B0ybI90mw93dMJYfLTXj7tNAkiDlavYHpYzjhdROYGU3ICv2QK6x5m8dYEZuxvYhDw6MUrn3epUEp2+VCtnTKHeNwpPgdXntFRLUdg9+I4+0OychZ7isohy6LNX2T4gu0154Og1LK8WG7I20pbzHg05AYcgJqM3eE7kXMQFBNrX89wljmFmRXgZP0l6/4NtJDG2E6ZDw0QuyBCnGTLsRaadQM/SYV9Rh1mQp0LRKA2d707B+r7OSO13ZwrmR8Ux1aPvdM459BTJ2aVAvNUSnK6pq7259/spEuRD1cYFvhsWcjs10E/WGLExuUTH2jvcZVaSVNKY0GV/qkK5JxNQwUlzk83pDOviLm9asnGwPv3+wrLdLpagGHayQnXpkxSR4DLbCI2CMjEWA/HY8H90pJhMCKEDwkXMzoOYZCMvtBG18WsbiVRXsQhfxvSdYI21/2endihGGPX5E/+oXs2TF0aLSpgvAvd06gZPFfVZkhKZ/wUCFxVSw2E1UoyrPxqjYQdnIWsitGwcZbRrjwtfvfkZHPbEO+ih/4t1tiQpyQ9x4O1gutDikwKgf2NJFQ3tUdC7zIwuA5bcHD08KAQuBI4IowCB7pQ23RclYzWtrebR3hxJL4jH9oyGIUk9Zw+KW1Ie8Bn6/l6HZZ7RyeHOYEEStztNEAqcdaYzt3GQgFeb4IQfu0S5vm6hcZiP+6+z3NZxusCGVkqsOeqA01d4zETRePU2F2goFSSHvoBvOeAbSTCR01nYG5gIx0tDEKlRKaEem1bnaki/vS9sRG08gQGKzRuRIxoCpwEy2K3DnvI/qR9DbA7/cUv9ztuOqwv6n2L9H7aAtFAP27uvJw0W+tTYHrQ5sZLtZcDGl4iiPVrMavdgjvBvbTn71THsPtN9mtFS0QvSsI4yoryxjIYRCXAJQqkgOOAK/m61DIz25HyHagxe1qdZT
 5SL9WppR
 TBdB/9/9u2HZ/FSl2J6NSV/TjpTvkbkgHqp/V4SCkv7ErPRqlA85Pma1SqeIEuxk0LRkjc2rA/I4dwBYQ88HqSkAW4vAlBlRv1IP2j6Q+metdLDryjfKbj6Gl+CH7iisL72oO42kZFPTM6DTz+RYnX9ByWsatkAXfNR2P1OS1g+jmhQzXzEb2RfOwIhG5WVDRXX9E2w1U3TzWVTVNSb/QXk/FKYfXlhNibLSgRyhkY5pvBQtRcgyA721g9IrKvObgEJ6anITaPz63+w4a9t4eKz6/Qcy91TnUwIs3auZPEcNb3ltIByr2QXHgaE5NniqFMPTcU8OZ+yKaipGWtTFEgzGmpRUTwzTUkeMShsFxfaCVOluvED7cI+uTBX1vp93Ff4TqInYkgzeyMVz+Lcrh07RNu0iKZsXv46KHzdUmBKKlsZ40xFzL1pFUjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui, Youngjun, Kemeng,

Thanks for the comments.

I missed Kemeng's earlier patch and the follow-up discussion. Sorry for the
noise and for the incomplete Cc list.

Since this issue is already being discussed there, I will step back and let
Kemeng continue with the updated version.

Thanks,
Longlong


在 2026/8/14 10:35, Kairui Song 写道:
> On Thu, Aug 13, 2026 at 11:03:16PM +0800, Longlong Xia wrote:
>> From: Longlong Xia <xialonglong@kylinos.cn>
>>
>> swap_cluster_populate() drops the local, global, and cluster locks
>> before its sleeping allocation.  The allocation helper publishes ci->table
>> before allocating the memcg table and, on some 32-bit configurations, the
>> zero bitmap.
>>
>> A stale per-CPU or global cluster cursor can reach the isolated cluster in
>> that window.  Since CLUSTER_FLAG_NONE and a non-NULL table make the cluster
>> appear usable, it can allocate a slot without the auxiliary state.  An
>> auxiliary allocation failure can then tear down a table which is already in
>> use.
>>
>> Allocate the complete set of tables into a private carrier.  Install the
>> auxiliary pointers and publish the main table only while holding ci->lock;
>> the slow path does this after reacquiring all allocator locks.  Allocation
>> failures now free only unpublished resources.
>>
>> Fixes: b197d41462c2 ("mm/memcg, swap: store cgroup id in cluster table directly")
>> Cc: stable@vger.kernel.org
>> Assisted-by: Codex:gpt-5.6-sol
>> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
>> ---
>>   mm/swapfile.c | 167 +++++++++++++++++++++++++++++++++++---------------
>>   1 file changed, 117 insertions(+), 50 deletions(-)
>>
> Hi Longlong, thanks for the patch and report.
>
>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>> index 78b49b0658ad..2ca947c540e9 100644
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -410,6 +410,99 @@ static inline unsigned int cluster_offset(struct swap_info_struct *si,
>>   	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
>>   }
>>   
>> +struct swap_cluster_tables {
>> +	struct swap_table *table;
>> +#ifdef CONFIG_MEMCG
>> +	struct swap_memcg_table *memcg_table;
>> +#endif
>> +#if !SWAP_TABLE_HAS_ZEROFLAG
>> +	unsigned long *zero_bitmap;
>> +#endif
>> +};
>> +
>> +static void swap_cluster_tables_free(struct swap_cluster_tables *tables)
>> +{
>> +#ifdef CONFIG_MEMCG
>> +	kfree(tables->memcg_table);
>> +	tables->memcg_table = NULL;
>> +#endif
>> +
>> +#if !SWAP_TABLE_HAS_ZEROFLAG
>> +	kfree(tables->zero_bitmap);
>> +	tables->zero_bitmap = NULL;
>> +#endif
>> +
>> +	if (!tables->table)
>> +		return;
>> +
>> +	if (SWP_TABLE_USE_PAGE)
>> +		folio_put(virt_to_folio(tables->table));
>> +	else
>> +		kmem_cache_free(swap_table_cachep, tables->table);
>> +	tables->table = NULL;
>> +}
>> +
>> +static int swap_cluster_tables_alloc(struct swap_cluster_tables *tables,
>> +				     gfp_t gfp)
>> +{
>> +	struct folio *folio;
>> +
>> +	if (SWP_TABLE_USE_PAGE) {
>> +		folio = folio_alloc(gfp | __GFP_ZERO, 0);
>> +		if (folio)
>> +			tables->table = folio_address(folio);
>> +	} else {
>> +		tables->table = kmem_cache_zalloc(swap_table_cachep, gfp);
>> +	}
>> +	if (!tables->table)
>> +		return -ENOMEM;
>> +
>> +#ifdef CONFIG_MEMCG
>> +	if (!mem_cgroup_disabled()) {
>> +		tables->memcg_table = kzalloc_obj(*tables->memcg_table, gfp);
>> +		if (!tables->memcg_table)
>> +			goto free_tables;
>> +	}
>> +#endif
>> +
>> +#if !SWAP_TABLE_HAS_ZEROFLAG
>> +	tables->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
>> +	if (!tables->zero_bitmap)
>> +		goto free_tables;
>> +#endif
>> +
>> +	return 0;
>> +
>> +#if defined(CONFIG_MEMCG) || !SWAP_TABLE_HAS_ZEROFLAG
>> +free_tables:
>> +	swap_cluster_tables_free(tables);
>> +	return -ENOMEM;
>> +#endif
>> +}
>> +
>> +static void swap_cluster_tables_install(struct swap_cluster_info *ci,
>> +					struct swap_cluster_tables *tables)
>> +{
>> +	lockdep_assert_held(&ci->lock);
>> +	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
>> +	VM_WARN_ON_ONCE(rcu_access_pointer(ci->table));
>> +
>> +#ifdef CONFIG_MEMCG
>> +	VM_WARN_ON_ONCE(ci->memcg_table);
>> +	ci->memcg_table = tables->memcg_table;
>> +	tables->memcg_table = NULL;
>> +#endif
>> +
>> +#if !SWAP_TABLE_HAS_ZEROFLAG
>> +	VM_WARN_ON_ONCE(ci->zero_bitmap);
>> +	ci->zero_bitmap = tables->zero_bitmap;
>> +	tables->zero_bitmap = NULL;
>> +#endif
>> +
>> +	rcu_assign_pointer(ci->table, tables->table);
>> +	tables->table = NULL;
>> +}
>> +
> You don't need to shuffle all the code for a simple bug fix, you can use
> forward declaration if some functions are needed earlier.
>
> ...
>
>>   	/*
>>   	 * Back to atomic context. We might have migrated to a new CPU with a
>> @@ -568,11 +621,19 @@ swap_cluster_populate(struct swap_info_struct *si,
>>   		spin_lock(&si->global_cluster_lock);
>>   	spin_lock(&ci->lock);
>>   
>> +	/* Nothing except this helper should populate an isolated cluster. */
>> +	if (WARN_ON_ONCE(cluster_table_is_alloced(ci))) {
>> +		swap_cluster_tables_free(&tables);
>> +		return ci;
>> +	}
>> +
>>   	if (ret) {
>>   		move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
>>   		spin_unlock(&ci->lock);
>>   		return NULL;
>>   	}
>> +
>> +	swap_cluster_tables_install(ci, &tables);
> It seems the same fix with Kemeng's patch? Youngjun have notice this too.
> https://lore.kernel.org/linux-mm/20260720071342.50742-2-shikemeng@huaweicloud.com/
>
> And I think you missed some Cc, maybe you can try tools like b4 which
> automatically generate the Cc list for you.
>
> Hello Kemeng, can you help check and see if an updated can be sent?


