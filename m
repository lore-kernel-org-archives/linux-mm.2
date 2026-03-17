Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8B38FED9F0
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247636B0098; Tue, 17 Mar 2026 13:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21F036B00A2; Tue, 17 Mar 2026 13:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15BE56B00A7; Tue, 17 Mar 2026 13:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02B1E6B0098
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:22:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91D4A1C591
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:22:32 +0000 (UTC)
X-FDA: 84556224144.30.7C5F2F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0952A180002
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:22:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZqqxV3K2;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773768151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJxJEmRypfWuM6YddlInSIyFtia1teHIB6WSqhxdiX4=;
	b=IKfFwwPUSEHs0Kh2E5EFXJPjKFC1LYBRXFM5V+54TUJkI0i+lc2tiB1R71npAKWN0RN9GX
	AN7uwiTJyugYe4vwX27IVAS7IYa925Aat6TWN/MUvgh3MKh/YmC5Zh3/ujhb7OMQkmdnQR
	oLDfftulw1a6/QGtHi3jBUzw8XyyqCs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZqqxV3K2;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773768151; a=rsa-sha256;
	cv=none;
	b=LItnnC9olDUZJnonkG6z1f+0EuA+ZAXehO2CtSXNJVi8yiF/a31bDQ/FxCppXsGrXKhefx
	+q73VB1BpXVrHW+HrV1FYrIng+0xhgV9XGCXIEMYhgitq4GyQjLUpIuEZFmBxnYia6Uc+Y
	VNED675WAjuuKE6mpEQkk6PyqBwrcyc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B9676012A;
	Tue, 17 Mar 2026 17:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0416C4CEF7;
	Tue, 17 Mar 2026 17:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773768150;
	bh=CXmAL0fZMhCd313IWOg1p205CurpMDcHyDTWRrkP3T4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZqqxV3K2taXpMWi9I62jvNQ2Nbso5h2AQWq9+9AMlJt1uQeV4Zp2+ZS8jEuqfRAL+
	 5P2lzLcgxOr49+x7RDobgdg28kMumEGpA3ZyMDGstaZSkrG5JYpbg/McqRZWAZCYei
	 73OfWn9fjHM8Bu95B1KzPK5r7ITT6SpI2BbF10Y3cnkspn7unPF+0+XRRKXtiLkJH3
	 frvYeeYaJ1JFtOWfhoW286UeyI3Mnx76+/Wo2h9CWCwMwUjldhiLVyyNNBT9LgS04E
	 Wz4AhiYhp1vyLWqOGGU3qIqIA+H/gUANoKxn+pQH3CRRy7K2uGi3JVI618ROa9d9Cp
	 BK2WzmJVxPVng==
Date: Tue, 17 Mar 2026 17:22:24 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 03/14] mm/Kconfig: make CONFIG_MEMORY_HOTPLUG depend on
 CONFIG_SPARSEMEM_VMEMMAP
Message-ID: <02b0cc59-bc6e-477e-831a-9f699b7e529a@lucifer.local>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-4-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-4-david@kernel.org>
X-Stat-Signature: ryh5sekin7y8idbkfasqzw864yhqo63b
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0952A180002
X-HE-Tag: 1773768150-202939
X-HE-Meta: U2FsdGVkX191Kqfl4NTSVMnTU7RqTGTBbgxGP87LCrzzGiEa0mmkI/R0IWMknpORlV/F0tXMg3LSS1OLYvmtU/xweywKTfSfcmge1sX3JFExN65pZXFx4LjTGUXoah2lMGTjWYtllpuc90TV+3u/fDh6GW6vWmJQJGGHv52/kWGb0+O4FJft84X2W2ZLnhY2mCM1FXQqmWDTBEj+1PfXW+JNaCheQgvFUBLzAW7cOkG9xTsBQ0KskltVrM5OAgL9vNBwmV8cP22I0qP/pfssr+TLR5YSyt0PyCOd4MxrfCpcMJI4jJcCix6pvp8sO1Tn3TdV/i7a5vlfuVv953WwcAjBelOYzonG7HS/Ry57q2CH0R9FsOVFsON+7a6csyetyFeu4IPD0qH9H7YpyM68WXLTJ/k4sYSMjWo7RfzQQNGjh0mlN4Ohb1l30nO2V566T/P0HHde2jHlf4nqcI034Wcye2WGETdY880LHZrX1s1HdcrfnxMNjkFN8UdtP4GhP5APF52gy1+L5M3wH475PQRCdmGs3QFZBQEcOvbaRdLaLUBSvdsjo2pdSplY+3Aezw/BkLZzMOHQbf+tJ4Bw/GDKvqZAWxg4rYAYaLaeyev7vZu1om+YctMSzjw4gJlhn3SHGpWSWIOOaHLJ6PmukE4/g43X0x5Xc/GVYODJcriUfYynSYqitTasYMhz/NBhh4X2ltnCRiYFZ7AVrx8e1tkphhAivs46KKPwB/MmLDG7vbAGNyG3yd37Htug4K4kfleUSgl27aYAryNEr437JtzgtsmNBo+K65UIMERjk+02m81m6eSwR58dxS9vIQJ97jNJhjXd1DJberq4mw4eAyqZW8xb6XBz6Pa42PWFzxwtqsMzwwQkESTZ6yX2qPSrIU4/vBRcQD/JPCslsNX+VpfSxbr9Ebv8cj6FK85XMo7nuiOR/KW7uWHrmnjdoVxh2mVrZBJ7gyfWBQ3zrL4
 WfQjFMAF
 PrEO7GIvO9F21+jfzVLTss8btijIh1hp1V/XseWP2S8PIO5XO0+ogO6pk/yw067wJt1qTSWH8dpUtKHlxwAde7h5QK0VyaZMrC7rQ+ZdSoX4DR6JqWl6/ENzuB8QVAbCim+msposm1Chnsoal5rvNokFnSK5EHIsWTD2AeDwtyBb4wLIUicbMWGjsCieiIRcnFdDpBkRMQFqZTvEi6jbBzf1mMaUWZ5zPW7YGOYBdF5Rq5WWDOm6lK2dFtNA48+2MLeukinoY4IlCYiwl8Mdqv9EsuooDSgsnwbWP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:41PM +0100, David Hildenbrand (Arm) wrote:
> Ever since commit f8f03eb5f0f9 ("mm: stop making SPARSEMEM_VMEMMAP
> user-selectable"), an architecture that supports CONFIG_SPARSEMEM_VMEMMAP
> (by selecting SPARSEMEM_VMEMMAP_ENABLE) can no longer enable
> CONFIG_SPARSEMEM without CONFIG_SPARSEMEM_VMEMMAP.
>
> Right now, CONFIG_MEMORY_HOTPLUG is guarded by CONFIG_SPARSEMEM.
>
> However, CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG is only enabled by
> * arm64: which selects SPARSEMEM_VMEMMAP_ENABLE
> * loongarch: which selects SPARSEMEM_VMEMMAP_ENABLE
> * powerpc (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE
> * riscv (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE
> * s390 with SPARSEMEM: which selects SPARSEMEM_VMEMMAP_ENABLE
> * x86 (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE
>
> So, we can make CONFIG_MEMORY_HOTPLUG depend on CONFIG_SPARSEMEM_VMEMMAP
> without affecting any setups.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Some risc-y business Dave but I believe in you! So:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index ebd8ea353687..c012944938a7 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -472,7 +472,7 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
>  menuconfig MEMORY_HOTPLUG
>  	bool "Memory hotplug"
>  	select MEMORY_ISOLATION
> -	depends on SPARSEMEM
> +	depends on SPARSEMEM_VMEMMAP
>  	depends on ARCH_ENABLE_MEMORY_HOTPLUG
>  	depends on 64BIT
>  	select NUMA_KEEP_MEMINFO if NUMA
> --
> 2.43.0
>

