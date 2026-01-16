Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EBE3D4898C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 12:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29D26B0088; Fri, 16 Jan 2026 07:02:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA456B008A; Fri, 16 Jan 2026 07:02:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CECFE6B0092; Fri, 16 Jan 2026 07:02:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF4AF6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:02:52 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EE16160646
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:02:52 +0000 (UTC)
X-FDA: 84337690584.21.5E4832B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf16.hostedemail.com (Postfix) with ESMTP id C0C1518000E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:02:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OJCCJB1N;
	spf=pass (imf16.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768564969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usPasjRE/H5V2+nkLHoYwXlpGP6jy12WA++GuX/bN1c=;
	b=bqMVouRF+e1CLlj65rUOSKLXGUmOEmbd7SQcz7e1odEFj/iKhRkRVL/vh9o5BsHypjDtmC
	1hKQgRge5OjjbXP6A+w1s08zJ/un78FCkJhy+yDByz3lUn8ogyDTFvQiUQA2HR5v2wvDcw
	lOT+03YIdUggy1GDiFSj1Vk0dgYp45c=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OJCCJB1N;
	spf=pass (imf16.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768564969; a=rsa-sha256;
	cv=fail;
	b=Qp6x5U6zMaH22tHRT3nuWqRDvSNOqiJ5dgWpmc7fVi59/ui8SpgOCx9t7B1Elv/ydOWa1O
	0zXHA2RMErrH1BXKMGLpdJjdTGJV/qiL5AH85XkvWx5hNhBNlWZYQ6IBoDM/fvCiRLG1o0
	kgGO88XhBsnWv4BOcl8dMiowp5KoqtM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768564969; x=1800100969;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7L219SglN/PEzlCqEYsKUF6B+kD5zZoHqeYkExHmC/g=;
  b=OJCCJB1Na499Jrbs90ndx0908RFvnMbrhFmWebSR4/loMCA5CBLcDMIf
   R7zBMkCM5RFvSY6vNpjKY/V7N2qYY75PQ6eIqoXF4mcHZcpNghstzhvsM
   /JJgWpDJtIptTFcineNAbsIuzu3VR2aePoPWm27RU14E/Mp5//KZUpxGc
   ShC+ZFqyqNnyQsGeX0tRsVMwlTziQ+573LQAHG0xkmtYoxeD7S4ZVoXuS
   i2W8l7YijPy8PoWfGpm+MwuriuE//jIyWOHY/iEfg7vrZj8LJvnosNylG
   B5YnwGGYXuFWntvDOVeKYYJh9WgsubV1597uwdRFOlS3JSbeLfwu3CQQ8
   g==;
X-CSE-ConnectionGUID: 8Aj54QI/Sw2+gvhi1NazwA==
X-CSE-MsgGUID: uUhJZCf7Sa6M5F25T11lng==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="80521156"
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="80521156"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 04:02:47 -0800
X-CSE-ConnectionGUID: Rm7HLIksSkqu3a0rQ4yOSw==
X-CSE-MsgGUID: /r0/po+uSim0n3MEaFikvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="242772568"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 04:02:47 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 04:02:46 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 04:02:46 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.31)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 04:02:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vhbk9GL3CDq5VPyNdRMKEZTupdWMddI9WNFOf4mnxyQPC/+P754+EUa4jWLNPXoeuYJVahw1MoK379sOQTeuNNLXibP9ffRBRvzsL0NepLRUxmeyjwlY7Uj+FJAzXmW2nirJxA9UGETkSSA6ycG6sVozbX8tW9ouO70doZJuL+DDDGI2z6u7vyn4HgftkaBMkvQvvmpKEuTI8PY08spU7xtfeyqpCjKJH44v1X+lzziUsEFOH5+JOISgNNIZHuHy7QtrHKca717CYnYUERdGe/tW0oZrOa27cOIzt0NqSGR22Ya2CKxHVkCA/QLwUPDAYxWLqQnMg5XjsJ50Itwv+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=usPasjRE/H5V2+nkLHoYwXlpGP6jy12WA++GuX/bN1c=;
 b=Mr/ohyTE8A+YNQmP7KXMPfHIq8mi+qsEB+s6tUV0yJ9UR2dTTaMo8bS82tu4utcjmgrteEGQ2hXuF4XsBn+vrCDzkRLvSUSFXg/ntXDyQjw6SZ0Wk9f5JcgKNfj5cpNr501JofmIZpbyjTNIymn8okt6aMuIRyOWIhf66JSlwnQZ8PHPU7g9/dxIgAADQYpr6SFpTqGLeR9hmcWoEdQYJ80zx0U4ur0p7gqMza94v+zlHPN00mQtyHyNLPT/gXth+ckEyK2mwmKca3cvtbtdbKDMDnEE0Qk8va83EbJFHAotbjHEsO2zPTdqvhLd2+RqGCx7jAxikMwGWpKIrWNxIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY8PR11MB7828.namprd11.prod.outlook.com (2603:10b6:930:78::8)
 by DS0PR11MB7559.namprd11.prod.outlook.com (2603:10b6:8:146::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 12:02:41 +0000
Received: from CY8PR11MB7828.namprd11.prod.outlook.com
 ([fe80::1171:db4d:d6ad:3277]) by CY8PR11MB7828.namprd11.prod.outlook.com
 ([fe80::1171:db4d:d6ad:3277%3]) with mapi id 15.20.9520.006; Fri, 16 Jan 2026
 12:02:41 +0000
Date: Fri, 16 Jan 2026 13:02:31 +0100
From: Francois Dugast <francois.dugast@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	Matthew Brost <matthew.brost@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH v6 4/5] drm/pagemap: Correct cpages calculation for
 migrate_vma_setup
Message-ID: <aWoo16A5-Nj5-iNy@fdugast-desk>
References: <20260116111325.1736137-1-francois.dugast@intel.com>
 <20260116111325.1736137-5-francois.dugast@intel.com>
 <32ad0dee-0604-411b-b99a-b1bfd8ba89ed@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <32ad0dee-0604-411b-b99a-b1bfd8ba89ed@nvidia.com>
Organization: Intel Corporation
X-ClientProxiedBy: DB9PR01CA0011.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::16) To CY8PR11MB7828.namprd11.prod.outlook.com
 (2603:10b6:930:78::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB7828:EE_|DS0PR11MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: 72ad7258-4088-45d0-c693-08de54f726a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9+VyKAJLw8+OaS28TsB/j1pPdDreMnFlqpkQWqOM3BoTcQihzPllf8ZWN2eJ?=
 =?us-ascii?Q?gJ5bq/7/5GAgBO/DC+79PC7OPKhgIxH0zG0SyQyNcOFgEJo86vD5HuKEATP2?=
 =?us-ascii?Q?3WE2ME3LeEzZqNX0bpLSeAz4N9ulXRAjOT+vm4o+BR+IzZp8AFKTmnvCkcvO?=
 =?us-ascii?Q?Nwx3YjsRh9aVxcaxc+qjP6AOoozMDkfe9ZQlfWlj2dkiuziAK3635Vz2lB33?=
 =?us-ascii?Q?ejyPMqzsnrhZczx/F/otW/KG72tc0FR4ZUxpNYbW/xcp2UJ/xQ1nxbv/dmta?=
 =?us-ascii?Q?falCAjMHDN9ZDBsASlOcODlVD8adeiN/EjPtAUz7X5v31kNhsaPQXxZR9pK3?=
 =?us-ascii?Q?9b/uVwUyTQTL2hn3KMfhLlDYJUU+gQLLwGnf/1V0l7qQ+TXBSdlH82PXUwLd?=
 =?us-ascii?Q?br2jSSRfs6uu1IKj56yuhnpOhI3gSeybnnemjZSnwpYZPzIncWRuBJ820X+U?=
 =?us-ascii?Q?ylxHQcrpoXv3EJNldrs5/Krz5sx6BjIrbDAIBaMeHmyGTptMAvz42WPX1M3y?=
 =?us-ascii?Q?4UVW3rI9L+dUmdDdVSmUbMinIpigzzzHhmA4yxwcbQN4VUtQg9bmqrOTSh2d?=
 =?us-ascii?Q?a3xCjc2mSCxrc05qN28eWmYtvi42yHSRayUFNqg/HHq3+YhJNX2O3Char/gb?=
 =?us-ascii?Q?tl2pUlfXx//kEEO6uni9w+BtTtAlwjN/vh+SuiVIqvUP9s8/Oib5hRf2d+j5?=
 =?us-ascii?Q?suKDaQ2KD39B58KI8YF3ZFuG+/vrtlrtYe9us+a10TFKFRoEjiJ5C3fzC1Az?=
 =?us-ascii?Q?/TePoMzugovpiPNYf3QhOAqARwUKKTJqJR18R8fNEC1SK7WJYzKwU9jEBykx?=
 =?us-ascii?Q?nUlSr1zS17JDM1t9Aq7UhBWg6O1fZ6t14IHp1Aq2lwdd0Z4MMnovSheR7bO/?=
 =?us-ascii?Q?1Y8XILNHerKwsM0x9pKFK7n181famWGv7Pkl/AMQnJQRKeeInM7+S96Lrktz?=
 =?us-ascii?Q?oS0t7q8ZiYLhnN6fDqyVMbpNRsDxXoBtz9O5gTfGXWaFXYrbdoGuSXznerPb?=
 =?us-ascii?Q?/6AultKn7o+Ctq1KJlowYIDnsHtdmzkPa8lHjJ6JV/Yn07v6k6ixmZSqnBmM?=
 =?us-ascii?Q?4asTpEIk77M3xdXU6KPLJFwUBzWDGYYm228UBt5xW79vEH1C2TZDSWCd1Ub+?=
 =?us-ascii?Q?jiqkG6ljj+7dfnlwmTcnxY3WBTZA1P8jy1AztKDd2xMdwBZ+201GcPUTRmyP?=
 =?us-ascii?Q?Tb+69iz46MXgQKY76r+zcImbUAKkj/wuhZII04SvoUWdBVHEYgeR3E/ohffq?=
 =?us-ascii?Q?MV+t9eVI8k2F/XSlqFjS5rur1oR7zOjm2a1o/Y4mgJN22xL1TbzCeeQ4qtEw?=
 =?us-ascii?Q?UmWPdqejn6Z0B0nXORbgNwyGlLw/EN7FFhw4xKp1nMo614j1NjRTR12TpI8r?=
 =?us-ascii?Q?JUeGZz+aLL6+010KTGZteoFWRGNpf9+mhwNh59B/NEMXKeymKugMzgFVKcaR?=
 =?us-ascii?Q?2DX3jRjFYRyFix5aHCXL2kbX8S5JJiRPUJwIwqQVf7RbaqwPAFHfFIc8j6SJ?=
 =?us-ascii?Q?uO6RfnTY1AFpcd5J8A7h+zIlUtDQ8W7Os6JVpGuTP0irsQPxglbdo81zi5io?=
 =?us-ascii?Q?uxOVFanu1oh8/ywDm3o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7828.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ykHJ6p68EvOdAxlgM0csfbyyCPIJTLja14I37A1vCU+AD3LGUU148Sejyu2q?=
 =?us-ascii?Q?Qghvk/W3tNsrzHPGgDLoq1d68xW70o8aF3z9Tgg/lxuX3RkSvq9SuUjj/PGX?=
 =?us-ascii?Q?gXuMZkvbAInmn7Go+fyRjsHKAqA3LZkKd2mWXeR94MxE9TVsVShywVR6uCu+?=
 =?us-ascii?Q?lMHc+frYL3DHjRUiWlEjkv/b/dtCmCkajjJ7/6S+zCXmytRs2TSeSc13iOhi?=
 =?us-ascii?Q?RmNCV1xHUF2sQU2xbf5Dpyoqb8257XRmp5i/w/MFzsZxLjqhhn2bAGzYzfOo?=
 =?us-ascii?Q?Xk0xOU4Ii7Z3X4MuIJZ4oCuKrRwMFY8B0kexi/3ORCW+4CDHThN2SNMuuzxY?=
 =?us-ascii?Q?9RG9roXztkywsf+R+Q5tYlSgyN2sMhymEcoByQYeaWQf0KDPsGV7pEpS2DcE?=
 =?us-ascii?Q?8CJL7uCiGpexJRUpS/0AfIYWSCfEP+qxV6bi8VWJ5DilmfhdxCizISjTgoHp?=
 =?us-ascii?Q?fxDaBn+2FYJe3pBkO3v4ytvXzqC6zm43upvjnNDMemwd3d8sqjgm2L2veAk7?=
 =?us-ascii?Q?nDj6IYzq+2Pjem8iNh5ykDu7OnhtSktonO3FKJ0TMBLsZwS40aK75qyrDVtc?=
 =?us-ascii?Q?WqJsBfKhQUWd2ejxoUmrwQ1x+Og8gA5cxmBjIo2nvRhB5bDVzCKajwF6cfNy?=
 =?us-ascii?Q?ZZ4RnK5C31kUX9/ZJpaRSJLrwaFnwqoqijxhKorKJ0crtUsr8qnQmbZOBD1F?=
 =?us-ascii?Q?3mzPLJfutVYqIZunwUS58KKHdR+ZP8xV+nxdkJPrKTUWPMFpxw8xU9pOqOyw?=
 =?us-ascii?Q?riPvBB/020ThXEB33WWLn8y1PebKE7vpaJvDcQhepY/F0cpHUk6kvlHcGx02?=
 =?us-ascii?Q?pwM67kAA5HnRy9PDklu0xYmEZ2w/MrszCVGCHt/kSVmAgwQThrzk3AAr7EUp?=
 =?us-ascii?Q?dccXiJ77Sx1LEyVqS64CPMspWymkUYebf9widxfi5fk9ENZYCP2pfm29kgrk?=
 =?us-ascii?Q?N9olrbdijAiGU7Ez0TBa1egV2ddwgfh0zBzv5qvRvsfmqso7qmidQMkvedqZ?=
 =?us-ascii?Q?bYvE2vNj8Rno1nAi2Yy2/Me+/nP/cYsFU204UGIAduZ3iaImDqrvXfDTmMhJ?=
 =?us-ascii?Q?3WMFELLVp75iGLCYMSJuO1DBD/UKynALfaoICsP/lTBB1Q4twCvoHjfLRvQC?=
 =?us-ascii?Q?vcn+I0bHPJu6xsJMUrnFcWrqUvN9wQMLni/gTXTOd7+PVMxwrEIe6g0A5JAr?=
 =?us-ascii?Q?MXNJCIDXjMP2dttRG5iGfMF36yE3SX7E2bIWlcm6g6sw6r+ndwL8mRIabhng?=
 =?us-ascii?Q?8x8yLisBf8sLLucX/TwdlesFWCFMPcR4+FW+HG/9v0YYGUAIn/6DGSKbjZca?=
 =?us-ascii?Q?vOpgjMzWyouQsJ3yti0qRKxRr9l7mZ9xzU0x5DpoQN3SjkglrDkTfUZi9g6c?=
 =?us-ascii?Q?CuBfpoZBiq3Ubai412Jb6DKYqCq+j5j+h4VQ7J6kWRGRjcv2oOWNHBaMQefT?=
 =?us-ascii?Q?Hf2YyqS8U6YtV1OxiVWrCE8ww76TvBsgOp+kZ6m9bd2i0dT4CNyLsmgHWVAZ?=
 =?us-ascii?Q?kT97Ycr0y8vD8j0uH7XccV/62Umf1qA7ViecDekHJ67KsgW6NIbvYwObpR70?=
 =?us-ascii?Q?H/YUF/de1LgCfqV3/63KidjgQ7gosZT+MCzVfxzFxTc/dBFPkIh8kdQ6gfby?=
 =?us-ascii?Q?p/KW9fa4JQ4Vd1+Ysi1d2b5kh1gfOw3WnzL3UBh+ooBbqJJM7UiXkoxJYSt9?=
 =?us-ascii?Q?9ircP3k6t5FmKxMq+yS2VSR6D9/x3W8OhODbxb5U/Y9JaekVYwWeFylJ5Ycf?=
 =?us-ascii?Q?z3wAANtzH4ylCbLn3lnb3pXWJA4SqPg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ad7258-4088-45d0-c693-08de54f726a1
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7828.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 12:02:41.6209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q4Rb3XORGh1DKxczprzacpR6AmMfhCprAD99iZ2CLhGYlsq1ON8/6+7hEQZee9Htn2OuJP7ldYeJx/aJfhOZQ9/Qa3WVEzNSOQZ02T5XCc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7559
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C0C1518000E
X-Stat-Signature: 85asq7qiyjoqig1sfdxnq6xk45bxewzz
X-HE-Tag: 1768564968-432807
X-HE-Meta: U2FsdGVkX1/BQLz6G51OB8FIF/wbiTwNg4FfbfJLnZqGazuG7AQPIGNprQsT04slGlYB6tqn4ZyzGSSP9wO33VhXyWhmsSQKijX5fRqn51xf+g53nRMy5J5XKYMWWkGS4iRLtAE/7beoh9OZFRoY/486x7f3d+TdqNlleEEdYziZHBDQSks8HgZf9jMJcu0D1P3LmZmSA9xVl9NHslU2/9ZpJCKKWBin0hA2p/Mi6JkxBCZ10AfLbsg+VCWShpfbEZmYBCujdf+7nqvV0uH5rjnjPBzFHtpQ7pWL4Z2Jpynn4DgrJEuvO+kPls26g2ztYS/gJw+QpQDpF75ZyR/+GOtLXQqr/8oGZwU9bP5oZ1PxaATd+Jq18QDWEcfkI53kMe1+QgtMohhJeIZM9L9YN6r/q5kglGqsiLxID5/mxjKZyxb2ouJFKIatrsEYgkWXRq4hp7uhr74ovUPI4FspEpA2nHyOmJKLCIVynIKxEmCdxECWwFxMMSdaoojT3uGA3E+WRTbo3aAUswXz6mxpBc1OUwcwN+Sbmo52ln/HtmTHfPQCdY1mNdtKnljf30DlxVAT+MLNRPowVcuA8XE0RGUZZi89U0wHihEZLGR2sdcWyDJ8t2DKM1dK7mVwyrMDNaeGfaC4p1A3tdcwGh7dXSRQ3Yeet6ejR+gMlCPIPgnbKQAERgw7KdIIxvMyeOX/qqn97sHYVIKC0NIi8s8OV2sCYZoPq0OHxaSX+B7/6z+OYSI3n8hUEoXefaoRvgfIcmuPwO/7TuDNOuGrhVjQbIxLyPMNyWr3HdHviWM5zEl/3B39/w9us2tv3Tzo20H9Y7xDPQ6bLjsE3uXsWXjYKhDdMqk3UW7zgO4Eo0cggWnHKhjhzADjk7xPVW1vGZjlhHIUgUzFvDE0V2XCkDdpHI2HjkQprb0aYZZ9m5aE2uB8pU3Al/q2BM3H2X8nOL2VWGdAtQpEbKzMni6pTiH
 X94fZ8fA
 5UdunTwaBTSsnCKcCLS0mGNNESju7cYr+ZT0pz0ZhisGJkvoJh9VHGYKzxl7SzX8k/JhAl/TGWOskVWpnw9cb1YDei53cxjGwYdZBDbJdB+WUqsiHxddeJnDlUlmNw5mtkiBvrDcqWmj4lj6xETmJmwpEytPZ99fQx/OewEuz4byaWWeI+7eahz3hL1PBwAb4AeqV7SsMkoJE4sPHebYbVpfk1CaAyj3he/fo3uq/NUzP+1noWBe46WgPJ84VlonJIfBui/vU83Aq8S9GX3mdXGBB7dTnuWAmOfsW1/KtDa20DEmncg+M+wPYb1tB4EJRfqD+OMCTao0f7z3b0KbICTAYip5Y3kM+Bb/itdROYLiVjv40fge8YNjud1hKHGlX6q3Wz+Jrglrc0sLHc7VwHSkWjYzpR5FLZfNqvA8flnMzQ4PnUI3oLecq0w/pgE3ffrrbPJK/KzdAwevrWnycPybAoBq9gBkkZ9xiF9kxu2S9J+ytHyiMbrVq6HXNh4SAp4N2OiQFT9OaaunZLZRD0ZvZ8E882Uyy7U0rkzKujPKEowTj611uJIsp30biXcK+9EtAk+I2etjEjvvGzDtKx9aWbvR/YmhK9zEmrPFhQkpUQDqV9sFP/oEIYcoVB9gofF/0CfiAEw8oJMkiJheHYVjR+Gz75LxPr7azTk+LsbZIrHPa0KbO2Gn2Y1ppv9OsMSMu5izsHsaIK56D0o3101ZVVXN8syn0GvO6HqgV2wh/7HUrdTph4ePUjYVTGTTx4y/oz+uyk6wRqUqcgqrLFtCmlVT+vqwe7bsj2g+PMC+NhrFLW2k03ollfGXyj6ye504b92sGsl7r36J+TDibXBeS5AQhcCmCciLx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 10:37:15PM +1100, Balbir Singh wrote:
> On 1/16/26 22:10, Francois Dugast wrote:
> > From: Matthew Brost <matthew.brost@intel.com>
> > 
> > cpages returned from migrate_vma_setup represents the total number of
> > individual pages found, not the number of 4K pages. The math in
> > drm_pagemap_migrate_to_devmem for npages is based on the number of 4K
> > pages, so cpages != npages can fail even if the entire memory range is
> > found in migrate_vma_setup (e.g., when a single 2M page is found).
> > Add drm_pagemap_cpages, which converts cpages to the number of 4K pages
> > found.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Cc: Alistair Popple <apopple@nvidia.com>
> > Cc: Balbir Singh <balbirs@nvidia.com>
> > Cc: linux-mm@kvack.org
> > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > Reviewed-by: Francois Dugast <francois.dugast@intel.com>
> > Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> > ---
> >  drivers/gpu/drm/drm_pagemap.c | 38 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 37 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
> > index 61c6ca59df81..801da343f0a6 100644
> > --- a/drivers/gpu/drm/drm_pagemap.c
> > +++ b/drivers/gpu/drm/drm_pagemap.c
> > @@ -452,6 +452,41 @@ static int drm_pagemap_migrate_range(struct drm_pagemap_devmem *devmem,
> >  	return ret;
> >  }
> >  
> > +/**
> > + * drm_pagemap_cpages() - Count collected pages
> > + * @migrate_pfn: Array of migrate_pfn entries to account
> > + * @npages: Number of entries in @migrate_pfn
> > + *
> > + * Compute the total number of minimum-sized pages represented by the
> > + * collected entries in @migrate_pfn. The total is derived from the
> > + * order encoded in each entry.
> > + *
> > + * Return: Total number of minimum-sized pages.
> > + */
> > +static int drm_pagemap_cpages(unsigned long *migrate_pfn, unsigned long npages)
> > +{
> > +	unsigned long i, cpages = 0;
> > +
> > +	for (i = 0; i < npages;) {
> > +		struct page *page = migrate_pfn_to_page(migrate_pfn[i]);
> > +		struct folio *folio;
> > +		unsigned int order = 0;
> > +
> > +		if (page) {
> > +			folio = page_folio(page);
> > +			order = folio_order(folio);
> > +			cpages += NR_PAGES(order);
> > +		} else if (migrate_pfn[i] & MIGRATE_PFN_COMPOUND) {
> > +			order = HPAGE_PMD_ORDER;
> > +			cpages += NR_PAGES(order);
> > +		}
> > +
> > +		i += NR_PAGES(order);
> > +	}
> > +
> > +	return cpages;
> > +}
> > +
> >  /**
> >   * drm_pagemap_migrate_to_devmem() - Migrate a struct mm_struct range to device memory
> >   * @devmem_allocation: The device memory allocation to migrate to.
> > @@ -564,7 +599,8 @@ int drm_pagemap_migrate_to_devmem(struct drm_pagemap_devmem *devmem_allocation,
> >  		goto err_free;
> >  	}
> >  
> > -	if (migrate.cpages != npages) {
> > +	if (migrate.cpages != npages &&
> > +	    drm_pagemap_cpages(migrate.src, npages) != npages) {
> >  		/*
> >  		 * Some pages to migrate. But we want to migrate all or
> >  		 * nothing. Raced or unknown device pages.
> 
> I thought I did for the previous revision, but

You did for patch #2, it was kept in this revision.

> 
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>

Thanks Balbir!

Francois

