Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5600CCED25D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 09:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F15B6B0088; Tue, 18 Nov 2025 04:36:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A1106B009E; Tue, 18 Nov 2025 04:36:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 890996B00A0; Tue, 18 Nov 2025 04:36:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79F956B0088
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:36:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 26DC716047D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:36:11 +0000 (UTC)
X-FDA: 84123221742.07.4762B61
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf18.hostedemail.com (Postfix) with ESMTP id 80C3E1C0004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:36:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dcRMPbq+;
	spf=pass (imf18.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763458567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1NaVQZlMecIZUIIt01csIVu4TXOPbaNa/ZcMHMNGvI=;
	b=8cUljhDCEOxBnX7Y4df4b9R+iGjeU93nW8MCxmfp/7gRy/Z0PnpgOgcZrpLPI12m84F2ss
	tjeXk/Ows+iNdyObrcdYQIlmNTHUPEw1vtjNi/VlPePF1nmsd2hIWA6RzLLhUlhlMhiJ+A
	bvX+5agBz58vKrECGSk2MfeEoJoTddI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dcRMPbq+;
	spf=pass (imf18.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763458567; a=rsa-sha256;
	cv=fail;
	b=hNZq/D154cnLbz17R8APXmWoJsT+TzH5KkVWFi4tgjXzDDNPfztxzsJkl9b/rwn5ufZvvS
	2lkT78MdCdDl2ywmre21nKfVzAP6vXRRfFdYl17aqiuc+i5D38iXO514kvKOYtTvUVO9Uh
	u7OhYhmzglxiwVcHkI3ntdQV0WkByi0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763458568; x=1794994568;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3sPzZsKkrCvLRzUVG9+ivWNv1Maa2cfIfmID3SrWWi0=;
  b=dcRMPbq+iVMWoGRt0xwX3C56ske7T1w8HhXrNeRf5kCgryZ6FbL2U/Yl
   kL1/WJyHlyjZJolq/lxo3Jvp9TA12D7rN9+vGC/QfKoGc22NEPbq6p9HT
   chKbGv3MAC9sryA/JxQ6yT27cyjeDZgIaWW3zF8MKMKyud2YgdGbCR8Hv
   3cS77vwv/jcUI/f3gcpaoXVyqgxp0j3pf8Oh9jz9g9L3kWFeZ4uvmOB8d
   TdQn2j+mP5A1csuVe9i9tVZoH/N+SQvJSKmGSq8nHTZWVEXWuNW0Vb3Wc
   rwSfyCB+fh8bzZ5TibHb8BhVi3FDd4xodiLE50076Z91yjBIuzNjov3HU
   g==;
X-CSE-ConnectionGUID: kNK8l/sRT+6kU8Y0ioqZGg==
X-CSE-MsgGUID: l+jpP2qGRKiNMTtk8XNRuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="75798159"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="75798159"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 01:36:07 -0800
X-CSE-ConnectionGUID: 1M6mAcGhRGu94MsrD/6lQQ==
X-CSE-MsgGUID: XaYd493DSFu+kidQS6OUKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="190874606"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 01:36:07 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 01:36:05 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 01:36:05 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.65) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 01:36:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tnT0N/TpEkw/5MzTB0c17uf415DF5pwHn1JfrsQXV3sCHGIwLCiF71I/4efOJi518QHDjfHOCpTcG0uKTw/2fB08rx4+uuDVzn546c50K9TRzvXIqzjVcrrAWrlFN4OS6Fc1dKveAHluZEyzxKiQoRaH6qwZsdXa6hLzQLWE0xAXbPuqwH2PmbcTMfYEm0sKHP3yY9Ui+6OavQXCZrJNYm8KWMNhoti5sAISg6umPZlt09Zef0rC5Z3N7QbqmN9I/cgG7ELUZbJwwQIkNndwyaRo/59oTtZzcWw3vN21q7p6b7b4Ax51t4RYvdtGEMmzrJUhTmGbK85xYNd28pkMuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d1NaVQZlMecIZUIIt01csIVu4TXOPbaNa/ZcMHMNGvI=;
 b=nIeXOAL6f5s5LzGfl07moXMSwTIgMeD3h3FdLHY3obxS207IWbYV/XLqwivFgMKyIM9tggWOt3LneG9+Gy8MTr9rxZbR8cKzznQVDro76NNDng9HeeqP4D4PM5OopfCWivfdSoJPWDr02l5Q/8DsUU9bkoONNFzR/EZzirYYjqKfrUDLW2pUWTHBkuhlMT0Nb4zrlouVoIYCthbhYAdnTnO78+613TJuuPlLOodnY1VH+1tEyO8xqec/o13iwY1an+frctv2yNqAWxC5IlieLCl5/tcUKfbeO0lmtQV8uq1eTjmNOdhwEXOin0zEOL/NaA1hG2oBdeqltWxcMNijng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by SJ1PR11MB6202.namprd11.prod.outlook.com (2603:10b6:a03:45b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Tue, 18 Nov
 2025 09:35:58 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9320.019; Tue, 18 Nov 2025
 09:35:58 +0000
Message-ID: <d78e10f2-9483-4d05-9a73-eebd8d8af827@intel.com>
Date: Tue, 18 Nov 2025 17:35:52 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
	<linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251117033052.371890-1-tianyou.li@intel.com>
 <aRwAjSQBby614Itx@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <aRwAjSQBby614Itx@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TPYP295CA0026.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::20) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|SJ1PR11MB6202:EE_
X-MS-Office365-Filtering-Correlation-Id: 30557e42-29aa-4a53-d298-08de2685e12b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eVBIV3FQYkxMb3FtTmVOL2dobmVQTmRoODBycXpOWXhqcDE1RENYdmtHVENa?=
 =?utf-8?B?S0Fqd0NqTUF2MHlxeXYwaEhGK1ZaVXNrcXZTVUtpV0hDWm5oRmVHZm9NV29W?=
 =?utf-8?B?UURuK21ueUhtTXZ0Q0UyTjB2K0lGVVl3Zm5jbnR1a0w0U3JWUksxQWpHL01q?=
 =?utf-8?B?NFNpL3FjUE4wRGZybWNRRHh2a1F2QkxZWFBXRDcwcDJaV211eUVuRTd5RFh0?=
 =?utf-8?B?ZGRXbjJpK3VYQ0hiNEpRdENwZmhxY2l3RFZtbnhvbTRDL20xaUdDclhOZUpv?=
 =?utf-8?B?NDVDOWJZVE9GK2V6Tjh3cmxFVWxMbHEyMkxPaG0vbWZhckJYTzRzMXU3cmQ0?=
 =?utf-8?B?L0ZoWGVJLzFCYnVhdHVuTEFkYWx5Z3FIVWR6Zk5rcUpIRHBkeVhQZUFnNE5X?=
 =?utf-8?B?OGZXM2lodnNvdlBHeXdiekhRaUJ3b2l6WGo4c2dOSHJpRDVPZUhwUGgybTFO?=
 =?utf-8?B?L1RUQ0hjOVZ3dmhlQVlKeVFPeUlqdFIzRCtYbkZhT2tqbFg0NW1SdUhzaita?=
 =?utf-8?B?cWQwK0IxcG1YUk93VnlTd1AwTGl2MzZlVjJLNFRlQ0dlYnhwTGh5U2I0OXNx?=
 =?utf-8?B?amt1RDk4aVVDblFveUV2Si8zYi94QlhOTHl6ZDRuSFBmc3VuVGdvZFRLdE9G?=
 =?utf-8?B?KzJKMUNaQ2FmWCtCZ1NZcm01dGVwalE4Z0UvY3NrNEplSWdUWThBYTRXaXBD?=
 =?utf-8?B?SStEanFmYnplVUVqV2oxRUh0aGZsV2twWktMZGo5VjVJMkJISTdQOHN0MmIv?=
 =?utf-8?B?LzJGS1ZjWjVkVmN1dXpQc09CRktsVlcwaGlkQnVES0JjYW45VW55WHJzNDZX?=
 =?utf-8?B?dUtBUmtVbm9BSXN6Z2h0ZUFLYVlyRVpoczNiSlR5aXFyYUFQcFYxRzZGUmE2?=
 =?utf-8?B?WXk5UVFGWnFsSzdGZzJxQWVQL1U2STFUZHY3RFV2dXFMOTB5UTNrU25LVC80?=
 =?utf-8?B?Y09SenJSeDlnTFhldFlUdW9MTVYyMkFnZVdPR0k5TmVBajEvL2s3Q25OcHRE?=
 =?utf-8?B?MGp6NTgyK3V6RVRuSlljS1lybjUrdnZWek1tV2RDYVcyQThjcGJLc1hKVDVq?=
 =?utf-8?B?dmtuNVFMYmE0SnYxeXpPdWsvWjBvdmV3YVJGeGlQSjk4YjlKQzhuL3lCeldz?=
 =?utf-8?B?UFFLM0VxK0tuT1hneFd2amgzYlpuTytIblZCdkRxbmJGL2ptQW5keTRjN0lM?=
 =?utf-8?B?di9xZTdBY21vTDEzeWZSMGZKK0NQVWVOZ3JpM3JzekJrVTdlZUd2SFNFY0pF?=
 =?utf-8?B?UnFUMythT0pFUnhITnZiM0ZLZUNKWkxhdENDV0FTSnl0cUpTRHlRakhBc3da?=
 =?utf-8?B?dW1veXE1Q2pUcGdVcyttZmNiSzI5Q3ZpdXk1RDFUNm1XY1NBRUpQcVdKZTFI?=
 =?utf-8?B?QkhBeGNqZXNnbDFRYmpIRHp1V0RuTXV2SFdwNGt4cm5SekZQL1hTdVVQVGN6?=
 =?utf-8?B?cWpOdVBNOTA4cHY4MlQ5azZrRmVtcVVZR3BQU0hxMlB0UUZUalpEOGFHUkUr?=
 =?utf-8?B?R2h4UEhZNEpVSzh0TFpGVSswY3RYQ05JWEIrTlNjWVhVd2w0RFNVUXlsSUc1?=
 =?utf-8?B?dnFZN3ZDYmZWdU5INGI4WHNSanMyWG5yNVBnL3B3bzlEM0tGVXZHdkxsRXUz?=
 =?utf-8?B?VEorQVVpQjVqVGFTQy93T3U2bUdkNkFBV0VxeFlxVWVJOEFvbmJwQm54ME80?=
 =?utf-8?B?SU8vWm45bWxxamdFWmRoNkRTTlpFOWFjTG1MVGc4KzhJc2pNUVJXeTZQb1dj?=
 =?utf-8?B?QUJ4Vm5RNWxYajdHWHExYklTTnZwQ1NoRWZEdW1GUzdURUk1bnVxMk90MlIy?=
 =?utf-8?B?UklYVStPUDk1anpmUXZETUZOOUtHQW1iTlB1UktDYW4za0hsSUdTdDFwRW9H?=
 =?utf-8?B?STJUQysxY0VLbUhDUnFETlU0VFhnOWN6WDVDWGdIZlhmZXJSMVRnVXk3TXJ6?=
 =?utf-8?Q?KPCjOfOyJyUiHuMjDPsBsSOky4NuLDbU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2dncEFFZE1lYUVIbkgwUFhOT3d0TUV0RUVmVTZJd0hTTElYYnZXRmtCMm9P?=
 =?utf-8?B?bWV3SmhwNTE4NDRjSDk2a2pHWktOQ0hqdWYzSkNqU0dXOURyeWs2M1c2TkRK?=
 =?utf-8?B?T2NMTEhPWU1Td2RqRHRCUjFETmRwemJ6YWJDelljb0c2RVg4MVJjNysvb1VC?=
 =?utf-8?B?dEVGWGNveUhOVE85d2pqd1dvZXkyZ2JNQ2h6UGZwR0U0TG9QZVFCTEhkNnBt?=
 =?utf-8?B?OExFQUpBTUYyY3NlWmtGb3dwMnd3WGxHVUsxZWhScWh4MTdUQjJocGxSSS9W?=
 =?utf-8?B?bWNLY0Y1VGQ1U3BtVkEvM0REeWtwUTlQcU5KVXkzQWZyaWhpcXd4U1E0czZB?=
 =?utf-8?B?WXQzejN3V3ZUcUVod25TcUhtTGxLRUYzOUtydWRJeFQ1UlFSandxVm1vZU41?=
 =?utf-8?B?alVDM21RZEFERERZbnpCZVZWRHhib0pPQmYvWnVxbWJYZTkrUDZwWTJIK21G?=
 =?utf-8?B?MlFyS0JUdjRScHAwajNhWUd6M3Rqa1lrZ2hpUTEycTMxcVM5bWhiT1o4emNE?=
 =?utf-8?B?SzZjZDVWTWpxaDRBaUIwTG1oeGhPMWIraW9mYkdBRk9GajN6VXU5QUpPQjl0?=
 =?utf-8?B?UVN3ekRzdENmRUVXbG93U2R2MGxhdDN1OXc1bWNkNUUxZFdJNm5uR3B5NkNJ?=
 =?utf-8?B?QXlIUWJPa3F3dUF3MG9jTUwvQUhNKzFCTVZPRnhGajNhekQ3VFJHOWFqU3NN?=
 =?utf-8?B?WTZtTkMyR2p4YVBuZzJOVDhjTWxKZXVVaWNya21aVmtUR09tdVhDclpmV1dK?=
 =?utf-8?B?QmIySWg2SUxDU0FnV0JSb0JPVXNicjNyd24xWmZ2Y0U3SGZZbzhhVGdvemxP?=
 =?utf-8?B?S2Y1Nk5FUnI0d2hSOUs2d01tS3dMaXY3R3dPT0pXcWFIVlN2U3U5amdmYko5?=
 =?utf-8?B?Q09hc3lmc3hzNzNwbHgxUk85YU1uTmlkOWR5RTNXZ05GWnJSNVVqUnFqWTJX?=
 =?utf-8?B?bnczVS9sY0w2dVEwNUx1alRUeXZ1NzRCU3BXeFBpRnM4WGRNWjJHSFJlb0Fv?=
 =?utf-8?B?dytmVk9MQ0piRUo0T2JVWkY5ZVVyaG81RDJlYU9QUkVlcys2Ulg1SDdHbkdB?=
 =?utf-8?B?cy9Bbk5WVU4wOW9ST2lrQjVmTEtmZ1M2bnZaU3dGOHNYbkN1TFdIdDBxZjgr?=
 =?utf-8?B?aTRjNmVoeVdhYzJ3aHRsTjU4bCtxcUJOZ0VNcitkdU1rMmxOaVhWM1EyaGJx?=
 =?utf-8?B?N0pFaCtqaFpHVE9FNDJxS0ZaWDBUWTNmUmlYVzA1WVZiVVFVT21DZndTNjdu?=
 =?utf-8?B?em0ydjRSbllUczRGbnJPUGRwVWhvSnVEY1RyRCtmRWNHMXRLVERyeFJGS08v?=
 =?utf-8?B?THFPZzEzYUZsRnhub21wRFBBbnFqb3N4SGZzd3R6M0ZNMm9NdDIwdk5KV251?=
 =?utf-8?B?MjNuZURERE93Vk1RV0RCU2lYS0I2eFNoNUxlbUJNNVhYUzhnNjRiYmZLSlF4?=
 =?utf-8?B?cFBPcHZKenF6TGNqazdRdHBQcXBGUGRndS9FNzNqbkQyWnppeXpKa08vZkI0?=
 =?utf-8?B?cGpSYVFtYy8zb3VPTE1VWEY1N2JISEVRb2JsbVU3dFhGMTFYNURYM2MvMmlW?=
 =?utf-8?B?Zm5YRE13M1NkVS9hSXErbDJsYk9mbmtud1hRWGVtdzEzdWVjUTlBMTVZa1N2?=
 =?utf-8?B?MklDeFJXZVZkWm1YNHh4bE81bWwwNVU1WXk0UlFjd3l5MmlUMXl2TWhmaG96?=
 =?utf-8?B?bzBwRXYrMEFWY2pOd0w5YjM0TWpxclEyRkJvc2FrTFNYUk5Da3QzWk03cUVm?=
 =?utf-8?B?ZjRIZ1poVk8xTkpPSTNVSlNYcExrMTRteEVxQVZ5THhLMkphaWgyOVFYNWlS?=
 =?utf-8?B?UStjVnE4Y2ZNZkFGbE50cFRLeFJqOTJzcnFNTXYrOEhkTnVBOGdJbGZnSnlZ?=
 =?utf-8?B?ZnU4TEFodk1oU3o0TGEvMTBEeFZ4ZXBxU01NeHk0cUhZZWQ3eHRmcENTWHcy?=
 =?utf-8?B?bmExdjFFV3J5dFowdlcvVnMvdndKWVNpdFZQYkJPZ1lMb0oyUTNSV2JDWE5v?=
 =?utf-8?B?ZnVFaTBCcjJEWkJpeVNqTDRHemJuam5heGp4OGxvTFhTaC9PcWxCeEltdnZR?=
 =?utf-8?B?OVlDQlBwbVVkdlNKYVpaKys5WVJWREIvZ3lqMmt3M2VuamxDMUQxVXhOVTJj?=
 =?utf-8?Q?2dWnGk7YjY4u0t0Q+VrQQ8tj4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30557e42-29aa-4a53-d298-08de2685e12b
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 09:35:58.5563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Amg/yrasggJwRJGgQWitQaS9ED97VsgR8Ds+lN+9LKSoQhWw9O2r+YnuB79nzodszmy+tYsvnXLZI97b6mEf4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6202
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 80C3E1C0004
X-Stat-Signature: pfdxjr8p3dsjcmqyc1f9kqebbwj5f56y
X-Rspam-User: 
X-HE-Tag: 1763458567-831621
X-HE-Meta: U2FsdGVkX19Mi3Y+0TOlm6Kt9xRkMh8plmX9CIeYv3dSDlC4pRJWfBN+cmk0Nu2LmpbNUy+O8S0G++VQWZXa4m700P6f7oPeIInaIH7EQmWvRNhg4pOEsZ3QjFdgEwNm8hQVorrSNpXtsTzHMS6vh2rM9DDP1fy2Op+CJWPBE5m3bYTEJL4BRH7NgqFD7GCTxID8LTf8+pi/WfgM7j6XhNSnsYOIOYAYnu0cIEshxqNwgIQFfrb6eXXnav3C2kA1y0dQXT+zju7473ln0C2KFyC3X9qSMR/vnGveHVVL2E8t7id5leAiQU+S/g1hASS6KrEe2/6UHY5r6oS/6LdiJ7i6+yT6Xh7Y0o22h6qBQrym3D1mId9TEnH9AyQDPsKqhwQVW+BvvLZGSio162ZpenDREIWgckhmfhTAxJT3L1xUYzoGcq7hB8JnpvEoHwy7nqBpaKAfA+mCJbuUYlh1kt1gs/yzp1jADeFyIEw3sYz2cKnXvB1Ws3sGnEUdtFBYQZiYh0DHq3EH+1pKgSGHOXCtMtHV98dpsIgcSfCfvEE6Fb0KbZmNa/m2SDaviV52yEWHtC5z5/SjoGK+RXS/ptOD3Nxq0u60QN4NEuyeXtErL47rbHfM0npdUzARpa1HWJXW6hwgb9vtyJ4HjJYpaoHZFXALUdY4XAlm9ExA98/xBEBnh/FQxDQsQ8cb1cXU3vdgXb7M6w0oXP4SHJuX/HOVe5hKiytqdENbsq0Gbci5o/G8tLxP1YGmSJ3do2RgMnjcSw5dwVP3zBMDL7GUN0rvgIyKHLxSmlnTEMeuhk5fZ02g/PtY2WPEqceqrFlbtqhjZ6UBnyjzvvSF78NnsGTia0jf8UqmSXBrdPSTczgQAu46BBXGKhWNsLSCj+s/C8BsyQap4wzjbpARGW9eVGPNZR6fj+8Wn6fg835c270sLQcIwEPzo1ZNsjzPKusYdI69SjgRrFFZLzjqnth
 bRwT3Yj5
 wbB9SmuXuRtQLSMHFNNlXN2DSzcUCDCZPt+XC8aLuoe4zaJo3YjoMj1S1nRSQSAqFn+f09bygw02gBSh8l7HlwcGe+5vQS07uQx0BzbFrzTyoxH8y2OrSZ0jzD8B3z4AV82zVI/2qMbm9Huw4DNPIgnElxvyUmQcb5DKGHfHVPX7m2bRxVIKXWj+r86H42cqxmGl/YaCRrr2xMxW2qEc2Kvglbl7wBCtNcp5UIGbaWYJXiI639buJmIBL6//sCLaH1ypWFkZBA7LLyuyhlxJMs5tz+RWyFsET1MvpHSbru+meel8LJMCPjxMT8wN1PNu8EJvVOEWN+aKsV/EvyP1tOsqiDqg0kLPSxIXVxeqMNLi+IHH85JAlUrC7xcxh0BKdXDGqMo4R/sQ3+Xv+rZg4F12DNK6h/I8PFNe1U+WG/VgXFDbGU2GwhdXOweRxvnBTULd+kbVHU/8Y3Bk+5al4RplPYL4N0izc3eabTFL74GshVTdqqiE8iTD5Oz16uwWAItYK3Hpf0MrE/IpuGfmQLdB6RA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for your comments Mike. Appreciated.


On 11/18/2025 1:13 PM, Mike Rapoport wrote:
> On Mon, Nov 17, 2025 at 11:30:52AM +0800, Tianyou Li wrote:
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
>> | Memory Hotplug | 256G |      10s      |      3s      |       70%      |
>> |                +------+---------------+--------------+----------------+
>> |                | 512G |      33s      |      8s      |       76%      |
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
>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>> ---
>>   mm/internal.h       |  3 +++
>>   mm/memory_hotplug.c | 48 ++++++++++++++++++++++++++++++++++++++++++++-
>>   mm/mm_init.c        | 31 ++++++++++++++++++++++-------
>>   3 files changed, 74 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 1561fc2ff5b8..734caae6873c 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -734,6 +734,9 @@ void set_zone_contiguous(struct zone *zone);
>>   bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>>   			   unsigned long nr_pages);
>>   
>> +bool check_zone_contiguous(struct zone *zone, unsigned long start_pfn,
>> +			   unsigned long nr_pages);
>> +
>>   static inline void clear_zone_contiguous(struct zone *zone)
>>   {
>>   	zone->contiguous = false;
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 0be83039c3b5..96c003271b8e 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -723,6 +723,47 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
>>   
>>   }
>>   
>> +static void __meminit update_zone_contiguous(struct zone *zone,
>> +			bool old_contiguous, unsigned long old_start_pfn,
>> +			unsigned long old_nr_pages, unsigned long old_absent_pages,
>> +			unsigned long new_start_pfn, unsigned long new_nr_pages)
>> +{
>> +	unsigned long old_end_pfn = old_start_pfn + old_nr_pages;
>> +	unsigned long new_end_pfn = new_start_pfn + new_nr_pages;
>> +	unsigned long new_filled_pages = 0;
>> +
>> +	/*
>> +	 * If the moved pfn range does not intersect with the old zone span,
>> +	 * the contiguous property is surely false.
>> +	 */
>> +	if (new_end_pfn < old_start_pfn || new_start_pfn > old_end_pfn)
>> +		return;
>> +
>> +	/*
>> +	 * If the moved pfn range is adjacent to the old zone span,
>> +	 * check the range to the left or to the right
>> +	 */
>> +	if (new_end_pfn == old_start_pfn || new_start_pfn == old_end_pfn) {
>> +		zone->contiguous = old_contiguous &&
>> +			check_zone_contiguous(zone, new_start_pfn, new_nr_pages);
>> +		return;
> The check for adjacency of the new range to the zone can be moved to the
> beginning of move_pfn_range_to_zone() and it will already optimize the
> common case when we hotplug memory to a contiguous zone.


Do you mean we can separate the update_zone_contiguous logic into two 
parts, one for fast path at the beginning of the move_pfn_range_to_zone, 
and the other for slow path after the memmep_init_range?


>> +	}
>> +
>> +	/*
>> +	 * If old zone's hole larger than the new filled pages, the contiguous
>> +	 * property is surely false.
>> +	 */
>> +	new_filled_pages = new_end_pfn - old_start_pfn;
>> +	if (new_start_pfn > old_start_pfn)
>> +		new_filled_pages -= new_start_pfn - old_start_pfn;
>> +	if (new_end_pfn > old_end_pfn)
>> +		new_filled_pages -= new_end_pfn - old_end_pfn;
>> +	if (new_filled_pages < old_absent_pages)
>> +		return;
> Let's just check that we don't add enough pages to cover the hole
>
> 	if (nr_new_pages < old_absent_pages)
> 		return;
>
> and if we do go to the slow path and walk the pageblocks.


I'd like to avoid of the slow path as much as possible. The check 'if 
(nr_new_pages < old_absent_pages)' is more strict if overlap happens. I 
am OK to simplify it if there is no overlap cases or to reduce the 
maintaining efforts.


Thanks & Regards,

Tianyou


>> +
>> +	set_zone_contiguous(zone);
>> +}
>> +

