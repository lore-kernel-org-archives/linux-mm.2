Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DA08E6689D
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 22:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DD6F6B0088; Fri, 19 Dec 2025 17:39:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 694126B0089; Fri, 19 Dec 2025 17:39:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 596906B008A; Fri, 19 Dec 2025 17:39:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 46BFC6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:39:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCF3F12FA4
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:39:09 +0000 (UTC)
X-FDA: 84237687618.27.EC54BC8
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011049.outbound.protection.outlook.com [52.101.62.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id D2672C0004
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:39:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e2cSsYmr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of joelagnelf@nvidia.com designates 52.101.62.49 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766183947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pNnZMtqE6o4bWUv0MYuR016PgTMnrQIxxjCWFe163M=;
	b=nO56SJmhmk35hnOdN9prmP/ad1wN/CMoS4gfQJoU4xd6XC91FMS0pG/w4OkMom4tJ/Lv4T
	lpQj+ruJEqommdL2KPoVX3Un6LIYD7sPnZOttBM/1hUFRwAPajmLA9RoOo0iFgZf4lPLXr
	odXgrn9DJP28fF6bVemYPlSXCdcNtyI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e2cSsYmr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of joelagnelf@nvidia.com designates 52.101.62.49 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766183947; a=rsa-sha256;
	cv=pass;
	b=bFb4FQw9AqDsCVqtt77Xx1HzsG/0Wqor8WCuOIZz3VeHXuvIduv1DofBzDNZHFFuM7dRRW
	g2FBdOlL0Y+3iyRWmAWLX+hPyVQI/YeG3ZWfrt1N5vyJZoUXMPDPsFQ1wYr5c8xRYprwG5
	lKj8yC/xvwH2RznFi2Y1zQTJp0vtJt0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eaqDre4m6wj8X0cWI0nuQ5dCqWM22AlivVIkyFCGMxkgdo3tfwfNWBc4mV1h1lLbF94CEBT2jGQGl0W+UNizoc0LM9xTixRfc7ELfr1kLhIY020fZvhirY2ysj9Mj5X+Gn2Lhqpvr2sYYjX3Fvsnpzin4OVl3wuJqEsNQwHNgrX1aIcXDny9YAWIlQhRpJ/CE815hGKVE4F7SliPFUQCzRr9mCTjZxcW1u56FS0Lv8TO7frK0B8ZQ7UlpfGVEXD5qhNzutrhbW+8CxWOntoDPF2yNLIfuWYeUu7WclOWzVoPCEURoE/dC3UnU7zsMmL+TJh+MGPQQ+0RU1+P8qF0tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6pNnZMtqE6o4bWUv0MYuR016PgTMnrQIxxjCWFe163M=;
 b=twl48xkHaZBcclvo6LMIYw9BaiTOCPotJx3I3aKi/sGXQH+Ha75UQpBhUf+yMUZbPVXQzPuuvewRTxq5gbn4Qfmg7HqIayURI+XHMec8KI5yDf03PnLmaT77/8+VUapdWDBTrxS5U/xPVmwPSXkPLX+EbAIDutyEngyLbaWKhJN8lFEkz27klnuRY81JYWP2EjSNZud285ha+MTrDWF2kz7bRE2kTmbpWJK/bWnrxwtNnvFyMzb0GJTKW2/uHpOoyscztRKYy1idCU2CW7Vd3OW8RHLlc9ZokkkMTk8z4zNRCcDCOHs+ipmSSfn6YxaqgPsaNBnYiCQKsea6hCwNbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6pNnZMtqE6o4bWUv0MYuR016PgTMnrQIxxjCWFe163M=;
 b=e2cSsYmrudZfyySU+voAEXhaUb2TKB18NaHdFeRBKoMt+B36dnc+jR+3bYphzBzGMS/SXipEWVDOU8KzdFmL0STEzCAzk5Ggp1hsf2zNE9TeWcTAlWjr40OMRmjBRza/g532PsxMnnvrMsXJnv0LwLjA2d4g8ttm1S9gmT66r994QlPTjc5ttrBbBzWFGtex2cT5PMjLSOjM7KP4V6tWvEHrGPCUn8/HJ0bGi0VmsuDLq4rru6Hv8orc8T9Tsej6wQcdCZYGK78dT4oBAMkfh1b8bGsp+wVQ/Sy4rGyp77SR6z60uqwPFWdjKqrkRTZHggom6ZqQ07dfLqCjRy+2jg==
Received: from SN7PR12MB8059.namprd12.prod.outlook.com (2603:10b6:806:32b::7)
 by IA0PR12MB8695.namprd12.prod.outlook.com (2603:10b6:208:485::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 22:39:03 +0000
Received: from SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91]) by SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91%2]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 22:39:03 +0000
Message-ID: <38d05c17-c28e-4ec1-be30-e77fd7015b5a@nvidia.com>
Date: Fri, 19 Dec 2025 17:39:00 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 3/4] hazptr: Implement Hazard Pointers
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Boqun Feng <boqun.feng@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Alan Stern <stern@rowland.harvard.edu>, John Stultz <jstultz@google.com>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
 Mateusz Guzik <mjguzik@gmail.com>,
 Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org, lkmm@lists.linux.dev
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-4-mathieu.desnoyers@efficios.com>
 <aUO9KRaP0FXpm_l9@tardis-2.local>
 <fcbc99d0-b7c7-45f7-9cf8-f5d3bfad966e@efficios.com>
 <aURihbmjsKi8m7MO@tardis-2.local>
 <42607ed5-f543-41bd-94da-aa0ee7ec71cd@efficios.com>
 <aUSbhiMgluudbVEG@tardis-2.local>
 <edbe45b3-0f85-48d2-8d4f-784781a8dee5@efficios.com>
 <6353feeb-c2ab-4ff6-9ea6-04ae5102641d@nvidia.com>
 <6b27f3c3-47f7-402f-aa6c-b564e3db1d6a@efficios.com>
Content-Language: en-US
From: Joel Fernandes <joelagnelf@nvidia.com>
In-Reply-To: <6b27f3c3-47f7-402f-aa6c-b564e3db1d6a@efficios.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN0P221CA0028.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::16) To SN7PR12MB8059.namprd12.prod.outlook.com
 (2603:10b6:806:32b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8059:EE_|IA0PR12MB8695:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c1801a9-09e0-4ad6-ee16-08de3f4f6950
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VUNRdmRJenAyN2dhV3RRUlpOZHM1UFFSQndkRE1ZMVRGN0dqZm1rcHQzRC9X?=
 =?utf-8?B?WEpGUm9nMU54R2hMWk9nMkJXc0hhN2wrVEtVYVpXdTNZTGNpQ1crUzk2M3pE?=
 =?utf-8?B?SFN0YVFGZVNkeFVWUzZ2aDAzNlNiaWFWQjJka0NFSDdXeGdlRWphc2gzQkkx?=
 =?utf-8?B?cEdCRElKZ2lsV21uQkxjenMzOUIzQnBZS1plUkFPZWozRllFU280NkZJTm53?=
 =?utf-8?B?SlE3NW04OCtxK0oyV3lGNEV4YllrUGRXRHZ2TGlGbmJ3ZytPTGhRSDNkMWF2?=
 =?utf-8?B?WHVtZjc3QXNSMFI3b3pxZnJ5MDZmR1F2eDZUNk11U1hYZ055RmdObnp4Kzkr?=
 =?utf-8?B?dERBLzVVc1F0R09SY1RJaGNNaW9YTTVTYmM5Y1ZGZ1loanBTVWI4YjJueDJi?=
 =?utf-8?B?UmZycWFZSnFkOHQ0bGlsSEVqWUJrQlVTdS9HUXplQW5DYXNqeTViYVZWb1lm?=
 =?utf-8?B?RFl5cENhSFkwdlpEZHZzOW9hRVZKRURzaENhWEtQN09INlVoOTZvajV1Tzhx?=
 =?utf-8?B?Qm9LYm1WRVZGYkQ1YlgyNlloQjg0QXZ6a0VzbkllTlFVblludjMycjFOb2dz?=
 =?utf-8?B?VWFhS2R4Vy9oTTdOa0N1WWNWRFcyQXJzNFNKY0JBa2E4YTBzK0dvc0VVS3RZ?=
 =?utf-8?B?YTR0a1ZSUG5na1JRMGt0QmtDMlhCWlJsTjZpeHFUSHBmT3djczFldmdlTkF0?=
 =?utf-8?B?T2lUMHVveFpoRWwyNWJ4VEhwUkpzbEJTYnI3Y2FmMUt2N0Z2TlJNSFVQTENV?=
 =?utf-8?B?eUtaZDlvTmpSQUNLK2g0dHhEWHFPUUFUSmhNSk8xK1ZKK3ZQd2pRZHhnZEVa?=
 =?utf-8?B?VG5UWm9FNW5YSWRzN2UrOHlVRVdvcW1ycTB2aFRJd2V2UndtemtMd1JPeTVS?=
 =?utf-8?B?SjdMbmlHRjliT0NWN0Q2MXNqbVJmZGFnTXBaREp5WldpeEN5cFIrWGlnSzdN?=
 =?utf-8?B?czR3NWxnUjdNbVMrSytVYjg2aTBKcUg2TnVuUXA2a1RUWEs4VDJEb0xuaFlD?=
 =?utf-8?B?c0JJRktCYVU5b3cyVEptaUlGbVRsZmc2cFR6YThpaVo5QmNwcFFtMHNxcmIw?=
 =?utf-8?B?UG5KdmlWSjh4NVl0Mm5BMVJ6eXdmN1oxcEhiNjB3OWd0UGRHdDNUOXN5d2Ns?=
 =?utf-8?B?bGZjTk1NOURhbzYxL2VQZ1k5aERsR3ZTdWhYaExKVWpMbVl5OUI0WlozTjE3?=
 =?utf-8?B?QkJtUXVUZVEzcW5YZ2NHMXl0QmV5QWJQblQ1UFk0TTNPS09uRmRIQ0xUcGhQ?=
 =?utf-8?B?cG1RZ2FMQ2FCaUtjbzNmbCtpZHp3YnEvN2xaU25CRVdpam92OXQveGgwckRP?=
 =?utf-8?B?SExHNEdtOVhYM1FYakd4RS8ra2xDT0lmZmNZbXQzUEZ4OCtIZlF1eXdHZmhi?=
 =?utf-8?B?bDJlQThqTno5ZHhJQVVUejVFb0pDWVppam5EOVd2UTFLVEhRSXo4cVFwZW9C?=
 =?utf-8?B?aVBGK3oxOUk1Q25oODdXMUthd2JaTEgzVFlTQzR1c2lFYUZuT01sVDNnb3JP?=
 =?utf-8?B?OE1RNkY0Y0hnK3ZvRjFDTkwvUXhYT0ZnNVU2MWJ6Qy93QVAxWFFVRmg2Q2t6?=
 =?utf-8?B?STZVa3VKakNaWjBpUEN6NUQwOFUvT3NGVzF6bWtXdTcyUk56c0VUQlRhQ0l2?=
 =?utf-8?B?V2JEQi9USlNiQlp3bjROUkF0Nmh0NFNWVmd1YmNNeTlsNGYyb2YvY2VPZEcw?=
 =?utf-8?B?Q2hpQXJMVU5KVEZ0TExPa0FBZFRpOFl4MlNIRGFPN05MUy9ONUE5Y3ljcGJJ?=
 =?utf-8?B?ZDkrUk5UalhsUkhHTWY1Tm5RQTYrQ080V2ZiNWlzTk91NC9mWVFFZTVHNGY3?=
 =?utf-8?B?QWhUalFJdVpQSDNLVlpZaUFrVS9RV2c3N0RSVnlyRGF1dFNpeTg4clYzZHVT?=
 =?utf-8?B?dUwySG8zeFVEQVMvMThzTHBzSVJMOTFvTkxyaFJZK2MxREZiTlhDTk5pNllT?=
 =?utf-8?Q?hG7yYwGSn/o7S1dLIGani/36iQgBAsiR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8059.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVhsNE9QWmdqalkrT29kVU1JUS9ZYzlCVzRtN0J4c3FUL0dkL2ZsdVBPOFRE?=
 =?utf-8?B?WGloOThmTEd3WnZ2TDV0OEp2Q1kxV0dpWS83U1RtMGpBSnN6eE44VXNGSXlG?=
 =?utf-8?B?OEd6T0p3Z1B0R0U2aFFBUzVyM2M1bUQ5RjVwc01wZDZScy9DdkJvNGtmaWN4?=
 =?utf-8?B?alA2WUk0Zk9JbWpkRDdkN092NHRsbG1kMFFvYmNRc1lTMjlMQ2szTjNqYTdZ?=
 =?utf-8?B?RlMwZFU1SnlVMlJaU2xTMmF1cGFDYUVCREpnVzVBTVp5NkNaaE9EMy9xczRL?=
 =?utf-8?B?MmxxcWEvNkVETzA2S2UwRUszMXlyd1BGVnF6RG90K284YmwwT3BvME92WFFH?=
 =?utf-8?B?dFY1SXRZMDZZTCtSancxc2NuUjlXSW1TSDg0cVIybTBQT05lNWhFT1VudjZU?=
 =?utf-8?B?a2NwdVFsMFc3V1hsTkhuUVFyODcybmhSdTd1c2xFV2VPNUlNOVVxVHBKOFA2?=
 =?utf-8?B?OHFhbXA1Y200UkpwUCszYXlxQmJscXZkVkdIdTM0ZkVSTi94TWhuV0tIbHNI?=
 =?utf-8?B?blp4aCtacjEyYkJVVUJVaGNqNGpKYTJhajArbHJmODh0SThFaGJZR05lWmxU?=
 =?utf-8?B?MzJJd2E4MGlMMUFtYnRJWFd5REl5U2ZJSUp5UUtaYWN5S01ialBFWkVuazU4?=
 =?utf-8?B?c0tIR1NPemRxSnV2d2lCbzVITE5aaFhXTWZ5QmNZWlpuQVZtR2d2bC9QT2Q0?=
 =?utf-8?B?QVJLMm01TitlMWNvb3ZIUUJENGRKbG9JejBUMi9ORk51ZE1iaFhVa2tmN0cz?=
 =?utf-8?B?SUpKRllGZ0RocVROK213MllPME4wL1cwMHBBb1dLTklhUVlsbXV2bkRmSDBG?=
 =?utf-8?B?NHlGakpXOVdIM3pWUWZrbi94MUl1dlU2d2FuTGdQVUluY0xwdFZma0t6NTBN?=
 =?utf-8?B?MU9waHAyTHFMcldsODFGSFNsaThNa1NPTUJ4MGMwMGtMRnROQjlQOGpqaEVi?=
 =?utf-8?B?YXo5R0hMNEhGcGx2SFV6bkxYbnJ3UE95RnNBS3VSOVNhdkJBOXNaclQxMWxO?=
 =?utf-8?B?bWNQeFV1c3FHU1YwakJMRnFGVTlJZVZUU21yMnd5SnA0V20yT1NGaDFrUUNZ?=
 =?utf-8?B?QnorTzNJbGZ0QkFreENKTHg5T05PVzVWNDZXR2JJL0hOMDhoeVdadzdoelB1?=
 =?utf-8?B?c3RTZVZNQzRpZXlnQjNmM1NrNm5YQUlsOS9YYXRhS05jZytrSXI1ZGZ1cTRX?=
 =?utf-8?B?YVVJc3lZRis0MXFUUlNxdkJBSHBRK1pZTnRJMDduTDNQZGVnREhLS1dDQ0JI?=
 =?utf-8?B?ckw0VmRycWxwTnY5RU5xcWl6Qk9OeUpzVXlGeUxEVlEyWXJsbnZiWGU4Q2hL?=
 =?utf-8?B?ZHc3alQ5OUlSbE16VFQrY0Vya3ZWeWtJb21zTDMrY25IUnFVRzNLa2JCMlht?=
 =?utf-8?B?cW4vY2JCdmhhTXdTL0NNakxsZFdBZ3plUExuMmFiZ3hEMlVQVG16enZrREV5?=
 =?utf-8?B?anl0aW11NlRWeklWTEJxSGk1OHlKc21jZzJpaFFIdlVBd2JIYTRFanV2bkwr?=
 =?utf-8?B?a1E5ZmR6WExJQ0dDbjJJOTZHUHFianBlVy9QU1NKaEx6dy9KUmZYbWUvZmlN?=
 =?utf-8?B?WnNDUEUrVlVPZy9rKy9ad2VqVG1HcmVFR3NnK29zVUR5TmFrQm5ITU5UQk90?=
 =?utf-8?B?NGZ4S1hrM21EYmFybDU5ZjJteXJqMC9qWHJrM0x4R3NoTFhRZlRaRXE4Rzdk?=
 =?utf-8?B?aE80aW5RVm5wWFBGTTd5NGZyNFRQb2h5b2djWFF6cUhvSjFFMDlOZmptaXJw?=
 =?utf-8?B?VStNRldGTHdhOHJZQWkxa3c1SjV1TXp5anBzdkkxaFY1ZHBIUEdTMng3dzdR?=
 =?utf-8?B?TkZTVnd1Q3NodkNpTzYyN3YycTltckdLM0htbVQ1bCtVTUtEdFg5T2pUYkpk?=
 =?utf-8?B?aXpucUNmV3NNdVd6dU44aGZzZTBaOSsrMkEzZ0pHSmxlcm11NjFwRUJiY0la?=
 =?utf-8?B?Q21YMEs0ZmhXNlA0MyszSkRpcmpBYjRvQUJaR1cvalZLMGpocDh1eHFTMTRS?=
 =?utf-8?B?eDZMQ3ZmM1FYQ2lISWJOUHgydmExeEhYQU5zT25EL0t6SW9TYVBxZ2FUVVR4?=
 =?utf-8?B?bFQ5N29zbTZDVi9iOVdJcEtwWG9WSWJqOThBUEpxYUVwMCtvZzduOEhqODBF?=
 =?utf-8?B?eThYQ3RZQmVUOG5SQnhrME8yZStjb1BLSDBlcmdRdFB6Sk9JSzg3M2JORzBt?=
 =?utf-8?B?OWpjRlh4ZWJQNm1iTHFrbDZ6cUIzb3ZUaEw5K25MY016cGVyOTJlOWJpNE84?=
 =?utf-8?B?Y3JrMlNRNXdVVS9nNkhaMEZ0ZHM4WlR0SWplbXZya1luNk11SGE4TzhIYU03?=
 =?utf-8?B?WDdFeXc0amVGenpLVVpCcVhjZmgrQUxudkh5Rk1DS05Eb1FGTjdpZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1801a9-09e0-4ad6-ee16-08de3f4f6950
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8059.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 22:39:03.6310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXw08JUWuQb+/unPnetnKDwXHHxRlLhAbAGsuxGVpnT5x5jKhy2iuVVfZYx1BSivSFt/XCJrU/oD8I+WYVTTSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8695
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D2672C0004
X-Stat-Signature: jwm8xkph3t13mu4m8a4ugn4931w8w7n4
X-Rspam-User: 
X-HE-Tag: 1766183946-749328
X-HE-Meta: U2FsdGVkX19xXbaKNSdeeEUKM03bgYvf4igRih+txU1t7/jIMtsJb/yDlSRkiGeHAu/KGIqH+CWfzFe77N5FwGrFl/2M3m85LT1csHPH5FrQJNzqTDK+nM1QStCOcztHys89AsmrVB+m6ATns371XpM7YZ+kX1GuRZg+E2e8Css2AvIMvYuTiooL8IrAVdELIO8VCu/JXGmlI3KpsI0wh4y+Evevd4MMkT7PgP1bOjoVzP9nrpSzsMxVpjmYo4HTdlmtXL3cffu0RFJL+TpRs26dADais3c9EqREG8d2D0LfuCQznj6Q25MXrPPjp/cn+4Q1ylukbWv1yAFgwNVYKRMJMAWTTZfEvw/uZSZ0gJfHyfpuVk6j86zHklGpgu4As3Lzc7MaQeQInya75uqpyMYehdAJ1dj90c3PSbuM58Qn60naDC9ZZQOyaZkUsMP3R8jWbnujX6DIqWjLh5idcuJRAmmcm4jBpAitaYH8otMH2JFjLt5h2A/+Cvh/VsOOw2cy7qrijOnRxir2Sl/shJ/wkjU8pwSyiKsVlFRdVEh4aSJRj07kvLmX+XJttwwU4NDXUVpYMJgxsIggNU/th7ZzbjjPL52zxLwyPzyFPPxDAURVYzVdm+otryvVmyIFjq3mXus5wB5owkctr5KsWZ0jnmwaKtnHCbiDbahz0y1GEDe0v68ba6ENYaW4gXLkUp3ctP9hu8q7CXsrPhC2fbjCtXjFQlc4x5RqEd3med9F+4fRdl+HhZFaAr+flm3VfPj12KZ3RR/rIhXkhrFH5RLoi16ctcgOzAtHm/e83Z7b377VPpHHYHoPeMw7gAFGnuMATEssZiF/Zqoq2wrt7wXMtB7hjCCtSgBfl6LxkpN4mdbrfxEINqyRQxVjp6UfmAH1/WFoBIBHkuQIWwWxwXGzjwhnHLbrZk85LoXfH5tnYJbBQyYEUYXt05yzOF+VtoT+2Lav6bTcIb+C+L9
 QuXa7Ymg
 n/Z1k1cHXhUWQYiCOtd1elTpGPJmbQgSm9ULTp2V8ZW/TvAuRyrqFy9KEXslisAkCantpjU26AaoGF72WDv1OBW3dndDm3/V1QLG/adETVHqwUdrkZ6KEVnzsyVWdLUwb6FtAHKuSAVhQYS4LARlrwITEvSZM4DHnt9yFI8EKAaPQf0MPue0p47yOkVY9TsbvYzVLa00Xv2XOBpygdr1bFw76o4+Ipx/+hfQCXynDtJQyGkhmPV2AWvM+NlpQvuRPLzUoA9OIdB9RyFGsHsHc6lBtEQtre1PaZ/DwKKfhBbEezr/n+18ama5nb3ZO5Sp+sjvfjO0TB7duiNouzVbQC0gbYEu0HjTKe4U8N8HtTweiax9fwYU0VuX/1A3sTyRIBhYj4YsJ/YhDnejiH9qeNz5QZHahodVWniz9OqUUFyKUiqzahp4b16iaT1t4QpMBLgg8ZJtie3GSgynZ6iF3DngQ0g5D+nNqsRFzduAjfO/Bqzw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/19/2025 5:19 PM, Mathieu Desnoyers wrote:
> On 2025-12-19 10:42, Joel Fernandes wrote:
>>
>> IMHO the overflow case is "special" and should not happen often, otherwise
>> things are "bad" anyway. I am not sure if this kind of complexity will be worth
>> it unless we know HP forward-progress is a real problem. Also, since HP acquire
>> will be short lived, are we that likely to not get past a temporary shortage of
>> slots?
> 
> Given that we have context switch integration which moves the active
> per-cpu slots to the overflow list, I can see that even not-so-special
> users which get preempted or block regularly with active per-cpu slots
> could theoretically end up preventing HP scan progress.

Yeah, I see. That's the 'problem' with the preemption design of this patchset.
You always have to move it in and out of overflow list on preemption even when
there is no overflow AFAICS. My idea (which has its own issues) does not require
that on preemption.

> Providing HP scan progress guarantees is IMO an important aspect to
> consider if we want to ensure the implementation does not cause subtle
> HP scan stall when its amount of use will scale up.

Sure. But if you didn't have to deal with a list in the 'normal' case (not over
saturated slots case), then it wouldn't be that big a deal.

>> Perhaps the forward-progress problem should be rephrased to the following?: If a
>> reader hit an overflow slot, it should probably be able to get a non-overflow
>> slot soon, even if hazard pointer slots are over-subscribed.
> 
> Those are two distinct forward progress guarantees, and I think both are
> important:
> 
> * Forward progress of HP readers,
> * Forward progress of HP scan.

Maybe I am missing something, but AFAICS, if the readers and only using slots
and not locking in normal operation, then the scan also will automatically make
forward progress. So both are forward progress of readers and scanning related.
It is your preemption design that requires the locking..

Btw, I thought about the scanning issue with the task-slots idea, and really
synchronize() is supposed to be a slow-path so I am not fully sure it is that
much of an issue - again depends on usecase but for per-cpu ref and
synchronize_rcu(), both are 'slow' anyway. Again depends on usecase. And for the
async case, it is almost not an issue at all due to the batching/amortization of
the task scan cost.

thanks,

 - Joel


