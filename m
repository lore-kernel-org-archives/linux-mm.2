Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C6CCAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61EC98E001D; Tue, 16 Sep 2025 08:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582488E0001; Tue, 16 Sep 2025 08:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AE968E001D; Tue, 16 Sep 2025 08:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 139598E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:25:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3D77566E1
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:25:11 +0000 (UTC)
X-FDA: 83895033222.24.3259120
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011069.outbound.protection.outlook.com [40.107.208.69])
	by imf25.hostedemail.com (Postfix) with ESMTP id CFA8AA0013
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:25:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TR85zBP+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.69 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758025509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lf6Lo4GHmVHv45h8UNJrWYOxsmekted8s+hIRd5zl9Q=;
	b=GZNU2/Bj5fgYE6ZrwRtKt2lsweorQLABF0YTJ1wkjMar2FzhUqJViM5mVgwXrNxXi4H/2x
	03Li2C/+RCoThNEBAxwrinsxkVUbcAplzwb+OcXZSV1JqoDVwSruvhM4uAQ0SaDEN99CG2
	lnWFf2ZEy5w5zFTZrjyTOn6RW2mv+/s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758025509; a=rsa-sha256;
	cv=pass;
	b=xuMQaTYylDT0gygn5fw64LqCxDHRsUWdEhhgUnJd+Klci9IE+Y1aPZu7UG8tenR97Xi1oV
	xvv8bq8cJug0HrNqMns/ViZbOtYvwnP1P1WXly5rIud1cql06sTl59YwQCw3o+C0g5njm3
	e51VMqf7SBSehF+63dv25gjj2iJH/8Y=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TR85zBP+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.69 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KVFzRHyznrvl/W5p1WCC8/XUdGdn2Xt2bZl0UcPHDHjTQqThhTYJOi4zYXBxr4ZYCDToVBTsVPVESK2Ot1Hb3ZUFTMf3jyMBg+4iu4dpIb9FUMj8IOWYlVM4WE1Px2mnSjuTYKbUOBSVdmFULzRkYhxDHE5WLE+DBt8F8kqlVJ/zNX39FajYwc/iV3ohU6g3UN7Rq95vYF3hzk2VvbRfZXcEsPpq2YNA7nbP5YEB7QsDatjmkIupm05dRPqkEzzOjUsKm4KtCS7XXgSUqaExwzEv5bGy2F5POyqnrTxKMRr47UpabEBbRCXEtx6K8zTFRHnq0/IitRjMKeiCdxf4Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lf6Lo4GHmVHv45h8UNJrWYOxsmekted8s+hIRd5zl9Q=;
 b=MrQFQD/SFJVCG9HbOTE2QLCoARg8PXa6VOX1f+U2VEpv4mhw0bptnpkVtTd3kFMnGD4Hkn19awO9ntKxvuKbjCqG6EpiMgCAw0GFt1HVq1sTL1GY4WSgBzkS178O0d5DX6pDAZVYqRwLAcKBPJO3gkS51jLL2oIG8ho9JVIlvrlIQQiyPWtK3K+p5BGH/11m2fZcLzKHJiL7TEgyCUtvobFy+7FlPc6Q8WaG/kbWaL41W8xRVmzZkG/G5nQYDbnyhlWVAlqQl5uPO5fS97vZcObcACESZMJXOCMrcZilvTBNhcMEMkJbbxmE4EYqGg6XBEOH2qM6Rg76PDjX4fGeow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lf6Lo4GHmVHv45h8UNJrWYOxsmekted8s+hIRd5zl9Q=;
 b=TR85zBP+eHrteiL4u6IywoPq8iSeYxUp7eHuvoToTGx1/hU3pCzGzdQXRXfQkC67fLOJaXKCwaGDkluUz50xoD2/stYOlM2Bezvzor8ocnN6GINehKsZ90HrpVC7g/L1oPQFZ9uJWahKLRtur1X2oNE0ZGvpHTTw92VWURHtMNupUQmE3fyu9D+92W+JNFRwG0RsjsPBv8UuGrlNH2TiZzaDfRV+VxR1Ud4Pe8RqVup1oxn1/G7Nulqu3ER8FOsqDitTEh+ISYO/2bUdxX5BMZMlb+PcZI9wIVon9hEaR/UdvUQoRXv4f+p71iS4y/cAAxJLy3fxfNqUGI9EnmsIKw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 16 Sep
 2025 12:21:56 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9115.018; Tue, 16 Sep 2025
 12:21:56 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [v6 06/15] mm/migrate_device: implement THP migration of zone device pages
Date: Tue, 16 Sep 2025 22:21:19 +1000
Message-ID: <20250916122128.2098535-7-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250916122128.2098535-1-balbirs@nvidia.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0098.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::13) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 238cf21b-67fd-4b43-5b55-08ddf51ba05f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b2piVGx6aytDSE9jaExBSXpyUG1oMFVHdWc0WkVIZEJwZzR4VDhzSFVheC93?=
 =?utf-8?B?TjVDZnVPOGplcXdVYVBwMDZxZ1dadDNVeElaS0l3cUZnMndLRlZNa1cwc0Fo?=
 =?utf-8?B?UDFTeGJFTnc5Q2lKcnMyMzhVZEt1MFdOdG1JUzJjQ2lhSmwza0kyaytwT1lo?=
 =?utf-8?B?RGsrOGVuVHZ6b3Y3bjJKTWtzcVB4QUYrV0p5TXovNkl5cmxkSWRUUEhNZk1l?=
 =?utf-8?B?Y0xmVTQ1S0ZZWVVxZUZvRU00NlExUGZ1S1c1bVB4Y2FlMTBLTkp5WlV1aWFP?=
 =?utf-8?B?TndBclJsUjMvLzJuUlV2TlZVS3M0N0ZVUGdhN0RUWGpwU2EreWlGTGdDOVoy?=
 =?utf-8?B?VklGZzVLYlJIZVRsV04razZRWnkzUzJRSStGc1U3Ri9MQWF0WlY4LzN6MjQx?=
 =?utf-8?B?bnFRVFdXaHdvWEJSanVtbnZLWXozQ1FFK2dWdDY0NHFRcTBYYTVaakZ0UmUz?=
 =?utf-8?B?bWdLaVlkMi9QOExTQ21sUzA0cmJvT2l0UjBtbkV5MnpocUNZZFA1azBzcUN5?=
 =?utf-8?B?Zi81RFA4QmQ3b3g1QjRMKzhkcW9EK2VKcDF4L0p3NDJuVmF3VFoweWsvV0Qv?=
 =?utf-8?B?Sko2UzNBeHlTMmtmMCtHQkQvSUN3eFNpZzJSck1KUEs4UHhHVUwyUzVheHBy?=
 =?utf-8?B?eDRXZFFBQXVTSHNEQitjcHo5WmYweDd2b3RmdjVMS0swSTMwYW5iTjU3Ymh5?=
 =?utf-8?B?bW5xQVpnNTZ0SXBMNC94TU1uMDVsZlpSdWhNM2Q1NGdGT0M0VE1IckREMWgv?=
 =?utf-8?B?UkU4MDJoLzJiNXlCbFVrSHU5amt5M2I4WjFCOXJUTWdOYjQ4dGZLdnN0VUNY?=
 =?utf-8?B?R0t2Mitpank2RXdxNTFqYjRHa3dseWNJajVqQkhrcjZtTjBHTDF4am1yTjJU?=
 =?utf-8?B?RDkxSnhlcmhzOWJNem1odHhER1dBNWYxU1BWZnlpVXJBa01MM3UyZGtidUF6?=
 =?utf-8?B?RXZsWmtqU1VsWTdJcmdlZVFnL3ZqK0RyaldSZ3ZYTUUyaE44UHlEdk8rdHI3?=
 =?utf-8?B?T3BqS2NTeEQ5QlpRV1p2R0dDQ2VNclFMMVRtaXhkVGhhN3ZCa3poU3BHRFh5?=
 =?utf-8?B?THBmMjUzUHczS2g1cVpuMU5acDZHWUJKakxjMTYwa0Rja0FnM2RvWFYyY0t1?=
 =?utf-8?B?MzViVmFSdTI1TVg3N1JqQXBqbFJ0M2NRcVpGSXBuNDNPcWhaM2JWSEl1OTBa?=
 =?utf-8?B?REpzWlliSnZGV1JkRzJYNEI1ZytTMUJOUmUxcjJuNWF2aWtWb3U0ak5DWXRH?=
 =?utf-8?B?Vm85M1UxaHplYkdET0VNZTl4d25WSkRJR3N4WjdxdjZsd293bnVkcW5qR3FC?=
 =?utf-8?B?SVA0ZHpmYWU1NWZnUm94WmY5a0hnNCt3MFY3WEIrS3RWRjMyWnJtL3g5azFY?=
 =?utf-8?B?bysxVUZjYXExSHh2QzdoVXU5NnFYd2xQKzNjQ1MyajFOalczK0ZzSVJ2T0tp?=
 =?utf-8?B?UWpzQm9wclU4UkdwdGs2SG9xQ2hpUEFzd1dXQ0NjeEY1MTRaRHpNT1BSay8r?=
 =?utf-8?B?UDJlTEU5R1J5S2hyTk5KTTJQL3hYbFZxR3ozU3Z3SWhsTzlxY3ZJUjQvNlJo?=
 =?utf-8?B?TTE0ZGNXRlVLRzFhYzdBdVM4b3FTVU5wb090cUpIM2FCU3pYUy9mOUFGenhX?=
 =?utf-8?B?ZnFWQkJ5Q3FEaWhYei9iRnV5YXM1ZWRLdHBvWTZzTnJXQm1vS2o1anlPTTFv?=
 =?utf-8?B?bTVRZzVDdjFsaU5oQmdUTEM4VVVoZGJDL3Z3SlQ2dXhDeXZMaWNMNm5tZDNp?=
 =?utf-8?B?bW1NMWk2ZFdJU0oyZGFMN1FidWJlcDdrbEJQcEp3dkJYQXREM3pTQndFY0Ro?=
 =?utf-8?B?TEd4bW9ZVk8xajFRWGkyRkRsbU1FOXdRUndwRjlLd21SMVJ4STJxdTZxWWhP?=
 =?utf-8?B?NHFvOFUvSE4yakNqckdMeElVbEQzQTRmOFhpWHVsaEVzbFZNY3VZa2hyUWNH?=
 =?utf-8?Q?wvJf78G4jzc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHJpUUt3eCtGRnBEN0U5V3NJbHZWOFFrdUNZaDBjUkE2enhCM2duR1pKTlNh?=
 =?utf-8?B?ZkNLSHcrTVlKSkJsUVhoamxTRE9VL2NsWnMrNDhmNnIrV0hvc0svejNBeWdq?=
 =?utf-8?B?OFFxMHh0K3pvaXRTZVpRc3M5dWVnR2JwUmlYUW56NlJUeWhnV2pUa3l4QTFu?=
 =?utf-8?B?ZWRUR3VvSko2UmN4bThZSjBvL1p5cFdSYkpUVzFBbmh2UFo5K1ZmbTdwVzcv?=
 =?utf-8?B?SUdhVm80OHA4QzZtR0VzcUsrUjlMUFJuTG5LNFhIY25PNkJPMDRDVGhEbEpG?=
 =?utf-8?B?UDNMSzlyUTcxc2c3a3lkSXljRHYyeUtJS1RtSEJrWUI0SWZUMWpOWmFsa0Fq?=
 =?utf-8?B?bHMzUmluMEtpMFRrNm1TelhOZHUwY2d2bkxHbU40UnRod0I3TUMxakIycGUz?=
 =?utf-8?B?SkdoTkNLcVF2dmo1M0k2dGJYTUdUWTcvK2tiVkRuKzFKRlRDR05qUVBaODYv?=
 =?utf-8?B?cGdNSzQ0ZEpmZVNlN3FNTUU3UDVaMzN1RGRxUTdHazhqSFcvRWZoZ2V6Qmw4?=
 =?utf-8?B?aVhTODJRMXN6d1F3NTBzUmF6Z2ZQN1RqaWIraDUzWnVyN0VUUzFRSGJHcXl5?=
 =?utf-8?B?QWhrMG9vVWlrNFhLb2M0ZklHZElZR1VkbUxBaEJsRk9hTVN5S1h3MFBqblZY?=
 =?utf-8?B?RjFsOERubTRHbkN1SzA2RWZSZzkxZVRqc0s2Um40Y1BrOEQ0M2xBZTArR3ht?=
 =?utf-8?B?N1YzdGlFUTlKWVZxM2tWdDliV21xUWpFNEFncjVweUlEdTY2UW5BRmpkcnBS?=
 =?utf-8?B?OW90TUszTWdNYVUvMlBFdjcxV29rbGRWdnQ3a2pHc1dlOEJYbWhnb0s0UFIx?=
 =?utf-8?B?em1yYmphQytubnhiL3ArOGJJTFFnVlhydFdvc1BnNUw2RUh3dHRmS1FJSWpt?=
 =?utf-8?B?cGNNcnNLcmRVL3VCUTVVMitMc2dYa3ZKWm9lRmoxNDQ2dGtoUmREZW5nVmhT?=
 =?utf-8?B?RHRYNE5tYXlENHkyUmhLTUVLTFMyUnVZd3NVaDBvVGFXaDdTeVkydGJhNEV0?=
 =?utf-8?B?d0lzemdpY1J5QWpSc2pNOHdlV1U5YXYzV0hjV0luUWU3K2Y4R0JoSG5LSXNN?=
 =?utf-8?B?U2Y3T2hsYkU2UXhLY28rT0FaTmxOdExtQzNqQVd4K1RXZ2d2d3dxTi9CbE1F?=
 =?utf-8?B?YlFLMTFmRlFsWUJZbzdBNHlYTWtZenhSZ0xXeFYvNDRYS1ZEUlZnckUxZHFx?=
 =?utf-8?B?dWVpVmdxUFFKZ0NzYWtrb0xxaU5hbytmeEpnSHU4N3hJRTRpZWlFN1FFOFU0?=
 =?utf-8?B?SlpWV0ljMzF2Um9zSlp2TVdsYXJKeTZKd0Fpd243anQ0a3lBZkJPanJXcFRl?=
 =?utf-8?B?T29zUXJsbm1rVVdjTTMvOHJGRE9CS25wR2RLRGN3SmlHWFF6SFFEU3dkVElr?=
 =?utf-8?B?WkhlRE1OTHBrMGp3ZkVSWjBHbGRxQ3pjdzZ0V0poODl2SUlqaW9qSTBNM05t?=
 =?utf-8?B?Nks0WHJ3RGc4VEdlVGRINzYxR05ONUpYbVZpbWNwZmZQektXc0xsbWhvSVFp?=
 =?utf-8?B?WnJCK0hhb0ZEdGVQU21zUlF0M1Q5bHVTa1BVOGJUM1dVVFh6T3hqa1U4T2RC?=
 =?utf-8?B?NGhXRkVkNUlKSEtwdWpSbWUrdmhOV2N5VWt1Y3Q0VERSbExnRjFtMWpLSWxx?=
 =?utf-8?B?ZXBjK1hmc3NDWVpibTYwVnlKSGk3T2RiN1pUYzNFcmVIaTFRR2hlKzdNMlo1?=
 =?utf-8?B?RnkxMkdKK0xUcnpaTmdna2U3bXJaOE9tMDVSeTZRSEtIc0pwSUp1ZUduaVJC?=
 =?utf-8?B?cndSTDlycWtDWGlKcU5PdXVabW82UmFWSDk4OUhVM3lndU9jYkFzWFBWdkNM?=
 =?utf-8?B?ZUQranJ6TWdkM1ZxWS9zWVBXMHJXM1hFeWJHWlhkMU5aMGJyZjQvRjE2a2k4?=
 =?utf-8?B?ODVPRzVSSHhGMGsyVEFrVW1wOGQzQmltb3hqOWxJWVFMdmdsSFpKdzhBRmg3?=
 =?utf-8?B?K1J0YzNvM1ZETWducXNMSDl3c3dMTk9wU21GSDlSYm1IUUdaK0xMZTJPNmNp?=
 =?utf-8?B?M3hVSDU1UTdXUG54bkpQZ1ozQUYxRjZUNVB5Uy9uWXZKZHBzNFc4Z1QzNjZa?=
 =?utf-8?B?WkEyTFN1cW4xSW45OERDZlA2OEdLVjZXc1BGUWZKQWtVRVFYV0E1NHd4Y1Y0?=
 =?utf-8?B?aGNidVRJR1FHK0Z1eWlIdWtGeENpbFRnTVdkaHpEL3Y1cnhkb1VyMlNMZFND?=
 =?utf-8?B?WlE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 238cf21b-67fd-4b43-5b55-08ddf51ba05f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 12:21:56.2641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kxKKAwUl+gJ/Jbrb6ulnZTEqRh6j6CaShc88ctTta4rr4krJ5cmGETMuxOqWJGACqQ4G8Nykf0UlcY9TlaJbkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CFA8AA0013
X-Stat-Signature: ijnzqfuhon18drzyhpxgh5mf4dp87ub7
X-Rspam-User: 
X-HE-Tag: 1758025508-720456
X-HE-Meta: U2FsdGVkX1/d9JMSN+ZPFgPtWCDeP8MwmLMxIm3LFwThCdx4oZNWzcW3I7qCixS/+zMvWEYJ+/tZORSpw79OZeMUUiQQCIl5U5G+i7WUm/RFkKtfBm0rLEa44bVPVrVgSedpYYe/Wbko+h8xcpecRLMV0voeyc+vqKBVDsDFnxRKhAMkXxy3zilynXl4K1suPbKsoS84wK7OYSr6m0V8aaCDk8mFOyrejbWzIqoan1fIp+UFVGDVzBnPeq60ilnWv1W5VgrN6JShF9IhFiHQXmxBTMZuH9kfRWU2+wrS+RtsTowtahz+0/AFMY167nKqNmFJi4nMDq8uFiRmm2/zwCF/SuNNd/gJCqCMXFB1dU5nV1g/6pend0qa38Zgvw4NKbB/C+U45HxBbeR9WbKLp0EYu21+L96GjCnhDGtZLLvHHoJystXh/hKkr2ykj5uoMC/Ar2e2e4EqgyuL9rO64IHJNgDlI1+dg3nSgV4nwW2MYww8atuPF/c8ZN7SfxejtnnyJ6WWWvTF4NQm6m4McypCKICd8I13kAss9HEbJ6Ipyl8OcHF1R8XZ11vxkJwxSq4mjPme/5nlSFBpzUJ/xME8BlD0OOwOiZUKy7m7goBu0ZFYpcx1vTMhDqg72HH/6LcYse8WG1UEP9htD9xnr/ukERyovBwrLT5BC5zijTRAj0K7CGOLq9Fr7KgCVBeIonqLnREpg9mqAxkTPjteB5bT3XJsbIPiEfCHIm61WUgIpRuQmj60fygtisNs3T1220pNTgbYLOX95P+FSEJ1mkuR6GA6YSxIuUcIfoLfOHlXl4QxYu7DUEl5+M55YMXjcEMRDP3N0Kc5LtdNQMFbD89C9S3do3ct393P39jzP86Z/td2MfIlWW5jS3Xx60fgz5z4JCQSVD1FIJejHyvhEMYFbEPrFGkBiOBKCX1J5IyHfNjFkO0pCo8oRoQijAqD129AWZZhVX4SQSUbUJz
 Ry/O/ZTI
 rbBTuGT5jGGVu7W0e5dX3gqQ++sQ0Mj7cJO7JI4ALTY00vo1KA5OlaFZX9dAt/bcAe+UZ4Kt57hEvKdvub22/vRT4VgBtCWtooVat79v1QU31xNm4Jk40pUZz5jU2C/m+8QeH3We/k7o3Qy3q6IHpZygW6UgW01kgoIWOt+nMDpYwJihKJmgCmj5PJ15WJXD9/H3+yQ45P16hU0HwjJIw7AssD4FMI4flQDauhCxwvNUOXj6qso49vqm/jN9sMXY+H1lRjQPSvGlLKi+8GL8fN6txD5yvlwTdOt8QHfy55se4PuyOG/FOnk6rhAUFE4JtIGLblfNk/zfDomGYjVOMWoESsHNCY9eMtoZG5Wv/OTYbRcfWtTz/5ubtYDQtaFOWa4gbbIjOP9zHSQ2XWJQ2QxozNxdxuTKHzZt2RTXY6K31vKlGpS+B4U8Ou5fGYUnp7o2OvLMe51VlnfJRGE/XG3WFenUk/rCxrVuvG6X6E+nJ3wbEQ8LQWpQe1TnaMnt6IBMFfv7K75Zs3TfoffMqSSWaYNI12UotqSw6jlt2aaz6MHpZSQhoz7H3Q54a+VqtaOwv8WRP9eKz+m4D+QxzlGWsC4+7CcqbrgqTKeXujzlJm795rR05qc/HR2Of/UotXh0ZuDwHxR0r/BAnJzfszOgSO40QExKd+PbxnXrp9MmqaLmaHrWOi8OrqUUJhNc7VptGGJKUqSiMwupXLIKEFtRqAqUHY7OLfdyaW0HzUSK9yF/c1E/z9e8Jx57fg95gfthEeJyPXFrIGdJv6csAVAW2VfLOeS4QDpOjvw6B4iTgATY22psB36XWWEtUBLAOT0nVKkDzVBXQJGlP7HRYHj5EYNRU0qp+2G1f8BcsMHiMpvLaP1vBv+Cw8/iS5gMzoO68i8mQPxm/cWKRiAcJnMrTFAxEwC6MA+8tIcDkfWPu5bHmii+EKtdxg7allHF1UVVr3aFbuYYl2f4j6odjxYWqjsBE
 HQfVedYv
 QYXfzYuqXpBOt+sHHArAP+reVTOEJfPnBv3oBR4AQk5ilJR137XJz64Y8bYvVd5UyB9YdwrfwzO6wS/knu6oY0gNi+eN9J6bZ0VPW6wkhMTnhZxMa7sL7U3qM4Um5h0b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MIGRATE_VMA_SELECT_COMPOUND will be used to select THP pages during
migrate_vma_setup() and MIGRATE_PFN_COMPOUND will make migrating device
pages as compound pages during device pfn migration.

migrate_device code paths go through the collect, setup and finalize
phases of migration.

The entries in src and dst arrays passed to these functions still remain
at a PAGE_SIZE granularity.  When a compound page is passed, the first
entry has the PFN along with MIGRATE_PFN_COMPOUND and other flags set
(MIGRATE_PFN_MIGRATE, MIGRATE_PFN_VALID), the remaining entries
(HPAGE_PMD_NR - 1) are filled with 0's.  This representation allows for
the compound page to be split into smaller page sizes.

migrate_vma_collect_hole(), migrate_vma_collect_pmd() are now THP page
aware.  Two new helper functions migrate_vma_collect_huge_pmd() and
migrate_vma_insert_huge_pmd_page() have been added.

migrate_vma_collect_huge_pmd() can collect THP pages, but if for some
reason this fails, there is fallback support to split the folio and
migrate it.

migrate_vma_insert_huge_pmd_page() closely follows the logic of
migrate_vma_insert_page()

Support for splitting pages as needed for migration will follow in later
patches in this series.

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
---
 include/linux/migrate.h |   2 +
 mm/migrate_device.c     | 468 ++++++++++++++++++++++++++++++++++------
 2 files changed, 407 insertions(+), 63 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 1f0ac122c3bf..41b4cc05a450 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -125,6 +125,7 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
 #define MIGRATE_PFN_VALID	(1UL << 0)
 #define MIGRATE_PFN_MIGRATE	(1UL << 1)
 #define MIGRATE_PFN_WRITE	(1UL << 3)
+#define MIGRATE_PFN_COMPOUND	(1UL << 4)
 #define MIGRATE_PFN_SHIFT	6
 
 static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
@@ -143,6 +144,7 @@ enum migrate_vma_direction {
 	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
+	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
 };
 
 struct migrate_vma {
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 70c0601f70ea..1663ce553184 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -14,6 +14,7 @@
 #include <linux/pagewalk.h>
 #include <linux/rmap.h>
 #include <linux/swapops.h>
+#include <linux/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
 
@@ -44,6 +45,23 @@ static int migrate_vma_collect_hole(unsigned long start,
 	if (!vma_is_anonymous(walk->vma))
 		return migrate_vma_collect_skip(start, end, walk);
 
+	if (thp_migration_supported() &&
+		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
+		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
+		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
+		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE |
+						MIGRATE_PFN_COMPOUND;
+		migrate->dst[migrate->npages] = 0;
+		migrate->npages++;
+		migrate->cpages++;
+
+		/*
+		 * Collect the remaining entries as holes, in case we
+		 * need to split later
+		 */
+		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
+	}
+
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
 		migrate->dst[migrate->npages] = 0;
@@ -101,57 +119,150 @@ static int migrate_vma_split_folio(struct folio *folio,
 	return 0;
 }
 
-static int migrate_vma_collect_pmd(pmd_t *pmdp,
-				   unsigned long start,
-				   unsigned long end,
-				   struct mm_walk *walk)
+/** migrate_vma_collect_huge_pmd - collect THP pages without splitting the
+ * folio for device private pages.
+ * @pmdp: pointer to pmd entry
+ * @start: start address of the range for migration
+ * @end: end address of the range for migration
+ * @walk: mm_walk callback structure
+ *
+ * Collect the huge pmd entry at @pmdp for migration and set the
+ * MIGRATE_PFN_COMPOUND flag in the migrate src entry to indicate that
+ * migration will occur at HPAGE_PMD granularity
+ */
+static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
+					unsigned long end, struct mm_walk *walk,
+					struct folio *fault_folio)
 {
+	struct mm_struct *mm = walk->mm;
+	struct folio *folio;
 	struct migrate_vma *migrate = walk->private;
-	struct folio *fault_folio = migrate->fault_page ?
-		page_folio(migrate->fault_page) : NULL;
-	struct vm_area_struct *vma = walk->vma;
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr = start, unmapped = 0;
 	spinlock_t *ptl;
-	pte_t *ptep;
+	swp_entry_t entry;
+	int ret;
+	unsigned long write = 0;
 
-again:
-	if (pmd_none(*pmdp))
+	ptl = pmd_lock(mm, pmdp);
+	if (pmd_none(*pmdp)) {
+		spin_unlock(ptl);
 		return migrate_vma_collect_hole(start, end, -1, walk);
+	}
 
 	if (pmd_trans_huge(*pmdp)) {
-		struct folio *folio;
-
-		ptl = pmd_lock(mm, pmdp);
-		if (unlikely(!pmd_trans_huge(*pmdp))) {
+		if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
 			spin_unlock(ptl);
-			goto again;
+			return migrate_vma_collect_skip(start, end, walk);
 		}
 
 		folio = pmd_folio(*pmdp);
 		if (is_huge_zero_folio(folio)) {
 			spin_unlock(ptl);
-			split_huge_pmd(vma, pmdp, addr);
-		} else {
-			int ret;
+			return migrate_vma_collect_hole(start, end, -1, walk);
+		}
+		if (pmd_write(*pmdp))
+			write = MIGRATE_PFN_WRITE;
+	} else if (!pmd_present(*pmdp)) {
+		entry = pmd_to_swp_entry(*pmdp);
+		folio = pfn_swap_entry_folio(entry);
+
+		if (!is_device_private_entry(entry) ||
+			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
+			(folio->pgmap->owner != migrate->pgmap_owner)) {
+			spin_unlock(ptl);
+			return migrate_vma_collect_skip(start, end, walk);
+		}
 
-			folio_get(folio);
+		if (is_migration_entry(entry)) {
+			migration_entry_wait_on_locked(entry, ptl);
 			spin_unlock(ptl);
-			/* FIXME: we don't expect THP for fault_folio */
-			if (WARN_ON_ONCE(fault_folio == folio))
-				return migrate_vma_collect_skip(start, end,
-								walk);
-			if (unlikely(!folio_trylock(folio)))
-				return migrate_vma_collect_skip(start, end,
-								walk);
-			ret = split_folio(folio);
-			if (fault_folio != folio)
-				folio_unlock(folio);
-			folio_put(folio);
-			if (ret)
-				return migrate_vma_collect_skip(start, end,
-								walk);
+			return -EAGAIN;
+		}
+
+		if (is_writable_device_private_entry(entry))
+			write = MIGRATE_PFN_WRITE;
+	} else {
+		spin_unlock(ptl);
+		return -EAGAIN;
+	}
+
+	folio_get(folio);
+	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
+		spin_unlock(ptl);
+		folio_put(folio);
+		return migrate_vma_collect_skip(start, end, walk);
+	}
+
+	if (thp_migration_supported() &&
+		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
+		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
+		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
+
+		struct page_vma_mapped_walk pvmw = {
+			.ptl = ptl,
+			.address = start,
+			.pmd = pmdp,
+			.vma = walk->vma,
+		};
+
+		unsigned long pfn = page_to_pfn(folio_page(folio, 0));
+
+		migrate->src[migrate->npages] = migrate_pfn(pfn) | write
+						| MIGRATE_PFN_MIGRATE
+						| MIGRATE_PFN_COMPOUND;
+		migrate->dst[migrate->npages++] = 0;
+		migrate->cpages++;
+		ret = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
+		if (ret) {
+			migrate->npages--;
+			migrate->cpages--;
+			migrate->src[migrate->npages] = 0;
+			migrate->dst[migrate->npages] = 0;
+			goto fallback;
 		}
+		migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
+		spin_unlock(ptl);
+		return 0;
+	}
+
+fallback:
+	spin_unlock(ptl);
+	if (!folio_test_large(folio))
+		goto done;
+	ret = split_folio(folio);
+	if (fault_folio != folio)
+		folio_unlock(folio);
+	folio_put(folio);
+	if (ret)
+		return migrate_vma_collect_skip(start, end, walk);
+	if (pmd_none(pmdp_get_lockless(pmdp)))
+		return migrate_vma_collect_hole(start, end, -1, walk);
+
+done:
+	return -ENOENT;
+}
+
+static int migrate_vma_collect_pmd(pmd_t *pmdp,
+				   unsigned long start,
+				   unsigned long end,
+				   struct mm_walk *walk)
+{
+	struct migrate_vma *migrate = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long addr = start, unmapped = 0;
+	spinlock_t *ptl;
+	struct folio *fault_folio = migrate->fault_page ?
+		page_folio(migrate->fault_page) : NULL;
+	pte_t *ptep;
+
+again:
+	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
+		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
+
+		if (ret == -EAGAIN)
+			goto again;
+		if (ret == 0)
+			return 0;
 	}
 
 	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
@@ -257,8 +368,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
 		}
 
-		/* FIXME support THP */
-		if (!page || !page->mapping || PageTransCompound(page)) {
+		if (!page || !page->mapping) {
 			mpfn = 0;
 			goto next;
 		}
@@ -429,14 +539,6 @@ static bool migrate_vma_check_page(struct page *page, struct page *fault_page)
 	 */
 	int extra = 1 + (page == fault_page);
 
-	/*
-	 * FIXME support THP (transparent huge page), it is bit more complex to
-	 * check them than regular pages, because they can be mapped with a pmd
-	 * or with a pte (split pte mapping).
-	 */
-	if (folio_test_large(folio))
-		return false;
-
 	/* Page from ZONE_DEVICE have one extra reference */
 	if (folio_is_zone_device(folio))
 		extra++;
@@ -467,17 +569,24 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
 
 	lru_add_drain();
 
-	for (i = 0; i < npages; i++) {
+	for (i = 0; i < npages; ) {
 		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 		struct folio *folio;
+		unsigned int nr = 1;
 
 		if (!page) {
 			if (src_pfns[i] & MIGRATE_PFN_MIGRATE)
 				unmapped++;
-			continue;
+			goto next;
 		}
 
 		folio =	page_folio(page);
+		nr = folio_nr_pages(folio);
+
+		if (nr > 1)
+			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
+
+
 		/* ZONE_DEVICE folios are not on LRU */
 		if (!folio_is_zone_device(folio)) {
 			if (!folio_test_lru(folio) && allow_drain) {
@@ -489,7 +598,7 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
 			if (!folio_isolate_lru(folio)) {
 				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 				restore++;
-				continue;
+				goto next;
 			}
 
 			/* Drop the reference we took in collect */
@@ -508,10 +617,12 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
 
 			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 			restore++;
-			continue;
+			goto next;
 		}
 
 		unmapped++;
+next:
+		i += nr;
 	}
 
 	for (i = 0; i < npages && restore; i++) {
@@ -657,6 +768,160 @@ int migrate_vma_setup(struct migrate_vma *args)
 }
 EXPORT_SYMBOL(migrate_vma_setup);
 
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+/**
+ * migrate_vma_insert_huge_pmd_page: Insert a huge folio into @migrate->vma->vm_mm
+ * at @addr. folio is already allocated as a part of the migration process with
+ * large page.
+ *
+ * @page needs to be initialized and setup after it's allocated. The code bits
+ * here follow closely the code in __do_huge_pmd_anonymous_page(). This API does
+ * not support THP zero pages.
+ *
+ * @migrate: migrate_vma arguments
+ * @addr: address where the folio will be inserted
+ * @page: page to be inserted at @addr
+ * @src: src pfn which is being migrated
+ * @pmdp: pointer to the pmd
+ */
+static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
+					 unsigned long addr,
+					 struct page *page,
+					 unsigned long *src,
+					 pmd_t *pmdp)
+{
+	struct vm_area_struct *vma = migrate->vma;
+	gfp_t gfp = vma_thp_gfp_mask(vma);
+	struct folio *folio = page_folio(page);
+	int ret;
+	vm_fault_t csa_ret;
+	spinlock_t *ptl;
+	pgtable_t pgtable;
+	pmd_t entry;
+	bool flush = false;
+	unsigned long i;
+
+	VM_WARN_ON_FOLIO(!folio, folio);
+	VM_WARN_ON_ONCE(!pmd_none(*pmdp) && !is_huge_zero_pmd(*pmdp));
+
+	if (!thp_vma_suitable_order(vma, addr, HPAGE_PMD_ORDER))
+		return -EINVAL;
+
+	ret = anon_vma_prepare(vma);
+	if (ret)
+		return ret;
+
+	folio_set_order(folio, HPAGE_PMD_ORDER);
+	folio_set_large_rmappable(folio);
+
+	if (mem_cgroup_charge(folio, migrate->vma->vm_mm, gfp)) {
+		count_vm_event(THP_FAULT_FALLBACK);
+		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+		ret = -ENOMEM;
+		goto abort;
+	}
+
+	__folio_mark_uptodate(folio);
+
+	pgtable = pte_alloc_one(vma->vm_mm);
+	if (unlikely(!pgtable))
+		goto abort;
+
+	if (folio_is_device_private(folio)) {
+		swp_entry_t swp_entry;
+
+		if (vma->vm_flags & VM_WRITE)
+			swp_entry = make_writable_device_private_entry(
+						page_to_pfn(page));
+		else
+			swp_entry = make_readable_device_private_entry(
+						page_to_pfn(page));
+		entry = swp_entry_to_pmd(swp_entry);
+	} else {
+		if (folio_is_zone_device(folio) &&
+		    !folio_is_device_coherent(folio)) {
+			goto abort;
+		}
+		entry = folio_mk_pmd(folio, vma->vm_page_prot);
+		if (vma->vm_flags & VM_WRITE)
+			entry = pmd_mkwrite(pmd_mkdirty(entry), vma);
+	}
+
+	ptl = pmd_lock(vma->vm_mm, pmdp);
+	csa_ret = check_stable_address_space(vma->vm_mm);
+	if (csa_ret)
+		goto abort;
+
+	/*
+	 * Check for userfaultfd but do not deliver the fault. Instead,
+	 * just back off.
+	 */
+	if (userfaultfd_missing(vma))
+		goto unlock_abort;
+
+	if (!pmd_none(*pmdp)) {
+		if (!is_huge_zero_pmd(*pmdp))
+			goto unlock_abort;
+		flush = true;
+	} else if (!pmd_none(*pmdp))
+		goto unlock_abort;
+
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
+	if (!folio_is_zone_device(folio))
+		folio_add_lru_vma(folio, vma);
+	folio_get(folio);
+
+	if (flush) {
+		pte_free(vma->vm_mm, pgtable);
+		flush_cache_page(vma, addr, addr + HPAGE_PMD_SIZE);
+		pmdp_invalidate(vma, addr, pmdp);
+	} else {
+		pgtable_trans_huge_deposit(vma->vm_mm, pmdp, pgtable);
+		mm_inc_nr_ptes(vma->vm_mm);
+	}
+	set_pmd_at(vma->vm_mm, addr, pmdp, entry);
+	update_mmu_cache_pmd(vma, addr, pmdp);
+
+	spin_unlock(ptl);
+
+	count_vm_event(THP_FAULT_ALLOC);
+	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
+	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
+
+	return 0;
+
+unlock_abort:
+	spin_unlock(ptl);
+abort:
+	for (i = 0; i < HPAGE_PMD_NR; i++)
+		src[i] &= ~MIGRATE_PFN_MIGRATE;
+	return 0;
+}
+#else /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
+static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
+					 unsigned long addr,
+					 struct page *page,
+					 unsigned long *src,
+					 pmd_t *pmdp)
+{
+	return 0;
+}
+#endif
+
+static unsigned long migrate_vma_nr_pages(unsigned long *src)
+{
+	unsigned long nr = 1;
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+	if (*src & MIGRATE_PFN_COMPOUND)
+		nr = HPAGE_PMD_NR;
+#else
+	if (*src & MIGRATE_PFN_COMPOUND)
+		VM_WARN_ON_ONCE(true);
+#endif
+	return nr;
+}
+
 /*
  * This code closely matches the code in:
  *   __handle_mm_fault()
@@ -667,9 +932,10 @@ EXPORT_SYMBOL(migrate_vma_setup);
  */
 static void migrate_vma_insert_page(struct migrate_vma *migrate,
 				    unsigned long addr,
-				    struct page *page,
+				    unsigned long *dst,
 				    unsigned long *src)
 {
+	struct page *page = migrate_pfn_to_page(*dst);
 	struct folio *folio = page_folio(page);
 	struct vm_area_struct *vma = migrate->vma;
 	struct mm_struct *mm = vma->vm_mm;
@@ -697,8 +963,24 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 	pmdp = pmd_alloc(mm, pudp, addr);
 	if (!pmdp)
 		goto abort;
-	if (pmd_trans_huge(*pmdp))
-		goto abort;
+
+	if (thp_migration_supported() && (*dst & MIGRATE_PFN_COMPOUND)) {
+		int ret = migrate_vma_insert_huge_pmd_page(migrate, addr, page,
+								src, pmdp);
+		if (ret)
+			goto abort;
+		return;
+	}
+
+	if (!pmd_none(*pmdp)) {
+		if (pmd_trans_huge(*pmdp)) {
+			if (!is_huge_zero_pmd(*pmdp))
+				goto abort;
+			split_huge_pmd(vma, pmdp, addr);
+		} else if (pmd_leaf(*pmdp))
+			goto abort;
+	}
+
 	if (pte_alloc(mm, pmdp))
 		goto abort;
 	if (unlikely(anon_vma_prepare(vma)))
@@ -789,23 +1071,24 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 	unsigned long i;
 	bool notified = false;
 
-	for (i = 0; i < npages; i++) {
+	for (i = 0; i < npages; ) {
 		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
 		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 		struct address_space *mapping;
 		struct folio *newfolio, *folio;
 		int r, extra_cnt = 0;
+		unsigned long nr = 1;
 
 		if (!newpage) {
 			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-			continue;
+			goto next;
 		}
 
 		if (!page) {
 			unsigned long addr;
 
 			if (!(src_pfns[i] & MIGRATE_PFN_MIGRATE))
-				continue;
+				goto next;
 
 			/*
 			 * The only time there is no vma is when called from
@@ -823,15 +1106,47 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 					migrate->pgmap_owner);
 				mmu_notifier_invalidate_range_start(&range);
 			}
-			migrate_vma_insert_page(migrate, addr, newpage,
+
+			if ((src_pfns[i] & MIGRATE_PFN_COMPOUND) &&
+				(!(dst_pfns[i] & MIGRATE_PFN_COMPOUND))) {
+				nr = migrate_vma_nr_pages(&src_pfns[i]);
+				src_pfns[i] &= ~MIGRATE_PFN_COMPOUND;
+				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+				goto next;
+			}
+
+			migrate_vma_insert_page(migrate, addr, &dst_pfns[i],
 						&src_pfns[i]);
-			continue;
+			goto next;
 		}
 
 		newfolio = page_folio(newpage);
 		folio = page_folio(page);
 		mapping = folio_mapping(folio);
 
+		/*
+		 * If THP migration is enabled, check if both src and dst
+		 * can migrate large pages
+		 */
+		if (thp_migration_supported()) {
+			if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
+				(src_pfns[i] & MIGRATE_PFN_COMPOUND) &&
+				!(dst_pfns[i] & MIGRATE_PFN_COMPOUND)) {
+
+				if (!migrate) {
+					src_pfns[i] &= ~(MIGRATE_PFN_MIGRATE |
+							 MIGRATE_PFN_COMPOUND);
+					goto next;
+				}
+				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
+				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
+				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
+				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+			}
+		}
+
+
 		if (folio_is_device_private(newfolio) ||
 		    folio_is_device_coherent(newfolio)) {
 			if (mapping) {
@@ -844,7 +1159,7 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				if (!folio_test_anon(folio) ||
 				    !folio_free_swap(folio)) {
 					src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-					continue;
+					goto next;
 				}
 			}
 		} else if (folio_is_zone_device(newfolio)) {
@@ -852,7 +1167,7 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 			 * Other types of ZONE_DEVICE page are not supported.
 			 */
 			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-			continue;
+			goto next;
 		}
 
 		BUG_ON(folio_test_writeback(folio));
@@ -864,6 +1179,8 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 		else
 			folio_migrate_flags(newfolio, folio);
+next:
+		i += nr;
 	}
 
 	if (notified)
@@ -1025,10 +1342,23 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
 int migrate_device_range(unsigned long *src_pfns, unsigned long start,
 			unsigned long npages)
 {
-	unsigned long i, pfn;
+	unsigned long i, j, pfn;
+
+	for (pfn = start, i = 0; i < npages; pfn++, i++) {
+		struct page *page = pfn_to_page(pfn);
+		struct folio *folio = page_folio(page);
+		unsigned int nr = 1;
 
-	for (pfn = start, i = 0; i < npages; pfn++, i++)
 		src_pfns[i] = migrate_device_pfn_lock(pfn);
+		nr = folio_nr_pages(folio);
+		if (nr > 1) {
+			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
+			for (j = 1; j < nr; j++)
+				src_pfns[i+j] = 0;
+			i += j - 1;
+			pfn += j - 1;
+		}
+	}
 
 	migrate_device_unmap(src_pfns, npages, NULL);
 
@@ -1046,10 +1376,22 @@ EXPORT_SYMBOL(migrate_device_range);
  */
 int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
 {
-	unsigned long i;
+	unsigned long i, j;
+
+	for (i = 0; i < npages; i++) {
+		struct page *page = pfn_to_page(src_pfns[i]);
+		struct folio *folio = page_folio(page);
+		unsigned int nr = 1;
 
-	for (i = 0; i < npages; i++)
 		src_pfns[i] = migrate_device_pfn_lock(src_pfns[i]);
+		nr = folio_nr_pages(folio);
+		if (nr > 1) {
+			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
+			for (j = 1; j < nr; j++)
+				src_pfns[i+j] = 0;
+			i += j - 1;
+		}
+	}
 
 	migrate_device_unmap(src_pfns, npages, NULL);
 
-- 
2.50.1


