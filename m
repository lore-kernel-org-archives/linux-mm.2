Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B6C0F53D69
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C142E6B02F4; Mon, 16 Mar 2026 12:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5D06B02F6; Mon, 16 Mar 2026 12:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7536B02F7; Mon, 16 Mar 2026 12:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 989C26B02F4
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:03:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4931258232
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:03:59 +0000 (UTC)
X-FDA: 84552397398.04.939070F
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 650AB4000D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:03:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cTyvqarh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vipinsh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773677037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f55pgibkB6ee+8s3SeqViClU/kNvQ9qZ/ylLM13UAeM=;
	b=MRC16ZEw1EbfQqzjN6I3+DceOrjkgP1Q+yhxdCbhcyjEHdTMnRHNmbPDHduWeFKIx5Y0Lq
	7fdhxmGUse3hRKlHz5CqkYzIBDMgEFDvH32ZjTcYDrNxut4mjfQQ1quFN2XteFsjz7IglE
	nbd45PAeG7rj3g5lSSZafh9Rg84kFFA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cTyvqarh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vipinsh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773677037; a=rsa-sha256;
	cv=none;
	b=Z2us1t2TDek90yHX1GgUELxVABTTdT2KntQol+CPaspd8BEoZF7Ca0zDj2xBaHBHMc3+a4
	V/mO8Mv9ZTbB3UfNeXk76DMQq8QbUXHwDyzCgBB3YvFiBofVIkbbJdpQPFE6V6OCCL8FRw
	Dl01d+sFTsbZpUzuqL0wIkmlLtmJFbg=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2b04c9e3eb7so101255ad.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773677036; x=1774281836; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f55pgibkB6ee+8s3SeqViClU/kNvQ9qZ/ylLM13UAeM=;
        b=cTyvqarhCdJgEDylXSzQUTYar8YQdQWAgRhpcevgzMc69IhkYAt6gMtKOr0wEBV/av
         bXbJSdSOr9Nq5IlNNz76VbOHT+AkrxA4f0jyY6UECwuI0CeFTFQpTA3hcmxjhwe08wSm
         sywKIFc0P/YMe49pOU7r5RQ85WOprA6wrV6oQx8kF9nu6rHMSZRjeKyyiNQIEBlePkxS
         fFHnHTPBAsgKALVP3lckePymCcxd3lntflPOsDxqy7uYU5ah6Ujb0jF0NJdvBlH1ptqs
         5C+sIvFalHq5dtRb/Z+27Ws9/a1kY9xBiWoyUiYGzkDweqYYjvgmoBCBDM9DByZ7451R
         oCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773677036; x=1774281836;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f55pgibkB6ee+8s3SeqViClU/kNvQ9qZ/ylLM13UAeM=;
        b=qwS9rhH2dHyL1jj3ifs9pW5fzzWLsnf8C2Z3EuryyCBAzog7hq+ordGPqiwQmrqORX
         +Fh1+ZagD1kZQ0CAnqU4NRT0TfuVSDRZ+Z8yXIRibkZj3c04m8X6l+zrfgEoc2kc1aoe
         KEJUCEUKfiLg9XYldnFrV9wQcysm1X/fH8KsBSsAT7xr9I4EPFie/AClJpTMLqmbD2Hd
         Pek4wf11WX9ke3au8m8TBIVsDQ3GR8yLFqaqAhCbA370N44jVPZxFM039Z+ngSl96VkL
         5boI0ltybtNs1FPjTcO10dlPaErztcov6kOaBPz+GKBIA3Hx2CcN8n098m/Jm2970HdJ
         NUKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUt8DkUxgA3NPOQ20v70+CLK0kBbBb6fqSLpA67LiBYVMSVRuipTlecaEK3eO2SL6RI7GZuN19qkA==@kvack.org
X-Gm-Message-State: AOJu0YyBPtS2GNq59Ko6fMSGIwQn+xikRIBJEJ0+3S3SxlmVGfD9/n84
	MQ/FZPWTccJ9W3BtMJ1KLWg+Y43wjGbQXiaWSgjytNpjqBIOevXplNP5VsjoHPe6DQ==
X-Gm-Gg: ATEYQzyKLyHwr1pGGK+QbTt0rISUoTIwW8sAvutEPgkVpXDQ39Ea8FyUVWQA7X49SUo
	e8jKAvRhuFodLjXRKM0Vm0EWMNCuGFYHuVUp/6mxBueMwkKi1Pejp5zWf2qg4RYJsbcnBadsJKd
	XL//rWPw9vzXjcAdc6tyqhjY9JH3LD8FJGQC/4Z4GZ1joz8tcsXcWOFDRIbh688R5hx5M4gL0I/
	+HNToZZf7ryUYNAsMH3j40NwmcfsJMOZI3CbxN9ik2NS7PngwSEz4jn1A6L1ennDoqvRrIbNjg3
	PJJvSUhL0NFx7INrB/UMqL7VL6VvstQC0WI+QDacmL2WLMjWjgQqe645u7VUJai+8NcZsoeB2qN
	A/D/PDZSZozI8mqfa5eFUnvdLAJYAgJSmsZnCJ2pnSgZHuYYZsUkK9uo6ysD01gj6QeoFypEE26
	VWN+xO1i2brZw2d8VfQidleT49B0xjnCHTLjzLv1IzGUOAkUCQDBjKBa2Lgg==
X-Received: by 2002:a17:902:f54f:b0:2ae:d10c:6382 with SMTP id d9443c01a7336-2b042102968mr4463575ad.20.1773677035489;
        Mon, 16 Mar 2026 09:03:55 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73eb9966cesm9261411a12.10.2026.03.16.09.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 09:03:54 -0700 (PDT)
Date: Mon, 16 Mar 2026 09:03:50 -0700
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
Message-ID: <20260314061747.GD4177610.vipinsh@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-8-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-8-dmatlack@google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 650AB4000D
X-Stat-Signature: 79o7wf7381honui7aaqfbe4t76rewuwp
X-Rspam-User: 
X-HE-Tag: 1773677037-657015
X-HE-Meta: U2FsdGVkX1/EzJLNMKSDXa96OzpE1flfMh9s9lfMT0A49jKAk+baYD13tENmFZ7g9A+fiTx/g1Pnw4kUc1IqkbQH40qOFeV7cgUCrR9xtrlKwPbqRs5QOgMyicxv5WvNmWdOGOnADy5PsZouJl2LcMZU7EAT2Nv3LmmlqHpHmfB4FHkmXymX/CLwL4YGAjTmQfyWxKmHhdqk3wP69tKL8ZTgzIFrrr7VCuhyz7cVjqaY0z8szqIJzjniTQAAeZ0mePNolLR0W7oFpG3B3jNe9yWjAc5NKnDONCKjQGpDsg3tnCia9w7P4f8GRIfH2/UXNeprb3LtISfOg5tRQ0NEvd4nW0y1RYFwCKo7zBUS+iH3+DNEWz2G+4J6/qdiUkLKwUE7U5zj0Lr5IRlpPhaeKY/UE5B7zsAANEsqBECudR1kMTjzxopQ/e0ibiGFx3VOZuSh1Mc4cG8R7g/HMd8zNupGpkic96qrS2GTLNqty4BRnrp3lwAdtwDT6AMxT/SpHUNK4A9HEp3QHO7NzQeuNoxvIX1kIKONeUH708uEVhh7GIq2iYRQUfD5KXuXuuuvEQGF3+2jt8lHgjvDz/vH6zNmp3FGv4ElV6DYWBbbqTlS6c/QV3FirpzXpqKtezDyXMio8dRR/1Zsi+OVzn7j1P+7A4KHysTo9YlBQofxYQAEJSpXyawojkiHYoySa4WnlUzk+iCOdkOgaw2qX9kEuVsBj6cGcR2d+4nDoH4QQ5svFWcLiNuJCVHtdoC0WNfEXLmd6VJ+vdqas0hZX3ftUF0dD0n4u2DtKf+r4OD4uDXBI7IXX7fSkAIbPBu04F74S8v5hlYP4El8flE6HIWIn/KMMrMFUzacxQxmET/wF783KmrmZI/1sYiJjf40xi3oQuXo0DFtecqCtKd9iJIVdqp74Ya8CZhzEjUq+tgpGNZ57vWrFRwqr1qE3ycwaDenCsWDRIPJ5S3loMcO2qx
 2kmjg8UI
 iTp3GkN+e/Mqsx+C3y6/EbL4paacXWMLbJiXObFIE7XQZKTbACWibQHnRE6HcHq4/BhCl6fDiwiLLKFOTaXIBliv4W78BOgrKYgBid01N8ib7zPk7JfMNOcBHW7eLUZwiO1FoZNTGclUzCOQKNLOANOa/Hh/dSOM70sWZpbqoTKkHW3ABZrTmyBBODmJJlA5wsbTP4qb0/X3BPNaN9JYweZVihGyN9YL+7jXZvbwQ7cBDhS7+cD2A+uA7jiZv3VkqjlpMMq+kJC1QUono1HtNomqRf5ag3tpOdcKjA+Gr93zwTVK5gFVyvq0jRWDj/0BkV32NLrwVQecD+0KgmMl5uKHf8n1OHUA6IRdgUZc1xchsVM14AG8wQBZiDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:24:54PM +0000, David Matlack wrote:
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -192,10 +200,24 @@ static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
>  
>  int __init vfio_pci_liveupdate_init(void)
>  {
> +	int ret;
> +
>  	if (!liveupdate_enabled())
>  		return 0;
>  
> -	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> +	ret = liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> +	if (ret)
> +		return ret;
> +
> +	ret = pci_liveupdate_register_fh(&vfio_pci_liveupdate_fh);

May be we should rename pci_liveupdate_register_fh() to something like
pci_register_to_liveupdate_flb(). In the current way, it is confusing to
why same handler is getting registered at two places.

Above name will also make it similar to IOMMU series as well
  https://lore.kernel.org/kvm/20260203220948.2176157-2-skhawaja@google.com/

