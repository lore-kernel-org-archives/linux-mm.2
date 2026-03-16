Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2EFEF53D70
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010DB6B0311; Mon, 16 Mar 2026 12:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00C96B0312; Mon, 16 Mar 2026 12:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE2476B0313; Mon, 16 Mar 2026 12:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF5416B0311
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:28:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B0BF1B73D6
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:28:40 +0000 (UTC)
X-FDA: 84552459600.22.2A2B2B4
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id 750B5C000D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:28:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VrUlTeNk;
	spf=pass (imf22.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773678518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdY0MHpBaQytGDjrwl6No73PmmhiNXL6flXFjxFT7cE=;
	b=fIo+X6akaGR84NpIR2q/HL9O2IIsTisDrAqVnxWEs+ogvbCrMuKWT94L1uYsXTJCCJ7cnI
	Um0yYQJyvApljEpqjdBF+2Gf3u4zMajsiQf6h0+t16QAL++4O+6OMi2Rw6G0ixaCaqVuU8
	F4McfVQJGCUtXZhmtUpLVWkx9GMdzTU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VrUlTeNk;
	spf=pass (imf22.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773678518; a=rsa-sha256;
	cv=none;
	b=J1vzvujIVmwzSpHebmDwLyShW8qQ6cxlL8+blVnjnbc9y2fgfucFmRQljtYFePCFWSLkFf
	nkUOtAAcWbt1VEK/QmOC903ZM0EvBzqSRyMuHKHcSm/Wx0ifAlq7cVY0u0zAw6Q3Uf6yd0
	aEphZv4QIxfo6MGFx4yGhRPMEpx9ANQ=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b052ec7176so96865ad.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773678517; x=1774283317; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bdY0MHpBaQytGDjrwl6No73PmmhiNXL6flXFjxFT7cE=;
        b=VrUlTeNkq04kRhmTUXJkRa2keHvuTeom1C30rioM1rVMykpIPc2+NnbFxsEnTa/ObI
         1agy5rDIA5rYpy8l930iz74F0nkA+FbyIPIU7e6hmsONlmeRdbYp5S6LGtsfZzrF6eO5
         i42ijrn+2dtf2sRkoA2tiLFmiOTugrh0qJYPWXWyB96hCFyAX4IeZ0Fv9jhZoepwxg7P
         JgggTXcMR//0mgf8PSRxL9VFO7GL+SOvEmdwvvTWGQmgJT1nLyIVIYPDxvsGYaWE/RUD
         Bv9ucDcvFhTvti6DDjAZJ0YZDI9r1MdSDl7mhDiaQ6V7x+fJgFOgPOj4fm3NbNU+Awow
         KUug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773678517; x=1774283317;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bdY0MHpBaQytGDjrwl6No73PmmhiNXL6flXFjxFT7cE=;
        b=DfeCjDss1Te90AV1WYbdRR5zf92BcGJlr0jJZeij7XijbBEq+nDBZVWzbebjmRC4dX
         dCpDNHwOsiD0qFIpuUIF55ak5dA3DvSIkRyRdPlYth2725gwFenX07QUAttZ+IeTHMRh
         SymR4XKcRM3YLjUSDP4QIbE4j2uFq7vEu0qJhX8YnyIOv1OzxsdI0xrN5/Y2Ih20KM9X
         59hsnX7ClkN/SgQsUS5CLTny+vvZGzeyburq+0LkaWBHpPlV18rYKxIuqM33YBEVLqCu
         NTyr1jF5Yha3AmlDKRBtYlXIrQ82SBjV+d+q4glPoKYwUdKO+hM/pxD6E3YgHgAN/1yk
         Ozkg==
X-Forwarded-Encrypted: i=1; AJvYcCVRjMlG6HaMfY6AEcbi+eQ6HpOeevxx7VJZ1B4TL6QG5Ky/IMK80bSTmZCFkCDqyeabivgG5UcdIA==@kvack.org
X-Gm-Message-State: AOJu0YwwsTMhVX712FHKMD02ioYH3U8YRLrSOdBEcvoI0gtpGWRaq2+q
	6YxRIg1vMFXT6/+QR39o+elfr6Vc30ab0xAAfIVRovCcPgMveju9b0GuDEEGCV4dcQ==
X-Gm-Gg: ATEYQzyI+qHN/jGHxJlIxYGW+QPNZcnn9eILleiCEAKXaO7mYS6cPX6SBZ0Truaw5Hp
	Z1wRA7dvFWAjq3ZgW+ZpjKXhPxWWBCqnJZ3ac/KgRTrDYp+vrtuSJ0iG/8J2vVT1ki4srpy3thg
	gFVK31zXCFsa9qFATpixT60Enj0mki6AQ+mvfbWZctZMEt+0Qiqy5RGvsVz+VKMBRSN+xjIVYHK
	mxlCGVmj2PxKCrawHe/qboODdt1ZK0L0qmjsy4m2ria2hJXiweb7Hah99fFUCPt36JQEboC2lJm
	3bqHIbY5BUcQY1rraR8jQ8R514p3A2x4CvwIec5M7HGVPGZuJ6EiaAy+LJ0dou3rGK+V2bkA7yW
	yiAFJI7HySaYZJzXCMd9By4g+GWjBasu7x2DQ3+epFjY4t9djqpxY4W8AQ5u4ct2XQwTyFnW2TR
	cE/wH3/UHsc+2t/WOhtwuoezmHCgytw8BZQugTQuWaURHP/WYaBWQsvVY+xJcP+8iQW3+S
X-Received: by 2002:a17:902:d48b:b0:2ae:80a3:98a9 with SMTP id d9443c01a7336-2b042d512d2mr5465485ad.11.1773678516811;
        Mon, 16 Mar 2026 09:28:36 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bada5c760sm115860a91.5.2026.03.16.09.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 09:28:36 -0700 (PDT)
Date: Mon, 16 Mar 2026 09:28:32 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: David Matlack <dmatlack@google.com>, 
	Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, 
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Lukas Wunner <lukas@wunner.de>, =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <20260316162518.GB1767448.vipinsh@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-11-dmatlack@google.com>
 <20260226170030.5a938c74@shazbot.org>
 <aaDqhjdLyf1qSTSh@google.com>
 <20260227084658.3767d801@shazbot.org>
 <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
 <20260227105720.522ca97f@shazbot.org>
 <CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
 <abNOwcOTXqxCxNzt@google.com>
 <20260313083918.00005731@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260313083918.00005731@linux.microsoft.com>
X-Stat-Signature: wo1ged73o8748k9mofkurkntt53rskuo
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 750B5C000D
X-HE-Tag: 1773678518-768636
X-HE-Meta: U2FsdGVkX1/WGFNkoumENFwUEfhm1/wPUnejRWjiUlmYDTrcOWJMhzWepN9nRsaR1JkUD2VSXbws/JDqp35f/HAbWN2c+uWUvmBuhVuGd2RCZRiOGw5ddF8opNtG3M3ipl9p0xpt02xzv22w3sHDC+ZnNzMnbgnofVTzmgeTpZPzBbjgHrI7IT2Y1sfv4FJjgbVjxjVFSDWFyss3atGSfQ/P+cbFUEe+WAd7V1vgE32NtLNSs64Vx62cbWLHO3rnyp1YGDuVdkYtmQTrv9moUnqdVawCr8gs3GkETnzYkbiKtLB6XSjkFPPZ2/7+DQbqj8cPjX4uJUGtQqqlTd9pOdeKGXrRyjL8weKmj8QsfFanOyN3XL+WqB67SUZOoNt1kkz1OtLU19Q71cwDyID9wnBSnniaJ8n6qSzaoO+vp3KCMhB0LZDjsZzbqRsUD82y9xj54ifvTSXNajaAbG4J/NTOVeU26fP0Q94vdO+/uiwVsUJ6KbvDHKsiPrSwsnuF1JEJVGAjWgYNLl7hjH7KjVa5kFIGjqCky8up2Ec/TnuQDq0FGD6ItVJ1bFjdVwahEUM15nJHQt1SbaeraDUrMwc7YwvElLUzPPN0qfWW8Zpj7mCN+elJDPimXZBWHOLam/+8FJFWTN0adUOYekIUSBIdmkbGhQFXCeJnyPdxfjXP1IdMW9HwpLL4mhQBS5bsXFVYLQa19PBTa27EWxHlIX2ukJaAWF18UVvdYnLR/8YJJyCc4T52kiRtNZWtM5ypETTWOcaVdBheCsT6akNdFkaEWM55WRX7Kj0Kg8cvU+r3E5xCultt3+taIx9jLUcK44wvCxv7p/aC9AZwI0Hy2b6AKtU3zmP86UIwMJuMdx0u7ewLSbTdr9CVjHtif7yQ4fGC4r0kuGYwhPm3Q9obTULSbvrwhXYdFNT9WOfOyVeH0oLADrZuRXeaSjoInw+hEqpZ0io9FmKTsmz/qCa
 W97b87zM
 5JFsI8kZs55XiKrSYroAi6l5aDBV9iw+tqnffefGj0sJ4hpfKCB6zMojp+sTHr84/3Nq9mJQrg1i2lWR5W4HaHJC9ePt/vFiXJoc+ouTcXqjN1RmEkwxSdscUbjC+FVega/eQK6z86uDOzTeRqr006cD+q+STGTw+d0L9XZ+vkBjLlSqZuckgRJKiWLvUkrL7QuxGpx5blZeXjvhfLTPNZArfRGSpvtQcDv6M8cUUF+dcH4gVuctkugQfL/5dCSDPwlxB4wmbUthx4VqrvPgHbK3mhZhJxLfplRXKZrCt7sVRcFhdgGud7qVL8qVoFrCP6nInWo4usM2GqYh1HBA2AgqCyAuXHNuKNN1EKKEQrgdnnhGPykrGi+NrgJQ3j/hQzfys6Zht1TDuvFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 08:39:18AM -0700, Jacob Pan wrote:
> Hi David,
> 
> > +config VFIO_PCI_LIVEUPDATE
> > +       bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
> > +       depends on LIVEUPDATE && VFIO_PCI
> > +       help
> > +         Support for preserving devices bound to vfio-pci across a
> > Live
> > +         Update. The eventual goal is that preserved devices can run
> > +         uninterrupted during a Live Update, including DMA to
> > preserved
> > +         memory buffers and P2P. However there are many steps still
> > needed to
> > +         achieve this, including:
> > +
> > +          - Preservation of iommufd files
> > +          - Preservation of IOMMU driver state
> In the interim, what do you think about moving forward with noiommu
> mode without preserving IOMMU driver state? I’ve tested your
> vfio_pci_liveupdate_kexec_test with the noiommu cdev, and it works as
> expected.
> 

Just curious, are you using qemu VM without iommu device for noiommu
work or do you have actual system without iommu hardware for testing?

