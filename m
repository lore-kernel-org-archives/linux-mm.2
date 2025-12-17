Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67D4DD65C7E
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 17:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C81AB6B0005; Wed, 17 Dec 2025 12:16:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2EF96B0089; Wed, 17 Dec 2025 12:16:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD92D6B008A; Wed, 17 Dec 2025 12:16:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 97B5D6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:16:06 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47FF01A0AAD
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:16:06 +0000 (UTC)
X-FDA: 84229615932.02.C781C71
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	by imf24.hostedemail.com (Postfix) with ESMTP id 149A9180010
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:16:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JcWH7yGH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of skolothumtho@nvidia.com designates 52.101.46.21 as permitted sender) smtp.mailfrom=skolothumtho@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765991763; a=rsa-sha256;
	cv=pass;
	b=B/OxxwJz6I2TgeTjlPbHBoD8/0fj9/Xr8OJZ1+wgK34qu1kK29cG0AmBxjAfi5siXAdJYY
	0bBcFrLYIWm+YPjI5d4/Z6aB0a19mR1VlfQ1xbr/k61y73iumn1h6Y9gg0ofSKNxkBU8J6
	EkqTiPZ234IgiDlJpF806LdGsH4vSTQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JcWH7yGH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of skolothumtho@nvidia.com designates 52.101.46.21 as permitted sender) smtp.mailfrom=skolothumtho@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765991763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=spzLDqLrCXO+Tffu2yWEWhat8iEaROKYddL08uI0w98=;
	b=BN71O8V5Y/WMpY9DVFFJ6xrAF5FHr8fgEqa+36SiK5fkXR6OAZXjjsPN0CiFce91/HB6RN
	cPe37i4yt7BttudDM+HQvbcL4M3b/QOvOwRYgQ7VS1z7DUUinurrcqhleAL/JkrFoPX+yN
	sJFHevNvWfEzSZGqJPhv3vplvQO/+6M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vyzi2QM4ZmpAGgJ3/HbXbu3S8C3STm5HxwFH8bnexjd3jFWlcyfF3y8+Ht1F0YxuOyBMgstA8DIa8Prd1FXdiJnUd7b+hxU+Rc0lx2VJkSCfYnTtr0FX9fJzhySzRGfu7h3dkjB0DYFDhxK4WHtvMSblG0ha8jIcdWlMd5A6a8/zaaFiRTjE1ZOM2nPVBXZ/jKCHp6x8EULQZzygBS2HssS9HpKefqZF1EmOyyMQO5maEt/pplldAu7WrHPlR8b1AuMpFegkUr/fdptkWiq4+Tf/c1gjAFSh58FGOrHu+iQjdPBEJOn5HxbiYb0zBuabftGTeTLhxEhlLE/kAS2MZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=spzLDqLrCXO+Tffu2yWEWhat8iEaROKYddL08uI0w98=;
 b=sJxoGkRoeVhBSPEHEfPj2QkvFiR7i3q1/aCq1HotMJxSl+sW/uqM1i3U+CcJP+GybiYAG3tjCbAKHlPz/AJB5Z2fKKKkfj65vG2EcvZcch8es+y6/7/DT+e5b8pUMiIVBKHuXqdJeklKginhRoIEM8hUSHH/vZGdPpFzgBj5XfevGt/waicpq3Ficnf9Zf9VBRecJJ6vOjDqVBLuZxt6kkoY1p7x/xKcS5IeWuCuSMdcX+NeUukejWkU9Kza0uuci1DRgk9xR+5t70jGHAiGDDwfMmgDiASej43VsF6aXA/cAoCBG1MQo1oIxFge9T4ITN+BKcfb3J7PJt8l9H0uuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spzLDqLrCXO+Tffu2yWEWhat8iEaROKYddL08uI0w98=;
 b=JcWH7yGHhCqW6zq6TMapgafe50mDQZ0xSInfqUykjaDlYUjDzK0gtOfSG9Rnr9PnRB2jAi67tjx+vjHDSIY2oigCcxIIawZVq+M5HYppGK6tHBAaieDyijfHxHw3B8Tbj9aumHTHA9Xs4XxxLL+w7P9hANdOgYbjgqxoGHE2Pw8yVmahIIvHpaJXBHVG7NUNLn4+iVS6NHNnXHKxi/tGV/LJPMsaEVqt7Rt0l76OOPt32zAwrrwTZfyyjyk/Hyr1rCZ9qnanwGBotAA3MPuElU1UrNxrRYtuW90u+l+fbBKhFHFqP8sTluuZE/K13LviBCY1sQwlnaJB7bSXeH5YLA==
Received: from IA0PR12MB7555.namprd12.prod.outlook.com (2603:10b6:208:43d::5)
 by MN6PR12MB8591.namprd12.prod.outlook.com (2603:10b6:208:471::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 17:15:58 +0000
Received: from IA0PR12MB7555.namprd12.prod.outlook.com
 ([fe80::963e:9c86:4830:2ebd]) by IA0PR12MB7555.namprd12.prod.outlook.com
 ([fe80::963e:9c86:4830:2ebd%6]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 17:15:58 +0000
From: Shameer Kolothum <skolothumtho@nvidia.com>
To: =?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clg@redhat.com>, Nicolin Chen
	<nicolinc@nvidia.com>, Leon Romanovsky <leon@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
	<logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>, Robin Murphy
	<robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, Jonathan
 Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, Alex
 Williamson <alex.williamson@redhat.com>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Ankit Agrawal
	<ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs
	<mochs@nvidia.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "linaro-mm-sig@lists.linaro.org"
	<linaro-mm-sig@lists.linaro.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, Vivek Kasireddy
	<vivek.kasireddy@intel.com>
Subject: RE: [PATCH v6 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Thread-Topic: [PATCH v6 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Thread-Index: AQHcS87c99CPn11PS0eBuCwGSI7Fa7Ti6FSAgENttwCAAAOkEA==
Date: Wed, 17 Dec 2025 17:15:58 +0000
Message-ID:
 <IA0PR12MB755536B17795F5188B9493EEABABA@IA0PR12MB7555.namprd12.prod.outlook.com>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
 <aQpRz74RurfhZK15@Asurada-Nvidia>
 <9d06837d-7aed-43ef-87c2-1ce4f921dff2@redhat.com>
In-Reply-To: <9d06837d-7aed-43ef-87c2-1ce4f921dff2@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR12MB7555:EE_|MN6PR12MB8591:EE_
x-ms-office365-filtering-correlation-id: c420b1fa-a55c-4a87-e750-08de3d8ff204
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VHdKVkZkUXlwd1pQaWNadkJXSFY1WWM5eExHUXZvK3l3Z0tVRkhlN2JVTzFx?=
 =?utf-8?B?alFoNFRpYmpVTExaL2FLZ0NvWnUvQnhkTHZocjR3MXZiNWhqeFpPeEQvMEZR?=
 =?utf-8?B?WFRUQXoySjFFYUdzR0REdEg2eEtsMzk2QU5KZjJ3Z2JIKzBlZzBLWUZybDRN?=
 =?utf-8?B?WmRJRGFiYnBhSHVFT3A2MmRZWU5tRXcvS2xVbmVJT3ZkVG1vUXZNUDN0WVZ2?=
 =?utf-8?B?WkNYQjA2UUk4dGtiQ2ZTeVFFMUNBSEg2d3F6aTh2VTh6UktJZ1RkRDZYZE9w?=
 =?utf-8?B?ZGVVZzM4eUs3c0gwaXREQkVrVFZBYjVBeTdUdXBITkM3aEc5c1FxeVhRRlBz?=
 =?utf-8?B?L0pQd2NraG9jbXdUV3JDK0MrVlJycS9MVVhJaDFRZDFIMkNGdlUwSnVLS2hQ?=
 =?utf-8?B?a3hzTC9LamNZRzNhUzNIWEV0bi9WeDlTN04rTklWWWdtSGhYc1RvR25aMWho?=
 =?utf-8?B?M3dWOU5PLzhFNDFHd1Vtd3VjdW1yVjEzeFdqWURpcmJvZzladjRaRWRkVWpa?=
 =?utf-8?B?SlYxWCtBbWJ2dTlSeXo2U291b3d6R2FkVW43RlMxRHhIL2lOSUMzbHNCV3dV?=
 =?utf-8?B?RUtRaWR5RUFCamloakZlNDVwWGJnSzJveXo3Z0JjUk1yOExkYmdQMngxOWZU?=
 =?utf-8?B?UklGNm82eDdHa2UwZXoyTFFMdmRTN1p6NlZHK0hQRjQrSTN3Q1J2QU40OXpi?=
 =?utf-8?B?bTFuenRCeDVkTWtVZGw0MndEL0NsbUI2T3FsL3pBbE1YRDV3S0NEV1lidVdq?=
 =?utf-8?B?VElHTzFIazRqQm05a1VLTmYvVE90eWd5ZmZwbk03eFRhdjBtVU0weE9rOW8v?=
 =?utf-8?B?U3pTdmxPMkJkc29UaWhwTHMrTDNTN281V0ptQndHd2NDTTlZNHhHN0hoWlJl?=
 =?utf-8?B?UEN6WjlUdVRIYm1rVm1FMFp0MGd5V2FZcUhFbzdkYWc4Y0tZemduOXI5Q0Yx?=
 =?utf-8?B?Rm5MT2xCaEVSUEhxZEFSY1daczhUR28xaW1yUmRsQ21mYkNOTVl6OEVXaFQ0?=
 =?utf-8?B?U0NnTTdDaWo5WWNkb2QrblFIRnR6TjFIV3g0WVRnZVh2clVzM0ptdWtjL0RB?=
 =?utf-8?B?VDZZZWNKSyt5K0F3aXRHNTUwMVAyRzdNU2x2c1NpbHJ3MVNxYnBtY3pkQkk4?=
 =?utf-8?B?SVV3cUkxNm15bTd2OFVKbFVNSUNTQmZXRDRxUTZSWERDU1RTMVd5L1krSGRV?=
 =?utf-8?B?TS9FazhVTU9qUmpOZWdMU3NaK1VUWHI2UElZTmw5My9wY1lvSkxYaXArazk5?=
 =?utf-8?B?amI3eFNRRy9vWWdWRmNjcC9OZHBhaHVqdExoTzdaWndVS0dyWkFlRC9MYitO?=
 =?utf-8?B?R2RWU3JmbW5TWml5U3dxVnRvZWp1ZmZldG9wVk5OYnNVVUVzeWlLNTZxV2Zt?=
 =?utf-8?B?OFBhUCtoZnBDbzNyVE0xc01wM1p6a0dKQnVSaWc2ODBmaVNhb3VjQVpwblUy?=
 =?utf-8?B?YjhTVklUdGJoTWoyWUlja01wbzBLWnJNY2RKZTJ2MTR3eFBZVEhBc2o0aTBv?=
 =?utf-8?B?WHB4TXVqMzIrRHYvOEJsbmQyY1F1WWM5YkFmQkhoTUdrTEd1dklWL2hScUUz?=
 =?utf-8?B?NVpCWnhOYU4xT2g1VmhGdTJ6WXl0L2hEYjhBMHZ5RU9xcnA4N0ZPQlkzeTdn?=
 =?utf-8?B?MXYrNFpvZHNtZmNnTlZJb1ZIMXRvSnowUFdhRDVOQWltRWJTdG12VkJaU1dQ?=
 =?utf-8?B?TFJuVXFoN0RMNVV2M09UMmRoaTByU1BDVVdqdnhwQ01mMjNMYzBZUUxEMkkz?=
 =?utf-8?B?WUM1UG5Gck9UTHBDZy9udGNNRTd4OUw5NXdtZ0c1QkM1RlhwdUpCeEg1Skll?=
 =?utf-8?B?OGMySVJxT2FZWllyU3hwbjg4b2V1VVY1QW04ZEs1WUFta05LZUtlZVh5dFRL?=
 =?utf-8?B?Uk9WeEVOaUhFdWxMekMwR3VzT1hYbk4vZG5vaFBaSjAxNThxN1BJWWs0VlZF?=
 =?utf-8?B?WDErYWpwcEQyajdGQmI5dm9DV0NGWnZXd2tMenFpamZsVkxGVGxCcVFRM0Vk?=
 =?utf-8?B?VXQ5MHlZUnRtOWhBd2J5dk9Rb3pIYndxTGlyM2wzYTg5NW9rRndzT1R4Y3ho?=
 =?utf-8?B?d2lRZHNRSURUOWtxbTRsRVZiVUNzc3ZMemRvZz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB7555.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WnQ0dXVsVm94WG9uRlhhcEw5YmROL2t1UGZra0ROeGNYTlpFbmxyblczSWd0?=
 =?utf-8?B?Rjk3TUF0eUZzejdMcDlrN0NPSjdHWkl6MkdwVTJGUGx2Q0xJcERlSTFFbVkw?=
 =?utf-8?B?WE9CVG9ZOHZIRDhqZ20zQS9mamFReXhrVWo0ODlneTFOTkc1SW1RL2k5VDVn?=
 =?utf-8?B?WHBXekhMekFYRUtERU5RQ3lENk9PWHhkMCszSGwycVhSNHZoNFdielBzUS9l?=
 =?utf-8?B?Ulh3OUliUW5wWjlLeGNFY0hwaHIxcGtXeE9uaVQvYjNiWXR6dzMyV1V0aVdK?=
 =?utf-8?B?VkhhQkFFcFBFeCs0eFlkZ3RrTlNWSnZvQkswTi9TZHRuRUxML2RlWjdsRTRO?=
 =?utf-8?B?YXh2WEZDRHlsYkVQTnJ2ci9kaDRrbUxaeElhbEdsOVhweXYzYlR6dTNCQ2x2?=
 =?utf-8?B?TkZTM0M4Zm5ueURCR3RqUzZOa1MzTmova3RQZTBJVytXTGd2ZStiQThzZzVP?=
 =?utf-8?B?YXphVTl5ZHhhM0hPU1loT3oxZUdTMmpNV1NoYmF3UmpGWURCZEhvdmxPVFFj?=
 =?utf-8?B?a0NPWDAxdGlTNWRpNFRWR3B5OUVqTFZLeFFvc0JKcDVSOU5uS3JGSmRodk1w?=
 =?utf-8?B?VEwyMVJyVkEyKzlFclBwU0xTdmRZbUhpKzVKYm1IaXIybVZ3dUVGUmdqWkVj?=
 =?utf-8?B?ZjJhMkhib1dmNEdNOFl2TFZNd0xKUjVxQnpnZENRQXc2S0hMMDEvVVEwcTc4?=
 =?utf-8?B?QzhqaGF3Tit3VDE1U08xNVMvQnlQRU51KzVEMHpNa0JmWVk2Ty9WYzBNTEo0?=
 =?utf-8?B?enVEWWxuQzhDZE1RRlhwMk1LWXJiam80QTNkVk80ZFlhQ1g4SnM4RDRINEJR?=
 =?utf-8?B?TEp5cU5kUW1Nb2R2QmNZZmlVaUhTV1R0V3BwMldGbFB0WlQxZ1duUTJjV3d2?=
 =?utf-8?B?T2JzNjVZRklCbCs0WCswYkdkaitKaUZqWFZEem53am1YTGphWmh3RkJwQzQy?=
 =?utf-8?B?cWlGNVVBeldJSWViMlpLVWptM1p6bnZ0Y0g1ajcyNk8ycDM3dk93dVJIalVV?=
 =?utf-8?B?bENublZqMUJxT05QQ05qUVlkSHBaTFlwRGFqamNnQkxjVm12dHpRYjN1WkpW?=
 =?utf-8?B?V0Yza2cyYnJEQjNudzk1S001OTc3N2Fwa2pFNEE5cWo3VjQrVWZGT04zek1n?=
 =?utf-8?B?QTZ5S2xxZFFnRFZpdDlMU1FacnlXU0hScFMzZjFSUmQ3SUtGYzVqa3U1Sld0?=
 =?utf-8?B?WjMveXpwSzJwZEVZVXZMVnZCdUJiUHk3Qm1Scy9sOHQvY0lMSVFoZmlMYXk2?=
 =?utf-8?B?d3hzSThWbG1QbkM1Wm9yaHJ0ZSt6RzBmSVlZZHdVbFNRNHJkcUZxVlF0bGxD?=
 =?utf-8?B?cERKQ1RLY25hVWN4K1JIdnF5M1hnQWFmekN2a094bjlvdGdGb25QQklFY3Rh?=
 =?utf-8?B?by9yMGgyd3FRWVlJNndBQnNuTEJzSWRUbHUvNUJxaGJ0UkVZd0UxM2tvUlQ4?=
 =?utf-8?B?NHJqZzgyUzBIbDZmL2dhcDIxVWtzaGx5Tk5CMU9ySnhpZHdPVHNha3dheXow?=
 =?utf-8?B?bDVOeDhrUkNkb0NTUVpDTUZmM3AvSGtpK1RYaStQVzBUQVhTelE3blBvMmVO?=
 =?utf-8?B?Wkhrbm93OHFJM0phUklwUGx4akV1dC9kOWxiMXI1Z09jYlBaVlVVZmptTnhB?=
 =?utf-8?B?QlFjYWpudmhob3Q4aWZuMm9XOXV0L3kzS2xWVWVFR21HUzFOa2w5RmJMOE5M?=
 =?utf-8?B?dHNHcG81eldCNTlJRGhMeVJOdFRnSlI1aE96WEw5OUY3VFFEMWRaWkJuNnJ0?=
 =?utf-8?B?OXB6S2h6dUxxVlBla3BXelV1Wkcxd1NUZHA3T2E4azZwdTc0bkh5aWREUUtp?=
 =?utf-8?B?TXJwV0Y5bVJtd2wyMlZ6MVpIQml6bnd6aTJYOXBOdWMrd0Q5VkFMNXFlRWVo?=
 =?utf-8?B?TEc0SDcrMXYxWTdPb1RMdEZMdG9KSWc3UVhHbklXd3A4K0I3YUZmZlVkdkVD?=
 =?utf-8?B?MFYyWEVzTldnUmpvaC9VWXRpTHcwWnBpSDhQQkxzR1pqN3NOMWZEM0xnUnk1?=
 =?utf-8?B?Mjh2WEJDVzNkQ2VqNTlrNEdXeUVuT2RVUVRJcGw0dnk4YSsyMVdoUkwycVpD?=
 =?utf-8?B?dC9Fb1ZqdkpUbmJ1cVZPK2ZVbjBPZ294SzVHWUhoN2RaWkdUU3ZMYStiVWp4?=
 =?utf-8?Q?dcySGiy6iB4ECBGoyOx//+LdB?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB7555.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c420b1fa-a55c-4a87-e750-08de3d8ff204
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2025 17:15:58.3008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qlRWOrUFPXgxAjYsflhpylZV9NnmYzjka6TGy1VIWX3hN3ERYJWjoi29VT51tUtdy/j/KsotZL/6/8YxlIWigw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8591
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 149A9180010
X-Stat-Signature: mzc145i3cfi1y4iuc7p694cbb17mtwad
X-Rspam-User: 
X-HE-Tag: 1765991762-473306
X-HE-Meta: U2FsdGVkX18FEPhW9+WgqCY4jHVZRDiPqBGAmRsavN1Snx/pW19UI5b4xIjpbNyuwPh5BGP/wDipB1Su0tLGfG4crjx+pCcTLBxY/FCzb9ipSNbroMwF4EyNbGwz8Crs3w4ANKHIZp/zOim8w/KVJP8OaiMQ2RRq5nTxaFkmGPdWrKB0FKA0LbNBrYp77IHFY55+3P7v/N0OLYbwalljo7cNDRnM3GoTmad5nbEV7NBYIN3uT49zTPrHv0Usso2EmuDtS8Y+QL3z7mxiTh10dUxqUc9ynJU2rCOKZVuB4KcXppCYIggZw6ymsduuj7A9QkVOC1Qd++yiPimfgy7GhGb2M81bYSZPFHa1qF4lctdQVT9RqsSLtIemGoOHnsJdBfPGV8Rzeizrz96XwW3r2UwxmRP9ExC3DRmf9jX+9rgb5OxnoFtDwKDPtkaQJm5FLkRqK+ztqMH7N/aFznAl7imVriLjg9iFvWK9EF3LOaLbHV0CC/uP9uqJys+cYFtg8J7bLoZS0dY5iARpTXNzOuILTjxAEmE22FfwO9UleJrUaePewlMsu969Qc3yYXzFlcnn9K9AGIGznwXelyC3cXhunUOun7SdGLTLMfK7+sdg0AcKzqgycn0yN5iDZe5ZQ4vUKl3RG8LKGczJ7OJ0ZTaDCo1sZbE3OIurvaY+1UD5Em8AYOZTCUZswc9oqLdqc572VCN4S39UD7tMPo29VduYaV+y2RdN0cbk2vxZK6s7owrtqu7ns+Mu1PToapDqJM4zOa9Ne4odf9iga/VxhgmqOW1ajEblc9CyASBmj/Gp4+4mtWiSO5n3XLNQaXWjVo/qCDOxWl8miZd2/U+WMUqlh7V9TriRG3zOx+cjXptxKP+rj84zTM13gRlF7tuUmbhiVlvYArE4dhKN65CGu7PQX9FhbtIusMAyJx2oq2dQ9y8Yezml4v2F4r1uQiBoqC9AuupR1cOb5KssRG6
 Z7SUxhRY
 5X2dnR6XN6sGHSsdU+xfslY4z3OsWwH2PlDss8sCoyMS6lt5wWuDgqt98eq6ddLVjHfDYF6YM3y4Ul4p+VOpP5kJj7SzbVMqrG1kjIfeMeqYALbA5RFf4+H0D6R5WrE8lcYDKvk43waj+X3tXT2kFX2vcLCWdaBLdtORE8Lq11cSOb5ZgjGGU5w3SNzYQPWH6vzFczYzjseju/5rJvLdgW3El3Sa+UmatuboHwwgaLLHL9l9DmkmJdvDn3K4QEXD9hIZWMKDB+63GCoVqM/6Q3ZYvCWsd8M7K2PF1BVur6Kba7v5takOiFBuaCaatGb1O+9HahrQrspaS7obl4llpO0xhz7aGVQLa/O0D46RiamCUz9R7jQUbAj2HnVII3TTDEGosqm4ohzH9eEScC4suQFc7wVw75JmQzQ9BaLav7qJJ2MXHtPcWHb/gt9hQicu4jNXK7gZyeUIb5oWcT+0oi6OIEK5hAQi1dkh5/d1/1vYziPl0Vmiv7lUd/ZqS484v1mZnjUQWlcVYhnAWl2BB67Oy/nxJPCR2hgG19xnislbbCAExNdECQk5TMKwTu6/TJLOBDsJCGCMSt2NxfzpnSoV2fLPetQeTBTkRRrfjuXv00hFHqZSgDxxcpwW2KjODs+SFtihWXmxA/XlcdyCURvUkgusc81u12iNxFOJjLAum18TuUwmar/QbK9AOL/oAaoSOAzdRTXEPyQDwxgMjCj1wYhSLe8AieO1b6Gud430Iap6SNDFgapcdvKYPkvFVibNrxYwX3hs5sFPI1mTOqho5XDLbMjN78xSa+ig4i42th5aDyvp0ltgMrCTwdL1Z2trffohHkAjM2qNUO7/FwFP7OdzM0r5y/rgOWcuhsbNPzmljEafhLI/0QKd6C+QMI1LG9ncc5Hm7I9+xI/1qzhr4QrSTSHPcX4MN2TtDljLzxIl9EvKE+sArTQPh7L97dHn01Omqxbc5aRZAtgx4zp5g++qp
 AXvrFUxJ
 TSPsVCRYm9sOtoLfRfcLz3r1nRESQkEUgdCQcB8uiv1iS/O6eBKyTVbClENT+NKrm1idBuBeYYC176vjl/pOsBJO+5nbdGZAcFQ0hqoJjkVdwVMwvjOe08AlQE0muMJjWbbHnDbGrLtc0Wtbl79KTy65EjqJdzQKYHFGK0F1kF6fftfEl4o6sMfZmVA1ed7URRzoQHCm1ofFUAAgN5Y6C0UUIyg/bpXC9WaW6GA+R3o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgQ8OpZHJpYywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDw6lk
cmljIExlIEdvYXRlciA8Y2xnQHJlZGhhdC5jb20+DQo+IFNlbnQ6IDE3IERlY2VtYmVyIDIwMjUg
MTc6MDINCj4gVG86IE5pY29saW4gQ2hlbiA8bmljb2xpbmNAbnZpZGlhLmNvbT47IExlb24gUm9t
YW5vdnNreSA8bGVvbkBrZXJuZWwub3JnPg0KPiBDYzogQmpvcm4gSGVsZ2FhcyA8YmhlbGdhYXNA
Z29vZ2xlLmNvbT47IExvZ2FuIEd1bnRob3JwZQ0KPiA8bG9nYW5nQGRlbHRhdGVlLmNvbT47IEpl
bnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz47IFJvYmluIE11cnBoeQ0KPiA8cm9iaW4ubXVycGh5
QGFybS5jb20+OyBKb2VyZyBSb2VkZWwgPGpvcm9AOGJ5dGVzLm9yZz47IFdpbGwgRGVhY29uDQo+
IDx3aWxsQGtlcm5lbC5vcmc+OyBNYXJlayBTenlwcm93c2tpIDxtLnN6eXByb3dza2lAc2Ftc3Vu
Zy5jb20+OyBKYXNvbg0KPiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT47IEFuZHJldyBNb3J0b24g
PGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+Ow0KPiBKb25hdGhhbiBDb3JiZXQgPGNvcmJldEBs
d24ubmV0PjsgU3VtaXQgU2Vtd2FsDQo+IDxzdW1pdC5zZW13YWxAbGluYXJvLm9yZz47IENocmlz
dGlhbiBLw7ZuaWcgPGNocmlzdGlhbi5rb2VuaWdAYW1kLmNvbT47DQo+IEFsZXggV2lsbGlhbXNv
biA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+OyBLZWVzIENvb2sNCj4gPGtlZXNAa2VybmVs
Lm9yZz47IEd1c3Rhdm8gQS4gUi4gU2lsdmEgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz47IEFua2l0
DQo+IEFncmF3YWwgPGFua2l0YUBudmlkaWEuY29tPjsgWWlzaGFpIEhhZGFzIDx5aXNoYWloQG52
aWRpYS5jb20+OyBTaGFtZWVyDQo+IEtvbG90aHVtIDxza29sb3RodW10aG9AbnZpZGlhLmNvbT47
IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPjsNCj4gS3Jpc2huYWthbnQgSmFqdSA8
a2phanVAbnZpZGlhLmNvbT47IE1hdHQgT2NocyA8bW9jaHNAbnZpZGlhLmNvbT47DQo+IGxpbnV4
LXBjaUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LQ0KPiBibG9ja0B2Z2VyLmtlcm5lbC5vcmc7IGlvbW11QGxpc3RzLmxpbnV4LmRldjsgbGludXgt
bW1Aa3ZhY2sub3JnOyBsaW51eC0NCj4gZG9jQHZnZXIua2VybmVsLm9yZzsgbGludXgtbWVkaWFA
dmdlci5rZXJuZWwub3JnOyBkcmktDQo+IGRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZzsgbGlu
YXJvLW1tLXNpZ0BsaXN0cy5saW5hcm8ub3JnOw0KPiBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51
eC1oYXJkZW5pbmdAdmdlci5rZXJuZWwub3JnOyBWaXZlayBLYXNpcmVkZHkNCj4gPHZpdmVrLmth
c2lyZWRkeUBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjYgMDAvMTFdIHZmaW8v
cGNpOiBBbGxvdyBNTUlPIHJlZ2lvbnMgdG8gYmUgZXhwb3J0ZWQNCj4gdGhyb3VnaCBkbWEtYnVm
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbDogVXNlIGNhdXRpb24gb3BlbmluZyBsaW5rcyBvciBhdHRh
Y2htZW50cw0KPiANCj4gDQo+IEhlbGxvIE5pY29saW4sDQo+IA0KPiBPbiAxMS80LzI1IDIwOjE5
LCBOaWNvbGluIENoZW4gd3JvdGU6DQo+ID4gT24gU3VuLCBOb3YgMDIsIDIwMjUgYXQgMTA6MDA6
NDhBTSArMDIwMCwgTGVvbiBSb21hbm92c2t5IHdyb3RlOg0KPiA+PiBDaGFuZ2Vsb2c6DQo+ID4+
IHY2Og0KPiA+PiAgICogRml4ZWQgd3JvbmcgZXJyb3IgY2hlY2sgZnJvbSBwY2ltX3AycGRtYV9p
bml0KCkuDQo+ID4+ICAgKiBEb2N1bWVudGVkIHBjaW1fcDJwZG1hX3Byb3ZpZGVyKCkgZnVuY3Rp
b24uDQo+ID4+ICAgKiBJbXByb3ZlZCBjb21taXQgbWVzc2FnZXMuDQo+ID4+ICAgKiBBZGRlZCBW
RklPIERNQS1CVUYgc2VsZnRlc3QuDQo+ID4+ICAgKiBBZGRlZCBfX2NvdW50ZWRfYnkobnJfcmFu
Z2VzKSBhbm5vdGF0aW9uIHRvIHN0cnVjdA0KPiB2ZmlvX2RldmljZV9mZWF0dXJlX2RtYV9idWYu
DQo+ID4+ICAgKiBGaXhlZCBlcnJvciB1bndpbmQgd2hlbiBkbWFfYnVmX2ZkKCkgZmFpbHMuDQo+
ID4+ICAgKiBEb2N1bWVudCBsYXRlc3QgY2hhbmdlcyB0byBwMnBtZW0uDQo+ID4+ICAgKiBSZW1v
dmVkIEVYUE9SVF9TWU1CT0xfR1BMIGZyb20gcGNpX3AycGRtYV9tYXBfdHlwZS4NCj4gPj4gICAq
IE1vdmVkIERNQSBtYXBwaW5nIGxvZ2ljIHRvIERNQS1CVUYuDQo+ID4+ICAgKiBSZW1vdmVkIHR5
cGVzIHBhdGNoIHRvIGF2b2lkIGRlcGVuZGVuY2llcyBiZXR3ZWVuIHN1YnN5c3RlbXMuDQo+ID4+
ICAgKiBNb3ZlZCB2ZmlvX3BjaV9kbWFfYnVmX21vdmUoKSBpbiBlcnJfdW5kbyBibG9jay4NCj4g
Pj4gICAqIEFkZGVkIG52Z3JhY2UgcGF0Y2guDQo+ID4NCj4gPiBJIGhhdmUgdmVyaWZpZWQgdGhp
cyB2NiB1c2luZyBKYXNvbidzIGlvbW11ZmQgZG1hYnVmIGJyYW5jaDoNCj4gPiBodHRwczovL2dp
dGh1Yi5jb20vamd1bnRob3JwZS9saW51eC9jb21taXRzL2lvbW11ZmRfZG1hYnVmLw0KPiA+DQo+
ID4gYnkgZHJhZnRpbmcgYSBRRU1VIHBhdGNoIG9uIHRvcCBvZiBTaGFtZWVyJ3MgdlNNTVUgdjUg
c2VyaWVzOg0KPiA+IGh0dHBzOi8vZ2l0aHViLmNvbS9uaWNvbGluYy9xZW11L2NvbW1pdHMvd2lw
L2lvbW11ZmRfZG1hYnVmLw0KPiA+DQo+ID4gd2l0aCB0aGF0LCBJIHNlZSBHUFUgQkFSIG1lbW9y
eSBiZSBjb3JyZWN0bHkgZmV0Y2hlZCBpbiB0aGUgUUVNVToNCj4gPiB2ZmlvX3JlZ2lvbl9kbWFi
dWYgRGV2aWNlIDAwMDk6MDE6MDAuMCwgcmVnaW9uICIwMDA5OjAxOjAwLjAgQkFSIDAiLA0KPiA+
IG9mZnNldDogMHgwLCBzaXplOiAweDEwMDAwMDAgdmZpb19yZWdpb25fZG1hYnVmIERldmljZSAw
MDA5OjAxOjAwLjAsDQo+ID4gcmVnaW9uICIwMDA5OjAxOjAwLjAgQkFSIDIiLCBvZmZzZXQ6IDB4
MCwgc2l6ZTogMHg0NGYwMDAwMA0KPiA+IHZmaW9fcmVnaW9uX2RtYWJ1ZiBEZXZpY2UgMDAwOTow
MTowMC4wLCByZWdpb24gIjAwMDk6MDE6MDAuMCBCQVIgNCIsDQo+ID4gb2Zmc2V0OiAweDAsIHNp
emU6IDB4MTdhMDAwMDAwMA0KPiA+DQo+ID4gVGVzdGVkLWJ5OiBOaWNvbGluIENoZW4gPG5pY29s
aW5jQG52aWRpYS5jb20+DQo+IA0KPiBEbyB5b3UgcGxhbiB0byBwcm92aWRlIFAyUCBzdXBwb3J0
IHdpdGggSU9NTVVGRCBmb3IgUUVNVSA/DQoNClllcy4gV2UgZG8gcGxhbiB0byBzZW5kIHRoYXQg
c3VwcG9ydCBwYXRjaCBzb29uLg0KDQpUaGFua3MsDQpTaGFtZWVyDQo=

