Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E3A0CEBF93
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B89BB8E0009; Tue, 18 Nov 2025 02:11:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3AB88E0005; Tue, 18 Nov 2025 02:11:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DAFA8E0009; Tue, 18 Nov 2025 02:11:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6528E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:11:19 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 324F012E7CF
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:11:19 +0000 (UTC)
X-FDA: 84122856678.12.CF4B709
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf12.hostedemail.com (Postfix) with ESMTP id EBDAB40014
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:11:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=byT2o3Ph;
	spf=pass (imf12.hostedemail.com: domain of kevin.tian@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=kevin.tian@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763449870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ac5FAQw0UUZSR0+QhqXokMpCYxXJnXxzLeafKx08K9E=;
	b=QC6apYs22K5Juj2nMmFg2r4bxNx6dDy883Yjwot1pF9YCfkqOUWzNyRVaNNYajh4WWaJ+p
	DEq3aZ7Txaz6ni6YSFAzSK/BTuJkCvNjABvNh4glJHBmisQR1f4+Jh0HQ5K+P/jBxaLELV
	LlvhVSW6Jle61iv7z0Z6iXmdMad26R8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=byT2o3Ph;
	spf=pass (imf12.hostedemail.com: domain of kevin.tian@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=kevin.tian@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763449870; a=rsa-sha256;
	cv=pass;
	b=6WEyMnBJONnOvcodOHSIG/k/Rf6pWjhKETvljG/xpNq3b0bdPOlb+Jht9WiadLqq4t/3N+
	+pjjV4/U6BbUWmw55JU7xBGgl4N9rx1ioU2kePG2MinVyZAKGIBvldtr0OHGFlJTzMSl7q
	pr0gk/6L2Wx3QSzt4rKyB0Cywi+hAPE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763449870; x=1794985870;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ac5FAQw0UUZSR0+QhqXokMpCYxXJnXxzLeafKx08K9E=;
  b=byT2o3PhD2lLax+uIQImtdj1OV2I9ghDIXL1jCWNAVwyXHUZ7qxoQCAx
   yBwa1cASLSdRynmysG37UyAeaerEL0qIqK0fwYU5Jv1wHWYXYPmxDlmWe
   BVFF0bmrNx2u78bWs+noLJojrJhjPBSoeVSZE2THKyIZzjGED9jwYbhob
   8qo56hpYmGFUQByi+cpOnTmC2JRgc6TvdYuyBm7vTfxIXAi+GZQzifR5u
   pFTCSZCl8uSb9AkBXOanPaV+MV/+5KvSGIHKsCIKFtaBkuGhI1NKGPiTN
   S+7L6g1Y22FWrFlHsaaQaVUpB7lKwQrySgdCLC8/Cl2U2hvZe5q5HYY+o
   A==;
X-CSE-ConnectionGUID: TXfJpz2bS1uXOQ0Y1zKZRQ==
X-CSE-MsgGUID: q9HP895oRtqAugOYYA3DOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="88113981"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="88113981"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 23:11:08 -0800
X-CSE-ConnectionGUID: JHLj8fDFRyO2yg1jyTN9qg==
X-CSE-MsgGUID: ATJYK7cWTg6Vx/XnTyGflQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="189942573"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 23:11:07 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 23:11:06 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 23:11:06 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.67) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 23:11:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CIICT8rFi4hrybfQrUc2McrsgL0Ngju3k5vL2rHmYeFk6AEZJu+hdWjbkRtOKFgERTGRcs+1wEbrHQtHFSCSk19Gp+S60TaXjPsGZnq31NaTlrmRHpfHce44quiAxXLS2V+kaUWJeJr+L5jDEHtpVuic+t50bc02bg+E0SV00AJz1w2L+/u9mvdnUZLtx+n7DLXzc2vrLaJm3bE+WUXbnvJo53Kn3EvVBq69SNkxdvfpU/O5CqUt7lJa8xOV/0LaQrRU0iV0+m2K5flr4UqLV/iJ+vWWm9CWLsANdszNDxQde1fFUrVdcGMIxpRbduEjzmSGYac5KRutaSY514kaxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ac5FAQw0UUZSR0+QhqXokMpCYxXJnXxzLeafKx08K9E=;
 b=Cpc/lLCVz50BSTL6JJZ4IUQE0sbG/8AoXIBXoA3ccfgkTI9figwmX7fvtRu92XFAKq/aFhX0U3WWCRkBXGSnJrv70Yi2l3ZIClm2O58vjs1O9BoImmX96jaZvgUNpb45GKiwSFCRyouzSYwWl3dOdN4fLwsFP8dnuEpvrS+6PKADOCzQUUskONNoTKNILGV0JJpj8ks7SYsC97ULNqLHH5/806TZnmANv+eSYRhlkFjDSglCdQ1XLQmmfiOd0eR3YH0xzrA8JLeDP3Zel82g9Hmj3dkJVRiQ2XadNVJiMoJ6rfrKGkGFInuG1AyW7PQec0l5RhosEBlp7pxhIwFXwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4980.namprd11.prod.outlook.com (2603:10b6:303:98::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Tue, 18 Nov
 2025 07:10:59 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 07:10:58 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>, "Robin
 Murphy" <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, Kees Cook
	<kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, "Ankit
 Agrawal" <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "Shameer
 Kolothum" <skolothumtho@nvidia.com>, Alex Williamson <alex@shazbot.org>
CC: Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "linaro-mm-sig@lists.linaro.org"
	<linaro-mm-sig@lists.linaro.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, "Kasireddy, Vivek"
	<vivek.kasireddy@intel.com>, Alex Mastro <amastro@fb.com>, Nicolin Chen
	<nicolinc@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH v8 07/11] vfio: Export vfio device get and put
 registration helpers
Thread-Topic: [PATCH v8 07/11] vfio: Export vfio device get and put
 registration helpers
Thread-Index: AQHcUvHChFxcVdm3dUei4Y3GBAL1Y7T4Dttw
Date: Tue, 18 Nov 2025 07:10:58 +0000
Message-ID: <BN9PR11MB52764795D6B6405785A2C5228CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-7-fd9aa5df478f@nvidia.com>
In-Reply-To: <20251111-dmabuf-vfio-v8-7-fd9aa5df478f@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4980:EE_
x-ms-office365-filtering-correlation-id: 81d4fa21-5ddb-4175-fa34-08de26719f92
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?Nk13aDBzamRCenp5TDNxbFpTSEZZN2NrNFY5ekZXNWNreHZ3Wkd1b2lQVGF3?=
 =?utf-8?B?QmU5T3JiZVFnNEk4TEJKVDdlN0pKVmp6TkxMbkJPOEZSSEJac3ZOdTUwaFNT?=
 =?utf-8?B?TnplbDBwMU8vWm5wZFFveWc4K1cyV2QzREovWGJlQXljZ05nNVRJOUhWZzVy?=
 =?utf-8?B?RFd6QWM5R0pDZk51VjdPN2RGTWJZYXgyY0xPMnRrVXJhWW9FYm5DQkRaM0xY?=
 =?utf-8?B?M01PWHBtcDVuc0NWUUNqWHRSTGZBdXhVRUpGT1dIZEtHUVgwL3hxM2hWWFVh?=
 =?utf-8?B?dkhTOWpjRzdRVG1mOVk5YXpkMEFtM2paZjlEVmc0bEdyNnFMN2IyWmZUcmUv?=
 =?utf-8?B?M2J5TG9FTFFTNTQ2YWhrUUR2MzZ0bFVkeXhCMm9PZkZ6ZTNCTE02aENMWXU4?=
 =?utf-8?B?WVJkaXZQc3ZPZ29QdlRvWkRRRDNOOHpPaWF4Nm8zc1VzaGs1dm5VWlJ4YlhW?=
 =?utf-8?B?ZFhOTitPZ29RdURvTWhzVWFvemc1SEhHd2lXZFVRZE5xaUdicWdQRmRyK2NL?=
 =?utf-8?B?RHhSOURPa3BQa2dMVUk0YTNrTFF1TkhJMHhBVzlTN1N2ZlpmYzRBNjBzNExL?=
 =?utf-8?B?UFlFbHdzbXR4NGhkWGZ2YkpMRjF1MUpBVlNFcnZCSU5TcjZGRUZEWG9jWXV0?=
 =?utf-8?B?UXFqLzZlMjFjL3VTMEZoM3JIWkZzMFF4M3lrVm5ONWJadjFObHFjcVVlOFlj?=
 =?utf-8?B?cDlBa0t6aFBFMjE5cWdEMExmV0RPYm9JMWxUUDdnUkRQZS9EZlg0K0VYWnFo?=
 =?utf-8?B?MmpnL1RiVDhNVWR3eWFCb2lJVDI2ekl5ajBhb0J1NlA1SmpncHZCejhEUHp6?=
 =?utf-8?B?YjFEK0dLSkMwVmRoY0lmZG9wYUZ0Wmx1amJNTHhrZDh5VG5udUkrcGNIZ1p2?=
 =?utf-8?B?RHErZ1VNcUpXamZUa0NXWDZia0M5eEJ6enB6cklZd2JDQjFkbW5Na0tjVG5L?=
 =?utf-8?B?QzRCK2NJbGhmOWpDYm80S0hoNXo0YVd4cmI0eHM4ZHFFN1NmNmZJTjZrZXBS?=
 =?utf-8?B?VklmU0doUzQ2Y0tIemp4QlBxUk02RTdJMGE0d29wVmhrSzdDUUtGTHpGdHQ2?=
 =?utf-8?B?QnRma2J1bUVmVlpZRzl6RElKaHpMc1AvK0wySkdKclM0akVlUTB5Y21nb1N3?=
 =?utf-8?B?RHlHOG9lRWNDUGZieC9xYUx2aTFVbXY2Tms0MDA3RUZMOGNKNGlqME0yUUxM?=
 =?utf-8?B?L3lsRjQxbzhXeiszdStkZWxMeVhmdFR3dzdDRGhZM1hUYXlIbHQrdkZFbEhH?=
 =?utf-8?B?RjNOVk5hZEg2ODB5YnF4dHEzUllMT3EvcXFkM1Z5OGkzd2lONG15MUY2bEtx?=
 =?utf-8?B?R2w4dVdyRHZDZHNNNXFadWlTWVhFTnNia255dHYyenNGbjkreCt0cG1GY3N3?=
 =?utf-8?B?cDYwNXRzamtqcmRJdGF4VFluWm1SMHR3dHc5UkQ0NTRSOXFZam05MWhDeDJC?=
 =?utf-8?B?ckFVRmh0TFJiZWZpamgwWTZhWHpmUnpuekJlbHFSR3NsVjRycFZuQXpMMVBz?=
 =?utf-8?B?cTljRnd4ODhhaWVVVkpUVzFEYThCQlBwcVBJekllNVFEVS9IcUlVWWt2MDI3?=
 =?utf-8?B?anVRcXhsZW5xSHdNUGhQT0RlVnA1MGRzREdxVjJTblk0eG1qTXZHMUI0T1Jh?=
 =?utf-8?B?WGVwVTA4WDUvajZxNFR5Wk5DNnFYcVgxemFlYjVyMjlQRk1lSmNDWWMxYzRT?=
 =?utf-8?B?SU9pdnBXcFY5cU1rdUlOOVdrY0FNSUZYR1BQaDFWSy9SKzVCUStKc1JTMGUx?=
 =?utf-8?B?SDNocWhDSHNiMytmVjh3TURlSlAyenJzZXYrSzJmbEdkS1VrTnZxN05nZTBJ?=
 =?utf-8?B?cWRTYVF4aDBkRXJ4WVhSWFptSjZ6M2pFNFU2bVk1OHk5Ync1V0dUKzFvWDJt?=
 =?utf-8?B?UWpGVTJOWFIyYVU4UEQ3RDNaNlJSeXBWNDNSK284MksxRGEwSlF6Zlk5T25K?=
 =?utf-8?B?UExibFRYaWlsUHBYWlBncGtTcnFhMFloWXpIL0UvSzZKalM3d0NubURvdmY2?=
 =?utf-8?B?cnovS281V2svdC9yUW9aTThHYWZCVWxGMHFOUzFDbXE1Nnp0NU5DNXlPZ05U?=
 =?utf-8?B?TXdBU0F5ZnVlcGRKT0ZBYlJnZkJLTEVsMUtBZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXZpcE9oeTEzTjQxSlgwNHdQY3FQQU5ZMW0yRy9nUEt5WTBVeWZWbC83Wnp0?=
 =?utf-8?B?bzZ4ZnVRRVM2VWpGMzhXakJDTzBwNmFrZVhmZjR1UDNxa25HUGlYZHNqTWtN?=
 =?utf-8?B?MXd1NjNoTkdKTFY0Qm5kRU9zaCt5aTBDN0VOQ3lGeEtRbGI1d2VWVjgreWlR?=
 =?utf-8?B?QUhUVGdwM2hCdlpOYXoyeXlVVTZuUHI3NS9GQ203cU9kbm5tcUpXcXBjL1Vp?=
 =?utf-8?B?N2lvQ3RORUVPbVFUcHFzeW4rclJZdVVmbVRZL1VhOGtDcklTcEdNQWdtQzQv?=
 =?utf-8?B?NmgzWmM4WTd4aEhMMmpJazM4cVR2VjdIUGZYend0WTFybzRpQk9vbEhPWWVN?=
 =?utf-8?B?VE40ZVllZFFBbUt0U0dyT0YyV1o5bVBvTDNKaHFRajFiVno2WGFPVXZkdk9C?=
 =?utf-8?B?MXZzQ1BSc1RIaHFRU0VhUG1mSEYxbW14SjVQYUtzeEhtWW8zdUFwL2xqajZv?=
 =?utf-8?B?bW45cG81dlVhMi9HZkd3cCtRMFk1QnpMK2dQeEo3Ky8yOVVlc0lQTlJuUGda?=
 =?utf-8?B?VUJVS0RBMllwMkY1NjBXa0xQNWQ2c2g2eGFCS3ZDN1FSbHNQWXd0YlU5cEdK?=
 =?utf-8?B?NE9NNVF5Q0RSSElkbFBkaEtVdVF3ZjJPNnV6T2F2eEQra0l4LzRoTDNIT3l6?=
 =?utf-8?B?S1B2OW9HMS8wbVQ3clVHdDY2VEFwUlBxK0RMWTFGbXJnRkdWdUlZbkhOZ2lE?=
 =?utf-8?B?VTZFbjhjbTBtdVVMdExEdWFRSHV5UHNZWnkwMDQwbTVRam9QdDdRSG84eUQv?=
 =?utf-8?B?R1FySmNBQTMvUGd0aTN1ZnYrNG8vOHp1SWp0VlNyaktyVlBQa0tkdFdScXJ0?=
 =?utf-8?B?M1gvN2tUcm1ubEZ0VEpWZWpmVitvdWw4UU5VTTJnb1V6dllILzgvR1pIY0Vy?=
 =?utf-8?B?QWhid3Q1N1ZnZmpqQUJ3UDNodTZ5bWgzdmtnWUFIeVI0dXVvUG5aNUdEWjNW?=
 =?utf-8?B?MlJLbWJnUEJ4bk9tVVZLUXJOVU0vcE11em9BVWVvTENEcW5OUFNpN2RCS25y?=
 =?utf-8?B?aXdKR210RG5ITG9PZ2w0UXN2dnlOOGFWRkw1Z2M2c2taaEMxb04rOGYwL0Fj?=
 =?utf-8?B?d1A2RDhSOEw1MnFaOVBaZE05MVdMb24wcWZNakRGeTZhRGlWNG9Tb0kzNUwx?=
 =?utf-8?B?UG5nVU9IL1BsZmM5Ym1PbzJFMEpzNWpzeUVITW4vbHNvVWY1L2dMYndMT0xO?=
 =?utf-8?B?ZjdQKzZmeHdqQlJKcWs5dU45TWpOZHpEeXI2RHBFL1c4Uk5TZm51dFJNQ1Bz?=
 =?utf-8?B?VTNQZDBJbjV2UnNvakxaVVMzMGhnSEcxakJLMmUxRUkxV3dJbk5vb0N2dHUy?=
 =?utf-8?B?eGtGc0ZiMUxIK1NLRW0rZnpVejVlUE1aMjRzVVM5UUx3WFBhSEtXZ3c3dHUw?=
 =?utf-8?B?THhsQzZ3UUxSNWJhekVTdzN3bmZlQ2dXcnpsRmp6SlhQNWxES3BGdlBkUzdr?=
 =?utf-8?B?Q2p6ZElPbDI0akYydWZJdEpISHZmakpNZ3lYZ3hDdWdwRkYxZHRJcmw5R1Jk?=
 =?utf-8?B?RDNzbjFVMUt3QUJraTkrQWRYeDB6NmI4dEdzV2o0VnpHSXpTR0NodFc0Ujho?=
 =?utf-8?B?YUZheGxEZTdWTUhPKzNEV04zYjhrM0JHdUpIUnBJNjhlRDB3UDg4RSthb2JP?=
 =?utf-8?B?c1dDQjBqNy9QVmNaVkdKeUxMYmp5blVYNWNMemlXYmcxeWc0WlNqVGdsYVg5?=
 =?utf-8?B?YjlSd3R4RnNRYVdhVi9LaGxpZGZKU21KdnNJRFA2UVI3QVFPWVR2K1NIS3lJ?=
 =?utf-8?B?NEpzOW5NRkZwSm52eFZSUXJWMHRFMFFCeWhpKzUzT0tmekdvSHBPdkY0STVD?=
 =?utf-8?B?OXdkRTBHc1c2a09rQjNyd3FpMUJRVWl6aFlZcWk0N2x4MDduUENCbjNBUDN2?=
 =?utf-8?B?cExlT016Wm03YkN3U3kxVkZ2Smk0aXZNY3VZRmsrY2lQa2dFUjBmVFJ5NXUy?=
 =?utf-8?B?b1FZd0xxWVNVdTdudURaK1FieTA4MEp4VTF0RDNiVE1FWWhRSXY5akw5Z0dv?=
 =?utf-8?B?U1BHQlk3QlFHN3RQcUlEaFFmcXFJVGJ0b0xCRDZ3TGJCOG1UanVWOFVkMmNm?=
 =?utf-8?B?MHNrRFJOZlo5R2hHM052V1E4aExGT01oU0YwNG9lOHd5NDZjU2VnR05jWHRt?=
 =?utf-8?Q?yy8JRwwA20VFhlqHLNjvfbYMw?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d4fa21-5ddb-4175-fa34-08de26719f92
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 07:10:58.3170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BrWwLupX4PhjxI0esTDIAxUvxtCvwE7yW9IPml9Kt5g8VyXnzlPVjy13mt+IyrEdoLRW2bAPM6vWng+lG3hKrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4980
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EBDAB40014
X-Stat-Signature: mkyniawtx56mh6shc6bbwcibpe3saxxe
X-Rspam-User: 
X-HE-Tag: 1763449869-347097
X-HE-Meta: U2FsdGVkX1+ZjO6jif2gB6RR9C9SoKGGSZEax0SjjVAUc9S6bLByIVTml/Lsmqp/DrQA8tcSe6apmMw9CtZFQo8Kkv7KPyzmpO65YdJooutDp0XmqLa0GCEUpJgFkU5Yms+vknvoMM42AOFiopHXnSsrSlAGOtMBqFn96ybRp6MzMz/xghsLwCkbdE0VYumA4zdX/UddYygghymjAxqYmTLFZj1vj1QVEww9OHO/OykXJVfXVMX0A1HB4eH0RKSTjx8/zO2dq2sg7Pzfvr7FxxXrfxANxUFW8O/kDlrBmKEKZU38cMu4Su88de6WXqgsJ0Zq3bIKHyoNgnFCE0IFiFmiapZVkVK6JXcwn1Fvdbe2MjKMy+zdSmF50uuU+qlXOtEeButK4sG7LUcl1N9NZDypIW6pXtc2ASpceJGZl7w4nQRZ9ZZq532vX4bqfN6ZNYDu85w6SPHky/7INZt6ovNloTVTkDY20l97hUXrtidzfYZq2gtYa5SqDeHVYuctehfP4dwJKI2uJpdykVNvr1eYfuA/0FgC3rb1AJifHCpn7xjHBrqTpNAALx8Mkd71Ku3svzzsEIhsy/aGVk7WGEN0YFye0KRyKGjxVMHuPAvG1Wu82JsfPKTrjjEnmDuZkTJnBD1OrpS0mwb5HMaFAzAQJkOVBezyVBmUoE2znGTFUy3ayCb+iC3jXzHUqQvTF2aexTQssYjc5BDzG+SAubpp4ldQ36N0tpDiPF1FH+nm/xv77sfQ0YqpV8AXpeCxQD2GmJLBomvjQIXi9ye89Z0/TX7n8JmTpY4zuf6M6wYu5ChHSUGgsGeM308LEXX479dEYkkJvKV+KKbZgokUPcLDO9iJbPE03S6ruR2dFb5aeSyka0Xtq2Kfgp6yZ++ZE7Phf5+Q5EddjS+4WJWnpvwGrSerKmK+6ZS33DWHXlWsFpBz0MBMI0MmB5U/W+PLFCu04SPwHtsWu247Cbs
 tEjIK34J
 B0fZF+qDY2pSXeDX6ZHLdeSSHR1bXq8SQbUqZfQ6ryCvEFkOpOVzZP/5KKdBEXy1bjEClsjUvzgmSLrdXWp3wUj7w5UIoDO84OIDVXdWcbxiDVEwby63wo0Qaq7u3pkHcsSUoLlIIW0GvGCJ8lsNXYqRtv4KISThGBl9X7r+rCOPgg1feTq74PBrr6NEGvyDuOL8fkpl7bG1ztDM7Mws8ltWUlmcOgAfsyaKJByjtqwD4GausmUeXvX1rW6VsOEkff5Ww6nUabj6fXRxw7hHz5P4kN+gpiWJPsfP20gp/yCFRixTZ6Nw/He0pz4gU3pcw65M7eM9tJJYl9W+7Pwpz5+POufGk3YfL8oCodJ5a5LJt8GkBobHXpqUhRbMJuKOXaZzlak/zVg/GJo61CP+F+v4aSz/otDvycPvjatnvguetZ3SdDDLTlLeutJrnU34OQwR2uAZcYBsrEt3esimE197WK5UxyHRbJha0kJ2JcGYa5BjmUQNT4epKmOY+PO0exMq75YaBeXA2Y356fsHFupkmFBWdAok9ODMVG6sjqRGocXSnLUUInJQIuPZyKjp7fXML1b1eLQAyxTDT49WobUQmASf7FrpoGEJEBGCRaZgpt69BUbd40hrVJczGkxOadbzh98XQgVkzHGNioxZiP5k3zxPSSksXqFr6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBGcm9tOiBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4NCj4gU2VudDogVHVlc2Rh
eSwgTm92ZW1iZXIgMTEsIDIwMjUgNTo1OCBQTQ0KPiANCj4gRnJvbTogVml2ZWsgS2FzaXJlZGR5
IDx2aXZlay5rYXNpcmVkZHlAaW50ZWwuY29tPg0KPiANCj4gVGhlc2UgaGVscGVycyBhcmUgdXNl
ZnVsIGZvciBtYW5hZ2luZyBhZGRpdGlvbmFsIHJlZmVyZW5jZXMgdGFrZW4NCj4gb24gdGhlIGRl
dmljZSBmcm9tIG90aGVyIGFzc29jaWF0ZWQgVkZJTyBtb2R1bGVzLg0KPiANCj4gT3JpZ2luYWwt
cGF0Y2gtYnk6IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+IFNpZ25lZC1vZmYt
Ynk6IFZpdmVrIEthc2lyZWRkeSA8dml2ZWsua2FzaXJlZGR5QGludGVsLmNvbT4NCj4gVGVzdGVk
LWJ5OiBBbGV4IE1hc3RybyA8YW1hc3Ryb0BmYi5jb20+DQo+IFRlc3RlZC1ieTogTmljb2xpbiBD
aGVuIDxuaWNvbGluY0BudmlkaWEuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBMZW9uIFJvbWFub3Zz
a3kgPGxlb25yb0BudmlkaWEuY29tPg0KDQpSZXZpZXdlZC1ieTogS2V2aW4gVGlhbiA8a2V2aW4u
dGlhbkBpbnRlbC5jb20+DQo=

