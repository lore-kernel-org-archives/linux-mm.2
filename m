Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C85E4CFD317
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DE266B0028; Mon, 24 Nov 2025 05:33:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6566B0029; Mon, 24 Nov 2025 05:33:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F28B6B002A; Mon, 24 Nov 2025 05:33:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C60D6B0028
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:33:58 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A687AB7A15
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:33:57 +0000 (UTC)
X-FDA: 84145140114.13.0DDA6EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0B5AF18000C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:33:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FGYHbnAn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763980436; a=rsa-sha256;
	cv=none;
	b=bZ8HkZdC1BU1fxau4/Z8Nt6x7Sb4VfibQ+rN9G6xmZzkgZo9/VWmL0SDzxF7FPYa7KYUe8
	Fua1lMoCIeWH643Qft2Zf/h+i2paovjB3HUTZosd1hOCF5ZXeCAWZYsgyPZQgDPShFtvjP
	9D2K0NhfuEDi5SJx7a5hcOkqeSDeVZM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FGYHbnAn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763980436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfL2ZG4Lf0ptXZXMj9LLGpxKI+Gze6cSqaMDuM0GPGU=;
	b=vFp0e+ZJaGfIDk2T9GCJ3e/aNZjqy2rSybrJMZKqwVxlIA1ez0sHmoZNY9Lm+LmupmnbtM
	H/Y/iWfT3a/y+O73nNFQ5iYLQOOeW1eoCFeDbeXsHqT/yTCcA67mq80PwsKQbA01cbEwHY
	X66K0ZWD3k4KZtM7nxKUYxfAF8+StLU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 54F736012A;
	Mon, 24 Nov 2025 10:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F53C4CEF1;
	Mon, 24 Nov 2025 10:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763980435;
	bh=9yc7x0NqELzfUZMjCX5AI1V6GWkCqxsRDtJfN0ylbjU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FGYHbnAntD/Scnr8pk77Bv9rQzRW5wcuSrEuoXLix2iy51nsKDW1u0vePbaqTB7qa
	 JI8G8qvKqDrj9UfD9hRUXFJUngeyXztymXaXmUfYNrqVZEpSsA2DZgL7S4ELTD2YIB
	 Dug8PyMOHOzmsBPbrXcvwda9TgheSHHHnjStW3ZO9Aicky/58YLWi+MiNKegvfa+Va
	 UDKBE999phJttg/sqB8Ug+G6zDIEThIGes4vxcZoGvxMfMobpDCViJuGuQr58LJwc8
	 uyzytistiLPgb2kMWVW/Fq7q6zzyCNbywj4ZBZlHHGjlLrg3UelGyed9Upyp4AGKgv
	 gG7BHcYrl3EAg==
Message-ID: <60d27f00-20ca-4a58-9d32-ffbe55f69a1d@kernel.org>
Date: Mon, 24 Nov 2025 11:33:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm/huge_memory: change folio_split_supported() to
 folio_check_splittable()
To: Barry Song <21cnbao@gmail.com>, Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-2-ziy@nvidia.com>
 <CAGsJ_4wyL9TZr141emBOBTKhN7oEJjeA7kFxhoBbi-cme-5tKg@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CAGsJ_4wyL9TZr141emBOBTKhN7oEJjeA7kFxhoBbi-cme-5tKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B5AF18000C
X-Stat-Signature: x96g9gft5uy3b7mryx7bm9hsxjer6mtx
X-HE-Tag: 1763980435-316669
X-HE-Meta: U2FsdGVkX1/4AalNf4HzsH3FnJC2r59nxdrZdFCcTg14rC/tTbKPsmRT2L8YJb57Jx+iWKQv/oHZygGq7gjGOR/Vteif+cwT6ooFi6G+41T337nbwivUDgT59xHNZCCHgck0qUJbBe0tAtZ7Q4BGeovE2tbbpXlHuKvu4L5HKxxwqrhTMDeM2CG2Ufgx+Om94Dhnt5QKqPz64Ni47/aza7QGjCD5qZnqQZ0eGChQyW24OBZJnt6oM6BqweZHPcob5C3iIbHmPrylIFDfJcdTCr33QQ+AyCc20NKVeXqk1sHxgE9hpRTqPNQQABcwdeLhDTYu83MSWQ4xtYJ1nYN4befQON/5tQDLFDJLujZhqIXUncjuuGn0R46Rax9v41aT2pupYPXFtRHMzOH/33c5seMnSiog+AvG52hY703xAtpHZfyJYI43xUFOlvLDIgXoEfO8J7BPRXKJN4+e8Z2zA/7xDC7HPV8xdOpYnzKSl926KuiWYK+GVA23a8PhMxtsskaBG/0tim5+PuERZFh6w07xXLszLuN1RGnA1SfVh6muRDXUu0K3ECLTg4Sm5vmON+qhWZy+J0P0MnxOfUplWO57KXBikhYPWLRUee+agXjehP092e4QFw6A9/djAL3KBTAn4k+5+KCniQ12mCRkn3BUUBxM5YfmwF7r2XuaPtrKciIJX2wKifI9aN4hrQvEhQYihhdetLPsQAuOFGRQQ2sbSk27+X01nLpzpJQJspiErq5iDW7Hi3x71KynS70cKlsUUU87Zjj3YTFvfi0m0Iye11rqnk8JmrRBg7b/saCt4/lSy9XSMY5XEJWS2Fd2L4/56hlohRGvffVcwn2CD7bnzfEIRmqwmX4x964XPZlOBPi7b4WiX4N881K0VbdcKUCzWjnBXDD3o36+bppMceFgfy5OkRSzL3C0eZLN/sZIDhErGyqUO68v7Unn8Z6EsYUixcNYPDfh0/2eFZB
 QA5pVr/R
 8Q6TXWp7B1bWK7jIDZ6xhiGWRdX5igrZSWJdkzr3YHkvqJfU55v9xOHT8dNhRWjpvVTbFBvDtQjhnd1Cr2a4PN2cV/qj/sFtm9uJ9IffOr/boKiBOAHNxsGdCO2QXNFRCGonE6LRrOrZhFOsh2QR1WW8TDNBsYrtPZv3k/SgQEgWQ+YXZ5q4O/lv/Z3igv3oYBmlOZ/QfpicNGjN4tdwNguPO/f8DjjtARiPIUo3HpSF1Lqj/vQQpNrgv3ftuzNbFeHDv29vSPoRHf4mYLIjs6SjbEgCzow4YZmHUTrQe8QPotuDwzaamWE07XaCCdN4a5CmVsftZI8bpTRi8xa0dWz7GcUfRSjm/pjEei9COLdNfd6V+IDDddRGpaCcGehFOkR+LFd11SrQ7Y8FJtrNMWnyvvYTdgnHEnZUJM1k0bmT0MtI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/23/25 19:38, Barry Song wrote:
> Hi Zi Yan,
> 
> Thanks for the nice cleanup.
> 
> On Sat, Nov 22, 2025 at 10:55 AM Zi Yan <ziy@nvidia.com> wrote:
>>
>> folio_split_supported() used in try_folio_split_to_order() requires
>> folio->mapping to be non NULL, but current try_folio_split_to_order() does
>> not check it. There is no issue in the current code, since
>> try_folio_split_to_order() is only used in truncate_inode_partial_folio(),
>> where folio->mapping is not NULL.
>>
>> To prevent future misuse, move folio->mapping NULL check (i.e., folio is
>> truncated) into folio_split_supported(). Since folio->mapping NULL check
>> returns -EBUSY and folio_split_supported() == false means -EINVAL, change
>> folio_split_supported() return type from bool to int and return error
>> numbers accordingly. Rename folio_split_supported() to
>> folio_check_splittable() to match the return type change.
>>
>> While at it, move is_huge_zero_folio() check and folio_test_writeback()
>> check into folio_check_splittable() and add kernel-doc.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   include/linux/huge_mm.h | 10 ++++--
>>   mm/huge_memory.c        | 74 +++++++++++++++++++++++++----------------
>>   2 files changed, 53 insertions(+), 31 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 1d439de1ca2c..97686fb46e30 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -375,8 +375,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
>>   int folio_split_unmapped(struct folio *folio, unsigned int new_order);
>>   int min_order_for_split(struct folio *folio);
>>   int split_folio_to_list(struct folio *folio, struct list_head *list);
>> -bool folio_split_supported(struct folio *folio, unsigned int new_order,
>> -               enum split_type split_type, bool warns);
>> +int folio_check_splittable(struct folio *folio, unsigned int new_order,
>> +                          enum split_type split_type, bool warns);
> 
> 
> It feels a bit odd to have a warns parameter here, especially given that it's
> a bool. I understand that in one case we're only checking whether a split is
> possible, without actually performing it. In the other case, we are performing
> the split, so we must confirm it's valid — otherwise it's a bug.
> 
> Could we rename split_type to something more like gfp_flags, where we have
> variants such as __GFP_NOWARN or something similar? That would make the code
> much more readable.

Could we get rid of the "warns" parameter and simply always do a 
pr_warn_once()?

As an alternative, simply move the warning to the single caller

VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");

-- 
Cheers

David

