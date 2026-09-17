Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 710FCC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 00:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347A56B0088; Wed, 16 Sep 2026 20:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6FD6B008C; Wed, 16 Sep 2026 20:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC836B0092; Wed, 16 Sep 2026 20:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF4656B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:18:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8676120168
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:18:51 +0000 (UTC)
X-FDA: 85221343662.09.F65F1DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0438C14000B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:18:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hTCcc2Op;
	spf=pass (imf23.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789604330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=/I018ClHfzUNPJt0+qMbQoq+P+RBASppZEIurBOx0D0=;
	b=FfmnVdH3KUPVhmES2uMQ5hSYKSBL7+z/1t78jYbIjY9VZSlHZQ/RJbXlvqJrQmgL5KlVl5
	s/h0D1t8P2WzMJmHGEkVJQF8vyhZhBXypN7icFw9ORxVykONEirZ3fmbzlCNXcFoqURGoQ
	ysgZejtJMBxbPe/2nYajOsNgBdnw80k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789604330;
	b=7Q2im5go0FMli/omTLM3F/mCFsDykMgdB2uFQazmrmkhGco46Q/E0WsGdPEvDKlwCVWVF/
	eH3yvixjhohgind66SyGtNJCX0E1FVsRidVZsMk0AiegSyX1Eh0/KXQMIoFIaQhlvldpWd
	DfM6DqSwNK5C0ulYgKO1mZHNa2fZhb0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hTCcc2Op;
	spf=pass (imf23.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A40440F10;
	Thu, 17 Sep 2026 00:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E5E1F000FF;
	Thu, 17 Sep 2026 00:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789604329;
	bh=/I018ClHfzUNPJt0+qMbQoq+P+RBASppZEIurBOx0D0=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=hTCcc2OpdJ9QTJ/43CxwpgjFBxFkI1cBuFOCVvg+DW5lqQhReL4g6HpYm8MA+Yd+s
	 cEtp/gYcnSUCGp5wIg8UPM53pGwTfoPcpJRGcQQhWUlDWh2mDLElt8OzdzQzRaToHm
	 1WyHFD0e2UTg0HfnN6aX3wx5uL8+aUjuxmypfEz9bjjjRFX4J0v7Hv2ZS0P9OD7CJz
	 i4SQqmEylvwEMl9RubLczb7y5qvyXOJLBmta4HxuXXhlP8A0tpNQL00gzGAIw52HOv
	 UcyiTOvMxjRzAkCubtbbwYMqr6Ras8/HJf6uPvXYP5hDxatNQMRSFkQQG3nbiv4bgz
	 AtstkzNaGBXEA==
Date: Wed, 16 Sep 2026 19:18:47 -0500
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
Message-ID: <20260917001847.GA993118@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqQzmvgILmU8F4TR@google.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9ojwzr48efkhjrwnson5p44ykhp93s6q
X-Rspamd-Queue-Id: 0438C14000B
X-HE-Tag: 1789604329-526187
X-HE-Meta: U2FsdGVkX1/55dTAi3/JqB6LWrNjU743SDWUX0rjSFnmf7/+Mr0JoQVb5Og+WUyt9AWA3sJwqZuzNAS3R3VBw5IbLxStL5wFrx+OHCswiQo9mmkUGlpLMGam3YNTdbUE9gJgppZ1H04v9aAVqv0a81NJdcSmx8f0bH5CLA6OdVNX3CBekOlcWzkwsll1jdnGNn2YM7FXznuzkcuoUP8LKytFoV6EoGW0dRSdzYI6At129VZw8pI9GdISysU5+iCO7cC14XTWb4i+tQ2UE97jHybMhY9FrM9z2Nv2P/rbFW8u2TNzX5KMZiBzUsr5h0dKyfGd5GEBrgGOyawX3h2yztHCp1uwTa/MCWmzumbVbO6/riutBdej7+e2BWoANV0ScDtGCGlsdS4oTyK9UnEdr5rv52F4Cn+CeBxAvu3Pi33avKEb0vG4Qx4I7LBkx0ZGskrc/2B+NzJnDrtmHbqQpghH/4oEwXU8ySVqdmJlBQeRxw3cq1AZv6YHQ44Xi5ZcPiBQT1Y3mF1IkD34jYoI1+Dnh/lHxl+c4pKzBpj2gUrBXR8MeUULilarw821vWl71khE6U2aofjEGfLwLIWRd5aMY9A/8z/jKI7Z6AkLq3cGCWJEqGvT9zxlk0gSJNUkf6SADYppglpOyiOW2cGXfTMgam0gkf/51i4Va6U9mf2vBaTTAt3oUA78GSv8kwH46NnIslgBHYFHlaCyxT+sdOTX0q1ciSGjAlN9dZOy48TSA7GTCjicjkedlTmNwnLfVQmQYjPinHizAMhq0LNOCNDbV78xatCVY9pB5wOVj2AKZDV5GqGQTHN+Vs6Eofjyncwt90LiXWjJsWSW93+RvhjT6XN7RYgLfCicJE9+7D9G0qZe0NfhnA4Re5yruyLgYsWl44enyTzwcAbZQnE0mwz62q1+oifFceBVHfyDBNDDg77sz1yIAo9cUjHc7Qmg35sZ2GnC5ufhIN8COkS
 F9/KE6Xp
 62bQEm4Up7N1DAZfJz9x8d+likrQ7lXI8+3BSPYw96iyHEKjtxMj5Z3B5MJPAGpBlBkYRhAh9iWqLfaorNsWjDkUr14/UL7zTmZc8S8VnXkdCAXYueG2JZaNFfFDKb20gbnVTOdw6ES3e14vEHUpgZCFK6d0msBJ4dh07uBlcrKAHQwbPl6E7Yz6nWWamWo+9SdDnlecaCCZBL2oh5zbSS5vDsodBu8VcLmQHjgZ1n7Sja5Nj+d1BjsVk45xzr+8m7Zsbrro0KKYqWL5fLqHR8RqL7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 05:00:10PM +0000, David Matlack wrote:
> On 2026-09-10 06:51 PM, Bjorn Helgaas wrote:
> > On Tue, Jul 28, 2026 at 10:10:00PM +0000, David Matlack wrote:
> > > When a PCI device is preserved across a Live Update, all of its upstream
> > > bridges up to the root port must also be preserved. This enables the PCI
> > > core and any drivers bound to the bridges to manage bridges correctly
> > > across a Live Update.
> > > 
> > > Notably, this will be used in subsequent commits to ensure that
> > > preserved devices can continue performing memory transactions without a
> > > disruption or change in routing.
> > > 
> > > To preserve bridges, the PCI core tracks the number of downstream
> > > devices preserved under each bridge using a reference count in struct
> > > pci_dev_ser. This allows a bridge to remain preserved until all its
> > > downstream preserved devices are unpreserved or finish their
> > > participation in the Live Update.
> > 
> > This seems to hint that we're going to allow bridge reconfiguration in
> > some cases, e.g., for hot-adds.  The simplest case is "leave config of
> > all bridges the same", and I thought that was what the previous patch
> > commit log said.
> > 
> > What's the benefit added by this patch?
> 
> It is used in the following patches:
> 
>  PCI: liveupdate: Adopt ACS controls in incoming preserved devices
>  PCI: liveupdate: Adopt ARI Forwarding Enable on preserved bridges
>  PCI: liveupdate: Do not disable bus mastering on preserved devices during kexec
> 
> to preserve certain configuration on bridges that have downstream
> endpoints that are being preserved. To support P2PDMA we will also have
> to preserve bridge memory windows (future series).
> 
> If we are ok with applying those policies to all bridges on the system
> whenever one or more endpoints anywhere on the system are being
> preserved, then I agree we don't need this patch. But I thought it would
> be cleaner to track things per-device.

Yes, I agree tracking it per-device is good.  I was looking for a
traversal upstream to increment refcounts on bridges, and I guess that
happens via for_each_pci_dev_in_path() in pci_liveupdate_preserve().

The actual refcount still confuses me a bit (see
https://lore.kernel.org/all/20260917000723.GA992337@bhelgaas).  Maybe
it would help if pci_liveupdate_preserve_device() alloc the dev_ser
*first* (right after all the bail-out checks)?  I wonder if the
refcount increment could then happen in exactly one place, separated
from the one-time dev_ser housekeeping?  E.g., something like:

  if (!dev->liveupdate.outgoing) {
    dev_ser = pci_flb_alloc_dev_ser(outgoing);
    ...
    dev->liveupdate.outgoing = dev_ser;
  }

  dev->liveupdate.outgoing->refcount++;

