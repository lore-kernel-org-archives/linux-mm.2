Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DFC2EA812F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 15:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88016B0005; Tue, 10 Feb 2026 10:28:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35A06B0089; Tue, 10 Feb 2026 10:28:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9446B008A; Tue, 10 Feb 2026 10:28:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4DF6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:28:41 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34A891605F9
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:28:41 +0000 (UTC)
X-FDA: 84428929242.18.08F1C9C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf26.hostedemail.com (Postfix) with ESMTP id 13AD1140006
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:28:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DINHlJcr;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf26.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770737317; a=rsa-sha256;
	cv=fail;
	b=0s5654ipVJm3IEuJk1PXnu8CXH+movszTgkkqbyLkxHfVbS7CNvJxBlDCRZzGP8BTPY/UL
	jf9kmN0yyY41ZYWFWQLuw1Yv4YLgrAOZyiJWL+lLyvUmEAl6PW5Kbwtf8luxQabde7+MvJ
	p/va0h/sc5vYyOF9EqHcYoNeFGHPttI=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DINHlJcr;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf26.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770737317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AlEHryzQDS/8MOD7VxyidT/nP/sMPeeuxMo8wwEoYV8=;
	b=hH3xoDM5M8qpNBbtE5krgnvbS9nUF9S9sqK/XpqlGu5UQubThyD29sMMg/kw7J0gZ5oOA3
	B+rIpNCr4A6L0tXwh8H/6dD1H8T0wVcvY2Ybx+/6VeuLjGR8Ug/yRUp4kVnWnQxTaWzT6o
	vnU8RdPGWrNIZsQGerrtjF/VnBv1pTk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770737317; x=1802273317;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/frZdFT2/HE8iryPJ9Zgy3rGzpo7mLlQSOGWvIOKnbw=;
  b=DINHlJcrBT0+DkkW/Sp7JanCvnpxslKPlBzoiTV/bEy2QgulHYEXx2Lk
   o49h1JarmNGZdlf0ZF9usEgUpFObxb8IOnPEZnkwehcKYE5OjMZg8ge6B
   mkTG0/W7TKjaF7CnHUBhbasbSLKM+jRnRhqRQ8ePtSyqmXSK54n2qJ9MH
   FyfBh3vEkIOjtKxISxF+nVkiTtRoSo4BhNc/Q1PK5InPLq26R2Wxripov
   6XMDANySEF6XCdM6R1JV6Un0MxwrXuLo1oUWvrhLXwqFopd5n7BOfQHH3
   n4BOaVuUc/QuY2NmYWFm6y7A6rQcb04tVWxk5h0FKqML+8mm/T6FXqA1J
   A==;
X-CSE-ConnectionGUID: 3Qb0BbnETyuhmT/XAxI1GQ==
X-CSE-MsgGUID: LgGmIMVjRnKdE0PN1nNtqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="89459441"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="89459441"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 07:28:35 -0800
X-CSE-ConnectionGUID: o9MFRVIhQGuVt0niI0xRmg==
X-CSE-MsgGUID: kor42X1XRzOIiu281l/DVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211025907"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 07:28:35 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 07:28:35 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 07:28:35 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.52) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 07:28:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TBUjzDcZs4kq+YbmkF3KgIP38ViGJKftBrIgAFcv9O4xft9DFNc7i4gD3TzNzwNHhTMPqAQVagj57wi5Wbg17ybasiA9jhn44VzLaxRdxmhTnAGE3/nKO4LnAYDfHrp9SEIs8wWWnGPqn5mSjyLVfZstpY23WCYtkOxXDB1LaHlyt7jImAjBJ7UWw1IbOknA57hRCRVRR/mgd25bLdq6FZK23TNGfZ/S4RH+GjdoD3Oi7L3t1ibLjHVMHIJVvFljAsq6f6UMXSewK2ehU83+oseUMZB3zsG69AtNgBK9SjIO6Res2xgxw+UwuGseYUpiw6HSPQOxTiuUjJn1oybr1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlEHryzQDS/8MOD7VxyidT/nP/sMPeeuxMo8wwEoYV8=;
 b=xGX9ha+R9PB9xdJnoJfrUpwaORfrdgI+RR+HHqthEu6MFZExjr5vvZlawVwTrm7nq/EFzYpxMuJ0h7EzKUMtbE06TqxkkV4EWZJppyaHIXcgjQ0FtOWIE+GBB4/s7Y6+anaQf+SgIPqnc6COAYsowBvmhQRigVJ0/2lGFRdTN1D6Hu2gmNAaFI6e5PQaEGUxBqi+dPHNTb+uIA8kEITtHAY7cVDCENmy09X39A1lityJrafNVf3y4y4uRBe3+YJeGH2hS5kQNIIhfRzfumBNCN3f0iUVH7FuoNl2knIg+rCwmL5/ZoxL24NlxAeMnxH9deHF0INGi+OmoRnpJy0kNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by SN7PR11MB6728.namprd11.prod.outlook.com (2603:10b6:806:264::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Tue, 10 Feb
 2026 15:28:30 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%3]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 15:28:30 +0000
Message-ID: <4660c8e3-92db-4555-8168-e8cc57c92230@intel.com>
Date: Tue, 10 Feb 2026 23:28:20 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: Mike Rapoport <rppt@kernel.org>, "David Hildenbrand (Arm)"
	<david@kernel.org>
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
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <aYsaBkMecDG595Xg@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TP0P295CA0035.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::17) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|SN7PR11MB6728:EE_
X-MS-Office365-Filtering-Correlation-Id: df4d80cb-ba3b-41a7-6457-08de68b90ad8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Yzl6NzM4WkI4ZlJnR1owTTcydmJxSG4rRlgxc2llbkl6OTdMNEpiL0JoV3dk?=
 =?utf-8?B?RE51SGRHejkvcUdZeDA1cEttd1RkKzVTNFEvb3Y4VjlUYnZDZS9XdGFNWGxp?=
 =?utf-8?B?bHRuY1ZEb3ZEUllRcGZTVjlzbnFHcHlFaExyNzRvU0JsN0RQcEV3NFRoOEpC?=
 =?utf-8?B?a3ozQVFpYlN6Ym8zejFtVnQ4SnBndzJCempoWlQxbkFxcnRNQkNQQnJheWhW?=
 =?utf-8?B?eThMY3IvUllqTmg1Y0Fmak5FM1ZibjB0RFBXdUFtWW9oUXVCU2NWbWpWTm5q?=
 =?utf-8?B?eEUxUzhTTjh0NnBRaW9ldG5FVkY4aHhxRFY2dFlyVEg4T0cwdmZleTBkdWc0?=
 =?utf-8?B?MGRzYW1iWE5iUzFZSUdKUE5wNlEyTER6Z3BnMHl2QXJreTVVN2RqZisrblMw?=
 =?utf-8?B?UzIzdXl6S2NiYXRNSGFrVFFOcEFoaWV5ZkJHTzZXWm5aZmhUNUl5c1BWZWgy?=
 =?utf-8?B?bzlNQm5oamdkWExIbmlBNzJ3MDdNQVE4RW9ZcnNMT2tEaUhodnZGYk1yWFJa?=
 =?utf-8?B?TW9VMWxhQTI2VGg0bllGNkZ4dmFhZys3b2Y5OVROYlRDQVIvUnd5RllPSlp3?=
 =?utf-8?B?aDBobGYrRmU1ck8xdkZ4V1pIb3ZXN3RqRjRhSHlPUVBwQmtlTlZyWEpvd29F?=
 =?utf-8?B?R25TaFhVYVJGRXVoUWNtZnlWN0N1YUhWbzZQTm1seTZBcDNLR0E3dzVweXBt?=
 =?utf-8?B?RDMycXBKZkhCbW1ReHdNQnlQcnFVV1hkd2hJSDdMMm44Q3R2aUc4L3JlKzR1?=
 =?utf-8?B?NFNoQlRGenZhTkcyc1F1MFRiVUNUSEF4Y3RDSnVtMlFIdDVmaytBOHNCUnRG?=
 =?utf-8?B?S2VZczBnTlk5SHVMVk1ha3Z1Nnh5OUh3K1pGR013dGdTdWMwMGQwVDlxQVlV?=
 =?utf-8?B?SVdsa1RZeWpKNTlnWnRySGtnak9xZkpYb3VoSmdLVmdlTHVZb0czUjBqVno5?=
 =?utf-8?B?YXBtZGhOM2Q0eEVqS0lETzAxUEVFWURDTGIxVzVpczFvUU14UExTVnNZb2Vx?=
 =?utf-8?B?dC9VNkhBK0FaQU04U2tOWWxXL25UNXh5VkxCMk1rcEFrdGU1aGNKMjQ3SXIy?=
 =?utf-8?B?Yzk5UGtrQlJ0M2pldE1WTVdpZlM0VTMyVlkyY0RlY1c2RWxxeUJGWlNGellW?=
 =?utf-8?B?cWNUY2RXQWZsR1I1aHlCSkhDMkFrZDJUb3NOOUpSUzRWcytjQmFIaTU3TXFC?=
 =?utf-8?B?cHFNc3BlY205R3krNDBjeEk3UW0xZmQ5UEZOL0d1OUpzTmFoRlR5QnpNbmRV?=
 =?utf-8?B?Nk1oRlAwTC9vM3krZVZOZEZxUm9pTURUaG5UYWp0MWRjdHFqWWpCZnBMQkRC?=
 =?utf-8?B?WHk4TnZjd3B5eEVTbWluZlVaM2lWbTlEd3FaTVQ4QnAzWTE5SmNKWUtXdEto?=
 =?utf-8?B?VE51NUc0c2VwRzUrQ2lUKzdPRlhuUjBBZERIZWFrRkdTK1FkZy9PTGFDVkRr?=
 =?utf-8?B?MXZOcWtDZVRJR0FVbGsvSTVLT3k2OFpWNXZ5Yy8vMWtBcmlTa1ZIb2ttcUd5?=
 =?utf-8?B?bm1MY3hGOCtMK1lOM2tVUzVJSTZMQ0JEZXJaaStLYVB2NldNSlBjQnhVcG5Q?=
 =?utf-8?B?MnhpNDZHUm5MVDlZUUVjN3AvV3JrbDVOK0VVb2JCM0Q3SVovai9hS2hFcElI?=
 =?utf-8?B?dkhlL0tkMXFHMFBJalYrck9YalFQcHEvckRwZHIxVTAwNFJLSkxjR2xRZ3ly?=
 =?utf-8?B?NzUxZ3BKaHMzWjlWY1ErYXQ3dTJrajB0TEY4SmJDRXlobEhockxUOHlFWVZm?=
 =?utf-8?B?Vy9PaWYyblBlS3pxRmVHOWhTeG5EUHlITnRlbVNodG8rSXRkajVFNXVjWVhC?=
 =?utf-8?B?a3Zja2hDb1ByWEUxTW5VRUVsRC83bC8xdlJ6SEI0bk9QVTNIS3V0SW9WaXhp?=
 =?utf-8?B?WW9EMFNvYzhjcWNMek83TGZXQnN3Sm1GOVl2NWsvOC9OelQza2xHTDZOY29m?=
 =?utf-8?B?VHV3NG5hY256VEROWFRUV3JyemlvNWo1cjFsbmhOOFBvdjAwRjg4c1dRMGFV?=
 =?utf-8?B?MVUwMWliblA5UGFWczJrTXR1aitvZWNhdlZHc2VrV3RUSXYySm1FaGprNDFW?=
 =?utf-8?B?clpnb3VDRndtUkRqNitzMDZnVzFDT1pkYTFtOWlNY0JyNUhYQkZEWnRuM2Zn?=
 =?utf-8?Q?vipk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDZrbjl4dnMyZGV0WjhnTTBWTUFqcU1qT0Jwc3g5MTA2dmJrbWFVY0htbjQ5?=
 =?utf-8?B?S0MxWTlCRUgxU2dlNFhaSHlDTDBaZFhOcWoxUXhBcG5SMWpiSTM0UW5QSlBx?=
 =?utf-8?B?bXVySENtWXQvcXZ0eDNzZjBFV0cyNnF6QUxSMmcxL0Q4Q3lCV0pad2d3VWxT?=
 =?utf-8?B?S3ZYM2hmZzRUelFUdnB5bzk4V1h0Z1hnSVhNYi93akF5L25FZTBsa0FnbE5l?=
 =?utf-8?B?OWxTMXNxWXNUdFJUeGRteENNRlNjQTlKYU9oaFlrRDVOR1Q5WTdqazF2L1pu?=
 =?utf-8?B?RGtKRGJXeUdZMkUxRE50ek4vY2Y5bTN5dG5rY0t4MGE2cGMzaVhnVndVWHV0?=
 =?utf-8?B?NnhLcW4vNTE5ZC96WGM0aXR5bkNwbkt2Nm10VmlsU2VXK010OG9kR0hMR2Jk?=
 =?utf-8?B?aUszV2V4aldudlNnUGdJK21OOElDZ2hCN0pzQmFHNEtCRHMzVkJYL0hSdzk0?=
 =?utf-8?B?Z3BlR3NhTXFjcC92ZkZ0U2ZTNlZ6VGJzZHpBMGFjWUlzOWVaSEpBUG5VKzNo?=
 =?utf-8?B?MlVLaDNUVURrZXk4MkQvMHlIenRCbk1QT2YrVXdrUmFDbXJMT050SlljWEhV?=
 =?utf-8?B?WkNVd3ptN29WODhFZ0p3UVlXaHdneGFrL0ZHaSsrNGlBSklPMC9pYUg2aVla?=
 =?utf-8?B?ckY2ZEQ4RjdyeWtDNjE4R0svMXI4ZklpUi9RaG9mTzlpNjZlL2s0S29zOUZo?=
 =?utf-8?B?ckF0dGFhWC9JZHlVM3hpWlQ2RHZCdzVGR01lK29TdGk3bHRsdjkwR2R1TkJQ?=
 =?utf-8?B?QWlySVJ4UEttbHNtSkl0UUtFVCtQRTRHbDRsWTVweVNQQXo3ZS9tT1ZFYUlP?=
 =?utf-8?B?bFJScGhTVnpsQU1hVHFFVWVhMFV1bEY3QkN0b1FqTjNOZnk4QldPQVFVN1B6?=
 =?utf-8?B?Q0Fla3hlL2ZUcGFUd3hHV2RsUnFpNmhFL3NQdnBsTlZyU3gvbjFVNEh3RVRq?=
 =?utf-8?B?NXZOL3dUN1BlenYyVU16TVNhZXhQYms1T3NLeUFDc2RrNXBHOTR3enF6OHpm?=
 =?utf-8?B?SDdWRXQzVWFFRWFyQ2xvL05PYlN5ZmVLQ1BTZzFiVkRtcGZSdXo1ajJ6ajhh?=
 =?utf-8?B?ekMwelQyVHh2MWRvaHFHdm5ieTVhaTVpdllKcnlxdnh1SVp0dnlhR3plYkVq?=
 =?utf-8?B?cHk4Q0VucjhYaXBKS0hTdk1XY1pnUitJYnhKN3orVG5RSlpReUNIUVJETld0?=
 =?utf-8?B?czNVRzBaR1pZWnVPb3NoTjVBOW1RNFpLUDQ3VW5tenFvVE14RCtwYjIwVGEw?=
 =?utf-8?B?RGRVdlhoSTdFeVBrbWMybUN6dGFYNjBRRTQ3THJKUU5aR3g0WnlrdWdaNkh3?=
 =?utf-8?B?ZnVWVlozVkJQLysrcmZKVnk2T1o3dmduKy9NcDAyR1ErOGNuS1RiRXVNMXo5?=
 =?utf-8?B?LzFzVXlEUDZRWmpod3dNMlFrZ1VtcVc3Y0hRYWRqZ3JjOG9SbzRrZFVISlov?=
 =?utf-8?B?RHlxdDQ1SnhoMzcxOWJWRy9BaVNSOFV3dzkvYUJEbU95alk1NlJxME1PNkFm?=
 =?utf-8?B?NW5UTDliRzhaaEdnMXI4Yzh0K3RWdlNpdDVEQkh0VGFTbkZGYXIxM3N1YkhD?=
 =?utf-8?B?cnpWQ1FvQnR5aTE1WkJTUzRZcklYNWJqZzY3Vi9ZdmhvMFVFVGdrRHhjUVN6?=
 =?utf-8?B?KzVUbzJ4ZHZ5ZUEzVVh4c09obkZRaUtZS0d3bGhMRVI0RURqSWRYbnhnZHBK?=
 =?utf-8?B?WWloNmJpaWVEU2hQRmd5NWVqVmFUZTdHbkprN2U2WndxdUdVR3ROYUdscVZX?=
 =?utf-8?B?N0w5R1IxemRwa1V2NTNaaStwd2R4S29VZ2RkbFhEL1NYYWdyblo1bFF3RGpo?=
 =?utf-8?B?WlNFYXhJQkRVVFdQbDJDWC8wNy9qdWJxMktLc2hTeldML2U3dE5KNDZIcnJJ?=
 =?utf-8?B?M0ViRkRZSWY4SWlJby9LaTQvd0NFY0hhaTVtbklJRWtiMGpNMndwa01WSGVa?=
 =?utf-8?B?R1pZWHBRQnJ5RXlTVWdCSUFKbm4rcC9zWlErUWtVOVdRcFJ1NHR5REh0TnJX?=
 =?utf-8?B?VFAzdC9YVC94VEFlWEkzdUdtOHF1cmZodVhDeGlKU0VEMEpNTnU0R2NtMXNq?=
 =?utf-8?B?OFRYMWRKRk91U2JaMWZvN1NhcE1hS1ZjelZxMmlhWHdtNXlGV2UvNHpaejlw?=
 =?utf-8?B?YzNxaFZEL1ljemo1RTZXWFVIZDlOMVFMM3JwcHN1MGY0Wlpic0ZGVllURmZQ?=
 =?utf-8?B?a09DSEVXNVI4T2hoK25HMkIwZEltT3NMejlielpNY1lSOE9lZk53bHlnZjlP?=
 =?utf-8?B?MU9mdkxrQUIyMkpOaFZxOVBWT0Yrc2RhOCtwTTBzYlU2NzN2Y3NtK3Y0OWNI?=
 =?utf-8?B?UG1oV0FDbnlGWkpaMVhuSE1BaG5aaG5zMDdIL3dLWm9Wai9tVEU4Zz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df4d80cb-ba3b-41a7-6457-08de68b90ad8
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 15:28:30.0528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g7gWIOgBbCsKDzapYAtTMwSpyrZQqPKOOWmtIlRuy8YDK+w6OXkn6d81GwedqYWD/Pfsw3aRG+kWgk5W+iUpwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6728
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 13AD1140006
X-Stat-Signature: sp9yioooaicp4jnrot9mpx5hqkpddgbf
X-HE-Tag: 1770737316-144001
X-HE-Meta: U2FsdGVkX192n1tjIG2FkFQcYQ7R3sJsAgL1MEH6r1+vqBfw3ofcU81kFTfgwhKYW3yFD78aBhgL8Z9n9HYW0ZllZoDqNExuUkeC2NSwiVJ04P8IhtvhCpnVl90F8hfFLxxHAg8f9MHvPesG8kGof/QkCMNLfNtTZLXMJ8XUL+DSTxOGRaTkxFQ+1CYx7pT8TDLvpNVKLnWxwVje3oWvLTVFrikPX2fQNmOCxwbBv1RvCo3TRbBznH45KUj1kl1Xfg7Ol54MP5mWLJC9yi0TwbZfLNa3lcGAsOiAHr/iQ1SVyPJb+BPJsK2r21AZPAQ3Xp/ghxJ8iBGg/2FZG+0a1L7zP7yjaKj4l6xkmaHM3SdX54MfSEmMuIJENG4F13T8/tQlP3pUxRcul7bVm9r8B0ZYhPic6ZA1B/utNgYRPiszwvcFhRJveBSRG0ulHvBaJweCKpqTNo2K+i0pZIu4+08Wu+jSZP4S4pFOFcBVkvp7yLFiIVdUq0Xj8nQdI61KiAEomiwrkTubbjz6BYcWRILIh02cxxE3lY4V6zHnYbb2q48ZbQMIfGDHbOcjPVMwzfyp3PdYJfAnVLUhDsh+OcRoWlxH+1JzQKobJx6J8Ap06i2zam4FxdRyXqrNNutaZRSG6y9pBWSnYGqqW0MAgDBaXXou97J4F4H51N9fbL3eEsN56pYxxweH5PW7tBPLBzTxPX5N8hg/kiHWW01doh1/2UCnOvD9+AKA+UbzjHMmQVvjTeMmd/M3OKOBjBewimLEpCatGkJHXEYHTWVHOYtcbIquWwAj/bqUyVa9QqVEOvWhrisTB2TXekaSiM7M4r80kIJKbTf9lR0ca5CzdwFESP+ix5AYCXqiD+cj3HbQ6Xn6UXBpwi4qDcoHzkaXxbrTomasripIqHiUTog5xrh9MFjHtGcvy/0swZMXW7IO1gKxCBl8Bc4NgtxniSRmmq36thShGYTvqqMxaa0
 Im1PsYHl
 BsStmsqjd6cXWr8mvtUHjPjDMrYz5/bFwW4ZbfwoVV+g/IeN5e8vsMIBIU/z+sK9VDGgdUTDIb6YXbfL07HGIK96dZTx9sFYWVgBy6AeJaQFTkJ+mULC9Cr3HsOeJ1b0m+BRitj0GJio0UhOKUUAVbZX9xp03xbrlx3I0qrAW4fZ5wuYE+fYM/xc+4WuZUaAYjmdMAv38QXosRL3HQgz+00f+hwGXhUf8ZWhspL5NVFUcDlo07Vd0vFI5Ha/tYmWrCq6c1lC7vhHZqAWxcLbzrn0oikBCYtfL/Vh/+8KMfDjGVKV4Oqwp0oWuW3mn/uHp/Rhc7grzzGIYBDdKu02AFkvPd9u1mnx3aGY5VwV2ZVVdkR7UMR8XoQQXiSt0M2fZcmyHsTV1jfNb2BaBmyE+QEI55D6++4GXCh927BkQqze97WPB+w0oywdmRD6OxA68lvXwckFdrxGcuuOkI/cWYR3A7tWbiMJdBpMigBuCTpu9VyeuT5lBuXd8z0UFvdFJZPiugxh4N1/SKwfgxLbSJJP/t9cQUPwEqSDW/RifdZPMWAteG+JFmyAYdIczbHyul92STws8hGra6l7S/+5zIc4Y2tEl1WiI+5b4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2/10/2026 7:44 PM, Mike Rapoport wrote:
> On Mon, Feb 09, 2026 at 01:44:45PM +0100, David Hildenbrand (Arm) wrote:
>> On 2/9/26 11:52, David Hildenbrand (Arm) wrote:
>>> On 2/8/26 20:39, Mike Rapoport wrote:
>>>> On Sat, Feb 07, 2026 at 12:00:09PM +0100, David Hildenbrand (Arm) wrote:
>>>>> Thanks for all your work on this and sorry for being slower with
>>>>> review the last month.
>>>>>
>>>>> While I was in the shower I was thinking about how much I hate
>>>>> zone->contiguous + the pageblock walking, and how we could just get
>>>>> rid of it.
>>>>>
>>>>> You know, just what you do while having a relaxing shower.
>>>>>
>>>>>
>>>>> And I was wondering:
>>>>>
>>>>> (a) in which case would we have zone_spanned_pages == zone_present_pages
>>>>> and the zone *not* being contiguous? I assume this just cannot happen,
>>>>> otherwise BUG.
>>>>>
>>>>> (b) in which case would we have zone_spanned_pages != zone_present_pages
>>>>> and the zone *being* contiguous? I assume in some cases where we
>>>>> have small
>>>>> holes within a pageblock?
>>>>>
>>>>> Reading the doc of __pageblock_pfn_to_page(), there are some weird
>>>>> scenarios with holes in pageblocks.
>>>> It seems that "zone->contigous" is really bad name for what this thing
>>>> represents.
>>>>
>>>> tl;dr I don't think zone_spanned_pages == zone_present_pages is
>>>> related to
>>>> zone->contigous at all :)
>>> My point in (a) was that with "zone_spanned_pages == zone_present_pages"
>>> there are no holes so -> contiguous.
>>>
>>> (b), and what I said further below, is exactly about memory holes where
>>> we have a memmap, but it's not present memory.
>>>
>>>> If you look at pageblock_pfn_to_page() and __pageblock_pfn_to_page(), the
>>>> check for zone->contigous should guarantee that the entire pageblock
>>>> has a
>>>> valid memory map and that the entire pageblock fits a zone and does not
>>>> cross zone/node boundaries.
>>> Right. But that must hold for each and ever pageblock in the spanned
>>> zone range for it to be contiguous.
>>>
>>> zone->contigous tells you "pfn_to_page()" is valid on the complete zone
>>> range"
>>>
>>> That's why set_zone_contiguous() probes __pageblock_pfn_to_page() on ech
>>> and ever pageblock.
>>>> For coldplug memory the memory map is valid for every section that has
>>>> present memory, i.e. even it there is a hole in a section, it's
>>>> memory map
>>>> will be populated and will have struct pages.
>>> There is this sub-section thing, and holes larger than a section might
>>> not have a memmap (unless reserved I guess).
>>>
>>>> When zone->contigous is false, the slow path in __pageblock_pfn_to_page()
>>>> essentially checks if the first page in a pageblock is online and if
>>>> first
>>>> and last pages are in the zone being compacted.
>>>> AFAIU, in the hotplug case an entire pageblock is always onlined to the
>>>> same zone, so zone->contigous won't change after the hotplug is complete.
>>> I think you are missing a point: hotp(un)plug might create holes in the
>>> zone span. Then, pfn_to_page() is no longer valid to be called on
>>> arbitrary pageblocks within the zone.
>>>
>>>> We might set it to false in the beginning of the hotplug to avoid
>>>> scanning
>>>> offline pages, although I'm not sure if it's possible.
>>>>
>>>> But in the end of hotplug we can simply restore the old value and
>>>> move on.
>>> No, you might create holes.
>>>
>>>> For the coldplug case I'm also not sure it's worth the hassle, we could
>>>> just let compaction scan a few more pfns for those rare weird pageblocks
>>>> and bail out on wrong page conditions.
>>> To recap:
>>>
>>> My idea is that "zone_spanned_pages == zone_present_pages" tells you
>>> that the zone is contiguous because there are no holes.
>>>
>>> To handle "non-memory with a struct page", you'd have to check
>>>
>>>       "zone_spanned_pages == zone_present_pages +
>>>            zone_non_present_memmap_pages"
>>>
>>> Or shorter
>>>
>>>       "zone_spanned_pages == zone_pages_with_memmap"
>>>
>>> Then, pfn_to_page() is valid within the complete zone.
>>>
>>> The question is how to best calculate the "zone_pages_with_memmap"
>>> during boot.
>>>
>>> During hot(un)plug we only add/remove zone_present_pages. The
>>> zone_non_present_memmap_pages will not change due to hot(un)plug later.
>>>
>> The following hack does the trick. But
>>
>> (a) I wish we could get rid of the pageblock walking in calc_online_pages().
>> (b) "online_pages" has weird semantics due to the pageblock handling.
>>      "online_pageblock_pages"? not sure.
>> (c) Calculating "online_pages" when we know there is a hole does not make sense,
>>      as we could just keep it 0 if there are holes and simply set it to
>>      zone->online_pageblock_pages->zone->spanned_pages in case all are online.
>>
>>
>>  From d4cb825e91a6363afc68fb994c5d9b29c38c5f42 Mon Sep 17 00:00:00 2001
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>> Date: Mon, 9 Feb 2026 13:40:24 +0100
>> Subject: [PATCH] tmp
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>   include/linux/mmzone.h | 25 +++++++++++++++++++++++--
>>   mm/internal.h          |  8 +-------
>>   mm/memory_hotplug.c    | 20 ++++++--------------
>>   mm/mm_init.c           | 12 ++++++------
>>   4 files changed, 36 insertions(+), 29 deletions(-)
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index fc5d6c88d2f0..3f7d8d88c597 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -943,6 +943,11 @@ struct zone {
>>   	 * cma pages is present pages that are assigned for CMA use
>>   	 * (MIGRATE_CMA).
>>   	 *
>> +	 * online_pages is pages within the zone that have an online memmap.
>> +	 * online_pages include present pages and memory holes that have a
>> +	 * memmap. When spanned_pages == online_pages, pfn_to_page() can be
>> +	 * performed without further checks on any pfn within the zone span.
> Maybe pages_with_memmap? It would stand off from managed, spanned and
> present, but it's clearer than online IMHO.
>
>> +	 *
>>   	 * So present_pages may be used by memory hotplug or memory power
>>   	 * management logic to figure out unmanaged pages by checking
>>   	 * (present_pages - managed_pages). And managed_pages should be used
>> @@ -967,6 +972,7 @@ struct zone {
>>   	atomic_long_t		managed_pages;
>>   	unsigned long		spanned_pages;
>>   	unsigned long		present_pages;
>> +	unsigned long		online_pages;
>>   #if defined(CONFIG_MEMORY_HOTPLUG)
>>   	unsigned long		present_early_pages;
>>   #endif
>> @@ -1051,8 +1057,6 @@ struct zone {
>>   	bool			compact_blockskip_flush;
>>   #endif
>> -	bool			contiguous;
>> -
>>   	CACHELINE_PADDING(_pad3_);
>>   	/* Zone statistics */
>>   	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
>> @@ -1124,6 +1128,23 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
>>   	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
>>   }
>> +/**
>> + * zone_is_contiguous - test whether a zone is contiguous
>> + * @zone: the zone to test.
>> + *
>> + * In a contiguous zone, it is valid to call pfn_to_page() on any pfn in the
>> + * spanned zone without requiting pfn_valid() or pfn_to_online_page() checks.
>> + *
>> + * Returns: true if contiguous, otherwise false.
>> + */
>> +static inline bool zone_is_contiguous(const struct zone *zone)
>> +{
>> +	return READ_ONCE(zone->spanned_pages) == READ_ONCE(zone->online_pages);
>> +}
>> +
>>   static inline bool zone_is_initialized(const struct zone *zone)
>>   {
>>   	return zone->initialized;
>> diff --git a/mm/internal.h b/mm/internal.h
>> index f35dbcf99a86..6062f9b8ee62 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -716,21 +716,15 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
>>   static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>>   				unsigned long end_pfn, struct zone *zone)
>>   {
>> -	if (zone->contiguous)
>> +	if (zone_is_contiguous(zone))
>>   		return pfn_to_page(start_pfn);
>>   	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
>>   }
>> -void set_zone_contiguous(struct zone *zone);
>>   bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>>   			   unsigned long nr_pages);
>> -static inline void clear_zone_contiguous(struct zone *zone)
>> -{
>> -	zone->contiguous = false;
>> -}
>> -
>>   extern int __isolate_free_page(struct page *page, unsigned int order);
>>   extern void __putback_isolated_page(struct page *page, unsigned int order,
>>   				    int mt);
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index a63ec679d861..76496c1039a9 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -492,11 +492,11 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
>>   		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
>>   						zone_end_pfn(zone));
>>   		if (pfn) {
>> -			zone->spanned_pages = zone_end_pfn(zone) - pfn;
>> +			WRITE_ONCE(zone->spanned_pages, zone_end_pfn(zone) - pfn);
>>   			zone->zone_start_pfn = pfn;
>>   		} else {
>>   			zone->zone_start_pfn = 0;
>> -			zone->spanned_pages = 0;
>> +			WRITE_ONCE(zone->spanned_pages, 0);
>>   		}
>>   	} else if (zone_end_pfn(zone) == end_pfn) {
>>   		/*
>> @@ -508,10 +508,10 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
>>   		pfn = find_biggest_section_pfn(nid, zone, zone->zone_start_pfn,
>>   					       start_pfn);
>>   		if (pfn)
>> -			zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
>> +			WRITE_ONCE(zone->spanned_pages, pfn - zone->zone_start_pfn + 1);
>>   		else {
>>   			zone->zone_start_pfn = 0;
>> -			zone->spanned_pages = 0;
>> +			WRITE_ONCE(zone->spanned_pages, 0);
>>   		}
>>   	}
>>   }
>> @@ -565,18 +565,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>   	/*
>>   	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
>> -	 * we will not try to shrink the zones - which is okay as
>> -	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
>> +	 * we will not try to shrink the zones.
>>   	 */
>>   	if (zone_is_zone_device(zone))
>>   		return;
>> -	clear_zone_contiguous(zone);
>> -
>>   	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
>>   	update_pgdat_span(pgdat);
>> -
>> -	set_zone_contiguous(zone);
>>   }
>>   /**
>> @@ -753,8 +748,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>   	struct pglist_data *pgdat = zone->zone_pgdat;
>>   	int nid = pgdat->node_id;
>> -	clear_zone_contiguous(zone);
>> -
>>   	if (zone_is_empty(zone))
>>   		init_currently_empty_zone(zone, start_pfn, nr_pages);
>>   	resize_zone_range(zone, start_pfn, nr_pages);
>> @@ -782,8 +775,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>   	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>>   			 MEMINIT_HOTPLUG, altmap, migratetype,
>>   			 isolate_pageblock);
>> -
>> -	set_zone_contiguous(zone);
>>   }
>>   struct auto_movable_stats {
>> @@ -1079,6 +1070,7 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
>>   	if (early_section(__pfn_to_section(page_to_pfn(page))))
>>   		zone->present_early_pages += nr_pages;
>>   	zone->present_pages += nr_pages;
>> +	WRITE_ONCE(zone->online_pages,  zone->online_pages + nr_pages);
>>   	zone->zone_pgdat->node_present_pages += nr_pages;
>>   	if (group && movable)
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 2a809cd8e7fa..e33caa6fb6fc 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -2263,9 +2263,10 @@ void __init init_cma_pageblock(struct page *page)
>>   }
>>   #endif
>> -void set_zone_contiguous(struct zone *zone)
>> +static void calc_online_pages(struct zone *zone)
>>   {
>>   	unsigned long block_start_pfn = zone->zone_start_pfn;
>> +	unsigned long online_pages = 0;
>>   	unsigned long block_end_pfn;
>>   	block_end_pfn = pageblock_end_pfn(block_start_pfn);
>> @@ -2277,12 +2278,11 @@ void set_zone_contiguous(struct zone *zone)
>>   		if (!__pageblock_pfn_to_page(block_start_pfn,
>>   					     block_end_pfn, zone))
>> -			return;
>> +			continue;
>>   		cond_resched();
>> +		online_pages += block_end_pfn - block_start_pfn;
> I think we can completely get rid of this with something like this untested
> patch to calculate zone->online_pages for coldplug:
>
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index e33caa6fb6fc..ff2f75e7b49f 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -845,9 +845,9 @@ overlap_memmap_init(unsigned long zone, unsigned long *pfn)
>    *   zone/node above the hole except for the trailing pages in the last
>    *   section that will be appended to the zone/node below.
>    */
> -static void __init init_unavailable_range(unsigned long spfn,
> -					  unsigned long epfn,
> -					  int zone, int node)
> +static u64 __init init_unavailable_range(unsigned long spfn,
> +					 unsigned long epfn,
> +					 int zone, int node)
>   {
>   	unsigned long pfn;
>   	u64 pgcnt = 0;
> @@ -861,6 +861,8 @@ static void __init init_unavailable_range(unsigned long spfn,
>   	if (pgcnt)
>   		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
>   			node, zone_names[zone], pgcnt);
> +
> +	return pgcnt;
>   }
>   
>   /*
> @@ -959,9 +961,10 @@ static void __init memmap_init_zone_range(struct zone *zone,
>   	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
>   			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
>   			  false);
> +	zone->online_pages += (end_pfn - start_pfn);
>   
>   	if (*hole_pfn < start_pfn)
> -		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
> +		zone->online_pages += init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
>   
>   	*hole_pfn = end_pfn;
>   }



Sorry for late response, I am trying to catch up with the discussion:) 
Per my understanding, zone->contiguous has 2 semantics in combination, 
one is the pages are full filled in the zone span, the other is those 
pages could be access as it has been onlined. The check 
zone_spanned_pages == zone_online_pages guaranteed the both. Either 
resize_zone_span() or shrink_zone_span() will change the 
zone_spanned_pages so they need to use WRITE_ONCE to guarantee the 
ordering; so does to the adjust_present_page_count() where 
zone_online_pages get updated.

Regards,

Tianyou


