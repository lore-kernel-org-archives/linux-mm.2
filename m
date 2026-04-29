Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A54FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 22:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2E016B0088; Wed, 29 Apr 2026 18:28:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05AB6B008A; Wed, 29 Apr 2026 18:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C7C6B008C; Wed, 29 Apr 2026 18:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF0ED6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:28:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BD5BA040C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:28:20 +0000 (UTC)
X-FDA: 84713033160.22.2D63B77
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 613358000F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:28:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=W9PFJauS;
	spf=pass (imf02.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777501698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nNaeytT1WfkYlrb7aq4OM5BymIk3oCnk59yTBTmQPMc=;
	b=xHkaupPTSt4e2EFP6/27ngd4K06vAOq7CzjknzOxr1fRr10mPN7vc4E2CmftjWbTDsyo0B
	D3IFWgtThozXmPiVhM0gMJA++xE3n+8UlNR77xIwM9X/TNZZrAbYXOx7cW8ZRRFakuPfOi
	ABiyl85nEll50ifrBNTzGCG/RsFEM1I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777501698; a=rsa-sha256;
	cv=none;
	b=JKTZo7XWcFuOPqFAQcmv9Qrri9X4zeA/LmMZqDloErhLcRq/ugsazDHEO821nPmbPjoKPN
	CPh7yQe3n4eXUOs4cbPli/RtT6Qm1ouB81k06Ud2p1lIZcjcEZr8fb28+gv5TGZDQazE8C
	jDo6EniJXgS2MnRLI1aV4xe3HWKBPLA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=W9PFJauS;
	spf=pass (imf02.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from localhost (unknown [20.236.11.29])
	by linux.microsoft.com (Postfix) with ESMTPSA id B332D20B716C;
	Wed, 29 Apr 2026 15:28:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B332D20B716C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1777501697;
	bh=nNaeytT1WfkYlrb7aq4OM5BymIk3oCnk59yTBTmQPMc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=W9PFJauSunK2M1P7HpxoCdIEe/7dds3W8ifeRq+H+GIEPZIql+z+ll5f8Oi8pnA5k
	 stF9yPMgyiXGStTt9LoWiMYlFXVCGkHR4jBbO6Qv+M68ZVMuno2zYfiGGjcdCd8LfU
	 3eBJCFTPEacmBO2mKO6fT5KCiB/jVoL0/2gljJdk=
Date: Wed, 29 Apr 2026 15:28:14 -0700
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
Message-ID: <20260429152814.000005f7@linux.microsoft.com>
In-Reply-To: <ae_SHCjNGrEPurzH@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
	<20260423212316.3431746-6-dmatlack@google.com>
	<20260427114745.00000656@linux.microsoft.com>
	<ae_J2pRWFf5qjZXb@google.com>
	<ae_SHCjNGrEPurzH@google.com>
Organization: LSG
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 613358000F
X-Stat-Signature: 9oswyzg4f8fpfj5oy4sgrshkugjjpt9g
X-Rspam-User: 
X-HE-Tag: 1777501698-177212
X-HE-Meta: U2FsdGVkX19Qe0XuGPojvT3dUek/qOQ49f4oFW+x+5ZDbWmYtomk2MEiQXhYn7kilIuADRoTuvEaIw+esu6q4Ufbc7tnPBP9L+LWDxukSuW1LUmnna2qtgHM7xZC0b8+9tLOkIZh5mjCTYIwXOFPFRlldGFaMi5PlqgVSDyUONky6MRG/RMsBj6iJMs1V2VYJi3KegL11huthJk/tbn1YRWbXDnzr2Y6CVK8ZdpUg4IOCE/gOH5xWFIWPbPd1oxDLzzNiGM3UBuCSZeW2rganZJ0vNzCbB3f0LzNxz0t4rxIXPc/tSDfzTYmh+xVHbFWHlxNEqSA1mq6/LC6CoVXcZ1AJ1l1DnAgl3VZy6RjxbcoIdXw/W5ZoE3jPVtZXnQsylKv4Z211Kyabas8u56uNeAWb5L9QrBEo/60Um7rrCems/8iw2n0GibeuOLCytH4Q3cJ6JWJXBpt+tNPKJS9spCROsjBx9cS9o40xM+6VLOVaKkMXQaqHKzWUpHCBQg1oVksY5f2OJNzmbvFS0xzvU2SDZI/EKHsS/6rOGFJHNVzvdACfSdGR74PBxePF0T3I9opG7dmaizB0EbTa4xV2W5h1Ci+SgQQ/O+4/gMWG+Ftb961DPiER/U1WC1SeaF30NAKD5ESoUdVOQa78ykZJ3C8WY7SeftGy7Z5xwC+ct6jWyYLLHrNBakbFVZatBuHyjSBt6GNv/q/+TmpgtPJiHYHpeOZ2LnO9hcQR4vyKiHZgaR1hs3CvrvX4rnGNAVzEh9hIJAlrwqJOZuKxQYjKnjRmFjkqcDTXRMJXvmv+Nb85CdPS2LDBg+pF1wei8E8T93jVQma1nlIA+RrbS7/fTOLxOJzdMxIeIWOoQKreKD7MaZHYfzljIVwU4X7zCDZRdsAWqgxAzsyHY/uos05xCRVWhZOKDuzJwFoRGCAs4YyH5HY2KO2X9JRj5veTKTL+HvJVvEjFMHx3h5j5M1
 BcVleAi8
 fCJhdLTSeF4udfcF2x/xFOMnSYb/Z2yNBlXvXdz03e8eYYv2B0vRa64l3avjSvXwtoG4lpUS0XZJueAxwENzi9SFx/8rb2ZeDDT240m7BdL65KJd8IzX2XRfND0BC/+M/KD8QN4yDKJ7MH7xxO9DHoEoOtzyxzuXQiOHKsCvPXx6m2iV9cvwCY+2NSOFlXiRDgqN5Irr44uC4yCrR9rJyfxV4YmlyD6BqgiPF+Cag+e6WA0MsLWDBngZ+k/m7NvG8G82/XvF0j7XkN4jD1nSjUyTwkFVvgRtkh3EDYXAZi/b3eyGHlcS7tc5AdKhMQMolT/pXQnxceN8As4J9jIFmo2B40LZbn/wZ3yiyIZva7ffGix8YJKpZzSSoqF93UfNK7NzX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Mon, 27 Apr 2026 21:16:12 +0000
David Matlack <dmatlack@google.com> wrote:

> On 2026-04-27 08:40 PM, David Matlack wrote:
> > On 2026-04-27 11:47 AM, Jacob Pan wrote:  
> > > On Thu, 23 Apr 2026 21:23:09 +0000
> > > David Matlack <dmatlack@google.com> wrote:  
> >   
> > > > To keep things simple, inherit the secondary and subordinate bus
> > > > numbers on all bridges if any PCI devices were preserved (i.e.
> > > > even bridges without any downstream endpoints that were
> > > > preserved). This avoids accidentally assigning a bridge a new
> > > > window that overlaps with a preserved device that is downstream
> > > > of a different bridge.
> > > > 
> > > > If a bridge is enumerated with a broken topology or has no bus
> > > > numbers set during a Live Update, refuse to assign it new bus
> > > > numbers and refuse to enumerate devices below it. This is a
> > > > safety measure to prevent topology conflicts.
> > > > 
> > > > Require that CONFIG_CARDBUS is not enabled to enable
> > > > CONFIG_PCI_LIVEUPDATE since inheriting bus numbers on
> > > > PCI-to-CardBus bridges requires additional work but is not a
> > > > priority at the moment.
> > > > 
> > > > Signed-off-by: David Matlack <dmatlack@google.com>  
> >   
> > > > +	/*
> > > > +	 * During a Live Update, preserved devices are allowed
> > > > to continue
> > > > +	 * performing memory transactions. The kernel must not
> > > > change the fabric
> > > > +	 * topology, including bus numbers, since that would
> > > > require disabling
> > > > +	 * and flushing any memory transactions first.
> > > > +	 *
> > > > +	 * To keep things simple, inherit the secondary and
> > > > subordinate bus
> > > > +	 * numbers on _all_ bridges if _any_ PCI devices were
> > > > preserved (i.e.
> > > > +	 * even bridges without any downstream endpoints that
> > > > were preserved).
> > > > +	 * This avoids accidentally assigning a bridge a new
> > > > window that
> > > > +	 * overlaps with a preserved device that is downstream
> > > > of a different
> > > > +	 * bridge.
> > > > +	 */
> > > > +	dev->liveupdate_inherit_buses = true;
> > > > +  
> > > This flag never gets cleared after the incoming kernel boot up,
> > > what if the user does a manual rescan via sysfs? i.e.
> > > # echo 1 > /sys/bus/pci/rescan
> > > pcibios_assign_all_busses() will never gets called for this
> > > device, and may hit this
> > > 	if (dev->liveupdate_inherit_buses) {
> > > 		pci_err(dev, "Cannot reconfigure bridge during
> > > 		Live Update!\n");
> > > 
> > > So, maybe clear it in pci_liveupdate_finish()?  
> > 
> > I think we can allo wa rescan to assign new bus numbers once all
> > devices go through pci_liveupdate_finish() by clearing
> > dev->liveupdate_inherit_buses on all devices in pci_flb_finish(). We
> > would need to hold pci_rescan_remove_lock to avoid this racing with
> > such a rescan.
> > 
> > Now that you bring up /sys/bus/pci/rescan... I think we also need to
> > set dev->liveupdate_inherit_buses in the outgoing kernel, to avoid
> > bus numbers changing on outgoing preserved devices.
> > pci_flb_preserve() should take pci_rescan_remove_lock and set
> > dev->liveupdate_inherit_buses on all devices, and
> > pci_flb_unpreserve() should do the opposite.
> > 
> > If we did all then then /sys/bus/pci/rescan can work like normal as
> > long as no devices are preserved (incoming or outgoing). If any
> > devices are preserved then dev->liveupdate_inherit_buses gets set
> > to prevent bus numbers from changing during a possible rescan.  
> 
> Something like this? This is a diff applied on top of this commit.
Below looks correct to me, but I have another question. How do you
stablize PCI BARs? PCI BDF stability does not guarantee BARs don't get
moved, right?

> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index fead478e8a04..b1b0a5b1a5df 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -120,6 +120,20 @@
>  
>  #include "pci.h"
>  
> +/*
> + * During a Live Update, preserved devices are allowed to continue
> performing
> + * memory transactions. The kernel must not change the fabric
> topology,
> + * including bus numbers, since that would require disabling and
> flushing any
> + * memory transactions first.
> + *
> + * To keep things simple, inherit the secondary and subordinate bus
> numbers on
> + * _all_ bridges if _any_ PCI devices are preserved (i.e.  even
> bridges without
> + * any downstream endpoints that were preserved).  This avoids
> accidentally
> + * assigning a bridge a new window that overlaps with a preserved
> device that is
> + * downstream of a different bridge.
> + */
> +static atomic_t inherit_buses;
> +
>  struct pci_flb_outgoing {
>  	/* The pci_ser struct to be passed to the next kernel */
>  	struct pci_ser *ser;
> @@ -141,6 +155,29 @@ static unsigned long pci_ser_xa_key(unsigned
> long domain, unsigned long bdf) return domain << 16 | bdf;
>  }
>  
> +bool pci_liveupdate_inherit_buses(void)
> +{
> +	return atomic_read(&inherit_buses);
> +}
> +
> +static void pci_set_liveupdate_inherit_buses(bool enable)
> +{
> +	/* Ensure updates to inherit_buses do not race with rescans
> */
> +	pci_lock_rescan_remove();
> +
> +	/*
> +	 * Increment/decrement instead of setting directly to
> true/false so that
> +	 * pci_liveupdate_inherit_buses() returns true if any device
> is outgoing
> +	 * preserved or incoming preserved.
> +	 */
> +	if (enable)
> +		atomic_inc(&inherit_buses);
> +	else
> +		atomic_dec(&inherit_buses);
> +
> +	pci_unlock_rescan_remove();
> +}
> +
>  static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
>  {
>  	struct pci_flb_outgoing *outgoing;
> @@ -180,6 +217,8 @@ static int pci_flb_preserve(struct
> liveupdate_flb_op_args *args) 
>  	args->obj = outgoing;
>  	args->data = virt_to_phys(outgoing->ser);
> +
> +	pci_set_liveupdate_inherit_buses(true);
>  	return 0;
>  }
>  
> @@ -187,6 +226,8 @@ static void pci_flb_unpreserve(struct
> liveupdate_flb_op_args *args) {
>  	struct pci_flb_outgoing *outgoing = args->obj;
>  
> +	pci_set_liveupdate_inherit_buses(false);
> +
>  	pr_debug("Unpreserving struct pci_ser\n");
>  	WARN_ON_ONCE(outgoing->ser->nr_devices);
>  	kho_unpreserve_free(outgoing->ser);
> @@ -223,6 +264,8 @@ static int pci_flb_retrieve(struct
> liveupdate_flb_op_args *args) }
>  
>  	args->obj = incoming;
> +
> +	pci_set_liveupdate_inherit_buses(true);
>  	return 0;
>  }
>  
> @@ -230,6 +273,8 @@ static void pci_flb_finish(struct
> liveupdate_flb_op_args *args) {
>  	struct pci_flb_incoming *incoming = args->obj;
>  
> +	pci_set_liveupdate_inherit_buses(false);
> +
>  	xa_destroy(&incoming->xa);
>  	kho_restore_free(incoming->ser);
>  	kfree(incoming);
> @@ -385,21 +430,6 @@ void pci_liveupdate_setup_device(struct pci_dev
> *dev) if (!xa)
>  		return;
>  
> -	/*
> -	 * During a Live Update, preserved devices are allowed to
> continue
> -	 * performing memory transactions. The kernel must not
> change the fabric
> -	 * topology, including bus numbers, since that would require
> disabling
> -	 * and flushing any memory transactions first.
> -	 *
> -	 * To keep things simple, inherit the secondary and
> subordinate bus
> -	 * numbers on _all_ bridges if _any_ PCI devices were
> preserved (i.e.
> -	 * even bridges without any downstream endpoints that were
> preserved).
> -	 * This avoids accidentally assigning a bridge a new window
> that
> -	 * overlaps with a preserved device that is downstream of a
> different
> -	 * bridge.
> -	 */
> -	dev->liveupdate_inherit_buses = true;
> -
>  	key = pci_ser_xa_key(pci_domain_nr(dev->bus),
> pci_dev_id(dev)); dev_ser = xa_load(xa, key);
>  
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 09bab39738d7..abd8379b99cf 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -1442,6 +1442,7 @@ static inline int pci_msix_write_tph_tag(struct
> pci_dev *pdev, unsigned int inde #ifdef CONFIG_PCI_LIVEUPDATE
>  void pci_liveupdate_setup_device(struct pci_dev *dev);
>  void pci_liveupdate_cleanup_device(struct pci_dev *dev);
> +bool pci_liveupdate_inherit_buses(void);
>  #else
>  static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
>  {
> @@ -1450,6 +1451,11 @@ static inline void
> pci_liveupdate_setup_device(struct pci_dev *dev) static inline void
> pci_liveupdate_cleanup_device(struct pci_dev *dev) {
>  }
> +
> +static inline bool pci_liveupdate_inherit_buses(void)
> +{
> +	return false;
> +}
>  #endif
>  
>  #endif /* DRIVERS_PCI_H */
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index fa26f4170add..f94fa1fc76cc 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1374,9 +1374,9 @@ bool pci_ea_fixed_busnrs(struct pci_dev *dev,
> u8 *sec, u8 *sub) return true;
>  }
>  
> -static bool pci_should_assign_new_buses(struct pci_dev *dev)
> +static bool pci_should_assign_new_buses(void)
>  {
> -	if (dev->liveupdate_inherit_buses)
> +	if (pci_liveupdate_inherit_buses())
>  		return false;
>  
>  	return pcibios_assign_all_busses();
> @@ -1409,7 +1409,7 @@ static int pci_scan_bridge_extend(struct
> pci_bus *bus, struct pci_dev *dev, int max, unsigned int
> available_buses, int pass)
>  {
> -	const bool assign_new_buses =
> pci_should_assign_new_buses(dev);
> +	const bool assign_new_buses = pci_should_assign_new_buses();
>  	struct pci_bus *child;
>  	u32 buses;
>  	u16 bctl;
> @@ -1518,7 +1518,7 @@ static int pci_scan_bridge_extend(struct
> pci_bus *bus, struct pci_dev *dev, goto out;
>  		}
>  
> -		if (dev->liveupdate_inherit_buses) {
> +		if (pci_liveupdate_inherit_buses()) {
>  			pci_err(dev, "Cannot reconfigure bridge
> during Live Update!\n"); pci_err(dev, "Downstream devices will not be
> enumerated!\n"); goto out;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 9a602b322e3c..dd6b26ca9462 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -511,7 +511,6 @@ struct pci_dev {
>  	unsigned int	rom_bar_overlap:1;	/* ROM BAR
> disable broken */ unsigned int	rom_attr_enabled:1;	/*
> Display of ROM attribute enabled? */ unsigned int
> non_mappable_bars:1;	/* BARs can't be mapped to user-space  */
> -	unsigned int	liveupdate_inherit_buses:1; /* Inherit
> bus numbers due to Live Update */ pci_dev_flags_t dev_flags;
>  	atomic_t	enable_cnt;	/* pci_enable_device has
> been called */ 


