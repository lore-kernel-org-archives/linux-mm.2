Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18A46CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801466B008C; Thu, 15 Oct 2026 14:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1416B0092; Thu, 15 Oct 2026 14:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67A046B0095; Thu, 15 Oct 2026 14:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4A06B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:13:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9E601A0125
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:13:30 +0000 (UTC)
X-FDA: 85325658180.23.A1CDB06
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by imf28.hostedemail.com (Postfix) with ESMTP id CD3C2C0009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:13:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=drS4tK+9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NjQRMzjmWhwFyO/EkneVh0xWt8+hcaTn26d1Fi2mBg0=;
	b=O/wRr0rq5+rwEGIHEWa4W1AgICy7I2/7owdkTlv+7sOv9eQFZw0Bnp9hhAERjl0nD9RUr2
	FUHIuXraaUSXV17mtlGDtkWhvgH8g8+MFsG6jTZaxI0QucwGXjUzncM+Bucvw8TdFhjVrs
	kV8N/bIgR1NwC9/aGFDV5MP5XS3rn4Y=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=drS4tK+9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792088008;
	b=FnIj9Ok0Z8+mD5OtTWK7EF9GuSB8L7W03fVfJQ0B6cGm+4+vSMqfbiy206+q/paTY3/fu1
	DoEJ9Cy3w0UJa8e3eBg/iunZZU1fjAiRhPV+fOutnI6CkHF9vEGmRlcraGeIf4K9nLJ732
	JWoSJ0D0E502Pe1V6KSgcl07LRagGt8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SvkyZmt+L99PQrUG4jGW2fLc+MpbuTV1qNP94GA3XtCFXplpwDZMvfm9Y3LTQ1Lq+okf3ySdOyCecMmW145pKVUSGdJY7jcLAZVNh1kDO8191/u1/VxhL6yRUySAtprOwc/3aUh7KNShDs3p8im/5pSZUPXH0QplKInTCWMYs8+VyGaOW6T2itCxWkyHzEwusHJuvDeK6DtB3fZ8A+Vop0JudS6AKxt1BurCBDNVEAi7Y/+d18lFdOv9lwOY9k09KWVxDFhDBFpgonRtkCQps0FqnsBx9x9Sn3k+S/YEz9xYWSMRnS8iqU7tjCTj/SeOzLzalTjY9kvu0DNPIJKKCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjQRMzjmWhwFyO/EkneVh0xWt8+hcaTn26d1Fi2mBg0=;
 b=d0iocx6XYG2bzL/DVkYjqxDxv0tcLAxuA+P7nC0+39HNCH2h0NJIiGiKCfejTAJ2cAL68aMJcLE3KEvKnvYfG073gSEVpozmltUtyuJgWBkD9xMxdX11nP9z2xoQb+1+d0S/guLM9dyyHxw6VPmFEEcQs1uWa6xHAl+qOAzhDqW6w0BQhHtO5IOfWxzZUaNThiEq+dKET2iauhsi+SH6QC3tNrjCZhk9j14hOnOMKc9TEf8m4sFF3GX/QMlvBH5dTH/rfVcG1NFZtC4oOkZ/dPYlqx0LVdtbrmfzzGrjPQvREcvB6sbLnk8dxkA3Grt95PWEVlq8m+3PkTAslrSm1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjQRMzjmWhwFyO/EkneVh0xWt8+hcaTn26d1Fi2mBg0=;
 b=drS4tK+9p3m+gi8D9YHgQWdPPSralJyV4hZSarYYmOJFpHpyidHYZvHXglkI8+dRO+jsSTszf9xaGhvREny54zs4mG03Ln81OGo0NRSRh0eKKrHGtRYOfYAggPrm3CUME/Dk6eCJcBlt5jCBi68VYvGa86EK6KxcnrUJjQ8Ykexbbz6+xFEDHbPnKiH+OXXsEOYEqr/XNQhOoxf+Bx+47fBnxONEkc72dWG5c7eM32ILoZI5Jan5ul4nbe7XgfWm1qEg2jfAEQ5sK6jszE2Qea2n5bzxrnHJi2qPeTVd0U4ngbRZcrKCMpSBQjyszf5eVKnHZEUy5A170xpxHIuMZg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB9058.namprd12.prod.outlook.com (2603:10b6:8:c6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 18:13:14 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Thu, 15 Oct 2026
 18:13:13 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 15 Oct 2026 14:13:02 -0400
Subject: [PATCH for 7.4-rc2+ 2/7] riscv: mm: don't let GUP-fast follow
 invalidated THP PMDs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-anon_vma_uaf_fix-v1-2-7b977303b42b@nvidia.com>
References: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
In-Reply-To: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Kyle Zeng <kylebot@openai.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, linux-riscv@lists.infradead.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQBPR0101CA0101.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::34) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB9058:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d3ccb48-1394-452c-9e57-08df2ae7fa30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|921020|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	EyxtQlTXCxPQI0x7pBb5R3ujKfkedl3RDfsHOHGoGPFPeC4JVh+qeb//+q+6AxaTk5JK27tmbkvyKnZMTrG+qHzgvq47zCbrVIRTmLXYKnNAKIntW4+TG4kWjjC0l+GAW0Pc2/4S+QU5dnT568RioItUuUvSn/GJMqPilNiEWPez08/3Q5hZRp0z2oqUEMfDf2R+K7oNbTQvqqH/E94bs+ZTUuNN+z6jxlM+vejZ46xXWqzrDYPK0J+grf7KjBBKUF9GUj2P+HI3vXdJK9klXyDvX0vcP6I/6qrhPAvHd6b4h70hul3duA41AOcpmm+usCPq3AUb7LJt5JIHHXVBu3Cmo53nCfMNQNw5qbWarFKYepCbH4AttWHSnwWkVM76Alvky0knA7AbZlu5uvviet1mpJeF0qJXe9kNucRml77+iKOCOlVjb84EQ5QoUathLlP7yHmQz+fBIl4rYBkmNU2vR05MHZfKdYgA0loVigSq5woiE7nsL/WVnXS6kP7g4xEg+SPyAe/tPoGFp0lk2oCusJqKVR9EdwBoavh1/GH84n4r33q/tzVxnkzYGA9MTzhfogWbF/rck4ja8mI9QFO4gfeus+VlcljRxVCkyI/iYX+ErtoDLc8F1PAXaTVbc19pb16AaB/onXieVwbnNf8Fxc1+ckGWTFSzWUnwf2zbhbRKft5g2lQiNWiHomFPFHvqjUGUM/v5YKHogdsytQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(921020)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1JYdm42UzE5bFd0L2o3WTBnVlRHNjhZUEpLM2dTQlZyK1hOaGVudERzeVVv?=
 =?utf-8?B?ZjltRTh5ZnlIbUlRWTB1b202K3YreG9IVG9aQ01CcnBEbUU0emR6Tjcwamhu?=
 =?utf-8?B?L2t0SzlPTjl6Q0dZaXk0OXhqRE9ZdWtEeXRGeE5nS1BuSEMwaCtjSFBjLzZG?=
 =?utf-8?B?ZHMzNjdPTFZwbGtnWnpwQzRDMlVlZkhzL1V2TjBPanNoZTk4eE9ham9VOGwv?=
 =?utf-8?B?a3FFWDZrbVJ0S2c2Q3hXb0lUbTVab0NRK1NNdzZrTytHL01meVgwUkYwRjU1?=
 =?utf-8?B?UVlDOUNJcTZrQk5VdElTRGJRdEhVb0oxeDV4N2ZRR2pXUnp6Y3hEZDZVTmR6?=
 =?utf-8?B?c1diNENBOHFVbndvZHkzT0JudmlPOEYrMWNHOXFtMi9lcFc0SFZ3T0ZyZVMw?=
 =?utf-8?B?QmVRVWFBdHVmQno3SWFkbkh2clcvU0QrYzhXZEQ2dFg5UkFJQ2lTUmlMSjJt?=
 =?utf-8?B?Yk1mbC9NQnZDMmFhRXA5d3ZrNVpNekMzUDhwekNTNVFMT2lmUjBKdlVEVllM?=
 =?utf-8?B?VHlUQnlPem9pUWFMTUVtakFFaDJQR21vbEp4VnZxajFyVHlqNWlDMC9wcFI4?=
 =?utf-8?B?S21xN0l6bVR6MzlnenVhVThINWJXbUZqVVIrd1Z3dVk1ZXV3SzZid3daNDFV?=
 =?utf-8?B?Wnp1c3U2Nm1VejdXelpPUXB1MVJYK1VHZVpST2dqamNFQzg2UktnUmxscTF0?=
 =?utf-8?B?NDN3ZVhCKzVUc1h0WFhsMWg4K3N5S3dmS3llbVZtcFBBOHFKMXF4QkdLbi9u?=
 =?utf-8?B?YUViT2dtZEdIUE1uSzhDZC81NkFMVlE1SGY1ZTdKNkZQMVVkTlZMdkZ1TUlF?=
 =?utf-8?B?OTE1T1J5a0FDNStPbWs2ZlVZOW1RUXhEVzdIbHdhMHZreW9QaEY4Y2NSNHc0?=
 =?utf-8?B?ZWRDcWdjSWNEZjRWZTdpQzVzQVlzb1JWRW8xMHd0MGg3dm9ZZ1JkK2wxak1K?=
 =?utf-8?B?bnNOUzI3UkFKKzJtVFErVXcrSllEVnlCZnp1ZVVjVkRySGE3ZjFhdDExbWhG?=
 =?utf-8?B?L3R1QkJGSitTdGVGaEYwSVRTYU11RUVWNTR5NTBpL3QrbmFjTnBBTVRUQzJi?=
 =?utf-8?B?QkdEM2l1U0hGakRuWnRtM3ArWmRwMU5QYVRaM1YxcmFDNnZCdEtMbktjTk44?=
 =?utf-8?B?eUFiczh6Mm9tbUpoQUplWTE2OVFUSndiVk81NitBRE1tTi9YRTgzZXgyd0tz?=
 =?utf-8?B?Qlg5ODNMeE93STdyMVRqamJKYVMvbUlyY0JyRzNKNnUyWm1wbmVNblFvM1pE?=
 =?utf-8?B?ODMxdzRFYlowT25jZi80bjRLem1TMTdWOURCVnE3Vml4RENqZVhHbWsxclFN?=
 =?utf-8?B?Q3FFL0hEdGdiYVJ3ZkdLT2h5dkU3LzliRTlIa2F3VzFuYWppR2puaUllRFRv?=
 =?utf-8?B?WDB6Y0pMMGQ4ZHdWN3hQU3NxQWdKQ1A1dVcvTGFIc3ljRHNxMlQwZ0dHRDJp?=
 =?utf-8?B?YnMxbmt3WWZtYUpudG1wbkpqazFoVkxyR0hRb3J0bkdLR2VSR3k2bzRDS3hP?=
 =?utf-8?B?VlhMZmM5VkJkelNSRXk2ZEpJSE5xQjVocWQ2bDRTSU95QXpna21mSDR5d3JC?=
 =?utf-8?B?UHc4VFI4b0V6ditJRmFEaTUzNGpGYmxkUlF3cXJ5SDVtME1CS0xvRlBNYzNT?=
 =?utf-8?B?YmhHVm5kcXdJR056NTJ3WSs0MWo2YW1zb1lac0hObHBQNWNqVWdLMFhjV2RZ?=
 =?utf-8?B?VFM2azA2Q3dwK0NmWlVMVnZ3TEJqaXNCaVdzWUxLaTVMZEoxNlUxKzJQSCtB?=
 =?utf-8?B?TzVzWkpMRFZCNU5tMHZ4My9XNkN3c0Q4YnJCWWY4MDlZWkZQZTUwdUpmNmdY?=
 =?utf-8?B?VWVqTG5XZmwvc0E0dEl5TXFzeDZySmltTU1sMGZydVFXZzREcWxOVERGdjZE?=
 =?utf-8?B?SEZ2aGU3WldVemhRNG1vMDNPYWQwRGoxWVl5cnNZVkZCVVNjYjFGM0NWSWc3?=
 =?utf-8?B?djMxTVpuWTFXd3ZiT2MyL3ZaamVZY0VIVXh5OWFpUHFQQ201ZXdKVXVsQTla?=
 =?utf-8?B?UTl1TFFURTF5VFlSdHdtUEVxeDliNWpDMVZQMThxa1FoVGRvWkR1WnNrQVZl?=
 =?utf-8?B?V2hCK1BDc2wxMVRiQ2c4T2ZrNHdhRldaMTh0NW1Odkh6UlpEdEJxUlJpekd2?=
 =?utf-8?B?eWpqTXZLZm9zTjRVanlOaDNYVDlmazRmM0VwMXVtTTRXN2hSUVZWdTdrR1Fy?=
 =?utf-8?B?S3NkTHAydHU2SWJmRW1jVnd5dmF4NTQrb2FPS3lnK1JqZG1IY2dyNlNhbnpp?=
 =?utf-8?B?WVo2U1dsclR1Z2NyeDRRZS8rRDFGVkdDVDUwaU1QcDY3SFA4OU9YTkhoaE1j?=
 =?utf-8?Q?Pd6u0z9PNkEwyjP9La?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d3ccb48-1394-452c-9e57-08df2ae7fa30
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 18:13:13.4147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hpB20jfPFlr7SWLkuY4nhllwaeLxXuUtulVbiGMCTr5qTA+vm5uPvcvMagWh0gKd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9058
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CD3C2C0009
X-Rspam-User: 
X-Stat-Signature: q6m48zwrrnmd3n87dzsdszhp6qfegy7z
X-HE-Tag: 1792088007-912253
X-HE-Meta: U2FsdGVkX1/JpzMOQ6ER5l/INjy/19uwYJub9acyF4zKXO7tZwkFZl8ocL1n4KROBDaMquD0FmZwwVtwIzXd1iHvqzrC6yN1h92h7vLjFKmcw0yDOZ/QVGmJh+9kcKaFSUCr1bYyS7n5fplfWHpc6xxaR1XL5VGASxubFHDI7DLwjb7g8gz+QmDHRDEHoAuM3Ln20FTbhGLKmLT9mSbRsTbYjePwpNZItBJ8PksJrvZkru70Y7/pKw6SapFI25IVgJjCF+iX9HUNELPkbJwGMqbos8STbz65XsTQ5HcrL0E30B4L8bEVEuOn6rwEsZt5rVuh160LIjarQFTrJvhgwl4MvXN5Ivd4uCSjCT4mnrh6mDvsxLTSel1FwXHaG+RjHa0ZmX09cEKDMnqN9ktp/3asyA/gPc7YcCrNwJuN5GNmHdFgflpZK6uuNaLH55UC5N+t0qAq62dw5xPygEhoOCeo0ZlW/v7YHhWCpdHsMoVWGeemvxzaJ5blveeYt1gsdskcAnKDXBPAAixVdYAyoEWbhJIxD1GLIiWxeuGLrHscITRjxSHADyaeJv2t2RoxxS4cKfhd8CsioFT9Sg28D8ZNnJ7xf5lvOloSExgGI/X+ciTWCdGRjxzZoZLChFEVjxhyUIoh706/gaAkevi4YlP98jaEJILraCovOfKb5pp4ViGecEzN8uH40YgNbpNwkqLBt50zHlOXzJGU7b4jdIwF9ym7RNQaV4PNrGbS17HOCSSwBCnOXXWDl3Ycur3Ry9TarOgPqfPaixdMTLTCMJni6LA2p0mBk8nKlShSgom4nJ4LTZWcF9PgHy/uIVI9dB/UH2q5xUw4f5ISU9sbIdaD9QFE35uIzHJFATVQuxeN+J7yafdLrX4DWo0Yo6iMCkONbZwBSMWp3kwEdW6MjSapla9EhPifHz61rsNpT8NvTQDMYiSbgMZXyrBVksiskLPr4kWHj2w5XPOG+UU
 85OGGDuv
 tUp6zDEZlRL5WjRZWMV209sBDFkvAm1rOehADr46NN5eMTwT2jBwwuVawXS9cxGptTscpWsV7VCHXfWaW5VhXdna3mH2oKvBW+9dKQRQlKor43AeapHPSG9j7ek4Gl8rE4HNr1QnBqsrQTvJGsERV3OxzraYO7oE8TjsSJFLh9Hg28T/+lu4YlU6q2K42RXPoVEcla2dikWtHJbvTzvXy+83U7I5i1F6zqhaSPPO54kG0xQJTkaYlRF9/e4NgRfBMKZCNjR3vkUVfvBeQiVNiGD34Gx+66idMlyiUjvmNNMBCTo0x4eagLIi8VS5l2jlrM6J8aXBbTZdl7+/2HnV8XZc1uC7lUHrFeoLDhRI5lb72/lgsjbZivFvFgjUDj2VYAzxiH+4Nnw6GQ37dsuE3vNS6jXtjbcGIpp7m+loCu5U0A0M7Tm1qF6pHFjugiL5bkR73LPq5CNyKOkMkrla5lmzPioZYMfCIqHjGvijhzmfhaBB3tJFoloiTwACFExboWk8XgsOvcAwvPV1AMcFxDIKEKoPbN7XcWj4MkO/FUdubXNrBNfWN0FBOxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pmdp_invalidate() leaves a PMD whose pmd_present() is still true, so the
generic pmd_access_permitted() returns true for an invalidated PMD. Then
GUP-fast can grab a reference on the folio and, as the PMD value doesn't
change until the caller finishes, the recheck after taking the reference
passes too.

Code that invalidates a PMD and then decides, from the folio refcount,
whether it may drop the mapping relies on GUP-fast backing off from an
invalidated PMD, like it does from a cleared one. x86, arm64 and powerpc
already reject invalidated PMDs in pmd_access_permitted().

Provide a riscv pmd_access_permitted() that requires _PAGE_PRESENT, so
invalidated (and PROT_NONE) PMDs are not followed by GUP-fast.

Assisted-by: LLM
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Paul Walmsley <pjw@kernel.org>
To: Palmer Dabbelt <palmer@dabbelt.com>
To: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: linux-riscv@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/riscv/include/asm/pgtable.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index d48f90140841e..66aac56631f0c 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -816,6 +816,12 @@ static inline int pmd_write(pmd_t pmd)
 	return pte_write(pmd_pte(pmd));
 }
 
+#define pmd_access_permitted pmd_access_permitted
+static inline bool pmd_access_permitted(pmd_t pmd, bool write)
+{
+	return (pmd_val(pmd) & _PAGE_PRESENT) && (!write || pmd_write(pmd));
+}
+
 #define pud_write pud_write
 static inline int pud_write(pud_t pud)
 {

-- 
2.53.0


