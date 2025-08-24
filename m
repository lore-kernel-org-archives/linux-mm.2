Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD209CA0EFC
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 05:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885626B0006; Sun, 24 Aug 2025 01:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835A96B00A5; Sun, 24 Aug 2025 01:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D68F6B00A6; Sun, 24 Aug 2025 01:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59B676B0006
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 01:31:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACDCDBB6E1
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 05:31:32 +0000 (UTC)
X-FDA: 83810528424.04.04C1975
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2382C20004
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 05:31:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BD61lRdr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YnzW8t74;
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756013489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GvdOdlcMdtnw/NjhLaJuRLGOXKyB4p6rLw8Fc13nOo=;
	b=gMoFKrag5K8kqlCjl8eXxHQc53jDvdf8CPkjaqW+1gkrpVPTjUhnETwJmyZ8hE4fmCyecu
	adwQ1KTy+LokkCJU2ITXqrqSiwhO7xm/A+7WKXGsJtYyFXVAuhMe9JhYBhPF61J707Hz+Q
	KV/oUeRcpDvdphD8VvSpBnWV+GrQfR0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756013489; a=rsa-sha256;
	cv=pass;
	b=rgBuFWhxox9EYtTtMwCGKkmqfcTNeVlT2OMNDVMPwwWsguDF/j5xB4OxobyefcRGdP+DFm
	SJZT22fPREvNDa1m017VteXGZBvhG7FRrRzGzbCmeJSqCJUKwhSp9aCi9NCG/MYz66xyVF
	0vSj5MAaIMMibwlJPWEtA9oWmVgPspM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BD61lRdr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YnzW8t74;
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57O5KGgg030437;
	Sun, 24 Aug 2025 05:31:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0GvdOdlcMdtnw/NjhLaJuRLGOXKyB4p6rLw8Fc13nOo=; b=
	BD61lRdrsN+AociM6AX4tT+1WdAMuZBT0PRfFxRZ51EO0jt2MNXh0CzqlFFIewHI
	fzgZH+xSqhsNkJM88AarOvzWRYPKO1wUNG2VU++k1YD+CYPRqhiiy8O6SFXlSS8I
	RJNItprh6mU7GE7jjlqFfR3/8nLMVHnI8j4gdNxE+p0QVME3as7KwRk0/mX1WOxJ
	9Qo0sNSnpQNBjB2Uocz+0mFDHDAxWzvVMQ2HDJjm1sKiTWd4jTF/EpU9zSIJMxzh
	FFKOUK1SEOpA/WNjMQZ1L8LfMCfYvg150Za86ZJkl8S3bhGQ1CW1x5bhj2GEp/IR
	WXxjEyJEJ6YVbHVX+fkdSw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q678rpj9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 24 Aug 2025 05:31:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57O3RgEn014567;
	Sun, 24 Aug 2025 05:31:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q4371n1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 24 Aug 2025 05:31:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yaff9qj4lHi+MvsMJAS3JSMzJMr6E+LHmEHliUKVr4U9oLXTQPoG67+HscDl7b65v3CIyQ0duSfEpkZBVRhg/VJFDxZXQ5jVpHWIr5lwcLc98dm34z/Ehu4lXREJhkOHcxDr1ZH/gVWlZuHFRL2QnMrRgLcdlvwq7wA57nsP2gWknPaFHKqRnxJZcpjM96Zd98gK7dmStiYQAKxemDVsbtiyDCD2GSzA6FXZ7XyebNn0JH+lmsL9X3FGKCQK71+dqf3bCbxjTYwbcdVvn1fzNuw9dFsksLxfPCcnckz2heyZHrR3v8k/HghFcCJbFtKx4zcYugTZrQlVQsqZ/arCMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0GvdOdlcMdtnw/NjhLaJuRLGOXKyB4p6rLw8Fc13nOo=;
 b=OYdoFCKAZTa+HOE4kNPWg+YvWJj+rRLiYUUbt3eLKUApXcEP4Y2ERIA0JgzuW5+nQ07Y5oeTHPrEQMt6IwH428HLxBI/tgKstH+RWEwVTCSfPrwf30gX9pU5mL5/hmsP0rMUZKcDrILJBz3sU4ytBWhGrnNsvofRNHIrEmusTK72/qi1OS6N1oVCPVH37yNJbW84sprNMsgl9yHZvBqVVZvMfjzoVh9OLUhBSHmzOEgF6B2ac4k3jw85GWnsDur5IPdQaaLSyU4YhUZ0D9bBBBK6tok4tFxx7xGTcV9vQw8lecDd9kyrfxyyUPdqEAp4oaTVE63/PojMlHy8Big33Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GvdOdlcMdtnw/NjhLaJuRLGOXKyB4p6rLw8Fc13nOo=;
 b=YnzW8t74k2M+yt8vuiUUiJYxvDsqyaeCR1RWFsipyYI1YSAaS2B5i/QgP3y/anQzammTJz+Bgk44D/+HPDHbIXvt94jcJeeZtOB1bKrhF6GXlD/tJcnPDE8a6sT8TFo3NFDd4TFRqp25Eri8KJ3Fg5TMp9OHwjkbpy4fBKaKP9w=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB6785.namprd10.prod.outlook.com (2603:10b6:610:141::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Sun, 24 Aug
 2025 05:31:20 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9052.019; Sun, 24 Aug 2025
 05:31:20 +0000
Date: Sun, 24 Aug 2025 14:31:10 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
        Barry Song <21cnbao@gmail.com>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        android-mm <android-mm@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
Message-ID: <aKqjWqn8lrITKI7P@hyeyoo>
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <CA+EESO7j4dY3KjBWybTG6uQmXJ8kyhBrid3rTk5XAP7poZOhYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EESO7j4dY3KjBWybTG6uQmXJ8kyhBrid3rTk5XAP7poZOhYQ@mail.gmail.com>
X-ClientProxiedBy: SE2P216CA0140.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c8::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB6785:EE_
X-MS-Office365-Filtering-Correlation-Id: bcf9b4ad-d894-47b6-df73-08dde2cf746f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RWMrRk14SHkxZC9Xb3lQQ0hVV0VLWFNzM0pIU01HTFFjbm5WdDllc0hJVkhE?=
 =?utf-8?B?NG9wYlZFbk56a2RXZ0JpaG16NUIwRFVjWDJ6a2NZbXhMTStWbWxLQUhCdTcw?=
 =?utf-8?B?TXc1RTZ4OHVCUXlCOVRMU3VXZk9QdTB4ZzVxVFEwK2hkb203bDJoMjVDRlJl?=
 =?utf-8?B?SHlrakNRVWFHcXM0K3hONExLaURGY0V6UWVwRDFiMEpXQ3dVKzMzcjZ2QWdW?=
 =?utf-8?B?L2Fmdk1FSi80Y2Q5QkpUS0Z4Nm5EeFJtSG8rT1NwT3ZxTm1kaVJqR0d1TThS?=
 =?utf-8?B?b3J3dkI4TVc4THlMbmJMd0ZKSFpPQVcySlhWeFJMTXhJOVRQWGcyTWhRMnFQ?=
 =?utf-8?B?bUlpY2tXLzF4bmFiNGVnYWxkV3pvTnVwSDZVd0NGcjZXcitGcEM0bTFidUo1?=
 =?utf-8?B?SWxYUHBkL25ob0VqN3hzWVlhSlN1TFFoZWtIVEl1OFdkTWhqUFpZQ1hVT1lC?=
 =?utf-8?B?VkpsTUYzMHJOclR5bW4wVVVIaFBmSGZUaElLVS94N3NhTFkrUHBuQjhzcnQx?=
 =?utf-8?B?bVh4RkFBNlFMbyswRklleHlzdG8vVkNacDJYaHJjaERLbGxJMzA2aVZweUhq?=
 =?utf-8?B?WFlCNEJuaVFDK2hDVmlybC8wNWxLekRuZUM3dXo3ZUs4MjA3dlBwbzNIS24y?=
 =?utf-8?B?Y2NmZXIwd2p2aEFaNFFWdXZXMDNwcTByRm5MRkdJaUdVaWdWMU9KNmY1OGdJ?=
 =?utf-8?B?enZmcWdLQjFoYWZtUlMrNzZ3T2V0aUEwMk9sTFIyT1pBMGkzMXlVdkxtaWU4?=
 =?utf-8?B?TWVuWjMyNzY0RlBYZG5BSDRGZWxBMHJCVTFUSG5tbHZ3RFBuYU81VEg2cTV6?=
 =?utf-8?B?OVJndmhzdUtBUkR2N2dYRk9QRVZzTkdRZGh6MGhLSkRyTmZ0ODVoS0xjemlq?=
 =?utf-8?B?TkpmbkIxdmt6eHdnUzR0bEpDN28yR1BnOGxXZ3dpWHgxeElTeUtWaURuVHFI?=
 =?utf-8?B?K3FnQ2pnSFh5cjc3aER5L3daZ2k2dURacVFQNjFkQUJZUmxIaXRKempwU2RW?=
 =?utf-8?B?NER1YjR3Q1hGdWF1WmwxRFNNYnZOMDhEemlsbXlObFlaNnJZMTYzUDdnQjNn?=
 =?utf-8?B?Z1drL2V0SDlBeEd1cE15NlZ5Wi80RUV2WHdsMDFKck8ydWF0aXRmS3ZzMEo2?=
 =?utf-8?B?UXlxUWNJUzZHWUl6RlBlU3RkcFNlcFdBOEFDUzVuU0c2T3c4cUJqbHhBS2k4?=
 =?utf-8?B?UXN4bWVZZ2JVWklvWG9acjVOWGFSYjVLWFF3dENOc0JOMHBMa2VRWmZKZlk2?=
 =?utf-8?B?c1pYY0o4TlFNQU1tNHBIZFBPeEpDb2h5TEtaL1E5cTRjNVB3Y2MrYjErejVD?=
 =?utf-8?B?T0h4N1ZtTi8zbG1valFOaThDZDVybmVpQks4UUF2ODZjQ2U5TS9UWlY4Q1ZG?=
 =?utf-8?B?UDgzc2twMTFDRkh6R3dGOXYxbUNPQjlvSmNFbTVYMWVNVS9NeS9xd1JBUW5n?=
 =?utf-8?B?WDFHUmhVbEVTQ1l3V2hBbG5rWVlEWm1iZGVvcVZRblJpUEZOcWJqbUNtcjhK?=
 =?utf-8?B?bXQvWFFsdHpTbVdmNEp0RG0xN0JpTFRHQmdzbVVTa2NUTko1ajVHNnNRNWhU?=
 =?utf-8?B?MElTWDRYRFdLUEtteFlDK3liWGdCMWdDTno2RG5venpmWWtQb3hCNFZoUVhI?=
 =?utf-8?B?NmRsMy9vbi9adEdQWkNkRmVmVlZ2aktxZ0JjOVZxaEtyV1lhY1AzQ3ZlVUhr?=
 =?utf-8?B?S0ZOQUwzYkRzL3lGT3FoMFNzYUlPd00xWmNhNW1nSnFXSHNNdTNGV3BkTzUw?=
 =?utf-8?B?L0hEMjI5UnZGR1VhVEhFK1Y3b2l1R0tER2hwbDJrYU9BempHbVVtQkdlWko3?=
 =?utf-8?B?VExQRmdnWWx2WkFMZGxENGlhVEFDN2lucmdXa2hnUzNIbXJJbXk2c0NmK2Fv?=
 =?utf-8?B?MTJqV2Q5UWFpRmhjR25KRTVMYjY0dkxscE52dnZ2VHVUdU4vSk5Uc0dRMFdV?=
 =?utf-8?Q?xhiKM9D7wss=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmprRHFZdzM2dFd1SHNSWVlxNFZ0ZGxyNjRpbkU3NGpoNWJGbU4vb01WaXJR?=
 =?utf-8?B?MXFNVm9EcWUxSDZQQ00rZ3BzQlQzblNyMXdQWGlrQ01MT25PTEZCODBkajh3?=
 =?utf-8?B?dFo1OFdmN2V5NyszSkFwTmhMd2Z4Y1hDamlZMkx4UHI5THhqalRlMWgwWTVj?=
 =?utf-8?B?UFpnSWgyaW44OFppU21JbVloOElSWDl5cWJOVlhEc0xFckw4c1I3MXQyTmJM?=
 =?utf-8?B?bTg1cm9XU0ZKdU0xem8xKzJyOXNtUFJlbHZoRE9TZGYrdzJwb1U2MnJnRzNI?=
 =?utf-8?B?Y0ZsbmI3WEhPSTRTcHQ0R3JoUy84anRtVXpSNThsV2RIdk9qZWQ0ZHNEWjVt?=
 =?utf-8?B?eGpyQSs4ZHRueWJmcXlNQ05jMXJDYXB6Q2ZZUmNTOURlb3U5dHpKZXZrQlRr?=
 =?utf-8?B?UC9IcC9aN3UzMWhoOTlFR3lNQ25UeVF5cWd2VkoyOFJSZWdzQkZ5czlVRExQ?=
 =?utf-8?B?UzBKb3FyWDhJeEZrVkgwQ2VXVjd0SnlUZkRxU1FlQmRzVUNmNGdvRHRPSlZS?=
 =?utf-8?B?b3pNOEY1SVhuS0NvV0d5am82Kzc3VmFBSHl5b2dFQWdTZlY1NVV1Tm05YmpD?=
 =?utf-8?B?SDExeHdBNklZNWFVQmFUL21UUCttVDJaekdQMGJDUFRSaGpwOXBjcXc0SkpM?=
 =?utf-8?B?ZXgySzNmRzE1eXgyNDE4V080d25XVzdXRTZLMXFmUnNNdGlleFpqVUptaklm?=
 =?utf-8?B?WXUyc1hDcjNuZGx1RmttODZMUkRkZkhnOGd4U21iemlRbFZQL09JSGVQb3oy?=
 =?utf-8?B?UzAvdnBLdlFxUUVkMUN2UTV0VWpncjY0TldPcmpjNXZoU3JZWjc5WjlpTlpK?=
 =?utf-8?B?aDR0NDJqRjFmaVhJY0JkbDF0ZmdkYk16azZ2cTNqdGhZYVBYc3dsMENSUnNN?=
 =?utf-8?B?eXdrelFmSzJYUHdTOWVzU21TaFNwSElJVXZoRjR2TlJoVE1qdG0xTDg4R0U2?=
 =?utf-8?B?NWVqNk9BMGJYR0RaZjgyVENCWWtJSU94amNMR2lrdjRyN2RhNkY2LzlvYjdH?=
 =?utf-8?B?bGZHWm5BemVVSDZiTml3L09yRG9rNnRjRmxyS2tLZFdEeVh6a0x1L0RDbmIz?=
 =?utf-8?B?VjFyYkUyS01aanpqQmRUMVRibzRDaHhqN0hEUTRqaDlFRExFZ1MrUkhPRmxu?=
 =?utf-8?B?KzJyWkpkckJvOUU0aXlGeTlHNFZMTUpvaVBGeVdsNWl6N1owUVhRMmFzL2VM?=
 =?utf-8?B?L2hSYk0vQjRNM0FoTlEwbnEwc2hNcnBxdEFVN3FTOXcyQmlsL01LU2hIeDhs?=
 =?utf-8?B?UVdLNU5XeGt6MDJ4QkVBNFdNemxNc1hJbHdRWU1qMnAvZXQ5Uk0ydHNzNEVa?=
 =?utf-8?B?ZmZ6VlIxb1A4VkxKZ2FCK3ZiUXVPenp6QWdoMzJKbUlLOXRNOWd6U0ROejF4?=
 =?utf-8?B?TFIrbWc1dkF2T0lnMkd5UkI5aE1CTW5DOSt6QklKdHFRZEgrYmZSbEZGOUpr?=
 =?utf-8?B?akRjdVJDeXVFZEYyS0FMQlZNR0hhem5aSTlETXdvcnJ4VThpQXVFaWtWbHE5?=
 =?utf-8?B?bEpiYzRvTFlvSjFldysvMnJRaEQ1Q1pKKzg4SnI1VUNDTkN4R1F5TUZmbFox?=
 =?utf-8?B?QjJGVm5TQ2xLc1lldm0yRERrWGlHNkttOHlUQjdnUE4yZ2NwN1h3NjROaVBW?=
 =?utf-8?B?TzNoZUJjWldHUEtOYzkxaFJ1TnlxN3JXSzlyZkMwa1V1Mll0WWVsK3FxUEdM?=
 =?utf-8?B?RzhpemhXNHIzaFJZbk9mTHUxS2k3WjdxcmhsdFVleGJVM2N4Rjk0QUNreGpx?=
 =?utf-8?B?QUJ6MXJ0QncrK0tmcmZYRjF2cFp5UzVUREhuejNqaWtBOGhnMkdOaVpVZi8z?=
 =?utf-8?B?WHBBaUJwNlFjRHVESG1NdTRCTDRQQzZrSDJFS0hDZFoyWXhTUlVyYWZmZnI2?=
 =?utf-8?B?NmszQUxSS3J6V2YrWkFNOWh1cWRRYkQ2eWlpT0w0RDNvVE9SbVdSU3E5Vy8r?=
 =?utf-8?B?ejRLdHphUVk2TmZhaEJWOWlBRVR2NVBYb2Z3OWNIaGFVYVNNd1p0L0xTR0tx?=
 =?utf-8?B?eXlNTjB3QWd3MWhNeE9ETjY0bWtIdFFxWGFTclR2U2tXYUpIRXVNd1BEdHlr?=
 =?utf-8?B?SEQzazNmcjNTQzg5U05oTzFodXlLcTJmakF4THZVTUxFa0VtT2N2WXAwcjIy?=
 =?utf-8?Q?T4GPWeYChsVxfkd/yTg08kCbR?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ohflMwC2hM3SwyV1lAktB/DfYkpZ0NEif8MZiqbC/AIUB7RUj5nfDRgV/EImawoNzi2z+9b5LMxyAyNr4f7bkBVjhEppNBI53v2pmJ6rDB2CIMOacU8EXFiirQRdnFwl0Ec9ZFI2uuLwsG+qHwU9pIRuk8qxYU/j1VgZSSjZZ75iLPLwJzTaU3bh6nJrobTMY3+qcGhqDch35VIpbz1CRN4Dk6yrU6h+WCLECqn3tH/UXTV/HNbWhOxQhkbOwl9W7c9wWncXqSYMit3jVLyiEpO99q0cD7MtSN+ibMM67N1mARzRKHsAxyWT3L7+URoeFF6G/gY8FE0rr4+ywb39aDB0L5aIV+1BPJiMZnon5sCulDNpI7hLNPRTZayjG5A2HN3qDycDNbbFqZFWIdQTI947DyZdsjNu3cRfgW+/Y0o0Gm57sIc14VsHlQ83aVPtToSnv97gDmJ4DuEzqBhWpeAnvD5ToMPbzZb2JbfUhp0QRMip2hUkH3IZ5aB35HpbAoNDPheIErG/sis86511CTqtTCpZjjXueHFME1vrUT5LOizBZYtmPn2YCprJ1vU6PGTqg8PGu5cK9aS/5plVWK2aTINYqsP0xiMiAfL3Tr0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcf9b4ad-d894-47b6-df73-08dde2cf746f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2025 05:31:20.1411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCQJnUVxYe6lf9aS/ufU3xk1BfPvFPtyRGDZYXy20PBvmeYFohr2uLNnx8lu25uqCvt4Nshdq2gUKM/nM1e2qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6785
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-24_01,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508240050
X-Proofpoint-GUID: EpKS90Ufu8uLMxt2zx1zYal6TEUd2sfo
X-Proofpoint-ORIG-GUID: EpKS90Ufu8uLMxt2zx1zYal6TEUd2sfo
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68aaa3ad b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=1XWaLZrsAAAA:8 a=Laui4gjxkI-neqVSmyAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13600
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfX1EiAxV2MZ0vJ
 4DajefcJoSHv8Z76X+xkUVupBwJ0vb4cLiTEY7ZU+Ov7pxuYIqFPlVu8l5XdKuRZC3XVh9GcLWI
 ikhpRtwKVYMhreJJTAlWfkhir/6dxHy6kfivB6m3SKa930MV2q9KGFgbo8eErVMu4S0UwWn4uIF
 qSjlo6F6/zFwlzNZ66OxycPWRz94iPsK8EyJfynkmyYFOhZc6IUfe9AHqDl0tE2TWs+3KdIA9iO
 GNoIROhp6SIXdf2pdimjQCCwEnq1RsR2uSEGIhKHUsBDeZpU2JDdLo1peU5I+Xlynsj/R31ISP/
 DNmri3+vJEFYWdRcuRuddn0yQ/pl+hBHw2KO/lVUBW9nO2gRDVU0/9s8ovatzgbQgOLLW+m6KBV
 jPFUooKOLgLrxLR0h0QvEoYJvqYMDg==
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2382C20004
X-Stat-Signature: x44dng47bxomdum157byotqqqpx4jbgg
X-HE-Tag: 1756013488-819013
X-HE-Meta: U2FsdGVkX19Pqsnxbl1MX9Z6mAp8uNCK0RFjfJGo/VtHRMwnmDzZiRwWYXKnPFqZ6k97xUf5/5AOCLkV3exB6FxitnNhZar29Wilr7pF4OgNuJrsKwXs+DUrsON+bgwaqVyLtVvDmU94WNg6J+cSBWBf3afSrV3lzHHNj+ryTzvlyJFgmaLyMYKVbcLNgDMqMTHFkhLG+303GVzDBjHyuBp8aCNG6OBJghIu515V4FL9C03wOnAsXf55C5AXeRTzNlabsTgrqzexFrJE/c6Yl4OeZHaRKCrSksr0SW9qE3oXyWGRHhMwVAWJIeoVkphQXksRSCl9qSLjVFlv6SyJgrJxpUCraWo6VziXqY2ahP5QZ00P9wLsLm/rjzc1iHFlq6iX8wP9SLzW9FT2t/IQjYm4T+e+ES6/PdrD25W7H8V9eB9L+cS8AACApGubFE+qzreQgNvo+VHNYjg3Ij+K4GuZk2y4gc7t4DdZQMb5seXJCNzmVjDQmGewCZmubwQvjp8od8rFiH8bszmcrqN6fzerKvrQLBhVaYbhULdUcx2UOLXxGNlC4K+A44Pq7aoZOtTZ0JUZLoad21E6xdclNJk2gsgJdc4Jbe1/eyFG2S39yqFfe/MUkMG5P6V6yYF4k4HedLAZcfB9Nibu/ywdgcOpxAmEi+rRGld1HzcsYleRID+ol1jJiXubLDrfIaxMRGageRNwV7o4QK84LwV+1bV/kDea43jXXJwOiBQYB72rmX5jIIL1VuQ+qB2anbRorhuwoCxa2lz8uIS3+8KC+TDrWikODAUirc3PoW3iWgGG8DJcywvcjTGKSZ+btmQHNzxy+OokAFM44qTZjYX/kW0ITSplwD3+atGCXv0djMudvt34clxYyadJEPVZJplx9vV4Ps2bPzUXojGiZilPmX/+12WOVKcVHGo8caAoq6InzDr4Lju+szBZCyk3c23J3ViRhh69uocsp7saC77
 hKy3bRiA
 49m0G7+ELqfeYzdu/5yrj7f66X5QDmlLqUGwytmH/si5W0H6CH8sAa6B7HcrYsrElCb9ytDkME8uIR8622dM6T73wNOmufrlhABf/c6Qh+DLHpRpmWBQ/OgLRU1FB3LIxA7Uu7YShmRs2ympggoH49P+CIkeTi7Rkw/eMpvxZL9RXF8prx5ZSLAgZUwDTaZtFyQ8anWA/aC9EE9qItqOgC7C9AucJp0i7zWASUhQtJYmzof2rV/uZrOBVCbKJkRXHnRxeMlCYoM5D3y/HHlhOBWfwLnz/Hg43Iff41qQOZJ+Dep8F6q+m3nIswF7zc7r4uVYMzbYT+eeLr/ga2osKnBdAh56F4JIDxdbO7noynY9v25QFwOdTqoYvf1f74Ezn7FsF3KR8ZtEimUoLW1ktLe41T3ntmxc/tTT/XU6pvySB7/YiJz/0KiE+IjFYSu6LPZZT7j0kKXqOO8KAiWhhHYPb/C298OlYRCi0a5Py0umLnv+kKuL9Wxzz/x1aucWU5UKAg+3zVvv7MYI4EqmsIVP2Q8t5acEmBipMZ08WSyja2nuU8/VB2XUkf/Uo2/CE5jrF+3e69SVn2yxSTka9UrM+okHW7Oq0NDHCr/GV6INmUZ7Ngjk2Lbi279ssN20HYM6oRjpEOYjE2PWoFCzO4ZTl8idpuZdSg68qaXV5KUhqe7Qx/g932/07JC7IRUaVhgxW4w3gjjR/j5xuvE3VqP3I9KJpRMHAsTGvPBOlG4q4BJSNTt2Qiu+nmPFF4vuZK4x/wnDMZlivl7FGj25Ex8+RhMeOICy433Di7oWgEqoifhc3TEjYg8jaiVaDeq0dWiIQHIi/HccHd6jm1jlHPt+STgp1NYCGbbcHwqRgTZHzo27S/bOk6FO4CiPN9kKZsiUKrnlT6MAS+2I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 23, 2025 at 09:18:11PM -0700, Lokesh Gidra wrote:
> On Fri, Aug 22, 2025 at 10:29 AM Lokesh Gidra <lokeshgidra@google.com> wrote:
> >
> > Hi all,
> >
> > Currently, some callers of rmap_walk() conditionally avoid try-locking
> > non-ksm anon folios. This necessitates serialization through anon_vma
> > write-lock elsewhere when folio->mapping and/or folio->index (fields
> > involved in rmap_walk()) are to be updated. This hurts scalability due
> > to coarse granularity of the lock. For instance, when multiple threads
> > invoke userfaultfd’s MOVE ioctl simultaneously to move distinct pages
> > from the same src VMA, they all contend for the corresponding
> > anon_vma’s lock. Field traces for arm64 android devices reveal over
> > 30ms of uninterruptible sleep in the main UI thread, leading to janky
> > user interactions.
> >
> > Among all rmap_walk() callers that don’t lock anon folios,
> > folio_referenced() is the most critical (others are
> > page_idle_clear_pte_refs(), damon_folio_young(), and
> > damon_folio_mkold()). The relevant code in folio_referenced() is:
> >
> > if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> >         we_locked = folio_trylock(folio);
> >         if (!we_locked)
> >                 return 1;
> > }
> >
> > It’s unclear why locking anon_vma exclusively (when updating
> > folio->mapping, like in uffd MOVE) is beneficial over walking rmap
> > with folio locked. It’s in the reclaim path, so should not be a
> > critical path that necessitates some special treatment, unless I’m
> > missing something.
> >
> > Therefore, I propose simplifying the locking mechanism by ensuring the
> > folio is locked before calling rmap_walk(). This helps avoid locking
> > anon_vma when updating folio->mapping, which, for instance, will help
> > eliminate the uninterruptible sleep observed in the field traces
> > mentioned earlier. Furthermore, it enables us to simplify the code in
> > folio_lock_anon_vma_read() by removing the re-check to ensure that the
> > field hasn’t changed under us.
> Hi Harry,
>
> Your comment [1] in the other thread was quite useful and also needed
> to be responded to. So bringing it here for continuing discussion.

Hi Lokesh,

Here I'm quoting my previous comment for discussion. I should have done it
earlier but you know, it was Friday night in Korea :)

My previous comment was:
  Simply acquiring the folio lock instead of anon_vma lock isn't enough
  1) because the kernel can't stablize anon_vma without anon_vma lock
  (an anon_vma cannot be freed while someone's holding anon_vma lock,
  see anon_vma_free()).

  2) without anon_vma lock the kernel can't reliably unmap folios because
  they can be mapped to other processes (by fork()) while the kernel is
  iterating list of VMAs that can possibly map the folio. fork() doens't
  and shouldn't acquire folio lock.

  3) Holding anon_vma lock also prevents anon_vma_chains from
     being freed while holding the lock.

  [Are there more things to worry about that I missed?
   Please add them if so]

  Any idea to relax locking requirements while addressing these
  requirements?

  If some users don't care about missing some PTE A bits due to race
  against fork() (perhaps folio_referenced()?), a crazy idea might be to
  RCU-protect anon_vma_chains (but then we need to check if the VMA is
  still alive) and use refcount to stablize anon_vmas?

> It seems from your comment that you misunderstood my proposal. I am
> not suggesting replacing anon_vma lock with folio lock during rmap
> walk. Clearly, it is essential for all the reasons that you
> enumerated. My proposal is to lock anon folios during rmap_walk(),
> like file and KSM folios.

Still not sure if I follow your proposal. Let's clarify a little bit.

As anon_vma lock is reader-writer semaphore, maybe you're saying
1) readers should acquire both folio lock and anon_vma lock, and

> This helps in improving scalability (and also simplifying code in
> folio_lock_anon_vma_read()) as then we can serialize on folio lock
> instead of anon_vma lock when moving the folio to a different root
> anon_vma in folio_move_anon_rmap() [2].

2) some of existing writers (e.g., move_pages_pte() in mm/userfaultfd.c)
   simply update folio->index and folio->mapping, and they should be able
   to run in parallel if they're not updating the same folio,
   by taking folio lock and avoiding anon_vma lock?

I see a comment in move_pages_pte():
/*
 * folio_referenced walks the anon_vma chain
 * without the folio lock. Serialize against it with
 * the anon_vma lock, the folio lock is not enough.
 */

> [1] https://lore.kernel.org/all/aKhIL3OguViS9myH@hyeyoo
> [2] https://lore.kernel.org/all/e5d41fbe-a91b-9491-7b93-733f67e75a54@redhat.com
> > > > Thanks,
> > Lokesh

-- 
Cheers,
Harry / Hyeonggon

