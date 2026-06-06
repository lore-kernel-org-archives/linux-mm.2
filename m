Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BB6CCD8C88
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 22:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E840C6B0088; Sat,  6 Jun 2026 18:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34BD6B008A; Sat,  6 Jun 2026 18:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23526B008C; Sat,  6 Jun 2026 18:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0E926B0088
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 18:15:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 491E2A058F
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 22:15:29 +0000 (UTC)
X-FDA: 84850895178.21.129C6D1
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6F2A5120008
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 22:15:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ovyQ9F/r";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of praan@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780784127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYxfXn22R4rSEp+91VSc3le3ou2J0SQ37n2yrmKjM2Q=;
	b=IDnKvTWhu1KGBeN7zq6c0GR4xOKFsK5SpknTimjkfOU0bXTG3O8m3o+ylDhM/jAo6p5Eaa
	lWK0W2kGtV7CKYHaaeqDAjSTckjKrb6xOs3DIYyKOz4vZ88SdDQp3yiWMJVvQlNOIPBxvf
	Evv4RZRJtllcMu3Jy7qBfDPPxMbTYe0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ovyQ9F/r";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of praan@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780784127;
	b=j4Aw8+hLVVyW3mB6Q/dCwteYip2w3Ui4rQz7eTC7BlbFIco62vMt2bNO+td5U8UKZ5hj70
	+cpuYdy/Nv1FKk8KO/9jtShKC8v1ez8UC4hDvLaZI9HKzfBWhnEpuJhDPfT2iKCk1qol/O
	HKNA2wagNsQNt+jB8gCrP6+uOpJ5U0A=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-137ff9a7d5eso18361c88.1
        for <linux-mm@kvack.org>; Sat, 06 Jun 2026 15:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780784126; x=1781388926; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LYxfXn22R4rSEp+91VSc3le3ou2J0SQ37n2yrmKjM2Q=;
        b=ovyQ9F/rEFNvm3b+QGt6KckNHYXPOgF0kzD399hGp84k1NULBSQShzBfJ6eqifiEmw
         jH+x7fFwnBfaSoKv0jZwivSezbNW5UGkawC0PP0VpePwkf09PV2go0ZrcT4MEeLe8Mcd
         GgVVZG2qLu6wIwhB6T/NsiXQjex4aQ5QBHwkaR3gsf47AVtWmToh3D1vTy7FOnsHpGjU
         2bspgZc9H5AQRRQHrWVT575OghRJJjMnp/TYdpNMRlTk+UXyHoUddUzUTK2lZ7uBTgoQ
         L1N62A0/Z/S22+M3k4daTn3Pjw8AL/mCOtR1n2/RMHKsCV1XqkPMJWsD5Nx9zbR3/nfW
         VQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780784126; x=1781388926;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LYxfXn22R4rSEp+91VSc3le3ou2J0SQ37n2yrmKjM2Q=;
        b=tUxDtKK9mLuLiWdJrZO2XoroWAX9oSrCj29Nb3rMRykRRa7CYBfiyOqDTvwpSf/l3u
         L6KY8CIPq7ZU+nbcJfpufldhB9KWE9//pWFLBviP0O4HC6Tz2Wm2vNQMjJzVv7byNRB1
         PmzILRntRzfAW/bjK+Q2nDhwHVYuy+91jJ45JuxdvYyBz5fkothuAUIOtwNO4rmkr8/k
         kmuKKjsR7rZ0SJ9RQtlwFwE6z/QIQLLvnQ+mnosDa8m6IlkSIwp9nT7tMmY7cTMJ5UpJ
         +r0tMXHwYW7uffj9qa36qlc0N2PfwYT7JlwJgSNqCMBlMNXav60RB2XGdDpPZdsBOMu0
         e6XA==
X-Forwarded-Encrypted: i=1; AFNElJ9Q4oQMxqe1TCxmkpBk0nZ6iBn7SoZEaFyqiKFNRhmMtnEu4rYdZo38fQhu+oLYPWWlplmLpLKHQw==@kvack.org
X-Gm-Message-State: AOJu0Yyb/cTVjL3ISEh6ec0TQZB6se5r0Nxc8mAPzTVrszhVfPkkQY/R
	sxF1PBOrg8BY+RyYtvAbKOgVVXO8rhHeaGgDCl4Qy+UvDASfmMqOqi8v8KTq3aKUeg==
X-Gm-Gg: Acq92OF0lHa3UZeLCq8BhjrlZYHHgesWwE/FYUEjcsaa29BvzOMp5VeZqPLw1ZenQV1
	+CP8C7iHFf7yoU+S/Lm6LOQ5yrba2Q0hklgSeExNpTLYa1L+Pllgbfc8PF+J33y3JQmvBnwVALx
	AvFrxv74bTzCZr2gLJaFaJ1INsBiTyFg0Jo5exjjvPW/SxMGBMjQJwuuueeZ3aisGSLZbKBnrLC
	vdhBfufYv3T5TChA4pwdjETIryIHOLhJSLELK+fJpPZhoap/fog2U/C0DgLLCluuHRG5r0ZzBr7
	8qAqr2XAXuPyn9iv58QS89jAerE7a7xKEZnW12VTcONtV/KEN3xfQjmsPwKBShK57SR3INw+LZ4
	3askG9heXzUIe3vpzIzEQ/Fba42ao/XCa38vFIsMpAE7npzmoOO0kMaa36PaJjtjquraohO3J3u
	mXF1opffIgMUBauULNUgI973LZ/iAD28Jjm7ZUY4jSWUElPhq0C/a3bQU2XSYJlBrrWenZ9eU=
X-Received: by 2002:a05:7022:12b:b0:137:dbbf:db2c with SMTP id a92af1059eb24-13807bfbad7mr235639c88.5.1780784125379;
        Sat, 06 Jun 2026 15:15:25 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074df75ff6sm12469930eec.26.2026.06.06.15.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 15:15:24 -0700 (PDT)
Date: Sat, 6 Jun 2026 22:15:15 +0000
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
Message-ID: <aiSb85Ec6jW4xPaE@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-7-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-7-dmatlack@google.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: bmsyk4mekbgxiewbyd4khi1azznnz4px
X-Rspamd-Queue-Id: 6F2A5120008
X-HE-Tag: 1780784127-199680
X-HE-Meta: U2FsdGVkX18qWt34k76NRPO0W9/K6P6MfbPwbh1b/9P5YisFnU+WL+GknZ1W3HF5k6/8Xp8MnpPNHrUpfAuh6ACOITNNSIuRw6jF1Lsi1HGdeNm0hfd6XkXAMRma9O1ZiaShbXKdAiOx9wdbcVndGifbQbyPMmNKpSfBmg5rjmuqP0tydjdNffmBN2DahBYvrQLqKyHPFtrb7jhSA8R6/XV6ssrpsyl2xnxYG0zwfmYlTP7205lna9jCn3enAD41n8cDXuKZdtH3VV5rrXJQQ299FioQ/xuw/l/k1EqLP/6UyHHZ9e4w4Kv7Cx1UnHjDTbAbTfvU88BgTgOhrzkb2ExHJ1B0KhxDu5p8IYohCxmEJLricYbAIJ1QBsI6QB6SvzVSSWqXHB5icjEDZR6I35+7OGvSLUW9BbzzO1TBtlb2RImaE2m0aUzY9EC5muJLPxO/yZ+sbVAgLSdIfsZxWpiPyk1y2o6vbCpGQjyNR/E0hvGyIWqEyeFCVT/h0YSHvcbk9z+Xg0cxiPVTZ+Vaf62eclgZxJDLF4Os6HXM+jIkymzFJYWdgi6tNh2+MiNVY6M2W+6+FZJpWL5XFv6HTiAdzqrOsZih5lWo+eOhzSpalhAoEGssWecSenmty3bVOZtIlPiecOC2wDOhb+mi4fPxoN6zf2C6CQlk/Pxt/lJhyrW34sDt7fsLKUnnUDUahU9svtZh8r1X9o/PR2EPkIIKmv85Vytu/UhJrlU6YWvlEav3GA613HQIYg+HuLe/v0UEhH6IYJhkq0iz8OK5X6RnBMpCJ+Loc0CwHcPtkOQFxF5a9uZ7+CtxX4X5xina7vftdIGDGf5SuTxq2sYq9WIHdW03GItQMrd3AwMDyU4WyCYUVAUDXiIsmLtxsPg+8Je0w72uDzFD/mLyZyJPr8gUQ4av68mVdcOU+/DjDC1YszAj05L4DBGWIkDy6ZIDo6AfQxZuQ/gs1Evmazo
 LGl6/cl+
 S5DwCea0hFgjcavroMduTm1dOXMz0OpKaC4S+L9U+eVEEjTDBTXqjsTGrOz7MLKebnf6mxTPg2rvEz1xZV4cUGNdFvgLw7LsJ8wAfyB3NaTCcDWAsYpvAZIFZuDy+5IU+HgpEeMCLKj35dhXM2DOOPG94Xr8F2mpNgILcYvKlpY7lr4wzHkfxyo1E0TrWQg43rrArkD6RXiNdX4sS1ZweppUDy1GNtqPE/Jj2yZGycMgxNKZybZs8GFew/FA8CaLz/22ZIQa0QYdSLRaJwVteQMuoUmJR2o9+2pWYtVO69X8DDxoj1zFmlpKLrj/8hks543waI88vUTcK8DTohxXtvH/M7cTaM/ynXM50n1LtgyxhTrqS6Zlf+xmfU4Tz654FN64/CcvEPKTA8KhHKF+8mObkrPVuVOEg/vIPETP9AyefbVX9YRNOvPA3/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:24:04PM +0000, David Matlack wrote:
> When a PCI device is preserved across a Live Update, all of its upstream
> bridges up to the root port must also be preserved. This enables the PCI
> core and any drivers bound to the bridges to manage bridges correctly
> across a Live Update.
> 
> Notably, this will be used in subsequent commits to ensure that
> preserved devices can continue performing memory transactions without a
> disruption or change in routing.
> 
> To preserve bridges, the PCI core tracks the number of downstream
> devices preserved under each bridge using a reference count in struct
> pci_dev_ser. This allows a bridge to remain preserved until all its
> downstream preserved devices are unpreserved or finish their
> participation in the Live Update.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/liveupdate.c    | 136 +++++++++++++++++++++++++++++++-----
>  include/linux/kho/abi/pci.h |   5 +-
>  2 files changed, 122 insertions(+), 19 deletions(-)
> 

[...]

> +
> +#define for_each_pci_dev_in_path(_d, _start, _end) \
> +	for ((_d) = (_start); (_d) != (_end); (_d) = (_d)->bus->self)
> +
> +static void __pci_liveupdate_unpreserve_path(struct pci_ser *ser,
> +					     struct pci_dev *start,
> +					     struct pci_dev *end)
> +{
> +	struct pci_dev *dev;
> +
> +	for_each_pci_dev_in_path(dev, start, end) {
> +		if (pci_liveupdate_unpreserve_device(ser, dev))

I might be reading this wrong but are we leaking some upstream devs if 
an intermediate node fails?

			  EP0
			/
Assume we have: RC -> B1 -> B2 
				\
				 EP1

and EP0 & EP1 were preserved successfully.

And then we try unpreserving EP1, we follow:

unpreserve EP1 -> unpreserve B2 failed due to a corruption.

This aborts the loop, skipping B1 and RC completely?
Their refcounts remain elevated, effectively leaking them as preserved 
state permanently? (i.e. if we unpreserve EP0 after this, B1 & RC will
still get preserved).

> +			return;
> +	}
> +}
> +
> +static void pci_liveupdate_unpreserve_path(struct pci_ser *ser,
> +					   struct pci_dev *start)
> +{
> +	__pci_liveupdate_unpreserve_path(ser, start, /*end=*/NULL);
> +}
> +
> +static int pci_liveupdate_preserve_path(struct pci_ser *ser,
> +					struct pci_dev *start)
> +{
> +	struct pci_dev *dev;
> +	int ret;
> +
> +	for_each_pci_dev_in_path(dev, start, NULL) {
> +		ret = pci_liveupdate_preserve_device(ser, dev);
> +		if (ret) {
> +			__pci_liveupdate_unpreserve_path(ser, start, dev);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * pci_liveupdate_preserve() - Preserve a PCI device across Live Update
>   * @dev: The PCI device to preserve.
> @@ -321,6 +403,9 @@ static int pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev *d
>   * pci_liveupdate_preserve() from their struct liveupdate_file_handler
>   * preserve() callback to ensure the outgoing struct pci_ser is already set up.
>   *
> + * pci_liveupdate_preserve() automatically preserves all bridges upstream of
> + * @dev.
> + *
>   * Returns: 0 on success, <0 on failure.
>   */
>  int pci_liveupdate_preserve(struct pci_dev *dev)
> @@ -336,7 +421,7 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
>  	if (IS_ERR(ser))
>  		return PTR_ERR(ser);
>  
> -	return pci_liveupdate_preserve_device(ser, dev);
> +	return pci_liveupdate_preserve_path(ser, dev);

Minor nit: I might be too nitpicky here (and it's NOT a strong opinion)
but naming it pci_liveupdate_preserve_path_for_dev() reads better to me.

>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
>  

[...]

Thanks,
Praan

