Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E706CCD187
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 00:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958A28E0003; Sun, 12 Oct 2025 20:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930328E0002; Sun, 12 Oct 2025 20:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6F68E0003; Sun, 12 Oct 2025 20:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 662858E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 20:21:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFD45118C5F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 00:21:47 +0000 (UTC)
X-FDA: 83991187854.28.E5DB61D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 702AC40004
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 00:21:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gwMI0F9+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UiQAtZCr;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760314904; a=rsa-sha256;
	cv=pass;
	b=yT7vIMmQfdytpN2bTaMkSh7mDTPMgXnv45Sg597TxvVPNZZWH7yJBnCKRZPKIq9C/gr8zL
	p3MYI53pGxUE3alVRJKOn5kDQX0174LzMNWPr0Snm7yxGKEGrkmOUPC6GM3wHJ8/CHTDie
	+wuG+G0JH3oRJjUx76RGJa2aIcEidWg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gwMI0F9+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UiQAtZCr;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760314904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xv6EhwHVxFJ83whD3eetAnjyDpRZDzk0zO5LkJoiL84=;
	b=PY5j4f0TggevPqTrOpgyCmpvvspmkzLbIa+o6wLkzmYtU21x1Q7d9XMjBXsMK3YcQB8h0d
	GlV751WdYQ1/6lcTMRn1cJ10vBeCW/Ctmj+UE++bf1e3+kxBV7NagJVK2K/OLd2pA9DXZX
	hWcPRIpMSjBZD+o8wFCrN+MO/Viio/U=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59CNNm2S014024;
	Mon, 13 Oct 2025 00:21:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xv6EhwHVxFJ83whD3eetAnjyDpRZDzk0zO5LkJoiL84=; b=
	gwMI0F9+nYd4RlntI4IT0zDBNZf2erR2YtcLtrwQxm8mTMm5a20LEk/Sh2zegdJS
	HVsix4IZ+8MAwltHwg77Pt0Ko/VlL3hg/SWCpvcMjqKpB6s9HxQmPX4r+aHlEGdU
	Dd2yfCnZDjmu4lysZpKcPZsB4UmnAVUkI+3tQBs/zC0p7m1ARiXPHugwG+ooTGfU
	dShsZwuYnCEypjkIdFbbNHK7SUDn2MSz2h9Aa9fAy0Ps960OJN+UHCCqPW3KJXSm
	62859RkGHIm7a0jp6ZOSmc9OX2I5+yssAOVLnI0ZwpQpH5NgXHFWSgB2vLpFIIgm
	zKKmdjeS21+YlediDmElGw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qfsrs8h0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 00:21:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59CLhIxC017202;
	Mon, 13 Oct 2025 00:21:37 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010071.outbound.protection.outlook.com [52.101.61.71])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp6wed0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 00:21:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=clKKXysyOHBsKdnyGjRJKY3BvbBwij39tQJVx8p571XkFebc96EVPzDZ4muZmgT2R1W+GfURVCOE9myKMfuNACBmHqZ78EORN91sVfjX0+hGaI63jfwNndJ6OMu2GjbliMXJpobp9tKzJ6lLKUbSSa0UlawSt0aNOE88SsZrw5FhTgQ4GGoZLyBs2x71V+5EhlZZT318F2eGCT/ApzZNNC8FK4lN3bQPJbTHhQlK7eaFyMbqxhtDVi0xyeQ42LMOo4FthD3WOuprchcnRA4clqRYz8P/1776ByoGYDpKeXCjqvpaXpYnCJLCzJTaNV+yClPbZcDUY/QqLl8R0AT8jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xv6EhwHVxFJ83whD3eetAnjyDpRZDzk0zO5LkJoiL84=;
 b=oRtck7chc2lgdrsrVQanGLgTnrkLoLh3X2VVQBgUVQyT9/zkzws3Gey9iRVujoouJ/Oz48mAYxTx0hXrOvvQcGQd59yGaH7FEMIqHFyoxqNW2xAJWggDDXjhcqE+QL5qjOR+QsPv+8eHCKtv5/QdfMJDBB3oaN3lyzQVJ5VE/EmOX6ds+/LVs6ZA/B2kRc6nYvWXQOYSFPqsnLLV4ibcQRheSlL8isXD4zTDVNav0U/O3wo+CXk97Rm6GLGbNQr5bM5bqOGgEsAYrl8Hh+QXn5p4zM03pwDM8Ys7iM4c2RrPq/26eygLyRo58unxp9rJFTO6gUqN+c0sliv7+8rtDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xv6EhwHVxFJ83whD3eetAnjyDpRZDzk0zO5LkJoiL84=;
 b=UiQAtZCrznjHWWkDv9dpRiCUQauNnq05ZhA+Jp2Lh9tFQWgoG46mvuE/ZNMdkYpKI2HUxAbxznYgUZPdH4KmXSs27Ca+i0Vl8BTp9ISok0pAGLLeB4cfPb9l53M/isjlnBRQ20W0VNcnZ4hfwVq3MWaajmJYY4dDgycan8FDxKk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA4PR10MB8424.namprd10.prod.outlook.com (2603:10b6:208:56d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 00:21:35 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%4]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 00:21:34 +0000
Date: Mon, 13 Oct 2025 09:21:24 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kuniyuki Iwashima <kuniyu@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm <linux-mm@kvack.org>,
        syzbot+a6f4d69b9b23404bbabf@syzkaller.appspotmail.com
Subject: Re: [PATCH] slub: Don't call lockdep_unregister_key() for immature
 kmem_cache.
Message-ID: <aOxGBD1W23t4otkT@hyeyoo>
References: <20251007052534.2776661-1-kuniyu@google.com>
 <10d6dec4-665d-493f-97a9-2982dfbc1afe@suse.cz>
 <CAADnVQJ1AzEL6JD+ePBZctqmK6unYKDYKuARRwDBhNJ3CBykdw@mail.gmail.com>
 <e072aba0-6160-4485-93ed-3c3ae5abdc22@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e072aba0-6160-4485-93ed-3c3ae5abdc22@suse.cz>
X-ClientProxiedBy: SE2P216CA0106.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA4PR10MB8424:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d344ef3-a933-4644-f177-08de09ee7744
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T3lMVGRZSXRMNHFpaDNNU2RycndIb2lWMnd2b1NzNVNUTjhvV2VTMEphUmdS?=
 =?utf-8?B?eVp3TXNGZUxCVHhnbHp5V3BDc01ZWlR4M3NMNzlER1FsTklqN0Q3c2diWEN2?=
 =?utf-8?B?MjlDeTZLVGRodGo2MjdQYlA1Z0lQUWowZFVvQTBseDFPMFo5MXJtVi9Zai9H?=
 =?utf-8?B?dmE1dmdRNVc2MHgyNlczelkwSEw2VDlpYTZzcjI5RU1lYXNyQk5CbURodWFV?=
 =?utf-8?B?MS9NbjI5RU9QaFdzM0ZQNll2UHNLaVJXUFNLNEU0Y1RpNVcraytMUEYrSURQ?=
 =?utf-8?B?ZWc4S0dIZmdmcHpiaGRhaXNmamZMRXp6VHg1ZW9FYkNkOE9POE9wMFBrVkxw?=
 =?utf-8?B?REZzREdzMSt5dDlabUwzWk5uekVOWFJaVSsyZlhkWnZhQkprSTdnakxESG1n?=
 =?utf-8?B?Qmoyb1Y5QUN5c292L0tDQ0dDZG5TbDBaRWRDYm9ldiswM2RMdSs1TFVhMnM4?=
 =?utf-8?B?aTB5TE1qYzBOZHd1WjJxTkUvczBRblpvamxzTWxzQjZxRGRPT0gyRlp2Y3pS?=
 =?utf-8?B?ZXBabC9VSWJ3cUtlc2REcTdKM3lQWVJkTEpnVkI3c29MTmJqbmhVSG1qNS9v?=
 =?utf-8?B?OFZZSnB5Y1RnWjdzQjd5KzZFOHFKZ3g5ZFQvZ05OKzdRdDd5MVJINXFuVlUz?=
 =?utf-8?B?MW9tKzUyZ2JVMkhyR1o0Yjg2UHo5M1VzMFNOKzc2WjRSbFZNemJOa3pYRjZo?=
 =?utf-8?B?dFV3YnhUNlNpMzZLWFI0SDhxZGhCZW5OMEdLK2d6M3hmSDVhYlp2UXNlZlNE?=
 =?utf-8?B?T052UWlqeERwNFczSDhkQTRaZU5DMzl0Tk5WcjQ3RG5ybkRVWVBCUmNCTGM3?=
 =?utf-8?B?UmN2UnFTdHFzSVdlOEliWUo4NFU4bWdLc05zQVlycFlJbmdhUkZiRmtOZjhz?=
 =?utf-8?B?ZkQwaHByYkdja1ZRVWtiazg3RFprRTdqZDJpaGphVnhWYThhcDVpTzdLckRS?=
 =?utf-8?B?a1ZIU21zSGh4QSsvRTdmR3dKdTFDWFdMcjcwdVloUkwzalgydUgyMnZ2UGQy?=
 =?utf-8?B?dlZGWS9Pc0gwK1JxVEdRdnMvTFpYeGdRbkc0Q21GZlNlTDVwdzc5OU5rS0hD?=
 =?utf-8?B?UHhqbDRueUtPcjRtOVpCNklTOFRRZE55anlwOEJGMmtvQWIxWjhkQTZiRmgw?=
 =?utf-8?B?NG5ieVRveXNHREFQN3NERjhuelZ4bGZka3NYcThUdTFvVHArVit2NkJQMEsw?=
 =?utf-8?B?Q0tqNGowRU56UXdiZDNMdXJwYk92R0RMc1ZUdHNETEFwRFM2WHY4ZG5TK3ZK?=
 =?utf-8?B?TFlpd0JEUDRtdW42S3dhK2JBTjNvRVBXSmdqUElCMDl6U3NpcFhKNk1idnFO?=
 =?utf-8?B?eTNqU0FnUkViZnhjcGlCY3lOa1RTUHUyTWhRaWttV1hnSllKbURFNmhTNzNa?=
 =?utf-8?B?QmMwakpqWDZ2Y2NwVTVtblloTnh3K1lZUVdhY0hyMll4dVN0OGV1M3BEYkV3?=
 =?utf-8?B?UHFQd0dROVovNXAwUkFVTmNuVEd1a2Y1OVhEelhlVlg2R0p6cjV3KzFXQUFm?=
 =?utf-8?B?dW9aZllqTE5sMmdYUEJqeHNUR05lSVVxaStOZGpMYW5NODFLbVJ1UjJiU1ZO?=
 =?utf-8?B?My9XLzVxR0M1M25qNGRCdUpOR0RST3dKV1BtNytFVktrc1ErNUk1NVB0SHl0?=
 =?utf-8?B?K3JZTWtvakFGRFFpTkgzRXRFejV0MGVTNmZib0dBOWFxMUxrWFVYZFNYNHoz?=
 =?utf-8?B?Y0NSNlY3S2VmeDNCWWM4MDA5cDJ3RlFiK1BKUlExblRpKzFtNTVXZFErbHlz?=
 =?utf-8?B?SGVUclc5bE03RFlzNlVXSFJ6YWRnZm93cU9wenVnanNQdHZTdjBKVGNkN3NE?=
 =?utf-8?B?aHRoZEEvVDZaNEoxTXBKWDFIOU9GaFFPRUQ5WU9LZ2tYaUl4M0ZFQ1daVjJI?=
 =?utf-8?B?cjJKWDIxdG9vR3M3OVlHaFBqZnU5U1BFYWZnbE5FOHB2UTF4UmpuTUdRQ1Nr?=
 =?utf-8?Q?TNtva3uwp11Y6Xz7sRYI2NceDnPbwmdW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEhESkp3V0EzNk02LzN1N1ZjMStPUFZwdTdkQXpnOFBMZ2FvUGJvQlE0OU51?=
 =?utf-8?B?VEJpY2dYZjBDanlyK01GN2ZwZEd1aXR3V3VEOVFuR1Q0aG9PM2pQWGFjQUtk?=
 =?utf-8?B?T2dtNkx1Y3pCTi9VeGp4TGV0eGQyeTk2N2dkaU9KZXNzV2RCRDFaOW9Fakx4?=
 =?utf-8?B?L3Z6QjhpQzJibjkvKzNtRlMvdFlGcUV4RHpnL2NGUWU2MzdBV2RnUmxNNTNl?=
 =?utf-8?B?NE9iUU1hZUsxM0RldlhPalRTWUh6NHpiQmxMRnJ5a2hCak96YXB3YUhTMEpj?=
 =?utf-8?B?dWJHWUkyd2xGWmtkNEIzTEw1TWM4T0VUa2gyZjB1QU5DM2RJTGN1a01ZNmpJ?=
 =?utf-8?B?TmxvOHNaVE93dkxkTFVwYm9IR2M5eWRwcG5vZnhUNE85REcxdG1xS3QwU3Bv?=
 =?utf-8?B?V2ZWb2N5VVoxbmdGb2VFZW5lWDhhVEd2cFNqcDV0K3NDQ2Y2REFMUDZYVzJU?=
 =?utf-8?B?MmdaeXo3d0xRUlZSR2NucXR1Tk1wbC9QdDFzZHF1SjVYRStxdTJmQlFNRFor?=
 =?utf-8?B?OGpFVkxtdWlsSklEQ2tvS056TVp4TGUxSGxKU2xOYlNjNXpmK2Z6T0dob0Zl?=
 =?utf-8?B?WkFWZ290T3AxNTJaRWdTME93bmRzdXhMbFR2bm9hZmlxcG9ScXEzcEcwTmlk?=
 =?utf-8?B?aG4xNjQxSm0rOHVGYkJNWlo4dkcrSTlhNTNJKzhoSGZ1OGtFaU1JbW9vazkr?=
 =?utf-8?B?OWd5Q3Z3aGZnTUZOdjdaTjdkYm1TOThTYUYrbUhHdGMrd0oxVFhYWXhpZWpL?=
 =?utf-8?B?amxNV2xaU0RqSk1aVmluUlRRVTRZTmNNdmxsYUMzbEFkMnFwWWc3czJxc0R3?=
 =?utf-8?B?RFkwcGZNNkIxdEh5bHRHR0xPcXFaSEtyV2h0YWErUUdzak90Ty8yWUlwR1l1?=
 =?utf-8?B?ZTFURVBxQjNTczBsRXZFMldmbFgzVkZYb1FKYktiZExud2JNREx3cmtOOWtU?=
 =?utf-8?B?Y3pLaEVqVncrTDR5THJtZEMrM2lyMTBOMUcybExpaGJhcGZSd0V4cE42RDJl?=
 =?utf-8?B?ZnJqcTl3UWczRTV5emppaXRhVmlPNlZrdDI5NjNlMFNycmtUQlNzTGVCRUtS?=
 =?utf-8?B?emlpQ1ovbHgrMGJQRXREdytEcTRMZ0Uzc0E4RVFwa3ovTk9YNTdGQkZnNDln?=
 =?utf-8?B?REt2R0UxWjlxSFYvM0kvMmZTT0JlY1BwT3YvTURCVmdlQkNXWHpLblBIaDJv?=
 =?utf-8?B?WjhJbWxCM2dYREpwaTNaanNzNW5FRkJSWlp2OEFCMzVVaTVrS21naWYvT0Nx?=
 =?utf-8?B?SkVzYjI1aVhwSTBnbnI3ZTJ1Vmdpb3R5S3NybHlkVG1oRXN3cFltdVRoalBD?=
 =?utf-8?B?b0xTSjVaU1E1YnVVUDVWb25kWHFZRXpLREVhUVhmTFNEa0lVRGtVUm5RMW40?=
 =?utf-8?B?dmF6SU9XU052SjJrZ3BCeHBhUExoQ2dhdk5qendORGMwVXdPSWZ4N0FPZW1C?=
 =?utf-8?B?WVc5YjZ2bDF6bFFjWk5FUlpSQWlUZUhBd0QzeldKYi9hS3E1ckpCeWdMaStP?=
 =?utf-8?B?SnlCODArSHdyNFV2Z3Ruek51R0FpbG1VeUZ5SG8rRDd3SU9iZ1BVR0xQNUZ6?=
 =?utf-8?B?N3pIdU8vK2ppb1ZyVDd2Rk5FSElsVVVjVWdtZ1Y3b0NZdWd1K3IyK3pwazBj?=
 =?utf-8?B?T0lRQmRlb25COGxxV0tGV2xlQ1VWMzNIZkJXZm9aSU55Z09BNEZkVlp6Vjhp?=
 =?utf-8?B?Y0FCNVEyQ09jMzVac29kVi9qdm1kUHgvYnh1K0dMV29tZ2Rmd0JWSk9WWGk3?=
 =?utf-8?B?RUFnY0o3SlorWlBGd3B3cE1QVXlocXBzWVhiZDMzdzcvenZsZ2hnWW9BMTBG?=
 =?utf-8?B?Zm5GekpHU0lLK3lnZ1BURndRKzI3WVA2YWJNQ2RYdXd4MVFrSkhBNi9IdEMr?=
 =?utf-8?B?c21TT2UyTHBDbDZvQmFXclZ3VmxLOVU1U3ZQZTYrMDljY0d2SXVleC9Xbzha?=
 =?utf-8?B?ZEVwMWJWN3A4RTBNSlNid3J4ekl1YmFzWThOYXBxYWdEbzhLNkd0M2pQVm5t?=
 =?utf-8?B?LzFzNURXSnJQb1VRdnRtVWh5SC9PVkJlM1R0T0NnMlVOeXdjWG83eEs2U3hM?=
 =?utf-8?B?SG4xRUV1dkZiQ3AwZmRKbTliM1ZHU201ZnRVdC9uSU9xZkVNSG5kNW4rUWx1?=
 =?utf-8?Q?baD6Y1uax33ioscCASbY+RuzA?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bLYMSg94TFIk2ym0TB9w/6/Rs4tiPaiqW3IPdGC924ZlpG8RC097J3fqmFJh7A3eMgqFDHEmuGJEG93ILWOmWOslID8t3nnFVHcm54wfIRS43wvDd6yaIfWeNaGDfpL8eRGHwJyJlP55omLpUn+da42UjK/pZdJO/7uFXq4Xw/S1h/CSXR8r/5XAAze8ELHPahpkxxfi+7tNQy8yuTHtXs8s+C1JPCXFpJL6jgrF+Z5UoEeeoEjDceCASBR2WQh2to7NrR05tFbghwVJ6fABYegqYN/7u+NkZL4+9SEZ/SPlUjIdSIn+y7ZslbjtGgsQbbrLN/Yc+mGn1TYVpj75eJ/TiZdRsKzZUXDxTV38LKiio5V4Q3ZBEdKh4NZo12hy9UvWTvCXhn46qlak+oOR2/QQpX9qb6ambKfCmM1OU1ZEz592wtbvdE4qrOTd4CIdF6O5icnVrI6v3L465FgA7xW7loiP7xelG95+EugvwAT4iM/pOWCSu69krega8O9J+0X8ZYKgwBgndohRVyhsoeV1+CwBQPKp2loo1lPG4zp8Wwq/j7+gvYn5snJj6VPixnyrRmsfFMSbv/MuoN12Uh/vR7iBn678lq+OtYN/URc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d344ef3-a933-4644-f177-08de09ee7744
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 00:21:34.7798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h6mdDwxx4/jr/0jrstnxgGf2JWEyuQ/8URIJbOj1VCz39JKp/dF/4ub/X4r0bbBuJubdGFg53QZlo5iOak8T+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8424
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-12_09,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510120129
X-Proofpoint-GUID: DOMF02LMTfueVTgbVGY1gjtHuyZ_v8Iv
X-Authority-Analysis: v=2.4 cv=APfYzRIR c=1 sm=1 tr=0 ts=68ec4612 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=osOJaCoKrwLyM-mU4PYA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAyMSBTYWx0ZWRfX0PvyU5w0GE33
 HmG7WUKVq9aa5u0wZsoCSWSvpgNgSqrYS/OMj/hjcWuTxlsr2GT7R83Wflr4De8D6nQKo1+TY7J
 20FoY/TkL6fW4pYyvYddafSe4/ZJBcaqSg0LHxApToMMUHMGEqBitH2IWc01D9jOV4vcdHXyr1B
 Ql25Ih6Qc0xXetznrBi5XqH2lpCvHHzAHVdhSdEqaL2aV4PVH3bkvU9pAUFrbduB04vKHDCzwA7
 rcDwEB/Mgri4o8i2YAwusyJNpr+6qz/yBT3y92UXfDMKm0cnrscpQj29dher94zmsc6SZcBAtaq
 chMOhF32sU31jiCU2SVnAJRfgFRsVhFL/jpgSMsUMIsC7bTSs5BNX1/SMR6JHUeCtEWM07vzVa9
 CFTWXvYWt6FtfyBYWEkES+nTY7pFVQ==
X-Proofpoint-ORIG-GUID: DOMF02LMTfueVTgbVGY1gjtHuyZ_v8Iv
X-Stat-Signature: 4krey3qrmb5d6bjzcqaj3sm6ucotzqmh
X-Rspamd-Queue-Id: 702AC40004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760314904-821651
X-HE-Meta: U2FsdGVkX1+xIzSA7rh+dsI4USVm6pWOwpOQI0DMrKr5dl/BVp4kjPfCTG0TbOU/Lig3frfpRR9xbXYsL79oMcxtn8nLAAFfZcc9wqH5F3nGqT301an/V+V/F9QmBzIJjgLE1JCS7bWN/46O9siUeK0ErRJ9OJKiuuNtwRYl0IhIY5eDt1Nnm+vfdWF1HfpXh/OfzxrsctcWMkfCcGWYtxhVjR2Le98Y1ObRl48EM2dzNMNAYtPfo8Kz/1jm33WWxUXjmXyDWcknCumSe5TAjo1Y55TtBRgWHXRY7VJxmu0tAjhJ5WkERZP4eG/6bVZ/csXYefiV5h+4U17dgtAxG6X4rtfdB2TfjV3O9UNcNXBD7W5ZF6OvAf9ub4XYRSEg8Lj9aqf/KnoAZby7RrPspcq33fvFMN8xAsuouJ0Ijg26x3PW3z1gZPQXXCaBH6FSLGU/P6Gonsz/QsMBvIJd044kfF+bpawXjPE45EVw8cJCm3UPJlH1f+14Po4YEkHGbL/h5FBOqipypMi27w+BuSH3OpTiKwO42VTM7kjpQXr9fceV4l6SH9Ssi5sNJ8reRoa6sUto56QLstZdrJDJGTfBMIz8uNlINQcCVK3m+DsgufHr0ddabJYwx/BXTEkRpyxxx3fMe9DPgLPoMKwbrPuJtxcWECyf1gDiTXCq2VOlLo+xHY5Tjl0VXW20iarvdNX8eCBv77YR6A2CuibK3GCplFcmAvJDxdFy7nIskgci4ZYCqjHHd/zJowf+GbHsTuEj2+lFXypDYqrkvjJwi4xTwxlr0ORKMfCtOToHnAD2FvvZpxqMBobCyCDQOckvDQ/YTd/3+KCKzxD4tF/V59xqdUmd48ook//2IgISVTmu9VRj1lxEUU0OX7HjOJCTtCsquGRJGJ1pLHLY8EuFA+5Xa76rB1jZET5hBcIT9bvZCLCDt/QYe2uN6o0kg5Ol/7yWGx6h1UAFE3TpNkG
 gpFbr4eh
 maLD4DvlF94LZrQ28hoQdWRpONtDMiQtlntrOb/Y0KwYzKNzrnpqT5X/Ms4gasJES/ZSvtRKs7fY6K/5rz2NyTXH+F+2qEOJ6CFfXAv9Wb+TO8PJ4WJ/7bJMPN31/y5S1XRbyDbIbRy6O0gCLO/cG3dOaRvsU2fr3CC1ZQKppC31GXfVgpSm/CPAbBerg39KtAYq2O95V6riL/2U6BMNMwNwbGUudjsItgVHghKLuLZvKpKm/XRvJplk51OxIqdDo9cc4wiS1SxHEawBZ4s7GhBQwPmpBQ5wTIfeRLDy/oT0D5SijPtgPFn45RBtMJc0dQ5WX47BjisQ2GOTyGfXA7KbSx2cEkt9XdXnvH3ibYM6/eKh3TxMqmFUl4EEfYMuzexImczXZRUSeZOznNZo7bcO+qWSHofDk9TVCxEFUmxJzOrh+JBaAqTfv/U6gYjjDHc6RgjrBlPY5T1h2+pW9+PF6SGUxzJ72dPnNBLXUIwL0L4t8+2QpZ6u9UdZejSkEXPiIHWNrTKUVS/yql79z8noEClD0GCMdiceLiLF0r5i/9BMDnizd3CSm0N1CSszXzlL7iX18bWOKVyrTeJrI+sum5Zt088mMhRaojg4pq7GHnRXizh9DPb5bfWwWnljtFg78d7Q/XI4tcgqH2sj9cgflBZKk1t72x2ebRLb9jOh0P9nDeWMLm8atDdgE72cbUA2Yle7Rd5TZO1qsjG2eAcUWU7Iq9KpxhyH9m/nGlK3T+deNgb0uI/b6hLESz8J6BnCefRs8w/K2GLb/WWeI47a2IXkMOkhqQz3EoEQwHdkuNhFioGgZgXBgk80heH7RioyYvDi6RbD49SVe2r9hASjsmtAzm69Mw5gF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 08:07:54PM +0200, Vlastimil Babka wrote:
> On 10/7/25 18:11, Alexei Starovoitov wrote:
> > On Tue, Oct 7, 2025 at 12:46 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> >>
> >> On 10/7/25 07:25, Kuniyuki Iwashima wrote:
> >> > syzbot reported the lockdep splat below in __kmem_cache_release(). [0]
> >> >
> >> > The problem is that __kmem_cache_release() could be called from
> >> > do_kmem_cache_create() before init_kmem_cache_cpus() registers
> >> > the lockdep key.
> > 
> > Hmm. If that's the case then alloc_kmem_cache_cpus() wasn't called yet
> > and s->cpu_slab == NULL, so any kmalloc/kmem_cache_alloc from
> > that slub will crash. The above sounds like it's a race condition,
> > but it's not. It's a weird error path in do_kmem_cache_create()
> 
> Indeed.
> 
> > due to syzbot pressure.
> > So the fix isn't quite right.
> > There is no need to sprinkle #ifdef all over the code.
> > 
> >> >
> >> > Let's move lockdep_unregister_key() from __kmem_cache_release()
> >> > to slab_kmem_cache_release() and do_kmem_cache_create().
> > 
> > I wouldn't.
> > 
> >> Thanks, added to slab/for-next-fixes
> > 
> > The following is imo much cleaner fix:
> 
> Yes much better, I'm changing it. Thanks!
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 584a5ff1828b..0a1fbddb77f8 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -7693,7 +7693,8 @@ void __kmem_cache_release(struct kmem_cache *s)
> >                 pcs_destroy(s);
> >  #ifndef CONFIG_SLUB_TINY
> >  #ifdef CONFIG_PREEMPT_RT
> > -       lockdep_unregister_key(&s->lock_key);
> > +       if (s->cpu_slab)
> > +               lockdep_unregister_key(&s->lock_key);
> >  #endif
> >         free_percpu(s->cpu_slab);
> >  #endif
> > 
> > compile tested only...

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

