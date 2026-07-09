Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A06DDC44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 483CC6B009D; Thu,  9 Jul 2026 14:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433F86B009E; Thu,  9 Jul 2026 14:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F806B009D; Thu,  9 Jul 2026 14:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9AB76B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:07:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7385512027B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:07:01 +0000 (UTC)
X-FDA: 84970019442.09.81FAEC7
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012061.outbound.protection.outlook.com [52.101.53.61])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9E1341A0006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:06:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FVB7Hqii;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783620418;
	b=bjghq96vFxpL8E599oKsgoLJN66Rl7MiOMJe/suDw1TnfeC0A679/Fp4J23A9SR/TKqZTd
	INLjbJnUGvZMcCd7u1K8Jf609tq+s9JsmTcHtSVeKTANWsd780lZlV6dAIBWbQX3nm65Hh
	lFHPZ71QuvX2LqY98oZ9sNQsZJg9tm0=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FVB7Hqii;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783620418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOOrdQPzwZr6nIoMEHcumGzsQqQZ/bSyuwlPWkGswaE=;
	b=BNcw1fruzV53g9NEKlY2O0VURjqoA3DQvi/HHMeUGc/CdCnWrUM1YR+lzTNck4CDU3gTxG
	8tBPzoRFVVlIOUpSsa4GwQ6gKZ3WAjt/yzzfFExhUIRBcNeTLnIDpDNLdBOa8mAbY+UV16
	EAb5lITJLf9Gst+7FSdBA7deNLXlFV0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GsTC8cmx84nclUzJwY5nKl1EEZPt7W6HavFn74VFDb8wutkGHWNMLA9rchnc4Y+2OBUW5oAwdK0kYK17tXOUUnO4eIVVkDKBRLuNuUXG21f9SSriZg5AjBVZ/a0cZQT6oThThB6ue+LIl7TzHqm608ivzLh5oLdU6w8L5Q+bFRKpJf8mPFI4dhteD/RRYRkTvo/FL/VeBA+S2a/t8lVgeSUrky7MLl1wFn+LNzMh995aqkj/Wn917tXlBn8HT5Yl4Qo/BzbCqrIYT1ocbBDwDAW/HG7pmsBNJE2L29Q18Mea6BU2JbqyAd3LVD5GKdDXmg/nApmV1DfGn3zrly+I5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iOOrdQPzwZr6nIoMEHcumGzsQqQZ/bSyuwlPWkGswaE=;
 b=vrFxoGl7+fqN/phV9HQREJ+aOtEJS+bADqiX4eIn1DRIJSRtWnZvE1639hGyW17SXLDeX3Xk5GJgekpiSsPXU50qYvPr6SJdt1lBVJiwakSc+qDyMImPfaHe0qNCsy0ngtZc7Ttz7KtWaOhfhJPyUeeckUX5iLtWXHaOTaOjSYzinMgriESkTQuN0cBNtHe1c7+EddP2eBEUBe0sD5D76pNNb7JzISdlnHuIgJZ970zkBQN4KP+I0UeK77buGvoSwSQTBxwqU3ruTLdOHOLtChCMs4fU7JFvolDXX6H2lpH4FGdpi01dP2XvPiZcQpJjLloN1aDoQMTc8CF2mSA3qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iOOrdQPzwZr6nIoMEHcumGzsQqQZ/bSyuwlPWkGswaE=;
 b=FVB7HqiigbWW1/c2hFG1YpNm+56I99wgvR2+Oe4iZb4wcELQkIY5RpSGvI0ol4odtRpvgpCNmLFBLec+Kw17fKF3u4uw6zauMKzqGsTD7r+bVSOKzPijN/vLiAGLEbksotUALgg5ZHWLngW6QLETuihJ3iXNKuPNldBizT7vGpwZS807HOczhCu2mOJ6JgoCkV+Rimg7LpdvA5jY6zjUWI4hz5kbG+zZBJmb7MjUrRRJMzDxrdVao9wpWIwZ/tcXSHnAQwY6xl5kzAgD+ow/6ufV64CX+x0zpJ9fq5H1Re8A/pjQOxFog3qexVg1hq25D5ZSMvL5a8NQYwGPUspFgQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB9007.namprd12.prod.outlook.com (2603:10b6:a03:541::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Thu, 9 Jul 2026
 18:06:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 18:06:52 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 09 Jul 2026 14:06:04 -0400
Subject: [PATCH v3 4/5] mm/page_alloc: make sure tail_page->private is zero
 at page free time
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-keep-subpage-private-zero-at-free-v3-4-7e4fe155f5b9@nvidia.com>
References: <20260709-keep-subpage-private-zero-at-free-v3-0-7e4fe155f5b9@nvidia.com>
In-Reply-To: <20260709-keep-subpage-private-zero-at-free-v3-0-7e4fe155f5b9@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: DS7PR03CA0044.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB9007:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c9a7d10-5599-4210-302a-08dedde4da5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|366016|376014|11063799006|56012099006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	4sFwGo6/npcwsgO6v7RDIwT03HpZriXirukWIL+A2lSXRQQYgZlUI2ZWJ3W/B3FTxAnPkX0HInv3c4nhfS6LlhjYphggiOFd5Q625mevv1L26Xwg/nWNVN14yM6hCMJxc/lg2JDCpka6uW7/Cffo+WzVMo8tk53au5Gcz49cuLeLXn6f8HGtLjk+mPw3SToIO8ER06onq759umM6PRlkeHycIZ4DW2SZubYGOD7i6IAVDM82aU2WbYPe5R81kLYT2n2QWWRE0m62/pHM44zNBx2so4Jeo2Gb/V6sqI2q9KlIkLMJkWXE5ktIXToRRtyNCvc4sKt+zWGdTVGK5v7btzFRdH4ObuXSy7/OctSwq3JxGPj4cpXh0NdPUjcrt+WkLN9s3Wi5asQSti+bkbQK+PvFYRba/7kEWQCOWomi2RzKpeaFSx2F4xmfHmVcRHPVnaN+gxfbcjbtmWNOi9jbpdTfqgXOIrc1qqB5MiEApuzJJwjFJ/NoTvNE7c3bK0kYhqTHTbQdedGCtQexiSmfIB540WATGvtB90Jp4+EfCei1dEMbVkp7EjjDAzzA3pAdizPXFMkAE+Wycvjmvui5/GJ6qTYTLKY+JV8VBuGn5/KWrTImIm1uMmiwN7w3E+JSLp6DUqFsZkpXL5FdQf7vajzdARuvHybIbDsBVEuvEBEU5IVgF9+5S0cSgfYe+IHu0rIpbxoXF3/RSExsJZe+Qg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(366016)(376014)(11063799006)(56012099006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0pzUHdsRm50a3ZmUll3WncvaXV2SVVNT1VqZXpwMFJqT2JxZzNXU0MrblpB?=
 =?utf-8?B?cXJ5WklHdkpLWXlJR0tEYnR2WDdtNjJCaTlQQnZwUXlQbGxpNVBpSkNndUVW?=
 =?utf-8?B?cy9wSCtobXhyUThYcTU5RGtTU0szTlhmUWtITWJYSFBYM3U1RDl1UVlkaHpm?=
 =?utf-8?B?eFNtQXZtaStodDVzR2hyU1VyTGd4MUU5dnkva081VlVnRS9WK2JjYmhIdUhD?=
 =?utf-8?B?ZmUyb3ZRNzJqTDJ5VU5obnRuSnhvaEErY3NZa0VOdy9obUQxNTlHZnM5UjlN?=
 =?utf-8?B?Um4xSk5zUHpRVFFOVElyV0xJYjk2MVNISDlGdjVYRmRuaFNoR25qVzBCYXNY?=
 =?utf-8?B?MGhReWxuc1JYZFBOdFgzQzNZRUNaSEd5dUdKc2pueVNVZ3U1b2RXOHVmVWdN?=
 =?utf-8?B?b2hQNzBRaHMxQUVPQXdzNmNHcDZhUzlXM3pGbUs3OHhWU2V4Z3VzUXdxdGM1?=
 =?utf-8?B?MUt1QnZGVjNnWDI2b2MyRFZJUkIweU1JTk1xdGt1SzhlY1Zmdml6Tlh0VnVw?=
 =?utf-8?B?OFZ2VEJQcC90NE0zNDdpbFZhTDZXQm9wNkRubXRLZG8vVS9nU0c5Z1oxMjZm?=
 =?utf-8?B?Q1VDWjFUN09TT05lc2FkUzhoTlBIZFBUc2hNYnBhcDNkalpSSElucnlaRmZN?=
 =?utf-8?B?UkVDRGlxNVlhdzAzZ05aa0VQcDBxSlNCUFZGNTkxTWVpOHVkWC85TDZQRzRn?=
 =?utf-8?B?aVhPQ2tLYllNY1ZvUEZjUTBPVi9vdVlSUDBVZDFia1dxNGx2aGVwRzN0MEg2?=
 =?utf-8?B?U204Y0R4ams5ekdlaVl4a2lXM2NPL0dhWkFEa2lZZmRzUER5UVFQWmgvVEpy?=
 =?utf-8?B?YU15bTdGMDJ0RTBaODVIZzVHd3ZCZDZmQVVZWFV2R1MvcTJSYWp1UmwyNGo2?=
 =?utf-8?B?YkYwOHA5TXNGSi9iTk84eitHMERXYmJTbUZSWjM3SXM0eDFPWVM4T1pvUXBa?=
 =?utf-8?B?ZWJlWmJJSE1yNWp1ODhYYUY5Z29DREI2aDR5UFFlSUt3OS9kV3hQR2Y3cVIz?=
 =?utf-8?B?Vm0wQy9WRnU3a0FnelBCZURmUldiTVVVaFJ4RWE3NVlLTkxBb2cyZGNidjJI?=
 =?utf-8?B?RGFaU2lqZ2luNzc3dER6cnplQmk3cEtwWGwvajI2N2tGUE5DTFV2M3laaGYx?=
 =?utf-8?B?NnhBeFp6VU80anhlZ0JTSngxMzBISDJFaWxHM1BvelhTZjBZWUlHdURCdzFR?=
 =?utf-8?B?UTgyZE5oS2MrUHB0Q21lTzQ5Tk5xRUdIRUtkNDJ2U1BMWUlvcm55eXNvSmc0?=
 =?utf-8?B?WHRzcXRxNk1jaklpRVZzOGEvNVFxWlRFTTJzYXFSNWhBWTJEZ2hON2lQM2wx?=
 =?utf-8?B?blduT3Rjek9kckJwMzVUb0tVeTFLMTRUVXgrdnN3a1Z0cmxYNnpsVzdKckNQ?=
 =?utf-8?B?Z3hkKzF6K1F1UzRRSXpxc1ZsbE9iM0dDRTB0S3IwQVcwODRIYUZNTHdMd1Fv?=
 =?utf-8?B?bEZ4cTlQRkVDUnQwTGU1SjQyUzMxMVJZRzNBRFBBZjdnelkwYnF4Nlo1Mnpt?=
 =?utf-8?B?LzJNU0MvU2dMajVwbGtjRll3UG0xQnhuaEZCdXVJdGVJZDFnbTA1VkhNSkQz?=
 =?utf-8?B?TTl5SWNmN2t6SlNSVG0vQW5qakVXbldmdkZpY1pRSnRybVEyWVhncTd2cm9N?=
 =?utf-8?B?U3ZBTWFEY3dmSXIwa3lTNjFnM0hlaTVITlZrcnRLQytoSEZlNjlYelRCYzJI?=
 =?utf-8?B?Ym16L3RSNzBTMUdLWXY0VzV2N3VZZjhuV0FNNXE1bUlBaHdTckhpVmdJMmZj?=
 =?utf-8?B?citGY0owSGNnWGp0MGFYSzk3VzNQNk14aCt6akd5Zmlya1dhRCtBRUV5cElh?=
 =?utf-8?B?VEk2cldQZnZ4Um1TZnBpMWQvejg4THdNY1VYeGxoQTlsMHlIOVBMVkliRnhh?=
 =?utf-8?B?WElCbkRLT0lFMkQvdDBvNnM4UWtneDM5TWNPL002T29Sc1RQbTV0WWJvblRB?=
 =?utf-8?B?UEIvNDdUUUI0YUNtTzdGRFlvVERpUnU2RXFZWWlqMmNUV3VyRE9lL3RCOGJv?=
 =?utf-8?B?REhxVXdQUmlqMWtGb0FVa2kzdkpnbXhTTWFpazQ2OE9QeE5vRjIxUzAwT21v?=
 =?utf-8?B?NjBPQUVNRERRZGpBdWVpYUpYV3kwZGtoaWZUOUtDQk44bGw3L1lDSTE1VUVY?=
 =?utf-8?B?YUFoUUFhSUNrTkNvczZhRWUrMlgraHRlNzd0UGNRak1YeDl2NENHcElnNWdk?=
 =?utf-8?B?SXByT0d3bFdLdFJoaFBZWVJ3dGFlczRWUDE1MkZLdmZQVW9ZcngrYWdNMHo0?=
 =?utf-8?B?NUpGRXp3UnY3NE41ZG1maGlBMmZEOVQvSTVQaEFWTy9CcjQ2dTN4djA1ZENG?=
 =?utf-8?Q?W5OZ5nCJ9glwg/oqZZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c9a7d10-5599-4210-302a-08dedde4da5e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 18:06:51.9968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+YE1YwA99L5pDk0krqBF/JDkQIM2vD5Hf/OeQXcBHSdbI3ORC94GF/BQAwHmtNL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9007
X-Rspamd-Queue-Id: 9E1341A0006
X-Rspam-User: 
X-Stat-Signature: 4pde6hjfqet11c7r9yibf6cujkchf3in
X-Rspamd-Server: rspam03
X-HE-Tag: 1783620418-671340
X-HE-Meta: U2FsdGVkX1/uaHuPEPw0Ray3ps+IT8CoyNDRlfGt4YNflHZP3zHdaYI2KTrDiiTjr8Nvd4IOzAeXIf7MTrBSloo0A4DVOCReNJQv0hGmJJgVUKibKJlyoImQUg60+XGo+zz4Og3RA8+A37a9VlM0Xp8IITUG1xWvt3UryX443uLE2OTb5l3NX3rwYdljw5st3uwbwRL48+2/DrV8zM6zeHxjb9cxWQSlCcQpo+ywsc1njBRM0aJsvd4/J0KPLP3ZLvRZJ7cBMjV5tiLT0oMhqNOYHYWdYmL381Rc3AuH0y4t9S+BEWT5ouTZAA3lCTs/aMd+OOipEKqGhe/wr/6OeLwEr+JYqCCc9oN6zijR6fysEMsfK8aSArF5bRJ7fn/kmx3LBfvN9OR/CIfJkP1vuqSI9NunNvfbV7v/Fj6UCvbQkm35Bv7/MYp4BSiV2PnMYXjMYWkCIFYl4pc8STXDXDVeHUHMv6vELmG2kTGIUZ2jT99szsFJcYSwtuREZUTnjQomabL/01umkiq/6ODXs/sBpPDlMo+OQui/N/6Cj4s8RAAaCX0JIiHR1MiYWtAIswzH9UNIsh+Z2GW058zgMBNOEk4pnyMvI2vi9TXGbNAfQVo9JNqA41c7wAAb7iwbvos42DDK63zBgMWWL8OG5s5XagzACixfI+iT4988Swq7dDko1t0A1Hyc8SExDT4olSrdYlI94+iqiXm+pESzQ1mU0nODBUJm7netE95h1kjMuxppiEWGcYQ6Ji5ByWawAjQMN+00nKZB/g99lYmiLtee0UWE1p1hvUGDBnEIF5oKEfQhRVoeh6UoCAzaEOwFDQxc6jA4HF05yhiwEsgs4jYbFPkSDmqHxKqYBqIfGayVxUvFASFJBZe1wFbEyanLWkJ5QHuzk+uEm1gXM66xMrR44ZVC3YCl+M7LOHUKCZA6TIeg9A/fMaaxw5hcfiRfvPyTTt6nTLF2nAaQ3me
 P3TGel/5
 0VUyR2gfj4cYM4wy86Xgi5nhFg8Vu6IETiqLGL30zX74iuk0ZwCU11j7xnLc/3j5mdgHPg/hq3egEWaArJVsHedHnkuqENQhCpQkbcsqczuskO2GAZ5EEnpra61OfmeItSnROj7AzXuq3VTnrXe2ZxMIzHhCtglxH82InuyqZIK317PAzPslmjkMKQBkR8PpoI5TwebvN3+7Vu1w9g6rTRc3GOrcWuhZhimtEdv4GxfTiy6+gzOB+bwKltAlvEnttetlKquceIgLBfFdGYg1sOJI/T7EGGexzmF5CSMTwGuvuHQTgVDCrAsTo+YlsYm6Y7+zz8mdy6JMvq/rRsuegcGjNw3gP7Y9IOIc5ymBa7Ltfa52IGqx6OueMh4R10aXq3uWj5HFg6VOfxdTUESeD8YdO1c5pwLcH3duiNPj4IEwv7lgWJeVS4icui50yxCAhOaggEk6WK7UTYMVI4l2x+8h1DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Any code using tail_page->private of a folio, a compound page or a
high-order page is supposed to reset it after use, otherwise ->private data
can leak to new page user and cause unexpected issues. Add a bad_page()
check at page free path for it.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/page_alloc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a63733dac659e..cc45dfe89c76b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1377,15 +1377,23 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 #endif
 		}
 		for (i = 1; i < (1 << order); i++) {
+			struct page *tail_page = page + i;
+
 			if (compound)
-				bad += free_tail_page_prepare(page, page + i);
+				bad += free_tail_page_prepare(page, tail_page);
 			if (is_check_pages_enabled()) {
-				if (free_page_is_bad(page + i)) {
+				if (free_page_is_bad(tail_page)) {
+					bad++;
+					continue;
+				}
+
+				if (tail_page->private) {
+					bad_page(tail_page, "nonzero private");
 					bad++;
 					continue;
 				}
 			}
-			(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			tail_page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
 		}
 	}
 	if (folio_test_anon(folio)) {

-- 
2.53.0


