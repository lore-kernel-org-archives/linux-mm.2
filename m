Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A3FFC982DE
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 01:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916D86B00DC; Fri, 18 Sep 2026 21:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C78D6B00DE; Fri, 18 Sep 2026 21:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78EB66B00E1; Fri, 18 Sep 2026 21:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 053066B00DC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:18:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70AB1C0180
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:18:58 +0000 (UTC)
X-FDA: 85228752756.27.9EBCCAD
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4686E140006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:18:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=GfU3B8bz;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="I ThjHth";
	spf=pass (imf23.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.155 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789780736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f07OJapwP7n4iN5o+VTBr7NTU5yudYQ1EeJavoRTsAU=;
	b=BnEy1eODA7TtgI009a4t1LpicwRcqHYtQkoHRV5I5nu1DbxBz4uyDRuMYBePZ5FVHQvCLw
	AIl1r+517EMVONUSNYghl+uj/My1ez5fuPByFHcWaJM/tjFyNEz5RC7BEhbDR2fKG0x9VS
	HSipVEBZBM/NxQlAGjRnGCbQ5BfS9Ik=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789780736;
	b=hh8MuZ/pu/9axcw/Nb++0YfXlvZmeGDbh1+IzH+WzxmuAOFjGAOK+P/+gWSnO+vbdZL5ka
	zfcsqWVTUcdYNhapxzhXK/GyPmu2VSbNfByr8+b6xa262k5+fxXhlyESHfENbTmFsLWzhi
	AXnbmv3UcEjnT3kw+Wvqe6Mi7jecO/0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=GfU3B8bz;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="I ThjHth";
	spf=pass (imf23.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.155 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A06117A00F7;
	Fri, 18 Sep 2026 21:18:54 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 18 Sep 2026 21:18:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789780734;
	 x=1789867134; bh=f07OJapwP7n4iN5o+VTBr7NTU5yudYQ1EeJavoRTsAU=; b=
	GfU3B8bzgvN3baH4hN7kVi3lK+nwsYLBoo8cuedw+XfuLRi7C2LDOr2zGEqpyItk
	eQoRHmiP7gdOYs4G+8gpNILRD1NXFmda7hFAMawTqLZlswHVgxBzxcrjACt0t1mW
	tgO9e4sqsVcqDI7Uw0UTvZ4BtfzKqUbSP7IPivwb7zwTOCGwHGaX3v7NqsU2WNMo
	omFYls3/du51cPE6bB8koXlKIW2lNpV7owGIhw1oTppNYkBPxiEtBttdBwAWRz7m
	7efK2Z7EnC+/QZYvSIBHjfWU/Fau93vviQy345fFfOQMwK3BZuTz+Ov0bDw3uj6c
	DluMmuq+++tmqRxCLPnIow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789780734; x=
	1789867134; bh=f07OJapwP7n4iN5o+VTBr7NTU5yudYQ1EeJavoRTsAU=; b=I
	ThjHthLB53HlQOXiE/B8C3BzG82k34YmTXWtypVrrj1sjAl98hJPFZ/PA3L3KWGO
	zMZCQjnbil2KmYaPnS/La+VdZhooz7N38ZnWV/G8dAla26+qRY3PLTlOjvlFBBJ1
	+mx2dQybAiByY9eqhXx2HduZXZsj0yzqh71wvT0igfSONIw0bX5t6aBcbIaDHpIe
	LU0HR6/dtgJhImLLqevRoUrkgh2jX6IqChVBAZ228wP8225XjZvUHi0L0XgCug8V
	a+S8pOhSrolB8dq+eSA1w75N5gjmio1xONFAojmsmVDmsDxusNdJBl4tLAEnpq+4
	7BZb90CwahB0U5AxiriZg==
X-ME-Sender: <xms:_OKtaga1fTfEWHifyiBStU5q9_fICtTmkw9yO3PHO-DRBGkRgLhT1g>
    <xme:_OKtaiV5RKACYIrHoXPOlyWPJUa6XFxgsdCF0p3mhbTljbESOF56b7UeHhIVzQn1u
    ZPhhlvBI3Ibc6uA_co5L3_YYocxTmjAxU7xMvg3B_GxkG9_iZFlcwu_>
X-ME-Received: <xmr:_OKtahZ-2xFlTFGAN0BdpiQP7dQ9Y6RzUBtbF9QY5lq-YUZGP37_jBq9GjsAOQ>
X-ME-Proxy-Cause: dmFkZTFsi21agycuHwmyYJyjldjG/6AIpBHOLfkjZs+7QWdmfXu3roB/D7PU/BJ5GavaBQ
    AU4Zx86E3Ar9fkk1i41sLL79DnqebEpC8pDQ6c5ESWbp577Kk3af/AT9f5eoXlX0Lw/Mwn
    FcwH1rl6rXf0ysQZescsD7HR4aD9cokOy6JHc/odoFo5LW74f6xcHPp7/3IXor/7lPRlg4
    yVxI+ykZmTAbWVw9hIWIcQv2dY+r8MD8Wy3QjrkvIeBpxUqwnvjaOFAxf3/hHEtPNnLxjs
    ds98IeB4eQbJsmnMJLcg38qvtl3mGH/yUl4cVyev259XESUEPVRdDW+b9fBfBPjDcrgVI+
    BVIlyr12V9nYqdU5Zo1weZP/CyuOjwUSS3xmHA+sFvyIYwVdXKsVOOrcJLgBflm22kdNyO
    OefOMArnTas4zRxUhJgbvX1OAkCf+nqcf4j6frGTX205opZyUxnl5xlsaBa3ibVeWM9erA
    ePj0w2q/rKlqCJNRlmxVdXJwfsxkckiDWN/E3g0t1fXf8kv9cv+RYjAWIatFvyc6rL8rxQ
    u3X3RlPxpeu3mB7lNH5rrGoxRaqoxgs4aW/La6pfZxaymhcUewyZeQ84Z/YefVcxKQhX9/
    ib/pnrw0CtPk1XE16IBpOJ7VT/SFvHGcnz/4zucdY+TDS4kvL8ePHyTyeVYg
X-ME-Proxy: <xmx:_OKtapJ8d19Nb_dUW0u98RLaH22nwgDrxhCtssfSsItOxCPsRIc54g>
    <xmx:_OKtas1lKKCmEv1xr5qabBOKGe-sUnb_2jS4i6JqtfX4Do4V0lSltw>
    <xmx:_OKtangcRGH9oLTXiMpZwZ86j52cO0RMagUMHuuvD_HQGYuySJBpsg>
    <xmx:_OKtarwxBsVW90ouA5BhWWosP9nDeIcGzw6Fx3cFQ4qfWaWzUry8wA>
    <xmx:_uKtasPXkArDpKb2s-2cwtmutgEGZHjf9sxZHxleXUugjeM4BZ0cS2UU>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 21:18:48 -0400 (EDT)
Date: Fri, 18 Sep 2026 19:18:46 -0600
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>,
 Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>,
 Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
 Yi Liu <yi.l.liu@intel.com>, alex@shazbot.org
Subject: Re: [PATCH v9 08/13] PCI: Save and restore the ACS Control register
Message-ID: <20260918191846.2f68b23b@shazbot.org>
In-Reply-To: <20260918200640.887030-9-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
	<20260918200640.887030-9-dmatlack@google.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3ytepdqf9oqohetjhh3as4yp9ydy5dm5
X-Rspamd-Queue-Id: 4686E140006
X-HE-Tag: 1789780736-812489
X-HE-Meta: U2FsdGVkX18C97fAS39L8SqlNDFo/2i5gLA2G4pk4rv9xa4nsgkCPB4ydJojUeE9+VH99SqYxgI6NpwFo7ousWmeM+nB7pTP4Hm9UHpZrIUB7JE6LI0gk0N31UaEVQWrBOogJQHua4nbLzsIxS0le3AcjBRZgtNkztMKAJERmqp2iO9DrY/IhEgDa/QrdJsKpN+dsuSvTa2WIkJ8eYmBA71cg0TQ1UnwZnHjZqOauVerjeDt40dN/ONGGv/zr/kdA+TY4yXf5XS8kRaP5NXvkMqUpHV60ZV/Xxzbaxp/2MtRt8BkKS9RGuzhqhSuEAtYZsENQFoQjnMSK1glxKP/VqSwS0lAX6NUqGxkZcMqZ8Uzwx3+yXfJjzJ8rN0t1y5/1KP9zDAyaipXE11e0u8vFacdkpI+vlnohLkLFF9pwMAwUtZGGXIYOMRqNvbsChwUjp4hy/cPllTkh1I9i9fuXB4f579TuVDU4P4/Xgu3Pl8iyA67Pp6OwNCDi048t8SvJrw28ojN/J95E2haZvHkVAk9maFoKLkxgBAB+WvEPl6StAZ8sMSDCeqJiiWRVBFknYpN41T0VnJNGPHEl7GP4geIKBmmei6vU8mVEuO117cu3bcmM6qMbIvyeSLrr6u3EI/21U4J7LRhp2CFOhf7R+6U4c+3xe/JqFUWVFVXlhh2ghWtpC2RAfJEFqkbGzGek3f4xrRQzydpRP/65gQE8MuX522snBrXv2WycvnQoxlDScEQGVaKIp9u+sYv+LEs5zG7rwiihnOuonX0nV9vTVcNZ+y9nGtZAiKwIVyFdVgDdVOGcIvtvD7FIssBqt2RGcguFKJk04hVPdMtyR5Sal3lEqX58rthXSP7/3JkYUyKq3SvdI+Q38Js0NUGNsK1XBl6OXCOYgVH1cogqcJBbRE1gviiEkCnthLBAGA7XJqT/zlBnAwAIEJ2A/nXMo0cNoWgCvjt/uKzXj5gZCH
 srg89FRY
 /1YtaZiBsHhy0ki1PHFsny7MEK0wYQKchUniube4VuKGTZTqRLC8oMutlGpNS99pc4DK1hR4xMj3Fc4lG8jalR09YeFLwpDNKlWV/JSwXR4e9xo1non5D67rtJFzGcH5wnV/N+seUC0/31fKmaHIPpzhpBGS6YhhfmBpLiYZQkq2rzHoaSiWWbW6Vbu9k7F+ZCnqbOJjw+oHeEMC0XyUqevIrvrUJf/HTMopanyIGtWECBSbX6mht4NOSCTPPSgoRDLmIZ7ByPjcMlNsF1e0z+u2PT2tq7UHJlBkt93PdjDAT6SUTd9AFLkEfmsZBPylcE7pexpT51JKqPwTm7zl43qY6pmsg+EWp/SOf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 20:06:34 +0000
David Matlack <dmatlack@google.com> wrote:

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

Controls, yes, but if we're restoring controls that might have EC set
now, should the Egress Control Vector also be part of the save state?

Currently EC always gets cleared on reset and won't be restored by
pci_enable_acs(), so we can lose both EC and the EC vector.  With this,
I think we restore EC but still lose the EC vector.  Thanks,

Alex

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
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: David Matlack <dmatlack@google.com>
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


