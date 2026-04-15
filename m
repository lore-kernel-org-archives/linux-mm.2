Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A590CF428C9
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 19:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7326B0089; Wed, 15 Apr 2026 15:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17E1E6B008A; Wed, 15 Apr 2026 15:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D566B008C; Wed, 15 Apr 2026 15:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC2AB6B0089
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:40:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9673D1A063F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:40:47 +0000 (UTC)
X-FDA: 84661807734.24.D3C10A9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id EFEE41C000F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:40:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="a/2MRC2K";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xoeAOgOe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776282044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4UYWnbn6cGbBMS5hEhdUnXSfnjxWbWMbFqYS0h+0A8=;
	b=mf5GfxjhqASWMr+/LzzSShRakfIoI3lhEbTydILYa22aQZJTkFcu1//ZB+xJmh17JFKhJ6
	R6sXbDCMT9POpyfZqSyktRT25o0+9xOzTCeO28rlPmtVoks19UYiqfA9dtc6U6ypsmO96/
	GXM/8if6I+gYMV0UofExzzJ7XED4I+g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776282044; a=rsa-sha256;
	cv=pass;
	b=KWHP34jVnjCTCV0lIyMirsK6oWXxJU39OrGdENv6VxybZ15Tk2KB4Pzz86W7Qpu6qLSe5f
	Z3JvEkH9nywsPKf2eZejebM/fXlTILi/Pl/oWN6XJnfhLC3dj4LubCAGwCG+pt/DbH4x5a
	JOvYwIlTq2T+CrWtMVeYP5tQ6tA4RME=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="a/2MRC2K";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xoeAOgOe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FJMRTG2136605;
	Wed, 15 Apr 2026 19:40:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=r4UYWnbn6cGbBMS5hEhdUnXSfnjxWbWMbFqYS0h+0A8=; b=
	a/2MRC2KmH7ef0eXBMIKrWpRvB+XB8Y1Md8wsd4lzAoGF4rHexX1PSYtsOBtrAbb
	6oUr8J4i3IqpEotVLoCxDM5RN2bu69hRnyCGH8Gvb4AQf5RQjWkDXxlqDuyXblpS
	f5w4sOyqrrbMvSi+PsABnNZ7tXXcNbJjSskJ0Er6tf2lM8t+HN6/9Lq8/Yyvr6ZC
	jtI/3mmNSuPzm8RT9UtvzK1Rg52O7SNE1+yxNxX/XHqrhngyvK6ZzNZqmcRmLmF2
	DmHyVxw6ot4pZZub84/puDNFNeeqCOZL75w4U9Y0RWDGqa1mvwXhV05sbzJpSe84
	wKwxXQUBgRNZToDEq6dOrQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh86863jq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 19:40:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63FJdSUR029950;
	Wed, 15 Apr 2026 19:40:36 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012051.outbound.protection.outlook.com [40.107.200.51])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh9jr337s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 19:40:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KyFCFdnEZjufih+AQLTO2f9aSvTEi6epNjtgoAcnX0vF2omT2OGNNHrO6TVmrxnLQzJVQKkBfh8LL9KMRXwMVGfRgQQorDrEPIeIfyPVB34b4wwR7isg3lybmN4neW08IExSgb48vla2O3Jrz4w+iyeIvB3YqRAi1EnoZz92mCF/yLng9I6dUcnRJfIAKRnC3f45MyyZhzs5MwGPyrdWnilZu5FrxIjLSh/kWSBWwg5+kZ0AnI0Lyw+jT5kHitU4eJ2cdMrwUs0BZSPSVQcI+KHV8HcV3UKoigbCtVMbU6n/HdERWVrzhR+mWHDfttez55nnIlHOpifmzDQguUQQdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4UYWnbn6cGbBMS5hEhdUnXSfnjxWbWMbFqYS0h+0A8=;
 b=Rg7ep/nCTR1Zu72xMy4GPBSxgbVfnQmfv0HD8wUIrR6+YhXK1LlHZ7+hSjBk7dVlQeXsyKiETdJc4ornaU6jJaVU0BnSKoUPHuky0zDzHGsTEPvFn8Yps29tJps4Y4cC8LS/Sp6m8fODNp1cglnrtUGJ3bLCnewPHq8WR9GI+QVxv3hOEaAWby1/xJE/+HzVsKwb7PMIZwErYfdF3mvtOMUV/ydGoqIbgjSo5GU97n3oktuwY65NbG47AlUfnvNuSAkxrA+fcQxtYtxdmPhbMFkjQGaefIbnr/arkzUVoGydW+H9yE2+5C8tZUZWAtSirbbDcyh/2A6mljbL30v/eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4UYWnbn6cGbBMS5hEhdUnXSfnjxWbWMbFqYS0h+0A8=;
 b=xoeAOgOexXfFvuB3mXR4MXB4Jew95769QP8fnrFEb2AMuUczRJLi0tw9e0JjbQYUVAvjrBdte/4Fl9ZFIPGyyK/iAGL1GRc2+sTur9vrChenASV/S65RGWCntRXcXQi5J7RZ2g7ICm2vKtIGNAC4lgdGIeQLZnckORAEQ4mHfqc=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 SN4PR10MB5589.namprd10.prod.outlook.com (2603:10b6:806:204::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 19:40:28 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%3]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 19:40:28 +0000
Message-ID: <bc2970f6-9f71-4789-8a9a-5f21b605a647@oracle.com>
Date: Wed, 15 Apr 2026 12:40:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] hugetlb: normalize exported interfaces to use
 base-page indices
To: Oscar Salvador <osalvador@suse.de>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        skhan@linuxfoundation.org, hughd@google.com,
        baolin.wang@linux.alibaba.com, peterx@redhat.com, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <ad9GS_hRv5hbLfl3@localhost.localdomain>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <ad9GS_hRv5hbLfl3@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::19) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|SN4PR10MB5589:EE_
X-MS-Office365-Filtering-Correlation-Id: 0aa1bb83-5fb5-4795-b737-08de9b26d8ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qk2pT9xawn+xt3PVh5zluRcESH8RGAT8ZOC5sqIC3IO5yJ23EY504HsStdyMKGQYSLpyjaXzYOlDIwQE3auDmLk3/XftBP3oGWILqMYxG1zBervrYpT/xJShWbq2lyJi1aDJMUYBNJCtGa794MAoFufPPlAlJ/BIdAuh4OH/brbEJlfyRObNZkt+vIiS8yUN1eekfk1qUxieNDqso6YwMI5KqD2gpfeHAyMfNdIYp5pkrIYV/VPwaxYvE+uzuRiNXlCVTs3VRQCZR9fz/gWCtTjppO2vtW3LhgvKUPL273FaLQ9Im51Y+Edt993jaw0Mta0mPYiK07u7KFPeX1IvRK2+Q3Vl+CpL7yOcEYk3DLjiP9VqNI6EibCAwvdUtu7JJdTOWM+Doi1BipnXQk5bD1AebDp7339TPgVxk58jnWCpHFTGmsw/tNL8CFq3PZAPZDRyScui+Xe8kjQwZsRAYHBVve8jAObZuHFejOuEuHDAtjeP4qfAXu4Mw7zBgYPVFM8cWXyMN0xpoFcfoXkzndLJ+rovhsvtMRIzWMOtik5u0zCI/H2k6kCaLy9HgmBGg4/KVf5fshxNcrFr7tiPVwluB03Kn96Jm4SambU/NiSSuBbY9sfAM6Yrq5asBAKmugRZmmazFbNqYvFzqTms2Yr4Od/Qu6Ke60JbEXPsCWGIOCg8laZVxXaEU3JJ8tOICGp7rtifthXxxj6A0rdi/7AONAmQ7IF9Pcwh+cIrnzY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVRLdll2bFc3L3Z2S0lNbmxKZUJnb25hem5FTUJ0QjRhWXJ1NGVYc2N6TGU0?=
 =?utf-8?B?ak4zVm96S21KeG0ySGZyK3A2bDM4RkwyUld3VDRRZXI1dnp5d0hyRzZwY0Yx?=
 =?utf-8?B?UXF2TXFWS25paWlSRmJmOW1GVHdFV1pMNVZwUStRc25Fc3NvWnorQ0J2dG15?=
 =?utf-8?B?YWl5N1dycUpLM2RIVkVDYUo0Q1ZxU3VqN0pJZWVGZmpTSjFOdDBobHRVcUll?=
 =?utf-8?B?aGJvelNkM3RnZXBQZEh4TXNqbm9BZTFCeHlwempScVQzdW4zaFJsNm9iOFZo?=
 =?utf-8?B?WXlIb0hGSHI3WDFyZ2RWOWROTDBrZ3p5V0pXREMrcEZQcUUrVWlhTDZDcW0v?=
 =?utf-8?B?b3pLaGg0OS9MTkFubW5xNGFTdWhkMkFWTytXL1JoN3RxRlE2SCtSSTNZOExG?=
 =?utf-8?B?a2dhd3Y3aU1ka2VBWWtHRS9jbnorVytwSEpWL2hRZXhLemNnbWhzdlpnMjEr?=
 =?utf-8?B?bGVEdmhOZXJNR3pVMDNqR21TRUZ4czRQWEZTd2Z6czg4T2FmbjRoSEFwcjM3?=
 =?utf-8?B?UCtWUXZVQzNCeGROTlpwYnBIeWtCd1dHNmVWWk10Vk1ldytNb0d1bTl1dHF6?=
 =?utf-8?B?Z0ozb1RuWnR6V1J1K2NHa0FrOUJ6SnNCL0xGNllBMGhMR0pYL20vM25mOGhB?=
 =?utf-8?B?NXMvaWttZmVFKzYza0JscFl5NUVCSTZEYVQwM3dFVm1oNUxCeGYvVVZOMll3?=
 =?utf-8?B?aDlHQnRSQkRGZXBsOTlqQVo4NTFiZktYN1h1ejR5WFd1YjJ4MHdydGdLNUVk?=
 =?utf-8?B?allaSXpUa3F2VzN1MGVOQnFkVDRZYzB4VUsvby8wcXFzVHRUUnFJYUdVUU55?=
 =?utf-8?B?S05lckRrL3NLSGExNlA4VHJzK1NCOWlTT3RCZUhJS0FqWkZOU1lqZ2l0M3dV?=
 =?utf-8?B?VEhDS25JNjQ1NFFqVDJXLzl5eWxGeGdlQ0t2WEl2U2puL2FFWnkwK1Y3QlBo?=
 =?utf-8?B?d2txZmlEaXdsdU5TK1o3ckdNRGJHSDkvdDkwVWFWUVlyWVdHSzZKVXBaZUVr?=
 =?utf-8?B?bEkrUk9aNW1GRGp6QUdzeEtESmV5dkhJWk9qanJrU0tBdTZaTE1RMjRVNnU4?=
 =?utf-8?B?bFNHcTlrcnRjSG12andTNjg1S3dZY05GTlZrYlg4bVdaMEpJdm55bVV4eEVU?=
 =?utf-8?B?aTBXYzZ6aVZkcVVEV1lJSU45c1ZlSGVWTis5MHBuVFVTTWV6WUZNa1FHV1BQ?=
 =?utf-8?B?NVA1VS9WZ3VFQkdiTllBa2c3U283N0o3R2lqL3ozSytVanZIaDNXYVVpWW9B?=
 =?utf-8?B?VXF3azNTS3pNQ0FOcVNLMHlsR3ZvbDhiT2EvdEFwZHRVd0s4bzRGYTRwdUZz?=
 =?utf-8?B?KzArWmFJRC8yS0NJVndiWDNYY25QSDk4ajdsa2RpNjFKN2pvMUxCWmk4V0xL?=
 =?utf-8?B?dEFqL05PellxT3g4ZnRCZk9XbU5sNUI3RWVvd0EvOTUyRDg1LytDVloyazBz?=
 =?utf-8?B?QVRTaW9oakpNSGt2dkRnS0ZzRmpFQml0S1l6eUxiMWZuTDJ4TnZ6OXVETExo?=
 =?utf-8?B?UDZnNkU5N1lnL241UUFnMlkxVjlHUy9DMmpLeHZQcGpGNk9jUVVtNWJXZmJs?=
 =?utf-8?B?Tlk5MnZGMDgyaWMrMTBIQktVMm9CZWE2QUsvWDRYZlF5Wjg0MVdyckw2Q3BT?=
 =?utf-8?B?TW4vUGRlRFpWdXVQQnFDa0lQSjdzS1FiUFJIUSsyQUsybGhVaFlGYzF2MXVs?=
 =?utf-8?B?WVUwMnNvWVQ4SWc5UjhNbVJMWFI0TnE1Q3dyTkZEdnA0RjNnV2JCSkZHN09o?=
 =?utf-8?B?UENvQTNEZmZOY2p2VkdSOEJZcWxsWk5JaGd5SmNGMEtla09aMmRNMFhTZk9X?=
 =?utf-8?B?NUF4K1Z3Z0loVWdLaUlXUytjU0tRclZKVXRwbm40Rm9MbzB2azlnMVhlWjlj?=
 =?utf-8?B?TE1hUGJ2dGI3QWhNK1VCZE9pVjNlcGh0Ykhsdk1MOUs5OWV1ZlZKWFE1Qnp0?=
 =?utf-8?B?T3RzUHlzejFwM1ZkMXRVN2oxcmRjY0MreEc4S21BeUF2WHFVRFBQRGJ4dzlD?=
 =?utf-8?B?SDJkOGtWdUFRckQwUmtROXY4WDRQMjVhRDVNY2ZWSitsQVNHam1LRUdTbjkw?=
 =?utf-8?B?bjhta0tLWmhuNVJzbkpycENRUTIydU9MNXNTdHZWRnp0M3ZTMmE3Z0c2SzBn?=
 =?utf-8?B?N3hVT2krUHBOL2t3K2dFU2h3RHprT2ZRNFZUSnJ3aWwwcUY3L2xMazR6REV1?=
 =?utf-8?B?cjIyL1N1azR5blRlalQyRjRUemw1UE9wMXFXLzRMcG5GWXdSK1liM0RKaHdO?=
 =?utf-8?B?d2t6QzdpcUM3U0tsMjUraERWRGZpOXNYSzNCcnh4MC9Va29mU3Jxd3JvTUtJ?=
 =?utf-8?B?OUNzUVhOeTFBYjVNODF1OHdQdHRUU0RXYzhvcU0wMlNUb1hlQnFHUT09?=
X-Exchange-RoutingPolicyChecked:
	PCBmhB8znj0IldCcFSNvcM0ZcpnsDnQAE/WqUvgkAfFU4kXPxzagPq/P1RIyH0l/Ivw/Dy9cNxBYJPjGTaLCSY5mMBNg5C1DvzHwufBTxtA3AbzPlz3YbIFWT7h/Acv/ZiFZjer6nh8zfrGjAc6TsouGnj2kJq9gVTsHueOmrKaERSZI1W23jNLrB2G83zAi7W6pxXGGMxg07DA/5EAWXwOEYMNo2KLiq9lYOulKrZZserSGqHEv4EfnrsIEXVXdMLD7epIc26mb2yLx1/Qfm/dOcFSEQdHFE9KbFHJd/Au+96r1oGQxu2WxNlZzK6n36DzAxynXqVWMhxPr5yvAqQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7jyNRzXV5hLWhc/lZGr/JIg9tIp9dJ5nEs7KdD4YvBY5eZuAlNCo8js3boXgTHKW8ZguCtA1+12tyZOYsLwLyvEPR5dFTD8WOcoP7mGgWXwqXPTl2gTGolOrDTdYSRKZsqjSlomUJB7b5THmebKLPHhuhrcpWEAUxG9xabKs/QqUK/r3KHyt5Ej9UbhMo7r8xDFA5Cxw94l73Zv8BAh8vqHghvM+LCk/mputCFYf1L9ac+FmZdZtlKaSDm6Vg/wMPxxcZVVJz/NSiquww6OwMFD4LEsOX4dUlsJpdeXR0REmCU1Yc3Ku34azXyqM87tGj2su1wqbYG9mHCW9JRloujwtEEN2X1lUDHYIb6WNhxcd2aannxbOo6oo/x6yeHeh1sT/4hCrS+PK7kpR37rltpqMxCOPdc9WgS7jBILAO6/9bGMPwJsW02+lfBcqmZub3FPYJStVsdhHnzYAAfnGGUcUhI4Fo/IT8CqXtk/8eD4c3mcj93ofUxC5At+ra5AVuiGCwA35ce3fEecZoL88UguV9pLaxa3zrAGy7sowF+XJV3hlt+RV6biiWiarIE6upkKLR9d7IctA3EKRbW1FZwqV85QbMAecd9/HrTDBO0I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aa1bb83-5fb5-4795-b737-08de9b26d8ca
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 19:40:28.2845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y6mb9SeBkNpvjkWjUfsB51wLjuuEZej8XSAwsd2us9Rz+Vu/uHlDl2l9wy3CCp29m3ku4IIA1uK1DP8MZp1k1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5589
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-15_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=730 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604150184
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDE4NCBTYWx0ZWRfX6uh+A2exs1Jk
 XMWd1C7cO8GeEUqOqFKnch+p7K66hXg9xOlw55xM0dMGdoz5TcP5CS/RDnV3OsBMzuCBkuoLsEk
 t/srfUCzOLbQgT8QMh+iY0VYxmVfOP4huzk8TAbgS2JlCRp3nicd9RlM0XFDNlcKgXGCm5pnRca
 N/rHAdvo20eHuGGS7VsledJcH/T2w3kjFP8W0R/rkERr1pFTccxQwjvFfAWTnXlxVn3BuTCU36J
 DZGBAOtnO+zcOSfpeegtHC6hRuQsZQwkaW4QExMMb5/gdp5pXiWATJxRXU22acsMcPhrY5Bbm2b
 plgxQO4Db8HUbRLqr0r7M3eCl19CSePpNLhMh89LWSzsfdrfonWyrZ+zS6O1nedZCOvo0wyA0FB
 4IFiy6aYziph/PqlOt0XSxjRJvc3gw3l5HqpsKc59XWfzeB8xEBGRZiApKZtWFE8B/WtG7iO7ar
 AGW1zgcf3wQKPSE/Prw==
X-Proofpoint-GUID: RhiAwv9sltHxgD_Zhw9-th4f5DbXNZqB
X-Proofpoint-ORIG-GUID: RhiAwv9sltHxgD_Zhw9-th4f5DbXNZqB
X-Authority-Analysis: v=2.4 cv=JY6Ma0KV c=1 sm=1 tr=0 ts=69dfe9b5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=oOAJSsOtIehUPVaMPUwA:9 a=QEXdDO2ut3YA:10
X-Stat-Signature: n8zdrkqxqmwsnsikb54ufqp4oxdzwq84
X-Rspam-User: 
X-Rspamd-Queue-Id: EFEE41C000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1776282043-591271
X-HE-Meta: U2FsdGVkX1/9lu9rdiGgOUNxrZLtuTiacnqZkzIaSbtcdRCD5bnI/T2gfMzdUdD4TBm2fCkEp4Vr6NyuBLJBJ7ViSAJZgpNelncVpD+3Yw6qzl7z5cWmzc4480V4/sP1Yfz+1N4hnmjAHzcgnDDpWHvriwCcakG//ntFlb2i8XvxP4rJc9Zlq1lLcAsz0xLxqSb2SUSAQMIjflXjJIWRg5rGiY/5wXnnAlyQk9HJZXAMOJnEjJM+O7lyV0Sv6uYKp/vkFsG1v0rzYdFqdA2f22bRkWCMu8W60ewuNhhgy6LVFTUpNhe0Q2DLwT/U9CRoWrle/N6maZlpDa4yC7/fGzZTWdQE8wKSqut1bJYzCOHIAwo3fcMBQfDzWbfECZrTCE8Fo9E78xxKTwQNK0lHs6v1ud0Po55h/jO8yfTdkby4M5k8MD9TqWQERmCrATAFywtXkRivm9PovhBE5vtu5cINUuEv8xbuYG4RXfTMjVHEVrV1mmAv41cP0+5qoU7ige3N0Tf3dR2XiFRLslWL+LxaFqyqdchOzMr4oS9VeyArImFqNvRBtZm/PEG4F+euJiJlaAoZiWex0cqEdTjZsmD4ayrDFPvRokGgAd9+XxIIPIXJfH5nUyVLzfr96DO+3voh1skkUAPyLD407NHI5MlmdSLro9+qG9X+lqhn8Rz6DBKSBuTj6BwSCKFIhFWD1o1BR8dojk5CZcgoNo1XqU0eaOLSxy1Ml5O1ELegjlQIomzcI4B0AmfEsiPfjDF/VBxkBG1foE7H8bFLFBYFct+5uG8x7NLMWVbp0L+routNv5M/49fjajcwJyLMv96YU6siYj8DrJiE7RNSuLhZFdkBQQSVXGRn36bOIITFupUhbjHCLAXuXaO9ikxX8GcyZ0HGmnDe6hvaZMQFlqzV4T1jP4qrI2EemIhq+8IFcC7PxU3L6HsbOcLahD7ilvKr7wWKbSIbF1pTKaWLPqU
 IlQW0WEV
 lZzEKpwde24vQmhpDkON/M/w9QmgeNmsQrHmkRebOTHRlCER7wYYPbgFW4lRUcuoJsWeVnvNHpvGb7D3M1EOpXcDB77PaMF3vyDBHGGs2NjCT4XfTTc091qw/SP/izVnO0MHb9WBGo/vyfac9+tlSEcD4hzJAIt56lVhi7nADrt777YuOzQPJSHJVXu+Vs5xPyCIKH2nmgMaaWtOe++QapanLrJNv6pmGESCjjVae05nrDSHJkfBdsiyv1btCWxe09jTqgUG6C2kv/BSezViJN6nKUKiS9Jmqzj1HAlPis8/+R+QbDrMVErvKajDVFcIy+QZP4O1H/wvj/+QstyvnRJ4KIiHm5pcOn+0pdw+WWordIo383biXRz86+6pVFC9l8QGxRtIcl04fSCgRPmNP9XhP8KT08IbT71nFOMeNRyzlbYD3vX0b4n6Z74VS5i9rwc4wTCnGQecGey6H0Bplhigp+zTG9fG3/wJU7mMr6rdJj/cFQs55oEKlpsPtY+h+co2D8dFld5TSaAZMtgxPM6y+7AjHMPA7MT28UW6NrlJmpwADPpgQ5MftYRR+jZ/sE3+Tgg1jG84FC+B3GR2ypbZniboD6aM2k/4LVq7zfQN6N8MRNCJ1QsrBGcJpy6hurb/f1tpf/0sTltaxREYD1ha56bv5zGwHFFoXhpwCGWZYd7nKyWFhA9Q7VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/15/2026 1:03 AM, Oscar Salvador wrote:
> On Thu, Apr 09, 2026 at 05:41:51PM -0600, Jane Chu wrote:
>> This series stems from a discussion with David. [1]
>> The series makes a small cleanup to a few hugetlb interfaces used
>> outside the subsystem by standardizing them on base-page indices.
>> Hopefully this makes the interface semantics a bit more coherent with
>> the rest of mm, while the internal hugetlb code continue to use hugepage
>> indices where that remains the more natural fit.
>>
>> It is based off mm-stable, 3/30/2026, b2c31180b9d6.
>>
>> [1] https://lore.kernel.org/linux-mm/9ec9edd1-0f4c-4da2-ae78-0e7b251a9e25@kernel.org/
> 
> It seems you got some trailing spaces issues:
> 
> Applying: hugetlb: open-code hugetlb folio lookup index conversion
> .git/rebase-apply/patch:64: trailing whitespace.
> 	pgoff_t index = start >> PAGE_SHIFT;
> 
> Applying: hugetlb: make hugetlb_fault_mutex_hash() take PAGE_SIZE index
> .git/rebase-apply/patch:161: trailing whitespace.
> 	key[1] = index >> huge_page_order(hstate_inode(mapping->host));
> 
> Applying: hugetlb: drop vma_hugecache_offset() in favor of linear_page_index()
> .git/rebase-apply/patch:44: trailing whitespace.
> 	start = linear_page_index(vma, vma->vm_start);
> .git/rebase-apply/patch:46: trailing whitespace.
> 	end = linear_page_index(vma, vma->vm_end);
> 
> Applying: hugetlb: pass hugetlb reservation ranges in base-page indices
> .git/rebase-apply/patch:237: trailing whitespace.
> 		next_index = index + pages_per_huge_page(h)
> 
> 

Sorry, will remove them in v2.

thanks!
-jane
> 


