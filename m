Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B1C1CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 15:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402C28E014E; Tue,  4 Nov 2025 10:27:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3A58E0124; Tue,  4 Nov 2025 10:27:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2547D8E014E; Tue,  4 Nov 2025 10:27:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BC0A8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:27:26 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 951334AE57
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 15:27:25 +0000 (UTC)
X-FDA: 84073303650.06.B7FEF1E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 34317C0010
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 15:27:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YrsNR8bV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RjosRYzD;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762270042; a=rsa-sha256;
	cv=pass;
	b=6WdC0S4uLYtWtzuaTmNpJ1kMauKMa/jYc3SeRiiT44TLyxcKY/1pl+ocOkybDqA2MWNDsQ
	JafuI9jvcmdN54pZfKVMvRoNp1xUUnPY6fBWGHSyzNmoDMdE8Q7XyNH/h5kSeqsKgEDpXH
	4NB49yG0qKIHv8HAwrWA29w6VN1XeT4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YrsNR8bV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RjosRYzD;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762270042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VhzqJjrXJnL4pj4PyG+/5i1VNQZx9gOCqGjP90nWyPU=;
	b=AJXGlvCwEKyOPNf4z3HQZbrQSiorogtTEJip/EQfhNdhWGMGYA/IsLvrfxqkC9hzgGKk8t
	QZEbQPebM1lkNZyyVLRWu38505gw5hV7jdFHnmkg37IW/qTxU5qnHcBSeOKnfrf3G917+9
	US2HmpGunSp2b001qrA1GGPOzT7FSDQ=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A4FF2ee003522;
	Tue, 4 Nov 2025 15:22:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VhzqJjrXJnL4pj4PyG+/5i1VNQZx9gOCqGjP90nWyPU=; b=
	YrsNR8bVGGAHyiDLNZsV20ODpju9xbidvbNyiu2aSVph13tN4TkfHR+XfUJeLLob
	DG3BB1aU0vTiig2FMHKAXoQUjM6OX74rb4KVRd9WjGalVhk6zZOFAfh9OxyL4JsB
	XlnPt2SLJZKBJcH1IsEaogEWfseOiwopDkEulcVpodE+LJNdxuaIxqQtkn1edWIX
	MKruIZKRGufjUoDC5cBtztqM9mpPOnE4dOUUamVHMmAGKGz3PLg3cBDphKHGRSjX
	rojM65UI01v91AtzfdzSHV/qxgZdLnKYglf3d/wEq2KbABGZqUpsNuafyXDjQ3B/
	7fXtnEy64CAZ0dddAgWJbg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7ky10131-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 15:22:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A4DmiZI022146;
	Tue, 4 Nov 2025 15:22:00 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010015.outbound.protection.outlook.com [40.93.198.15])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nkgu20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 15:22:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=roKwRsgyiOGEluMqWliJHK4ERxKNygvJGzJZv1/oxSUr7IJVQfvOJFU/XxkmZWHIVR8ApWFjOOJsbLTPBSAS52RjN7K1zJedLDFgDu5SVdxalUOOTZ/DsjW+lOC6K3YG7tbcnV01UP6b86hyPex6WOn2N6PmJdSvhfQqgkEDOyvmV90gxRNfMwpNikSZqe4rXqUS3LOP1SYdy9zpbJ2aXp1/NKhikWi0RyqDWdxanCAMoFPIhJZN98dxUXrJ5AlbWT1sZrRKv/Hgivxcpr9dgMUwvdMb19pyrJVqJZlaonN7N087yi6s2k/dGvbAIRN/oq3brHcOA63zAwv4pvnFsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VhzqJjrXJnL4pj4PyG+/5i1VNQZx9gOCqGjP90nWyPU=;
 b=yjlkHzX20HEsyaQ0pQcmFoWNcUk4Dw5crD1vzC0nBvPXXULTnlfahhYBmhQToA4CkT3MjCKV5607ITz7yHczb81o4JfhYTU3Skg4sGMSNYAH4p3V+TRXr0BlCQvbpWuvwRhREDL5ea+pk+8qpO0f8zbpnCWlaWUn/l4BS1O1jZAB9e3iDK/5YQAbJ3hPTKsnEdHmumbyMZY5D5lUbzbnTu62+kCVRF1a95I5HIpZfG9CGaZPTJSkELK5xUPwegZn94zSvJYSTdq2Sp5hDfYtm4CtDeeeyVgVclkYU77JT5gk7h2+kCJBChDCFpPj1Pajv4f202cbxdyytEKyffAuww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VhzqJjrXJnL4pj4PyG+/5i1VNQZx9gOCqGjP90nWyPU=;
 b=RjosRYzDIF9obyUiiDw9iZcLQ952AkaOEfiRtdrTgV3pJomAlg69MwduvrQ/rhO+tEAJyvETpf7n03tkzCrkjDSM0i4THhnC8vhy8o59xKMep5EpBveuchVPd867kxP2bApv7st2+b+9oUxKws3eNkWsGWCHrH/muCYuSgzF4nE=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DM4PR10MB6182.namprd10.prod.outlook.com (2603:10b6:8:89::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 15:21:55 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9253.018; Tue, 4 Nov 2025
 15:21:54 +0000
Date: Tue, 4 Nov 2025 15:21:51 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
        linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Lokesh Gidra <lokeshgidra@google.com>,
        Tangquan Zheng <zhengtangquan@oppo.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
Message-ID: <7998c1f1-fd53-45e9-b748-55043522f1c7@lucifer.local>
References: <20250607220150.2980-1-21cnbao@gmail.com>
 <efeb3350-fbdf-408c-92ef-c6eada4a5755@huawei.com>
 <564941f2-b538-462a-ac55-f38d3e8a6f2e@lucifer.local>
 <c9925b2e-207b-447e-afce-07873406a853@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c9925b2e-207b-447e-afce-07873406a853@huawei.com>
X-ClientProxiedBy: LO4P265CA0225.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::10) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DM4PR10MB6182:EE_
X-MS-Office365-Filtering-Correlation-Id: 34a3aee8-2324-448a-2f39-08de1bb5e2c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dHQvR2xSMWNYek80YUJUaVk1aGxJY0JxbE1mRXN3L2QxeEV0MmJKV2JRRWRV?=
 =?utf-8?B?a0k3SnZpNlZjMFc1Yk8rTXdiajEvbkNxc3FWTU1PQzVvZEF4N252QWFOVExX?=
 =?utf-8?B?akh0TE8wL3gxcFJaUUpXMVYza1JhNm1SMzRGck42eFdmdjRqcFA5SC9VNUxV?=
 =?utf-8?B?T3J4SkN1V0NPclVRYi9oTEMvOVV5WWhFZ3h2dG5PRmg1TWZINWRkVldzT243?=
 =?utf-8?B?QWxtR0JpeDRVV0xESHFZc2NoelA3cEJGeVdjdEkra1R4ZDhRRTcrM2Z5am1R?=
 =?utf-8?B?T0k0a3JWTUxvSWlHNmJyeEhjM0ltd29TdUE2cmZVemZjSUUxcUNMdFRFeWpI?=
 =?utf-8?B?OXdqbGdpcVlZSHlwajEyYWJWNWxBT2FrMmVMWEhhck1aS25xRVpYZ0grcmxr?=
 =?utf-8?B?ZjlpUmN0VGNUUVRiVkpyc3d5Y2EyNVd3OFFNRkpVWVpTeHEwSHBvdXZwNHZ3?=
 =?utf-8?B?Vzh6MllKRHV0UGsrVEFHY1ZOTzV1U1lHeDBOMDd3WTV2cDJ1N1F1ZGEyaEFX?=
 =?utf-8?B?RzVLZEl3VHcrUS81UXl3ejhmb3B3US9rYWxWVUgzQ1FiOWxLQkNkUFZMUjY2?=
 =?utf-8?B?bVo1anhuRW9EdUM4Y3JUamluL2ZyRXFiMW83eEpTdnFKU2R3dDc2Z1JvbnRp?=
 =?utf-8?B?Ujdna2xWUHI1NVR2a0JnOHBXenFuYlEzL1FFa1pjVHM0NnJYZGZob2lTOEl2?=
 =?utf-8?B?STR1VTAybGZacjZvY3RFeGNVaXVhSkdDMi9jN291bnhObHROSEhmYzgza3RE?=
 =?utf-8?B?UGdQV2hReWVVSXJWMlRJeXVQREZuRFNlUWNtaU1PWUVEWG9xWDBWZkhvbStm?=
 =?utf-8?B?VS8vUitIK2l1a3I2YWZKL1F6a04vL0QzbmJyOE1BVHl0eUJmN1NrQVhEa3Rs?=
 =?utf-8?B?dlQrbjVuRzZsQlA3Zk9Nbk1DSlJlaHp5S1E1Sm95RmFzUWw0NmpyaXpNd0l2?=
 =?utf-8?B?VWVjVHN1VjNNZ2hlZFM2Z1lZbTJBV1RvNkY5L1QvTm9pMThxcGJXL0FETVhE?=
 =?utf-8?B?dXdMTWttZllLUlNuUkdtZjB4c0FPNjI4aUR5eWJHSVNkbkVEejVxbHgranEz?=
 =?utf-8?B?NUNkYm9qUk5KZXN4Y1FPaGRJdlEyc2ttWnk1ZHNkeEFSWlVTazh6eE5oRU5r?=
 =?utf-8?B?RFVBcitacmRoWmRJQUNnUlA3YStZTmdONEJCa21WTm9hVTlhTS9nR2hMVHNM?=
 =?utf-8?B?YlczMVMwYTZPOGt4ZllsMjNFeHpNcnU1VVl3dUtOU1RPbUJMVzYzdVMrcExm?=
 =?utf-8?B?bEVmQXFDL0NicEw5T0RGa3pnYUZxMVQ4bGlsSUk4QUFPamxYaGdhOWd2c0xw?=
 =?utf-8?B?aHFLWk5IV09aT3RuS04rdVFMd0liVG5XSlZ6dmgxRW1HalJMdFlxRnhENnhS?=
 =?utf-8?B?MFhVRTgwTHF0QWk1cTV4K056NUhKRENUS21UOFc1WTh2aUhMRTVpZk9VczRY?=
 =?utf-8?B?R2EyZHhVRERsYnlvcXY5Nk9JL1FHNGRXamNBbUVkN1VtRWgzWXl3MHY2VFF6?=
 =?utf-8?B?VDUyY3hyaitPRzdudWhUYTNEcWRlRGFudjdsVVpIOVhrdThta1hWQTMwUHgz?=
 =?utf-8?B?RFpueE9jQW1DUmpMT05WKzd2MnZUSTMvTGVmS0FYbzNJU0tTaGdxY1Qzc2l3?=
 =?utf-8?B?MjhFU2VmdVNDdjRGbDZPWGFGcXk5Z3h4TkhseGVCR2t5L3k0Z1k5Nm1VNjdy?=
 =?utf-8?B?bmN1MmxNRXlpOS9pWE5teC9qVmE3NlpMWkNqZkxjbkR5REtQdjFpUVBYUGJT?=
 =?utf-8?B?b0d5emhGc0liSC9KUTAxVHJsUGxMdzdGYnZ1WkNmZmd6bTZuUW9USHVOUGtS?=
 =?utf-8?B?d1p0OS9odHZSaENFdW81M3dBbFNNWlRhMStVRTNad3BDODdzV2xFNWoybjQz?=
 =?utf-8?B?d3k1a0VjYjRQb0dweFd4NTd5NDZaODdHTjcvOEZqOE0ranJJcGVmU1VTcjRw?=
 =?utf-8?B?Vk42VUtCOVFRZDQ0RGVncG1pNHdEZUw2TnVUUk0xQTJleXY3TU5kS3UrWW4z?=
 =?utf-8?B?L08xQmU5WGJ3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlJiVTVCUTBDSmR4aVFjV041b2s4WlN3cEgwc0xhZU92NmFseGhaQXJxRmJn?=
 =?utf-8?B?emppbVZ5WUE0NmZRQ2lNaFZYcUM0WldYdGU1RUMrR0RITk0ydWFEcFFXbCtW?=
 =?utf-8?B?QUM2REdKam85MXVQdDVsTE1idjhmc0RJT0J6Q1hTbzF5ZVdtd0RCU0hRWW91?=
 =?utf-8?B?TlBlMzVwZHFCdWpMN1NTdVY2NTJsdHFGZXJmV1NuT1B6eGMyVlozbUtuRlIr?=
 =?utf-8?B?dUdjSEEwSWVVUVBjdE41eUxvU3dqMVFid2xXVmZOVTczQ25zSWNnWTNOMEhQ?=
 =?utf-8?B?cjNMdzhXSERXd1hWTy84dC85dVA2VXVYQUlsUU92Mkhsb1BxbHpOckUxT09Z?=
 =?utf-8?B?ZWU1OVdKVWlqbmJPT1ZFOWt4bFhhV1k3WllPY0hEcElFdVliWnFPNHdUbkZ5?=
 =?utf-8?B?bDBuMXR6aXVRZUJ0K3loYnlic1FMS29wOG1UMmlqUkcySHNzczZrNWl3TTdk?=
 =?utf-8?B?YktXVzczZ2tKWElyUU5NUERYcWxTYkRvMG5sQ05vUzlFTTgwbXh5d2RYbnNj?=
 =?utf-8?B?dm5tOGhWamlzNVlxNFkvOGtSTFByTTBKMEVYU21UUzJEWS9wOWdsMnBKOTdW?=
 =?utf-8?B?TkV5eW5XZGNoWnZicWppRVpFRExCZzFhS3B1TURRa1VnNjhUOEJ5NzJFWEZO?=
 =?utf-8?B?ZUh6cHFVam9Hdk5rQkFzcU13RTl1UzVTNytIWEpHUW5DWkVyWHNUbFA4Nllu?=
 =?utf-8?B?NURoRXB6MDhwS3VUUHAwamNQbkpNQy9ZcGNCRXBXdmRZUjBtT2JESEJzck1u?=
 =?utf-8?B?V00xZXlXZ0p1bmVGUnhqN2VtZlpnSCtxNU9TTWIzRDIyQUFKVFovSXhyTGEr?=
 =?utf-8?B?bzZya0ZUVkJsT2RHajJBY3JFeEZHUndXdTllVTVsNndUbURlaXVjbW1SSXRs?=
 =?utf-8?B?Slp6Ym1lOUpHSmt1K1RiSTk1cmE2Q2JGLzgvQ3oyM0pGV0cyNXo5TGpqbkxE?=
 =?utf-8?B?aGJoeXRYOGFHSHJPWlFIM0k2SUFNdktkaW8rci8xUDVZRlNrelV5Y01JbWc1?=
 =?utf-8?B?KzNHSXZZd3JDN01SUmgwakhjQ2pWN3dZMzBtM0VZcXBueWJibXdJMTUxNXVZ?=
 =?utf-8?B?UDB6dVlkM0pZRDlUMThJVlhmQ0xZQklGejEwbCtIZGNMdDlqVlhxbHc3dnho?=
 =?utf-8?B?OGtTekh6MURHY1FNd0F2M1ZWdWwzNytaN3F0WlFCNFV3YzIrZ0FtR01XUjQr?=
 =?utf-8?B?aHQ0Rk1ncW5TQ3R1SURWN0hpSUtzdjRHdSthK3ZUajBHckRqQUp2aFlURGRE?=
 =?utf-8?B?eVV0RWlhNm5MVzZmTitmOG91Tm1SdnJaTk02ajRXSDhiUERTWHV1R0NLMkt2?=
 =?utf-8?B?N0RFZWdZdjRQdmErc0Y1d1h4V1JSNDBIQVRlMysxbStZblhaMlZvNDl3dXBr?=
 =?utf-8?B?V25SMnpYNHBXN1ZJb1k4WWFwb2ExUTAwaGlJVTNDRWdvcHFuemFmNlgrcGsr?=
 =?utf-8?B?RlVFWnY1Y2QxTUt5MUlvODlJM204dyt0M0tGSmE0NU5wamNuWDZTRzJJT2J0?=
 =?utf-8?B?b3Ivd293TVQzdmJ6Tk1NYVllaDdOOU9kUmRTeFZkVlAvQk5iMHd0ZnJUejZ2?=
 =?utf-8?B?SjVnUDc0ei9hUTRwdE05K0NuQTZNd0ZDbHkzcjIvY0NPRWxnU0xJRUpkV2d4?=
 =?utf-8?B?UjJXU3B5ZUsrQmFMK0lmSmJYZ0EwZGpoVjNmdHNZcnRTTSs4NDhjNXFtaXJD?=
 =?utf-8?B?cmxmR3p5SThMUzQreFluZ3RZcmRaQVNyc0ZLU09kMUkyUW1QTitIL0J6SW8v?=
 =?utf-8?B?UmtTRmhjUktyaXhaL3lVcEtqNndFRGNWTTNnQ0xRTW56ZzIwT3lwR0Q2MXRC?=
 =?utf-8?B?VGlaTHpUbnJYV2Y4UVg3ZDNHbU1vQTBCTXZpTWkwUU5WaWt4dmUyZHVwM3Z4?=
 =?utf-8?B?bGNpeFRvTG1hcFFISk5kQ1VzK1h0U010VmhVU1oxcW5iOUVBSFFHOUFFVUFU?=
 =?utf-8?B?dFZDckR4VUJBdXVnR2k4TTMvOEdOTmc1OTBtOEljZmVlNkZYUjJVR3gwRFBH?=
 =?utf-8?B?d2xxMlFlOFBFcnBYVXZEUENWSThiRDgxeGc2ZUp4R1Z5NXhOR0FSbUlZM3lN?=
 =?utf-8?B?SVJJZkY5WkdGZDJSbGMzU1lVNDVaTHdhZDQvZTJVNHJUY2xSazNHbWZ3QlYx?=
 =?utf-8?B?WUYrUjBUcnhMWVdBaVl5bmROMWRoMXdXV3dSWVFzOGlVLzFmN0owa0p6a2lN?=
 =?utf-8?B?ZXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	602oh1T+bzrOG4zmU8aDu4XDrbiD68+pIJ4yAAprfEumH5tCnNj1FipFEfx1zCugdmz1E59+DQt3Rf3XC0SyDYEMXir3AlXkRWEoeeaITPYkVA97Pi+ZfOlAcgzXgBoki8gVNtHeSx3RjU6vvfACgriNdtQnSBKMkC5W9iN9KZ/GzZz1OFuNi1NW0SICR9i2QHw7V+HP9ObjVzelu3oM6iKZpd/uWm37C4UXsKwXr0mzpyJNp1HY6k+a3i5ox1W2u5T7giThMPtUleFmJkguOTArQYrzzP2Cd9insV4Qx8bJxT6E0A+0bQgx1vAICd4tTFadcy/38tivIZ8LzjyMRJfU7b0aWDKuHUEKmO7Ii098kx/m5c4ys6uaWT9WXflCAOiyt3zUitiBfZb0dm6aMEV6L+/VX/pDkfu6T/Kpao6vk6dFRUcPuzKN/0In2i3YTCvhsmUQ1LcRW9UReZiOkESps9dFoU/J0dsxz3af0IytGWv+/gbceHy6+UF2mmkuAindGcRqoDV4pPGCsT6OJL57so6KB6GtygUYKtlF4B17FA9E/VmDgBn8sx2yhxtGKCRJ/1K05STqxq7tvZcj4F2Yd78ZC22Qc3cqpQZhpqI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a3aee8-2324-448a-2f39-08de1bb5e2c9
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 15:21:54.2395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sHGYoZdDSwRhuxSeWZ/eZQDWGZRBUMy4Hu7ytzkjNsg/qaPhCxy1CVokpYeCg4NvxoSwpWK/bI5BZZCeyBZqXY08VaGdhSd+hWIZmILz2wg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6182
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-04_01,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=990 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511040128
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA0MDEyNyBTYWx0ZWRfX1HRYlTiEqBn2
 4glaQ/FFmQVsi0Q5BCC8HON9jyKbPrB+VuF4NdopmuFu4VwiNfku+kzljHHt151015xHaGOmUDX
 NSRSfVw81iXfQ8taHYegsYflz6rTAuPQ4/ZtKvbtcHaYsPBTqd0dFgcCDfQxTbYlQ80moPh+kwg
 ik0qSgMfLCl1Am3Vk84aK9AbLqg1AAFilMaBdpPTGHZmlo7XrwMWdIGUPUflW4imYmmKOJkQSuY
 d4Bz96avlpMce0AnqZItZQ6Bsrotwvy7qUuW1+dYpqON7vwkTOL0hgerAqQFJuEcOkEpo/+mDlk
 tRyfWo8hAcCiKnXrsemY9qa4p15y6ZJpOwv3mikg/8e+oXPT9d9bc3MiCLAbghhRiCu5kP6pPl4
 I+tRV/h9w4zVMj3/DcwAyObfXueZOp5zm+jX8I/iZHEgg6JypMk=
X-Authority-Analysis: v=2.4 cv=EK0LElZC c=1 sm=1 tr=0 ts=690a1a19 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=nfdd62QgFSw9KfRWXsYA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=2jmYF3J1Y9AA:10 cc=ntf awl=host:12124
X-Proofpoint-GUID: nF-nPRcgUdjq5f25853hLu5R0pSDNPzK
X-Proofpoint-ORIG-GUID: nF-nPRcgUdjq5f25853hLu5R0pSDNPzK
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 34317C0010
X-Stat-Signature: 5hkrm1ak1y8m1yymfoa3z8qi7or9asm8
X-Rspam-User: 
X-HE-Tag: 1762270042-813460
X-HE-Meta: U2FsdGVkX1/Dg/7OpUw8BimzCfG55yF5FPIToneAVzB/jy7/QeSfepzni1ouHcra2ZkQRKkWLzgCfBXPMLg2LVp+y1kgceDQYmN/fP/Y2XFEJki+VbSii6cwu0xBIM0dphWwiS7PXFFswQinPa5i+Y7eZS6NcCWaIPDkuEGi//m69q7BKGabiVBb+WuoYhR1hwjmFVLwsZo+IW3i3RY+akhmMF1Xr2RXEQXxRcR4CCVV2cnhjQCbSemYG4d/DV3Xuqtp0aTPj58OQdZ8H4s+xuBiPOK5nBFdhxiafDGDNbtDdYV2wpElsy4aI7fVZWl/TToD7TafwlhgZvXPkX4Oz/nn9WYb2uXqzphbYlCZKllCtDHHvD9cl1uGrC3CS0EbaY9c4br8dXvTGG5IMlErdZeppiZhwyjhiPHACl1TjIUTxWQ22GfwpPjRJaNSeFsRNIp7d54e4rv3E7i1U/mJoXg1W+Gz85JFBYQMcQQUdSs8xvsFVMPsF3CdOLnbJE7o5vFYjiPfnXkGQAvYa8WBzl7Q8Ga1dwJTeGtke5YvUun9tAiQHVe4RsN+H8R9BW6hEN84mb665CW49G3Ldwh1v+yO7Yr6SPBvBp9K9sQMCmnO+H6lsVwsBz1PKaOi32tnWIiX/WCj4kVgzcAI6usHkiUveghXuNINJ10Hx2kvuQrBImH47vGTzVIXoOQz9rSk1QoqY6o3KHzQSVC+gOQHvNY5DxhgkXxX1y6mdcq/VzwN1XrpqGJcsDj8Ao4bGMbm7qXTksHo3vx7C8hKXFq6mfTfPdjffPDrjgCa/i5Mc270Qvd8LqpLkryIKAjYahZcXj1UFfgsHxEZzMzHLTaDRoa/NCdyf782zYLfSoxGWJ7VOnv0cod9GPqURSQhbRE31vOQ+u20D/T5yh5E0Xjw2AC9jmZiKbgKvr89Aw/K1yC1r9ISsqGXWOCzuOc3RntULhsVBg5FBdevZnmi2bn
 fD0Ujl7D
 /I6zjy1r1lPXvBvMKR+ElWQsGaPZJZTP+KNf/u+Tcx5iwUw2lsTmtdsoF3+LGpvVoi0me9bVBoWiLOFtubJVzhw0DB7brXHBFtP2b+BjoKPbbpZuihYZPMrJ7sNEDLvDUsy9UnBJXFZGsjJ3PpkC0mitEtk6p4LBkmuIY6VpojNbb3EmVLkDKo/P783W716JWtYc6JzSAtTZDiivHT2vhftks1yYt2QByUIrE1KQYm2tXHvdshR1X8BWOFZO49vqQ7c4VSLeOd5x2Vbv91otLqujPBawCWkqn2DJer60CbXzhciBc+WcwA+cFu3N2vjerYW9Sy3GCasKkrWLHGQtMJ2EoQp9789GIubegeixH+3QW4/xQoZyH7CI4zWWBVSp0fcVuXxZLC7hJsY+pUIMrghKR7aIA6nBExf7COXev/n7AIUV2a3jN7ptlkjR0Jx/fJbc+oO9M6XXAV/jcM04D7YqBxKHS+DLfATHx0HfIhCeGKx7K3jhCLDfku+b7mJRRoVH/aZOl+NpH8V6uvy5btM+DQoNJLP4lrrngJ0/hrdQ/A6mzh2/IPkXjepJ9BCqTwvoxePlVLpbaGikk2qx+I4IEzFG3Lft2IoEsTpEv1EGBrRIPv65qzqtG3WzPdWS1Lwu0xyAl6eAD0YeG+r8UXHb22kEOJbawlTwAuHJqrGMoYB8pa43IgEoNoIlHvBHs1q4LFO9ABxwviYZq6F8GbB9k7Hzm8FnDWHrNh25yEWY4SSqaArLA12c/zWEamQeuOUSH3gVuiswkOGI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 08:09:58PM +0800, Kefeng Wang wrote:
>
>
> On 2025/11/4 17:01, Lorenzo Stoakes wrote:
> > On Tue, Nov 04, 2025 at 04:34:35PM +0800, Kefeng Wang wrote:
> > > > +static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavior)
> > > >    {
> > > > +	int behavior = madv_behavior->behavior;
> > > > +
> > > >    	if (is_memory_failure(behavior))
> > > > -		return 0;
> > > > +		return MADVISE_NO_LOCK;
> > > > -	if (madvise_need_mmap_write(behavior)) {
> > > > +	switch (behavior) {
> > > > +	case MADV_REMOVE:
> > > > +	case MADV_WILLNEED:
> > > > +	case MADV_COLD:
> > > > +	case MADV_PAGEOUT:
> > > > +	case MADV_FREE:
> > > > +	case MADV_POPULATE_READ:
> > > > +	case MADV_POPULATE_WRITE:
> > > > +	case MADV_COLLAPSE:
> > > > +	case MADV_GUARD_INSTALL:
> > > > +	case MADV_GUARD_REMOVE:
> > > > +		return MADVISE_MMAP_READ_LOCK;
> > > > +	case MADV_DONTNEED:
> > > > +	case MADV_DONTNEED_LOCKED:
> > > > +		return MADVISE_VMA_READ_LOCK;
> > >
> > > I have a question, we will try per-vma lock for dontneed,
> > > but there is a mmap_assert_locked() during madvise_dontneed_free(),
> >
> > Hmm, this is only in the THP PUD huge case, and MADV_FREE is only valid for
> > anonymous memory, and I think only DAX can have some weird THP PUD case.
> >
> > So I don't think we can hit this.
>
> Yes, we don't support pud THP for anonymous pages.

Right, so we can't hit this.

>
> >
> > In any event, I think this mmap_assert_locked() is mistaken, as we should
> > only need a VMA lock here.
> >
> > So we could replace with a:
> >
> > 	if (!rwsem_is_locked(&tlb->mm->mmap_lock))
> > 		vma_assert_locked(vma);
> >
> > ?
> >
>
> The pmd dax/anon split don't have assert, for PUD dax, we maybe remove this
> assert?

Well, we probably do want to assert that we hold a lock.

>
>
>
>
> > >
> > > madvise_dontneed_free
> > >    madvise_dontneed_single_vma
> > >      zap_page_range_single_batched
> > >        unmap_single_vma
> > >           unmap_page_range
> > >             zap_pud_range
> > >               mmap_assert_locked
> > >
> > > We could fix it by passing the lock_mode into zap_detial and then check
> > > the right lock here, but I'm not sure whether it is safe to zap page
> > > only with vma lock?
> >
> > It's fine to zap with the VMA lock. You need only hold the VMA stable which
> > a VMA lock achieves.
> >
> > See https://docs.kernel.org/mm/process_addrs.html
>
> Thanks, I will learn it.

Hopefully useful, I made it to remind myself of these things as they're very
fiddly + otherwise I find myself constantly forgetting these details :)

>
> >
> > >
> > > And another about 4f8ba33bbdfc （"mm: madvise: use per_vma lock
> > > for MADV_FREE"）, it called walk_page_range_vma() in
> > > madvise_free_single_vma(),  but from link[1] and 5631da56c9a8
> > > ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock"), it saids
> > >
> > >    "Note that similar approach would not work for /proc/pid/smaps
> > >    reading as it also walks the page table and that's not RCU-safe"
> > >
> > > We could use walk_page_range_vma() instead of walk_page_range() in
> > > smap_gather_stats(), and same question, why 4f8ba33bbdfc(for MADV_FREEE)
> > > is safe but not for show_numa_map()/show_smap()?
> >
> > We only use walk_page_range() there in case 4 listed in show_smaps_rollup()
> > where the mmap lock is dropped on contention.
>
> Sorry, I mean the walk_page_range() in smap_gather_stats() called by
> show_smap()  from /proc/pid/smaps, not the walk_page_range() in
> show_smaps_rollup() from /proc/pid/smaps_rollup.

show_smaps()
-> smap_gather_stats(..., start = 0)
-> walk_page_vma()

Because:

	if (!start)
		walk_page_vma(vma, ops, mss);

The only case where start is non-zero is show_smaps_rollup() case 4. So we are
already using walk_page_vma() here right?

I may be missing something here :)

>
>
> >
> > >
> > > Thanks.
> > >
> > > [1] https://lkml.kernel.org/r/20250719182854.3166724-1-surenb@google.com
> >
> > AFAICT That's referring to a previous approach that tried to walk
> > /proc/$pid/swaps under RCU _alone_ without VMA locks. This is not safe as
> > page tables can be yanked from under you not under RCU.
>
> But for now it tries per-vma lock or fallback to mmap lock, not lockless, so
> do you mean we could try per-vma lock for /proc/pid/numa_maps or
> /proc/pid/smaps ?

Probably we could, but I'm not sure if it'd be really worth it, since traversing
page tables is a very heavy operation and so optimising it against contention
like this seems probably not all that worth it?

Suren maybe could comment on this.

Cheers, Lorenzo

