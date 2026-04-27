Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2432BFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871686B00A6; Mon, 27 Apr 2026 14:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821ED6B00A7; Mon, 27 Apr 2026 14:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7376F6B00A8; Mon, 27 Apr 2026 14:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 602A26B00A6
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:47:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2D5D1402A9
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:47:51 +0000 (UTC)
X-FDA: 84705219942.03.F7AA530
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id F071720010
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:47:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=cmjEZol5;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf03.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777315670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S4tzZTHVVwx4dE5q55trjuPou8rUVW9NKtUsR+YVAxQ=;
	b=CBhIcsL5lBmkCZm7G/NrSlFPX2N2Pc+HqRfjLBZfRSRgKD66L4DftIgSJFjCHdXcdBOK4N
	y7EY5oiV8zUDcOyWLrLHsSklzpRqQMrp7jjo37QH8/AVhcbLTzsF223D0boVA7R4OxBZ7R
	ZeMcc4AydTjxxVslb5Sfwhn99MbkMl0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777315670; a=rsa-sha256;
	cv=none;
	b=zHfoISehsu/DAPUUj5B1de8eQFNgnLL2PRQTZTCxvKXupoP++PH6AQCS7cQQheaJxM/p6n
	hb80y7j0LA7XeBjWeQjupTxui5RGv9bq36ZUw1Fe99uC7K1TCsk0wh5G/GmTmHa4SzPDPA
	q4EXjCKRpeyd+LMDGf4hMmIEVW8dvxg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=cmjEZol5;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf03.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com
Received: from localhost (unknown [52.148.138.235])
	by linux.microsoft.com (Postfix) with ESMTPSA id E249A20B716A;
	Mon, 27 Apr 2026 11:47:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E249A20B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1777315668;
	bh=S4tzZTHVVwx4dE5q55trjuPou8rUVW9NKtUsR+YVAxQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cmjEZol5n8EEvl93N6WXvZ/B3Z6d2+Hp0UmiD/Ox5Af+pe8fIxtkwd1dvkRKkWOUa
	 5abA7q+8En19G5GEOu5St1WIegpcN4MQ5bqVKnj0Vprr5Ue7paKmos8vQ89Zu+BJ0v
	 SgTFjCNrDtKoq0bcX9wEqEP8qZW/2b479wPNxwgw=
Date: Mon, 27 Apr 2026 11:47:45 -0700
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: David Matlack <dmatlack@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Adithya Jayachandran
 <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex
 Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris
 Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, Jason
 Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet
 <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky
 <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport
 <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja
 <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, Will Deacon
 <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu
 <yi.l.liu@intel.com>, jacob.pan@linux.microsoft.com
Subject: Re: [PATCH v4 05/11] PCI: liveupdate: Inherit bus numbers during
 Live Update
Message-ID: <20260427114745.00000656@linux.microsoft.com>
In-Reply-To: <20260423212316.3431746-6-dmatlack@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
	<20260423212316.3431746-6-dmatlack@google.com>
Organization: LSG
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F071720010
X-Stat-Signature: yg58oxy34fc6w7rx1bcyfucbaxgaiwjk
X-Rspam-User: 
X-HE-Tag: 1777315669-168558
X-HE-Meta: U2FsdGVkX1/yqvPTHXOJM8A3C4BGaXsCUSwZyvPBotsPJSmD8u9n62ENVo6K/rfkiCGOGFqewca9pgvuO/gU0CXf9bL3aQPTdaVY8He9qKdUegUjCGYv6Me3iKk63gmjEjiAaGpzWHjLOarSC8PqpPQs/h1m7qH4fW8+Gm5pYXoJM18bb3Tv2ORhCu5lHBAHU7VGyAh0cCkknVYpKsBNoh3zSWHP67+9I4hxm43+Ve3LtfrwbcRq7aWdPkQRD/jvKFVwChFNDO0G33osvlpUBz6m9nAzeJ0Ty706hZiytRetRJdE79u28fJ+k6wvNo4quHHMwQYBl5iYjgjq0mZbUxRehAWFHXNMiMXiK5PZF9vY54dGU/vOT3pgHmnRs/qGYWZ9AX2+xDo107/CsiIopBN3HdvfBxlFAejMFZwTl/dOEQsuUcsLzSa9xDoKJr/g7It9Z4O+p8FPnONC/GS9frAUitlciymPinUav32/PYdWltA1usEM4GujbqW8CwFPueVefhbhlwJ80Xr8w+tvimVcEvtYhSJfA6otpXvvwXfBZ126pY1gASTbacPrhpUjP/PGYkMtqdkeL/w9Y/IdLVmp6rszbYwNmXa688pZK5C9z9FL4SOwpgPYkfWlrZM40Z3waT44mOV6gpAG19F+Odc4VWEspYYTWWAqLzJt6KNEnE6eI8TVINiFntniLL/oGyaVeY5aDWic3puH/Ef9htCQcg7F0O5ZYF/gJ9p/WEdw7B8qOgHIU4FBguzVtHDYOoBCdACXbjPIUAEAsnAYLxY/+SjWARVwQ9b4qtMCEaayxjPHEQ7g973fqWGQaKlOqkARTwQw/5vqEMV5xZyUbMwiNiCRKNSO40P84zqVV4nk8ATCp3xfEQ6E22moOvVUFJmACHHK8zDuBfgfRBo0TZaIuWoNyjBrqPwL7g28SpmSbOkuBMk3ntEDNBGMLEtW7Vl6gQzllNj0qBQ9Nhc
 2xyzkS28
 moV0Hf3nHw03VydJ5ubgndzAyavycCrLr+ZTsQq2jJeemAa+GldB+LOrAbWY7cIQrsGXHcuJlCdCxkWEupYwqs4Auj790JmRlZdPREej6aWxZS3KmTPIw4++Pwb8+1ybGE8HlhpCEOI/h6RkUee+w+jXDp2AqOZtN1Rfru5lGRwd416YqHzTGgSV6IqThIGl7TbM6P/fac4FoLEaUyahPW5x1cVqRcshnq8cnNuEX1Rlwh1UCf+pLguyxYRdMCGPBL60EdWl9IXH53zO33W2VGQ0c8SvULvCKo5LuREl5jl1GE4tZ1dhYQD9kvn8iT6vC31+aoC3/ygMtCpXLfaG1V0oGuyBbyu3Bu4SJIM+KywEjjKhKMc6u5p+17x4ZegNrHxvE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Thu, 23 Apr 2026 21:23:09 +0000
David Matlack <dmatlack@google.com> wrote:

> Inherit bus numbers from the previous kernel during a Live Update when
> one or more PCI devices are being preserved.
> 
> During a Live Update, preserved devices must be allowed to continue
> performing memory transactions so the kernel cannot change the fabric
> topology, including bus numbers, since that would require disabling
> and flushing any memory transactions first.
> 
> To keep things simple, inherit the secondary and subordinate bus
> numbers on all bridges if any PCI devices were preserved (i.e. even
> bridges without any downstream endpoints that were preserved). This
> avoids accidentally assigning a bridge a new window that overlaps
> with a preserved device that is downstream of a different bridge.
> 
> If a bridge is enumerated with a broken topology or has no bus numbers
> set during a Live Update, refuse to assign it new bus numbers and
> refuse to enumerate devices below it. This is a safety measure to
> prevent topology conflicts.
> 
> Require that CONFIG_CARDBUS is not enabled to enable
> CONFIG_PCI_LIVEUPDATE since inheriting bus numbers on PCI-to-CardBus
> bridges requires additional work but is not a priority at the moment.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  6 +++-
>  drivers/pci/Kconfig                           |  2 +-
>  drivers/pci/liveupdate.c                      | 28
> +++++++++++++++++++ drivers/pci/probe.c                           |
> 21 +++++++++++--- include/linux/pci.h                           |  1 +
>  5 files changed, 52 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt
> b/Documentation/admin-guide/kernel-parameters.txt index
> cf3807641d89..f412a4b77fb7 100644 ---
> a/Documentation/admin-guide/kernel-parameters.txt +++
> b/Documentation/admin-guide/kernel-parameters.txt @@ -5156,7 +5156,11
> @@ Kernel parameters explicitly which ones they are.
>  		assign-busses	[X86] Always assign all PCI bus
>  				numbers ourselves, overriding
> -				whatever the firmware may have done.
> +				whatever the firmware may have done.
> Ignored
> +				during a Live Update, where the
> kernel must
> +				inherit the PCI topology (including
> bus numbers)
> +				to avoid interrupting ongoing memory
> +				transactions of preserved devices.
>  		usepirqmask	[X86] Honor the possible IRQ mask
> stored in the BIOS $PIR table. This is needed on
>  				some systems with broken BIOSes,
> notably diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 08398cbe970c..6ef457ff9d08 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -330,7 +330,7 @@ config VGA_ARB_MAX_GPUS
>  
>  config PCI_LIVEUPDATE
>  	bool "PCI Live Update Support (EXPERIMENTAL)"
> -	depends on PCI && LIVEUPDATE
> +	depends on PCI && LIVEUPDATE && !CARDBUS
>  	help
>  	  Enable PCI core support for preserving PCI devices across
> Live Update. This, in combination with support in a device's driver,
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index c0a30d16d9b8..cf8cff134a75 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -93,6 +93,19 @@
>   * bound to the correct driver. i.e. The PCI core does not protect
> against a
>   * device getting preserved by driver A in the outgoing kernel and
> then getting
>   * bound to driver B in the incoming kernel.
> + *
> + * BDF Stability
> + * =============
> + *
> + * The PCI core guarantees that incoming preserved devices can be
> identified by
> + * the same bus, device, and function numbers as prior to kexec. To
> accomplish
> + * this, the PCI core always inherits the secondary and subordinate
> bus numbers
> + * assigned to bridges during enumeration, rather than assigning new
> ones (the
> + * PCI core assumes that the previous kernel established a sane
> topology).
> + *
> + * If a misconfigured or unconfigured bridge is encountered during
> enumeration
> + * while there are incoming preserved devices, it's secondary and
> subordinate
> + * bus numbers will be cleared and devices below it will not be
> enumerated. */
>  
>  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
> @@ -354,6 +367,21 @@ void pci_liveupdate_setup_device(struct pci_dev
> *dev) if (!xa)
>  		return;
>  
> +	/*
> +	 * During a Live Update, preserved devices are allowed to
> continue
> +	 * performing memory transactions. The kernel must not
> change the fabric
> +	 * topology, including bus numbers, since that would require
> disabling
> +	 * and flushing any memory transactions first.
> +	 *
> +	 * To keep things simple, inherit the secondary and
> subordinate bus
> +	 * numbers on _all_ bridges if _any_ PCI devices were
> preserved (i.e.
> +	 * even bridges without any downstream endpoints that were
> preserved).
> +	 * This avoids accidentally assigning a bridge a new window
> that
> +	 * overlaps with a preserved device that is downstream of a
> different
> +	 * bridge.
> +	 */
> +	dev->liveupdate_inherit_buses = true;
> +
This flag never gets cleared after the incoming kernel boot up, what if
the user does a manual rescan via sysfs? i.e.
# echo 1 > /sys/bus/pci/rescan
pcibios_assign_all_busses() will never gets called for this device, and
may hit this
	if (dev->liveupdate_inherit_buses) {
		pci_err(dev, "Cannot reconfigure bridge during
		Live Update!\n");

So, maybe clear it in pci_liveupdate_finish()?

>  	key = pci_ser_xa_key(pci_domain_nr(dev->bus),
> pci_dev_id(dev)); dev_ser = xa_load(xa, key);
>  
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 938a28e4a7a0..fa26f4170add 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1374,6 +1374,14 @@ bool pci_ea_fixed_busnrs(struct pci_dev *dev,
> u8 *sec, u8 *sub) return true;
>  }
>  
> +static bool pci_should_assign_new_buses(struct pci_dev *dev)
> +{
> +	if (dev->liveupdate_inherit_buses)
> +		return false;
> +
> +	return pcibios_assign_all_busses();
> +}
> +
>  /*
>   * pci_scan_bridge_extend() - Scan buses behind a bridge
>   * @bus: Parent bus the bridge is on
> @@ -1401,6 +1409,7 @@ static int pci_scan_bridge_extend(struct
> pci_bus *bus, struct pci_dev *dev, int max, unsigned int
> available_buses, int pass)
>  {
> +	const bool assign_new_buses =
> pci_should_assign_new_buses(dev); struct pci_bus *child;
>  	u32 buses;
>  	u16 bctl;
> @@ -1453,8 +1462,7 @@ static int pci_scan_bridge_extend(struct
> pci_bus *bus, struct pci_dev *dev, goto out;
>  	}
>  
> -	if ((secondary || subordinate) &&
> -	    !pcibios_assign_all_busses() && !broken) {
> +	if ((secondary || subordinate) && !assign_new_buses &&
> !broken) { unsigned int cmax, buses;
>  
>  		/*
> @@ -1496,8 +1504,7 @@ static int pci_scan_bridge_extend(struct
> pci_bus *bus, struct pci_dev *dev,
>  		 * do in the second pass.
>  		 */
>  		if (!pass) {
> -			if (pcibios_assign_all_busses() || broken)
> -
> +			if (assign_new_buses || broken)
>  				/*
>  				 * Temporarily disable forwarding of
> the
>  				 * configuration cycles on all
> bridges in @@ -1511,6 +1518,12 @@ static int
> pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev, goto
> out; }
>  
> +		if (dev->liveupdate_inherit_buses) {
> +			pci_err(dev, "Cannot reconfigure bridge
> during Live Update!\n");
> +			pci_err(dev, "Downstream devices will not be
> enumerated!\n");
> +			goto out;
> +		}
> +
>  		/* Clear errors */
>  		pci_write_config_word(dev, PCI_STATUS, 0xffff);
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index dd6b26ca9462..9a602b322e3c 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -511,6 +511,7 @@ struct pci_dev {
>  	unsigned int	rom_bar_overlap:1;	/* ROM BAR
> disable broken */ unsigned int	rom_attr_enabled:1;	/*
> Display of ROM attribute enabled? */ unsigned int
> non_mappable_bars:1;	/* BARs can't be mapped to user-space  */
> +	unsigned int	liveupdate_inherit_buses:1; /* Inherit
> bus numbers due to Live Update */ pci_dev_flags_t dev_flags;
>  	atomic_t	enable_cnt;	/* pci_enable_device has
> been called */ 


