Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4CAAEC1EBE
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 14:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34FD66B0089; Thu,  5 Feb 2026 09:09:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE546B008A; Thu,  5 Feb 2026 09:09:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B4786B0092; Thu,  5 Feb 2026 09:09:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07F636B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:09:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA56313B223
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 14:09:28 +0000 (UTC)
X-FDA: 84410585616.06.8F3480A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E3B6040004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 14:09:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sCGRM+PR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770300567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3c2H5tjAI/VCTSIfVatGbJskpc3SS3EmhlyBnSCSb5k=;
	b=CfK8B6JVQPXDCwUkJ05XsQeG2spKhEtbudOnEfPoziZvx/CYyODHJ6rbt8ztHrFVT0fTUs
	agFk3B75lxPza1czsJHAJYnWnTEUxQ3NfQCCSGAh4Tiw9IKatHQQ6gI960D3FXf+AVxMLu
	nXUUJK4DvLbpu9fw96R+KwvPBXhlNUU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770300567; a=rsa-sha256;
	cv=none;
	b=Z13N6MxSLCSEH+t7rHVjZYT1aii9YCQGiuRkCBVYFrG1g7JTtIGLZIHwgnJJlrW0MiwLjw
	ysq+ChlAfdHsRXZyPbIvG3/y+51UIX+rgEVH9c11NSoTCduZxcs471F5x60GFHy1EIBZ3t
	N0YT6drpPjXc4umpoW8sLK/Gl5C07L8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sCGRM+PR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E11B144216;
	Thu,  5 Feb 2026 14:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F349C4CEF7;
	Thu,  5 Feb 2026 14:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770300565;
	bh=0kbSVa7phW9AqGFlXTnauWNQcCHubPrgNwvp7uwjvu8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sCGRM+PRyGgOyssVyvdukY1De8h4831Ciolpqds8PUVcS1ysLBcjh7HmmnfiahlQR
	 UEXl9gsl4cXbGZt7Pl9PPyfqHFngUDeiC96ASVObz5Wm3SFr9Vj870kosRSNYWwg6W
	 3v/P6rUMXfnQiJmBrEVHMshasXlyXWezvOHZAPyfQU0UV8qxGguqtLa+rw6j8PEZjb
	 crNbWr2uHHmV3BAJjRCL4br0SKX5mQf33giCaBsVhYi6Q4BiAldqsMxjZM01v+Yvok
	 HGbiIw+EZRp7gBs6rDtcPQpTSvRfzNHJWuFPHPngRj6oChfnL7YZv7vBEEE4VgTvHN
	 zsskoDr8poN5Q==
Message-ID: <6e182cb7-6f32-41c0-ba86-520728b161c7@kernel.org>
Date: Thu, 5 Feb 2026 15:09:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 07/17] mm: Rework compound_head() for power-of-2
 sizeof(struct page)
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-8-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202155634.650837-8-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E3B6040004
X-Stat-Signature: e1uaetgfutcoxbc4bcmjnkfkr8k418sr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770300566-329877
X-HE-Meta: U2FsdGVkX1/+oxAw8NukURN+4hQokfJRQlMAKxUZ5X/Zm3aRG094Xh3rTCEiFjVoYH/1Fyoh4sKXTdxSsRL1YGGq777hfT1uVWol8w9Hzt5h3zSjIA5DNeo9HSaWtrg3xSeyJgZzYjEmS37JnFwgDGl2xVm6/uh1y2fxHhmswqsKBRc1h/UY9lk6zbkhxOwGtN8Phie8icsin8s7869Z7D/t18GGtdVHXZuz6jR0FCraEx0qlU3KUKi0IT3fiKlw+bbHQ2xQdg3PwAaPGcmclJXseEznVRdMBrKVJSe78Cy4B7MpFc4k4eej3KjncRJGM43xLr7QctsT15jkDjLDk4UUUad+c2gQ9k30Z83gdMdn/ujEJ5sLtJFTHrQ6J09uC5xAVdRwLIUh4OOsOi+apxCjEjL9EG86MO1oQfVdjf3MNlMC5Y5sogSaw+pk9NGy5e5p0u6fWDMwOIktagbiMvkQ68W5h38lIbjlny9u9tKZod1Nzjnn6S272kxc5sk3tbiNp+O/kTyR2fMEpWsU6xSguI/zLUazP2CcPWfK7npxEuLqlpfy6SurUwjJCFBgs9sya3Vue2QoejFwFq9ykiy5jqck/3uri2p0JoLWiiFNCVgtOsbKt6zNdANpaXbtbgVAYe8x9SBKVAyfiWLdlYgJ9FdeKBCwO5r4mCYZDrc2fzLBmPR0uap4nyKEejwUd2MiDKj2rKNqybLtriKPKCAM9/cF0xl3IBr13ekwN9gjztq7itAmuNvDAraEAPBXy+L/z4QE2xB63/zheNyFRwYF3WnS/jxHzLVnz1E5xqxTWdczARiXPXDLIS+RqM28j6CNNcaj5dZ1KWqy/ZTLm6QPgNgT8MzAkahy0g5HBQ3Go3gTopynYBAx9hc1weSAHJFE0kDXpH8nbcy2R2ccXX6vpZ8MudwGAbWrghJyuuIATfeCIwtjZIMnP/iP6tmVUgHn5t/SFpL4TWFs14r
 iT+3i/qv
 UyqD36WjPTL6fIqZVG36G10iGx/Un2HMyT9edOxWijBJ3EWlEQY2Xai4tsfteONzVdor2l5fL1pWV/BWEHrK8ZdDqMyYHGAE9Qbm/XHEIXeWRTtuu7Z7jTujNbGm20RT+wp1yrB87HjbUGEx8LUT+GnFRj5/X1tlv+awLplM+GL7orxOd/Id0Tz58r71TyouZOVqDD6SMDSorP5DEe6oH3jxP6jCAhHTqc0OYaNmzhe28O6wvlqDnntEVrPDhX0Si05QIKYBezD++qTH9CyYv73fyqi1zZ8BwY2YItlRZpESwqUUluX1qN52yyf5q7L5GwDpOID/Pjeccb5pJJSmSgbOed4yTWfrU8YVP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> For tail pages, the kernel uses the 'compound_info' field to get to the
> head page. The bit 0 of the field indicates whether the page is a
> tail page, and if set, the remaining bits represent a pointer to the
> head page.
> 
> For cases when size of struct page is power-of-2, change the encoding of
> compound_info to store a mask that can be applied to the virtual address
> of the tail page in order to access the head page. It is possible
> because struct page of the head page is naturally aligned with regards
> to order of the page.
> 
> The significant impact of this modification is that all tail pages of
> the same order will now have identical 'compound_info', regardless of
> the compound page they are associated with. This paves the way for
> eliminating fake heads.
> 
> The HugeTLB Vmemmap Optimization (HVO) creates fake heads and it is only
> applied when the sizeof(struct page) is power-of-2. Having identical
> tail pages allows the same page to be mapped into the vmemmap of all
> pages, maintaining memory savings without fake heads.
> 
> If sizeof(struct page) is not power-of-2, there is no functional
> changes.
> 
> Limit mask usage to HugeTLB vmemmap optimization (HVO) where it makes
> a difference. The approach with mask would work in the wider set of
> conditions, but it requires validating that struct pages are naturally
> aligned for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

[...]

>   	struct folio *foliop;
>   	int loops = 5;
>   
> @@ -1247,8 +1247,8 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
>   again:
>   	memset(&ps->folio_snapshot, 0, sizeof(struct folio));
>   	memcpy(&ps->page_snapshot, page, sizeof(*page));
> -	head = ps->page_snapshot.compound_info;
> -	if ((head & 1) == 0) {
> +	info = ps->page_snapshot.compound_info;
> +	if (!(info & 1)) {
>   		ps->idx = 0;
>   		foliop = (struct folio *)&ps->page_snapshot;
>   		if (!folio_test_large(foliop)) {
> @@ -1259,7 +1259,15 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
>   		}
>   		foliop = (struct folio *)page;
>   	} else {
> -		foliop = (struct folio *)(head - 1);
> +		/* See compound_head() */
> +		if (compound_info_has_mask()) {
> +			unsigned long p = (unsigned long)page;
> +
> +			foliop = (struct folio *)(p & info);

IIUC, we don't care about clearing bit0 before the & as the page pointer 
shouldn't have set it in the first page.

Pretty neat

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

