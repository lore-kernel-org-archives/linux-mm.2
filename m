Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F481CCFA18
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 00:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54C18E0012; Tue, 11 Nov 2025 19:36:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6A08E0002; Tue, 11 Nov 2025 19:36:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A291C8E0012; Tue, 11 Nov 2025 19:36:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2B68E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:36:47 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23AD71402A5
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:36:47 +0000 (UTC)
X-FDA: 84100089654.15.D187912
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010001.outbound.protection.outlook.com [52.101.61.1])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4938C4000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:36:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MMjVB8JT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.61.1 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762907804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MM8lgBCm6UUgN6+1hhX+Oa6dRSRxkRGTEj5lsNqDe0w=;
	b=RC7DmNxnNMPfEqfYwS9ng0uGXS/xsVTSBSATFQMSIX/kM8hIt/YRKVu0fvUD+D3I8id7pd
	YaZJtwHiQFEC/YNEVrJqlEIOpY4dxUAtXLxkeKJbzbgg192pSXE1ATzphSJ/hDQoyazlhc
	4pthQVdV/WK4Ux5ktOiZQoY4djdLogM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762907804; a=rsa-sha256;
	cv=pass;
	b=TwykVz9qF3lNdpb4fqOhdUzYglxiVFC3l/6LDqTy/gXoFRk29Wy7SA50J/LGHHUmwcqMxf
	rWSTgJpfXcGIc9lPE1jJ5wmwHi0HuLpjCJuKbPyvJBuaGvvFUelNd1nVK9doA3zmi2kLe3
	GDMtMruxIK/E4zp5HENML9YCxunPXC4=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MMjVB8JT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.61.1 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t3JIz3DMjlGQBRlLnX9J/xUMfHoqF4OiCtj+X5MZeV7qsLaAtYZDL6gzonfoMcoPSKQB+KDWaWWc3WXwhWtUhTZo2E1qbiLNeJItkbJkL27xAl/udJS0ak0z5tpg2jffnRXg3v6Tmx5AiFCdyI41qx9T4o/AkD7xpUM4As7iHTRzQzBcSDN7ab/h6I3fOcM6CD23FL3ebksNT6ojSvXlH1PxLgFSkGcLgZ2JchJ+czc7DX1iCeQYEdsokm6XOTYKm7MXeT4W+gnxyt0I7fL+5vU9aVmWR/Dqcb9GAsoLFD+mVkXuQhS8KlS2BHij+hf9s9Va9hXpS5wSPCL0oh59ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MM8lgBCm6UUgN6+1hhX+Oa6dRSRxkRGTEj5lsNqDe0w=;
 b=yzM5euwa2Is7WXoj6kVh6eXDRQd7sGdLdb4/B4ul6OiCmA1i8jWzbD2sQSh5JT9sOwzIeky+X7ihPZrQgrUxfTZX3FBPWCcn2POpWdKS9ZpgVhfAQpJmpEMhfFx1lCsLEWyNiSKJ9EFz/hCfU1Im+3NIY1n5jNOs5mxtbtOdHclYzEWnBWq6zJvw6bmUlEYDSitIKvgipppArmfK/XyIpehOmoSKuUSAUffiveUaBy7dcAZZoe3H6AtyHBx78BDkyA1/0a0pBRId337XmEcYRc+70ekhxBwwhvv7xJtSqaQH1sMNI5V/BHf4Lfb6jN8x21IGOgekrGpbEAiZtKJHPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MM8lgBCm6UUgN6+1hhX+Oa6dRSRxkRGTEj5lsNqDe0w=;
 b=MMjVB8JT36TGgvAstnPgMkm3EBxQWPMoFttzpM3Z4H8zOhG9iHddSeFeIyu63elRTdpuc0yvIhR4tAdXmKAtl+L6IcZtl32DkZ+uYW3KnSFcVFxFGzye13oGKZ/1HiV1ILkc6AWMoFyehLML+C0Y36A7kjvhgvpnSlDtPxlhAxeSnEERdRlefc+ZED6TIfK6zwrhxUS+7oih1i4rfl/WUWU9+X3uFS1qA6f+mlR/pl5Kttg49lyP8UHqkOSyTMdN6E+VFAi1ai0ptDYelbfCt3eEhTCgYSNYcwNGN9WGpDrkqx+uZyJc41Ax9ZRWsk1uREoxs8q4mRZCOOe5J0HXOQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH0PR12MB5630.namprd12.prod.outlook.com (2603:10b6:510:146::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 00:36:38 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9298.015; Wed, 12 Nov 2025
 00:36:38 +0000
Message-ID: <fce3cb20-07b8-4cd7-ae7e-5800bbb53ae7@nvidia.com>
Date: Wed, 12 Nov 2025 11:36:29 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [v7 00/16] mm: support device-private THP
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Brost <matthew.brost@intel.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
 <20251008201740.d9507f4807a73058d4da23a8@linux-foundation.org>
 <a5992f11-5841-4bbf-b190-b5df41b68b0c@nvidia.com>
 <aOePfeoDuRW+prFq@lstrano-desk.jf.intel.com>
 <20251111154326.bc48466a6962fbbffd8ebdd0@linux-foundation.org>
 <7a0f2704-80b5-4cbd-8f3b-ac03692eefd3@nvidia.com>
 <20251111162403.709f37d86b67254765c7846b@linux-foundation.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20251111162403.709f37d86b67254765c7846b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0377.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::22) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH0PR12MB5630:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fffc63e-0c59-450f-aa50-08de21838a9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZFQvbTk5M1Rxc0UwYk44Zi9iWGk5NHdkWU11Si9uVEdNdlk1SjhkR3h3dmYv?=
 =?utf-8?B?a3hYS2dmL1BrQnlONzFmSWw2ditTd0FkNWlmbjF6T0FuVkFINGRxckhYM2Jl?=
 =?utf-8?B?bGNOa0U3Z1VpVEhoN21IRDBFbHQ5UVRBbW5MVjNWTTdOY2Y0ZnloL040N0VQ?=
 =?utf-8?B?NHk2OEFxd3VSYm1pV2pyZ1ZHelNnTWlWSEFmYVEyK3VPUnpONFM4ZG1VVmJp?=
 =?utf-8?B?NlZPUU8yQlpyVDJObUVhb2s2VjY4ZlJKeGY0d041UCtMT0t5NFk3b0k2MVFS?=
 =?utf-8?B?Rmt3K0pqd2EzK296K0RxVVdiWHpmV2RCRDlzdHJlaDFJRmI2Zkh0U2ZXZ0xB?=
 =?utf-8?B?VXJqb3dBdDJmNi9uOW5veVZqa0Z1VGV3K05FU2JsOGV2Q2F0TGlkanc2dWtt?=
 =?utf-8?B?NUlBazY3NEk4Y205YlQ3QzB5R1l0djBKNlBpWnRBdXBhaDdHbGZJMmhmS0Jz?=
 =?utf-8?B?VGFhTEdCbGNuNnNScVdzMWVaS0lVUm5PVGllNVZhaW83TmhwVVBJNi82R04y?=
 =?utf-8?B?TkE1V0FENzEyRDB2U0tFMUpYbU8vajlUc1hJYXFRcDJLQzJSa0RVMjdSc3Uv?=
 =?utf-8?B?dnVzNVQwTm1mRitQRDZybFU2elBKcWdhclllTkRyRUltN3BJa3IzNTI5Zlpu?=
 =?utf-8?B?aFlpMW8xMy9XNjJLWFNFdFM4TlFRcTFuZTlUWEQ5cDRaVnF4UU9VcDFhNm9D?=
 =?utf-8?B?eTJGZkIvWnB2VGlGTEJhWlhuWmp1VEhVcFpFUWFuNkt5NStLT3RmNk16ZXgx?=
 =?utf-8?B?cmozMGhwQkc5ZmlTTHdRYUxZYlVlRGlFUkNscXUvcDZmOGpBZ0pYOTNiTUVw?=
 =?utf-8?B?QjA0RWVDSHRrcE5uNlJTTDU4enpJWU5pZXFjZ1JKL29PSHFteWJveGJMK09C?=
 =?utf-8?B?d1BuWXpUMWV1NjRKM0VPZ050TE5LTkxTYzltVTdNMUJIcGhaTUQ2YkxJTEw3?=
 =?utf-8?B?aStlRmM2ZXoxSTEvNHAwODI5Rm9TdDNRNmsrK3drUlhCZ3FJS3dZT2d3L1Zn?=
 =?utf-8?B?anhYZWdDd0hlVWF3M2VFbEIwejZ2c3VyWG1PTG9ySFhlTDZuWlZGWDYwSUFn?=
 =?utf-8?B?YlJYOTlDOTZCR3Q4OVU0MmUybUh1cUhQRlAvOWV1VU5lRkZRNGlnUGFqWEFU?=
 =?utf-8?B?QlB2aDlFUGNWZ25BaTREcDNTK3REQmlBdDdvRElIM3B1WHNVRnlmTHJYeUVx?=
 =?utf-8?B?dk5Ia2lIMUh5aXB5UjNyU0lZWG5vQUN6U3V6dWFIZGFXY0pUM0J1ZldtOFg2?=
 =?utf-8?B?Q1R0VzdCbjByZ2QrWi8xZzNtaEtrajAwMzJzdW01MUVxT01zMUJTeC9oQlB0?=
 =?utf-8?B?ODMyMzNzd1Eyckk4UGRqTDhJOUY2aHB2MEZNRzJFbUsrZkY1b1VBNmh6NUl6?=
 =?utf-8?B?K3FpN3RuTTNuTm9EOTJUUkl4ZDN6azBsU0RXaG5zUDAyVGtwM3hNUUU0a2JD?=
 =?utf-8?B?K2pQeEN2dTFSbjcxRVo3NjVYOVl6VTlNY25EUFU5Q1RBbFBNcnlQY1dQVXNB?=
 =?utf-8?B?bzFWRnh6eVFCendaT0U1OGp1aC9zZkVMSW9oc2hMTzVQT3c0NFlIS0pYczVY?=
 =?utf-8?B?OFBYa2dodE5FUWFIN2VmMTFFaUxLSzA3aEwwRG9va1VZZlNINmdxc21NL2VC?=
 =?utf-8?B?Q0VGNXdaZUFCWm5xRVkybmNTdmhQdHN5ZmFwQ0lYWEFZeUpkWmt0UStOVTRj?=
 =?utf-8?B?d2x5Qk4wZHl6UzhVbE1BYU5vbTFNOHFLeituQlFUQTZyUGNWN1YzbmZvajdq?=
 =?utf-8?B?dC81bkFZU0w4Q1JjN29ON04zR3BFdjA4bHJ1aEc0eWRLSk03ODlhakJ1bjZU?=
 =?utf-8?B?ZmFwL2U5NVZPN3VxVUFNU3g3SXRHOWdBV0FDQmtKOHR5eUtUd3VwVEkyM2Rh?=
 =?utf-8?B?bGFEdzlUM2k1K3o3QlVBRTVMeFVVWUZFNmxKZm1RN1E0Yk1Qa250cEI4UXlh?=
 =?utf-8?B?dUdqTWVaR1A5eU5ycXkzaC9wbEg2WVdSdUNZUmx1ekNVTGFpR1hjWGlxMzNr?=
 =?utf-8?B?RC9pV00wMElnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1k4K1JaZlhGMkd4aGwzVVpEWktpY05qRC9pRS9LSk9lY0NDbm5RVDIzNGM3?=
 =?utf-8?B?VXNkcCtFaDRiTkFmSFNpT1VTcjFBcGJ3M0ZZaDQvME1mQ0M0WHo1RkY4WXB5?=
 =?utf-8?B?ZXhuUVFDdHRrWEJBQlY5NjAvU0pGNTZzdE16Rmg1bzUzWmRneWNTN2pnS0VU?=
 =?utf-8?B?SSs1bU9PcU9GTi9kUDlKOXVOYnI1QmJFbmtLaWM1cmtzK1NzbVJSc2VBb3N5?=
 =?utf-8?B?WW8vNlhFZGY3aW1MSGxORWhNZjV5VlczMlZRQm1hZlUrVzNBSXZvSS82V0M4?=
 =?utf-8?B?N2NjVG9qQjBsajNMMDNvV1M1Z1B0djBJVFdXMEpsWXBBV3dyVjljRnpJTmNY?=
 =?utf-8?B?N1l1aWc5bUlZUkMyeHdSWlNaZk5MR2NnZnBUQ2FqUy9GSThpWEFOc1JyNHpx?=
 =?utf-8?B?SGlXWVU5aU5WTmpoZHk5MnRUcXlzc0dmTGhQUjFGS1pZYkFxcllOeWdZSVJF?=
 =?utf-8?B?YVhoQVlLWWVCbHhIN2g2bFRUWVZha3grSFQxWWR3QXR6eUk0RXB4NWl4TENK?=
 =?utf-8?B?YmpEdDZNWDNDNzR2VzZ3OUJzZ29YY0VWSnZ2M3pDcDUxeWsxU3YrRG1JOFov?=
 =?utf-8?B?TmNBcmpyeDRrR2YwbXRzRFNmZ1grV002enppU0tHdHhld2tGUUVSN1BiR0c4?=
 =?utf-8?B?SngzYzRhUHpyUFB6L2NIb3NWSm9wcXhEZGNJMGU0ZElQU0JUbHM0TXZDRFJm?=
 =?utf-8?B?SklvSk9xR2ZyU21SczB2VTFjRHh2RU9jVzlxelFMNlNUVWdKaStRdHpYSERk?=
 =?utf-8?B?YStJMzZQVWhOQlVCaTc1YnRlbUdPRmovdVQ4L2xOeDRheklGZmNMaEdIS1Mx?=
 =?utf-8?B?NEp3NUkvTDJRMjN2bXpydHVLajByTllJNjA4MzNBeGNLVXVTSTRoMTZiMGtu?=
 =?utf-8?B?Z2d0NW5scnNuSXVha0s5WFRFKzkxdkxuaXB5UnhlM2VNM2JYcVdCUThWL2NL?=
 =?utf-8?B?NUF1VzNtVlJIeUsyNGtIWWxHZlN5dEs0TDgwT2JjdzdDSHFITURaVEhoTWxP?=
 =?utf-8?B?a1o4Q0ZJS3FuaU94QXBPTGtSWU9qRkhCYkVUYVVHVFVlRGtCc1E3RGdkQTNy?=
 =?utf-8?B?MU9SOUg1TzFubysrdjVMUmE0Z0cwVDlHMVV5RG1Zb2RobDRadTc1WTFsQWtP?=
 =?utf-8?B?Y0RRZU14dmJSaHlGNjFxRkxVakpQS0lzOW12R2N1aDBBYkxCR0NneW5IZTZq?=
 =?utf-8?B?QjZROU8xNXhlaXZ6S2tnUFhFQ1dJU0lURUNYYjlQelViVm1IMk5uYXFPK2ZK?=
 =?utf-8?B?c0lkQXNiellkSXdieSsxOEJORWhUa2w4RzZ1aUp3cW12ejhwanI3MkJaRkRU?=
 =?utf-8?B?algvNURXVjRsNG1jbzczOXA3dTIzTEFqMHdaSDgwd2ZUcFJZNVh5cDNzWS9j?=
 =?utf-8?B?RnJvcVRRbEVzY1BQT1NZYUlGUEZRSmtkWVErUkFaaVNGc0hVNXpLNDV6QjBU?=
 =?utf-8?B?K3hpcklyU2J3bkkxVDN3dHdqc1dVNGMvTjNNMWRkbXlBVGtFdW9Jc29tTkUz?=
 =?utf-8?B?NGNPVGZLWkxtQmdlWlIxNFRTeFRoWHRtTGQxMW5CY3hlZWkvSFR0dzZnOUVI?=
 =?utf-8?B?WjExTS81UTVTM3g0T1ZNanVwUHR4d3FScitlVDRZQUZDWFJodzhCbXZXWGZo?=
 =?utf-8?B?RHRSenMwcDFISExVaDljVW5CTW0wZ05WSi9UakZyYlZucjd6cjA0VjFTd01h?=
 =?utf-8?B?d2pMR0ZUeU4zSTl5dVl1a0l0am1lQzNxcURJNGxtcnJuQ3JOa3VOcmhaNThU?=
 =?utf-8?B?S0M3empyUFEwVEljMS9yT09vdnFVKzEybkVvbFJIRmwxVjRCamxYQk1QRHp2?=
 =?utf-8?B?NzdQZGp0UlhXSDdsNzg1cXFDamFBZTZlaGVRM0p0SVhmN0ZYK3VxVGJxa1ZM?=
 =?utf-8?B?MFc5eVFWMnZIQWx5b3l6aUNBNDVqRThjOXJ6aEFGNlpJZGx1WDI2VzJ6V1I4?=
 =?utf-8?B?TURndzhoUTAxZzY4NTNPL01YaFlHeWhoMUorQzRQVG9SQW9PK2N5WUx0bUw1?=
 =?utf-8?B?MVpWWkM5di91eHRSdVFSSDZLNFFmano4REdTOUxWZy9pN2xiNmRINjlWZWla?=
 =?utf-8?B?cUV4TUxWRzRzQWliWkNLbHVpNTFPVjBvNGJvOEJuci9FMTVab2hjQ2E5UHJo?=
 =?utf-8?B?R0x6bk5LaENvZEhiNWdLblVKdVY1NjFWdjErTGVRK1lKVHNOWG1jUy8xNGds?=
 =?utf-8?Q?Zlyp4bnt4eywv+VcfVGnBAn2VlLeYMxbaKBAud+a7cS/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fffc63e-0c59-450f-aa50-08de21838a9d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 00:36:38.5372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QiyH4ElMwM+3E1o12PZq1QUMKvencNocWFOIZwo5VU5R6HOs3nls/Un5escJDp4+xVIiERqdZhcFVTaesn7G/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5630
X-Stat-Signature: imnhsqkyd4fektxprqqnnzbkcj6b8wau
X-Rspam-User: 
X-Rspamd-Queue-Id: 4938C4000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1762907804-34250
X-HE-Meta: U2FsdGVkX19sgbfuseV8mt0XdKPUHmkHErHF5VpDoLNUpiwe+bTjdkSOB1FK26pp1YH748zQGJL7vL9NqJHadf15+758zuXdW9ofYeOY2TDlUU2MJILW6+6BJjRuThxtQJ7k5cH2YjFa4WlRTTFPliivGpjP/ozLURxd+nsJUwfIEe0EaEzAMHzhaa2AT2RX47yhKRnLBsPgdZ1jJvQQI+apL/F5ey2wVKlnBoILQwQ+d4v5TuODU5l6gHx0mZ/wOkpcMjAmWHyv7DhRsTDom7KaDUZg4a0/4LX5NeNEbWt7zgedQ5yyVFGVlCuztYe1VaKrWLiZh6HzzH7wDI5VHO3ql4N3v9GSZRSfpq4yV6tziAxqEen5QBDMt4Fztfi7IcFo4uTCXK4qvjZp1OVgR006t4eyL06l0mxgk64QWUNn/k0mH97FhuEiTS5qaH7D40nScCbKgnm9WYCot9omiA5V1kuzY3pcbcAVJoqWTovG2W9H7Me9cdYS+3xycL9m6shCr90ie4DbHaDLFlX2aCiCEcdoHc48YImFxH/FuG2VpOZLn3Dpm/FHAqyZSnYkSxMh/Q02lqQxB1Y2su4zHQr5z4zQ0EjvaqGbWt/uiCnKuRj42iOkdg4iHpKBk5tOdAplEaIMRZyoOcsw0PPVnQ+Dx9zlDteBaDzn8BnTHRyjk9Fz4ZxOXWRl2F/2hwGNa4PesEtmb/+ehifVY/3l22RprXQ9bdWIHPVB0DnRySrVqlB+sdMZsohLNRtcroHUzpnrH9NjFPjPogI4IQRG0gGBlYND5F0FUzoQ3UZVnYMA/R8OgXqRyJRkb3wBgnnOUOvNmGr2WkJI1cWo3GuwaJnTAOJj2l+i5n303X1oQRP0y0SDZ7KEaqY/yHMKj5pvmsvbCs0GX4o7E6gs5YoZ132uxIikTPnPjlzstFEWCsa5KbIneahOL755itYGoKRME8NZKymvxJvnH+t+S2V
 xAQthP9Y
 3ZDkyE8i9lW9ixJBRFyOVoBWHKhe5NBJzrZac3/dJzIB0VLVVd+fsFAKTn7/4YLhnqR1i7U/iake+WMVxj8mKP1vN92Bf0pkq5iFiYlbojyHmDyJBkQDmqj20ODePugzjTQqytK+OedDVX3y64e2CP336j/jSnmx/bk7YKKg2cnP6zYpHMkWMrdPN/sGA40uhfXs4b+qdfVaO8eTmYssv0M2Jwo4RsmNTOzLgMQR0GHQv7pyvccZ+GR6UYXtyJoeT2OFfJxw3pMjNcodShg5kSDiRyA9GxwCUGbIX3GTgEnHBNYRnW/M9i3rnomQ/sCN5DatNy5HhwawrXmG08eEquz8Pb1QMFWFytBJp2pBHu3K+WfT4wq632sSX3WYKrsi+46TnTZs1jN1WnFXo0LCxgHY4oXZtzhXQGwWvQV7xAG3AgeDC9ibSWXpeMwcNW1Agr8m5OpQb6jTLreJ31G1bSj+OqIF+8Z6a8AzjxXHRgJzJ5Sw+bjkAaV0/W1BnxyoI/7gJF8r8k9Drz3qGQirXQzJtQjnwbd4NPW96gRpgM+AvXno=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/12/25 11:24, Andrew Morton wrote:
> On Wed, 12 Nov 2025 10:52:43 +1100 Balbir Singh <balbirs@nvidia.com> wrote:
> 
>>> https://lkml.kernel.org/r/62073ca1-5bb6-49e8-b8d4-447c5e0e582e@
>>>
>>
>> I can't seem to open this
> 
> https://lore.kernel.org/all/62073ca1-5bb6-49e8-b8d4-447c5e0e582e@nvidia.com/T/#u
> 
>>> plus a general re-read of the
>>> mm-migrate_device-add-thp-splitting-during-migration.patch review
>>> discussion.
>>>
>> That's the patch I have
>>
> 
> What I meant was - please re-read the review against that patch (it was
> fairly long) and double-check that everything was addressed.
> 

The last discussion ended at https://lore.kernel.org/all/CABzRoyZZ8QLF5PSeDCVxgcnQmF9kFQ3RZdNq0Deik3o9OrK+BQ@mail.gmail.com/T/#m2368cc4ed7d88b2ae99157a649a9a5877585f006

In summary, removing the cluster_info and deferred_list handling
into another function lead to duplication and so I've avoided
going down that route. I'll send the new patch out shortly

Balbir

