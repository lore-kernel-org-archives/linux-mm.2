Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 208F5CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB278E0024; Tue,  2 Sep 2025 11:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BE518E0002; Tue,  2 Sep 2025 11:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38FA8E0024; Tue,  2 Sep 2025 11:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C69F38E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:44:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 706DD84DB1
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:44:50 +0000 (UTC)
X-FDA: 83844733140.22.1DF0A14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6A67F140008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:44:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=E3rf4mAi;
	spf=pass (imf26.hostedemail.com: domain of giovanni.cabiddu@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=giovanni.cabiddu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756827887; a=rsa-sha256;
	cv=fail;
	b=UjvnGs2adfrRL06uxVNY4XJULaVhASJ6eDKnbLASDSDb2qP2dDA8sETOsz6jgAK3ZNGRVZ
	zxehG5d1a0VBJPQ/5GniaLuBpbsemrZS+1aomF1KRiHBRNDo8FBfXZNzVe/W3xXbf6rS0b
	LeiCCM3Mn7NNm0l8qr2sOD2vgEPgG8M=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=E3rf4mAi;
	spf=pass (imf26.hostedemail.com: domain of giovanni.cabiddu@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=giovanni.cabiddu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756827887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dd238a6sUyHmoQRnpv/+oXzIo3ZpIXCnETBr2et3mIc=;
	b=Rtdtf8R1b8qWnkUeg0y6QxbXr9+CFC8I0klytuB/z/6VLRtyenV/rbcUWGJOUThp54oKP0
	ImPM0QdiAe5Jzy+nlubTWAtC7NBExFmabOJLtTrbVMDV/DNVkwByp6ghkicaLtxWylXVfc
	sn/I6ejLpq62k2KoZjz46Vi1N8+S+ak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756827886; x=1788363886;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=O0BAwJ1+Xp8aiaxma1ORYpfaP9lhzDv8t9POm9dFKpc=;
  b=E3rf4mAis6t3EqC7+/ECUxElTxvDfFerAXNfDiP21SpIBBhe9ihEP3l4
   CawdNpTML3fG4eS1Ad5gwp1292hO/+80YJGOU+SZoXDpNVZp/SiAhWITa
   s3vIp9nkB5dw0rxRnv+JGRx1IVmrkHWESADYhDCkx3nOTpkeJQcEooFWW
   7OesYA3yblQtBgye+BqBYyB91mG/O5rz3chkvgbJSp2tUl2xMPMhdqzkG
   h5eTK15hmMx8S/u1GCxkTLLC5VHZ3ttRuPYvQ2Pruqzhm26MhLil6xia3
   Ink5F2HvY1qSibqZa99XSBMsodue0JplwdcgLh8eW0A+hrznNJTAQ0nxF
   w==;
X-CSE-ConnectionGUID: XlTpJ+qQRXG3WBgMB5qy2A==
X-CSE-MsgGUID: jhJgyu3yRRKv3rjkfJJ71Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="62929418"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="62929418"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 08:44:44 -0700
X-CSE-ConnectionGUID: 8VzCUmJATi2/b8XHh11GGg==
X-CSE-MsgGUID: ytUJh8ubQoSECVhaoZRG3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="194957818"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 08:44:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 08:44:43 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 2 Sep 2025 08:44:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.67)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 08:44:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JFoBI0Ytfbq0Xh9BZ/H0ii16gtYH5GS9rdS++tIdQd9mYjKeMFWazVjNwmlLHU7bK3wxY9Z/CJkz98fsXdwWBOQRL6pJaRig75P8etFTrO1cs7NcMyjTeVK7kohPE6l4lPB+SicwfVXrJConb6rTm9FfVPfHMkk0ZX5Qo2J5PLchqkvyjWzVy+wC4IQnLTN0g5H/e2KNQlSUeAiCmGMck6askQMY46a/gQyLR0AUxJn4n9Q2UJH2spthp0yobdHyUzUEemNfr88JoMxdzXmONsLGR69cjCJTyRVK5JLyqkvcJMYjBS2HBpsnO/depoXr+xJ2vgI889GNzr5dOTiqNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dd238a6sUyHmoQRnpv/+oXzIo3ZpIXCnETBr2et3mIc=;
 b=d4bDFEZzYr5X4ulvMZdvk9jwOaajTh28S1xGvCGZVKYGi0vmChj9wBNQLnUrP1u9cQzScMEgE2icqVWr/FAiYwgkWG4M8N5+FTedKejmVyFrsFjWd5IYdov/NX5jIzGjLweVyyvcd+h/uFVE4zz8gSTG8ts/X1jLs02x1tPMZlMW6TczrBCrJlfU2hTFoQRkZ4D6+jm2YPQxQyGmi0wwZYT2ORsgEyYwRi69bkkW1pFEobF2F7AqwDaMqOtPW0aW5rDRoxR+UX2/y671/OZLM1zIAJKTwF8PNpD2rGJM0LvaMK7M330vYq3F9eNm+IakX584yLPgMi0e+MM/JnC4eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DS0PR11MB6326.namprd11.prod.outlook.com (2603:10b6:8:ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 15:44:39 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 15:44:39 +0000
Date: Tue, 2 Sep 2025 16:44:29 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Rik van Riel <riel@surriel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <bp@alien8.de>,
	<peterz@infradead.org>, <dave.hansen@linux.intel.com>,
	<zhengqi.arch@bytedance.com>, <nadav.amit@gmail.com>,
	<thomas.lendacky@amd.com>, <kernel-team@meta.com>, <linux-mm@kvack.org>,
	<akpm@linux-foundation.org>, <jackmanb@google.com>, <jannh@google.com>,
	<mhklinux@outlook.com>, <andrew.cooper3@citrix.com>, <Manali.Shukla@amd.com>,
	<mingo@kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	<baolu.lu@intel.com>, <david.guckian@intel.com>, <damian.muszynski@intel.com>
Subject: [BUG] x86/mm: regression after 4a02ed8e1cc3
Message-ID: <aLcQ3UCXXNcByW1O@gcabiddu-mobl.ger.corp.intel.com>
References: <20250226030129.530345-1-riel@surriel.com>
 <20250226030129.530345-2-riel@surriel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250226030129.530345-2-riel@surriel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB8PR09CA0018.eurprd09.prod.outlook.com
 (2603:10a6:10:a0::31) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DS0PR11MB6326:EE_
X-MS-Office365-Filtering-Correlation-Id: 57f6072a-10a0-435f-5849-08ddea37a027
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?42wa1XBvCODpyPvNrooYH1VAJTkTVP53+7ndPqTFrsoSNoKnpgGsAmBXH2bf?=
 =?us-ascii?Q?KGc1hticyeTdKxUUH8oeBNNUQXzxt3yFe2cxeYdgMX9gIkk0fzkU+dtwIW4d?=
 =?us-ascii?Q?6A6uGP0Sx0OU6l8pv7Wf7/vMi0mq3ClWPR+SzGm2zkdyvYxFG7Vkl/37h9MY?=
 =?us-ascii?Q?IwWoDRUPv+LIr9yKq6S3tsTSqcnpETMLqtois6IKVBBHhUUJvPGEtg6dV3GA?=
 =?us-ascii?Q?gUZIh+EBIgax+0ExNCm6PdOvp+dPUpq9xODj+Ja/C/5rjDzchAEMCMh8t0KG?=
 =?us-ascii?Q?q03rS2RFkb6MubqgQuMf1W20ap6lgLiuYuugN0lttSiA2s8Dy7b3drzdEzeq?=
 =?us-ascii?Q?WRIuU6EsS2lZD8kV21t5VtuvM8LIq5pHF2X8T7v67oRce55di8uip3D0pXri?=
 =?us-ascii?Q?O1tvfF7ayf8tX9OaQaDz5UooMtbx4hpQvKN22XkJw5mRxmMriDgz6QWE01Hs?=
 =?us-ascii?Q?jxo8wRliQ3l6JSYz2nDvqTLrEZYD3j5I4pEFV7wbuw+wj9IFxoj0JeckhjyH?=
 =?us-ascii?Q?vrkDzFmvpDalt+EsBVV3hsFzkczvDpWsQKNLf23gZ/5s6zeJNEYm3wMcs8IT?=
 =?us-ascii?Q?2qHPSDcofwPhx2uAcM6XChypxLXDzt5U8mvt/XBwKhLQVEgL6w1N/BPs3dXe?=
 =?us-ascii?Q?ndGpotxsfK3UKMIlGaU+F6lVK7WwFln7e38FVKq4LYYgR7WfPT8abkXB+38c?=
 =?us-ascii?Q?FlhzUEQ7aAJh3idLKVgm0TWpeIT8JntF78Mv4YLACJUYO2j8zphaSdw1vlYZ?=
 =?us-ascii?Q?nPvLMG2TsJtk+8kn9Loc9Cg2/bYuqeKLeZ2okJgnQIJb6W0oiijskv380xjk?=
 =?us-ascii?Q?yT4a6CbXVXkElpXlvID89t3odVnNoZ+kbdJ/YeFvIa9aWOH67N0Qr7Gj2y+C?=
 =?us-ascii?Q?nw06xqAq9RaZjRpHv697QW5CdW706DwQwAC8ToniaKdix9R7StOf29BiudtH?=
 =?us-ascii?Q?c5gWd0m6X5gFqtKSmh3kAaBZNpQxsP+MiKuW2zv/dYFwLefVKMjsX2e77FXP?=
 =?us-ascii?Q?8/gmvXurnPWO75Tlzbbux2EkPU+husxSt5bwdvgV18uCF5aFNBOmKfLeeSuM?=
 =?us-ascii?Q?HGF39HFk9A//Xem66NGVzyCUPnJTJRr9/s1pUtMnTChiUg0vywGYA7OHAhta?=
 =?us-ascii?Q?1l2tCtOxFr/Fvtl0wWZy8t0Jn2Me/tMKp250YP32n0PCDrlN9M/rswUkoPhe?=
 =?us-ascii?Q?AJ7TfENSrzUz9/ANAWTUBpXgHmy/OjkFnf8qIkfbbU6wUEUcsVsHvjEdFp66?=
 =?us-ascii?Q?6FbuTGthmgbR49lYGFpy0q+WTF2d2xdVXTukJPaakjJ/5ctggXoLtV+0Ud7D?=
 =?us-ascii?Q?IlpLnUlyyizuIfnP+8bJjpPlkS4+bGVyF91ZbRIowQIkDQqI2a7ylC+ayIjS?=
 =?us-ascii?Q?TxwvVrt6BXNVwl7Tp6GfNjuRvTtize/DLAGzX3y2bUelICvo6hM1mPzrpn5X?=
 =?us-ascii?Q?/TRt0YroRaA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dLE9wmG+30aMOYVx55XmyWVNW1ejoL6EHpsGDznOQK0um8/yOQVPsbpdwJzj?=
 =?us-ascii?Q?TavYXtLISnsuKKNA7oiAhcEhOGN6+hV0jaqgSSB0qwP24F32EiWG7PiC/Ihf?=
 =?us-ascii?Q?JKQczatv4TViC6tZHAZqe8L+x+5NhWctJ2Soru1tThD5GlDrvjwhv7dkPV/k?=
 =?us-ascii?Q?rK4ouzdsHuhGHot6wPVJzRxJAGnDrN6b+gmpUC3oHYm/treQ4pYaAHBpwlbf?=
 =?us-ascii?Q?uXR24ab/MKRH5OexV1Gm2QfynYC95glb/A2D/QHgi8ZmJ+0G3Q0+UXeAy7D8?=
 =?us-ascii?Q?Oc1sW0TCn8DIlYUKcUQGSLt3RdJbL0vbdL+VxXz+B7w0fQEX/mBP/eXPfrRM?=
 =?us-ascii?Q?ePqbXEE0mQmrwmhJ5HhvUu9m1lWtR649x5jqJoPuqhUQdtADMWg/gbYo3XMO?=
 =?us-ascii?Q?bx8QF+fglhNyWw0DWH3x5iE11ZjK8Bc7OsTldbMB1QIDtgg9mmaVAAjequmR?=
 =?us-ascii?Q?tpuwJ7LpUxYzogCQCWVN/IGJFMVpeCx+laX7VbE5832llCVHdMTGclPzBcHI?=
 =?us-ascii?Q?++V9fZWdkgnJRb4/XsnX7CyzVea691DKGnP20F06H9OOBN3BtxeBMelBBdk5?=
 =?us-ascii?Q?WgvXUu35/b+BQsE+u1suR54cTMW2lPZ1B5LUhMsk3AHonHqx0IaAWoWiVscW?=
 =?us-ascii?Q?6rmNRZEawAQK745c2R+RzL3vsOcWHAEAsbIFt3TWNpno9R5ckW1h5k0tlF8p?=
 =?us-ascii?Q?6mFs6Qs1Wo0iorbPI0GnIYOO5EDFj35s86OUZvxeY0dD4Ru+K6ySg0Sf35VO?=
 =?us-ascii?Q?sdxvKDnxc//4XjP07bOhITnyb7Y1G4TeCMouc6HOGYoeaKbQajHW4Pg7BTAP?=
 =?us-ascii?Q?2RpJJjMYnQR9n8Znha3J2Vr/03VQ+LHe3ycaXHyJgsjROtPcyTt2uBqd2Ndv?=
 =?us-ascii?Q?dKnpudkOh/3Sro7EWJw8eH/ZAF9zJ3/9bitIXbYjc4wjgFXttM9hIaHNnna5?=
 =?us-ascii?Q?pz7xoG0uhLMgtHlJS7oHzuHGL3BxQtz6E1C3TXHYE3uoLTASOmkk1snZO7It?=
 =?us-ascii?Q?Q+QPqGpQkqP9DDn8Ww+dIaRNcahw1Ux1sP0Cri47aNiiBlpEWavTn/Mln+OR?=
 =?us-ascii?Q?NsYsVPOp3ygs6Al81eFi+OZRHisxTGzYbhNDRQTmm0cP+LzGBUtWMgTetF++?=
 =?us-ascii?Q?vzcfz1JfhKq2rs8B9yN8+ZX1AET3JudPamYmpO0k8MpHPi1yJ+mM0VBCPkMz?=
 =?us-ascii?Q?27MnF3L2WLL3eIoA5NPVc0sXCDf4LMRNK0fk0QyuLMKN80JFc+dgvXYUFGik?=
 =?us-ascii?Q?mCf1+bFKzSk5J+G6quTK9bQcBu3g7i0AdVGjjlua3uTCuh/3Y5UaSsueUyLG?=
 =?us-ascii?Q?Dg275XZvpfx5CNvUk96EjI8igTZbKzU37Tj3rnuhdTZu1FY7MMr1/QvX67hp?=
 =?us-ascii?Q?hfCBMEzJi7efA8H6PMghjE6jlUlhJ9Vd04mGRGokpzB2AyJA1Sj9QYEZhCKS?=
 =?us-ascii?Q?wZc+d0z+oYrZStU1uM/+Loq8Id7VPEGRyGpcrdc0c7MxJXRRtGcO8bzvZLGU?=
 =?us-ascii?Q?kKk7Pd+CUSPwZ1097o4wAZlLWugqFa2qD7sjlbvhIPbaApqJ6H5tROBSzxja?=
 =?us-ascii?Q?8XL78tcJJAdEDJuNU8HeHM/NcVPl7UMEHbabtqHdxbI2AAsgRsROPk6ajpKb?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f6072a-10a0-435f-5849-08ddea37a027
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 15:44:39.1706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Ekq+RLznKHImEuMtDvWJXdlUz4v0UBPI8cmbIZysT/KYpF3Qmnl4WS9NfBkMyvYT1qGrkNVNHzNN/pwFCQA0gGu5b6xyBYjMQGUDmAoll0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6326
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6A67F140008
X-Stat-Signature: foxtttaxxmyf933cs76591geuxsw15r9
X-Rspam-User: 
X-HE-Tag: 1756827886-38514
X-HE-Meta: U2FsdGVkX1++Bpr8YKc2JrVo9I6PKUY6iILeCSLxtB+W3y30usiDFa8WgK8LNCFD381sE1kC9/hNze8GiVFUDJpgvm4JVf7fOUcAqeVS77JDTiCJBanpPvWuPX28C/O6ccBEad6GUdFI8gH21ZGFft49yrsBuEr+XuP5DKQCSxaRshod+pitkGmta8R3xBiaV0TQAL+YxNTIUijdkgencR75bcQ1NSWYZ8L+fKmvrNJm/lRAngMARwTU7GD9MgiETmEei8cs6+EnuRegxD7+zYVBO1lWbZFijzk1Ui902eTlzjPIS4+6MvAfx9knizvqTFaHMSqlLvW35J/ofjImFzqRrg34f7QnmbDOlvdWdbQP8bwBBtcKT0rI0+3knud0rEJGrbMP/K5btv+wBkx7hJxTsO/BRhsZl/Nn6c2DAhVBEXDXFyGFqj9smZDt4g9gxNdxnJdD+d4AMKLIRYjyJonUw3D42aOGp9TDPK4fjkSRCSLZ5Ct82ZfkzQbuN+Ry9Wo5fO0CgFAE+dqFPGQIyKTbWGLD2uLr5eEhPi2G2UUWCc00sgeuGJx4qfuCC/vqD1jvI4yIX2mkhhtG+0R/7Yx9LJhAQI13m4HCEwR6y4ZV6wbBSHJZ2QekeOvcEGVV0FxQshpPm/N32NwGQMvj5BZ8KNM1U7ShKIyCBsXOrP3MrQJZOZekpFha0UNnqzKSNCfbzJ87RiZIXvTGV+WR7lphmVYahQA3vLVGE52ZnbOLuE8CxZerEBkS2/bPIShyI/MZ8nH0bo9KI/Yhn1W5+j7kMoI+J3FfR9yGtQLDmevmjoVgDXggHl+lhCcaxw7LS8Rp7P5Fi0gTO6tYZ6l+mO9778mqGNzOnM7z7T/e2mVKLoi8X5HERJkzcp5058DZmncdHv2Nswhoqabde871HuxmVEgkqKzEYOerqvVF1G2jQxmi+YrN2yDNSKK4jeqHOp5EICRbO0ApLCd/4GI
 w7lSEFCR
 8FparjSYl322YCS8GlaeXe45IMNhDJIPtYqcHBe0e44J1CRM/zIHrnViX96tcaxsZO+fBtJz7VFe5dsCVsdb8brvomIiOA/WwWq3leDbBsYJSLVCqTyuRe5Pld02S4F1PlmGJb1+Om4IcgcH9MhdP4oloL8SSsI7OCjJHDkdPi1crc54yzo8QcDYCsQsOOf0UiTO++bVYBK87tkeWNw4eEiwfr2YyYrPXkeTdRsGTA+WDytRtY5s4j0ATwNr/Kq9xLxNGuK3YrIenBG6Lk0BBsdKeL7qFKM49od4uwdcR3f/VfdLJmF7mbcGQxuXwA8bHkA4cZIGJmFB65CpJNbI2EGDMSuRkaSZXJAqZu6/zkeZzrhNF/eqv81tXOQlnktU07snyRHgZA0uNDWgyEWpd2aWAqHFIb+Kk2DgusPCb2Mz3TV0BHUtaHgSaLbe90qfJ4tV7lntE8xmszdmfJ3r2BIsK9nds/HN+1KdvB5mg5fQjtt6PnVpmcGovn0SxNl5r8aR8rII6aHhbH9kei2RiMbl/ksGCk5knzQ2/YFww20guTS0zUvX5hAw5mUgn/dfErKG2Ox4tCw8BIPh1b3LpDbYNjRtc0d427sMw3GZPssn6WXnLp2dmqGIuxZkkJEQiCpW0LCDgc5YF57e9zf09YyEYx2UW4hO5psHZefSYOVLtntr7p42m/660fbRYwq0DlCI8jb/mxLi77nhCF0AgJ+2ciiPLJ9vJqQ2IZ08b3MfuvgxE/hkSkxyjm1TfShA0ER4318jAufzwz3XiPbbSCJVkVfu5Y0r4WzRN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 25, 2025 at 10:00:36PM -0500, Rik van Riel wrote:
> Reduce code duplication by consolidating the decision point
> for whether to do individual invalidations or a full flush
> inside get_flush_tlb_info.
> 
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> Tested-by: Michael Kelley <mhklinux@outlook.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
> ---
After 4a02ed8e1cc3 ("x86/mm: Consolidate full flush threshold
decision"), we've seen data corruption in DMAd buffers when testing SVA.

From our preliminary analysis, it appears that get_flush_tlb_info()
modifies the start and end parameters for full TLB flushes (setting
start=0, end=TLB_FLUSH_ALL). However, the MMU notifier call at the end
of the function still uses the original parameters instead of the
updated info->start and info->end.

The change below appears to solve the problem, however we are not sure if
this is the right way to fix the problem.

----8<----
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 39f80111e6f1..e66c7662c254 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -1459,7 +1459,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 
 	put_flush_tlb_info();
 	put_cpu();
-	mmu_notifier_arch_invalidate_secondary_tlbs(mm, start, end);
+	mmu_notifier_arch_invalidate_secondary_tlbs(mm, info->start, info->end);
 }
 
 static void do_flush_tlb_all(void *info)
-- 
2.51.0

