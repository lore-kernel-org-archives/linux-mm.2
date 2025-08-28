Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CD90C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 15:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2516B0010; Thu, 28 Aug 2025 11:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB9D16B002F; Thu, 28 Aug 2025 11:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C83606B00A1; Thu, 28 Aug 2025 11:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B69E56B0010
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 11:25:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C196842C5
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:25:21 +0000 (UTC)
X-FDA: 83826540042.18.3210502
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 44E314001C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:25:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ttr/25kH";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rMymH8pf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756394718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A6iz1Q+mEDYQFIECdLlh10N6Q7A5P9Piu0KDHHHXEEY=;
	b=kPFLAbdpVQcmUHZWgBOFfZYuhVKpRTGjk60sK13MSkh3OzPnIAoTHZtOUGz4fmJjJ5E//C
	akL2LSMt3cvj/RL8yuJ5h9bJ52FC828HV2P+cGhaH/nuTy8yirvr0CdkPWbpFd8l+2Q0tv
	TNBRpLuSXojpMnBhV4AQqc24iI+shTY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756394718; a=rsa-sha256;
	cv=pass;
	b=TNO58mCTtM8Hz1nKs7TeQNEWdZPAnISuQolyPjWMIN/L1hNjZQtAP54isWG1RH8yCjRgMr
	V+VB6VR7dv7D5P7CytNAfI3EBPnPcpohkkgkZz/xxyMBkKFPrlxlGAoBksVB03vytaf41E
	3Gzt6iquATfLVcanEqPmLxpM6oSn4VI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ttr/25kH";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rMymH8pf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEN4M5005168;
	Thu, 28 Aug 2025 15:25:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=A6iz1Q+mEDYQFIECdLlh10N6Q7A5P9Piu0KDHHHXEEY=; b=
	Ttr/25kHEl556Kk4Pc9FmeGxZcxjlf8D5yDSoFlWcMnbQEKRQkVzgrwwACQqA9o1
	5425+KmoYHrillIdOetczk60/8wFfWPXOWiDkJCc9I7O0TMhPetIrD1ZWW6nGoGS
	BVNrje4B2TPZC6XeP0MkqrQI0Zz3FN0UElnUH8Sf2Q4Oq2J3A05c2EFTRrXojnHk
	xrsJv7gUZ7B0Ge5XkgdGTmeK4YpPnfx2Jl3d00OKCzZQAlTlrw9ejGXmDyF0Ui09
	lY4WRi8csQmBvyNom24G4wUUEhqZmkq9v11KoKTAwbWLsoy9i4Z83PsotLbWD2DX
	grsbyd5v5v1ypVeSCLq14w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q58s8rub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:25:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SElDMX026739;
	Thu, 28 Aug 2025 15:25:16 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010070.outbound.protection.outlook.com [52.101.85.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43bw4wf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:25:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=opNHcZ4D3VDjGJlP/v7qGupQz/VfuIBUoxKrMWo49LIE8MrllBpb99tpBL+8bDK9oNB86nJ+p1rTg6lFKsV6jENYCsTXAmPuCheW8voAx7e88IHTP9X78wrsxfIADNPc18OnR6Ae8IxBCPMEF+rJGa7CHglmHoQN2cvICvW2EhY7AiRyhVoldtmiNTGl4GLO3ql0nOa7aDelJKNOKwFdHSvcjSj2m+MGsqtFbcMR4U7P/wC7S/e0c8T6DpIF0K5L4YOlt2ty2UBklIxQ9r2eoesrouaq5VrCj8DFDNsooHuTsf5BKicYNT0aedRfAMD19QwRvuMUgNwxP19MFRcuow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A6iz1Q+mEDYQFIECdLlh10N6Q7A5P9Piu0KDHHHXEEY=;
 b=U8VQ6RoDcB8N8qtmEr/tygt5DUsMXohUWlQbBCiWc/8Y36zVu1o0zZzlZ8WJ+gwUdNtxyUZe6s5lnPgeCQrDIc8CwxL0mNnOQuHYBxxsQoiRWvY78UG0O0h8qZ3EAd2N7r5jg3cZm+XPPORx7pwRLq8LGRU8O1j3nhtiVrXjQedEfhifPsrF3qkdji2MOPfDmrhtmLWMgjUr9E+eFL7zdDpZBzTS0qAel4IFY9pLSxlx/lpeFZPK7fbEJEQ3NhpNODxvvzoXWjGv2er0L7HOOQ8Q5U5jsW9Eau6YVL+RaobU0GG2k5ddJy2e5pNiEFYxsdI+1dWHH3pt9TolezwpPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A6iz1Q+mEDYQFIECdLlh10N6Q7A5P9Piu0KDHHHXEEY=;
 b=rMymH8pfCsPuXoxFROn7s1ffoaxcZoEVRMgj3v//mRoWTikQup0HDPF6xZHouGtE51mAPWixWnokQxTLGhsI23ftLekLHpm1DfBTrcujLLNu8FvJgXe02zyD1qpeXWhKlI148fOi+wHL2FjQFQFpTb0/x7xmQHlHA3NjhCDBEI0=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by SN7PR10MB6499.namprd10.prod.outlook.com (2603:10b6:806:2a6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Thu, 28 Aug
 2025 15:25:08 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.9052.017; Thu, 28 Aug 2025
 15:25:07 +0000
Message-ID: <133e0b4b-1f3c-4a62-9876-f191f0befd46@oracle.com>
Date: Thu, 28 Aug 2025 11:25:04 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] maple_tree: Testing fix for spanning store on 32b
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20250828003023.418966-1-Liam.Howlett@oracle.com>
 <20250828003023.418966-3-Liam.Howlett@oracle.com>
Content-Language: en-US
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20250828003023.418966-3-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0085.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::26) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|SN7PR10MB6499:EE_
X-MS-Office365-Filtering-Correlation-Id: f960475c-611b-4ed4-6e45-08dde6471202
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bUh0M2xZMDV6RHdUQS9wRnI3dDhpMHBjai8wVlp1UmhMRksyb25hR1dxMzFP?=
 =?utf-8?B?bytxek1ON0pRZXc4Yy9RM0xlMjRkTlRMMDFuZENRZnkxOVp6ZkcrYTBlYndl?=
 =?utf-8?B?ZjhORS9zN0RQbUcyOVlCSllaemRINGRRNWV0RFNhSFBZVW83L3dKcTJqWjFS?=
 =?utf-8?B?SDBnbVh0bkpTV01QdWluUGpMbU11Zk01bTdZU2F5WGUwaXFiQ084ZlVBYkJy?=
 =?utf-8?B?S0hDT0RRODhWZmpybTVLWTVNbU84U2kzRFFQNVJtR2tBM3Rmd0JDWmF1VUk1?=
 =?utf-8?B?Z2xEby8vb25OQmM1QVJwRUJSbkdPZU1XcExkSFBZWUxmZzIxY0lvdXdOczhk?=
 =?utf-8?B?aDlwcHcrMERFZ05iKzFmbldpS0xXSWR5bUFaQVo1MWVkOGh1RnZXUkxNaEIy?=
 =?utf-8?B?ODJzVy9TOEhvWmU1bmZRMDRobmZiNmYrV28vQmpvNThpdC9DQVMzWjNqR3Zj?=
 =?utf-8?B?aktZZVZhQ1hudXFoRVJuckp2cWVCYlE4QnZVVW5zMzVVbTgxK1RhQ01CTTZ4?=
 =?utf-8?B?Z05LVmdCK1F6azVyaDF2eE54dHRlcUVicm81WkJJQTN3bWNvYTR2NnVxREor?=
 =?utf-8?B?eU5LWTZzS3RmTzIvUm9EYW1id21FZCtZdElsVXdYa2UxbUJDdnZuYVJGekZI?=
 =?utf-8?B?NmdQN2h1QzRLamwySG1xdjVmOGYyTmNTcU9jMXBkUHJhV2RFcnpiYkNHY1ZR?=
 =?utf-8?B?WUpQUUhLcmJQTllqcVVVVGVCS29rYndvYWhSSS9RODRHTUx3cjVMSTJ4VDJW?=
 =?utf-8?B?clZrZm5RN1YvOGxlM2V2OVZ4K0JPMGIvQ0xWUjlVOXdoUHc4Nlcyb050TzR2?=
 =?utf-8?B?dkpqMDdGMG1CMVl1S3d6S3VlNitXN2ViamlXbWFueGJGUmNDamdGWHFlaFhS?=
 =?utf-8?B?aDk2cWc2cythSkZsdzF2ZVlXckppc0ZtR3MwWWx3aTNCN3cwM0R2ZnJQNGp3?=
 =?utf-8?B?V05ic2lQVWtNYlhEMUM3ZWRXQklYTC9HZEZRY2p3ay84eXFsYWZ5Nk5mUTJt?=
 =?utf-8?B?b0FwQ0dDUzFzNVFXMm5QS3lQOVdIdkRleGtORU83Z1V0ZVVkQ05iOW5VQVps?=
 =?utf-8?B?eFIrUzVKMGxqb1FNbjE4QWFSclNNVWZad1k4bmVQSTdQalFJOG9mYVBaRXFD?=
 =?utf-8?B?aHgzem01ZC9HcmpSclZyTC9mZGJySXFtTko4TGZzMGI5ck8wKzFONmNmM3Vo?=
 =?utf-8?B?cTlZK05QUjFhYWV2RWNEUXpjSHB1NW9HY3hBZXh6WkxDQWEzK09DM3p4T3B0?=
 =?utf-8?B?WVpzVyszb1dnN1RuaGZrRmFQUm8yS0RwOXQzM0t3SXVwN3ZsL2J1blZGK2hu?=
 =?utf-8?B?ZDltWWxMckp6dktWNGpxa2VDKzRSR0gwcFdwNElLMzVKbUdhb3hyekp6N25j?=
 =?utf-8?B?cHE5QldGV1NGamswZUpoZURDOFFkdWZPN0NMUkd5bmZUSHdKRStjY0VDMUxN?=
 =?utf-8?B?YUhiN1I4dXk3TWRvMGdYYlRraHF2NHpJb2NzaEg1MU0zaE1uZitrN0kyUGlx?=
 =?utf-8?B?SGhBZ1lOMmIxZGpuREk3T2J6dmhCN1kvRDMwU0RxVTR5bXZ3TndCeGxsa2NL?=
 =?utf-8?B?b2pPcEpIdGFzRE4xTWpUZzh2TXlkU1h3QUY1SGcxQXIxQU9HNUpvMUJaWkZR?=
 =?utf-8?B?b0N5bEJlY1VEVTZXMjBucGVCbFh5NkFsb2hVbk1Tc2h3WkVUTWxrRnVldzR4?=
 =?utf-8?B?aVY2em1ub2ZrZW8yQ1dMVWliM2xWODhONko4MkJLTlNBWlAycERlUUJPMy9m?=
 =?utf-8?B?ZnVOWTdENW5XSVZvV0JCcitQT25GejdwcXplUEh2VWVZY1JWQU5JSzMrN1pP?=
 =?utf-8?B?d01QY0NXc1gyYk1VMnM3L1pxVG5Fckt5cytrTktibGtIS1RodW1YOFRHTUJ4?=
 =?utf-8?B?c05FNnN1ZkJiRFNNM252YzdXNjh5VzJxQUhxMDdaczlSRnBVVVFpOHlNR1c3?=
 =?utf-8?Q?mCc5EE0CnVI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eG1wV2laMFVkcnAxZzFQUlZuNTFwenlSV2xtZWl2MGZnUnA0VkN2Y1d6S2Fp?=
 =?utf-8?B?aGpZZi9EYUJUR2pUc01obnQ4TElIUk82ZnZYaFZGTklKbFpsdkZMcXVObXZT?=
 =?utf-8?B?TktuMWZ5Z3lNcC81QjlxVkt4aUN2U1FGVlpWRTVzenpwb0VvNndEMGdLV0RR?=
 =?utf-8?B?VDN4RGduNE1LMmNRcGkxSHdxZlE1WEx2aGxuQ2p1Yk9nQ004ZCs0TmtGWUJx?=
 =?utf-8?B?RDFSbzU0eEhOZno5T2FlbzBMc1N1bGlqOElWTjlTYW4zNnRFV2c3b1NIcHYx?=
 =?utf-8?B?TFE3Tm92a1NRWENEaEhlQmtJNW5tL09tV3hHV1FpSSszdFUvU0JIK1RzTDFS?=
 =?utf-8?B?ZklhUGJmZDlDNlJyd1dHVEcrQ3J1MlNwTFVjYVhuZlNraUgxOXJuNzNoR2U0?=
 =?utf-8?B?dk5FdFZ3eDBSU3hCK2l5dzB4N2JERFVVb0RKOXhXTVpydFJZMjhTSmF3MHF3?=
 =?utf-8?B?dXZMb0FyazFIUlZUbHFqcHR5QXlEZnFiN2daT0J1aFQyWXByODBTdDdiTTg5?=
 =?utf-8?B?dUxjb0NQbjMwSllzRUJFbVFOcXZZWWZ3dXlVRjF2UkdIcGxwekhXbEFOeVFk?=
 =?utf-8?B?MWNhN2pIdEpidHFPcGpJWmtqekVEbDVsVFJEUjZjeXZYNGZ1NUhXNEZvdEth?=
 =?utf-8?B?cWZIeVFISEszNnlTOVNycTM3aCtOSTgrM1I5aTJ3aVdicWVyMEJZWFBkbzhl?=
 =?utf-8?B?b0FaVnlsT3U1MSs3YzNYY09pNmNzV0NPV1ZaMEpTUWVSb3NMZzArRFNVT21t?=
 =?utf-8?B?UXAwU1BYR0dHYWlid3FsWU8zUU9Ld1pTSlNpdjliVzM0MUV4ckdqTzFqNXp4?=
 =?utf-8?B?bWM1RHk4TVpkNEgxamFyZlRkMWZVMkxody84YUxJS1R4Y2VNUnBpclZlaUYy?=
 =?utf-8?B?NlVFd3RkRi9zWlhFM1I3ZnI5eVNsK3I4bFk4K0Nhc0E4cDZuYWNFVjNUdWFt?=
 =?utf-8?B?RU5uYlY4Vm1uMWsvYzZLN0ptdFBFYzk4OHMreDhVMFJXbk5NY2NUWmpCZlVr?=
 =?utf-8?B?K1YxRWpYanlMY1BmNlZDNFd2UEM3aDZsVUpPNFhsQTNabnlUc0V0VnBwSm9s?=
 =?utf-8?B?NGVFbDJpSlRrSlJabyt2UUtCMUZqNUxMVzYvaW1sbk1NajRkMkdVelVOT0x3?=
 =?utf-8?B?VUZxTDlWc3d5dVBwdGt5ZVhvTUNtNkk5YUpHbzZQRncyaVNFSHN6MWVUbnB6?=
 =?utf-8?B?MzhyVmNjTm5QVHJjV2gxaWRaVlUxSjVNb240cnRGblMzQ2ttS3hFTXl0d081?=
 =?utf-8?B?Uk5TbzRNampBSXBZb1dCTVRTRnVhayt1dk9GVlUrMVpSTmpQbVo2T3drOVVN?=
 =?utf-8?B?OWN2T1dqT1Zjelpxa0FsclZoUmRzY1ZEMWV2T3BhVm9MV2JKcXhvUllyS2h1?=
 =?utf-8?B?b2hCMzI2MVF3Wnc4elNkaDRQNUt5bFVudEdHeWg4Q2hpQndKZnZUTXdLTlVw?=
 =?utf-8?B?ak94Wi9Hb3hXamwvVWljVjZ6S2xWNWJUb0lNMnFDc2hIKzNLT3lPNS9IUmNX?=
 =?utf-8?B?Y0ZxVGlXNU1BaDVva1lLa0l5czdhY1pvMWdLd0Ztd1B2Z0JuNGxQUjBiQXFF?=
 =?utf-8?B?bXV5ajNpc21Sdml2TlcxaTFPWXUwRC8wYU1jV200bXh0cC9uRldJam9zRCs3?=
 =?utf-8?B?NlIzRWFDR2NwMFFtcDBvZFQrVzg1S05PNnAvTlRBTjdhWm55REZidTRoZ1NS?=
 =?utf-8?B?OS9OR25WdVI5bERUb1Q1Qk0vWitHMHRNVlZjM1Y5cHN5dDZ3WnpmclJMTWc4?=
 =?utf-8?B?Q0I1eVBqNWlZcGxBTHlEOVBFWGhpOStXNkhRcEpRVlE0QitnT3NVTEFwOW95?=
 =?utf-8?B?cHM0ZGVCdnNqZzRlazhDS3gyeEFFT096MVB2Q09TdVd6aTBNWWxoSU0vOWJD?=
 =?utf-8?B?TFFEMUk0NlB6cWQ3R0dvSkZsM3hBRy96dWlnVlFrZlhtMGZuQ3BDczVSYmFt?=
 =?utf-8?B?UjVTWFZtUDFUN2dQSXE0bm9PTGtxdm5pR2Z0T0YvUnl5MmJ2eE1BL0h3UlFy?=
 =?utf-8?B?UmtoVHhhV3EzcE1MVXJyZG0wcUVNZXMyS0IrQWtPU1RtZzRlY2loTDl1YSs2?=
 =?utf-8?B?WUxxK3hSOG1KV3JkQWsyN2FLNExwVDA0YWVvdEVSYmtlR2VvOG4rYk45Z1hi?=
 =?utf-8?B?RGlHOXhaUWZFbVV5R3ZueCtEZm1URnhqa0lOTnhocHdiT09YajBGWmNrUlJw?=
 =?utf-8?B?elE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q6wx2mZ9bDNWsHdwf3DGGv1kNVRwUkCtQLJ3UuioIqFbF8vQ8xyVnr6Zzp+aEAJApbQCrZdk6c+xpF+uicNI/Ck1A65Sg2Uy9gppGGPmYUg8bO8d35KXzHwkOlDAODC4CmK7p9YHe8DlqcZ9VHWtKHVr2kK2swE/1n3oyDTBNOQhaLqsbvcL6AZGvj2jBYEBSjxUD3e/wg+z8mEC3PpjY3o4e18SwmMJVyaYOMOxNfy3khARVySVxBZ0MeAVHmxru0YVrfKrvFGfwxEy0apnuwKM88pOZFfE4OLPMALKjhN+UyMcPTIWsbBeDvyWeqmHjdCnNKlL7fGfZporDT6X5gPpkiBlbeWcmwG2QMxmgHoLn51XPWAQPWtDzIeDLxYeoX6ZOjwVhlA1K6+NmEX0ZqUUJ09yBlzQiHtFoyjIKFrnGp+3vEPmDBEV+JYLquYpoQ3FWSB/MEFwmghqv48Pt2fj95Qre4+HWmhdymGvsKLLM82aWI/a5sWAgqkxbnbAwOwOmCTWMbCjcscb7pNpx9jNuv86OgOSLWqLa4dolAanEE2Re0wN21iyQOzlL8zFRsxTs3MSe+cbu7rR1gN2oxnARX3SavgCgs/ypdxuQp0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f960475c-611b-4ed4-6e45-08dde6471202
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:25:07.7256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jq6Zd7d2DZNLmm1ZtAgPukmW4CDbfTUIxVx+jV+Iqa3a2nflKj+MmnxVb7Ijebkg+DSvLWORiCmgGf8u/8aSrhwYpHwXfsN8sggtW50DZwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6499
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280128
X-Authority-Analysis: v=2.4 cv=J6mq7BnS c=1 sm=1 tr=0 ts=68b074dd cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=wB_bADJ8foi7Bvuq8k0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: U4zObZ5khNlGuEG1_JJVS_lH-_rrjD7m
X-Proofpoint-ORIG-GUID: U4zObZ5khNlGuEG1_JJVS_lH-_rrjD7m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyNyBTYWx0ZWRfXxtemCxieoIg/
 Hb7khQ9IqNv6/ArdqKThfRdxgielJt1MBH6drc8ofTeNCJnqb+79iGnJZ1QSGh1AhzeiL7/FJYQ
 wPN0X9SJTQljDIbup8Ie9xhghsbWBcALwsKGAQ5LI+x4SVnItuhE/F6NNAwaEX7sp0wtCutQQko
 UpvL+dsiLBLnqG/PEb7JOZqSg/cfgZL5ulrwbjolcCmZLBfkJKwsRgoE61AZ1AAK3YS4taHDC/f
 S+HsTDEqGw0YUgX/zT+vTA70f9qzS2Vmre7KyYTWs/gyd2P6GaviDgNpUttpkTdGhDhRvxfwXYS
 Nr6XRmYXGvBnfO0+MHaUl10Wpy0LErPHc70hjv1Nh8R5wa1pgFI7iKWsWXkMPFUJ8Ov0Xqs1gPS
 22FiGTO0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 44E314001C
X-Stat-Signature: kkp5az9npj17aict5odpasju1zryh8uy
X-Rspam-User: 
X-HE-Tag: 1756394718-90996
X-HE-Meta: U2FsdGVkX18qPcd4LMraz7cqH0/e0deJ3nyQzmiqeZYt/0zExRtCCdukFdS0ijfHC7gmfo/RyD3phD5KbdhkDWhRWr8tWoT49Lsj59E4iuiMD0LSxCXPHYlv1R+GPiqmZTlS+NW8lIqLKp29R4bqw1YdNtPfWzy1VxkeWkk1l9ZbAr/jqMrI8rpFZT3fXnhsn4p+z4wbt2mRqc7TaPOdkcHi2GmoXeQ8cvGH0V1kb0wBmESU1yf/lA+44AMh+FOMM6tyRqKMd/XdL7CDX7v8l0QQF2OLuOXsLHyEyEa60BrSpyFAphGXK9EVARFzPh9trLHfiDlAwNFKRoQnNY+p2F2RjVKFCHX/rHlWIlzu3S0aksI/qEUOzf9AbTubrVdAbAP+taapw8RW6ZOHzPZSZvjxcalt/ZSYTzc/4vebox3agSZ9qTnxgj25NOWm7qaF6ZU+ZFoy3K61Z6k5Ep3TZG2aj5Wsn84+i8In3Fs8ZEuuYCLar2Kuo7f5IpETOwWltUYiN44ugxkTFyjchMsNWf2EILWfDkFk+tzWGESkT4Mc1mGVpMGl9fbE6eXlzvAxTojhZkXzmLRk4yR+ecbVgcgP+5qgWt2SWLSPp2DuFszlGJvC3fPljsdvAgRq8kiq4d3xg0DXVR3vOTwp0ivbKUOF2UCmbTOMSw6Hu+JC/jqgvXok1ZLB89ZpFJgVN+R+1P8aFEsO8v9CrawOugWFd0Vl1U+6MhBCgjY+v7yQspO+WFfBxdxAEHVRXCgF18yhR8/Ey0Vat/9DuhxATUt+2lNbSO4TDXzPhd35YCQBw+ymUzoepAij/QCwEU0KXM9YmORKQHxOt0cOOdtH0pWOjd4sHegmZT99TunXbAECCCrAXR2pWP5/PJcICbH7IjB3G1HRH4RgeU1lrKBz/cREBi1tazhh73yvk2UnYFnw86NN8VOzsc4tKUHzjtD/kpxiAUbsjyoQHmq3aRB0Du4
 vdAjwJVy
 gRcvDxSYIiBOXpOIZzbvdNcMrCQK0Lde+uHsP1gOXpumKB+XTuYaAcapSYPpWaYnvUhgjZEvQ9xpFCdtDES2Wy+AHQukPdCxwtO7/g1Xijk/7c0leS8Vq15cUOgx9eqvtx9wc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/25 8:30 PM, Liam R. Howlett wrote:
> 32 bit nodes have a larger branching factor.  This affects the required
> value to cause a height change.  Update the spanning store height test
> to work for both 64 and 32 bit nodes.
> 
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Fixes: f9d3a963fef4 ("maple_tree: use height and depth consistently")

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>> ---
>   tools/testing/radix-tree/maple.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
> index 90a0db45a33c3..05714c22994ea 100644
> --- a/tools/testing/radix-tree/maple.c
> +++ b/tools/testing/radix-tree/maple.c
> @@ -36327,13 +36327,18 @@ extern void test_kmem_cache_bulk(void);
>   static inline void check_spanning_store_height(struct maple_tree *mt)
>   {
>   	int index = 0;
> +	int last = 140;
>   	MA_STATE(mas, mt, 0, 0);
>   	mas_lock(&mas);
>   	while (mt_height(mt) != 3) {
>   		mas_store_gfp(&mas, xa_mk_value(index), GFP_KERNEL);
>   		mas_set(&mas, ++index);
>   	}
> -	mas_set_range(&mas, 90, 140);
> +
> +	if (MAPLE_32BIT)
> +		last = 155; /* 32 bit higher branching factor. */
> +
> +	mas_set_range(&mas, 90, last);
>   	mas_store_gfp(&mas, xa_mk_value(index), GFP_KERNEL);
>   	MT_BUG_ON(mt, mas_mt_height(&mas) != 2);
>   	mas_unlock(&mas);


