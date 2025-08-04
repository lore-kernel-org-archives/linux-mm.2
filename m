Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C58EC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 16:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D248E0002; Mon,  4 Aug 2025 12:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44CF8E0001; Mon,  4 Aug 2025 12:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0D348E0002; Mon,  4 Aug 2025 12:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AE09A8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:14:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 629B25AFF1
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:14:09 +0000 (UTC)
X-FDA: 83739571818.19.B33744A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id AED781C0007
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:14:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iUMJ7kf0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nKVZwWnS;
	spf=pass (imf20.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754324046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=14dqt7Zbnb3t/zzsBcJXC1pwImkMCRlMO+eLSJbQS8c=;
	b=7/f4nI2c84OXUG1+ABEK0bphSx6PhWqmTkunIUh+0KLpM8jJntn4Myu7/IWjBlSy0tBnpU
	8PJyDmLbbRVyevhn72Jttfws1tVm7VxnSdQk7jJFsTcU1/9LRrho0pOghL2SWdSwMX2Tae
	JYg8z9UcnA/mH5iZh7nupx0aoyhnvr4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iUMJ7kf0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nKVZwWnS;
	spf=pass (imf20.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754324046; a=rsa-sha256;
	cv=pass;
	b=TqixGsQh2jyi4LC2LPbj42gDq4no8XY1NksS62+yn0IzPcLBoyoNXQkCCzbwyncYMYicO6
	aKaxNuCaGEGyjpEvXhkJfwe36e2JsR/gtwJo4II2qLjVp2k50hy8m8m1u4iCWLT5Q9Em2a
	eOUBAvXBjhzvk5gFZysfx7qe7SIA2wI=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 574D6w77032271;
	Mon, 4 Aug 2025 16:13:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=14dqt7Zbnb3t/zzsBcJXC1pwImkMCRlMO+eLSJbQS8c=; b=
	iUMJ7kf06oCkxMHnQy3UtaF3AVA5ajXAeANKvYmtPga7fc/jvPLsVXlhevzFH7J2
	td/iSVbyqCB5AKBsIUA/ppm7imkOZBFxxSUfjlrK8sZ8BxS79/KHi1o7B4mznZdA
	uDjRFe/xdWYzgvLgzPwJsYasc20QTvbjE+5GIqcdHBpJwAgb54m2W4/8jHWBhjxh
	wn5K0nnOMhLkxrNfBbJmuVmcxtNn+Awrof6sBJ5tt7f1zB1dr0yLbaAMFVXyPMgC
	OXzG0r8cwVnMqTRbGqiFDtcjBB06Vg/Sl0JMx7mFAHvM9OSjgFhgQG5FgGub0IE6
	wUAgfD/qYZLQUcECcbUxDA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489ajdjxt5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 16:13:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 574Fh6rH025476;
	Mon, 4 Aug 2025 16:13:56 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7jsm3rs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 16:13:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fa6q8MjICIgGaUO20OoebRIwHItmKIsm3LZ8VwdRJPyQZ6GesS1LNXxfAzgdIZzaZ2J5wHUrXZ6iCQ5NjfVjGtsp70+i36BwuImSagNfSO1P3LfB7WzgHF81L7rOdyxYFWeM1k//L4qzVrETZ/CamTzbiLdAaK1kVA1U6t5A6No34aGqtfC9cdjkzqsQK2V4vc4BWELHhiJrGrF8YDUW+xXca+YFDNHCRvJRs1o8PliLTxY6CrlFpp/g+nGLMxXr68N843VS6PueHT2HlA6r8jwptJSGGccpj+p+rDUBZBjOsVjKO19mTWdomASVb6I7qWOuW34COsWlYEo5nAOZ3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14dqt7Zbnb3t/zzsBcJXC1pwImkMCRlMO+eLSJbQS8c=;
 b=Tovdi5O5OHqZ/LMZkxEexTBZx7MqK3hoTq+WTggLOvfZWgwUzUY1WPjOLfMvt4cFICihHRAR2rWeNu4+DMEPvmvxInMt8bKSP828qvorV2HdNHMX3++p/7G4VE844OLNu7DHOBAIKA9AzRIiNLlNdVinr4ojORCR9vYgX4gLVa/mMGSBIKo1jdO9x9Y6quJ0uV2R1H0C0JizryPuw6T1Qxcj8lNV9p7iyStQ9wwiGnGcjn09ZY9rDRlhPWBpwmEfy+yIKGXfs5hqeEefn4qSpuoSLE+ZqzkhwsjAgJCktZuhZ0jqu2e064kMONKWJskiJB8pDFqU7c/4vAoYqvWWFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14dqt7Zbnb3t/zzsBcJXC1pwImkMCRlMO+eLSJbQS8c=;
 b=nKVZwWnSOvJDojlOoHUA+T7pFhkQJpLd6kjr/7GDqV0h5csIJaje4rfQNsVtD/dx4IWjnTg07ypPkKi7C3Bf+8xmpqhkYpP42fdPGsPRarEyanb7S3IEcKI8XK/ue7qFogpU78k4DCLFXOUQpgvm9pTHItWmXXZXM15fLAH1VQ4=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by DM3PPFC3D93F6EF.namprd10.prod.outlook.com (2603:10b6:f:fc00::c49) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Mon, 4 Aug
 2025 16:13:53 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 16:13:50 +0000
Message-ID: <3c615755-7467-4dce-b9e4-0f856d6bff73@oracle.com>
Date: Mon, 4 Aug 2025 12:13:47 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] mm: hugetlb: remove struct hstate from
 init_new_hugetlb_folio()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-6-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20250802073107.2787975-6-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P223CA0008.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:338::6) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|DM3PPFC3D93F6EF:EE_
X-MS-Office365-Filtering-Correlation-Id: 24a036fb-e787-453e-1ea4-08ddd371e5d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T01seU5aN2h1Y0JlRFNlS3VVbjhjV0RaVXVwUUp4NGdFdm04ZlZ4N0lZckF4?=
 =?utf-8?B?NU14bHM1VU56S3Z2YTZmTnlLdHplamZSYm00KzNuSE1ObVJxU1JjMG45c2k4?=
 =?utf-8?B?UGZpSHZrcHFacTNiZFRGUENBK0NRUWxsNGRPd3hPNFhVelRJdU11ekpnWENy?=
 =?utf-8?B?am85bVNpbUJaVXJyOWwwMjU0S2lXL05JcmtrRndmRllXYTZESVB0T1hGV1Zm?=
 =?utf-8?B?ckRCa25VTjQ1TmIyQkZJOTFraUF2cmtMZE4rc1FSM1VtU2FaL04zNTYvY1NM?=
 =?utf-8?B?YVpJTUVMaUZZem03YzNQeTJIck5iOWNLejFSempFTVRhdlFuQ3J3T1N0RWp0?=
 =?utf-8?B?TXZpeDN6b3MzU0JjTjMyQWszanJxTzF2YmZEZkx1MVpzdFc3ZDlVMWdBWVF1?=
 =?utf-8?B?UnJRMStMckp3dTJ1eUEycVhyUTA5Y3J0dnRLOThwbUcvcnIyZi9YbUpBTmVM?=
 =?utf-8?B?c3QzaC9yaWUxZEpiUlZpbWF4NjEyOStpbmdZTGNRQVJTTFlrRzVRdStHdTlY?=
 =?utf-8?B?VEZEUWJJZlNiVXhlbkVOeDdHRkgzRi9LbEVaUFZCZEtwcml4SmZKQmVkeExH?=
 =?utf-8?B?cTlzeTQxMk1BMklYKzVoeHlUcFNFMldrTU9aRHdFaVBqL0E3UDJQMmVSWC9i?=
 =?utf-8?B?MjVhRWJZcm4rN1RCRUJuTU53eEZaOGhGM1hLa1Q2cjh6UElXMHp5eTNSYUVh?=
 =?utf-8?B?cUZJNFYxVjZJU29sZjdBMDRXNW8zbkNQaU9WNUlVSjg3L2lxNGlEQkQrek5W?=
 =?utf-8?B?N0FyR3k2ay9WSFdZUGViblUvS3V1VkhyaEpiR2pGRTBTSVIwanVDQmhHZzFi?=
 =?utf-8?B?THl4c1NFVkZ6K0xHUzZNQUU2YWJ1dGgvbHN6SkxyTG1iR3pqTE53UndDeEJx?=
 =?utf-8?B?MnVib3R1OVZuWmFmMTFjdENrd29ldWl4dHorTlJ1YU9Zb0dnenpBYzlOUERF?=
 =?utf-8?B?aStuVmtac2krN2RYdDluUUQzUkJ6OEJRVDluMktYSDhtK1BkQTJEbU45RTRL?=
 =?utf-8?B?bmd3QWFHR3RGS1l1OUlrYy9mOXh2UVZwVTNXWjNCRDYrNUxXTXVta0xabVkw?=
 =?utf-8?B?RkxTbDVMOW9FcGFhY1FsTkhTSnJMaHNMMEpGblJsYXVucm5hSzJITzUveHQy?=
 =?utf-8?B?QlVodllMYTA3U0pEL3BrdjFGWFlSNGFoM1RYaXhCQW1jQU9CcjRRYzZVOC8w?=
 =?utf-8?B?WTN1VytRL3M5QU45cEhRWDdBVE40Q3Q0M1NIOW13OWJxUzkvTkM5VUR1N3dl?=
 =?utf-8?B?RTZSRnVzS3dVUThOZjZJN2NVTFJKakxsTTRkNHdDL3o5VlA2R1FmK040ZXg5?=
 =?utf-8?B?cXhiUGxnL2srZDFHQzhWOHYwSi92c0ZHRnRyME50cVdoNFFaRkQvVjE0c21j?=
 =?utf-8?B?a0VCNUZqeFNTaFlTOGEwUXA4M0Y0S0ZpaHhCMkYvZEc4OURwdjh3UVhzN01I?=
 =?utf-8?B?Y0RSMDNhZ1dHcm9GZmt5VndHa2tsL3hZeDBnTlAyN0hoSFA0eHNpS3lVWUJP?=
 =?utf-8?B?eDR3RHpZR2pZRmJDOXpuSE5pdS9aWU94TWZoaFZNVjJuS2FFWHRLZGJVNko0?=
 =?utf-8?B?RVlGRENyNXNZdmMwVy9yVWRoM0ZHdFN6NUNKeGx2L3cxeVZVT2kwOW1CWjNt?=
 =?utf-8?B?WDFqNzNOQTQ3R0NtNkVjWjd3T0VkNjlUcHNqejRYRU9yU2hpa04ya1NtSzlj?=
 =?utf-8?B?aFJyZ2czdWU1dThPYjhta0kzV1NjaDJVdXNYVlFxbG9ZMG1yUmZaYlluSHZZ?=
 =?utf-8?B?MG1kaDVFWEhVdzdpeEV2VTNMVHFZNDN5NmI3UFA5RTZjSFVwRXVNbDc2ZkRw?=
 =?utf-8?B?NnZxRUhDTVNxUXVRRUErRmxZZmdGZTF1RHJKRzU2MzFxRFMrc0RxMmY5RHY0?=
 =?utf-8?B?MGpxcWgzajROTloxK1lxU1diRC9xdVdBTXdmMmNKanRlb1VPbGFBeTFRZ2hh?=
 =?utf-8?Q?IZfV24+eDhM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NW42RjNHVDFiOGJuS014bFN5WXB6UXliQW1EblBuaXl5cUtPVDNpRnlGTnVm?=
 =?utf-8?B?T3ovZ0JWK3IvdThQRVRQdzAzMjdxV25DaHU0d1l5RHc3QmE2bVBIMzhzRlRy?=
 =?utf-8?B?ODB5S285M2ZBcXFJOUhtaDh0UW4xU2hxejdOeVMwc0xXVDhZaXhjeklmMDli?=
 =?utf-8?B?ZE13Unl4UjNTcTdSd2NQaWN4d01PcHczRWliNmVDdDh1R0UybSt4dllCa21U?=
 =?utf-8?B?Q2VDR1dBOTdXUi8wWnBwaEhUVW9CdmFoaVJ0T0d2L1lOb0xuejdESFdLclNE?=
 =?utf-8?B?UzJMR2t6YXBtK0RGL0pXaHg0NHBybGhsTEcyVkVhN3VMZ05GQklBNkMrK1Ur?=
 =?utf-8?B?NUVISUFBYWE3cVUwVGlVcjlaN3JwMDIxbU54ZWM0OXB1OEtnbVdzdnJzMVJT?=
 =?utf-8?B?dlpDaFdHRjRoQWFsWDR3VldqVkFIMUJtRHlWTFdaTUNSK1pQeTQzZldpc0NL?=
 =?utf-8?B?ajVKYkZqSUF2QlQrYU1uM0ZzMUM4ZVJpZUc2dVZIY3BWOGZWdDlLSTdsdWdi?=
 =?utf-8?B?K2ZPcGxlQmU2TkNYQ2NBSW5mdEE2Yi9yQzZkOEdDRzFCWkxOV3JFcHcra0pI?=
 =?utf-8?B?OWlObFZXZkplUnU1RUNnWUV6cE9ZRG82NHNrL1R3dVVrV2VNUlYxcXk1ZEMv?=
 =?utf-8?B?eUJjanQwVmw3VXdYcW9WYzVtQkNQMnZNNGh5UnlTd29aNWlOdjI2MThrc3R5?=
 =?utf-8?B?K0ZGYlZmK0FkVURyWDlreXhPWkZuMjR1NVl4R1o1amx5QTJxQ1ZDdVJBRXlH?=
 =?utf-8?B?UDFZWWFvL29oN2tNYmU2RmJUaUE4YStmN1RTaWdtL3pQUGJ4amxWY1hjbE0r?=
 =?utf-8?B?aFRNeFIralA1MXJ2RDB6aDVQNytKZnFlcHFEQ2Rvb2dOQTg0Y0VaYjdwY0pB?=
 =?utf-8?B?emF3MkZ4RHY3YjJIM0hZR0ZidnJ0SmloQU90UDhhdHhmMlE3UDZEMlkzRUFp?=
 =?utf-8?B?NnZNSDFLV0tKR29tZmorWitLZ041bVg0RGtWS3d5RHRWKzZYSVh0YjJSbldB?=
 =?utf-8?B?dXVqN0dXMVJnc0RBWmVQUFpkbld1YUI1MVUrcTVYR0t2cWRVWDEyU2dRZ01C?=
 =?utf-8?B?NDR3UHB4NDhiUndwd3pFMHhkVHNRS21jV01aWGtFOE1OVEwrZy9vRGdDUmRR?=
 =?utf-8?B?di9VQUVjL1Z2eWd2VWVsMldwaWRKNUlRQ0dsMEtxbDk3VkVlcVZXTHo4b3cr?=
 =?utf-8?B?OXNDL0I0ZGwvalU0UWRNTVVuOGxINEpRNDZoZ1hscDdkbkE4cERQekJZYWY3?=
 =?utf-8?B?aCthSkdJVDhETnU3d1ZRa2JXQVFVQ2NLeFJlV3c2d3lndHlmVDdrajdidnp1?=
 =?utf-8?B?STlmUWkxRVAyajZVK2JYUEV2RnhuR0x1RlRJREZoZ3NnekNPbS9nbk5mbUtx?=
 =?utf-8?B?OGpLOXZEdW45ajJRWU0rQWtwK1VFOVBYZWNBYTJRR2YwVVpRT2ZXTTEvNjlW?=
 =?utf-8?B?aDRFZXlNOGw0ZFJZY29ES2VCMEVleXlsOWhVOTFiRWdkNjliL1R5VHBPTFgx?=
 =?utf-8?B?U3dBZEppYXFWR3BRZnFLek00TUVuT0NxRGxta2hObDkySTArTHJ4cVdNRTU0?=
 =?utf-8?B?WHRzVG5XejVZbHRQMVJDeFpZNXhrUFhpU1dZSTdFTkYxenc3V1BxalcwdDZr?=
 =?utf-8?B?YTJYZVNySUErNThYL3EycE1kTlRDeEJkRVRtVkE0bXlheHoreUxLcWdQekRC?=
 =?utf-8?B?M09HMkZaTzhzNWQyMWtUZEpFVW9BYzRUYWVzNVIrdHkxY29hbCtyeHh1LzFP?=
 =?utf-8?B?dUcrajZWMWZwREdwayt3RkI3aTdpNGNZQzFGU2V0eXRYcThENjR2ZXVsZ1lh?=
 =?utf-8?B?SE9NQStxQTdZR0tJaG92RFdhNnBJYXhmSHN0MlJLT0p5UVQ4ei8rbjlCUE9H?=
 =?utf-8?B?cjkyc3cxRysybkhMdTU1WXpBeFhIVXJ1MTZ1anQxWmJyVVhBejNOL3RNRUxN?=
 =?utf-8?B?cVpGbUNDSm9DN1FvSDdEY0dYY3diOGZxRitJME5oWDIveUF5amVyQlZnWWRu?=
 =?utf-8?B?V1lzc3JGQUs3VzRqMGZ6d1ZhajdRTnlhZExjQndmTm92eDFFVXRFMEVPUHBv?=
 =?utf-8?B?YW1wdHF2YWR4MjBZRDNheTlvS0FNai9INFFTTmpBdE53RzhMTmNCZXF4VHRE?=
 =?utf-8?B?NmxBSHZDZkUydkYrYkJQdFBROFNpY3J6YVE1SFJaVTNnd2JZYURHNU5SbVhl?=
 =?utf-8?B?cGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1TeWq0kfsLgwHSYYdFORBUGYH1fwIRdwS2InSFPRda0lDMI1afabo+f7Z5nmccDWgbLloISx604JjsGxyFGzjy1AnbnmgJggyxllsYUsh5UwENhf6BfOZ4GZN9tCh1COL9k+qw8EPNcddJDCd3yd/SMpAr+Ekm6M59dCfixmIPT8Nqq8YAn6iJcBfdBUkLXxogWSqdllvAzwCnk5b8vHmz0b2aImJlRPZpCNTohFEJYj7ShRX1+MpWEhUagDZDcQt4QLAx5R4E/oj4fKsNEL5lCuT0nmA6wFEAl6dq97ECel2Boc0OGAqBEPgR4bjM9LW+MlEPIqSNv2vj5pd6Ne+v3bvLsR9wIxlaSCSp66vaXZo8Bko7d9Rgyun5RSERoZWWrnOGShie2atE2uNGS2T6ehMk0CV1pc/nE2rqX1TwGsx7ErKiGxz82336oEEgL6w/Gd1b/PvdCb68gYWIyDd5e/lSo6v6R1SJ2JcJwGMr+CZD5j3bZJC5czwN/UKTMV8iCRWIoEpU+MGw2AuPbf80jPXFo4HzRwroPSzaOrX5MQ211PGnDUJbYOS0JfgaLKL6FXdsFE1eT2/3w57Nh2Oyetg0eW//aZwSG3Lywvkz0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24a036fb-e787-453e-1ea4-08ddd371e5d5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 16:13:49.9714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ynsentzVl6cVbx8sfupkJGnW2X0fTx0uEFcB3nenRGgV/pE0VxGSlxu+yOKwydYIaqskP3b4ufxqXabpo8W3T39hp26lqsv6oHU1lTWm2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFC3D93F6EF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_06,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040089
X-Proofpoint-GUID: cYrlBQ_oN2Cy35flVLCf3MGfJpNzdU24
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA4OSBTYWx0ZWRfX+c/wcAiL17gC
 UEbTncx6gtkPgTuzFNBZ4q46k+GUKnwRAay2wVAvDpNjWX+Pxo5eQ55Y4ufSdcB7ne2cMyXl1+O
 OxUjHe09EdXqr5xr8jf8FmgPTagH2oxarDEHCgfK1+DNFNg+Q121bZkdH3F2HEg/UIfmgiIGnFa
 DpAxlF+NkQJKtZm2sG21h2CBeLBdVxZ7MsxeCxtwg1Nt98IDmbvNnemnhmoQqEBYw0ahZn+mcYU
 L3AayCe/PdYD1WLFuOuQUjNKah4jctb4bOaY97MzGu/YkkiNc7ZOae2qf+EoFwqGr+cxRiBvymj
 1PYRRE6N5F4OtPdsCnVjZGlj+ahUItY09UITU6UPehSeMVll7eq6lKrHprxTPxrixaTKWNneJm+
 Nw7GsjbgRmC+Vmi6wlUKAk6EYlOURTjb5uNeVO5e+4tMzgqcb3HM02EOByTheUsw0Lf0kaGw
X-Proofpoint-ORIG-GUID: cYrlBQ_oN2Cy35flVLCf3MGfJpNzdU24
X-Authority-Analysis: v=2.4 cv=FIobx/os c=1 sm=1 tr=0 ts=6890dc44 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=KM4iBDCcdl3A2YbkZkwA:9 a=QEXdDO2ut3YA:10
X-Rspam-User: 
X-Rspamd-Queue-Id: AED781C0007
X-Rspamd-Server: rspam06
X-Stat-Signature: u7x7qzuh53notjwx1trb57je81m64ciq
X-HE-Tag: 1754324045-989717
X-HE-Meta: U2FsdGVkX1+QIao3CW/vU8k+YjjHdq0zojswI3d2nDYdmKZLQkwz+pm4MDrNTEK3K19ITmSaNnXp4C8edR3/Ijrzn314BuLF2O5EM61Rf5BSICc3lYRKlB29LjXx2j6uQurPkEfrJKbKcT6eD0U0+y1spkvY15vHOOs7WMOmHrMxGRjEy3SZDxGk8tdxRBo4Nr0c8wt1Jz7LvVkUfuOywhtLR7ND94vEBYheQdsiz/qw3YMSL6HCoPqNrzcCV3C4R6cVSb5ffYou4mjY05jREnCLlxZ5izk+KQMLSOSH8MHQcel+i+0jv/FzzjdfqmBMpy+jU0VMghbzFjoGa0TlrFEj4KBFMAAPmQ6PheIOxw9wDsCB4KVgs2R0wg5Aw2Dg70OBgFD8gmWZ6qAZJzYO9mmwYAPZQ8Nc2j2Pj0756bY1TrSJUm/5s37pTyh27OmB/lF386ssPf660e3bPro05pA5iyb5d4eHv9W+XFdlp9Xl9y4wqASLKk7TVnkgFnnGoRyoWTukTE1Rj/8Hjuc6ifI8x2yZKIMDkb93xSuMoMgcKowkU0+9URwd0GXyU5c5mFXlVcWxZbTFBkh6d0JzxOW78vB5fJdQenCOqlkPWSb0Z10eFFcZ5VGGMnf6f2oMQObEb+ZrzAeZoox43MD+XubXujcrPpv0UQgWlIbSkhCZuGv/DjX/zoOs9OkD5MO51VrBW3Igu3zXIs6TtFOHjFy0VBFaG9MvtjTw3WcsAhwOo3Ou1W35stQCrSVg1nPStXSrFc6kgesshY3nJ+vob+yM9QolofEZLb3sfspRZfYH+1wmYic1bIyjDWfIwt3c3EA+lgSKudUNV46oXfXmP6p+HQlLhmqjucgxseITDcgVMO3vY9CABFnoCp/1CBaSJCiizOBFN2PFMdqYPNYc40xShIei8RareceIalMj+1XpbO4dmT2HSrFMVMu/gMNpSndDS3fz8ffUEDjf8MW
 FbIPAaLQ
 1HsF5QC+9lkYmXHavJTVOh9IPU2yxgqOcvJgrOwuRm7uXTIOaKBEx0lb4VqcFLo22kYFWVny4qxSuCEgwtBuJdlh7D5aEze7Ul8R7+IdWeQP+FIeRnw+/Zex14cUGlEf1C1Wf2OZAjgCCUVOVdKxRMD8pv0IhwgY0wifNPI5I2/Ji+HqtpcnNNSuUEQweGUrZqy8lDjT6gyF62LV530q1llHVQjkatjZP85ECWGbo2vKVRzMEM3BC9XZ29y8T+NXZaIHrHmsEHKZNZESKEYcoDxAVpNCD5gVzUCdqBJUUlG8r8/GReCMTLpahaUvzoD6yN2s+8l2/XzfgioyX/baaSjbauhxGM6lvjvJz/zZNq1pst9HO3MKGTgUeao/ckYbYNQvOo1cYmlIEtLm2I4vZ/bPvdoC79CCzpJmRXE0sPT64CLmY0tK/Rl6MUyjpc7vAxUo3IxtwcEpjpDIGyNrCY5ioR9feHpL57LCAIDnvukh7gd0F/J9ehDJ/hHYih4GmC24Xpo4IGSZuVboZ3wsrOTGWfEM0PSc/D2qhubqUhXwn9H9kVT0loneEr/IaHI+W5DHGwkNwGTVkG3wcjBkyHjh71ML9JY9NhnYdYyvFXAgeN0iN6jhdI26VIRdf75YcUQVZb2X21CBiiW49PS9BgCZBRu+lEeX43ISWUCr7+wUdudujGYdM8+0JdXLgIw+rm4/uwZHWQmrmgybR18OtVTac3QTyF6+TyCgRP2ykB1o+qD2EuNCSizsMEcvebjqbL6GZJDxqxpNP0K/qrghdLjzyaMQ5asnFUOyhUmVK58JxT6WcTZ3j2pIAlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/25 3:31 AM, Kefeng Wang wrote:
> The struct hstate is never used, remove it.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> ---
>   mm/hugetlb.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e174a9269f52..b16011c9645d 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1896,7 +1896,7 @@ static void prep_account_new_hugetlb_folio(struct hstate *h, struct folio *folio
>   	h->nr_huge_pages_node[folio_nid(folio)]++;
>   }
>   
> -static void init_new_hugetlb_folio(struct hstate *h, struct folio *folio)
> +static void init_new_hugetlb_folio(struct folio *folio)
>   {
>   	__folio_set_hugetlb(folio);
>   	INIT_LIST_HEAD(&folio->lru);
> @@ -1982,7 +1982,7 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>   		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
>   						  node_alloc_noretry);
>   	if (folio)
> -		init_new_hugetlb_folio(h, folio);
> +		init_new_hugetlb_folio(folio);
>   	return folio;
>   }
>   
> @@ -3401,7 +3401,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
>   
>   		hugetlb_folio_init_vmemmap(folio, h,
>   					   HUGETLB_VMEMMAP_RESERVE_PAGES);
> -		init_new_hugetlb_folio(h, folio);
> +		init_new_hugetlb_folio(folio);
>   
>   		if (hugetlb_bootmem_page_prehvo(m))
>   			/*
> @@ -4013,7 +4013,7 @@ static long demote_free_hugetlb_folios(struct hstate *src, struct hstate *dst,
>   			prep_compound_page(page, dst->order);
>   
>   			new_folio->mapping = NULL;
> -			init_new_hugetlb_folio(dst, new_folio);
> +			init_new_hugetlb_folio(new_folio);
>   			/* Copy the CMA flag so that it is freed correctly */
>   			if (cma)
>   				folio_set_hugetlb_cma(new_folio);


