Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7936A606AA44
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k3cl72xz
Received: by kanga.kvack.org (Postfix)
	id 7EAC26B05B3; Thu,  5 Nov 2026 05:10:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 799846B05B9; Thu,  5 Nov 2026 05:10:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2856B05BC; Thu,  5 Nov 2026 05:10:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41E206B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:10:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D99A21609AC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:10:55 +0000 (UTC)
X-FDA: 85400646870.07.5021115
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1C49A180006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:10:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k3cl72xz;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793873454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXZ/Cop4M0ZnDrJ4wQeY87tjQ0rUXnvNstfpKB55sUk=;
	b=WbxMy703/chV6+Ht4YSxFTSSjgt0LamX7WS0hdCVmpcparCfP8L3SZfhS4jbPLVjsnntb4
	GCkWrwhjitbuVg/JQ9LXzuZa1u/hcsysaw4ulI5U6JjOboBfVWa14vkaTSpnb9QTHdaTIb
	na0MmmTLTFGLwx4pz/IbfjJzk09ggrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793873454;
	b=qQWUCnZsj3YOBVWO4DXaH1Y18Ejq8UNouxhdJjxaoxLpdCrMGiT2xihOthBLsbXnJpswsQ
	dnQcxz0YrLd2bAkxpCxSaUNk64eMVMb31q/PsqxfPpc1hzfGnTc/44XWx061vL6BDOo6jZ
	xXJubqf9rmClbwuZqJSM1XAsIi11/IA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k3cl72xz;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B57E4049A;
	Thu,  5 Nov 2026 10:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31BE1F000C1;
	Thu,  5 Nov 2026 10:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873453;
	bh=TXZ/Cop4M0ZnDrJ4wQeY87tjQ0rUXnvNstfpKB55sUk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=k3cl72xzOEiy9SzPFOTWRhOm9Pw2JPryzjYRC/tErxE68Soeko0mqfdTqUQydNd56
	 gnZymVVVtBskHkDzHmJ5wWkG0tke1RReilVqsS9uOX1nUdldc67ef7k5KMrsUVNHfH
	 dNsTzrw2DUe9KMN/fevHO2g+BUAn+hnVzqlw/maQBYuf8visyRnQPgoFeLRVsuWFCf
	 9xBCM8rcm3y5QluKH9UGk9EyoIsZIuEC2WrrwIrnOTNLWMbmyL8saM8vMUpQXKTL13
	 eDJ9JfaHXti3IwNjhXzkkBwssUkM3h3VwCf5MYS2kFNayxDLYyMp893NbVtEi3Yez8
	 +GmSLJ6dEPV+w==
Message-ID: <717bba87-ecce-4425-92c2-b28f172b2bf9@kernel.org>
Date: Thu, 5 Nov 2026 11:10:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: don't move memcg NR_FILE_PAGES for swapcache
To: Joshua Hahn <joshua.hahnjy@gmail.com>, Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, matthew.brost@intel.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, willy@infradead.org, shivankg@amd.com,
 ridong.chen@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261104044313.2099309-1-husong@kylinos.cn>
 <CAN+CAwNJP+CP2kRsgcYKA=3cgy-o9k5PoUnR9vUy4suJu+4ciA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAN+CAwNJP+CP2kRsgcYKA=3cgy-o9k5PoUnR9vUy4suJu+4ciA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bdrspb9z4bbk48o6y5fbidt1xarx9ooq
X-Rspamd-Queue-Id: 1C49A180006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793873453-600048
X-HE-Meta: U2FsdGVkX18MXYv3MK2M+1+ykuxHD/7rBCRYol0CrmqqlOy38WlGH4+lhePZvtuA/JKKz7J4YrQud6wmKjEQyL0clY/Wt4K/9c3c9tfdwcEhagP2dxjwx+DXvhQ0lx98HfVIWqbEGxe636C7TVN2jT8j2g7ruv944lqHBv402/FKOV4EasM7nQRIma2LKA9gzW+5O7vmKgrm3ynFLI+/En5f/1MLsa2/eBeMHdnRAqYhWDXtC2cnqG6U7coQCeUcNRv/N0U31i2Bu2bmWQbOrId+YNH1hNt0+0ydI80cDVdiMRzNbaSmbF5wWVbixvT8uqyxtDHO7raQE/+f6CPZ2RqJu87G8RaBOszx9rC3W5I/BidRIpDzMcLSqmlFkbsw2gAHlgyS9mzTy8DOI5jCYlPGEFNPFR1Ghno8RS23V46qDQoS0JnLYV5PxrroLXoymYwAX+Nv53SHgW56ugfX85XQBIQqQCciXc/Xtur8iGe1Hq9bmKEhEYDZLZUQXO/8s9/lI3AxtmGi/RdCHvK+DCL0K438i3mY+bkaYZnCGoJZS0jZsHZEw5vVgPMWWZnS/QbApWt0R3QV3nRSx8+H9ZGicZPQawlZPoLcIRfhgTUufLYauiGMrQ2FFEWYa3EKan73RoPv3WyUAenP4O8Fgmdu78GjIO/vvG9HFi8pviU3fj2uHYLlUJevD5jB6ZKevpKECEDEm/E7wOQBejXKIBmrjx2+Z4f1gNFUGEfkFlAuUkH5f+cFFOkr2P07nJT0gIg0S+9wcvudseoBKZoMuA0ApTzfAEQ80ee5Z2/jpMdtmh9LKeCn1nfjNtn6dKJjsRa+DlY5qR5ZtVelUcj23TnluK7vRHAIpoqEcBOqLppK72hi3EdaHwsOcj+5WKcUzqm2vbQtpg9LuZbCYkogglicIXGsgO5veuCzhxsB3oiRr7O754i77guLylCpUCQi/pVgLD4odR8rmemX/hP
 BoQi5aqs
 1EzPL1bR8MVYwBZjhHjjaogTFjyTaF2kOyfeR6Jx7XTleL+b5N7X/joZ+N6PhZZxB1OPyPycJnj8QgF0AEjAP23EyKDpkTLnqUfLrXEkmv3hiYXQ3W6xraPVO2xkFfSGqlLbvIR6ULgN7BXv+znTmpcIxaONLl+3uz2Y/BYnJmY/RgKRIECq/+ISxbZ/Qnwp9wDskBCblI5SlWSMOgvm8+d0dZqHzoW6Ky/AC1UN+bJ0ilB3nIYutgyifXOVie2MbwruoFC1YlPAF1/M04i8vx0ztfkOftHB5QFuowwFH/HrzV3xssbCCLLQ8sJezN9VjqfOU6Y8czkcqtOcn5/5u05mF31x6WYfWNdaoPHQ21GGZpUlQFjxyV3kILZY/d0K9LF+7Q5TJeEzDgNDvMGBH5u8F3D97D3GvyJJUvvMLqCBP0wW5i+EIEZ6JDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 16:54, Joshua Hahn wrote:
> On Tue, Nov 3, 2026 at 11:43 PM Song Hu <husong@kylinos.cn> wrote:
>>
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
> Hi Song, thanks for the patch!
> 
> I think this description was a little bit hard to read @_@ so the core
> problem is that swapcache folios are accounted differently in per-node
> and per-memcg, right? And that swapcache is not accounted towards
> memcg's NR_FILE_PAGES, so we need to split up the mod_lruvec_state
> into the node and memcg accounting separately. This makes sense to me.
> 
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
> 
> Thanks for adding the reproducer. This helps a lot for reviewing!
> 
>> Keep moving the node plane via mod_node_page_state() and skip only
>> the empty memcg plane, mirroring the swapcache exclusion the NR_SHMEM
>> handling in the same block already applies.  It accompanies
> 
> So you note here that the block already has a kind of swapcache
> exclusion. To me I think the code block we are working with here is a
> little bit complicated with all the cases we have to look into (and
> three separate folio_test_swapcache() calls...). At a future time I
> think we should explicitly lay out all the cases (swapcache /
> non-swapcache shmem / normal file) to make it a bit easier to follow
> where everything gets accounted for.
> 
> I say this because it took me a second to realize that the #ifdef
> CONFIG_SWAP should only apply to the NR_SWAPCACHE modification and not
> other swapcache conditionals since it protects the enum and nothing
> else.
> 
> Anyways, none of that should block this clearly user-visible bug.
> Thanks! I hope you have a great day,
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

This sounds like something we want to fix in stable?

-- 
Cheers,

David

