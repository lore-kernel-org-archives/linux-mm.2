Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71744CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 04:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9078E0006; Fri, 12 Sep 2025 00:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1248E0001; Fri, 12 Sep 2025 00:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69518E0006; Fri, 12 Sep 2025 00:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9368E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:49:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26FAC140696
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:49:47 +0000 (UTC)
X-FDA: 83879370414.20.8CE27BB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9BDC480004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:49:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VB4h2R5S;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ynpMwCQ+;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757652583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2cDHIGXFX6V+UR4y0uPkWR2gkOrqCXB9govW31179A=;
	b=e1Y0c3CPQP2Ms0SatKGp3xXLOepPG38Z2r9xlC7Gcu0TkLcmfcXGcvzRB30orgBiW2/IYv
	aZecPx41k5KD5VZhfRaJ2rq0xqIEC2N45pdEjUrPcLL8yV7z8vwwo9o3BzHN4N/YkgT0ce
	1V2T9s17YI3bK1vslM2bHMJIpi6S6DQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VB4h2R5S;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ynpMwCQ+;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757652583; a=rsa-sha256;
	cv=pass;
	b=7GkscrAfbgQhu0Ic1P4X4Op8f6cSsgHHi5Y046gfISi/I1zrrZ87syzsdUxsM4m2KAFkEI
	H3VBgjwm5EbhWqsj5AOIdeC0IEsgiqYoBHyReEK6kpiucZseaOpvb4IufQFjqFONWtDpNj
	YAggBh7HkmzX5b9oYU6dTKNFZC5KoRU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1uOs1009834;
	Fri, 12 Sep 2025 04:49:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=b2cDHIGXFX6V+UR4y0uPkWR2gkOrqCXB9govW31179A=; b=
	VB4h2R5SB84FcXprzuKhz3fiT7+fcVVjkLFJeupSSMgltuzGYrdJ4fbHVLXMo7iF
	F8dc7vdOUDq0R5fOwJWSacm1SUSv/7eMZc31/xLyQ/ir7t0T3R8oUoA32fFnk+V3
	PX9WHigqPvWv3OLX2219TDK+iZcLdncsT/VgcFLckHy2p8FpIDH2yqHaekX4v4F6
	sMwb9fKLiO3q6QZETN6BzB77QXGH/j/999I9wN39mwoEo61BWL/XniP8UTFGLzdF
	/zdLG0kjJ+/LMygd/2J7ImcHmIZIRk0JqhAUJFESCf/QTjT0fa5DjL7UKYKAS/uP
	DCLL3X+uysmZSSJck/TQqQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921d1qmtp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 04:49:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58C2E1Gq026170;
	Fri, 12 Sep 2025 04:49:36 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011003.outbound.protection.outlook.com [52.101.52.3])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bddd1rs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 04:49:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qOwvUce/yOYxBbBmHk9FCUjkbQdJeJ+0S0L4TDkHvPn+WUhu7mwra65JI79vjHydsvUUSxYv3H9iKDeODERmDo0w1Elih9IYdeRZisEY9MglzODgIOrYfAPXyUJMTvZfodlfZ0K87c13dPD8HFfIUPxQnnVVIfc60Uhnc19/6jMOYI38KbfpceP4Jz2lCHwgwuu1qC/GIrwGjUdMNi5pX0P+8RfPcmWkjdYk5oHDI0Pk0S9TKiLNzTTGXabvBCNYahxRYnNKouKvj2eTAxQy5hz+0GgsXKWJ1i1j4CShLbd496RZY5gQAnG95ctl88N4VML+ZmPlbmJyXb2XDHI1Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2cDHIGXFX6V+UR4y0uPkWR2gkOrqCXB9govW31179A=;
 b=DmHFH59qGYT4ZnvYcW3gXa8h1PP8Ji6cwyOoQunajIOuFEyXtJHHvt899NeWH4C0EiB6gXIyDWaYa1xHxYvP71sLGN9TYwBCEgEyCzeV0a29DdKUKkUewTVjrDqBPjVFrdS2L2oRhQrqrzHao4TIJxqdd1TexOtrFFfEu2j9nkkOduxWKFWQ4JUnRVpATMRiUmKdRFCQAa35mujnD7etvyfBOnVY29B6hgsk7su5M1/nJWH5hz825DFXD94pLPsVufw4OIWx/Tozb5Zm4AFBeWM7ns6JXSLn0eukOvxzlZLF0vfhX9phdP1nbABgsIiqltfx8is/m1pQcs9tW05jbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2cDHIGXFX6V+UR4y0uPkWR2gkOrqCXB9govW31179A=;
 b=ynpMwCQ+a4Gv7iagUyEJHsq64MayoATOKz03Rv7i4b9vgizZNHqfNpLNeKorL43qXA53IyKuz50LccPu3orsd5klXxWp/N/aWqTOPzTOzCanGHG2ZVhMIHTXxS5nMXgaoaJRi52hoI2M+ESdGTjOSMTK8u5DzGmGQia16Bh2Gmc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7936.namprd10.prod.outlook.com (2603:10b6:8:1b6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 04:49:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 04:49:33 +0000
Date: Fri, 12 Sep 2025 05:49:30 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: Barry Song <21cnbao@gmail.com>, Nicolas Geoffray <ngeoffray@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        David Hildenbrand <david@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Linux-MM <linux-mm@kvack.org>,
        Kalesh Singh <kaleshsingh@google.com>, SeongJae Park <sj@kernel.org>,
        Barry Song <v-songbaohua@oppo.com>, Peter Xu <peterx@redhat.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
Message-ID: <6558e0c9-fb6a-4f2f-b9e7-0647ff64ba66@lucifer.local>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <a67129f8-9ff6-4109-bbbf-4209f6dfa3be@lucifer.local>
 <CAG48ez0GVWV024kPe6kSV8c0LO7coACYXf9-85iqw+T+paUi3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez0GVWV024kPe6kSV8c0LO7coACYXf9-85iqw+T+paUi3Q@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0203.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7936:EE_
X-MS-Office365-Filtering-Correlation-Id: 046b50a2-7f63-40da-5ed1-08ddf1b7c41a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHhnRVpHblU0ZGZuVWlZMEZKbThtSXYwcGJxQ1JFNXZRMmpMYmdqQmI5U1Jk?=
 =?utf-8?B?b0F0K1ByTUZ3UkNPTXVOVlRXMlJhNyszOVVQQWFsQVZHLzhJS1BzWUtCTWwr?=
 =?utf-8?B?RzlrbzV0V2l5cUpMOHVqVTZLMFVEeEVFMVRMOGUxR1BHalVBdjFKZmNJcUUz?=
 =?utf-8?B?ekR4YXV1MFd3QXVZOWlnTEVZaTZ1UGtvYmMzelhQQkdCOXppcUN0dHRYTE9q?=
 =?utf-8?B?NVFuZlMwYmpmSXdwNlFJVGl5R0pCbi9SVlVsVHE5MU5QVmh0dk95bnNucjEz?=
 =?utf-8?B?aTY2QXBmZTB0aDVDeGJqZHd6N25TWWEwYmJtQlBxOWtCOHpLUE1USFBIdzJ3?=
 =?utf-8?B?SmpLZ0tITWVJc01BbmNKSFpoK21TK0V2Q1J1TWJxYWkyZnBQL21sQVhMK2t2?=
 =?utf-8?B?amJvYVFmUjUzRFY5VVhZVlFvUHF4Sm1VcFUvV1Z6MENvc3hQQ3RZdjR6Y1Zw?=
 =?utf-8?B?ckZGanRJWDBTNlRxcXVKRnNSR2pBNGd5WE5PQ3F4Z1ZVZ1lnM2kxUnIzWlQ2?=
 =?utf-8?B?Y3l4S3dTeUdFTXZrWkFPYW1mTmZMNXNaNGVoekZ3ZUI2bUYreVRGd3pHWW5I?=
 =?utf-8?B?dmZxTVBtTldLY0c0WENaVEFXMXpXUTRNTk11USsyNTFOaTk5MUVOT2pOekxn?=
 =?utf-8?B?ZmptSkx5OGdleDdpMFhkZ0c2aHB2RktCOTExMCs3eWwwcmZhWWRaK3k4QmV1?=
 =?utf-8?B?UHg5dUV0QWxOTWN5L0hON3p4TkJvNENaY0dOQWNHWFlrczhCdHlWYksvNE82?=
 =?utf-8?B?RWZIWVVRR1NHaW0zNTQ2NXRUWmJ3aTBNWTA2c0VFbHpvV0ZraWN4eVZtdFY2?=
 =?utf-8?B?WWEwWE93Nnk5bkVEUDdvcHRvMm5VS29TekZmYUphKy9oek9VTTZKZEVzQk53?=
 =?utf-8?B?NmZlejhZVm9CM2tkdGdReHhJRHNTQjFwZ3JHeEFIaFZ0aVFZamJKb0pCRWNE?=
 =?utf-8?B?VnRvblRyeitiQ0wveTU2aVNNcTN1MytGRllPdzVBa1RnejcrUWo5RXpMVE1E?=
 =?utf-8?B?WGpjb3RRaUhzV2J0T1I2RVlPTU1mTStPenc2MGdtYWdlWC9OK1ovNSt3Ym1G?=
 =?utf-8?B?b29tb1NYOUFEZ2hBUmlvaVZXMEhHRExZWTFLdGh0Z1h2Zk1iRW9rMW1mcnVr?=
 =?utf-8?B?SlJJT1ZsTzZKeExBWHQ2Z1JlVUtuM2FKeUtBUmx2MC8zbFk3NzFaSG9idUhZ?=
 =?utf-8?B?cVBxWE5WbFVxcWt1TDVQN0FiZGlQMEZLeVVRR3MwdlkyQ3Ayc01qeWRMSkd3?=
 =?utf-8?B?elc0VFNxb2RCeVJHK25UUFBFN1BTY0pMT3V6QnBkRHFkSUFsMjhoRHVDbkp0?=
 =?utf-8?B?WGN0OHA5NldEYzR1eDJlSTRMNmxYTGNEV2lzZ1hJVXUwVVUvVmg0VzVvK0ZM?=
 =?utf-8?B?MVIzclF4WjVWZUNqL2R6YjFBcWI2MkpkVlBmSVV2OUNyV00zV0ZEelE0YzQx?=
 =?utf-8?B?c21vNlMrVThBUTVhRy82SFZDaTNyNStvRWJiVUxsSkQzWnNxTC9Pa0pYbVN1?=
 =?utf-8?B?aWJ3YWJnZDdLU1FCWk4xTERMVXFvTjhyK1QzWE54RWVlSmd5WE5semNObW5v?=
 =?utf-8?B?TEFkQXlUc29DeGZZcTBRdGxuNGtUMU9vYlBoSXJqYVhqU2NXekVVVFcwNGVB?=
 =?utf-8?B?OEdyL2NubForSDZVbFpiRUNrMmlkKzRpK1R3YVZyRTZTWk1zcmJLU1QyVWRa?=
 =?utf-8?B?cUh0MmxIbTMwYlFIbjIwVkhOWFVaSisvRkRxVldxc3dxOEc3QTFUK0x1N2xx?=
 =?utf-8?B?YVdQeFVWQnA2MUcxRXlvazNTY3NVd1IrTlBvYXJaQnJMeVdkTWJFTGN4bThH?=
 =?utf-8?B?QlVudC9QRUNaQU1yZytSbWZtdkdTUlZPZFBYaGlvT1FUdE5jL0J2OVk4UlRn?=
 =?utf-8?B?RVVyQWQvNkJOalFKWXhsL1ZQcEQ3WHVsNUtURDdzSytMNDk2cy9zR1B6ZWRk?=
 =?utf-8?Q?bSFQ5jTU7/Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akNldEpBUVdmNVhNVHpZK2VORTRjWXRtdmp2NXU3Q3JDWllja2ZQeXFvNzRm?=
 =?utf-8?B?bWpsQXNLc2V4bzdMSmVDNlRVdkpTcVhTay82ajZRdGRZb3dYODV3cVBVQ1pC?=
 =?utf-8?B?NnRXSjFVeFRYQTNXaE9CelU3cGlSSkNKVmp0UVNvMmpaaHFNY0R6UUs0b2xX?=
 =?utf-8?B?S280a3F3TUpMZXl6Um1hQ0pIWGRvNWRxYU1LQzdnajR3UjhuRkQrQkN5V1BR?=
 =?utf-8?B?S3VFeGJ5Smg0Q0pmTFdOMFM3S1ZaOVB1M1owSmIzcW9BU2pIK25qUDRMKzNo?=
 =?utf-8?B?clV6ZHhiMk40c1lPV25QeFNiQkxpWXR2MkdVRTFUdHRNeWY0MnBTY1FidkN5?=
 =?utf-8?B?dDIwTHFWMW5STzB0UEFoQmdFbUREQTRlemw3VHFIb2p6cUhKa2I4NDVGL1pT?=
 =?utf-8?B?YzhHN2FySWVEQ1ZoMXdOTDRHQ2o2bGRjS3VQOUk4czFsRzJqTTU5TVlIZVhn?=
 =?utf-8?B?VmdHbmFhS1R1UDBrTDNFWWlSU1FteGRyK3Q3SW9oQ2ZtVCtUellOZmQveGsz?=
 =?utf-8?B?cHZITHlzZWJYZlo0cGRMem1YVGQ2bng2M0x0bFdMcmMyU3dSd3BOa0ZwbDBy?=
 =?utf-8?B?M1AzVkVNcitEVnhQdnYycnlQdlNNSnp4c2gvN1R3eVJGVFdLTDNtUll1Mi9i?=
 =?utf-8?B?VkNKM1J0Sm9PMjhRRFh6V0szNWFyTll5L3FSWjVOU2RjTDhtbkI2bFlOUjFY?=
 =?utf-8?B?YktWMyt4amdrSDBITERQbEo1bW8yVzVISmVKWUZhY3p5ZjV4THA2eG5LWS9z?=
 =?utf-8?B?dzlCaXcveGNITkFkMUllT3R3MjNSTXJpMEtSeFhaSUxmOXc1UFlrdzRlRFRy?=
 =?utf-8?B?R05SSWhTK09PSjAvNFFJcHR5QkwzOTRzalVGUHI2ZEtZUzcvWjhBM3lvYWwv?=
 =?utf-8?B?cmFmaXB0QVB0SVRqK1RNWjlaRzdZa1lVK2YzUlRTd3dVVWdIbDlKZFhZZ1k4?=
 =?utf-8?B?MUxiSnoxQXR4UWdFWjRsenVJMkIwb09HSHhwT0owK005cVNFd0xLWldmY0RX?=
 =?utf-8?B?TWdyL2xsY0RDaXhadXVZYW1nUTZHeDFkRm9POXV4RytsTnBJSTJXWENPQ1lC?=
 =?utf-8?B?ZThDZWFQZ1JoMWZIUktLcW5hMWJtMjVKYkhLY2tZcUZ4dUtTa3lyZ3p5SVJq?=
 =?utf-8?B?dUVqRm1LSW1vS0hWNDVTNDlYdFhkNDJOb1NQcy95Tkh3MnRQQ2VCZjUyTHNB?=
 =?utf-8?B?dHVzVHlGd0FIYTIwUHhvMmVZeDFGN0UvNmsrK09jdGhubURDRUpEQnNXUkhR?=
 =?utf-8?B?eDNxOGx3bS9lUERnNVE5SERGc3JBZmxqYnhzOTROeHlMRkl0ZDRjand6MWVw?=
 =?utf-8?B?Z1FsVGE2UjFpL0dRNVUvK0RiTGdFVEFRaEY0eU9tK05JSVd3QndmVXJ1VDBh?=
 =?utf-8?B?YTBnSEhrSmhLU2MwNTc2ZnpmZmJQSzhhUW9kTmZmVDFTbHd2WS9ycGRvRmo5?=
 =?utf-8?B?a3EwcE9EWTFQUjQ5TDdaQXprN1JRc3N4RU1OeHdkSlVZWnB5TGE2a0RyU0Ez?=
 =?utf-8?B?cjVYVFVUenQ4Z1kvMTk1ZXNGVlFweFhCUFNKeTNLaWErY0VicnBXeUg4MXI5?=
 =?utf-8?B?WjlNdkl3VUlnUnR5YkxPWmhyeGgvNEltNUVUN0FsQk94M1B6TVh4c3BSNHdr?=
 =?utf-8?B?UDhUclV4aDgzN0s1aGFUYmhiWTRWU01aaFl3dk5kOVVJNm9wSUdFQi9nclk3?=
 =?utf-8?B?eWJTUzlUVFpLd0xRbExTci9iWVVpNlVmTnFIQUZaK1owYnlSWlEyeGxNak9r?=
 =?utf-8?B?QTFqRUMybEU1cm5taUNibFlTZUVHT3NCMVEzcVl1d0tXZGdtUW53cXp6ME1H?=
 =?utf-8?B?QTFZeWxFU2RBU2kxRGxnQlhKWW8wN0NvODl4TmJvbFVIYUVDbVNxTDJwZ1BR?=
 =?utf-8?B?SWt3Z3I3eTNvYlI5SDI1a1MwTWYxbkxkcDh1Tms2NHZvU1Azelh3SHA0Z1ZE?=
 =?utf-8?B?Z0pSeE4wWFJzZjZ3UEhpS0FRUVdxQ0Z0SDVzWDU0a0tnWUdKSXVkaFZSUjdV?=
 =?utf-8?B?NWxvaE1JN1hsOGtCL2w0ZWdHeE9ibWExNkxyRlFPd0I3UitYTHJBR1QwZVRE?=
 =?utf-8?B?NmFvalk2TGZKeWd2Y0pwbFEyd2NhRjBJdGx6WEQ5aG5BSlhwSG9scDZCVFJk?=
 =?utf-8?B?SHpwZVBCc0ErNXZjNUVYMXh5SVNoQXA5Vy85aWp1dk1tV2JVOVJZaXVSYi9Q?=
 =?utf-8?B?WGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vJ1wKvdgFAv/aNJBFGbldvbEDfadgfr61vZH+jUMNwHs3IBPnZhyn5uJgO6TRXT5iFBUqrRJhKZvXs5D8lGBNXUB1kF2Ki4UlH1Ny2kdb+HoEX8d7LMraKccuJurRP+pNiPjk08l+savwESX/OBbUhZDAYa2pzOgqOlXKxmr1lAJWumGG1giYK1HErU8pRd8hz51VsuPLfOHyVwxII8zNp6Q0umbs2KkcaTcBGj+MobxzAPEl4pDWptF4fyqKN1kW2j5Yov8SKmBWtKUA+u77plr4uBbA5wanJT2HHLWTDHfc6A5jSAhESF5KTpQ+G7iY2Sl5BWyksj8VHD/20Dur4xpcPbvHTWTZF3MscgIR5giXpysQdxO5/3gdvXovWWecnbjTxd5cp5fU9Ex+zD4nMfHPptuMClYBX2yENUiBaYK5avbbQI2tYW+j5gYe8fdx2T71z5DElBBBP2NHFc8mAbyVGOkoQQCeU7V/GhQb5MfqQGMsJLj8FBgRa/5Wac40NOA3IvWkoSNEL1bCad/Wj9Ut0WYzBGJ43dOPppwKvcMlmHne1KWDiJBtQ1XqlYO1iWKOX/vUFVH32Wzqd4piVehU59XI7DQtW4gRgfLGNw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 046b50a2-7f63-40da-5ed1-08ddf1b7c41a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 04:49:32.9503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 41e57V9xu4oMI5aMeh94Q5upt7b5+/fcCgT/RjYkArHCJrpC4RfbNDjmB/5rIbtLMrA9JxOJ6hS3HQFVCdAh8TVeWPGexXWwPduplfhUL4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7936
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_01,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=973
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120044
X-Proofpoint-ORIG-GUID: gDnwgaJ5YQIlJJXULQBnR7aZzFiQZkuf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfX/Lhcbv/jOzx2
 vADi6gGoEaJ+xFgptUvzJ4lp5JXtk2VaExqZnXVaNWtm1PehWBASvT4ejgrhcukU96f20QJoyoE
 Y8oCeymTc93V1SLf4C6+xoE4QF3qhxOl3iHT9B/2quK84V6Q4dowuF6fVJvc9EY1In2HvxMAZTe
 vI04mfiz0esy2QZvpgiXC6gHHpXooL45VXTD6OQjzYhiSzgOk4hd9McGKWy7DlI7nzEnJVRwzRi
 77OqmOp5iQ1Zj6NO7B/sKvCN7Ghwqkynuz/iHVHIYb+dX3c4h71OKCLEsRzBViPlNLKBlTOCJCY
 Yg2L0sNUjpzi5+/d12BRrjVGMLCljnCwCm/zk8aCBshMLpYQLC9LMSv87KtmuiiV3JfWVEsqUCu
 vu7ypFu9CTlk+Mibgv8TKgLy/DkYlw==
X-Authority-Analysis: v=2.4 cv=d6P1yQjE c=1 sm=1 tr=0 ts=68c3a661 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=qkqXa6-kqllfGzLHqXwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13614
X-Proofpoint-GUID: gDnwgaJ5YQIlJJXULQBnR7aZzFiQZkuf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9BDC480004
X-Stat-Signature: 5xaame946i5an9ijnh8ucuxbrbtkd41a
X-HE-Tag: 1757652583-993402
X-HE-Meta: U2FsdGVkX19pse9vqccfxOsjnXw+yFtoC3zki5ALenPSKx6IqV8kqlcyAqg7WWNb+l9RyLOSDmPlvEdxnIHubOVqz1rH1+1nsFCuRTWg4dqBi1H9CIzxfXOxRn4r8jludG6Uq+pGj0Xm6Hnq9EK6FghYXesepGSX55jDBXkgJrTcj6L6yVzX1uYjiT8PyR3c5/G6NO60nv+KgtWJvaVumVXOsZYNoPKyd5UmL8ySdGUVi0KjNaj3XBBjaKM9rvybJRtWSf74QvMLDcHDzVc+qIPDY/Iga+ow+hc9P29y/cDmZILG3eO0wwX+5PX2GLF332wKsNNI2pWuKhj/CAZLWX8ofjuc5c9XHkyqtN8QRDmmK+sxmIFljiwNiMpyV6uuSdKnQPgfq4t0nd3JS+Vu4+v92YlVcc/W16tm9BG+7DhJu5+jclpjbiptm3SSXuM5kca2tcwi3lntYvrqQ1OndHZacTi+zPAGcbPIeqbIqyprXU+EwNh7Ay0MjEkJXDmUViH8i0x6RF01Ci7UZzNtUBpumg06CN1XPVBv6EuKwvPKgsli1iTuRrMJu4/iDjEfHJX9GWA3JrODlqVG0l27dVz7zHs20kIOXrPI6CMDsilNjiQ3/tRI0KxVlTLPBx1PG856SAOqqT+eF+vtQljPmkbB7wLQ31+EmteU+UOIaf2A0G+RWJWNeMnEx68OcAqxCQslgUKX99W8cboV1jasFGy3QHux98I5nZuRIAvnQ+/wPXwAJskvSIDJDCSYea7yyFsGXbGb0jkkGLaRWirWiuQc4MWVfQdAhzFcq+CIUnauNxgZf8tQzj8S3ospbRpu65JoZIw1XBYgNXhv0KDi/EoGVHasbRNZK/nCer6zqqZ0ixODwlL3f0pwbl+JiaSIIkl6KV5zMbMavffN3URJ41nAhBluuZFj5J2zQTUHLt2PRsqUw7T/RlaAtlJ1LvfvBghcDKs0+eRehQ1c8OZ
 kQIMtqC6
 30pSlWlKsPTBQrFWJBs7a+WCp2CmJ8G9DNq9GYVkPpDP5CcgTxmIavE0tNAzQQdW13mkqlgv1/+/iV7BT0BemVqz8wBY/Aj9NYLZnhdEHl8c0af55qwjoAJT4HXxF/bmFc0I6WFm2JnaehnHYtktxnkpqSbWTTH8kccFyGIuBQ1MPCCtHpdRkZ+hjwEhfizkIsCjVFrJo94KsubnoVOWL2Ee9cN8Oxinw4HB7DMW4lgcqyIB/NqxbpITL9wuseP3mobVE5BhTa+mbzq/EtBa99dEzot2L4NYuFzNBjpNpzUL45S7gAe34L5CzOZsIuA8/ag/fUW4AJRgnD9zgzpt/JPxXsIVx2P2U2NIpWlx7t4lqfGeBVW0vWtpNt0Fln3ErtF/kBgtTytnW6fpzT2JEYZlRKBggt2FCwwejaeH2Kop456/khjacryBMFyBD2LRKZrgGKO9smFIn4CAVjVcRfwqNz46OaR/BszE3B2MGRUmThaNivag8+hzES2qRhKOxRKbnMV2iS6JvPbOUacbS6JEt61WchpQnju7/WsVWhxxm/tQje4E9PZuxXeRp4AninYJKG+rgN5hFnOn2Ofh2DdwYjdBd+NecQmfXzg8/1sUifKJLskEfQwkNN63UqrNdgNvXG0gURiAcvm9k/+5bM7se2ZjAWy6yGiDSS/GwPUHmKgjJiUFQkQAwUjlSb45o2wmXMhKTPs0Z3dYoBnlQnOkz1xYoQ+1brYjPx2XEn39g7A0hTN4bDUnAplqFYRyWlnhlsqSd78PTxytGl3joQA28sjIfqh8W47844aA775CQLYS4Y+6s2vgepw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 08:22:13PM +0200, Jann Horn wrote:
> On Thu, Sep 11, 2025 at 10:29 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> > On Thu, Sep 11, 2025 at 07:17:01PM +1200, Barry Song wrote:
> > > Hi All,
> > >
> > > I’m aware that Lokesh started a discussion on the concurrency issue
> > > between usefaultfd_move and memory reclamation [1]. However, my
> > > concern is different, so I’m starting a separate discussion.
> > >
> > > In the process tree, many processes may share anon_vma->root, even if
> > > they don’t share the anon_vma itself. This causes serious lock contention
> > > between memory reclamation (which calls folio_referenced and try_to_unmap)
> > > and other processes calling fork(), exit(), mprotect(), etc.
> >
> > Well, when you say lock contention, I mean - we need to have a lock that is held
> > over the entire fork tree, as we are cloning references to them.
> >
> > This is at the anon_vma level - so the folio might be exclusive, but other
> > folios there might not be.
> >
> > Note that I'm working on a radical rework of anon_vma's at the moment (time
> > is not in my favour given other tasks + review workload, but it _is_
> > happening).
> >
> > So I'm interested to gather real world usecase data on how best to
> > implement things and this is interesting re: that.
> >
> > My proposed approach would use something like ranged locks. It's a bit
> > fuzzy right now so definitely interested in putting some meat on that.
> >
> > >
> > > On Android, this issue becomes more severe since many processes are
> > > descendants of zygote.
> > >
> > > Memory reclamation path:
> > >   folio_lock_anon_vma_read
> > >
> > > mprotect path:
> > >   mprotect
> > >     split_vma
> > >       anon_vma_clone
> > >
> > > fork / copy_process path:
> > >   copy_process
> > >     dup_mmap
> > >       anon_vma_fork
> > >
> > > exit path:
> > >   exit_mmap
> > >     free_pgtables
> > >       unlink_anon_vmas
> > >
> > > To be honest, memory reclamation—especially folio_referenced()—is a
> > > problem. It is called very frequently and can block other important
> > > user threads waiting for the anon_vma root lock, causing UI lag.
> > >
> > > I have a rough idea: since the vast majority of anon folios are actually
> > > exclusive (I observed almost 98% of Android anon folios fall into this
> > > category), they don’t need to iterate the anon_vma tree. They belong to
> > > a single process, and even for rmap, it is per-process.
> > >
> > > I propose introducing a per-anon_vma lock. For exclusive folios whose
> > > anon_vma is not shared, we could use this per-anon_vma lock.
> >
> > I'm not sure how adding _more_ locks is going to reduce contention :) and
> > the anon_vma's are all linked to their parents etc. etc. so it's simply not
> > ok to hold one lock and not the others when making changes.
>
> folio_referenced() only wants to look at mappings of a single folio,
> right? And it only uses the anon_vma of that folio? So as long as we
> can guarantee that the folio can't concurrently change which anon_vma
> it is associated with, folio_referenced() really only cares about the
> specific anon_vma that the folio is associated with, and the anon_vmas
> of other folios in the VMAs we traverse are irrelevant?

Right yeah, true. But the AVC's link you to 'related' VMA's which are
across the hierarchy.

I think really the refined way of saying this is - yes, you could, but
you're then putting the weight on the VMA side, and the VMA side is
being invoked _all the time_.

>
> Basically I think paths that come through the rmap would usually be
> able to use such a fine-grained lock, while paths that come through
> the MM would often have to use more coarse locking.

They'd have to use _both_ sets of locking.

And this is on every single fork, merge, etc. etc.

So we'd reduce lock acquisition from rmap end, and significantly increase
it, scaling with 'how far forked we are' ;)

So this is the fundamnetal issue.

>
> Of course paths requiring coarse locking (like for splitting VMAs and
> such) would then have to take a pile of locks, one lock per anon_vma
> associated with a given VMA. That part shouldn't be overly complicated
> though, we'd mainly have to make sure that there is a consistent lock
> ordering (such as "if you want to lock multiple anon_vmas, you have to
> lock the root anon_vma before the others").
>

I mean already this lock ordering is not so fun :)

I suspect there'd be other issues.

But perhaps a way forward is, since I'm working in this area already, to
try and hack together an RFC which we could use to figure out how heavy the
cost is...

So let me try and do that.

