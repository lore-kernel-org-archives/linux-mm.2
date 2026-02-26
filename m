Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08490FD9E20
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 23:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3076B00B7; Thu, 26 Feb 2026 18:04:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632966B0184; Thu, 26 Feb 2026 18:04:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5359E6B00BB; Thu, 26 Feb 2026 18:04:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 39FC16B0255
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:04:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 573F38B5EF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:04:04 +0000 (UTC)
X-FDA: 84488137608.11.DF41A83
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6D6D080012
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:03:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=pSKbpMBh;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="i tMG0Kr";
	spf=pass (imf02.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.142 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772147039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMLSS/6smhC2Fkh6khLdkEUEvv92EQDMAOVxu9hbY5o=;
	b=aiOD3QkW1zJlCPLmrFYQGAqHwxkvLa6GohjUbQnK7AWuvd3xu81ZIPOTwIgPfmqgaUpIBu
	EYGJEVmBkceg/VGEOdx1wbgAHzYdUjF0UNKa0LIKoK9m1hdj+vr5LN1ervMOSdHGf6jt6F
	pDBHGypuBNov/5YA9LIHkMyJBoeN65I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=pSKbpMBh;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="i tMG0Kr";
	spf=pass (imf02.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.142 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772147039; a=rsa-sha256;
	cv=none;
	b=SMgJiUw4XziQllGbC/daVJ9Y8DTUmzLIty08AF6IeVxVlWi7O8iT/68kZg59dUiOoVX1pj
	H+IsRDkBmrlYvR0VA0Eiegm0cgG2iLp8dFEUVnZqVl/rdlpcEcqk9IkN07JTlQlIzOLNiK
	dxoqXAIuI6oOGvHMqdOYGVjfz8Afn78=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 9F6221300BFE;
	Thu, 26 Feb 2026 18:03:57 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 26 Feb 2026 18:03:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772147037;
	 x=1772154237; bh=nMLSS/6smhC2Fkh6khLdkEUEvv92EQDMAOVxu9hbY5o=; b=
	pSKbpMBhjVCNUqBlCA9hD+PAOyjdKGsoXuEXpVYWW0tdWld7U/1w1NX2PmYBh/xn
	qo2DILVymgJ+aXiYyMFfT3jnhkE9B7opsAdiff9avzGjM/MXsGpc00dpMnvZH+v2
	+al57pngO7lZrPYnVu079A4SlbDzeFovpGchCvHqGWatoVsPVl6RrPEzl+P3nCb5
	oE0L2NS15px3cyVh5Qcf604sfEfRvQgZRC6Jb9ntHnIE5TaafEm1E6XlmLPIfc83
	f9ouaIu0hZGqkHCY8GCC1ZowDxp7Rgznbn690TZ/wsGjPCQ8o5VjZM/l+DRp9vbt
	dcjetnr74b8Jjy16XngAZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772147037; x=
	1772154237; bh=nMLSS/6smhC2Fkh6khLdkEUEvv92EQDMAOVxu9hbY5o=; b=i
	tMG0KrXlyEFXwalLMq9Sx0bQwBEAgP9bIZErOhRLK+YxLMjHGj/4pEB6yiISM9UB
	OiJQx272k4YcRkiIf1NT+lmiNDK1XLYNwsVvM+cKn2+iC29TRgWkNReqW7tf5oMC
	SO9UoppGBcBgwMXK9MJRMFWoE7UPMlhQAiitzOOkVRs2uOExtBYRRJe0ulaf1QZw
	HGVc3Isw7DmR0QVlIbuJdBI5a8GCLAEpiuM+klWIY5GnIXYK/PnDrGbdkB1LcKu5
	BYHX4zisQXoxrjyYzlkZ98AXUnJCkN7jYh1ZuTlqW76KnekpoRCowo/omVLticQX
	5gVCKqqyfQe8xrHK7Xt5w==
X-ME-Sender: <xms:XdGgacBk-a_O4YaEInjmWWDxabzQN4mLXC5qHVW4JFh-0mNlnVlFNQ>
    <xme:XdGgaULPU4sQfbMFfCtO-7kCODOOZLuyTwssclrsRpekwQfpSyKdg5TY_yhpHBy9o
    cLrLikyCCVk-iqtscnlq9KPMwGMdAm4lTFEkPGDHCSrMkkUucJ3Rg>
X-ME-Received: <xmr:XdGgaXpAlCE-PpaBMLNfI1-m1wWQpOlnWQ7LafEdb8Cgw61NBCBPYZGtKIs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeejfeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepgeehpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopegumhgrthhlrggtkhesghhoohhglhgvrdgtohhmpd
    hrtghpthhtoheprghjrgihrggthhgrnhgurhgrsehnvhhiughirgdrtghomhdprhgtphht
    thhopehgrhgrfhesrghmrgiiohhnrdgtohhmpdhrtghpthhtoheprghmrghsthhrohesfh
    gsrdgtohhmpdhrtghpthhtoheprghpohhpphhlvgesnhhvihguihgrrdgtohhmpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopegrnhhkihhtrgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepsghhvghlghgrrghs
    sehgohhoghhlvgdrtghomhdprhgtphhtthhopegthhhrihhslheskhgvrhhnvghlrdhorh
    hg
X-ME-Proxy: <xmx:XdGgabfq1Ai_EQPCKW27A1XJdpuSwGGpo_5-E1KoICM5d5hpf1B16g>
    <xmx:XdGgafpW__MOZjkcCeKPdqOzUegJkJbht_U9IShOJQZUvxnpHkhVuA>
    <xmx:XdGgaXQvCmNlF2J2dHS6vEVqYIZVfwQHxNyXMPN92lqXkjvDtj24dg>
    <xmx:XdGgaRwyXwCgwUD3I0SCQkXj7VyHRfPVqLTstyfDRwOu0X1MFBGsrQ>
    <xmx:XdGgaWSCrdHJXw1ROVKIfwjhuia4A0XZjl5nsXo6JfOBqvYYxsBNCQoN>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Feb 2026 18:03:54 -0500 (EST)
Date: Thu, 26 Feb 2026 16:03:53 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
 Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
 kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
 Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Lukas Wunner <lukas@wunner.de>,
 " =?UTF-8?B?TWljaGHFgg==?= Winiarski" <michal.winiarski@intel.com>,
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 "Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?=" <thomas.hellstrom@linux.intel.com>,
 Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Zhu Yanjun <yanjun.zhu@linux.dev>, alex@shazbot.org
Subject: Re: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
Message-ID: <20260226160353.6f3371bc@shazbot.org>
In-Reply-To: <20260129212510.967611-8-dmatlack@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-8-dmatlack@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6D6D080012
X-Stat-Signature: shfr859bxsoszezt74w3bmxtucny5h4k
X-Rspam-User: 
X-HE-Tag: 1772147039-734498
X-HE-Meta: U2FsdGVkX1/haPSYq1Tklt2vV+qsnzytIECuUdnAKNJR0NPXHy8C3mjwe8h3V2NgiZx3Rq3IrH/YMn29rhVVPFrQMT4j47tl/5lsCJKWd4Z8JpOcdQNshvQaf/ji4TnnxokVgf2FrlVEnZfPmDwI/RL0nxLcHVy6JYgD/j50W9l8jH2glISvui/Ldb3/tWwOdah9inid3BtPsUXputNEJhihtKfonJat9TzvJ4OouQ6hX6uSOaFbz+h1EPS4v5b3bwkd50cY+x7k29T+pOPmdJCiHfyk+q6moGi5Tx2jkQmkeSJ+JAZJP3met81p70AF2n8g945z5lQfWfBU9pcuDezEkOSYMar1X68cLqLxdDhzXcu5oI29gTJ20r/ajerMILijiRFJ1asCNiupvcDH2eybQUGhUHil2/ZXjxcGDEtCpbI/RdtyKyVhpw8nvlioFV7RbMK3y6Qdp4E1Jbm5G1nGCPECjBl9XCWnDQHGtZxzL5E0kKBIpe1PmGVb3bMbM4vmBzjXRgt1O8aaRKJGlXIGABlTEWzUMJ1fA6R7PI/7rVaRjYOB4b5dyyXmGUk5SZ+BvBxaPtYAF47mAtoBvWwllQvBeWNeMQBII+2FAbf6JEpUrjMokekLEKYuSJi18GSg2UUkSkgbPpF4XfOgBDdZK7lREOtrGx3D6Q2rPY0LgC1wxtFNMumzLUGeh/0nEmA/m2z4eTGjlXPtsMSkr+iJrzQyb9+iP5T5UPfbYXeNJ2o0RHwjhpRjI/M4y+DGeMy4vuUNsHuXKoajYO8blGES6PV7/HO1OElOtjdVspCNdueT23vaIli0utaXPVKJfPxBZHI8M3EC3DnfKtTPs6CTMmneqYlgZsXpEDHaqRgb8N4Uuzu0PtjNRl8D8N66Kztj139bDtBzx7+d1E10kvpi4YJ8FK1BSZ7f1EzDKRKMVU6Jge25AWmWfuPnv9LOOc2ry97tX9cIg19K/e7
 DgteOy2r
 GkCYcceTyObuyIyPHnGHd0JsW93qLDiSKQhpUkBTAyIjcwowiu6zByKisBBO5iaGV2wDOWPzknEjY1srEEarqQUY2KkAD82Pc6YxIiPKxaJ3SQdeWMmyJPJXyYSNOqDS0n/EfFVwvLadNvC3YPMQsRBlLPchuvVZDvkxpuvvanWs9A7S1o2HTFkCUeSdRu88Wg5YQlSPZWUOtUBijvwxK7iH3e6vSHn27TgBH62t0jBkv/2lkeMf0NDfZAMukeiujli+GkcKPyBK8SI9XAFHTbj0Uccfvgb1dvZZ0clQjB2Hb1scgdg99GXV606Dw5QdJyN/m1XZAofxsqj4mPDRfnPZSFbxvvXGu62uz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 21:24:54 +0000
David Matlack <dmatlack@google.com> wrote:

> Notify the PCI subsystem about devices vfio-pci is preserving across
> Live Update by registering the vfio-pci liveupdate file handler with the
> PCI subsystem's FLB handler.
> 
> Notably this will ensure that devices preserved through vfio-pci will
> have their PCI bus numbers preserved across Live Update, allowing VFIO
> to use BDF as a key to identify the device across the Live Update and
> (in the future) allow the device to continue DMA operations across
> the Live Update.
> 
> This also enables VFIO to detect that a device was preserved before
> userspace first retrieves the file from it, which will be used in
> subsequent commits.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/pci/vfio_pci_liveupdate.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> index 7f4117181fd0..ad915352303f 100644
> --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -53,6 +53,8 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>  	if (IS_ERR(ser))
>  		return PTR_ERR(ser);
>  
> +	pci_liveupdate_outgoing_preserve(pdev);

Why do we get to ignore the return value here?

> +
>  	ser->bdf = pci_dev_id(pdev);
>  	ser->domain = pci_domain_nr(pdev->bus);
>  
> @@ -62,6 +64,9 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>  
>  static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
>  {
> +	struct vfio_device *device = vfio_device_from_file(args->file);
> +
> +	pci_liveupdate_outgoing_unpreserve(to_pci_dev(device->dev));
>  	kho_unpreserve_free(phys_to_virt(args->serialized_data));
>  }
>  
> @@ -171,6 +176,9 @@ static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
>  
>  static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
>  {
> +	struct vfio_device *device = vfio_device_from_file(args->file);
> +
> +	pci_liveupdate_incoming_finish(to_pci_dev(device->dev));
>  	kho_restore_free(phys_to_virt(args->serialized_data));
>  }
>  
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
> +	if (ret)
> +		goto error;
> +
> +	return 0;
> +
> +error:
> +	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
> +	return ret;
>  }
>  
>  void vfio_pci_liveupdate_cleanup(void)
> @@ -203,5 +225,6 @@ void vfio_pci_liveupdate_cleanup(void)
>  	if (!liveupdate_enabled())
>  		return;
>  
> +	WARN_ON_ONCE(pci_liveupdate_unregister_fh(&vfio_pci_liveupdate_fh));

This is propagation of a poor API choice in liveupdate, the unregister
should return void, it shouldn't be allowed to fail, IMO.  Thanks,

Alex

>  	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
>  }


