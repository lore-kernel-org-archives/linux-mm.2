Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F70AFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 11:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1144B6B0088; Tue, 28 Apr 2026 07:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C44D6B008C; Tue, 28 Apr 2026 07:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF5876B0092; Tue, 28 Apr 2026 07:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D85016B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:37:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F3928B8D4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:37:31 +0000 (UTC)
X-FDA: 84707764302.14.FAD4B79
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf23.hostedemail.com (Postfix) with ESMTP id 055A2140005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:37:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=v0bFUI0B;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777376249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yP5OQNhMmcwIxI1oI5Mx5fKdBBjTBBmIQZkVZovEd3g=;
	b=FN05XvfHcI7AjKtFdOI/XD5Js9RXdR+Mo9dpiDlAmtUZg0DFX8crKsq0JoAvDL7/lRrQI7
	8IwjMtZ7/ZLMOPTkZZxorYuScaw6sXZ3PbzMLTki+GzSCsJ+ks/RYTQeJCn3dk8UcWvHhy
	jfjHnJMnVAj8S3gHL10MomzMplxeIso=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777376249; a=rsa-sha256;
	cv=none;
	b=KH5aEZbU1cCQS4STZ7gUPSY225cZ3ZYlQiys6Ah9SBOJdY9mhg44ptfov6VldHSernZNk7
	Rs4IkoSvQQSt+6BRHm8yaWKs9ldAQz4K7l97os76zfAKFMWDvqY3bmM3lnDHWI0kEb47s/
	4A+060z2DW9iNDq2wk/AkEedsl00WbM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=v0bFUI0B;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yP5OQNhMmcwIxI1oI5Mx5fKdBBjTBBmIQZkVZovEd3g=;
	b=v0bFUI0BEOyWueLy7pxnHCOKVoR0igzwxlVGdMA0Qyw81uWFz3SqQ8IPZMcyLRX01XUCsllDq
	buzpaLWGFTiho+PSVkEx0QUmIuhhGNY9chtIZr3xID27VtEzn6XPzSqZ2zQ1nG4KdfnWkjZEDqE
	lN3A5Uglgi494HwPD5AeF4k=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4g4dXv4h6bzmV6X;
	Tue, 28 Apr 2026 19:30:55 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 7998540565;
	Tue, 28 Apr 2026 19:37:23 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Apr 2026 19:37:23 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Apr 2026 19:37:22 +0800
Subject: Re: [PATCH v2 3/3] drivers/base/memory: fix locking for poison
 accounting lookup
To: Muchun Song <songmuchun@bytedance.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Ying Huang
	<huang.ying.caritas@gmail.com>, Dan Williams <djbw@kernel.org>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
	<linux-cxl@vger.kernel.org>, <driver-core@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
	<muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael
 J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
References: <20260428085219.1316047-1-songmuchun@bytedance.com>
 <20260428085219.1316047-4-songmuchun@bytedance.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <fae6e568-fbdd-e697-8ea4-b12c73750ec9@huawei.com>
Date: Tue, 28 Apr 2026 19:37:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260428085219.1316047-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 055A2140005
X-Rspam-User: 
X-Stat-Signature: gc9xgs7etmbxcgsyyp75tozk4e8qysz4
X-HE-Tag: 1777376247-947370
X-HE-Meta: U2FsdGVkX1+jsF/FYwMXkeu0l91ly1+sHpMkWKlG5SSusXLsASQlteRsSk2m+tw1yfwGEJg2Tqpl4Zi9ibQvXIJfXzhXsfdNe+xzfxIKISwUfVzUmCqKgbhrVG8X+AVuN42vopvoF3+7eqYIXIFmMgJllXp10G0b0Ta/E1SKuQCjKRWIDzIkjWSGpUVgdKfcivnwNLMlNY3n45liYoQtPFjTKOosDS3lcKmyEqCbb5sSMoJOM/Z7UkiLkwDTsCvM/Y+cmO/6a3mpPK8TYVjcjuO2Hdj8hIgdLK00/sUwIQuCCtmIkl5jothvZVcTcKBgJo3SK1DY93AztiFl0sBWIHPcANCzg78f9c4Kce2wgMAsOZCkfQPqTj+4R4OItSqL9RRyAYapEYTh5p7UPeVdIPG2xkQgfBlKp+grAQpCsP7amochmr5Iyot9Dc6+iztYAzR7gtW/l3XYp85w6IbEe7XY39rp5/ZfZ2B25P9vfkmc7n14XA4PKGG9+aKk9dCH3I1frhMnUYAIMV3pgeGrDA2oMG+fzsdgb8YgSd/cAlzGmGK90LhKYBZVYE3EtZbSkMQZltY1vXSnop1quIqLQgRCUXbfL47GR7rtDlTKviMfm9YudwcHFfF3J6pJvuOR0/OfstwXUpjlaSMdWMexMKGVG3N0NAyA8/HqF0dX8zPszs0VydUE6d+pcD9oIYpzllOAcCHmyhJuFSrlFz3OPe0GlNiXn4wVOWL65thZF2MaFslgp/5peSafCVuuTvXFQMNYmSSakHo2kz2qLgi+KojGxehpzIfbxXNzLXRw/Gb8eQcVJ0kCFvO/gvXsuVGJOcgXEN0WXa16Cflez9og2M/tziiKR1td2QzZCjSqckBMW8OJDFHog0cOOd1n7ybC8GCPyOcXtfORDlzRajraQ48fxREeD1hmEzl1a/cfdOOZPMmg0ZAehdMC5Qf+fhqJFBwRQZvgnwEKA3d3gRV
 e15hV818
 7LnvmNKNXxNGiMM0Q2QkXSn5U5eiQLyJLNSlwvlqhBcQpj2SdFY2m4HuZweev6yml6h6bYqLskcup3FL/u7oOyonFaAPqLdkU/heo61fzRRk6Wlr5lvAp7lxJS0v2pzh/hHJVJC+NwhPLS63FbiPISf9gNWX0qEMtRiM7jEiz24Hch9LoM3zCkcIukxlDrOEw8I+ww9cKAzYPbm3/atNEJGaybFMffWMxdknY1hAZOo97sGlbwxVTLU7I79MIaXQpRsBso8WtFIHCxNL0APAhhoacRW2Poj7AZS6tfjbfU15az0VqPhr3YTTkzz8SUMhExlx1FMfV52B3GeqqG89X0AHZOvqHun6ILtfDjEPMvEuf9u4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/28 16:52, Muchun Song wrote:
> memblk_nr_poison_inc() and memblk_nr_poison_sub() call
> find_memory_block_by_id(), which requires device_hotplug_lock to
> serialize the xarray lookup against memory block removal.
> 
> Take device_hotplug_lock around the lookup and nr_hwpoison update so
> the memory block cannot disappear between xa_load() and get_device().
> 
> Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Thanks for update.

> ---
>  drivers/base/memory.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 6981b55d582a..f76aee29e9a5 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -1228,23 +1228,29 @@ int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t func,
>  void memblk_nr_poison_inc(unsigned long pfn)
>  {
>  	const unsigned long block_id = pfn_to_block_id(pfn);
> -	struct memory_block *mem = find_memory_block_by_id(block_id);
> +	struct memory_block *mem;
>  
> +	lock_device_hotplug();

memblk_nr_poison_inc() and memblk_nr_poison_sub() are both called from memory_failure() context.
I'm afraid if memory_failure() is triggered while lock_device_hotplug is held, it will lead to
deadlock. Or am I miss something?

Thanks.
.

