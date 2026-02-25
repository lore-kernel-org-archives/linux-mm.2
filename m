Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED3FFD45F9
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F03E6B0092; Wed, 25 Feb 2026 17:41:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1F06B0093; Wed, 25 Feb 2026 17:41:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEBA46B0095; Wed, 25 Feb 2026 17:41:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D714D6B0092
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:41:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 691CC13B870
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:41:32 +0000 (UTC)
X-FDA: 84484452024.08.FFF4B2A
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf16.hostedemail.com (Postfix) with ESMTP id 371F918000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:41:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=FtNRN51z;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Z CUaIfR";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf16.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.138 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772059290; a=rsa-sha256;
	cv=none;
	b=vK5F+Qs7xZY5+KeToLfXnjdo/jb3Ecoo1yxWs9KqPOvMyVZMh7thoMucSC8eOXqkVHC8Fl
	wN8yspsyTYY30xG43MRHhmwoCfjMokuokkQxh2LAwhyQ9mqcf84mWJQhcoKXG6Rremx82j
	ALOz72UEOEe+IUpG2SYVnX6IMFEjpXs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=FtNRN51z;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Z CUaIfR";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf16.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.138 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772059290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oep9Y9MGDl6EnmjeOoassNkQMcZjeQipwaxd+cacIYs=;
	b=OVsrMiOV7cWHdHtkzJT119xk1bOsfgTkMORS1ZCAxR6IFEGpnoM1PaQQ0KdKO3Rmw70W6g
	cph0E4RyNOu+TJ2vyN/IEMe42hKaSG+63w3jIbrjMGBN87pWQvhyc8x3qFVWJg291vi6pg
	jH/imhgwZCKLBZqk+OAYRIwTZSRaCl0=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 639591380B4B;
	Wed, 25 Feb 2026 17:41:29 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 25 Feb 2026 17:41:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772059289;
	 x=1772066489; bh=Oep9Y9MGDl6EnmjeOoassNkQMcZjeQipwaxd+cacIYs=; b=
	FtNRN51zlLJSzOqZgYSf06qT/hPgX0Xh1t+FmulssFeEUF5T82rV6Q+97x1H38YL
	+vvwu1/aKxjyYy+J+aSj74n9zKKNdSbcGGFoaYL5GPr44+Mz8b3u6wdQBqiy8S3q
	brj5Jx3Ig+dsu8r0hzCEk4IFPGsG3AcJb7H20fydPUgMp6WBEZww92bEYjyCyFK4
	//AZ6+wONeSFmxuIh5NIe9gZAVkS6eUqw4owFWRQlLz0e0d2bpulb8ZcI8P4Rj0U
	13FZth1NOOabJgAvxdlyXHXjLZ5x6/9rdqGk6KV4uCPyblAuSowiX8TZsh/gNNsf
	SeCJPk86afvEwLHUfHxWGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772059289; x=
	1772066489; bh=Oep9Y9MGDl6EnmjeOoassNkQMcZjeQipwaxd+cacIYs=; b=Z
	CUaIfRsN1obBn4ydniZ2O5erKca5LBToJSQ58QZBTARgOisVPzmZgQwuP2/GoAmP
	bdQQMAZ/i0SHPFJKvaFcdUV/Vn+Y74lMvHJ1O2XlwPEDlKFMG3SFNXIVwevwC2vY
	+n908/d+3HpiQTQTrQzt1ZZjrbSy5oJKU8/YBlKfba5m1k/ElNmZBgbBMxSPTUFV
	RkT/35Ar32EdP7rXK0FCzMlh1w5KrA+CKu0LgULtpLLbwNNd+ZhaQewF6LFhowQB
	j1Bq5BnnkBxv5La9urpOgjqfkMg0cAAHvzq1PncEUPrF36nJeLj9bGI7L2hkzXXp
	NSf0CazlxHND4vyYQvCZg==
X-ME-Sender: <xms:mHqfaTxjHv1XxumCl1CA_axj93CQXqrt011zORmHxaIjcS59rd84sw>
    <xme:mHqfaYE4Fvmzpidx0yWcmrWwsyakqQk3lxCK9evXetu0ZaJPXwyxIatu8Ss0zCCMq
    BC9XLQOLw4RTMwitR9FQc4oKRipaM70Bz8QdCLfdhHM5rCcXz8s-g>
X-ME-Received: <xmr:mHqfaRh6z8Ki4tpCy7iQwcBL7gPLTxgPzOuHNSbAQoXmwHHaqEuzvnMPmb4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeegfeehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:mHqfabr1x-RS8v4yk7Ri9Ixpw6iqffu9JXPyV-SGCEDqKCi6V4lK0Q>
    <xmx:mHqfaZJxOBkG3oH8UxMu0LpcbZrqQh4iuU5F9aBBxW7ACQS6l1EwRQ>
    <xmx:mHqfae9h-Q9i8ZreTJZJfSoPQn3KhwG90kZC0faYdr6TAQ4avjQQGg>
    <xmx:mHqfadJpQjmVGfptc-41b-pfPVxlVNUKzzyM6Qm5JVECVHYT5CMc5g>
    <xmx:mXqfaWTmGPbaduxr2fz7lpdqZoYt3tYbiAu7lHoLUCYuIXRhXyYpudEL>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Feb 2026 17:41:25 -0500 (EST)
Date: Wed, 25 Feb 2026 15:41:24 -0700
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
Subject: Re: [PATCH v2 05/22] vfio/pci: Preserve vfio-pci device files
 across Live Update
Message-ID: <20260225154124.78e18fa4@shazbot.org>
In-Reply-To: <20260129212510.967611-6-dmatlack@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-6-dmatlack@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 371F918000A
X-Stat-Signature: wmid4sdznf6jgiimoggj89gr7q4xqruh
X-HE-Tag: 1772059290-442945
X-HE-Meta: U2FsdGVkX1/23o9VvgSmRia/ajqzjp2IVrut9QICyNpcmbQvbEx4xXmdIZaZ0zCEfiu/jjxxO0B/bS6TAhCKtHOvJR9RG2k0QMDlkrbYJBhEqG0InqglnHBziSO4K3uY1Hol+wOkOon8fEgQiAV52TFYNO5IHHiICRbAHCA8+w/VzTRPdkDYT+Dz0vnTtV4+UnAgv4Z7x5mYs40202on/krK1r8OeFtpe9HqnCjj/mJ9wIollkG/UTpnh61IC6HedYu9GbrJXGF/6MoqklZgWn3e9PCvJFe3uI8H4o7lyPDLhU6PnKoMNDvhaISyAD5HbXJcAysiDk4z1jnalC/rNAnaEhfQCjuNdZhCXNefzzMhQok/OeQZ6LUh9d1neAs0yPxBvvFFBq6p8OLIQsD0peuax/1wvC9KneM8hnAM8f8qyoGzuSLAUcl48eLwLrDVr4qVFDAA5NFJtef/+LCA6P3Qbs8qFeB3XKKxCFG3+DgH/thuihnuswgwG6UwjqpLQqMcuaHWXUkVy6o5BpDlHJbKeVRRZG8Rpmt98gAmU4G/b77pVV9mCB/Arth8W9VHUNQXLb7wvWIYMQ5q0AxQnLQwdlQDzu8FNJ2dt6epf63axkMPq7t4QwcaCb3J7nxuH0cplO6Lm0uGvWwbGMgw7DhRSLDJqDDKJbRi808kTKsX9iWSan9QrVnos31CXA+RejArM1q4I/ZL6qTCWxr8+FkHtiT26kpGe4LTVk6MfnyInWqESksh7B1hFaNjOOeFEW3r1uqm770lBd0CUK1IRyx0I1G6wYgBmeGZvYkPCplVoSWQsDZTApByjRim2bsYbTu0MMo0+CQluymFrEn27AxomlwRorsc86ag6lkZ92iouDwcKHVG6jtQCMq/0M+apZUEbzp6NXYhIdo2pbAtfBTjdshf6nE0Qh7prah856tSQ3LHWxf/fWKYWkgWX1AzZ8oVWTY7VUy0tBnbGwi
 y1LT7vMp
 rwYsA3WSYObdXOQ8ZnlULEWO0XW+4CpYcVzPaNc82VCAGDrWYr5tsYxKvGy12u7/MOLg4bTBEdjWkk92tXjB6piFV2kAsRO5sTd35pYlwlmsf/XMKVPzA83GBn5d1Vh9KGJpRqb9jlZ9j07PpFi/xgMD3eMI6sAi3LPrb1VdVoHNIQm13ajH3ZD7GbAiQnHFIiL3WpFb03HBXJ9JZHvn596a9loMnWEXEhQmQEUcYwSd+bGUwQBNoh7pdMOBSQDpVi/yX+njPhb+8IyGvgmnpkrAOd37YSlbbmrz738bASqg9lpMZyMsDquuMcBSfP0kdu78IrC7GSQ2VjLYl6C1H4DPn+52t+Xfse5Kj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 21:24:52 +0000
David Matlack <dmatlack@google.com> wrote:

> From: Vipin Sharma <vipinsh@google.com>
> 
> Implement the live update file handler callbacks to preserve a vfio-pci
> device across a Live Update. Subsequent commits will enable userspace to
> then retrieve this file after the Live Update.
> 
> Live Update support is scoped only to cdev files (i.e. not
> VFIO_GROUP_GET_DEVICE_FD files).
> 
> State about each device is serialized into a new ABI struct
> vfio_pci_core_device_ser. The contents of this struct are preserved
> across the Live Update to the next kernel using a combination of
> Kexec-Handover (KHO) to preserve the page(s) holding the struct and the
> Live Update Orchestrator (LUO) to preserve the physical address of the
> struct.
> 
> For now the only contents of struct vfio_pci_core_device_ser the
> device's PCI segment number and BDF, so that the device can be uniquely
> identified after the Live Update.
> 
> Require that userspace disables interrupts on the device prior to
> freeze() so that the device does not send any interrupts until new
> interrupt handlers have been set up by the next kernel.
> 
> Reset the device and restore its state in the freeze() callback. This
> ensures the device can be received by the next kernel in a consistent
> state. Eventually this will be dropped and the device can be preserved
> across in a running state, but that requires further work in VFIO and
> the core PCI layer.
> 
> Note that LUO holds a reference to this file when it is preserved. So
> VFIO is guaranteed that vfio_df_device_last_close() will not be called
> on this device no matter what userspace does.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Co-developed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/pci/vfio_pci.c            |  2 +-
>  drivers/vfio/pci/vfio_pci_liveupdate.c | 84 +++++++++++++++++++++++++-
>  drivers/vfio/pci/vfio_pci_priv.h       |  2 +
>  drivers/vfio/vfio.h                    | 13 ----
>  drivers/vfio/vfio_main.c               | 10 +--
>  include/linux/kho/abi/vfio_pci.h       | 15 +++++
>  include/linux/vfio.h                   | 28 +++++++++
>  7 files changed, 129 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 19e88322af2c..0260afb9492d 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -125,7 +125,7 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
>  	return 0;
>  }
>  
> -static const struct vfio_device_ops vfio_pci_ops = {
> +const struct vfio_device_ops vfio_pci_ops = {
>  	.name		= "vfio-pci",
>  	.init		= vfio_pci_core_init_dev,
>  	.release	= vfio_pci_core_release_dev,
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> index b84e63c0357b..f01de98f1b75 100644
> --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -8,25 +8,104 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> +#include <linux/kexec_handover.h>
>  #include <linux/kho/abi/vfio_pci.h>
>  #include <linux/liveupdate.h>
>  #include <linux/errno.h>
> +#include <linux/vfio.h>
>  
>  #include "vfio_pci_priv.h"
>  
>  static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
>  					     struct file *file)
>  {
> -	return false;
> +	struct vfio_device_file *df = to_vfio_device_file(file);
> +
> +	if (!df)
> +		return false;
> +
> +	/* Live Update support is limited to cdev files. */
> +	if (df->group)
> +		return false;
> +
> +	return df->device->ops == &vfio_pci_ops;
>  }

Why can't we use vfio_device_cdev_opened() here and avoid all the new
exposure in public headers?

      struct vfio_device *device = vfio_device_from_file(file);                 
                                                                                
      if (!device)                                                              
          return false;                                                         
                                                                                
      if (!vfio_device_cdev_opened(device))
          return false;

      return device->ops == &vfio_pci_ops;

>  
>  static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>  {
> -	return -EOPNOTSUPP;
> +	struct vfio_device *device = vfio_device_from_file(args->file);
> +	struct vfio_pci_core_device_ser *ser;
> +	struct vfio_pci_core_device *vdev;
> +	struct pci_dev *pdev;
> +
> +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> +	pdev = vdev->pdev;
> +
> +	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
> +		return -EINVAL;
> +
> +	if (vfio_pci_is_intel_display(pdev))
> +		return -EINVAL;

Some comments describing what's missing, if these are TODO or DONTCARE
would be useful.

> +
> +	ser = kho_alloc_preserve(sizeof(*ser));
> +	if (IS_ERR(ser))
> +		return PTR_ERR(ser);
> +
> +	ser->bdf = pci_dev_id(pdev);
> +	ser->domain = pci_domain_nr(pdev->bus);
> +
> +	args->serialized_data = virt_to_phys(ser);
> +	return 0;
>  }
>  
>  static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
>  {
> +	kho_unpreserve_free(phys_to_virt(args->serialized_data));
> +}
> +
> +static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
> +{
> +	struct vfio_device *device = vfio_device_from_file(args->file);
> +	struct vfio_pci_core_device *vdev;
> +	struct pci_dev *pdev;
> +	int ret;
> +
> +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> +	pdev = vdev->pdev;
> +
> +	guard(mutex)(&device->dev_set->lock);
> +
> +	/*
> +	 * Userspace must disable interrupts on the device prior to freeze so
> +	 * that the device does not send any interrupts until new interrupt
> +	 * handlers have been established by the next kernel.
> +	 */
> +	if (vdev->irq_type != VFIO_PCI_NUM_IRQS) {
> +		pci_err(pdev, "Freeze failed! Interrupts are still enabled.\n");
> +		return -EINVAL;
> +	}
> +
> +	pci_dev_lock(pdev);

device_lock() is a dangerous source of deadlocks, for instance how can
we know the freeze isn't occurring with an outstanding driver unbind?

> +
> +	ret = pci_load_saved_state(pdev, vdev->pci_saved_state);
> +	if (ret)
> +		goto out;
> +
> +	/*
> +	 * Reset the device and restore it back to its original state before
> +	 * handing it to the next kernel.
> +	 *
> +	 * Eventually both of these should be dropped and the device should be
> +	 * kept running with its current state across the Live Update.
> +	 */
> +	if (vdev->reset_works)
> +		ret = __pci_reset_function_locked(pdev);
> +
> +	pci_restore_state(pdev);
> +
> +out:
> +	pci_dev_unlock(pdev);
> +	return ret;
>  }
>  
>  static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
> @@ -42,6 +121,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
>  	.can_preserve = vfio_pci_liveupdate_can_preserve,
>  	.preserve = vfio_pci_liveupdate_preserve,
>  	.unpreserve = vfio_pci_liveupdate_unpreserve,
> +	.freeze = vfio_pci_liveupdate_freeze,
>  	.retrieve = vfio_pci_liveupdate_retrieve,
>  	.finish = vfio_pci_liveupdate_finish,
>  	.owner = THIS_MODULE,
> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
> index 68966ec64e51..d3da79b7b03c 100644
> --- a/drivers/vfio/pci/vfio_pci_priv.h
> +++ b/drivers/vfio/pci/vfio_pci_priv.h
> @@ -11,6 +11,8 @@
>  /* Cap maximum number of ioeventfds per device (arbitrary) */
>  #define VFIO_PCI_IOEVENTFD_MAX		1000
>  
> +extern const struct vfio_device_ops vfio_pci_ops;
> +
>  struct vfio_pci_ioeventfd {
>  	struct list_head	next;
>  	struct vfio_pci_core_device	*vdev;
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 50128da18bca..6b89edbbf174 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -16,17 +16,6 @@ struct iommufd_ctx;
>  struct iommu_group;
>  struct vfio_container;
>  
> -struct vfio_device_file {
> -	struct vfio_device *device;
> -	struct vfio_group *group;
> -
> -	u8 access_granted;
> -	u32 devid; /* only valid when iommufd is valid */
> -	spinlock_t kvm_ref_lock; /* protect kvm field */
> -	struct kvm *kvm;
> -	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
> -};
> -
>  void vfio_device_put_registration(struct vfio_device *device);
>  bool vfio_device_try_get_registration(struct vfio_device *device);
>  int vfio_df_open(struct vfio_device_file *df);
> @@ -34,8 +23,6 @@ void vfio_df_close(struct vfio_device_file *df);
>  struct vfio_device_file *
>  vfio_allocate_device_file(struct vfio_device *device);
>  
> -extern const struct file_operations vfio_device_fops;
> -
>  #ifdef CONFIG_VFIO_NOIOMMU
>  extern bool vfio_noiommu __read_mostly;
>  #else
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index f7df90c423b4..276f615f0c28 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1436,15 +1436,7 @@ const struct file_operations vfio_device_fops = {
>  	.show_fdinfo	= vfio_device_show_fdinfo,
>  #endif
>  };
> -
> -static struct vfio_device *vfio_device_from_file(struct file *file)
> -{
> -	struct vfio_device_file *df = file->private_data;
> -
> -	if (file->f_op != &vfio_device_fops)
> -		return NULL;
> -	return df->device;
> -}
> +EXPORT_SYMBOL_GPL(vfio_device_fops);

Seems we just need to export vfio_device_from_file().  Thanks,

Alex

>  
>  /**
>   * vfio_file_is_valid - True if the file is valid vfio file
> diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
> index 37a845eed972..9bf58a2f3820 100644
> --- a/include/linux/kho/abi/vfio_pci.h
> +++ b/include/linux/kho/abi/vfio_pci.h
> @@ -9,6 +9,9 @@
>  #ifndef _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
>  #define _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
>  
> +#include <linux/compiler.h>
> +#include <linux/types.h>
> +
>  /**
>   * DOC: VFIO PCI Live Update ABI
>   *
> @@ -25,4 +28,16 @@
>  
>  #define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
>  
> +/**
> + * struct vfio_pci_core_device_ser - Serialized state of a single VFIO PCI
> + * device.
> + *
> + * @bdf: The device's PCI bus, device, and function number.
> + * @domain: The device's PCI domain number (segment).
> + */
> +struct vfio_pci_core_device_ser {
> +	u16 bdf;
> +	u16 domain;
> +} __packed;
> +
>  #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e90859956514..9aa1587fea19 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -81,6 +81,34 @@ struct vfio_device {
>  #endif
>  };
>  
> +struct vfio_device_file {
> +	struct vfio_device *device;
> +	struct vfio_group *group;
> +
> +	u8 access_granted;
> +	u32 devid; /* only valid when iommufd is valid */
> +	spinlock_t kvm_ref_lock; /* protect kvm field */
> +	struct kvm *kvm;
> +	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
> +};
> +
> +extern const struct file_operations vfio_device_fops;
> +
> +static inline struct vfio_device_file *to_vfio_device_file(struct file *file)
> +{
> +	if (file->f_op != &vfio_device_fops)
> +		return NULL;
> +
> +	return file->private_data;
> +}
> +
> +static inline struct vfio_device *vfio_device_from_file(struct file *file)
> +{
> +	struct vfio_device_file *df = to_vfio_device_file(file);
> +
> +	return df ? df->device : NULL;
> +}
> +
>  /**
>   * struct vfio_device_ops - VFIO bus driver device callbacks
>   *


