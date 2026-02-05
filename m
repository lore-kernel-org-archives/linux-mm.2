Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20407EA795C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 03:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87B2D6B0093; Wed,  4 Feb 2026 22:35:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8527C6B0096; Wed,  4 Feb 2026 22:35:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E00F6B0098; Wed,  4 Feb 2026 22:35:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3A86B0093
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:35:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C0AD140392
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:35:39 +0000 (UTC)
X-FDA: 84408988398.26.369D41C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9908D180004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:35:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lWPGdpCW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kQUaUS5g;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770262535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjkwRI2csenZCgeHa/1V7rNrfHseUcO690h9Sl1cAV4=;
	b=JX5syV3BRcEoQQeJ/5Qh3vwKHqqtGSFvFh02oLIKk/DppDnW6GZm4YJlbqdTsj1pNugaKF
	HTKuoHgdsk6J4YlzG8k5+v5w2J4A8rCfJxw0F3QCTquLmL5uEPjVrEQ3yj36crPY9I3yPq
	3NhtDxCH4WDdZrEJWl8veAHD/0/b3M4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lWPGdpCW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kQUaUS5g;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770262535; a=rsa-sha256;
	cv=pass;
	b=QBpR6q6a5MFjVk6dJZborMUK6gbJ5XxbRYReOH8shqWcgPt+ldBobDF1ZN6IbzZtkAlC7y
	f0PWzd7N8yjZCyfsBcVmALrM2uuEfncDraPVsCMPHQ0/4ITT8QbqXDBINiW8vYRN2m16DK
	YAqo0S11vJgLIi3TG8fIhZ7nYhcRon0=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614Mhfmo1789564;
	Thu, 5 Feb 2026 03:35:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zjkwRI2csenZCgeHa/1V7rNrfHseUcO690h9Sl1cAV4=; b=
	lWPGdpCWxEzx582zqMKcM7lVQKr5S6VFJCJ5jtYqU8oUao13TvyRXj/7EZQl3Dd8
	dfdeTHt8bWLXjebPKR9Q6vqqMsRVFjDnvydZUMDmuQoBc0AaSL0PShNoJbpnZznO
	03zBRXRSB8R7q+ln0NqBePgYTUqDELVDfflMk8LPwIGRGIKI/GTLg0zftVfgkjC9
	9tEHDuPDP45/N2w226iTCxZYRnMcVSiYcW/iO2PHJ9KRzmdLPuWtITcImhQjCAcm
	v6iNmKIHAwjfX/EZzLCftexVy2iTWsLwdFtbHgyFePNCNDw2k4PwbrgNxPHt7Rci
	kUaHUtdx8V85VbrrbrJlFA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3j8uk40s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 03:35:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6152POPu002352;
	Thu, 5 Feb 2026 03:35:00 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012049.outbound.protection.outlook.com [52.101.43.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186pxy9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 03:35:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I+GGkHP7LDtjk0HXFROIklQb4fEFnyMjqzbsSgnwh9q81LRq8V9/PF7jgOJBela+lBLemZoBJfz8OUwOcd0qwlvNQlyxdJyHI31I8zZlZfSFlvDaBoElRW+O0lO08D+jy7mtHcCMsH5GPawwxSv75Y5IcvrBumEKc3cf2Skr+gzMS9/mJCXz+MG2eU3C2UDS5PvVzUuQYEqnU3XFabB4Jayg65meiEux7Za4ObQ1YXsy3c67QBJvuV26ghyk1u5hYcbch31f4KPXTE5/XTxTzKGTNSsyXwyKa8kuN1CwiQzxBA/dtaUv0XXInB3AWsNlC+ZdyLhtCYQSXcgCj9Barg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zjkwRI2csenZCgeHa/1V7rNrfHseUcO690h9Sl1cAV4=;
 b=zEUSqhX3kXL82IgrcwU6wNVGCPuHpcb4v4GxXM/9lJ04x4oS2m8vzyH8FRgGqk2SjBK93Y2vVW/0m/MJ/mIDiF7xCoh/nsURdwhoOSQhfXID9XommWOV+86Gr7U/1STsbyLYg/o+1ihMf+XdU2WsywIFfoe+ZJ6ryeuOAW2RZeUIie61CyIqSCgjb4KnZlfF5jveBf7LvQ0qYqAxVjF5tH9ppQdZVI26A44fZxXoSXhzP9td8a3NzKFgPKBB3om3FEAulmEur784tVN7UGO8JGC9cKKhkjYavI/63CIbWEQBRyH0MTu+IcAd3PJPneYlcbGA6uxpkruS256mxI8IKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjkwRI2csenZCgeHa/1V7rNrfHseUcO690h9Sl1cAV4=;
 b=kQUaUS5gSsyRXa/V+TQ04yu6O+2xZOzT07+aWB6qGdjmzCn/nB2wwWC90mA6ycyRAA0ee3m4+awlH7c/oMgp52IYj8yTOGrtiD/jZFHVSc0KEQVrjcugKTXVw1SlZHiRURlr8xc0jAZ7CByrz1Uc/Z32OY3PVc5D+kV41WnmCLk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ0PR10MB5892.namprd10.prod.outlook.com (2603:10b6:a03:422::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Thu, 5 Feb
 2026 03:34:56 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.010; Thu, 5 Feb 2026
 03:34:56 +0000
Date: Thu, 5 Feb 2026 12:34:47 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?B?5piv5Y+C5beu?= <shicenci@gmail.com>
Subject: Re: [PATCH] mm/memory_failure: reject unsupported non-folio compound
 page
Message-ID: <aYQP1wmHFuiktray@hyeyoo>
References: <20260205005603.274383-1-ziy@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260205005603.274383-1-ziy@nvidia.com>
X-ClientProxiedBy: SEWP216CA0149.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2be::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ0PR10MB5892:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ac47064-d009-4c33-d966-08de64678844
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RnNjRFpKcGxmaVZ1WCtRTGVQV2JxSzMwaG5kcGpQT0NlZG1KS050SEZUS0t2?=
 =?utf-8?B?ME9ld2Q2YTRHSXdEcjY0VUlueE92bVpoMEdvOEMvZzNYTXBIaDl0SGsvUkdx?=
 =?utf-8?B?YWdLc1Y5RjQrckNQR0E5ME1KTzRMYTRQdVpZZFEzWnJ2bnl5OWd3ZlVEQW1C?=
 =?utf-8?B?bTZEMUp3K010UVM1aUduOGdEbWp4N0M2UUFxY0dodVN5Q0JUb2M4MWFuMkdv?=
 =?utf-8?B?aHlPK1ZvdDFUN3NtYmpYR3NXeFNjT2F3TkJMeUNEZWtBSU9icXJwTDlMN0hW?=
 =?utf-8?B?eUhrc2NtR1JzM1Z2dWo1djBZMUsrQkdRUW9JZUVYY0wwRzlrVGYwNW9GYmhV?=
 =?utf-8?B?NlB4bVB4UE85NERvckV5YVpHNVd6UlFUdGgxTi9hLzRvekdKSWRjZlhNYStw?=
 =?utf-8?B?UWZoUzFZSU52bTVQaVBJWFE3cFUvZTBPT24zaTFRL3lVbTd2N1d0MlQ4SHdv?=
 =?utf-8?B?ZWgxTDN3MmptTHVYVHRDRjhTR2JDdFVYaUloR2RyaWlMVktucDUrdlEvOGZk?=
 =?utf-8?B?Ykl6UWtTMC9icG9USTNnRFVyUERlTGhXYmdEZk1la3lFdWQ3c2QvQU9hWnlN?=
 =?utf-8?B?OWZGK1J1L3NKRXBEQ1djd0h3ODMvV28vai9jTVlreDNMMms1NVR3c0RlMnFB?=
 =?utf-8?B?ZTVJMTBTNjN3eld6VW1WMVE0R3Z0a3J2U1RJZU5rR3pEWVJoRTRZOHBRSmkw?=
 =?utf-8?B?bFUyM0NGT0pmYUhxNG1mWWh0RUdhZFYvcGVZNkZxMTFiQk5QY1hhMFdwVzQ4?=
 =?utf-8?B?OGI4UUZSQmJjc0pTWkhZMmRLWW4wQUR2eEY2Y09ub1A5enBDLzhUV3M0R1Fq?=
 =?utf-8?B?VDRySnI0S01OdWpVZXduZmRQV092R0FjTks4MVE1VllCbkdMZVFFTmRvNWY5?=
 =?utf-8?B?N2hoYkhNWXVxUUV6SE5XYVpTZDFpRytBcTByd3NlU1hVeUowVk9iczJGdjA3?=
 =?utf-8?B?NXpGZ2FrWHdwMjZ6SUhWeVFpcHJoeUVqelM2MjNkMXcwa2s4UnM2RXh0VmhB?=
 =?utf-8?B?SURhVGE4YXhXT2JYSHdpdmU0dzhVKzBBeUltUWtKMEN2eEdFcUN0RzduL3U4?=
 =?utf-8?B?QTlKZVBYSDNTcFRzM3pmZFZHWFBodmJIZXBaT3dzbXNzYk1KVE5XWmhsc05v?=
 =?utf-8?B?RzFWNGtwYWtxaWtwV215L2dFdDBMbUNtdXp1ei8zN01HcXUwOHg4TVlZWDhF?=
 =?utf-8?B?b3V3dFVnZFM1KzJxTUxUeDdzNnpDUHVDaVRqc0NmQytkTXoydXRuY3ZhSi9M?=
 =?utf-8?B?Vll5TmZobnZpeEJMUGNxbE96RkpnNDExWUV1M2hGalVvVC9BZ0JRcE54emM4?=
 =?utf-8?B?VVdPdTY1N3JlQzZlMllRTkRwOFR5SEhMYVhWYnRyaGlyMElWL0Yzc0R3SmdY?=
 =?utf-8?B?eEFGMWg1SUlxNVlEbTJBWWhnRGh0U3JhVytNMkRNZVdjVlYvUlAweWZpZUx2?=
 =?utf-8?B?dlY1UEZsZGxKcnY4Y0FxRUVwSkIyei8xNE9EWjBDZnV6WG1mWkY3T0Q2b3BO?=
 =?utf-8?B?OE1sS1BXa0VPVUdyUlErclZuakk5cnZzaTN2T2pndjV3c1FXVkh2ODZoZ1B0?=
 =?utf-8?B?UVBMV0o0UnJxRmkyRHgvUlAybzNuaTdScDg4TFdibFZ3cER5SUZyWk5SWGpU?=
 =?utf-8?B?VGdFRThHSERQTkIxUDZPeVZNZ20zeElWQ3JqaURONEJzZ3MzWUVzTjhzNEQv?=
 =?utf-8?B?MVBWT1pSU2RrdkhnVzdOUmZLcnhZRy9kYkN2ZndZaXRmMGQ1RU0yaEVpbTZ0?=
 =?utf-8?B?WWphVzBjRWNwcndQZWh6R3h2eSs4TTZtQ25qWUJBTTNocXI0VGZOaDd4cDgv?=
 =?utf-8?B?R1NxQ2s1NnFQNHRDUjE1QktrOTkxUXpraE5LY04rQVhGQ0JnTG9adlZGREhn?=
 =?utf-8?B?N0RsUXBsNG1PRVpES0RrMkd4WVg2THo3TUZ5dVhwZlJ3UEtyQUsxYi9WSm5i?=
 =?utf-8?B?REIzQ0ZEbVU5NTZjQ1lZaFFwalRlMEplT1Q3bDZyWkN4dGJCems0RytHTDZs?=
 =?utf-8?B?VGFHdmJ6cGNXNGJ1Sy9pWXVNN2x0VkpTd3R2V1V5cWJmbC9FOXBvdmFOUDhQ?=
 =?utf-8?B?TE1UK3ByMEpmRDhtakdndmd2N1RXcUdLb0F1NHpIZGRWLzBlTldabVk1MWRn?=
 =?utf-8?Q?SNDU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TjIzaXYzQUVCai9mUVNxYjhLcXVuM1k4Y1pHMTU5WCt0TndOVU1hTC9ZV3ZB?=
 =?utf-8?B?VWtaV0I4N1loZllnaUN6WmY4ZlkzdjZ6Njg2emNtZ3YrWUZ1dERLbzZDT1da?=
 =?utf-8?B?UCtHVjJOVXdSdDlXa1dmWVpmTHNxVHd5dzZyVnloaVViSVMxa0V4bFNLenlQ?=
 =?utf-8?B?R2llQTF3K1Q5aVpiaVNHdUlzSnM0Y0ZOemdoZmhVVlpJTVgwTUhmMzR5dFdJ?=
 =?utf-8?B?Ylp4enBOdXNmZXkxVTFpSjRBNzFNZ0hXMUxJWHVXYUR3TGwvRFJKYU0yREZ3?=
 =?utf-8?B?d1FRbS9iVzIvL1pTcFhaaUxNMm9iRnhha1Y5SHhVTHhxUGtFeExudFQ2RlhN?=
 =?utf-8?B?bG9mWitXMnlqaUVUK3ZVV1BPTkZZWXRLT1JDOHc1bzUvU3lIdWtWNi9kZG8w?=
 =?utf-8?B?ZzJOWWV5d0pkZFN5MW14cEJmV0trTHFJcnYrMnQ0TVBXRlZYakE4aWJDQSti?=
 =?utf-8?B?aEV0Q0xKUU10Vmt5a28xeGhIaEtWQXlFazc3NmcxNXpzcThtQ3VQb1FpeEhD?=
 =?utf-8?B?MUhSUFhxRmdNODFlaXpUYmtSVE1VUmpVOTB5RTBJNHJiK3VHZTFQTG9MaVZP?=
 =?utf-8?B?czc0OS9yVkMxT0pXMnArek9VMTBhb2xMWkw5aElmdGZhQkNnYVZXUUxPMGV1?=
 =?utf-8?B?Wk9HZ0RwLyt0cFlvUVR2QXROYkYxTkwwalZXS3k1amZhVmJmT0hoVVM0djNh?=
 =?utf-8?B?TGtUWDJ6RTVJaXRqQ3JYaWFDQm9tYk5PeUlLZTFCM1FVSDBzNzJ2cWt3dHhm?=
 =?utf-8?B?ZVhWTjloMHlIOUNmQStHRVpMbm9sQ2dTQklYelVHY3d4NDZ6NnlsUXJmZjFC?=
 =?utf-8?B?cG90VUJrMnE0RS9ZM0NZalJXRnNnQUFFZU5JeWlkemtDU2NmOGVrTEdOUUJH?=
 =?utf-8?B?SjJid2k0NUl6Ri9HUlpvcWNqOUpjckFKMkZXWnhhMUFDUUd5VU84RE84T3Aw?=
 =?utf-8?B?M3NkN1JoYUFqdkZEVXJBaFFtQnAwaC9UTkNyNHZvQndFSjQ5czE1L1hCeTBZ?=
 =?utf-8?B?bUxDM3pHbHZ6d2RQdllkWXZlWkI2cmxTdHpoc25BVmlJRHgzbU5sNGwrNXlh?=
 =?utf-8?B?WUNLWFhHZEp1M1c0cWxSWW9jczVhNGRvRU5wbVMraCs4L05QdjZoU2VVcldh?=
 =?utf-8?B?V3ZsNVZQalpDMHVLazFQQW5YUGcvWGlUV09TNTR2T3FUOStSWXZORVl4RVF5?=
 =?utf-8?B?cUdkNEszbGhGblFHSU1PbnN3UGliVFlvdmhWZ0VUdEVPY2RTM2pMOFZVU05m?=
 =?utf-8?B?cG5QNk1HVElUbGJrUGJrRzU2djJ5VkcxbnQ4bUtwdXNZOEVMWmFYNEdwR0ZB?=
 =?utf-8?B?YmErYWFJL1JuMVd6cnpwVVhKcDhUOEtPTDVCb2xzVzdPTkdvTWVVakwxajdo?=
 =?utf-8?B?bWhUWjRwNjlmNTN6bGtySFdxRXlyWUJBbG1kZnowTXZZZHpLbUxwMGFGRDJC?=
 =?utf-8?B?MFRUKzlVNnBNM0VzSS9zZ1FTNkVFY3FBcXhMTmd0dVp3OURNWXdRb1JDMkpq?=
 =?utf-8?B?LzBGU0ljMWRHWDVDWEYrZ01RN1doQThlRXZpRnE1ZWFVSUp1RGNLR2R4c2lT?=
 =?utf-8?B?eUh1NXJwSkd1UDRWQWU4UDBYS2xyS1ZvL1hqSEhTdG8xLzNGL3pRUTRFTFJU?=
 =?utf-8?B?WmM0REFnbHBtUzhwM282dDRWOHluZG9UWWsxZzJuTmJZTmVlVHREVThWSnp4?=
 =?utf-8?B?RVZkZG4xNExBVlFDWmR5ODFOTCtkNHdPSWFnOUk3dURGeXUrZXVDL0U3OVhF?=
 =?utf-8?B?Y1FhRllqNWdHckVHUjl1QXpCY3RBcFp2eElCbUJEcklWdXVWWjhJaEZNc2lQ?=
 =?utf-8?B?T2I3aVM4b0JLd29TMWVYdWRXZGYwTXpST0Vxc2Y0RU1BRDNtVG5IKytKUTl0?=
 =?utf-8?B?K3BpZ3d1VmMxejN5YUxhZzg2RitjSk5pYXhUQTRXYi93UlRuZWR4Y3VlWHQr?=
 =?utf-8?B?eFlYTnQrYW5ST0c1TWFUWS9UWFZ5SlZxZUpVL0t3OHltSzdUOFhCbGNkZXFY?=
 =?utf-8?B?dDZ0bVVUdGMvWklnSnBSeStiQjlTSmRvZDNheWpyNnBlMlNNWjc3N21BZ3FO?=
 =?utf-8?B?MUx1THRZdVZvWitJUW96dHg3SDVNUG1BaU9VSW0ySlRkWmhCQ2JOVDdvNStt?=
 =?utf-8?B?VE1RWDZLR1hZcUtZa1BidSt3MXRUNHpvb2E3TU51UmF0YmFRNjNFdXVZNVlG?=
 =?utf-8?B?RkJsN3NVdzRCTTltSzlXNWkycG12bjZDNllSRjFlZE56VmltUVZjSXlNQnJr?=
 =?utf-8?B?RDQveXhFMWlDRC9heVVOUXRhbk96Y3ZiRHJRaHMyaE9kOGUwaEIvV1lWbCt3?=
 =?utf-8?B?bDkrZVJEZmdoZExiTHU1Y0NyWVBScjQxWGViSnRWZUlIWndCSGNPdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RR7HzvXdB4AOAi++Vxjh8JfsHMs/1zcyQlskz1aGNS9BwFzPSxw5bAMIWj3GtIQh555+Bf6QBW0cEyNdkWLP41YemtfutJpAoRMVsc/4bb+Jx8eIIDmaFCaFBZMTagPt21qpasqTQLPO0DIjZoeWGRZ8DRQuL9cTFC19k81xAhOc0oXQXkihij7J/aA/1aKmKgSpuJwN4f932Ct14DxZATysnXAOGnX7R7ynKy1mPkMSHrARTI4vFw1v9cWLICTKNHP0kwbbGGs+yZr2HxB1f+pZd6WchwKMPKhj1odi64WVVCFeTMi6ELn3HJjp3u8LLIB8qhwLVzXBqiXhksTyOgwZzo7hZhNebHQaC3lZ5y5aJDzeiXYQ12Sj8bBEk+24yTZxOVthkWEvnC20oUflYWyLobBqT1lJWoAMAKp5vT3tFGnJa0dbY+v9Co+9ntGSnWZOmRxWsCxyW30FMRHa0noRudRQbDKRILp8tIuZ7aSHGg6+yrefExeodFx+7WjbWmO7yNI8AjpprerFTB4vGJeckXm6lSONttJNU/k9aOc4Lt2siDVrwi+v1E1Ca8GbcxQ8jwE4qZII6jlLlDWvayf2lTgd9b2zCws3b8L0KAw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ac47064-d009-4c33-d966-08de64678844
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 03:34:56.5423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N4R8t0toyHG+CrwomLz6AmIZSNYtHLTsZ2EsunvR8tehMTCJ2PvfuzMnU49QJETWy2KT7wqZkrIeguiWsGyMSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5892
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_08,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602050022
X-Proofpoint-GUID: DaJf0KgOWxEpo9G2m2QQ4bjA2gBMj2Gg
X-Proofpoint-ORIG-GUID: DaJf0KgOWxEpo9G2m2QQ4bjA2gBMj2Gg
X-Authority-Analysis: v=2.4 cv=BJS+bVQG c=1 sm=1 tr=0 ts=69840fe5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=UqCG9HQmAAAA:8 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8
 a=yPCof4ZbAAAA:8 a=0xksyk6nsQDcDdKhKFMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDAyMSBTYWx0ZWRfX0Q8rpaDsJlj2
 do4qNxcQ7F2GrNLHwBHLz63+i9Xy5u27i+nPriiR2h/kkwMpfGWo1LJaVXEvAXf24uCagw1FDkI
 G0pdjNrZLPRn2rhW8UQC2dCQLpOWCc397ZYQzUSvQtYwtzoGT9AnARD68tUAyG7D0NdL0NNjyTZ
 ag+VESn53PVAs7wRzhaqbPO3TYTKaiRtoQftJC3TSOqZx/BLl5POBLuTcoC3QEKX23bNynKu+bY
 aWZv8V+D9kCKAIhKxdKuajdbhkIcQ+M/fYT8R8UTTroJ1G2pcGR643tJd9m3hLtMn2NRvrLDGuy
 5j0Ao5E6QoLjfo28O/8feyml0bbdSn/ChQW00UnNr6h9XluYhYG/ccf8fCOceR7Wv9aooFfx/rv
 RJp+5CI3ikzLC5bmRJpU3EMzSm3oiqrm1p/XgDyGdtJ0C/Yve/CThIXiawwZ5akJShcv8/bf0uN
 OEb0uzoBTuZmFlw+f7UbGCuE9bvAF5JI7HXvNP7E=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9908D180004
X-Stat-Signature: 63xfczoifg6kcfhk1ab1gu4b8dnut4qp
X-Rspam-User: 
X-HE-Tag: 1770262535-915225
X-HE-Meta: U2FsdGVkX1/qL0k9sW2eYa9g1aesquilZm/+PuvJ0lKhchkMNiQxWU4sotSkwg1cyk8uemVHl5j603q+9sx/vkI/BZvVHfymHph26iD4uUqKYBtsFwVWIuybWmue8pHtkMUh2LQBgmvudIGo08Sp0v2nrhlrF8K23SK6FV52ZIE2dZ6vBoR1KXCALP6cTr7FBGU23Phm9CTq6/oUdmt1ftzeZCb1U6DDGhPYwE0807SRxtZevmlpLpbyZFHMeAKl6QF+UnMKAR8c1RbJsbv3pyLrS7tIjNI5gN44Id099XnizQ704jOA1oWWep9HZAWoNDytZpaZrsgRBluYz+Cju3Sqno9xT78IglzdnF12IR1e9ZBgcWsODJv6HQ5x1u09UmIjL9ZEIRchEfNlIeFxJXUQDNXXcZlUuVh0FBG4YPupzQS0fHva8duKYt/YXdLiaxPiIDh7P6QJtU7+zJfFj5/wkIvLDC7/btXwFz8lxmZbb0dbEwhsv4Fr1gkP/ZYs765pojLEV8gk1CrquIjt4AFDWm2Sb/N315xM5YzKv0tfL6HBAMBHtczOP18JvUkvXtAwKr0QSq0dOjDP79eLVR2ldI6FQiyNqYDxUikdKJBtP5sKnOH7pn0xJTY9M7Y1qMy4VixU9yadUpBrvqM2KtFZ3wPEdJp7wGIzv+gRWmGs8QnJkOp8l46AAHZt4q3p8nrbiplqqumNJXkagcUQL7MAg58cK1E/Q7i+kvthUakBDsdPK5HXunEMB5hSTbzpFP9FUp1PYHMMw48iOOXp52L2oPp/aZ+MG672JaorLitmczHjZU1Zm9Wxgh5IlZwymBf6pWQFXzBB9pvxhHv9QYybgozkbe8KWJ8kiKQRbP2DU6UB9VYGh0C/CMvkSgpgiuwFWmic7Uc+PaOfEwQObkL52YvoRlZptzYfNon8vnyGa1RLgK6+S6es5Zre65JHmDH6kst/zWmuBqHluET
 Pd9ozIHc
 MWU4eskng53ngeTxUShCwJMvq2/EjX67NLsgxdjvvl0WXAYE4ma7g/YObqm/NxvMh1eSKzNL0h6jj5b54/DS6wEx7hiXE1ReZz9gDUu76/h5qSPQDu0j7e/16rKEnoy3BZqz7izvV+6gBtECemTVwFhOcygBA5Qgza1p+b4UT9HZY1vFdbRidwXaMU86Ulloq+hiwwqbTnRVbFG91DXGUX0Jh5vFfHsnpcG/wLQWBfWF7NXPno7mskoXZj10LESnpEnSBcscZaRHM74UeRuDR/ZE7i0oEaHUwCCy3F2UL518VepS+nMEtbtGmYTZXxdufTVwUmo3ZAjRSnIiVO7CRdlcHQJHhpqCAHzdUol7iP2heQGARYNfgFN4RVCaoK95S3lRGk3/RrAOuWBsHJeIINlUrFSxDDHmgKS+Uh1VoEPfJ6vAq1oGf3PLzAbUMFdm4RNxacOQyx7UVCxFHcksQjptwszy6dW+n7PsDbDz1F7pEDbVIhv0w3X5HwA42N8NbUtsCTXHygn2Zhy/i9B5CDrzGot12FUCSfukNKG+4e7xWYF2EEN1Np9Ijxj9BbR06sgJ2i7pi3KUUzKy5CBOpBuOEDvnu9dzcDCdih9NlNPUI4OdbkahVgaRYnK0Pgobn+y8WhJp8Dpeccs5+1A/nlz0fJGvLKS8GeMlhRqEiz0xF5Lbb6UdPLM1cc3hoGh/jQ5v8A/0oxzAoWkLc8n9kiYWyM4yKQteuP0hHQQ9MK13RvKLZsDBgDhMi5e6UWTKinWGZr1DF1GqYHVUL7YPUGmTtX8ZZcYf+dKhbVAIYKt3/1Nyp+bjiGX8zj66zh41kdBg+U+fc/xmcnYmZA1A6k3BXmMImrCbzdInl+0sV0eaAX7uzWWGgA7IuLeZAFp5/oR6f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 07:56:03PM -0500, Zi Yan wrote:
> When !CONFIG_TRANSPARENT_HUGEPAGE, a non-folio compound page can appear in
> a userspace mapping via either vm_insert_*() functions or
> vm_operatios_struct->fault(). They are not folios, thus should not be
> considered for folio operations like split. Change memory_failure() and
> soft_offline_page() to reject these non-folio compound pages as
> EOPNOTSUPP.
> 
> Add PageNonFolioCompound() helper function. This function is functionally
> equivalent to folio_test_large() && !folio_test_large_rmappable(), but it
> is supposed to be used on struct page. So open code it instead.
> 
> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
> Reported-by: 是参差 <shicenci@gmail.com>
> Closes: https://lore.kernel.org/all/PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com/
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Looks good to me,
Acked-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

