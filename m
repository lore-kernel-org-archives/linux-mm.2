Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EF48CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A62746B0098; Mon,  8 Jun 2026 07:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12D76B009D; Mon,  8 Jun 2026 07:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901726B009E; Mon,  8 Jun 2026 07:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7B56B0098
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:33:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23949164C06
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:33:20 +0000 (UTC)
X-FDA: 84856534560.09.6186946
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3F55820005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:33:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mcCZ+LLy;
	spf=pass (imf13.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780918398;
	b=1XJVXeXw2WgZcqOpoOlo5s3NFHjxZixQec/8k08RCdXXSHdf82Bno1vSvFN7jr98lnljct
	0ylPXl+bfJEylnv1o3QMavN+RphPsTZTCrDT2RptOD8uY+K9hvAwnR1DkJsmlXEo6AZNTY
	b65vujbPGYhdcI3Pc0g23VGjCrb8NDA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mcCZ+LLy;
	spf=pass (imf13.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780918398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/AClK5b2UGJLL9HjNCJk/rNNqh+8+sTLcKYFLOrhzbk=;
	b=y+vEeT5fVNTEOI3H78vDRmQaKr4ev/uMp8jy31xLzqfpu+f0RkKx2dvzSODDsc/0n93E2q
	QY7aFdwL2jYMVPEnCQU55uqyHlAl8Gymf2c664J19+19/ySL9d8JYoHYVtPqNEjRKnBo5/
	Kxpd71VGDi4DEYuKqxUBYlLtng4EMCI=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c0b1a48855so368935ad.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 04:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780918397; x=1781523197; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/AClK5b2UGJLL9HjNCJk/rNNqh+8+sTLcKYFLOrhzbk=;
        b=mcCZ+LLySU9Og03FrdgwYjcfufTk74tGmMdS6CupTXfqzu+HGCuzFXV/ZA5TjMUsI1
         UwockeOwAezM73yoa1NfQGAioHXPDLoEIw5vzpfslKY3x3YSX5qKxln8vH56EmLKZ9V8
         8friy8QvdBpyko8ZIfce13uZ3zy5viebbCyO6PKLIegkpjR1feAtekYwhGfyXYzdW1nw
         J3weYnmhnYp/phndfGgFeVMOl8Cz/BmEqU6KHyyIKu2cQ13yrTDcANCm/5BCvZ9SJZ2G
         k8WztTDXybHBD/5UlzBLaPAo/+iqA3n4V7dShox3PJ6a2XLko8Egv8HsoIxVOexPnrI6
         2LqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780918397; x=1781523197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/AClK5b2UGJLL9HjNCJk/rNNqh+8+sTLcKYFLOrhzbk=;
        b=ieDbyoE/eC9dNmsvx8m+kOUm0yb/Qy4KtOwdc1xcuViObb1sdL6hr+defTDkOfgPhe
         XHsSiX3TxypEgAZDl3osRNcEWIMKRuYACGSJGypw//UfMwPGPZZLf7V5OPr2DKWu7SAQ
         Z3Ut/eSzIVZTKz+L44eAulbViFBRVkSouBwS5Y/06Kh+tggX5TuyGUqlDjaLcr7PBfkF
         7hJF7rx2qq9LZB4qYakW4Fn0PSNFFQ+OJzaPiDuABHfhaUD3wgtcDXchRgGvihRyIHzz
         l1SNtjq6C1TOOV5H7AklEbbym3GlMG3pHWVUphQTq/9pBRuxKsovm4n1cpE5WmTSmea1
         W16A==
X-Forwarded-Encrypted: i=1; AFNElJ9LvfimHSiOTNdo2UlyHJIWInNDB885iWQEYZ12QkXylextQcN+8StFguLUnsa9lkPEEexnmlUOfQ==@kvack.org
X-Gm-Message-State: AOJu0YyMDrLnarYrouRBqOP0797c4O6eDujhI+zIGfEQ/bQdLMMuh1v2
	PmR4pazSWOiQf7oSTWJv3tSGtvGhA/ccqkeWJox5SIQqF/FOtCxNYQQphmkvvFeurYEf5lzPQ2b
	mHi2D5A==
X-Gm-Gg: Acq92OHSPP8Y/qV7Yxm9eZMSAU1UV3bXTGDBNHXVsgKG/OFcY3Ccypjaq6HgRuImhaB
	ivGWIz1FReGlng9ThwczHZVpIIA8r8YPnO+Bb+UcTPvImNO/dI4QvmLO2zrd9od0EnrNaQaT8IP
	g+DFyPwkDNtoaLnCoYKJDApSlzVfGstAxgBbs/qPbfSaaZs2MZihQWSsYmhtwdIEmDM6ru0Nynh
	mFMZpKtUFbgVStY3OZnsA01mzAj7J5XL/sCais2aG8cty+K+m9RaA99hNzohG7O9HDIa4t7j3So
	YEAAk6YMcRejYb9FumLXBd6HH7cSLGQfXnniegusuDU/pXGzV+SgJ2B0V6/G+Hn++QGYO4ULRo1
	aRzRsvptqAqSk2r+Xc4P59zFt2cEPqy4QXAXdroSbD/iNCr5+55keDW7gVO5XXJwx7GPZqGOPAB
	ZeAaWlllbAsFKjDqpouC5fJRiuziF8HIdv16CdWOitIQ7hamQ1qwcReI9/D+KrODqNPyxJWxU=
X-Received: by 2002:a17:903:2349:b0:2bd:3c1b:3073 with SMTP id d9443c01a7336-2c1ebea9c71mr4318635ad.16.1780918396547;
        Mon, 08 Jun 2026 04:33:16 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f9ed6csm182143405ad.31.2026.06.08.04.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 04:33:15 -0700 (PDT)
Date: Mon, 8 Jun 2026 11:33:07 +0000
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
Subject: Re: [PATCH v6 09/12] PCI: liveupdate: Inherit ARI Forwarding Enable
 on preserved bridges
Message-ID: <aiaoc6Y6qeF_5Wn9@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-10-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-10-dmatlack@google.com>
X-Rspamd-Queue-Id: 3F55820005
X-Stat-Signature: z7ydehum3rg4gftwm986ywittpwbhykz
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780918398-105033
X-HE-Meta: U2FsdGVkX1+dVHULtn9UboBt2UZe3exH1HZXkft5ZUglHOjACJl7RfKvtouagIl3tVgehq7Vy/p4uJf0hDLAAw7XS64qwSZAACRZ3VDc8FSiga0GANfKwhck00ueR5K7+B7nxMTcdAIo0zgph0I6ZrZ9ub9BN8jJ2IyM2et+MRadREVkX+MzjeXwB8Tz84udL0pRmLFgnama4xYhUVyRpc3wV/Mux1iwVJvr8KIkVE24tTe2hab9wle2OT/wvAXRelgHypnXuQDLRb/aYlB7n9CfEO0rB0td38VW7zlcOzL5dVy3M2oCj1t9CMbe4epkZjtZArHCmwaIGKJ+lFdaM03OZJbCoMkU1IQ+Pi454aChfM8ClV+Xh7mn6mx0Ut/hI9pdbOw76u6tlLwVj9E9NJC3JbxlepaqYaJVoTr0dRrVoY7WC905FSpjPV/FR5XPHoX5HRa+MJfFd73maFj2dH/w0QhpgX69+qrazL4KE1ouTLMRymYdlzSjagotjjTHcZR4ZbyIKrw8bWtkQvEU5xFTD735J0bNsz3i6ZZECpusTHcKCIHVRkvnj8mfSYgqpSZLTrm8miYnPOMRgh/Wbt2v4qtbeRxS3SBBHfKjYrKNfhml32BdFzSlaIi1Q1g3s+TIXGNLu5UwAfcEDH8PBKqjnP0fBsr7d81wZGrYK+udQrM1Ewagb0Pm5hnpalUhNXw9NhidERjuy8PNjQrKXHJNOvNj/0udcRj/SDhcOi6tmMVz6V928ISbSl9vpNl8+M4N0PDTVu6Ez98A75p66IGG7xyc++KzEUdjqE4L8lLCB/2fyPG/uZk0jNLCsITXEooWWbKm1jn/MQTfNoeRGkKtd1lcbRVgEwPbnjuxVxTxmEMZNDOS5dwaiF7QCWfOKIEycACru6MTC16cO71aknxTakWJD2kj5yqTjkaYKJ67zRVKm8apnPnN+iNs0lyk+8c34USKJzmpib3eSVm
 BqAd3HtN
 3NKJue62+HCP9xAwLEX1eOpsygpfntEJ4amE0qa5US+XhmuOpIYW1YJwqJe8TcZt1J0GTA8KGXwsK9QBYvttBJ/bgigSsFOuEyo5yzarIdV3G3M9NkS6zz3Sw6NPtr9f3LujrjKz0tk4RHWN5OcTK9Kd09AzbBP8j6Y0fxJ+KGHhV+69kyTTeifkjEguI7RcOhF/ZjBiNiLrMAtieGdYgRI+T+opgf81uyE7+b+ctbkF9R/jv2FwprFa/nj2xAyJmnX1bYgHx9s9q01ipt/U8sqAant1XFSnjH4JNuJ9jQ/OwInlDB8aOLf/Ovp767GyOdryS1xr8Pwq/MLxeJSW5ikGcT06UL5hEZDSG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:24:07PM +0000, David Matlack wrote:
> Inherit the ARI Forwarding Enable on preserved bridges and update
> pci_dev->ari_enabled accordingly during a Live Update. This ensures that
> the preserved devices on the bridge's secondary bus can be identified
> with the same expanded 8-bit function number after a Live Update.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/liveupdate.c | 18 ++++++++++++++++++
>  drivers/pci/liveupdate.h |  6 ++++++
>  drivers/pci/pci.c        |  8 +++++++-
>  3 files changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index a93b7ef065f2..701276ef6cfb 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -128,6 +128,10 @@
>   *    way after Live Update and ensures that IOMMU groups do not change. Note
>   *    that a device will use its inherited ACS flags for the lifetime of its
>   *    struct pci_dev (i.e. even after pci_liveupdate_finish()).
> + *
> + *  * The PCI core inherits ARI Forwarding Enable on all bridges with downstream
> + *    preserved devices to ensure that all preserved devices on the bridge's
> + *    secondary bus are addressable after the Live Update.
>   */
>  
>  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
> @@ -756,6 +760,20 @@ int pci_liveupdate_enable_acs(struct pci_dev *dev)
>  	return 0;
>  }
>  
> +int pci_liveupdate_configure_ari(struct pci_dev *dev)
> +{
> +	u16 val;
> +
> +	guard(rwsem_read)(&pci_liveupdate.rwsem);
> +
> +	if (!dev->liveupdate.incoming)
> +		return -EINVAL;
> +
> +	pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &val);

Again, I might be thinking out loud here, but since these are
hot-pluggable devices, with some FW / SW running on them, I'm a little
worried while assuming the HW registers can be trusted across a kexec.

Say, if the bridge experiences a reset (e.g. link drop etc) during the
kexec blackout, the PCI_EXP_DEVCTL2 register could revert to its default
state, meaning the ARI bit will be 0.

In that scenario, pci_liveupdate_configure_ari() will read 0, set
bridge->ari_enabled = false, and bypass the pci_configure_ari() logic
as well, permanently leaving ARI disabled on the bridge. Any preserved
downstream devices with function numbers > 7 will instantly become
unaddressable, breaking the Live Update. Even if that's desired it gets
hard to identify why the Liveupdate broke.

Should ari_enabled be serialized with bridge's pci_ser to ensure we
correctly restore / match it in case HW changed it during the kexec?

> +	dev->ari_enabled = !!(val & PCI_EXP_DEVCTL2_ARI);
> +	return 0;
> +}
> +

[...]

Thanks,
Praan

