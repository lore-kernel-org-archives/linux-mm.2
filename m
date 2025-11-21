Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF25BCFA459
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 00:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 473D46B000E; Thu, 20 Nov 2025 19:23:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BB36B0010; Thu, 20 Nov 2025 19:23:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361866B0011; Thu, 20 Nov 2025 19:23:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 230476B000E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:23:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D56DA140222
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 00:23:48 +0000 (UTC)
X-FDA: 84132716136.08.C0B951C
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id ED753C0003
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 00:23:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=JyTPGtXc;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.42 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763684627; a=rsa-sha256;
	cv=none;
	b=MWKuypL34cMCCPqFZ9XRY6tvywh8SAUw7AAbX/B+HW6M1PlJ6cc/pN97Fbvu4FUNVU3iJu
	FY5xxRpIA+KuAIuKly5LrvbPFNAEQbv03u6sU5F8r6DZikS+TBNWqoTjwCkbo+rF+W4yuj
	qOvzJXbTG1zzWjVxn4m5NACrYIelebg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=JyTPGtXc;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.42 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763684627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HeoQ6A9zQA47pPVQ4WN0R1Mr0WB5BGBDvzJz+/SIjn4=;
	b=vltaHLOhQqv9JkQr7gcZGpWHEJuSPSLWH74QvIuxwHSm3mWvZEu3Eo2pDiIk2qgc6tHOS7
	zDTmXnx63t3mmzlZMEjHx3cQKxVQ6ojqKoWdHcflclBn4hzqj0m/cmdeQVkIxWUzAG9K2u
	gqccs8YkwirRL77hMCgJp1MtGBRGBIY=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-88242fc32c9so17085746d6.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763684626; x=1764289426; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HeoQ6A9zQA47pPVQ4WN0R1Mr0WB5BGBDvzJz+/SIjn4=;
        b=JyTPGtXcWNE8HXH9M4seqVoZgQjdpxuXisMu4dKIYcfGlXvXMHKAscJcz7byJgIcBk
         RJCAXAeHheq010gVf8Gcj4WrIrkFqP94F7YgdvF1DXw9QQwtgpHgjRk1Y+/GM/hcw92T
         gzervTKhljRPKO6BbqELbCh4nq2xsOnk21td0rmR+MNTZZPkMUQRyrYhB5L7kBUirxBi
         exxxSSZOJVsoCGTytQyEvks8DL2BLAc08ZnkhM47FUSZtEhWV+IMuAlBmIvznL3qhAkm
         PPTOAfVlNv4D6ENPTWrzqG/OyC/DjaRDt7PW/6siY2UTyVrckXNM7FeMECxeHcefXwtA
         QTpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763684626; x=1764289426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HeoQ6A9zQA47pPVQ4WN0R1Mr0WB5BGBDvzJz+/SIjn4=;
        b=eDPdG4oE56Q8ysr95dqkkUZJSnmBvksctQrPl9rtnBSsmLVT1t6hGH/kjfcRgx02Na
         Ofw/EprJC8p7vSwatjdGdeqqkwzlVJx4SPw73Dx6Ks3uxv3CuC2y4Xvd/EL7N5E6YvSc
         NY83NArvvEPDTr6ZHo1l8tx8+iG06S0bzS9Z7y32jRqHeOcTRakG3LyJRz3uAM/o4p8v
         XLZJTB92Zi98cPgopdkPRj/HCqGUfkCHOsEJszOEumlMXjUwbRuCVdCKKZ1LuXcp/2EQ
         cS3Q9BHqWWJDRgs/R4V3X+lifa0RBpe3jqHEBgrhjO9OWZa0K+uc7AsBb7ub4Cj4k0Pr
         jwFw==
X-Forwarded-Encrypted: i=1; AJvYcCW6ZdtFzLkKOwnPUAAu8/gS6u7DfmdMmpD6+Vv6rX76BEiQBS4sC2o+GecJr8lVSexQROnrAf2yDw==@kvack.org
X-Gm-Message-State: AOJu0YyRNmX7w+fbwTyJBibmaFNRadA9tz07Nbv56JcbChkBCvXUeDES
	v9kHbHV5L+lVJ/MzrWXeWBIFT1GEq7SnuE5U21UdiDWth/+u7/eV0L/FIDOOSDloloM=
X-Gm-Gg: ASbGncuqcZM68gPVP8Z/5b7KnIS7KgnJ1SSB8t8nCeGh24vr9h4rkigDPvIzpoAR64J
	RV+z3Q08CkYNYgycPlAryYDi85odNW8hrgqpee1CwbUPeRuVHuHmXwIrxQl6TMgaJkaIzOu11V7
	JGTTJxIAJX1JeDpyGaLXmCHKskjJDt+eXN3e/6kYVK9zgGAG7gVMhv/wu5uhGP5odA7fFaNjXpi
	QT0S05MunXD/sfF9kToDL0VMYOq5U24vpbBb8JOViK1H9LUsJa26XoAchB+d5vvgTP6iYzmfimy
	blQUU+Q46ISqLhNowSTxW7QgLdNIKqUdeW+JJBK9L+xJwf1OLbQO3Aulo1AmRDak7q+s4A65hkk
	egRq4PTdUNucIB1Ib1JYlMOn9wh2FsAaL8GExEsgsQQkNXVxroXH66G8LqbjyOrHO30LgQYtlPM
	bPzEQUwlVL3n24sRG1DsGX5lrJKtGraN91+vS/o15exP47ugkcYwyE3vHP
X-Google-Smtp-Source: AGHT+IF9fpUZC0KSEi60qYSTXqU5TN/0kv3Br6v+7st2smYcT5XQOEwOWy/F2amvDq4QuChbOli5Vg==
X-Received: by 2002:ad4:5d42:0:b0:880:2c08:88e with SMTP id 6a1803df08f44-8847c5206f8mr8425876d6.45.1763684625945;
        Thu, 20 Nov 2025 16:23:45 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e472ae1sm27645766d6.22.2025.11.20.16.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 16:23:45 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vMEwC-000000016i7-2ZE0;
	Thu, 20 Nov 2025 20:23:44 -0400
Date: Thu, 20 Nov 2025 20:23:44 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex@shazbot.org>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v9 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251121002344.GC233636@ziepe.ca>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
 <20251120-dmabuf-vfio-v9-10-d7f71607f371@nvidia.com>
 <20251120170413.050ccbb5.alex@shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120170413.050ccbb5.alex@shazbot.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED753C0003
X-Stat-Signature: urt498jgp1c69ocnn7ed5e7c94bq8zuf
X-HE-Tag: 1763684626-10861
X-HE-Meta: U2FsdGVkX19Y5VqR68Ru/496rQko5fgUkz3w3i7hFp/FF3drpzLyl8bYDKM+hfx5PeheDS0Lv/uZ/kISb8obk4XfmLpbMYJUpFrpYLbIiqCEh+yeTus4fpBiU8mekB+r4f+ZwG77c9CdXviTrMMT0grmHdC4QC94YHLNLB1Rfns6l1IZwBAJltMVE7gUlGVprbj15hcE+VM3BTbJBoagw/ktTQDOlpAf5HrtO94mumz7zBI1CHB/uQ7qIbpfdBMhBdDu58CBavTMNxvM4Lk0l+naWZnMBI20AcuMhFnRhLoVynkngCGCW38KBu2KJKsY27FCIIMLZmPSL0GzEVwMO7UA2T8Y4Y0D88Y+ubcz057osQuXPOw/jB+UB1YYPMHvmDb7yBJv0a+u+cCtec4jPaBMDGrTUtv+QUKy2/NKXDPRfE9N3wqKmt6Sh1fCKpeR5IJq9KCTcOE5L0N0+pNGUDQIIc3r1epfvZVRGohhtX4UQiE34SYz5ssjMtF+wgu+Rd5EEuIAfM+zX+5hwCC81Wrtbw87k4/3DCADLGvTVC9/+cTBWfZ598udMMP8JE/sVSxrBMxs9+volaZ5YJANfqxKG2n5Lx1YUWE5l7gw9o3g6YSbM/ik4d2VKMWDc+GuKnliM9dWr8hDBLd6sHCyo5SlnGX9tAMxpP736OfssezjJ8r57hwUsRg8FIYs+yulcPE8ghtNx5J5QNjQICS+qm+yfiAGCkI95PVGWBQERvm5tbPVqUERU9F8mbonS0YrCwZFTEc476+NIf45buP1Qb75YnuugKqaJrG3DIUUBoSMsYK9gOpCnPIqpidUG4YsU6VCN88AjtcwEdjHkd0uQFdO8KUZNq/GcNOxYsZ1KfTDkqthpHPXkGUabzlhV3tRRjh0kBSvr9QYB4dX4iEZi97iAzh6XDP/UoKs964qOZWFsc6hTM9dMwER9R353ONVeMneSofRVk7moklbfUr
 Z+MfiWZy
 f8bV4q0TThRy7e9AORd2yzwuNsrQlEjsJr8WEZOrjdQ8DzAiv6cbMncy+rHwCxbmpmQXNB7ZqUXL0C1g0GGFLMnyKRrrLaPrBLyzFXENvCtih8IaWpOjPrji9uyfxVexdtshn32Z/0zlEOb8I6v3IrQDueYzpM+YeRJa/9BvQhG4ubLokVH9YMUDqgzEo+DQtsqsZrGgUKdU2DvM3cCBTdeI44VX739ahrybpJccId+wba5ybWYCTUIPYjiYwE4BX/Kfa9wa4C55PvGlqetLPORs/E9YnRPuNT5RV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 05:04:13PM -0700, Alex Williamson wrote:

> @@ -2501,7 +2501,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  err_undo:
>         list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
>                                          vdev.dev_set_list) {
> -               if (__vfio_pci_memory_enabled(vdev))
> +               if (vdev->vdev.open_count && __vfio_pci_memory_enabled(vdev))
>                         vfio_pci_dma_buf_move(vdev, false);
>                 up_write(&vdev->memory_lock);
>         }
> 
> Any other suggestions?  This should be the only reset path with this
> nuance of affecting non-opened devices.  Thanks,

Seems reasonable, but should it be in __vfio_pci_memory_enabled() just
to be robust?

Jason

