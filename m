Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1BACA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 06:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0848E00E6; Tue, 12 Aug 2025 02:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691348E00E4; Tue, 12 Aug 2025 02:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3288E00E6; Tue, 12 Aug 2025 02:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3954E8E00E4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:33:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E1864115476
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 06:33:23 +0000 (UTC)
X-FDA: 83767138686.24.267DDE3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id 35CE14000D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 06:33:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RaklcR2J;
	spf=pass (imf07.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754980400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1m+xdnm7ynjxQA+xTyPk7w/I9qajILrcRpKNTtFu8SU=;
	b=qNr4JEA4FrS2wBMgBt4OuTs5DvqlhHON7KGWi++7YA8H7qPLMtapcn+SF0ciLt1gkTW+N1
	FYLhqNkjHGbotmSRNI65qyd09fWEFYtZR8t1C12Kj8CbftOHzAZONUemfkNA6LRwqx2x+f
	ombTNW86vEhdvesWG5bB1x7KA44elCo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RaklcR2J;
	spf=pass (imf07.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754980400; a=rsa-sha256;
	cv=fail;
	b=i68Uzs5QH1WmFAmDIUvayxZ44AsL/7565cXUojVHc4CG7tv5KZh/XFo8EYJyuUgIH0MbFx
	4UaUN+hH7/aE49m+iE93P+O/2Sz4jU7+sVQLgwg9j47KDJe3CdLWEX7OQ5Bq7RG0LEdu5U
	LdnrECIeVK+tk50KSpY94V1d7jDr9LQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754980400; x=1786516400;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=fveYlQTuhnE+NOmUn3Xynp20P1+49zTTj4ZVKa5AhIM=;
  b=RaklcR2JcYhGhmjm96I8offAI/mMTe2FJ+f+9mEqzRF7u5lUBN0e0E6d
   iqd32htGfkMurIX+nl+OXYAs4A8o8Epi7yhUAI/ucqh6115UI1QYd4fsY
   Ows/mgCCV9y4gOX/ioW4e6dekxsOOBApPNQxrKfB0BGRFvrgTvpl0toSD
   WjycdjtF56MZ5+4p9ftRiaAW5Q6tmbZzMhd2jbaHZ0Q6SmnX+wfg8/vFf
   2ynMyMCI7BzUiENa2gFYeSKGTwyndAxmmnjt6VD8i6Gm9O0v3V1k0LNOe
   oBMleYPhnct5yAxTK/8cIjSXYTGiUbyyUrQ+YqZw85lrw29ZqGoZ228gY
   g==;
X-CSE-ConnectionGUID: utSLTXusRWK+5+3joFY2/Q==
X-CSE-MsgGUID: xwFYR6FQRUqgYrjuUpOqfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68700737"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="68700737"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 23:33:18 -0700
X-CSE-ConnectionGUID: 2lliUYmSQL67ZmCW7Dll1A==
X-CSE-MsgGUID: Opw8hmraQ022ZSUYUA/Bww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165308117"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 23:33:18 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 23:33:17 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 23:33:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.71)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 23:33:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=splji0TaSR2jEQAlPKWVhk32ksJn31Nujlt2upXQUAth2R8CgTKoqU/aQAVO6RKideMiFfdV/AqAEvgML5ek9sbxYJRF6eWrZeTng39YZCJzSny4RkrkD9NgAZojUm4cwd5YrMooLyCEcJKSpuBkuSW/5OfezAF9q+wJUPKIamwhrv8w/4u43xyhhgHWuerfz/+dTYasVXMwzF/wN0mVGT4sMbV9B45dCeRy3uQfVq+6CHOF33fAholLDUWvE7qWWa6nf6vggRQX8e4I1ALxqgUhOsHkTZftauX8jCLA+8m2GAm5i8gVxyWSPH115ZkBl7n58fXvvIAZOoFZtSGcPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1m+xdnm7ynjxQA+xTyPk7w/I9qajILrcRpKNTtFu8SU=;
 b=TnclChqolvzAzbG2D3AXiNC7H1swi0mjaAYT6UfmApo7rt8bWEh1k5cZ976GM+ZBk3Qu1f8CPY/gzDAADJmFsTezYhQV6mvEkZCz4CeWmTS919/5UpX6DjPCw7FIL8ewueWrgVzS6tIC0GGygIVJHgsZiwNF4c5WT41w/b3ref5IHjuhuIk77buEkvZW/BiyUsjVZ5IKbFamGQ0wtwgV0pvH36OXPWULZzW80CzYvImhiuV5QqQb3UIan2ufutKhiuxtjXeCGNRj1L0VsBtFTzzpq9GRcWe2FZyjis18xb3uKOeHF620VEX6jSOJ/mjOfYwx+aDSaMUKFW+QIpGfkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SN7PR11MB7115.namprd11.prod.outlook.com (2603:10b6:806:29a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Tue, 12 Aug
 2025 06:33:14 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%4]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 06:33:14 +0000
Date: Mon, 11 Aug 2025 23:33:10 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>
CC: Balbir Singh <balbirs@nvidia.com>, <dri-devel@lists.freedesktop.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Zi Yan
	<ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
	<dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lyude Paul
	<lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, David Airlie
	<airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Ralph Campbell
	<rcampbell@nvidia.com>, Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v3 03/11] mm/migrate_device: THP migration of zone device pages
Message-ID: <aJrgJvmyeg7YuOQY@lstrano-desk.jf.intel.com>
References: <20250812024036.690064-1-balbirs@nvidia.com>
 <20250812024036.690064-4-balbirs@nvidia.com>
 <81ca37d5-b1ff-46de-8dcc-b222af350c77@redhat.com>
 <aJrW/JUBhdlL2Kur@lstrano-desk.jf.intel.com>
 <3df6fbed-7587-44f5-bd12-29e59ecde123@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3df6fbed-7587-44f5-bd12-29e59ecde123@redhat.com>
X-ClientProxiedBy: SJ0PR13CA0018.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::23) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SN7PR11MB7115:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f0eb8ea-df27-4023-9bf1-08ddd96a1d53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?LzhtM3dPN0toUU5icjBNSnRkckNvZEpFa0FPQzh1cHRRbUw0UlVzSWNYYzdM?=
 =?utf-8?B?ck1HZkI5T25TSXpCcnB6WUIyZ0dKM09SQWtPTXhSN3ZwcmJ0bHQwVVNrb3ZT?=
 =?utf-8?B?Y3pEZnM4UFNndjNHR3RCVnNnZS94QUtzZmVjV2dhVnZzOGUrVlZERUZsNHF5?=
 =?utf-8?B?TGthUmZReG9zclJnVXRVbUFjVCs1bG1GTG1jdG1XaGx4WGlzcUIwS1hobnJt?=
 =?utf-8?B?Q3lmWTMwakZsb0ZtU25JVG80NHlxbjQ2UCtSK2dDUWFnRXJNUEpobkY4czhs?=
 =?utf-8?B?OG1nTWVHTVhoSXcybmdzV3pVOGN3dklrcWp0WjFjWXU1emRGMU14UjBNQ1Rh?=
 =?utf-8?B?aFFLSUtpbFRBRWEvMThsbW92Z2I5NzBZNVBFZS9ySXJUZnQ5bmhucDNaU3RL?=
 =?utf-8?B?S2hyL3RpU015Zyt1Y3RRSlArbDlka2ZmbGF5ZGc5ZjY5YkdYVFo2WVE5L0lM?=
 =?utf-8?B?S1RjWFRVUFA1WURLY2F3anNLUitvOFZmcGhaSHY4UDVEZUw3S3J0clBTYVd1?=
 =?utf-8?B?VUI1ME5Bc2p1cmlvcnY0YjhiS2FkWDFUNzhtUWh0OWQvVFNWNFBzMUNvYktz?=
 =?utf-8?B?V1ZiOVUyMnZqc015ZDFMdlBhZ2FiQUFaZWN5MnlpUHliZm9QNllBbW5IM1I5?=
 =?utf-8?B?UUVHM0kzNDJGRXhoTE5lMWZWOSt4OUthZXIwRzJuVHdRVmtwNHpKOHkwUXkr?=
 =?utf-8?B?YXQ3VFE1MVloTW5NaGRzeFZsZWJDQ1lrSU5FL0NyUDBweFh2RThCSVRNR2dC?=
 =?utf-8?B?TGdsZHNaSkp0M2t4clhhbktwOEZ2eFhydHh4R2xRN05kSDdxekhEQ2tVeHdY?=
 =?utf-8?B?Qk9qVGdnaHlLekpqZ01TdlVFZUlLaWw1di93bE1Ia1dreEpkSEFiTmZ5UnRh?=
 =?utf-8?B?NTlmNUVzaVpoTkU3dWJBZzQwMDVsZlBHN3ZTM0tkdzVyYTlWd09qSnlGNjRt?=
 =?utf-8?B?bDNLclRCZlFQL1dWbHZrZndBSmN5VEQ0VW90OHViZGFzMmZtUnBCd0YxNEk1?=
 =?utf-8?B?VVdsakhoUzBZZXpoMlFCWlJKNlhHMHg1VEI2VGpDbGlkWDFmYTdzM0pWcit2?=
 =?utf-8?B?aUdpWmxxbWNWWngwWFpsZVBpMXJsTkhxWHJjQit6MnQrZlJFL1kxTlVFckw1?=
 =?utf-8?B?RDVsV1JZR0hkZjNUNE1DR0ZEOW9waHJyL2Vnc2hoRjNYUGExSXF3bDZnZDh2?=
 =?utf-8?B?YTB3Y01xSWdUa0plMU1nL2tES1BLandEYnk2RGk2Z084c2N3dmhpUDYxckpp?=
 =?utf-8?B?Q3FwbnhjWjFINmdtUFZXWmI0S1ZWTWtwNEFoRmhqemdYayswNS90OG14a0RL?=
 =?utf-8?B?T25PYVNWd3N3NjRGdWpiTzZvSjFMd2Q4R3JuT0lEYVNpcU1ueWhoMEhnODZ3?=
 =?utf-8?B?VXZ2blRUNkh1Q1ZERmtZVHY1VUdpdXRzZUY4UEJCYWhzV0RZcGptNWpPdkFL?=
 =?utf-8?B?WlBYWUp5VUFYRklIbzJZMm5td3lZaUhHb0pXcDNXZUdFaTRHQnh6Y3lmQlhl?=
 =?utf-8?B?d05ZWjZmUm5mVzdVOWxqQkUxWHRTVFBzMlVYckhKNUZqc1hLdTl5OEl0Misr?=
 =?utf-8?B?S0d4RlhFNi9CSWZxc2x0TUEzVFVsTGxoSEF1djA4RUJ2M3dTdTJnWW85MHNT?=
 =?utf-8?B?S1V1aWxuSlBNVGhGb1pZSUJzWkZIWGpjWDRKQlNQRXJxKzc5LzdvbklFeDR4?=
 =?utf-8?B?TXAzMVpucUIzYSt6Tk9VY0Q0ajZVQkFLTUpSUStHUlFPajhVVFEwMDR6YUkx?=
 =?utf-8?B?TU41Z2VuOFljNXJ5S0hSL3ZPY3MrdkxoRVpNRHBzQ2MrbXJuYlNlYzVxTzF0?=
 =?utf-8?B?dmE0QmYwd3hrZ1J1cjBld0ZhK25KVE9RYk1vcUNvRTI1ZFFvcnRHeGNSZDI0?=
 =?utf-8?B?OFpUdUhRdXp6N2ZRaXdZTE1obnZKWEM2SE1aSERTRDBjcUE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0RrcUFGd2J4NXZnazNnUVpwWnJxcXUzdDdpaFY0ZU5WeE15aU1MUjdGaDIw?=
 =?utf-8?B?VVp5YVZUT2pFOFlySnJTOXlUQmNzdlVBd0FscVhMUmlFdWlCTW9zMkZ3d0ll?=
 =?utf-8?B?Z0pGdWplUGZpQ0s0SkVPaTB0elhhbHdiRDFPKytLOVA5ZlpjS3M1c1RkaVRT?=
 =?utf-8?B?V3NoQ0FhZWxrTEtDQm5obkhjV3FrM0JBL2F3R1lEMEhXa28rOVl0U2xQN3JG?=
 =?utf-8?B?ZVZLRGROUFRzQ1pZU2J4cFdVTElsOFdOcHdIbUk3MFdXb0hEbjBnd25MMzY1?=
 =?utf-8?B?emRkYUFmSmtoN0k5M29jbytrQVN2clM4aENDYTNwQVc0QXl4bzZJOEZvQU05?=
 =?utf-8?B?bk1LeXdXcjVEN0J4dFFTSFE5dGYzUE1HK2hUeU5aYkgzcmJMSkRQd21HM1JI?=
 =?utf-8?B?ZFM5WFNzVVltU25rY2VkMGdSd2gvRmh1YUZpYzFxUStYRWIveFhQZGZEaEN1?=
 =?utf-8?B?TDB4elE1ME8yMjJxajZwNjJacENRZFFRNGJYckIrNHdEdEkrRm5rdmlyYmxE?=
 =?utf-8?B?NjZoZU82RHBRNmlmQnJnRVJVWDNudW1OOUhUalhzRTIvajVGdnd6cGZPZmRJ?=
 =?utf-8?B?cXdnWDJ0cE1DQ3lubnJqVnhvMjZySUhNM2dldXk0MGV1MGhPQzJnTDYxb3ZT?=
 =?utf-8?B?SVBMN0lsY1JmZUtZdzV6cUpaZlFtbFVjeTJRbmZOTTBqUExjcUVqNGQwb0V4?=
 =?utf-8?B?OUQ0ZVZFazNZZWlrVUhlUGlqS2plb3RtMHZQcmg1SEc5L0g1VDBJTi9RUFpP?=
 =?utf-8?B?RXZpMlQrcnd3SFAyenhGOVp0bnZVejRiUXFpOEFwOVRUc2hnbDlQZzRFSE5x?=
 =?utf-8?B?NVBhbnBGemhsQldnSmhxSkFYTEZOR0JTTWE3OWlxanlKTXMwK0JscytYdTdE?=
 =?utf-8?B?WFFQeXN4RExJOGpBbTQ2S3JzSGtXNGN5VTJzMFVUZDdWYkI3RTF4WEpqR0Qw?=
 =?utf-8?B?NUREMzI5VzRBWU1SR05zM1RaWS9VYlhmRDZSdklQZnZlWnhVQVpJVFp6YUcv?=
 =?utf-8?B?dVhXUVhkVFhUVEk1TFU5MnJLN0ozUno2SDBBQ1RHVTA4RWkzQzFZQ0d4RndY?=
 =?utf-8?B?OU10VDhyZmMvUDYzMVhscDk0RVUwV3ZVRVUyWms2SExNQ1M4QzNxYVdkTnQz?=
 =?utf-8?B?L3lxdEw0RFAvaW5uZ1Q1L05YbVUrbGE4QjhRaWQ4bGg1NVRpUE8wcXB1bnNj?=
 =?utf-8?B?U1JrR1BYVWtHRkk2QURUdDFMR3R6SlJIUGU1cGxwS3gzRXprODI3YzR0WHRN?=
 =?utf-8?B?TUJ5SHA3UGNtQU1TNEZ5TjhBZUNIWHF5OSs1QmF4YzJac1hGekErTTJ1aXNu?=
 =?utf-8?B?bWNub0h6YWNEVUtGV1BPdHZjUkNaYS9peUJLYmYwaG8yRUhQWWI2VDFWZTdP?=
 =?utf-8?B?TVhENktMVTJnZEwvQ0VocjM1OU8wcmdQYjV6dUhqSm55T2o5cTZpU20xTTli?=
 =?utf-8?B?WHNWMXJHa0dyRThmYzJlNzBOMzVqZ3JCR2ltQkExbWlkSm02R1pZQ2hqUlN0?=
 =?utf-8?B?YVQwQ3ZKSG5Ua25TS0hZUnJjMlRXdThGZExnYlc1b0xMWVErL0xNUmtFMnlD?=
 =?utf-8?B?ZlRDbTBBRE4vSExOVks1RGJubnpnZWdsRmdUMHJERElQQTBWSGxmYzdVTURo?=
 =?utf-8?B?eldMK0NFWkVzVjNDM3M0dzgrc2F6UFpkbG5lMTV0aFF1cExmUXZwR2hwSWZ4?=
 =?utf-8?B?MHVJMUk3bG1UUi9HOWxLRGpZeWhBaExPV2lva2MwV01pWFZ3TzExMXFUN0d1?=
 =?utf-8?B?QlVmbVlPOHFRZkMxZmZmdHN3SVJOK01wM3JvRXBUT1V1TS95aW9BZGoybEpR?=
 =?utf-8?B?VGFwVE9ZUDkzWXBWRjhsNldobk9EOTYrZ1pzcGZuVDl0L0F1c3J4blgrY24v?=
 =?utf-8?B?aFlLNko5emdxTFBoRzZlZ0NvWFkyRFpya3R2QVJDdHJBVHdJaDU1RUhleHVF?=
 =?utf-8?B?di9zTUQyWmtBUUxtdEJTa2pmNEdoRDQyQ0t4WEhhR2JtbGFYUitDRExjd2l4?=
 =?utf-8?B?R0FoRnJBUUVRYW5aamZhWlRMR25lYTJ4cEFsWnJta3VQWlpDZkVPZUsxY21N?=
 =?utf-8?B?L0xOVGVaS2RGTmpmY0VEdTMyekd2QzYwU08zekdWMWs4amhTT1crUTM4YnV5?=
 =?utf-8?B?VVRsblVMaWt2U2VkY2t4RDh3V1MvYnpadExVVUJDQ0RrS0J6TVE0cnpLS01h?=
 =?utf-8?B?bUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0eb8ea-df27-4023-9bf1-08ddd96a1d53
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 06:33:14.0031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKWSzto+xi6ihbHle+KXT+6ygaXKre6qqdzDCqSkSp6cDEepTqG8Guk6r29U/KJwELYIqMTRe16L0dTSnf3q/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7115
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 35CE14000D
X-Rspamd-Server: rspam06
X-Stat-Signature: qbwd65ryy93f8co86nkzga76oda96hgr
X-HE-Tag: 1754980400-661796
X-HE-Meta: U2FsdGVkX18w7Mp5PaoqFH4OAuSmRwsohhNBzYQLT9YaNxznSYWHjZuC+HNwKdosm8lSKO5Gz+IMTr7rd0IHIxP6Skl7B5cYP1wbTz7OR/Z5q7Bs1gl/+zgQIHdZYI8mCQWNDHXfWkzRk8duouFsUhRpwykn/+saGzpiOr073mG3Q86IDfIY0QKDDKkR8QzCzQEnIxgjqzAwjs/cPPXozf6WpVbloc+DecYSTiXCbQ24Qx8CZUVvMeqO6bf/BV7dsv9gQJd42GTv/Pc22ZLDoWQS8hzBq8Xl1QI8UXk7Qe5CBiDAusbaa3BtAlQCJ0TkauWUODvuwG4mpbpP2qiMNFnZ0/RvizW6VYNxafbRGKkeFbLBP6R4qwU5d/mRUfmynwt45bZcYGUcd4p7BqQsvz5iIBELWQY2YIMYWExijPOMC8eKvdaH1iz+FsxKu5eZ3Y0tx99Fhgo9boXrBWnSlljD8qTxq2hovag8Eac2IXl9Z5zGN1mgDBZcchX3uyWMA/COCrx4JbuG0W4O2wu4kKOdRTqqV6FlfJderOmKvgLNX+kNjkFVqChGuDd13S5wzUYcHbwnmQQEga3eyy8DE2e2T07eiKqtCtyCpv5DhEVaBVAZkH2zAuyziuyRPY+3HPlhyc13B8vndqmMg68ZE7L7kZVX78KN54rA8fFm4phpLSUYw0FD7bRdjiqiuCyvXfPqJ+dO/aR/woptueOdfzrqROB63rv049nh0v93YQp2ydyo01CUtTM69T3A5TLDs9uuOgdFycnYqMTYM1rETB+DP3Oo81VCGiKd2AYEKu8ImjKL5S6hwJ1Y8iRD8/IEGQXqADTUqV971kAp/ZhpPR342CWuBgY0JwT0bVMrj78+CF7W2e1dc8sg2Ji8t+EpJimA8HKrIeFApQ262p2/CwyEGdLFrzr7oWqYdZKG0SGgXUzHYEYdLMh6qCcp6Qqz31c1qBqRWFKXR7YeAJz
 u8wSpynC
 dyrdaAOszqg0I86IH/R/9r6FCUQlH6n25Mc6q2fXba1m6GtCW9F9v2NJVUjCLaUqQxbdu1SmEm7CkCRScBi9WpQ8dYVNrJkPK4RvQAspanxEoMIAvBpMoNy9nvE2/WZIvelXsRXLtDP8cgnE7nHIfGoALMmIAwgvqUGL9QDCdiYiFoSenhvlmVY/KtoB5tQyp6HsgcgJKsYV4GuvmwCZLJn+/YwnDNG0sV5EU8TuR3jQITOWuqkpu37LrBxlUXAnPWANe4YCU8i/tk8UtoBgxQ3i3u4HsulU3JxnXJeNbV4fwdM9wvP7jgp7kkLC+OOHJJeBnYD9xJCFndmHx4f3nyTGsdZdIhaMRAd58wE50/j5BAzPIbbl8bwF4BjLTNn93Fk066FRwkcMh8atz5IP10Lq5tymUR6eQHkN1mluJxG2vxaPcWguLtujYu2vhOJYley06RJDZA0FMpn+thiTJx3goLOo7s4DAB+t42yi23yT/GnXjGzLFZURflt3f4gnBbhDetpBE0u2tlXBjGHvhBuLHCicoPGz1fcIrqHEWpveQ5RhD+Zd8gEYTIaXDu9yFXHvTXCxkjdvTwa50/qwnIeGj0nY27f7vthpaMPeXRR+qZrvn/MnC+Fm6TOVC7Ff15XvRQUzwCfrpBVpVXkm9RfdVxbmdOueL+FNrCULDC7qyHlRaCpNkVETzAA423CJ8jvmn6P7kSRSBQKblYYD4vpR+Cy45bDuj2F8nYPw0KE/I6gdPYN3W+rF/xMxwrlDYpRUucI4mQmUcpaBn6Ujbdp+28SQEdoxl3FGuksnLFuTrEckpaWiNAUsPdxVXHbnGW4n9yEoHd9QsYLQnss2GB+trbYZ0oT4vvee5R3B7pb14Htfd1GLK32aw6vSWIrJ2Bi6FJ23u3QwnH2MAAqHfMf8ZJR8xJCkmR/4o2qoeohnaPCY4nvzAScreFzVOOsoeYsGogePfE1WfHovpvWRR96tWqaGV
 qfbTcAmA
 9r2klPVOkNoB9jWtialS4GDlaoatFAFDcOCN8sT06mer2Xm2izlzq7Vx3irFW1Rncsp0qXBwba7qA8wEaRECQt1QGM+vGwuIvtO/o6aLzaTC0Fa/3bluul9ZGPltlGpgfOggL8LGoo/IsIcvL50Hfmnt4YJFi//kykmnAc5i/G4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 09:25:29AM +0300, Mika Penttilä wrote:
> 
> On 8/12/25 08:54, Matthew Brost wrote:
> 
> > On Tue, Aug 12, 2025 at 08:35:49AM +0300, Mika Penttilä wrote:
> >> Hi,
> >>
> >> On 8/12/25 05:40, Balbir Singh wrote:
> >>
> >>> MIGRATE_VMA_SELECT_COMPOUND will be used to select THP pages during
> >>> migrate_vma_setup() and MIGRATE_PFN_COMPOUND will make migrating
> >>> device pages as compound pages during device pfn migration.
> >>>
> >>> migrate_device code paths go through the collect, setup
> >>> and finalize phases of migration.
> >>>
> >>> The entries in src and dst arrays passed to these functions still
> >>> remain at a PAGE_SIZE granularity. When a compound page is passed,
> >>> the first entry has the PFN along with MIGRATE_PFN_COMPOUND
> >>> and other flags set (MIGRATE_PFN_MIGRATE, MIGRATE_PFN_VALID), the
> >>> remaining entries (HPAGE_PMD_NR - 1) are filled with 0's. This
> >>> representation allows for the compound page to be split into smaller
> >>> page sizes.
> >>>
> >>> migrate_vma_collect_hole(), migrate_vma_collect_pmd() are now THP
> >>> page aware. Two new helper functions migrate_vma_collect_huge_pmd()
> >>> and migrate_vma_insert_huge_pmd_page() have been added.
> >>>
> >>> migrate_vma_collect_huge_pmd() can collect THP pages, but if for
> >>> some reason this fails, there is fallback support to split the folio
> >>> and migrate it.
> >>>
> >>> migrate_vma_insert_huge_pmd_page() closely follows the logic of
> >>> migrate_vma_insert_page()
> >>>
> >>> Support for splitting pages as needed for migration will follow in
> >>> later patches in this series.
> >>>
> >>> Cc: Andrew Morton <akpm@linux-foundation.org>
> >>> Cc: David Hildenbrand <david@redhat.com>
> >>> Cc: Zi Yan <ziy@nvidia.com>
> >>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> >>> Cc: Rakie Kim <rakie.kim@sk.com>
> >>> Cc: Byungchul Park <byungchul@sk.com>
> >>> Cc: Gregory Price <gourry@gourry.net>
> >>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> >>> Cc: Alistair Popple <apopple@nvidia.com>
> >>> Cc: Oscar Salvador <osalvador@suse.de>
> >>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> >>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> >>> Cc: Nico Pache <npache@redhat.com>
> >>> Cc: Ryan Roberts <ryan.roberts@arm.com>
> >>> Cc: Dev Jain <dev.jain@arm.com>
> >>> Cc: Barry Song <baohua@kernel.org>
> >>> Cc: Lyude Paul <lyude@redhat.com>
> >>> Cc: Danilo Krummrich <dakr@kernel.org>
> >>> Cc: David Airlie <airlied@gmail.com>
> >>> Cc: Simona Vetter <simona@ffwll.ch>
> >>> Cc: Ralph Campbell <rcampbell@nvidia.com>
> >>> Cc: Mika Penttilä <mpenttil@redhat.com>
> >>> Cc: Matthew Brost <matthew.brost@intel.com>
> >>> Cc: Francois Dugast <francois.dugast@intel.com>
> >>>
> >>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> >>> ---
> >>>  include/linux/migrate.h |   2 +
> >>>  mm/migrate_device.c     | 457 ++++++++++++++++++++++++++++++++++------
> >>>  2 files changed, 396 insertions(+), 63 deletions(-)
> >>>
> >>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> >>> index acadd41e0b5c..d9cef0819f91 100644
> >>> --- a/include/linux/migrate.h
> >>> +++ b/include/linux/migrate.h
> >>> @@ -129,6 +129,7 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
> >>>  #define MIGRATE_PFN_VALID	(1UL << 0)
> >>>  #define MIGRATE_PFN_MIGRATE	(1UL << 1)
> >>>  #define MIGRATE_PFN_WRITE	(1UL << 3)
> >>> +#define MIGRATE_PFN_COMPOUND	(1UL << 4)
> >>>  #define MIGRATE_PFN_SHIFT	6
> >>>  
> >>>  static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
> >>> @@ -147,6 +148,7 @@ enum migrate_vma_direction {
> >>>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
> >>>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
> >>>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
> >>> +	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
> >>>  };
> >>>  
> >>>  struct migrate_vma {
> >>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> >>> index 0ed337f94fcd..6621bba62710 100644
> >>> --- a/mm/migrate_device.c
> >>> +++ b/mm/migrate_device.c
> >>> @@ -14,6 +14,7 @@
> >>>  #include <linux/pagewalk.h>
> >>>  #include <linux/rmap.h>
> >>>  #include <linux/swapops.h>
> >>> +#include <asm/pgalloc.h>
> >>>  #include <asm/tlbflush.h>
> >>>  #include "internal.h"
> >>>  
> >>> @@ -44,6 +45,23 @@ static int migrate_vma_collect_hole(unsigned long start,
> >>>  	if (!vma_is_anonymous(walk->vma))
> >>>  		return migrate_vma_collect_skip(start, end, walk);
> >>>  
> >>> +	if (thp_migration_supported() &&
> >>> +		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
> >>> +		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
> >>> +		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
> >>> +		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE |
> >>> +						MIGRATE_PFN_COMPOUND;
> >>> +		migrate->dst[migrate->npages] = 0;
> >>> +		migrate->npages++;
> >>> +		migrate->cpages++;
> >>> +
> >>> +		/*
> >>> +		 * Collect the remaining entries as holes, in case we
> >>> +		 * need to split later
> >>> +		 */
> >>> +		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
> >>> +	}
> >>> +
> >>>  	for (addr = start; addr < end; addr += PAGE_SIZE) {
> >>>  		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
> >>>  		migrate->dst[migrate->npages] = 0;
> >>> @@ -54,57 +72,151 @@ static int migrate_vma_collect_hole(unsigned long start,
> >>>  	return 0;
> >>>  }
> >>>  
> >>> -static int migrate_vma_collect_pmd(pmd_t *pmdp,
> >>> -				   unsigned long start,
> >>> -				   unsigned long end,
> >>> -				   struct mm_walk *walk)
> >>> +/**
> >>> + * migrate_vma_collect_huge_pmd - collect THP pages without splitting the
> >>> + * folio for device private pages.
> >>> + * @pmdp: pointer to pmd entry
> >>> + * @start: start address of the range for migration
> >>> + * @end: end address of the range for migration
> >>> + * @walk: mm_walk callback structure
> >>> + *
> >>> + * Collect the huge pmd entry at @pmdp for migration and set the
> >>> + * MIGRATE_PFN_COMPOUND flag in the migrate src entry to indicate that
> >>> + * migration will occur at HPAGE_PMD granularity
> >>> + */
> >>> +static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
> >>> +					unsigned long end, struct mm_walk *walk,
> >>> +					struct folio *fault_folio)
> >>>  {
> >>> +	struct mm_struct *mm = walk->mm;
> >>> +	struct folio *folio;
> >>>  	struct migrate_vma *migrate = walk->private;
> >>> -	struct folio *fault_folio = migrate->fault_page ?
> >>> -		page_folio(migrate->fault_page) : NULL;
> >>> -	struct vm_area_struct *vma = walk->vma;
> >>> -	struct mm_struct *mm = vma->vm_mm;
> >>> -	unsigned long addr = start, unmapped = 0;
> >>>  	spinlock_t *ptl;
> >>> -	pte_t *ptep;
> >>> +	swp_entry_t entry;
> >>> +	int ret;
> >>> +	unsigned long write = 0;
> >>>  
> >>> -again:
> >>> -	if (pmd_none(*pmdp))
> >>> +	ptl = pmd_lock(mm, pmdp);
> >>> +	if (pmd_none(*pmdp)) {
> >>> +		spin_unlock(ptl);
> >>>  		return migrate_vma_collect_hole(start, end, -1, walk);
> >>> +	}
> >>>  
> >>>  	if (pmd_trans_huge(*pmdp)) {
> >>> -		struct folio *folio;
> >>> -
> >>> -		ptl = pmd_lock(mm, pmdp);
> >>> -		if (unlikely(!pmd_trans_huge(*pmdp))) {
> >>> +		if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
> >>>  			spin_unlock(ptl);
> >>> -			goto again;
> >>> +			return migrate_vma_collect_skip(start, end, walk);
> >>>  		}
> >>>  
> >>>  		folio = pmd_folio(*pmdp);
> >>>  		if (is_huge_zero_folio(folio)) {
> >>>  			spin_unlock(ptl);
> >>> -			split_huge_pmd(vma, pmdp, addr);
> >>> -		} else {
> >>> -			int ret;
> >>> +			return migrate_vma_collect_hole(start, end, -1, walk);
> >>> +		}
> >>> +		if (pmd_write(*pmdp))
> >>> +			write = MIGRATE_PFN_WRITE;
> >>> +	} else if (!pmd_present(*pmdp)) {
> >>> +		entry = pmd_to_swp_entry(*pmdp);
> >>> +		folio = pfn_swap_entry_folio(entry);
> >>> +
> >>> +		if (!is_device_private_entry(entry) ||
> >>> +			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
> >>> +			(folio->pgmap->owner != migrate->pgmap_owner)) {
> >>> +			spin_unlock(ptl);
> >>> +			return migrate_vma_collect_skip(start, end, walk);
> >>> +		}
> >>>  
> >>> -			folio_get(folio);
> >>> +		if (is_migration_entry(entry)) {
> >>> +			migration_entry_wait_on_locked(entry, ptl);
> >>>  			spin_unlock(ptl);
> >>> -			/* FIXME: we don't expect THP for fault_folio */
> >>> -			if (WARN_ON_ONCE(fault_folio == folio))
> >>> -				return migrate_vma_collect_skip(start, end,
> >>> -								walk);
> >>> -			if (unlikely(!folio_trylock(folio)))
> >>> -				return migrate_vma_collect_skip(start, end,
> >>> -								walk);
> >>> -			ret = split_folio(folio);
> >>> -			if (fault_folio != folio)
> >>> -				folio_unlock(folio);
> >>> -			folio_put(folio);
> >>> -			if (ret)
> >>> -				return migrate_vma_collect_skip(start, end,
> >>> -								walk);
> >>> +			return -EAGAIN;
> >>>  		}
> >>> +
> >>> +		if (is_writable_device_private_entry(entry))
> >>> +			write = MIGRATE_PFN_WRITE;
> >>> +	} else {
> >>> +		spin_unlock(ptl);
> >>> +		return -EAGAIN;
> >>> +	}
> >>> +
> >>> +	folio_get(folio);
> >>> +	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
> >>> +		spin_unlock(ptl);
> >>> +		folio_put(folio);
> >>> +		return migrate_vma_collect_skip(start, end, walk);
> >>> +	}
> >>> +
> >>> +	if (thp_migration_supported() &&
> >>> +		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
> >>> +		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
> >>> +		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
> >>> +
> >>> +		struct page_vma_mapped_walk pvmw = {
> >>> +			.ptl = ptl,
> >>> +			.address = start,
> >>> +			.pmd = pmdp,
> >>> +			.vma = walk->vma,
> >>> +		};
> >>> +
> >>> +		unsigned long pfn = page_to_pfn(folio_page(folio, 0));
> >>> +
> >>> +		migrate->src[migrate->npages] = migrate_pfn(pfn) | write
> >>> +						| MIGRATE_PFN_MIGRATE
> >>> +						| MIGRATE_PFN_COMPOUND;
> >>> +		migrate->dst[migrate->npages++] = 0;
> >>> +		migrate->cpages++;
> >>> +		ret = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
> >>> +		if (ret) {
> >>> +			migrate->npages--;
> >>> +			migrate->cpages--;
> >>> +			migrate->src[migrate->npages] = 0;
> >>> +			migrate->dst[migrate->npages] = 0;
> >>> +			goto fallback;
> >>> +		}
> >>> +		migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
> >>> +		spin_unlock(ptl);
> >>> +		return 0;
> >>> +	}
> >>> +
> >>> +fallback:
> >>> +	spin_unlock(ptl);
> >>> +	if (!folio_test_large(folio))
> >>> +		goto done;
> >>> +	ret = split_folio(folio);
> >>> +	if (fault_folio != folio)
> >>> +		folio_unlock(folio);
> >>> +	folio_put(folio);
> >>> +	if (ret)
> >>> +		return migrate_vma_collect_skip(start, end, walk);
> >>> +	if (pmd_none(pmdp_get_lockless(pmdp)))
> >>> +		return migrate_vma_collect_hole(start, end, -1, walk);
> >>> +
> >>> +done:
> >>> +	return -ENOENT;
> >>> +}
> >>> +
> >>> +static int migrate_vma_collect_pmd(pmd_t *pmdp,
> >>> +				   unsigned long start,
> >>> +				   unsigned long end,
> >>> +				   struct mm_walk *walk)
> >>> +{
> >>> +	struct migrate_vma *migrate = walk->private;
> >>> +	struct vm_area_struct *vma = walk->vma;
> >>> +	struct mm_struct *mm = vma->vm_mm;
> >>> +	unsigned long addr = start, unmapped = 0;
> >>> +	spinlock_t *ptl;
> >>> +	struct folio *fault_folio = migrate->fault_page ?
> >>> +		page_folio(migrate->fault_page) : NULL;
> >>> +	pte_t *ptep;
> >>> +
> >>> +again:
> >>> +	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
> >>> +		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
> >>> +
> >>> +		if (ret == -EAGAIN)
> >>> +			goto again;
> >>> +		if (ret == 0)
> >>> +			return 0;
> >>>  	}
> >>>  
> >>>  	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> >>> @@ -222,8 +334,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
> >>>  			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
> >>>  		}
> >>>  
> >>> -		/* FIXME support THP */
> >>> -		if (!page || !page->mapping || PageTransCompound(page)) {
> >>> +		if (!page || !page->mapping) {
> >>>  			mpfn = 0;
> >>>  			goto next;
> >>>  		}
> >>> @@ -394,14 +505,6 @@ static bool migrate_vma_check_page(struct page *page, struct page *fault_page)
> >>>  	 */
> >>>  	int extra = 1 + (page == fault_page);
> >>>  
> >>> -	/*
> >>> -	 * FIXME support THP (transparent huge page), it is bit more complex to
> >>> -	 * check them than regular pages, because they can be mapped with a pmd
> >>> -	 * or with a pte (split pte mapping).
> >>> -	 */
> >>> -	if (folio_test_large(folio))
> >>> -		return false;
> >>> -
> >> You cannot remove this check unless support normal mTHP folios migrate to device, 
> >> which I think this series doesn't do, but maybe should?
> >>
> > Currently, mTHP should be split upon collection, right? The only way a
> > THP should be collected is if it directly maps to a PMD. If a THP or
> > mTHP is found in PTEs (i.e., in migrate_vma_collect_pmd outside of
> > migrate_vma_collect_huge_pmd), it should be split there. I sent this
> > logic to Balbir privately, but it appears to have been omitted.
> 
> I think currently if mTHP is found byte PTEs folio just isn't migrated.

If this is the fault page, you'd just spin forever. IIRC this how it
popped in my testing. I'll try to follow up with a fixes patch as I have
bandwidth.

> Yes maybe they should be just split while collected now. Best would of course

+1 for now.

> to migrate (like as order-0 pages for device) for not to split all mTHPs.
> And yes maybe this all controlled by different flag.
> 

+1 for different flag eventually.

Matt

> > I’m quite sure this missing split is actually an upstream bug, but it
> > has been suppressed by PMDs being split upon device fault. I have a test
> > that performs a ton of complete mremap—nonsense no one would normally
> > do, but which should work—that exposed this. I can rebase on this series
> > and see if the bug appears, or try the same nonsense without the device
> > faulting first and splitting the pages, to trigger the bug.
> >
> > Matt
> >
> >> --Mika
> >>
> --Mika
> 

