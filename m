Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 472D1E81A36
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9785B6B0089; Mon, 16 Feb 2026 10:21:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FCD06B008A; Mon, 16 Feb 2026 10:21:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C166B008C; Mon, 16 Feb 2026 10:21:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 606626B0089
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:21:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECE068D105
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:21:08 +0000 (UTC)
X-FDA: 84450683016.06.E13BFBF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 802E740016
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:21:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NLhrQkGW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EHV8k+du;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771255265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2A4ZBTPywd5tP+DbRmrl2Ek10KXvfpMhjo3+uPLz32M=;
	b=nHjTM1gOKgX47re2uJ+5Khi59zlky7OYJu4od3o0cpuLR+oTkE5SnDVd0mzGjhljiR+mGF
	CoPdF4IObxH8Pgg5RhHvZ7O1L6tX8d8/RA3qEKUc1dVrwIAdehpgpzHY+d3LSNGRiQ6ASp
	9lJHzHDUu9aOTTW57tcIR2j00LU275Q=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NLhrQkGW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EHV8k+du;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771255265; a=rsa-sha256;
	cv=pass;
	b=0vzpRm2HNJhWOPpcBYfiyovQm8eLdAGp9zVG18aZlnbbfoXkhIHWdFdD+pJJ3b7LbwXkr2
	LWhSJqgEGA0yNIw04NaPYtpDRJ0IvtrDywohIUCRkc2zotmn40zjNj0wznozs9kMHc7Owx
	AKl8F0J3mIQ5jGCkzf0MgOyIlHMJ5vs=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61GET6IC638622;
	Mon, 16 Feb 2026 15:20:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2A4ZBTPywd5tP+DbRmrl2Ek10KXvfpMhjo3+uPLz32M=; b=
	NLhrQkGWmV1e/NN9fJhNZEfpMOAIfOgGWJUrDNJo8VGMynqPYfgcoK2YrkbR0/q7
	TpMF7JY3zpr6p0vkSk+qkDfDxsGRCvG37XnnGFnEqUIFfvkau+WHHS3P+sHpPZBV
	RhWLEH+wiMkdAzNUVIyCnE/R5wWnBfO4632j1lZfKtWmvisvg6DKFPnNLXuymDj5
	Q4kvWY8gzez3nct5JoOMpEW8baITKbKFyMWfhU1CeD56bwL8EHDt7eYDVjzZUpQQ
	X7YApD2he2AxmtClB1cpiE1N75kwX7NJm0o7bWgvVXWwZqIhxlwCbBS6fFRqVwzn
	eHWi3y1/nivgYBzTEvCYHg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj6ma7t1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 15:20:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61GD8gVG033555;
	Mon, 16 Feb 2026 15:20:40 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012069.outbound.protection.outlook.com [40.107.200.69])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cafgcg5yg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 15:20:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E50ohLkXjL8whciCDYFMSNIJjESGj2wkUkn4tWgdXl5p3bAdnyMZHvtqXmvA5BPUnGcJrfZyS3V649L+EacJFWiL7VHxYaGOno30NLUh6n1q4ToTJgLtn3yo//dz/rmgr/CdF2Bw8k3PaF6MNufsVHvO1ABv5c/R6OEOJtPebtx2/B+kH5So+vIvA3E9nF5+Kg/BLBxRS9h/1shh9s+PnwrdKgibqSZKiurCAbqJEJxFggokLIx8LU59uOJkIm7ePKK22f/i4YFMJXyldfRTh5WOTkJqyEzT8s/M/FpvfeE5mQcRfcAGGJWF9RrrkpnhCFEYDfFRa5x+/Hs6c0zzcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2A4ZBTPywd5tP+DbRmrl2Ek10KXvfpMhjo3+uPLz32M=;
 b=bK7kYFXH1kilFtW2ZplWhlaR95AxQoYSjJuhX1Tsfgs/XGC1y+AaNYX/oYZIrJevvpj1gZvnjh3fRY3gdT1D29t4SbcFZ8rpkXYqlKJAz5wPPymFTZSeByxVFwhDzd1D+NH5ee0F1gGeld4Ws/bfdYCvYuVtQsrrNU/oEOHcWQgprtn1buxhZj+D8ld8c5BLm7NlOqJgCaa+3qZB4RIC05bsC2G+YX5xo7IdvpP5BWfL7gQ0c7139Fey6DiA2IvDQElpUdYYuZenV4ApoikWLEhRBp8R3dGFPUG0XL6ZepL2KcfoZzycB6r76D8Hqa7/PRLUaeTDKrBTRKpSd+y+4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2A4ZBTPywd5tP+DbRmrl2Ek10KXvfpMhjo3+uPLz32M=;
 b=EHV8k+ducnR0eLk0slREk8cDQOVRHQ4ls6Jbqf1R/w5JV3lXyBNlNwlegBm/DRAOgASZd3WprnT8cgguaft+tnHnqCDIn0NSKMUgHGPHYAwTL9HxjlSdXwAwL51uW9/zXzJXs+vGdh59eAeuuHKjyQOjdA6FteJX6tBwqLn2eiM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4782.namprd10.prod.outlook.com (2603:10b6:a03:2dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 15:20:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9587.017; Mon, 16 Feb 2026
 15:20:33 +0000
Date: Mon, 16 Feb 2026 15:20:31 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
        joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
        gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
        jannh@google.com, pfalcato@suse.de, jackmanb@google.com,
        hannes@cmpxchg.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, zokeefe@google.com,
        rientjes@google.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com
Subject: Re: [PATCH mm-unstable v14 08/16] khugepaged: generalize
 collapse_huge_page for mTHP collapse
Message-ID: <1e7f2456-79db-4096-8bbd-aafd9acd8e0a@lucifer.local>
References: <20260122192841.128719-1-npache@redhat.com>
 <20260122192841.128719-9-npache@redhat.com>
 <599ebe0a-086a-4701-b797-dcd801ad02fb@lucifer.local>
 <CAA1CXcCCbiV9j+_SVNJrkfVRqKPXjGg+Lt3YnyNUhDHWkRjHGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcCCbiV9j+_SVNJrkfVRqKPXjGg+Lt3YnyNUhDHWkRjHGQ@mail.gmail.com>
X-ClientProxiedBy: CPCP307CA0005.DNKP307.PROD.OUTLOOK.COM (2603:10a6:380::14)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4782:EE_
X-MS-Office365-Filtering-Correlation-Id: f34b2a41-1b77-4d27-3dc4-08de6d6eed4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TjlGSDdMK3BydTE2M3FOOVV4U1Jwd2YzMllOd00rK0NQclN5RnFkaWFYVUh2?=
 =?utf-8?B?T21RYkJmZ1o3dWU2SFhEcDlzNSsxSUs4S2pjZ04rSGFkZFdKUWRJeXlLWXJh?=
 =?utf-8?B?dlRDaDJtbW9zS0FNWlppM01lYktic0pXRThIWmUzOFF2OW9wS0YzV2xHR0V1?=
 =?utf-8?B?UytmQTRHdTBvenkyMzMreGhUQW5kK1luUTRERUZwV3dvYjQzZXJtRTMxVE1D?=
 =?utf-8?B?elh5TXhwQ1ZmakdwYkpkUjlUdUZLTHl2TzQxaHFPZWZDWHRteWt1K3lyRU5u?=
 =?utf-8?B?aWZTaCtrZmhsZXQ1Y3R6Q0grRlRuMzlweWMxeFV0aVVGRmtLSFlPTis2aER3?=
 =?utf-8?B?NU0yUTltZUlta2c3SlU0ZjJaM1JGUG5mYmZvWlEzUmphbVBtRlpmSjExRjI5?=
 =?utf-8?B?YU9aMXUwSHpPRmM2NCtnWFVZclRlaUJIUEFzci9vWm1qeUtZZ3hLWE1IdUVu?=
 =?utf-8?B?WnJMbVlIbWZFWnRqQVB3cDdTbnMrQmxnQVhsTFNjbjhXTW43RTZ6NWhPekJk?=
 =?utf-8?B?MzdrOVFqUFpUbkU2MDRBQ3I1UXBtUlRVMHlQSXppQUdraWlRa0huNlRWMzZC?=
 =?utf-8?B?M0J1TkRnS3dhS1g1QnUxY1JLcXdLVlR5dmZEUU05VmNta214UEpUK3NTamxh?=
 =?utf-8?B?WndLOEIxYnpqS0VpQkRNaW5jKytNell3OXpoWjF1WXA4NzBXT1F2NzE4SVJq?=
 =?utf-8?B?alFjZmp2THVBcm5vdXBnb0lqOERabTFIc2RiZms2dUJXaW9rUWhaTytXU1I2?=
 =?utf-8?B?Q0xDU2pRTkFNaGdtT1MzSVB6Tk9kY3pReEJJbXlLbDUyT1JRT2U2TW9idFhx?=
 =?utf-8?B?Z0IrRzMydENKeU5NekRjTkZKZWxUQ2JiNkg5V1ZUY3R0N2xkbUU0YlZOM1gy?=
 =?utf-8?B?YWMvL3hHSGszVmdjM1ZFUUdLOXBaVDJPbVZQL2p6aTBwMGhuRWREVWxlNDBB?=
 =?utf-8?B?ZU50OEJTMUpEaEVJbjVaQlVnV1E4aVNCaFZTbUZWaU9RY25mRCtJMkZoWFB6?=
 =?utf-8?B?SVNqZHFvSzBvNFh5V3gzcXNVR1Rxd3A3S20rQm1pNHhkVXlGTGhqeGlBQzNI?=
 =?utf-8?B?RjY5SWJpYXZRRDdYMTV6OHBOTjdIZS9VT1pWb296N3V1KzBnWHdzT2lBS0ZI?=
 =?utf-8?B?UkZZdWxZWUlhK2g1L0pOS1kyckVCc0U0aUxvZ1BpSDV0Q0NlQjF5MzRPT1lv?=
 =?utf-8?B?cm9zcld0RnZDQzN5dDlJMXF3Tm5ScWpJV2p2SFFNMVpERHVhVnlUMkdvTkNI?=
 =?utf-8?B?MCs0N0VtZ2QzcVdrQUZOZmRtTGpVQTRwdE15TzRpdnEwZ2h6RkYxbk0za0Zi?=
 =?utf-8?B?K0FNZUdaSG5QbCtqdnMydTM0bnFwZ05zaGdKc29mRmtDR2FOUGU1dXlScWgv?=
 =?utf-8?B?MXVkUnJMTnJoaEphZDd5dCtDandSTHhscFdZanl6dWxxK2ZzSjZiYXF5KzJS?=
 =?utf-8?B?ZHNCcFh6TjFBSXFYZDNkRllCN1czOWJZYncwOHZ3b1RldjZxZGYvdkJqQzVv?=
 =?utf-8?B?Zzh0RnhRU3c0UWdBbkpVZkYxTXk4U1ByTEZrb0JCMXpEaWJLbU5RNUlMQWZl?=
 =?utf-8?B?cTgxcEdhdFVmMDBBM1ZmUDZHVDhQYnQvYUx4R0FVWi9Ha3Q1Y1IyU0lTUk9E?=
 =?utf-8?B?ZlFYNmNnNmszZnRXRlIzMUVxVmZOOFVIdVZCMjZqTmZ2WWVnY1hPYkJ3SzVo?=
 =?utf-8?B?VlV0WGRObFB0RzJNTi91OW9sZWMvVzBOQjRqM1YrdU1xOUdpcEtsZ0piWWRw?=
 =?utf-8?B?L0QvaG9VdWo1anRKK2ZKSHFwb0REelo5aDRjK2ZsZmE3bjRVbllpNFRFSHVD?=
 =?utf-8?B?YVZLRkJvUmlzVW9VWWxVdlZzbTdpazlNeWUrRy9DYWNzUWE3WXF6K2o5ZWND?=
 =?utf-8?B?Y3NsYndMbUlXK2RqRnJwMWUzNkhtd29hazlVK05sOFlpWDBtc0hGUm9vazFu?=
 =?utf-8?B?eFV4Ulc4N1d4blVZblRhS2FlTTBjSXNKdzUzaEk2ejlaeXk0djN2YmVvMWc1?=
 =?utf-8?B?UzNJeFppZk1uU0dEeWxEMnpIMThaZm4ybExESnpocFlTYlV5ZUNPKytJcG45?=
 =?utf-8?B?SFFpTmpUZkRmOHRKbzF2SHlISThYaGZyR3hRNENvdmdoV0VUSVNHVWtjN2Vt?=
 =?utf-8?Q?tglo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejB5NVlpaCtvUjBZTU5KNHNud1VGeHNMSUJCMjJvVmNNRjhKVXBDVTJENmM0?=
 =?utf-8?B?OUgzOS9DTFEzTDdEN2MvS3lKT09GcWpEQVVRYkJFZFA1M3A5QStCZDNhbzA5?=
 =?utf-8?B?MHllK096YXZWVzg0MWt2bmNxaTRKS25NQjFXelFUYjJZZmN0Nm1rZEZXSmow?=
 =?utf-8?B?QmtMSmlZMTViVHlqTjdzcUgzTEJXWWtjbHc4KzFJQXp0TlhlWXpwSkY5R0x0?=
 =?utf-8?B?MmdOSElTNXNPamMvdllxaXN2Sm9jalFaRVIwVkFqSG9MeU5FdThuQ0VmWTQv?=
 =?utf-8?B?eVZTdUhrWUU0Uy9JRmJqcTZMbkVhVlVuYy9aV3JRTGdUQVZzNXpmdlFLaGV6?=
 =?utf-8?B?YkZsVUVSWWtpRzVUS0gxV0pWVGowS21zeCtCZmNMblhJcHNQS2p4WGRlSFRQ?=
 =?utf-8?B?Mk1DbTUwQXoyZlVrOVVtbks1SHdTajdmbm1PRkJieSt0MmVYRDZqbnEyN0Rj?=
 =?utf-8?B?UFFvaXJYTHVIeG1wTlNFMXhzSXhRSmoySjJDTzhteFlOTUFqcWRkcGdWV1pO?=
 =?utf-8?B?dit2Y0dUdm5tcmJnc0Y2UXNHdlBzVDU4MWdsRTFxVXBOUTNMaVV3aGREWnBT?=
 =?utf-8?B?RkUvRnMxTFU2elp0TXN4NzNvNUJNSll3WlhWeHM0TTZyS1BTRU9PK05DTGxF?=
 =?utf-8?B?cUxwUlA4NEgxMmdDWTQxWnBmVGlja3E0NDdtSVNYNC9XblUveUkyZEtWU0Jj?=
 =?utf-8?B?MWthNmV2Q1lkWjJPTUJCSXduQ0RmNkhzb0ZMZSs0b01JSUxNWEc5RUpsM3B4?=
 =?utf-8?B?SHBUTFUwK2h0ZFVCMi9ISXB4aGNmTjZ4Sko0VmdpcXcybWNOVDRoaWRqMGxN?=
 =?utf-8?B?WmhuNmFabTU3U1Z4SXhFeWlaUFN6MEY5MHFzdmNyK09iNWQvaXBvelFzRjRp?=
 =?utf-8?B?ZkMrbFcrY1llK2NVRmhvRGMyNmc1WkIrU3JaZk1XL0lSMHlsRGQrWFluOE4z?=
 =?utf-8?B?SFlGQm5kNjk3NXMrYWVqS3UvN0tmMmhOYVZHQk91SUJBQUN3WkVucFBERnR5?=
 =?utf-8?B?TEY3ZEZ5US9CYUNQeDJHMzQvRU1xMnd6Nm01aEpYaGU3dHJsMy9vanliSTNI?=
 =?utf-8?B?Z0FYWHpIY244UDRZSUExb1RLNnZHNkt3Zlg1Uzl1enB2VUVNZWxQUjlZTkhu?=
 =?utf-8?B?YWQ5UldNUER5bGdHaTZGVG1rdzBHdk1vLytud2UyRlR3WS8yekt2WDBCNmJI?=
 =?utf-8?B?dlZrc3E4VUxmSEtET05YTWRsUUVFbWkwem8yL084N2p0TmNMWEdkUEZ6a25h?=
 =?utf-8?B?ZWZrZHlHNEZSYXlZOGp5eFVZME00QnY0Zjdwem9IRUZxSUNidjVDM3ZuNThm?=
 =?utf-8?B?cmQ1QVpvUmVuc1NXRDRseDEzeExwNTBjOEp5WkEza1dEVVhzdDlmbkZqa3Yz?=
 =?utf-8?B?SXlPRThsR3BNUUszV3dhckpXWERQckFDbDVhTVA2dC9kekcxZHltL3g4Yk1Q?=
 =?utf-8?B?QmtlRkZTRUFhTFgxeWFvN1RrdWd3NnNVV0gyYTQrTnFjUjhHZ1RXV0FmY2sr?=
 =?utf-8?B?SW9TamttdS9jYWNvTFpUWXNvcEZrQWd5UVdPQkVIZkYvdHBzUHYwRnFQSzA0?=
 =?utf-8?B?Y3NVWmdSNE5zamtYTERLeFgzMEU2c2ZXcm45TWxjUEVlTGV5Q0I4N05JVUsy?=
 =?utf-8?B?Uzc2ZStKRmZQVzJBVXlvV25tZ3JxWXNUditjWWRTKzRHVjViYXdhdkhjNmIw?=
 =?utf-8?B?ZkxUS3RyODlzdjlzNk93UUNWNnlzczV2TUhzZEkyMWQwTVRzQlZqancxVCts?=
 =?utf-8?B?ZG10S3lNV21hSXkvNkhhQndsMGNPaE43bVAxaGNrY294SG5TKzhoZFpETmlh?=
 =?utf-8?B?YVRRdHJNVUh5M0VyUzhFenlzZXRHd3VLbVY0NmFNMm03UlpIR1ZwZDNiTE50?=
 =?utf-8?B?U1J2ZWZJd0ZQUGZFd3BrQytPRXcvNnhndHF4MVJmcDlYWTVLRnRKL0tKMWpm?=
 =?utf-8?B?UFNOLzM5N1hCWm9PclRBcCswQ2NUMnlIK3ZQQUdZa21nZjM1NVN4MTJZczBu?=
 =?utf-8?B?cVJTRHZoamI0eUpsUDM0c0NqNnU3TzJyMUJQdGdxRFBsblZ4aUErZ0c0Tzlp?=
 =?utf-8?B?Z2tweGZQM3BldHp4aW5QT1pnMWwzL3A0THRpNTViYW91UTJraVJNSlVwcE5j?=
 =?utf-8?B?VUZDa2RrU3Y2UlJqRVZZdW9VcUt2VWd0bTBsbmpKckY0WFVrS2xTWkp1U3BV?=
 =?utf-8?B?akVKV2sxUmQ2UDFuWWMzankyTnBWSXZvSG5kRkFndHBpR3lyNlFvenErcUkz?=
 =?utf-8?B?WmhWL2dic0VpMUF4ZkZFRzk0bjBoc090MExGdDZjQXdEaXBSQmo1OEQ0VGxo?=
 =?utf-8?B?QXNaeFRpRzVUV1NLVjhRVWFpclpHVEN6Q1RUVmVmU3VVYzM0bThWaEJJeGUv?=
 =?utf-8?Q?mFKxGSFBlKBUd3G0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aSuOQnOZ75kKwD9BizQUXEPsx72u4gd6R8btCsNj6eURkH1MK7Sk13Bxujc6zKlDYUe57lhVcz4L6xKeVh2tamPAy7XzMq1SKINZT9AF125ogfkSvdBpZXI/pO9RNoWzSce2UdqeC/9C+VTPda3oK/cpz8HaEOpzR2pJEddkBjsuFxqmnIkjc6+aJhix2R57MN4SnO7JRVsCQTNvLVw2Kgr4BBS6tniRtT4ueCq0ZfdtboEnCuxvB4m63iAPIfLGT6i8SJsL+ym0K9pQwTv46xZMXte+TAjfQltwju0shbr1nyeM7IKoUROR5tJVsCF41qn95/frDL59IGPgcGDgfNDJWdicL4oawqfLHqUk59gMmzEpVtyAfBIk2tqFMsySDR62TTfhOML5sBQ1BH1tpo2965HaEupi/1WB2dFv2jC1nL3ycWGHcfhpH0PIpXE4svgwVedSTV/ybmujnM2It5NvDTq+gKif+bK0or1eqvpsRBk/Q//K14ttKvuSv3Ct7Z/rHSsJqw9OqBFihowRijZoxxQjpMRHdbT0Ky+SwkoGi9kGzXY8N9l233UmpHJWlcqG05IdLtw9+x7hWZktSepp9e070K2H4ph61uZAFxE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f34b2a41-1b77-4d27-3dc4-08de6d6eed4a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 15:20:33.1077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wx7nbhfTOOyk5YrhjVGoCj60/sgE0HXtYvjHV/n+OE4/M7rRdrXbtNNSFmYZ4iqCjHMkVhZAZj5jNbVnZ/45fHHHbUJVaZ2vo2NovsLIwcE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-16_04,2026-02-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602160130
X-Proofpoint-GUID: XIuZJv5VnLQkvSeBw0ySgVLhJx7ooD1q
X-Proofpoint-ORIG-GUID: XIuZJv5VnLQkvSeBw0ySgVLhJx7ooD1q
X-Authority-Analysis: v=2.4 cv=JO82csKb c=1 sm=1 tr=0 ts=699335c9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8
 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8 a=S7gJEkJEHN-xwhIT7fUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13801
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE2MDEzMCBTYWx0ZWRfXzHU0zXymLZ9d
 O6hHeVi+/o1+z2XT1HpxEJe+QTA9QrIpbc2PSDTSf6i8w+BFOOYFWDwiCXFfhrDUcxKHkzlfmPC
 /EVpR4NShhYuixXNA9oaKjVcKBUbbRLi8Kj8SAWdifOx8Lk6FkDDAL/6hBKoBEv5ZVRBSIGyg3A
 +8km/2OilXdUujenRjoJx5L7MyVlTAQ70cGRfN5phd3Fk87Gh5voVzoYs3Mvhqois0QPgEv98oh
 qwJtTEH4T+5RFlUKb0xqheyOBYvpe459b0AXhc8FwUnzIk66nkHSe+tsM2SvHL1pzzZLm13wXlU
 /Q5UmNdrQKfm4XyDjh8h6mKxpNxO+g8YiPfCoPWwfQrLoVkVLM25T/MVdLeY+2DKBICU3qCdm02
 q/fkWnCk5wXSNNLFPYgkP6phs30rCooGD37zKyk/egyFC/xlckvHEtiGZlLo2yy5KnLEQUqKkAd
 RPsUOkC6ZjgnxRHsqtZzsNs6Crqo0zL+boAiHK2M=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 802E740016
X-Stat-Signature: hh5anbggx8s4wmyq8eu7yeoep6utmwr4
X-Rspam-User: 
X-HE-Tag: 1771255265-928081
X-HE-Meta: U2FsdGVkX185eiQnvK4a8bi1BIdhBIjpD37BCPCaoSR8kK2dnHmmqHsyKNB1c7NIvjLIz6dAeo6wKXkfiErwX0rQQetgdlIDZ/+Lp9/OuupFVV/QP39arYKJszb5XHkh+RF37Br+MwSvwhAfReZjzW7dkPXb+QND/r8b0hr3mNTqIgfWAdAvT+6Gn/ff9EWESIrxrTf2Lc3po9pZhG8D8Y0ikvrdZCm23GJge3k303Lwjz/U5vX4Lk8cptcgDGMUwyg2ttFmEuoC60BAIJMeEgjTS1AYkcARmT+EjxLHn4gqy2qzUER5k5I2t9JpPIiNnz0qGWi3n5NWk6ziNIveWPCNRihmx+N9eeC58dKtSxhtM3xxV8XZDMQ10Lfyqmm4SugEIh33TffBMXQwi9PhHhI2J6XOL6MYPjUB4CQko/y1GAvfK4DyrE2pawMh1YVuytIFVPVLJhqwueM9OuhFHTQ6A6I5MH6AByKfs7KPGMLiZjl/+nJbMqqqKozNCySgNPMq0EKHuRfYmx01jfVHZ8F4f+vYtv4Q/NmuR9/HlBDzhcPaQg6EoTiUNcw6rIRlL8+AypNfbz17SDH9nGf2vfBjfl3Muoy7U/7+Xy4uz7o5YCmz44/t3CdPh6yV9h9R3N9fi9xv/EjlnmNkhS6WINTQU0Spxp9amOi6HnGLQ8el5+8iyWlt8f94imcJXbMT2O32dNecCDNU8cRUXHc5m1ddPZnexzHqGC61SKPbxhI8BRHDwgi6L0MdROl8jxukLxbwqAfw0Nc1jGRzoRYxPS1bfb9IcXml9pmDMmjvedMvWyCOn7o7yCNZpTspOa0GU97MMY/n79/PYEOcKNksl8bvlS9SNkst/TW0Ns6upCb6K0xqVdVUrjxvP6cHkF1gRnj7ima7yxiFyNsE6nTmn3U2cB5nwZwzAj3+w85LNwVtDRXJMsaC300l301wnoiRsxxt7naKv2i6qU6+pEE
 GM/+RkeT
 bIy00UREWougmCsOmaCSY1tj8tmuzTIYa6cGoNyIai0QAp2soo8rmJGkJjTdCmLVk1apTvrs+8hTC3PlagP4bEtDhE6C8EOe9/e1Xujhcob3IEdFniUlyDfd43V5sKHVndj352wYMRaNMy81QnFZKLHwyEOiNbfjLkYNn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 03:00:57PM -0700, Nico Pache wrote:
> On Tue, Feb 3, 2026 at 6:13 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Thu, Jan 22, 2026 at 12:28:33PM -0700, Nico Pache wrote:
> > > Pass an order and offset to collapse_huge_page to support collapsing anon
> > > memory to arbitrary orders within a PMD. order indicates what mTHP size we
> > > are attempting to collapse to, and offset indicates were in the PMD to
> > > start the collapse attempt.
> > >
> > > For non-PMD collapse we must leave the anon VMA write locked until after
> > > we collapse the mTHP-- in the PMD case all the pages are isolated, but in
> > > the mTHP case this is not true, and we must keep the lock to prevent
> > > changes to the VMA from occurring.
> > >
> > > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > Signed-off-by: Nico Pache <npache@redhat.com>
> > > ---
> > >  mm/khugepaged.c | 111 +++++++++++++++++++++++++++++++-----------------
> > >  1 file changed, 71 insertions(+), 40 deletions(-)
> > >
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index 9b7e05827749..76cb17243793 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -1151,44 +1151,54 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
> > >       return SCAN_SUCCEED;
> > >  }
> > >
> > > -static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
> > > -             int referenced, int unmapped, struct collapse_control *cc)
> > > +static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
> > > +             int referenced, int unmapped, struct collapse_control *cc,
> > > +             bool *mmap_locked, unsigned int order)
> > >  {
> > >       LIST_HEAD(compound_pagelist);
> > >       pmd_t *pmd, _pmd;
> > > -     pte_t *pte;
> > > +     pte_t *pte = NULL;
> > >       pgtable_t pgtable;
> > >       struct folio *folio;
> > >       spinlock_t *pmd_ptl, *pte_ptl;
> > >       enum scan_result result = SCAN_FAIL;
> > >       struct vm_area_struct *vma;
> > >       struct mmu_notifier_range range;
> > > +     bool anon_vma_locked = false;
> > > +     const unsigned long nr_pages = 1UL << order;
> > > +     const unsigned long pmd_address = start_addr & HPAGE_PMD_MASK;
> > >
> > > -     VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> > > +     VM_WARN_ON_ONCE(pmd_address & ~HPAGE_PMD_MASK);
> > >
> > >       /*
> > >        * Before allocating the hugepage, release the mmap_lock read lock.
> > >        * The allocation can take potentially a long time if it involves
> > >        * sync compaction, and we do not need to hold the mmap_lock during
> > >        * that. We will recheck the vma after taking it again in write mode.
> > > +      * If collapsing mTHPs we may have already released the read_lock.
> > >        */
> > > -     mmap_read_unlock(mm);
> > > +     if (*mmap_locked) {
> > > +             mmap_read_unlock(mm);
> > > +             *mmap_locked = false;
> > > +     }
> > >
> > > -     result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> > > +     result = alloc_charge_folio(&folio, mm, cc, order);
> > >       if (result != SCAN_SUCCEED)
> > >               goto out_nolock;
> > >
> > >       mmap_read_lock(mm);
> > > -     result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > > -                                      HPAGE_PMD_ORDER);
> > > +     *mmap_locked = true;
> > > +     result = hugepage_vma_revalidate(mm, pmd_address, true, &vma, cc, order);
> >
> > Why would we use the PMD address here rather than the actual start address?
>
> The revalidation relies on the pmd_addr not the start_addr. It (only)
> uses this to make sure the VMA is still at least PMD sized, and it
> uses the order to validate that the target order is allowed. I left a
> small comment about this in the revalidate function.

Yeah having these different addresses is a bit icky, easy to make mistakes here.

Oh how we need to refactor all of these...

>
> >
> > Also please add /*expect_anon=*/ before the 'true' because it's hard to
> > understand what that references.
>
> ack
>
> >
> > >       if (result != SCAN_SUCCEED) {
> > >               mmap_read_unlock(mm);
> > > +             *mmap_locked = false;
> > >               goto out_nolock;
> > >       }
> > >
> > > -     result = find_pmd_or_thp_or_none(mm, address, &pmd);
> > > +     result = find_pmd_or_thp_or_none(mm, pmd_address, &pmd);
> > >       if (result != SCAN_SUCCEED) {
> > >               mmap_read_unlock(mm);
> > > +             *mmap_locked = false;
> > >               goto out_nolock;
> > >       }
> > >
> > > @@ -1198,13 +1208,16 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> > >                * released when it fails. So we jump out_nolock directly in
> > >                * that case.  Continuing to collapse causes inconsistency.
> > >                */
> > > -             result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> > > -                                                  referenced, HPAGE_PMD_ORDER);
> > > -             if (result != SCAN_SUCCEED)
> > > +             result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
> > > +                                                  referenced, order);
> > > +             if (result != SCAN_SUCCEED) {
> > > +                     *mmap_locked = false;
> > >                       goto out_nolock;
> > > +             }
> > >       }
> > >
> > >       mmap_read_unlock(mm);
> > > +     *mmap_locked = false;
> > >       /*
> > >        * Prevent all access to pagetables with the exception of
> > >        * gup_fast later handled by the ptep_clear_flush and the VM
> > > @@ -1214,20 +1227,20 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> > >        * mmap_lock.
> > >        */
> > >       mmap_write_lock(mm);
> > > -     result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > > -                                      HPAGE_PMD_ORDER);
> > > +     result = hugepage_vma_revalidate(mm, pmd_address, true, &vma, cc, order);
> > >       if (result != SCAN_SUCCEED)
> > >               goto out_up_write;
> > >       /* check if the pmd is still valid */
> > >       vma_start_write(vma);
> > > -     result = check_pmd_still_valid(mm, address, pmd);
> > > +     result = check_pmd_still_valid(mm, pmd_address, pmd);
> > >       if (result != SCAN_SUCCEED)
> > >               goto out_up_write;
> > >
> > >       anon_vma_lock_write(vma->anon_vma);
> > > +     anon_vma_locked = true;
> > >
> > > -     mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> > > -                             address + HPAGE_PMD_SIZE);
> > > +     mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
> > > +                             start_addr + (PAGE_SIZE << order));
> > >       mmu_notifier_invalidate_range_start(&range);
> > >
> > >       pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
> > > @@ -1239,24 +1252,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> > >        * Parallel GUP-fast is fine since GUP-fast will back off when
> > >        * it detects PMD is changed.
> > >        */
> > > -     _pmd = pmdp_collapse_flush(vma, address, pmd);
> > > +     _pmd = pmdp_collapse_flush(vma, pmd_address, pmd);
> > >       spin_unlock(pmd_ptl);
> > >       mmu_notifier_invalidate_range_end(&range);
> > >       tlb_remove_table_sync_one();
> > >
> > > -     pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> > > +     pte = pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);
> > >       if (pte) {
> > > -             result = __collapse_huge_page_isolate(vma, address, pte, cc,
> > > -                                                   HPAGE_PMD_ORDER,
> > > -                                                   &compound_pagelist);
> > > +             result = __collapse_huge_page_isolate(vma, start_addr, pte, cc,
> > > +                                                   order, &compound_pagelist);
> > >               spin_unlock(pte_ptl);
> > >       } else {
> > >               result = SCAN_NO_PTE_TABLE;
> > >       }
> > >
> > >       if (unlikely(result != SCAN_SUCCEED)) {
> > > -             if (pte)
> > > -                     pte_unmap(pte);
> > >               spin_lock(pmd_ptl);
> > >               BUG_ON(!pmd_none(*pmd));
> > >               /*
> > > @@ -1266,21 +1276,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> > >                */
> > >               pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> > >               spin_unlock(pmd_ptl);
> > > -             anon_vma_unlock_write(vma->anon_vma);
> > >               goto out_up_write;
> > >       }
> > >
> > >       /*
> > > -      * All pages are isolated and locked so anon_vma rmap
> > > -      * can't run anymore.
> > > +      * For PMD collapse all pages are isolated and locked so anon_vma
> > > +      * rmap can't run anymore. For mTHP collapse we must hold the lock
> > >        */
> > > -     anon_vma_unlock_write(vma->anon_vma);
> > > +     if (is_pmd_order(order)) {
> > > +             anon_vma_unlock_write(vma->anon_vma);
> > > +             anon_vma_locked = false;
> > > +     }
> > >
> > >       result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> > > -                                        vma, address, pte_ptl,
> > > -                                        HPAGE_PMD_ORDER,
> > > -                                        &compound_pagelist);
> > > -     pte_unmap(pte);
> > > +                                        vma, start_addr, pte_ptl,
> > > +                                        order, &compound_pagelist);
> > >       if (unlikely(result != SCAN_SUCCEED))
> > >               goto out_up_write;
> > >
> > > @@ -1290,20 +1300,42 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> > >        * write.
> > >        */
> > >       __folio_mark_uptodate(folio);
> > > -     pgtable = pmd_pgtable(_pmd);
> > > +     if (is_pmd_order(order)) { /* PMD collapse */
> > > +             pgtable = pmd_pgtable(_pmd);
> > >
> > > -     spin_lock(pmd_ptl);
> > > -     BUG_ON(!pmd_none(*pmd));
> > > -     pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > > -     map_anon_folio_pmd_nopf(folio, pmd, vma, address);
> > > +             spin_lock(pmd_ptl);
> > > +             WARN_ON_ONCE(!pmd_none(*pmd));
> > > +             pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > > +             map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_address);
> > > +     } else { /* mTHP collapse */
> > > +             pte_t mthp_pte = mk_pte(folio_page(folio, 0), vma->vm_page_prot);
> > > +
> > > +             mthp_pte = maybe_mkwrite(pte_mkdirty(mthp_pte), vma);
> > > +             spin_lock(pmd_ptl);
> > > +             WARN_ON_ONCE(!pmd_none(*pmd));
> > > +             folio_ref_add(folio, nr_pages - 1);
> > > +             folio_add_new_anon_rmap(folio, vma, start_addr, RMAP_EXCLUSIVE);
> > > +             folio_add_lru_vma(folio, vma);
> > > +             set_ptes(vma->vm_mm, start_addr, pte, mthp_pte, nr_pages);
> > > +             update_mmu_cache_range(NULL, vma, start_addr, pte, nr_pages);
> > > +
> > > +             smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
> > > +             pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> >
> > I seriously hate this being open-coded, can we separate it out into another
> > function?
>
> Yeah I think we've discussed this before. I started to generalize
> this, and apply it to other parts of the kernel that maintain a
> similar pattern, but each potential user of the helper was slightly
> different in its approach and I was unable to find a quick solution to
> make it apply to all. I think it will require a lot more thought to
> cleanly refactor this. I figured I could leave this to the later
> cleanup work, or I could just create a static function just for
> khugepaged for now?

Yeah let's at least separate it out for this logic anyway.

Really we should have done the refactoring in advance of these changes, but that
ship has sailed :)

>
> >
> > > +     }
> > >       spin_unlock(pmd_ptl);
> > >
> > >       folio = NULL;
> > >
> > >       result = SCAN_SUCCEED;
> > >  out_up_write:
> > > +     if (anon_vma_locked)
> > > +             anon_vma_unlock_write(vma->anon_vma);
> >
> > Thanks it's much better tracking this specifically.
> >
> > The whole damn thing needs refactoring (by this I mean - khugepaged and really
> > THP in general to be clear :) but it's not your fault.
>
> Yeah it has not been the prettiest code to try and understand/work on!

:)

>
> >
> > Could I ask though whether you might help out with some cleanups after this
> > lands :)
> >
> > I feel like we all need to do our bit to pay down some technical debt!
>
>
> Yes ofc! I had already planned on doing so. I have some in mind, and I
> believe others have already tackled some. After this land, let's
> discuss further plans (discussion thread or THP meeting).

Yeah, I'll get that TODO list discussed in meeting shared soon...

>
> Cheers,
> -- Nico
>
> >
> > > +     if (pte)
> > > +             pte_unmap(pte);
> > >       mmap_write_unlock(mm);
> > > +     *mmap_locked = false;
> > >  out_nolock:
> > > +     WARN_ON_ONCE(*mmap_locked);
> > >       if (folio)
> > >               folio_put(folio);
> > >       trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
> > > @@ -1471,9 +1503,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> > >       pte_unmap_unlock(pte, ptl);
> > >       if (result == SCAN_SUCCEED) {
> > >               result = collapse_huge_page(mm, start_addr, referenced,
> > > -                                         unmapped, cc);
> > > -             /* collapse_huge_page will return with the mmap_lock released */
> > > -             *mmap_locked = false;
> > > +                                         unmapped, cc, mmap_locked,
> > > +                                         HPAGE_PMD_ORDER);
> > >       }
> > >  out:
> > >       trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> > > --
> > > 2.52.0
> > >
> >
> > Cheers, Lorenzo
> >
>

Cheers, Lorenzo

