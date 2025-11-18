Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF747CEE350
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 20:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8BF6B0030; Tue, 18 Nov 2025 15:10:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AFDC6B0062; Tue, 18 Nov 2025 15:10:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F079A6B00AB; Tue, 18 Nov 2025 15:10:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF47F6B0030
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:10:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7907D56B5D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:10:54 +0000 (UTC)
X-FDA: 84124821228.14.BEBC86F
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf01.hostedemail.com (Postfix) with ESMTP id 44AFF4000F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:10:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=dKsiVfIf;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="b 4BcgUd";
	spf=pass (imf01.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.148 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763496652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JKFcF4a+cNbrtlp+FIdvl2Y5hDbZC7BuoipJJsoD+Xg=;
	b=qgJ39yy6koMpek8Stycb96tUMEZnNKiOBV5xRugux2+9Mkr2qQOxSDQPtTM5o3ZtIKOjnu
	NJziU5nIyhVcWBgqwKkr9jttJKzmub+yACpyWjbANQnNT4+x/IfeCBmSQjDE6LGBQc/o1x
	XBY+x9yx7QSXcNN1Btt30Jj8+19FtG8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=dKsiVfIf;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="b 4BcgUd";
	spf=pass (imf01.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.148 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763496652; a=rsa-sha256;
	cv=none;
	b=48eA2zP5rBtqlSnAdpwtVoKSylvUNuURq4NHhuCk9U9xmLnqP1PHdA8aBFypBhERo1OSpY
	8q+G+u5KsyaAZ2Qps2nYKztJmi7hAFIc3uIz5H31l/4t+n9dmEdlQM9tuvFoQ5rW3DrSiN
	26o3LcNXT7V2ZJB7vM+I+L3UJBco4ZA=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 7E23D1D00011;
	Tue, 18 Nov 2025 15:10:50 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 18 Nov 2025 15:10:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1763496650;
	 x=1763583050; bh=JKFcF4a+cNbrtlp+FIdvl2Y5hDbZC7BuoipJJsoD+Xg=; b=
	dKsiVfIfgRz3kNZHBVLW4w4a09M1An1YvYNcijPZ2AbBFboB1FxX0SwNlWv2rI3m
	jLV/veDDgOhw9IS/7J8t81UctKoauLfjaXOyWqAp44a4MChEre02HVqGpMlsgIQ5
	OVDMVHJablLjrzU+B8hL8QqRQ1+FyFvGpkw3BwGVonzwVgBd7NvVAsA+IlLoTNVT
	kot+Gxju1ZTzga7Bee121GDDqWNUI+lqCGgG89zYk6ckhz8rEtrBbj0mNQhPhOcc
	4uOd0pLPLZNlB7v3J3DPPBINt8sCnltepxWxkehpeYBA1Harjd8rccj6w8gmbij3
	nDgGERM8bBQyy2uD5HkTCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763496650; x=
	1763583050; bh=JKFcF4a+cNbrtlp+FIdvl2Y5hDbZC7BuoipJJsoD+Xg=; b=b
	4BcgUdYcPIovWahMuxFSya7KoSim52uHsgehgqj/ncnPhxE3qTN1l9XUmfH5dLA0
	nA9E0d7Le0Mc4/Xf7R7J2lQ/+CU38ymtFa6iaGShFA8iMhhJds2uyGYsUrmk0AGZ
	wwHqhNPuDyy3T1wmEKwJ83vo1u1sv9Rg4GlJkbcIEp90cjcQFPESsb71YSlLcyQd
	UEAV/QlH64EIJ1lqCiYY4cKUDhQBuK7Z/C878cS9zvqM5xyFNzLBS1ECI4FZmTN2
	zM7jJStJjqi5FJm842MkyHtQUwl7n/Nil39X0PVzn77HpNlgls3inc0qko2NNjgy
	yxSKoNtyts9q6kzxUKgCg==
X-ME-Sender: <xms:yNIcaVSvmDTF8VooyebZ_3iAuWJLF1nEpDYA2SFkLVpCRLI7ry-_yQ>
    <xme:yNIcaVmEGLCY5Y5fPmoEJKQOT9y5RfkjFiDcjDM82fNtYUukk3d8ZO-gnIlZyOOPP
    GAmhpj4l6gxq2LE9j06pWjqNlxkgm2Z3bZOzOLp7Twv9NJiGOok>
X-ME-Received: <xmr:yNIcaTzm8Q6mhtNsmKzPVt9MMUAmwOqIQ5a4gIx8lLQ0mWSG2DA3IJH6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvvddvvdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeefgedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtohepkhgvvhhinhdrthhirghnsehinhhtvghlrdgtohhmpd
    hrtghpthhtoheplhgvohhnsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegshhgvlhhg
    rggrshesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhoghgrnhhgseguvghlthgrth
    gvvgdrtghomhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthht
    oheprhhosghinhdrmhhurhhphhihsegrrhhmrdgtohhmpdhrtghpthhtohepjhhorhhose
    eksgihthgvshdrohhrghdprhgtphhtthhopeifihhllheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepmhdrshiihihprhhofihskhhisehsrghmshhunhhgrdgtohhm
X-ME-Proxy: <xmx:yNIcaf26KhFFpsUivmrVFhTObM-rKgDaEfC2zz-v9EkVExJppHMvwg>
    <xmx:yNIcaSxvHZrLpODSMU140Px8A7i2ec7wW6bLtqhUmriZmnVfLlueSA>
    <xmx:yNIcaQJG6BeoorANBFQ22bf_jmYfsKJ4ShsrttygfX-HrSPLvyCzdg>
    <xmx:yNIcaY_XYy0V85f_vM-5tra11pYCLKaPoalvR53bkh_Q_lBlGmVbiA>
    <xmx:ytIcabAqBX1IJkm5xY2Na7fzL8IPkzZ-PxplGx_6mGsuM1UBrv418EQg>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 18 Nov 2025 15:10:45 -0500 (EST)
Date: Tue, 18 Nov 2025 13:10:38 -0700
From: Alex Williamson <alex@shazbot.org>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 "Robin Murphy" <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "Ankit Agrawal" <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 "Shameer Kolothum" <skolothumtho@nvidia.com>,
 Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
 "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
 "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
 Alex Mastro <amastro@fb.com>, Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH v8 09/11] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Message-ID: <20251118131038.32b7804d.alex@shazbot.org>
In-Reply-To: <BN9PR11MB52767F78317AF3AB94A5B7D38CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
	<20251111-dmabuf-vfio-v8-9-fd9aa5df478f@nvidia.com>
	<BN9PR11MB52767F78317AF3AB94A5B7D38CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 44AFF4000F
X-Stat-Signature: 39pxunqadq43mauzrcmikiziannje1x4
X-Rspam-User: 
X-HE-Tag: 1763496652-160674
X-HE-Meta: U2FsdGVkX1/xClIwrZHRU6/OB6elYqNzzm4sgDHSq+VdRiFcXnXf+SG+XAdOUH99jC3btzWX+bCRxCYLRb1vo9dzGGDQfNL0qpwvkO8IqKD9WQn/xt/Z6bUAUvUhLuFtQEuN3C0Ej48xJt1+TSqNBVP4+o5Xaa7g2a/gcPc++mzr5NeSNUQiPL4SZ6qZ8Xed/nvNdksYIJXq7AeSWfNLJyEIUJpCDMbEcJrABIeCa9NcuikfLPEiVqLXgDIVX6kFnth8itlfPAJeURuOtLGoUR8/380N/ZQoaJK7kplEVjQrAFF/4SEHD+TMuLYa+t7Eq1Q1iCBHqQEyX87jVf2s+FV8LZ29/22WVDXJVtbovwc46C6BYh3HZvNeFj3K8+qILnGB/DkCZECEhgpqKsSx/Cksc5dXfXmZDqFsKxiWh0gOelN4Q1UTe8FlVZWWq1R/AdzzYk+dnYpsPjm/0IGp2viRiIOmkVRC6x3q6tWXopiqY/Xak6T5AjsF6E1pPjJL1yQJwExgnDdh20Vuc7FepsObBIl59KbPVQgr67+UhRHMPnWeFVknm3Kqdj7tlzxwT/kh3CffozrmU59YS2DkF+WOz457bROsxzL47wCeuUJX11iz9HPuBrBQXL40/Odpskzm+N+i6HRP3/sRFd3qxXG62VzqK9NAkpGUpRH21Cy+zJ0S9GycTbbRWu5Ws8KKNazPYzvt3b+IaUf/yQA5BdgwpM1LgRyFd3FtlCKsxfgF1uVvSeKynrdhp5KAvmGvXrrRDKUbuhab5J6N2CIh+ls9e0CtTk6f9r/E/S1fgJEv1MxRujnqngrcvC7N/F8bIQDrcQvdd9nMFhOU+DGVh5dELZgeQ1qNgMlcUorV3gpQvgyd9aodXx0BJBTmpIbA+DYallGYdSZS4yVEFjJAsdMjb835WpGXjXbv8XEQFTCJcuzHdx79Q1B5vF3mm8odzJ5uJ5zg7p7sqZ+C1lF
 DYb5S0n6
 dhs4t/AZd3IcM/Nz5upHZenVBauv2DOAkjfOOPzXHeNbC8PSzRElhvVbzHNoY+undL+HGlhUDdCshO6f99Lyx62o+btoegLTTh2ywquH4B0Tk0fv5h8XI3OPgYdo+UKLCs8RsG0MauVx3HikDENw7W+dHhig28ULkrvO5c7DuAJxU+axN7gbHinTDUzK1qmMYUzoxrUCqNTgGV8/WmR1n39ydv8HbZIsfv9SVz5EepXa+/ns0QcPY1dP8yuwsZCjT1m8HF8huSsB1xlMHYjQCcTBAfFDlDRHUEyfHRfYEQRLMDIYUrWqKl5P2l9YhD245ii9+jEGaoRpwrlldn0223o1mygCzJyjzdfau6AA62kbhGa06IJVcrElxSalKKVMZhyMdhmu7YVD4X504GhcYReUyxUgRmlMRZao9p0OKIbSwqeZlnRzH5JsV8Cd6DixbOIL6XZQHEKc1ihgOAaJJ8dGS4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 07:18:36 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Tuesday, November 11, 2025 5:58 PM
> > 
> > From: Leon Romanovsky <leonro@nvidia.com>  
> 
> not required with only your own s-o-b
> 
> > @@ -2090,6 +2092,9 @@ int vfio_pci_core_init_dev(struct vfio_device
> > *core_vdev)
> >  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
> >  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> >  	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> > +	ret = pcim_p2pdma_init(vdev->pdev);
> > +	if (ret && ret != -EOPNOTSUPP)
> > +		return ret;  
> 
> Reading the commit msg seems -EOPNOTSUPP is only returned for fake
> PCI devices, otherwise it implies regression. better add a comment for it?

I think the commit log is saying that if a device comes along that
can't support this, we'd quirk the init path to return -EOPNOTSUPP for
that particular device here.  This path is currently used when
!CONFIG_PCI_P2PDMA to make this error non-fatal to the device init.

I don't see a regression if such a device comes along and while we
could survive other types of failures by disabling p2pdma here, I think
all such cases are sufficient rare out of memory cases to consider them
catastrophic.  Thanks,

Alex

