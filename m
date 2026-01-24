Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E2B9D715D6
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 09:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 311DD6B0596; Sat, 24 Jan 2026 04:01:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E96B6B0598; Sat, 24 Jan 2026 04:01:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 142876B0599; Sat, 24 Jan 2026 04:01:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F23216B0596
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 04:01:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E9E61DFFD7
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 09:01:34 +0000 (UTC)
X-FDA: 84366264108.24.EBE6B9D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id D86141C0005
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 09:01:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=J0ruJt96;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UEADLBNd;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769245291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVk8ideGBfLH7vQhPWkun38hOBtCVvJH/4BlhMKGy9E=;
	b=u44fVBqmiKeCDiZqLRzHcpPPlV8qoSi9SrshZ+qbukV7qMMsTAv4Idjhg1vK1SaTmeLLFX
	iQABNKcbEDr5TnDonNH+HXuUqO+D5R2zRuPt4s9/PhtV5xSj8W06pOJrCp0DjJIMhNQihW
	/9m0enHAojoQ7j0Mm8Cljuyk+P4SJzU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=J0ruJt96;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UEADLBNd;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769245291; a=rsa-sha256;
	cv=pass;
	b=lLm6fqTfOMU4oMA69Xy0Mjh/MTUSCbwAmuDe8AvpzUZKnG7YZJLxxRWIx7tT6eOs9cAk89
	2DjTUjh5V9SNe8fAzWvD73VSLwkZBcjJPKVPH4fQymMlf72mODh5oPrcIVW2h65yAHCQ3I
	PAsYVs+Cu64C0DltpJWvbS0SChfVvMk=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60O8ihnS372371;
	Sat, 24 Jan 2026 09:01:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LVk8ideGBfLH7vQhPWkun38hOBtCVvJH/4BlhMKGy9E=; b=
	J0ruJt96JK3Y2pa4gtPfjgZ4NPvB9rLCPQJJZDjBSadL+65hjOZYzs7x9O4Pm6zI
	ST3+jmLM/cvyM3/LwNg7FqZw2SGMoZaeAZ7pSv8CkCBuM8ZZg3M3LgbsIMAJawIs
	PSS7Cl7yRGDSWb8h8VoK1o81Zb5Ew+H6oJuHhEdMiylL9JWyyMOcToSKy/7AFOLo
	Ey5pTCQo4h5FczRqgZOXkoY5JLssSBxnQecNK345NQfEtMmh9xXTOlkv8JuX10GI
	Jf5q+K3yU7x+NoJhbRFlGjbBLeAj1fVE+qe50oKghsc91wMUSSBGoGRPz/JGesSD
	GEsMD5e6oFLeAClmZpy2oA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmny05ex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 09:01:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O8EU8U036018;
	Sat, 24 Jan 2026 09:01:18 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012049.outbound.protection.outlook.com [52.101.53.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhjhut3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 09:01:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O9S27X9TgToL/M/euob0S7SLeKzlqe3voXXMi6Fe9X1yalzz90UHcKJo9wu1US7G9VnLeZyWlEAyZh/1Y/KyttmLjeoZm/7bkLFxxnp3IMfTTLdy8KF1aFVGJpJNZM7ifG9gKoyzt/IrzajLoM3aSro5223GiM7EeLa5wffrwYARo/eF0mkfzTDK3EmSSThxkub/I3UsSkJ4ifh2UWyuJfNM1+2qJefsp0DE5O1DNSqIoRqpwiEE/xg+rbVxhK1MGsi2Xi0t99rDJEeNZDgPj0nhkjUlhcvJRwYqdKtMtpu7yeqqsuAGF4INf+Q5AM6MlXKzPVVJGpgZLV9JPVfNAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LVk8ideGBfLH7vQhPWkun38hOBtCVvJH/4BlhMKGy9E=;
 b=Nduh90ZpbSpTtfCkY9DVVyncU+oiFPRWHuEYjQv+KA+Uq0LMYLvEsE2dpQsHIK1vstV0MgvMiaaUrJT8gDaikSV91lGxfj3LITbFVxdH6phWTkX4DuseDMIDsvoXNVgicr0VQSPUGmz6NxHXtc/D/9DtLbFsA9ZV8uxbklnYqJyDqbdvxjr/FTfS8y+laiStLMXAMn1aDZOia4aHJFcwl/Nlwfi6+pXfupbKwMutPdlQ88DxhxX5FfRa+XoOJbD8B3oqI4JFoHPWHkca4UT+E76OX62ZWRuOjup0O4XxlxS/tUQtfE9Zw1oVXUHeVasQUELRNzxozNvZr7TFHE6foA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LVk8ideGBfLH7vQhPWkun38hOBtCVvJH/4BlhMKGy9E=;
 b=UEADLBNdH4Kbi2bphsaKrnnX5iv9hvvXgvYR/wtm8ssHs21mIOnqCUmQmy88n/33jZ+2rEKjp8zP7R5bAK0jbYEHJeQtj+DDRPtyYhtk2+EaQjbM5OJUytxoeEynTNKSh4gHTrTyP6Sh+Ijvy+M7ZSG0xQLgUjVvXt89HoIe4zM=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS7PR10MB5973.namprd10.prod.outlook.com (2603:10b6:8:9f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Sat, 24 Jan
 2026 09:01:15 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sat, 24 Jan 2026
 09:01:15 +0000
Date: Sat, 24 Jan 2026 09:01:18 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wei Yang <richard.weiyang@gmail.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH V3 5/5] mm/khugepaged: make khugepaged_collapse_control
 static
Message-ID: <50da84da-1cd6-4b8b-babd-b6dea405713b@lucifer.local>
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-14-shivankg@amd.com>
 <6486c6dd-2702-4a4d-9662-09639532ce6f@arm.com>
 <afc56f8f-0c22-4bac-a99b-b46df346334d@arm.com>
 <ba4502f7-0c35-460e-a42c-d32dea9ab9eb@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ba4502f7-0c35-460e-a42c-d32dea9ab9eb@amd.com>
X-ClientProxiedBy: LO4P265CA0264.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::15) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS7PR10MB5973:EE_
X-MS-Office365-Filtering-Correlation-Id: b33451ba-ce9b-431e-0bf6-08de5b27213b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bGlaS2djZ3lVSkd3UWRGRU9vZmE2MjI1Z0NMQXJiUUxBdXFLZHZwamYrODgv?=
 =?utf-8?B?RDdTNExXZC9OSDNzdUFEZ3V4NVVVK3h1dmllbFVLOHUwR0ZtOVNkb0p0OUxk?=
 =?utf-8?B?bVlmSHJ4N25nWi9RSFY0cGk3OVR0MTdteEt5VWc1cFlSbDYzVzlYSGlmdnJk?=
 =?utf-8?B?U2V3SnVGYUNkM2JGbDMrVFlXVXNUZFB6aDFFNU5xa2JRK045U2JUbTk4VVZQ?=
 =?utf-8?B?ZWo0UXU2Wk5yQXdYQXFZSjY0MVdSVC9JTmwrSndIVzJkcjZjaGdObU45a2lC?=
 =?utf-8?B?bndZcWxvQTRwb1pxU1czWnZEZkZ5VytOUk5IaVhxNWVheGczMHRtVGNOM2RP?=
 =?utf-8?B?TzN6Q1FjVjltTGVuMUNqeWZSbTZNN1c3bmczeWo0VGFPTXBCam1paXlhSEdS?=
 =?utf-8?B?bDRCUURYRHd1Y3pVVU1SdTdINUhqVFh3UGdTbkJxYVJKVE5SbVV5QTlNVGxl?=
 =?utf-8?B?Tmprak45dktJQWJxWTNEZ1V5NkdzL0xDL2FwR3hXNEdLSjE3eUY5OHlSUi9U?=
 =?utf-8?B?ai9zS3kwNkF3OWJuYzJzZ1hjeFR5aUsyWUVVSzlzdlpEQzgvVjVNYVF6bHdV?=
 =?utf-8?B?NUdSSXM5WjFNT2dWdk4zNWVwSjNhbnF4dVVsQmdIMHpGNjBsVk1Ib1ZtMDhp?=
 =?utf-8?B?ZkF6dW9oT3dqekQxeFIraU4wVmMzek9QRFdydGtqWEZFZ0MxRUgyaFhhY2k1?=
 =?utf-8?B?c2dLV2tZRER3K1VnSXY0Qi9yVHhISDlpZU9ydWVwRGxweE1MaDNZZFo2d1lq?=
 =?utf-8?B?TU5vdEkyKzh0T2tHeGk1NGhvOWplNlVXREJtVHk0RFRFbDBpU3l3M3p4dXdj?=
 =?utf-8?B?OUpNdXM2d1VFSE93NldVY3Z3aWdoNlR2bWdpRXFtZmU1ZnNNaG5nSzEyWkQ4?=
 =?utf-8?B?Q2lVRFU1T3Joenpyb0NIRk8zVGx6QW9wRkxNbjRGcjd1Y0pnTWgxd05YK2dz?=
 =?utf-8?B?VUdkQnYzMzlmNHlmTGxmcFlBMTdKcnFSYmtpalBVem5ybUh1Qm94MGlUelVr?=
 =?utf-8?B?amtiOHpHblZDZDBPWjVQc3kvTGZaSlNUVk5uaDFCZThYN2JyQkQ5KzlLZ081?=
 =?utf-8?B?SklSckVvdllxaUZYQzMveEtzVEtmQmZrNXk5T1VuYkJld2lRdGEzVTg4SC9R?=
 =?utf-8?B?MTkybnVWV1YySjJRQ21qanNjTzFzRDFsci9sdDAvT0VOVGY1SGRleDJnSGN3?=
 =?utf-8?B?WU5PUjhLQWJEazJlQi9MUHlOY3drajFab2lLS3pLSXhCYStlRzJoR3FKcEhi?=
 =?utf-8?B?eDlNRkV3UnZuSmhlVFRsck9JZzl4NVBKbS9NSjgydmJ3S28xZ1A1MGduL1k4?=
 =?utf-8?B?ZkYvMnpiMmU2cWFtdks0VDdCUlliejRWalJ5ampmMVFKUGR2RThJZmFNd0tr?=
 =?utf-8?B?WmdvcEVka0RuRGs0L1BPQUM3WkpkQnRVOVU2RlBHRUs5RnRhUDRNLzdLR2k2?=
 =?utf-8?B?K0NFQjJxS1d2bnp0QUloTitqNWdLSUszZU1PQ3ZRZ0xiTU4rbXg3RCs0eFlQ?=
 =?utf-8?B?eDU2VnpVOEFBZ0grMUtWaUNYVUtsTkR2QlJDK2RNUDVpTXNGTlYwUTVVZHRB?=
 =?utf-8?B?SzNLcGpzZk9iUFBMWldvOTcxSkYxNnZ0eWdaaG1yRlVWZmxTVEFsM3dxY1l5?=
 =?utf-8?B?RWtVNWRwbVpUOXBqVlpweUJDejEvaXovNHpCU2x5bVI2d29TYVFBVG1EajZH?=
 =?utf-8?B?cFhneDkrWTZFQmpMWFROWkM0dHJpV1FGSytuOTVUQnVZbWlCbnEvRit4M2pC?=
 =?utf-8?B?M3BUbkRKWmVEejdBdDh6Szdra0JuM3d1b2R2MzJmb2FGc2lJSHJYWEVLRnVO?=
 =?utf-8?B?MVlkU2o5bkpPakhoei84VFRqQnlUbFU0WXRGTGRUMDNkdnAxV2t0aE1YNlI3?=
 =?utf-8?B?dFFHWVpveVZ5Y1c2c0Z4M3lubzcrTm52OVVSV0xtS2RMb01Vd21kUS9kOVFR?=
 =?utf-8?B?LzlvY2UxT1lNWS9wZ09tSnlySTN0QjBEeGxJZWNMeWVDWHNpeGJQY2hvdmh4?=
 =?utf-8?B?cExuQ0lCa2pxejhITzRnRnBHYkFjMDJvWCtDWUZ5cHhBUCtwV2lPRm91WWpF?=
 =?utf-8?B?aTJFcEZjWmRUVmZQblNKcnBFNlVBVGlsYzJCb3hzVXZVb2N2NVhCQzhzSkx6?=
 =?utf-8?Q?EwnI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2krV2FuWnlUVTY3cDJtTWhZQlB6MXB1WDJsNlNCV2dKekpIVlRuRTBoNUhl?=
 =?utf-8?B?OGR4dThoWWpiQzFZb3hFRmxPai9FekkrY2ZGdnp3ek5LMXdGM0RnUXZBOVNR?=
 =?utf-8?B?WjdMNnBLcyszQXEwZHo4aE5LUk15bjJJM2xOYjBJZUU5Wk9BVnphMTJvTmVm?=
 =?utf-8?B?dWZnNGcyZWxDSGlxMGhvaXpOaklPR0p1MURWNEQ1UEdoZGdEQnMrS0xNUDZT?=
 =?utf-8?B?dGNwUEZPT1R5WEZldUEzLzBkOUVyNUMzVVhsem5lQXRSYUxJQnRJZllQcDVK?=
 =?utf-8?B?T1lpOHNITktyZE9TbHdoc04yLzhXbkJhOS9yWXEyd3poZHRrSjMzc2s4K1VU?=
 =?utf-8?B?YkswSElCczVPRnBtUDQ0eHZVMGFRMEtMVnRVdzZvRjBUaTY2N1dicE9tSTVD?=
 =?utf-8?B?TWV6QzFTbDlQZnArNElWRXBtSnZEaVJjZlJINElpRU1mSWJSOEFIbE5VRVB6?=
 =?utf-8?B?aXc2MzdMMjFKREdkbEJ5WUUzcU1UYWNVbkUvTEVNbi91aSs3cTFQcFg5T1FV?=
 =?utf-8?B?VjFVenhZQTNrNkxXTkdLWUkzRXZDOFRTYU11aTZBazZKdzluNGdCaXdtcFh3?=
 =?utf-8?B?V0lCL2E3V0xCU3VYdGFoUVRSTVhIU3dKNG1nWC9pK0hBK1kxMUJoeC9vamdV?=
 =?utf-8?B?dDlURnUvT2NnaWdNaXFFekw5OE9RYWNUTEQxNmk4VGJLdjIwTVZVZXBRRis3?=
 =?utf-8?B?OURiazArMFdndWNxR24zb3NVVGUwN3RucnlVYjE4WG81R3RMcndTR1FuMnNN?=
 =?utf-8?B?UGl5WlpvRHRPTXNEUkg5TU5wdnEwdDFBaFZ5ZGlTd245VEhhbWlFQVRNUXRl?=
 =?utf-8?B?dC9kMXBtbGptYU9vWnk2WnRVKzdOc0RUMlpYcy9ld2I1ZjNNREpWbmlWTFgz?=
 =?utf-8?B?MnlQSmQ5MDgrMWx6OEIxUEwwenpGRTVCdFJiRlZFOG96eWsvTGZtSFR3bklR?=
 =?utf-8?B?ZlhPTk52M29vUk9wRW84d2F4Wm9VS1RZRnFDdzVRcXpIY2diNnZKbDF1QUp6?=
 =?utf-8?B?bUdMd3BpeVVWSC9rRG1BMlIrK3ZtSWhQOVVaYU80YjJRY1V1c1FzQzEvSHRF?=
 =?utf-8?B?OG9tOXdZVitDVXFuMzZvd0lNd1lGZFVOaUZ2RFUrMGkrNUdKVlcya1ZhcUZS?=
 =?utf-8?B?OWViZkFQclhrVUhGVUIzcTRVM1owU1VveXcvUWlyWjBraXl3WVcva216QVVE?=
 =?utf-8?B?b1dBY3JrZkZGTzJYdy9kRWF3anlSRFBjUzFxbDRvOXQvempMOVo0VXNsYkR3?=
 =?utf-8?B?VEpRM3hLbFJQU2RnL3ZmMjcrbmNCc1EvV2xoWk1RQ2tkTjlxRUR6TlR2czNB?=
 =?utf-8?B?UTJZZEF6K3dYdWkwV1NKMjROVVBRTWw4bkRnR004WlBOdEg2a0VwdWo5cmov?=
 =?utf-8?B?RzJCVFhxZXFGamhySHlBZ2hlczJWK0ZORVhLM3JWMDRmb0Y2MW8xcS9WcHd1?=
 =?utf-8?B?dHAyR1lxdWxPRkhhUUkxQmw0ZVRtb092NmRCcnZ1RmZiL3NkTjhBQVFwSzgx?=
 =?utf-8?B?djM1TndNeWJVeDNKeGQyTzZGeFRvRzNIMFFjTXdlWXY2elFDbk5WWDF3Q1hj?=
 =?utf-8?B?Qk1ZVDRwWDFSMXZjejI2aGlmbGQ0NVorMkJHSTBWb3BnNUhlUC9KQ1h3OVlq?=
 =?utf-8?B?MjFtYVVBNVBoOGc0SC9iU0VKZUxSYkc4bklKZnNqU0VqTDc0VjJqaWtlaTdM?=
 =?utf-8?B?dlFrdk1wTlR6VFFQaTBnV0ZJWlNsdGJhdTZVL0FDcWNaZTNkWXJReWw4eUV0?=
 =?utf-8?B?Qy9jajhVbC85Y3FZWDNFSzNWc2RzUTlXUWM1Q3YwVVlvOGRVbEhIRjhJSEZi?=
 =?utf-8?B?L3BOblgrVVJISU4rYUVac1l2aDZEK3g0MkFpWWk4VTZ3Y3drS3BuTXBxQ3hp?=
 =?utf-8?B?TGNEdCtSOTgzbjFMVkpSb0NSdmVYamxnN2ZReUpldldVV2N3TjB2R1Rmc09v?=
 =?utf-8?B?TU44R1pxeXBadkdTb3hweTNPVnR1Yi9vcG9NQ0h1cGdzMTNjaHB5VTB1RlNS?=
 =?utf-8?B?ZjFOQVdQQWZDZWYrTlBXeWJmVWNRUnJHUzJyWUh1eU5vTU9sckJiTm8vTFEz?=
 =?utf-8?B?RFlFNDcrYml3NGxtb0pyS1JlMVRGMWJzUXVqUzFLTFBPU1VJd0dhSE41cHNl?=
 =?utf-8?B?bTI5U3YrdE9RTFFoS0pIdUZ5VC9FTkNDSVFRbGhkaUdSNThqY1plYWRkZkpT?=
 =?utf-8?B?Z1J0Z3o5N0orQSsyYmFPREtidHI2NUY4aFNsSXRvZ1FSVE9uTkZqZ2pNMjk3?=
 =?utf-8?B?eXhPekhsT0pDNTE3MjcxNHpScDU4NEY1Wmc4ZDA1M1BGOHpIQnJHVmpqUmpk?=
 =?utf-8?B?Q0IvWWhEbXNiR3F4YktUMTZsTldyaEppS2FtL09GaGVpandIM1Z4aW5ZdGFa?=
 =?utf-8?Q?XSSFE/ZZ+II0TP6Q=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+NjHuhkE/qIYwy/L8momwyFNjFcE39exjE5qvUAWzeEAe5tW7dkINTs9ZXxpbShE0vDfWDES4f2GFTMSarhk+1JrqH3AuBUxV7/FSFTP1C3uHFLM3EWWfzD8fyA76VfAI+N1NENV9wyxCi7uOetCqQ6iyYZ9p/+jEmQmwU/fsROBQBByOSIBXI50XZXRYOs1HebAwn9YAG8Ht2Y+H7FbuVq2KieadanqsnWEUCU4VVYiIDKL/CYJbME2mYFgFCsMojLDOdE7HZjG07R6e/2jFid9h2s7w1112vKTqEUA9oY8q/54Bs2lSxTh76KHkGYlNRwYg25YzpPQ9ccT8dcbteShEHwVPVPXEVSjDYuDnWOpWrfn58pl7bAs2PE/SfriRUNAyamI/cBE+6qTwoIE1vGmMoBoVV/6AXx3W/+4DYIVNcZxZ40DYbmb5Mlakos7Tl1eY4tA424M6BzbOs7+tlfZJw3/+k3WhcA6OXtq8iac9klTxxb9tSUjvUnQY6mM5QhrYC4odqcNaGIzWHVG6+2VdAxpwddiuDwjrL3PGdwPcCdATnxzHf5iuKo6kQqVa4iAFsuUQvAq1BMZjqUMJ6q6Vi4kwSAuKPh2eSyta/Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b33451ba-ce9b-431e-0bf6-08de5b27213b
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 09:01:15.3569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RS/U/sWBYb3pux0xTMj2QlV1JPD/9ZwaF3KuxW3BHo+D5tpMqlfPApDLKwdrM4Y5RNTzwvGOn8zfcI1A3jCJLFDe7ecmKEPHnwkh9c6SThI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5973
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=958 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDA3MCBTYWx0ZWRfXyDdaPtCRmMMV
 +twYJrbSVMj9vBM7OZxHu5y0NSgd0qIGBqNsGQeWs2Y0+G0ERTKf+QWu09CXNc788+PYTBiUEA/
 kImGiG0xzBudeLzmSNLpxSD9+uP39417MUpTNTiKBXlhQVP6aopRLoGDTCUlf1Oshb922YJlo0V
 wL/kenIG87rjd7aZ5iFoQ5RNoChy9mm6k5cVtMXFkjd1ZX3MyHcPsZfX2G/ZAxBhvuCqhjhShwP
 CZDS08YZ3Zo3M2q5+EPiJKrJZv6txuWNda5kcHpiQCQEvPv//XnNi/+cfvCPMuXDJCjK9wiShCj
 u1843LHtvLw1dWGGKdUNsOIVgoBH5fuBOXjA8/sWrPAsLy0IY29YdW7JtFjbLHaGTSJDjXkMhRo
 BPrRUH/v3jZBYDjSxL9eYIOvDyorFKx6kpC8iV0EH9U/1fh4pQxY8UMDqebo7FlrGvUksl5VEbT
 A3P2fxQSQWKqhjAWDrCfZCA7qDQXnlA2kwrjseHg=
X-Proofpoint-GUID: MYXINWuM8smgxwxLv3-sWdeV9cd7nKzS
X-Authority-Analysis: v=2.4 cv=cZrfb3DM c=1 sm=1 tr=0 ts=69748a5f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8
 a=zd2uoN0lAAAA:8 a=SMgZLZ884CkMmZVNy8YA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12104
X-Proofpoint-ORIG-GUID: MYXINWuM8smgxwxLv3-sWdeV9cd7nKzS
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D86141C0005
X-Stat-Signature: qqwtbbqesm3q7gek4gck6eae5kkdm7ac
X-Rspam-User: 
X-HE-Tag: 1769245290-669843
X-HE-Meta: U2FsdGVkX1+0ZvG618SVosFs/sJ00Wc7oGdQnjmrT4PJY2nJGf9ugFwhlqfIZR7zgCiVE3Rxp4+59ADd+j34dNpgz5J9rV3LPOI3bbgERktY8fgIJ1/MY/LpUv2dGstglU9tjNx64KviBML7uGEO8i+6bheGRcGEELJtpdstVwDNVXY1C5TmzYNbjb+CKFQAS/2vyAv1R1tjJ8HXBwjOsEGN2VvmwFyrDuxmO+aPGc+Fs0IpQtUFJ3h77pAuSuTfHs3LlPCzLeA6eh305KLS8+In2/RFlhUxiB6ZwKzpnJzFS6oisniPWUHsatNQCRUvQXhUA21Bn7cRlxqWFLfJrAg3odnizcwlbiXUCSP/RWTW+x3uEP092Vp2hIwIAPtRQllJETSlXtN7otiF4I1auCFnDv1fSKiJareY+ZIbsrDQGxT6DfKcz0xmy5U9XvMWvwSbiCp0LaATsrhxeJ/dd1wlTpkRDa50LRKqUcUkKpeqi9QZnDUFaAcnNtSO6zFoXGeLngO0q45ksKGXGBaeNQMnO+7ws8x/p8pKN9POE4+cOGggvxMzsmXNtC9DV6vcyrGIoxZxBvUlub8ImCtg65JNIH57YCz/pcLAeRDMbT3XK89RxcGyQKRX33qwCc5jtgDFIzEXyU5IU6DiprNen1J2muYpCvxadkO7wbniyYM+1CP9RAteme9dp91xh+JUBl9hMLpcREaCioUkDeAT//mx0B+SqNrv2hcbUq3WHt5VG4CRNmn3ZGkW4TsJBFCu8OkWtwIAHX1iVNZF/XJTh2QWBso6GPl/sxXnnztW3SODh9AZkqF+KRxMsX/lnc9bZVq093QLZQAJYs9VUsfeEQ7S1XaB02e1CBeRtaSn9DlArJHHuaMknqITzncK7R28a5tIICJNMcseZV1J21xrXEiO3Nq+TSl9WIX3k3En0UVqUapR8rnnOvhKVre9u0KDxfpO3NtYpqOKVGEbJ/j
 3qavnGr6
 pYoJWGDLu1yuuVfCiZ3UdNhMnQb/l8GkgGHX62Dv1XkLYhHuRGUuJZ1h7xP8RAK6O/+sSWNvOlzCjXWSTo/gxQ6O0RrzH/ikzadw/PEIQgH0XKaOqfXmLlIiEuKsyHqXEEKD0AtbMGw1FHGWPQn7o1gqx9Vm8ismTxlTMryc9ifd8lPRILcQJDrhRZXsToM5txquvKHB2lZqeVvlPyvOv8dDyEaD0nq0FgpXKuJmQMJmSg18/aZFrLySMMpaE280iqc4kfz5+e8bHJt30Ob+Kie88Zy6w6QqnflmUd20JjOvee70Bw/FxJDGKJc+ZgaFT3uOjWReF+V9jZJA7Bf/z/qyAGP1q/RxwoM3WrM7Hc09R64rqRQUZ2zRlDi1MwvSr74PQsyazjwB9Fzy4pG4GpVsi915Pl3n6xOQtWygPRkqZzWNVBasHHZgiN/opXJEGTfgnTwI1x/3LOtRVWvXXsB9nWw0+byws3yfLYxIfW2JG5CUdcquFJ9qTtX22PnuBMyixkt8oZUWiwlfNflRHjBsXkNeFBgre7O98YiybVXZ2KwA3cXi8X34X+sbtnRXxa3HSL/YuMhX+OnOdb5Ky6IsMoHTo1hFm/cg2d1CejGBT1bttL5/Tb8SWrJ+52Aun4H8FENUBwBk+nWWjMNSi+iUIrti4Olnylym0Hys2b2tafZnu62XoH2d8diJ4ykbiayBR5cUTd5iKeDqaYA7agUHghCd1lKGEbTAmPr/Y2nIuQ9yWAjsQsH/hsAxQt5wnxH9Td21ngAN6BTXDtogIB1/Jiz8ijIldpc/j61ZZdQmUJ5fvFg7qGZ7Tkss+B7OGgxU/VvMcWHk59IzDEHdKzt9jIIrTaUDTTo2pQ9Z+h38iGaBeRe6e2+qz8bnNPQlSZPsuRnSom9VZ1gFOvyiUbLpkWtfhvfEPEDYQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK to this change....

On Fri, Jan 23, 2026 at 03:03:58PM +0530, Garg, Shivank wrote:
>
>
> On 1/23/2026 1:18 PM, Dev Jain wrote:
> >
> > On 22/01/26 2:58 pm, Dev Jain wrote:
> >> On 19/01/26 12:53 am, Shivank Garg wrote:
> >>> The global variable 'khugepaged_collapse_control' is not used outside of
> >>> mm/khugepaged.c. Make it static to limit its scope.
> >>>
> >>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> >>> Reviewed-by: Zi Yan <ziy@nvidia.com>
> >>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> >>> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> >>> Signed-off-by: Shivank Garg <shivankg@amd.com>
> >>> ---
> >>>  mm/khugepaged.c | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>> index 1667abae6d8d..fba6aea5bea6 100644
> >>> --- a/mm/khugepaged.c
> >>> +++ b/mm/khugepaged.c
> >>> @@ -827,7 +827,7 @@ static void khugepaged_alloc_sleep(void)
> >>>  	remove_wait_queue(&khugepaged_wait, &wait);
> >>>  }
> >>>
> >>> -struct collapse_control khugepaged_collapse_control = {
> >>> +static struct collapse_control khugepaged_collapse_control = {
> >>>  	.is_khugepaged = true,
> >>>  };
> >>>
> >> Will it not be better to just remove this variable? In madvise_collapse,
> >> we defined cc as a local variable and set .is_khugepaged = false. The
> >> same can be done in int khugepaged() - define a local variable and set
> >> .is_khugepaged = true.
> >
> > Since this patch has been stabilized already by 4 R-bs, it may be a headache
> > to now remove this, we can do my suggestion later.
> >
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
> >
> >>
> >>
>
> Thank you Dev for the feedback and review.
>
> I've attached the patch implementing your suggestion and sending this as a separate
> follow-up to avoid disrupting the current series.
>
> I’m happy to queue it for next cycle or if it’s acceptable now, please take it.
>
> Thanks for the suggestion!
>
> Regards,
> Shivank
>
> ---
> From: Shivank Garg <shivankg@amd.com>
> Date: Thu, 22 Jan 2026 12:36:28 +0000
> Subject: [PATCH] mm/khugepaged: convert khugepaged_collapse_control to local
>  variable in khugepaged()
>
> Make khugepaged_collapse_control a local variable in khugepaged() instead
> of static global, consistent with how madvise_collapse() handles its
> collapse_control. Static storage is unnecessary here as node_load and
> alloc_nmask are reset per-VMA during scanning.
>
> No functional change.
>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/khugepaged.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 9f790ec34400..c18d2ce639b1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -829,10 +829,6 @@ static void khugepaged_alloc_sleep(void)
>  	remove_wait_queue(&khugepaged_wait, &wait);
>  }
>
> -static struct collapse_control khugepaged_collapse_control = {
> -	.is_khugepaged = true,
> -};
> -
>  static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
>  {
>  	int i;
> @@ -2629,13 +2625,16 @@ static void khugepaged_wait_work(void)
>
>  static int khugepaged(void *none)
>  {
> +	struct collapse_control cc = {
> +		.is_khugepaged = true,
> +	};
>  	struct mm_slot *slot;
>
>  	set_freezable();
>  	set_user_nice(current, MAX_NICE);
>
>  	while (!kthread_should_stop()) {
> -		khugepaged_do_scan(&khugepaged_collapse_control);
> +		khugepaged_do_scan(&cc);
>  		khugepaged_wait_work();
>  	}
>
> --
> 2.43.0
>
>
>
>

Andrew's already commented but this is terribly mistaken.

The argument against it (why did nobody check...) is that this struct is HUGE
and there's really no benefit to doing this.

Nico's series makes this struct even bigger (...!)

Dev - PLEASE use pahole or sizeof(...) or something before suggesting moving
things like this on to the stack, in future e.g.:

$ pahole collapse_control
struct collapse_control {
	bool                       is_khugepaged;        /*     0     1 */

	/* XXX 3 bytes hole, try to pack */

	u32                        node_load[1024];      /*     4  4096 */

	/* XXX 4 bytes hole, try to pack */

	/* --- cacheline 64 boundary (4096 bytes) was 8 bytes ago --- */
	nodemask_t                 alloc_nmask;          /*  4104   128 */

	/* size: 4232, cachelines: 67, members: 3 */
	/* sum members: 4225, holes: 2, sum holes: 7 */
	/* last cacheline: 8 bytes */
};

Making this static was fine. Leave it as-is.

Thanks, Lorenzo

