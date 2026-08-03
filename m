Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7557C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2D46B007B; Mon,  3 Aug 2026 15:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73866B0088; Mon,  3 Aug 2026 15:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62746B008A; Mon,  3 Aug 2026 15:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 740506B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:12:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2C771407FC
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:12:13 +0000 (UTC)
X-FDA: 85060903746.21.A0A8243
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11021104.outbound.protection.outlook.com [52.101.52.104])
	by imf16.hostedemail.com (Postfix) with ESMTP id E2874180006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:12:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=u1xa3hFb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.52.104 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785784331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kiZzOLH+N8WaI9WcBLqbjm+eyWCM6fibXzHT7cyGIY8=;
	b=btM3WFE1UqbvGztXRLK7i/tKlcj7qJ69nXDdT9/V0M72sEbq6b4DVBz7DadD4GnmcILrIY
	ShI2486nQRX+835oq7YFt069ersrgroP4oD7xeOg9Jlee1qrsou1S6OYpICmLhUycEndH8
	r+F+m6jH8N8A79sqrS++VtnzZjx8L/Q=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=u1xa3hFb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.52.104 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785784331;
	b=oAFyDoMy+jc7fI1wusd9+KxDgVh1s5Ce1P3Cgf9o+lNN3kL+LepqJA+sGriu/aPO41l1II
	ZDRG0AOu75zDFTuqxZEYLfCMl187sy4XDgMCVh4d3RSpWy081a2lJ9SykR2CBM2Pjmu4HL
	l+MJzIM9dmyMjvZ0vXTYsyVP6ciqj/c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vc0VS8ISIkD/NvSZFfs2jdSar0DIsdW6nUa5nlbKX+/RwersXunCm2eumnmfSOIy+bpP/pRSGTk+xTovYQMt5pMEZ5fFeem6YASjz9SDGyATSadWiL7WqX5Od3pXXgxEhKwJBbs7kc3hZlin1a0NYWexELuHY243unGnJJLgas2Hm7O5R7t82o3AxCFbpA4VwxF8LQDqPwuUsMq+uXv3P0CCQbvV9wv4Z3OvoXFBMhjlj6rpyYx0tV3FifDCfiAsATiguDz9fVEtOPeNrpCiulIUqjHynwDZKv8oUJ/KCinjsJHZOuYjeSIdffgnpb/Fn+/rb1f+BMlk3pSG05saXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kiZzOLH+N8WaI9WcBLqbjm+eyWCM6fibXzHT7cyGIY8=;
 b=aTLZ6nLxozAZ3GOTNecu9tXbKEf818e08bru+Kx2C0rGL4Ne+To6UEEyci/PGhOZIjsjQ1UPl/A6gKxc2mepaLcVQ780M6x4Nb6aIkrgJDsZVeq8iJnH9N8CH2LmDG4AWxudXkJBzyaBXT6ebZjTUY9Cg4+fCAuZAgbOXHOeJUPArsHJhY9iQxrTWSoX372Z44w1udVQ7LXUuIkDn1R824azbPku5sbSPJixT9u2wYh3qBR3qGSoy8QlG7AYVU/2i717eq6GpG8+CaRHjp4tMeVsN33GIkXsgpB8YqQFBP42Cu5Gy+5A2TujeBqMoPUDQrdDWcvHG9Dfe6NcH48qgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiZzOLH+N8WaI9WcBLqbjm+eyWCM6fibXzHT7cyGIY8=;
 b=u1xa3hFbJYGYLiS7Jo9sdRl0oHN+pz2U3n5qRxX9104LGfv0PeYnP9LYBOgbhanKeIk+ehXyV0AEv9+RTvJcW5NMpWI/IBHcLCU4f7BqRONPZTdyMAQe64/5V9hDigvJEsUK6ByrlJ9lmEfuJjRiI5HuhrUBEJP7Twmpf27qeKs=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 EA2PR01MB994459.prod.exchangelabs.com (2603:10b6:303:2bc::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.18; Mon, 3 Aug 2026 19:12:07 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 19:12:06 +0000
Message-ID: <64d83bb0-b19c-47cd-94db-34ac99686ed0@os.amperecomputing.com>
Date: Mon, 3 Aug 2026 12:12:03 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/16] vmalloc: pass in pgd pointer for
 vmap{__vunmap}_range_noflush()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: cl@gentwo.org, dennis@kernel.org, tj@kernel.org, urezki@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
 david@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <20260715180455.515692-5-yang@os.amperecomputing.com>
 <amnIBsFnkt5Q2UUw@lucifer>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <amnIBsFnkt5Q2UUw@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::9) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|EA2PR01MB994459:EE_
X-MS-Office365-Filtering-Correlation-Id: a09b4f79-57f3-473e-8712-08def1931bed
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|7416014|56012099006|10067099003|11063799006|4143699003|6133799003|22082099003|55112099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vI0hziprTcEhuPz1hK5Jy+dFwecDMLKLDjFjPUCart0QN8dI966mNLj0Xvqyd5U+pnnqFAD3kgI5p3FkKsBLJj3Kg/QzhFITUBwbrILnrelJFh4d8SPRTfP4nqxXoC+PXqAWlQZjeNIb5niF0MqxyDbTvzgby7lhok6LfmnXp1rvp6CHiGrTlDnPHiz4JAzJqFhGQjtcZSOhTL4Vlb9J2C8nagoBNx125/XkqpB7QI9/FgOWayjXS+DmZSXtPg7/nRJAx9CDxxw8VDor0foszmO9omdB6UlnRPhr295ylYFSCupxUpDk+D+aG3AL75r9UC+cfck4eRlCRxH+Z9fTVbsIxivY4aoj/QIe2otJYpKj2gPjBKO6jTyLvfDHDuf286+csnAKFSco0rmG3IJUFVkewuikR7YPSg5MWkx6AWP/BmltT1cyBR0F/Og8g1ry4MSLSfoRv0KIEsFnWtsrAz/pmCc6Oh9RT9oN7hOSSJz4Ov9Jh8w3uWnCodcAeyp9qJHyJDGCpkwMxHJknzFZuXfRvGUu/EnoVvizT9D2TnWCfoRF3GWsvGJT8iweo1Gp9S7ujOOROY/JgtZbdIO8zbow5c02mXeM/DqsHsIekop4twYh5+g75erpXTqp2DBmA0FvYGq8znZY9G6BjdPDIv2m3+23HL0z7OB5E+qWNC0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(7416014)(56012099006)(10067099003)(11063799006)(4143699003)(6133799003)(22082099003)(55112099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WmFWWm1FRDlSVUtuNytsQXo5ZzZuYWQySm9rOTF5ZXhHWmdrRW00VHBNZm5s?=
 =?utf-8?B?bldtaGFLdVEyblFBWENqMzZjcDloVFRUME1HNUdKN2FlN0R4U0RiQ1BiaU9E?=
 =?utf-8?B?TzU1N0lGMUUrV0xwVW5DMWhPMWh1U21wdFhncXZ4T3lDQ1YvUGYwVmZRVmk4?=
 =?utf-8?B?UnhTQkRHWjEvOFNHd1hnRVJ3NGlkT2dSZjh0N1RCTmtqQzZRdGhXQzZpN0Nt?=
 =?utf-8?B?VWVTMXBaendIR01reGhMYjQ3emc3SFF4eHJ1SExpcURTeGt3anhvNk5hSWRu?=
 =?utf-8?B?S3N1TjBRa1RSMVpKcDZXbzg3TEphZWhiV2JxTHJWamgxTmJhRWhmK3Y4NUI5?=
 =?utf-8?B?MUd0RjVtR2tIbDQya3AxOHlvMWIrbVB6YUNhbk5OaTF6STlhZHJzSFp5a1pz?=
 =?utf-8?B?Z3JDQTJoNmJwY2VzWWdBU3hXT05CY2hLUnpQNEs2emw2MG1qeUo2UG1TOHFs?=
 =?utf-8?B?M011VGJBclU0UUhvbkRURGo3c3Q4QlB2Z1J2UXNPRkV6U3pwS2RtMjN3Mjgw?=
 =?utf-8?B?TWh6dGc3b2NiWDFVZTg4L1dpOUQ4cHpBTjJZZjNVVnFrb0doOVd3NXdYMGsz?=
 =?utf-8?B?WnB4K2tmdVdhTXlTUU9SblF6aFgrUHlBZDQ1MWJKVlNNWVJjZlRuakVycVhZ?=
 =?utf-8?B?RVc1TytOa3hKczh4QmVyQ1BZQjNkdW9uN3o4ckV6eERIL3pBSmVxd3NDczUy?=
 =?utf-8?B?SGg2aUtWcndTMCtzUS9XN0JoaitEeHd0RzVwakZnQ2h3Z1dkeVRsckQwRjJj?=
 =?utf-8?B?K1ZEMklpR0Vtd0ZzWHpLVDgwQnkvZUpWREw1clJYN2lDcWNsNXh0TldZcW82?=
 =?utf-8?B?TC8zTFErSWcxMzdRYVFnZFVvOVV4WFJYcURnN0NXbTV3U1pEcWZicTlZbzZY?=
 =?utf-8?B?NUlrT1FHUFBJYmUwM3d0dXFsVFFpeHF3Tmx2bmp1WDV6dEEvU3VCWUwwb1Vu?=
 =?utf-8?B?cnM5dmtSOThnWXRCRXV5SW81TVA3YWl0Mk1qLzJuNGUxUTJlU0ZpMUFSUGRk?=
 =?utf-8?B?c2E2L0hLK20rcVV6MzlBRmdFVDhIUkcwMXpTK3IvYXBNZC9uU1cwK21yTDJ0?=
 =?utf-8?B?YjhVQmc5Mk9GaVdBNWVQT1NnZHQvTHJFRkF6VFgvT0hhRUUraGRWNVUwM21Z?=
 =?utf-8?B?NjhLZTdIMzRBcmMrU1FvYUs0ZGZpaWJxR3M0ZThVMnIrNnQwWU4vaVNTTXlH?=
 =?utf-8?B?Q201OTc3bUpMSDNXRFpNeG5zLzR5T2NqV1RvaTUvTGhyVlZkMFdqZEdKR1hG?=
 =?utf-8?B?aERySmVneVdiZzVWeDRCL0Q1L2l1bnZ5UUM4OHRYUGJjWi9rRldIdlRETUhp?=
 =?utf-8?B?NDh3V25CN3ZtMlM1S3BYTUZhT2VUc1pTTXJkSklnWDk3Zm5EZmJWZldMbnhh?=
 =?utf-8?B?WkVuR2ZlY3JJaE5idnFZM1hQM2lENUV5RTZxbkh4MXI1bW81ay95YUZ6TDhY?=
 =?utf-8?B?SHpMaXcyRGFySVBXTHZQaFRqVFhOVElhRDhXdXZZS09TajVBQlpHWFl5VnZu?=
 =?utf-8?B?SGJNaGtSd29saVMvYnhCWGd2NXI0TEpyTy9EV1BSQmxZTHVza2ZLZ1NsS1JU?=
 =?utf-8?B?RFBPTHV6ZkdodkgvV2dVbmFBQ2lBcG40Ym53eGh0cGVQY1p3M0xVYU9URFRx?=
 =?utf-8?B?VDZmNG5GclFmRW9aK0FtSyt3L051aCtIRzhmdlNoSEJPdzV0cTd2emhWZE9u?=
 =?utf-8?B?QjZBYUhoYktZMUNRT28wMXVoNEMveE5yQ0I1amF4ajcwM0R1c0xrc3lFdzBE?=
 =?utf-8?B?dnZxUzRtZVJNUDhrQ2pxSlNyb29Jc2ZFb3BhZjk1T1F3WUorTng1V05lYmlZ?=
 =?utf-8?B?d2pXZlVyeUtRUzJhbHFXYWJGOXNodUpNMDVwdStKZXpiZnA5cE8rZTdkaUtO?=
 =?utf-8?B?OVpicDVWYm13c2U0SkJReGUzbWFGKytaY1p6cDFKTjJPZ1hpdnhENGR4ejdl?=
 =?utf-8?B?bUVCdkNsMjNMalJQekRqL3lyUkZEMEVtZ1hVc05SeXM1TkNLeHFXV1hEKytm?=
 =?utf-8?B?WGVYTXBiQVphN3FZRnBYY0MvTm5BZTVqUmsrbnZ0ejJKdlYrSVMyR2owZ2Rn?=
 =?utf-8?B?dEh0cGhkYTczSHA5dXp0VTM4OUVuMWdCNWtvTkZNVHhlYnhYY1ZmeXFEQmh0?=
 =?utf-8?B?cVFTYVhZSENDM1RkSGdQMzFKSVIxRHk1UXgzVENFRHYwbGs5KzdDQUQ4NURX?=
 =?utf-8?B?dXkwUUw3WFB3VFoyNkJiRkhtNk5jUDFGS1E4MW9wTy9yekEyK29pdnpoaW5I?=
 =?utf-8?B?TnFuK1hYTmk1RkpaNHk2Q3NaL0ZMdHVGSkV6Smx3TldUWlFOMEpLSGZYajJu?=
 =?utf-8?B?dkdqU2laWUJjbERTS3hpaUkzNzRvbFdDTnJuL1NwWUtzOG0xVTg4QmhZeHJB?=
 =?utf-8?Q?Xm6cpQJNybqM3NmE=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a09b4f79-57f3-473e-8712-08def1931bed
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 19:12:06.6555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4AKvl1XWoNHm90pIA4iBqI+322keMmEqGMva1X0PD0CNoPehDejz2gVkoZXEAvFHNz9b94uqgOxulY0aHdzNgIzQXfthI6Sg3gHJ31K2vw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EA2PR01MB994459
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E2874180006
X-Stat-Signature: g4u9j1ecszhjh3msfqfi73bs5imwbggx
X-HE-Tag: 1785784330-685967
X-HE-Meta: U2FsdGVkX1/MRYqfOo+bukgqsqMa2RApbq79dUJROngg6jm6F/312X5o+SuHVJjGVdD/8TRHN0FpT4Ma2Rb8NI1p+kWqUTDdO76vOvuJENkI21HIIxf4J2KC+q0FUSXZa+voldKNMCdRtycukzOin1D70W34LTl4MxWOCDu/OiiFGGoy0S5lv4BrnFegj7CbzBKm3qcM87TMPkdwV5f1aY82PFAP4VzyZhGUru1viKrhl+zW+qit8MjTqgIx+iiP+cPkVTl1sofZiXxW+c/foPYoxLx5r27g+zUr8GFX+1GYJOpG8uGI+PZNtEnlHpn+aw6DWWlW/wSkAmac66nQKVuN3QS/Wgy+1SXMXiD8cMS9YQpgHWhpDf0O0s5pERWSAiC9K5XTuMavfoxrIqKx/iKSw+KliubyWjuC/l/hHPbe+Gt8uGFw722Kda1nF9BxL4jV1SZqr8CKw6/N4wBrtrNrDB1i/Pj3iI/M+NQMQHjgwHbZqg3t7wRRxZmmd/Tywjf8Jmn8em37XIzF98tTnMiuSQnoW1FhkJq+8FNiwSc+SiNHGu83lbye2J7qYEtFZdcEhb3W4JwC7uUP8dNlIKLi/hJ6sVkxh1AUBC1hhtjXKTaoa6CkHRqLIgUkKFjYPzf8d61tiWjPRibHoN7IDSwW8pGNFu/iLvvB4ItaBWQBRrILy+M8ky0gWx7Q2z3QfpeK6llJiyvgR5M4+imIDeCT65KFhw5xPMnsvQxIzLcVik+LY5IBqkVeNtzWg7W1sWq2d2AGq0q8vOppSZ+ffG541XFrhakOH2TVH5lXu0QqwZE2NQjgRBMMlhntMNXEa6T1yhU6QXd9GI2hs7R0TUQnRVB+L7RcA6ZRAUDbhAdJj1tx9kSalYja7kv1J/tOeZfYBnoJtjtqvBuZTq8KvmSRgh9hsZElycCcl/qz9gxKzh16pP+9FeSsSNxsJj2pvIkfwB9fL9PzpfQB1Ws
 H/kGqP8k
 BeZPl1jY90A3lh9kc8gq4VMmbmCWiOK+eVltVvHewfafU1WXZQRlix6taPx8w02+VAnw+UI9MvfALdem4/7N4M9xm7zp+EViNEng3zdmyQ+2RNUVvDyl6fqz7KkZBWFcnmmVXu9oECqr4RyW5UnNvgjVYOpEzArOPiquYIqUOEDrBRH9MEept9tzq0YwLfn2WtLqHh2XSWh6ZFSiV4IBQKYOMK3w0uD3OUrIoeMCTIuAWz2GxfxUcV63c+KanM99mf/q+JhzkI6JtcPo3FwMABmIhy5LKbp8MY/GSgzaEglx04lhI2c7XhK+NJwaNky8gQ5Kmcrkk6MV35nfdbgOUNNfVwUNBCb2Zxq4tsSTXaLUlCEwLi29Zah2cC8fdWwkldVesA3kbq0sytauTkwzvqBTkSdRf1E0JM+pn7I44o3rPnaYBeSOCwxS97j78GT2j7rAYJ4/tabsfsqDOsOn2PUyfH8xAKLEdVY7/fwfjpkGy9LELE9cOKswlq4dmavz+WV0L3ZPmNZ8EISLwzfIHBJ4DSf9+AbzHcu8PhhNMO6HbfLR+Ltias08ChmFti6xGMdeGECFzZ43XWtMovcXcZpETZSDEsWeDtGKx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/29/26 2:32 AM, Lorenzo Stoakes (ARM) wrote:
> On Wed, Jul 15, 2026 at 11:04:06AM -0700, Yang Shi wrote:
>> vmap{__vunmap}_range_noflush() assume manipulate init_mm pgd.  The
> It's not an assumption, it's a requirement.
>
> There is now (and really should have always been) strictly a locking requirement
> that the mm being manipulated is init_mm.
>
>> following patch will map percpu local mapping into percpu page table by
>> calling them, so the assumption will no longer stand.  Make them take
>> pgd pointer as an parameter.
> No, this isn't OK.
>
> vmalloc is expressly for manipulating kernel mappings in init_mm.

This commit message may be a little bit misleading. vmalloc still 
manipulates init_mm all the time. The percpu allocator uses some vmalloc 
APIs to map memory. So the APIs used by percpu allocator needs to 
manipulate percpu page table when mapping memory for the new percpu area 
added by the following patches. So percpu pgd is just used when mapping 
the specific percpu area by percpu allocator.

>
>> Also make vmap_range_noflush() non static, it will be called outside
>> vmalloc in the following patch.
> Hmm not loving the exposure of an internal function ehre.

The RFC reused and extended the vmalloc APIs. We don't have to do so if 
it is not preferred. I think I can create some percpu allocator specific 
APIs to manipulate percpu area mapping with percpu pgd.

>
>> There is no functional change.
>>
>> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
> You're fundamentally changing something here, conceptually. I'm not sure why you
> specifically need vmalloc to do it but it doesn't strike me as worthwhile for
> what you're doing.

The percpu allocator uses vmalloc APIs to map percpu variables 
currently. So the patch extended it to take pgd pointer as an extra 
parameter. This helped to reduce duplicate code. I can add percpu 
specific APIs if extending the APIs doesn't make too much sense.

Thanks,
Yang

>
>> ---
>>   mm/internal.h    |  5 ++++-
>>   mm/kmsan/hooks.c | 14 +++++++-------
>>   mm/vmalloc.c     | 25 +++++++++++++------------
>>   3 files changed, 24 insertions(+), 20 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 181e79f1d6a2..9d9f08cb26a1 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1552,10 +1552,13 @@ void clear_vm_uninitialized_flag(struct vm_struct *vm);
>>   int __must_check __vmap_pages_range_noflush(unsigned long addr,
>>   			       unsigned long end, pgprot_t prot,
>>   			       struct page **pages, unsigned int page_shift);
>> +int __must_check vmap_range_noflush(pgd_t *pgdir, unsigned long addr,
>> +			unsigned long end, phys_addr_t phys_addr,
>> +			pgprot_t prot, unsigned int max_page_shift);
>>
>>   void vunmap_range_noflush(unsigned long start, unsigned long end);
>>
>> -void __vunmap_range_noflush(unsigned long start, unsigned long end);
>> +void __vunmap_range_noflush(pgd_t *pgdir, unsigned long start, unsigned long end);
>>
>>   static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
>>   {
>> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
>> index 8f22d1f22981..e2a0faf344b9 100644
>> --- a/mm/kmsan/hooks.c
>> +++ b/mm/kmsan/hooks.c
>> @@ -135,8 +135,8 @@ static unsigned long vmalloc_origin(unsigned long addr)
>>
>>   void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
>>   {
>> -	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
>> -	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
>> +	__vunmap_range_noflush(init_mm.pgd, vmalloc_shadow(start), vmalloc_shadow(end));
>> +	__vunmap_range_noflush(init_mm.pgd, vmalloc_origin(start), vmalloc_origin(end));
>>   	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
>>   	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
>>   }
>> @@ -181,7 +181,7 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
>>   			vmalloc_origin(start + off + PAGE_SIZE), prot, &origin,
>>   			PAGE_SHIFT);
>>   		if (mapped) {
>> -			__vunmap_range_noflush(
>> +			__vunmap_range_noflush(init_mm.pgd,
>>   				vmalloc_shadow(start + off),
>>   				vmalloc_shadow(start + off + PAGE_SIZE));
>>   			err = mapped;
>> @@ -203,10 +203,10 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
>>   			__free_pages(shadow, 1);
>>   		if (origin)
>>   			__free_pages(origin, 1);
>> -		__vunmap_range_noflush(
>> +		__vunmap_range_noflush(init_mm.pgd,
>>   			vmalloc_shadow(start),
>>   			vmalloc_shadow(start + clean * PAGE_SIZE));
>> -		__vunmap_range_noflush(
>> +		__vunmap_range_noflush(init_mm.pgd,
>>   			vmalloc_origin(start),
>>   			vmalloc_origin(start + clean * PAGE_SIZE));
>>   	}
>> @@ -233,8 +233,8 @@ void kmsan_iounmap_page_range(unsigned long start, unsigned long end)
>>   	     i++, v_shadow += PAGE_SIZE, v_origin += PAGE_SIZE) {
>>   		shadow = kmsan_vmalloc_to_page_or_null((void *)v_shadow);
>>   		origin = kmsan_vmalloc_to_page_or_null((void *)v_origin);
>> -		__vunmap_range_noflush(v_shadow, vmalloc_shadow(end));
>> -		__vunmap_range_noflush(v_origin, vmalloc_origin(end));
>> +		__vunmap_range_noflush(init_mm.pgd, v_shadow, vmalloc_shadow(end));
>> +		__vunmap_range_noflush(init_mm.pgd, v_origin, vmalloc_origin(end));
>>   		if (shadow)
>>   			__free_pages(shadow, 1);
>>   		if (origin)
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 1afca3568b9b..17c26e9796b2 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -295,9 +295,9 @@ static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>>   	return err;
>>   }
>>
>> -static int vmap_range_noflush(unsigned long addr, unsigned long end,
>> -			phys_addr_t phys_addr, pgprot_t prot,
>> -			unsigned int max_page_shift)
>> +int vmap_range_noflush(pgd_t *pgdir, unsigned long addr, unsigned long end,
>> +		       phys_addr_t phys_addr, pgprot_t prot,
>> +		       unsigned int max_page_shift)
>>   {
>>   	pgd_t *pgd;
>>   	unsigned long start;
>> @@ -314,7 +314,7 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
>>   	BUG_ON(addr >= end);
>>
>>   	start = addr;
>> -	pgd = pgd_offset_k(addr);
>> +	pgd = pgd_offset_pgd(pgdir, addr);
>>   	do {
>>   		next = pgd_addr_end(addr, end);
>>   		err = vmap_p4d_range(pgd, addr, next, phys_addr, prot,
>> @@ -334,8 +334,8 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>>   {
>>   	int err;
>>
>> -	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
>> -				 ioremap_max_page_shift);
>> +	err = vmap_range_noflush(init_mm.pgd, addr, end, phys_addr,
>> +				 pgprot_nx(prot), ioremap_max_page_shift);
>>   	flush_cache_vmap(addr, end);
>>   	if (!err)
>>   		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>> @@ -478,7 +478,7 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>>    *
>>    * This is an internal function only. Do not use outside mm/.
>>    */
>> -void __vunmap_range_noflush(unsigned long start, unsigned long end)
>> +void __vunmap_range_noflush(pgd_t *pgdir, unsigned long start, unsigned long end)
>>   {
>>   	unsigned long next;
>>   	pgd_t *pgd;
>> @@ -486,7 +486,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
>>   	pgtbl_mod_mask mask = 0;
>>
>>   	BUG_ON(addr >= end);
>> -	pgd = pgd_offset_k(addr);
>> +	pgd = pgd_offset_pgd(pgdir, addr);
>>   	do {
>>   		next = pgd_addr_end(addr, end);
>>   		if (pgd_bad(*pgd))
>> @@ -503,7 +503,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
>>   void vunmap_range_noflush(unsigned long start, unsigned long end)
>>   {
>>   	kmsan_vunmap_range_noflush(start, end);
>> -	__vunmap_range_noflush(start, end);
>> +	__vunmap_range_noflush(init_mm.pgd, start, end);
>>   }
>>
>>   /**
>> @@ -670,9 +670,10 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>   	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>>   		int err;
>>
>> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>> -					page_to_phys(pages[i]), prot,
>> -					page_shift);
>> +		err = vmap_range_noflush(init_mm.pgd, addr,
>> +					 addr + (1UL << page_shift),
>> +					 page_to_phys(pages[i]), prot,
>> +					 page_shift);
>>   		if (err)
>>   			return err;
>>
>> --
>> 2.47.0
>>
>>
>>
> Cheers, Lorenzo


