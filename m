Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A63AC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 00:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D76E6B009D; Mon, 21 Jul 2025 20:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8873C6B009F; Mon, 21 Jul 2025 20:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74EE56B00A1; Mon, 21 Jul 2025 20:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 641756B009D
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:06:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E10991401F3
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 00:06:08 +0000 (UTC)
X-FDA: 83689958016.27.6DED841
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5228620009
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 00:06:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eou2qAUw;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753142765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dte3Z0JUeEu/1QlH/eLLe6VBt3w3uMmtt8mwVFcw7z4=;
	b=LqpqUO5H/d7uRikx5pGICklWE0wD7ULJRAU9O+RvVTztioM0brlXTbwH7oaU6+KlIiQmQc
	PSH3Z9T/ChGPHFbfffT4LqkIE24cwJz2EAycI9zHLJ4WcOPX0pj1/hkyCEI9tFJiZ0lZw5
	X1x6sLAPA3KwqNMx+1utMhWj52waQB0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753142765; a=rsa-sha256;
	cv=fail;
	b=Ju2P9LjqcD1woSn8letddVlbOrO516cuq8ohxZRCV8uqhfS5hy8qmjRe+vM8TG3RjpVTgM
	UWOpoNYjdHC1HXHTI+UHOnYY4QEuJ9CrBBhcfIvsqm2iQWkR/lOjfCuu3CwZ1PyP9fk93X
	SHHfqfbyFGyX5FZjxj3mc3Gt3pnRQ2M=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eou2qAUw;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753142765; x=1784678765;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=6QJFYPkmVPJQiLiJd+L1iTf1l2Lcm490hUAycABdpAY=;
  b=eou2qAUw8f2He+H15CURkaLNJF4gUZplIXN7chBHO8CJemQ0Bd5qkT3N
   HDYK2Q9M1E1zFEd2FJSMJf95m8HfDSc532ZOwDAune7DMWi/1pooedSqU
   YCwwwH6Fjoi6xKRFayH3A7BqrTYxlRBfBAvTaSQm8spPPk8D9kx68SVIg
   17R9pmjL6hklkYtJ+3bM0cm2yYpYochSiD7YcUrc55sEOMBSC/SLWUV/B
   0eG2yPsAFytesqvijWz8IkEqHvAv2adTuI+CDHFQF6eFMdLIV/C5gHNmC
   lecbLD8NpWR8zQ3rfUXbC2RvJpqnMCzbUb1kbvi+rTQfvPJ6+1IiZBnmz
   w==;
X-CSE-ConnectionGUID: ZWKjFdUUSOy7S8P5BFI9lw==
X-CSE-MsgGUID: JZ/w/ok7RmqfE1UgbVMVFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="55489367"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="55489367"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 17:06:04 -0700
X-CSE-ConnectionGUID: YZEna9YNSXSa+DEsnsPtYQ==
X-CSE-MsgGUID: fcrFSlK1S2SYZ8fdPB1EEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="159302645"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 17:06:03 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 17:06:02 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 17:06:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.53)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 21 Jul 2025 17:06:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qhaZ91xUfKWzqfKdwbvwca2fwTEZcFlI0sRbWINfhmtrdRONtgZOVJjOCeMEW1rmKkdHgw94dxg6C0HzQho9ls4Jy+ANnygqBYT0PYtHv7phEVHV+5CSdKnDa1Rd6G6AWyS83CeF2PAso8cD6tvCf8oNI7Xf2ee6kEMMGwNryZXGHRAfJBgmERcTarWnOwkDMi49Qe78qQWDf63qridAZEibmU8dyvrNlUUCs1M9Gkg3bcalCSHgvZdS2gjNXU1kuzp4XozWfZMXk6pwBgxSqEX+8Eci6tLwDVIe+YJBH1jQslmSZhMvgvBJ/A3jzyGqo4FZHULEm7NUXKi2pBgiqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dte3Z0JUeEu/1QlH/eLLe6VBt3w3uMmtt8mwVFcw7z4=;
 b=grrRHkkyN1rFCtzz9u2k24gLPYSva+pz4NKgaC/R/6Vy1Ov9m6jOSlSyqX4s2JNht5zByxpAVf2zTQWB5MBr1S10qtqigXDuib0KCKVPKm30oSETYT6lDW2I/JV3RHQWae+wqwyix5200atsdKNP4yk+R3raMIcff+U6UyKW9REfzKs7DtvHuC84M28i1ocOXEqqDvrlh4eFlY0ltKX8J40HVHQ2ViOY95/FYL6SaJLMDhRUJ/9hLDKGZfs/yxE/O7Zp7dxaZLEzfjKnxgzGy6oFUSuXULryZbJ4rHJEdaJAKxrQYoohGPzSsJL5+lXrtgS+VimK6hkLem2RZ8MQPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6527.namprd11.prod.outlook.com (2603:10b6:8:8e::19) by
 DM3PR11MB8733.namprd11.prod.outlook.com (2603:10b6:0:40::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8943.30; Tue, 22 Jul 2025 00:06:00 +0000
Received: from DM4PR11MB6527.namprd11.prod.outlook.com
 ([fe80::5a48:57be:974b:8ee0]) by DM4PR11MB6527.namprd11.prod.outlook.com
 ([fe80::5a48:57be:974b:8ee0%7]) with mapi id 15.20.8922.037; Tue, 22 Jul 2025
 00:06:00 +0000
Date: Mon, 21 Jul 2025 17:07:46 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: <linux-mm@kvack.org>, <akpm@linux-foundation.org>,
	<linux-kernel@vger.kernel.org>, Karol Herbst <kherbst@redhat.com>, Lyude Paul
	<lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, David Airlie
	<airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Shuah Khan
	<shuah@kernel.org>, David Hildenbrand <david@redhat.com>, Barry Song
	<baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>, "Peter
 Xu" <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>, Jane Chu <jane.chu@oracle.com>, Alistair Popple
	<apopple@nvidia.com>, Donet Tom <donettom@linux.ibm.com>
Subject: Re: [v1 resend 00/12] THP support for zone device page migration
Message-ID: <aH7WUugkBh/OO2ty@lstrano-desk.jf.intel.com>
References: <20250703233511.2028395-1-balbirs@nvidia.com>
 <aHmJ+L3fCc0tju7A@lstrano-desk.jf.intel.com>
 <09c5ce76-f7c1-41c7-97e1-74448e6143f7@nvidia.com>
 <aHnUMTly7pOywJKg@lstrano-desk.jf.intel.com>
 <0340e202-8ec8-4226-b136-e924eca00309@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0340e202-8ec8-4226-b136-e924eca00309@nvidia.com>
X-ClientProxiedBy: SJ0PR05CA0199.namprd05.prod.outlook.com
 (2603:10b6:a03:330::24) To DM4PR11MB6527.namprd11.prod.outlook.com
 (2603:10b6:8:8e::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6527:EE_|DM3PR11MB8733:EE_
X-MS-Office365-Filtering-Correlation-Id: b7c70b75-6c88-441b-3aa2-08ddc8b38a8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OEZYTHBIcXB5aFhhMWRGNVZucktlaTZ4V0ZvK0lkTXpLNWc5UVJvYTBUN282?=
 =?utf-8?B?aHo3bzVSaHV1SVd0dmZIaWNiYVc0RW5QRDBvMW1GZjBkN3dtVWJZQ0pHWE4y?=
 =?utf-8?B?bVN3a3QyVG1QQ21CdUhhRWJWUVdsTXFJclRjQzJWcGlLdytTZW9FRTlSR1Zs?=
 =?utf-8?B?T01OZUx2elJWQ3lhSk90ZG40Zk9GMUNCTmNLVDB3ODArOG5CemNTclBsc1lM?=
 =?utf-8?B?UnZzckg0N1B6MVVPL3NHalRLYXNieUpWT0xqeFoyZjA5Z0NvZ1hzRGsvdjdi?=
 =?utf-8?B?YkVBZXp1NG11djVJUGVrRmJiTE04ZThUTnlwWHpiQ29pUWV3cXBsZEU1YkVJ?=
 =?utf-8?B?M2J0eGQxUmFHTkh5TkFpZzY0eGw5RmZYL3JFWlVJcjBvOXArMFpqbHVRSHBm?=
 =?utf-8?B?RlBxK2tXT3cvTlM4NHhkRFlPTVNHc3RhTVprYkhMRW44cGw0SVVSNmgvOEZo?=
 =?utf-8?B?RFVqZ0NzOHFuSmJCdzlML1JGWGluUGkvZy9VaXY4cGx2WGtEVU5VbEswTE5t?=
 =?utf-8?B?YVlFMytmbDdQVWhEcisxYnkvSTB0R2kwVjFkZ3FGY25wK1N0aTF5REFabEkv?=
 =?utf-8?B?S0RiOWVBVGsrcllvVUNkN0FJZ0RFYldvZjJoS3F4Vjdwc3d1R09IYTVrZnBE?=
 =?utf-8?B?N3FEQmJYSDJhdzRkbGRRNGdIdlN2Q0RUOTVYZ1BYYm9YVUxsUHhGb0prSWFt?=
 =?utf-8?B?bTI0NzRQK1B3M1FCdytpbGhSUTVYRXJhN2FBVXlPZXhXMUluZy95ZlJObEwx?=
 =?utf-8?B?S2ZwV0NwR2wxbnVFWXVZamNobVhpVktaSHlxUm11V09kbXh3Mkl6T2hSbkNB?=
 =?utf-8?B?MVNXZW5FTW1VL3RPdURXYWlIRmhqbGlXUU5DVzdBajhVays2ci9Menl6RVVO?=
 =?utf-8?B?Z2IyWVlLSWt2T3hYb1grUmtia2wxVUxMUC9YWjhoTzZLaEgyQnVXQVJrS3hU?=
 =?utf-8?B?aFVLT3pPeS9QTWhoUWlMTUdGYzdsUUlLRmgvc0M5SWllTDUyejVtMEw1bUtQ?=
 =?utf-8?B?UkF2SmFvUnRNV1pMbURvOGRpSU1ScG9jN0oycTJld1V3cmgrUnN3L3MxQ1Ex?=
 =?utf-8?B?QTB6OVFXZTJCeEQyVFNVZEJpaStyWU5URFVrbkNYMVZ5N0F1N3QvWllLaGpU?=
 =?utf-8?B?bVhyQ3hVek9ySDJtVTZPL05iRTdNTVRwYndRNVZ2Z1RNV1VxQkZHU28yL3pn?=
 =?utf-8?B?ZU9QeWxFS0NySldIREhac29PdkFTc1lSdndwQldQdGJwSURLTTA4Y3NxczdV?=
 =?utf-8?B?TitOd3kxeTlONmkyMzhBZWkzaXBPS1NxQUlLV0tRRURHTGEwcFJEbEpiUmdR?=
 =?utf-8?B?dkpGOVlrYXF5bS9aZG9va2FwSWRLTmMxNWpOam1CL2ZVN3E4TWdPSERZV28w?=
 =?utf-8?B?RlRYdUtEWFJ4VnpaTitoSXJsRUJ2KzR0NjZSQnBYcE15blM5RlBrUVlEN3ZD?=
 =?utf-8?B?QWJEeGZrRGU0alJDZ1JPZW50NEQ4Q2VIM2pKdmhWTVdxRk1MU050QzJFbTQ3?=
 =?utf-8?B?S0FUYmsxZnNKRFQzb21iWTZkcWNGcDdsK0lRRXZyYzYvd2p4bEt3UWR3WERV?=
 =?utf-8?B?Ykl2R1ZkUUI0VkRtZ1FYQko4czZhNmRyY1AzZWFFYzR4TzJjWWVTN1pvYmkv?=
 =?utf-8?B?OXc5YzZjZGNtb1g3dGdZREF2TlE2czVmUXdYbkZaOWRObitaVityNFV6eDZk?=
 =?utf-8?B?clgvZ2dwcjkvMlExQWhkWW1Ca0NmcnpUcVcxNG9xblAwNlNQNnN2ZnZqa24z?=
 =?utf-8?B?Sk9ZbnJuQ2hlMVd2K0k3aEN6Vlg4T2Fta2IyQTZNZVZhYmRtajFpK0V0Tm9X?=
 =?utf-8?B?aXJRSk80Ni9wZDlwaGg4TDdYNDFzNWluYmxzWmRObG5odEM1bXZMUWlzOEp6?=
 =?utf-8?B?Sk5GSHRkbDl4TFFocU5OUlVpYXBVVWVCS0lla0lKVVZPSzNwT21lbXMveDZ2?=
 =?utf-8?Q?W1WqGCGJtHk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6527.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWZ1bklUV1NjZHA1RXFwamp3c3Z4T1dObU5nNFIyMndnV3pGSStvWHErSnlG?=
 =?utf-8?B?MEEwUEY0aUFOOWNnM3dIeUFiODdrZ2NlOHM5WStWY0JLbkVWUUg4bjNqV0NP?=
 =?utf-8?B?Nm0wMWlkSFgzUHhPS2h1ZTdsRVcvZ2pxRXY0QjBDNFZUbDN1M25MMW00MmYz?=
 =?utf-8?B?L1FZNXBCSGFIa0FWd3B3YThVcy9wQWhFSEIyQU5xelBSRlVpRmZwWTdBK1Ft?=
 =?utf-8?B?RUpzalUrYmdQRXFud0ExdVB2ZEpSWUV5UXE1alcvdjJGc3NUbXBvemQvN0g0?=
 =?utf-8?B?RDloS1c5eTY1bzB0Yms5VzNLZHRLanZsNDM2dDFvdG5hQlFLay9IdG5Pajgv?=
 =?utf-8?B?Z0dzdVlkekxJbnRaK29sMHdWVlU1Vy84MFFBeGIvWmJucGpzc0xWVThOakhs?=
 =?utf-8?B?YnFhZnpiZ0ZKbDgyZXVkRW8xemRWazJrR1BWeGlnbXRPd1JWcFRUMEpiYmN6?=
 =?utf-8?B?Y2t1MW1EZzBHOFFESlFldGl0T0FpK1pCVW1aTnFyTUdnNVB3NVpPNjVYNGVB?=
 =?utf-8?B?dWVRekNPcUJWSXZRWC96cFo0amZPVFZBN01POHd5eW5UbCtrcjJWTjZFa05q?=
 =?utf-8?B?alI1RHVLYWkzWGhZQW1DdE1rMGMvQ0ZXWFY0OE8rQktWRzFzMDB2UFhYZ2JW?=
 =?utf-8?B?ZVl5c0toZElRQUU3VXo2RFN6TkZVQ2lOMmhjL2NDUk1zeFdqVTlKNXNaNG0x?=
 =?utf-8?B?SVhTc0ozZ25jMEtCN0t1TWJBV09rbEVtZjZJdmQ1VTE5T1h0QWZOSDVpbm4v?=
 =?utf-8?B?NnlJN0dZclA5VGYzNUcvY05KbFdMdjdIYmRRTFQvV1YrU1dSdzNSclVwUkta?=
 =?utf-8?B?czMwcXhpT1FzMHYzZlJza0c2RVFjS25XK0ZXTnNiNEY5aVpEOFFRTytrbWd4?=
 =?utf-8?B?eW95RTg2STRvRjFUNzBtZ1hLbHJEN0VHOTI4ZEVpbEtEVVR0Q0JOTG1zZnFQ?=
 =?utf-8?B?aXJqT3VvSStkWGZLU0FvenJQWms3MGpvZDJPb3NjakxKZXRveXIyQ3JKc3JV?=
 =?utf-8?B?SHZjL2ZhYWMzNEpKNlhKMWxxVGNxTURQMmZTSnRSbUpJTThjaGVSMTkzS1Jo?=
 =?utf-8?B?NUlwdGxWVGhkTTkySVJvN2F0NkVWNHNOay9DWk1rQ2V2Y1pyd05IVWxFUkpr?=
 =?utf-8?B?TndlR0xEZ3I0dkJLcDE0SHY3d2VkWk82a2lYN2QzVWpKMzdnTTQvUHo4NXEx?=
 =?utf-8?B?bStRN1RBa2lvcFd0REwxekdJYzZ2OVQ3Sm9FYlJtSVdGSGorYmlqZ2JuZGJB?=
 =?utf-8?B?R2ZZRW9KNzN6Y2FucWk4STBvQUhCN3RIUkFYY2NVNkcwU1hzSTZtOThRL0lj?=
 =?utf-8?B?VjFXdkp5QlNVOHo4WUd2QkNsWDVVMmxwdUE1RGRRaUh0QWU5WDFNUVJxQzRF?=
 =?utf-8?B?bWx4YnpuV09WaDE4YXdXQ3J5L1h5cXlqT3BBQXdRa0FRYUxBQ0QvYituNmZv?=
 =?utf-8?B?YWZGcXVmUWpIZUpTMzdVUlA2Y01rWkllandQb1lpVjArZjRUdWFPWldzNlVt?=
 =?utf-8?B?aHI0TWdPSUZTN0JzN3c1OU9McitPcCt4Q1E2K3hKU2hIdlpHNi9mVkV5VW9a?=
 =?utf-8?B?eXZKeVR4RDhIL2JVNlErazFwZmduNUJONU5naDhuNnVQL2E1V3o0WlI5ZEpz?=
 =?utf-8?B?aDVCTldad3cyNHBQazhnMWk3enNyNW8zTUJiM1FLUDhTRkdldUt0Y2YzWGNX?=
 =?utf-8?B?cklhdkZ1T2NNcUoxY3IraHo4N3ltTmdRaVlURVNKMHlMOWx3Qm5DbFVNM3hs?=
 =?utf-8?B?Y3NWWXEwbjhqalo3MEg3K0RRclJiYmYyTU1VTzFYcXpzYkNlbVpaczFoeGov?=
 =?utf-8?B?alZZbmpCbkR1RDZhR282U3NwbmRwZVRTY0dnTkRWVUw4QnpVcGRaSUpOUXZK?=
 =?utf-8?B?a0V3dVEvZ0tWUEZaWVh6NWNpRDd5RlprRUs2UnJVSXo5ZGN0MXRaR2RDOTZD?=
 =?utf-8?B?WEhnMW0zZWJ0dDdOQzcrY2wwL3EySFRzNlpwdVZPc1NVVFhXTzFnL0xTMzc3?=
 =?utf-8?B?UElSWDJRUlBORFhzZzlGME1pK1pYN25NRFZ0OE9Jb1VFblZLWHpnQ2FZcVQw?=
 =?utf-8?B?Zm1MSHVBUW1IaDNXakk1V1FLVi83QUwxNUNZcUt4N2V3QjV0UjBGMDhTY1Bx?=
 =?utf-8?B?M0c0ZFpKbWxMc1Y5K0tLVWF1QVc3K2hEQ1pJUllSaHBka3NjM1hxUmJpS1Nx?=
 =?utf-8?B?QXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7c70b75-6c88-441b-3aa2-08ddc8b38a8c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6527.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 00:06:00.7101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aUJZZyUd+4F7nKRW6nLvBFsZsF1Ux7lfQZ0qtZbSnSy3FvdYaHa8qJs55X2+lDUULve0cCAHwgjuv3Mzf943Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8733
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 5228620009
X-Stat-Signature: uj54kwzkpje4c38fi94j5oee4fga8h7i
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753142765-836906
X-HE-Meta: U2FsdGVkX18yt82H5asUjld7rvtxODeJGpDTaSTNx9p7DsqPwlSVXMQ0AFsD6j2BY8AbALq6tVj4vwLJHNBros4wUknTwr/7FA/CiEguzBZlzVb8Xim/Qr4wiQ2+j4ahX3B04e7/kLwvet17BkvgvqkRDdqe4sMZNQJyhkyEDCfVZ6HzRUvMQWKoCpYj8htbJtPf6NOttAbzxpkorhILt1jz1PAavfIX4YgqF6op0p42HigO6BtEOa8aiK1tywPg3jrdZh34gYr4qhqbBd6d5BImhLYC7hBiv2QcPeweIunqw9xJGhN1Inf1yMkesh6eI1vCECbIogiBrSm9cavfl9Sx98k/l/9CQ3Aozim/fPWGeTJmGEWnzfe1iEKhTn2wWpDxW9Cmt6E8oX35DTndmmmrmrIa+I1RMFhHDkqwhpkC2yi/WDFMaPsApNv1/YYIhh4n0zYZuedGSLCd3ZMWSbIqkjHnzgLs87eYke+MIBTZyWh7mqmaRjBz71qcur1T4I34qzaENZmybLKPjqJU15nDkoT78dxMCpXQvo165BO1iWBoFRbxWY3e6ckryhosnSQ9n1gfY709XXJIQrO/MLLmMUFAVP7vocbUxj9xNE6Zik1LbyN00wO9a9pnreZVasjq+JocV0d+MuSqAdNDBDlO+OJZ8GTlEVuFZXL5QHcQM2vxCVO7foX/fp+CnlbsBi+HcsBW1AzVdnkw1fllfSS7UDRy5RwdvtoreFUy0jwNT/3KMD3c6lhkdlht237Sj9os7VWC5AigxjNaCAUciHoHuQ17ECfpcdUgx3TGG45+rcQUuvqGu2e4xd3BaTA7geGJypPagBxh9Fepn6iZ7ezh96MLch9MB/onHb4G2FnLjiagKULChGfYep706DSEOIpnDZfUIdX7c7m1DyVo9sBj+ah5p0vFT6trX+39fjQ6SkZEoO2JOA++doK5fYax3OHXv1zyA4KSQ0RIe71
 0I8ir1c8
 7+IGV62T7iIP4qUvS23mWTd5eLDv5ka4RE42Q11LYCNRc4JA+blT9dV71wkHWqHMEnoPSJwUiDD2pAfUDUCwNt0jMrt6UlZBpspE9f6W/bSgK2s/ckcZeOftBoe6xb2G06UOJhGOcN36HmJEipViMSv7Iol2NLDS+DWcKqgDqnodLA/loy8XPDMYeDCs8qQSFL1U3exemaQTVj3U3uYwSH28+H5UdhLQDSK8COFvJPhVg2mcLYefOpVKv2AtWh3g6iHFpyp3gFX3QrNOTVuT7a8u+outBOR8WtL+imiUpUaWMbZk1XM60ePiz7VaZnkzdt79Va6fAYyB2fbh1+GWyzWKovIoz9mLeStYYI2KdxVVMRrz2bbi53rhUjwfOa0w7u6NEGaRDyQREXg2BKYNnS5dGGGMOFfgLK2jRUcvKLtKkGjQmJKPNaPbp9RKgFbvsmOEoEp/eFV4MTWmP13gqhW//h3am9hIHDyZgFyqQ0Z4SxhcHn897tuzERe53rLoml3gDhrOLPR3Cvq/Y1QKMVBe5bxxTLt5iuSeVFmLCdbH0NQ0pUNZ/bwHNEUDSMjPBeiez9469SHspAnDP09NS4SCYbGpiWv0gP/av
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 09:48:18AM +1000, Balbir Singh wrote:
> On 7/18/25 14:57, Matthew Brost wrote:
> > On Fri, Jul 18, 2025 at 01:57:13PM +1000, Balbir Singh wrote:
> >> On 7/18/25 09:40, Matthew Brost wrote:
> >>> On Fri, Jul 04, 2025 at 09:34:59AM +1000, Balbir Singh wrote:
> >> ...
> >>>>
> >>>> The nouveau dmem code has been enhanced to use the new THP migration
> >>>> capability.
> >>>>
> >>>> Feedback from the RFC [2]:
> >>>>
> >>>
> >>> Thanks for the patches, results look very promising. I wanted to give
> >>> some quick feedback:
> >>>
> >>
> >> Are you seeing improvements with the patchset?
> >>
> > 
> > We're nowhere near stable yet, but basic testing shows that CPU time
> > from the start of migrate_vma_* to the end drops from ~300µs to ~6µs on
> > a 2MB GPU fault. A lot of this improvement is dma-mapping at 2M
> > grainularity for the CPU<->GPU copy rather than mapping 512 4k pages
> > too.
> > 
> >>> - You appear to have missed updating hmm_range_fault, specifically
> >>> hmm_vma_handle_pmd, to check for device-private entries and populate the
> >>> HMM PFNs accordingly. My colleague François has a fix for this if you're
> >>> interested.
> >>>
> >>
> >> Sure, please feel free to post them. 
> >>
> >>> - I believe copy_huge_pmd also needs to be updated to avoid installing a
> >>> migration entry if the swap entry is device-private. I don't have an
> >>> exact fix yet due to my limited experience with core MM. The test case
> >>> that triggers this is fairly simple: fault in a 2MB device page on the
> >>> GPU, then fork a process that reads the page — the kernel crashes in
> >>> this scenario.
> >>>
> >>
> >> I'd be happy to look at any traces you have or post any fixes you have
> >>
> > 
> > I've got it so the kernel doesn't explode but still get warnings like:
> > 
> > [ 3564.850036] mm/pgtable-generic.c:54: bad pmd ffff8881290408e0(efffff80042bfe00)
> > [ 3565.298186] BUG: Bad rss-counter state mm:ffff88810a100c40 type:MM_ANONPAGES val:114688
> > [ 3565.306108] BUG: non-zero pgtables_bytes on freeing mm: 917504
> > 
> > I'm basically just skip is_swap_pmd clause if the entry is device
> > private, and let the rest of the function execute. This avoids
> > installing a migration entry—which isn't required and cause the
> > crash—and allows the rmap code to run, which flips the pages to not
> > anonymous exclusive (effectively making them copy-on-write (?), though
> > that doesn't fully apply to device pages). It's not 100% correct yet,
> > but it's a step in the right direction.
> > 
> 
> 
> Thanks, could you post the stack trace as well. This is usually a symptom of 
> not freeing up the page table cleanly.
> 

Did you see my reply here [1]? I've got this working cleanly.

I actually have all my tests passing with a few additional core MM
changes. I'll reply shortly to a few other patches with those details
and will also send over a complete set of the core MM changes we've made
to get things stable.

Matt

[1] https://lore.kernel.org/linux-mm/aHrsdvjjliBBdVQm@lstrano-desk.jf.intel.com/

> Do you have my latest patches that have
> 
> 	if (is_swap_pmd(pmdval)) {
> 		swp_entry_t entry = pmd_to_swp_entry(pmdval);
> 
> 		if (is_device_private_entry(entry))
> 			goto nomap;
> 	}
> 
> in __pte_offset_map()?
> 
> Balbir Singh

