Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7B51C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A5B6B0095; Mon, 14 Sep 2026 23:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B0C6B0096; Mon, 14 Sep 2026 23:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20866B0098; Mon, 14 Sep 2026 23:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD3F6B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:52:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DCB61402C6
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:52:34 +0000 (UTC)
X-FDA: 85214624628.14.8030E75
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3C35D100002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:52:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=F5yUp1ZH;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789444352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJVUgxZ6Z7SyN6ps4x16I8lk10PKOfHTk2RT2VqVrOM=;
	b=4yed8lxFPRly9bhfkF2BsYTVAUuJThVcFfBR80g1mgE6NX7ld5xkD3AEcH8UIsrEFsEmFv
	L8z/olaLIds9Ta7L41N/Js5z9r2MjREkIsbeY70fmHcS5R8iyj02AvR+8eBUTtZjOmlTmL
	rDi/F4PBgtU64W42QVVAWOaPZNIwbLU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789444352;
	b=lJ0aElpym3Hgp2QzFIX6H5Ne94BP/JbWKsC9e2GyXLlgwyoTSUpWLzUwKwSsE0Kv7YYRHF
	ZkaR1uOkckJ5483u8wLv/IxoR0BjzCdPfM/1RxUyy2rURqJJDL3bkCuJrkyNvCy8CCg+OL
	2c7ZOZ5T9s1lqBb1OIEF+V8zTB4kyek=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=F5yUp1ZH;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E6AA1570;
	Mon, 14 Sep 2026 20:52:27 -0700 (PDT)
Received: from [10.164.19.33] (unknown [10.164.19.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C3663F7B4;
	Mon, 14 Sep 2026 20:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789444351; bh=Co6SXIL0Bncyw5H+la1E66Ec/i8oPza1k5EsbVdTuhs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F5yUp1ZHoPolXZeL2ixVMvITqQi5Z/TW2mpm07PlQtH+pCqBJDqMSskR89AlSqbPn
	 h2nsK4H02OHf2rQSyH+EyGGwcVW/DTcdxwRPq1ylTuQlyc3Ry39lxBDEupZJ+pkeRx
	 yUhPktMNKmQ4DbkhtcuwMnrmq8PknY+b+GOrM1k0=
Message-ID: <e9d2c977-fd94-4e3b-a859-99d2f7c06818@arm.com>
Date: Tue, 15 Sep 2026 09:22:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/vmalloc: group xa_init with vbq field
 initializations
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ye Liu <liuye@kylinos.cn>
References: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
 <20260914-vmalloc_study-v1-1-526f68559706@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260914-vmalloc_study-v1-1-526f68559706@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3C35D100002
X-Stat-Signature: dqcs766qtepmkwnfchjxe8s1e518j1ob
X-HE-Tag: 1789444352-7609
X-HE-Meta: U2FsdGVkX18MY9G7zvZZfc8P+8O6jqUvt3RBy2r0HRX0Oy1gaQhMJDIPZxPf8LgTwr12hV2M1mU6BDKy5zGRlwt5qL7awiEg/ubnEPsh0o7XuXu+AVSyi2IhkyToC8TOCTPer5wa4lDYqOT5DFkkADoB9M7mp42AVfm3Z32vVby1RjIPOd3zpDOq7uoUGtKP2y4ATt6eCXV6/eogBDtiQNGxNxC+L4XJ6vBsOClZTgBxYnVC7asLzaaXgKa9WEqkwIYdx4fikLQAjVZA/Rdew2DLDPhMp7V0tEMbaKyKyhxHRzWI39M5VUch/Hsa9GKiAUDg6hlPXKQ9tjv1alb/Cu7lUAJThoU9ynaR8O1MpprwNItNj/zziblHgkvdB4Jr07Fj1Jo8wkK/TKys0rJd/zd6u7Ri3y9d9DzoMgX5UC/05YfYYugVpmqdjWP+180om52ryOva3YTcmP/pkNb13/LTqJ/pJeHoQNWY6yiKlRBrjVrv40VaQMIr5jZbxyWeeazBnciT38Eyv+ofnpoRW25eBcwH7xgVKMT65xvtNJfvQXbDbkKmn6pnoTOQi7mbfwIIhLAKqUad3v2JX/xCJQKkbTPT9Mi1KA0tx1qTEyBfZq1GVND6Ie65Ub761bI3PH3OBYHI/AfpREjalfRoxaNUFDMOSJ8kQpGP+jcrURvEugTHkyb7UKgMy6vTLldF8DDtZm6zTE3MER5QoiDYFCd/Nqi32wLCsVgmLzQYItR+0ezG3AkrUDAPIrY3OCZNB8m9IS89mX84wpxTQ/R2M1q+VdHQwdTN3byJXqHde23VkWv66atNPU1/KF/O8uNY3wf199qZRIn598415I1QA3XYBSoZjsi88vkPNHTyMnaiwfwryz1Ri1X7qvpsknOENXWFey2wVz5sQyc23QMslxEYylUD7+s9BEoJK0Ah5elB1T4klX89yUnL1bljJO+7S+qPs7KfVHgPSXx5Wb5
 +1JmbZM+
 LXZaRoQ9u4tfKSFjxOpbOPJDZypFlWqzfbFsAY7NVwA7ZatKustb81GmsFihqfHu63HU9rJbSeLUADKl0XKWr/poQKsQ/WFQclIYKXYrcalVV/XlteELrVKiZ1jMMjHkaI2Y6YOPcx+Ly2zhJQAQAP10OLeXrSRR/XpLLKzNPQIDPAo0PyePh0qftl4S6HlNt3ZjRD/vh7T891KeJwFjux7tKcHfFfOc7uDfzR2awyR9Jtou2pW7IOUQ3sVhXAlLCJQg0D85UsssqIXcykMv9Ww+0a4LvzNGy0J3rc7+ZIfr+S2PVvviARthvOgi2455AT9qlyJO9Ab9azufDccngmfkS7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/09/26 9:04 am, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Move xa_init() next to the other vbq field initializations instead of
> after the unrelated vfree_deferred setup.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---

LGTM

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  mm/vmalloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 859e6d2d57a3..117483dd048c 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5585,10 +5585,11 @@ void __init vmalloc_init(void)
>  		vbq = &per_cpu(vmap_block_queue, i);
>  		spin_lock_init(&vbq->lock);
>  		INIT_LIST_HEAD(&vbq->free);
> +		xa_init(&vbq->vmap_blocks);
> +
>  		p = &per_cpu(vfree_deferred, i);
>  		init_llist_head(&p->list);
>  		INIT_WORK(&p->wq, delayed_vfree_work);
> -		xa_init(&vbq->vmap_blocks);
>  	}
>  
>  	/*
> 


