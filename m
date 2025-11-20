Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54832CF8860
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 14:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37D36B0089; Thu, 20 Nov 2025 09:21:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0F416B008A; Thu, 20 Nov 2025 09:21:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7296B008C; Thu, 20 Nov 2025 09:21:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 89B5B6B0089
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:21:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E1131A014F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:21:51 +0000 (UTC)
X-FDA: 84131199222.16.F7C4C2F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf28.hostedemail.com (Postfix) with ESMTP id 09FEEC0003
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:21:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Au1qHNrr;
	spf=pass (imf28.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763648507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJQMuqBqBgPABvtnKPDlCWYeDynbpKxVw7oc794dkHs=;
	b=0nlSrM5a8nLeI9uvsw3mEWOxf+FNXgty+HzQ1v3AOoJNMTn947s6HysU/VgTa6616ZSto+
	Wp6zE5ore1RmqNVCy6l+Z1XFKXyTAkJkXzHyLS5GeMCinOH8dJs3ZlKSKL6tNhBSQSV6gf
	z5f/Ky3vEkA8tpye8VvImU7YyH2+hpA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763648507; a=rsa-sha256;
	cv=fail;
	b=FFixxXVGGsMM8TFnRRsCVZRvrv7eefSliMlVHH3YTJxRzA+biBaxGKwoAKl79c8uKG9V4n
	5QNNhL5QUPEPLvl1hGXeBSLNeAa2UlRW0pXfgCoby5TrgGBa+bTFuteqDJKDpjhllI4MjF
	Cp9SDxil3ijh1liXDuOdhsmRD3o3AFU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Au1qHNrr;
	spf=pass (imf28.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763648507; x=1795184507;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sg+gygruXHHImvYjGg7TQuYZUAZAW2V0/qTKG6tKGNw=;
  b=Au1qHNrrV/GCL7Zzioo5ZH7VlWsRCQfu3iLWQTXva+WAK8GA2PKlJzLd
   Zb3dldc6Nl7Y1J3K/kYILWU7JXLF8F6F009TF632jX3Qd9ftKzS6eweYR
   sm0ggjVdfKzBRZeAoWHFiqzpGIrSknHUHww1bi/sCT0dL0ryVfzSan/Yy
   hg558J2y6G2VyaUeKcusYk5AzqnLvAGXXD4LTo0xIqIins0UVm8Z3Y8zl
   Ccqf4smsD48qFW2MhOITYG8oCkqlcnTF0N1Wv7dIfnb0vHpiJgOc+vNPR
   GTbqVB9dAUHvwE3kH8FW+eZai2lvO7/uwxaIS4AIgHGpZ+24XF6IR7XwP
   w==;
X-CSE-ConnectionGUID: uXF6yO6eQmSuSFoNYBXVOg==
X-CSE-MsgGUID: qz5EUePYSg6/WjaERqA0Sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="65878652"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="65878652"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 06:21:46 -0800
X-CSE-ConnectionGUID: rkQOIjzBQ9ihT6AwMxMQaw==
X-CSE-MsgGUID: TNA1Wfg4Q76oulI0G+j8yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="191632286"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 06:21:45 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 06:21:45 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 06:21:45 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.15) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 06:21:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f8siKF9r1mZh/KDyW4iL0sC7a9mwFQ3RDAhrxfGyhZtoMOc9byh+VuzKrgqff7tQJIwDlacyHIcNBi55v15FcXa7/jlzgHNDDB6j00QgcAPoTJCR7pkYooKT1OrQN6dCVliZhS69LncEuIIA7Mw2dyRzQ+xAUpj8uH7lNU1nP9umUFNEr7LJ+JQG5EIh4eN7bMpposi3z5aZ35GlCjxDwa04w0K8kR3MNtVe58SbBVANXKLrAvnaZDpPSYjzHX4GbpU6/dsXg6ozpBSUd/L0uo1zi6C6SUs24PlekWUwOiv34EkkNewc89+Rl4O/8lKWcwhEvyF1d5vUMNW8f2jfjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJQMuqBqBgPABvtnKPDlCWYeDynbpKxVw7oc794dkHs=;
 b=Slrn9krzAsXU2kjcaeRFDvQvB96huHyV9SAxmlJmGdIDQZWQOGmBDuxCjqDoaROOob4WH4C7DhtYoH/w79B33TfyEF3b82YMsDSmjd/6giVjgWZNgVOW4oSUfc6iVA9gDXs/sEa9gy+lNrFywz9D9OZgfJMJ6i0S6cqDXzaK7AYqCAJI9SmRvpPs48pM0x+SNhsKRW+ge01AIXMgD9XeV79CNaGkTHPoJcFESXsZSwKCABPf1juMpOeOycu5apMjd9DR4JmKOGbSJG71T/RUnr25fxsv3CULvVxRueb1ofIJJmJHRLIoQdL57UDUUYQP/fLJzLZz789TPSiVKAchmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by PH3PPF496D5EAB2.namprd11.prod.outlook.com (2603:10b6:518:1::d1c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 14:21:40 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 14:21:40 +0000
Message-ID: <e0ea1aa6-bbcf-4148-bc43-ee7c4de087d4@intel.com>
Date: Thu, 20 Nov 2025 22:21:30 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, <linux-mm@kvack.org>, Yong Hu
	<yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu
	<yuan1.liu@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo
	<qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>, Pan Deng
	<pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	<linux-kernel@vger.kernel.org>
References: <20251119114252.oykrczprf3ecd7ak@master>
 <20251119140657.3845818-1-tianyou.li@intel.com> <aR8Cx_K2N8DPlwkP@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <aR8Cx_K2N8DPlwkP@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::20) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|PH3PPF496D5EAB2:EE_
X-MS-Office365-Filtering-Correlation-Id: 7baf2c67-4dd5-4017-c05b-08de28401efa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RncvWnJhSUZreHVpZ0g3WGRXZk0raVkvS0FzSExGZHZYNHlxN0FMRUV2QWo5?=
 =?utf-8?B?SkltU1hqWFFDKzNXQ25LNC9QdFRMUHRCME9JakV0ek0rcUx6RWJ4ODJiNFdF?=
 =?utf-8?B?WXhqZUxCOTc0R3VqeUdPR0p0aUNiMmgvV3IzbEZoSStuOGNLMUFDSmJScmdn?=
 =?utf-8?B?YkRFSDVPRHVLSHNsTkRoL3BzWVVOcHhsK3ByQ08vdlBOc3Y1SUo3WjhpdTFC?=
 =?utf-8?B?cjJaSEpQa0dxWkZqem52b3kwSlBQaEoxNFVxWlV4MTd6cVJJRlU4SXJ0UkFI?=
 =?utf-8?B?cFROcnlyMjdZY3NqYmNTMjFxenFuaGg2ZmFnRUhwajJkWFgrVWtaMU9DUDFP?=
 =?utf-8?B?YmlTbk5vMU9rOUZRbTFjRnNwUFhNQ3A4SWhLWnpqeFNKMG9nSUdiZWg4NklN?=
 =?utf-8?B?SGc1QzFDbWtsYlB3R1pGQVBOQWZacElWeVp4b1VvUi93ZHdoTlZVZUdVcU44?=
 =?utf-8?B?NlZycEI5SXBJL2FWakE0Nkp6UVBjajVpSkNiL2djMTZkMGY5TVp3ZG5FWlpZ?=
 =?utf-8?B?TXZPQXN5KzVwYVNHeWdoakZpTDE1aDJnQzlaK2tpdVcyZCtnOW9rck9iM054?=
 =?utf-8?B?T3dlQjRPZ0NNNUQ3NW53NnM2dGlTUStMVTNYZzZiV3BHK0NIb0Q5UE04ZWpt?=
 =?utf-8?B?TmRWd05RM2ZEVGR3MTh6OU11ODNtTHlmTllJakxJM0plN2RDNkIwbnBTblor?=
 =?utf-8?B?Wkl5bktuODljR2hGMUE5NUZTb2g0bWtLVFJ1bC9IMWw3WER1NDFjWU1iYTFl?=
 =?utf-8?B?eEk4bHF6REtQQzZlcmhXLzg4T2ZUVUVBSmV2bS82SnIya0J4d1k5d3E1L3dG?=
 =?utf-8?B?c2RLWjRxWlZ5MnNib3QrSWR4cWVmQkdCM3kxdHZRT0ZMYy9Ud05LbThaSTFK?=
 =?utf-8?B?TVB4ZTczYm9KNVYzS3laNzhaUnNhY2JrdVowL0Z2b01DSU4vQU5PZ3VpRUF0?=
 =?utf-8?B?cDZVN2RkTTRmUDYrN1hybGxtbWFBUWxtb3pVNDFxZk41ZGV5RFp3bnZRYktx?=
 =?utf-8?B?Q2dtTGFackxvOUl3S29kSmYzQ0Z3OWZ2L01DTmZyOW9NSDVIZnVabkgxcEh3?=
 =?utf-8?B?UFRMUDd6c3NUc0UvM1VFYlV3RUczVWo2UzFlU0g5S0lNR0cvWXdOcDlXTW1E?=
 =?utf-8?B?VzR5S0RTOW5zUjRRbXN5V1Z3VThSOXJ6QlNianQ0TG44ZCs2T29rVm1renlv?=
 =?utf-8?B?czVTT3RWL3BLb1JYSzZaK2lJM0cwTTBnM2FUd0JEQ3h6WkVqMi9TN1FwU2FK?=
 =?utf-8?B?OGhWOC9ob3h3Wk9lbUhSaEt0Y1YyR0J3ODI5QzBBMHlmT1BlVllwRDluQmJJ?=
 =?utf-8?B?UEtBdGgvRXlmclRxbHFtTlZObTY5VUtxTEMyY250OEYwSzNqTEVpaEdsMG9h?=
 =?utf-8?B?KzR6RVdDL2VvVkd1MmNFcjdVR0JURyt2emg0eGtja1I3UThjbWtISnEvc0xj?=
 =?utf-8?B?aXF1dTl2dWFuQVZocmRwYlBlV0RYNkZTR051NG1hcVZUd0Z4N2hEU2hMWVJl?=
 =?utf-8?B?WEIzejhmdkVzeHJST3JFTndjNDF3empRWmFCM0ovM2F1ZHk0VzU4NWozVWpZ?=
 =?utf-8?B?V2EzZ2NWQVIvcUVtSk9LS0ppVzdLUVRCekcyVmY5ZU9VdmkrQXpqZmU2NnB5?=
 =?utf-8?B?UWdwU0pSeDh6YlZHM2FEKzNJVmE0MS9nV2RpcmpQVGh1ejdoU2MyZmZIMG9G?=
 =?utf-8?B?ZDFRWGpXUXZiRlpRWEo3MmlCZHdZdHR5V2s1cGFHK2NWV2ozY0E3SGQ0bDNm?=
 =?utf-8?B?OW1NRVNRR2JWV0tRb3JUcHlRKzRjT2RZaGRqU1l6VlZnZHdWREk1MGdQZnZq?=
 =?utf-8?B?WU1DRlN6NTNmSFRYcnhsMXVlSmtZZllGWkVtSktLQ1dhazZRTlhUbkgzL2Za?=
 =?utf-8?B?czIyYkxmMmcxUGFHVFJzNTFPdkNpNERXdGx5dk5GNXltRVljNjNQbm1lbVp5?=
 =?utf-8?Q?6B++MLInFnydOmb+98119fjflrHK5bCh?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjNSYmxsRnVrWFdTK2l5OTVlc3pRWllZM3ZiYXhLdVBPY3pZZHhEckN3eWdE?=
 =?utf-8?B?NmJiUlRjeXpCTW05R20zNW9WR0pRN1p6UjNTZkZzeWtUdVZVSjVKSGEyckpL?=
 =?utf-8?B?Ni9zUWQ1UlViNTB3RTROb2o5Rnpkcy9UUGhhYnJ5L21yZlV1L3hQUWsyK1VC?=
 =?utf-8?B?akxzc0VBemF0NEZYTUhFd3pLS0V1VmlUVTlIWXFsa0Q3Qmpsc1J3WHV4TjVV?=
 =?utf-8?B?OUEwVHNKK2xpTHlncTdzWFlOMWdVSkZKZ1dFeDZ3THozbEhWd0VINUp6bnlt?=
 =?utf-8?B?WHBDVm5hcDdpeUJqd2hyUlZqdlRsMUQxVGFWcXlibStCaFJuY3FDMWFRTWw3?=
 =?utf-8?B?YUFBalg4OFVEVmI1azlnaTJWNHpBQjF1bTBPaWE1VUtWT2pwVTZJUmZIRXc3?=
 =?utf-8?B?Yyt6UGR6MVBjMW5aR1BTeFlmbE1yTFNybVRCWGhWd3VsRWVqTnJTeDBORytv?=
 =?utf-8?B?aGE3SUNWWSttcWlIUXRxZnNDT1ltQlQ5dlJpYm96NWlDY3oyVWRmYTllWlA2?=
 =?utf-8?B?ejdnKzlHOEY0WFpOdkZxMHVOYzhzVEpBTlZJSlFHczVTb2x2Vk1jQTdTNmdh?=
 =?utf-8?B?UGRNdVEvOUNnTmFLZVJKOWVySHRRZ2EvNllQTUFtdHkxaXI3cVJOaFdoUFky?=
 =?utf-8?B?WmdHaWQ1dytPeThZeWdYeWI5aEtnYnBLd3duSkJHTzlDVGRKNmNvTlZRU0Yr?=
 =?utf-8?B?YlVQcEhwbU5DaHQrbWtvRzZ3UFVQVkVLZnI2WmI5bWcydi8xRktEaFl3dFZK?=
 =?utf-8?B?ZTRvNm9ZaWxaNEZMNHBVVlZvaXNBUHV2dDAxcDFUVmVZTkdxUVZ2cmpzM3FX?=
 =?utf-8?B?eTVWT3NPdDRhTXdSM3R5N2pSNEFzY01jdDdZejZLQkVZeUJYd3lSY3pyYVR1?=
 =?utf-8?B?R0pRc1JkOHEwSWVaSktLYmZKNTAxWjRydnVrUHkzYlVCUW5SQXFvem1OMWNm?=
 =?utf-8?B?RGFoRXVVVWp3eDQ0NVFUQTFWalJ0dXV2REx0OFRNejFseElhU3ZlU3NGdlJo?=
 =?utf-8?B?MUl4U256MHg4cHVmOFJ6SVQwVXE2Y1BYMnZXTjZYSHdwbm1Mb1V4TmdkaDRy?=
 =?utf-8?B?ZmwrbUhyUkh0QzFPdU00bmdBMW14ckdldStlOWlaTEJRaG9iVm00YXpSaW9X?=
 =?utf-8?B?aUhGL3hiVG1CR09qM2UxMzZGQU1ya2Z2MnZDbnpzTUlOekxQZ1FaekZ5QXJT?=
 =?utf-8?B?OGJTeEhOUktJU3FRc2I1QjhScS9XcGtvaFVMNTNDZ05SV3U3eHl3bWtHbTNi?=
 =?utf-8?B?OHIvQkE5QzYrVEFiZjFXNGxOMEFnM0N1T0s5RnQ0QlhLczNuSzdoTkMyWm5i?=
 =?utf-8?B?R1hmcjl6enZuWlZsd3FnemhOQlpnbFJWTEtCTmFPcnFzZmlsamR2eDBURTkw?=
 =?utf-8?B?TU4wd05JNzNKMEs0VFZKLzgvK0N3eldHVlRYRk9xRGd6U2pTVVlNUnFqdHNk?=
 =?utf-8?B?Q2NOU0MwbTFacFJVb0wzNWVzZWRSTzRUMjUzZ2FtZ2xTTUxnbUFYQmNCRFFK?=
 =?utf-8?B?NDg0N2laUmhMQ0ZTTHpsRm0wdTFudTU2dGRWdGE4QS9Pb3JleEtHdk9tNzVo?=
 =?utf-8?B?ZkF5c0Zubit5eTBVck9Fd2ZURnhzUG9iVVhlVmVCN0pZenoyV2gxbE5kWThx?=
 =?utf-8?B?UUdpODJ5RFNjZnJUc0JRMGUrNmRaM1k3bjdCMXBjK203d0kzd2Z3NVVhaU9K?=
 =?utf-8?B?dWFaL3h0RDJnT2FLenlxSWRuMDd2czU3YWc5NTNlakpjdUNWT2FHZHNnVHF2?=
 =?utf-8?B?WjNMOFRWZk8rQURwTkRhTnl4cjJ1aEdob2dnZnM2WkJiNEVsdG41NkdjYkFL?=
 =?utf-8?B?RUs1R3FlSzU0VC9oVUpiV2RUU3R6Ty9pS0FqWnlsU2tuZ3ZNNHdqdGtCaUVi?=
 =?utf-8?B?OXk1TXUxTFpkaGxhWklJYjFLendSVHhsWjdlOGdCd2RyVHp4Y2dONnZTVStS?=
 =?utf-8?B?OE52emUxVXVSS1VmM01HcG1yV054UjFkSmQ2SmpLS3k1MHlLK2VhWWwrbUxB?=
 =?utf-8?B?WUE0cGgvOHhwVXVrdjBaSEY4dDJSbE1hcFR6OTB2a25LbE9RSmtlQUJ2T3dw?=
 =?utf-8?B?aE5haW8vZ250VFJuazI5QWVYWkZLVEJZYUdXdDVoUmdzWE1oY0IzejlURWVO?=
 =?utf-8?Q?V1DhIN6jED4PAmuynnqeQ9iB9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7baf2c67-4dd5-4017-c05b-08de28401efa
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 14:21:39.9801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KOco7yDBe4N5F5G5k4alNupf10gZjsiu+2k7Hsx06XU6XY6FCz8/TOfYfl6k7zQ/3KQBwOwaElavWcXRfN28OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF496D5EAB2
X-OriginatorOrg: intel.com
X-Stat-Signature: 4ssm9g3xtzw1s3oy9od3c31d8x93g3mq
X-Rspam-User: 
X-Rspamd-Queue-Id: 09FEEC0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1763648506-121044
X-HE-Meta: U2FsdGVkX190GhZgWXV4uRkV2dHb2gokLeshdUCRS6tloltib4+TuyEY0mpUKFj1vAUOxfTCjMhtP56s+w1paghszSP4XjRMF/oPFo3mQnV+YdQLf6ZEbxUKlB6nsWKZYebfrWOx3uOUVmKxlv2kQJ+k3/p9hMsglfgXPxrkKt4zETKKY+zxk3JaD8QlGekCqPw+bIvSWpwmbVJWiTDWKKDT3qMdBBQZP7BlpVhsylSjmVkOgS5ZbC4RhxbaPegfrAhG5Sre23XjCxmuNjAJOeXHYV/tvUsFtollbaNCh5kNJmouesIUDR3j9J9zKlf172yuchCEmquxJiVtl4hvy0GM4XVTR2GQmizARD2VWhzI/RFSzVrnSxkdVOxzw+CwQR4li+reHxuYWTfytXTONBoA9Q2fd/XasGmdufGNguk9uQWv+ZTfDSkNH9fQ9hQeypDbO093GxyVMDUVddMmNB92ZMe7Vqhbr3HPM2JV4ZOLoyJVW0P7eKv5Bo585gWR2WjDDdyKdH1CGE6HruLM0SXDXAhrYR/awVS/Vg0FQzEuZBYc19+Qyd3f+8dbzqcPX/pcUeqvxyj1l4AnL4ExKqVmUzhjGDhkfb/bDWUMf1+FTxbWmDiW40twmeTUWvo9rHZR6JBGq0cHEBX4jXwoQJhtwJ+DcHCSW510oAhBvIQ4Nd7QkB2tINwrLYB3eBKAb9i1BLNe1z7dSUkxjgi25FqC2tWCCPytfioOHN4O/SBRHi9BsjuNpVbstKL5/FEwxKqnLnqnR7zmGcOriZWBYkmeDbx/Y2h5Adhkq0a79GfDaXxqCQnvvLE3JzdJ6i/Xeq+fBv/GQuXK3ycN1fsZneF5N4jMj+zdvxr5VyVXU3ndBTNl+X6Ze3oEHG8g6nQ56j20ub8hUwRGXxMLSYlzU6tgfWGCA0qm2MLvN3SzzphxCGU5W+BguK2A9vUHZGfiBKSWC0S0dPcP4OYOIFH
 BHTEnh7x
 3Pb9kPMLKPCFApsQVJjp1xR1+W9u4fL/A8mQ4v8ct21ZxOzTV6qd7umMJjuI0lNdY+9DoR0vjVrJWWQXB9tc42A0WwBQXA6h2gUoWlaqltewqZKGN4stoNzmCnUGktaldk+6813hPwJ44wEzYHYtmRodj/nmvzp0LIcLUqdAqT1MZJkFaGsKmjtOeESZ3z6Im4h7s3BK1OzWPcnHlG1sbLzYurZz+7KyPMJW8sGiO3bZ3Wofc2KCeRFpncfusUj9C1l8EyKKAF+G6aszgBqV4a60qLY5inQ2l89NKWVKgBhVxgEwXBBNXOWVX0QaESNIMRM0wpyozjzfWomi7MTtLIIEuXjvuhu2Nc/vM4j8XUnj3bn08gIpq2VxqEVNS0NQcBjUUSlT7LUY/99EvSqZu6aQ3H9aeesA6snxhwftm3ovo8DeRwIDAV/AWi6lNv1nblcQ5XQkxUV17H5bi13lS17gLJ73rrZJWfWzIp9s1Zkb9Uv63e/PPJsZF8Fzn4KURGV5YGpDiJsQPWEl2bWuK3AWmcuk/4Pwe5k73H/oM3bGEmDqNfmgUzi7tTmznJ4pEEc5Hhm8s46HgFSTSC2JSBH5XggLXeG3/Dl7p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Thanks for your review. Appreciated.


On 11/20/2025 8:00 PM, Mike Rapoport wrote:
> Hi,
>
> Please start a new thread when sending a new version of a patch next time.


Got it.


> And as Wei mentioned, wait a bit for the discussion on vN to settle before
> sending vN+1.


Will do. Thanks.


> On Wed, Nov 19, 2025 at 10:06:57PM +0800, Tianyou Li wrote:
>> When invoke move_pfn_range_to_zone, it will update the zone->contiguous by
>> checking the new zone's pfn range from the beginning to the end, regardless
>> the previous state of the old zone. When the zone's pfn range is large, the
>> cost of traversing the pfn range to update the zone->contiguous could be
>> significant.
>>
>> Add fast paths to quickly detect cases where zone is definitely not
>> contiguous without scanning the new zone. The cases are: when the new range
>> did not overlap with previous range, the contiguous should be false; if the
>> new range adjacent with the previous range, just need to check the new
>> range; if the new added pages could not fill the hole of previous zone, the
>> contiguous should be false.
>>
>> The following test cases of memory hotplug for a VM [1], tested in the
>> environment [2], show that this optimization can significantly reduce the
>> memory hotplug time [3].
>>
>> +----------------+------+---------------+--------------+----------------+
>> |                | Size | Time (before) | Time (after) | Time Reduction |
>> |                +------+---------------+--------------+----------------+
>> | Memory Hotplug | 256G |      10s      |      2s      |       80%      |
>> |                +------+---------------+--------------+----------------+
>> |                | 512G |      33s      |      6s      |       81%      |
>> +----------------+------+---------------+--------------+----------------+
>>
>> [1] Qemu commands to hotplug 512G memory for a VM:
>>      object_add memory-backend-ram,id=hotmem0,size=512G,share=on
>>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>>      qom-set vmem1 requested-size 512G
>>
>> [2] Hardware     : Intel Icelake server
>>      Guest Kernel : v6.18-rc2
>>      Qemu         : v9.0.0
>>
>>      Launch VM    :
>>      qemu-system-x86_64 -accel kvm -cpu host \
>>      -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>>      -drive file=./seed.img,format=raw,if=virtio \
>>      -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>>      -m 2G,slots=10,maxmem=2052472M \
>>      -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>>      -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>>      -nographic -machine q35 \
>>      -nic user,hostfwd=tcp::3000-:22
>>
>>      Guest kernel auto-onlines newly added memory blocks:
>>      echo online > /sys/devices/system/memory/auto_online_blocks
>>
>> [3] The time from typing the QEMU commands in [1] to when the output of
>>      'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>>      memory is recognized.
>>
>> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
>> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
>> Tested-by: Yuan Liu <yuan1.liu@intel.com>
>> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
>> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
>> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
>> Reviewed-by: Pan Deng <pan.deng@intel.com>
>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>> ---
>>   mm/memory_hotplug.c | 51 ++++++++++++++++++++++++++++++++++++++++++---
>>   1 file changed, 48 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 0be83039c3b5..aed1827a2778 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -723,6 +723,51 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
>>   
>>   }
>>   
>> +static bool __meminit check_zone_contiguous_fast(struct zone *zone,
>> +			unsigned long start_pfn, unsigned long nr_pages)
>> +{
>> +	const unsigned long end_pfn = start_pfn + nr_pages;
>> +
>> +	/*
>> +	 * Given the moved pfn range's contiguous property is always true,
>> +	 * under the conditional of empty zone, the contiguous property should
>> +	 * be true.
>> +	 */
>> +	if (zone_is_empty(zone)) {
>> +		zone->contiguous = true;
> I don't think it's safe to set zone->contiguous until the end of
> move_pfn_range_to_zone(). See commit feee6b298916 ("mm/memory_hotplug:
> shrink zones when offlining memory").
>
> check_zone_contiguous_fast() should only check if the zone remains
> contiguous after hotplug or it's certainly discontinuous, but should not
> set zone->contiguous. It still must be cleared before resizing the zone and
> set after the initialization of the memory map.


Thanks for the pointer. Allow me to learn more about the context and get 
back to you soon. Thanks.


>> +		return true;
>> +	}
>> +
>> +	/*
>> +	 * If the moved pfn range does not intersect with the original zone span,
>> +	 * the contiguous property is surely false.
>> +	 */
>> +	if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone)) {
>> +		zone->contiguous = false;
>> +		return true;
>> +	}
>> +
>> +	/*
>> +	 * If the moved pfn range is adjacent to the original zone span, given
>> +	 * the moved pfn range's contiguous property is always true, the zone's
>> +	 * contiguous property inherited from the original value.
>> +	 */
>> +	if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
>> +		return true;
>> +
>> +	/*
>> +	 * If the original zone's hole larger than the moved pages in the range,
>> +	 * the contiguous property is surely false.
>> +	 */
>> +	if (nr_pages < (zone->spanned_pages - zone->present_pages)) {
>> +		zone->contiguous = false;
>> +		return true;
>> +	}
>> +
>> +	clear_zone_contiguous(zone);
>> +	return false;
>> +}
>> +
>>   #ifdef CONFIG_ZONE_DEVICE
>>   static void section_taint_zone_device(unsigned long pfn)
>>   {
>> @@ -752,8 +797,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>   {
>>   	struct pglist_data *pgdat = zone->zone_pgdat;
>>   	int nid = pgdat->node_id;
>> -
>> -	clear_zone_contiguous(zone);
>> +	const bool fast_path = check_zone_contiguous_fast(zone, start_pfn, nr_pages);
>>
>>   	if (zone_is_empty(zone))
>>   		init_currently_empty_zone(zone, start_pfn, nr_pages);
>> @@ -783,7 +827,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>   			 MEMINIT_HOTPLUG, altmap, migratetype,
>>   			 isolate_pageblock);
>>   
>> -	set_zone_contiguous(zone);
>> +	if (!fast_path)
>> +		set_zone_contiguous(zone);
>>   }
>>   
>>   struct auto_movable_stats {
>> -- 
>> 2.47.1
>>

