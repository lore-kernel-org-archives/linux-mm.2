Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82108108B8FF
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 06:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5F976B0005; Sat, 21 Mar 2026 02:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A104E6B0088; Sat, 21 Mar 2026 02:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9264F6B0089; Sat, 21 Mar 2026 02:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 811936B0005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:29:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7A401B69F7
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:29:37 +0000 (UTC)
X-FDA: 84569093994.16.F91A207
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5A5B9C0005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:29:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of linan666@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=linan666@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774074576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q71t7/a7uvTLKhFUcPyK1PzyOV2t7Z4ZelNXk/vJE4s=;
	b=fi7YesrdmmJzqdzCe5ItAFDzlmbxe4e6Whoh4+vNYnFtcDBOTOnWzzIdRPJXC5b5fLtk41
	+vb33NpnEgEbd1qUjZLiCq8hVrLfNP5ZZaExl7CbZi/FeMnfh9m/Bx6iKW/WeqKZRMTvYU
	DQIa2KVNwRHZ6HK1Jzyt+ZiiV8OSnJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774074576; a=rsa-sha256;
	cv=none;
	b=WwzqULXpzcz4wHsBIVaWSadxzhgofKl7np1TT3pu+XuemevjckIqoYpqq9fETpD2wrNFZl
	pJT4Ww7brFNCp0NUG6v1n8POA5V0NqGvkkeAFSBia6++iHD1sUOxMZ9Dy6wWo9SLfWLruR
	g4y7MA49jdC+iEt1t8F8T0Zc5ouX60U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of linan666@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=linan666@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fd8fY323zzYQtgd
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:29:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 8B3504058F
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:29:28 +0800 (CST)
Received: from [10.174.178.255] (unknown [10.174.178.255])
	by APP1 (Coremail) with SMTP id cCh0CgA3OtrGOr5pzkW0Bg--.21396S3;
	Sat, 21 Mar 2026 14:29:28 +0800 (CST)
Message-ID: <84ec0c9e-4651-b66b-8793-36ba823fce75@huaweicloud.com>
Date: Sat, 21 Mar 2026 14:29:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md/raid0: use kvzalloc/kvfree for strip_zone and devlist
 allocations
To: Gregory Price <gourry@gourry.net>, song@kernel.org, yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com,
 akpm@linux-foundation.org
References: <69adaba8.a00a0220.b130.0005.GAE@google.com>
 <20260308234202.3118119-1-gourry@gourry.net>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260308234202.3118119-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3OtrGOr5pzkW0Bg--.21396S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CFyUXr1rCw4UXw4UZw1xAFb_yoW5JF4kpa
	1rW3Z8JrWrJrn8GFyDJ3yxua4agw4fJrW0kFZ3Xay8ZFZIvrWktrW3AFyYgr1IkFyxCa4r
	XFWYkFZ5Ja1DJrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9jb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvf
	C2KfnxnUUI43ZEXa7IU8rWrtUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/
X-Rspam-User: 
X-Stat-Signature: ge3dgatsrnhenumbonyn9sw5qfr9yyph
X-Rspamd-Queue-Id: 5A5B9C0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1774074571-456084
X-HE-Meta: U2FsdGVkX18EXby+3iAFu6bEvWtAXcR3X/38CTst2hbMoJYfog9IV7d6pHZzjh49mNvGzm0Y2NZdJfD3H7x/fZKDub2ZxRvGv629Hkta63r7Ov/KwOvzOq5/zPI9nF6p69tlY68ebLLaip3e87A/9DdUsip9iTpqo7UGjI2CUWU7swkEVlbC6Qyee9BhoIB/tAnNUpEQ3DuTeWcdvYQd4aGXH+qzbh+O402Z5v/UDHlIQmMyIb2lzysa8GErG8WgiuLJH0F1By8IANTuz1Nqczu1p3MglJCu347AOAAQa9l4NrrCBIdl9ldUX83t57t60d5dKHhWxYCNMNybXs6isGBq0CP5UdrzHMe7DG4mbDx2dal6fC1k66J7rAaxA1lEmchxq+Kzitz99jDuYoI3UhruH/8hJ+NwJ2YyLUUaZpntdUQCKWTPCyYtZRT+keLfv8fZt+bGE9yxeeVWodfZlEBjoQDSEFGLa4MDcx6Mmm+Mt07Vk0qgoUVu3t5GoGCZcWSGkjT7oFepapSiOG/PAVtmnMfepM42YPneTu9+WDfYYSP6krd83u8BnVyo2pdjri6s86LkXiDMkCzJ51B89IY3I8eytN+rZc4wolTPsbOGy+Mb8R7Tt4aNLdr4dc0V86GqQ0QSiRLJEq0hO56wWAo9lafVpO8YPje7xllD1pUyDXypF/hXFW6wIA9LcczeEtebMVg+UiHTbmhLCjBsQzEjVZIaAGium0ioR/iIoTLUabSSj3bXpQiyYM2AbsFdx1WFw6MRGh5mYjxiah8XDy+bSJBRezuO7ByCWLYA6Twik6SQSd4J1p/Ko+DpF3R75hvIueMrmak6f5H+dNyGxxbUbbUN74h7/LMWD+SbZcurwVUckuu4b2abLFlf3tYgDDqvZvvOnLjFoF1N/o7G63jOtdyW4fKi1awGcq9GpFHgrtlDH0xdzGSaZgOuoi/bsBLAvk2QT5iKvyqd/s6
 UmWY9xHg
 dk844bWY3caf7StSAdcPgP5eWNdevfyzibDv5QHQPgn/DA6eAfIn8S8dounpxp8PUyUnzMSrMeS1tw1c5qWKwJMEfbbPqUxObq+YIFWLUJ/6E4u6dhsVLJB1WPeiGYhzn0ab2B0iwyxw2/AwXRpxcgRxwQeE8h2fxRdABnRktu7xEeO91YHDFFDsrfyj6H1VWIdcHDbyFCCkaPhg8GqHIBOUQ0apRlEbrETCUxzxYp0mjqpVuWIXkzEifiXSpB+Y++wL4t/YwSN1+d7qBi36qNVrEq8G1NtOYiVEAnaIuHH0LfJ112OuFjlna3OuzPfs9/BOoF+Za/LXZWZ9DfyDnXxAC4xzd4FoQXS+v6lFpHvwnImQ0GFQ7vtQg8LwiENMhBcIvklOzrAy+aJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/3/9 7:42, Gregory Price 写道:
> syzbot reported a WARNING at mm/page_alloc.c:__alloc_frozen_pages_noprof()
> triggered by create_strip_zones() in the RAID0 driver.
> 
> When raid_disks is large, the allocation size exceeds MAX_PAGE_ORDER (4MB
> on x86), causing WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER).
> 
> Convert the strip_zone and devlist allocations from kzalloc/kzalloc_objs to
> kvzalloc/kvzalloc_objs, which first attempts a contiguous allocation with
> __GFP_NOWARN and then falls back to vmalloc for large sizes. Convert the
> corresponding kfree calls to kvfree.
> 
> Both arrays are pure metadata lookup tables (arrays of pointers and zone
> descriptors) accessed only via indexing, so they do not require physically
> contiguous memory.
> 
> Reported-by: syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>   drivers/md/raid0.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index ef0045db409f..5e38a51e349a 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -143,13 +143,13 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
>   	}
>   
>   	err = -ENOMEM;
> -	conf->strip_zone = kzalloc_objs(struct strip_zone, conf->nr_strip_zones);
> +	conf->strip_zone = kvzalloc_objs(struct strip_zone, conf->nr_strip_zones);
>   	if (!conf->strip_zone)
>   		goto abort;
> -	conf->devlist = kzalloc(array3_size(sizeof(struct md_rdev *),
> -					    conf->nr_strip_zones,
> -					    mddev->raid_disks),
> -				GFP_KERNEL);
> +	conf->devlist = kvzalloc(array3_size(sizeof(struct md_rdev *),
> +					     conf->nr_strip_zones,
> +					     mddev->raid_disks),
> +				 GFP_KERNEL);
>   	if (!conf->devlist)
>   		goto abort;
>   
> @@ -291,8 +291,8 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
>   
>   	return 0;
>   abort:
> -	kfree(conf->strip_zone);
> -	kfree(conf->devlist);
> +	kvfree(conf->strip_zone);
> +	kvfree(conf->devlist);
>   	kfree(conf);
>   	*private_conf = ERR_PTR(err);
>   	return err;
> @@ -373,8 +373,8 @@ static void raid0_free(struct mddev *mddev, void *priv)
>   {
>   	struct r0conf *conf = priv;
>   
> -	kfree(conf->strip_zone);
> -	kfree(conf->devlist);
> +	kvfree(conf->strip_zone);
> +	kvfree(conf->devlist);
>   	kfree(conf);
>   }
>   


LGTM

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan


