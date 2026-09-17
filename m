Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 804CCC982CC
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 00:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD966B0092; Wed, 16 Sep 2026 20:23:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438556B0093; Wed, 16 Sep 2026 20:23:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FFAB6B0095; Wed, 16 Sep 2026 20:23:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3F096B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:23:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 35BD8A43B0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:23:32 +0000 (UTC)
X-FDA: 85221355464.22.8944FFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8F6C040009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:23:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uaczt0oD;
	spf=pass (imf17.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789604610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=BYq4fZIoFhLtPEIgNGcHeKoYgNlbKrrDbCQCa193GqU=;
	b=6BfeGdTMG1FAnD188ZBN1T+E3+yM/rcdtAYf8OwV4BB/duvWBmt5z7OKxj8uMQ3T5vorBF
	2KHoAP4yVL5Ndue/huOxmG4BAf/oR1Qjkl6yC02o22OpeOBOKz33gdTH0iGCoq7YSzSrqD
	8gYNPzlduohRaRwwIYINVfyA8fKfKO0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uaczt0oD;
	spf=pass (imf17.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789604610;
	b=xU0mTxzpmJL+LClakfUqUL7hU8SaQoEZJDXs1Qmmm6/oXQYPtZhpd2eF/SYucTg0lzFjgf
	TrivXcdAbwFABfWvGldJwbHcDxJ11B4opXgnvlUaFXtMmIR5AZpyJQeGTy7Nxtu94i0Fcr
	YGeGrQLNJ2D9x9hwDTJi+pReYeGBEjc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5A59601EF;
	Thu, 17 Sep 2026 00:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D801F000FF;
	Thu, 17 Sep 2026 00:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789604609;
	bh=BYq4fZIoFhLtPEIgNGcHeKoYgNlbKrrDbCQCa193GqU=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=Uaczt0oDsYk8FN3ojEgKvdY1DeqU6zoNXXMnQqPOTDXF6YL5rRKYv3Opo0gGEC4tc
	 ir6Y2Ji9QCmt4oSSQIwBhL1kkVNOlPZFg4QXH70AOPpVZTMjLzyLWxoTVyEolXKFoM
	 dvB/2CMnvKoj1QsigbEHWuBF9URuMwekTo1t2ZWpF2goI6+SrnjB+E2oxr8zfHcqnW
	 LuBDyk9pdcpOmU1ah6P4J2DqtTZz08Dke/63uQa7m8a5begeSsMWIQAhwQcg0s66lB
	 05Kvt1jFEMK08+vkOdoeScR7/E7PaagQWYerR3lQChifp0sTXGzb9eujUnyELudeB/
	 9G3xVW7/lYrOg==
Date: Wed, 16 Sep 2026 19:23:28 -0500
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
Subject: Re: [PATCH v8 08/12] PCI: liveupdate: Adopt ACS controls in incoming
 preserved devices
Message-ID: <20260917002328.GA994546@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqgkxmXlhfqsdfAa@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F6C040009
X-Stat-Signature: wxdekcxqtwatj56r6wnizz3ztp3tgu16
X-Rspam-User: 
X-HE-Tag: 1789604610-135134
X-HE-Meta: U2FsdGVkX19LE3PeyPxi7wd+xWDbjy2irOlQ4I1IWwdE6aSxrIJloFz1JxXbH5k8BDMzTy1R7J+qYk9Sr9kRSfRAxVSDEB3NIo/J0accaYSBNIOn2s7y6ta8bvRoCofX+VUOr0AyVY5vmWUZkoLbpIinISjguZlnB9hmOIsUlJhkN1V1HWJ1fLW8sTmYn4Gjv/YwN9cRxA6IDGJXxo4W1U7oXCjCbgEGID2eGSgLVGIYMJ/8HwIah/7h1xmzj7V8GaonYt2qYwWvyQUHwqLDI/dkLv8iqIvQb2QO/zdbc/OdV2YPXa6tXuamWPCWMrNE+ntBazM+5XpTnGapDe7dsmu974i8OYUDLrk7VhWIRz9d8vJG/wNIwiXaVTVrBZ4ZePG/3AigoITRQ4m9r7+udDyyyRcqymmE40LFfekwQ1+wkOqVfItOv7ZXNLqeOcJJA2WdrYJlyUvHTAaUTD9gRRUpzdZQpmima2yZNPMutGEdacTMH3VhDTcsp/DC2JYZ9kACNKuwuN1yYspjzaagnDDWWma9vx7w85IIFMwtGiZyJyv+7bjwajWPOSuq8DV6QYILpF2I9zJGwBJ2Mx83+2lkluGuIBC3cl/zVxugDnqVO1w4V3so1AGFnOPs1AvuE4Dn+cPnO/vBmj2iAD8IPH23SHextvXL+jvk4z6U4ydhlJ3yq5wegcf+cultH1fpzZael+/qlbjesID6KcF+Rj8mmxKqUu9RPqp45eS2PlkES1eiUyB2AWHjOXGAMplrVd1pxt+GaxATwsMGz0L1uoOmxfZ8py7r1/yL+vhYyfHbZZRj64bdl4Qdj59nBwkuZQsRUpIF8l55YXKVUusrj51nX0e4qC+qoWCNx9ZmgcaR2vD93Ing1zwRYTO29qlJeBovbV6f+dYIQXdmkDkQzKhA/K7MKKqL9H1sT4+6eoOzpbZQGh53TdypIGxSPQ5zCGvTuFw+phJOEG3pPrj
 YjZjF/Rd
 y57RrcwYkjqgu7msgSR3dpgwnOX/eIjpU8NKpEuZtKC7ZV5O9xln8QV1wTY7MowWjLQ13kziYWYvcJYHS04GdaFYThG+Kc54ufEinZImiOkl3wV9lJRN2GM/BZQRUowDSJFirUfZr6g3xAcuwCnwGkB1dp/HdCXFSNuosxGFKJpj2Y7WjnajOdtA+7UB/sDvzbI6JhQlC9Z2TtWbN8KPGs6Cjx+V8w4RhI/fETMqMPk3R6JxcyApDYU7MQLXo48DKabWjIOgpV3Ws/jL8pBv9bc8byw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 04:45:58PM +0000, David Matlack wrote:
> On 2026-09-11 06:31 PM, David Matlack wrote:
> > On 2026-09-10 06:51 PM, Bjorn Helgaas wrote:
> > 
> > > > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > > > index 77b17b13ee61..22001bdf4c97 100644
> > > > --- a/drivers/pci/pci.c
> > > > +++ b/drivers/pci/pci.c
> > > > @@ -34,6 +34,8 @@
> > > >  #include <linux/aer.h>
> > > >  #include <linux/bitfield.h>
> > > >  #include <linux/suspend.h>
> > > > +
> > > > +#include "liveupdate.h"
> > > >  #include "pci.h"
> > > >  
> > > >  DEFINE_MUTEX(pci_slot_mutex);
> > > > @@ -1008,6 +1010,9 @@ void pci_enable_acs(struct pci_dev *dev)
> > > >  	bool enable_acs = false;
> > > >  	int pos;
> > > >  
> > > > +	if (!pci_liveupdate_enable_adopted_acs_controls(dev))
> > > > +		return;
> > > 
> > > Ugh.  The asymmetry between pci_save_state(), which does nothing
> > > ACS-related, and pci_restore_state(), which enables it, is sort of
> > > sketchy to begin with.
> > > 
> > > The command-line parsing in this path feels like kind of a wart (not
> > > that you're touching it).
> > > 
> > > It just seems like this path is already hard to analyze, and
> > > liveupdate is making it harder.
> > > 
> > > If we could save/restore the ACS state around the reset, wouldn't that
> > > solve this without any liveupdate specials here?
> > 
> > Yeah that would simplify the liveupdate support greatly. Let me work on
> > that for v9.
> 
> Here's the patch I have prepped for v9 to save/restore ACS controls
> around reset:
> 
> From 0c69424454de0c569aca67bc69f496db915a9bcf Mon Sep 17 00:00:00 2001
> From: David Matlack <dmatlack@google.com>
> Date: Fri, 11 Sep 2026 20:05:04 +0000
> Subject: [PATCH] PCI: Save and restore the ACS Control register
> 
> Save the ACS Control register in pci_save_state() and write it back
> in pci_restore_state(), instead of recomputing the ACS controls from
> scratch with pci_enable_acs().
> 
> This makes ACS symmetric with the rest of a device's saved state. Today
> pci_save_state() ignores ACS entirely and pci_restore_state() re-enables
> the ACS controls from the kernel's current ACS policy. As a result, a
> device can come out of a reset with different ACS controls than it went
> in with, e.g. any controls programmed outside of pci_enable_acs() are
> silently dropped.
> 
> pci_enable_acs() runs when a driver binds to a device
> (pci_dma_configure()), i.e. after pci_bus_add_device() has already saved
> the device's state. Refresh the saved ACS Control register there as
> well, otherwise a subsequent reset would revert ACS back to the
> configuration left behind by firmware.
> 
> Devices that rely on device-specific quirks to enable an ACS equivalent
> keep that configuration outside of the ACS Control register, so keep
> configuring ACS from scratch for them. Do the same for devices that have
> no saved ACS state at all.
> 
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: David Matlack <dmatlack@google.com>

I like this a lot, thanks!  It would be good to get Alex W's ack, too.

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/pci.c    | 66 +++++++++++++++++++++++++++++++++++++++++++-
>  drivers/pci/pci.h    |  5 ++++
>  drivers/pci/quirks.c |  7 +++++
>  3 files changed, 77 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index b2879a6be5f8..dd25c01736b4 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1021,6 +1021,55 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
>  		caps->ctrl |= (dev->acs_capabilities & PCI_ACS_TB);
>  }
>  
> +/**
> + * pci_save_acs_state - save the ACS Control register
> + * @dev: the PCI device
> + *
> + * Record the ACS controls currently programmed in hardware so that
> + * pci_restore_acs_state() can reapply them after a reset.
> + */
> +static void pci_save_acs_state(struct pci_dev *dev)
> +{
> +	struct pci_cap_saved_state *save_state;
> +
> +	if (!dev->acs_cap)
> +		return;
> +
> +	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
> +	if (!save_state)
> +		return;
> +
> +	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL,
> +			     (u16 *)&save_state->cap.data[0]);
> +}
> +
> +/**
> + * pci_restore_acs_state - restore the ACS Control register
> + * @dev: the PCI device
> + */
> +static void pci_restore_acs_state(struct pci_dev *dev)
> +{
> +	struct pci_cap_saved_state *save_state = NULL;
> +
> +	if (dev->acs_cap && !pci_need_dev_specific_enable_acs(dev))
> +		save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
> +
> +	/*
> +	 * Devices that rely on device-specific quirks to enable an ACS
> +	 * equivalent keep that configuration outside of the ACS Control
> +	 * register, so there is nothing useful to restore for them. Configure
> +	 * ACS from scratch instead, which also covers devices that have no
> +	 * saved ACS state at all.
> +	 */
> +	if (!save_state) {
> +		pci_enable_acs(dev);
> +		return;
> +	}
> +
> +	pci_write_config_word(dev, dev->acs_cap + PCI_ACS_CTRL,
> +			      *(u16 *)&save_state->cap.data[0]);
> +}
> +
>  /**
>   * pci_enable_acs - enable ACS if hardware support it
>   * @dev: the PCI device
> @@ -1057,6 +1106,15 @@ void pci_enable_acs(struct pci_dev *dev)
>  	__pci_config_acs(dev, &caps, config_acs_param, 0, 0);
>  
>  	pci_write_config_word(dev, pos + PCI_ACS_CTRL, caps.ctrl);
> +
> +	/*
> +	 * pci_enable_acs() runs when a driver binds to the device, i.e. after
> +	 * pci_bus_add_device() has already saved the device's state. Refresh
> +	 * the saved ACS Control register so that a subsequent reset restores
> +	 * the controls programmed here rather than the ones left behind by
> +	 * firmware.
> +	 */
> +	pci_save_acs_state(dev);
>  }
>  
>  /**
> @@ -1800,6 +1858,7 @@ int pci_save_state(struct pci_dev *dev)
>  	pci_save_aer_state(dev);
>  	pci_save_ptm_state(dev);
>  	pci_save_tph_state(dev);
> +	pci_save_acs_state(dev);
>  	return pci_save_vc_state(dev);
>  }
>  EXPORT_SYMBOL(pci_save_state);
> @@ -1877,7 +1936,7 @@ void pci_restore_state(struct pci_dev *dev)
>  	pci_restore_msi_state(dev);
>  
>  	/* Restore ACS and IOV configuration state */
> -	pci_enable_acs(dev);
> +	pci_restore_acs_state(dev);
>  	pci_restore_iov_state(dev);
>  
>  	dev->state_saved = false;
> @@ -3532,6 +3591,11 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev)
>  	if (error)
>  		pci_err(dev, "unable to allocate suspend buffer for LTR\n");
>  
> +	error = pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_ACS,
> +					    sizeof(u16));
> +	if (error)
> +		pci_err(dev, "unable to allocate suspend buffer for ACS\n");
> +
>  	pci_allocate_vc_save_buffers(dev);
>  }
>  
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index ba3c3fddddc2..037c1674f164 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -1095,6 +1095,7 @@ void pci_acs_init(struct pci_dev *dev);
>  void pci_enable_acs(struct pci_dev *dev);
>  #ifdef CONFIG_PCI_QUIRKS
>  int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
> +bool pci_need_dev_specific_enable_acs(struct pci_dev *dev);
>  int pci_dev_specific_enable_acs(struct pci_dev *dev);
>  int pci_dev_specific_disable_acs_redir(struct pci_dev *dev);
>  void pci_disable_broken_acs_cap(struct pci_dev *pdev);
> @@ -1105,6 +1106,10 @@ static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
>  {
>  	return -ENOTTY;
>  }
> +static inline bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
> +{
> +	return false;
> +}
>  static inline int pci_dev_specific_enable_acs(struct pci_dev *dev)
>  {
>  	return -ENOTTY;
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 7aee30734303..e500c202d2ec 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -5476,6 +5476,13 @@ static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
>  	return NULL;
>  }
>  
> +bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
> +{
> +	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
> +
> +	return p && p->enable_acs;
> +}
> +
>  int pci_dev_specific_enable_acs(struct pci_dev *dev)
>  {
>  	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);

