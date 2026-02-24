Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC2E3E9B243
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 09:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04546B0088; Tue, 24 Feb 2026 04:36:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB23E6B0089; Tue, 24 Feb 2026 04:36:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94636B008A; Tue, 24 Feb 2026 04:36:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3A146B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:36:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 59DE18BA05
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:36:17 +0000 (UTC)
X-FDA: 84478844394.21.6359402
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 941A140006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:36:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jFjVn+ko;
	spf=pass (imf12.hostedemail.com: domain of praan@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771925775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24cju2hDHQ+kbJrPkzmdwVRuKgiC4K6oV6u1w7p/OMI=;
	b=yKQome64Kz8rC7HjXEPPPDTmeCjYZfc1mKwgJEDtkcHMtTDL/fK1vHZ0IneHWYylIWrrrz
	8ITQ5GcKqd+pBAAyByxzAuCz5o/bC4rnw7CoiHyPnngs/WE1hKvXvlzyPZxhstXJbZsW4A
	pQLuqp06vooaBQ8aA4o1MxoUBNMrkMM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771925775; a=rsa-sha256;
	cv=none;
	b=oYdlIgjcmPMHeyK7lqFJd0hjzT0O4O3FsljJFx4ZgSHXodc4Io8tz1ouURkZFieI4VPDsm
	rtUJ+C1TgJ2sLWi8lT6akGCATzASYOlY6zocF1iMuW3+7yu3ZTHNJFJNweXNFVJWylujrG
	nSW2kOgYI5OcofuBz18NyG8fwTL1EVU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jFjVn+ko;
	spf=pass (imf12.hostedemail.com: domain of praan@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ada9e4ea32so39785ad.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771925774; x=1772530574; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=24cju2hDHQ+kbJrPkzmdwVRuKgiC4K6oV6u1w7p/OMI=;
        b=jFjVn+ko+sf2u62esjKQH+XU+Jioj4Kdsvj+LoYDpJxtBTMefu/+SmX5vqkzl/Weli
         rpea2EKYhWRw8/C9AoMMBnKJjc8quqSh9z7ilesBbQZV9w8bVhxdoaB4m7TDI4PCgfv3
         SCry8AZXPAKrMyCBbS53O+BHC6iV7h+rXAOWYBtJmSFcDc2xxFlXm8csYNzMTTHFkKw4
         okCT014Egs0M9Ae23DRQ6PFUlL49On/kYXtkBeCE9qlEuC1xZ+dSGu6RdQ7glGn9dyOu
         rsKmNMRxdhdEwfXMStuFbEvgEIJCDu3XqEjSRdWKkj8AVuPthfvpppFD61Uphwf+a+kV
         Ot5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771925774; x=1772530574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=24cju2hDHQ+kbJrPkzmdwVRuKgiC4K6oV6u1w7p/OMI=;
        b=W2+7ZtyWUHwOOGSPoPBpvnn92NjqTkLJKj3Aq60WSQlhvPxYYRei2l2iwloH6vYPLZ
         7f0dOD4vWnjMXirRpKHmsXuUkR7FXqbi5XL/3RnhfaBMLNiQBsGECA3hTQhGoK1LV3Gw
         23H8DmKdKc5828VwyNrI3/ml4dv8pZjn9v53JqRAgMZe/EW6djHWI+tVziTCxvpYmsOw
         Yc6UtGOQW1t8j10wEuHf8EWU0yaJWz2TF/cQI3J9c8tnLrI4Wa/T3sJToCl6NN8byzuc
         19qD/YQJ84YVBGtIsbfWfkBTa/etXbtAO7Ai+gjW18Bv6jEggLRtPMf8pSXo1s4+28qC
         W3Qw==
X-Forwarded-Encrypted: i=1; AJvYcCV670alB517J55zKrPrkbEKsUieYrfcyhHUufs83EnCWiOVb5lTq20ubbI6Lqe0NV+sCiQ3yeymnw==@kvack.org
X-Gm-Message-State: AOJu0YynDlso0Sjr+5lECuwdxEVwaTRbAqDgojio8yergYA/Ebc6T8rS
	TvaVNfuI5lN6Cyc0g1faM3o/RC+89vrW7u4K0zS0tCTu3W5km2xSNFaDV4HnDFIwXw==
X-Gm-Gg: ATEYQzxKELZlC/4aMjV32CuTint9BGJ2G9W9ByQe//muVx0P27cxNIF2/k9vXwhHdyt
	GyTMheUbY8K+r+7LgM8VuOE36XIGKa2UEV3t2Ewm+xImakMk7TQ2+kq2h0HHJaNAtaHgMP+Dp0g
	2OUGy+6Qb/qzZjYEQFgPHvmF3XdZIlit8BprjCbFnXpbaa8WDoZAa8gR7Lqx5jkres+N+VAeuVr
	raUquXEjiuIMinsdeuoz2Je3mjEtQH3HHhYAWG37qTN/si9Y+mWiUjGnjexfhRUdo9nVBD/GrMa
	plvTFf3Ki986Y+ziiWgp04ZtzHuq0De3eYZnexS8Kcyi+VeD8DmeROVf9ow3kAPUpndarx9Zl2H
	neVvxevlLpHmJ33qhlBUrcwf7WsSXw8SISZEaAu2uAYQ/OmqpKDtQlROaHpBqeJaTgEPSKt1p/3
	G9qztNarTp1XJflk2sL0qvXf+T8RK26IsT2O3zEE6ukMMWSI5vjn0H4489uZ5W
X-Received: by 2002:a17:902:e78f:b0:2a7:7f07:340e with SMTP id d9443c01a7336-2ad993a510cmr1492795ad.4.1771925773665;
        Tue, 24 Feb 2026 01:36:13 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70b71a7351sm10754939a12.8.2026.02.24.01.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 01:36:13 -0800 (PST)
Date: Tue, 24 Feb 2026 09:36:03 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel
 during Live Update
Message-ID: <aZ1xAyN0vgLWIi5y@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-4-dmatlack@google.com>
X-Rspam-User: 
X-Stat-Signature: nqtfjdco3cddrjbpx3cby7pcjrdd1kod
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 941A140006
X-HE-Tag: 1771925775-732941
X-HE-Meta: U2FsdGVkX1+H6VkUDF9HOlGrBcgSnhltWHFbZ5qToZn6bM+gd0npNd3s8bB0Z5PJ+7oOZbPc4aFqitFJEkRq/W71wvnK+CGgIG5xgRPcb0n0+q7G+2/ze7OOiPxAGcThe1HvTN/+yEUYgZ9OP7TGUkgdhrFBaO4JMfHYrX63bTZh9wIKlJ2g9Qci6Dds8Y8Go+/reVUuU1aCbU6wtCW6S3jyauiw3NuOProyArs1n174GUhtB9iRgE73FgOlJZ8dDQWcSGiuSErMag6UkCr2Cxz+h1lNe0C/Ao0Yqmqo3GBXIReOhL6jFyDzws0Ulzdua/6b2zN9DThPxdCqu3867OICw0LeOhi+aVTZiN5bMvVo9o8s26TbobsLr7SJIT0nWbMbUdT5q+1/FHsiXEtprVgRkUk0xrfoIyc1VGl/qoBg0KUN1kRmvf7R/kRb7j0lF/ARtt+B0X2dicsFzGmcy5KvU2BpQYxJfuYOZmP4p5Ok2nu2ciT/fQH/k9J86KzjllO+JwFodHoZPtWRQXNae9c5k14+hvr2XpoMrVY/LVoA4g3K5okj9ECEerz4b7VdB2xtUQUH2br3uKQsyNA1Sompmtcrtxs4yAMViqQLziVTR/8ILGIudtn1tGhPa8c2fiwgHYkNGkNqdHRka20qvUM3ukqCoTfVPGKvIaKzfKQySjrXHbYjncQ4PX2VQ0vXcQP69qVnR1kxa9P5RPVJtV6ExyfiCxazWwJJCqPI+ObfcDp5T2Y85gDx9XlvpS0ISF8kOgFJnOjMVeH/csjq0VD/yeMuonVVIyFHwOLPQIAPsBFNMEQz0ttbQzG+fYXNvpWJVdyUaSC+JfE/b7j9K1Ql7dcLKCaPU4NWgCBXhubSyKF/42dbU2fEOsPGfyXfQXxoyqQAHODjG3cMQIr+heAmnMRiQ5JDYHNpHeyWn17M/Rkc2FS4PP4J1RBstuXsgmm6/ZYHbzlcxDXdH+V
 gDIGWrQJ
 XYREv9QayqMxg8xdrQZ2uQWCxrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:24:50PM +0000, David Matlack wrote:
> Inherit bus numbers from the previous kernel during a Live Update when
> one or more PCI devices are being preserved. This is necessary so that
> preserved devices can DMA through the IOMMU during a Live Update
> (changing bus numbers would break IOMMU translation).
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/probe.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index af6356c5a156..ca6e5f79debb 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1351,6 +1351,20 @@ static bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
>  	return true;
>  }
>  
> +static bool pci_assign_all_busses(void)
> +{
> +	/*
> +	 * During a Live Update where devices are preserved by the previous
> +	 * kernel, inherit all bus numbers assigned by the previous kernel. Bus
> +	 * numbers must remain stable for preserved devices so that they can
> +	 * perform DMA during the Live Update uninterrupted.
> +	 */
> +	if (pci_liveupdate_incoming_nr_devices())
> +		return false;

Following the comment on Patch 2 regarding propagating errors, the check
if (pci_liveupdate_incoming_nr_devices()) should be made explicit to 
distinguish between "Preservation Active" and "Retrieval Failed".

> +
> +	return pcibios_assign_all_busses();
> +}
> +
>  /*
>   * pci_scan_bridge_extend() - Scan buses behind a bridge
>   * @bus: Parent bus the bridge is on
> @@ -1378,6 +1392,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  				  int max, unsigned int available_buses,
>  				  int pass)
>  {
> +	bool assign_all_busses = pci_assign_all_busses();
>  	struct pci_bus *child;
>  	int is_cardbus = (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS);
>  	u32 buses, i, j = 0;
> @@ -1424,7 +1439,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  	pci_write_config_word(dev, PCI_BRIDGE_CONTROL,
>  			      bctl & ~PCI_BRIDGE_CTL_MASTER_ABORT);
>  
> -	if ((secondary || subordinate) && !pcibios_assign_all_busses() &&
> +	if ((secondary || subordinate) && !assign_all_busses &&
>  	    !is_cardbus && !broken) {
>  		unsigned int cmax, buses;
>  
> @@ -1467,7 +1482,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  		 * do in the second pass.
>  		 */
>  		if (!pass) {
> -			if (pcibios_assign_all_busses() || broken || is_cardbus)
> +			if (assign_all_busses || broken || is_cardbus)
>  
>  				/*
>  				 * Temporarily disable forwarding of the
> @@ -1542,7 +1557,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  							max+i+1))
>  					break;
>  				while (parent->parent) {
> -					if ((!pcibios_assign_all_busses()) &&
> +					if (!assign_all_busses &&
>  					    (parent->busn_res.end > max) &&
>  					    (parent->busn_res.end <= max+i)) {
>  						j = 1;

Looks like we over-ride the pci=assign-busses boot param here. 
We should document how this change affects the pci=assign-busses kernel
command line. If both are present, the inheritance required by LUO would
likely take precedence to prevent DMA corruption, but a doc update & a 
warning to the user would be nice.

Thanks,
Praan

