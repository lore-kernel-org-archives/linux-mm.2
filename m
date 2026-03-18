Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFD67FCD0C1
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B1C6B0101; Wed, 18 Mar 2026 03:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413486B0103; Wed, 18 Mar 2026 03:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301FB6B0104; Wed, 18 Mar 2026 03:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17FC66B0101
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:35:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1FB28BF82
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:35:53 +0000 (UTC)
X-FDA: 84558374586.26.9D19800
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7FCEFC0002
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:35:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="YSnWb7/r";
	spf=pass (imf28.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773819350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oYxJdilKEH+ktJdkf4f81N/WmxCR6b6pcpOpnQz0rZc=;
	b=f1ugDrkFrk7/+Dwb+OQPeH41ILgq3v1i7PlJ+P5unXjoi0KAUJTzmb6d8JCG7FdtLZnWwj
	W/5bYSzsyFGEMAKoFyDAW/DkX4wxdT80uElz5sG977RY/xHAq/RWXoUhPNs8AySaNtpO62
	1d3VPuQGrNtWI45umpmNihEW7ed2emU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773819350; a=rsa-sha256;
	cv=fail;
	b=IVwjnNTqV4tROMaOzQgkVLINrKN5CYPe0p754z0gdoRLlde+qUtO994t+tDJ4GHJYos4e7
	lVKByFxJBKdVWVl1FxaiLphvI+0sAC6qlJxBSOPduVquMVu2DWDRR4WsKyUR6XfYgv5s7P
	KTjeuDJtWVGHUZYc9qv/lzz4HgDDryc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="YSnWb7/r";
	spf=pass (imf28.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773819350; x=1805355350;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=mxAus0m7y2DqyTg/dpxIiiakzp7yUZ8qOPbPAFNGUTI=;
  b=YSnWb7/rypGO1maP7TOxnvNyk2YGTZfLhD9YI184sQsXM7TpN8JI4rEM
   TvD1TJjFG9DMg14yfPNMBg87L/wlZ8hE77up+pTkaag4ZzgVUcyQNs2ul
   HtHp6ZydtSEYCiQG1/df9SjKGKCBtsJa1o3KYNzdI1rkOF93i/V+KU/Bp
   yHK0FNCgEEakMGUoSd1OoHCP/PdGcKfpFZryintsiqN5u4XtlTVDbklRu
   9/fCJo5jYjly8o9M7LYxKzWgoRGF1CO4DXQrQSv899NVcdroqmDzY+zOk
   /oJtdnNO0rcMIgJI0Xmwaa5+tGaaJpa/i5WVb0QHZq8VsRyVAG2tzgWqX
   w==;
X-CSE-ConnectionGUID: m8V3Dh62RsSr7PAjC0xO+w==
X-CSE-MsgGUID: WyH2eSweQyKRamAVvEcFlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11732"; a="78766415"
X-IronPort-AV: E=Sophos;i="6.23,127,1770624000"; 
   d="scan'208";a="78766415"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 00:35:48 -0700
X-CSE-ConnectionGUID: XrX2P7hIQX2H1xyoXVTGQg==
X-CSE-MsgGUID: bl4LvXKhRymwlEA/Cgm0qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,127,1770624000"; 
   d="scan'208";a="218589921"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 00:35:46 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 18 Mar 2026 00:35:45 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 18 Mar 2026 00:35:45 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.61) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 18 Mar 2026 00:35:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nFqd9/yp2hnGtvJ5GIlhcB7QejXSgY0+QDMOJQF3X+9KacJzPTogaCvrux+XuGHoGy9U84N1Qpmog9131tsmcwxZXPsi02XKqdimt4CYQKT46EzlrEtpTUH6h7ZoYI7HpjYD9tvVY2iXEuFW889Gwenf2diS8qbjBaSGxDJI3lHQrCQcWWlo6BEauXpLEqb9HVGYVzIYE3l2bBDWqI/y+ozlfXS0r9JsGyvJP1IDVmp9ybiXOSmvgu11nevAaBGAv51nasbe0X6/NAjp1ECdd4XjPAcagFOvV3qJcGEDzXVY34b+W6svAKwO0jQ6QF640pK3XcsEIebpmMGbuJIz1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJiHTF35GwXk6HMt239Ki+TRV5yNLVIqpBsX1kEQzS4=;
 b=IPWm0uTjcfP2sK7C9EkAoyVKN2xv5g0tZumER3g3j0eP9dDXCmdvB+SSxxygW1FikRN3drSoSoXuk1lSaA9Z2SHVCHalrNC9v+SELsdxpc+rQMoYlhYGj/wWMkic6Y5scbKY0rOSOAshM5M/o7rXJuXE8nXHTom5u1W/sLbY5xVJjpSwzW+h5G3KNutDujgRxZRYpTzTqWnOIXq7xI4ZzptNDfA4iYZ+McPwuyRlydZJc0lDeOtHfQ43Dn4oVjl4kU2hhx3+HN3oUGo3aPAhMOd8D7MfACGYkJBSyM7fxAtdofF1UB/vCGJLKLNWsXo+vUvM8qupagIbKxPtnQRVzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by CH3PR11MB7794.namprd11.prod.outlook.com (2603:10b6:610:125::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 07:35:42 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9723.013; Wed, 18 Mar 2026
 07:35:36 +0000
Date: Wed, 18 Mar 2026 15:35:29 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Harry Yoo <harry.yoo@oracle.com>,
	"Hao Li" <hao.li@linux.dev>, Breno Leitao <leitao@debian.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Zhao Liu <zhao1.liu@intel.com>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linus:master] [slab]  e47c897a29: stress-ng.lockofd.ops_per_sec
 15.1% improvement
Message-ID: <202603181437.2b4fc5d4-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TP0P295CA0004.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::14) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|CH3PR11MB7794:EE_
X-MS-Office365-Filtering-Correlation-Id: fc30d0cc-a26c-4267-0e52-08de84c0f21e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: eglSY5h7UZ+EnEaTiVpBNbz6GkQITJgjs61xXr4R1dn93j1zqv8OumI/Jv6ntlYMOkFAACLY9G7uaxR2jU2M8BzbZ7yKtSNYRCkQvoKSn2mFVRHww4yRkbzgr1QwjRFfsuDYZogj14VrgyrRTYTYhfTwPLlbKyuLUPFjP6EVwISWpHK2I44KjT1q86q34qhs4tAtd3Zcg0ZkhlWKa1XMtWp/FkXYtPg3JegJEhpiW7rN0J634r4VnDZzh+SKH8jNN/S7vaoysYdHsh7Avpp8jkR8bURw5svbuch4HKwKIycK+yGePajf6yqkt001RsZ6sPzSg39JZ1Uzjzt+qaCPn2Hxyla+dVzALBh+uzGVv4eQNOz6OBAeONma6PJ09YKwIWXhrJ55jWP2NndepsXTf5f+nmX8u3+z7KLQ3CEALd2NVb+AG7CXndZOgwjyei3dHbwrnpx5D52RB51i02PLA9trgsAnrKZkBlmtbJLXK31eMOz2YzqOo80zdNHZ+iRTVJwQcRwAqWIp7X5N1NWuGV8UkrJ4vKTD1sun3FVkxMbdNIXHdwzfX1BytdGJLsyFFn4Kw6bm4YzhTv7vpC7rM0gZkbT0Jsg5frqXr6sBgV2wqyFtjvv0Rk5mrmp7jkIVING8aDvvVNsahG2QgyXDKKi5GRroMAQy8z3qKBwygMAG8RKAp72pBoYzSWZlvgIO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?SACJAgoiF7PfDTNQqSwNmTLmjBPCCKv1OrLcmJddr+2kkmYp9/yJjfNHbj?=
 =?iso-8859-1?Q?kqB5NJwwpWy1oAvsl0xV58/M5vqPm713RS5cg0GGnixd+ISQKGp7D+hZDQ?=
 =?iso-8859-1?Q?KP5I+1qCYNffLqbfQmH90LWt+DZqPD+VeqwlXsRAzkrCKzZHZZu15eMUxT?=
 =?iso-8859-1?Q?sI9EFYQGG3dO6W/jIKnyA36XrYon9G0IqxVYZjn9X6IFbCYqqyVQ6GAmUD?=
 =?iso-8859-1?Q?gEmKt64I5YgvYFi7NAGoUodjlZBdR2ZkiWnitRRhnqBmbfjN1DdS2UXAzd?=
 =?iso-8859-1?Q?m32stHoyRuRtikhoEvUaN8k00o510nIkAa/qO8NtihzPXyIK+3dsJVJgbd?=
 =?iso-8859-1?Q?sXXXqeXLk2Z0+HMHOWJR21n5ZpCj5IIpiZAtN2RuirB1u2izHSG0STlnPC?=
 =?iso-8859-1?Q?1hLCit8jxAQL4G4bhRfOpbrbxcuAXLxB5xgqkOzUDn/2igNYd1gXz2lvdI?=
 =?iso-8859-1?Q?w4Z9OMY9892eOnYZHH7FfawINRoK9qLTe33d0OBedu8WfKWV0phxdZj9NN?=
 =?iso-8859-1?Q?wkLJFpLEscyh85zysptwsk4Su8PxbFInU6/1LEjrCEZ1j3i4O7BmIT3UF2?=
 =?iso-8859-1?Q?XSO0ykv73WqhfKFY52WIoDowNF7LdwEMb8XCGWM/79gU4mU0yi7zHB/uc/?=
 =?iso-8859-1?Q?HeWOjvzewUI8573hqwgvzfcW3SiqlfEDR80wjaCsjTCEvQLebyH16OzerS?=
 =?iso-8859-1?Q?5D1PegMahjXa7TimrGyF6vaRIh/g7xAYcls+e5JuFbTdWI9QMk7dGZE6+V?=
 =?iso-8859-1?Q?Md3dzhsZEeLvPMLaK4TrwdGx9T0d3K3eaT+uey3PxYbnX05bZuyc9Pwc59?=
 =?iso-8859-1?Q?Nil3N9kIMuhVZsIW5lzKYPSIzlBf2Gem5FYoQqo22Kyig/PAWG47m/dIFO?=
 =?iso-8859-1?Q?YHmKt9yBMWIx84vFQcTp0VJTeho6iyXm7vCjx983pRzJnfl1qLuEGZQdqB?=
 =?iso-8859-1?Q?HbZ6xabq+J1oVIrBV+lpBkmQnodibDw2MJP4Xt5ad0vIAuf2GyNVyl7OiZ?=
 =?iso-8859-1?Q?X/pQCIStBHt345fcYKxZYTU3TusqQapIDXdhwtuv4/yuX1TWJaOsZIJ23g?=
 =?iso-8859-1?Q?0ewTzfep1khVpypOlpEp1KRsmgCm6Md9exrRwFcioLwS0SlvZRKfc7w7DF?=
 =?iso-8859-1?Q?Gnv4Z09a1zxNMOGsw4JqTKrOVmf95HKHQj0q5J6SUdxRj2HexbmkBW0NA9?=
 =?iso-8859-1?Q?W1BjphgF0lQOzMEDj/lZ61Scupp9uBu3xzE2FhmRbw12GNcrSr8t29XYQW?=
 =?iso-8859-1?Q?vqwwU5vtrfpar0FBm8BXvcGdMR66Q9hFXXvxbTABynVtEgK4WMCSbvXUJ0?=
 =?iso-8859-1?Q?1qcmPeIgdMuQGDQZtxUiWkEH1cmZyHFnN8p7cOnLv+FDxqyKzneOc7Qo/R?=
 =?iso-8859-1?Q?JXS8YofSLII/lJ1JMjoDNE8vI/DSCzC5aCkDDVY/gpDit9aSYtzh0JgInr?=
 =?iso-8859-1?Q?NSeIVupXrMPj4vrmW/2JceqHFKGq0lu+ArfuVmiifxYnY0aKYOOWp1soMC?=
 =?iso-8859-1?Q?KoddmAPAoSRm2Y0CzBzJpuns8bgjxNJJ8mH2odvmSvqBcYgNufuC6jMHVm?=
 =?iso-8859-1?Q?ujgLP6rVisC91P5+H1rydYVNmzSpEMkWMayBppYOaSPUC6rc/Wni+fyLad?=
 =?iso-8859-1?Q?57jTfeui8AlLjYO9N8qB4SAmFFQ4mWFPfu5xXpLMd2S9kQl+vpQw9Gd4yE?=
 =?iso-8859-1?Q?vru4bwrwYB/YA/59Tzs6dAVDguaViW1t6KWWluaORhGPkOM/JNZVGoUlM/?=
 =?iso-8859-1?Q?dH7b8NG+5ccy2oqcTaRjmEaUaFTjbmwGByjeq4DeJjylbvSdozlndcbc6h?=
 =?iso-8859-1?Q?rmEkaE1Ilg=3D=3D?=
X-Exchange-RoutingPolicyChecked: tzwAR7E4EYMZv+gZElqwbcMQe6DQqNbHS2DQUxTL0GfI4BVP93oyC/dczOLN7QYSHlfKZT083Qp9HSlNOmCH36r5XWNTwwpGYqS+bxqxDG9QOJr0AhQL7N7o/cHO6hGi+ZSgHphhbUGq9vopmT9K3y46qL6W4i9f/WquAF99FJ6ZX/+2V+2sOERM8E+IWUPdXrrya1rpooWeRPHQji6Yv1yjMk5xJynC4BC3W+fBI3KUyCZ25rg9FrX1CZdcPMMytceyxvz1maoGsutaoIAP1P3Fn+LY1tHWH7Px2FPNkUQci9jS5tzgAkFRv7FqSFEjrBqADkKqtBVF112l/fI2dg==
X-MS-Exchange-CrossTenant-Network-Message-Id: fc30d0cc-a26c-4267-0e52-08de84c0f21e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 07:35:36.6970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tPO9OsNMWXJCRmmSCtL+raCaf0o1KrwTSBgztRMiRZdyLflvgnEiUR/e5jO/MSlBwe6Z3pEHrIMtwldQbIy1QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7794
X-OriginatorOrg: intel.com
X-Stat-Signature: f7nwasmwawhhdhwiqetrcebiw7igidd7
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FCEFC0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1773819349-690007
X-HE-Meta: U2FsdGVkX1+ZnVezxHk4REyWmReDS34nYzkHgUs0Mi0lFFIifF0wYfY6nDjwAhyMvFtccN+7G+wUixZ57gQkL8fHZ3UbFv01BgoXhfMlkMR0cYb0gLFwz5uHsvGFRpXOgDmerDSi3cvV8xBIz1xQBt0RNY8C64wsF/2gyG7f3nGwxr82rMin7w1QRGIkuQuffycZE+q8XoQ49h3SXwpvK6ArfR0j+5OFtZZNJb8u2dOFxMJUAoI289y1ZeFLyp3lpeq5+AlDladTdeE9zIwZpW6EGdmbf5rpOzniCHEIOKy9+uzg5bW2cSCgCo4TKCE+PwR3zUwtrXD+GGC4XDVgMFYxJNjLnMhCl2eeGDDcaOOGRLZHt6IF1cBUTyn5QzbjXnMALQwuV/i9MbUq4DOQG69plKjWj4pXD28lxZxh6iOCldb+7gyc0erDyUHPgn9X0+Y857ogsJbwFz/1lT8BoVl/vl8PkKxlH+ynX69UKExV82S3qaRamapt7cvaDPYTRr8U+Lj3uGAgLrMA+DOdwFxDFpg7mjsOQ155PMD4XtYwyC0wypK1X7TX+IFMbJfGtVp0+/xHgjJfEHyrRlSx/8Wv6vr6zhP5jZI/GxulnsAMJKR99Zeq3Vo4edI1FzpO2LGSCcodmZbrwKu//Qf/tr4mdtIAxxSKnmAVWKFNhmMyhdfP7g8EGpfepeeyoZWHfKJqX4NNxWAn4NhCHORQ4secTrunzZwCD2yI34n2ReBh2PSpyJhG3SHQ68Oa14C9qqu6QKbxSlURUgYv/NoNUlkc1YiQCdfKc6CuCJy2ZN2KqFdqcY1MVxaA0YxfgaOG8whGRuSs3qR3hWhgeA/MviYU9Lp8esjgUDBNWuIvjSsxh252+eT95BMkuh/Jr9jF/SPcS4fGQ3+Yy3T0mmJbMjVO+L+qsdLdf0YKZNAIgNyelhy2kdWUV1j/P1zl0SX5SA9lpgn2zWrPvFDNBKZ
 /iNSq6Tk
 lXyA1kS1+SfzcINkuO00xEFaXSFufuWzQGnzVJTU9kpHi4D/XzZBE2l8MNmFy2+o34HGHduM5GQbw8zvHrDWOIhbX2URxUXgNCN3s43Zn7vbbo5FJqGulDQJdGbHB4PfsCdvzqWDkzurcY5xwijcsyt1MYkpuQNxIcK3KNN4+zBm29cRe7cN9VzyDlwXvLuGneaOwLV2v7B0hJOh5945iUhRjrr4u3kG50Ju0b+hHIpTFpMT+l3sSMG+sppBoCav6mFw+5mIxXFEykOG343gxcokrmluQWIK7TLj3PaIp/qnE9K8833sUjBJsGsSC83rP64yWWb1zg3bcL6uOI9g6s3B0cXxJdbiGeZv20SUfxXzOEMcPovzbsE71/cd+mEvvikydlRHxvdgME6QYMB5DrbBPod02lrLkVueVbea5VrFRQWPmsOjRp3DnD81GzotXR3TaO/Xh9+YD1s/OOn1L+ZPOvGy/kqORFc6HgzVChv8QEjmEBi29RGjLJv9gztSvZG61+1UFZRG88W2Eat0WIdycCK1SsHXVT2wRqprMfpqapD7vJB8a1dpCBRSn+3ebVUOflIMBWBc2MMaOT6NXlqBUWizgU8Ff5R4PFkWr7dXvtk/s/TF8gu/tL/bz6mLc6AH0Me8VinfPw1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 15.1% improvement of stress-ng.lockofd.ops_per_sec on:


commit: e47c897a29491ade20b27612fdd3107c39a07357 ("slab: add sheaves to most caches")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6768P  CPU @ 2.4GHz (Granite Rapids) with 64G memory
parameters:

	nr_threads: 100%
	disk: 1SSD
	testtime: 60s
	fs: xfs
	test: lockofd
	cpufreq_governor: performance



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260318/202603181437.2b4fc5d4-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/disk/fs/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/1SSD/xfs/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp4/lockofd/stress-ng/60s

commit: 
  4b038a9670 ("slub: keep empty main sheaf as spare in __pcs_replace_empty_main()")
  e47c897a29 ("slab: add sheaves to most caches")

4b038a9670154e8b e47c897a29491ade20b27612fdd 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
 1.912e+09 ±  3%     +15.1%  2.201e+09 ±  2%  stress-ng.lockofd.ops
  31892971 ±  3%     +15.1%   36721113 ±  2%  stress-ng.lockofd.ops_per_sec
      0.28 ±  2%      +0.0        0.31 ±  2%  mpstat.cpu.all.irq%
      0.33 ±  3%     +12.5%       0.38 ±  2%  turbostat.IPC
     17.77 ±  2%     -19.2%      14.36 ±  5%  turbostat.RAMWatt
      6374 ± 13%     -91.1%     568.33 ± 47%  perf-c2c.DRAM.local
    209276 ± 12%     -69.0%      64817 ± 40%  perf-c2c.DRAM.remote
    475369 ± 14%     -64.4%     169285 ± 36%  perf-c2c.HITM.local
     24507 ± 12%     -49.3%      12424 ± 40%  perf-c2c.HITM.remote
    499876 ± 13%     -63.6%     181710 ± 36%  perf-c2c.HITM.total
      4.03 ± 11%     -49.8%       2.02 ± 10%  perf-stat.i.MPKI
 7.069e+10 ±  3%     +14.3%  8.083e+10        perf-stat.i.branch-instructions
      0.40            -0.1        0.33        perf-stat.i.branch-miss-rate%
     22.12 ± 13%      -6.0       16.15 ± 10%  perf-stat.i.cache-miss-rate%
 1.229e+09 ±  7%     -43.2%  6.977e+08 ±  9%  perf-stat.i.cache-misses
 5.599e+09 ±  5%     -22.7%  4.329e+09 ±  2%  perf-stat.i.cache-references
      2.99 ±  3%     -10.6%       2.67 ±  2%  perf-stat.i.cpi
    748.51 ±  7%     +78.5%       1336 ±  9%  perf-stat.i.cycles-between-cache-misses
 3.062e+11 ±  3%     +12.9%  3.456e+11        perf-stat.i.instructions
      0.33 ±  3%     +11.8%       0.37 ±  2%  perf-stat.i.ipc
      4.03 ± 11%     -49.9%       2.02 ± 10%  perf-stat.overall.MPKI
      0.40            -0.1        0.33        perf-stat.overall.branch-miss-rate%
     22.10 ± 13%      -6.0       16.11 ± 10%  perf-stat.overall.cache-miss-rate%
      2.99 ±  3%     -10.6%       2.67 ±  2%  perf-stat.overall.cpi
    748.41 ±  7%     +78.6%       1336 ±  9%  perf-stat.overall.cycles-between-cache-misses
      0.34 ±  3%     +11.8%       0.37 ±  2%  perf-stat.overall.ipc
 6.915e+10 ±  3%     +13.8%  7.871e+10 ±  2%  perf-stat.ps.branch-instructions
 1.201e+09 ±  7%     -43.5%  6.784e+08 ±  9%  perf-stat.ps.cache-misses
 5.475e+09 ±  5%     -23.0%  4.216e+09 ±  2%  perf-stat.ps.cache-references
 2.995e+11 ±  3%     +12.4%  3.366e+11 ±  2%  perf-stat.ps.instructions
 1.829e+13 ±  3%     +10.2%  2.015e+13 ±  4%  perf-stat.total.instructions
      3.09 ±  2%      -1.6        1.52 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.posix_lock_inode.fcntl_setlk.do_fcntl.__x64_sys_fcntl
      3.25 ±  2%      -1.2        2.06 ±  3%  perf-profile.calltrace.cycles-pp.kmem_cache_free.posix_lock_inode.fcntl_setlk.do_fcntl.__x64_sys_fcntl
     93.17            -0.5       92.64        perf-profile.calltrace.cycles-pp.posix_lock_inode.fcntl_setlk.do_fcntl.__x64_sys_fcntl.do_syscall_64
     95.62            -0.3       95.36        perf-profile.calltrace.cycles-pp.fcntl_setlk.do_fcntl.__x64_sys_fcntl.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.15 ±  4%      -0.1        1.00 ±  2%  perf-profile.calltrace.cycles-pp.locks_insert_lock_ctx.posix_lock_inode.fcntl_setlk.do_fcntl.__x64_sys_fcntl
      0.72            -0.1        0.58 ±  2%  perf-profile.calltrace.cycles-pp.locks_release_private.posix_lock_inode.fcntl_setlk.do_fcntl.__x64_sys_fcntl
      1.04 ±  4%      -0.1        0.92 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock.locks_insert_lock_ctx.posix_lock_inode.fcntl_setlk.do_fcntl
     96.32            -0.1       96.21        perf-profile.calltrace.cycles-pp.do_fcntl.__x64_sys_fcntl.do_syscall_64.entry_SYSCALL_64_after_hwframe
     97.45            +0.1       97.54        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.66 ±  4%      +0.1        0.76 ±  7%  perf-profile.calltrace.cycles-pp.stress_lockofd_contention
     97.61            +0.1       97.71        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.74 ±  2%      +0.3        1.07        perf-profile.calltrace.cycles-pp.kmem_cache_free.fcntl_setlk.do_fcntl.__x64_sys_fcntl.do_syscall_64
      3.66 ±  3%      -1.6        2.10        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      1.66 ±  3%      -1.5        0.15 ±  9%  perf-profile.children.cycles-pp.___slab_alloc
      1.66 ±  4%      -1.2        0.42 ±  8%  perf-profile.children.cycles-pp.__slab_free
      4.08            -0.9        3.16 ±  2%  perf-profile.children.cycles-pp.kmem_cache_free
      0.97 ±  5%      -0.9        0.06 ±  9%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.69 ±  5%      -0.6        0.08 ±  8%  perf-profile.children.cycles-pp.get_partial_node
     93.45            -0.6       92.87        perf-profile.children.cycles-pp.posix_lock_inode
      0.62 ±  4%      -0.5        0.07 ± 12%  perf-profile.children.cycles-pp.__put_partials
     95.72            -0.2       95.48        perf-profile.children.cycles-pp.fcntl_setlk
      0.46 ±  5%      -0.2        0.29        perf-profile.children.cycles-pp.syscall_return_via_sysret
      1.16 ±  4%      -0.1        1.01 ±  2%  perf-profile.children.cycles-pp.locks_insert_lock_ctx
      0.82            -0.1        0.70 ±  2%  perf-profile.children.cycles-pp.locks_release_private
      0.31            -0.1        0.21 ±  2%  perf-profile.children.cycles-pp.__locks_delete_block
     96.34            -0.1       96.24        perf-profile.children.cycles-pp.do_fcntl
      0.15 ±  3%      -0.0        0.11 ± 14%  perf-profile.children.cycles-pp.__libc_fcntl64
      0.16 ±  3%      -0.0        0.13 ±  5%  perf-profile.children.cycles-pp.stress_mwc16
      0.12 ±  3%      -0.0        0.10 ±  5%  perf-profile.children.cycles-pp.locks_copy_lock
      0.18            -0.0        0.17 ±  2%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.15            -0.0        0.14        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.07            +0.0        0.08        perf-profile.children.cycles-pp.locks_get_lock_context
      0.10 ±  3%      +0.0        0.11        perf-profile.children.cycles-pp.x64_sys_call
      0.13 ±  5%      +0.0        0.16 ±  3%  perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.07            +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.stress_mwc64
      0.15 ±  3%      +0.0        0.18 ±  3%  perf-profile.children.cycles-pp.flock64_to_posix_lock
      0.29            +0.0        0.32 ±  2%  perf-profile.children.cycles-pp.arch_exit_to_user_mode_prepare
      0.11 ±  4%      +0.0        0.15 ±  2%  perf-profile.children.cycles-pp.__init_waitqueue_head
      0.23 ±  4%      +0.1        0.28        perf-profile.children.cycles-pp.fdget_raw
      0.32 ±  4%      +0.1        0.37        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.71 ±  3%      +0.1        0.78 ±  7%  perf-profile.children.cycles-pp.stress_lockofd_contention
     97.58            +0.1       97.66        perf-profile.children.cycles-pp.do_syscall_64
      0.42 ±  4%      +0.2        0.58        perf-profile.children.cycles-pp.__pi_memset
      0.00            +0.2        0.22 ±  9%  perf-profile.children.cycles-pp.__kmem_cache_alloc_bulk
      0.00            +0.2        0.23 ±  7%  perf-profile.children.cycles-pp.__pcs_replace_empty_main
      1.59 ±  3%      -1.2        0.42 ±  8%  perf-profile.self.cycles-pp.__slab_free
      0.95 ±  2%      -0.9        0.06 ±  7%  perf-profile.self.cycles-pp.___slab_alloc
      0.24 ±  2%      -0.2        0.06 ± 13%  perf-profile.self.cycles-pp.get_partial_node
      1.42 ±  3%      -0.2        1.24 ±  2%  perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.46 ±  5%      -0.2        0.29        perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.79            -0.2        0.64 ±  2%  perf-profile.self.cycles-pp.locks_release_private
      0.30            -0.1        0.20 ±  2%  perf-profile.self.cycles-pp.__locks_delete_block
      0.51 ±  8%      -0.1        0.43 ±  5%  perf-profile.self.cycles-pp.locks_unlink_lock_ctx
      0.09            -0.1        0.02 ± 99%  perf-profile.self.cycles-pp.__put_partials
      0.13 ±  3%      -0.0        0.09 ± 17%  perf-profile.self.cycles-pp.__libc_fcntl64
      0.15 ±  3%      -0.0        0.12 ±  4%  perf-profile.self.cycles-pp.stress_mwc16
      0.12 ±  6%      -0.0        0.08 ±  4%  perf-profile.self.cycles-pp.locks_insert_lock_ctx
      0.18 ±  2%      -0.0        0.15 ±  3%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.12            -0.0        0.09 ±  4%  perf-profile.self.cycles-pp.locks_copy_lock
      0.11 ±  4%      -0.0        0.10        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.06            +0.0        0.07        perf-profile.self.cycles-pp.locks_get_lock_context
      0.09 ±  4%      +0.0        0.10        perf-profile.self.cycles-pp.x64_sys_call
      0.13 ±  5%      +0.0        0.16 ±  3%  perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.13 ±  5%      +0.0        0.16 ±  3%  perf-profile.self.cycles-pp.flock64_to_posix_lock
      0.06 ±  6%      +0.0        0.09        perf-profile.self.cycles-pp.stress_mwc64
      0.27 ±  2%      +0.0        0.30 ±  2%  perf-profile.self.cycles-pp.arch_exit_to_user_mode_prepare
      0.14 ±  4%      +0.0        0.18 ±  2%  perf-profile.self.cycles-pp.do_fcntl
      0.08 ±  4%      +0.0        0.11 ±  4%  perf-profile.self.cycles-pp.__init_waitqueue_head
      0.22 ±  4%      +0.1        0.27        perf-profile.self.cycles-pp.fdget_raw
      0.31 ±  4%      +0.1        0.36 ±  2%  perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.24 ±  4%      +0.1        0.29        perf-profile.self.cycles-pp.do_syscall_64
      0.24 ±  2%      +0.1        0.30 ±  2%  perf-profile.self.cycles-pp.__x64_sys_fcntl
      0.42 ±  2%      +0.1        0.48        perf-profile.self.cycles-pp.fcntl_setlk
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.__kmem_cache_alloc_bulk
      0.67 ±  4%      +0.1        0.75 ±  7%  perf-profile.self.cycles-pp.stress_lockofd_contention
      0.40 ±  4%      +0.2        0.56 ±  2%  perf-profile.self.cycles-pp.__pi_memset
      1.57            +1.0        2.56        perf-profile.self.cycles-pp.kmem_cache_free
     60.77            +1.9       62.63        perf-profile.self.cycles-pp.posix_lock_inode



Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


