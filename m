Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BDDECF2563
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 00:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5F66B0062; Tue, 18 Nov 2025 19:01:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6F16B007B; Tue, 18 Nov 2025 19:01:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46E1E6B0088; Tue, 18 Nov 2025 19:01:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 36DFD6B0062
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:01:47 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B913B12E67F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 00:01:46 +0000 (UTC)
X-FDA: 84125403012.30.F7049A9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id 01C954000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 00:01:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XDJrYB8H;
	spf=pass (imf04.hostedemail.com: domain of kevin.tian@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kevin.tian@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763510503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9V83g3wzls+I7ehBCJ6c2qad6jXiVP/Dl3ArumS6ZI=;
	b=OYWAYKq7XWppIedn3tOj3jJH6SUgeNMdSAoKVZgS/vDOKCT5ClcMsQ8kpJlPzfUSc19V8p
	AYfxmZ1v6so7vpL0iOZxfpUxdMJBlS0m59WrYTyb/zUvOiUTKlNIpFHZJHvOt7ty5xLKZy
	AHIdhaSG9udx8F6rTu9Fj1Z0QDiPcf4=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XDJrYB8H;
	spf=pass (imf04.hostedemail.com: domain of kevin.tian@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kevin.tian@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763510503; a=rsa-sha256;
	cv=pass;
	b=fPBNKA2Z46VIn29QkxA5qe20FlZ9ofqHAu1dDstkyrmHJRX+VqwUbMaSiJPn1E28pLZFE+
	9oDDrTRxzfRfR2iHfcfDcp6vsWNC4S7StWhXcyoTLMLgkJ47xYl47/Ji6whHxEPRkxfGYu
	zY2Hyn1TwSlVLapwhpW2IHCIN5W8s1g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763510503; x=1795046503;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/WVjqBvYjuJWYLvCe4ypUHu51Qv6NkfITOkMyNXLB7c=;
  b=XDJrYB8H4yLzYAMK4z45Jm+LOBtfTalUq3FIKI+qHrax2zNuUQncipgc
   m9k7Tp/l73R2XfM5X9prwDtR23Il6qDgYwfeD4WLn638NLo282G0MDi0O
   JtPXjhAuwIA4weKUVmt25K9TFQURD144moGUeaOF+MvoGCWQVJUFAOasQ
   zNB4VfoKAM6/ArAY/QzxDiOY9paGB8YObNmJPHM3MvAQKVJyEZ7IIIsDq
   y12g+NjDl3Xcv8139Zvb2HY+NJ8ugk4RgN4zwgekCbptJvcXaxknVBAZ5
   IjgmzDz0yM7DGnuitDUtuAX7VLWypDGSsclrJxYOwDvsSOD+9alJucBnd
   Q==;
X-CSE-ConnectionGUID: xiZpg+CRRt2iW9iysdPuMA==
X-CSE-MsgGUID: d5jd/xwiRQ+xq2pgvzFpwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="82935812"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="82935812"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 16:01:41 -0800
X-CSE-ConnectionGUID: yWmEaWGqR7WNGWmo8tDpcA==
X-CSE-MsgGUID: bNR4waxbQoGFtBQ6bSIdjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="221806037"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 16:01:40 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 16:01:39 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 16:01:39 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.37) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 16:01:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yzaMvqS3zBiQjeCiDB0cp3NwuT09UrHno2pbOdMt5gC87sEafI40xOEC21Eyme6xMVgd2/2gfpjv3RZqZdpSTi3R3tMcKOPgMeZMuu4Ela7fjGYOCy9u1pWnZudHVVjKNPhgGNCg/vhb6Ksat8C9hu8aEh2PHCxClHrfcje9Z9aY95uE4C2KeuKHVxInR/YqWZYt68ZLo5GriB+q6aZNHEsqu5tJvykOGfXxPIJmsEchrnVEmTgAXmF3F5cqTh4Hu2w66aqlqVe/Gc33f2GvKETpX1DWtd2P6HM3TdCCaGagbNpSm+rBZvpu2HKLkD96id5H4kk9O12HWrNRPzST/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z9V83g3wzls+I7ehBCJ6c2qad6jXiVP/Dl3ArumS6ZI=;
 b=j3JxS2TIVAe8EH8o3HSRywOSpuZgVKr3z+sFrORSoP/rVkxUohM2wGeGGj/+Aa6J49cNnCcgRCJTiG8wcrJiZ58ZNFI8K60oIE6/HjIqcI4y4bqqQp/S3u0y65hxZPnO6pXe0yS6ph/FVIxHhhsskhcqN0P21F4/KhGyAkBn4zZjbA/+vEwPuzMdxmEiOkF5Zv/BxMpSdme2HJ6/EkEfu+S+hM0J31S6lTdbDEN5JQoVgngHYpshChsm1e621hS8YGNr+BFn8ZOvP7Aw5cfLzOQeGoyk+doS4c/+H7BkGqFqBtIuGsKOCKesvHOY8cKSRvK7heJDYCmwCXrXFdjWHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB5959.namprd11.prod.outlook.com (2603:10b6:510:1e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 00:01:35 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 00:01:35 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex@shazbot.org>
CC: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>, "Robin
 Murphy" <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
	=?iso-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, Kees Cook
	<kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, "Ankit
 Agrawal" <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "Shameer
 Kolothum" <skolothumtho@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, "Alex
 Mastro" <amastro@fb.com>, Nicolin Chen <nicolinc@nvidia.com>
Subject: RE: [PATCH v8 09/11] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Thread-Topic: [PATCH v8 09/11] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Thread-Index: AQHcUvHIktoMrvUl+keVP/eL057qqrT4D0PwgADZqQCAAEAVEA==
Date: Wed, 19 Nov 2025 00:01:35 +0000
Message-ID: <BN9PR11MB5276E1C21E6F3CAA5E5C85068CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
	<20251111-dmabuf-vfio-v8-9-fd9aa5df478f@nvidia.com>
	<BN9PR11MB52767F78317AF3AB94A5B7D38CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20251118131038.32b7804d.alex@shazbot.org>
In-Reply-To: <20251118131038.32b7804d.alex@shazbot.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB5959:EE_
x-ms-office365-filtering-correlation-id: 584011b0-db1d-43dd-61bb-08de26fece17
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?ofgixeOcHMrRoKpbTo2dF8KP6IdInyGhS3rfINgDXwxWAvi5oKV3RRoXQH?=
 =?iso-8859-1?Q?QShV2H66oYRorfc4OYexmce8Rt+Cx5YE40zyt79YnfBDeu2fYe/RL3rtHK?=
 =?iso-8859-1?Q?RsD44KPNX68Gzm3ggBUJiad68pYnumbLQSuKegDAfA9XClljtTiy9AM+o0?=
 =?iso-8859-1?Q?obKvaGLAx4LlmnbPOx8gE7zrww9zfTZLOx5JvpHcKr7TnZHNjHRTh1UiJc?=
 =?iso-8859-1?Q?0H1zjmR4C3EBudhhuxPM04z7autqxZCuQXTxZX6EvJSCRwH+Wy42AfJ7jz?=
 =?iso-8859-1?Q?hGvgFLEBx0tqN14baG4sxMNUcYzJJECGkBcGKkHJnEZrcgDtIF8EO6cPMg?=
 =?iso-8859-1?Q?tzyK06mCWOfePcCYFkpIBfqPUqiDwJFKq+WNt0jYh/9ggaEgFHoFPOL13o?=
 =?iso-8859-1?Q?hPRyZFC5YoZuY1ZRio0A4oLtUa+VIT6ufbDXpcSDwItT9tcsbwnIwXthoJ?=
 =?iso-8859-1?Q?Az0J1e4toLumy9fPCr4S7I5tPT/wJcuMPu8oDNDOv3xytYVxk7eTDouJ+U?=
 =?iso-8859-1?Q?wB2wPtOX/hWtCl+2NJcAWpYirTuikrU0r4D9EspLQXzCshIebQR1GEg/4B?=
 =?iso-8859-1?Q?lZ2H9aDYaXdfJOHdb2rRO/bMhq1c0PjhwJfWBnUnvAC3TtaoZ/3mi2AcBz?=
 =?iso-8859-1?Q?ljfv7amUZLcGqyzSF0E9ZeuchqvrzRpOa1keJMZLRk8ivxKX8cU13PU/ej?=
 =?iso-8859-1?Q?oBT8VxKttGtle+fC0le7jXQzb1mWIR8IpU3oh/NzpxCecS8NN7d3SKbpSN?=
 =?iso-8859-1?Q?W1Gl8biqiIGRplUNqCJ03Le/fx+1qsblGaN0I0w52cKkr6BPYBEE/wAQyC?=
 =?iso-8859-1?Q?ZfxAJgrgPPrVmm7a4UrthkFwcpJcEKpDkrFozsgFlCj3/eMtzjCOr/oC/e?=
 =?iso-8859-1?Q?dtj6brM/PGZvbpOyuzHu6a5iNjNLdvj2KxpsgFJt2u0+dGP5K5ZCcUey6c?=
 =?iso-8859-1?Q?Wfv8Y61rww5dEAKunYfHzjvxkwni2ymaFJTDslLqyqxkSz0+CgoKOU3uEs?=
 =?iso-8859-1?Q?oRSoHkP9hgMsTsW0JYlT6XSVRyqrY9/e7OSz3bDjj8BAshFgz6aKZuWVd2?=
 =?iso-8859-1?Q?q9bkChBIGYxg7JoZ6oR6oFSdeKrLcGdLbVgljA/jeCrs4PBUUL0D4OfK+h?=
 =?iso-8859-1?Q?3/piXecbrmJcxtwtAPduxQHj+5KQi34krgY4ElXiNLlK/UjDDp8r6fxWf7?=
 =?iso-8859-1?Q?sbXGXvpYKwQPaTaE2m67t4VSOoHJ3Ivxy/Uk1dHwyrHOtsDldxKJ44BV78?=
 =?iso-8859-1?Q?i9XMogsZcSGANXCBRulvP+6lXQp6SqXvyOt8DloZjHRwLnusaFWeeqJ0W0?=
 =?iso-8859-1?Q?TrySuIthWWCfUiEL0+08DR1SPcn1SIL7SLxEm+UErA1/VyaLN19C/W69hq?=
 =?iso-8859-1?Q?j8A3EXIDym3Mcg3G1RKVPTDxhWR/RAV73wH1MZf7hNwpAUcPRQFeEKogq+?=
 =?iso-8859-1?Q?aymFJpxjSzCiYM3mhzd5lBG9lV5S/DrHBY2ta+vUbLjR6MkyM/GOrHgqhB?=
 =?iso-8859-1?Q?XN23yZbuMQgu3R2Ve9hxYmMwo8MUeAv9hETMYuq9VzNQ4FgcO2Piep7bzc?=
 =?iso-8859-1?Q?UyjasEF8YPT2haMf2Stoyr4Po/io?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?00M/vg8gXEBV64SYSuifP1llaWI1ezCUcYrimxLKfj+iMVPqW2Y9TUpcxZ?=
 =?iso-8859-1?Q?wXI4INt9GPSUE0NNkLRiNYw8GmXTt/iZ66Jdq9jKbtDuvNKUJ6U9wGICLw?=
 =?iso-8859-1?Q?dHJJyQK4cuH7BkTyxAJGGTQJ8dHL4+sCHFEVQNGsDXeJfbkXTM/nJxqmH3?=
 =?iso-8859-1?Q?RtI6T59izOsoaa1WKwUe9zegtP+/sDTktgounH660AGBXpN/nAD1VlUPY3?=
 =?iso-8859-1?Q?Ds/rwLiJw8u2U9RSZ9McgCqkF6NzNHQ5b8oeTmqrwhejzev72ykEC2/6nC?=
 =?iso-8859-1?Q?14aY+XExZADKZJgyNAXfYIrw/W0TL8aA2uJxbO+oMfqzjjsVOxe7c/Uhej?=
 =?iso-8859-1?Q?R9+UbOX+2wa6or3Y5zXRSOcr+s+Ha7KAKRzcVpNqQV+ja+Y+GQpewi0nIA?=
 =?iso-8859-1?Q?JI2K7bWLTnkWlQBya84NumHwufdHtF79dLxGtmzxTQrn6nIbe2ucN99bLI?=
 =?iso-8859-1?Q?xEUIczuqoaIF9PMt2yDuaQtFrn6YMoMNnPcI5KaYfosj2nWEx4/A2nQthy?=
 =?iso-8859-1?Q?J/T66ExgV0XXWeHb0oUc7oJ9BBBGi9Njenoni1NjVjXVgEwEMtbaqJ8gM2?=
 =?iso-8859-1?Q?ff2DmNAIF5az9d8quWHliw9k0M5A0tWQZepCEFRj2MTHhIke4nkXOvTijv?=
 =?iso-8859-1?Q?v3OkUnsLqd02GcAdZebTQeq46UTJ/VArV+QXTtP9UT1JlwrRHj8qi0GCKS?=
 =?iso-8859-1?Q?naOX9FWr8rSb2DYb4adQI4nhyRl6SpSVf5YdsHj6FsJY+efZA99AwTCgyP?=
 =?iso-8859-1?Q?ne0eUlEZFEhEZxSnbTC8gRLgL4aulmKxeJ7M9oNfkKiNGaZtzQuYao+ozK?=
 =?iso-8859-1?Q?hQJmCQEaFyWEhAjXAk1Lc/vF5l8FsvWAxMmvp93qq5t/K+2EnY0R3C0466?=
 =?iso-8859-1?Q?vTyLRI3RVfR9ByUKoyGSptv5kNXGKxzanE9kWgQLKK1D1UQyFzaLA1YGrm?=
 =?iso-8859-1?Q?jJzTsuKS4hxvn7XVgspoInMNMTWG2N3av+fNPzghHnjwPx6iZzfYem+8bP?=
 =?iso-8859-1?Q?GX9m7jytsLiyGsJQkxTW70UQ/yOcKzo50xZ+dJph/gSCIWe3Y7GTeL5o+z?=
 =?iso-8859-1?Q?xVLN6BM/nCzkS3D0Jof+J3rS/dn5E78X8JTh8hGTK5SK50KD0CnLyB7fhe?=
 =?iso-8859-1?Q?9JbQrEBbyCPdYOo1uCQX6aouiBIkfYNZEXgHmCRMtfIFQe4K6O1H8sDTmk?=
 =?iso-8859-1?Q?M+kKdZeiDambmmY14UwOEtYRn8/0PVQ5pkKkP03I20S3ONVGYy0q7ngKET?=
 =?iso-8859-1?Q?qTjgKe6wrPxBvQTL4zE0K+98yt761tcB8DDlLQLxfS/EUfQ+/S9k8SC1lX?=
 =?iso-8859-1?Q?M8yWoodUFkYhtvJ8jD3IFZGOQtpjJaeFVAqYWxa4ApwFfWeAd20iXdC3Sa?=
 =?iso-8859-1?Q?cLkbjAIfSNIxLZcD1zUAVMhEftbMcgo1N4ISFasYX58MhycSegYg2ICtqX?=
 =?iso-8859-1?Q?lh2rNztFmSRu4rLvMBIVSdYNUh1Wyk1MKmzmjs0LUEINxppIXWf8n5Sxgf?=
 =?iso-8859-1?Q?njnXy5q3x6qs7BP41jPRMkQCpFYu69s/mab6tWJue7P/TJMiEtRBYvAq6q?=
 =?iso-8859-1?Q?nZcJpNR+WN3B/6i5epdVtkBYbYhrLmhVwax1TjMSjGYfpyw18osNkKzMWM?=
 =?iso-8859-1?Q?nzcQ9eE+sQk97u0/76PoLa2YWFdbG/JNfD?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 584011b0-db1d-43dd-61bb-08de26fece17
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2025 00:01:35.4295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RFcr1CY6x9pSLNtrXdMV1suLk+vHcQzDu6l+UidY43e9s9MskDJcuTELbSGtIxr9LC2nIlhUrhDimQtfL7FvUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5959
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 01C954000A
X-Stat-Signature: fz7jzpaxtoy3rqerco3fe8bjggpwnq6e
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763510502-842110
X-HE-Meta: U2FsdGVkX18sJbUSJXogDg5VBtYfn2jcTCcYOeaXMysb8CBSclUMFcMiLJSqrVs4KW/H4fisP7Y9pOrNuzC6gmTClokBnjv+E+1+s+PuIQbrqEJkmmtYQL5BInSNCWr0rXYCei5uSQKSkUE61kw5ByKGS9/+dSfft49uycYFc+HIOlyloyG3LMoSPg10Z1L3r5jzvLyoxsrm8IpxSRazo6Lm6TCirgnc3h3Pd5Hx3tucW3NgIpRaqYBFC1p7NalpIN8SdxX8W6CDUoxet+euS4js5m0i/gKZ0d8Rlngh4MTfUy1KF9C6YCW6Wqm4rM9AEKdgJFCtLwDL9hCSTfosD5XL82Unj1wgAQ8vx72ackT+4EjF/a3t3UBiBTGmZ+ZmLFaUTOLSpf1Qdnj4E6xVsHb2dOFRBe9qXl6hBMUCx8FMxUecVVh32qIqg0DqPlTzoKsxUZJXGX2GncCNECsfnIkTcdJWtlMHcOVvM9wMgYwbr5hDzdcjfMtKBGmA8mfFHNrB9NtrcL7TzCi0APSgcIfTk/gSWVPL6ApewJwl6nWDLLQ45dNqoJXMJf/gZySmi0/2BOEXm7IWOeRaOd/1mxGvoXX+9h46UuUnKG9KWABJAhrsOPg/2BhBSJh+6nctvX5BQHJHYdXIX76eMEhSu3JK9I1zqX0EGXHIIeQ90XeUWjcl+QhiRqXgrNeJpKalRBl3Y1z9ZR+i9+wDwv5QdeoNqu7gdGuHKLRm2QKMjonKF2iu/9SFA4tF0uZ8Zy8t4Ykul5bCGHFz9Vm0vI1rfVwR5USUEfSq8z8a8KXiMjnGvKZ/iWP+TsZOiBAcug2aD0moXQ07fFZrIge1GJzz2jdkeIZirOINsWi1nQ4goz50pyl49Jya0LVlzvtE7zm1s9BzdYkgxuQmtcYocQbyVu+VrGUoaUK4/3jaRsmcD3ct7UElJqO9UfgEUpwj8dH+Mv8apfXXT5xOAc+xg2r
 FdgJy2Mb
 fA3RqJM+SNmNXvyfznogC2chY0B9PIozoErQ8xCSvBLo2qTPshhed8ssePirw+yXB0j11G3ivNdqrPyuIBkSCxvfRAH6HKMsm8FtPa41Q5wW5UICAW2wDH4/C7d32JShdIQANosMOdN0gMc7eUpVPU+s7bUeWuMfQv5GEVjSnb7g/LXdQAp5+IWExHe85tbBXA4kupdVp8rmBJtNXyXxSk+HfzIV3hdGNfH2ogg3MzQGcnqXoLczuWmT7Pwui8Jy52EJvfKEfv0IfdaCz++vJGyLRqeXQeshIhASp6/rOMcJi4N5EsPufvpKItuT3uv0xnmsGzmfccToSFeA1HA08TCYQ7MAU8kY7A4Zxtbp0Zpx7sS1O5WsL6KdCKPvVK2mhsdPMXl/dsbOhstOAIePJmULmOy1c6hqrQvPf8NFnPvMJkt7jThLYW1U4Upyt9wEe8+hu2orGFOSpltN5XHqFKUY8yFP5m75GtZQQCcvFNaoldza9sqbXodYNQ8y+r8yotvJubVoo8ccGH1ify8t4OEXEOzU4EsbhB5+/giCmkVadYGwsK+RmCV9Y8A6cXNeU9oDQxLGC7lThgd9v5BJotF7xWQJCWVQGBJRu/zL0ykmkiic=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: Alex Williamson <alex@shazbot.org>
> Sent: Wednesday, November 19, 2025 4:11 AM
>=20
> On Tue, 18 Nov 2025 07:18:36 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Tuesday, November 11, 2025 5:58 PM
> > >
> > > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > not required with only your own s-o-b
> >
> > > @@ -2090,6 +2092,9 @@ int vfio_pci_core_init_dev(struct vfio_device
> > > *core_vdev)
> > >  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
> > >  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> > >  	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> > > +	ret =3D pcim_p2pdma_init(vdev->pdev);
> > > +	if (ret && ret !=3D -EOPNOTSUPP)
> > > +		return ret;
> >
> > Reading the commit msg seems -EOPNOTSUPP is only returned for fake
> > PCI devices, otherwise it implies regression. better add a comment for =
it?
>=20
> I think the commit log is saying that if a device comes along that
> can't support this, we'd quirk the init path to return -EOPNOTSUPP for
> that particular device here.  This path is currently used when
> !CONFIG_PCI_P2PDMA to make this error non-fatal to the device init.
>=20
> I don't see a regression if such a device comes along and while we
> could survive other types of failures by disabling p2pdma here, I think
> all such cases are sufficient rare out of memory cases to consider them
> catastrophic.  Thanks,
>=20

ah yes. I read it inaccurately.

