Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89054CFA477
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 06:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814376B000C; Fri, 21 Nov 2025 01:28:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4966B0012; Fri, 21 Nov 2025 01:28:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6656B6B0022; Fri, 21 Nov 2025 01:28:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 516C86B000C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:28:04 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC6FE1404A1
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:28:03 +0000 (UTC)
X-FDA: 84133634046.02.4869DD3
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010005.outbound.protection.outlook.com [52.101.85.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 05AF820006
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:28:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FLHVTHjO;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.5 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763706481; a=rsa-sha256;
	cv=pass;
	b=BbLs6UclOYqASxHAj1gA9yruwI7LaGbJu4QLt7gk8irDMjqOXdCR0L7xWeBF/g1edG0usq
	wKbC0L6nEWgi/MT4UAShSDjCJ5Fn6WxZl2pa2GrGKT6yEh8eD7M6jk4ttJu3cZoi21fROO
	QjLA4wt++Rnn1hM2eMA4F/HSJJBDTLg=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FLHVTHjO;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.5 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763706481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJpzY+8p7e6mkQCSFD+RNf7gAUaeZITTk5gvlc/nyZM=;
	b=cHwX+U49N9bp598l8dU+nW9l7etk2a6SPAqG8PtIebjg8LwzsXOawGaJrTN4g9Kv0eYX2Z
	SJ5JVuVlDfGTRJ/uBs0UWZxjN4bllMWAS4dJ06qocbNpkLWJqBlm8+xoYIJslH+qyQNhUU
	t4UQYLbylVmEINZtoIIu3u0F/bphPP0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=meYAnC4QhHtyDWjVr9Ta65bi9PEpIRw14e15FiBtpqo9ujeFzErpFJRKcn8kvxSokeQJxTz9KpxkBunGbhWuHnc0jIXTf+9a+w4ji6jhvW+LV41iJHwSOtz7iWkbIrdldx0Sn134ld7pFDiv06nSi+TPb7XIulobtsZMLfF5fShrjPD2uO/XvTCCb2JdX9Me5ZzdGxN18SXruah4qJBoxQMgbDG/jL0m+9nusxY8z4rHD4mHgTexraRrMva9sBag9leL2cX9ax7DZqdcvbLNrDm5KVPZu+6lDXti5FUpKvB1GpPF4aG5jyrtg1cvX8dVMnXGJp8r0cB4lK2dWfMsrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZJpzY+8p7e6mkQCSFD+RNf7gAUaeZITTk5gvlc/nyZM=;
 b=FYkj3IHgo+DPcY14EagEbfHVl/X4wbELyaOJqvF3a8VK3Zk1uZtegAodOrbU1tKSe8qmWx3gkpOo157YdjCvZnosObWSeJdonBcRDnlOcuGsgGYCDR7bkkUjC8iEkGuGQ2gseLGlXMmw1cMK9X8gRYDYQldzSlKGKG5COvpAFzmF9F1OIuS5w1AlZYbZY0SwYyT210GQVXdzWx58eSbFYvp2KafwiW+E84JzzFBZNAPxcuMi/6kab1xJP96z5M5GbFtgs9FZVG0X+KnCU8K9IehKj3ZvTdEQQwPKgmoqaoo6f+QVLwzA4zT+TaUNEjF0i4Fr0LI1VYbQqqfrcNvhyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJpzY+8p7e6mkQCSFD+RNf7gAUaeZITTk5gvlc/nyZM=;
 b=FLHVTHjO1AMevOlC3OcgKRHNhanAzwWQji7HoBOMCv2VA3nC1V1+50OSs/nlXXWF6SyAaT/WsiBEq5eu2ihOYvGsqPmi4DRcQXVs2va2PVaTTVvdp77ESHaqm5t2kWi61CDh9o4k0IlQiyIF91CG5IGoQdHCLbArOav+0xs5pCk=
Received: from MW4PR12MB7465.namprd12.prod.outlook.com (2603:10b6:303:212::18)
 by CH3PR12MB9100.namprd12.prod.outlook.com (2603:10b6:610:1a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 06:27:56 +0000
Received: from MW4PR12MB7465.namprd12.prod.outlook.com
 ([fe80::6b00:b9eb:486a:f10b]) by MW4PR12MB7465.namprd12.prod.outlook.com
 ([fe80::6b00:b9eb:486a:f10b%4]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 06:27:56 +0000
Message-ID: <e170b847-e44c-4f23-8adf-87f74997f2e4@amd.com>
Date: Fri, 21 Nov 2025 11:57:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
To: Lance Yang <lance.yang@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, David Hildenbrand <david@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Branden Moore <Branden.Moore@amd.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20251120065043.41738-6-shivankg@amd.com>
 <20251120065043.41738-8-shivankg@amd.com>
 <f4652d26-a0f0-4ffe-ad53-74a3418c75e1@linux.dev>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <f4652d26-a0f0-4ffe-ad53-74a3418c75e1@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4P287CA0119.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b0::9) To MW4PR12MB7465.namprd12.prod.outlook.com
 (2603:10b6:303:212::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR12MB7465:EE_|CH3PR12MB9100:EE_
X-MS-Office365-Filtering-Correlation-Id: 7da80a55-2c8b-45ba-78b0-08de28c71bcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VzdkYWo4L2RDUnRnd2llQVY3ZkxtdEtURE5weGloZ1NIWUJVMlRrQjhjMzZP?=
 =?utf-8?B?VEFlQ09XaCtoNEY5MnlOSllpYVBKQ0lXREdpaXk3Zlp0b0ZwMkx6NitXRmk5?=
 =?utf-8?B?TWsvbytYV3ZYSmlPb25jaHNsTDRncjVPUGFmWmdvZ1I4TldvT1k0NG4vRzhN?=
 =?utf-8?B?TkxIWHVoVFBBNi9ReXA2dzBnanhKaXI0bkFocjlIelR5ZGY1dXJuYXJjR2RH?=
 =?utf-8?B?RjlFYWUzQ1VVcUNWcFQzN0F2VTlyWUdsdUdKUTFqTTdLc1FzbCtjLzVEZ21F?=
 =?utf-8?B?WC9aNENwV2djNU0xcGZLWkxEcHJpTUNwUHhWTkdKTC9WVmYzbGhTTGxwdU0x?=
 =?utf-8?B?Unh2SHk1UEtNZ2FHRkpRNHF0d0c1Wk1GcVFVRFVhTUI4WVdmQzBMQnpDamMy?=
 =?utf-8?B?MHFZa1hJeFRmRFNldEM1NzNKT01qdTlTWS9jU29lQUVUSFZNZE82azJDZXhO?=
 =?utf-8?B?d0dsdXdFdzYrR0F3R3Y2R2s5bUhPL3FJMm8xSHExMTV3cWJFL3RVUVljTGlH?=
 =?utf-8?B?ZlI0N0pwLzI1REV3VzN1bmRZSFR0azROTEpEL1NGc0J2TzVRaUZiaDVIOThY?=
 =?utf-8?B?aTZiVFNnSXdxSTZLV1R4akVHUUNpdXVrN3htYW40QWpEWDBWWG1yVnlTS0pI?=
 =?utf-8?B?MkFCaEdVV0o3MCtFakRacm8xSGIyc040MUxjNHcyZUFid1czeExCKzJQNWVI?=
 =?utf-8?B?SXZ3Y3hySng3NjVmaUIwWHJ6SjJzQU9sb3pzSW5ublhiQ3JxQzE3enQvWTBl?=
 =?utf-8?B?MVdEUXQ1OVl3a2JOZmtlN1BCbWp0R1o2VmxjK3VaaFJhUEoxc2VuSG5yTlRl?=
 =?utf-8?B?Y0plYTUwVDBIV2hIZTdYSmNKTEMxc2hpSEZVbVg0ZUdHemZ4YlFCeFRSNEYx?=
 =?utf-8?B?cEM2RzlyV003aGxVSXllVWhnNjNzK0RWOWk5d2xxU2h4NEJBVHFySVQ4VjhC?=
 =?utf-8?B?NzRCaEMxWHhaYW9RT0lPak93RWNjK2NSN1RTb3VrTHRKQXdDWUNWQjdzcG1F?=
 =?utf-8?B?SExtRSt3T0gzMTRtM2xReDAwcFlEUXBnVllYOU92TDc3TW8xc1ZlUXQ5NWUv?=
 =?utf-8?B?czlHZXV2dWlFWHRQb0pQUlBiWlovMlFleE1wR09PU3NXREdUNVJzenpUWjVy?=
 =?utf-8?B?VHc2eGpkVk1sNVErNXpWZkxEcEN5UU9PVUphY2s0T1IwVlVXQWhnYnU5MzJ6?=
 =?utf-8?B?YVArTlkrd0R6K3VGSUxmWmUvcnlQams4b1ZvTU5GSVBZdnRCemMvbzNTTWJq?=
 =?utf-8?B?cGFlL3E0UW5PVkhHYjkrbkRpeHlZdkZ3MStBZWhkdUhYaUlrcHJXTUt5QjYy?=
 =?utf-8?B?QUN4bVl4VGs2aHlpVVA5T2JGZW84UUlZRVZQejVKU2ZLVCtlNG1ZNHc2OTJK?=
 =?utf-8?B?eXF2SDRmSWh2UkFHQkNXaEE2akRGcnVOZkFtL2w0M2szb0d0a21wZmE5Y09u?=
 =?utf-8?B?RDZMY2lhdWhjQXkvRVhBcWFrVlNZcDBsTGREZTZRRDE3NFEyS0kzV1o3OEQ0?=
 =?utf-8?B?YW5NNUFtZVVCWTgzQllyVnNQTDdIRDFjMEdTSmY4UkFHRnoySzAvNXVmSyt5?=
 =?utf-8?B?Tm5YN3piOENCczBHdnl2b1JXaGY2Tng2RThLOHNybkRTNzVTcmlZS2FOem1S?=
 =?utf-8?B?M3Vac3ZBY0FkMDRaS1ZLT1BaZzlJS1ZuNUVOTUxKYzU5OVcyOXlNQWZxbUEw?=
 =?utf-8?B?ai9HdFdHWFJjclAyOGc3ajdvVXU3SlZXOUQwaXhtV0pScmFyWjlwQkVWRFpP?=
 =?utf-8?B?YXlmdU1XeUR5Tm80Y25NWThkYzJ2MzlUQTFZNzFqNDBGVGs0VGNGNkZYWFd6?=
 =?utf-8?B?a0VqOE15bk5PUTRSWW9reFdIOW5EdFlSQVFVRnhTYTNLekFzSHIzVVRYaVJa?=
 =?utf-8?B?YmM1NVJ2MXpNWXVjN2FrWUxZejNOd0R0SVFuNmg2YlUwY0RvMkgyTlZDMDN3?=
 =?utf-8?B?WTJmM0J3NmpBdFF3ZnlIaVhDS0poWHNvWHB0MlZhM1M0SGlpZ0xDeUhGMXg2?=
 =?utf-8?B?MTJmOWVTQldRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB7465.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eVplajUyMStyY0pweVd0bGxRMHJmcFlBa1U3RmxNTTY5T29ySVRTblJvd2hQ?=
 =?utf-8?B?K3FNMG8yZjIwMUFoT1JLaG5iV3FDRWpwR0ttWHBzUVhheE9kdG8yeXJCZEV0?=
 =?utf-8?B?a0dMenBrUVczUzN1dFgzUnVmV3dTRDZpWm5zL0pVWkRwVzJVZ21UT3J5Rmow?=
 =?utf-8?B?TXpNUm5TQUlLSXJBS3g4bzJQbURKdFg3UVc1NEt4WnFwTVNXVmlKNDFYRmEy?=
 =?utf-8?B?SFI0aU5BVytlOGVtaGVZUXRiVzVPakZTL25LK2dhOFhKUGdtZHFPK2ZUa1BJ?=
 =?utf-8?B?Y1NBbjFFYkxVUHFHcVFYNUZjMmxYOC83RzYxd3pIdmdHUDFGUHZTc0xXbmM2?=
 =?utf-8?B?cnFPdTdBaTFvYnZMN1VYeHBlYVFhZnFyWUNPeGE1d3FIbXYwTTlLb0hGVzNw?=
 =?utf-8?B?QWZWaTVuZnZsRTRQVjZuOWVWd0JGNE5XZEQ1QVNXSnhFeTJVWjJWa2dZUjZt?=
 =?utf-8?B?eGtXb3ZtVXdKZHdzTjBVZ05PTldNbHV0NkxIMW5QL0JtcHBqWmR6UmFzUm9U?=
 =?utf-8?B?aWZUQWd2SVZ1S05yalVra2tuNmpRalZvSUcwdjBvVHk0MDFrWVdqdU9LU2dz?=
 =?utf-8?B?bGJnWnEzVEF0YWI5blA1Tzl1VFRxdmNmV3JZc2EzemNHNWhaanFQazFOMURC?=
 =?utf-8?B?VHptbmZvdVc1VnNucXBkdmVQRUxCLzBkZzRwYVY0MHQ1WHBwU0JWcXl1L2R1?=
 =?utf-8?B?RjRtRU52TE5FNmJ6cE9xN2tlL3QzR0t1WGd0KzNScEF1T3pqN3ZDQjdlVEk0?=
 =?utf-8?B?N00yemVLN0dzbjdKVWtaMUk4K1o4WURPeENGek1mbDZKWUJtMXgzNHJhRk5q?=
 =?utf-8?B?Q25WLytEZE9yRFJTRExQMXNIWEJRVHRUUzB6TWs5Tll0VHhmLzVsV2VCeS9R?=
 =?utf-8?B?ZzVJRS9kR1VsMHNrVk5YOEJWaE5sVTJ1bzl3MzZGOVAzWkdoKzc2elRQTVR5?=
 =?utf-8?B?Q1BZYTUrVHFuZmdPblY0UDUyTURZT2RwdXFpSU9aMmEzZ0R0cUhWS1FSSHdh?=
 =?utf-8?B?dVNsWms3SEkrYW03MGo5VU9XZk9qVTFrY0xXbHlFOG92UWR0enJhSGJVYktQ?=
 =?utf-8?B?R3IvdzN4c29mWlVFbFVlcC9CUm5YRGVBdnJiUktIZGMrbE13ZE5kTlUyR25p?=
 =?utf-8?B?RGhRbzV5WmhWL3piS1d6NUdUMmdoVTZLNW9Vd1UvdDlVMXloWmR5bldSWEpQ?=
 =?utf-8?B?eCtzamhpVFQvTjlzMjhlYW9zY1Z2NENFYlZqeW92UzJLekpxMFJpTEFGaDVx?=
 =?utf-8?B?T28xckZCTjhsalp3YkFrMTFEaTVEZFpZYTJaSkVQOXI3MzhPZHI1emJvY1U4?=
 =?utf-8?B?OWppMVhnQTgxa3U3cXRIZFZMdFRGck9yRGwwVVN4WkVab3NjVlFZQlpKRGVk?=
 =?utf-8?B?YTc4bFZGY3Z6NmxZdXpTZlM3citLUXhtSFhMeEo5TUtjaFZhSnFkWUgyTjlL?=
 =?utf-8?B?d0xqSUpieXFQV0hmY2hXcXdhalZXRDZFek9ZNnBOVlZRTXBKaUczT2d2RUdk?=
 =?utf-8?B?TEFnZVgvck9Gcmt6dFNxaDE5ZXFYYjVaQUdLc3Y1RDBJdUlVVnBVRWpLRWN1?=
 =?utf-8?B?Y096Tlczd282R3pPU05BQXR0VmFLcU0xK1p6dEdjZ2M1L3lJckI2L1N0TFRN?=
 =?utf-8?B?UlVPK2hIRUZiOG9FUnQ2SlVBdGZab3ozSHB4VzNvMmN3TTEzbVh5SVZRc0Y2?=
 =?utf-8?B?VlRSQmpheTUrV25PU1ZwMm5lTW1kTFlyWFArVzd3RDd5TTR5UUV0WlZoRTM3?=
 =?utf-8?B?UHFmeDBLQWMwU1JWRGxXTnhhVXk3NGVXb0dibzdxOXRXTnllc3VxK1NyVHFj?=
 =?utf-8?B?VGtnY3U1RWFnL1RWU09hTG1BU2xkS3hFd2lDSklDamdPNTZHZndNZ1hkWmsz?=
 =?utf-8?B?RkVIM2xlWGVSbitGSnJhdDdUa1ROY0gvcG1EeXBzWEJibktvTHBsakZGdW5T?=
 =?utf-8?B?cGFVcU5JOElFdHBORWdRMURERGhjRVdScWhSanhrWVZVYk5UWWNCVzluU2E2?=
 =?utf-8?B?cTJmNEdMWWtVL1h6RHIxUXVTeUhGUnQ5eCtOMDVQZTNLYk5VNlhsZlliQmFE?=
 =?utf-8?B?TXBxejRDaHAwZGNTR2RzTkNFbjB3MnczVGdwaUhqZFRIRjRjaHE3c0REOXNO?=
 =?utf-8?Q?0oYU3XSL5BnapLPB9UvZBDQgk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da80a55-2c8b-45ba-78b0-08de28c71bcc
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB7465.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 06:27:56.6172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2OX33vVWLHBVvVrnpEKwTHT39Je4U875UXbQ6n+WqV0fHkPxovJ+NJF3F1WrOlSpcsfZznuGGvdCjCt9wZPtbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9100
X-Rspamd-Queue-Id: 05AF820006
X-Rspamd-Server: rspam07
X-Stat-Signature: eafi489t1j15yo5a6ndexse8pis7zoan
X-Rspam-User: 
X-HE-Tag: 1763706480-85285
X-HE-Meta: U2FsdGVkX18lQy/cyrUX13za3eWdAfJRYJxYDKthQPOYkeYETfeVbOvQrOJABXBOf68k8/U5CijCgtnCS+GyLnZ5kv7RBn0bt7PZcMG0P9BR7opohNVhCeNgpvhJ/wdBWuWcyr82Rf/FTax4PnejSxbnm/y7TwVf8kN50zduphxsWzf9fXTuj0mHv3/GZ53cQWjzi7b51smJ9So986SuKs4K/PdeKezMIHNgKtvsDwG2XySn2PNRPF8vn0JAyGHmBXxGsXZEVg/c6OIiSbrWRUGCRlcEv3r+OZr+52yQvk2Geg17h42o8OID+Al0Te7d0K58czhHpoIXfz/4wAbLbQoKY5m53CytcIA/51V8KVtipDO5rw21KhhxQ03jGdSghzxQB4HwfEiThPsig6+Ic9brj3wvjaFaIHqSa2QsW51gvv3IhGAVb9n+L4roD5h5DrTNKFTWXP2uO+Fqw9HTw2M/TUCh8+4lmdiJ22QXn14I9HzNjzwjhQUO9BEVSDuwTftN+RfwV0d2GGBlOCF4llhBx+pBkA/unybt2CZeeLNPc+31Uj4JaA2Y09+0PrhC4HY8lfIkRbzyqAtZTPeDjnmu3yM1tVZrySV2hm7bLfrzkGdmThvgivcxnhV04WhR9sDU86Qwyrh3JroSuU9uGSB/zRMsLlc1YAO3nrxVj7rZ5PRAKj3xMpKQPISk+mOIMpjDHIABzTvLm8hQDdjBukiL/r2zfYilBH8X12GZceVtwNYAhzuSQ3dLRyevnarI9UXCO7PMwJO1oKQyD+7sMH6P4oq3U82Hhpic+i08LzlbgcshN+oxA1N1ZOdmW3Dj/2PeQbPEkXCnmC+Rt1Lkdt/d2izs6SyCZuiHaCN6l9hcINmyRdPAuNRqbr8SawmqxQGHk6ajiNEC01AfladMPnz3NBRr81H3fjLHibtKw5ADAHS/uKQV5xpxECPzmyoWp6yJBrWxXDgtbPYmJzL
 U6v1Venu
 azR5Vu78vqrJ0yvupQAfS03veCir8ySOv4XTYB64qQMrQ+Wa/slCRyjHRKh+eM1cbakot1kWEvz6RH9CrB7t/GYqn3DaFlLu90oHyMEEEb/NVpAOyM7gEE2MWNnl5TBxNPQM7Z7150z8cFoVAF4Jb3V1v8ty28377IBznDTO0Iq34YRQGsTGuZVDE8GAcoEfWiZGrowr1HOwKZ8rjNwxVi8gDEfEUkE2khbNztZnU6Kyu+OM+5SoZMz/dfc2xVE1D0EoA+lIZG2GDgbyFXCtHSvfOMlBo8cOnshzCPMY/SOK5CB0kHaq4ALzDF0/MUxC5H8+vz4kwugLmAF1C8KMUN5Yy65jozl0eHWi+qyxFtiayOBLRS2b3rhcro5uQrsSjYCXUvT5O7daVsILUns83k/HUQVuWjPbBhAx8v6ynzKOVqBpj2+DngzKb366UohLOss2imz6EJMza6S+gbSubyfQnA8s5NASaZAEsDlXf/Yn5+1uS0tfUca96ZPxHL4RreB6hfJzwal9nbXjy/OPQD1QO3Or5pII4t0gz2mBhDPxJw0Usu1O7kZrqJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/20/2025 6:31 PM, Lance Yang wrote:
> 
> 
> On 2025/11/20 14:50, Shivank Garg wrote:
>> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
>> text sections), the pages may still be dirty from recent writes and
>> cause collapse to fail with -EINVAL. This is particularly problematic
>> for freshly copied executables on filesystems, where page cache folios
>> remain dirty until background writeback completes.
>>
>> The current code in collapse_file() triggers async writeback via
>> filemap_flush() and expects khugepaged to revisit the page later.
>> However, MADV_COLLAPSE is a synchronous operation where userspace
>> expects immediate results.
>>
>> Perform synchronous writeback in madvise_collapse() before attempting
>> collapse to avoid failing on first attempt.
> 
> Thanks!
> 
>>
>> Reported-by: Branden Moore <Branden.Moore@amd.com>
>> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
>> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>   mm/khugepaged.c | 26 ++++++++++++++++++++++++++
>>   1 file changed, 26 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 97d1b2824386..066a332c76ad 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -22,6 +22,7 @@
>>   #include <linux/dax.h>
>>   #include <linux/ksm.h>
>>   #include <linux/pgalloc.h>
>> +#include <linux/backing-dev.h>
>>     #include <asm/tlb.h>
>>   #include "internal.h"
>> @@ -2784,6 +2785,31 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>       hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
>>       hend = end & HPAGE_PMD_MASK;
>>   +    /*
>> +     * For file-backed VMAs, perform synchronous writeback to ensure
>> +     * dirty folios are flushed before attempting collapse. This avoids
>> +     * failing on the first attempt when freshly-written executable text
>> +     * is still dirty in the page cache.
>> +     */
>> +    if (!vma_is_anonymous(vma) && vma->vm_file) {
>> +        struct address_space *mapping = vma->vm_file->f_mapping;
>> +
>> +        if (mapping_can_writeback(mapping)) {
>> +            pgoff_t pgoff_start = linear_page_index(vma, hstart);
>> +            pgoff_t pgoff_end = linear_page_index(vma, hend);
>> +            loff_t lstart = (loff_t)pgoff_start << PAGE_SHIFT;
>> +            loff_t lend = ((loff_t)pgoff_end << PAGE_SHIFT) - 1;
> 
> It looks like we need to hold a reference to the file here before
> dropping the mmap lock :)
> 
>             file = get_file(vma->vm_file);
> 
> Without it, the vma could be destroyed by a concurrent munmap() while
> we are waiting in filemap_write_and_wait_range(), leading to a UAF
> on mapping, IIUC ...

Excellent catch!
Thanks for saving me from this nasty bug. I'll be more careful on file ref
handling in next version.

Best Regards,
Shivank
> 
>> +
>> +            mmap_read_unlock(mm);
>> +            mmap_locked = false;
>> +
>> +            if (filemap_write_and_wait_range(mapping, lstart, lend)) {
> 
> And drop the reference :)
> 
>                 fput(file);
> 
> 
>> +                last_fail = SCAN_FAIL;
>> +                goto out_maybelock;
>> +            }
> 
> Same here :)
> 
>             fput(file);
> 
> 
>> +        }
>> +    }
>> +
>>       for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>           int result = SCAN_FAIL;
>>   
> 
> Cheers,
> Lance


