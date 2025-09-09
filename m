Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23EB5CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 00:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F15D8E0001; Mon,  8 Sep 2025 20:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9116B000E; Mon,  8 Sep 2025 20:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690AE8E0001; Mon,  8 Sep 2025 20:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 55A066B0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:21:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03CC81DDAC2
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:21:28 +0000 (UTC)
X-FDA: 83867807898.20.6B39D73
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 700ED1C0004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:21:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CLGAs57F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aboYzmdm;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757377285; a=rsa-sha256;
	cv=pass;
	b=DGQpCd+kAwIK8H6xINpRJ3SD49xmU+ayo2nfjTEi1s69bw9j+tWtXOxJj049fPMrcNt2x3
	2Xt8qVExmAsWJS/M4He+ly7Kb8+ikbCvoIzp3BvxKDfaJQ6raWi3b+KqNJzOfnJfwdby5B
	BRGQqXgXT8veIp3M7hdVBZWPovXF1EE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CLGAs57F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aboYzmdm;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757377285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6izGVLP3iFnVuWzc6kIgm/xmXx0o1ruu8V0KP1EZY8=;
	b=zX6sQBCicL9xwKYo5VMCXzMhnDPq76R02XPmQnozPE/pfSDsnge6rp/r7iYmQ26KuMnRmt
	UR0hqxd1gH1UKPYX9pdIvSyn9rnP+sPUMJHbFJ4RGryuzcK89ax4Sub8F2JnQwA06pgRaH
	S8d6svGrfnrtEbZIzW+h24Ytw2WoXhQ=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588LC9QW014045;
	Tue, 9 Sep 2025 00:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=n6izGVLP3iFnVuWzc6kIgm/xmXx0o1ruu8V0KP1EZY8=; b=
	CLGAs57FcXsQhEFcYJuwIhq1BrwTmttPsK0b9VElc+HuYUft6J95kI6MP2siYW+r
	0JYyUYCtCBQyVjNUBdFD3ymgoythtexrG2kkSFStfMCyjFebr/AtECuZDS544mrp
	C471xT6+tyu9Qlf5DXFPPfEqoilcflcor0b0tVQrJFS+gwOgqH2iaPW9BUDrcEVD
	DaClXDtvsjpo8+kG6gDxta7qBkB/qjjDYhG8YfmqMYgGCFQo+3MYqBWMDyt+XZ/V
	GRt0lD2RyoVBSy8o2UlYtejeSdOqJOYL79g7s1XzSnZd0PAnuQrWQdx8cbmHHcf0
	gpG5qTasRO5NG27fY9fakg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921pe8uat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 00:21:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588NX4Nl038955;
	Tue, 9 Sep 2025 00:21:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd8vutu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 00:21:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MgibzXIc/0/8JdrRczf9SNXoBxXcB/8OONvPIO5tfoMjKxMD+CJgLleziOb1u8tuAF7jQxxbVRBwNyHoF8+i1gigZAhxJz+mG1wzRaecj+EUgcl+AdGKapIS03yXz+HtmJb6Q1tfy7LBu4JJtpbhE/UcLXD2xmoD3QOC+Gj/UCXhIwV8MnaduurqpJWoSLfbPo/5EsaqnZ87xaFOspKbV5dOs+0CpvVk98jGtAaCufJyyxNdvJRhc0HI7fH09DFdbq74dZkReWwCFddqrnI6X9ZryU81QcyGUQ/7WK7DIWBT95X7uaF3X1RR5Vc/1c6IdlvCKEpH8HaWwptsF/p0Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6izGVLP3iFnVuWzc6kIgm/xmXx0o1ruu8V0KP1EZY8=;
 b=M+xYryZB6nJ+rLN3BAC7XU+AhYVGWCcWMe0Zm1SxrZv9PbTJ+QhZV+b2fleEXbdn3IjT6YRlq9UKtnWx1HYa02jMaWSxwRl3OJcRrYWjEMfYPV2hfgk2EEIFTfcbDAckn9aHpz8/C3mQoSnfjKFQLcRCuQS/23++0I9v97M4Li4iV/y4ytLHtbDjPBoZ+f1iFhHfZ2oZ/chfJmoCCXmlE13y+l5D5sUvG3N68Xn0mQNHb9kOXM9I2Z6COjsT9Ifs+32karEBVi3FBiIXt5XlFN/ywOFTfC7MiNpp/4yIg+fdgQW7gxdChQze5TA3I0IdBi/+4W1uH4JX7d0MzheOrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6izGVLP3iFnVuWzc6kIgm/xmXx0o1ruu8V0KP1EZY8=;
 b=aboYzmdmQ0j5IaC5qxFAmImlRfXe70zW0ndhtq9pIAJUJPETylVEhsxNcFuluQIuv0kwmsgb97TdbPqNvW9x/8IV/DstQE6i3XT6z516LYmmUT7EC+qml7/5s8NRM8tNXcv9JiICzRV/ua4YHNr3m+U77xjYFlvojA2AAlzQbL4=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 BLAPR10MB5203.namprd10.prod.outlook.com (2603:10b6:208:30d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 00:21:08 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 00:21:08 +0000
Message-ID: <bef19610-5f0a-4cb4-af8c-042301262054@oracle.com>
Date: Mon, 8 Sep 2025 17:21:05 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/9] mm: page_alloc: add alloc_contig_frozen_pages()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Muchun Song <muchun.song@linux.dev>
Cc: sidhartha.kumar@oracle.com, Zi Yan <ziy@nvidia.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-7-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20250902124820.3081488-7-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0181.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::6) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|BLAPR10MB5203:EE_
X-MS-Office365-Filtering-Correlation-Id: 127118a5-8f67-4d42-6b34-08ddef36c5ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0tnRXFjZjJ5eXg4QnVNS0xZVldtMXA2UEdEUDljYzJZVjZQVkJWOXNLOUtq?=
 =?utf-8?B?UTBsY09Yd1dpbFlzdzVKeGFEN25YendVNVBnYWE1Z2hWKzM2NDFhVFJBVDc3?=
 =?utf-8?B?TVBMaTVQb2dlSmMya0hVakZYOFpOZ0U5c2M5N2JHek0vTjlvcm1DNHdiNFo1?=
 =?utf-8?B?b003UWhpR2dTWURORkZtbGxzalA0QnEvV3lOYWlSSjRtWFRMSFpjR0pONzRs?=
 =?utf-8?B?dmtWN3dzUXpSYkNITks4c0grbVhlQmFsMGJkcHFXOTVaaEE5NkZnQ05DU1BZ?=
 =?utf-8?B?SWhoZ3BoaW1HTDY1NzVkK0VLMFp1aXcrNHUraUx3SWNCQ0lneW9IOXB1aGtm?=
 =?utf-8?B?Qk1NdUZrVHZwejd4QksxUFVNODVScUZIWlRvcWJoTmZBUmQrU01nQkoyTUVq?=
 =?utf-8?B?TlEvQXFWZ2RpL25DYTY2dktlTnY3bHFzbGtCenlpU0RzK2ZNQytuN2g0emlI?=
 =?utf-8?B?VTJBenV2blkwU2Y1cUZ3MDV6aDN4by9pNW5OVjZPQXRTeHdCRjhGcHlCNGxh?=
 =?utf-8?B?TDNMd2tYSHlhanFiRXhjN09sdXo2NzgxcnNrVWRpWk5XTUlNLzMvejVKUk9P?=
 =?utf-8?B?QlZjS1hxOEttWTQ1TEloOEE3UlFrYzYzOWhQSzIrZHdjVFhkZEF6ZTdxRGs0?=
 =?utf-8?B?R21hOGJFZ3dZU1FLUEFGeGp3YjVYcVhCT0F4MFNyU2h1YkpEdk1INmtWeStq?=
 =?utf-8?B?elhqaENoblBUaFBOaVU4QXFUaUY0OExmcVJmQnV2cFZBYjRYUG9LbjBJM0xC?=
 =?utf-8?B?QVRldHp5M3pXeTZUR3ZEZ1A2b3dLK05LeVhNV3daM2tqVU1iNEs5Ums2QkxX?=
 =?utf-8?B?V2ZSRVZxaEtrT1IrekljZVFKaGE4dVhZNVo0RTZVZWFDYWlCbndZVHhSUnR5?=
 =?utf-8?B?UE42WjVKNjgzUElRWWdrWUlUL1F0M29IdjdMUzlZdUZkUTB2Skdrd0R0Sk03?=
 =?utf-8?B?TDA3QjZoeE5BU20xdUZXbkdYOUV4L285ZHlwU3FpTTFvdEJlR0gxSW9kOGh1?=
 =?utf-8?B?S1FoYVJwMFZqdjRXMnVoODMvL01pUUxadlIxeXJ4T3JEazRUWFJKZGFrL1I5?=
 =?utf-8?B?OHEyaDIrdjIxYUJ5SHh5eDI1Qm9zOE1idlIyS1JvbktSanc3UVVYTXBsVXpn?=
 =?utf-8?B?emdwejRvblBVUW5DNlRocE5rWXBXNm1yQzJocUNVZ1hSZWtMY0pPVHhxWDJC?=
 =?utf-8?B?NlU0SXI0a3BpME9XcUlTUnVjcDVqRVBuZVZvV0FjWldzMUpLUm5LVHhyMWE0?=
 =?utf-8?B?WkVkV24xQlg4WWhRUmdzUG1VMjI3Yk1pdnpaUXhBOEcyZWcxZktQd2h1MWg4?=
 =?utf-8?B?Q1AyNE1neHdGOVdGTXhLbCtvRlhnL1NDYjZnNU9sS3NIeGxLU0luOHowQVM4?=
 =?utf-8?B?NHhqMmRvbFVWbTh4NjZJUm9kclBSbnZ2K3dBdkcwQS91Y1JhK0Q4a3VlQ1Fr?=
 =?utf-8?B?dklZS25sTDBPSHRhdUpMNWxTQlpzanZ5cUxoakpSYnpGdU1OOVVRQ0J3V3Fm?=
 =?utf-8?B?ZXA5RXVQc2k3MFVBRGZvT2NBSldZV3FDR0R3UlUzWVNma0JKM3Y2R0JPMkpL?=
 =?utf-8?B?ejVyTjU2Z3pEQzhCemZRVEJUT1JQUEFJWkF0TFB5UXE4M04wVURvTFkrR1dm?=
 =?utf-8?B?NEs0SW1SUnBpMDdhd0VseWREMCszNjFzZmtuL2lFODUrWXcyUHZGMm1Jc0ZH?=
 =?utf-8?B?NzVPelRMQWVDTEJtM2planAyWVY2cGZaMTFkWS9TMnZKblBlYjYxeTc2cXpI?=
 =?utf-8?B?YjVrdkpIR1VGcGpuWUFyZVQ1OEtCOXVvVkh0em9rRHppb1dob3EyT1laeStN?=
 =?utf-8?B?NGxRQ1hYNnhtSFBWT1ZxNmVJdDJMdmhJa3lnL1VsTnlsaHh1bGwrSCtpeXBJ?=
 =?utf-8?B?QVo0OGtrNGpPQWVGRkgvQ2NZNlNIMnBmam85QUY1YjhVNFZOclY1SVpnMFVm?=
 =?utf-8?Q?1uuqSYArWpc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEtKcWFpaVJLTEN3bEVVSkgrTFAzamw4RkR6UzVNNUU1T1c1NmxybGFKa29U?=
 =?utf-8?B?U0M1UVAxVnBOcGdtTGJJTndITHZ6bVZHcWFFQnNZOHp0ZVljbkVWVjFlanV1?=
 =?utf-8?B?R1pzL0VMbW1BSXpDYmxnRzVSWGEybjdudGF5L3ZxQ1c5MTNTM1NDR2I5cUhB?=
 =?utf-8?B?WEE4cjVydmdEaTdObkE0SDcxQTlqTEI2OHdCdzNGRHA2bVYyL1dZdGNNU1pz?=
 =?utf-8?B?MERBU1d6djV4K0lhb2RtUW9GakJON21MVDd0MWRhN0EvMTVlc2JRVlNtVWMx?=
 =?utf-8?B?d3JHQ2VXQzBKYW4vbzI5TTlwbGxCejJLZVh2R0J6S3dYVHgveWs0a0F2Kzk1?=
 =?utf-8?B?VUgzMTNYQXp2eG9hRUw0K0JhRStwMmY5eG1BUVNCTEZvVG1nczBTaHVSWEk5?=
 =?utf-8?B?a3d1TytGOVRHaVdwMmpISHhEYm0wK1VCM3lGOXhScHRFUlpHeXIvbzFkY0o2?=
 =?utf-8?B?bEtwK29uYXV3ZytyUk1LY3VST1A3OTV1bnd2K1BxbkF1QVEzUkVseUFsbE1C?=
 =?utf-8?B?SjlnUTlnWlluYzFyNXlWVmRBMVBDRnZuVTBoOTBaNmxEaW9rTkI3UlJUMnkw?=
 =?utf-8?B?dDVjakFaYlZFdkQ1eVRWb0trSnhQdTg4MUpSbHJocGt3QUtxTmhnOEtVNW9M?=
 =?utf-8?B?NE9yYlNOMmhTTGdzeDRBclZHVlFiUTY2dzlQOWZBdWV1YXZyTmkwMUpyUTdP?=
 =?utf-8?B?R0VkMURWTGhhL21NUWRwVmhNeURhY0pROTJnbGxpZzE0TEdhU2tQZmVGeTBK?=
 =?utf-8?B?OEp2Mll2TC9DYk9YOE80YjJkdTZVeEZ4ZG5TWHQ5d3JSNDRVSTM0dzdOUWgv?=
 =?utf-8?B?MUhvRXZqajNWNmxjOTRHNjlLYUZmVzJjVE5SMDJxRFJmSzdzbU92bGxPRCtH?=
 =?utf-8?B?YmpaWjZ1UDRsREtvTCs1MjV3cGRKeHNmc0EzQkxyQjNOOXpkSHAzUXFscjFh?=
 =?utf-8?B?N0FCOUhwVS92QUpqcEJHbmowOGR2c3U5SXo2U01SM3dreUJDZkdwMWwreTl4?=
 =?utf-8?B?a1l3cXdKaFJyb3MvdXp1ZmpNY2Z5aWY2OTBFTGY5SGp4aExOS28zVDQ5ZVNq?=
 =?utf-8?B?V3gvNVVGKzZIL1NKWXVrNXU3WnFOU05pVW1NNUlBSHk3cXpSWHliSjJwMDY0?=
 =?utf-8?B?WGNnNktrZG1TU0MvRE1GNVZYQWJlOWpiU0dEL3NtNkxOVGwrYUwwMVZPZWRm?=
 =?utf-8?B?YkQ0QlNPVGw4amNGSy9XVEMrQXU4SURxeFQrVHUyamowbEtsdjk3U1JDYXRJ?=
 =?utf-8?B?SVhVdnFZSlVTaTlXVXpzN282blMwZ3dkQk4xYldFS0VMTktYVTkxNlRvV2tL?=
 =?utf-8?B?SlFpY1VTczNvWGlWTm1WMmdUcnlrSnpBak5JU3pmNHZLWi9ESUsxRlJFOHNB?=
 =?utf-8?B?dTJjb0JZbTNmaGFIVVo3U3dReGp2angxOUVtLzl2RnBWUDlwSWd4citIcytn?=
 =?utf-8?B?RWdlK2l3clc1VFVtbGMxOHBwZEx0dTMxMlVKYjJlNWRIQ3djMmtuTng0MlZI?=
 =?utf-8?B?eVoyTndPUDhIYjNESThQUkNIT3BHRUZ0eHpjSG5Jd0IxWndCMHQxQWVoRExo?=
 =?utf-8?B?RnZMcG9NR25uUUFIV2FiZ3VKVEhYOTlLVVdCVnlnblhFN1JLUTZQZEFEWGky?=
 =?utf-8?B?aW9tSWYvS0NJN2RUS01nSlRSRXkwdThJRHdoVnlnRURuTEprbEtVeHhvRWdN?=
 =?utf-8?B?S0RQR0pwSlJXVy8rOGRLWlZUSTNyWnNScUh2cW84T1JDWmJUd3l1di9WQXRz?=
 =?utf-8?B?c2dBL095Wm53dUlkdTNXVk5YQXM0Ulh2azA1QldXSVFhRnIwempLSExVa1Yz?=
 =?utf-8?B?VC90cDM1WDVhWk1rUk5UV2VRVk5Wb0MxYnhsN0R4bmNUYkExdCtkLzcxY0E0?=
 =?utf-8?B?amhtSVh3bzkrRGljaVNQYVpBZFIveS9wT0cvVnhveTJlVUZhMXlBSkljVUpP?=
 =?utf-8?B?OFlDWmhSYmdiY3dvZ0N2THBQR1BuN2NtUVJQNklVL0xwK1V5ZFdKRTNWcldp?=
 =?utf-8?B?MW9oSGFxSCt3dlRsT0l0RXZNTkwzMEhBVXBoMUt0NlFMcjQ5dzZxS2UxeVB5?=
 =?utf-8?B?REEyRUdzc3R2QlRVdmhkcERJSlh2eWozMmMvTThUQVE0REx1K3Y1OTZhUjVv?=
 =?utf-8?Q?LQZnac0no2OT8RQoaYxkuVFSS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YJiZElT8Oh8y5cpnAZEw+Agz11Mi3/nXUaKGp8QEd6f9cEthdrmLxUE4Drh5UzbPohwha8JAJomZ5rpPI1+/GEfQcc5HnbidVm7DZohyCed4YIw/aEPzhz/gqLJrZSnhncY7dpavJ2/Bhd+qpVLQXP5ZTp1+oaLXSKWVFyQE6Y/TD/6oBnENsSuhJ18lVopSCwHQvQQIbpmYOH8rCU/ruh1lt3Q7Obcx+CU1JyHC/fmgwFQd63VDKJ2IprF0cQFsqVPw2aEB0NsWiTxrljKpvXhQQ7XbWTepvbJbeuzELwdjWNJIm47zXK6KbryfPpfobUqzXFg2ZxrX00YlOSeFwLLXZ6Ija1ZXWGCnyS+p9kylfgKmyfUspTbQr3sB2XaGAPcSG8i1xie6tHwt1dRgaoZiOnXo0KePwuupFGavJWCqaYiNmTvbsuTZaqvjt28S0PB94uB4C8IZZIvmy8sIi3wWlqO8+BpE0UwUoA5FhcLYujy4WRTOpFrnaZTJ2dDdZHXMRpCZz8Q9ceEhz6Ffvfeb6rjcRO1Ito8EcKo5zAv5A83Z0lxoGl8y3d/LEXgxdKgE8P5LWJYFoLEMtAg3BaxC7j51W14YB00B4F5Vft8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 127118a5-8f67-4d42-6b34-08ddef36c5ee
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 00:21:08.6359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FVfl5wlTokquqnkKB53ZvxTFZNWoBZmi+a7lkC5eTQQgLeOX0v2dZ2fWYAQYIuHRCmT46ayPRl4reTp42j2GJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5203
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090001
X-Proofpoint-GUID: n_Xaf4haNsQGmrl7xe3fjekV-y2XwU5r
X-Proofpoint-ORIG-GUID: n_Xaf4haNsQGmrl7xe3fjekV-y2XwU5r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfX9+57JXcrim3s
 hMzc/oP1p8SL5+rlwYQIyX2OkGuQtF2rM29pSxnPKiFNhOOBmWfc57/+rKo5CpcAVkf7Km+jmZe
 XipL79OYpJ4bJURKWFO3E4hQf1nuq17M76VonuSXHnYnV/HIOqUUctSHayOVdGZjcK3QaFas+CX
 C1Ee22IiXN1crV6Ye47zZXfl8LImpCnleL9K0lGyVH7GgsATQV+9qnBTDAwTsrJWxZ4C8kEYik+
 HcYgfUqFTal5iHZwhLX6pX9MII0THsw+2H7Sjr1K6w7MYyD5S1oPXHiSd1SDb1Q93BIdcPqnjOR
 DfxzK2qdMMkv4mq0GaVnAO23c4kxcn9XCJDcBE3JcrAoojOckzdhoy437QJ7MCd7p5qYP5tmsux
 HUh166rbLdWMGZZjPOkA9PI3GqDkwQ==
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68bf72fc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=tBLqZ0BfAAAA:8
 a=pqf_Oxc35WSZHZxPxbAA:9 a=QEXdDO2ut3YA:10 a=bcxzA36k8LdFRrLh0hrl:22 cc=ntf
 awl=host:12083
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 700ED1C0004
X-Stat-Signature: 5xkhsyayd8dcf3raocgdja38e4dgyhm5
X-Rspam-User: 
X-HE-Tag: 1757377285-483524
X-HE-Meta: U2FsdGVkX19QapVqaSbqssGXDjV0GufVkZTIZrzraGXeu8arg93Rb1tA7IGmf1NpQoB0oe3PehgUoI8gYo8/7K0VEpJLXnB0kTfdh8NexISb1dPIYH08rcNvKFERX14f7dmPTRmDqJdYnlPNnkpsB0MT4iUS0aGhFg+YdkhVL+YgmVkkx3TRnUk2s2rnab/kvtKgcpgyc0xoiOKs3UEnSNarMgVTI96zLPKAgYtZ2y+EvNraf1jtdUBXXy6Vus5//5KQ95WDwt+iYTy/nPI666943CU1uQ+Cp7Fa5eijYOCz0Ydor+WycQC7CqDe76G7Ov0Ung0JLKAYNjRUYE8ayfuWZed/y58LUhbhpl2BylE5CFms0/y3pett4IOyggckZOu6xjuM/LFv7L3jJ79J831fA80YT+2aszeuLhwSHp9u3LF807P+95EXCJ65Aj0P+t2k5o/U5lfjCl5pQ7PA0VPsQJDffgDxw2RxUGy2wf/b2WVGMwF/uWQSglzk/RTyQ70A4c5H6KcRgl2LecDazcXhHjKHT/FkbsigCY+kvPaV20NtjFvxa888ohiq8kejw6tm1sK6NTj3zX3F/39nikUVpehFl3WuaWym5Lo+Xl9I3RKaSGL98t8FwqtnPgKGJnP8Yrr6pDZHsQ6wxTjEzz+fgSy6P4G6gxdu0PNS6n0UsPlmrMQt1goaNjhiNN7QgBU1yPB8uXEInFaOHPn/zl+vHkpMkGvgDe/Ml51U5UYQimd5U1/20nh4dlKMRsYibPWCdcQQmEloaHYRt90ZIzb4RoaDjzJmVeFFclA4cye8gLiKFUP0pBsDm3hrBSR08J2UDnB7rJd6pl68G14J3zK5jLg/EQPnwXI1LTvSU5gx8o5MPbVYNfFzhgr2Hgre12f8yn68h/1Q+tQUaViVghfLreCfWS957hCBF29HGkC+5mpRYlbZ3EboxUeuhdND1QPeH9Y1+eATymNyFBm
 KQiG0UkL
 XQG4ifvk93O9bd09KbuHE+ltMSz4ykoyxFP3UK/YOnwUYH3kLAARnmP/XXJI2ycB5uSNpzlGNQ4+O7MjhwRW1dgkXVhfIS/rkmcxTARxErvgdLcU7CCJYethsiRvvOfy811Pz34+oXACHPlp9PaOuwcSIqPS6a0TNJ0CQzHheAdu95sMnUD2M0bKSWjd30N2BuwOasb0yywdsqdSHLrVd74J5NLneRkREBxaaO6l+RZ7MiT6g7RNFQPilPClx+HqqIMK51RQHB1iha8L4EgpzoCmPKFD2JL2g/0pCL0KTSnb1olJpTWU18X+TFZp9HMgrsMqrgJgAyaLF9y7rdUj8VLx/77m2oXmryhbQ24gO7xtDXvJAsFsx0UnMxLp7FFJdEp/AeD/qyItgor+hVo7121XEHwy4NDB5vOy7QvQhMBsjtTvOsmcQIBx8ZKbhDxzoVpjP8AQL4fGf4Qq5F8qmMIiG94+ItsyP94LCtmBc5wbhhkClRtDHQnIzGlQ7t06cl5QGT7qpWoMRx/2unHJbYOhI+QSu/ZNN+wDvk3rUpuuPz9irYFBFUx5Nw7tXGyJk/sSjj4xYJ/z0zqFR1rOsUtNfOwGHUbzmV+2CiSJ7Tnrcg+jcJAscbQo38z7Jf7hvfDoxjOQzn0sGsbSxZHuayupILuo4EJyIRsLwGGMWv6ykX2AXy6PbnXtwkLNwKQKQ/OxlYRX0/v9pPahYbf2TKkwV4Q1qomqqwjfaRtJrWy02EiNZXKeRGiYWeGWbRTNasF+ztsOwf2YSx2C1UgY9btLr5FJHD4MJvN6n7KPDKycpojjvWeUt+EzbKg7ge2MLBYnNfSIbxgbq+qpBy3S15NSJJUIWJe1BDRJEn0ZAj/abdwD4pYuVarEERzmX5xWL7zlc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/2025 5:48 AM, Kefeng Wang wrote:
> Introduce a ACR_FLAGS_FROZEN flags to indicate that we want to
> allocate a frozen compound pages by alloc_contig_range(), also
> provide alloc_contig_frozen_pages() to allocate pages without
> incrementing their refcount, which may be beneficial to some
> users (eg hugetlb).
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   include/linux/gfp.h |  6 ++++
>   mm/page_alloc.c     | 85 +++++++++++++++++++++++++--------------------
>   2 files changed, 54 insertions(+), 37 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 5ebf26fcdcfa..d0047b85fe34 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -427,6 +427,7 @@ extern gfp_t vma_thp_gfp_mask(struct vm_area_struct *vma);
>   typedef unsigned int __bitwise acr_flags_t;
>   #define ACR_FLAGS_NONE ((__force acr_flags_t)0) // ordinary allocation request
>   #define ACR_FLAGS_CMA ((__force acr_flags_t)BIT(0)) // allocate for CMA
> +#define ACR_FLAGS_FROZEN ((__force acr_flags_t)BIT(1)) // allocate for frozen compound pages
>   
>   /* The below functions must be run on a range from a single zone. */
>   extern int alloc_contig_range_noprof(unsigned long start, unsigned long end,
> @@ -437,6 +438,11 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
>   					      int nid, nodemask_t *nodemask);
>   #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
>   
> +struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
> +		gfp_t gfp_mask, int nid, nodemask_t *nodemask);
> +#define alloc_contig_frozen_pages(...) \
> +	alloc_hooks(alloc_contig_frozen_pages_noprof(__VA_ARGS__))
> +
>   #endif
>   void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>   
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index baead29b3e67..0677c49fdff1 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6854,6 +6854,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>   	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
>   		return -EINVAL;
>   
> +	if ((alloc_flags & ACR_FLAGS_FROZEN) && !(gfp_mask & __GFP_COMP))
> +		return -EINVAL;
> +
>   	/*
>   	 * What we do here is we mark all pageblocks in range as
>   	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
> @@ -6951,7 +6954,8 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>   
>   		check_new_pages(head, order);
>   		prep_new_page(head, order, gfp_mask, 0);
> -		set_page_refcounted(head);
> +		if (!(alloc_flags & ACR_FLAGS_FROZEN))
> +			set_page_refcounted(head);
>   	} else {
>   		ret = -EINVAL;
>   		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
> @@ -6963,15 +6967,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>   }
>   EXPORT_SYMBOL(alloc_contig_range_noprof);
>   
> -static int __alloc_contig_pages(unsigned long start_pfn,
> -				unsigned long nr_pages, gfp_t gfp_mask)
> -{
> -	unsigned long end_pfn = start_pfn + nr_pages;
> -
> -	return alloc_contig_range_noprof(start_pfn, end_pfn, ACR_FLAGS_NONE,
> -					 gfp_mask);
> -}
> -
>   static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>   				   unsigned long nr_pages)
>   {
> @@ -7003,31 +6998,8 @@ static bool zone_spans_last_pfn(const struct zone *zone,
>   	return zone_spans_pfn(zone, last_pfn);
>   }
>   
> -/**
> - * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
> - * @nr_pages:	Number of contiguous pages to allocate
> - * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
> - *		action and reclaim modifiers are supported. Reclaim modifiers
> - *		control allocation behavior during compaction/migration/reclaim.
> - * @nid:	Target node
> - * @nodemask:	Mask for other possible nodes
> - *
> - * This routine is a wrapper around alloc_contig_range(). It scans over zones
> - * on an applicable zonelist to find a contiguous pfn range which can then be
> - * tried for allocation with alloc_contig_range(). This routine is intended
> - * for allocation requests which can not be fulfilled with the buddy allocator.
> - *
> - * The allocated memory is always aligned to a page boundary. If nr_pages is a
> - * power of two, then allocated range is also guaranteed to be aligned to same
> - * nr_pages (e.g. 1GB request would be aligned to 1GB).
> - *
> - * Allocated pages can be freed with free_contig_range() or by manually calling
> - * __free_page() on each allocated page.
> - *
> - * Return: pointer to contiguous pages on success, or NULL if not successful.
> - */
> -struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
> -				 int nid, nodemask_t *nodemask)
> +static struct page *__alloc_contig_pages(unsigned long nr_pages, gfp_t gfp_mask,
> +		acr_flags_t alloc_flags, int nid, nodemask_t *nodemask)
>   {
>   	unsigned long ret, pfn, flags;
>   	struct zonelist *zonelist;
> @@ -7050,8 +7022,8 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>   				 * and cause alloc_contig_range() to fail...
>   				 */
>   				spin_unlock_irqrestore(&zone->lock, flags);
> -				ret = __alloc_contig_pages(pfn, nr_pages,
> -							gfp_mask);
> +				ret = alloc_contig_range_noprof(pfn, pfn + nr_pages,
> +							alloc_flags, gfp_mask);
>   				if (!ret)
>   					return pfn_to_page(pfn);
>   				spin_lock_irqsave(&zone->lock, flags);
> @@ -7062,6 +7034,45 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>   	}
>   	return NULL;
>   }
> +
> +/**
> + * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
> + * @nr_pages:	Number of contiguous pages to allocate
> + * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
> + *		action and reclaim modifiers are supported. Reclaim modifiers
> + *		control allocation behavior during compaction/migration/reclaim.
> + * @nid:	Target node
> + * @nodemask:	Mask for other possible nodes
> + *
> + * This routine is a wrapper around alloc_contig_range(). It scans over zones
> + * on an applicable zonelist to find a contiguous pfn range which can then be
> + * tried for allocation with alloc_contig_range(). This routine is intended
> + * for allocation requests which can not be fulfilled with the buddy allocator.
> + *
> + * The allocated memory is always aligned to a page boundary. If nr_pages is a
> + * power of two, then allocated range is also guaranteed to be aligned to same
> + * nr_pages (e.g. 1GB request would be aligned to 1GB).
> + *
> + * Allocated pages can be freed with free_contig_range() or by manually calling
> + * __free_page() on each allocated page.
> + *
> + * Return: pointer to contiguous pages on success, or NULL if not successful.
> + */
> +struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
> +		int nid, nodemask_t *nodemask)
> +{
> +	return __alloc_contig_pages(nr_pages, gfp_mask, ACR_FLAGS_NONE,
> +				    nid, nodemask);
> +}
> +
> +struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
> +		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
> +{
> +	/* always allocate compound pages without refcount increased */
> +	return __alloc_contig_pages(nr_pages, gfp_mask | __GFP_COMP,
> +				    ACR_FLAGS_FROZEN, nid, nodemask);
> +}
> +
>   #endif /* CONFIG_CONTIG_ALLOC */
>   
>   void free_contig_range(unsigned long pfn, unsigned long nr_pages)

Looks good!  Thanks for your work, this makes the frozen page allocation 
explicitly stated.

Reviewed-by: Jane Chu <jane.chu@oralce.com>

-jane


