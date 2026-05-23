Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 659D0CD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 13:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5581E6B0092; Sat, 23 May 2026 09:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508146B0095; Sat, 23 May 2026 09:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CFEF6B0096; Sat, 23 May 2026 09:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23D986B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 09:35:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B2D0C93933
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:35:16 +0000 (UTC)
X-FDA: 84798781032.26.F1E643B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf28.hostedemail.com (Postfix) with ESMTP id A5A64C0003
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:35:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CFWKjdnM;
	spf=pass (imf28.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779543313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=XhbkHJ3VOdVK/CfYwQJhY+kIYGmddeyfNZvIM6E4Htg=;
	b=CRcbnm+D6En3lPB9pz0qm5YUukVzIne7MPgvNFSLsSSZ7Yb0wdY9KAcLhTJWnVfXeqHffu
	mtk4hsHBjF1Tiwmd4u9B9IX2tfPqdaLq7JE+T9cYfFj9/44E1JTTfkHc+nmOL3tlTxmsys
	aIaxmZpj4KGpSZEFVock2gxsbWh3u+M=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CFWKjdnM;
	spf=pass (imf28.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779543313; a=rsa-sha256;
	cv=fail;
	b=MT8XIDCvRBQMPUcnlTiJjEbozPDj6zMjGRCXndQdD+f/RpeFuC5UUPCi6a9BoDEj1HglfF
	o+5nb+4dQY2xFMrFVUh0OgJ0SPs3Wd2z9EyPP41r4SCwaz9Ox1knlkv0Bvv5JRLcMSIVBZ
	oIhxOWOs4fl2kwcWRsKpurc4rL/x3RY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779543313; x=1811079313;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=iAWyBI0rScO99eKDPolqPUPS6uJ6Kpr9f4uKzmgQk2k=;
  b=CFWKjdnMf4wYR92xBP2iUPMZfeyoMgxnSNAXTfRvlRNjh9W6WrXTyHru
   jhJoLd6n6iT+v8oBcmwfUSBJhztPKgut3c+uhEf063vJO3JPV58IiojHU
   IlWFGQqHl4NWwURtCgn9EdYgOusfr2Dgzep74s5A26BK1MoZDbRyxTNZj
   0QWpUP0NcEzf/2mnsvRCbk/36ts04Lb/xEsLZzmsMgXAjNHKxxVn/2Z34
   cwLsXlhujszR6yi/q2WmxU/koik4qXgRnEX3Zb4BQccr30joUZD9dW8Mt
   XiGfchupXqV63tJsx4+TL5Z31HSwQQ5Bch5W+jjUTHvO3hv5jMCIlLFNH
   Q==;
X-CSE-ConnectionGUID: RpiC3l86QkWhpc8HBiXb5Q==
X-CSE-MsgGUID: IuTWoiXJStSIxMmUVJObbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11794"; a="67971083"
X-IronPort-AV: E=Sophos;i="6.24,164,1774335600"; 
   d="scan'208";a="67971083"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2026 06:35:11 -0700
X-CSE-ConnectionGUID: 33WSxgYQRCmOQyyafvBxGA==
X-CSE-MsgGUID: zl9Aan81TsilCZJpfr/CgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,164,1774335600"; 
   d="scan'208";a="279270829"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2026 06:35:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sat, 23 May 2026 06:35:10 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sat, 23 May 2026 06:35:10 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.5) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sat, 23 May 2026 06:35:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N881KxL9PqRaLNRZDWb8x5XYg8J/JE8Bxmc2WGbkzJ9q6nWjKQEOsM8yWKdYVtLg7NO1hwtdK4dKuN0B6rVfF3X7XaFBWdkautH5bF8Boeob9CGsc8x0vNybPqDqZbLLSFr3Jpo/9LO1qsefZO06xXDXG11LLiFmfIKGPFclpG5iZQ9SEpb7KdtcwjjkqprRI+yHq2yjez4+0PNq4LOOSL+cwnS/rZdlIMTkk/lr+HPJMqxlBNtmm0QlgXE37X0jrR9W8txMvEedgm2Gj9vH+/FCrSmaLg6EFrdZMfy429RXzJ2R/vFvi/thyu4QkKkr1kNl6+hAeyfOkUfyWMq6ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XhbkHJ3VOdVK/CfYwQJhY+kIYGmddeyfNZvIM6E4Htg=;
 b=MmyMmSgSQpyB/RZc6fBlGNsWe/C3QJshU9C5qTqavDmy+IvOsCyI83CfN6PnnRQkh9dhZHel6yIfbR3x6C/GxJjNTKgdltMt08C5Ney6eYnIkjaQiMdhmMUPW3CqwbVKhaSq6aPr48pR+F4fU5+vFDtlyG4kdgApSiFUEFYPgF+lzzfPUvjNEQAM987GAKtVRZXw83rRmRCfxEZ+h1/Mb/ZYuqcUqkFZ/CkwWzUp1UMSzFjV+aicAo8Sbb4pCf7AmlkEcCnXHB6QVY2WaqpYMT3hQayzSM0QLu+6Y8TTdsMxNiK2dYBu81B5sZ4R63tBkuT1/7sI7QZFGEZMlsDfBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by DM3PR11MB8681.namprd11.prod.outlook.com (2603:10b6:0:49::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.18; Sat, 23 May 2026 13:35:07 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.21.0048.016; Sat, 23 May 2026
 13:35:07 +0000
Date: Sat, 23 May 2026 21:34:59 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Jill Ravaliya <jillravaliya@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	<akpm@linux-foundation.org>, <urezki@gmail.com>,
	<linux-kernel@vger.kernel.org>, Jill Ravaliya <jillravaliya@gmail.com>
Subject: Re: [PATCH 2/2] selftests/mm: add test for vrealloc() shrink page
 freeing
Message-ID: <202605231524.731e5313-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260507114854.41117-2-jillravaliya@gmail.com>
X-ClientProxiedBy: SG2PR02CA0120.apcprd02.prod.outlook.com
 (2603:1096:4:92::36) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|DM3PR11MB8681:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b4d60c2-ab91-4d01-25b6-08deb8d01a87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|11063799006|3023799007|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: /+oZN051+GNQI54agKRJLdUnzbpBBnbsc46nU+N2P2qubfp67dr//c8VwOUlzMNPlnijSecjQ3OQGcygRAYibzwe25ABNdKLp3+qijg2Fqa6RoeLliuZ2W/3mVgnUTEYJ326VZNx5kICUVzj1IGVJ7Ljvj7OIrq7WdjvzUyyt77TR8SP9RH/Y6FSuImxmsNk/u9U4BjzgNRLWpfM+XEd05IKOKlbywurxeNAUWYWIQsgv/xVqdC8XQKqkzEEeWjglhqQcZE6XzOllDzs5v/+GF/f0ZI1RSJDqPTRx/3DeoofT72D4uLa2pG38HyswOoQFbdo9/Fhb4oJLFzyEP/yebc35hohZG5QZprzKuiQ6pbEoOnMJTiITbcHmWf7HRiuoEqNir/1EB9Ne67ftxdFfkjvBNXfuJtoEiyv2mFR9QmeK/dP0jzY/+PQl6qSJzskqpyA1uJV2KSTecjy40N+Ui6LZiCuk1s/yNDYCJS0xk6e11vMQxtRtf2HuOxMD5C5WQuDSMlYsr7di7sig74qQRZGacdc5xu0mp5gHgl/ZIVGbHNPqs1SCor9SNQ1biqEO+e1GoTVKGOq4rJdJWDModrYYSVwEyc9VY/W9CbzEUFwq1BpXiUUNiXPxLJTSoknOlnoY4Qf6ujafRSLfKrcQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(11063799006)(3023799007)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nh/1CjGkIgCKgtwowJbHtXgFA7mdUGQuMap3/4U+gxuwU+KBA0ANaAzaRpUk?=
 =?us-ascii?Q?Md//iHvuFXH2jU5Gne0LMCZ+ZGdCpS/p7wCPDLydiACrtSmD13auI6Uv/lj4?=
 =?us-ascii?Q?2rsb1q217a3HMj/mZs8eJfdLkclI/Gt/0RqzswrqXVMyRZO4yBXvHiAPErGG?=
 =?us-ascii?Q?H1eaPol/wLa1tj+jdwQ1qYu0p8ZhIEjQThOwYaRhegmvQxZoJOxnO1QnD/gE?=
 =?us-ascii?Q?nH28jz0RSySL6WH7A66uHd8ch4jd9sBaEm2YZXG1kjrOAVb7Fe/LMxlKu4qi?=
 =?us-ascii?Q?KmxdA/iDXrVAsKqJgyC3Wm6vaNLUXmnG2ENeU/e1oAFEjEPE1v6o+joGg/IU?=
 =?us-ascii?Q?5BIhxsnJ+YBt+7aU7lJLs0TsT1q2E/HfabH4mwsoCiPTpVuQ2oNsQhEG1MQK?=
 =?us-ascii?Q?+azKF7c+GxjcHaYF1j0KTC2V8l8ddPQClYq5nR+0z3HA6H78iMH9JhBFVG9G?=
 =?us-ascii?Q?xOgvGNac5kU17ObgXclBHbV2Exple8kocQLCOjuWYcYAndGdNvFBGA5WdbeH?=
 =?us-ascii?Q?Ftr3FIHFrYu8+x3Aan+1zOzGyxg9hHmaEN9hNRD6lOKVDBuaivYQ5iVm1Cqh?=
 =?us-ascii?Q?v1QmOdPCRWuDAHlEg62zdUZa9LZH/mkbgk1JGqWCl9pJhwCI9DZNHgh7VS87?=
 =?us-ascii?Q?vbNiLzPf0NdZUzLvhXn+Dn2dkWrsysOz02rap3zathHKEch9HuvdEohAij0P?=
 =?us-ascii?Q?vigxkMnw7hyg+ubrBDTiWDFRSXggvmVY8+cDBgWPBwykatkv6Uuar1wCjrpN?=
 =?us-ascii?Q?q/y9vAuWzik5V7bYtJ9M+3cJrpZu7E2lIoYoc6HtCgoz0RULBj7XgKyGY6Zv?=
 =?us-ascii?Q?9NgTSGr9XCWKI5xce3+oebtJlxLrCLBMk+1N6tgoSOguRez7TKQDhcvafSDK?=
 =?us-ascii?Q?3i7SHdEswwdTokiclzjb2HGqsrH+M3IJ0e5eImqhwTftrFfKazLfmNcWChiF?=
 =?us-ascii?Q?iPI8YG7tn1roD4kj/RDAQGBise1w4BAMFOAZcMBbDM4fTCIJZSAYU7yXXNI6?=
 =?us-ascii?Q?K2iClNl0sCrjmnUGbK1fRPGOS26h2SkjJlVQJtp1n96eEIbNh9y5IuYcR1wC?=
 =?us-ascii?Q?YGQmYB3A/LixXxR+s9HQPcrrroyHKekHWGppPojndj5qTD6IYMafXWfbmuEu?=
 =?us-ascii?Q?GyU/o8+wJp151Q1diusPNWRs2hTUOcPl+mW7+d866loQoFmMf3llEZameT/O?=
 =?us-ascii?Q?Z3acOmoMCnCJjUTNFJnBbIZeqy/o8Fr3AcjD7jWUkn9ezWLfWqaH1T/uh4sE?=
 =?us-ascii?Q?M/Yez/bsd6Z4PiGhIOB9S/RcJDs99M/xL5Z1pHeaA33+29uXgY3TLDibCceQ?=
 =?us-ascii?Q?iU+ndMR5cLQgNI+1XEte/+D+0g79gLGQ2xA0gdWp7E8/yDa2ecedT/wC/FUF?=
 =?us-ascii?Q?YL4Mft/AgsXY+Q3gn7rBA0f/g94Oprx7aeUqugqEhLBV7+9Rnh6s2lJe1vEK?=
 =?us-ascii?Q?N3tVMe/SCNkOz7/+vr//I6S/9ZZnPqQJl9lJm3rERBTAryie8aBE6oUFcsnt?=
 =?us-ascii?Q?7rzZxOrwLvYwB6gS+tgN4wH9kGkMKtNp/4w1x/PmNAk59wYtl+T88mPI804w?=
 =?us-ascii?Q?//XOAWcYo28BgwLE99Tm8IlfY6VP8PC2pW1bgXltsbUFoCISsMDoaJ6797KI?=
 =?us-ascii?Q?K7T+78yXrJqk/h1duhC3LjwRvJ7ToAs1rzl4jCNRdkxj3GBIYK1kUouvLciw?=
 =?us-ascii?Q?4QwnnsFvoMi5jYEDoXKgnJJQKsggo+oWF+U7DPx4W8qFgXGFjTmH4t85g/wq?=
 =?us-ascii?Q?1ZlQfyUzdw=3D=3D?=
X-Exchange-RoutingPolicyChecked: SG/WoMwU/kFLaGmjZKxs3ZuOyHlXOq+zLaw7wZHh4+MjuQ6+RzP1LmByeGnERv1iHuf35IKrKh7x2H3MT04+5eznL9R1AMEHGad7UhpJRtp0WoSK3AzS5n6H7BCvi1BL0PBQrxdGXjBxT1KlN449VW6stu19QfgjdTuV43nq3DjHuvi3rypLyBcC9a6ecI6uQkRo1DRpcMxarLi+Xr9Gv853GR2MguTvsnDfckCeMZB+cfabYLVv40sxUPHJgFluRadfRBtUkv65o2kQ7o1NY+olK8Z4HT2JtSO01OOFoONz6slrGe1kHAZhSB8/kEob1wf5uqq1NiIMi9hh+ielbw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b4d60c2-ab91-4d01-25b6-08deb8d01a87
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2026 13:35:07.2996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZtvIkblyDU0zsZP7JvRGWM5Aqt7pfblEah+z1CzSuRVHA5vhMhCpi8ghEzrK6DUtEs9WYLTgWRrJuilaPUAmAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8681
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A5A64C0003
X-Rspam-User: 
X-Stat-Signature: ktbhao4n3u5tm7y1sgqu9ekr86tkytpf
X-HE-Tag: 1779543312-687742
X-HE-Meta: U2FsdGVkX1+WOYWZUUPdYv4QGPtiv+vYqOCjIbe7z9eqrFjixTmxNldemZ1v88plwaoR++hBdgKVHSW2Sp3iwcCRZfCWWwo1Ik5d9dp8k6mTszqCBm9K1IbeUAKIudEyOFtvmcAZKo+RO62GW8OMY93/+b8OLoo8/oSKECBQW57aU/O1IKwsvpEwqdArYIyP8C2V4V3JwCjMvHLyBUszvvaqqb9k7WVX50JiwI2eJMD5qhyqfAx4GEGHX0VmYIc6Rqopduz7PkuQr24FzPmAXtUWF41whMFmwblGCTTJRzUt97TzbyZKNbuXc2MHJ9X7u7VX2QQoSPwjuszSoUsQOsUbci4kY41k74BiAwV55rXOfqOsZqIRUXHVpsvvyyMcHvOJLjtihFX32difemqwz1LZdePF6yovbublVFtZlV0jheeg9Q4EyMWE4j+V+IganatowI1SFxLglL+5xrrHKsCQEhCFxg1vbJYlsgFfETNKKEYIa9TqeWhsL/KEA3wz86w06Mss/7fTVIcDBL1QTEMlTyCTptErp1Su8V2ZwVyE+6FKkBZwS8jKK0yZWUt6hOGUZSXvBGMuTzxPtPHrNwOlikTT+ttXmwmolqg2gNQTwOHf4zMIJ7vPwzcb1t59/tvu6aMLtfb5nM9968qPMkGsgCPc2B9eBKWdFigOgGJC/i8bDJNnS5eXuVpQNdFciQyjxB7K4It287szE1OGW2iK8oy2+vw1JzJoy6bbn2onlu4F9ZaoB16RM5/a54eOlf1vg4zcTf2MpNwdvmj8fjYgkZ11DXukJ0hg62e+QNzH6rc02aRd2cjHBr70N5EdTODKJdsHC/U7ff94PxP3j9oXbY8uLOzhvc7YhXj4AKzEJjgDLpoRsFDTRP3cCiiQsAwk/UxnNWc6EzAYmvcaRRx9QjVlAgw7I1QfcNEd/TM2X1eUSl5NtRwEa9eLQNkjfppMacmO2yPVsm08JQD
 51rtKh6L
 yz2f+c0fRVETDyg5h9zJ4iiBtCY+LJ/L5gmVdYDNmVC08O/oHlL0fikHQ049EDZLfFGMIH5s4TT/PVxRUaL51m0Nx7Vnz6FifcAQ+3WyI1XSvLdZ0L0721ulIxfKiywwTvfdFIOSlfT4C78AEMl/Mi+fUiqYAHUvBBxaL6/cmvotnMQGTMKlG/ZSMv9nvs2172uYYuF4s5YcU7p9XdF0Dhu1g2VgqP+x+P9tqIWMYvVOChBNsVwdt4xVqGll/hJ1bzKeYOxxJZ3eiSpER0VCXUsKZx+JsqCsPXBOrnPLSyqD8nPhAc/fpUYVJ3kY1VdrMKog+GuIvidZ0vRSNvFrPZWHszSAt94mQZxjgTdu1RzbLulEXCMAjhtHjO2a22wCMiZsZz5t83S99i8vPVofKH04Y0VYVvD9LJxVqP2OxN9AaWvqhk6qql5v2NAR9QU+vqjKOuFM+aspi3hl9z33s6tlFMBn5HO+4bFImEgRyx3SAyxhcmTIbLvHTOk0FtjalxoPO3+ghn0g7FnkoUtPr90yUN8EjgB8L5tY83DLRqPKan5+sRNA4cLS17Qosl75rnu80DmBVKeXbXiBibK8v+oNPEHxwn7qzgGaObbuDDqabaj3HBa3IGBqrkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "kernel_BUG_at_mm/vmalloc.c" on:

commit: 7a2723bc6f2ec12f6e8bfccdf20c09b84f721993 ("[PATCH 2/2] selftests/mm: add test for vrealloc() shrink page freeing")
url: https://github.com/intel-lab-lkp/linux/commits/Jill-Ravaliya/selftests-mm-add-test-for-vrealloc-shrink-page-freeing/20260511-181706
base: https://git.kernel.org/cgit/linux/kernel/git/akpm/mm.git mm-everything
patch link: https://lore.kernel.org/all/20260507114854.41117-2-jillravaliya@gmail.com/
patch subject: [PATCH 2/2] selftests/mm: add test for vrealloc() shrink page freeing

in testcase: boot

config: x86_64-kexec
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202605231524.731e5313-lkp@intel.com



[    3.859842][    T1] ------------[ cut here ]------------
[    3.860491][    T1] kernel BUG at mm/vmalloc.c:488!
[    3.861026][    T1] Oops: invalid opcode: 0000 [#1] SMP PTI
[    3.861616][    T1] CPU: 0 UID: 0 PID: 1 Comm: systemd Not tainted 7.1.0-rc1-00283-g7a2723bc6f2e #1 PREEMPT(lazy)
[    3.862702][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    3.863724][    T1] RIP: 0010:__vunmap_range_noflush (vmalloc.c:501)
[    3.864346][    T1] Code: 7c 24 10 48 83 c4 58 5b 41 5c 41 5d 41 5e 41 5f 5d e9 7c 9d d2 ff 48 83 c4 58 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00
All code
========
   0:	7c 24                	jl     0x26
   2:	10 48 83             	adc    %cl,-0x7d(%rax)
   5:	c4                   	(bad)
   6:	58                   	pop    %rax
   7:	5b                   	pop    %rbx
   8:	41 5c                	pop    %r12
   a:	41 5d                	pop    %r13
   c:	41 5e                	pop    %r14
   e:	41 5f                	pop    %r15
  10:	5d                   	pop    %rbp
  11:	e9 7c 9d d2 ff       	jmp    0xffffffffffd29d92
  16:	48 83 c4 58          	add    $0x58,%rsp
  1a:	5b                   	pop    %rbx
  1b:	41 5c                	pop    %r12
  1d:	41 5d                	pop    %r13
  1f:	41 5e                	pop    %r14
  21:	41 5f                	pop    %r15
  23:	5d                   	pop    %rbp
  24:	c3                   	ret
  25:	cc                   	int3
  26:	cc                   	int3
  27:	cc                   	int3
  28:	cc                   	int3
  29:	cc                   	int3
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  33:	0f 1f 84 00 00 00 00 
  3a:	00 
  3b:	0f                   	.byte 0xf
  3c:	1f                   	(bad)
  3d:	80 00 00             	addb   $0x0,(%rax)

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   9:	0f 1f 84 00 00 00 00 
  10:	00 
  11:	0f                   	.byte 0xf
  12:	1f                   	(bad)
  13:	80 00 00             	addb   $0x0,(%rax)
[    3.866197][    T1] RSP: 0018:ffffc90000013a70 EFLAGS: 00010246
[    3.866816][    T1] RAX: ffffc90000035990 RBX: ffffc90000035000 RCX: 0000000000000000
[    3.867632][    T1] RDX: 0000000000000000 RSI: ffffc90000036000 RDI: ffffc90000036000
[    3.868442][    T1] RBP: 0000000000400dc0 R08: 00000000ffffffff R09: 0000000000000000
[    3.869260][    T1] R10: ffffc90000035990 R11: ffffffff8215b050 R12: ffffc90000036000
[    3.870088][    T1] R13: ffffc90000036000 R14: 0000000000000001 R15: ffff88810f5e18a0
[    3.870907][    T1] FS:  00007f356fcade40(0000) GS:ffff88889c100000(0000) knlGS:0000000000000000
[    3.871802][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.872461][    T1] CR2: 00007f3570966000 CR3: 000000010c872000 CR4: 00000000000406f0
[    3.873270][    T1] Call Trace:
[    3.873666][    T1]  <TASK>
[    3.874083][    T1]  ? krealloc_node_align_noprof (slub.c:?)
[    3.874811][    T1]  ? find_instance (bpf/liveness.c:66)
[    3.875300][    T1]  vrealloc_node_align_noprof (vmalloc.c:506 vmalloc.c:521 vmalloc.c:4345)
[    3.875883][    T1]  bpf_patch_insn_data (bpf/fixups.c:254)
[    3.876410][    T1]  bpf_convert_ctx_accesses (bpf/fixups.c:974)
[    3.876975][    T1]  bpf_check (bpf/verifier.c:20094)
[    3.877441][    T1]  bpf_prog_load (bpf/syscall.c:3082)
[    3.877951][    T1]  __sys_bpf (bpf/syscall.c:6248)
[    3.878419][    T1]  __x64_sys_bpf (bpf/syscall.c:6361 bpf/syscall.c:6359 bpf/syscall.c:6359)
[    3.878891][    T1]  do_syscall_64 (x86/entry/syscall_64.c:63 x86/entry/syscall_64.c:94)
[    3.879373][    T1]  entry_SYSCALL_64_after_hwframe (x86/entry/entry_64.S:121)
[    3.879974][    T1] RIP: 0033:0x7f3570834779
[    3.880451][    T1] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4f 86 0d 00 f7 d8 64 89 01 48
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
[    3.882300][    T1] RSP: 002b:00007ffcd8cbbc88 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
[    3.883149][    T1] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f3570834779
[    3.883966][    T1] RDX: 0000000000000094 RSI: 00007ffcd8cbbd10 RDI: 0000000000000005
[    3.884774][    T1] RBP: 0000000000000013 R08: 00007ffcd8cbbe40 R09: 0000559a2fc27b30
[    3.885594][    T1] R10: 0000000000000013 R11: 0000000000000246 R12: 0000000000000094
[    3.886456][    T1] R13: 00007ffcd8cbbd10 R14: 00007ffcd8cbbd10 R15: 0000000000000008
[    3.887273][    T1]  </TASK>
[    3.887627][    T1] Modules linked in:
[    3.888071][    T1] ---[ end trace 0000000000000000 ]---
[    3.888642][    T1] RIP: 0010:__vunmap_range_noflush (vmalloc.c:501)
[    3.889273][    T1] Code: 7c 24 10 48 83 c4 58 5b 41 5c 41 5d 41 5e 41 5f 5d e9 7c 9d d2 ff 48 83 c4 58 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00
All code
========
   0:	7c 24                	jl     0x26
   2:	10 48 83             	adc    %cl,-0x7d(%rax)
   5:	c4                   	(bad)
   6:	58                   	pop    %rax
   7:	5b                   	pop    %rbx
   8:	41 5c                	pop    %r12
   a:	41 5d                	pop    %r13
   c:	41 5e                	pop    %r14
   e:	41 5f                	pop    %r15
  10:	5d                   	pop    %rbp
  11:	e9 7c 9d d2 ff       	jmp    0xffffffffffd29d92
  16:	48 83 c4 58          	add    $0x58,%rsp
  1a:	5b                   	pop    %rbx
  1b:	41 5c                	pop    %r12
  1d:	41 5d                	pop    %r13
  1f:	41 5e                	pop    %r14
  21:	41 5f                	pop    %r15
  23:	5d                   	pop    %rbp
  24:	c3                   	ret
  25:	cc                   	int3
  26:	cc                   	int3
  27:	cc                   	int3
  28:	cc                   	int3
  29:	cc                   	int3
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  33:	0f 1f 84 00 00 00 00 
  3a:	00 
  3b:	0f                   	.byte 0xf
  3c:	1f                   	(bad)
  3d:	80 00 00             	addb   $0x0,(%rax)

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   9:	0f 1f 84 00 00 00 00 
  10:	00 
  11:	0f                   	.byte 0xf
  12:	1f                   	(bad)
  13:	80 00 00             	addb   $0x0,(%rax)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260523/202605231524.731e5313-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


