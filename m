Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0393CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 22:16:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51E268E0003; Fri,  3 Oct 2025 18:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F55D8E0002; Fri,  3 Oct 2025 18:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E49B8E0003; Fri,  3 Oct 2025 18:16:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 289DE8E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 18:16:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8EB25BCE0
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 22:16:27 +0000 (UTC)
X-FDA: 83958212814.23.BF221EB
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010045.outbound.protection.outlook.com [52.101.85.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id C737DC000C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 22:16:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=anMz6hfP;
	spf=pass (imf10.hostedemail.com: domain of Felix.Kuehling@amd.com designates 52.101.85.45 as permitted sender) smtp.mailfrom=Felix.Kuehling@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759529785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwtbyfnVSjSZ1LbrBu0M0GT2WdrIqeO58kmbc4zLhn4=;
	b=Q17cUq4pJM2caGecYDbHlTYtn4nGbx1XEpiuyZZxG7r+6I7K8FMoBsaXDGBDJo+9t8/Be6
	rahNvrj0to4EBboo4QsetCWm/N4WFJyZ3nEUTSwHbU9aCf6e7zGtFFWg4WYS3OaEDBwqQF
	mmozVLZCQVqIuGWtI2bggFscUJgoNoU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=anMz6hfP;
	spf=pass (imf10.hostedemail.com: domain of Felix.Kuehling@amd.com designates 52.101.85.45 as permitted sender) smtp.mailfrom=Felix.Kuehling@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759529785; a=rsa-sha256;
	cv=pass;
	b=FxdfW5gga318AiUjRiWvUQMALyOTQFiEsalN+bl51uDaP3Avp23Go9Q/0HoEBdMAaNMZdx
	eWXnhbJnoW7I6KDptWguRN4IhGSq6uGi/1vNQ9VNpRRxXVvtpRV0zlgbDrzgZkki1QjVw7
	6JahM2Kvh4x+q/tcG7kTNLR5a2L0UZ8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GRQgsjs/M0Oj3qdlyJwAklC85XSGz0uMy48wHId3TfMZkVyvRPCbjCby7vXrsJigZ216SJGrjFD6gYh5JcTMpwX8EJoPwN/3a22C06Q8HXEA6UExbDAW75icYCeEuvm+CzHMJXB3amLt4YOqExEJajdW/rd5Kt4cF/c3X1H9Wz8GyJapl+nCU7VGwGQUccIS9mHcf3NI1fIumbJJa/p2y4bglsWFafxrCiYCQBC5r4Sr+AeGMHQkTZq/Jgi1oBmsGQJQqHJx2eOnn8j2UWrwmrFcDlicY0uPXmUr45L5scLrfpM3u6iKO4wdmFqD8jFYBFoT+JztiwH5v43HlqWZfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwtbyfnVSjSZ1LbrBu0M0GT2WdrIqeO58kmbc4zLhn4=;
 b=mqvCNoEjo/cEX4l9fqYRCPEk0SkdC5deeP6BGzqGcVSjQLbyFfisoDrRAC8kYreGojuPqa6k97qGh84FngUeg1k25vYcEAGcWByCECU43bqUxRXeLffliS6EbhLO4bhTUSAMF796t9gQdgLyiycoT7hWiNiGb/vX2J5ZzwgJ1TYdGm9a52syPOUn/zxzZQ2Y/CDIgtsTqpDUhK7L4mKxwCug03Gr2QVffhgatpF/2O2QGqEAqCU6ZI2J3seG24wt/G5Pou5KrkBlCWj6LoQxsSDCq/WCeNrxi6Xvo6sWMAY5G73z3SzKO6L8UF2Eg82edLbdCiCo5s7LqC3KcFbHgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwtbyfnVSjSZ1LbrBu0M0GT2WdrIqeO58kmbc4zLhn4=;
 b=anMz6hfPh2zHtK2yEjFfbTnx3sTNXg4Dlb6+wM7cAEckTppO6Kuf/H0kwCGSsDAUyWGL/8UPc+jxtSJvPq7RZPVSyozpcDY8VHWBpvrE0Yk7BfYZ19a2YgItjEQtqtNvckZIxlNH1AOBp+KCqLtcGwtofR/8DJJyfQCmJZ4XKnA=
Received: from BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14)
 by MN2PR12MB4254.namprd12.prod.outlook.com (2603:10b6:208:1d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Fri, 3 Oct
 2025 22:16:17 +0000
Received: from BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::9269:317f:e85:cf81]) by BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::9269:317f:e85:cf81%6]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 22:16:16 +0000
Message-ID: <17ee1a4d-69cd-4be9-bd6a-2924e8731db8@amd.com>
Date: Fri, 3 Oct 2025 18:16:14 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/amdkfd: Fix svm_bo and vram page refcount
To: Philip Yang <yangp@amd.com>, Philip Yang <Philip.Yang@amd.com>,
 amd-gfx@lists.freedesktop.org, Linux MM <linux-mm@kvack.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>
References: <20250926210331.17401-1-Philip.Yang@amd.com>
 <87ae1017-5990-4d6e-b42c-7a15f5663281@amd.com>
 <f3349a43-446f-f712-ac61-fa867cd74242@amd.com>
 <674f455e-434d-43d2-8f4f-18f577479ac9@amd.com>
 <aa910171-bc96-d8b1-1bee-65f3ef5d1f46@amd.com>
Content-Language: en-US
From: Felix Kuehling <felix.kuehling@amd.com>
Organization: AMD Inc.
In-Reply-To: <aa910171-bc96-d8b1-1bee-65f3ef5d1f46@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YQBPR0101CA0338.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::6) To BN9PR12MB5115.namprd12.prod.outlook.com
 (2603:10b6:408:118::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5115:EE_|MN2PR12MB4254:EE_
X-MS-Office365-Filtering-Correlation-Id: ca604d40-a4de-4d1b-6fdb-08de02ca78cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cm00TVl2eU5WZW13ZmtjQ3lIWEhEV05Md0NqT1VJM29FK1p3cG1JL3I3dGNo?=
 =?utf-8?B?TmQ2UzNjMjNPNXlLUVlEREN1SDR2U2pzRkl1WURFS0RSdTdXUDZSemJMSUFX?=
 =?utf-8?B?a3puQis5NmhLdXhZNkJrZDJpYWpiQ2dXYU4vYm1RTy85R1RoYUQ3Z0o1NUp1?=
 =?utf-8?B?eXUyNjJRbjFCeFJlaTMzZWtPZThQaEVkanVjMzVzTE94eEQ3eEFUM015WDFT?=
 =?utf-8?B?SG11US9aOVdYMlRSSVF2dWRvQ2FnekNCcGlyQk9tYWx4MXZwbThqYnVtWEF0?=
 =?utf-8?B?ay9xeXlDWnBkNnBzTGt2Z0dERkdzd1Z2ZjVtYVpPOGdrQ3NlNW92VFNwU1JW?=
 =?utf-8?B?L1pTME5ZdHFQeTd1QkhaaTREOCtxNDM1WXFwNG5pZ2JpZVBkai9qVU1QOXV6?=
 =?utf-8?B?TGxodjc2SlBHOXN3R040M1BmT1k2SEdNRkU2ZnJxOTN1Q2xCYmttUDk3djc2?=
 =?utf-8?B?RGhtV08rSm1oR1hoZnlzamZzQ2NMSk9zdU9zYlRrTmNxTzEwUGg1Zm5vRktN?=
 =?utf-8?B?MHI0d2d6RndRSVdMME5IdUpOWVV3c3FaT1ZDQXltUjhNeVRTK2ptVVBzenJE?=
 =?utf-8?B?OTVEb092N2tZN2ZuSEZNZ2FzYjlkSHZSL1NSSTYwMFFnN1pObmVlY3hVaFR1?=
 =?utf-8?B?SitsR3gxQ3JJbGszUmRVODR5aTBoak9uci9IZU5vTU9NR2VzUTRKUmVnYVZ2?=
 =?utf-8?B?MmR2QTQvaGxBdkk5NE9nNmtFNkpJa0lwWjFhNGRpUkg2N2VJTHRSWGdUNlRC?=
 =?utf-8?B?MWNuN0tHZ284VW0wL3FQb01YNEtwbjdjR0VZaGp6bmsrck9uZUsrdzR4R09W?=
 =?utf-8?B?NERRWkxyOFRFc05HdzlpQXhyQTIwYmNoK2VHZ1MzdW9mNXo3NzBicmpTRk5U?=
 =?utf-8?B?Rzhqbk55WEJEa1NPcWRiZFRtZDl2T2o1SHB5R0loaC9QVTZMVW1wdElIU1Ft?=
 =?utf-8?B?VGFUN3BwTXVsYzE4aE1mME8vbE4wdGxaUDRuVWw4MmRveXQwZUlmaUNlRmtQ?=
 =?utf-8?B?TkRGdExRbENoZS9ka0dYd2hkMHdQODFYQnluS2VyV25oTUlGWUtMdXg0czJ3?=
 =?utf-8?B?d2E2QTFnSm1XUlBxUGVOeks4b1Q5bVRFOFFqa0RpeDZPL3RLekFtQ05RMURs?=
 =?utf-8?B?YjlDSWdtcmZ6K1VTYXprNEZNckt1QWxFaVZ5NVlDWm9JNDNGbzRaR2JjZ0Jp?=
 =?utf-8?B?d1RuQmRWY1orcmxpZnVHMzh2bVB1Rk1sN0tIN2JFQ0h6NDlramxzWmhDUzVC?=
 =?utf-8?B?bnRPQlgyUFpnRUlodXBPTmFzd3BTZkkvQUxoTW5pNkVUSTVTU09YZDdhK0RP?=
 =?utf-8?B?bEluNXpHQ2VaVDlZSW44eDhDSi8xVCtMcnFNaHpHUzdkS3JUSUkxL3BucWI3?=
 =?utf-8?B?TkNDRWxtYWV2MEY4OEtNdWkrSTFsM2NLdjE3S1hzczNuUXd4cW9zWG1SSkNE?=
 =?utf-8?B?ZjBtYUhiSjNMaElRd1h5dGZ2cDRybERBNnhlVlV3MjZ5QkhDc1ZBTng4TzlQ?=
 =?utf-8?B?OXRPWHRLcjZDRnF0clcwQzdpcER5bUNoSlp1OG1tMjdRNU1JblMzWnhIWXJo?=
 =?utf-8?B?TWMwZ2Z1dE5LK0p1TWpJZGJyOVZ4VElwWEh0dTJlQUgvUU9ad29XMHAxdlJ2?=
 =?utf-8?B?ZnZ3Mnloa0l3WkRLYlYzcGFYdEx0c01EampZcVJ2Zld2MEZ2S1JxbE5lQ3hS?=
 =?utf-8?B?b3lRRUI2QUZLaTdKNVBPMUhUSFdZVUxkVzNCQ0ZUR2pYV05UbjcycXE4NGRV?=
 =?utf-8?B?cTVGa0FIS1AxWGE0SDhBR0ovRDZpQy85Yjh1ZGRnN2tqRzNIMVpCYVhjN0VD?=
 =?utf-8?B?NUVCUlBna0c4b09Ia3JNVlBmMG42KzQ5YjZKUlFuMndreDFEZUd0c3lTbE85?=
 =?utf-8?B?M1oraGZTckdCSFNYZjEvSVE3V1VrSEZMWU40M0hrNlJpTHQ5Z3JJQzJQTWZ1?=
 =?utf-8?Q?LeY7DpiA4VxGRtb7/ywHADWZbp04urC3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5115.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmJjdkRTeU5GRkw5MTBjcU9EM05PbkhlWXVCTk1qSVZ3S1N6dzR4V2dCTGF2?=
 =?utf-8?B?RUZHdmZnSXN6WkxxMGQ5SnBKYzJydEN2aHg0WGgrZGhHcVNMMDYxVG5KQmVq?=
 =?utf-8?B?Z212Qnk3cEtjdmZJQkJjM3UwbDhKUDduNEhKWmdFQjFuQ0JhZnczNFB6VUti?=
 =?utf-8?B?VzlrQ1VkWFlqY1JUSlZvTkhJcXR3NmdUZVJPaEVzY0RrbjVxNFlXMG5xcVo0?=
 =?utf-8?B?eCtURkQyZDlHTHBjSmR5TUY5am1udWtnckZBU21TUTR0TU9weFVlbFl0SlBM?=
 =?utf-8?B?UDB5TUcyeTJOMTJreUZDdE1tTXEyMURBRzczUU1PUXBSRmoyOUY5NDMxazFB?=
 =?utf-8?B?WFpPL3RTSzFIRXZHa1NiUnFYNlFBOWFzRFByVFNPZWRtZzJqMHMwRVhaR1FM?=
 =?utf-8?B?NHM4dHZsQW9aY1ZMZzlzZTBPZmR4TUdVbklSSnhsS0MxeEhlaEhGOUVGeDlH?=
 =?utf-8?B?Q1FhUkxabklQS1VpYklNaVJuaCt2eTNPbEg0dW1vTnNiQjgwSVJneW9mTFJl?=
 =?utf-8?B?djlHT2lKNkZNK1A1UDNjdUZuVjJuRmJ0WExSRElFYml6NVE4ZXZqRjBWS2ht?=
 =?utf-8?B?bFZYSGRTdzBZWlJuMmVESkIxc0pINkVHbUlENWZsaFcwVzQzbytSQnU4UTNR?=
 =?utf-8?B?cEF3dml5OXpCalE0ZkFYL29rRXhkMkVZekFNYW50WUtFTlVTc2M1ZUd6Z0sw?=
 =?utf-8?B?RUdTbHYxcVAvWC9aNEdXMFN3RTR0N1Rybko5RC9nR2ZwUnJtQzNBWHRnR3VT?=
 =?utf-8?B?MENzdXdIMjF4RDlneEJXV056WnE2aFJhNERScUkzSVhYMC9ScXk5QURaSFRD?=
 =?utf-8?B?U3F1dlVqSDNIbGxVMnBGUkVvTmsvY0o3VW1aREZOTXNVaUFQRThOcjkyNmlS?=
 =?utf-8?B?SUszclJOcUhVYkt0c1BsUlcwNm1hSlNDUWhVMm5zSUM0REFQYmJ6RnFJQkcw?=
 =?utf-8?B?UEhHK3dmajM5N2U2WjFrMTVtUGt6L3FRdHkyRmZXQ1k2cFFuNFUweVBqN2Ns?=
 =?utf-8?B?VkZOaU9kNmJ5NjRja3pxSTB2VWRyUlR1aVgydC9jNzJsMVFSajdnMzFDdVNX?=
 =?utf-8?B?OWtqQ3NxYm12ZFBoRVlhVldOYlJGY3hqaUs0ZFZFMy9KZHlvUFc5TEpFSGJj?=
 =?utf-8?B?Rkh4VkVFWGZjZjJtWlprejVMRzBnREhlSFFpYzZoVVUyTW9nWk4wZEpqNlRk?=
 =?utf-8?B?d2VrTlZtVjlHMTh4cmwzc0hxWGRNNXdQTVVublBSWG9Sa0FwSjA4K3AyZjNO?=
 =?utf-8?B?MGM3QjJMbGRyWmZCSzVqeXVCUFpsbzNMSmxKMEYvM0VtMGZ4ZXE0cnV3dFFK?=
 =?utf-8?B?d0k1WWJiaWZOSW4yZGY3T1Vsd3ZaamtNWnZoaEdQTHJGMzFSMWhuT3dRZTdX?=
 =?utf-8?B?a0dlemxzYWNZN3FteXd5Yy9Zc3dzemFkaG9WV1U5WEJDWVBEbXF2VDB4bUVp?=
 =?utf-8?B?K0xGRHZLamkvdktoUzBOWHhldTNrd1BpVWVnRmtmZW50bFU2WFpTcERMM0Zi?=
 =?utf-8?B?a1JTWHpLa1IwMG1UOGJtWkl2djB0ckVLMUpabjRCZ0h1ckszWHBiMm5RdW9j?=
 =?utf-8?B?THBMQlU5d3ZRdXppNENBYXlTbjQ4RE5Yd2FrQTJ3NkFGMWpicXdNeWx6VHZU?=
 =?utf-8?B?N3Rocm44ZThzdW5nclBFM2JycXRDRFRvbHZpWC9IRGVkZ3VCN3htMmJDTVgz?=
 =?utf-8?B?d29vS00yLy91cHVsWHd6aUxTaGQrdHpaMjFQOU1vQlN0ck0xV0tBVE1uUXph?=
 =?utf-8?B?MzdnL0RwNUhrcmR4eCszYzY4S2RHU3lPZWRIQUhiK3Q0QjR4VkQvZ1BLbTkz?=
 =?utf-8?B?dUtWU1g0VkU2a2UwNjMxM1p1NWlUL0JWUzJPRktya1czbnhiRkt6bEh5aERi?=
 =?utf-8?B?WnVZV0svTVhGZzBUWWhXWTE1TklTQzFtVXVLT0VqNlkwNzJhekhTRDJxNGlW?=
 =?utf-8?B?a1UvblJTajZZdDlPTGJlNzg2bml6eE5ZZVlrNjgxSG13MGtKV0dCMmphdHNh?=
 =?utf-8?B?aDgzd2RxM3BzaWRMRHJ3NkNJTVhzdUp1MDFNYWgrMVNCcVVKUDlNNzRER3Rx?=
 =?utf-8?B?dktSeWZzOUpHVzdzZ0l2d1QrRHZiY09LWGhXMUY4eXVYelkzODQ2Z0VzYjlh?=
 =?utf-8?Q?d9/r3rHGUumxsIaCpfp1sN8A3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca604d40-a4de-4d1b-6fdb-08de02ca78cb
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5115.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 22:16:16.7795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ugjYDAEqxI6rVtXAezve1cse90lYTlkP6BafApYDiyIgdB7lQ73YhgwyM0JCOGdQ/QLs5DaBpU5osGRnkiCsfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4254
X-Stat-Signature: ih55spxh46bw47j35hxyzd67bzue5ne7
X-Rspam-User: 
X-Rspamd-Queue-Id: C737DC000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1759529784-421766
X-HE-Meta: U2FsdGVkX1++T+GASjZXVbdvsj0aNhVLgXre93B/3j6Gil+DepcEI0h3m7GzenChzKi6OZ90yM8Q2IyAbxuYyzlVzufEPSYOR32FlwJvl7pn3R4nDL8fN7L2DbYXhVhple7VuXdRYHbhGMZAFqXQniVziPayvt/eSXhgdngNwtmiK0GwHqj3iizkk6s+dSmch375Y/R6RzT3AUmUuenTTlVN8J4k+K76XVUCSXeh0FIK6ZvhC9fvYS7ZEkyylfM6UyHvd9zliuYPO/m6fPSwVLbRhcYCTlWO/M4PrLHxZ5IUBJpeDAdcUHKXALmGmr2A1bUB6dwT6+iMX315nRxDjJ0RMs4Yne3GRSa8VJm7BP8ofUviadtf5LaLkCgyUJJxFBlZbit/G8TkuzvUr+zpJY5BlhbAl08iwvgUCWMg0jomO7ko6n4CiMZr7894p66EVfP3RJv5O5ReA1BOswAe6hvb8n9eAyOTpNfCfr5KtkMaYMn3nu5Ya+gSlNGC/oVDPs6jygKtv9TyvCNA4D4D97J7mf9xMy6HDX7D/T6QlGrIgGSeXc9z0mxdguE5REYnQHTLVxMFYAMWuH4RLH7m5/S/YLArDU3Asb0pwsPqpAngVJt5/+JgFmH3w6Epi3ALjD96q2WYSQocCLOqSRslzZV/XpBVpdjJslhlWaNhtHPVPwFgAvI10NuVSQ3AiUsQnPP/QZ/Q+zLIG0pTWHkE+XOu6KCUxk1FKYlqaZYHO5j23AtpfKs3abjM8Gz/mYmBqODKC6j8i8kKNcZ3P185y3BS8dtTgd+xibv0z2DltaOTPNfiRqCCJv59JyUBcpzyvuOpZtqR5xnbCde9xGFv5Al9rTaAdkrR3p+NYzjFEqUqRqCkZ0A4koyqnN2FbG9jf1RfqMmX4Om27wWT7nmKQpjBJ/cEtHAqG83JjoaL5skQVx7Cb4/Y92XD5rHKcvHCVvNMXAf0RDCrtO6VdOV
 2xCzIQsG
 HFSyW0Xs+MiZz7kCH+DI/hzCy3QEjIQ/dJvUeTArq+ElwAke7aUlozuAsVKMTX1hM2lQpJGLYTtMskqRmg6mGpK+03HidxqeOWAimYGV3Hc9OfVqY6Ul5jgpNiodoWqlczMwAvdYPauMsLHL/WOJNjBHyZ4WIiOuazBSSdOnsfBeNjYuYGhs+iuvHVML4aL02nzwfGyavMErNRo9FYh83KBjqImEICQnSMci/wi29rUNqXzwQwA+8obHZT0V8juXBjn9EYUB/a9VWeX2ZbTN+XMWh60Cv8reLPA6VTIvrVuXxR4LJ1eugr8XWIO+ezvvpctSCMjzjIBM/qBaQzGyklIncJMsA7/xbJHOGed50E3d7WsmrR/OCsFqjRcm+cyE+vNNIV02tjAYdjugzlPdlHRaM+Xo2F58DIf1Sm0qzzf4ryvIlEfzM2ycs9MLSRX/fOJlFfP1PD4qwnmWCUYtaM9IyNPjCcbACO13wA+g1tUc95ykiYTAlhJQ+yr5ywrbpMmBVWqpS0VdYaSx9Yu3vBJLC8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[+Linux MM and HMM maintainers]

Please see below my question about the safety of using 
zone_device_page_init.

On 2025-10-03 18:02, Philip Yang wrote:
>
> On 2025-10-03 17:46, Felix Kuehling wrote:
>>
>> On 2025-10-03 17:18, Philip Yang wrote:
>>>
>>> On 2025-10-03 17:05, Felix Kuehling wrote:
>>>> On 2025-09-26 17:03, Philip Yang wrote:
>>>>> zone_device_page_init uses set_page_count to set vram page 
>>>>> refcount to
>>>>> 1, there is race if step 2 happens between step 1 and 3.
>>>>>
>>>>> 1. CPU page fault handler get vram page, migrate the vram page to
>>>>> system page
>>>>> 2. GPU page fault migrate to the vram page, set page refcount to 1
>>>>> 3. CPU page fault handler put vram page, the vram page refcount is
>>>>> 0 and reduce the vram_bo refcount
>>>>> 4. vram_bo refcount is 1 off because the vram page is still used.
>>>>>
>>>>> Afterwards, this causes use-after-free bug and page refcount warning.
>>>>
>>>> This implies that migration to RAM and to VRAM of the same range 
>>>> are happening at the same time. Isn't that a bigger problem? It 
>>>> means someone doing a migration is not holding the 
>>>> prange->migrate_mutex.
>>>
>>> Migration hold prange->migrate_mutex so we don't have migration to 
>>> RAM and VRAM of same range at same time, the issue is in step 3, CPU 
>>> page fault handler do_swap_page put_page after 
>>> pgmap->ops->migrate_to_ram() returns and during migate_to_vram.
>>
>> That's the part I don't understand. The CPU page fault handler 
>> (svm_migrate_to_ram) is holding prange->migrate_mutex until the very 
>> end. Where do we have a put_page for a zone_device page outside the 
>> prange->migrate_mutex? Do you have a backtrace?
> do_swap_page() {
>    .......
>         } else if (is_device_private_entry(entry)) {
>    ........
>
>             /*
>              * Get a page reference while we know the page can't be
>              * freed.
>              */
>             if (trylock_page(vmf->page)) {
>                 struct dev_pagemap *pgmap;
>
>                 get_page(vmf->page);
>                 pte_unmap_unlock(vmf->pte, vmf->ptl);
>                 pgmap = page_pgmap(vmf->page);
>                 ret = pgmap->ops->migrate_to_ram(vmf);
>                 unlock_page(vmf->page);
>                 put_page(vmf->page);
>
> This put_page reduce the vram page refcount to zero if migrate_to_vram 
> -> svm_migrate_get_vram_page already call zone_device_page_init set 
> page refcount to 1.
>
> put_page must be after unlock_page as put_page may free the page, 
> svm_migrate_get_vram_page can lock the page, but page refcount becomes 0.

OK. Then you must have hit the 
WARN_ON_ONCE(!percpu_ref_tryget_live(&page_pgmap(page)->ref)) in that 
function.

It sounds like zone_device_page_init is just unsafe to use in general. 
It assumes that pages have a 0 refcount. But I don't see a good way for 
drivers to guarantee that, because they are not in control of when the 
page refcounts for their zone-device pages get decremented.

Regards,
   Felix


>
> Regards,
>
> Philip
>
>>
>> Regards,
>>   Felix
>>
>>
>>>
>>> Regards,
>>>
>>> Philip
>>>
>>>>
>>>> Regards,
>>>>   Felix
>>>>
>>>>
>>>>>
>>>>> zone_device_page_init should not use in page migration, change to
>>>>> get_page fix the race bug.
>>>>>
>>>>> Add WARN_ONCE to report this issue early because the refcount bug is
>>>>> hard to investigate.
>>>>>
>>>>> Signed-off-by: Philip Yang <Philip.Yang@amd.com>
>>>>> ---
>>>>>   drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 14 +++++++++++++-
>>>>>   1 file changed, 13 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c 
>>>>> b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
>>>>> index d10c6673f4de..15ab2db4af1d 100644
>>>>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
>>>>> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
>>>>> @@ -217,7 +217,8 @@ svm_migrate_get_vram_page(struct svm_range 
>>>>> *prange, unsigned long pfn)
>>>>>       page = pfn_to_page(pfn);
>>>>>       svm_range_bo_ref(prange->svm_bo);
>>>>>       page->zone_device_data = prange->svm_bo;
>>>>> -    zone_device_page_init(page);
>>>>> +    get_page(page);
>>>>> +    lock_page(page);
>>>>>   }
>>>>>     static void
>>>>> @@ -552,6 +553,17 @@ svm_migrate_ram_to_vram(struct svm_range 
>>>>> *prange, uint32_t best_loc,
>>>>>       if (mpages) {
>>>>>           prange->actual_loc = best_loc;
>>>>>           prange->vram_pages += mpages;
>>>>> +        /*
>>>>> +         * To guarent we hold correct page refcount for all 
>>>>> prange vram
>>>>> +         * pages and svm_bo refcount.
>>>>> +         * After prange migrated to VRAM, each vram page refcount 
>>>>> hold
>>>>> +         * one svm_bo refcount, and vram node hold one refcount.
>>>>> +         * After page migrated to system memory, vram page refcount
>>>>> +         * reduced to 0, svm_migrate_page_free reduce svm_bo 
>>>>> refcount.
>>>>> +         * svm_range_vram_node_free will free the svm_bo.
>>>>> +         */
>>>>> +        WARN_ONCE(prange->vram_pages == 
>>>>> kref_read(&prange->svm_bo->kref),
>>>>> +              "svm_bo refcount leaking\n");
>>>>>       } else if (!prange->actual_loc) {
>>>>>           /* if no page migrated and all pages from prange are at
>>>>>            * sys ram drop svm_bo got from svm_range_vram_node_new

