Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D962D262B2
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 08:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A86A6B0005; Wed, 21 Jan 2026 03:20:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7808B6B0088; Wed, 21 Jan 2026 03:20:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6D16B0089; Wed, 21 Jan 2026 03:20:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5B20B6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:20:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3958C298F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:20:06 +0000 (UTC)
X-FDA: 84355273212.08.AF41998
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf14.hostedemail.com (Postfix) with ESMTP id 64C9D100003
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:20:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=00lkPeLf;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768983605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TSq6+yOT1HdiMWW0u9Yc+Zl3cqGQ3pgfZNbZ2cq5LD8=;
	b=fnY2wfFCwFIRP6M12/JY/Lopa5PRjuJkCuUIYK+mCaVE2XJGv0qjJjUXmwMReBZeSzp0Es
	nvcR0xpspN5Ir66S59aMHrLVv/t37pMVdyPKsCUPe34tJxMhFF7CT3j9lxUOdZN/uwAUdc
	F/v8LoxEhE+6yYVjgZOZ7QRBsw052Vk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768983605; a=rsa-sha256;
	cv=none;
	b=sAdTL7LwsNkwHyo3V5mJwHWwK38/1FflPudKKKS+KJftclSmYoMD4doM9Lh7/k3BCMk1Tz
	bah/vQQ+IqG3Cypgne/gsKCSwlyVhfFMpSyRURKwIig4G/VExCKhZxAUdrFMb2B1XytjNW
	WFoCwVqi6s7e9P+iNecLnDejMtKoRnE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=00lkPeLf;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TSq6+yOT1HdiMWW0u9Yc+Zl3cqGQ3pgfZNbZ2cq5LD8=;
	b=00lkPeLfx/QR/Ly6HZWxS/zzaQW8FdmDJ2XbgT/4I7N3GVIJXKexwFU/cG+gyO1W9q4zcDfte
	fBhDGI9wOWeVL/NH1h7yhkltJcgP8S9DHFeyq/1Cs1u010nvL3P6BPEJRG1oj3j+U5vBLN696r8
	yopauiLXq/lmdwGknS/gdGY=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dwxpg43L2z1T4H4;
	Wed, 21 Jan 2026 16:15:55 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 2AE58405A8;
	Wed, 21 Jan 2026 16:19:58 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 21 Jan 2026 16:19:57 +0800
Message-ID: <baccc29c-a68d-40e3-9e0b-f172d32e3842@huawei.com>
Date: Wed, 21 Jan 2026 16:19:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/khugepaged: free empty xa_nodes when rollbacks in
 collapse_file
To: Matthew Wilcox <willy@infradead.org>
CC: <akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <shardul.b@mpiricsoftware.com>,
	<linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
	<wangkefeng.wang@huawei.com>
References: <20260121062243.1893129-1-tujinjiang@huawei.com>
 <aXB0Zcu4bIEvSSuX@casper.infradead.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aXB0Zcu4bIEvSSuX@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: 64C9D100003
X-Rspamd-Server: rspam12
X-Stat-Signature: gkz73a9aop4c9wtc6i44bkhqbj7dun7c
X-HE-Tag: 1768983603-594214
X-HE-Meta: U2FsdGVkX1+dL7qytsboO2BtfgOfwUv4BNdwdzh9wyl9VBMB3BOQcBzLyxpsxPKHYhbIuDEHyiEZL+Em+nOeQHR+zijUGJV3E26B5WreinZMJ+pQfnXyWsm++3fOgBfs4sSZA5w8aD6rNQRMZk3XPb74DhrcbckBbSLG81rn1DuoKABV78JUMlQx1lRpXfKIqd6EtKKhcPXWwP6xfnS5fXfHFPHGg+p0vgXS0YRr0njNhkM8bdo4MMsbFT7NZUfdByQYi4Y5fsB6k5zRkSLhql+hA7n4i0XUtKITthruaMRTY7Y5vfHKoC6OHyLQEInykKJjR02mn2Y5q/I0uck5I9d8XbLu7NFfI4dMZvNEJZiz/VOYbRPzHWwgTBHB5qNp+thenoROz0GH18xs7ouitglBJ8kGKwkUhlgUeYPHpQn9ofviFNtgstbyPsvn7fkIgXOFyB0M5/m2b8W8Jx+7wuN6g16+zBJFneNx1pAdaUDH+1rpfC2PZGctKaZwEw/00GvkEuzfpHHZIfGDvKmLjCag+zpUNfFPQqHEuduTtA0vpS1y4WG8DsQo67ZJCjxtIH6NhSsC3RUP2hALhb4HQBQz+nOMU3JCDBNp0lvyp655NPe6rumk6GtIDKXsKr2RGOABc83wqxrEMdiNxwCJTbU9/CGsqRAruaOZSe/KX5/9N4zQCq6GPgW5fNpoUXOnvW/yOCnGiyYChguD6JvCTASzEJVtMBf1qLxkIWohzWbYXHyYrPdZWRYQPyVu24eH52s310dZSfrge+TitjwzIWd7mgd532xtCjtyl7pjaZJnKNXnNlRotwZevi+fHVOw5Rf4Xg41j1ltTuHICX67eTN1NrwXK+wV1My3rtb7iPq9x/BZvNgCZAURaTftPJNYJGKdQu2Qm7buwNFiC649TyUPIKtYFbFIMqpUGvEILbFR33SdzD8Q0vp9lg4SRtU/N6sBYivEiVRwdWN/JXt
 lc3hUIpc
 8hfKxAqF7PpRFWjuB9x5LqV4RvaizYODJB6CPmn2SIJIO/eDTk2qvuUpStxY6JdWIdIO1S4OvJWQ7jcyAv/dmHtb2x3IDc92020ORTHkHFoR4id2El/CrZVyXJJqzP9r5wHffkenOpdwwzvMLnVxd4fh23gVsMXwgi4qhv6aLAfX6uB6ZV8DzVpUXAxmwfUVpFmRqa9OyL/DnEpXhwfStuLRYHZ+Oi+HqbY1ueCVNegIVvS6AXI/LSJS+VjrDk7zNE3omYFZgbozpJPiz5WiX45UT+tid4OlYKknRI7sh2XWUZmL0Gq0sUvnX0XylMvnqQe5ktlhQPRxbcaf812cFUw1PGOagVu7yx6JRr+QG2ZZ+4FoE0seKW47h98Ow4vv/JE+j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/1/21 14:38, Matthew Wilcox 写道:
> On Wed, Jan 21, 2026 at 02:22:43PM +0800, Jinjiang Tu wrote:
>> collapse_file() calls xas_create_range() to pre-create all slots needed.
>> If collapse_file() finally fails, these pre-created slots are empty nodes
>> and aren't destroyed.
> try this instead
>
> diff --git a/fs/inode.c b/fs/inode.c
> index cff1d3af0d57..85886af1e7ab 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -744,22 +744,18 @@ void dump_mapping(const struct address_space *mapping)
>   
>   void clear_inode(struct inode *inode)
>   {
> -	/*
> -	 * We have to cycle the i_pages lock here because reclaim can be in the
> -	 * process of removing the last page (in __filemap_remove_folio())
> -	 * and we must not free the mapping under it.
> -	 */
> -	xa_lock_irq(&inode->i_data.i_pages);
> -	BUG_ON(inode->i_data.nrpages);
>   	/*
>   	 * Almost always, mapping_empty(&inode->i_data) here; but there are
>   	 * two known and long-standing ways in which nodes may get left behind
>   	 * (when deep radix-tree node allocation failed partway; or when THP
> -	 * collapse_file() failed). Until those two known cases are cleaned up,
> -	 * or a cleanup function is called here, do not BUG_ON(!mapping_empty),
> -	 * nor even WARN_ON(!mapping_empty).
> +	 * collapse_file() failed).
> +	 *
> +	 * xa_destroy() also cycles the lock for us, which is needed because
> +	 * reclaim can be in the process of removing the last folio (in
> +	 * __filemap_remove_folio()) and we must not free the mapping under it.
>   	 */
> -	xa_unlock_irq(&inode->i_data.i_pages);
> +	xa_destroy(&inode->i_data.i_pages);
> +	BUG_ON(inode->i_data.nrpages);
>   	BUG_ON(!list_empty(&inode->i_data.i_private_list));
>   	BUG_ON(!(inode->i_state & I_FREEING));
>   	BUG_ON(inode->i_state & I_CLEAR);

I tried it, and the memleak disappears.


