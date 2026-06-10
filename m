Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E863CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 08:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4EDB6B0005; Wed, 10 Jun 2026 04:02:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25D56B0088; Wed, 10 Jun 2026 04:02:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963AD6B008A; Wed, 10 Jun 2026 04:02:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 821436B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:02:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD67D408FF
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:02:48 +0000 (UTC)
X-FDA: 84863261616.13.4E4E138
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7F18CC0009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:02:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sgu4KDlx;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781078566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gtYxj6a7fAD7Z6IKLgRqzmm5d2LG5rVj+H+R61HoGo=;
	b=7MD4cohFAxD1yzVmYAYjGuLX7w8ctUFxqOVI6VosXy6bZxlw+GRmtzSxj0JEyfFmGR5U4p
	IfWlrQD7Mcclg8ksJ5PhIzOVQzVm4o+sqsbutEszkuWIVfNlG7r1gLXz2lYQMGvxyLbA/o
	vF/5G+vZeJHr1hfEDH+za1Nh6F5O7OE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sgu4KDlx;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781078566;
	b=3tNjzmaDhmleO1GODap3Imd+95y/r4T6I8O1orDDxDRBCnkZDAQkUG1bd98730AuSgZYXA
	WwOvrA8jbZQyp/E2iNiSpzL9oYF65AKBRFYNzlVHMNqFAi5KXxB+8RPx8eO+gaMk23wbl8
	hdPKa1DsXdj8V6QxxNeSpr7DzEq702Q=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781078561; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8gtYxj6a7fAD7Z6IKLgRqzmm5d2LG5rVj+H+R61HoGo=;
	b=sgu4KDlxLm6n/76IA0vrhWEGpwCPD4YhYS/pPJ6vTlk7ncXej2QZvxb8faNJz8E642gSSm8p/wb/nVuXlM74ZyV2dUaA1IMKgTxmeH+ksnSM/dM5Tkn/fNvQHnQ+TjYr5hKJdhL9dJYCIVZpFUlwVcvFyohjYMfjRoY1pnxQV1M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X4Zwsje_1781078557;
Received: from 30.74.144.110(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4Zwsje_1781078557 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Jun 2026 16:02:38 +0800
Message-ID: <92ed35ad-4f8c-43d2-b72d-b46f07533a3a@linux.alibaba.com>
Date: Wed, 10 Jun 2026 16:02:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap PTE
 accounting
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: david@kernel.org, ljs@kernel.org, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260609120443.71864-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260609120443.71864-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7F18CC0009
X-Stat-Signature: xg31aem66te7eng36bthm6p9birt3mtx
X-Rspam-User: 
X-HE-Tag: 1781078565-384583
X-HE-Meta: U2FsdGVkX1+XtftazSp9QOR9ylgvZsRHA4kxZIt9rOFAWVU/vtCo4MEASTqCg4uT7UfYeNUVUvj04THhgYoMwPYaxvZNmOd7Kd2wb0n3QJWHIfKW3p6/E1RocVEx5wbdnf4YWqawg4HM/URpSretXUtiFY3T4lY5IsBCVeQdaLq/11ietMVpgKmdp7gMf7cxZKPD5qjoxsJIkchOztu3bsfaCsugq/Pu9ihfjGN7x7ykcpetYY4GPGBCI9eTl8wZudDIsETeF2YVlcyrEDv1Leg9ZnbehtvEti8IgnXqTo8eP+G8wkVofOMiex5vGhVYbDxPByKljFUZKA7Tk1c2a5jwl53w6hyDESRI+Qpfy5+oe0yVXQMNZO5ZFiMQvF6FSrM6o13RVTw/WuSQDNqLBSz5wn6MM4buFpyJ/qsn3NDL2C1hUpsauv0vcD8CqLkcd1uV2MPXAf7jew5+E7D87nB9gMWAXFIRa5mGCwDnYNPloeKh8zevhTnDZH97B66NgkJmtCsVMq71Xmv53eMe8RQSgX4FG+glwLTJNWE+NlaSYVJNKybaChNwMsQJf4JJMybyxAQcpWCADaJqS+zT3YcSDLSwUXbxMo6RJ1kj6lU6gG64mtiKcxUbZfQQI6h3DXLJCVwIiNyh7GOtlJz/zCWfkZMary1uAgi6dnfpIqGBvjT8uUhMSZ7Mw8p6FtbOy8oCFI/D0NKyVe6KEE3QbV0ja056qDlRA6KYwEU6DvwvxCWFYYmUMCH5sYQ/nPysrC9smJYgXww6RP0jzK+gui8u8K7wWEEFWmErMJ4bPGf/VwXlWC/l5l2NXUbom+SoCZFnkfiaLIc98KDegRL9jXoV675HfQP/6+Y1NZbA9MB+15iTm+IoDMk6YDIDeB3y3wZxaHhob1NqCbIIr6YB9TtOYtlBHI99u7UQlv9E694ZXqtzo7Ah9ZXWRV2zIFZoZp0Yw5qzSKi86mGRpHU
 mMKEO5IS
 +qOPBPZE5r66OpvE41brzuc9fYB8FJ1LX/6RC8girEf1IoXt8VZsMWOoDbtInomqT9Pm/IrHL4Tzmak8koZHaadrJsIyjaDsSplvqVpiarvF5yVKI3AlYrn95LGDfmyB3htfIELPqcL0aLOOnbEKbqoN/a0Z2u8eeM8LZwlPrxjDn4AlCyaorcW9f7VYpF8CMOR3Rs2Wf9PbBxxHcKG/kOI4fJRYGcgrVmonS9dHcN63FDYV7GsZ16qHEwXa75okgv6gyWYUCgg9pyHq+jZVW8K00W3FDUc6vINYliT9BbFK0f4wQlVhKgPdBsmJmsxV0HDROv3hox+P/wFKNp8lNEHlDEzjnt/odi7EyiNJXnRiyxBU1y45Mybg2oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/9/26 8:04 PM, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> mthp_collapse() uses mthp_present_ptes to decide whether a range has
> enough occupied PTEs to try collapse. Swap PTEs accepted by
> collapse_scan_pmd() are counted in unmapped, but are not represented in
> mthp_present_ptes.
> 
> When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_none
> so the scan can cover the whole PMD and build the bitmap. mthp_collapse()
> then checks the PMD-order candidate using the bitmap.
> 
> With max_ptes_none set to 0, a range with 511 present PTEs and one swap
> PTE no longer reaches collapse_huge_page(), even though PMD collapse can
> handle swap PTEs up to max_ptes_swap.
> 
> Account unmapped PTEs only for PMD order. PMD collapse supports swap PTEs
> through max_ptes_swap, while lower-order mTHP collapse does not currently
> support non-present PTEs. Keep non-present PTEs out of the lower-order
> eligibility check.
> 
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

LGTM. Feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

> Sent separately, as discussed in [1], to spell out the PMD-order swap PTE
> case. Patch [2] is still only in mm-unstable, so no Fixes: tag.
> 
> [1] https://lore.kernel.org/linux-mm/CAA1CXcD7WAiA1b9GTLAuNZ+kHaFx0SzZwpBkqAZ=s+RHsTUaow@mail.gmail.com/
> [2] https://lore.kernel.org/linux-mm/20260605161422.213817-12-npache@redhat.com/
> 
>   mm/khugepaged.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b12187709f6d..617bca76db49 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1508,6 +1508,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>   		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
>   						      offset + nr_ptes);
>   
> +		/*
> +		 * Swap PTEs accepted during the scan are counted in @unmapped,
> +		 * not in the present-PTE bitmap. Account them for the PMD-order
> +		 * candidate.
> +		 */
> +		if (is_pmd_order(order))
> +			nr_occupied_ptes += unmapped;
> +
>   		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>   			enum scan_result ret;
>   


