Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C08D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 06:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA166B0006; Mon, 15 Dec 2025 01:14:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1AE6B0007; Mon, 15 Dec 2025 01:14:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0696B0008; Mon, 15 Dec 2025 01:14:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B85FC6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:14:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D3D713C45C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:14:28 +0000 (UTC)
X-FDA: 84220691016.29.37152EC
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012050.outbound.protection.outlook.com [40.107.200.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 659A740014
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:14:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Lh8Xn5zz;
	spf=pass (imf12.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.50 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765779265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpsWtq7ddPrODWfLI8l34tr9g4+BTFVQOz/mzUXBJec=;
	b=MdiWqH/tseqj5m6yLNqJEoLQNLr/uxJmJSUFoR9z+POOvLRLASb6fyLPZNJT9YhpCNrvwZ
	UI5PAhkfm5IRP6KkyzT4HRjbwpovrIQtoSwPdx4S9VdNdVzfn/NozpUelJ1mnfeN5laCiP
	JT3gQdFZLxAUcjNbSwN/KlH2IGokXO8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Lh8Xn5zz;
	spf=pass (imf12.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.50 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765779265; a=rsa-sha256;
	cv=pass;
	b=cOHxsqk79gL5Y3qnXuC4OgV+FS7FiSoFPwoCFYhJK/7qfyRocGmOBHylzsHEwhJM6qjgJa
	mGfqoCSTm8N6FD917AL+DgSZAmSV5aZEdSAWgbEX8iARfK9UpNzHRHoS17rOc5a5aNyh7i
	1SZjXOlNTB9b0HAMoKh08ScK8QYZfEM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ip7eJAcizm9MtYJ8eTpFvT7wYSUGpksLvx5d0TCer62h2cw4l368cIy2rGZt/t6uhU6qc04DBsiqTrvbnn/anYBzInnnTOrYc5JKSmLUoZFVAucD/SQXAmgjNQIdi2FRuUgQR/GyDDheRGOzRYF6Ye+8T+1aqGZcBiDPsSLvuhJvxqCCjQoLJ98q5QtkVZcoonJA5EWWZiGdl+GyjbnGkOszqhq23rQn5/5Jl1HwkOOJrf+T9tGfIZBOeBro8XkqzxLN6WdfquGxEMz9ej7UIZoKXBn+TTN9VDiHRkLcEi5Ptva8FtY/lEosUGezntY8QIyOqCqfdadZLSJzgxmXLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpsWtq7ddPrODWfLI8l34tr9g4+BTFVQOz/mzUXBJec=;
 b=KKboLhTywR/vU4fAEkRb68kXfNmjHSdNbbyjwbgi17ZA+0Bd1CkUPwf8o12JVQ33PUzvvm/pTVqIX6rE4XhnKlLK+sWhXLpD7nFGpel5HO2IoqDdlZ3LB3n8krHgZyKGMvoT1Uh2728S2tAwierOPX7O54+N+CJOa4c234M9XbDQu8YJWPBAPffxbq9YZCp4+p5sHCIWxY0S0X3g4nbuupbN+7wJICYALjWqMqKucJxsrvsJE2lcNBKWcP4nqVbNycE2d74g5gj4d2V7hq1+ripImqbG31Fzg910PX6GLd5Rqr+OcbmHRl06n8Rlo4kmX0JUUnXsKbOCaPldkVT1rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CpsWtq7ddPrODWfLI8l34tr9g4+BTFVQOz/mzUXBJec=;
 b=Lh8Xn5zzPVIRaw3kYZl89KYnPz+2nAE2BGcAKCTLxuAdGo4TAv51WCydpYNcPjOgLqZWYPi0pyJiwrteKuY8ht5PO3xGnmYToaFhMv5tdcQ8p8UcidU0Ia3KAcFZwTuY8ybpdY2Esg6bDTgDQ+d9+qmI9z9WBXzd6bgGfn0fsLdGlabQ9A3cu0x1KOwbDkbMKudHzrikprNOA2bJiXlFDrc6+PYI5At4tAuDCLcLNFORxqk4JvW0ItPfnWrwfHEHGxg2/5BdET4Z3oDwHtkrjLw2QhgKGuQtaM+zU0ateSSmqUmyg+dj+fHWOWFKlHjcjb3Frr0q28TmhCV3jP6Wgw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH0PR12MB5607.namprd12.prod.outlook.com (2603:10b6:510:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Mon, 15 Dec
 2025 06:14:21 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 06:14:21 +0000
Message-ID: <dda1fab7-5cb9-4d83-8b60-f4ed75a03aa8@nvidia.com>
Date: Mon, 15 Dec 2025 17:14:07 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 02/11] mm: change callers of __cpuset_zone_allowed
 to cpuset_zone_allowed
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: kernel-team@meta.com, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, dave@stgolabs.net,
 jonathan.cameron@huawei.com, dave.jiang@intel.com,
 alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 dan.j.williams@intel.com, longman@redhat.com, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, kees@kernel.org, muchun.song@linux.dev,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, rientjes@google.com,
 jackmanb@google.com, cl@gentwo.org, harry.yoo@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 zhengqi.arch@bytedance.com, yosry.ahmed@linux.dev, nphamcs@gmail.com,
 chengming.zhou@linux.dev, fabio.m.de.francesco@linux.intel.com,
 rrichter@amd.com, ming.li@zohomail.com, usamaarif642@gmail.com,
 brauner@kernel.org, oleg@redhat.com, namcao@linutronix.de,
 escape@linux.alibaba.com, dongjoo.seo1@samsung.com
References: <20251112192936.2574429-1-gourry@gourry.net>
 <20251112192936.2574429-3-gourry@gourry.net>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20251112192936.2574429-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0119.namprd05.prod.outlook.com
 (2603:10b6:a03:334::34) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH0PR12MB5607:EE_
X-MS-Office365-Filtering-Correlation-Id: 10a72e9a-fe5c-43bb-75c1-08de3ba13020
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3RSemRPRzI5R1ZZRFo1WFBhRStEOFd0ZDMwUDV5TUQwWm9YZHg5N2kvOS9R?=
 =?utf-8?B?a2M2TEtrMHFxNDFlMDFsWlNlTFQ3NmZITWRON0NrSGtMdnM3UkRIblQxM2tG?=
 =?utf-8?B?MVYxR242aEtBSEFJTGRoREdCbExxRFV2Z3FxbGo4MWt3U2hOVGV4OEdqd1JT?=
 =?utf-8?B?U1RmRXp3TUpUd1BKUzZLNjFrR2tyQVVZTFlCeStvTE9OQW41UmF4SWQ3bDZJ?=
 =?utf-8?B?dmVzVkZDOFc0TW4wTHFzZ1F1Y1IzU0d6WEJJZCtnZWk5UE4wMEVjVHB0UGIv?=
 =?utf-8?B?MGg3cWhaRnJNaWpMYnlpU0d0YWtMZVFNZ2tISTBrZnBnSmVDSG5lZXNFaUNq?=
 =?utf-8?B?ZnZUaEtxbzZ6czkxYk1zUDNMa013MjlIb2dQK1BXZWxCVUdWc04zU1BLaW50?=
 =?utf-8?B?SHBGSW95K29GTFY5TWxVR2FGZ2pneU5IK2hVblpYNTVWU0FBUkZXMGZCQVhW?=
 =?utf-8?B?NVdUT2hLQWFzVmlaYnEyRGc2YkpudVYxTDNPN2E3SHVHbGZoZjA3WVU5b2ll?=
 =?utf-8?B?TFhUL1FDenRJMTJWTXZKMmxPa3VJbEZZbFZZYmM0TWNYeWozbTd5aE1SL0dm?=
 =?utf-8?B?NkdsNUkxQ1BCT3hMOHZaemEwbGRoOFNFRWlaMDVuUXZiVXRIcGUraWtTamhv?=
 =?utf-8?B?YkpSdUVnYUMza0hwaFFTeGRUWEJGZU8wQm5YWnVEa1FCaVVsNlk3SVdEMEhJ?=
 =?utf-8?B?SXUxRVozZGtmOGxTZzNFZ1R4eTVIdmsvNEg5S0Rqam9RbEhyN3FsVTFPOEFO?=
 =?utf-8?B?Qm1HREw0NXlnRUFicjBySkcxYy9sYjFuanluZng0VjU4SWZRNzJsc1k4Q0hi?=
 =?utf-8?B?bTVwZ2hFVXZ2MXFiemtBLzNWZzFkMzNhZjgzc3F5QUo5VTNnT2kvbXFIUkJ0?=
 =?utf-8?B?c3lJRFlmQSt1VHlZRDhCMkJ3SU8xSHE2SFhyM3pVd2VzVVVmeHdMWTYzanNO?=
 =?utf-8?B?SEpxbzFHOE9VTUNtU1BCR3MyNkxEVTRZRHVaZlY2aFJObTUzeGVhaXh5dTRF?=
 =?utf-8?B?Q25EYjd0M1VBMTdiRnRrOHMzaUxOVXVEc1lGZG5YZTc4dWhWemhzWmpFL1ZB?=
 =?utf-8?B?VklBSXJzMkUyTWtuNE9iaVVsYU1CN1FsZmdHbTl1ZkxSZTdnaDFMaUYrVTI5?=
 =?utf-8?B?dkZ1SnBRZnhGa1poNks5eDhCYlJvTzFCMmJNek5ZVTFvM3cySXpOSElFLzd3?=
 =?utf-8?B?dDdTWHlUVUJ2YlZBcStCQms1dVZtWnE3a1RKbWxJT0hxYm5oM2tjN29iVTFa?=
 =?utf-8?B?TWlpYmlqamRPdzdjMkJZS1BKZTlrK3VwR1RPWlMwM2FKVkNXZ3BVeGpNSEVi?=
 =?utf-8?B?YVpTSU82bUJhbFFVNzZzZVZWQjVzRnVaWGlIQ2Y1RmZRV3haNmE1L1RXSXZG?=
 =?utf-8?B?d2orWXVWNWNEZ1BFSHJqV0J6NExkSXlUNnJIZ0NPODlDU00xSXd2VXdBZGhW?=
 =?utf-8?B?c29ydEY5UXZRUE1xUGJKS3grd2RFWkNkOE8zdlhBVU5URlhGclJLSkphZlgx?=
 =?utf-8?B?QnFiUk15TG5CS0tMVE02ekYvSk1TVlpMK0pISUJXdzhFdmZ4MmpHWWVxQWo1?=
 =?utf-8?B?TXJuWEFUWmVFTUNNaGR2TWRkemZiVGtJSlBScFJRWllMUkJyN0g5UG9tcWtY?=
 =?utf-8?B?QWE2M0szeVo1dzBBbWl2MUpFOWF0NnRycHAxYUxDWG8xN0FUdWI0RG1CK0pX?=
 =?utf-8?B?WlcrMElYdHlXTFBhMGpmWjJtNXIyWDVSbEtUWlY0dHBOZ1lEUnp0czZXeUs0?=
 =?utf-8?B?ZG9LU2w4WFAySmRad3NjZC9ZdXhHQzdwak9SaVBlRGlaVE8rbHZzSGRxcE9u?=
 =?utf-8?B?ZW5CYkRPVHBWc1U2RkUwVXBXeWl2UTZEZDc1OXorWGJQUlpOYTNOQUxKaXhB?=
 =?utf-8?B?bmxudVZRd3d6ZThhaDFtMitiZ2N1Sm96NFZIN2YrVSszVGl3cEVxbEd5amJM?=
 =?utf-8?Q?fIy2w8E9f32b7Bd61qkWia2ihKw3wvun?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(10070799003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amVVaDlCVEdMMjdQYWhFOVhGKzZHVDNlbGlPcSs0VFFObk9WTjg3SzRINk9B?=
 =?utf-8?B?NWlFc1pzRVlmdll6NUtnYVVkMFFZRVpoOFhXOFhxZm1JajJPQWg5NHQzQ21R?=
 =?utf-8?B?WmhTT2Q4a2JNRnZHcTBwSjRLNjE3MnJMYTdFeGpFNkNhODFRZUNyeW5wQmxu?=
 =?utf-8?B?cVczRS9wN2p4bXU3aXp0SVJiZ3Bpd3l2dG9oMnhiL0d3dlltKzBkV0ZBd0NZ?=
 =?utf-8?B?elJvTU9OeVl2Y3dHMys5UE13Q0wxK1NVbVFYcDJIYkdOZk1FazBObEtpaFN4?=
 =?utf-8?B?cldXVVF5SXNJNFVIcVN0L0Zjb2JkZ2owUXhkRXNsVUd3Mng5aDVQUDliVU9F?=
 =?utf-8?B?RjlTYVFSdVdRZHM5UG9hRDhoM2s0RkYyOGZ4SnFnRjhCR0cvVWk5TWt1bStW?=
 =?utf-8?B?SnV2WW40OStCY25jNGduak5NTUU0djdocklZVy8zdU5WZXlhSVQraE9GcmFE?=
 =?utf-8?B?dCtRTVlMNUNoRnJGUzFjbS9WbEc3enVuZS9ybXdCdjJ5dWNnYmU0WXpncDU2?=
 =?utf-8?B?NituYzFpNzRUSytaQkhrSTg4UFF4QkRKcDN1Y2dLcW1OYS9SL3JDamR3TGdT?=
 =?utf-8?B?TXNJWUJESW9qMUMvVjJFTitVY3Q4dUprZTQxRlpIZDR1ek10cWZ5U2hEMXoy?=
 =?utf-8?B?QkFZNEQvRkpPL1FlYXdHdVM3clB2MmFHTHZmeXIrMjN3ZzN4K3VpS3VMa25P?=
 =?utf-8?B?Z3Z4RVN5cmV4SVRSQy9ZTnVDWFhHcEFhUWVOdGVJdE1jbGFXWE9TWHB2a0JR?=
 =?utf-8?B?TzNVV0JGbnF0OXJYNi9sVU1OWUhMQzlRWmNKSzhhTFNGK3R0b1BVS3J1Y3o0?=
 =?utf-8?B?ampQTFVrVW9uSWU1TUVYR2I0UnN4OXRabU9PSVhxV1VzcGZNYllYa1hpSGdk?=
 =?utf-8?B?K3lhWHo0SUZaTDZFVG5jMnZZdURON3JZa0R0N0NVdEJPd1h6Zi9IWldwdGhu?=
 =?utf-8?B?RGpPQktLYXhxdVg5Q1JkSGNqUE1yQ3NtaFJqa25URTZVVEo4c1ZQZ1U4dHRL?=
 =?utf-8?B?SzE3VzFHN3NxYlhMM2FVQlRLM2tmUUpWZUVNNG5lV292Q0RoUDRsTWdWS1VB?=
 =?utf-8?B?QmJYMitGWStQdXRzM0t6a01Qc2szMHpBTG03N2RWZXZPekN3WXZMb1RyWTlm?=
 =?utf-8?B?eHR6RlIwRjg2WTd3TW5jbzhxVTlicGQ5a1BSVnB1Z0p4bE1ya2J4SWlwc2hQ?=
 =?utf-8?B?b0JIekNQdnNrdXpmRThCUnlzZ2pNU3dRakhoM0lQcHUybTRPblVRSU96eWVV?=
 =?utf-8?B?T05FL1dWbXduY3QrUHRVUEdHVjY0WXl1QnZvRnBKYkZtOUllWFp3SE9OWlJH?=
 =?utf-8?B?ckZJanIxTTFkVmV3N0lDbDJUOXY3L0FDcy9rUm0yUi9FNjlhcWtWMkFpYWxG?=
 =?utf-8?B?WWhoY1BVZlh6bnRlV1hqTGJ5RlZ0Vys2KzBFQVE3VlpmOUJQcFZZU3BRTXRs?=
 =?utf-8?B?Nis1M2kwQ3A4NlMrbTdnU21zM3E1d0hCelk4U0tBbE5EMnM5bVVqWnlxSGwz?=
 =?utf-8?B?czkyNGdXYWhnN0xZWmFxd1FJZU9nd3Q3M2pPN2ZXS0lXWjdUODlQbXgzWGJQ?=
 =?utf-8?B?YWxDYzRyYVpWYkRxeDNEb2syVjNuWit2NjF1VHlWWFhNRlRJU1VZZGxmanZl?=
 =?utf-8?B?ZWxndzNxbzdMZDY2b2xHQjAwYUtYSFdsdnIvSG9QRUJSZS8wd3o1YTVRZmZR?=
 =?utf-8?B?VHVUWUZ6UkZNeFhBb2U3Ym1BSFpOemtmNzVWRXlORHlCL29ydURaSnBtTE96?=
 =?utf-8?B?cFA3UDFYWnF3TDJEMEp1WjZNdUdjQWptalgvc3J3SWNKOXc0OTFMRGY5M3Bm?=
 =?utf-8?B?YXYzY2JiWEtoK2pHaDk3cVNqb1FhbktOcDZpZnd3QnpWYTJFRU96TE9oY0pi?=
 =?utf-8?B?NDVmK0FFMUE5SHNLb2pTNXA0TzVJWlFqYnk3MUVUdHl2aWErcVpJOWFJTklp?=
 =?utf-8?B?NkdOV1RDNGVhdXozWm1rRGMwdmJyWS9EeGRnbm40UStGcUhyenlETGhQQzE3?=
 =?utf-8?B?dzRxaWtBWlRUK3JZaE9naEthSGwzMnhZT3JLYmlOWjFFc0NkN010ZlRyK0Yv?=
 =?utf-8?B?eFJlazAvcXd2ZkJuOFhpZEh2ZWdjTzB4MXlUWWxPNGVRRnVjZWdtcUVqY0ZP?=
 =?utf-8?B?aFlyd05kWWJNc25Od3d3Zm9WeVk3MjVKcW81dTQ1SHRGNW93ZVRBOUk5YmlE?=
 =?utf-8?Q?jO1/LFU6g8B2QFhAvAfbki0eUuOM6Zj4QRDMVtCRC9y1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a72e9a-fe5c-43bb-75c1-08de3ba13020
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 06:14:21.7479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +V1xyzO3Hc2SG3McMgh6ThrIyZgxflBG+ioQD14vDjcEFr0DGYQjAKXuVl5Hygw8U4qWkms6RyFluXt6oPmV/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5607
X-Stat-Signature: 3w7osmwf3jqz6k4k39bo9rhkg3j6waia
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 659A740014
X-HE-Tag: 1765779265-104012
X-HE-Meta: U2FsdGVkX1//3WLBfYBvEYhWLkw+AHFvanRr6AtKDq1/1SehDujVhdvL++AeXwe8okt+cPtF6UFIV/O1vsEs8Mf7+E5xZHroE3JKQRqUL37m0jzTzx2g4yrOqfDqoDAYQ9HKZgFNnfUD+Gn4z91tUdL4QOvrult9uZzV7dGq8F/4ObkMI4IUUrFTGvwmeIkT+dg2J/+YjU9ihQaKLLfqLdM/tjNnkpCbXvMbgK/r0yBeJvE0kJW1gbbVw+zvpcDiwpdqH6Bdgi2+KAg+K3IKhu+y8vxnsNSPCXh4cYz8iPS0C5neBMoYwjouj/AVvdM5UoFEvn767e17u9LrLjaxIvfmDAU1nKeJR/k1X5YpDweaYfjORcxwEgCdyl9LrT4q4eOzgT43sqUEm7camvq83+1d34PNF8tqwFcnEPd6Pv6DWC2ma9IFKrRiK6mkcB8ShcjDiuH4pvaS3IUc3EEGv3yZKqdh+yBzC31NunDBm8lTckx7uEI+acWQWMA0f1lRNTm3JST9gEUEjOWCy2imWgY/YM5VZpi98CjQiTA4dVCAUB0gLzDKRna0cKRJ9dUE0op4naLSx8MemTRzzla4x5dVxHD+w48+oxHBGCNpQd80CPJm7VTz389D1pXW5BsVnvofzJVnMb2PIPlS2wCEWINkUQikQfhoPmkgQtNSqaASiIstyr/PY3+wmS/2QdSn9f/VMPaNyxSif6x4Fj9eE+IYYXUUmR+G9M3OZQaJ58dBQcoYi37QxukweQGEwN8iiZVtzGjxcEU88KbRkM0ohxKqH1gQvwKVV3gGqX7APAX6OJNrgDXGf3eqxQlOGaELTfUd+Nh/TUcZRbcIrpoqpT0ELBJoktFHk5tTPJGoAOEugsRPjl9FttuOMzVpKAptuF3/Z1So5rlICCNsVl9cMbGSYhk7j4wBhgpCK9SBYdq44IZmWWOFXl8DH6Oxx8YSiyiXYCjlVJ7lznRroDN
 zfVKngS6
 aOJ8PKtOHoZoCy1TbffwIcFbySekHwjJWKxdwE1cGOEOb7JWetvd8oa5SuEynar+RlCfPSYBFvJNJgLBX9AVBM0EiumDq/gsHqVBoT6iKt+jmx9qwvtJQmrwsrU0Bl6lohD1GSVr7CnFK7mRBbkpXvnOqN/iZKtIOuFDlXC3Z1S8oAaGFoOs8F2uEsSfDUMB6xorYEh7hsLdYxtz2MabBInAVqJrsUnWUbMe8xr+QSfJ//57Fl47byyJQFWS6hz1WhDaPF5jhsppRzHt1h3rXttz+2ETXG7ARV+A5ix7JB/j/C191tczaUkNocp/oxIyElHs9Uu2d56vx3HtpxRKcf+t35a5nRxF3X6UNKUwNhvFDyCO0lPupqnQCcovDSNA75sOVni8iAsng/Pw6gAiGWMrb32AXKF7nq6yVnMTg/+x8dQ7U79tTMWxW5QY8PdNZ5YgnXeKnwzJGwO9Gaj0CTVCmZ1OfSgFd3aNcJhv3/0ZyaO1rhsXKngI9N7wzTX/KznlurJsfmYroprmM6FxJ8/Lm6VAeL9fhNdHRrukcpTEOSlo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 06:29, Gregory Price wrote:
> All current callers of __cpuset_zone_allowed() presently check if
> cpusets_enabled() is true first - which is the first check of the
> cpuset_zone_allowed() function.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  mm/compaction.c |  7 +++----
>  mm/page_alloc.c | 19 ++++++++-----------
>  2 files changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 1e8f8eca318c..d2176935d3dd 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -2829,10 +2829,9 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
>  					ac->highest_zoneidx, ac->nodemask) {
>  		enum compact_result status;
>  
> -		if (cpusets_enabled() &&
> -			(alloc_flags & ALLOC_CPUSET) &&
> -			!__cpuset_zone_allowed(zone, gfp_mask))
> -				continue;
> +		if ((alloc_flags & ALLOC_CPUSET) &&
> +		    !cpuset_zone_allowed(zone, gfp_mask))
> +			continue;
>  

Shouldn't this become one inline helper -- alloc_flags and cpuset_zone_allowed.

Balbir
<snip>

