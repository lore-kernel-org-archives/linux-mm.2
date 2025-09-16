Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51982CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE17E8E001B; Tue, 16 Sep 2025 14:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB90F8E0001; Tue, 16 Sep 2025 14:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980D28E001B; Tue, 16 Sep 2025 14:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 85BEC8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:12:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 372FA14029E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:12:42 +0000 (UTC)
X-FDA: 83895908964.28.D37C091
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 51C9D1C0019
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:12:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=APyYVu63;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wV3VX++Q;
	spf=pass (imf20.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758046358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dz1VlJ61ptRtjqMI7QHRsl620CCMSZvdQXmtLJSEK0s=;
	b=uzwHGP7jZXoZf1jKqjS10YJ/yde9+lXFCVsvtP/hXkaEtUsHRzUQAb4+8Z+nhDf46zx9dk
	Il+dOfvD+Mme7hrN4BBcsZtF8Eh+v5YgRHWXiOMUkf060eWqajhgShns0lDhXZGKAzagYg
	GJ9KFVjFzuViTWRbvlyqE4lFZMnf3g0=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=APyYVu63;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wV3VX++Q;
	spf=pass (imf20.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758046358; a=rsa-sha256;
	cv=pass;
	b=KjnnOcGcP13h3hWjYKvQXOGQ8oiaA1hVVpeqbXKx84cRYkLcyEM04/O7MDVOYqtaJPZPI6
	VQx+5ZVaqj4V3an3gI4yEKVGluH8nt77CvFbnXSqs6Z//qpX3EVBryvzyI5bbhpfGdetaO
	YjXNYoylkDCBWjRcLDAGHBhAnXD2zJU=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GIBxQF029978;
	Tue, 16 Sep 2025 18:12:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Dz1VlJ61ptRtjqMI7QHRsl620CCMSZvdQXmtLJSEK0s=; b=
	APyYVu639GG1OngkNd0pMKSB0GuP6b+0AuHJqN1m1QScSTKJWHaqyN84uaGKJj7W
	+0qdDKkMp83fpeJMXizgKQ9wG3N8oLneFj8S6PDZwYtLysYqnwi6YlhyhpWXWElA
	ScsksOYIrF4564M+/bxO4sIobnVy8TYM0qioXF6+h0n/42Jdg2cr800QIWAP6qTr
	n2IKvzNJp3QzsFmk9/yDSHY9KNThhZdTxcK2hSgGyxn2hZiCEonTS8MPd29KexKT
	DMGhDnb/0+nSjqM/b7GwMHSUC8xucpHwQlQr/ipUhMCxY2OscNwFmPIhxXUxOJ/M
	QkDLgWA645YRbK3zC66WGA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494y72wb13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 18:12:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58GGgDVh035313;
	Tue, 16 Sep 2025 18:12:26 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012000.outbound.protection.outlook.com [52.101.48.0])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2k21y0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 18:12:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z3zkng/62ydmBVzg5vdFqstKUOSXMpHl3Iz0FdArX1h7MD0eFn3gtmcIuDwXjyVfsDki1tUOaTjO6wP5M0iRlJlQm3gcqy2IoqJEGhPO9SQ8fTJ5bP+J8SGenR+/1dX0IVaq0YCOZ32BZCPwtZ3eytt6BrXiD4pQQCishxVx/LtFnnJg+O6NoqWtX1VbIZdn/FmEg7+DrPEbFBsXY7OEWkQ9S4/TBUZk3JOfpzEgdfnaMJICVnLcOU/JBTdYoNUL6PmZ5uBZBfk6PGg5nNCaKiU7pesm0NRuCcg0HOjCF+45FPpalgHNeLHqS6p1Kr7lJpdw2qXmJ+mOhBw2H+87TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dz1VlJ61ptRtjqMI7QHRsl620CCMSZvdQXmtLJSEK0s=;
 b=Ug2g6ElVdjOw/JvcihT9ZJlZTdbIZSOHQcmgpNPjBFYbPEuaG6OaGmTKs0yIn1NWK9dpNJdCvg2z3IpieV0o7KwtkWplU+suSZbqyAcdAVcXp64v0Fw4QGUyV8aOlFSWDfeMSYRhZmfcpsbN1nOBOimFq0tbNnn9tz9lmYlagSigh9HXhiQ7+mUemjI0Mwrtp/Yycd7flVdpn6sMlLfjHznSqVr0xG61n/MK/t/Y22FdqDhRa+gB59LUBD9xQDPrJUxi1xKhbrTMmNXPHIjRDD8hTeT6ES7kMow5RoaIBxqtglEs7zcZu/HHNDR8+LHcFVWEB4p6kjIbPULD/ZAyOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dz1VlJ61ptRtjqMI7QHRsl620CCMSZvdQXmtLJSEK0s=;
 b=wV3VX++QPhU+6sUMway0LfM/hlgczxx61GTWwSMKarN3+rSA+8tkWoU7bGTqEge8Ezr1U+LqpRK0/AbmLAWvneX6PuFsg3/E21PNihVkChX/0K+OuJEoD8UlMttlriBXYx4iqZkW1dq240qeQDXKcOeHWxK0PO0GFpZsiqcqAlQ=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 BY5PR10MB4211.namprd10.prod.outlook.com (2603:10b6:a03:20c::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.22; Tue, 16 Sep 2025 18:12:23 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 18:12:23 +0000
Message-ID: <2c1d20e1-f024-4f4a-90b6-685a4daf6bbb@oracle.com>
Date: Tue, 16 Sep 2025 11:12:20 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/hugetlb: fix copy_hugetlb_page_range() to use
 ->pt_share_count
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@redhat.com, harry.yoo@oracle.com, osalvador@suse.de,
        liushixin2@huawei.com, muchun.song@linux.dev, jannh@google.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250916004520.1604530-1-jane.chu@oracle.com>
 <20250915200815.e2b844e0a3291fa994d333b4@linux-foundation.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20250915200815.e2b844e0a3291fa994d333b4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::11) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|BY5PR10MB4211:EE_
X-MS-Office365-Filtering-Correlation-Id: 40bb7cbe-e040-4e28-2707-08ddf54c9559
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnhHaFBZT3MxQytscWJJMGlManM0WHEvNHFYbW9zTTFNVWVHU1YyY1dPNTFt?=
 =?utf-8?B?Rk1YdHArL3FPVmIzNUtmaGpkN01zZE8wcHEvTWhaV09SKzhtY3p6WjZZKzhW?=
 =?utf-8?B?ZkdzTDZXVDNjZENOTTlXdE1OcnpFbm5jaC95MkZNMEFlbURpNlNyZUpZVDFp?=
 =?utf-8?B?aGhxdWlwcGtiLzYyczdkckIvTXdPSjI5SEtHK2ZQbWxiZ0FkTW5ydU53WWgx?=
 =?utf-8?B?cWU1aTlUQ2ZzT2FuQ3NKekZ0L2ZWTTh2cDVjeWJZb205TmxGeEZSUkpwQ21v?=
 =?utf-8?B?cGtZaFlSampoMS9WTFhPNWRQTmVlQXNwR0NTRWoxb1JFb0Y0WU16QXkyZWs4?=
 =?utf-8?B?Z3A1UkhWL3JsbzAza3lvcW5QdGYzQVgxSllIOVV3SGdtUTNNMUVEcGhxUVpR?=
 =?utf-8?B?b3NSZXg4dXVIRjBnNWN6ZUdiZFdLSVR0ZjNDS3FRK3NxR0gxWjNnalRSZWtO?=
 =?utf-8?B?eDVVZktOTDJHV2Fpd1o5YjNSUDVFLzNUN0trMThOaVlXRnc3dkdVUHBlMUln?=
 =?utf-8?B?Y0RtZU44MjVwYWowWEd5V3lWbnFvbDVXWjY2TG9tRitUZFhoNS9DWW1GYjhY?=
 =?utf-8?B?ZVNWenZiV09nZlRrdi9MMmxpUDUzUUJyQ0h4aktVd3hsMVdaUkFEOVZRWkVs?=
 =?utf-8?B?TzZNaVdiTlBmS3cxME5jS2d5QzRrRytncVRFRGptNVp5ZGZEUDVoM093cDYy?=
 =?utf-8?B?UzZEYUVXejBVOUxVSHFhSXFUMnlTaDNTNkpUaHdBSm14VWtxZXFlMWVuVWZY?=
 =?utf-8?B?dHcwMkVSUFF4aWpHOTJxUVFFOXZnM0NkNGVnN1NWUGVyVjJmUStSN29zOGI5?=
 =?utf-8?B?ZkNhc0t2Vi9YQ0V4YW5yMGdYV3FnNUdjdnpzd1lxTXp2cmJGYTZXVm5lcHlM?=
 =?utf-8?B?eHduYURQQjJCU2tDaXpWSStVMGdaLzloaTJnTTJaR2J1S2tGaEJKL3ZqbUda?=
 =?utf-8?B?WmVkbUlCUlRERlVDUUlydkZSaElhZXR1c1VFMFZWLzJLQy9OK2dZaFpsRXhx?=
 =?utf-8?B?YVVtbThHSU0vSlh3UTZLRWI0N3F5NkJaSTFWNVBRckc0ejY1Rmt5L3Bqd1lM?=
 =?utf-8?B?c2pZQTdCdFhzcDlYMFdmQUxkaG9BSWIrWHpYekFpMnJaQ2haN0hpN1pETEpk?=
 =?utf-8?B?ZWhGS1RoQ1JCU1p6ejhoL2V5bzZHdW16ODRtYVZWMVh3ZjZGSzRJbG1Yc1Yv?=
 =?utf-8?B?clpGMWo5OThnSjJWbEpvakozKzl0Ym9XS0VndHVwTXBJQ0RzZkpBSTNEZi9n?=
 =?utf-8?B?eVVNNXlLNitac1ppY2kwWkduaHlLTnlvMkxEdzFjWHRUZG5MY3h6YXQxbllz?=
 =?utf-8?B?RFRqcGZESXlvRlZJcEVXNWMxSkY0NDUrTVNQaHhvcWlpdTlLeGE0dHZSRFBu?=
 =?utf-8?B?U0RiSE9LcnlWTHFLaWJRSDNDN0pyNFp3RWUrcCtqZ0ZuRWdNOWt6ZTRiT3oy?=
 =?utf-8?B?ZVB1TUEwSjBwdmtjMmxhR1NmNWRtUkF2QzFNTm5QSWM0MmJUOTZGWDFFZmVo?=
 =?utf-8?B?T3hlZ090SDlXb0dueG5oSmcrZ0U5a3VneS92S0huYWIyVkxrVjBKTXZETFQv?=
 =?utf-8?B?MEx0WUhHK3QzR2FSei8vRDJWSnlpd0M2R0xyNFNEckUxTEcvK0dnMjdBSURh?=
 =?utf-8?B?QXVMWnpmaEp2T20vZHRHYnJTbndyRkFjblE0OTM5MWhKSmg1WU9xeU5LQVFY?=
 =?utf-8?B?Nm9zQjNaUjZ0YlE5aGl2S0RXOG94TWVPTk8yZDI4OHFVZjltOS9zeVYzYW14?=
 =?utf-8?B?c0k2ZHJMQVZSa2NRTkJhT2daSzh3WHAxY3RmemdzNStpNjB3M1N5VSt5UlRK?=
 =?utf-8?B?MnMwR1pYSlFDVHJ4K2pNYit4cmNYcUpROFRqWXUxMUVTZ2JzOVE4T2grQ2lo?=
 =?utf-8?B?Vm5VaDdURGdnVTI5dy9INDU0KzJyZzdDTlp1cjlrcHFsZytqMEdmdlpWNTR6?=
 =?utf-8?Q?d75GpBk/+iE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2pNU2cra3NEV2hwSStMYnlMclgwc2k2T0Q2VGhhVEFOSDRsUVlweVJwdTdB?=
 =?utf-8?B?Sy9NQUhObzA1a2xuWG9hN1JNaEZFVnZ0VUxNOVNSd3N5T0xsTVlteUpDbHpY?=
 =?utf-8?B?MlVpWkNOaklhNGx1RmN2RGhUbldUZmhkTXlUeTFQa0RVTkdyL3NSc2ltVDg5?=
 =?utf-8?B?NnpZd1NRVExOUkhxYlNxQTMvUy9HN2JHT3hzbDcrN1dWSTRRd0VXVGtuMUNE?=
 =?utf-8?B?WHpKU0ViVW5LL253UnViU0lFRWZhMmhWSDdyYzBXUFpwVDlDN3NRY1gxbXZx?=
 =?utf-8?B?UmV0Q3FuZUdXWnpDdjV4WWlTZ2tTK2RkbHc3Zmx4RmJvaVIrSmRjMVFEVW5Y?=
 =?utf-8?B?Ym9uOGpBTkZOVWtLZXQxTmF3ZjdTclE0ZWZhbEtuUUdJVGEzRFB5SU0rNzJC?=
 =?utf-8?B?MnJ6dkpCWUZxNGd0Y2NKeGM2blhEZW5yRGpyUlByUzFTWkYzMExlUld1RGha?=
 =?utf-8?B?N21vekc5OVdaMkVIMXNXNnZxUm1nUVhQYU9vOVM0U1B0UnZuRWVSb3FPd21R?=
 =?utf-8?B?U3FtMkNGdk0zSW0vcEZXMnk4L1JYd215ckRrR0Y5MVRKdmJlaTZPcFJjRnht?=
 =?utf-8?B?cVBuWVFRRVYrQ0NVMlZNczhEaW9IQkREa1N1a1ZPZlA2WWtGOEFnUHBmT09z?=
 =?utf-8?B?dDcwNzlBeWdkNzhNNTdXVklYclZaNE1MbURwcm9FZmdXMXRWYUt1aHJhZFFI?=
 =?utf-8?B?YUM1c3I1SXViUHpMNnppNENmZ2VTUlZHV0QwTElxOU9xM2dXeVhDWlVjZDV4?=
 =?utf-8?B?NTJJa3hpYUlxR0pmUDB2SVo0NElVN2RLdW5mNlRtdU5rYnZEakNtbkhhTGxB?=
 =?utf-8?B?Tkp2OWlBdngvTm5hVFpZMmo5UVhFSjBSWlZ0OEF5amV3UEtBNXBQcVo5ZCtZ?=
 =?utf-8?B?aTd5M2t0cWc1MEYxcDZpQzhPVGk0a3ZxL2thd2lOdy81cWx1cGF2M3lkQ2R0?=
 =?utf-8?B?NkdmeDN3eHo1dUh3aVZaUjBRWjNyVi9xalljWEVsNzZHeXM4aUhUUDA3OWVN?=
 =?utf-8?B?dmNEajZucjRDZ3djSFFhNnd3RDBRbE5HZzIyazExZ3NScVdmVVhGTTludTdC?=
 =?utf-8?B?bjB5MHpsRnhXQUF6STlmem9IMEdDQTlPY2VRRG1pOWFiQm9IRGxDK05nTkdl?=
 =?utf-8?B?K1pQaEtZSlJQMmoybmhsekNvUE91Um1lWTRYT3VQazRqNmg1VktUTEtadEFF?=
 =?utf-8?B?cjk5RDdNVmVoajlkTmJFbVZyK1pBcVkxdGhESjAxY0JSODkzUU41aklhMGdj?=
 =?utf-8?B?SnJoR2FoRVBWdzcxQWxnblFERmtWOXdNVElmYmR5S3dQWDNHZ0RPck9NNE95?=
 =?utf-8?B?cm81U3RzNU1lWk9qN242V1JyMm10RS94VFFBOGRNcmZ2cEZSb20ybWpRZ1gv?=
 =?utf-8?B?djF5QkdWdFpCaDBKSVo4eFFLbTVaK1RWejEycjNkMXMralEwU2ptdFYwYVZr?=
 =?utf-8?B?aEVIY3lPRzlteUtCQmVURnNHcjlja21UVVBuU01JWWp3S1I2WG1wNVdmV01O?=
 =?utf-8?B?R1U0MVhDOElxNzRqZFJNVWhtcGdhSDlHUDlvbGJyejcyaVhUSEtpY0xzOFpB?=
 =?utf-8?B?Q25YZzkrQjd2M0lDRnlFUkFHTzZTWmRwaFQrY1lhZ2xUR0w0WlhjTFVHeVJn?=
 =?utf-8?B?NlZwT1BERTk2ZFdJUS9HT3o5citORWJjbDJ1aElBaDBkWllHK2tEUEg4YTlO?=
 =?utf-8?B?NTduVTBLMERyeXNGcTBFYm9SRFNVNW1zSWNiVGVFZGM4V1BYRkVablArZGUv?=
 =?utf-8?B?ZDMrdjlEZ2xvTis2Q3hvcGtocXJjTkJRd2lnVzlDNjF5VWtZWlRaRWhvRG5j?=
 =?utf-8?B?Zjh2TmRldU9RU2xqVWxiUFgycll1TVRwbU5sYm9ETUpLNjlQR3M3Z0w1N2cv?=
 =?utf-8?B?QTdXWEp5RVMrYldacDdjRjY5MXU3VjhBaWF0NWxEZ2JUMEFjbzVHRVk0TTZF?=
 =?utf-8?B?SjNQeVJRdjQ0elcyRUQ3R09TKzVOZ2VoUGRFeUN5SHF6bi9yckxBK2YzRjVD?=
 =?utf-8?B?MTVtVWFBd1BSdVNrL2NaT1NuaVRQc0VROXArSy9lZDNDeHNWa281SllZS214?=
 =?utf-8?B?d09adDRySzQzRDJTdDdhbVA1VndrMmpGR3lSVWxCd21KTGZreEhaVURWRGJq?=
 =?utf-8?Q?PC2r2dicm231kUMznn7ruYuRJ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oSmLbyPOGdtj3USSKS7lm/RjzSPh3OSi2t9DOR3pjxBFrxwOTK//AO+rsbbeQ+2OJxeP+8S34kC/xmwuz+2Ds1rWaL4vS1DfM+uUDfHYAO6pAN+NruB68JF6b4J8K5Ra4hjsb1P3yWAcaMOhYIb9ELcWEcZKTEpVuqve/o4SxmMFtXkR/SxHMg9P7HFEUXueFxsHZumpisj2IeGJMndE4iJTZvqHjN5lDe6K4YhqTkMFsMuhOEmMTPZY9NUJR/tNl8WDWzeXC89jpP+/sm5udNJx4XCO/DoUI7Fd51jjiEotqkUA41mEcb1lwUp9EDagqZVkMySVKVObddnya9p3N4OKtvh5gX7IBFDNUh6/ja2nIAjZoT94yj+mTTQAfztjnmY+0pubmAMYnwLmJkqgAT5jNiw0iH6hvVOtzkjh6phGigtmYu+u/VxaAEVa/RzSPhXxj7lqaxvwT6mzRSK75yupT8GTg/srxo2aUHkxPq6l/aEzwa8WdTfstuPqMAYxvQF4TOcnq1akuVBWzCui066IIFZpFjA8jFesRGEveDVPgHE5/83P0PweUg8kC87KrBHEElsoD17WW9fX1DHzrE3KAtkJs7MNg03skOGhpgU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40bb7cbe-e040-4e28-2707-08ddf54c9559
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 18:12:23.0599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fNCglUKlpyAQFXGyIyjzDQzsrkG8ukVOEwWAzXfp1KKznHTulJhnoBxBv2YTXgmDMHLHp3bMLIJ2/rkn4/F4CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4211
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509160169
X-Authority-Analysis: v=2.4 cv=F9lXdrhN c=1 sm=1 tr=0 ts=68c9a88c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=40Hn-1xceIyPyDX-wYcA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13614
X-Proofpoint-ORIG-GUID: yCDWIP_oHbA4fSBLFO-ig1KaReb909RI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxMyBTYWx0ZWRfX3tocs6MbGldf
 cgCbf1JbjC0DTOQS8M55Y2XCbXR2ByivYWFhMueRxy/TzQZIKQzdcNaVHPpLOricM612ndkBYFJ
 jHxqSMzJ02fDUmsSKiOZIjtQPc1JJGcO4Mv1mkLoK1ht+94sTEtgySB9WFAhNqIIrmLr47KkL04
 Ruv/6bYqf8qmUsYSrx5ZCFKYyKDHzuYua1N/gJ4hjB2lnK6coi7bClUqIqsKu2Z79OWqQiCCeaw
 88MH+fIJjXloW65j+O/p3D87A8jSDg44n6RZ+3I+F4aQg1+HUwAYJobBS5fpHELNGzRFMh6ND8w
 Xe5AAJfvtk5JJ473jJwnNVAt5WoErnnjtJ4rBptBo1rGvxC1ocYWxVtMU9yAkMK7XN7RqeIRtj8
 j0WgRlzPZ4Y5KOAq6b0HKCO7yTIqtw==
X-Proofpoint-GUID: yCDWIP_oHbA4fSBLFO-ig1KaReb909RI
X-Rspamd-Queue-Id: 51C9D1C0019
X-Stat-Signature: iirewa1req9sbt1crxbmctmpgpjqqqnd
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758046358-764298
X-HE-Meta: U2FsdGVkX1/mmLQ8mWfOifUcdrUYZuxvNHEPzfgCwTs3Fo51ZT2UERh5y6HTEFps3GwDkq4qT+cl/U6awWFGL1S9b6Kx22nSDsZjHEuDTIc28h/Z9gNgUwBw2fC4gO7qDX4iRnEL5FhP82xw+V0RjMW8BJzlmfTouaYBmPyBZ8sQFAZ37Ba869RXeLHTuFqPGxT/5pY8J/JcT+0HxLPeWxSec04d+mwCBMbcNFri4p/n6RdlKHvKcC9LWfV93jK68ZKrQylCknZVnlrh/0WfJZe9t2o91AE0IfC9sZGnai8jM8bPHC5jM4nQAPoaeGGHM9Gz8JTIjDomtNlPnFKTqBZnZeTz8zbP0Rsbh+cGRXPNNGyDUmbzUsevPasA1LRLKJLQwzj0upqGcmeCidhx8PPc81tnssUgZG4g44StPj1OUX3p0aY7WG6YSbxhgr1b65TS9O1N0RqN9hhuzp98w0UKFlMXaIkHGuFwq5MHW1tpHbDfjTmp6g1PaEg2LZlZIhQYJCxJniyXKQ2bPvz3BMhkmDv4RQ8XuH+8oob4UZGvlHF6sq4yODw65rH9RjTIct496I+1/C8gT1hstcyULw9ZiCk8OYux+rmxIgv9OwSrak37Wcnfd5VQkWtj3O1Vs5PvUhFnJlPCYtwmDK4oaXj95NLZtqrv7AevK01pGSCa9NRMzi0gYOD87b4s5tlwgxeIU6dtLWSHUkaRX7ngaQqNi7HPCz31z0V9+8QgpPhXdsGWp4tpYva2IFHFgF/C7xp1iqdpiWUcHkXxQebjcaJCVIQI9l3uvYDZkgeoVBaJ0W37jsCnPJ4MZxXt+0VVEUOgpS1AbGeejteeuArtDl68NRRIYk3zTFhFfzbqqejd18SooSpn4Z2+lg8TUe2MjzgZcKoow3VtF7alLfbGco002Sj90bXm76szHXvhd2ilxT8966XnhDafoD3PM0KoMd8bHrUYCHC0xJxR+0G
 PpjXfXtG
 XwoPkI5dcdWefVmXVp2S2kQfqszlk8stfd60M8WWLjhlEarWdYod6BgdL/4BtTBanYAdsYvKeRCqrPBBMl4WRq2ZcOjXtl5V+Mma/k1T9d4se8oYv25bUbAQhrnm7+KMGxJbab9XRqLpJDbFFat3b/vYhPA79lxOVRMqnFUEWSQU3eTvaMT+8sxwDzSCFGj6URk2cgEg5+C00YXmmyndf6OHyaIuwiSQ5+G5t6pYEZN/oBQo55VE5DDlunTjq6pzeKdPyzwHT1isWeWhcXAEjAXhEn8Wn8oiOFROi2+Lnx5PK71jlCAL7D+BuCLqUNUX8MJWZHs8JhOeaZ+JvBadXKBB1eBrrU62+2wOKq8FMZzGX0xYSVoxZmoVwS0lQRWUhFwlrHXL7B5U6USz1b8tgI4E1j7H31+DzpihJKg1RGcriXu7+ieuYfmFpEjjKr14+4KqUAJmclVeMJSLdes/48JTfwbH1l1n3OdDaQOJKE76uHBqFWWI310IlqU9Av45ZWfpQpdC5MbgqtuK8hueoCs+ZIg9RaGyZV+dn/8bQYsYMm4d6nlOlgGmfr7EvxWEpHp5uygpABq/ISnsgJRtl21VwiaGPPapF+0kmwrSW0ATP9pxamRqzI1E8xhVgcPJExdojNUbY446uNxtJ7V1r5kE2my7emu8aXiewKeUpkNk23sH6a8tJp30KZ3Jhvp99v2+ePLu4Fi3PwGVIiwC5on4H9SS24youJDi7wjA0siP+BXbu5Q4wCHYnoq/ZkGgOoAZs7hcFUSNQXl1AG1iKZ0Utck6RyNYVxNZY1hcNNLFmu8k/FBRKbGwSNOO/Ckzr7Xz37i+wpC+mNrc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/15/2025 8:08 PM, Andrew Morton wrote:
>> Fixes: 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared count")
>> Signed-off-by: Jane Chu<jane.chu@oracle.com>
>> Reviewed-by: Harry Yoo<harry.yoo@oracle.com>
>> ---
>>   include/linux/mm_types.h |  5 +++++
>>   mm/hugetlb.c             | 15 +++++----------
>>   2 files changed, 10 insertions(+), 10 deletions(-)
>>
> It's conventional (and useful) to explain (beneath the "---") what
> changed since the previous version.
> 
> Here's the v2->v3 diff, which appears to be based on David's review
> comments:

Yes, v3 is entirely based on David's comments.  I will resend with 
comments added.

thanks,
-jane

