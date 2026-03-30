Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9272FF495E
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 13:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4306B008C; Mon, 30 Mar 2026 09:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09BC86B0095; Mon, 30 Mar 2026 09:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5EE6B0096; Mon, 30 Mar 2026 09:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D30256B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:34:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A4F8A8C118
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:34:47 +0000 (UTC)
X-FDA: 84602824614.09.0C3252F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6CC05140007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:34:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OgkuHowJ;
	spf=pass (imf09.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774877684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RCIMAoWRH0lZG10GYRhEKFe1d0c7UC5sYbzZGEgrEfA=;
	b=JubEUptMbhrooEa+JhBEKhvRv4j4ZlFnXlBNbiMlbiaU6QvpbpTV64mIszBKmDMKNt7ovB
	RjM/PZxwLOENzEsre4PX6CoxMhn+1YnlazSenJHgrwNAB0EACgzkPzLA5j6g07Y68xFHBt
	SryxOFBrh9NjW6kNl3cTpj8hpOy+ZRc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OgkuHowJ;
	spf=pass (imf09.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774877684; a=rsa-sha256;
	cv=fail;
	b=yrUTlXLl1CCwEfqo3Yw5T7MFWvKvZic5Tj0moyolZDDlaCqRO956dnUN15gLL4yKknG6lX
	vXtgDqj7kGt9ydBXYL3pE+K4kgGOQR7YMayRKpAyNPJXTQmYRWAn6erronf+hbTk8JwU7w
	+BbG84P/rWos1PeJBM3aixFkK4BXk/Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774877683; x=1806413683;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=QO9Dx8jXyll64ycqpuZC17GQwGyKqlo6LPhFDbshBhs=;
  b=OgkuHowJaq22ikCpqYq00vwUMsFtXvRN/AjpNv13I0HJ1X3aDDvksJpB
   r+x/kJYMpam4iPtMpNmTq7bBsFu8FOrR1h+4Xrtbivbw0Ojoug9JocFBr
   uXxeeIL/vXXltw7uuxBWIPrlYu+7dI9CUppvI4zu0KUSpjJZzTVLjKSQw
   fAlzQGWJ2wx8tcDVhDIfz4C2j7BAKeJa/+QKjnjqfXO8sKl7HVfyV08//
   N9RlGVxm0xSQVHLGNavziNj5qNBwTxEAFEb14BND9nrM9FcH4kkbi7HFl
   3ShWCJCqIKhibL0rGOHV684OHIyO/NKKJtvtx4uN2YAUMn3MSrSwQSUqm
   A==;
X-CSE-ConnectionGUID: yV/t0fvVRIa6trnfTUuYcQ==
X-CSE-MsgGUID: KsYpTYUoQC6ZigTBjRKCXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11743"; a="75047301"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="75047301"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 06:34:38 -0700
X-CSE-ConnectionGUID: ORwzZ5b1SxWeSAhOfNGLUg==
X-CSE-MsgGUID: pgEsgHXQQ9CVuOM33XjPLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="225945768"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 06:34:23 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 06:34:21 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 30 Mar 2026 06:34:21 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.28) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 06:34:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nh2cXnZiPWLDdww3Tz/xSTvLZj3e8iw72rMlXmp4sL2ZBwbFhLrdzINdkHq0J7Er+Lpo9GPcGATSm/DwWghGYn74rpCrqM4O1zWoOBtRYcb7boBN28swDewJMjSc3Yn0Ul4lvbvQTs6+pwEq6GY3vFNq8PePlFo3xooOpxMBor13gELWUAbGoK8dgPv4egppRcCAkCMo0iBMO5CBSAHhPyP6n3UqZP4vDTyOyK12nV6ORq2eUHLcYQEd6JX9DHljo8NOxVHNrpFkrXLzekdhPgBqNKOm4FK7xAQlZw1ZKxDN+qs4tG3sGgnaYRdiqkQNCjARxyf7hg2MA5LVfCvnyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RCIMAoWRH0lZG10GYRhEKFe1d0c7UC5sYbzZGEgrEfA=;
 b=FB4YORwpGxV0DJAz7RVrPJ9KYiizh5MjdkOIxHWBIGBfpQTwLPcfuyDpNUrL1560FVVrvQAMacZADEIDFZmk9hLxvW3VIGxdThQVonBlKgjpZd8l9ZuZVJMYWvjGw/ix9DHsgELl669rzzqZQErExRN2hCSkItl2DMSJcD+8YpQbmq0HrypOy8cyKDAfSkLt67rkdBQmgS2QUFn4vlsAzBPjlHVj/VwGH8yqp0F5wPlXDhrDbMrofhuCy7eIpF3IjE9n5AZDmS3lwxBTP+y2vaLMsL/rSVTwvEKEGjDDaywOVuyK4o/2ZM/RI1eUKFJvZ2eXxCgsmjoBdn0vM31sbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by SN7PR11MB8110.namprd11.prod.outlook.com (2603:10b6:806:2e1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.12; Mon, 30 Mar
 2026 13:34:03 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9769.006; Mon, 30 Mar 2026
 13:34:03 +0000
Date: Mon, 30 Mar 2026 21:33:51 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Chris Down
	<chris@chrisdown.name>, David Hildenbrand <david@kernel.org>, Liam Howlett
	<liam.howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, Matthew Wilcox
	<willy@infradead.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
	<rppt@kernel.org>, Peter Xu <peterx@redhat.com>, Shuah Khan
	<shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
	<vbabka@kernel.org>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [selftests]  9652b82ca9:
 kernel-selftests.mm.make.fail
Message-ID: <202603302149.1db397e2-lkp@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2PR02CA0005.apcprd02.prod.outlook.com
 (2603:1096:4:194::6) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|SN7PR11MB8110:EE_
X-MS-Office365-Filtering-Correlation-Id: 90043cfd-3733-4e83-16c5-08de8e61017f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: OKumzQNxItleQDadtoThtB4GDhmaSyFZN7Iz2EKjoj++21EFsF5rsB37QDRrGi7cZvl7sTOGbsyP6Wa5rFPtNGjgWvwPPnRQoyITekJUmFks+XDoaw8sI5qoKD5HEUt+Oi56IE1tIdaWpyml/6RCUAKnOZ5qL29maqSXMRj+y7hu0gk55v8ePeP/R+V2pkX7RaCAwJUh2QNLz7QcVyFWX7NQSQqzx5un1gEzy2h+7tWUktbRpMOlIVCPCFHiHWrjMRTTPfHlwXGHMpyqVuk3m3GymrrJVumP1JlEAb8ZRDvUiDrW44dwIemqEwzAX0QFxrswC8pcxNpebBPgRt31XM19QwI/K86ayyD3P02/uZMojsx93NclFoeC40NdyWM0o7/2/Zx1JYzItR+kinTu2wtOS0NKshELuL7ecTfcv0LD+uuCaueGnbYwPJEbhYJZeSkT7NBwA5SmfxyBuOErtQmRM7ZY45fNsDy8SyozzjJ7NbV7OVAkOUD3TeyjDHF+m5/ycP3Wh3I6c9jYG7i1ktsEVyrYDQayECRXorDiuvPSl7KiJT1KN7ZsXoGM0RVHvARhXP+Ev+E7wsJRdc/ZSX6ZG+C2hThTPuOXQ4MKpjnF+ayWe+NQ0iayEwh3QAZ+2Vc6wyE4bEODoVS7hkEqGy/znOCriWTjYi21S2+p2Asqk1gse7ZdFgFgTJDUlHFvYrwb+cdfvIh6Cy7V7KmsFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3pPTW5CQWpyWDJxSlZ1Rldqbmg5SWZZY1Frb3hsc2ZWQ2ZnZ2pVb0R2aGVT?=
 =?utf-8?B?V2IvV1BTV3dwMFI1cDN6VUxiZ0VrZGVWWmc0cjNDVzNtdEdubjh4Y2JtalJG?=
 =?utf-8?B?WUJ6MlBNWGxxUGFGM0EyMFpKaFdzazladGNEYnllZm03OVdtVlZpTm9rampz?=
 =?utf-8?B?cWJzUjA1OE9Xam9pRlRGdEMvM29ZK0crVGNkRkp0VjdmN3o0bUlEV1hYVkxx?=
 =?utf-8?B?M2RoWEZlWVIrQytsRWdQN29USzVQQ2NHS2VTUmFlOTRjZFJlcjVaVU5UNHV5?=
 =?utf-8?B?enhqSVI5MktxSk55Zm1NTlZTUldlZUgvcmt5a1I0UWxFNXpqM1paYVNSVDRx?=
 =?utf-8?B?b1ZWZncxK21tbVdLY3Vha2IwZ1FmWUU5RkhBNE9DSCtxd0YwU3cvMEVlNnZH?=
 =?utf-8?B?ZER3SWE4SFNib01zM3M1TEVLT0MzcDNqeEh1NVc0MFBHeHNXZFQ3dy9IVHBX?=
 =?utf-8?B?UjdVRnd0NDNsTG1ta2VyZUh1ZFU3aFYyVVVrRFhVQ2pJM0Z2eGdqejVWZElk?=
 =?utf-8?B?NWwrVjR6RzVOaWdYVmFGdmVNcEFyK2ZIeXVucDI0QThldEVNNHRMeWN3Z2Nq?=
 =?utf-8?B?UlBmcmhLSHZReWd6K0Z0R1dhNEVGR3lKd2dmUHYxa0VqbjRxTHIzTktiS3lE?=
 =?utf-8?B?NXNhSXZYYWRlcVF2VTJUMzAwVkhOLzBQb2tvQmVvckRGMFJkR1d3SnM3eWgv?=
 =?utf-8?B?UkhjNXNrUlVwRFl6ekhZMHR6aC9XdmlwTlZncUNWaXRNYU1pK1hCWHBuQnlB?=
 =?utf-8?B?Z2lDUE56dThSOUpZNVBPdWtCQ0RPbThFWlZxVnhadCt3bFY3cXJlWWJJSTRM?=
 =?utf-8?B?blZJQkdwbDNaQnBwWkV0RkNaaDltQ2U2clc5enBSNVkya0lkZkw3eFdNQ01q?=
 =?utf-8?B?Qjc4a1ZYN3B4TmdvbUl0VWppanMyc2paN0l0MEI3YXlyNzJvNkZwWVhKdFpW?=
 =?utf-8?B?clA4QXN6T1VwbUxQYzJaM3l0WXR2bS9mM0NuR3NZS25pejljK0pYTy9YYitx?=
 =?utf-8?B?S2VTMDhzTTJvbW9WaGRQK0lwUzZFNDRWcFNhK1JRVWtDVGNjRElJNEZmZzNh?=
 =?utf-8?B?cXFBbGJDUy9hUFhLeEc4TUVWRDlqUFE3THd3UkRlZGcybFFod2h5K2E3NWly?=
 =?utf-8?B?VXR0KzFkYXhXZG5OaW9xL3dZalFEV3pKeUt0ckw1eVR0anNaTi9YbXVnWnpO?=
 =?utf-8?B?dEFudU0zTUhsZ2JqSmlzQnB6N2RETXMzRHRUcm9rRDd6eHFQWVE1WTRBOFY5?=
 =?utf-8?B?dHdWY0hTb3lsVVM2aG1FMnJrODVIOFhIQlVQNjdiaDVqUURVdzN3WHl0SS93?=
 =?utf-8?B?RjFrRmxUaUJ6akVnRFdqZnJDdExtbkg2U3hEd3MxanJ4R1FTZTNPMWdTcGhE?=
 =?utf-8?B?R1BkV3RCQkVxM1hhR3RxRkNMN2wrVEJ6emRoS3A3NE9DUkp1VUxvelN4d3hz?=
 =?utf-8?B?d090MWhGZUhucXZUWGREa2VyUmVITFFzajkyRmlIWS9NM0EzeHJ0Vy91TU5v?=
 =?utf-8?B?ejMzaUZLOFByUmI3T3V5Tkpwd3RhYzU2MWtyMmVUeEVlS2hNSzllTGlPU0pp?=
 =?utf-8?B?UnZBcVZFaHg0akF1Zm9RWFh3aVNzekhiOUxtVWRFYSs2V2tLRnEra1MzVmN2?=
 =?utf-8?B?SGNTMmlrbUF6bVM5bmNZZ0M3aWdORmdVUHg5WU4xV2ZTRGZRMnprUE04c1dO?=
 =?utf-8?B?UGk5N25QamcvcGZOUHovU2srMWZsVkhQWkQ0TitoaFRzUDRNeDZUME42cDZp?=
 =?utf-8?B?K0hEVUdpaUhNRkxNLy9MZzhkQlBJL3VlNkhtL29Dc2s4YjgzRjZ5aklGTmNP?=
 =?utf-8?B?V01iVVB0dWw3SGdFZy9XQXlncUlwblcxVWc5OVFOVlJaemFEbHJWbUZ4b1Az?=
 =?utf-8?B?QzlFZENOUWI0Y1RkTHRZZitlYm9XYVg5SEpXY0hmckVvU2pLaGgyN2tCOHRm?=
 =?utf-8?B?S095NE5qUzVPTzRlbG05V243cWtBWEJ1M2gxa1Mremc5WWV5YlBUb3pYQkFN?=
 =?utf-8?B?L3ZqUi82bHpQL1NLZHZmOXgyYnhleFdYcjdyTmNGRExSeFlvenlIU3RMeUp6?=
 =?utf-8?B?eXdaUGc0c3V4aC9ORVZjbkt2bXBwblNGUFZKSGg1Snh5dXRWdEdNalMxVTBt?=
 =?utf-8?B?VDMrQlF3MEF5RzNLT1FCanJ1Zit4cWRVVy9LcnJNWUdqWUhzQzN4eUJ4dFcz?=
 =?utf-8?B?OGtEaHNEeWRVYVpici9WVVVWOHFoanhPOEdEZ3ZQQnNmRlhLWE1abCtRamdl?=
 =?utf-8?B?QWVST015ZXgzZGFlY2hTY3MvUmZkRWwwUEErWVVLcWRobXFRTHczbklhaTJX?=
 =?utf-8?B?L1ZYK1JsMDZxZXhoYWpiemIrcjdXcktNUDJuY0o4SUgrdDZNSUtGdz09?=
X-Exchange-RoutingPolicyChecked: USatn2TVPW/dae4XX+3WeAdGyJJk+qtXtPMcpSH+dTH5Gi2uPuxJexD0MVC2YwxRkt0BpxlyWqrtHTljCZHa/lrcSj5UYIAb/6XiTc+uw/nOH9i+akUe2kSkOQaX53uAA187iKmRZQH201uzk20Iv6b7+ck8JsVwKeSD7OJhA92iukmOhQfyiXDTrGEAL6b0rG6PGqrshCPsasVQ66BSY0vSRQdLksoqYuSyW1jwgd/kZALlImdPBN5JbJfx4YRQUq7ollLLRjerbCsrMhgjWNQEMpd7/Bi16C+0Y6OUqJKS8BPwU9UPnPTRvuw8BPaJwbQRjYF2fdISW6ouMRPMpQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 90043cfd-3733-4e83-16c5-08de8e61017f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 13:34:03.6069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUcQK2Cfo5UU8byPaB1C8uaLx9PDsAm3Prsfn9wDf2LJAiubWocOVIEX4TuKAAjq74p0YhqO6/yfwQb5pXL8oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8110
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: 9uyz7jfe9nsyc8kkku3wnphg71yse5m7
X-Rspamd-Queue-Id: 6CC05140007
X-Rspamd-Server: rspam09
X-HE-Tag: 1774877681-997467
X-HE-Meta: U2FsdGVkX18VJXmvS1aask5/4ASKJcJOgj52QN7kOpIEXsA3KzUluAsjD/cW+pkAra1lh/o6T57zqY8RX1jjdBD3l32Mi7TP4ysA/OzkCja2SM52LCGxoU+Lk4Pi/3S5j9qPWg0YL2LNsiT1Z23ylg/eRC4LNNNPWopGyW7AQPAL2s0VoL4XQsx0nf8eyzOn+5ohe6P1QkCnRURWTJhVohgyhmBlrYACwDYOyF0SBDk0B6EhT5S91+WVNOpL9gryf8nCyVIFz/beTHoFIBAGc/tqKkNZxTyY6lOq18oxwnfeZQn7sqTyQs54erLuxNU+uhL7srMkev3lTzXbK6YYE5M5UxcdncYzBGy0rYzvYgKPyS5GcKk9MYa7ys33/KdfGRYv9/3tiNZlkAuvji0hzIUi9y3PiPkK8a0QgQtQWzYi2qO4RmVIf7W4LiuKII9OICWuPaozfvtSKQZfuAMcD5IG7gkRFrTygV/sOW4/S+JfUXdZ/SqV1MNHdEiPmZD3rqonFijlhs04y5UL2YWRAgtHnARbqPXn5MIxQjPIM+k596i54DTUDwTuJP+W+qezn5PTv2kaHC9bcvOpBG1+nM0n9WCKWir94Bq7bQJydKsLOX8EolVcg9qF3gteSPZOWIOfzlJNqHDC6HH3MwF41w0sGGTqiaV+5OPwfpsCIZpVBenbS4gx4uDy5K6TbKC1HCtOF0kT3kRQ1LmEa3KcOCfpNUMnqsbMa7lTtAH2k2j3zrAvWVYFbkFNSUhfC/NLOOm7WCZyoWUwDrH/jEaXHelUJLnjiLliFs3uE6CFp8y1VNVkBZdUa/m9PFQX/lKH2RnhMfojV1XqTgAsgqF0P0qlzR7zSacGMx3DXkuRrNUkxtFYzGcRNWbubCN746EcSLcXIvxBx7fSx//jp/DAb5Y+sw7X71zalTBIR+sCvALG8KqigO8lBmpxmk69uC5lXqCi/EWIZEeUg6QGQJN
 0GhtrSW/
 tLsRHgei69Hj/vmw2MEIPLt2J5Y0Gq5GKJ0DjAmmRmkH3kXn5rpsqDUfdVuDW8APpKRlK7Oedeq+/UdKVaJEo7dUgQXNrJwICrTFQZ1qNHZQYeCHZKioUkJkbcSyok4L6PwR6avjFIgj37kFNppj6YSDcr7OelQgcoT7WhpREiuXbLV1PnGNGjmj04NaqBGBj0969Jx84AGLXuezrvOeKk7GFjHykV0VrW5C6liABn6+dmuw+iMwRKjx5qp+odjkYeppZURXuAS1CEaE3B8TkW8jpYHrM/poZ3C61vl200CX8s9/XQbE/KQgdrZohLLo0PQMjLjwQ2znFulC/7H/m+4ndpO3VJvsXruDDhOIynlCAuos/nUdvk8Z2ekaf5uEFdJtCDYCg+eAHPnMQA+IyeVuGxhruKVyduCm22euU314AqymcYmtW1de79blwaAUp5ANsWMiH+TPxq/F6Fv+h5S37YvBi9CrHMsqUbPrjeIzqhjYt6RgtTD0aCi5OgFvEqJ5aANWzamGi0ORmGeFCPHWHX5QftFan9RmA2snEDhbEPQmwcOvCVncgpSfUsVioBmuusPA2EHvqitIwSUdyi1e3zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "kernel-selftests.mm.make.fail" on:

commit: 9652b82ca963243fb80e645319d473a7dc65ee79 ("selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 3b058d1aeeeff27a7289529c4944291613b364e9]

in testcase: kernel-selftests
version: kernel-selftests-x86_64-c369299895a5-1_20260323
with following parameters:

	sc_nr_hugepages: 2
	group: mm



config: x86_64-rhel-9.4-kselftests
compiler: gcc-14
test machine: 36 threads 1 sockets Intel(R) Core(TM) i9-9980XE CPU @ 3.00GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202603302149.1db397e2-lkp@intel.com


KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79
2026-03-28 07:10:57 sed -i s/default_timeout=45/default_timeout=300/ kselftest/runner.sh
fixup_test_group: fixup_mm /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests
2026-03-28 07:10:57 make -j36 install TARGETS=mm INSTALL_PATH=/opt/rootfs/tmp/kselftests/mm
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm'
CC="gcc" CFLAGS="-Wall -O2 -I /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/../../..  -isystem /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/usr/include -isystem /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/../../../tools/include/uapi -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE= -I/usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/../../../tools/testing/selftests " ./check_config.sh
  CC       cow
  CC       compaction_test
  CC       gup_longterm
  CC       gup_test
  CC       hmm-tests
  CC       hugetlb-madvise
  CC       hugetlb-read-hwpoison
  CC       hugetlb-soft-offline
  CC       hugepage-mmap
  CC       hugepage-mremap
  CC       hugepage-shm
  CC       hugepage-vmemmap
  CC       khugepaged
  CC       madv_populate
  CC       map_fixed_noreplace
  CC       map_hugetlb
  CC       map_populate
  CC       memfd_secret
  CC       memory-failure
  CC       migration
  CC       mkdirty
  CC       mlock-random-test
  CC       mlock2-tests
  CC       mrelease_test
  CC       mremap_test
  CC       mremap_dontunmap
  CC       mseal_test
  CC       on-fault-limit
  CC       pagemap_ioctl
  CC       pfnmap
  CC       process_madv
  CC       prctl_thp_disable
  CC       thuge-gen
  CC       transhuge-stress
  CC       uffd-stress
  CC       uffd-unit-tests
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hugepage-shm] Error 1
make[1]: *** Waiting for unfinished jobs....
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/map_hugetlb] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/compaction_test] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hugepage-mmap] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hugepage-vmemmap] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/map_fixed_noreplace] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hugetlb-read-hwpoison] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/on-fault-limit] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hugepage-mremap] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/madv_populate] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hugetlb-madvise] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/transhuge-stress] Error 1
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/mlock-random-test] Error 1
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hugetlb-soft-offline] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/mkdirty] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/map_populate] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/gup_test] Error 1
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/memfd_secret] Error 1
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/mrelease_test] Error 1
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/mlock2-tests] Error 1
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/mremap_dontunmap] Error 1
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/gup_longterm] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/thuge-gen] Error 1
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/prctl_thp_disable] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/memory-failure] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/pfnmap] Error 1
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/mremap_test] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/migration] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/khugepaged] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/process_madv] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/cow] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/mseal_test] Error 1
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/uffd-stress] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/pagemap_ioctl] Error 1
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/uffd-unit-tests] Error 1
vm_util.c: In function ‘pagemap_is_huge_zero’:
vm_util.c:127:14: error: too few arguments to function ‘pagemap_scan_supported’
  127 |         if (!pagemap_scan_supported(fd))
      |              ^~~~~~~~~~~~~~~~~~~~~~
vm_util.c:70:13: note: declared here
   70 | static bool pagemap_scan_supported(int fd, char *start)
      |             ^~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [../lib.mk:224: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm/hmm-tests] Error 1
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-9652b82ca963243fb80e645319d473a7dc65ee79/tools/testing/selftests/mm'
make: *** [Makefile:212: all] Error 2



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260330/202603302149.1db397e2-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


