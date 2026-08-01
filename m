Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EBD9C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 02:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9588C6B00A1; Fri, 31 Jul 2026 22:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E16D6B00A2; Fri, 31 Jul 2026 22:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C0636B00A3; Fri, 31 Jul 2026 22:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 45D4A6B00A1
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 22:17:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4097A020D
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:17:32 +0000 (UTC)
X-FDA: 85051089144.28.8280E34
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010026.outbound.protection.outlook.com [40.93.198.26])
	by imf23.hostedemail.com (Postfix) with ESMTP id 209B4140004
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:17:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="nFODE/+t";
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785550650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OB4Z6HAhO90wSrzqBCueeDHnctlgsxAOSQ2ZuZDGWmw=;
	b=lp4yMXuPcqi7ymnyUUrXQuNHGzmJGp29x4ikcyxvoxgo18m206Xi1le+7/tocE9evBxL6/
	oug6L/4Bz9+T+y5EunNbJ6MQUIpBkKlb/2q0tfhqZ1MLfm92DwAF4MJUHr3cETInulHwW3
	BHvmy+LMXA72M3WdzyU2/YNO1wQiC5I=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785550650;
	b=0HnBx6BbYbKbYCrdjLhLHzehXQuNKMOVDVm2cBJBwW9Bwye4h3cPtfNFY+GAco7UlMcm0V
	8f026pUVpb7rY86OR9urXHSWAxZ6bslI4QyPYvOLRlN4viXJvbH950AcR7YOUGl1Iw2ORX
	ISMJONxhYK6SD8w2ObsjSkC/9tNCq3g=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="nFODE/+t";
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XEXHn9OTclHnFLa0twxkAcXCaOWap+vQmvIuPgBMvTlMBQ55KCm2B9L4JShnGOPi1HHaThMo3iOQJ3HFe2FPziEiOlISoSMteq4O9usSzcsep83J87Yo8Rzkf5bQYwGoKOp3v+y+fN1UuvMieU+02SfIWojn/CcoH6Fq7IlVUgjEKspHW6uA9hB0YupL6uySnt3YmunGOA04bXUO7r3F5CKO3dYuqzU64Gkr+yRBbs0ooj92dzdr14hO+QqtnV/yh5R4ExCafFdf3kdfbvvKKsyKQwmDgADej7wYUXrF4DFm/YAjLN/RLzSITUxiCRQwQS/BP8GBM96OepoEFawBZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OB4Z6HAhO90wSrzqBCueeDHnctlgsxAOSQ2ZuZDGWmw=;
 b=mXbp6n7hPwqzEt1kp53pYLmyE7dBXKMjXLGWaewGRfYRovyyFWLu7g4zrgWtv7Uay9UqKbPtfmsdWUgosBg8YMKBmFiNNV1G67SIyi3sa1rlD/kM7etGohWyoy4ZnFFX5lkyJYGCa7pctEBdIF/5iuUiz35b32hY3YQa8LLhfo17WGhrg7cYPKi6uqUyb+rT6pBqMZlW6+iacWE0xmZR60+JdeYo7IOBwxn82wWlro9vnB0Gy5pFTC5ifRxrTBzGLBd33plPZBBpBCXxZj7/LkxQFlTTOcrIlCtgC/hpfzQIzdFj7bnykqIQWyoSqZO7WBPtrNTMexJxSXZeG17KMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OB4Z6HAhO90wSrzqBCueeDHnctlgsxAOSQ2ZuZDGWmw=;
 b=nFODE/+t7haKzw4Xq5lAl1t3Z2a5CtIBoUVG+hKpiErSYjBQLpcYwjzoOo/pEmTBiV9HJ4WXJqIQ0f1b+FLPXcKaqMHRpqOiNislWW5yl8dWA9XntqWYek2vzxQGhTniIF1dMKxudNdWtsXfkRvgPStZdJnwiJTa3iPKGdKc9WwfqTLqzfu9LcitZHdRtBatKQgWOwfTPewOxlM3NBgyCJ7eQpnDAePprCUHgcA3qW78NGcBDehD3O8KDVOjw+Ttv/vlZ8SMMnb1rsQqxtdZAMt6HLARDwc2dHOP6tDvS/4BeNxKyvSdw+363JJfgPB6tw4h4qjpAm3Cgo0EMLM0lQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CHAPR12MB999250.namprd12.prod.outlook.com (2603:10b6:610:300::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Sat, 1 Aug
 2026 02:17:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.015; Sat, 1 Aug 2026
 02:17:20 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 31 Jul 2026 22:13:37 -0400
Subject: [PATCH RFC 14/14] mm/page-flags: remove PG_private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-remove-pg_private-v1-14-142c97ba3562@nvidia.com>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Baoquan He <baoquan.he@linux.dev>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Dave Young <ruirui.yang@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-ClientProxiedBy: YQBPR0101CA0189.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::32) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CHAPR12MB999250:EE_
X-MS-Office365-Filtering-Correlation-Id: 1246d7d6-8757-413c-3889-08deef73040e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|921020|6133799003|5023799004|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YtgmYyd9j5YwgCrUn++onox1AGnpP1h6mxVq5hpgG47VCp2c3+zu5ju1GggoIOHPuuP85qCDpY/kEAnkwZDKeGwf9BFmov6SoCD2MsaBKPLlLe285aqKKjpz966FY/AUn3FF3e+wZ/1/e8Jz9znAE9jDB8zYzuGA3H0zQ0L86LkiuBHulnvUmziZITwwB0pOvgPpTWs7qgLmUrevDnjPlR9vFiS1Ri2H7eqZ/Jn8a3kKRc9T/8EkiO3og41Gmd5TQopM38AHhmWa3IkNVoixNMOmlAx+6SnRSTnOIpUYXT0V7HJ6yKo3yv4QpKLnvCrW24CsyMTCmULyxAbupDt11PH0T0OkEjA2HC/5yk9sGQNduHmVd1yQz23u+BVCYfFho+7Pmacdqlw8JxkjIKnHB2DTxKA9Z8OZds7bSEpMcQh0/2xjOLRfzKuWYlOxjveQpfSMyKXkmsPuSH3KjTmYGY53KnIekI2P7iw51m7xqk8UIdISosxod4q4Sy7efsiED54PadzHDOdhOKUmbZ5mSq4SII3KT9g69YDLtJO4N4/X1dGo+c5vVrR3+9NhvDqiI54yAQOv9HnDz94Vlag7LOxQuQUhs72bpB6fwFGYTuLvkEUlmF3j9z8EhgfkiJ9k+VwJ9dq0tfsxmQminF7CIi8Thx5HADy7/kKfda5XaNwXEWdYMElcRMNgVxYEMc7zKAIx3Tr3Nau3Ix2+eD9ZMg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(921020)(6133799003)(5023799004)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NE5iN2VIa3RaSzRacVpGS1E3VGtWTjZKWkcrWHVjVTRiSmhtYTNMQW5hRnJ0?=
 =?utf-8?B?NFdMYlF4WWo4M25jbWhzYjdKR012aG1vTk9idkxjME9vUXEyTnBldkVPQkRw?=
 =?utf-8?B?cHpRenBrYmRNREljK25kSnRLUy9ZM0k2UmZQVzV2dzdVTzF4YWNDZHFPRVMx?=
 =?utf-8?B?QUJCNllucm0rZWd0Q3dOUjMvMm9IM0h2ZmhOeFJJWlAvWU94K25lcUZRUTE5?=
 =?utf-8?B?U3VkdHE0WTJxZjdRbkd4dzFpTmVFSG9WVzVMbVRzektSZlhTNlN6b1FjS0Vo?=
 =?utf-8?B?ODRwbm5tRHFUb3FCSmdQSldDTnM1cXppMC9JVkJ4YnJpWmxiY0VmdjZYbmJt?=
 =?utf-8?B?dUlIT3l1dXdYcm0vWFpyRHNickQxSTA2SVRIcEpYTitOWHRDU2s3QlJhVjFa?=
 =?utf-8?B?Y3FORGpHdS9Jc0VjVjB0OW1PUFQxZkR1VldzaVQ1RVA5NTFtcGdOWGhnSEJz?=
 =?utf-8?B?K0R3bEhPV2h4eURMdjRjS1ZQSGdmdkVEdFozRDZOVXhzb2x2SkpyY1RYQjVG?=
 =?utf-8?B?SU9hOWcwS2J2aFVqeCtET3lPdjV3azBkS2p2Y0V0aXNpNkdsKzVHWVNnWnpD?=
 =?utf-8?B?dGNTMlNETFdlWkVjRTdvc2VHdkxMU25qcUZwOXVBbFNPcjVqc2Zlb3FzU00y?=
 =?utf-8?B?WTlUNHIwN2k0b2ZQOGRwZXRqR3JzT0ZxZUlvdDA3WFN0ZXpFVVg2cVhQc1Nt?=
 =?utf-8?B?blFlUmp3T0hmN1NVc3d2eFlWTS9zRndHcitiVDhUMHJZNk5iWXZQWC9GalZ1?=
 =?utf-8?B?TnpiaElKTnZzUGI3YmZLdHpFaG4wVDNpb3Foc1VZRDBFK28vTFpzaWVYZXNC?=
 =?utf-8?B?ZWFZeEd2WnNWMDljeVJvRTEvYW9lOFB0Y2kxcjFWTTYxa3NCNDJVOXZDR2RP?=
 =?utf-8?B?bTllSVNKRVFOMkloTnFIL1RwUHFtUU9QSjEvNnlBbFQvLzBJZXVFR1AxQ2xk?=
 =?utf-8?B?NURiUTZMTElnTDBGaUo1UDByQ29sZnphRlZQSngzQy9nUmNCMlFNTGVvcXNv?=
 =?utf-8?B?aENEcytJbHFZQzlyRnZJUGFTRHhoenhtOEoxMDY3QWxOY09GYytydGVhWkdR?=
 =?utf-8?B?eUg3VUR1UVhiVTFtOFM2bUE5Y2Y2VjNoNUZ6ZDB5RVlQZTJGZDFEZ0ZGaGxR?=
 =?utf-8?B?YzdXTWtHdDVxQ3ZIbWZvUlhlZjFzb21hekV4U0ljZ2phNml5U3VPVElocTRJ?=
 =?utf-8?B?SDgvYktQb0JEeEgxS0ZQV01IQ0hXb3J4dVBubkVBQkw4WUNGeE5wRWpNbGNJ?=
 =?utf-8?B?UkYzZyt0RDFFQnFHdERsSDhVZjVWNnFZV1NMdHZ4cGVxeTFYY1FZU3ZqRGNT?=
 =?utf-8?B?Ly96bzJFU0tqbDZ5M0FtMkpwWUlPR2U4M0lqUmZPbUsrODI1YUZ0SVVIWEVk?=
 =?utf-8?B?VG0xUmhyNEd2WlRqbmVjaitCdCtkSThyMjFxckpMYUcvM0E4akN2eHpXaVlu?=
 =?utf-8?B?ckdkK1dZSDdDUTcvaVF3ekRNbkZhU3Z6T1lHbHV5alFObzBGUWlNR3QyWW1Q?=
 =?utf-8?B?SFJsVFdoWUNFc1V2dmViWkV1Ky9hTlR3dWhCcVFwQVI5RG9TRzNaUWpYcXVp?=
 =?utf-8?B?cGVia3lyQmo0NlpnWTlYYXFDWnFwVkpwUU1TSmtKbVZQdWl1Nks3WjV5TkNE?=
 =?utf-8?B?YklnZnRWVFY2UlN3VnFGSzRoN0NMaUZqdkJFV1g5TEIxM1NNQUhlM1BJMWxp?=
 =?utf-8?B?Q0Q3UDNtcHUxdElGL0t0WFFmY0RGWFFQU0RaS1ZCa3hHSC8wKzYwZWUrMGZV?=
 =?utf-8?B?V1VqQlBtV0JsNXJ5eXV6S2NEdkFMalp5bmR5MC95RTQwQlR3Z1dDa1l3UjFq?=
 =?utf-8?B?YWg2Q04rdUFneGdlV1dESVpEOGNFdzNmc0ZUNHpKWTIzTk5jdmRnVGVSbUdm?=
 =?utf-8?B?VVdzODBOUDBlNFZjSnFqZk43QWw1R3BTN0VsTWtNWGJ1QzRTWlBtMi9Ud0dE?=
 =?utf-8?B?dk05eHF1QmNpVDhCYWI0U2Y5ZHl5NFhGTHVrRGdsMUlhM3RUdjBDcTlxcC9z?=
 =?utf-8?B?bjZFVEJvQnBxei8vM3I4TUJJRFBPYURyVENNS3lPY2U2Slc2bXpOKzZiOW9r?=
 =?utf-8?B?cUtzUGZwYnExWk1JcXZJMjRHZ3JzQ1M3dzRuSkRrU3BtY2RZS0RNK1ZtVDBT?=
 =?utf-8?B?V0JJWUQweGdkc2pDWHM0UWJqempMOHZBcHczdGpGUjNrd1Z0U3ZLSlIxWXJO?=
 =?utf-8?B?VEdaTUVLaitNOS9iQklmTDZmaUt1M2ozS01qVUdWQmxCdzRIRkJuZVdMcW5E?=
 =?utf-8?B?cHRheFlWSm1LSnIxcjJFdlJaMW1ybWs2M21UMlJIcmFoNjNKYlVFdkFCRWh3?=
 =?utf-8?Q?cc4n9jaAEktgJX9rMA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1246d7d6-8757-413c-3889-08deef73040e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 02:17:20.2222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 91bkUmO6i4hIhaG8Qu5OmEn3y9IvCfuSTeJ6WjzB+wsg2Uw7eG38b12oK7hss0fg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR12MB999250
X-Rspamd-Queue-Id: 209B4140004
X-Stat-Signature: zpjotzqpw7t9y68ygmw99xbruo7dnmu6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785550650-174468
X-HE-Meta: U2FsdGVkX1/bdGdDJL9Wv+6ZYOF76HwbqP56kboQNrDI9C0wpwg6tSuiNu4mZWNMeSI8TtylEyHugOs1B02eaowG/7yOOhdgtOPqvDp/GiCdDMPF7+KTQUc+FrLKSJLUPB3sLWjnZ9yyKfToTYmb0pDLEWQe4HsjCc2/wZ63RMZHV/9jMoxhfBufGxt9zZ60TCAhS9K2Qpu82HuGz+VEgq0eqQq8E2wplQz1B/4pUG6foxgSREhqFnRuFTHHsonutiWdeJDmGTkDFzvA0d94Bjk4T4AfEBqrVZ0rsQSdZTX+pduiN1B+mfgAaipNZhoHy14uB77LAexsClkTXE/hYFzhgycCKpchqVQIB/8dPSbIMe6WgWiyrQELGvO01FMWKqK+pl1t42Y97P3hLEiWy091vhfUncxLCoNBQIHPJdlOq+UaEtjtDafG8osI7/Y9bS3jstkOoyKzLEbf71kJHq1L6mLIDHYzSqXnmyGZkzIjs8fDA2c9vPD8bqoQ01jj6QNI8AewGE4SCxQAUYDFC27ofHSTFGvO39u8T6/lpBy9jf+f+EuVu4H7CHr3lGtQwHw0NsBeoSIiT6brsFclHVcxAQrAuy4XIiX/p8EfzgSh7V2iSYwEQxJ5bV45KlfoRHIJtL5tUfBxzpESXFbhd0HW3PXO//D4h5L+RABrrLD13simm8lRrUGuu6Hh1jvWSVy5qJphgDmhMnZ3ZHGFUKCjt3OYgzP1cBU6N+ptHFQhtoE3UfTem77qOJmZzFC49j8qlY1QEOHXpQq/8+dFgSrSr3UKE0/cM/2dfVeUf49mRdiOi9s+mUCLgXS9CTljYox9bwkSO2i+4RqJeMYR73yq0XSA/XYfwtUlUFIyiF6ui0f7S4rZNoITZKElHyEeDVlOQAMuFEqX411uU5ic/ColAIZ+o2JVfAmSpkxUd9F6A0+c88JSxuxyp0xZdb1aUY/rMrY8buR/lT8Tt6Z
 1fQI/+zQ
 3QImxW1pYd4Zwr/bWD8Zb+KPokhhenzp26+xjv6wb2cqSo2R828bv3y3WTCdoMYEtjXF685KGIw8iKcGq9wn0g7aTpuo07y6tr0R3Bv5d/JF2gpQZe7kZiLTHCMu2f1JS22dVCaWWs9ie+d4pacgUiOuxNfgDhnmk6LwRkpkKv2FerAvEjZmiTzjSVYeblWKzQIewta420hBnrAuywI9Ey0M4cczGeMgxdCUYN1xbQXXrFxPXSAjBwN4TidqE2BuxL8Vbj2fRXqwj1tZdpDmL2DWcewbUB4pzaPYW6Yf0P/AFE+zk+VNCdwmqToUUVxjmrTeVv4mwtZSF6AqoqmOXBMq3FqhJUi2rhRAPAIUxexNqmzHIie34pxf5QoZZO+NX293xKvs/SM62bdpIjbtkI686mOb5wn2+vQrh9tvnkJL5EuBQwdYc5vya7TJbXRPgBDjIkYE3c09SxVTW/2c8KxCsT5tB+ifTJh55DsTA0om9saoZXaij5J56ph603CdFOL+MoTzbvwKah0pWLTJCB2aI5OXP7b7qa6aV6EaeIoLQF+To/mgbQESRZ2rzcwHj3xVQxr5ljDq5RV15pb4wylghDrUkKlZJgN209jbm/tfGY8ek3tsbzCjOahPtAeotcfiTi5uDcV4PycBCmtIicA9OEK/MOCo2Cy+V4GQu2IbM1gqKtM9v2n/ud9yV5zz7zjeZhly2b6Qb6DAebPsq2UjBreNsawoiNr+M7fNGwfv/8NwsUKyBTQZ2RG3WgrA5moNU/JK+rbPV92HKbpnyHM03bDax+8Cpl8MDPV832dY5GxGtE5IqJ2pTeOehcWL+uBBbn6emDROcvF7/YIaKk7hou4PviBYqsL83c9/jgB7wA6Li94hQHWZrWBDiXwB4v0CNYDl//yahG9z04hlb2jl7/LW+iEDKJ6rQs6zxKheN7+on7fcB6xSEv7PR0IG+ZALiBQYNu5jHhWThfQY/x7sL7XT6
 Oay2hri8
 RLonW7os/tk+nsZYGDLBYY+ElGpzMDddE6D/QHc2NWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio->private != NULL indicates a folio carries private data, replacing
PG_private. All PG_private users are converted. Remove PG_private and
reserve the space as __PG_folio for future use.

Also update files in Documentation. hugetlbfs_reserv.rst is outdated and
left unchanged. It should be rewritten.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <baoquan.he@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
To: David Hildenbrand <david@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: kexec@lists.infradead.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org
---
 Documentation/admin-guide/kdump/vmcoreinfo.rst |  2 +-
 Documentation/filesystems/vfs.rst              |  6 +++---
 include/linux/page-flags.h                     | 19 ++-----------------
 include/trace/events/mmflags.h                 |  2 +-
 kernel/vmcore_info.c                           |  1 -
 5 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Documentation/admin-guide/kdump/vmcoreinfo.rst
index 7663c610fe901..5f1df6d080508 100644
--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst
+++ b/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -325,7 +325,7 @@ NR_FREE_PAGES
 On linux-2.6.21 or later, the number of free pages is in
 vm_stat[NR_FREE_PAGES]. Used to get the number of free pages.
 
-PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
+PG_lru|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
 --------------------------------------------------------------------------
 
 Page attributes. These flags are used to filter various unnecessary for
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index e7677423a20f7..5cc07f82fe371 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -649,8 +649,8 @@ Writeback.
 
 The first can be used independently to the others.  The VM can try to
 release clean pages in order to reuse them.  To do this it can call
-->release_folio on clean folios with the private
-flag set.  Clean pages without PagePrivate and with no external references
+->release_folio on clean folios with folio->private set. Clean pages
+without folio->private set and with no external references
 will be released without notice being given to the address_space.
 
 To achieve this functionality, pages need to be placed on an LRU with
@@ -674,7 +674,7 @@ filemap_fdatawait_range, to wait for all writeback to complete.
 
 An address_space handler may attach extra information to a page,
 typically using the 'private' field in the 'struct page'.  If such
-information is attached, the PG_Private flag should be set.  This will
+information is attached, non-NULL 'private' field will
 cause various VM routines to make extra calls into the address_space
 handler to deal with that data.
 
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0e3628ea080c4..eb2961ed61018 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -44,10 +44,6 @@
  * Consequently, PG_reserved for a page mapped into user space can indicate
  * the zero page, the vDSO, MMIO pages or device memory.
  *
- * The PG_private bitflag is set on pagecache pages if they contain filesystem
- * specific data (which is normally at page->private). It can be used by
- * private allocations for its own usage.
- *
  * During initiation of disk I/O, PG_locked is set. This bit is set before I/O
  * and cleared when writeback _starts_ or when read _completes_. PG_writeback
  * is set before writeback starts and cleared when it finishes.
@@ -105,7 +101,7 @@ enum pageflags {
 	PG_owner_2,		/* Owner use. If pagecache, fs may use */
 	PG_arch_1,
 	PG_reserved,
-	PG_private,		/* If pagecache, has fs-private data */
+	__PG_folio,		/* Do not use: reserved for folio identification */
 	PG_private_2,		/* If pagecache, has fs aux data */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_swapbacked,		/* Page is backed by RAM/swap */
@@ -576,7 +572,7 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
 /*
  * Private page markings that may be used by the filesystem that owns the page
  * for its own purposes.
- * - PG_private and PG_private_2 cause release_folio() and co to be invoked
+ * - folio->private and PG_private_2 cause release_folio() and co to be invoked
  */
 
 static __always_inline bool folio_test_private(const struct folio *folio)
@@ -584,17 +580,6 @@ static __always_inline bool folio_test_private(const struct folio *folio)
 	return folio->private;
 }
 
-static __always_inline int PagePrivate(const struct page *page)
-{
-	return !!page_private(page);
-}
-
-/* no-ops during transition */
-static __always_inline void folio_set_private(struct folio *folio) { }
-static __always_inline void folio_clear_private(struct folio *folio) { }
-static __always_inline void SetPagePrivate(struct page *page) { }
-static __always_inline void ClearPagePrivate(struct page *page) { }
-
 FOLIO_FLAG(private_2, FOLIO_HEAD_PAGE)
 
 /* owner_2 can be set on tail pages for anon memory */
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 935893e5ea53b..caf090cd6f85e 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -144,7 +144,7 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 	DEF_PAGEFLAG_NAME(owner_2),					\
 	DEF_PAGEFLAG_NAME(arch_1),					\
 	DEF_PAGEFLAG_NAME(reserved),					\
-	DEF_PAGEFLAG_NAME(private),					\
+	{ 1UL << __PG_folio, "folio" },					\
 	DEF_PAGEFLAG_NAME(private_2),					\
 	DEF_PAGEFLAG_NAME(writeback),					\
 	DEF_PAGEFLAG_NAME(head),					\
diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index 8614430ca212a..5a417f8a922ab 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -216,7 +216,6 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 	VMCOREINFO_NUMBER(PG_lru);
-	VMCOREINFO_NUMBER(PG_private);
 	VMCOREINFO_NUMBER(PG_swapcache);
 	VMCOREINFO_NUMBER(PG_swapbacked);
 #define PAGE_SLAB_MAPCOUNT_VALUE	(PGTY_slab << 24)

-- 
2.53.0


