Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72125C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 19:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA066B008A; Thu, 17 Sep 2026 15:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489C06B008C; Thu, 17 Sep 2026 15:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A1B6B0092; Thu, 17 Sep 2026 15:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DB456B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:47:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 948CAC044D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:47:11 +0000 (UTC)
X-FDA: 85224287862.06.2E0C7E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 147E7140013
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:47:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ITACFmTu;
	spf=pass (imf23.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789674430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=FIVFF1Gz0qTcL6D0qsjU7Wz5A7oH5Uxjc4mt3x0Rb8M=;
	b=Eg6/OBHc2sPRDi2WTCNCoZg3qjA4k/lEE3lHTaZoStcrJCns2FnqO1c95AUl0+JBt4k1mp
	+ShdZ1eyCT5kpfKihXaCWnk02sBoGnK2NNZFzb4bYvhKJN5jmBoy0+FICwrS4AWiBrrhL9
	+AkBb1UA9f6vOVpeGECcco2uViCIr+s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ITACFmTu;
	spf=pass (imf23.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789674430;
	b=cXS0h99ra1q+9whRD+H7TFXhr0b/oa8zZ24ksS22vyFi9woWVFeZf42l4CL1ynJUELICVa
	uHyKYGF5RcHNxvsfoaU+/jAHR+g2hl05SSX4vX/Q2Yp+L8vHHWbfqXWOZYnrOit8Jcv+nQ
	PPGy6PW7mSEqgSTjpMSQgvcVqof14jE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 695B9601EF;
	Thu, 17 Sep 2026 19:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96EC1F000FF;
	Thu, 17 Sep 2026 19:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789674429;
	bh=FIVFF1Gz0qTcL6D0qsjU7Wz5A7oH5Uxjc4mt3x0Rb8M=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=ITACFmTuRMNQBN70r1LnmUlyRzCHXOzNKwQta9Q3q8IXvtIZGGZC0HnDjiuVGz78R
	 EI93ZUJBBCPLeovbDy0Ya2s+Jizc+FiJeJ9wBZfFKMjqoaH52DlK4Xoo4X2+aED1PO
	 11Tu3BmmyNrTrknb2wJyGvUs8xJD893qs2vSLN/6pGC4pfbcMZAsUQQ6hTvbLLsDxB
	 A1Un69fr/uNRVwYmEKSRf/2s2tCjcBCliZfkAx5MkL96mrCZXc6aA42BYjNJjlyYri
	 wmyHxC0nRKKJiVpWROfJSOnMgC3KzaifYv19mCGGyI3yp1TqpS9tRfTJ6cXz8tNlc5
	 QykvFjSC7e2Uw==
Date: Thu, 17 Sep 2026 14:47:07 -0500
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
Subject: Re: [PATCH v8 09/12] PCI: liveupdate: Adopt ARI Forwarding Enable on
 preserved bridges
Message-ID: <20260917194707.GA1047156@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-10-dmatlack@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 147E7140013
X-Stat-Signature: f9yur74jdzczp9cd8f9yi4reudzbtxru
X-Rspam-User: 
X-HE-Tag: 1789674429-110273
X-HE-Meta: U2FsdGVkX1++sakNuL4JqGLNDGu9ZcxJYYErz86zKlYRx1EWC8S+4hf7kUh6lpvGo2Ida7X23tjBVsi47wrTVe7UZXQ17P2/rhCfz7H/KM7Zhtcdxvw6U+3Jx7GwM59rvzpg9GO7LmYof+2+oqcSZ4RnOMGEB2V94xV7/PWic4fOUZJ8DZqMk682nIHDPAuXhCQxSnB+TXxh0GocXUhaDMdc03+BIDfkYmpAcLPKxOxzvkEzJEI52O7fvYXSA3vx6CDQUPCbs3OnGIOzfWC7hUH7Ge6nfBW7vkLOX2jlJApa7BPO2ajXVDK8IbQv2oszHJnVZnLt0nPyGfg2jT5YkLaUwXgqkvb3xb+EDo0767WLoqIVJIdBAib153eKqLhmZFKRpOcWgKuYhNYYln60hROgnfH4wQ3qQm3d7YKRMUrif8Q24D+ccxU34UdLuA6FG3u50OQVXWDhMPTpHIAq52cx62kigen/oir09IdOXM0Mjk/kjPXrgZ0Ga+9OLKgiNiiWZPq4lkHSUVRDlGI4IRqsjxXuZ2YLAZeRn7hVcOgEceg1h3CdfweWAHN2nz+PqnytCF2MKMCjwfLwT3bxAvn0IC2aksdoNR1/qlAeOpzUfzrKYinfRWq10sZ6CyQW4SUDNkC1wR/lthbeItbr2bU4vYYPSzGo+toibtde5tymi2NeTzAZmdabIMNPa9uUH3UFOFwUPF34y7+wVoV4JV0YjeW1GA2Pj05zyDiQNgxWGI8tZXyl4gqzkznd0273WuY94IyYza+OJYs5NjobdXR0LvvEjwmelDYmxruJLl2+8VXt1dJS4ForxyowR8oMJKb+awNlyxmhLcyJFKt6APQkUg7Js/SakOBsSrscOKe2xG0rENDNOev9AU4HGikh6XQxSu7lkJj2wrmIhbF/zPRaTigYzGSCWVlAaW0re8+OsUSmQ35Ly/8UDX25+lpJ1mCr0NXBdU5NLIq8KGd
 ButbuzSe
 yrVxk6YlvjRiKvHEtL0/psw9mw0RLRx54WdFuXhCfnHMgE934uvjGZVxSY1/HEqwzRZKYal2pC+SQ+mxDPKkCndrRgHLMlXIklUy4BOksYwCNgPCF/Gbf/3ygPAeiftwLO2W3RZ20BMBNwxSKOpWjlM/o+JQvE+tUEIsZG8rm8rBanntcRVse/QdLXgF+0epD7Y5lIN7kR5ApyPujOw2ajQI9gQ88n3dlYHRxR1Aoq0UzO5GeCzykfrxJowF1+iZ1uwCycYtO/Uwjg1rcEbo6IY9P5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:10:03PM +0000, David Matlack wrote:
> Adopt the ARI Forwarding Enable bit on preserved bridges and update
> pci_dev->ari_enabled accordingly during a Live Update. This ensures that
> the preserved devices on the bridge's secondary bus can be identified
> with the same expanded 8-bit function number after a Live Update.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/liveupdate.c | 30 ++++++++++++++++++++++++++++++
>  drivers/pci/liveupdate.h |  6 ++++++
>  drivers/pci/pci.c        |  8 +++++++-
>  3 files changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index fb602dd3933e..744513ee11ed 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -128,6 +128,10 @@
>   *    way after Live Update and ensures that IOMMU groups do not change. Note
>   *    that a device will use its adopted ACS controls for the lifetime of its
>   *    struct pci_dev (i.e. even after pci_liveupdate_finish()).
> + *
> + *  * The PCI core adopts ARI Forwarding Enable on all bridges with downstream
> + *    preserved devices to ensure that all preserved devices on the bridge's
> + *    secondary bus are addressable after the Live Update.
>   */
>  
>  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
> @@ -833,6 +837,32 @@ int pci_liveupdate_enable_adopted_acs_controls(struct pci_dev *dev)
>  	return 0;
>  }
>  
> +/**
> + * pci_liveupdate_adopt_ari() - Adopt ARI configuration
> + * @dev: The PCI device to adopt ARI configuration for
> + *
> + * For devices preserved across a Live Update, read the ARI state from
> + * hardware and adopt it. This ensures the device continues to use the ARI
> + * configuration established by the previous kernel.
> + *
> + * Return: 0 on success, or -EINVAL if the device was not preserved.
> + */
> +int pci_liveupdate_adopt_ari(struct pci_dev *dev)
> +{
> +	u16 val;
> +
> +	guard(rwsem_read)(&pci_liveupdate.rwsem);
> +
> +	if (!dev->liveupdate.incoming)
> +		return -EINVAL;
> +
> +	pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &val);
> +
> +	/* Safe to modify dev->ari_enabled bitfield during enumeration. */
> +	dev->ari_enabled = !!(val & PCI_EXP_DEVCTL2_ARI);
> +	return 0;
> +}
> +
>  /**
>   * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
>   * @dev: The PCI device to check
> diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
> index ac5b8bf2edf5..ccc23031e99d 100644
> --- a/drivers/pci/liveupdate.h
> +++ b/drivers/pci/liveupdate.h
> @@ -18,6 +18,7 @@ bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus,
>  void pci_liveupdate_scan_bridge_end(struct pci_dev *dev);
>  void pci_liveupdate_cache_adopted_acs_controls(struct pci_dev *dev);
>  int pci_liveupdate_enable_adopted_acs_controls(struct pci_dev *dev);
> +int pci_liveupdate_adopt_ari(struct pci_dev *dev);
>  #else
>  static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
>  {
> @@ -45,6 +46,11 @@ static inline int pci_liveupdate_enable_adopted_acs_controls(struct pci_dev *dev
>  {
>  	return -EINVAL;
>  }
> +
> +static inline int pci_liveupdate_adopt_ari(struct pci_dev *dev)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #endif /* DRIVERS_PCI_LIVEUPDATE_H */
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 22001bdf4c97..6922f361a89e 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3528,7 +3528,7 @@ void pci_configure_ari(struct pci_dev *dev)
>  	u32 cap;
>  	struct pci_dev *bridge;
>  
> -	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
> +	if (!pci_is_pcie(dev) || dev->devfn)
>  		return;
>  
>  	bridge = dev->bus->self;
> @@ -3539,6 +3539,12 @@ void pci_configure_ari(struct pci_dev *dev)
>  	if (!(cap & PCI_EXP_DEVCAP2_ARI))
>  		return;
>  
> +	if (!pci_liveupdate_adopt_ari(bridge))
> +		return;
> +
> +	if (pcie_ari_disabled)
> +		return;
> +
>  	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI)) {
>  		pcie_capability_set_word(bridge, PCI_EXP_DEVCTL2,
>  					 PCI_EXP_DEVCTL2_ARI);
> -- 
> 2.55.0.487.gaf234c4eb3-goog
> 

