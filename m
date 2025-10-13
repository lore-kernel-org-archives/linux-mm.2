Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0F21CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 11:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11DA8E0031; Mon, 13 Oct 2025 07:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE91F8E0007; Mon, 13 Oct 2025 07:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89028E0031; Mon, 13 Oct 2025 07:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADC798E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:24:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 455B2589F0
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:24:06 +0000 (UTC)
X-FDA: 83992856892.02.212CFDD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1A7A840004
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:24:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dxvwpkTP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pBBAX0BJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf07.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760354643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/y4tFZBqdJe+rakqkb3ti+6/KcT/yIOL7FIV6cL1mA=;
	b=bqAATB/IDMu2VaEvEDfiWGCYqNaW1Fx3Aai17oobKikDmZqL5uKaPbS7xGebMKHMDExsFk
	ZTVP0zdBtC/YbEJlGQ6/BRYBDPuSOhaf2kSkG6YLMY6ZECBGDc0gykHRzVVCjttUflaDYg
	lLv7rqIQzltQeX0W7AGigEw30JYa6Bs=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dxvwpkTP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pBBAX0BJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf07.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760354643; a=rsa-sha256;
	cv=pass;
	b=2vOuhyST95v4ovxwTS/gAyijBuuPyLrS6o/JQTjmj1cg3fHzEEfLoSJLQjCzuUZOeFEzJI
	Ow8QNhRGOvgQI3R7uFq5bXnolawKAy4vzMvvZtSvX1QuWKRWlBIp/2a6BBjwo09yP9/zZv
	nsL+gDv0bmENRPwJShYHl2IVRUCbN2I=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59D7u4C8032445;
	Mon, 13 Oct 2025 11:24:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=l/y4tFZBqdJe+rakqkb3ti+6/KcT/yIOL7FIV6cL1mA=; b=
	dxvwpkTP5gysW4yeJlq/aQO6l3NVctQk5HGBbld5SNqezYwvhhPb5b8a9nNKz09C
	8dapAliKFcGtU9CrUVd9dihMWJWp5IsjVj2dkoR7xdhwW7TSY1p8rLrQqq//4JuA
	I0AT63kOpowwhZ4Jn/nBTT7eakb5HyBKjzEaVgR0Pr3QrQfiyGB50bwQgqnQCtVf
	bfkxu+Ygg0ugtIzwqgg+y6lwWEXdUD1AlTPVY9fRYt5QhoP1AsPBRV/Svu4Sb36a
	fMQDA/30ZFMACKL++xQkoiICRToRP9ZuHHtJm0WAyGjNKWX8tIeNQkKmF8Z5Si3/
	zGpJDiDgS+zd+5m/rSRnuA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qf9bt1a1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 11:23:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59D9QlUx009788;
	Mon, 13 Oct 2025 11:23:54 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010014.outbound.protection.outlook.com [52.101.46.14])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpddkvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 11:23:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bGiRLGywynbiXKXDBmu7o2r6bYXmbmHf6k2lKAQfCKywm2iBztu275sofULbET3HbDPdf51o5tTx2QazH/z09VDf0rxk8uCJ8fqaUYcgEwTUSxxLXZVlc8kiREWjK9DpY5SUsQtqv+e6ZRd1Xb4mDjdFGG2opjxD1H6+P/yBxy3GwfiqNDcWcuSBZhKF3s/ZzLOJHC/Dsd4+XlHy0XdiUtiJTqAjVw96q7JV3IO8+5NbVST7dwzwiyQvBFrqgWVGN0gnWo+9GTYsfAmbgM57cWmxnC5A2wwZmCJdmXXeloo6EzJFm5DJ011Wxa4xhjImOgVeNx5EnwimAMNJV2OAjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/y4tFZBqdJe+rakqkb3ti+6/KcT/yIOL7FIV6cL1mA=;
 b=llN6EZgfrZk708bUit6EtunVNpavDLVWdmmOn4CYeOO4h8TddWS3TOijUv5/z45+/PLv5IAvUVuogaN7JAzj/e603k5hKcRifs9PK9X/szxHODLA6Mj+W+86pygUR63vPRQqxGOG9BaQnb/0ABkDtwhqN0KhmXAwKCVnBftmaxQdzkaCIhLQid4aSjKlaUYcl+DMU+ruTDhPvRpV+FyT+32rXt/8MiKzX3QpyQ2VBU2Qjj8SJb99DBM6L1G8/cyZFTNq8/T/w/7EzOfEY2RlltufhuBYJtXB4J+uFSAP7uX4iF0/bcK2iX5ETxOWiXOuD95BEIE0BHwd4LHDqSK6MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/y4tFZBqdJe+rakqkb3ti+6/KcT/yIOL7FIV6cL1mA=;
 b=pBBAX0BJj+tzMOtC3T+t524IepEwpxw0K+MzCrWL75Oiy6aUiB44sUtRBCQRVLqq1Xa8SKQuI0EXHQ5yi6E5gQ+QaRyi1owGpYPtOYbKgSt7CufUFn4yYam+KzXFTAns++9GOjUod3okg/MPlSH2RoHvVY1csLJJci4rNuwhShA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Mon, 13 Oct
 2025 11:23:50 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%4]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 11:23:50 +0000
Date: Mon, 13 Oct 2025 20:23:39 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: syzbot <syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com>,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@redhat.com,
        jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, riel@surriel.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>
Subject: Re: [syzbot] [mm?] INFO: task hung in __rmap_walk_file
Message-ID: <aOzhOwtLUS-A09Jn@hyeyoo>
References: <68e9715a.050a0220.1186a4.000d.GAE@google.com>
 <CABzRoyYLxqdQpLf5JBO2qjpw0G=b8diuHs6WA3Bn24_0Ynu9oA@mail.gmail.com>
 <CABzRoyYzfgVW8EVzWRGyg17C00C44X8-JoNzcB3LZmMqWDoK9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABzRoyYzfgVW8EVzWRGyg17C00C44X8-JoNzcB3LZmMqWDoK9Q@mail.gmail.com>
X-ClientProxiedBy: SE2P216CA0054.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:115::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: a5d7850c-5d3b-4e29-69f7-08de0a4afb6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWhYampCbDlqRUZoVXFNREpxcDN0L0N6S0FqSXFWQitkZHF4YXJOSGROWjhW?=
 =?utf-8?B?OWtLcnpMOFl6UmcyVXhGY1NGNlBhVFZuWXROQWxBSzl2ZXZ5MVRUd05jdnRT?=
 =?utf-8?B?V2gybXkwQjcwS3dJM1p0eC90dmVVdjMyQ1Z4ZDZ2TW1kQlhlNDNHeHFHbDVv?=
 =?utf-8?B?am1JR0w3TmdNdllJNVRMcS9CWGpXYlJBU3FnSFQyTWFnb29lQ25aZmZvZDJI?=
 =?utf-8?B?Y1MvcWlVU1VCbVhuOHJ4NXRuMzhKWjVLNHRpQjc4KzkyZHg1UWRFRTZvWUdW?=
 =?utf-8?B?cUorMTNlbGN1YkVBcUVFR3NpYU9BNzJMZkRsaTVyN1dvbStYeFR6NC9zRnh4?=
 =?utf-8?B?cXRmSUtZOHBZdUtpZ1RuSzZuTmlIVng3MGpTMTRLazdDaWlMdnp2SlUrR2l2?=
 =?utf-8?B?dkF2d2tJbXF1MnludDVBbjg3MWhNU0pkOUVDVDBXNFM0ckJ5K0Q0eXIxUEhs?=
 =?utf-8?B?Wm1NMGVBSWhudjZ3Y3pHbHhtbFdCQVMyYnhydVYxd0RUc3RTNUc0Qmd3T1lW?=
 =?utf-8?B?MmpjdW5JR1U1VTA5amdrdWJqS0o1TkordkM3c2NPek9WaFRqUGpheTlHWUVH?=
 =?utf-8?B?Mmd0K1pnWWZ1MXdpOTRNVndmVUNvV2ZrcmttMFUwaTZUOGxyVXFtbkw3enky?=
 =?utf-8?B?Uk8xckxhSjhhayt4TjVnZVZibStOMVFYK0drNE10Wnl2aGRWZ002QXdJWFVM?=
 =?utf-8?B?WXloSE43TUZMYUJBcnZCdTlLRHRsZkVlUWdMVDZ4UXA2SXhlU05oRm1PQ0o3?=
 =?utf-8?B?VTRYRWJib1BPQ3I5a0YxNkhYMTdXb2ZwQ1h5Lys2YkJtQnRrVWJ3MlhZR2tE?=
 =?utf-8?B?cXhxRWR4R2YrV0NucnhFL0k0TjlOdWd4elNuOG1WaGloNUdQTC93aExUS0Q1?=
 =?utf-8?B?V0l6RWkwYjNhVUVqMnJIeFAyM1lXQjZEZWxEU2V6ZGlPUGRBYkNsYzBldWJY?=
 =?utf-8?B?RlpFTElNeDBFcW1FOEVBckl1aUdOSGJ2cEY2alYycTN4VnZwdGprRGFBcWxy?=
 =?utf-8?B?cXVBR2V3Z21CRHVNZm1uKzBtUzE3WEoxSWpDNWg5OUtJb2IzdEl5ZTR3MjBM?=
 =?utf-8?B?Y1B0SlVNb3VBRUd3bStjejA0aXZNSndhNDNJcTAvNEhRU1JZYmRIajFFbitX?=
 =?utf-8?B?elNoTy9BbUo1aHFFTkVYRFppVEtRWUVvNUpUQUcxVWJYdWlMWmJvVWtoVHRQ?=
 =?utf-8?B?VWNORUZpUFZrMTkrZWVpVCt5MTVoYlV6SFR5QmkzOHZtT3pFTERNOERJVWhT?=
 =?utf-8?B?M0xldjVyRktqOHpEOWMvSXZFbTZaa3FIUW1ZeHIxei9aSFBTem55eVlNYU1r?=
 =?utf-8?B?WXNMYy8zMzFJUWxLNGVmNDRxZG04cUhGa2xHempnUkpHdFFyWVYvS2hvRGZm?=
 =?utf-8?B?T1NOYmdPZG9wMnBWSlh5M3JyY2pWSHh5VE4rNjh0eW94ZDJGcmU4T1V6UFVI?=
 =?utf-8?B?akN1dm03QUNvemE5MTZST3dJSmY5VWdqYzhqL3c3QXNoQjBMaktoOU9FV3oz?=
 =?utf-8?B?d1hFUHBTM0RUeUVNVlFxTjJGYWpZWmRWK3ZXUzgzVWluN3UrRWkzei8xNCs1?=
 =?utf-8?B?MnpIMThBRjlzUTNiKy85dDJudGcxSUUvNHQ2QVFWVGtObitQMmV4WUtPMlBl?=
 =?utf-8?B?NEh0bTZIV010eXBybkR3K3dGcGpXUS9neEt6VXl0UlZiTzZ6NWE1eGY2QnNi?=
 =?utf-8?B?cmZzUGdSbEZ3L2orcUxsL3VDWC94VEs5cWs3MHVCZXNZRFpCczh1UHB2TFR0?=
 =?utf-8?B?VkRlR002YXVSK05NbElKNVlteXkzY1I2OWtuaGoyRElSU2NBeEdPN0FwMVY0?=
 =?utf-8?B?alQvWlV5U0QyNlR5OTUzUkp0NVBqQ25yRE1iMmZINC80NjFySnI5UlVsTllH?=
 =?utf-8?B?aFBHaUtVNEwwMmJoSmxiY2VaZ2FDYVprWThwcUJrOVo5UVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFF0T1F2K25XcDZ6Y0JQL3MwYXZkUkFobnlFL0JacVFLeVRmTitZaGJndVR4?=
 =?utf-8?B?TXlWUGUydXUra0VXTDc5cjdSK0IxaFpYY09VZDNDMTRDNFVaaGoxQlU2enhz?=
 =?utf-8?B?cnBSNXFsOXFXUGJTdjRDYkNVVlNaeGZ4eW50MGJVNEthL3FqMjhXMkdvK1V4?=
 =?utf-8?B?S0U2UTZnTnI2NXBvdVNyQnlxVGExWGVKTlhrZjhMakhzdzF4K296Slh5M0Fa?=
 =?utf-8?B?R2lBS0IrVjZIc1NuZlFSQmt2R2ZJbElsQXQzSzI5M1ZsZElEUmxXTW9JbzZ5?=
 =?utf-8?B?bFlNNGpOeGpVL1JUM3ozc1drNmJhZUw0TmN1QVVPNTFXOEF5SkNYUFRTVmxZ?=
 =?utf-8?B?aGNFYlBUaHZGZkFaMUQxZSt0QlFsUExqTjcxbW9JeVNUQ3VremRaak5BSVp6?=
 =?utf-8?B?RHhlUytMWlVHOVg5RngyeVZVbEV2SDh2VGN6aFp0bXRBLy81NFNMNkRvTkhR?=
 =?utf-8?B?OGpBeUhIVHJ3b2NUNDd1dVBXVlRWNWo0VTJyRHFPSWRKVDU0elk1bVNVN3NP?=
 =?utf-8?B?cHFDTmMyWlhRK211UlhoNktBdmtxYnlwdkVXdEEwb2o2NVZKRThMV2pmbW5l?=
 =?utf-8?B?SlVkVnpiZ1d5YTRUbnU4K3VWWjd5Vjh6QnB4eDh0VFdFM2lvZ1dNS2MyRWlz?=
 =?utf-8?B?S2pDWTl1bmhpdG9IV3poeHduSURnVmlCUkN2aUxBQytWTHJVSmdqRlBpQS9N?=
 =?utf-8?B?VGlPdEJrdHMvam1JSmhnUWprZXFFOXBzL3BtczNXUGkzeDR0Rnlwd3VzQlgx?=
 =?utf-8?B?WGZJRlBXQUZ4ZVV1VnJUdEYzUjcvQ0NiMWlpTm5GaUVoRW5DUk8xYThqSGdk?=
 =?utf-8?B?Z3hSUjJxcWZrUVJST0s3ZWNja0Z0cE01MHlqemJwb0lINUpPdS9PQnlqUkV4?=
 =?utf-8?B?TWJkamY2NUgydFNsVVVGMHUva24rTVkwdng3L0hmTTY5OTRhVXkza28yUThm?=
 =?utf-8?B?V2NuNnMvMGFnZ0ZYb1ErOCs3VEV1NWs5QjdOTWFQdmg0a0hZMkNmMm1mZnRH?=
 =?utf-8?B?NEFrZFNvQy9aUWR3Zk14SUpia1J2UHRYVE1uK3BTWEU4S1JleXFjc01xdUZ4?=
 =?utf-8?B?Q3QxMTg4U0dIQzE4Q0F0Sk43Z1VWMUlzVnlaN3JFb2NQbGRkU2Y4a2hycnR0?=
 =?utf-8?B?SFRHMHIvM3VsNDIvWkRyV0lLd3ZIbCtnYnVKaEFtanNYakZjOHRoblFSZlVr?=
 =?utf-8?B?OHdnU0ozaHFBS29JR1E3Zm9iYU52eXFkMWRvNjIxSGhVa3gxUnc0RHhGSU4r?=
 =?utf-8?B?dUNDSFg0WTE2czNMSisrdktmTGYwY0xuU0tCcDNHNUVHbklrbG5GNC9PN0U5?=
 =?utf-8?B?OUJSdVZwUEZ3cUsya1NjVmNBODZCTVRQVm4wbUxFL3JsMTJzTW1oQTJnVFlo?=
 =?utf-8?B?bDcyQUZXNUpEaXJJclFwT29SNTJUeThiN1A5MFJDeXlDb3A5dUtrMXdrV2dH?=
 =?utf-8?B?T1RMMjhCWitnWmRxQWtZdllYVms5QVlxY242RjNiVjhxMlJFdFhzVndDMEgy?=
 =?utf-8?B?NG5ieUdCK2xzVDBXeXR1THhaZm9ta2I1UE5pUGZPdjBLTGhKaDZBZEhUbVh0?=
 =?utf-8?B?aW9SSHNDOWxmejB2MHhkOU1hRDJUS0g4ZkFSemNId2VldEptenpuZVJlMWQ5?=
 =?utf-8?B?SFdqcFYyZGl3NHJJaWR5My9MUm84WC84d3l6dnUwNHBCL3VNc0JNdnFvNDNO?=
 =?utf-8?B?ejdza016U0ZLZURrQ1VzelVUWTJjVGY5dmRnYlNvTjc5WXVyVC9jSTNQcFlz?=
 =?utf-8?B?b1Y1KzBpOWt6WU9UV3BhdTQrK0p2MS9mdHpTcy9ReENEcmx6Q2ZrK2NCM1Y0?=
 =?utf-8?B?VS9ieWxxSW8zbXJzMUIrVyszd3gyNlFkSG10VnJiOTNxWEVnVTRPZGlteHhz?=
 =?utf-8?B?cDhMVTllNXYyaXhkU0srR2IvcFVIcUdwaDJPTW9ITUgyczNOT1lWWDZEeERX?=
 =?utf-8?B?aERvR2krb0xtd0d4KzdSd1Yxam5lUVpjcHkzNTBrTFBZUDVSWVZTWEEzNnpk?=
 =?utf-8?B?QkUxdHA3T2l6dVpPNkxEVmlmYllVTjdET0VaV1d3cnZtRGVsSnUyR2YwUEtN?=
 =?utf-8?B?VFk2TEoxOWJlaHpQb3VXLzIzcE5ON2xheHhGclZzOEoyNExNVmVlb3VxNXkv?=
 =?utf-8?Q?q8xWoQ8bFxqTxx6B16/jFTIyC?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lPhA31iupO2s1+8/HN/SgWdA+te9pdtV6vP4maYMLLW418ESVOVgiUk5/ZP4F26tO7joigjy357RCBaKZiDRF82tLj1Gh11M5UmYhjmX96776555Ax7uhEmmGm1LNhwLvsTAdAdNwMlCrHCq6KnGw1y04TD9+99Ja7Y6p6Zc74sykrA7HBjfmmiOYHBWF6MoYZH3VJV5/8nsB45dbFvLOcx4tpDNKv76tgU6touPGVc0VXa6KMQDNGmlrW8jM+vM30CMyPOGw1zKnrlE5ossX7r/vhEG7wbjM1UiToHpxI/EJPYAheO6IDPickWS9jq4/IHWJCDM4CwjZwjCHZ1tdDDqHH7Dq7l99LfMEHodfGxd7l2YIo/PCZAnG230xfKQjkdk+qlQTmFJ0FnBFIZZB/7w+PcZ4ViXbgdPeyMlKEZ0VqtdG/+Ou11BewQ1Hu6T7eaOxwcU7QRSPfTWCLJUchVAhwya8LJh6io1PrQsZZv3hLBkNBUol24O1hgwK7H37tEmhcVtxIWaE6acrfuOa0AFAoq3iFm/AzbTnwxNB2k3XFSnjl7UynJAnOetY59yzZBs7EHdFM7JhzjSjvVLFlnEtoPTlrPwpRh+tqpsp/M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d7850c-5d3b-4e29-69f7-08de0a4afb6b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 11:23:49.8025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EhopRe2+WUU8EsZIRbCjvhKdsuvMNaomnUI66Sljf3paE5yF+dMLgM2RUjteTgc9lcFbwQoiycLE+frvl93eZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_04,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510130051
X-Proofpoint-GUID: OFFTk_mIAMI8lxrNdwwJdmq0TYCnsf_i
X-Proofpoint-ORIG-GUID: OFFTk_mIAMI8lxrNdwwJdmq0TYCnsf_i
X-Authority-Analysis: v=2.4 cv=QfNrf8bv c=1 sm=1 tr=0 ts=68ece14f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=3g80flMcAAAA:8
 a=oHvirCaBAAAA:8 a=hSkVLCK3AAAA:8 a=4RBUngkUAAAA:8 a=WDfTfp9nZxwohloeVnUA:9
 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=slFVYn995OdndYK6izCD:22 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22
 a=cQPPKAXgyycSBL8etih5:22 a=_sbA2Q-Kp09kWB8D3iXc:22 cc=ntf awl=host:12092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNyBTYWx0ZWRfX/0qQdCuyGOCT
 djVx288pgs9CcqKVDS2iyFOC0AGUcq4n8uATz6dLU/eDWgwMGaE/2TyBD2i26fzOmX5f59Acqmq
 ocmu6EmrW/rmcorQPxgAgkJm/yf97GrTp2tqz8DyN0HWN8BT8rmUmBghKkVf2iICSZ2XrnWGL/a
 QIxAatXnCNKgk0rF5sjLTAvQsqrtf9m3oooXeX8vcLKTH4dTMeLeJEzDSTzqyo+iJF+L2UzVTbM
 zCN2MsbKokyQU1yUwr27PwBnbLkte6q9AH73TtdhtHS6hb0nUeLTlUL9xVsaTAtY5QoBzdDaMlZ
 KdHLQw35tfl1FgxRqM5I+7S5ew4GQHxTh5HiHYHcv9C9l3FfqJBYeN4Kjf2oai99e5vJumA4rW8
 4HveVv+hmLjr1k/SYyeTEcgBEt4GNuEVKaQB2iQmfxhB79xadtw=
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A7A840004
X-Rspamd-Server: rspam03
X-Stat-Signature: 6p3utukrd8mxoe4yhf9xt6hd6tz88mj8
X-HE-Tag: 1760354641-534342
X-HE-Meta: U2FsdGVkX1+YUJpt1PQn1qHA6mgdLX+mYJyMpFgRg4Q/wPmb+FIDgLDbXEbdELiseBQ3sKMxuqT+//Aany61/BvGbkumdA9YAg7eV5qej8tg5etoXBCPRhM7piktXmV2ZYodPpd8kkxiTKJmf1HtdlwEqsCB+Mh7TQjikQDg7ML7CQ0w4X6RNx8plM4dA4voaRqGfD5w647YwWhfzf1OYPKHVq53gqgFcICnVKoD6YfN8jHl4egx76tk5DNlH09J76/rTXnraTlZosN20irLWbmmfgVeznz6KSkRI6+vVNt5pKF2UX8aGzJFiTDaG6oo45XjlopTkQ8IpTTVyY4aQlb9m0zjvLd03y/hEHKngn04pRYwKBF8FFp2o3kI14+HHZTIstqYuy8HPuDjKuKlHks8cXYbRHTPsgVsBQIAf3s+69ab7dIDv0ugcAwGybe0BApXHjCHJSpwW0d9pB0zAT9qHEx/OjOZj/ICfe+zoE/nVVN+PbiYGFmREdZ0QtkD2naR9o+FdG64Hekd7klEqIqSZEoo6m4CjB8Y6wKaRP1qjSzOdnlfs7Fr+8Jgnw/y+yHoJl1WtA4Eiijw7lgOQ9VDHed3+NaB4OFwDt24n75Haapmz4QU4lQclfLlFob2a5UP3ODe/QYpcL4vuq2iuXrfPBQV969rfHAQzpI6brrwC/A3jm5clEO89NrsoTYb5o+Ji75/9ug8UCYPN/Cr5bSGrW/RBRBUSZcMXqjW4pWApnJGZwdpXPyEGXevCwhpYB/1bn3yPtK8/b2AyLFyHnjjIrYCLDvIRDPYqBqrXJ0ZO5wAFpOy3fhidTD/ZGqF5I6VBWghwCNberQ9SmTTlxDz32EbxJjh/UF1VVfbReTDG171PBRTawjJAtRzU7gLWr94LfAuEZBgB6bnHScQMGycXcV5TtBKw/qSXm1k5SWgM94JnsT2niL5tj8dB8eNAGxyGqKTkl90WDEDnM3
 nga0HvJ+
 JGOPPZeZwlP3Lqw5A+dcVG/QnrW+VG5ja2y9SpV1YLrcsynuIRzjSpIIurW9M3xUuWRyAU8nSZrH7keJ4WFFy8bqGwV/BppWogjt1AOru9GMmh54cnfurrXGg17NWxwEcWiy1E1P+5+dQnD3sUdGgB6bszzaRZnaZ1Mf99XTkTdriHMEXR7CDSvM9QXte23DHpFGMB1B0wN6p28scic0sRIxTsqdyIyWEmOWX6vs1DVq3dcb7GlEZk/ZU3HiX/V9z3pHlUxEEPC5N5F99nihret5k6aoA+pUMZquc2HHSwUvLDukr54vOld2vTE1k4YnQjyUaumAN7jaoPYu1gfdEsCSyqgIyR2CcPInMWP/WYYs1Ssau82zyzTeAqRf2K8soqwe7B+BNvFq9b0+eYX1EdYaxbsawQGHlp/Yv4G5WCOj6fBdjLmdS7NUD6GgQKODyMI0w+E6qTJxwoEMxO9Qvs8L3dBdiuNs9gcXUvmfPz/9NgP5YE9+eDSyqYkSV2dwx+E4XDxc0ni/bw0iPiNT2DZbb98pX5P4RG/F2R0rl+BqI2726vUlsOkC39CFcv1mls5xKRv+d7Dz3ggsqF+7NreeZdEl28dQepjFYH8PQBxkRnfZS3+jx7z+HxmluBmifTr1ZiihrywFtHiVlQZlKFeByOvJIj247XSHPdJzaQOREPPvd1UMYABPsBGWgSTbbDGQ02Kv5cW45VQ6ZoSWR3JLFLbiAJ1HzOxuCWTUV2Us6sdVKoPdrHZEJIKOVx2weUSR55AgLrZ0TSL5OrEKjXe/Dt2ozR1pQLoNleBtUWOVivP+RNJbeRlylBonen7ByavRQBdwNEDjqt0nXOhg9OoINKFsR45EdWF3/F9wJrCW9bJYt1P6QGWFZPUeFlZ1n6Z6smUtuhFF+M2+eNI0rhqMzO4LPTvZSILdDR5utWs53dGhrHykXTZyUxHwUgAyZIhPYmTEUQ5bhTDTcxNDlKUrmPMKv
 Uj0lkWfs
 RcyR70ozSo2x7tbRWjnG957hW/91xMNUYqrMrVb4z3z2MC/PmRQQsv27pRtoulmJQ9eU4hgzSv4H4HDUGvlzgXI5XfwWf8hSm5Fs/CDa/jJIAmcBAi/ObBnhMkNLOTW2B0kIoFUKSsC4a4xqU7GYe+cwkG1JarPn4ELwVV6841jvfrw8p7rZde2mTWR26Vzz0/7A+GzUK3A8HeMgWd4myw7jlfrlu5nEDKClQJJ0lyJWbt19hrrhsBj5X6f3KYOiSQkVE+BxiC+eLHnE+FI5WqJtWdlx0mL63Wt4LJnjBUu3n4pkehXWYCmG+iF4Ge6SlW1st9X1sb8LimJtXaRD8jv9mGUYP2dEqTfkZ8r/4k9jNyrmwqwk5cU38XyUx04IKeGjzqai+Er3ZJa3Km03TGTGxvUv05eZ+6ETPrkKRVoHgnKfOZtCkQm0twE7osVTzCUNuBzaYCw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 11, 2025 at 02:10:14PM +0800, Lance Yang wrote:
> On Sat, Oct 11, 2025 at 11:11 AM Lance Yang <lance.yang@linux.dev> wrote:
> >
> > On Sat, Oct 11, 2025 at 4:49 AM syzbot
> > <syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    5472d60c129f Merge tag 'trace-v6.18-2' of git://git.kernel..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=16d69304580000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=5b213914b883d014
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=2d9c96466c978346b55f
> > > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133e89e2580000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f3ba7c580000
> > >
> > > Downloadable assets:
> > > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-5472d60c.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/af61e8db8b22/vmlinux-5472d60c.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/a2c11e401d8a/bzImage-5472d60c.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
> > >
> > > INFO: task syz.5.48:5749 blocked for more than 143 seconds.
> > >       Not tainted syzkaller #0
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > task:syz.5.48        state:D stack:27656 pid:5749  tgid:5747  ppid:5477   task_flags:0x400040 flags:0x00080002
> > > Call Trace:
> > >  <TASK>
> > >  context_switch kernel/sched/core.c:5325 [inline]
> > >  __schedule+0x1798/0x4cc0 kernel/sched/core.c:6929
> > >  __schedule_loop kernel/sched/core.c:7011 [inline]
> > >  schedule+0x165/0x360 kernel/sched/core.c:7026
> > >  schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7083
> > >  rwsem_down_read_slowpath+0x5fd/0x8f0 kernel/locking/rwsem.c:1086
> >
> > It would be great if CONFIG_DETECT_HUNG_TASK_BLOCKER was set, as it could
> > point directly to the blocker. However, the lockdep output at the end of
> > the report already gives us the crucial clue :)
> >
> > ```
> > 1 lock held by syz.5.48/5749:
> >  #0: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
> > i_mmap_lock_read include/linux/fs.h:568 [inline]
> >  #0: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
> > __rmap_walk_file+0x227/0x620 mm/rmap.c:2905
> >
> > 3 locks held by syz.5.48/5754:
> > ...
> >  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
> > i_mmap_lock_write include/linux/fs.h:548 [inline]
> >  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
> > hugetlbfs_punch_hole fs/hugetlbfs/inode.c:691 [inline]
> >  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
> > hugetlbfs_fallocate+0x4b5/0x1100
> > ```
> >
> > 1) One task (5754) holds the i_mmap_rwsem write lock for hugetlbfs_fallocate.
> > 2) While holding that lock, it blocks waiting for a folio_lock (according
> >    to its call trace).
> > 3) This starves the other task (5749), which is waiting for the i_mmap_rwsem
> >    read lock to perform migrate_pages.
> >
> > From the report, I cannot tell who originally held the folio_lock that
> > blocked task 5754. I hope this analysis is useful ...
> 
> I believe task (5749) is the one holding that folio_lock. IIUC, that's a
> A-B-B-A deadlock:
> 
> 1) Task (5749): Holds folio_lock, then tries to acquire i_mmap_rwsem(read lock).
> 2) Task (5754): Holds i_mmap_rwsem(write lock), then tries to acquire
> folio_lock.

[+Cc HUGETLB SUBSYSTEM folks]
 
> # Task (5749)
> migrate_pages()
>   -> migrate_hugetlbs()
>     -> unmap_and_move_huge_page()     <- Takes folio_lock!
>       -> remove_migration_ptes()
>         -> __rmap_walk_file()
>           -> i_mmap_lock_read()       <- Waits for i_mmap_rwsem(read lock)!
>
> # Task (5754)
> hugetlbfs_fallocate()
>   -> hugetlbfs_punch_hole()           <- Takes i_mmap_rwsem(write lock)!
>     -> hugetlbfs_zero_partial_page()
>      -> filemap_lock_hugetlb_folio()
>       -> filemap_lock_folio()
>         -> __filemap_get_folio        <- Waits for folio_lock!


So this is against the locking order mentioned in mm/rmap.c?

The order should be mapping->i_mmap_rwsem -> folio_lock instead of
the other way around, or it should use trylock variant instead of folio_lock()?

-- 
Cheers,
Harry / Hyeonggon

> Thanks,
> Lance
> 
> 
> >
> > Thanks,
> > Lance
> >
> > >  __down_read_common kernel/locking/rwsem.c:1261 [inline]
> > >  __down_read kernel/locking/rwsem.c:1274 [inline]
> > >  down_read+0x98/0x2e0 kernel/locking/rwsem.c:1539
> > >  i_mmap_lock_read include/linux/fs.h:568 [inline]
> > >  __rmap_walk_file+0x227/0x620 mm/rmap.c:2905
> > >  remove_migration_ptes mm/migrate.c:471 [inline]
> > >  unmap_and_move_huge_page mm/migrate.c:1520 [inline]
> > >  migrate_hugetlbs mm/migrate.c:1641 [inline]
> > >  migrate_pages+0xc98/0x2930 mm/migrate.c:2080
> > >  do_mbind mm/mempolicy.c:1539 [inline]
> > >  kernel_mbind mm/mempolicy.c:1682 [inline]
> > >  __do_sys_mbind mm/mempolicy.c:1756 [inline]
> > >  __se_sys_mbind+0xa47/0xc40 mm/mempolicy.c:1752
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > RIP: 0033:0x7fd36cd8eec9
> > > RSP: 002b:00007fd36dccd038 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
> > > RAX: ffffffffffffffda RBX: 00007fd36cfe5fa0 RCX: 00007fd36cd8eec9
> > > RDX: 0000000000000000 RSI: 0000000000800000 RDI: 0000200000001000
> > > RBP: 00007fd36ce11f91 R08: 0000000000000040 R09: 0000000000000002
> > > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > > R13: 00007fd36cfe6038 R14: 00007fd36cfe5fa0 R15: 00007ffec3386808
> > >  </TASK>
> > > INFO: task syz.5.48:5754 blocked for more than 143 seconds.
> > >       Not tainted syzkaller #0
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > task:syz.5.48        state:D stack:26920 pid:5754  tgid:5747  ppid:5477   task_flags:0x400040 flags:0x00080002
> > > Call Trace:
> > >  <TASK>
> > >  context_switch kernel/sched/core.c:5325 [inline]
> > >  __schedule+0x1798/0x4cc0 kernel/sched/core.c:6929
> > >  __schedule_loop kernel/sched/core.c:7011 [inline]
> > >  schedule+0x165/0x360 kernel/sched/core.c:7026
> > >  io_schedule+0x80/0xd0 kernel/sched/core.c:7871
> > >  folio_wait_bit_common+0x6b0/0xb80 mm/filemap.c:1330
> > >  __folio_lock mm/filemap.c:1706 [inline]
> > >  folio_lock include/linux/pagemap.h:1141 [inline]
> > >  __filemap_get_folio+0x139/0xaf0 mm/filemap.c:1960
> > >  filemap_lock_folio include/linux/pagemap.h:820 [inline]
> > >  filemap_lock_hugetlb_folio include/linux/hugetlb.h:814 [inline]
> > >  hugetlbfs_zero_partial_page+0xae/0x610 fs/hugetlbfs/inode.c:654
> > >  hugetlbfs_punch_hole fs/hugetlbfs/inode.c:708 [inline]
> > >  hugetlbfs_fallocate+0xb91/0x1100 fs/hugetlbfs/inode.c:741
> > >  vfs_fallocate+0x666/0x7e0 fs/open.c:342
> > >  madvise_remove mm/madvise.c:1049 [inline]
> > >  madvise_vma_behavior+0x31b3/0x3a10 mm/madvise.c:1346
> > >  madvise_walk_vmas+0x51c/0xa30 mm/madvise.c:1669
> > >  madvise_do_behavior+0x38e/0x550 mm/madvise.c:1885
> > >  do_madvise+0x1bc/0x270 mm/madvise.c:1978
> > >  __do_sys_madvise mm/madvise.c:1987 [inline]
> > >  __se_sys_madvise mm/madvise.c:1985 [inline]
> > >  __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:1985
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > RIP: 0033:0x7fd36cd8eec9
> > > RSP: 002b:00007fd36dcac038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> > > RAX: ffffffffffffffda RBX: 00007fd36cfe6090 RCX: 00007fd36cd8eec9
> > > RDX: 0000000000000009 RSI: 0000000000600002 RDI: 0000200000000000
> > > RBP: 00007fd36ce11f91 R08: 0000000000000000 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > > R13: 00007fd36cfe6128 R14: 00007fd36cfe6090 R15: 00007ffec3386808
> > >  </TASK>
> > >
> > > Showing all locks held in the system:
> > > 3 locks held by kworker/u4:0/12:
> > >  #0: ffff88801a479948 ((wq_completion)events_unbound#2){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3238 [inline]
> > >  #0: ffff88801a479948 ((wq_completion)events_unbound#2){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3346
> > >  #1: ffffc900001e7ba0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3239 [inline]
> > >  #1: ffffc900001e7ba0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3346
> > >  #2: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: linkwatch_event+0xe/0x60 net/core/link_watch.c:303
> > > 1 lock held by khungtaskd/26:
> > >  #0: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
> > >  #0: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
> > >  #0: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
> > > 5 locks held by kworker/u4:6/1041:
> > >  #0: ffff88801b6f8948 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3238 [inline]
> > >  #0: ffff88801b6f8948 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3346
> > >  #1: ffffc900025b7ba0 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3239 [inline]
> > >  #1: ffffc900025b7ba0 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3346
> > >  #2: ffffffff8f4d4c50 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0xf7/0x820 net/core/net_namespace.c:669
> > >  #3: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: default_device_exit_batch+0xdc/0x890 net/core/dev.c:12807
> > >  #4: ffffffff8e142db8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:311 [inline]
> > >  #4: ffffffff8e142db8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x2f6/0x730 kernel/rcu/tree_exp.h:957
> > > 1 lock held by dhcpcd/5017:
> > >  #0: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
> > >  #0: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: devinet_ioctl+0x323/0x1b50 net/ipv4/devinet.c:1120
> > > 2 locks held by getty/5110:
> > >  #0: ffff88803597c0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
> > >  #1: ffffc9000018e2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
> > > 1 lock held by syz.5.48/5749:
> > >  #0: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: i_mmap_lock_read include/linux/fs.h:568 [inline]
> > >  #0: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: __rmap_walk_file+0x227/0x620 mm/rmap.c:2905
> > > 3 locks held by syz.5.48/5754:
> > >  #0: ffff88801ebe2420 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3111 [inline]
> > >  #0: ffff88801ebe2420 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5f0/0x7e0 fs/open.c:341
> > >  #1: ffff888011d3f348 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
> > >  #1: ffff888011d3f348 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: hugetlbfs_punch_hole fs/hugetlbfs/inode.c:683 [inline]
> > >  #1: ffff888011d3f348 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: hugetlbfs_fallocate+0x3cc/0x1100 fs/hugetlbfs/inode.c:741
> > >  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: i_mmap_lock_write include/linux/fs.h:548 [inline]
> > >  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: hugetlbfs_punch_hole fs/hugetlbfs/inode.c:691 [inline]
> > >  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: hugetlbfs_fallocate+0x4b5/0x1100 fs/hugetlbfs/inode.c:741
> > > 2 locks held by syz-executor/20402:
> > >  #0: ffffffff8ec74400 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
> > >  #0: ffffffff8ec74400 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
> > >  #0: ffffffff8ec74400 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0x23/0x250 net/core/rtnetlink.c:570
> > >  #1: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
> > >  #1: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core/rtnetlink.c:341 [inline]
> > >  #1: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8e9/0x1c80 net/core/rtnetlink.c:4064
> > > 1 lock held by syz.4.7446/21125:
> > >  #0: ffffffff8e142db8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:343 [inline]
> > >  #0: ffffffff8e142db8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x3b9/0x730 kernel/rcu/tree_exp.h:957
> > >
> > > =============================================
> > >
> > > NMI backtrace for cpu 0
> > > CPU: 0 UID: 0 PID: 26 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full)
> > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> > > Call Trace:
> > >  <TASK>
> > >  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
> > >  nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
> > >  nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
> > >  trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
> > >  check_hung_uninterruptible_tasks kernel/hung_task.c:332 [inline]
> > >  watchdog+0xf60/0xfa0 kernel/hung_task.c:495
> > >  kthread+0x711/0x8a0 kernel/kthread.c:463
> > >  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
> > >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> > >  </TASK>
> > >
> > >
> > > ---
> > > This report is generated by a bot. It may contain errors.
> > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > >
> > > syzbot will keep track of this issue. See:
> > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > >
> > > If the report is already addressed, let syzbot know by replying with:
> > > #syz fix: exact-commit-title
> > >
> > > If you want syzbot to run the reproducer, reply with:
> > > #syz test: git://repo/address.git branch-or-commit-hash
> > > If you attach or paste a git patch, syzbot will apply it before testing.
> > >
> > > If you want to overwrite report's subsystems, reply with:
> > > #syz set subsystems: new-subsystem
> > > (See the list of subsystem names on the web dashboard)
> > >
> > > If the report is a duplicate of another one, reply with:
> > > #syz dup: exact-subject-of-another-report
> > >
> > > If you want to undo deduplication, reply with:
> > > #syz undup
> > >
> 

