Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09FACC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 04:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC826B0092; Tue, 15 Sep 2026 00:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876D76B0093; Tue, 15 Sep 2026 00:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 764FD6B0095; Tue, 15 Sep 2026 00:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1566B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:23:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE9524030A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:23:17 +0000 (UTC)
X-FDA: 85214702034.25.A95060E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6E1701C0004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:23:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=laRA6TOX;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789446193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3bE1vYcJEMZwgNZJdDvjq7N3pDZZTBMPutYCe/LGKM=;
	b=TCVF0f7BAbBspDRmbr6dG5QVz///fgqlkh7u/ZquCveD3hIEViL3mHwc/h1A2JEN99A6GO
	xpWuLsN+5N+bICgl3bPePc88oBPREaAGSlXUFHs30NCXt1P5YdHNzyA+1zPSGQqQcDjZtb
	oivnPnWoF4iFNT0apS5liVSj5d+xlXU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=laRA6TOX;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789446193;
	b=EtiwreQ1E4lnc7J5LCmKD7ANx6JzFFvfEXz8gwp6ZUuiZjdf+T9+GMTRWcKhlv+MpmVVG5
	MxUzN/rnahEzPNojDwPWv7PXh1F5XSJ9xq3KAe/N9nGv0851OxBO7iVIlRP+eDz42ktAo9
	w526SenaZ4T4iApw+3XWgh33rzqbYzE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA1CA16F3;
	Mon, 14 Sep 2026 21:23:08 -0700 (PDT)
Received: from [10.164.19.33] (unknown [10.164.19.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D6D5B3F86F;
	Mon, 14 Sep 2026 21:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789446192; bh=QTihovuoYTHtrWdsiydIKBnDHHDBkjzHaEXKFHeEaf8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=laRA6TOX+7Wq16OysZ3VgBnqWdJeIUrsYRlPTMhc8ZVylWTgY9bJxhHO/h/SK5BeB
	 w1m3+S4367IkbYhXwa+NVuU2U4zrRi24asaFI7jDgbNmlEKUdewsGao+5wnaBeERcJ
	 RWrAY5YmLx2eqY3yqBKii1rLzKGaEWD/keZ9+9/s=
Message-ID: <5f1f4e7d-909e-4622-95d2-c4ab26c567c8@arm.com>
Date: Tue, 15 Sep 2026 09:53:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/vmalloc: extract show_busy_info from
 vmalloc_info_show
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ye Liu <liuye@kylinos.cn>
References: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
 <20260914-vmalloc_study-v1-3-526f68559706@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260914-vmalloc_study-v1-3-526f68559706@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: g45rf3roi5rrspkgj4tfbb5nn1u576bk
X-Rspamd-Queue-Id: 6E1701C0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789446193-526944
X-HE-Meta: U2FsdGVkX18V84NEwZsyx/maN4m574FkEeyaLOaHOXjtcqd9174LzSKTOvsQW7TyviBcJQi8R8gVbb2c8D8FEjwzAgtb/YxyEbEL8pbASAUWmrpx1zngy0KViFSox/nyd6tjwIMtKqbGFUbF8u6x6y1DVbv8QjAa76ZwwcEczjQvgTmodGE47NHl7cBuGC29lAcBiu2Euz6CufX5emEe1SICj+bsX4oKjubXJOGapq6mgqsE3tUQrLPhM7jAG+VKZFjZ1yeZak2gPxXsR/GcwHIqdYJB09k4xDiE5u/eoAMcx6un1lHo5aKONdHc57uO4Lv2qWIGuMw529MaCLFnO6jFnyfZp9rOmMoOWUyrXWeT3xar/jwbLWQJAcPZy47EMcBTeRzaDQzlfwaXApkLqki0OjOxxNc8fgS6Us/BKcLsJwMzf7kjUQAj9Ayz9IKJK8kvzcij/UoWODgIp0E5cfpJ2nIrchbuJTmnVy5ozV6yJ58UKwLOEqml3JeiFvNSpIzecAdc18BttP27Ac8WbriPeF/grENheXOuAjk1H+Un7kEtJoHpozrkujO1yqtubkZL4FL5QWZN2dLonQ5H1Vc7qxv59T8fcErYZj9sPIUF24d38ZgWZRJZdG6+meZRNiTdr70u96AlbmT2XkhRyrfv8T4U1biJmefqh8Uw3itdyT9HVyfdv5KgkUHikImmckNM3zLOXEjCxkC4No7SeSm5G+qzP6lk0UB17c/qEnCTBC2tjEewUXm2B2s1Wbw5IQNDxwDtgwqLE9hTM4QTdyf22UM3EfeSZYzjltkGWQ6UBS9iN/F5cwbF9RKU/uvdb5AiB38WMFsbPSwjyFzDrLjnMWawUCPAIwTK09PG41gmPUzlFWx7VAwTIHEF2P+6rvZYyHIXjAtRVteex1T299J3mfzjWNnLQK6lpTzAUt4K/219UPw+JcmkioS1ZmlAbV1GKyHrjXNAeto6As2
 PpxjFk6B
 fLvgWJ/E8o/pQ+y153hkh+apxF08X1oX8EGPhxF/9W4MLEsnxx4YUf/5UanVvifL/D5Es3Kw2hKRjqXlTTYXCqMVylAe9Eao67m/7Ok0rN5/ZCJPRoPOzH9wErNeJhYgXn044pbpghq7Xu7BS6IRNRQO8zdIcNYoOa1IL+BxajB1hossZ2XYBxlLlA9c2LDYS1E7bPaLbRN11nctpejENYr6jIa724o7Yt6NBfU3m2HUtsORG5PCXTqlrQfN38hg6/GfTS/zV9Vfvz5yZUfG35zz0NCMRFzcyQD7CFdaJA12fFoeaEjUYXq0d8QdAVvp15txhMAdvn3iDEF5qsQQ2vujU0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/09/26 9:04 am, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Extract the busy vmap area iteration into show_busy_info, mirroring
> the existing show_purge_info pattern.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 797933ba9451..7638845377f5 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5345,12 +5345,12 @@ static void show_purge_info(struct seq_file *m)
>  	}
>  }
>  
> -static int vmalloc_info_show(struct seq_file *m, void *p)
> +static void show_busy_info(struct seq_file *m)
>  {
>  	struct vmap_node *vn;
>  	struct vmap_area *va;
>  	struct vm_struct *v;
> -	unsigned int *counters;
> +	unsigned int *counters = NULL;

As pointed out by Uladzislau, setting to NULL is redundant.

Apart from that LGTM

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  
>  	if (IS_ENABLED(CONFIG_NUMA))
>  		counters = kmalloc_array(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
> @@ -5415,12 +5415,18 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
>  		spin_unlock(&vn->busy.lock);
>  	}
>  
> +	if (IS_ENABLED(CONFIG_NUMA))
> +		kfree(counters);
> +}
> +
> +static int vmalloc_info_show(struct seq_file *m, void *p)
> +{
> +	show_busy_info(m);
> +
>  	/*
>  	 * As a final step, dump "unpurged" areas.
>  	 */
>  	show_purge_info(m);
> -	if (IS_ENABLED(CONFIG_NUMA))
> -		kfree(counters);
>  	return 0;
>  }
>  
> 


