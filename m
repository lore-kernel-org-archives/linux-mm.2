Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE790CA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 07:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6ED46B00B7; Mon, 25 Aug 2025 03:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46AF6B00B8; Mon, 25 Aug 2025 03:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E376B00B9; Mon, 25 Aug 2025 03:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A96256B00B7
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 03:01:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20F1983C02
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:01:30 +0000 (UTC)
X-FDA: 83814383940.19.32C432D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf12.hostedemail.com (Postfix) with ESMTP id 26FD340012
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:01:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YqGO+SYS;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf12.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756105286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nOVzKuHbfeH1e3fCvXoxGcoGa8xN8CKGGG3Xds0NKrI=;
	b=jb0FTOyWT45Pu/bufu6YLWRhrRryTKg8gxbTNOfxGDb7J6i0gK+KXFnLGQPX1LSejuUCdB
	DVwJwey6Pp9QJjgaivSGalxgaaKnyFWOai8qdJqwfvK4+j/L4KgTDHBHYuV2K3pS+3hnbA
	Zk4RvjYtYeDgz/p2OhHEt6mJbkuKsvs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756105286; a=rsa-sha256;
	cv=fail;
	b=gFjW26ZARBL8H5LnNKBDxPsRNltFZcNInpA/EyR4EtUFoR82zTANgnxvUcGmWtyVnTEDb7
	qCK24JLMrvinoqeCny5fd0onAVTHusFLKjMsCRo2uzlUb+XkOKSn+LaZzNEc55dk3WVoIr
	0j07df8PR/MQWkLaKC+6MH8hFpomwVs=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YqGO+SYS;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf12.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756105287; x=1787641287;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=z2P5bhHOC+JgHS07wF5MySGnpxBStIeLAduyiSRirc0=;
  b=YqGO+SYSkEhlUBxw6uHbu1GZdOVslC1ew7v88SFqhcf4h3rS3NXKmk6f
   EVUUK+AVWZTKDlsJF+e58yHcy3Sm8EIe6dI5SO7lmM8CTsqqNJb/1QukU
   m58CdGZzId026QnAWuEnNp9yUc9bIHsaaE6HvzaWjXrYbCBzSuJNcii7e
   9gQJ8go0QlwMJgSFFgwrZ6o2Tp2DZqzQoOMjQ545Fw3zXUc1QB5Gu6BO8
   rqExdsdutCGlE+rxLn3Ly+2KrUYu3/oXGN7tposHkgm3D2pskeH9x9dSW
   SpQc523NU55JfKKatqQPhFTzVSDZ0SMzYiIHSdGW237DjacCeBe1Y0bcU
   g==;
X-CSE-ConnectionGUID: Jtf9EzdhQES8GwDmQspDcQ==
X-CSE-MsgGUID: 0JI4HAEZSs66WsqB37rSHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11532"; a="75762042"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="75762042"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 00:01:25 -0700
X-CSE-ConnectionGUID: yKVFEwImQ76/KWl3q9hEgg==
X-CSE-MsgGUID: +vypR8t1RGOVs23OcNPS6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="168721159"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 00:01:24 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 00:01:24 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 25 Aug 2025 00:01:24 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.60)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 00:01:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xq8+EBwQQ2vM8wc7OElFmHOHy/V4yShoHoJSThsRD2UyftS8rm2+57JCHPEmcB/AjuxeLx2/zmt48RmkvtHBUPpD/npA8ceZU08zlVGLZ614riSx/wRQ/yJcfHhtYewhK/ruFnzXzo97N4ETcO3AcdnukaFckqQxx5HI98tUwRPX6SwRBL9fc061ulI1jdyFEJTVFY+lROI2iFftAtGEEyDuIOULkuN4uU5pB/u8Es8ybitXRKm9OOTEYAaR5U7mxoj9tlxnjQDNuFxtl+0GkekpvaYImGXVMrUu9TnDf3/8ZHwBEi/VDEFHLW7Im7SS8j0I8ALkqwgANWi0RLZBeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nOVzKuHbfeH1e3fCvXoxGcoGa8xN8CKGGG3Xds0NKrI=;
 b=bXhaHGlQJF7x3QdpMK7qQMNXiruF1olLQHrrX/ahocLxm5444dlGdeWnOXwxuQXotx+KyvLBVy9dK24gPNTOKer+gvopIVb6CKEeiP4F9Fm8C5xIieGdjALXyls8uiWp7/XpvirUb6KiKz4W6lmfPIihuJdPBgiq3c5Dl0/1nj8Ggg+UO9c6HiIfeOdmETLa+PyMsViB9ye7nepWpf/WsoSFRDGscqym0U+TdeEfj85SuROGYYS/0EfBHS4r6eo7oApql1rR7Je6ut6T//28vlVGLQPj9coqK4oRdsQxnjbdosqem+3VjfbmrlX9x3ZCQ7X3NcQbr+264pyxF7takw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH0PR11MB7494.namprd11.prod.outlook.com (2603:10b6:510:283::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Mon, 25 Aug
 2025 07:01:21 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 07:01:20 +0000
Date: Mon, 25 Aug 2025 15:01:12 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Mike Rapoport <rppt@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, David Hildenbrand
	<david@redhat.com>, Wei Yang <richard.weiyang@gmail.com>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mm/mm_init]  8a523d9e6f:
 BUG:sleeping_function_called_from_invalid_context_at_mm/mm_init.c
Message-ID: <202508251443.f2d9f77f-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2P153CA0025.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::12)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH0PR11MB7494:EE_
X-MS-Office365-Filtering-Correlation-Id: 525466f6-5296-4195-0252-08dde3a53235
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6PbD6ff3aiF5T40xaQyTxZzArgAHRG4Ps99SdFxq1Vq5PaH3qeByPkOZLOCT?=
 =?us-ascii?Q?oF1HMhacyJcoJ2AmCrsZNekWzOiLPaXiDoCTwhGgNgaZXVunRZa8Y3+dhNcM?=
 =?us-ascii?Q?mEDvgmVrcuqo9fMS4wjmKK3UjzTglLLPr9jUuEv6mKPjlZCXZAxa3y/XioiY?=
 =?us-ascii?Q?T0Yy/sm8XJrcuY9ypnosRMulcpXtL5Nic3wRgkcWt5PUv1M5f8QWEFwzpZds?=
 =?us-ascii?Q?gs8kx+xSFIN0PCFaIkwESYp8XKHkcbC80GP6gY9hmOw/T/1uW2m3k2PHL43c?=
 =?us-ascii?Q?SCTJ5j1Or2sevL+gRZ2y4wwCOADrU77kKjyI8c5MupJud8vpr7VK7fO7wU3v?=
 =?us-ascii?Q?m7eu30egK+3KGX8KYpC0aYf+oua67YOmXHqqEhG3mHNJK370UjjI7wZj+xdK?=
 =?us-ascii?Q?3Cj86enWT3J4/fpC1R780PtTvm7aUytdaR8OprcA4IDAs+7JBqsOAzOU6rPA?=
 =?us-ascii?Q?OY+GtBGn0QFO3bHBDFZcsng8A4W4ZTRl3q3pcOg7EpknUR3BCoFYkGfrDOMc?=
 =?us-ascii?Q?EJneBmrGDKyla8rufRexw25z+POxuxxBiYXd2dvdotMXr8bEObXrDf7DLaQg?=
 =?us-ascii?Q?VaxHtIbxYuwFFwUVZpc0ppM8obODJ68tCMpcezaLAI7eV+oNapU7XZyn6uCO?=
 =?us-ascii?Q?j5Ir/iDfgkPAw3dxVHotpAfd1rVO57yNcBvZGVG0mQ+2SvxyA1vU+UFHQ9HI?=
 =?us-ascii?Q?rSenb7Z3DOOwvpPqEw2VQaiYgfdwpcabSwDyPTc7CPq5yD2Go/hDCtdoiQGN?=
 =?us-ascii?Q?CmyzNrvtvRjlRszFFlJGRUKCoLBgSdBQyx9Arv3XlUpGhgh8iJEMIFpz+iiA?=
 =?us-ascii?Q?GC97fMiQ9o6wlj8TskymztTzikeMKuoNaUIKxcICx4q2c0myulYovfFPjpgI?=
 =?us-ascii?Q?KUaYio3SAXFmTx/alUq5eMFPD1TM5k9Q7TorgZDEwMdKLWRAzvX43hPEV3hQ?=
 =?us-ascii?Q?aAxHkJWY9/t10PRWWXvZ5DRQHcNNuv9hLojFftiU8ogDkm30VAeF0ZQWI/ic?=
 =?us-ascii?Q?50/scX9iKk2DPeXz2+PaGEt6KbqUzaIwA1JEt1oyRr9n0Gnm39tw6crbQ//j?=
 =?us-ascii?Q?beu6UTchxTCn1yXe7Xf7QFeqRCgCLClYUgr7vs1EsHcxtF1QttG96ZnCsG4o?=
 =?us-ascii?Q?2cqubHuwTmZrisbgOnRDdI667TWylj6VMwaLC4SZYUkDwcyoNWENzMm2x1RE?=
 =?us-ascii?Q?a7P7ji01OSpvG0GnoI8p4jM5EImVq662KeKuJF4Rn/Gsz8PvizeqRF5PLrES?=
 =?us-ascii?Q?Fyotqf2WYvZBbFVuM/E6xYSmvUD/FSdA5oiByZIr1bRx/nqZOVZlVjm6GTsn?=
 =?us-ascii?Q?cyV4MdLLIMXLLu5e1Dz+cUC0zKZKJv/4aq7WDVTviVl96O81H4WB1n/7ix4Q?=
 =?us-ascii?Q?XH5qE4/aH+Xa4MTzxwIL4FisAlOh?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2qNZOYAKN0A7jVEMKJE/fTdtfgXYC4FZfpN7yr9GRw/vbDlCzqIaAf30hmFI?=
 =?us-ascii?Q?r86kdbOOrVR+PExMFbtf6rBKdzm7+yCMW459vz0W0U4AYFkBGrOhLv3bICsP?=
 =?us-ascii?Q?gQ3nqm0dwVPBHavp7m1X5pwJqh5uheASDnj+mZeGjGLPIqLqdSZbHu1r+rcF?=
 =?us-ascii?Q?Cvs///IPp+dfigeLZwfv01qvPBu27FgQKJlgi6dJezqPsB6Uz2tsYLEMFsmh?=
 =?us-ascii?Q?UcoUFszRBGmAHyu5Ru5kKnO+eeab8ACfKQLnNi3QQ4HXz2b6SUoEYLtgatQk?=
 =?us-ascii?Q?d9HrMVdL/IpkK+RQe/DyC28QkJUTIVu+5+ctmlUPZw4tvUcDzOv98nw3eOHv?=
 =?us-ascii?Q?dAwLVNlxFnotT5O0IioFeAGOmzfNFfKaz3gA+vUS/pLod59T71ka/Rs3x/TY?=
 =?us-ascii?Q?99iVgNR38Sc6LB5TDs3F3Ck0cD4R9s78snrKGhT5ow+O+Hs6GxxWRjzRC7XL?=
 =?us-ascii?Q?CiF6/JmKbPK+cKJh4MDDHWBQXW6KEqeG1b0F8Cko20uAFLaow6rR5GScuAPm?=
 =?us-ascii?Q?ogimu3G5D3Ob22C4w3sHrsvypbGBIhadZQJyPXVf7WjPRm6c+maPx/+bYb/1?=
 =?us-ascii?Q?0YZka7/ZLVGySfkkuBR9WTTwDSSWe7A+TZxJB0NJM6Kh3E9po1ZiioMEbiT6?=
 =?us-ascii?Q?vjEkE1xrBh6yl/eESHtbi37K42aM2eHAv60GhjTCP1gkoGP/eHmwIr8yeRde?=
 =?us-ascii?Q?kABc62RKIMBMczza55TnL1RKFOuOW4Stjz3JDkcI958HEcSR6QKRSBijIP2c?=
 =?us-ascii?Q?xj2hHQ0ccAyOedQrjLY15Z9GlUXfrrCc73R2YnoEADRM8JbWwpzHFC4ySSMJ?=
 =?us-ascii?Q?m99pGoRRNtS/XNeU6BOyrc011SDXMqEZBl+UywVpgnLJ03xESrITQcYOdbc0?=
 =?us-ascii?Q?g2oXz2EM0CYzu5k0hbezemHLXXOAwe88IdRibkMCBojVoqXUeZ0cCY2drlwH?=
 =?us-ascii?Q?pHuJzQjllZkUCIMDqTeJdU7hMGwWufzjEqrS7kLPRtIkmfJ6H63YFkyew+ot?=
 =?us-ascii?Q?6ft6C2wMPK+IGff885kXS1+5ef/WbkUTEKApX6CgSphcSTKWV7FAdpisYuNf?=
 =?us-ascii?Q?HKVZ4Sowg84E6GPZuNuBi+jMJsqmlZhIjtb24Al43OI44u1a3QlPm99oU/TX?=
 =?us-ascii?Q?E252wkIGSF5RjAyOOZFDvp7+4F6FINETcWykTrW2qZd1p1gK8HUml8w9GsUP?=
 =?us-ascii?Q?8Ek8OfB0GwyjJ0I1h4pLOB3zVlYe3RLVfHPBdJKh8igXdUqILMBo6IzOB9Jo?=
 =?us-ascii?Q?SfTRN/D8jWxYl7kLfEiOZ2gfdZDi8j5QC3RHsc+c8tJzKl9ThmLrLqGGYkYz?=
 =?us-ascii?Q?9xytbawRlIJRYLXRNvwpdD0M9/YjYPdraT6aiWeBDfkE/M1+nRtu1NnYeO2d?=
 =?us-ascii?Q?SdJdVLfp+/5ERgrtUlgGI5nwelcPO2kAP7z8ylMe6g5QALT+WR1EDMhlzUPR?=
 =?us-ascii?Q?4UW7UQIxQCp+Dh3nw9Fs3S8vGZwXtNUSut3XlvPSivMd4AHwoV31v2HzrUOi?=
 =?us-ascii?Q?iKo399vM2rIH6O+gmgez+XM+Tuo932hoP18tNNrkjyAeizy/BOsXHQLRCI5R?=
 =?us-ascii?Q?bkPfg9trDlnsHhJeWYLAIdqCV+eI1BZoO5Yt4TCFnnkvNMIdOkm66dmQibmt?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 525466f6-5296-4195-0252-08dde3a53235
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 07:01:20.8851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iqVziHYCJKWMVtQxaFqGw3MbQXw/zjBPrP46qJz1VC7r1oBS82/+ehc/Iy/D7Y25mAI1kzKEu2wXD/Oe6sGncg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7494
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 26FD340012
X-Stat-Signature: iqbc11h61jcmf1j68scc7pbi7gxxu6y5
X-Rspam-User: 
X-HE-Tag: 1756105285-689660
X-HE-Meta: U2FsdGVkX1/ri/SMdtQIO9x2hrybCd7z4AS0zXYyjUL7XF1EAIC1ll1k/7c+fiyowGJW1Kzz3DyJOOaaRodLLl6TPgGzQXNhJFK4VEvoEaYrjOlR+3FC2aQAmeCwAeWOAwrnbZOHfV2X2NdGGQtaJUY5ZcJkG8L836/8sl0fi2ZlMeesoe5u+kab7fvHr1O99TDPR7dzBuSinPlzz4j414uq2Tk0SqcGs19/1iF0tEgAi0lga6LA4KbX5PPRBq89/BiHWSWFKjb22dOSjnWrkK8/13tMMwXcMFkaYPZ2KPlxxyN1H47BLgI6Shkm70X4JXseaJIzFYq7AKzOr+BP/n2dCdedXNqlwfidK+u2RGVAbMq4cxfXcfkHUUMSYXfIGm7NSaVBt78fgtIknkeyKj+sPgMwdJuE8ixyso4rg7jzSZC2W0DELQldtM0a5KpLl3oCgxC0Yuimt0SHEzG9TBHorEN4HSBUxTEH6jOXFKMKn7ccRQ+qe5Oy/1o+51a4sK6IUkHxw1IWKRBUX0TEXlx2hrqe8SsYodjRJ4bFQpH65rEr3UvjjOb4im/STCT168FX5zoyPiDmPVgzK4Us/QOPB2XO+IvL+JtZpy1T2Ec1cULH3WgtGGSvNGT3Ff6L5udNssTHTW5zLA6f/SpuZYDcrppIj9HGRtwFqbPzKM/NHmzfXxFXoMaG6jiO68BWCg/Vls86j4K+usQsuK+vYZ84bXe4miSy/FHWPZZbI4XX4aJd5AlYQnLh5xwVqKciSTmxGT3JRtntLuknanQX8jhDiP1Weu1SFrrQRccPMkV7H8RXWXl+41PHw5kxtWPvVRLyyW+L4EfekKSN+f30s0LGR/YDPYw6zvxiVZbA6nmvpr+AhjNtILziNlgzAn2HiTR1pU6NWcuwawYX2m4q7UnqlE4WgPPaEpTY0sV3g5lsUPIN1nXCtPavHty0YPSbrZKqHPwzthYBbNmR1kW
 u1DJ68xB
 7UFUekoIKfLTeQgGRI1wgklgZuIMBJpivqfyc5IQVA8Fk2Z6ODpEWNSc9w9pvM2VCPNVOzWqqq2db0ltcyBrOKJRk1wcwgbZivEIXnSORHjxyqCLxXxECIWbKaG+2fDtp6/pXK8Rx6HbCV0fdvSOV78HjAiDp+hMpBKWr/NEFRBd3XfNuz+weEHZvgfZDW36iYwLP102NIJiWdTPhErjiB5M/4CTHtubojkzthYK2V2N9k9pRvTSCYAvmjsVh7AcayEgkm44Fo74/WUY/pH+45uvN89iNqCVetqvnoLufQn1b/cVX6F09VWifefcXU+2fRBv6o4p1CFjT3vYWU1wdlFivRZszeXUlfIJXX/gaf8eh+Rp+UC8WMK0o/hJ1N8xpnw9gJ9f9Dfr/g0gOmFAHYcKs2Renx0GnuOTO7D7EPs9PX5sy4+vi61j78nv9bk7RWC7ErWES5VZim06njt+KCV10x2ZTRGihVhCPYylssrwO1MTmGTCbxr2AhwUGq330aSYQE29ZFXFWRu1Og2dmSXwkmqUFGFHU1+HgYoTmYZcAZ7LAuAFz7XMfD3Q4qauLLk1X/FYle91olN6ybt74m0SVnLcZzF0cNg//IL346/myAXJLX0ocD6OgwkZZAYYNwwPB9AAiHJtH0tX2xGn9Gxjs3TjS6Kf7ICt3UzHwu/UezrJ14g46oPoi8um6ZrG/oHmtokJy4AwJtnAs1RJUK0pEhnEfROf8wJLDB9OZySnZ5i+rmOJT4TeiW1pI2xBwEDwrwRqLv8uOTzspJNE++udsgs6JMgJqHHr53CW0Blgx4ymQ/joTgrzQwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG:sleeping_function_called_from_invalid_context_at_mm/mm_init.c" on:

commit: 8a523d9e6f30349ad2f8c34d850483db905e976b ("mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 0f4c93f7eb861acab537dbe94441817a270537bf]

in testcase: blktests
version: blktests-x86_64-34a7fc4-1_20250824
with following parameters:

	disk: 1SSD
	test: nvme-group-00



config: x86_64-rhel-9.4-func
compiler: gcc-12
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202508251443.f2d9f77f-lkp@intel.com


kern  :err   : [    9.708923] BUG: sleeping function called from invalid context at mm/mm_init.c:2153
kern  :err   : [    9.709485] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 1, name: swapper/0
kern  :err   : [    9.709485] preempt_count: 1, expected: 0
kern  :err   : [    9.709485] RCU nest depth: 0, expected: 0
kern  :warn  : [    9.709485] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.17.0-rc1-00003-g8a523d9e6f30 #1 PREEMPT(voluntary)
kern  :warn  : [    9.709485] Hardware name: IEIT SYSTEMS NF5180-M8-A0-R0-00/NF5180-M8-A0-R0-00, BIOS 00.14.04 09/23/2024
kern  :warn  : [    9.709485] Call Trace:
kern  :warn  : [    9.709485]  <TASK>
kern :warn : [    9.709485] dump_stack_lvl (lib/dump_stack.c:123 (discriminator 1)) 
kern :warn : [    9.709485] __might_resched (kernel/sched/core.c:8958) 
kern :warn : [    9.709485] deferred_init_memmap_chunk (include/linux/sched.h:2070 mm/mm_init.c:2153) 
kern :warn : [    9.709485] ? __pfx_deferred_init_memmap_chunk (mm/mm_init.c:2140) 
kern :warn : [    9.709485] ? __pfx_try_to_claim_block (mm/page_alloc.c:2291) 
kern :warn : [    9.709485] ? __pfx__raw_spin_lock_irqsave (kernel/locking/spinlock.c:161) 
kern :warn : [    9.709485] ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:107 include/linux/atomic/atomic-arch-fallback.h:2170 include/linux/atomic/atomic-instrumented.h:1302 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:111 kernel/locking/spinlock.c:162) 
kern :warn : [    9.709485] ? __pfx__raw_spin_lock_irqsave (kernel/locking/spinlock.c:161) 
kern :warn : [    9.709485] ? rmqueue+0x8f7/0x29d0 
kern :warn : [    9.709485] deferred_grow_zone (mm/mm_init.c:2286) 
kern :warn : [    9.709485] get_page_from_freelist (mm/page_alloc.c:3824) 
kern :warn : [    9.709485] __alloc_frozen_pages_noprof (mm/page_alloc.c:5148) 
kern :warn : [    9.709485] ? __pfx___alloc_frozen_pages_noprof (mm/page_alloc.c:5114) 
kern :warn : [    9.709485] ? __pfx_smp_call_function_many_cond (kernel/smp.c:784) 
kern :warn : [    9.709485] __alloc_pages_noprof (mm/page_alloc.c:5182) 
kern :warn : [    9.709485] dsalloc_pages (arch/x86/events/intel/ds.c:611) 
kern :warn : [    9.709485] ? __asan_memset (mm/kasan/shadow.c:84) 
kern :warn : [    9.709485] reserve_ds_buffers (arch/x86/events/intel/ds.c:631 arch/x86/events/intel/ds.c:789) 
kern :warn : [    9.709485] x86_reserve_hardware (arch/x86/events/core.c:420 arch/x86/events/core.c:409) 
kern :warn : [    9.709485] x86_pmu_event_init (arch/x86/events/core.c:673 arch/x86/events/core.c:2475) 
kern :warn : [    9.709485] ? kmem_cache_alloc_node_noprof (arch/x86/include/asm/jump_label.h:46 include/linux/memcontrol.h:1714 mm/slub.c:2210 mm/slub.c:4190 mm/slub.c:4229 mm/slub.c:4281) 
kern :warn : [    9.709485] perf_try_init_event (kernel/events/core.c:12581) 
kern :warn : [    9.709485] perf_event_alloc (kernel/events/core.c:12680 kernel/events/core.c:12954) 
kern :warn : [    9.709485] ? __pfx_watchdog_overflow_callback (kernel/watchdog_perf.c:107) 
kern :warn : [    9.709485] perf_event_create_kernel_counter (kernel/events/core.c:13779 (discriminator 1)) 
kern :warn : [    9.709485] hardlockup_detector_event_create (kernel/watchdog_perf.c:133 (discriminator 3)) 
kern :warn : [    9.709485] watchdog_hardlockup_probe (kernel/watchdog_perf.c:267) 
kern :warn : [    9.709485] lockup_detector_init (kernel/watchdog.c:1312) 
kern :warn : [    9.709485] kernel_init_freeable (init/main.c:1571) 
kern :warn : [    9.709485] ? __pfx_kernel_init (init/main.c:1461) 
kern :warn : [    9.709485] kernel_init (init/main.c:1471) 
kern :warn : [    9.709485] ? calculate_sigpending (kernel/signal.c:194) 
kern :warn : [    9.709485] ? __pfx_kernel_init (init/main.c:1461) 
kern :warn : [    9.709485] ret_from_fork (arch/x86/kernel/process.c:148) 
kern :warn : [    9.709485] ? __pfx_kernel_init (init/main.c:1461) 
kern :warn : [    9.709485] ret_from_fork_asm (arch/x86/entry/entry_64.S:258) 
kern  :warn  : [    9.709485]  </TASK>


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250825/202508251443.f2d9f77f-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


