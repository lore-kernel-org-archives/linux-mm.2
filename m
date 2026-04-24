Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A517AFF8858
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42DA6B0005; Fri, 24 Apr 2026 17:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3AD6B008A; Fri, 24 Apr 2026 17:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB236B008C; Fri, 24 Apr 2026 17:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6A796B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:23:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D1901A012A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:23:18 +0000 (UTC)
X-FDA: 84694725276.07.A9C65E4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf29.hostedemail.com (Postfix) with ESMTP id B9A5A12000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:23:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mUOBjlq1;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf29.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777065795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hh/azdyUcArDoVJYw/ocjyEMuoeC/ZMl/FlS8dvcD1Y=;
	b=7TBCuZbOpIk8gEKm1Gv2CKdL4o6caRcjxLkrsBezQXWBmJBwKG04c9xAV0l3cU5zMBb/Ov
	3roX2nXGzezMGYP6r7U2ixr+3k5y4alpB7KN/9C6IoFI871HvdnPj31njF0vxH4K32XcuD
	maFxUYe8yvkvgg+NgNHIH/QGgCKlrNE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777065795; a=rsa-sha256;
	cv=fail;
	b=vQ7ELlLx4Yxz2Do/+FTx9BwyS+bscNqdVe3XaFLmJ9AzwY2eTC/cLovZddWQ3JYl2tfLyj
	mvsTq2Z8u+c5xV+/gTJ9yWuQxA5YMZzayD/g3MMCXipKHd6kD6T17aY0xBhXJly54Zd4Q+
	FcAe3KqUhqq71st+ju3b2UUFA1TH8mY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mUOBjlq1;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf29.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777065794; x=1808601794;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=NYr5qLoebBRUEqT0ZNonwYp7iTGFDLJm+P4NivVdMiQ=;
  b=mUOBjlq16VEO9qaVTPYcYJt1EQA7r8nc5SaTYKh07pD2rsLlAnENOEV0
   tjDW2NaNmABnsddpINhWdsL7+wwt9l/V9XXDX0HOyvVw4rgxhghcgOIgL
   OtaZmpxpBaH5ObhzngZJro/f8AOwEFxzo1RV60djniItMM9m0qATHCHHG
   QosQ5aMqj94LIVt4yc1VThE4OC2g7eiRbw9B67Mqm7kkLtskcqgP3aLBB
   EN+CARdjl+c9Ejxtk7YGFKepM89TBuHOhUm2gWbrDW0XWzJ3DnFUw0hwH
   sEXKDcw7AljZpQhp9pwgYfKd8/B2x70ln74ZOZ3aPb635KFknsoVgHQkn
   Q==;
X-CSE-ConnectionGUID: 9tfpelPbQCilYuDhfu4SIw==
X-CSE-MsgGUID: FIMwa/M3Tl6rzHYmp7m/OA==
X-IronPort-AV: E=McAfee;i="6800,10657,11766"; a="78112585"
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="78112585"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 14:23:12 -0700
X-CSE-ConnectionGUID: /IFRKOggQMy9GvVQpjb+kg==
X-CSE-MsgGUID: kBSpyk0mTzO2gUVMLmBoWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="256351889"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 14:23:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 24 Apr 2026 14:23:10 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 24 Apr 2026 14:23:10 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.31) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 24 Apr 2026 14:23:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cBTKJD38S4Ykxk0A0bILTlJxT9orSkHQoBQpUMD/zymvbwadGWuVzPbPPVRjUBJWvbpjpDgaJiJbdIWR+j5xgfGuKUu/FoxSAEGSU7ZPCaoiDzgK8Wq1p1M6Rq2YLS8xMLvtW9CuZOfElMfDwlo1PgVh+11axwP5ctTH8HhNPnggzl8J7bMMbq/XdbGOwgvlmVREfmp4IJy+laHvcggqgMEbo0BLGHxrZBx4WzqCVUckjq5Ok4zk7kb01GfsN0FL9M3nVx6uiCoHVN9h3bqs8XqzDJA03tqeQ/vN1GyqYBbukEqPi4UTqU82GmJoLM7PYGmafAcHzd0r136vrmBN9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4F/S16E3TVRWSRrk6ccnWj++9WUg9F4MrxxbgSRd7o=;
 b=FMc2AQ3vmM+AcyTyTkOPvSMknsrDGwDLp4kvdE2Bl32wrKXJX8Pob60x29fYzFGMG6dxcxRqxrvhzGeOx/ujdjDklzkOV1MkxRruKvUODmXIyt2n8tOAHGfLycc+tzLpTB2Jy1iiklS3UqZkVjAS1nLAp8aGd5zKMasQQulaFFxj4EUbB05Ld/DOS5cGu5iYWgV2fMNCKg2M/sV15seolyOA8mHvq/Fa6MHX5RtC3ap4jZubNclE4JCU9k2+ZPm5fQWjo6N/lPb34QwXwlLZxvARtHEZigcRhTDXXr5WYSu/Livd5VL7jLDNnrI7EIkWRG39csVFOLk08sHQ+WH3sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA2PR11MB5020.namprd11.prod.outlook.com (2603:10b6:806:11f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Fri, 24 Apr
 2026 21:23:07 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%7]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 21:23:07 +0000
Date: Fri, 24 Apr 2026 14:23:04 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, David Hildenbrand <david@kernel.org>, "Jason
 Gunthorpe" <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, "Alistair
 Popple" <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, Zi Yan
	<ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>
Subject: Re: [PATCH v8 0/5] Migrate on fault for device pages
Message-ID: <aevfOMdaANt0lAUo@gsse-cloud1.jf.intel.com>
References: <20260414041226.1539439-1-mpenttil@redhat.com>
 <20260424092336.7f8f5b0c00f4b46f9e0879d9@linux-foundation.org>
 <3faef07e-5093-4d9f-bb1f-e9a1f2dc6100@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3faef07e-5093-4d9f-bb1f-e9a1f2dc6100@redhat.com>
X-ClientProxiedBy: BY5PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::12) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA2PR11MB5020:EE_
X-MS-Office365-Filtering-Correlation-Id: d4a0410e-3d11-4a51-4b1c-08dea247ad81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|56012099003|18096099003;
X-Microsoft-Antispam-Message-Info: ET6wUb47D60/YMZomnBNgWbx9LbCjs9XQOCs278vmzm2Y5bscBy7el2yxZsTG1aKSZtfj4asABJ8HOZ2BX1bg8tn7jyML+WIv2NcTqb9JPJm6FGznsD9tRPblBVcWUpvTTXH7l4NR5LgCxn/JCiH9TDpT83hYMY05mI3t86Ikpiw6d+mZet9DYGIqusI8eqVuMCZjRij+7h+9MmnmCiMNDemWlT1UnELf7dE5OvjeuWXDb0D55cD27e0klPT8dy0pQKg9U4fcoPkG8kdQx/sg/ZHnTf/J7+a0xd193ragjWMdiSeVdXlA+xMOIOmM47SWxoXjZZXK0TDCQ8uSlJIWJP1RHL2xYDQLCBL9CByecZeOkZR1irZgztXWg4KngsM6uEuXnqRq8BzQLygke7IYC7zzLr/839ISVDTkwPcu///Fzem6fIoyiRT/GXfTie4234AKRiU91UWXwPsDW247qKvhyNXLlZ70P1USwz7ieB4D2SLs8XKIs5dITBkhtRDJULLriOE3b37ziPg0sgzC/FEkym/GOGRRJV3AHSj8A1kaf7T3QGdLansGI3a2kzJaptvAhrYyFGt+l5eflmd3wQempz8mDGtW36Ed/EFI6n3pfVepSI0tBYGx4u+tqhGizsjw70bH6REVQm+8k2jlV1IiR1ULfs2M5I5Pbx55Y0QRvHhrz+vh+HGoDghu46gUiplZX6urXo9WS4cRFvNy3FYQLzQOWWksHQ5v4Ea6T4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(56012099003)(18096099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?1uQceSk208vxNgVgMKhuT8p86SZzUGy7x9tqBeblvGwHCWcxE8TDrrLUKC?=
 =?iso-8859-1?Q?qM8CFmwPfEezmczoQP5bjZWDy4T0iCSwiu3TWWjCpVktwG0e3AcK2OAJia?=
 =?iso-8859-1?Q?3kCHXObJWVEy0B8vlP/1AgAATA8/BsTZI0giQr5iXjH02JY0jSsRKWNzvl?=
 =?iso-8859-1?Q?jmzqIM87B1zYRq7djBpand/OB16tAteTgDybt/zfET/cRVYYRYHNL5fB7V?=
 =?iso-8859-1?Q?3SbuEnRUgsH7ciBAaoNs3PtxrZTL2GXZIONWEKF1QhfVsO7/hB0EKp841j?=
 =?iso-8859-1?Q?RpXxOB8K19bnrDFrWlUgOE7q8pUIBgibRHnGZ7o6EqyDkUrX6sgvkp5La+?=
 =?iso-8859-1?Q?M0QGz+k5HWGl9YD+sF9Y3tSZnEdyFwrM8g5VMqAZKmwEDjfDUNInuQJMYO?=
 =?iso-8859-1?Q?qUGRdLdEg5eZfW76zi0NRHaPayudXrFrLNaWj/Ays2bcdz2ThrutjHnWs1?=
 =?iso-8859-1?Q?uKvTflJRNNeCIkPsgd4drKz77j4HFtd/Z0+GFmMYLK3nvWjKfgEJvYtGuj?=
 =?iso-8859-1?Q?4uYspkafQHm7hQeW1Our9U9x19dylqSa+GicjbDkVFhM7hTVboeSEbb8yK?=
 =?iso-8859-1?Q?sYyF+G/S6KNowqsGt8n29st4mSBCNaXhIZf7QMyuCk4WMmxh8WZj2jANl3?=
 =?iso-8859-1?Q?NZySUgi4tm2kY6Xh0xirjmqzYHuANMZl/old++VqRb0ETVCyblgiwCTHcq?=
 =?iso-8859-1?Q?tS4WmtBf05nBZ1aCQngQ1VaHJdqODlLDh+qn/T5tS6CkkPk/25u6nAliBY?=
 =?iso-8859-1?Q?kX9UUDU4EnZ/lmQ76XBy2aPzQC2+spn5zl9hDj99BIhXQZwSP+1xU0Hy02?=
 =?iso-8859-1?Q?bT885eZ5uXoPiSXeS0MHGVA3WRBe1tkHk2JW3rJMGvUQUsEcnd2YgZ1R/0?=
 =?iso-8859-1?Q?c9Uv8GuDlDwPG1zuob7f29nzJiNuLEvgm2zVKBvDRfbv+5pgzGVbuXG4aX?=
 =?iso-8859-1?Q?24pboMvZd2PD1BwoVGCvhmW1EJcl4/pJnRuzzC7RvyEFBF3a0EvHhEQOBm?=
 =?iso-8859-1?Q?+wbTjkcSvc3fC5s2nrsEORZeG/CFK1jBhHwY8FcJ9jsEhP76j7wyIiEIDM?=
 =?iso-8859-1?Q?eKAnSUA7hHSeEAv8qET24qJh3azeJJufmHVrpF3uSNQ0qC8iCWhiot9Hxe?=
 =?iso-8859-1?Q?HXDDbj7Qseq8P66MOTCtrpJvEYMXHFWpcwPLsRgaa98EQHl/VeiNi00eTf?=
 =?iso-8859-1?Q?Hqw2UYcnVgE6xv8ihp+9I87volA58KTA9Nuw30ouICyWuRkneywwIskMSm?=
 =?iso-8859-1?Q?MioEHOyJXefaGtnfvSS8bBtADLa/YtlX2I8WqIGoptTajBOFQc+1uLcLJ5?=
 =?iso-8859-1?Q?HEwsa6jhzr3VvTQ3yx+cTn5hgkeM+m/ZWkPv3Jyla8V7Es0Th4XfhAN8xe?=
 =?iso-8859-1?Q?EV18u+CDiFj4LDRyF8zBXKECi/2L8hzJEce11poKOoMrEbp7rWKSfhGdLr?=
 =?iso-8859-1?Q?SwUkvtTqzvfUNNYtRAIS7HlmLxE2SCLHIYmjBvTut29CKTG5h7JN7KLJwO?=
 =?iso-8859-1?Q?LFku0KgcIAJPTcp9kWym9uWR6Gkdn+Zo3AfulNhNX3FN4ZPUowtSTz38Cw?=
 =?iso-8859-1?Q?Y75JKlEW7SIn3gqts4NwPtkftOnBtXxzcbGaC3RWElG3ViOMMG+cKqBcVI?=
 =?iso-8859-1?Q?1q9cNXbXzUXXZYhdKQgoJSDZEBI23JMOQMPKYUhY29HtHfOI+QcihVkrx3?=
 =?iso-8859-1?Q?eywasqw/TzZ2wHG5PPE3L6mWr/NZOw6+4Jz3xNyLUXu1RQFLhr+9eq+Bpy?=
 =?iso-8859-1?Q?jqefW2WQZTMZL03kAasXSKxsW22yN1Ul/eQCLbMdsn0/HRxBJjInw+K93E?=
 =?iso-8859-1?Q?wbcpftECaQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: CfaZa5uyUlKoY5QRJJJQi9wGaCZ3OYpIDAE3HdlnVRYPlc/lPbqKYWHIMAydaRP2O6jlJujb9sL7gT7jzyWqF2DIulQry8WALGu3pi4CEWTUndRVS3hXB3fm2QTLRRZ0HTfS12IRd6xvodJO7jwb/vfRusVP3ni/LIVqKTbprIJ1TLL4rjow9Logs6JqFyaPGx7KidaLXTNdFNJr9e3TbZU8ef4pblyFCTs/5lNAhI1kReiDpx9v0UklyQOupFhNgSWBgdj37w2OjKk1Kc3T8342qPFUFZnCUd1ChiPJG2186NKDkcrWsKDS8katHCDW/lNcfyR/5At9g2bAWfSjRQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d4a0410e-3d11-4a51-4b1c-08dea247ad81
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 21:23:07.2288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 86auPrpnKIKNC+BnH8mXEZrIW5iNDW1SpFggK3a6uBxT2BuJQxNrb2i0qwqkstuPBbd5FQPB0Sq/s5VmJgHfRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5020
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B9A5A12000B
X-Stat-Signature: ow5xb83hay5ocabzcc5173s3tutkkgds
X-Rspam-User: 
X-HE-Tag: 1777065793-302491
X-HE-Meta: U2FsdGVkX18dkrDWQ+e1ZC5dGkHqu5b++SSK/umwYu7xiHAUy3vuvAU9Ure/F7wBdSLzga84x/8EXm7nAIEwO8Y3vNGJoNT6ybcNjiWq4gr+jnmM13J3DVaiONi8Nc7nyT3gRhh/BXgCOIiWAfIOw5vNLOxO/M5Hfu18uTAYL9zXtJs62+L5VGEn1ulzZU16y/Ced9xQ1T7iXbvP0Y3/chwI+c+O2TyloGnX7hxPoO/e6k5E1ix/3RKL7uL+FrKBST6TwfncrHmndNVONbm+n528XbOg5TMuuA74kXA8hxRzlJQEPEGFNgFfOEQIdrQLpaGIffKt0rZjqFGkZ6X7pzgKhuRYAxTDB5+Q05QHCJ65QJxwIYJ8id6lV5AE+Xi5GzGgm8EHrxiHDRkJ1oXvbv04QQ+MzB/KL5XFuXY/DWMy4KGXxNAhCQ5IluBYAhTcgzlSyRhCybiDv6A1kqI3pNI7t2bZ/q0GlBo5JtLvjN6U6VnzKHQbDK8MojwakzBKSDF89Wyrmk3sUHgJPmw++VXzOqaTSWKg5RaggoyWUwSO2u3UnBICJx2RpdnBnbATvDfiumSw2Z9lp72yyY/1PSAa/cMrWDRZiPrtCz9Q6WgLwgE6fIQr8KZcdXWP+w7LR3IwR7Y5/C0genkHhzYQKZ2gYTfVOMfNABNiCVmGFA4xK7cvGyqmGPUmou34GUuuFZ4x3SHaAhx1r4Xn+TO6IrLOOx7Y1jlRpB3LoNIe1HOWLeubpHNm5tqBtXi3zV1eIVndKjxYn5QK8yqlAfXwcnDPqT3cR43615f3AYvOr8NrD5Iep5y8kK4VjI+e/DviVA2ph69YIK1C4e1i/1WiIvSTICFBEEXFTmAXJSAxw2bPykCZUrfeedblo859UNtBSAX4TDLFdlXaBmlX0MWJk8q1SlZUxoPndH1OWvy5D7Jta3CyqjDa3c2ULmeztmVXJFTQkAKOD9Ir4xa0wB5
 vWC83hdW
 zQELGrpRXSB4ivR9IpOULCl2jVSDiQhZ1fDQJBVHdISrA+3hw9RksIdV3Vqm8/h3ABeChZPDHgXyrE6QrzYzpuPUxUB37PJrVSKcwHF1Ac0UGi6PBIjc8hrHFLNdnTk87llD77gEkzzWR0EzGV4REUYIHZvLXYnh8Udzh036s97kO79FCwSeGpR4ZRmrImfGka2TTuTZcOhwFigayGBZzZfDmJk0b0vC/kw4XGd+gpvPy1A3KgMat73GKAYWCtTGwh6DlHW+6P+XSILqmZYMCCp43T5tL+i2piUiP8Fzx25LrD/Gsf47Hz49sh6aoaVuVQ8gBZUVPx093kAw6ncthyaOjEdFg8GH+Ia/VaV0oD9NaXVVAByNl1SO66pgJcTjKymXayypU+XKr7r75M1VDh1yIGg7w6/OaFVSY8TBsK8/Zvexeb5iYciDlk5ZFh288QGv3A5wyiYL0Tks8l/pl6l8hHtmh85hf860uoqkm1blCViuD38YYxLH9B83sUMDEp6tPFCXeAkk0MM1kExYhzC0yYTVrEdanXW68TUaS0041FGte+EUc5fqKAhEGj4czGzCZwNLZuh+Q1GaNm+w0cyuaXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 07:50:37PM +0300, Mika Penttilä wrote:
> On 4/24/26 19:23, Andrew Morton wrote:
> 
> > On Tue, 14 Apr 2026 07:12:21 +0300 mpenttil@redhat.com wrote:
> >
> >> From: Mika Penttilä <mpenttil@redhat.com>
> >>
> >> Currently, the way device page faulting and migration works
> >> is not optimal, if you want to do both fault handling and
> >> migration at once.
> >>
> >> Being able to migrate not present pages (or pages mapped with incorrect
> >> permissions, eg. COW) to the GPU requires doing either of the
> >> following sequences:
> >>
> >> ...
> >>
> > Via which tree would it be best to upstream this?
> >
> >>  include/linux/hmm.h                    |  19 +-
> >>  include/linux/migrate.h                |  26 +-
> >>  lib/test_hmm.c                         | 101 ++-
> >>  lib/test_hmm_uapi.h                    |  19 +-
> >>  mm/Kconfig                             |   2 +
> >>  mm/hmm.c                               | 821 +++++++++++++++++++++++--
> >>  mm/migrate_device.c                    | 589 +++---------------
> >>  tools/testing/selftests/mm/hmm-tests.c |  54 ++
> >>  8 files changed, 1053 insertions(+), 578 deletions(-)
> > Looks like mm.git.
> >
> > It might be more useful to add it to a DRM tree if there's ongoing
> > development against this.  But please no upstreaming without good
> > review!
> >
> > Anyway, this is a bit dated and Sashiko AI review wasn't able to apply
> > the patches.  Nor was it able to apply v7 or v6.  So please refresh,
> > retest, resend?
> 
> It is against Linus tree v7.0, base-commit: 028ef9c96e96197026887c0f092424679298aae8,
> but applies and passes hmm selftests on mm trees as is.
> 
> I plan to do v9 refresh and maybe minor updates in week or so.
> 

It might be good to send a version which applies to drm-tip to
intel-xe@lists.freedesktop.org to trigger our CI too. I know tested an
earlier rev and everything seemed to be working but another round of
testing before merging is likely a good idea.

Matt

> --Mika
> 

