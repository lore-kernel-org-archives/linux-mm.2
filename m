Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66AAE10F9943
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 14:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3E96B0099; Wed,  8 Apr 2026 10:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB416B009B; Wed,  8 Apr 2026 10:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82CA6B009D; Wed,  8 Apr 2026 10:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 958326B0099
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:32:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 428A1E0401
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:32:55 +0000 (UTC)
X-FDA: 84635630310.09.F3FA76C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 97BDEC0010
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:32:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ew7UtYQF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k2DYn7ti;
	spf=pass (imf22.hostedemail.com: domain of joseph.salisbury@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=joseph.salisbury@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775658771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3nsiNP8XNFE7OWuMlPWIwrFZTLaM0R2nCPlV+Tc/baI=;
	b=rlM36cvpA9LEd1nOeE/Oa7tH6kA+xD4u2AEWqo8Dj0bLKi0U0I/+pA65FMSNqy2+ql37OD
	SxV7bXqd5l9rhQr9sPsNqeDi8FJHvzmNxO+TwLYxSKL5WcBvm4D2Wa0x2roCyHl0OV8Wzz
	KQtiudjL7ozuOUGbg2vtIDVbStimR9A=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ew7UtYQF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k2DYn7ti;
	spf=pass (imf22.hostedemail.com: domain of joseph.salisbury@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=joseph.salisbury@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775658771; a=rsa-sha256;
	cv=pass;
	b=YItQ1IheykY4U9QflWK6gP8Sw5OyW+IBJmroX3N33xd/uGcEFX2aQ5cBTt4q5YDzsBrw7X
	lOdoh7XI0X03OLCEm9AWeq5Z52+PilhKfmWZ3rr9PiWdkAmDGMiaAop+kXV9niDWFo2wCA
	Dg3nuTPk/t/d6zkaXC2CCYEqqvfz1CY=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638E8hJZ212818;
	Wed, 8 Apr 2026 14:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3nsiNP8XNFE7OWuMlPWIwrFZTLaM0R2nCPlV+Tc/baI=; b=
	Ew7UtYQFVU8KKBWVtIA4sKGD/+gOoMa3DcDC6pXu/tp2hgZgdEEDNgxVHB/HhI3s
	P2jleVt9RznIxvoMgH+hRq7HBGfj+b8vUMB5hJQbO3VsjIn4jCtSlyVqWyatKJDy
	lLqCJxDwqGs/x+ULet7z61ezzhcbnowwpNsyOqDHja2iz0JHEUtN+BjOjDRlbDdo
	5jGmzBdSkk33ZzF2kbma3kNLi4SIpkl53t9l/MQ+0BrOj9XVGKM3UfbJOr3VBXMo
	fZPLWnV94j7IL56N0Edypx/xAlgoPPc75cF9dxptiMwn70e1W+NK0VWMmdaImFbS
	KqgRqpg5ATvO/aS1MTUWhA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqaunpw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Apr 2026 14:27:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 638EG5Cf003572;
	Wed, 8 Apr 2026 14:27:40 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011012.outbound.protection.outlook.com [52.101.57.12])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcn5wtbfc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Apr 2026 14:27:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wdf8c2Jr386JhhHaLJus785oQBR4Pmz0W41zker4zC+/JBTTJzwY2M3/G3nJ4vmPtVZbPKU2eyytbJ7Oewy5enpahQmvHucUkVkfdM/otcQhRQjBAuv3gkxym+N8M+WqdM0DeP0bHuRU+w6X4/E/zWR2bAn2carGcVgZsWM0PT4fIh50cbW7+pdELB9bFwG5gCyccYjISmV5gxsftxF1DHZrzgWZZ1vCjq1vZQ02lKkKieLyIx70vUNjhEIdYMuVtPOY0meUNKldZDsx3bjfi6Zs7gxH4m6LVuNCPJb5UtOqDUHngzspfMcOVvUVOUoVNmryiqbDzircU/rF+P8zbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nsiNP8XNFE7OWuMlPWIwrFZTLaM0R2nCPlV+Tc/baI=;
 b=aILY9l+ofL4r3J8KV27lptqluIRknY3L9d1Uvo5ALqqzMPWX/1ivbBPz23NAcuy1eURubsS26/uCpzMRytSs1zotWTXOAHbWTAJHSfkz2hDc1YPQIELCCEIDJmDqlpM7OBeul4lclDw242NtyyRGy29R70vnN0dHzMweVLOjxW6ODDNlUEWIul4J/xAu47YkLV/alQ8OZuY9pgldd7cWFpntmVIN60r8z11jdD9BSdYCWMV+aoYVpu8eRcwQgXEjnroPXthJXmq6jhGz6QKbt0wRRL8kmXiVr6EpzObjCsPz5YqehHOzj6Psh1h2e3J9YTUDsbCdqpluMW9cEo6wsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nsiNP8XNFE7OWuMlPWIwrFZTLaM0R2nCPlV+Tc/baI=;
 b=k2DYn7ti7H5SI/YbkRVgulJwNmfX79LDBdSmHyDyPdGr6wNBVXqI5LzFvN//a6b9S2TCl4SkV9LUThF+zaQzgOmZVIBwq+MaH5V7rrIma7aMQM5WJoEecp5+B0iL2CsQmreyKLxJQ0uInk6yYqE0H7c8dMMmNC2t67f9lh7Hlls=
Received: from CH0PR10MB5131.namprd10.prod.outlook.com (2603:10b6:610:c6::24)
 by LV3PR10MB8180.namprd10.prod.outlook.com (2603:10b6:408:286::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Wed, 8 Apr
 2026 14:27:37 +0000
Received: from CH0PR10MB5131.namprd10.prod.outlook.com
 ([fe80::ab76:24ce:816a:8307]) by CH0PR10MB5131.namprd10.prod.outlook.com
 ([fe80::ab76:24ce:816a:8307%6]) with mapi id 15.20.9769.014; Wed, 8 Apr 2026
 14:27:37 +0000
Message-ID: <ebbd4c39-859f-4a10-a9e2-c0e9cd1013a9@oracle.com>
Date: Wed, 8 Apr 2026 10:27:34 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : Re: [RFC] mm: stress-ng --mremap triggers severe
 lruvec lock contention in populate/unmap paths
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <k2ldf7rk6mogzhoe3r7a2hpcc62x2uqqpnwk3czbet4shpirs5@sqfzsqpdc3fk>
 <639f20f3-9e65-4117-af9b-e37af0829847@kernel.org>
Content-Language: en-US, en-AG
From: Joseph Salisbury <joseph.salisbury@oracle.com>
In-Reply-To: <639f20f3-9e65-4117-af9b-e37af0829847@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:5:333::21) To CH0PR10MB5131.namprd10.prod.outlook.com
 (2603:10b6:610:c6::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5131:EE_|LV3PR10MB8180:EE_
X-MS-Office365-Filtering-Correlation-Id: 294f0253-32e1-4755-c6c6-08de957afb47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	hYt50RY/XH8+wDKk+Q1dPZ7fC2tS0Ua/4ura0CoPoa4HN8glh1tdyx8BGF9tHT8vt4PgqUBhdjrzne+p4XYI2SVm9+AHliqoXr3dl+JEGYlQK1LpVxafCp5xDt1rxdKwmZGyUVzpyPA13qWLKHGUs4aVPOTgCcogUT88/MC8IMKGlXg7wv1Nf+kyKmNrMT11PuIsX0bT0eEn+h6MHa87svnAREz1PhrL8TFrZEBj2WustedueRvjfMTcyqs2zjVOOS153wOot/lHNMb4DOKAYNlFlZxAckANIoCSaAwm1lt0qHWE7b4PbfpzSgtwKC4f/eAenKwz04UpJd53sI6SBUd1QJWqr7f6dYnXjWu74G6nPJ0LrTQWSB7Ragc5sH+JYKb7+X6ZTN+wwH/zkQFgsg6ZpjkjVPv0Vngb4uFjmYtHtaxMgpfvGFwglFCIp7oaS5DP19h8FFaq4OJBbTLptTUaup/+xXQSWEbxGSK6M1yEpkSYk9F2ADtvEisaOub989yIPIP+rYu7iW4A1mvaqpnhXH9ZGuiwUIYlfv3uwvq6s1O9isVYqVQRl8xJ6EHEKn6l7J7+T7eI6BqxA3VxGxbPocqnHkfHqD2mc6TngAsltJHJIyAq2/3kyGwNAKIcqnoq6sH9cROp3h/HbIrwcj+ShQb0FHVSD3Bv+F/cfid2lR8YjRL5Owsdh57DDxQzrxZnJpaIADu7bdDs2Hb/bf/xb+HWhZ7FpmCBwonN5g8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5131.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWlpRWxMaFFLMXdPZG9mTDRRK1dPOFNKRWNXVXowQ05jcFNPajNpanh5dGlL?=
 =?utf-8?B?V2VPYmJWUS9xV1hweHhqdzliekFGekpTaTIrZStzTlQyTExTUm9BdU51YjZw?=
 =?utf-8?B?SFhqSTlPYmpoS3JTSDhtMlBUUVNYWkt3V3pvcU50TjJQRmZIVXpENi9pRk10?=
 =?utf-8?B?RUVEak9VN3diMll5ZVRBMnNGcFZNeXJnV1lGOEZ2SHBObGZQMDZoVHJNcDN4?=
 =?utf-8?B?bnBvVEI0Vmd0NlA4WTVYcjFseE10VSs3K3Z6SnVDYWxUcThjbU91K0xjMW1D?=
 =?utf-8?B?OWh5VGhaaDJpdi9zb3U3TDl6djVtaXo1dUdncEo3R2RwSFB4cVZLZXRIUTZy?=
 =?utf-8?B?QU1MclpPZUtyMjlhYzlhYTVqajhKcGdUVGd6VTI2L3JPei9QTUtRUGpVem5p?=
 =?utf-8?B?VGtQL1ZVVWVOTGYvRTFlOWFDa2F5U3BROE1wWDROaUNHMTdTQkZON1piYTNa?=
 =?utf-8?B?QlEwTlUwRFYvSForTFQ4Qmd3RWZ0UklqMEhOOERSYmJhMy9xYlc4M2g5K3k3?=
 =?utf-8?B?Q3hMNWRaOWFpODZpQVZDYmhZSTJ1WlRhVjkwWEhGR1VVUWlYbFIwVG8wUWp3?=
 =?utf-8?B?TXZBQnpHWXBPTE8xbGxrNUgvVE5OcnJxMTE0ZkFGTnhaT2F2ZXd3ZWt4WFlv?=
 =?utf-8?B?bVZDT1Y4R3NLdUhPZFVwVGhEVjVJbkp5a2pOWjJJaW96SDRFZ2Y3eFhwVVBa?=
 =?utf-8?B?QjNYZ1NQbVhuUllhS0dWWEQ5MXY2b1huVXVwYVJla0FoY3FGbDVMTTlZOUNz?=
 =?utf-8?B?d05SM2FLR2lhbXE0YnVuRzFGK3NQK2JTMDYwdFlCcmFFZWZkMTZwSE14OUx1?=
 =?utf-8?B?VUpJejNSY1JKU1pNVUxzL25wM01KU3pqbGY1TlhtOGh2cy95YWhRUm5BT1Ey?=
 =?utf-8?B?NW13bGIzTE15amdmUnNZL3RSN3ByejcyKzZzU3pyRk82MFRqYzEvS1RxcUY5?=
 =?utf-8?B?cms0R2MvdDZPZkNwUjZsNmRtZnltamx2TS9OaWh3K3FrOUJOanA2Vlg1OEMv?=
 =?utf-8?B?SDZMbWt6OXhncC9QNWZqUnRWbmxlMVZ6Q2RLNHdyTHJYS0lYUnMxQ200TTNO?=
 =?utf-8?B?VTJ1ZHU4TElhem9oclNzTjQvdUJtaXhhNTRmcmhUVHVpSlJXUUFOME5mMnBP?=
 =?utf-8?B?QVJMZ1ZhaERIbWdNbkh0eGZsci83Ynl0UTVzQ2JwQi9senhYRmpyVGxWWUF6?=
 =?utf-8?B?dGRCMjJkVThsSzAwK0txVlcrVnJlZCtGcENyalNVN3ZuQWVYOWlNb2IvWEZB?=
 =?utf-8?B?VmJ6QnRaem1HTlFNamc0Q2xmc2hERGkvem1YNFhORHVlUk92UUZ3N0RSMlY3?=
 =?utf-8?B?TkF6eEZ4bWF5RkhibVQvK3kxcFIvNnZ0Qi9PMWJNZkJ2Y1RhSjQ0SFY0Mmgy?=
 =?utf-8?B?cXRKQ05DRjk0MkI0Um81Um9SL1lFTzMyU1VJR1FPaEpuWVpGZW1oUTNoRzhV?=
 =?utf-8?B?Tk9BWUoyQ2NBWUJHTFhzbW5YL2c2OVlvU3FJck1QcjNBZFc1Z1Fjby9sUzE5?=
 =?utf-8?B?cVNLZ2pBVnRJdDJ1RUN5U2dReENFWWU3RWp3d0MxMi9GaHBtY1Y1VjlBL09K?=
 =?utf-8?B?bnRzQ1BaYWtwbisxZEFBbjJiVkhvbkh6a3dKaENIWUtNSVFJTlBEb3JBbFlX?=
 =?utf-8?B?Szh2VUV5NmtqZzdMdFUyWFRIYmhnZ2NyUXE3TVJsZmNnMmQxd3k1eDdXdndT?=
 =?utf-8?B?bE9jeng3OG81UTVlMFprYVRVbzc1TWhqaFdteUlncjR3S2FuVzZCSlB1eVkv?=
 =?utf-8?B?WHVxdWNVQWNrME1SK1paMEVUSVZoWjVEc3E5U25DU0ZCZG02bnppZk5VQzFZ?=
 =?utf-8?B?OXdtRTZVbGViWUFnUk1CeERXRnBSNWxMSWRIV2xMMlZuOWh2YmU4bGJ1TGNX?=
 =?utf-8?B?TjhxbW1aR05GOWhkUDYvNXE0TGwxaUZlUitIeVJ4cTZZN0xwaGRPK0h5Y0tO?=
 =?utf-8?B?Z1hqSmt6SkFSdGVpcDN0WVV6em9HeEZDSWRHVmV1ZVZSalBlZTd2ZXYveFRz?=
 =?utf-8?B?VDMrNXo5cFVnazhNbW9RTTJEdk5CK1FoVFF6ZGs0c1Q2MWdzcXo1VlpNa1px?=
 =?utf-8?B?K0xwWklqNjJ6anZocmNSb1VpSkJtZExLVjArdUZ4dnBjTm9EVGNaMlFyU3hS?=
 =?utf-8?B?OGhiemsySkpveTN0T3MvMFhqYm4vUFU2YnF0ZnFuUGZGMCtLWjF6WFFmMXJu?=
 =?utf-8?B?TVpTZGlSdXZhQ3Rtb3l6aTZHYmQ1T3psa1NQaks4ZVIrVm1kZWEvRWo0VmdP?=
 =?utf-8?B?UlB6dkpGd1I5NmxkQ0JOdW1JM0Znays3VXdhYU54enVGdjliZENrNHFlN2w2?=
 =?utf-8?B?eG5LRHFnRmw0RTNETGlINVJla1NhaGIyN09hVnlDeXFERVQ3L0JqZXRPOFZK?=
 =?utf-8?Q?pV13Xo/XNDP47U1k=3D?=
X-Exchange-RoutingPolicyChecked:
	WaGs3iLbKS8Xj1kcgo8SdyofZfbL/ffCK79MTVfiCTdAyb4rTKDslg2F8EHShJx44UwLSCOPiWvC/CbvHoXXJ8oO9e/joph3h9ATOuAE0k9MerF7eONWe3/W4Cjxfbm6HBYsDy8XISsaxlMPrlYET2avfwUdAb3RlEyqrdoKGAsgcS/vw/xxJpjbSENbWfMSn/6tcZy0Lo8yG9nzzW/ePiDfzhwwSX7THZ7MZUjAxu5xN0sQHv5HicVvuN4/LxUleEg96qf7ETPlrL9Q9S+gS50BFBrf/tY5+34UPHYXtaABDB9XMoEdigvNZVZOsTVG48gu+tJGyHatCLEhEEqanA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iDrG9QKO49Yfth71auqYFLZGIhn0uGuR4VQ+qStvrNlJQlSYJ+ogmRn5WIlBRAKP/prm9m2Hyq0bhp5WxHR+xnbbV9iqPDXm+KLaF04UYfsf8f8Qt5C2kGBZtE1UBQFcKcLji2t07L8UQq1A37dPMfZzZKBzQWK9CTRJxOJrQdkTizQNJTHwzVP0ORqqrwufke5rJ8pnE3Op6rHf2sp/Bp/SUHHNlbY7Sx+fKPj2YQ5OyEgDV5b77hbU2tcNUBNqDm/OeBjQq0vgrd6XEYvxgS54ZkUJwhxUQpeLroMZTmQVw5m5RhtHcyfXGaSRFTxwToLKuRTY7s4XvTGJlc06u1AnXSZd3pyJRCuPkDGUxo6aMrj4EJwzvdogJLddmgsNY8w6aolIUWLsw6GQm06wcSLb0dgxwssBGEX+tFLG2ip6LEiqKQwm61Tjrvmis/0JsDseE87smVWmE69R87aeI5K1esAokZidt9XogHY9JcIngKmyJc8PrI5/gF5cw5dEjmS59W4fAB94XX554dBciC4YG5Z63mNNEn6OB3tzZMO6WWlO24T+cPTZzfpAr6gF9ZWF45m+N2LEJEiJaerOVC2Mzdd57kUWNDHQvzZCkII=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 294f0253-32e1-4755-c6c6-08de957afb47
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5131.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 14:27:36.9422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XW3YP9iAI1fKg97JI2WSdJKxD+w6m7J7cq0aA3eg1i8GnWkoxZnkFI/j1y0UCwa8FdjFVcJ6QwjAXztoaKRXwAdvvRasBtZv5g5qRc5x2wQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8180
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_04,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604080133
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDEzMyBTYWx0ZWRfX2aKqiwwW03FM
 QAozBsJV4Z3lP3U1OH/UtLibQCK65pRSEsO5rJoQGi63d8URhj+IzUsK+jc4ddXf22COGXJbQmZ
 3Mpi7ujt0YK9Bzj95rt1uehdS2VUoBSiGLWqHO3MavywgDFoxByGXv3x0mjjETUvWQdoHNWudHA
 DEREDck9PW0NZ5rkTcc2I4B+mMsvroGhONBUd3f+mkABx803907vq9Ly81bhbIbiBhvsOLkkD8w
 ogp9iBXnHGoo88jJWeilj5BstqcMcG7n0riehxZ9oZ+jsvsmHphIN4NSfoWpgKfMZumCCmFs7rZ
 A+z1SMlzonYmN0ZWZJ5u6HCdaYRKULbshjHHiDomisosuBIM3QUimgejVzC2Cv2/ztvilgJaULH
 B8HCAMcij6JuDrB0wSBxuv1zC7aiCsWRxlCSL34I1RkO2oEvkYOWwXcLG6fSIYPB9mOMYKFUMU+
 CTc7ZZdUUb0Fdey3iws3ylk/sJnRbBvp/IImQpt8=
X-Proofpoint-GUID: 6VJjytY51_2P8Ob7bHUIF-LgnxBJ8P_7
X-Authority-Analysis: v=2.4 cv=Oux/DS/t c=1 sm=1 tr=0 ts=69d665dd b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=4Q9MLjCS6kJe3uB55v0A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12291
X-Proofpoint-ORIG-GUID: 6VJjytY51_2P8Ob7bHUIF-LgnxBJ8P_7
X-Rspamd-Queue-Id: 97BDEC0010
X-Stat-Signature: 5otndocf34mjgeoqbdrxtrka987336w8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775658771-134298
X-HE-Meta: U2FsdGVkX1/hasFsTyaMYF8IqUA4p6EnsqyfNdPw9IsPUVsHChzWmINZHZVdF6KBnlr2tANQanVFuCQNRU/VemdLCiwgtN+t+h2MrfXH3YFE45SNXeJ74S/iU75a5z9s39tlgSc+85Az+da4/u5/60i0J0bsbflxbuC8jfo5KTgMlVn6ubSjMvdeVwX3KUfjtVhvyd9szZa0plxoEIb1+5OdazGA0NFApnI/NPcO4MXDSa4PnwuOu1sY+6UfXXMqtm9U2PiUP88yRzOX+N7WuKpAnO1gJYGEH/FQyXL4zrUhw54jPfiP2FscUWe+5TC6AscdqDFf8bBQocVjvcVim975SBcJo37zL5qUfntUULTPcy3v2oe7LhEtxMBjTe+s+A4RlPt6kJ4lSciDCaKQejs4pFVy7UxXY0KQukZU0L8Pv7CTBKhxSq8zTlykAmkO8J/P0dT6XO77i2THbZ2Cmj0uPDwh411BQanR7NIcKvkn+/xnx19qPhsYzQcR509Yht/GWQtoaMh3sXL20N3PMPiy2tW++gUOiu+U9gSwFXO5RnEo7xQ22i6xX3Q0tuQ8OJGcyc6DNPWyivVcNEsuA1YFO4Db8DmkQev8LG2xTWQ3XcRYeLV9A/UnPriF+i5iDDPoRMyjUGeOUA5bHOzbQIPn/wHfJkMyqZMypI5s47f9PvywxvHaeWpZd02z+8E+gcF/GpmatW7McaePqoxotVwQsq6qsMkqpgk98sMnfbduCeA0cr7JjoXPC5B6pjEIs8WDFOxDwnEhM0IhUBEmrPiYQPEuTUaDyRhduxaMNk7jEhWds9CuTKggg5ju43G5dNl16GcB/qNsqMfx4ARImeKwRqlOpcT2lScnU8LhNnh0xh552f0WHs7yM8Oi1bKfSm56lxVfISSZfEHQ71Rf3WwN/6k/tsH40YDwz3zE+2VDuJu9P35SK8oSFzKmC01GedUH6oFlxGnB5qUtDil
 zj96ODMc
 j2pCHtvFMXaZ08Vr6ySY+tCL/71srBHLDo+DgPT54AZ3YJ27GCr2HVMu0DioVVwICsoaSJHsrBbXuIVKbcg7bUPpHHS7dwxQ4EmDp6/IK5u0qNThwaIt+cxBAQehFmTzSvhRStVWUjQ1Lhi2TcU3TONlqJ8NzKwRhqLDLm8NnGBFcm1VWDuXfhxeTP+Hl7QdUcxu7zeWte3vQGz93k+qfUI8adY6nd02ylgvgLiJCYZT8VjJL3NWJnNlwhN9QOwXr8XQF82wj+dH8FETDjuBU92AnTqcnsb33pc/+65IJTTpFdtF1KuKkjkL/GXWdex90NTq7ZxlB3Z5cdIoHFp3n0XMZ2/6hdyk8iSGs2EshapAtSU8NNx7y6Bni86RIrvb0AqAnpHbK8w9HqHQIN8CgpHh4QsnkJPeWHKkUiJieaDtAuQ7Qys6pq+I4k/Hftu/7QxfNqEeI3SbbrT348ZR7yjYhKcQcEb1euKkiDyh1kgaDNTesGLV/3qAtN6eKL3W1bsuUJQTkeFfQG7/8wWJYkEdRDmuHWTj442IUddDcUVaCeGEhcUaAF7x6y+w2G+OmfKP/umv5zAjDOLCw/onk6B+mvQOtWQULv9zNKBBrpVL9v6Iw1rqgpXdZpzctltCTWxx8X4JxKk+y+yioa6DE7KVXxrvZxE2A5RSB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/8/26 4:09 AM, David Hildenbrand (Arm) wrote:
>>> It was also found that adding '--mremap-numa' changes the behavior
>>> substantially:
>> "assign memory mapped pages to randomly selected NUMA nodes. This is
>> disabled for systems that do not support NUMA."
>>
>> so this is just sharding your lock contention across your NUMA nodes (you
>> have an lruvec per node).
>>
>>> stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --mremap-numa
>>> --metrics-brief
>>>
>>> mremap 2570798 29.39 8.06 106.23 87466.50 22494.74
>>>
>>> So it's possible that either actual swapping, or the mbind(...,
>>> MPOL_MF_MOVE) path used by '--mremap-numa', removes most of the excessive
>>> system time.
>>>
>>> Does this look like a known MM scalability issue around short-lived
>>> MAP_POPULATE / munmap churn?
>> Yes. Is this an actual issue on some workload?
> Same thought, it's unclear to me why we should care here. In particular,
> when talking about excessive use of zero-filled pages.
>
Currently this is only showing up with that particular stress test. We 
will try John's patch and provide feedback.

Thanks for all the feedback, everyone!

