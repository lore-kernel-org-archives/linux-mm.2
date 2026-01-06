Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F343ECD042A
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 01:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADB826B008A; Mon,  5 Jan 2026 20:11:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5EA16B0093; Mon,  5 Jan 2026 20:11:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933BD6B0095; Mon,  5 Jan 2026 20:11:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB116B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:11:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A6BB58A8D9
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 01:11:31 +0000 (UTC)
X-FDA: 84299761182.03.8B66259
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf30.hostedemail.com (Postfix) with ESMTP id 51B3A80009
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 01:11:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OT8qqJHW;
	spf=pass (imf30.hostedemail.com: domain of dave.jiang@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767661889; a=rsa-sha256;
	cv=none;
	b=3TChPQedCy+db0mo2sB6XQKT5ieaw2Jqd8KXU0xDGNOWqrthIE/1uBs5t3hntR675Gi9R/
	dUXz2jddQUj/FkwKT+BX5Tp9if6OeD+V/v/zs11ymHIM+EbIbQhqR5M/jI6a4364IWpk9k
	92CONrvePDTyY+zL4KdLdU/CdkDCRxo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OT8qqJHW;
	spf=pass (imf30.hostedemail.com: domain of dave.jiang@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767661889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zWzB4pHdZUgCmAu1AL/eXVFE3OI1XVvaFLmnuPa2Rxg=;
	b=vMHmIzCelnN8cxraJw4ROnbpfcJyNuKTyxw6oIB96bLJel7dbx6StSk22Pyy8w6zvQkks6
	HJ+89yKMh/uRiJeSCvlG1FNBZuwbGDGEwx9yDixPDUdj4EMIegze26c4/f3TLo4bPSaO3X
	kXjtb/BCjWbz40Jk/O4ponO5jYcZzPI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767661889; x=1799197889;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jm8nnelT+Iq43xL+maySEnxe6OspV/EkRGcxzUcVGEs=;
  b=OT8qqJHW2e9KHT+5/qbAK1dv2yryQ1F/fLoRO/PebDfm7MwrLkGsXeIE
   WsI2htZckK7tW8zFMjTHwQ5vX0NAM9h+7DnEMTJ/SvTCeMmYXwz1E1cnQ
   W58+GxYjIwckkWiFetlG1TcImk+NRxC774rA0duEQNFOfnYogI9NktGXC
   Wwv3bvY9ORawIgM4SmPzHgf5F6TJredGjiSO0F/BxqoMhlFU/OcMTgbAr
   5b0nqYP/SHyfCo2wpkixrwEGknfJ+Jr6bEKpkDt0jgnRfORztMux6GVNF
   UrR0D+xBAtdWpHZgMu/3RHqkaz2uf5EpRzwHCRLSj7+kV5JbIeRAEb9jS
   A==;
X-CSE-ConnectionGUID: VejGd+VBTfyOeRccw9Fomw==
X-CSE-MsgGUID: 2wPs6NmsTN+elcTf66FiuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="69011391"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="69011391"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 17:11:27 -0800
X-CSE-ConnectionGUID: ZAeGyJRHS5KhCLhzHdp8sg==
X-CSE-MsgGUID: FB5IVjx6RKulu3P0IYcOSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202772009"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [10.125.109.45]) ([10.125.109.45])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 17:11:25 -0800
Message-ID: <0569b41b-0d74-4237-b471-6994ddc42333@intel.com>
Date: Mon, 5 Jan 2026 18:11:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/kaslr: P2PDMA is one of a class of ZONE_DEVICE-KASLR
 collisions
To: dan.j.williams@intel.com, Dave Hansen <dave.hansen@intel.com>,
 dave.hansen@linux.intel.com, peterz@infradead.org
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-pci@vger.kernel.org,
 Balbir Singh <balbirs@nvidia.com>, Ingo Molnar <mingo@kernel.org>,
 Kees Cook <kees@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Andy Lutomirski <luto@kernel.org>, Logan Gunthorpe <logang@deltatee.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>
References: <20251108023215.2984031-1-dan.j.williams@intel.com>
 <2d4fb1ce-176c-404a-852f-987a9481046d@intel.com>
 <692e08b2516d4_261c1100a3@dwillia2-mobl4.notmuch>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <692e08b2516d4_261c1100a3@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 51B3A80009
X-Rspamd-Server: rspam04
X-Stat-Signature: 1rdqem968kfdnd437yhb9qx3cphkrwcc
X-HE-Tag: 1767661888-817614
X-HE-Meta: U2FsdGVkX1/hs9wf5FpbLYzFRW2Sp1/t3x5fyQ6wgeqWgJzr2tZFAXwlo+VXouPTjFTpY7CYXmncLyzw7fn4SCCFj34lca3WSSVgk7YJ/hyFMwbBK+dP4xyVUe1WYyGsCsp0dCL/we8XgSFjLML8TTCqxCVqYXhtGdxTKJl/nTkmx2B52G6I83m8Oa5XLzc+/dlqJZgRhADg5LiHJ42hS5+V/9yurkbOZP6hQEXRH67jYv+IYV8Ow8KIytkzFdVbt7CizZPcyA9tF2DmqYF2V22gpkkcxW470q/Xrf8UeIwFHj2HD8vreeL2tqWaG7/fYe/LaJhWIrYSggcMPYjYn28D6kXcOUyyMt4g/zFSqewLZAiyfihR1leKb8YC+oF/hLVuFwBSArFBjfY2Yjjl/6LlDnXIcMx6uW47DR0SNVGR54CGfVF3TBEaOhSrRT41mKryBl2z4ultlnQ0otlcKm8j7QLTLwszocXVfDaSnZevElUB/qbb9W66bQMzu7ohY3FZnGEwCv67zhgn1gQVGKkDgehTOTJFVZ/74lhc3qRN/F/uwitSKCkjCUcfQCYwdTo9pkLnllanSk74EHVbx82vCiaIMhsiMo5xEkdzYEeakvDRL+3Nszyv5oq2AF9AXx+bfifUK9xg9jZs6JS6u0Z0WEOR5owUQ3oaCQGiKvnRvTI2YuzgObDzsFsANz5sdaH8JQFS8FIUWpg1HyXNick7EQeSnDegHhIE7LJg1REhCzg0j65NptcZy7kFYfhlmOeQr9VLucmnjqBkAwm+d6MJjOAk/CcP8YkCCwrVoIRQoAi98q97rEdmTKK6PCHvlRTr778D+OFyw6qRi6PtOvFeQ03GplxnZUVwZMd62OBzg4fMQ7dBvNYKvqvqb5xUkxUFdw/KhIZsVCxVEkrn/9slIO86xWISi6h3EPVsWon0YKlypf6UT5Xc2E0kliNkD1oGG09jgMwGRP2QPyu
 StRwNZ/8
 nW1bhZ5VqFNnlE+KaAd3KVYdzfd/N24zgc+LNbM/zXFYK7/amuqMHaMM4YcSama/bJGZvtf3emR/9ztKGKcdVWaQ98WoXqOLsrl3WB3T6TUbDjxbHUC14JJHVcHiotp5jisCzgxoO/9E3Bab/g+AMDXpdGd7U2xx/pezSD/rUb5duvGCLbXCNTtWNSIWAZG9uZOOmweOCrX4SKb/r+QDeV0ii4HVwviwrnsEWUp+Y+8uem+7YWhunnNLFpdYsTNS4f8JlvXdJf+TQNBNRjYyfnWlvh1qTOpIa2H9P47DoiKKbB8JyW7BehiKylr9uVCdRCBC9M90SQoc5PpiAqYroXGNVpKbS2YiQCkR4b4ofUlhI7JrKLc7w2Dp9JyxSPqIzI9OXBbm6qf52q+fz7BSnzns8qnAKKbugjpQyTIf1Fs8TA04MO5OHns6rfWvMRR9LZUQZK9yDB3Z6IOJNDst6ddJv6p/61A0eozOTfOCAz0BAtaHhtbzSKW0UaCjdWnjm+h/hOxDjbXtD6sVFeh9YZTIM2S2JNlTJlriON0wVwdq0v5X/Gg8zEBc5AdhGEvhVMYl84jGMurz4Oswq9+q6wFOoou0yJNzRyvB4lWKPRLh/0BXBMpLhP4izxkl9Kvsj9DlJPtdiIlNLP7I4KZ62AdZKrilSa7bPR+7O4Mkp7YqoOrGDK79wfsoVeJoVqsiEwfjQB50Wzxv5Q4s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/1/25 2:29 PM, dan.j.williams@intel.com wrote:
> Dave Hansen wrote:
>> The subject probably wants to be something along the lines of:
>>
>> 	x86/kaslr: Recognize all ZONE_DEVICE users as physaddr consumers
> 
> ...works for me.
> 
>>
>> On 11/7/25 18:32, Dan Williams wrote:
>>> Commit 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
>>> is too narrow. ZONE_DEVICE, in general, lets any physical address be added
>>> to the direct-map. I.e. not only ACPI hotplug ranges, CXL Memory Windows,
>>> or EFI Specific Purpose Memory, but also any PCI MMIO range for the
>>> CONFIG_DEVICE_PRIVATE and CONFIG_PCI_P2PDMA cases.
>>
>> This should probably also mention the fact that:
>>
>> 	config PCI_P2PDMA
>> 		depends on ZONE_DEVICE
>>
>> It would also be nice to point out how the "too narrow" check had an
>> impact on real ZONE_DEVICE but !PCI_P2PDMA users. This isn't just a
>> theoretical problem, right?
> 
> Yasunori filled in a detail [1] that I did not have when creating the
> patch, specifically that when he enountered the CXL collision with KASLR
> he was running on a kernel before commit 7ffb791423c7 ("x86/kaslr:
> Reduce KASLR entropy on most x86 systems").
> 
> Either way, a pre-7ffb791423c7 kernel and a kernel with
> CONFIG_PCI_P2PDMA=n would fail the same way. Yasunori confirmed that
> current kernel with CONFIG_PCI_P2PDMA=y, or this patch solved the
> problem for him.
> 
> See below for a reworked patch with these changes.
> 
> [1]: http://lore.kernel.org/OS9PR01MB124215C4182B59D590049B99390CCA@OS9PR01MB12421.jpnprd01.prod.outlook.com
>>
>>> A potential path to recover entropy would be to walk ACPI and determine the
>>> limits for hotplug and PCI MMIO before kernel_randomize_memory(). On
>>> smaller systems that could yield some KASLR address bits. This needs
>>> additional investigation to determine if some limited ACPI table scanning
>>> can happen this early without an open coded solution like
>>> arch/x86/boot/compressed/acpi.c needs to deploy.
>>
>> Yeah, a more flexible runtime solution would be highly preferred over
>> the existing solution built around config options. But this is really
>> orthogonal to the bug fix here.
>>
>> With the changelog fixes above:
>>
>> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
>>
>> Oh, and does this need to be cc:stable@?
> 
> Yes, especially because it would create a dependency on 7ffb791423c7
> also being backported and that would have helped Yasunori avoid this
> problem (for CONFIG_PCI_P2PDMA=y builds at least).
> 
> -- >8 --
> From d2f4b9ac915ce35e2ec842548ae1ccb4f1690b04 Mon Sep 17 00:00:00 2001
> From: Dan Williams <dan.j.williams@intel.com>
> Date: Thu, 6 Nov 2025 15:13:50 -0800
> Subject: [PATCH v2] x86/kaslr: Recognize all ZONE_DEVICE users as physaddr
>  consumers
> 
> Commit 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
> is too narrow. The effect being mitigated in that commit is caused by
> ZONE_DEVICE which PCI_P2PDMA has a dependency. ZONE_DEVICE, in general,
> lets any physical address be added to the direct-map. I.e. not only ACPI
> hotplug ranges, CXL Memory Windows, or EFI Specific Purpose Memory, but
> also any PCI MMIO range for the DEVICE_PRIVATE and PCI_P2PDMA cases. Update
> the mitigation, limit KASLR entropy, to apply in all ZONE_DEVICE=y cases.
> 
> Distro kernels typically have PCI_P2PDMA=y, so the practical exposure of
> this problem is limited to the PCI_P2PDMA=n case.
> 
> A potential path to recover entropy would be to walk ACPI and determine the
> limits for hotplug and PCI MMIO before kernel_randomize_memory(). On
> smaller systems that could yield some KASLR address bits. This needs
> additional investigation to determine if some limited ACPI table scanning
> can happen this early without an open coded solution like
> arch/x86/boot/compressed/acpi.c needs to deploy.
> 
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
> Fixes: 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> Tested-by: Yasunori Goto <y-goto@fujitsu.com>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

Applied to cxl/fixes
269031b15c1433ff39e30fa7ea3ab8f0be9d6ae2

DJ

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
>  
>  	/*


