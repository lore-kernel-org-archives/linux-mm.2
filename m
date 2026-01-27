Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E9F7C88E41
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 08:18:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31FF6B0088; Tue, 27 Jan 2026 03:18:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFFC96B0089; Tue, 27 Jan 2026 03:18:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0BD6B008A; Tue, 27 Jan 2026 03:18:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C30A26B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 03:18:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DF64C3578
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 08:18:42 +0000 (UTC)
X-FDA: 84377042484.14.38D1D3A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id B6891100003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 08:18:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GATRv06D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oRAiQsmG;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769501919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GqRjeqsSAB8+qxc+vUZfybSRHbXu7n6QpQ4qupKDn+4=;
	b=gZlXWY8ZpgLOMo2sbQvGVg4VzVM5tMCk1yqIFVw+eymKaTq/1EtfauCvw+wZLFnhfPsshQ
	/yUF/c0gMHNNWAh3/mLRba4wKF0fP0REI2WxqF/VyqUcfclK+HyAIcDhV6wvwaMO+yEe1n
	oUHwlxBCl5vA8nZ7/CnEvLF7/kUIY0c=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GATRv06D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oRAiQsmG;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769501919; a=rsa-sha256;
	cv=pass;
	b=qkcGuqtLYoGwUMgJ4PnhLfDkUegDI3NDpKRnX+OA9Fq+KfxEZ9W6yUJsZTBLrUOarrH5RP
	OPqiY3Nv15aCRSdLmwbIYpYQXJAW11/UaZ/cMpF1xWzo8z6ZRSXYmyeqFR8n4p2XR347rK
	kbYMyz6FMt1s2WPy5hU2a8p0UYV6Z+8=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60R0GY4M292109;
	Tue, 27 Jan 2026 08:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GqRjeqsSAB8+qxc+vUZfybSRHbXu7n6QpQ4qupKDn+4=; b=
	GATRv06DN9/w/sgGRXXLJx9VHJnfLR7V2hR8dHHEtw1OEDfRn1N+cBSN9gVLnU02
	Q+GyokQlXKSCeC5sBcg6ZD+Wkknf2M54G9O2Dy4M250PEqGq5U0tTxNs5Gkg4kUP
	VwfeM5n87a7V4UWOCpU8bKdQ2oqqydfn2JxO5uP4kAW/Xl2Re9zlX05ccZ28zOQl
	GtQ5c2VMuXZ4s1FSuICcHzzr1mXcSqLmeNugos5UBQ06Re/ghj95f7xAXEsA4Kvn
	9gJ/5xYmid3vIxfEbkAgL1MmbU38m8e/KQEa4EHTN8XQ1ez/SRZM4uENqN+I7F8R
	TXTLa92pdmavUFNorSESvQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvny6uk2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 08:18:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60R87C3I001729;
	Tue, 27 Jan 2026 08:18:27 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013010.outbound.protection.outlook.com [40.93.201.10])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhdm4br-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 08:18:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TsVF9BDDtIxb3iEjb5gC/2iCS4OXw2A5eVfRJc4xn4tcbKv6hZWIjqQK6Oj86lbNOY6m3x1KBiGRaN6vcqJ9ahDvdqnodlD0tTU2cfbTzXa+iKHPBUpV3heSvj+ucNfBrVEP8G1032K8rSHfOxHBNn9mN/iM4TbhRHCOKBGST4sEeN3c7kk0Dg2wRgcY/1u2uqNTEgKyJNGwkGUCebq5tjUP0Pe93jxvaV1EyMCcaA6e3JHt/YmRh+1EWQShkb3lhaLJ6Yw8Jkvp7VMRc/FbwE7Ah7I4eQ2PSFibvR7xxnJxiHvaR0FbBmx21UIfX6Gpy0xQE2Z4NC3VjOziOXVsaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GqRjeqsSAB8+qxc+vUZfybSRHbXu7n6QpQ4qupKDn+4=;
 b=NPeybZyrfarzC3L1cvsBSpmuKogbFohuWvOOAmLkYA2yDXPJkwtuvU019Nu1NERys274OdMw6KOQLJw61rZtqhJ57sgvf28/fxvrMLvYBzkNCf7IkkqRHqDqKwDyOn7BDrmxyLCmNeuQHtcPzNB1nwfR7JEU2yj9JlXZeRsbL5zl2ekxQnB6KvolL+cu1SVn8rdYHxbw22rIOVpFD3QKjQOhtX7K9o88QEKLPE4NoHnvM+acp546j6D/c9LsnKtFXoDjnZfERxXH2e0bqy3GpF17afTpcoK+YCgeT/F/x99S9gjXzWF6MwP9uncMYy9G8D2je2XZlUi4+VywK4ENaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqRjeqsSAB8+qxc+vUZfybSRHbXu7n6QpQ4qupKDn+4=;
 b=oRAiQsmGsERg9IOoLDq23uqYiHoWzvssnI22ceqK5YYqItnJQNhzRUGrJTgVlpuap66PK1cf+um6mGO3fDWNmy6mdBw98NNMzM7W/6UIVfVcelQd1GeeQswS2JlUejX1/N7tX8y35HqtpzIo2+3QSyekMGgwyNF6KMl+j6F+RLY=
Received: from CH3PR10MB8215.namprd10.prod.outlook.com (2603:10b6:610:1f5::7)
 by CYXPR10MB7951.namprd10.prod.outlook.com (2603:10b6:930:dc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 08:18:24 +0000
Received: from CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9]) by CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9%6]) with mapi id 15.20.9499.005; Tue, 27 Jan 2026
 08:18:24 +0000
Date: Tue, 27 Jan 2026 08:18:12 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Barry Song <baohua@kernel.org>, David Hildenbrand <david@kernel.org>,
        Dev Jain <dev.jain@arm.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org
Subject: Re: [linux-next:master] [tools/testing/vma]  28d7ff9930:
 ktools.vma.make.fail
Message-ID: <8b1135d4-387c-4c4c-94fd-22bc433a0e6c@lucifer.local>
References: <202601271308.b8d3fcb6-lkp@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202601271308.b8d3fcb6-lkp@intel.com>
X-ClientProxiedBy: LO4P123CA0122.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::19) To CH3PR10MB8215.namprd10.prod.outlook.com
 (2603:10b6:610:1f5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB8215:EE_|CYXPR10MB7951:EE_
X-MS-Office365-Filtering-Correlation-Id: a219a0f5-5f11-4871-6f14-08de5d7ca3e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VXFXc2crRWpmdDZzS3Q1MW54NzloUE1UVlFlenBGNmZYbHIvaHRHa0hzZHRz?=
 =?utf-8?B?STlJMHd6Vks1ZnVkUUtlOXZGTmlWMENkL0pFTzJ4ZlF1cTEzV1VDU09ud0x2?=
 =?utf-8?B?V2VpTzFMbkhnWUN2WnZjeHMrSk9oWUJDMEFLbVhwU2tnV0ViY0h2UU5YajRi?=
 =?utf-8?B?ZkUyd243ME51T3plRE9GQmdXQXRxMzIranRPWExnYzJXdkxVb2ZqNm1xWWJI?=
 =?utf-8?B?MUlRakJEdHRDVVFDOXB0aVhLU3VnQkxzdUhKamJUV0h6WmxYV1daRkJsamJv?=
 =?utf-8?B?NmhtUzUxSFBkaHRBaFlubnhUZkQyS2duR1VENEJLVEMxckY1VVpDZXlFaDdK?=
 =?utf-8?B?YTErQVpxdXAzU2lwLzhseEc4bk00eEN4ZVZ4UU15WHFiK3RTU1pMa2pPL2hy?=
 =?utf-8?B?YURGd2tyZU42U0UxeVhFTW12RFNoRUZsWDhwRlN1M3RNVWQwaWxla1hlazRl?=
 =?utf-8?B?SWV1Z2dPaTRjR1I1M3M2Wkhuck9VSTF1VndSVXpWU1lJWFF6RURUY1NwUXRr?=
 =?utf-8?B?elZWdzNya2RGV1FFY29GaCtRdU5maHRiaGpETmcvQldwczE5ODhpMXphRWF6?=
 =?utf-8?B?MHp5L1RxSnFldHdjcnQ3R0VqVDJhc0hXSG9mK1BTVkljY3Q2UnlSc3ZBMFpy?=
 =?utf-8?B?dzlRWVBNbG1mWHh0am9NRTk3ZUlnUGVJSC9NcTFqRE1ERGdCVld6VGF6TmlG?=
 =?utf-8?B?YVBQUDUvNFFzOTE0R0svSTgvOVpYYi9IR0dKZW8zZHZOZzJ6d0dTUUJ1S29w?=
 =?utf-8?B?blk1VmJZYWR5RytoczZpTURubjhKU1dFazB1QjNlRlRXalVYMGVNR2RJV3B6?=
 =?utf-8?B?RzN5a2s3Z3F4RUN0Q1Y2L1M0Vk5tWTdlTlhUa1gyTWIrUU4vbHp0Y2N2ZFBU?=
 =?utf-8?B?MHB6MSttQTJZRDA3ZUUvZkpNMXM0a0dmamU5OVh6SlBTRUJZOWtDM096WHJa?=
 =?utf-8?B?MHZaanJYdi9LdWtWcTBUbUw1SU1RZERjeEtJZm8vS0ZrYTBoUFBwUEFZQk1H?=
 =?utf-8?B?WTBMek02d3F4VHFqcEFlQmJPSDl3SmpGbXRMYXZzZk5YYW1reVFvRGI2WGFT?=
 =?utf-8?B?eEFGa0lIYVpFampMb3lxRmt1b25nMEZtT3FPb25YQ1RCYk5nK2ZyVUMyQUc3?=
 =?utf-8?B?S3lhODROeDRkT0U3aDJHMjl4R28zTUhITUFwcjVIb2ZQWXZyTlcrakdtMEpV?=
 =?utf-8?B?RTBiNzZvZzZ6ZnlqQVFBbkgrOTZqcEJ4Qm5Rdlc2RVJnWS95R2owRkdGNk94?=
 =?utf-8?B?d1dMVzR2dHJob2ErQWduSGNRTHZFaVUwMjZmZXJ0M09NUTNNRXJUU1cxTG1p?=
 =?utf-8?B?dkhrT1dVWUhaeTdQZ3k4Q2FjVVFLZ1dnOGo0QWdsODVTU1pJdVRYaUd1eVVz?=
 =?utf-8?B?SkM4N2ROVVYvY3dBTS9WRmdON2E5a0VvNWtOYzBYOGtEYmliSndFa2NtRlRJ?=
 =?utf-8?B?QUpOUXV6OXdoWjRLWXd4T0F2c3BlQ2JxTUJhem0xbGJVRXBqSzN2cUpBczN6?=
 =?utf-8?B?OU94bXRYc0V1YU5xL1NHVEh3WXZsS0NWSXd6eTVwU0IvbWJxSW1acFJXL0JL?=
 =?utf-8?B?ei9oVFp6SW1DdHFJT1FmZ1E5RXlzK3pXN3U0RVR5dnhibDJJUUV2UWZnbk5m?=
 =?utf-8?B?MDVhcmgyeGxLWkdKaXAweGdRRlVicHpIQWVoYkI5cGs3TEZZZlBJSlJNT0ZF?=
 =?utf-8?B?L1ZBOERRSG5hZEpWc0tORHhjUXJRQkxDYWJMUlpGNWU1S2lqdk40WFVPZXpi?=
 =?utf-8?B?UmZaRlQ5aVhScVMvYVFmaysySVdKck0rbUhiZFpoZStVZ3dVZkI4K0Yyc20r?=
 =?utf-8?B?L1hRWS9hWC90SHBpTm0vZVVROE8yTGZpclgrbjg1RWdNMUFNOXNXbFFqRG95?=
 =?utf-8?B?cTV5cmtpb044azg2bUowbmtBZmhIWXVXTWgveTFVQ1dydjIrWTVTZElzWEtn?=
 =?utf-8?B?N0duVnJZbU1jdk42ek9WMTlKUDBMd1JPVUpMakdBWDNMaEFHWFRoOHllU2k2?=
 =?utf-8?B?QVBRRHNBdFVsRmJQOEFxZStWUXY2WSsyUVhtUHdmWHlrRzFoM25MZGd6dDZF?=
 =?utf-8?B?cTZ6VW1GTUpaWWppZnRCcWxSZXZocGFrRlZmczlpTVlCU09UZ2xhNXJ1cTdk?=
 =?utf-8?Q?IJlC0FHqqqcQ8RyU5vFN9KJC3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB8215.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3dhVWI5alZkU1ZkZE1TZ3dWTlUxRTdtbk1DRmovM1UvcUVFNGtLa1FtNmpr?=
 =?utf-8?B?N04wRmFXTWlDUWNZVWM2T0FQWjhiTTNRa2U2dG5YVlRqOXZQUWhjTnJVdlhv?=
 =?utf-8?B?UDdLQnlEenA5TFhLNXZwSVJ6N2p5QlZXQVJaek9CT20vZ3dJU29BZGV3QnE5?=
 =?utf-8?B?SkIrK24zNHVIeXZLR2dBTmxQN2ErZVhWZE9CV1A5K0Z2UDFoS1gvY2d0ZTBa?=
 =?utf-8?B?MFlmcGY5WEtYekFSRC80NVhsL2x0MittUFVBUmZQU1hwR05VNUFQcjByVmFm?=
 =?utf-8?B?MzF4cWRtTmZWdmQxZFdOWHdjTzlod3RobzFjYTRQeXE4NVQvdSsxYjdla014?=
 =?utf-8?B?THVNRDltUjFZaldhUml4TEFjdE5RekowYURkNXRxLzNCVkVQWEhnN0JGbHlr?=
 =?utf-8?B?dzcrRytXdUdHT3RnUHNJdVo1Z3pjNC91ZnJGZlpLaEdJenhnUmZ5cXYzN01L?=
 =?utf-8?B?RlJPSEl1eFVwcDNjUDZqVTlyWTNvWkN5UnBlS0FLYlNndi9JOFlwa1ZoTTRt?=
 =?utf-8?B?TjA2QVF4anZHdHNjTnFaSmVvK0dVY2Z2eHNSNVNJYTFXenRjZGd2U3F0emNl?=
 =?utf-8?B?My9FT3ZOYXF0dlVSYTBmUER0Mk1ZTTA0c2tlM285eGZaQ0k1V1llVy9lUFRP?=
 =?utf-8?B?QzZGbXVRZkFSZmZzcWdtTXc0RlhoNVNzMzhwNUQwc21IeHE3SVNBWGhCMjVM?=
 =?utf-8?B?KytTT2FoZk1rNHg4aFpyVzQzZVRQeTQrUlY3aEZ6K2d3a09pWVQrU3BPaVk0?=
 =?utf-8?B?MlJJUllTQXpCZGI1TTlsZnhLWVBYVWZvWWF2amljN09hVXhvS3lLU1l2czBl?=
 =?utf-8?B?TXdMYjQzMXgvdnp5TVMydWlrdUJ1K1pDdWtjNnNjV3ZLb0o0bURGWnVxWkxa?=
 =?utf-8?B?RWxGamsvVEtLbXpoQTFNb3oxNXc2UTZsOGpwYTcyL2txZzlPRmNIZVJSZWNL?=
 =?utf-8?B?VjkyMTYvdlZGNjQrOGlSa1BjYkRxdUxXbTk0czViVGltYjB0LzRWYUZQeGl2?=
 =?utf-8?B?bmhTVnUydzR3NGY4RG1pMUtYcjRPd29nTy9OS2c5dytCOTE5b3Z4WVc5aWdk?=
 =?utf-8?B?bWlsOGJiRVRaZ21hRFlLaGNoOUpnbG95N3F1THZyU0NyKzMvVDV3UkZzQTN1?=
 =?utf-8?B?NXZId2tlWS9GVlZ3S21zQnFhWmJLcTBJOVAzaHowTlExNXBpNk9TVld4VWpz?=
 =?utf-8?B?RDRCTjhvN2h2UDcyTFR1VWUrSms4d0F1Zms1dkwrbEFVUEpQNU4zTVphRWhV?=
 =?utf-8?B?cGdTNlBiN041NWp6Y2Zxa1NiczFlYnhkbWxCWHlYNFpYSFRvanBZRTkzZGp4?=
 =?utf-8?B?bGY0NHZOL0NBbnRGVDhQVkFPYWFQa3Y0eHhoZ3RYNnlzN2pKdVEvZmpOM3JC?=
 =?utf-8?B?Ny8yTmJMd0VnbEpKMzFXeXNjSStpRWFha3ZPSnZKWUxKendlVW5BOXBjcGxt?=
 =?utf-8?B?REgvTy9OOUdIZUFCUkVmbnFsbkx3eHZvRWNNd2RFaHNITWFNQnYxNUo0VG9W?=
 =?utf-8?B?V2pnWTZRSkQ5clRkZ01WRXNwRFA1b1VxMEtjKzdhVXMvVitVWWJ1Szd2VWZ3?=
 =?utf-8?B?U01EUDh0WkNDN213RXpxYW5xUlFtL1dUWk5hK3VlVFNVekhDZG1iZ0pFUnhw?=
 =?utf-8?B?d0R1bzlnd05EQUtoVWdHa0FRKzlRbUFxVWdRQUI2aHFPT3ZPeG9xUjJLaGZI?=
 =?utf-8?B?c0Y0V3lKNG5senFURGwzeG15QThQZnByYm5TZDd5Y01ta3lMNkY5cEFycUUz?=
 =?utf-8?B?RU9IR2tIMy9PNlV1bWFXdjV2UmdqdFV6SWZBWmk4YzdISGNOeXNWL21aQUhi?=
 =?utf-8?B?QjVhMGRIdU1IbGdkSlR3K2pLZE5WcWRwZDNtNE1nMTBiYStHY1g5bWpQSHdi?=
 =?utf-8?B?T1c3YzJLRlhyRUpCUUVVNk9tUXB5SzgzNlpZbk9rUVg5MGpzUExjWE40SDM5?=
 =?utf-8?B?SWRjWHdDSWNiSUFESzFncTZOY2FTVlBUc3JDOHJ3ZDVuN3FrRHlsMG94c1Nz?=
 =?utf-8?B?STd6RDdEdDgwRzIyM3hvOERsbXIvUkYxbUlIbEVaSXpjZ2s0aFY0QndmQlBD?=
 =?utf-8?B?YlN4azg2NmhXYW1WRWlDVERHZnBlMWFoenUyZWVXN2o3Wm5hcUJSV1ovNkNJ?=
 =?utf-8?B?Umh1RTFuYlQ5anArNDFENyt1Znk1TWRoSjVnZjVuWGtFL1I0cy9yOUljSEx2?=
 =?utf-8?B?Y3RxRkJ6SExBVXlBQWZ1TE5Pdk9sUzRROFprSWhIMDNqKy9leHk5U3MxeW5P?=
 =?utf-8?B?c3JFUFA4RFkvMldYTmt6dS9sT1IyUEhEQ2Erb01OK3JkeUs5QXBkTVA3RUtL?=
 =?utf-8?B?aFkzK2JLS1A3MkpzNnNKY1g4MjdlUVZNZzM4OWZpOTZNMzVZU2E1ZnNUM3RH?=
 =?utf-8?Q?oELsQc7bK4IEiUxU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qPHtIJmRD5f/XN3guscHwXwYxVwN3Lel3NAbVbgdv/tPwpCYyXealOhTvl4ni7KkyGGf2h+d+eS00lMRu1Ia4auld5rO4k/CTkoSdUtsS5iw8nGLx2ZmFLJtTzVqIAAAWKkUqW/gMx2AG4FqMlyH9RRCG5oMS98wiColW6b1R/uNNI67itcOM+Aftq4RC/xf/bCyJsgDXc6iBlbZ4K2a/w9whXbT+cGVVaj+MceUGneoo6MHX8sw71ogv3fIv6jBLCTB07JGSFOU6Wwd4FL/je2miP67yjhGHmFpOY0yzYzP8HcCASvg4j2dy11pdogHrFARKo/g0Edc/WqlmP+2jWoC7cxrPHHBRtC4O2H0RvjSYeuCwwoYnsX9lyQzDOMpXWes6dxqKeiGuHSKqhdv1s2lvf0qEfx1fgVM4j/vWWoyuyh0hKaLDXaGFTHFomewE35nwx2bKUI1QlujmeqrHoD567uc57noPpJuO4NtVoXkrymXXze3n/9vJ3V0ZaUeLTppSCxxsoUmXOsgnHF5s9q1nEHOlG7v4PG2QEoVNkYOqv7tFpoPp7G795I0eDvzIdZEOpkAsxnROcxTfOPxEWX5yFoZ3fDwz2PkV7TKKPU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a219a0f5-5f11-4871-6f14-08de5d7ca3e7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB8215.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 08:18:24.1754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p77qVhIfSFGJJ4N4k79E1qIpcPMWsVa5F95zUS6gxkssN4Q3QC3omtdtxVjZknrZGZJ70FS4orc9hFaODPiJRBNCSwGmOrnqdKACdNjpFh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7951
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-27_01,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601270067
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDA2NiBTYWx0ZWRfXxrH+hfCYGYmo
 Vo7xgrAbi5SNbFWuGOMleeKD9tran0utkxYXI/Tt+0r5YCz1ZEvjZOyRKOcbSaG67ETJg2fJ2qX
 yZIFz6ukGH1J88F0DYtHbBaCpPZV5ZEaPC8i3WDGvU/9QBVx5nQ+GppTl3OeA5vuwtMsoyU9Kg8
 QdA3K3GhWjmkjDkv/tF4vXeKHjl0kohbVEufB0nSWLvbENYib70AJ1DZDV3PLaBxBsiSNAAIzG5
 vffLNbREKeaepMQN2FT5zHE5GBAF01rzN0BUiegJqajKFqtEeh0vCuXDKiSULxZ0n35ORJ5eg9/
 F0xb5dxhz3xczi3+9uV4oEYPkr0eGDDQDswWEvaFvG9DXvU3zAPowDLrcrg2bK8BD0BjLXLLaBJ
 AxJ6HUE5r+9ko0n+IVEon5xp6biGZK2JHElF8kIuiTU98H6sGuwLdGsadqLMmzNu/EJH9V/KQda
 7XclFit5cpLLQjb/cA4URJQ5IRrEzlYyqDR/JEcI=
X-Authority-Analysis: v=2.4 cv=C+XkCAP+ c=1 sm=1 tr=0 ts=697874d5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=i3X5FwGiAAAA:8 a=NEAV23lmAAAA:8
 a=Nhz_2EOhUgunInCj75kA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf awl=host:13644
X-Proofpoint-GUID: VZVt-N_KvPs19XeOyUJcI7pC6SUVO4MB
X-Proofpoint-ORIG-GUID: VZVt-N_KvPs19XeOyUJcI7pC6SUVO4MB
X-Rspam-User: 
X-Rspamd-Queue-Id: B6891100003
X-Rspamd-Server: rspam07
X-Stat-Signature: t8hcx48ckraytfw1b8mij4o5kw567yqj
X-HE-Tag: 1769501918-556546
X-HE-Meta: U2FsdGVkX1/1+/9rgDsuG2fM9/h48d0PQH7sjVnhsZrHgBcnUcOoqh9kxk788JtY3eC5LjVnoioPJ9Bj4AO5zagWaDsac+qW0ADWb7sUlfYvFDTewXj7sZg/CiIdzSMyjJEoeoL70BXx30dxSRDQGN4di/QsNbjf4WI8WxG9s2eAfXg6CrAIs+9ITuWRI4R69RIH3E+LgcrZEQHIDTIb1JL+mYbFJoYjrqqsKhL0Lc+G80CUYt8fITVULnZdlrU/n5pnTtE/asMQnr+6jTQy2g6WggDK3bY1p3YNhQTYkL/do9ThCnpqz3lC4Lsh/6t7OCEN/9ipSlGNoHB738GvQTl+G/mIlhOUxDWx7WSBI5KSS5+3IU5ZKjK3KWTaXiTc8zEvlxz55MYpVfXCiL/OjXU9y6LvmEiFDN4bKJ87SUaqeQMl1la0nR27IF9AKZsg+PFJKVSrH5zfUk9JO472KfViSTHCI89AjSu/OpGtwxTAElkc9cmzURn+K1wX5IL7zza04MhHbIm9N6M85v5nRncxKDXo+qSwsar0XgzgMoADrZbBaq/GolNqBs6LFAqj/I/3gCZYmatEKTQaMEk/gKHeZswA7klGCkBMRG6uOpUr+IAPZAE4Cl8e4YAP8TS7HpUJ05/BMv+P4bxUp7I6uTB6h2uJh4QBge79ylfE8CUceGzyYyypyNpkHIHbd4EmiFhz4fJnO61BXt+jMj4LqaGY9WNcs2ldz5fgD+YhinSZFBBL+rgU74oYDJ7pBvOT2+c4nSFzNaMVfTyjCPuUIbx2f0h+2YtKeXX4UNuQ38HQnA5zPuq019KuphmWg8JXfjhQ6Xuywl5q3S+u2Lirdty6Po503oiGft/LhPVneOIKLJSHT+8BP9mp4o/lOL/WOhaSWvnSoKj8hFHekN94HXieS0pFPRsoJMmgP/WiQhUVfJ22fkyH+2LtcZ93IlPOwYrvTcxr7FvkxVVWSKj
 pAf4YYNH
 /P6/faDSOrfppGf/VAZvEXgrtCHjF+11vngybs8BaMsPpr7pXh+ZVIQQphNzBWVrB/z3+t0nkHBMox9NdpNe8vuOS8L+AbA6JhF0V0WkocHPEVNmseDRY415FYI/RCRUPYCHovYhbnqkUFECMi/QkAG6bEWVn40g1JUBQM6MBhMAP4J3SJL69yZVFzfbtxaEiybRobf618FzuHevhRjL80UbWyHeNN4PiflqCfNegRi//7e3fUm6bS8MwB1n28efKX+3sBYB3dYavUhKAXQ6nCODPEl2Kn2twj3cAbrTCZKPMM5AKnUnl+WcocWUK4iI4bwRXv+zhJDe01YfamFAckgLBsNi+ZgNRlCYKbmeiLvEGkz5HaeQzyUr56/EId58et1IuLgm68h1vB584wI3Ecwr+rthEFdKO8z4sM3QqO1hGYsmWOtAYpAwugf2OI4GaY8/cWCd9n/s68UDOpWfPWEvvOlW2wjbgkDnr1bZn4rZIvc/QE2Vco0W8suxKcPBvzC5NDVWa7dP0fakGiaPvU/7JKZWmUalNgY5gjBeIgszgYpBmt76WYGS6gfooOHFYtKopOZISSn4JJk6a0x3JUE18RE8lYwjOLQ0JfTfvc84L710tfAimzg2V/9GVE+CxK7N/4yk2y/1DhEMx9sG7/NC1vf67TiesX9yJMHSAHxxhHNlyyln4Zn9tIYr0WLYDEzdZYCrYn07/dJ709ckVJdGIriwpZPKjMtZ895BSnp4eQRDGJ5IOhbSeOw+GHfUCrFghzbCKRfPZWvy4qZUFzBFY6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 02:13:11PM +0800, kernel test robot wrote:
>
>
> Hello,
>
> kernel test robot noticed "ktools.vma.make.fail" on:

Thanks to whoever set this up :) so far VMA userland tests have not been
exercised very much and I've had to find issues manually :)

>
> commit: 28d7ff99300f3a897eb6419efafdbcf96978f637 ("tools/testing/vma: separate out vma_internal.h into logical headers")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

Hm this is strange, this works perfectly fine locally at this commit.

But it does seem this is duplicated so will fix-patch at this point in the series.

I notice the build is broken however at tip on next (will bisect), I guess the
bot hasn't got there yet? Seems somebody added a compiler directive that is not
stubbed out yet.

I might simply fix by adding to this commit as a stub to avoid hassle with
chasing down the offending patch...

Cheers, Lorenzo

>
> in testcase: ktools
> version:
> with following parameters:
>
> 	test: vma
>
>
>
> config: x86_64-rhel-9.4-func
> compiler: gcc-14
> test machine: 36 threads 1 sockets Intel(R) Core(TM) i9-9980XE CPU @ 3.00GHz (Skylake) with 32G memory
>
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>
>
>
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202601271308.b8d3fcb6-lkp@intel.com
>
>
> KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-9.4-func-28d7ff99300f3a897eb6419efafdbcf96978f637
>
> Generating generated/map-shift.h
> Generating generated/bit-length.h
> cp ../shared/autoconf.h generated/autoconf.h
> cc -c -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined  ../shared/xarray-shared.c -o xarray-shared.o
> sed -e 's/^static //' -e 's/__always_inline //' -e 's/inline //' < ../../../lib/radix-tree.c > radix-tree.c
> cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o radix-tree.o radix-tree.c
> sed -e 's/^static //' -e 's/__always_inline //' -e 's/inline //' < ../../../lib/idr.c > idr.c
> cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o idr.o idr.c
> cc -c -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined  ../shared/linux.c -o linux.o
> cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o slab.o ../../lib/slab.c
> cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o find_bit.o ../../lib/find_bit.c
> cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o bitmap.o ../../lib/bitmap.c
> cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o hweight.o ../../lib/hweight.c
> cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o vsprintf.o ../../lib/vsprintf.c
> cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o main.o main.c
> In file included from shared.h:12,
>                  from main.c:3:
> ../../../mm/vma.h:158:8: error: redefinition of ‘struct unmap_desc’
>   158 | struct unmap_desc {
>       |        ^~~~~~~~~~
> In file included from vma_internal.h:55,
>                  from shared.h:11:
> include/dup.h:1331:8: note: originally defined here
>  1331 | struct unmap_desc {
>       |        ^~~~~~~~~~
> In file included from main.c:10:
> ../../../mm/vma.c: In function ‘unmap_region’:
> ../../../mm/vma.c:485:26: error: passing argument 2 of ‘unmap_vmas’ from incompatible pointer type [-Wincompatible-pointer-types]
>   485 |         unmap_vmas(&tlb, unmap);
>       |                          ^~~~~
>       |                          |
>       |                          struct unmap_desc *
> In file included from vma_internal.h:54:
> include/stubs.h:391:74: note: expected ‘struct unmap_desc *’ but argument is of type ‘struct unmap_desc *’

>   391 | static inline void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
>       |                                                       ~~~~~~~~~~~~~~~~~~~^~~~~
> ../../../mm/vma.c:487:29: error: passing argument 2 of ‘free_pgtables’ from incompatible pointer type [-Wincompatible-pointer-types]
>   487 |         free_pgtables(&tlb, unmap);
>       |                             ^~~~~
>       |                             |
>       |                             struct unmap_desc *
> include/stubs.h:395:77: note: expected ‘struct unmap_desc *’ but argument is of type ‘struct unmap_desc *’
>   395 | static inline void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *unmap)
>       |                                                          ~~~~~~~~~~~~~~~~~~~^~~~~
> make: *** [<builtin>: main.o] Error 1
> make vma failed
>
>
>
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260127/202601271308.b8d3fcb6-lkp@intel.com
>
>
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>

