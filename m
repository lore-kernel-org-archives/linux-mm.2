Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E64CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6139A6B0005; Tue,  9 Jun 2026 07:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E4416B0088; Tue,  9 Jun 2026 07:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3246B008A; Tue,  9 Jun 2026 07:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8CB6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:15:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE0BC1404E2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:15:15 +0000 (UTC)
X-FDA: 84860117790.17.CFD6BC4
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1C0B9A0017
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:15:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="iD7/AOGY";
	spf=pass (imf15.hostedemail.com: domain of praan@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781003714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIwRB/fzX43FvZDy8zd3F8cYltlmCTKmqxv8mTl/pb8=;
	b=JgaP2gAKlcBFHnuxTc3Kk4o4PB1UCTUKIwhzJ/BiSzM6hQsh5P4qQ3hLW9SvO6Tb+iAiCx
	xf2BqR/e8KI1eeHPkxNooiYDUJdxmG0u1mtFtAfFTOLrFiMky7hmQvRMDl9p2QcHpDVDLl
	I5xZwn8F+3PgbKGTLQC8Uizm62t4mvw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781003714;
	b=njZiVGTXc4J6ElvuoBg42e2px4s9NlEuOLfgbKVD/c9H9lqTanSGMGAeSPU2I0HTqmbj9B
	7jn0PefAakQU1XjQ3Q1r27P/18XT0qVHtCNYEWPwWeFNJnvXrsWSfe/g7Y0CWRQ8EBJWvQ
	bSvEVbyXjF0PXgoupm2iFAzQXCFgTNA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="iD7/AOGY";
	spf=pass (imf15.hostedemail.com: domain of praan@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2bf2d865383so436895ad.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 04:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781003713; x=1781608513; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OIwRB/fzX43FvZDy8zd3F8cYltlmCTKmqxv8mTl/pb8=;
        b=iD7/AOGYaT7YYhwy1xLpymVZd/wMeoT4ZvBe1a/ZrQ/SY/xkek3Hc/Q4RG0cfZtplU
         guT85hScoNs+U4FHsHbJfUxMJ5p+8AzmzZZV8MEOnH7742AZR/wN+/7hGCZYmDVgcpHI
         T3HydYVBi2TJn2ukq+laQkf4Fnu3Rj7ysaIaogbBVMYH+gVgOQpmoiMGLj3qjaI5UxQn
         zMiDjF+qb7RnDFpAkeRgz1FaRkHaDQW9ErAT3LIMJpB07M5qGHirzIyfaQXRXAMXmpDp
         KjBBmg/tZB8d8vb0rq8jGO7v3wATL0Wj39+d7QNc4NDi3dBCs6Rw0kLkkfVX+3f97SfT
         tLfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781003713; x=1781608513;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OIwRB/fzX43FvZDy8zd3F8cYltlmCTKmqxv8mTl/pb8=;
        b=FaocAtA7T2faLXwbMebUILGC7gEduVu+hfdeg8MlFthiE54wb3G8+zLuHkbtWzWG9c
         ZwMtyNWDpciT+xlUSnBOnnlAz+OZ8bCo6bmqtIvwezK4m3DEjprmFTYrOP1qI713sGuy
         v4Eg6GftvwUONcxbtJEqmnK0IEV6HtyfqiBMwnhQ4amN3NAWsp6EGnfQfI4vSawgYt9f
         IaxgbHqEIJWudY2UoldlMb6Glw5brqv7azmaUrsAERft8loVIPhHSDvbbT5XfAsHeY2t
         ChtjBAO0/c0RYwnQYyz6lSG6tdMv6LJKG57DwlZe/bjCeMezdvkqOucuhoCZne9952uF
         A7Tw==
X-Forwarded-Encrypted: i=1; AFNElJ8/McStPDKp0zLEv66PzmyUdC0uNwOhhDprDCHRgEr8jhp4teATuXvcACrluhpCw3013ULWM8tGGw==@kvack.org
X-Gm-Message-State: AOJu0YzPdF1HagJvMnWMQfRTTl47E2H9CmeTQdCygp8AOHr61KIN3HPp
	pTe7+0o6DlnZL6nwwB2qcy4XO/lGckICUR5vdMluJiVr6O8K5nefMRN43vTYGgeB3w==
X-Gm-Gg: Acq92OHvBI0NrQRaPOj09z7TIMa5268WXe3sKz4/h5azO5QTNWOHmmVUVE9TzL+Ha//
	sQE6wfPZSY4xJnEyR7b1QJNgF0rwY78UzqfAHm/xuiMW3PCqjsSgKTWdMF7Wq1sJRMsVBgfF7Kh
	PwnpdjbY4wwznagxSDvdb3uafkVz1Q1mDyH3oBEvi0OXTgOrzm9FxsMg3c3o3sd3sSxKrlQIqMO
	5WZbsXERduxvNQSNnuQrkLhNLAsdhcA2hwMADMdLBVqH2K/pCcqMeqdVQygkJpN6LUgcvo7qT9e
	FCpHMyMasvJzqmlUcW9w66uEoF8PkiFQRo5R+JtPV+9cs+H7n30CdP/cB2XMUc/EpHmFhLvSd3d
	ChzCXfckd6USAy8elesnRSMZHsQeuXInkt8s3Jv8EbKZvPAo6Ybp77oOesF1LHsNn8VStbL/Ts6
	OrFkjvYQ2o3Fw3h3XXuhVmDi0j+yQHRHB0bvaffVQ4GXQ8Y7K+B8VPavC0GH25Y81uooH8yuM=
X-Received: by 2002:a17:902:ffce:b0:2c2:50c7:5894 with SMTP id d9443c01a7336-2c250c75a1dmr4219375ad.24.1781003712132;
        Tue, 09 Jun 2026 04:15:12 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6d109dcdsm21430052a91.9.2026.06.09.04.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 04:15:11 -0700 (PDT)
Date: Tue, 9 Jun 2026 11:15:02 +0000
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
Subject: Re: [PATCH v6 06/12] PCI: liveupdate: Auto-preserve upstream bridges
 across Live Update
Message-ID: <aif1tq8TvHuYwUC-@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-7-dmatlack@google.com>
 <aiSb85Ec6jW4xPaE@google.com>
 <aic1gdmisIT4sqEN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aic1gdmisIT4sqEN@google.com>
X-Rspamd-Queue-Id: 1C0B9A0017
X-Rspam-User: 
X-Stat-Signature: m149a8rqcd1yb4er4szm7jnn8ct9krhe
X-Rspamd-Server: rspam08
X-HE-Tag: 1781003713-474188
X-HE-Meta: U2FsdGVkX1/AjhlLOYCF0pQdfh1trWcen1YuPMffpi1PFoyfXsB2eJcC3P9lusWX4MRKqZli+AJrRet57Mfyp+ZCmtSZCV/wmQOch2FbPQtoqeqtaQdQiOTa8rRg3fW1aG9CF/KU+ABgQSOIzPUT6XBgy2USY274nFUBRhRpqbwDHQf783keJk9kOmTnbYnQIboqOZrRjbP0theMyNFyKv7NfZoATSr9evIpqUdEa724H1YKuv49jflq3HBbArMzHsExCL3wV+zb96o0SIwsX1R4GLooYc7HUskiZit1/yLVWIe6Nv1cq8Gr8jGdALlv0kOgiahF4nrh12kszrbWCn/e2GSGdp44YbNuj1O3KuNZodfuDRG3r3N4ERrQRPLudr56Viy4qLQD9WXY0qr7t/M4hqENATnhxEEYQr6H+VvZJ2zUuZPaX2hz6e2fMtZDJk7h8FN7lBXHn2N28QZCf5kXCqPjI83RuW6t3xQr5X/vU9VamqLhfWlY4Xbq3rwG3Pbxmb1pqiQWTPlLXpdqUUADv39OoNiy21wY+cqh4qFXDlmLhf2q5yl18FTpf4tNN5RWY4hBxzJnJQVP+1nAJ8kpbviZhDUPG2eHNxMI/RWun/KC7JNgtemGxfKtt2iSksVF0up1R8tfyF+WIxywECnmJIDajiNe9tnv+cAJFY6o4kTdueOxCs6DVU/g464kqJlWSs0OeKcmEDLXlmqVjJ+VNFypq184bx0zj2+do8fqF8Zv9rb0LIGWOXJmBsiFhq8X5UPqf8FXGr8Tupof4u6hsUaLinEIq0mK1D9PPOIhYQb9rtsvPPOT4KpKhMEnsTe7AyHfhNXsG7rZ9kg1jx+uD+ivHuk3+bTROZgpowoXcosA0JcVA09YwZ8cgyRsWOXq1X8pD+4VqF/Q3gD+CtIH7rTyjUCGpiXzpv4Qsytq90dLFRewS34kXbtAa3rJUldtPwBQOvIP7DreifN
 KmOUuTnw
 9mwf4+vq7EdwKG08ycC98AE2HQHdOE+PAe/P4vOO/XipkMO15A+hldrLgZss1Ksqem1dsdWedwD6lWRIOq9augrWhwyaaQIU+7AqcbyDhQldXrx/tY2F8vCx027tih+5wRVsGOPMzHjbgD2TowP0wlNubUio+lvhvRJxjIhyN5ZX1F7eFxVqgD06ymRBbsQ+Boc4+3lLb9ehuGEYUDlEV1tps9n55Oi2wz1GKhlv1AxLV5T2XaCnzGKhS+SP5ehWyeP+2DGBHnkQ3R7y6cmqgot0RmwGMkwqFrUmr+AKMGzKtFhYevqpoM9U96mG+CjieQ6UwpNZz6KBBiNmLCKKAUFM+mTHA5K0nYOgC0/926n9CE9d+0mB671Q5vnlGn0TnNUZY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 09:34:57PM +0000, David Matlack wrote:
> On 2026-06-06 10:15 PM, Pranjal Shrivastava wrote:
> > On Fri, May 22, 2026 at 08:24:04PM +0000, David Matlack wrote:
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
> > > 
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >  drivers/pci/liveupdate.c    | 136 +++++++++++++++++++++++++++++++-----
> > >  include/linux/kho/abi/pci.h |   5 +-
> > >  2 files changed, 122 insertions(+), 19 deletions(-)
> > > 
> > 
> > [...]
> > 
> > > +
> > > +#define for_each_pci_dev_in_path(_d, _start, _end) \
> > > +	for ((_d) = (_start); (_d) != (_end); (_d) = (_d)->bus->self)
> > > +
> > > +static void __pci_liveupdate_unpreserve_path(struct pci_ser *ser,
> > > +					     struct pci_dev *start,
> > > +					     struct pci_dev *end)
> > > +{
> > > +	struct pci_dev *dev;
> > > +
> > > +	for_each_pci_dev_in_path(dev, start, end) {
> > > +		if (pci_liveupdate_unpreserve_device(ser, dev))
> > 
> > I might be reading this wrong but are we leaking some upstream devs if 
> > an intermediate node fails?
> > 
> > 			  EP0
> > 			/
> > Assume we have: RC -> B1 -> B2 
> > 				\
> > 				 EP1
> > 
> > and EP0 & EP1 were preserved successfully.
> > 
> > And then we try unpreserving EP1, we follow:
> > 
> > unpreserve EP1 -> unpreserve B2 failed due to a corruption.
> > 
> > This aborts the loop, skipping B1 and RC completely?
> > Their refcounts remain elevated, effectively leaking them as preserved 
> > state permanently? (i.e. if we unpreserve EP0 after this, B1 & RC will
> > still get preserved).
> 
> Yes, but that would only happen if there is some sort of kernel bug or
> silent data corruption. I guess we could proceed with trying to
> unpreserve the bridges upstream. But I opted to log a big warning and
> bail immediately.
> 
> pci_liveupdate_finish_path() has the same behavior BTW.

Fair point. I agree we are in a broken state if we hit this. 

I was originally thinking of a situation where we'd want to keep the
failure localized. For example: unpreserve EP1 fails -> user sees the
warning -> resets EP1 -> retries preserving it later. 

But given the recent discussion/decision that retrieve operations
will no longer be retried, I guess there isn't really a use-case for
retrying anything. It makes sense to just bail here.

> 
> > 
> > > +			return;
> > > +	}
> > > +}
> > > +
> > > +static void pci_liveupdate_unpreserve_path(struct pci_ser *ser,
> > > +					   struct pci_dev *start)
> > > +{
> > > +	__pci_liveupdate_unpreserve_path(ser, start, /*end=*/NULL);
> > > +}
> > > +
> > > +static int pci_liveupdate_preserve_path(struct pci_ser *ser,
> > > +					struct pci_dev *start)
> > > +{
> > > +	struct pci_dev *dev;
> > > +	int ret;
> > > +
> > > +	for_each_pci_dev_in_path(dev, start, NULL) {
> > > +		ret = pci_liveupdate_preserve_device(ser, dev);
> > > +		if (ret) {
> > > +			__pci_liveupdate_unpreserve_path(ser, start, dev);
> > > +			return ret;
> > > +		}
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >  /**
> > >   * pci_liveupdate_preserve() - Preserve a PCI device across Live Update
> > >   * @dev: The PCI device to preserve.
> > > @@ -321,6 +403,9 @@ static int pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev *d
> > >   * pci_liveupdate_preserve() from their struct liveupdate_file_handler
> > >   * preserve() callback to ensure the outgoing struct pci_ser is already set up.
> > >   *
> > > + * pci_liveupdate_preserve() automatically preserves all bridges upstream of
> > > + * @dev.
> > > + *
> > >   * Returns: 0 on success, <0 on failure.
> > >   */
> > >  int pci_liveupdate_preserve(struct pci_dev *dev)
> > > @@ -336,7 +421,7 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
> > >  	if (IS_ERR(ser))
> > >  		return PTR_ERR(ser);
> > >  
> > > -	return pci_liveupdate_preserve_device(ser, dev);
> > > +	return pci_liveupdate_preserve_path(ser, dev);
> > 
> > Minor nit: I might be too nitpicky here (and it's NOT a strong opinion)
> > but naming it pci_liveupdate_preserve_path_for_dev() reads better to me.
> 
> Noted :). I'll keep the current name for now since that is pretty long,
> but if anyone else votes for it I'm happy to be overridden.

Sounds good.

Thanks,
Praan

