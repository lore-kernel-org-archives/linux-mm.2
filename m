Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E10A7FD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 21:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC386B0088; Wed, 25 Feb 2026 16:33:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47A5F6B0089; Wed, 25 Feb 2026 16:33:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324C16B008A; Wed, 25 Feb 2026 16:33:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF006B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:33:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BBB671B7310
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:33:37 +0000 (UTC)
X-FDA: 84484280874.02.6A9A08B
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7DC6E100006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:33:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b="Fe/KFBw9";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="t 4JQiMy";
	spf=pass (imf14.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.137 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772055215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uOyGcfhW1LI1T0+ImDiYL1uiY49EgY0HI4HEklJbETo=;
	b=kl2znuBbG/7luQzXd00rXxkwxYNBDKc5YCOcjkhWVy9oMJPvGLtXRbXjGa/jnTFl11eLme
	gm7YLvSM8d9LC8g61m3xMdTaL3Tg0ahn2d1BE9EuRiG1wCNPzNIbUIcZ9EOAGy/0nD5hU7
	4S+mHJMLYRKzAi8qyPWs0gyE6bEXgvI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772055215; a=rsa-sha256;
	cv=none;
	b=7yezdnJKz5HbfdU+LqT5ZcNF5LbR1tz/qyVxpehGKJhGbrUHkHJj4UdcHhoFf5biHu0A1b
	E5o1kxSSOndkZLeXi24wh55k1wSpijLyPnJ1V6Uu/eOtZC46DFWRvmEOY7gqdb4qdquW5f
	rrvZ8lCFJ694YqfBIDZbw8EnD97XQR4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b="Fe/KFBw9";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="t 4JQiMy";
	spf=pass (imf14.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.137 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id B25A31380AF9;
	Wed, 25 Feb 2026 16:33:34 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 25 Feb 2026 16:33:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772055214;
	 x=1772062414; bh=uOyGcfhW1LI1T0+ImDiYL1uiY49EgY0HI4HEklJbETo=; b=
	Fe/KFBw9AhdA4JIPEFA6oKZMPb3jkSYj07O1VtDSsj+hw5ueMPGI4TP6AlPnPNgU
	uZlkZcKu8F1V6CdaKQ5F8rawNot0JXhub7A7i8kZ2a6Irzgqdj7ZQAljrKUPo+WN
	ckUH2mfIMPrAO9ug3Y04JmgN0axE2/mLsE8on37v3AnY9UigCsYwl8fMzaZ92Kqq
	ZrMc2qH8gqaY/MnjtK/Xg04fIJ932Mkf7qP0Jlo8hmNEEll1xyQnNz1fVs3kNUB0
	Znrc1HsroIGXMMsicDgklPEh6/3RiMSEQcqGJ7mtvo8Q5V7ly3+egJRP/D/91qrN
	yhTgY2R+oZbaVMmtg7slSA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772055214; x=
	1772062414; bh=uOyGcfhW1LI1T0+ImDiYL1uiY49EgY0HI4HEklJbETo=; b=t
	4JQiMybd8my/Q8yahj2kZiHYVHPzFYw0ah1C6Tkdx+JRzb9lwDbPteJ70dqqsSH6
	kadwUwL5Gk5PBfLYFgya2G4juOjsnxGCVT0+aoOKuK73XIt/Iq0+WpPFp5XsMxK+
	DZBp/DPLYUIoB6yitemqtAqz1guul+U7JWiurf6Vb0EjbLYJEalun1XNPphPOTLV
	VMvgLUWk+8R7ppxGFGoKLuKkEUXEo06Hji/3KL0bb92rRQw43cXEpsVQQctrKVIg
	dhMZgQyNNbsV9wf1seVJLxybZb5ljarp4SDjvTDq6G1ich04JP9tkvPNdadt8H8t
	D6yk0yc7cuZz9C+OPZyZg==
X-ME-Sender: <xms:rWqfabg6hBv-eIfPU45VVg_kTi1XiEwGHCOLtJKZTjFoS1vqERTeZw>
    <xme:rWqfaYPVV_7brDFcjHNXpI-JiFYTDmsC4vAhdZGQdFLO-xAQYewBtL7EIwbF0UqsN
    AC8flZI8dVseXF2purGoWJL7MkKi1NyUgatg72tdlNAJGpBX0RhIw>
X-ME-Received: <xmr:rWqfaUkEndAraLfwnPYcRWzYlSIKrjBMwBcae6DD4LZUkyH1CzTVOelnKSc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeegvddtucetufdoteggodetrf
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
X-ME-Proxy: <xmx:rWqfaXUe2FtA3DswIFB60ExhxZFyF4WTpDXQ_5K0uJb6A_pjD1-zHw>
    <xmx:rWqfaZbwjR4qhyLCBUtS6HbozOQLTb8Da7JXbzPAfHRRsnRclDkjxQ>
    <xmx:rWqfae0woTolOhs7n0PnNGy8Qymd6xqUPJqv3NBoAD2YEx6TloCDlQ>
    <xmx:rWqfaetNyIWQCnkMaOKDOZ3yWit9rXv9QiQwVJWAzIF4HXj2RH6MkQ>
    <xmx:rmqfaUCfyiFWNX-EYiIXFm3n4u8-Ftbqh0sezsK1WkYGRbGtK7SN5TSD>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Feb 2026 16:33:30 -0500 (EST)
Date: Wed, 25 Feb 2026 14:33:28 -0700
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
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
Message-ID: <20260225143328.35be89f6@shazbot.org>
In-Reply-To: <20260129212510.967611-5-dmatlack@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-5-dmatlack@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5c18idkd1qsaqd8ahhexykgnn364xad5
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7DC6E100006
X-HE-Tag: 1772055215-696594
X-HE-Meta: U2FsdGVkX1+zLtOeFvm7x44KLCILK34oimnj6NUxwvvT+MQxru6cJak+Ym6ZFKV6FfeOVAQWNQkDDrFd53wQtLE4HBdA1FuHolHyzWcJa5inoCnn9yQ5sJPu4DWrLAcFAyFShVXMW1juBAMgLI52LA0KMLTZhq4ZD0TU5BIQVrGDV/jbXCJDVfikRz5ZMjhzqfVtVtG6VRQ50dyekgeydKVnfyzYpt4QqeH9o6GBS8sSAJ30LFzerL3HmV9wnDfSKYxVr41y5WK90hN4JbdEt08r809tFckd0Kz0pF/IqOzdRyMCtaLfMm+bXdEL8bDYdVjvBqU7tc3NCbFCNWbm/mz3v9n0Zg81t9tRMr1mv87GlpmBynDf/onsKcq2ZW0hNuvBrsm2LcAAdVF6odDs07x+2uPJ0hxnS7aVeqADTIxpDzCGc6nR/CkkCkqma2XcF+T5nEKCNkAsYJ7nW7AzqiOj/ZS3TXLMfnC3b46264FoZGbdE9XAQHibsa/oWm7oTA9ASTMYK5Ehk4hQGukFvhOXvCC17/QcfAJuK9HWfM4rkm+5LsPi1/XnLEsIQbv9BV/oa6XpHMCnuW7YYgU2XglvbjW0P6I1vCwgttWfcS2DVdHtKxitHYoXU3TbDCJ2rTIudoB/VzuEheWmMHKf+mSiRkuQJF5VCwJv22lfp1Yy6O0E5pxFU1qjfbR6Bu3H3+BHX3Q+quXK0bH7+yhqJc3R14XFdE7ButWQ8ZmPp7eOrys5lxUMFSnfUSuqPecvANWTs7RYSlHKDR8XZ8eEofY3jXRYnhbokUbBfIxSrxeDKaIwlcAdBXKuXg37JE3nHx4oJlNnOJ1/CDNKdd81xJHG7EKDn7KfexfRQ+90X8N7OIaOiYHzZIjOIrE7aiGub/R3eh+ZlAgcfe2+0iJ/CSXW6NVEO1ce3gPL278ZE8FfE5NUC00z3lVqoq1CO8V7JiyPCMtzdtX9JVqulwo
 Xghg28WR
 gvF6sLPhYJURUbyowLamtLk7x5YmkYntPjDLnfA/12sV+vHnzfpfIZlydzvlfMXXusr0BRR37h1ysyK/wYFWyXO7uA7j89/pC9f/hn6GpmREeESwKM+fJn90FdZYPHb+9zyVJdgXIpCFvYPbxk8TXbBqBmJU2JVdpzKBfDS7+b9VZDVpmVanVyzK8uf1hqNOokL9jv6gIgLBzvmn1zCWlo/CiBI1qixneafFt+cLm4tOwMphagIwN09JqrmU8RniqnsKCsMk10tn2Sbb4YVoff2CbkPvZ9zhAtfgQo6qp1JIGQzI9vdY64VkkxwoHQnpl0/9W7+KLIn64E5N9iGTxKFLFn2lChyP9zpTg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 21:24:51 +0000
David Matlack <dmatlack@google.com> wrote:
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 0c771064c0b8..19e88322af2c 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -258,6 +258,10 @@ static int __init vfio_pci_init(void)
>  	int ret;
>  	bool is_disable_vga = true;
>  
> +	ret = vfio_pci_liveupdate_init();
> +	if (ret)
> +		return ret;
> +
>  #ifdef CONFIG_VFIO_PCI_VGA
>  	is_disable_vga = disable_vga;
>  #endif
> @@ -266,8 +270,10 @@ static int __init vfio_pci_init(void)
>  
>  	/* Register and scan for devices */
>  	ret = pci_register_driver(&vfio_pci_driver);
> -	if (ret)
> +	if (ret) {
> +		vfio_pci_liveupdate_cleanup();
>  		return ret;
> +	}
>  
>  	vfio_pci_fill_ids();
>  
> @@ -281,6 +287,7 @@ module_init(vfio_pci_init);
>  static void __exit vfio_pci_cleanup(void)
>  {
>  	pci_unregister_driver(&vfio_pci_driver);
> +	vfio_pci_liveupdate_cleanup();
>  }
>  module_exit(vfio_pci_cleanup);
>  
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> new file mode 100644
> index 000000000000..b84e63c0357b
> --- /dev/null
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -0,0 +1,69 @@
...
> +static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> +	.can_preserve = vfio_pci_liveupdate_can_preserve,
> +	.preserve = vfio_pci_liveupdate_preserve,
> +	.unpreserve = vfio_pci_liveupdate_unpreserve,
> +	.retrieve = vfio_pci_liveupdate_retrieve,
> +	.finish = vfio_pci_liveupdate_finish,
> +	.owner = THIS_MODULE,
> +};
> +
> +static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
> +	.ops = &vfio_pci_liveupdate_file_ops,
> +	.compatible = VFIO_PCI_LUO_FH_COMPATIBLE,
> +};
> +
> +int __init vfio_pci_liveupdate_init(void)
> +{
> +	if (!liveupdate_enabled())
> +		return 0;
> +
> +	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> +}

liveupdate_register_file_handler() "pins" vfio-pci with a
try_module_get().  Since this is done in our module_init function and
unregister occurs in our module_exit function, rather than relative
to any actual device binding or usage, this means vfio-pci CANNOT be
unloaded.  That seems bad.  Thanks,

Alex

> +
> +void vfio_pci_liveupdate_cleanup(void)
> +{
> +	if (!liveupdate_enabled())
> +		return;
> +
> +	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
> +}

