Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A2A4C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCD96B0088; Tue, 15 Sep 2026 02:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8F806B008C; Tue, 15 Sep 2026 02:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C076B0092; Tue, 15 Sep 2026 02:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BBB76B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:04:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D35B014029B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:04:02 +0000 (UTC)
X-FDA: 85214955924.10.B9210B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D336CC0004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:04:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mMAaxlNn;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789452240;
	b=eKbkz6k5QuSsbIo4mI7ck7xk07fsCKs++C4fNF/w3i46zJ4VQsOpBsRozXyUF2hLC5IoMD
	g7ZOBQNr2e1am77laPAAyExYql6gyIxZVASEJgMKFhfLGjPAEWx3vhqA+Hk1QGsqEb6VCF
	GxCx992AWMX2wSzeGBt8EAnFlXJ6d+4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mMAaxlNn;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789452240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vCQE5R3+C/PNtR9Gpe0u3TKggkO3uc52l+x3OETu2o=;
	b=dhenfEroDLz8NlMv64V61xRjZJ/ruiu4tJa/m8em0ye7Ca3FMdvmh1hvKpxbYrd6nOFGU4
	jBZm9b5waxHqDgOiXRUfsLZHsN56fqoqfgVXYKEeiN1slGTZ+DxrjTr4AiDPRv2I3GdAZK
	xbYAdi/aUiKLI76EBUEftjQRTt53CoI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 522F3600D1;
	Tue, 15 Sep 2026 06:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F4D1F00893;
	Tue, 15 Sep 2026 06:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789452240;
	bh=8vCQE5R3+C/PNtR9Gpe0u3TKggkO3uc52l+x3OETu2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mMAaxlNnxdyl4mQxQyS/wkmDUx3chMaHciqE9DrDRwHke7Oyow2NxXwO8bFqHRs6Z
	 HQ/HbnfmXSgMapZcx//yZOtdcpBvP1pr2FSVxJyLQ/2CiIc9xqC+wc0IF48YOihe95
	 KVzUKgKfirySdLJY0oXOyyaUWo12vbxHe8UNYJMa0eCkfqlZM3bZFFcPPRXaNM5X6u
	 gzQCnmP5s+lGJjhCJ6m7ObDGNU0MUiVSgRTN/XfCTi6Fr75Dx+NlUlicWK2IqCFWjA
	 OfqeeLZaMsCBzYq3GhCQkALmwm5CtO4MiEpo0SqgdfLs6RCF0yheIC/HXVxKr8dJq4
	 Xn+Cg1UCgEWxg==
Date: Tue, 15 Sep 2026 09:03:52 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>, Chen Yu <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Message-ID: <aqjfyGeQaL4g2EcA@kernel.org>
References: <20260914072929.1883794-1-yuan1.liu@intel.com>
 <20260914072929.1883794-3-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914072929.1883794-3-yuan1.liu@intel.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D336CC0004
X-Rspam-User: 
X-Stat-Signature: pyaxrkfdrp6qw6posppttio5f7sunndz
X-HE-Tag: 1789452240-56153
X-HE-Meta: U2FsdGVkX1+LD0SZe86mmSYBpmbvTUuvWr8V8OnaE1U+WdQsYGO8zy6UiWD8YZx4nUTOoDrM62MTFfX1GFH+3xJ1/a1eQX3daohX3T/NJo4LlYYyxsLBq2/HnC2GAWOyhJrkPcGG/3+IhiP+V20Q+QC0h4NIc6HyV4hwT3HzumqxrUKVMq0WCCksTIEWdTycReu8FcgO2OC/4oidShUHn9rcG0jzwNKfdsQx2OEW+dBm3G58WxYOl+DzfqvM4tOG/SnNbi52tMAbU1U6Ctx2wIzURrBOsUSniRk83hdyFOHpgzpyfmgPTsWCtgWfoYCCkpRZmml1jweZ/t+CLsBF7ChHm9mlYzM7t0KeXtOxzpRGVFrxvGLPIsyKUtReKisQ4QfAwW+S261ZN5JudpNhtFObaR+I6RbAftxsk3ZR95m6EG5tyezpMCaUaiNHGFNL/4nPHjdtuOihfo14I96nzGD0QoQBw93hNNtKXGJtMkB6irEy5LlQKwCStWYs05dvwSfSnfysmcpVtQe2oG1Nu8VHtezHVbMvOqpnBH2//XofAAt6+I5O5R10sfFk1ISz2gwlUoJank0Zlgb+Ps8mtuZfX5YvuiNXbd7XrVsam3bzED4/YSYmkLZKC1zD6g3bk54O1qb9g2CT/Eb1bH0gB6MUpAJHvNnlz7h0i3Qfh4/XaG+/5rC1NqQFJBvSrOCm+znRqAUiC7RQxceyGV4qJtkqTklDp38PioQKIKptWciOakVcXILasCrzIExTTdFBcnobZn+JKv7FYurNezRW164Y//sRsyjj0vixvqJ/77h7RwaUIE13KUvrC7GO/sHzsR+biOEN6uzqixiEv6X6MiWQPHFk4vY1n72lX0kf8AKXrvUGLxsJEbFukZT4gNOGCSvolxQLvjW2hXfMMJSy+vv05rfT9gEy2SC/m4yUw7m9D1OAvzpGxe5wF/RW7/LniJoj0j9fV7+nydO2YPN
 5a+deCy2
 Y4DUZVr5RTH42SKYqJ8nmtgxtP0zsgKlowCsWcXJhuH1WxbZMAWvbVFk9O+RUs6CYFmEplEU9ROqlJExP41FaMO1cMAM83KanPnjtLZBemQgelLuVaKLtRsBIbG0cSgbJWA61I2LtCLySUorCI5CPbZYRGEhrcV7IV0+mUevl2pGWmI3klWiYzG8nAc4GBpdQwxoRyCjBd6onSAzLQcHreUeVfG2gvbUh7Mt6yxp/BSgrJf+fMX70EzbbhmKAjGA6EI187UTlB+eiGQECJ9N9iuyr3nKoNWSppxSvsayIHDgwgW8tosO605QdLUGKkvUJos5itXSkQdYd119wXnMXOaeNPaGR5Ila3ZdlzvRNi8Lhr2w6ugMUqc/OXTwRoJxaS8xGBM1CZX+2gaiqJkp7XWNrww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, Sep 14, 2026 at 03:29:29AM -0400, Yuan Liu wrote:
> When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
> zone, set_zone_contiguous() rescans the entire zone pageblock-by-pageblock
> to rebuild zone->contiguous. For large zones this is a significant cost
> during memory hotplug and hot-unplug.
>
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 1533aebafb68..d40a8ff23370 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -817,22 +817,39 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
>   *   zone/node above the hole except for the trailing pages in the last
>   *   section that will be appended to the zone/node below.
>   */
> -static void __init init_unavailable_range(unsigned long spfn,
> -					  unsigned long epfn,
> -					  int zone, int node)
> +static unsigned long __init init_unavailable_range(unsigned long spfn,
> +						   unsigned long epfn,
> +						   int zone, int node)
>  {
> +	unsigned long next_chunk_pfn __maybe_unused = spfn;
>  	unsigned long pfn;
> -	u64 pgcnt = 0;
> +	u64 online_pgcnt = 0, pgcnt = 0;
> +	bool is_online = true;
>  
>  	for_each_valid_pfn(pfn, spfn, epfn) {
>  		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
>  		__SetPageReserved(pfn_to_page(pfn));
>  		pgcnt++;
> +
> +		/*
> +		 * With vmemmap, at this stage all pages in an early section
> +		 * have a valid memmap and are marked as online. However, only
> +		 * subsections in the subsection map are actually online.
> +		 */

I'm having trouble parsing this comment. Shouldn't is say that some
subsections in a section can be offline because of holes?

Other than that

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> +#ifdef CONFIG_SPARSEMEM_VMEMMAP
> +		if (pfn >= next_chunk_pfn) {
> +			is_online = pfn_section_valid(__pfn_to_section(pfn), pfn);
> +			next_chunk_pfn = min(SUBSECTION_ALIGN_UP(pfn + 1), epfn);
> +		}
> +#endif
> +		if (is_online)
> +			online_pgcnt++;
>  	}
>  
>  	if (pgcnt)
>  		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
>  			node, zone_names[zone], pgcnt);
> +	return online_pgcnt;
>  }
>  
>  /*

-- 
Sincerely yours,
Mike.

