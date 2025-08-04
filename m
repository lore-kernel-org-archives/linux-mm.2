Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD38C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 836928E0002; Mon,  4 Aug 2025 11:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80EF08E0001; Mon,  4 Aug 2025 11:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AFB28E0002; Mon,  4 Aug 2025 11:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ACBE8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:54:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F398B8292
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:54:38 +0000 (UTC)
X-FDA: 83739522636.23.BDF27F7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 40ACE140004
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:54:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mPjd35Jj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qvAMEWJ3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754322874; a=rsa-sha256;
	cv=pass;
	b=5q7qMHpfU9FTtpEYO08DsjK9Ucm0/SHKqOb/1/fsl771Yht63jXNaCT60/OP7TwrPAafDd
	6ieWQGbsCJLqw5hhAIDtTF5wuCFPcMJMiv1j1i0/L1ZS/kYUzsyrpmw84VBO/rqIss3/GD
	0p00wNYnkjMJjutwOGc0J/ENb9GTEO8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mPjd35Jj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qvAMEWJ3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754322874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U+MDhn0vNOOdr9fDHPKFklyLwGGP+RPXno4yaix8KkM=;
	b=g8eAaX8rSe2pZOqUHneIbBIpeCwg3AXvI4mTL5MuoKLOvXMyw84Mll9quUQSvE7mySb83A
	2QgNPf+q/+qnAFWAjZ7Z5KUJmXGEWO8M4za2MRiN3YANVMU3BfQl/moUXT6i6VY49dKSDT
	B7LAF902F2OLVou1jduL2+w4O/ScNEA=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 574D6fEv021638;
	Mon, 4 Aug 2025 15:54:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=U+MDhn0vNOOdr9fDHPKFklyLwGGP+RPXno4yaix8KkM=; b=
	mPjd35Jj6BOTlIjb4GIJczZ5KiNuv0b4BEKISSsDs+ISESRG4JZzSUxf7FjnSH2N
	3eKYda9aU8O1NPEaouulxUlaClzb/4YAG587cKFDrrR+A2Dwcz3w35zKdOaDz4Iz
	2vzZgUuFR8wjGPxzECoVXiUyuzW/axu3E196luUx6YsjlttAVhYqTXXPQO+PDj7m
	kbFqjsqmCxW8SFKEWnsaj5baEe7wxoRTrn62LbdFp10B3VRBzHhk9ffSzThY+PlN
	fIx/knkMBSboZ9NQkqNmIJ59psjkDYEQG4Hj9g7TL8oJ4wR99zy1bYqWiscOc0kx
	50L0Gbu2aLNZ2KcOuVOPCg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4899kfb0jx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 15:54:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 574Fannq025314;
	Mon, 4 Aug 2025 15:54:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7jsk88k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 15:54:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kCyN/S+WyppePeaFRvyTpR8yn/ilR3SiICpyyCf1lNwC6eR1+cp7YCkupJJAidB4N4c5rr+rujq+nlp/VnXLID35dsWkIUYI/wkR8NqxWY9OYVwskgC93Dbz4yi0rXMjWUR11lrf/LTdKxS6tHBNSPkqbh+3TsLjjEC+JX113CtLQjL24yt0y/aobiM76iYVMmWxQ+XdORaImQbcNhGaX0Zhp785+8NJMndTpIUeEJo+Ahxs3GIzyogj4QTCC/mEWwm0ip56aQePSmcAjt4G6wmoScYQxfcA4XyzBspsQttxCJ6jchXa52W/ofTqAgPGlY9YyU0Dv3ZYTrmP5gKp9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+MDhn0vNOOdr9fDHPKFklyLwGGP+RPXno4yaix8KkM=;
 b=IbjylqUOxjZkchPi6d1Uak4DD7HAnOpwrrQl2SqAcucskkYx/+okT8NlnG29SdqQjIJGSRVY2N532hFHuJ8+3QTn/BZ8kXuDXlGORe6SDPspBiVyI/7TCYUI0HOblxAzkiGQdXzBz0AULw29VrIFZ4+up41Pwn+a+e8mLLmN1MEqAty0+VuwkZOJo+XI8x2w+8jQhi7cIvoIHDiJB2hK/5iCvcmyD5J+iOPfX1QxWvF1RX4cJUZMdZfMon5Cj6dc6fMsfJIkk//bipgR6rNF/i6s7MKVCu5ERizS9BODYL2lJrAZhAgd7qcZxAoyut4N4BDe+kroLnk1jq+tCghb1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+MDhn0vNOOdr9fDHPKFklyLwGGP+RPXno4yaix8KkM=;
 b=qvAMEWJ30SfOutERPcAAFlj6AzvtToOJgFFbLBvde5upEFHeF+uTaGQP8aREicxIgw99vBnslPY9QTfg06WVsbyYgkJq4B/MKJOlhcvjZ7xiV7xDhYFMgkOclkTPwVTzT/ZTAft/Qp33rkUjhsVRkZycu61JQQFoQOhgjc1jGjQ=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by IA0PR10MB6746.namprd10.prod.outlook.com (2603:10b6:208:43e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 15:54:20 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 15:54:20 +0000
Message-ID: <efa76c67-c85e-46e3-9a7b-e4c1cf457aa7@oracle.com>
Date: Mon, 4 Aug 2025 11:54:17 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm: hugetlb: convert to
 prep_account_new_hugetlb_folio()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-3-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20250802073107.2787975-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0223.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::18) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|IA0PR10MB6746:EE_
X-MS-Office365-Filtering-Correlation-Id: d65d201f-afe5-4a01-8423-08ddd36f2c92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VldSbEp5VVI3V0hmREN3TGU5SGxzZHJnbVhwTnIzR2F1VlZHZnQxK1A1bnhv?=
 =?utf-8?B?bHlDeUFKdGs5dnBqSCtSYU5zV25Nb0FKLzBzYTBBUit1U0tQNlo3UWZKbFJM?=
 =?utf-8?B?NFkyK3dyY1B1cTJ6QzAvNEdxRnJsb2hjdnVJMFFHT2JLUVE2SjA4TU9JSHNu?=
 =?utf-8?B?dG1qT3BtSmRmbU5LMmp3clhzUm9NZkhPZFhtQjZKWGhCaHIyMU9TalVkS091?=
 =?utf-8?B?OGZyRkdoY09mcDdTSk5kMWFVellNdEZXc1U3bk9vQTlJOThaaHM0eDVTa3FK?=
 =?utf-8?B?aU9DOVN3eXJ6UEtha2ZiMFFjNWdqZTRRbDZLSU1lUlR0UkxuTGJzbnJoZzdz?=
 =?utf-8?B?N2Nld253dmpCSFBIMWJ5NHRXMDBzVk4vdzhweUZuY3poV3h2TDR6Wnl6Y2xv?=
 =?utf-8?B?ZWlkYm1zVzcwMzFiTGxIN3R0YnJadXhJRU1vOUEyRHNlRHN5b2hobmczSVZH?=
 =?utf-8?B?VVNJdG5UZ0JwSXFzeFAxdEdxNEVZQkF5ZEc4M21MZ253NjJUU3pvYlRHbDMv?=
 =?utf-8?B?bEh3N2I1OFg3NktOc0lDT1pZSmhoYUFaUTdsN0FiQTA2a3dJQ3NqN3BUdXlR?=
 =?utf-8?B?WnJoeTF1alZKcmVBMjExZ2FmSnNaMTJSUEtFMDNVYkRhZU9FNEtzKzQ4Snpj?=
 =?utf-8?B?OVE4TzBMRzY3ZkpqQnF2NHJ5bmo5aWhNRnFRdWZ2YVRvZ3F6UU44R0hFbGdZ?=
 =?utf-8?B?ckh4NTV1MWlZcWVqVzJwYXNpQ2dhN3ZBNXJaSTh6czVEV1RVbE0wRHB4MnlT?=
 =?utf-8?B?bjdYTmx5aVhhWThGNkFCYklSNGJxQ1l6d2IyallLeVMyeHFrdUlHTGwrcExJ?=
 =?utf-8?B?ZkYrcjRGOW1yTFFicDgwckdkZnNHOEl1V0dlckRpOWlNQ3ZGbWt6WWRhZ0Fu?=
 =?utf-8?B?TDIycFVLQ1JHY1l0aE0wSWloSitPb1V2U042RVErUlRCQU1VRVlnVUhzT0FR?=
 =?utf-8?B?d2pWbVhRODhpdm9UU3duWkZUZWNCYW9MS0tQNzAzYW5RbGdUc2R1MjhjMHd2?=
 =?utf-8?B?ZUtDQjNRZVpMV3pvakVRTFB3ckhkdHBwL29UeThPbWQ3U2lVd3pUa0NkTzA0?=
 =?utf-8?B?dTNId25RcGhTT2hDaTZwYW1PTitSTlJ0VXp0V3dyRHRqNGovZ0J2N0tQRmJ0?=
 =?utf-8?B?YVo5VFlOaEQwTEdJVktSNm5aUTlKY2hieTNpL0hybU5YbFROMnIrRGZ0ak94?=
 =?utf-8?B?VUIreTFocUtRRTUvMGxQR015eGdYTEFtbnFWZkJXemQ5VUVGMHFFNDVXaG1Q?=
 =?utf-8?B?RktLWVlyTU9ab3g4U1hWdXZXSW9tWTRicHVzdTJSN3lDU0MxM1g1dm1URDZj?=
 =?utf-8?B?VlZIYW8wb0srVDdESktBeCtQT0lkMW9aNG9pK2FRbStPYk94T0J4U3hQaXcv?=
 =?utf-8?B?eGhGa1VpMHdvNFFUdktCZ2ZvSjNqVUlicEJiRXBDMmgxaHNKWkE2bCtWZDZj?=
 =?utf-8?B?d2ZyWUpZNHRweVVIVEFWN2NJQ0hVaVk5WXVuUW13QVNaZGUvT1NpbGdTNzdy?=
 =?utf-8?B?Q0NOV1NpL3hHU3JCTkFYVXhoYkxWZUxQVHM2K1ZNaVJjQi90dHFWUk1ZZDZN?=
 =?utf-8?B?M3ZML2FFTnU0V3lrZFA2ajFmT0piWHdrVGN1MmxTcmxkWk5nZVVrTUNlTUpl?=
 =?utf-8?B?Rkw5TWxId3YraW1zbEVjK25zaXNGVzNUeUYzNmVQeDMweWUyS0lGM3R5M0pS?=
 =?utf-8?B?VUFyVU9FZ0xCR1VOQ2tDMHRkanVUNDZDZDk4NVFqVkYyOXZ6QWk0eGVWNWUr?=
 =?utf-8?B?aHlVNDBxWjNkNEhBc0hCUjdUbENjMnZJVnQ3RndKUkFJT1QwaFkvdXRObWhr?=
 =?utf-8?B?SDdWL1QxMWtBR2NxQW9ERHoxREtsQ2xkUjBaUDVRaUtpbEJvd3BGdjd1a3o5?=
 =?utf-8?B?QU8zV01NQmMwZzlDUG9iWk4wMVRNbGFzblJWOWw2M1I4OXZuY2FJZ2lUS0V6?=
 =?utf-8?Q?vc7huQ2Jc4Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3FBZEJtZk5PeXhlc1dCTzJERWRCMHlFMXR1QUtqMVRKMk9OQzJTMER4K0JB?=
 =?utf-8?B?TDJacVdPSWlwcUE4RU10blpOUnRwcGFob256cnB5N2h4Q1l1QkordkZSeXQr?=
 =?utf-8?B?NGNYSjhTRTh4cjQyYWc3UkdwM2o3eDRKdnZxVWdzKzQ2eEZyWlJGNjBBcUls?=
 =?utf-8?B?b3Yzc0ZCUHpuV1BZVEhkWWwvUlNLbFNUb0dNRXNyRFQvMTQvWFAvb0FtUlVL?=
 =?utf-8?B?aHYxbjFsRTUyVVpwTzA0R0lpalVuKyt3MG9TanQxRFVmdE41cjlyVVg3WlNK?=
 =?utf-8?B?bVl2Q0lGRng0cUpBSVFEaHYvYzIyWW5wSjNISCtZVE5vSmVrZW9XcytUOVlt?=
 =?utf-8?B?ODRQNTJvNkpGeE5DRjliaTl4Qm5mdGxHdG83QVp3c1N0NFlVSzdUU3haRit1?=
 =?utf-8?B?V2xETWNtOXFkRHl5a0ZtbWtyU1VDS1Q1UEpOd0twV0xrN3E5dUxiMTg3TS9s?=
 =?utf-8?B?M214dSs1MnNuamRsOC9hcFdodEdiQzhkZkU5Y1RiQkxPT3NrdlhKN2dZejFK?=
 =?utf-8?B?QkJJaVFkUDFnNTE4MjcvSEFNU00zVUxsNi9iNHREdkNnV0NXZ3FGWDg1Y2J4?=
 =?utf-8?B?OFBPcEdXeElTMTlwNzl4b3gxL3hZTXJhMEtVcURtalFUcGdKOWxCYmx5NWNI?=
 =?utf-8?B?cG8wZDhhdXdTZHVkWWtNdFA3UzR5V1Q5UnlCQmllV0dqK2VTbkhGS1hBbHkw?=
 =?utf-8?B?Yk1HMUVUTGpTYTh5dVlqUWV1QVpqbCtCR0dIMjZ1eDY4bkc3MFhxcnFjcnhG?=
 =?utf-8?B?RHpPZ3JLaXFxTXZnOUYzcVFpd3NhL1prazNwU2NWK0lYSFFBT3ZZbFJjei96?=
 =?utf-8?B?Q1lianhxOXN6UFV5T2I4VHd4TUFJcmVuUkF5V2ZBUXZGaWhiK3F4YUhPM0ph?=
 =?utf-8?B?VzVBYlNhdXJ3RVJWcUxXeVNMa3R4VllEQzBRUTE1ZVNhRlkrZzBjODYyeFk2?=
 =?utf-8?B?dGhKZ2JadS9lS0RrMmRrTE9QYnd3MXBlK2VNVCs1SUJZNFhxSEtPMHhPWE1B?=
 =?utf-8?B?bmI1ZGFtSnNycE1IbURpZUgwUHp2SDNHNlJiWDV0cnZ0K1VER3g4RWVQOUdw?=
 =?utf-8?B?eGN4bXF0d2J4WW1rR01IbThtVHFwdjk4R3QrbFBzWktYeW1mbXJQNkxLc0RG?=
 =?utf-8?B?ZmlrMy9SWG41bFNhcTBGYVA2M0lrbzhFaXhyRFNhbXArQ2pDRFQ2dnU4RmUr?=
 =?utf-8?B?OUd4anlFK3JaSXFrcCtQam9Va0Q5UG10NEJLeklreU1GRUQ2K2pGSkxOVEcv?=
 =?utf-8?B?UzZMNDBqQStDMlpranVXbHVKZG9qRTZyOEFiVE5YOHNxVVVKTHdQcTZ0WE1z?=
 =?utf-8?B?ZitQTXl0WGpDc2hMNlo1cGFtd2t1Q3ptNm1tYjRKcnlyaEZXdEhlZHkwZEJ4?=
 =?utf-8?B?dFBmZk44UkZuaEwzQXVDSjNPMmVUUUxGRjY3QlRvcWVUdlJCU3kxMjJuZ1Rh?=
 =?utf-8?B?T083bmJPT2w0ZGNJUDVYbkFIWFFZbjRGVFRCcDdLQmVPMW51UzVjZnU0MFJ6?=
 =?utf-8?B?dzgxMDNmVkV1TjYvdEhRYkFoTkdyaTdtUnJ3U3A0V2NsdjdwVGpocVJPNERT?=
 =?utf-8?B?TWpraEZldWt4YkRvQldrWGtnbXdvMHZpRHdKUGlXZHBreHFLQWp1NFY5RlpO?=
 =?utf-8?B?UzRFR3ZSRzc3L1I2UnFMNVQrcWJEYVRBZnA1eTh0V2thZnZCRlZIZ3VGQ3A5?=
 =?utf-8?B?TnpEZWFGWVY2blY3Y0NHWGcrNEFvSHBhMFpZZnJDdXN6SG1WSW45WXVxVVQ3?=
 =?utf-8?B?QXdBWlFScDhPaXllai9iMFV1dmdhaDRXSzZQNUZRYTd5bk90c0ZUWFJzMDY0?=
 =?utf-8?B?UjJRWFdjRWVrYzFTNktUV05tQXlqVU9PajVLZDZyUytVWEcvVFNTcjcvUU5Q?=
 =?utf-8?B?VkVXTjl2bTVvb3F2SVN4TkNEQ29lYmdibS96eVprTHpBdUNhcmZlaHVWM1pa?=
 =?utf-8?B?OGRIek9uNitrZnAwdFA3OTZmeVBVS0dqRW9KcG9mKzVJcWlzV0tKd3pmWlhR?=
 =?utf-8?B?UFNHRzd0SWZKK0RsRHNNbjJFa2w0a2tybzF5djU5dHZhcmd1ai9JWC9ZdGxN?=
 =?utf-8?B?V3ZKa2dkUDEwamgwTHVPSUhxc29wRndhSlNaODE0N0xiZk5JNFZSK2FneE8y?=
 =?utf-8?B?dFJZV2J0MkVLOStZekUxZ1FrQTJBQTVSN2dyN29WcHZvOG5UdVhINkJlTk9q?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tqC6cO7/4CHmfRKCDHMjz0q4FqH8jPEpW7qOiieLLb10YS6rk5B306wVY3UeM4RwkUE4NfxXTTnYGhSqNA0QWAnNFCM3Z9VVXaU831Sr3G996qjCihVU88o/dp8JcFkmQSLlzQ5pLzERRt73K+3qtkmxCsQuQQfii5whgrCARyo7s9/cLY61Yh+S1ag6ollXmudKldGXycvQVaBDV4i53x9ZJL4YJmsK3s30PdvkuQ5QN+WG9y3zfsV9j9qvgBwmcZZBGBXASmnQOEn+u4peN99KJgtoJE+YBFwc3k09CNFB2U8aXK3F2fBFho+o5UYOFy+pn8mtbf7+EqBp5zWHzhb+x1IF5KppyHKyUW16sD6XffQ3S8i0DV5cPGz+Sr8T3iT6pcPTz17TW3HxwvaLIfvpusIXZE4Vx5xbtBT21KMOsYLv3haz4+nRHBOtCOGETuErGnfHuYSohcoW/WJiobXHdMdpr1Te2vEAVqr0WecMP7zQ92nwK+sQ+VN/wJmeif1BHDTLytHlWvvg47iK19amrr9M4nAySpZWlxpy8D7tGZiVTylpvfLwoXy3SKF3ZD7xD9+AonybgHXzFCrqEi6DGl0uLdEo9jAq+4Apzs8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d65d201f-afe5-4a01-8423-08ddd36f2c92
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 15:54:20.0977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qw7oYqYmMNaiGsLcB5WOKxXaOc7sQQNUFwcrzqEQoTyJlY/5xj2ytQjCAtB4EIZ384JrklCP347mBwVAvqs57WAPUh8vGy5wrp/mr8t0hiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6746
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_06,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040087
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA4NyBTYWx0ZWRfX+3VNY5LiD9Jx
 mET09m2cc42hiApQP9/uVKyNbTJGIGhxsWRenAJyVVq6R/se4OpYkh/w58rGKyVpUe3D4QD64UC
 2Uw/TmyAk+4gmYHEnVss3R6Qyc7ma1nVvcLjtXSNdfGDUYZ1x5QzhvckFInbrIgTwC7LlezKeO+
 5qmbF0bUnkYgUNYZuDbgfbxBGw69KJWIzbAu7AFYOVUMqmo2sQudwrrSOOCRMgFn8DP8/9h9kRU
 Mw9DCeE2GF0xUkMLRDQBX4oNcQb0hcS8agjouESHQZ1wd0kmpArphM6fuO+wPsXQVa8YE4LVy4t
 zYoq5nPrA0Mu5CrSZPlhJSqRqWlT+GTCUFv2TntjF6PuPtsG2EfC9NkCUt4C0b2oB+ne3EntPf9
 uhj0xE9x0Nn4l2FEn4kBnVXjvG64+FyFWnR4VJSn9izkKSpWe8U3p2XPCajHKrQywalyQn4u
X-Proofpoint-GUID: 3kgeC5RDio2ueeVfd_5A7G7pqYoBZQi9
X-Proofpoint-ORIG-GUID: 3kgeC5RDio2ueeVfd_5A7G7pqYoBZQi9
X-Authority-Analysis: v=2.4 cv=VMvdn8PX c=1 sm=1 tr=0 ts=6890d7af cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=QTsU5mMKaPQ9sp0_GrgA:9 a=QEXdDO2ut3YA:10
X-Rspamd-Queue-Id: 40ACE140004
X-Stat-Signature: w6ffr1tbq7z7aw8moog1gfi1pburdafu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754322874-50238
X-HE-Meta: U2FsdGVkX1+vL4T2ZL11ra+h0Ojx/LYulsarOS/j6GXAygvFnGQqvLw6AwWIlNoyEP98UxLMYaMAxJkR8u6jeKDFV2WfWuyn0ZVzcU0rguGm6kiuBrePjPNhARgP2p99ekBWsic2wx5goDit+mGlzNbSIfOoVrqfIj/dTOO1vaWxtG0t9yDImogHP/asJ9oOTWQxXzJHD4EtQFsJ1+VHqYEcXgZuQhLoaJq1CCE6jlPqaGGpFKYCYlJ5lOib17tUvYwbU571+eGoNtjT5dN0ExzVnIBxvQckFMKZ+0R8FPuo4L1rKbOR7pi/27rQ+aFokmV2EB9m7DrDh7F+3EDZJe9ewveR6L4YomDfyZ5oTeVaE1N2LdUfAB7LFgay2dWceC3W/t4cFFJWPOAS3gHpAB22IDApg1EqZHDYZR/GvYASL74vUVWWVFmyr+MNX+i+X799WFtc0qL/rnZKianr8vaG4cxyzjg/QfXHlmd5dqOa/Nz6F6M0Yh6RVEaHBhEblnZwc7wzGKy7MDOGq7THeiopEtTxeaj2D0US2NHPNtze6FIWVRqWOX84rJyt0IOvOqImwqDSATlgzKZze94lDxeX4ObwSrt/0e4T7JnOgO5VYhPaSxEe3DIe7dzgkX+l+Pq3qW8q7GDQ5ixWQ8wMf5R86lrcfrnjwjA8YGf1ChVLZYO8w34AeW6rMBzvTcmBpwLdbFmOBpGqA3Zt6Jvl82rMPje2SK4zQoVzfxGYIdkN4sbZk5Up5ruRKzw5vZ3y17B212SVlNKs1NHCsUNwQh/M4jwJUiw76AuuJ0mRJv49fwlLJZWVFWCFiTJ4GQZFhoQ0hliHZ4Beu0teOtFenD8ciNKFObKJHdYM96hl4iECHhptWfyoIqxbJM+l4wdpMi6l9mxSafJrsDkrm7437Yk+q4Pim9kkdNooHTtM0CBY1yRAU3Do/om2m2BskGH6ljW0Ky6JZP7MlZnyBY/
 rgbs3q0T
 D60nroNF3oNNBIzQ2sXr91sWjU8HxoEEuS8TQeHoou1znGlpwTJPqK1XbBI27jmP1cNTX/C9eM2OX8WkPnnMu6VJuz54kMEHngXfZnOKEOgyArgeKzNP31B9VINagkI282IMJ2ztw1ENX87bbKtMnv3n5KTniSX+/Yps/TutTpi4UFCaVyj/K89t+CoOWJ/VOdoIuFufTmpQ3egVQRF83+6DKnfFXa+DDEn8PPFbi2Zp8JS7zLdv6jpNkuIf9rt0jyr5h4Gct06Ac7bVX45MXCr1dh8fxJ4eQV+ZEH8B60l1T7gTuV96/yUOF0zQNcEiwyPlWyouNAv3WXeEpgvfee0AQ4NDWvLAqs7hjNgNdvdhC1Aw51hKa+YheWVPtMRY5tK06RSdMhP/p2pGYSliqZzODxw7VcXwIa5wyKGOEHBEH8LsOffzjgVAiaeuyqTLpvak2WsbDznEOLxdfpLLP/tWD13MX1cCUtly9RSQiEjwk431/qys0E/WziZSxc/ajXEN9YQsZHwDOF0+aixjX5Ohhe2MjzsVYCjmxvjci10+OhtZiHws9X4FHzmKHa7r1sPVLrEJFRQB/3ySSmHBhZhtTwyHsT7xNftAakuov2oE5h4h4BzoxzllX/E7GJJws0KJ13Ys1X/kAC5T+lg1SNWCT3IMJUc2LB9NutVmCrdMCdt4b903yG32kU7ZR1MggiERlxyWVjo0zkiNQwulk93VsFNBtw3myMoqaYl7tmIuC10QV98jpQvSWBnlERDETrPgTDnL4vvUUPFNwAhDB/rEUYbFEdEqHGB6/kToilhxavYd9SdxUmuI1+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/25 3:31 AM, Kefeng Wang wrote:
> In order to avoid the wrong nid passed into the account, it's better
> to move folio_nid() into prep_account_new_hugetlb_folio().
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> ---
>   mm/hugetlb.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 5b4c19e7a5f7..afec5a6a8aca 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1890,11 +1890,11 @@ void free_huge_folio(struct folio *folio)
>   /*
>    * Must be called with the hugetlb lock held
>    */
> -static void __prep_account_new_huge_page(struct hstate *h, int nid)
> +static void prep_account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
>   {
>   	lockdep_assert_held(&hugetlb_lock);
>   	h->nr_huge_pages++;
> -	h->nr_huge_pages_node[nid]++;
> +	h->nr_huge_pages_node[folio_nid(folio)]++;
>   }
>   
>   static void init_new_hugetlb_folio(struct hstate *h, struct folio *folio)
> @@ -2020,7 +2020,7 @@ static void prep_and_add_allocated_folios(struct hstate *h,
>   	/* Add all new pool pages to free lists in one lock cycle */
>   	spin_lock_irqsave(&hugetlb_lock, flags);
>   	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
> -		__prep_account_new_huge_page(h, folio_nid(folio));
> +		prep_account_new_hugetlb_folio(h, folio);
>   		enqueue_hugetlb_folio(h, folio);
>   	}
>   	spin_unlock_irqrestore(&hugetlb_lock, flags);
> @@ -2232,7 +2232,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
>   	 * as surplus_pages, otherwise it might confuse
>   	 * persistent_huge_pages() momentarily.
>   	 */
> -	__prep_account_new_huge_page(h, folio_nid(folio));
> +	prep_account_new_hugetlb_folio(h, folio);
>   
>   	/*
>   	 * We could have raced with the pool size change.
> @@ -2270,7 +2270,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
>   		return NULL;
>   
>   	spin_lock_irq(&hugetlb_lock);
> -	__prep_account_new_huge_page(h, folio_nid(folio));
> +	prep_account_new_hugetlb_folio(h, folio);
>   	spin_unlock_irq(&hugetlb_lock);
>   
>   	/* fresh huge pages are frozen */
> @@ -2829,7 +2829,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
>   		/*
>   		 * Ok, old_folio is still a genuine free hugepage. Remove it from
>   		 * the freelist and decrease the counters. These will be
> -		 * incremented again when calling __prep_account_new_huge_page()
> +		 * incremented again when calling prep_account_new_hugetlb_folio()
>   		 * and enqueue_hugetlb_folio() for new_folio. The counters will
>   		 * remain stable since this happens under the lock.
>   		 */
> @@ -2839,7 +2839,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
>   		 * Ref count on new_folio is already zero as it was dropped
>   		 * earlier.  It can be directly added to the pool free list.
>   		 */
> -		__prep_account_new_huge_page(h, nid);
> +		prep_account_new_hugetlb_folio(h, new_folio);
>   		enqueue_hugetlb_folio(h, new_folio);
>   
>   		/*
> @@ -3309,7 +3309,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
>   		hugetlb_bootmem_init_migratetype(folio, h);
>   		/* Subdivide locks to achieve better parallel performance */
>   		spin_lock_irqsave(&hugetlb_lock, flags);
> -		__prep_account_new_huge_page(h, folio_nid(folio));
> +		prep_account_new_hugetlb_folio(h, folio);
>   		enqueue_hugetlb_folio(h, folio);
>   		spin_unlock_irqrestore(&hugetlb_lock, flags);
>   	}


