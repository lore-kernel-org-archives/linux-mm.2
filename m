Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 276F6CCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 06:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF95D8E000C; Sun,  9 Nov 2025 01:51:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1498E0003; Sun,  9 Nov 2025 01:51:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CAC8E000C; Sun,  9 Nov 2025 01:51:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE0FD8E0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 01:51:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E1A2B8E1A
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 06:51:52 +0000 (UTC)
X-FDA: 84090148464.29.52D167C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D1B6940005
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 06:51:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NsMdolEI;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762671110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=seu7avoOeVpHk3+mR7mGZLCgWVmRkx8A1TmKkLfcyOo=;
	b=b24kxxZ8363K+/cyKH65ok3zZZzykjDen9lNK7j80BGHB+1+QUAzJ+hEXan+pxr2M4R5bj
	OOYOi4Pm8rJYt4dhQJ42XBBYX5xlIF13F6Q42ECpAteBHPlKllbbH4wOFn/moYE5jlXSV/
	tHKRobco65KV7ode15h3+Q3kFyjqCuI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NsMdolEI;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762671110; a=rsa-sha256;
	cv=none;
	b=YkCdBoIuehY0pWpzR0limfWqVGFCABmaKz+zW84nWUX6q/MEDRck1E3rZwe+CasXU3tSDT
	aojS5EolY4+UUT4gptWICsXpB8qmxpiqdFL7npHwqsWiTr5cqDTb4xdZJ8k8LDpdktl/7I
	/mEGnAiH/PyTy7so3cNXeShurrwMVmA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 17456601AC;
	Sun,  9 Nov 2025 06:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBBAC116B1;
	Sun,  9 Nov 2025 06:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762671109;
	bh=MjDOt2y11QmzHF2gEFJK2lQgeHlq6vkMc5A4XeB0RbY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NsMdolEIRb19jC0QwXU10fbcgYllK8QpXG4ZtQ1RvzQeEswgBQsd5paSLvdSsxOCD
	 rbApSj1I/q0dfl/0kCIDROZpWhMscQDc9VOsS6fHSHMYWENwW3cnkuRPunjvNF+sMQ
	 uaTCZ7AxHQBlOIMQZnTxQvZ0xTyeoRmv3KGnz8QirfXVCNfEmFbYegDOsiSN/dCE+l
	 +wCcu+TYf02hfSC8pP/pzq9Z3x4ARgErD5HvTX43EcIlaz6py6nEMXnxk4Ja9NmOuR
	 ReykoaaBA1tpr16Zuvfqt5SSKu+ensPUI6SP9dzxgWundkTLamXvMHqRsGvGh/Tejf
	 Ysb2jEM3uQ4lw==
Date: Sun, 9 Nov 2025 08:51:39 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: dave.hansen@linux.intel.com, peterz@infradead.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, linux-pci@vger.kernel.org,
	Balbir Singh <balbirs@nvidia.com>, Ingo Molnar <mingo@kernel.org>,
	Kees Cook <kees@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>
Subject: Re: [PATCH] x86/kaslr: P2PDMA is one of a class of ZONE_DEVICE-KASLR
 collisions
Message-ID: <aRA5-wgo6bm_TA74@kernel.org>
References: <20251108023215.2984031-1-dan.j.williams@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251108023215.2984031-1-dan.j.williams@intel.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D1B6940005
X-Stat-Signature: 7nqnserjeueonfxwhtik3ecao3ypmof5
X-Rspam-User: 
X-HE-Tag: 1762671110-237589
X-HE-Meta: U2FsdGVkX1/1SZcmaHvUxtVaHBs9n/+9Jmscz+mTGTlLBj1vCUJqKexoZET1pAA4mnXC3MJF1wbBYjK/EEwmk+BkCDAdSKUolqOMmy+DXeQygRneiGBZLsTdvBHrug/wklp0U4zcJstbDcrxVsnr5cSvBZXeeyaB512QrBzuH5Ggzw7hg5q7HHXRPfWJ5bzjIgYdU2t27FwRPWepoTLyXRS8Zb/HfgBykIaW1vEKHs3Zfd5wlVJV5BocNzU5UQqJ7PEFWY/r2DihQdotr1JzmsU/B+WBA1RFEISmoaXgHzriG+clvH+1PZB9TuKiNsh4VyAzY9YrhTgI3+iI0gAEESnNclx8Jfu/BOGK6zk+klNWVZQr3/m7zp1YrE59dRB5ag1QJBYrD/jolUg+NjxcHSfzMu83IQM/g8FgDhuH6fM59up55PXP5ihGO7+fkYE6DsP8dAYRnQvPpg4IglrZQZ0qnM/zWSF7JvbRnsLokqR9WgLg+fC1HTrf7ziFuvMYxF6v8m7l0keW/Xt3XuwSy7gIVXaka4n4kWpivlWLUUbj8uh2bzdVGxDarmU+dIom+wCDPNeBx6vat1pwvA9nJxRx8o5eUoHxXg61zjTGV3cJc2o5E+4sWRTd7Ov+cQp4sY01PIVOO82tY05HJhpbMzBY5lYzvvjQwmOGDU4IRsI6pCNzls6Gtsy98ZPEXeK4pcsC2gv/52R4MwHN2DIDgmGVRUmNqpQpWUn14aCFQe70k1Zp+Eo0G267EUu8o8Qj+VW/aiZHCiqVnuE5seQdSbAHmrtywfoB6fX0+ORtpplgkz0jUB7qs8bX+9AupkxU2oHCOdLlSGIQqUDuI60uiGKPLpGDdOaw8POm/f36aB7MpHeDfCHw+H0C/cFZBWnFd7pMwIqmBvAbkHX1tks3uGwjiy4G+6AwtqcB/hvTl4qPRo0KvLST/9XuYopaphoLgHy3z5CLFV0zD3DyJd7
 wkVg3frl
 fDzguUpDRjr/Cgc29TQFkXB29PbjndBMcvcADlpHWxXYIckXQuqovbp53ptYC/OIwdrbGzZ3ws0HUblI4mz36L2ezz+EYAZw9hpT5AwT/AFg01eozlj2LX6MtrOL+WAqxG2I0N5q6YvMZjBme0iKpVKiU7AOx3lzsDzXb3UZJqSDFNZxNQU1bmGiOwvANe0r5V9wPfiZXW6R6zXLYYCh8n5VJ6fqPkylWwd6fcadQCe79wHQxEvxBaxck+I/CZG3KeiOPcNZlO/FN9GC8QuDfdBBNqqBS/J2LoHflxDLlYfKIt684NIxI8yuRMmC5JOCR9r3kr+x7noxEo2qJPzisQN+M2aGIFL18DhiHRKOscSxwlIWMUE+70qF1wU8/4FaIUw5RprCXZNNNrz+zzTdAqbpvRSsuAS/XV31BRORjIXE6sZMm6/gItM1MZHm3aLAH6bqOQAVLnipYeAvcPgtjw9q9e3Tz4v0Ppvf2DlHEtMQhZHOcsE7qnMjNwMNJrE+P5hSjHenrgRCBcvuJpupRokXPTYtWuE9TuxAHBtQLQx5p8Emx120hXSleh2g8y39ayiiqey3IYHFX6+XppImxaYQpZm4aRRLgtjAzufbS9BXXAXrHE3A7/QU4O1ttuB1chO/Fv/uJ9xZzCxjdftJv1ZHH1st1I0vmTNExWppM22uTkpdBFPfddiHS4PFb9Di+CaiWj+no0UCSp0dp78/ot3gg0jp8Guxdcyet
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 06:32:15PM -0800, Dan Williams wrote:
> Commit 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
> is too narrow. ZONE_DEVICE, in general, lets any physical address be added
> to the direct-map. I.e. not only ACPI hotplug ranges, CXL Memory Windows,
> or EFI Specific Purpose Memory, but also any PCI MMIO range for the
> CONFIG_DEVICE_PRIVATE and CONFIG_PCI_P2PDMA cases.
> 
> A potential path to recover entropy would be to walk ACPI and determine the
> limits for hotplug and PCI MMIO before kernel_randomize_memory(). On
> smaller systems that could yield some KASLR address bits. This needs
> additional investigation to determine if some limited ACPI table scanning
> can happen this early without an open coded solution like
> arch/x86/boot/compressed/acpi.c needs to deploy.
> 
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>
> Fixes: 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/pci/Kconfig |  6 ------
>  mm/Kconfig          | 12 ++++++++----
>  arch/x86/mm/kaslr.c | 10 +++++-----
>  3 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index f94f5d384362..47e466946bed 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -207,12 +207,6 @@ config PCI_P2PDMA
>  	  P2P DMA transactions must be between devices behind the same root
>  	  port.
>  
> -	  Enabling this option will reduce the entropy of x86 KASLR memory
> -	  regions. For example - on a 46 bit system, the entropy goes down
> -	  from 16 bits to 15 bits. The actual reduction in entropy depends
> -	  on the physical address bits, on processor features, kernel config
> -	  (5 level page table) and physical memory present on the system.
> -
>  	  If unsure, say N.
>  
>  config PCI_LABEL
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 0e26f4fc8717..d17ebcc1a029 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1128,10 +1128,14 @@ config ZONE_DEVICE
>  	  Device memory hotplug support allows for establishing pmem,
>  	  or other device driver discovered memory regions, in the
>  	  memmap. This allows pfn_to_page() lookups of otherwise
> -	  "device-physical" addresses which is needed for using a DAX
> -	  mapping in an O_DIRECT operation, among other things.
> -
> -	  If FS_DAX is enabled, then say Y.
> +	  "device-physical" addresses which is needed for DAX, PCI_P2PDMA, and
> +	  DEVICE_PRIVATE features among others.
> +
> +	  Enabling this option will reduce the entropy of x86 KASLR memory
> +	  regions. For example - on a 46 bit system, the entropy goes down
> +	  from 16 bits to 15 bits. The actual reduction in entropy depends
> +	  on the physical address bits, on processor features, kernel config
> +	  (5 level page table) and physical memory present on the system.
>  
>  #
>  # Helpers to mirror range of the CPU page tables of a process into device page
> diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
> index 3c306de52fd4..834641c6049a 100644
> --- a/arch/x86/mm/kaslr.c
> +++ b/arch/x86/mm/kaslr.c
> @@ -115,12 +115,12 @@ void __init kernel_randomize_memory(void)
>  
>  	/*
>  	 * Adapt physical memory region size based on available memory,
> -	 * except when CONFIG_PCI_P2PDMA is enabled. P2PDMA exposes the
> -	 * device BAR space assuming the direct map space is large enough
> -	 * for creating a ZONE_DEVICE mapping in the direct map corresponding
> -	 * to the physical BAR address.
> +	 * except when CONFIG_ZONE_DEVICE is enabled. ZONE_DEVICE wants to map
> +	 * any physical address into the direct-map. KASLR wants to reliably
> +	 * steal some physical address bits. Those design choices are in direct
> +	 * conflict.
>  	 */
> -	if (!IS_ENABLED(CONFIG_PCI_P2PDMA) && (memory_tb < kaslr_regions[0].size_tb))
> +	if (!IS_ENABLED(CONFIG_ZONE_DEVICE) && (memory_tb < kaslr_regions[0].size_tb))
>  		kaslr_regions[0].size_tb = memory_tb;

A stupid question, why we adjust virtual kaslr to actual physical memory
size at all rather than always use maximal addressable size?
  
>  	/*
> 
> base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
> -- 
> 2.51.0
> 

-- 
Sincerely yours,
Mike.

