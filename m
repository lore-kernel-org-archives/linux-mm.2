Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFFE5CA6004
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 02:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7A46B0092; Wed,  7 Oct 2026 22:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761226B0093; Wed,  7 Oct 2026 22:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C056B0095; Wed,  7 Oct 2026 22:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 380756B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:54:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6974C0437
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:54:07 +0000 (UTC)
X-FDA: 85297939734.06.3B871B1
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013016.outbound.protection.outlook.com [40.93.196.16])
	by imf18.hostedemail.com (Postfix) with ESMTP id DD9AB1C0006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:54:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ALMFSoGc;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791428045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FDTa1dQSyDy8gclWJ2+emGjodjx64wgFrlLW/ZPbKGM=;
	b=TX4vRd8j8TJjxiLga5oX2HwL87s0wlaasbzuHjVc3Qk5ImysQ1VjNvGLsaiW1PM1WcxyZf
	+td6TBnWeIVOv+lh8yaXC7lxLK1KlhwzAIdbViSjKN+fRBTOCGl74tjN/no56ldkJ6cVrn
	5QJ4A0CGIhtDxPrN2BqipEK07KL3viA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ALMFSoGc;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791428045;
	b=l14mJ5w1ww+EuhGONKXkcq+gAs9qhNXh6SWMW/bNiSIwtmkOZO8sFWrEae2jI5wzuT9qoh
	jD2jG5FYKjnj1Z0J6X/mtrGxImDqc1RNqmMM5T6j+wt/yIRv5lJAfA5eM8PhBR1zoi6/dZ
	57QJ+AC8b/fKv2jg13UUzzsAoF9cRlo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hcw4qG77U3P09ShFVJ0rvMGq2uzbwHneKteV/a42mHukGIXsBjaWKV+Egzaa3pYPLbrf1QXToOf8ZgeGCZbw6F21c1ubs4byGWk0cep4LkI/H9/frL0AKoKx+It2Aogw+8JX3tKLlYMf7rtrrpvFUUV66ybwLXyEOt/SfQKudGdUcckate3++0/64VyejaKhPgfwKIPZ0fwQYTbQ+VfnRuZoumlWq+pROHTieDK+ZXQ3zKtVxydfA0qVvOpWPLNoms1KH9Iq3mmK82TMWIw82jph08st5oOqtMqea5J029hlgXTKk9z61KYAXYgnKsoYeLksctL4aQLm3BPBJrCoiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDTa1dQSyDy8gclWJ2+emGjodjx64wgFrlLW/ZPbKGM=;
 b=t3dctr8WBeYjW6mxr8RCsk7SzxeGZiyrCnfNuvz9qgBKXybNbjzsyOURq9/1csBh9K4GmSrULHp9Ytde5Dl5pJRT13NvFNj+QFX5FpPSfsFifw2aXUrtvJYNt/pU6ky1DWtvANaLjPFOYyEMNXvLzNy2kJYvNwKEL2MGtTELT462uOaWUGskUqVMgCeSutvUV9mRQHn2pFHdKevXfurw2VleMDY5NYJoZbfawDNMVeHdtmIlZt5y9MP/evJMoVkJ1/vJtitKmkERGdzjQ9nucyk97VrKvPLD2LKK3626xUPPOWjhFh9j9fF2WwlbRAEx5p1QO+0CPxc9jYo/m7m1yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FDTa1dQSyDy8gclWJ2+emGjodjx64wgFrlLW/ZPbKGM=;
 b=ALMFSoGcOxfX3Ayv1i+poSYw348DJMn4+2vlIWcVPs/qR4f8Oar1y2cyZJrohuJfcYQmG2ibTKgoZ/qtCplujo9s1Jr3QIpmWhWxPYM0VbHmjDLNBerhxfS2etIEA5VXD5EddYz9cyf45Qrz/jwINXlaba2CDYdC4pdYdixcnPC64RyYAiVi/o7jJPBNWBSAcWu75L0GLFco70NrdjZEfxefYiyU2Xjl5V5JIAR5omRnTS3fpzFwgFOsve4zdoH1oylBPoXjVHAw1Zg+rGxJf1siCm2QWOY6SXGgi0zEsyDJPHhv+1/CZkAK4HOwYNV0f/JATwBN56y8GzgEOH+RFA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL3PR12MB6644.namprd12.prod.outlook.com (2603:10b6:208:3b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Thu, 8 Oct
 2026 02:53:53 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 02:53:53 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 Oct 2026 22:53:51 -0400
Message-Id: <DLZ48KMS7YG8.3BTM0UUU8CTU2@nvidia.com>
Cc: <ying.huang@linux.alibaba.com>, "Baoquan He" <baoquan.he@linux.dev>,
 <willy@infradead.org>, <youngjun.park@lge.com>, <hannes@cmpxchg.org>,
 <riel@surriel.com>, <shakeel.butt@linux.dev>, <alex@ghiti.fr>,
 <kas@kernel.org>, <baohua@kernel.org>, <dev.jain@arm.com>,
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Liam
 R.Howlett" <liam@infradead.org>, <ryan.roberts@arm.com>, "Vlastimil Babka"
 <vbabka@kernel.org>, <lance.yang@linux.dev>,
 <linux-kernel@vger.kernel.org>, <nphamcs@gmail.com>,
 <shikemeng@huaweicloud.com>, <yosry@kernel.org>, <qi.zheng@linux.dev>,
 <luizcap@redhat.com>, <kernel-team@meta.com>
To: "Usama Arif" <usama.arif@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, <david@kernel.org>, <chrisl@kernel.org>,
 <kasong@tencent.com>, <ljs@kernel.org>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v8 10/30] mm: make PMD migration-entry splitting
 explicit
X-Mailer: aerc 0.22.0
References: <20261002095503.3585565-1-usama.arif@linux.dev>
 <20261002095503.3585565-11-usama.arif@linux.dev>
In-Reply-To: <20261002095503.3585565-11-usama.arif@linux.dev>
X-ClientProxiedBy: BN9PR03CA0194.namprd03.prod.outlook.com
 (2603:10b6:408:f9::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL3PR12MB6644:EE_
X-MS-Office365-Filtering-Correlation-Id: 6897ba90-8e22-4694-d337-08df24e76353
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|4143699003|5023799004|11063799006|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	5VGW4pAyNkm7LAHIFKWizr+JPrvyf7A2AOHOp4IQe1xT6C3a1N4ivw1i3mUVdzXcmh0O2hI9WDUqC9lcy8tlhp4nzDEE0ebnBHnFBVmGTDZfa+PGEAwsI9fkB5YBju2VKcE6cT+wkbsX0g7pm44ogZjdZJNh3XoH4ttIHycRchHFuuc53Emwqfd+r58hsM0AJ6+D6Gxbrp2tcSnl5T0ZufHMg9kNmsYt282HzUkX1l3XPNCydnS9mvcZXfuPkrNOoNOusw8fdHOj7HwvA1cUzoGjsVCYtyLjqWGQschtWrvHbh6Y+nO9IRxikYfod50r88r5qJ8gm7qYPke99Nnyf1hrSoCUcJ5G1ONcpUE3GOROM9LICMqsKVVpVfYLShdFefP99Fu8Tb84WKIC2OqnI/eXXECcVuTOp2tg+YK6EABM6vjEhSbjuEoCawzKkrXlXkpQ6Lskm0W1FGUqq1IoqM/XdRX5o0nULDI3fITwyO2TAoOLeTJyYxijz51UzymkDkLzdLtYVttQ7YOzOOg4CaZN0oGCg3HLQfBKi4oDq1iOtrUOwQ182HkKogq7Ksy5NwoDgo01it6F3FzR0AgePKVWpTe5Qc0HXYvJlKZ/iJMDwM8ygoNOiSHN/3HeKbv+ZjFgB3ijA2IIn65niz2cMPRLPRjRQbb6ViT7EL96Avs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(4143699003)(5023799004)(11063799006)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1JzdmJwVnpJb3JWaW5odmJiSWN1bExsNlBrZkU1dFdtZUF5UEw1Y0tqY0xk?=
 =?utf-8?B?KzVDOUZwcmM0MFdJVGVHcXlaYjRQL1FJb1IyaVFlSjUzV2w3a3ZwbnlpUThM?=
 =?utf-8?B?VjRlUTZ5QjBPelhyWDZSZTB2di9RbENUTVZzZU9URjhoYW9WZkQzYzg0TVdm?=
 =?utf-8?B?RUFyVE80eTVpbEQzdE5xaTQzNWJwa0ZmNUYrUlc4ck4zYW8wMlE3dDlyZG1O?=
 =?utf-8?B?RGdGWjJIVngwNUIwbElLcEcrNEFQcFg2MGxnRnBtMnRFUEZMMTBNZlJiMDI0?=
 =?utf-8?B?VTg5cHVaM3l3N3hGUUJndldSZ2czK1hvdW5FR0tFWkxvZ1pJY2xhZkEydDJy?=
 =?utf-8?B?L0IrcVJzRWlTK056UWx3dFVuTDJiUXAycGppMDdYTUFzOHpEaU80cmU3UE9Q?=
 =?utf-8?B?Y25GVVF4UXo3dVp5aHdNaWtCbzkzMjJQVTJmZWlFNjdtRHEyekZmWEVmd013?=
 =?utf-8?B?WWxPSFE4TGNJNnBVT2ZmdzVXYVJ0SVFNbHl6QkdjbHUvblVVOVJ1bVJ6ZVJU?=
 =?utf-8?B?SWp6aWVZSm9nUnh3U3NpK3dBaUwzOTlWbkJUaXBCZjhKY29KTm1ESzllRHdv?=
 =?utf-8?B?ZVhjbG01TVhES2JIa3BiRjJyWlI0STVhWVFYNEZ0OWhYdkt4NDNHYWNBWUQ1?=
 =?utf-8?B?Mkh3czNNb3lhaEJ6SHp6TnJpNmJRV2JPNU9pNzZ3cktSSGppdzdHZVZ3eWpB?=
 =?utf-8?B?SEdQeFErMlJtZ2huK3psRkNBYVpjQVRqWTNkbnEwNTRDVU41aWhETzRlc05r?=
 =?utf-8?B?R0VFc3l4SnFCMkxrYkFqREZBelpHV1pOSjR4ZVdVZVRPK3cwRzBIQmRaeFV4?=
 =?utf-8?B?WVNLSnNvZG9NOWk3V2pkVkNpNG9VVDZhUmRscHJDQkNmenVFeWI1RUNYTG5O?=
 =?utf-8?B?cVl6TW9KUVBHQS9sdFVsZmVtMytPYjRabkdOdEdjQlVoSm1WOENOTzNyZlV1?=
 =?utf-8?B?cEJhZmJGc1hqRkVrenRXdVVNMm9FUFIyV1FkME5xNjIvVGJPZyt1SVpNRkw5?=
 =?utf-8?B?bUpQZ29tSGYvdkVtMmg0M1dyYWpXYXUwZXpIT0tqRkZkVXV0ZmkyQXN2RCt6?=
 =?utf-8?B?N3pna0JWQm9rK2lrN0tDSHpnM2w2R01FVWVnTzVFU2JNejRXL3dMSE9nZXB6?=
 =?utf-8?B?SjBKQVZZOWU0eWdnSGZFSGF3dHlSaS8yVjNOc29LZEsxd0hwRkxIQ2I0WWVr?=
 =?utf-8?B?MllVYzExSDhRekxmbjRRb1ovVEwvZGZZOG15cnYvaGpYN2VOVm83QlZwR3By?=
 =?utf-8?B?UkZHY3krZUVrc1NmUG92ems2ZnRkQjB4TUo4RC82ejZETU50VnJxUUpGeUJG?=
 =?utf-8?B?Z1Nuc2MvTHBDQmtTa2YvZmtsaC9OTkhzOC85MUIxdG5LVEJlRjlSM0lmeDJZ?=
 =?utf-8?B?TE1wR040Qmtld2F6azFRbEZTWmpBZ1BVZS8vZ0FrOWtUUDZPRnZBcDJBdER2?=
 =?utf-8?B?eGNYTTl0NXdvWDV1SllXTW80R3B0L1grVlV6V084TnFiWldudDVqOEZYMnRM?=
 =?utf-8?B?dGE3R0kra01pZkdpak1PY1A4bnRZcmVHVmovRno4MG5nZGZtV2dtZ0hqekND?=
 =?utf-8?B?STRVV3JvRFdQeE5Felo1KzBwam9xNTRVemlSb3greURPY1RnNnJLMmd2RVRm?=
 =?utf-8?B?UjhrUWtOTSt4b1JEYzdXSHIrTlBnazliUURoY0JBYm8zbVoyUHYvSUlISEx2?=
 =?utf-8?B?d2FWa0Q0U0pEblJHejJTMW5CSlFSdEt4UnR1Mis4RlBJU0FZdW1kcndSWlBZ?=
 =?utf-8?B?UGhGUlNoeWNYU3Uzekl1WFF4UzR2MG1HWVJFYS9udk42WFExa1hHdGkyTnh4?=
 =?utf-8?B?dmVPRUdQbXBFaVN5MzNkZGVrRjlvaEdiKzJabk0vcHN3QkZrMjRvNXFqb0h2?=
 =?utf-8?B?QkNPVFZpNDNnbjZZY1g4UGUxNFJuYk1Kbmt1YWlXY3R5bmtHQjdrb1VGbVBO?=
 =?utf-8?B?dkNxOFFOUWJBNGw3MUdsdVA1OWFzNGVJNFlFTWdpOStqaFRWK0FpRHZpd2w0?=
 =?utf-8?B?dEZQYU9iNUk1VFJZNmlscjcrTDdnNXhiTnJkZzNnVUZHeWcxTkxYUkdLcm0z?=
 =?utf-8?B?MlFjQ2prODdKK04zaDYzS2JtK21sd3pVYys5cmdoNVk4VjFabm85NGRZRjdX?=
 =?utf-8?B?V3kyeXF4VUJId0lpYnA3TVVvdFVkL01FV1pxNUJaWlZ5RUk1ZCsvY3RVOUxN?=
 =?utf-8?B?cFE3WGRCZk10ZStwSGFaQyszSldNOThBekRNNGo1dmJJaXRxSTdkOCtHTzhU?=
 =?utf-8?B?WUkweXNkU0ZJTU5ta2gyV09kQXpCNVFrZWJDN0NSUXB6L0xGSzRNL0NHRzVt?=
 =?utf-8?Q?f6SDHyke/jrXCUFGEV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6897ba90-8e22-4694-d337-08df24e76353
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 02:53:53.3880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DUIR7MZmPdM5Vw8WLd6rN+6AB2Rz1S0uucL1Tj0Ay7AuETTHwn/gHOzJF3kDXBUe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6644
X-Stat-Signature: iar41s6soeo8xqm4qui9gm7bkj65b4kq
X-Rspam-User: 
X-Rspamd-Queue-Id: DD9AB1C0006
X-Rspamd-Server: rspam08
X-HE-Tag: 1791428044-174413
X-HE-Meta: U2FsdGVkX19VB84k4UXN9JpO8nUC2SIs4CkIOVBEYS9gpu9ssPmnDcrtSYoCE/jtlMDbBQMJjq9zySLLuJYZljPnYhACqlOdVHmUor+sJv0AxDPhscMf2cIbYzz08SPs/jYKVWYPG5/UpEpGyu/99i18p5YIwhQmv8HjH5KubYO4A/80ZgjcVF7HKS1wrBWE5c5FFbt8JwSVpZxXci77Z8NbTccv3DD2qGrpAH7XiCM0lASVCE4Rt1XoBl7QwSCs2NnyH9vpi8gRVoM5ub3xD0fHTKCa2GzdCT3IDOK8DTBqZtJAWNEDBEXW6jk4MTqZ1Q0CYKOcgscbavBeYlHO2uGH/xRP7BrGFG5/9FOTJCJNR3jQgIZrNoY9nUx5ZG7zxPmBSHDPehzot4KMgmMd0wKSaRUGIh/awHjIltrql9DU+WFyrwhWKXp4ZN57qKEQ3qWa41WS192cJ4K2wTEo27NNsITI4fS6QZJrGtQx8vvK9Cikq9usYw5NqNuGMTUMJu8vGBwpzmYkb0llgg3AQMs6eJ1HvVmR1cnKMhJ3G0ErueJsJqu6iIDmDkFtXx1ZKaGT47H+Vu1JOWtQrpbnN4G77u7UPJ+PPzNdG2L2nk9y1YeJf1h+goeCw/HgORXxFzrTZrbnuy/Sb3p96pKvwl/1IFTLSuVFoVs6lY0K2pZ3D3DqZUESvSd0uvBJLfnLmf9ro+ovFqQ02fM9USYUcBvfDuCbE7/S3j8V9pR5S9rNyJJVpEHf6Stj/EgteSal/jkwdjEdrykFo6f7MSfjZYeX/+FiyiNssEswnrWN8Io5zW1A9acq+aknfiZt+KB4XORqzraBWJjJltaS1xTEGYMJFgpVSYsJolx7YzZnD1H+7dMlGWUsGzQOwh9C6KceFHxmuT5cv1X+UFLjgY9iyzyAvu/Rh3UqwCoaDiKTnwLIxPF9LBBiUYaMeV6pOjtor3pNUU/uOzPiGOh9ij3
 YF4wjEJN
 dNackvDThaH7H+8xp0KDo1FX0DCOPyDq6OoJDCkjrEcBI4BTHVWadAeZ22yZmvwd3vKcFsjQyzPebpPIkaDInIQIm1MHE39ijVW88VH1LyUUVxtwj1ZWBwT+Q15meuBYkyRAWfxKg4kMh2imMIOPhKacClLxptnHt4nFjl7moyy/m8mOxrSCYN0i9gIWCtiCz8FNGYkkRlERFxSqmFoNcNicczpchUkLIcukkZHYSMow2lWCf5pa09R0RfGIxCfIBKtYhGPVOC9Ei3r0HeHDf5Pe2IAUJIkmGRu8Kzb7H7IK55MnpOKRtXh8q4/w4z8oUWo2V2iGdO/muCK13GCUJxohniHcKMXeEab0FkoQ1WUglpNqrtV9/JQswBLEc9vcQGqArwHf1vUPC2s1FlICFaRkjfsVUWKpkFDO3nQDgvSHBxlU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Oct 2, 2026 at 5:52 AM EDT, Usama Arif wrote:
> __split_huge_pmd() and friends take a "freeze" boolean that every caller
> has to pass and almost every caller passes as false. The name says nothin=
g
> about what it selects, and the one thing it does select - PTE migration
> entries instead of PTE mappings - is only ever wanted by the rmap migrati=
on
> path.
>
> Rename it to to_migration_entries, keep it private to mm/huge_memory.c,
> and add split_pmd_to_migration_entries() for try_to_migrate_one(), the on=
ly
> caller that wants it.
>
> migrate_vma_split_unmapped_folio() also passed freeze=3Dtrue, but only ev=
er
> runs on a PMD that is already a migration entry, which the generic helper

Is it always a PMD migration entry? Can a concurrent MADV_DONTNEED zap
the PMD migration entry or split it with a partial zap? Although it
does not affect the correctness of the patch.

If that concurrent zap is possible, the existing code can leak a ref,
causing the folio to be not freed, since
split_huge_pmd_address(freeze=3Dtrue) does not drop the folio refcount
when the PMD is zapped or becomes a PTE page.

We might want a separate fix for it.

Actually, Mika Penttil=C3=A4's "migrate on fault for device pages"[1] also
talks about the race.

[1] https://lore.kernel.org/r/20260924065313.899730-1-mpenttil@redhat.com

> expands into PTE migration entries either way. Its folio_get() only exist=
ed
> to balance the put_page() that freeze=3Dtrue performs, so both go.
>
> split_pmd_to_migration_entries() is only ever handed a present or
> device-private PMD, so assert that in __split_huge_pmd_locked() instead o=
f
> silently skipping anything else.
>
> Other than that assertion, no functional change intended.
>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  include/linux/huge_mm.h | 21 ++++++------
>  mm/huge_memory.c        | 74 ++++++++++++++++++++++++++---------------
>  mm/memory.c             |  4 +--
>  mm/migrate_device.c     |  7 +---
>  mm/mprotect.c           |  2 +-
>  mm/rmap.c               |  8 ++---
>  6 files changed, 65 insertions(+), 51 deletions(-)
>

<snip>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 0c437004329d9..4a0b61d50d222 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -918,12 +918,7 @@ static int migrate_vma_split_unmapped_folio(struct m=
igrate_vma *migrate,
>  	unsigned long flags;
>  	int ret =3D 0;
> =20
> -	/*
> -	 * take a reference, since split_huge_pmd_address() with freeze =3D tru=
e
> -	 * drops a reference at the end.
> -	 */
> -	folio_get(folio);
> -	split_huge_pmd_address(migrate->vma, addr, true);
> +	split_huge_pmd_address(migrate->vma, addr);
>  	ret =3D folio_split_unmapped(folio, 0);
>  	if (ret)
>  		return ret;

This part can be a separate fix for the refcount leak.

Otherwise, LGTM.


--=20
Best Regards,
Yan, Zi


