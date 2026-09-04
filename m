Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC194C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 07:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7377B6B0088; Fri,  4 Sep 2026 03:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EFA86B008A; Fri,  4 Sep 2026 03:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7D96B008C; Fri,  4 Sep 2026 03:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30F636B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:39:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70CD61206CD
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:39:01 +0000 (UTC)
X-FDA: 85175278482.12.EA40321
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 89BE6100007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:38:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m5cOW3ai;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788507539;
	b=IAdaxD663UzviywuJKRT4NoMmOFDlhHZDbjd5YXhPi7BGcrAW2GfKZ+ooRpoHFq2ioGKrf
	DEpOIYYD1DDhR7Ih4X+KiMkGKAlfPkpDxRw8P94sOY4C7ZNOx4lw4qn4XbiSuSyZS9HpR3
	EzqDge0STD9RpHsjQjCQWd4lqFD0znQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m5cOW3ai;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788507539;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwQ4btCeRfLmSBWD36qpa3SzF+nr0ezs/B8+Yu7nv2A=;
	b=MN0GxAo7D9bHBvnPgxGPTDzrd//Fi6RxEiBDWvcMsfJzcAChXZ2v6dURM+VC6O+V9Q+Np6
	ikvBmE8wQmm7sQ0Ma1uRIJ21/9+WsWgaTVH1V4mR4ffBAuBN6kC1kPMK8FYO4rL8cGCZ7n
	uz1wYaD5AYwfCoVRU5HhYVC9JiputLE=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a6868f18aeso1051882a12.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 00:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788507538; x=1789112338; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fwQ4btCeRfLmSBWD36qpa3SzF+nr0ezs/B8+Yu7nv2A=;
        b=m5cOW3aiNHeG5Y+IVQDT2ejZVYjWTAzsJXwVXeQ4flCjwiuKYzsBswAN//nZeC6ndm
         THxqiHcyJkIr5bgJM2cFZKz12L4eIeJrJPpKnvEge6XJGofCa0HyUuJ1xDaOIrj5mFEm
         6etr7YnYixuEccV9B26T+BgifW+w+jLn82BQ1TuM0wyhQPtn0dE0RIS0Jnhk65fOvQJU
         C4bF5L3zfkU8htTn6bYdWJ+fJSrMQlRbjszU5QB148sM+wHqEzhM3zPLOlCewqFNAF9f
         gqvl8v9tj6LAsdgdQpEvi/y/A7Yf6EYyjFoL7sM0sk98iCYyQr41TEJxtnpdWzm2A9Qo
         0Baw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788507538; x=1789112338;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fwQ4btCeRfLmSBWD36qpa3SzF+nr0ezs/B8+Yu7nv2A=;
        b=ZfObDWvF/BPH50f+i1SiYNsdn4DoaVC2JaiN7xO19Ef13INj+Qznk9FO3+N358LYqe
         ZmNOwfv4SjGEwOOJDz5mg0fwPK9leWwkRqjBavm0BToECpfy9aUft+Wa4eFHMJiAhs/S
         o/kA/mirUaick4ZN5N1KFtEQ1zZwHeFbsynhoexgniBWQNXxNG7yK4kEQpPabArj5kne
         mwbDznJtaKohavECg6rFF7E8Bk0IG4RtPZ2OPy9etJheJucbKC4W+1xosbm4Jex4Y1Eb
         DYldyKZewryn80ik8V5mpBjejNTu+NQLOc82IjFg/fOBUk2HreLB2RLc6tzQyEEIbQ2E
         El4Q==
X-Forwarded-Encrypted: i=1; AKwUvBzm15swO7DagGaFjVe7FcT2eiYpRUdXmGne13lrtKIlcXEdscav1fS+s3XGegtzx/TJeod9NZB6Tg==@kvack.org
X-Gm-Message-State: AFuF++nd+IzDhxmtJxf5rTEru8/R79i+SB4CjLax7Mg1NYPsgmTRZEL+
	95tqE/Oxjl7lZSEoqZtIIZpHk8K3rR2wTq7g+T5HP/ZCPIXsK15WhsGQ
X-Gm-Gg: AYBFou0aUL/S2yWWSHyGvfoZWjYV25REqBTaM+Zxv/nVevygn1SEQMs10Ef0seI4a9Y
	FrLJ5IRUibLDrX5L1ohZs7HHfqImDJ8B9XGklo+jlcHJWoKpKV1PYitpJiTTP+LgfXV3FHu0M/+
	lfpmakVbdcJ0yxaidvYOabsqO+Ep6OHznQ1olzg39699obkmUq/o7SHmRkGaXMFmwpSDBSQ/WiK
	sx1hVt6oEGeI76P8f0LDoc2WyQL/Al5SzhVIZnAQPjumYJ3g+4vZXx0XhhDN5vHmdHaDrE9aAUM
	MmrBVYnwVfTHDcsIaOZ9XQejJm/OgitNOyRxy+DDLcBRsgmqRpZMqfu9xIzuseTnvAzNyhfhceg
	5v3U99CuO/UWTbibr0meiR6++E2Bmr3HyD0T0gR8Ld4/hl4xKxD55FndgMY51u8kRbLCG3NfSPW
	mqC5DwtfaVYQSf4pgFmf7yJTUvMjid9EZopJAroJP9PiDPjPwxJl9NJ4SCvxI=
X-Received: by 2002:a05:6402:28c5:b0:6a5:f4cd:ae39 with SMTP id 4fb4d7f45d1cf-6a7e8d648a5mr1599048a12.9.1788507537725;
        Fri, 04 Sep 2026 00:38:57 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a7e6c20a41sm748804a12.31.2026.09.04.00.38.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 04 Sep 2026 00:38:57 -0700 (PDT)
Date: Fri, 4 Sep 2026 07:38:56 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>, Chen Yu <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Message-ID: <20260904073856.5r56imgrwtpe56wl@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260901052950.3284540-1-yuan1.liu@intel.com>
 <20260901052950.3284540-3-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901052950.3284540-3-yuan1.liu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89BE6100007
X-Stat-Signature: hdmx1e96ijwiuw43k3w88htp6igmtczn
X-HE-Tag: 1788507539-734259
X-HE-Meta: U2FsdGVkX18BjpMmN/zjbsyzCPDNN/xltEQhL7dSRRRrdpQ052b+POkwrhoc31T2/wxssTjXwsyudsuOYnc5xw+kkJO6TGfxoxL1R6TaO5qApptPS8BhodZEr5J6EbLtAXZS+70PCE81WoZqsWr8Uvr2Iz7MrWxJF/CQeGjp+H3CXtXDPcEchP7Y2s0yN49fQ0L+kAiX6eCTPGtuNG/V+ZFEvkPeOqwaFyKlcy0Y/JZk0FUEyzpNwTBlvn+1GzNrrCsMZmM0Uc1ZnQMd5QwA5RiOkMsJfA/q+4Zj2+hcC8cHJof5ii70ENfBrbUUbR/HL/3dEVrzQeiExLd4uOLcPTBv15F1V7XKkelSDvjsbDoOQpayiNxDQ99H2+fpgYLqDkpihJGr/LXMl1wMef+acxHaR5CY+r/anik76D0usYYHC/QiyrCFL23jHiwu6iDQeLdSWj3cl8zkINNgEdPrtiVmUZ3aDcOjiLuwu2SbQOR82snn2ge6brudFekEDc3+qH38dX6Zs1LICSwX7/fq8Ln0BmZss2Hdp4B1bUQmNRP2MEhwDCfyZP0oylCBssMSmfjK0ZSqtcWgVKvTHh+bd8QVUmRLxrGi3sI9t62Ige0X2d1fGopBkZsb1C7br5RjHyQRfn8NN79J0HDqpXBZ5JiP9iuDch7cP32hgPiFyldQift0Lyd+lE6J3peMk53Qq4QzY37fUx0H5vTjUeM/4Vw3UtwJp8Z2a6ickE5XnzOM4u69tF14YkSQR2JTheayayKwbq5uCrlchcLTOq9yx6CsaulkCHLBbP7Jr1UEgoaoJ94pkrnh0lSK1LLxI8uboN3cpyYJ/tKO268YV8e05dXGfmAZOw3CBNOT8spaniTuBqwUNjJ4cl+QP62Dco9dI3nqeWkyWV5VR4U4K3hLpqnhrnenMZTdKaZ87ZEibU1QrY14hNDh/c52eTTeF1MH7WmdbcN1PJgoaK8fB3P
 XAotG0Ub
 Bx2NOQlWmTq8xpSK0H7sPHOveF+/XTDEFDV2HDh+5AbfETCAkgztemd+tVB3NG0SF0SE1R3F+HnEZCypBv/Qc6PsGm/oKTZd3k0JaPBJx/iJ8COfouwShGOWreVp6y6Fb5lKlx87nhQ6gJ/Tl+k7kav6tN13u9EOoIqZ41//WrY9LZNRgGmgv3kRvEHn33R6fbaf9pEHT31ROXO4CFtJrjYcPrjLmub4fRRmxHsoZQVMsJA0GfO4ViQJjcxt9yMDTuAYxhpTkR+hewKmp1D3WNsCm/i83uP+1D5XkMkw6m1MxvoI8jSXb/jQ5Jr2WC3tQgdvpA26nvmwcbF3FDXcVFYX0k1pVxpJT1iDIiFOyPOU9Cwf9Elro/HeM2C7nJl8aV0YAtFmF4nKo97+4KSdm2K8R1RpvFaAve109b/KcL6/GKGA2KhAp+DUAAvbMRihtkMTo9NRe2oe4ppL8pFYwhScBPSfr0ClOhazMZAOQIGS2RpM2j3EOMDLc78aSyrBfBuDW9moHpxniALOcZc9OCpwmwdahapnHjlTiY9hSkj1Khhzoxn78L2OMpV2KQJDq0pE/FoN8i5gD6yIguwYa3vjMFkhz47BGLlgRNEN2sCrcUmENlZI6ZluNw8XCB/fA7xbLkLK4nyBxN1CDyDcBVWsAxOk1xUubWr5kpLA+QKfCvZU8i4t5vElcur9/pOZLfHQlNluvT04Ma+D5Shndpt6pTSRYQerO9p46BVHB0K/t15tpurcoKgFwW8/PPTLspR6ezsULtFBfEf7auAMSikcabw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 01:29:50AM -0400, Yuan Liu wrote:
>When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
>zone, set_zone_contiguous() rescans the entire zone pageblock-by-pageblock
>to rebuild zone->contiguous. For large zones this is a significant cost
>during memory hotplug and hot-unplug.
>
>Add a new zone member, pages_with_online_memmap, that tracks the
>number of pages within the zone span that have an online memory map,
>including present pages and memory holes whose memory map has been
>initialized and for which pfn_to_online_page() succeeds.
>
>For early boot memory, pages_with_online_memmap is calculated in
>memmap_init_zone_range(). PFNs initialized by memmap_init_range() are
>included in pages_with_online_memmap, and hole PFNs for which
>pfn_to_online_page() succeeds are also counted in
>init_unavailable_range(). For hotplugged memory,
>pages_with_online_memmap is updated through adjust_present_page_count(),
>which is called during memory online and offline operations. When
>spanned_pages == pages_with_online_memmap, every PFN in the zone span
>has a valid memmap entry, so pfn_to_page() can be called for any PFN
>within the zone span without an additional pfn_valid() check.
>
>The counter may temporarily undercount when pages with an online
>memory map exist outside the current zone span. This can only happen
>during boot, when initializing the memory map of pages that do not
>fall into any zone span. Growing the zone to cover such pages and
>later shrinking it back may result in a value that is too small.
>This is safe, as it merely prevents detecting a contiguous zone.
>
>The contiguity check using pages_with_online_memmap is stricter than
>the old pageblock-by-pageblock scan. The old set_zone_contiguous()
>iterated at pageblock granularity via pageblock_pfn_to_page(), so a
>zone could be marked contiguous even if a subsection-sized hole
>existed within a pageblock. The new check requires
>spanned_pages == pages_with_online_memmap, meaning every PFN in the
>zone span must satisfy pfn_to_online_page().
>
>The following test cases of memory hotplug for a VM [1], tested in the
>environment [2], show that this optimization can significantly reduce the
>memory hotplug time [3].
>
>+----------------+------+---------------+--------------+----------------+
>|                | Size | Time (before) | Time (after) | Time Reduction |
>|                +------+---------------+--------------+----------------+
>| Plug Memory    | 256G |      10s      |      3s      |       70%      |
>|                +------+---------------+--------------+----------------+
>|                | 512G |      36s      |      7s      |       81%      |
>+----------------+------+---------------+--------------+----------------+
>
>+----------------+------+---------------+--------------+----------------+
>|                | Size | Time (before) | Time (after) | Time Reduction |
>|                +------+---------------+--------------+----------------+
>| Unplug Memory  | 256G |      11s      |      4s      |       64%      |
>|                +------+---------------+--------------+----------------+
>|                | 512G |      36s      |      9s      |       75%      |
>+----------------+------+---------------+--------------+----------------+
>
>[1] Qemu commands to hotplug 256G/512G memory for a VM:
>    object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>    device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>    qom-set vmem1 requested-size 256G/512G (Plug Memory)
>    qom-set vmem1 requested-size 0G (Unplug Memory)
>
>[2] Hardware     : Intel Icelake server
>    Guest Kernel : v7.3-rc1
>    Qemu         : v9.0.0
>
>    Launch VM    :
>    qemu-system-x86_64 -accel kvm -cpu host \
>    -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>    -drive file=./seed.img,format=raw,if=virtio \
>    -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>    -m 2G,slots=10,maxmem=2052472M \
>    -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>    -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>    -nographic -machine q35 \
>    -nic user,hostfwd=tcp::3000-:22
>
>    Guest kernel auto-onlines newly added memory blocks:
>    echo online > /sys/devices/system/memory/auto_online_blocks
>
>[3] The time from typing the QEMU commands in [1] to when the output of
>    'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>    memory is recognized.
>
>Reported-by: Nanhai Zou <nanhai.zou@intel.com>
>Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
>Tested-by: Yuan Liu <yuan1.liu@intel.com>
>Reviewed-by: Jason Zeng <jason.zeng@intel.com>
>Reviewed-by: Chen Yu <yu.c.chen@intel.com>
>Reviewed-by: Pan Deng <pan.deng@intel.com>
>Co-developed-by: Tianyou Li <tianyou.li@intel.com>
>Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>---
> Documentation/mm/physical_memory.rst |  6 +++
> drivers/base/memory.c                |  7 +++-
> include/linux/mmzone.h               | 48 +++++++++++++++++++++
> mm/memory_hotplug.c                  | 12 +-----
> mm/mm_init.c                         | 63 +++++++++++++++-------------
> mm/mm_init.h                         |  6 ---
> mm/page_alloc.h                      |  2 +-
> 7 files changed, 98 insertions(+), 46 deletions(-)
>
>diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
>index a09407d72973..2e67e8b23a99 100644
>--- a/Documentation/mm/physical_memory.rst
>+++ b/Documentation/mm/physical_memory.rst
>@@ -480,6 +480,12 @@ General
>   ``present_pages`` should use ``get_online_mems()`` to get a stable value. It
>   is initialized by ``calculate_node_totalpages()``.
> 
>+``pages_with_online_memmap``
>+  Pages within the zone that have an online memory map: present pages and
>+  memory holes whose memory map has been initialized and
>+  ``pfn_to_online_page()`` succeeds. See the comment for
>+  ``pages_with_online_memmap`` in ``include/linux/mmzone.h`` for more details.
>+
> ``present_early_pages``
>   The present pages existing within the zone located on memory available since
>   early boot, excluding hotplugged memory. Defined only when
>diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>index 5eead3346f1e..28f9503f6a71 100644
>--- a/drivers/base/memory.c
>+++ b/drivers/base/memory.c
>@@ -255,6 +255,7 @@ static int memory_block_online(struct memory_block *mem)
> 		nr_vmemmap_pages = mem->altmap->free;
> 
> 	mem_hotplug_begin();
>+	clear_zone_contiguous(zone);
> 	if (nr_vmemmap_pages) {
> 		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
> 		if (ret)
>@@ -279,6 +280,7 @@ static int memory_block_online(struct memory_block *mem)
> 
> 	mem->zone = zone;
> out:
>+	set_zone_contiguous(zone);
> 	mem_hotplug_done();
> 	return ret;
> }
>@@ -304,6 +306,7 @@ static int memory_block_offline(struct memory_block *mem)
> 		nr_vmemmap_pages = mem->altmap->free;
> 
> 	mem_hotplug_begin();
>+	clear_zone_contiguous(mem->zone);
> 	if (nr_vmemmap_pages)
> 		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
> 					  -nr_vmemmap_pages);
>@@ -321,8 +324,10 @@ static int memory_block_offline(struct memory_block *mem)
> 	if (nr_vmemmap_pages)
> 		mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
> 
>-	mem->zone = NULL;
> out:
>+	set_zone_contiguous(mem->zone);
>+	if (!ret)
>+		mem->zone = NULL;
> 	mem_hotplug_done();
> 	return ret;
> }
>diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>index 94f9c3ff5416..7bfb871d6344 100644
>--- a/include/linux/mmzone.h
>+++ b/include/linux/mmzone.h
>@@ -1043,6 +1043,21 @@ struct zone {
> 	 * cma pages is present pages that are assigned for CMA use
> 	 * (MIGRATE_CMA).
> 	 *
>+	 * pages_with_online_memmap tracks pages within the zone that have
>+	 * an online memory map: present pages and memory holes whose
>+	 * memory map has been initialized and pfn_to_online_page()
>+	 * succeeds. When spanned_pages == pages_with_online_memmap,
>+	 * pfn_to_page() can be performed without further checks on any
>+	 * PFN within the zone span.
>+	 *
>+	 * Note: this counter may temporarily undercount when pages with an
>+	 * online memory map exist outside the current zone span. This can
>+	 * only happen during boot, when initializing the memory map of
>+	 * pages that do not fall into any zone span. Growing the zone to
>+	 * cover such pages and later shrinking it back may result in a
>+	 * "too small" value. This is safe: it merely prevents detecting a
>+	 * contiguous zone.
>+	 *
> 	 * So present_pages may be used by memory hotplug or memory power
> 	 * management logic to figure out unmanaged pages by checking
> 	 * (present_pages - managed_pages). And managed_pages should be used
>@@ -1067,6 +1082,7 @@ struct zone {
> 	atomic_long_t		managed_pages;
> 	unsigned long		spanned_pages;
> 	unsigned long		present_pages;
>+	unsigned long		pages_with_online_memmap;
> #if defined(CONFIG_MEMORY_HOTPLUG)
> 	unsigned long		present_early_pages;
> #endif
>@@ -1694,6 +1710,38 @@ static inline bool zone_is_zone_device(const struct zone *zone)
> }
> #endif
> 
>+/**
>+ * zone_is_contiguous - test whether a zone is contiguous
>+ * @zone: the zone to test.
>+ *
>+ * In a contiguous zone, it is valid to call pfn_to_page() on any PFN in the
>+ * spanned zone without requiring pfn_valid() or pfn_to_online_page() checks.
>+ *
>+ * Note that missing synchronization with memory offlining makes any PFN
>+ * traversal prone to races.
>+ *
>+ * ZONE_DEVICE zones are always marked non-contiguous.
>+ *
>+ * Return: true if contiguous, otherwise false.
>+ */
>+static inline bool zone_is_contiguous(const struct zone *zone)
>+{
>+	return READ_ONCE(zone->contiguous);
>+}
>+
>+static inline void set_zone_contiguous(struct zone *zone)
>+{
>+	if (zone_is_zone_device(zone))
>+		return;

After this patch, set_zone_contiguous() is only used in two cases:

  * memory_block_online()
  * page_alloc_init_late()

If I understand correctly:

  * zone_for_pfn_range() won't return ZONE_DEVICE
  * there is no ZONE_DEVICE memory populated at this point, device memory is
    populated during do_initcalls()

So we don't expect ZONE_DEVICE here?

>+	if (zone->spanned_pages == zone->pages_with_online_memmap)
>+		WRITE_ONCE(zone->contiguous, true);
>+}
>+
>+static inline void clear_zone_contiguous(struct zone *zone)
>+{
>+	WRITE_ONCE(zone->contiguous, false);
>+}
>+
> /*
>  * Returns true if a zone has pages managed by the buddy allocator.
>  * All the reclaim decisions have to use this function rather than
>diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>index 9f19876ec3ec..100941d1b828 100644
>--- a/mm/memory_hotplug.c
>+++ b/mm/memory_hotplug.c
>@@ -549,18 +549,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
> 
> 	/*
> 	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
>-	 * we will not try to shrink the zones - which is okay as
>-	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
>+	 * we will not try to shrink it.
> 	 */
> 	if (zone_is_zone_device(zone))
> 		return;

One question not closely related to this patch.

This check is introduced in commit 7ce700bf11b5 ("mm/memory_hotplug: don't
access uninitialized memmaps in shrink_zone_span()"), at that time
pfn_to_online_page() couldn't handle ZONE_DEVICE pfn correctly.

Then commit 1f90a3477df3 ("mm: teach pfn_to_online_page() about ZONE_DEVICE
section collisions") enables it.

So could we remove the restriction now?

> 
>-	clear_zone_contiguous(zone);
>-
> 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
> 	update_pgdat_span(pgdat);
>-
>-	set_zone_contiguous(zone);
> }
> 
> /**
>@@ -738,8 +733,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
> 	struct pglist_data *pgdat = zone->zone_pgdat;
> 	int nid = pgdat->node_id;
> 
>-	clear_zone_contiguous(zone);
>-
> 	if (zone_is_empty(zone))
> 		init_currently_empty_zone(zone, start_pfn, nr_pages);
> 	resize_zone_range(zone, start_pfn, nr_pages);
>@@ -767,8 +760,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
> 	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
> 			 MEMINIT_HOTPLUG, altmap, migratetype,
> 			 isolate_pageblock);
>-
>-	set_zone_contiguous(zone);
> }
> 
> struct auto_movable_stats {
>@@ -1064,6 +1055,7 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
> 	if (early_section(__pfn_to_section(page_to_pfn(page))))
> 		zone->present_early_pages += nr_pages;
> 	zone->present_pages += nr_pages;
>+	zone->pages_with_online_memmap += nr_pages;
> 	zone->zone_pgdat->node_present_pages += nr_pages;
> 
> 	if (group && movable)
>diff --git a/mm/mm_init.c b/mm/mm_init.c
>index 1533aebafb68..d40a8ff23370 100644
>--- a/mm/mm_init.c
>+++ b/mm/mm_init.c
>@@ -817,22 +817,39 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
>  *   zone/node above the hole except for the trailing pages in the last
>  *   section that will be appended to the zone/node below.
>  */
>-static void __init init_unavailable_range(unsigned long spfn,
>-					  unsigned long epfn,
>-					  int zone, int node)
>+static unsigned long __init init_unavailable_range(unsigned long spfn,
>+						   unsigned long epfn,
>+						   int zone, int node)
> {
>+	unsigned long next_chunk_pfn __maybe_unused = spfn;
> 	unsigned long pfn;
>-	u64 pgcnt = 0;
>+	u64 online_pgcnt = 0, pgcnt = 0;
>+	bool is_online = true;
> 
> 	for_each_valid_pfn(pfn, spfn, epfn) {
> 		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
> 		__SetPageReserved(pfn_to_page(pfn));
> 		pgcnt++;
>+
>+		/*
>+		 * With vmemmap, at this stage all pages in an early section
>+		 * have a valid memmap and are marked as online. However, only
>+		 * subsections in the subsection map are actually online.
>+		 */
>+#ifdef CONFIG_SPARSEMEM_VMEMMAP
>+		if (pfn >= next_chunk_pfn) {
>+			is_online = pfn_section_valid(__pfn_to_section(pfn), pfn);
>+			next_chunk_pfn = min(SUBSECTION_ALIGN_UP(pfn + 1), epfn);

The range iterates by for_each_valid_pfn() is [spfn, epfn - 1], so we don't
expect pfn exceed epfn?

			next_chunk_pfn = SUBSECTION_ALIGN_UP(pfn + 1);

Could be enough?

>+		}
>+#endif
>+		if (is_online)
>+			online_pgcnt++;
> 	}
> 
> 	if (pgcnt)
> 		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
> 			node, zone_names[zone], pgcnt);
>+	return online_pgcnt;
> }
> 
> /*
>@@ -930,9 +947,21 @@ static void __init memmap_init_zone_range(struct zone *zone,
> 	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
> 			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
> 			  false);
>+	zone->pages_with_online_memmap += end_pfn - start_pfn;
> 
>-	if (*hole_pfn < start_pfn)
>-		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
>+	if (*hole_pfn < start_pfn) {
>+		unsigned long hole_start_pfn = *hole_pfn;
>+		unsigned long pgcnt;
>+
>+		if (hole_start_pfn < zone_start_pfn) {
>+			init_unavailable_range(hole_start_pfn, zone_start_pfn,
>+					       zone_id, nid);
>+			hole_start_pfn = zone_start_pfn;
>+		}
>+		pgcnt = init_unavailable_range(hole_start_pfn, start_pfn,
>+					       zone_id, nid);
>+		zone->pages_with_online_memmap += pgcnt;
>+	}
> 
> 	*hole_pfn = end_pfn;
> }
>@@ -2188,28 +2217,6 @@ void __init init_cma_pageblock(struct page *page)
> }
> #endif
> 
>-void set_zone_contiguous(struct zone *zone)
>-{
>-	unsigned long block_start_pfn = zone->zone_start_pfn;
>-	unsigned long block_end_pfn;
>-
>-	block_end_pfn = pageblock_end_pfn(block_start_pfn);
>-	for (; block_start_pfn < zone_end_pfn(zone);
>-			block_start_pfn = block_end_pfn,
>-			 block_end_pfn += pageblock_nr_pages) {
>-
>-		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
>-
>-		if (!__pageblock_pfn_to_page(block_start_pfn,
>-					     block_end_pfn, zone))
>-			return;
>-		cond_resched();
>-	}
>-
>-	/* We confirm that there is no hole */
>-	zone->contiguous = true;
>-}
>-
> /*
>  * Check if a PFN range intersects multiple zones on one or more
>  * NUMA nodes. Specify the @nid argument if it is known that this
>diff --git a/mm/mm_init.h b/mm/mm_init.h
>index 39f75df9be1c..520d53ecc68d 100644
>--- a/mm/mm_init.h
>+++ b/mm/mm_init.h
>@@ -20,15 +20,9 @@ struct vmem_altmap;
> /* perform sanity checks on struct pages being allocated or freed */
> DECLARE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
> 
>-void set_zone_contiguous(struct zone *zone);
> bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
> 			   unsigned long nr_pages);
> 
>-static inline void clear_zone_contiguous(struct zone *zone)
>-{
>-	zone->contiguous = false;
>-}
>-
> void memblock_free_pages(unsigned long pfn, unsigned int order);
> 
> void *memmap_alloc(phys_addr_t size, phys_addr_t align, phys_addr_t min_addr,
>diff --git a/mm/page_alloc.h b/mm/page_alloc.h
>index b9259deddb59..d4182f7cb7dd 100644
>--- a/mm/page_alloc.h
>+++ b/mm/page_alloc.h
>@@ -214,7 +214,7 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
> static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
> 				unsigned long end_pfn, struct zone *zone)
> {
>-	if (zone->contiguous)
>+	if (zone_is_contiguous(zone))
> 		return pfn_to_page(start_pfn);
> 
> 	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
>-- 
>2.47.3

-- 
Wei Yang
Help you, Help me

