Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D44D26D9B
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 20:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8316E6B0005; Fri,  9 Jan 2026 15:03:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DF396B0089; Fri,  9 Jan 2026 15:03:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66BD36B008A; Fri,  9 Jan 2026 15:03:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50BBE6B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:03:13 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03184160940
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 20:03:12 +0000 (UTC)
X-FDA: 84313499466.11.9D6E78E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf03.hostedemail.com (Postfix) with ESMTP id D0C3520011
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 20:03:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dNm1D6+Q;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf03.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767988989; a=rsa-sha256;
	cv=fail;
	b=iQLMX+2auzBaB7/lKxt9TtHAl870rf6vklMAe4gnoiV/1pub9l/VSTQaMGHdFiayDCW3NM
	mIHqTkpObAlTJwAdVUuvkMtOkwkhCedc1OMc/rIzbKKMvX2ccfEmEXygwTNidZClZXhGxt
	mDmXleoqEJJAn4V7NDtbdRf6AB0k8E8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dNm1D6+Q;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf03.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767988989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LiDOXihVxGjR24hq47T93y/Ie5VjLHQemIKufY6onPY=;
	b=NTjPDkK6d+C+IDjln2t+I5TgRNsUmiWLnYqsOrgbCGp3iUENKE8V8m2WqBEOtAsVvfv4KD
	WOSdmP3xsEd515raWydndL7KAT9vjB/83lVxKeQwtY6oPRZj8b8jSUYXVMEwuTopNGSXjJ
	XJ8dWy/mTq7PlsoyirJ+5ycMnwsZmF0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767988989; x=1799524989;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=3efuFY8avHC2JArgCjay9FGZgOkNpEvmHIUfTc9EGgc=;
  b=dNm1D6+QODx/+Yy9GClGEBppwVBZkXAhkj3I9jOf7+evGtkmW/NefFf3
   3kA4nrWuaFUmH+S6KOK5IBkbyydfGkZ8gLqda6Y05oGcMoFlWAIsViWkU
   iB0eW6Kwtj6J9eqYtNN3aMQZxGdGM44HpestXb/Tm1Y7iOqli3TwA5eP7
   4n0xwnKngRNzpbrXsQJWmhTrESgRPhSwzOicxxsCXL8JCcTF7ObJ515Fz
   2E1prjtl6zbiYFIUzBHW8EVAPB120jUyCpzOMg5lUT8n6bX0i+dSUFChb
   dmROmXf+S+aA0XpfOEvK8hLPm9PAQQiYNPkwvXFhSbCuqKNALRkroog8g
   A==;
X-CSE-ConnectionGUID: akPAZWUwQxmntH8snrKNsA==
X-CSE-MsgGUID: oi27wTvtSuGPJMI2fwxLjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="92036249"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="92036249"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 12:03:08 -0800
X-CSE-ConnectionGUID: B62n0WI4SXyKjUjGyZHhzQ==
X-CSE-MsgGUID: cQJV44h0RuSnE3u3UhB8tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="203970362"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 12:03:06 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 12:03:06 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 12:03:06 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.39) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 12:03:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KDwe1r5j8AePvGb2bEmhKAmDaRdFwDhyxCc0/D7zRZD9xUGN1O5kWpa/Vny6Bo83RbOXTBlpHRSq1cCWkhHn4Gf8AfpqBBfkPVqCjm3zRIvor/C3g7uIo1rRJOY+jIfPSpGB/9+SRp2WLCi8zWkPHo1iFyj/rV4lelFn+t+kzZfhojXsUoYM1e1C6hEC4btZ4vfrGVTr4HpkE7ePZWxfFtfdPe0+JAAcoOrOJVQKYHsFHdgs9HT+pY35w3zz7IRpTO40XH1rZhIKzYfSjpU1HVIxJTi4f7O8BVfQy4R9jX0aW27Gv0s+HH8GRhl2HKaGXsP4BlG94tQnrBvfgmrxdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LiDOXihVxGjR24hq47T93y/Ie5VjLHQemIKufY6onPY=;
 b=wKX3ICdOYgNMuSokIOipeM9Xkgm/kmuqodpbi+2bK8gKvSPD029bq19zNeOacNUq91O0rmUU7N6DdBH/2kSWnh94EueV0Tobq6ygM36bU9odsaJO1w6IfekfkYM/OlAxnPyMUzyBpGe9em+97SZLQoC04E3OCO5p39OH5KDoTItOR+S9dC0xIysRJ+3IimIH+KfebZvhrN9sR8kfQJgCaAY8RkykuDRPEBRI9R5hgXFIIWQRbsmM1glMA49SmjfERHsD0Erdr8ZFWk+AJQxCqnmumxQmswDQVVK3BgOFLyMTWTessKZnBXhoQUFHt81eik3NhuyIhdVcxZ99KpEkOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by PH7PR11MB6722.namprd11.prod.outlook.com (2603:10b6:510:1ae::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 20:03:04 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Fri, 9 Jan 2026
 20:03:03 +0000
Date: Fri, 9 Jan 2026 12:03:01 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Zi Yan <ziy@nvidia.com>
CC: Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>, Francois Dugast
	<francois.dugast@intel.com>, <intel-xe@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, Balbir Singh <balbirs@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>, David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/7] mm: Split device-private and coherent folios
 before freeing
Message-ID: <aWFe9S2DGwfD2smO@lstrano-desk.jf.intel.com>
References: <20260109085605.443316-1-francois.dugast@intel.com>
 <20260109085605.443316-4-francois.dugast@intel.com>
 <d1d80b81-678d-4d28-9ac2-95cb74824e73@redhat.com>
 <DF5A6B81-7811-4654-855F-8EAB76CCCE51@nvidia.com>
 <aWFIW6XCKXPpIinv@lstrano-desk.jf.intel.com>
 <D9ED5F01-E758-4A89-87F2-ABFF5197231D@nvidia.com>
 <aWFSGc7MIUqVsilw@lstrano-desk.jf.intel.com>
 <12A9DCBB-0B59-4D63-9BA8-9F99570AFA80@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12A9DCBB-0B59-4D63-9BA8-9F99570AFA80@nvidia.com>
X-ClientProxiedBy: BYAPR06CA0004.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::17) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|PH7PR11MB6722:EE_
X-MS-Office365-Filtering-Correlation-Id: 238de939-2d53-434a-9b8c-08de4fba192a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QjZ6a0NRcEE5bDhFOGY1cmEyN3FpcXNBNTJrSk9LQStQaDRuNysvSnQ4ZTdR?=
 =?utf-8?B?VUYxdTd6MXFHS0QzY1FEMHUvMGZ4KyszUkEwTXhwc1JDT05haDkxQXUwZXZY?=
 =?utf-8?B?cjRyM3BlRGNmNjIwdWFleUhXdUVwWVFRS1RneHBONGU4K2JmTzdIdWsrbjlY?=
 =?utf-8?B?a04vS1NUU0NvcURhUWJXeE1FeGYxaU9FekFIenRhOEdLU0hTcFd0TWFuZld4?=
 =?utf-8?B?R0N1SGx2UWhtOWw4am90eEJ6TS96aHZ1T0xCdlhkd0diMDJFRUNxaEprT201?=
 =?utf-8?B?MEhYMTNVVFlMTVRkNFkxcSs5Q1NvVSs4cnhrSklvVkdXbnpNN3dVSk05Y3dL?=
 =?utf-8?B?UDRiS2hueDJtYWwzc1VYS0pEL1hDbWVsZ1BkbkFodEpiUGRKa3FhU011RU9I?=
 =?utf-8?B?VXQ1aUR1YVMwSXZVd2ljMjZ0TlNmZHFNT0JRUW5xTmlHaVpVUzhxY251VnAy?=
 =?utf-8?B?ZVphSkhaczdmZE8rTUlXRk5MalZtaTg2OVppUldlbzhJR1JzcE1HczJteGxN?=
 =?utf-8?B?dFl1Z3ZHNzdlV3pPZE1ZeDFaeGkxYk9WbkdVMjF3N25DZUxBelZaakxvK21Y?=
 =?utf-8?B?NGhlN1diV29aV1U4Q2Y2bk9Zd0UvUmR0Vk5xdzRYMkMwM1lwM0cxZDdwbTRX?=
 =?utf-8?B?bHVickRTK2dGQWJCWHBpeStqQWtFOG1UVW1BRDBjWGZKSkkvK3RXSEZKQnV5?=
 =?utf-8?B?K1Avc1BmKzAyNjBXRm4yNVhqeGx4YkVXa1czb25RVmlUQ3RZckRJRXp1SHFq?=
 =?utf-8?B?N0s4blR0dTF6K1Z3VEdmbTRiQ3A2T05mMm4xYXdNQjhlOXNzUWx6cEpQQmNn?=
 =?utf-8?B?MGF1eFpadlA1eXZVZ3ZUanBzbHRjSnJDcktvbEQ2TGNYOWFOMmZ2VWNqK29y?=
 =?utf-8?B?c0MvSzBmRHV5K1JxZk5Hb2tmT1NxZ01wV0lLQjZQbU95RHJwWkxnRXRNSmgr?=
 =?utf-8?B?b0lWZ1ljNk5URGNxRnB0SG1VcUgvZ3BocjBwMUNURjdaN1lMZzA3YXVuaWJB?=
 =?utf-8?B?SWgvcG10VkNHcTZQRzBhM3hSRldQaEIrMy90ZlNaeUF3UWwvc3NjMml2V3Js?=
 =?utf-8?B?K0dheVZrVE9BYVR5OUdYMkJkNGdCVXE3cE1sU0RFYU8xeXBNT2FITmZLL1po?=
 =?utf-8?B?VUhpQ1hRZ1IyU2I2c3lXb3NBOFgrekNOT2xkak1IRXJMa0dWa0wzVWR2RnpL?=
 =?utf-8?B?amxFa0Q4czFBTGZjdEJkM2kyNnF4Z0dhNXNzVGI3OEprbDIrMlNvZWpiaHA3?=
 =?utf-8?B?NFo1QUp6WmxLNWpkTW5mOHEvSmRHa1RxVzRSTUdpenZPN0F2b1ExcG5BZzkx?=
 =?utf-8?B?dWdIYTQ3RmhCY1lIeGlEblBtcXk0MUVxSDVYeVJtM2c2R2ZiOFdOTUV1b3pk?=
 =?utf-8?B?alNaZEJIZmFUWXNxRjUzbGQzeW9uTWlHL0J6K1R2VVhvaE1RdHBMV1g4RCtU?=
 =?utf-8?B?R2ZxRCsxRWRsdko1QklvZ1UrRHBOQThQRlMvYmlMMHY1SzRvQ2U4b1NhLzdU?=
 =?utf-8?B?eGtqYlI3YmQvMmdYazFPZHc2OXdtc3E1aVpwSlJGL2pDSjRMaHJDMFFuRFdR?=
 =?utf-8?B?M2JtSXQ3SHBDVEJXRkk1eDVRdGR4YzhGcE1kOFMyRUMwLzNVdHJoZDE3L3lQ?=
 =?utf-8?B?YVMvMUluRzBkM1ZVOWRvd0RGa0FOYmNLYWdZQmpJSFdrVkxuT1NjbnpLUTFs?=
 =?utf-8?B?MUY4b0RGOUFKSGFBNDZ0WWdRcGxmRzBCNE8yNVV2S0gzazdvY2NDQ283OWZR?=
 =?utf-8?B?eUJ5QWJRQW5OcFVDK3BYS2U2SnFkd2M4bVErRGVFV3lCK0g2QjdzaURFK3U5?=
 =?utf-8?B?YnJ5T3h4b0tUUExHK2RYOTZvRHlSUCs5MGM0ZCsvbW4vbE1pdzdScmxRRUpE?=
 =?utf-8?B?MzlNWHY4RUh5RzBhWlFIdjZvMDRLMXpVYzZ1NktNS205ejVPMVpPSnpaU2hq?=
 =?utf-8?Q?JkvdarMpQk/UHLiEt52jlQ8bV1aBwyMu?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXhRUlREMUc1WXJHSUF2dE5zRmxKTmZSUzNRNGgyQ3FVQzc5c0lzVFduTTRV?=
 =?utf-8?B?M0V6VW1XSlB4blBNRi9WakdvQVFYRzRqakJTdFRwWk5pckd5ckJ2TUtHT1Yx?=
 =?utf-8?B?QVBtVlQ0UWszQnJZQzJTMU96NVpzS09DT3U1Yng3N1FsbWYzaU5BWDkrNEY1?=
 =?utf-8?B?RXFkekxpRS8xRndybjVBdExTQ2E3OVpGQXFpSmkvYk9PT3ZKR3FvMGxUY0l3?=
 =?utf-8?B?bSsvdEFzQjVsdWQrbkpTc2xkNU9nZ09UUWxWUWcrQ2JUeElWZlJneWwzUlpM?=
 =?utf-8?B?dzViTlBmQmNaWkZVaWRROHNma3luQ1N1Mm83d3NiT0FFa2VWdTBabCtxbUth?=
 =?utf-8?B?YjNyMm9xZUwrVlJ4NTNKUGFJOFNNTWhFcnIrL2tzZUpJOHRXeTZOTzU1Wkw5?=
 =?utf-8?B?aE5xT3ZuYlZWR2UyV1hpa0VWMGF3ZU42QVFRYitpbjNZK3VZK1FrWHBvRVls?=
 =?utf-8?B?dXdJU2JWalhieXp1Q3I5TEc1OFF2c1k5NDArZG5BNUkrSzFRb2Z3S0NHeGdz?=
 =?utf-8?B?NG5NdE1IS0xxcWVXQi9WdzBPUEZzaXIxbjVjZmxOOXhiTFhhY0Mvd0ZoQ3dq?=
 =?utf-8?B?azVkZWpTcnM4dFVVUEM4OUIycFFKRUEyTTdzOEhyTW0wVnF1Y3BEeFFDeTJw?=
 =?utf-8?B?NjBNTjdxL3hMeXhvMGJKT01TQjdHbmpWQ0pGRi9mbE9oN1ZORWhXMDc3VG1s?=
 =?utf-8?B?TXpJbmNmN3FReTFJVDMwNWp5WUd5dWVBblBuUjNnOVh6aHJ0Y3ZaalFDL1JK?=
 =?utf-8?B?YzhQOXA4VEt5RU9jVDRiemFOQ005NWhUOHU4UkNsVXhRS21hVldvQUtTb2NR?=
 =?utf-8?B?aDRFYkZnWTdKakxRK0NYTmtNRlpKbGRkM21QMk1aRXY0dndCcm5yTUZMVUEx?=
 =?utf-8?B?d2dCb2JlaHhTLzEvM2tHMmJhajdOTnFHNk8rR3l4QTJLQWZmZUhZZEZJQ2FN?=
 =?utf-8?B?QTlyQXdWMUQxYkJ0eWQ0R2RpaUVJQkxyZWhRNXlOVkErVkk1UkdVbHVFSGV2?=
 =?utf-8?B?dWhoeDdZelBlTVNnTHdZOGYvZVFLc3R1TzVUTjUvWmNDVFlrUURBcWU4em00?=
 =?utf-8?B?WE94cERFTGJXRm5uMCt5NEY2cjRRdmlDMEZNMzIrdjdna1RqUWl6a2xqMzNG?=
 =?utf-8?B?eEpZREVLdE11L291ZG13ZFJkQUN4TUR3eFBJeUJVelNGNGFKL0F0eXhlTVB2?=
 =?utf-8?B?eVlIeUVMU29IUDFlU1Fva24yWUl3alNOSDhuRy9nd3gycnBPQzZnR1RrdEJ5?=
 =?utf-8?B?cVJIbW9PSnhLazJrVmZKZmNtYnV4bmhVRU95VXBYRnFmWHRmQmltVG1MakZx?=
 =?utf-8?B?b05iVkw0RXVWbW9UZkdOTHhiNHpNbDZzRXV0R1h1MVhnekF6YS9iWmlXY0cy?=
 =?utf-8?B?Q3pabUYwTHRna2hqRzFMU0RzOUFSSXFKRmI5eXJLU25iQ09ya3JZcnZYOSsz?=
 =?utf-8?B?OEpZa1ZVM1IvTnp4V3VoRVhVZ3FhQnorank1cjEwdjg3ZXFqdktDRVV1czhu?=
 =?utf-8?B?VVFKQ0dWNEVvbHovMVFEMnVoMFhCQ2FHMm9wTnBpNSt1R0t4WE1ZSHoyUUJo?=
 =?utf-8?B?Mk55SlF6Z3B5cUZ1dFlvZ3VORS9vSXRxbEZ5dmt0UmhZb0Q5SWRLUTl4RE1P?=
 =?utf-8?B?czJJRXNJOHh6TTkzckxqMjVSZUdEVXNGZXBWM2JKUHZNc282Rkk0ZzZlajNX?=
 =?utf-8?B?THRGM2tYaFBCenpJTHB0NVExV1VBRVdTNkkyKzN0U0oyc3FJaWhQaXlvZXBB?=
 =?utf-8?B?bG90TksyM0piYVZMeWMvOXF0YnIvUFV4bVpJRVBuNDZxbk83bmpCbHFTMnJ5?=
 =?utf-8?B?T0JJZTFCWWpsZEt3aGx3ZVJodmVVTU9WT0ZabE96V0V6MlJlNUZzRFZhTG5m?=
 =?utf-8?B?NGpBS0wyaUFHbklBQmJMUVY3ekMxSkZCZGlQZGhOSHNmS1pXMkorb1pYSXBy?=
 =?utf-8?B?RDdRRWV3czUvZm9Qa29XdmtUUm5kOEJTR2grRlFxc0lIWnlRVHVyY0twM1lN?=
 =?utf-8?B?UGZ4Nk1SOXlDbS95ajU0bksrbXlJTmtReXpScDVwRFdUOEFwTHpFbTVJaWlW?=
 =?utf-8?B?QnJlZDJmbGhuNXVUd0lYNmFYTWxSOVB5WjcrUnIvRnFmaVV0Z2pndURxNlZN?=
 =?utf-8?B?aFArQWRGSFQ5V2lsbkFadEtnK2tqcnpCQVR1aWhwV0pNTGJ1RWQzV0c2MGtK?=
 =?utf-8?B?cDZsc2pIKzdSM0VVcnYzSHdSM3lwcFBqWThvSUJ0VzJpSjhIM2NxOE9hcDlO?=
 =?utf-8?B?K3laaUF1QUFUUHdFQWMraFBIN1hGaXcwU2NqQUJBeFhsMVZ5SVFPME5aUmRN?=
 =?utf-8?B?dlZBTzhQR3N2YmJ2b281WEFWUFRKSzRCci9GalFXdmY2YndNdFkvSzJxVUsw?=
 =?utf-8?Q?bash5WY13cOg9G2U=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 238de939-2d53-434a-9b8c-08de4fba192a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 20:03:03.9328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IQidKG5bFw4Kam8g1X8i6AEMgtv3Fhipjys0QKktD3QqtJ6H6z6y1PHLEL3Za378ic80OS+XcNQjcCMD9U7rMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6722
X-OriginatorOrg: intel.com
X-Stat-Signature: 4rxie9hx7otyow1zz6a8aon1oohs935p
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D0C3520011
X-Rspam-User: 
X-HE-Tag: 1767988988-633708
X-HE-Meta: U2FsdGVkX18Ed+Z2QjnJj3eUBGaxTBdsIWVc+Jd4g/dJUXGWGIIqhGAq9hbec/c005emM4/cTywkfpeWbDPPc2JwcKgjn1U1BINdBSr5kK9YqebuZYIEHg4BH1jgs5SfzOvZNss2Hq9JIfhGEPXHX4NwUG2xAeKx5bEYRnhLeX9oliqTpFlFl1fRpzbFRO3x6FtpAM0mIea4KAQA8guIOdF78dRTjqAzwtAlnkRoO9k9h1NGlBxmOqRkCdEP/XvfLSGfWiTa3bZw8MUNikzw0zrwku/wFJQC6ZjXFpIbQURxPVmn/g/4azh592Q2NiS0hgitAs4fqihWo1lSXRHoCjRUPxzMMai6lG0lniXxMetpSwnV2YRgOAQt8mjzmlI/90hsMUFMIJRJ7hodxtGXwzm6bzSRVR6aq8Gts2Ax7gaJ/fGrHx/sGUCxdvQiK54pMsfL93UumV82XANsPXfh5DU23mF0cIrGqnkodxcgppN6pI9TywIEI7cE6uLeLImEF/4F6AwGEDE0UjH7bdMRd/AfdduMHViwkypCHZH6wrwJ4JrEOMzePhS3hlxsL0Elih08iDRSlmVCI5NZftKqAOLUQsXXV0sG8XTZ8J18UoV/JbR0aNUyU/NTAb4IK9Fl9zhQWBqHgcP2RXA0q+PluNwn7cBbnRM7h8ygdkf3aKvW8qOcenPEFZhobOe9LF6VQ9izWjqMn3bahEDYdVGcSfHGeI5pfyucqs92W514BJwlZ89rqxxOqLx+05i2nowoyEobOMSW+ADqoWa16vNHQk3c/CxUK0UTqv5PGOxM3VKyZ5fohKFXV6BGczhhgkyOJiLCYyigfZ4mEB0WdkC/yHLNhrBAMV3JXUgFBPvq9qlsyY7ghfADCP/CKgmcFpqXHXDoBUMfP7X+9YMjPFVAgkM6hR1TvvtcQm2MM1XIYM9Wq/WxRG/GNcJR4UIKjTpUHPd26g8WW2wfTeIl7YD
 wJBrYTPz
 JOtEgA+yGZL6Z955h6xhyzWPP9ouqzJZbXaMBcJOAvvF/EorljoqRLRgMCUtSxnTdeBCpvcerBOx26r5IJ0RjRyQkBgiYeLRk/pW89h0/Vj5lbMKomuJ35sWp4R79O8uCQzOofQKpYBTeJ8dyy4tWdWrViJaErtjOpRjxKkOB8bi0ZcBAtjf7nYxqEeoL+kDIDMlFp7Iv227kPOnXpvhwC5aCKoJsHdClB0vDmhN7Qm6zJURMniOnnwnX4HU4FsVo0IacuA4/ewajtHxwz3A/RGSGbQgJA+JyO6hmdWpUHx9c8zOFPnsBuZJjwSfr+1NeCJPgLVsYPZD7bsRt4dAVTYPp/fxxZjBcN/KPd+zU1Gy3mj/Mt5fYoG64L5jCRscxoIj84BN6kdzRqvCDqeX7IoQN8IJMoG97W0D+P0n5vnVsvzBAae+rQwHeNZEwwOFiQ4aIKYS34CMEJGW1uGE0xEBVoOm1aI3/4gScfnIk0tEutvsp109vV7zuc4Bp1dyl6WEzEfgg2vWpnxMMPrh8bJ7b6VIViM+UKDkXHyCLamTCScirI16JNPqax1IUGI9sqzaAyj/f9M5EpnLZ38HIzaRsToCcUAN4Ant4/esNfqDVN6Wd+XPdmC98DNJGgYi13PW9/8P6L9DfGUTK5+euhFEQvr12oawpVkmJH4OMvgC2rhJU1jx5FmAT1lQRrUKCpeh5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 02:23:49PM -0500, Zi Yan wrote:
> On 9 Jan 2026, at 14:08, Matthew Brost wrote:
> 
> > On Fri, Jan 09, 2026 at 01:53:33PM -0500, Zi Yan wrote:
> >> On 9 Jan 2026, at 13:26, Matthew Brost wrote:
> >>
> >>> On Fri, Jan 09, 2026 at 12:28:22PM -0500, Zi Yan wrote:
> >>>> On 9 Jan 2026, at 6:09, Mika Penttilä wrote:
> >>>>
> >>>>> Hi,
> >>>>>
> >>>>> On 1/9/26 10:54, Francois Dugast wrote:
> >>>>>
> >>>>>> From: Matthew Brost <matthew.brost@intel.com>
> >>>>>>
> >>>>>> Split device-private and coherent folios into individual pages before
> >>>>>> freeing so that any order folio can be formed upon the next use of the
> >>>>>> pages.
> >>>>>>
> >>>>>> Cc: Balbir Singh <balbirs@nvidia.com>
> >>>>>> Cc: Alistair Popple <apopple@nvidia.com>
> >>>>>> Cc: Zi Yan <ziy@nvidia.com>
> >>>>>> Cc: David Hildenbrand <david@kernel.org>
> >>>>>> Cc: Oscar Salvador <osalvador@suse.de>
> >>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
> >>>>>> Cc: linux-mm@kvack.org
> >>>>>> Cc: linux-cxl@vger.kernel.org
> >>>>>> Cc: linux-kernel@vger.kernel.org
> >>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> >>>>>> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> >>>>>> ---
> >>>>>>  mm/memremap.c | 2 ++
> >>>>>>  1 file changed, 2 insertions(+)
> >>>>>>
> >>>>>> diff --git a/mm/memremap.c b/mm/memremap.c
> >>>>>> index 63c6ab4fdf08..7289cdd6862f 100644
> >>>>>> --- a/mm/memremap.c
> >>>>>> +++ b/mm/memremap.c
> >>>>>> @@ -453,6 +453,8 @@ void free_zone_device_folio(struct folio *folio)
> >>>>>>  	case MEMORY_DEVICE_COHERENT:
> >>>>>>  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
> >>>>>>  			break;
> >>>>>> +
> >>>>>> +		folio_split_unref(folio);
> >>>>>>  		pgmap->ops->folio_free(folio);
> >>>>>>  		percpu_ref_put_many(&folio->pgmap->ref, nr);
> >>>>>>  		break;
> >>>>>
> >>>>> This breaks folio_free implementations like nouveau_dmem_folio_free
> >>>>> which checks the folio order and act upon that.
> >>>>> Maybe add an order parameter to folio_free or let the driver handle the split?
> >>>
> >>> 'let the driver handle the split?' - I had consisder this as an option.
> >>>
> >>>>
> >>>> Passing an order parameter might be better to avoid exposing core MM internals
> >>>> by asking drivers to undo compound pages.
> >>>>
> >>>
> >>> It looks like Nouveau tracks free folios and free pages—something Xe’s
> >>> device memory allocator (DRM Buddy) cannot do. I guess this answers my
> >>> earlier question of how Nouveau avoids hitting the same bug as Xe / GPU
> >>> SVM with respect to reusing folios. It appears Nouveau prefers not to
> >>> split the folio, so I’m leaning toward moving this call into the
> >>> driver’s folio_free function.
> >>
> >> No, that creates asymmetric page handling and is error prone.
> >>
> >
> > I agree it is asymmetric and symmetric is likely better.
> >
> >> In addition, looking at nouveau’s implementation in
> >> nouveau_dmem_page_alloc_locked(), it gets a folio from drm->dmem->free_folios,
> >> which is never split, and passes it to zone_device_folio_init(). This
> >> is wrong, since if the folio is large, it will go through prep_compound_page()
> >> again. The bug has not manifested because there is only order-9 large folios.
> >> Once mTHP support is added, how is nouveau going to allocate a order-4 folio
> >> from a free order-9 folio? Maintain a per-order free folio list and
> >> reimplement a buddy allocator? Nevertheless, nouveau’s implementation
> >
> > The way Nouveau handles memory allocations here looks wrong to me—it
> > should probably use DRM Buddy and convert a block buddy to pages rather
> > than tracking a free folio list and free page list. But this is not my
> > driver.
> >
> >> is wrong by calling prep_compound_page() on a folio (already compound page).
> >>
> >
> > I don’t disagree that this implementation is questionable.
> >
> > So what’s the suggestion here—add folio order to folio_free just to
> > accommodate Nouveau’s rather odd memory allocation algorithm? That
> > doesn’t seem right to me either.
> 
> Splitting the folio in free_zone_device_folio() and passing folio order
> to folio_free() make sense to me, since after the split, the folio passed

If this is concensous / direction - I can do this but a tree wide
change.

I do have another question for everyone here - do we think this spliting
implementation should be considered a Fixes so this can go into 6.19?

> to folio_free() contains no order information, but just the used-to-be
> head page and the remaining 511 pages are free. How does Intel Xe driver
> handle it without knowing folio order?
> 

It’s a bit convoluted, but folio/page->zone_device_data points to a
reference-counted object in GPU SVM. When the object’s reference count
drops to zero, we callback into the driver layer to release the memory.
In Xe, this is a TTM BO that resolves to a DRM Buddy allocation, which
is then released. If it’s not clear, our original allocation size
determines the granularity at which we free the backing store.

> Do we really need the order info in ->folio_free() if the folio is split
> in free_zone_device_folio()? free_zone_device_folio() should just call
> ->folio_free() 2^order times to free individual page.
> 

No. If it’s a higher-order folio—let’s say a 2MB folio—we have one
reference to our GPU SVM object, so we can free the backing in a single
->folio_free call.

Now, if that folio gets split at some point into 4KB pages, then we’d
have 512 references to this object set up in the ->folio_split calls.
We’d then expect 512 ->folio_free() calls. Same case here: if, for
whatever reason, we can’t create a 2MB device page during a 2MB
migration and need to create 512 4KB pages so we'd have 512 references
to our GPU SVM object.

Matt

> 
> Best Regards,
> Yan, Zi

