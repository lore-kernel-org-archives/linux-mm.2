Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E53ACCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 17:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802D88E0007; Sun,  2 Nov 2025 12:12:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DA368E0002; Sun,  2 Nov 2025 12:12:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF738E0007; Sun,  2 Nov 2025 12:12:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D44B8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 12:12:08 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9F27129C6E
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 17:12:07 +0000 (UTC)
X-FDA: 84066309894.29.E96E308
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	by imf26.hostedemail.com (Postfix) with ESMTP id C1733140007
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 17:12:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=ARP+t+ms;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="v 9KpaIc";
	spf=pass (imf26.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.155 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762103526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8GBlzVdFLqLDITNMfrx+jlxxxq6gfyNGi3CdsrexZI=;
	b=R4rPnW3xJAqeho+BGYKubzIEz5ejub7FrOOTm6IGXMf0jcQsjM+wKdUmnhuvrnoSCbPuVb
	W81YaJB+ZWOOLiPAn2IgVyvvrvfxmXX3Wpz07TJXZA1BdE5ek7HgmXdv7A8CWCZCX825Xk
	hK5uwAOUjj8fmB1prZJaxVvff5ne8WE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=ARP+t+ms;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="v 9KpaIc";
	spf=pass (imf26.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.155 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762103526; a=rsa-sha256;
	cv=none;
	b=xChN6DkZzfgCfQWEmR1Vmy5XPow2hQcOxLBczdXccPIp0KeHNrfTOdcOJR9CEuZW0KsBau
	t8aHOLhJOE3olApIhMCfBxxkElOtTpVbpQqTTPhhSaaAbwRJa6Fv3xlx8k70Uk4FgQw5N9
	5iOnPXOmzE38yxSClZKtwjqm88VN+dA=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D3C421400085;
	Sun,  2 Nov 2025 12:12:04 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Sun, 02 Nov 2025 12:12:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762103524;
	 x=1762189924; bh=a8GBlzVdFLqLDITNMfrx+jlxxxq6gfyNGi3CdsrexZI=; b=
	ARP+t+msJuI/3RJhhtYbBSFdEA7HyYjz67gdLAISlfgMVO+MnsQr8r1xk62dNhbd
	yI1NvYRfUV5jvNQigsXv5hM9shQ9mIGK7qiGfyO8fc5PQcGXpIOuwDEIZ3WwT5q7
	Gyox0q0Fnl1k6VbVxwNvzp/3PszW8Yb1PKA6OTjeFDd2fkXefL0kmJv1l77vIF5i
	YIgLYJgBqufautWfZLVDdNYHKouRVaxeHaRRsVRK+pLviBAK7gJaEXGEB4qNwR+7
	Hezxm8X7xwAKlixuVAWWSJ+8dOvKgWlCg4pqu016RbmhLzs+27VhTRQqLN29OogB
	3wjUYYJOaN6K34W+lgbHyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762103524; x=
	1762189924; bh=a8GBlzVdFLqLDITNMfrx+jlxxxq6gfyNGi3CdsrexZI=; b=v
	9KpaIclihxfYlmk593KmiTk5BxS4JIR7bgYvhR0NAwe80xqKE16tUXwNpDkvT269
	OFbT4TjgEiVVOOQDgfAiN06ZXLgRr482uVauwHbvA1UG6HKqcbJGpSpu62nfR9uw
	SZQP7sZg848DbQ/gj6+NF4RZuuTr+gfvhjGuc50FwmUunVlkhCkZ8S0QFToF9eDj
	Q9FsUBEScnBDJGasO2skhA9rIWRksj1tLSmc8bbPrE/V3omRv1tZDAkV/l5A1+pY
	zSXEjUYbPxiJ2N5N7CFusfzpEys4zyVu0WPlXGZHfQx2PC4canHEHDI8LJ045GIC
	moNcBmwwrBiSN+laj4PhQ==
X-ME-Sender: <xms:4pAHaaJvAQn91kmZ_L8EDo9K0hkQkKrMWH_IihatlP3lP5mfCsgZLA>
    <xme:4pAHaVGqzWItmKM9uVjZd7D7s73TPSJT17RH_QAqT7tOT2Lt3yN0HyR1RhuS_DqG1
    Am_YdNX9LPn6NdmN50A5pDf7ybqjSBfU9JLJSS02Nex2t7iHMwkLg>
X-ME-Received: <xmr:4pAHae4VRDGyqVonaYTLr6w6DuqmTaw4vZiOzLQ3Heo4t_Q0q99oFoXPKM8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddujeehkedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeefgedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheplhgvohhnsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopegshhgvlhhgrggrshesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhoghgrnhhg
    seguvghlthgrthgvvgdrtghomhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrug
    hkpdhrtghpthhtoheprhhosghinhdrmhhurhhphhihsegrrhhmrdgtohhmpdhrtghpthht
    ohepjhhorhhoseeksgihthgvshdrohhrghdprhgtphhtthhopeifihhllheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepmhdrshiihihprhhofihskhhisehsrghmshhunhhgrdgt
    ohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggr
X-ME-Proxy: <xmx:4pAHacmtyeD6hGjmG5yJylSyTA-HADMGajUjQCdmqT32jDrnaono_w>
    <xmx:4pAHadv8O87-N3u7RBjdpz4I-VpiuG28OEKea_LULbQEWM07iNrZow>
    <xmx:4pAHafSnW8NhnYBcocBvwjMJZJwKp-bH1sWpaSPhMezd7UcEP_aM4A>
    <xmx:4pAHaXEDRYciiigXo_h0MGBa4ZI4FQYqaBv7JF7YPQQn35BVrD5OoA>
    <xmx:5JAHaTjTYS-Qyu0V5EarqGMARTYneth4LDaS1-R29jSNkR8I4POCr7gf>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Nov 2025 12:12:00 -0500 (EST)
Date: Sun, 2 Nov 2025 10:11:58 -0700
From: Alex Williamson <alex@shazbot.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Krishnakant Jaju <kjaju@nvidia.com>,
 Matt Ochs <mochs@nvidia.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 linux-hardening@vger.kernel.org,
 Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v6 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251102101158.6d2c36c6@shazbot.org>
In-Reply-To: <20251102151253.GA50752@unreal>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
	<20251102-dmabuf-vfio-v6-10-d773cff0db9f@nvidia.com>
	<20251102080137.209aa567@shazbot.org>
	<20251102151253.GA50752@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1733140007
X-Stat-Signature: 3cetbpwoqrfyteog16awgyoczyc3fdwe
X-Rspam-User: 
X-HE-Tag: 1762103525-759650
X-HE-Meta: U2FsdGVkX18LMUJQPBvcFy7pb0drcuizEoQAg37PbzzZGEPd3aHFGKxoqklL49RN8VDJEx2jfrHMCTLgUfCBD7JT0VbUEOgp1rkXUvcXwfeh+dxmsh+dL7ujLWDFLsaHTuikdbNuzRipOSTZ+dxqQMpvsU0ro3uVndOEIpzlOfRRQV+MFmSQC01yKSJYGvgfoeMC5qMoLB4Vi9mCWTeRKIkJdsa7ARBgbESMY7b9b6EzF02cmGJMkqH0PG0bWsJtOULEzY2TWB6UzcULAJyMrKVwRgTT3IOxejEnxQEDcYEMAfKK7ukkoOQeUriahQUL4p1Cw+OOxla7G+qhT9T1CZ/qVegnUg9r5f6Bdcj9yPKoDms0u9b7W+xfpxdxxkanTwJfifG57xgWVeoDPgQ6mR/7a9+UmPYTu9AsKKxTA68D3DDxP/SwDQ1zexRg3lRfr3vK/PsSnno2EjvzziDJ1RSq5soHnjFKMI2Ts/p5got4QeFUQxu/OHsuzABdapBxKWb9G/dKlGdxtYpX8CTHIfkirwszNuhd9ZFUYDVh6lvYYst+T7ULDl21tOyc5zvmOjGm6vkeAa+pPUIVhMyzEkVuSBCMIAX14Ncq4HpWbfnUyb/SXmOcW4ifdUKFO2nh9dqWompn6EwRHbfEOfBaquXVKZ6xoYbLLflhnQ8k/MuGAZY//KSNSjcuRL4BaH/pe4+1TaSNXJcovx+00MnfKvY+fpkJ3F6G7SI0JGRnqLL93vz0rRLGWjQwKiuL1SiShPCx3xw8bNlfK37/w6gBfDhDaScAzEN30yPbZTgdyhgm8JgHCH5igWJrTr7obB5bgAMeuvUBbEgk6PSVQcW4dY6sjIs9iiiS5WPbjQXMyYiO1mbvXkBhtev/dlqH4s07lDqzZQU3bqhJYFMhh3r+wrFmyYG16pv0iF2Xm5wKv8nJzK7+qQL44lu4WCQZeq3TkkDUix5UsiNSD3hHpb1
 FWCIcU5b
 AJ1DZfsHUNUAMXGMp5oc7C3owpfv02ZC5xlGvwXzhUGdb+ZGEjKmLchZGxsIZnCp7rnkitHdYEOBzbP6sr6cWhgNc9njJjZEqrM4AvL8StL2LRDvKIIuPIalVxCne97FXnpme9Uexnt3QDwikFs4ex3jZ/QlmPdh9sQm6cs6gfLRiCMtvgegtsNBpiz0Og4d8zA0YslMslbBynmpLj/3Ub3Cf+U6E4la7voML7dAS44eoPnAkOC3QsI5y46Vsc3DgGAExeHnOEZHMVLSPvHIfiR1z1JvVx2Umj6uEmkwqAiYhBXNeJcfCDg5aY9soXTmWSX9713wNnzrf0LybAepiG6/bFVK1NxYCxXBIq2Qnwq5Jv+mS4P/UnPc8tlFGksuE3ufCAgMfs/ARiys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2 Nov 2025 17:12:53 +0200
Leon Romanovsky <leon@kernel.org> wrote:
> On Sun, Nov 02, 2025 at 08:01:37AM -0700, Alex Williamson wrote: 
> > We don't need the separate loop or flag, and adding it breaks the
> > existing reverse list walk.  Thanks,  
> 
> Do you want me to send v7? I have a feeling that v6 is good to be merged.

Let's hold off, if this ends up being the only fixup I can roll it in.
Thanks,

Alex
 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 24204893e221..51a3bcc26f8b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2403,7 +2403,6 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>                                       struct iommufd_ctx *iommufd_ctx)
>  {
>         struct vfio_pci_core_device *vdev;
> -       bool restore_revoke = false;
>         struct pci_dev *pdev;
>         int ret;
>  
> @@ -2473,7 +2472,6 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>                 }
>  
>                 vfio_pci_dma_buf_move(vdev, true);
> -               restore_revoke = true;
>                 vfio_pci_zap_bars(vdev);
>         }
>  
> @@ -2501,15 +2499,12 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>                                struct vfio_pci_core_device, vdev.dev_set_list);
>  
>  err_undo:
> -       if (restore_revoke) {
> -               list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
> -                       if (__vfio_pci_memory_enabled(vdev))
> -                               vfio_pci_dma_buf_move(vdev, false);
> -       }
> -
>         list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
> -                                        vdev.dev_set_list)
> +                                        vdev.dev_set_list) {
> +               if (__vfio_pci_memory_enabled(vdev))
> +                       vfio_pci_dma_buf_move(vdev, false);
>                 up_write(&vdev->memory_lock);
> +       }
>  
>         list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
>                 pm_runtime_put(&vdev->pdev->dev);
> 
> 
> > 
> > Alex
> >   
> 


