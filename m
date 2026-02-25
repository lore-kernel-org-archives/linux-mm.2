Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB2AEFD206
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4046B0005; Wed, 25 Feb 2026 03:03:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861DB6B0088; Wed, 25 Feb 2026 03:03:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718F66B0092; Wed, 25 Feb 2026 03:03:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3EA6B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:03:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C5EF1C598
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:03:33 +0000 (UTC)
X-FDA: 84482239506.14.CFEBBBF
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 244FC1C0003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:03:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1synquUZ;
	spf=pass (imf20.hostedemail.com: domain of praan@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCJxVjDFn9Nx1ZVu0w3V3L8nPN74ZP9DglkzEBV+/BI=;
	b=O1AmdWsj45Z4ftGifvqqeQ3bGEv33mo8lgdv0lPFwCKWg4998yfHzoEhEhyzOAM0aeYPPR
	bFSBdpbee3RiKE1+Il8mySpBMU+4TAW8s597oHqDSlH29SvVE2zVeXUECyCbTsicSHiZaK
	NxbwjSDNWiMhS4voInnKFnFt43O43Qk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006611; a=rsa-sha256;
	cv=none;
	b=gV0vupiVH3OiNtnz5nzJaAV7R8ephrMU6OyD7B2/eyPcF8mcA/IYdUal92kC88RNtdKUXM
	R2kX+2Fb/fDduPdWaeKPyUy2ueUS6NQJwL8kQFvVnYbvtNe0V00okLEXtkoe8hJL2O/Y3d
	gG/JRmbwfly4UVKpsxk/v1E1Ne1WwO0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1synquUZ;
	spf=pass (imf20.hostedemail.com: domain of praan@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ada9e4ea32so56015ad.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772006610; x=1772611410; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sCJxVjDFn9Nx1ZVu0w3V3L8nPN74ZP9DglkzEBV+/BI=;
        b=1synquUZ9ORMcomU4f5v/xHQ0f5+KrDodcWRsaHD6bDRMe0EaDpHE/gocydoEoiAtc
         +OhE2rIy22y2BYs4T0br5fzYrexGD5NSfJs9Sw3rdRW/AlOwxYv4UE4r1T6NkcBYl/3C
         CIP87cxZNZBeYFJGWl6QpFmrb+kFAo8iKfx7cljZ/zfAYeCT9d+Rqkwj+s9xYikTK/tU
         Sddqw4TdI3Y4LA7nFUxMqBbd+Hj3n4GfOcv/Aybcq2oHxUVb4fi+Nap9p/MVxN/eNWOd
         Jh0gYVQ3p2ArmqA9rf5cNLkBsk6OrurVslGOI+UIw7aQAgxZGLbUzMDpzfJ38pUFBkpf
         tuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772006610; x=1772611410;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sCJxVjDFn9Nx1ZVu0w3V3L8nPN74ZP9DglkzEBV+/BI=;
        b=GL/WqqRrFh+EdDvEcpMD3hUtc+Apw3RgqsO22XIpM8llA8mrojxDVMw5Dq9y0MKq8U
         ag15UrSX5qLhQ4qe3A1sXfEBWfKPkAHFIQ62WVWK7Opf/h3Pvx9tENuc6DnyzGOJ941A
         Yurq8XzLZSWZY9pgcP01jxMj7fDnvW9oPfQUHHolLJO+hesGagVI5DZG8uKqPxcaFHCf
         ZVEyWP+vfuJI4WlIKLrajMuDXmOBY1FN8wGWn8e5+x5EhjHp6jMZxypeTMm0q791IW7f
         ipsCgtkHACh//iZzm/qF0aNI9KXbnjwoNjSmrhCQ3lbHVDPEzW4u7LsRfwLbPUB5yzLG
         chnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfTxC7GwFphL3Ss49D4dmiADibpkdA+8OZrYsLq23FqYSYjyKmTT9Mqmm8Icn12GyTAZHIOEakSA==@kvack.org
X-Gm-Message-State: AOJu0YyTqw/mkUdAIxGLr1hk5hNkhzhUVJWvGAAZiLa4rEMd3Wd5LV7s
	ekreAoASdHqHET6BOM77TBnsx2jREI/qlMzayCuSV40xnCBOlcjcbag2M+Yn4FHyUg==
X-Gm-Gg: ATEYQzxqNazYDCNHIqDMZqF6UsjTCdshXYUqLtpYyklP6KpSmGnfO9wDjNXmk1k2ddK
	65S/ACIt1wD5mXOSYkSOnO85XpKOcM5lSk3L1eW5MWuynXl1eei4dnolvx/vcrBQyXBDnM9Rv48
	iMdIqFfmUIvjNAt+I5RqtZ1vdpt9zjeLtUhIH9uej0Nz8LJuvon1YGj5Nm/HNPVqY6wPWexNVWz
	0O5Z3+UYokrn67oZJBdlNkOk9u64LvPP8zjNTgRQz2OGFjwv6ouopaLi+QEHpbpg/UZY21XaEh6
	92ncqZXLzCQFGe2x7Hu82z9Y+lEKcE+Cl+9tFROJvR/9x3nKNGJH8akoRa7xhESuP2EX6gVUAsR
	J7kwymGwmMvayCTlTvzuSjCOl4XmgBdDTHceFaoqklPsbjLGW0F+fcyhwLxtB9++qR6UWQoSnaX
	JyivI7bF/qnCUvvx1MxiQhGHZFk8WjeGjLn58L2NJiCyfWdVVQZHQL6mIiKDwJ
X-Received: by 2002:a17:902:ecc2:b0:2a7:7f07:340e with SMTP id d9443c01a7336-2adca6c9d85mr1313215ad.4.1772006609152;
        Wed, 25 Feb 2026 00:03:29 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3591342f19fsm421683a91.10.2026.02.25.00.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 00:03:28 -0800 (PST)
Date: Wed, 25 Feb 2026 08:03:18 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 08/22] vfio: Enforce preserved devices are retrieved
 via LIVEUPDATE_SESSION_RETRIEVE_FD
Message-ID: <aZ6sxhNeHqy-hqhK@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-9-dmatlack@google.com>
X-Rspamd-Queue-Id: 244FC1C0003
X-Stat-Signature: 68n9urq4bwsjmr8hct7g3ud8cqr3ua4r
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772006610-767928
X-HE-Meta: U2FsdGVkX194dF8EKNJdMUdNTbwnuwd2pbRsGzP6K+A79ceIq8uk+c+8P17GBc92wRJBn4Fjv138lNfV9HiTZtgnMPPFWXa9g9f7VCoyncDVlN/FTaREjBCa0wF1DV9ES6tmQzDRwyDKtLyxP4Kbkre1b78SKrVKkIdXzECMMnaogTiXkFLzRCPqVHRa/QulFwdS2ipOPBLEJrf8RA87tiRf1QRg7UPpJp+xssl1mMiJMWTfLduSf7VoTasF3G2Tg53qrirumVDfGcEXJ7gTihzGJXrH2F8Im6Ypc1Ne+Iu4xc0AVdGIoN3vDyeoCRnjDPFfJ4mfgkPSZy2sO5L5dRXg+fsc6ij6L2t29HyFASHn9JPDPjnx+B6LYbno4SgQNC6+LKSSrVawLTXOZR4yKWjwxrtanBcxx2U9XcxkcmC4RCEL7zygxOE7Ipn3ICE5zcJ9MlYAI8fTH4NyMRyUtAUcOOZ1UrPrEAIBkAkJURYhSNmwgTVQLaYbgyxK4hC981LTxPDOM+j0Ry2ycw58PBmj1W6vG2oE9qM6FuieooIv6PkWAR6pgNfgEC9P/M/zJTt93OwBaDJRTDWl3D97Z+emDukajGZVKCYq1N7fgM+eSZOY3zk8bX2EmS8R4zkoAdFEbYj9N75Ro36vzk50Kmwsu6nnLtEKo1q+15d7JwUz/DsNgVzOvSWxeIvLuPLrhZt2owV5+2gkhf41HKUT7xm9sdEANh6Pb94E2OPtx+v3WfPrM/9sEt+U/l0K5BDTcj6Ou5uuDX+TEonTPxnP266wQ6lOrOskU0alzWBmWPTl/taAQeo6aNIsjccs1KaEWS5V1QBqbIhxC9owyvCYUbSXCifgwwjuUAL/z5pyKdbhlTEl9VlZPkbTpvx2aXyqQevb4q5OGfm6Ze0XCsRADmljr95eAMyjHNoS0XpFHE+Y27DnUYr6IY3CxC5pKIEBxlFNRqFEqH01gs2eK/f
 cujWyR/l
 viMVdHx7mCgOdin9JeACzQh+q7rJSudTDGceTjdNIKZq5BdJ7/olNpWWEIR7e7hPaQis3BrgbzZV4Zd1OTbPojYwGKBEdLdbcSsneQu9Mr1hN2cbudHojALUuyC0KDEhBIlddwO28uuDK+5McwZUZAsveh32wG28w+cz1B1zn2dxRmIiyORxNepfWhISMQiny5tm8ezp36NZCsk7wWOyJL/EYO9yta7l7paYQZyA/4S5qIrCPpoz54i4SzAOucMq19hz5dLJ+LtkOvwzZSKHNrQLjwioJW7ulAhRQif4VJXvzivsR0yPrgp+73BqbkkQzB4CXZUWlu5yW42pZ5fMJ25rv+mKIDHbiAVU1YHvOab16kMjUSmryjSUeRd6+02S92VmbHaFE6mmTwLbX403AXdhO7WFB5W2Y7W9Oig6GjKUbkI3/MN9wIUGzFRCCDcCB97635WjWfo3VlrT6iXkWDbHkdtVD4FnpgLc1OMdPweRqfDXUJf4KMAf1hNsFBgzRho8s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:24:55PM +0000, David Matlack wrote:
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

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

