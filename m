Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461D4CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E83C8E0006; Mon, 15 Sep 2025 11:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898398E0001; Mon, 15 Sep 2025 11:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739128E0006; Mon, 15 Sep 2025 11:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB458E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:35:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04B8F1405CB
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:35:22 +0000 (UTC)
X-FDA: 83891883726.20.740E5D0
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012017.outbound.protection.outlook.com [52.101.53.17])
	by imf07.hostedemail.com (Postfix) with ESMTP id 36D784000F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:35:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Nxx64M/x";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757950520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V8B1zVm6xTlPax/Ty6C0qGKRqQac9tuQRGcqqfq93e8=;
	b=3fwAm4g7hGBb54ECkZdFcHuH1ojq22Dbdvj94KDwEmz12oIrqcKVr2NovCJPT7g6DcO7SE
	WgH98b7OUYcsHes29aI8weJhJo8jaFnZ0pseU2zDvcOsJUD0l+6rWyV4shGPCts5/KN1Tw
	c/dVguZkpq1mq1cFapWaW3g1Nf4BN8s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757950520; a=rsa-sha256;
	cv=pass;
	b=Cj68ynpqVlldQJzfaFuJv79KFWKVqKLqE8GEgfSNjv1GSHXLBLaVNm7RUxq2EfpS9p7qSS
	78oT1g7gcT42ulE51PmwjT2KREu5KlOdcLiIvgv5OrIV+LIP2DMgpaRNgB89zkDLYDj7t1
	DAlYaYMEJmj1mACRa+VogpXoW5aEfiU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Nxx64M/x";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F/cw3m3RqH2CuWioVDmKddDiVihNSfaFFFAHLLtTxOAfBkQQTgUQHWE3CNJfTZ4+KAXcohGQ1gyIgQvlZc7bWrJ24SzZVAhE0BKIkZPdxt4flWW7imlQCihwr9xhbGa3Jjr7UceeCSidDGDosJQ6fe+fVbHnEFqRDTrjYUai4abfPPj4Mi5QnuoMSwqbUv6hqtuqmL+X4IUwTl7LWaf3++Fhn0Bsbh2dmoomfy/9aii242s1R9Z3pHbXQI5AkHpOMtGCCI6dVezTijUSP3LQhZTYtbj5qjyXc3uh/tMHpo8PJJQT8tRsWX3gSN29aZpGAbYOGH+MVrDM453CbQQAZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8B1zVm6xTlPax/Ty6C0qGKRqQac9tuQRGcqqfq93e8=;
 b=bxZ+fya14it3rwSwd2D/R11ntP3/HahO4G0pcS5HE9h7k9wpsJeyex1Uw/dVzDDktuat73WEnrShTEUWUE689j+QxiJW56Bvx575nuJQu4MmmRud9/5BB039cdb11A7ynlF4q5cWbxBHccVPQjb07BrNNaL2PN0y7DY0YEGaZ7qMP2G+klAzA6h5RhnvikC62lOcvKXlJc/6XH6UcrwJjwf+YLbLlCQBXJ1LY1Ni98XY4CxXXAQ9f3IGQzdNxEIYhsX+216LYlr9sX19GZYeey7pLzj22jb90MLCrUDIwsIaG9O3sWq2N495DkQx0GfMNtEhMRxWEsXIsBMiV0lADQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8B1zVm6xTlPax/Ty6C0qGKRqQac9tuQRGcqqfq93e8=;
 b=Nxx64M/xxLnSp/29WufAdd1c33z8uN5MlTEy0JCkrwBYERC2+Q39b/z+JbZFwo5Jsh8/K76cVdjpT+qTCdmLnKZqUwsCxb2Ky26ExQsOmmsueBQgtrkCzJ/HVUulCG7m98k2T2A7FHKFzNXfjPq61O9yRmqVzXqvJQJo1OaVM8vU/sX2booJGzYe0og8VoAp7slDXR2ASYQWuRIa+LHqpbbaTAgKBBbBfZ+mC0QfK/HVCVOiZZsYy5PYRNMk1U5N1KiPegTASRJhRAFBvJoN1AkDv8cfr72cIejsdv2HeXeL/Jj+syaxDpxZeOw/ipQpwSwIYKlaTZh44LZSH3BzdA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BN7PPFDE2ACDA69.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 15:35:14 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 15:35:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kiryl Shutsemau <kirill@shutemov.name>,
 "Zach O'Keefe" <zokeefe@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] mm/khugepaged: Do not fail collapse_pte_mapped_thp() on
 SCAN_PMD_NULL
Date: Mon, 15 Sep 2025 11:35:12 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <63CFCF33-B334-446F-B6AE-EADB24A9F8CD@nvidia.com>
In-Reply-To: <v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh>
References: <v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR16CA0024.namprd16.prod.outlook.com
 (2603:10b6:208:134::37) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BN7PPFDE2ACDA69:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e450e64-69a6-496d-cf55-08ddf46d7732
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VndwaHJ4aU5QdFlheEhXdnk3Y3V0Wjl4RGp1WjI3Z012YzhwYlloZ3hDaGNX?=
 =?utf-8?B?WkdScXNqOXNXMm1HMWQ4YWU0SEk3dk1NRjJ3bHVzemMzb2MvSzl5OXR2amJa?=
 =?utf-8?B?QTM5YVdyNjBONXZkUHFZcWFFTVY5SU9CdWYwd25tZkpxWlF2TFk3VzhBaGI0?=
 =?utf-8?B?alo0SkdjV2hveUQ2RFgrUlgwZlNaSnNvR3hWem1acWQxZmJlN3ZrdFBscTZm?=
 =?utf-8?B?cU1wWXhhMnIraURYMlJ1SFplVHNlZU43R29OWDM2QjZndGJUWTJ5Uko4Q1li?=
 =?utf-8?B?Y2Y5OGNLYzY1aHYxaVQzQVNLN0lGcVF6WmljRkdBK2ZkWGkvaDdJQy85VUZC?=
 =?utf-8?B?SG1JVjl5by84MUVpcFc2VXVFKzJseFJqMkFUaVRvRUlucXJGeUk3RENMMklx?=
 =?utf-8?B?V0xZYWR3Z29TMXpaYVVkL2R1U3EvY3JqeVVPNzJ6QXAxQjB1MEo5QVBzUVIw?=
 =?utf-8?B?bGFGcFdoRGNqZmowektmUCt2Q0dmTFJ5UTNRRS9xK0xUTEEwVnhMd0dZcExj?=
 =?utf-8?B?Z3VrSDQ3RmRyUVZ1aFJKbkowcHFhOWx6TEIya2NXUzFXdFdZQmZrcEsyZnNv?=
 =?utf-8?B?T1lHZ3ozaEorYlEyRXBXS0dWWHdCaWlob2IrU1ZUTXpZYkFmU1k2MTdVLyts?=
 =?utf-8?B?dGtqTVBvYi90YnZtQzN2Tk9Hd3lydG9tMWhBUVduaVB5U01Qbjh4UlZCN0Z2?=
 =?utf-8?B?d0hDK21yNU8ydllOMUNvVS9DcHkvZjBydkVVZlk2cE8yTmVYLy9tdXpkNHZM?=
 =?utf-8?B?ZG42SlhsekdNSEtsYWhsMXhoanZuWElVbUpjYWhoUlFxOVdlRVRvVmhtYXVY?=
 =?utf-8?B?aHRrdXJFUWZYN1VQSCtxeHNIamM0amcybkNWWEk5cGRhbWN5Ry9HKzNvWUor?=
 =?utf-8?B?bTdZbkpRb1ozc3JBek1tUDNLbDI3d0lWNjUwc0pEMVd5NFBnVlJEY2puQnlW?=
 =?utf-8?B?ZStDN2l5c1BBMU4vVXJHS2VkOWsxbEd3NG1tV1N6VlBkY1ZsUVdpOStUUjhi?=
 =?utf-8?B?Znl0OG00Zm5qN3QwY3NlYk1aUGMvRGRWdlNpTjAyRVRDeGdlNGppYkptZFVl?=
 =?utf-8?B?bWI3dUFOOU1IV2FkL05qWlJSUUdjdEVrSEVUMDlaSzdxOEdXdzNaaFBoamU0?=
 =?utf-8?B?V09NMDhtTXRvWDBSZVA1VWdwdGNoYkhDZ1BFSmtvbzFpbkFjL016cGlZTXdD?=
 =?utf-8?B?MThERzc0UDBuS2UzRkc0NktzM1JjNDNPQUZaNVZyZlgwZDRNaUFaeVNCTG1k?=
 =?utf-8?B?Z3JNVm8yei8yTFlhQ0g4K2ZsMWUrbklYM2ZwaVhMc3h5TlVQMDFscjZPMnNZ?=
 =?utf-8?B?aVpqOUgrN01tVWlyWVEzTzJxRlMrL0daZlJJRkRydll6VWNzcVpzNmhIMUFF?=
 =?utf-8?B?dU1PbmJlTzBOMC9JTzNzdXFYelkvWWZyMUVocFRSTFp0WTYrU0ZEaVJrQkVv?=
 =?utf-8?B?aWVHelU0V3NwR0RUbUlDQk1aYnc4ZnQ5ekE0UzAxM1JGd0VhQmtoSUozbnVt?=
 =?utf-8?B?aWcwZ3Y1c3BYSHg2NFIwT2NXZEt6N2pEMXJOOVZEVmlMbVk4aWVWcXcxMWg3?=
 =?utf-8?B?MGJQZ1lLYjlmZlZwelJjNWNCeG1HdngzaXZTd2hoTUk3ZWVMbSt4dTlLbHYx?=
 =?utf-8?B?YTcwTGExbm5GVGtxb25RMlRLRXBKeTY0N3lwd3FEUmNSL25EWGFRQ0gwRFd6?=
 =?utf-8?B?eWtlOThDR0c2d1I5L0pwME5wY2hIbUNUQVpNQXRpRkxmYXIwcERtNENDUDRq?=
 =?utf-8?B?VFNkZTlqTVNMekJNSENGMXFWanV2L3VyWVBIRTM5dkF5dFRCM3VOeC9xZHRq?=
 =?utf-8?B?cUNJUXpQRnVVRndWUmd2OUlrZ3ZwMjVKNy93OGlwcE5Ic0RXbW80ejUrc0Fz?=
 =?utf-8?B?WjZ5dVRmTFZTS3RaUU5vSzVZbS9iWmQrTTdvclRKMWZqeFhwckNIU0pBVnMr?=
 =?utf-8?Q?cNsQRyCukNI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a2NHL2oyejNZWi8yMjZFZHhLMGtUajlTRGQwWWJlTlg0WU05bHNyS2VlRHl2?=
 =?utf-8?B?YlNlbXBPWmZwUG1BUndEaU1tMWZRdGIxejRKYktJcW5Nc2Z5NWswYWx3OFNk?=
 =?utf-8?B?aThrNHFHTDlDeUxHa0g4dVdudlFycVpVeFZEbXk3Q09FeHoyZHBJN1NpWDhD?=
 =?utf-8?B?TGJaSEpmbzRseGZpdWR0WGVQVjlZRTlrK1J6NjBmL21kbUdGdGVxMDQ1dnVE?=
 =?utf-8?B?N0s4QkVkSnNuZ2k2UFMreFVCZ0ViRTJkeG5BK0Z3STZ2ZmZ4MjFaRmkxY1RX?=
 =?utf-8?B?d3RGY1BJUFNGa1BzcHpONXZ3NTBqOTEyQWo0NDZ1RUduTzFqTkttL1MvWlZL?=
 =?utf-8?B?TW9McWVqbm5peEdyS0VHU2RYMUl1TmpIeHRENEZwL3Ixck0rRXVsSk1palFQ?=
 =?utf-8?B?M3d3UldlMWRKVUNjYm1lZU1BTWdvMmZTbHhZcXdsREI1YkMyNWpGRHJKVUYy?=
 =?utf-8?B?RVN5QTFFNm9hVGdoMnltaWN6Ukpsano4MjQ5QVcxQkR4M3plR3VITGh6NnFx?=
 =?utf-8?B?Ri9VN0FzK25KQUVQdWFVSlk5ZTBaVUVnMXlsV2ljQ3krQXBpYXZIeklhaHlh?=
 =?utf-8?B?aTcwYng2c3F0cmJ5MzVINzJyTk42RFBoNFQxSEFDKzhad0kweldsNFpTV1JG?=
 =?utf-8?B?dWp3TWFLQ0gyRzY4dGU2UzlFblJHVzFsenZMNzBkR3Y5eWtIQUE1TmdDSE43?=
 =?utf-8?B?YThnUDlhUXR3RVEwUEduaW9OQWgxTFBHRmU1eSt0cmxvcUxDbjVLYk5tTmpB?=
 =?utf-8?B?Njg0YjJGYUdET28wYkJFQkwrQ0Q4VnhORFE5YXAxWVh0RG9CVjdISVJKRFIx?=
 =?utf-8?B?bXVpblpQMnlrWlZuc2dEdnBlVHgybHZ3RG1SS08xZWxmdnYxck52Rm1EQnFH?=
 =?utf-8?B?RjZLZHBYWkxQZUhwU0Z0STM5b2d4eW5PRDdUOTlCT2djV1ZTeGZ6V041TDhQ?=
 =?utf-8?B?NytLL0oxMW0yVTdINWROVXpqVURNVzlEMWc4bjhGaCt1elRmK0dBUGhINWM5?=
 =?utf-8?B?c2dHT0k5Y1UrNzJZOHZWN3l3SU4wN3JJUVk5L1RyMEE3S0toZThVVGpjdkYz?=
 =?utf-8?B?V1gzL1NYdU9pYVFMaHNXSUMvMEZWYU9GbjBEVy90OERaQ2Zndm1Ud2RyYllq?=
 =?utf-8?B?TnZBbVNnamswOUJQa1ZqR1VxTmdlQmFxMU9ZMGh3ZEhQZHVHdmZVL3BxZVlj?=
 =?utf-8?B?MDFWSHBOd0kvWEdURzZRR2FlSXRlMFkxSW9WeWUveVJOM2R2elRnWHBaUnhI?=
 =?utf-8?B?TENiSk9xZWJQL2dhbEM3SjBwYTV3SmJyWGRmMUQzdWQ5bnpzanBIOUhjYkhW?=
 =?utf-8?B?SDV2TG5UZzNKVkhoSlVqRFk0QnNtOUpKSHNkaU1SYUxBaTFGcjU4V1ZJeUd6?=
 =?utf-8?B?U3BaMGlKMVkzUHRjcVIwQW5CcXArTEx2M0F3UU1aWC9qWTdTRHV0c1V5VGJu?=
 =?utf-8?B?bXZnZU10MVZxaGpRQWtaNWlIRWlueENKV2U5SFB0ZlNvWVRoMG1Eb1pHQVlB?=
 =?utf-8?B?Z2pJL2xYdk9UY0diUFV6amw0VzlDTmgyVDlNRC9WMnU4OVZrbVVCN0pKRmhQ?=
 =?utf-8?B?Q3ZTdFA1OWg1Wm54OVFuejFMdTJENDBKYmVQaGozdTY1TEc4QTd0dzhpb1cy?=
 =?utf-8?B?cEFjRG1GT2hMTDVCT3hGSlUzNGwxVWFuYThUY0oraDlsOVdmUXNSK2VuTWV5?=
 =?utf-8?B?WUVBb3ROMW1WUElxY2dEcFNEdXNlZTQ5d0hBdkhVeUs2cmtwY2s3T3ZSWFpP?=
 =?utf-8?B?eDdjOVRHSS9XVFdMekZKRFMwaGVSV1FrWHRNM014aldMMUhySXhzQi81dDhv?=
 =?utf-8?B?OVZwRTI0VTlyaTBkSTdxdVBBaDZxR2txRi9CZ3ZRVk5jdkpGVlgzaFBVUU0x?=
 =?utf-8?B?ZW5icHYyanBuNFVIM1hBbDE1UmhCeWFSeVJNREpKL1FaT0cxTzluNlBYbTFC?=
 =?utf-8?B?NlhBOUFkZURyakFSMVJreUhEQXdMdkUyMVJZVTQ5M0NXM0tDTVVKOWlDOGQ3?=
 =?utf-8?B?Q1hFT1RrTEpUWWY3Q2JFakRFY1AxK1o4K1BmemhKaWQvVk5TU3FkdHBmaWV4?=
 =?utf-8?B?SWVxT21sSkpMbFdvalgzNlRRSmhLR1JSSHlWMzlWc0Q2aU5JM25VN2pYRWh5?=
 =?utf-8?Q?U0bWK+QtkfPo5nDpBy0rt1VGB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e450e64-69a6-496d-cf55-08ddf46d7732
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 15:35:14.6507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zK7GiTBY0ou3/dfXR8wbHmPfYruy/HVmYZxaJMnbIkvVk8TF8rmU0k+dgBorBloB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFDE2ACDA69
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 36D784000F
X-Stat-Signature: 9ypw5cjofsgkqxjtizpuznotmf6h3wzx
X-Rspam-User: 
X-HE-Tag: 1757950520-210395
X-HE-Meta: U2FsdGVkX19fIVJyvAvM3mfNcn/MgdX05/jPJnq91ch30y6etwsmg8gqM44wJF6JxwJTnI4766Bs+32VWdVGCvMaDo9Zk/nxMy6GuNEjt65UpNOj2bBXA/6ePT20axuqo8xX7gabIRXD9FQ4VXMDGPNkyOTD5DPH72Iq3GrIB9r9qaaxD2OQgjuVMgqR6sFMfyn/EzM68mv3Dg5/O9ccgfDCOKZ1Dw2LjXynKiH/YfVVp5GYGI9dcAT6AxRx+UpFVjtKB5fSxd5pGFo3iXMgNbdYQoaw3kLcRCSmDsgvCa6qsZnN6bh0nay7EYF8/TIP1at6L2HA6vJilmon0ItfXUoaxBWoJX8yJ34XQNRNOz+ER0h2T4d8YX30hen8RLUMk3bXERpfPsdDaZscr3Ord9s5FwPuys/M2TLBn6FKFUPEnZGzJTuY2baJjPKyMBQjZWBo3+rXgol1RBDLDFtf05g+Ri1kpWZvJ36jaUe9vnnifpBya0lZRF7DjlzY7XgyAQjGhKNXSJPFjqAXN2zUMXuDzybR+F4KVvZg5rVE76OZZKrbkfZ8ntuTaAhFLCSNJfJgT6RuNhyzWl7OOYy3xxgQkVg5M0lkf5/3vIj1jN0Ql9F+qJ9fH6uSGGl6t7jhCvAmd+mhKI+kcUKd3SveQy3xrCx/Edl3sA8tMloix9mQC9VWt+zj+w/SkfH75VJVBiRGL+26gjdydMlnHwe32EapS4gyGuYVWbsiCvWaeLsBWErUHb1L9j0KcxufOZCPGCE8+eGDP8MSbAhgJtkwMqfy6CuIVVFHzcSyfWZ4By6OS1ZJFmepljkjKH6/5Jzy/rJMTkwPoZNBGU+zjqWzMfgrzGCPEllhSxfhdO4MWxM2yskv+GIgOtoornT1e7pp66ewjLzUBxPsHMIbWh+ktrVQAwJpoBkwL4J+9WLBDdvZsvqX9xORkYcdK3QhFrjf6Dz5ccvo29N1OV6nnAA
 iX1cInVE
 87e/ewYAgN0hNBRiXalYSdonxFEofvtRLxNyReRmEbU3k+OL56HgU9bEvjW7vdXhB79csJnfhCxdSilsvH4pujAVjfxD/vvybx22AvZdrcIBI0On9nGuY0HJQH48q7Ai4krbAVKwAk3ibFZ1H2NG9x99GaAbZ7OqCkiawisvJC81ScHL1YXpT+VmAEH8x3XdTnUv2ii8z1lk/xaIF0iGKv2WZReq1sVfLHy6be/G1XxS28MTd+CBMMVZIIL99+RNKqgvPg8wL/k4wsEtpA46EfERNxCGrj6IIGb6Xl8AqKC0YgGRM4ICdJkWzvGJK9GaXFFjaaHa9KXfLa9jbrp07IkivIHFi8VmnbF8vd/58XCVRrHzAVhDJm9qpRbgNu59bZTg09Pm0E58FrLRmIRkBsSh7+PkFZwlQXfvPxJJLxK9frBU9lAV54GcNARwRX1Ib9/z7niX9/ePsg2u7AidT4ZJDvnqAZBmzi78QKMdZF/gEVHv9EovC7bLGun40CGcP8ssGei4E89S6yVCKEGID6O0u/FXIKdMtnmWy0A23nqeGqKqRW8+xhRfcc6YNwqC0SNHAvURmTZHH7NE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15 Sep 2025, at 9:52, Kiryl Shutsemau wrote:

> From: Kiryl Shutsemau <kas@kernel.org>
>
> MADV_COLLAPSE on a file mapping behaves inconsistently depending on if
> PMD page table is installed or not.
>
> Consider following example:
>
> 	p = mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
> 		 MAP_SHARED, fd, 0);
> 	err = madvise(p, 2UL << 20, MADV_COLLAPSE);
>
> fd is a populated tmpfs file.
>
> The result depends on the address that the kernel returns on mmap().
> If it is located in an existing PMD table, the madvise() will succeed.
> However, if the table does not exist, it will fail with -EINVAL.
>
> This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL when
> a page table is missing, which causes collapse_pte_mapped_thp() to fail.
>
> SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in
> collapse_pte_mapped_thp(): install the PMD leaf entry and allocate page
> tables as needed.

Why does collapse code want to know the difference between SCAN_PMD_NULL and
SCAN_PMD_NONE? Both seems to be treated as “nothing here, install a PMD
leaf”. One difference is that madvise_collapse() will continue
on SCAN_PMD_NULL but bail out on SCAN_PMD_NONE.

I wonder if we could have SCAN_PMD_NULL_OR_NONE instead.

Zach, since you added both, can you share some insight? Thanks.

>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>
> v2:
>  - Modify set_huge_pmd() instead of introducing install_huge_pmd();
>
> ---
>  mm/khugepaged.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>

The changes look good to me. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

