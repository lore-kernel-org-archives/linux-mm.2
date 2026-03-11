Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 294861125841
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 15:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DB786B0089; Wed, 11 Mar 2026 11:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385EF6B008A; Wed, 11 Mar 2026 11:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2588B6B008C; Wed, 11 Mar 2026 11:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 012916B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:03:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93D9B13A007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:03:11 +0000 (UTC)
X-FDA: 84534100182.08.5FF988D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8030980002
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:03:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LkRAAATu;
	spf=pass (imf02.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773241384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q2PLZbfKpWbocpQoL7s9BuT0wzgTrnoMZ66j260UZuI=;
	b=1wNVHnsWmlDQa8DL2dCSy7Bkd6+iZ8lQDXyb4hLtTlIporircD7kPvDYRZl0w9SagCIMjF
	DmeacgoLlXYiRnOiYfCVED9osNkabUDilcNio72Bf/Pgg3gIoXnJqPsaFwSiTirIvaMg5r
	xZTRBNmsSmFpcS3p+4rRrWMmY9ctldE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773241384; a=rsa-sha256;
	cv=fail;
	b=xynbOpBj6ycDW/lkx4FL5WvnrxyWGLqAnuGdSww09kQz4f1E3zzFNIz/cNAqfsr3i3N1Jj
	+GB3JU2p1/tCaeizBT1syk1nx1qulCialTLNgHXnyC0N77EIMgfJmaXjk+YhxJ/mdOK04P
	hzuovFj+vlC/vVYVdr3hCjRcQ/eG5jA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LkRAAATu;
	spf=pass (imf02.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773241385; x=1804777385;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zi/7e7rCtQB6liDKcg3a6a2/OoM1zFbmI/8kiC/Qt6o=;
  b=LkRAAATufVBSiZcCMk3ta7hvc2xLCAZE04BuDbbAoYSqCOL9Ia3BTwUU
   rdzUR2fFy3qjKLZUrrXxZQckP8XGOAvXcFRFLUacHjooOOE6fSAgizn83
   4ykaTOSRdXnxRB4oB5ZSpt+m+GRS9JIRfZHgIlNueFbVdpV5tDeM6GdAu
   emNr3H1J13Nt8PnIr0lR0gZcD9/zH+HLI3DVdpn0pb00TbhVyXB9VI+DW
   dM+06jlhb09gIP/uNqV74DyAPtjFmoDgwdqZbW42f07TFFIGIdSHD+1Ut
   x6aIjflnmGb8393jCZmNKixG7KpHbYJWsdwW4ag+TVMc6tyfXIlRAqCas
   Q==;
X-CSE-ConnectionGUID: zxfd2MqBRI+EZ08aR+vgMg==
X-CSE-MsgGUID: Lp4OgbdjTZStBq5J+8WEaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11726"; a="78165522"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="78165522"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 08:03:04 -0700
X-CSE-ConnectionGUID: IGek92XtTHyAVPlzNcxjhw==
X-CSE-MsgGUID: xAVcav/2Su6oSma8FuzWjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="225469390"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 08:03:03 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 08:03:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 11 Mar 2026 08:03:02 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.5) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 08:03:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZG+ogsS16ejUuEHYQtmlTDo8IA5KJod0k5juiNAHzWGWbIM5C1gwUOcmILAbeEfxP9t62p0pw6DFeQFPK45yncdJJOam02XPt6RUcCIDBt5wbXX5YXFY9UkUH/Lf/ZoObAGNfJnNSLZTo5ZuwwLf0e7+tgwTeZYfDpzs4TSAZJ4c6z/vk2J7J0rk0cvs29lTuiyl30vRw7Ty7oWVv+3w6VsqMlt/AYkTCkiZ3M+V8irQSEyCx6wdqqRyzFo9YDdxoa9qBPIeXKCiYQBGCyZvG1Wu3Yl/PYwShzkRVrcA3ONPvOPyEzBldQ+i5jLUQQ3orMxmrAfq9I9t1mhg00bk+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2PLZbfKpWbocpQoL7s9BuT0wzgTrnoMZ66j260UZuI=;
 b=ntKpynd5fQcLAxfx4ar4NYviehSl0UIbK3hKXzvhXtFHZdYGNqTNVNXDYcDi+TYDWqqbUzzvqot3r9CuzrC35X8BJXNu6B/a840FLIwOjsBXuSYsHuCP/IJvWdt9m9J+3EgMgRw4VoNChnUTH/TldmalN922bogz20xAEX/kXjftMe/1OuiO42tPA+x+0m++7rPyJbZ1tYJVexo6cjDmiRIHP58Uh4cfPb/JQCDO4/IN+NjIHUgfqeCzqls69ymgDKPPtLBPe2/EZyZWun0O4O6xznePcGdpgZbvcAalWov2wZS9S46pLpF4N00jnd7VAkzJRRwZxty0mgddUhTZvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by CY8PR11MB7105.namprd11.prod.outlook.com (2603:10b6:930:53::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Wed, 11 Mar
 2026 15:02:58 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%6]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 15:02:58 +0000
Message-ID: <214b2cb0-e0d9-4482-956a-5bc599bae45e@intel.com>
Date: Wed, 11 Mar 2026 23:02:48 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: "David Hildenbrand (Arm)" <david@kernel.org>, Mike Rapoport
	<rppt@kernel.org>
CC: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>, <linux-mm@kvack.org>, Yong Hu
	<yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu
	<yuan1.liu@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo
	<qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>, Pan Deng
	<pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	<linux-kernel@vger.kernel.org>
References: <20260130163756.2674225-1-tianyou.li@intel.com>
 <20260130163756.2674225-3-tianyou.li@intel.com>
 <3cb317fa-abe0-4946-9f00-da00bade2def@kernel.org>
 <aYjmcZ4hg9bNbmiY@kernel.org>
 <6ea2dbce-c919-49d6-b2cb-255a565a94e0@kernel.org>
 <2cb55d76-4da7-4ebe-b23b-0abbc4d963f3@kernel.org>
 <aYsaBkMecDG595Xg@kernel.org>
 <b3777d0e-0b25-45bc-b387-e67fe5a0d328@kernel.org>
 <de501b65-6d02-4eeb-b50e-bfe5ab9b8d00@intel.com>
 <24ef67e7-6f0f-4544-a50c-90c4de368c40@intel.com>
 <383e1567-0966-434e-a818-f70bff1d5220@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <383e1567-0966-434e-a818-f70bff1d5220@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::10) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|CY8PR11MB7105:EE_
X-MS-Office365-Filtering-Correlation-Id: 22a54e50-4aac-4482-7fe7-08de7f7f4812
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: B1PgQeh/FZHRvZun0AzmLgPlzlJQhBVSsZwb+VVbGCJ6r2MIH8hOUNwad9htWzdsuwuNjdONhgAmDRWDCrynARjC27Xk/kqCefnAgLyWGsAfNsEmul2PYrSzymlQqaOucIu4r6f/TgT9lKeQOt/G/l+92z2ZlIeQHA5JP4ZEU/BGOhVmQFfb6FXx7hcR7B1rfsTIoye8Gxq3BvP6B0WH50T01dHm3aqJw1ixSdyklbNJ6vPXNKYviWI3Qmj+F3s4Es/HDP1pnqMHtkeDhf7uApjAJkxZrMsKBLwvH+AYvbdyE8SK6SWGmxziAeocCfUNy4ZE9uNKj8u/2uCld0MIH1PuyV8NWByEQOfoOFeS8h4ZA/MzoQ09g1pXWdTeMzCF2Fyh6220UkSUIG3CtXEqjs38M66K4L1EG/FOHTcSYKmh3NaC88bnaDgVQDCQ+kqeVzlApxzGY1z3qQz8Sanr2sG4iHTB9G7W+a8m+lglWBRe2abBHuaIqfuzgPQJbRB8aW+34Wl+Cj54T9FrV2gUmf2c7kMRAKqTuXM8s1Y1K2DjUYk49WuCeMdgs+1iPdq1sAXHvMP1l9yn2rDHM4n+KP2TRFUmDjEaIFz/7TvswTXw+ob22jsYunZUwe5aLg1U3txA4KsbXS9RJ1smL2D/gpDNiJN9C46sdZ6pF9Vdc6xCcLdhRzDLFDeEY9e36SfaeHWpSi/WIkXbFEZvHsfoch6ZYzlDYdwTQJ7VO5BNuHg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1RJZ2FYQzBMNlBhUzB4eFpWUlRpM3ZwZWxNQlNOdEI3Z3JTQTU5WDdpcU1u?=
 =?utf-8?B?ZTY4WWJxSzdJbkVDQ0NDTG1kZXNLeUJCalFXR2JIM0NNTFkrZks0ZWpMUGMr?=
 =?utf-8?B?aWEzRVpmcDgwSU4ySTFicmFwYTRzK1EyY2NOSHFweUZ3RFpCd01HdWozRUpG?=
 =?utf-8?B?Z2xiQ20zNUt0bUFHZkdybGI3WG4wTXpUQkRZZGJ6WUlXQjQxK3JsdmM0anlm?=
 =?utf-8?B?bnVPK0F4NktMMXh3STZrelVaWWJxaU9kZ25WSUx1ck51ZUhobFhSS3dDN3Bm?=
 =?utf-8?B?eTJnTnhFQXNZYWZraDdZOFZjd3lCbFY4b3d4U2o2T1AwZFMwSGVqNHJEZDRT?=
 =?utf-8?B?czJIQlFjS2I3WGlSNmkzL3BDdnVSNjhadGtFZjJlQ1hiUjFwb21kZldFejZl?=
 =?utf-8?B?UUpEaEdUT3RZL3pJa0hxbDRnVkNRT3FRdVV1R3paSEo5M1hlTjdNclBBbEh2?=
 =?utf-8?B?aER4dDVreEdVMFJQaGVXUUNyWXdZMzRzdmdnV2xqNVh0cmkwL1JEQjJZbVpu?=
 =?utf-8?B?cFdESEViMEdjdE1KMWFpdERsMlRFRE5FVmk5eWZSSFR5WWRDek5QMlo3LzB5?=
 =?utf-8?B?ekF4ZVVtSVJ1Z0FYc3BIUTJpSlBwcU40ZHd5aDJPT0JmSVhaTjZ1REdtQVIv?=
 =?utf-8?B?MDNGc0llbVJXSm1ET3BWeHVJN21JL3dZU1BFMXNhU3pBNjZxTzFXb2cwZlF4?=
 =?utf-8?B?TUtVUTZUVUhDRnRkbFlzdW04QWgrMmgrdzBKSzRPRGN1MkpPZFkyTUEwM1cx?=
 =?utf-8?B?STV3anQ1OEYzTWE1QU1jVjA5Z0x1Ym5kVWhoajl0WXdmanN5cU5lWHhWUkpL?=
 =?utf-8?B?ZlhXM1Y5TXhyWEFGakw5THRJSXp1WEVRZXlzR1c4V21lYm9OVkU3UVZVbnB0?=
 =?utf-8?B?cXExNEhUZlRWVHlvdWw3dHhlOTdIS2xMSXJiK2Z2aFlXREgrUWtKQUs5OWl3?=
 =?utf-8?B?NDNoSlYrOTlkS2JoUEhlSi9XWmQwcE1UZTJyWlJCRHFGQVpWNGo5aHFDUVZV?=
 =?utf-8?B?NXFoTnJlTkYvTEFZS3ZmSWtPaGUwN0tHMlNYclpGWS9jUmxuR1gxTmdZcUMy?=
 =?utf-8?B?UUxNZXBHTk45UDJ6c1A0SCtRR3ZHSW5xZERGRDllMlovc2NKTFJpK3FoS0xQ?=
 =?utf-8?B?M1VFd2ZlMlljZ3pBSis0TXNtYXdHbnJkUzluTVY5OW5Id29NbmxVeGxZcWJh?=
 =?utf-8?B?N1ljclRIK25hQmh6Wkl5WVlaZURYbVJTOGZtNllRSU5kM0g3M1MxNytpL1VT?=
 =?utf-8?B?RC83UzZ4ejlsakdRTUVnRlA3RXN1d0dSNEJLajVySXlVenlrdStScWkzbEo1?=
 =?utf-8?B?OGZaL3BudThWTDkxUzRROHRTY1hiR3dxZ0Fpbzk3NytsTkZON1BsazdGNWMr?=
 =?utf-8?B?QnplM1pYVHZNc3cvWFBlTlp6MnpQUVRyd3I5V240UXk2QU9ZTmhpU2owK0VF?=
 =?utf-8?B?cTIxVmZ2U2JnTEFrZTc5bVh5VlE1L3VQcjYrWW53YVpiUVo3UEFEWFphbVFH?=
 =?utf-8?B?dDZnNDR2eGRseFpOMTN6WVB3UjNNdnJqSGdhcFJkNUlkUWhCOEJ0TE1Wd3Mr?=
 =?utf-8?B?WXBLZU1XcXZZeEQyTTRVWWNrSFROOXRiSEhnanlSTkxjNjJiQXNhYnMwZzNl?=
 =?utf-8?B?NmxlU3l5YlRhS1c0WjBLM3RuR1d2MitnQXFJNWdLWkxKNTJNL1ZFdmFrSVRk?=
 =?utf-8?B?SEdkUEtiZkpTY2g1bmZXSEh6bFNwdTRJVGVMZnBnOVczUHV3S2NOMUZnTzhM?=
 =?utf-8?B?QlBZZ1pPSmZVNmtsU21xMENib1NTZXIyZ3o1dTUzcDdSelU3Yi9uVmN1NHBv?=
 =?utf-8?B?RjlZckpEMnlucW1RY1RxMFRXNFFjd3JaNklFOEY1R2Y3RE9KL0ZQQUlSWFRu?=
 =?utf-8?B?SzU4SVpRS2JycDJaZTVmWCtVSmQwOStGVXFRVW91eSt6ajhYNWEzT2tHLzZa?=
 =?utf-8?B?WDlYRXZvdU92c0J4RnJGV2RTa1RGTy9rcUtzejRnTEVka0RmZnB3aFppMjJu?=
 =?utf-8?B?bnp6cUkzclFRaWlnV1RLQTNpVXBLQkZZQm9CQTlzK2FzMW5nVTFtZ2UrRE5r?=
 =?utf-8?B?RjVIK240NG9Hemx3S0NYMFZGU0dkdHc4b2tVWjJTY3NsY2ZRNjVXTzQ1cE0x?=
 =?utf-8?B?aXQ1QVA2d3hWUTZhU21rZGFVVGNHNjdpbkFMQWJHeEtNZk93SVd5a0dNR1FR?=
 =?utf-8?B?Syt6UGlmSDJ2UzlLUFBUcVU4Z3BLSERzbFJ4M1VRS29LSitveHpFSnpLRUtt?=
 =?utf-8?B?UXNlOHpEWXJVb2NKdUNFbG1ubUxRc2NiWXlwM0FWNWJDUER2R1dmVUIwVnhS?=
 =?utf-8?B?SWpsN0tRcXkzSGkvdFBEQjViUWtwQ041amhqSHRyZlJDVjhtOWx1dz09?=
X-Exchange-RoutingPolicyChecked: IBxh/dpKZI0DEP8wIN0pI/BLWefC4MxN7jBLoqF/HVV8P0InWSfAejiWwIrmV61bv7M2o88qjmyEQzseRN+EfcjqhD355bVaUsRvBtCUDYOCB7txrMDDDeh/bLchnhzX42BbZJMsGW9NNG/0tA4sFTBADeuUcsfYp+r+9tdDKzPW940rD/nL76Mzo9b4ypLAJf2a9EsG9yKtT9pKiFSB+XV74KaH5nSMW0Cbq/4DPJ8o9UYBZWEa4CEAoAR+3e7qGzeWxC+LmTrortxFZaaiPcUvDyzNGTcmPxYhO9x1sfZyQgdUIxJRqsTooC7ZOhAStNLuzkEgYge32DVQe2xPiw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 22a54e50-4aac-4482-7fe7-08de7f7f4812
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 15:02:58.3478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cgbdWs3iFBZ/oyQWuSSbICo4Ad2M5MTlnFVr148BEdifWIIO43y0jrccrkQeWs0tp8hzo4GhOvF5iK4Rh3UX7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7105
X-OriginatorOrg: intel.com
X-Stat-Signature: rsrcpfqhigais3erbg9rohcs6pux7tug
X-Rspam-User: 
X-Rspamd-Queue-Id: 8030980002
X-Rspamd-Server: rspam12
X-HE-Tag: 1773241384-898354
X-HE-Meta: U2FsdGVkX1/jt2uB95NJNQKVOsvJlzofcPI0OHjzA1PQOxX6z5c8ybNracflwULeBIy184tAcz8rQcuG1Br29iHxyLcecdxCb7sDaeL/sjsu8AjlCIHLHLPS1U2zKY1dci36C6VnVeNwBrAhIV6GhaAjqG8fZ84kTlidmiL622CnusHg0f69Z0v5e5euJL3zDuFg62gt7OPlo6uyECFAxwlcEAh+dxj8e5wTaSceWfGjrIGy+vhC3QQ0X9ZGDF//Y9ec6DtISieHHrSYbg+8Q6KcGddxQxpmwPXgM1Z2vPAPux8S+gIQJecjD1OWYWSjMlcTAm0cbX71ua2TODBXm8+bsUF+JaeC/DR4km1Z1/ww7bNi/K5E/SEymKCFJOVRBR76g8i5OJ8fvLldg7mjZebyv4i4MPM7IUHls81HSl8gak3tPPQiF3po4af8aD/fDhLrrHJiPBYRrAe7C3/taZ94KmyXWQzgX7mce8BxHjBhSRExLTGoMh2LdM2vV7amRF/wU63MO8N8eKp0ouWHkkwCt338VfhoTyslIO9fxzZWNAB6kIJYeJoEDtJwDCJvxguBWlNY49uOM8d5WFbCvfY1Rqp/cNgc4feJoD9NJeuFHk96ZI4C/x0B1IlQaRT32V8ncFXM9eeWiIsjq5APx6a1HCeYfdIe3NQVu6ksKxKQH2IyUldHWGCIVe6jjqQLWoxlLHPkHufA8thmUUJI+zrR65yoCFy+wzUDV1H7XhJEEBtIc/BxJuiBg/Ti1QXykwi+83oM4sjBmsjRFJQHTZMj6qF157zi/QJKLguRG841Ew9x/xRuX2yq5OTis8cgojWFxn/6CUzIfAoD1yGAn1qAfaMHxG5htSZKfBgbVRG8y6mgYT4ZIU27jLBs5kwZjX+HnDzdYYTsNz88qW4UCQ5fP5YPCZsR4Gv7Ga3FaITwocjAm2i0Y+kohjxJkPfUsJR9X/iKbcj72ZmeopT
 8xYGneMe
 ei8RzwrdjE4Ct+HCgm4Zundxs+gBa+tBbKnNAx0Huch2fpF/AIY7P0+qUGLkQCenNlqSpXYBRfUfCR1QlcM3tfRNTM2Oibd+D9ioHLur8itMy6B7zMA9PWJyzASwRiSZysUQbpvCZ2L5QS0yFnWnzKNYkbxhDYtO+bXKwwpRbV12dY0CaNosNqHAgK6Ajf0bJzI5pO2Cv5rSkeLboydNBcL2J5xN9hbTNs/xJBRZ7X62ZBKDo1p2tu+nL9dPmMbryzK+3oj4QDRw9Un3l5C7qjqbDB7NVv4NxXI2X2MBfg0VypMr2fFJW2QDis8NyH/9RO9e6OEz8pnRTXrqboAG5sMZziEBlBl1w++QqYyykVkhpom2/WC9ukykr4EGV8U1s17Ufwe+zdLnRpCmQrZhr9vJ7kkJwX0V6KLjuLg90k0nSio0/HO4ISyk9J7/tLB0qWNPOk+X12Nzd6H+L1YPBoRURZ5ymewRcHbZ9sG/5m2JV6nm+8BOkdHMwwzPeKKZBBZU8vEP0UZQB2uKxWOkbpQIlUuj9ijZl2jowiOsZhvNviAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/9/2026 10:26 PM, David Hildenbrand (Arm) wrote:
> On 3/9/26 01:42, Li, Tianyou wrote:
>> Hi David, Mike & Other maintainers,
> Hi!
>
>> Just a quick update: Yuan and I created a new patch based on David and
>> Mike's code, updated the documentation as well, performed the
>> performance test, double check all the references etc. We observed a
>> slightly performance regression, not sure it was caused by the
>> environment configuration or we triggered some unexpected behavior. We
>> might need a bit more time to investigate. Will send out the patch soon
>> once we have confirmed data for the performance regression. Thanks.
> A performance regression would be rather unexpected, unless we somehow
> don't ever set zone->contiguous=true any more :)
>
> In which test / code path did you observe a regression?


Sorry for the late response, I missed the email by accident. The test is 
simply hotplug and unplug the 256GB memory, the time became 3s instead 
of 2s for some reason compared to previous patch. Interestingly, for 
512GB memory hotplug/unplug, the time remains as 6s. What we planned to 
do are: 1. double/triple check with the same and other servers; 2. 
collect the perf profile to see what is the diff compared with previous 
patch, if the regression consistently persisted.

I will work with Yuan on this and hopefully we can have more information 
to be shared here soon. Thanks.


Regards,

Tianyou


