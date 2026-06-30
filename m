Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60A81C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 02:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2D96B00C8; Mon, 29 Jun 2026 22:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C7A6B00CA; Mon, 29 Jun 2026 22:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E853B6B00CB; Mon, 29 Jun 2026 22:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC3F96B00C8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:44:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26B471C27CF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:44:10 +0000 (UTC)
X-FDA: 84935034660.16.5ED36EF
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 443A51C0005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:44:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bHTv8m80;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782787448;
	b=c+4H9/f5kdrOJLkvceVODmjj1KAMprfGzuTRjqkuxSDfnnmcTOhr8uMXFJc8iKAeLqVhNH
	i1IpgGNJe5px49LarN/lNaA8rxzNa6F4ENrL6Q/QFNn/uF/wCXZFU+0hy3IFBIXWN11kzr
	hIkFnhLM/bsHVEDtuM1tMZcPjirMQl4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782787448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OisJI56156U7nSgtBYB0oE48vrZLbekiX9UlbgQeffk=;
	b=bc+sogbQwNi2XeK2v3JkUFM+lF0UqfR3MOcUkplERTDltph25kIoJkRJw6lMtY6nYhRSn/
	9dFYjzE0xP5bAMZ4YkEZakk2hpIVZ3LigoOgjlC1pYHxmLI/N29LxFe7D+haLcmX+cjOGA
	0e83Ud3THx5Vkhr42jj+Be6z1SF0UV8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bHTv8m80;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <57a65820-d0b6-48f5-8de6-5d362d0e4ca3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782787446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OisJI56156U7nSgtBYB0oE48vrZLbekiX9UlbgQeffk=;
	b=bHTv8m80NqwdlrtRO9yUqtJ+KyEoRzt1XgxKw5T+gWwbI6l5s4dSAAlhq5sTu1aN0CWEB6
	Slnd8GFyn1MY5MgL/PIG0AtF5+LzPVNuq5sS4D5jFsaWka8szV7X9ZY/x7xjAWmtr6Z8JX
	IucB/ZEdEHbdXLy+CuIYEGYP+QwpaBk=
Date: Tue, 30 Jun 2026 10:43:57 +0800
MIME-Version: 1.0
Subject: Re: [Patch mm-hotfixes v5] mm/page_vma_mapped: fix device-private PMD
 handling
To: Wei Yang <richard.weiyang@gmail.com>
Cc: liam@infradead.org, linux-mm@kvack.org, ljs@kernel.org, david@kernel.org,
 akpm@linux-foundation.org, sj@kernel.org, balbirs@nvidia.com,
 harry@kernel.org, jannh@google.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, vbabka@kernel.org, ziy@nvidia.com, riel@surriel.com
References: <20260630021540.17297-1-richard.weiyang@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260630021540.17297-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: y11nae33qwprp7gmb4t4k33sqp6xiypi
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 443A51C0005
X-HE-Tag: 1782787448-390964
X-HE-Meta: U2FsdGVkX1/CWtzJB5d5zDkrf1A8F4jwFESO8sxofzxf91fl4MPnDqHJwvGR7WL9YK3z0/hs3mWnwkPxhvE3btRu9T9cgKzNHHXtItqH7l0vrMSqc102jSzTh+8Gnw9DDrQ6QocUNuA0v+po0if+hJHEB4MbhkABbimol30Vn8PPj5+mJpCEtDMaWhhbLj7+t8bUNTkGyaMQcYP7YT+IsVj3DCsUfAmODq2gUMKxGpcw18HeAiMzOHvbWT9mt4o0PjJKDI6e7kqn8E9MPcQuT6d9U2KsEuPvEBiQmiTTntI3L06wxaKwQTEqXiXpzfCZYqruSylsY1zQ8BBvGryp8T0iNefIRJK7qIBMERIdb+ATzQZ4x3yldX5b1lvaVHt21+ALHqqxP6Ll5oPumTmVGFS1DQFupP4TuaBu5kpR9JEEVhgGL/qvSq1oRWRGnq9ubg5+Nx90n+p8f9jPKGpdMMNy3jqMjsWWMc6siQcUUFC7eArFM8ZcbmJNgeWuTqxFvz1nTYsg5IVMC6Zw2ZbDThUrgC/CiTDUyOOnedHhlzno6afmRMu1EqqvHC/O1Zd4dA49CX3eiDKj3/HPDacxgfgkcKaEmxqjdiPMpu5rSwtw52mqZC+OFkJiYLj2LTxbhoTYIzQQR+yeOtQfr5fOqkbgh3vgm/5sZh3ZgAtxIKDyuHZZJzNjTmayYbxfGkEKlzkI/bt4NeZq2vznT8ymXKqLOzOkyJzK920o4ITIdy0FDtSgXk3741IFdUaBljgFRb2+vTj+NprQjWuamw5gsEu13wc0hxSISfvhtuMo8KdqAxMA1wk9sOHv0ChxyrlGCvpUfbOCo2JjLDJAwC+l995fndtkSFQYA2/z9vkwIC/+uMSChHDyMcIii23a3upqm20itjSf7vg9TBaK1QU4ch58pbSxF5S/6De/IGKkgbaWeEKjMgCyPldfUaXb74BVwlPZQCJ1XWppLjY+05Q
 e1E6yL6S
 O+8TGySLAFF1w4Ez2J0F8w06+LHsxDi3WwahzmFpseXffVRSQiryZzQKWGPgIKD/m9WQPgYWDLxEFcr8YaDPNtqyc8PG7RdaqkJC62YshkJg0z5IlSidvTxNWuMPQy4f6TzlrUDyCRaEnRwXzE3sgi3YQMk5a8r7G6NvjM7ExnNAk+GBndwIAYGAhZ6WbsJ2sN+WkOYHG8expSBZz91UIGol9dm4uE6l+0G/gW0/Ti4C+l0jxTz7aSmstR0jrmTjDSl7VaQvUuclRQUTh4q0HZDhmmAkmcNCSdvbFQBSQIqE3tbBfx24QwryRHDa4R2AUJBo2syCND0ce0X4R6PAJVdihohdLjfvdtXjxRsYU4AlX9funboo/XwuO2tPabBOfMx0e7vrAzPBcPu2pce9UqE6uMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/30 10:15, Wei Yang wrote:
> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") introduced the concept of device-private
> PMD entries, but did not correctly update the rmap walk code to
> account for them.
> 
> As a result, when page_vma_mapped_walk() encounters device-private
> PMD entries, it takes no action other than to acquire the PMD lock
> and exit.
> 
> However this is highly problematic for two reasons - firstly,
> device private entries possess a PFN so check_pmd() needs to be
> called to ensure an overlapping PFN range.
> 
> Secondly, and more importantly, if PVMW_MIGRATION is set the
> caller assumes the returned entry is a migration entry, resulting
> in memory corruption when the caller tries to interpret the device
> private entry as such.
> 
> In addition, commit 146287290023 ("mm/huge_memory: implement
> device-private THP splitting") allowed device private PMDs to be
> split like THP mappings, but again did not update this code path.
> 
> As a result, we might race a PMD split prior to acquiring the PMD
> lock.
> 
> This patch addresses all of these issues by invoking check_pmd(),
> ensuring PMVW_MIGRATION is not set and checks whether a split raced
> us we do for PMD THP and migration entries.
> 
> Instead of checking for a subset of the cases after taking the
> pmd_lock(), put device-private along with pmd_trans_huge() and
> pmd_is_migration_entry(). Also remove thp_migration_supported() as
> it is already guarded by pmd_is_migration_entry().
> 
> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> 
> ---

LGTM, thanks!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

