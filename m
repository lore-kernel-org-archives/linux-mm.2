Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 422E5D65C7F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 23:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D8AE6B0005; Wed, 17 Dec 2025 18:59:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7867D6B0089; Wed, 17 Dec 2025 18:59:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63CD26B008A; Wed, 17 Dec 2025 18:59:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7846B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:59:20 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DCC24B9AB5
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 23:59:19 +0000 (UTC)
X-FDA: 84230632038.19.54850EE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf02.hostedemail.com (Postfix) with ESMTP id E572C80008
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 23:59:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="C/vTQiuD";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf02.hostedemail.com: domain of dan.j.williams@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766015956; a=rsa-sha256;
	cv=fail;
	b=lPwELlWea+15ikuDNcGiaW/mfE7hQgE1TD2yLsuKFpIRrSmqb6m49MVdBHwGFG0mKvgl+H
	l0NfRqFWES74ljP6qtZii7hil61Q2yJ20fdgur5zxHLX3CGpU6qr7KRiLQZilVEiVMVIwr
	9h2hRDmRcpSeV7/CGSfEhZxnmEuC8Qw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="C/vTQiuD";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf02.hostedemail.com: domain of dan.j.williams@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766015956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qX+f/1PzdYpmJ+m6uvvo9rNqf2MTQC9iiNzOxZo5nXs=;
	b=i2NqFmpv6BEvhfXfz1TT/OlYjMXj0lhvT4FKfTIr2AHywp/BP651Ht4QDERkfm3iOJjmz+
	3YLpl5xxxB6FkTjxHg18y4RB1atTXks7sPlb8HcTXY6ZZZH2BAglCpoejEPy1N67nY+eHG
	XqRQ3c4xuLPGbeUDCFIJK+A+82Ci2Lk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766015956; x=1797551956;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=uQbckFei89O32hHZEEq8yYM5MM0NdtmcZH/4F7CM6cA=;
  b=C/vTQiuDBi5LGwZPVScdBQTk6E+AO0NOQPh/4XkLltv592A+HZS8RT2U
   UO3ceZCeYfu30PqeEUfOzkVjafJU5WEgWcy0qiVLsnIBTyrsId8ynKirm
   Xfaj/VQVH9ARyPCx/8tC9fYJ6gVNaJG2ohjEX2naCfEXHOCHu2oWM4xJQ
   LtRv+bPvRRVSbRQTnf8eXdtToLJq3W3wDXxtofhvNld79iLMDUBKKIg2W
   1Dj8bzqEBilYdP4W09Itx1ALk2a0I0WEdDLmkoSGW3aE7DRb2NgKLK1E6
   +Gqoh+Rf41vREfLLr2t84AUlB5gopunP9EM8G8m5DPIFr4o5v3vzjgoOu
   Q==;
X-CSE-ConnectionGUID: p7HerKa8T4GVb7vjywfm2A==
X-CSE-MsgGUID: dri2+ptbRPCH/Gg5SaY16Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="67933104"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="67933104"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 15:59:15 -0800
X-CSE-ConnectionGUID: 9UyznW09SAyAjNGIhijQtg==
X-CSE-MsgGUID: kXFBoRI3TAyuBueHzmiJqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="198046986"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 15:59:14 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 15:59:13 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 17 Dec 2025 15:59:13 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.55) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 15:59:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X/Q7XgF7+lbhHC5w7Dd4DC2HIYrP9HnZejKzQ2SMGZZhFlFpLjG8x/wCX2hcIQZ1jko3aiGVxc5bobU42erjr96NlUpJRduWs321KYGRXs480MR2KFf9ne6munb1mMVgCDKt6szdI5ktdLB3HjmE4W7xUgISO5XZBsFDluMZjJDkY9J8e9GkKg7blDo3p7JwJl4x29JpzaCJoMfButY1rb+6ENAJuDAAwGa4xfnzGK03axrfuifJCxALZZw8jOZKxkdfJ6Tj0Pu5mAPNjP7sZaDwNpajATTSN3O6a7ZY80IorsFNniGcnD3mqqY4f6Mym4/lbFX+vq8zcczWJ/mHGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qX+f/1PzdYpmJ+m6uvvo9rNqf2MTQC9iiNzOxZo5nXs=;
 b=x4M0G5aGw0vOa5AuMKqaH1aJxfBWJFy1j2T6e0LHiUvQ/Rdg8QGuElLjeJQiUBZgYR08MhicYMw/677yW++U9rZRlpn6P4twp4LuECXNNVQ9d6XBqz/XOWAuggfpWxEXvIM4dpLAz1T4YbhzuAmdtPpwmUfUicLyzBwXYm/2/aNb5UdsocIFnQwo1tdPh+rZUdCg4KQ66WFCiXQhM2ZktGQohekY/4HglIZA/kmKAbc+AG4VfvXFsE6lHR+46oPgYXn5I8W44zQTtFMaBPH4HrkA//tPATibPOCLFxS6FlexPtDV8T+f6x/L/YuNTlfR50KbpsZZcwAyebEypG3gag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB6216.namprd11.prod.outlook.com (2603:10b6:8:a8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.13; Wed, 17 Dec 2025 23:59:10 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 23:59:09 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 17 Dec 2025 15:59:08 -0800
To: John Groves <John@Groves.net>, David Hildenbrand <david@kernel.org>,
	"Oscar Salvador" <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>
CC: John Groves <John@Groves.net>, John Groves <jgroves@micron.com>, "Darrick
 J . Wong" <djwong@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
	Gregory Price <gourry@gourry.net>, Balbir Singh <bsingharora@gmail.com>,
	Alistair Popple <apopple@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, Aravind Ramesh <arramesh@micron.com>, "Ajay
 Joshi" <ajayjoshi@micron.com>, John Groves <john@groves.net>
Message-ID: <694343cc7e89_1cf51003@dwillia2-mobl4.notmuch>
In-Reply-To: <20251217211310.98772-1-john@groves.net>
References: <20251217211310.98772-1-john@groves.net>
Subject: Re: [PATCH] mm/memremap: fix spurious large folio warning for FS-DAX
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0022.namprd21.prod.outlook.com
 (2603:10b6:a03:114::32) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f7c33f1-aa66-4171-b20d-08de3dc84527
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RkVIYU1Od1VkbnBmSkNnSzFaVTROWFd2aDduL3dZTXhZd2V6Zk5Jd0d0UTFy?=
 =?utf-8?B?TlFKdHpVa3BGQ2pzdjFSSkVWRjV6Z2M2WnpLSXN5ZFoyV0w1bnFpSjlHN1Z3?=
 =?utf-8?B?TmJxbTV4ZWRCblM0OXNhcGZsaGI3bzlyWG1YYnF4eDJuWElHLzNyM0MvQ0lq?=
 =?utf-8?B?K1puMVhuZVAxOVlyOURzZEhBaDRoeHBkZmtCbHY5d2hkVHlLamRWMnlMWnUv?=
 =?utf-8?B?Tk0wVDlTRk4ySVVmd0VHTTdHUjdEZlp2SE0rVm1SMHh1YWxYTGhOQWpYZ0pE?=
 =?utf-8?B?Zjl1VnlYbGtkYTY4d2hmL1ZxSlhUNXJQa0RSUmlwYWZzM1NHNDlxTUp1dDR0?=
 =?utf-8?B?QS9OR05WOVIreFN3ell4ay9jR3QxbTZzR1pJSjV1YkNIOENHS2dxZkhIZ0JU?=
 =?utf-8?B?Sk5tM1l4ZVFmVXE3R2FkY01URmFydkRTUy9RbHhyVTZuVVlPZkowVmtIemx1?=
 =?utf-8?B?WHVpY2pZNm91alp0SVhmelJWckR6MkFqdHBXNFF6K2ZUMlV4bTNQVEhTV0lF?=
 =?utf-8?B?TnExcmRxdEVEZWtTVnUzSkIwNHkwWE94V3Vpb2Uwdi95T1JGQmRxMU9YYnBM?=
 =?utf-8?B?TkhWRmV3bnpheUZ0Qks5MnVDZnlxeEk5Mm9BL09WQUZ5aTVXeUJtbFl4MlAr?=
 =?utf-8?B?NnordjZGYzRUc2ZBMGVMUVJlV0VmKzNZOW1ya2txR1NQM1o0MTNCZXdWN2tt?=
 =?utf-8?B?aDJUMlN1ZlRIZzN0azBSOS9NSEZiTk1yTUcwTzNFa1g3eU5sMGtEbUxiNEQ0?=
 =?utf-8?B?NEtHY0RuaE8zRVBwb1J1bnZZUG5ZZG1wZlRaTWZmTzVGVTQzWUNHa2dLKzVj?=
 =?utf-8?B?V0w0RmNvUlhRaTVLUTQwaXA0dkkyWG40MVRMUFRVUGV2WlBlay9Lb3lkWnRI?=
 =?utf-8?B?OU1nRlRnbVRDTnlibWlsNDRPMHZqNGNNQzdWNmo5b3JYWEZ4YmxEVjNFQnd2?=
 =?utf-8?B?RVY5ajcxMVl5VW9mU2xoeUFHTjB3R0J5aTdWeVdZSWZyUDFtS0JkbVFTSkJK?=
 =?utf-8?B?ai8yRDVuS1BqV1R5V2hOM1ZxTUp5OXozejVwTjk1VEJTckVta0dwZkI4Rmxp?=
 =?utf-8?B?QkorWTdzWU5PZnZSbG1rWDRQQkRLMzR5Wkwra0NpWjEwdEJHYjdNOHVLMlJB?=
 =?utf-8?B?UUtLY0FzNnpzaWNkU1ZpU2R0a1ZPdEU0YmtUOTlGQzhxOWk3OWtTakIzMlRq?=
 =?utf-8?B?cGcvY0dJcmJZZDJibTVENnpNcks5V3I4YjVQcDNENEpMaDMxMW5EclN0SzJq?=
 =?utf-8?B?QVZ4MnpTNjBsWGpjZmpsVkI5SXdsUmpKT2JheEg4RTRSK01qZERoaG5RU2pF?=
 =?utf-8?B?MDJMZ0hKMlJKZU1mQ0N0TWErZmdCMmNibjM5NkVPMGdRWTQwRVR3SWt6aWFY?=
 =?utf-8?B?amIvUHkvZmVLbTZCQVlIMnFIU3ZPdFYrUDFxTC9vd29WSnpWYm8vVnh0dnhz?=
 =?utf-8?B?dGFXVlhKUENzUWxKZjEwSGRQcGlNeGdSNFNWVlprck1ObmQybTNKc3A2N3lM?=
 =?utf-8?B?VlVJODZRYkVzeCtiVFFETzNwbGZmc0dEMkR5TGdELzRMSlRBT2ZrYjVza21M?=
 =?utf-8?B?cExKUE5KQWRCa0pPNG10allMRzVBbE83RXRWcDFiK0pCMFdtKzhpbFp0YVAx?=
 =?utf-8?B?cFhzUk8zb3ZzdlhRWVZHT0tKMk9FOGlxS2c5azlvSFJuT2xHRE1zbXVRVHJ2?=
 =?utf-8?B?UzNaZkhtRGJFTElvaHlPREtxTEk4NEZtT1ZUdmJnaE9sWE8xZWZZY1gxRXpE?=
 =?utf-8?B?QldSM0YvcDQ0SjEyRVVieWVvcDcvRlR1K1BqaXI5OWtpM2JKZ3VBeEZ0VFl1?=
 =?utf-8?B?Nlo5bWV0Zm5SZ2hxU213ZUVrRkdWVkdCRExZT3kvRTN4MWY5M3FVc3lLemRK?=
 =?utf-8?B?bHViYlNON2RtVkM1ZlZsbElMcXhqT0YyczExVTlmTG9wVXl1TjdUZXN0M3pY?=
 =?utf-8?Q?JhLK2IaHMV4OS5fthbdKGjop5eKou4kt?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q091Q2tuM2Iwb2ptSmE4VGl5UWJYc1JpWU9hdHBlY2JrRnNpVzhEQkJOSnRi?=
 =?utf-8?B?YXU1bnZyRXV3Ung0ZDFaRU1OQkZ3aWptRkJlYVdrNkNCQVVyc2l4U3lGeTEy?=
 =?utf-8?B?VGlvdDBDRElxMU9PV0FST09Ec1hxQWdabFhTaHhxVTdEcFJEci9oWTZTU2xC?=
 =?utf-8?B?RkwrcERTa0xxYmdWQ3I1Mlh6c0hiR0s2RWdkUzFxMUJOZlFub0wyNXlqb0pB?=
 =?utf-8?B?anA5U0ppSVFoVU05T2pYejRCZXVBL09naVA4aWVYWXpncXFLeVRZYUwycWFP?=
 =?utf-8?B?enBIQkw0VmI0MWlTWXgxVnozei9uN01BVWw3QWRGeldlWDZwTkhlRmhMbU1i?=
 =?utf-8?B?cE5TYW9kTjlGR0FEeFhFSWxZOWJwOEdRcnNLSmc5Y25RRmN4V1dUdXVuQU1Y?=
 =?utf-8?B?U1dMSEw2ekZpS2x2eXREdjNxN0dPM3RsZmtnZGNnQ0YxL0c5SlBxNzVQeTVP?=
 =?utf-8?B?VkZ3OXE3dVEwRUx5ZS9acTRRWUtESnJnU00vQVoySklXNG5vb01EY0tWYmtT?=
 =?utf-8?B?UC8zdmZ4aVpWckkwOVhmRG9FTHZzaGxkMGU0Q3JzYTRlY2U0c1JGdXUxa2xH?=
 =?utf-8?B?K3BYRGhHSXRRMVBlUGU3VDZPQVlrU1J6UmNYQVVLL0UvSVp0RG1ObmZsY1Fx?=
 =?utf-8?B?OThwS1NKZDdOaFI4QlBvaHRlYUlTWHQ1TlRxWi9DRU1zL2N2dWlKalNUelBT?=
 =?utf-8?B?RlFsMmlqRm45dFhhU2E2b1JQZ0VscWN1L3BpSU5uRmVSUzJyVXFhRE0zTmNH?=
 =?utf-8?B?WVRySUl2dHUvWHRoMHJpL1hLNlhqS0dSdTcyRXcyczI0bUlJYzBwTmRPSkta?=
 =?utf-8?B?aVBVM29GK3I5eUM1UzNnLzE5YTMwVVZENWxSY0d5RXh2bEhnWWJldFg0RDRU?=
 =?utf-8?B?VFJSQ3pyaXRVbXllemRxcytYM2FxeDhYcGlOT0pVL3NqZEpaK01MSGl2b3p0?=
 =?utf-8?B?RnRmT0NwRU10aWM0eWxvWk9KbVFva3YxYmdaci9OcHdPbFJYSlAwTmU0Uksr?=
 =?utf-8?B?OEdxdytJTGhhVWZqQjhvYzFMaGZBZkxsS1VFMDNheGprbkYxVFdiWXl1OTI5?=
 =?utf-8?B?UUtPajh4SVZyZzFjRTZNNlF6TTdZVDEzQUd6R0ZXSENZUElCeXplNloyeDhV?=
 =?utf-8?B?cWNBR3lxY1dYZzNlTk1WZkFDK3AzNEdIdUkrQ1drWkRlQS9SajZuRWtaMXh3?=
 =?utf-8?B?MHJoUXhXM0RoMUhpVkcwb0ovREkvVVo4QzU2c082dnRFMjFQQmJDQS9KMXlX?=
 =?utf-8?B?WldXZDhNNS9uQ1BaN2RzOWpqWktwRUlDWFhmemRzRmVKVDZzM2ZhWWc1SUJM?=
 =?utf-8?B?WTkreDM4b1U1cU1kYjZHMzl6cy9nenRxUmtLMkZ2ZmRhUzFtTWFabW92Qit6?=
 =?utf-8?B?ZmlSL0w0YWd6REVrT1Z4Z0l4WXc1WnlQdGFRQnFGajJBR0pjamVqc3dGOUlP?=
 =?utf-8?B?czFCazNCRCt6Q0ZDMmw1K3FPWGR2bktoK0c2eHNoSDRlR0hEbmE3TjJuc0wv?=
 =?utf-8?B?NW5SK095VzhRRjRXUE85ZS9YcFVCYjNaTWJoRStCZHg4dWt6Si9mYTdSK3hm?=
 =?utf-8?B?TE9rNVdBeWg5aUgrUFlWVGxyMHFud25FZkE1eEIxREd1WDg2RktvQW90emJy?=
 =?utf-8?B?NDh2OTluNGpIQTFIU20xZFFWZmpadDZIU1liV1hUNHdkYjI3bFdvQ0p3dkNw?=
 =?utf-8?B?N3RVUFVWYVh1dnNmYUFmK3REdVJkeEQvek1pMHk5VkRZQm0yclhPN2FWOGxT?=
 =?utf-8?B?MDZsY0p5M2dxMmNvaEYwWGIvay9pYkNESU51ekRqWFdVWjJ3MmUxRm9pN01y?=
 =?utf-8?B?VDVob1VBakV5eVJNamt6MFJLcjhiVVEwWWF4ZTlUN3diRDBEU3V3Q2I5U0Q4?=
 =?utf-8?B?b1pTNFhjZHhvOTNMelhROFkwZGcvVFJZakZpKzVqWGpjRGZQd29NVDdJQ2NS?=
 =?utf-8?B?MTVLRG9WYlFxNmR3bUp6bi9VMGpaeHAwOHRzMFJvZzNScEMyNU5GTkVRdUMz?=
 =?utf-8?B?bTM2dHBXQWNkSFRYMk1OVkVWSWtQUTVHcjJJVytzd04wTjBxUkR0bWEwR0R0?=
 =?utf-8?B?SUw0SFh6Q2c3cjhucU9lUzhZdEtianV2YWlaUkc2K0NJMlljN1gwRStDM0ow?=
 =?utf-8?B?Zy9NbEF5UGRYbU5JR00veXBUWnhScXNhZ1N3c1JuNlJXQXlCN2lMSU5GZmxa?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7c33f1-aa66-4171-b20d-08de3dc84527
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 23:59:09.7611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8VEXJa9cZqh0V2frSNxsFSHyaWLA+gbeRx5mM8xDP/Htiy0OkjBhDdVUWW8MWAS/3wR42AXIv8Mzy40cBbMLgGsRmhNQ5xDN040aQ2JFRIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6216
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E572C80008
X-Stat-Signature: joeta19ou4jnrbfn1yugiardhw3gamep
X-HE-Tag: 1766015955-618396
X-HE-Meta: U2FsdGVkX18tPzeS84PrzgtG8F1gX46Q89cdNafNlz0xOEQ2g81kzVFBpPab8P3EQTd3ob9GXAYMpF8NQpg3z99WzivsB1VZX7rFgoco8oDCN5IC1srPShgYfNmR6OESiDJtjQDmdskCwAy6UsUonQeLaRVUoCYs9butaw4IkFojxtVKOqBfroCSpBsX/Jy2t5RyPORXMXHCOPCu3OFfTQhHP9BKd/jlAMjUnWHEtGaa9FULYeLYaIIv7mGc6788KxMf9azqvT3dNYdV6iVBdltEOyObeK0Cdp6d7r55ZwOpXrPAykY02AFxNfW73OwEKkmUI8XU1/nQgVUh/9URRJc+E/LJ/QBxGkWMTPfWXZB+t31DkzQKGbtD/A7SE3N7Az1lMNwv3/Xy9k9cUlLHVr+7M9H1Se/udB3YHQwpv0IzIf3yPhKbo4bdkN4CIplIyPNw1KTHCxVvbCQbemp9BIqzbwfgLL3O6IADH5v+4ETDK3+mBGbEMu50a7Gm9/rAGn4Ykxv1KIT/5jlTUmPe02zrRj4mem8NoJoIJuz48JKRlbNl7n2X0u6EKCjLgjD/UDMa8+XecdO/o2UnjIp95vVw6159hEtT+UJqScy5+hHVk3dF4lPAKVaUJE6OueVu8XvuOwyp749atMDcVxZQzUiwWas2MTup4PvunzY+Ln7sriLIkVjqG9XE74gSaCdIXI+s/hDAIOv+QJI8Ct10b3NkeOH9McF8fP49AzIzWpULD9dwWQ4WnJOF9wOpzFLReed5OKmP++lyrTt+4mDl/1YDcFbp5M9HI/6Zb0Y60MgJ/k6QpoI4unGU2LbFR0W/qO5YekCiZZq/V/zOWApZguWkZuXG8DMJlG2vXgOqLnmKOCdy+twJDxR2yukPPPG3Zt41yDjA6OmkQZvgRKVz/nKEk8METDlnCqp0HruD5iQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> This patch addresses a warning that I discovered while working on famfs,
> which is an fs-dax file system that virtually always does PMD faults
> (next famfs patch series coming after the holidays).
> 
> However, XFS also does PMD faults in fs-dax mode, and it also triggers
> the warning. It takes some effort to get XFS to do a PMD fault, but
> instructions to reproduce it are below.
> 
> The VM_WARN_ON_ONCE(folio_test_large(folio)) check in
> free_zone_device_folio() incorrectly triggers for MEMORY_DEVICE_FS_DAX
> when PMD (2MB) mappings are used.
> 
> FS-DAX legitimately creates large file-backed folios when handling PMD
> faults. This is a core feature of FS-DAX that provides significant
> performance benefits by mapping 2MB regions directly to persistent
> memory. When these mappings are unmapped, the large folios are freed
> through free_zone_device_folio(), which triggers the spurious warning.
> 
> The warning was introduced by commit that added support for large zone
> device private folios. However, that commit did not account for FS-DAX
> file-backed folios, which have always supported large (PMD-sized)
> mappings.

Oh, I was not copied on:

d245f9b4ab80 mm/zone_device: support large zone device private folios

...I should probably add myself as a reviewer to the MEMORY HOT(UN)PLUG
entry in MAINTAINERS at least for the mm/mememap.c bits.

Now, why is the warning there in the first place?

I.e. what is the risk of just doing this fixup:

diff --git a/mm/memremap.c b/mm/memremap.c
index 4c2e0d68eb27..63c6ab4fdf08 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -427,8 +427,6 @@ void free_zone_device_folio(struct folio *folio)
        if (folio_test_anon(folio)) {
                for (i = 0; i < nr; i++)
                        __ClearPageAnonExclusive(folio_page(folio, i));
-       } else {
-               VM_WARN_ON_ONCE(folio_test_large(folio));
        }
 
        /*

