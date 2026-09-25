Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49761C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53D7C6B0092; Fri, 25 Sep 2026 16:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7E96B0093; Fri, 25 Sep 2026 16:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F1A6B0095; Fri, 25 Sep 2026 16:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F05F6B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:02:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8843F120710
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:02:16 +0000 (UTC)
X-FDA: 85253356272.18.02D20F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A3AE640008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:02:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=on3Al0dK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790366534;
	b=FaIj1+icuC7zhHPtUeUQCtTMB1k2tdk6CJIZcNwIXlbKOEGHuiyX+JWxgZI2ba6YavFqLU
	gb6g0UF18TSUIcF1VubF7/3GnBlmvg44KbyzbLykUiCbS/SMS6Wals4w1y93e+ALC6U33k
	RFtpKpY9Z/kE1hCqewkHOBRhEertpi4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=on3Al0dK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790366534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=ZtcT91k1BC068tpcYnPNOSbfWg5Hqn83Pwqha6rsoNc=;
	b=qQmVGcxaXzzIU3kD2JVhx2Kgb7RWcVCQ2r5lEA+BfiHBc/3yWWokifhUXnhZecBHlS1CS9
	yuuWKN5NGcCKfyMonjBuXxqf5kzR0lkMHI8tIBSnZ1gjjLPVUxnvixsfXoGpvXLsqegu42
	A9Sa1di4dFw6yr8Y1WrKWTtWXYwGjXA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 02A4A60136;
	Fri, 25 Sep 2026 20:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824AC1F000FF;
	Fri, 25 Sep 2026 20:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790366533;
	bh=ZtcT91k1BC068tpcYnPNOSbfWg5Hqn83Pwqha6rsoNc=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=on3Al0dKls36XkavMiRKhbx1pcKKa2K91EoZiaTZ0prTK8rD+RHOaik47qljzr34R
	 +GXaeDdTW2vGYZl6qFBRXOHgjGxRgAAgXuw3OUgfk33Nz2H86ebgFuZChQfCvTNX8p
	 mBL7/HF+Y2UAHzVXXHxI+9ybi5qxb2JWKPiI8Pk/8qvo1amDCrGa3vVahXKYdX6Ml/
	 DvoQpVXmDdHo//gb5ORSFA5XyTVA9b8NqMUCFipE3oLVpmhtyXZ9WuEUtxbykuKryD
	 v/oj8bTLN/eyJk6sAVRvEIeqTDZED8fpRR4VDfMtcBdDTVt3Rxm+sPL/Tqv7cdB8Kr
	 kdjnm4M+NMU9w==
Date: Fri, 25 Sep 2026 15:02:12 -0500
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
Subject: Re: [PATCH v9 05/13] PCI: liveupdate: Auto-preserve upstream bridges
 across Live Update
Message-ID: <20260925200212.GA2082495@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918200640.887030-6-dmatlack@google.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 8wnu7mf13xiegcckfaj3exrdtncuwnja
X-Rspam-User: 
X-Rspamd-Queue-Id: A3AE640008
X-HE-Tag: 1790366534-301125
X-HE-Meta: U2FsdGVkX1+bFwTkyfLHtTX80wAVsVc7zy+og3QqBDprxOguB3hBu32L/z6oCGFnaeseXswLOhib4ra8cbBIOh+5D3A84PqcYouuDCO9mcyAOTwWbZTOJisNFqVYMNvgfmskuijNBunzSbZ2Y4QTdfb7nnYLLnrIgjHA9c9/iNkKDhKNh4fBAayUJrxzrPCfEFmuTDfs141QJQ94DT4DAuBZhJ8gVtaoqRST7AgI9Zez6TNI/fu5+KQs8ZciMCXOSOIOq2WovoFHkbnR0Nxm/J00yyjCbwPHs46fh1cWiEjdxGm4LP45Dh/31+VAN5WVzClOI2cQ4P43MXE+0Fk720eFDjB5i8/PV1HBUs04qupKN562wNUsuMxDzQ1b75OyB4JnBKpvO24gcu3MzoFvpfaRAU+6SBLjOgsJVE+wSsrbaueaMqIpAGdHp4d2yK6jyeGHgoDpqC9BrzekyXhZ+W/CroK7SG4MKOgU/UJxO/CrIdx/X4jrsFWvm+9ouqfrWjVMe4LrXSEqJ/nG2CDVT405TKsAYH5sjt8tOCi0DQRbuHQeu9SvFA9Hrk3M029RkJbHE/ker/sMRqJupCD5ArJQH+t6oCIUcHUIgCJ9ETUIK0rPWnsEAoVLXFayy49nxJTB23B1I/cxbKng5vmp7YwfFqp3qlyKcO/eENarS/cfdhwy5tk6OYnq/Jvam1OInZNAcgxRk2hq1aaw8FcDxsBdh/83YNO7nftWfaU/Wo7yQPuGd+VJv70r3YIM0YAqcEvdWp3/NHmfNCp4nW1bpMb7xzgEWpA5QH+mPqByiXES4YzBitObCxtPQmLegKQ4sF12L2ofFVWitc69zP/UCI3igd0aK7aGYCNRZP10StJLPVeE6Cac00OoXCmh6k2seNelWR0zKAYDC588J9z52W4QiKZ2uU5AlBU+FBXTw8AC5XOROzYMhZe7rZRj0bGtCwis03KA0uxwRxLpVg0
 bo9gWfLR
 5Kd44pMZn+CaduiUYieNatpDh4A6mUm5nY59OgYNpKSHinNxX+gf8DJE5C+jTHfUwQiLZtp4yu2zynt1pRgw+iVfx4heU9KSxX3VZXiFCrnfKa8JS+JkgAkz/eJ0BNRKMmK1bUHncoO2W8gpJ1nzH/xPgnW73xlXKXWH6aw/kQ4dWNajegsL79qfxBKx6Yyrf2I0BKbroqj8b56xz1JDhLRu2koQ0Mm2Zwo0mDey3Wb7sWeDYmoCu1BujFnBBebKIFYM8xL9yN1FimUCvaH34u1tEzSMmMG5F1D7sIeTA5P4rGm130sanBeJjVXq08xSx1Vj58Ltu+iBFPkgvWm64J7rQ5f7vca0oT5L5OSCJZ4JY3LI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 08:06:31PM +0000, David Matlack wrote:
> When a PCI device is preserved across a Live Update, all of its upstream
> bridges up to the root port must also be preserved. This enables the PCI
> core and any drivers bound to the bridges to manage bridges correctly
> across a Live Update.
> 
> Notably, this will be used in subsequent commits to ensure that
> preserved devices can continue performing memory transactions without a
> disruption or change in routing.
> 
> To preserve bridges, the PCI core tracks the number of downstream
> devices preserved under each bridge using a reference count in struct
> pci_dev_ser. This allows a bridge to remain preserved until all its
> downstream preserved devices are unpreserved or finish their
> participation in the Live Update.
> 
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/liveupdate.c    | 125 +++++++++++++++++++++++++++---------
>  include/linux/kho/abi/pci.h |   5 +-
>  include/linux/pci.h         |   3 +
>  3 files changed, 99 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index ec8db86ed66d..825df024eec4 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -122,7 +122,6 @@
>   * preserved. These may be relaxed in the future:
>   *
>   *  * The device cannot be a Virtual Function (VF).
> - *  * The device cannot be behind a PCI-to-PCI bridge.
>   *
>   * Driver Binding
>   * ==============
> @@ -137,6 +136,18 @@
>   * bound to the correct driver. The PCI core does not protect against a device
>   * getting preserved by driver A in the outgoing kernel and then getting bound
>   * to driver B in the incoming kernel.
> + *
> + * PCI-to-PCI Bridges
> + * ==================
> + *
> + * Any PCI-to-PCI bridges upstream of a preserved device are automatically
> + * preserved when the device is preserved. The PCI core keeps track of the
> + * number of downstream devices that are preserved under a bridge so that the
> + * bridge is only unpreserved once all downstream devices are unpreserved.
> + *
> + * This enables the PCI core and any drivers bound to the bridge to participate
> + * in the Live Update so that preserved endpoints can continue issuing memory
> + * transactions during the Live Update.
>   */
>  
>  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
> @@ -407,55 +418,84 @@ static struct pci_dev_ser *pci_flb_alloc_dev_ser(struct pci_flb_outgoing *outgoi
>  	return dev_ser;
>  }
>  
> -static void pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
> -					     struct pci_dev *dev)
> +static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
> +					    struct pci_dev *dev)
>  {
>  	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
>  
>  	if (!dev_ser) {
>  		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
> -		return;
> +		return -EINVAL;
>  	}
>  
> +	if (!dev_ser->refcount) {
> +		pci_WARN(dev, 1, "Preserved device has a 0 refcount!\n");
> +		return -EINVAL;
> +	}
> +
> +	if (--dev_ser->refcount)
> +		return 0;
> +
>  	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
>  	outgoing->ser->nr_devices--;
>  	memset(dev_ser, 0, sizeof(*dev_ser));
>  	dev->liveupdate.outgoing = NULL;
> +	return 0;
> +}
> +
> +static void pci_liveupdate_unpreserve_path(struct pci_flb_outgoing *outgoing,
> +					   struct pci_dev *dev,
> +					   struct pci_dev *end)
> +{
> +	for_each_pci_dev_in_path(dev) {
> +		if (dev == end)
> +			break;
> +
> +		if (pci_liveupdate_unpreserve_device(outgoing, dev))
> +			return;
> +	}
>  }
>  
>  static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
>  					  struct pci_dev *dev)
>  {
> -	struct pci_dev_ser *dev_ser;
> -
>  	if (dev->is_virtfn) {
>  		pci_warn(dev, "Cannot preserve Virtual Functions\n");
>  		return -EINVAL;
>  	}
>  
> -	if (dev->liveupdate.outgoing) {
> +	/*
> +	 * Endpoint devices should not be preserved more than once.
> +	 * Bridges are preserved once for every downstream device that
> +	 * is preserved.
> +	 */
> +	if (dev->liveupdate.outgoing && !dev->subordinate) {
>  		pci_warn(dev, "Device is already preserved\n");
>  		return -EBUSY;
>  	}
>  
> -	if (!pci_is_root_bus(dev->bus)) {
> -		pci_warn(dev, "Cannot preserve devices behind bridges\n");
> +	if (dev->liveupdate.outgoing && !dev->liveupdate.outgoing->refcount) {
> +		pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
>  		return -EINVAL;
>  	}
>  
> -	dev_ser = pci_flb_alloc_dev_ser(outgoing);
> -	if (IS_ERR(dev_ser))
> -		return PTR_ERR(dev_ser);
> +	if (!dev->liveupdate.outgoing) {
> +		struct pci_dev_ser *dev_ser;
>  
> -	pci_info(dev, "Device will be preserved across next Live Update\n");
> -	outgoing->ser->nr_devices++;
> -	outgoing->ser->devices = kho_block_set_head_pa(&outgoing->block_set);
> +		dev_ser = pci_flb_alloc_dev_ser(outgoing);
> +		if (IS_ERR(dev_ser))
> +			return PTR_ERR(dev_ser);
>  
> -	dev_ser->domain = pci_domain_nr(dev->bus);
> -	dev_ser->bdf = pci_dev_id(dev);
> -	dev_ser->refcount++;
> +		pci_info(dev, "Device will be preserved across next Live Update\n");
> +		outgoing->ser->nr_devices++;
> +		outgoing->ser->devices = kho_block_set_head_pa(&outgoing->block_set);
> +
> +		dev_ser->domain = pci_domain_nr(dev->bus);
> +		dev_ser->bdf = pci_dev_id(dev);
> +		dev->liveupdate.outgoing = dev_ser;
> +	}
>  
> -	dev->liveupdate.outgoing = dev_ser;
> +	dev->liveupdate.outgoing->refcount++;

Nice, thanks for this, I think it reads much better!

>  	return 0;
>  }
>  
> @@ -468,12 +508,16 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
>   * pci_liveupdate_preserve() from their struct liveupdate_file_handler
>   * preserve() callback to ensure the outgoing struct pci_ser is already set up.
>   *
> + * pci_liveupdate_preserve() automatically preserves all bridges upstream of
> + * @dev.
> + *
>   * Returns: 0 on success, <0 on failure.
>   */
>  int pci_liveupdate_preserve(struct pci_dev *dev)
>  {
>  	struct pci_flb_outgoing *outgoing = NULL;
> -	int ret;
> +	struct pci_dev *start = dev;
> +	int ret = -ENODEV;
>  
>  	guard(rwsem_write)(&pci_liveupdate.rwsem);
>  
> @@ -481,7 +525,13 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
>  	if (IS_ERR(outgoing))
>  		return PTR_ERR(outgoing);
>  
> -	ret = pci_liveupdate_preserve_device(outgoing, dev);
> +	for_each_pci_dev_in_path(dev) {
> +		ret = pci_liveupdate_preserve_device(outgoing, dev);
> +		if (ret) {
> +			pci_liveupdate_unpreserve_path(outgoing, start, dev);
> +			break;
> +		}
> +	}
>  
>  	pci_liveupdate_flb_put_outgoing();
>  	return ret;
> @@ -497,6 +547,9 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
>   * pci_liveupdate_unpreserve() from their struct liveupdate_file_handler
>   * unpreserve() callback to ensure the outgoing struct pci_ser is already set
>   * up.
> + *
> + * pci_liveupdate_unpreserve() automatically unpreserves all bridges upstream of
> + * @dev.
>   */
>  void pci_liveupdate_unpreserve(struct pci_dev *dev)
>  {
> @@ -510,7 +563,7 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
>  		return;
>  	}
>  
> -	pci_liveupdate_unpreserve_device(outgoing, dev);
> +	pci_liveupdate_unpreserve_path(outgoing, dev, /*end=*/NULL);
>  	pci_liveupdate_flb_put_outgoing();
>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
> @@ -600,28 +653,30 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
>  		pci_WARN(dev, 1, "Destroying incoming-preserved device!\n");
>  }
>  
> -static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
> +static int pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
>  {
>  	if (!dev->liveupdate.incoming) {
>  		pci_warn(dev, "Cannot finish preserving an unpreserved device\n");
> -		return;
> +		return -EINVAL;
>  	}
>  
> -	if (dev->liveupdate.incoming->refcount != 1) {
> -		pci_WARN(dev, 1, "Preserved device has a corrupted refcount!\n");
> -		return;
> +	if (!dev->liveupdate.incoming->refcount) {
> +		pci_WARN(dev, 1, "Preserved device has a 0 refcount!\n");
> +		return -EINVAL;
>  	}
>  
>  	/*
> -	 * Drop the refcount so this device does not get treated as an incoming
> -	 * device again, e.g. in case pci_liveupdate_setup_device() gets called
> -	 * again because the device is hot-plugged.
> +	 * Decrement the refcount so this device does not get treated as an
> +	 * incoming device again, e.g. in case pci_liveupdate_setup_device()
> +	 * gets called again because the device is hot-plugged.
>  	 */
> -	dev->liveupdate.incoming->refcount = 0;
> +	if (--dev->liveupdate.incoming->refcount)
> +		return 0;
>  
>  	pci_info(dev, "Device is finished participating in Live Update\n");
>  	dev->liveupdate.incoming = NULL;
>  	ser->nr_devices--;
> +	return 0;
>  }
>  
>  /**
> @@ -633,6 +688,8 @@ static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *de
>   * Update. Drivers must call pci_liveupdate_finish() from their struct
>   * liveupdate_file_handler finish() callback to ensure the incoming struct
>   * pci_ser is allocated.
> + *
> + * pci_liveupdate_finish() automatically finishes all bridges upstream of @dev.
>   */
>  void pci_liveupdate_finish(struct pci_dev *dev)
>  {
> @@ -646,7 +703,11 @@ void pci_liveupdate_finish(struct pci_dev *dev)
>  		return;
>  	}
>  
> -	pci_liveupdate_finish_device(incoming->ser, dev);
> +	for_each_pci_dev_in_path(dev) {
> +		if (pci_liveupdate_finish_device(incoming->ser, dev))
> +			break;
> +	}
> +
>  	pci_liveupdate_flb_put_incoming();
>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
> diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> index 4096e3cd3324..9485ed73c351 100644
> --- a/include/linux/kho/abi/pci.h
> +++ b/include/linux/kho/abi/pci.h
> @@ -24,7 +24,7 @@
>   */
>  
>  #define PCI_LUO_FLB_COMPATIBLE "pci"
> -#define PCI_LUO_FLB_VERSION 1
> +#define PCI_LUO_FLB_VERSION 2
>  
>  /**
>   * struct pci_dev_ser - Serialized state about a single PCI device.
> @@ -33,7 +33,8 @@
>   * @bdf: The device's PCI bus, device, and function number.
>   * @refcount: Reference count used by the PCI core to keep track of whether it
>   *            is done using a device's struct pci_dev_ser. The value of the
> - *            refcount is equal to 1 when the struct pci_dev_ser is in use, and
> + *            refcount is equal to the number of preserved devices at or below
> + *            it in the PCI hierarchy when the struct pci_dev_ser is in use, and
>   *            0 otherwise.
>   */
>  struct pci_dev_ser {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 76abe884e3dc..b35ac263c451 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -836,6 +836,9 @@ static inline struct pci_dev *pci_upstream_bridge(struct pci_dev *dev)
>  	return dev->bus->self;
>  }
>  
> +#define for_each_pci_dev_in_path(dev) \
> +	for (; dev; dev = pci_upstream_bridge(dev))
> +
>  #ifdef CONFIG_PCI_MSI
>  static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev)
>  {
> -- 
> 2.55.0.1082.g2b9226bbc0-goog
> 

