Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D69CC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 09:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06C8F6B0096; Wed, 30 Jul 2025 05:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D8A6B0099; Wed, 30 Jul 2025 05:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01BD6B009A; Wed, 30 Jul 2025 05:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAD366B0096
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:25:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 883E31A02F2
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:25:46 +0000 (UTC)
X-FDA: 83720398692.16.9B3F20A
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	by imf01.hostedemail.com (Postfix) with ESMTP id DDA5A40002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:25:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=m1K1ix2A;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.243.85 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753867544; a=rsa-sha256;
	cv=pass;
	b=ZcOz+7NKEEMR8pI1Fd8v4XpMDY23tIB2B/B6M1Kpne2ygB0UmBGz4WHzp3xLutMo4/Nw9X
	tMFYa6soSkqIH0fVXklivASfZdof/T7o/4QJCZ4lPcKx5scbjiLXfgZ2RolD9dU8tOcEcv
	6Xn5dwIIV4HLo6vDBfjc0IKWNJAzKNY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=m1K1ix2A;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.243.85 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753867544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owgWAcCn0rKaefQS3eiqrFLRcwcYAHcSfZg5ZFk8mJE=;
	b=LklM4pnyl/8vHh0A77RLPHQ8dHki2eEcm4uAC2nJV0WwJVkTXTBdF+JxT08HhxZ55FTtl1
	nQAMHW8gCB39YFMx2OV1D4O0MQwrTHscuBc2Fkhb5YgQ0sXNetbdfJzr/KvDP+nyj/4rCo
	kojGaEFDaAC9k6k/Z5CmLJi5EGPk/0s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qq9hPt8tNJoB4wY2I7+R6tLVCTIjet2uA4chlrZraTW+KaHLRjk4bfU1JZPBXp+hJqKEei4oQ6kDI0G5BBgn35jyYjclyGN+smkm8U6t2qBehxIFwHqTcGtbODh0VcSt2u02WX6g02xIra0onvxVRJN570uH5bSWawxXb4i8INBAtmdfdNwK04XsZ3Xmt74L6PXnTZi8FMGOl+ba0a7pdw1aIIczrWM4VXXMBiuHaebbdkIqkNEC3Epq/gRIlnkLbOzEPDGa80gXnVhMJomW8Z7IIBD9zEQz4rUWu8hSLJMrcuvXWnNGgOWupJxzm/BKWwOerjhkMVGfFRFIyLrbRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=owgWAcCn0rKaefQS3eiqrFLRcwcYAHcSfZg5ZFk8mJE=;
 b=qUfuZl3fvwyWBsB/oC8KfkeYJnz/eBYesaqokg9lo7XBhm51xuet9i/bkvVAPIiHGx+pXgai65+QM3baadq2yMkV4mFFW09I4k5s8wjauIVdOssG8gwbLMqXpGyQc01V1KheQGrq7fcYMkgtmJinX8T0Xp1MRqiY/YjmdLO+NqqvizQGz8Gw4XFklfwmKiPbTz9u308hEEwGWSQSwu1lzUjEqdO9eVtaICRBiV7XBghUgADrzFlhYXlI4vh4OOLNSCuR0V99gcLBAbwgbZeN9bn9ZVaERhCFf0B2D/uU2Jw4M79cZ+KB6d9oxm0nt7UuZtGbFQ7zlgfYsFIfvAcV3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owgWAcCn0rKaefQS3eiqrFLRcwcYAHcSfZg5ZFk8mJE=;
 b=m1K1ix2AZTU8kVmifRV7ZE1qJail80GP17kWdHX3f1uXf/0z0X4Xb3aqr02VR1diT14TQqacg6ZEdTixkICaNKqsdFm4GXr5OcpzOCP5DlxJO9zd8fZ6ypT5/SY8ZKudBrvkRSwEjG7E55ZjRI+j6meebhQkRKSOFsf4vXq6gelnaVVMXAyBxYF6NRKVQcC0gikipjengZGLBQSlPdKIVhZFTYsLOCzEgNcRdPgkAMtiQF7M+T02pP4OqIsufaRqCE9yw0DauQK6B1Z3MFwxCxBn4OrFzxGrDu9dWNaGntKYWTl9BBwvLWdUQpYyjuRnOAasfgWwwVa56o5rlZlYMA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB8428.namprd12.prod.outlook.com (2603:10b6:510:243::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 30 Jul
 2025 09:22:13 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8964.025; Wed, 30 Jul 2025
 09:22:13 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Balbir Singh <balbirs@nvidia.com>,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Peter Xu <peterx@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Jane Chu <jane.chu@oracle.com>,
	Alistair Popple <apopple@nvidia.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [v2 07/11] mm/thp: add split during migration support
Date: Wed, 30 Jul 2025 19:21:35 +1000
Message-ID: <20250730092139.3890844-8-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730092139.3890844-1-balbirs@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0036.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::21) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB8428:EE_
X-MS-Office365-Filtering-Correlation-Id: a2067ca5-10bb-41c7-69d1-08ddcf4a91a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bTFSRVdoNWxrNUJhUGhDTkJ2ZXptWW1pd2hUVXBoRlA0YjFPQWZJQVlhK0J4?=
 =?utf-8?B?NkpKc1drYTNSTnRyWWVhZi9HUTBpUUR0OUwzVXJnZWpnVGxXNlBDSk5tUE1p?=
 =?utf-8?B?TGlqdW92WWNaMGUzU0NzRDJrM0hOZFh3SUI1Tlh1RXJoUlNYTWk3K09wdldj?=
 =?utf-8?B?ayt0YzFrbFZzUXZ3WkJ2anRZTjVBc0h1WU5OOFpTQVdKWkNmS2FicE84NlFn?=
 =?utf-8?B?aWZyKzkvV1g0TDVlMXMrWjM0U21tTlJ0UURjSjlKRHg1S29Yc2NUR3ByS2tn?=
 =?utf-8?B?S2JQWWN0K3BPU1lVL25iSVZ1TnRHQ2tUcHVobkI0QzgvTCtQU0p3a1EwUHNn?=
 =?utf-8?B?Uk5hWTdISXA0TGJCTGo3WVRRaG9wSXJZTlREUGhha2h2MTdUWm9leEc3aFg3?=
 =?utf-8?B?VjVNWTVzODF3alpSRlJleUhXTFNjblU2Ujl1ZkdsTGllL25qeGxwQmxZcGJJ?=
 =?utf-8?B?UklwajRpWGIxZFRCZUdaUDdPSFBIMlFRRHZBZHc3S1J0R2JWaVl2anNWOWFY?=
 =?utf-8?B?UElaZVREZ2cvTHlXakUzLzcvR2g5YlRnQXZlaS9Ha2dyV2RhVm1uNSt1VGh5?=
 =?utf-8?B?aGtzVWdBakt1aWoyM2ZNdVduaVdNU2gwTzBqVStUemZzei9CYnZtOTN0QkpB?=
 =?utf-8?B?NEFsc1pQWDQyQ00vQ2VEamRobDZpczluRkFzRXgyalYwV3VUN09WVHoybW16?=
 =?utf-8?B?RWJOYlpmbFpxSGROakpRM1did3dXbWlnSktqUTA4SVk4elhCdjU4dkd2Tk5R?=
 =?utf-8?B?OUZSQ1h6Vzh0enF1MDAvMHNrc1RXNDZtd0pmcFdFcnVNa0hLRUJYa2JTT1dV?=
 =?utf-8?B?SXZmblZ1ZDRUQW5Oek1lckM4eHB4N0ZVN3JNU25QN2dKellFcjZOSC8wSlVl?=
 =?utf-8?B?UnZvYUdtdnZXQVpZZlVHbmh5OTEwcGpkWGtxcnNmNS9XQ0pPQjNqZmhIUVZn?=
 =?utf-8?B?cCttejVWUWZCV1Vtd3VObEp2VkNkNFd6ZHZqbTgrWmF2MGFkazBwSU8xaGFK?=
 =?utf-8?B?cm04T2VFZ3h3ZWxwUjdvTXBLdTgwT0hrQmtKZFd3K3V3VGJhNG4relkybm40?=
 =?utf-8?B?SVA4VGxyK0VKSWZaRXN3WVBKYUpzOEhHTHFTNkNMa0hCd0pzaUtlZWUxby85?=
 =?utf-8?B?VWZuVkxZVlUzK2dPb2NZd2t0TjVEaTBoTzArYk9kUVp1TmxUYXJHM2dEVXhs?=
 =?utf-8?B?bXVlMnhTUTlxNlRxSkhSQkFpRGUwdUZwdHJMMUFsY0VOMWpzK3d3STdZMHc4?=
 =?utf-8?B?UVIwQnIrbk5JZ1RHbmphZlI4ZWtpM2M4UkdGOFE0U3JyVXVvdmlhQXVtcnBk?=
 =?utf-8?B?cjRHakJjTm5hWmZDV1FCajJGQUlXbUJKaGVIV1QxR0Vpbm1lZStRRUxNYngx?=
 =?utf-8?B?UmhrYk5LbWlhbFpRNUQ4UE1TdTdCaFlkRHlEU1M3SmtWSzE4MXBjamVPdDg5?=
 =?utf-8?B?R2F2bjkxbGV5K1lmSjBNamkzWkxmODFVWDNvd0Rla2Q0YW5YREZNY1lta0Jl?=
 =?utf-8?B?R3ZFZ1BIT2FrazZUaTBQSTZlN1RGYjhCenRZMERCdzBvNFZucW84Nnp4TzRl?=
 =?utf-8?B?OUxIWG9qS3JOdUo5aVBLSG1QMlRQQmU3cnl1TStaMGIzd0Z1VG96djdOdWpM?=
 =?utf-8?B?WWgwTkFpYlBucEhXb1pnR3k4SjlFdmw1NXBLN2M3ZE1TN0lJVjBxaWIzam9B?=
 =?utf-8?B?TmFEOUtSakNaNTNuV0U4NiswT1FsOG1lZ3BDZTBIZS9PUG1NR0ZMdXVhbmQ5?=
 =?utf-8?B?M1dubVZpQ0U3Z3FMTjJaMTZLWlJLaXpBV1RKZFNWTG1YYjF1T2hIUVc4OGk2?=
 =?utf-8?B?Y1lFdS9iQjJHeDI5M2x6RGpSWWdTbHpIWUl2YXcwWldXZWRYdEdCaytzL1hW?=
 =?utf-8?B?aHNMNlhXc01aRTFrbFB6T3E0UTJLNmZyMlhNQnVHSUQxV3JCampUUkNiNkRi?=
 =?utf-8?Q?8h0Ue1ZjJqY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkszZldKeXlEUDlOOGNtL29sanNxY3NrT0FzczN6N29RL0YvNWlYZXlKd29m?=
 =?utf-8?B?dDZzQ0FHOHlBVUJxUDBad0pYeXBDRnRjRlB0UUpjVzdaZDRZQU1JSlRYWXBL?=
 =?utf-8?B?Z2hqZVdyTzhhSlJSUTNQdEpPMlVpSUdsMjBhZTk4aHh3RnAwVC9aZmExdkND?=
 =?utf-8?B?Y2VwM2ozWW15Y2FKNHFkL1VwWjhqQlIvT1dzM2hQeEg0YXd3QXJNMjNZSHQ3?=
 =?utf-8?B?cUxwNTM3STBsQkZtNEtyR2R2VlcvK0ZwMFVSaWEyNWxwYVNMQ3M3Q0dHRWlN?=
 =?utf-8?B?VmJ6cGFweFZ4QnhnRjZUOXcrSzZ1MS9YaWwwS3B6NGEyVzQ2MUdFdVFzSWdT?=
 =?utf-8?B?ZlJJdzRITjV2ZUJJa2Y2KzBNSXcwelNaeVZiZzgzMkovdk1Cb1BZMmZRYjE1?=
 =?utf-8?B?ZTYvZk9oa3lIU3cwODlVcXdKMFc1NVpoc28ySlMwMVRmT1dtdGU0bU5VM1h4?=
 =?utf-8?B?VDMwRXRROFBHTWsrY0t6OTNoaGZpOXRRdEV4bXpkdEZGOGt6OTEwdmloRU15?=
 =?utf-8?B?VzcwcEtpSzIyektyVVptekplNHA1QU9mVzZtcUwyLzNRTW1XdXZMQVNsQlcr?=
 =?utf-8?B?WnNGUEViZFdiRmliaVpUMWd1ZUo5QkltUUJ6Y0xabGYzektrSG54ck5rSlIw?=
 =?utf-8?B?TCtkNWNpWTBGdVpJUkNqUVdENnV2YUdWQW9MUHA2cGIxUitKOUk2MExRWXlk?=
 =?utf-8?B?SHBGenpiY09iN2lHd3NHcTNrTXJKMXp0TUF2eGJqS0xVV1ZNaitaazVVMUxX?=
 =?utf-8?B?aWptN0VhT0poOERhVUl4dnc0Y0NkTWRqR3Z0cHVaY21oVWlmbkFEV0wzdkpl?=
 =?utf-8?B?MDd2cERBbzU0WUNzWFRaaTJOcnNoU2dwUnp5ZWNCaWQvYnNocUhKK0hEaitF?=
 =?utf-8?B?THFjL0dmeG5TMmxvR3JFeHkxaE0zN1d3VDhiTkNsQ3dYaFNsUHNDcTVKQzFS?=
 =?utf-8?B?dTlnVlQzUUoralFxQm1pOHR0aDVUeDdGQ3dCazlReDdyaWhoR2thL0N4MmZW?=
 =?utf-8?B?WEl0dTYyL28zRFRpUGtvQVZsVXJraTRNcTZOOEMyTGR6a04vdXRYUzQwdmZP?=
 =?utf-8?B?bG5UN0VVRmUwMkFRVlpaZkEwN0RtbEdWVFBPWStERCtiNjNQN2luS05KMGNC?=
 =?utf-8?B?Qk1TNFIvSm1vTzFJYjE5NXhHaTd6OXZhdW96c3UrL0JYcC9FZDJJbHNndTdE?=
 =?utf-8?B?bUhBYlEveFZkazBIUFJxSlUrSTlJaWdkcnJwZlU5bGg3TWdReW02RWtLZXhF?=
 =?utf-8?B?UjZzTnVsSEw4NGhQVUJQeDlRVlVIMDZNQS9lMHJaT29pV0R0QWY1WklkMGRI?=
 =?utf-8?B?NE9yT2xLNFU4dHd3ZTFvTFhzV3JCL05jNTR0ZkxPVUJpQkFoWUNTY0p5Q1Yv?=
 =?utf-8?B?RHpVblJIU1B6SVVreDBPMnF1eG5Zd0J4OWFwTDI2SWVNaDJTMDdnb2k3RlZv?=
 =?utf-8?B?ZE93S2NPenFtUGtrRGd1dlJYT1VPNExuNlp0TDVBSDc4dGViSHZYSHUxYzJl?=
 =?utf-8?B?ZDVjczMzTVg0bGxra0kyMVgydHcvTjN5a1NXM2lCSWNwNnJ0ZWJQMUxsKzlk?=
 =?utf-8?B?b2FScXJ2cklrVGdNRW9nckpPRnlmZ1V1Q0EvNjZHdHM4bklyQkVXcjV1Y294?=
 =?utf-8?B?cXYrUEY5eEVuWDJkL3I3VG9TOTN3RDRQWlhYQW91NjhZbHJSK0YxSjVyN3BL?=
 =?utf-8?B?aS83NDdBZ3pnVys5OWxYQjB3Q1cwdlo3WFdwOElOOGpLNi9tTXJqZWRuQ2JX?=
 =?utf-8?B?TnFHRVNKNUZSNGgvVU0rTGQ3Sm5KSVdsRno3WEgyMGxLNG5jUmV2dEZBV3Vq?=
 =?utf-8?B?NjZIL3cvV09TUjBvK1hObVd3bG9LSjVhY2FzMEJmR241L1JSN3REQnBxLzcy?=
 =?utf-8?B?UkVhbHIzL0pWVGVKbG1NQ0luT01ONmY2d0ducklQeXZXN21YRkJYQThrTWdo?=
 =?utf-8?B?c1doSjc0bXV6c24xTGVOSjZhZksyQjhaQTRlQ2dIMERTTHl3blUvNkVuNkVS?=
 =?utf-8?B?UmQxVGZ3a3NqTjdjbDBuTm5IcU9hV3F3WVY2RGVieE5ibzlyc1ZCUUJPSTRT?=
 =?utf-8?B?T1BLZEN3ZzZXRVVFTk9BNE82eVZIYWdiTHQwbmNTbHJnaFZrMGFTbTIvYjdp?=
 =?utf-8?Q?y06P9ewUerCR074UYgVMVzHAN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2067ca5-10bb-41c7-69d1-08ddcf4a91a1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 09:22:13.7369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CAdvRLgBR27Cl3dU/s+i3gydN6rreINFMu0Q38rlUo3nKEJWEx8tyttepY9QS5c0G3CugLUMkB7TxaCI0PIgGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8428
X-Stat-Signature: x7hpzjqe6ommr5nb4c1eoq9w3q1ed3mk
X-Rspam-User: 
X-Rspamd-Queue-Id: DDA5A40002
X-Rspamd-Server: rspam02
X-HE-Tag: 1753867543-772329
X-HE-Meta: U2FsdGVkX19J3e6i9BuqbxsTNVRQ/6u/Lslol/+rfwQVWfDASNsas2sXE1koSPbm68kBhRvqZ3JN00mlP6yIbM/0ZMpiXY3j1zBKlqf55e7RdZZYRy1bGc3RJTfb/5sJNJsgqKTKasHTehzryV45CiObwsxyDEen628GmLWEwPYELUpJLzOjH9t/GatckZu+eOm+IOasWi0ooZlcK72TVpkkY7peeOwTgZdtmPX8k4twBjGTpcOl3gAE8yiyfIGHTPxJ0M/4XPFcPfq7wsPcQUvYK01VuRhcEnWpQi8Z/8iS+NFuUkRsG5ok9p98xH1IJ3mcWw1NfnlY/cflk2uvrZr41FyHmRKAJ8zVJbaaJgwjjAdDo6rMMaxoVmzk6GKzcPHzTZduDLmHM59oT0Hb2Di64iZ1Lo8qnBMjH1TH6vqS/llgROlshjSD2fSAmBhVIpEN7IT9ZoAKbIwBbMeP8jAz+xYgLub9kEO5WZDtWJBpZw0s8hiP+ummpqf05mibCOuE3zCJ/qF6hxb2BLwbPobpbU0X6fjF2gWvOb/Th6qhAKdL7Hef9l6DV2u6bHQLX9/FLSaNXFCHVbGJFyY84uCEV2EAzDadx9jbj85AQpu66zxYWbO5xctuc7r4CXxCf9QyYVCNWlEu4Wjgqyr8GwePupUWw4twpqOX6XHAkwbYYlHcIdbHyFpSxoLQW5FXn4FxlwD7quOJbDoxTowD5XSI8FQCblL1SeCnlUdo+VCrcBdyoOtiFmM0R9tyCMD1PvmgVe6lImtEs1jqWpu6n9knYOMFCOv6wWbaf0/CIraxXezfrYKtDjY1jyFK0qFD51E6Op8YWk63bwE2C9oDeAgelSznmrYtV+GzeV2BXfPopUJqGC+jxjc7BoT1NQGmuJv86lGLzsZ2H1bceYX+47zdiQbmkj3nOQQSCms70JpEbUuFQMlOgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Support splitting pages during THP zone device migration as needed.
The common case that arises is that after setup, during migrate
the destination might not be able to allocate MIGRATE_PFN_COMPOUND
pages.

Add a new routine migrate_vma_split_pages() to support the splitting
of already isolated pages. The pages being migrated are already unmapped
and marked for migration during setup (via unmap). folio_split() and
__split_unmapped_folio() take additional isolated arguments, to avoid
unmapping and remaping these pages and unlocking/putting the folio.

Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/huge_mm.h | 11 +++++--
 mm/huge_memory.c        | 46 ++++++++++++++-------------
 mm/migrate_device.c     | 69 ++++++++++++++++++++++++++++++++++-------
 3 files changed, 91 insertions(+), 35 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 56fdcaf7604b..19e7e3b7c2b7 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -343,9 +343,9 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 		vm_flags_t vm_flags);
 
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
-int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-		unsigned int new_order);
 int split_device_private_folio(struct folio *folio);
+int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order, bool unmapped);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 bool uniform_split_supported(struct folio *folio, unsigned int new_order,
@@ -354,6 +354,13 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
 		bool warns);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
+
+static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order)
+{
+	return __split_huge_page_to_list_to_order(page, list, new_order, false);
+}
+
 /*
  * try_folio_split - try to split a @folio at @page using non uniform split.
  * @folio: folio to be split
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 75b368e7e33f..1fc1efa219c8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3538,15 +3538,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
-		/*
-		 * page->private should not be set in tail pages. Fix up and warn once
-		 * if private is unexpectedly set.
-		 */
-		if (unlikely(new_folio->private)) {
-			VM_WARN_ON_ONCE_PAGE(true, new_head);
-			new_folio->private = NULL;
-		}
-
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 
@@ -3775,6 +3766,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  * @lock_at: a page within @folio to be left locked to caller
  * @list: after-split folios will be put on it if non NULL
  * @uniform_split: perform uniform split or not (non-uniform split)
+ * @unmapped: The pages are already unmapped, they are migration entries.
  *
  * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
@@ -3790,7 +3782,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  */
 static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
-		struct list_head *list, bool uniform_split)
+		struct list_head *list, bool uniform_split, bool unmapped)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
@@ -3840,13 +3832,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		 * is taken to serialise against parallel split or collapse
 		 * operations.
 		 */
-		anon_vma = folio_get_anon_vma(folio);
-		if (!anon_vma) {
-			ret = -EBUSY;
-			goto out;
+		if (!unmapped) {
+			anon_vma = folio_get_anon_vma(folio);
+			if (!anon_vma) {
+				ret = -EBUSY;
+				goto out;
+			}
+			anon_vma_lock_write(anon_vma);
 		}
 		mapping = NULL;
-		anon_vma_lock_write(anon_vma);
 	} else {
 		unsigned int min_order;
 		gfp_t gfp;
@@ -3913,7 +3907,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out_unlock;
 	}
 
-	unmap_folio(folio);
+	if (!unmapped)
+		unmap_folio(folio);
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
@@ -4000,10 +3995,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 			next = folio_next(new_folio);
 
+			zone_device_private_split_cb(folio, new_folio);
+
 			expected_refs = folio_expected_ref_count(new_folio) + 1;
 			folio_ref_unfreeze(new_folio, expected_refs);
 
-			lru_add_split_folio(folio, new_folio, lruvec, list);
+			if (!unmapped)
+				lru_add_split_folio(folio, new_folio, lruvec, list);
 
 			/*
 			 * Anonymous folio with swap cache.
@@ -4037,6 +4035,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			folio_put_refs(new_folio, nr_pages);
 		}
 
+		zone_device_private_split_cb(folio, NULL);
 		/*
 		 * Unfreeze @folio only after all page cache entries, which
 		 * used to point to it, have been updated with new folios.
@@ -4060,11 +4059,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	local_irq_enable();
 
+	if (unmapped)
+		return ret;
+
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
 	if (!ret && is_anon)
 		remap_flags = RMP_USE_SHARED_ZEROPAGE;
+
 	remap_page(folio, 1 << order, remap_flags);
 
 	/*
@@ -4149,12 +4152,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  * Returns -EINVAL when trying to split to an order that is incompatible
  * with the folio. Splitting to order 0 is compatible with all folios.
  */
-int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-				     unsigned int new_order)
+int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+				     unsigned int new_order, bool unmapped)
 {
 	struct folio *folio = page_folio(page);
 
-	return __folio_split(folio, new_order, &folio->page, page, list, true);
+	return __folio_split(folio, new_order, &folio->page, page, list, true,
+				unmapped);
 }
 
 /*
@@ -4183,7 +4187,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-			false);
+			false, false);
 }
 
 int min_order_for_split(struct folio *folio)
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 4c3334cc3228..49962ea19109 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -816,6 +816,29 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		src[i] &= ~MIGRATE_PFN_MIGRATE;
 	return 0;
 }
+
+static int migrate_vma_split_pages(struct migrate_vma *migrate,
+					unsigned long idx, unsigned long addr,
+					struct folio *folio)
+{
+	unsigned long i;
+	unsigned long pfn;
+	unsigned long flags;
+	int ret = 0;
+
+	folio_get(folio);
+	split_huge_pmd_address(migrate->vma, addr, true);
+	ret = __split_huge_page_to_list_to_order(folio_page(folio, 0), NULL,
+							0, true);
+	if (ret)
+		return ret;
+	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
+	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
+	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
+	for (i = 1; i < HPAGE_PMD_NR; i++)
+		migrate->src[i+idx] = migrate_pfn(pfn + i) | flags;
+	return ret;
+}
 #else /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
 static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 					 unsigned long addr,
@@ -825,6 +848,11 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 {
 	return 0;
 }
+
+static void migrate_vma_split_pages(struct migrate_vma *migrate,
+					unsigned long idx, unsigned long addr,
+					struct folio *folio)
+{}
 #endif
 
 /*
@@ -974,8 +1002,9 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				struct migrate_vma *migrate)
 {
 	struct mmu_notifier_range range;
-	unsigned long i;
+	unsigned long i, j;
 	bool notified = false;
+	unsigned long addr;
 
 	for (i = 0; i < npages; ) {
 		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
@@ -1017,12 +1046,16 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				(!(dst_pfns[i] & MIGRATE_PFN_COMPOUND))) {
 				nr = HPAGE_PMD_NR;
 				src_pfns[i] &= ~MIGRATE_PFN_COMPOUND;
-				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-				goto next;
+			} else {
+				nr = 1;
 			}
 
-			migrate_vma_insert_page(migrate, addr, &dst_pfns[i],
-						&src_pfns[i]);
+			for (j = 0; j < nr && i + j < npages; j++) {
+				src_pfns[i+j] |= MIGRATE_PFN_MIGRATE;
+				migrate_vma_insert_page(migrate,
+					addr + j * PAGE_SIZE,
+					&dst_pfns[i+j], &src_pfns[i+j]);
+			}
 			goto next;
 		}
 
@@ -1044,7 +1077,14 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 							 MIGRATE_PFN_COMPOUND);
 					goto next;
 				}
-				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+				nr = 1 << folio_order(folio);
+				addr = migrate->start + i * PAGE_SIZE;
+				if (migrate_vma_split_pages(migrate, i, addr,
+								folio)) {
+					src_pfns[i] &= ~(MIGRATE_PFN_MIGRATE |
+							 MIGRATE_PFN_COMPOUND);
+					goto next;
+				}
 			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
 				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
 				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
@@ -1079,12 +1119,17 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 		BUG_ON(folio_test_writeback(folio));
 
 		if (migrate && migrate->fault_page == page)
-			extra_cnt = 1;
-		r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
-		if (r != MIGRATEPAGE_SUCCESS)
-			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-		else
-			folio_migrate_flags(newfolio, folio);
+			extra_cnt++;
+		for (j = 0; j < nr && i + j < npages; j++) {
+			folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
+			newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
+
+			r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
+			if (r != MIGRATEPAGE_SUCCESS)
+				src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;
+			else
+				folio_migrate_flags(newfolio, folio);
+		}
 next:
 		i += nr;
 	}
-- 
2.50.1


