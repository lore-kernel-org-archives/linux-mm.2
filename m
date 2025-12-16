Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA383D637D6
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AE256B0098; Tue, 16 Dec 2025 16:40:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25C336B0099; Tue, 16 Dec 2025 16:40:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB6A6B009B; Tue, 16 Dec 2025 16:40:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F04CA6B0098
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:40:22 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99BC513BB3F
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:40:22 +0000 (UTC)
X-FDA: 84226653084.07.25FD583
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf03.hostedemail.com (Postfix) with ESMTP id 19B2E20005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:40:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UXKqdPkU;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765921219; a=rsa-sha256;
	cv=fail;
	b=SezU5dDeQfSbSA/Lh/JYpbAKIO49C52KTE4YRr8f6BEhWZawLRHJyMQA54QtDB4lmFECN1
	fzBd257LMfEQVz1ATL27aI7Rdg3NLw3fmQbA/4gKIFOm5Otzz7xSVkv9kVn0OxDayV4QtJ
	Sa8F/bqYZaVXeILj6LLzOWpJCWiThwg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UXKqdPkU;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765921219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6MtlBLkYlwQUag/wE2fkthopf7Jkr5F0SSfn2t8YhA=;
	b=MTv2pvdv8XMxNNQqX1y0nBzbRmVt4cp6DDeBWrdcFQ5FF41w8inrMOIVMx+IHT2bZeIRls
	jj/GYz0Vsa9L/J79Jm4yna5mJjJlHxCOghvX72cbfBIUMPzk6bFpfakwkFeCrmbMhPsCNO
	5dIDCmmU3bWW0XhwCGqJbvly4JuFnYI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765921218; x=1797457218;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=kq3wDnUk07Wx3FrPqVZNhqYl8nS0ErGgrhM0zKxSKHw=;
  b=UXKqdPkU/Li/pimoFpQUxzKn9sc0PBJGry0IfwejGhz9c+P5DDaeU6My
   GbJR+pzPvJFTGLw1beDceOUVBZTv6qUwsEu0afekd9/bBu/q2H1O+BIJt
   XFdIPK/HK/kB1X0oKUPPisNKo/rar0cEhyUo4m40RnRfh8t50PTLmFI7J
   5A+XGCqm8ZfjLkr6A5ZhJJuZOjPOQAZYq7EXOPa99a82Jhrp24/cAVbFr
   Dagd0rmJpPmioj08iXqRyHTHgRYSD0wHlOb3+zOnh4BjHa5jv5TXUc+6w
   04/hMOdLgD2PJkIw/8B7cQguuOe8V5qlZQs2BOociRKbxurZLoRhnPniH
   g==;
X-CSE-ConnectionGUID: UgvGvWHzTjKTIwbz2AY7kQ==
X-CSE-MsgGUID: sEU25h6YScm5loVc0GjBBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="67734637"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="67734637"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:40:16 -0800
X-CSE-ConnectionGUID: s2G5/pYFS0aiJjLhpBXNVg==
X-CSE-MsgGUID: gRMphmTVRP2cmuNTcHkgvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="197419593"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:40:16 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 13:40:15 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 13:40:15 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.19) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 13:40:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nB4k0FDE4nyOW9hXOdyH+kIOy9Q8+Bd0pSDOqvSefJRwWciDa9bTapGuV4XIpU2bQSYlDP8A0KB4bFtX323hqga7NA8U7z5zGjYAYJavezm2mRtmLNRsjWdqF5feD3rPDtQv3NNpYCXzrI4ZjqJSbROSaRhnIV2w4+lPdtd8HiZT7mJ3bu/5LGYyi9CKamL6y52a/DiFqtcUvkeTesWxTEmIYG6oUlRzlBmcd/tOemSsVcyjoKaF2drjRRdS35TagnblkYPTvQjtXa+G0sLLkjCcOsNv8a2L1N75uvNG38xC3CW8ao+fTzHdTaOLKI7Bh/10IsIxlem7AGIC9IgUvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z6MtlBLkYlwQUag/wE2fkthopf7Jkr5F0SSfn2t8YhA=;
 b=MEa1bADsnULDLutVMfeWd5VVVjiYf3gBsvDcneKurlv2vp33JuOt333F7dgC63H9wVVSLtjKxGJtEbeW4Psa7UyK4Z1bm/fDE6FaEmAIcUQp+SAW9BfRFWZd7SJdU0W6RVUpOEKbRphWGNlXn4b8y3K8wcXdOMFjX+/N/4AwiGFeGUyzKdz281WIOqUSrotgFSAt3p+qlmyT97nI7VSPFFFkL+P8X9WEhVbxfgjC+LED1C5wdLOzKsrWhbuVz3xJ7TWaaBFI/F0Ge+2pEUjQmEC5r/sbfJ71Zba3ZUqpn5L95n5eAJ159j7S7X0do7CNDzLSXS8EZ2xI1tqhDmf+XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by LV8PR11MB8512.namprd11.prod.outlook.com (2603:10b6:408:1e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 21:40:08 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9434.001; Tue, 16 Dec 2025
 21:40:08 +0000
Date: Tue, 16 Dec 2025 13:39:50 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Matthew Wilcox <willy@infradead.org>
CC: Francois Dugast <francois.dugast@intel.com>,
	<intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Balbir Singh <balbirs@nvidia.com>,
	<linux-mm@kvack.org>
Subject: Re: [PATCH 1/4] mm/migrate: Add migrate_device_split_page
Message-ID: <aUHRpvsa80wg04r7@lstrano-desk.jf.intel.com>
References: <20251216201206.1660899-1-francois.dugast@intel.com>
 <20251216201206.1660899-2-francois.dugast@intel.com>
 <aUHCZpnTNqv8wfdc@casper.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aUHCZpnTNqv8wfdc@casper.infradead.org>
X-ClientProxiedBy: MW4PR04CA0335.namprd04.prod.outlook.com
 (2603:10b6:303:8a::10) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|LV8PR11MB8512:EE_
X-MS-Office365-Filtering-Correlation-Id: 80f57c5a-34bd-4abc-9fc8-08de3cebaec2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cUdXMEFYWFVFL1NJQTk1QmgvYzNZOGlMU3l3VVEzeWxJQXVIdUdUYmJhdzQy?=
 =?utf-8?B?SnhkZDFBd3VqVVRRa0lWZ2ZkZldXMElRSGhCZUFVRzBUdVIvcFdmWjd0SXBX?=
 =?utf-8?B?M2hWR09Wa1RkK0JDRU1PWG8zdVJGV1hJMEU2WmdsYkpiNGpibkR1Q3M1dy8v?=
 =?utf-8?B?OVhOU0l1K1FiLzdlbmlwSVByUVR4emgxVUl3T3VqcXlRTVBZZDYxL0VJeHJQ?=
 =?utf-8?B?dTZJVlhiSDFPZGNuN2crLzA0Sk9Jc0lBWlZNNmQ3M2JnL3N4eXZPMDQrNmgw?=
 =?utf-8?B?dzdyamVYYTNpZ1RXMlhlSVNmcWlrMlcwQ1lEOGZoTno3NHJ6aHZwemh6cmNG?=
 =?utf-8?B?MHJHbGpEOE1kZ2t1Yk9ybWJRVEpLZ0FjQ3UrcHJYZ2lVSEVhcjJ0S2MrMUQ2?=
 =?utf-8?B?UmlOcGhxQ2hmUVRlTE12SVdMaGtDL3hOc2hUYSt2QVl5ckwxOFllN1JleS9a?=
 =?utf-8?B?VmhtcEhhV2NwN3pXenFUM283VW4wcC9LUGliZEFucWhYcWluc012eHhJa25V?=
 =?utf-8?B?WGF5RjJEcXNWcnd6ZUlhNkJldE1Jamp6aHRPSEF2K2RkNEhhZkhkMXJkVmxy?=
 =?utf-8?B?ekc1L0RyN2JKUXhES1l1OFVGQ0JZRXNEVWozVmtkNkcrcGVER1pqWUdUNFZu?=
 =?utf-8?B?YlI5WFh4azJTNkdSSm1Ib2t5Z2drKzUybGp4Ui9sY3dDQzNxdHVDQk9GQUpq?=
 =?utf-8?B?djlaYi92eEVyQjhCVEZ4bG1IQzRJQVltd0RFa3N3NVRxSDl1RWk1MzRtRnBU?=
 =?utf-8?B?RnNDWENRQlVhWHVUZG9nK3JlU0RwSEFwSGhxNENtU2MyaTA1WmpqYU5ZTFlB?=
 =?utf-8?B?cTR5L2w0TzRKdDJ0V21WT3lNUUZCbW1BRmhxREFkajVGQWpYbXFJRHZmWFJm?=
 =?utf-8?B?VnNkVkZkWmI3QmU1a3B5UFFyRjRNaDdVTi9yRmhIZ3lOblg0OGhSalBYekJn?=
 =?utf-8?B?VWxDMElpbGU3cEpiRXFwbFlKNDBMQngvSGRJZXVyTGRpcGpBSm1sTGJ2MnM3?=
 =?utf-8?B?ejVVWnEwNHA4WFFaOHJoaWp1QXYzT2xEcS9vZFNTQTdhUWtXS1hsd2FpdW11?=
 =?utf-8?B?YW5QcU5sRU04Q3FjR0E4RDE0ME1oWEZ6STRoLzZhcUROekxkT0k1QWtWN0Jk?=
 =?utf-8?B?ejFoMFZad3d5b2tUMFQ0U25kWkpCTGJBSmpuZ1NvUTBEZnB6WDhzaWFOY0JX?=
 =?utf-8?B?RkR0QnhoRmpqRTZCekVLV0h2VEV1eTViUFpzc3pTVW9vZDd1Y0MvbGg4TVND?=
 =?utf-8?B?VWtTMngyNk5yTXpMQ1NFMEJIck1yenhOV1RlNnkySE9sTTJMYzVlRmlIcGJP?=
 =?utf-8?B?UkI5dFQ2ZzBxVEpTR1I1RXJmQ1p1Rm9aRURDL2IyeHl3eUhjKzFZUG5TTnJM?=
 =?utf-8?B?aFFBbElOMVYrRlJjdk5FMG1FRUtjS3pTSCtNZVBwREs2a1RYMDZURldvTGFa?=
 =?utf-8?B?NjhWeGpZaXFZQVhaa2VXS1BUZXA1WTBDSWNtMldlSWNuTGg0TXhZbFZwS2pj?=
 =?utf-8?B?TnFzcWt5dGM0YlFRSUtXYkhJSDlCVVd2SVE5a2QvRjZNanBwUkF5cnc5Nmhk?=
 =?utf-8?B?TzBWU1QxZGVmdTdmSWNBdUZXTTJZM3JMMjZsUXYxajNxSlBOTGNsVkFQV25J?=
 =?utf-8?B?SkMvUFpoekg1VVR0SmpZTU5CZk9SQ2t2R3czT0hacm56cXBrM1owemlHNTQ3?=
 =?utf-8?B?dTJETXBrNGc4S0hCMFdMT0UwVkJjeE03dGxBQytHYTEvcmlYOW1OUjF1cUdu?=
 =?utf-8?B?M0JCM2p6dDZJN0N3YksvTlVQQkJBcDRzMzZQWGpzUHhLL0lIemF4R0wwRHhR?=
 =?utf-8?B?MzNTQ2hpVjZpTGhYOEhtUjNHZU5wQUQydDFpdkhjc3pVRmppZWFjRjJIOXNM?=
 =?utf-8?B?WWxMRWdGNGxlQm5kRXhEQXpmMUdwcEg0cElZOFdIRXozTlVGR1RzWk9MdlZp?=
 =?utf-8?Q?xS8T1rls9/EDJRozPrJMkM2YANbXJK1r?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2pIeFlxV0VFRHozdEE1dWxsb3lPWlpiekw2L3hJM0dtZ1JFdDRWNVkwZXR1?=
 =?utf-8?B?RGpRY2xWQm5JRXNWRGd3SU9RK1Nra0FSTUliUW96OWFpZTZ3aVZKMUYzU3Fu?=
 =?utf-8?B?T0JIVm9pSFZ3eWNVbW5hYXNBWDRKbTQrTEVpdmdJb0FlWWxoZlZOTjZFMXNE?=
 =?utf-8?B?TWYyaUV6aHVpbnJQNmJLay92K3hKSlJoR2s3K1N3TFN1RWR0dXNzaTNKbWg4?=
 =?utf-8?B?M1dSVks4MVQ4RkI3YTg2aTNCMFRhbllkMU4xNzRSOUcvMkRMdVdsMUdqcVFJ?=
 =?utf-8?B?UVppaFFwL3JreVk5ZzczUW9Ob3gxMXhEK2VFZmxMU1gxc2VjN01URUoyTmRM?=
 =?utf-8?B?bStGczRXeDNVa2NUQ0ovUFp2YkNreHhrU1FVU3g0WlZxeENEN0kzenI0RHhF?=
 =?utf-8?B?K3N6eUozWFl0dE5UNW9yT21SbHdrMFY5VCsrbDFkYUVsVGt4VjliZWFvRWVa?=
 =?utf-8?B?RVNIUHlzcU1BTmx5MklCbTVia09ENytqd25kemEwWmFwdWRKVW8xZjRQRDhQ?=
 =?utf-8?B?K2pBMFZnVFd1Y0RSemkwNE9VR2VGRWNQdFNtUFhJbXBoR0VBb01SQmpmZ0Zp?=
 =?utf-8?B?ektxZFdiOHUrVk9ycDJncmdyN2ZMNGIyZW92bVhndnpFdnNtZ3dRNkNHSW9v?=
 =?utf-8?B?c1pQUkJKMk9rc1ZUTjZKMWZ3Sys4Q1hBQnFmQldVY00vbCtXUklNc2VWMy9q?=
 =?utf-8?B?empIVzdkK0RNNUhNNjR5QTNBSHpxNmxSQjZxSndqaEF1b3ZaNnI0T2ZNbWs1?=
 =?utf-8?B?SDdYU2JCL1o3OVdwcEtaM2VGMldJVDBuS1l1a3R4K2k1YThOTnlETFpBOGlh?=
 =?utf-8?B?NGZwYU5ZaXdjMkFUNnpoV2x1OElOT25hTlUrTnRQazZOUENYbzd2SnZFalN4?=
 =?utf-8?B?WEVYMWNFcmFvV1hyMFBrdlRtaEcwMng4a0xTQndCK01NcEEwZGxhK0xQa3dU?=
 =?utf-8?B?WnBEOU9rbG9ldzZuRFFNdnFDNmNvZVNxOW5oMkRZc3Y2Q1ppUlNCaG5wcEh6?=
 =?utf-8?B?OGhMb2Fkb1lNKzlyWDlQWmJQNGhMNWliQXp6cCtrQmovTW5UYUx3U3pta29T?=
 =?utf-8?B?MGsvVDA5OGZRb1FpSGdjQXoxbXp5QjFvRXcrUFBYS3FwZ1ZNV0gwMVB0OHAz?=
 =?utf-8?B?VGZ6S1N2M1dKMlBlVjVrdUQ5M0hRRUlaUzdLdTBjYTlTWERCL2RvY1RQZ3k5?=
 =?utf-8?B?ajRla253SnAxOExKNFJSVm5wWE1UYU9oNEo5clVFVmt1YWdoRlJ1TXlpTVZJ?=
 =?utf-8?B?cDlVc0RlT1I0bUo5Wk94cHA2T3czSXF3RTFyTk04L1hwdVpEck5FZXhpVGMw?=
 =?utf-8?B?OW9JTGNkakFwbGFDMnc1OXBVZjJTdlZoSXhvTS9PelRwS1YzNzlnWGI5eGFY?=
 =?utf-8?B?QlovOVR1QUVhRFJZdGszZzFYTmV0WTJnWGpvencyNmZjQWJiUDVYQmsxMVV5?=
 =?utf-8?B?eTZyeHRYa0pUWkhKQ2lRTmo3RXQzRDZMN0JJMWFReXlVclprMVVBY0k4SEJO?=
 =?utf-8?B?VDJWRVJ4ZFJDQ2c3UWMrMWJjenNRSVNmUExMaldoTnduRXNzMFpqTFFkUTFs?=
 =?utf-8?B?K2V4ZTRVakVrSTQ4SU5mRHFTUndLUkIrQ29EUmNRcUhoTVZFbWVteEk4ZFFB?=
 =?utf-8?B?OHArSldma2xnZWhUV1NjS1pFQStsSXVBZ0E2cDBRa25iNlJ6ZUI4YVdGVEJP?=
 =?utf-8?B?M0liRnppK2xCSWNqSXBnYWQwL2I0RjBkYzRlTEQwa1BSbm1jT2NlVXh6UGZi?=
 =?utf-8?B?d0hZbkxBOWNvRFpPcUtldDFES29wck00OGVSWVUybEw4UDBib1c3T3pQaXRD?=
 =?utf-8?B?RmNkdEs0Q1pnVXZFUld4ZUV2Sy92MnhpM3Avb0NTSnhvTFFncW1tWm5mMWx1?=
 =?utf-8?B?NXM2YytLNEthVElDMVhBSDlFTGUrTEUzRmRkaWkxcUc0aS9najlJZlNzUjdt?=
 =?utf-8?B?enZ2ZXIrdEdzRTdQNzY5Ukxrem5PTUdFZWFpbU5pZHREMmV6a3JXeU1Ha2JO?=
 =?utf-8?B?SmdFVHd4cEw1RVJaQTVjcUJOVzcrY09nREprcWhUZXBuNG5uY1dnbEZkcWdq?=
 =?utf-8?B?cUV3UzQ3YlZoaU9idGJpU2djTUlDYWlVYlZYWUFqWExUYmZCK29Oa25iUDdo?=
 =?utf-8?B?bzU0Mm92aGd5TVFjYWdPTHFNY3JKcFRhYjRrcHh0blQxNk83c3oyTWNjNDZF?=
 =?utf-8?B?NUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f57c5a-34bd-4abc-9fc8-08de3cebaec2
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 21:40:08.1348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QiG20vjrfr1efiWfqHBztCr89PoOmfsjBTwhvdSqTpnyg+pdCptpTbzHaH26ZwE/+vVY8roioSxfUFqPtFaqGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8512
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 19B2E20005
X-Stat-Signature: a3ojoa53ptp661zcmqztycze6naci38f
X-Rspam-User: 
X-HE-Tag: 1765921217-199226
X-HE-Meta: U2FsdGVkX18Adv47wYoH8RxYI2Hj61jloebdTOR1jHEUbJaM/dQJm7DeX3hlYO2lvveIEtTETvQobE38QLUWaeweO5/Rn5SDWmSAdrcQECIdcBydAZOuQzhJlIh/KSZwHhFsTPUGgnMxW1C9rAHRcaZcqqIhCkuxEJ6/XXWUajGB4sSHfePTKEMqXTDfkC6997Zm0veCee8ERpwYbetrZJUS5Umyh3Uiu4DEUMQL5XNnmxIvwJpPZMXP3MmQhwPlUHbMCXAZnJ9qSO6aRvjtQde+kRIVKNnWq5N82RQi46b1u7MwsgX+JWCbZeXHGjwFIgqFkIVh6HlJXFQvzpumhAAe32A3A99CpXZumqkHZzev/GdLhp4W6rKp0Z7JF8ljWiNFPJXGoSerDK3rE4W2QhvNm6VT7Ra3G4ktzpXTO3k2vtLp9xjyU+/Qqw59RGaRWqrfPITyVxoghJJy7XZ8xuhHCcXxkEmpbv9tJHAJb3B1P8c8Vs0tP574nKw6gAKur+WSCqfdzTfwvl63ggx69Ldq6ZoXCj8iT7F0nrHkJwD0iXUmmYnHUe37RJFOwJw9of7wGIMnDo5TVJ0py64pQnDGuCamBuflAbvoGJxP93Jtd3sBRHn5UK01+hP7y1EvZyEtIbEbooAqju5gIi8PS30G0BFVYCrDCktozZHBhnyhCpUUXsgoHxOUgNk1CCd9ADD3iTDd99tCMVu0khVQ9ifLV5j/0U8cTMRSBZ4fsQAy0lpellGnpiHOwv3aNZoNOck4eDCLUSnIKMiEdzKM3coCG3R27HX0Sx4GTJ987oB0latY2mph2NSmE/mdobCQieInLVRsBo3bDximyfq5gA/Z4HiAPNOXH+/CBOByYgxIdARB5tktzgwQ9N03yxTiyD+P6/Y6Vcwyae3exWmgko5vB83K3HCWxSU0bN5Pt/5vKwauOGFLngEv94iXrcYRDgJVQXmOG0/0BgzTXmL
 Z4kSza+b
 SEmkvy4LIkJvHsuN4AWy1hs6vAVx7ojwsnWvuDccMo49TnhL5qCpzR74f3HRm02F1s6gmeGtfNsp+uOfQZYUIn4KbPhneQG99JAC2NvE/4453XpUAr67d6Ci7AaYSf4QwdtxyJUVNGSTERIu/8/bey1bDz67x+nycjp7NLE3rt6LdotiPjQySx0gtG+2iytgmlj6lFaFSx34qG/dZpxVxCnNXMWPRJTmAegt0xTEjLekMGxH7FHmcf4W+69V74VVj9s5T4UMeXCDfJa8Do8ZcOHwyMj5jmbbpHeirEG2N35Ga9o5bqxkWmOI/z/zNEzU9Ag2OycEok8WdaZdf67qvK8BJqcmTrEbXJiNuZKQzU8F0Swm91s6yrWqolS3xUwhp4oozKg5kNhUJyWZX7D4Q5JlSsr6mlsYnl0i5gRi27B3ePrGy4BwnEgRYMmZ6GVmC9X6zOkJSfBy0qiR9vytiYm8Ro1/iWWe6g0TSjhylxOvh2rdwgxCjqdlS4LMIEGtXYXr00TL0ceP5Ap36iKU3CnuvT+wbTEepQ7QU7gnjujjmlu8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 08:34:46PM +0000, Matthew Wilcox wrote:
> On Tue, Dec 16, 2025 at 09:10:11PM +0100, Francois Dugast wrote:
> > +	ret = __split_unmapped_folio(folio, 0, page, NULL, NULL, SPLIT_TYPE_UNIFORM);
> 
> We're trying to get rid of uniform splits.  Why do you need this to be
> uniform?

It’s very possible we’re doing this incorrectly due to a lack of core MM
experience. I believe Zi Yan suggested this approach (use
__split_unmapped_folio) a while back.

Let me start by explaining what we’re trying to do and see if there’s a
better suggestion for how to accomplish it.

Would SPLIT_TYPE_NON_UNIFORM split work here? Or do you have another
suggestion on how to split the folio aside from __split_unmapped_folio?

This covers the case where a GPU device page was allocated as a THP
(e.g., we call zone_device_folio_init with an order of 9). Later, this
page is freed/unmapped and then reallocated for a CPU VMA that is
smaller than a THP (e.g., we’d allocate either 4KB or 64KB based on
CPU VMA size alignment). At this point, we need to split the device
folio so we can migrate data into 4KB device pages.

Would SPLIT_TYPE_NON_UNIFORM work here? Or do you have another
suggestion for splitting the folio aside from __split_unmapped_folio?

Matt

