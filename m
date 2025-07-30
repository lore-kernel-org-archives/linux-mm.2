Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D423C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 19:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117458E0003; Wed, 30 Jul 2025 15:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8EB8E0001; Wed, 30 Jul 2025 15:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9B38E0003; Wed, 30 Jul 2025 15:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE2EF8E0001
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:58:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76EB711422E
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:58:54 +0000 (UTC)
X-FDA: 83721994188.28.4537A20
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 53599C0005
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:58:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Zwipy1d/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753905532; a=rsa-sha256;
	cv=none;
	b=w6hr0P1SPdO9gkURLjTvIa06BY+E1VFFcHT6kJtBWUDkL95yLXyljhqjf0qrRG7Th8imjF
	9C7bzx6cxKZumeVmErlLGuK+iwJ6pK8wRrLpIbCVE30nnDZnkrzzdI61ekOv2BMjGSr0o3
	UDeh/S0wDPX7z7tTG3tgqZKquja8txI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Zwipy1d/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753905532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJ8yWqGXhru7WhV5DGnUZnDJthF7Yg1ZkZASyV+JWoM=;
	b=l2RaIVkSKvsidbqn4d2bTRCK/FcgG1RaS+AGM4DAJhOdyS7S83hQvLTPsQ+Fmvm7hy8ks4
	KGK0GeZERfszPBINPrA1d5Kes9xRBtZosyG9nRVUCnlKQqCbnDKScGeCtiDsPdbdCwmooL
	cKHW4JCA9uv6XHVq8aLP9UMWbuP7sOE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753905531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MJ8yWqGXhru7WhV5DGnUZnDJthF7Yg1ZkZASyV+JWoM=;
	b=Zwipy1d/+aYeX49YUl3RPWoAUZbooFhei0QjfGCwO7B6gicBefkcYFOHLVp3nRcdVyAnK8
	fz9dbP/EKgOzMP/UlVW7s06aAtjY3f8I+AnGHnlKsxTV+SZKY9U+K8UdHAtu69hNexPuN+
	a5nOYkou2V0wu0FmawyGX5zof/5RgdY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-sufAzO4YPGu5NwuLjQ8nug-1; Wed, 30 Jul 2025 15:58:50 -0400
X-MC-Unique: sufAzO4YPGu5NwuLjQ8nug-1
X-Mimecast-MFC-AGG-ID: sufAzO4YPGu5NwuLjQ8nug_1753905530
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-881327e173fso3159839f.0
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:58:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753905530; x=1754510330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJ8yWqGXhru7WhV5DGnUZnDJthF7Yg1ZkZASyV+JWoM=;
        b=pBHD3pF9TzqupyX8cSJH8jaGl4Ar6aJ+q04ipZ5KAzGcQpWXT2Hekz0vE0L5yQYnaJ
         CDve2KpZD1OobI7liopkcBFNW3HjG11CbBPkBEGYoJgLdGllGb57+0TU3gsVgLVYZth6
         Z02aDAPLbgAooxtwWnbvC5OPrq+IRKWl3r/NmeWlH8f+tMFte/40lo6u1o/lb10ScX4Z
         4uLbF9r5hkXMgBTnU8oj2WnhFyBw9P+1lMuKTjqr04ZRygjDdh4S0ILM+dt6Rml5Oqyh
         sw0k73SLHvaxJ69z51oRaBnkIW0andyrLFQCA9CVXuhwy9s/pEBSpJqkOfN38153a3OT
         uTUA==
X-Forwarded-Encrypted: i=1; AJvYcCWkoHhjwf4UU+Y2U22T6d8VtAgBpt5xcoyiNOBdk9sg+LTvdDgYisV5p6VitABGiNs6OYKzzVQBmQ==@kvack.org
X-Gm-Message-State: AOJu0YxBC9FBCLhwn3jFoYEw8Z80YHawrYth5O6nukCbZhkHAJn+LZvM
	HEIFGPW1WxQ6TzRRJc6g5TBXljuje2eDvfsYOzWCOwFtAPNAndpgXV9pmvO8w9bGnvtPC57ThcB
	c3jeG0Tp8WS0JB1dD9WUE5gF/Ul54eVKOVFNxmc+wtISWsHOYun5W
X-Gm-Gg: ASbGnctkPabmhoLZcnQ+Z9xBDZcwjhd87jzS8njJOIBOmMGBQmSl1+1ICqASENdeVkq
	wU/gJXPZgImt6mYQgPmM/C3WrXAJHekmnmGPYqaFbv/iTL7cHsoBa24I1WHjxBdE9uPwG/ZnqmL
	Bym1BFNUYuU00PAJDitCrUmnmRghWakgXIlslEqQ3k6siSb1lBLpdZ+v3cBGPOPFTpBheE1+H2L
	ikpgQIpFqIqMk2NRk4DYtdnPYgiCJUo8Z3fTsHeLF0c3bmPhQ09UIPetO9u7Mq9nuafJjH/UnCg
	ed6Yu//srfmEYK/BNuWDPnxijgKgHlhoMsR0tVACodc=
X-Received: by 2002:a05:6602:3403:b0:85b:544c:ba6c with SMTP id ca18e2360f4ac-88137489c1bmr247637739f.1.1753905529644;
        Wed, 30 Jul 2025 12:58:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqzTNDwtWgU4diezEDNzfWAqDpdNRdRLffgeb0LuFILxM3AuzO6OxVkpYobVhQ8ZrxcWgziA==
X-Received: by 2002:a05:6602:3403:b0:85b:544c:ba6c with SMTP id ca18e2360f4ac-88137489c1bmr247635939f.1.1753905529204;
        Wed, 30 Jul 2025 12:58:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50a55da3278sm19521173.84.2025.07.30.12.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 12:58:48 -0700 (PDT)
Date: Wed, 30 Jul 2025 13:58:46 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Christoph Hellwig <hch@lst.de>,
 Jason Gunthorpe <jgg@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, Jens Axboe
 <axboe@kernel.dk>, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Logan Gunthorpe
 <logang@deltatee.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin
 Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH 00/10] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20250730135846.2208fe89.alex.williamson@redhat.com>
In-Reply-To: <cover.1753274085.git.leonro@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6KxBdHrH45cGXKEyVxgSEUmmPTfwvcoIn2jzHh31nVI_1753905530
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 53599C0005
X-Stat-Signature: y6arbaw1bqiz959a59uattzns51396gk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753905532-174367
X-HE-Meta: U2FsdGVkX1+6an2A6mi7NKmXPgrzRfBJGuDmqLWLcDZJBgysOHSgjM0oMWNXbcLJPYBlPmNYFPtJ01T/W6ijP74riGaucitNZ75ZpVZIBianifD7UuanusOP6/S6rfsBUCLQ1pe+Rr//ehNElr1zAWUZSMq6YZ31vigNb9fojlDnuMD6/Pgo4LXlbWq5hVwVaEIb9MSXEh2qBAigOme+xFdKraXavOyEGCmv4ikkvPhg1WWsPw3KNZ1dUCkVFnlpT+oGq3aPSz4alpD4MXbj3JbJftAachJth+Vr3/XN84Qp8CnWbiOqPhP2WL0kAfTydpQKtMsXkjYs5VQ2HRmgOzCYZr1WWAj5MjwOyHPROAWaWDXlQI005EshKSltoONJ1eF70Bk/io/O7ZK7hiodQYAcTbGxEqMWM5kgFzFpklGtinIt1MPJwO5sZS35FUx7iH3qLqj3b3TaxkZPgwZijmH/lILhKZPJzfU/mwvTH8tJyDUX2yXJWX5Ay7dQ5swMau35T3oN6urd6iFuEcgGiHXa1AYDI3zhDDybKygK3RAmnDiYTvA5UMsP4qODZweh09pM4TOHhMfjQYJ83Q76OLEadi+afmkzlqL6yZPcC9yNi+AMm2CK1QeySDTO3vo6LFAbvo3mVYeI3StpgeFNN0ZrYLZIobx1d59Yu/KuOYosP+GYqHl8Gu6dXI2VxAchgnvDE5C4RMq4PmsrKHi9x5uLlsYhaJG3WooUKq+Vyyqf33W1DVOCu5En+vIxq9zU7zxVV+eaMnybolQmZ+rmWhd5gXZ1zuB7C7c3yXFhbbMZmKsrKs4hmPqsf6o2EjZWscJrdO3woh34nsf0tZFS1nRNyHobO2R/gBYV9nxgpwc2H7vlMp51rzRj7wGGkOIO6N5wKV49MGZgh9cC73GehrDhWE1gnPMKlKhMA/9e567vnhd1nruTXrdLB1XhFUpSWDLBJElfRAi2L3GsrHf
 YV+KWs/b
 uINOR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Jul 2025 16:00:01 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> ---------------------------------------------------------------------------
> Based on blk and DMA patches which will be sent during coming merge window.
> ---------------------------------------------------------------------------
> 
> This series extends the VFIO PCI subsystem to support exporting MMIO regions
> from PCI device BARs as dma-buf objects, enabling safe sharing of non-struct
> page memory with controlled lifetime management. This allows RDMA and other
> subsystems to import dma-buf FDs and build them into memory regions for PCI
> P2P operations.
> 
> The series supports a use case for SPDK where a NVMe device will be owned
> by SPDK through VFIO but interacting with a RDMA device. The RDMA device
> may directly access the NVMe CMB or directly manipulate the NVMe device's
> doorbell using PCI P2P.
> 
> However, as a general mechanism, it can support many other scenarios with
> VFIO. This dmabuf approach can be usable by iommufd as well for generic
> and safe P2P mappings.

I think this will eventually enable DMA mapping of device MMIO through
an IOMMUFD IOAS for the VM P2P use cases, right?  How do we get from
what appears to be a point-to-point mapping between two devices to a
shared IOVA between multiple devices?  I'm guessing we need IOMMUFD to
support something like IOMMU_IOAS_MAP_FILE for dma-buf, but I can't
connect all the dots.  Thanks,

Alex


