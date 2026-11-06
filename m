Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3416606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 16:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XUh+X1MB
Received: by kanga.kvack.org (Postfix)
	id 143436B05BA; Fri,  6 Nov 2026 11:53:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B606B05BB; Fri,  6 Nov 2026 11:53:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009246B05BC; Fri,  6 Nov 2026 11:53:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D11956B05BA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:53:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AFBE80159
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:53:18 +0000 (UTC)
X-FDA: 85405289676.26.9382C3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B629A1C000E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:53:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XUh+X1MB;
	spf=pass (imf18.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793983996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=Gz2u9EnCGWdtrTqR4hVa9tGdXR6zdtpqvvIAqGLjrwU=;
	b=qBdQD6NeKQPJhY46wU8YZV5oyRx1a4KNQQc5Qln9bukzfSMgXCmr1XbDiy59raFuCEBCa0
	zux+3gKYq/9rfskYB3bvqb6B6FuTXH7TFXeL28wZTc5ugumR2h3n/1L37IS6T5QyBYGJaR
	SM29Z+7tICRIoXvDYu/rMWW3lsCv4ZU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XUh+X1MB;
	spf=pass (imf18.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793983996;
	b=PxuI4UsTpSZj+T2I6tltSGN5C04fZiinJVwWVhWmgL0MdhRqqyoQdNY2Uw3nJnXQTzbsuj
	K0pCffXw8FweXzQSMVFAd6MEvl/HOi1nSYbzu3t/pH3KIA98wFCFkAZbII4843ZXM1w+du
	qDrfAaFEEEuoKMLasGAZa30JLnXuFag=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ECCD94380E;
	Fri,  6 Nov 2026 16:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5ECB1F0089F;
	Fri,  6 Nov 2026 16:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793983995;
	bh=Gz2u9EnCGWdtrTqR4hVa9tGdXR6zdtpqvvIAqGLjrwU=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=XUh+X1MB7/4juUrSebMdcjlE1Ia+8doHHosmD1izvgtD+MPOx4GTKqKDwphSWps8L
	 X6JCDN6fVeM6SVsEVAxS9aXGXvJ1WwItPwLEJpHvukCIIJZelxqMtqcDkBH4YR0M4M
	 qcxySM6I8n1XV9+ZSlJaJLOpNXIln2zqrvSxowQqeM/6dtIc+uZygEi+PAbREUCjz7
	 ngKFcjAHboW34I0FPVn0yUyt/VdcDr3svkx5yGZN0xf7wrRi9Bg9ND3JZqqBr/wOZZ
	 fPmtC6G2xO5cvAizlaTWReFwY7wvVnE6cgWegHXRlznhjSOAacDC3im2FHnb2UCLMR
	 Shc/bG22V1Udg==
Date: Fri, 6 Nov 2026 10:53:14 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v10 03/13] PCI: liveupdate: Track incoming preserved PCI
 devices
Message-ID: <20261106165314.GA1632197@bhelgaas>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013162529.1928093-4-dmatlack@google.com>
X-Stat-Signature: a7gyufo8dhjwwn585ifh7debsw1ibnq5
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B629A1C000E
X-HE-Tag: 1793983996-953476
X-HE-Meta: U2FsdGVkX1+32VwERzMbmbuV92qc7ukFi8iB4Ubd3S2y4dNY+4SnYQKqTthOb261vkg+o5wwAPu8bLNPKuoI70R178AW3eEuUmKrmcZ7QQ8649MpkYH01AjlDrY6DN5Gah++l++TdWIUXiPU+YUQKyy28L+pQ26O3I2ofqCNw4wVNuElBrFjSXMxJS7lQX1utnQz/m8qgLWCPSHFZNuA5BPfzqkXtlD5dKTMhkC0S9/HX/6pTVP3ncWmdSEOq5jJKj02yJ4TKPRWCrSCPNorKu5JWUIazU1v4p6fxAVjVAzg7Qa/OreUGkAAhkPCoisnJ5JdZCXTQXQzNvbTBAlA5V1Q2RzQE66/opCR6Iw6lIyVUnText7500DLQjdkzJrd0OFwD7OJvin644X2yzGtO/JifKm4qxwmPc+EFRvaVkZK2RGN+FTc4gcpWsbrHUffqtQ9+nzzujXPKAxHeV373c0J5Xl6JyHNZIdSQEJzUSCScc7pxYPVC9xvOhRkcF2QMURQs5JtOo2fe6SJSNTVoiNyDAgeTyaJPtukTsAbpt9H2qyQdG6+9sc6+32TRF29O9h9AYSFx1xvZt32seMtRDK4HGiw+iqsYhqLv+rjOUTS1mOqMzPeNcOM0j9mAutJgHSLjqjNJZtkOHaqFjnAUMU/DPHggz2zzuH9ZlXjYXeZFTJJo6VJ4mXxq/P0Ckhlf1pgACPY4id49brlBDeYYDOvd6Mea486v4E67vUkQfcIO09VX2LnVcaI3R3vm86w3gEiyRPdD86CY43uU7Izo3TTOCHPGZAoS2JbsaDprYOhvx9tGlrPcVWjFSV785Etg33D72OzdfDfjIZ36QjG7dNqWFamKfkL9PW8CpumM3ay+iJRyI36UtTiHA/Bdtyi2JHBZqfq1nQ5/60Zpf7IK1SFYK+1EfgrZH5rGQnSrJpnenkYEmfa6AcfFMcbTo+U6qt0RUR4ICJiPhkZnYl
 bKBDzGM4
 eqWPrDUj72TeRnzYa8D+lhgRVCzQssmwcHp+qm2SCdqoqmYCXcUTeW4v3Xmfnib1FmkTqPpNI2V/NDV9MCyMMxy5+Z988Ni5aE7+BX0ywBFZDPHALXSsBmvdY/XT4AMRsCUq1gEWfY74fMMDJEvdzXH8ybtm2kTvBba5vBKEbhGXkHi+9ud1rY8iYEDH04FO88xlanK41OEOecUHUoU3qfaHT2NFywwkKJJSqbHA0glBo4fhZQ5t0e92yc680MeS/+8mwr9Hnk4+Lvr+lMlKGQYLNo3gl1kOgYPF0fVwj0M12KIs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 13, 2026 at 04:25:19PM +0000, David Matlack wrote:
> During PCI enumeration, the previous kernel might have passed state about
> devices that were preserved across kexec. The PCI core needs to fetch
> this state to identify which devices are "incoming" and require special
> handling.
> 
> Add pci_liveupdate_setup_device() which is called during device setup
> to fetch the serialized state (struct pci_ser) from the Live Update
> Orchestrator. The first time this happens, pci_flb_retrieve() will run
> and convert the array of pci_dev_ser structs into an xarray so that it
> can be looked up efficiently.
> 
> If a device is found in the xarray, the PCI core stores a pointer to its
> state in dev->liveupdate_incoming until pci_liveupdate_finish() is
> called by the driver. This pointer allows the PCI core and drivers to
> apply Live Update-specific logic to incoming devices in subsequent
> commits.
> 
> Drivers can check if a device is an incoming preserved device (e.g.
> during probe) by calling pci_liveupdate_is_incoming().
> 
> Note that any error during pci_flb_retrieve() must be treated as fatal.
> The previous kernel handed off PCI devices that are performing DMA and
> the current kernel cannot safely take over those devices without this
> state.
> 
> pci_flb_retrieve() panics if the previous kernel set a bit in
> required_flags that this kernel does not know how to handle, or if
> struct pci_dev_ser entries are smaller than PCI_DEV_SER_MIN_SIZE. Fields
> appended to struct pci_dev_ser by the previous kernel are ignored.
> 
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  MAINTAINERS                    |   1 +
>  drivers/pci/liveupdate.c       | 302 ++++++++++++++++++++++++++++++++-
>  drivers/pci/liveupdate.h       |   5 +
>  drivers/pci/probe.c            |   3 +
>  include/linux/pci_liveupdate.h |  13 ++
>  5 files changed, 318 insertions(+), 6 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bb9ef5460b5c..3eacaa98775c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -21056,6 +21056,7 @@ L:	linux-pci@vger.kernel.org
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
>  F:	drivers/pci/liveupdate.c
> +F:	drivers/pci/liveupdate.h
>  F:	include/linux/kho/abi/pci.h
>  F:	include/linux/pci_liveupdate.h
>  
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 22d5d177e104..a1d9b2b1f9e3 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -45,6 +45,11 @@
>   * it (e.g. during enumeration), and pci_flb_finish() frees it once the PCI
>   * core is done with it.
>   *
> + * State handed over by the previous kernel is trusted. The PCI core validates
> + * it only far enough to detect an incompatible or corrupt hand over, and makes
> + * no attempt to defend against deliberate modification, since a previous kernel
> + * able to corrupt preserved state is able to corrupt arbitrary memory anyway.
> + *
>   * Call Flow
>   * ---------
>   *
> @@ -69,14 +74,17 @@
>   *
>   *   # ---------------- kexec ----------------
>   *
> - *   # New kernel: the PCI core asks for the previous kernel's state
> - *   liveupdate_flb_get_incoming()
> - *     luo_flb_retrieve_one()             # first request only
> - *       pci_flb_retrieve()               # previous kernel's struct pci_ser
> + *   # New kernel: PCI enumeration
> + *   pci_setup_device()
> + *     pci_liveupdate_setup_device()
> + *       liveupdate_flb_get_incoming()
> + *         luo_flb_retrieve_one()         # first request only
> + *           pci_flb_retrieve()           # previous kernel's struct pci_ser
>   *
>   *   # Userspace: ioctl(LIVEUPDATE_SESSION_FINISH)
>   *   luo_file_finish_one()
>   *     fh->ops->finish()                  # driver callback
> + *       pci_liveupdate_finish(dev)       # release this device's pci_dev_ser
>   *     luo_flb_file_finish()
>   *       liveupdate_flb_put_incoming()    # last incoming file only
>   *         pci_flb_finish()               # free struct pci_ser
> @@ -93,6 +101,20 @@
>   * This allows the PCI core to keep its FLB data (struct pci_ser) up to date
>   * with the list of **outgoing** preserved devices for the next kernel.
>   *
> + * After kexec, whenever a device is enumerated, the PCI core will check if it
> + * is an **incoming** preserved device (i.e. preserved by the previous kernel)
> + * by checking the incoming FLB data (struct pci_ser).
> + *
> + * Drivers must notify the PCI core when an **incoming** device is done
> + * participating in the incoming Live Update with the following API:
> + *
> + *  * ``pci_liveupdate_finish(pci_dev)``
> + *
> + * The PCI core does not enforce any ordering of ``pci_liveupdate_finish()`` and
> + * ``pci_liveupdate_preserve()``, i.e., a PCI device can be **outgoing**
> + * (preserved for next kernel) and **incoming** (preserved by previous kernel)
> + * at the same time.
> + *
>   * Restrictions
>   * ============
>   *
> @@ -144,6 +166,34 @@ struct pci_flb_outgoing {
>  	struct kho_block_set block_set;
>  };
>  
> +/**
> + * struct pci_flb_incoming - Incoming PCI FLB object
> + * @ser: The incoming struct pci_ser from the previous kernel.
> + * @xa: Xarray used to quickly lookup devices in @ser.
> + * @block_set: The KHO block set holding the incoming devices.
> + *
> + * This structure holds the runtime state for the incoming PCI Live Update
> + * state. It wraps the serialized pci_ser, the block_set used to restore
> + * the serialized entries, and an xarray for fast lookups.
> + */
> +struct pci_flb_incoming {
> +	struct pci_ser *ser;
> +	struct xarray xa;
> +	struct kho_block_set block_set;
> +};
> +
> +/*
> + * Bits in struct pci_ser::required_flags that this kernel knows how to handle.
> + * No flags are currently defined.
> + */
> +#define PCI_SER_REQUIRED_FLAGS_SUPPORTED	0ULL
> +
> +/* PCI_LIVEUPDATE depends on 64BIT, so domain and bdf always fit. */
> +static unsigned long pci_ser_xa_key(u32 domain, u16 bdf)
> +{
> +	return (unsigned long)domain << 16 | bdf;
> +}
> +
>  static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
>  {
>  	struct pci_flb_outgoing *outgoing __free(kfree) = NULL;
> @@ -184,17 +234,115 @@ static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
>  	kfree(outgoing);
>  }
>  
> +/*
> + * Any failure here is fatal. The previous kernel handed over devices that are
> + * still performing DMA, and this kernel cannot identify them without this
> + * state. Continuing would let the PCI core reassign bus numbers and rebind
> + * drivers underneath live devices, so fail loudly instead of unwinding.
> + */
>  static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
>  {
> +	struct pci_ser *ser = phys_to_virt(args->data);
> +	struct pci_flb_incoming *incoming;
> +	struct pci_dev_ser *dev_ser;
> +	struct kho_block_set_it it;
> +	int ret;
> +
>  	pr_debug("Retrieving struct pci_ser (0x%llx)\n", args->data);
> -	args->obj = phys_to_virt(args->data);
> +
> +	if (ser->required_flags & ~PCI_SER_REQUIRED_FLAGS_SUPPORTED)
> +		panic("Incoming PCI FLB requires unsupported features (0x%llx)\n",
> +		      ser->required_flags & ~PCI_SER_REQUIRED_FLAGS_SUPPORTED);
> +
> +	/*
> +	 * The previous kernel may have appended fields to struct pci_dev_ser,
> +	 * which this kernel ignores, but every entry must be at least the
> +	 * minimum size.
> +	 */
> +	if (ser->dev_ser_size < PCI_DEV_SER_MIN_SIZE)
> +		panic("Incoming PCI FLB has unsupported struct pci_dev_ser size (%u)\n",
> +		      ser->dev_ser_size);
> +
> +	incoming = kzalloc_obj(*incoming);
> +	if (!incoming)
> +		panic("Failed to allocate struct pci_flb_incoming\n");
> +
> +	incoming->ser = ser;
> +	xa_init(&incoming->xa);
> +
> +	kho_block_set_init(&incoming->block_set, ser->dev_ser_size);
> +	ret = kho_block_set_restore(&incoming->block_set, ser->devices);
> +	if (ret)
> +		panic("Failed to restore devices KHO block set (%d)\n", ret);
> +
> +	kho_block_set_it_init(&it, &incoming->block_set);
> +	while ((dev_ser = kho_block_set_it_read_entry(&it))) {
> +		unsigned long key;
> +
> +		if (!dev_ser->refcount)
> +			continue;
> +
> +		key = pci_ser_xa_key(dev_ser->domain, dev_ser->bdf);
> +		ret = xa_insert(&incoming->xa, key, dev_ser, GFP_KERNEL);
> +		if (ret)
> +			panic("Failed to insert PCI device %04x:%02x:%02x.%d into xarray (%d)\n",
> +			      dev_ser->domain, PCI_BUS_NUM(dev_ser->bdf),
> +			      PCI_SLOT(dev_ser->bdf), PCI_FUNC(dev_ser->bdf),
> +			      ret);
> +	}
> +
> +	args->obj = incoming;
>  	return 0;
>  }
>  
> +static void pci_check_all_devices_finished(struct pci_flb_incoming *incoming)
> +{
> +	struct pci_dev_ser *dev_ser;
> +	unsigned long index;
> +	u32 nr_devices;
> +
> +	/*
> +	 * nr_devices is only decremented by pci_liveupdate_finish_device().
> +	 * This runs once the last reference to the incoming FLB is dropped, so
> +	 * there are no finishers left in flight.
> +	 */
> +	nr_devices = incoming->ser->nr_devices;
> +	if (nr_devices == 0)
> +		return;
> +
> +	/*
> +	 * Report the unfinished devices from the incoming FLB rather than by
> +	 * walking struct pci_dev, so that devices that never showed up after
> +	 * kexec, or that were destroyed before they finished, are identified
> +	 * as well.
> +	 */
> +	xa_for_each(&incoming->xa, index, dev_ser) {
> +		if (!dev_ser->refcount)
> +			continue;
> +
> +		pr_emerg("%04x:%02x:%02x.%d was never finished!\n",
> +			 dev_ser->domain, PCI_BUS_NUM(dev_ser->bdf),
> +			 PCI_SLOT(dev_ser->bdf), PCI_FUNC(dev_ser->bdf));
> +	}
> +
> +	/*
> +	 * This should only happen if a driver violated the contract to call
> +	 * pci_liveupdate_finish() (something is extremely broken).
> +	 */
> +	panic("%u preserved device(s) were never finished!\n", nr_devices);
> +}
> +
>  static void pci_flb_finish(struct liveupdate_flb_op_args *args)
>  {
> +	struct pci_flb_incoming *incoming = args->obj;
> +
>  	pr_debug("Finished struct pci_ser (0x%llx)\n", args->data);
> -	kho_restore_free(args->obj);
> +	pci_check_all_devices_finished(incoming);
> +
> +	xa_destroy(&incoming->xa);
> +	kho_block_set_destroy(&incoming->block_set);
> +	kho_restore_free(incoming->ser);
> +	kfree(incoming);
>  }
>  
>  static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
> @@ -371,6 +519,75 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
>  
> +static struct pci_flb_incoming *pci_liveupdate_flb_get_incoming(void)
> +{
> +	struct pci_flb_incoming *incoming = NULL;
> +	int ret;
> +
> +	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&incoming);
> +
> +	/* Live Update is not enabled. */
> +	if (ret == -EOPNOTSUPP)
> +		return NULL;
> +
> +	/* Live Update is enabled, but there is no incoming FLB data. */
> +	if (ret == -ENODATA)
> +		return NULL;
> +
> +	/*
> +	 * Live Update is enabled and there is incoming FLB data, but none of it
> +	 * matches pci_liveupdate_flb.compatible.
> +	 */
> +	if (ret == -ENOENT)
> +		return NULL;
> +
> +	/*
> +	 * There is incoming FLB data that matches pci_liveupdate_flb.compatible
> +	 * but retrieve failed (pci_flb_retrieve() returned an error or LUO
> +	 * failed to acquire a reference to pci_liveupdate_flb_ops.owner).
> +	 */
> +	if (ret)
> +		panic("Failed to retrieve incoming FLB data (%d)\n", ret);
> +
> +	return incoming;
> +}
> +
> +static void pci_liveupdate_flb_put_incoming(void)
> +{
> +	liveupdate_flb_put_incoming(&pci_liveupdate_flb);
> +}
> +
> +void pci_liveupdate_setup_device(struct pci_dev *dev)
> +{
> +	struct pci_flb_incoming *incoming;
> +	struct pci_dev_ser *dev_ser;
> +	unsigned long key;
> +
> +	guard(rwsem_write)(&pci_liveupdate.rwsem);
> +
> +	incoming = pci_liveupdate_flb_get_incoming();
> +	if (!incoming)
> +		return;
> +
> +	key = pci_ser_xa_key(pci_domain_nr(dev->bus), pci_dev_id(dev));
> +	dev_ser = xa_load(&incoming->xa, key);
> +
> +	/*
> +	 * This device was not preserved across Live Update, or it was preserved
> +	 * but has already been probed and gone through pci_liveupdate_finish(),
> +	 * e.g. due to removing and re-adding the device. Either way, it's not
> +	 * treated as incoming-preserved.
> +	 */
> +	if (!dev_ser || !dev_ser->refcount) {
> +		pci_liveupdate_flb_put_incoming();
> +		return;
> +	}
> +
> +	pci_info(dev, "Device was preserved by previous kernel across Live Update\n");
> +	dev->liveupdate.incoming = dev_ser;
> +	pci_liveupdate_flb_put_incoming();
> +}
> +
>  void pci_liveupdate_cleanup_device(struct pci_dev *dev)
>  {
>  	/*
> @@ -382,7 +599,80 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
>  	 */
>  	if (READ_ONCE(dev->liveupdate.outgoing))
>  		pci_WARN(dev, 1, "Destroying outgoing-preserved device!\n");
> +
> +	if (READ_ONCE(dev->liveupdate.incoming))
> +		pci_WARN(dev, 1, "Destroying incoming-preserved device!\n");
> +}
> +
> +static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
> +{
> +	if (!dev->liveupdate.incoming) {
> +		pci_warn(dev, "Cannot finish preserving an unpreserved device\n");
> +		return;
> +	}
> +
> +	if (dev->liveupdate.incoming->refcount != 1) {
> +		pci_WARN(dev, 1, "Preserved device has a corrupted refcount!\n");
> +		return;
> +	}
> +
> +	/*
> +	 * Drop the refcount so this device does not get treated as an incoming
> +	 * device again, e.g. in case pci_liveupdate_setup_device() gets called
> +	 * again because the device is hot-plugged.
> +	 */
> +	dev->liveupdate.incoming->refcount = 0;
> +
> +	pci_info(dev, "Device is finished participating in Live Update\n");
> +	dev->liveupdate.incoming = NULL;
> +	ser->nr_devices--;
> +}
> +
> +/**
> + * pci_liveupdate_finish() - Finish the preservation of a PCI device
> + * @dev: The PCI device
> + *
> + * pci_liveupdate_finish() notifies the PCI core that a PCI device that was
> + * preserved across the previous Live Update has finished participating in Live
> + * Update. Drivers must call pci_liveupdate_finish() from their struct
> + * liveupdate_file_handler finish() callback to ensure the incoming struct
> + * pci_ser is allocated.
> + */
> +void pci_liveupdate_finish(struct pci_dev *dev)
> +{
> +	struct pci_flb_incoming *incoming;
> +
> +	guard(rwsem_write)(&pci_liveupdate.rwsem);
> +
> +	incoming = pci_liveupdate_flb_get_incoming();
> +	if (!incoming) {
> +		pci_warn(dev, "Cannot finish preserving device without incoming FLB\n");
> +		return;
> +	}
> +
> +	pci_liveupdate_finish_device(incoming->ser, dev);
> +	pci_liveupdate_flb_put_incoming();
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
> +
> +/**
> + * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
> + * @dev: The PCI device to check
> + *
> + * Check if a device was preserved across Live Update by the previous kernel,
> + * i.e. the device is incoming-preserved. Note that a device is only considered
> + * incoming-preserved prior to pci_liveupdate_finish(). It is up to drivers to
> + * synchronize usage of pci_liveupdate_is_incoming() with their own call to
> + * pci_liveupdate_finish() to avoid acting on stale data.
> + *
> + * Returns: True if the device is incoming-preserved, false otherwise.
> + */
> +bool pci_liveupdate_is_incoming(struct pci_dev *dev)
> +{
> +	guard(rwsem_read)(&pci_liveupdate.rwsem);
> +	return dev->liveupdate.incoming;
>  }
> +EXPORT_SYMBOL_GPL(pci_liveupdate_is_incoming);
>  
>  /**
>   * pci_liveupdate_register_flb() - Register a file handler with the PCI core
> diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
> index b2335581f8d0..eaaa3559fd77 100644
> --- a/drivers/pci/liveupdate.h
> +++ b/drivers/pci/liveupdate.h
> @@ -11,8 +11,13 @@
>  #include <linux/pci.h>
>  
>  #ifdef CONFIG_PCI_LIVEUPDATE
> +void pci_liveupdate_setup_device(struct pci_dev *dev);
>  void pci_liveupdate_cleanup_device(struct pci_dev *dev);
>  #else
> +static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
> +{
> +}
> +
>  static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
>  {
>  }
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 2a37e5d3e8e3..ad7fdf0d56b6 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -2065,6 +2065,8 @@ int pci_setup_device(struct pci_dev *dev)
>  	if (pci_early_dump)
>  		early_dump_pci_device(dev);
>  
> +	pci_liveupdate_setup_device(dev);
> +
>  	/* Need to have dev->class ready */
>  	dev->cfg_size = pci_cfg_space_size(dev);
>  
> @@ -2188,6 +2190,7 @@ int pci_setup_device(struct pci_dev *dev)
>  	default:				    /* unknown header */
>  		pci_err(dev, "unknown header type %02x, ignoring device\n",
>  			dev->hdr_type);
> +		pci_liveupdate_cleanup_device(dev);
>  		pci_release_of_node(dev);
>  		return -EIO;
>  
> diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
> index 894052ad6961..710026ada2d5 100644
> --- a/include/linux/pci_liveupdate.h
> +++ b/include/linux/pci_liveupdate.h
> @@ -16,9 +16,11 @@
>  /**
>   * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
>   * @outgoing: State preserved for the next kernel.
> + * @incoming: State preserved by the previous kernel.
>   */
>  struct pci_liveupdate {
>  	struct pci_dev_ser *outgoing;
> +	struct pci_dev_ser *incoming;
>  };
>  
>  struct pci_dev;
> @@ -28,6 +30,8 @@ int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
>  void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh);
>  int pci_liveupdate_preserve(struct pci_dev *dev);
>  void pci_liveupdate_unpreserve(struct pci_dev *dev);
> +void pci_liveupdate_finish(struct pci_dev *dev);
> +bool pci_liveupdate_is_incoming(struct pci_dev *dev);
>  #else
>  static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
>  {
> @@ -46,6 +50,15 @@ static inline int pci_liveupdate_preserve(struct pci_dev *dev)
>  static inline void pci_liveupdate_unpreserve(struct pci_dev *dev)
>  {
>  }
> +
> +static inline void pci_liveupdate_finish(struct pci_dev *dev)
> +{
> +}
> +
> +static inline bool pci_liveupdate_is_incoming(struct pci_dev *dev)
> +{
> +	return false;
> +}
>  #endif
>  
>  #endif /* LINUX_PCI_LIVEUPDATE_H */
> -- 
> 2.56.0.385.gd3acb90ef8-goog
> 

