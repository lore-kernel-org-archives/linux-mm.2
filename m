Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD4B1C982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 21:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEB466B008A; Thu, 17 Sep 2026 17:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D2D6B008C; Thu, 17 Sep 2026 17:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B34A6B0092; Thu, 17 Sep 2026 17:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3A66B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:56:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E29F61404D1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:56:23 +0000 (UTC)
X-FDA: 85224613446.03.FF24799
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id DDEB380006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:56:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L1Mdag9k;
	spf=pass (imf30.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789682182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NhZ/y4a+dkUa7WaLlbHkeAQBTwZUNqbVt6sm8GoTkU=;
	b=nxcAPz07yDDNr5XMf0Iv170N+enzOJp3T9AXXdMRvIB21KrX7CXODf3TP3OTS/OHXt0emv
	m/tvXrH2yOWB4EE9WStQsMyTeRtKj8I2c0C9WI6WhHaq9yruLj1FD/dvtrSwxBsVwQh1TM
	c/uRge7bpPbN4qNIwZbBlkaQ08S2oJ4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L1Mdag9k;
	spf=pass (imf30.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789682182;
	b=hwabVg+l30wnbZ3wOqmlgKNxWExSHlii10+TCyIN7VCVnkQOnQ8gu0J0wjturUpu0u6LWS
	3unXBwGQodiM3wFFWzO6lvc4ogSkSq0QuRCQ+5NZiFZfPpc1kLypC58jtgh9Ow3nWj6t5k
	WtPxEY+bRNrRC3ZeOGRTDw8rIzSCw4s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E768B43AB3;
	Thu, 17 Sep 2026 21:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FA41F000FF;
	Thu, 17 Sep 2026 21:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789682179;
	bh=5NhZ/y4a+dkUa7WaLlbHkeAQBTwZUNqbVt6sm8GoTkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L1Mdag9kmnPe+L2tPYHLcz67jASLAJHRTXbLRL6FwDWypq3Me5VmVOJNpahpirJUr
	 gEsrTsb4nt+eg05Kke9kTilWmPAyVnbXAZ2QqEIckXNOxU8Nc03uHomC6TOH25W/2K
	 z5l+kA7XR1hsKOVXM9nOrECRGVVSTOZ0fYqJJ4d/qsSPlA92WfCU5Jhz5VgBRKk640
	 b+F2H3fiHFKhDUNxqU1GLBt2Ks6ayctuMUVHHspuUBp72wI7bAIxxIjtCNIMAhHGB1
	 kVbr6OldOAOOfF9euNAChU/YRakT3Vou1QLZTXALxAI02xOX2wLGmDaBhTwt/LCZFD
	 fiZ6QpTX8Oq4A==
Date: Thu, 17 Sep 2026 16:56:18 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: chenhuacai@kernel.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
	m.szyprowski@samsung.com, x86@kernel.org, bp@alien8.de,
	iommu@lists.linux.dev, saravanak@kernel.org, pratyush@kernel.org,
	robin.murphy@arm.com, loongarch@lists.linux.dev,
	aou@eecs.berkeley.edu, palmer@dabbelt.com, will@kernel.org,
	akpm@linux-foundation.org, pasha.tatashin@soleen.com,
	mingo@redhat.com, pjw@kernel.org, kexec@lists.infradead.org,
	hpa@zytor.com, catalin.marinas@arm.com, devicetree@vger.kernel.org,
	baoquan.he@linux.dev, ruirui.yang@linux.dev, mark.rutland@arm.com,
	kernel@xen0n.name, linux-arm-kernel@lists.infradead.org,
	alex@ghiti.fr, linux-mm@kvack.org, linux-riscv@lists.infradead.org,
	tglx@kernel.org, dave.hansen@linux.intel.com
Subject: Re: [PATCH v6 07/10] of: reserved_mem: add dumpable flag to opt-in
 vmcore
Message-ID: <178968217748.3989713.7328577485527762154.robh@kernel.org>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-8-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902073116.802752-8-chenwandun1@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DDEB380006
X-Stat-Signature: hfduhmoo3kout4378wqarfqn83kwqfdz
X-Rspam-User: 
X-HE-Tag: 1789682181-458092
X-HE-Meta: U2FsdGVkX19NGRwcL6WZkrIG/CG52gjIt5XgNePqa1mXUnM3UUv45OOZ4LMXLmA32fRTj8PB9b595PfQfQ4tOWHngkj1tpDgNMXbq6aJR6vfxritb9Jq7e264zBlaSWJjDz8iaT/FrsshYh0kr06KNqwewTxV3jU3PSP3k+8IOZgv7fj9ExcdWKMlH9kcd1Jxe492d7cX/zcUEAWXAX1PV86iV0eogjKr1vzVG816at/DD3cmfaspOBa6Mzv2m+r89LPi13M7IvtfCbYZoVkXk4tmhuwscR/c57evSnETFT6cpSHl362kCTlp5ih6IRTTxDJLki5+j5X+r9PF1ExO5ifdO3JnGXWNtEsHcwQ7EYmzYlJNCGaNPWD1TFzPmrF+cN1Ex6RFQ1YYUI4hhdPPrhEC5ajkv078YTjqjGPRQMjdt56Tv3jOg/pjZgcF4IdA7Y/iugA5X3iP+L/6TA99ZfFaeCdU67GEAeMdho5wEY3TNLdzwiBTnXwnXRr0J79cKtv9sgm/cMRCPZxTEGM1NxeoT+KZ1iEopfWQgDJuGxL3kjIU7akfIXoqroScq3r27dItfIb1FcFJDLjrwS3kjGafCMOe6NIW9QAlccCZyaqYnemoadCFQTiH3BJhWRM2NwGd30WZJegb7n8PMshAOW0LW+PNLLBBrX1W5H3Jp/svBAf24lKATGqK5iXwXRM0CBPkJjb/nxBuRIVzyx9GiJvweZpsbN94nZz0OBI9eKkbwo9PHuKl32jS8NxFWJBEmh06PjWOrZvCRwLM+Cdv3TtMjjGixImIyBdRoHzmPzXoVXazOLFeGFHCassd3Jbr4RuXamHGuPo4RrmDqkJ59OAlTtVmv9RxyuGrjpLWLd8zBtO1sh2IQJ/j48NxnQTGECqnHDgN30iSgCZdQiU/oeGcguja481oHM1iZF5KKWC7NgMMMFIUFltp7Ce72ezqkC52UlrQHrKMe87k47
 DvREbMKo
 /k1kgkI7V6DS/icmNrDK2jK9ww9v2B9OE1BlilVF8DGV4nkT+VWjhlTlr019O+OYurub05OP94Eh0C55IiB28r9R0xI7/RfOyr/wqvrq8hsup/B1qKbIEWhQJchgUTXguaCiub+m+mtKpVBDHWY5FMkGvejrzJw2glNCPRXkGrcUWcyVvwswUAOx1lncxuzo/YcokY294uNvhGHw6oveOPllAe2pJ5bpCzT+1BEicW1SGyBxr+IVZDxlGdtqbIJ6JPp0SExeqQnYX3Kf+S917JpfNtAZYESCJseEzM7WCGTHNS1ufNfMlUrXHXU1hC27q6UT+uiiFvtf9qpDt/fho+bNqe0eYdkwyW6zdddgCB/YEvCYLAPqm1z2tSiLlAM3tpEAaPRU5Byb1uTKlZfgmTefdpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, 02 Sep 2026 15:31:13 +0800, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> Add a 'dumpable' flag to struct reserved_mem to decide whether a
> reserved area should be included in the kdump vmcore. Non-dumpable
> regions are later marked MEMBLOCK_NODUMP;the filtering itself happens
> in memblock, keeping the arch kdump code independent of the DT API.
> 
> Most reserved regions are owned by devices and do not contain data
> useful for kernel crash analysis, so dumpable default to false.
> Reusable CMA regions are different: their pages are handed back to the
> buddy allocator and may contain key data for crash analysis, so set
> dumpable to true in rmem_cma_setup().
> 
> The dumpable flag is also used to check /memreserve/ entries for overlap
> with other dumpable regions.
> 
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  include/linux/of_reserved_mem.h | 1 +
>  kernel/dma/contiguous.c         | 1 +
>  2 files changed, 2 insertions(+)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>


