Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E8A2C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B88C6B009D; Tue, 22 Sep 2026 04:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268B36B00A0; Tue, 22 Sep 2026 04:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3D56B00A4; Tue, 22 Sep 2026 04:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D99D06B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:25:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 710C2A041E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:25:40 +0000 (UTC)
X-FDA: 85240714440.17.0598CF7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf08.hostedemail.com (Postfix) with ESMTP id AB173160004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:25:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Hb4uDEBA;
	spf=pass (imf08.hostedemail.com: domain of yu.c.chen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yu.c.chen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790065537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8ScHMbw6S77Rn1lizMKbQpxfc902v8+PTmx9RRaLhI=;
	b=VZ013RrKQ+jTX1zSaEHXfbMkUHbjDoPTSjJ/ONzHeKZiHnnD8blF42fCo+tM2JpKoMiQm4
	KW43zGu4JSwML1fciQtjHoZG/hP0zx3gPKRDUsELCV0Sx+0RRwDwqMxcVwl4w3mApvJ3vS
	uzCyVaOGQgZ4FAyMhJ3VsOp0H6uPL8Y=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1790065537;
	b=hp7yznOyU8WMvfnQDTJJLp8TcCKDxkjEehFWKvYpei5lvSrqOV1pNw/v8Jr85LIAWxnmkd
	kCSctjz2LdVIi2/l0npJdhjUnwJawcZKOsDKk0wpxDkqoxvmcbUXx0es4/fa1B4yYsDA+A
	odZf0UdumH6lDop2YxrObgpPRfUPLJ4=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Hb4uDEBA;
	spf=pass (imf08.hostedemail.com: domain of yu.c.chen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yu.c.chen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790065536; x=1821601536;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h2T+E+11t/tjFul5DmT3kRHLCOvq9uuqXJ719hNohW4=;
  b=Hb4uDEBAFUkO3tszJTb/uOA/swBuDXzC2kVlpIxAZZDJ6kJCeAWxUGVk
   yXpHBAj+4NO5XpTN8lzF1/FjE8340qUZNK7j+jd5HFx+gpRQbnHlgD4LQ
   nmBspg0Z4Zm2VpgEG9yb2UKx0RRbBAceRHDUvwJmKU1QcHDnOkzayuxTe
   XnMCyIXZVMve8cQdkQZbMiFUPQNHCE8vP/E5PTwpKdPeWH4orOUdJDxwl
   A8na+LAwJYcW35y23875KCmxzlffhm+UofjpGswOk9zdH31i5SdZVOdbh
   Kkg4Za3KuQqRFg/5jTcreTf+sklQ2qwJr3mmEhqmMtubNblAJjEJ/tsD6
   A==;
X-CSE-ConnectionGUID: Zxo2W/H1TweVAIoICbKy1A==
X-CSE-MsgGUID: XOSi6MKeR1y1JI06WQCq4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="101996912"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="101996912"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 01:25:34 -0700
X-CSE-ConnectionGUID: eISDqyHLR/OgT/3KAoCGLg==
X-CSE-MsgGUID: BRfXq8yBRxq7Vm79q36Duw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="4340986"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 01:25:34 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 22 Sep 2026 01:25:33 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 22 Sep 2026 01:25:33 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.68)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 22 Sep 2026 01:25:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FurAxu2f9LsZewca5AqCfHEQajCD+hDX39U2j5SpvT3/iAjCn1CU9SCqv/I1rtwoxqiRVxJHk3NzjquNBdeTgUVz0As52qecsbmTVQZDnNRPOGaNKiW8h9Vpr7lQZ9r7Cs8QDhsUYSG5ila3vq0NREY7n0i3xB1oRnzESJ346mTgpOHRO29UjG+v8PQ69sxftsh2LD/QDo+n5hmMb6lMc6SEmNJyUXLEmqdH3eaa6E4z4H290mfPurYlQo0wrQ/U5TTxANgqDxR1wV1aURvu3GM+H+bpIxWWC7Cgw+RkrBBdfinoXVHI8FGW4rgzt5iNhox5PWWThpOfYna6u/WTSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8ScHMbw6S77Rn1lizMKbQpxfc902v8+PTmx9RRaLhI=;
 b=s2MJfwu57bLEm/5sEPmSlJw1Sp+R2VXVaK9B6YqEprjQr1z4ClgdeHouVf3q9NvHQaaB3hm9r5+PogpJoAgJ/yYbfLQaAnyLR88g0nPFUPaR+ShBOa1fA/qwRUveYZPbGaKYa5vGxnFZq4hBMIJ/T7NHrFr9dRQNOHk9MAMBkk55OslrN2UgTm/DwF1fD29ar8r4okyPyXHqruXQBR6ETII7nDbe9FEV1hl4qdgICrhQSRJgroHN46ITKzwpLWpaaZRZj0vtAdmDxkbEnkqbyKUIfcgsHME+NCn+ITzh/bSnVjJZesyuowvNULHtN7Cp7VXK9kQPHIQzbkPst9rLlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 PH0PR11MB9702.namprd11.prod.outlook.com (2603:10b6:510:396::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Tue, 22 Sep
 2026 08:25:31 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%3]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 08:25:31 +0000
Message-ID: <65ee9df8-2422-4d1a-80d6-41ac51979da1@intel.com>
Date: Tue, 22 Sep 2026 16:25:14 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] sched/cache: Keep nr_pref_llc_running in the
 runnable domain
To: Peter Zijlstra <peterz@infradead.org>, Tim Chen
	<tim.c.chen@linux.intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
	<dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall
	<bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin Schneider
	<vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook
	<kees@kernel.org>, Christian Brauner <brauner@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Shrikanth Hegde
	<sshegde@linux.ibm.com>, Qais Yousef <qyousef@layalina.io>, Aaron Lu
	<ziqianlu@bytedance.com>, Srikar Dronamraju <srikar@linux.ibm.com>, "Vineeth
 Remanan Pillai" <vineethr@linux.ibm.com>, Ricardo Neri-Calderon
	<ricardo.neri-calderon@linux.intel.com>, Lu Wang <wanglu.priv@gmail.com>,
	Hyunwoo Kim <imv4bel@gmail.com>, Zhan Xusheng <zhanxusheng@xiaomi.com>, "Zhan
 Xusheng" <zhanxusheng1024@gmail.com>, Yi Lai <yi1.lai@intel.com>, "Rafael J .
 Wysocki" <rafael.j.wysocki@intel.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Danilo Krummrich <dakr@kernel.org>, Zenghui Yu
	<zenghui.yu@linux.dev>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, Kayra Cizmeci <kayracizmeci@gmail.com>,
	<stable@kernel.org>
References: <cover.1790035273.git.tim.c.chen@linux.intel.com>
 <06af61afedac32e6477f57feb4d658f6c411c3af.1790035273.git.tim.c.chen@linux.intel.com>
 <20260922072205.GV4121339@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <20260922072205.GV4121339@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:196::21) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|PH0PR11MB9702:EE_
X-MS-Office365-Filtering-Correlation-Id: daeabf79-9f4f-4692-992a-08df188310c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: B70U1iVpAK8APeiYrjYl2ZwNhi92MCwgHkZI3EXBOSnjrZ+4zmho3zw7NlyH+lVxrRQiJxHdenkV/4lTl4OUX1P4FY/TeQY2Gf0yk6sWB+mSJoQGvCr4NHUZjMCpGgTxIbjOF6EmMZQdjSDAJXJdTR+Qq94qtR3mMn53E0JcFuWAMYTKtFSXoliYPQPkv6foL2GQp8SCNgQOXta3tQI1bR8/vYhGNWNA/qIXQqIqPyM2Se+dOcOEsalGlEO8jVEiIR0Cba6iAl/xW6Fli3ALug2FGgnmnJX5OSOV69yIEJyuc9Xsria8IhoVlJYSnjjEh0pqFY2SUmD9/vVVO4uIyV4zHkrFdi2em1OYhxCPIKzpsm1AYP2xCFcwTlmq4lI/A9/mGiRxG6Lni/1t/sKRDhxP1FMfPequUWdmWK9k4/TNBvQp2LpTjhyKCW66Ua4RU7lci5i7vByoGhWLC1lylyVNXceCiqzS6ebkUxhcApzJWH7gZOAw5pDd/1lJ5xtOlszddJjT1SePNHQZABH2BneUG6Rzwb4EklgITiRrcAn8t+Y9rwTXOea8NBZSxQlH0iu82TvxcdMrRhDbaBdwcmAcLdWkdak5EkyJLuyvq3MXXB6A3r3fM1gj0gph1aKEUWSLKP8zWjAWbzi64Fi56++rxXXE4DrBqgFguwRSDEE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXFZZmZEQkdHbmtsaUlEWDR6SlBvN3FDU2lCOUJyZ285YVVLcXNIbnljMGti?=
 =?utf-8?B?TnFQRStTcWFibTNNOG1uY3g3REFYbXVOMVJnN2V1ZEJlK2hORC9rWnpxemhr?=
 =?utf-8?B?S0ZLQTJPcms0S2FYMXdZL0Y0UjNxd2RITUlsdERmbUFlcWpkM0gvWEJPS2c3?=
 =?utf-8?B?RWdNNEY0TTU1d3A4bEtKUGRUajg0ZHZmWHBkY2RrQXZpWXhlVlF4ZHFvRTZa?=
 =?utf-8?B?RG5oRHoyYVkzaHdJZytYL3orcFk1ZlBWbmF4MVpEQVBNQzBsUHpVRzVoOUxx?=
 =?utf-8?B?dWZZN3ZISnRISlRRdVhHS2JiSDMzQTZkWkhhNWovR0gvSzZ5NUJidTRrVlgw?=
 =?utf-8?B?ckRqU1h4dG53cm93WU9Ja3VDUm5RYkNTZ3BZeXR0NXlmd3lVbVczWlJaNG1N?=
 =?utf-8?B?dDQra0NkRitQaktYMTVrSzNKZGhCTlQ4R3luTVRVSDVNd3FJSXQyS2pQSWNk?=
 =?utf-8?B?MThJam5PVTBaODVMVWg2MlFyVS83MDk2TXN1bm9NVU5IaWxqMG8vUDVGUExF?=
 =?utf-8?B?Ykd5WmRxZFBGMmV6SGtNY0Rha1ZWV0dUeWdodmdlK0tHNEV6ZGNZZmZCL0pN?=
 =?utf-8?B?endUeVh1Sk4vWVFBVXo5bXhoK3BVZkVYamR0TTNyTHluM1BucVRNbnpNYUpU?=
 =?utf-8?B?UDNEOXhmOUpkbXh4SUR1d0laTnlmd29pZDl3VWZWQ1dsVGpQUUlpQWhjN25Z?=
 =?utf-8?B?L29saFNqZGtFSjJKcjAvQjM3SnJ6TmovNnBkTmJXQ0ZwS1JjOW83QVhrYmZy?=
 =?utf-8?B?R3MrVnRaSDV5ajhvTXVUR3ZPb2JNSmtiUDdKVzJwRkVLMXJZenE4UFg0dFUw?=
 =?utf-8?B?WU1BLzhWb3JSVU53RTU1eGo5R2x0cTBuY1UyK2RCczRMRDlBYW90OFhnU2ZM?=
 =?utf-8?B?cUVxaXdVQWdTVG8wTWNsZVFVbmNSN29PQ3dYbkwvclQ2ZGVDNEMvVnVwWnVJ?=
 =?utf-8?B?eGJFbmxLRVdvNkxpNHlCdE5sVExGNXg0VTZSK2t1R1U2bVFZQ0dwcHZqc0FZ?=
 =?utf-8?B?UTJXRURhbVpvb0t0dFNuWnh3c0ZhNDBxNGFUTjBIOEZDRDJPRlVOeS90LzhJ?=
 =?utf-8?B?b3FvZkNHV2sxY0tmQXFrd3hON1Rjayt6b3Q3UWFNWkt2OHRVVzh6RjhqZXlZ?=
 =?utf-8?B?d0lnNE15MTNFRHVXdTFYYmUyK0NhWlIrMXMyNzNUbHRmZGRTWHRyZ3B5bThC?=
 =?utf-8?B?NHFOaXZNZVZyRHBtZ1ZWdm1EMVBWWmFWM09ndkdxeEwzWjNMUU5NWXp6VlB1?=
 =?utf-8?B?Ti9YMURzNFl2YWZXTkErU1RhU0hla3NraFRuVlY5cWlMb0xxZmh2QmM0VG9S?=
 =?utf-8?B?TTBQM3kwMEkxRWFDaUk4Yk9WZGp4VjZOUjB1a0FrSWNvMzN2ano3SHF3MXNB?=
 =?utf-8?B?SWN0ODlDdGlzSkp0akVjQU1RcUxUZ21wRU1FMFoySks0dnhMb1gvM3FvTUJQ?=
 =?utf-8?B?Y0JWUnNZSUJXS0prZThqS2JlcEhmZmpiRzFkRjY5OUNWV0pQQkMwdHgzdmdL?=
 =?utf-8?B?M3pWV3JzY29RUGRFeDNBV0JibnJpQWZnRkpCL1VZS3dxOUVVZ1VudzRuTEFq?=
 =?utf-8?B?Z2MzRFlnZWc5R09GTERPYUdhWUhYdVVuaUlKWHFQNjNsbnJVYlJOZmhXbEI3?=
 =?utf-8?B?R0JyUEYvc2lBSlBHcS9JK2Znam41SUViVUdOL0g0YnROODgvNkkvRDEvTnZs?=
 =?utf-8?B?WWhTb0VHVzJVdnAxZzNtK2FtVEw4N0Y0WHo4b3pwNUxBYjJ0anAxdHR5S3RP?=
 =?utf-8?B?R3F3bENhODl0eGdtWlh5NHp1WS9xNms0Z3dUQ3dibTY2Z1oyRTVwT1lDUWxy?=
 =?utf-8?B?M1Q0UytRaVZXdEQ3RDRIY2dUa1J1WVpnUDdaREFwTE9hd1Nmc0FOS09Ccnk4?=
 =?utf-8?B?RlJEQS9Samg2YU9aU25rcVcvVVljbU9JRWFuaUhNVkN4Sk5wUW41ZjhtN2gr?=
 =?utf-8?B?WVdSRmVXR3lnK0NwYjNRRkVWSFk0V3FUdDExNkVvc3d4L0txY09SQThFTjZX?=
 =?utf-8?B?VnY4bi93WnVpSXNhZjVNQkxMSkplSlVQSXdDY2o3UXgySlltd3FTYzJldCtD?=
 =?utf-8?B?K25Ycy9TNXIxT3lwOHJRK0VQZGtFNlZzNFRhVmFSaXRDbm02VjlhbDI2VkhS?=
 =?utf-8?B?K091L0F4Ymhxd1hqU2VmaUJ5ZTQ0clJuNlViNzl4TlM2dkhyVjQ4WG5OVGNQ?=
 =?utf-8?B?QmxocDlaUEJ6ODNXUlJOTXVHNC9kOXpNQmpyOWNFNnZoSExzalhXbXN2MEsr?=
 =?utf-8?B?SDlYaUFVenFPYksveXRRL3U3dGhDOTU0Ym01a1EzRG0wSlZpTk5YZjUyMHl3?=
 =?utf-8?B?dGZyWFNUQlpsVitnQ1VKMERQejJOQzVTaW5HaldGU1lkS2dLK0ZCZz09?=
X-Exchange-RoutingPolicyChecked: SqZrtGj/gIgghBdIjFbFmY4wVR3/gRa9aLwRrfvGbXCEfv4hD/J3Y8HoQCcOQiZX1dL7m4Atq5U13eszXWBhba0QpIxxcNDYpDCKFo5OuNrSiwuSAx/zfKuRSlX/t8gaLdNZnxddyVrNwFso95dIjYo2FDFfBl5HWLFXHnxXlUImtABmrYnYLhIB2Jg+Zzp75olhYU0lq0ojDLOYPwDZoxOlPOVxL7vAImRflWSSrCmSRBsLxCT75wZyoxGo7fUoXJrm1Ha2NowuCZUPp0qxKf1RzIolNBrYmERCD7oG3KEq3I2m8Yoq8YzPdDB1VVHf0X4r6kL7xFz5Zm1bPk3MLA==
X-MS-Exchange-CrossTenant-Network-Message-Id: daeabf79-9f4f-4692-992a-08df188310c0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 08:25:31.4907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+4PoaYV4FTsfRi/+vCbOJ6U9kkxjgfUj8Mx19ZcyqOiU1YD3TrMif6GTuxj1ebBhOfrzDDvSpRhH4zn+l8b+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB9702
X-OriginatorOrg: intel.com
X-Stat-Signature: 7tgwqnstfk6wgyx8ssnmjfg9m5sjwnxn
X-Rspam-User: 
X-Rspamd-Queue-Id: AB173160004
X-Rspamd-Server: rspam03
X-HE-Tag: 1790065535-385560
X-HE-Meta: U2FsdGVkX1/3+r4E276ihjXR/x1QIYxIXf0XpxEpuaXBYCkAsQ8G98+NCcsQJs6A9DkHJnn5TQNIIup7u+Hr2JYybXDDcZU1rLMgVmzdOQ8CCYAWr0YCHdypExHyQKhB4MUS+U7NhlDQzSafRKLqZ9u1FaC4rjE0VXvwF7203aGDatXeemvMgewA+XkmHdq6fzm4yzJzf+U80ZIttETbsCWKnZrZt+RUA+m3DoHv3uZMkJeHL6hFY1mCEZVLRYUD1ERh3kBkKOFjh+KOKsNeMdFSlIQjDw6ozDpEsYfaK8outlHGF9ez+UTVOGBF6eoOaORy+LMLL1lFVDnozV756VLCa5ROlCRoVbzFqLuYVFyMsAFz3029WB92ViOlSek2T71cnPI+q628NpPKx1/fXEAWfxSDJv3Eknfetn6ftG8C/Y7DzYO09y9Y+HkNg5G8ywHj4UEYwnGkS5FgTLeJ2NB8HFAZ7Al6ejhAN4LO5nWZjwAY6dApdJCAb3cO2hqoAY7kp8f3W+SAOTe+KzwFYTObl9MTRBJy2xsv+Xl6UtsQUb/WWHwfmfsBnlH9AzsqOE/zXDLO/zsoDThfSOkwLTnhtCZQeNtIYErY2GeGGQapBdlL4fDFIRG9P3adX0OxtAh/mAaiA0tUHINZsXLN1BNYlgIQIZQBpq8o6q42mjLtoWR+Xop8CpDamlj02xv7D9Jj1cGplpX26rQEdlFo/NMGY87cGPioyVhHq2IJsvHpZ1Z+ojBDt/6AfTKV5KacL3a0PYn5dz1swu3psa99wndXA2S3j4xxCaLHKXnd+fbJmYFylCPPs5w1kLFz5YRKUz/tGvaRYLTHsjLFzlTcZXqpHlyl082H9sn5cH/7++GFVVCw5XIIO2OZJdJ+not+oUrllrh+eu6+kZzu3nA+tuNy8K/eXHdDRDN1VskVKzw8zAWYc3J52lPWv8BL8m6zu2IwkeoFQWACCruYDAk
 gjKQZgqn
 N4uWlUx+XqwE6VdeuBd/7TFwC8T39+L32L+eAw+lKu2K8p9pUWcwdnJ6k8Pmgch9o9Hm6rdlVkxqYW4cRSKVXkQi09lqA8tQIP/ES9+i2FPg2UPBH/4iFxyxy5eEL2+EsjBI2CiPzWYWNpsS403wrJoCYEphT8poPRlqMSdhWHwyvy0p4r2zxM1jTsrk4nEUTxrsfq37rQcNvxHF/9nZ+XlfCMMvZaStXpsCyWcIPPaBV3hYyaHYY4bheCZzwA8rr5MT6lVVBqnM55zxGtj2kiPrLWRZv4HFoGvyNDcc+st1EZvCD5LhQ/XjHaL5xCpL2DyzHRz2Iu6AKEdJMDmTSrhYYYmgmRnmLGjtVVqgqIKa7S04nW8lnXOlIf7ThSB+dtFHobp5Dn3zfmrZ0LU+8H28+ZYZ+Fpk98pnBWpWpLWLSAVq4z4hsQU02cEAdZPjf32prrSnqj+xNay4BJNGOWURIkqOCmFYw7Y9i9y35d7Hevrna8jBSYddyMelcHT4XB7mdgeAG737mbiKVBsjtU5IKJZCC8CSQbtvrEMR2YkXVp+38jVelbiIxNzIkfchhG4GVSjutVlXaxNt8An3C5kzXq+wJdow4V4gI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

On 9/22/2026 3:22 PM, Peter Zijlstra wrote:
> On Mon, Sep 21, 2026 at 05:37:22PM -0700, Tim Chen wrote:
>> @@ -6395,15 +6429,27 @@ static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
>>   
>>   static void set_delayed(struct sched_entity *se)
>>   {
>> -	se->sched_delayed = 1;
>> -
>>   	/*
>>   	 * Delayed se of cfs_rq have no tasks queued on them.
>>   	 * Do not adjust h_nr_runnable since __dequeue_task()
>>   	 * will account it for blocked tasks.
>> +	 *
>> +	 * This check can be removed because when flat pick
>> +	 * patches get merged as only task can get delayed,
>> +	 * same for clear_delayed().
>>   	 */
>> -	if (!entity_is_task(se))
>> +	if (!entity_is_task(se)) {
>> +		se->sched_delayed = 1;
>>   		return;
>> +	}
> 
> This is dead code. In Linus' tree, where this will be applied, this can
> never happen. A possible backport of this fix however will need to take
> care.
> 

Would you prefer that we create a separate patch to remove entity_is_task()
for Linus's tree (so that the current patch can be backported, since 
cache-aware
scheduling was merged before flat task-pickup)?

thanks,
Chenyu


