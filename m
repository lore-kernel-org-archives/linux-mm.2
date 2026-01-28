Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67AD0D25B7D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0F0F6B0089; Wed, 28 Jan 2026 08:50:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE6A66B008A; Wed, 28 Jan 2026 08:50:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7F06B008C; Wed, 28 Jan 2026 08:50:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA2236B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:50:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47B6A16069F
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:50:05 +0000 (UTC)
X-FDA: 84381506370.29.D864F68
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf14.hostedemail.com (Postfix) with ESMTP id 47B9E10000C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:50:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mtdvpNyy;
	spf=pass (imf14.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wo58rpbh5xBQax2a+ezhZptzyxugqDM4RE1I/OyXBxc=;
	b=ptX92XYb3WoO8VA+9ETLebxKt7M2oLBoSn1hWTC54MVFy+ZqyRtEZfYDRrSIOSIbccEZop
	+TUDgviscIb7zp6dMR/lL13uOXZBZN1IIKYsgG0+T9Suf09L2eokX2GiYXMtQwr38AF4D+
	1lrD/MHSPwSaoUvlSGbF6amAU9zWmsg=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mtdvpNyy;
	spf=pass (imf14.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769608201; a=rsa-sha256;
	cv=fail;
	b=wThfk5flbjGVl/X+9K5suWd2v6QMwWPWRBr488BHyPEd7vVpKLLQUNETalgpIavZyLnnGy
	rt7RdqhYBBI87Oo4AtFdvZJcMO5YDT7NuiLv1ACS/eeQquSNIlx7FbbGlv+S1mczCuSUyM
	XwqkHNMjZv4yZVO3uKUnpfYElMoKWrU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769608201; x=1801144201;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=STjymFErC3zEfxRL+Sd470CW3cgIL6cAyNXRl2LLc+k=;
  b=mtdvpNyyEmeQhvNnK1/WOnyRMrCIKNXBqw/CHT24h9gxoa7t0GfVKomG
   O4ApelVL0oLK+KDkjCpgRmr5FRe7maDeo6Sar6viioCjVsIX28rXLT6dw
   iZKnRFncRNR81KZSzDNHtryjnKK51Kj3MX3tftZNzaE9TeIxqwpOC+x8D
   fNaAzOhs+fKCTjd593MvvVhNPvRoC8Gj5K2Wc5kBuGii2SyU+MVvBgeZU
   fyr3Xd+zKfC0/ZOzeSQxh2LtnZtlHBv7BV1jUqJ+l7poI+z7g21tvcM1J
   0UI8XcApeJ5Z/sswDccsw1UJYl2rPr1/Bh8j6csoMMnnC73mv7zh21Bza
   g==;
X-CSE-ConnectionGUID: NHFa8NhIT5KPBEudLqKvPw==
X-CSE-MsgGUID: 9id7NIcHQ9euJlqEt7kkjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="70791082"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="70791082"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 05:49:59 -0800
X-CSE-ConnectionGUID: y4Nm7LFATUm3GahzLIi2fA==
X-CSE-MsgGUID: D4Rsrrm1SeK4eV4VNgKhng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="231228902"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 05:49:59 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 05:49:59 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 05:49:59 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.1) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 05:49:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b7VzpUyl95PXsWBlND4qsKr2aiZQ8nUIfvb2GMLQBirHClpePXAdaY6irxqd9Wv0hFB76VfFBL7H7JJFtjPpWH8VSUiyC1Pv2cDU6TLP2T9suYAG00SYxAEih/wR9FWQfv9g5El1qK3gOL6Fk+uqkh0E1YnCE5YebEDSNxC6yA4WPmCzFWEwhe8VIDnj8gUrmWS0aHQW2kVO0msI28fIMlFxbjCUocQiT4+4TeJomn7cKOgF0UJvCnFRau+CXcIvcOxXiIgQltoW6WSG7JRca0KHdn7AMy1SMeDnxDaOadBHJZpUjiY3FA4lLUniOoAXKnQ42aBrGASGGBMqNyQ4yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wo58rpbh5xBQax2a+ezhZptzyxugqDM4RE1I/OyXBxc=;
 b=x00sdZ6X1tI7Lp8pFfurumf1dACUJqNk8i4XyS5xmsX4fKzI25i3WSLx2NODOYOSeqrlW5ZR5ESH5/xO8ajsDIXmSk/yBKoUcYSHV63yhLPzXB2WM98Y7hbbi1Xg5nkVtxkz0Q+aDKqDKrqpDZnphZMM95gp6ZQx6Jwm/GFRIDZS7dDDjL4sZhCc9RKgE+46cV5pXOgjxn26IIuOsUTV2kpkc+jmJeUfLT19XyG/07NNlkPpulGzSafGgJMmsLKX7eNo7WGvQvkTLZC540kgtoEZiQH378bTEU8Bt2fKz/mZ40vXoOwvaSISwYEtmzU7s3WnQSqux+kyQRIUzfLw2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by CYYPR11MB8430.namprd11.prod.outlook.com (2603:10b6:930:c6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 13:49:49 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%3]) with mapi id 15.20.9542.010; Wed, 28 Jan 2026
 13:49:49 +0000
Message-ID: <c2ded9b7-c35f-4da9-bed8-b9206868a343@intel.com>
Date: Wed, 28 Jan 2026 21:49:39 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/3] mm/memory hotplug: Fix zone->contiguous always
 false when hotplug
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
 <20260120143346.1427837-2-tianyou.li@intel.com> <aXIHG8MQhMRt7M5d@kernel.org>
 <804139fd-e210-4387-9a63-ac76f4df66c7@intel.com>
 <aXhg5k_iAwzQr8Wa@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <aXhg5k_iAwzQr8Wa@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0033.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::21) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|CYYPR11MB8430:EE_
X-MS-Office365-Filtering-Correlation-Id: 52016f9a-698a-4aa8-068b-08de5e741a09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aW1IenA5eFJ2WnNHNEo2MVJ4NmJUL3p6MGsvbmZ5VUVqcWhyZmM2UE05Q3lU?=
 =?utf-8?B?OTc4cEp0MlZ1TGk1d1NHYWtNTXZybkVpV0RXcytDUDFvS01Qb2paTXVtTWla?=
 =?utf-8?B?UHlmZ2NTMndGUE5sVkRGbE5IQVg3b3lNeCtydVBzdm40dEtRRHhlYlRCNnRa?=
 =?utf-8?B?SjN3NG0vS2lyZlFIQzFmdHNnSEZIYWxpUHV0bUtaM2NPa0RVUUNCZE1oWi92?=
 =?utf-8?B?OHlIZmZwUWFuaFZzY1RyR0lMSit4Tk82cG1WbkhDeFY5SjdwUjNwQkR5bzY2?=
 =?utf-8?B?bFNBVzkzVkc5VXNjZDdnY0JVTGpmbm8waURMdmFubjY0NWZqcFVFQ284WTI1?=
 =?utf-8?B?MFRzMy8xcWwwVktqeUR1cFBDTlUwK1B5OSt1WWxiTVRkTmp2MytId294d1RF?=
 =?utf-8?B?UmJiNlM0aTd0RjN1UW9QVTJLazBGbXVnQlU0WWc3b3NEZ0VtSEhidWh4R2h5?=
 =?utf-8?B?QnBMNmtsUHJtMlVNVzViTzFxUkJBdVJuei9heFFkQVNEK29FNUtKWXpuenUx?=
 =?utf-8?B?U1B1K3Btc3FJSC9OOWQyZ2NOakdrUFdmMHBUOFRqM2FjZloxTWFqWU5UNUgw?=
 =?utf-8?B?S3dGczh5cWlnV2d6dVgxdXBUQUtOQmtDZVJweWh0d0hMdE15TGV2RURBV2FH?=
 =?utf-8?B?cTFHeWdhbWhRSm9ieWtnSnJiRDNVd0pmSFJnMU5xNFBjQnU1RUNTODhJdmds?=
 =?utf-8?B?YmcvVWFSdWU2ZzRyejJxSG5HSDNLdlJlK05OekJXZnRoSXNoamNZK0doVW1l?=
 =?utf-8?B?L0RSUnhYNkZVWHl4RE9WMStRMThodTZtajdXOG0vWjNsT2NVSElMMWF4dCtY?=
 =?utf-8?B?bEh4Y1hMUlg5VXI3dnpIU0ZvVTVWRDRiT3Y2T1pHOTlET1plVWdOYi9zQS9z?=
 =?utf-8?B?Z0FFVEpqMVJmOEU4Q2wyK0FRMVJ4RGYvdFU4T2U0R0lrcVMxVlNRcWNSc25p?=
 =?utf-8?B?eXZUR2FGeG4rZlc3NjkyZ0pZRks3MjdpL1BMem1DaVNNM1hJc2RKOGJ0bGE0?=
 =?utf-8?B?M2NxUlp1bzBVejhvQW1LQ2RjYWNQUkhrSFFhSkhOa1o3UFJOUGxBc0ZQSFpG?=
 =?utf-8?B?Z0FYWjMvRVBWdmNhYnh6SmhTeEJacFpsMW1xQnJhSUxEaVVTUUczSnJrZkla?=
 =?utf-8?B?QjAzV0EzZUhaZ3NHY1NmYTVBZXcwTnB1ZUROR2pFQ0EzYUdxRWhJY2t1eTF5?=
 =?utf-8?B?RnlLOG5IbzhZZEpyU3VPRkwyMExpeE1Db1FOVG5FaEN6VE5lKzcxMG9IL0NF?=
 =?utf-8?B?SjlnVXFESWNKdGYzcGc5YWwvTmFTQTYzU2lhekdtaUhIUVllbWI2aXFWU3VG?=
 =?utf-8?B?Z1VkNGJXVU1yMTJueGhWZFNOd085YlFTNTlZV3N4d0RnKzhjMC9mT1J3QjBE?=
 =?utf-8?B?ODcrK0JzdHpOekdPRlgvb2pPdzRTSlVrZ1JiZmJJVjczSEl2YTNkeDAvTjgz?=
 =?utf-8?B?K1ZQcW9PYmhwa0x5Rm5memhxbHVJa1hCcXFEZWJQT3lDSVNGUGhieFZPWThU?=
 =?utf-8?B?aitPWFhlRnI2UGFnZ25WUkVLTFlxN2lVTFE3RTNpLzFpb3NUUVYzVFhGRFNl?=
 =?utf-8?B?ZktrTWlJSS9CUnU4eHdLYjlNd1hCMnAwYnhKRHdHYzlmMm1yRE03YUVldzZz?=
 =?utf-8?B?bGhTdmFGd2ZOQnJTR3hHWGRSNEtpSmhuMGZuZnN6cGpGWmxrcCtHWGJkeUVi?=
 =?utf-8?B?WFRyQ2tJVlZQNk1JWGQrZXhrbWhvZnBOK0k3blQ4b2xaWjdqem91TW0zSjlq?=
 =?utf-8?B?NVMzbVgzUVI2eFREMUswUk1lVktVdXQzei9RRkNSNWdqcEVkVys0czNobkp3?=
 =?utf-8?B?ZG80YlVyY1RSRTVzQStEYmFkSmw5YUEvSHpZR1ZjS01vY3VveklsUXk5RUsx?=
 =?utf-8?B?VEQyNWRxamVUYStEa3Z4T2xzbjZBNEc0ZXZqeVdkRFk2TU5JSkUvTWZwUjBF?=
 =?utf-8?B?Sm9SaEZOMWNLUTdlL0M4OW92c2IvcFd5c0dGTUtVWFhJeDZTRWN0SzBIQUlz?=
 =?utf-8?B?REl2dnJqTGw1WmdYTURxOWpwYkt4VzV5Q1RCU3hFVzJjdElKd1R1WVp2bWd5?=
 =?utf-8?B?UW80ZzZkcngveUhaRU5FY3JpMFVoTXBXdjUvVURtQS9keHpiVDVqV01GbXgz?=
 =?utf-8?Q?UbbE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S01NQWtOdXljc2RUYmpEMFJRL21pWXFhbzN0ZGgrb0o0WGpJRk9rOHlIbThq?=
 =?utf-8?B?NWtYc0VNcDh3L1JLQ2ZYaVBNYUJkT2RsbjZOS1RNQ2ZGUi9Kclh2VHVYc1B1?=
 =?utf-8?B?WVRFY2wvOHNKemNGWXdLL05XeWtIb0VMNklXUjlpVlQ1MStIUExxRU1iNUNI?=
 =?utf-8?B?RVloOVd4MThrWlkvMFEzY3ZkdHNvRmUzY1llNVRReGZBMWhxeVc4KzFSZnRs?=
 =?utf-8?B?QitYQWU5ckVBdUl2Tkk5cEZVd2pZMlNCeW9kYUpRc2ViQmcwUGIvZ25qS0ZI?=
 =?utf-8?B?S0dkR1pXS0w4emJGcmI0VkYzT0lFNk82a0hwYWdPSEFQaU9JWlkzMHJ2V3lV?=
 =?utf-8?B?YUt2N0hiUG4wNEZ4RkdRMGJ3aC85QmVXa0JGdXR4MVhXU0Q3UlVyVWhDWWcr?=
 =?utf-8?B?aitwYTh6aGRsWFZSOVNxQUlLdTVGU3Urdk9nOGRlNzBCUCtRMXFuR2ZJTTg1?=
 =?utf-8?B?Rnh0Z2pNejNxc2lkdFp6UW1odWtPZTRSSHcydzFpZGhiNVc0N0V6MlEwd21z?=
 =?utf-8?B?bVRUWkZJUk1zamMxc1pOaHpiUWMvUUhLTWV5SVg5cmpha0QwWENIYWMrSVlS?=
 =?utf-8?B?NHREVGdJeE54MFdvV214Z0ZKbGZRMHZ3eDFhbFhxcVM2bDNoTXprSE96d3NT?=
 =?utf-8?B?QTRDZFFnY1hwZ1czcEp2amZqN0YvcjI0MlNlQUs0VkdkTDRJellCb0cxTE9N?=
 =?utf-8?B?UmdhM25MNWJNZVJNdXpWZ0pmUVhjalYyemVyMUo3UEhVcmIxUGFWaTB4R0Y3?=
 =?utf-8?B?VmdndlRRdFZJM3o5U1MvajhmeUFQLzlXUlMydFFoR1hzQ1pnSkQraThNVlV1?=
 =?utf-8?B?WXdYVmhvQ1NnRjExN092WVYxMEpKd0RuazhyTTZubWpOcU5MNjZJbmhhZldN?=
 =?utf-8?B?ajM1Y3QrY0wyNm5qRHpyd3dpblhKaGpRQTdXaC9QMFA3Si9XMERraTI0NjN5?=
 =?utf-8?B?dWQzZ0V6WXFqZThnYld4MDdkaURjOFB5bXV6aWQ3MWJDN2Z3MmtVRmp2SlFl?=
 =?utf-8?B?STZFR3N4Tm9Ra1gxYW5ia2NLOXU3WWJtY1hrNm00dHpmbGlRQ2djTjBWRG1u?=
 =?utf-8?B?Mm8rSGMvaWg0dmxtZjZJUituNUwvaEVpb3RScGppRjJKbzArSU9oSWVwZm9X?=
 =?utf-8?B?ZlA4cWJha3BSVzhHUHhYY0VwUCtuMzcyb0pIcXgyWTFsUkJPOWgwam5zb1dL?=
 =?utf-8?B?YUZZS25jUnUxWW9MOEE4K3pjSVZzckE4QVhQYjgxUnZJZnhHMG1RcUNGeG5M?=
 =?utf-8?B?SzYrK1dpWHlKc1E5L0pGYWV4c0VaSnhjdnZHckRzQkhrOWhtVzhNbHZOUllX?=
 =?utf-8?B?enlFeXZnNU9IM09jMG1yWUM3UTFaMzhQVnNZd3BHeDZDWWlHTjBNMWZmd0NC?=
 =?utf-8?B?YmVBYUtCdW52eFNlM0lGOUVjbG4xcTdnTDBuQWdSeC9xU2JiZXgwRFE0aGRy?=
 =?utf-8?B?TCs5YXlFcHRZam5obTY4TE1EclZrWmZZSXREQmVoQyswSUZzVk5QTW5ycVMz?=
 =?utf-8?B?N1piazlyUElxc0o4T1dTTUZkZzZHdkJSNk9iQnY3cVZRWkQyb1hGalpYbk0r?=
 =?utf-8?B?NzBXVHFCTFZHSmxiQVczbElGRnVSeHBldFB2QnhESXE1dVV1eXFUMUgwajIv?=
 =?utf-8?B?alo5b0thaGYvN01ZaS9iNzNYNHhEaG94ZityMXVPeUdLVDJ4QVp4ckhiUHVv?=
 =?utf-8?B?S1pyZDgyYTJZc1c1OWRBNUVGbStVQ21adWJ2dVh0MUxIN05saHhKY3hWNVNJ?=
 =?utf-8?B?SlJPQW1LSCtEWUoxaVRVVDBwcmVWcHpIU2QwdWZ5VDFzQk1nbGtHeis3aWp2?=
 =?utf-8?B?N1BzS0lqVWxjSVh6bWpsRHBnZlVCSXJndnR6dDNhUEllbTlXeGFFQTVOcDRr?=
 =?utf-8?B?RG9iWjBOTSttM3VHNDJ2WWdpMlUrWGpwdEJsNm9WenNHSmVZTnE5QnpXRG5I?=
 =?utf-8?B?MFBjbVVIQ3c2V01UbVpJTkdvbER1aHcwNE9UdHRiOTVPS24xbGpWL1gyZFY2?=
 =?utf-8?B?VnloSmFSWGhYTkUrUmxVN1NEWkFRU0ppek5KVnluQ1lCSDRmMjZ4RlZiUktM?=
 =?utf-8?B?WGxsTFJOS2QyLzRYL0tkbkFNY3lFVHpQVEVYVXpLUHlpN0JkckhGWGYxWDNU?=
 =?utf-8?B?TW9qNXlNUjJZNzNSc1hLb0Q4SnRybTYxN3lLNjhGTXNVMXloYkNnVWR0MGx2?=
 =?utf-8?B?dmtBY3VwN1c1MnRnK1E3UnY4aWMxd01OL2VicGpaeWRERk5tTUxpQ25kWkpl?=
 =?utf-8?B?SDBELzJBSEIyREUrcnJpOWpzRU84SXBFODliZ1V2RjJUdkRWTE1Kb2F2T1BC?=
 =?utf-8?B?SmVlVXpDVjY1MWxmUUR2dDJPNU1GNVBJOENIVGxGRzlWR0twZGduQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 52016f9a-698a-4aa8-068b-08de5e741a09
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 13:49:48.9059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DPzUBpYgyh2J6emCze7Vazm7TrXPEF/PnXDIPsjEYt4LTeqC+xWk5Tzh3yB71xpENSsgwvJRxlvyb0BNDSPlZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8430
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 47B9E10000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 3s9x6hyb8b9icfjouuuy57o87u3uy7ct
X-HE-Tag: 1769608201-679967
X-HE-Meta: U2FsdGVkX1+Dv7KlDDrSS01zjBYImwyJhSvxPD5X4i58hI94wENhWSgNwsAA23jZHUV8E5IWUQrDPP9lAFUf3yam8b9UW+MQi1HjOmcVzoxID8XWSaPWpSKArkbhNMpAYER8IBuBWzI/D+bn0nShZMPfJDkfKsQWUAyp0Vm1qWVv+reJIc8brsvtvLOntuVbd3b7+VBKaTvclsEEX+RMecCVPn0Pm9Oa2WDwf4Dko9Xx98POgXwzus7dLDXs7xZEIXiLk9ajjm6G3FBubEEjvRpWgtEgT3utdCZ6ZiTBHdE1yZMUr8B1tOgYhSWL7XpzYFysD4t0B3YD9S8zLd1icJ1VGRr1yY9AQfi5mToLXZwZMKfvP58fRc46S9amxNxWk1DW8nKuRWkkyaj3nnH4jeh10dByVuiFvNnwobKBa6/u4Sqe//FuOVsSUI+9nj/b6fdY6YKY65JUMEOWm9TZbMoLmhItx6e3KIMsrCwXKxvNYDWt28STHaqXWgISB7OhaqnF8tNhXzMYZYVCdUCYVcC0EzUIG4aHbYZkPrZuLuqsWDSgvs+IuvCESj+nrXJUJvBLtxE6/b4ojyjUxkEmtrBD7Pi+Xtgl8J9kIDqGEpgKVZXxEQ9hbmMXRZ84XFqHQACIYt/eICRdO5RI2YzAh+j4zSfulWxvTOHjLQ7BWqpqO1HtwSfOCbwIBap3Az8zGRrRUa1QqO6mUAiADEKqb/KfD+h2yWM5Cu9V+W/4ILtUdb1qfl+5qLWKR6FqN3rFao+qq5dmVio+wB+Jcxj5e2uIwD0pM8a5bQRMcjJwgn5lB0j/9JPB1yA9O2x8+UWhvIITIxcg0oP4Pi5trQWQ0a1LQH56CxnYnSBL8zG/risWDlSE02IIGlOxaLhC/iH32Oij0cGpQRRA0V6zieo2IHeDdm8snvvAI9ZCrajz0ukzTJ1jJ7bncx78A99qmj/4AWboZmhI9mj2z0Xrj/V
 6rOiNVPI
 F9+9DFEIR2Vf/GamlJjlKzBkitNsWLdFZwxm5OPyNEoMzV3nqXAZ6kNmSna66cbiA1i5EzvYxVNsEuM2YXGTXhCPRXHeZUuv32FuqX2o5mOyOpyMJu/WMUWezgvlXLuYv4+QlAI8g2p7xnNuFu8lacztRoKtHiZFsOn2G8i6g/wJ3kGE+jrcaTBmBU7VLWnaCX1b1HX7msH+KdcmyUzAMSLwcfwZfU/9TTFt0CkGG1WXQKqtVPywkCQiR2gvbsrWiaamNUZ/wxCaIAoxXgddSvYVGbFrogjLwQMCJIpdmN6I9JO20fAW15klr9QQLocQFfK+IH1DfzPLbesxY1W+VGHB74jQHirS0WATOX2TQu0+YNXwP0DJy5C37TE7M9D1dCjRg+SqnPGnl5sg957RE/6sxLqhyTl0rZyQus4ROWzKdJWOPO5woijAzfNM6gC3mGBoTm/2J4hTgNlI1/MX6OS9vTqxD1/RvjoQ9JlOq5NSqFItkP4vrecYs8/8sTcnf/i9MhPNpu56Xx6oTW38Q2Bvu8ZkXKvPGkyZu3YAV6uKwkEQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/27/2026 2:53 PM, Mike Rapoport wrote:
> Hi,
>
> On Sat, Jan 24, 2026 at 08:18:39PM +0800, Li, Tianyou wrote:
>> On 1/22/2026 7:16 PM, Mike Rapoport wrote:
>>> On Tue, Jan 20, 2026 at 10:33:44PM +0800, Tianyou Li wrote:
>>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>>> index a63ec679d861..c8f492b5daf0 100644
>>>> --- a/mm/memory_hotplug.c
>>>> +++ b/mm/memory_hotplug.c
>>>> @@ -782,8 +782,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>>>    	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>>>>    			 MEMINIT_HOTPLUG, altmap, migratetype,
>>>>    			 isolate_pageblock);
>>>> -
>>>> -	set_zone_contiguous(zone);
>>> move_pfn_range_to_zone() is also called from memremap::pagemap_range().
>>> Shouldn't we add set_zone_contiguous() there as well?
>> I did not find the place where the online_pages was invoked along path of
>> the memremap:pagemap_range() function. Would there be other functions to
>> online the pages remapped? Much appreciated for the guidance.
> Currently when we do memremap_pages() we have
>
> 	memremap_pages() ->
> 		pagemap_range() ->
> 			move_pfn_range_to_zone() ->
> 				set_zone_contiguous();
>   
> Once set_zone_contiguous() is moved out from move_pfn_range_to_zone(),
> memremap_pages() path never calls it.
> I'm not sure if the pages added in memremap_pages() are online, but to keep
> it's current behaviour I think it should call set_zone_contiguous()
> explicitly.

Thanks Mike. It's doable for me to add such a line. I am worried about 
place a set_zone_contiguous() will not add any meaningful value. Per my 
understanding, the zone contiguous will remain as false because the page 
is not online.

Regards,

Tianyou


