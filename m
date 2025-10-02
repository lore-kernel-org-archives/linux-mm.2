Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E18ACCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 17:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A8748E000C; Thu,  2 Oct 2025 13:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47FFA8E0001; Thu,  2 Oct 2025 13:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347EF8E000C; Thu,  2 Oct 2025 13:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2FA8E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:54:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8C1713B51E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:54:32 +0000 (UTC)
X-FDA: 83953923984.20.494BFB5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1C6C94000A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:54:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EgmHZGBY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ENjwOYbJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759427669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aRsOvVGONcBXQ7d8Qu7UVknFjNTRf8B3RD7U9Uj+miM=;
	b=bvbEgmmcFM1gQSThm3G9iHRJQPfYUoRCTbeN8JSH1WDTTqXoiwsEIQqE4q7wvH0bAdl/Zr
	ch6rMQsvHKJ3qSctaMXM28XyYcS+aQ1MOl5U9PdwShOyaOjWRlIrvILSNcB1v+QdmpA5vN
	zKAHb98JwJ2w4jKBIrdNUWr8nw1SSJU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EgmHZGBY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ENjwOYbJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759427669; a=rsa-sha256;
	cv=pass;
	b=tE8e4pkH5KCClLV1uiukP77lrIizLfwt3fY5mo8LSbHq4Q9fzZiiFA7dgdXw8rw/1s7pnq
	+nR5Vzlk/5gnu9ends2cS5ai1nbOxMg86+A5kI35aJ1vA1dp/QVgXJWgmfvzE9KHNkZSmU
	dKSr+cPYICR7+1c+VwzVkeCZl9Qw6jo=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 592DN0Eh001264;
	Thu, 2 Oct 2025 17:54:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aRsOvVGONcBXQ7d8Qu7UVknFjNTRf8B3RD7U9Uj+miM=; b=
	EgmHZGBYX5bmBdNkK2DvaFYKsXbZki19BH1l02sE5frId/3NIly0GNXdBz8DasLk
	zozrGeS8th1zRsQiPr/kY9VLIsa6pLuCKiNVzMf7+Q/Ry08ay+MsITVLkgjsO3Tb
	dVGgl/apTZacLA1y0AmewBwWNR7FiACv3kC1U/P8L/RYohVSw+in1T+yo6zn4FLg
	2zyhsFs8bpGA6VJoPC8sxBuClc4Vc/WrxsuxLQBTun/PirlQP/mibRYtBNQEErbQ
	mcKe4I+aGON5ArvNz/Tm4BfccQYA9VrvjD1BdEnXWCCFf+GVDIg2D7IhpPfb6Dx5
	9OKmhOXRfNav+hjCwPX3dw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gksxbw3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Oct 2025 17:54:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 592GZE7k008978;
	Thu, 2 Oct 2025 17:54:17 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011012.outbound.protection.outlook.com [52.101.52.12])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49hw1x2kjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Oct 2025 17:54:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BxChfxicHVh3NWLE1MFDb7zeRDtaoqMKWjJYKIV16crhYkVxYNPE2dOVcwIKRU+QdatX75heeBlJs2/mHPVxfWgiVNDy1BvFIpQiqDQNmM4OyrzjCY1w0ZLdUoHw4qjkP/IecJmMhhG91eNN6Cf//ClM683HJME2tjRN+O/8/0Snvn1fsIsV3K0KM+VgrxBcfYg0XNcqnnh8gCUzvKMXCc3yhmQ1gWhYVWdBB4GPM+z8A+mRIHIdNMMOXIa/HvKeyP28BQkNMsm0q0YgQ36MmL6x6ssGU/G6gYHuhgMslwItqAmBh0m9aMYNC2+0mY/uMGilzw7ImACxWODWgPHFvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRsOvVGONcBXQ7d8Qu7UVknFjNTRf8B3RD7U9Uj+miM=;
 b=hocUFDl3J9bG9I/t4Y3QFZZIHUs9F/4fwTzQSqrwoDCWwhVDuwtq0tpam4ufp5Ktux29cuCY1AdwbEc/XfhD9994xC2KCCf8Mmcx3oGzfa98E6OgDF70kiwKxL/PZPADj53v63hK7FZI+mF74nDi1NnO5PrHiwOpY52yhw3aWjPt89c29ZkB6xWEoVe8gnUhtHn6qnW4qYSUKUTuvrRbwQUZb3kNaOY2jL+Ap2dWcWYKcba55ISIy/H1WxD/19Fcgzjx3Y0WfWMYEai8O0cNSGqa6T9jCOqkaPLBpmHwKGZFx+jgtHJZiKyHHctxKYyBBwvfbK+4AnhybQfao6YluQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRsOvVGONcBXQ7d8Qu7UVknFjNTRf8B3RD7U9Uj+miM=;
 b=ENjwOYbJnSRu6eWQXeBzbBDDSZkcifhw4L6Cg8j/XlbUKeFE4eQ3ZaFIrE+zUI0Z99Nli2mO91WLubOqGMj7noBOVmDhQRq3MWekwr6EA7nAiQSFYIUIRqO0R4npVD0oBbGcvsnaFfqWjR6/UOInrcdvNOfrRuNujH7gGemEfm0=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 IA3PR10MB8298.namprd10.prod.outlook.com (2603:10b6:208:570::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 2 Oct
 2025 17:54:13 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 17:54:13 +0000
Message-ID: <d60770df-a967-498f-9e0e-25a6a145ff55@oracle.com>
Date: Thu, 2 Oct 2025 10:54:09 -0700
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
X-ClientProxiedBy: BY3PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:217::6) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|IA3PR10MB8298:EE_
X-MS-Office365-Filtering-Correlation-Id: bbae323f-0247-4bb4-cd59-08de01dcb2b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bk5rOG5pT2dBcUNJZytmL0Y0TjJSZTBpUndHOEhCTldOYU5VckZ2QjZKU1RF?=
 =?utf-8?B?M2RTSVhYMGdkaEQweFI1WUpEK0ZsOGNVU2pUVUdyS0tQTC9rK21qcldQTm9r?=
 =?utf-8?B?aHlyaDl5ZVN3TUVac25ldzQ2emlmamttV1laamc4QnlSSVYrMlpGRURwcXNh?=
 =?utf-8?B?UklNQzFOL1lnUFkydjBHYVljbm1nMm5kMVlTV2dpUi95eDVVa25KcW1VOFZT?=
 =?utf-8?B?Mi9qamcwdHIzNmZ3OVpGUEx3ZkRvcWd6WHA4NWVKUFlLcU1nSHhKMlpHeDZQ?=
 =?utf-8?B?d0pLYi9OY3VKNnE2ZHVKeDFrOHNVQ3N1YS9ncFloRkRrdzRLRUpjUGR6bFFl?=
 =?utf-8?B?akZaZnU2T2RGZjFkYkdDYktCYVBPZWRhNmhwVUtQQ09Sc2hMS0paV1RoQUNr?=
 =?utf-8?B?Mld6aFM5N2NuWDB2ZU1CV2wzUzYwamVDUkhsT3g0UEVUZDBOakxGL0RCcnpW?=
 =?utf-8?B?YlhuTXluSURGMnVRWThhbzRqSlR3SG80aE0wQURIZDBsSjFwY1JldUdLbTcr?=
 =?utf-8?B?T1FaUkd1U05raDBuYVhoVUZxL1JYMklKeFpZcnlNNlp2V0VJTUQyYmZlOHhE?=
 =?utf-8?B?ZzJrckIybkVuVm40eG9TYUF5LzFpRTRTUjVTTE1BMlpqbHVkbUxsWm1ZQldD?=
 =?utf-8?B?SXhwYW5OSERoVDRXQ3dKcitPYzBiRnF5VFgyK1RCNkk1SFY4dHlPSlFLdDNu?=
 =?utf-8?B?eSsxdGV3TUpPNCtpNWR3Y0dxRks4T1FURUF2dzljMlRqdVhlRFRLRWVqYjlJ?=
 =?utf-8?B?VlNiK2RCaWxRZnFVdXk2NFMvS1ZvajM5V1ZwWEgwM25CUGhLYjhObUIzNlBy?=
 =?utf-8?B?OGZ2YzlSWTc0SmZJUEdRWDI0Z2dIeDJxMGNxdDJkMmhySWoxWUFwSXN6R2Zv?=
 =?utf-8?B?RVIvdUpqK2NFN1NMYjFCT0ZHb3lLR0I2MndWcm5jd1Z6YSs2cFRYbWFZdHhv?=
 =?utf-8?B?MmVQRENHMks4Q2Q3L3YzbnB2dWs0c05OclVGNHFFNDNqc2pEeko1dHllWFFt?=
 =?utf-8?B?Rzg5K04wT2R0SzByakJPMEtRdHhzMmhrR3NuODVWejRlUUprSVZLckFHVVBB?=
 =?utf-8?B?Qi9xZis5SWd6bktORE8yNmZhTjNEWDBBaTN1bUFYYS9Ca3EvNzk1cjFLV3pW?=
 =?utf-8?B?WE5tNk1sZVpsSTdmZ0xrdmJTcVJSVW12S2ovZVhZSlBCZ0lKcWJlVjIwYTVJ?=
 =?utf-8?B?a2k4YlRxanJ5RUppTTJIeUliclhNS2ZoYVlQZkJUalZSd1JrK1VQU1lwWkRt?=
 =?utf-8?B?V3VSVXhUbmhxYTkvSk5hTGNMNEJOblovR2xFTE0xZk40S1FsR1QxQnRFdmQr?=
 =?utf-8?B?Y1lETyszWUlTS2gzVUZrZnBMU3V4MjE3Y2puZkpEcXIweUZhK2QzQ1ZNS2NY?=
 =?utf-8?B?bjU5Mk5xVS9HZmtyQzA4eHZ6bkRrUnh0RkNKSWNrUEQ0bG4yNU5Ia0VodC8y?=
 =?utf-8?B?eUtUbEozQVovSWRPSlpiWW1sTWpPZDRnU1ZxMjdYNDNldUk4REVRM0tiKzFG?=
 =?utf-8?B?VXNscE10dmNiaVNwa1VsQSt6UVNjZy9vczZlSGhYUGhFeSt6b3ZyVitreG9J?=
 =?utf-8?B?cWUvMmVxZkJuRG01RTMxMHNIb3RSazRMMlgxTXQ2Q3JQY25LN0JTb0VuMVFn?=
 =?utf-8?B?T1k3cFhGNTErRjMvRllSRHBPcitPeVRzc3JnNW1FMWpsTnJLSFhsd3pWU1JV?=
 =?utf-8?B?TE1zREtJemNmRGl4V1FQTFhPdVNuN3RkRUkzWGNsVHpVeFNDeTgvYzlGWCts?=
 =?utf-8?B?dlVSMlVuelB1d0hoRTdCK3lUZ3B3SkpRNnhFeTlLUkY0c3RJSmQ3NnppeUd4?=
 =?utf-8?B?RFBvbVpIbGJEODRrd3g2ek1YTHphcjV3dHVvVkswUkFqbGMwd1ZhRXR0cUhw?=
 =?utf-8?B?WFhteldqQWxVV3BjcnRzdHMvNU1vMmlYYkJHaFdzbGRrV0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dE52VWttd01DbGtqWkNLSWJjd3NqTWcvVHhlSktFQmZkMC9seld2eDA0elR6?=
 =?utf-8?B?eUhhb1RKbGdBSXZKMjBna3RiclFSL0x5WTgrQWVZZmRETy9lNXYrcGQ2bDdk?=
 =?utf-8?B?Szg0azFyL1FSckNQamVsR040NmJCUkYvZUd0d0JoNUxEUk9jODVKRFdaT0Iv?=
 =?utf-8?B?L1QzMEd0SHFkclpZVVJqVzNPTVZrYWNQelM2REorWCtZbGdGemVpdUNOVjZC?=
 =?utf-8?B?Q3Q0R0MySEp1dkV2Zm1RRFpSd1lnckg0RlNKTTZiWUR2ZUdLM3g4bmFsUGVu?=
 =?utf-8?B?Z0dmWkpybTBKTUxWUU03djVEVWJ3U1BHZFJoZXdsWmI1RE1FbmgwNEVXUXpD?=
 =?utf-8?B?Vlg2T2ltRVU0WVhNeE1hcWFZU0hGcnBvMDJNSnFxaDZMSEFLMDF1bkpuNG8w?=
 =?utf-8?B?QzRjQ0JtVW5QZXJSY1lwc0U5Zk1jMjNhRlZ5YjN1bVp0ZHpUY1BWMjluczVk?=
 =?utf-8?B?Ujc5NFN3cHZiUGE5cHNTRzhtWi92L3M2MUZDRm1qV3MvSzlGQnpIK1FwTWVh?=
 =?utf-8?B?eGhHL0lQUW9LZ2dzbFRuL25FeEN4aVR3UTZiekVvOVQrZ3JEb2NVcnF3bFUy?=
 =?utf-8?B?RkZGWFIxT0ttTUxNcHJINXBuVStrbUtTQWhCSGtoUlVYOEJPSVFDaHJKWG1m?=
 =?utf-8?B?VnBES29yRnZZNXk1NGYzbUpaMy8yQWVFOFJSeG1CNXFqblJlOEFYQVdDZTk0?=
 =?utf-8?B?M2xuQk9FVHNjSjJlK2lKckxVUEhoS2VaeWhzSHNRS1N2TmxtTHVvQlBiNTg4?=
 =?utf-8?B?QzVnb1NZclFqdDA1VStSQlYvY1drTDBQQmVhU0QvQWN6UmFibXhxZEUxZk1q?=
 =?utf-8?B?NGxwRy9LOC9xY3pVcHR6M0piTTVOeEtSQmRucVY3bVRodnNXS1JHWjIrblRC?=
 =?utf-8?B?REZKTmpDVDZ4SE9NQW9KNUJLeEFwbDlIRyt1Z2I5WWwwVjNCeVBNRTIzb01a?=
 =?utf-8?B?OVJROC9nck1IcFAyQUZRSmxsNHgzUWVYRk9ZUWcyNFRQRFRBdG40RTdHYlVr?=
 =?utf-8?B?bWp4aGo3c1EzMnVXRTNidGI2dFlhb28ycXVnTm1QZEtVYmg5UVRrS2M5cTdF?=
 =?utf-8?B?NkV1TERuT2pLVGJMZnZPbVpiRitjaVQ4S1RWVDlhTTNRSVY5amRhTmFrZ3Rt?=
 =?utf-8?B?aFJHSmtXRmZNSTJ3VGIzdms2MEVBYjB0ckw2dFpqV3I1ZzNzcFpxdUEvL1VR?=
 =?utf-8?B?T1U5RlBic3R2eTBFNUhYSTFOMDJ4anViU1l0Zy9JbFdjTW96Q3VUeTVqdWR2?=
 =?utf-8?B?SGVwRWpvWjFzaEZMYUErMmZIbWc4V0JlNXVPQUM0YlpwdzNPZVp2RXBoN2Rl?=
 =?utf-8?B?Y3BQQzJDYk93cHpoQ3FaWmhVMS9mWHlQT2RMUVU1K051ZnFFR2pGZHJSYXFh?=
 =?utf-8?B?YWk1SkVUb3hxZEJJNmp1TkxIV3oxLzJxdWlOWEdLcnZhTXh4N0pZV3dVN044?=
 =?utf-8?B?dndHdlZ0d3dhWnRsSlBUVUluT2VTaGY3MGxIYmF0VVVEQ3dNZk1DYTZMOHlu?=
 =?utf-8?B?VGFoNEFkL1dXalNNSkNhRHpoMXk0dllhUGxBY015NVlKNjg0UGwrUGZuQXZh?=
 =?utf-8?B?RjJ3MFJYN2k1K1FRT3lGaXJFeWNsSFVZQXpxTWdKMk8xSE10SkZ0MEJsQ3kx?=
 =?utf-8?B?NEJwNjRZZktHQ1VPRWp6WlY5WWdFNCt2K0h4QlhTMXE5THJLaFloRmVOc1E1?=
 =?utf-8?B?VmdVSjRkK0o4bWFyK3hEUnJCU0dmVTFtNnU4dUliZ0I0OVZSOU9KWVhXYzdB?=
 =?utf-8?B?MFFFNmlybDRzd0tXV2k1WThwTk1aOWFkK08yVU9McTI3b0w0aXQxbnN2TVJ0?=
 =?utf-8?B?TEhwbjg0dEdtWEs3TmNvbWg0SmY2N1ZYS2lRUnVtRzFPN2VWL1FmNkFWWkM0?=
 =?utf-8?B?RVM1S0dIUGdNb2tqcEtGT2R1K0JRandlYnJIN1R1TmpCaDlTampvc1BFMmdP?=
 =?utf-8?B?MkE5dlhCODZUOCt0eGl1RUwzUGY4c1gwUzc3WnFkdHhOQVN0T0NENUEyMmlu?=
 =?utf-8?B?TWZpbGdqQXhGbXdmUXVNaHZaN3piRkNsWjJyOExzL0JBQjNMeWtVeXlnYlhY?=
 =?utf-8?B?MUMzaTV2MVFmNFI5aGVKOXhCQ1JuTGQ4UXNlbndTeWdjZVFjMXc4NG9CT01p?=
 =?utf-8?Q?wKTqRJGENbrHUvpQcKZQ1tV82?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g4bAdpy8Wi/oEAK/3F38bW2ZnLiupQ/JsdWkPnVm91TaZ6XT9uWiE17zliZBe/qQXjKaBm5Sj/FyY9T5nRukHHNZQOew5Fuakgnr/1OnuVUWZAIuJSbOGgNJno6uvoxvEJqg62z23YdcxKLYVb30TD4Z4nT0A8TT+X4sWVAzzoGXTTbrijGhPe07eUwXUA/amOZOGV+/VJMLwdkWs26XOBJIoOb++QYcI9qBmuttmn8MK15lZFeZcBthfrvskYRLCJQPEQr7mg0p00Alt3zBUNNs23UpFgJQk/QZ2zgJdEdfYQdEfNYxG98RYhWio47HeuxOFvHXDZTarsvruo66moNUxZjaX8+Kuyck7jwGLGARzoruomrrA9fqPqJ0Tbo2Xpq883mkBvWA2vxWdD6DjqtK9RsHhbg3T9udYb0rjg5X68cgpjHuypIXE6AKSnqGhTMFMPyLirHZJYSeqhoT+Mnnd2hGUNyVrEFUbkNaoIG0ndATaAz/M6MaaNsHNzWHlqJlJ1DqPNm8TpzNu/h1RDPMAdVJ+WA8q3OIA74BOrDxPd2A3Q1iY7WfEHgo7rSEzyc6ryWo3tSRgSZFATVXcrJ++xtVqJA1KsSAKq0uCg8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbae323f-0247-4bb4-cd59-08de01dcb2b3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 17:54:13.7406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXeH+w9HerB4wPkowQWQLgCYAnC97WN+D/9RtckbvcS9zzSeW0GhaheofVFUDCcN6y0X/gtKwgvHF9hEaCnHgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-02_06,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510020154
X-Proofpoint-GUID: FTNMwbUlUVdTaZK2xKlX3SWZJKiNSWUK
X-Authority-Analysis: v=2.4 cv=N4Ik1m9B c=1 sm=1 tr=0 ts=68debc4a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=NEAV23lmAAAA:8 a=edf1wS77AAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=IdymAyYZYteemNvU4yMA:9 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=poXaRoVlC6wW9_mwW8W4:22 a=cPQSjfK2_nFv0Q5t_7PE:22
 a=HhbK4dLum7pmb74im6QT:22 a=p-dnK0njbqwfn1k4-x12:22 a=jjky5lfK57Ii_Ajn6BuG:22
X-Proofpoint-ORIG-GUID: FTNMwbUlUVdTaZK2xKlX3SWZJKiNSWUK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE2MCBTYWx0ZWRfXzsWupGN+Kr45
 1EnDNzL5qBqSAPmVmPuJLfrSvHfKpbxtUKbzEfoEh4ghQhKcoWfeX55rfii3YItDvUr9yTQsnqH
 /GPNqNuSfXmZ0BbauMYWosPijPCTKNUdUsH9ORbdivIkbEi7B4gQ2hdrmFlQaGSy7uygwYJlbrR
 tVMnXn51r0+/0aQEzAYuB8tXt5FkqEPUDOZrnJzj+zAvg8ftKKS6Ifj6/pS0daYJW9GYxyTN78j
 3KiFzY2Q8ZIiZSqUAtM26QAWF21nQmSwMLtgGpPHQB8erBXKW7ILEmftbKo/5FqyXrDw4Gyh8Pn
 wjCH4hggvZTUG29UkgeIci3lb78yMehrGEHxgLO7DfdYjz9RE1y3EYcHYyUHcTvHkoL3rRiQjWd
 GBu1UtwLCTpJPIMspqOcWPCEZp+pXQ==
X-Rspamd-Queue-Id: 1C6C94000A
X-Rspamd-Server: rspam05
X-Stat-Signature: ktwgjkrt8snjr19f91h8rjqxp8mrj1qe
X-Rspam-User: 
X-HE-Tag: 1759427668-460193
X-HE-Meta: U2FsdGVkX1+47i62U4LLK+qQFdFm66W0XVpmVLgq+cF35/WgFUZvpqxAR4p+V8BGtA7f5D7AAlif/sLOY/sCXLotpXNPShix0/xn+GOpBINDANKRMpZvd2eZ1MiyBROmdoRFthAEQ5MoJ2SK2eIZqXeAbuNUg45XrXszmU5cgTo5WJzZxUhypxAepScfAKuFFFavnB9534qyD2N5kFPNPlG82VPF7ODg/6mBjURAyx7rb50Gs6VuMKX60NuhCvHIw6b7RcKqHPLnA+LrjNh+1XFHIm9J0BmDtquuK0jHKSARsQKJhTWtbvtXGpJ9ixKmoMdDjguk9JZMunaO0kllSgWKX/3EmlwgnpqS/XGxctoZu7vPUEMGK8Y2rB4vDkA5liS7AjRi05xna9sUo+eKPZ+Dgb91HmNxNqWtaETELhKXAxcAyXU6Dq0El9ueSQgpmHfBurn3JBa/TW3znhOsuZFs+vH5OUB2GjRmiwm25Y63nofU4u8EdrjYB7LyhyZYvmieWWbadQAjDz/D0v8qTjSFaGrdIenpJkes2YKVgfcNMA+AQMj8kTdK9OQYlCLL6a9dakmcQliGCQytAGlEdAyA6eP1nZzr1A/B7VNsweHNFITboId4GL+G7tuGdSuz0s97AWO22UHw46eiv/QZoSyyz3XlaEvaBoDbT/JKJbbNoe828TfC5MeB3uzEhhWfAKE3baTqhPO3lyO9rrgCNimQJFXAiXVFQhD9gFZH9UAiQYsePpXR+8gAyq7nSX+eWjybDPCCvN4us8obULYMhL8G25zZG2fnxlCLNi+Jt2iXfydalTbL1SWFyiCZ3UZq79NTgUyc8w6kmXwI4PNpRjHV0M+++jj+lmb0AkwMqG0fQPC1a2cgJ25s9qVVRWedel+PY56KFPFEhAOKKVpNirr9MoVRfDtqmdYTgGnpJmGGi0J4Ew+mEF3TdoV0Q8VFrEk+8Yr0QNvMyoOuO3/
 MKRwPhlx
 axTTn0Tqnks9+Ppb2Jl7I5tLPRYMEnAD/9DrPh31nSj3wpIAQJv3sRVho5edZBCLyG/5JiQ9j52Jc8RweySN86gMaz9PVPBaij+fI5Y9D/9KZTpB0/hM3Aer3jvbeL5V9iOVnXT7OfO+J1uEn4lifogkcDIGrMWwjWQzAoO/HQQFHTXKiHcwrd1fvJp+9VDUwhxoOy+HBqfUpybRUI4q8G/jemtEIpA4r0xJtQWprs0x0QKHSt6BegBBb9T6ZPJtdgceMWF4c/BoEs7NkfxXCes1ZVy4ryUv0OIrXAsouf6CiGFz/ltCuyUa8sFEaQvSDgi39ZNbIzxa10/sFx9d2rkYelm755rPJq9GLES0yt3/MMywteoFjafNB8DKOICo7LxWGt3iT6BPgvmaCrBv9GgnCjqwVWWSV/ocw2BrtLJxLjhMsGLodwNjJu8v19YQvwX5kZDy/5y/34jyrxgOu0kvLO19e4cBom61B/wH44Jh3z9JTsYAIvAsTftA5tkDMUKeRDpd5bkhQ1/QyJ+rzjDwusRK2iF+JOq+SiKs1u9htcBTNKwxDplkVyCmbfVnX5vIpqazVrb72drfr7aw3Zo4PTBFNNrM7l/cQ9kTJuVvwKHwQI1+qPdM2sWS2uVv1KuYI55g3UDBFMi6NPtWh4WmrIp+6mN58xMKUAizOyFVtji8OuiPIgu6K1NBO94KsYgSEg16mlm8PJTYDun3o4n8EsZvbnnyWT+KyuIScQdheIkSyFxjj0IOhsmSB/chGxRsAaMMNjrtB9HKFcE+RYCcZvadVVRgMXIFpKxdzafPtNdWbfn+DE9Y0MYKkf4aLTdP/GChWfiG9KiQ1g42eNFnzb+YVAQBb2lz1uwuPSyjz7tDy6IdKi8V0ROpvx2ACPOBaDHIwloVFDOaTruYWxZpAHZHlOOGvzFN1C8nsWFEt+zS3scAhmhip42kIyPElQGcDBBronGr7V5g1sTjlX23kGtW3
 lr10cX4J
 A+kRneMcjjhX2aqlP+zg7vDqgfHGgowKCGMS/X3IgQdn7HwZ21Gqd2Qvb/RdDteFgFyMcVY3YNW+L1dLf5KJCw==
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

Forgot to ask, even with your current patch, after splitting at 
min_order, the old 'folio' should be at min_order as well, just not 
necessarily the one where the raw hwpoisoned sub-page resides, right?
If yes, then 1) I am wondering about the value of the min_order?  2) 
perhaps the syzbot test need to reduce the number of fork()'ing,
as with each MADV_HWPOISON inject, one page cache page will be lost and 
stuck in the page cache, the difference is the size of the page cache 
page and the number of pages.

thanks,
-jane


