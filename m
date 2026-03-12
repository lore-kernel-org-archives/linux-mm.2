Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E80106ACD1
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 23:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 192306B0005; Thu, 12 Mar 2026 19:40:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166FE6B0088; Thu, 12 Mar 2026 19:40:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E9D6B0089; Thu, 12 Mar 2026 19:40:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5D2C6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:40:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D4E11A0498
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:40:58 +0000 (UTC)
X-FDA: 84539033796.25.E77A29E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf13.hostedemail.com (Postfix) with ESMTP id 03A8C2000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:40:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NNrLUkZa;
	spf=pass (imf13.hostedemail.com: domain of dan.j.williams@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773358855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AfsMvo326MrfYPU/19i7dSkNU/3mYxGHe87rVeeMve0=;
	b=qrp6PBSJ82FNFkJ8b6jd1EWthrETowgrvu5P8h6RStOWvivBu5s0vLUweF0IyPiOUivCCv
	syU5CiQc7gX8K1HlGSp9T07Ll7Me6kZwOk54dZNvOXWQuEgVCyLIRYYPVVL/duCN1d9QfV
	u6U/Bg4jhF8T6kb7p+umnG4EYyF3bks=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773358855; a=rsa-sha256;
	cv=fail;
	b=JGzNjFzXSeP+Ds+9BFvkk9svzEx81eIU/809XgWuvJxktSeilf0xvaXYgUrchHFBMYU4bU
	shEckxTJtGKhBmwSoVSf4fW+4Xd046ORNd/1uniO2kwI25sQ+yWnY+o41C/ntMxyJDG/Xq
	9YHXiLvFHI7fYNkmWp0EQ5Nx7cqSmiw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NNrLUkZa;
	spf=pass (imf13.hostedemail.com: domain of dan.j.williams@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773358854; x=1804894854;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=AfsMvo326MrfYPU/19i7dSkNU/3mYxGHe87rVeeMve0=;
  b=NNrLUkZaC/9Dht4Qc44uUjyLGlI2ApVhUiINN+KGeir9RpzQHTDn52jS
   DSWhJxqMweWGEG/hQVNRViClaYW2uEmoBsX1KUwjy6kRiewR5qJyMQaRz
   TSuTNQBHvXaC4PZGJ8qCJ9iHOp5uCgwDX5YRRcGt9O44IJnyP3+HoCqzE
   KelwiaP7nHnRymNmXgFzWjPCnlokIf38Q+5GtKLQyu2au0bTCIoJ85o1C
   l4Ajlx/y0oOSKAneJxCLNxvTHWC9xS1DgN9IvT9XfYAn9RWb45C949xAq
   oy6GZ80voEqPklcrE17MYWAcjATtvupB0w8xqqhWgP8Mrqa9oMFbKCaLS
   A==;
X-CSE-ConnectionGUID: SwvkhBD3SsyWKP9oaP6d6Q==
X-CSE-MsgGUID: FJUC2JunSa2ItXf2jRfsFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11727"; a="74347106"
X-IronPort-AV: E=Sophos;i="6.23,117,1770624000"; 
   d="scan'208";a="74347106"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2026 16:40:52 -0700
X-CSE-ConnectionGUID: ooLXGFjgSeuKM+VWcYMyBw==
X-CSE-MsgGUID: y6Y2CMT8T0eceQAOJqdFoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,117,1770624000"; 
   d="scan'208";a="220934453"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2026 16:40:52 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 12 Mar 2026 16:40:51 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 12 Mar 2026 16:40:51 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.70)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 12 Mar 2026 16:40:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RC7Xx6mh7/mkqVinxOY2xVv2agCT9vmd2VDe9qMg0mNDnE4H4mcEkmHfUMEJIRz6CkeJ26B1R65W+XF3Rsi4iBL48+Hf0G3HJTcMY+mfs2KCgt1znNqlxeio5XpMtKZc5F8PIgNwxw8nM3o7cjjAGG+xytlgaAK4fxHRreYCoE3d941S9wyOTLzSZqKCDICNHIsduKeXrT1l+2ESngm5iBFIHq4D0VHkwuABJsXt5FAytdRw+iek85pRWdQuMtzD2UwRbLaah+RFWuj717TlXCbwaBUYEwdDwIEw/x/N8N4HzERM90CsbFDuWvOFqHe0DxDzE3xBwF71MvatTsdL1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfsMvo326MrfYPU/19i7dSkNU/3mYxGHe87rVeeMve0=;
 b=MWAaPHsrzAmClxbeHn8TFcn5SiUnpCmtbCzA+6drtNIeIrJex0FzuLMPWXi1qtE7ly3N2f+v9pX8Ov8mjtZ653Zkv29Bcx+HqkFCBm5JsjRSrlJ1Tvi322v8dRkXqiMVvUA6P/afCDQx1tPp9Vri5cYU4LVUa/BG3xYRaovX+hX1ytVmobpBQh1zGzyMbqSqRS0J1/SaQSZ5GeMn7IHaQ52LHAGGOpx2t6KunFN7xM1Bn26eqP6RXUX87uEuEDBCkKRIZpLQwMgR7lMhc+GI+5dsytmg4tsqMG4lLT2c5PcXI3dAYUOQ8X3rZr7XdKpkQfgLR1EpEgt1BqzXyCLRAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA3PR11MB9085.namprd11.prod.outlook.com (2603:10b6:208:574::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Thu, 12 Mar
 2026 23:40:47 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9723.004; Thu, 12 Mar 2026
 23:40:46 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Mar 2026 16:40:45 -0700
To: Peter Zijlstra <peterz@infradead.org>, Dmitry Ilvokhin <d@ilvokhin.com>,
	<dan.j.williams@intel.com>
CC: Vlastimil Babka <vbabka@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Brendan
 Jackman" <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
	<ziy@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<kernel-team@meta.com>
Message-ID: <69b34efd5bd1a_213210038@dwillia2-mobl4.notmuch>
In-Reply-To: <20260309164516.GE606826@noisy.programming.kicks-ass.net>
References: <cover.1772811429.git.d@ilvokhin.com>
 <cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
 <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
 <20260306130052.7da8eab3@gandalf.local.home>
 <ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
 <20260307131641.GX606826@noisy.programming.kicks-ass.net>
 <aawxpQDPpqX2k5z8@shell.ilvokhin.com>
 <20260309164516.GE606826@noisy.programming.kicks-ass.net>
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::14) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA3PR11MB9085:EE_
X-MS-Office365-Filtering-Correlation-Id: e20ffcb6-8136-41bf-077b-08de8090c8e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: osePFuY8+TueWw5yi3Q9DvaoaArEKQ66Sy1aSzwX9zh5cwvVxeLZGIvzv1IfpUpb/2uNpUsOqIU4Y3O0fTNxwymB0mcC2wQDNDIMbkov8APeXWjLXM3493cvcYSr+MHg1xqWiDDC+x5pjm9qfLVGjz6Lawb+CTTJ3UhNKqMRmNPw8CxpLE4aI7PgCbTnMtlZYRaD8OVCGCzhKIvyDe50N019Rciz4yIIkIN9tmU14KfHXItzvrPVsBSihS6Z2PoAp/ujOQdqx1VIlCnrhlVGgI1PNQ7sE9ZwCU48nCWCfsbErhUDNfv0WnQylZxueh+1vvooCnAe6pM06GvCr8vd/AT+u783EgdY22YUwLUQ1nHk7f6C6Npq1gds8kfhBuwEGnqvjWrjoDdWigxllbuwgsAL11ahya5F/+h5w8LpQylGdw8UVN575rm2RRNwlJa6qKoY+nAhEJNXaYD3pg3nF1dpuXVHX4MJ2cPvK4vCKPtHk7OMVRKYAc7kR1BrPPw+AoYTSGN8s3w74D8KTUu4W3miV6mJlp4ntFfjbLIqCgWE0Wg/J5ZzzArU0FUcu6/KVH4AwGW1Fwp06ZbFtXLphUFSvsU0fFKUCFWQuzfCZv61VZNmrpfpu3CHhirqr3WaKQ0fEK8EHa9i7ivoHAvsIkW9kNvEL8iU+zyr/yXfbf8gJcDR48/Q82McKSaKNyR6gU9F66doBfSDWbdr6pztud81KFzv5fJGnDVB5MWKWK8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b25wT3dFeHFIcVFHdjJzdExRTlVjVlAzaVNGQS9oS050VzE0ZVhnZHAzNlRt?=
 =?utf-8?B?Z2dKUm0rUU1ha2tKVEZWMGwvdEZjNnAyOHU1ZTk0VmRFUVZ1NlZsblRxZHdW?=
 =?utf-8?B?OWxpVUprdFZjUWtac3F3bWZCOEhuYjRXTTNYZ1FtRTkxZE9zK0NPRUZ4RHMw?=
 =?utf-8?B?SzZnWlFvcm9GZlE4M3ovdUc3OGE0TmtFUmhWUHQ4LzVFU3pCYldrZ2lnMVlr?=
 =?utf-8?B?eFdhRDhBenc2RzVyelptcy9pUEhSejdLU1BkRkh1MzhCeGZkN2dxclJIOXB4?=
 =?utf-8?B?MERpYkxGd2NNRWNWTzhiU05TTXNmM3JFdHNBalowVGdrNFhTQjIwY01kVXcv?=
 =?utf-8?B?MUVPUXd5QjFmWG9Dbk9rckRhMEk3MUY5TnhpeFBUV1lsYkhHY09JaVlHbXR2?=
 =?utf-8?B?Q21NNk5hR3J1UDNWNUFOVDh0Nkg1bXRGQ0lMZXdZdkJMVjliOWg2b3dIdThT?=
 =?utf-8?B?NTdJaU5wY0dPQ3dzL01MSCtGZHk5a1Vnb3JTN3RybEJJR09NcFhBc29MeTh3?=
 =?utf-8?B?aERxTTRQbkFyc3ZaV3hzV0NLcmZnOG80czcxOHpKR0ZYb084eTJKMEIvSlhq?=
 =?utf-8?B?c09iUEhyM29DSVd3K0x0QnJRRW1SSEYybG9Bb2lIVW9wek1kaXdEWldjYmtT?=
 =?utf-8?B?SnZJbDhVMzlEOTFxK3JSNmw3bmw0d3dGZWJJQ3I3TGN6TldSNDJLOGJDNnhs?=
 =?utf-8?B?MSszNnAwWDRSTXBsMXBXakMwNFlTZTk5K0dYTmN2bmQzK3BYd2I5U1JSZFVm?=
 =?utf-8?B?T0g5Mk9IZmxsNUdGQ0E0MzhYemNOZzJ6UlNHVjhneXdvQ1RDdW1LcUhGb0dx?=
 =?utf-8?B?azgzV3J6K1lrSUR0YmNLcTBEZEpEVDJ2VWxXeEovK0pIUng3WkgyY0FmTVV4?=
 =?utf-8?B?VGg5ZTBsSG5mWFRzalZ0a2M2QXpkdzNoS3Z5NXNhaWNmQU1uMk1HZHNtajRj?=
 =?utf-8?B?WEh1L2tmL09IbXVtc0RXckQzMWNLT2FPUzVxR0JRN3dEangxUldGK1FtK285?=
 =?utf-8?B?RHlBeWhBZmVPLzBjSnNmSzUxVnl3Zk5peW5mUmdEQmR5ZVMvTDhQci9FN2Zr?=
 =?utf-8?B?RlNienlWcy93aDV6K0NybjNBMFVUUjBvcm9iME8yQnZDa1hsZ3EvQytaUkxM?=
 =?utf-8?B?MDNRUWw5UUJ5TXBONVEzN1FYY2dBYlZFM0htNm5IZ0FPb3VZT2p3a3c0WExn?=
 =?utf-8?B?NmJIVG9tZFkxQmppMG9Hc01yTXBSOG9DbXlRMStsOWJHcXcyT0JoaVJBVDlN?=
 =?utf-8?B?VE50amJ6SWJ6RFdIV3dRVDFZNG1lejZjYkJyMysxRU0zR2lJeVhKU09oQ0xW?=
 =?utf-8?B?M0RicTNlQUYvYmRFN3VPRC9hZzNVc09zOVpYNmM3QVVtd2ltQ2doUU9sNlRq?=
 =?utf-8?B?STVIK0IzbnNSUFM2RDN3SEhpbml0MjNyT1BuN2Q5NjZ1VEZRRFBydVg5UTR2?=
 =?utf-8?B?LzFRRzA4cktoT3Q4U1ZmbG1MVjJxREd0bVJNRlhhMGkvY3BiSHEwZGxZNEI3?=
 =?utf-8?B?Tzc3aXQwVXo0ZDFDZ2pBTms5akpIMm43SWR2MURwMGZSOURyRHlhcjkyUXZz?=
 =?utf-8?B?eEpBUy81MlRXUktnSGVVU05zWHVBdGZUaU1YNTZYYjFTNlZuNHlEdFJUR2RR?=
 =?utf-8?B?T2RnaXk5UVM5WWlzNktqN2w4K2w2MjJsUE9wMk1jYXJ5NWxQS2NqTWhrN2sr?=
 =?utf-8?B?cU1LQnJ2V2psa0VwUGZaczNQRTFCMEw3WjNDZk9xTkZXY2tiOTNNT2ZQV0Zv?=
 =?utf-8?B?cFhrSUN3Wk4xR0tydzM3RzcyOEtaVkFPa2lWdVArWS9PY3VkaFhMd2JOd2Z0?=
 =?utf-8?B?OVpVVTFYQ2VxbmswQXJmMlFtdjlIY0lSak5nbUd3YVVNb0g0ekovandkdmIv?=
 =?utf-8?B?QS92LzBENis0MTdpaTlzNWw3VlpVeXN5dFBHVXdJL2RoNytERytuMFU0TjJP?=
 =?utf-8?B?Z09iYzRyS2tBcG5IYS9MMyt3WGtwUERnL2lBQ3ZkQ3FsWXMwZzI3MXFTN0Jh?=
 =?utf-8?B?SzNIU0VyWjdmUVlWS2VhVWMrYUZ2Z2NsOTM3N0VlcDhUeEpndml5ai9NSTFQ?=
 =?utf-8?B?bDVuTjhtWnpSWnViVUxKZVZ5L3RFMGpLOFh0Qk13NW0yd3BjMHFlTVprS1hm?=
 =?utf-8?B?MWJINVJaL0R6U081RThjaUJlbStTcTNJV0pZdlI0cUM5Nys2UVZheG5nS1V5?=
 =?utf-8?B?YWV6WTA0aFk3ek5HVlRXQnY4K2YyaVJjU1VOMjVOMnhNdUpGTmhXY0dWeEVD?=
 =?utf-8?B?aFNaVjR6OGxKZnNEbHdaZWMxcXB1YkZjYVRjT21zbzBONGVVc09ramd0KzZx?=
 =?utf-8?B?d1dhTXJaZ1lacWhhZzlEVnFaZTUzYnhkNjBGMVlzQTd1UDQ5ditnS05uY0JX?=
 =?utf-8?Q?Zaec+y/D7wAL+/nE=3D?=
X-Exchange-RoutingPolicyChecked: g780Tj2L/ogCr2O5uDLllFw4PmDyl/GNc3/Vjp/HUSxy2Irlm594+UUPVEPOLfKaWJqq2XirGkU8p3vGCQWDy4jTfwAslObf7AS9xs6gq6iLCS6odkKzgdZWiN7OnY8SOWMPE9EBzifuEtQ+XYfXoWnhzSiyB1zZAdBLMBSg+QNU7TV8vCMQAkUYoQlihCVwn3+jFIaCwlJ/eqGO1/0ugIIbLmQZQRW7jmgxncmt1PcZO/V0a+gKoeja63+G/FbHYmeGGIrID6ijZJUAGRzyBkMLPRvGWmY1iiy+ka0ApAm1YethFRmIcCVH5ptdqy4w+O9lMh1VXTdg5MB5JiRftA==
X-MS-Exchange-CrossTenant-Network-Message-Id: e20ffcb6-8136-41bf-077b-08de8090c8e8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 23:40:46.8940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DTkPkEej9nVeTRlBRw15gQ0FCmzvda79OjIUrSUhhECQ9TYiWCsFrKG6Dnwa4XrYbaoOXCokQiPRbPBnjZLLkuvLGL7uHq2c7kYVYHwkd+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9085
X-OriginatorOrg: intel.com
X-Stat-Signature: xgjopjckmiahze4pwjzzim5ysb1qxkwe
X-Rspam-User: 
X-Rspamd-Queue-Id: 03A8C2000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1773358853-455368
X-HE-Meta: U2FsdGVkX1/hNAHtaj0/UuOJ3P9mS3nfTQPJEubO3LwxY5WSS6V/ViF3OxGBFTb5MeUG1Abi3VY/88rP26VvWQkCgR7geNbdnniGpalYOe2LyDhjO3IBBIR8vnbgn1DeT7xpayK2IjzwRb3jVXs53veXrvV0zV+NzH2y32S6IbopJ76MyjhCbpo5vVU/JDpI9A+X4ThkGjzOyY5ZgnCjwELFbhAGwQiCeoX6EUZIDeofuIWbNu63+iG1O9rXyZsiV9rZhy4iC+zhU8g8HX6KeXfnRI7UlD4Oyw3qF+iGUHvQKjMFvTOdIlX+vxcx60Y7RwY8AeOXJWW8cI6x9kV5RR4MWEW5VLIQQKBoXPXNFjvFu0JO4lc1dACJLAYXtYMiMcYqTAG3wddrhy6G/mJExpd62h0s4s4aQijTTlG6eYzFkeKr48OyP8MYdVEsBAQXM75LPw5vbM49MLBRLJZ1TmUrTWjJDBRBi5g0wvWwhTO6I6X2cUVRJfYju5HjzwMK2RLH+yv5znsWXabrCpR0s4gTas8fLGj9/cWc9n/VCKgDdtQTHBppglDyAGQ6gm/ade90y3tJS+AX1sU4ujfGvF0sm+82EHBqNtaY2QaVWxXgDsSTOXmzby+bkAaDDdXqUxRiXu5kXpMzZEAOkbPKkpbjR3mQhobCNq4PA5ARJGcRuNbOMlWC4GN1nN1R6zJuU7NaIh38zMjZRTdhbEdDk6fq7G5qBkenCZ6sm0kvy9VhspS2IdsA++Z1ajKHAfKSMeFFjPyHaPHzdQruW+dTU7J/ymJT+q5xJiKrMP7Wa9UP1eZYO8VUXfAGo7w1kQFUW2NP9dUiVguU7WC3l3uzf91vxG3+/AOzwmsYSXi9UE4hiy6LpwTzfeQ0zh0EoKg906tjx2ha9fakTDldHaIv9TbhYlnkF/235Ti6f2IuLOf/mSFImUes/crK2wWKced4NbzTXyz7OlTmFzW96v6
 trJQPrXH
 OqDURXCOlp2uY5DgkvcKQejakfAJpzxZ//hUc2jxK7qGDrNedXSMGXyXWgohkXJdDH28IQ8qBINLs3dU2tSaDLo1Kjrgp6g65Fo12wJw20K7I6TbH756WrQykazxP2CFt6v4Ek/4cYc2w4R913LAqRE3QE8JevMfeDP5tI8k/zAOAYpttaiZlfFbmxd7QMoemNqofOnPH56/2/D1Lg/q8xSS89NLH1UCOSC22v+j1F97cfPbTa8ceuM/b/mWGwVeAgyiwzWDGjEF6EteJsgk2hJ87cqzpBsN3xz0/et/9WgggFYfg3SBbsuRU1qRWInq79NY1viPWfGaPpETY7vy2evCke2vF/J20dDqxwvLjzAoV7tHCXjjjUpVa7Wb4tA/4EtEoy5D7lqrFrBrVDsyR891xqrRKvemU0Binn/mgw2qAQFIgHDmAnFVRbq6rJcTzOgoA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Peter Zijlstra wrote:
[..]
> However, looking at things again, I think we can get rid of that
> unconditional __GUARD_IS_ERR(), something like the below, Dan?

I think it makes sense, do not make everyone pay the cost of
__GUARD_IS_ERR() at least until a better __GUARD_IS_ERR() comes along.

I gave the below a run through the CXL subsystem tests which uses
conditional guards quite a bit. Worked fine, and looks good to me.

So feel free to add a "tested by" from me. Not putting the actual tag
here so that b4 does not slurp a tag for the wrong patchset.

> ---
> --- a/include/linux/cleanup.h
> +++ b/include/linux/cleanup.h
[..]

