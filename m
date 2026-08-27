Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D0FC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D756B008C; Thu, 27 Aug 2026 12:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE216B0092; Thu, 27 Aug 2026 12:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AE076B00A0; Thu, 27 Aug 2026 12:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1351A6B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:36:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85FC7A0109
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:36:30 +0000 (UTC)
X-FDA: 85147602540.17.E21E012
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C679D4000D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:36:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i80nmpSi;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787848588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fe6QylMKCeuh3KNFlGrIMs2kCUl+qJA+OBCFl1uufjU=;
	b=CnNaS/sjBS7We2Nij2aYz6bBDziiGRDDe3Y7C8dwhlpErJL+lYeaUlqyaASWa7ScD75sMJ
	B6eqJ1QCjEd6WO7e5WckgnFEZoAtgdC5NQz4pDYGWnUKjt9AphqQQrfmOjlQGkSRUvknH3
	hyJSTuhcgAOhnJS3dwsAvJqdD2ZpPpg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i80nmpSi;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787848588;
	b=oZfKN1SQS7zCDdImGnccRlbAp1b5pEvLflt2GJiAoucBKm41rOfgbqrtGWtrDKUTRc2jBs
	AhjROpbGPfuwGvtl+PfFlxezgxVpyoXAzHAwHhZNuz4X/2juCDfTegJ3YWBL6GfvQ+h7pe
	INwQgJzc/zxMmkaGpPB3XgvXf/UAeSQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47D12600D2;
	Thu, 27 Aug 2026 16:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858601F000E9;
	Thu, 27 Aug 2026 16:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787848588;
	bh=fe6QylMKCeuh3KNFlGrIMs2kCUl+qJA+OBCFl1uufjU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i80nmpSixq3jjLPjVr8WqKUnb5AtiN0HydEGFuk133+04LtGqHyuWZZfqRQaNIfbr
	 7Y6jDkXgDIm2APXKVZ6UYweg2iUrpODAVe3goviZyuz/F41FF3BZFWGxVhQa2+S3R6
	 1aPjHTbqKGN+7XI/EiHL8roZ8H9b/EhEJKzsqOqZZNJ+DJ9kUfvtBAFXMZSCaDJXie
	 zRm0nWDOEemrFnqEkueh9sofGU0tIc7Kml5m8Rszl33FXqkWWRpzyxdx5oDKmNzd3r
	 aXomkPI7yKidgUD3z6DCrBSFO5iG5EoylHrWQPcraaesraBnC3YQdoCCOJetdlg/nP
	 Gk3aHja2yb97A==
Message-ID: <acdfa561-0690-4c78-bc50-92d308f4dca0@kernel.org>
Date: Thu, 27 Aug 2026 18:36:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/18] mm/huge_memory: move anon_vma and filemap
 management into split helpers
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-9-9b43f5163238@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260821-swap-thp-cleanup-v3-9-9b43f5163238@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kem3ibn7jkqfisuxtzhfpuswiqjjhpnk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C679D4000D
X-Rspam-User: 
X-HE-Tag: 1787848588-742176
X-HE-Meta: U2FsdGVkX1+BT1ZPJ2w3vfPyptiLige24vtCqrKW/0HAO8KRYfqquhj5L2IOnTudgjGLwv/3dNEUbITyW24UlsDv1YGHjSDcWgU+yYpZHxe66v8JHmenM5A5NcKQp+OI1lFyNd6yFTeKi0PO1OzBfGBtC4Angbfq9DA476iiB1KjxViut2gsQ97dtWrJV2L/WT61WyecEoyIdBi8EFBX9pBn/ZFY+GvK0I9A6Ac6sJnad9S7jN2MBP+B+YQpuz3uLTCh2gbSVK+PF1dLFAuwVeB7T/SmQ35A/kaPLYMw//geV2qZssxYA4LmXPDJ0JoCByUaEoyS1/QPgERCaE86D+WWrU+XjXZYG9oZnO71uEaFKBFI6XOHZwZih6qyaSrsKAZZRPFVL1SpfdVUKauLqc2phdu6XoKGoNnC/R8Px/q/efMMAEH5ox5xSJymS+qRL53F9bphNzruWnu02h/50mZzGRJ1IDKqtGiOcoXN675cLT/ivMsRLvtfFt6/vPrvfQmJL2QZ5IB3AeeYCRsYnhMaJ7NugPErRdzLLh7xrP9AcCRg+R6QImjblyD5C57zQt374rPKx4Fw+99jvCKKNF8oo6N0vs96liqCQLluSKJG9fMNYlB2YTT2eI+VYOeB7qMO4WBtCJXI2hQGj+EaRMwdfmrEAquzmBwckAIz4dlqs5WqK4ZjGSizJpA40iuv39Rn7X7899LhYWf5EkOXpoP2leArnL3Z4bF6mPyqS25jjOIR0ozSOed9lrJOhFWkfpN0VTIW3nIGpcl/iTjPK8wlqk/Zen6IStqK8N/O/RCXJcM5jdHIMX8GLDafnFrPg1FlcNxjdF2lh7d0heGkuIf+WYaZQWlLZglkYlnst+Xen8J7SMYXQz/brhBvFatQ727PjpyeER4Cff3Y7XLPWmRw1p9JZsY2MTuqdHAP8ForhzxxiBCBVCD2p0R0SkPWZj/0iR3PnZHlx/GT8XX
 ZSxXECPX
 Zk/cNbUHxUdIJgTTuAnDD7PY7bu9dt5tq/tEEYfczNibfyQ9Cs9oz+2ZQI/TcIuFxtuub9UJtV55azYz3FvQnxtqL+YIMMsanwxEiLjiVCpvowwCzMNJw7s+IEbTwjLev21TT9YE2DCywrHhWelqulPt3n0D2noZGoRC5VAUBn6i5XbeyYxAWEyRYwNe1YI1akWXCuIN36w965xrp/FCqcqXG5pgIIfxvXLC6sApgYpdmYcgvIMCcsoyZDoi3lAc9t0QtbMCOv0/Z481PArsKH8iOKATeW31DkwyUEV5GGAREwrOTYlb+Ni+wk5M9YUg1YnjvPM362sFB6SvhL/B1Xj+VK3idsANBRYqS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Only anon split needs vma info, and only file split needs the filemap
> handling. Move the related code into separate helpers so they are
> genuinely more self-contained.

This patch seems to do more than that, like relocating the
folio_expected_ref_count check (and duplicating it, which is not so nice).

> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

[...]

> -	/*
> -	 * Racy check if we can split the page, before unmap_folio() will
> -	 * split PMDs
> -	 */
> -	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
> -		ret = -EAGAIN;
> -		goto out_unlock;
> -	}
> -
> -	if (!is_anon) {
> -		ret = __folio_split_unmap_and_freeze_file(folio, new_order, split_at, &xas, mapping,
> -							  true, list, split_type);
> -	} else {
> +	if (is_anon)
>  		ret = __folio_split_unmap_and_freeze_anon(folio, new_order, split_at, true,
>  							  true, list, split_type);
> -	}

Inverting the conditional seems to produce unnecessary noise in this patch.



-- 
Cheers,

David

