Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97810C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 10:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EBE96B00B8; Mon, 27 Jul 2026 06:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89C8A6B00B9; Mon, 27 Jul 2026 06:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E276B00BA; Mon, 27 Jul 2026 06:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49BEB6B00B8
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:59:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C43901406C8
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:59:10 +0000 (UTC)
X-FDA: 85034259660.02.02956CE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9678440003
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:59:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gyYSypq4;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf27.hostedemail.com: domain of arvind.yadav@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785149947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIIzXhVIzg0WaoOrAT4nwx3X3I5cUdpd4gyixfDCZWI=;
	b=LSvBkllF+HxD96byBKD6GsOii00SWUIc1oCX5p2xZUG73h1AVg0E8EDmTmsRyQl2S3/+iC
	MF0mHUXb40MrTMKSzoCzrBtMgCuTAeW1AWhbnvl5HfkiUFAkeqoUCOvyOqBgVQSnENPvNr
	XOhveM3eOk2mYYxiMH3yIw/1TCUEfk0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gyYSypq4;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf27.hostedemail.com: domain of arvind.yadav@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785149947;
	b=xuO3hsr9CrvTbNvQiMkdYPDtdDQWSCHRaWBakh0/e0qsYgiPkdVI8duif+ExsvLtjDRTlZ
	xFZCAU1KBAP0o3OSKobk984wmePdApBHbniwEUGvRb1vhKUGc3nCb2DWGq1u3KvDlqEXlu
	Z5Q79gqhZ+17mifNkWmyNLP7dsxpqUk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785149946; x=1816685946;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S+YGaXMzbpn+FaTk8D4vhDF1hnRgjsBMndM5Wae70xE=;
  b=gyYSypq4Cjv+EVh0n6FAWWCuuYECqmWeiLqPdrm7VJnseN2TkemNq46u
   Nf0TtkuJO2theLIereww22IYc8c7mDMXRYy2XevONBQx3vUHHcZ5sSxaz
   GS6y1vKN9o1+xBmIqpf+cR4iTOf2xEWOBQhd2+XMp/CTJrQIbYfboK9LF
   FmI++UpzuW+Yzl2pDddeDDdj4xZYjUVVSmEgMhRtMn2u2HDijmMZtU73h
   EnpZYU59Qm8scX0eYTALpEPU9+SH9FiQi0MkTD2XaFoaN/iknOf2/+VRl
   6E8D1arfE1eqV1YvnE7gQr6+VgzoqKqp1yTjpC/v6AM2zwgIyh7C9pnn/
   g==;
X-CSE-ConnectionGUID: BJ7v1tuLTKCK0ksyTNIEpw==
X-CSE-MsgGUID: 1mRlulvxTcWKznsKHi/9/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11857"; a="97088235"
X-IronPort-AV: E=Sophos;i="6.25,188,1779174000"; 
   d="scan'208";a="97088235"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 03:59:05 -0700
X-CSE-ConnectionGUID: GWdzSb+USTab1v+MV83ZmA==
X-CSE-MsgGUID: 8POy9/2GQkWx5KoImVkRpw==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 03:59:04 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 27 Jul 2026 03:59:04 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 27 Jul 2026 03:59:04 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.35) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 27 Jul 2026 03:59:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TcEovOdI52McmzGDxUPsvw+U8rP9sWZaiDnH1IBRZMDGJ/XaC7qMlrF3ApvmcKSqSrccQpCzmwDYNAA1PJx/jPCGLG/dAA3wLSH092lcVpNJIruOTDPnUPoVQ3kTHitUt23sCyZwpTIxWvIPFDo9kl6y9WXXPRR+CcPku+mDHEXxLLfqChMLVtj8yrewqibeILksg1E9NvtKGSOf7HOPdNKF4DDczuPZCqblFpTedTKfrZUpppvSRMBaPbB4y4Z4ACTDmhBRUslZ7pURuOKTYa4v1Og7hr2EYWiQsaAODa98rz9ty2Sb/NomsfHUZk5m6B2+Y/56XG25sbNTndNPWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIIzXhVIzg0WaoOrAT4nwx3X3I5cUdpd4gyixfDCZWI=;
 b=rElHCVftqyTC6tVO0eSLnnKE94+yzh2Dx6kUx1iWTlSuUVIWBa7jpF2j0ce7ssP04hoXwqxqNyMtKyVjbay1F6xIZkEnrUNlMlQ+BJ7qo7y7CMwcIMrXuzSPIhc0A3wPDb6ZzuDttP/i+ungR8qSehitnd1+lQn0UtW1fYhOB+NK1XPtuVmsGJDqarfRZv1ut1B1eIMic4ICEfSe7Nn5gbUKJK67ibKrEKT8GznrQPA/U+cjcuueNbx+fAPBMt72lUwg7spfcAXri5LszregGBMuhJvOnk0yUSmj2r2/ePTfjefgn6zcptT4+eqxDUSOdhsWf2m502PW1we0Ifv5qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN0PR11MB5709.namprd11.prod.outlook.com (2603:10b6:408:148::6)
 by CY5PR11MB6305.namprd11.prod.outlook.com (2603:10b6:930:23::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 10:58:57 +0000
Received: from BN0PR11MB5709.namprd11.prod.outlook.com
 ([fe80::ad31:3f30:20b8:26c]) by BN0PR11MB5709.namprd11.prod.outlook.com
 ([fe80::ad31:3f30:20b8:26c%4]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 10:58:56 +0000
Message-ID: <439924d5-b51a-40f7-bd96-42fa43eef0e0@intel.com>
Date: Mon, 27 Jul 2026 16:28:42 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/migrate_device: Clear stale mapping after freeing
 swapcache
To: Balbir Singh <balbirs@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: <akpm@linux-foundation.org>, <david@kernel.org>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <ziy@nvidia.com>,
	<rakie.kim@sk.com>, <byungchul@sk.com>, <gourry@gourry.net>,
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>
References: <20260727053920.3494211-1-arvind.yadav@intel.com>
 <0ea36640-36bc-47a9-8d57-edc886e13aeb@nvidia.com>
Content-Language: en-US
From: "Yadav, Arvind" <arvind.yadav@intel.com>
In-Reply-To: <0ea36640-36bc-47a9-8d57-edc886e13aeb@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5PR01CA0165.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1cf::15) To BN0PR11MB5709.namprd11.prod.outlook.com
 (2603:10b6:408:148::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR11MB5709:EE_|CY5PR11MB6305:EE_
X-MS-Office365-Filtering-Correlation-Id: 0306ea0f-12ca-4f78-e8b9-08deebce0d6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|7416014|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: NaIscL4eW+iInVMGfMZzyNU4M7xpJQGXtQX4r00zl3lTgImwRp9tq7t3C2Ai4uje9GSVMYVxwgTTw96g6IX9omEcX/iDTJZ+hx8Vv1h5/DT3Y4jpivXLiF/Rx48uVJIa/P/PLwdhCFNUy9ov9d2CoackqqYip1t+yhzStwP14Qv1Np5VVQe3R+SKD/rzejlFH+OzgKJYy1yXV3Lpon58mHU00ACfYaUCsbth9D2na5oSnVFvC8jd2mr51Bdg+4+sG/lPgIk+li529T0U0NOtlKusCCgHGWk5U1/TQQ7UklE4VdLoKnZotcoz5qUfu8HcMfC2vL1yMdZl5PrGv/5zXgB021h35NbnBvvqff9BuyZtOTTSCPnHvbNYgxz1cOCAYKB9/GvzUBKdS1Ev7BvViNGejIXOKWcAQU0OM/xzyrJqUcf0GIf9gYHo/qiayzRcEIyTNKg9o3yidTSZsdLHQaoajKbwqzqobpdzP9RGJM7rfz8VZcIuV9oIqB4xJPyAX9dKI6TRqx8Jty2bFQKmWPmCO0pPHK98ZCJbmpMtabrK+o6Ng0iL+6oh6U4IDkqMocakV2XqDF+ZnyKfkOsmJU8mNbVGa1p/ytYGrUoOoS+g9ja2y8flZ9VkDD6kk/8JnQ2oxxVAhqmmHwtcDc5P5DCHIcno2MRijDitkLoT8D4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5709.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(7416014)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2JTcHU1SUxETVJBNWdmWmNjb2pNc3hxQWY3RVZRaVB3eWw0UVAwZWhkY0Ja?=
 =?utf-8?B?YldYd3oxWGtqNUdFSklXcnp4OWQycElWLzNiNVpSN1Q1WGd1blhvd2M5eWxF?=
 =?utf-8?B?T01zaWUvY2lHVlF3Yi9JbU5rZ0txcEZDc3VTdFJtcTZPd0h3RVNaVTJ1Yy9R?=
 =?utf-8?B?dk5GZENLRnpWR2t2cW9uWURuV0JVazFyelB5d2dqdG8vMDROdmdiaEhkU0NC?=
 =?utf-8?B?dWhpR2dhcjJXWnBieTRmRkZHU28xR2lWcnhiUjFReko0N3pUb2ZraUN0WXFy?=
 =?utf-8?B?TWVsOGh1eE5ROEd2V0VPTG5icGdZbkR0MDhWR2JoSlBtWURnN0VaOS9zd0xy?=
 =?utf-8?B?dlFVKytlZ0kvL3h2ZmU2WG5sWlVmS2Zna25IZ0Fpa1ZZTzJhdFdjQmJhTm5F?=
 =?utf-8?B?cnBWbHdOVXM3dHRsY3VMNjkwKzg3WnllMG0wR3cxQVpqcmdxSGg0K2NSWEtK?=
 =?utf-8?B?dFdPRlRFZHlTaWtraldnTU5RbWYzTHovejlKM3p5dXhyY2NndzdxVU5SQW9y?=
 =?utf-8?B?aUtSUGFQWmJPY1U4OU5jd1U3Y29qNHZNRlVEeEpqMFhhM01vVkoxdTBxTHdQ?=
 =?utf-8?B?ekFSeStTWlBwcGEraWdRdTFhUlVhWnZiQ2x5ZExUcUhLb0huWWJ6WUQ1T0Rx?=
 =?utf-8?B?SzFjeHBJOTJ4RlVyZXlVQ3RyYW4zWjVVVWQ5cHNpei9pUjMyWHQ4RmRoWjJG?=
 =?utf-8?B?RCtqSEkvQUVwbFlSTzBQU1c0VHZYWldXOGVRRnlEcDl3MEhsZjNISWtUM3Nr?=
 =?utf-8?B?S2NjS2EzN1BtbHdmUkpWcHJJWUJpTjQrNnRGRGc1MnpyUnFGdU5peDNpdFdt?=
 =?utf-8?B?WER4cW5oN3M1SW5saGx1RjNxME11L3lUVkwzS3dhcFYxRGNtMVdINDk4T01x?=
 =?utf-8?B?cVVDTElqeG5ETnNmVjNIRm1qa1phKzhNWWxFVmZoY0p1Y0tNSWs4T0NVcEtF?=
 =?utf-8?B?dmRoVTNzWTAyNVNpWmNKWGcwdEg2cVFLS0NneERjTFhMNDJQY0xBMHRSakp1?=
 =?utf-8?B?MVZ0dHduak53SzBYQWxxWnZyekV6dEw3b1MyRitQSXR2OVh0bVJWNVNzOVpw?=
 =?utf-8?B?YWQxcmdSVHJCN2ttZUxySU9ITSt5elFmNURsN2g2VUNNWHZaYkJ0RmhBaTZj?=
 =?utf-8?B?TisrUDdOQmhTalRGNnJqUFhBYmRSOWJJRlVsZWlONC96aTkrMFQwOGcrekg5?=
 =?utf-8?B?d2dFNzNpcVBON2lSdVVLUUliU3h1M2NxM3FrbmJ1SFNZQnArRkdFbThoTUFJ?=
 =?utf-8?B?bTNMUnBQd0dxcWVUSnhLc1N1NmxxWXhwL1QrWHk2MklBQ2Q4U3FmTHlkS3Qx?=
 =?utf-8?B?R29peW1hOGRIdnByMDBkN080SUt1b1Znanl2dXQwa2JvZncrZStCYUNQQWJ6?=
 =?utf-8?B?aUFjZzJXWk1YUTRJYi9GYUJFT3FZa3BZektkNlFXbndQa1VXaFVsVklQZVZ6?=
 =?utf-8?B?MDhiNWx2ZU5xTmVFQTlocjdNcy8wUHZKOHRFSnU2RFJUeDBMZTdJZ2h0MGF6?=
 =?utf-8?B?cEhBVU5PdTEzSkhrRDJhRitmYUZqazU3aDJtdmhPTWd0ajhXY2FqS3pjOEJ3?=
 =?utf-8?B?Q0UrbHpGd09LbEU3bGswaXF6WlJuVjZ6MU9GSEo1akREVFF1bXRXWVY0dFR0?=
 =?utf-8?B?dTBPLy8rS2VLVlRXWVUyeTFadDV4VDd1V1Z2QzZadVNGeDFiWTZaYXovS2tC?=
 =?utf-8?B?UXByVng1MzRlSWt6UmRGWnRhWXJmams2eEFPOWRNZGJ6THJlOFV1SGJ3VkRN?=
 =?utf-8?B?K3h6aGRyb3REMGxDYnEzTlZPVDNrZXlTT0FLeXhpTjBzQVJ4aGR2dXoxbHNK?=
 =?utf-8?B?QWlmZmlHQjNrMUFPYVNQSDVhZUt2SFFPakhEdi9hekJKNjB2cTVRUjVvS3A2?=
 =?utf-8?B?NktvUmhoOFAwT0luWWhLc0VhYlF5bHpsRnQ0S1VUdG5HM042NVVYUno2QXE2?=
 =?utf-8?B?SFJkbTFJRmo3cUVCbzhsNUlnbVlicXRjMnBzZWp2U2VLb3lXTlNkY0ZZN2Ro?=
 =?utf-8?B?VUt1QjJ3SW1SSlhvRnJxMFduRVF1SldmT0IwK0FSZXNGbmFHdmRwV0NEa2N3?=
 =?utf-8?B?b3VHSElpRlJ5K2NOUENtcTJvQzF2UmIzVXYzOXdBYm04UDllL1JwZ200WGdn?=
 =?utf-8?B?cnlkWkZoaHk3cGFoanpWRzZyMGkvUzJUcDBpaWdpR1l1TUttWEZqQnhnZDZ5?=
 =?utf-8?B?aFZjNGVjR3lYTnRNQmZsNFV0eHZjMHBiSGZUb2xnQk5sVEh1L2hpeE95M3Ir?=
 =?utf-8?B?U3VkWVFhLzZNZVAwWno0SEhkZXlUcjBQbWJUZUpyU3NqZDVHMFBvbnN5UC9O?=
 =?utf-8?B?ODQ4RzhvVmtiUFR1NlRVSGhheGZxczBZVmZQL21QNXVsVVpxSmFhUT09?=
X-Exchange-RoutingPolicyChecked: Rvcp+HY4mpWwMz6VEtJ09nmD+uC/7CEkEI5jCV/Ct++spUQVX5k7i4YBHoVwxGYxUfFIEM2qlDSuPbnQBpFPuGCWRl1BCA0JXM0IYt+oqDiy9WpMIRogpzzPiq04s2ODPIzi4tA2W1y3aqRbgpEhaxOW+I+Ef7ktwOb6bVE+vZ7E+9LSiEmdaDJpy7BikG3nUJBtCD/5mPn6y+NyDC/jkguZiyloQZhIpmqOYwp6IZg8JuOhEmCWLyFMXbGCdy2UJ/60VrxDdtqgOx14rFFwbgXppXqukGYhL4rSC45P1CKnzHXkad4MbNkdwUcf8oF890WDEWlGfoRwC5JY2kf/WA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0306ea0f-12ca-4f78-e8b9-08deebce0d6b
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5709.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 10:58:56.7179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: as4kwLF2No/5l5bEBfY2yJVUE3sE/hfG6eAT5foOB52gQK19Hn2xdST3g9Y+P1wuLMLIo9Aa7s2jy1r90Kgtfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6305
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9678440003
X-Stat-Signature: xgoijgd66mwo5zcwgxktk84to11o9kem
X-HE-Tag: 1785149946-979304
X-HE-Meta: U2FsdGVkX19caA3Z1xhbty6L6hqFgLs/R/RUbGl8nc8iDOSf5n2E68F3/J2M7s6f669z9hWuJbpo2vhA9lo+zgPROmUj8/1DOIWscfI/s9zdP5RxyGvh4xyqVEfbXYk/I24hxBjP438h+JDIJAJtBCCrjfCG1F0niaxX/dkG74di4o6V8CRboKDeAqA4WcTKZKnLhKu+hqAV15G/4bD5EHH/ZGWekiKAzAbJIs3/J2eVxaTYreUKxZrIg69jtecdfZCbUFjnfU0x2SFEJ0Gq+u4+LsOhBeettRGFSxGFWjULQDEz4na6JWDalmIFdxrr6gZMmgp1CbRAvz9nAlnfckMyUJm26nk1enBbEypM5pyUVFVHuRQun0k9sOiRaPKn3TrFL1WzVnEIE9f8CKjwlIQQYUmswo/R04wPVIeWwMcVwoKnFBaoWK7ZXsXbyj6rcTGB3XuGIC24EHlZNGnSpSUwVpf/D5H8JN4hoxneiZO3ku6D1T/tNtkqPbhxy0akZxBJMIRH36lJSxuECyCMpNDq1TmObUy5RZ1GWBJF8eoItW03QFblsuqKpKZEhR3ZCZBjiY5VDtNZnxpdokkuNrZMQGgEX99sZoQKjcH8IoRb5ElFuQoH9rSfTIuvMtXMBsLDA3fqjPV/z5lAQu9XMpD3LN2bxget8YHGWM04spotV455pBeTHY6sVRTi8nbt5uMxg7jGp8OK1/0JiNlSDZzuC/V6cJ38Ia9yxUE3oNIDDbA1UVy64ppbnr59EPT4gWWReu5gdvx3fRmKLpZGmF7sb6XTdy1+ezEQJwE7SGS3FwljntV0iB4JtE4gvD58Qf/JLmMgOUybHedO78fqnMOP4P5IUiG1WIwSX0DZ0ouzYB00fntbrG607gRpN0NR4hgOIKRp8wDbnfncB9xQn5RRsGsutWJvTvD1gqTV9OpYgn7QRyiFqxMugA4+O81WX0a+/+xr3yV5PRCu1bU
 V/7Pk3g3
 XRNmFugtOwyW3W3SuHOuLy9XCL5GTUSn2LlZmuKSTnBedLkDrgo3ssvZDYw6jxEVA3c3uN9bbgKuPBVj+JRgjoxEnRyHveFkuyB4/AITStVFTb0AovlEgQajKpdebIyPsjIXylvmFgqacIALl/2DBglubr/gg6d1Qn0OEp3h7WSFoFLLo7PMLlktj+YB2b8q99UFl4kjjXM/tXQBuYTfwSzr554UdRWxfcPF/8jeq5raWL2OeKRyg5nbAgWocMwo2NA23xznPk8yJeHjJJMXpulJp/7SteXCGeVtT9++kdY+Eo5mg7xOe7TU6MpEeiAqEYymq0CWas/+qikj2yE+hKnz+Z/bguJlbK48AoS/s51NuKwV3gLS1LQvDyqv+kRAVm/IFvU5EiSRAugo2oiE4GajM3qzSrbywAYa3kxP6ZXPkHU482pKNK+0N69yNgJvpey5U8I1yfitE/fJNPRdL68lOYT783GBnCjKrAKpu2u36yn+KoOEg5XlxjawZqUk1UgIKc4zN/pP56BsbirbGlE/Ae6xIoaK/TP89v8UB7l2Vnv3PZ4daGYO4t2Ay33P8rPKEu1Z/m/hnkiCl0ESQh8JD6Q96nrDGiLvBweG3ITJ4+d3NH/rowEMDBQjBqLKzxbRDpxdlYyU8rgZ8lbZyFZfV8L304fmvGT+kX5DihOVoF4V2XXNSCrhk+tyGBXp2cUja0z6Uuut8kkijumuiDU8BR8sVphAfOZ3rZ6Z4q7P9jF1RDvb6iHEfYYQ66z4Qxq/2qWu5dUeZhdHFFTAxw/AtAV9xvgUp+l0j0G1IEKMMqcctvxSHUgFyCur7Ew39ol3tc0otTVUYEsL+JaRVtb/ur7gFQdq8OVsiOQA0pzYCHdLba4CKPlxcaybMYvUSsA+XJ2hy47Jqoj5HvncDDZEobAnI9/HJQqLX2sRlZh3tIDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 27-07-2026 13:30, Balbir Singh wrote:
> On 7/27/26 3:39 PM, Arvind Yadav wrote:
>> __migrate_device_pages() reads the folio mapping before calling
>> folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
>> from the swap cache, but the saved mapping still points to swap_space.
>>
>> Passing the stale mapping to folio_migrate_mapping() makes it take the
>> mapped-folio path after the swapcache reference has been dropped. This can
>> cause an invalid swap_space lock access followed by a folio reference
>> count BUG.
>>
>> After a successful split, nr still contains the number of pages in the
>> original large folio, although each resulting page is now a separate
>> order-0 folio. Reset nr to 1 so each split folio is processed separately,
>> including its own swapcache removal and mapping lookup.
>>
>> Refresh the saved mapping after folio_free_swap() so the current folio
>> state is used during migration.
>>
>> v2:
>> - Refresh the mapping using folio_mapping(), as suggested by Zi Yan.
>>
>> v3:
>> - Reset nr to 1 after a successful split so each resulting folio is
>>    processed independently, as suggested by Zi Yan.
>>
>> Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Cc: Rakie Kim <rakie.kim@sk.com>
>> Cc: Byungchul Park <byungchul@sk.com>
>> Cc: Gregory Price <gourry@gourry.net>
>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
>> Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
>> ---
>>   mm/migrate_device.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 554754eb26ff..74ac6651d4b3 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -1182,6 +1182,11 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>>   							 MIGRATE_PFN_COMPOUND);
>>   					goto next;
>>   				}
>> +				/*
>> +				 * reset nr so that only first after-split folio
>> +				 * is processed below
>> +				 */
>> +				nr = 1;
> We should also add a VM_WARN_ON_ONCE(folio_test_swapcache(folio))


Agreed , but folio_test_swapcache()  is not valid immediately after the 
split, as the order-0 folios may still be in swapcache.
I’ll use just before nr = 1

>
>>   			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
>>   				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
>>   				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
>> @@ -1204,6 +1209,12 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>>   					src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
>>   					goto next;
>>   				}
>> +
>> +				/*
>> +				 * folio_free_swap() removed the folio from the swap
>> +				 * cache. Refresh the saved mapping before migration.
>> +				 */
>> +				mapping = folio_mapping(folio);
>>   			}
> I wonder if we should change this instead to (sorry for the wrap around, I'll
> need to fix my mailer)
>
> @@ -1242,6 +1232,11 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>                  for (j = 0; j < nr && i + j < npages; j++) {
>                          folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
>                          newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
> +                       /*
> +                        * folio_free_swap() removed the folio from the swap
> +                        * cache. Refresh the saved mapping before migration.
> +                        */
> +                       mapping = folio_mapping(folio);
>

Agreed, Moving the mapping lookup into the per-folio loop looks better; 
I’ll update it


Thanks,
Arvind

>
>>   		} else if (folio_is_zone_device(newfolio)) {
>>   			/*
> Thanks,
> Balbir

