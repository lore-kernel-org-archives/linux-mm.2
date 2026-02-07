Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0127EE6B70
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 01:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 487576B0089; Fri,  6 Feb 2026 20:26:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434D56B0092; Fri,  6 Feb 2026 20:26:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ECF46B0093; Fri,  6 Feb 2026 20:26:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A05D6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:26:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE9AD1B2A03
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:26:06 +0000 (UTC)
X-FDA: 84415919532.05.81AE80A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 466D020009
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:26:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QVLVCnnm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=p5USEnSt;
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770427563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/Y22mX8iKkOrpd7IJbM5Radlz6DbFw8bDoWuTyAu1I=;
	b=5FIAAehsXUPtXNaPL3R3zVcGfdNo2Ur/sqNTSqF5Z3OJNsEl3r+6BY9m3LJ/pYDprDCpl5
	EpTC6QBSwecGgfvM1SHuEYDIXvX1iVXlgoj0AMhn29AG6JUT+LF1PqwUrFUxRyDVD5QVdF
	uflXheMVEabmVOZE+QCwPmtUnJHVr3U=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QVLVCnnm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=p5USEnSt;
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770427563; a=rsa-sha256;
	cv=pass;
	b=tyQM0ymQlsrtp+rnB1bdmedrEbCbHIFPJedOt7Q7+90Y8y5BKgaJYjXfWSKeoTqgJJ+dRV
	ZVwoZndDFKPhozPgmztLppz+//vIAkXzUm60yWegLmoUsP1qILB2WmEFGURQsIS3yT252I
	EWdmSC12nAwKbFY6jgO+mdiqapUQCcs=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 616JuYaO3255969;
	Sat, 7 Feb 2026 01:25:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6/Y22mX8iKkOrpd7IJbM5Radlz6DbFw8bDoWuTyAu1I=; b=
	QVLVCnnm5ZZU9JwpwAVrLYQoBtf7msnk/xCBAonvFFte1vPoQCFW2MywrxjgLaWg
	+p0wSVAUrLth3TglJ3xH/cJ0KKXUJLCBebRRbObBFNVPv6dAC8JfSmKdGN/eJapQ
	wFut1j3oTHSK7CWKLp9yLoDjtBdGQoD2XZtZMJUIKbhFIaf0Z1VgYYESpCcgd0rJ
	YKHz+Zm6X6y54CSzm4IEiNKmffJvA6gdFsD3PzHO8OmbmWqYU8L9oER7h2hMxjz0
	u6/NAbwh3/4PLKmDHIrPMmKJ8xfn64wabw69o7dvLvPllgjnRZPfbQCKlFwKOTlG
	JRQxXLe2a4ykHP2pbYk8sA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jhb6bm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Feb 2026 01:25:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 616MoOqm009658;
	Sat, 7 Feb 2026 01:25:50 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012060.outbound.protection.outlook.com [52.101.48.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186sutfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Feb 2026 01:25:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vaDtKJQEM6qGojK0vHVCayeb4JM1THxW7dh4HzbzjqGjYrxo12lnRROWx7x62dJ8/IRg84/BRm8zmxdp9fnSy58HL8V+sefr4kYQN678zotxDOaHHYmUH7F7vivwY6Y12lpZ7DDW/w5GzR+zue2cSoMUbOGDv13pJtKculT68X0YZwq34fdPzMR+1U3kNPTd2S+9eljnvGIPi0o3nq9eaAgqmiV8cbXl1sxN1VHM3keT5qP7tX3ciuRZKimSge+CU6YaUqQoq/4N23CmTFz857Zlv2U0XLk4nIHxozSPlYt9NWaIGjXDfUpSAd4iro5qNfP11Nt6FKrh6qqvWQ3lHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/Y22mX8iKkOrpd7IJbM5Radlz6DbFw8bDoWuTyAu1I=;
 b=djrdB8r4tARycwc7VR6vhNJbXTuzJUKnPj5qxPv2gqUBpqNb9wjy8mSN5674p8oQqCRqbb2uG+FazozQL3XgzurSxIdSBfdGWE/ZE7MWLQTLJFxJ4HImwxoAcW1o20qBvSnUZtqOCmfPnwVk8XAJnYU8rpTV3KIkKVsfZEp9WrrTlI+X2HEEoXSkEkkxSQMCN7gAJ0OSyPv5PSjUJr9VuUKov6Fe/e56i6cIMAZGFwTmmNZbJfwu0OvwBA6YkWf0WscqDYTMVWWGADIxTtba1bWZAq/m18calE6k80Q4fawk9peeg04rt2NT4g4F9qXS1rw1qCu3gRXcA+cmStHbYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/Y22mX8iKkOrpd7IJbM5Radlz6DbFw8bDoWuTyAu1I=;
 b=p5USEnSt8pC9yDJyeRmQQSZfJ6/1IqQ2i3wmRLMvp/mCqYvKaJg7wWimylT8UD/k61bt0HLscpIF8ok1UO0T/DeFOiMM8DYFQDglT/IdGqcBN+2G3Uk+ZH2lG2Yz+FBk3Q6A5ChqGWNAywotX1DPEdavBPFGgF6tF6dlUqlJ3ow=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA6PR10MB8208.namprd10.prod.outlook.com (2603:10b6:806:435::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.16; Sat, 7 Feb
 2026 01:25:47 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Sat, 7 Feb 2026
 01:25:46 +0000
Date: Sat, 7 Feb 2026 10:25:40 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] mm/slab: use prandom if !allow_spin
Message-ID: <aYaUlIMXU1YQKQnO@hyeyoo>
References: <20260206171348.35886-1-harry.yoo@oracle.com>
 <20260206171348.35886-3-harry.yoo@oracle.com>
 <52b408e8-ea29-439d-8e34-91c4cae8009a@suse.cz>
 <CAADnVQJ5AKmt+fNkAVRLPT5qAgfCGquBNRhg4v=U9FrH9cU+OA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQJ5AKmt+fNkAVRLPT5qAgfCGquBNRhg4v=U9FrH9cU+OA@mail.gmail.com>
X-ClientProxiedBy: SEWP216CA0073.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bc::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA6PR10MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: 8deb5860-2e36-4a99-be6d-08de65e7d1df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZkFtNkF6MmdtRzRmemFHci9jcmE5eHBJODZxS09tYmpEQm1JVWFVZ1NKbUFz?=
 =?utf-8?B?VUxWdzRaemNuTkNzUkFDc1pSdmhJc2YvZ0hTRFJ0RmR1YlF0cXJvSjlrQmUr?=
 =?utf-8?B?THg3OVRDSHF1TkRhNHlHVzBFaWI4NE04L0dLYlFYN1hjTy9jc01kVHNJZTRD?=
 =?utf-8?B?dkFxV3ROU09SQ3hiOUxyU0JwWTRoLzYwWTRBeG9IV1FvM1B4SWRDM3VITm94?=
 =?utf-8?B?eHQvRXUxTm82d1NkVnNHK3cyVVNzaDE3Sy9vU2FoVlVhakEzamRURjBlcC85?=
 =?utf-8?B?YzNuVGZtNWdpOThoeEtrNUZZMTBiK05lTUF3Y24xUEgzTmR2ZjYrMWNjdFUy?=
 =?utf-8?B?VUdpVm1DNW1tQ05sdVB2SjBNd2tLeCtneW92YTR0dm42UkkyZVR3WEtXWjVy?=
 =?utf-8?B?RXFLUmptMWZYUWZTMk5MWko3QzVhdDUxdTFlMHFGNUZtQS9ldTJDdEVZWGZE?=
 =?utf-8?B?SDRmcUpZV0tQQnVGeGhoNTVRM0NwQjZCMHcxQnRyZ090ZkVlVDBCdkkydDdN?=
 =?utf-8?B?RUpUOVJHUm1XaldOSGUxdXhYUmNRRDY0Q3djQVp6dGNpVFg2RHpXMHhmUUEy?=
 =?utf-8?B?U2ZpK0pyb1Vya0x3RGg4MWdZcjQ1aGVOQng3eGo4RE8vL1h0ZVFKbzcwbDhO?=
 =?utf-8?B?MnFYOCszaUZCa0YvSEkydTkrbGNnbnRXUlMrUy9FR0o0R3R3OHMyVHR4bXVs?=
 =?utf-8?B?dndmMktaSnYwNDk0MjVwQ214SFV5bXhWeWs0alJCWXM3MmE2NUQxSjVkZFJO?=
 =?utf-8?B?WmtXZFVJMkdZVS9YSGFzSGVIVTRWUnFnMmhSQUM2S2JzVEdPbnNQVlB4SUhM?=
 =?utf-8?B?dE94N3lhdGw4V1NXOUZ0STBrSWorM2g1MTlVMFhCOWc2V3U0NFJZYUVHQ1ZI?=
 =?utf-8?B?d012VWlKTmtBOWRRRTV6WjlIUElsL2JGc1d1allhK05vTHIyUTdlMjNVaDNo?=
 =?utf-8?B?NktoL0dQVkt5OTh2S1BMZHVaT0dRWnc5ekVram9zUG9vOTE4VkR4a0lBY3dJ?=
 =?utf-8?B?L1plRnhDUmJnSDRvTWcxMGVIODNaeG1iMUNybnpEVnVYdU9kOExEQUxmN0Zl?=
 =?utf-8?B?U3h1YmtHUXpwUzRBaE1ZejFjM1lPemdVL2ZGQlZGTExvWnJ6M3ZiRGJZRVZL?=
 =?utf-8?B?eWljM1dxb3lMbVB1TWFlVVFnRnM5MStidndaS05WOWNHZjgxcSs5emE3dWNr?=
 =?utf-8?B?UkgrNGRCdU9OdFIzN0xqQ1piS0ZRYWNTWWpEdlk4aGZUQitjeDRjZ2UrVlZs?=
 =?utf-8?B?UmJsQnNVMFcxUy9OZlFJSHZ2QUNtdlZCOXdhcEdCb2gyZUJCK1laNWRlRlFT?=
 =?utf-8?B?MHVPM011VlhOL0NLcDVXMkpuaVBQeUYrUDNlSFQ0UW9STHRtTjlHaWVUdXJF?=
 =?utf-8?B?a1hESUt2L3Q3amxsSUt6K2ZRZ21wYzVtc05xK2dFQU5KK1FWY0pYUlVyRkRN?=
 =?utf-8?B?c1hnOHlWcWY3NFl1UzVra1g3NER2THJlR1VQV0svUjdoL2FlUzRhNEtZbDZR?=
 =?utf-8?B?S0RZbGdDRjR6VnQxbkx5Q254MzkwOTRqOUJiTzY5TzUxWUlDbjVMZEdGNkIz?=
 =?utf-8?B?QnhMTFlsVFRqN3RMT2ZKVTFhRTVZK1NiUWhCVXN0S1NBSjFQYWNpbTU4MHRC?=
 =?utf-8?B?eUNQRFpWOXJkMW5qZ3FtRlBQQ0YxYW4rNW95N0NEcGNRSGt2bHkzbE5mZitQ?=
 =?utf-8?B?MVl3clJoaWFoaU1ZSUNleDJNOGxvRU1aMy9MWVZxK0ZDOXJ0VE8xY1FVUS85?=
 =?utf-8?B?dWRsSFZzY0V1TzVvSEU1cG1YRG5PMkFXVGJ3V09IRzJKMm9wVXNiNnZkcTUr?=
 =?utf-8?B?WmhhdWFMcUNLZ1BlMjZycHRvbWRzRmRhTitTRjNZN0Y0UGtzYXVBY0szT2Q1?=
 =?utf-8?B?TUIvN0hXUlAyMndXNWJZL0xDTVJ6b2dPNEt0cXBXT3RNOWlaK25QUVFNaGJ2?=
 =?utf-8?B?RjA4Y0thaGQ0QWRScytzcnJyN28xYURuNVZMZnZpSWVGekRudFU1WGY4V3B3?=
 =?utf-8?B?VVg0R0w3eXZXT1VBRmhuWmdMU1p2UTUwYnk4eDIzTmx1anBwWnNSZTI3eXdX?=
 =?utf-8?B?UlY5Vk9tR3o4Y29zbWlVaGE0S1VQK1Y5VVhjTkU4cmwzenBDeERjUGRab1ll?=
 =?utf-8?Q?CB1CxgzVU67slGuYoxqguKN/N?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VjNkNDBkcWNUd2c2bXF1M2RMUVdMVk1qU2FxQ2t6S3VNaHdRT1Fab2hZS0NL?=
 =?utf-8?B?YWpwR2NQeVV5Y0lIdGlZY241ZG8yeldwQm1xTTlBNEEwaWowb05iVzRoTEVj?=
 =?utf-8?B?QWVyZis0cHZvQmZJVXpEK0NFRVlyNkU4R2dYTnphaDVaVXFZcE9vWlEybDNy?=
 =?utf-8?B?NVlFMnJ5UGRsZGUvUWU2UWRyWURBSjhteWkrUkdSbkJ5cHVjVUZleTJNK2RK?=
 =?utf-8?B?MmRWUzFjeGROZ0dlbFVwS282ZU9YV1pMS2ZZN2xTWlVDQStjSzhVaThqeTVu?=
 =?utf-8?B?MG5jS3JpMkljSnFUTUhYTW9iYU9KdUMydWI0TjJNOTR3dnB0NGtJa3ViWkx4?=
 =?utf-8?B?TkhWMG1KZDJSZHEvbWc5WEZRaVJWQlVsQmdsZzZhQ1lMczlWVURid05BMGdJ?=
 =?utf-8?B?TVM2NnRLcXRsdjA1aHJGMmxiYmRQZ0gvemVGcWJubkdnVGVQK3FtUnR6NTdl?=
 =?utf-8?B?dHV2VzhrdnVRRkVtQTFsLzhkTUJpQ1E3NGZuZzgwRHB6MXJUNFF1OXU1elZ1?=
 =?utf-8?B?dTBEbm5PRzNSVUZoR1c1RVNzWTVlRWlOS2o4OE45U25BWnhhajZ4dHdaeVYz?=
 =?utf-8?B?Tnd4em9hMXRwKzNtTWltYkFoMHJKSWhPeFNSbVk3RmJlaVBqQ2FLYXhWQUpI?=
 =?utf-8?B?NFFsZXhVWTk4OGFhR3dsbFphbkxRM0o0K0Ivc0M3OFRtVGQwbGEvL0ZFZW9S?=
 =?utf-8?B?YVdhNHVSSUtnTmhrWFl2dTdDa1Y0enZuRUdSdDNIQ0h4K3l1eXpVSTV2RE9k?=
 =?utf-8?B?TmQ1NlJYU2QxVnJORHcyZzRtWWdJM09EeDdHbFV5bHZ3aEVET0hOMHVmaWxn?=
 =?utf-8?B?UFZQNUcySTJybjdlSVFNNExXVWdWeHZxWlFIK2oyNXRxZlJQWU9KNTN5VGpX?=
 =?utf-8?B?am43aEd5N0tOZ3RwTGlmM1BGN3MwUGNsbUJPMmFtNVJYeTQrQ2NtUFF4OUZq?=
 =?utf-8?B?eFVoZW5wcFRpem9UT2k1OWJMblNRV0I2QjNVWHVDbnVwVHh3RXVKRkR6WVk3?=
 =?utf-8?B?eFpodzhoek1CZklDc0JrME1sak9YOGpxN0RLMFUvNG01V0VPdFZpMDZMcEtj?=
 =?utf-8?B?WE5DaklnSGhlQzVlRFpUMTFRelIyYmY3elVxQitsaDdvU2dWck04MHFXa001?=
 =?utf-8?B?L043Tno4aEZLTEpoclp5VkR4NWlvSkJWTHcvajVOTXhSazhJUGhHTjF1Tzk3?=
 =?utf-8?B?UmVqQ3J6UDdicDZ1T1llcEhvVnc4bEtEaUdpTkpReit2TjAvS25IY1ZTQzBs?=
 =?utf-8?B?Z2pEekUvNzJaYmUzVGRJTUdMUTVhUjBXRGxFZ3Y1MFJFckhqKzU2UDVaeGlM?=
 =?utf-8?B?NUVjZ2x1N2daUktFb3FPTU81Vll1aFE5QUdidkpHMlNIVFVkVjZadjhQZTBi?=
 =?utf-8?B?QUtOZXd4YjJaYy8zSSs3SWovYkdDdHR5bFNTYmlJTzRKTTZnMDVaWFpkcUxq?=
 =?utf-8?B?Q1BZa3RzMjR5eHFSTlZkZXJsN2lVaC9sZ2tDN0tOZ2hlMUFkZU82L2xmSW0r?=
 =?utf-8?B?b3grZ1NJYzJrQ3pHZUprQW95a1hWWGVIWUVBWHI0ZmNwM0VZcy9pVlM1ZFVz?=
 =?utf-8?B?VTRRKzcrUCtBR3RwRklEdDBST3VIUXBWYVJsY1EvZGpvT1FZTEpGU1ZyZWZo?=
 =?utf-8?B?a2pTSmx0OEgwYlNaYXBXTndMc0VQejAyMm9tZkljNzEwMndWN0hzank2L3NO?=
 =?utf-8?B?T3U3eUtPRWdqN2syTmdWMGE5VytIQkFtanZobHJObWUyYitPZnRkTTYrK2xD?=
 =?utf-8?B?cDZZdWlaVk9KK2lHYitkZHBkeU80M1A4QUNFQ0dMS3Y5c3VpS2dVSHlKTHhJ?=
 =?utf-8?B?MTI5aHpsUmpxdGkyOGg4eE51eTNIdDl1akRXanlhT2czUXZjQ2RHTGhsNUhh?=
 =?utf-8?B?bktKNVBpejF5Q2xaL09MZ2RMSUtjUyt1ZGlydHB1UXVVN0dDNFVmQjJJSG0v?=
 =?utf-8?B?cGkxU29iVHdyK0xsRHRVSjZMZjBWWkQ3UEEzaGhZQW53amp1MEVGS0tNODNi?=
 =?utf-8?B?dVFiKzBpWDloYUpMSnFwM2p3THBScWF0cnJiMW02SkdQZVVvWjh4RVpSZzhi?=
 =?utf-8?B?WDBlSlpiVFV4SHNvU1FST1V5ZXBtMDBLVytMQ09UU05LMXpSZzQzb3RuYXJu?=
 =?utf-8?B?MmlDZzdSRk5Rc0txV0ZncGtma1lMdlpsblZHTjF0N0FZckFYNTFEd2tQUE5K?=
 =?utf-8?B?T280T3ZFV3JvUExKNDFQei85dGF3UUt0V1IyR25sb1BjVG1VaWUxY1ZaZVQv?=
 =?utf-8?B?R0FGNWtrVjdES2xacnZvU2QzdU16VnRRTlZXVGhOWFAyZENOeXdUUHI3UTJl?=
 =?utf-8?B?SjFZcVB5QVhNb01Qb0o1Z0llNWpxa0JxYTZMMG1rU3d5TTBadHNodz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ADgjBWH1atwnGiv0vsiDoxag/8a5/vBAjoC4tzTTa/MrI3vlZWLVXRQ5PJYqg/dVPdX0Ptleb9FYSPlWyUMipcR85COAgg0SaG3j43Z5r++MKMhkT9H/uLExPDrAUhnybTLhza3LCQCwBIzUAGHNkTe6xhbjpTapBMCYIl4l6qkd0VKvSQ73mY9Zr8linBGCTCTvjB8acHRbYalenJtN5o16onGF7sGGXYJkyqMEWebpMlghJJmv5Gdg5SKMeXinag3nYAJXQl3wQkGAPSkVOX90GRl7bhls+/xkoio0Qy1b/nLL5kgWRABoK6LlFe4/Rig7esN9K4EhdVlMtoqi0wgSLK7SCd5TYi9W0DAOdt7GU1oGrwpfICoGuhJb8ry44t561OZ8E8TDgMwYfP9oneTXF5duiAtbyIK1Js8t6BLRquC9SnxOFbyBefp+9VFFFlTjGv6RO8Ya05Qrh6veGgsOjCxX4eakACU9ohFFRr4nN1CbbvcqAzx2h8ktFunPXu/9oi55MOPu7q/pr1pClmJ8YfgwfCQ03U2fQ0ryCi8XZfARPLWQwLYGwCtmpuHeM5VKK39c4nxvkMoVitM5i/Z1lVs2f3oi9ztY51Njd4E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8deb5860-2e36-4a99-be6d-08de65e7d1df
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2026 01:25:46.7431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iauMrc82LaZKG5iwNXQ1Kb4vzpg0neJls2FCdmB66tR2J0gYUATyvFelLFMdxgSQF+L5flCHE2SNjGHI/fU8pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602070008
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA3MDAwOCBTYWx0ZWRfX2RtdOQxKMYpo
 R/8CIo3zXv/4MlwifPb/8AikEjff8l8v+UkZFrkk/MhwexnLvWhGAn3Ni6eCCVPQopj7Ufwfxcr
 OD4qKnrwU6ojpepVanHnKKCq6vbUVc8xBfdXbJK78S+ush16/SxntEjf2paQ8C5DwI3Vfg9MWOu
 DjLVe6obiJZMF9q4mX0R7yvUDgZk8bNam9ndOdHWNCUeZezg4U25rdbKxOkugv1N4CY0RAqGg8R
 UICTg+I7o90otyicVCU/YIGdjhbIXhD6UP6Vej3aYlF3dbt2XS2RLsh2AimQQVfQNADVyMmjoQG
 +vIm/Nw83yY0oRmFUxqIxNJ6mq8HI9zVx+a0+aifFPaurxMds9erg0kuFyUc7D7Qyv33FB2U5c1
 NWBzIPtqcygdZ9FGsVv9Rj1RJbtO1ZYFED6yBVzH0Qxnw2fCFXgYqzGjxGQ+guwup/MFX06foao
 a7Eqg0JmvsMvYLXSpWJTl5aKSn8V+hQ3rurUE+AY=
X-Proofpoint-ORIG-GUID: QrhK1O2wSJl0JvxCJh-kPpRCxEMWqWpd
X-Proofpoint-GUID: QrhK1O2wSJl0JvxCJh-kPpRCxEMWqWpd
X-Authority-Analysis: v=2.4 cv=CaYFJbrl c=1 sm=1 tr=0 ts=6986949f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=-T-YLOhXaYDv1lzS0EoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12104
X-Stat-Signature: t59ynin64ztub9wa7srduir7ccgu8o3k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 466D020009
X-HE-Tag: 1770427563-115110
X-HE-Meta: U2FsdGVkX1+A3AMfaVwtfe/y/K/UXU2GF/Nl3MjDg0Ke/6FflvBLFXiV1BVC7sAeakVqHE6rRH78PP3xnJ7kDpToH8SfDEkBTTEd7zzR0EKUe57KCuPFos9S3QjIpvJ7eQlnvqNCUpoMVFuh8klZB3WX3NaTGcunvXOEWAJxHTwxdjw6b2FmVSHWGgOT/3lpAv1zlFM2b4dc6GEYubfXDjMHJMVN83yeKR7TkLJBpjpfIWmm3sKHbHsA/JUlgEe0pCWOnmkoQOXMY1tEgbtS6GJOAs0rk80oH+D5jVT1FpIct1zTTVE8LqoNoXSjdY1oeuuoHffih7DPPGXDUmaCVzvSxuz5V3+WRXEtW1KINZ7xFWxDrnBQ3LEu5BJzdAvjEDqhE2ZUKASAg825YpRwT9kFKgZ6rChKmP23spGi7Jx90GMs1VuZqTMgYS/bOvOvHVpd9XwWAHiWzK2BrWUhaAUg9voFNAmqFBT6xJFU0wH8M4rOLVbiz9Ne/vP0GV6KFigo+V5aoDBXH1Yu5i74PuinRknZ1QM/PWaMa9D3+lbtKS+AVcbiX306TGy9idNLXVCTUAfzhJ8G5F+2uz2NgKGTjMw81XMB9h/zvLK9IVEEN1ik6NtzkTm1l+YVfyXifzhLcOTWD9nppmcMWlH3YExZ9hXemz/efui9qaTCo5EgZrVffb8yPLHIW/7cYKv9Lk4QEgVuZSFFAvasplKvy0bewhSd2pirJLYVMByJ5qTmq0TzVJX+VDA8jUOLdVa3PNIvdq0PgG8ialkIX2BoJMMs2iVkA1kte280xWEo/EIOFytGk4tV+P4VbVvgV5x+LsNkMLBgbjP5XCF94iUnpDkjhL1BoOvxZOguceunQhH1/Qh+ObKt6Md9aEf0WCpGs6AiE4iqMejvZTRR3+qr7vg6gij34b4k0nk5Q2HYcM3ZqjXSJOC75ehDIjOzxch6psfkYNAAf5lXUs5LlKd
 CiTSBzmu
 iJXdS1cZv1vqiPMI/iVC/DH6l7s21PkImshufNuDvtGkCHlCowV0xvqf7a5nEO+mQ2HFwJtMt7wIkyesollED0CueNCm+9WZxuGuGqmzpQ/EHWxaWQ2KP2h1U8jdVTBi9r+FnstVjD/6kpvPcet+i33X4xN5kSTH1cEoenqtohYWiJsrUZWgmKm3I2AGMBpQMRXy3/5m2+xHpqkjaNC7YNDjb2HH/bCk5tcKS8U1B+U+PtfmcG81/+M7wbeASs0LlGdbRxuhbt43uWqQP9YKrYAcO6BMiia16DKW48eQ4HMo2oHCCBfBlX96dW/vkplq1/qFsD9JmSpxcHMKo9kH77G9Sver/5YOYanbvZUd+DJGLQhAetRu8Wjq0oAB6fYttoME/cSApZA3JlX/O1aAGXXyvaJtaQetTPBsxe/AA3w94paseV7Wbc0EuT2HMFk3dLyOlvrL3SNPRPNMo3/4zCpUak7RuxGsb29KW+b0NErBkt1M9pQEp/8kloBCLR3ujtxjlc+M5a9LJLMbv9UTUQQ0hMAs6NKg3OJC0Hj4VXxLZfK1jIf1JMEUa73eQfRD1+VlpoHOHALXoE9FGOSA2dTEjdqRkyiSm3D/WRsFmSHLLn8a1lTtttvUSb3UzsioBLuStpc7a3aQ5BHtV5ESulRBQhfp7sOLpG/RegtF2e06wOPLmFuQXsk5L7ewbNv5as7p5EKSaI0ymo8xpqenjwDKr3D4i3Z2Qahak+R0Is5rGr1PfrPQHtlAOD48obVPbr/pdhy42LAlHA4AOIOO50HQpqXXfJO6KHSM/OPSL3iKyp4KzTvCa2Qe8/o0njwDW8BdGfjnjVH+VXOq/EX7n1FJJkqF4uBwP6Fkzl06BmxDk/ujD8dEw3ol8U/ozYDz56hWH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 11:22:27AM -0800, Alexei Starovoitov wrote:
> On Fri, Feb 6, 2026 at 10:27 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> >
> > On 2/6/26 18:13, Harry Yoo wrote:
> > > When CONFIG_SLAB_FREELIST_RANDOM is enabled and get_random_u32()
> > > is called in an NMI context, lockdep complains because it acquires
> > > a local_lock:
> > >
> > >   ================================
> > >   WARNING: inconsistent lock state
> > >   6.19.0-rc5-slab-for-next+ #325 Tainted: G                 N
> > >   --------------------------------
> > >   inconsistent {INITIAL USE} -> {IN-NMI} usage.
> > >   kunit_try_catch/8312 [HC2[2]:SC0[0]:HE0:SE1] takes:
> > >   ffff88a02ec49cc0 (batched_entropy_u32.lock){-.-.}-{3:3}, at: get_random_u32+0x7f/0x2e0
> > >   {INITIAL USE} state was registered at:
> > >     lock_acquire+0xd9/0x2f0
> > >     get_random_u32+0x93/0x2e0
> > >     __get_random_u32_below+0x17/0x70
> > >     cache_random_seq_create+0x121/0x1c0
> > >     init_cache_random_seq+0x5d/0x110
> > >     do_kmem_cache_create+0x1e0/0xa30
> > >     __kmem_cache_create_args+0x4ec/0x830
> > >     create_kmalloc_caches+0xe6/0x130
> > >     kmem_cache_init+0x1b1/0x660
> > >     mm_core_init+0x1d8/0x4b0
> > >     start_kernel+0x620/0xcd0
> > >     x86_64_start_reservations+0x18/0x30
> > >     x86_64_start_kernel+0xf3/0x140
> > >     common_startup_64+0x13e/0x148
> > >   irq event stamp: 76
> > >   hardirqs last  enabled at (75): [<ffffffff8298b77a>] exc_nmi+0x11a/0x240
> > >   hardirqs last disabled at (76): [<ffffffff8298b991>] sysvec_irq_work+0x11/0x110
> > >   softirqs last  enabled at (0): [<ffffffff813b2dda>] copy_process+0xc7a/0x2350
> > >   softirqs last disabled at (0): [<0000000000000000>] 0x0
> > >
> > >   other info that might help us debug this:
> > >    Possible unsafe locking scenario:
> > >
> > >          CPU0
> > >          ----
> > >     lock(batched_entropy_u32.lock);
> > >     <Interrupt>
> > >       lock(batched_entropy_u32.lock);
> > >
> > >    *** DEADLOCK ***
> > >
> > > Fix this by using pseudo-random number generator if !allow_spin.
> > > This means kmalloc_nolock() users won't get truly random numbers,
> > > but there is not much we can do about it.
> > >
> > > Note that an NMI handler might interrupt prandom_u32_state() and
> > > change the random state, but that's safe.
> > >
> > > Link: https://lore.kernel.org/all/0c33bdee-6de8-4d9f-92ca-4f72c1b6fb9f@suse.cz
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > ---
> > >  mm/slub.c | 28 ++++++++++++++++++++++++----
> > >  1 file changed, 24 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index d46464654c15..4d76af84f018 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -43,6 +43,7 @@
> > >  #include <linux/prefetch.h>
> > >  #include <linux/memcontrol.h>
> > >  #include <linux/random.h>
> > > +#include <linux/prandom.h>
> > >  #include <kunit/test.h>
> > >  #include <kunit/test-bug.h>
> > >  #include <linux/sort.h>
> > > @@ -3308,8 +3309,11 @@ static void *next_freelist_entry(struct kmem_cache *s,
> > >       return (char *)start + idx;
> > >  }
> > >
> > > +static DEFINE_PER_CPU(struct rnd_state, slab_rnd_state);
> > > +
> > >  /* Shuffle the single linked freelist based on a random pre-computed sequence */
> > > -static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
> > > +static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
> > > +                          bool allow_spin)
> > >  {
> > >       void *start;
> > >       void *cur;
> > > @@ -3320,7 +3324,19 @@ static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
> > >               return false;
> > >
> > >       freelist_count = oo_objects(s->oo);
> > > -     pos = get_random_u32_below(freelist_count);
> > > +     if (allow_spin) {
> > > +             pos = get_random_u32_below(freelist_count);
> > > +     } else {
> > > +             struct rnd_state *state;
> > > +
> > > +             /*
> > > +              * kmalloc_nolock() called in an NMI context might interrupt
> > > +              * and change the state in the middle.
> > > +              */
> > > +             state = &get_cpu_var(slab_rnd_state);
> > > +             pos = prandom_u32_state(state) % freelist_count;
> > > +             put_cpu_var(slab_rnd_state);
> >
> > I don't think this prevents the changing in the middle? We just stored the
> > pointer in a local variable state, but the prandom call will still access
> > the percpu variable through that?
> >
> > So we might need to disable irq here, and have another percpu state that's
> > used when in_nmi()?

Oh, my intention was not preventing state changes in the middle.
I was thinking "Hmm if we can't disable NMI, do we even need to disable
IRQ? just add some comment saying it might be interrupted
in the middle".

I was even thinking of using raw_cpu_ptr() instead without disabling
preemption through get/put_cpu_var()...

> imo this is all overkill.
> Just prandom_u32_state() without any protection is fine.
> Even if it reenters there is no harm. Just more randomness.

Yeah.

-- 
Cheers,
Harry / Hyeonggon

