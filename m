Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF47EE67811
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 18:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BEE06B0088; Mon, 22 Dec 2025 13:42:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D396B0089; Mon, 22 Dec 2025 13:42:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66E56B008A; Mon, 22 Dec 2025 13:42:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CF4586B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:42:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53B85C04DE
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 18:42:27 +0000 (UTC)
X-FDA: 84247977534.05.835589D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id BC2D140002
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 18:42:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GI5n6jQ5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="ZDY/ysNT";
	spf=pass (imf04.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766428944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hv0iTR9hG9mdsPgP+ksqeF02VrUYvYFP5rdU8BV5smY=;
	b=OSp2xvwB9OnHopyBAOJJMusyrmpgiT2QXOV9jGdhe+mMvtBM2skiFGD86GT2V6ZM7T3naH
	H1l63dOEyk2xfGeKz3FAYhVIu7d1ABooXMBZvl5DwEDlj9oKOfeAdQ5Rzb6wx4HJgr3Pyz
	sFiKIpLyzpm9zC5VI2hDLniu+kHvKoA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GI5n6jQ5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="ZDY/ysNT";
	spf=pass (imf04.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766428944; a=rsa-sha256;
	cv=pass;
	b=M9G8C/E0jl+7KFW8VSSExOpFUzZJX7MBiPtEHC2a3p+ViO0zum+8cHk2WTCQ9CJdkKwoqh
	mD0uf2AvZr/A/kUxdaSOaLuKo7Yylv5JAKAcBg2BXVN9MUVfaxO5WNLAGuf+QsdyCKOzXf
	jnbjAeouN4X2xOIKUQ8e8ydLjHdAywY=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMHQYbE2549274;
	Mon, 22 Dec 2025 18:42:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hv0iTR9hG9mdsPgP+ksqeF02VrUYvYFP5rdU8BV5smY=; b=
	GI5n6jQ5mCBlQ1K/I8xmeSmP657yn76lU2Ys0t4WzzuUIot2bg9MfKwWQbfwpji2
	R6p9kxXiOVG1KuUilv7uhblyDK/QE1g2DaRUg4e37PO6boL0PLmU/mrHX+rxpsNT
	m/u3V03QXtpzkuj6/mJRDaUDdV12v6seqf+z98iZe7faVLbgic6yBLA9xMfEScDm
	fK+tjVEgq22CPJjfpDtjc+Pe/KhvupqDzbfRahsvw21WodqMNVvvZMsA5mkZnk5j
	m0lqu/64fI0+34rlndGDPQU8RqaSP3hoUoMx3WNKmaEXoFSQZOpQDfZsf0Y8HNeC
	/nzOrsNEIR//LcbpebueMw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b7acvg4d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 18:42:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMIZvGN024440;
	Mon, 22 Dec 2025 18:42:10 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010056.outbound.protection.outlook.com [52.101.46.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b5j8bmy75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 18:42:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tSl1bQG4kW2KGNHPPt3EZvNwMdAuTf/yXyKyyvidsiuWPV7BxdfjGLUAv4PIMv1G53KH//5IXD51+ytXwkGeQIYPPFJCLt7kPdpkV5JAqG6dlJqUZUGETTsk9Pzpr3CHwQIHLftiNjkLC5A/HdRLIkqf6pXwzitrnqCbqyGDUdanCjCNoPKy/zrFwciSkuQ/y3tpU8sEVpWFZRBVv+5IDUnczxqKM3kdI907rDbB5PT0iVWYtdq5nc5FiFbtNC7dNyNg3RLsxa9NZdsZw7dyEk876Uxs6bCTNIBmvtggzADl9ASceYAwTH6KIx42k/I+wKihjCZH2m0dGNQXWP9rRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hv0iTR9hG9mdsPgP+ksqeF02VrUYvYFP5rdU8BV5smY=;
 b=bSKsaKeVo5RPrBevi8ecoiI2M/mxO+vnQqhhLzoE4/74WulA8dmWl385kuHyQP6fBFEPW9y+og+nzPLiX6b0gLjWwWIJbGds3mJcNb1+Fhh2INIJ+1JQ7l+R+9ybyXyptpidznrxiWpcsZ1L/s4Us6tQYOnFALaVrEMErVfav+dvVu37KMTWtweWJDPSAAqrEyFFEQPF3G3WZNMMaBrAEY0wHfiW4PE0yt3OY1QNvLY5Y3T8Jji2WZ7Q0jtrS6RtWZjr/Uj0TUtoPwe00YsrcS2Mx6bxqg2Rw4rFWQVz05pEQ0fz82rEzqAyhIBtB6vgoaf80BvCkNY4VlImZJ5crQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hv0iTR9hG9mdsPgP+ksqeF02VrUYvYFP5rdU8BV5smY=;
 b=ZDY/ysNTZsCOAn5pSbqMxGBs2f+i/aqi6T1QK6tb6FFP1BOqPhEJXkIbq2zFmV6dbf/+MUam5lucPdChQqu/0OoQZec917SI1TZflJlgoXm212FlbEu+3uA6ocRAwAVq881SiX6uyuo7Kq2TmfcJitppbSAq1iL4IojCrf8D7RM=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 LV3PR10MB7724.namprd10.prod.outlook.com (2603:10b6:408:1b4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.11; Mon, 22 Dec 2025 18:42:06 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.20.9434.009; Mon, 22 Dec 2025
 18:42:06 +0000
Message-ID: <d441011b-fe8e-46d3-a67b-6971a380b3cd@oracle.com>
Date: Mon, 22 Dec 2025 10:42:02 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: teach kill_accessing_process to accept
 hugetlb tail page pfn
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, muchun.song@linux.dev,
        osalvador@suse.de, linmiaohe@huawei.com, jiaqiyan@google.com,
        william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251219062819.2499399-1-jane.chu@oracle.com>
 <8b8dd99e-78b8-4786-a175-6131eb6b7c3e@kernel.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <8b8dd99e-78b8-4786-a175-6131eb6b7c3e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::11) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|LV3PR10MB7724:EE_
X-MS-Office365-Filtering-Correlation-Id: 3456f6f7-7ef0-4a80-deb1-08de4189ce4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWR6NkxCRyt4Z2h4VmN0NG1BTHdDZ0RFYWIzN2F1b1kwM2hHK05EOU9oQkVF?=
 =?utf-8?B?SENSNUk3N1U3bVAyQlNQeXJxRStGbk80UzhmZkVIemRhN3hwdmM2WWdRR2ZQ?=
 =?utf-8?B?V3IwWTNvNVlDaHNPWG13djM1ZlNHR0Nvc0FxZnFnVVFrbUE3TU5EOEJrMVJz?=
 =?utf-8?B?ZVdDMC9qdzZERXJicVUvaG9QSVREbG11dVNWcUtOVWtsU1BRVE83WVFQbzRS?=
 =?utf-8?B?WEp6b2o4SDM0NDhCL1VINHNlTVA5bEladEpOSzdLWjF1Uk1velk5ZEFBUWYy?=
 =?utf-8?B?TVNjbkdZZkpRazVlY3F2Y1Y0UUFlRWx5aEh4RXVtZDZSUXA0VVAwaVZDUld3?=
 =?utf-8?B?eEtESHVQeENLNW12eTRqWmJCUVpvUm0vS2NrNDJrY0REMGFOclBoVXRqWE10?=
 =?utf-8?B?Z3dYdkhBdmJqQTh0dHYxVkVvWFBhL3RCdWl6SkxqOHFVQWZ6S2l6YVdCdDdE?=
 =?utf-8?B?RklDRGQ2a0lVeTFRQUcvZHRjRTFSTEJwUURqT29GVUcyRy93aGpnTlVFa01y?=
 =?utf-8?B?NWY4SGFtL3ZLaU4vRk52bEtEb1laY0VKS1kxZklQUkF2VFlUdnRBYmJ0TmJH?=
 =?utf-8?B?M3FvdkViNURQK0g0NVNsbngzQ2wwVkdaTlBBc3hpeEg2ZGRSY3Z0Z29Oa1Bs?=
 =?utf-8?B?aHFRVEFKUkUwajB3RWlNUkdsek1sOEYrNkZMVTAwbzVRNCs1Tng1Q29wVkM3?=
 =?utf-8?B?SjlVVmw3TUFaQ2FyYzFVeTVlUGwxZDRZdVFPVHRyUUhGdjNlTzNmQXRBV1dZ?=
 =?utf-8?B?eUFlYnU2UTdRT0Rhd3RoSGpYUWhLOHowMzJRbHlEZFVTTnk4eEtFaGdxa2l2?=
 =?utf-8?B?Y0RxaXhUazRnd2pCa2wzb3ZabGM5SEJ6cC9kNUhmTEpBOEdXSHd4aTczZjlS?=
 =?utf-8?B?Z1N2Vm0zTEZCWjNjb0RHMFNYZGdBYlhLQTFRUFQ3RCsyNklhTVBZOHJtOUNR?=
 =?utf-8?B?T2VUZGtjNEtNNUhsb3MweVJZWVZjblNsMUxsaVZ0eHhEOHl0cWM5ZENhYVpB?=
 =?utf-8?B?NjA2WDZTeFNZd1lNV2UrNzl1eVE4cGlhNFEwby9IUTNLRDJyR2x0MENPQlZM?=
 =?utf-8?B?TlZGZndmZWJGWXlIZ2pMZTUzWXNrckJXRnZRMmtCamJ4L0N4TVhuODFrdzN1?=
 =?utf-8?B?SlVZNHdBZ1dac3lCWi9scnF2elpSQ1BmQlBIWEtxUitCRGZ5M0dmS1JaVUZV?=
 =?utf-8?B?TlhaY3RkUkkrM3RuY0ZIL0VVcmVOS29GZUJPeWoyNGRaa2dWNllYbXM5b295?=
 =?utf-8?B?eXZsalJXdGtncnY3UlBVS3JIYjBieVVMRnZYUVVBYkljRUtQZzVGNit1eXpK?=
 =?utf-8?B?b3V2M3VIdk9wL0pkSEUvNjVtU0RVbVhJd0RyTlZGa0IwQTUxSWZDTUgvS0JN?=
 =?utf-8?B?T0tZM2JKNVhEZGM4QVk0bWFwLzYyQ2d3T2tOc0IvKzV5eXpnYW1UaDB2MGdy?=
 =?utf-8?B?VTNsbWgydU91TTBKbm50aC9pMFBBWld4Q09BSnRacnZvWGhPeTdSeTcvRklt?=
 =?utf-8?B?SXJUTGt0VHVLdjlNMlEzci8rbkVIbUFUS1VjdFBGRjlGSEFNeTZ6eHFhVjNu?=
 =?utf-8?B?Q2lhS1ZxcXoyWjBWNTJMdk5wTm9zUlYxT3dpUTVuSUdhWEFlUWhMSm5ZRzRz?=
 =?utf-8?B?QkNBNlRSZTJrWTQ3eFQ3eTZYWW1SeDF4UGpJdUUrU292dHVrdWdtczhvZjhv?=
 =?utf-8?B?RmkrL0dsS3lCOUpvZlowVWcxcmJoNE5KbUJ6OEV6Mi9WWUp1dU44Q3NZZUM3?=
 =?utf-8?B?blJSZENVWjhvR0ppbHJLK1VzSDlJb1Y5V2lKTXlCZkJ6SkxlMDdtY2d0RCtM?=
 =?utf-8?B?N0J2UERLWFBSdWFVQkZEZ3dZcDdxakdMa2NnWEc2b1BRVmEwQ2xpcEJMcXpC?=
 =?utf-8?B?WlZEMDRaNWZjVGV4T2ZTK2l6SytXS08ySG1rYUc1NkRweDNHL1J6MUtmcVBY?=
 =?utf-8?B?ME1ON2J3NlBHYzlJVlRVRUk5RDA5a1lQcWNPcEozTUpQcnZYdVprYVc4SVNn?=
 =?utf-8?Q?CiEd5qgmo1wEX59f8M4JpWTX6bYCfY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1A5YTZhOEQweDVTNmtCTlRVOXMxM2RoUVhUWlBWV1h4cHR3a2JuMnFGSFhC?=
 =?utf-8?B?WnlmVklXbHRrU2dCa2tTUmlRRlpKbDQxbCtYTm81cVlmeEtJSW9RL3dMaW1l?=
 =?utf-8?B?Q1MzTjRvWHJlSmxKWkFNdldzWlFudk5PR0FFbVo1TXFIaUFCRzcxcHdMS3dj?=
 =?utf-8?B?SG90VUF3ZVdUYzMrMDBMdEFxL2ZkTHZmc0FTV2I0Z3BpUjJRaG1vbktIekR5?=
 =?utf-8?B?UmczR0ZHZFJkNU56YW93dkFGbnlnNkhFRzFsbzNzYm1lSU1xRTFmRi9VajNO?=
 =?utf-8?B?c3N5YjFtdldIeUdXVGRGU3BsMFkyQkV2c1NDM0g2U0tPRE5tS2ZLQ1E0T0FC?=
 =?utf-8?B?N3VnMEhFNUNpTi8rS3R2b25PYnFlTG82NGF0eGZVU0Z6YVVkcG9oTG96bklK?=
 =?utf-8?B?NHprZGZMMExVNnZ4Zzg4R2h2a245SzdPQ05PSHJXQUYyMEUyclMxMU5GL281?=
 =?utf-8?B?YUEzbXprWEp6dUVxbHdSVXdSbXB0MWhBZ1dTSWpmdk84Vm85cE1Za0EyN3NR?=
 =?utf-8?B?L3BpTitlZzJ3MkU2Q2VCYkpaNGRMRXorUUl5L2FjSERhUnpHY0R1ZEJ3MjJp?=
 =?utf-8?B?bVpVc05xNjBsS2t2MnM5YmN1YUFGeVZDQk50ci9zaC8zVHZQWWtGMExLdnZh?=
 =?utf-8?B?TmVoc0ltcXdsSEVXbEsyZTg5cnhoanZxMzZ5UkJqbXBmaWdTOEVoTm9iM0hX?=
 =?utf-8?B?NnNVMzhJRVBla0RBNDA4V3JSWU5xOXNianV6Tyt4enhGSDh2eXh5dEZycXA5?=
 =?utf-8?B?ZmZQcE44aWRZVlBxcWdZL2NHaWdDQzJNWnZBOWltZ0pWbFVMcTN0QmNGeUlj?=
 =?utf-8?B?eGZXOW54TGNLSVdKcGtmSzNxUFYrR0N6c0JpbS9rbWpqUFBHRmVJZWdrSktY?=
 =?utf-8?B?TlVYQWdDeXM3ZzNYNThJU3MrKzluTTYyeCsyTVBnQVZJUDJqRG9BcjlRQzAx?=
 =?utf-8?B?NnBjUG9vb0hQUmFLTFBWUjc3bzFZNTMrbHdnSTNJN1BmVUx5SUo1QkVDSjhU?=
 =?utf-8?B?QWw1TUpxaElIbVpabDM5VEYyYnl3ekw4dzhlK3lLVTVNYmlLWjNTK2srTWV0?=
 =?utf-8?B?M1Y2OVJlYi9Db2lET1FmSmtuSmU1dTBSbFhrZDFGd2UzT09vVE9FT3hzemsx?=
 =?utf-8?B?VmthNXEraGh3aUNrVWdnYXBpUXNHcDh4RERiZXRSTEFPbWZwbW5XOTZ1eVNO?=
 =?utf-8?B?L09iUk9ZS09aUEtaVVhrNVMxeWhwbEtVM1Y1bSs5QTVsYmdFRDJHRTlCSHpv?=
 =?utf-8?B?czMrY1dFS2hWWnNZQUlweHVubzdGZDNDaEF3UjgxMGJSSVZxQXZIcHl3SUhj?=
 =?utf-8?B?alpiQzdyeVltNlQ3cmIyWjkwRm9SSHVSUk5oT0VrcUxDUGFQQWgvQyswQ1Br?=
 =?utf-8?B?T3l3aDJWcmptRldZc2pxb3hBWVFoRFdKSzhibml6QUFyNEhJaFFuQnZTd1pY?=
 =?utf-8?B?WXZhRkxCcWM2MXpHaHYwWkFmTmxKUEtqRTNUY1hYWXVOVzh5TUdGeFB4dmV0?=
 =?utf-8?B?RFZzZWZDNStTNXp3Z2NaOGplNUN6K05OT2hVc0RUaFd1aEJMck92bllITW5N?=
 =?utf-8?B?YjhDM1BqRTFUK0lFNUltTDFibU1sSis1YVpUL280SStHR0hkZkw4M1g4eGJw?=
 =?utf-8?B?NUlPZGxqQkpCaDA4NlFTbVVqWjRRMitmT1c1KzFWMkN6eS84ZEpXSUo2MHpC?=
 =?utf-8?B?RW5jTUkzcXlVZlhLNStvQ3ZXNnRYd0RnSjAzMkJWZW1oWEkyaXZna0RPWkZK?=
 =?utf-8?B?cFpKZlpHYWdKb0JqOElwWGVqRTkyd1pJVFJOM1F6b1pUZTkvaUR5L1RFeFhk?=
 =?utf-8?B?emUvYkNwMHk3UFRRRFN6MkUrSjdWbDhZZHptL0RHeHdBK0NmNGpUbHR3SGRm?=
 =?utf-8?B?TitmK2tEU1dHcER5cTNqaXJCTldtdEcwMHB6bTJLM0lWOXpJaVFocWcrYktO?=
 =?utf-8?B?RnZiTU51S0lmQWh4YnNCQTBtbTM3YnNidmEyc1RodUpQSUlyNUN3ejhJM0x0?=
 =?utf-8?B?Sk9hVjVQMEUvK0RORUZEV3ZhUTBSRzlHaXhJdVRwRVVWREpyMkpuNUx4RWZC?=
 =?utf-8?B?ODhRNzJqS2RWSnZOUjd3WDdHQUJVMit6ZFZYS3JBLzhCejhoTzRKOWdaTWRh?=
 =?utf-8?B?cEVkZzdTUXlaMkdmWmJXRlZCL2g5akp5bGlCUFZMeWY5U2VUSlJiR1NUQ3l4?=
 =?utf-8?B?dkYzVEZFTGtiQU82ZThmK1ExYVNBdG40dkVrRDFOOFNvN2FCVmYrU3NFYnQv?=
 =?utf-8?B?eDlXQzdHeFc3NHoyczVwM01YUlROVDVyZ1JKUDE5bVNGZUUxQnlZSmFMUzRN?=
 =?utf-8?B?akh5TXhSeVVBN3o5ZUY5dDNYV2EvNzd0Q0p3TVZaWEZKZWJnUXh1Zz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C9vblD8AK8widYDdJMyIa9KQH7xYOcEYSa3LD3E1pThk8L6MFO6+qMK6mY0YY/fMVyCVKcKmMj33gENhaq0ACukN1kCXcg5FcVpkFKLJVDGUv2lc4RuK7FmpIA1speQxVUyD8nSTrN8oxJCsQlR78Ors87DjHfCF+0vjYpJB+urlxecDzlSv1ArfgDivT1XdD367aPBghzILhir+iA7dfx+WgeQYjMZAJnPBTUvbN2ein8GD4nu/okUbSMArsyXL+J1zByGrYfOKdgEDcs64C5/XMWWpLAz0UdAjdrQI4SXc46LUBqw57v4OOcPWsLewmmrdptaoTZKhFnIbcq9D/U8SBjzivY07gYIRxfs+QK0zUODaYx3cqF0VNVpwnBJpY4KsOBwT6x4lSzj+5lk1732SafbIztgDX+2jjrOfdRg/oHIn+YGT5gSwtbG7LG3CL1um5MazMeaHxpRvIPvDiJrWr0BRhpwg2RzomONXx8DpG4UuB9ClxE8C9HhHUlnNdwFVfylXVyjI4R0iFWLIdFP16Bok5W1MBrIeXTmyTQ7oCAxhSzHNaOrTzmKXKZR7hJPYuYseTnemFhtQrV5oTPr3YLQr2D6+g0bjVhqyl5Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3456f6f7-7ef0-4a80-deb1-08de4189ce4f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2025 18:42:06.2820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9gWFEEURaC8re94EMS/+ZeaiLCPTJ6trECzs91YsmwyIc/X119UWFzkTpeCzuP9IxLfXn444lLscXM34uReGKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512220171
X-Authority-Analysis: v=2.4 cv=AO5nb62Y c=1 sm=1 tr=0 ts=69499104 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=BLFs3uAbWVecHf_NEe0A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13654
X-Proofpoint-GUID: lr_FgeOIJFyi0Bt_Fto7zrL1r32AYHOp
X-Proofpoint-ORIG-GUID: lr_FgeOIJFyi0Bt_Fto7zrL1r32AYHOp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE3MiBTYWx0ZWRfX+HKhyssQnotR
 +K808zAyoQDgTdziGkkcTKsQAL5Zu/e6QPGaEXbdv67BnmXVkecH8cNcf+KuO8dBufGHf/SWu07
 893S33cv60hzy1282ez7HCXepS+R/MxLkTFI9Noh5B1J8ktqlUouNFuiYubNH634dUFfXv+Xe/x
 JnSZJlQ6NHCbg7WESE3dkmFPm18+txvRAMahsIbuiDDwZ4EXGA0tM8InXkixtjGAtLSZqOS/8qe
 zXRNoeDmT9kz4rmOfZUUASU6l/ksu2zXwU8xJPoaeS8LOcVUXOEYsMp6FXfKE6PLLkOuwPpCfh3
 fsTcLRYMCJLV8ALm7ip/ZUYmyAmZX83jxFioiH4tGuGINANAIN0Q8E2YAfGiIzLJjVv8sYjmqd+
 unoQcFQ5NG3es5gsgfhorxl/ifL1JeMAvSZhyk7LibRY+Z0u58pZ+j/fbkrq4GcTLUny3S5GnOD
 L7tKs1Jv1d7OKQQZQlGrh38HsDIxowTnpVefo4f0=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BC2D140002
X-Stat-Signature: gj31b5jojmspba99tuojbhtctxcfctxy
X-HE-Tag: 1766428943-418275
X-HE-Meta: U2FsdGVkX19R+UOLyU01gVyVG4/SnwEzDFKB+B1ndp6er1/xSWCyCHGlmrwWpwI4pARCMkm4DPj4KWlX3VNBMaUxDyCDdn8PeK4sQINBYKN6jVO18Y38hDSZ1P8mWadFETXRqqJ58MuyPsnD22ssY5eJ3wOQIvGUre390vua9oy7gViOhCKyf47jG3vNcCjsW7wsMureUuvfW+HbRzUQDxmFwT6QrseB7HYU1yUpHgIOPRVy5EkWFu1QQlWFZgVAYjuKktVLVZe6VdVR3/BvnlgmTAkt2/kZNFrVLtVS0VgVAyh0X14RTBKVRmQFYRFt65ophYOMRDOBacYvj0VJW8VMZzaGgtTQ6CkEUKZvZSv3VX6fe10GF/Kd3/IN6f6h+jJIfCaE0MEypCAYzglcmLYZiWO4qlIJak24HvQocFDq2BpbQ4s8EFw8ilkNnoDoHBwYH4D+02h+BLjuKmKHJFr9LzrYxXwqAW7BGD7dUDcs4FQt4ocMzuG8SAz3ypdzpyX6VJSiJbWKsRVPwgl16iUXgk5mIMa93EoYRv+TV5/Fv81DXlkqY0IwGQzAt5Fx1igSK/pYC39k8rxWP7c+08WSwENgohy7uCALyscbt97g42jF935wfJ9FZZnHgs2ZnA+ZyCr80v4Y4MMlaRTTk2YW7ekUCEAV/ay3Bfe6UsWr3mXn/prrN/En/85pH6x4irJu6AtFxxvbqhuiPujSZ8LgFh5bA9s+0dpg3HY18tLu6Ct7Mp38wfsy2z1upknUKhZYcjpjjUoPQGRYuPAHhqcSCm/zMXItIKDlBUudD3RTKhtF3XwFc76r58JgCfC3JASNNutD9ijbVKrNBQ5Nr9d2D3Qunnp49OTDTiy8rZaJgwCsEkz5CgmWNPMWbcgdWw8FcDBaPSWlvGw6kWwoUxIfyvNrGcLYwAiP72UbNi6AnBHE8Xaa6925CerbL7W89fKCEvsutnMtq+KSokr
 27mZ/PVA
 te7HlYn9EE8N1BfgFq8DmCVzTZ+VW5OqLlMiMQIfc/aO7bPZR5PwCCb6IJUL+vh9lWobw7j+h0lRfl8P1+rm/81kx33vvA4L9Xvs5b5vsEFYfZQIm1VCaGD9+RODJ/BEt8ljWjjAP2E45EnSoX6vdLwqnR7iLkrg/yWahXJZmlqorWACtcQ7ZUofUhA+jjDgd8DTboGCffjsXhs4bD5kIkMSrV50DTTM6QmyEtfHrNiTX3tdzZAUeLIkdCykAj9g83zKepv3cngD//sFHgX65RDo/btqm5XjvuOS10/BoqD4DtwpiAOQkgFWapWY7pylXyTwraWSlVVsOj0LyhQx/b/eJQgJ7BrBI7WYAU9+dagDX80XPdxE+njrr0X82isYA7Pq33HM/X3Rz2eBP7sPtledqsbkzuGMseOKAa72GyLer/rW5NfHWzSP6tHo9dY/3sGd/CKtVr3HllzAxMNAvZFJ6V+VhXijknKeLEjuORbmo8UXsq7i3DRnjj92SFhwby2lk3x/7kK623ka6s4fjbt/ItUrFiCDeP83XQPCcIGM4O9l5r5R/mc8B4VTXGMQQgSSLTJo8QQ8MYWkVbHpgWm1eRZDjtQO+o8SQDEeBu5ilw/rE8t3H2rP6m2PxpJkrDa4O9HpxL1ngZ5WynW24AF9ckpTffrL9c0n59Qj+3WHBj0KenhPsznqiD+ut8sdVngCM3Ez1y0/xv6am2GSq/VN4+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/21/2025 12:49 AM, David Hildenbrand (Red Hat) wrote:
> On 12/19/25 07:28, Jane Chu wrote:
>> When a hugetlb folio is being poisoned again, 
>> try_memory_failure_hugetlb()
>> passed head pfn to kill_accessing_process(), that is not right.
>> The precise pfn of the poisoned page should be used in order to
>> determine the precise vaddr as the SIGBUS payload.
> 
> I don't think so? IIRC, for hugetlb folios we always reported the head 
> PFN. And user space must assume that the whole thing is poisoned and 
> will go away.
> 
> I recall that older QEMU even depended on that behavior, for example.
> 

What happens if non-head PFN of hugetlb is indicated in a SIGBUG to 
QEMU?  Because, the regular path, the path via hwpoison_user_mappings() 
already behave this way.

I'm not familiar with QEMU. AFAIK, the need for this patch came from our 
VM/QEMU team.

thanks,
-jane


