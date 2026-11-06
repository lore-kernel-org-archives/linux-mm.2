Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79265606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xb7yl0Xv
Received: by kanga.kvack.org (Postfix)
	id 820556B05B5; Fri,  6 Nov 2026 13:40:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1D16B05B6; Fri,  6 Nov 2026 13:40:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E78B6B05B7; Fri,  6 Nov 2026 13:40:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0E66B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:40:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D0ECA8018F
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:40:07 +0000 (UTC)
X-FDA: 85405558854.01.702EC3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3B5BEA0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:40:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xb7yl0Xv;
	spf=pass (imf15.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793990406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=CpICwym72YG5FzmGNLZ7e4BGuF42O7YTN8yD95c9zhQ=;
	b=sPS4BU173OhpHd+OsgvsVnb7kIiMt1Z/goV2gve8nlHt632gkv0RRvqLuh/FMOfy3S+A/T
	sv05rzl1g+0VI2iAObYcHuAV5H+IrAyp35XHudpyldfrzShVaaeQdn/Uco1f5No4Pp7uJw
	wfbLrERHy4kvG1oS8E8zqQFfiXg9hGE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793990406;
	b=xZ6d8+CVKV17B5NBM3cp7eFLJgnnYpXDfSrl6JRgmihKCysWyzGJY+Gs/8ytuzOEBiBRw3
	JwJXw8T+GA0mkR8k1ENuj86eSu3498pnUprq/JL25mAIwOKBBM+4BYSDRU9rbMHu4mRZiF
	urBVnBOb4cyedYFAswbsqVoj6HZ92ro=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xb7yl0Xv;
	spf=pass (imf15.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 685A14166A;
	Fri,  6 Nov 2026 18:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1141F0089F;
	Fri,  6 Nov 2026 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793990405;
	bh=CpICwym72YG5FzmGNLZ7e4BGuF42O7YTN8yD95c9zhQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=Xb7yl0Xv5COAxlnBn69RMPPK4zSBM/bZh6T33t1fFl9S6ILcLtE5eIhOKxpr2UDXT
	 Xj3oYVlCDsBdBs6fb+DG9DnLMlxSYeTIpDLM0SNx4QLXkDdiG5spQDShCzR2pF2KGd
	 A4f2aKj9vPho4LXFpatWXX6YsET8IGV0K0+50yEjxkmYUv4aTZyTHD1ukObVAWtdc0
	 H0oh2dJot7OdOQBw5qJtL0gAsDxbcarncXXWlVI4VildgGUblBvYK7zE2L7+kGCEo5
	 aC2XDaeMI2g9ROTeo1cev3+/+QKJ3M34/HD1siQeySFH/5zRpRTFxFaV+Unq6RHSqK
	 EYxaNr1G2L9aA==
Date: Fri, 6 Nov 2026 12:40:03 -0600
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
Subject: Re: [PATCH v10 05/13] PCI: liveupdate: Auto-preserve upstream
 bridges across Live Update
Message-ID: <20261106184003.GA1641106@bhelgaas>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013162529.1928093-6-dmatlack@google.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ysceo9msjtn64ondzy1xixrymj8npaqr
X-Rspamd-Queue-Id: 3B5BEA0005
X-Rspam-User: 
X-HE-Tag: 1793990406-110909
X-HE-Meta: U2FsdGVkX19KsFqIjd9GIdeuYu2GJ9tkXRcnvWWQewvjpebuD7JfktzVVb78oVex2JtxrwnWpbJ/6FTjnGFwxN1T1iyuuVp1Od7bvldHtDg1CBCtzpa2tRAYAYhbIvYUqZ7nT5yV3EG8G8pp2nYfFWLuAIlTzLOjvpYxziajhCXnZYiML7ht8bVa5WlehSg+VB1uH7xuDD7WzbzlGWV00Cp6PnHjNXQNjERVxSnke6gC81cS6RKBARTkoHgV1LUTvsHATrvPK3j6ibgj1aBPEvGOheylcDgrjXGFELV+M3m68J0+Bsr4tigpUJfNqQorCuLcDX7dnkBqe71potOQCAS43+zlxPohGbn8avpJFG1c3WlLlL27wbGZKZCQ57htwHszhxLS4FvgZqqecnM0vu8b9ZiU/WA6fnhBwka5zvvqijLw+G2YTuTib1qvgmiRcdkOlU/QSqMZTQKSiztI0ZokmYVP9/Fzu0uAjMEHbT+rFcdcxuAeAPDfN+KNOyGPdGAuKCc0iWI+MyByKK6vijqq+mJpAaXbIm89tEmSP7XneJLSK6nzpyZ9deOo9QLfRZMhQQIuk7dsHc6N/h0LjCL8kPEepBLQPvnjLGlTWRxCJxYSDY7um135Xg0LklsAAp/gQmsYKOaCatm2IG9s5rOO2VcbprVl3twcKDpmYyf4XYUJU8WtgLRSAzRZ3wuSx3ZGd1E1T5r4zZKN8Ba9/Ewts9IXLBSFkqtesxFtifUjOBqZmVyhaZ1ZT7/d7HcdthTG1ZCF9UVBXx6nE2h7KhWeEPJZfGRVdF1aflXE6RKvzk9ck7XtM6zBLqMhSGZaWsOgj2o6E8IGfA0Hi2nis/sQu4D+x7hs/1Pbk6qP6wq6lIcaTnDs792SZZEb3Grs9eSh2mJDhS8VJGfOc8/vYt9DBEPF+fBbuPHm8xhJwbr9/CbrdYbeaVG7673NgJeZogacofmmHEsailn22HB
 3IepcnVg
 W0+luvvFsDGktMqCfebsjOHervIHn0rUYF+mHH4WVtgd7D0qyo5WEQ/8bLsvXTftBmTrZAmfOHFa9zauDECKanm2obUHicDpz56yPP6bvRNlNiUjAsTDuroWLTAxbjMNzv+I5pl2lIt/+j6POVEuavXYhInNQBHVQxgMENgrBYCJlaYBQn3IZo0sjfkaTRq6/Znt3RYsxYCe9yfVf0g6wkfqNlXAczma8vAeEVSjvUpGBKXctlShui01XYptiwJQjIoW4nZ4ZGqsvWPVvw74AR+P8Z+GrWaRumyCb2KYJHShaqfBl67A9VflbO4va7H4UDPzC5dDqRd53ykngHICLNMwrllpqupRuZL6uIXLyYOBVshs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 13, 2026 at 04:25:21PM +0000, David Matlack wrote:
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
>  drivers/pci/liveupdate.c | 125 +++++++++++++++++++++++++++++----------
>  include/linux/pci.h      |   3 +
>  2 files changed, 96 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index d6b659b346bb..bffb3e1d8b2d 100644
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
> @@ -425,55 +436,84 @@ static struct pci_dev_ser *pci_flb_alloc_dev_ser(struct pci_flb_outgoing *outgoi
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
>  	return 0;
>  }
>  
> @@ -486,12 +526,16 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
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
> @@ -499,7 +543,13 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
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
> @@ -515,6 +565,9 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
>   * pci_liveupdate_unpreserve() from their struct liveupdate_file_handler
>   * unpreserve() callback to ensure the outgoing struct pci_ser is already set
>   * up.
> + *
> + * pci_liveupdate_unpreserve() automatically unpreserves all bridges upstream of
> + * @dev.
>   */
>  void pci_liveupdate_unpreserve(struct pci_dev *dev)
>  {
> @@ -528,7 +581,7 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
>  		return;
>  	}
>  
> -	pci_liveupdate_unpreserve_device(outgoing, dev);
> +	pci_liveupdate_unpreserve_path(outgoing, dev, /*end=*/NULL);
>  	pci_liveupdate_flb_put_outgoing();
>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
> @@ -618,28 +671,30 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
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
> @@ -651,6 +706,8 @@ static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *de
>   * Update. Drivers must call pci_liveupdate_finish() from their struct
>   * liveupdate_file_handler finish() callback to ensure the incoming struct
>   * pci_ser is allocated.
> + *
> + * pci_liveupdate_finish() automatically finishes all bridges upstream of @dev.
>   */
>  void pci_liveupdate_finish(struct pci_dev *dev)
>  {
> @@ -664,7 +721,11 @@ void pci_liveupdate_finish(struct pci_dev *dev)
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
> 2.56.0.385.gd3acb90ef8-goog
> 

