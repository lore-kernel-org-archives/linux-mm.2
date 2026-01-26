Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA51ECF65E9
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 12:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7DB6B0089; Mon, 26 Jan 2026 07:26:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182696B008A; Mon, 26 Jan 2026 07:26:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C9C6B008C; Mon, 26 Jan 2026 07:26:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E42396B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:26:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7AFE6C2458
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:26:14 +0000 (UTC)
X-FDA: 84374037468.18.669CF82
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5284A1C0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:26:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Tsc1/4Tn";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Og1O+KLw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769430371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPOgIAXRugpCIXNurezpzMRnb+k0l11osGS+EWH9Dfs=;
	b=PJNuHCYZRhEKB1JXtHOTMk++oUmMoySs7j6QpyIZ0JwZTd4HbzPJkJWMUgts2Zntq17j2h
	gk/HPGF+Ti9SoZY5V9P0+JOPva4VUbc2LVfKsPBE1prPbAOFJ4YgSWBGFwlm56TOUGxwMN
	75+bTsNh3l6AdjyTNFuA3fgdmJ5sNBY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769430371; a=rsa-sha256;
	cv=pass;
	b=XtRTw2mw/FL8yAAOgMRUrR76i2+2qkinTpqjWZfz5zHKtoLH+apFWgdwIdds6uKgRfjal0
	GMAfeR5aWUuBrwnexz0u5ph3sIeoqwX5gFqfAttbn4tD6lyEMpn11l3YRW+mGxurbZ7v/4
	SBbetURYnCV389ZAKsSynPC/uw8Dv/c=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Tsc1/4Tn";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Og1O+KLw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q3ZX2f679447;
	Mon, 26 Jan 2026 12:26:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZPOgIAXRugpCIXNurezpzMRnb+k0l11osGS+EWH9Dfs=; b=
	Tsc1/4TnWpzvQAwLYEAyJQafUsedfw8oE8AXReQiXCQzK/QTAfRRUuvGzX+Rq7ul
	TXePKUcG5k5IJLDNuOxSzrZ9O+pyQ17AfVbGB8CsaPUfD1InpYn3r+aWPSryae+c
	ZNkmY217D16PBesN91LZ1qZel8WEPK8uihnvyx5HkfuxUM23tTHvkGGUL73KU6QZ
	Qy7K8FD3ihZRUJtWHhwebhGq6OwZcJ1TAnE9eTJo6Tc2jRMJNYvB74qD/EKcnwA7
	ZlMG+mPR4RPT+n7YHpyooH5mUH3voHic5nB0BTScfDLUJ3GahMY7aDlE9rCn2KnB
	fKysvcFC+UETfsVEoDor4w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmv2sryg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 12:26:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60QC24XF012724;
	Mon, 26 Jan 2026 12:26:07 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012019.outbound.protection.outlook.com [52.101.53.19])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh7wa1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 12:26:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qrGGuimY1PY4ZYEb6CAY5LTikyFPiyOj+H7MN/Ajx38jiA6hNWzObyvVbnKkhLtpNjnkjfePm/CLDslk5PbI9ixTML411qHF+8mfkZMi1rj0DVEQlO0Dll4y+hOGg7rCDA/zo2LWVtW/mS1n21o6uGXk/JKDQOBhb4/tHStefCfolE7s1tUef6pS6BdLEHrkXhP90w8pbVpTieHhrN2t2HauVe5eGZIb/QDB+Bix7FqjC/6fTZRh8T6XhQYB3PZRq4GrrdB21tSG7TA0r1zVhZGMnhvb82YJJdqewaXulZ63mMLb9/y15hr6Exx4dQoU96c/szTs4g+UY1ikKLFtBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPOgIAXRugpCIXNurezpzMRnb+k0l11osGS+EWH9Dfs=;
 b=W/HpP8YDUq81Mv8wsSWVB/1QkW8npEY+2fA/POn+9/HRzDbeKEA4Rtd0byMlSPDeEmA3GrQVMHPX5IK1GxbVc2e+wJnNw6YWCjbRur3akqXRsHaWAh9QfyOXXaenaU8ro6WuTO/4SE0Idz3lu0TtbaBSQWyEfR56cdYXfpPairnGVMpiarURbGUA87V2dZOcVzemf7h7TMKPNEpcmGIa12uotivHC0+2qvq9L5eaNij1Fo3V6YXSuBYlvna9gxCDX82nxEhnJzUlKj4WKAY3+VU/xvDkhZ+FJJi7H++CBHm4kUt0fuZzvC14d2gS2c8ousl1sf+Wy+FOKDab4LehCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPOgIAXRugpCIXNurezpzMRnb+k0l11osGS+EWH9Dfs=;
 b=Og1O+KLwkC1vQdGbXYXwxCeVDVbty9OlBm09sr6zwDr87Uq7oMZTWCQoMd71lAeyGP3sgE0qgfdYlL71WcSFGp/ztdCwBGFHxogxSBtzoQ9T0y1clYdeUeV1B6dwxAkvgNwd3Q66KBCfKKdqLZ+tVMBnHLe8YBnkHRcxmfc1T20=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by LV8PR10MB7869.namprd10.prod.outlook.com (2603:10b6:408:1e6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Mon, 26 Jan
 2026 12:25:50 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 26 Jan 2026
 12:25:59 +0000
Date: Mon, 26 Jan 2026 12:25:56 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, "Garg, Shivank" <shivankg@amd.com>,
        akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org,
        matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
        byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
        apopple@nvidia.com, jannh@google.com, pfalcato@suse.de,
        jackmanb@google.com, hannes@cmpxchg.org, willy@infradead.org,
        peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, zokeefe@google.com,
        rientjes@google.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, David Hildenbrand <david@redhat.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH mm-unstable v14 03/16] introduce collapse_single_pmd to
 unify khugepaged and madvise_collapse
Message-ID: <93afe7f8-f288-40f7-9c9c-5ba1b269792c@lucifer.local>
References: <20260122192841.128719-1-npache@redhat.com>
 <20260122192841.128719-4-npache@redhat.com>
 <65dcf7ab-1299-411f-9cbc-438ae72ff757@linux.dev>
 <CAA1CXcDm75=hM_g0x7ox05nGrGykE8ry_+NbryYu=T+TY114MQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcDm75=hM_g0x7ox05nGrGykE8ry_+NbryYu=T+TY114MQ@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0090.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::11) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|LV8PR10MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: f4ea3c68-1e81-48e3-eac9-08de5cd61005
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qk1uM2Q4YitoZHhkc2Jwc2pxa1hjbU1XOXdWNVpyVnNnQlY3SzBqMU5yMiti?=
 =?utf-8?B?Y0JkTVdBb0hDUWRoazd0d1ppOXBPNDBLTnNTU01GRitJdlREVXRPM0xrV2R2?=
 =?utf-8?B?djZzellScC9qSXlWSnNwV0M2eDdQWlZDdVJMemNuRlRWN0Y0Si9hdjE2Tmpt?=
 =?utf-8?B?ZUttRGRneHZ4Q296bStJa040b2RSQmlRMms5MEsxOWFHN2xZeWRENkxvVnhz?=
 =?utf-8?B?NFlsbWVBZVkwRWR5RmZWUFdBTXZHY1VsVEwrWm9wcFNhNHo0d3VWV2Izc1dz?=
 =?utf-8?B?T21jcHZROVJRU3czUHNCa2E3dGF5ZTBTU2treENDbDJJWlkwNitoblhMUE1L?=
 =?utf-8?B?N0JKKzZZSmd5TUJsallnWUdkU0dZWHUra2xKVXFEWWNPSUpXNkJyZlhidGpB?=
 =?utf-8?B?Q2k1eGZXck84K3BjY0VQTXdmdS9HTVhSVC9XdEhVZWt2d2kwNXpMdkFxSlF4?=
 =?utf-8?B?NVk3V3NFd3RyMGtoRVM0V2h5MTBJSzNFVFZNS1EwRm5ua2gwa290a2RWYW1W?=
 =?utf-8?B?NFMwRmVEckpBdjA5Q2hwVTVtN1ZtOXRXbkxJM0tPVU9TcTdhTGhjUVcvbUc2?=
 =?utf-8?B?OGF6R0gvRCs0cG9CRWltb0VBd2dMa2M5L2JHTy9MbEV4NnhrVkJHT3FqZE9a?=
 =?utf-8?B?aWlsN0c4YUhJbTdsMURzQ2pNYTViRWp0WVF0czRQOU5mS1ZGUVk3MVRpcmR0?=
 =?utf-8?B?Q3NkVndmTm9RNC9pNmpLNkRhNGZFQzY1dW5PUkJScTZldFpNd1pud2pFVmtB?=
 =?utf-8?B?YnU4MWkxaHNLQUVHSmJBS0p2MTZjdTg4QXAwNW8xRjFUN0ZJb0pDdHRXRW9r?=
 =?utf-8?B?dXZVOURVNDB0UkxCaU1lckFoR3MyMUlBZms5Q3UxOTV1UzQ4RTRZbndnUzRS?=
 =?utf-8?B?dEp5WTBJM2d3Vmh3aWJPNCtqY3cyZUtqWGNWUnJUTTVEQS9Ra2cxK1hpVklh?=
 =?utf-8?B?L2Q5OXIrVjJFWVc1ZTVtK2syczRtTlprRm5wcTVzYndjNkpnQ1ZpbUhGaTZ3?=
 =?utf-8?B?VWlDZi9ZL2tWVk1OMmZlUGE0dWpGWWZ1ZFJzWDU3MFVuTXdEcmRmSHllUFM3?=
 =?utf-8?B?bVN6VUw5eFVhMkxZN2IxdEo5dnFWYzR2eWUwdUEvMHpYWmxoSGFCbGZDTkJH?=
 =?utf-8?B?d0VTOExMb2hDbjE4U0RWdTR5aXgvc0FLMThTN3pnYlpYemt6ME1sL0lSMUtW?=
 =?utf-8?B?R2NQK2Izc05nUUt3QlRSMzU5cnI1TXpKRkR1Q2l1bW1MV2xjS2dyb3lTYjUr?=
 =?utf-8?B?blFXcUxReTJGUTB5MnlrMEFWaUdhT1lORTk1U2xvNjZyS0tXWk5EbzRtbHFR?=
 =?utf-8?B?eENJMXp1R1lXdWt0ZEljVmpnQnVDOEtQb01ZL204V0hXNE5CNXVDa0RhRFNx?=
 =?utf-8?B?Z2RVRHFScWppVEhPNG9Bd0g0S3VTbHJSTVVnVFdYSW5xWnpzNkh6N2oyV0Nt?=
 =?utf-8?B?WG1lak52QmxKbWlRenVpVjVVaVpDdVp2eTRmU1lPVVBGazlpZ1dMdmVMSFgv?=
 =?utf-8?B?REd5TVgxaVh0cEY4YnlVOW9SMUxvT3BzSjJHS1hUcWVnY2lxeEZGV3ovNlU3?=
 =?utf-8?B?bUYyamJyNGxubUthQlF3dUZGVDVYKzUxQWF0WkJRQUN3YTdTcUl5c3I3Z3Ns?=
 =?utf-8?B?MWtkOFFVK29DRUxPL0FRaWJkYkNURjBIYndIcFVRRGtrd0dwb0ZwUmtuOWtU?=
 =?utf-8?B?WjhzbWhFTHZVWlo1MXp3QkNCUzg3anJTRFo3bzRkK1JYS01wcXZ5cGtmRzlU?=
 =?utf-8?B?ekFETzdBVmM0UkRIenVxM1dxdXcrZERzVlZsNzZoZFFsTDRYS1l0N0lnTzFI?=
 =?utf-8?B?aG8rMDRWcHBnbWovTnEvMUVCcXJhTXlucndrc3ZxN3JZWXJLOXU1eUhmSVhT?=
 =?utf-8?B?Uk91WmtHQmY5eG1nczQzNk9xdE9LaHhCalU2NnNIVGFwa09iUkxJUTFNWnRT?=
 =?utf-8?B?L2JHQ3hzN2x2OElxaXYvR2hEd0pSWERjd1k4M0xwOGlzMjd3RTJrakt3d2xX?=
 =?utf-8?B?ajFiSzZ0STcraExGZXlTdmxoMzNrY01IYkM0T080QUpTZ2toektWMEFETFVt?=
 =?utf-8?B?ZVhLSXVUOW1SK0U1VVNWR3J6OWF2UGovL3l4N0JseGYwMUFvbStvOG5OZUNw?=
 =?utf-8?Q?3eIwa5/Kih1RHfaIUooaDAGZu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0VlMWlxakd5Z1RXRW5TSFo4cHB3eTdCWi9ob2kzcVNRRzlEZTBidm9mMVN6?=
 =?utf-8?B?N21XVmVTTDV4djdUTnFTSVlIcTY4c3JveWFIZVd4ck5GcjVzWEsvUEJBTi8x?=
 =?utf-8?B?WTEzaGE1YS93Q0Y3RTFzQnVtR253MWNKMGw2anRpb2NCMkZrUk03UFZyT2lG?=
 =?utf-8?B?NkdKUjMwT3NMUTFvNm9sVVNpNFF1WHgyc043a0VVTEVZZzhXZWhDVmNuOFhS?=
 =?utf-8?B?RlVRVUdnajA0SnNObUZxREl0dTdtbHdJMWFxT05vMW8vZEo5T3hDU3hrRm1k?=
 =?utf-8?B?MkExdGZMc3pSTG02cDJkZXU0K0FHT3g3WncxdGR2WjBXL0U3UklPQzVxSlhN?=
 =?utf-8?B?NjMrMDRLS0x6eFVvYThNU0JHTTFGaEErNnhBamFXL0xwTnB4T3pzRUprYmVW?=
 =?utf-8?B?TysrZ2pjYTJQZllqM3Z3YlM0ODZCYkt1d1VnTW5nV3dvakNsRFN4V3UxSEEy?=
 =?utf-8?B?OVRrbmNIdEJRVENqZEZBcGwvVWRKVDR4TWcvRDVzRUpGR0dqVmYvcnFMQkVW?=
 =?utf-8?B?RE9VOGVETDRGOXJWdndUcW5OczBNWlZxcWlNemM3cVJJRzI0ZEpmYUVRcXhx?=
 =?utf-8?B?T2tzNVN4VURzV2lkZEJDNWhVdGZicnJnZkdFbWFYWnJobjF0RVo0cUFPSWtK?=
 =?utf-8?B?YnMwK25VZzAxNGFtbVMwTms4WWNCRGpXUXcrSWZMejN5Y1k2RnlRY2NpV3hw?=
 =?utf-8?B?cjhWM0IvYXFRQ3NQcWR5V0hmOTVINnNwUEh6a0d3Qm9VWjh6VVlXN2doTjg2?=
 =?utf-8?B?ODhFOS9ZU2lPZXhKM0xvNEsyWURGcFBTa1doQmFrUnkwK3hYanIrNFhwbnYy?=
 =?utf-8?B?Qk51SDQzRTFDaS92NGRaWkhrZk9GaW5jam9vZGhmOWdyT3BVckRNNWRtOWo1?=
 =?utf-8?B?R2F1RTFpczY1VnRwVDZsM0ZHOEdWRVJFUEdRNnRPUE9IR2hINGEzS291WWJQ?=
 =?utf-8?B?NGQvZ2JaVDhCSmFEa0ZSaXFlQnljOGhZczFQcG1XcXplQUJNRXB5M3Jkdk9w?=
 =?utf-8?B?amFaY2xVVFgySUNJckcvd0xBMTFOZ0Ywa3VuclV3dUtXc1drSzYrRE5BUFZ6?=
 =?utf-8?B?N1p3Q2NyQlQyU3hPTWtRN1VqSTRtSDY0K3BvSUIxQzd1aFFTNy9lUjg0ZWly?=
 =?utf-8?B?VWdXNXdxM2c0K1BrclpXVWxXSzhWSGFqOCtXdHYvZENKdUs1N1p5SVU5UXVQ?=
 =?utf-8?B?Y0taN1RTNDAvQ2dMeWxPSXB1Q0pNd2t0UGJHQ1lqakFyN213NlA4REpaVVFG?=
 =?utf-8?B?WXROdHdUN09QaDVDNXg2dEpmQnBvUUl2cDdEelpQbkJCVDZKaTFOYTBOeEVG?=
 =?utf-8?B?dW1rTmlheXZPWTlSc1lBR2V0Qk5ZZk44eUhtVHBEdndVNzdDTEFHRmsxc0lS?=
 =?utf-8?B?dGw1T3U5TkdpdnZMNjVNRit6SkRHbWZ3YjhhdEpXam5FTUlRQkpDN1FTRXNQ?=
 =?utf-8?B?Tnl1TkZuNkJiRC9kYVo5SjNDUnRCVEI1V2p0QmQ0dWdmUXRybmVndUhlR0pQ?=
 =?utf-8?B?ek9xZXRWRUJYajRleG5YV1YxU2tlOWpaa0hrWUw3blNJVlpKYWVBSXNFQ2lt?=
 =?utf-8?B?bSswRGQzT2xRK01EQ3ZBNjB1R25UN0dhZFRCamt0UEQwTndDVERTaDRCbmpH?=
 =?utf-8?B?dGxUVm5OUFV0T0NCcWcwV1lhek1IbmF2WmIydE4vZldPT0pqc2tndHI4RERQ?=
 =?utf-8?B?ZXdOTjg0VXlOUHpZTzFEMFZpdUhORjllVCtpQUVOMWhvSVYyK2JhYWFwdmNB?=
 =?utf-8?B?aWZFL3IzdlQ1M1JpRm9PdmRucE5IOEFGajRQWlV6T1JMZG1WeWhJVjR0ZTh4?=
 =?utf-8?B?UXQrcW5qWERHOU1VNkt5MzRUVnBQcllsU0ZVVTB6TkZZQVh6R3YrRks5dFRI?=
 =?utf-8?B?Y1pRbEpsWVliU0NGR1ZXczJWeXRnVFZ3Mm1lTXFXcDd1cGV3M3pUTXZER1Ev?=
 =?utf-8?B?d3hJVHdqUEc0OFdOU1hraDc2UkpQUlpPL3JZOE1Yek9tNkN1cVB6b21iNk1M?=
 =?utf-8?B?UmpzeEVPcUpkdTl4N2RqeW1KZXJnbXQvUVZUZDFrU0QvZytZaWdEUzdmdVcy?=
 =?utf-8?B?M1lyVndyN1FKdWNTZFJMb0tWUU16MmxMYUsycW1Jclc0Zis3VUNqNzVNS1RZ?=
 =?utf-8?B?RlhwOVgrRnk5cjFyZEFRTVptZ3dMZy8ycGYyOHZwRUNrNGpkTURZSDY4bEk0?=
 =?utf-8?B?V1JvWVRFcU5LL3liQWxVby82MVlDMFJObXI1ME0xd3RVdkRQeTQ4NXlSa2Ft?=
 =?utf-8?B?VTU5c0dXeXQrdVpUSDhUcFhOZzVDd2xhZmJMaFc3eG5tdUQwYkltUlltbWg2?=
 =?utf-8?B?YlNucFd2Ly9iTGs0SGJ3MmcwQXVWaFR3bjE0YTBydTRQVkcreDBaMXJKMTI2?=
 =?utf-8?Q?7cNegj6W6+FAfVTc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i4w2CRmJc0jQy0UqpEEE3YFHt35noFj88fTtTT2Q2Znj6rmnQV0KfE/sBNUFfjed4LZu0PxN7bSrdnwjc+s7nwzeHUYfEiPXZfFTDQUP9VoSqOkN/Tf3VRcbkxW4sC7LF3xW3nqb6dGhiqxdt67uHk9w3ddcJu3OFHScvxgdZPc+0yc2XeXWrT4sMfiqCVSI1MmrTMCx+GYxAE6DqRMLOcKJvpMy91DScenkQ+IOPRoCIhlaJkShxhqh9JzhBJI4w3mDzOKXFLxvTy3ArqiqtNXLrQnwjtrBt8SgM9YaJY8oLRYmSvhHbSjB2Rofi4S8XtB1t+d5bgFF5j1WXBhYPO2bp7HpHIqI71XGMLW+mMJWmVbZfiSnLhAfLvFtlaY1c+2JSmgAePWb744hixW5Hx74ZtLgr1hAOHIKWRpamT3ze0VJSuHi07dAuSBmzTxWjQ3dTj4BoN295D+s8vdnwXx9Yw933Rn9ygxtofuZVpI8vfjj34uN+ITW2p3Iow44tTVMBjgxIMqbzHjhFz8C123y7yZSf1j5Fhr/EL2PWP3Op2w2qc/wmhaXYUTaAtbyym5rhCF6Euw0YtWaAR1aCflmgEh0K5VqEXJ4Rpmiz+I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4ea3c68-1e81-48e3-eac9-08de5cd61005
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 12:25:59.6345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C8x+Xk2mFhJCEDr71yhxolteuw+UOG/u7MaQRXxSGt1JLIq5g/qWXUWDsCvF3XYi68rZut5MnlkAdh7o1NHs6Zr4WfS0rC3PP24MovbYLRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601260105
X-Proofpoint-ORIG-GUID: kUqiMnh_RsHsUWUe9P-F06e9jbobXj0Y
X-Proofpoint-GUID: kUqiMnh_RsHsUWUe9P-F06e9jbobXj0Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDEwNiBTYWx0ZWRfX/NWpHdFF+bSX
 jisPqTtCkBbWTNFhULRnyTG6m0uSDnXtjjfgNH+2kAajcFAQWoW+kp7xPbIMBhxCkCa2Jl1xG+R
 BewpJhKByKZwAH3sFBqRTzQ91bCwOmSkgTgnZkjxCuUJyL4eei8P/VeehjxGR1W2esyCOY94VRh
 WFwSYLarA2onhy3/uBNqPIG7iqKcEf/B9aeuxCx6Bu+bQ+B5ohQQ/cUurKFLHPPeETiKrrnCAKI
 wgSTLtxzjbsjT1SbBIKoz/vogo0D3OOEOKK64um4us88UC0LrFBuw8NUWW/8NwbqX9vBveD6/uC
 aX1RJkLpteZ4HDpKj8Dg1dypnmEd9JLl1wWJXs6Tb7CJumg95MZEhQsAsQllGd/lNCDmLMfRuZI
 WfrCw9xqz3qRBv4KAYy3NP3fznGxudL1bPKpxkCeyR9fF3wG9YfeaeaFXTjlQz0muLS93lc1Y6x
 Wj0UoWOFaWX8sJ8pXWQ==
X-Authority-Analysis: v=2.4 cv=cPLtc1eN c=1 sm=1 tr=0 ts=69775d60 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8
 a=SRrdq9N9AAAA:8 a=Ikd4Dj_1AAAA:8 a=VePcBMO8G7lZEwpRzy8A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Rspamd-Queue-Id: 5284A1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gntxc7jfhhjbf8wtqsze8m1w4m9644ei
X-HE-Tag: 1769430371-409695
X-HE-Meta: U2FsdGVkX18unAZK+cCQgvwfWls9fHEbD5NEXE/nPvqBD9eJNor2X+0+CRmr+mIn5NJi2ELac6ibnSA3wj9pg4Zh7Lerb4UiJgKoD0DHMDNqxQJRRNbz9fudKyIBEMFOnB8a2SK5u6ZFvdh0OtFUfyUB0AqLTtMuc0gwRvnQwg021lHy/buJHqoYDIrR3W2XYPeYwb+3qDwO2MYOujv7tY53owmQ+zoeH7t10C9nLVBLXg8k4hvAyntOYQwjgtdEbRM4zgn6rGk6mjnyoseKyMkr9SjHC6Qgpbohj0kd5ah2bKmzScQDtGl7v3+hvwi6ij/HVQtxa+vThvSRhdJkjE0VVIt08c2Lp5Xt0JTJ9nfGSsug9Q6v/XpVaPgO8yeNuyI3DiNFFpLIvT0jGTxlxRLpfg+g8IoxIzy3/Fs4QIou33hltM2uw32Z92p5Jz4gWdEoXE16oNSRxFR63qLVVx1MM8YCARa+BZfIbaJ2g03Zb7PQeSjcNY0tTOX1VcDqq9xHySqfSyviGJBLYB6TEmBd+SRRBgNS+z+p7UL57ES907g2kWGGIZtckPjkzDh2aowXoHNR+etyi1LrOHSr61Wpmz0mt/Hzes/E2kX+2pFQat0ILC74c90q0naFdQXtut7kiD46ClMKgT5SNEJweeeoaco73pukJMNtmXaf+aHAGafwGY0pHDmu93R92yVYM9mrqhyuh3uBThVjziR3MGzGY7IX+A/YyNCj/137v3421xtws+GUxrG/81puxdfVxvM+GNgp3Sc6sqnuLIZKMcbUzQFpJVCzYrf4J+crkkTOmP8nfM6UPI0FBMUBInuw3SAYQWWw2z+PZ31fL1EV5AR/MC+6WIN5V/kOkUfEYk2dLcXvWzlC6YlaYFuykp4P8CA1s6QmXKzCuEyh2Sr+iFpbe8mnDlMzubcELUG5k4XbVMu8awEuGLWxPnRCFz12B3bn80Ik6TaHDMIaKFH
 foDRc5yI
 KJOB0xxiD5Rvi70lkRyrILA2rSg0t0OelJL3pRC15EYMp10Jvr7gBIcoOhq4I/N2n8HvbRVe6RUkPKObmLwjwn3ChS9TU4J6SQ+bL9LsJf/8TN/+hYaPI7nVFfIyf/pau5o/Y46RE5Be8W12vv98+5xvs/TrIXQyISTd2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 04:26:09PM -0700, Nico Pache wrote:
> On Thu, Jan 22, 2026 at 10:08 PM Lance Yang <lance.yang@linux.dev> wrote:
> >
> >
> >
> > On 2026/1/23 03:28, Nico Pache wrote:
> > > The khugepaged daemon and madvise_collapse have two different
> > > implementations that do almost the same thing.
> > >
> > > Create collapse_single_pmd to increase code reuse and create an entry
> > > point to these two users.
> > >
> > > Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> > > collapse_single_pmd function. This introduces a minor behavioral change
> > > that is most likely an undiscovered bug. The current implementation of
> > > khugepaged tests collapse_test_exit_or_disable before calling
> > > collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
> > > case. By unifying these two callers madvise_collapse now also performs
> > > this check. We also modify the return value to be SCAN_ANY_PROCESS which
> > > properly indicates that this process is no longer valid to operate on.
> > >
> > > We also guard the khugepaged_pages_collapsed variable to ensure its only
> > > incremented for khugepaged.
> > >
> > > Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> > > Reviewed-by: Lance Yang <lance.yang@linux.dev>
> > > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > > Acked-by: David Hildenbrand <david@redhat.com>
> > > Signed-off-by: Nico Pache <npache@redhat.com>
> > > ---
> >
> > I think this patch introduces some functional changes compared to previous
> > version[1] ...
> >
> > Maybe we should drop the r-b tags and let folks take another look?
> >
> > There might be an issue with the vma access in madvise_collapse(). See
> > below:
> >
> > [1]
> > https://lore.kernel.org/linux-mm/20251201174627.23295-3-npache@redhat.com/
> >
> > >   mm/khugepaged.c | 106 +++++++++++++++++++++++++++---------------------
> > >   1 file changed, 60 insertions(+), 46 deletions(-)
> > >
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index fefcbdca4510..59e5a5588d85 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -2394,6 +2394,54 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long a
> > >       return result;
> > >   }
> > >
> > > +/*
> > > + * Try to collapse a single PMD starting at a PMD aligned addr, and return
> > > + * the results.
> > > + */
> > > +static enum scan_result collapse_single_pmd(unsigned long addr,
> > > +             struct vm_area_struct *vma, bool *mmap_locked,
> > > +             struct collapse_control *cc)
> > > +{
> > > +     struct mm_struct *mm = vma->vm_mm;
> > > +     enum scan_result result;
> > > +     struct file *file;
> > > +     pgoff_t pgoff;
> > > +
> > > +     if (vma_is_anonymous(vma)) {
> > > +             result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
> > > +             goto end;
> > > +     }
> > > +
> > > +     file = get_file(vma->vm_file);
> > > +     pgoff = linear_page_index(vma, addr);
> > > +
> > > +     mmap_read_unlock(mm);
> > > +     *mmap_locked = false;
> > > +     result = collapse_scan_file(mm, addr, file, pgoff, cc);
> > > +     fput(file);
> > > +
> > > +     if (result != SCAN_PTE_MAPPED_HUGEPAGE)
> > > +             goto end;
> > > +
> > > +     mmap_read_lock(mm);
> > > +     *mmap_locked = true;
> > > +     if (collapse_test_exit_or_disable(mm)) {
> > > +             mmap_read_unlock(mm);
> > > +             *mmap_locked = false;
> > > +             return SCAN_ANY_PROCESS;
> > > +     }
> > > +     result = try_collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
> > > +     if (result == SCAN_PMD_MAPPED)
> > > +             result = SCAN_SUCCEED;
> > > +     mmap_read_unlock(mm);
> > > +     *mmap_locked = false;
> > > +
> > > +end:
> > > +     if (cc->is_khugepaged && result == SCAN_SUCCEED)
> > > +             ++khugepaged_pages_collapsed;
> > > +     return result;
> > > +}
> > > +
> > >   static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *result,
> > >                                           struct collapse_control *cc)
> > >       __releases(&khugepaged_mm_lock)
> > > @@ -2466,34 +2514,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
> > >                       VM_BUG_ON(khugepaged_scan.address < hstart ||
> > >                                 khugepaged_scan.address + HPAGE_PMD_SIZE >
> > >                                 hend);
> > > -                     if (!vma_is_anonymous(vma)) {
> > > -                             struct file *file = get_file(vma->vm_file);
> > > -                             pgoff_t pgoff = linear_page_index(vma,
> > > -                                             khugepaged_scan.address);
> > > -
> > > -                             mmap_read_unlock(mm);
> > > -                             mmap_locked = false;
> > > -                             *result = collapse_scan_file(mm,
> > > -                                     khugepaged_scan.address, file, pgoff, cc);
> > > -                             fput(file);
> > > -                             if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
> > > -                                     mmap_read_lock(mm);
> > > -                                     if (collapse_test_exit_or_disable(mm))
> > > -                                             goto breakouterloop;
> > > -                                     *result = try_collapse_pte_mapped_thp(mm,
> > > -                                             khugepaged_scan.address, false);
> > > -                                     if (*result == SCAN_PMD_MAPPED)
> > > -                                             *result = SCAN_SUCCEED;
> > > -                                     mmap_read_unlock(mm);
> > > -                             }
> > > -                     } else {
> > > -                             *result = collapse_scan_pmd(mm, vma,
> > > -                                     khugepaged_scan.address, &mmap_locked, cc);
> > > -                     }
> > > -
> > > -                     if (*result == SCAN_SUCCEED)
> > > -                             ++khugepaged_pages_collapsed;
> > >
> > > +                     *result = collapse_single_pmd(khugepaged_scan.address,
> > > +                                                   vma, &mmap_locked, cc);
> > >                       /* move to next address */
> > >                       khugepaged_scan.address += HPAGE_PMD_SIZE;
> > >                       progress += HPAGE_PMD_NR;
> > > @@ -2799,6 +2822,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> > >                       cond_resched();
> > >                       mmap_read_lock(mm);
> > >                       mmap_locked = true;
> > > +                     *lock_dropped = true;
> > >                       result = hugepage_vma_revalidate(mm, addr, false, &vma,
> > >                                                        cc);
> > >                       if (result  != SCAN_SUCCEED) {
> > > @@ -2809,17 +2833,17 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> > >                       hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
> > >               }
> > >               mmap_assert_locked(mm);
> > > -             if (!vma_is_anonymous(vma)) {
> > > -                     struct file *file = get_file(vma->vm_file);
> > > -                     pgoff_t pgoff = linear_page_index(vma, addr);
> > >
> > > -                     mmap_read_unlock(mm);
> > > -                     mmap_locked = false;
> > > +             result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
> > > +
> > > +             if (!mmap_locked)
> > >                       *lock_dropped = true;
> > > -                     result = collapse_scan_file(mm, addr, file, pgoff, cc);
> > >
> > > -                     if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
> > > -                         mapping_can_writeback(file->f_mapping)) {
> > > +             if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
> > > +                     struct file *file = get_file(vma->vm_file);
> > > +                     pgoff_t pgoff = linear_page_index(vma, addr);
> >
> >
> > After collapse_single_pmd() returns, mmap_lock might have been released.
> > Between
> > that unlock and here, another thread could unmap/remap the VMA, making
> > the vma
> > pointer stale when we access vma->vm_file?
>
> + Shivank, I thought they were on the CC list.
>
> Hey! I thought of this case, but then figured it was no different than
> what is currently implemented for the writeback-retry logic, since the
> mmap lock is dropped and not revalidated. BUT I failed to consider
> that the file reference is held throughout that time.

You obviously can't manipulate or reference a pointer to a VMA in any way
if is no longer stabilised, that'd be a potential UAF.

>
> I thought of moving the functionality into collapse_single_pmd(), but
> figured I'd keep it in madvise_collapse() as it's the sole user of
> that functionality. Given the potential file ref issue, that may be
> the best solution, and I dont think it should be too difficult. I'll
> queue that up, and also drop the r-b tags as you suggested.
>
> Ok, here's my solution, does this look like the right approach?:
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 59e5a5588d85..dda9fdc35767 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2418,6 +2418,14 @@ static enum scan_result
> collapse_single_pmd(unsigned long addr,
>         mmap_read_unlock(mm);
>         *mmap_locked = false;
>         result = collapse_scan_file(mm, addr, file, pgoff, cc);
> +
> +       if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
> +           mapping_can_writeback(file->f_mapping)) {
> +               loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> +               loff_t lend = lstart + HPAGE_PMD_SIZE - 1;

NIT, but Let's const-ify these.

Also credit to Baolin for having suggested taking the approach of putting
here! :)


> +
> +               filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> +       }
>         fput(file);
>
>         if (result != SCAN_PTE_MAPPED_HUGEPAGE)
> @@ -2840,19 +2848,8 @@ int madvise_collapse(struct vm_area_struct
> *vma, unsigned long start,
>                         *lock_dropped = true;
>
>                 if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
> -                       struct file *file = get_file(vma->vm_file);
> -                       pgoff_t pgoff = linear_page_index(vma, addr);
> -
> -                       if (mapping_can_writeback(file->f_mapping)) {
> -                               loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> -                               loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> -
> -
> filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> -                               triggered_wb = true;
> -                               fput(file);
> -                               goto retry;
> -                       }
> -                       fput(file);
> +                       triggered_wb = true;
> +                       goto retry;

OK this looks correct I agree with Lance.

Could you send this in reply to the parent, i.e. [0], as a fix-patch and
ask Andrew to apply it?

Can then review that there.

[0]:https://lore.kernel.org/all/20260122192841.128719-4-npache@redhat.com/


>                 }
>
>                 switch (result) {
>
>
>
> -- Nico
>

Cheers, Lorenzo

