Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18A66CC6B27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 07:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33086B008C; Wed, 14 Oct 2026 03:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4356B0092; Wed, 14 Oct 2026 03:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFA276B0095; Wed, 14 Oct 2026 03:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1FB6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:55:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE8D91403E5
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:55:03 +0000 (UTC)
X-FDA: 85320470886.05.8039680
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf23.hostedemail.com (Postfix) with ESMTP id 246E2140005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:54:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XuFHEPhu;
	spf=pass (imf23.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791964502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1srLPeeQpqMU1BY9DsdzVHBSRvgKY9TmGHXByiTkNk=;
	b=xffKfGDcL9jdrTfhWmd9DIN2ZgD7WwYFlIIxPOJz3Q+Nx5NBa4qcj7eF6a7+j/SBVe75TH
	/dAsk4OdkKCM4i2S4I6w6018cGfe1dw8+lfgE3gz06nw/3I17c/ieDg/dI0C4Xk7XrFQvV
	T7o8A0EQpyH8tkK6qi1hlMVqBCuPpKw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791964502;
	b=M9yC2QDrnseX4Dxv/0m1CczPlyAyONslQsANNbgi29v+J6OgJX1uS3amMjI4sX/JkgPeYC
	sevbI30RTFJ2PgZpVlNS4LthBve7odS+Y5f1AkvG2v8SN7VnVaCy0ThxcqivvLEZZI89Ik
	lpAiN3O3/HENS8/XDlGW/TkXtRZ0cQs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XuFHEPhu;
	spf=pass (imf23.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791964494; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=A1srLPeeQpqMU1BY9DsdzVHBSRvgKY9TmGHXByiTkNk=;
	b=XuFHEPhu0NuRUUO/DLjpHsZUoFSYYmFFSz5BViN6mRNUDE84xKYJptJWUtKkPgCCiVQptlNorjtHTfGxjhA6+qHtI2i6Ppu19ScVOfRVVqj9WJ14Aky3SMw9rRHXtXjNFbzhji5fUexI671H28hbEiNvmHvPMObqQt1pwazItV8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XCoKjKf_1791964491;
Received: from 30.74.129.250(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XCoKjKf_1791964491 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Oct 2026 15:54:52 +0800
Message-ID: <82f099d8-e46d-481e-bba5-95bff118ffbb@linux.alibaba.com>
Date: Wed, 14 Oct 2026 15:54:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ipc/shm: fix RSS accounting for hugetlb shared memory
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Dan Carpenter <error27@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261014062705.1997201-1-tongweilin@linux.alibaba.com>
 <0B5B2CA9-8FA9-4DEE-BF78-8E280F337362@linux.dev>
Content-Language: en-US
From: Weilin Tong <tongweilin@linux.alibaba.com>
In-Reply-To: <0B5B2CA9-8FA9-4DEE-BF78-8E280F337362@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 246E2140005
X-Rspam-User: 
X-Stat-Signature: 49rk394iu958yocgf9dkk57o1qgtdsrt
X-HE-Tag: 1791964497-338845
X-HE-Meta: U2FsdGVkX19GQNlQbWnRlw5of/eqwBUfQr+rcNzY/jJxWdxjrhL8/vv6LBD3MNVvFQ+TVdHFZe9uFez2BiWXY2ktWdviz2SNK+tgTPbYQJOYDcgaWgT5QfadOMzf5m5pn8pNnIABFKi4Cl1q1sHLzyyn/PU4ff5LMNEQ3R8NSHxfhm4zH4NaVR1p1SrB9yp4r+Gkaf5FVfWnL0xG8gzHav28mcCvXCh+yJUYtNpPDZFm9ZAGlsQe4RDYFXcnT9lMAXExcVQxPtyE2lNT0pUqaV2D7ihxUGUEGaRSEFT0b1FcY/WJtBumsjZ0lCr/SyVQb4Q3LatdCFLs17VBVo9+T3PPQBNGu3HFPqkdvmOhAGMACfWFjfoIsmotMN79bpbVwxwyXSsq/0y0705TmLC1S6/1x3KggasMe2kGqjDQZtMQPL6/IMYcQQwEgp96B1d0gvb16ZroaLbIzDVxjIxUnbzd4KaNAwkPXHUzmzI7AmmFpnxymvG0cnCJiTU1XfV3k7NH/glxfm2lU81wpUqm4giMqcW1UUB9eQaViZRmPF9zl+Ob++f/10rPoZx5wzH825yAqlAoTUzxdz6QypaIIrkY1v2HxLHK9wZefd5buwb00IFlKn/FoSALyy6iGPtHuEhcpYA01t27ZRXo5g0JInJkajB1HnQdhe7ndcSApgw0BifkVx7Z7C4fWHj7+cRPdcq4nlnMN8R6NMSKv5Dr5PEcTgpgrYvSMh8H9+XsEgLQEqdlUhA2bbM6IwtaFrQkgpAh2v8jpZLdLlXX0i03FyiqV6g5merleRJFeKXyvCvt4wqb+q8ogO8Am1mQYMXcsLwp31B+4PJ4SR/hjztAYH39GLfSJklYS6RZ0p35d+rTFzQ6eS8YKr4vmi9v9MynWfXhTfRPA6wwhNPEPQtft6MO61+IRD2CsNrS+LoG97KOXrhXDUGdu3+7TjB+U0uWZMpcUqh3QNR0fzHlqvX
 Q6SV8oHy
 SX4v7O2259Lbpya09lHnQMX8KS24IgOzLF4LoC0YjhSinxro5UzoXh3V8bWVbAi8CdCeXBUOkDg3IcmDdxCLVdJ5NO12xc4J7QPZVfI5rK27144bbLP9KlkSkKfhTdmZe9As38uog2qLFC15D0y4DDY2/qzT103fcXOGJQMBgm17ZZrLpZIpzPU4EY2IMdsYpMEiQZfWPLDevQHTg0Ieq9UQ2obYOG4L02xY6LUAX2oqaIPqCXndXu5StF5aMwhSKefWbg93GUho9s+O3ijLXLygBdWgNnHju+j5O1HgXJOO4m7NYyTbhuGJBLNE7kJm7JkDrmEO27QCdTi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Muchun,

Thanks for the review and suggestion. The simplification makes sense. 
I'll update the patch accordingly and then send v2 after testing.

Thanks,
Weilin


在 2026/10/14 15:25, Muchun Song 写道:
>
>> On Oct 14, 2026, at 14:27, Weilin Tong <tongweilin@linux.alibaba.com> wrote:
>>
>> Commit a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in
>> filemap.c") changed mapping->nrpages to count base pages for hugetlb
>> folios. However, shm_add_rss_swap() still multiplies it by
>> pages_per_huge_page(), overcounting RSS in both SHM_INFO and
>> /proc/sysvipc/shm.
>>
>> Use mapping->nrpages directly and remove the unused hstate variable.
>>
>> Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
>> Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
>>
>> ---
>> ipc/shm.c | 3 +--
>> 1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/ipc/shm.c b/ipc/shm.c
>> index 25190965c9a50..5ed2beef0f1d2 100644
>> --- a/ipc/shm.c
>> +++ b/ipc/shm.c
>> @@ -943,8 +943,7 @@ static void shm_add_rss_swap(struct shmid_kernel *shp,
>>
>> 	if (is_file_hugepages(shp->shm_file)) {
>> 		struct address_space *mapping = inode->i_mapping;
>> - 		struct hstate *h = hstate_file(shp->shm_file);
>> - 		*rss_add += pages_per_huge_page(h) * mapping->nrpages;
>> + 		*rss_add += mapping->nrpages;
> Hi Weilin,
>
> Thanks for fixing this. Using mapping->nrpages directly for hugetlb
> folios is correct.
>
> Could you please simplify shm_add_rss_swap() further as shown below?
>
> The info->lock taken here only serializes the read of info->swapped. It
> does not protect mapping->nrpages, which is updated under the page-cache
> XArray lock. Therefore, taking info->lock cannot provide a consistent
> snapshot of nrpages and swapped.
>
> These statistics are inherently best-effort, so READ_ONCE() should be
> sufficient for both fields. This is also consistent with
> shmem_swap_usage(), which reads info->swapped using READ_ONCE() without
> taking info->lock.
>
> With that, the nrpages accounting can be shared by all backing types,
> and only the swapped accounting needs to remain conditional on
> CONFIG_SHMEM and non-hugetlb files.
>
> Please also mention the lockless snapshot change in the commit message.
>
> Thanks,
> Muchun
>
> diff --git a/ipc/shm.c b/ipc/shm.c
> index bb1a721a3e74..6862f681373f 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -936,26 +936,11 @@ static inline unsigned long copy_shminfo_to_user(void __user
> *buf, struct shminf
> static void shm_add_rss_swap(struct shmid_kernel *shp,
>       unsigned long *rss_add, unsigned long *swp_add)
> {
> -     struct inode *inode;
> +     struct inode *inode = file_inode(shp->shm_file);
>
> -     inode = file_inode(shp->shm_file);
> -
> -     if (is_file_hugepages(shp->shm_file)) {
> -             struct address_space *mapping = inode->i_mapping;
> -             struct hstate *h = hstate_file(shp->shm_file);
> -             *rss_add += pages_per_huge_page(h) * mapping->nrpages;
> -     } else {
> -#ifdef CONFIG_SHMEM
> -             struct shmem_inode_info *info = SHMEM_I(inode);
> -
> -             spin_lock_irq(&info->lock);
> -             *rss_add += inode->i_mapping->nrpages;
> -             *swp_add += info->swapped;
> -             spin_unlock_irq(&info->lock);
> -#else
> -             *rss_add += inode->i_mapping->nrpages;
> -#endif
> -     }
> +     *rss_add += READ_ONCE(inode->i_mapping->nrpages);
> +     if (IS_ENABLED(CONFIG_SHMEM) && !is_file_hugepages(shp->shm_file))
> +             *swp_add += READ_ONCE(SHMEM_I(inode)->swapped);
> }
>
>> 	} else {
>> #ifdef CONFIG_SHMEM
>> 		struct shmem_inode_info *info = SHMEM_I(inode);
>> -- 
>> 2.43.5
>>

