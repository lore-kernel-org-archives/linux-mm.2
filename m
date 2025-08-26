Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8D79CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 08:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252496B017B; Tue, 26 Aug 2025 04:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229C96B017C; Tue, 26 Aug 2025 04:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CAE06B017D; Tue, 26 Aug 2025 04:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E61216B017B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:33:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68735847F3
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:33:58 +0000 (UTC)
X-FDA: 83818245756.23.0E922F5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id E9EEA100007
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:33:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iE1voyF+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=prqCwyjy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756197235; a=rsa-sha256;
	cv=pass;
	b=KualFDjDUhiPQkyxyil9sSjwPSjwBg+dGVnwo2vESNVrxtSXILpYpxA5yRrtIPiXL4isnd
	GwdOK1w/l6zeVGcfTHvzXx+D4fa+mqyqR7TSeHVYf8kFb9J1DwvfrOR/TAFTyYcwkV9GmS
	7wr9aMLmN+nhG9o/NelnFP53tLLuJUU=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iE1voyF+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=prqCwyjy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756197235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mziY/eKfFcEFyoZ+H72DAE/Jj+OkVK/Qmf+ajVhvbqA=;
	b=mTnnl3EXlrj4kTQSeadkKt8uef/XX0+7+Bo1XicO4mh1xKXCLs5x4phDjRJBW5jr/750hR
	Y+fYI2bLFYgYPX4HiMk9TGPQK1h71TZmQNE8dREuT2LdbcHEgarFtSWsaUcLDkDMYq6d7o
	sTZovJB5hxx/1G+sBEb1h8I/vkK7rU0=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q6Bjd0010453;
	Tue, 26 Aug 2025 08:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mziY/eKfFcEFyoZ+H72DAE/Jj+OkVK/Qmf+ajVhvbqA=; b=
	iE1voyF+Wv/ZmmMbLHoJWFO2LOHE5/MY56kKXRf+5H7dPuMh6WFVWm/WlSPHk/+o
	aglSXZg4DOqh39nR3fqbVLlzCeWfXec1UuEP3QvXx6iHLstxH+6IO51eKljDMYUQ
	LhfR5Ijqw+evzPbrX/R1f5FPa8MpgX0xqMoGMNrI6nXDb6ddkGeyf97AwfDIfxZL
	EFdzTkwcOwjVBb943szjC41ETMzXXda/viM39tExeGfbjZnIoal8pWUqjHFf0PJI
	TKzSHHH6sNG4hBXwocrN3yoPxyBZKx99yyYnMNeiiA85afRnppdeo7lD3wloV2do
	DZJvd6XMfzVoozHxPdpd8A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q58s3wrh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 08:33:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q7QU1I012418;
	Tue, 26 Aug 2025 08:33:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43983td-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 08:33:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l4qqFwiPOhSfpIox1cfFL47vZyieGT6WKEe1fVaX7jrlbRmPru+y836+lvEImicKwMRL96sktgF0WWwf5kYjRgraHbJ+NX54RB0lnM7OOfRf+lmszBKpI7cAN6FtqIKHY6w/kf2ntoUlrxLNBoqK9ZIXncs5o1o8qawoKKvQuJcz2OiSbxDq5XB4YvMYeixN3ywxStSGbuHN2nYHvXPKsX4fI9rhZ+U/D3ngI9fG2CLIh8n/3y+Yz6dWuJOdZHdA9ATundhMmvnetPGyVZw2SjkugaL3JT0Mm7KxouscsT3TC2M4VzrRVw0kNd3lkcMal8Iqe2E1hQh2Gzh4MPTCNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mziY/eKfFcEFyoZ+H72DAE/Jj+OkVK/Qmf+ajVhvbqA=;
 b=KhFYhYS+VXds0P8jBjty3dpYRYGgMrPX0XdcQjPKbMGSsdcViBohQ3Lls94otFsC2Tm7C3BYwD9aPYkbLJZhvflrU315IpLZhu7WPLmf1p0KH4Rh01mBtyQcf3vSxT/O+0l7iTEsujjtRpNmSvxIz5Sz3Ae4dKbK2LZQIi+2GskSglzPzeFMfPldV8tTh0T5O58CNim7QVcrVcdxJMRxsT1jveG1HZ0c9KniRnDyKAmlaDNYbnobOE8Hwz+g1Onv/cyvzO0+rhAx+51c5vP5oTaUeAPHvXRg/SajLswRCmD2pWlfEwhqCIhu5WKwxRxO5j8zhAQExv7/ThpE7TfICQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mziY/eKfFcEFyoZ+H72DAE/Jj+OkVK/Qmf+ajVhvbqA=;
 b=prqCwyjy7Ze6dc2nNGAb2/d+EpDsJgPxjFy8yAJ1264iP2HbJ1q/rdPGKYzBSN9Zwcwx9ZCCoeH5H3irdJ6a8ZkeKwvErxDVK95m6TrhdBwE5Ij1hJxs1gXYnquz/iqmKcluBBA103bTOgZ9tbANdM4bc8qY9GLQAPNV+zTIDbM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5625.namprd10.prod.outlook.com (2603:10b6:510:f8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 08:33:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 08:33:19 +0000
Date: Tue, 26 Aug 2025 09:33:14 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        hannes@cmpxchg.org, usamaarif642@gmail.com,
        gutierrez.asier@huawei-partners.com, willy@infradead.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 mm-new 00/10] mm, bpf: BPF based THP order selection
Message-ID: <0398bfc4-49f5-4a7c-abba-90151002ff82@lucifer.local>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
 <d8f723c4-4cb0-431d-9df2-ba4ec74c7b43@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d8f723c4-4cb0-431d-9df2-ba4ec74c7b43@redhat.com>
X-ClientProxiedBy: MM0P280CA0047.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::28) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5625:EE_
X-MS-Office365-Filtering-Correlation-Id: e616717a-c9ba-4a99-73cd-08dde47b35df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OVB3RkpIWTFJYllWUFJTdndURmd0ZFFyTnNxRHgrdE1oZXZpaWVoUXVGMXNZ?=
 =?utf-8?B?V1FBN280aTNlRzllOGZhVmMrVHI2OEk2NjhXZmp1R3U3Ky9tWHBMNURIYTg3?=
 =?utf-8?B?dnNDU0ZCTUpkdkRmVFpLQThiNk91aStuWG1UK2xEMHdUODNzQ3VYVlVpd0E3?=
 =?utf-8?B?MURBMzJTRTRnU0NWenNQZk1Xc3c0OEVob2p5WHFPUEpKSWhYV21PZTYrSnFk?=
 =?utf-8?B?TFYzTk0yMWFBWGlNUmZUbmhwY2ViSFZ3ZUE5TE85S3orVTJUTDVJVkFuRjly?=
 =?utf-8?B?d2hYZTJXblQzOU04SkcrOHpneFFBOE1qMERrYWt0bHBpcTZMd1VpQXZVbXFl?=
 =?utf-8?B?UW9ZNy9sZW1ESDBhTXU1Y1o3ZExwdzZoVHFwN1RXcXVCM3NRK1ZnR0FPbUc3?=
 =?utf-8?B?R0J1aVJlUTBiTHBLSmdOb3VlMGRFRDRzbWROSTlPT05id1ZiRDRtY05vcHAz?=
 =?utf-8?B?a2o3VVhzMGxkVkFoZDFGbE1HUnJINmRIb0Y2Z1J5djZQYlFVeTNHNEZldnVX?=
 =?utf-8?B?RXlReldoZDJQZ2dBcXc0a0tOMnd3NXNoZUV4TWJQaGh6SUJwa2FNaTZLMFlJ?=
 =?utf-8?B?dEhsU2VPRUFpeGpxSXNUZWJvSTBMd0I0SlF6Y05lM1NkOVkxdlZHZ0gwT21w?=
 =?utf-8?B?WmNTTUFjU3RML0ZMN3NkNTBJSE9EcVdDR1FjUmo4UXMvY1ZZS0x3NGdYTWRQ?=
 =?utf-8?B?NG4zUGJ6ckM2TDlFa3ZNK2JZWW4zaVhJMmh6bnZpZkF1MEFLMDR0d2x4L1hq?=
 =?utf-8?B?ektsaGJjNHBKdDFpd2hMdDVTZ2FqZkpRMVY5QU1QWTg5Vi9sNEFBcVFMRmtK?=
 =?utf-8?B?NTFyUThpQUdCUndqNDJ5Z20vcE00REEzbmtzVC9ONVhVWW9KQkVlQ3ZDcUJ5?=
 =?utf-8?B?WmVuMmFvOWRzZ2FzS2xuVzFtUkJmY3YremJtR3l5U0U4UG9ia0N6Z3Avam85?=
 =?utf-8?B?YW42NDdXa0k3VFExRkQyLytyOTVnMlloekhQOTZnUGYxbEJ0OVFadXRKUFdM?=
 =?utf-8?B?M0RFYXNnbGlNbUI5VFF3VVFHM1VuOURJRThMTTB3RHJOWlE0VkZEYURZdnR0?=
 =?utf-8?B?QjV1OWdwa25tK2NBZThaUHI3dXBYY2Q3SjlpNDUwYTRGMXVvQm80YlM1VmZX?=
 =?utf-8?B?RExZYVZ3R2I5L0pDQ3JONFJDa0ptKzF1S1YvWCt1RkhxeGV5MnRKNzdGQjYy?=
 =?utf-8?B?RE1rbFhXRm1HeTdXVkFQQWJOOCtSMWhLbHh3cFBNZjdBUzhabENUUUMyUU5s?=
 =?utf-8?B?QU1KK3JEd2M4OXVGUVpEVmFQM2FrZGlSKzFqczZvbXFiQTNhRWYvMHBIUXFu?=
 =?utf-8?B?WkVIK1MxL1ZYWWtobTlueXZqU1BHT3ZHOXJrSXBOektUeXB0WTRvWC9pdDlr?=
 =?utf-8?B?UWltZGsxM1FLKzltMjVpeFpkVHZNcUxZa2lIRndGZWFRM1dpN2tWQzlWWEhC?=
 =?utf-8?B?amVkZlNZUDhtZVM3cC9ZZjAxbkVMK3RDWElWeVRBSUtYSFZ6MHAvVTBmTW8v?=
 =?utf-8?B?V2JZY09kMndkckd3WGhBL2hLZHVYWTRaYjBZdkJuMmVDNmdUU1dFK1N2OXRZ?=
 =?utf-8?B?MzNXSlJobm5CQjVPdWRXL3k4cHkwSytYdGx3Rkl1QnZLVXExM2E2bnFiS3Fs?=
 =?utf-8?B?QlQxeFdQMkZUbE5KUE9xYk12b1RTNmRlTFlHNVdEbzgzYVJpSW54bzd1Y2p1?=
 =?utf-8?B?QzQ1Wk1hZXEyV3ArRDdvSGg4cUUvNlh6M1RtWXVsK2NFYUkrYlVFNFc1V1NZ?=
 =?utf-8?B?RjVzYXIyYXcrOWcvcnhxSU54N2dCTnN6SWNkNlZqbTI4ODhQUmFHTHRqWWVZ?=
 =?utf-8?B?THhNUWhYaVVvSlNWQisxRzBLRm83SGFMVitjNzYzRndZWDJvaWd2TlZWRVhW?=
 =?utf-8?B?YUFaWHlXc1hMZmxsKzd2WGtUdVYxYytWWXp5V3psbVJuS2NIV1RHa3R4bG9k?=
 =?utf-8?Q?+URrldrhx2A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEhsTm9Bd1lBRUNEZ2ZXZ2hxOXJpc1dod3NyYzF2cUphOXZ1Z0xmdGo2NDUv?=
 =?utf-8?B?ZXdxR1MwdXZQQ0FXQ0NObzVDVkVTbnlwcGJwV0JtZVgyblRpNHV6RHBnYzNj?=
 =?utf-8?B?aTlubGNidDJ3QU8xaS8rYmNYUVNYb2ZSSVpnU3BzazNrNUxGQmFQUGdaQytT?=
 =?utf-8?B?ZkpiTWMvcWlRenFnSHlGNEs0QllVY3hYVUJsRVlIWEFqZko3akRldGJ3VGdx?=
 =?utf-8?B?V0ZiSlpPMWVUTmhBalovVTY3MnVZTlI4VkttSHQ2RnA4SUJobjZWdjdrR0JZ?=
 =?utf-8?B?ekxRUjdTL3ZvWXl1WEFuQVNNb2VRNHl3cGNMZkp1WWJGUXdDY3AwNXBEakFY?=
 =?utf-8?B?Q2hIQmhQNzV2OFpyUWhoUjJuSjFCWUZoZVhSOEFkM2VrMDZ0SWpvRUZsdHZO?=
 =?utf-8?B?OThIU244cC9jL1dGa3FMd0toeDBlRE0ybHZkT2lSODkzaDVwTDh5dnE3bUk4?=
 =?utf-8?B?dXZVWWh5QlZlMStnc2tVZmVJb1ZKOURTYldGUVhUUUZnOUFaNCtxNTIrdFRw?=
 =?utf-8?B?R1hFTWtmTXJRVWFIanF0VSs5OHZKckR0K0ZmWXFKN1Q1RFJRNlZUVkVhdFdO?=
 =?utf-8?B?YVF2cG1GSmJZVFpXOUpsZFNMWTl5L1dTK0J6cnQwMGNzZnZUKzZiT3pJR2RP?=
 =?utf-8?B?TXdXQkFNMFd3QUk1SnZNTlR4K2NPaUhWNFI3bjVuZzJ4L25wNlpKTmJIZm80?=
 =?utf-8?B?OFdhRHpuNVRoWEhCS2hqbnhBb285YlVrd0l0RThoV2NzTHI0VGhGQXJGVVBW?=
 =?utf-8?B?SEtReS8xVCtGdlFUaStUeDEzSFQ0M0ZpZmExL0c2VlNoQXQxVk45bnk0bXdS?=
 =?utf-8?B?Y0g3SWsyRmF0NjM0ZVRDUzFQblAwSFRsc2NhSGxFbzVlbDFiemh5UGVPS0tL?=
 =?utf-8?B?dVlQR3BhNDJuUzhBVTg5NEFLZzRNM3Z1NDFPcUdPb3k3MktuRlNNUk9LWndD?=
 =?utf-8?B?TnpWZ3pnNmJoVFduVVNYQUhSK2VhV0x1Q1Q5Z3h6c1oxazgvZExXeTBpTVV6?=
 =?utf-8?B?ZFFGTmVwM0UwdUNXZ3p0bzJQcFhxMVlmREVOU0pDbDhodkIvbWRLdnYyYUwr?=
 =?utf-8?B?L0J3Yi9NZXZPdm5uZjZ3QmQxTGFybXIrZ2VCZmtMOFRjUHFQL3lyMi9IMzJK?=
 =?utf-8?B?YStXTU9WdmFvWXFFa01UZFd2bVFYVld5KzdBQWtZOXhlZEZzVFRZSWRlNWw1?=
 =?utf-8?B?dFRtZS94Nm9naUZEWmcrQm5jbTZlK1RwNDJMYm5aNENDSlMwUkJQSXczZlpp?=
 =?utf-8?B?VGNTZ1dLbmkyN2dGbE82cVFPaHhEZXRXWnhIVzZHVXpiVWhPVjRjWWlHMVM2?=
 =?utf-8?B?eE1RN1JNT2NzbUV6NXpzZlZ0SXQ0azVWaTF3c1NKT25aV3A1UjdiRVhFdXVP?=
 =?utf-8?B?azkvdVhIRkNzb295NFM1UTBOcnBWelNuek83QUNrejl4YWkra2xKbFpDbUlZ?=
 =?utf-8?B?NE0ySU1JZjJXNkY2eXUwdStQMGxhT3o5UFNTUmpiZDZ2SVdzVEFYcmExeTVU?=
 =?utf-8?B?bFJDYjlPOGhFdk5sai9CWlRkU2NBaGRzK2J4RzRRNkp4NW92YUEvUmM3SFZW?=
 =?utf-8?B?YU44b3ppWUtJaHkrdG9LTEcyUTlvclJmUnk3T1puWEVJUmdrYi9JakRSc2w2?=
 =?utf-8?B?WFdxWGh2NkFkMmpkQ1FVbDlxWjVPTjdjeVJjdnphZ1FJMWdhMS9uam1xZ0RH?=
 =?utf-8?B?ZHZDaFV4eGE2eGVFV1Jmc0RNTWhLRkhiYkp5REQweVRKM0xIeXV5by90VGpk?=
 =?utf-8?B?L1BTQ0NsVjJpRWZQMWFCcXYyQ055YkJYYjkvYTVqMFBSMWpOSVVCMEkyRzQ1?=
 =?utf-8?B?QWVTV0lxalY1WWxwcDhqS3JITnh6RXBZbVFUWXV5dUMzdXNZdkNXUnQ1SGda?=
 =?utf-8?B?aFZ4NTJmVk9USDRldjRZTFpKdG1GQW1xQ0w4RnNZaXhiRHk3TG90ek13OTV3?=
 =?utf-8?B?ZHZ6MmRnMW9TSGQwbVdFM0MvK2dPR1BnMFgwUXZieTdjcUNSaDlISHp4RVdU?=
 =?utf-8?B?V2w2MDdVQlJjRnl1TnQrcURvazJOVTdVNUsya05adVVETVRUNjJIVHVnNmRu?=
 =?utf-8?B?Y3VrWkZLdWZYL3lnbTEreWhLNHl4c2poTmt2azBoL2FZdzIxQzhkK0RJSnhh?=
 =?utf-8?B?UXF5M0Q1L2hxMlYvb2hKUW5qZnhpNjZrQlBaSjg0NXpQL3FiUnNraW0yNzli?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pAl72M8n6Xook0Ex4mZECujdD0vKP/1Rp2CBUowv+MRbFVwyTEsGceuKsCYJqA1LMsEcSzUG2Wh/M4X5Axhxnj7ReQ1qNJBuB4tu1apZVc1f94FfZclwb1HsNNjyUaWRWfKMgZVv1b8TQOlNL5Yoxmr3M1DYkwxQRWAO5NHH+GIQXXSlCua0YQrfR6Mefhtf3+uqla2SiHs0VjgP6VKG5eWZ3IBXoKHqQIm6l6y6WB1rsn7AmUaxgvz+dcNi1T60NxjW2I1j4NanucQXMmjuV+cSJ2caNaie2LtGP4a64QTljN4oSfsjztkmVt9NpfLIBJGOF4xXC7t2HArOJ64E1T7v8O6KbFTahe1KNT7qZlCc4RGNnLj3nSoddJpTOFnxyFFBJ0svRMcVwwfltene/36DVUVRbG8acrHeRMfW65tJiIawxldeZm0pep6lvIHBnQC3ugB1JFZvNYs5NrSHPIdvFnyg0WhpxPbcZOVvVtmpFqLrjcJQKJghGxUrqgCzBjDEFLx7SG/6t9to+o9X/Ml80s95muvWIWW5mp7+82jEOWFEC9V+ytvrkFrDWCI0Y0dWFaTqa5wMHqcY/qFI7GE07FzqY79h/v234yuDV30=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e616717a-c9ba-4a99-73cd-08dde47b35df
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 08:33:19.3095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6newjlFLdyygij6kpTlrAbcoMPjcDhMG4aYoe5o7ANBuRGCK49YLoR5rVUPzdQQg/gDpfBZvRndV9bKAKwnRjFuFfbIvohg140QIxH1033o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5625
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=870 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508260075
X-Authority-Analysis: v=2.4 cv=J6mq7BnS c=1 sm=1 tr=0 ts=68ad7153 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=RHwqBwa7QJl3oy4lJGoA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070
X-Proofpoint-GUID: yx93empHc97OssYTD9_is4vzfVOq7o6T
X-Proofpoint-ORIG-GUID: yx93empHc97OssYTD9_is4vzfVOq7o6T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyNyBTYWx0ZWRfX5LjvK0U6hjY0
 iUk9L2eQgicLvu2/Gn0iGwzaJc7/yLIAYNM4ymauoYAHjdwOh9wMdZ28Gb98Cbc0V813mfm5IJB
 Qf7f5rcZf3fROYepOgoBg5GsnufBC9/4J1Ut2lZ/h4w6pExSVgM2BJ6UWbzwi+tEI/WOhlmha3i
 u2/slgR0FNsUtWbhEfcsHuAbjGp70d4OaFytW29LVEP5FmtS5GqFOruTNW+p4PFAMn1KvpLf+r/
 fsd2pVG2msdDiJ5cOtZIEPAC3AwRx6vx9k+L20cmtNgVLrOeUvKZMK39su65kLjyMiE4U5lztvH
 HHisdtv1MzsJgzVyp9c3zBc22dgl4xEGVWs7VmR7qe/EZNtpIKeCtv6TAVCr9wUgLF8oBN1TJJC
 ZPmaTcpT+qobiuIqccjopmgXFKPGqQ==
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E9EEA100007
X-Stat-Signature: qz5954ytiw8bdsxrzmpn6h8qgci5rnbq
X-HE-Tag: 1756197234-849290
X-HE-Meta: U2FsdGVkX1+fgySei77SEOAoYenvRm2zRJcB3jtMc7Ov5VwNCO0gYtARtZnVoZ4hCefKuynAv9bd+ZlOSWfr/nXF5YJkCwf6Sy9XPStqqOxDLKjtGSiG34O5nvw2DI5a/7xws7/m1VllbHzsEMuqTwKTC/Mvyhw4tCjcJwBGyi3GdSDYQLjPiH+aR/u7urYaJYUof1tp1sWF1umHv11hkJWzXjaps7q1gdWnhhiUTwwxt2xLFma0zzJVa0sCZkTLvK0fSKpVbcE25Q4S5ukOAGKknIpVLhFC0x0cXybiB7tYSV7zweMCeksJIytte21SGGpqScSVege3a+d4SMiWgzO36WTNFlPb9YR9jOK/O0zcMN7xs3KxW1ouM85LMVcs+gudaGWSuNf3wd9SxssJg6JAAC2nb1DMjoGBgd0/7IZEowV0csV8SbsEewZ9LEBlP013LgFvxD/aJ7rnT0d0WSqI1vepZ4H2GPymkeY8FkDllvR1kUTT4nOeWLuQF/Yt738DDuhg8F0acEeLLnBvd9EwrVW8KAbr5Tkw4SNN+PFvuULXYR8VZ6x8DDkfiqGhuwVmVooeJvpVbUVMyrULgCHm1CiWFwqJLLrEL768jAceCLDVDVJaKh+A8kYluUWHxZHe6MSOJTdTzE3KlHHwdvoti9O5MefaIEz6v4bZ4s/CANEJLE4x/PxfvoSDqFoZem6ETxDmVcEfUmsiFwuNASC8O0WSOK5M5vwF8HRz0rEqBKP5BlYMd/Q/RtX+Klkx9iUd+XfzgI9/VnnVQ/x1AXbr/TtUFxsNoKyQsW3VyCHGbDj+tNOK9jo64Ru/jjW693c5o9W4FnsR8/Z2qWLNOPMmgvJvzE/6rS0le50htELxQ4hFJGLsn8a205qqs8kZVkdg47NJHr1YGz+ydI2NC+JNaoQjaQXOWnjlyFafW5UYG6n4jCN8/UqY/V8MsPalOsBEaJkwo63MkChO9MY
 Zn1Isbs9
 UeJ3uL/MnXAbT0HVlThPt+zAUtU0sTOdG4135YMeOze87n9fZdcMrjxgJGQvGGq0byofzTqUnio1kTC5nKH3+rEBfDnQNC+0YBkvCSRPIKoB5Ui3z7Id6z/7EGfqPT+ZCMOLDu/fMDJSIaMvtH+uWk2fk5uEu6YI09QcwAetKN/LpSITc7O6M26xMD6f4sBu0PiFiBa4lYSV8wg0PCLw+/jf0gRwf8bzHlW1lQedD83k8tMg4srBOU3DGvfrfvK1Yex+pLn5yG+d8Wcu6xMBZykQOHH/kcAgsgMXJHkZLecIfUolYDiZ4BlkDe4pgIDML5AqwFw/l1aEzzFzDipRmIWnJscdNdS/o1N8Px2NrSSf0zMbDx5MrjGJSTR5LgkSzyonKtwXptJI0gqUdwUFJwAGVEqh3b1hVUq1xEy8v76KsUNz6d1qAJ6grtcvob9zCcZ1j7rUbEy8iN0pnyRqiCBu5pQdIR59jsDqRiHSC/mO9XmTrjI/kJ8efOcM20/LMPJE0eeG+AkhbNFenKhjWuC4QzX/BaoNo8hvkh2lyANVKZCl3A3OqAiibkoSchcY4VKadUmr0RUoGva9V+0ehFLEOMEP9TLaSu/PIiZ6P5rfhMgvsgTZscsyMtAPF9xDGzWsnkGMsent7mjVWvmCUlHa2bU5yn0tJ5peJ0T+15iX/1nc6wK3xlzbIlLaoyTWADwq11wExxXCfUcPlBzQCggS84Uzq7bUl0S22gGRMHZoQWqAwi50EWqbb/3ptl/1Ix/zncCsi/UA9kRRcZ0009uwKvWzzPVXZzDM2DtNrES01f2/TD9c+BUkGyjDA4Q9S30CFDLGX4qp6xDowlAkPtwesoO6QeCh9Oj2f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 09:42:30AM +0200, David Hildenbrand wrote:
> On 26.08.25 09:19, Yafang Shao wrote:
> > Background
> > ==========
> >
> > Our production servers consistently configure THP to "never" due to
> > historical incidents caused by its behavior. Key issues include:
> > - Increased Memory Consumption
> >    THP significantly raises overall memory usage, reducing available memory
> >    for workloads.
> >
> > - Latency Spikes
> >    Random latency spikes occur due to frequent memory compaction triggered
> >    by THP.
> >
> > - Lack of Fine-Grained Control
> >    THP tuning is globally configured, making it unsuitable for containerized
> >    environments. When multiple workloads share a host, enabling THP without
> >    per-workload control leads to unpredictable behavior.
> >
> > Due to these issues, administrators avoid switching to madvise or always
> > modes—unless per-workload THP control is implemented.
> >
> > To address this, we propose BPF-based THP policy for flexible adjustment.
> > Additionally, as David mentioned [0], this mechanism can also serve as a
> > policy prototyping tool (test policies via BPF before upstreaming them).
>
> There is a lot going on and most reviewers (including me) are fairly busy
> right now, so getting more detailed review could take a while.
>
> This topic sounds like a good candidate for the bi-weekly MM alignment
> session.
>
> Would you be interested in presenting the current bpf interface, how to use
> it,  drawbacks, todos, ... in that forum?
>
> David Rientjes, who organizes this meeting, is already on Cc.

If we do this, would like an invite to it also!

Have been meaning to take a look into this in detail while in RFC but more so
now obviously :) as discussed in THP cabal, I am broadly in favour of this as
long we get the interface right.

Anyway let me have a look through...!

Cheers, Lorenzo

