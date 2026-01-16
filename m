Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BDB2D4898C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B202B6B008C; Fri, 16 Jan 2026 06:58:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADDC96B0093; Fri, 16 Jan 2026 06:58:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E276B0095; Fri, 16 Jan 2026 06:58:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 823A76B008C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:58:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 165578C129
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:58:47 +0000 (UTC)
X-FDA: 84337680294.19.A3869EE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf19.hostedemail.com (Postfix) with ESMTP id C348E1A0004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:58:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=E4Dk6PL3;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf19.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768564722; a=rsa-sha256;
	cv=fail;
	b=ZyDdtRsZ/oxWm+ziQyEcy60cTDJvdz3gHyc4as6ZQsPP8bOQmBALdZZ5cA8m+xNnQLAMbC
	5GrEapYw//imIxQxiXDtuQHUx93GzxNzR+gH6q1TdAhJdxOMp56PgkOCPtu0bl8b/fyAJ2
	WCkClKfnh065/Cm11pLMRgbdA0n23/o=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=E4Dk6PL3;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf19.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768564722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZydOZvNZwtBSk0M2O0xgfUSrScXVPfKPrKpD50KNNQo=;
	b=6JgYoSO1VCSWzbcI2/Usxaq6RKo6iWOfgDoMBmvHpkSybkLoqdt6JTZBGRXvh3a6ewNezR
	u881q5M2sGSLxJkhoJzV0YYL7kRpKiA1vzGaSyuH2yVZgf4/pbGL0yDl50usqsp7+y0a+o
	Y/8TtgHtjK/++Y63cKxMvilVNk613mo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768564721; x=1800100721;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VCOTIYwkvMFArjcyyPCbWS8JrHmijs8kPTsW7wVy0wM=;
  b=E4Dk6PL3SzjeVC201cv4k3vbsAN5Qy674h18qCrFA9jDtnr+UPeaMYxJ
   98cELAkVV7KAnbjC2kpLcP8PlWvPkLjqQnVLLy4TXLyIksXx4UE3pjiSH
   fSYwC8E5/AfXi7NM1slo2BarSyLrPccfzyNPb+PNfOkWSkAPiEUzUVTXb
   S9abzCUpf6eYFucFcj0vZbvaPxgIg7cPhoduZ+mgNbKq05pO4igHII4ij
   9f7GxlLdXxIWZY7T3Jx9Vqpj+OuMJSu/uCSc1VHDViWeO0FYE2ZfYOu50
   RYlC/2kL8xmzlXcpdLT69p4x1/x0GolHNqJoFb8Rr8DDtR0Rgzsy1WMeN
   w==;
X-CSE-ConnectionGUID: zH8uTCJDTkORuBfe6A4bsQ==
X-CSE-MsgGUID: vGNYrlj1ToG3sLFqsZjvUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="73507687"
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="73507687"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:58:40 -0800
X-CSE-ConnectionGUID: B0CDNKdJQuyhZ/5RjsHGPg==
X-CSE-MsgGUID: 5gpgO2ZmSlqwYkSue58kwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="210090900"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:58:40 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 03:58:39 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 03:58:39 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.11) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 03:58:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wXOp5VYiapR93V9//kGOsVePkkZdjOM1aa7Dx/Dy0fPrpqr+uY82WGEJivvoHAhv0S3IXQOhYjUmC/B6aiIYRmDR3r3ahusD/Qa8i1G3eU6i8iF3ZXsSUDhr/EdgFFENgSvaMkmqOAitg3/6uX34IW02oDKUj76wZ5yFJwh2hBCAnrXdWoIUERQTtOX4p0BX4xsCqPzvGqw4j4LJOS+uS4Wqy84iPyMssB9GZcFDlsUX0MB6r33aUEchFE8xoxVf19hwJkB9yxKqsplEqgH6fM/hh0vRVn6tuvNDlayInHuPloqRA1t4HOXTaeVg8heQSWE8hNUmO+/Ip5Vz0OR0xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZydOZvNZwtBSk0M2O0xgfUSrScXVPfKPrKpD50KNNQo=;
 b=DeY7UrhIYSdRFH8NVGLTUK9jLwNlG9objPxa88bUua1x6sjqTh9opZYOE1XFaY7+uJc9iS6vjBc5kEJT6YTTFtNQX6jtRddSmZsSdD9OJ5if+75SOl1cUT91BvqDMVI5qAN6wnsohSQwBt52j2ogvX0zKocQ7uCZBvkQDpXTWgJJy6eUiEGm5VGjpDJozcSkimjimLqXVHn2UcMPDvKh3wcsZiR6i18MzIFSQtQ6SUD1Lk/+0L3gE8OLePobU8k6t2olDVUcR5y0KnKZRVjxpCLIEyC7zYpPALgibPfxcGESHqf5YymrXIIqQB17sh4YS0Wo+viN5X2YSkXIcOGHJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by SN7PR11MB6993.namprd11.prod.outlook.com (2603:10b6:806:2ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 11:58:36 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%3]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 11:58:35 +0000
Message-ID: <da65f26d-d2e0-42ae-a682-9652182d37b3@intel.com>
Date: Fri, 16 Jan 2026 19:58:27 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251222145807.11351-1-tianyou.li@intel.com>
 <20251222145807.11351-3-tianyou.li@intel.com>
 <2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org>
 <e9d52093-d11e-4e0d-9bb9-88e0ffb78a19@intel.com>
 <a7da047e-0064-4f21-9f8b-fa4bcf40dca3@kernel.org>
 <d97a8744-6d49-4582-82fc-a38ee2ae06fc@intel.com>
 <4d47cd01-034d-4886-80c4-3861d2181e18@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <4d47cd01-034d-4886-80c4-3861d2181e18@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0196.apcprd04.prod.outlook.com
 (2603:1096:4:14::34) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|SN7PR11MB6993:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cbc3719-0ac1-40ff-fc8f-08de54f693bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OUR2b1ZSaW42WUFEVjFhd2JiRHl4bnpiZG5JbWhrU2pORG96cVNqQ0FKQnJ2?=
 =?utf-8?B?OVM1VklyM0JPNll2eDhrWXlxUE95STVuSVZ0TSs4VEd0a2lwU0tLZXU0bWhU?=
 =?utf-8?B?UW93ZFdLZ3BUeUZuWTZsZjRHZUlKVUFNYzV4ZWU5N2RMVmVsbWtsaGZSTTkr?=
 =?utf-8?B?V2ZHdnBvcUtqRExHS241dzkvSmpQLzZMVEU3b3ZvQ2wySnIzZmxKRmdadnZi?=
 =?utf-8?B?N0dDRTlod1FHS3BxVFZUNTlQd1JyNlkwZnF0V3hXRlJ2Z2d6ZzJ3WlA0OXU0?=
 =?utf-8?B?UVBsWWwrTDkrOHN0NHo2V3M2RnBYemJudE5NZVFQZzFEMW93TEZYU0JQWGk2?=
 =?utf-8?B?WWsvdVh2ZDYwUndyZjNLOWhLTlJsWmhFbk1PSkl2RWpJTk5mRVYyN04wOUlu?=
 =?utf-8?B?MWdwVjFpNHc4dVBySVVTanNiSEwzbzV5aUxJK2ZkbExHZWZ2T3FyWjB1UndW?=
 =?utf-8?B?MGk2L0xFanN0M2l0QVBLb3dBTWtpMUVYNVV0cXNhUElLbU9zR2dUQnJvY3lk?=
 =?utf-8?B?RlA0d01pRUVmeVpXYlVhMERSMUZMKzVOdVhJSlFKTTEzY0xnNENpelJhaTZI?=
 =?utf-8?B?TklaWlRwalczR1lQcUlGN1FKWUpsYUxTeFBLM3RyUHFpbnZyVldvQ043dTN1?=
 =?utf-8?B?UWNLdXlxeTNFY09EU0ZacHc2VGtKQTdEM09GOW5SbjFTRlFuUGJDdHpoZ2dU?=
 =?utf-8?B?Q05UaDM3YlJaVHlXM3JnNVQ0WXh0a3RRT2phSW5rSzBZYlphYll6YWxmSVRo?=
 =?utf-8?B?YzVQMlBGVktsNjU3NGU3bWpGK1krQ09rRFZrMnZ1MG9ZMlh0dXhSU1VGY1Qv?=
 =?utf-8?B?cHZUcTFNaHg2R1V5UjdDWjhoVTFyNEg5MTZrRjdwRXFDaEF0WWw0bngvemEy?=
 =?utf-8?B?OVNVKy81WkxZVUF0Rks1ZzRua0J0Q2lGWE15dlFXNjVFSEh1allJUzc1U3FV?=
 =?utf-8?B?aWpjWkJ2dXNPNjAwVlVhUXB3Z2FBTlZ3dkFEKzE4UStXb2pBQTBiWGdJRVVO?=
 =?utf-8?B?QzYvSHljUVB2ek1IZFMyak5VMmFDd3NCRmxrSDFFKzRqaDRNNGtEWmlBV0dv?=
 =?utf-8?B?YU5taFBqNDZ0SGdCME03MGtzdWFUcmNpWWdaSklLRURSOHFZd0dXRXJnelZq?=
 =?utf-8?B?UjhTeEQrMWVHd3lTa0hCcnRUTkVkT1pTNEdRMk94OXpyTyt0OGpwQUVpYmJQ?=
 =?utf-8?B?Y0ZPL3JtMTlqK3hVSjZ2R1RvSE1TUE1QdUx5R3VuMWpKcTlDUUxkdm04bHJu?=
 =?utf-8?B?MlFBZ211a3QwTnpFcjlJSVlUWnRBR1hCVnRvTVREdGY5aExLWlRER0dqNEVj?=
 =?utf-8?B?bWpESThEbVhlNWU3RkpTVlBQZ2JzMm5IQnh6UVlhdHdYU3p1RmZsNldkVDlX?=
 =?utf-8?B?Skc4NE5JQ200cGh2UHZjZkdrejBvT3gyREZZSGFubE1qZ0xaalNiQnVLdUVJ?=
 =?utf-8?B?NkphK1UvdnpwRlpBdno3TnR4cVVvVHdweG5MVU5rOEFBSkdGSWhacTBSdi9M?=
 =?utf-8?B?eFB6OU1CMXJyTXd4d0creitpU1k1Tk9WMy9UdmVPa21hSzRKUDVhRDRiREdw?=
 =?utf-8?B?WkdLS0d5aHhYTzE4Q1l4Z0paSXpsR0RGU0hsY1JmdFhzWW5rWldGVDdYU2hQ?=
 =?utf-8?B?ZUdlUkFURDNQZElSVnRGcUNmS3UzYnd0d3lCRG9wQXRUMEpMVjVmaWRpMlRC?=
 =?utf-8?B?d0V6U1hhMkJOY012UGpPVDllQ3BwcHk5YzF0Q2lUZ1JKYXFaM0tqOXlKZjBq?=
 =?utf-8?B?TmVyTFpjckhzd0psL29NRElkYkVCRGtJOFNwcEJNZTRWM2lBU0VLYWM5cUR1?=
 =?utf-8?B?TytQQWpydXc1dWdYUCtDa3pGa1lJZEVmdTdQR3FQaVhHZ3dBbkpHd24zQXdB?=
 =?utf-8?B?bk1hS21PNzlRQnZ3eGlRNHZPbUFsczRQc0xSZDBjOHpnSFZ3cGJ5ejlwU3pH?=
 =?utf-8?B?MEhBNmo3RlhwVnhCOEZHTTVlQzMrN2ZUZ3FBc01NSWxtbkJ0OHh0emk4Q1Fj?=
 =?utf-8?B?U24wVXhaalJsSEZpQ2FOdEFtT2EzRUZPY2dPZGhSOE1GWmNRZ3pDNFV3MHhN?=
 =?utf-8?B?eW1wU3NpZVBwNHFtK2hPTmZKVldlb1AzbFBXbWtJNU9LeXN1RURkMHN3Vkc4?=
 =?utf-8?Q?lWb0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlYyQlQ0VW5oa0VwKzNvd0Jkd2xIUzQvWTBQWnA0bFZiUTBLVTVIYzVoa21U?=
 =?utf-8?B?ZU13ZmJaeGRIL1IrQTBJSFp6WGRwTVplRDFNazNPb2RrY3JoeFp6emlBUjli?=
 =?utf-8?B?NFloMzBZMDU5emhsQXZ2c2tBbmovenBtQjc3dDhQcEt6eWVRcmVXeEh5aGpL?=
 =?utf-8?B?dzJOOTJaNEtvQnhEc2VGaGZuQytJcC9TZC8wWWE5SkU0NGhXZkl0THFsN25w?=
 =?utf-8?B?bGNMbDFaNTI1cS9uKzhUbHU0TEFhbnRVOHk2cENpNk1USW5yZTJtK2VQUm5U?=
 =?utf-8?B?L1JpVUc2YkFDSGVDN2tESm1sWGVPNXFobHpSSDVvRktkSzVWWVQ4U1pmSXh1?=
 =?utf-8?B?QzBPY3kzMVhlWU5SbldLTTJPS1czSlB6Y0tadFNxSStUNlBlbzNrYXo0MGsr?=
 =?utf-8?B?YlBlQWM0YWoxQkdTMUl4VmdydksxQmVOZ0dBYTRFd0JkRG5CSmhjU1FVc1Bv?=
 =?utf-8?B?VHlWcW54L1p1RU5sWThHZnZZL1ZWbW00UTMzK1hDWUdzdE9ZeUs2MTVXK0sy?=
 =?utf-8?B?ZUluTTFzQWZVeitPZ0ZjOENYbHdmSk5zU3ZpOGdoMHRzWUNBMStuWllvVkZ3?=
 =?utf-8?B?TVBhdWp0T2szb3IxSXZkVmp1dm05Qi9NWEZ3dEowaE95ays4OEhOc2FxZ3Bq?=
 =?utf-8?B?Z3ZoazBMQUxjL0ozaVRuZVdOeVpYTXZvUVhQNEl1d1VGUVdqNXorRU1oMExj?=
 =?utf-8?B?V3pMY3VocnA1OTdQTVdSSC85WC9XRmhZSnpzWEtyQU1naENTRzFxOG11eGZl?=
 =?utf-8?B?WXZTcmtJTndOODA0V2tIZEg3VjIyVnV0M3JZbXlkZFdydVJzRlRmV3FrcVJ1?=
 =?utf-8?B?RDFRSzRpOTgweXBQL1A1YWxJN0pMWWNsakt5dzVLSm1seEdaRGtPQ1lvQzRQ?=
 =?utf-8?B?Q3h4aGF5eGxMTnBCQXhoY1NrcFY5bitJT25SOWIva29rb3ZoTzliOVBEQTlw?=
 =?utf-8?B?elZ0SmlZbFA3eERkSjhGK1hCYzNEb1FOTDl3cU90eWN6Wkw4LzkvRlozS283?=
 =?utf-8?B?MitiY3grY3Y3T1UwY09GeWlDM3hRRERsWjh5REVGWDE1NzJmdXllTmNsS2Nr?=
 =?utf-8?B?dnprOGErWkMxTVltR1V0RGRXUWFWVkdWaER3dGRsaENrZEZRNmpGWGt2Mlpr?=
 =?utf-8?B?V2ZTbEluNERZeUFGQXd5S2d3amVQd05nVWkwUHFRbGpRQ2JYeVZyc1BLTlpR?=
 =?utf-8?B?K1ZKWmNrd3pHdGdNaGY5akZrSFZlbUkydGpuUmhwOWErbGtHTXNqb1VxNFRx?=
 =?utf-8?B?VzhZRWRYcFpiOGxNS0V4VWUyN3NLYmtvMDBZeDVwTCtyaklyc1JmU2JicW44?=
 =?utf-8?B?ZUwxSVFHdkZzUG9sYno2cGF3K1FmclgzMXRubHhsbFBuamFmbTUxbmVHOFV1?=
 =?utf-8?B?QlNvWGpzTkdWMVA2TktWYjhpYXcrcndueUVqdEs3MldvQVQ2aVZFSVYxeTFX?=
 =?utf-8?B?Tk1PcUprVlBDaTk1aUVNS1dxblk3enZXYXJzbFF6QXd1VU4wbmNYZTU5NmVu?=
 =?utf-8?B?VWFwdkx0b3M0VlJlK2VDeWlZWUdNREV1MFZKMTFGRENxUTRxSGdsRzhiWExm?=
 =?utf-8?B?TzgvaEN3ZDFOWnJMQURvUlVPTy9wNkoyS213RFhmei9qQU9CNm02N2dZbTFQ?=
 =?utf-8?B?MWFZZGRkSEM1ZXhEVUZjdjFYUityM1k2c3JkN05KTGU4ZmpjTXdWN3Q2bWhM?=
 =?utf-8?B?Z3NVZDBCNTFBdGlrZkpNMTdNM2dJc2E2Qk5ENFZraG9GdTk4SE5RdUJKK3Ry?=
 =?utf-8?B?V0NrQzBCdGNuRFVXLzZnQkNtNzdoVEtMTk82MFltL1lpMXh1SC9yVXFOOENq?=
 =?utf-8?B?NlFQNFVGZGtwYXNkR2N5ejBJbC9jdjlYOHBVL0xUbm9FKzdDR2UvaWxrbm81?=
 =?utf-8?B?bzVtQ1M1WHdCc2txVzE2dFVMYm1TWi84cEViR1FET3JyR0lGZVdUWFgzdXNl?=
 =?utf-8?B?dlVISDM0U1AwNDREQmdEYWJ4eGVwUFA3R3c0WXlLNEJKbGE0QWJWRnJOWDQ3?=
 =?utf-8?B?NTlxNzlhRDdLZ0xyU2NCQUFHUytUVGVOU0dXVVgyc1k4QzZWbGdoZG9hMVVn?=
 =?utf-8?B?cXo3SnlWMTRLYzd3aEhEYUR3aUkzYks3MTNZVlBTSVlTYTVCMkJnYzFwdnhn?=
 =?utf-8?B?eGRYWHVyczN1dERFMGFVd0ttSnBhZUk4N2ZCUTh2NlcwemhOZTcvSUJCKzMy?=
 =?utf-8?B?VjM3NndIRFltRUhSN3YzalphSVRIeDB2NHdXakUwRzhGaDJ4RjNBZmZjUnYr?=
 =?utf-8?B?c0ZCU2FCTG1wb0FaRmRGSEhGN1NRNVlrNWZuR094NVlrZHdhWDhzTkozR1Ji?=
 =?utf-8?B?Q1VoOE9IekhDV2RmYUV4STdzSTBOTS9wcm1GRzZTRW81d2k4aEp2Zz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cbc3719-0ac1-40ff-fc8f-08de54f693bc
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 11:58:35.2028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NeSrjK9fByhrmORMfvh3camytQSF9yUjPCp4zq0ThB1AuDJHHHxaFodGOC5e8cB63IJvVgRHlAUnHiltg/5y9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6993
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C348E1A0004
X-Stat-Signature: 7hrjw8brignwuqfx9tg34m7o7x7fksz5
X-Rspam-User: 
X-HE-Tag: 1768564721-675565
X-HE-Meta: U2FsdGVkX1/cBeHiQAxl5x83xd2T2UwRlDAniXnbUqER6JBXTOmYz6CnAek5Ngz2AeGvf2gqjQlYmfrbNIZsItF5qeoFrY/ScNdQV37stTTSrs8OT4D57X/opvQ2JM4W+r4qkwwJr80kvUdDvZAJVr5hmTHUSXVQZm1sZMsOXelSLVgLmvioLMSx6bITqk/OC13kEIHVkhEeyOziGkcXh2eccJKzPC5/gzXkDjxpnZ2dtw67EMJFucdTo+LhB0dAtME7OmA3at6JPsYlXLFxJeEm0zlnRK2paj5MMiNvMB8EIQfSWJEA+Q9S3RJCCJw0QzpMjI4TfBieYb3sZIu1d0bW/PTX57C8X4YjwixRJeNPo/plT8puje5hqt6CTJuk2lB2CFg7QDLEJXPU7wcW0+GPxrzERxE8iXknrGxaK1orQNe9Fg+FXf/CdVmIWruk224jAj7UJZLhdE9P/kFEyfCCl0o6ysIhE5u44Tro8slUqHKK9Y6NBkFJFAsUwS3JH53yF0hC5z0eTf63PHaOcfuECdgoA8mkkyvJAhX7tGRe3zuxRs66OVKyULFeLwNc77VzYMbDhpkqyl7/7sPBRcBBqtK2N/qCGoMa7F4uKXf2NUzDEVp5IwnNS6XIQdrszR7ApcCl3KVpRyALzTSf4XIwNiB5MoCGEsG+MIa5uhoUG/DcCnZbWtEGDrsge7HkviKT9ExWTuRxC8qTrmXgY9ZTEGjuniS3WI0wAJNOxlGJrFfki4LzN2INpGMlSZX6shPItS04zkUZkOxGWvYweGxlmNB7AvWjEYPgscF7xT7HMqYcPm9CmK/Kbo0vJ69x/ravyYNQfsSajmmbhzqN0hT0UE0PDmcK/CqV7PEDZ4+CI4nf/PJi+F2j0dkhXst2Hj0RC5vsw6l6XwSWSdCS5hlkw8woDMOL94C5q+SisQ7wFmnzIthtkFWNapQpTIoZnTk0+2Qh1ep4WeTtsyX
 XNKIv9Zf
 b9KmMYjjmuA3RvzTXFehpNFsAvldocU8wuJbpJJGXLsI1u1R7W1MnBpx2lh1QJnm37ARyo/h0viVE6ALo2U+g/0oW75ALmuBDZea6oy5B/pDcpb4HKf35Fl4yHLJ3JT4zSZQ4t17Bnvg1WzheHQyxpU9WytmdkXPZfgJR1ZZcxSCemvFRfglMnXrQcCMDz4h9leNmeJ7pNIGv70/PFUEeO21oRtWJu1QqM7sylcGdufNfK19oVd88Z2EtkFLzCBLdu0CxYfkYh1Kgce2kmFbbfzexMzyFhwySQc0Vu3V6SbEQwcH1/FxIKXgDrUP8ti+OeOy9T+9VF+CcF7lKEzIXModnKWyMSACicWk9Viyro1Hkdr+nd7vdRfXGoyxbd8j9mbJicAikkRWsYe001nxaz19h+uVEmgwlzsPEfFh4k0cVuPLhWRueuOyam3dCOeWy8qPD7o72knVvTUQ2ipSLCDA/OyQCElZQGowUR+qz3cxVZKS3gBSwAUHluLuYSAIKCm4xATfm+XDA/mygRo6E1UNWTvaLV7MMDA3ayjYeiUdLVCf/KrfyBN54Rr5HXIYxHTzo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/16/2026 1:00 AM, David Hildenbrand (Red Hat) wrote:
> On 1/15/26 16:09, Li, Tianyou wrote:
>> Sorry for my delayed response. Appreciated for all your suggestions
>> David. My thoughts inlined for your kind consideration.
>>
>> On 1/14/2026 7:13 PM, David Hildenbrand (Red Hat) wrote:
>>>>>
>>>>> This is nasty. I would wish we could just leave that code path alone.
>>>>>
>>>>> In particular: I am 99% sure that we never ever run into this case in
>>>>> practice.
>>>>>
>>>>> E.g., on x86, we can have up to 2 GiB memory blocks. But the 
>>>>> memmap of
>>>>> that is 64/4096*2GiB == 32 MB ... and a memory section is 128 MiB.
>>>>>
>>>>>
>>>>> As commented on patch #1, we should drop the set_zone_contiguous() in
>>>>> this function either way and let online_pages() deal with it.
>>>>>
>>>>> We just have to make sure that we don't create some 
>>>>> inconsistencies by
>>>>> doing that.
>>>>>
>>>>> Can you double-check?
>>>
>>> I thought about this some more, and it's all a bit nasty. We have to
>>> get this right.
>>>
>>> Losing the optimization for memmap_on_memory users indicates that we
>>> are doing the wrong thing.
>>>
>>> You could introduce the set_zone_contiguous() in this patch here. But
>>> then, I think instead of
>>>
>>> +    /*
>>> +     * If the allocated memmap pages are not in a full section, 
>>> keep the
>>> +     * contiguous state as ZONE_CONTIG_NO.
>>> +     */
>>> +    if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
>>> +        new_contiguous_state = zone_contig_state_after_growing(zone,
>>> +                                pfn, nr_pages);
>>> +
>>>
>>> We'd actually unconditionally have to do that, no?
>>>
>> That's a great idea! Probably we need to move
>> the adjust_present_page_count right after mhp_init_memmap_on_memory to
>> keep the present_pages in sync.
>>
>> When the zone is contiguous previously, there probably 2 situations:
>>
>> 1. If new added range is at the start of the zone, then
>> after mhp_init_memmap_on_memory, the zone contiguous will be false at
>> fast path. It should be expected as long as the
>> adjust_present_page_count was called before the online_pages,
>> so zone_contig_state_after_growing in online_pages will return
>> ZONE_CONTIG_MAYBE, which is expected. Then the set_zone_contiguous in
>> online_pages will get correct result.
>>
>> 2. If new added range is at the end of the zone, then
>> the zone_contig_state_after_growing will return ZONE_CONTIG_YES or
>> ZONE_CONTIG_NO, regardless of the memory section online or not. When the
>> contiguous check comes into the online_pages, it will follow the fast
>> path and get the correct contiguous state.
>>
>> When the zone is not contiguous previously, in any case the new zone
>> contiguous state will be false in mhp_init_memmap_on_memory, because
>> either the nr_vmemmap_pages can not fill the hole or the memory section
>> is not online. If we update the present_pages correctly, then in
>> online_pages, the zone_contig_state_after_growing could have the chance
>> to return ZONE_CONTIG_MAYBE, and since all memory sections are onlined,
>> the set_zone_contiguous will get the correct result.
>>
>>
>> I am not sure if you'd like to consider another option: could we
>> encapsulate the mhp_init_memmap_on_memory and online_pages into one
>> function eg. online_memory_block_pages, and offline_memory_block_pages
>> correspondingly as well, in the memory_hotplug.c. So we can check the
>> zone contiguous state as the whole for the new added range.
>>
>> int online_memory_block_pages(unsigned long start_pfn, unsigned long
>> nr_pages,
>>               unsigned long nr_vmemmap_pages, struct zone *zone,
>>               struct memory_group *group)
>> {
>>       bool contiguous = zone->contiguous;
>>       enum zone_contig_state new_contiguous_state;
>>       int ret;
>>
>>       /*
>>        * Calculate the new zone contig state before 
>> move_pfn_range_to_zone()
>>        * sets the zone temporarily to non-contiguous.
>>        */
>>       new_contiguous_state = zone_contig_state_after_growing(zone, 
>> start_pfn,
>>                                   nr_pages);
>
> Should we clear the flag here?
>

Yuan and I have quite a few debate here, the contiguous flag should be 
clear once the zone changed, so it make sense that 
move_pfn_range_to_zone and remove_pfn_range_from_zone coupled with 
clear_zone_contiguous. While the set_zone_contiguous has the 
dependencies with page online, so it should be carefully invoked after 
page online or before page offline.


>>
>>       if (nr_vmemmap_pages) {
>>           ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages,
>>                           zone);
>>           if (ret)
>>               goto restore_zone_contig;
>>       }
>>
>>       ret = online_pages(start_pfn + nr_vmemmap_pages,
>>                  nr_pages - nr_vmemmap_pages, zone, group);
>>       if (ret) {
>>           if (nr_vmemmap_pages)
>>               mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
>>           goto restore_zone_contig;
>>       }
>>
>>       /*
>>        * Account once onlining succeeded. If the zone was 
>> unpopulated, it is
>>        * now already properly populated.
>>        */
>>       if (nr_vmemmap_pages)
>>           adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
>>                         nr_vmemmap_pages);
>>
>>       /*
>>        * Now that the ranges are indicated as online, check whether 
>> the whole
>>        * zone is contiguous.
>>        */
>>       set_zone_contiguous(zone, new_contiguous_state);
>>       return 0;
>>
>> restore_zone_contig:
>>       zone->contiguous = contiguous;
>>       return ret;
>> }
>
> That is even better, although it sucks to have to handle it on that 
> level, and that it's so far away from actual zone resizing code.
>

Agreed. Thanks for the confirmation.


> Should we do the same on the offlining path?
>

Yes, definitely. I will work on this change for patch v8. I will post 
the patch v8 once tested and confirmed by Yuan.


Regards,

Tianyou


