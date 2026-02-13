Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75905EEA876
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 02:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35586B0005; Thu, 12 Feb 2026 21:31:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2D56B0089; Thu, 12 Feb 2026 21:31:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6FB36B008A; Thu, 12 Feb 2026 21:31:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A7D3A6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:31:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5AF50B80C9
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:31:25 +0000 (UTC)
X-FDA: 84437856930.07.9167A82
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id C9BB3A000E
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:31:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WeECwKfX;
	spf=pass (imf25.hostedemail.com: domain of philip.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770949882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQickWG4LjBZoIt9xmBpZBIIYFa577r56QRpLUsvNZ8=;
	b=GymGvXHhbYT0WjVZyRepZoLqxaahClfP1lgag3w6JHlEAy3m2O7QbAic3T6C1lfxmDCKR5
	rhgqs7I3mRaNeunoWKkqdD5XB1PxZbp8lGLRiUcVReq7igpza7tA+30MTBKQOtvxoJYHIM
	0OMBpoN+pMtWykxnzUZefscVajow+aw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WeECwKfX;
	spf=pass (imf25.hostedemail.com: domain of philip.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770949882; a=rsa-sha256;
	cv=fail;
	b=O4SMUl3LKQztsYyUkw1h2JnGH2K/vpZT90lE1R1eNepgGKtLczB8ZjR88MTN6P1kjvw5t/
	8YjEzvMvvZ0mheULnjlm/L1/bu3eyFKMs1hcP/zcRqYDW87fc5kbrSy0vZ/Q8k717wfVDJ
	RXMIqMS9G7e4qtO2IrHjneYTDIJ1tl8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770949882; x=1802485882;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yEd8uDwqnOTMwbeK0DqR/CBfOn8umVPuYmMPn7ExBHs=;
  b=WeECwKfXxL7aZazBbMZEjx8GaIT1bZA3VdjuH4aDlDZ8xfpQdg1HmwnM
   Xk2NE6a7jYZ4sxiD4PmwDiVRx4JFSLiab0YzfIoG+ZJL8kF0wZStMbeus
   sC3JWDTgIBj3pJF8HWgsvYBSRCmhh0Q0dNXFu/5BLaLwrky426cZFZQr1
   raKnrzg1R3BpRN/FPlHb+abhvKfaoUL6kW0h3MEx+4U+rJWcTRd3sk4Mh
   3mhiH3TVBCDx3gL6YlT8aG01Z48cynPLoDfxaI0lqddM0Hffivhsy70to
   Ch3YCmJScqabvhh4PJacof5LbQJp2veOIpg2fuSiqadiqB9X74uPc2BWU
   A==;
X-CSE-ConnectionGUID: rgOXpcdQQxmAxp9HCG0DpQ==
X-CSE-MsgGUID: 5s2bUFk/TB6MEGYMy5vIeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="82459285"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="82459285"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 18:31:20 -0800
X-CSE-ConnectionGUID: EYdeWoO6Q/iSOOd+DWIitg==
X-CSE-MsgGUID: ogTl8K2tRQ6Z2MrwxXO48w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="211883366"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 18:31:19 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 18:31:18 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 12 Feb 2026 18:31:18 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.61) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 18:31:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y8xxziHi3OzUniHJaBptJL5a0866FFZp4ZHqhk5ZMeafPopGW9eYmK0ikqFz6qIeG2TrlMEsG1f+/P2nW0BzieM5AGm2amK0iDZtW8d9FbieRyBFOochL9N4q3gkWkKW8VyeNUBYRiSnEJC5pBrKjNpex3ey5R/EuGV6AZuc890ypUOOJ+W7C3jTFyrJFdqEk7seLIjSBaeFcb3xbswlPFH0x4zAV5GLo/KfWAOnLP473mop21VzOOxY1sg8yGkK+EUlmZEgwHgZrDEL/CkiuSNnkHuuERMF1lUXpNz1e2G3uyvN6JX8QkpwmEXvY070T+uIpH6GcgrC16Cc1JCXCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQickWG4LjBZoIt9xmBpZBIIYFa577r56QRpLUsvNZ8=;
 b=Sxnbt0bZx4sAubS1GKxP31LMv5dd6zLqeHNGldpGv5TTQ+cP8HdO+ubcnouYT6jHbAKoLZ9Fl1eFJI8JN86apbgPcYSTCJuGv6Mv7Q1/I2dQtQvP/x1Plou91Vri3omoda6/ZuB5lQkurcbdiADTngbfAllsTk/WcJ7+pH0fAzdHPdupjU508wtyXpNKmfhBHfGmRNiEm7M1Oo7wPLML33axn2Jwi2mCLkqAcfkLT2s/coCFMYS/u7dILhSNfEyK/2Hk8EJsezbJL10Q1iNIJYvn5ICsQIkLV69o1TpwBFurt09TJ6R6boeUzFA9vRD8Oay77NPCxX8MfRRk7PP5Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8468.namprd11.prod.outlook.com (2603:10b6:610:1ba::19)
 by CH3PR11MB7895.namprd11.prod.outlook.com (2603:10b6:610:12f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Fri, 13 Feb
 2026 02:31:16 +0000
Received: from CH3PR11MB8468.namprd11.prod.outlook.com
 ([fe80::8188:d688:bbca:2394]) by CH3PR11MB8468.namprd11.prod.outlook.com
 ([fe80::8188:d688:bbca:2394%5]) with mapi id 15.20.9611.008; Fri, 13 Feb 2026
 02:31:16 +0000
Date: Fri, 13 Feb 2026 10:31:07 +0800
From: Philip Li <philip.li@intel.com>
To: kernel test robot <lkp@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, <oe-kbuild-all@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>, Finn Thain
	<fthain@linux-m68k.org>
Subject: Re: {standard input}:44576: Error: pcrel offset for branch to
 .LS0066 too far (0x3a)
Message-ID: <aY6M64oN18jYa6Ik@rli9-mobl>
References: <202602131056.yW8CcR2i-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <202602131056.yW8CcR2i-lkp@intel.com>
X-ClientProxiedBy: SG2PR04CA0170.apcprd04.prod.outlook.com (2603:1096:4::32)
 To CH3PR11MB8468.namprd11.prod.outlook.com (2603:10b6:610:1ba::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8468:EE_|CH3PR11MB7895:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eb3737d-7849-456f-61f0-08de6aa7f687
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?pzi+J2kXyMkNPXAzeS23KoqO6ysNMvDGAPphv9vdN4+QAWEaCJqFOXhXZdo0?=
 =?us-ascii?Q?bGrbkKXQsxE72pAnm1e6TVbcdRt+5Fxr3cIYbG8E2L0Z2oCWaeIWcIpSBIhl?=
 =?us-ascii?Q?9AWSrGb2MHnASF4wJzGNS6sh11aE52hJuU++S3tn6SHpmeKQ/Rzs5umTC7Vk?=
 =?us-ascii?Q?VIiZOcOEzz2MBRrowo0c6tvzauH5n0dTjdsbcuqiDKEkPPZf0u1W4Vlq7Hsi?=
 =?us-ascii?Q?1/uOcAuWrAGj++Xd3/NQWbA9Mf2AvJWvhvXRoMmiUXthG5O25NyL614T2Lo9?=
 =?us-ascii?Q?X8mImbDHN6kk/Ho1YRs3sEPvpS2t7bXA6OAHoMk9rdLfI/qOgLyOEkTjMU6c?=
 =?us-ascii?Q?+pVmdMMC6vil/koCQf+oEEh8EWRZoAdM0uv6wdxo0ITPQct2QmGUcA89iWMx?=
 =?us-ascii?Q?aHVTcwXgbFKt3qNdV0LRB6L3WgXwcwLDkqGb/Xl5Z3gPKA72/ffQ4R9FvoPK?=
 =?us-ascii?Q?qIwGxbEYX6wgBmSYZazwfaqLJTpbDNFo98DRRcHriYKXS9MvxZ/Iw7WpF5U5?=
 =?us-ascii?Q?9jeEKFpKd2Z7GWj+G2XfonYK2IM94unz866vVe3xYqKwJjVWHzrI72dCltR4?=
 =?us-ascii?Q?r1DYvPxbBoaF3jjfW2osEMEInGMih7UVkXw6hXzXUjSbzscoOtXzVaql2nl0?=
 =?us-ascii?Q?1ZPLVArrQ0/VvgUwJRDSiQ0AFoMY2fT1PzoVZngS6BLkgaqUsNXty94WgaQr?=
 =?us-ascii?Q?eoaUZUPiioeZn6OhUUIfQydHB1/QdYlw69iHN2UiCFccPl4RGgMlA9VgxfJ2?=
 =?us-ascii?Q?CpswzSXMXtAVhI2X/6mDdRNpxCfYvNUtX1wHpdAoOYMf51A66spHjx+lvi4x?=
 =?us-ascii?Q?Y8f1BpajmHw2UqCAef2nHyts2aScpUYhKgtDulbRqP2Utd+7Ln1CgSDtMc7p?=
 =?us-ascii?Q?IfrTdq0rbjCxpIKkSzFttdb4yVVmFVMX4HihM9DZ/1bPw9Mbbe56ENLtnpg+?=
 =?us-ascii?Q?ao2RjKN4IrvsWvqjQmabIIzmpusffM5MjUSGt0sM98h/fh51xFKf62D6+w51?=
 =?us-ascii?Q?y9V2pqvQOgC9wiKJNpTrIS7Qn0shRsW8U6D8HhIV0lhK8VE0ir/8q6bN8S0n?=
 =?us-ascii?Q?+FuXkeEYnlEJLhjpnME+oy9cQZtzjZW3ZBKXsUTIoyWF/xRFhEnyc6p/ly/A?=
 =?us-ascii?Q?7+rGpyVixCUsGbP351EG4kX9gYf9vzk9Iv8WOVQSSCBX4hPx6h+J7aX1EmeD?=
 =?us-ascii?Q?8/iAU33rPxgmZjqbCOGKDi5SZN2+vk/sFAiKjgG0fXdvWIDLUg4SIewSkXXi?=
 =?us-ascii?Q?N1pseyZiRNNNUkw+mtAptp2NPIc6DnTWXgoDNhO055r+yuMP8mFNBv1ZQFeK?=
 =?us-ascii?Q?AoS3aBN9jzahIcwYYGrykXs9vlyIEt/75UCLQcveAbsFGTqsvBR/0s8Z2FOS?=
 =?us-ascii?Q?ciMC0ZT8Qe3F1uVcjdnhIdjqjIP56JBkydQIDEBERQi/1QijKaWSsEj8UGor?=
 =?us-ascii?Q?zsDtIGhZBLQ2p1v+y3Vre4xoNmun0Ac5gPVuDe0WlU032sREMp9M3yaE4RxM?=
 =?us-ascii?Q?LOiO6dZHiJ+iBZwMLOZ7gN/KH6ckofGA3ITuSfrp1TIunZ8CbzPjIP/ViPao?=
 =?us-ascii?Q?k22K9e/2n/MoSg2rf/CjO1LbbO1ptObXco2l7qXO?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8468.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cl60rCeXry+9bKXB8oufA8iEszif3f1O0ybDycACA0T/2WHJuV0m8QotVc6Y?=
 =?us-ascii?Q?7jhMcnemD3GFdvIBx1DkfNDKsv2kToHJoWtjWMeFb1jUW91rJ4qYFZAb0Dl3?=
 =?us-ascii?Q?7zE5ypVpBf3CnWn5NF1zgt0xem4WUdHik+I8dKL9KuEvysbPuu8x3/ATbz/i?=
 =?us-ascii?Q?PhT5uGSEtMrOjO7UDIIeNGpfWkIcrctYWJX5trhD3zBAY0hDfzMo2gPiIGgt?=
 =?us-ascii?Q?BlsccUisJ49eAnusuu68W6gL+teRqSdbzkoLiG0a7DagUBqTtA20zceXgIkN?=
 =?us-ascii?Q?dL0LCDbwPCvP8kiRMyhIdrJnGNgFFi1UTzaZH9nk5L7EzX70TJvvG8dri0kf?=
 =?us-ascii?Q?Fdn30ckhW2vgzO/H4vN7x/xw0/fyFEQY6gN1s8T/hdAuwRvCUIh2+QeLh6IZ?=
 =?us-ascii?Q?2xK+4A9QLzt2kHFzvR+LpdPuIJCV4jhd3JunCyXBGEXq9YqDzBWJVfDWaW9t?=
 =?us-ascii?Q?8PU2NR34mkIkXSJfJRUncD+ZFqgNb46xIiwcTR5e2fTspzwgc25euWsTDz1Y?=
 =?us-ascii?Q?fNGZbvYgtMTW9EZtgAdAV2GQ5FH/OncTjY0lVz3SrFeKmHq34EjlZM2POur0?=
 =?us-ascii?Q?zICzy1aXl8sxfHySHIoL/rI57rU6LSiT/VfXl0iBnT0nIL7WnqiiEBcGFztM?=
 =?us-ascii?Q?M2KokuFYoKDj7P3X48hdnIXBKtZjhEyZa1U4kcFVS+c7Z1hc9uzUdBevzTSD?=
 =?us-ascii?Q?Cy1MhKTamCmadvQFjPdPvsHfshdVb51GW8PPA2oq8PJ4LJq0pEkbvzfPVX3y?=
 =?us-ascii?Q?3//2f2aDffB/lKYFa/1yBQat9N19JU0uOgjNegwBpZlF4dHpK0YGSIixS5MS?=
 =?us-ascii?Q?AIl1bzr6DeqJu4Q0g6HJXbDGT2jEgaL0IhkJIYuXjP7dUssn9PBPuWjOGrqq?=
 =?us-ascii?Q?HzTcE4KJVCT3bj3vyU/juQKJ3BV7t0X8A6AsA9x30pY7P7BykiyOxhTj5F6W?=
 =?us-ascii?Q?E/+qNH3hjrw7FBDf3YA0uiwfHZZNYdeQsIAn9RHwzKSHguqcT/0w2UOUZ5pL?=
 =?us-ascii?Q?7AyZJUO7Pb1sAGyWXhGg1LC7QMQ/eMoihsE+n/IuD1vSC+Z3+dazXHZWdXa0?=
 =?us-ascii?Q?vnZLzHA0xYpS1rM6ywQ/C70BhzUARCqa88P7E/KItVxZ9tamxQuNky+AuvCS?=
 =?us-ascii?Q?3s/M1tKmS05JnshzN+mtsb26LD3qGRIGro8XS3PTCB5qo1DGZcofL2DaW+kT?=
 =?us-ascii?Q?My4g9Y2HRGzFyIVj1aagFF9+tB74XdOQosmIaASei7QhWzd5FOSvzLfnxyR/?=
 =?us-ascii?Q?6iC5b85J2i6IlgZ7XL3TKrtQ8Oqa96aWqlcUpd9nErcS3USIbBm5losN1gFV?=
 =?us-ascii?Q?l7NYrYsVQaibaRYUH5c1oEUgs1wAz1/UYtDIIRZLRDjmVQZtrVNlmc3S1nPa?=
 =?us-ascii?Q?zNLFyO4uJjMMXsVmIwDZxzHxbDXUD3WacJ2P29RCp2x8K+P+RLsX/lvt4Pd0?=
 =?us-ascii?Q?gQQvdEFrV2BPVC3T8rUpZ35fbHCyNeOlKwFPBCwYutNZ3iZtaeEKJAvBduW9?=
 =?us-ascii?Q?fUpQLKAGGBfS2vONDd/7nG4PFfrDSgbUbRLb9l5pSsIl/Ug1bd5nkLoj496k?=
 =?us-ascii?Q?UB7iC0VLlagKx1a5LxaKmZ/uPmFEcj/e5y0liibrrvJ5s79+Wb/GcKW913dz?=
 =?us-ascii?Q?AJOBk+MsZVnGZvB2oTDVieEfXpCGsqck7hFqfzuGLzvKj0Zca4irwEUB+vOo?=
 =?us-ascii?Q?7eljv5WGKY+sl7nm43Bjtk3bwpomCCu9OFvjrEUBE6+Htne0/aw/Vlskmrda?=
 =?us-ascii?Q?ryNCEsnSiw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eb3737d-7849-456f-61f0-08de6aa7f687
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8468.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 02:31:16.4420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 496tRTG6wKHGcmGii4Em2gtDQjBiLFJAheR3aEt9zOad2qyMwE7y33wJ++sY/LAeAFYkUOcpg6Jwd+3CKTn2EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7895
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C9BB3A000E
X-Stat-Signature: nn8nr367hd3z6a1u3z4er75fgb4xpnaj
X-Rspam-User: 
X-HE-Tag: 1770949880-232536
X-HE-Meta: U2FsdGVkX19hEFJ2rX9uLKgZnh6k5Ccy6tFCVjknT51Vu6BbbgGVtqKusqhjqszirBesvCniGunuetm2ODfLsziw9WMuQN3R7Ne8cHreL/op3AgE5XFQMrJzZ0Bu9eq1nwYiH32IN0UoCfHTHfzJ68ztS5OrvERMIDx5Cv1wy9SG6cH/sG4fg/OvDY8b4GjD1DqV55o2IpXPpSOZfa5pMKhhnPSs23eDS1MTsc7Xge8msf9m+Q5JskRnCNOYOlrY9uVJ3YTof3iRkCgBStUc+/AdqLivSBb22jGMLe4UVNFUa3TzvjTzPwgCGTvozP2XlUut4ZAQHCddWbElah6au68I5rKiUStQD3bjwowUF0EvlDgaDhSITsZ5r3Gx24OluaeiUWSoX2zoXYZTBo1GD1c/aBFqAH+qwDe78dwGnkHy3kBOyBQOWFkkNjjDpmpOZLPA/mTwdBnSnT1whIBIEvi/b+vLb9vNfyXLuXaP/2SzYTNRjacL7MGJjlq2RFWDI7PsWVUs6su/Z5rpoBdDzIl+zrF88SswbFpxlTHWSOX7LAjqXT6ZwMBi4xAGnIikJwv5H/S1rPcZEwIKZLSURlBi+l9OAUDIpDT0rizzG22obxK7R/B7uKrrvExszeqwgYCB4yMtGIPM923wH/zmVrqm98rHLqtlwiGV662EkOjS2TsCpwXNpBdT0PsaS09s6pNuaH3y2McjOJibtFZM7Tx57VKR/ciEk0XORkPQiskx+f82z+jyWH4LPy957eBp1oW0qmuXrPq8pQ3L6Rt1F2Hz08lesy9k/Na8giwZRL+jh/fxIWg8nppknrAFSLIBqjTTPlomLCOGn+gcUVnmoubocD8WtPZTibqsx37IK5gjR1GcT11uzIPosLq4Db/s9S2LilmBdbeaYk37UdXm1+DfS81HVFRkZ67Tnhkmru4o0N4zf9SqM9kj+StBVHhfBWaRE4bq8lYOiguJ9lI
 LWyNTypR
 jQMRbUH59VktsRV/H6u/Rp/ncPktmIU2kRywF1NWEQkRns+Qkr1q0dB3FkE/Ipg1zrj8YaZvMm5Pf7qHdajIRo1uu9poxAjprfuJlVwNH/qOcq40MsH+A0NZ4XxutLouw3FioDRlkg4MNUIRpq2BmgyPKaV/ZKb5CW6tX04P2Nub7aJRHeUCE+FBO476T4Emagq6X8sjNApPrnTmFaxY+j2D11YYbWEogliG1MHIYoMCQ2iKEQx/zcqBGlZHLqAZVMQgktMfe9XAjAE1o24wuoIo5NlGSKxUchWzDRz3IU+ailRZzC/0I65y8waQVDtfmrcZ4l90tdy9KjhLftTGjYf4L4jSA4x3hdQyjP/UdxdYLMFYsjtok7cSLpmDPeg2B85n1OdOQJpL22gEMCGIRi8CXHeRYyJtqKfYQxTg7RPX8rmeGoxHBn6GO9SvSZR71Z2dogSVghOkgHI5LtG4xwtXUEvbvj1psKHzrSd4y5IZKWo/WNIcrPlQwLvRKFFfHZsMP7CPBKnChrEp2mcdy2z4OvRs5J3BGG37p6AcPM3cN0g01CDRqxnDIGsAHqVqw5WVBssnfXOSzkUps7K+/7+A8TfVcypD7sA+QgFvkvNaatKZcctIrz7FXZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 10:15:04AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   582a1ef360a05bff4350bbf6e383f61d26b804f0
> commit: 80047d84eed25e9c92cfb9169980a0dfec110246 atomic: add alignment check to instrumented atomic operations
> date:   2 weeks ago
> config: csky-randconfig-r071-20260213 (https://download.01.org/0day-ci/archive/20260213/202602131056.yW8CcR2i-lkp@intel.com/config)
> compiler: csky-linux-gcc (GCC) 15.2.0
> smatch version: v0.5.0-8994-gd50c5a4c
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260213/202602131056.yW8CcR2i-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202602131056.yW8CcR2i-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    {standard input}: Assembler messages:
> >> {standard input}:44576: Error: pcrel offset for branch to .LS0066 too far (0x3a)

kindly ignore this issue, there's some discussion at [1] [2] that probably this is a
compiler issue. I will configure the bot to ignore this issue for now.

[1] https://lore.kernel.org/oe-kbuild-all/dbed961f-f3c3-496b-9498-6821852da038@huawei.com/
[2] https://lore.kernel.org/oe-kbuild-all/aXDzPokjHlJweiBY@jlelli-thinkpadt14gen4.remote.csb/

> --
>    {standard input}: Assembler messages:
> >> {standard input}:16916: Error: pcrel offset for branch to .LS0027 too far (0x3c)
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

