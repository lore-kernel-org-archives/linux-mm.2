Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A117ECEDD93
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 14:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECB736B0096; Tue, 18 Nov 2025 09:30:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7BE96B0099; Tue, 18 Nov 2025 09:30:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1CC66B009B; Tue, 18 Nov 2025 09:30:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B75A16B0096
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:30:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3DC765944A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:30:08 +0000 (UTC)
X-FDA: 84123962496.19.D936774
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2FAA8180006
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:30:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="nFXaS/YX";
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763476206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gAj/lhLwXUkQIe838UyunLw5D1V/iLtJCJGMnOEEnt8=;
	b=aX0IK7ETH6x3aaqWVaYZte4o9lYSBQXZIVG0+EypWnbBeYqjLHXcJ+CerhBYgI1D8tkukJ
	vr2EGbTXQHHDB1UD2nnPKOM3/Y+tOLntIqzZ0vyvH7wiMPdXM5MF4RsU/12pCyveB3ROax
	vHmMpReJFGs1/pV+ZMhjl6d4sdAzLO4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="nFXaS/YX";
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763476206; a=rsa-sha256;
	cv=none;
	b=CnwUtBGCreiRYKbwX+Yo+tje+vnPZeOkMxzYBB++ZxZlkElv0WtkE/560nwdEwPNtrI3zC
	aCoFsrS99b0qxmUaXYtFWLDU4nqEhervkqwTHMaUswhawuNO/pV1QGXnvqPLOcW5S20VfU
	9YBhqMDBVIFt9tF/S0kn0Q3PaU5th8Y=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8b2d56eaaceso324858185a.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763476205; x=1764081005; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gAj/lhLwXUkQIe838UyunLw5D1V/iLtJCJGMnOEEnt8=;
        b=nFXaS/YXPjU6xSOe8S3g7/GeuNxyvTxCNh3TFVIux/D9/NE+A7XhQlsZ7A98//P8fe
         +0cWW4v5GBgUKeJXYYRxeP63ka6kaH/nDDu/w97+D1MCAd6XckRFSTuUIDrRDwZ6IcSA
         gFMC5aCsn8P2it3h6+ZVhSRiUnf2w7NtGtG5OkkMyaqqXgeNjVum5RPlpQMxdQGlZTj7
         +iQlFTJ4u+BfCx0QxREbYweDdZacB1diUq72ddEZtxNEEMwtvGFdRd+ehggBcoHiQee2
         R/KpWKn5OH0xHUwkBlQ16JDi3asiMDg+1uTf9iKcoB0tbm5HiKbOQpworn4h3/bQ390S
         H9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763476205; x=1764081005;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gAj/lhLwXUkQIe838UyunLw5D1V/iLtJCJGMnOEEnt8=;
        b=o9DvOJbNcMwR/1xj+fnaSf+srSyDVKGLTzEl2QerCJYAr8p03VjumsbksGQ8JXjA7D
         yZKsfCjV/1BpwlFOnqJx3hGioEz6Yzw7uBVnuG6slqlZHZ9ciTgeY4Q8JUuqMeJypBED
         u4VrwPVVN6wtXWJIoVvjb4Fja5/suU2IAQoCRLiKKk9PYuXJKDD+PYZA0fqkZVwA05G2
         QWGAZwEHjT/T86N+zfbHKAJhdXEh/HP2vZc9pbl1QDnh7QgtjxQcBNclptSN+GumiOXL
         kTDpQ30hLuRzZ/G08btlqLBbjzeWo/pN8OII2vcHcUuJAb9ibcJdxENXCwD9bkI9z4Sn
         IVjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvf15RORYuI85ueuFrKMGSsUfw5dSzzEt/257WS81nJX8LTwrwgYwR1QwRxQHRuGbdjQ97L5pxEw==@kvack.org
X-Gm-Message-State: AOJu0YxLqpQL8BGhGZ1LoZqP9/lsdaT0rZyPMzIa6GDVbBXf6ZQoH/fl
	/u0vu0WPATYS1NOQZ6Q55YkoRHvzDgNjxu8jGpdE9iCn3AD6BwnGxyukH0o/Uoq4mII=
X-Gm-Gg: ASbGncsTZZ8n/jStMqsVfos0kFNHHNZ6N/hv3HmZ0W44LSGuiXLtSaXvQ4UUmJTJGmV
	TX222HMif9fnA3FDZzVMp5e5l7U2HzDcfaHvINB1VhGlP4nVlV3/cRCcSlyGYVFOvWL7ZlBMOYi
	QMGyYMjUQqQ3OhgbT8CRtVssIWpJVAmu5byT2g9PSXFcbjVMODn6uxpwBT2BRDoZBO/lh91qaZH
	YmAZ8My9Hv2RBbXI/ik0FXUFEThUACPA/SwRS1qFHuZoksjhZJpmDyQMVvjb4v/lNKWDbXP0ydW
	xcDdCatHTJmHmxgmlmFjIIMDxB0uFieb6KwuekeTUEI7ymQrP57KMuYgmc/HRY+TC6QrvSsfpwr
	BZz3bd+PU/Hyoiod2V9d2YG+JoodViWroBycRL3DcPKysvENuJzc+3eC+0Nnhx9zWVBeZ4tnRDw
	KH9cahZ3c9Vj2RlQN3ca6+Ea7QsRpuMeoMIaFlCSxswn6QS/PrvFNSUtH1bdsZHkh87MA=
X-Google-Smtp-Source: AGHT+IGl2QxjkDkgi5jKGR6lwtLy9hLDUjSd3xhjzd2vh/OGWRtCENW0fUVdt2sQ45uUuO7DIyidjQ==
X-Received: by 2002:a05:622a:4a15:b0:4ed:df82:ca30 with SMTP id d75a77b69052e-4edfc875136mr206770331cf.13.1763476204719;
        Tue, 18 Nov 2025 06:30:04 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-882862d0944sm115395396d6.9.2025.11.18.06.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 06:30:04 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLMiZ-00000000NFZ-1yj6;
	Tue, 18 Nov 2025 10:30:03 -0400
Date: Tue, 18 Nov 2025 10:30:03 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Ankit Agrawal <ankita@nvidia.com>
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
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
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
Subject: Re: [PATCH v8 11/11] vfio/nvgrace: Support get_dmabuf_phys
Message-ID: <20251118143003.GH17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-11-fd9aa5df478f@nvidia.com>
 <SA1PR12MB7199A8A0D17CDC980F819CC6B0D6A@SA1PR12MB7199.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SA1PR12MB7199A8A0D17CDC980F819CC6B0D6A@SA1PR12MB7199.namprd12.prod.outlook.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2FAA8180006
X-Stat-Signature: m5mrtsbisfpfuc4tmn6gxhkb4goczhdu
X-Rspam-User: 
X-HE-Tag: 1763476205-335716
X-HE-Meta: U2FsdGVkX1+m7ftDUTdW6LRdK2Pr0sT8iG6NkqqozHSVUwevbvWC4S3pVXDZX2gldla2iV0CQtkhcGR7YDQg4Tp2P1GQGSxTdvmN795WacWbIgiVkXb4L1e8HGwolsUIiQDadWDjLvMcQrhgWxmSO1fNNsnVtgw7D+NLhH/v9Zd4PePE8oevNt7/VADoRD9jTO+JY4O8zpEWENpOvXCcP45lHfahO783ZR3j9ZvN529oXIKWq6bguOwxRRbTM7JnNs9mrwaYVx3Pwk39CogHvCPDQ6NyINPUvBcBPidgm5ozGnYOAPco+hktBwz5IMo9HwFCOOWVS4sBJCvLl9Ape81/bMYMQGWR/Y4kF1/U91w/NPOogc5ErbkxJ6ZkmISMkrwwwfiUebW6FZUTnUHap94A2DZ2FfZwqVc2LToBwnF3NWBU5KZ1hqOrJRG5zJC6QSER9bAs+kC2tVFv1waeRoJhVHbNUFl2r9DSV+rUsWE97GqQwdCV+VksV+hF83coZjGj2ujKd+74wgabBRPbS0Bzhy6rGGQf4JcSsuUydDXG0o2RLJK8qvqnUxbXH1T1aji/+zwnIeMU2arzTiuc2DWxCSU4qAF77/yYckFczRRDVqtgclGCqUPpmbhGrYtSL61OpCUakoaP3wTSN4GGenM/oYx30jb6lPNLJoDh87/wn6+UrnQZAG59rv6bolbr2YC9HHiL/Un9fAoNmtB2LzyRNcQTLhq7dSzs9Bznpa1xyDqTepJfhdG528stsBmTqDHJlBGFI1yGgN96fkVCN4gH5eXB8Hb2RReE8iP+yUQPnJ7q1c75ZrxoUhhE5OZW7MrfPBC1VzJLD1RT5C7PezgW2h6vVIu5qdcLHhNYjuF1uVOIYeuZLNYgAekH4lOxQe1Yveyx10GTUOjx3NWdC/PFH6h9ObsPaO87qZQPaQ6PctpjQgtRGjjPCJhZpwKRNpOdavn86J6AbtSGC9O
 ma/h31+s
 vKi0BYcTY+ezfhGE6Iq1cXGHjZORa+iFdOnU8QDvjkLGFQ4ZMmvpNMlWJFk0NoPC4BUWc1gF2djWdZMmFtAN3AnOLjtrpicGcPbps5ncgj/Ptv8sDva+msXMfWmFoQGurGCXCAYZw5rIs3uXXOg3h+kcaJ25cnRZzYGM1Ro/JLAozabs+AzlS4I3TII6p8PviXWXiJEEMpYoiswzN3iBRvBPDaykPgxstO5FTFh4p8vaMODLoKAo4av3wKv8vZ+7aYtLHE4gNT3M2vIg/08rz9dUUT5SiiHMlIw5Wtrs1KiAfXHo3ibUJlFjTeIVrUKvG3i/qyKLrQR60qi8xtVG/QaSezFSaZhHUuOmdHx3w91T7WP6LNMmIJXvmvqixdCV4QAPYGi6UbT/Ega8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 07:59:20AM +0000, Ankit Agrawal wrote:
> +       if (nvdev->resmem.memlength && region_index == RESMEM_REGION_INDEX) {
> +               /*
> +                * The P2P properties of the non-BAR memory is the same as the
> +                * BAR memory, so just use the provider for index 0. Someday
> +                * when CXL gets P2P support we could create CXLish providers
> +                * for the non-BAR memory.
> +                */
> +               mem_region = &nvdev->resmem;
> +       } else if (region_index == USEMEM_REGION_INDEX) {
> +               /*
> +                * This is actually cachable memory and isn't treated as P2P in
> +                * the chip. For now we have no way to push cachable memory
> +                * through everything and the Grace HW doesn't care what caching
> +                * attribute is programmed into the SMMU. So use BAR 0.
> +                */
> +               mem_region = &nvdev->usemem;
> +       }
> +
> 
> Can we replace this with nvgrace_gpu_memregion()?

Yes, looks like

But we need to preserve the comments above as well somehow.

Jason

