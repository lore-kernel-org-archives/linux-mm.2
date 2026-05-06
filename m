Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A04ACD3424
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 05:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC716B0005; Wed,  6 May 2026 01:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D596B0088; Wed,  6 May 2026 01:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9731D6B008A; Wed,  6 May 2026 01:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8884F6B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 01:46:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCC8A160704
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:46:25 +0000 (UTC)
X-FDA: 84735909930.11.A833D7B
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf15.hostedemail.com (Postfix) with ESMTP id E4B52A0002
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:46:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=At++f87t;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778046384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIXW9sHd6Di6iTQuVK6219NYZCkGia9n6H+juVQb/AQ=;
	b=hrOSgsDLZzfOg/DuwK7e1yBRhB8hjGuZ1YQ0I9ZuwfIQ3d5g6VTHaj4Nfkm1QtOYeU7fLb
	K88CAkJLf10b8NgScwyHngv1hyd1QsTk40E2hdqPYBFSrB9j5fArjaQpyEAnSTS+Hbhifb
	8aB8jY741f8zJbPizVLq04LiMHK+S68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778046384; a=rsa-sha256;
	cv=none;
	b=fiHNdINGAvHPY9qXO9SKSRVJY4CxoQfVH0lO9dWIDm00jqmecw1r9z4FKU6QyYgISZ1evy
	GMwI3tn/ZkhmaoMqwzitixNwLu473HY75AkobLbr25E8oPgy6T3icBVPYSTyJMYQbpEy7b
	wBIrTS0yi/NUrnQ8aYUQNCAntamF0kM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=At++f87t;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778046377; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MIXW9sHd6Di6iTQuVK6219NYZCkGia9n6H+juVQb/AQ=;
	b=At++f87tu+MunQkT/182cZHx92KprYAg70N87NmCMMKK5KnEcDP83ktM4P3cnQeAYVb0katspaqWkUPPk0FC4ZrswwNb8BG7kYvOOSnUzfVZoxM87w1s8UN+022P4E0vvGHGTrZCv9TDpgbRPJ4yCUVk4TSOaSsJFsvrydvsSQQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X2LaIpR_1778046375;
Received: from 30.221.149.158(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X2LaIpR_1778046375 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 06 May 2026 13:46:16 +0800
Message-ID: <37990f6e-61ae-4b8d-94e5-772bb6f800fe@linux.alibaba.com>
Date: Wed, 6 May 2026 13:46:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] mm: thp: always enable mTHP support
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <f67da00a825da9097b5faf2f390ad344450b88be.1777663129.git.luizcap@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <f67da00a825da9097b5faf2f390ad344450b88be.1777663129.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E4B52A0002
X-Stat-Signature: ku6qbyfnn91h5ph4exxche9gbjhe69e1
X-Rspam-User: 
X-HE-Tag: 1778046382-320755
X-HE-Meta: U2FsdGVkX18OO8EPCj6lGCFnXiLH8rWBZbnjSfvxFMrLOuA9cgg/gMC7b+i74aZBNAXmeZNJqQgas26l16/f/KLLcsxkwx87AwJ5PDfUZx/JCrGLlD/Y45LgamCPQUcQChTQCN+9nyZfSGSc8E3etyuPj2esrfngbufKsBO8M3ovYTAj9uWzS6pUQRBpj6hzzR+VC7+u19Wr7aiHVWlhno7YtnJi5hvNB2Q7AueGxMNCEI6q8XI3zSwhXl9rKX8//r6lLBd4vxhdhOdfn+E2HpI27BG/eWO62Y50aDYxz37LS8LVrerfQIM0CxJj59TnHBQi4ybY+NwOjSwBvSuKVT3SI8rOMbDyzLFiX2HihS5BxNEL99dAAyscih7zeIRWxOGsWQednBKUfeuA3zOPTJS93BjJFOBZt64E5+c7bOgz9bG9blgAWMK+yMYVQO0mUdF5LfJZ8/yydi6qo0wbFzj5l0KoYG10s3Se+8iQlJ8waJ3MrS3zXcy7y5zBHB4iOp4pkSiFbf3MsqpV74YW3ll91wU26VnrzpaxADNgJUJqAHOjQoDASmx70WSIsxnQp9tM1c81YBE7RxtNp4M0wo8xOxvrvap9ArsK4NdrE1xAQcCBIf6/5HHvx1ZEOGnNvBAS1mMtEWeI0p24bF/vF0VPL0cVLXW2PfPfxTVU6vk9Z7eAwX8Uuvyb/TicuE/IG8hF/rKApmxcihg9lNQb74Dp40n2IU9c8qgjvWFymjQXmGpsSaBmWi9O9w5bVFLVymYvmfYPusdco4vyP8PeXlsVTWwl6D8qVmyzJhHYAkxsqC0q0BDdMmjtsMgJglK06k+pm1O9uGUqnXKRpGo3iVgQMM+vFiDHuQDQStb53qurGfAzjz2wALCEENyyamb5Vrz/ZqKRAOF5ZXHft5LwQhgKNHx3F0j6j4QnyJ2JI0cElaxx2igwD9cj3FAdEPoMYzfiVe73g00wq3ncH9u
 qU+MvqaQ
 YxwkdSrn+WeCi9NKZ6OAdoyJIivq4ISNk1IrSCdieY1Q/xBRRICshlg+3/MCx/edh/jW8L0XO3DmGbcuKeN63E/rguB1ebtOLRfF+6Yg/bV0otiHTcE/TIks3w5vvY4UErkCKjclSsKLmwqU7YyRKoY8pVNc0puKGb3ogJywLp+eEAgrMjdQtYWJDP9ioQYjY3Ch3/i15HuJP9aZfxeeRI/ZvxpzGCjY6g+8XHZaHcaBPL+JJFi3ZT4LCC226S6wDN2okFl8v1EZzdscAeEChwLJRVrPqGM9DMrMcFJnsVvh4fiLU1GYn6gHcoBivyfWJ+R6KfG2jQNVwJcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/2/26 3:18 AM, Luiz Capitulino wrote:
> If PMD-sized pages are not supported on an architecture (ie. the
> arch implements arch_has_pmd_leaves() and it returns false) then the
> current code disables all THP, including mTHP.
> 
> This commit fixes this by allowing mTHP to be always enabled for all
> archs. When PMD-sized pages are not supported, its sysfs entry won't be
> created and their mapping will be disallowed at page-fault time.
> 
> Similarly, this commit implements the following changes for shmem in
> shmem_allowable_huge_orders():
> 
>   - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>     considered
>   - Filter out PMD and PUD orders from allowable orders when
>     PMD-sized pages are not supported by the CPU
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---

Nothing else caught my eye. Thanks. Feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

