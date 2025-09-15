Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB98CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DEDA8E0014; Mon, 15 Sep 2025 12:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28EBD8E0008; Mon, 15 Sep 2025 12:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108FE8E0014; Mon, 15 Sep 2025 12:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDBFB8E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:53:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D8CD140605
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:53:10 +0000 (UTC)
X-FDA: 83892079740.08.D664F05
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id EF6FB1C0006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:53:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nDvENaU5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XjktDH79;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757955187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4oYceQrcbKRg0xdo2psbbrWndYX1CCjUc7yj2XpKkAg=;
	b=DRwqVS8tR2SakOd6tedtByu6BpMZjfHe1CgOJI7CZjpz2i0W298aBCz0jN5PiVc3U+8xKo
	dA/PrhSjJmKT22Jsw/HJpDq1sDH+vwN3761Oir/e/W6TNyB9+M2ADyefxgPg7quxIwzcSn
	7zuFqWI274t98bJG1HH/opvuNShqaoM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757955187; a=rsa-sha256;
	cv=pass;
	b=4kiUSxRLgVHrZ/TIX7harGFdMMOmQ4VDyxI0mQiZ1DXF+8Qu17nPoyfEwt7bmQ6KcfLVX/
	NJFd0tsW4bMuIpH35EXeTaJBIjc7whqsI5+aTsdRQNzyRHqHFpaLWjXRryBoeRF0R3BnRL
	augsK+yPfLQefzbgVwAEEnLtbC3zwhM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nDvENaU5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XjktDH79;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FFSm25025253;
	Mon, 15 Sep 2025 16:53:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4oYceQrcbKRg0xdo2psbbrWndYX1CCjUc7yj2XpKkAg=; b=
	nDvENaU5UpCWS5Jt+N0jH56ByAb5PCSbqXahfyJuolJ/APppgcLFV3bOe4R+ORv4
	idrYIhbJ0CcTnjC2LYQXVIhw7GRWurzrJHvDHXyvWuFmkYAXkyf/08ypoasmYrAx
	hJmcJ6TdCOXfLnYluseSlpWtvH7tGmBrXjqeAE3f38pJv+ufWkRNqMK8sJmGEkFY
	edNKgGsDefCB3Dh134ns6SzZ+jaDkOcL7wDpm8FBejqzCsf04IH0Ylz7Bk8cOGya
	9iwY8uv+v0knOPm6coLks4vBR493t8SGH0jYtje7qctyRk9kLpNSLTDy9gCepNl3
	DKYYqmScPhImAQf7QdZ/qw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49515v2u5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 16:52:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FGBQDo021282;
	Mon, 15 Sep 2025 16:52:59 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011036.outbound.protection.outlook.com [40.107.208.36])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2b9b38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 16:52:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wd9DfgKvKMSMUkspk564KAqhZajNmiZ9HfKugdBFHn4msRu7Ytm2JSkF4E88QkphnZmm56UXWv1yIEbjbXCP75Rup5iXcl61zClXyffWMRoKzJmH5eVwER3SukEp3TdJwb1b/TxqAWSv+lBWT29I0wsqjIwU5fsEGew3KJtmsOCEa3Ecel7TqED/qhXAIcHB9+bxw4MMYNG/LX8Z59rjwhkewO5AgmCJBYyROhfYNrUc8lg5nowoT7f88rmQRSFD75WtmoAQdUypdEYioUkoRe/vpl2vWN0BYwMBDJ7m1O5GcQPu7kV9FegYI0rbZo2ic8ktpHzSVgSGbBhkyLsGOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4oYceQrcbKRg0xdo2psbbrWndYX1CCjUc7yj2XpKkAg=;
 b=GxStGAwAuBRLSwIwJdql2A7q/dkVWHiiZAs0g8RKpGS2FJPb8tRZTjOaJXosAUrppAi+6+xsjqWnlCw/OxjRYHpqYEGI8jkM9JOlsLf6D/QrfPS0xOabZjDAfdSdm1esQK2A0JoRGRlFF6No6cahxB8HelwU8Zdz0ct+RRrWp0YAYr7H+YPfv1RCnl7VI8YMVzBQ7+jsKwAw63BaaQu3/8rvkP4eQlGBE14TF0m1pJ1BuykhsEENWm1cVWNNNIxJYTCZiP+Zn4AbmQeeqDuMu4giEj52bHQnju32k0m6EeQvVZX1tDyKFUmzOYxJK2f5BBF7TMBD9PfvnddEzMOIUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4oYceQrcbKRg0xdo2psbbrWndYX1CCjUc7yj2XpKkAg=;
 b=XjktDH79XVSLkPAHVtdWY9YsMdpZQZ2ohXuSThnYnTqjht8MzRtjezGTmNO07/ZaeJvwm5D3j55j6mLodxSKmxi7786tmlBusJKUiSKcIjYIoGzZefWrYmMHbHYB9ksPXj8vvMt4s2alpkJEKbhqhraroyODFAh3gTXibKioFXA=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 CO1PR10MB4801.namprd10.prod.outlook.com (2603:10b6:303:96::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.21; Mon, 15 Sep 2025 16:52:56 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9115.018; Mon, 15 Sep 2025
 16:52:55 +0000
Message-ID: <baf2edec-f3fa-444d-8365-4adecef99e72@oracle.com>
Date: Mon, 15 Sep 2025 09:52:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/hugetlb: fix copy_hugetlb_page_range() to use
 ->pt_share_count
To: David Hildenbrand <david@redhat.com>, harry.yoo@oracle.com,
        osalvador@suse.de, liushixin2@huawei.com, muchun.song@linux.dev,
        akpm@linux-foundation.org, jannh@google.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20250910192730.635688-1-jane.chu@oracle.com>
 <bfeb8af7-62d3-4dc6-903c-b6697c5ef795@redhat.com>
 <16fd43b6-930a-4a33-980d-c493f88747b2@oracle.com>
 <b5bba27f-e26f-4efc-a7e0-92a6d82b9bbb@redhat.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <b5bba27f-e26f-4efc-a7e0-92a6d82b9bbb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0753.namprd03.prod.outlook.com
 (2603:10b6:408:13a::8) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|CO1PR10MB4801:EE_
X-MS-Office365-Filtering-Correlation-Id: 195c7563-6e5b-451c-2b0e-08ddf47850ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YllZMksyYldVendhbWZEdE95WkxsOE9ScnNKQ0dSM1dwSTU4UFQ0a1JMTDIr?=
 =?utf-8?B?OHNLckUwMUVubkdsT21CamNrOFo1cjl4b2tqZGdUTDMxdXBRNGhFaDFtQjZw?=
 =?utf-8?B?Zkd5NlMzRWFZM3lLOVZYOE14NFdmQTA2dXNqTmNJUW1LTTMydHFmMGFIV3pI?=
 =?utf-8?B?L0dHYWNBVldMYS9IUWNZbWtlNllTY3N4UEZIT3h3Mk9KRUgxbEpDTnRYcFdn?=
 =?utf-8?B?b3RVcTQ2VlU2eWR2RC84VzcvVlhZWEdiYlExdXZQUzFCN0dYWHRIRHBtd0R6?=
 =?utf-8?B?Z3hCcy9NbGNyTVlqM0lVY0xLNjVuaG0vZmxTTmJxUWp3MmZDRWdZZkJ1QVJn?=
 =?utf-8?B?SUFCS1JEdHlRdXZ2dUVLbEFqQWJDU1BDRjIyNTdtY3BIalh5eVlsb3NWaGJj?=
 =?utf-8?B?LzBqRWc2L2lldVlEOFJxeU5oSGRKOUFwMnRFSFRPMThYK1d6V0ZGS3dNNXRi?=
 =?utf-8?B?bWhnWUl3UDhyVTZ0dDBWTTRIa2dwSEVrQXAwWkNvcmQyT3FkdnpFd2tVUUtX?=
 =?utf-8?B?RW4vcmVQQ2paVVBXekZ4VitRcWI4K0JpWS83Y3VNYkZOeHhENXU0VFEvdGpU?=
 =?utf-8?B?WmYrK3RoM3FJLzZUWG5HNHhqeStrQmpyYnhMTFBSQUtwMjV5cllTVzgzUlhV?=
 =?utf-8?B?VE02K2pTdlZmNFFGTEJVWTdIK3lsQU5FOHYzV09ScEUxcnViYWtWTm1tWDkx?=
 =?utf-8?B?c0c5RE1VRi9HazQxbzQ0dlR2c0VuQUxCaTA3Kzl3ZzY4R0JRMTNyTTVTOWpn?=
 =?utf-8?B?bXJkTTlIUFNhaTQ5U0pCVU5ma2RFUS9XSjdEbkpZaWJ3K0J4UEZ1NCtNQ2V6?=
 =?utf-8?B?OVJPd1FiQi8rcStPekFCcEJ5emdyTjI0NzhqY3U1aW9uYXIwbDZUcjhJbE5X?=
 =?utf-8?B?UUhCaStua2IyRWlZN1lsRkF3VnYzb25NdU5JZWFRQUhIUWtRaVhnWjE5MFly?=
 =?utf-8?B?L294MjBBQjFoc1Z4WXoyd3J2eUxaSlBmUVZDUXc1akdnMkZqSGdlY0lBcmY2?=
 =?utf-8?B?ZnVSaGhpSjdXaWY1VHJ5OFRHd1VhNFJwR0xWUVUzRzNFTEdEVGRVZERGanBs?=
 =?utf-8?B?UnpObGxKTll3VkZFRU4zQlAxTXV6TmlQTmJRSHdrcEI3QXdKNEVaNVZSZUZu?=
 =?utf-8?B?RkkyazdVbnZScG1WQjZtTWhoZ09uanpqNjBPR3hOT3U4NkZGWGRzcmtDcGdJ?=
 =?utf-8?B?aW10eklBMGp1NE5IZjcrTm12SkNPUG43b3d0cFZ2TTZNVmYvUlRtR2ttYnJy?=
 =?utf-8?B?Uk9Ec2hwV2lVMDdFNWs5MERKWlNCY2VsSE1NQ2VoNVkxYzJtMndNMkhVdTh2?=
 =?utf-8?B?ajlHMHZLZjdGNDg3WVhrOE9tYXhHVWVRWDRraXA3Z3h6bWxudjU5Y3RuLytt?=
 =?utf-8?B?NkRzT2xCdzlETHY4aFQ0MFFsVXJpckFDN0lMc3pOSXRmSk0xcDFWY2FPK3Fi?=
 =?utf-8?B?NEtDdVJJeEc1em1zNDFCOVFJRWROTkMwMFd4cC9DY3FMTkpiUVRLR2ZvZVhF?=
 =?utf-8?B?RU0xSGNwT1REMExkeWozdGxsUE1BQ2x3SHJqNnpGcHQ3eHgrMVdwYTVMZGV0?=
 =?utf-8?B?akZTbXFBZXllanErSWhIUFgyKzhoU3NHNWZIcDcxTm9mc3llT2ZYZjVzNW9W?=
 =?utf-8?B?d21RZTdlVDgvK1ZIRi9MY3FaOTdGOFE3MW1ObU9SNEtJbWJVUEQvdXhJdjNT?=
 =?utf-8?B?V21ERVlmSm9ySGIrbHQ3MWZrUkRsemtFOEdqQkpVZUExdWFQR3R0bmRNbm9O?=
 =?utf-8?B?RWZjby9aZGhVRWtQS2V1OFhNVFRBZk1pajNmQW14NVZaa0V5dXR6U05lV3By?=
 =?utf-8?B?dHk0d1dnU3RrTVk5aXdBdldBeStSckR2bk94YksvVkJTc1VpVVNXOXV3dU5a?=
 =?utf-8?B?VDhtb3B1b0hFL0lhdzY5SFNRb1hNTTY5MjRnSFIrQWFEVjhOYVBjZmI4RlRq?=
 =?utf-8?Q?A+br4Qs5aR0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0hCUmxnSDFKS2ZWUU0wV0Vxd2tFT3U4WXBNVC9kVEQ4WlhGMXkwZ3U5U3lm?=
 =?utf-8?B?NmV1WmpMWTc5RmhlQTBBV29qejlKNUorNlNELyticXVDQXVKdmtMYzloSVBx?=
 =?utf-8?B?bnBYdDVOUlZwOFcwTzRmWkN4ZTRKUmFzaEJCWmtzUXBsY3c0YlNCa2ZyMDFX?=
 =?utf-8?B?N0tsQTF5aXFxdEpUUFlMWnoyTjdIY3hEYmZnT0ZWQUV1MVIvbmQ3QWFpZnJ0?=
 =?utf-8?B?MnVyYlptYUpyMmFacERpZ3Ivd1hxSkl1dGhXY0RRQ043RjRMWUljV3EwL1NB?=
 =?utf-8?B?b1ZsYWpLSFllb3l3UGpBV1Urb1hVRnMzbEJnNWVoTEJiL0EzOWFsY3ZIcXRz?=
 =?utf-8?B?WFNiT1FDcExXZzJlK0xhekVtL0VaeUQxWFZZaWc2aXdQQlhwaU80dDhnTFR4?=
 =?utf-8?B?WWR2eWVoQlpGZE1KamdsTEx1UmhlaDJodTFQeHhHdlg3bTVqUzNPUEN1dU9O?=
 =?utf-8?B?aGJHeVQweXEydmFUWm9MQU9xSDlMZnhRQ0Y5dnZ5V09mYjVjbnZZL0RUNHBz?=
 =?utf-8?B?QXhlZGFYdkpBVFlLcFloL3F6U0JWbWo4RHpVOFhHZExZN0c5NkZ4UWFwdUor?=
 =?utf-8?B?dXpEUTRheTZaU2w5WVZGa0R5Um90Y0NQNmZkc1hOVHpEY0xjSkxseHFJRzZN?=
 =?utf-8?B?eGNwQ0ljODRGNWs4YUNNRVB5YmZweHR6d2NleWpQYzhJSTBleG0xUjh5dDMx?=
 =?utf-8?B?aGhnaXJXZ0drNEZ2SzhwdUZmQ2pSVXNtb1M0aEpvQk1CTDczNFNhSGQxalVN?=
 =?utf-8?B?WTdERll4WkR3WjV4Q1p0Zzd6YnRKb1FBMml5VHZ5a3JPSjFnek9UcG9nbmpD?=
 =?utf-8?B?TzN6b3E5TitWNENMNzVpaVlXR3p3UENsajBJSWN5RnNnUm9NdERHUy91dWU4?=
 =?utf-8?B?V2YrTU12RVEwVks4R0JVSFhZZHJQcC8rT00vbXZYWFhsQUs2U1NiL0hoSDdh?=
 =?utf-8?B?b3FwK1VMTVp1alBxMU56cXlreXZDVWUzaHp5ZVdnTTZGaVEyQzlFTlNJU21G?=
 =?utf-8?B?Rlg3aERHVzBUaEczYmdaZ3FSaC9qbjhYdnpOanE4R2ZIdmo4L0VYUnlFV0hU?=
 =?utf-8?B?dVBzYW9ZOStYeXZtWEdGVlFYRk9tOVlaR1ZPR3pKd0h5WnJiMmFoWnZlcHNR?=
 =?utf-8?B?azV2T0JFdDFxVmNhRzlZQnQxUitZR1N4U01WcjNkeVZ0TDNuYzBxNnhQQlFL?=
 =?utf-8?B?ZEFXSi9EZmE5a00yS1FMNXN3eHplODkyNXpMbmdFVElmU2l2dUdnOG9rUEJz?=
 =?utf-8?B?TE1URndxSCtPRmxURzZlcjFwSTE2ZGIvYkx3YjgyZ3hFUFl0SW5hSHRCcnAx?=
 =?utf-8?B?bFhrVUxHd0d4RHpVNWdTL3FUV3E3NXBHY0lJK1lFZU15Q2ZCMGs1VWRKM21S?=
 =?utf-8?B?aDdidmpHWUR6RVV5Vmo2RTdDVmIwdlBDTjJBZHp1TnZrL2NCQnBNMHJDd1NZ?=
 =?utf-8?B?NXRCN0pFTlZmV0NmMWptbnpHQlVkVmFrZkVKM0pZd2VNSE11NnJVY0FhTVJr?=
 =?utf-8?B?YnlRS3hRZ3YrVTBwRFdxc0dPSG9INjlIUjNta0tRcitJNHlOZGNWdVJ3NUFB?=
 =?utf-8?B?cVZYK1drN0FkTnlOdjZjaDd6ZVpKeStLVFlxMVYycmRxUjFEQXA1dXBxUVFS?=
 =?utf-8?B?cHVLVzIwdGtkd3Zpb01McmgrUmdTT1ZFM1RWSlBPSnVxYW0wQXhsZzltcFpR?=
 =?utf-8?B?TzdFcjVLRjhXbHZ6M0ozRFpVUWxiWUZUT2g4NHk1S1BrZkF2NCt6R29MTVdD?=
 =?utf-8?B?SFNndmR2WkN5ZTA4OW51ZHJpZFJVZDFYT1NmV2VyQ3JkNXF2RTc0REJnYTRJ?=
 =?utf-8?B?QU0yY29Sa1FCYlY1QmlvU2E3czk2NG83TmNsOGZRWmI1RnVrbjdCTW41RWoz?=
 =?utf-8?B?UEhXM3FKa1NhdjloSDB4dHoyYTVlSTNoTXhBdklkVjluMU5aaVBSWDhCdTc0?=
 =?utf-8?B?TUplSnlQQXplRVZlaURhRExueDZYcUxMemliUkUrQ1UyTG1JeDliaGsyaXZC?=
 =?utf-8?B?c2V5eDFYNDNDYVpCTUpYUjBodFpmY3ZyOWpYb09MSFhVWm9JRGZqZDJpd3ph?=
 =?utf-8?B?emk0VWJrejkvZ1hrOTRyUVNGT1FVaFVTZGNIWklaQ2FGbXY4RXZtOTVuZndG?=
 =?utf-8?Q?mqReIs0Ehp4S8o19pVnbrjxl8?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VPoBvf8D4fxRsNvcP2cw8fc+/veNGaBO7uC9NjuiUxqN4uu76iZFjsyWKND2By+4EGmXxBN0nINhmcrfl/CPqDtOcfu/o8OtGI+IEhdaFRbAXQcJv3sWii8OuO+/xl/oMWgXSPepslYqyR93r0wqGJr1/I4IRfRHfD6ZbDST7Bffm++B5iTmhjCHGOSrzKRLFedHT61azeV8sjyh4XKilgDtGrOnU25YbZV3d1bLiGjWzvSq0j7X2auQLiUurXslhYhr9vYOwAWhWmw+nfsis5mBZknzmCCY23sfeVqVIhlcJHr3ZVL2X/KPOPU9nC4u3XpJru1zNUke+VXfvJDGH0c09er+5KZSkGZ66PO1eq46t8VyR+YD1UtJd8RFRcltl8hPMb+Q2BQyacpz7SJadXzX32LNkUYFJ7vxVvc8ZypSpkUbUm5wgx55xOsHnByWFHA23iuuul4fK04fNHZPdbUF4+NO3iYIVSZocLXgrze0yuWRwvPA6rq6xOnGSsg2U2QazYCMYbE3LIYmzyQWyp2BbHY1K/QoiGI02y5iMoxAAGQRFrw/WiD3bD8DM2egJudz7hyEQ/pJ2MOfAzV72bH8IIXda8P4URwp9SkBTas=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 195c7563-6e5b-451c-2b0e-08ddf47850ef
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 16:52:54.9575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5rwEEJVNreerKYtnFsBTxuQJ6+hoGuMyO/P51bXPeEux4e8ZENEUBNXbEXxwlk5wVMD0giv1xN8Tf2wd8Z4y7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4801
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_06,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150160
X-Proofpoint-GUID: oUPwZqimKU-18I7FSxzMotQqK3-JKoIc
X-Authority-Analysis: v=2.4 cv=RtzFLDmK c=1 sm=1 tr=0 ts=68c8446b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=h5Kz_pY3q0FoVNV8Yr0A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAzMyBTYWx0ZWRfXy+vGp6ByG6kW
 mCXPZqhAoIiB3xQUnK7FqVIeEoopWVFEB8nZvL+79XS5SCsvHMA8D8doC8JyJZyjDO11ZE1k03S
 HAzL1boFOYrv4bUoBk7Tvhdvh43BWn0y0srUBTqVADgdL0B2UseWhGDAoYh5STrhQzZoJy0Boa7
 e1HTfaUMXBmOn4KoMbUzwmBfo6mS/VLPxrVbROg2xwS3I18LowN4Q2bVVV4D2icNQsemPssQrhO
 gnW1fM+UNUHBYdDAnUypPjbSosdPAyhnB5OIjUU113toed8TyB8UsORUeSS5f3CNmpyjzCyrV1j
 axXISeUT2TdhqodW9yp4mo4R17mn/UVNcB0Fq737AwiT6DxlYeo/w/s0sI3zJP4ce9RgPg4uGKh
 aFdIWFVs
X-Proofpoint-ORIG-GUID: oUPwZqimKU-18I7FSxzMotQqK3-JKoIc
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF6FB1C0006
X-Stat-Signature: 9qg8q4scnkc4jny54ngx79awg1g81rkr
X-Rspam-User: 
X-HE-Tag: 1757955186-810669
X-HE-Meta: U2FsdGVkX1+SyE8z/uOhLpdYWkdXxkbSPz8eb8DFvRFAhH6+89vSmDCpp46GSROsFcd2eaVPIm86zGmBMJL1Yb2WUvHE0TrIZL1huUOIpf+G5XoYCOUWgsOJVRrExg+bWpllaoOEe6n06I9Q92NZv0iykzYc6daimmRj4YcNxO9IpiMYTdCiJTbaUvPXa410uhNJwBj9NP+aYB9eLanAfUfJEaQ6sdPabL0ZNoyBcOCIob/eKy5Z+yJRIHBigB8WQb40tZpwH5KycnmVkvu+GVjZMPwXjjI9oEKvLqVg5nGJeHBQMohXjKemU4EXUrYtAVEmD+W9UAJhfobPlTmkEqhTZaAPATsnNnppd812lZAZa2/fGSqiOlHtV1J8PLredF3L+ckbqw6wYPI0LXWq3e7wDlOxR9RwrDU5EyApVbvCv83u0wO9J2bfB3T+HPuYQJvIYoCh5W40b8+SrTPeBlX1xEvpEf1l3ScIt7ZF4RDKUMEeQ0wTGV9Fb4NMn+Qzg2frFTd/hc+xCEPgIgIc0BxjHm1Vs2NdxdO8fR7svqMftihNxNdWpVvI2dQrYBZjVeN05/aC7cUnunADtZhPgORP8bfbKBLlWLNZebRQYotfIo4NhF5380l8k12j7OAfVSCkXGvqJZnS7NZn8uydLpad8TiwVM/IIG7dGHCx0C2OpK5+S1/Vsf6S6MYTzfNQVQiKMBDqXCQlPJsV9wsdZFkZyPEM4AHG674Sha5lGffrSURAGYAOTz4cWMiOTSWYpk+M8+1eQgstXhjRH39sBwTQyIP98Qn9oVxZVoGnGq5o4utGu2gSo8/FO+2WODWB2+aJ8oxj6DvCp2tVs237sxWIA7E65hE5qD3M0A8p7DL/ZgqDC8xj94dOvaWe4jpWH89iIPHTwVLIgjeKyh/NyfsMn7IM9kVmPOLlAMLt+ohjaZYnxymU0XMy+mNmUWEVOxOMaVaPKiQGjF8h43s
 S3yjEFbS
 YwFbdo5zt/hY1xpRlSEOWfINK9ygrDVYTu0CHVxQ5FZrXuU1+VUo5SyTLrGfamNYqKt07Fx0jKKwIxHVDv0kTZ3clVmBSy0A0MiLrBOnOfeP09EYnkwoDsqFBTyCfrUDjJNkUsoT21frFrWmQrYwa0eWci0Dy0g8VlnqkgVhComM6vYF1nBz3jQvs9a/uLlLbpFxPUzbMsnojNShmwoS6QfvSkG32sUHXrWlOuBwNefh/oHr6AOuMcz8Xj6q/rhZb2GMVrdGx4NzMRyQhTXsDlAqZENFTqIGu6gSg8e2qLCtvRG56tduLgXrKdm66bdeYn+wE4wjWAtL86OkDXzaPs+bKQiL3NrdZyickP1tVlMivYeFg7J9gaoJEMaaSEPwqdthyypCPanzrCGp6DjubvSrVDrzYfv97UENJRPtaY6B50ait4bFFP4cFTZccgDr+nnCF3j5ialAwRLY27sz0E2MxRUYSA1h8bxVh4W1YmE6KO0UHerpzWc+Z6iLNSlaNn8/UDCOC9ppii4O+lTGvtVbt6/SEgUB43BeinATN3fHSqrQzVvnkddYQCM8RxuQqjHwzshCv1630pvcRWUSMf6weFkG4yoGqvVPA4E6nyrgpUWNm3rqDeAxPla8akzcAjFFQcrnXmd2d+ypt1pQsCNXMcCxvrjO3VqTfpFj9QkRm1qHFez4TYlKQYsqSFY0uaxIytcHy/8JRhrsr8OgwvRxGU2elxwooVEiAkh3F4W7cezPAP4w/cXdAz1Knwfavm99VworVzUzJ81h2uujsrX6mIqXGOFxncxX2PyFPhlhDe3flyTMx0JGt7P8Nv9jzNfMj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/12/2025 12:32 AM, David Hildenbrand wrote:
> On 11.09.25 21:58, jane.chu@oracle.com wrote:
>>
>>
>> On 9/11/2025 1:17 AM, David Hildenbrand wrote:
>> [..]
>>>>
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index 753f99b4c718..8ca5b4f7805f 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -5594,18 +5594,13 @@ int copy_hugetlb_page_range(struct mm_struct
>>>> *dst, struct mm_struct *src,
>>>>                break;
>>>>            }
>>>> -        /*
>>>> -         * If the pagetables are shared don't copy or take references.
>>>> -         *
>>>> -         * dst_pte == src_pte is the common case of src/dest sharing.
>>>> -         * However, src could have 'unshared' and dst shares with
>>>> -         * another vma. So page_count of ptep page is checked instead
>>>> -         * to reliably determine whether pte is shared.
>>>> -         */
>>>
>>> I think you ignored my question to v1 regarding the change of comment.
>>>
>>
>> Sorry David, didn't mean disrespect, I missed your earlier comments.
> 
> No worries. Replied there about possibly simplifying the comment further.
> 
> BTW, I think the code would be even clearer if we would have
> 
> ptdesc_pmd_is_shared()
> 
> that is simply a wrapper around the ptdesc_pmd_pts_count() check.

Agreed, will add ptdesc_pmd_is_shared().

thanks a lot!

-jane>



