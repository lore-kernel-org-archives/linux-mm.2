Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CD6C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 16:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962368E0003; Mon,  4 Aug 2025 12:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912EF8E0001; Mon,  4 Aug 2025 12:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DAC78E0003; Mon,  4 Aug 2025 12:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7AF8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:23:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 231F71607D9
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:23:13 +0000 (UTC)
X-FDA: 83739594666.04.022195A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 76B1840009
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:23:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZYAWN0c2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="dhIRR2/d";
	spf=pass (imf12.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754324589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWUsNDAXBPAZupatUXRIEHk16CSN6I5wNuL8ydbYrkE=;
	b=Qfmu73ROwoQadYPvjBj0OnSmRF6v6bNhxRKHsv+8fHanEbEGCmMJnFJcb90ZVlzK2tssg4
	KuYvwJ+g0iekyb9pM8AXDu8R6fytObq5bPFOjMV9O2QAkdP5mmrX03/N5peo+OQ3ip7H1Y
	Nm9/gMLoGL8+vwGjU42OviH8+iltoAM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754324589; a=rsa-sha256;
	cv=pass;
	b=ePSzaRsls3BMTkFdqpFZJGCxgTeNEhkRpR233PVjBfGf46MKeI38n8O0CDRLX3hPAZX1J1
	dR883L8kf+ESZlM6iIbrXvJmO+0FCaMP3h1ZJyGFKkAO0vdThFQRhWMnFyUUgbC6T2SYs5
	13SvRB6NK/shbQy/hg+FDJanp0bR+Qc=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZYAWN0c2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="dhIRR2/d";
	spf=pass (imf12.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 574D7QIF015845;
	Mon, 4 Aug 2025 16:23:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jWUsNDAXBPAZupatUXRIEHk16CSN6I5wNuL8ydbYrkE=; b=
	ZYAWN0c2HA4Eiey9hk5NvPncnzOppREamVMWR+T+0TM1f1HehkVX18an+y8Azf93
	jKHPxjx/L6hRWIRK3hldi6/bSsFon6HEBiymu6DSuwOEMnqfV0r869cAeShlR2lo
	/YiG87rXLr85YUv94hWkv0fJ2b5WyHS71C3iAcuaF8OgHJpBgqKvK/JjV6wSqd+v
	6k8mYEpvn57BprELAcGnufh86kWnahKrjxDSL1JJaT524Xm3n8IEjuidDt1PNCbS
	Szv94IKoQpuk6Cp3K7boR//6WXqJPcVvG4qzX+gjKpG55vCAXPaRBQ//9PJgxmBp
	5wBuDzN5ZMhYE6wINNwvYA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489994k1j3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 16:23:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 574GJjUh017941;
	Mon, 4 Aug 2025 16:23:00 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2088.outbound.protection.outlook.com [40.107.100.88])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48a7jw4u16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 16:23:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mAZxI54GYzhpNF/TBWhfj40NQapFTXuu2D08GdcHIriQtNXFoEWp0FFTn1JmEVuovp0LIcHRNCsGZNdNXBrR6hfwCgzfdpXm56pN44PCGNLb4AshCFPVZuT5J7seVDDyNoB22jhB2LcI2e62QNh6ZaTZ16uyRe6Cxt8UkvhIjAMHJKuPRvgtg8e6nrMB+J4QLuODbcrtyqLTg+Ikqg3HNzrJZmFPK3VtIJnJyvk/OU4fPrYcgwpNx9bk6tE+FHUKHlWtTCGeboHQhhfauQKaR1hq/olSEQF9sw2CWzv7IWoTo6yXXDKih+7zYT14B7BMyWlHh6Kbk1XkWV2tla9pZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jWUsNDAXBPAZupatUXRIEHk16CSN6I5wNuL8ydbYrkE=;
 b=hLcQNKn87PU/NZ3zklqPTW1BDI3PWp2+luwrdDDnGHQbdvQ9dT7BuisYwXUqCg+P1KOLBTJlw19Bd74ePBLPG/ufgje1FDWLPmcfIJUMVYNFRqURjjVVClHIyd7tAkjKArUFbXKncbPrYtfHsz2njCcpjfnfHpXKzN2/9bzrzF2/FBA/Ccf7Jwxjs0uv9gUpe7Yy+pLekJvP2ADQFdixMtMBm/JhRcd8aJhoaXGnG/RSb+9m7vqQoRNwHX8SSAzoxX+mHA+JcjBL89+QORa1gfBd/jpChDhVP2wW2FI4ReDALm0U4MFcE5eZWEA74ecYpOzpYwTA8y/Z8viZyHNAQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWUsNDAXBPAZupatUXRIEHk16CSN6I5wNuL8ydbYrkE=;
 b=dhIRR2/dQEUr6f/HEfdzW6fM5SVgfNf4lKF3/Lg7Tv7G8O1q52+ti0v7BkCzYZwDRMkznN5J5hE+VjTkxNZ9tCAyW98chZfdNJOzXL6k0/qFPPpL86SGYd0e0FwU6YZ3zuuDi6+ZywcAsU7UtecuaIV4EFYktt/ti/jC3nr+DwA=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by PH0PR10MB5796.namprd10.prod.outlook.com (2603:10b6:510:da::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.16; Mon, 4 Aug
 2025 16:22:58 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 16:22:57 +0000
Message-ID: <48969241-9d36-4d4a-85ad-b0a1ea5283ec@oracle.com>
Date: Mon, 4 Aug 2025 12:22:55 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] mm: hugetlb: directly pass order when allocate a
 hugetlb folio
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-5-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20250802073107.2787975-5-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0238.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::33) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|PH0PR10MB5796:EE_
X-MS-Office365-Filtering-Correlation-Id: aed3e128-90aa-46db-d417-08ddd3732c6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXA3NGhIQzM0NE9Wa01UMFdSQnpheTNvUEVwY1UwclVWT0JieCt2Q014Q2Jw?=
 =?utf-8?B?WGFvYVhCSHpGLzJIU3ZHMUk3Vkwwc2Zhd2NZRnZyUWtCQ1ViNVV4M1NsblNZ?=
 =?utf-8?B?ZTNuc2t2U3plenpyUVovS1BRV1BUcC9qOFFsMmV0VUpMRmV6b21LTmJveU1w?=
 =?utf-8?B?b1ZJb2NuY24vUXREMlNwZ2kyTlYrWFRIbVcyY0ZPMHVqRkJCQjFKNHNCK2VF?=
 =?utf-8?B?eXlWQnF5eFlVb0t2ZzQ1aHZic1c3b3pnaVFmK2VjbHRQVFNmYmNWVkw5SGZ6?=
 =?utf-8?B?eUdDT2NiT1VLWklYQU1ieStQakdSalF2c1k4eWFWR0FPR1kxQk1vaTV2VTBx?=
 =?utf-8?B?aEdCc1hBMWNidVViVkV0ckgycDJJODlTUFpYV1AwZjdzQ1l6OTFsd08rMjJG?=
 =?utf-8?B?TUN6VXRmbDFrZlQ2S0ZTYmx3bUJMWlFOOVhPQkxWSG0yNm4xdE1lNjY0M3o3?=
 =?utf-8?B?QWplamp0RDYxNmdLRUNKK0pCak82a0lqcHlML3pmUnBHTWRRV3YvbHNUOFM0?=
 =?utf-8?B?aTl2Tlg4SG1qd1N2OVd0UU4wQ1hRZi8zWm1ybzBmZlFNMlpMTzFYSXNic2J2?=
 =?utf-8?B?SmswYkIwOTZUTEY5c1kxS0pobGFmYUM3ekFCeWpuczkwZHUzcmxFNVlqdTgx?=
 =?utf-8?B?Uzg1WFo1QUg0R3JGSDdaNnc1WVBOQmR5Y0c1ZXIrSVBVZGFmQ3hXVktaQWUz?=
 =?utf-8?B?cjdKSEFERHY3VFJkakpBSTZmZjB1QnpaWlI1UjJlQ1dSaVd6d3hBczNyV0po?=
 =?utf-8?B?Z0pWbXpXdVFJZU1LN2FRY2VFT01EMldqWXpGMnIvcGRoNktHQXhFblB0WVNC?=
 =?utf-8?B?a1FuMDc3ZEt6TDBXT2hsUU10Y2ZzeENhSGlTWnlWMTVXSFduV3BCVmdTa2RU?=
 =?utf-8?B?QWcxNmJOS1k3WmpHWndVMjc4cmwzNGs4Mm5zZlBxN1FXVTc5WDBoUXFPV3h6?=
 =?utf-8?B?RjlqSHNoRVErQ0RwZ3VlL1UraFdNZXNabFZWQmw4LzdPYldPS2E0ZWsrY0dw?=
 =?utf-8?B?cTJhdWJ1eDVpc2RLOTNYQ0k3QTBCQ25Xcjl5U0I4YzNTaFZMZmJteFBPR1hs?=
 =?utf-8?B?WEplb2ViVCszOVJvZkgrMEpSWGdYTERtaTlzUGFEK29tbGRNNjlFbHlyQXhZ?=
 =?utf-8?B?T1ZidUdKTDVwQ0xGVU40NVk3T3VMVzBWalRjYXp1Mzg0VnUyZ1A2by8xbGhD?=
 =?utf-8?B?dGRRTzdwL1lhdVJVTUlHRFcwdHdQYTV1NllaUzhoaTZBRWQ3QjY5ODdsRkQy?=
 =?utf-8?B?aitid1o3dTVQRDZ0K3BocnNKTUx1VnA5QjRweE9pSER6aERJTEdwbmYvWmFW?=
 =?utf-8?B?WnBJZW43SGJsOFMrYldVQkZSbk1DaUp2Q080M3AzRVd2UU9OOC9LS3VVdVha?=
 =?utf-8?B?Nk44NHlKd0hlaGh6ZjNxT3ZrSE9HWkcvRXVuRTVWeUN0U0t0bVh3Vlo1bysy?=
 =?utf-8?B?c2lBa09YclNkWE5BcjV6R256Mk5vd2FGT3h2bTRjaWhTTm0xbWk1bjVSMjZq?=
 =?utf-8?B?Q3lSKzJVWjZ1Y2tKSXYydVh1Ui9TTmdPY1pPM1FjTStMUTVBdGpIK3FRa3E2?=
 =?utf-8?B?R2FQc0NaSk1OcWY4MkRxcWpyMjlQQnBqNGdZOGppY2VnajA3czA2R2ZXYURI?=
 =?utf-8?B?L2tQVVZWRzZnS3NQNDRneHo1RjcxbUttdU5ycVQwRW9hNnNCWVRIVEdibTRC?=
 =?utf-8?B?VmZ3MXUrRmd4aGhTQXlLeUo3UWFHQ1J6eVRITkpuWUduVUx6YVBRd1JhbnlP?=
 =?utf-8?B?RFU1VExpVmQxMXQ5VVNwWDVWRmtwMDRqaHY3bHhQK3VZVnhsZHZIVW9lS09F?=
 =?utf-8?B?NlNqU3JPTk1uN2s2NE0rcUk2T2hCTzA0ZUMyUVhLOExDRVlPckdXY1RXSUpY?=
 =?utf-8?B?TXhxQURJWnE3Z25lNE1EaWJEUEVQUWRaU1ZaYnRpcm4yS3JCbGMrSmxkbTNo?=
 =?utf-8?Q?mIb/3TbQB9g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXFQeDhHdWpjc0NOQ0dsQ2lDcEVOeStWcEozL2E4QVdMV1FVZFlrUGZsalE0?=
 =?utf-8?B?WllCTE16T2pTR3VyVDMwaU9xSkN6MlNubWJVVTVHcGE4WHIyeTBqMm9Hb1Yr?=
 =?utf-8?B?bE0zSzVZZnlWakYzUlljK3laSytoUXhaOWxENFQxS0pxdWMzSGlUQytrUExQ?=
 =?utf-8?B?VkM1VHBQbVZ4UjBPVnF6anhvTG1RUmVTck1QMURYN0o3TmhwcXNldmxKS1hi?=
 =?utf-8?B?ZFpsSCtIWDEvUTVlQWhtYTAyZVM4Vjh4RHVwaDVpVDQxQzZEajVxbml4YTRk?=
 =?utf-8?B?RkZXVjhEV3h5NDJ0Ty9qaU0rNGM5WTF0ZndsM2RPL0RBUERVT0dhU3kvc3NZ?=
 =?utf-8?B?d1VmZlYrL0QvWGlGVFBxTkdKNmkvVnVmRHV2eHlIR0hsQWxwU1Z5TmE1d3o2?=
 =?utf-8?B?TkxOaFI0aHFHMTZ5NURXbGozZTN5U1RGdEQyY2x1bXI3NXZhdi9nQ1FlTnM2?=
 =?utf-8?B?cVZWTjk1UWhDRkRSRWJ0UXhVekEycXBVdUZIdjRrYnV0a2FQbWZSTGd3ZGs4?=
 =?utf-8?B?MDdZdFczT1kwT0hnbzl6d0lzS2VhVjdEYmpaQlFjSTc2RHJob3VsWU1IZzJY?=
 =?utf-8?B?RjltVU9oOFk3RUZyaXI1bDJRckVOMGJYaE9jNkU5emVMZzZzNFo4bnNaSnJP?=
 =?utf-8?B?QjZSQkw2TTF0aHk5VzNMYm1IclZpZHpnMmhrNFhFWS92cSs4UVJaWDRyekRU?=
 =?utf-8?B?eEQ4UzRrd01CK3lyNzBSWGxPUVhhbGFQQ1B1OEgyM1ZTTG56WDB6Q2JWVERZ?=
 =?utf-8?B?dHBTb05oRklYbDVVUEN2S0VnQjFrRjROTXpIcGxNaHFyRmd2aEFIeGdVU01q?=
 =?utf-8?B?L0s1WTJNQytud1VGTVo5YldnVnJGVWh5NXJjN204MVJINzRmUEVjeWtwQ2Vo?=
 =?utf-8?B?STZOWXlwbi9HVjRqTjZaWTZTbk9lYndacGg0c2dTenZGQS9PdUI2MDl2cDd0?=
 =?utf-8?B?YzBubTgrL1hTQnNUVnhGeDdnVTI4czRBQk5SeWZHdG44STB3ZUc0a2JkTkNs?=
 =?utf-8?B?ZkNXMGxKMGVYd3h0dWVyc3lkM0hnM1RqbUhwKzh5cG9jMy8ybEVBaDJTM3Rr?=
 =?utf-8?B?dkI0L1BBNTVvK09adHdKUmVUQ1c0YzVybVZwcjJ3SmFMdENTL3NYWVdFa1ZO?=
 =?utf-8?B?dDRodXZ6eHJlbDRpcUxSbXZ1SENRL2doOElSZXN5TnAzdUF1YndmVzk4Nm9y?=
 =?utf-8?B?dW00ckZPa01IVnVMb1ZzZ3JFcVFqci9hNkVMaHFOdUJDZmFydUlUNm1pRSsz?=
 =?utf-8?B?TVgvMVpHVVNFRnRCb2xOeUtqejlvTXpLYTdrUjFjS0NHQlV5bW9ZWWpiN1dU?=
 =?utf-8?B?SnU1em13R1cySkx2T2syTGpKay9HMHJOUnlsbndvYUs0ZEdIVkxnMGhtWG0r?=
 =?utf-8?B?ODZBRmcxaURmdEhtQUZuVHhRQTRtelpoODVjaTFyWmlMb2IyZ1hJMlI0SVo4?=
 =?utf-8?B?RTByT2FGVTI0Z3AzbmpnRExLTEtmQU5kZGZVUGxMV1QvRGh6QW10NzYxRVZk?=
 =?utf-8?B?dGJjTmUyRS9JRWJXcmpEOGtKQnIwSzY5WGx1RTBSL0NGcUhCYW9lYmU3OU9P?=
 =?utf-8?B?V1lBNG1NT1pjck5MbmVPcytXTFMwVWdVZWdSUzZYU1d3eVdSQUphNnJqV1VN?=
 =?utf-8?B?bjNoWVVkTk1LdnBWZVZldTdhcW1pQnpBZUdXNzRlR0g4bWdTbXNYZUU4NU9Y?=
 =?utf-8?B?NnlPakJIcmw5dFc4L3hXVEFQRU5VRGFZOHk3aUs3Uy9NVTZoRGc2bVJZRkp5?=
 =?utf-8?B?VU5KeXkvRjBwZWVxTVc2eDY4V2tqNXRGQlNOaHZQTjdnZmNIem4xaVhEWGNI?=
 =?utf-8?B?eDZTWU5Pckxac1J3cHpYektab3pqZmUzclVnMkwrU1ErYUVWTzJBOGc5RjNQ?=
 =?utf-8?B?bC9jL0x6a1IwS2Z0ZHVBNzNsVXlhZzJyRXRyUE8vNDRmRUppbEp3UThtN2pv?=
 =?utf-8?B?WHNyMVB5UzhjcUV6WVAyUU5tMU5jdUl2OEIrVlRFRkhiVUN4WEFBVElhdTh4?=
 =?utf-8?B?VU4vcFhwZjlWYzU3NkVxSSsxNGlXUmlnS2VhL3FKN3VCNFNIcTJxMzNDc1FX?=
 =?utf-8?B?MTczNmdFN1pjWTh3Sk9rRVI4d3diaERUMDQ4c01ORC84UU9pWjVOYTJDMkVy?=
 =?utf-8?B?U0FCLzcrK2JwY3NHZDhrakFqMStybEZGby9hR1FMT3FuRHVpd0N0L01vRm9N?=
 =?utf-8?B?dnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iT2pwiREf+CoCZcKqlCrjJ9va7aHHk9um8avDr91VsRwm1CX8RTCZfxtYAP/b00BVRr4a8XjTCt523Sl211mR96s1InqiEpqEt/PVFkujOqMcQj7Px7PNbhchI0P2dBg4ZLNYcyxKVuwOJTatTXilmY4BdN4donGC+Fru+u2ZDfbbwn0Y5XamxV8f8JECRhSDnW8whKghuDdvrLgeKm801YnvHeaH+L29pzYb3C6K/z0l1wFpKt2mBd9ma62WkJbHx2kkiwMGkEf70q7GhlrWGDQf94C6sv6LUj6LqxBVr1k2PJ63R4VhLASxDEW8ng998EyvFvBU6WPcdR9JcJREGW+I7M9o5WdQ4zOOfhX1yJ18HV7ZmpDGM7HnCo5K6Mzdu4RWXoXYIvWc+pqGrJiM7em60tj5Bg9IwDWVarJbub+hW4DU35h7gclnAn23xuuyBKAGfRAr8a6WukgG41Z5TcYRJJHJsiqn81lsd8JaOjz4oLhnsBs+exR8sfFQJy6arxm5q0dULnILQHsXc30LjSyIwYlC4+fyqINXEmRx9Gy/iezg+EEKTjIaU/dBpDJtgTO4reR5KtVbn8KQ17uLG5ubKTqkVImo7pLOeZdioQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aed3e128-90aa-46db-d417-08ddd3732c6e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 16:22:57.8414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3gDJhG9n2nhNYTWR4aEiHD0iUBi3OWp06wxyzAqsy0OF8k/D/ph02UCIWzEI/zFOQaLEYd1VgOZcEOR7pM1y6MNg3iHaxTkSqYYNRTyj6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5796
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_06,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2508040090
X-Proofpoint-ORIG-GUID: IPDLdQ1iAZ7dWfa3Q1ouD85d9C4kCuYx
X-Authority-Analysis: v=2.4 cv=HY4UTjE8 c=1 sm=1 tr=0 ts=6890de66 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=LDFJHRcXdElZQuq7yIsA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12065
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA5MCBTYWx0ZWRfXwdpmt74QrPGz
 LPNXLVgOvO2DGqdOJexG14HCaNymjzjOHndIZjnQ2Pf+0Mk4eUWMPNyq+ePqOicXKEmeu0+AX6a
 4nHXvJTROi/B8cfz3SNZsfQBJHzOEUQpW3o2vVEiJVpvvWqcTCynKZPN6vg/J+pa+YbZroKJC2X
 4SxgeDM68aM3yI7DPBaNCHuDwUHfDSlm3iZwLyrwSsQJW7QxWo2/wyWk4blA3OetOQK0EMkVw9t
 7eTc5zpEXoqxR3cKw0GfwMlKI+hug6SoLrEbIiQ5V1MvCy5je9O2RC4bsZke7XXQPWG9IyoNl9Y
 e3RQLaVGukeWlnprxlLaNRnFXAKv7LOzxAraSyrHCDYIFUIPHcakgddJ55ryJicmfY7GLQBdRzJ
 l1i3tPIy4y+sBTl6rOiA03IjFCq6+EXV9VVlO+zHro0342wAiXTZYLJN03P2FTcdCbcFf5rI
X-Proofpoint-GUID: IPDLdQ1iAZ7dWfa3Q1ouD85d9C4kCuYx
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 76B1840009
X-Stat-Signature: cytdqbfbejceswscuuboebuf4gfjxnz1
X-Rspam-User: 
X-HE-Tag: 1754324589-910335
X-HE-Meta: U2FsdGVkX1/5ePIcle4OVh6HukN6cnMrMfl9OswaWCZ9Sp+yRskU0TxbP3ye3hGyG8wJ+ZSCpkxLZPL50eD9/ODW9LRsnrDlpa0xi3BbS5ysl6vDPK+A9A6Jq1FQIHrzIid67ap3saovOgtN9ZFObsOg5vstSab3Zxnga0U7gRUuCMH4XLtSj9HnXo+9LpA8K6F9tWfq6TwRp1xXxFJUh7nWwLkZ4KJKCv3IaqceuW19S3jXFuwZX+Wxw8fodMkOQHrThE63+y4FlMMtYddmoOgdEbK41ZuIcYS1xYkbp7pfNxi9GKyUUj5IxgNRI22zlgaB49u7tnil8LkMuL+Bwt8kyzsZjXja/S+tCMAdvp2Y6r3LLmfytplhR6OqvDVzYNN33jdFuLCr1BQIudPd1A5vXQ221k0GdpijvRuR+pnxIGotM6+uYvm+EbAfdYQPXtcGhQtzneDybAgb43qNqGw2UCf3lsSBIwvqzqLGzAZFEs2y4sExOWalfpzKavGs5/eAKp2cDG4U+6kR0YQd2p4Mu2dEhVYpj6TjvIffdUOWzHDlXI2Ioa5iJfId2TPZOqqPaN1f8vYTF2RKdBGx6b3Pn3u3bXBAAptiA2gUUCTPzkt6EwmZlHu2ui1UZUWw1H3c0YBRkbDgnR7ilzD27YBJVJhNAdVaKFEishV3R8fub03t4yfYfnWkufHVGYsyFWcW2Zy3+9YOqwXcTnkTv68S9UW4JpGvWA7dz+wXWSImPUBFo4XiwsgU6lSzp1OguQHbj8yqfs2iGzPwILIJi3FAcLXGb1IN6HRBKMCEKGJ/Usnfh9ZU35HlPkGvDXjgHC65pQqTkEOsvYVJ2SVgBuOK069URdHGeIXatxyMW90//ZA4KvvQeJ0tgZBKOPY78VmnMrZpwzjttuThow98hmAUx3ZwPg2d/2T7Yvfkt2YKj344ixq/Im1Ju3QXUqakB/dVcoveqrw/ht1NbSH
 HDq3qdyq
 +T+pWJVHf1mgTd43UHkohyJEG3/hpaw/fImIyZHEul4YvwNt7U3f6u9rgdln3g2vs986OyCXkdrc5IlLqS6kAbpu/kBxhcl01SV5WUWBc57Y+BjCHekT9Ut6UXI7xKUV71IXMKvYK8zJIPaernTcwCzqzff4go76OxxzDFp6knYn61KFr3JMPVP7NMN51tf+nC9pl/bRpLSws7/7oevJfwc6zqy4A7X3oAEh4coWvQ3qJq6liCa565y9fsXnz9sUASZtxUxN2QxZrs0vy+8cS1Ao5KWDFTFp9btXOBisy2YRIET87muIheac95UWCm9zZ1OxwwYa59yfE1uSWs42xonj5AxOTJ3KUczfFN7zVooenTYnLHQ1AcPbiOhwfEjJyGEfdT2vbnlKNa4ChUqQiBjp2bnjgeb0tQgI5MQt9J7Kx52523z6IJU2mCKcJ3qddOmnv8FAlN/O96G/H8jJHeSTV2H2M0AbvJcNxjFB4f5A9FX6x2j43k6yD1gZt8QLwuNmKF9vayu+TnAMCItV5Re4WAwbxmw82YuqObim+r839W16f4oW/f3v3nUUMkejfUYJF+llPoFsteWDl6vgdKNbVPozuZzEiW5K3FGFXAbRlKSKF63iRfcmS/8Lnz6BDUW22DIAPpumRQAo1plHJzcC9ehpPA/6/4DmYpM2tShOYvWvxZmPejim77fAdBNB0Vl8MudVNj6I95UAM5IEZ7PNXdi+ww6Z0SuyNCjZhCg0amGs0RlUihWsN+wakBkRmskm/nU1Qwbee9U01VksGDg6AOChB+pKY4+i1Odk0ijnM+9sNNFLGcExCRQ8Ao8v2u1CiOyEiH6O5Dl4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/25 3:31 AM, Kefeng Wang wrote:
> Use order instead of struct hstate to remove huge_page_order() call
> from all hugetlb folio allocation.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> ---
>   mm/hugetlb.c     | 27 +++++++++++++--------------
>   mm/hugetlb_cma.c |  3 +--
>   mm/hugetlb_cma.h |  6 +++---
>   3 files changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 436403fb0bed..e174a9269f52 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1473,17 +1473,16 @@ static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
>   
>   #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>   #ifdef CONFIG_CONTIG_ALLOC
> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
>   		int nid, nodemask_t *nodemask)
>   {
>   	struct folio *folio;
> -	int order = huge_page_order(h);
>   	bool retried = false;
>   
>   	if (nid == NUMA_NO_NODE)
>   		nid = numa_mem_id();
>   retry:
> -	folio = hugetlb_cma_alloc_folio(h, gfp_mask, nid, nodemask);
> +	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
>   	if (!folio) {
>   		if (hugetlb_cma_exclusive_alloc())
>   			return NULL;
> @@ -1506,16 +1505,16 @@ static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
>   }
>   
>   #else /* !CONFIG_CONTIG_ALLOC */
> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
> -					int nid, nodemask_t *nodemask)
> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
> +					  nodemask_t *nodemask)
>   {
>   	return NULL;
>   }
>   #endif /* CONFIG_CONTIG_ALLOC */
>   
>   #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
> -					int nid, nodemask_t *nodemask)
> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
> +					  nodemask_t *nodemask)
>   {
>   	return NULL;
>   }
> @@ -1926,11 +1925,9 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
>   	return NULL;
>   }
>   
> -static struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
> -		gfp_t gfp_mask, int nid, nodemask_t *nmask,
> -		nodemask_t *node_alloc_noretry)
> +static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_mask,
> +		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
>   {
> -	int order = huge_page_order(h);
>   	struct folio *folio;
>   	bool alloc_try_hard = true;
>   
> @@ -1977,11 +1974,13 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>   		nodemask_t *node_alloc_noretry)
>   {
>   	struct folio *folio;
> +	int order = huge_page_order(h);
>   
> -	if (hstate_is_gigantic(h))
> -		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
> +	if (order > MAX_PAGE_ORDER)
> +		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
>   	else
> -		folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, node_alloc_noretry);
> +		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
> +						  node_alloc_noretry);
>   	if (folio)
>   		init_new_hugetlb_folio(h, folio);
>   	return folio;
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index f58ef4969e7a..e8e4dc7182d5 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -26,11 +26,10 @@ void hugetlb_cma_free_folio(struct folio *folio)
>   }
>   
>   
> -struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
> +struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
>   				      int nid, nodemask_t *nodemask)
>   {
>   	int node;
> -	int order = huge_page_order(h);
>   	struct folio *folio = NULL;
>   
>   	if (hugetlb_cma[nid])
> diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
> index f7d7fb9880a2..2c2ec8a7e134 100644
> --- a/mm/hugetlb_cma.h
> +++ b/mm/hugetlb_cma.h
> @@ -4,7 +4,7 @@
>   
>   #ifdef CONFIG_CMA
>   void hugetlb_cma_free_folio(struct folio *folio);
> -struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
> +struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
>   				      int nid, nodemask_t *nodemask);
>   struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
>   						    bool node_exact);
> @@ -18,8 +18,8 @@ static inline void hugetlb_cma_free_folio(struct folio *folio)
>   {
>   }
>   
> -static inline struct folio *hugetlb_cma_alloc_folio(struct hstate *h,
> -	    gfp_t gfp_mask, int nid, nodemask_t *nodemask)
> +static inline struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
> +		int nid, nodemask_t *nodemask)
>   {
>   	return NULL;
>   }


