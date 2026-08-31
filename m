Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A30A4C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 04:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E506B009D; Mon, 31 Aug 2026 00:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52C96B009E; Mon, 31 Aug 2026 00:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F31E6B009F; Mon, 31 Aug 2026 00:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 607F76B009D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:23:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7E63403F7
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:23:11 +0000 (UTC)
X-FDA: 85160269782.03.4AF3263
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf30.hostedemail.com (Postfix) with ESMTP id AAF0480002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:23:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jRKk0c8F;
	spf=pass (imf30.hostedemail.com: domain of yu.c.chen@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=yu.c.chen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1788150188;
	b=pwV+SWxhOA7IAc2iCcNtvAmAZRauN0K01+vt9zJ/r6w6dmBAzM0kRHQocjns6TJNmYoq3K
	mrNE1NEphEV41RquqGzkCibQf0o7mQ1dSqO0eXetgLO7fQHK+ilqkCj6ccRZrSkA6J4107
	O//uqqTOyBo8jIun98DZzbn9Ks31dBQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jRKk0c8F;
	spf=pass (imf30.hostedemail.com: domain of yu.c.chen@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=yu.c.chen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788150188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rC8eCZq2KePgUS+Dnb8yvgTgONW59VIAxB4yvs9h7pc=;
	b=6wmA9Y0sy3bqLHZV8nY10rhA36oU9K+6wdRXJIQgl94boU5Ge49Dg5/nfsZtqdkrqfQYXn
	vq7q7IpHPSuMmyuvEs3fuiv7J9gQidic/cMBTiqfZuIOhh1+FgrlQkI5X4qOLGKN0CBdx7
	7UPxc3d/h3+bJ/0nxe4DDMzC/VUKjus=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788150188; x=1819686188;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T9rfljFrLo/4IANbr1Ji4NOzLsLKKf03OEgCk6gfB+U=;
  b=jRKk0c8FnAAVf3RnKmDAw9X8Jqv7yYqDj8gf1vA4NGMHFXa4ScL4HQDn
   /AAknkyUHTUyCfRG1Dik81jBawAkTwAvSrP1ym+9yY/ffZeK47/1CwAeL
   6GaEQ6WTuOmRdD7WlyyocTvWB6X8T6918VNJNJqiVz8C0VhqGZFZFABtn
   Z1ZRyRCNIJGSy8TRoqPLXmyKfDrBIKPWX7GCWqsPHghKM3R9MnOJTAAZy
   Afma4MtN/kSNm5zYcQHU7/Ob1Z6KHS8ZAqpBkfhDiUCRo+Rr7rnbaJoMs
   bjzXWMFEwBgK1FIBnvhzAf4fNZ4g9ky8Uy5AzyYvsY+9sr0QBYoTcoXHw
   Q==;
X-CSE-ConnectionGUID: js4w82/vQyW3N41ATo+x9A==
X-CSE-MsgGUID: hbuwTXNAS2+b1RlgQ5WWmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="100059723"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="100059723"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2026 21:23:06 -0700
X-CSE-ConnectionGUID: j/KyGLzzRJmC9FLPaAZIEg==
X-CSE-MsgGUID: pI+5YweST+ippX0wWFXNDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="270621923"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2026 21:23:05 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 30 Aug 2026 21:23:05 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Sun, 30 Aug 2026 21:23:05 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.59)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 30 Aug 2026 21:23:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J4OjeINK5zeSHJLP/6ufPC6ifQOYpYj2vTQgn72omIW5qckpq7K0N0Pyt3oM/dF37N9JxFYrs8oMlVp5btz4IGjLRqEY947MwqfWFp3bUXI3iTK4LhoyFdPSTRIC+d9youLWulSX43e/cHqSZuPAp18o+lx3gyY6ZHs+JRqFfKfUlPP6isbQ0saoLBDY9Pdru56BV5Piwn4IQUvmyLkeumKH06UNtwPc24PEvkwZA1ZOpvOJrSnoZi34hQy59sIvfK+GoMs6Fkdgka4hHOSd92jkF7WTwQAbfIkxfVMbPL7eIxDH1xyWFXQP6bv8y0txJVY5lLIFiRvFKSiNlrPRCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rC8eCZq2KePgUS+Dnb8yvgTgONW59VIAxB4yvs9h7pc=;
 b=Hp81Yptx+nj0vaOo5Sck/HN7oG4MK/nwKyoVHNvVe8AydcRpheFjzmTQc2WbLeKqadAW4wOFkJtY0WeVnk1RVnvLnLCS8FqsWb3iDlfW6wwdw0QyLY4kwqoGl1RVCkzW1lfA01dJh01yCFGt8+WgqyDf/X5l8CQgXrTSPrOmxVZIqQttZc5dnawkLeC/T0IdtadwA7wSeFy+mMYDeyZmw5YXYaZOvjfyuMAynCY4vBhgFfUTN20sV3J74o+YO7PDN3NwnAqHv6v7L5IDp6Iyzcr6gw+OMztroKMo8pOyzOvf07CT74w+pQ0WFznVJ84oU91oz2/hfPql3d790Fbfbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 SA3PR11MB9485.namprd11.prod.outlook.com (2603:10b6:806:45e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 04:22:58 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%4]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 04:22:58 +0000
Message-ID: <825d9dcc-b052-4367-a9c7-15efc4b354f8@intel.com>
Date: Mon, 31 Aug 2026 12:22:45 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sched/cache: Fix use-after-free of the mm replaced by
 exec
To: Hyunwoo Kim <imv4bel@gmail.com>
CC: Tim Chen <tim.c.chen@linux.intel.com>, Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Juri Lelli
	<juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
	<rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
	<mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, "Qais
 Yousef" <qyousef@layalina.io>, Aaron Lu <ziqianlu@bytedance.com>, "Srikar
 Dronamraju" <srikar@linux.ibm.com>, Vineeth Remanan Pillai
	<vineethr@linux.ibm.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	"chen.yu@linux.dev" <chen.yu@linux.dev>
References: <apPb-Dr4nPYuHQOK@v4bel>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <apPb-Dr4nPYuHQOK@v4bel>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0033.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::21) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|SA3PR11MB9485:EE_
X-MS-Office365-Filtering-Correlation-Id: 1db0bc00-77bf-4cb5-6158-08df07178938
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|5023799004|56012099006|18002099003|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info: vcPQhzxq4SUnIqsUFeCy0gxKTHxZsQSJPpDM39J3M5okA56r3A4UrAo5XE7foXwlHxSWzouh2N4fa54KxEF5DoWiyYGT+VOAwLflmV4gBPnxdufvW/WRXRw9q7Z8/UMyPZ81j0UPwTzX9DzjUJIJfHaPBV9XkTUN2UVrAfXp1nKt5e/ava/cVAMyozS8iYyxp6ArCdfCL5WbvA2PtdA5orGU9dnC/mlir2qNs8ygWEBCIHrn5F8bPAr54YWEa8egI8aMdaP6gmZLZ4EUlCM0P7jIXxrbjNOaK1uAFoSvaNMC/H1nowZ3DOx5OxfuP4HojW3M7ZfTPBNtmRLzFRHlTPVWmJ+dYKTFg2+OYqoHC5waSznZYiAar7Y0F32LldKUs5OpV3t1CQ6sGWwvU+xU6dC7VC5ME1KvpS4k6Qb054dgiXcCGkSG3DSU5+0oI3WpIVHXnHnWXKLfptJLxMh2irrQCubmIaTAXJqhs7BYkoYf3pdtGP7XQR+7flToKVksrgEZ8fap7tGjkkgIOkiq/OPucrsmTrOLwjaXoGNCsmz+loIB0dQcdtrQQVaCFhZRduudtJ/KtPegdF4vF3kLWalU+XApJrHA7F3s4rk7lbFgJ+4jYbcXZoLynaE0nhxUGOLanlAW8W+4SOaHjzi+ft2xIbT8xV5Nh3uBExdhxU4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(5023799004)(56012099006)(18002099003)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFNTWVlra29RT3J4Z0RnblJYWSs0cXNoOXlGNTIrWVFHbFJZZzlwQ1VkdzJX?=
 =?utf-8?B?WmdsRXhsbXlFNGF5M2dOTFl3dzRSbURlSjdpa2RXSGllTlRnTHVoTnZFQ2lF?=
 =?utf-8?B?YXJ5elVxN0JNZno0dVh5RDA0K1lEVnhyODkxZUdoeU1ZaDVZVlhPMU9zSGhQ?=
 =?utf-8?B?NTgyMldCMVA0Q2RTQzJlakVYRmtVZmlSWHZFMG0va0szdEpTdWZ5Y0d3ODZ0?=
 =?utf-8?B?Qnc2L1ZDdmhWcXpwOUd0SG9heHJWK2hJdUdvRDRzWWtwNnFBSnV2Q3dnNzZ1?=
 =?utf-8?B?ajgyQTZQYTNReUNvQy8wbGN6OGJORnh0OEdIbHl0cG1QeFJwMVpKeFJZN3ZR?=
 =?utf-8?B?d0pGT1krTFhoOHVZcFFBQU8wQ05PWVZoeTJhMGg2aEtPM3JSbTNKWDJyeDV1?=
 =?utf-8?B?MnkxUnJNVXU0SGkxckpwdzJtVlVkM0c0VzI3TXhjK0RNZWZZc2hqaC81VnFu?=
 =?utf-8?B?ZFVYRXVpREs1Z1pVdXlvanFneDFSQUE5eDVQWVhtaTBGdzF1cG5QcG44YlMr?=
 =?utf-8?B?azVxTk8xK1ZESzRUZGt6Uy9YdlIrMUlUOTVrYzhTTmRZVUl3V1BQQ2hVUTZs?=
 =?utf-8?B?NlJIM2V5dlhtSzkvMkVPSmZpdzN5VUh2Z1FCWTFvN3FQYzRyejFCamxKd0VT?=
 =?utf-8?B?emkybW1OaUtYN3dtMUFQbFFnVlZBM01VZFRSaU9pK0Q3S1MwcnY1Vkx4eEw2?=
 =?utf-8?B?ekM2czNpbnNSakVud2E2Yk45Nis0dWx4RWRyMUhTTkt2TlI2cmFFR0NTMHRG?=
 =?utf-8?B?eHJZMGY4dDVGVjJ4aC9XWFJNMnhvajQ0MVFwaFVpWWpJNGNJTm4ybyt4cy9Y?=
 =?utf-8?B?end3WXhWbjJKZVlvYnBMcVVuLzU4NHJvQmFaZmVueEFjNU1XdStpb3ZhRUpF?=
 =?utf-8?B?VDBKeGtkY1ZONlRLN05FNWZWR2ZHajdRTE1MSlZ0NzBmRVlvYzQwNmczak10?=
 =?utf-8?B?N3RsSFVqY0hBK1ozUmExNkhuR3ZTeXNsWlZQYjlSSS9la2FMRHJPNzBRcjU2?=
 =?utf-8?B?aUJ0SGlYaFVkZFZOWGh2L2RwckplTGZrNE8zb1dnbDB6Myt3WGlBb3d0dE44?=
 =?utf-8?B?TEFRQU1tK1Nad0RKc2NEK3lValNtSU0xZlFLZkE2UVR3Q1lZUWFHa2UzVTEy?=
 =?utf-8?B?UzBZMTVORUF3ajB2cWk3MnRoZUJKU1Y4MjI3dE0xMVRLNUE2NUExTEx4S3Yy?=
 =?utf-8?B?YlhhNjRCald0TTBYNm5QbDlkSTNoUzlSb0RkWXRBVlM2aW41ekZBYjNxb3ZE?=
 =?utf-8?B?TzJ2Q0lad0FPN1BJeXJTRWpBbFFPTHYram9iQldlZ0QyUVZkYjVFL2RocnI4?=
 =?utf-8?B?OGZ4d21TWTlZWkZ2VS8xazVvWVdwZEcrZERSenpRcDZZMUhhYUJrejlDa0NT?=
 =?utf-8?B?UmpaekNDbmlTRmVvbUxYVzFFaTQwQU9YLzl6K2VKZC9UTUd2NnpZcnZobmNx?=
 =?utf-8?B?bmxORUF3cnMwNWNKc3VNVU1CK1hnTWFodnJXZDhKdGNKNXgydlRBS3UrbzVr?=
 =?utf-8?B?WTU4Wjc4THNRUExESDdqTjA2TjRvWlA2d0xieGpuM3ZCVHA2YzNzZ1REQlBH?=
 =?utf-8?B?eXNJRnQxTnNqRzFNbEM2NkZTeisxZjlDNUhGc2RpUkVIWG5COTN3NDlUY1F4?=
 =?utf-8?B?eXNxRU1RTXljMit5YjN4ak02cUJYVk1qSDc4ZFBkSG1nSUV0TS9EQnU5aHpj?=
 =?utf-8?B?YlBTK2MyblVGSTY0aTNVK2N2WlNjcXR1Mzh5SUFPWGc2T2VGRDFFb0EwYjVP?=
 =?utf-8?B?bmN2TFNqZ2pMdGhjQlNpL1lSV1M5ait5U0VvcFVaK1lUT3RPQzRjdVUreldo?=
 =?utf-8?B?bWpFN0w5dHN3cDN0ZFpJTnJDQUdpajZGeEpRN1JSemRYeVprRzNlTTllb2wz?=
 =?utf-8?B?NmgzNzQraFBjN0xPeGRvZExORjBvZ1pweUxxQmdWa09QVVRCY0VtTWt1Rkhy?=
 =?utf-8?B?bUdRTHFkZkNYNDMvOHRmbjdUTmFKcXI2Z3VmaU10YVdXRk1XV2JEMkVKNWhK?=
 =?utf-8?B?OFlkMEMySXFjcE15dXM4aVU4YVNTblBjanUrK0s4bS85UWRQaUM5aXZUQTV5?=
 =?utf-8?B?N0w1RTMybXl0dUJhYVJFdC9HdVZzbENFdnE5QjVXWjhvejVob05TbGFBT0Ni?=
 =?utf-8?B?UDFUNEZqQWhkYlFvdlpSbE9EOEt6ZkdPSngwbjU5TlVnWFBJdUQ2NFBwUkFG?=
 =?utf-8?B?R0tjT09NdEV3VGI0d0ExV09GZjA3L3RnR0IwKzJmM1AzYlg4Qk1JWWg1MG9E?=
 =?utf-8?B?TEFKWHNGTWptS1NIbzNaSGs0d2owVWhHUmx2dDBPeDF1TUpSdXFDbkF6WjVy?=
 =?utf-8?B?eXFyQVRwN2JuTWdMUEJmWWY2NjJYQ2txS0VLTXltSjFXd3VneHhuQT09?=
X-Exchange-RoutingPolicyChecked: Q5QT/sdqfmuiqLMx9PLmGkrOyOoDVQhsUqPj94OeRC9ryp2ubT3qgTPoQuBGvOMBtDf6JjcsHV6mSZPZKpQ5Q3GosCEMAooltsWLGczfP4gkvT9U7FJuazS4ResTjPWJZos5PmKeBNa/tO6v85MF3huyCzgNbsHHuxzsAcyRxGTXab2ViVbkocXyJ8DIXrKWlczf4k2NFOB9Q4hQwPLtC5qM0VLNYQtoWHLuYo9sdqYH0u+JIBOvGPwKV1Bo+97kuQYCJknw0jpbQa1uN7laTuosgBGZ9OfLXi/IhHMLN2COFLETxVBfwGyLXWp3MUnZyaCYmAnquAJ919NzXNyrng==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db0bc00-77bf-4cb5-6158-08df07178938
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 04:22:57.9436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VaZzevTGTe4sk5gLq9rICk2/j1ryaNHLfqEJxKeowTNGz94Dn1wlVQ4tpaXBAolJLSUYRyG5mQjMnFPXS/gNhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9485
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AAF0480002
X-Stat-Signature: qesgf4hie4cszryeu7pasisn5oo5umj9
X-HE-Tag: 1788150187-987084
X-HE-Meta: U2FsdGVkX18yYDPLnnHKjxGKElEWzS3nFO+UaHaKy+JAzx3v0t5IFlcfViKryXohJLZRMSuypyOrzqo197r4+HFytZ1phqvYYzKWsElCA6DU2hC73T9wnfB5m1ah11f5l/BDlFBEfODcRrY92Yq3IkEpqq422/fZacDi9B8iTidpcWCsxfdZ63KNFa5jL0MqtR+wT8EncMx0cIgPGtv/i5u5KJAD8oKjZjDtag8fYffu2r6zByVFK39uwBewUjAIoh8trdXIIPx6njbDiyc0fEfw1HvCsD6xl6z/H2VEIgF6FFBm10HlJ5/TfqWqDStELTePEZPt6Ataxm/w+hrmYkokiLA26jrtieI0xxtNsABTLHdpK3ztJo0ACvjRvmsYrTZRe/uv8t3xSa0pqrlI1WslKkyLoCNS56GcmTdltBJnE+jHR1gjTOcTCqVr2U4kS3erplvkKMdUYkt1xFGPc0/3H6uVvQOAtoA+lpv5lsVJ12TQgADdgJdYtSsPIXff7P2F3H8nEIovID1aJknFj96tK1dBNZh+HZdNa2t16si0sZXR6PMfzJvjrlKYQDaGby5+kosXkWnFa+G6RhdzN+9OdYNH+k2y5WJ1PITbMC00uc309CXNncnQddAbpHVmrQIT8Tn8Mbt54qDGDMvNycGIO9KPYtoig2dFT0Ap6U3HrBnGOKeOnerPeIdfLZmTB0ba6QVheI7U4ZBz0Gtl7gHg4VMJssst8/7BGs1VcW2sLJ+bHgMHRQh+RU641VpopnBtIjRHKYvk14jr5H4ThIuSiWcik7+wdles5m2XWdh1O+3Vc5YFSHtxf9iHJnSRUwTsc/zBgZhS+8nFmPHw8rBp16bmkbUn6u8F45oYkTyWWeBXfN5jxOoPa/RN4f+eMqoFlCsGFdepby/bCxSFa531CI+pb8WZSG3LFiWG+Gk2X3vZWMFaxdz2wO6nTi1UlLyCJ5MX8q22yE3BLVU
 ksGJYkL4
 QhUjBE4rLIo4uezWaA8Pg6SgF2u3Ar/Or8MawpFZw6GNEqmd3ZrnO4L2YI8btgepdLnv/I2Nu17b1JK95cBUr7lsXcD7u7aqBJphfbGTktsu6cLrH/lFbh3e0TDom50urwfKAGCFKS5X5kzA0UyPnWjYcUJE5yFAzasp61ZQkKh07yiGai3gRBfGx8KqrLWhfdtIazWfJD/aHr4ir+c6np1mI35TmFspkrisdShRCyqEGGVsfVM3yW4qBI0Yxi3s6ULwcVyp5r4Jn9FKPX5lmu2x/MyyjGsQIohhPo4Vt+iKTy010pAlJ/whjskuThPE4BHQZAu9QHD4e1j8Y2HKRI1KimS71K0k+AK+d0jc+5i9TwVovEW/VwYaN/bwhzl2rFx9cz7BBnEC6FfpI9KX+gJIuttvs2BH5W2IRKAr1P5PwfS1SoLy5Kwuc+abPTSf77HKJgl/GffCKmCOS0GZS9IOdC3x/OPK82GtwBe1HRiFuPetY4Gr6gVmgOVJcASVwTU8r4fvGnBPL/S+TWLdRHY4xiF5bnC7B6kJ4PZ8CghyyNt4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hyunwoo,

On 8/30/2026 3:30 PM, Hyunwoo Kim wrote:
> When the waker cannot use the wakelist, ttwu_queue() takes the target rq
> lock and goes down into update_curr(). If the target rq belongs to another
> CPU, the task handed to account_mm_sched() is the one running on that CPU,
> not the task being woken.
> 
> account_mm_sched() reads p->mm and updates mm->sc_stat. Nothing keeps that
> mm alive. The rq lock and rq->cpu_epoch_lock it holds have nothing to do
> with the lifetime of the mm.
> 
> If that task happens to be in execve(), exec_mmap() points tsk->mm and
> tsk->active_mm at the new mm, and exec_mm_put_old() from setup_new_exec()
> drops the old one. free_bprm() does the same when exec fails. On the way
> from mmput() down to __mmdrop(), mm_destroy_sched() calls free_percpu() on
> sc_stat.pcpu_sched and free_mm() returns the mm_struct.
> 
> Whoever already read the old pointer keeps using it. It adds to runtime in
> the freed per-cpu area and reads sc_stat in the freed mm_struct. Depending
> on the condition it also writes sc_stat.cpu. That is a use-after-free.
> 
> Commit 9f23469401b0 ("sched/cache: Fix potential NULL mm pointer access")
> changed the remaining p->mm dereference to the local variable, and said the
> active_mm reference keeps the structure allocated. That holds for the other
> paths that detach an mm, since they take an mmgrab_lazy_tlb() reference.
> exec reassigns active_mm to the new mm as well, so that reference is gone.
> What is left is the mm_users reference in bprm->old_mm, and dropping it is
> the free.
> 
>               CPU0                                CPU1
> 
>                                        write(pipe)
>                                        try_to_wake_up()
>                                          ttwu_queue()      // takes rq0 lock
>                                            enqueue_task_fair()
>                                              update_curr()
>                                                update_se()
>                                                  account_mm_sched()
>                                                    mm = rq0->curr->mm
>                                                          // old mm
>    execve()
>      exec_mmap()                       // tsk->mm = new mm
>      setup_new_exec()
>        exec_mm_put_old()
>          mmput() -> ... -> __mmdrop()
>            mm_destroy_sched()          // free_percpu()
>            free_mm()
>                                                    read mm->sc_stat.epoch
>                                                          // use-after-free
> 

Ah, thanks for catching this.

> ---
>   fs/exec.c             |  1 +
>   include/linux/sched.h |  4 ++++
>   kernel/events/core.c  |  2 ++
>   kernel/sched/fair.c   | 16 ++++++++++++++++
>   4 files changed, 23 insertions(+)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 745f6eb5279e6..6194c38807980 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -916,6 +916,7 @@ static void exec_mm_put_old(struct mm_struct *old_mm)
>   {
>   	setmax_mm_hiwater_rss(&current->signal->maxrss, old_mm);
>   	mm_update_next_owner(old_mm);
> +	sched_cache_exec_done();
>   	mmput(old_mm);
>   }
>   
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8b3d47a325cca..6ae31bffe049e 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2415,10 +2415,14 @@ struct sched_cache_stat {
>   	int cpu;
>   } ____cacheline_aligned_in_smp;
>   
> +void sched_cache_exec_done(void);
> +
>   #else
>   
>   struct sched_cache_stat { };
>   
> +static inline void sched_cache_exec_done(void) { }
> +
>   #endif
>   
>   #ifndef MODULE
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index a6c8e38a31104..2f29cbccf03f1 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5427,6 +5427,8 @@ attach_task_ctx_data(struct task_struct *task, struct kmem_cache *ctx_cache,
>   	if (!cd)
>   		return -ENOMEM;
>   
> +	/* @old, loaded by the try_cmpxchg() below, is only stable under RCU. */
> +	guard(rcu)();

Is this change related to this UAF issue?

> +/* exec() has switched to the new mm and is about to drop the old one. */
> +void sched_cache_exec_done(void)
> +{
> +	struct rq_flags rf;
> +	struct rq *rq;
> +
> +	/*
> +	 * account_mm_sched() dereferences rq->curr->mm under this rq's lock,
> +	 * so a remote CPU can still be using the old mm. The lock cycle waits
> +	 * for it, and the store to tsk->mm cannot be reordered past the
> +	 * release, so later acquirers see the new mm.
> +	 */
> +	rq = this_rq_lock_irq(&rf);

A smart fix, learnt! It behaves like a synchronize_rcu() to protect against
the read in account_mm_sched(). Small open: since the context of invoking
account_mm_sched() is preemption-disabled, I wonder if we can simply use
synchronize_rcu() directly instead of this_rq_lock_irq() - just to avoid
contention for rq-lock in heavy system?

thanks,
Chenyu

