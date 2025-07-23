Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BEAC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 18:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AED76B0145; Wed, 23 Jul 2025 14:04:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 664AB6B0146; Wed, 23 Jul 2025 14:04:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500286B0147; Wed, 23 Jul 2025 14:04:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39F876B0145
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:04:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 032351601A1
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:04:08 +0000 (UTC)
X-FDA: 83696303418.06.A868BE6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id E411B180009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:04:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Baz89+cB;
	spf=pass (imf24.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753293845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EsW65FY5tbPdlVgqjgbuVYxRbAX9Dkd2Kb5BN5u8Y4A=;
	b=fKXNmhUK0L4Um8C2zuPvomO17VrA+CxQi316OCJHQ/ckjOu7irqlTRUt+bnajPgp1YajQh
	/CG61CwgsowUvQLTt7r7+MjptSlh3vhgxkldDKYWxaCZnrj074SCiJ4Bb7P/8hU6oWY8ZB
	6bgcXvpt1FVAr6Ge7dwC4mv0wSWhK40=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Baz89+cB;
	spf=pass (imf24.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753293845; a=rsa-sha256;
	cv=fail;
	b=SBtuFXFH/qzf3RKl9z/iEfWpata/NVEuwRjcx5uF7A2iuUbCPwPFRkOcyviLw+nU46wyOJ
	jddttcHfxG1MNuolN2IYl/BupPTolSPWSqnXrPObqUpt8ZLR9XGt+XLgvSfQEqNwIyNlfq
	vaGIx4v/Er0oYuu74KarWzGJ2j6alTg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753293845; x=1784829845;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=F8x2O8VQX/3W0FKqcIzTu++mRQN/K2GLtfCyo5EReGI=;
  b=Baz89+cBVGPo38FeAIJvOCPw9iOVnbWfv7R3N/3ajptqc9I07m6DXjOZ
   jOpfQjrihECNydYjNlk2LY/9XkEGtUiETE3tK0bH/PX6kJ6HSXnocFZBO
   IHRk/5udFHLLY47aKu/St1LWJd7o29RiJ9dl+D+5agbA+pNX32jnNIgWp
   kPVllWZJ7GSaSLMhmEhsAh7mEayDXFXws0zT14WbadgsEiX10JeJdX7Lv
   r9nbCOqi3qgEvq79G5oSoMEzVhSklQKWDHK6cPEzz8DVV6s+GZp+2zj2Z
   FGeG7qiaffCj7S0pG3ojAiDNJbD456zuiwxtEjzlx/iem3bCwttFAekes
   A==;
X-CSE-ConnectionGUID: XkewoUeFTdqrlOF99gif0Q==
X-CSE-MsgGUID: v1gDvgxlT6qIOPQA3CcqyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55701209"
X-IronPort-AV: E=Sophos;i="6.16,335,1744095600"; 
   d="scan'208";a="55701209"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 11:04:00 -0700
X-CSE-ConnectionGUID: amsjmIeZTvmqt3Lv5nU7tA==
X-CSE-MsgGUID: Xh03FLtRR8SK/XUiKJoETg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,335,1744095600"; 
   d="scan'208";a="160374063"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 11:04:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 11:03:45 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 11:03:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.73) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 11:03:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mR14p4Mpq/nJH2Ms/XCjMagCqXwuM+mNkrMLNQyWQi0fn2i68NmVxJSKL51jnF2iQFmPj52EIeZ0JhBMoylkKei257sirBv5hFAnSBcv3G0dDG7s2lHuyclxglFkZjSFFx7llJwsA/hj95lEB3wT3+Pg1+ZYVR608zvghAeKVrNUbqKx3BVB4e0y5b+jP6Y1MBMYfoM2zHFDmU66/n3ae3Z5FhoXj0MT4IaULq1zR+7GImfjyXeWCeXEaYlGGdn3NVg+CEjEh//rp2ls0d683hPCxZBE6mPTD9WPNPcjj0kXg64klRf6NYW+ma0GKG1D+GjNsIlp5O6WNn/ckdUS9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EsW65FY5tbPdlVgqjgbuVYxRbAX9Dkd2Kb5BN5u8Y4A=;
 b=wL0xmAGJSSmOkX7SlSNVDASMMmvUYQUMvwD34iU2q5xx8prU3WO1/av7CXCx1Um9HAEo2MjgkUIK1yNU1Cjypn90hkihclUW0KrMKGoBupqfFGwJAqo+LYNNGkZjg3eQvEfFh4ZZOZgOgJrjo52iJKflHn+jVEBqLqjs99QaJN87fGXT6Pw5TIYiODTbx70RC46wJytHPUkWpmrJmqmiww7eqyikMxZss7f+paX5bw1FR9roaRn7C8rwZaRZIgCD2ZH5kbqmyf16XEIaDpH72GzFPABLjqBxS2yWxzT8dKjZGIz0bO4HX4Irajv0xWGhIBwqTdHvyTDnZ8RNh6PiQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SJ0PR11MB5197.namprd11.prod.outlook.com (2603:10b6:a03:2d1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 18:03:22 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 18:03:22 +0000
Date: Wed, 23 Jul 2025 11:05:08 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Francois Dugast <francois.dugast@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <balbirs@nvidia.com>,
	<airlied@gmail.com>, <apopple@nvidia.com>, <baohua@kernel.org>,
	<baolin.wang@linux.alibaba.com>, <dakr@kernel.org>, <david@redhat.com>,
	<donettom@linux.ibm.com>, <jane.chu@oracle.com>, <jglisse@redhat.com>,
	<kherbst@redhat.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lyude@redhat.com>, <peterx@redhat.com>, <ryan.roberts@arm.com>,
	<shuah@kernel.org>, <simona@ffwll.ch>, <wangkefeng.wang@huawei.com>,
	<willy@infradead.org>, <ziy@nvidia.com>
Subject: Re: [PATCH] mm/hmm: Do not fault in device private pages owned by
 the caller
Message-ID: <aIEkVEvNJwcegBF7@lstrano-desk.jf.intel.com>
References: <9ae3e014-c7d0-4d58-af0e-925bcd9e4cfd@nvidia.com>
 <20250722193445.1588348-1-francois.dugast@intel.com>
 <20250722130721.9169d564eeeb28807e18635a@linux-foundation.org>
 <aIEA-a5h3Zkx87EN@fdugast-desk>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aIEA-a5h3Zkx87EN@fdugast-desk>
X-ClientProxiedBy: MW4PR04CA0133.namprd04.prod.outlook.com
 (2603:10b6:303:84::18) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SJ0PR11MB5197:EE_
X-MS-Office365-Filtering-Correlation-Id: d27a9cbb-67c0-4414-3bf1-08ddca133640
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YzRITDRxZHRETGx3eWM4U2tWcHAwMG0vWlovSjhBMFJENVpWU052VlVlQmZ6?=
 =?utf-8?B?S0gxNDBYYkQ4VkZGSGRmUTFkQjI0L2FoUy9DdkFtdE4vWkErOFNjbkdhaW1a?=
 =?utf-8?B?ME1QZyswZ2RxbWplNnlQcTZsdm9aSUxQeUIrbk4ydWlDN2ZqTkdQbUw2SDI5?=
 =?utf-8?B?dys2azBJQzBYVnpQZ0E3UmhHblF3NGNKMnpwaTVoNHZSNE1OeGdOQUk1Mmoy?=
 =?utf-8?B?eTVHaHlTV0VaL1NGRXlxcVRDTkgzY3duQ0MrQ0s4ZytKWFZ4ekxYTkZMRTN5?=
 =?utf-8?B?RWd0RUNQbFZtZWR3ZDk2c2Nhdm1JR0tvZFRBWWk4Skt2YTFwTitXdzR6dEEy?=
 =?utf-8?B?Z1lscWN3MzRyYkN3a2hRWkpKNGFvZzkyNDA0WkFaRTRJV2ZZSTVlaGVXY2tC?=
 =?utf-8?B?dEx2UVUyNXlHLzlMTWphRktSWUZjZ0dXWFExY3QxNlc5ZzY1V1lFSS9IK2Yx?=
 =?utf-8?B?bjNFM1dGckQ0czBkOGJVcjdsL1A1NFQrZ3lTQ1VHOUtJemw1cm90MGtmdTZ6?=
 =?utf-8?B?Y0hlTHVWc2pabDY2VU5Pc0oxTGQ3ZDl0d3BKUHFUeTREWVNTajhrQ3lrbFVj?=
 =?utf-8?B?Q3pZY21acjF5dk1EYWZKa2NLKzArU1RkajRqUXJJRzdZeFpJVllNU09xM2Q0?=
 =?utf-8?B?eW11aTRYTjhkWi9NMVJPVFFMbXVOeWRtVkY3UWU4dVFYcS9adEtKcEU5VEpZ?=
 =?utf-8?B?NVFCMXRGUW0zR09wRUIxd1hjRmUxQlhMNEFsdlJsbGZQdldtS2lhRXZUVldN?=
 =?utf-8?B?NTd0SXoxV1JnOU0zS2V2QVZIdDNMVGV5b05yN05qRU93SUoxRlcrcXpNcHls?=
 =?utf-8?B?c3pFaEtycXlQczFhU21iT1VJQ0ZpYS9lVFE2MENHa2ZVQjMyeGxVY29YSS9J?=
 =?utf-8?B?enJETml0aXFCV1VuSDFnWCtrZElOdEJMYzZrOU0zdmxRbnB3N1BMUnlCeU5m?=
 =?utf-8?B?MCtra09XRnZuYVNIa2loOUdNMXlwN3YzY0RXd3UwUllBdTI4bENUK01rYmt4?=
 =?utf-8?B?RTYvSUU2bGgwc3E3dWE4RWduQ21DYjY5RTg2c0VpYndGa0VwUGF0ZzlGbVpU?=
 =?utf-8?B?UEh2WmhiM0NldGFRMXJWRW0rYWpsQ2wwdDJLK3FnRDlyZGd5ZWJMaGYrYVVu?=
 =?utf-8?B?bWJ0SURrZCtOc0M4bUk2WUxibTlDemlJcjF2c1RUY3orTG5uYmNRRmQybkg5?=
 =?utf-8?B?NWtFeVZGSWMyZmdIT0k5MFFmMGhhNExsb0lCSXFweCtJUlFlSjNROW5xNHZk?=
 =?utf-8?B?R3ZxbFJKOVBiL2orMHFiRzJsR2U2cXhERy8xNGIya1ZXQkRtNy9OL1FzY1o4?=
 =?utf-8?B?SnJIZi9lcXQvZ0ttd1JWWWJGbWlXWHFZcHB0NzVTTm9ONHNqYzYwQ1BoOGdV?=
 =?utf-8?B?cS9uNkNuRlRCK2IydVY0c29tRTU0NUNNZXd0V2htaWxDZDNhTzRlSTVZdVRw?=
 =?utf-8?B?WHNKeXYvR1pxVk0ydTl5bXpjcnY2T0o4eHRmNENjY3VkYU5CLy8vK3o1eU9Z?=
 =?utf-8?B?TE9BeUFqdjZaNjNwSXNvWUhjb3EzVzVOdVMwdnF2VkVJSW9NMmtoRkhOWUht?=
 =?utf-8?B?a24vbjNIdnNqSGgxdWhhR0dGUkJ0LzA1UEt2RUJIMEZpb01XR0ZDQlJvMWVH?=
 =?utf-8?B?MzZlcWhlNlVCY0E5cVVxOXhvdHo2Skx1c2ZKdmkyOThhci9CckxkdEpzQThQ?=
 =?utf-8?B?anlnZDZSbHNjNFF6cHNyTlpMc2huRFVjalVUWUJocjdlSDc2TUNXT2o2SjVF?=
 =?utf-8?B?ZFcveUh1bFhPTkdhTGNlUFJNYW50aUNCUXdldm5LNGtXTE1mN0o3LzNxNUN0?=
 =?utf-8?B?UExFZE51SjVFbUM2c3RLdllTMmhnSHhTNmhTWnFhYzdYdS9RTWFld00xR1VG?=
 =?utf-8?B?SCtocnFoNmJaZjZUenI2d3BPYUxGK3pCVEVSbkJKQU5pbnc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDdNcmtKcWZrajhwVkxSS054SENEV25xellENDRnZTBRd3Y0WVYrKy9POUtN?=
 =?utf-8?B?T2h1U2ZuUFRYQklHM1RqZFUvOFFzU0p4S1ByOFl3bXhmcmt0MjJRRzh0WlNJ?=
 =?utf-8?B?emdhcXM1OVVzZk45WmwveE02bEc0KzhpRnZPMnJQQTVvUlNaSFFUQ0lycnZ0?=
 =?utf-8?B?ODU1N1BPK2lsTXpRekhyVG5DQ29xdUVQNEdBZUJpaXNoeFpRS1I5cjhUM3Q3?=
 =?utf-8?B?UnF3YlIweEVVYTEydmYyUEQ4a2dVNC9Ccys2K2dRc0ZRMCsyRG43dHA0dXpT?=
 =?utf-8?B?dHZoVzNvbWU1TzBRaHhYUlREbHFwK09ML0laLytWVmNMNWVTM2w5WHUrNFps?=
 =?utf-8?B?dytENllydkYyOWxCUkpTcnRSbXFnbWxUQUluOWZKQUNpbDZuQkllM1lja3U0?=
 =?utf-8?B?Vnl0WEdDMmVSbERFUktkMzRwcFFHR2JNczNERC9kNkFXTnRDTFFLdFk0cFFu?=
 =?utf-8?B?NnFaOGQwcURjZ1BCeWk4SllQTHNoeGJzY2kzdDlEaWZkZkNZTkJKRFl4NlU1?=
 =?utf-8?B?VVlsaGUycllvclVqdUt6K3ZCRENlTktmK0tjSHVHamJIbVdrWE5BdlMzaHFN?=
 =?utf-8?B?djlFcCtWd1lDSGJucHE0V3d2UEZyUkVhc0ViSDdhV2VnM3dkbGQ3WEg3Wkh3?=
 =?utf-8?B?ay9kZzErVW0wdG92Ums3WDNqSHpmRkpGcHV4a1QyVWVpT1lEWEJqY3MwOUhP?=
 =?utf-8?B?M1NWTEFTVGNzdjI5TW5PemdRQ280Nzc5WGF2cGhtWGxCV0QrUTMwY0w5d0Jt?=
 =?utf-8?B?N05tQ0c4a3llRm1qRE1MSHBuL3RiRlRuSVFOQXNqZW1XdVJJaWljZ0Uxc3NM?=
 =?utf-8?B?MnVJVXcrUmVSaDMrenFWSWRVSndnRHROeHowNHN3Q0lHYTM4SlBqK040dk5C?=
 =?utf-8?B?b2o2RzFFbnEyVFEyeTJsbmRCTWtSQzNTWml3alV1WURJdW43NFp0ZnFQSm84?=
 =?utf-8?B?NHhSblJxRmpqMUxLZDVhamZDTk40VkNNeWpuOE9uUHdUZ0VUWldDQ1hZMlJ1?=
 =?utf-8?B?QVN5WmtlT3RmUWJBSEJudUxwcTZTa1U4bnhlTWR3ZytySHRRQ0VMTWVHSUFu?=
 =?utf-8?B?NGZ4VHlsbWphcldSNWdWOFFQdVQ3aTUzN0ZJWUw4a1B3dWV2V2RCTFRZQWdy?=
 =?utf-8?B?UVBGbjNyQUNna2dJaENXUFdtL0sxMDVrU05HbDFDRGZBOWljV1NqYzlYNVVP?=
 =?utf-8?B?b0hJNDBYcTVMMWFVTTVWWlA4K252aklLVkthcE9YdXJiK0dLNG9XTjlXMDl3?=
 =?utf-8?B?eUdQSzQ2STJtdFdJQmZjcDBGVGtIQ05rdmtKSG55anlQOGlScVRxQVorRlRI?=
 =?utf-8?B?QVNIampRVnZ0TkFTWU81UitPcDFYS0lpRFNPL0Jndk9xSVliOEdZbmpWa1BR?=
 =?utf-8?B?MmxtZWc0ekJJRVhJRHFFb3RQaDZqdDVtSzR0dmNLcC9xY3hmVjVFTXJCQnhD?=
 =?utf-8?B?bVI1bXl4QTdGWEhlY3ZVL044VEZtKzAwL3hCckE1akJOT1o1N29vbXd1T0x4?=
 =?utf-8?B?WTQwWU9aU2wzeXJ6a1R5cVNURzlaTTh3STBpUjJHa05YeWtGVmt1WnlpZEtJ?=
 =?utf-8?B?eGtraDlDaGtnR2gzckdMSFZCbXFldmhoNWhXbFVhd3habXIrKzlkd3pKYkda?=
 =?utf-8?B?UnhDazB4bnI4MGtpMC9qdU5JdWJRRHVGY0E4NG1Qb25UR09PQnplNUNVK1Z3?=
 =?utf-8?B?RUZRVWJNell0NmNDRjBsTXpCSDNqSTMvWjJrZXEzMmdodVZEbkcvTTlKazI0?=
 =?utf-8?B?Tm1ONllOUXYwQVgrU1Q4bVkrRFhpeVl1OG1UQUVTV1dUTFllQ21nbExISURu?=
 =?utf-8?B?NXRXVTkySkpSRmhzdGtMK2RCVHVYUElqam1PWFZ5b1ZYS3doSndxNjlXRU1M?=
 =?utf-8?B?VEF3czN5ejI1ajN6MXplTHFZbHlRcENneldVQmh2eGd3MExEc25tTWJWMFUy?=
 =?utf-8?B?ck4yaXI3QjB0ZUlaTkZpVG5zY2ltZ0pFYThQbXFGVjVaWHJMYlc0TytJWHhM?=
 =?utf-8?B?Y3ZBU0c4MzBDK0tCRzJJaEZFRGtMeW1GdlBNajdndFJnb2QrSjJVOWtMekFK?=
 =?utf-8?B?Nm9NYXBtaC9kb2FUZlRyWk5TQmRtRHdjM2MwTDNxeG80MUIyZ1B4YXV3TTVO?=
 =?utf-8?B?cWtkSXQwSTRKU2lMQ1VxK3RubUtmNHA0cEZBR2VVOGxoK2wvRHdsTm5FSUlT?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d27a9cbb-67c0-4414-3bf1-08ddca133640
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 18:03:22.1614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3570ZIcP988gGzuFdwTwmWUlYQNB5liz45iwyatZncWpeIt3vGm2pvCb6LN6/NbbBJl+RbdGruj9V953mJWFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5197
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: E411B180009
X-Rspamd-Server: rspam06
X-Stat-Signature: phteabazyi7w5ux7qdju6w84o7wr4u9s
X-HE-Tag: 1753293844-103853
X-HE-Meta: U2FsdGVkX18n7w5ev+rUJ+SgS+SvSfvNf8aSte3K0tEjG4aGwiryLQXdUlVRnLrlxOxagZitwnHpNCuKlZT+zuwAsfXxpxiuF5VtSMsy2FvwQL/+xlXhfa7kqJOr0yOgFGiM2O2ZyFnfSd8nlVAZHAR0BLAJniWqA4lac2kdt3gc48pR7mLmToJCx/7WesTAVHMfSUy5OSG1iX7oIc1ArpSCKNsX3pvqrNQaAHgDzcoFS/of/esfXObD+07E5Z9J/O12D2HZRhqWd6mN/BZXUESGVzQWCbALgfESrwSNuGDiePLrmjv6dQ0q8KdLTFFr5u99Qa/H9VA8uBVFHeq4p7im2zDaGZmodiPsh27Cuu/+KEVtNwOCo09lIt+PG3ZQc4WesBbjHHIH4EEpRWswhjzy/UdgB19LSikFfBlPbDGXJFapE1/I2m0thSvzpTkXDqmXA0azBmJJwPpSSM40pCbV4J4CKSKItcYiHGrOS9RyiZabksbDptMSWLoSErKHCJ1eY5nblhqenSRDW6PeSZrNMDP7cwItMAUFKR0p4rnEHkdTLAMciaKado2Z6He8jIXwJ9wY0KKQbZh0keq5rZSEoxii2lqWFM6lEBAiZ44Qbds8ruIDL2e3k1SPvhbOpMMRsHRfGVhdoy/v5NQ/LPPIn8ZojjhCPdMVZ/uvNXPyp5wpk7e3Pm1kwNH3Ttqjajar/0oQK2gj0EQ5aoHzhjHp75RCNRHj4R6InCM/1hmaSd5jXW1h6JGxT4RsgeNbKrW/hr0djuwEI+VKP2CuQumET/wX6rRH8X5O7O6zkTDrnjWszC9uOOIO8ugo++yKxQ2Mv/B2ry6HyFKizms/OH2r7q0zupbEfFDaqnW3nchwQx+a8awyL6VmevugXoVGC3tbaWsd0xObmaPg06Zfmc4IP97oMKAV0/4Rx4wF/65AE2UKLfo8tu12p5dBiBUjWEscBa7S8x2RQ+D1OBM
 zzObWk29
 bBC98WulSaYePTF066y6upgfnH8hyCxZZjpaS2B5JxxqmgyNWGwedDplZUmvDCsD9I5o0sRG607krxVFAKnqMNAkeKko0I2ikdOZphn2os5H9LQjtQgeyHq7qwk2YQE9XgWIGHyBAJAr5t+pDA2QDj9n20I5O6drYwIDwdtWXZonmg/OiR43/raFEIfdAiEgoR03XKWcQEwQPutDtOGKyIhO+ZeEBdxY2+RZayAkVVD0+qbodffgefyaiE69RE2k3YKQrcnPwdXL47M261HN6AxevvzKGNVFIVDudU02xcDhDC2JlchmmiwDixNKJNbFrSGSxnLoqFaMZ9DRTuJwtambW2xdnAv96+W0TOmV5Ntvz4Q8D63D+0g3ISQHmiEqfv5CBkF9AZ39pTEikqAI9r68HpxebvrQSbYxQELXAhC/mlRZQIOTGrs80WOfGL5iBoGhTvzqWLnf0g0zkvsizu/IYPU1Sc/6v125Ajo93WJpmkMFitqrJs1zq7tAKqnANihkur3uFxpdO773a5gJqBowmkm07GiE0o/fFvytmsXCSiXxwsvPuSvCpbWSLeXNf4qhF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 05:34:17PM +0200, Francois Dugast wrote:
> On Tue, Jul 22, 2025 at 01:07:21PM -0700, Andrew Morton wrote:
> > On Tue, 22 Jul 2025 21:34:45 +0200 Francois Dugast <francois.dugast@intel.com> wrote:
> > 
> > > When the PMD swap entry is device private and owned by the caller,
> > > skip the range faulting and instead just set the correct HMM PFNs.
> > > This is similar to the logic for PTEs in hmm_vma_handle_pte().
> > 
> > Please always tell us why a patch does something, not only what it does.
> 
> Sure, let me improve this in the next version.
> 
> > 
> > > For now, each hmm_pfns[i] entry is populated as it is currently done
> > > in hmm_vma_handle_pmd() but this might not be necessary. A follow-up
> > > optimization could be to make use of the order and skip populating
> > > subsequent PFNs.
> > 
> > I infer from this paragraph that this patch is a performance
> > optimization?  Have its effects been measured?
> 
> Yes, this performance optimization would come from avoiding the loop
> over the range but it has neither been properly tested nor measured
> yet.
> 

This is also a functional change. Once THP device pages are enabled (for
performance), we will encounter device-private swap entries in PMDs. At
that point, the correct behavior is to populate HMM PFNs from the swap
entry when dev_private_owner matches; otherwise, trigger a fault if the
HMM range-walk input requests one, or skip it in the non-faulting case.

It’s harmless to merge this patch before THP device pages are enabled,
since with the current code base we never find device-private swap
entries in PMDs.

I'd include something like the above explanation in the patch commit
message, or in code comments if needed.

Matt

> > 
> > > --- a/mm/hmm.c
> > > +++ b/mm/hmm.c
> > > @@ -355,6 +355,31 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
> > >  	}
> > >  
> > >  	if (!pmd_present(pmd)) {
> > > +		swp_entry_t entry = pmd_to_swp_entry(pmd);
> > > +
> > > +		/*
> > > +		 * Don't fault in device private pages owned by the caller,
> > > +		 * just report the PFNs.
> > > +		 */
> > 
> > Similarly, this tells us "what" it does, which is fairly obvious from
> > the code itself.  What is not obvious from the code is the "why".
> 
> Indeed, will fix.
> 
> > 
> > > +		if (is_device_private_entry(entry) &&
> > > +		    pfn_swap_entry_folio(entry)->pgmap->owner ==
> > > +		    range->dev_private_owner) {
> > > +			unsigned long cpu_flags = HMM_PFN_VALID |
> > > +				hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
> > > +			unsigned long pfn = swp_offset_pfn(entry);
> > > +			unsigned long i;
> > > +
> > > +			if (is_writable_device_private_entry(entry))
> > > +				cpu_flags |= HMM_PFN_WRITE;
> > > +
> > > +			for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
> > > +				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> > > +				hmm_pfns[i] |= pfn | cpu_flags;
> > > +			}
> > > +
> > > +			return 0;
> > > +		}
> > > +
> > >  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
> > >  			return -EFAULT;
> > >  		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> > 

