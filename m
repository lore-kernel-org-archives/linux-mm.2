Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B650CD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 19:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CCCE6B0088; Sun,  7 Jun 2026 15:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D986B008A; Sun,  7 Jun 2026 15:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66C7B6B008C; Sun,  7 Jun 2026 15:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54FF66B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 15:01:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2640164825
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 19:01:39 +0000 (UTC)
X-FDA: 84854035518.15.150C14B
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id F365820010
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 19:01:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qik6IaHY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of praan@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780858898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7bxnEjA/C3zuxdR051u14W5wOLjOO10IAKaN4C2htfQ=;
	b=UlQ6+m13v/xxvRxHkcs7nFKwbznw/NcvowWKWVnUKJWBklkwzXTZsygCAjo8gBhVlGjY4Q
	GTG5AFDAubwHYooWTlnZQtsatYlyyZR8XBPsJKu3qMqx0GTPlu2JejjJXGyyTqwerWXHgZ
	0Pdn39O4+28O8LxdLFAGvYoU5BiOJHE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qik6IaHY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of praan@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780858898;
	b=o8z6c/jiWvBUCxP7TnyhT/Q7YFhI9h2wJZMTpTzF9W0xbbIUPfJMKgYcAWvzGsGwM+0sm8
	GPheVxQUtb441z8cLDoOR3ER/OYY8A8Uu2K1bRw01SAHHs2zrphk1ambcBz2KdbAIovxxq
	0BhWNYM29rLO5GVPSfMyg1NFhZBSv60=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1336742714fso24287c88.1
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 12:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780858897; x=1781463697; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7bxnEjA/C3zuxdR051u14W5wOLjOO10IAKaN4C2htfQ=;
        b=Qik6IaHY0ModhPQj5mCm+YNKzQDeIwWzTpXv266y112vv6N2WLgI1IRuEAiNTM2Er4
         5kh1OdKFKsXn7wCEgM+h6rKvPKRMOGhqiTTSeX5wiz09Kn0Kp6SLk0w0S/xdYwtvqM0I
         F6XDuyyQXA8bIPSLPAVSgJbsYG9Pq3TEZj18NzXPWcZx+VGcStyfml5BhXYZd2Ls0UJt
         etHvv9NRlp6evEgmebkzZ5uMXYdAtYHN5Jn6LpSIgsJKKia+9AWHVOW/yG5vm16RmB8d
         QrqD/5UGwEnPMbyYEMI00oCVp5sylJbuD9qQhNy+C8+MzxyI1HNdKH1A1ATeFqiaLQ7K
         WVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780858897; x=1781463697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7bxnEjA/C3zuxdR051u14W5wOLjOO10IAKaN4C2htfQ=;
        b=fWWwsRr99xQ3V4UGggeVwZ3EnhCyAZ8oZH66ZiKuG/c3IwhZJ6qtP66LZ2Ei0ZdRPa
         bdp5DeROFEmQaioH/JU2eTHcBbcnW2QxprWNgVC5MNVtA/pAZ2Z3Uo7MBV1bNIfIOADY
         RuG6FGplJsUa1WSHy1Em/SMUpim0GT5JYrG/Nn7YfWe9N/B8o+Ed+GMVe+0BfPzHNaF/
         qsTkXSrrrxHQVZVL9fvyRSIfC5O7eYuO8mxACDFviwuPyKYzADiWi4KfuWf+2RLXQYje
         krZFxYXTnpByOEWiJzpdu9S0Xr91Y5PYNLQFQsnSY+f8EprlqH2M2hXhAg50Ke7TJwe9
         WNyg==
X-Forwarded-Encrypted: i=1; AFNElJ/UPzZh1io4qxc14bmanTmZgSkEsHK8LnJKZJTrNculkWNdXh9FtFXDaF8MJvBwItKhqQ/89PiZRg==@kvack.org
X-Gm-Message-State: AOJu0YwCXk2Jd/ZRG0RsyCWpm4yHoKrn2Zn2RMKRILZOQfFyryVRSnHz
	kK78pBC0Zz8BRqcqaGRzVcfXqjPfq3Ft4tIBPGoBHU5+tmYPJzek8UU/CS6s1mU5+A==
X-Gm-Gg: Acq92OEPeRCuCFV3XilOkw5toh+I5NN/QTX2O3coww2s++6vmVdAXphH1QItWzm0zVO
	qdxQa5wjWPDRS+j3bzO6Y4lDp40gyHEWeo+hr3exnY/EN0mUp73HnMgy1shXNCBpeBsEzTdM0On
	L+bL9r+zNwNwdYIeKe5bZ0a4tvUil5EkqLYkivpIySH8y3kxVtVdCvssMOAuQc7eZF0WJQ0U/zQ
	Gl10FDSdL5Q0yooTAxUwWVAgtXq6My4C7cR4Q4t/U1fU5e9BKIrpm+NE6b5ZyDkU4ZoDdV8vZJi
	tB4TB2vcMpXbtTpV/1cfLk6Uvq9vM5r8kcmglFS4hzuq6olg46q13w65fEbWE9r3Ot0XtYomEGL
	YQqF0adyCTPOygkjPZPkElDaM4oj6gST7smqjbsJh7KlA838AG1bxVeOKzx0VGdKEzp1pMqZQWZ
	AB+X88qFkcUcsliB8kzrGRDVnYjktVa9Sui7Ml9tkD4z9Vy3QmeKtBTKyIdBiYqVyOoC8bmjs=
X-Received: by 2002:a05:7022:23a2:b0:138:888:32de with SMTP id a92af1059eb24-13808883386mr174298c88.30.1780858894965;
        Sun, 07 Jun 2026 12:01:34 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074dea8e76sm13773740eec.18.2026.06.07.12.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 12:01:34 -0700 (PDT)
Date: Sun, 7 Jun 2026 19:01:25 +0000
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
Subject: Re: [PATCH v6 07/12] PCI: Refactor matching logic for pci_dev_acs_ops
Message-ID: <aiW_M7y0fFwLN84G@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-8-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-8-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F365820010
X-Stat-Signature: r38p8ifj1ukwz6g8sfonw38n7icddn56
X-HE-Tag: 1780858897-39306
X-HE-Meta: U2FsdGVkX19PeLyOMM+4NBo5+kLmJkwS0cUeV72JT4EKRHddxUAQTAy9DVM1wH778PvXrHX9yrhGPH90fbINV7S/NEvKyk/jr76BlLvdvpkdZum5TvpuraoviTpFY+lhU2VNi64A56fomXsp9OxhZKZmZzL8qTBQXsqPNY5jKby8/mCN6Rvw1TnIuc5yMpBntjc9BRoKohiOAxWNOJ7G8QQiqGniW/jsmxCr7jp8ZN67cUMhfdjUQb9CHGhbcw5uua3stlorqG6M/6+4qDPqS1snfDVyC2wOfqFkrZXEsKpb3Zu+NqwJkKpXrWzw2cAYCWeLjZYKTnWETzBXP2Y3+MVlejTDq122E+w1W4DfNLyxhRGc7UXLu8bzEo9aGc61s073i5pewp8pMBgdmO+Re/0MBtT7cuJvg56jgnromosso2OKXYQBo7uFi1cWyieH8RNzY7QLf9qG2GtVJ7Uwev35Q5EqWNC/7YgBdR4vbsAtOXhrS8KhGf63E6L4vVb6AOsl+7ZeFbXjoXKYUaHR/segmki7sc11mIgHQHMVedOTvF8LnX+sW0mWYwqpqojytYOuh1iQtaDlrahOeDLzcUVOGXCZWsTHeYsEe9yp0VIdxFiEGcu0wEwNr4CCAK5g4rC8VLocns0uSdh/hRtyiBCelAEwPEiecFG3AIpZnLXSP1LBk/cPbTySX3OYLqH1W6B8AMPm75wUS6q23jBLy7h2Ts0owcbo+YUxGd1MjcZnV1s6RON+F90hfboRizIQ2OHTqdlu4SHUFPtKHqnSlml+XvFOUO8pTr1fHbUpf3CgX3pb4z4Rw0znMxxT5Jow3QW5it4S6k45xbbd/BL8iNnOj3tSjdrWmqMEQ71R9kjlDpiKi+hSzZC5Un7q+ejy0Cs939XSAV8z7BpMhrauAmU3TYZX5L8nPdrXZoPSE/nQgi/eUKj+5+rZIpkPBepQrmnndJEJjqJw7sc1zVi
 40V7knnQ
 EUYOuAMQu4qbLR4EwJ6i8zsNQvIMZhSED9bAnsH0+1tOUq4RSSABp1gK9IFuowcQ4GIajiMN295mdbIOsJgYG33OZTetU5Gi0Wdrs3gA1xmeWE2bbR3Egp+TAbc05iOkOSbc49Tj80Z9pbPXMEp6glwFtLK4PDZpEGbWyVQdLXKnwM5uMk0XXF9yHKzLq3TJadf2agumMfL9u/c76Wf4RQt6y1+SlT3W3mhtNn6qWO/Zh2NM4ELQTdZxKf+ZtnFwcswk1NKkrSWG2KGo7r+etd+Nz8phYOgIXs3Mv7a/Wie4RkqxDw4qUvjCpogsonGMZ+lTv06j9+6OisEXa2hv2h2qPSXNACh4eLbygWIIZy2hv5OP6f4carmOhgAoezYxFU87NcKinhZ388VK9f6gbvgYv3y0Ki8MWLFhn7b/zmecB11G7Nftf09VzVYn5FGmwzZqEc706yKDcXuEfU95aMcuWllGngROs2tc/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:24:05PM +0000, David Matlack wrote:
> Refactor the logic to match devices to pci_dev_acs_ops by factoring out
> the loop and device matching into its own routine. This eliminates some
> duplicate code between pci_dev_specific_enable_acs() and
> pci_dev_specific_disable_acs_redir(), and will also be used in a
> subsequent commit to check if a device requires device-specific
> enable_acs() during a Live Update.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/quirks.c | 50 ++++++++++++++++++--------------------------
>  1 file changed, 20 insertions(+), 30 deletions(-)
> 

[...]

>  } pci_dev_acs_ops[] = {
>  	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
> +	    .match = pci_quirk_intel_pch_acs_match,
>  	    .enable_acs = pci_quirk_enable_intel_pch_acs,
>  	},
>  	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
> +	    .match = pci_quirk_intel_spt_pch_acs_match,
>  	    .enable_acs = pci_quirk_enable_intel_spt_pch_acs,
>  	    .disable_acs_redir = pci_quirk_disable_intel_spt_pch_acs_redir,
>  	},
>  };
>  
> -int pci_dev_specific_enable_acs(struct pci_dev *dev)
> +static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
>  {
>  	const struct pci_dev_acs_ops *p;
> -	int i, ret;
> +	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
>  		p = &pci_dev_acs_ops[i];
> @@ -5481,33 +5475,29 @@ int pci_dev_specific_enable_acs(struct pci_dev *dev)
>  		     p->vendor == (u16)PCI_ANY_ID) &&
>  		    (p->device == dev->device ||
>  		     p->device == (u16)PCI_ANY_ID) &&
> -		    p->enable_acs) {
> -			ret = p->enable_acs(dev);
> -			if (ret >= 0)
> -				return ret;
> -		}
> +		    p->match(dev))
> +			return p;

Nit:
Should we check if (p->match != NULL) like we check for p->enable_acs &
p->disable_acs_redir(). 

Otherwise, it seems like we're mandating the existence of a match op in
the pci_dev_acs_ops here? Today, we just have two Intel entries in that
array, both of which need the match op. However, AFAICT, it shouldn't be
mandatory for future SoCs that might only need a simple vid + devid match

[...]

with that nit:
Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

