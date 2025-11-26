Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C6DD10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 15:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7C296B002B; Wed, 26 Nov 2025 10:03:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2BCA6B002E; Wed, 26 Nov 2025 10:03:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6206B002F; Wed, 26 Nov 2025 10:03:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A0ED26B002B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:03:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 543B01A05EF
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:03:02 +0000 (UTC)
X-FDA: 84153075804.25.B6AAE43
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2922A140025
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:02:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qyhYNZhq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Mth5p00E;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764169378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCRFYgo4AqOV+eBLPTqJY+ls8Jr5iyGOXMRrPZ7ivsI=;
	b=5MGV39O0kCTMhmrV4opbjRSgcR9YUxnW7D6TXG/nij1TqL/gu7Skf2UOM1av+IQrpBZOGT
	q/pF5qZuULUvbFLPbFkDjZbuaHXdjsi0C/KC5U6teSPvd+JPagsRH1ovoYXskmT/E+lJIp
	L4w8o3yoMarioGGh2A4pwR2o1IBu4po=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764169378; a=rsa-sha256;
	cv=pass;
	b=K0jNeqyktU6DlW+cxDT2zZ/1IA2ssurMrFISbWVE+qB8+oZxy3hJ7qhncwFk2zAKaD1BOK
	eB1Spqukialh8/y8Fup/TdCeCot260NEjobFk44jjx3Ewrt9JLVvl6w+LWk8PCP5GPOITJ
	52NL1JL3dPQ/l8+cXDaPCAHFsHqQfYg=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qyhYNZhq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Mth5p00E;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQEuIKH2483025;
	Wed, 26 Nov 2025 15:02:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RCRFYgo4AqOV+eBLPTqJY+ls8Jr5iyGOXMRrPZ7ivsI=; b=
	qyhYNZhqvenNBqGXJD22kbxaGIvQEocv+oUMGH8pCmCzvYZPp+287YDx9ngEd/yQ
	FRpDhiJd170CkrlsUKui9Rlp0r+jDiD7WG2/O5QmNH6qrejVX2e3E4JsF1Md5q3C
	2lZrT2QXfKHywA6fLLyaKJl5J4eBGp8Zpc1xHF1xCwxLTE5a+BpSBlcQcJuHQbLi
	U+sC2qu5k01s8zXQPQeu40i2upcmwLSXWn5KVSPFywamnE71t9Zq4FvXLgVqYjgQ
	P1UqpAXG1BKTbfcNnMEP5gT+mjHMYuRSWwEErkWnPevkiJzYEiZEG7iFWdoSEbqW
	Ef7gCl8cMKQTfFmTdMUk2A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8d34878-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 15:02:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQDfruT029663;
	Wed, 26 Nov 2025 15:02:37 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010042.outbound.protection.outlook.com [52.101.46.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3memq34-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 15:02:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AuGK/L/A5V/0SahbdE/YTn5gWQJkiy/ByK7+wDxJKqAqgoS9tnwHm+nvL9W32pYaKJfIzYrdND78JVTfeACL/IVBhzKG28BH9UHTLhXJkZP9A87PkGf5XxEgC/Uwv50RN6CskICKfb3N0tTjnc8mbcndTfgczXgbOh02OyophUQOv9zTgr42JXE3aAISfUQ0UWvk+HUiAuT6fKiFiJw0F2MbXc9322zB5tL8NeVIcWMFVP8K0MI+XdJzsr8pwONQWJeooCUEaQLNEMWBm64k0SD4M+ejoEIXaCRnXE2rKpiutBXAAj5qx5ZDdkoZ4IMSv8bfmvgcy3S9UVdNZCFGMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RCRFYgo4AqOV+eBLPTqJY+ls8Jr5iyGOXMRrPZ7ivsI=;
 b=R5UnpKDifSx9gLbK5zt0WkFbQ6ExJYboYk8j7bC9M30svmrHIAQiTXYFIG58D2PFlV9j33kRCS0UNxWLmpws1NShjplf8LYD6IVFLXoLQFUCEFVBJqWz+rO7sgghhcotz9+UOo1BJL3HNV9t+gkPwqI5hO39VH8r3jf0t6542jk9nmMS/Kw+gyCxpo5ncgyOne5yWg6B0j6wYA3ohjYCXuOlAPVjATCavj3XeDNmuBM97sKeEQjimINU8XMc8FCkNGB09JJ+NGuRA7PfogJpZ2/qLDEE/KfEI1MoNsmFgE9RQDvoevQdmdLs+f3d41FBux/zDcJA6S7gfk/5WTSpTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCRFYgo4AqOV+eBLPTqJY+ls8Jr5iyGOXMRrPZ7ivsI=;
 b=Mth5p00E1t78Z/iHo4pzMhXc6VcpOb7ywyRYFCVmMw7cPmTMa5cFkQpl2Gf89vRyHdNNayLaVF/9+DC2HedgSQbeInMKVzKiQtZi4b9KtWG4SgCzwPFRMjlMMfn2yh5/7AG+QtuSn8JS+GSIoMSl3ZV2GTkHrC8hwt4BRUzFBdc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CHAPR10MB997721.namprd10.prod.outlook.com (2603:10b6:610:2f4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Wed, 26 Nov
 2025 15:02:34 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 15:02:34 +0000
Date: Wed, 26 Nov 2025 15:02:32 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
Message-ID: <7282f511-39b0-4321-b3a4-b95d6ac5a209@lucifer.local>
References: <20251126034404.2264317-1-willy@infradead.org>
 <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
 <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz>
X-ClientProxiedBy: LO4P123CA0517.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CHAPR10MB997721:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b31ef7f-84c8-45b3-6655-08de2cfcd47c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUdnZFNMcHlkMmVsdG5HSkoxQVhoS2g5alFpREp0Q2diQi9teGdXaklNdGdi?=
 =?utf-8?B?KzZOdU5LTkpnZnRNQjR5R0ZvZTNFZ3dmVFhPTkdhTW9jbkhlcUxzZCswTFB0?=
 =?utf-8?B?S09yWlFIc3VZTWdEVE4wR01hby9iVjhoTG8yay9NcnNMbjdxVnYzdGw1NE5Y?=
 =?utf-8?B?L2RKMnVuMXRsMlFOR2dxS0FFN3pMOThrc3ZtajR5UDRGRmNpakdYbzZyeC9y?=
 =?utf-8?B?cGk1OWVYVHl6TmxiTXh6aWxCUWdSb3JxeDAxak81bml3YVBaaDFpbXE3MUJR?=
 =?utf-8?B?am5NcmQ5YUhLbkhnMmt1Q0dHcG53dUsxWERlREpGNnY2SU1kMSsrMCs5YTRW?=
 =?utf-8?B?clBJdkM0TWpxUEluSUJqNDFISzBXMGhiSm5vZ3ZXdmZVT1NUOWRJRkxJc0tN?=
 =?utf-8?B?bHhqK2dmUkNDNzh6ZzRrSGRSTVcwTGV4RmdQbFQrdXdNbmRwNml5R05GdzJH?=
 =?utf-8?B?TUxhcnNnK3cvOEVTa3hkTm9MZHRWdnQ0clhrOXVoRzdxZmZKS0RoYkkzTlBu?=
 =?utf-8?B?UTNxN2F3WmpvVGgvZExHWUQ0QXJaTi95d0hCaUVtUHhBUkFrTEdiM0NoUUlQ?=
 =?utf-8?B?Mml1NDVqaW9CTkNPaGN2VGRQaHVvazkycmFTa2g1RW5Wb1J4U1FxRjMzVTg1?=
 =?utf-8?B?aEpwNStUL29BRitwekxrVyt6WXBRWm80REJ2OHE0bVpuK29tODRlczA0dlds?=
 =?utf-8?B?WnREbEZGRHQzV0dhTzk5YkRSMVhDQ1Rnc3d5cFB0RWR2R05TSnhURkhoSWlr?=
 =?utf-8?B?QzBDTzNCMWtLSWowYStGNDFoQ0JkeE1EZEhnUVNIV20rVlRkRW84VWRiQ1FJ?=
 =?utf-8?B?eUw2U2lha3JEMnl4d1g0WlpGLzl2anVzOHJxUTBhM3hzQzJKWXZkaldUYzJx?=
 =?utf-8?B?VHZIRGM2SlBSYVZaanY2OEN1TE1zRnpnVzA3SFcyRC9raGVSU0dWcmxROXdR?=
 =?utf-8?B?WEFsRGhySU9MRW82a0Z3YjRYbS9SVHh1WkZXVUlIM2Z2TEVIQVNFS0FlbVJO?=
 =?utf-8?B?VW9uTjJOL2czRkdrVC9vTUJTdHp6aWUwUjJ2blNsaVU3MlBqaEtuem03dTJl?=
 =?utf-8?B?cnFuZTlPN2VGSFdPdTBXSEJSbUx2dStjemZqcjNYUVBZaG5IbjhObjJvdFpw?=
 =?utf-8?B?bDV2TlgzSDVtUW1aRmFLa1pLbDVQY1gvc2NYTGEwY1ROVFYvckQ5cm13eWZo?=
 =?utf-8?B?MW05dlhBSlYxblVpYzl3K21nSUM3TVhlVEFVV24rUU1KWjN6aHdNTEN2NkF0?=
 =?utf-8?B?ZUZmeTFZK2JQbEpMYWtsMFNueWo1MEQ5UXFqWXgxdmc0bStvMDdsQWN2dnR4?=
 =?utf-8?B?THF2cnRrbGZYaC8wbFY0dnJxV0pvak11M2I5aitlWHprL2E5Q293dFlwakxG?=
 =?utf-8?B?SStSU3FlV2RnRDlEVmt4MWZQNWNnQmRYUWdpQ0FwNmFKQmhNVkFlcm9jNzd2?=
 =?utf-8?B?MkllNk5CVXFlTnB2djJWSEZYeUMzQ3BMQ1d1WWVvVEVWWndtZTJLSC9BTG1N?=
 =?utf-8?B?aGw5TGRVS1BnMUhkanYyK3F5a1U2djBTTk95anA5dmphU3JFbU1CNGErMU9I?=
 =?utf-8?B?MnAxYVF1eTBjOVFpQ2FiaS9Dek5HaTZjVFdjSG5TRG9qSldZZ05VTHhOOHZ2?=
 =?utf-8?B?eGk3d21oejN4Y2pHVjhHQS8ySDd2YVFqZkFpVS9RenM3NEs4OXU4NHZrSmc0?=
 =?utf-8?B?b0x2bmw0ZEo5V0U1bDVvM1RBYnBvK00rb1FJRm9MLzZsVmlrYWp6SE9ybG5q?=
 =?utf-8?B?N3lBT0dhcGd0bHpWcXRaRXpHS0daVmJ4b1UzYzBCMnhjd2djNWt3Vkh3Q3dj?=
 =?utf-8?B?VlNRUmtFZXRqNUVhSVlxNDU4Q0haTjZjZnJyYWRLVWVQMnI0KzExQ2VJWnky?=
 =?utf-8?B?RjFUSllVQmlGdHBicGZRWFR0R0hDUjBiNTVJd0ZCUWNuWWZ4SFhZQ3RaRWF6?=
 =?utf-8?Q?9Gsr3+R4HSPZQr/5Xs3K+WCXPibGcOni?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEo5TjRqL1JRbksva3hyelFMdVk3aVExQ21IOFlDWjdDb1d1MmJ1dG5tcGYx?=
 =?utf-8?B?L0h3clVZMFo4K2kwNDFKOVdFSnpIcm9zYml6cHlkb0kwM01xOWVkdHJJYzhy?=
 =?utf-8?B?T08zaUhIT2x5SDM3MmExNjAwNmNOeGlXZ3ZVQnZnTndCV1J1MFJYU1Jmd2wx?=
 =?utf-8?B?WHFabHlxdGNpMENKL2l2THlVWjhSbG5YUTFtaXhROXE0TWN1YWtQazBFT3hs?=
 =?utf-8?B?NllUVVk3d01pNXR0Z2pKNVBnNDlQMENxbHAxNFVvam1jWU1Vbm56QWxXZVZs?=
 =?utf-8?B?V3dUWE0wTGkyZVBHSjlCSkEzeCt1SzhZN0kvRkQxN0lPaDFxc0dVT05IQUhL?=
 =?utf-8?B?K1NHNzVHS1VCdHRNVHBueFgzNW9JQ0lyNHhEdjlDWTUwTmhRSk9mQkdRRUMx?=
 =?utf-8?B?eGJWb3ViMFFudFJCZXRUeFpBYmpCa3BZSkNock90Nmc1QU5xZ0s5TjB4OWhv?=
 =?utf-8?B?MWNrbENMM0gvM0dPZnc5dlJnclRvMDhTT1FhUUVHUlBJV2hRL3hNTGI2Vzc3?=
 =?utf-8?B?Y3M1Nmthdi9QRXA5ZUFuSHlQNldEUUN5Q3JiVTQ2cFNGVzl4SkgvZUo5U291?=
 =?utf-8?B?SG1vWHY1d21EV2pMYTl0V3psYjZ3aHdZTmFVTG4zQkFkK1l2WUpqNDhqdEdK?=
 =?utf-8?B?NlVqQng1R1BaZFBJQmNrSkRuMjFNWWE5YzcrNmM3QlJkcDF4OU55YUZRR24x?=
 =?utf-8?B?b2pXRHJiQ21xejFvVURmdGlSSHVFc25vL1JkR3h4ZjdHRmpRSG85N0NDZnBK?=
 =?utf-8?B?UGFJK1hkZ3FHZWU5dEcvYklNNFVMaXozeUNxZFdGQ25TWi84L2NVVjd4NnR5?=
 =?utf-8?B?SGFDREhIcGlobXI3Ti9yR01jZHdhaFJzUDJMNHFVZ0hvU1QxTGdxb1l1UFcz?=
 =?utf-8?B?dzZmT1FtRGp4L1JYb3RrUG9EL082TlpVZERFZ0FjdS9Da1lTRTE0eEN1eDZX?=
 =?utf-8?B?WFBYL052UWQzNkZSeW43R0I3VmVnTlJlUExmMnJrdmZvbkdQZ29KelBkekc4?=
 =?utf-8?B?UFh5VHluRDd4bjBCRU8xVThIblhTWmFVUGdiRHg1T2pDbWZ4VlNicVExNFZn?=
 =?utf-8?B?a1JQNDhTdWsxQytRRmtsSDRxRHk3UGthVHdkb3d1ekxvZGVjK1BDRkQxWjlR?=
 =?utf-8?B?N0V0a09SVTJ5eVUzT3EwR24xVytZdHZ4ODQvdGV6anV1akdTS05YaHUrWkp0?=
 =?utf-8?B?VTBaNjltZmZjZEJYK3NzZ3Bwd1QxUjFJalFIY0IwS3p0ZXNOL1VZcEdiSEI3?=
 =?utf-8?B?M2k5NDRUU0xWR0VwaXVSWERHOXpzQ1IxSGxYd0pOM2Vod1ZsZStvTDZHcjNB?=
 =?utf-8?B?K2UxL2VMUXdDR215Sm5HQzlmS1JOZHFKU0ExbVZMQmd4ZmhHQ2VZcVk5TDFr?=
 =?utf-8?B?TER5QThmUkV0WjJpSmFGZ2VVWmwvZ29NN0lIcWI0TzNySEFGTE5hNmxhNm1x?=
 =?utf-8?B?TERSNkNKeVpES3ZQZW8zOCtjczVlS0JxVkt1eTJwUzJ0UHRyWmpzcmY4K1lN?=
 =?utf-8?B?dmZUL0pYVjlxMVlSSi9NOEFYbWFCdkh3dTJpWkxaTFhuL2VVK1poMVJySlRh?=
 =?utf-8?B?d2VCTEh5LzhFakRJSTl2VVpweHlYRDBTMktQRVhqVzNhYTFvUTZlb1M1VU42?=
 =?utf-8?B?YTI5SmNpUEcvbkpROEtuNTBBLzd5R1VaeGQ3dWxLakRwVThlNXJidnRwbzZZ?=
 =?utf-8?B?RHNyVWUvbGRXVWRBUEF6Nmpod0ppT1NRaWZOd0tKNnB1bzVNRHM4UXh2Y1J6?=
 =?utf-8?B?WGRQemRCY2Z1YnFGd1Y4amttbjdVZy9kaGc3bk5WK2xKTjJOb0UrN25XaGNH?=
 =?utf-8?B?dFlDQUtqNXEzUFo3bW1aRmhFNEpxYzMyTTkvbFA5K1puMkRkb0Q4WnJMcWRN?=
 =?utf-8?B?SXNNQTZyb2xZeXhYYWdvNnNkckp1cmVSNHVVbDI3NytDN0drMFE0OS9qbmFF?=
 =?utf-8?B?N2tMNDVVSXk4ZzZiMkFHdUhGdG04cHA4QnBBck9RcWl6aWJxRlExNXdYOEtH?=
 =?utf-8?B?S2VFZjh6a2kzNEVnQlI4cWlxZE1oT0ZZNjRmZnhYOEJzMjRHZGMyTUp6eFFB?=
 =?utf-8?B?V3lKZnhRLzdxdFR3bXIvR09heEFNbExwUVZ0TVNiei9WYW16aE5rR05jWXNC?=
 =?utf-8?B?VVpkMU9DRjU2S0JyMVY1ajlGK1pjbmF1YnJrRnRGaERzb1N0dnBhdGVVd2hm?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cMLwN15rpFqe5M4TmNkSA6/KYYFPpdQKBO49UMwuz3h6T8BtwOHTpreh2Hya6ETyy+b70ImRbl+NaHqP73f3/xRR8wf0bXVhzfbCEgFSb+xAPTBUTKrRKer+3wg0a23m6XwDzp8k2jF0x/HaoP9amAgSzTp1IU1+6ASk2Y3KBkBYiMadg+gBBcho0ooJ6Eu5zwGM+Ih2A9vvVxynhwOAtS7tOXSh2MoHup0DTqrR5oD/ABptkBhD356YOf9a7Luq+DB5xybwgHY2209UxyPYuqc37X99BF2sszyccN1yFcxrJ2BAk8OByNk08UoFx6dZx6IqJO8dojndTwQL/Esiuzjjdc3993I1corb8V1JPRUOlJuYmJqbPW7i4vK9+uCKg0zPpG2hNB0+v7LAO1nHOdTqHrKPxGJCnUX0DgbH8VAKQ2zreNouShMb0jRgfxG9JOU1wKNXI3BeJGge8VP1dRD6A6ouLdQEPhJz3VW/1yo0QwqB9dAsqm4tEw8m0l+lHtklcGxcpnlUFQdwVJeq0gyk2EeTlLrg/cY1sOV3IXZ1EppSSJFoGYD3YKQlQbyXuSUoEdvmqiIDYgJEX6iw/0qgtlrCRADU+ApFFvSd5dk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b31ef7f-84c8-45b3-6655-08de2cfcd47c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 15:02:34.3115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jEfR8POZf+FZAWPUm2Y22FDkb9X1qQ7LE5+6WuEW3hitpkn1laZ9XTYOrmEc6wEUNEnIGu+YAyeMVngLxK1pyAmqNBaGwOK4sYcXljsRJ9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR10MB997721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511260123
X-Authority-Analysis: v=2.4 cv=QPJlhwLL c=1 sm=1 tr=0 ts=6927168f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=hSkVLCK3AAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=-7lIu9vsSZoNVDDNJKYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=cQPPKAXgyycSBL8etih5:22 cc=ntf awl=host:12099
X-Proofpoint-GUID: 7IDFc1kSO1iaU7mcjAS5EMLdn-zf_BxE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDEyMyBTYWx0ZWRfXzr7yaHn/BoQM
 FSfaT8uJtkYIHl8UonEBa9BsH85PwpM6BVa2w/+IJtKQq2tmb4vIo3tBvJd4ZGt8tdydW4kb9uU
 OCrUd+g5ld0IrSra0SVTEGb1+FxZ5nY1iGSME6lEyhNSai6WNFVqQA5ilae00QOM7t9hEGVJB0L
 w0iDSMYWXHX92VRyhutFvZxijbYtgRrCXY/NtzH1ZvhnE7vKTlADVB5mKrzr6gbvYy2gPqTlD5V
 gP3A6VD2wWaO1CBMlmDB8NESY7QXtLVEmDQmqSqFc6N+Wu98RyJvYHlqbtWlxlpEEJiJLIyIGC/
 gAnIS/MB2M2so4udEA4QXm2oxcH2mUscnuzmM3MO+65cMUVjSHZ5d/8Daq+uJIrmVAgmibulH3h
 BPN5NhAvqn1S7Jdt5BjNcYc0QsXp3Jq8PPGktwu7k9Wsju6J89o=
X-Proofpoint-ORIG-GUID: 7IDFc1kSO1iaU7mcjAS5EMLdn-zf_BxE
X-Rspam-User: 
X-Stat-Signature: s4ma6ytaspgez7bshmxh3utepq74yuuu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2922A140025
X-HE-Tag: 1764169377-649973
X-HE-Meta: U2FsdGVkX19jECemKKU2b44O7B74Ct0VSiOq8g0jr3kLPLw3W64vHzSiyBekDTQdEH6AvTOEbw00zW3hSW3iBWWYmaYCsKxYd4ayW6TPuf828rmNs2lUhY+ak5aNAlorBo+cIYlu5z8I/oS56NJw+IxSnMjFdZPI76IjBg+5boJdGCK7Uca4sjTE9mzeteAiqgo8Bwd3CDvlgvNmJxA6cQ0oGiuZCICyQS9jrtAZf2tVFlAnABCJF75L56AKrRt7pheEgMFRzO2fYNxvS5XXA1uSNW5Om5eK8IPl08KWajq1nRoFLRkk1XzaZxzCliWFHTMqBie7BhbUoFvtKFcWOYWHN9RQRtOUaPHd3GuhrPqyIlhYEwf3x4kmRH89i7j/PQGT0KdF3CZKO8i6Jitr42twPW/vXzRHw27lIcUSnce7iLJaQbNcw9/N4uyeWRcqm37px6YTSCOGHFCWKLE3ID6QtwjQlQNQ0f6x9dNkN2C3EzrLUeGskGZhMPtZwMMm2e/Cl4QElU5GYr0A/2my9P+qkezKvuO/VNFH0AwgfInS8aAGwdoYwKflABVsN+Emix8LGNwvpS/IAy+fN7iNYcO/5vt31hAv9vCD7zWxLRp1WxzlsvEWfxV8ZkcMx42dWgHDEf7nfWT1ZTVpGeIcVDqv8/R1GGGUx5OLdRw+iJv3x/QUQM7LfXT8WOkm8ITiRHzd2BWewNokaS+Ls2B0xUAW63zTb3cDm+hzZiyspflCEUqEegXpgsVNXU751+DqH1HCd/TA0cPBURjoAl2nl0VL9zbnMNq3nucZ/oCRl4YIeFHugPrqHsbZd44F+/u0BaN0pRrb7a8ryHHWTDF8WBYcwo+QGek1y4LSTMlkia0qcZHbGxxsFuMsGefTe/XI+VxdWg+lVKdS2cjO2cMTgymtTefVWGnZRW71wIpJCkSXtqExi5v9BkQ73VbqcDiaA79u5EGv7vh2gk7erTu
 FnPESPmm
 gRQwCN3WOgs7V0iCjCxwoggkun9fadCn88zXWT9v56jBWKq7eB8tbNNcIwwOxzZ6ewrSQ8df52FMoG8JikKMhxplyn3n9gdLyV/TjYLf55FuaKs+X4YrxsVyvhcUAh7AMNbjrRcb8pjx8lYDE8FWWvix3Fg/VbdXqqMjHy6eNEvMAo84tUW5c35jBKCcZ2d4T4pmwhYB9JEeH9xqaDsxK62L8Z6iWUc2pEDGHVUoStsxnVwLzlMf2sK0w2EDgb+lBOYzbhjJoz26CRnARt5I9Ced5y0o4VGVWR0it7T69Wm0aTVNH/pendjXxXCf16eD3SgFr/9cMBbxZ8TXnMuX9G9cqaaznNyQX7lr9rIn5qmFx2n3Y3W/99PgwPQ0j4MKjNzFstABLn8X+E8z/g4OL5Ei5LG1wlUVqGwQlCIgsOUoGGSscQLI5mueackUfMpUtKgfaoSDg1OPFF552XgyuP7WoMYuaa2nhTa70yZPRIgqAuZVTHddxgAWtjzCmdJ2kU9bjxWoFbFx/O6VNw0PSykz9ZrGHFY9K336Bu9U0bdNNXtx/a6bdHbnPIvl14DWW0BGZXUa/gmRBkaDSW4CKd4T5r4lphvxcurSizdKKdx1nS7gjV5Tq4S98DAKq34Rd4tx0G722R8ojdz1v19VjPKykIQhKbOrN6ft3/3z+57XxrSGMglqj40fdIDom/V6ZKYbCkJXzDRJMrMKOq1IpS9PFXfL2mDEGxB478CB88erFPacoMcpphO1LDMIDhhkMOLcZHgA2C8AMKLKyMWHygMkYx8wgUbx4MEZmZ37YjVgvEMPtdGvD9WiWpRmrntEKwtB8U1DaAgp6x3TK9nBLv/B7dGfwHaR/1wSdKw1YRH565p1yLz8DVF5FCq/o0D+qeCnZ1zDxlt94ATNSfAM/gHnzsoCorthAS6TatQ+XMw/ad9hIapmloTHRSSROMzmweT0ejHQot9uZnII=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 03:36:46PM +0100, Vlastimil Babka wrote:
> On 11/26/25 5:28 AM, Suren Baghdasaryan wrote:
> > On Tue, Nov 25, 2025 at 7:44 PM Matthew Wilcox (Oracle)
> > <willy@infradead.org> wrote:
> >>
> >> If we get a signal, we need to restore the vm_refcnt.  The wrinkle in
> >> that is that we might be the last reference.  If that happens, fix the
> >> refcount to look like we weren't interrupted by a fatal signal.
> >>
> >> Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
> >> Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
> >> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> >> Cc: Suren Baghdasaryan <surenb@google.com>
> >> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> >> Cc: Vlastimil Babka <vbabka@suse.cz>
> >> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >> ---
> >> Andrew, since the vma_start_write_killable() patch is in mm-stable,
> >> I don't think you can put this in as a fixup, right?
> >>
> >> Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this bug.
> >
> > Doh! This is embarassing...
>
> Hand-rolled synchronization primitives are wonderful, aren't they?

I do wonder why we reworked the VMA locks again, I understood the previous
iteration :)

Not sure we fully justified that. But it's water under the bridge now.

>
> >> Any other stupid thing I've done?  And am I doing the right thing
> >> with refcount_set()?
>
> I think it's not wrong, but because it's dead code anyway. So it's
> unnecessary.
>
> >>  mm/mmap_lock.c | 9 +++++++++
> >>  1 file changed, 9 insertions(+)
> >>
> >> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> >> index e6e5570d1ec7..71af7f0a5fe1 100644
> >> --- a/mm/mmap_lock.c
> >> +++ b/mm/mmap_lock.c
> >> @@ -74,9 +74,18 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
> >>                    refcount_read(&vma->vm_refcnt) == tgt_refcnt,
> >>                    state);
> >>         if (err) {

OK so the sequence of events as I undersatnd it are:

- VMA_LOCK_OFFSET added to vma->vm_refcnt (assuming not zero)
- we try to wait on vma->vm_mm->vma_writer_wait

- this fails because ___rcuwait_wait_event() calls signal_pending_state()
  which (if task is in interruptible mode) indicates a fatal signal, so
  -EINTR is returned.
- Oopsies we need to subtract VMA_LOCK_OFFSET before we're done.
- If the resulting reference count is zero, i.e. we held the last
  reference, we then... take the lock anyway?

> >> +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> >> +                       /* Oh cobblers.  While we got a fatal signal, we

Well for one this comment is broken ;)

Plus 'cobblers'... when 'Gosh darn it' was there for the taking...

> >> +                        * raced with the last user.  Pretend we didn't notice
> >> +                        * the signal
> >> +                        */

I don't love that we just assume that rcu_wait_event() can and forever more
only error out on fatal signal.

I mean I guess probably it can but... maybe worth rewording to say we
failed to wait so have to subtract but raced and probably if -EINTR this
means...

> >> +                       refcount_set(&vma->vm_refcnt, VMA_LOCK_OFFSET);
> >> +                       goto acquired;
> >
> > Wait, why do we consider this as a successful acquisition? The
> > vm_refcnt is 0, so this is similar situation to an earlier:

Right yeah, same question?

> >
> > if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> >         return 0;
>
> But this means "vma is not attached" not "we failed to lock it".

Yup as vma_mark_detached() always takes the last refcount afaict.

>
> > IOW, the vma is not referenced, so we failed to lock it. I think the
> > fix should be:
> >
> >         if (err) {
> > +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> > +                       /* Oh cobblers.  While we got a fatal signal, we
> > +                        * raced with the last user.  VMA is not referenced,
> > +                        * fail to lock it.
> > +                        */
> > +                       err = 0;
>
> Returning 0 in this situation therefore wouldn't be correct.
>
> AFAIU since we started with attached vma above, it's not possible that
> the refcount_sub_and_test here will drop the refcnt to zero. We could
> just WARN_ON_ONCE() on the result (in a way to make also the
> __must_check happy) and then can return err below.

Yeah we are only detaching in the case that we _know_ we are the only
writer right? So nobody else should be trying to get the write lock and
failing like this?

So maybe the 'wrinkle' as you say should be a WARN_ON()... or a
VM_WARN_ON() since this 'should never happen' (famous last words TM)?

>
> > +               }
> >                 rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> >                 return err;
> >         }
> >
> >
> >> +               }
> >>                 rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> >>                 return err;
> >>         }
> >> +acquired:
> >>         lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
> >>
> >>         return 1;
> >> --
> >> 2.47.2
> >>
>
>

Cheers, Lorenzo

