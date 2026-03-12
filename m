Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FAC7103E2FC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 02:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 632496B0088; Wed, 11 Mar 2026 22:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D94E6B0089; Wed, 11 Mar 2026 22:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4672D6B008A; Wed, 11 Mar 2026 22:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 324956B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:01:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B4EA61A0696
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:01:28 +0000 (UTC)
X-FDA: 84535759056.05.47E7C39
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0996640011
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:01:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZOuJZRWc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Q7huPtm7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773280885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxPjIXFA7CQ1BsvjimmjcFOQ1zc7lSSboJKxDxrYtBI=;
	b=z6tvx+uQWAYnlnN8gh0SPb8qlalQoIb7StgGmRNux4FSHybRDKcEqaqKwCksdG4EGRNR+d
	IQgxBIESPdBfHDRYf5wbmwu6H5Qww3stPMFXCHu00oliC6hsuBPUFF4JfjEyVU+m0hIhXk
	qjZgNLBLRKF84Zm0DA/E48Q2aCy8oAE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773280885; a=rsa-sha256;
	cv=pass;
	b=Oi4MBVqN5U0qQZySuYCTpomcUgSxSmASR6dKD8xSbnYKQyr5APetfofsaJEVDq75JolCzw
	r53Dh+4OYaXAN6aaar9yZBf3tKRoET3CEkEw9mPJpxwfkmpzXV5jL/f02QlI1Wop3wrtQk
	8sP5hJDo5+Geobk28u2NDI2ad13i+rU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZOuJZRWc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Q7huPtm7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMNsB13508059;
	Thu, 12 Mar 2026 02:01:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UxPjIXFA7CQ1BsvjimmjcFOQ1zc7lSSboJKxDxrYtBI=; b=
	ZOuJZRWcQyEjM3etWgG3uPoFfE5pW10HHDsa6P2+8qZr/M9FxsHN3jJvPP1fWWV2
	k/uM8lQ+ileZWb+6wU1JQdnBZDazvTIEzCoJfY1iyNxZLpxCdE6g4RW5YKPJSykd
	J8RSkjH9/tXnraVF75QraDOgFq3UtoyYDB8Z1JeCZU2ODmQepabt/Jxcck5+l51S
	ubl0A0uHnDHsjZ+GeGOG772JLWjGTkFiIF/RIN0PseL6HyQ1gqq3H1KrGX1r3czH
	ZtsI002GUHLF1L6dpJ7wrkcE/vpyujkgvaefCTMYMj6Q48hRWP5evKYRH+9gAory
	rplJDev8k2Y2bX0yTYPNJQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cuh4kg52p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 02:01:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62C20C3Q022216;
	Thu, 12 Mar 2026 02:01:17 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011057.outbound.protection.outlook.com [52.101.52.57])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cuh5jn2ay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 02:01:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jYSPQOS2Aq+r4t2/MJaD7kC59PgWrxcJXDqVAE7gG6dS+wEc1yR64bPwlGAUXbzrDi0bd4mkgMJjWy82o+tLqadI68U59ibAwP6VhiVvGCIMol9PekKgTRLNdr/MqwLazlu4hCfv1W4LS3Qbg4pI4OUCIB6Fldztmjuh5TNFe9XVmWig8BScK5G1hh0ftOLyTTiHtJdkihi+rCmBV+RUd4IlMf44I3V4E/haLDhgnl0Kdkq3MPVIxqhOtYUxLlKgvtKwLPY8No2+6Y8t7JyRvS7Nn46ZO9vsDiPWSnKBHGpA7n8cNRLJmz+9DV/txBWGcIDrwKd58xu2+IxFemqT5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UxPjIXFA7CQ1BsvjimmjcFOQ1zc7lSSboJKxDxrYtBI=;
 b=dLIhKvG61w+0wwH+sCUb70IOKWz7ODqVHoEQ4HJpi6xoZqFjQeCK9LNYTm36BYtXKM8qC4wRYXXd4NsR8zQK/thITcyI17Xh3WAR5xs2Nc1oK7LBJTCwLAxeSvd1srkBfNzLmzPtV1IZNVex/dxITP1lxkbsSdXPsMRSfm6pquTjsdFp8mdmb3KuE+7M7L1aOIRcDKJKsjjTNZ9pSz/wkfhiPetvH0mPPXmsFu1Wr3oaFjQKbHkYQFWcCDoQpjdS3yjGu5syBLR673i9wOq9zRx1690fUDsreyGpHpZyeoX0bJOdYdz4zCveWXBFcDMRSZ3qyncWWgv1S4mPv4/jhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UxPjIXFA7CQ1BsvjimmjcFOQ1zc7lSSboJKxDxrYtBI=;
 b=Q7huPtm7y1zexMwQKpdU/M1iofaBeaZHOLUY6oL0+teNxpzCv2Jb3y5lQ/2eRj/xmp2LenxD9A+lu+eBcox6X9BAsHd/VF05uX+GUC68n4Odb8UchhERLsQMzrFdrngjVWOz8e2Xt0uP0WTkoEwEhQnLm3QivBUtO7UizolNHzk=
Received: from MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12)
 by MW4PR10MB6559.namprd10.prod.outlook.com (2603:10b6:303:228::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Thu, 12 Mar
 2026 02:01:13 +0000
Received: from MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230]) by MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230%6]) with mapi id 15.20.9700.010; Thu, 12 Mar 2026
 02:01:13 +0000
Message-ID: <9d90dd0b-1d60-4e45-922a-84637cab16a3@oracle.com>
Date: Wed, 11 Mar 2026 19:01:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: prevent droppable mappings from being locked
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
        vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
References: <20260310155821.17869-1-anthony.yznaga@oracle.com>
 <ba9a99a0-2ab8-4726-8287-ab21b3da8df5@kernel.org>
Content-Language: en-US
From: anthony.yznaga@oracle.com
In-Reply-To: <ba9a99a0-2ab8-4726-8287-ab21b3da8df5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0059.namprd08.prod.outlook.com
 (2603:10b6:a03:117::36) To MW6PR10MB7660.namprd10.prod.outlook.com
 (2603:10b6:303:24b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7660:EE_|MW4PR10MB6559:EE_
X-MS-Office365-Filtering-Correlation-Id: 42b70252-4b20-4ec2-8ceb-08de7fdb3d21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|7053199007|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	7ynYPfDq+4SqgOLX/tL+QReBeasIslLJh/Hoy4wbsSDcfFSrpiRCU+TjVLrm8BFVKpp8nRJchj9mHJiNfH210NqcDf5yRurbFfjCITrpAMqs0hnxEho0trwK39VUXsKO42qWCUjZ2+Alcuk3+MU9Xmoop9Z+L/UCm6zYYJrCBcb65paIz837qmQRuppcDMRj0hrQbGw3NSuxpktuRildvFdMid/a44yP40W1XbDNQ3gb8yDENYeZsrm/mnVKIdHU/pxH/7dAIitPQ3pirEHszvRw73QRgPCo9yNFg81l3vYN2B2BZNglNt7G6/2PADXW0xB7pzhuYAeDdGShY+VXF8pWvhqEqJUqiC0n9DLXM2/RNLlCY71uDEUsTcA87dP5B77ANksWeev4sW0yJkJ857eYFTteK36h6c+7SQno4CNRymWtjqpbdr7lGspYa6iTBL7vx987v3EgDUQfvWvf9HyHIx7FFnrAi9SIC+xw38ILREzCacjif7RDOQ3QFgcEmz/iQb5+TzBdZSumumOjlhdEMOIXI+57jhW9jRXjAq4dUFoiAS/1TBwFXQ3Q8pQ2+x0qX5ntZZUHdomfhHzb95wxim3cMIjBrSGRTX6AoXurvXjIwdCe7RjW4loPFxny/d0b6Z47gR1Cjuh7/Lm2fxRBhJsOYaBQnkG+imSvQfDmS3EBb0uIcfJ6O3K/k9BT/qqsEFTlKjIyeKXK8uxr9JWdWyF3EzJXyLwdK8+ERzk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(7053199007)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3pvYU5mT2UzdXI5UGFMeEFvakZxR2NVbVNMaW1WQ3l0Y3JsVWQ1clVmaFlm?=
 =?utf-8?B?c0tGNXBVUCtMenlFbzFWemp6d2hSV1ptL0NRbFFyaEVlVHN0WjhoaUZyWDdk?=
 =?utf-8?B?U3g0elJnUUM3d3V4a0U0ZW5zRDJVYW5zUDdaT0lDbXZpQm14UEVvUHY4bTZE?=
 =?utf-8?B?Rms1UHE3d1UyeHV6cHRqMlN3MHVFdlJ4d1llbnUxWmtsMFBwMXdaQ2lvNUxr?=
 =?utf-8?B?bzdNRUlURm5RZ2RreEJlUmRtcE00b09KNXJTSWMyN0lDWGgrWkNlV0c2OC9L?=
 =?utf-8?B?MGJwMTNYbmEvOHR6SzJPaFA2SEtLVEhKWWtyWnpDNDFqR1htUmN1R0pUSTVv?=
 =?utf-8?B?VSttTkIzcS9LQklpQnVXQWZFMzZncGJtSW1pUG5jZmlJdmpxd3JQWTZwdHBi?=
 =?utf-8?B?WEwwblZVNHg2c29mNm9OV3p5eGJOT0sxMHVJWkNpS3lHdytwOTBhcXgxRjhR?=
 =?utf-8?B?VEZ1cU9yNE9TNHQ0TU5JZHk2MnYvd2ZDK04xRG5laC9acWhkaVlTOVVraE5u?=
 =?utf-8?B?anJjTFB2ZTRva3FPMU1GSVJIR0x2L3YveklOTTFsbDR3VEp4a3B5b3VJaFVD?=
 =?utf-8?B?T1llb25WQzlHOHdjbzZabzVDWHNLMm51VEZHdUFSNDJ1Ti9LVklPTm9RNTN0?=
 =?utf-8?B?amIzcXFsYXFsMXp5R3NtcnkveGJkbVplSmZROVVaTkRQV0hMSXVlU0NkNnF4?=
 =?utf-8?B?bXBIM3MvcEhrRDlxSDVSOEk2NkR2aFF1MzdvcEJkWXM2U1pHRm8yYmdlUURJ?=
 =?utf-8?B?emlpb2lHeTN5U2dZNWdEMHMwNEY4NytYR0xTRlduRGVuZzBhSWtsY2Rtcmc1?=
 =?utf-8?B?V2lGU0tqQy9NK1JZNG8xN211MW1VVDVRZmNYR1BUS0hkRDM2eEdNa3ArTVE4?=
 =?utf-8?B?SU02SFd0Z1BXejB1cENVWkUzeEprRE16bHd5VmJWc2VvcStYTUJoVm5sb3Zp?=
 =?utf-8?B?R1RjN2JkSjRqZktKS0pudm1ReFBUYXZMeXkxa0NoYkVMV1hnbFpiWnJCT21U?=
 =?utf-8?B?YjRURnJiRndkSUJGZFZtc3A0cHNnNEdrUFBUWWlHbkhxcU0xNmI3bUI4MHRx?=
 =?utf-8?B?OWtXaGs2VjQwVkEzWHFxR1luMDVsNlhucnBjczcxMmdhdTlaSEFhQk03dm9n?=
 =?utf-8?B?QThhcGFnSmdGbUxSTGZ3bVROTmN1cFcwS0RoNEd1YWRpN2REcnVZcWs2em94?=
 =?utf-8?B?a3kzUnc2dzRaeHhiV1NYOWl3NEFMeEVsakRtTGhNdHlHclNjRWJ4RE03RHFw?=
 =?utf-8?B?SzVNbG5vNmxzL0tlSjhCWDRqUHNaOXI2VkhvcG5XMkpPN1JjQk9ZOGJvZGEz?=
 =?utf-8?B?R3FMZmdkUWhITjNSNzNRNHF5UVQ3VzBGbUVYZXpLUkhYU1M4c3NWa0dPR2Rm?=
 =?utf-8?B?a0E1RTE0SnU2eG5VWmpROVdIcWVQUWlHbFRBQ2pzbTdaMkY2NUZOWFVva1pv?=
 =?utf-8?B?R2RZdTRRMHdNY21ab3pxby92ZDFrdkFGd2hrejVhbXBQMFA2YlJQWGlRZDhK?=
 =?utf-8?B?azdZa0tRYWxQSnVRVVpPa1dsc1AwdzROSVZYbHlxeHcrTEZ1Q0xqQjgxbGdl?=
 =?utf-8?B?K2FYWE9YWkxFb29PaXNnMVpaK0VjYkllajVLWWVhdmZ2QWpMTmJDd05EVyta?=
 =?utf-8?B?VmVwV0h1ZE1tMmJQekpQQlZmdVNXQjM3aGhkNjNHS2Vld3VhNytmUnpKTGRG?=
 =?utf-8?B?RUZrKzIzbENZNlJDVkYxeWR2R3J6QVIxbjU4Y0QzTkErQW9vdzlpNGRMQ1E2?=
 =?utf-8?B?TnVPNjJCT1FaY2pBcHlMMFFqb2FGcHY2VEI4ek01NEZ4ZEUyck9oaXZSQ09y?=
 =?utf-8?B?UTdPSXJ2aUU4b2I1dTY1Nk1lckNabXBZd01aemtaaExhZFU4UU50MDUzTUhU?=
 =?utf-8?B?cWxrWVNSWEZUR0ZDQXYrYzBJdmVVV2tjMUR4UFFZN2cxZjQ1WGNzc2pIODJB?=
 =?utf-8?B?OHZzcUZiSXBremFsZEZucHFJRExNR0NhOXhPbXM3a1l2NWhHenI0U2hUSUFa?=
 =?utf-8?B?ak4zK2R4TzBDWE5od1ZHYVpveTRaMnR2dThXakNFNCs5bXVoaHVZeTQvcGg5?=
 =?utf-8?B?K3REdUo0djFycDYvSDRwc0lzdjArcittMVF1eDVGUmQ5dkphd1J2aGZzK0FQ?=
 =?utf-8?B?ME16OXc2Zkw4c1JMekN0UDREVTJ3SEh0b0tRRU16TEZFU2w2Q3NYU3RnTnpr?=
 =?utf-8?B?ZVRjMW9lZk9pU05DNXAwY3BCdFFvVlRnekxxcVNZSjNNT0hMK01sdlErT3p5?=
 =?utf-8?B?RlRuU2lhMHhtZVg4VDJ5WWNWZVUwTERMYk5VQzFTRTdMUWM0azVJczBOc3Ax?=
 =?utf-8?B?WU8rYU95aXFjN0pZREV1MWVUNlpSdkZxRlpYVVVheDBOLzVyNzk0WS9IWlNO?=
 =?utf-8?Q?LxoCCDmS4IC4wxO8=3D?=
X-Exchange-RoutingPolicyChecked:
	chotHWcBYcN6BaO2ZfHsudkaP9x4d9d2VqsntnUcCV762+/Auz9HK6pbveqBUFPyycGBV0a02EurxG7BIaC3Iiqjq44i47tTp/aGPKsFjJjuKyBwnXYf0cGr7fvYVyohgtTDn3eMkUUbWU5ZxTCbslCvYFM9FU7PbonGxkxFRTjIHKeLmJ4wNgq0fHacnCDYPmu1zfhnRU90FZefQS3yaM9xWx5LTOPRZ19FGkzmfkSfBb8Hvty9/YB2iS0htkJ4v7EjpRJ5Nktcl8Pr7U+oaOBWEqiEIzLNlRxvvi3f4/VUzRSoVIVS1FRIz7gDEY2cx5SdyvvA3cp+eek2lvdDCw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5V5MG0Zwid8lo/WrfNzGeHm3rKZDE+pJEPfHg9jXgvTCQ/0cbeYLs4oP3+++iHW/vsiOjUVyKSdLNTFLuQM/nQl1zkj0GP0gzVegxKSBJ+p8AGnCJDxtzoPaP5OoE3u00sYNdrno8pMOPc0BkULHYz93mARX+qtMJVJOPMpnaFJhGKS29es0tfdjtPZSvmQEAwm8i6rtTEBkVfCgvzrk/hEYQKgHqgRKLH8Q0gb7Axo1bVJjWo8mVQoua903RtzXattnn/j1KSNSvfgZAoN87a+vUDL1XpmStfzLnsJXcuJ3s/FO618Tw3aIneEpmhkTkE/C+2HRbJ+Nt5k58dpc4bBQNDw9pCs9qNMK4pd1o1WYc2zRJ11o7mBsNaXErtH4PNiNyg++S6G/41atZuCGSXQNVqoRdsbk5oLSSQaFMcVUm+WhkgFg7zN6DLoypXzQT5xiSLaG+lGXnVRVvVejjIBGYR/c1/BzRi8mDNLR+7HLSdX/szh7826NckRSTiSkjFOaOyDCi1uhp9Ffn2wGoq9wsIANzCztuoXtwYP/YB8gPHM2sNawAHrXy+cIipDLtG8PySfBCEdbLqHcEkawcE6s0S1qPkEmNjr+VRpTQ+g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42b70252-4b20-4ec2-8ceb-08de7fdb3d21
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 02:01:13.5195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: syRXjJnhJG+7RyS6bQjRb8ns5Q4wOurYxUtR0rY/GzbvpBogrH1R9C0WUHmn2lwzwdE7/PKOoAi8N9pmU4X3S311Qex5xUNiBMI0V8DWwNQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603120015
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDAxNCBTYWx0ZWRfXz7zZceTqtoQc
 ovptcU9A17kj3TNGyS60Ngc3d/ffFvGbgXni/wchPJylFCYOaFu/rLpCp1J6I6p0t1LGjNFz4wR
 x04aiHctirt8c7w4yIVjh+XdI01fQXntLiGt+ut2UI2knBlyvM4XUVx3HOG99FhTaSyEv+Ip0Zi
 rA/EY7XrrSaGV7S1jHxNkAq5tLzSddKPAW3nRAiUq+YsMasf5NHjohAat3foJeLW3FhJNWuuY5D
 itvvI8MmAB+1p8HqtjiK406PCw5x+9eW8jnJzoTBDVTDXjI2CoanNEjqvcek7AvMnMQr31JXrdv
 wETU5YOgHyJtAZs2tLNVdXUTe3ho7LQx0acQkOUXXOPhK1+KEFBK9rL3nsUcCuuxsNmpaDAGfCf
 w462BaH7y6jW+AwtqKv62h4pn2UT3LTmkdg7fY1rx4PRKn5Bd1Cpcc93TDGuap7WTks6EDoZtxK
 KdfahViVGOoBCzGGb3z8J2ASrE4JT9Vi3+Os5Q24=
X-Proofpoint-GUID: nJotyoWd4U3M1lYEwvJo1T4HxoBw7BKz
X-Proofpoint-ORIG-GUID: nJotyoWd4U3M1lYEwvJo1T4HxoBw7BKz
X-Authority-Analysis: v=2.4 cv=Ob2VzxTY c=1 sm=1 tr=0 ts=69b21e6f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=OPzyfgQavzlHH78o-fYA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12271
X-Rspam-User: 
X-Stat-Signature: q9hfbo3noimbsy8pebdx7m4nbphrwcer
X-Rspamd-Queue-Id: 0996640011
X-Rspamd-Server: rspam03
X-HE-Tag: 1773280884-606424
X-HE-Meta: U2FsdGVkX1/WWr08X3l/3XTAQtd4/9y1xFDRm8s+PNsDlyXN0gnv1WVgkzHj77AqGKAxn47JznZGmtEJT/1KcHBtexV4qR86sDFK60w5AG1qp5xWNZKCF/ObfZtkYbdxVYLYNrArWpwf1BhTSlSf4RMAtBjzwvxpAKGgY5ecHGiP94a0apMAa05G5rf5JgPAtnpY2gzbSFC2ixbuGhfkqk7FwPCH8xUgstNGgkgWGhxPZipaM9mKOBdufjWdvqTfBj07Tgk6ZhzaQQfwkGNIiR+QAFSw3ZcuHc0ZfIhcnm8pRTS7W0b4C7rrO250GFxpSDaHXfI6nOXPUB1bpetqwO6KcNBGVkNGj1dzUvRQ0/6x2uhsnAyKrTXflnh/bCtRzw+3Vkt0e/ElLl5bWk929c2P9JMwSXMnx2gtWqiSRR6NzNSaMf1C+MFbSx3BNXoyNjUqq5XbfPeJLfQP+P7BoFLHQzvc0vv1EX6EtIssisws9iH8u0D6H5WMGanTrMRmqGbuUzzQ0M5rrI/5p1R8xKzD8UXnAUxqalQzdbYZ+mySWf4D5u2Pj0LSFPSje1WIA916wpTAQn+MjhrqmZLUN2cem/NAiZv0/tEv6r0mZXIG/xln1odDvpX77OpVQWrHabVdQoXtg71WYWX4xybE3D6z7hSRyCyieAaEVGA73Ba6n7B7weRa83cJsX5f7Hc8qSTZ+BVasIdJMLGlFa0fk8E/+wTekL++2xs8xFFNqkZWsvJKzc1VXJg+nSL2sT6NSidYt6D2iyT0tNqzfFc9PNDwljnd3CRHMFpM0LXlUTo0kDmg5dqYMCOcJeB+Yb2nGI9MC322Q/Ujy2WbcLrxOpoTYttfNv0TKGKYKKoZjGNyoEGDip0xy//LnnKLqtUtD3Or12pNhpijiun01bhL/+apAgXLHOA+h0rRcc7PZQzbX4oc5/yiylwzdhN9sqXtoS4pP8rfLAmgdBG5WF6
 Q+E9qOUC
 4uQErzglrfPFVO1FFp+8i1CRMfXJEi1bgs4zQPSv39jcIyRXCJBVLKZVOD/jHIelI16Z6yYdp+/v8wRDpUrhk6iWTTpKeHgdPKa8JHyseYYh+kXi95EmSWyT1gwaqdcyxjf7DLLtlqTFeAAlokNrnVb+7+90Sjzf9YiF+KAsKsLNCuy0hIJmeYCR/4IBXbOQ90m8J4pOGrO4M3PV2R4jC7cSvj0ay7y7aI27IGIg1l6wDfarBNbJ4HVpkQu7RuWsliUberCSUbaZvl5HhiBx0a2XyezlONjkN/p778DGftrXt16lxuvVi8IwhFiUpguzhgSQf2KYt/qtwU5AXl75tv2urDqwaL8Kgfsk0Leg172D49PjvWgQ3L4az/d5woJ6uu71TJh1+10CDCzfgxulFOJO9jk+gXiYzqzjkIr6TUFZ/UdtFHncX1PCgSfrNBGwJwhDTZPdvDpZFy61r2fQCcwywgByz14onFM3WUDpa+hUCx6h9CedCfSWDDz+OqwB8jzEDkyfAaH5CvP7VwpPLRyGPvydNFAbGcp4ujae6ut9G8yRkSupTNx1GFa42iXsvRHhImUxYgUQ+BIYVpunIiokFpTX5WTMlr9nmVEqgH0hhq45iFag46mlYSq3abbeOKvzb6CrIySPw1oRzaEl1o+6ohb1yLvyWg/60A3lvtvusRUvBhOfSr2gCHP8i/AiVb/hKbE9FDxS+hTXmtc6K+bHW2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/11/26 2:27 AM, David Hildenbrand (Arm) wrote:
> On 3/10/26 16:58, Anthony Yznaga wrote:
>> Droppable mappings must not be lockable. There is a check for VMAs with
>> VM_DROPPABLE set in mlock_fixup() along with checks for other types of
>> unlockable VMAs which ensures this when calling mlock()/mlock2().
>>
>> For mlockall(MCL_FUTURE), the check for unlockable VMAs is different.
>> In apply_mlockall_flags(), if the flags parameter has MCL_FUTURE set, the
>> current task's mm's default VMA flag field mm->def_flags has VM_LOCKED
>> applied to it. VM_LOCKONFAULT is also applied if MCL_ONFAULT is also set.
>> When these flags are set as default in this manner they are cleared in
>> __mmap_complete() for new mappings that do not support mlock. A check for
>> VM_DROPPABLE in __mmap_complete() is missing resulting in droppable
>> mappings created with VM_LOCKED set. To fix this and reduce that chance of
>> similar bugs in the future, introduce and use vma_supports_mlock().
>>
>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> Should we Cc: stable? I think we should, to fix mlockall(MCL_FUTURE)
> behavior.

I found this issue through code inspection while doing mshare dev work. 
I don't have a strong idea how likely it is to happen in practice. If it 
did it might not be easily diagnosed so I'm fine adding the tag.


>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
>> ---
>> v2:
>>   - Implement vma_supports_mlock() instead of vma flags mask (DavidH)
>>   - Add selftests (Lorenzo)
>>
>>   include/linux/hugetlb_inline.h    |  2 +-
>>   mm/internal.h                     | 10 ++++++++++
>>   mm/mlock.c                        | 10 ++++++----
>>   mm/vma.c                          |  4 +---
>>   tools/testing/vma/include/stubs.h |  5 +++++
>>   5 files changed, 23 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
>> index 593f5d4e108b..755281fab23d 100644
>> --- a/include/linux/hugetlb_inline.h
>> +++ b/include/linux/hugetlb_inline.h
>> @@ -30,7 +30,7 @@ static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
>>   
>>   #endif
>>   
>> -static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
>> +static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
>>   {
>>   	return is_vm_hugetlb_flags(vma->vm_flags);
>>   }
>> diff --git a/mm/internal.h b/mm/internal.h
>> index cb0af847d7d9..8c67637abcdd 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1218,6 +1218,16 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
>>   	}
>>   	return fpin;
>>   }
>> +
>> +static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
>> +{
>> +	if (vma->vm_flags & (VM_SPECIAL | VM_DROPPABLE))
>> +		return false;
>> +	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
>> +		return false;
>> +	return vma != get_gate_vma(current->mm);
> As discussed, it would be great to find out whether checking
> get_gate_vma() makes any sense here. Likely not. :)

I do think the get_gate_vma() check can go away, but I figured that was 
better done in a separate patch. Is that better done as a separate 
submission or should I tack on patches to this series?


> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>

