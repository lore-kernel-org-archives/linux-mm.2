Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C02ACC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252896B015E; Thu, 22 Jan 2026 06:43:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A7A6B0160; Thu, 22 Jan 2026 06:43:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156C66B0161; Thu, 22 Jan 2026 06:43:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0549F6B015E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:43:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 968B313A5FE
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:43:24 +0000 (UTC)
X-FDA: 84359414328.24.046C25F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 24AB91C0011
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:43:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mIpB13tS;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769082203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUKeOXaWPSvWor2VXIPXbqx4wZlr8Vl/wXtpW4gdmdM=;
	b=WegpzVSQTopjtqxwhikddLIiHV89j8Hk5cg4Ov6NkuwOt8582iJGaUU4xf05OY2aF1RFMJ
	LfphLVZHIEMQd+tOhsSEHfmMI5mFy6PucMQg2Yw5AW6D6IPw4eUPD8KJkN61RTK+RPEAAy
	hvZbqWDwmKIZAaFv1y4P7pYUK5WREVU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mIpB13tS;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769082203; a=rsa-sha256;
	cv=none;
	b=GogBMgFYSLJBkSyquxBlie+qRjhxXx8veMLCOavyobo168SOFdu1jejeiha4hWPjJUNea7
	q1YZWFHWjgTOnRKiEh7AKiuOb0cbWym9PB6BKKOwBknAMfVsjLkQK59dzNiE2ap0/aTbQz
	IqrcC1dCB2pO1Ojb2s4/6L3JoxR2g60=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8802760053;
	Thu, 22 Jan 2026 11:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7445BC116C6;
	Thu, 22 Jan 2026 11:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769082202;
	bh=OPdZB6MSp5meiziqBd6t9/xT7dgKfhbqXbbraGT13Mg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mIpB13tSBsQHZYqWrcmRadmhOe9cDmU9RxlZ8RaFNt76xFzjjJ1XDWs2tQDj/WBbB
	 FLqq54Rgvexxb24IGs9cCmrmIix/Np5so7G7P4j4VFW9yjtCIS6/ttCze+Ft+S2V8x
	 9YyAP4tTIG9Ttx4NF27XfG9EYhTc5GHnAWCFj8kAYWK5UCiXciBGJRM6TGYEKyUX6H
	 AuMRKYj2BFmP7p6bm6urjlBiCE93iq9u2r0+KgC47aqrs4pcMGGBHY+v0lQ9QJ0vCc
	 ziNJPBRRNA5DH1rgBnyrffz9SOSVQAAfM4IoglJMgJFPDhSDzbpBU7qVxafqtiIRWo
	 GgIcZJ9Ar+ahg==
Date: Thu, 22 Jan 2026 13:43:13 +0200
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
Subject: Re: [PATCH v8 3/3] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
Message-ID: <aXINUc0ZJSJusel2@kernel.org>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
 <20260120143346.1427837-4-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120143346.1427837-4-tianyou.li@intel.com>
X-Stat-Signature: bcyrpd3aqjyow4z1y6t1i7ry9sba4e77
X-Rspamd-Queue-Id: 24AB91C0011
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769082202-542434
X-HE-Meta: U2FsdGVkX1/UtguXXPR+uum3+18H4zTUtK8+VhzFSMKKZ3hlAMVngpN8BhW7d3eB62RxS7hWCPclDaQSQXmx/l1uyg+0T7SItFcasMmJvw19RAXTnCMjjt7r4oT2yU71dlSOuFjvO/RuMayGhZnFvOdvMshJr8GAyxzf8tB8wlE9wFzxnhTdfUUCdmUPc59oLgfLWt2ROlHLtvMOKnP8/qGmHkCdPOAB+7ocR1I5oq7csONHECNJunfcMewdjidDmZoqP8fiMq3NmYnw8eIT6vBmV2Z7LKZNKZfAY6xQ9Y4Xv7T2rh/hOTaG2midjxrP55LoIX+6ErC5z5hdfqW3JrL8yWPNFvRfXXj9nH8TdfFLT8h800gdlXO1Vgu1OpKLdhTPoyHE+SNHq/NGaBUE4SUCqsjq3akx08E0qJdvBCFn71I4lYzimoNeHCjVoRHZ0dZecX9fj/oE1JPu0m55NJ4sRY0j7HRC/4h9RXjcc20i/Qtw2SDsbslsNQBoJ3W46ZiNrWwYlYOgeVUh2d/3XMWC22BVJiL+Dk0P+WhFQZtLt+EiGW8BHCr1ko16pV6uoLmfP9kU1XBNTwNpLMDMw+v+PElGFCM9jNx6dN+/D9Ci1OYCoofEOqJl/Boy/0Xy/YmhOwzr3e4GF2pqfCWplmoCGl/nHwuFNjiyFskIy8XAI+ycIrPPB5tpf5KEbURpISOnNceJp+x8D8ePT4HLnKfUS2XaP/stINxthl/EQAJ7Zk62dbH0cWk994QNYFSgSglSkB5PxmZiNWGDUMZHDq/FTw5FWSpJVGMe7VqnyceRQyJjAAtx7MYi+mkdD28DqonSdW4Efysvy83+SPVGNrRw5jM8eGorjSMCKtFw3uCk6T1trgXTtjNA7bTZRcgxBgynVhjc36djA7COabIfztvE2QNWn/niYzTsettVJfLwi2Tz78PbxQo4fKHDYHX8+vqqG68puRyAgnX58H8
 dezrIgqA
 Tmw106VXTpTGZdLBHpNo2BUoQzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Jan 20, 2026 at 10:33:46PM +0800, Tianyou Li wrote:
> When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it will
> update the zone->contiguous by checking the new zone's pfn range from the
> beginning to the end, regardless the previous state of the old zone. When
> the zone's pfn range is large, the cost of traversing the pfn range to
> update the zone->contiguous could be significant.
> 
> Add fast paths to quickly detect cases where zone is definitely not
> contiguous without scanning the new zone. The cases are: when the new range
> did not overlap with previous range, the contiguous should be false; if the
> new range adjacent with the previous range, just need to check the new
> range; if the new added pages could not fill the hole of previous zone, the
> contiguous should be false.
> 
> The following test cases of memory hotplug for a VM [1], tested in the
> environment [2], show that this optimization can significantly reduce the
> memory hotplug time [3].
> 
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Plug Memory    | 256G |      10s      |      2s      |       80%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      33s      |      6s      |       81%      |
> +----------------+------+---------------+--------------+----------------+
> 
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Unplug Memory  | 256G |      10s      |      2s      |       80%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      34s      |      6s      |       82%      |
> +----------------+------+---------------+--------------+----------------+
> 
> [1] Qemu commands to hotplug 256G/512G memory for a VM:
>     object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>     device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>     qom-set vmem1 requested-size 256G/512G (Plug Memory)
>     qom-set vmem1 requested-size 0G (Unplug Memory)
> 
> [2] Hardware     : Intel Icelake server
>     Guest Kernel : v6.18-rc2
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
> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> ---

...

> +int online_memory_block_pages(unsigned long start_pfn, unsigned long nr_pages,
> +			unsigned long nr_vmemmap_pages, struct zone *zone,
> +			struct memory_group *group)
>  {
> +	const bool contiguous = zone->contiguous;
> +	enum zone_contig_state new_contiguous_state;
>  	int ret;
>  
> +	/*
> +	 * Calculate the new zone contig state before move_pfn_range_to_zone()
> +	 * sets the zone temporarily to non-contiguous.
> +	 */
> +	new_contiguous_state = zone_contig_state_after_growing(zone, start_pfn,
> +							       nr_pages);
> +
>  	if (nr_vmemmap_pages) {
>  		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
>  		if (ret)
> -			return ret;
> +			goto restore_zone_contig;

But zone_contig_state_after_growing() does not change zone->contiguous. Why
do we need to save and restore it?

>  	}
>  
>  	ret = online_pages(start_pfn + nr_vmemmap_pages,
> @@ -1271,7 +1320,7 @@ int online_memory_block_pages(unsigned long start_pfn,
>  	if (ret) {
>  		if (nr_vmemmap_pages)
>  			mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
> -		return ret;
> +		goto restore_zone_contig;
>  	}
>  
>  	/*
> @@ -1282,6 +1331,15 @@ int online_memory_block_pages(unsigned long start_pfn,
>  		adjust_present_page_count(pfn_to_page(start_pfn), group,
>  					  nr_vmemmap_pages);
>  
> +	/*
> +	 * Now that the ranges are indicated as online, check whether the whole
> +	 * zone is contiguous.
> +	 */
> +	set_zone_contiguous(zone, new_contiguous_state);
> +	return 0;
> +
> +restore_zone_contig:
> +	zone->contiguous = contiguous;
>  	return ret;
>  }

-- 
Sincerely yours,
Mike.

