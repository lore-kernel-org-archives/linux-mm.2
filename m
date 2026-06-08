Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17513CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160D76B0005; Mon,  8 Jun 2026 07:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139306B008A; Mon,  8 Jun 2026 07:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0277E6B008C; Mon,  8 Jun 2026 07:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E643E6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:58:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96E721A0A87
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:58:33 +0000 (UTC)
X-FDA: 84856598106.06.B15F840
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id B86E7C0003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:58:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ifyb1RFZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of praan@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780919911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CB2k4eqEZ/J9Iam1QvalqCdyib5VuBIoGU6FvxH5X0=;
	b=rgxpWd2FklJCbMSYt2+KGwD6+P7szs8au/oiZXie9FtRzIhwtGCHj6pSn7xuE16mMZAdte
	ckkz1qu22CGwQitnqvUhD8KK7qxyIYVuL6O6sztRShv4O/Hr8vhp4FNGxmVqxgb/NJG+GK
	nDYWy90eKlFzOsZLfx9PUqt5nmP3d/0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ifyb1RFZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of praan@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780919911;
	b=FHoJ8W5oUq/9tUHu9C6hWo2lP7RGUsM+6tp2IB8VVAutsyqaawWUNJzDTCI/W1NXFpTta2
	lva9vG15spcmCRqFtfTnXKcUkC77zyzXjKjnYWhI8ypueKF+zVOPmsqOYQGMftQlE7L4UB
	wsxXBIxYwr17do9KABhui5w8ofLnR1U=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2bf22c18ad3so373805ad.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 04:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780919910; x=1781524710; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8CB2k4eqEZ/J9Iam1QvalqCdyib5VuBIoGU6FvxH5X0=;
        b=Ifyb1RFZATFIDVtQbyF38VmdP4laUjBC5DybvXd1mmM5mvRnvsS2ZvH6sYp5GwCoze
         UUppSqvppQh8FCP/Lvda2zl2Y7x8iYYKlHano4ocfLeZ2B6QufDJWjklIlgIeJKBEpoM
         jEjstBk8Zi3S8jgRTtgSIaq1krpcq5f6yUUwmtel/fvLZ34WsnhovfzCdpcOgjmUeNdU
         5HWljyNQEzCFRuU/AIr+ADm7i01ohAZJj50OqVw6as/LaXJfJCIKMZ3EPn+vZzMHVrRp
         OnEvibcbZBi1Y8mTvmpV5j4VOTdgm6PcDIwK1xAyohKUelnIky6nWttX8dVyrRU6ZGGm
         idfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780919910; x=1781524710;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8CB2k4eqEZ/J9Iam1QvalqCdyib5VuBIoGU6FvxH5X0=;
        b=UF79StcrOjRfTcBf8Jz82OIXSLyB78/T4G9LuFmfF2cxW297ilL4cJj5V/jeKskm7s
         Xro0TqP4gwuVjt2/9oFLQz311TTKb3kVc7JiWv55zpJpz6H+az499t11A9GWOXpvgltY
         lb7jesV26AsWprrDXVJFXJGtCI17EyO8I4KfEy4hcGVhlWpLwQfQW+DmJjPEvKv7ckbZ
         kAXpbC+nWAFKZnGujWYZpjn1OGQyzdtcM1I1YvdW8Upsd6v9mYOzlSthoy9McMLco9i3
         9BZuYTwXA1L2JkFqLLwXSrTWqli6nCOFsEiBdraX4UblUKEKHVUntur/qu6eOz6uBY1M
         15eg==
X-Forwarded-Encrypted: i=1; AFNElJ/uyRQViANcZyxY1k5yLjHnX0yQ/raRGh6qVZ1pCou0C3qWfNBtfzM6MjNXSGXBNgtJOyOX+h0TFA==@kvack.org
X-Gm-Message-State: AOJu0YzXzBrt+Hxj3fEcgQwOYtwDa5QGDE2PU5/E/6FuV6klRjpRCdxn
	wv68uMwEsv8+sOxbvPNCnoPJhwnws7DmrgzmQ/MvSH3smuhGmo2fHjj9KjENCvuEdA==
X-Gm-Gg: Acq92OHIiXPAc+7ALWdPMthRnBg4ndVPgCRH90tK8Ffwwbjzc0krjfIcuuBSvpcyjt7
	qiRt8P9ZnXIen1bnO9J2jv6sFE+OLfgs0kaD7zC5v+XS4O3rKNxbMCyHsBtMlM17T5lkAJ0tlKf
	HycKX/qFTKqhtCSMFbmL8B7tEcMaEISNDnsgumgTPdtcYMkNYcn0zpqDQsOaj9pYiR0Zx93prAD
	PmRZe+nsC0fseB8/P3TJaXvEx2oM/Spjbwu5262Z7NRpF12lQjZpwWB/YbV8UsyGrJx3P7IDIy7
	uBfNtgWRed5YMqaea/wJplmt4hMYbMiIJ2adJhVHdXtiatzS7plMV3qW8yKiks3q7kU7hxiT0xo
	PvdpzzogzCWchUsGphtbzMPFoAoBHK8uRqvDXZl51wOKCTvVicJzImFCXr6c6OUBRVqJLRhP4TE
	RtDtGKg/lmOs3S0DSpYIM/4UtUI4OGfZ4eNctBa7xlkuDIpfkmv9mJlgFyWkbu3Au66X+oXrA=
X-Received: by 2002:a17:902:f787:b0:2b2:70ba:305c with SMTP id d9443c01a7336-2c1eafbd48cmr5222305ad.8.1780919910000;
        Mon, 08 Jun 2026 04:58:30 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85df0b56c5sm15740485a12.27.2026.06.08.04.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 04:58:29 -0700 (PDT)
Date: Mon, 8 Jun 2026 11:58:20 +0000
From: Pranjal Shrivastava <praan@google.com>
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
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 11/12] PCI: liveupdate: Do not disable bus mastering
 on preserved devices during kexec
Message-ID: <aiauXATym3w2QX9N@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-12-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-12-dmatlack@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B86E7C0003
X-Stat-Signature: piiq5feazsjb3rjrj1nzzupkikghkhes
X-Rspam-User: 
X-HE-Tag: 1780919911-938659
X-HE-Meta: U2FsdGVkX19HdsbLSUr46KbHjhD+Nl8yS2WtuzK1R9R5ULGUQv3DRjQac2Cncioif86qLcVgp8c+i3YLSsImO+QOx/pJd+NfqIgScONjb/fpOo/1/ZpexbADfMwN+cS1j42gkj3CKXoMhUi/I+AVbYV9w0fBFjsIaJRS/Ti/q9WHn5zMT1/SL/tPY/tUATMkBRYK428PpwEqJG7O9Afx142jBxHCbIP1H7SQ7r4tWJ6IgUxSsWZ6w6f8J3wXXDg+Nnohnp6qVxtWmcXZKxeKNTNLEEn2M3Oe59rkAgM8gjLmIYfrO8xwrh+jAqKDZl3WVZF2hDewgwsNPjuPpxAjAqRAe2gmylJHG+ZNpn2CJn2eFS9/j4slkYujTp6IjEbif421Jiyx186y/FDpQ/K1sM4K7YTUYl/1gKdRWKMiJQ/Lm/Eg0fReSM4URoioJbroHv+3N1juQ5tIPA0QUvjShBp3fIzXVxdfsg4UmTcsDYkXa1QLMtu8wS7mADwdhrvCVZGxmYTMH97A+HeIrZIt/wYW49vL3N+fP6U7IZR2TWYhPlK2w1E0ePCUnVhHCf56kReX9ngokaZ0cuYtWvdvO7RyJt44hVqOPJ5GKg2XCZpVmZsYxw2KIb38XMXBJMLZkU0kO0M4RQvPwDiFnOqxtBK15VQ4qKh46Yt5aP80iGjks9cblg/+p2KEsgs7iH3M3hNikEN+61Ccow12vlGPL1henEVqpmlePUTwI0+SYx+15kRyA7Q4v4LWU2dL7h7dBF0Dx0lvF28pUBz8xKh4L8Ua9En3k2nk+FiJ6XDDvm+3rpS34IWH/hdMapEc2XrmunLRdYnPo4833W5x9YXNrUIN3IcSyrLEfHTsgFwMrMNqCATx+JD0Lq5IDjMH7PgoMFlTWZxhg+Wq0PzY3I81NuoIyA6sJxTjgqboiCdTHJAiHPGbdSNQ9KIA47enWQpa7cBayyTYKzJ0ZrvOR9t
 DBMlcK+H
 DHi7V3bOeqA7uc7ojSvvZJbWhPX7ZMB83n5jnbGbU0DnHkfLM7GuDJ7t0kHM4O8sdya6jLN2ANJ6FYA2R6vE4yP67ByY/kundg/DT+Om3y+s3evF7KaT8v5dsYrJoO9vSy59PzTgfwjyBNZ2KW3XBkuHFthozdxhfdP8viAy6i8+Bo2m0Sc2AwFrDdUTNiGpabwcff7svsKOYs22+liKwyqa+V2+N17qujWygjDqL9Ltuyam4/eYoniDxw+HgZBAeASoiKhZI1r99YI3AxXp9in+zqADbQcFDRPDFww33KoVHRCBm88SMLq3IYsYAWq8vmu3QWyXeVA4GKKqQocRiGqpO2jGusEvkgoyM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:24:09PM +0000, David Matlack wrote:
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
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/liveupdate.c | 11 +++++++++++
>  drivers/pci/liveupdate.h |  6 ++++++
>  drivers/pci/pci-driver.c |  7 +++++--
>  3 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index d404e64a4e55..a6f2790bc1bf 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -132,6 +132,10 @@
>   *  * The PCI core inherits ARI Forwarding Enable on all bridges with downstream
>   *    preserved devices to ensure that all preserved devices on the bridge's
>   *    secondary bus are addressable after the Live Update.
> + *
> + *  * The PCI core does not disable bus mastering on outgoing preserved devices
> + *    during kexec. This allows preserved devices to issue memory transactions
> + *    throughout the Live Update.
>   */
>  
>  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
> @@ -790,6 +794,13 @@ int pci_liveupdate_configure_ari(struct pci_dev *dev)
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

[...]

> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index f7a5e65a7c75..0b1f8d01d7a5 100644
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

Looks good. 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

