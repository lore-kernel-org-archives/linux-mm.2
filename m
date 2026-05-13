Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBDC9CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6406B008C; Wed, 13 May 2026 05:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2974E6B0092; Wed, 13 May 2026 05:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185F76B0093; Wed, 13 May 2026 05:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 044796B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:12:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A38BB1C1532
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:12:57 +0000 (UTC)
X-FDA: 84761831994.19.02D6E1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D0AB440007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:12:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pBCPO+Ea;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778663576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVlD0bwql/Ht1MzUNmb7fov8/FJIhq23eqGblH6/098=;
	b=AA1Q/yx6b6TbIYCsovDO66Jk/RlWHFiw5XQWbj1qAn085zxYzSRARxpxHsTV44pQMo8eO3
	0XH7Z15dzTuq/czlk9NwH0lHDAr+YY7Zm8aZUdsIdNVTTQNHJq/Nriu9+IAbcxWw2UxYqv
	mFf1XiakERzcosNEI4lB4eZaOutpb+s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778663576; a=rsa-sha256;
	cv=none;
	b=ojVV2FA5YsHom91l+YapdEoucs9KgrncMre86xaf/DcogIyZFPOQWvpePniiv6si1kuH+W
	mANnrtcgK+CvF2rLS1iIImoG4wrdyYMY3moBtdLOoueYCMCx5DMdmw/JykvUJhWIj4EpYf
	xftwPg5h2Ack0kPEgb702sIFRT9Ef8A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pBCPO+Ea;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DF5B438A0;
	Wed, 13 May 2026 09:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD842C2BCB7;
	Wed, 13 May 2026 09:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778663574;
	bh=qRabOF++bZmrieB5yRF9VHZpIrCCwhEvvQeJnJbmNtI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pBCPO+EaE8pJc/JDvuaqBXD7hV4smqSfKcHEgNUqGb4cGuGTDXOUFHiLGZbzd6C83
	 LBKayyvNHahEwKwg2tbuBOH6Mgg6i0ppemAUFB4NfHrjLIB2F6gup/g/K7UJl15LWa
	 jWQ6TkkjZHIZ+eQP9tFvmkVx4BRJumPBSOo6CXxX6U5PSZIJM6SYQStwSmCLr/M8NW
	 stDGSvDezseuddvtIn3nEO2gjrQhfVUS4ZOIjY+tpI6sPGyaAPCKRNMQjQ+9Ea1elR
	 NsjKBen6Y0JiijVZdJkyRt11Pq1TAM70H5IKgSkqt9ED849e3XyyNRG7BtxWmEsGtl
	 AnfwkT6FHnm9A==
Message-ID: <4af19eda-c29c-4302-92d5-c0915267fc0c@kernel.org>
Date: Wed, 13 May 2026 11:12:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: introduce a new page type for page pool in page
 type
Content-Language: en-US
To: Dragos Tatulea <dtatulea@nvidia.com>, Byungchul Park <byungchul@sk.com>,
 linux-mm@kvack.org, akpm@linux-foundation.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com
References: <20260224051347.19621-1-byungchul@sk.com>
 <982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D0AB440007
X-Rspamd-Server: rspam04
X-Stat-Signature: 31gw5i9ca8bzkkx4jz1xjuarx1ofx7dr
X-HE-Tag: 1778663575-279573
X-HE-Meta: U2FsdGVkX18lCfnmG1JcPPJ6rgqGEfGfOuPWXU97nm/FjhR6f8TgNTKnrF+T9/YFaRqG7jS7kJufXBhTblS3jxYvHvqC8SMfAAHWZihM6npUE01PjTDBeq2jpMOgKrGIoeLVvl1Q4R8mZ/pOKdqD2u2lDowT3y+y1FldQfFcQdq9wrPXWL7s1cxHp0dNrQO/VX6jvZyapCkkvF+1XZWvHWxqwhz/vBi8YVUX/GuOk25KP5umlHdl0JcYU79HcOxYZHA85PBeyFdLfpBdAlM9wQ9ECFtauevWPhp+U8/DyNFiDTdQphFT5BhL/KDba7VdAYUtugHFW5CBzi3TGqCSg1DMWa//xuWQlU3+X0GsMgzJ2ZTDYeyhB+j6lSzR2Qy09N4Nqb255U/eqjRLLlgGFl6xLw3qhPyDXc7w22yvZe3H27xyzaCAhxw4yL5k/n3aR+/KklEBfnSXzD+GpDkQ+coq40tJggr28Es8Xq6Wa8DWWlv44WTqyHFlWeI4N3cOHQveu32KOt2FNUqmFQmrV9sjfPt78ogdHzyoyfFnn4KSOZWjGZ4Y72aOmXdCNcagY2DvGIZ7feRxF+pnHNCz4O/zAeyoiMXAPLVT2wLGwNKzgoBCk76jk3rJfsPmqgaK1fqllFYoTsHfiqFFj+bXY4mPT2DjGduxwigaPHBigusGVU80iDpfzIuHFjAFGCpWmTupw0EbweYsjcGtiMud/IJxufL2gr65+pmOBOLbybspnPQn2byyUOBJWVnS0ExI3LoRCWlTqNGql5RAMp1+tpgsvb1jsjdj7vI1if1EYPKi5tGqouz9nsWnStFgggnNPGWqmyAZitrHW/YpONwe0SNXG4peHF9vyswz9oyHX80++JMY1DCH0pOnLZgnPXYRXXPdLHDgn8tpgCrkSVXecMUASBvDDNiRNJhwMkKv6hN9Rsa7R5ZsbbnQithdWh/KNRyHxq0o28jNOg886ol
 AzgSdHTq
 5CE/HnWR1NsW0FjHn2LfKFdl2QO56DpVsG+xCy5DlOybOzDSlK1yRxQll1NM5xuCSU/3HTe35Cf6cBBkI1LxfpLQsWNfDgHnE224jJkHukQ95JeUlpOVMM+ulf60F2jnmamIn7724p4A8QGQH/r7oNvupqEfWIdnGQig5bxH6QyW2n5ijTWCooFDee5n0FxctuOwLvmdCnKien4DpllZXT0NhDO3Zx6ESqxoio2j13TEcIWVCmNzoSN/gl0wmhw3fKWDcG/B1a/SK9VNFyeguxQ51JvZ06jYD6zS6wDIgi+0avYcEECcmWy4oToh/bAb8UHdu+hVNp1vOd5N0Cl9WTmLKnsWIsN3HoyZuToo2u6+UgjqqsFMxdVJ+q310W3ysLrMwkpysQ5dfTYi7nNw4uPlLUM/11JyeSocm0UUvQegHozVEBiEqQ3MgU3RhLKyhqGu6IK5tuXyQjBUczbmq4Q9ZngCqSm1q17ke1yGR0zBRywZaGp5ZyOt2835DJDicAvNUYYu/GdwBccjPD4+dBkw4ItNfZ9CYcvaW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 11:00, Dragos Tatulea wrote:
> 
> 
> On 24.02.26 06:13, Byungchul Park wrote:
>> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
>> determine if a page belongs to a page pool.  However, with the planned
>> removal of @pp_magic, we should instead leverage the page_type in struct
>> page, such as PGTY_netpp, for this purpose.
>> 
>> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
>> and __ClearPageNetpp() instead, and remove the existing APIs accessing
>> @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
>> netmem_clear_pp_magic().
>> 
>> Plus, add @page_type to struct net_iov at the same offset as struct page
>> so as to use the page_type APIs for struct net_iov as well.  While at it,
>> reorder @type and @owner in struct net_iov to avoid a hole and
>> increasing the struct size.
>> 
>> This work was inspired by the following link:
>> 
>>   https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
>> 
>> While at it, move the sanity check for page pool to on the free path.
>> 
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: Byungchul Park <byungchul@sk.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: Vlastimil Babka <vbabka@suse.cz>
>> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
> 
> Seems like this patch broke tcp_mmap because
> validate_page_before_insert() returns -EINVAL due
> to a page having a type. Here's the full flow:
> 
> getsockopt(TCP_ZEROCOPY_RECEIVE) returns -EINVAL because of the
> below flow in the kernel:
> 
> tcp_zerocopy_receive()
> -> tcp_zerocopy_vm_insert_batch()
>   -> vm_insert_pages()
>     -> insert_pages()
>       -> insert_page_in_batch_locked()
>         -> validate_page_before_insert() returns -EINVAL
>            because page_has_type(page) is now true.
> 
> The patch below fixes the issue. But is this a valid fix?

Hmm the check traces back to commit 0ee930e6cafa0 "mm/memory.c: prevent
mapping typed pages to userspace"

> Pages which use page_type must never be mapped to userspace as it would
> destroy their page type.  Add an explicit check for this instead of
> assuming that kernel drivers always get this right.

So uh, this doesn't look good I think.

> diff --git a/mm/memory.c b/mm/memory.c
> index ea6568571131..4cb12673f450 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2326,7 +2326,7 @@ static int validate_page_before_insert(struct vm_area_struct *vma,
>                         return -EINVAL;
>                 return 0;
>         }
> -       if (folio_test_anon(folio) || page_has_type(page))
> +       if (folio_test_anon(folio) || (page_has_type(page) && !PageNetpp(page)))
>                 return -EINVAL;
>         flush_dcache_folio(folio);
>         return 0;
> 
> Thanks,
> Dragos
> 
> 


