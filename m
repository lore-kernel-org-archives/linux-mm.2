Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CBBFC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D65F6B00A4; Fri, 10 Jul 2026 10:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD376B00A5; Fri, 10 Jul 2026 10:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB3E6B00A7; Fri, 10 Jul 2026 10:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BC186B00A4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:49:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9203BA0460
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:49:44 +0000 (UTC)
X-FDA: 84973151088.21.E477B4C
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 515A1100006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:49:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JmU/jn0G";
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783694983;
	b=xacqrBPJGpg9xW8JW5v7mVOguoQFmbDb7J2dMCkqv0+HwjCwjiyqrWj0rEQDhY0b/z8nkb
	Zg6tAFKElvnZW9E61K+AHT0MTkzZyH0JfCP2TyTyNidBORnWqB/aIP3a9TS+NyyH7Sg4UO
	v3aQtcesa9w1RoZ99lKR5HlLGEnCz8I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JmU/jn0G";
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783694983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXZlxSO/l92LMpl6/wSr5Uj7XlqGnryB8RQYDio6xSg=;
	b=hIY5XJ51ZfwYRXvxIyzufZHaIlj2KcCkE3BzF6gBApwaRYIbj8mOXR97DIugbCOP4aY/rV
	ybpnIaF5nQk5d3tbvgbey9xLGmaGuCBZIvg/I/wPehuj14X7ggq2M96qb9TwqY1eVEPAYC
	uBhJzBO6bg4rP0eiaSUlJWlbnBqAexM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783694978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fXZlxSO/l92LMpl6/wSr5Uj7XlqGnryB8RQYDio6xSg=;
	b=JmU/jn0Gt4Y7cqKt/pqB4N9AsbtjK+l0fkxsrbznBJ3RTnlOfTULLd4rAPCSiGh2BKcRnG
	RCr2Ox90kU/lZ+DtVvdN8Y/5+HoUrU581oMSjuaESOaHkPBQCJnleBEuxLk1WCTwFv17OY
	sqDUnPxa9wuAI/XuzwBXgPDmRnKAFfM=
From: Usama Arif <usama.arif@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 04/10] hugetlb: Set mapping folio order
Date: Fri, 10 Jul 2026 07:49:32 -0700
Message-ID: <20260710144932.1582955-1-usama.arif@linux.dev>
In-Reply-To: <20260709184740.1286561-5-willy@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 515A1100006
X-Stat-Signature: hq479enkas9b5pijjcufq18p9m1foiqp
X-HE-Tag: 1783694981-196474
X-HE-Meta: U2FsdGVkX1+PTb8KbZj+vFBTbcK1qpkr7pz9wn7b2zBMMRQQd8v2nJTjVvtKM+8KNom0yKEBQj5godJKLiVSz7Jbz1/sed1PeJWWZwVUeGAV0cNzL4M0FZiLcAP3Spk+14E+/VYPkywuOBtpruVbxWR5Nz8eY4z3lPrq8pY0BFN6dJRC3OZGQyc+qyAzih4UaPsNJev4b3kxVIJ2zV9y37MwSEUAyuwZrpxHkANeWGMo0WFzALOb707lksk9RGAhCtOjsATzopbFsUMvSZ+0Xsuwwjr57cPwt+Ifseg0L79cZSjdWn0D2Sq4UMmVRDp1KwJZ/OcRYLIJ9BPlKoBcD3ctb5T/pNaMhr33pngNasJmRHn+Xq6XzKsbY4bk7W9rCZ1lnZXuCJ0/Cfz0PgUmAVu7XhH7ap0PW622HWxb/lbBF7xdKX/CrkneA7GhbQItPsS5jw5+XhU2iEYUw04aOz4RrCNBNLRNJzaV6nrqvlzrKcxyKaTU/GjnfXDqQaLMhn4/9fW/DMTjTzEh2kjfhfr00xsYlxNPuLqdMZbafw3BKufISQ9g8NzvsPLuR5sBOVyWxIEngg/4Hjpisz4QZqp3cD4ScSdoUspOEr3hWoXzX2OiMVrpBURkvCmhtHx9UrbG92gyfaacFk4MvPJ0VAi709lFDZW/WG8ZJYr/3GFK5niezfmdoGOwTyHbVTcymVyzM1oR40/7FLy+GHl+zBaSr/MJuu1eZfy3cz85TE59HckZ0DHgXSRpe0X2dai+4y5/kfvNytDmcOzAnx4oM8znhSsd4XHVF8JOAregBhUzRtMdmCm6yxIAYf5nOx2c5DRwaUHRPg4++8cv4J95PniVJDFoHizYnv0Ec6Xojfk48Akt9CEmH6eq+ZpX6d9d3izDwA22aphjfS3V8v41joxLRppaUJmPHrxVxpPMvotqG4wlRUt/kmcFdp4HGbBWjZyssby2FKefn4CZcpf
 tl19SAWv
 XnbXHpA0TvIE4B4XDRwtn4kX3xSGfQxcoBixsmtshwkfmEoI6x9FZ1fQrZEPGGO7NwFCeN1gsj3RsV3v1oLMLvX66L/vNGWCjtliSSpyy/4NrijBUe6fTALrkRYz6qg7/ecVszrQ7Cr8ZpUA0oNd6Gf/oktscdLsfiof5j21jYnyVrbHBXzFEWL1+qbbl/MU8YcFeWh0/HJbK0rVF7EkiOsjbYqz1K3ocQ+CTNb7N0KqsxVOAn3WmYO6CuNVbysgmJRmvsp8j0d3YZPoQmbp/OIjRaHiALhGmVfRrxui6h4y+uPFk0BRrDW0CiVukAibLB6Ns8XkrFqowADQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Jul 2026 19:47:32 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> hugetlbfs currently uses an fs-specific way to determine the size of
> the folios in its page cache.  Thanks to the support of block sizes
> larger than page sizes, we now support this as part of the page cache.
> It's somewhat more efficient as we have this information directly in the
> mapping rather than going from inode->i_sb->s_fs_info.  We can convert
> the rest of the hugetlb code to use this at our leisure; this is needed
> now so that we can use filemap_get_pages() unmodified.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/hugetlbfs/inode.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 216e1a0dd0b2..1760df6f2709 100644
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

We are setting mapping_set_folio_order_range(), but mapping_min_folio_order()
and mapping_max_folio_order() will still return 0 if CONFIG_TRANSPARENT_HUGEPAGE
is disabled but hugetlb is enabled. I am guessing this will be tackled in
one of the following patches in the series.

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
> -- 
> 2.47.3
> 
> 

