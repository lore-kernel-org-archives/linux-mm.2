Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC8CD3EE9A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6046B03F1; Fri, 23 Jan 2026 01:51:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD566B03F2; Fri, 23 Jan 2026 01:51:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAFE86B03F3; Fri, 23 Jan 2026 01:51:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A99346B03F1
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:51:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D7B8D28FE
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:51:32 +0000 (UTC)
X-FDA: 84362307624.12.F633586
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3975EA0007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:51:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MQmvNUye;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dq315O0j93dLcFq1bZxcJRTGFPKJRchphpHfHVTtMQs=;
	b=engsmhj9RueRcrhkaVGoGUk2NjjgPYKP8GDLYYePfb5ivAId262zBYYlfLOyzCi3V/N3Ye
	Jd/02+wKwVBMCLwwTMnY/8fvsBiil1gdXESq48LugQkovGUJ9aCbbTRKc1o1o2+TEn82qB
	z5zzCrVIbJxYrASchn7wu3QOobsUxzg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151090; a=rsa-sha256;
	cv=none;
	b=hsHB1IIv1gfUdaDZ+LgdKuPGCqf4oKEJcY/qk1PE3rzhFjFceMwcNQj1kHr9+v6LmzfQEJ
	tAhMrEcwqnvvtAswN7dv2Fi/Hs+mWoYkD9vPlQGGUCRJY3CuX8XaeQWZonqpDJc4RVAetT
	kt3RxWk7Itq2HgjW76I8uaU3hs50cK4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MQmvNUye;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Dq315O0j93dLcFq1bZxcJRTGFPKJRchphpHfHVTtMQs=;
	b=MQmvNUyeyICeQ+LPKkgRlGKf0Tw5IELOxCwPeDuhrzdFigKfHtQdOaBFQIZp3TRHtU6sHWOfH
	ZB0w3K+9gJhOtvyuqGRPSQ43McUZxeh3b6sgr5E3TCQjCJPOCEIHdsHlZn1N+YX8EfDr4YexMR2
	cXQFN1gmVxqdJnvikc/6Tbo=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dy7mF2npkzKm5N;
	Fri, 23 Jan 2026 14:47:57 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id F302A40565;
	Fri, 23 Jan 2026 14:51:22 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 23 Jan 2026 14:51:22 +0800
Message-ID: <a1f97fe2-fa7c-4411-b2a0-d19257653863@huawei.com>
Date: Fri, 23 Jan 2026 14:51:21 +0800
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
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: 3975EA0007
X-Stat-Signature: mi7zqacx1eiba18m5xgciajk41ktfqc5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769151088-66887
X-HE-Meta: U2FsdGVkX185wzMAhl48XGAoTqJne0aeDHMuYuCi69FDOLHADMBejAfKzKHkK0dzDdSjvUUdbT+js5DbLKuhA5GPRmfu3dGWjKUV3KYfky12ZAl1PoHxF4CjCVQVO5G4xsHBX4Amsz7pxvwdKOCMQ/DZ3aHsFb6/02pLsjXKPwN8isLReJtjnc/Riv6XLqrrLOPK5MOtETXQPHwkd37xgx4FgCDvxI0TxtEU9hzSD+z3nRHt37ws4JFmQbsTxSletUe68Jc4sXC3qJ7n2P1sOCgmluv/pyced911S8pJ1hP2zHK/cXlNDeMG2ZqZrQCoYno7QnB94fR3BHTiYhXU+suAY88S2rL3+hq3NjqVQMXRYt9ywM1xkNkUBo9It6W8zk8ZUksSgGF+cFTi4WLc8If1ywzNwimzGzuNXrPAoyT4D2AfadKy+T61eqkCKpXo3kwyi5XWU6vxaGSib5NkS/ePoVssbIe9gVVXYXYiZt1Ni225DDKGxDyoF97jCnp1aYdmi/6BL3Ma95BQkLdXBTmB0DJQXn91cYaSjnWevArh7VsliMmPs1ZFdHl8tJbXzbQIJiPoYiOH0uE2Bve3lBs0eGbkXZlyi+jMBfVwZQn5NYbEJHRv5ks8R88COHsNDw+akeMyuHJKNbu7CYQrrvQoGKhXicvxPBYSb2bhv2q3v1eg8hUfj+LN/AKkS9n0RJi5qUqfH+dR+N+F9CDo3U76MeCkE0jAODFAY9/LocoZ05a3gxZvGLqdQmbZcDkTkA4XjB0RYg0OPmWv+NchKw306Iivgjm+GmqGxocT3q6oXXg4XGLmYCcCCnOLT9e4mJzi1sftxxyDnXEkXNrL5oySEO9Z7aV6/5FYlWX+JNahgOPJ8S7fj9LftnuGlMRjMOn0wOCrx+A3ws9UvhzxAVtwupGArPg/69G/1qm1vkbwnG0IMbwIR11oJRolnl09emTpe3pDRDF0J9uOeDO
 wTcAoAu0
 YaMXkyq8AMDErvr81/uycjgsJrhU6goAfz1PMSFtT7ZWPfRExqFLxHRMXdpDpazdB3+BRKWicb7+wdToUbzj/uYQZ977nXYOld9jUo9wCh1EL0zpj5zJ0aYaSCIPlYuWspr/iwDmSsTHFi8MCuvk3OK7CUsykHi0sYldC7dzpscA/1D1URq8eOSxf9vRKQ4bWG2MbmaQ20Es8XcT4wtmRf3YQdJEXtlzhXjBA0lDje3LfN3a2s0HzaG6MQgTBnIFQx9A+OngGy06RM5KipU45l4RxkSP59yAbMn18I+UIqAcXLFjkjXiJE/aXW6wsNbrk5fiMtyMLPnR9K66Rqj7CHsfIEU1/gECrpYS+hBwTTBdmi9pNpqZSNKdK8ltjx2Hi+uO6
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

Hi, Matthew

This appoach is much simpler. Could you please send a formal patch?


