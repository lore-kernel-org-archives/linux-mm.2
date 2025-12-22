Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5045E6ADE7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 20:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23196B0005; Mon, 22 Dec 2025 15:30:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1746B0089; Mon, 22 Dec 2025 15:30:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9539D6B008A; Mon, 22 Dec 2025 15:30:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8D36B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:30:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29DC5160362
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:30:12 +0000 (UTC)
X-FDA: 84248249064.07.9441B07
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 978E214000D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:30:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ATpa0O3G;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GHF1b6Sb;
	spf=pass (imf23.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766435408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJPtW92UGmv6NRrAqy51tTCashB4UnJ2/IknSrZqlGc=;
	b=h/A9fHB7zvt5zLDIm529R2i5ARwRSxVS/uYutxxN8hZHvcYqr5VC++Hqw043v5cL9OiKse
	wlq/2CcDwJuJHPet/dM6NL591deN/28+ib2+pd9hw3+Yc/kSME7nOc9KDQFhEoHlJd4vHK
	bTAlOvBMLy+IJECOuscv6UjJim78hWg=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ATpa0O3G;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GHF1b6Sb;
	spf=pass (imf23.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766435408; a=rsa-sha256;
	cv=pass;
	b=LlgzEmikFlQbyIPTU+4sL0ZKczNuRZIRJA2XAvQqKTdm8UmmYelINjDqbsBNVesT2Qaj10
	wE2UHwZRUeds1U/kEL3dRZg4gyhc27cX8tpn3w94HEw0Zaj0aeQHymQt1/e7H02jttLaVj
	BerdgVl8N9wHrxSdlxCQ+I9c1DBlN24=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMKKlwc3032511;
	Mon, 22 Dec 2025 20:29:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LJPtW92UGmv6NRrAqy51tTCashB4UnJ2/IknSrZqlGc=; b=
	ATpa0O3Go0abAEjGcidMvaahwEmsqUijWkl3O+6KNGMXv2LNKHBEJ9XsTN8dEnGd
	8quvN6SzvwWgjLoOiGISSyvyOFHywaFS2yRyqv/kI0ZeBg2+RY2uxjSzCFOghlVg
	VO/31J6LRrEAgE5hScS1cpaFb0PYpbPrzXwHvEo+Nnwn0LCDJzRXrCT4GBI/qv5g
	hkxFR6aEPiyY8VRamarLdv4uHhnak1KpF//0DOrzfgCp8S6F7PQZeIFhOR0M+ejT
	EiDypdzddctMwDyjvsun5sUS0P4D1coiLRRd9zf+USVMrr63SgP3bpj1Q4WSMlck
	0lpOhxh/lZ8tPhul/JI1dw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b7cxer0kd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 20:29:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMJ0NqW000422;
	Mon, 22 Dec 2025 20:29:51 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011071.outbound.protection.outlook.com [52.101.62.71])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b5j8j0610-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 20:29:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=akDi87ruEIZxJuv/mZdhjR1JHlGD7Jt7+4UUvxFdIN4Do2mHg9yZH6HmMHY84BMHBJjCwlkEyYJ0t/yYGl08xw4IuYpO/uTmNSxC2MOuual2RStSGmD4dx8sJm43jUzba6B2bPL7ANwuuS240VBIfKxdwDgQwf1K63O6mTsU4AxAFEiZNz/mtwDfLrhPY+NNNKWxtFP0YbEVwrgLvnxQk6sUIBvS/66YGJ8uWe2KgQFhL2zBvy6UEniIreYEBwGjeEzLF95yG/o8bKt1OoK4MOBSVCv/uQlR6T7PtRAY9kCyHk9P5Aio+sWaQfJ65rGertHTPwtGldW+S6vX5EyxKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJPtW92UGmv6NRrAqy51tTCashB4UnJ2/IknSrZqlGc=;
 b=GxIv3gzD4DYovD4Nm6F2jXw6C0Dmz8gjifjxgN1OnWB9ojqGyIS/jTMGYmL4zjX/LU72GqlWtPgbz7Wn+8B9nWa9D1caIidUQnuh+WwSsk/dsZEAd5SnLeQojKxjRz9Cdpf0fQwLqpildXcDEvadwQyUU6xDRhACJM1oWvzE27pI6WZgaokIFczjTT0kQHzcGHRYqv7XAQlWxyTDyk0RABUv4sYQ70edJJ/0FVgZnLZRwm69Fa3qH4zbKb3vgQudhryYiuEmhmIrs3UTEV9HREmlW2CJEsqi7XitJWuKzsAEtGFXNoIJpfyGMSzG+gXxWFv+URQAwoIiLvsCaUILmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJPtW92UGmv6NRrAqy51tTCashB4UnJ2/IknSrZqlGc=;
 b=GHF1b6SbHSMJfBZ3c1YU6bie7yFzf6oc9oYCJxpmM8TvseUYoIFhguCHyZu7pcn/rkcOshpipOfQ1lGUZCtJtuwgRCFfZh+JFyhF5OpZThtEYtoN4rUVH/p4E/1Tb3IDpoTI20FWRNzWJiCcY4agh5O/l9G6LvuRM1zkS4YnZMM=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 CH0PR10MB5131.namprd10.prod.outlook.com (2603:10b6:610:c6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.11; Mon, 22 Dec 2025 20:29:48 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.20.9434.009; Mon, 22 Dec 2025
 20:29:48 +0000
Message-ID: <5046fe72-4e1c-4ed9-a970-af4b28e54ba8@oracle.com>
Date: Mon, 22 Dec 2025 12:29:44 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: teach kill_accessing_process to accept
 hugetlb tail page pfn
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251219062819.2499399-1-jane.chu@oracle.com>
 <eade3d62-8102-22a0-637e-ae2e34f11406@huawei.com>
 <38c098ea-95bb-476f-80c9-de9231b9c991@oracle.com>
 <93ce8e83-500f-9f97-a90c-64d9b3c73f3a@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <93ce8e83-500f-9f97-a90c-64d9b3c73f3a@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7P221CA0077.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:328::12) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|CH0PR10MB5131:EE_
X-MS-Office365-Filtering-Correlation-Id: 956cf5ee-4a3d-4780-fb7f-08de4198d9ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S09DdmlIc2ZjaFBiTUI4YUZzTE85aDdiRWhjOWwvZFJ3ZkpxeVRzd0VhbnBw?=
 =?utf-8?B?YnpFNzBEYlczTkM5WUdvOVZzNVNjZzBPNW5YUG56aWpEU0tobm1FNlJtblNr?=
 =?utf-8?B?enVXTHc0dDgweiszeFk5ZGdBOWhDNDY4aG1NVGR5WERVbG0rVzA5R1BSVGRZ?=
 =?utf-8?B?UUR3bWVqNVk1YWZXQnd3eHhoWmpnbUJpdzMrKzhFRm1tUFdBNzQyTll2NjZC?=
 =?utf-8?B?YlR0c3NDdDVxRnNSTWVoOUF2eEJqZmlGaVZvdmFhcHN6SVM5QTlnTnVxeDdw?=
 =?utf-8?B?bXU1Z05Jd2t1dlFvYWxuOGtUVmZyaXdteDRBVittMkNnSGJqbis5QlNVY1hT?=
 =?utf-8?B?aytudExMeDJwSHY3dHgvSDBvUkZUMEYzdWZxTVZFZHI0ZjB5QXd0QTM0VGlJ?=
 =?utf-8?B?ZjBXZ2VVaWRCcm4wVGNDVW9ZM0FjVmhINVlyTzhKb25YamMweXB6ejFjRnpW?=
 =?utf-8?B?a3B4UWl0TzUrb0ZaYmVTT3AyV1M3ZmpPSUxuc3JSUzZMa3AycldvYVVLUWNM?=
 =?utf-8?B?MHhGNytoWmxMMUxKMTJNaFIrRUpXODl2NzEwdVN4Y0wvR3VSdXhFM3dJNkpv?=
 =?utf-8?B?alZzdnlTYUZNYTBVZ2ZQSk9BVElLODUwaThjbitmMWgyWTFyeS8yZERicjRh?=
 =?utf-8?B?RTlhOHpuQ1VIOE55ZEZ3aXJDZlVSaWJNbTIyMjZ3OVR5U0RJSWY4dXJGUkI1?=
 =?utf-8?B?VmxsRG9WRXdXL25mR2xhdEpnbmZTVUtRZiszOUwrazdqTVdFUkxMNFgzQXVU?=
 =?utf-8?B?OUlYbTNsUG0wck1rU29zbXc4SVNFTHRQNHhINElMR0lQalZsTjJ2eTB3MVdV?=
 =?utf-8?B?c0k5ZVRMK3oyTHhhbVI1b1k1NTFzb1YxQ2FmRHVDY1pQalhBV3h2U1EzQUxS?=
 =?utf-8?B?Q0NBaHFEVG9BWU52K3hYdEJFeEZxbFYzTG52bXhOYjlUQ0YxclQ2OHQrVjFz?=
 =?utf-8?B?Uy80WE1iR0o4djl0eW8vMForWHE1NlpKS0J1M2V3cVZ5dHJTaW1OdjIrajJz?=
 =?utf-8?B?UXorSUJCUHVRUmpqUmFxaUFBeEUyamZWTnk2bklTMWJQUFdkdGVYbVQ1c3Vv?=
 =?utf-8?B?ZUdZOXVsZHZXT1FWUlFSQzZqZkQrTnZ0bFFBNnlTODVyKzhXVGJlQWxJSjNh?=
 =?utf-8?B?L25nOEtBTW1rNzRCRVUrdVNMZzROUHJmOGhZV2dEblJQRkFSYXA4ekVDZEsx?=
 =?utf-8?B?bmp6VVM5ODVUZndVdTBhVmFMejdyK05YSFNtc3BxSUxOSVh5UjJLclM1M1dH?=
 =?utf-8?B?UWtqTmkwQnEwMjFHVnVHRjBqbFpsSkloanZPa3VWQ3BRZ3BQUm5XWDQ4dEor?=
 =?utf-8?B?V0RhckEyZnRjZ2poaGdSTXIyTkg4dHdhR05nRUNZdFpHL1hrMFQyNDk2TXNa?=
 =?utf-8?B?UFRpVHRuRlN6RFdNWTBrQ3RXVkpOTUdZQk4xQlczQUlwd284Ui9iZmdVNk9j?=
 =?utf-8?B?aW51ZzBGd1VNN043SGo3bWR0SmRmWkp4UGFaU2FCeG0rakN1TGtJWXNaS0JJ?=
 =?utf-8?B?bm1neGtBeTkxMlhyTWszV2U3TVFxZll1TTFGVmFSNzdBbmwyZlU3OWJ6VlFS?=
 =?utf-8?B?SW5mSDdOZ3h0YnQxSDB2dFFLUVpNdGlydUF2K3VzYXNvcWZ1Qzl1Z1NFRnB2?=
 =?utf-8?B?NjNXeDgrQXBQOVBveG55OXIra0pqN1Q2bnhCNHZSQWJmTlZoWU1vbXZBak04?=
 =?utf-8?B?NTdLYXJpTlRMaWhtYVNBOXpvUGh5bXJEamhJMjJWU0NVLyt1NlZ0Yjd1cFV6?=
 =?utf-8?B?UzJkYmFCeEdDL21jVjB1VlZhbVp0K3FtbzgwQmx5eEJUeVIrdzdYeWF2RytV?=
 =?utf-8?B?SEZSQ0JLUHVacVRZSkRJRWtZZGp5bWxmQ1laQnJnUGpicjc0bHFCUFh5ejVQ?=
 =?utf-8?B?MlQ4cnc2YTJ0SEJZeDZHT3RjMlNlVmljUXQyYXF6RnQrTi9ScVYyVlprUFpD?=
 =?utf-8?B?OVBlQ1NKVkNqdlNMUmxNTUNoMEQ3REpxd1I0S0hrWUIycWxYajdETElUZUlZ?=
 =?utf-8?B?eWxFSEtVNU5RPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHBybnpzRnpWY1Vyak5JVm1XcjBrbjFqNW1mZVhiQmxxZDY0dnI4REVEYVRJ?=
 =?utf-8?B?bmJacGlxcG0rajl0dG9sR2N3aFE3UXVBVlpMTyt0aXdjL3hoWUdTNlNFQm5z?=
 =?utf-8?B?K1lSZEtKSklEMmo3OTZKVDU5TmYvSi9Obk1LS3FhanR4OTJRSkZOZkNnd2Qz?=
 =?utf-8?B?UmNveUU2WjArejlxeG9vZjYreVc3U29kdllSUys0SnpKdk1BSkJPQ1NkT3VM?=
 =?utf-8?B?dDdJZ2ozQWh2S2d4VVRGUlBEeHRCR0htQzdhR0tWVmEyOTdrYjZRL0x3M1lw?=
 =?utf-8?B?ckdxdG1tT2hxQ0NQVjRoQ2xxNWk3OXRFUTZic3NReUNvM25qdXNBZENGdmJF?=
 =?utf-8?B?THpaUHdVZlM1MmZDazNXK1dXVk1ORE5hTUxCRUY5d25UMjRSUXo3NldqYjh3?=
 =?utf-8?B?Z1ZkN2djclhSamxnaW9uSlNTZmgvTUZjb0svbHVRUUdBTjFkUWtiQnUwazFP?=
 =?utf-8?B?SEExekRYNkVwNnJGZ3pNdzdhU2w2bm8xc1M2RzZZUGRJd1oyMGVnVDlXTFBz?=
 =?utf-8?B?SEU0M1R4eEpENkFoQ1ZVS2FoM2gvV1hhRjEvdEtoZ0Y2ZmpQQ2J5OCtZTk9R?=
 =?utf-8?B?dityckZoWkpndG9yL2xUbGxTMmVBS29weU1hcU14UEhZSm1MMFJWVDB4bm5j?=
 =?utf-8?B?cERxSS92UXpHc2x4WnJRdzZHMWhwa0VqNFlpZ3h5dXBaY1ZoMTRHR0hUNGJ4?=
 =?utf-8?B?WFFkSDhTTG9xd3p6dUZxV3hGUUxHMzI0bFNham5zYUppWThPUTRBeU1BUzZM?=
 =?utf-8?B?WXZhVHFPWlc5Z2lNcHlsVFNuQ2xOSDN2djVJNklPVlpMbW52QU05M1ZRSmFv?=
 =?utf-8?B?Qm5MK2lPSXlYMDhrY0VKVFF0Z21GaTN2blFRWjZobGxxd2poQ3UxcjVDVGJx?=
 =?utf-8?B?Tlh0QmI1R09pWnRubkpmb0IxTGxoTDhuZWNPbnI2S1o3STRSdEU0cnZYRkts?=
 =?utf-8?B?YjM5a29VQVVzeXAyY0VuZ1E5OFhoYjdtQ1Q0RHdWM3lWQkpIRlFZWm0rMlVy?=
 =?utf-8?B?NTlsNEgvT0lVLzZ4WW02VVpseHBhK1pQajEvejIreDJUOHdseXhBRVAyM0Vy?=
 =?utf-8?B?MHlPb1hBbnZUa0xRNjVkZ1pIa0hRdHF5WVExenAwUjIrVXlTOHlDdFhaNkls?=
 =?utf-8?B?TTlhMnc5UDVOMmdZV2dGbjJZU3ZINFhyWkNzNWtXZnVDM1dSWjE4ZHRRS1l0?=
 =?utf-8?B?QXlNbWovVmRZNkwvQVZIaENwelFrVUdEQmJiWDFZTkdsNmord1ZUOUhQWUht?=
 =?utf-8?B?SDBFUERRa04ySkxueHd3UC9NcVNCVUhQV3NTNnpRdVRJS0lZWHBRMmp5Q3Ri?=
 =?utf-8?B?b3Y3dWtRYnZIekJINExTa0QvRU5rQVVMSXBiMXlLUkRwRjVaTmczZnRNNUZM?=
 =?utf-8?B?VHY4RG8vZWE0VXBZTVZKQ1MreHRTeXZaKzZVRk5DZG5tby9oSkRQanFBL29K?=
 =?utf-8?B?OXg5Q3RWNEVIaldEdkJucU1Xckc5VjlYcnRjRDIyT1lKcmF3bnZMMjBnOFhz?=
 =?utf-8?B?cjJHL0oyaUZRWG1zbUlkWWhnK2xtT0JWeE1nYTZEYy81RzRUM0gzUkgwbWFP?=
 =?utf-8?B?Q3BLNTFjTUtEMzJQbkN1Y0JGZEw4Y0U1YTRBa3BRaVpJSDVkam9aZm03ZUxB?=
 =?utf-8?B?Rm1XRG94dUh3a0JlTkRKZ3VCV0tKOW93aisrVDhkaG9Dd1pxV3RycGhHNFZO?=
 =?utf-8?B?OUVKZHd5OHA4WkZSUkg3QmRTQUhua3lGYzY5eXhSZUZIWFptMTJMRnRvaHNv?=
 =?utf-8?B?OHpnZW5EMFRBZDJFWmV4cmxYalhWbHBkeVg0YnN6YWJuenRHZTBFVjlFOUFG?=
 =?utf-8?B?UU9Dd2tHbDRFVzFhUVBJaE5ObldZSDVycFZpUDVPZUJYRGZ6WXZ6OEUydllW?=
 =?utf-8?B?RHVVU3VRT2ZaNHhrRzVLNzhaZytXSHg2UUR1Uk5FU1pDNTN4S2ZLeVp2QVhN?=
 =?utf-8?B?L055c3k1Qk4xcWtoL1djTmxaOWNkd1pvRm93ME8xU3Vra2NnaEV2UUprcjhK?=
 =?utf-8?B?TDV4akdSZnhvY0dOL3JzNTVoOUx0M1JQdFd4eTZnSHEvSm1rOVBEQ2tvVW4r?=
 =?utf-8?B?Q25rbmNhR2xPc2VqQ3AveGFHWWovQ1ROK05HU1RsUjVNZGNSVDlFQkRacE50?=
 =?utf-8?B?cDFWMklpNXNmQ2g2ckVPWkFIOWxTVm5DUUxpaHpob01rQ1J4T1lST0NqQW9L?=
 =?utf-8?B?ZkJ2MDIreE5nUHJaeGdxaHZwYVdMNnAwWXY2NU1wZE9NTTV1dVhwVXRTOVlW?=
 =?utf-8?B?VStIYXkvMGhVVDVpb0VDeWdpbEVLUTBSWnpDVEV1bTBtbUZnQjA0RWk0YXpm?=
 =?utf-8?B?SlErU2RyZDFzUHFOb2liU01TaUs2eWd2eUZDays4R04wT2lyVUJ3QT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yr5VmI1SlWeIkkvcEaKNWPf6u70k2DdrmckaEah+Z7q1o4KcjfWoGBmmHNZzbqECZmahfrsl6fSE/MdYEVtQpx7pYYjL14a7X33BnSTvyZG6UQBh++wsnF4bNj23vTxE5MGc8tWdD2GT7qGyFhxd5ll56ckHBAvqr0g6w5xh2qHmLhYNsvGxynrDkjxScqmvtNWrhtjRa/OcHN+DM9t8PiILRCVW9P1gr+TTewGNDwgxmZo2BucUuUI8xG3w+0OPB6U4uBcAQOM9scq9N5vaHU6JRVMcEk1BZYi9qpgHeEgLWdmGmmPjK/s7x/r+Baeld0V2bCppo6+/32uX94Y8ajjZbrsOjRCQqzM5KVD0j+JYHpq4yflSID4oj7YW2L3fNrpZDf69DZkhKuRxZ/lDjsbOqu8jJrJGKAo5O6ZrvkE1KyRMyUm6ULATvr6bN1Hb5MP745eubDVUW6AplZyB9istnjyjMaVtD9PcEtMMTz1qE0+7PujPNYz4UY1p+bZBweNFhOZS6S2PGFTvk05+bwNgp3i+Egwj66Ghom3LGu3E1GB5eyHMg5nAvGOE2M0vUHCidp1CPSZgy2qIjs34un/leM5jLd8T8QVha3Psor4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 956cf5ee-4a3d-4780-fb7f-08de4198d9ad
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2025 20:29:48.0320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HUNEEndP08JZ8Ub3PgtD4UosoaH2OOt5UK2W8jeAm1O9Z0ZJxzV5zWCTUYP6mFiCu95D83dr0HabLsl/WmW/iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5131
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_03,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512220188
X-Proofpoint-GUID: jOmMwiGT7DCiHoP9eZVBbsZYikEZQF_9
X-Authority-Analysis: v=2.4 cv=cZDfb3DM c=1 sm=1 tr=0 ts=6949aa40 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=kWWqPUn4wn6z97MopsQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12110
X-Proofpoint-ORIG-GUID: jOmMwiGT7DCiHoP9eZVBbsZYikEZQF_9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE4NiBTYWx0ZWRfX/Fot0/ZYNqMz
 BnKrcSjRwShn3P3BJM6TcXHc0TuiK0Deh+gOLAR+Hxu1WmdHU1FdiDlxxgzhGdh3tdWfN1N3iAK
 OR3tZGTPm8NEzEFhaaWIXRjzUhTFd98fiVQBY4WO40YPMKdbxeCxiC7dkTJMxdmGg1fiYKRQCeo
 RbHCNJZGgOqjlgDtP4JEpVR1F6ThBXLM4JyRpyM3Aei/+NMW84HqlmAxbcGc9cyZ7IUlG94hmBC
 GEV0H23VHT4PhKHPqwrwW3QA6EJdaxyRSS4C8hYkpnRqonZMwIwKUXNb5Mw70bSBNd5vEcRyYpJ
 d56zYHcMhxLlqWlv4BvtsO1E9Sn+ileaaXRABEIuDn76v7JTZBxNb4Oo/QXe9Pl+zwLgw59Mn4W
 OtSUB21R5k/jVLx3kZW8I1JXzREOZdYUrldtclOvV2VwMbo33ppGIr9c93cm+Qmavp83WEMVAPe
 yL6W1qhhUetJwq+RGsDu7IdzG94HOkJYGB4mk81M=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 978E214000D
X-Stat-Signature: kjtqgguqognu4jzhzzibf7dekz9ddqdk
X-HE-Tag: 1766435408-910205
X-HE-Meta: U2FsdGVkX1/YAGH/daONRiWD/tcMwGRCk8mXE0vJRpWjZCjh/COWqNqXq9GK9LClpvNkubvZQH0V64a2wyYntnd/wx77MHK0B3ZAen/isYzvEG+GoI9IQkor0lNmt21GjwpUREIMFFNBs4I1qzp4Ao7066g9SqD8HFi8UQjPmWgWZns8oAo+1TwqBfyjN1g+WYFFXZ/8l9E9MQSL95lo8+jCWP1utmlec9P78DMf09m6PuYRbasaIKpRX9Vt2UGLHzWD0v1BOIT257qj3x1tyKjAskk9qgq7iTzr+VqJv+YutqJmHZGrITjpqNUYoIP5+/V5cPQBxDQc+/KLCs0m+seFiS57ADjdaJTE0mgACr/6ezTYgKVRgSxjkapF28ENVMJSwh2RPelaKJgv5o1/fY3FdUKRtwhm43moWnAAkxOaT1/c+8HuonWOCd/r5Jhcp1GQQ0DvvB9H0Drei03OxNxKUBKA11Rsbp3qN2aPROE9ni/COgt/oGca0bUA503yeYNBTzwqgjMH8CZPCA0GIF8kNFtcX2TrmUC3HQz6EgQKUhAW3tNAOVoevS+WoikM+w7DBzmUwkchclCb8X9MDCo9w5rwh5J11ZhZezBtKPKyyI6rniUiJFG7HS4aCraxblo3aUpkJ0w8qixoxsnLk6EZsz3vbLETAHftDrwyyiCCKzKoHGD3SX2WzSUZ993WXMSYbzlT3GCYR5UUJ+jgIwCJFgafJxHq6w6g8SmNYf4ToE/xdFJJF3eqLCAs2ONCmN94peQ1l2mAjB9lnIi20urpLaRRp9NlWlAecKxZ6N12LisukuJqp5aDrHmiAfy57KvnY1zLzxCcQ8UWgulKP3UuEhmRNssQIkGMfdLVu9bRo3okAsgRXg8emMhSj8/a9vw2KRUCFLih1GsXw2XSHqd03/6gUzOFx3w3JvxaQBiW5FEbJ5e3pfk13W0KzERCOVwvBZ47ZyUATXQ7PJ2
 qw7jrt0T
 f8VNL3mwrCZSxrisyKnUgY9Y01b5QUdKbLvqz36+DiDfNe+o3N1koXItC2d8r2GyRL8tlbfBZxEqeR4PC1AsvWKbDpiEq/5gmawQCz33lQkdDOoFh6DYiklG/8cCSdW09CBwm5glUpJzoJ1JsZNkuYBCGu3FLYzniCYVaXkV8SYXaWVFd14MTRttXP56A4kngK5poNJvt7SK0iG2YF7ZCKq5bghtwGwoifsmlqad3yxTZZbrtURohxhPxE4nH8Oz4HcWSv3/ScbqmZwxxzpGIBfLeD3mJmPCVbFYBEv60+UEVcwfCnnyIG6ATrm79MrmcAk1GrvsniGl5GWllNQgbu0IhDbOVHB0jwl/XTf4pbh0Vtz3HBonXyY53Jy5JVgAPWuF/gN9lEG2Br1FumkxtqDb2V6aWtmNncU3JVw+z9/CoVRbEYdSmlqg3QHMI5YTd2ZfI05ppMt0MKRHFKNQa4kpe7Oz/dt7rJTmXUgOYzbm0AwqyxRMAOyHJGkeq/Z02wVmVdAtbAKCxsGxwLchSFnKrgEzIi39WSMzEhtJv1qUNOJze1Zv1Dx0lSDHQfEgz7GedQ/gc6qIXZdDeYdOGCgC0gcLq0VTw3FjiRRBB3EHo2c1/ZRKJ7e9A6fZlCIXUzTpJmTjdoOFyUT0spNOJAhQXgk9uAi70LZ1HDWH+icbDftS0//RZNwOzX7Hz8xhtxa5CpfvLU29MuGSSISmRyXQ69/BC+pFrSjA0slaqTldkLJ0hmy5tDqIv9vJDJ2N48Tnv87MALRMNHQaFHdhdPnqbzuoPuJk9MGIOpWuX2I3YPOckMbnQuddZVRASEjg8PfDn/ax1c2pzBtSKMrkOWqK7WlSdPPqeCc+N8bpmLUfMq2dG/GRZXUKixA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/21/2025 7:01 PM, Miaohe Lin wrote:
> On 2025/12/19 16:06, jane.chu@oracle.com wrote:
>>
>>
>> On 12/19/2025 12:01 AM, Miaohe Lin wrote:
>>> On 2025/12/19 14:28, Jane Chu wrote:
>>>> When a hugetlb folio is being poisoned again, try_memory_failure_hugetlb()
>>>> passed head pfn to kill_accessing_process(), that is not right.
>>>> The precise pfn of the poisoned page should be used in order to
>>>> determine the precise vaddr as the SIGBUS payload.
>>>>
>>>> This issue has already been taken care of in the normal path, that is,
>>>> hwpoison_user_mappings(), see [1][2].  Further more, for [3] to work
>>>> correctly in the hugetlb repoisoning case, it's essential to inform
>>>> VM the precise poisoned page, not the head page.
>>>>
>>>> [1] https://lkml.kernel.org/r/20231218135837.3310403-1-willy@infradead.org
>>>> [2] https://lkml.kernel.org/r/20250224211445.2663312-1-jane.chu@oracle.com
>>>> [3] https://lore.kernel.org/lkml/20251116013223.1557158-1-jiaqiyan@google.com/
>>>>
>>>
>>> Thanks for your patch.
>>>
>>>> Cc: <stable@vger.kernel.org>
>>>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>>>> ---
>>>>    mm/memory-failure.c | 22 ++++++++++++----------
>>>>    1 file changed, 12 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>>> index 3edebb0cda30..c9d87811b1ea 100644
>>>> --- a/mm/memory-failure.c
>>>> +++ b/mm/memory-failure.c
>>>> @@ -681,9 +681,11 @@ static void set_to_kill(struct to_kill *tk, unsigned long addr, short shift)
>>>>    }
>>>>      static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
>>>> -                unsigned long poisoned_pfn, struct to_kill *tk)
>>>> +                unsigned long poisoned_pfn, struct to_kill *tk,
>>>> +                int pte_nr)
>>>>    {
>>>>        unsigned long pfn = 0;
>>>> +    unsigned long hwpoison_vaddr;
>>>>          if (pte_present(pte)) {
>>>>            pfn = pte_pfn(pte);
>>>> @@ -694,10 +696,11 @@ static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
>>>>                pfn = swp_offset_pfn(swp);
>>>>        }
>>>>    -    if (!pfn || pfn != poisoned_pfn)
>>>> +    if (!pfn || (pfn > poisoned_pfn || (pfn + pte_nr - 1) < poisoned_pfn))
>>>>            return 0;
>>>
>>> Can we get pte_nr from @shift? I.e. something like "pte_nr = 1UL << (shift - PAGE_SHIFT);"?
>>
>> Why?  Is there any concern with using the macro pages_per_huge_page(h) ?
> 
> No, I was trying to get rid of new @pte_nr parameter. Something like below:
> 
>   static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
> -                               unsigned long poisoned_pfn, struct to_kill *tk,
> -                               int pte_nr)
> +                               unsigned long poisoned_pfn, struct to_kill *tk)
>   {
>          unsigned long pfn = 0;
>          unsigned long hwpoison_vaddr;
> +       int pte_nr;
> 
>          if (pte_present(pte)) {
>                  pfn = pte_pfn(pte);
> @@ -701,7 +701,8 @@ static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
>                          pfn = softleaf_to_pfn(entry);
>          }
> 
> -       if (!pfn || (pfn > poisoned_pfn || (pfn + pte_nr - 1) < poisoned_pfn))
> +       pte_nr = 1UL << (shift - PAGE_SHIFT);
> +       if (!pfn || (pfn > poisoned_pfn || (pfn +  pte_nr - 1) < poisoned_pfn))
>                  return 0;
> 
>          hwpoison_vaddr = addr + ((poisoned_pfn - pfn) << PAGE_SHIFT);
> 
> So we don't have to pass in pte_nr from all callers. But that's trivial.

Got it, that's better. I will combine yours and Matthew's suggestion in v3.

Thanks a lot!
-jane

> 
> Thanks.
> .
> 


