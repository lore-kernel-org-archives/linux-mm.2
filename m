Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19962F54AB9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49D746B0099; Tue, 24 Mar 2026 09:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 426E56B009E; Tue, 24 Mar 2026 09:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EECA6B009F; Tue, 24 Mar 2026 09:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 14BBB6B0099
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:32:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B471CBA2E4
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:32:45 +0000 (UTC)
X-FDA: 84581046690.24.3BBBCE5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf29.hostedemail.com (Postfix) with ESMTP id 03A2B120011
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:32:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XlVw29nN;
	spf=pass (imf29.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XlVw29nN;
	spf=pass (imf29.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774359162; a=rsa-sha256;
	cv=fail;
	b=G1GbEXNXFjXLz0O2oBFS6COKY9RMjT4tvkAiX1EZIX0ORoySyQcM/pB565eMoa6RfNAwHN
	tIyfWmZxhihDf68jPEk/XjRJvVtgSiUvwtGUYgdbdI5MRHmlPBebpUrHYVmblRXIo343Xk
	C4T/dcPINToM6hjguyvyZCSfh9zCmrc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774359162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=aYWwJGliSTlqfMOK2RPHUdDE9oo7bGfiwuYQEYAvZjg=;
	b=BHgDbhgKtmFTCl0Q1eELk7M7TaEAeF7W8ea62xsgSy1sGA1QmFVN/OUcwgs/PzjV0VCFE6
	qFPDeXYlsPLNj6g/fIE3bhG5YpX/AwVbp98bJHP00IbN7rMTz65iFpydCa9biJotBxCegS
	KgekBHV97al1ml+pi7t4pW97B3jdgCY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774359162; x=1805895162;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=tOg/hDQkdzdd3wCiPPCy31DuW3/zQ7KTS314WIls4R4=;
  b=XlVw29nN0IDUb4cM3oQRT9SXP4T/R7MQD0RDpiMs0pAxn3C32vSI7MkT
   O3+fufrkfV+/p1SjwFCfbLvSt1pLacygxC2unumraVuGtmTH+1qIvkGue
   eVYcPtyV/aV1qxT4F0m1hQfLgvXGiy7RuT486NgeWz2sZDnv6o04b9++a
   y3eHHvqTBmagJCo4Y1ahReD6FJdR8HZ4ExBA5ikB7cZTG8vl2iXqrUl4W
   9U9Z4/Iekr+EArikiul255DTG9PQZvJJK/Mdd8TrCknlRK80KuuNG72vN
   VYnPaEX1BmIUTan7OzD2X64r6OLEOjf6f+lSxl+A5lHnsmuVjv9woUQf4
   A==;
X-CSE-ConnectionGUID: YyK8uBXoRVObSCy6Cdqx0A==
X-CSE-MsgGUID: 0PgvamiLTHecixk8MbqTpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="79231486"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="79231486"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 06:32:40 -0700
X-CSE-ConnectionGUID: hRqVgU1iTieisWH6OM7llw==
X-CSE-MsgGUID: QQqIo6GFRQuzwRx3MHmmnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="247428373"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 06:32:39 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 06:32:38 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 24 Mar 2026 06:32:38 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.12) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 06:32:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g66QldvrCuXAGjlkdGfb2nKuewcVHhYQ1GpTTswKS7G08LHio0nhkMJy/QAEdX+rdtSopywGuSlMPFwoEiwhYnHXeC7U23z2kPxOrblVYiN06T2q/8UQmoVymeaisB6va+kz4LMrBH4STyfatO8bl+c5nZtR/OAdKUfMMFdaaiugR3PRDM8yabvPqaFC3sDCvGaDNIaBggAw66JjZ8QS3iJ6PrB12Ic+57ULx6AZs6tulan3MiQcVdUgmSgt1K97Vftfv1KjAVkZK57fRA2R6dRriKcVoSEyxyr1hl+ovAtHJaqCAq+14P540keW/bH6FWP6ZKbDLAFnGGiHzkEyNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aYWwJGliSTlqfMOK2RPHUdDE9oo7bGfiwuYQEYAvZjg=;
 b=FXORnHUe+GI9YdCnNO5Cd9IY6NbcN4roiNh2Z/XwRQbfyoknXG0IIQLh2i3jg5gWK3yHFR6VouLVN7zzk6iJPvf95bD3dZFcLqaI8x+R810FaO9rVA8QYVLPqfZ5J5ClP/K/gpdZUUNg8BeyCuu90KQar16GpisNLBqYtxinx2xdP9vLJgajt8w1WVGUbEK3KgMbiSmbzLN31u7ljIL9R1+lV2NGTSK1HsJbB9/L5YEQ2rQX0gYJH82DGV7AuFJ8gnOq4KKichskc9qeWNh7UckVDUksxUVcFQ11CHIP6kphZusXDleAkk9RuQA47QNiajtxQaeteioxJJp8R8plsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by MN6PR11MB8195.namprd11.prod.outlook.com (2603:10b6:208:47f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 13:32:35 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 13:32:35 +0000
Date: Tue, 24 Mar 2026 21:32:26 +0800
From: kernel test robot <oliver.sang@intel.com>
To: lirongqing <lirongqing@baidu.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Uladzislau Rezki
	<urezki@gmail.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Li RongQing
	<lirongqing@baidu.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH v2] mm/vmalloc: use dedicated unbound workqueue for vmap
 area draining
Message-ID: <202603242123.12c0dd46-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260319074307.2325-1-lirongqing@baidu.com>
X-ClientProxiedBy: KUZPR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:d10:33::10) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|MN6PR11MB8195:EE_
X-MS-Office365-Filtering-Correlation-Id: 06e6e4aa-2a78-49c9-02b7-08de89a9cf68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: hANongPDjSpjZiZuz+A+T6R0B3LFrZ+NTT6cinMNA8/ZRKp36wRcv4gKhtD+0TngU4i3iQhRxxy6BJExtTGZrv9nU7DrgGWM5fcJ0IP/veMd25qr8ly1TefPg9zJwc9WU+kHLx/Ro641sWvbqsZ+caysdkp/mJVjootQjrYwxr+LKGVCmrKHEUc85eu/2yq2hGBEagPm9YRwlElG437NsrdaCGiW9kLTxjiyQz0hInhsW5FnEteAcF9IQlRaAZ9Ecgb/Eaw+5f1nAm8/groPhB3BjsgYhoxai+mxohIOKMji2nUrws+CnpBOE901HQU1WGo+d2UdeQNkvJ6Pm59vGWat+GFu1nsr8F5iD8Y9vs+yHBa0Gxww+Q5zHKDhys+LPlST0qV2faBk1rXRbT/aSilbveZlJMeL1Qe9txag5ekApsPZlZogPbyFF0GRIFdLwsgEUiqFbBh4u/kJNDNFQWa0eVslkOf6x1wS4iiFvznNqJni4XkDpurvxQYx7vTpHVtyRk/sEMzE1REpwlg+hTziigjF4Qserw0HQK8bF0jdoQnIbMyXoYiJaQcIDsngd4R158eQbDOJrCUJafg7FMeceL8VVYPtHWS6ZjutpJ7C3vr+bYCtfR6IHA7o5bazlxJqQtT9LmCSg3VzqB1W1m82SRQguZbwwzeguM49d4fN8NdVUbiKydKEGlxp0izh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TOcjFzHzzBb9EnJs9JrzmQdDQLhDr/s00S2jOpzVc9k//c+9wr8Gf7E3RDc1?=
 =?us-ascii?Q?hE+O+us0ww38i4CcPxtI2RdhXYh6+IkLPwiCZN/qGcq4ar6cN0bjwo03e+Oq?=
 =?us-ascii?Q?VX4We+HPgXTToMTBbLcWAHHmHAQf1uCl6cbQYO2kLVtsWRfV3n4wozmM79Ul?=
 =?us-ascii?Q?sZ1af1YM+gEHDjZSc+h3+SMzJD8A+Ow0F71a5PU1uDjrJycZGfn+AAWG981N?=
 =?us-ascii?Q?Ut69oWLDHU6NuzX8VlsVXl7faoxdK24tNHk+fRbVwy40JrAnPBJaCoinlOUx?=
 =?us-ascii?Q?nJLs86PhRJd32OtfGCfu193GN1x9sdUni9T8U2fALd8UmgXnRRQpGviKQRxw?=
 =?us-ascii?Q?JQQH/WAODv4a+CzgNoVT3OMTyqLvMdK5ga7etXww5BVMdQLhvopA8LjhHPyi?=
 =?us-ascii?Q?cO70wCB+HHxCPxzJ3G4Sw5fvvv2WcIyUEHWxsaDLVHShzBV3yrlST0doYQ7S?=
 =?us-ascii?Q?bSTOmg00uuAiBcrpN+idmW2FCEOKy6bA5u80ItRT7gdRBEde6pyfcNJe+0LP?=
 =?us-ascii?Q?/kPHqApyeyULNoDdgEzGmOlSmNJs1Kkdpuv8tO0hpLQJefLqPT6dwfsWCd3+?=
 =?us-ascii?Q?SN3fjrCavAUTzZOTuzmLd2r4zgi/xtokqsRgLUIm32yvrnTZwzchNnQi3p20?=
 =?us-ascii?Q?qEg6pvfvAFsAH+3eNSuGOLD8U+0eZgukcr+B9Gkt+sd6x5gJOmRzNR6rZNBK?=
 =?us-ascii?Q?5DnFBCEYeT6rxH1cPBv7Qg/iz/rkP0YXq5+spoqD2Ns1d4cAZZN46yK7JGxm?=
 =?us-ascii?Q?32pPUW3zQ7pv3k53nxb3ZA3r166a99eEnJ4MJlJxJM11q6Tpq7LzjeEwpgv5?=
 =?us-ascii?Q?pONla5CyerNpfFQ8ENdPFxvYpgvYv4KEAVkYE6hB4TxcHOM2ZJyI0hzO6Bga?=
 =?us-ascii?Q?GYE8fVCabPZugKSZf1mUoaQoQ6vrtcW3eRhfGQ35sOOkhzT7BBpb6M+vKFx4?=
 =?us-ascii?Q?m91MNedm7bR5EmMCd7QKg8AEJRzGBJQ2+8vGIArmSJZhFV7La2B9NqJtLjS1?=
 =?us-ascii?Q?zuVZ4UFbxJ3lRI2pslqN7ZHPz9cXADifu6zyksQvyYsDUm9AAZbqLQ6Uyg8J?=
 =?us-ascii?Q?8Nk1ghgzamDfplvFLkV191IbYgAVxuwONYX8XhSUxcXGH/4qKLt+JwcN0ZCg?=
 =?us-ascii?Q?drQjSNO5DcCBesPav3LJ2wJuqcqmOxcpjqOUUGzxA0xPFvAzGZUv6kCitRa5?=
 =?us-ascii?Q?Gk+WcIGXXCZ3AJ6WgQb7j+giuPrSMPFTyjaUG3SAx2/xZpg9bMhVi8Ms1Uk7?=
 =?us-ascii?Q?StBPYAgVAXDvhTQ//Uuql2nCGAVvfeOUP2Boy+yHh1GqtaHtQ47GgmMXXVYn?=
 =?us-ascii?Q?bSOyjAiZj2rIiUzUh2Lm+HXPcHtvyDjgxzP46xrfVg5mv80oHkid05bbHWIj?=
 =?us-ascii?Q?q5pvu7RgxyhA7Zrxbje0F6iPGtaoR7acNa36TpxDFOrCgWKKfnkuGrgmxZzw?=
 =?us-ascii?Q?U+aYMTLUxVcsvGaNHBmmspcQ6+p/VCWxY1foe1nG1dU07JJjPfzVrgGjKnIa?=
 =?us-ascii?Q?f1Ib32fmW7Sj767LhwSu1/8lsvMspAvcTL5fUFRujl15PvxJ8p7EVUarzu3V?=
 =?us-ascii?Q?z7gvx6RAADihyKjZKXyRNgtHzEus8dZn5IL9IESm1wupyO/weBDxZa3Jkr3C?=
 =?us-ascii?Q?f6nvjFN216QB9I+8wMl5QEVo3Mmh9Z4H8fpOyGu+VvvIBBUteAF7yQdIpQbs?=
 =?us-ascii?Q?TSOtZKuwJAEhGEg4UFLkNsralrKaeSRWZ0s8rVTUih+6Zw3qUtlB/tDdHHJR?=
 =?us-ascii?Q?zBntBbmnvg=3D=3D?=
X-Exchange-RoutingPolicyChecked: end7GbwujzgLwMmwqz3vC1UP+vEBA0sdnwQT7K0gJFXLAnVyJpM8QLmENeaocPC19iv2PHanal2DD1WDQdx/3KfND6ElYx5uAiJ/BzoHEKfX1CQwek2cDPn2Sa8IDce/Fi9UfyoZU5eRUTk4RN2ywa4g3bGB54bi2qTnllC3Ayiay6ACazREfzLldlh86Y2VgnOht1bSKD7ewUIu9RTSlt6ddVhhZv1BBDo2n2dSoS7AOiIiPhllaP54MF6VnqMuHU6qrkgGNafnqRrGLfHvEwhqVdtGcRzPfsj7KcCzfofi3tbkuZSwNSDntx7q+2aEC/YcCJLKE7yCGv9xpeufGA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 06e6e4aa-2a78-49c9-02b7-08de89a9cf68
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 13:32:35.7250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rm9rWsJbISLoo9/DVrS1S+ebqEkJpeDXOH3cHV/UGzVbX7/JFtZNsLLWyen1STUHOrwrKWy+N90KBrYTMTfoMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8195
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 03A2B120011
X-Stat-Signature: huuum7tdo6fq7o7u5355cbjfxjn8gpba
X-Rspam-User: 
X-HE-Tag: 1774359161-270454
X-HE-Meta: U2FsdGVkX19AcIhXEiKGK/uzqCkG28xLpinkafDYiaOCKbkyPTTcrtJu8QF117DdtUJVxAIPqpmGPJwYo91CimTN4AG6o323WXSPm98/g4vgdsmdtt3DdgSzacBLetG/AGmnFDRKUEMU6XP5+FpzV2Ob/60gxhScopqu+yFBA48SLQSMXOp9FMIwfh0b25TB1mMKdG1ynquTB98miRO4mak3UlxudB95Gh9km9iUkLgfPkodoQE90jsm4nm/ZRAWkS9zPzFH8/XT9iMgl8j44nNsgGjgekzQxTdJinPv+qEqcL+nfC2lR7vbcHqyxropyKq39hFaUQOQgD+LLmKKgwYQGj1m+yzDPRafhCuW0QREh5Tq17DXEzmkyhpqtsP9DXZC0/zZB6mWAaQoBdLhz00KGofIBv7CMkfiISkirQUwhXJgCjLy/+IG1Tryu6ftGsL5SAxgZOei0OjUX9S4cskH//EPk6Fj16nN8cOcMY81S3lNIs0RG0pwft3oluNM3QYAF5SO1tIpAa3FTMtXkob8658pQhT+Pa/yGUqvYgPGoH3nxJ0b7yKoE0yrOzRW4kdNuNDYIzcaArny9BUD61jyxOQ8feC+Fkd9lxAi4OB5Owv41Mq/Pp5Irra1b+KT6erhcIwH+qCkqlO/usXmlUU1PH/q7cq7tC7piTdTOIT1UdTeqEMe39FxSjf1Z/j40hJxhiA/+6Bz1jd5+IckkFOLrsUp9zqiMq+O9VTSa+VK8IsntKOL8wMPTALrWva8Z/BJSaD36hC4mcQSgHRzqED/FK2jDgJ9UpJ3nnFDLdInoZBK5K0O98Z4PptllYdoTU7PQewg2+8DD1IZA6jQzxrSGyhRB7lX6U2x7OSyrFSD7IkFN3Z98DGaX/SLY1OTMZ+3bPlSGJvsTNKNykbCGXVQaVku4JO7tKr+t2+LepCT8+G03mbKp9dWqGBajFzw7saGTEzan0U8czsydJk
 uEt4MJJ6
 PYmMkoz9yqmCrj4akECsa6xoUNRPl/PXD+h4epAlYOyE1U2Q5HfA2x57euNik4Z6RRlK/xmRl0PHK7KOzc6VXyRHuI0R7u61SrurTvIFpfrEBouN3w+NZMSpNmSh069sX9czQMXpBpIf6Q0f/rV0zhMXAyIexf2V1D8R4zTj6kRNkv7SWC3yKzC+7D6QMz6Jq1XvTz8n3MS3ELazAmv6GjhrB3mjfUWgeNjs/ndBpa0jkamPd0MuSYqhw2ukMS5GpUG5/7VEynlUP0Ve1fzYMqKK19/ctbU8I7lp7GeHQaHEFbcbQ///BATqlUYmf+QpW6okM9vKB/DhT5B8CfTpIFgYjyXEeCClqoL97h6zholaPppHSdiDdssiVaELhj+gDguOAa+Mt4EphU7UtHVVXIiO5eow/YZfoWr61o+CtCfFcbTEDfW5b6scCASEX2MI1HwV1Hpyp3gSLqiVCMqxB0/p5Gx1YdyTcoA0hrc7lfPMMVHv2KosRWBfZGeyctBYyrN8PNjbGgDugfUjHktXy9JC5t42AWMBKov9olcE1ZChTHKcmbcAU4ZRZJ1y+o6zUYgvP8vfDTehFcX8aJ6OwbTj6txu4vJ+eclQ5kgm0XhLXxSr87lOVkVwv3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "RIP:check_flush_dependency" on:

commit: fadd60891595f20eece57c413cc7654e82bf3ea2 ("[PATCH v2] mm/vmalloc: u=
se dedicated unbound workqueue for vmap area draining")
url: https://github.com/intel-lab-lkp/linux/commits/lirongqing/mm-vmalloc-u=
se-dedicated-unbound-workqueue-for-vmap-area-draining/20260319-194106
base: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git 8a30a=
eb0d1b4e4aaf7f7bae72f20f2ae75385ccb
patch link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@ba=
idu.com/
patch subject: [PATCH v2] mm/vmalloc: use dedicated unbound workqueue for v=
map area draining

in testcase: blktests
version: blktests-x86_64-7baa454-1_20260320
with following parameters:

	test: zbd-009



config: x86_64-rhel-9.4-func
compiler: gcc-14
test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) w=
ith 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202603242123.12c0dd46-lkp@intel.co=
m


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260324/202603242123.12c0dd46-lkp@=
intel.com


[   68.342260][   T44] ------------[ cut here ]------------
[   68.347550][   T44] workqueue: WQ_MEM_RECLAIM vmap_drain:drain_vmap_area=
_work is flushing !WQ_MEM_RECLAIM events:purge_vmap_node
[   68.347558][   T44] WARNING: kernel/workqueue.c:3801 at check_flush_depe=
ndency+0x1bb/0x330, CPU#1: kworker/u16:3/44
[   68.370043][   T44] Modules linked in: scsi_debug(-) null_blk loop binfm=
t_misc snd_hda_codec_intelhdmi snd_hda_codec_hdmi snd_ctl_led snd_hda_codec=
_alc269 snd_hda_codec_realtek_lib snd_hda_scodec_component snd_hda_codec_ge=
neric btrfs libblake2b intel_rapl_msr xor intel_rapl_common zstd_compress p=
latform_profile x86_pkg_temp_thermal intel_powerclamp raid6_pq coretemp i91=
5 dell_wmi sd_mod sg snd_hda_intel kvm_intel intel_gtt snd_soc_avs rfkill d=
ell_smbios dcdbas snd_soc_hda_codec drm_buddy snd_hda_ext_core mei_wdt snd_=
hda_codec wmi_bmof dell_smm_hwmon dell_wmi_descriptor ttm sparse_keymap kvm=
 snd_hda_core snd_intel_dspcfg drm_display_helper snd_intel_sdw_acpi snd_hw=
dep irqbypass ghash_clmulni_intel rapl intel_cstate ahci snd_soc_core intel=
_pmc_core cec snd_compress drm_client_lib pmt_telemetry snd_pcm drm_kms_hel=
per libahci snd_timer pmt_discovery intel_uncore pmt_class pcspkr video i2c=
_i801 intel_pmc_ssram_telemetry libata snd mei_me intel_vsec acpi_pad i2c_s=
mbus intel_pch_thermal mei wmi soundcore drm fuse nfnetlink
[   68.370231][   T44]  [last unloaded: scsi_debug]
[   68.464263][   T44] CPU: 1 UID: 0 PID: 44 Comm: kworker/u16:3 Tainted: G=
 S                  7.0.0-rc4-00075-gfadd60891595 #1 PREEMPT(lazy)=20
[   68.476704][   T44] Tainted: [S]=3DCPU_OUT_OF_SPEC
[   68.481292][   T44] Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, BIOS =
1.8.1 12/05/2017
[   68.489337][   T44] Workqueue: vmap_drain drain_vmap_area_work
[   68.495137][   T44] RIP: 0010:check_flush_dependency+0x1c9/0x330
[   68.501713][   T44] Code: 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0=
f 85 4f 01 00 00 48 8d 3d 65 c6 0d 05 48 8b 55 18 48 81 c6 c0 00 00 00 4d 8=
9 f8 <67> 48 0f b9 3a 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc
[   68.521058][   T44] RSP: 0018:ffffc90000357b50 EFLAGS: 00010086
[   68.526946][   T44] RAX: dffffc0000000000 RBX: ffff88810c9a9500 RCX: fff=
f88810c8820c0
[   68.534730][   T44] RDX: ffffffff81e33510 RSI: ffff88810c9accc0 RDI: fff=
fffff86670070
[   68.542511][   T44] RBP: ffff88810d566000 R08: ffffffff81e31890 R09: fff=
fed102191130b
[   68.550295][   T44] R10: ffff88810c88985f R11: 0000000000000040 R12: fff=
f88810d8a8000
[   68.558082][   T44] R13: ffff88810c882000 R14: ffff88810d8a802c R15: fff=
fffff81e31890
[   68.565865][   T44] FS:  0000000000000000(0000) GS:ffff8887fa56f000(0000=
) knlGS:0000000000000000
[   68.574596][   T44] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   68.580998][   T44] CR2: 000056337e5a7918 CR3: 000000081a872003 CR4: 000=
00000003726f0
[   68.588779][   T44] Call Trace:
[   68.591900][   T44]  <TASK>
[   68.594681][   T44]  __flush_work+0x50c/0x8f0
[   68.599013][   T44]  ? purge_vmap_node+0x6f5/0xab0
[   68.603780][   T44]  ? __pfx___flush_work+0x10/0x10
[   68.608638][   T44]  ? __pfx_purge_vmap_node+0x10/0x10
[   68.613753][   T44]  ? _raw_spin_lock+0x80/0xf0
[   68.618268][   T44]  __purge_vmap_area_lazy+0x723/0xaf0
[   68.623486][   T44]  drain_vmap_area_work+0x21/0x30
[   68.628347][   T44]  process_one_work+0x6b4/0xff0
[   68.633030][   T44]  ? assign_work+0x131/0x3f0
[   68.637461][   T44]  worker_thread+0x51d/0xdb0
[   68.641894][   T44]  ? __kthread_parkme+0xb1/0x1f0
[   68.646660][   T44]  ? __pfx_worker_thread+0x10/0x10
[   68.651597][   T44]  ? __pfx_worker_thread+0x10/0x10
[   68.656535][   T44]  kthread+0x353/0x470
[   68.660436][   T44]  ? recalc_sigpending+0x159/0x1f0
[   68.665377][   T44]  ? __pfx_kthread+0x10/0x10
[   68.669795][   T44]  ret_from_fork+0x32f/0x670
[   68.674215][   T44]  ? __pfx_ret_from_fork+0x10/0x10
[   68.679164][   T44]  ? switch_fpu+0x13/0x1f0
[   68.683412][   T44]  ? __switch_to+0x4c9/0xe70
[   68.687831][   T44]  ? __switch_to_asm+0x33/0x70
[   68.692426][   T44]  ? __pfx_kthread+0x10/0x10
[   68.696845][   T44]  ret_from_fork_asm+0x1a/0x30
[   68.701454][   T44]  </TASK>
[   68.704333][   T44] ---[ end trace 0000000000000000 ]---

--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


