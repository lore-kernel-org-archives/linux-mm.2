Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B590CEBF61
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 14:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 608058E0014; Mon, 17 Nov 2025 09:38:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DF3C8E0002; Mon, 17 Nov 2025 09:38:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7058E0014; Mon, 17 Nov 2025 09:38:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3602D8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:38:29 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B773F1DF2AD
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:38:28 +0000 (UTC)
X-FDA: 84120354696.23.3D07A7E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf16.hostedemail.com (Postfix) with ESMTP id 23682180014
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:38:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NNX+HxuD;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763390305; a=rsa-sha256;
	cv=fail;
	b=3vX//JX5049DhG0F2hZ16BLnvnKoujn/Lm4M6G2LiELNRcf0ZFaYLqAMFNb9vdtCK7NbEI
	7TZRoGp7beptoj7wBHlgRbm66v5NrOcrQI7NtOVsK+Skodk9Zl1T4RfbKHBeL66cibXHIx
	nE+AazSNxEW7a0YxN3HzrcjjI7nCESA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NNX+HxuD;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763390305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=p97rilJ19Y1KJdbgzbLAiINr5kdAKD68a2behWFopI4=;
	b=LUKaWvQnrVBsEHePia4aZ4gymFnRertGvbEh2XjyAyQ0KlC8iVLaKcfGmLAxJ84erjU4tg
	KVfV3INXwy27A1UXnemhCXtkrDAhejYxGfmJT3QcG6DKTGH5I+iYQT9iPvzB7S3HMNeGbu
	ls3G/AyfQw4718ONksuie80pYjd3+NI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763390306; x=1794926306;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=jYraZFjI8Lt8FOEmHwkhF+itIAHfyZ1mIGo+2oQadbY=;
  b=NNX+HxuDhyqK0GvdLVyg6OkZ9KYeSrygF01S5tzee0yoc1PjD80xOOdo
   FrdnK7TBg10p7jxbXUHtsCkYvTuwz9koEswnO10Hfi0N98hRsrByFJro6
   ZztlgkqIRzmz7Xp+l/DXmxMczE3za8OGcfp1WDe+QEoJ3jzH34vuydkUM
   tsRepAi+lbfj75PL1rsSYdBTcR42UzQ0kqxk5K9HdEbDTSHHZ8jZeg8Pw
   AIp4Byta4BfKuNYt0VRyTm47CS5yw9+OfMTars5tr4MXjzKEtV1hFilX2
   Izf/mfv/VJTE4QO0NJiKkgpyFrDcSJFQ+qM1OKFezlByfLUNqaa5E04WO
   Q==;
X-CSE-ConnectionGUID: DXgFeuwuTrOUz+0IJ4RH/A==
X-CSE-MsgGUID: cN8D4ST2SdKsK2oNFCfsDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65325421"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="65325421"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 06:38:24 -0800
X-CSE-ConnectionGUID: dFt7LZzpSHeDK8npD0MQ6A==
X-CSE-MsgGUID: sB+/1O3JT9mvBRmoUJheYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="227798473"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 06:38:22 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 06:38:22 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 06:38:22 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.68) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 06:38:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xYMo+fjkuLGMati58rRxIxD6yptm7h5hH5ppEy+EWUnv2NDfaqcp+82s8hL7Q/Sp2r0bxSoQPJSOi2I6/LgtzOKy8qBOCLpXBvoNLhHoI8o9Xve09MEC14evw+mZeW+G+REOlJvNvnDS4STcoR3BtSc4igzfQOgcOGtrjpKIkBRHCymGn1YCky5EmryixBU0FdtcITP66ZUReHp0dfRwFNhzcMETaUcK3S/tVIHIM27mHkhL2TSQjJbTHD2AKcjJr/HyzcMe2X3rJVW0EsP0sPPmejsM+2e0sP+mH3YVgJF+AwHcdv/N1UcHgCAl3/wF/To/jpatka1/0RMRwl5ktg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p97rilJ19Y1KJdbgzbLAiINr5kdAKD68a2behWFopI4=;
 b=TzNa84iQ8t932hZqtvau4t3xswWXPqhYkYZaswKKsr2evAW6z+IcFdE2tWnSrM8srb0vhysAPWcLW5cB9pJSBWmtzFMY/+Ec3PYqVqXMsVePYL1cqEtz4ztHM27iIBTxxjd8cM2ysV0DAVpM7AHSLyI6hCyD608o+pKeuCsU0OYqLPNgB7eqpTK8mQMlw6byXMgCVVrfN2y5/dzG8Ke5ZbvUc+blrI0ir3qxhHMWN5WyvtJqN3yE5Us5FAiB8m+pOGZt8n2OmKZvsRFSkLmgFTPIh/bXlpsGwqxh2+de5Hae8IHyOLfRQIIpGsk6+OIZYWsW93tIAYm5xxUkab42oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SA2PR11MB5148.namprd11.prod.outlook.com (2603:10b6:806:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.20; Mon, 17 Nov
 2025 14:38:19 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 14:38:19 +0000
Date: Mon, 17 Nov 2025 22:38:09 +0800
From: kernel test robot <oliver.sang@intel.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Matthew Wilcox (Oracle)"
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Vishal Moola
	<vishal.moola@gmail.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH 1/4] mm: Use frozen pages for page tables
Message-ID: <202511172257.ffd96dab-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251113140448.1814860-2-willy@infradead.org>
X-ClientProxiedBy: SG3P274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::17)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SA2PR11MB5148:EE_
X-MS-Office365-Filtering-Correlation-Id: 81204e2f-4c76-46a3-1a30-08de25e6f392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dHq3ZNYz9veDZqTbSaXtJ8l5qZ4KUreU3uIzXLeDrOrSNl1Y6kitpg1SJ6nO?=
 =?us-ascii?Q?L7jMYkVbYQWFFR/E/kSdVTt7R9Qyyv0CBcXdOxwkUhWOc3bh/Uf7k4nZ5/Hv?=
 =?us-ascii?Q?3ZHoKR7r0TsBiG5VrbjYP5MHDJT35MZ2E71lceRNvBs9Kau5/p0HZCNMydIT?=
 =?us-ascii?Q?BlZpAhaZUCLy+FeOrNDvX8H1g03PNvwMUkGu5nl5uwqxNBBx+dbHJX4aSdDQ?=
 =?us-ascii?Q?T6pWe9eJz8GFxJimjX01WOaQ1iBY5klCV5voYH/+0jdsfkkz2K4RGI0lY3J6?=
 =?us-ascii?Q?MQluUBpUEo4wKJm/THLdG+ixbl9v6/t2ZcQMCWQ+7K7oS6h3ueXwi/p27fB8?=
 =?us-ascii?Q?s7N9DcMMumv3JvBBNCImS2DVyH/tLCxut75OP6PtVvokdtrB12JKr63DfKz6?=
 =?us-ascii?Q?YpZtQI6jED5LnaGs8VWSw8Mg1uiBJ9jARRLw2kxPxxGh8KQ+T8EpFdYKZoru?=
 =?us-ascii?Q?xH6KkW5ZAkunhReO/q2xsropEU2XjTLgT9z/zmNqEk+bq490ctP2kvqhPQr8?=
 =?us-ascii?Q?7rOV4eN4zQbxEpGqrtgMzGdrtWXuAoxcoYiezaXyjyPAib0gNbPShU52/Q6N?=
 =?us-ascii?Q?PfAe2b2XoycH23W44Z8lL8FsnyG9Vz+AXTUsc3us0ReBPm66U5o2UhWF32eN?=
 =?us-ascii?Q?SwwrNvXQAwJSqmiwOHsZIWykLxzz7lR2ZiCjUdF5R1naZyB9JmgRdLYzp1FQ?=
 =?us-ascii?Q?QaCXalDI6LHcRkneT9JVSDCyAwQeFKEi7AKPZWGEizCNFgxGRB2jJKOdAJev?=
 =?us-ascii?Q?GsYCvm4OVcGfQv0J/1SPYcPFyEaJuMacTgOCKRIHHG0WWifcQc8zE54zZrpT?=
 =?us-ascii?Q?xQRL7sCzvL6SuRRNhoD2JL96lGueFsBstwf515yM0NtNyttDteBYck+4YHTb?=
 =?us-ascii?Q?FUaSRxa2A234OBni8dXCiAg4ksTp1v8f9wdgeXGkJ98wXIsAhCxdAUCj0qX4?=
 =?us-ascii?Q?X4QEyBSps8HLIv43j15+yMmhTAc60604qvVkVjWYQgh3ItjrunPHyvKWmTki?=
 =?us-ascii?Q?w8obxuu3GWbNlfbkaSqtjAEqtyekr6tcXhlu2ZnGKSyi0I7LWj8yd93nWuia?=
 =?us-ascii?Q?pe/5EhC8v7nKIIC3EuOC/479VleIPsdE/hGsyjX2HbihlZ+XtaJPs4CJcYSU?=
 =?us-ascii?Q?8gq0P/w1zClJqZ9to/ZxpzPRQQbSuBYjdjlsLmXQiT7/qDo5/g0HjCAiaPSD?=
 =?us-ascii?Q?h2anJYSvHAje1zpDmpolJGEsi97Q7Ijg8nwXamcgkpTnCVNEqCXP70YuYVMi?=
 =?us-ascii?Q?tZce9lGvbiwU8elEPfWQ3KMyj11bHZ2eNEe6GdN4XrgpI16iqkv6M2YX2+2U?=
 =?us-ascii?Q?7V73myvKxxIHZ3gaYuXfMITmiNX2zkf+V0FsKbHV8cdClz0dBcMzXtjHmyqI?=
 =?us-ascii?Q?zaTARg38zwCMo1qGOXQOkpk1YSlMxfggMNJMclIxVt2jIuswcNHrP2HxqHU1?=
 =?us-ascii?Q?l4NDUyV1SXrBueN+asgBvDLu3qT78m9EThoeOtiTTrS0rK7/qEh5hQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c7/gsdi8f7HNZgGzJtApufhc8DfyTl6PZmEGmFM3OSWC3sygvQH/gBELUkyI?=
 =?us-ascii?Q?L/7/BVUQ4fB8oMxyU3ygkHvgTiOpOKBDMIdXzGibRoGLtB4jAGf090uKje4S?=
 =?us-ascii?Q?H1J9i/MwpTqcW06cQpAwC202UsXNaydd1KuFydkVyBSSjySiTUya9is2MrZ+?=
 =?us-ascii?Q?+ZkJxolMyDHdaveQUUdj/OM998TTC96yZgjOizA1CGSe6K1YqV9ROA+lfxK9?=
 =?us-ascii?Q?HIOvFNAsuTe98XdhRMAB1zS+JMRIDPF+nR0HliXVhRfu7ZMAxTozNRk1HIpQ?=
 =?us-ascii?Q?flrz1LnOV35NAR1QEYHGaDubfehPaRLFhERMCLRMpE5iCF7yKidtQyjpXKvA?=
 =?us-ascii?Q?/IqnCEcp3xKebQpdHoViu+PxogVYNyg+aj+FpQ2sPBQCpo29TH5ZH5hKGdRF?=
 =?us-ascii?Q?KAVHS6hpH2Oh1Z7p6bZ1FYwvxlnmssy1g1cmRhJcTgJMYwhoThfPHHt7X28v?=
 =?us-ascii?Q?9Q7hF7KSi5R78zLuLzB2QxkJKWrxYXuxIXGJkMF0bHTKDSfsNaofphI8llE+?=
 =?us-ascii?Q?G0cemUhrdJoJcLoLAPoTizUVyAcks7HChruLzQFkXfVDTDZorU50stfzRdkH?=
 =?us-ascii?Q?nJAeCVbBeMdYyMj0psBOnIgg358nuXK0axlvU2djeUJXyKArNoAN+ih9UtK6?=
 =?us-ascii?Q?B5CrFBcdmPpvH7FQZhQsvGDRJuEJtcEK9Zvm5lOCRKQx3ztMfxq9L/vW30Yr?=
 =?us-ascii?Q?9NA56hcUb9tiRWs83WAUP1brGZ7n3WTuOQzaCN8AdEiDKBH2LHJRafjkOWrW?=
 =?us-ascii?Q?Z3Tnh8Li84mPddTpzqo6i6VCiEWmL8Vn5DpUXdoTBSfITZ6cFJWklTW+pQAN?=
 =?us-ascii?Q?rQDVxVCgUpY5vAWOQXbfpD1aYHxkyzedn4KAXCzblR9kAlnaS5VUBjUZFW6p?=
 =?us-ascii?Q?Hyr8au40gW9AcOAWPjvkg6YDWp8XcxOn2hD9CTkuSZcarFIHDjLlV5T3qIFp?=
 =?us-ascii?Q?0s3w9zqEwyiPTb8+vY9OBUp28LjEHyOYBag33r0Wfu4HycVA/dt5Ts/Gm9IB?=
 =?us-ascii?Q?z9zXC2HnFXvMth+GBnqObjp2dPa0MHcH9oukgjIblaDbBi9vMaEY3kKYU7/E?=
 =?us-ascii?Q?vAwp9GClt1MJRy/YMzPM2FWFNAPqeHTPohL43vHII9QPw2tYQUwYcS8HOF3b?=
 =?us-ascii?Q?PO0HGYJe8geLmNEwpiTVrtbgaM5iXHiMR1bSXCyxxf7+AbKBycxe5Z3tNIfR?=
 =?us-ascii?Q?XWGq8QS6C31Ee9yM0/W5ITe9/7eQddeEQszHVt6fGgt8/hjp9MrQO0Itf/pk?=
 =?us-ascii?Q?+9InmrhtRh2zL44DslQ0FzYyXSZeXgcvFTy2M5nbQA6zektSN6lZ/+eQlrUE?=
 =?us-ascii?Q?jH9v686HLKE7BIQhIMlGCyn8JV5cwnn/MMeAaies2VBCa2vr6vw1vwWxVEjS?=
 =?us-ascii?Q?Hl02P39pQcxA5z0WHC1e0f3cprVktmuhWzlnEY2yrEwK4xkfnBOVJMuTeLZN?=
 =?us-ascii?Q?+nldOO+zowYcwlSWDyMHuKv7Hgn1HM6NX3PJTDx9Auaufqed9BqnzmqRliY5?=
 =?us-ascii?Q?/ZibgeHTfdtco5M+KeRMH+hJRcI3HJLV3xTPiQLleJ9JarlsnwxW0kd5oBHy?=
 =?us-ascii?Q?QuM8rvTQoEZDEMlwJO3zmxn7XT8IPGykfP4IEPRTDl3vwkzeRRvLDnz2X0Hj?=
 =?us-ascii?Q?PQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81204e2f-4c76-46a3-1a30-08de25e6f392
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 14:38:19.4478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pad3QTrUGDA/SbqbzrPUaPMCT0PsMrp85BPBSl5y5HJhSuV03q1lhkyEbnfwRbJFZp+EqL834NO1vzJwrQRpUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5148
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 23682180014
X-Stat-Signature: c7p5tnyd7wj9i8odk4mtsjsk5qc3x9me
X-Rspam-User: 
X-HE-Tag: 1763390304-258805
X-HE-Meta: U2FsdGVkX18Af2q6qwH249n+tMCO+2Jj1L1+aGAgHNsUIQLf0lgvvlcxuj0lF6G2/AHLh5pwgPKKWEfvYtLSOYJNlgd1Sq10bX4xMWBVnmYhBXm0P+7LwCpgC2VEfLenT326tMzigxme49XKkmwMrWlgdt0W4w+9BL8hwtHHcXpTqBFOCPf4jS5B7V6aFp8QSDxFnW1MRT5KQOCL/hKsuF1QdKp43sFocEdXPmf0nFhDqX15g9YiSECbuR9dbIr24P8ycKkbffuMabHm8iQUbYae9Tbkc22f8BT+35RwdOfY+MHZJrJslPCMRdtD9Fwqd/JdKJd7tK8cJHMS+74lfuzwz0sBzNIDCe8rkpMtQrBIuFOC76nzZZaHU9oqe/HDnf8ZuaPt+AZJYbBhmHHB8XKpDkz2YBors+LlJhx8jktxcVp1zXFAb5V5+2rS/VUQB2j312ZSZlMV6NtmrMIdauVJ3U6q6bExLw8rKgTEmQ2kZi2G0MhlZJByQJjHK2892RS1RRp79pDpNIzRe3rDu/Ad5mu6nffHXFzHq2ofjBs+BHSSxhRTNZb/CCU8KE5grDRo5GFIuvhAB40QcXhdBIrDMp9N+4It/62sQX9SeCo8fdJCJDWik4ZVIBafiezubT05EKKkKKS43N4educsN1GH4f/+Ay6lK1F4+whyI0brLGWeSZsEQVzdNRZUz2FcZQK491NmuuMSziUYl/oMTpWPcSbx0RBItlB3dC+ED0lVnZCS40lpi1jJTBfKkoOuBi8gQlIzNF/YbrynuRKrPiEjxkoORMmY7xDoyuse92k1Hw990thIA27JwIQd/OpWk4WFdEwkBPOk05g0c30UAe1rVvwY3SzJ9ldLPqIvLSjYZGpsprGL9qTKa/qqdyKxy1V2jBdRp3HJEMg7U26+i+F2miOlDCjpbBgGu3S58D7NyarnNf83iUjMhYs8oG3cRn6h5xJYcKKEOoODFUI
 zPpjJz1b
 MDIEIBL8G6/48T66NClRgVfPO5k5DOMmFq0ZcMIMFjRKR/Gn3bu4WUvecRqsds6bDO7JX15qkcs7lF2X/ECvfuNnFNzpdeonypjkmcoU+ilTLfO6b2iZbVUW555N1Yi1+IbnFAlPLMZ0V1wiCD1XzT2e/aFDQR43h1uwMCCe2Qb2dSHvskKbAJCSAu6EdzEfhm6IJRyinZs2cDMu+j7cl5lFEG5+6MncRaNRyJG5VFbSKHgVVnfqUpAx/zaVWtN1yYePvtASpFZ2DE0fYK0xrNt/KUXOKeLO7nsOTIfGnFOHAoI4UQihV0BTuQDaYNT4uZPfwGpEIYTwPYnApDrNDkG65AAdaHhCeRGKxwYKKN4Q0JuI5t+EgOYk4EhNu+QKHEYUnCxWvalVhhQtI6AwBUthbtXGfFqhgaclRTqbar/E87AZg5AqzmLnNEWSUUQPIHuAb+YcX0YOMEJ0Vd6sAX0ha6OO8QGwcaXIQNqwEFYUe9jASBbdh54++ndK7eyUtG3sod0ZAyqE0dXlvnvfkS2+Sw0Vi2q8H6hM94UxCKu4MjsEN6NOenZ/3HI67xdjykI++l9fq2gJsY9VZb8spL/nuf0EUvhP+w0k95tJBUhabELy/MwhKu387zjE7dFgBt9kGFqh1QfPB9CKGzP33zZqDWUYHxKemOrjEZ+7SgErZglT7XTSn/xILAsfKO0+HlAn+yqXeQRd4kNiGTjusSqF18W87KzGKxc29FBJ690N6Fq8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG:Bad_page_state_in_process" on:

commit: ffb870b766822062b6c71211c80342c85a7ffcd8 ("[PATCH 1/4] mm: Use frozen pages for page tables")
url: https://github.com/intel-lab-lkp/linux/commits/Matthew-Wilcox-Oracle/mm-Use-frozen-pages-for-page-tables/20251113-222907
base: https://git.kernel.org/cgit/linux/kernel/git/akpm/mm.git mm-everything
patch link: https://lore.kernel.org/all/20251113140448.1814860-2-willy@infradead.org/
patch subject: [PATCH 1/4] mm: Use frozen pages for page tables

in testcase: rcutorture
version: 
with following parameters:

	runtime: 300s
	test: cpuhotplug
	torture_type: trivial



config: x86_64-randconfig-101-20251114
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202511172257.ffd96dab-lkp@intel.com


[   19.289760][  T422] BUG: Bad page state in process modprobe  pfn:1618b2
[   19.290414][  T422] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1618b2
[   19.291313][  T422] flags: 0x8000000000000000(zone=2)
[   19.291714][  T422] raw: 8000000000000000 dead000000000100 dead000000000122 0000000000000000
[   19.292382][  T422] raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
[   19.293020][  T422] page dumped because: nonzero _refcount
[   19.293444][  T422] Modules linked in:
[   19.293804][  T422] CPU: 0 UID: 0 PID: 422 Comm: modprobe Not tainted 6.18.0-rc5-00422-gffb870b76682 #1 PREEMPT(none)  65c9d11eede624b36533d4efe2c3c7798fc76b60
[   19.293811][  T422] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   19.293814][  T422] Call Trace:
[   19.293817][  T422]  <TASK>
[   19.293820][  T422]  dump_stack_lvl (lib/dump_stack.c:123)
[   19.293834][  T422]  ? show_regs_print_info (lib/dump_stack.c:104)
[   19.293842][  T422]  ? smp_call_function_many (kernel/smp.c:784)
[   19.293847][  T422]  ? find_held_lock (kernel/locking/lockdep.c:5350)
[   19.293854][  T422]  bad_page (mm/page_alloc.c:?)
[   19.293860][  T422]  __free_frozen_pages (mm/page_alloc.c:?)
[   19.293870][  T422]  change_page_attr_set_clr (include/linux/list.h:372)
[   19.293878][  T422]  ? __set_memory_prot (arch/x86/mm/pat/set_memory.c:2041)
[   19.293884][  T422]  ? __set_memory_prot (arch/x86/mm/pat/set_memory.c:2041)
[   19.293889][  T422]  ? trace_contention_end (include/trace/events/lock.h:122)
[   19.293897][  T422]  ? do_raw_spin_lock (arch/x86/include/asm/atomic.h:107)
[   19.293904][  T422]  set_memory_rox (arch/x86/mm/pat/set_memory.c:2327)
[   19.293910][  T422]  ? set_memory_nx (arch/x86/mm/pat/set_memory.c:2123 arch/x86/mm/pat/set_memory.c:2312)
[   19.293915][  T422]  ? set_memory_ro (arch/x86/mm/pat/set_memory.c:2321)
[   19.293921][  T422]  ? _raw_spin_unlock (arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:186)
[   19.293929][  T422]  ? find_vmap_area (mm/vmalloc.c:2507)
[   19.293935][  T422]  module_enable_text_rox (kernel/module/strict_rwx.c:40)
[   19.293943][  T422]  complete_formation (kernel/module/main.c:3258)
[   19.293952][  T422]  ? post_relocation (kernel/module/main.c:3237)
[   19.293959][  T422]  ? init_build_id (kernel/module/kallsyms.c:?)
[   19.293967][  T422]  load_module (kernel/module/main.c:3468)
[   19.293979][  T422]  __se_sys_finit_module (kernel/module/main.c:? kernel/module/main.c:3713 kernel/module/main.c:3739 kernel/module/main.c:3723)
[   19.293987][  T422]  ? __x64_sys_finit_module (kernel/module/main.c:3723)
[   19.293998][  T422]  ? exc_page_fault (arch/x86/mm/fault.c:?)
[   19.294007][  T422]  ? __ia32_sys_write (fs/read_write.c:754)
[   19.294015][  T422]  ? do_sys_open (fs/open.c:1452)
[   19.294022][  T422]  ? entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[   19.294026][  T422]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
[   19.294034][  T422]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[   19.294038][  T422] RIP: 0033:0x7f8d36fda779
[   19.294042][  T422] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4f 86 0d 00 f7 d8 64 89 01 48
All code
========
   0:	ff c3                	inc    %ebx
   2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   9:	00 00 00 
   c:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  11:	48 89 f8             	mov    %rdi,%rax
  14:	48 89 f7             	mov    %rsi,%rdi
  17:	48 89 d6             	mov    %rdx,%rsi
  1a:	48 89 ca             	mov    %rcx,%rdx
  1d:	4d 89 c2             	mov    %r8,%r10
  20:	4d 89 c8             	mov    %r9,%r8
  23:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  28:	0f 05                	syscall
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	ret
  33:	48 8b 0d 4f 86 0d 00 	mov    0xd864f(%rip),%rcx        # 0xd8689
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	73 01                	jae    0x9
   8:	c3                   	ret
   9:	48 8b 0d 4f 86 0d 00 	mov    0xd864f(%rip),%rcx        # 0xd865f
  10:	f7 d8                	neg    %eax
  12:	64 89 01             	mov    %eax,%fs:(%rcx)
  15:	48                   	rex.W
[   19.294046][  T422] RSP: 002b:00007ffe07ac3298 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   19.294051][  T422] RAX: ffffffffffffffda RBX: 000055b5fb23ae30 RCX: 00007f8d36fda779
[   19.294054][  T422] RDX: 0000000000000000 RSI: 000055b5e55e332b RDI: 0000000000000004
[   19.294056][  T422] RBP: 0000000000000000 R08: 0000000000000000 R09: 000055b5fb23c020
[   19.294059][  T422] R10: 0000000000000000 R11: 0000000000000246 R12: 000055b5e55e332b
[   19.294061][  T422] R13: 0000000000040000 R14: 000055b5fb23ade0 R15: 0000000000000000
[   19.294069][  T422]  </TASK>
[   19.294071][  T422] Disabling lock debugging due to kernel taint
[   19.373082][  T422] BUG: Bad page state in process modprobe  pfn:163532
[   19.373680][  T422] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x163532
[   19.374387][  T422] flags: 0x8000000000000000(zone=2)
[   19.374795][  T422] raw: 8000000000000000 dead000000000100 dead000000000122 0000000000000000
[   19.375424][  T422] raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
[   19.376107][  T422] page dumped because: nonzero _refcount
[   19.376525][  T422] Modules linked in: torture
[   19.376917][  T422] CPU: 0 UID: 0 PID: 422 Comm: modprobe Tainted: G    B               6.18.0-rc5-00422-gffb870b76682 #1 PREEMPT(none)  65c9d11eede624b36533d4efe2c3c7798fc76b60
[   19.376925][  T422] Tainted: [B]=BAD_PAGE
[   19.376927][  T422] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   19.376930][  T422] Call Trace:
[   19.376933][  T422]  <TASK>
[   19.376936][  T422]  dump_stack_lvl (lib/dump_stack.c:123)
[   19.376946][  T422]  ? show_regs_print_info (lib/dump_stack.c:104)
[   19.376952][  T422]  ? smp_call_function_many (kernel/smp.c:784)
[   19.376959][  T422]  bad_page (mm/page_alloc.c:?)
[   19.376964][  T422]  __free_frozen_pages (mm/page_alloc.c:?)
[   19.376972][  T422]  change_page_attr_set_clr (include/linux/list.h:372)
[   19.376979][  T422]  ? __set_memory_prot (arch/x86/mm/pat/set_memory.c:2041)
[   19.376984][  T422]  ? __set_memory_prot (arch/x86/mm/pat/set_memory.c:2041)
[   19.376989][  T422]  ? trace_contention_end (include/trace/events/lock.h:122)
[   19.376995][  T422]  ? do_raw_spin_lock (arch/x86/include/asm/atomic.h:107)
[   19.377001][  T422]  set_memory_rox (arch/x86/mm/pat/set_memory.c:2327)
[   19.377006][  T422]  ? set_memory_nx (arch/x86/mm/pat/set_memory.c:2123 arch/x86/mm/pat/set_memory.c:2312)
[   19.377010][  T422]  ? set_memory_ro (arch/x86/mm/pat/set_memory.c:2321)
[   19.377016][  T422]  ? _raw_spin_unlock (arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:186)
[   19.377023][  T422]  ? find_vmap_area (mm/vmalloc.c:2507)
[   19.377028][  T422]  module_enable_text_rox (kernel/module/strict_rwx.c:40)
[   19.377036][  T422]  complete_formation (kernel/module/main.c:3258)
[   19.377042][  T422]  ? __might_fault (mm/memory.c:7142)
[   19.377046][  T422]  ? post_relocation (kernel/module/main.c:3237)
[   19.377051][  T422]  ? __might_fault (mm/memory.c:7142)
[   19.377054][  T422]  ? init_build_id (kernel/module/kallsyms.c:?)
[   19.377061][  T422]  load_module (kernel/module/main.c:3468)
[   19.377069][  T422]  __se_sys_finit_module (kernel/module/main.c:? kernel/module/main.c:3713 kernel/module/main.c:3739 kernel/module/main.c:3723)
[   19.377074][  T422]  ? __x64_sys_finit_module (kernel/module/main.c:3723)
[   19.377081][  T422]  ? do_sys_openat2 (fs/open.c:1447)
[   19.377089][  T422]  ? __ia32_sys_write (fs/read_write.c:754)
[   19.377095][  T422]  ? do_sys_open (fs/open.c:1452)
[   19.377100][  T422]  ? entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[   19.377104][  T422]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
[   19.377111][  T422]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[   19.377115][  T422] RIP: 0033:0x7f8d36fda779
[   19.377120][  T422] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4f 86 0d 00 f7 d8 64 89 01 48
All code
========
   0:	ff c3                	inc    %ebx
   2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   9:	00 00 00 
   c:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  11:	48 89 f8             	mov    %rdi,%rax
  14:	48 89 f7             	mov    %rsi,%rdi
  17:	48 89 d6             	mov    %rdx,%rsi
  1a:	48 89 ca             	mov    %rcx,%rdx
  1d:	4d 89 c2             	mov    %r8,%r10
  20:	4d 89 c8             	mov    %r9,%r8
  23:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  28:	0f 05                	syscall
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	ret
  33:	48 8b 0d 4f 86 0d 00 	mov    0xd864f(%rip),%rcx        # 0xd8689
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	73 01                	jae    0x9
   8:	c3                   	ret
   9:	48 8b 0d 4f 86 0d 00 	mov    0xd864f(%rip),%rcx        # 0xd865f
  10:	f7 d8                	neg    %eax
  12:	64 89 01             	mov    %eax,%fs:(%rcx)
  15:	48                   	rex.W
[   19.377123][  T422] RSP: 002b:00007ffe07ac3298 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   19.377128][  T422] RAX: ffffffffffffffda RBX: 000055b5fb23ac50 RCX: 00007f8d36fda779
[   19.377131][  T422] RDX: 0000000000000000 RSI: 000055b5fb23aff0 RDI: 0000000000000005
[   19.377134][  T422] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[   19.377136][  T422] R10: 0000000000000000 R11: 0000000000000246 R12: 000055b5fb23aff0
[   19.377139][  T422] R13: 0000000000040000 R14: 000055b5fb23ad80 R15: 0000000000000000
[   19.377143][  T422]  </TASK>


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251117/202511172257.ffd96dab-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


