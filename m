Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3903CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 17:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9BC8E000B; Thu,  2 Oct 2025 13:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0838E0001; Thu,  2 Oct 2025 13:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98A08E000B; Thu,  2 Oct 2025 13:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C40908E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:47:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67389BA391
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:47:42 +0000 (UTC)
X-FDA: 83953906764.23.0A4E329
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 07E2320016
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:47:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="guKQPg0/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=T156ln3u;
	spf=pass (imf13.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759427259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46whvMIBPlzCwRUtE9zCMujOGaCwghbIasAH7idnOyM=;
	b=Ku8OwTpbyvhGjMKgP7Lsr+p1X7EEpaAt67KS/MYo01EQ0iSmq7aM33Wp+nUBT89C2WXJ6w
	uhybR7A0PYYpnjhBZ3s6+qPI7ty6qTzrO5vy81YdvJDnYvqTDOsStLKgbi8ZZOln4uzOCr
	QxvPZ1MSyZ8qS4uKtdOeKeyNNMmjG6U=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="guKQPg0/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=T156ln3u;
	spf=pass (imf13.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759427259; a=rsa-sha256;
	cv=pass;
	b=gbpVqUeFvyUTLL8JPDlDB+eJwm/ZBdOqzeL1h9mUrUJSrupNRt0BY/xqPD3SeqD3zuiqcx
	e8mARyppJgkQPPY/BsIYe7HRtuHvm1oSmR9eEN0vzQPvbNPZQC0n+ILfdvtLjshAVQlHKV
	VfhY+YU7q8yzyulpiVQByAYhbHCZ0JA=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 592DNApf009935;
	Thu, 2 Oct 2025 17:47:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=46whvMIBPlzCwRUtE9zCMujOGaCwghbIasAH7idnOyM=; b=
	guKQPg0/d3TCMiSp62WVlp1GLYLs9+J9QAplW5AU7bpQVQGSE93PS2DZG+itms4T
	lozgcayCuY3Hzfgs/4ndT+hyLWBh+nQMo8zI6aGQEBekM/LiFATAKrpLhUHsOh1F
	29h8bs4Uu2Y4m7XcJ1Gnb81UNoNkYSwXd2AJW7YENvgmO/ZMehc1cMRycRvlcrU2
	V7bkedQ1hCpuAD+FB/Wn5QYn60RbrnQ4JXQ8Be5AEGU2Y4w3Je7/bammshp/Whns
	yiESec0HeiEyxSaB/3HnIdyTR9WQJJYAunkmCz8FfLOTOswHKbpwqcD6B8hW5JKh
	DrpCB71HvJOoEtZNgqttXg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gm3bkvpe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Oct 2025 17:47:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 592GZaRE017442;
	Thu, 2 Oct 2025 17:47:28 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011042.outbound.protection.outlook.com [52.101.62.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49hw232bt0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Oct 2025 17:47:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xG/iJcXMVR4VqmdJwXdbCA1jZE25Dc0Lpu2JJJgKJOdNgqvqN/V8L0Xbhq+fAVhxHWNTHlkpIAodT9jF9Gj71eyEi05Y9XB1K1Esl/BDPF3gRt3gDjj1TEi7xvQrFizRbioXTsQxfQDIcUJjqnrkPYMEcwCIoCUFSwviKaC0BGaH0iV5AymxLMdOTNWUtK9BPoqotKkqqYRkSpMkdGyXuMTr3/PKoNDNPQjT5ErCShOXjgOp3dzyFDpd+blsuwRO0BqGHJ7mCJ1XIHjW4BOwwqGOmZge8/TcqGttqypDzF7X1IRXEOXO4X0eFrRgeY/LEZx3xOz3U39IM9pCHogwag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46whvMIBPlzCwRUtE9zCMujOGaCwghbIasAH7idnOyM=;
 b=eube35IFFT9xEBN7qRhWUH7mS+N2Xzb54+3g9LQACQv7AUTg/47ZJdVl9rR9hLsSFV5VY0wEc6SOPhvRfixAC041gn8FvhXRaxRFheOmXI3T9jrFy78Y5H1pU2PKkJ5n6uJJNCfbHkNF2/6LZrLILJMPLdqIQnNwnZoP5xnPmOd50L+rXrho46sJXUOy7cna2dXIypASL3UnMZexzUTE5rTzdPpQkWfyZge54Bqgx+NbJO1wMStbCTU3b45l0E9FHft56Hi2ksVzy7dIj3Iy9IYjS/EDsFDVkAwKY60C+xl4O4TY2akvu+HSVitjKvVhaEyev0V9pgQVyfz5EEW6qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46whvMIBPlzCwRUtE9zCMujOGaCwghbIasAH7idnOyM=;
 b=T156ln3u2pJ++XZrO98xTfQXmpIhwXWev0I1AvzSPs0MGmzTeVDGyGZEgketW/qzCTH1bqpQtMQTHk0WSlFi2oyHB1ZadUCHqsU0BG0U2XlzWarfFQOZRxpju5JmJzvPL5ISVJk/JUhVP9I1EjeM8EC2EQgihlGS1tqVeM5QZVg=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 SJ1PR10MB5953.namprd10.prod.outlook.com (2603:10b6:a03:48c::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.18; Thu, 2 Oct 2025 17:47:20 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 17:47:20 +0000
Message-ID: <ae74c0b4-7115-4856-a3f0-c61945f64c7d@oracle.com>
Date: Thu, 2 Oct 2025 10:47:16 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: Zi Yan <ziy@nvidia.com>
Cc: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org,
        david@redhat.com, kernel@pankajraghav.com, linmiaohe@huawei.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org,
        nao.horiguchi@gmail.com
References: <68dcb33a.a00a0220.102ee.0053.GAE@google.com>
 <2afee6bb-b2f0-4a86-ba8c-d33b0b477473@oracle.com>
 <637BC0B5-B911-4A79-8107-BD7CDB351660@nvidia.com>
 <A4321695-9F12-4C7C-ACC9-72FD84B6DB2C@nvidia.com>
 <57d9aa32-2fc8-48d2-b68b-3308c7d58125@oracle.com>
 <CD6D8EBD-F139-41BC-9A59-5033EF5A09BC@nvidia.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <CD6D8EBD-F139-41BC-9A59-5033EF5A09BC@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0075.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::16) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|SJ1PR10MB5953:EE_
X-MS-Office365-Filtering-Correlation-Id: 525a1306-08eb-4e9a-9437-08de01dbbc3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d2g1dVgycGRWbWJETk95eWF4Um1zSGZYNGhWallsKytwL2tJYlNkY1A2aGZu?=
 =?utf-8?B?bnMza29kQ0EzUkxKdXBWRFVieGo0cWxtSVRLS3NVMU5GQlhBK3ZWVHk2RHpY?=
 =?utf-8?B?ZHNpY0RKcll6aWRJVUg5bTRWcUtWRWpwakZLemtKbjU0SGFzVm9UdGl1UE5H?=
 =?utf-8?B?Y2hnZTdGcXFQbFJRdDlvL2ZQeU5VUStOa013MHJlR2R6dThoREwyZ2V5RmFY?=
 =?utf-8?B?M3kyUXlxSEgvOFkwS2N3YTl6NnpNYkVDT1JxOTB4SUZrMm51Qk1aRW9YQ1h3?=
 =?utf-8?B?OWJpZEVlRWFNV2dxZmo0NEd6VGp5c1E3RW52QW85RjRMa3Y5QmxzWEtyUUtI?=
 =?utf-8?B?a2hIeWJjbTFhVEhGbDJ2RWFuNG1WZjdDeUR0bDlJUkpRVTc3dTFOT2ZnQXJB?=
 =?utf-8?B?a0lIRk92VlVvTm9VUDUweEtkUldzK2dva3cya05CZFJzWW55bHg3UG5aVExL?=
 =?utf-8?B?aW5EbnE5Ynh6QXE4c1lqRGFiK1R1dUs3ajlVWkI1UGZSZERIbUM2UncxR3dt?=
 =?utf-8?B?QlQ4TjZOUkJjS2xKcG1TZ3NIVy9qcTdDTVR0b0Rkc2FXaHRCbE94VTh2bW1M?=
 =?utf-8?B?WVZUWENmQkxrZUc2NHhEV0cyRmYvdklnWlVTZDkraVZLMUhKcHRWcVc1SUQ0?=
 =?utf-8?B?emFUM2NhdVVHa05PWERVcGtJVkFkb2NVRkI0UUZvOFZjamVpUVc1VktqcTRi?=
 =?utf-8?B?WDUydkgvcEVESVladlUrMEN6NHNtT05ndDN3cW1mWFptYis4OXNVQVZ5bFNK?=
 =?utf-8?B?MlBZR3dzeU5HQmVKTC9KeWxqMVNvN1Vwc0I0L2U0R2QxTmV5MjdJcEw1YTVU?=
 =?utf-8?B?UzNRa2QwSlJPUmN6UXZXK3RIWGR5NDVReW8veW5ZLzdHTm1BOFFTdzd2czgw?=
 =?utf-8?B?YVIyUklpQnA4NjNWVzk3bnFzdlpTOWFDd29SeFMvSUZWdFhUZnhZdjhkUWUx?=
 =?utf-8?B?WlU5cVMxeXN4dVhIZlU0T3RiaFhmNnJCeFhqcGMvM2pXWnZXMk4xbStHQ1JK?=
 =?utf-8?B?Uy9VVHNBNUV5SkJ1Zlp5T3Y1STVaN3pZS0E5TlRIUlRPQ2hrcXhSS01odmVK?=
 =?utf-8?B?MVZidlBVcllaQ0ROZ2hUbEg0YjEvam50OG9lQVlYK1ZOTDBTbEVRWnlUSWZ3?=
 =?utf-8?B?OFZPWkttUlkzalBQZ3lsTkpBb2hjZGU5SzZaY2FnN2dGeDdKRDVQVGNYeUZ1?=
 =?utf-8?B?cmhTNzVvWmVtdC95NFdhMy9mdU5jQmlXQ05QQXB0clJqS2pOSWZ0S2FZeEMr?=
 =?utf-8?B?Q21qYmhyUFVzMElxdEtySWhEMTZPU21MUU5uNVp4T1RvZUZXR21MYWhnWGtK?=
 =?utf-8?B?NG1NTThvL3oxWUU5SzBSZlJiVGFuM3lCenZpajl4Yk9NTUg2UVdmR1QydHJX?=
 =?utf-8?B?UU01Mkg3a3MybVBTcFJhbmNWUG9Gb2Q3ZHRCa1llNkE3ZkRVR0pac01iZ1Qw?=
 =?utf-8?B?cFYyYmhrVVhxeU5hS0lWNXRKZFZhd0FMSS9FVGpVMVZ3SXNTRzFaT09QeENR?=
 =?utf-8?B?Uncrd0FQbWw1TGtPZTJLak5MeSt6V09DSkFEa3loM2lNR3NKM1IxemdpOWtj?=
 =?utf-8?B?bHlDY1N5Z012RVp6SjFUSGJLbEpaMTNJMnJpMnA2dUVTMDZ2NUdKd3VCbGVt?=
 =?utf-8?B?aTd6OUp2a2JuZjBmYnhseUpRRU9Tc1JudjQyZTh1d254THphM0hybWZuTCti?=
 =?utf-8?B?dTN1TW54eE9DeEtVQjRJaVo1cDB2d0t5em9jdVZpYUNyYWFVWndqK3R3eUEy?=
 =?utf-8?B?NGFIOUVjRFEwWW1icGtBVGJmazd5ZHorbUFyLzYxU2RIelVLMDlGYjNVT0tI?=
 =?utf-8?B?eWRJSjRpTkIweTl2QVU2UE05N0syRm5BUk54Q2ZEb3ZMdVZPMVpyQmpaYkls?=
 =?utf-8?B?SmxlZUhLWGd2QnFPenVJbUhTNFh1bUxVelMxK01mS21mQmc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWJSdk9Eb2dadGRJdCt1VzB0dnZlMVM0LzZMcUdjNk52TUlvVkxzWGlTeHAr?=
 =?utf-8?B?Nkt3QStTMEUzc0xSOE9zVFIyNkNPUHFmTGxoNHZsNldJalp2ODZTTFdXc1FT?=
 =?utf-8?B?VlI2dXRka2trRWNyUytSNTBWemF3dE1TVGJvWTY0NEpyVy9aSlZjcTFKVG9Z?=
 =?utf-8?B?YmVtWC9aOU9MVktSaDZyUDJJSXpDOEx4Q0Nka0U1VHdwYWcrZkVxdm1Ra1V3?=
 =?utf-8?B?eGEwTmU2QjhkWEN4SlhWenZGZysvSlBtcmEzY1dkaUVLUWNhaWc1UG1DcWxR?=
 =?utf-8?B?bFJWY0ZGRFpjeWhwNG9wWkJTVXZPclJPYmVUbVlrR3d3NzJZay9QenMxNEdG?=
 =?utf-8?B?Y1BRVHpBNmc4TWwwamxRUXBodUszVFNPVS80dWp1aHhGV29LRGg5OUJORURk?=
 =?utf-8?B?ZWxiY2laL3NXVFlZTHJMazJnRWRPMWtnRTlOUEYyUmVxb3FjRWo4MTBqN0do?=
 =?utf-8?B?WlRXSkttWWo5MENHVUxiNkJKQ25uMXlta1JqeFNmQnRnbzZsWkhwZnFwSXhK?=
 =?utf-8?B?eFRBNGFzSjkxV1gvQ2ZNWEp1alJ3amV3T3NEQ1Y1UGdxb1BCK2dubCtQc2cv?=
 =?utf-8?B?eHdTOERWQUdPaUE0dGFORk9kZ0dSZVh3NnFvVkFiQ0RYakhaMGlaTGlkSkcy?=
 =?utf-8?B?TnFxR3EwL2tIUGRhWnRZNWNBR3BDNEZHRzdhOWtCRktxNjZ1UUZXRWRrclZa?=
 =?utf-8?B?QjlSTkx5QUJlcmFWZmFKUTdQbmxraXZjUWhjV3RNUlJ1cGM3VXNGWEZnTkVi?=
 =?utf-8?B?RE5BSm40ZVVYMi9lVVV1MGFSM3Y1QitVSktUSUFHM1c1QzhOM2ptckVPeHJP?=
 =?utf-8?B?OWcxaURvRk5xaHczV0lTTm4yUW94aURWRGlXODg1RFZONzZMSmthNU9LUTds?=
 =?utf-8?B?Vy9FK2FNMlRkM05TVVNqSnhhWUhGV0FmeEhHaWloNjI4bzA0TExoQmhOTnFW?=
 =?utf-8?B?QUlnWXpVb2ZsMGdCOVYwMmN2WTNrT1NHMzRKb3BkOFh2ZEY3RHRvSDRMY29m?=
 =?utf-8?B?bUYwcHFFYlFhZ05FYlhvc09GUW16WXJRbEpsQXd3OVpCK0ZHakJCMUpSMHZs?=
 =?utf-8?B?L0lqcElWU01SdG03MjdYMWlXYXhyNzhHdjJGVjEyeHhJUStjcThYVWdweEhs?=
 =?utf-8?B?aFc4emk2VFBaR2ozQVJvclpEVVcrMkMwRTF5dDVpNGlOQzRuY2MxQXJKdmFR?=
 =?utf-8?B?dC9ZZzZVTGV6SktBT2hIU0xybWpTVDY0bGt3QmUyaW9CVjFteTVLSUxrQ3Iw?=
 =?utf-8?B?cUxwWG9qWEFDSFV0VFdubUNmQlpMbERXYXVlcjI1SDdBSGZYN0lnbmtuNncx?=
 =?utf-8?B?dWtzenlESUhGSm5kWk5pU09TSllET2ExMDZvMDhBaTU1d0lxZG1kSUdPQTRz?=
 =?utf-8?B?Q2FOTWIrMS9IcjZmeTJpMGxKZ2ltY0JCalpHQ3Qya0RVdVFWd1NqSzdGWS8v?=
 =?utf-8?B?WlhqLzhvdkc1U0k0VVFIczRIaUFUM3ZXc2gyVDJhUnIrQU45eFNKdmFqUjBH?=
 =?utf-8?B?dVAvK2t0WWFUWnppRDVBc1VnTDQyWWMyT2Q0RytOei9keEJGb3ZlWVZvRlFw?=
 =?utf-8?B?dWRSN1V0SzZDSkYwMVhrWC9mTUJLSE5uOTlrY08vdnVwSFdJL1hDS2NkME0w?=
 =?utf-8?B?dGs1aTgyUnZKVmVPYTg3bThRNkptUUMrMmxXcU5ZTGNITmVva2ZJWktlOERr?=
 =?utf-8?B?UTE0WS9lSE5lWTZjODk2MWl0dWIxRXowRmR1d3ZaWE5zeVBZRVlHaVhieDRC?=
 =?utf-8?B?clV2KzJlUDlFRDVYYUc4VUwwVkN4dzA3T1F3N09VUHJGVXRQbGNzZjFadFRG?=
 =?utf-8?B?d015UTVhSjRDNmg4dkRwRWZ2THVRaUdNMmc0MlVVa00raWllN21WZWV6Q3Z6?=
 =?utf-8?B?dUFoQ3IvK3R1VVg2cFJuUEljaHlHMjZndDU3K0V2NXE5dVp5SzliV0JGcmNJ?=
 =?utf-8?B?bGs5cE4vdWIrb1pRRjB1UFdtTHYvUDhOakxuUjUrL25UWk51QlArYjIrckUr?=
 =?utf-8?B?UkkrSUNqUi9Hb1UvYmlYNkJsMDlJYWhLQnpOaE9FT1l2NWlTUHNmNE16S0VV?=
 =?utf-8?B?czBpSTQ3cVR1ZzhVaVBSWkJFOUFHcThRSGdMdzhZMUNKYWh4aDQ0alNnV3V3?=
 =?utf-8?Q?Vt8bRlYR377xOuRgJYVbXU3Xw?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K7Y3nJvZ+nONEigLUIZTeiC40DHjdcrWm5Y+Fn1E5jHVsPmEIIkAZBNmx2OxTAhBGFMCZTUt2+5m2fCSxNZk6zhF6uMEjuLmvWcYczNvbDrsG9KkQpvc4DjFp2XcAzsXzfeXK+i1drBJCLE3Eavxcm4dtXndjGfZwUquE3F5L3qyk2cmcJ2Xlkk/OrEB4osnPPN8N3MKzM8U/Yq6vSFDQrivWzw4ZuIP06EG2k9WOYYH5F8H+//woq6s/KZ6lGWZGW9Wl5Hv9pQ5zEYIBSKERcCejKJVILBeIJbSElMIyGvMtNwBxU5lhzprkdMbFaY50HSpKLIKL5D/6S1umVM/ga+8um5OdFlpneh3Yxz+rnm+txZQStni6K8qJUi8VaDMn/3Fv46wQ9fRIecFPSgWt9jDCFflBOO3hJSaIs3lllBofitDOwzWTcBAG0T0QZSeAfEp8T4t5nVPlUE3LytBVLAZWhNh/FycJ4BhsOJcrWsnMO4vj9hByaRnAgd4SZpdYruvmGCtdn0qA8yN8KNgaTSHgFYhZFxjgG8UpweoaNSuaKwZ2hnooXrfzZN7scz4QF7vFotDlR8YB/HVXACGZOt2EwoEwmgNovZaGLfjJ3Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 525a1306-08eb-4e9a-9437-08de01dbbc3c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 17:47:20.2609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f5S751RUuqiZkBBH3CcqzW7jVbRGytYrrKF97H8hq/9yH/4gZN7WdiBQu27Odu9kOE6cfCK5BDzdnXh4kU0D6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5953
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-02_06,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2510020152
X-Proofpoint-GUID: JY2L6xlbR5UAwlq1dMaOMcr34eu0sm9P
X-Authority-Analysis: v=2.4 cv=GsJPO01C c=1 sm=1 tr=0 ts=68debab1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=NEAV23lmAAAA:8 a=edf1wS77AAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=IdymAyYZYteemNvU4yMA:9 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 cc=ntf awl=host:12090
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE2MiBTYWx0ZWRfX/Lfw54hV6Lwx
 59GnPiSZ8/7DQCgHeT7MB2TAjAtfLO3XIlkEZDdMCFzgdsHMYViaGpp1vcus87JiPiUzDlN3Yvl
 uq8LZr2vBnXMESWiljm3OdsAYGS6QYiNpgwuNrKJCo9hOkLt4e6YgXMdqHSeEVIS+SMZg22kwe7
 wFhgta3M+NnZViJuCs6RT2pOswPSBt12v7Ef/pDej3RL4QKEZlO4+8MnLVr6Ao0t3gfWTU9iDuS
 hPdCNG5jADFMhhNGVnY0dgjrPd1r0jAb9K9OTXx+w9e/5rwXqDCT/DhBOaYC33nLTH3sT772Ea4
 7I5sdLz7DEmr5A8KtmW9qatSGdTOFzmEvuWxOoSM0hSrhXKlZg4r7Zf9ljoIRjFs5v2QW7CiNRK
 xTDbrkyz8xM4huXPCPEh05XnpsGvgpPkC3AnBJvfCQqafPBTOAA=
X-Proofpoint-ORIG-GUID: JY2L6xlbR5UAwlq1dMaOMcr34eu0sm9P
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 07E2320016
X-Stat-Signature: nxpfokjcuq9ziyjqqs33butjk5ghm81r
X-HE-Tag: 1759427258-389375
X-HE-Meta: U2FsdGVkX19JRvfQDGOYlExGqUAvsiQ8zjcNri/xny+hfvLEcXjH+WkDfVcuMlbR0SDMFVmeDs4YrbkxO2vQhc7GeT3YGIrLyQDhWcL3oy2N+p6DRBva7h0mPQVPN24MlDdKNoaSBF344iiFa6eJ0n3uyeweYDMQJqXHT+EMn6qVz64OF0qBzJxYhS+PCVyDV1CbP7oIlyJs0lNrcdb9x0YwJ+e1uwcBNL4P0EU87pzWDAh6mL8fBI1mqw2uYPIAuibWjEwSDEyDkUpCaYzZkX6/kf7F5yIfea9dSsLQwhQ+0gYR9CimjwkCLZpLpLOgtK/7CLNKFhYzNF5vxeatux/qAfIvdsMjQVFdOu7Oua61ZYD8IEAivm1PG63kgc1B9+baGBVMFHuR5xP2/vyPZqVoKeoeC+a304qlziG5OUzMUFb21+TjUxbUdRvivJ+ftjkFE2VyGplqg4/z3Eh1FGB8u3Y3khTEWtLuqOR4+vVgA/1lu3Iwu7DxY1jj8TzJ6RTmcW3FAt9VKNU42J04fvCGD7TiPWeiqgT2DPJ5uuyiZXIwxHEtsPOylIZwOELPm6F1Cix+QsUeXbsltLU+JjgJAyhkFHyf3KzkQjb6bF8DqtHvwDx2NpRuMuVOdcOWb3O/eYlqEyF+U68UGchx7SsBQuz8pSHjisItxN8A7/WCUmZ+G6eoSBWOTbYlaeOR7BFMvM1caeYzpm1ocsUB6CtGO0oKo9L8Mw+e5hKzzGKDRABxOwNZm459zVcxWCiYaOkmwjwepJUqCbPrZ4iOE9WJOimVc19PHqrzFUmFXGanXyyLKn6U32XnVQ8Du491RLPQN9IdtqMfn9/RBqExJZ7Et+XWGKzaxT+D7uI0gK5xieM4PLbXzadwF4YkfWrQ6wOIrXHnqtJ3DYj24vdbhLSiCXFTaALtrroMvtmlYMWm8j8HRjoX8a7racpStb7LJ3AF+pLl/hCbxgJ60pP
 HmkqdeHX
 liCrhCSAQejDzIQyrJ7+LDvKHvhTdJ0OOtyFTdoJxqjtNXuxlDi0ItyZG5C7G3j3PD+WG888y8/VvifejPBdGONHXuJbWVHWQTlt+4qF3625C/iPbgOj/z1/p7kqg07KK+AtNlggVEDksOMXoy3286q3y88tFM3ukaVhJFtI945lT3/ye1y4PIKWCgYhnBeRLVkEGoZDsDwcY69st5vhaFDd28+DquyOeY1jlL+sth1ndz9FLyIIWANmZRyHTmZ0QXl/K6NyjjCTRt0Wlo/8at4GvWvjZb/VloYAHx3Hqo/FyhGTzMtur09Rh0MUilSLP3+pT2Ye+tbBSbpPZ+jrGxJDDFJrtps+VRV58mNZDB5rDMlYopZCbqJ9LccWpE8jYQrFV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/2/2025 6:54 AM, Zi Yan wrote:
> On 2 Oct 2025, at 1:23, jane.chu@oracle.com wrote:
> 
>> On 10/1/2025 7:04 PM, Zi Yan wrote:
>>> On 1 Oct 2025, at 20:38, Zi Yan wrote:
>>>
>>>> On 1 Oct 2025, at 19:58, jane.chu@oracle.com wrote:
>>>>
>>>>> Hi, Zi Yan,
>>>>>
>>>>> On 9/30/2025 9:51 PM, syzbot wrote:
>>>>>> Hello,
>>>>>>
>>>>>> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
>>>>>> lost connection to test machine
>>>>>>
>>>>>>
>>>>>>
>>>>>> Tested on:
>>>>>>
>>>>>> commit:         d8795075 mm/huge_memory: do not change split_huge_page..
>>>>>> git tree:       https://github.com/x-y-z/linux-dev.git fix_split_page_min_order-for-kernelci
>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=17ce96e2580000
>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=714d45b6135c308e
>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=e6367ea2fdab6ed46056
>>>>>> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>>>>>> userspace arch: arm64
>>>>>>
>>>>>> Note: no patches were applied.
>>>>>>
>>>>>
>>>>
>>>> Thank you for looking into this.
>>>>
>>>>> My hunch is that
>>>>> https://github.com/x-y-z/linux-dev.git fix_split_page_min_order-for-kernelci
>>>>> alone is not enough.  Perhaps on ARM64, the page cache pages of /dev/nullb0 in
>>>> Yes, it only has the first patch, which fails a split if it cannot be
>>>> split to the intended order (order-0 in this case).
>>>>
>>>>
>>>>> the test case are probably with min_order > 0, therefore THP split fails, as the console message show:
>>>>> [  200.378989][T18221] Memory failure: 0x124d30: recovery action for unsplit thp: Failed
>>>>>
>>>>> With lots of poisoned THP pages stuck in the page cache, OOM could trigger too soon.
>>>>
>>>> That is my understanding too. Thanks for the confirmation.
>>>>
>>>>>
>>>>> I think it's worth to try add the additional changes I suggested earlier -
>>>>> https://lore.kernel.org/lkml/7577871f-06be-492d-b6d7-8404d7a045e0@oracle.com/
>>>>>
>>>>> So that in the madvise HWPOISON cases, large huge pages are splitted to smaller huge pages, and most of them remain usable in the page cache.
>>>>
>>>> Yep, I am going to incorporate your suggestion as the second patch and make
>>>> syzbot check it again.
>>>
>>>
>>> #syz test: https://github.com/x-y-z/linux-dev.git fix_split_page_min_order_and_opt_memory_failure-for-kernelci
>>>
>>
>> There is a bug here,
>>
>> 		if (try_to_split_thp_page(p, new_order, false) || new_order) {
>> 			res = -EHWPOISON;
>> 			kill_procs_now(p, pfn, flags, folio);  <---
>>
>> If try_to_split_thp_page() succeeded on min_order, 'folio' should be retaken:  folio = page_folio(page) before moving on to kill_procs_now().
> 
> Thank you for pointing it out. Let me fix it and let syzbot test it again.
> 
> BTW, do you mind explaining why soft offline case does not want to split?
> Like memory failure case, splitting it would make other after-split folios
> available.

That's exactly what I think.  Let's wait for Miaohe, not sure if he has 
other concern.

thanks,
-jane

> 
> Thanks.
> 
> Best Regards,
> Yan, Zi



