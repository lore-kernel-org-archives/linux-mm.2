Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE9F7C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624746B00C4; Wed, 22 Jul 2026 19:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D5136B00C5; Wed, 22 Jul 2026 19:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 476106B00C6; Wed, 22 Jul 2026 19:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0401E6B00C4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:16:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 767301A034A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:16:00 +0000 (UTC)
X-FDA: 85017972480.29.983A463
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4F97340008
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:15:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=etQzh2RY;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf01.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784762157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zb4eqmgUED98p3Gp4i7Y3GQiv/6hiOpM/zYckDqgfJE=;
	b=SN+aWXRNAJB5W2YhFLQJ0m0vez7hgAode38+jGEMFF/2caFJ8TKG9iqq1iUdd6NCc9owQX
	9nG6q8/y8kGP412dBrd1+7mMK+rsnkCdqsqsS6pxcNDy2t+MAdrQa5IbDUlAQJN01O7Ugo
	xSFzY1gqmuQsP/5L27iGMVcasaS5BNo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=etQzh2RY;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf01.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784762157;
	b=2wIPrHYbxCViVzK8C9/m2w13yfMnBGUMmtzSTOkDAy9o9MYXNKsMXyP0BiM01ZLXg+29T0
	mwfMF2Q9vpczD/qSfhsYhtQ2IzPdzpq1gCP+RAkByjgLveIgN9Xck+gYtA6L4R3TS7/5iX
	SHn8lvn+0i8zlAkvLIfaZlOJzyfnViM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784762157; x=1816298157;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NAMW9FNXT4yajWjMqDqEk5gQxXnsGCaL6fQb4vFTfH8=;
  b=etQzh2RYIxAkkuRYN6L9gDc4tsZKk6d7h7qRDQMHNQuq2fQM9VvxigAz
   6ywFYQp6IsAL0VZY+l8yz6ZIsIQfbii/UbOD+Fo6PK29KDS7G/wP2Jl9S
   wcsDEjOv8OPe/8EL4I2YOa8ZgpSPadD/36xyeYg3A0HhY0Nua6um0Kjep
   bKYGKsQoK75gKpMC64v9hmjjF42wBJ2ckMXlPWUCNUcr0EO7UyxS9igDV
   JoEjwkbpk9r6orQLd9kjUU6EHQDo2ly9wS5VoIS1TR1S1Dk0x1GJ0TidC
   JGE3HdZiGH7VARCDZFpPCk5lfb9DLAnhweWIWpDzruRaTE4NWN0BAUuw5
   A==;
X-CSE-ConnectionGUID: md3OzvmJSH+CbjsbPTf7+A==
X-CSE-MsgGUID: 0/TmZtrASTCnEyOm6wY1XQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="85604061"
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="85604061"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 16:15:55 -0700
X-CSE-ConnectionGUID: s3GHVW1qTmuZ3eUNk5yGqg==
X-CSE-MsgGUID: oQVJ9/0dS/meMqs8sU9xZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="256438542"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 16:15:54 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 22 Jul 2026 16:15:53 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 22 Jul 2026 16:15:53 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.67) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 22 Jul 2026 16:15:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pwZ9B8+WHHZPZI/9Q3XlmIJR93aJ58tS0W94Hn8XvpAZX1TXKBw3VAauDeoGcQR6zwxjDaJmxbuJKC7Yc22wAoz2CPRArq3UyCjHtia2c6IKPtHQLgwQ8v8AuVhgtx25D40W3t4oa0jznYBaI31UZiKr9M8Gl5Q3rqsGEVm3J09hUwSDZSFUT7Zsgg/yd2cH7IYmco5yLle7D14GaeKoWXCEmhMYZLBAqgMeviLv1HwVc9YUPJOPLpEfakSTLHs942VuP7iYBi53M0KQxL2Z4jzHq8fZKjgBChc4PzFa2WiMJrQ37k1pOKRnM0C3AeEXFdvHJihA3tgiu3iA3rbamg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zb4eqmgUED98p3Gp4i7Y3GQiv/6hiOpM/zYckDqgfJE=;
 b=QQGQuKAlV1sdtso5hr+ojBMkRpOW2FDeXBTCHi3bP5NEanntWfQDTabvUvOzvT0uJkkCDaghU4NMD0N8sR1Kn4exneujvNSOwTCtcX1ZiuFiz8ZyNyL6M78c6O4VgkqNyQiZHBR4d3PdJlCBUo3W6qNklzG+NEoMM/t7i74tlIcwZqE9u4O+GgDttlpUPrVjxFK48xcd2xAWwg3KPms/RPKqPv5rXxgNBPxhFsElXGcrXkw4BGg19IN/V8+3nVL7PJy07sBhQ0JU209SrHhRUIZPavbgsCLSI3glBjtTIAZqt8A37DWJud4xjjTRwOLekBlwJOWb+k5YEq5W+ZMrYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA2PR11MB5083.namprd11.prod.outlook.com (2603:10b6:806:11b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 23:15:51 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 23:15:51 +0000
Date: Wed, 22 Jul 2026 16:15:49 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Nathan Chancellor <nathan@kernel.org>
CC: Mark Brown <broonie@kernel.org>, Maarten Lankhorst
	<maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>, Usama Arif <usama.arif@linux.dev>,
	<linux-mm@kvack.org>, <dri-devel@lists.freedesktop.org>,
	<linux-next@vger.kernel.org>
Subject: Re: Semantic conflict between 04b177544a04 in drm-misc-fixes and
 0b6b1bb28482 in -mm
Message-ID: <amFPJc1NQbuYWlSp@gsse-cloud1.jf.intel.com>
References: <20260722225605.GA1910198@ax162>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260722225605.GA1910198@ax162>
X-ClientProxiedBy: MW4PR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:303:b6::23) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA2PR11MB5083:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fc940dc-36e7-4599-657f-08dee8472c43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|1800799024|366016|376014|22082099003|18002099003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info: +sn1+uANq62z5eyt1jZXY8vF2TCfP2JbSuC7H3Sx8WLgwdBCN6k5rzynpVlLsiTQfO1nh6AAmaNC8awPqEN5WIdowbMgg66vCExmphRpsZTTcS0ct5OzfDBJKWX2M4+rKZy/FIiCDbotSMWox19WRgBDMOyOwnYeJEwAuQgcNXkL4YBzRlnT0eK3XFndiKNRRwDIuG7Y1ypBDI/zjXfpNVvw5uy4/PO+WgP8ScWzR7ZMmbGEw7n0U2RAVbq4wRG41LdQTUxij8k6ynT1mGKednyUArWwK3uugXeK6k9mIscUWILQa/6BFEzll6hZDQSb5LBdhtwhtkMipJGANrDOhH5qjgyy6GoYZ0h91N4OtWw/8bFIWoR/Lx9UPV+5Tuz4W6igWPBl4mstr6W6EYJFcfZaH3Sk7o87I3/y+fJBEX2GTyn7QUw85g02aIX1CnJjoVGfwJ1feaVNEjVpqzTmiq0ULi9jxrDbbE+doKXwBJWW587jLdU1aUa5pV8KQcW1jGcYccI5xfQ2FO5Rxxnu0uTQ4tkE6n4q+irU7kNGkuuatp6q+3Bcu0UFB5GnkCRWG53k+bsCtIGI2JqKLguu849EI8Aye0jCnGcPsyuqmiebETeav6mpRe4Tc5RThM1Z0y4wPvFq7UBeY66PAsyPIdbs7I2ekheFHdUKqEUk/xU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(366016)(376014)(22082099003)(18002099003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+w1XOYMqCJ/19SHNFF//uBHGEppDS3U5FnuNRFTIwC+JOQ8kH8h/moBmM4dF?=
 =?us-ascii?Q?eNGTXa2wajNethnLmsyGuKXOOM5NC89xTxnX+NlRpU8mOTO0cOxEq8SLUqZV?=
 =?us-ascii?Q?yMQ18Q8u1u9n9K4GK1LVCCiS7cIC8FXtQOsb8nFASCzuTvF579pWwITfnnxZ?=
 =?us-ascii?Q?c2A97Q/Ttm75ECW2Mds1oXubZ1FuLdAvvH4qkbLb2xCrVvOcMPC8Bsa9ahFX?=
 =?us-ascii?Q?HGVo43t4LQ6fRwoZXs+PHL4FKR5n5rTd7NvRMOis2gtFkgT/XSUv7VzYCKlH?=
 =?us-ascii?Q?DGYF909NOckgflRlWmAkjHScYGnyB3KJWgwzLMHPdBgOzoP+04eUTQk4ocTH?=
 =?us-ascii?Q?sFNG2WhfC86STYaG3ctJk17FSGyAMT1xeXVZQuRvGVcjitcQa7ie2/vXAn8o?=
 =?us-ascii?Q?23guvaSQkwjrnnL7aLX0pYhhlNZpJO9qZiNj8JXwAkIOqRm2/3e9wtLHbpm4?=
 =?us-ascii?Q?IKghTztpcze7i5G5scQOjh/oHnR/PMSG/noKJZmbZi8ddwTlhWkiM2h4/WnC?=
 =?us-ascii?Q?yilOWCR1y0o9WWJgM82FS4yFEFVomXnUfpyI/j4aX1am98Gw11sUvcszfL+M?=
 =?us-ascii?Q?hJ/Q7VRpbQco93G/z85sP/2eRFG0Y+6VoCAlab6iqHcCNsdiWhKetWmWA54k?=
 =?us-ascii?Q?kJP2DTKGvpWGAzvKjHTETbAPK6Pp3BVOHBuz9kKdmJhl76Zmb0OhLUEbdlB8?=
 =?us-ascii?Q?CJSXaTXihlmgCy7tvjHWLJ9oRKnU+5qhrdde/DsDMQ/9XoB2EhELwN9RhDK0?=
 =?us-ascii?Q?Hwxr3TRBjMgaiG7/H8kG2fRG0kYzEO4V6BA1kCON4EQHKWKc67eVEO095kbE?=
 =?us-ascii?Q?Uoup8KsGYlDAiRRMNMylSjgiNt+9HfeK3mWRp2rSWzeeYGBaVLdPFkwEGRGF?=
 =?us-ascii?Q?aSTiYj9tc/yZg1/91iKZ9dm7c2ILvOU5bG37UIR3oMWyCbFTsDt0daKKGYZL?=
 =?us-ascii?Q?naLAh/K6hczSm9TlSwbFOiTIBFGhVFa02vdT1+zNJ8+6Uuf9uMY1IE7kHKKq?=
 =?us-ascii?Q?fToN1pnaiWXCKQGFntQaQzE4RoXKeK6y6jItAhq8S/pL+1/Ppc6o4nhlhlfh?=
 =?us-ascii?Q?OI++MhUgrLu89+P/FRTd0YOjRwT03volEcIDmq3R3l4hpQr2tfurlybKtUoP?=
 =?us-ascii?Q?qGtXgGKHPNrisDCrP5Gk75kkchw8h3x6C+u3r+/fK4ZrxswnDiPELk4bOKw0?=
 =?us-ascii?Q?GwvVSxnANATbz7RfIJNtpfGhNuORvPyzGvVJhfC6sc4XTTDVwDxwXkjy5tNK?=
 =?us-ascii?Q?7xtJGbflIiLHWZ3SWJVbvw2CG7R8bt97yW7bCLhFIJujQD5UqKill9sAdEYw?=
 =?us-ascii?Q?UGsC7L4pjMju90TkK7e9ilDS+elDhhR6bTRZdtdCMPytUQzPERSWDGZ0fkZ4?=
 =?us-ascii?Q?EvkB3CfRVUtP899OA6xOTBVJ+/fvqRPoLZ3ltH0U47hXk5X3pdN1QdtVyriT?=
 =?us-ascii?Q?xRgGP02M82WrYmW6gwoFkpzE89y33H0Vm1fuibOGPVJmjUtClo8Xzd6dAulO?=
 =?us-ascii?Q?RmI5m5gdbYW0Xuhnvnx5uxW/MFPYjb+iI8xhzkMB5aAUFvB1zoKpNB8evgDU?=
 =?us-ascii?Q?N1qSa3jqLksf8UK6K5l74NMTiHLnW3zZiRVgV3ti2ZxQCK/uU0ltcq9If5fM?=
 =?us-ascii?Q?RsmMRJ4IVLt7CY/gtNfEY08N3sifpY23kec4rBSx51ShWWfDNZysdUbjF3+O?=
 =?us-ascii?Q?KfO7HbghMVuAuC9IMWNPf8qHD2KEMYrxZKf+rAPPrmUan8mI6SgaThapvAV7?=
 =?us-ascii?Q?Q1t+LR4aIQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: TLUNGmtw5ks9nMu3DDpZXpWoFpzaMdJYkGy6Dk6qT4NT77RsN6/xAVOmZm1GAiiW3zZR+QcuoXzSd7Wak0/0Vz/N4YfF6Nx9ZNI/XZzhwZRDducHRj2y36DnKJgFafv3v1a7RkT93EVcuxeD3ojX84kdGZZHjBNEN3dafeW2Dwakc86LXEXctI6OfRNXQCyAThKVjlWkPDNh1d5fMdwdMcB1eejddi+bKntUuFBPXElNX5woEt8e2jh0nIxgGFR3TwZf4nLJEnIjIdk+qAyd1SrdStghgzhzclxpL3La+ybzE19/p58DDiuCwCmuk+6+l0GvNMVkq9CkHFOkyChP/w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc940dc-36e7-4599-657f-08dee8472c43
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 23:15:51.7785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8d6KPowc4zsSjxmK0+SQfMTD9Y078oUIGwPMpOA2fQWRe+VV/qSi98S4zh6wYVExyYxGWIyDZtpTMxLUR5UDHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5083
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4F97340008
X-Stat-Signature: swrdeg9ig6neajdktag5dca1dj4ki9re
X-HE-Tag: 1784762156-696254
X-HE-Meta: U2FsdGVkX1/TRzEfgvl1V9l35b6bKeJJiqKoyXmHMf6r2DC9iyqeCBBhwco67ptbqkgrEfqHocv8ryzPFxc/70EV8h6TNi7xMZNlyoMha05zkrZtrQ6UeK+9ZgON0Kx0lKWmEUXUx+wwicolDOaLFKo3khSy09XbseRlug9+ajApV7EAifthDcW9RbYmYqCWdQgNvmyXZfgerFkm8mN9VSA5M3QGpF3Kq4PhVI+b/P0S9z1iQe4eelN++LqIdwk24178lIETlHhX4PdlVA1dqqxCXLBvg2jnPYdFvcgyv31jBPXBY42pk6FO5WVgvs1ol4uH/Fd3VHhXY3eQY3frZVyqBBQlggxvmaptsY6BmwGfqNqNVdM3FmyD0LxQYxUYUBlmkBNSQvFskOvXnndUfhYP6ybSyjRfX+widSwkJ5WbT/DDwGY1wJgfi4ewjbqadg0xa8HUskDvz2mNzKdvNZRNiZEN+t4Eq6jv3MPSUoznvOH3ngaiPRhgZ9sQmUv9Z3KRzejJxi49a6eEx1gszTF/ub1bCjMYaFWzPUJVKvuXF/dPL0g2d5ngD9sJ/3mzqzwMq4FKKWtPwIEq32YAjUNrYO0ywivqPwIF40Xg6oLqTJquBYRN4wVXFw89B+5d335e6WTOxibOvEPT4p3Y3PP8O/LwYgwtNe04CqFZQS5sub+XXLpO1e22yiW8mPy6Ctz9DtsZ9CuJG4YPBcJCM0DsZSpdUjaxH7Ya1TM3aHKqs1+vzExx8BftiEZK2LMcM5bflU/AeWc0gprwYWSIBtXInm/BXhYmVxrzRA6qRjiNQoDfQphyJalxH7gTFt+2BPzhLSBzwnh+iMeV1y3px8InLM/dGxhRBDvmFf3XDMwtvxva+37Ft5CkIBXokc5vfw/+7kRU3+w8xxNJ1PlLV3T8cNzqEqcyfXlKCtxp6DuAXinlJDNBChyYHqCTYwQJd4SxQykR6gjeEZabxpB
 0AtjuJlO
 vWU1iiYt5KoNiCUUaX3phuReuRcW2deu3ewUtWGvoJ3CAERkn19IQ8jXu3fvdJrnCpfNtZB3Qfguk+Ela70IpURcFQPmX+8oSkgyfT/DRj6v02OXFl2MGaPjIkGz36BB5P/bqVOyzsdArNHRnDqhFHakOXL/OV4iSG3a9L8bWN90rzV+gy7jirCWV2jzOy6Bnk/euzkUiN/BXjsUCG6bilNT8eFfsvUOHlKZdAc8CC6h1qjYvUwGJQ82h7/2JXmGx/uItn0ma7dkjwHjnd2gRJQtA9DGCmXBmN9OCw/ZSUX5hDcGn30LgHUVtwab8/crcWza0c7mQWzk8aRpOCNv56f9akCilymR0BB+13aOLvq6UiS8HzkPq5X5lVhapB5VI8K2zBbV78nB4zp9yD7hA8xSdw0pAVE/oCJVBrad51g5qRhwT2QSfTXA7M9BUzCm1RUxd/pCbstX+ijbH8w240ws6opYHspcEsEGxftARyMNP/0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 03:56:05PM -0700, Nathan Chancellor wrote:
> Hi Mark and drm and mm folks,
> 

Typically to get drm_pagemap.c to compile on various configs this is
what is needed:

109 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
110 #define HPAGE_PMD_SHIFT PMD_SHIFT
111 #define HPAGE_PUD_SHIFT PUD_SHIFT
112 #else
113 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
114 #define HPAGE_PUD_SHIFT ({ BUILD_BUG(); 0; })
115 #endif

So the drm_pagemap.c code could be:

-#if IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION)
+#if IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES)
#define DRM_PAGEMAP_PMD_ORDER        HPAGE_PMD_ORDER
#else
#define DRM_PAGEMAP_PMD_ORDER        (-1)

This Kconfig has been around since 2024:
git format-patch -1 b979db1611a63

Would it be better for everyone for me to change this in the DRM branches?

Matt

> There is a semantic conflict between commit 04b177544a04 ("drm/pagemap:
> Guard HPAGE_PMD_ORDER use with CONFIG_ARCH_ENABLE_THP_MIGRATION") in the
> drm-misc-fixes tree and commit 0b6b1bb28482 ("mm: rename
> ARCH_ENABLE_THP_MIGRATION to ARCH_HAS_PMD_SOFTLEAVES"), resulting in a
> lone instance of CONFIG_ARCH_ENABLE_THP_MIGRATION with no way to define
> it.
> 
>   $ git grep ARCH_ENABLE_THP_MIGRATION
>   Next/merge.log:Merging drm-misc-fixes/for-linux-next-fixes (04b177544a040 drm/pagemap: Guard HPAGE_PMD_ORDER use with CONFIG_ARCH_ENABLE_THP_MIGRATION)
>   drivers/gpu/drm/drm_pagemap.c:#if IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION)
> 
> This results in an objtool warning (or error with CONFIG_OBJTOOL_WERROR)
> when building with clang because NR_PAGES(order) results in 1U << -1,
> which causes clang to stop generating code for
> drm_pagemap_migrate_to_devmem() when encountering unconditional
> undefined behavior.
> 
>   drivers/gpu/drm/drm_gpusvm_helper.o: error: objtool: drm_pagemap_migrate_to_devmem() falls through to next function drm_pagemap_zdd_alloc()
> 
> Mark, could please apply the following diff to the -mm merge to avoid
> this? Obviously, there will need to be further coordination for
> resolving this upstream when the time comes but it is only an issue in
> -next currently.
> 
> diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
> index 4a794544b7dc..f00c27edbfb9 100644
> --- a/drivers/gpu/drm/drm_pagemap.c
> +++ b/drivers/gpu/drm/drm_pagemap.c
> @@ -12,7 +12,7 @@
>  #include <drm/drm_pagemap_util.h>
>  #include <drm/drm_print.h>
>  
> -#if IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION)
> +#if IS_ENABLED(CONFIG_ARCH_HAS_PMD_SOFTLEAVES)
>  #define DRM_PAGEMAP_PMD_ORDER	HPAGE_PMD_ORDER
>  #else
>  #define DRM_PAGEMAP_PMD_ORDER	(-1)
> -- 
> Cheers,
> Nathan

