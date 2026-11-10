Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 488FB606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=blfPTJf3
Received: by kanga.kvack.org (Postfix)
	id 648906B05B6; Tue, 10 Nov 2026 07:30:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9A06B05B7; Tue, 10 Nov 2026 07:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E93C6B05B8; Tue, 10 Nov 2026 07:30:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1875C6B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:30:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5436160563
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:30:03 +0000 (UTC)
X-FDA: 85419141486.17.02A6F20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id DF7281A0002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:30:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=blfPTJf3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794313802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BgSE/1fL0Gmuvdjo71x0BWWR6H8PrWT9eXmVlUS9oqw=;
	b=4Qo/GazJJFzkl7AIdBeFA9l0rpL/QGXtpRO6spzY+1lgLhfWxVtCfzEUy2ZBT4yOV0KhIY
	VvNDZY8aSSGMT0b+FyiF4AWkS3sHZgYKz5qPuzaZJ7cXI/HdAWBs3Y7GZIOl2G62/aJHSW
	3/CSyXVJCcUlVoLUHwVJwUADL8Ic3LY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794313802;
	b=B1bXJqMLL69q2xpAS+bM8+LFIpBrXffU6NyyHnQgVJTr0riekuV6UaJgAh/5og22tGH6FV
	Ald5VVxiKz7mVaInyx9WPNFIIdHrkOEM4HR2Ntanqfk4JaN0TcdPMsqhRGTE7+vcIr0+7j
	24CcUVI5H+Ac0MS4a6bJj3jjYISa/c8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=blfPTJf3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB21943E46;
	Tue, 10 Nov 2026 12:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A811F0089F;
	Tue, 10 Nov 2026 12:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794313800;
	bh=BgSE/1fL0Gmuvdjo71x0BWWR6H8PrWT9eXmVlUS9oqw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=blfPTJf388MwCSPYtBP64cewc1b2uqBwZadbzZJb8OnU5AzPSUz7Ze9pmAulkvUGV
	 KGs5AWiBuT8LkB86B+jsPYEfMqUOFv7Cm0Rnc0eDReHhdwvB3+Q8bZoVywnKEg+/Aa
	 U4gXPKYx1tzcqu2FEcGmvHOyko63avnRy4Dn0xih/SgUdNl16nUTxI0bMjwe4tq+MG
	 jCwEX12VoK+bAQ/5nwsJSX2QtmXuDIfu7AeNgn+SyOw7O4YusX+UHbctmDpxdjNy1J
	 kKKtXmcYu6YGusfHauB8/pihppdE919Y59BVQkxIkGoZQaJ5G6zDG5+hwrYgONrJKE
	 6dCdyraaHfiFQ==
Message-ID: <67275d3d-cc60-406c-a088-298b948d7577@kernel.org>
Date: Tue, 10 Nov 2026 13:29:54 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: don't move memcg NR_FILE_PAGES for swapcache
To: Zi Yan <ziy@nvidia.com>, Song Hu <husong@kylinos.cn>,
 akpm@linux-foundation.org
Cc: matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 willy@infradead.org, shivankg@amd.com, ridong.chen@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261104044313.2099309-1-husong@kylinos.cn>
 <DMR78FJXMD8M.QC57KT5GIPX1@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DMR78FJXMD8M.QC57KT5GIPX1@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: atytoxmajburif9fmf6g61t8m5ww1iac
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF7281A0002
X-HE-Tag: 1794313801-96134
X-HE-Meta: U2FsdGVkX1+cJIqGRmGQDeieOUzY0Kl44gI12/FF1veteBRjQRsOiGganr74+oWiFwD4vs0pARyEegJKzUETt8byQadblXo39rcx+LfB7lu8t6QI4bx57GtZi5N6U7joiYaDdu19QiAlSZCkIEPu2sfw31bW0PESujjmp+ZqJFZxPRle0hxPQsgVi1Ty1cjBAL1iOkX2RkFHOXG/y4DopuhroWi8WinlpO7OngOOjykjz893LoeY6alL8c2QpK/WDBl1XKyKap8Hsv3GOi7zw8pOsVJMmoFv0UQ1K8IxwHnBn1pQsBWcklg6TQ/jIWkb+OaiMNMEFAbDMhfIy1LtZrw+oRP9jbqy9QZpDIYNPsrfz2fO+oZRfN3ejx1mtAFkHWsAXOzpp09V56Yxfi53F4QVYuaX3wiqvZwKColFs5CFd8RS3YwyNEHAG4YbXPgm9axAl4IzQzjxbgdRCEURqf88zI+PnbBHbaypHkZ7Xit+L5f10xj4AeKz0yi2hoQPdEWqQIqYvlgW2OmDn6/iDBlLjA2yT9TmBV2dtP2H+C4vTuCNw9qkeENu10CfLtHKbP/AYeVCZTFd7V4avWyRwQV0/oMal5KuveX2TdXVjasVVcjYgY2V94p9x5YT+jumMQY7lEwx7i8prdKTrzAkcG0veKOWhPdUiGA14S6B9/NerZ7ePdI02HdARrUI9qD6i8rqcPEiMCszn75W1a8iJdAX3nACdMq4Af2nOP8LYwAlciaeFUGFjWO6fqtw9HQIspw4mLFI6z9uw2DzqhWIVIFi2urtxhT2H2jn5R/JtxIMB2+I/fkEi7U+82F7qqDyVgbHoqKsSnjRqrUM8t72PWZVODTH7AiZfVpNaLERyPIcWe3nGQ9DGt2z503/uGbQ/ArbOylQg0H42HsBZlzWE47vdUrXTjBRHoSK1fzDnT0gEEUZlv77m5C+Oe8iDqEjvNr7K5/oZ0NvEEEhW3K
 00n86hpN
 nFWAR5m86VCVZLfF0XGcTmFvO6yKYkTXOaSPuP8x6k1mRMsKGZPel42eKxOARinCO8Kxsyk3T2WN71gEbdW2GcfaTkjJdPzhKn6nWNxbVoCZU9i0FHltbewa2YfqaTvj5OADwkRAHN5yJVGVxSkNwIddkJX4RnfOgrmcH73ruBtMW8eLcFX2n/zSGocF80+8vHD2k2GjzAKSzgtUHXxQkUMM0rjnMhwM4HFJAmobMEI5ViJ0bpA2x+kCAAfgIrPlP0ghThBD++H4EDJ6rwBf961XKH+419DNz7vvC4c6zVe79ptGwKSxHAz2qrS3ma/AcDzJY8x4VxUJYqXAsBHZtPPLBbttFpOibC7VmTsrUMk4YIK1ei9fbpb1OkHBAPvW4YuHp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 04:09, Zi Yan wrote:
> On Tue Nov 3, 2026 at 11:43 PM EST, Song Hu wrote:
>> NR_FILE_PAGES lives on both the node and the memcg plane for page
>> cache folios: filemap_add_folio() and filemap_unaccount_folio() charge
>> it to the folio's node and memcg, while __swap_cache_add_folio() and
>> __swap_cache_del_folio() maintain the node plane of NR_FILE_PAGES and
>> the memcg plane of NR_SWAPCACHE.  A folio in the swap cache therefore
>> carries no per-memcg NR_FILE_PAGES count: shmem folios drop their
>> memcg file accounting when swapped out, and anon folios never had any.
>>
>> The cross-zone arm of __folio_migrate_mapping() moves NR_FILE_PAGES on
>> both planes unconditionally.  For swapcache folios the memcg plane is
>> empty, so migrating one misaccounts it: the destination accrues
>> nr_pages that were never accounted there while the source counter
>> underflows.  The wrong counts persist until the memcg is destroyed,
>> but the aggregate in memory.stat stays correct, so the drift is easy
>> to miss.  NUMA balancing, migratepages, compaction and memory hotplug
>> can all migrate such folios.
> 
> It would be better to simplify the above like Joshua suggested.
> 
>>
>> Reproducer, on a 2-node QEMU guest with cgroup v2:
>>
>>   1. create a cgroup with memory.max = 50M and swap enabled;
>>   2. memset 128M of anonymous memory in it, so reclaim swaps most of
>>      it out;
>>   3. fork to raise the swap entry refcount, then fault the memory
>>      back in, so the resident folios are swapcache ones;
>>   4. migrate_pages(pid, node0 -> node1).
>>
>> "file" row of memory.numa_stat (bytes) after step 4:
>>
>>                     without this patch      with this patch
>>                       N0          N1          N0          N1
>>                      0 (*)  51691520         0           0
>>
>>   (*) the source counter has gone negative; negative values read as 0.
>>
>> Keep moving the node plane via mod_node_page_state() and skip only
>> the empty memcg plane, mirroring the swapcache exclusion the NR_SHMEM
>> handling in the same block already applies.  It accompanies
>> commit 4eef27af2932 ("mm/migrate: move NR_FILE_THPS on cross-node migration")
>> and commit c5eef2e03618 ("mm/migrate: move NR_KERNEL_FILE_PAGES on cross-node migration").
>>
>> Fixes: 0d1c20722ab3 ("mm: memcontrol: switch to native NR_FILE_PAGES and NR_SHMEM counters")
>> Signed-off-by: Song Hu <husong@kylinos.cn>
>> ---
>>  mm/migrate.c | 16 ++++++++++++++--
>>  1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 28a8d7734735..bc60f6587d1b 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -690,8 +690,20 @@ static int __folio_migrate_mapping(struct address_space *mapping,
>>  		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
>>  		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
>>  
>> -		mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
>> -		mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
>> +		/*
>> +		 * Swapcache folios carry NR_FILE_PAGES on the node plane
>> +		 * only (their memcg footprint is NR_SWAPCACHE, see
>> +		 * swap_state.c), so move only the node plane for them.
>> +		 */
>> +		if (folio_test_swapcache(folio)) {
>> +			mod_node_page_state(oldzone->zone_pgdat, NR_FILE_PAGES,
>> +					    -nr);
>> +			mod_node_page_state(newzone->zone_pgdat, NR_FILE_PAGES,
>> +					    nr);
>> +		} else {
>> +			mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
>> +			mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
>> +		}
> 
> Like Joshua said in another email, it will be more readable if
> NR_SWAPCACHE updates can be moved into the then branch above.

Can one of you write me the updated patch description? Thanks1

-- 
Cheers,

David

