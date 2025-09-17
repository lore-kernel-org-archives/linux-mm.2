Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFC45CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 20:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B8A68E006A; Wed, 17 Sep 2025 16:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3904E8E0068; Wed, 17 Sep 2025 16:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27EB38E006A; Wed, 17 Sep 2025 16:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1551F8E0068
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:00:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9302611AAE7
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:00:07 +0000 (UTC)
X-FDA: 83899808454.01.D6037AE
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11020073.outbound.protection.outlook.com [40.93.198.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 88AE4140018
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:00:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=pkxszzv2;
	spf=pass (imf26.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.198.73 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758139204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XML1A4ds/0Nmc7CI4clXC/wVjRZG3YM8lxyep1S8xOI=;
	b=L7uMV9ip5olpFIRbv/fVKtnfgOaqbO+99j+iKfucD69+QyNsuPUbCqpTK5FKyqLGEvGmlK
	5Fdz6jsYekrw6zg2kGz50Knw4SOYnv8wQZELZRw43PYvhI5FEU3F1sIIqKWDGWDkJYjzIE
	zA396CHDXGADiwD2bUwrv2rfl2p1FTY=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=pkxszzv2;
	spf=pass (imf26.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.198.73 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758139204; a=rsa-sha256;
	cv=pass;
	b=AaLQJH2vH53oQfnj8rqIRLllC/G1l1kKjfkEG3q+CrXvKlAp3us/PQNY8KI+pszQEC0/q5
	lhzbXDDALvlLiu3tZC/er7WfbQbMc2MUPSCKZtNVZmB3l4oqUhsv8nhGt5Ox5P/UJn0KX0
	34Y3xSYoSnTyyZKJGDULESwysPxj6Tw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VeoRdrub30gmrQ9gbM+afvJZxU6dQ4njaQGuvWhRGHR9MTHUklucbDYP/6rsRkKDSn9K/tpONn1Ox9JUjZLNsd32OQqcYK14bIGdppcbZzj7hnUeYQ1aYhkGAuTmvnXB3SNXHZYsQxF3cp3in2NN/oZQKiz0UDXaDWFRKemr0o+uHIsXPi6Qi1sZkzwK+UKMZJZ2hspN+YArMaGF6D0tBJBv2DeBpKdKF0KWA/UPO7lFYx2+pnBGrPrF36ipCetob27MMEAFMbN9rGCnhG7Ep96OVlkvI2Yh3azI6S1caVZDlShT4jZlNTeGn1NT2+w37e2I3uqw0Sar4EOmvYiTDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XML1A4ds/0Nmc7CI4clXC/wVjRZG3YM8lxyep1S8xOI=;
 b=UF6lW8tCCUCQaOorpWETWUHlGHAWFeHX/TobOcQgX00cUQLHlnpOyK0+0klhstLDqvys63eebIY4dY6AvkkNcqW48GbgdJDsiAviRcu6bZfKJ1NPpZWuvun8jh+ZbAPrpcOZ06S+PSZpKDfICVjTOza3aBJq1LigRMzoPOjVdEY5h70fo1MArbXgZ1UQFFSeIwz2eMOd+9d5ohrLVK4/SomZHuu6++dTTlgeUau2XRhGQJ79G72/h16xxKFM1pf0V4tWexlo6wYBNDeOXSmycq1weLJRZ9KN6/bMJOtCxZjRLER8khGdsf6G36yAFZcG6PE83G2JribdYHYZ9XofxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XML1A4ds/0Nmc7CI4clXC/wVjRZG3YM8lxyep1S8xOI=;
 b=pkxszzv2lNPqcmy2vyaLa6A7A4SIBLd6zLiUGsg0wUKdjxvwHm3tIUvBVd14omkHEDfEMSlbjoSDpG2w3Dt+uvH/n+Q8RArSbbR0mJcyU34CI2Pxvsqy8UXunAHbOibThQB2ihXDPZH/syYwDCn25Dc2eP7sOk0JmiWdVw/dHUs=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 BL1PR01MB7771.prod.exchangelabs.com (2603:10b6:208:39a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.21; Wed, 17 Sep 2025 19:59:59 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%3]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 19:59:59 +0000
Message-ID: <e42e8b11-d86c-4164-9d6b-13cd34045570@os.amperecomputing.com>
Date: Wed, 17 Sep 2025 12:59:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
To: Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <612940d2-4c8e-459c-8d7d-4ccec08fce0a@os.amperecomputing.com>
 <1471ea27-386d-4950-8eaa-8af7acf3c34a@arm.com>
 <f8cf1823-1ee9-4935-9293-86f58a9e2224@arm.com>
 <bf1aa0a4-08de-443f-a1a3-aa6c05bab38c@os.amperecomputing.com>
 <39c2f841-9043-448d-b644-ac96612d520a@os.amperecomputing.com>
 <d7cd4004-bacf-47b0-9cd8-f99125e02238@arm.com>
 <fe52a1d8-5211-4962-afc8-c3f9caf64119@os.amperecomputing.com>
 <8c363997-7b8d-4b54-b9b0-1a1b6a0e58ed@arm.com>
 <4aa4eedc-550f-4538-a499-504dc925ffc2@os.amperecomputing.com>
 <1cfda234-1339-4d83-bd87-b219fbd72664@arm.com>
 <55a79826-48e3-41c0-8dbd-b6398e7e49a6@os.amperecomputing.com>
 <92719b15-daf8-484f-b0db-72e23ae696ad@os.amperecomputing.com>
 <e86e2aa5-c66c-41a9-a56d-74451df0d105@arm.com>
 <f8898c87-8f49-4ef2-86ae-b60bcf67658c@os.amperecomputing.com>
 <047c0f7b-e46d-4a3f-8bc0-ce007eac36a7@arm.com>
 <45dc2746-153a-482d-954f-11fe1cd8d18e@os.amperecomputing.com>
 <3cbda17c-4c1c-4c04-a1fe-bd6ea6714de8@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <3cbda17c-4c1c-4c04-a1fe-bd6ea6714de8@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0031.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::44) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|BL1PR01MB7771:EE_
X-MS-Office365-Filtering-Correlation-Id: 226940fb-e6fa-42a0-5721-08ddf624c6f3
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V1ZEZ0JaWXZ5SnQ0YnFzZ2JhcXNWc21CNDJhSWY1WUVDNVNZdW5qeU1WcDN0?=
 =?utf-8?B?bTFBeTVtbGJsWUZLN2JlRlNHY0hKWUdYR241amFnVlV6cHNoRmhPblVpckpZ?=
 =?utf-8?B?dVN5VFZNbHVNQ2tzcmgyRHBsOVlXYjBpWEx1VGJJNms5c1JxRHZsTERreXU0?=
 =?utf-8?B?MlF4WGtvL1BBK1AxdWMxclpCZHdBQTAzRUNOMlM5bVI2bFlaYUdvZ3d4RGNK?=
 =?utf-8?B?eVFPUFJSdFRTUURrYi8wTzB2V2VPSVB1TWx2alN1Y1VxZlI2K3o2S3BtQ01U?=
 =?utf-8?B?bjBHMHUxSXdCNzcxQXNPMXdFZnl2WUZRWGdRZWF0ZXpGbmJMYkZNelg4T1Vu?=
 =?utf-8?B?bUVNL0h5NzZLS2dtUmJCNlZkLzhibUtpRDZ2aHRVajhwSEtiL2tkTzNwbWV3?=
 =?utf-8?B?QnpXVlVHWDNUWkRyU054ckZxa1FLREovS1E5aE1LZ0VDZ3lMdWthallBMzRD?=
 =?utf-8?B?K1hSNWhZMjJsS2Z6aDBjMHdPbWpDQ2wyenRVeTNxcjF0Sjh6OWNqbFJLcVFY?=
 =?utf-8?B?Y1R0dFIvVVpacEZRUGZ0OElHb1VtWnFacnZJclZGd2hFQUZGZ00xTlBDemxX?=
 =?utf-8?B?dndhQ1JQZGxSajEyZVNjSW16M2ZjMTNaZ05aM1Eyb283bTR6QVpFRGhFaktz?=
 =?utf-8?B?aUtxNGRVUUZNSzUxRjZweUc0eW1MWXhUS3hJZW4zNDFTQ1pCemVxeHMyZ1Zv?=
 =?utf-8?B?L1dmaGFtczd6cWxOVnVZUU9OMjlkbTVBdzdwOXBxMUdYOEllQ0I4VllLelNV?=
 =?utf-8?B?NGNuQVQ4UVhJVld2ZXpmSGlxSlhmWWdOUG1pRkZSZ2tibmJaV2djRFoydzd5?=
 =?utf-8?B?dTkrS1A4bW5sbDBNa2V1NnlabGxTSUdYcjNxOGExNlN4Z0RNNFNoNVBFNkMw?=
 =?utf-8?B?S0E3UjJvSEVtM2pzcms1RkVqNDV2dHEyaG1yK0xmQWt1bDlCckRrRTI1Uy9I?=
 =?utf-8?B?Y3czc0tiNzI4NTR5b1hCZHVJeEhUNUZsTk85NVp0QWJTaFJ4Q2swUEN4NC91?=
 =?utf-8?B?aHF2eU5pK3lpdjdQRkFpSm1nSFBacEJNV09iRlJVWnNENWxhZDVEUmJURjZ0?=
 =?utf-8?B?bWVvdGVRaGcxclRydGo3aGE0a24zanpqazlDK3g0Mk9nSmltdmNpdW01OHV0?=
 =?utf-8?B?VDdyeng1QlJHOFBXVlpmMjN0WHQ5OFJTckhyUW9CQzA3MTc3RkNTbXk4TWxN?=
 =?utf-8?B?TjdNZkhuSDlpeTI4Tk5Ycjg3eVh6TXEzYjhubHFSbW1sczl3eDVSUERPRjk1?=
 =?utf-8?B?MEhTT2tsK0ZNRkNQNEFBTDJscXZzQXZPdDREcGhuSUR5NUtHSTh3QkxZNjlp?=
 =?utf-8?B?VUs3aFl0K3BhcWRmV1N0ZDl5NjdGRGVDZVpFTGI3aVJBb2hjeFdnNmpzT1pV?=
 =?utf-8?B?c1lRQktyR2JRTkhSUVcreXJmQzZoQWNPaFltdWlqTEUvdWw5Z1I5NVdlNjc0?=
 =?utf-8?B?RThYZGhDZjloVVpzdlhBQlQwU1paOEJXN3R2OXZkeXZZdzVyVDh3aUJ0b1hr?=
 =?utf-8?B?Um1rdkVkQXVmSWp0eWx6V3k4akM1clJWRXlwWFlrUC9mWXI4SW1uRjJIQlht?=
 =?utf-8?B?OUhCMDJrS2VBTkk0MGZISHQ3Qy9MVHd3ODg2NzMrcHFPeHIvdy9QbHpkdzV6?=
 =?utf-8?B?UERIOXI2a3M1UXRpbjRDSytUMEtiSmZtMG0zVmpTYjBRczhiWkU2WVQ1N2pB?=
 =?utf-8?B?eUlMeXRrVlRrdno3Z2NHM0pPVVAxdXlCY2RSdlZLZUVCYkNXQUV0eGdFYk1L?=
 =?utf-8?B?OHpqZ1FCa3dqLzRsUjBXTVptaGErbHZPTkZoTzN6YXBBRkI3WTdmd3hXazJG?=
 =?utf-8?B?NDYwNlhITTZJSGc0dDZ4MU1EaEFVOU9lQUdPOUIwR2ZOV1NLV1NzUHF5SVFo?=
 =?utf-8?B?VTE3YWZLM2NOVzhScWZKT3NRWWUyTkFzQmtHTmR3S2Q1Sm93S2plTmhzcGZz?=
 =?utf-8?Q?jNFL0YiSuyU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEdyOWJZTmRJbzVsdE80T29aNUt5OUtCVi84WEpUZkJlQjM5OFRjc1pDenhG?=
 =?utf-8?B?VzdoektpbDA4dWZJUEEvNnlxOExncytIYnFVYjZ0NWd6T3Z6Z2hUWFpJTWN6?=
 =?utf-8?B?ZVFoMjFjMllVTVVhTnNzYUE0UkgvRjNVSUlUSEplSTZHUHdBNy9JenBHR3Rm?=
 =?utf-8?B?VVQwV3lXdVZmcmNLWURoc1VHaVgrbXBxcFBlTHpZbVVBbmJtd2F3c0ZZTEtz?=
 =?utf-8?B?VTdaMUdsWmlIdVBhM1AxVkl2bjdtWGNMZ3dNSEJ6S3ZsNVBSeEdIQnNIUmVF?=
 =?utf-8?B?eG1rSUhkbklaZlMvelZuYWV2YldjamZPamxYckpFYWJVaW9qN2pKTG9DbG5K?=
 =?utf-8?B?Ylp1WW9PcWNieXJhbEpBT3pqbnNsMGNSSmZ0akFuOVp0QjYzTldiUEdvQXdL?=
 =?utf-8?B?azNQS2tVeks0djRoalFPMzZPY09GWnhGbjJhVWlncmlPU3hvdW5nMnU4aG5D?=
 =?utf-8?B?U3gyVmVtam9UM1ZpVTlUeTVBODlTNmZIV0laN3BCbkxDNnhMUW1KQXlrMTk5?=
 =?utf-8?B?WHNHU3JaVjFsaG9Wa09qTG02RlM2aHdxaUFXRjVwZWZHTG9rYm9jdHk5cnFX?=
 =?utf-8?B?UHVIcW9wazJuK3BhSHhkZ2JtUis4N2tqNU1HS2wrWEc3TlJTbVdBcmliVUxI?=
 =?utf-8?B?eU53aHRyM0c2U3pKeFFMVHBvMFY3K1N2MmR4RjZEWkZlaWY4S21iNFpDSEFR?=
 =?utf-8?B?SlIyWkM3K0dpR0hpOTN2dkxRbUVDUjdYRmpBeHlWcGFQYlM0N0EwaXY3M2pG?=
 =?utf-8?B?RExhTU40aFlkTW5EcHRGVWtiUWhWbnFib2NKS29CNnY1SW9jOTBTTjBiVXhZ?=
 =?utf-8?B?YjloNTB1RnFrQVMwMStFak9RYk14YytJR2FDbUx6SmZCNWVPSHlPUVg3djd0?=
 =?utf-8?B?VC9FaC9aVjJCYTdXd2ZkWjUvV0p5MHNPRFUxQ3ZHcjdEbTVFY2RkYnJ4QUJH?=
 =?utf-8?B?cWVEVDhaWjhJZm1ORUt3dmk4Y2ZKTkEzS29xQkJKOHJ1a3dMVk96SjVLWWp1?=
 =?utf-8?B?aDhyUUR6UjNOOExGb0NYMmNtZGpxS2MvTU5raEEvUDg5STdJdDV1WEFEdWl4?=
 =?utf-8?B?QldONTExNE9xUmlDcVA1dmpJV210UU9rai9jd0xGR3lVbC9hKzB2MDBqYXhD?=
 =?utf-8?B?SFVPeStRcGc1azMwQk8xblRWQk9ZNEFkb0RUZGxrWFJZYlEzNjQ0dlU1a3NE?=
 =?utf-8?B?VnFaN1JFc3Vsck5WQ1NmcE1oV3YvR25WQTRlNm45RlVjdThHbVFRZ3c4SlRH?=
 =?utf-8?B?YXZaek9BdThqQzUxUDVHdGtoaVVDWmFMaVJxczQ4U2JvS2lRNGx2OUpTVU9x?=
 =?utf-8?B?U3k1cFRuNm52V1BKMXVITnhlRzZmazgrZGJZZ3NIOVdtMndVcjFmTmFIUFYy?=
 =?utf-8?B?YVJQNUtNdkt3bmw5a0g5ZXhnU2xPcDdRUnJoN1Q5anJzc3RldjRLcEhBaW9B?=
 =?utf-8?B?cmFaSzZCT2JXWFdBWkZQS1NFNDVVNnJFRkVMVXFPNnFvUmJISi9ZUHVIQThx?=
 =?utf-8?B?bXRnSzFLR3J4bEZsekU4Z3FJM1g2RCtYbmN0aTJzRVJmYlg1cmZQRmgyVVp0?=
 =?utf-8?B?Z0JhMXdmUzFYMUtoV3QwaE53aUhiSEJGZUVZdE9jNklMUUVLZWswbmFRRUp2?=
 =?utf-8?B?VUNsTUZJNStnMGFDZlFmQWdvVDNldU9odXNuNHBjMkhrcVhldTRVQVpZYzdG?=
 =?utf-8?B?S1lSUU9NODFMazVPQm5LUi9XQVVJL3pUcTdiZ0NwSW1FSDVua0xibFE5ZE5n?=
 =?utf-8?B?dGl4SnFvSFBtOTRaVG5IbldCSk9vTTJFb1hvODBpMlNyZFdFM0dGWWFBaTV4?=
 =?utf-8?B?dXFzQUVXRFlGTVN2dnBJWHY0Y2NXV2NrVHRzc2d5S01JYlQ0Q3hjbzBWVjRj?=
 =?utf-8?B?TnU1ZGdvWjhOZWxpcFhTbDMxMzJQdkZZNk4zN2liQkdKYk56SVk1anJMWU1h?=
 =?utf-8?B?bkxKQWdDdG8wdGQ1bWM5TU05cEpqalFwL1RJaWdCY0Z4emxhdnVvM1hMeEdQ?=
 =?utf-8?B?OHpjRkVsV29LSDJGZ2pxWkNXYmpVbTgwTVV2VHFGVk1tbEZWWXdKZ1NFcHdz?=
 =?utf-8?B?V0pKbC94OXBpSDNIWFB0V0JsZFNzK0RGMG9uMTZzMHdMRlJ0SVVjOFllRXJm?=
 =?utf-8?B?MHcxRHFrdk1BQlNGUytjb3ltNTQxVHIxSHBXWVB1bTRSU2VkWXF5QzAwQ1lY?=
 =?utf-8?Q?rIBRZlHuKlZJLP1bbM+jS6g=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 226940fb-e6fa-42a0-5721-08ddf624c6f3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 19:59:59.3608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JIZgsmB7JBj8T7h577/O6Mp6Mqzb55qZi+u3lBeGUoCx/Htte2plDb8jtO6uMDxOh5wFdYaxWYJY7TDO5ZsJfdAglmEs/taLm7Y6bXwrICk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR01MB7771
X-Stat-Signature: 3crsysramxwunh1k9uwdm85zex4shw9h
X-Rspam-User: 
X-Rspamd-Queue-Id: 88AE4140018
X-Rspamd-Server: rspam04
X-HE-Tag: 1758139204-119837
X-HE-Meta: U2FsdGVkX19trPFT8cHhGxtKhaMDJvoUwukMU5xF9f2ufz4DMoPR3D0vq0ZC8QOb+EXLaBfK771M4WXO9mtTFcDnNuAVI5FVMii1ciIWyHMs2gSj1NbKgSpkhJSVJL/d6fULE404y3OENlXiUrwUVuO38+7Shf2RNpHUesrb01VylzsKAXxgppsXmo3+6gXr3/bqC1xKJdYoHyet0jlNvhFsYvHs/Ka18nzTe+I/G3MqGUAeLDRR836cwc/bvFO3cDUDoto5hsxbwSfz3YKoA68fdFj8dU+kbdt85WEE75iY4P6xkLp3xix86RScu+E5QDvlNqXCKG3FlfdqPmdtfmzdqqS09UgYJUfUyXdj6kRdWV1WCD6aKIXOwW01yB1HHSwH35HlnVQWH2hJCX4rwd6R1szdXIDVe+E07QiSC15PNwXjMijQCywuX79Wt8Qiv1gZbtUrv+FD6y5LFHv9JHQttR/sucaqBM+HWUQWznF6iTKDWgeLRIWpHisCsQTy9Ajl5zIf5JGbzGf0Mlk8f6i/sGC/P3/jDiMzVV06NzccC9JyrJLRSEq6pyjOvmpLQPemt4ft1Z91QYLnykgXyJAN4Fv0jfj6PpDW3NNNprhELFva2l0rq7VFLGBkQRf65KSClzep3TkmQD9fkh/MFBRpaQH7JE/RjMOWg2YCKUfAQoyd3pveCWntPMHgAnMc3r85VHkxDcqktRy9Q9nL8qarkYwGGm9dBBg1EC3W3Nx4BN75mwefTCiJeGFVRbRyC4xTLttSu0R4XergQEKyv78Um9j9Itknau/1qiC5zJcKSwIxraD9P9iPdf/PPF+cRi4Kc7VQSm2cK6RL+KDPrf5IHrni6r82toORtkIukmVFKKiX+vs/hgkqTf5NOE66bY/7NtAVZBsY+K024tjX+9BSSZPTfeX1iMmKO07PnC27NdUu8IhK67iBUaCjNf6HLzrrbMff+dGR6GPJyMb
 inSQSTpw
 sXigCOrrYJVFDGdEJf6WheqOROYiBxq4KRnq/M0HIwEXyWwESeMuIRwuLDqsvuA0MhrwicL5wsifmg79+INfOvScxkF0LlFxJtr3Kp6yollbbjbwnwOwz0SWC8swPYhtXlADYq5eKX3/ll4qia38YWOFGClCS+y6+qvrP9Bv9ACkWZ/XIw1qv2kVwamcNMZ8xKYTOvkd1o6PG0sPpVrJ3AUm4bGH9z2Zti/R+F7Y1fw6IAushwSUZqUFW8us4zpBVVcG9XOLkdxj8qsaXmvLmrgzJri7vwpawQD8OhdyCXmNh/Nzjm83kR5hnBAO+6F5kQMioLdqA29jiX69Pco+zzlcwxA2+VZatt/xNZxChXy0gjGXD5MlTKSswpVsYcDISZ8239K5mXfDB+RKxhXc6so0B+Uph/b9symL9xbqdIah8AIFKUNSzr3VjAvGKjO2UG4MrrPXb1zJo3pQZTnhXMD9kl5GOeVInfTnfeppD3c0DK8ozpOtmaZnkIdWNWJmxWtLYi2wEdcRrOKfLw1l1JawnZWDHwzdIzDi2dh6o755u10ZODL7kJuAEQ3pkqndSBIGDR40s5p4d9XS+s5l2dbtJtuXg8uGjn2bK1MWJ8jHAVSeTHLpzBs/k7ZK7QOUr2XFo3hVv+Xggihz13bHn5nmvIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/17/25 12:40 PM, Ryan Roberts wrote:
> On 17/09/2025 20:15, Yang Shi wrote:
>>
>> On 9/17/25 11:58 AM, Ryan Roberts wrote:
>>> On 17/09/2025 18:21, Yang Shi wrote:
>>>> On 9/17/25 9:28 AM, Ryan Roberts wrote:
>>>>> Hi Yang,
>>>>>
>>>>> Sorry for the slow reply; I'm just getting back to this...
>>>>>
>>>>> On 11/09/2025 23:03, Yang Shi wrote:
>>>>>> Hi Ryan & Catalin,
>>>>>>
>>>>>> Any more concerns about this?
>>>>> I've been trying to convince myself that your assertion that all users that set
>>>>> the VM_FLUSH_RESET_PERMS also call set_memory_*() for the entire range that was
>>>>> returned my vmalloc. I agree that if that is the contract and everyone is
>>>>> following it, then there is no problem here.
>>>>>
>>>>> But I haven't been able to convince myself...
>>>>>
>>>>> Some examples (these might intersect with examples you previously raised):
>>>>>
>>>>> 1. bpf_dispatcher_change_prog() -> bpf_jit_alloc_exec() -> execmem_alloc() ->
>>>>> sets VM_FLUSH_RESET_PERMS. But I don't see it calling set_memory_*() for
>>>>> rw_image.
>>>> Yes, it doesn't call set_memory_*(). I spotted this in the earlier email. But it
>>>> is actually RW, so it should be ok to miss the call. The later
>>>> set_direct_map_invalid call in vfree() may fail, but set_direct_map_default call
>>>> will set RW permission back. But I think it doesn't have to use execmem_alloc(),
>>>> the plain vmalloc() should be good enough.
>>>>
>>>>> 2. module_memory_alloc() -> execmem_alloc_rw() -> execmem_alloc() -> sets
>>>>> VM_FLUSH_RESET_PERMS (note that execmem_force_rw() is nop for arm64).
>>>>> set_memory_*() is not called until much later on in module_set_memory().
>>>>> Another
>>>>> error in the meantime could cause the memory to be vfreed before that point.
>>>> IIUC, execmem_alloc_rw() is used to allocate memory for modules' text section
>>>> and data section. The code will set mod->mem[type].is_rox according to the type
>>>> of the section. It is true for text, false for data. Then set_memory_rox() will
>>>> be called later if it is true *after* insns are copied to the memory. So it is
>>>> still RW before that point.
>>>>
>>>>> 3. When set_vm_flush_reset_perms() is set for the range, it is called before
>>>>> set_memory_*() which might then fail to split prior to vfree.
>>>> Yes, all call sites check the return value and bail out if set_memory_*() failed
>>>> if I don't miss anything.
>>>>
>>>>> But I guess as long as set_memory_*() is never successfully called for a
>>>>> *sub-range* of the vmalloc'ed region, then for all of the above issues, the
>>>>> memory must still be RW at vfree-time, so this issue should be benign... I
>>>>> think?
>>>> Yes, it is true.
>>> So to summarise, all freshly vmalloc'ed memory starts as RW. set_memory_*() may
>>> only be called if VM_FLUSH_RESET_PERMS has already been set. If set_memory_*()
>>> is called at all, the first call MUST be for the whole range.
>> Whether the default permission is RW or not depends on the type passed in by
>> execmem_alloc(). It is defined by execmem_info in arch/arm64/mm/init.c. For
>> ARM64, module and BPF have PAGE_KERNEL permission (RW) by default, but kprobes
>> is PAGE_KERNEL_ROX (ROX).
> Perhaps I missed it, but as far as I could tell the prot that the arch sets for
> the type only determines the prot that is set for the vmalloc map. It doesn't
> look like the linear map is modified at all... which feels like a bug to me
> since the linear map will be RW while the vmalloc map will be ROX... I guess I
> must have missed something...

Yes, it just sets the permission for vmalloc area. The set_memory_*() 
must be called to change permission for direct map.

>
>>> If those requirements are all met, then if VM_FLUSH_RESET_PERMS was set but
>>> set_memory_*() was never called, the worst that can happen is for both the
>>> set_direct_map_invalid() and set_direct_map_default() calls to fail due to not
>>> enough memory. But that is safe because the memory was always RW. If
>>> set_memory_*() was called for the whole range and failed, it's the same as if it
>>> was never called. If it was called for the whole range and succeeded, then the
>>> split must have happened already and set_direct_map_invalid() and
>>> set_direct_map_default() will therefore definitely succeed.
>>>
>>> The only way this could be a problem is if someone vmallocs a range then
>>> performs a set_memory_*() on a sub-region without having first done it for the
>>> whole region. But we have not found any evidence that there are any users that
>>> do that.
>> Yes, exactly.
>>
>>> In fact, by that logic, I think alloc_insn_page() must also be safe; it only
>>> allocates 1 page, so if set_memory_*() is subsequently called for it, it must by
>>> definition be covering the whole allocation; 1 page is the smallest amount that
>>> can be protected.
>> Yes, but kprobes default permission is ROX.
>>
>>> So I agree we are safe.
>>>
>>>
>>>>> In summary this all looks horribly fragile. But I *think* it works. It would be
>>>>> good to clean it all up and have some clearly documented rules regardless.
>>>>> But I
>>>>> think that could be a follow up series.
>>>> Yeah, absolutely agreed.
>>>>
>>>>>> Shall we move forward with v8?
>>>>> Yes; Do you wnat me to post that or would you prefer to do it? I'm happy to do
>>>>> it; there are a few other tidy ups in pageattr.c I want to make which I
>>>>> spotted.
>>>> I actually just had v8 ready in my tree. I removed pageattr_pgd_entry and
>>>> pageattr_pud_entry in pageattr.c and fixed pmd_leaf/pud_leaf as you suggested.
>>>> Is it the cleanup you are supposed to do?
>>> I was also going to fix up the comment in change_memory_common() which is now
>>> stale.
>> Oops, I missed that in my v8. Please just comment for v8, I can fix it up later.
> Ahh no biggy. If there is a chance Will will take the series, let's not hold it
> up for a comment.

Yeah, sure, thank you.

Yang

>
>> Thanks,
>> Yang
>>
>>
>>>> And I also rebased it on top of
>>>> Shijie's series (https://git.kernel.org/pub/scm/linux/kernel/git/arm64/
>>>> linux.git/commit/?id=bfbbb0d3215f) which has been picked up by Will.
>>>>
>>>>>> We can include the
>>>>>> fix to kprobes in v8 or I can send it separately, either is fine to me.
>>>>> Post it on list, and I'll also incorporate into the series.
>>>> I can include it in v8 series.
>>>>
>>>>>> Hopefully we can make v6.18.
>>>>> It's probably getting a bit late now. Anyway, I'll aim to get v8 out
>>>>> tomorrow or
>>>>> Friday and we will see what Will thinks.
>>>> Thank you. I can post v8 today.
>>> OK great - I'll leave it all to you then - thanks!
>>>
>>>> Thanks,
>>>> Yang
>>>>
>>>>> Thanks,
>>>>> Ryan
>>>>>
>>>>>> Thanks,
>>>>>> Yang
>>>>>>


