Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A49606A338
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a9GKAGL6
Received: by kanga.kvack.org (Postfix)
	id 9DE3F6B05B5; Mon, 16 Nov 2026 13:44:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5C46B05B8; Mon, 16 Nov 2026 13:44:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC316B05B9; Mon, 16 Nov 2026 13:44:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB7E6B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:44:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 46568A7CD5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:44:57 +0000 (UTC)
X-FDA: 85441859034.01.1F91A0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8139A20009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:44:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a9GKAGL6;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794854695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EfMm5UKO/b+xbcoLhLXEne0KqVWvpjz0F0uxyUz9DJg=;
	b=it9abaE5wiuJDiOVy6zeM/FsGkVn1lqBiwclAVFVMWYrEbs3Mbtilow5wZczx8vktYhgln
	t9EPdekAHneQgJ2mDne8rx9B+E1kUqo8lPVFzqgWfu7/BOWRldsgEwrGybjs5HRsQQVPMT
	1jlfPBMeeWEOa2p/F5YNpvjWjUaKnSo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a9GKAGL6;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794854695;
	b=IBh3i8Jl16kG1TUDiQ8534lglUDyOWkXwCnanEtqYchiBombhSjW2GJUtuL3A17AdBs9i2
	nfn6I9d9e1w8t4cpdW50h/+JipEvsf2xtX8rtuakaxNmg8bKdXuy7lAuJhrC04psyjTagl
	ndISxsYAxlF3SPWzGwtFZwGSLKjNjWU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A377542486;
	Mon, 16 Nov 2026 18:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74ACB1F000C4;
	Mon, 16 Nov 2026 18:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794854694;
	bh=EfMm5UKO/b+xbcoLhLXEne0KqVWvpjz0F0uxyUz9DJg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=a9GKAGL6SmSIX91dJbJlokWyOCe3GYYifYd/yidJ7sJ5uxKCf5K3SkAI6aIy4V8Ag
	 UH6T5kAPE+93oZUrvLXqrRFnVEbHL9MCqiOx0e1qwy3KERGec74id4fAR9Sx9GBDoR
	 EbVoBrByP9A9rPWvBS/nCgK/OyC7Ea1KMvwzUYmmMonJTjQE1u/IigwEK97qnZYClX
	 8e4hnc4xO5a6+Q71lvcdf91j2hyJEjJzYJMyJNz2+dkyzJt42+yMLTyPxK5pIn5sLf
	 M4KhOtH3lur+QJE7TpWFbmzSIxygodBRSiGhnekqRnOjcinRBJFxF78h0SqzoCV9pO
	 YLH/E1sDrsjNg==
Message-ID: <40f86b39-96cb-4fb3-9282-ec06504774e5@kernel.org>
Date: Mon, 16 Nov 2026 19:44:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm/migrate_device: avoid leaking folio references
 during THP splitting
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kernel-team@meta.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev
Cc: stable@vger.kernel.org
References: <20261116063624.1382944-1-usama.arif@linux.dev>
 <20261116063624.1382944-2-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116063624.1382944-2-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8139A20009
X-Stat-Signature: 6d4wfop5c4g38mgneymxibz3srrxmd3o
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794854695-351624
X-HE-Meta: U2FsdGVkX19fzga0A8ApgKcLfXu9AJYU8iNE9OK4RPZlHpR6EU/x/Z9bvFjijefE6J9u69FVvohIxGqjRT/4SD07bZaXtt6QRez4qKlvTaRmCjvfbxUboJwpxElvAeFKWmdunRZNazLqbZWWe+r31i2e8wWh7axdbDX7ny15MKaJIgpMlTjkTTN0PR39ihK4wZJwhhVjEUcwjtt9+HGVVx4QU1eAKi0x2coLEEnHkE2Jo/Gi/m1EwSk6WJ+CQiAvwpm2fkC49UPZGUjo25/ppiBsyabP729lw97mIWB61ktmZZRObrcv9oA37MJIHNdRc/UIdu5uBPi7Z6w5XKjWMuXVhXy5o410X/J6P5utOeZD9sICqSzEg9cHv6m60IWhpwM1wIUZRG/wRRe1pwf/Mv6GujFqYCX83P0Yy1z9d5yt2O+dZdAZn+o5tFyItlgOSfzFFB25OOZFaYDrlM1ueTV1xk5o02wpbigVvzrbigfKiHlMBjJ2RXCCGxsp1hx6ezNLt94rQDBwz6OQRnKbW1vEOXxws7YVDW+3Z+SjVPtDbUW0NBvwwBM+2aKD5t6C3UAjo18TkfUeZLzkvIYf3h2G4Gi+PS13TKBMtOP7P2N6471xLOkbC7GEj3nHYauhnqs0l05CCUAJeN//Rfi72azBDFcP/LZYHXMmSPRdvExSvRsLtbjRXSZhsbAHSzICN8nqi8pWI3ZJmFVDtPXH9I9mijTB+/QdzXfq0HjJwGK9kW0ynE61cF7CVj1MJLIrlGdu00pyvMRwgoMee34XPGwV031nc2K4Wa5Pzmo21ryvZLgKUewlXwgCkTfdZ+6gUJIG4KJHwu4ZSSMynzrGxknNR3KaTQueCWndaSlxAKfSUIJrvv4hhlaRSILCRb/dKPfjTbrcYlGa9uwkIMW5oMkhSZgT0RRNz3gqCHDJoSaXZvCWQ/97UZBiSIn4QocHkIjlpeFmx+6PkPa4KET
 85vYnsNk
 teUogP3qtVVrlZMo8DtobX92x+myI8wTTWhTjtxt/bzsun4Y1Dp7g+456vtjnfidrFaIZmCTawyxJkDAedEoI5EcoLt9VydJPia9Qvk+pLJniJe3hzy/up1AbisZZoniYO5c6BspAGSCrf0lBgybIjbk9essDdf2PW5+Mv0ntShyKQAZqHTTosgQoHn4kpwHMt28Gh9LkG8NlfBJYgBTau8WQs6rajqLDbJ5EIaByQYwjkl3Om+lRn3Wke2wBCb/khdKHjnMWW+jQNKAqhY3vy4tO7X7wqhueLKcibTXRbRZhKFqZpOk3keMz7tgoHz06pJARZ7dSAhKe9MEefyAtQC2h8vhpbTRghqXO43gYtCFXIgLqCNsmYdJ4lz7lD9g6NMaccxlm3giNcAH8DU5u6PKbhZbwPRE/6NBXh4VuweWRmpQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 07:34, Usama Arif wrote:
> migrate_vma_split_unmapped_folio() takes an extra folio reference because
> split_huge_pmd_address(..., true) drops one when it splits a PMD.
> 
> However, migrate_vma only holds mmap_lock for reading. A concurrent
> MADV_DONTNEED can clear the migration PMD, or split it into PTE migration
> entries, before the split helper takes the PMD lock. The helper then does
> nothing and leaves the extra reference behind. folio_split_unmapped()
> fails with -EAGAIN due to the unexpected reference, and the reference is
> never dropped, so the source THP is leaked.
> 
> If a THP is faulted in at the same address inside that window it is
> worse: freeze = true replaces the new folio's mappings with migration
> entries that nothing will ever remove, and drops a reference the caller
> never took.
> 
> An existing migration PMD is expanded into PTE migration entries even
> with freeze = false. Use that mode and remove the extra folio_get(). The
> reference already held by migration keeps the source folio alive whether
> or not its PMD migration entry still exists.
> 
> Reported-by: Zi Yan <ziy@nvidia.com>
> Closes: https://lore.kernel.org/all/DLZ48KMS7YG8.3BTM0UUU8CTU2@nvidia.com/
> Fixes: 4265d67e405a ("mm/migrate_device: add THP splitting during migration")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/migrate_device.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 9e19fadfa65c6..3286bb8a4b73e 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -920,12 +920,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>  	unsigned long flags;
>  	int ret = 0;
>  
> -	/*
> -	 * take a reference, since split_huge_pmd_address() with freeze = true
> -	 * drops a reference at the end.
> -	 */
> -	folio_get(folio);
> -	split_huge_pmd_address(migrate->vma, addr, true);
> +	split_huge_pmd_address(migrate->vma, addr, false);
>  	ret = folio_split_unmapped(folio, 0);
>  	if (ret)
>  		return ret;

Oh, that means we can remove the parameter from split_huge_pmd_address no? Best
as a cleanup patch once this is in for-next-fixes.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

