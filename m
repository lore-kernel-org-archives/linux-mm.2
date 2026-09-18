Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B78DC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87BC96B009B; Fri, 18 Sep 2026 09:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C386B009D; Fri, 18 Sep 2026 09:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7429C6B009E; Fri, 18 Sep 2026 09:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4945A6B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:48:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D602A406D8
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:47:59 +0000 (UTC)
X-FDA: 85227011478.14.9F8B93D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0D2F8C0009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:47:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QUpaQHft;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QUpaQHft;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739278;
	b=nsR0cgH8RkQt6AQTuKJlVcfxo0gaONt5r4xxGsqCyNxGDG0eIFweUDmJw3cndZJS62sKsj
	pb8AXRLEID2D6BLCa1dHXycubWQVfYKr0Zwh0Cm1dldl2m7+34nVzUbesnaDmJcL1iJSLS
	bB/FmbtGaeb+bys8hpw2y0Ng+5t7rwM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yILN2EwZ/0v4lXtVvce4s3I7nOORRQ+NlRxjxqFOxvI=;
	b=4N5WMrxr6Q03pDYOx5u3WRLLbMpIvdCgI1u4uO9RZWug88Fj2nsy6sWTeocV5ixzP3PCsB
	7k/yGu2ON3ml0H/oqraV7hJcyJglYFs05vyKW2AByA0LR9d5AaXRiNtgUWqwMSJWBlgmUL
	9NT3rzIFjTQ2vqoTnwUJs5Vfm4iOesU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A66A407E1;
	Fri, 18 Sep 2026 13:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98461F000FF;
	Fri, 18 Sep 2026 13:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789739277;
	bh=yILN2EwZ/0v4lXtVvce4s3I7nOORRQ+NlRxjxqFOxvI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QUpaQHftxoWl/jsyC1b4ijl1sL7hKSWsQ3JDH7yrKcgvtu7Jubp2xWLpClMnlcUZW
	 3Un8QvcLUbu+0apj3clB7R0dLGPQoN/QVkB6QzbUJiVM5eI0LscJ22SXtgBUPPzRMD
	 GBypmrNwZnJ9opSMyJLhSCYFaFHI71MZx8RWZDs3z3Nvdm1/s2kQOw9+ml883kz4nO
	 gtZcdRkTyQBKkauwgfnRfF+SvlHup0MNyr1RbLLTEo6RCbi3K/lmrl3R3hJjJnYRr1
	 eeNppMEQ+nSEDmtmU+qTtRsULABG9qAm84EyC+vYW7QMR1eu9tkkidjtwAbpQhCohQ
	 I/LI8lz6jN4kg==
Message-ID: <190a2427-40e9-4b9c-ae2c-955dbeead526@kernel.org>
Date: Fri, 18 Sep 2026 15:47:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 13/15] hugetlb: Set mapping folio order
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>,
 linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Christian Brauner <christian@brauner.io>,
 Jiaqi Yan <jiaqiyan@google.com>, Gregory Price <gourry@gourry.net>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-14-willy@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805210557.1118966-14-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D2F8C0009
X-Stat-Signature: rkdm9wfjt1c734s9z5dj37eb75rhbdni
X-Rspamd-Server: rspam01
X-HE-Tag: 1789739277-330860
X-HE-Meta: U2FsdGVkX1/Kur9ZB0Q42Z7jThrMzVDfRqjaWJgk5rjpSg7h+oyUD4qs5e9H89epno0/9Meq2kwz4NH2Dgg2v7mSVp5ZhPDQn1b2YfDfiaqDTUkX7qRFOVp9m7DI1zqw1vi2IyO2isZHfr9cCUJrXHwzSztdPXBZJUpXI5XBToQ65bS0kRbrm3Qb6I3gGH/wY+ZTKocoUmEOvAWyLhSaLHqRY+ggdyDm24uW2uX6XxC804ZrX8VhrBriCJdaMwl/ay1K39jb+Lw5brx0h6lH/ZaIZhiExWxXHcoCfuhmFqJXhtcElm76eUoM+THw/9L4A1YekqEHedezMNF+TTmck+KkuzsPjCKVUwlBy52BVZE0Gg4KJ6Q0W1wQw3jvdpjr5XMT5QN3U+4WeExsLE9WXxj6aZgv267uEn3oXfNCNDjwHpNWQahdBXak0DkBkaSsE1+ZbbLCVgL0q6MOBqAb9zAxfVCvNj46gjcDKM5XoRAEiADmBNCSEKEzYsa7GiUuq/JpgMotAQayCLkAdFozEFt6IEOYm2nkFv3C8eIeX8WtSOe3w6A50T5rycQE8voZaNj/pYHpLx4pY+4f4/ofaPnWYLB1gxe3syhrZ3qFA9dyVLjlYDkJQYVbtaPfVSMC44GuSV63iFrOIffZmOnuWbxcJS6p9SOPnCDmZA7d29DUI22l/QsqbXs0Z59tCZnaogD8C7GbP/OFFQcDWNh7458sVCxzLoE/99lx1BqDr804V/1mQmZuHDHnmYWE/lO4XRO9E9Usk1qGbC9N+kksCC/KI1zYTMx6GfkyDKBeiymoILmOKC+gw77rbRh1A0KfzqbTK28PRgiZIJSDmC3yZDdBM/wpBxCW9T0iJGnyAzBxU/gi9d1Rs0JCuMHZmq2K8d1B5mSBf1d6Oiyn3MJ3nN+/VOnjRGNhZN7lcmTiEcCmUAZcZtYzDRVe0MgVJVAXLgpczKdTj6aMRKJY+0W
 /YHSqDmy
 gXtkP6BCgR18kzjEo9Gu7cl32wAMM6PkfazoHUpgGfmFkk8ihCQ421tarID7SZxeb3kmFX7UXgVCEblVI5MHcK/YaEbJ8xDm0/c/PSOwa5jOoAFLJm/xDmJm3bIs6wZeIg+uYdPRpdHtaIVkOzacj9SHc+mbzgLXHdlcr3pTH7RdqTy1FtccoWB/wiM4a8nNMNYBQs7/yGiu6akBtJh6CbcSOCkIxrFaFgfHqN+fVVTHqWa2Kh/hyL9YniQXTfdU8buQe9MfMuAARo/roO+AQeajjcvH0PY/DPYhnifHfm+2aB1z24WM3pTw7ABZ4XgvZ7dZWTdLd9wqO5zXsOX1mX+zxmJcyNDw7fBH/aZyfi8OhoDLO0SKfNAF1i8CuXrl0fc9fq4jdf2jznzKQVTnd3nIhxoGlAY+TFSlfMSj4qVYlWsDex3fioOy+4d80dK5NVCyJMXnuvHRdTmyrw98+hcp2KPxB4u3vGlESsvkqubl7mMqTzSw5IYfcnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 23:05, Matthew Wilcox (Oracle) wrote:
> hugetlbfs currently uses an fs-specific way to determine the size of
> the folios in its page cache.  Thanks to the support of block sizes
> larger than page sizes, we now support this as part of the page cache.
> It's somewhat more efficient as we have this information directly in the
> mapping rather than going from inode->i_sb->s_fs_info.  We can convert
> the rest of the hugetlb code to use this at our leisure; this is needed
> now so that we can use filemap_get_pages() unmodified.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> ---
>  fs/hugetlbfs/inode.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index dbca3f713bbf..8d15413a67ee 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -883,6 +883,16 @@ static struct inode *hugetlbfs_get_root(struct super_block *sb,
>  	return inode;
>  }
>  
> +static void hugetlbfs_init_regular_inode(struct inode *inode)
> +{
> +	struct hstate *hstate = hstate_inode(inode);
> +	unsigned int order = huge_page_order(hstate);
> +
> +	inode->i_op = &hugetlbfs_inode_operations;
> +	inode->i_fop = &hugetlbfs_file_operations;
> +	mapping_set_folio_order_range(inode->i_mapping, order, order);
> +}
> +
>  /*
>   * Hugetlbfs is not reclaimable; therefore its i_mmap_rwsem will never
>   * be taken from reclaim -- unlike regular filesystems. This needs an
> @@ -926,8 +936,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
>  			init_special_inode(inode, mode, dev);
>  			break;
>  		case S_IFREG:
> -			inode->i_op = &hugetlbfs_inode_operations;
> -			inode->i_fop = &hugetlbfs_file_operations;
> +			hugetlbfs_init_regular_inode(inode);
>  			break;
>  		case S_IFDIR:
>  			inode->i_op = &hugetlbfs_dir_inode_operations;

Yeah, that's very nice.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

