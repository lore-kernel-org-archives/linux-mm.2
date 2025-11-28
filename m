Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBFFCFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 08:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 190256B0008; Fri, 28 Nov 2025 03:57:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167306B0089; Fri, 28 Nov 2025 03:57:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0559E6B008C; Fri, 28 Nov 2025 03:57:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E797A6B0008
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:57:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D73613A774
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:57:42 +0000 (UTC)
X-FDA: 84159412764.25.692E7C5
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012023.outbound.protection.outlook.com [40.107.200.23])
	by imf28.hostedemail.com (Postfix) with ESMTP id B9567C000C
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:57:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SG6aNptw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of jonathanh@nvidia.com designates 40.107.200.23 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764320259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1haSm82u0cDFD0ojdncpatZ4ruISdLbQoBAS3fwaS8=;
	b=b/jLalJLb1VqW+LBfPegzFC2PWmJd2VtEZy4IOFWU7L5NciBY05B2x8/ONnB+z37+RS/gj
	HVdAXqTvMvHeO1mQVariR5xegxHhojXqGShMWkI8KAnuQuAJzifAPDPVDjBCZayMw61OLX
	SUErsXz/h6uO5WxadFGzqNemLhJPiu0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SG6aNptw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of jonathanh@nvidia.com designates 40.107.200.23 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764320259; a=rsa-sha256;
	cv=pass;
	b=Q4z7aPd8gCz+PqQJg2czRKwJIWTvdQwR/cCd6GJwsuvZvtj1MhgR3kwDUL2mHD33i33YPK
	4RMZGJ090VVA2DCoL/QlnFTtcdx3Uy0j/KIGlKbwEpmrk5RbQg8486LaAY4vgFKwIP0FhX
	m9JC7fNWDhbRGP4wv0BWoWtXO1r6HPQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TbQNPx+sZtIlGM978Ky7NcaGk6997D5w57NKgF8fsjSWzCxWAXq3LQxkJSwTmZSHE6R5TxccHXPfkAP9AArUxs9UxmdSAz5bFBl2TAMnpuGj6PemfEl32GBh5MydAxNjAqiw/MhtwT4+YX83/holhbhVkTbU/DADXjHkO3+ThhkBJlsssbZ3w+pv1lr60bxmIgS7CTRDwspftLMDNUxchTGWyFUXFrSarFPhMydzhyQWGcYykaZrano5MYEW72h8fnfg1urQFXQgEbNahh9Sc0vIfVy7+DQIujCpNUR7rbQuNPCQzwnMgBUzbm+3d51zsmmXR+CqypEH2neKlmQexg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1haSm82u0cDFD0ojdncpatZ4ruISdLbQoBAS3fwaS8=;
 b=PiArZE2B2mcO9T8PjpviZ8BHBRw+UFT5FR3ehTqOQdkATFZeu4qXhqYzu11E+zEF3nETG/kN3kPmQIERcOsgjLymeoIKRlHi7LIvu2yaE2nBBeajH2zzOC7Ll+S0//t24hlNUyPEiUcRe2IyAe9TmlMUlUfuGYJisyiLS7TyvukZSxqvk43ERfkZQ8fw4VbXV94LRHYDM5AJq/x+sEab/dhMGk20oNEEYsoSgcBl3htR1c30BX3fCwGjwpopharGW2ZFh1HwTWvrbkXC5MI5u0ruA2yMNTpgfZd5PwHawptsvjwgil4RWV2EDagNFxZr0Lx9v3WOqWAtwMJtesw0SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1haSm82u0cDFD0ojdncpatZ4ruISdLbQoBAS3fwaS8=;
 b=SG6aNptwEdWTSSRv/zSmsifxQjON6VljkfOP7ZjrtFuLHUf3B7kBQXGNUOCHVzpxyAlCIeCqa6wf91qW5KfH28RGwadfp/oZXUf/XuePQeSFuXPVPzFVpfHGMzF/0gZo5mAu92UPlefSWzkqnuPfn4qcPZFkMyaMJT55fXEOC6i5Q3y4bxdqGD9I3JHiIadEotmlz0+4dKxpyIjbKZL/nGBmmyWrMnFgrD1xrCCKBpCs+28qdQFczPzEds4njJXzcM+xBm8BUCb02KjUO5LzL4cMpVgNkJ6EdfVIwymVWCIi8CHDwTlg2wnQgXF7e30wwh0sfqChupSzItjx4xb3+w==
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by CH1PPFE5ACC0FD2.namprd12.prod.outlook.com (2603:10b6:61f:fc00::629) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Fri, 28 Nov
 2025 08:57:36 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%7]) with mapi id 15.20.9366.009; Fri, 28 Nov 2025
 08:57:36 +0000
Message-ID: <ad9c6f4d-42de-4251-ab10-579feec7e8d1@nvidia.com>
Date: Fri, 28 Nov 2025 08:57:28 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu()
 operations
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, linux-modules@vger.kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org>
 <e988eff6-1287-425e-a06c-805af5bbf262@nvidia.com> <aShFKpqPTgqshx3s@hyeyoo>
 <aShIqdKesZqEOELK@hyeyoo>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <aShIqdKesZqEOELK@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0163.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::6) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|CH1PPFE5ACC0FD2:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ddff685-ffcc-432f-35fc-08de2e5c2ce1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TDNrckVoWlFDRTE3S3J1bkxwNFhxUVdoRWdNR0gzUnhFQW1lcmRydFVDS0tY?=
 =?utf-8?B?dkZZS2dTaitwazJMWEo2WjBKSUh0c095RStOTy90bktEZHorTkdhQ1NlVGJ3?=
 =?utf-8?B?dEU0dHlTTjNBRWphOFV3alZiZ0tTUllUYTZyYXl3U0JSK0lFaWxkeHpYT1M2?=
 =?utf-8?B?V1VWZ1BEdjF3UHZPUGdBWndLZUZXYnlMSHZFRnl3NlB6elJtNDQ0MlVzcyt1?=
 =?utf-8?B?WDNJZ2JWTU85RDJ1cW1xWFMvNHNkWmJGZ0pwMjZsajRnOTBFY2xNZkFkY09D?=
 =?utf-8?B?VzRYbndKNnBZTExNVUdxTzhCWUlmVnhQeTU2SFM0L2N2bm1SR3BBamtzZ3lE?=
 =?utf-8?B?a3BuZitsUTlscE50WVpPSjZ1OWJZMDkvUjlYL1BRRU9NL2hUMFFqZ0N1SUVi?=
 =?utf-8?B?Y3prNksvbk8rNkR2K09meGpURngwLzVsOTVDb1dNaTBPSGhaQzM3YXA2WWUz?=
 =?utf-8?B?V0pEcHJWZWE3L2pYdDhuemxTY3RoZG10a2dlSEFUWjFvbUs4SUY5cy95ZTJ4?=
 =?utf-8?B?UXZGZnFzZ2EvSjJ2STNMZ1dsSy9MQThqZ094SGsrOEZ2bHlYNTNyZ1BZS3BM?=
 =?utf-8?B?TE8vV0dYaGtNd3orOGZBL2xQYi9zdnZJQlArS01PYUlJaFRMUEwwdlFVRG41?=
 =?utf-8?B?SnV3TDFFb0ZrWWRNUmRwSDQxQ0IzMXVuWWYwVUUwQnZ1TFUvcUF5WkJyTk1o?=
 =?utf-8?B?eWR3Qm1GeUV6M1FSck81eVcvN0M1MXg2c092dDRLdlpxTSszaHFVWlJMQjNO?=
 =?utf-8?B?R1hyaGJlbTNEMkx5TUZxY3JubGJqWW5YbUxUbXluWlMzWU1Ib3dtVTZXOGxP?=
 =?utf-8?B?bkEvaGQyajUwSE9LN1hINWNqdCtiQ0wzTE1XOXBlNWlDTzgrMTlwYTR0dGdY?=
 =?utf-8?B?cUY2MGlZdEpxMmUzaHFDNnc3cjZoNmtzVHBJYitRby9ja0xRT2FoVUxGU2wy?=
 =?utf-8?B?eko4RDZKZkRsSllNNUNhSGJxbHhJYVJJNHJpaVNsQTFyOGdtUU5Jb0RSWHNF?=
 =?utf-8?B?YkR2SVd3WVJwcmJxMkdlWVd0UG1DKzNvd1N0eE5mMU9uN3BpWXpkZjR5Mzk4?=
 =?utf-8?B?UEJ5L2RqME1mMWJ4dE96VjR4WHROOEdWVlNEK280dENFM2xFKzJiVm1RTC9h?=
 =?utf-8?B?ZE9yZ0ZHd0JkL3Y3cFlkTDY5M2ZSL1hiMEtoMHFmamszZGg2T2ExSytNZytV?=
 =?utf-8?B?QWdHdjJ4RlpvaVBPejZQakJzVE1DVFlCOThTbkZQaHdjOW80UjR0TjFsbnRF?=
 =?utf-8?B?YnpTMWIxeVVEN0FSLzBHbzBXcGpSR3kyMWFGbytKUWhKT1laY0c0TFlUaXY4?=
 =?utf-8?B?UCtWWTRRM0RkNk5odXkydHoxdE8vUkRzZDY2NnFmVDFVcnhrNE5pK0luYWVR?=
 =?utf-8?B?UWh5UmhWeUpxNmhLeHo4OEV5M0k5VmhKZmJPUnFoMkJtZ3RSMWlCY0NKZjR3?=
 =?utf-8?B?bzgrNGhlM2VBSmxRRjlzNmtIeTJWRnhLT2J5QmxFV29aam14cGNqK1h4cGNE?=
 =?utf-8?B?aldQbjRPbmNsYjJwK1ZkRFF4ZEwxY2QvTmYrdTNzL3UrNHo1ODRoZlY0ZWRT?=
 =?utf-8?B?d3pxUFozN0ZZampZS2M2QVhZZjhqQVREYnlneXVXYUIzbkVMdFdFTHFBY2pV?=
 =?utf-8?B?UER5YlRxT0R2QVcxeG1sMzlUdUQzanZ6MlVpREsveXpNblhkQk8vdXpUN3Fn?=
 =?utf-8?B?TkhPUW5hMGdoek16U3lRY2lMUXNvME5hVStVaTVLc3lZTjlQVHAvYXFibG8z?=
 =?utf-8?B?OE83TlNOT3FxY3I4VlA1LzVBeW5BZElZdFJCajhQNk9nRDc2cVRKMS9zV2ds?=
 =?utf-8?B?K1I0R0pmNUpMLzM1TmtXODIvSUhNMGgxc0RWSkZiRVJZQjIrUlJ4eUFaQllI?=
 =?utf-8?B?OTBCaTNEdS9Fd1VOUU9kdFdiQytONDc2S05kVndJRVFyWWhtc2lkcmgxSFRN?=
 =?utf-8?Q?w9/n7oGxqO71Kv3A4jy+9KnFybEXRFGM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SVcvQnpOemRKWDE0MHZzL1dZY2IvVC9HM3luQjhMUm92Y1F5WmtDZ3RRZmpC?=
 =?utf-8?B?U282Q2ZnTzIxUzBlbWRPUE9DYWdZOVRsRGtuZm51QWpSemRaQVo1S0djZXAv?=
 =?utf-8?B?Smc5ZkRWZXFWQ0hscitYUG55SmdyYlh5cDh5UUxKcVM0Q2M1OWUzb1BYeHBE?=
 =?utf-8?B?eG90blA2WUhoSDNaUEhTbC83aXFlV2sxd21ZZStPaksyRHV0ZGZRNmNKQW5r?=
 =?utf-8?B?TnFRRjdFc1lnaWpOTHZiS3pUNloxRm9FeVcrRGQ1Yk0yekRRdE1pZU0vV1Uy?=
 =?utf-8?B?cm9RWFV6MTFwNU5qTklZbHIzWk4rZ1V3bEIrLzNRTUlLcE5iVlZsdHNCR2tX?=
 =?utf-8?B?cHpqSzJQYThRK0x0bXdTZUVTVW5Qelgvd3BEWGdxZnk4RHRhQWFGUVQ2Zmdk?=
 =?utf-8?B?NXpHdy8vYWUxcWhqNnRRaStCdTdqREEvdktkb2dMNXVFTmtISlNQc0dNYk1R?=
 =?utf-8?B?MGZqbFVDM2V6NzZqQ0YxSUlPMU9CT1pMbXNuZGE2Q2dodERLVlM2dnQ4NkhZ?=
 =?utf-8?B?K2xJQmkvKy81MmQ0dnlPMDVvZEZDcHBtK3dIN3VHWDNuVkFMMGMvdXZrM2JO?=
 =?utf-8?B?Q09WbkhoYVUzcXJQYUkvT3QvVm83bmcwM2lkYnZLS1k1YnRrekZnb2Q3eWRv?=
 =?utf-8?B?SFJxSVFqWS9WSWtSUE53WEhzTmE5SVdadktwa21pMUxlcXFBczM0c1RoaEZy?=
 =?utf-8?B?MEZRN0lTd3FaRzlJRUdLWXZnVHBrV29NUk5HMlAyenc4MVNHRXVYV213Q0pu?=
 =?utf-8?B?bVB6VFdyT2MzOE1jaUJIdWI0eXlHbnFaZGdWaHJYaHRsbG9HYkJyRnJEUVJ1?=
 =?utf-8?B?Q045L1lDL0JJRXZwU2JUQjIyZmNiUzVldVhsbU5kWGovVEw2aUNvckxEeGxm?=
 =?utf-8?B?Y0Y1QVh5d1YweU15RFFUZ2hYdHRRVmlhMWVOQ2NVd1ZkbGtTNlhyNXZOczd4?=
 =?utf-8?B?NC85SGxsL05VOGNJZEdUMFA3Tm40d1packttcU9IT0ZmODdVN04wcnpTaGtC?=
 =?utf-8?B?QW5wZjRuanEzN3YvWEpWVnBidEY0bWpUZTE1ZWxTOEZGMkhmczRIVmdLVFlC?=
 =?utf-8?B?ZlFkODh0bHZuRWR1cUJxZ01CdWRVZXp5K2tlc2FwWFl5RXhkSWpmdUlweDIr?=
 =?utf-8?B?dm0rb2FwOWN0dnZSUkp6NHBreDZyZEpvUEtHQ0MvMHdRL2VyeVlLY1lIN3B5?=
 =?utf-8?B?R3c3QURlVStaZTdPbCtZLzZIN3N3d3lCSXhRMm40ZHM5NXJRUXZiTnZCZ2Fj?=
 =?utf-8?B?WlJSTVV2OXBYTGwrSWFqOEgwb1lnMmZUOWVLMHpwaWwyamdHTFRjckRlY2xU?=
 =?utf-8?B?TVorUDVXRGpYcTZWRjRJdXZXTjZRUCtWUGF2bElkVHhMOUlhVEYydDZvc0FI?=
 =?utf-8?B?SnBMMlBUQXM1Snh4SlZYTSt2QmkyS3VQRFRWcE5RQzZsaTZ0b1JYWGpQVDlm?=
 =?utf-8?B?clJiU1hWZmo5ZkR5V3FIWkFsVkpHUEw2eGtRV29aSGVidzBoNHN2cHlxcVNV?=
 =?utf-8?B?UTRLQ012djNRb1FFdGZtcnpsbm1KRThUUkhvNll0WTUzaWVmb08wRGs5RW4z?=
 =?utf-8?B?eDArOWVzQUtVSi8wWUtGTVpodTdtT01TOCs1eFJ6RVAvbEh3Ym9Wem1vdVUz?=
 =?utf-8?B?KzNoME90WlBOM0FkdnE2NkF6RldsMEhWR21ZL0NDK0NNWDNSNHJJdkgwR0dh?=
 =?utf-8?B?R0pQTmNldXhnYkZtblNiRzM1UVljOUlhekZsQ1JvK05CazlxZXRrRHFOZmdi?=
 =?utf-8?B?OFZpODhaNTBNLzd2b2kxVkhUZU42YmxzMktHVUpaQXF5d2FjaUVObkxJTURU?=
 =?utf-8?B?ejg4OEF5ZmFqdkNoczFZeXpnalZUUXQ1dGpscXk4QmhKczZHOWRERVZGRS9q?=
 =?utf-8?B?K3RrZWlzZmVHM2t0ak1PUklBQkNpUjBjZHJuOUhvOUlOS2VqK0FKKzRrN2Z0?=
 =?utf-8?B?T1pkdE5yL2NSbS9weGVMSytGL2djd1htelRUeHYrRk50blk4Ny9mdnVYbkhj?=
 =?utf-8?B?OURyYzU1RWU0NGJlQXpzQUlhU2pkQzFXUmJyRmRQQXAvS1VUUGFKZTJFVkhl?=
 =?utf-8?B?NjByT016WTNXS09nYStmcEtjZHFPTjRPSyt1UXN1SkZTWFNlM01uQ0F0OVpr?=
 =?utf-8?B?NXdtRkJZMXZYRWtsZlMzekJ2Q1ZBOGRocDk1YTBKTXFYMFJEN1BIQUlGZzdm?=
 =?utf-8?Q?EaPFWOjCbefc62iSbIG264H+eEvG47KSadHVhXafJS+s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ddff685-ffcc-432f-35fc-08de2e5c2ce1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 08:57:36.0569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RLgh9GowfTzN8EzSk8PHW5JBOQWCZ+LLtiMC/YzOERDUdRSmGhFp34V2EOGpJGnBZYQVKWneqwILr8C2+Upzuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFE5ACC0FD2
X-Rspamd-Queue-Id: B9567C000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xoc8sm9tmxsjuc3j61qb8uw3uh9korw7
X-HE-Tag: 1764320259-467386
X-HE-Meta: U2FsdGVkX193Kq0SL7uVB7C4QLAxiYYBks+Kl0Zh95eO4qhZdSQZtutzCFjP2TpdyKIAXifshzLHmEY8GgoFq5IN/Gk3LSQx3cp5n6yfZj64MqWJpJy8No9ildwgZx5rl5ZSE/R11haLopSz7D1kXbqcEpYbQsnePhlCUuQ7kUEf6olQp76eHUG6hDKu1IyAwLvtF0idYRveNRzR41gf6oOIob+j08vZNDGbcBVeB2B31jjQX+xPiSwzSANjLGALbO1uVg8xsex7/ycELBd4hHYLlIzDp42msN7lAg55s+7uf4JHEZh9siu2MUM293AvzI84tkHO9QiUDmdrS5JAYADFplrFrFjGp76OF3gf0WiOP8+p78Bsn4m40v9GvvQXNL9EgXR4j/vr4rwkCMtvxejdc7v4u13q0wcNp0rdOriUIYAsHdgs2UQ2C/vaJ224xVDsAPSwQYRVH/kt67ItMQEwDvaSKJ6HY4yle/W+2EMdgZ7dMn4tWPQPUGJe7jOlgKCZ5q82zX8Ka1k/TGmj+44vzMFq7EbnIWvENvMN6AsngMXIFmYonV9+XWsNx8W9yBuUvB9nOTo0/qv5iCmonpEH+RRUrFQOJfwmcXZvWHIqMyVJpa0UeD3oIxXtAED9xtl5+iqVmmV7swKV3D3UkaNxtbthBEjiiIS2nQ7MNi3fojTcvgVCTqwm5Pn0qjKAotYcrVg+h7GwNDm9ERs8XE3lcQkNwtM0PBas7dyg2qSqy8V1VwjD3kLVLCBn93O2JmzJXIJlvEEwwABk5rnbncbNR3Bayth+JKWA1FrLWP4ZsC1HADrrRWiTGj2oQxwV4/pRSwl3dIW9dI4xqn84AnqrkOMCbrtPU69PX+NTrlu+Ls/+7v6It+Ez/mcKTLM6oIBFDO0KkeSEcQ5qBnK2u6P6F+o3Ih/zXD600sb+YsipQUlgpzBspfg+SWS4PA1DVBBIxtcOz0UqK6fFJW6
 dHTZzgTI
 OIgpnzNDEhv4SNPO976270im8hoaq0xVuRlrrA2It0OGA0y86hGAInoO4Iy80HEM6T5c8tXlcIxH2Mpdq4q+SiPNU6A0utSrbjH+mZrEjFIDHP5ufVWY2/eDIVmBdEp6kwTvdijArXR5vGwWJcrsPTDeOm3fPkXZVlO3j0FhTuG3i2d0mLK0tL8dfk5LrfofWCkp39G56yoNMt2HTH/AtwjDFVShRXO6Jqqt7o3xHHq6zM4ChL1BdY//pgU7S651PtLEQU0tD/W2mSATWgkdOZaBO9gghDjs+dl+iExiWyyhxbSUO3GE1loHGq3aO1QbGYjDFfG8qe/zvbjx9VCBtGOEwt2olOn6+Y0fzkFdcZMZI+ug607PQufXcF+AkcjstBzcVm0iZXkHoV63d9p5O9I5V2jeGejUQxaNxJ0yQODj33JiBBCcFf+uVaphSIG4984s5ohBcHGV9C6WNzAbp3IZeQkbWqH3nwGbTfyK2IbuC+iS8Mdj2ffpDJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 27/11/2025 12:48, Harry Yoo wrote:

...

>>> I have been looking into a regression for Linux v6.18-rc where time taken to
>>> run some internal graphics tests on our Tegra234 device has increased from
>>> around 35% causing the tests to timeout. Bisect is pointing to this commit
>>> and I also see we have CONFIG_KVFREE_RCU_BATCHED=y.
>>
>> Thanks for reporting! Uh, this has been put aside while I was busy working
>> on other stuff... but now that we have two people complaining about this,
>> I'll allocate some time to investigate and improve it.
>>
>> It'll take some time though :)
> 
> By the way, how many CPUs do you have on your system, and does your
> kernel have CONFIG_CODE_TAGGING enabled?

For this device there are 12 CPUs. I don't see CONFIG_CODE_TAGGING enabled.

Thanks
Jon

-- 
nvpublic


