Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81EFBFD5F91
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 07:36:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1BD6B0088; Wed,  8 Apr 2026 03:36:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973396B0089; Wed,  8 Apr 2026 03:36:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861736B008A; Wed,  8 Apr 2026 03:36:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 77F5E6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:36:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1734A160A45
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:36:22 +0000 (UTC)
X-FDA: 84634580604.02.D75E633
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0C7DB8000D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:36:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nBN6TY5G;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775633780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHBxpCe8VwSq3CDbulhrrdaBqwIRC/vJocbp0QUE9l0=;
	b=coQfXwzsDo0bUKQ8ykCzGl3Rm6rba3+/9ubEQMAMOpOz9C8eepE5bYCvab8DqhouR3D0f4
	SdI9JajcjAqZXLmlzjOmylIaxH9BEuZNRaLmWFVO0PHn7yj/a3HdFgXqkE019febPgPXSE
	7ghKrsZKj1bcbxGaB6ErC40lA588FoM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nBN6TY5G;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775633780; a=rsa-sha256;
	cv=none;
	b=qNpxTnr/bYmPOFLkGeOY8qza2rY4Nlmg+BW26STWsCvU314CYwlUWCbvZ0DMR//9UHh18c
	ng+hazaAtdsZ7IvVBsYlsopRhcDtoAXQ+TY8Tvh4/9Y/a3E1qO1JdNaOUUFfsXf6TPrXPw
	WrDNbxS4OrgsBYP4KR5tIWbOAzvTM6A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 082CB433B3;
	Wed,  8 Apr 2026 07:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358E3C2BCB0;
	Wed,  8 Apr 2026 07:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775633778;
	bh=9usUKozMxTM5/KPBGhFL/Q5Q+WRhnI82yaR3J4yHm9A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nBN6TY5GLLWEq3U7h/9ZirccALW3l4Tx4ivhOSx0sUKHGA1kyxKWjil3vxw8CK7gz
	 yf2xzlKeYUJE2n/u08fy7XYLgX2ZBHpzeQxy4h0c77nWZVYQvDc6naZandP5Sw6m6b
	 8G9WHeVeNCxTVeT4FX7uNn7Ff1JEhX/9T6K2Kmmdy1CGD1Ku7FjSDuCwncxORKyg4e
	 /9TiGZ/AxuGYiZ+i81To3jOOGzRkWUs7ybxqkYExRifwGqkjomQou1PqeXGRR4wtgE
	 WMR1WF2XYtJeGlsYVfOrqTplvmhEXjc95oPGAu1xNYXtDNcmaTj3f229tLgjytv4L8
	 UI0J61zg01uaQ==
Message-ID: <17b821b6-0176-43d5-92f7-fe2a0c4f70cf@kernel.org>
Date: Wed, 8 Apr 2026 09:36:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
To: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
 Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
 Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260408031615.1831922-1-yuan1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C7DB8000D
X-Stat-Signature: x9xgqgcf7hm4eau8ysmmh6khqcbtpjcr
X-Rspamd-Server: rspam06
X-HE-Tag: 1775633779-744893
X-HE-Meta: U2FsdGVkX18EGhvSg6y1z1F9g6l9ddK5xrGZiVUMNGesFzeGG7uFM+ilIAUbg/nBJd2I4qDF8KxiCtrzowwCxEgWuA9UJGE1mrw1zYlGTJE5hTy+gTU8xFQ5aYuEwmVR8YelsHVcqUxqWPQL01CQMAjPGTbrYBTDBYm0LUXLWYfomAntzSz9k8PG0jX2MD38CRM32uA6wZJXBrS7vpefqRPL1qxNHTdU5Zp+0MGL5r33tOduG5pze5FaxWhC5160Fdx4G2EuDRGYZ1Lg3DmdR7qmrV++T6ceaPtfkZtnL6N4kFnuyiRW2MjtxBIbpkIPjZwl5PwLduW3tkV9aSYrt13U/iNYgi24wWer6s58i3RjIiSgqzo31apDjhCkGZq6OeXWfDeAVEVeOuRUhXbkp1ML5Ee6Y+Xczuj1szGLXe7GnAJSIb/u77h6JudfHFViTXXJZv3wquzsRljf2wLlSSggEzTgMU0cG4UQ5x9Xh60N5Ymv76rCdPFMP1fVmFGOFY3b3rmzPk4Fm1iM09qeSV8QunmkDWtTBeKCk2ct0wm3Z6iZWbByUwVKxbTw8NuT1DZjzNoXW9G+wGBrc0ntdGEwMwIDXERaiYK5gCphAHM9Y7z90pTRtEo0C/PdL9tvtr9NSSUfl+QSL0j7gPnJJ7IxidSdYvWZu6T/brBXiRPsZaakXc3uAR92w91DuauuGUY4jNnydZ8cumOWO9RgKg4FvG/aMShIZE7fvc2qqrYI51GCf4xkL/N0pGSsohc3xSrMVRV3u9s8kxv88LgYXKBMT/hk6KpiLOLh/UTq8cz4FQnWv8zZPUqQuIVE2BSFKe8Lv2iBh5v2xNKPjmr4a9f4Z8OfgbsQ7Hq2y8Q/93m+vuf+zkOpgzDQrbvjxENGhAitCVritCRr54uqGO9t2/3A+rSitokgVNIiaqgHbgKBrzWt7SLXocO9gfFdr2XY6xf0dYdxwUnVBxw+i13
 Ekg7hQrb
 zFFd+fcW2LA8SLTZYwnyAAUTlxTQiR7E9wHTvhDGbfLRFgHGfKSaU/PeJf3aB26bKZHdMdRHraDxULPg9jMGULpE8MHwokaaO8CpBqex530HpWtkZkDvvPc5IjM8R9HtR1/M1xWdJ83RucMAlp34et2D0PY84VZwOuAadfH883U0NPzpdvp6CtSjosovIHbiMU5S5BnqQrQPaZzU4g23fNvsTsrAG1PxYqw0HjHT4yztn92BSBOQZ5x+WASSLA6cyMj3MahgWCmF8Q8Xx/v8b1N85rWmiw5znWX3TjpvT3+qbUKfZYyp5DEHy9Cujslvt0+VBcx8jKUh4pr4ez/Jdz6xZvKbcoqsxqF0xLkGI954HDN+oxcg+lECihMCCOttFj/C/O1SdK/+ix7EPjJWhXWn7RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 05:16, Yuan Liu wrote:
> When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
> zone, set_zone_contiguous() rescans the entire zone pageblock-by-pageblock
> to rebuild zone->contiguous. For large zones this is a significant cost
> during memory hotplug and hot-unplug.
> 
> Add a new zone member pages_with_online_memmap that tracks the number of
> pages within the zone span that have an online memory map (including present
> pages and memory holes whose memory map has been initialized). When
> spanned_pages == pages_with_online_memmap the zone is contiguous and
> pfn_to_page() can be called on any PFN in the zone span without further
> pfn_valid() checks.
> 
> Only pages that fall within the current zone span are accounted towards
> pages_with_online_memmap. A "too small" value is safe, it merely prevents
> detecting a contiguous zone.
> 
> The following test cases of memory hotplug for a VM [1], tested in the
> environment [2], show that this optimization can significantly reduce the
> memory hotplug time [3].
> 
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Plug Memory    | 256G |      10s      |      3s      |       70%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      36s      |      7s      |       81%      |
> +----------------+------+---------------+--------------+----------------+
> 
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Unplug Memory  | 256G |      11s      |      4s      |       64%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      36s      |      9s      |       75%      |
> +----------------+------+---------------+--------------+----------------+
> 
> [1] Qemu commands to hotplug 256G/512G memory for a VM:
>     object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>     device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>     qom-set vmem1 requested-size 256G/512G (Plug Memory)
>     qom-set vmem1 requested-size 0G (Unplug Memory)
> 
> [2] Hardware     : Intel Icelake server
>     Guest Kernel : v7.0-rc4
>     Qemu         : v9.0.0
> 
>     Launch VM    :
>     qemu-system-x86_64 -accel kvm -cpu host \
>     -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>     -drive file=./seed.img,format=raw,if=virtio \
>     -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>     -m 2G,slots=10,maxmem=2052472M \
>     -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>     -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>     -nographic -machine q35 \
>     -nic user,hostfwd=tcp::3000-:22
> 
>     Guest kernel auto-onlines newly added memory blocks:
>     echo online > /sys/devices/system/memory/auto_online_blocks
> 
> [3] The time from typing the QEMU commands in [1] to when the output of
>     'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>     memory is recognized.
> 
> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
> Tested-by: Yuan Liu <yuan1.liu@intel.com>
> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
> Reviewed-by: Pan Deng <pan.deng@intel.com>
> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
> Co-developed-by: Tianyou Li <tianyou.li@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

[...]

> @@ -842,7 +842,7 @@ overlap_memmap_init(unsigned long zone, unsigned long *pfn)
>   *   zone/node above the hole except for the trailing pages in the last
>   *   section that will be appended to the zone/node below.
>   */
> -static void __init init_unavailable_range(unsigned long spfn,
> +static unsigned long __init init_unavailable_range(unsigned long spfn,
>  					  unsigned long epfn,
>  					  int zone, int node)
>  {
> @@ -858,6 +858,7 @@ static void __init init_unavailable_range(unsigned long spfn,
>  	if (pgcnt)
>  		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
>  			node, zone_names[zone], pgcnt);
> +	return pgcnt;
>  }
>  
>  /*
> @@ -956,9 +957,22 @@ static void __init memmap_init_zone_range(struct zone *zone,
>  	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
>  			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
>  			  false);
> +	zone->pages_with_online_memmap += end_pfn - start_pfn;
>  
> -	if (*hole_pfn < start_pfn)
> -		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
> +	if (*hole_pfn < start_pfn) {
> +		unsigned long pgcnt;
> +
> +		if (*hole_pfn < zone_start_pfn) {
> +			init_unavailable_range(*hole_pfn, zone_start_pfn,
> +					       zone_id, nid);
> +			pgcnt = init_unavailable_range(zone_start_pfn,
> +					start_pfn, zone_id, nid);

Indentation of parameters.

> +		} else {
> +			pgcnt = init_unavailable_range(*hole_pfn, start_pfn,
> +					zone_id, nid);


Same here.

> +		}
> +		zone->pages_with_online_memmap += pgcnt;
> +	}


Maybe something like the following could make it nicer to read, just a
thought.


unsigned long hole_start_pfn = *hole_pfn;

if (hole_start_pfn < zone_start_pfn) {
	init_unavailable_range(hole_start_pfn, zone_start_pfn,
			       zone_id, nid);
	hole_start_pfn = zone_start_pfn;
}
pgcnt = init_unavailable_range(hole_start_pfn, start_pfn,
			       zone_id, nid);


LGTM, thanks!

-- 
Cheers,

David

