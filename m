Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3799C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 13:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F21F6B0088; Fri, 25 Jul 2025 09:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C9876B0089; Fri, 25 Jul 2025 09:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 291056B008A; Fri, 25 Jul 2025 09:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 131086B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:49:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D3FB16074D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:49:09 +0000 (UTC)
X-FDA: 83702918418.08.F59F11F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id EFDFA1C0009
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:49:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mFRAROWq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sMdzW5JT;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753451346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VfwMWullMTl87fqaUJU10tRt4BjsmbRepcIOscUb9vc=;
	b=BzFoxmBXqQdYvETl1BR19cFqTkn5cmD5lONHN8cea4vYr0bevYCJZfxG5GH62rx2XBjZGO
	Zo+q/8Mdh0uEL4QXKDe8mc11mAjuna2gBdnD5cUN852EgelfD11E1pKyemlO1DTumdyuIO
	nTJeoUiEsYffKjqnYmxzXxX4w30bB0U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753451346; a=rsa-sha256;
	cv=pass;
	b=XAM1l3TVIvFAIY+9RY7rW8Wg/BJCkPcTz8onCeUcOBKijEBrxGpAfJaPDwWjBH5Q3DE+dT
	9peLmEPUdUu9EiichCuF0Dlw4hyr5hfHnv8tEhdpAFOrYLN07gV8H5L3ZqL8kLuZwwvAzg
	t2L6V20tNrqbq5XJsCQDzVmXw946mKw=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mFRAROWq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sMdzW5JT;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PDfrGj017872;
	Fri, 25 Jul 2025 13:49:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VfwMWullMTl87fqaUJU10tRt4BjsmbRepcIOscUb9vc=; b=
	mFRAROWqxODOTiZo0YMl1xcdR9+qdxGw8xW/Mivm61Juj2HYhRod2cpuBzzSUbPS
	Z/bVZ9uoqcTGiQP6PLYxCewfAY4n/CeqD2OU4xp6YtKN1t4Yo804zPebvGJf0t4K
	mx2APbuQl2ongS5ZHGOEHL1rUMUiBIIH8fiRjcV9SHUrOD8eWovUlyAyhAVBOASq
	wUqRNPpPT0FsMAnBLHXXUFAwhwU12mwpic5D3nOT9zu52c0zRQucrBEkBDD0BAJr
	G1F6GxToEHjrlxuuegxPemdj33cDE+hg0YWPWP3CkPlZ5ForoyrD0cn+12g8JVE4
	bb0p5e7azoaXExxev9AfMQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1jh34m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 13:49:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56PDZTCB005774;
	Fri, 25 Jul 2025 13:49:01 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801td38ad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 13:49:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ohvWSRgELh3Is1MS0DIPL/b9zWGQlw3SP4jAngnjrtOyx1bK7w+JMSDwW2t7qeAFlV10jx2rI8ZC1aQGoOsNUC0MJ9xdn9ayMibo+NSFfLAOnFtmWZIXuHCqFhdVS7hjj/1IxORhTjmnLix+d/xs1r5rLJsuWlpxLZmU2HPRJ6Lkw0J+aHUFN+S3ae6oQUUOwf50WSR5w9LuiQMOy+ggK1Y86ihekrQ/dO4/9Mt8IVZzBMPxCEMsGmdyuVRnQdycSmyuvc1NAZutNgGVhc6tZglrklNrhrcnrL5UPQQL+AQRRBjPqOwAXEMBkoziCZW0dZs1YcWC1des1WjEQudiWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VfwMWullMTl87fqaUJU10tRt4BjsmbRepcIOscUb9vc=;
 b=IMASpKYrFkL+ksnVUUVIuE8vPkI4O2CzVFms/4joh1rzbwzhs7LikVo14bCPRhqcPGPwIG896zl4XFdvDf6k/DIpKpGPuZrCdC0pp6w/k9SnpFTWVGQoRS24B0N78UOtT0oYGioj8Nrr2NYJYI+gnwFVVhwoEZvM/m814jhU4JS4AKklVdX4TPKlTomSfu0M0WP3oL7HufAJEvZGtXMRET6kIhImMwTx4Zwta06DcmIdnZHMPbO8Es4imrAt1gG5S5HojQL2V5NiSG+0aNQiwjXXHdBPILcyZjgrUyuRjJ6vYdkcDTathpcBVdMgJhrnR7W4YsbOJwxcDNexSFcDxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfwMWullMTl87fqaUJU10tRt4BjsmbRepcIOscUb9vc=;
 b=sMdzW5JTnJo6gyS0Ry0mSIwKvvZkCZyo7ylOQWx6fphYguESEqhtwtN3n605XxgxuKZwK/D74HNinEGcCDC4QBMq2p1gFFSf1ChdLVjBluOyS2JmriWmFtlSof435XKbkd8zZGEn4UpRr6/2fbrcLsnjQvSc89kGfzhl4sD1IHw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA6PR10MB8015.namprd10.prod.outlook.com (2603:10b6:806:438::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Fri, 25 Jul
 2025 13:48:59 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 13:48:59 +0000
Date: Fri, 25 Jul 2025 14:48:56 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Rik van Riel <riel@surriel.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
Message-ID: <50502c3b-903f-4018-b796-4a158f939593@lucifer.local>
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
 <c3f04c75-a73b-48bb-b56e-7b18e57c2382@lucifer.local>
 <CAG48ez31aVnoBiMMjUczbmThWnRGmod4yppgMVqf2Nu5-hjU2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez31aVnoBiMMjUczbmThWnRGmod4yppgMVqf2Nu5-hjU2g@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0313.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA6PR10MB8015:EE_
X-MS-Office365-Filtering-Correlation-Id: b5ad8364-158c-43b8-2d59-08ddcb8201b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UkE0d2xxSXNPRldWM25vSDVnNUU5dkZTQnRyNEZTZTJoMXlWNmJYSlRKclNQ?=
 =?utf-8?B?dTBwN0Q5dW1xTUJTZjFyRFFCb1ZDNnEyY1VuT3AvTndqN1ROd29BUDJvTlRH?=
 =?utf-8?B?b3pPUHh3WE02aDlSMGNZRm1zeTlnbWJyb3ZaUGFROTJYWVM3dVgyQWJBYm1p?=
 =?utf-8?B?d2laNEx6SzY5VW9uQXllS3N5N1ZtV1hHcVNtVlhLWjFSY2ltQ2Rwc08wN1A1?=
 =?utf-8?B?ZG04Mnk1aldsTEdHMjNtazJQbitQclR3TkJsVDk4T3VOQnFtTWd6NmMrUFB4?=
 =?utf-8?B?YmpqRVhRdkF5dmZZTGNISTVjdVRnL0gxT25CVEhBZkM2dHZYNzQ1NkdWelIw?=
 =?utf-8?B?eU4va3NTazczSnBwa25iVWkwcHUwOVY5aDJLNzhadnZ4b3FmemJBWU8zMjl3?=
 =?utf-8?B?ZUkzNVd4RG81UFA4QW5QNGVoK01JcC9ETDAvT0RzdHIra3dxTy84MXQzOFJX?=
 =?utf-8?B?aUxLcFB4ck9MWUJpczIwYm9Vbi90c2ZON3RpcUxrcy80cEM2UExKbU1GOEs5?=
 =?utf-8?B?ZkVkREV4RDh1TFNjeHJTdi94OUsrZFp4MWJQODlLaG1TKzdjTjlKNVRRZkhX?=
 =?utf-8?B?THRVd1NOTGFyWEJCMXhmRiszVm9TdUtzbitiWHp4bjYwNkdVbHR2WFVXdGVB?=
 =?utf-8?B?UmtMdkU1RmY2K2FIRit4V0ZteC95end5M29UclhJSU9WUC9GamdJNXYrRHhO?=
 =?utf-8?B?WTZEOXROdkhOV29BQXZvQUZzQVdrUENFYjd0My9jbER2VjVway9kQUc5aysy?=
 =?utf-8?B?Vkt1c0FodDBnRmZnaG0rVEFnRmJGZ0dOTW5NQVdkMFZCT0dXR1dUdmFLL3hy?=
 =?utf-8?B?NEdpT2htcnRoNWpYNUF4SVVUV3ErUzN4djBrRCt4blF1cUI2WE9aZWE5Nzdh?=
 =?utf-8?B?d1Y4Ti94bFZBSlM3Mk5ya2E4eFpKYmRJRmJNRi8yYytqeDNMWXNyMjRxck9Q?=
 =?utf-8?B?T0FOTit0WFkrenlaWmpBVjgxWTZuTW5sZVprSExTdlJsUFlhZi9xVWpiNlVU?=
 =?utf-8?B?dGhlOHdqd3FxRmlpbnJqQ3lBOVErWHFLRnNhYURjY0RwM1UzcmpXU0kvK3hs?=
 =?utf-8?B?QnNPTHhVNy9uZVFOSGJzOHQ5dTJYNzF4dVZYQXpiTCtncW84VEMyWlZ5WkZv?=
 =?utf-8?B?NXpRbllwcjlPaFN6U0I1K1N2OXJqU0hESGVpOS9FNnQxUW4xeGU3QzFMcEhD?=
 =?utf-8?B?U2g3TGtsUnBaa0szNVNCUVUwdTNkNFZBcE54VGQ2V1ZQclVpcGpZVERFcWN3?=
 =?utf-8?B?MjdsZFJxbGlNVWxjaldBeUdkWkcwQTZxZi82Ym9GbllRYVhaYkYzekwycUd2?=
 =?utf-8?B?enZsN1RBdHhnQU43SzBCWGovSlBJOWNpWmJQUUJYWHJ1UnZEU2R2UGo1cXYz?=
 =?utf-8?B?VDlEVmkwcVJrZnM1QUVmNGF6YTlyaHQ2bVlRZGFBSUt0UW14NFVSRE5Bem1n?=
 =?utf-8?B?WkhoVUZabHhnNWwrNVhqM3VIU3JydzlKMVR0eVhhbWZ3MHFIRlFvenM2M2FQ?=
 =?utf-8?B?YUpiTGdML2diZm92UzRnQW1RQ2dlb0N6MFJIRE9zV1Vucm42SGlwSXJpS0xG?=
 =?utf-8?B?TFJTRzFTQjZhWTBKQnRmclRGMVlYTFNFcWYrdnV5VkpWWEFmbjlGV0hiL1Vn?=
 =?utf-8?B?RzVMek1CbHR2R1NSSE5YZ25kS2JiUEw5SW9ReWJaQUlmSHVWeXFLUlRKckJw?=
 =?utf-8?B?RVM3eUFjM3pUQkhsVkRNYXprUnppQlR6MzcrV0N2UHgwN1NHNFlaZFI2bm5V?=
 =?utf-8?B?ZTJCYjRaVGhPOGVwSHNVL2kyMXRkZENHY1R6NWxKRTZrekxjWTdobzFPVHMy?=
 =?utf-8?B?cHk4Vzd2a1BxMmlwMm1xZnpEa3VOdXRvOTlTNFdHTHRiRDBhNjNPYXdIU2Fh?=
 =?utf-8?B?WEtCc0dtUzM4cHBSd3N0UHRMN2J1NVZKTTVaR0l5YTc5VkZVWmJlUjh6LzBO?=
 =?utf-8?Q?WTrJbO5t/rY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTZHcERRRzU0K2VNRWhXZXRFMDNkWWRRWENFYWtUMU52TzNEMnpSUm52V2FU?=
 =?utf-8?B?ZEVnV3pqVDZsaDRGYUt5RFR2Z1hDeXZlWXNzSmpNWFB1c1VXOFpYMnlWZmtC?=
 =?utf-8?B?NXBnWEN4M0U4OWZKUFliQm51cVV4SVVybjduaXEwcUw3K3FrbVY3K0h3c0Fj?=
 =?utf-8?B?dE52MXhHbGRtSXNjalZ6K3NadjluVklVUXprbzFnZ2V2dFZVUjJHOEZMYlJX?=
 =?utf-8?B?QzBYYjBHSkpUL3RNblR4aW1Ndk9oekZ1WnpUSU03NDRQSVV0RGJZZyt5dlBv?=
 =?utf-8?B?cU1xeURvRVc1VWpJUzlnbzRlU0FSSzE0L0VpTHYvSXlGZUJCUkRKVXBuNVI3?=
 =?utf-8?B?U3F0aXZpOUZmUFlnVmNaaktCb28xc2JwdEpsS1p5VkMwajBUWFRscG5Wbkc5?=
 =?utf-8?B?TGtZZHdKV01RWFI4RjBXVis5c2V5L2N2SW9lMjFBYjBYbnVkbkJaK3grakg4?=
 =?utf-8?B?SkIvcVBaQVJyRW9VS3pWMFlUclJndGFkeUNFbGhma2lDWjZ1YStNMVhxdmxZ?=
 =?utf-8?B?dUx2eE94R0RkM0d5SFlaV2hiVUZZUk9xSXVCNFcwTXhmeWVESmhld2hPV0E3?=
 =?utf-8?B?VDlaR3pKSWJQQlJsaWVCWTUwNFBadXJ5UjNMbnRTTm51VGJQNUtrWUtMb0lS?=
 =?utf-8?B?Ulovd1RsM2hHL2VPZDdoODdIN0xRVTVJRkFkcnpEQUZzQXg2RkpSaTlHSmZH?=
 =?utf-8?B?aEErRXVCZnhBb2Z2MVAyVDZUUElCRTF6TEx3ZVlkK3g3SGQ3bnJYNnd0K3RR?=
 =?utf-8?B?OXJsYXhOTXg2OXd0dkc0NHNsWUcwQ0k0Zy9kWXNhM0czQk5Ia3VzMVlxRlM1?=
 =?utf-8?B?ZlY3NC92UVN2bVEvTitONXFYdWhDWjMrcVRsMjZXbkhSYWNzQ3JiK1EvK2VV?=
 =?utf-8?B?YmtpY2dEQmdTRzUwZEVGbjB1ajVkK2V6K2czYjVHWkM2UDBpRFhMRGVmQ2pX?=
 =?utf-8?B?WXNKZlN0bGo3OGE0ZnBXS3IrS0JZb3dvL2JaK0d2QktSQ3BRaGh4Mmg5SGdB?=
 =?utf-8?B?Um9MQ0tvK1FCSmJqaFRRdU5nT1BuY3E0bEhRMWdZcWVqTkkzRWVZeE1oSnQ1?=
 =?utf-8?B?SktkTmxUSHZteWwwNXFDR3IyaTlENmlZbWZGRkhNRmtPbUFHV3B4RG8vYWRF?=
 =?utf-8?B?QlZlZ1IrVmRtVXEzQVloK3E0RkVlSXFUb3YwSG81cXlabGtzQ0JPL05TcTlM?=
 =?utf-8?B?Y1Azd2wzSk1IQk5Od3NzWXpJaE5EOCtqWGhiNStaTXltQ0xVZXl6bG9zMDZk?=
 =?utf-8?B?YUI3QkQrUE9JUC9UTHdlRmI2RTJtZGZvUkZGa1ZxamoxVEx3UXROQVhJQmlz?=
 =?utf-8?B?S1djYzdudnh1RkJIaFBJdCtzOVc3dFAyOWFoRTFkeUdqWE9weFpPM1o5Zlc0?=
 =?utf-8?B?MXZyNHRSVWM2TVhxclIyaUxweTdHOVFpS1hJTXg1dHZvTUxWOE13QUFzMitB?=
 =?utf-8?B?UnVwTGMwSTd1Z0JVTGE3ajRCRmhqRmk0K3VtQWtncFp1U2ZjaTlVQnZCWjh3?=
 =?utf-8?B?VE5JeXZydnRwZzlCeFVObmUxaitGWXJ1QnFRQk9lTGhqTkZ1ZE0wV3lCb1JR?=
 =?utf-8?B?Ry9DYzRMOHRtL0pJUlFXaElpUXc1RWZkdmxEWUhEbUFHN0ZnL0paRFpGRUla?=
 =?utf-8?B?N2tCaUJIWjVDRkRsYW9WMlYyTHVrSVZVMWs4U2ZWS0NCSXpZZzZLakdyUEhl?=
 =?utf-8?B?NFQweWR0YWVWRXJtZ1RJU2Q2WExCS0ZNdjdjVzNWeDhQTVJraDZKTEVycjB4?=
 =?utf-8?B?eVhrb2ZEd2llSjdDZk41VzZQRU9Fa2pydkJDanh6c1RqNzhhUmk2RjY0VDRJ?=
 =?utf-8?B?RXhvMWxsdW44SWkwejNiTUpycUIzSENYNHA5QzNGZTdOK2VHbjFsYlI1WDZq?=
 =?utf-8?B?Y1cwRmNQTm9aOU1WNkpnWCtNYXBxVjUvQ0RVbWFxQ1JaNmNwZVNVSmIzU2tH?=
 =?utf-8?B?RmNmYmJ6ZWtySnJCem44a2VSdHM4ZC83dXF6YWxzcy9QcFRGL1dEZ3djYWRL?=
 =?utf-8?B?aGx6MSs4ajFJY1p5enFXMlM2Z3NYOFdienNCMmw2bitlWU9yYWxTaVlWSmx5?=
 =?utf-8?B?azlMRlZLcU1lQUtJYkNsQWsxbzNPaitveFArUXVTcE5jSHRRMGxjTWh4SVQ5?=
 =?utf-8?B?Vi9mTllXWjRkQ2dJYjRkbFlHb0NhTDJXMUpFTjZvcUUxakoyamxSaHVJbFNw?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aMEZIFXLC5Uy4jwRy31PkDQz7uzuzTqyCQb0pGuHQvLvh6ILlndT7lSz+1h2rSvyh/VTMp8MJDtW30QEziIgRIVQO2YkS5Gkq69fCei7VgkDyTDRrsSx8z3hnyZ6cG51jQfmUzRYVJqnXNyZJGEpexxEP/+M273HCj/3uCE0TO4ZX5mTkTGHq3F8AQHqYfLGBWhnje5ZzyCJQTEd1dHi9hAGaxs98NnrkKp/sCgFZsD1mRly0ryAV0i3EQtKb1czDBbrvfFJu48V0ooebEHgBovMi7PxnJ0OCCz/uISDhdYMIuckske41gIn3hdTrvOM0hkm4XkdQ/SGyYoDNLhnbmpHYp/DQpLUF51REzpyUCk+ihMU5WyprEuvD7yJ87ul500m0JsqY+QkS/ENLI2XecnjcQxml21kRPfyxmdSX2YRkae3Oes3AZA1U/NYF958y6y3zH3dNxO1C8unYoBI8ePKBdnM4u9KgGkn1TP/oW/gl/2D40ECvbHFkDZgte4iAt1mqsIIW6x/bWOOV5vtmyM0/3VQgTcK6v4wRMgpV5R+oIW6+nNy031a5SrOLY/bqwYuhoMHQjjpE7/xjCxrgCt8TJhR45gEy+sbIt+cMNk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ad8364-158c-43b8-2d59-08ddcb8201b2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 13:48:59.2977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AdlNV1rSciGLIHM9Nw5tutKI9j+6CD9bLg+K4bGllVbQ64mMsn6Uh8WNNl+iHu8HhhZAVkvUBpR2OjlbWuVxElG0LDvWUt097km55e8tqTg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8015
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_03,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507250118
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDExNyBTYWx0ZWRfX7jtamWqI6tiM
 QnqoZEk6mfzvPl5b2iO9dKqggVwnOD7JcutBiR7z1SlmQ8rrn9xysDnZFczweQD8Hax1sTt1tX9
 zp+9Ra+f84HMtP9YUwBa3KVcVeCvgfDEnnidwj6CgJLAwLoC0cSjW6TT8uLbdYq6UTsh4E9oj4j
 VOSNN61r08/5izoVQ9VajhWbmXJngwSoeT42vEwNtJ5I0zksRGPqPV/q+fwSLBIefK+E1VwUFt9
 4fXv7fsALpSOXD5b9pcrIKvfJCdS8SDej3st2nGo2xRjbctUJcQBEeuIL0kgncpdgm9NeLcUXDe
 MJdjfR0zm4I4Nhfn7WDtgDK9fT9oXrMje2b/xFWp/DP6sQEF0e+/D2Vk35JV6rjuQEB0Gi6Cel/
 DHEQLpTNYshrSvVrkRA/IF+/BPEglgCHTrfsqlbFP4ycNNvrprfGTMVGFdkZ5oZRsMW0Tf2w
X-Authority-Analysis: v=2.4 cv=W+s4VQWk c=1 sm=1 tr=0 ts=68838b4e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=pT2omL0wxwnFCBA8yhgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 0F3WEUN2oLidSHdIVFrsPEILIlJRCMZE
X-Proofpoint-GUID: 0F3WEUN2oLidSHdIVFrsPEILIlJRCMZE
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EFDFA1C0009
X-Stat-Signature: t7ofhu5ai6q7xqx8r5rw7jjg11jkqwm3
X-Rspam-User: 
X-HE-Tag: 1753451345-88969
X-HE-Meta: U2FsdGVkX18FoWHFtadM6YGHg5x+StdBhMJDBA3RcnM2hXwEbmtOknwXqJgubE0gQ/M11eJTcp31euyW/RDZ8l+fZvLyFWj2B7gHec4ZlD2dqR5DK3UDMeDHIqVwCRacPT/yOvteXH8q8LU8V+f/bhhER5Xbe/1RT8DCfH58O0FAbEFPze+Rk5fh7SBJnZa1Ec2Z7Kv8lZ0AMtfytSB7cUZ/6dTtDQ1QAKfvDBcrIrwd9LMCAvcAVNhCbyeea76pCWcCPzzdHI2liFiKu/Y2c6t213yAB3SZkLMljI1aGl5x2WkxDfZiXS1K0UYzt7IRgtvoOfvyWp98VvmLq4CWLrT0/wOoP7OJ+0zhxQgdGv0qW1Q16rYaTUG7NKaK/bzq8oAnp69HlaARjs39KGaiBUfz0HznRq0BxuIWHahussk26agEdqXPUQQFbad1buplgnnG90wJtOCUQDRqkGYlqB8GJxjPeL/PNzPr66UOKzX62MzNGshuU8Yj0pcTH2P5eruKs8v8zGGyWLNRfcL9ff4N8RezMl0i/uonaZJXHuGSCxGuD06I/oHzL+enLVOCkB8/pdgUVDbYAKMlo8T4r0U3C8clPp2GpSpRAGfcAPlbETzc6A0zHW3VSUWvGHJcnlvVI4uWK6CKd5R9hoJYZeSb6OXIMrcv4cbsbALcKkKy9E5JQ0278JxvqidxR5OrYEy1h9Q1o6wjZwOZ52bNm3SQJTYEfioHA09rXbv7RaAyDHWX4lKhsKQfW/DN8qF41Fv5gdvGQtfrdEcWbfmCBcd62eRn4B0fZ31F5QFK3KfQxQPUg0RrggCxvnHgogJBIjCTF0Ek8iwnIJy0o+Ld8GkS2uiux+21TPcFtJl3tGDoEsAJlns5ObEfhOkk+wuK6TeMpj551SuJ0O8nwaRhukfDjYp+3KyYBl7O33bKcmU6GQd5UPaP0QAwmdUhQkY+kYA86HmnsUqiTZIyXmB
 m1afAumW
 RJq+SMbepiF2GpJ3fAhVdk8OnQvscvshFBHs/pHqmrqhhBe1USZKWdQ6TuesTz7jWWBwiEN/Uyh3JYMLNuSMjqqJjzyi7KLccgTzuvm4nj3MOuemaDHVCqWeEeZrZUkig0AwWsjewywW659EAvrQLYzcbtao6ojpBlG+OuAnyh7hcMuVHF+t9+fbEVe1B3sVi9CZjGgoy2g6rySzcCNHVyvSlxVxjem2NQN0ZzbiQZBw82dClcvXY6OYWtQxUH8+djToDzuio6wL9RFhrR+K56uTFwnTiIXBdlT4BsVylBpNWvI3GNyEPsOUjD/DTf3rKF7C2eWSuPFYLLwaPrHo5BwQTOqM6YbduBJO2leTurrErvJebNLLYf1ivI3+1vm4azYCWqtBKG39S0c7lqVRtY6lOAkvzA5mJNp//Pr9raczk2Oh0gTgR8J2qZWARgw/LEOy04tZ6P2lw/w4HzzdTONGDoo5JVmfRgHAAVAWMU4Oy2ywSWtaYKsFgEU0EsDUaYleLw37rse7dthp5JctoCG50TkSXGycCbYLE4sCWVPlHey+a1cVPR9kQhnhJwzpXNDmWa3HCi4m9j23VnKbnxFcm8MhibvGlTGDCr31RD2CecjZ+SNLXNF0ITq2Yi0/93PaetE2ljAJE0QvW3lwXpmcnscEJflGhtKHsPzlFMFL55Zk3Bq1Vf7HJsG2Dz96r23ghTzSGRcN2aKm7iFtdwQ/hw5ljj5kQUxaL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 02:00:18PM +0200, Jann Horn wrote:
> On Fri, Jul 25, 2025 at 1:32 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> > On Thu, Jul 24, 2025 at 09:13:50PM +0200, Jann Horn wrote:
> > > If an anon page is mapped into userspace, its anon_vma must be alive,
> > > otherwise rmap walks can hit UAF.
> >
> > This is extremely weird. I guess it's a UAF of vma->anon_vma
> >
> > Because we:
> >
> > put_anon_vma()
> > ->__put_anon_vma()
> > ->anon_vma_free() (also the root anon_vma... interestingly!)
>
> FWIW, the thing we're trying to access can't be the root anon_vma,
> since KASAN says the UAF'd object was allocated from anon_vma_fork.

OK that's interesting, this is data.

I wonder if related to anon_vma reuse somehow...

>
> > But none of this obviously updates the vma to set vma->anon_vma to NULL.
> >
> > So yeah god almighty. To get this, we must be dereffing vma->anon_vma
> > somewhere unexpected.
>
> I don't see how vma->anon_vma is directly relevant. I think the
> relevant things are:

Yeah sorry, I'm reflexively assuming it's a VMA that's the issue here. I'll
dig into the syzkallers when I can to get more insights if there are any to
be had (maybe this patch is the difference on this).

>
> An anon_vma is only kept alive as long as at least one associated VMA
> is still alive.

Well, including child VMA's yes.

> An anon folio may outlive the VMAs it comes from, so it may also
> outlive its associated anon_vma.

Yes, I will share some diagrams I did a while ago to outline this. They're
ASCII and make you want to cry! :)

Hmm, if non-root, I wonder if we

> When an anon_vma goes away, it does not clear the ->mapping of
> associated folios (this is an intentional design choice).

Well it can't without having to do an expensive page table walk, so
obviously by design yes.

> When an rmap traversal wants to go from a folio to the associated
> anon_vma, it (under RCU) checks that the mapcount is non-zero, which
> implies that there must still be associated VMAs, which implies that
> the associated anon_vma must still be alive; and then it dereferences
> the ->mapping.



>
> I think the ASAN splat indicates that syzkaller must fairly often get
> into situations where the ->mapping pointer is dangling despite the
> mapcount being non-zero, but syzkaller likely only actually hits the
> UAF when the kernel gets memory pressure by chance and does rmap walks
> on the reclaim path.

Yup.

>
> So there are several invariants we're relying on here, and breaking
> any one of these could allow an rmap traversal to cause UAF; a
> non-exhaustive list:

This is good, because we can start to really lay out these things. This is
also vital to my anon_vma work.

>
> 1. An anon folio is only mapped into VMAs that are associated with the
> folio's anon_vma.

Correct.

> 2. Removing an anon folio mapping reduces the anon folio's mapcount
> before the VMA can go away.

the anon folio's mapcount? You mean the VMA's? :P

> 3. VMA splitting/merging/forking properly preserves the anon_vma
  association.

I had slides for this for version 1 of my LSF presentation, not sure if I
kept...

But yes it does fundamentally, in a slightly typically overwrought way.

> 4. If the anon-exclusive bit is set, the folio is only mapped in a
> single place (otherwise swapout+swapin could erroneously set
> RMAP_EXCLUSIVE, causing the swapped-in folio to be associated with the
> wrong anon_vma).

I believe (David?) swapin can cause this not to be the case?

> 5. When a VMA is associated with an anon_vma, it is always also
> associated with the corresponding root anon_vma (necessary because
> non-RMAP_EXCLUSIVE swapin falls back to associating the folio with the
> root anon_vma).

OK but we know for sure the UAF is not on a root anon_vma so it's not some
weirdness with trying to access anon_vma->root

> 6. If two VMAs in the same process have the same ->anon_vma, their
> anonvma chains must be the same (otherwise VMA merging can break
> stuff).
>

What do you mean the same?

If you mean they both must have AVC's which ponit to the individual VMAs
and each point to the same anon_vma, yes.

Then we see e.g. after split anon_vma->num_active_vmas being incremented.

So in relation to this, as to assignment of vma->anon_vma or not:

1. Where vma->anon_vma == anon_vma A.

2. Where we fork the process and the new vma->anon_vma allocates a new
   anon_vma to vma->anon_vma B, whose parent, root fields reference
   anon_vma A.

3. We can end up with anon_vma's where no vma->anon_vma points to them, and
   folio->mapping (masking lower bits) == anon_vma, but then the refcount
   should be 1. Also I can't see how you can do that without a
   folio->mapping pointing at it:

Process 1

     |-------------|
     | avc         v
  |-----|   vma |-----|
  |  A  |<------| avc |
  |-----|       |-----|        |--------------------------|
     | anon_vma    ^           |                          |
     |             |--------------------|                 |
     v     rb_root |                    |                 |
  |---------------------|               |                 |
  | refcount = 3        |               |                 |
  | num_children = 2    |<--------------x----|            |
  | num_active_vmas = 1 |               |    |            |
  |---------------------|               |    |            |
                           |------------|    |            |
Process 2                  |                 |            |
                           |                 |            |
     |-------------|       |                 |            |
     | avc         v       v                 |            |
  |-----|   vma |-----| |-----|              |            |
  |  B  |<------| avc |.| avc |              |            |
  |-----|       |-----| |-----|              |            |
     | anon_vma    ^                         |            |
     |             |-------------------------x--------|   |
     v     rb_root |                         |        |   |
  |---------------------|                    |        |   |
  | refcount = 1        |<-------------------x----|   |   |
  | num_children = 1    |--------------------|    |   |   |
  | num_active_vmas = 1 | parent                  |   |   |
  |---------------------|                         |   |   |
                                                  |   |   |
Process 3                                         |   |   |
                           |----------------------x---|   |
     |-------------|       |       |--------------x-------|
     | avc         v       v       v              |
  |-----|   vma |-----| |-----| |-----|           |
  |  C  |<------| avc |.| avc |.| avc |           |
  |-----|       |-----| |-----| |-----|           |
     | anon_vma    ^                              |
     |             |                              |
     v     rb_root |                              |
  |---------------------|                         |
  | refcount = 1        |                         |
  | num_children = 0    |-------------------------|
  | num_active_vmas = 1 | parent
  |---------------------|

UNMAP B

Process 1

     |-------------|
     | avc         v
  |-----|   vma |-----|
  |  A  |<------| avc |
  |-----|       |-----|        |--------------------------|
     | anon_vma    ^           |                          |
     |             |------------                          |
     v     rb_root |                                      |
  |---------------------|                                 |
  | refcount = 3        |                                 |
  | num_children = 2    |<-------------------|            |
  | num_active_vmas = 1 |                    |            |
  |---------------------|                    |            |
                                             |            |
Process 2                                    |            |
                                             |            |
                   |-------------------------x--------|   |
           rb_root |                         |        |   |
  |---------------------|                    |        |   |
  | refcount = 1        |<-------------------x----|   |   | We keep empty
  | num_children = 1    |--------------------|    |   |   | anon_vma round.
  | num_active_vmas = 0 | parent                  |   |   |
  |---------------------|                         |   |   |
                                                  |   |   |
Process 3                                         |   |   |
                           |----------------------x---|   |
     |-------------|       |       |--------------x-------|
     | avc         v       v       v              |
  |-----|   vma |-----| |-----| |-----|           |
  |  C  |<------| avc |.| avc |.| avc |           |
  |-----|       |-----| |-----| |-----|           |
     | anon_vma    ^                              |
     |             |                              |
     v     rb_root |                              |
  |---------------------|                         |
  | refcount = 1        |                         |
  | num_children = 0    |-------------------------|
  | num_active_vmas = 1 | parent
  |---------------------|

4. But they can get reused through the anon_vma reuse logic:

FORK

Process 1

     |-------------|
     | avc         v
  |-----|   vma |-----|             |-----------------------------|
  |  A  |<------| avc |             |                             |
  |-----|       |-----|        |--------------------------|       |
     | anon_vma    ^           |                          |       |
     |             |-----------|                          |       |
     v     rb_root |                                      |       |
  |---------------------|                                 |       |
  | refcount = 3        | (self-parent)                   |       |
  | num_children = 2    |<-------------------|            |       |
  | num_active_vmas = 1 |                    |            |       |
  |---------------------|                    |            |       |
                                             |            |       |
Process 2               |--------------------x------------x-------x-------|
                        |                    |            |       |       |
                   |-------------------------x--------|   |       |       |
           rb_root |                         |        |   |       |       |
  |---------------------|<-------------------x--------x---x-------x---|   |
  | refcount = 1        |<-------------------x----|   |   |       |   |   |
  | num_children = 1    |--------------------|    |   |   |       |   |   |
  | num_active_vmas = 1 | parent                  |   |   |       |   |   |
  |---------------------|                         |   |   |       |   |   |
                                                  |   |   |       |   |   |
Process 3                                         |   |   |       |   |   |
                           |----------------------x---|   |       |   |   |
     |-------------|       |       |--------------x-------|       |   |   |
     | avc         v       v       v              |               |   |   |
  |-----|   vma |-----| |-----| |-----|           |               |   |   |
  |  C  |<------| avc |.| avc |.| avc |           |               |   |   |
  |-----|       |-----| |-----| |-----|           |               |   |   |
     | anon_vma    ^                              |               |   |   |
     |             |------------------------------x-----------|   |   |   |
     v     rb_root |                              |           |   |   |   |
  |---------------------|                         |           |   |   |   |
  | refcount = 1        |                         |           |   |   |   |
  | num_children = 0    |-------------------------|           |   |   |   |
  | num_active_vmas = 1 | parent                              |   |   |   |
  |---------------------|                                     |   |   |   |
                                                              |   |   |   |
Process 4                                                     |   |   |   |
                           |----------------------------------|   |   |   |
     |-------------|       |       |------------------------------|   |   |
     | avc         v       v       v                                  |   |
  |-----|   vma |-----| |-----| |-----|                               |   |
  |  D  |<------| avc |.| avc |.| avc |                               |   |
  |-----|       |-----| |-----| |-----|                               |   |
     | anon_vma    ^                                                  |   |
     |             |--------------------------------------------------x---|
     |                                                                |
     |----------------------------------------------------------------|

God simple isn't it? ;)

I verified these numbers with drgn, interesting add a new child doesn't
increment refcount...

> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Thanks!

No problem, thanks for doing this!

>
> > > ---
> > >  include/linux/rmap.h | 13 +++++++++++++
> > >  1 file changed, 13 insertions(+)
> > >
> > > diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> > > index c4f4903b1088..ba694c436f59 100644
> > > --- a/include/linux/rmap.h
> > > +++ b/include/linux/rmap.h
> > > @@ -449,6 +449,19 @@ static inline void __folio_rmap_sanity_checks(const struct folio *folio,
> > >       default:
> > >               VM_WARN_ON_ONCE(true);
> > >       }
> > > +
> > > +     /*
> > > +      * Anon folios must have an associated live anon_vma as long as they're
> > > +      * mapped into userspace.
> > > +      * Part of the purpose of the atomic_read() is to make KASAN check that
> > > +      * the anon_vma is still alive.
> > > +      */
> > > +     if (IS_ENABLED(CONFIG_DEBUG_VM) && PageAnonNotKsm(page)) {
> > > +             unsigned long mapping = (unsigned long)folio->mapping;
> > > +             struct anon_vma *anon_vma = (void *)(mapping - PAGE_MAPPING_ANON);
> > > +
> > > +             VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0, folio);
> >
> > Maybe stupid question, but wouldn't we pick this up with KASAN? Or would we
> > pick it up far too late I guess?
>
> I mean, it depends on the exact nature of the issue. If the issue is
> that we somehow end up with anon folios mapped into VMAs that are not
> associated with the anon folio's anon_vma, then I think the only time
> we'd notice would be if we randomly end up doing rmap walks of the
> folios, as syzkaller did above.

Yup. This will trigger on __folio_remove_rmap() and __folio_add_rmap():

do_swap_page() / remove_migration_pte() / remove_migration_pmd()
-> folio_add_anon_rmap_ptes() / folio_add_anon_rmap_pmd()
-> __folio_add_anon_rmap()
-> __folio_add_rmap()


vmf_insert_folio_pud() / set_pte_range() / insert_page_into_pte_locked() / mfill_atomic_install_pte() / vmf_insert_folio_pmd() / remove_migration_pmd() / remove_migration_pte()
-> folio_add_file_rmap_ptes() / folio_add_file_rmap_pmd() / folio_add_file_rmap_pud()
-> __folio_add_file_rmap()
-> __folio_add_rmap()

I guess we aren't interested in folio_add_new_anon_rmap() as we won't have
an existing anon_vma there

>
> > We're sort of relying on this
> >
> > a. being a UAF
> >
> > b. the thing we're UAF-ing not either corrupting this field or (if that
> >     memory is actually reused as an anon_vma - I'm not familiar with slab
> >     caches - so maybe it's quite likely - getting its refcount incremented.
>
> KASAN sees the memory read I'm doing with this atomic_read(), so in
> KASAN builds, if this is a UAF, it should trigger a KASAN splat
> (modulo KASAN limitations around when UAF can be detected). Basically,
> in KASAN builds, the actual explicit check I'm doing here is only
> relevant if the object has not yet been freed. That's why I wrote the
> comment "Part of the purpose of the atomic_read() is to make KASAN
> check that the anon_vma is still alive.".

Hm, I'm confused, how can you detect a UAF if the object cannot yet be
freed? :P

or would that be the case were it not an atomic_read()?

I guess this permits this to be detected in a timely manner.

>
> > Which is fine - because hey this is the only way we can get a hint that
> > this is happening, but I think we should describe what we're doing.
>
> Sure, I can make the comment more verbose.

Thanks!

