Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D13BFD9E1F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 00:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BAB86B00F8; Thu, 26 Feb 2026 19:00:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35FC86B00FF; Thu, 26 Feb 2026 19:00:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 233DF6B0102; Thu, 26 Feb 2026 19:00:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0740A6B00F8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:00:42 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A71741A0279
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:00:41 +0000 (UTC)
X-FDA: 84488280282.03.FECC401
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5FA1D100015
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:00:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=KfdyHubK;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Z glLpMD";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf14.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.139 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772150439; a=rsa-sha256;
	cv=none;
	b=0WJEbhsWJYWgkiJ5Zi89P8eJhWogewJLYVvpUEi4krTWbUjyTBV7i35ZYUP+rUr0Zdb/Oo
	ct+nvEilu45781xUYn94H7YaEwryq3KuLT5Tb6fT5ARb2wVHAfyg3gE3I0RdH7zyylaBmu
	UKs4eAiugdE/ooP/na08XYLMVexjaRU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=KfdyHubK;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Z glLpMD";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf14.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.139 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772150439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7/IXhnnADeIhqB8XjstCGNDdQ5WTGWIX32H4Qcjj2Qw=;
	b=IkP5+FLCHKD+elecEANkjq6m+7SJx2ywMygXV+GHtejPNTrPFodpQeKp6YHk4E77KXSG4z
	6skMGuOLPJXB9+G0/cgn1SbUgCLUP9Zwq/xpNTjK6NKLKIL4NpNu6PUUV4XYq41XLM1pJ4
	aeeSBfdubpDzZ9MCSY0WuQm7hgDMM0w=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id C7E2F13010DF;
	Thu, 26 Feb 2026 19:00:36 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 26 Feb 2026 19:00:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772150436;
	 x=1772157636; bh=7/IXhnnADeIhqB8XjstCGNDdQ5WTGWIX32H4Qcjj2Qw=; b=
	KfdyHubK7T6mgbCHRhIr5mD6ruTZ/iS4/fLNIWNjGnhl1gAn6fwi3ppJ06Gd2dJg
	4j+2iEI1NgIVGtQ1kbajwBmSZ3kucQpabC7rYBW1w7C9Ns95JC7G2sCDHFGTcMha
	kv7zoWe4YzeFKlalXC30X01vESpzdydowfQQQlWMPV+oZxWYLCz283lVR3zv2Nju
	eVuYQ9dFy2UDeoXJmZYe7S7vvDRP/TCyDm8hpE/sG7rbMKSh1TvkY8QDSsY8Cpg1
	4cwajHsmuyHaZiq7C2NI+9LmP/V6+FqeD6vXWgw/vHSpDK1AbcXQc1HLUA6FGUn8
	/XDw5I/P8HNRXjdutcMDoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772150436; x=
	1772157636; bh=7/IXhnnADeIhqB8XjstCGNDdQ5WTGWIX32H4Qcjj2Qw=; b=Z
	glLpMDrdH3ybIl6Jfbe8ZlqPwGEGiWIaKq84xdJ3XK72dVh252bgdeEHLhNGg88w
	3pDfMb8G+6ch5QZiYiTb2vdJac0ZiodwaNo8erWlfsW8wftbBkxgQ4hNNT4SzETg
	9xNYNGzd4JBoge3B2Vd6F//62u+9NBZ8XoKc5pbywbz8xoA1EsZcAiF6eo4hfyBI
	JQaANqURgm9EvX0L6bVDkSvv6JL/0ItofsOMGisEwrBldJgavCTL7e3d4uzr8Pqy
	wuJsoR33BNh7JMaPMshYytFmb9FjXE8o89NSJtN+p3BgZBE7aDmAMqP3zTdWMVzY
	8D3Z60+RKBqTkQZw6Ixcg==
X-ME-Sender: <xms:o96gaWTEnV5FxcL75W1_K7e8Bz0ZcR-1S0u_5NyytHtXv8SBEpirYQ>
    <xme:o96gaYmGfC4xz6mPRb4i8ZcE1LMJgkqCiSZk9yheAKn241ll_R_etVV_6kTxHHE7w
    H8cKRlU2sq26FM569T0VHWBriy5PaH5bhbbLCiPC0f2S_CXrBMYJA>
X-ME-Received: <xmr:o96gaYDj2UgYwWTCfXWlvCbKyPOUQXrlnfVEIrq7NLCPnXZSaSIprk1Y1HE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeejgeejucetufdoteggodetrf
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
X-ME-Proxy: <xmx:o96gaQJHyq02-tY5B_dgovb6RPEIgf6Zra2A8BonvF1GTzX4maPZjQ>
    <xmx:o96gaTq9myJ60d7pE_4qLYmIRw3gnIkLVp-szI7JBnBn6iTrqiLQZw>
    <xmx:o96gaXeIGbQgQvAmt_4Ob1Gt3PjoRrw-qPHspQrSOhWEA3H5bkLJxg>
    <xmx:o96gaboB8XLmP2v_WRvZDm7kWd2k5QB2M1rchi9hpS9YGiFsZlw84w>
    <xmx:pN6gacyXTZuNPPKKceRhRy0cZc3qSkBNvPabhXzUVrNJ42U27GWaTM6T>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Feb 2026 19:00:32 -0500 (EST)
Date: Thu, 26 Feb 2026 17:00:30 -0700
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
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <20260226170030.5a938c74@shazbot.org>
In-Reply-To: <20260129212510.967611-11-dmatlack@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-11-dmatlack@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5FA1D100015
X-Stat-Signature: i6xpd4xphxpmgaowza16dx5ajaprf1a6
X-Rspam-User: 
X-HE-Tag: 1772150439-824220
X-HE-Meta: U2FsdGVkX1+Tsd9XDeppza1OEEMWAn/EE+9a3EfzV6UTej+1WMhK9S7szDC/Ux7W7wM6WsJBIRELIDRpetRtQqdVdSUicE40KWmgzyxEHZlU5ezYYKJJwD/BKBjU5n1ulCrMn6bPXtNZwPCpPsACX26Qge9mcICa3imAif1awSLVj6bbdH0KkUJXD7PX1w02h8PreGKjCpVpuEqPmqhSQ4Ra5OEXSK+VWTddhKPMboEHBYRwHpPylZ+kx6BR0NIpZuuTZnxkjZEax96KtlHneImfiB5Pc2IC9UfMkfnlaqCZgH0zBCJegunk0xfRMlAYQdscn9nXgIRpR8KKJxZrIUI8LyOC6Igy0SRcCUsu1pk+P5ivlUE66l4qJ8CFAzj5JH45DdD1qtA5utyfUOAZin+5RiArb358r71x33zMJNhdW7jPhwI5DywtZ9df209doaPI5whbFD0sBNEigbaYD/+1t5TKl6bS/lPgC7UcgODKBZnSbLlbqamppWOcZkfgYkumkyoM5tUCIbSOeaPTEij8srpSt19W1ovuKbTY/8pn71T0/y+e9nOiZ760Tr8DkRQ0zHpBCnAH8zw/nxPFdgDY+HX8naaFvoPKGoDfetrAdaYQaKQrSvaRY/CJQ2aj4UeAudhl7djsS1q0oDByiT5p37Tp+gSydwaQnx/iiz0cHZNAP5Dn8lX+iilfY5FZb96iahiRkoBiZDIaZpEXmRsaC0gM9ccolY/g13FyCaZhts5cdcdZHnSlP3BQgePMTU/jU29uP2MqL2mdpy096fngUCEPuhooF9GtTlt/6IZTh4nUUoFy/R8yAxooxnUEGD+keffF6iZYUknOGRwO+jfrxUHsWlqvtVC9qjS4BwxTctAbw289UJE8E5Nipjs5IzhwZmv+DtrRntMm81U+FRbIXWxrtbmGrhznjw6yBszPFIk4TVOiTv717gGN3iDfG3fA0ByveOWsZr+eJCl
 XAhQvSRl
 SJVd0RfZaj+GaFcAqywKEHVBkO6xzbKRnZ/kprL4C/Ne6Qzifsnr0UV9YP34bFgEjwvZb7BiWCN5QnHN9azaZdlcl66KrScor77VFA5g96TqChNi4aM7bVp+2j884KnF5KOfJy7nI3b3PIKFbR0UYTjtg2TDNisKVO4IAHD3b/5aWeYfNYlom3QiL+ztgM1dBAx8oh/qsMVNK44nTIRWxDqerNSsDrPgYuFuEZ8IT69vygGEyj5xLmo4+ch7CN8UE8BvUSZMcLFbrxBWPt+oxCtSNSWln86oVsm57A9jKf4zjGgUAbrmfoqr2o7RzAobwEiPMX/wN/3Agk9vInSpK1MZaGkSQfSd4e2L3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 21:24:57 +0000
David Matlack <dmatlack@google.com> wrote:

> From: Vipin Sharma <vipinsh@google.com>
> 
> Do not reset the device when a Live Update preserved vfio-pci device is
> retrieved and first enabled. vfio_pci_liveupdate_freeze() guarantees the
> device is reset prior to Live Update, so there's no reason to reset it
> again after Live Update.
> 
> Since VFIO normally uses the initial reset to detect if the device
> supports function resets, pass that from the previous kernel via
> struct vfio_pci_core_dev_ser.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c       | 22 +++++++++++++++++-----
>  drivers/vfio/pci/vfio_pci_liveupdate.c |  1 +
>  include/linux/kho/abi/vfio_pci.h       |  2 ++
>  include/linux/vfio_pci_core.h          |  1 +
>  4 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index b01b94d81e28..c9f73f597797 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -515,12 +515,24 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  	if (ret)
>  		goto out_power;
>  
> -	/* If reset fails because of the device lock, fail this path entirely */
> -	ret = pci_try_reset_function(pdev);
> -	if (ret == -EAGAIN)
> -		goto out_disable_device;
> +	if (vdev->liveupdate_incoming_state) {
> +		/*
> +		 * This device was preserved by the previous kernel across a
> +		 * Live Update, so it does not need to be reset.
> +		 */
> +		vdev->reset_works = vdev->liveupdate_incoming_state->reset_works;
> +	} else {
> +		/*
> +		 * If reset fails because of the device lock, fail this path
> +		 * entirely.
> +		 */
> +		ret = pci_try_reset_function(pdev);
> +		if (ret == -EAGAIN)
> +			goto out_disable_device;
> +
> +		vdev->reset_works = !ret;
> +	}

This could maybe be incrementally cleaner in a
int vfio_pci_core_probe_reset(struct vfio_pci_core_device *vdev)
helper.

>  
> -	vdev->reset_works = !ret;
>  	pci_save_state(pdev);
>  	vdev->pci_saved_state = pci_store_saved_state(pdev);

Isn't this a problem too?  In the first kernel we store the initial,
post reset state of the device, now we're storing some arbitrary state.
This is the state we're restore when the device is closed.

>  	if (!vdev->pci_saved_state)
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> index 1ad7379c70c4..c52d6bdb455f 100644
> --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -57,6 +57,7 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>  
>  	ser->bdf = pci_dev_id(pdev);
>  	ser->domain = pci_domain_nr(pdev->bus);
> +	ser->reset_works = vdev->reset_works;
>  
>  	args->serialized_data = virt_to_phys(ser);
>  	return 0;
> diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
> index 9bf58a2f3820..6c3d3c6dfc09 100644
> --- a/include/linux/kho/abi/vfio_pci.h
> +++ b/include/linux/kho/abi/vfio_pci.h
> @@ -34,10 +34,12 @@
>   *
>   * @bdf: The device's PCI bus, device, and function number.
>   * @domain: The device's PCI domain number (segment).
> + * @reset_works: Non-zero if the device supports function resets.
>   */
>  struct vfio_pci_core_device_ser {
>  	u16 bdf;
>  	u16 domain;
> +	u8 reset_works;
>  } __packed;
>  
>  #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 350c30f84a13..95835298e29e 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -16,6 +16,7 @@
>  #include <linux/types.h>
>  #include <linux/uuid.h>
>  #include <linux/notifier.h>
> +#include <linux/kho/abi/vfio_pci.h>
>  
>  #ifndef VFIO_PCI_CORE_H
>  #define VFIO_PCI_CORE_H

Wouldn't a forward declaration do, and the kho/abi include can be kept
out of the public header?  Also should be in the previous patch?
Thanks,

Alex

