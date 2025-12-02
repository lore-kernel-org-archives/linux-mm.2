Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E32FCFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 449536B0096; Tue,  2 Dec 2025 05:42:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4207E6B0098; Tue,  2 Dec 2025 05:42:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E7756B009B; Tue,  2 Dec 2025 05:42:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC3F6B0096
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:42:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1E95BA3C1
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:42:04 +0000 (UTC)
X-FDA: 84174190968.10.3FAE6B6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf29.hostedemail.com (Postfix) with ESMTP id 97887120012
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:42:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I3rOrL6s;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf29.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764672121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tg9S48xZjz+jXtjZ9wBl9wW3cL7HmLMqNafxgvVXScE=;
	b=PiJPXbW40yuf7k/t+EdbyXvn/1iJVcoxdIGkpCtgp/IIzleQnZJYKhzD99ruNdbkmmW2Fi
	e1KrLpoPmgQ/b6PvVD2jf/EGG+YbYVJbpGJaHco7/SWUq5q0SruL8jAZm0PCHqRMErjja3
	gpzr0CGllpX4q2hYdZTSMI1v8K/1ADs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764672121; a=rsa-sha256;
	cv=fail;
	b=oMme3gWxhaGIb60n8NoxSAhzIUhNIJDMwuqcuAo9afuFg9YPsU9LoULqYii8QLku0n6IfZ
	GtnmVfm22CoGe02/1e+PtjIiOZOQtkgumUD0eC5IB3ksTtuSHYs5EA789YLPZYAEau/nZT
	HhjcpyBh/hLIg1HGUMlPjg3wZ+CEn6o=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I3rOrL6s;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf29.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764672121; x=1796208121;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xbJKnORX8O22CeO7maJhWIH2N4eyhgVNkNA4V+zUJVM=;
  b=I3rOrL6s93AskO8XMonmELm4q4kIQuXOQLwfv1toBndz/y7cegGUjSCe
   juwgfzKmGvi/guNqt93jJDJ7/Eas/N2fnwmYunwSIrPiX/3qaRfHIMNkX
   OFNDBSLhj9ZPFhyZu9WiJMch5+76oUnaUbOcaM49ybpniLFyHjhQHpcgB
   rfcNyFq+tJB2mBWxaMduHrWmON0xss1c6KLc3DR5K0EsDWLLOXnbxgMIY
   XyteIiOtLgYjXh725CLId9qpu31op9yX+q6A4S44GczSv/2eMj8GpianL
   s+ZAG9PPhiJMxjNNGTuBDXx6I19E7Kgc5MX3hV5fbuqAKHLTwjCc0h14p
   g==;
X-CSE-ConnectionGUID: 5TkIlPjYTCOImkB71dfe/g==
X-CSE-MsgGUID: js2eP3KsTSqbdJ5gMj5nwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="70482354"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="70482354"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 02:41:59 -0800
X-CSE-ConnectionGUID: m8dIQnsETqKoPAzRPVTWNQ==
X-CSE-MsgGUID: QsgFsgpcSjqhfXrEl9shQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="194333695"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 02:41:59 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 02:41:58 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 02:41:58 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.17) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 02:41:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZbBELpKXvHr6CpNsoV/t53kBuSipObhC9aV9YRKP5ZQ5xiUbzWlL+k+bHxyIaXkDmeZ5MlFN8Y1xnekjweAsHYozoK07TShpCAmqM73aafNO3VlPK6pBlD/ru+K4vTZcX+etkErRJL18HehtC6Alg0XAGdSHkszoBSk3HhwmX6kJJJUTs3O+cD1J7zgKsNTHbQtTUcpubWw3LxkA1T0mztbIynIoETmazU1TAfffG211gB/Nm8JGVSTnTY0VOJaGQbhi7IRVbexYhWdfJCBFPzCJmY9bWl1+eJg5wEAnnGaDWGxYrtq8gKPNLKgoA+V183lChc2ERtPEKcita6z3bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tg9S48xZjz+jXtjZ9wBl9wW3cL7HmLMqNafxgvVXScE=;
 b=yBMiOEZ7zV8u1XvD/zYHgMXm0+BJ1pRc9CVPPo7dAcPB0GzAFvYh0Ixxo1xIMn3vNx9idqrM6sgq8IVEG0hUk3jrTnofbTV5a/Q3Qi91QJmWimgZOWhoxkWn1fg45kK0R2MEcTltkuy+njSGjZ+D8rzZpSBkj42OLyaYhaJsO3dEtBt8iv26ycq5oes7+xWolLR66x8W7tkDfZiKZuCwzVTufgdq1x6ELz3DdJjgLgRFtl+fHhsNyEEejDVlx1H+OE/K1DTKhdgximJwlPPrD1Eh7M7WYOm1xa7wNhiYPe3Uy9z3ovNdiEdC/ubR0sw7GFT2bo6DLO1EgphCVU9TQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by PH7PR11MB8035.namprd11.prod.outlook.com (2603:10b6:510:245::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 10:41:51 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9388.003; Tue, 2 Dec 2025
 10:41:50 +0000
Message-ID: <7761ab95-4cf4-4a6f-a979-ce862ad97f85@intel.com>
Date: Tue, 2 Dec 2025 18:41:40 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when changes pfn range
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251201132216.1636924-1-tianyou.li@intel.com>
 <7633c77b-44eb-41f0-9c3a-1e5034b594e3@kernel.org>
 <0d9da08d-4293-4dbd-bf59-999488d73763@intel.com>
 <2901df56-bf0c-4d08-b043-eca294b981f9@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <2901df56-bf0c-4d08-b043-eca294b981f9@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0051.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::6) To PH8PR11MB8286.namprd11.prod.outlook.com
 (2603:10b6:510:1c6::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|PH7PR11MB8035:EE_
X-MS-Office365-Filtering-Correlation-Id: bd7873ae-1619-4f1c-3081-08de318f6603
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VFFMVUtiSXdJNGFVMG9vRDJoMmdTWHdLcElLcmNHZ2Fwb3pKK3g0bzRnTTdK?=
 =?utf-8?B?T1B4NWx6blJJUitwTTd5dWZCQVY1WWR4WGdEbHdlNE0zQXNSbFUzdmRrdTY4?=
 =?utf-8?B?bU9IZXBCZmYwZ05NZVNuODlRaVlTRU9TcHBXeW9JK1hOK1JwNXcvS3I1RXEx?=
 =?utf-8?B?OGRVR1VVcWlZQk81cXc1RXQ3RVNseXlYRW9QelJqMjkwRzJmWEk1NTFQNlEz?=
 =?utf-8?B?VlVGSlhGVE5TMWNNZmd2V2hWL1ZNbmt0TFdEUUx0ODQrTTR5TGhFSGRyWFpq?=
 =?utf-8?B?bU5acE16aTZIZTRkVTd3MitMM2JvbGMrRUM1ZWV5bFRlRHNTTWpwK2VMWjIw?=
 =?utf-8?B?cFhyR2h6SGUwTjlFcWV5VFJoZmEwNU5DMFZTblllK1BtMVBxOWFjQXc3T251?=
 =?utf-8?B?cHpJQkZXVGFjdHJZSE5xZHZUT2NSSUpGRU5jeUlITDZuTklna1cwRERiODZQ?=
 =?utf-8?B?UDBFVDlqa1pOYVl6WXNQNCs5ZENXbXkrVG9KVjcybDZkTHZRODV3N2FyTnlq?=
 =?utf-8?B?MFJWeWpiVUJaajZBN05YeHcxSVdCajh2Vkp5Tk1PNEVzdklZLzdrL2FETVBS?=
 =?utf-8?B?VGp0YlJpZTU5RWpjQ25DNXY4TmRZRWc4VnMxYnEwOVcyeEhmZmhoRklLci9Q?=
 =?utf-8?B?MG9MV1I1UEJMeXoveVRzYXFFRlNZUllIZHlVYmNyZjhRaXBFbkNDUCt4VXRj?=
 =?utf-8?B?T1U5bGJSQWZidlZZNElvRFhtVDNTRUd1WWVmblFmQ0RKSytsVm15U0E5T1Q0?=
 =?utf-8?B?eDBQOTNMbEZFYUZkZ1BDNG01Z3JEamJUMWw4OHBGMTI4ZDU0eEVmV3piaWNW?=
 =?utf-8?B?MG9UaE9aQjRzNy9oRUdmWUxnTkN3bGJQQVFIQ1VsUHRvUVo4NWhVUmZJb1Bz?=
 =?utf-8?B?czdpOXRScFJwSzVoT0lhTDJPNWI3SCtrcmtaaUgyTElIQ3hNeTBBS2ZmUXRh?=
 =?utf-8?B?emhwUWpmeTB1b2NWcXpDWk1RZlIxcnNRUUVSVVZBZHkrS0g5cUFTWVJva0FZ?=
 =?utf-8?B?dU50SVEva3JFSlpiREIrMFlPZmhzaXhNbWwwUzBhRmFDUzNlT0xGQkRjU1V2?=
 =?utf-8?B?UkFzRm1Yc2xaQldDclQ3dS9aZUswSDhCWE1JNm4vQUphc2Z0Rk1tUTBpY3J6?=
 =?utf-8?B?L2t1QkhnQng1eXdWR2M1YmxTb3I0WXNKOTkrdGpWRlRrbmE5QzkvdTNCcVR4?=
 =?utf-8?B?L2R2Y0FWajJKYkZXS1lLeHJtV2NQcE5JdWdKZGMwQ0lKY2VoNDhFSGs2Sm9N?=
 =?utf-8?B?cWkxN0p3TFZJYk9mN0lQTFdSeXJzeDhOb3l0VnJmMjVTZXBiRzRvZkdmelVn?=
 =?utf-8?B?U1dodU44ek9hb21FSU5FR1YxQllMMExNYVBNWUpoYytwaDFSQk81N2hvREIw?=
 =?utf-8?B?OG9VaTlQNklqdmFCVkVpOEVoa2JYa3dLdFJIaytzUGU5bG9uSkQvUnJHYWQ4?=
 =?utf-8?B?NEszR1pQTFAzQWlmS2FnZitFYll2eFJiRzZoSmZvTUlGNU5leFJadnNaRkxz?=
 =?utf-8?B?Uk8rZlVodDdkOEsxQW5HdHFINHVvRXFkbXdZVzBDWDBDclNheUE1UzQyaVdI?=
 =?utf-8?B?eUdqNERzd1NTVS8vOTdpYVlBLzJ1MEI2OTIxVjhzT0JZZGhsL1hva0lST2di?=
 =?utf-8?B?WFk3TUtxR3ZndEFuVlFLMlVjTmpxMXNjT2VlcG1vb3YrY3NrOVk2QVpKNXph?=
 =?utf-8?B?VUxkVFBNR0lLVzY0M2w1YWpiYXJHUnpkYXF3RlgzZWp6M0FlVTFZWHYyZDl6?=
 =?utf-8?B?cmNPYkU2anowVnovUmd0Zi9kTjdlTkZiQ1RUTzlselc0WFA5MmgyRHRGOWNS?=
 =?utf-8?B?eUdKNDN2WVlmd1VBRFRTc0RWV0V2Wjd3eUc3SnBTQWVlZWpsVnk5Vk05dkVi?=
 =?utf-8?B?U0wyaEltdHY5M2VKOFYrTUtIRXByOG9janEvbld5dHo1YzFJSDBPT3BEeHBX?=
 =?utf-8?Q?M6SRJgE33GOaTCITdGN/IZQ7/ddX+6YF?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVpmekV2MEFLRFl6cGtiUFQ3WGl5OS9FazIwaHhNc2VwVW04amJDN1drd1VD?=
 =?utf-8?B?WW1XL2ROVnBHTTdMYUhGcm5MWmtiWGxWZkcyQVg5Z0FsOW5kZ3M3MGxYVmxV?=
 =?utf-8?B?STFOSEpYL0M1WlZqd211R3VNYi9rSlhKQTUrRVVRMGg3dk01V2JJbVU3azNi?=
 =?utf-8?B?ekpZMUJ3WlZvUzRoV3ZPeGdLK0YySGhnejhXUGtMNkZQclkzWS9NdjAybG9S?=
 =?utf-8?B?SXREdDQ0bml5TWdrelhEbkRJVWo4VFZGNVNrZnhTSFVpMkxUeUl2bEw0Y3FS?=
 =?utf-8?B?K05iV1dxekhqeG9sZXYyeXc4aXBEcEpIY2dwNlIvWnRMbER4d1RVVjFNWUgv?=
 =?utf-8?B?VlFHMmxIT0RFWC83Y0dWeWtDKzV5SWtaNEJOL0p3MFNReWMrTkhqdjdoUENk?=
 =?utf-8?B?cjFNT2NiR2xIbG1JcEtXV1ZJTG01Q1drTURwMVJTZ01DKy9pV1lQZDNZckd3?=
 =?utf-8?B?bFZWV1BLdjBhMXJXNlhWd0VKU01PZ3ZVeFJ1N1JiU0QvdlhGMEJweDV1K2Iy?=
 =?utf-8?B?QjBIQVBabU83WVdQYkptNVIySjlYMkRIQm10NzJRYzkwUm5ZeHVzcG1JV3pF?=
 =?utf-8?B?bWV5bEljcFh0NU16d2UwdW5EeDdMalpQREZGTzAxeU9GSWQwSnJPVXFXVVRL?=
 =?utf-8?B?ZytvS0lqaE8vOTBZOFRoVTVGeHl3ZUIzZEh1MXlpdDhzQXB2OXdyMGh2NjJh?=
 =?utf-8?B?U3R3ZUFHTkFxdEJiWFNyM1ZYTUgvaUYrMkl6Nzh5TTl6dW9YNklDRzFIMWJu?=
 =?utf-8?B?ak1qN3JkR0lVcjdISzIxcHFJakVYRXZIZTlXYVlQWUNuVkRSMW5LOHczWGx0?=
 =?utf-8?B?SFZHLzJWYW9QSWFZOFpPUTVVRHNqTzJFVzQ0cUx5WE5Ma01GZzI5OFJTZDlG?=
 =?utf-8?B?TnNRREREbTNtUkFEblJEQW1ZaVkxNnVJNWNqR2puYTBYNWJVM0lBYkRIczhY?=
 =?utf-8?B?c0IwaVdmemQ0dmRvRi9rbjdkcWtTSVZiMEh3QmRPWXBaQmNSOXRqOHhhamlF?=
 =?utf-8?B?eUJObTRTTVViN1Bva1hTMzV2UlVhQjJtdWpJbzgyOE1pWEFQNVdOVG9RbDha?=
 =?utf-8?B?WWh3RDlnZTFTdHRMVllBOGE3RkdGdzZBYjF6UkIvY2EwMjhpODdmTGxBYXRB?=
 =?utf-8?B?ck9pTXBZeldQVnY1U1dSTFFFY1VGRzA3NjZTRkZHQWUxMlUwM0xXc2lMUE5P?=
 =?utf-8?B?bzBhaWlUdk9iMlBrK2I1Z1htNXVQODVRbU54NFNyT1ovWVB4YTIxTVdpVjYz?=
 =?utf-8?B?dGxpZm5wdU9oU3BDajJQNU56eEhrclF2ZVlhTXBlaC8raXAxbVhlSG1uMGcw?=
 =?utf-8?B?bmpWeFc0R2cwZEJsOExRSTZ2RHFEV0liK0Q2NnA1TEc3U3hZRHJSbXJUVlFi?=
 =?utf-8?B?Yi82K2JzQnJSNVNBbEZFM084em83YUltSzIvakYwdTU2QnFOSFIxWDMxZzlv?=
 =?utf-8?B?TE1KSkZIejBmeStPNU9iRXFpaDlUdENNaXBob2NyTGM1b0R3ZUZZRjJpU0RT?=
 =?utf-8?B?eEtaQmphcTM1dHcwTmxjMzdCSVdJbFI5RzgyM1FIaWFqNnQ2SzRCUm9SdC9X?=
 =?utf-8?B?R09zUjljQ3FhRkNUb2FUd2FnYUZ0ZTJ6SzNYMzdrRDd3ME9JMjhFMHZxOGZR?=
 =?utf-8?B?M3B1cEtiQk1lSFVhZ1dmVEdtaE9WK3g4Y1o3SFVnZ0t4cFluRXNtS2hVSmlq?=
 =?utf-8?B?UHhUaXZUYXJ1Y0xNUnZnMEdOejZkZVd5KzVYRzNYd2k1RVJnTzhJNHJBWWo3?=
 =?utf-8?B?RDZPb1RUSXpQYWNOU2RUQWZJYVdRMDhId0VXbWNUTmJkQm4waUlobTZTdTBv?=
 =?utf-8?B?R2pRdS9vcFYwZC9oWHJ2clVGTm1URWprRmJwWm9IcVZFTVErKzlpQjBTVDBu?=
 =?utf-8?B?VDRScG05Z1dMSmEwc3F5YmtHYjJTY1BHQXB0YStQRXcxTzFZcmMvalZseHp3?=
 =?utf-8?B?Y3pvZVgyMjhpa3p5b3JtNFJiaFFicHVoU2s4ZXRqL0RFNnJ0NXcvRXNIaVA4?=
 =?utf-8?B?SVFOWGlSMVN4c0NzS1U2WVNyNG11MytBRFFvRVk5WTlHK2VhbndsMlNVaFpO?=
 =?utf-8?B?RWMzVzJTRVlPYk54VWhyY3JYajFwTWFzaUdzaUNrcmpONm45OHFQL1FUWXZP?=
 =?utf-8?Q?GTbvKeM6J0qKTGytzI0qiKaJf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bd7873ae-1619-4f1c-3081-08de318f6603
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8286.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 10:41:50.7360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RBTcvPRGYzv0PkJg6R/VZE1AAIUr0ce57OENlT04iZ+Ty2niQGBNkTAv19aS/AcW66wq0FN7cXRbj8TesKARw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8035
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 97887120012
X-Stat-Signature: 1wbhh1raxri6nu1zbyzi3eezzb7n7s3g
X-HE-Tag: 1764672120-683300
X-HE-Meta: U2FsdGVkX1/BB2mbusFTo6DBlIEP1Ewj1u8faCvFrB9RoFasxRSd+uB8puGri+is6OU43LEeionL1hI9m6PuOjrCy4QEsWoedRbDbQcz25yqyY1y8H7H+3eSPcHlyqMIEU/DCFH/5Hnj2+HnpTAsCPhO38Lu2wPg/1NTCantyQsEdommfsoAxjsXEHjp9ju3OHLDD6IiH7R1r+BnFnT3mB35fDgk5C6ZaKTZgz7txW/vpKsKWAuvGeD3g75+lGRrZG3RoqGEUusD0HXjApZGxGrzfeLERezmIKtTBlMs0uFMPb0HvUDt3gjPLHegelVoHderoOkDvW6b0rVyvoJfWiY8HRgOcZCme1ZkqQiZ8Jml0sc3IwmCAu+By5GNsKGkmvJT/K0OsY1oNXJqbtgmAqikrJHSnJJbumUJJ7QOFp0LdquMOJCjQ8Xemlj434Vz5aRG7bG1uMM1r4AwgfMF88AQ/SP05yD+gqd1PSWlZm1uRqev8+tjDo0bbKe2GuKE1TJ2CL9JzjJQxUl6CBM2d0Ejy5wxnskuYBG3IGwpRS2d8zuL+yAgM608fk8v2jxXlgq+TKVmdWtDwdlBKBWaZJmUpQbH89qDLxkMgVwkq0B2cjC91jyx6jiTdncsJ4ihAgshgE8fAGELOKYUVrN3vFZkXZGpcRqqe46cEw5IAmiMQOsFv2JNmgrAcqNE+tgF1mmcgi1DWTKtx2poPho57UTzrle1aJ86WMZ/yOhoxLpjWGvqJIkm8JD5TPBzN0jC8r74eRERenJa/qAwiC3TpsMQd38QDQnscGGjK7m9w0yRDzBuwUka9bCu2g1YigHnwB+HXrHje8M9W7CZriQW/F3BrN5WnrdoCS7Yq9pnpj0t89MmSfYMn4da00w3HwsBX7HL7UCaLwkTyo1IGUX+pTQVVAIaX9MSoITcVPlbC/cKm/QBf2oATfCLpS6ELBSGO4GmvJbK8BvqAQe6nBM
 Avs1GFGb
 uOIOkxw57Hb1IJ9yYRs+iqYrOpOZhVP7zGRPbrJyoYIiAJ4Olpa5mK+ly8Cjv39NZPr6aGrsQJu78e7S3YRPXJAbDDVqidWCIcuflfciGVYzWsh/w4ZVzY+6ZLcIg5xQ79Im2KM1uptDWHHpjDa+tyYYt45Md+CJ1W+nDoQeBx2KIgRcT/BwWj9HchRWMQeKbdIw0ZFv7UFj3Ha8hAel2+zSsBgfeNCvKqztxojgm6Ci6+weQG52oWoGQBdh3+XypZyugRmvQTlzzqjCLVwlMtvcY/7sRA+Q1Tp9oj6EdY2wbhl2VbiRBrRYObSi8e/KvFpaJM1NAT0Q+lV5T/hjBJPK7ivw+4dL3Ls8kknn1gln7ldtWY2B7tOSHX9ibRUYW7Aj3ccZmGgOyHBXeeZZO4KsiDXGiGaLDS5hpspKKZkKwweHZc2baqrSYND8xwLKbgRZCEmCLAqPMU6nbdkoTHOAlcL0zvZ8Le7LuhCDkCUw8+1WNGKVJbZU+TvBkFCWCYGoBWeWhzKjFE3kVUOwfN171Wg+rcpFpriaDCoRZEWzKQ+xGE58/ew1uRDcOLW7YqxKunAiiZa7PL48=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/2/2025 6:24 PM, David Hildenbrand (Red Hat) wrote:
>>>> +};
>>>
>>> I don't like that the defines don't match the enum name (zone_c... vs.
>>> CONT... ).
>>>
>>> Essentially you want a "yes / no / maybe" tristate. I don't think we
>>> have an existing type for that, unfortunately.
>>>
>>> enum zone_contig_state {
>>>      ZONE_CONTIG_YES,
>>>      ZONE_CONTIG_NO,
>>>      ZONE_CONTIG_MAYBE,
>>> };
>>>
>>> Maybe someone reading along has a better idea.
>>>
>>
>> I agree it's better. Will wait for a day or two to make the change.
>>
>
> Yes, good idea. No needs to rush at this point because the merge 
> window just opened up.
>

Got it. Allow me to take one more day then complete the patch v5 with 
sufficient testing.


>>
>>>> +
>>>> +void set_zone_contiguous(struct zone *zone, enum
>>>> zone_contiguous_state state);
>>>>    bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>>>>                   unsigned long nr_pages);
>>>>    diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>>> index 0be83039c3b5..b74e558ce822 100644
>>>> --- a/mm/memory_hotplug.c
>>>> +++ b/mm/memory_hotplug.c
>>>> @@ -544,6 +544,32 @@ static void update_pgdat_span(struct pglist_data
>>>> *pgdat)
>>>>        pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
>>>>    }
>>>>    +static enum zone_contiguous_state __meminit
>>>> clear_zone_contiguous_for_shrinking(
>>>> +        struct zone *zone, unsigned long start_pfn, unsigned long
>>>> nr_pages)
>>>> +{
>>>> +    const unsigned long end_pfn = start_pfn + nr_pages;
>>>> +    enum zone_contiguous_state result = CONTIGUOUS_UNDETERMINED;
>>>> +
>>>> +    /*
>>>> +     * If the removed pfn range inside the original zone span, the
>>>> contiguous
>>>> +     * property is surely false.
>>>> +     */
>>>> +    if (start_pfn > zone->zone_start_pfn && end_pfn <
>>>> zone_end_pfn(zone))
>>>> +        result = CONTIGUOUS_DEFINITELY_NOT;
>>>> +
>>>> +    /*
>>>> +     * If the removed pfn range is at the beginning or end of the
>>>> +     * original zone span, the contiguous property is preserved when
>>>> +     * the original zone is contiguous.
>>>> +     */
>>>> +    else if (start_pfn == zone->zone_start_pfn || end_pfn ==
>>>> zone_end_pfn(zone))
>>>> +        result = zone->contiguous ?
>>>> +            CONTIGUOUS_DEFINITELY : CONTIGUOUS_UNDETERMINED;
>>>> +
>>>
>>> See my comment below on how to make this readable.
>>>
>>>> +    clear_zone_contiguous(zone);
>>>> +    return result;
>>>> +}
>>>> +
>>>>    void remove_pfn_range_from_zone(struct zone *zone,
>>>>                          unsigned long start_pfn,
>>>>                          unsigned long nr_pages)
>>>> @@ -551,6 +577,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>>>        const unsigned long end_pfn = start_pfn + nr_pages;
>>>>        struct pglist_data *pgdat = zone->zone_pgdat;
>>>>        unsigned long pfn, cur_nr_pages;
>>>> +    enum zone_contiguous_state contiguous_state =
>>>> CONTIGUOUS_UNDETERMINED;
>>>>          /* Poison struct pages because they are now uninitialized
>>>> again. */
>>>>        for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
>>>> @@ -571,12 +598,13 @@ void remove_pfn_range_from_zone(struct zone 
>>>> *zone,
>>>>        if (zone_is_zone_device(zone))
>>>>            return;
>>>>    -    clear_zone_contiguous(zone);
>>>> +    contiguous_state = clear_zone_contiguous_for_shrinking(
>>>> +                zone, start_pfn, nr_pages);
>>>
>>> Reading this again, I wonder whether it would be nicer to have
>>> something like:
>>>
>>> new_contig_state = zone_contig_state_after_shrinking();
>>> clear_zone_contiguous(zone);
>>>
>>> or sth like that. Similar for the growing case.
>>>
>>
>> In both shrinking and growing case, separate the clear_zone_contiguous
>> from the logic of zone state check, right?
>
> Yes, I think that makes it look a bit nicer.
>

Thanks for the confirmation David. Noted and will do. Thanks.



