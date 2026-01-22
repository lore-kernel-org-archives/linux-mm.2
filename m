Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE04C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED69C6B0146; Thu, 22 Jan 2026 06:16:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EADCA6B0147; Thu, 22 Jan 2026 06:16:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE3FC6B0148; Thu, 22 Jan 2026 06:16:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CA11E6B0146
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:16:55 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 616C9C14D9
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:16:55 +0000 (UTC)
X-FDA: 84359347590.05.2832690
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9932FA0008
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:16:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CUNYyx8c;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769080613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkN1LMC8YJWci7qXITb7/bYx60UUdi60yw+/LDMrxf0=;
	b=yupw8zZCORtOko3fIr++WlpCLcQI5gELqf46NqS0scBem9Y2qMEJoP3sy/HGtUuweSJMGF
	6AC+W6U68PTYLnHgDesNFXp0X0BBTr0tzKfaGQZ64dH1cbfeXUU/zg4TfofXWU12p2860r
	NcejjL4N8I543gshRb9cSV7hSIYbY/w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CUNYyx8c;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769080613; a=rsa-sha256;
	cv=none;
	b=xq3LpK3dsjLA2EXzQ5hl62qB0MQ6yPLR4WwNgUaumZ6fHQ+gYXO/eQ69B79j9PT2QhnQ4I
	hU9fHWzvCbdkuNcvxwk4X4GL9oDU4zwz52queue9vEc6nxoiZbCrJg282PThxDQuaAy74/
	706dyNUEHrIPN92kN+ZKKrHV20w769o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BC7A409CF;
	Thu, 22 Jan 2026 11:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF819C116C6;
	Thu, 22 Jan 2026 11:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769080612;
	bh=W/bJIzm3jSTgWiWcFxMKaaTTJUXpslY1VhhKcx5v7xI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CUNYyx8cfhjh/ngKFyNusCJPTPD77D53HIlqiNow7NmMEDs2H5VvBVmHsIs5q/LR0
	 bcZjPt8xm/BTSKGHldQTRheQ006nnUjt7hTzvzfzWo/oCmx2cF9wV4kH2DV4fuVRrG
	 Hmzg8QKxSGQ40xLg3O2HDHCMNFascA5AMl4LWF25igFMjWZCV9pPh1hOIBxpB/sGaR
	 0P4sPHo3eys1QoJE8GsyaIMjgjlhPEvFa3Xf8PodrRaZeQzAbwBf5FHtul70BgIj/y
	 zzKkezo0d09mlIVbgU8EON7IajTYi1wE5omU/4qHOTWdEJl1u3KbsnbDyB5ehMo7pc
	 oF2ygtkUhskGQ==
Date: Thu, 22 Jan 2026 13:16:43 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tianyou Li <tianyou.li@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/3] mm/memory hotplug: Fix zone->contiguous always
 false when hotplug
Message-ID: <aXIHG8MQhMRt7M5d@kernel.org>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
 <20260120143346.1427837-2-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120143346.1427837-2-tianyou.li@intel.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9932FA0008
X-Stat-Signature: bcz4wdnnbypw7sr8n8m81r9qnqkqhi4p
X-Rspam-User: 
X-HE-Tag: 1769080613-695754
X-HE-Meta: U2FsdGVkX1/TLp3En5XrpoPkkvuap/DFYd6U6xAhqJQkqbbDVprMzcGirao2Woyz4Ga52uwo4YRKXJOq9zltrqxjZeWwWoOxIn2eFScpn8+0zTk5HvuSAtiIXHRWVUxjRhKVYcMv6HkpH1PZsrVud9fruKyRO2DtCCLEQABKSYHez1/alOrvyGCYQxfQ5n2PSdS7NyvySSBxVV/io3uHXPioDZMNSeRWTBuQwnTFAyjDKMOaI+MGgDflCNysrY5XGo0xKApOhD+bQPfed1hufJWMF0+/B00skO0XSd//AnOs7FVofXRS8lQTs+Wj/NUB2uecv+JFRtdz9IJ7bwNwW+lXI/87NEFSOSE3xtit7R4XJTuTAMRppEzLUs4GwBsZTv8gOuvVpz4N+mFm5MpPVtVaGN48XlhqN06V0SYJ1pISlD/9BXn71zFI6JICpC6Gr2iij7NHJPpM11XEvIB+gOhbtMlai3GesWl4jK+ekJVBOFAt4Tnd+5Cb5xKGQRE/mrZxN8/O+gP6rj8o1AIqK9g0WEIWH4VjDF/fGuvxs7QabHPYXNsohd7XR89f/9xBg41JKnvnmGBLHxW0OMiZnNGT+kH1/giz0Rxc7ZbIVY8Og9f09F3H1hq+09lGkOkVuJn/+Dj3MWwSSyzeBYZZgHsRYZu7Fdy3ij757DbphrPKV80k3Yx89IeNlW8lvKJE+QqFkrgW2CRh/EDal/YdMtyF/SOMbmJUB/YriPkSJ29zgQUUWQNeD3K4AdcrBBueem8oxspX9KkaMmh2HaEW+J4Yzj//C/akEsGmsQ0iGSahi6g7YEbnUtIm4eDDXa4SiKArwtwxLGCk+O/Rf4WYWOd07/yvbK3PZwbYTBC44suZEY46ckZfzPpj8WkEyBS55FmpixHXx1dbzDPY1r8mXKE9KeOPd1j6CnUQVUVxj+H7lO/wFwakocBVc1W+YOgNP7zTUX2tl8qXvjr4hpd
 dvL8QwIS
 +cR6iNt9e1h5phiDa3jB7DFZAahGzPo0xnB3xLjQdQ9AyT6OBBOyf6xuwbYCZLgSdlRoNlpzU/BlAs0Ne5Z/X0PXP5cclMfl82DnuTmlAi7z0gyqBLs0CJy1T2brLv7ULfDqrjgXVOIX9edbmqq/2WoQtDe9sqeiXfhG1Vv4ib2ZAi3enyVj+lAkH1j/8jRnSWDqWqtHtQqFvk17yJUoK5GHP8r8vxUez5dcooSg2FD7Zl4qaEtj5vCz4FvIB4mIZsqLHHpIuOEnji25drwzjxBFyg3DiXYBYvt/81bTbq555fQaGIpm8/6g5pgfo3Qwa+5jIxCnDKdM8QST14NP1sYTZfBkZjRLw0vo8TUA6Selu0URR616OkyAr8vnXpvef2/tsfcD4midH24kYuSrHVYXBsPXbZlp3uJbQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Jan 20, 2026 at 10:33:44PM +0800, Tianyou Li wrote:
> From: Yuan Liu <yuan1.liu@intel.com>
> 
> set_zone_contiguous() uses __pageblock_pfn_to_page() to detect
> pageblocks that either do not exist (hole) or that do not belong
> to the same zone.
> 
> __pageblock_pfn_to_page(), however, relies on pfn_to_online_page(),
> effectively always returning NULL for memory ranges that were not
> onlined yet. So when called on a range-to-be-onlined, it indicates
> a memory hole to set_zone_contiguous().
> 
> Consequently, the set_zone_contiguous() call in move_pfn_range_to_zone(),
> which happens early during memory onlining, will never detect a
> zone as being contiguous. Bad.
> 
> To fix the issue, move the set_zone_contiguous() call to a later
> stage in memory onlining, where pfn_to_online_page() will succeed:
> after we mark the memory sections to be online.
> 
> Fixes: 2d070eab2e82 ("mm: consider zone which is not fully populated to have holes")

cc stable@ perhaps?

> Cc: Michal Hocko <mhocko@suse.com>
> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> ---
>  mm/memory_hotplug.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a63ec679d861..c8f492b5daf0 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -782,8 +782,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>  			 MEMINIT_HOTPLUG, altmap, migratetype,
>  			 isolate_pageblock);
> -
> -	set_zone_contiguous(zone);

move_pfn_range_to_zone() is also called from memremap::pagemap_range().
Shouldn't we add set_zone_contiguous() there as well?

>  }
>  
>  struct auto_movable_stats {
> @@ -1205,6 +1203,13 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>  	}
>  
>  	online_pages_range(pfn, nr_pages);
> +
> +	/*
> +	 * Now that the ranges are indicated as online, check whether the whole
> +	 * zone is contiguous.
> +	 */
> +	set_zone_contiguous(zone);
> +
>  	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
>  
>  	if (node_arg.nid >= 0)
> -- 
> 2.47.1
> 

-- 
Sincerely yours,
Mike.

