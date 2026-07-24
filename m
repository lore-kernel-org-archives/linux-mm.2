Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E666C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 20:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3F86B007B; Fri, 24 Jul 2026 16:55:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94506B0088; Fri, 24 Jul 2026 16:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F1A6B008A; Fri, 24 Jul 2026 16:55:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 714CF6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:55:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 002ACA038F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 20:55:10 +0000 (UTC)
X-FDA: 85024875180.20.F556756
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7944FC0002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 20:55:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPsO4F40;
	spf=pass (imf10.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784926509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=Rats3+uLlkKdYpRmDANFsMR8vfU9QiGYu7LLlmwp1U4=;
	b=QwDrBmWPpMLJ8nyQkcZBpNZvpbUV2XLBbatm+ClntI68GnoP78KoWcPxkZ6xQjDqRmDKGm
	G8/odycVTYvQcLdvOvHGprP9tTQPGd6VTrCRBfMIkLzXlG/rXF9twOxz0dyfm0rx6IvdZN
	rBuYYfK6zTOsbmT2dhrkPF7dUojmuyw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784926509;
	b=ZEALspNkBWREeYc0Ca+YXNTX6dUIas6Vxe5N3kFbAQQixEK/Da0iTbTfUteXGaBQt+H6FV
	4t0P/2Sg+Fg9qcm/co3+GW9kcZOM0LlyG9niO/XfKmt8UuB6It6PRb28SxWHLRe6TrAHBI
	eCQACyOX5q1+t711KQmdNBdBopzZqnk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPsO4F40;
	spf=pass (imf10.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 858DD600AD;
	Fri, 24 Jul 2026 20:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC9A1F000E9;
	Fri, 24 Jul 2026 20:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784926508;
	bh=Rats3+uLlkKdYpRmDANFsMR8vfU9QiGYu7LLlmwp1U4=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=PPsO4F40UmciD6/goxygKCj0jjauWWjsloRfZU7YFZhQouG91hdWwPU8+9OOxQBpY
	 SvBIzR+AyP/ZtBl37B+AiwoXZ0gZQlALq/H82AMgGFVfCG0uTUXZPI3kSh9pF93cWj
	 zPiv/0TFkDQstMdB9TyA3fsXZh6EAqM2B8B8KM+oL+IkFCo+ooh8b63RM9ZdKAk8jJ
	 TMAoylSMAqQaxnA+6tnYKJhSuu6r2vxnn8PWbLz6oOIPBZDnsP1ZivqmBJRVL8Mp2I
	 QCUYto3jCrjYJzhruoAd/Id4AJD46zHFlYAPAkuwq7xHWWseLgZ0E4g4FwN9sPG4eI
	 /uKQdVW2IwMGw==
Date: Fri, 24 Jul 2026 15:55:06 -0500
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
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v7 06/12] PCI: liveupdate: Auto-preserve upstream bridges
 across Live Update
Message-ID: <20260724205506.GA1012423@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710212616.1351130-7-dmatlack@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7944FC0002
X-Stat-Signature: 3qp6o987nq6cd8k1ekjox1arzg1pxa35
X-Rspam-User: 
X-HE-Tag: 1784926509-651887
X-HE-Meta: U2FsdGVkX180qDei+AkGiYzvh+ghxnLK5Og6PlW4l1kNsbC/HmFjZYCiQNpUvQ3/awGrwn34emPaebJ9c4Y9VXkfgodn1Lmz6eTCst4Mlgl2QzwImic+KXPjLxysQ0qQzrfjpi3K6rsUjgNa2wabSii6yzseIMl9aqWJ9pt2XWipZRO+5Eqcl4r126dq5N1MIYYfCOBEnz8ei3t4U2keHoU7tyRkjp2Of0i3vWBN9UQUC47sDvJUof6nn6ebQtvfm5k2xOSR3JB/wgZwoKNN0uEvBOst8wirhX+4QYQa1qzfiA2aKdCJG0/j0pZNT9TgjP/Wk6ZvZPmZW8bOSlaO5eUG0Y1XAmnSX62l5OvnExzzHXu4zLwAezbr07j5x+NGYcna+FA/VjIm653yNWpCWFMJU4nfJyAG421hp4ALQw9bj2Xsh+s0dk55JmFA09inLXTPoyoBN+iaYy6lZQh5CpHTS/QH2CXldRVBGWj/fqW+kDh07ya6g7ArmFIFK1My1wwdDimRftr0SJGWF1DyYmo9xJAlJCz147EUfO1VbrU+mX9GOMO5M9ApiUCGFK2aRxPw7MI59TeTaJ5Lb2S15no0homj9OC09BN5KSIbQRUX3jTDhler2Vvyx8b67mXDJWSD+DfB0PDPz4MtRk8eDslmNoeccn/12fVpi0LQLX28jmHFuR8PirLMj3CT4oduGars/eXEdWDuucInReVj4r6W2dk014ftIbpDphV5GhdYt/5CU4drVZdFga7iTpcJdz18vqOHDFeHrziRnaln5UBWE03T4xwQTnzKfXEwc0VZ/oRyPiTMTGrGaiORWzAK7gwBRF4YUrWpG6qHQMDoUfjqnDmsJ3R9rGDGyhvG7heYym3zAlF7pXuiM3ziTVcFgKZbDUrgi8m8goR6+Dz/IxPpI1oTdrLm9DlxApDUQnRXSeA9FCIEf+7+9+h4siWZTX7LE1X7IbFubVxY8ee
 pSGMtJqL
 L5N8xhZgwgDHeaxX1xbjJJVkA+9DLzlz9R1CkcqSS+IJzkkVRVh8Ipg8iJwRsEkgBUl8pJirKupEBg7yjAm90aFZPqBTbftcj2ZoW0yS0Avlng+Ovkv5ghftQ5SVFc3Odzv/+xcarO1zSandurtHuup0ypeyC03apbWAf0TB0xE9Gbq+fG5bRPelnKaV8ec9ajAh06mq1Jobu/wc5vD1QZyTGtMft8FR/R9jvxXQhfDcj2rtmMZUD7Tnj4UEf2sbDPFKRBpSkqtc1pdxyP+OejkI/u5I+zCrylpyy0/f9QnzKLKk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:26:09PM +0000, David Matlack wrote:
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
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/liveupdate.c    | 136 +++++++++++++++++++++++++++++++-----
>  include/linux/kho/abi/pci.h |   5 +-
>  2 files changed, 122 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index b2b950d71657..7f7710cb1da0 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -101,6 +101,18 @@
>   * If a misconfigured or unconfigured bridge is encountered during enumeration
>   * while there are preserved devices, its secondary and subordinate bus numbers
>   * will be cleared and devices below it will not be enumerated.
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
>  #define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt
> @@ -316,28 +328,52 @@ static struct pci_dev_ser *pci_get_empty_or_append(struct pci_flb_outgoing *outg
>  	return dev_ser;
>  }
>  
> -static void pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing, struct pci_dev *dev)
> +static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing, struct pci_dev *dev)
>  {
>  	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
>  
>  	if (!dev_ser) {
>  		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
> -		return;
> +		return -EINVAL;
> +	}
> +
> +	if (!dev_ser->refcount) {
> +		pci_WARN(dev, 1, "Preserved device has a 0 refcount!\n");
> +		return -EINVAL;
>  	}
>  
> +	if (--dev_ser->refcount)
> +		return 0;
> +
>  	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
>  	outgoing->ser->nr_devices--;
>  	memset(dev_ser, 0, sizeof(*dev_ser));
>  	dev->liveupdate.outgoing = NULL;
> +	return 0;
>  }
>  
> -static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing, struct pci_dev *dev)
> +static int pci_liveupdate_preserve_device_again(struct pci_dev *dev)

Could pci_liveupdate_preserve_device_again() be folded into
pci_liveupdate_preserve_device()?  That's the only caller, and having
so many *liveupdate_preserve*() functions gets to be a bit of a maze
of small functions:

  __pci_liveupdate_preserve_device
  pci_liveupdate_preserve_device_again
  pci_liveupdate_preserve_device
  pci_liveupdate_preserve_path
  pci_liveupdate_preserve

Maybe even more could be squashed; pci_liveupdate_preserve() is the
only caller of pci_liveupdate_preserve_path(), which is itself the
only caller of pci_liveupdate_preserve_device().

As a reader, I think there's some advantage in collecting the whole
"preserve" flow in one place, but maybe nesting depth would be an
issue, especially for the unpreserve cleanup in the failure path.
Maybe a "goto" error path could mitigate part of that.

If there's any squashing, I guess the place to start would be in
earlier patches, e.g., "PCI: liveupdate: Track outgoing preserved PCI
devices" and "PCI: liveupdate: Track incoming preserved PCI devices".

>  {
> -	struct pci_dev_ser *dev_ser;
> +	if (!dev->liveupdate.outgoing->refcount) {
> +		pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
> +		return -EINVAL;
> +	}
>  
> -	if (dev->liveupdate.outgoing)
> +	/*
> +	 * Endpoint devices should not be preserved more than once. Bridges are
> +	 * preserved once for every downstream device that is preserved.
> +	 */
> +	if (!dev->subordinate)
>  		return -EBUSY;
>  
> +	dev->liveupdate.outgoing->refcount++;
> +	return 0;
> +}
> +
> +static int __pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing, struct pci_dev *dev)
> +{
> +	struct pci_dev_ser *dev_ser;
> +
>  	dev_ser = pci_get_empty_or_append(outgoing);
>  	if (IS_ERR(dev_ser))
>  		return PTR_ERR(dev_ser);
> @@ -354,6 +390,52 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing, str
>  	return 0;
>  }
>  
> +static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing, struct pci_dev *dev)
> +{
> +	if (dev->liveupdate.outgoing)
> +		return pci_liveupdate_preserve_device_again(dev);
> +
> +	return __pci_liveupdate_preserve_device(outgoing, dev);
> +}
> +
> +#define for_each_pci_dev_in_path(_d, _start, _end) \
> +	for ((_d) = (_start); (_d) != (_end); (_d) = (_d)->bus->self)

I think you might want pci_upstream_bridge() instead of (_d)->bus->self;
see https://git.kernel.org/linus/c6bde215acfd ("PCI: Add
pci_upstream_bridge()").  I think VFs are currently out of scope, but 
no harm in making this future-proof.

Other than "_end", this looks fairly generic and might be a candidate
for putting in include/linux/pci.h.  I think there might be other
potential users, e.g., calc_map_type_and_dist(),
pci_enable_atomic_ops_to_root(), pcie_bandwidth_available(),
get_upstream_port(), pcie_find_root_port(),
pci_is_thunderbolt_attached().

The "_end" termination case could perhaps be done in the body instead
of the macro since it depends on the use case and several of the other
loops that iterate over the path already include terminations in the
body.

> +static void __pci_liveupdate_unpreserve_path(struct pci_flb_outgoing *outgoing,
> +					     struct pci_dev *start,
> +					     struct pci_dev *end)
> +{
> +	struct pci_dev *dev;
> +
> +	for_each_pci_dev_in_path(dev, start, end) {
> +		if (pci_liveupdate_unpreserve_device(outgoing, dev))
> +			return;
> +	}
> +}
> +
> +static void pci_liveupdate_unpreserve_path(struct pci_flb_outgoing *outgoing,
> +					   struct pci_dev *start)
> +{
> +	__pci_liveupdate_unpreserve_path(outgoing, start, /*end=*/NULL);
> +}
> +
> +static int pci_liveupdate_preserve_path(struct pci_flb_outgoing *outgoing,
> +					struct pci_dev *start)
> +{
> +	struct pci_dev *dev;
> +	int ret;
> +
> +	for_each_pci_dev_in_path(dev, start, NULL) {
> +		ret = pci_liveupdate_preserve_device(outgoing, dev);
> +		if (ret) {
> +			__pci_liveupdate_unpreserve_path(outgoing, start, dev);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * pci_liveupdate_preserve() - Preserve a PCI device across Live Update
>   * @dev: The PCI device to preserve.
> @@ -363,6 +445,9 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing, str
>   * pci_liveupdate_preserve() from their struct liveupdate_file_handler
>   * preserve() callback to ensure the outgoing struct pci_ser is already set up.
>   *
> + * pci_liveupdate_preserve() automatically preserves all bridges upstream of
> + * @dev.
> + *
>   * Returns: 0 on success, <0 on failure.
>   */
>  int pci_liveupdate_preserve(struct pci_dev *dev)
> @@ -378,7 +463,7 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
>  	if (IS_ERR(outgoing))
>  		return PTR_ERR(outgoing);
>  
> -	return pci_liveupdate_preserve_device(outgoing, dev);
> +	return pci_liveupdate_preserve_path(outgoing, dev);
>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
>  
> @@ -391,6 +476,9 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
>   * pci_liveupdate_unpreserve() from their struct liveupdate_file_handler
>   * unpreserve() callback to ensure the outgoing struct pci_ser is already set
>   * up.
> + *
> + * pci_liveupdate_unpreserve() automatically unpreserves all bridges upstream of
> + * @dev.
>   */
>  void pci_liveupdate_unpreserve(struct pci_dev *dev)
>  {
> @@ -404,7 +492,7 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
>  		return;
>  	}
>  
> -	pci_liveupdate_unpreserve_device(outgoing, dev);
> +	pci_liveupdate_unpreserve_path(outgoing, dev);
>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
>  
> @@ -594,29 +682,41 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
>  	}
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
>  	pci_liveupdate_flb_put_incoming();
> +	return 0;
> +}
> +
> +static void pci_liveupdate_finish_path(struct pci_ser *ser, struct pci_dev *start)
> +{
> +	struct pci_dev *dev;
> +
> +	for_each_pci_dev_in_path(dev, start, NULL) {
> +		if (pci_liveupdate_finish_device(ser, dev))
> +			return;
> +	}
>  }
>  
>  /**
> @@ -628,6 +728,8 @@ static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *de
>   * Update. Drivers must call pci_liveupdate_finish() from their struct
>   * liveupdate_file_handler finish() callback to ensure the incoming struct
>   * pci_ser is allocated.
> + *
> + * pci_liveupdate_finish() automatically finishes all bridges upstream of @dev.
>   */
>  void pci_liveupdate_finish(struct pci_dev *dev)
>  {
> @@ -641,7 +743,7 @@ void pci_liveupdate_finish(struct pci_dev *dev)
>  		return;
>  	}
>  
> -	pci_liveupdate_finish_device(incoming->ser, dev);
> +	pci_liveupdate_finish_path(incoming->ser, dev);
>  	pci_liveupdate_flb_put_incoming();
>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
> diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> index de549016807a..acf1b38dff02 100644
> --- a/include/linux/kho/abi/pci.h
> +++ b/include/linux/kho/abi/pci.h
> @@ -23,7 +23,7 @@
>   * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
>   */
>  
> -#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
> +#define PCI_LUO_FLB_COMPATIBLE "pci-v2"
>  
>  /**
>   * struct pci_dev_ser - Serialized state about a single PCI device.
> @@ -32,7 +32,8 @@
>   * @bdf: The device's PCI bus, device, and function number.
>   * @refcount: Reference count used by the PCI core to keep track of whether it
>   *            is done using a device's struct pci_dev_ser. The value of the
> - *            refcount is equal to 1 when the struct pci_dev_ser is in use, and
> + *            refcount is equal to the number of preserved devices at or below
> + *            it in the PCI hierarchy when the struct pci_dev_ser is in use, and
>   *            0 otherwise.
>   */
>  struct pci_dev_ser {
> -- 
> 2.55.0.795.g602f6c329a-goog
> 

