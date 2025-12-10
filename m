Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E167D3E773
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 18:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AC666B0006; Wed, 10 Dec 2025 13:47:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D446B0007; Wed, 10 Dec 2025 13:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40106B0008; Wed, 10 Dec 2025 13:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC0CD6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 13:47:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B6C45A0ED
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 18:47:29 +0000 (UTC)
X-FDA: 84204444618.28.0E933AD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7AA4DA0017
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 18:47:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ce0BJ+WE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765392445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DO1cqc232jK8XsvRRtiHf11JVrxThFHpGUTT1BcDECs=;
	b=8g2XumaqvoDuL90a6ASgURtQytJPge905rrw+FednoqM09uuBJx3JY54w2IMWtjnznRowd
	eKOl9iyst5NFQyDgP0q+x0EkNaACK6CBSlTPw0L+h9CK/n2hjI0EXQal66URxi6ltUcjYx
	HonMw1NWEAvv8cIsLXRfuvDKOOTU4UY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765392445; a=rsa-sha256;
	cv=pass;
	b=riAQm5EXgJk+cnQdte8Su5GLwUM6ePtVatZ9isXU/HKnu41cvt14bNeIa8n4kiYwSWVHkS
	xZY3Bz7YIkABVZO877k2OkQQS9xojnfUhKeC0DBWqYLZU1TxsOxBrlBcbLlN9WjTBUtu52
	L/qe9oXNnARGmH/mpDMAt3FPN8BwOdo=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ce0BJ+WE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765392445; x=1796928445;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J+VO16FcjcpWiImwaOsFJ4eR7hFlTXLXe9sv31urXvo=;
  b=ce0BJ+WE9rvfbf5nw0ZPliLWxE4Xl631blNMCYhC7EkC3dNLYqxOAUnc
   Xnf40nB2xUsZ5W+/PeB4yfuQmYjWy0168dVJC7hYaSDuWhiXAiIo5DilF
   5it0svakWgauGspGNXDR86/kIsE9R1CNIeSWjxrpyRDDPY9ZWfkrwKSht
   E26Ic2zMUYZ9FHmkm8FzmV7tTuqhwV4XUSJBd3T7SAACmba2uTIGXi585
   XZeq2xBBxC04/qFqWCwxp5gEVJJAnOSxhOOiBytH0Qpo9NR2uiNveKo+f
   yzPfjL3r1bdjHc3GDANVndFZG6Mb8dqW2ZGhhsL+mht8PzQ578MOHa9nj
   g==;
X-CSE-ConnectionGUID: suPf1LxEToGPAFzYVqdafg==
X-CSE-MsgGUID: oupWYaTST2+c56hzLiytNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67098781"
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="67098781"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 10:47:22 -0800
X-CSE-ConnectionGUID: r70a5wTLQcm4ln/XrFZwWA==
X-CSE-MsgGUID: boTDLazOQZyReADxJ/+9Ag==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 10:47:21 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 10 Dec 2025 10:47:20 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 10 Dec 2025 10:47:20 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.32) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 10 Dec 2025 10:47:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NATmqe4ZYPCuIi5rYGRSctzL1gszf3n15JlwGfCBWxM9+EsaTHqeP18oUiIrli/1A3ivDOnh+06sNKNozVpHJwAtAz77ealGcC/YdRXSpyKU6HmNlUJHOxLkZOnTUoVG9YEy+YTvvz8G1KX0hDyD48U1g6mzMy5S6t1oPlGhbe+5KqI0WGGvwxYiG/P+AdmBymcWNFvOCbNHueHtvAibCH5cdpr9YF08EwTiIvflQHqFfNLuXMIIpXQREu3O/nT2qFGkdZDtaEeSndKon91JmjIw0ytDb1zRNenNLwB/IES/uiz2Re9w8cuFZSMFJuYehGEU1KCWwWYPLVDbRVkrvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DO1cqc232jK8XsvRRtiHf11JVrxThFHpGUTT1BcDECs=;
 b=jmroJLLLtmZ0aB8g+dxUyGH+7wQ9eSbp1SpHTo6fJrihqn1lsL4qEA9N/Nv0Iq+Xb5CL03vUkAKixPEbmFSna5XbB8sfuZC9HfVV0Xdq7D30pMJ1eZwWv17hXhdjbnhP6gO7qFzm6EssOyQd7KEmAmwxkhGyzzBDSWxw6WF94drZjBrVNXror5jLesa5TUBpLAE3S+0qc/T0CuRHw0P0TWhjLdp6AFahfePIIr4ekKyyV4t5tsuC0kdoib4bG/G2zo8K3y/3F93t9fTZeLBK5HxEWEs2BpM3XgGjB05IUT/JPm50cmF4AG32Ip/WuiEpv/9jZwMGWIj3sjyW4nKItw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by PH3PPF91320C45A.namprd11.prod.outlook.com (2603:10b6:518:1::d38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Wed, 10 Dec
 2025 18:47:16 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 18:47:16 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: Herbert Xu <herbert@gondor.apana.org.au>, SeongJae Park <sj@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "kasong@tencent.com"
	<kasong@tencent.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Topic: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Index: AQHcTWs0Qo3eNl0w/UamTXF2PMbCz7TxL9wAgAAcuzCAAG5HAIAABzqAgACcWYCAEjbfgIAADVuAgADeg0CAEcgegIAAC4yggAAFRoCAAV2IAIAAFZkAgADxCICAAAPuIIAABkmAgAAcNRCAAV0LgIAAK3dw
Date: Wed, 10 Dec 2025 18:47:16 +0000
Message-ID: <SJ2PR11MB8472317EAEE27FE54D71C858C9A0A@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
 <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
 <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <bfkkizyjmfulkzxgf45l7tjsnudtyutnenyngzw7l4tmmugo3k@zr2wg2xqh3uv>
 <SJ2PR11MB8472D347836B6CA3FEB0CDEEC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <yhecgcnt52hnsyf23p576mz2mlnffqrluikwzv6tdn3bnmzumc@thpyltdpxtjq>
In-Reply-To: <yhecgcnt52hnsyf23p576mz2mlnffqrluikwzv6tdn3bnmzumc@thpyltdpxtjq>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|PH3PPF91320C45A:EE_
x-ms-office365-filtering-correlation-id: 356650f1-fb90-4427-609c-08de381c8a6e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|10070799003|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?ZfYjikGcB6rqum2ErYi5LKXW1V2X7Dy7kZyNkDlOb2SasEdah5dwXfMA67Nu?=
 =?us-ascii?Q?knb1kiq+tQ2exmroxRtsr4/HhbpGWdidesTnMsN6LrTm0X3jiBkGCV73DlMV?=
 =?us-ascii?Q?7Nb9VKvn1Q2Yxs4cscbELg2FBJXapSQgRnCbvd+70+huAsJOqdK0i4uDegxR?=
 =?us-ascii?Q?QiTJY7wKd6EwvdWuxB2JmEnw+NvAu5Cg9SA/v7EKzs/HpIxeBeSQ8jver2Lk?=
 =?us-ascii?Q?SvR3gwrifOtiGm8RJ8CNV2w0swhmZknMf3XemxsGRX7TQHSWWJc5hSPFv/CZ?=
 =?us-ascii?Q?n5JE73l73WPV4WdG56toQoiBxTHXOieSt6CNnTg8VP/K6TFQewgKR29XnJOO?=
 =?us-ascii?Q?wfnnswdb5qUzKOqWogXmz+J0SulnA1CLccRAWbQ15rhTrrQyM/85pVV97CAZ?=
 =?us-ascii?Q?X1hFwad4Hxb3Q+Yvbc1MlDBkFNfLRSjoWpaqs/AWe96CMq+O+Y9eYHTG/L8u?=
 =?us-ascii?Q?qbo36T0rNVyxwQ69yT+XlPVRYvqQZ6Th50vrh5MrC5Rl6EaRe2spaVbrkMs+?=
 =?us-ascii?Q?dbgqNpzmRvO7YX6MIYaLAKUYLoIkK4QjYQIfRPc/mvXr0P26pIof2oJ5tIz5?=
 =?us-ascii?Q?IDBlYXLVVlXJUxMMPsucSLmNqDt8eS7Xnrh6TcyLLle7H3q6UhcDkUo6BoGS?=
 =?us-ascii?Q?Z3hTK/z93gH323iG1PlL8QrWSR9LnK5kYn0bw/niycIBFq55JWX9bgS+BGjh?=
 =?us-ascii?Q?JKNUmGNdQLvA4Z4LdItX5UrdsJeXIm5BN5BTVl1kXK2EudPc5Mzi1UNYz7Lk?=
 =?us-ascii?Q?teMeToQJULHW7R1XudgW8t/wozp7MlWwjgKK8y5tnKXP8tGxo/IqBeo+kWZy?=
 =?us-ascii?Q?oWVP3xreSFNbg6z8qCFTjYFzDGAcfxxoX1E47aELcrDwSYdr1VCPaaSpH/6V?=
 =?us-ascii?Q?lAn2dXvZjmJGjdjBBNZ3S9aPZ7hd24Pvmw9SyUx9sYT1UbzoGza6+oauP8ZN?=
 =?us-ascii?Q?Eve+RdTo6mL//FFmis6lfuoGck3AtJ+eT+7jdXxYSD/HfM9P9JWus/cvoHyO?=
 =?us-ascii?Q?uBfZbhi1FfXBbOvWd7ff6SIgjmKy/UKq12viKex27fSBOjQw37l4H6B9MhXy?=
 =?us-ascii?Q?Oj6LT8GLyfSrYjaK+Bcq2mptjqWf1UV0x8XJMxoZesXvMoI0B6fDhwE0JwMh?=
 =?us-ascii?Q?QomNxU5qXEfEyPb4BYlJscdtfulvw9NkxJP15J+M6m4r7rw+HrRGVF0NY1S0?=
 =?us-ascii?Q?6MFkoit6gtSJJpeScAgxmIWGhUcXBAcjVaMwrLJN+7KFmc1ODgLwtRtLSEhS?=
 =?us-ascii?Q?kyITyeejSgaHREEwszW4F8ph//2p4fmatljOHQ8sdAL+7uLlhVg4GdMk8BYj?=
 =?us-ascii?Q?ms2MWBRTj8Mk4D6Vd0yF1i1rVnWN2zCbe+syo3cQdugEHzr3OG9cM2Jb32Nn?=
 =?us-ascii?Q?6njBVhxSforjX0phhDsDCZlx0ZTcx6bUrII5fqjn4vgs1wxwfSeVkxdGmZ9m?=
 =?us-ascii?Q?YOMLpup95xX24S4az+aK3gNrk7yd4LGEQeEv57Zn+aoogogS30hQIg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z8Uri8odFQyxnfmLclMnJo3yY02BqaWAR5yMCf8Z7FxEm7zIjpvWkOXC9D9T?=
 =?us-ascii?Q?BQMDRNCRVb8m8j7CJfdxfU8WB8uNvY7GIlcL0Jx0SLY5f+oOQFQEhaQ8WV0A?=
 =?us-ascii?Q?L3hJ/7hBtwY2cxsLFaypM6Sj518A4T5fLp34/VAlLrtPI5V8LjHGKWaLahk+?=
 =?us-ascii?Q?TsHHudaloaVwQVwDGbFW5ju0WnYNDZSFVYJgFcKnxa/8cSoGTUAWdGTW/srp?=
 =?us-ascii?Q?/LQkY43OfzHLZHFl/qB3RMbZ3andF3ueYI5T8zcsZV+4qJM1m0Gbe28igEzS?=
 =?us-ascii?Q?2WsbtxP6xRY4IpAbMXWeNxXmrnQqMbQHi8qRZhgDR4NuScp0pvemARMiN4x9?=
 =?us-ascii?Q?waplFrC/iQvHRHdjThedN9SS9ytDz2VPGvnRBWp2kML+rkgFpzb1MkzCtwl2?=
 =?us-ascii?Q?HW8u8yWk1vbTMTm2jIYoa868+pd+klWAoWz5anH8A8O+4850GL1JbYtZH42U?=
 =?us-ascii?Q?cmuV2CvN6OI8nmw8eunNU0x9+5drNEvAyMiWcJJC/DYjktqce0P/tvVpg1WN?=
 =?us-ascii?Q?g2my8QulEBX2k+H8Nz4devEgXsqq6EscdEnqan+Nx3NzvS6IF1Hzzca8M6KD?=
 =?us-ascii?Q?ftcyH7vMmvEe42uRlaJb+Pf3IAQVegjJbyPo0xVKoKrBmDrpl7JF6vpO+KE1?=
 =?us-ascii?Q?sjLSHcUAMrP/WB9rzzoMJ+DOlTyfg1c884nDlOkHD7nFjj03CWVH4AntdxIZ?=
 =?us-ascii?Q?tnaGC488e2jxyYyxXSLVgUMwwt9PuXX8gM1LkNQnnQmXh7WttIlsjm7wb6ej?=
 =?us-ascii?Q?9Ac14OMNUE/LuUlIjGihRodbS/Q+Y8G56XmkB9msm6kienb2PY6jAs7iAGrp?=
 =?us-ascii?Q?Q7mQfoKhLl+jqHBp5Y5gFPtnRsm4MGx5XeX6LiWeNS6NLGdUak13BR2ksyr+?=
 =?us-ascii?Q?pD9K0kDn5FWcbxvaIz3qXlzzCpW1W3RmwLd19sdqcLYM3v9SLO7m/WRt5fGH?=
 =?us-ascii?Q?uPfkSgVeDgagzA5OafEX3eGXcsQWgiMoWQRbSEYcbAOtuY44+nWkgqLFMB1j?=
 =?us-ascii?Q?XdA96q50laD9zE3CYlhPtikCKstNWtCa7fJIGPCWwWscs0HOL7yY+vMeb7Fr?=
 =?us-ascii?Q?mkeI8Znsoos2W8i/xWPqkPysZ6sGxTVvYgxpXaMPRl0g4C01kIeSualsLG9k?=
 =?us-ascii?Q?h32FOoK/+ugAO/4xs0G2RFXYaBE22ZW4lD4MEq/HJhdMJW0kZIzeWezIuKr9?=
 =?us-ascii?Q?wMsF1OW9jGgM6EirL2IHkhp29cJOS3Wk1k8XN6yqctfXIfzqzqOOp7NSJbmG?=
 =?us-ascii?Q?4hmgslkuB9I3pzhNpgVRjosSW0Cj6GosWLoJtfKW6WM4wBavWSIM5pB1QWO0?=
 =?us-ascii?Q?JQxiqNzpEiU8DzhNMRIsdYECxSjVa+kYW8wCEkGGyR0rjRL7ONc8XyzxJ3Wd?=
 =?us-ascii?Q?0YlH3VNGcqX6G+w4+AJyYlP7gSMApLDGEObkeBLK+2i076oWe+m7RNMhd60s?=
 =?us-ascii?Q?j+/H9ssEzNmCLMvomSU7EFzvA8nId/cLY53q38COg2cmyiiFMYU1wS4QIfVg?=
 =?us-ascii?Q?MAifoXMQPDlKOBWst4mq9nxqzSKZOF3tj7QXKeg9ntTm02/EZDOJQuRGyt81?=
 =?us-ascii?Q?j5M7AdKXepf5yXDVMXGtKM6xIl9EeGCp7pVihK1Mdj7NSsyyuUOlIk3ns3vg?=
 =?us-ascii?Q?dYiDhDZkUFAIayp511dfSOc5mPjFpGXFC/9EMJZGaYxjg4uW+1SyiHUb1h9O?=
 =?us-ascii?Q?BknZPg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 356650f1-fb90-4427-609c-08de381c8a6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2025 18:47:16.5892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sweAfhmWyOa0ZqA5d2GAxF+3r/2ctbZG7ws/D9uiY6bg7HezThBhYX3yEm7TTQnK9v5YQICW4qJ+IJpwpLhuSyVYCDK+GIED1PVzu0ifgew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF91320C45A
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7AA4DA0017
X-Stat-Signature: 3qsbuwmpn63d75frzfqfwzecr4wh9x6d
X-Rspam-User: 
X-HE-Tag: 1765392444-454678
X-HE-Meta: U2FsdGVkX1+27w321CTsBG+Oo81YSXSj75yP22XA59sxLV2O5ZWa80rBwpL5qx5pJloH/V3bU5NVzSOet7Da5f3BQsJ4XWG4E8kNVMnzAPfNwYC/UBEahTiu5288fxMbYme0uIhAcmzNpuR9CzymPksgVsiKIhw/IXOMyHiq9CYWh9cGGDdnaP4Abgbr6/gS1CMyY3jW28i23VClsJKs3bM4dcfT6f+WAVIn407BoVvHtU/jYLcAFjhxlCrcCnY2ewe9VsnEWjDqtErVoGBVK0LdfP8iBJ3GQP6SLYmonbV0XFpok9rhUWJXYBMUVIY1ZMcbBggqr0wuhqWZamGGdOX2uoeEXa1H0LouTXFc7Rn2+UGKbBYHCM523Fde9HuQSjIcJOc+1nFGO5d8oyZOfZwad7JoFKMCaZX82AwpRteDvGXWqEb+IfyxIsgZjfcSb6x1REyw4wzvw/phNLKruDsOryRow4coMlt77Konr+yEmdgOjBjQrAMacxYddSIsQnOcQCJ6EGOVCt7hlgNoGKkTlnLaekb3R3YXb3dblLZ/GTDGiRnV8/7RjsvyvgaQ54UVAm7d31EEf1mwGnOE9Iq1GsjrYR5FlPM6jOHVqCa0pPLzIJeBhJHMEMlS+NhDCWTn3aIUkMyFrzs/i1INc1CJlwz0pwTn4RY8dt9keJgFI911sl8MdJ6pRlSonMLLZbMXwLueg7EuU+3n+vgEzjsmdHZ/LilGetlmx21Q7YiMNNptCj93ks6UZzWLUJY4gFK+2OzuAS+n9LAoZkLHKhzgjC8H7cm9CIh8x40NdiGObVDTSZhxa3fg1IHSjcwy0JcogRxTwwkoF1+AUvWAw3cfZ8HXttebB8FO7iJFLq20RVJP/qWmqYMRk7dmQ+YhJEw0kjXYdrfunBdlnB2vt/QESFX7AQGZEjHk01AbmCWhlzlTWmBnVPu0Kdk/n/YlIWlbNvIo35SXecGmg2A
 7Z9Op1Oi
 SGDUTPEjfBHI2TLb/+g4v3jyFJy09wVZ+3FtR0bh28khCk7tg7nKckl+WGfyW9uXibJaOQGjdSAgj6XydMz1r5a5UnV81GEqmppSfVQJ5E1FPSkknWLUkUT783Gb6YkBclJdPkyqxEi9BkSe3TrPaiHZ9U9ZrqpMkBzghD+GqT8AHoXkTMk4iuxZfzZpTS7N0bltRIQj5PmE8oLq0TPolzUuZ9b+1WYlU0VDDJIRZZwD019n2N0LrjK6icihFCWVXm+QH46WY60P0TNNwix98Ktk2qAshlAjWq82bY2OgvQbHuGXfxHPkJAsaddQRSP+30IE3pf7gDC8A7ycNCWCXml7xxPd4UW2zENzTiEEuBUlJ5vFHI7hNZmozwL3VI+Mne6b+zXMmRIVIEiF+DHviGhuHUTvrusGuFa5xKy1UdzFM3syPnGr+Dm15EAUhwDTL0UFWZ3zA5eseCPu6/ay4rTfu54aRUAqONYotWri2APiUntrHbsgD+meI0IN8azRoojKIGkC8QsP1QSCSPz0fVy8JiCAMfAIZw0EL7T2L6bQtJ78HV+F/eh7QQTkH2O9kQexGiix1lYpCGsTjh5a6t/fC+tTZ7egR1XuefBRhn6zA90jksGmLPqHxYdO28YdWO0xCq48W0Li4W+dfaEvdbPu5WseLzWku6lOEPcIVhrgGmnG4DU88KPMiBuJHZ+dBpyF7V2PTU2cFq3xmVZlGcgS02YJFBzE/mLJxkSRbifKO+sHr/xeH9WDGE0xg5+Dhuv8fvu0oo18Zth2Lpw5A3z8kXTltaPXZZjsUya70+NrhSVpkTi+EzstYiIYkoD4kqCU8v+zlGDDVVG7Cd7/BKSV5TzTAhg36N1prUCles7PZ120cmarVcAdtjxrIvI0OQ772EuklkmD/QWoJz1+Z63js/xd0zZat/9a3KqyfQJtcLZXd7uUEfE5+4CleBap7VOFQmfQPyctR0LMSmc0P1t93DD9b
 ILsZCMDs
 S0dLF6+ZrXcjoUXeFMh2kOwoL8A8MV6fxFCQspRkGohQq2nm7ZjXVL/oX+vSCZXLvxqRL0FN1ja1XNAHt8rYfcCHxIcItBjMFR8kMStvfAiMZKM/8mBULCUhXQInU6Ab
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Wednesday, December 10, 2025 8:02 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>; SeongJae Park
> <sj@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> compress batching of large folios.
>=20
> On Tue, Dec 09, 2025 at 07:38:20PM +0000, Sridhar, Kanchana P wrote:
> >
> > > -----Original Message-----
> > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Sent: Tuesday, December 9, 2025 9:32 AM
> > > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > > Cc: Herbert Xu <herbert@gondor.apana.org.au>; SeongJae Park
> > > <sj@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > > hannes@cmpxchg.org; nphamcs@gmail.com;
> chengming.zhou@linux.dev;
> > > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > > senozhatsky@chromium.org; kasong@tencent.com; linux-
> > > crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> > > ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> > > Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> > > <vinicius.gomes@intel.com>; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>;
> > > Gopal, Vinodh <vinodh.gopal@intel.com>
> > > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress()
> with
> > > compress batching of large folios.
> > >
> > > On Tue, Dec 09, 2025 at 05:21:06PM +0000, Sridhar, Kanchana P wrote:
> > > >
> > > > > -----Original Message-----
> > > > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > > Sent: Tuesday, December 9, 2025 8:55 AM
> > > > > To: Herbert Xu <herbert@gondor.apana.org.au>
> > > > > Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; SeongJae
> Park
> > > > > <sj@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org=
;
> > > > > hannes@cmpxchg.org; nphamcs@gmail.com;
> > > chengming.zhou@linux.dev;
> > > > > usamaarif642@gmail.com; ryan.roberts@arm.com;
> 21cnbao@gmail.com;
> > > > > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > > > > senozhatsky@chromium.org; kasong@tencent.com; linux-
> > > > > crypto@vger.kernel.org; davem@davemloft.net;
> clabbe@baylibre.com;
> > > > > ardb@kernel.org; ebiggers@google.com; surenb@google.com;
> Accardi,
> > > > > Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> > > > > <vinicius.gomes@intel.com>; Feghali, Wajdi K
> > > <wajdi.k.feghali@intel.com>;
> > > > > Gopal, Vinodh <vinodh.gopal@intel.com>
> > > > > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched
> zswap_compress()
> > > with
> > > > > compress batching of large folios.
> > > > >
> > > > > On Tue, Dec 09, 2025 at 10:32:20AM +0800, Herbert Xu wrote:
> > > > > > On Tue, Dec 09, 2025 at 01:15:02AM +0000, Yosry Ahmed wrote:
> > > > > > >
> > > > > > > Just to clarify, does this mean that zswap can pass a batch o=
f
> (eight)
> > > > > > > pages to the acomp API, and get the results for the batch uni=
formly
> > > > > > > whether or not the underlying compressor supports batching?
> > > > > >
> > > > > > Correct.  In fact I'd like to remove the batch size exposure to=
 zswap
> > > > > > altogether.  zswap should just pass along whatever maximum
> number of
> > > > > > pages that is convenient to itself.
> > > > >
> > > > > I think exposing the batch size is still useful as a hint for zsw=
ap. In
> > > > > the current series, zswap allocates as many per-CPU buffers as th=
e
> > > > > compressor's batch size, so no extra buffers for non-batching
> > > > > compressors (including SW compressors).
> > > > >
> > > > > If we use the same batch size regardless, we'll have to always al=
locate
> > > > > 8 (or N) per-CPU buffers, for little to no benefit on non-batchin=
g
> > > > > compressors.
> > > > >
> > > > > So we still want the batch size on the zswap side, but we want th=
e
> > > > > crypto API to be uniform whether or not the compressor supports
> > > > > batching.
> > > >
> > > > Thanks Yosry, you bring up a good point. I currently have the outer=
 for
> > > > loop in zswap_compress() due to the above constraint. For non-batch=
ing
> > > > compressors, we allocate only one per-CPU buffer. Hence, we need to
> > > > call crypto_acomp_compress() and write the compressed data to the
> > > > zs_poll for each page in the batch. Wouldn't we need to allocate
> > > > 8 per-CPU buffers for non-batching compressors if we want zswap to
> > > > send a batch of 8 pages uniformly to the crypto API, so that
> > > > zswap_compress() can store the 8 pages in zs_pool after the crypto
> > > > API returns?
> > >
> > > Ugh, yes.. I don't think we want to burn 7 extra pages per-CPU for SW
> > > compressors.
> > >
> > > I think the cleanest way to handle this would be to:
> > > - Rename zswap_compress() to __zswap_compress(), and make it handle
> a
> > >   given batch size (which would be 1 or 8).
> > > - Introduce zswap_compress() as a wrapper that breaks down the folio
> > >   into batches and loops over them, passing them to __zswap_compress(=
).
> > > - __zswap_compress() has a single unified path (e.g. for compressed
> > >   length and error handling), regardless of the batch size.
> > >
> > > Can this be done with the current acomp API? I think all we really ne=
ed
> > > is to be able to pass in a batch of size N (which can be 1), and read
> > > the error and compressed length in a single way. This is my main prob=
lem
> > > with the current patch.
> >
> > Once Herbert gives us the crypto_acomp modification for non-batching
> > compressors to set the acomp_req->dst->length to the
> > compressed length/error value, I think the same could be accomplished
> > with the current patch, since I will be able to delete the "errp". IOW,=
 I think
> > a simplification is possible without introducing __zswap_compress(). Th=
e
> > code will look seamless for non-batching and batching compressors, and =
the
> > distinction will be made apparent by the outer for loop that iterates o=
ver
> > the batch based on the pool->compr_batch_size in the current patch.
>=20
> I think moving the outer loop outside to a wrapper could make the
> function digestable without nested loops.

Sure. We would still iterate over the output SG lists in __zswap_compress()=
,
but yes, there wouldn't be nested loops.

>=20
> >
> > Alternately, we could introduce the __zswap_compress() that abstracts
> > one single iteration through the outer for loop: it compresses 1 or 8 p=
ages
> > as a "batch". However, the distinction would still need to be made for
> > non-batching vs. batching compressors in the zswap_compress() wrapper:
> > both for sending the pool->compr_batch_size # of pages to
> > __zswap_compress() and for iterating over the single/multiple dst buffe=
rs
> > to write to zs_pool (the latter could be done within __zswap_compress()=
,
> > but the point remains: we would need to distinguish in one or the other=
).
>=20
> Not sure what you mean by the latter. IIUC, for all compressors
> __zswap_compress() would iterate over the dst buffers and write to
> zs_pool, whether the number of dst buffers is 1 or 8. So there wouldn't
> be any different handling in __zswap_compress(), right?

Yes, this is correct.

>=20
> That's my whole motivation for introducing a wrapper that abstracts away
> the batching size.

Yes, you're right.

>=20
> >
> > It could be argued that keeping the seamless-ness in handling the calls=
 to
> > crypto based on the pool->compr_batch_size and the logical distinctions
> > imposed by this in iterating over the output SG lists/buffers, would be
> > cleaner being self-contained in zswap_compress(). We already have a
> > zswap_store_pages() that processes the folio in batches. Maybe minimizi=
ng
> > the functions that do batch processing could be cleaner?
>=20
> Yeah it's not great that we'll end up with zswap_store_pages() splitting
> the folio into batches of 8, then zswap_compress() further splitting
> them into compression batches -- but we'll have that anyway. Whether
> it's inside zswap_compress() or a wrapper doesn't make things much
> different imo.
>=20
> Also, splitting the folio differently at different levels make semantic
> sense. zswap_store_pages() splits it into batches of 8, because this is
> what zswap handles (mainly to avoid dynamically allocating things like
> entries). zswap_compress() will split it further if the underlying
> compressor prefers that, to avoid allocating many buffer pages. So I
> think it kinda makes sense.

Agreed.

>=20
> In the future, we can revisit the split in zswap_compress() if we have a
> good case for batching compression for SW (e.g. compress every 8 pages
> as a single unit), or if we can optimize the per-CPU buffers somehow.

Yes. Let me see how best the __zswap_compress() API can support this.

Thanks!
Kanchana

>=20
> >
> > In any case, let me know which would be preferable.
> >
> > Thanks,
> > Kanchana
> >
> > >
> > > In the future, if it's beneifical for some SW compressors to batch
> > > compressions, we can look into optimizations for the per-CPU buffers =
to
> > > avoid allocating 8 pages per-CPU (e.g. shared page pool), or make thi=
s
> > > opt-in for certain SW compressors that justify the cost.
> > >
> > > >
> > > > Thanks,
> > > > Kanchana
> > > >
> > > > >
> > > > > >
> > > > > > Cheers,
> > > > > > --
> > > > > > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > > > > > Home Page: http://gondor.apana.org.au/~herbert/
> > > > > > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

