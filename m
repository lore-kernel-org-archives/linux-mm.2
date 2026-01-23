Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD6FED6CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33536B03AD; Thu, 22 Jan 2026 23:56:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1036B03AF; Thu, 22 Jan 2026 23:56:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 898CB6B03B0; Thu, 22 Jan 2026 23:56:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79D116B03AD
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:56:07 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21063BF4F5
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:17:48 +0000 (UTC)
X-FDA: 84361466616.26.55D6CDE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id E991240005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:17:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ClYYXuWD;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf17.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769131064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdTMwyzN2nm0Li1glYzU2dUni30wjZi+T2Qps5JLy+k=;
	b=prU52D7HMGSGQb83wGQ7yT83FkK27glA4UxdTS7YYcWs4LlQyAJuxYM+ItYSJqrzXhthR8
	s0h1pZ7DR2riY28fZCJPFJm81rjE5clqObQut1fZ/eXYqbjsAfe6oQrOdt6tYbB9cbKt2y
	Mb2sjaB8a3pBC398PY65uLbqyILQcVM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769131064; a=rsa-sha256;
	cv=fail;
	b=s+qINIgwBCGOL6N3ezzapu5FHoY2W1N5PdLQB4I5gYcf3JOm4GMGtCsfufJSrauhAH8GsQ
	gh7sfCUI1bVSUZI6IiC3C/Lpin05CT8yiRWBHWdxDz16kWoKUnE/EKpGdVZ1Bseq87W5IG
	4iilKN1xR8nfnERHGX/oFJy5LB8tiak=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ClYYXuWD;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf17.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769131064; x=1800667064;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FAVoYfNcJcbswE6uADVxkQoicCsgBn8VXtG6zpQh/1g=;
  b=ClYYXuWDFH+3OaV/2Tp6ZLpQ/3CMW9N5qgnscGsO31B2P8MYMZ4MHGzE
   TSvQnpaHwE4+JaDm9JNuq/vS7xIi9Tm2dtgGkdWNnnL1QINFLg76Dc0fv
   BtQNdLbKcJxZmy04dNzkHMPXkrHmgo1WA6LjUctWYcznvjvdQnHqCyIkD
   LxNyTSE4cbgv3Xa267iRrUDZXWRX5DHH2v6Eo0PDCjtZ7KNZWolLxGHXM
   MGhJUcGO1u05PKqS7Bpm+mCnAjMbJSjTGmEMSqBqT2xl/qHFPkvogWXyY
   3O9hjJ83rl3iXbWV0OlklXOY1m06+uCP4pcScJaT0ouaNuG09EWrycw5X
   Q==;
X-CSE-ConnectionGUID: JwXi52dRSsqiB8opjJzm9A==
X-CSE-MsgGUID: KcRNIndzRkeF9TQbmxlRiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="81101171"
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="81101171"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 17:17:42 -0800
X-CSE-ConnectionGUID: UV08i7/2Qc6TjTtGf+7HTA==
X-CSE-MsgGUID: Az5rZkAzQKGnRiilT2E7Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="211013600"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 17:17:42 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 17:17:41 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 22 Jan 2026 17:17:41 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.22) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 17:17:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MnMsQSU0sRtNqlLeqb1Php6e6QwhWzKKBMCCCojaJxY0lZqq2ExR6CPl/eDS297zkWULERQ3gOwh3gDD/EE84oE4km/9PwkkoLLXHzbjl0ToXnuDEc0XMJ5qGWvehgibhGXW0KoJty7tSRRooKPHPesg0CCsR99dtGo/bph6rcgqf1Dr0LB9Gz+4/BUZ10H4d8prxLIq1Fl3tZL99RBk8+u8mKVIwzFVFTBD5ZSplxXRcR5Hw+wYsTS43NTJqeRw3tgGlcOz4K8JzjotofFOANw5ZBdJoGqyIqOs5iIBtciCGECcKi+NOp55tKqtrOe8jAOFaq/kWXpWlAB8jZyNAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zdTMwyzN2nm0Li1glYzU2dUni30wjZi+T2Qps5JLy+k=;
 b=fZol4+jSxKpvFRY1ps1G5DvEzwXVtgxiQ1CZWmXyyvvjhUN7hGr9cr1YTMKu/u754SIutChstN/xNwLWfpZ7knPyOGzLPeUmyuaA2trQn0mHsQO9NbvB9VszFSCd7v7/3yAgHaC8scR5yFfhg4TOaVFTcOnH8kvNSp8QeChlR3UNSf2ajILswrAEsVSHAEsDFZN/u5/ftqaqlLiwj7s/x2sn4pEUaoxmmawqdCf4LU2zClozPH3jn74gXl3hB6+x0P45LlR1rBPRFspKHx5rd/GV9kuBVVcQ7rbmp2Z4JBpyMatsX0sRe6mOjpSLX2htpncv2JTz1eNhNqcHMRCn+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8468.namprd11.prod.outlook.com (2603:10b6:610:1ba::19)
 by SA2PR11MB5049.namprd11.prod.outlook.com (2603:10b6:806:11b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Fri, 23 Jan
 2026 01:16:02 +0000
Received: from CH3PR11MB8468.namprd11.prod.outlook.com
 ([fe80::8188:d688:bbca:2394]) by CH3PR11MB8468.namprd11.prod.outlook.com
 ([fe80::8188:d688:bbca:2394%5]) with mapi id 15.20.9542.009; Fri, 23 Jan 2026
 01:16:02 +0000
Date: Fri, 23 Jan 2026 09:15:52 +0800
From: Philip Li <philip.li@intel.com>
To: David Laight <david.laight.linux@gmail.com>
CC: kernel test robot <lkp@intel.com>, <oe-kbuild-all@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>, Nicolas Pitre
	<npitre@baylibre.com>
Subject: Re: mips64-linux-ld: lib/math/div64.c:undefined reference to
 `__multi3'
Message-ID: <aXLLyFPyc2ljyLzx@rli9-mobl>
References: <202601222217.uzed54La-lkp@intel.com>
 <20260122145752.1e4c4202@pumpkin>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260122145752.1e4c4202@pumpkin>
X-ClientProxiedBy: SG2PR04CA0153.apcprd04.prod.outlook.com (2603:1096:4::15)
 To PH7PR11MB8479.namprd11.prod.outlook.com (2603:10b6:510:30c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8468:EE_|SA2PR11MB5049:EE_
X-MS-Office365-Filtering-Correlation-Id: a4afe272-8a8e-41c3-3543-08de5a1cf8df
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?UZ1aBgPC/9tC02tcdqjO9F3TlFCpRWm0/YLW2fgr2TATzFielKfmYmk/DCbW?=
 =?us-ascii?Q?4GFSxNBRUCWas9Nk13iPswvlYJVd7n35exWisqVUviarcFQni6Bottn7KL3C?=
 =?us-ascii?Q?rCU9rCSyvgV5/kOBeGXAMgExtcvcbL4d4OtQ94g/TOYKax+tbLVfsQVedsjS?=
 =?us-ascii?Q?zG/TaWNeRvzQyd51ilPYYVWnwaUuSyAhMYWbb2fOX0FZSdOZxr4wYmG3PxQF?=
 =?us-ascii?Q?xhe/ZhMg/qk4QSpR1VTIELvPaGqE3tczd+FCtA3AWHzOiccaUheD7Zmst0/c?=
 =?us-ascii?Q?9ptKqC3022evRNnuk3rP6xJ6nmT3v0ZaDa4Bg2cJz6nsQbB+SlzMbSx8Xh55?=
 =?us-ascii?Q?0ZfeelihOu4Add++C5M9rEHn5ehX4j/5A5VZ037s0UZbG19vbopn5Nx/8w2y?=
 =?us-ascii?Q?7weeShFKh+akYh9DuKOSWa3IFlhwO4BCe4GH1WNTQRprB/fp2VlAYDHuHmGp?=
 =?us-ascii?Q?i9TOOCpD5XnhhGmXVlsUWQgrvt1TTEIat8hW3TW5VgXRo+TkqIkWjFO0bzG5?=
 =?us-ascii?Q?GFkLSq4ScRk796P4JVffqRi0pQHh+gmyH3AgbyBKXvp1dg+byykmgZbNLkz/?=
 =?us-ascii?Q?75GKvfE/uy5Mzc35JkvWnYkFyFicYJ2j0k9p9a/SpAZSqojEekG1tIKHZd84?=
 =?us-ascii?Q?V/bG/3RX9nfLh6AMqocQNOQaH3CBoa+ptJPlO5wdCkaQB/glBuuciw41782E?=
 =?us-ascii?Q?vByF1JYE7+CJcuglk5QSQYj2HXgEhlNlACUmf7IeSgG/TceDGsOMeCSaNeAq?=
 =?us-ascii?Q?t99x4w26SF5ZtINw4uWDJrn3fY1IyPkkST0NvepDlAd/56WP+z2/5GASkU3+?=
 =?us-ascii?Q?Vy4y1FNAjiTjV0dY91cjUAeFVCAz9DsFCtMP/oQkuJu57Oq5ZFntz2R8BwmC?=
 =?us-ascii?Q?TFcaWNJk2ZyeGGMei3PZ+hXypzFrAx1s5jwgjZ2+3Xn9fFjyg6P6UGVMceWI?=
 =?us-ascii?Q?9i7gb0VF5XxyDRbzXYmbFfgZeCv4BikwqVY4CUmZaKouFYQUKOz0dUaZoxx5?=
 =?us-ascii?Q?YGKJqKdzHr07MC4a1o86E2q+3Jn3JDDxZULWktjOxVu2XR+XYydlLB2jGbCb?=
 =?us-ascii?Q?VCGAYd+v9tZMbhkPrwNwYpMOjF3Wo3k15K+peI9RibG42xmIXhfZeUT6YrCF?=
 =?us-ascii?Q?LClYRf12l+Re9WB6mKw1hNpJi6IOnQPfBRwydhi6XTK/upRzb2p2NnCEKpHt?=
 =?us-ascii?Q?392PMiI3Fch5kjkgjYdqhfHaowrVz7wWvX9LX4qNlKovpQVg9I+U9COnnjUw?=
 =?us-ascii?Q?JcQ6DlK2vcfrfCNsemR40LFqNu9q8XMg0rguS1qksGxh5Ls8Wyz8RFpqtYht?=
 =?us-ascii?Q?yPE0bWd7Y4wVGhAGh+D3CryQNAp5mIuLzVq04ZGULdB2pfqSdVsV0IrJpUak?=
 =?us-ascii?Q?go3OjoZOCrzIauLPkJY74nM+9NGxkgaztu2SnSv6YCBo05oB4+LqYIf/ul0i?=
 =?us-ascii?Q?caP91M4FGt+5cSLTDb8SbF9zg2td7BbxD3MXrM3xf7XiNmEz7LBSQrRQCuPj?=
 =?us-ascii?Q?YD0kSmChEQrkeuwrOJz2pJ0dQnDCoX0bjCbtI7X4+2FeuCOTK0LKAfVxpLIJ?=
 =?us-ascii?Q?+ZCzy1+5MvA1ZDHBVYBk82F2b0AF1FEb3B7rx6iL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8468.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Eqqn8HI37aIbdA7x3VuK//AYUA6sEUJXbP2xG+JSPK/q5Pr4iv7OlgPfLYA?=
 =?us-ascii?Q?xvtMCkaKGUP3PaWftUP6qqwa72Y0IYSKSUjwFT08GCY27/HmAQ/ehTXdTWeN?=
 =?us-ascii?Q?z5iO0Lf3EUM3znhzJZJKx9QAlXXUny+sDiks7RIFUxXbGqOdudp/1h3+haIG?=
 =?us-ascii?Q?4JJZgnafigUa7vWqkkhaA/0Qquz4KgXFfrJi8xClKlj90sA9QJZKFrCvG7b0?=
 =?us-ascii?Q?3yDpWFMFx90cZ0AV6j0ZC1rLZEKaYItteYppkDyEuOwu22BOv3/SkYT1x3W7?=
 =?us-ascii?Q?fj2y5v4nmUTFBBJoq8SFXjPQbe47KEG8mTPIodJ4pJ4xsCucNc5gtr4YkBHb?=
 =?us-ascii?Q?7FS5GGFssTvmXmoF1ZHHE8Ka6cjLCHxhUb9dce86K416RCw1dUHZP78oxaVL?=
 =?us-ascii?Q?Ss7gkqc0l89SKvDCtsSGg4NdiyjPD/QgNUMqVvCkHBCccifXKLaaUN64eVue?=
 =?us-ascii?Q?cMI6q1UE6djbrblCUTmEqHvbE5JfrIDmSdpaofY1UB8yFT1DBOMcwEcFGIBp?=
 =?us-ascii?Q?+YxWWgdpOzL2C15JE+7xVwiLHLs6ll7DMdXV+x/XbTJVlOsZkbEcrhzBgsz6?=
 =?us-ascii?Q?D1yAvFtli2IIx42a6CkrYreiUTck9eVE7Dxd1d+qKINiB/zjyBQPpJkGeybS?=
 =?us-ascii?Q?BQYOM2M7Bwa68g/xwLRjzmCqemU8Nv9Km70zb3Y6OxagScFMs+UpBFsA+pid?=
 =?us-ascii?Q?KJyg3aRtxGTLWIaom9DIwfoytlNrNqEk8oOduXuHU3bBT5ebk4hURJxdotrf?=
 =?us-ascii?Q?qw8S/xqTTRAMGn7j+9LklDiyU4DsBi7vyqMjzl6+lonGv4T4Gqp9YIk6uXwO?=
 =?us-ascii?Q?wy2RvTa6EMsUdRRe+N/v5pxuGYYM8hkEgbpthOet8mh+u4kyS8dfKPp7Zb5B?=
 =?us-ascii?Q?HvHelFUnbYwWmbasOpQYjIeLUA8DkgcFwHI0jih5M6KILKU9auySbs9xBYez?=
 =?us-ascii?Q?qiRHAX0YPuMWafodXG1OQ86wskgjVWpw1BDAwxj81eXIM+x4I9/40UtvBEDE?=
 =?us-ascii?Q?8OUw823bVaJdZelzbfr0fuADtHcUn4+rCwX8qcCN8kGkw0W3o1jkZ9mqnWLT?=
 =?us-ascii?Q?84hbc5LWyJ9hHCUXlPQNlP4Xi6a6n6eYhTAPlUK/2AzzCqag6OS9jnCNQvZC?=
 =?us-ascii?Q?sZ2IA8TezGEKJXod4m9smqz5pFTTzlmeETeJieuy389gSqFhCEopmXQE0vxf?=
 =?us-ascii?Q?wLEEIZU8XIdX8XqcK4Etgetkfnxu/xgC3rFRKSzbmf+i5zWpv//NSeoG5jXc?=
 =?us-ascii?Q?Y4vSsyAEXjqJkXQ2penUqqLHiGyhTrFOdAlNZauab3W8wdrOehTk3dZ6G1m8?=
 =?us-ascii?Q?CvEAFmfO1FaEHa7DHCaZ76mfIP8ykPSLbxy13gX0Oqf2NDLuVDfhejFFJR+K?=
 =?us-ascii?Q?QJDo6dsG3bwpk8unxCHTnljnFv+Qqkv4u0pPQYHFzZUC8VncW04PHFAtwcGS?=
 =?us-ascii?Q?v2VsVPYYNsuXe+8ktcNR5/cKX3+TQbuBNbngK1V3SAKzduCrX5lai7kD0JHj?=
 =?us-ascii?Q?xwY0MfsxyUSZ4JO3jOQYo1YxXr+TWYkHSJyXwjbKbq2aGMAbYlUYBxu34Trg?=
 =?us-ascii?Q?jrgpKGy9ep1RAuL0d9V5zdt/ld2T2VS8ON2BWYHYYu9vCQHQrDdyhqj+VFPh?=
 =?us-ascii?Q?T+kPHJ7EnD95KCBEoQFEAOMvFjZE1VBMOvSd7veGrjH4F2CPIRS5RZh2HQxQ?=
 =?us-ascii?Q?BCsXJ0u2K84leppG4+tM2fjeyOHy6ty36F6w3M28CJUm7gcRUpYgGxqoLZxl?=
 =?us-ascii?Q?TiGvX7JYFA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a4afe272-8a8e-41c3-3543-08de5a1cf8df
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8479.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 01:16:02.4359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AykPV46xlzfeAOT0xvIxSNQLRTpoGKCwpMnPigMzEz413besSIlgbynh6qlvuO8dr8Jih3eexrYdLDoiugBnlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5049
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: E991240005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: cjqxcfgmp8tg9j4adotodyr7dnjy6sdx
X-HE-Tag: 1769131063-739219
X-HE-Meta: U2FsdGVkX19YuVv0UR7354yYQ4sgWjEe8OEritMYRuM9wQSNIsUxoX+qqElXNj4LG1yvwR4/SLMEgyaQ11pbxY91XlyTigPzgEPCxRyAQHoGco7sDdCm28T9sF/Jnh+Md3YuNI2rRcm0s+Yq5TaQ6GWu0vXPWKwPYTPczTsyOdVjk3WdZ49SZpaKCayJPsbpF9W7FCe3pLaSZuzQmSVIb8Az+Ge3Op3Hs6/6NPjyCHKwV2M4ELsDezjV8UnQOjxpWAZRPouG0B80MHRLk0H+EiZUvSTL4VL76Sb+zYzT5z8mErbcnrLeqTYHEMxlw8lGO4gXCmH6OvreGADwN17Tu/Q8ui1pFLd9AiEdwnxkynetlOjg4OnfZ1imoYWMtme53wCXmESukG3QCMOfhVDwMEslGdaum7tG1SZhHg7D7I3oaJLtikhUAtUb6trqdakcNSd7vzlB7vTpoGm+CRAWnLLhObz9HhONhIU8lbZYfIHJwQqC/VkvthpMGmBSQu5biygthtcJHNvna5ZK7v4KQZ0H4l2N0OyzrhW0cyKfQkiXTrVkb61UD1vZe3HKEqptIZNP60Jk0AaVu2TUhrzC6Rj3ZjXsZLaFzhj3hjLUwncK/swRmgZKwIhKkzjgWWQfpB06hRzW0dUorDAS87XaAFz9aWhib/DZrh3xpyxZwQj2HYNNvKTTIx99h47ZYTPLMzF5i1GuCf24PrgY+DjNQIAspUzdAQCC6wgRnacveuTjq5PGTuOBW+6yNmQJ8Ulke6h4RJTuZyAZbOy7538yev8bZjjP1480tIAsUhFO5LpXkmHFOxlxueQnVM72OkmFfTeI70Jlp+DwfAVRn8rcZxy+cCh4o8UfwlnaLudxVm+KVutjrHxvMj7zCJySfLDbQ75KEWcwNOPPhn5U83wyZ5lB1QahoS7c0noMNbfJ0UhEKTdFEoOnPHsA3nFo6UqIlDTRcM2La+E9uOcQR4s
 Gk9dC4VQ
 Gpw/RKXhCCPu7Zl7NcZs6kyHy1HmXlu2UyBkVr1lrPyZ1OcG1MQcDBv7zQehFTnpuOK6eSM0+NCux62ZPPUJ57OAL92AEraVcW5aqJk5pVMSwVWjzLVaHEbSRaHJKt68grAgZCXgUGzPJ618ClQ1837wg0SKU6o9ax/PSycrXqM3aI8tW/VDX9ab+Zwav1B+hBBzEpQHTv10KtzsHRguULbTn+mwtg5z+6lP3C0m8YYaiJNbj3nJfos/r6HPGTDvNYGfdlGBmvp87cZf53jP5r8iwKDeTV2iDVwNbYYhbYArKZojkRb58JxbqMp5lMbfzCa5tKCyh1mLx9Q+6UOCzwFTGfqTYcehhgS7OoICKBMQKnAYHDgBVhv0HcVW2PzBIobkP7OpbVcoTYK6mRPpthh1HWXnPLddKl+P1MBDc/ChcH4EOeZ2hpu5MfjU+tXtqSsv0RMbn+hxTA3eELQC1VF0+++tdFtphADZPV6FCI14G1TqlNje4y9icPk3+su7pEgm/XExNt35RWUmu1LIP1bEuIMFOR/xENNzfxMEuTn5n/iKDW9AlR1CS9LjdmAGELVF+lEZxKA1k19vQFHAYOiWmv0OWvO3sPdeRgkxqAq0ytQilIObQAVyhk6kChW9ug3n4sfLFXH/iQnLsMi9nQIqQSBgoV0IrrZfSsTrWWbbyvX6rmDboHQbHC9jo7orMLLlE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 02:57:52PM +0000, David Laight wrote:
> On Thu, 22 Jan 2026 22:43:28 +0800
> kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   a66191c590b3b58eaff05d2277971f854772bd5b
> > commit: d10bb374c41e4c4dced04ae7d2fe2d782a5858a0 lib: mul_u64_u64_div_u64(): optimise the divide code
> > date:   9 weeks ago
> > config: mips-randconfig-r062-20260122 (https://download.01.org/0day-ci/archive/20260122/202601222217.uzed54La-lkp@intel.com/config)
> > compiler: mips64-linux-gcc (GCC) 8.5.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601222217.uzed54La-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601222217.uzed54La-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    mips64-linux-ld: mips64-linux-ld: lib/math/div64.o: unable to get decompressed section .debug_info
> >    lib/math/div64.o: in function `mul_u64_add_u64_div_u64':
> >    lib/math/div64.c:(.text+0x60): undefined reference to `__multi3'
> > >> mips64-linux-ld: lib/math/div64.c:(.text+0x188): undefined reference to `__multi3'  
> > 
> 
> Known error, duplicate of a different build.
> Really a bug in gcc, fixable by changing the compiler version in a test.

Got it David, we will avoid further reporting on this. Sorry for the false positive.

> 
> 	David
> 

