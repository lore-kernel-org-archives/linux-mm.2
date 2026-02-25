Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00F94FD45F8
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4086B0089; Wed, 25 Feb 2026 17:06:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461536B008A; Wed, 25 Feb 2026 17:06:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E396B008C; Wed, 25 Feb 2026 17:06:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 219886B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:06:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2BD28C3A3
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:06:31 +0000 (UTC)
X-FDA: 84484363782.10.9D0AB59
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id F3A2A100011
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:06:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LI7Nut8j;
	spf=pass (imf05.hostedemail.com: domain of praan@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772057190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKxFO5jbcj0n3yx3uCDHTRhkwPsNZ/ADjqKpvoexazc=;
	b=Tc4RCqQJVQ0PYRKYqJn0lux6jiwe6NdEbDlwLXySLhayOUhPlaNAlmbxy/i9NwhlIaGdNy
	JRu7EMp8H7IQExT+8+2dsMWR/KtcS2WX3RpDRvnVzUZdc5l0dmCuNPPUga9nnXbfGgJztY
	TGwU15S1iWVo+NuPhK+KcMKcLN7yT40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772057190; a=rsa-sha256;
	cv=none;
	b=jrT5e0VU/7XbkoIX8TE4ldLUUw/LSPi2KrHFrSaKBGTwUxQYlgp1yOS4rthezt6F6kWvMp
	6SDa5fOEqeuxcOQKLJ+j7YPbCZIIA7H0ImITmBi49YQjEcd6+FYuCGVtQf2bFC7oXVSqQ+
	LB8aCRU49p9ThXFOvPHkEDPu7rcQvuA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LI7Nut8j;
	spf=pass (imf05.hostedemail.com: domain of praan@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ada9e4ea32so11255ad.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772057189; x=1772661989; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yKxFO5jbcj0n3yx3uCDHTRhkwPsNZ/ADjqKpvoexazc=;
        b=LI7Nut8jc1fwfR0WAGkb6rRTFf8VKGqI4zAN1AnEM9repobhhcPA/VGbB36Jzy4yKW
         17otl8d1/AzUc9584gP3ihoZPbrZBeqkiiB9f+/UMDpjW4FUQqUmdu9xoMmOvp5KHCUz
         pJVo6UZW1rOpl8BZrVRVx86IhccLLfJEh45kfPIJeoiMkNpFMmcvotdyMxhE1X0RyTlw
         8f9jR4XLzpaoFG3JYSyhZqTwNSYfPfvY3IBsjEycZ1JGkgCTSsjznE7vNSap8d3uqa3A
         yvjSIaLJPk20MtGJkvUCr+6TPPZhGjfrqNo2RaSjC6I2DXymtqqJygMyvlAV9rpSAiuU
         ARdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772057189; x=1772661989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yKxFO5jbcj0n3yx3uCDHTRhkwPsNZ/ADjqKpvoexazc=;
        b=RGXcmue/KQbbl/a4YBcTI9V9Hgy+MtQJRNFt101BsYHFKgI8oIiKdl8B2gZnIomEYg
         ZJrCzl2pLJaoffgpFx6CTjJqwzqUH3yYOe4ghce7bBlmutBZtVEbdAzKqZXHLLmSfiRC
         Okp2iCjhUJOoT2Xe9eBu1zSb+EoVBAQfti8+lsS7VOqbMnnUFFMnClHdGfobFfDUeaIR
         xqkBPjdb/OgKImixxHXNqAsd36Sb7+P6I2cS+F3BAcClP6kZStWmMpUF/4jS8tEolfg8
         Q2EjYYXkPSOG6iSJ1zGEK7KwlaDylDgzVrQerJhrB6B3U+wXdsLhPjIp+hn5pS2YWwXp
         eIJw==
X-Forwarded-Encrypted: i=1; AJvYcCUGEi8ppAd7BqLvi3qcII09G2qe18QOMXagXxGvdVStQl4UZi0wv5Llru0YU2j6dCP58iPivcU9dg==@kvack.org
X-Gm-Message-State: AOJu0YzRutl3TINvse7+6c95IScJcNotGYXCYTH8KbMN/HsZSqCN/eqx
	tnEBy8nSyPJ6bpN0fM9F3bj930WHi9LxPz/mkAtX1N0Q7NiP6lgLobeo+hZFKkMQzw==
X-Gm-Gg: ATEYQzzbf/bfsCdcgsPSdO898STw557osLyXG0Znhceda6Bi56vPSHBm2eFQpbqJ21G
	63V+Vceb5OagR2Wbp8m9UJKkwt9CrSvHGj4SA3b9ZSlMLlEftWpwkIfEi9koZ8k4vapCR5PbeBu
	xmdC3OQiB5VeGo2xsjQloK9gu6g9Ba9HO23jWNdzd2waptVItpPoj7e6KZ8CYg/xFPJkVonKaoi
	qjUp1FQrCKt6u413qbb21MeXqwSdgZcOmAJfrPgmorNpTpsyjNvKathnidhSwxJfuxFVN2QuWN6
	9CYETM172EnHFuX4JAleXcGP2dRKjXa5V/IdFQ9iNmBwC/c1FKxtlxVQ+RcMzDMSsMbGbaDWkPY
	xWvjgi+RF1RWHCMHvwh6QR8q4C1y4/8v0T7NoA8mRTFyXZ7JRnQzf4wGadG4JOTRDia+/c5orIK
	ED8rtkgkpcKEx6fezxbm96jL0FVIxNgQoyqzxry3s07TGywArP5/eEjZ/Me9XEZsZM/1owVIs=
X-Received: by 2002:a17:903:2a86:b0:29e:27f4:bac0 with SMTP id d9443c01a7336-2adf77c692amr672495ad.16.1772057188344;
        Wed, 25 Feb 2026 14:06:28 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8273a05e831sm236247b3a.58.2026.02.25.14.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 14:06:27 -0800 (PST)
Date: Wed, 25 Feb 2026 22:06:18 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: David Matlack <dmatlack@google.com>,
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
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
Message-ID: <aZ9yWlcqs2b6FLxy@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-5-dmatlack@google.com>
 <20260225143328.35be89f6@shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225143328.35be89f6@shazbot.org>
X-Rspamd-Server: rspam09
X-Stat-Signature: bau39y4rss8mqaoz7pnmhmkwtcp4ras8
X-Rspamd-Queue-Id: F3A2A100011
X-Rspam-User: 
X-HE-Tag: 1772057189-884197
X-HE-Meta: U2FsdGVkX1/oIYi987kkivNPXbbGatr4bG/idqk5mX9uU8IPHyA1QvHDlRXRY1qOg7eIaVPwl5xZ2Jx8/8O7DeDCh2wU+dKxuTQYuCMbIpx42HcGIaVYmqinGAC1oLo1FJ8W5uotC+OI/cAhCbZXuXCrtiAnpftOEC5DuAYzphedYSdP9TyJlnOGtWYmUQRhCrCnTFZ8QK7wcN0TmjJfNTxm4nozXlFWT/37pb0fYBKivhHoaL+uWW1UtckWj8fVb41+GIBCsGGlDusg3JbyNtnbUDOkDS4bV1dSop0CxHBe9zZ1PhxxC2K4LL/W3d2Ff4Xb10zON/3K2ucjsLlsAQ875qjYx3L26OfaqEAwHfZwlProJ8wFzY+t0r+S3AdYQkariTDZq1MhObedmIa5fEAnAq09TuHvxfeUgnako2BsTjY+Re/7Jr2ElUDiLb7OjUS8vjejwPDeOMtJPXaqSOTu669h8xSLqP5/C7qQXuID2cYBTPy7T1eSJCiX/651yYLiGY3/wJuLmX5S8BQ7tC+emh5PxBAgB0yGe3ETgwh1FO2hPqmrDNl20iuvSJVSDgjLGmJIL+XsJERRuZmLBX4DGwRoC1zpMdrvkWU24nPHesHsLmaWixAWGBz3E5pniMplt2YkXTFm/YJDiQ0syk3F9ZFrhX8rPUXWEIWeMdy8H33Dl1OdWLJMzALYjgeqynUJV+dnWqHsgxLV7XA4S7xtZE7unbWFlrTjUnDPJmFXS1rXIia+YSJ6T3SVYt9BN2ATvODwKsPrAGQRiL5yezrmvxhcu6BkobsziMNGQaRGoATN/N91joWJYWyjT7yVi+SzL/IAnuL76w+24QQAJfMrdvH2JG9l4Gqy2RFzssUuj/Q9UCuwVEJhCLpnKQW2e8NbGDYM95SkumZQeCUXO1yvLqZUcImrNPHf0+h0tpxVLmf+eqU61xhXrmlsDZEigkikiPaEp35Lip0ZTN2
 pq6Gmi41
 Z0SFW9DDcPHM9dDB0vnJKe7mcUIQymkskccTwE6nHly4eHQDrUCbD05MmPwoCGjgHeN2Ks6Ds4aES+R3kl8d91TQcCo/kcPGXRAQloeiICJ24C3tCzOkXZHhRGwIm0+OCu0uXI0+wvYfx6o5Zg+TW2UhEX9o6KjsFrbxoP16Z8ubiMlvCjWwEBcrZs+/8oM1t/pM6D7nboVyV833FBM195UZ8/xzGQdXIFRE651q1em++j95Ywlt8BQB7s6mskgUEc7g4cCzJRPmU1/TzX+12VyiA17eZpHmluI2QCVVPm/QZ1x4HB0jWHg4BAl1/gt+CoBjoezt+h8T1CLQQd1wQTHa8kiGiiU3Mo8AH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 02:33:28PM -0700, Alex Williamson wrote:
> On Thu, 29 Jan 2026 21:24:51 +0000
> David Matlack <dmatlack@google.com> wrote:
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 0c771064c0b8..19e88322af2c 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -258,6 +258,10 @@ static int __init vfio_pci_init(void)
> >  	int ret;
> >  	bool is_disable_vga = true;
> >  
> > +	ret = vfio_pci_liveupdate_init();
> > +	if (ret)
> > +		return ret;
> > +
> >  #ifdef CONFIG_VFIO_PCI_VGA
> >  	is_disable_vga = disable_vga;
> >  #endif
> > @@ -266,8 +270,10 @@ static int __init vfio_pci_init(void)
> >  
> >  	/* Register and scan for devices */
> >  	ret = pci_register_driver(&vfio_pci_driver);
> > -	if (ret)
> > +	if (ret) {
> > +		vfio_pci_liveupdate_cleanup();
> >  		return ret;
> > +	}
> >  
> >  	vfio_pci_fill_ids();
> >  
> > @@ -281,6 +287,7 @@ module_init(vfio_pci_init);
> >  static void __exit vfio_pci_cleanup(void)
> >  {
> >  	pci_unregister_driver(&vfio_pci_driver);
> > +	vfio_pci_liveupdate_cleanup();
> >  }
> >  module_exit(vfio_pci_cleanup);
> >  
> > diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> > new file mode 100644
> > index 000000000000..b84e63c0357b
> > --- /dev/null
> > +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> > @@ -0,0 +1,69 @@
> ...
> > +static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> > +	.can_preserve = vfio_pci_liveupdate_can_preserve,
> > +	.preserve = vfio_pci_liveupdate_preserve,
> > +	.unpreserve = vfio_pci_liveupdate_unpreserve,
> > +	.retrieve = vfio_pci_liveupdate_retrieve,
> > +	.finish = vfio_pci_liveupdate_finish,
> > +	.owner = THIS_MODULE,
> > +};
> > +
> > +static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
> > +	.ops = &vfio_pci_liveupdate_file_ops,
> > +	.compatible = VFIO_PCI_LUO_FH_COMPATIBLE,
> > +};
> > +
> > +int __init vfio_pci_liveupdate_init(void)
> > +{
> > +	if (!liveupdate_enabled())
> > +		return 0;
> > +
> > +	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> > +}
> 
> liveupdate_register_file_handler() "pins" vfio-pci with a
> try_module_get().  Since this is done in our module_init function and
> unregister occurs in our module_exit function, rather than relative
> to any actual device binding or usage, this means vfio-pci CANNOT be
> unloaded.  That seems bad.  Thanks,

Hmm... IIUC the concern here is about liveupdate policy if the user 
wants to unload a module which was previously marked for preservation?

AFAICT, In such a case, the user is expected to close the LUO session FD,
which "unpreserves" the FD. Finally, when rmmod is executed, the __exit 
(vfio_pci_cleanup) calls vfio_pci_liveupdate_cleanup() which ends up 
calling liveupdate_unregister_file_handler(), thereby dropping the ref
held by the liveupdate orchestrator which allows the module to be
unloaded.

I think we should document this policy somewhere or have a dev_warn to
scream at the users when they try unloading the module without closing
the session FD.

Thanks,
Praan

> 
> Alex
> 
> > +
> > +void vfio_pci_liveupdate_cleanup(void)
> > +{
> > +	if (!liveupdate_enabled())
> > +		return;
> > +
> > +	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
> > +}

