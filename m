Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12566FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 19:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7746C6B008C; Tue, 28 Apr 2026 15:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDF36B0092; Tue, 28 Apr 2026 15:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C6446B0093; Tue, 28 Apr 2026 15:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46CFC6B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:45:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF5A414024C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:45:57 +0000 (UTC)
X-FDA: 84708995154.01.30B764E
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2133640003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:45:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JUnvWVvv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=vipinsh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777405556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQ/Dt/O+th05aIC11KQd/tiOeex8kzc+/1s7j7TCtCI=;
	b=6mf9Zqpu5kVlr1NwfZ26WSiPnpna4Zle1RPL3KLAyEGLcAH7o1PXHRoh+tTCB8oC5bcHeS
	0Nqm1+kn88wtwK/Qf/T7WIesTCtWeLwAeOKMI1eD27u1W9gq1mTo5CT+4EG/QiJL3sYXoO
	t2HpyccyyI6SOiOHCLe4P7biuFWk0Tg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777405556; a=rsa-sha256;
	cv=none;
	b=sCQc1D/C2eMcRqd0ch+Kw/CmEA5Snz3Dn25RLHDKtcmiMdiXkyslriTrUgUZaJltyJCHgs
	+LOqi+rYOCBKLbtXdpmGilK2dF2KYTPU3AC4j1eqTApokpPelVQkRHrD01ovjq05OsG/Ik
	YffY6VoBTyJhrjBu0+PdOx+mjPOddsE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JUnvWVvv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=vipinsh@google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b243198058so9935ad.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777405555; x=1778010355; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DQ/Dt/O+th05aIC11KQd/tiOeex8kzc+/1s7j7TCtCI=;
        b=JUnvWVvvxMK6E4MnmaQVgpLUqdFQURGPavpesYmX6WTjs9FV9tw9wpVKd7MORSgUCr
         +8UvJZ04guEi6HGN2a4rE1CtAVjxmuD3ooHfyRWH20xSDvDEuJLqXUNfiCmkHG8P9qi8
         g1O7rdgcGzJpvw73CKpr4lnAEMHtwB2TrMnMjtOka1xrusDm5sedXK4ls9C7dZklysIc
         NpdCEXoQIkchuCYryPlE1eL+c1T84LZ42KzdP5VV3fdb40Tcm0suQUmVgI3aOSrIgHbx
         v04KP4G65iF9783iBCDt441k3rg4Dq2v9Sn3wz0Dj6+nmZB28UPzqXCTrnmZQC6EEDVQ
         EIeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777405555; x=1778010355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DQ/Dt/O+th05aIC11KQd/tiOeex8kzc+/1s7j7TCtCI=;
        b=mtblhqf8rs1uYJ555VgqxMAWwRfvEkImBQvrc3+hJUmTqyso4/w6IUGtfcEdGeXbQf
         lRog6IWCk/iS5Ka4Pg1ZbyRGTPn+GBbnKsamT9Zl/NI7OcvsNW+331fEvopEQoJd/ufj
         iJy4PhvSJ2WrgFFr5TYdYZaMbU7GsHbyQwWyIAJOqdl6vjVNZJv939pSxrOPRYiwUSZj
         V++GDy0upDQ2v9KdoCgDZynHuCPBYeikNKmKIC/JAZR84xqOk4B7HZH8suB4nnkQhEza
         pWnmuSIJJ9BhBuyo6DxvpW7AUxaI/+SAiDrESDvb5cnHq+aOH/79GgKgthZ+mNu8o8rX
         KI1w==
X-Forwarded-Encrypted: i=1; AFNElJ/fOHAuNIu0+dyovv3wzOG7gtd+n4N4TtyHHDUkeV/HL6I5UCgLioQfl+orEkAZY0oDYEYvwp6NYQ==@kvack.org
X-Gm-Message-State: AOJu0YzuOP01xKXs1tCYxiW8EU2o6QJOqOYI6QmMKjZHSiLFWjgPYPOc
	Oz1csQ86txgB/ln3tZCUGVkvumjl4uoQj3l7d7j6ka6h9F2HgaY/+qXkSFSelDot+Q==
X-Gm-Gg: AeBDiet9uDB+rQXkHu7VP599WAbS56h86eRsRNbSLdaPQCxkukx99fgWIze/LgjaFgZ
	MlPpgKI3uw1WaCTZIQo6064v5ozJhB8VXaniAFClns/BsGM4CNA9lQ88KIj6WOPuQ5PllWgrQIy
	EfHJkuuUdCge4FJDbSibdMXFP+8RuQEE9brGFnR4giVU4wiqqEjkJUx6TiLWGcEMGWAHNq/VTTi
	XrCmMgaI5xx0QIH3ERvgfrrH32RbBTC+zbryLM6xHCvnjvYKtXi8jjA/MKtgIC3VW/VCcWwuRj7
	IrJxKyKwvG4cedzQm+IWpnXeDFtZNY48Jo3ewEggG3LvRMCsDXpFT0rq0pGYA/ArTQ9JrKXyt7R
	6BQEav9e9K0cEwvi9DB+nmc0f4Qz7o/2EBB5HABf6nKRacfY6UtOfAxNKQhfwb6tsIkF/xqvy2x
	GR+JfOFJ0OboLWgxm4jPQT6NRP4+l5lc/NmFuBIonFlaDgEm+fxAc9NB5UXUZ/w3Iq8oaiQRKwv
	hbEDbDCgPNw6vLLFA==
X-Received: by 2002:a17:902:d58a:b0:2b2:5931:5950 with SMTP id d9443c01a7336-2b987eb5398mr770645ad.16.1777405553961;
        Tue, 28 Apr 2026 12:45:53 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364a2732502sm41657a91.3.2026.04.28.12.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 12:45:53 -0700 (PDT)
Date: Tue, 28 Apr 2026 12:45:48 -0700
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 01/11] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <20260428185242.GB3825533.vipinsh@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423212316.3431746-2-dmatlack@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2133640003
X-Stat-Signature: foc3xyffpbrk5bxzi4jdcxtdfbytxpox
X-Rspam-User: 
X-HE-Tag: 1777405555-491516
X-HE-Meta: U2FsdGVkX18ieGM8eW6TTrDLJkY/pyXn4AF/J76RtvdJB9hemitebEnCSdvwuDRhdWyFNbfNp+xqdBU76TAcoSTmVCWG7W7M1Ym+x+2Uwcd5vOUPT9U0MN88tRTXrspQHmhLGTPqDH1beWllabLxVWhFPkVPlT6yOzW7tgJBCLXjlccySR6sKEtVdx0c/lArAdbMyFcE/qplm4lfrGTV7y+fMGHjiPzOimpJZnNvFEIMpROPdh3mDSpcxOKDDUd4HEEgE6+KGi2tQy9wvHw0BzTIbXOXUrRosmbuzv+gYPh38apoT6D87nMFYeCIoSV76UzDmYa08sJEv7iIpib8xEhhR9Nj6vksaaiYS8z3LKtGA6JTE81ssb3Gyvw9HzBETLpy7Mt87rPjH2NVY6WlryuguJRHMIu80SGX6uuAK7cY1qVfxtLLKK3NnT8pLaLk87KsI0euvUB3XvW2cLUsQbw2K4eEdybmZw0zQmK7kynmmv0aOk8Z6lSQe+TZ9VT8MHbcv6tpjmiKtb5YKNvn4RbjJoFNs2RP0rQDSHujethvDtOYrSq7l7RAzqnGK/OmpVj4gwBPBMRp7PTtOyiskqt2u7TNhEDtz5CiCCBMcvFwMl9BI4NNAcAiViLc189UhoMFtVe6CBYdQeMz0GjizH9Ma2HwmNNNP6rV2H62IXRI81vzugZ5dTLkkdJ67LqDIr62iNCcXDxA2dCCo6Lm8lfod9AI/6tr3jJ1FG78g7dgCBfrEtzX0Gz/CaOjl8wSmvZv+xikc0D/mvda0gau/Z7hLXJt0DI7KQ7zu2z63DZ/qEpizYf/j+/02JjObVAk5+o2DPgXcgblKLoaOiffne/ld0ccqY1/ZbRglGM3eDLcN/XJlXTOiIuw5ocpV+QjcyGyvFiZtL7iA7/u58rWIe7g61ui8MhmTtjgQmHHbSLM2W7F7+iHKQozW+YQqlvYZQZGnlXMR/BMiFSrZRn
 Xf9OxlHO
 hSBfQLoj2SnFfzbsIiXfLJDQti1kVbZqwmrHVbd+amfdyljvF9hYE1PH3rOdWv/s875Wes0y5xT+n2b+HhPVckDvBsWOfGokLnn11e0Ilx1+fzwIga5HyK0fk9CcO72J5Emac2Jcqd6cv2GxB4VTcVoOHx+ykV4NfUoZGP0bl3NIguujL2/4tsAFQxvsa66Zn96u/CEMbw9iSLlWvh6GBzDhP9s7zgaD1frMcsyp420b2qVOaiKx6n3upVZd3PQtD/TWKlmBc46733SY0fmFa+UHZDxHZEXGqlUFoAGYQGQBDhJS9WI1cXhdR1Hwil7kkGgcHSfVVwErNAg7hCRw+vgmDreNRXzrLNUnk4ioZvkpHXnEz+bWqAxX6RBZ1qEnfwSux/J3/zIT3ydPKWTrhcLQRfREsXv7o0Fr2EJ3LMzxigswgB4uWK0KZ5j5ZCW8mRhA3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 09:23:05PM +0000, David Matlack wrote:
> +	pr_debug("Preserving struct pci_ser with room for %u devices\n",
> +		 max_nr_devices);
> +
> +	ser = kho_alloc_preserve(size);
> +	if (IS_ERR(ser))
> +		return PTR_ERR(ser);

Should there be a similar pr_debug() in case of failure to denote that above
"Preserving ..." message didn't finish, or, maybe just print one
pr_debug() after the error check above?

> +/**
> + * struct pci_dev_ser - Serialized state about a single PCI device.
> + *
> + * @domain: The device's PCI domain number (segment).
> + * @bdf: The device's PCI bus, device, and function number.
> + * @reserved: Reserved (to naturally align struct pci_dev_ser).
> + */
> +struct pci_dev_ser {
> +	u32 domain;
> +	u16 bdf;
> +	u16 reserved;

Should this be renamed to 'u8 __padding[2];' instead? This will allow to
just change the array length based on the need (0, 1, 2, 3).

> +} __packed;
> +
> +/**
> + * struct pci_ser - PCI Subsystem Live Update State
> + *
> + * This struct tracks state about all devices that are being preserved across
> + * a Live Update for the next kernel.
> + *
> + * @max_nr_devices: The length of the devices[] flexible array.
> + * @nr_devices: The number of devices that were preserved.
> + * @devices: Flexible array of pci_dev_ser structs for each device.
> + */
> +struct pci_ser {
> +	u32 max_nr_devices;
> +	u32 nr_devices;
> +	struct pci_dev_ser devices[];
> +} __packed;
> +
> +/* Ensure all elements of devices[] are naturally aligned. */
> +static_assert(offsetof(struct pci_ser, devices) % sizeof(unsigned long) == 0);
> +static_assert(sizeof(struct pci_dev_ser) % sizeof(unsigned long) == 0);

Nit: Maybe move this assert to be near to the definition of this struct,
easier to find it when editing the struct vs finding it later during
build.


