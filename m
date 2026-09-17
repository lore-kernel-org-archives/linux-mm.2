Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF8BC982CC
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 00:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 220B76B008C; Wed, 16 Sep 2026 20:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F73F6B0092; Wed, 16 Sep 2026 20:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135BC6B0093; Wed, 16 Sep 2026 20:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D47766B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:07:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F042114019A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:07:27 +0000 (UTC)
X-FDA: 85221314934.13.6C8927B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 715D42000A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:07:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UjbTsEtV;
	spf=pass (imf03.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789603646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=+yFcjzj37ujFduHmXiBvfG9JBS833j3YXgLJ04CFxHE=;
	b=qdnfQ4OmXJjvrJ03jNW3ubr/P2+s2wdvmytVamRwv22b72hKDoutQlH8IjPAK3tXU7DekI
	Fd0qPDw/kNEjl+VhFeupwaPm1GEp7QS8NUhUkBXGuVHpR05IgfWE1goNKVS8RnTxQvFK3V
	uZe9OoCki0wSehZ7J+BowQjdkuhZ8Yc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789603646;
	b=whC8l2hWYOKBkW1pmEhz7TGQvzf2EQ8mOfOJ926xHm3xgPUzvVhtJary/MlSRQj159OVMU
	x2ZzfmxV8XYyNzOWT983DrPEoiSbpow5LLccth5qeL2b6E1zae6RZZ3TfZwHDoCjS3bIw+
	qej/k6ujAjNGj8KOQCXQknzyL0W831E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UjbTsEtV;
	spf=pass (imf03.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BB6E601EF;
	Thu, 17 Sep 2026 00:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5DF1F000FF;
	Thu, 17 Sep 2026 00:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789603644;
	bh=+yFcjzj37ujFduHmXiBvfG9JBS833j3YXgLJ04CFxHE=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=UjbTsEtVaPtsiaZUuZNq+T2sPIquKhVFlF6WCE1Nit+LYL5byUhUnUswsWKHVH8wK
	 7qMsN9mQuJsHdDVnrFzUsqc9srPE2TyNRfy5sfQGHZd2IhIXBj2X/t95jvsRKjbxes
	 lW4C1s7A5Nc0siyJhxlMktOEclBcFv0GC8ZCkpoYvvrYb+6YZUqa5gzAF92LNEhiWG
	 fbkCpan3pHHSqNMPeNzv/+c7N/vuVGzf8tIrVMWvAFsKjZw1wSbvxtDjUqQoHSjPIh
	 af2nNUqh3M0izEpdLd5+JAe9EJ8BchGBTY8vR4TP4CD1d2d1+4+nNv6FNem2o7XMVr
	 6IuBrI0whhNvw==
Date: Wed, 16 Sep 2026 19:07:23 -0500
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
Subject: Re: [PATCH v8 06/12] PCI: liveupdate: Auto-preserve upstream bridges
 across Live Update
Message-ID: <20260917000723.GA992337@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-7-dmatlack@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 715D42000A
X-Stat-Signature: jooa4fxiwjk1h7atiron5tcfddwymb5y
X-Rspam-User: 
X-HE-Tag: 1789603646-204190
X-HE-Meta: U2FsdGVkX186gyjHF4chuJmshmJFiNmeiYp2YuSNL2pOlCISM1muTwe2r1R4c+SUqTTZdlznJ4vVk+sNvLjN4Kc3PoxXUnjuA845WDy6SoDv7w3puFhIT1aUAme4I9nHZEeLGExks3SwdBK4agQWSu/RTbBLLmEelfCbVi6SKYzR1Y40Cp7rO8SGRAjn/UwTqiPodhCTobIvN4wdoIqEFhzxiO4yHK87cRg/ZRjsyzZS7bhEQayZsDOt1mE4t0lBB3XE9HAZ9Fd5sANdwF0ORkeY2EaqnR3CiMmHw/8pbozjHTnqCuYvaltiRpfQ/muxeukQ2CBRxNwIBrmnAeT4RBshyR7p1VhwCLdgdg3925la/cA/0C7BMjMI7fVUguENfmeRV0DucTH453qw7Ym1Y1maeNowTGLOvoVxpfHnxzGhVlXlPTQBHmebZoaX2auk44FJI8HyZx6UysR9zFsk2B4tFzD88P1XuhOx8m/YELXZ8hic4QnJHrV3yz4FM7lYRPYOQxNwCn7rP6fAbvCoYtmkofkHU0EeRZgCxi57vNRRSzwYJVLVp5X8nydyoWjY1EppwuylSGusDhG86ff18wuwO0cz0WQ1j8k29RdUWou1/Fph7gdoKmzeYKYXr0V/SfDREkPkWILHtZ+IJfic65V56sBDQ3d9UTcOQvGUxl9eKYXflhSnYzqhAZ/EnekbumPvoTLi8J9HfeZM3rjaMinpTvaM3KnT0WHhC0saAkawVr25uh7Z+2m3Xmlfd4AVtAmlguovI28qJ456eX6dray220Bm7HYxi0o96tej2CBlbEdklJKhsfyLuTCQ0Y8Zp6GButMzpLczbrkWk4XCs6aHmJXenNUDdgEHOdUvpGMG/zhkTl8hRGt1C7p48DQhl+0FayIIBrThEo/JvoFrwVVKlDPDP9E41SxLmUANxfO6mm1NIQ+W5N5XEhuPBLttFRrBNAp9dz+31RPjoEP
 dT7RFNFw
 UFvzzLCJu/Rqy6q+OpKQONm/g6Vb4hu1RmQ1uVcSLx5b6Z5FkWMQEHCo+qOZe3Gr/CcxxjRLA8DY8+RgrEGU6qrZWEz9LXfkHSmLNTP4bc9ARYsVn/kFhfb2AM5IzjQFXtx8fl9vcOO9/V8ooOnQtTpaN6i5f2V3GwM33+LQ8uEvVVUxEZre8lltziXbP8YKHzvMYn4b55Vy9xkXdQHoEDa5OAz40HlQ77ibyUWOWi1U9Jc1gjLURqRSjVfycUBPCGjjH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:10:00PM +0000, David Matlack wrote:
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
> ...

> +static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
> +					    struct pci_dev *dev)
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

I guess this is a nit: I was looking for a dev_ser->refcount++ in this
patch to correspond with this decrement.  I *guess* the
"dev_ser->refcount = 1" in pci_liveupdate_preserve_device() starts
that, and the "dev->liveupdate.outgoing->refcount++" there is an
increment of the same refcount?  The connections there don't seem
quite obvious to me.

But I guess "dev_ser->refcount = 1" was added by a different patch, so
probably *not* the same?

>  	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
>  	outgoing->ser->nr_devices--;
>  	memset(dev_ser, 0, sizeof(*dev_ser));
>  	dev->liveupdate.outgoing = NULL;
> +	return 0;
> +}

> @@ -385,13 +418,23 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
>  	}
>  
>  	if (dev->liveupdate.outgoing) {
> -		pci_warn(dev, "Device is already preserved\n");
> -		return -EBUSY;
> -	}
> +		if (!dev->liveupdate.outgoing->refcount) {
> +			pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
> +			return -EINVAL;
> +		}
>  
> -	if (!pci_is_root_bus(dev->bus)) {
> -		pci_warn(dev, "Cannot preserve devices behind bridges\n");
> -		return -EINVAL;
> +		/*
> +		 * Endpoint devices should not be preserved more than once.
> +		 * Bridges are preserved once for every downstream device that
> +		 * is preserved.
> +		 */
> +		if (!dev->subordinate) {
> +			pci_warn(dev, "Device is already preserved\n");
> +			return -EBUSY;
> +		}
> +
> +		dev->liveupdate.outgoing->refcount++;
> +		return 0;
>  	}
>  
>  	dev_ser = pci_flb_alloc_dev_ser(outgoing);

