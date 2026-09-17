Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFEE0C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 20:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1D96B0092; Thu, 17 Sep 2026 16:19:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3196B0093; Thu, 17 Sep 2026 16:19:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA646B0095; Thu, 17 Sep 2026 16:19:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AD9D6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:19:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D75DF804E0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:19:56 +0000 (UTC)
X-FDA: 85224370392.23.52FD133
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BF499140008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:19:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fPn5Yy6F;
	spf=pass (imf23.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789676395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=FVPFyILB0p9mKi052GhepayT1vMbxqjB1Nhk/upvblM=;
	b=x1Q0pek4fYSDGyQYBvUKSKpwjpnkZKbnLMCa5LGbARFOSXaHao+lCA6ZezoTHCivCd+1BI
	VsPuBtg+7y7oByFUR8HxTRFMoF6vkLDrMh0OjjqFufaysgaXu4up1wCEVfZYv0i27czPUP
	RyR8v2K1f3JWrpLeEU5gVvqZF0YycNY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789676395;
	b=WM+/qbzcd5nIvmXO0xCzx352TtT0h76+YjT6DYDGWvVIl+7u6mxl+ZTGrdghxj55ddO4uG
	bRrdS/dUhs84hIbv2IsY2xPj7f2SY5LMPS2hztrVNN9L+NKbyHcuL7XLGSLOaVv1ILsMk7
	GYH0uqx/r/AoRF5K/fdrkabLzoyob6I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fPn5Yy6F;
	spf=pass (imf23.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DA3442A50;
	Thu, 17 Sep 2026 20:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177331F000FF;
	Thu, 17 Sep 2026 20:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789676393;
	bh=FVPFyILB0p9mKi052GhepayT1vMbxqjB1Nhk/upvblM=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=fPn5Yy6FfiqKTmfjU5oYceM12GCmiYpT11w/2EyEPdKZGB9CPcBNkVv2+BwFLzu6X
	 xSgkGQj5+WhLzGvcmRurhfvuOQGHvSLSKl4teDAJZ6QR/QG7VnV959jPcTz+HVEaZK
	 CuD8XS5L28gUkvAbrICdalmnnCwxmYFcPuyhzJDJRcJ2dL8dpzKDBT7Z38/9T65arE
	 LY8nGXBX//YUlL/TndeGkCuR1dbAH8rbGwzFuTEWxVYd14ZqNgn+y/iXdiTaJOcVDu
	 NcVTytHagvF9lKoqQdw5+GoOIioEKAtSHIhUTx/SJFFATlpqz1u3d3zNwsKQDDY+v+
	 SECBXMxIYkoGg==
Date: Thu, 17 Sep 2026 15:19:52 -0500
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
Subject: Re: [PATCH v8 11/12] PCI: liveupdate: Do not disable bus mastering
 on preserved devices during kexec
Message-ID: <20260917201952.GA1049400@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-12-dmatlack@google.com>
X-Stat-Signature: xz1n54hknoyik8s519k3dyz8fgmw3drg
X-Rspam-User: 
X-Rspamd-Queue-Id: BF499140008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789676394-284102
X-HE-Meta: U2FsdGVkX18sD8RdCcM04TesXmG4RPwJ106fc/IRa6nIbTwoZJPirQ6xzoWQ+gimz8tGzXuXFDDz448lua/AtUuRDVVxPD8ltv6ME7IQs3aykaxY/gmtglkabL/KP7euZ0ttHwmWZPJMmBL0Veo9Ek3jh5BJsIsPRRKnk7XiJy3gzAIl9Pu7jsPb0fJCk/iyhHtyvQJXz6SSa/gSE1tC9Tn5mf8J/j1QXHvXErGzMOkfcvVYb0Ck/2yTc3po6p7j+aaTu8jy8rhA6aiKmabYQp93Ud4h1j3we2mFtx5Mpdqj3k12hvTzjJc+V8I0ssPz5vcPL7Xr/es8/F6jRFefDEFS+y3uUxlOlEl7fupGNiWnKklrfDbGJkoU3DNSYHKzMzdYkFhsHTStJK+nHr1N2ODVsuKiU+DsjMfj55Daglu+yecOzczW9Mg5+bA0xX1EHNLTdw4xAL9ZSi9v5bBvkdLmZShfCUtKsYdu0L4+aeylctHS+Ay9PeTIbCgUXleI+jLoDxVJH9uUnOsiFaQH/CgjimteA/hDN8Qjei11Tn/tJmkWoYJf3YcM1TbCAJtYFxgTCVnUg0UhRCybif5AXLDNA56rS9jRgQeq2jpCnUHwh+MW/45I62PkvtlubrI3XaaZphUabeJzG6p/wMtTrQGlb+OUv/bAd6cDJsmImPoO5Zi4wHLOpy4Sr7Ok7KBJn9aoXdhOOxZ9XpPQO3rTrpirp+DjBeynjHNvtRfiC8b2sl5c62jeu8SikWdXhLoos1gfboDXnVgriEnVBHSVfWgZqmEdwWCpU+zRF0u3eudtIE1vcY5UO7s3scHHGFF/bOrKk8Pc4na5yRuPhtLT48rimKqsn3QIZmWgn/z5EXZ/WGfe3pW4WeQ6KJfV5mz8xMCop3dNLuP/VVst+PiYeF9zX8HLTvsMaKKOeg7jsEbKvt2rXH//udOcpBZHdsyghB4ZjBT72/A2STrEKL6
 DBVjYQCL
 rVF7ORQ9mV344Yx+2/EKMnBcdEqzGJjWGBAUkECd2KRzqA6xYwxKlsq/CjJWChIEh7iLxm690SUmSmOXRx94CoqZ7iMjuxvRcQtwsd5TaF+rJEhf4pYGVLIDdTLXHucVjYI5uc5rZ3nnp3w+3yEIWGU3EfdEDZOQYB9ZxV0dadK5Dc6sea1pbbQzjOWG0I0md8PJ1bE/LUZmlPA5UoIs3Arp48hTiQJjV0Yi/O4Vkr63TYuO+qZmYObjIN6adiy7wTTQQJoAibjsjozR473V9blGAIGlMci0b722Hdv570o/dg8VS7vOKGEa+cWnsyli2HGNWcXDG28RqJmh7rnxP15lBUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:10:05PM +0000, David Matlack wrote:
> Do not disable bus mastering on outgoing preserved devices during
> pci_device_shutdown() for kexec.
> 
> Preserved devices must be allowed to perform memory transactions during
> a Live Update to ensure continuous operation.  Clearing the bus
> mastering bit would prevent these devices from issuing any memory
> requests while the new kernel boots.
> 
> Because bridges upstream of preserved endpoint devices are also
> automatically preserved, this change also avoids clearing bus mastering
> on them. This is critical because clearing bus mastering on an upstream
> bridge prevents the bridge from forwarding memory requests upstream (i.e.
> it would prevent the endpoint device from accessing system RAM and doing
> peer-to-peer transactions with devices not downstream of the bridge).
> 
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/liveupdate.c | 11 +++++++++++
>  drivers/pci/liveupdate.h |  6 ++++++
>  drivers/pci/pci-driver.c |  7 +++++--
>  3 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 65bcecb1b64e..32b73ebf71f7 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -132,6 +132,10 @@
>   *  * The PCI core adopts ARI Forwarding Enable on all bridges with downstream
>   *    preserved devices to ensure that all preserved devices on the bridge's
>   *    secondary bus are addressable after the Live Update.
> + *
> + *  * The PCI core does not disable bus mastering on outgoing preserved devices
> + *    during kexec. This allows preserved devices to issue memory transactions
> + *    throughout the Live Update.
>   */
>  
>  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
> @@ -879,6 +883,13 @@ int pci_liveupdate_adopt_ari(struct pci_dev *dev)
>  	return 0;
>  }
>  
> +bool pci_liveupdate_is_outgoing(struct pci_dev *dev)
> +{
> +	guard(rwsem_read)(&pci_liveupdate.rwsem);
> +	pci_WARN_ONCE(dev, !dev->liveupdate.frozen, "Preservation status is unstable!\n");
> +	return dev->liveupdate.outgoing;
> +}
> +
>  /**
>   * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
>   * @dev: The PCI device to check
> diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
> index 49d07fd02132..9c31fb60207d 100644
> --- a/drivers/pci/liveupdate.h
> +++ b/drivers/pci/liveupdate.h
> @@ -20,6 +20,7 @@ void pci_liveupdate_scan_bridge_end(struct pci_dev *dev);
>  void pci_liveupdate_cache_adopted_acs_controls(struct pci_dev *dev);
>  int pci_liveupdate_enable_adopted_acs_controls(struct pci_dev *dev);
>  int pci_liveupdate_adopt_ari(struct pci_dev *dev);
> +bool pci_liveupdate_is_outgoing(struct pci_dev *dev);
>  #else
>  static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
>  {
> @@ -55,6 +56,11 @@ static inline int pci_liveupdate_adopt_ari(struct pci_dev *dev)
>  {
>  	return -EINVAL;
>  }
> +
> +static inline bool pci_liveupdate_is_outgoing(struct pci_dev *dev)
> +{
> +	return false;
> +}
>  #endif
>  
>  #endif /* DRIVERS_PCI_LIVEUPDATE_H */
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 51616e4327d3..47cb3dcaa927 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -546,11 +546,14 @@ static void pci_device_shutdown(struct device *dev)
>  	/*
>  	 * If this is a kexec reboot, turn off Bus Master bit on the
>  	 * device to tell it to not continue to do DMA. Don't touch
> -	 * devices in D3cold or unknown states.
> +	 * devices being preserved for Live Update or in D3cold or
> +	 * unknown states.
> +	 *
>  	 * If it is not a kexec reboot, firmware will hit the PCI
>  	 * devices with big hammer and stop their DMA any way.
>  	 */
> -	if (kexec_in_progress && (pci_dev->current_state <= PCI_D3hot))
> +	if (kexec_in_progress && !pci_liveupdate_is_outgoing(pci_dev) &&
> +	    pci_dev->current_state <= PCI_D3hot)
>  		pci_clear_master(pci_dev);
>  }
>  
> -- 
> 2.55.0.487.gaf234c4eb3-goog
> 

