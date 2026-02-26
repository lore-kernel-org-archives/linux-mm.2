Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 580D1FD9E21
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 23:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA9F66B0119; Thu, 26 Feb 2026 18:15:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73296B025D; Thu, 26 Feb 2026 18:15:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A554D6B0277; Thu, 26 Feb 2026 18:15:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2676B0119
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:15:23 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15FBE1602CE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:15:23 +0000 (UTC)
X-FDA: 84488166126.12.3C002B5
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf18.hostedemail.com (Postfix) with ESMTP id F0C691C0011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:15:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=gVXvAPiI;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="J gC6lC5";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf18.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.142 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772147721; a=rsa-sha256;
	cv=none;
	b=i0zCcBkqIKdcLDEY8kMB5IIIduMZ8nTeAdRbTfcmTKeIAHYSJWXcA4Zo6umgg0zqrw/VVg
	CDiKzp0+4Bmt5gBvrWwGg2aWEIyBaPi/1PHVtwZXSO/6DiPQlIt4VQiTyCj0JnMHUY4qA5
	NKvrYShvPSXPePbu+9caSZdi2kEZh+o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=gVXvAPiI;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="J gC6lC5";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf18.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.142 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772147721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yr+JJ9YtD7fwvp/AM3VRdjXUZyKz3WadH0Ul1izy0Z0=;
	b=0Ig3wCmiWGOXcx2tEt/9pdZMAP1N6yagsNne3Ikepkbjdp2+UplEajelqAVi0iZoEkxoaB
	zDEv9v5pFOmG1hhIwmdZ5SGH6Xhi7Fu1HWiVCQS4hrj0jKBNOHwO2MGHDzYoLYKn9vhUE8
	jxZVTneUlgFHj5ADNqASu/xsmzZPUR0=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 8F7561300FF1;
	Thu, 26 Feb 2026 18:15:18 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 26 Feb 2026 18:15:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772147718;
	 x=1772154918; bh=yr+JJ9YtD7fwvp/AM3VRdjXUZyKz3WadH0Ul1izy0Z0=; b=
	gVXvAPiIdt7JQHCG4TOy7SMG+5ql/toI+tvIZ+D4ZaWDiyRdMAQd/1KZyuxAtUzt
	hlzCnMbNtPNy8ufmzc6m6AWzKO7yp6VXXmkQhx6H62452wB7LtgjW8L56vilmyYU
	WILdSXDRUyk0L2K+OCYAvjn3kaFdVLwV0KvrHxGJXnJO93b6jF81uQGlVbEllWrz
	0j6fXXSRa74mG0ktKv12Xcgcs4zAv/2q4LlfcBwFoHAMWlyRmIq04c99KYkgRqej
	4K0IyixSiJ7JrkyoyBbj1TxyoTrmj3bZik1TT94WuYSIh7iqTuZq0KWaDkIacTk7
	JfkWg7Y3Q3B0a73/khWDNw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772147718; x=
	1772154918; bh=yr+JJ9YtD7fwvp/AM3VRdjXUZyKz3WadH0Ul1izy0Z0=; b=J
	gC6lC5vVC3gTJr1nCXt15HaLHDwk1aDrvyLUae67J4THeyPePTlSb7Do3ZsKZyns
	991HwVvfggEf+EaP/DL+O/nt3U6xHIrsa3e9Lyw0AnjdwChPGbbfzX6vB4PrYfE6
	UcXqmeDaAqxhds4eCgitvxgHDxHuwg6VpNOwUEZYE3URL4gcyGo3oynuEUeePwuc
	xuL3zs5Zx/Iv628XmCXiRlKNkVxs6WdQXzZyPzGl6eZ9+nL2RvcTt/i4gt4RuBe6
	n0ZXbMXki7yADbt8Ht4iQR4b4sQvDVpw5W4cvaAmEb98XepC6/BP5k6bNjPXMvic
	NRTmZhx6sl82fET4Pm7/w==
X-ME-Sender: <xms:BdSgaevBS-DP0E4PhF3SquCgA8u8bMx79QdHt-Vjk3m_hxwfIAJbCA>
    <xme:BdSgaQTDzIFDQe1gPvHOw9yHE4rE_oDxrvCrkjQ2qkM5VG5_HgMGBJT_dstvuGGEi
    GvhyqsFvZiERYQTpESNKdtPuXb0TlJSRYKrsev-NlUF20Z3SoM5BQ>
X-ME-Received: <xmr:BdSgad8lvkPNqEfr4rQXnoahwH0W1hQor4jiORwyCDcQBz72kZJkh_IX66A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeejfeelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:BdSgaXXjLybHbzutmuhIRci-8jpP40Xadl469qn5-4LoLe3S2Wb6cA>
    <xmx:BdSgaTGscqQPoDKst3DW8n1f1L054xbRkQYM5nsXRgP6lM_pPySt-g>
    <xmx:BdSgaaIxA5UEkBwT4LITTYN9WAf2Xehxe7ABZ29EHJuN-_uzDIhtMw>
    <xmx:BdSgaQmrDmIe8VjUAllvJFp9dMnIhHtKyOV3nfzNMEfOEE4pPVy9gQ>
    <xmx:BtSgaWy6imTK0zo4upPI5vovhFFHOcrzJtk4VSYMJJddYDd92-Nd46Y9>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Feb 2026 18:15:14 -0500 (EST)
Date: Thu, 26 Feb 2026 16:15:12 -0700
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
Subject: Re: [PATCH v2 08/22] vfio: Enforce preserved devices are retrieved
 via LIVEUPDATE_SESSION_RETRIEVE_FD
Message-ID: <20260226161512.532609ec@shazbot.org>
In-Reply-To: <20260129212510.967611-9-dmatlack@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-9-dmatlack@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F0C691C0011
X-Stat-Signature: pcgf3c6yk8iiox1trrd71c9i7ejyx895
X-HE-Tag: 1772147720-559058
X-HE-Meta: U2FsdGVkX1/NjbrPV4muLm9vueDX840PgbtiQZSWXmZRPZzpo0VVtAySCtpsh9cxBkqWtFzNhdks5UN5xAagCpGKbbIBoITsJEUm9cL5WGWdDh6HTOaoscArP7QDn5NAWbiy+6boMZcKMaBxnN3TkwVSMhNfCXbOKpcpZmbUs+oE3Yy39ZAMP+gbXRWQ/TAEfqEx/h95gNFbtwmQA+mmhh/Q5iNOLHqh4+xasJ8Gb21t3NRFGd3TP06r+TFgrBVKmM8CNv/qpyy9erI7cqTvDig9PBghwYok6HmsT5ME/t9Z3F38p3BndXt+gCjVg/IW78s6ZW6itCugotnHYE7jLi79SeN8LYVKhazpOnDgtmPPSs1ZxvZONW4ZJGSleVCrFItQiaUP6rpLUeRbdEOc7sMipYHJ8GpNPocCjf4/p/PSonkrXldDRvT3Ae+VPOHP5zHbCA0c4xfM26m7gMddK3lSene7HoPBpdLe/inK//XKYTVAEgDHv//n0doh/MyMMYd3Tnpdvrijd6i7+57ySe1PE67MfaCW8TWex3pqRhe+6JdCCDsbCqqwTk8J7yNvuSIXMfQfMAQ8LRW0sNRWV+aJNj6MTxhAIqOMVaRAfswlB08zIGq3HSZJ9nGNg41P4kuomg4hCyOefDaPVpqoE67+aeYKl6fSpjHbnwLuz4dhlbU4R2JHvHl7QBYJjhr/3e/lhiLRNn5FtqEXAz8N8c4vNbbvEvUafz/lnrIXPRxmrXx2HnsONrEnFKm+1FrusRUlO1LX8+5LO47iuRD1FvhqQqcFKH/ht99qRu65Sk32B1UTsbW2URSLhgIGLhtl16WFpYcwGRk0wIAbmxIMcVBIEbd9/AvIa79O94i63L0m1xS0Yj9u6Ow1tcptZHsx0XM4Wlr3pdBwEVasSmOqB3ueDegZbCwtmxKUwmbErz9M8i6XpSpVKq1Z2eDm9js8xScpejq/wbkYjoS+utn
 2w5GpVWf
 C11prWFv8nOPCgxLCv/bS9dJH2qrIhqz0el6CUDqsNroB03+BQPgU43mcd+daOxgSxfsms+HuEZvtaVUsV7i/Ft9AlXZrs2Xm+ETEpdVJhKU9DONfVwwKvvLh+dbV5moIXXDT6mqkYAxxyy6gQbeHBiAOSZFBWJhEl5mYKFNKDbJY/VZWxt1rVXPBh8KOPCUV6NnjhmxH3t/mKueWMYT8Q4HH4qFRzAKu8fE6Re0sCfSZ3fgaQsVqENWaMzjalVDcTtZVGQXvTNo4KhTZfIKiC6f9UDNMKpuAAIAeNSqpYFdwuZxJUcLFU1ZCbMQlbRxov9geIXpD5C3YEEnQVaY9p5cvb1sNuwefOjveu7pzxm8nScelPO/IRlLquSTZJOLl1UnhJ7CNyeDpVBkCZvpeynGNQZRi+JoYzg1oPauiUYakO1w5+YqMm4LcuiVj6HOFpcXV6bEOVn/TvOlLEipcpRhs7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 21:24:55 +0000
David Matlack <dmatlack@google.com> wrote:

> Enforce that files for incoming (preserved by previous kernel) VFIO
> devices are retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD rather than by
> opening the corresponding VFIO character device or via
> VFIO_GROUP_GET_DEVICE_FD.
> 
> Both of these methods would result in VFIO initializing the device
> without access to the preserved state of the device passed by the
> previous kernel.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/device_cdev.c |  4 ++++
>  drivers/vfio/group.c       |  9 +++++++++
>  include/linux/vfio.h       | 18 ++++++++++++++++++
>  3 files changed, 31 insertions(+)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 935f84a35875..355447e2add3 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -57,6 +57,10 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>  	struct vfio_device *device = container_of(inode->i_cdev,
>  						  struct vfio_device, cdev);
>  
> +	/* Device file must be retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD */
> +	if (vfio_liveupdate_incoming_is_preserved(device))
> +		return -EBUSY;
> +
>  	return __vfio_device_fops_cdev_open(device, filep);
>  }
>  
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index d47ffada6912..63fc4d656215 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -311,6 +311,15 @@ static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
>  	if (IS_ERR(device))
>  		return PTR_ERR(device);
>  
> +	/*
> +	 * This device was preserved across a Live Update. Accessing it via
> +	 * VFIO_GROUP_GET_DEVICE_FD is not allowed.
> +	 */
> +	if (vfio_liveupdate_incoming_is_preserved(device)) {
> +		vfio_device_put_registration(device);
> +		return -EBUSY;

Is this an EPERM issue then?

> +	}
> +
>  	fd = FD_ADD(O_CLOEXEC, vfio_device_open_file(device));
>  	if (fd < 0)
>  		vfio_device_put_registration(device);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index dc592dc00f89..0921847b18b5 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -16,6 +16,7 @@
>  #include <linux/cdev.h>
>  #include <uapi/linux/vfio.h>
>  #include <linux/iova_bitmap.h>
> +#include <linux/pci.h>
>  
>  struct kvm;
>  struct iommufd_ctx;
> @@ -431,4 +432,21 @@ static inline int __vfio_device_fops_cdev_open(struct vfio_device *device,
>  
>  struct vfio_device *vfio_find_device(const void *data, device_match_t match);
>  
> +#ifdef CONFIG_LIVEUPDATE
> +static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
> +{
> +	struct device *d = device->dev;
> +
> +	if (dev_is_pci(d))
> +		return to_pci_dev(d)->liveupdate_incoming;
> +
> +	return false;
> +}
> +#else
> +static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
> +{
> +	return false;
> +}
> +#endif

Why does this need to be in the public header versus
drivers/vfio/vfio.h?

