Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA514C87FCA
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 23:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0886B0088; Sun,  3 Aug 2025 19:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B613F6B0089; Sun,  3 Aug 2025 19:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28956B008A; Sun,  3 Aug 2025 19:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 902766B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 19:39:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0B42C065E
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 23:39:58 +0000 (UTC)
X-FDA: 83737066476.13.A61A348
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 18A7080009
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 23:39:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=coXY+CJT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sI7f+cKu;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754264395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpgEAELLY0AXwE0EWmISOwmfte1uFLC9cmNd6GpeH9Q=;
	b=DZFvDdpc1qvQYg4xOrw0aAsqJTq8vydvP4LggmFMe9eCxJ2wQIKbMCyTyaUSVrvOVevTq0
	F7OLr/S/41Dd88QD98tX1b6J2fm8IV+v9ejieBYh4ZKtHbxmt7LTsefXSPSeS7J2/BaNbP
	kYE9DBi5oa4I9xuFRPn6aL5sdeT69xY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=coXY+CJT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sI7f+cKu;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754264395; a=rsa-sha256;
	cv=pass;
	b=y1fvI7A3UV1Ef6C0QdJ9K3v1ZhyHCnKkTPI7w19P4UeBGTb3rxpYuIDvGyn1NvsDdtults
	FaB3LtjzZN5UzC1B172CeaYpOZ3E4QVIG1cw76QqHAu5RG/+MccDD0PasFiLEr4CCUgUIr
	8H/5MgQJJZl2Dmkm6bzmcLsYri4gyBA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 573K4YaA008481;
	Sun, 3 Aug 2025 23:39:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fpgEAELLY0AXwE0EWm
	ISOwmfte1uFLC9cmNd6GpeH9Q=; b=coXY+CJT5+mplzww+tvlqZLwXUpjiIGowq
	ZVNTbHJqVseV+Af0jEXEMyptUZ6cKfahPMgDX96qJNqktXbqukBDqGcOfW4976Lo
	EMIyPaAyOlQqO7yAPBkA19/c62G0MMy1uoY3hs6J7bKHL+BYze+cIhzj8cBSYCen
	hetnyRvNPjpN4E87pK5icjIF2XBymprQhMKtmAFtqOfaXdPuMQZHWMelmeqs2gJU
	4AkIPMDrZFnbMd+jqM2/rEBB82AcTNGcLaUpxxPu0BvaXDCs7u8Zx4C8DGGzNnW9
	DG5Op3RHXQgXKAgoZWWIuuVWu/+DBVRUyTMIiNfBhQShZhHS2cFw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489a9vsjn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Aug 2025 23:39:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 573NDjE4025358;
	Sun, 3 Aug 2025 23:39:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7jrrhmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Aug 2025 23:39:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZxpPjG/noO8ii0t0zAashcM7v9PVqiHyTzUblinE9TksKFnpg98joahRtzJOtbd36YtnRd4KA8+U5g6tv9pyDTJi72k2hzqMhz+dni4Az/VgwAo/KIjbHI+goe5MgHfmjS3PlDNvs2qlhh31XEjKc2eHZspUKyYuDoOxlMPujbue5Sgl56VYMqdjPR5bZ0/NLBhBHCrcsmqyeorPlVWk6vRc7hcQ969GuEutjoeuBacVkdKFJWFgEaysV83Cq4LomPNyJ6Q5aa2XlW7t3yRKyyGBsLtrRW8elQpJpNLfze7CdBPxuz9L8pPIusI/4B76RJQCs3fKqIUhViQW3Xhtqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fpgEAELLY0AXwE0EWmISOwmfte1uFLC9cmNd6GpeH9Q=;
 b=V3bBh/2V3dkuKNGJtkjc1y2plMMhANBCfa0w9/gE2nzG9KJHf+UjS0pDboVnbQezQdiDT7jBDNVGPGrEoDFtxm/TPKAbjG2hsyA4pbzYMVokvc6LB9JaMkH6pfqgk707DsQ5Y4SWNZw1RVj6l6DxaQXiIFyKChALyzzg/IUfTgFUI4MRRb27/jdJ3hInQRF/e29gbEdlHBwpYW1wUWmJiRZzwXF1lg54JQrXxV7U+LhosKKY51ciDHhNopb5tucotZzhASmvIotAVLBmhuULUwtn3qmhNc6ghQyNxWmrMkDv7kE5IDYIBHYZUh65+PVLEcVLfUiP80vNRV+xTuuRrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpgEAELLY0AXwE0EWmISOwmfte1uFLC9cmNd6GpeH9Q=;
 b=sI7f+cKuA2dRyDy5iSQa0FingU1VbTqO/4gyraVh1ucIbxzOdCTxLCE2WjFni1IZ9wPsps1PsRs1ymRLW5FGZ+7BFr3EAkQQda0HEfMgDfE2yPt/UeA9IV7WKwJzzMUIQq5sNAzdhKK6F8c3iNH+G6GFvd2BPXCWDg2O6DzE+N0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH8PR10MB6600.namprd10.prod.outlook.com (2603:10b6:510:223::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.18; Sun, 3 Aug
 2025 23:39:42 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8989.018; Sun, 3 Aug 2025
 23:39:41 +0000
Date: Mon, 4 Aug 2025 08:39:26 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: yangshiguang <yangshiguang1011@163.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexei.starovoitov@gmail.com
Subject: Re: Re: [PATCH] mm:slub:avoid wake up kswapd in set_track_prepare
Message-ID: <aI_zLqBtvp3gHk29@hyeyoo>
References: <20250801065121.876793-1-yangshiguang1011@163.com>
 <aIyJzh2-0YLydvlB@hyeyoo>
 <366fbd5f.2240.19869f49914.Coremail.yangshiguang1011@163.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <366fbd5f.2240.19869f49914.Coremail.yangshiguang1011@163.com>
X-ClientProxiedBy: SE2P216CA0067.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH8PR10MB6600:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f305a87-ce89-4526-9003-08ddd2e704a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4QnIeb7N70tP5hHeeOivEk3rrufeeQQfNWCZATRedco+aKtiazgJGoFH05Tt?=
 =?us-ascii?Q?I0t5+JNlQI/xTePdctXBqhHQ4hIDCgOJgj8L9tLRSYHTVk1gnUqBDI56aaXe?=
 =?us-ascii?Q?EsU/v+DKAtnA74VIv33fk9jZI/GN+Bhaqhege3iLic08ERVgwcyOiFaaJ4qB?=
 =?us-ascii?Q?iZbhuAeuxxKt1jpMonc/hMpwXkjCUgvv/RTYYxdxd3CunMrSmjw/VjtYay+G?=
 =?us-ascii?Q?sF455EYUMf2yKBiIgYboNifH8sfvMH90fkAgnl4t6IJwVOeWME7sSnr//+oQ?=
 =?us-ascii?Q?RH1lymwDT3v/juV5B0f6o5P+pQaikpPKf5IYXQwJjuQFauAVbhE86ZPv/pYN?=
 =?us-ascii?Q?2KRQgfVZJreCw3vbP5X+4xF/s3Li1EBNkR30shHZ31UDJ9HWyNGCWGwl8mXc?=
 =?us-ascii?Q?UdL/R9ZTToGHVjAOnoJGw9Z8cqcoPXrVcfy92hm/6UyQMmg+CN4NM+ti/Jud?=
 =?us-ascii?Q?pehwwDcZQ0oIUs6pay/uPkvkoIv5wqCuj3ZPGtmk8p8n3k4OKPJP2wVkgWlU?=
 =?us-ascii?Q?6xLpM6TlN3C0q2BZVk28Z7+mmBd7mOp8jLAL+qLTQCHUmFjPcPApoziAcUXh?=
 =?us-ascii?Q?Lh1VivwwlYHApWXR8vwPdhFDHkk7SjigvwvF8KmZT3WDWoopz3084RsyFEq4?=
 =?us-ascii?Q?Ux9NMY0ef2lghiUmGCO2Vqwz3UyH1cq4ayvczaaYctiqrdQyA2rhi7z+F8HY?=
 =?us-ascii?Q?C6yZiA5lxT0ycH6Fdp4PiUd59gVYYOaTtGBB2BFpDZ53k2jEbQNbODHWeVIj?=
 =?us-ascii?Q?c7aJdLKQUNEatH0cHswepij9XbqJb2MGsJHT7nzU1kTWFR1gV/SLz88ofDDG?=
 =?us-ascii?Q?JCKtNPD+A9RQYmycmjsadCfgXHknfuZ5E5lkm1kRK+rIuCfT+GL+Mo4X79jt?=
 =?us-ascii?Q?kh+9HEQedAo1Ri8fVFAedN4MfvOFAEpHByGIQV8mu7S0OQ570q/a4BRdKYIx?=
 =?us-ascii?Q?fhgDllhqZ6g5MH4jV6l5EUCu3Syz2HjXJjS1LrLp9jus8hqS9/Tu4hf45u6t?=
 =?us-ascii?Q?IqKWhJtRd6YQ5t4A/X3GM4+Ed6Iz5rX5l2R16x7aDu3U1Zh6Jd5oz7ncXMyy?=
 =?us-ascii?Q?OetHS9MnrN3udJD857FVz57u8ZJBlMlUrwsEhmbDwsPe2v+aBEnDzoSn4Uyh?=
 =?us-ascii?Q?O8oSl7ZwPQSlNcBbb7/LJbSp49eN5mI9mlXW8c3L7vzWQ2wEgIrgtxD+zLuS?=
 =?us-ascii?Q?M4/cc/WAovhKnDSBtzt71ce6/QdBYOhdQmLnsXs7JbkKPZRsd3VEaEEaxrGo?=
 =?us-ascii?Q?vosNW4ke9yxLVRRL1Vmd6us2OkC9tl2Vikte/+6YI+tKY0TYhR7iVdP27Pfu?=
 =?us-ascii?Q?ySn/HRR73gWdqZuQpfU7hWvJBYAAeIUdYsJvpggBz/zdolXYaoOerdBXqEr6?=
 =?us-ascii?Q?T4Ak3lRBncxuGaOvWqiK7DcevKpddXMGdNkPdIuO3lCkvePO0VZ0HCELLLWk?=
 =?us-ascii?Q?U+EP60+86kM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MwTITa/ikoZK/IpdNMrIoqDpW1TDwb3KH/2IxPsvwkPj4mzA7Rm3EkWM5rg6?=
 =?us-ascii?Q?cUm2xOIU+9ojswRHQCqTjwN7WXhit4Su9N8M2aYLG6Fa6DKZG8On616vlhPj?=
 =?us-ascii?Q?TBY50546vuF1xMlOzlJbbIr4DveEYbW9zJDSipT/8dWoeEnelS6yQEarE6oP?=
 =?us-ascii?Q?YTYAT+0AUQQp5sz+pMvH5W8pyISJ2ruvHWGAkIcfia/3N1AdAV0wz+p9ecP+?=
 =?us-ascii?Q?J4Qqq1Rorj36Af/7pRA1dBbH/K7oAd1L38o0bP/EEaJbs0jDYkHG/HluSMeq?=
 =?us-ascii?Q?035sPFYA7evIQNrBwv4KYrAxReRjhI5iwO7sfndkJ3+xH93um2qZb6Qz3kdj?=
 =?us-ascii?Q?q6GH3NDNE9znK3bElu2xpRJ3VT4IC8D38dbthGmErwHNAGXfPdmLkjcmOJuh?=
 =?us-ascii?Q?GiBWvfGOMJOH3ML1WLVcaYonjzt1N4rtTpgP2JX6tTcJbQeRywrUCA4cIjQP?=
 =?us-ascii?Q?VtMUN22KkouHfCxHsT3DFQ7XBLBK6TgNJDlFeDi5vYJK7htfZsGcQNiO0bre?=
 =?us-ascii?Q?ZNMDIGixLeaXtasTrHyZPqEO2t1QLo/irlipVdn1QuqTBlbb7KV3DruZeZU3?=
 =?us-ascii?Q?eTypeClt9k57mm1Vk0VKTx3HEqvkinzFqdkT+Bma1fDGRnEe7IYCeTjMcs2u?=
 =?us-ascii?Q?3dc9Vip4fXloP2Q3XXc3j5yr3/09goWpXMq9R1+wZlwQI73ZXyMxzCRtBqdP?=
 =?us-ascii?Q?fPnsVm+mmBRUiUlAEb0wVuKFZTr60fRVMNp1i0HCTYTs8NAVwNC4eUOLkpCD?=
 =?us-ascii?Q?afp/Xh61Nf7r1KdNsY+R7E270cT08gm9NUTCnvXAtOYOYqr9rEveDpeCFzMV?=
 =?us-ascii?Q?BsHz/++zBPd//fbbbfR8Rtn3dPoL5cX8WDHrVCWG1jj2wlRUHcCh2AS+Ee86?=
 =?us-ascii?Q?1uEKLHXmNQCsVEJ05PCvCYFbTRxQ9AYL19TjSS8QzRifSEPCyPvVd7pvEw1A?=
 =?us-ascii?Q?3c+W+fv+vnQM4fFUvwdXP22WxXB+AIJuczbhYYpwKEWauEIAxgyWO7eMuTK/?=
 =?us-ascii?Q?Oa3P6Dhi3hVgWb+dMu/gh1u/UZjtK5GNUWiL28CHYyMRcGVhfvztdj0viRxf?=
 =?us-ascii?Q?W/xQo8ik0mybQlMbVV+L9eb4XtIHwFmxHEAh+CtlUhKuIOsjMAe4nYBSYg62?=
 =?us-ascii?Q?H+WC4LexYu6pof5hcLqkYLgWmeM2T9i9DwNgouniRRxl237aW1MS4VynlgAS?=
 =?us-ascii?Q?MtQr8kxxR0kucnb1g8DcrWJ0RGj9AyoTLm0Q3SLWuHx8mnTWpbKaLctkKOAU?=
 =?us-ascii?Q?HnkXCsBvHsc6s5QJZzSK6/TTgH/svZp6RMVV1Tjm1EB9TiKJgsns86JQKDj/?=
 =?us-ascii?Q?xrEuQVWzrwz6tzmBxlro/OnmTWWeQDiFL7akVzU0Z0/IHte90O9pl0otZjUq?=
 =?us-ascii?Q?JLeN682foJNk3bKHzc6WeEswN68c4c93eHBjYiSVYdBQCzBo8jIg87onogT2?=
 =?us-ascii?Q?ExmUCoHhCmEL5L1zM40y3XmwmSZUVAuwg95WT/nuPXI2F3Ap6h1x2luvbTC2?=
 =?us-ascii?Q?GQ5aUOQ7ouk5TBQrxpjd35TXrjK5uj9D1O7WmeNrLD7oHrVVLzZEXxvCatTn?=
 =?us-ascii?Q?gnbr+7W9YS8tjSafeAK3G6QUJeJub6xc1cMBsUVZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/IjEqtL65OqAuKiY9g+1gYYf/e4hYPxQuDQof7FfqZMjlQt7tEfcyVjEUVSeFICTyQ85RpXNCroZ2p/Gbm1NvY9mc8h5FDgONd/EaT5SFCfsk8o9uWPdySssKND0JWEWQa/E5FlDXvhwnb6ZxS4bMuw58n2l7WM26o5cKSJTjQbLhvDRUlsneS4JUV5khErBNfGqkBqr3RZB6fHX4lOLmmbXnMr7h2aWoUfhmQ8QAcRxLxyvyLqq6bAPTGwmXenzPHTKd43/mJabs8P+x4gISBVGf8wlKGhK9WjMrKmfAqSDbNsshxwffKKyfNBpFAYSXvi7Nqb273np6s7LEVsv1hkYb5CFyOuvBpZD9ntgtcf72Lo5+7+EFEmPdyAimOAaMeyyivroY1f7ZmNyfVKZjbk0WLITqhMqh8PDn9mtK0ZRtuUU+z5T6NT/GDQ5TCHicX+mup7mqaDWL9rOxEyw0AzSg93gQB7w5sU20gBWaQebuiHk4JQ+A4StW+n8jo0hS8cNekC7tWTxYyeYDlX7dGTweOgCmPTs9NMStqZx9zx02X/HlEAj2qeRU+T4VWjIwem3N6skF0gsqPps1F7QYUzhLVliDiiel5adJnpazh0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f305a87-ce89-4526-9003-08ddd2e704a0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2025 23:39:41.5390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pOvUBIYYiLCX2PWx92+GVazk1RafIgNaYMixL93U0TPtHcBfB+XVhgGAOtG2BP6Q7RrU5TWq4BzYl9W+LGchxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6600
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-03_06,2025-08-01_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508030160
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAzMDE2MCBTYWx0ZWRfX9YjSyksihL1q
 jDgcmzzWuH8GiPDe0xBlr9AEISXwaPW+XphtCn/eiz74Jjrcf4KHWsPLUuFnDUPHMgvLN5YWUhL
 Z3E69kDZ/yq8CTrA6qAEzJP28vMBX6ghNcJx3vEYheq/WgMWm5jrqUCCRrCfJK6ZynW3wo5KPRZ
 xDcfnsKa3gD+OOtvR9A8XnPScTSIaVrSJTCPNytDOSMlotGTbweaFdXJHdUahLBCNVtlPMqQhue
 4waaslBcxzHbaQrvakWP8YFpAiNYC/sixcVLYTmd+Su3u72mbVlSrX+rPvDUbQGK+Hm8OhWLETT
 nwVdXJlmGlY+Rk1LbIL9yvPi52vJHHzdt8XSksmKL+CVXPYePaJ40Y858mfAkqWDKhvfLQaocpS
 l7p1FYJiytHD2JsKtWCzOjgJC7f3o3r7MqcaDzRD3M0Mp+U11phHj5WQqbId12FHlJDRNcDn
X-Authority-Analysis: v=2.4 cv=SIhCVPvH c=1 sm=1 tr=0 ts=688ff341 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=Byx-y9mGAAAA:8 a=I2tmWxhd37EZEsU4M5QA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: LRMAMLvjcgQvmN8nXZEq0hbcv33iq-0_
X-Proofpoint-ORIG-GUID: LRMAMLvjcgQvmN8nXZEq0hbcv33iq-0_
X-Rspam-User: 
X-Rspamd-Queue-Id: 18A7080009
X-Rspamd-Server: rspam06
X-Stat-Signature: bgbxbtwasf45sbh5jq4g7wcw1qawbxen
X-HE-Tag: 1754264394-197102
X-HE-Meta: U2FsdGVkX189z9NyDN7K1MvrK23QJgfeWZOoxaVNZwd28JrDERkqBWkF0VLuRKB+FUbNPTq5mnzu9wPN4MJdwqhKN1JkPPaF1VfLMLBnskkP13rI/IbUjtXogb/Gm4WsxksNPXu8ky1TQHKTXju5mf4wKgEK6fqVwd8JOaM1QLbRaqNCJl3uChbtKUyMuukPgNH261aDG5uDS3jkBtdjwWw2L3AsGFYdoE0vNrO/P6brvoIBCSOrlOzSYHHv0tkpyGLyL8XbbTZIMY9mMyNpxdWUM0xJOvO509Xs+xJ0mM9pAS12z8jXX4foED1rP1w8R4qv3dlNFa5bLrObslC6oC79yShJkOZe9SGnQTiOZpOV3eWecY8Oe2tKYIB1StBDGQjVU+ceceu8z/L+qxXovkhVfkawvzL8J8BJ7ecFLXHzzf1IEK4nHiBuGB2seGb0Qii63n/0SDiESW1f98m70lmEpYxVAQlBIrKlTh6W6LbE1CIpkIwlQ11iugfVuU4gpHN2yYiRwpeY0q7SyJ8EoXhTF773884Yelyxeo2g5csUq+z5vHTfIWIxzj1mStYUpT5zpz8AtkbUsQwsuygW0B5NKxgL0/GqhC6YnL+8KHbuRcbYlXeyLDP9c22/xpvECyLaYgAIFJmxCfZoizQO61+3gA3uioC4QvGYfLhUtkMVYoma279DdEMa21LegdiOvcZKeKNBFVXhuk0bJkVsCzm3uK1QaZYERrmM7c/tSHekFoqrp7Zfzn4Z2N5kGm/LfmqbNBy/lJwH1OqkV7B0oUFPhrvgt0Fiw7UCQ+bfBRrhp6p5rbGjXYa6y9v4IEKGEYjKy7/lBLkVczkqoAMXZ6dTgZgti7XSsjX6/aKIuzaRk75X2EKFLGQUOTp3G48b/x8nK4t0eNXOe89GBsY9Q4W/M56e7fLdPy85LY+PWc83ew3mATVbW29oCQ1R5QZXQWc1PXU2gLnR+8huwhV
 gc6ytMSn
 XoGz0F1dzAPa2gPawxRXm+Oq+xzpnGHvR7/j60PrG64VKP72XydTEB/NDUjxdiVdpJMIc+65hdqXYAeRYu/hrNYQiw0W2hA4jo775OAo+feJOaUSCvQW9Aq880XYRNWyy6lDcLuXTSGXbi2SGJ9MAhRpx4qglPfJj9oCi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 02, 2025 at 04:44:54PM +0800, yangshiguang wrote:
> 
> 
> At 2025-08-01 17:33:31, "Harry Yoo" <harry.yoo@oracle.com> wrote:
> >nit: the subject needs a whitespace between subsystems and the header.
> >"mm: slub: avoid waking up kswapd in set_track_prepare()"?
> >
> 
> Thanks for the reminder.
> 
> >On Fri, Aug 01, 2025 at 02:51:21PM +0800, yangshiguang1011@163.com wrote:
> >> From: yangshiguang <yangshiguang1011@163.com>
> >> 
> >> set_track_prepare() can incur lock recursion.
> >> The issue is that it is called from hrtimer_start_range_ns
> >> holding the per_cpu(hrtimer_bases)[n].lock, but when enabled
> >> CONFIG_DEBUG_OBJECTS_TIMERS, may wake up kswapd in set_track_prepare,
> >> and try to hold the per_cpu(hrtimer_bases)[n].lock.
> >> 
> >> So avoid waking up kswapd.The oops looks something like:
> >> 
> >> BUG: spinlock recursion on CPU#3, swapper/3/0
> >>  lock: 0xffffff8a4bf29c80, .magic: dead4ead, .owner: swapper/3/0, .owner_cpu: 3
> >> Hardware name: Qualcomm Technologies, Inc. Popsicle based on SM8850 (DT)
> >> Call trace:
> >> spin_bug+0x0
> >> _raw_spin_lock_irqsave+0x80
> >> hrtimer_try_to_cancel+0x94
> >> task_contending+0x10c
> >> enqueue_dl_entity+0x2a4
> >> dl_server_start+0x74
> >> enqueue_task_fair+0x568
> >> enqueue_task+0xac
> >> do_activate_task+0x14c
> >> ttwu_do_activate+0xcc
> >> try_to_wake_up+0x6c8
> >> default_wake_function+0x20
> >> autoremove_wake_function+0x1c
> >> __wake_up+0xac
> >> wakeup_kswapd+0x19c
> >> wake_all_kswapds+0x78
> >> __alloc_pages_slowpath+0x1ac
> >> __alloc_pages_noprof+0x298
> >> stack_depot_save_flags+0x6b0
> >> stack_depot_save+0x14
> >> set_track_prepare+0x5c
> >> ___slab_alloc+0xccc
> >> __kmalloc_cache_noprof+0x470
> >> __set_page_owner+0x2bc
> >> post_alloc_hook[jt]+0x1b8
> >> prep_new_page+0x28
> >> get_page_from_freelist+0x1edc
> >> __alloc_pages_noprof+0x13c
> >> alloc_slab_page+0x244
> >> allocate_slab+0x7c
> >> ___slab_alloc+0x8e8
> >> kmem_cache_alloc_noprof+0x450
> >> debug_objects_fill_pool+0x22c
> >> debug_object_activate+0x40
> >> enqueue_hrtimer[jt]+0xdc
> >> hrtimer_start_range_ns+0x5f8
> >> ...
> >
> >So some allocations can't even use __GFP_KSWAPD_RECLAIM (e.g., eb799279fb1
> >("debugobjects: Don't wake up kswapd from fill_pool()")) and
> >stack_depot_save() does not respect that.
> >
>
> yes,you are right.
>
> >> Signed-off-by: yangshiguang <yangshiguang1011@163.com>
> >> ---
> >
> >In general,
> >Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> >
> 
> Thanks.
> 
> >Let's add Fixes: 5cf909c553e9 ("mm/slub: use stackdepot to save stack
> >trace in objects") and potentially Cc: stable@vger.kernel.org too?
> >(It's hard to imagine use both configs in production, though)
> >
> Ok,it is necessary.
> >>  mm/slub.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index cf7c6032d5fd..14e3bac0c6ad 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -969,7 +969,7 @@ static noinline depot_stack_handle_t set_track_prepare(void)
> >>  	unsigned int nr_entries;
> >>  
> >>  	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 3);
> >> -	handle = stack_depot_save(entries, nr_entries, GFP_NOWAIT);
> >> +	handle = stack_depot_save(entries, nr_entries, __GFP_NOWARN);
> >
> >In the future, perhaps it might be better to propagate gfp flags to
> >set_track_prepare() and pass it to stack_depot_save()? That's what KASAN
> >does.
> >
> 
> Thanks for your advice.This might be a good idea.
> If only CONFIG_DEBUG_OBJECTS_TIMERS is enabled, there is a
> risk of recursive lock. Can __GFP_KSWAPD_RECLAIM be removed
> in this case? Just like:
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index cf7c6032d5fd..3b35b6cbdd40 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -967,9 +967,17 @@ static noinline depot_stack_handle_t set_track_prepare(void)
>         depot_stack_handle_t handle;
>         unsigned long entries[TRACK_ADDRS_COUNT];
>         unsigned int nr_entries;
> +       gfp_t flags = GFP_NOWAIT;
> +
> +#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
> +       /*
> +        * Don't wake up kswapd, to avoid potential recursive lock.
> +        */
> +       flags &= ~__GFP_KSWAPD_RECLAIM;
> +#endif
>  
>         nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 3);
> -       handle = stack_depot_save(entries, nr_entries, GFP_NOWAIT);
> +       handle = stack_depot_save(entries, nr_entries, flags);
>  
>         return handle;
>  }
> 
> What do you think of?

Oh, I should have been more clear.

I meant propagating gfp flags that's passed to the kmalloc() or
kmem_cache_alloc() interface to stack_depot_save(), something like:

__slab_alloc(gfpflags)
-> set_track(gfpflags)
-> set_track_prepare(gfpflags)
-> stack_depot_save(gfpflags)

Current code assumes that GFP_NOWAIT is safe to use regardless of
context. This is already problem as it turns out that assumption
does not hold when we use CONFIG_DEBUG_OBJECTS_TIMERS.

Also, in the near future we shouldn't even assume that current context can
use the __GFP_KSWAPD_RECLAIM flag, because the flag means we can spin on locks
and kmalloc_nolock() [1] users can't spin. (see gfpflags_allow_spinning()).

I think it'd be better to use the gfp flag passed by the user instead of
relying on the assumption that GFP_NOWAIT is safe to use in any context. 

[1] https://lore.kernel.org/linux-mm/20250718021646.73353-1-alexei.starovoitov@gmail.com

-- 
Cheers,
Harry / Hyeonggon

