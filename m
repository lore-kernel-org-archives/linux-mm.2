Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1148109E556
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30F3A6B0088; Thu, 26 Mar 2026 03:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E64A6B0089; Thu, 26 Mar 2026 03:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6296B008C; Thu, 26 Mar 2026 03:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0FB6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:33:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE4E8140C07
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:33:20 +0000 (UTC)
X-FDA: 84587398560.10.7DFD050
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf06.hostedemail.com (Postfix) with ESMTP id E0299180011
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:33:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Y9MIfJQN;
	spf=pass (imf06.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774510397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ye8DW6GyyJD7getvcUtRUM/yZE6iQTSdE502KFB+5y4=;
	b=oq0KFdFzDj4wbBCOJioQqyN4qOa3Vsa0eKyz055C+yv4jyV4FVgnDDadN9DdpoXHOkxIt5
	k/iG8p3dCTiYtIk0uCDMv9oDGNZcYtvhE9toMyhZNG/hlP81P3Iy/vSNW3zfAh0KJxfGZN
	7xh1/bRK/jJh0s7bt3MdwwUkH2NOSOQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Y9MIfJQN;
	spf=pass (imf06.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774510397; a=rsa-sha256;
	cv=fail;
	b=aaugzLwz7ln8QBrvMtC7b2yZRcnmABW1JNjSivY5FB1cdEDANV1dhACoWK2rYMWQgHrux+
	DZKGxn6GIrPdO6CCTmswZoETmxm/KjnGJDFZqTXHB4RajXih0Tz3VlBDELEEC1liOf6d/T
	2fmZkwIHVnwRIQlPMlNB3iD3M9Eu/Ls=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774510398; x=1806046398;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7W6hPXOUq0vddsWVbb7FN8pMFYp55HrlkoVvOlsG83Y=;
  b=Y9MIfJQNBv1dxviYHoAnzCYgzA/RkZbLl2VWd0uQzPVjTxjn0FyRmTC5
   i/9DJ6O9qhoaE9ATSQk9+SNHs7bAGKqxg1k8YpuWT/eusMBOrgVcx0g70
   GOrY/FZXMCC7N3e13D/LR6m3WzL4pcC3O6lY7ikNY48+BBnZdJgP2w534
   L/MTYPmxiQ5VoDG2c4uOpU6gt3n/9USmXho6V6f9NLXrvIukbM9e0bxlF
   ow6A0fC0Pp7r6f0ezIWwXMv/mEnX7yNWVMirUMkky2U+Nonl1k9Fkzl0N
   pV1OoH+k5v7eOsnGRSgEOjnU5EBO76yiAKm43i2Dnb1xk4ESpTmHn+COH
   g==;
X-CSE-ConnectionGUID: 4Gz3BYUGQoyvRZ9NlPf3eA==
X-CSE-MsgGUID: hZv16MImQpyOXlIEu/DpTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="75276565"
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="75276565"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 00:33:04 -0700
X-CSE-ConnectionGUID: l6dO5D3DS6S2U3Y6PO8f8g==
X-CSE-MsgGUID: 8S6RGeODQhCrs0AeKNhhcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="220520098"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 00:33:03 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Mar 2026 00:33:02 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 26 Mar 2026 00:33:02 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.63) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Mar 2026 00:33:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B0dGXlmbnnYpTV7KcVvoPZe91gj5sLHYBaBF9R1p3AKyk4AHP57L0qETn6bpoduQo4KfY0Yj8B76+juTmLUnrI96iECOG19bDL7reBxqXbOSGIO5PyjwxZFiYmpatXfD+WxyWr+2gWhkrSxiyMFlWAUl0gpOtkwMeaWSNn9vQbFS4m5bRGAXbHVJdsqfLW3WxZf1F/uZ+2ZNWjUFfphn+jV89sXH5kHS3ANZoN35zioQR8OB0l7o2rZwKkTu0uWq9Fa71yV2Nsim3b5NJtM1S154j+IECC2KMW5hQ+Jr780MhwxEB/PMp9sqGFXkL3WmBjrJNbeKX6AVK3C3YkwhEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ye8DW6GyyJD7getvcUtRUM/yZE6iQTSdE502KFB+5y4=;
 b=gwLnL4qM2sz76UP35eYpvCk5/TFIWF+wQNLXhcghJWK6Co9S2OU5sPTaFkMvCv44jEjY1Tx0AOMRX0leWVQgLy0Fyfc7YFkdrF2ccV98kCpW5RvZcbujAO/Z3yWfOhb7YvhJOzfNjZSufqoDjMgeiNZuyrWerW2NDCvqWytJHR8kIOTDMIFoc+1IppzLlY8Xn9XiJFIiMjcbKx8n2tyYfstpxNE84WAj5DUaWUkA8t5GcoLDIvVJuZJRLddi/FUSCstyXcfnmST4U0pL6gB+5KmdameM0WATAqknigBRldaP3o6q4OEEt1ppjjlnYTkw6rxl6N1ZKch8dRlb/LfDog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA4PR11MB9009.namprd11.prod.outlook.com (2603:10b6:208:56f::21)
 by SA2PR11MB4971.namprd11.prod.outlook.com (2603:10b6:806:118::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Thu, 26 Mar
 2026 07:32:54 +0000
Received: from IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541]) by IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541%7]) with mapi id 15.20.9745.007; Thu, 26 Mar 2026
 07:32:54 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>, "Zou, Nanhai"
	<nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, "Zhuo, Qiuxu"
	<qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan"
	<pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHct4abryaKSRoUW0qNNchDaIVkzLW8B6KAgARuaVA=
Date: Thu, 26 Mar 2026 07:32:53 +0000
Message-ID: <IA4PR11MB9009187EED35C9F23F476838A356A@IA4PR11MB9009.namprd11.prod.outlook.com>
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
 <acEpLz9zfAF6gS05@kernel.org>
In-Reply-To: <acEpLz9zfAF6gS05@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA4PR11MB9009:EE_|SA2PR11MB4971:EE_
x-ms-office365-filtering-correlation-id: 752f22b8-4604-4524-79ea-08de8b09e4a3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info: c+pSIwlcv8BtAh/fJDtqv62RsgHqC6BhgR+UUqs0INw2gsK870VMp78w52MXpQ40h6c8+qHRXmCCGqBOhAn2hr8rBbVBOFjfiwonYardfEO4Q8JpDXcfMYYw+BLGAFefFikPx8s3MKKtZ4gtXC/EmDP9cz76D9sOzWO7cM93ZB0rwLayWssXu7W0rImiyRGdJm83bxSIss0z+1h9Y8wKrnYC2dxEh2xJ6mGyU9D0CatwbKMdMNKJ7Gn9Tz8k0WHBev11ZpKqZbbMpYlV27eRoj6BmadoL0qKMkB3+servCGPENa8DGnzYorXjYEHacHIeeEKR/TexK/GXNtJ2SvIwEK0mAgRwhl4bLsosGz/2Z+wZZJQSc+Y4qohuwNzTTuJLDHJhXoFT9d3xR9QdfSVgQwDknSrqR0mU2RWaSkb1DUxl1Sc9O0ug+yECZE155KqDtSNSkiPG4HL4anl6Txxg/eYfL7Rwpa/yu0RdzdewHwnDuS2k63I7n6SBDDF5HNZp33773cgmfINTJl6/Q0yZvh63XehFUeMqwjd1OiHJRPZeTbuEeLlqmP4icFzlgx2xkzda6XAIg571Ymfc1KvHtnI3BhDS//EDq7M1EB8h7LzmVND1ql8K8bvk/dI2oST5aRmQaoB7cZUPV9ugmLmCReNS6t95Kw0hLqaWr0x1Go3ammY/f+yVyaBluW9v4AzMVlqcch740/PtuPDN6a+iQA/y7oopCoXr1CaHzxHJHKZDY59QBOBwyUSQAHajtlE5Yst5cCGa8tozop+LJFtrD0FmtcIgU/ESWp7N0hW9zY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9009.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Xrvl+4V1HwniUXMUw2jaaKv3eBB5KYjw7BbzylUW7julAdTmgFII5xjagYSo?=
 =?us-ascii?Q?RBYzrhaXxTiveIa18NYrAcrs+4P7+tLlKUBmAU6ObsWFDaao79/GZ+xoTp5p?=
 =?us-ascii?Q?ejImJOT7Whlr7wRSIHPsAmTTiuzn2ZEzKbDLwTTVFVJNDcOR/9aTlVPwhju0?=
 =?us-ascii?Q?MY19ruDU4dgEX87mlmdOKUVY0wK1iEXx3IPZeseEuf6gQJ8zIYaRKAcFGvHx?=
 =?us-ascii?Q?pE8GI10yGuTlhRErxQohSRbRiJnLgf0RxoHoKDi/wgXQHPSQo9V7xH5PIw5X?=
 =?us-ascii?Q?Hv38R+uV0OLgDK99egCoz6OjWHh3u/uwzsh/E2ZAOvWBBE+uDEqGiEhceIDL?=
 =?us-ascii?Q?s98vy4h4RdhCU+I4NiGvlJufdVlAsfCmhxCQfnN2VJzHAsNwUz4lYP8myEPc?=
 =?us-ascii?Q?COky6gIC+YOylXigHUd2pmMOa4XfmdjRG6gQWAxDNtwPMwnsb60cmcxnKpJr?=
 =?us-ascii?Q?0gdWOp32EURSTOUpBP97hj5c6ioBUiEutJs7VG4i3aBd/Y9e7/f12G4GDIrx?=
 =?us-ascii?Q?vP64TxDdm3J6G+sjYVF2Uv/yc0ztBEOia90ciHcAiqv7dr2KUgsrmPyb6DT0?=
 =?us-ascii?Q?Tw3ljkvE3i4Q28c2Flrs7xXQBeoWeW9q8MIp7ZA1bWNX3jHlsTrdSxl1u+VU?=
 =?us-ascii?Q?EKiRPLdsIhz2Mm38BzMQLKNJQhxpn2o5+oKTObNiAouMtVSmabY/4T43OR7v?=
 =?us-ascii?Q?r/Mhr05eOdNLbgTsDSYf/k+xfu83zOUW+DRge/jf9CLh/bjN2r1n6dZR9NAs?=
 =?us-ascii?Q?x8Hy5OOvNWj5NQPdX3/O6x+oxA/aP9fPnHezR6zbZt/ejN6zVgeNYcnUaQVw?=
 =?us-ascii?Q?PDVmZCrFsXKhtzguJtOirBh5wwwxpUTPU3iPQ0issN4crInHb1nKbJ3/ECO6?=
 =?us-ascii?Q?Io5Czjq3zFsmByGKpNe0M+4zpkos37ARxxLRO23K7Kj73EmjzBpbdOWIGK3u?=
 =?us-ascii?Q?pEP9+cKHB93jpzTau5A/4DaVyKkWUvJPSwWTDyysOqFHiFUkifgDEtmec25g?=
 =?us-ascii?Q?tuN/qFZ7bGuCqV1xDFjz0YGHLII37T5HJYfO68VehVEuxStrK2nvtpwPbaBy?=
 =?us-ascii?Q?caCbYLskxvN81SlmFZNXw/oo2Yuj4HqkM7E+pM/5ak6TIcgL1AP3cl+wQBfE?=
 =?us-ascii?Q?XVy1akoHaax38QrVVFsyccsfr1jWybCLSjYWPgojQmDuHv+vCrPEXmipCNJP?=
 =?us-ascii?Q?gQRcYfuS+R88lkVwDxC47A+gxz4Aq6M+UmfqTus6ZCmCcRVr05G+268az3bZ?=
 =?us-ascii?Q?FY1ZPBCLYbS++EEyRAxAW3IskJiNkNxc6rrwt0WW7kZJuZJ22rhiQyrFXO9E?=
 =?us-ascii?Q?98mXTilKMs2HX+966EZmXYA6fc5LMyFb7+0Bg2p8ADGk5H+dcciIGCIer4u0?=
 =?us-ascii?Q?ZbjvlT/EZthCYkhXUdb4bhendDccMiFMlzN9Fd3d5YxNXkv5zti0qsyndQOH?=
 =?us-ascii?Q?b+8Ju9YMye4l96GmnPOYGcicYgS1VeRDooLKKQ2Vn3J7PZtCMOSITmMQ5Dbi?=
 =?us-ascii?Q?P5gIPofQ1qHmQ73Eu4aXLe/q+oltNGpO/EbcBS53O2aYe2+XABsaxtg/0xdJ?=
 =?us-ascii?Q?NL6j4uB/m8FuCBGEsj6j//yDmaZdskMsjXxUVQjVZbFDqG+XLk/scloKwepL?=
 =?us-ascii?Q?VnWxY4qM6ATjcBr9lZZQgvSnBPm+cCbOS9FvNs/ZkiA/9yY5ZN3MambBYWrp?=
 =?us-ascii?Q?c6CwC2LtSaKqZ+6yFFSzxrkZuYYRuVZ776uicvHVdPkS+NBd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: CfB35s9qT9VeowIKQjwtP/W0Vtr8xfHTwku5DOYdpmQzigWwfrzYJjDZ3N4A+7Wf/JjRUVpJqN1cgwsjKIa/FH84DNxLi6D2B0+N9YE411aOeT8ut9YV36IQaen9/GdIS5x2vsO5Jc1xg4r68GtSlyuIr5svPHH0HV2GdP3OQ3XkJ/nfddoAy2rABOXajpY090vTvcSqV+IN8YyGyQ9muWljuN49DkzrQYh3vGtpruAmfMTVb8cQbSyMyQqwo/K5RQqohOwciinw2Fq0tiMxE81uDswwJRTaP2c8Ab4h+NjV4YBdmk3Z8KO5XJVtYJvniHHLnrdGA/51RSlPKd2QcQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9009.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 752f22b8-4604-4524-79ea-08de8b09e4a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2026 07:32:53.9881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5UQRd/ulpkHTw84j9BvRKPxYcFkmP6c+mGcxQcg15cm6IhHYH7BETer3jb+0FoWm7xIOwPZ3iYLs3ONhRHEoZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4971
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: mnnokof8hacd4o43fyuedgcuyg7o1dmx
X-Rspamd-Queue-Id: E0299180011
X-Rspamd-Server: rspam09
X-HE-Tag: 1774510396-508499
X-HE-Meta: U2FsdGVkX18br1MMfiCWQhbYvx6PvYlxl/3GDvjCxgUipugbDDuEvkQdCTEXI4OtFZ6Aj6XZtXPX/dABrYkvudxDlGox63oWax2HbUnitGsXgZ3CLaTHjt8UsrvuJ7+jmYVPIS7NGy9DW66DTo8TAhCsVbMVtsGknIUDxfOsYWx5WmFvYTRxQsDE+imPKIwFpnVET/UM7eu4kzRTCf/SMjbfRZFZf1UcYkuRnK/2ktMd6nW7FN3lXTIqdeLkdlptdvhxdRK+CIPzZBl4lq88ACowJYdg87hhzaZ/SG61g3JO4jEWAs2xyss4Xzer2Hnl2r46/y+1fvDPZQbqtvP0jW9dVVgEVSoUPyryq2i3S0iA4VoPERRxwtGGGeLejPLAIIlrDN9qnHh0zAqtyZGuPz2sbHOFLwqSiT4gGX4EtXEF7OKZywfYDid1vsqQ5JR2MyMD+x3a0kNLerYsfB8G031NclPHG372G+8iwaJiQSUTVh6Cj7245Zp4vtEVxU+2NILKfa/wvhUmFVdHRUxsLzjKN/W/3m0AiZGxbWj9c9lWTgBKyaAVzuOfq6ERf15Vf/ZtqUVFVpFghunRx2zJQqHCd4OzzHMwJWNY0blj7PKcdxEmrjbspNb+Ly5d4NNovMJnolF1W8YhXaZn97wQ3NTU9A2+iPngYZXfImEc/dL5Ik0YLftH123Iqs9jDVe/VYEzrvttnlx0FsXn2bQtmlFQgbXfHV6MwDoczReAHZxJcgwXLwX+xSXxuxt1qZbGoyc3q8ltCBSyjKznKICdtV3kFFUkPJhomgw0iNTGEf81+2aBFrhHx0SXnX2mEvIG693eXrsQ0sndwzqLojxgDv1U8wSopqH+We8NPlZPGruQ6r7+priNtZpcUa/vmvSC3+dK4t40QGgJFdkmVq8YWm5QynzCWtlpwwT4SMMYUX9hk4/i0tKDdeizgkjAnJkfs1lvw20XjB/xXP3Yngr
 0f5Z3t7C
 8DWGIxwi6kZS/RfUoILUv9sdnmnBBxU7ncYXGNdZi9r2s7Y7uBH5H28sKFyo2O6MfsE4SW1FOJJK8pEJJBimAgMdmUhFru68pG89wBADuzAsCR9HOSuwQI2ljXDJjkHd8rNWHGV4sZLtq7nPxCGBJ7604x91fMwiwjcbnuVjNuFQPiIkhmJO4ck//j481NvJt1EyCk2myJawKh5TKbmqqCDzHc6scxNVliVOgLQNxuOtLLtgVLAqNzKOV8ipOiZ/WEXKVK2WIqTwHC3j/g1rbUsmiDW+rQk0B/FpwdWVpFzpnjfPU4vZky1+5UVak+DrIsJzAdLwDhu2JsWbrvGKJlEmdD0DXsEV88I1gTNcWptyOPUTCqTVs0FGfPKhemINUF5naewzhZnu9JDi+q80P26c+y2tZtobJNH83Kju5f1xV45JFoITKXWBa9H4DVlKX0qJx3xpwyXDyVjx+EoCyKR2eBj4ancmvVEoJQNyZZxKOs8LSJE49FVfE/+MoOj0NSlKYoBLyDr7N6DArz+CXnppm1qKvjSF/bUwGNsQ4vOYElvbwd34PYF6cDPZdoG88ZWeKze0dwruZqJ3gQezxKV+x+UDGFl9WZ2xLuHHd/jqQPH/P6vwH26FWwDQlOqWEAJ0NUQKottLjweMlbgdTGJbf1NtfoUz63Wc/m7lTBhB0YDc9himMvU/GAgmKQAHjXYvdvwLp4XDjUUEKwEQzHmwZpQbDtpuldL7v3NdzJz4eHFCAsJFXNlxgCE9r15ZvxpNr4fckHf3W0UOki34hU+EqJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Mike Rapoport <rppt@kernel.org>
> Sent: Monday, March 23, 2026 7:51 PM
> To: Liu, Yuan1 <yuan1.liu@intel.com>
> Cc: David Hildenbrand <david@kernel.org>; Oscar Salvador
> <osalvador@suse.de>; Wei Yang <richard.weiyang@gmail.com>; linux-
> mm@kvack.org; Hu, Yong <yong.hu@intel.com>; Zou, Nanhai
> <nanhai.zou@intel.com>; Tim Chen <tim.c.chen@linux.intel.com>; Zhuo, Qiux=
u
> <qiuxu.zhuo@intel.com>; Chen, Yu C <yu.c.chen@intel.com>; Deng, Pan
> <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen Zhang
> <zhangchen.kidd@jd.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous
> check when changing pfn range
>=20
> Hi,
>=20
> On Thu, Mar 19, 2026 at 05:56:22AM -0400, Yuan Liu wrote:
>=20
> ...
>=20
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index df34797691bd..96690e550024 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -946,6 +946,7 @@ static void __init memmap_init_zone_range(struct
> zone *zone,
> >  	unsigned long zone_start_pfn =3D zone->zone_start_pfn;
> >  	unsigned long zone_end_pfn =3D zone_start_pfn + zone->spanned_pages;
> >  	int nid =3D zone_to_nid(zone), zone_id =3D zone_idx(zone);
> > +	unsigned long zone_hole_start, zone_hole_end;
> >
> >  	start_pfn =3D clamp(start_pfn, zone_start_pfn, zone_end_pfn);
> >  	end_pfn =3D clamp(end_pfn, zone_start_pfn, zone_end_pfn);
> > @@ -957,8 +958,19 @@ static void __init memmap_init_zone_range(struct
> zone *zone,
> >  			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
> >  			  false);
> >
> > -	if (*hole_pfn < start_pfn)
> > +	WRITE_ONCE(zone->pages_with_online_memmap,
> > +		   READ_ONCE(zone->pages_with_online_memmap) +
> > +		   (end_pfn - start_pfn));
> > +
> > +	if (*hole_pfn < start_pfn) {
> >  		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
> > +		zone_hole_start =3D clamp(*hole_pfn, zone_start_pfn,
> zone_end_pfn);
> > +		zone_hole_end =3D clamp(start_pfn, zone_start_pfn,
> zone_end_pfn);
> > +		if (zone_hole_start < zone_hole_end)
> > +			WRITE_ONCE(zone->pages_with_online_memmap,
> > +				   READ_ONCE(zone->pages_with_online_memmap) +
> > +				   (zone_hole_end - zone_hole_start));
> > +	}
>=20
> I didn't have time to review it, but it really jumped at me.
> memmap_init_zone_range() runs before SMP, there is no need for
> WRITE_ONCE()/READ_ONCE() here.

Hi Mike

Thank you very much for taking the time to review this patch. I will fix it=
.

> --
> Sincerely yours,
> Mike.

