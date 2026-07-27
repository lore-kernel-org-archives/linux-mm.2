Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0917EC53200
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 01:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CDCD6B0093; Sun, 26 Jul 2026 21:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5D56B0095; Sun, 26 Jul 2026 21:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5AA6B0096; Sun, 26 Jul 2026 21:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEA056B0093
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 21:46:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E654A16B9
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 01:46:56 +0000 (UTC)
X-FDA: 85032868032.15.B775EFD
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013032.outbound.protection.outlook.com [40.93.201.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 60690180004
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 01:46:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IbmTqpKE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785116813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoIachukbL648VIJ7Ww2DJbEYuOunoh4i13P0OCKKGY=;
	b=VwZEsHTDwBRpfztAorUZjNIuy9Fxj3hXFipMv3bBxWBLIeA8CV5qKDaTWHXNEViCIU0v3k
	xnm1Alk8eTB8SEwEKtaN7h0nPchoi3vpwdb2+N5bLJIQagQw6GKV2TcR0Din/sYCfpTKVy
	a6MnLfYHzh2IDiDLoSYosIHU10bH4so=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IbmTqpKE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785116813;
	b=XBbhZHijVihozuaw++JpCcqMjP8BunBHHYhc2Ldd6Z/LBwiwwH3EACpTCClF98VL+AKlKW
	jXR/5Dw+5f5URMMj1Z9XQy7YNU7FjTF661ajynRoOi7N9/ovdnA6fOAxB9Kg89J5e88DsN
	R0Cencl1VljP6XEaG4mUO5+MzoNcxKM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EbKmZEUS3Io/IRDx3xMHiyIBo7we+AQHx+stGjTUZRDwVmp7GQFq9FcybiKHsJIheE5huXowltrLDCUlDk47FZrrT6Y8Qsm/IDMwN44ngoXFd/v8DX+nuLYOIxyfvf28mJh92kk6CrEuPHDbH1UMy03f0Qx0z+xa8ebO3OAL/Q1LNNuAsFKC8U9kMo7aBmHVWZzYveqrcBiOV4e6csehXfGLNAQxxyEHkK5L0+Fdhhp3tME0nLVEee2lQyhiC+BczuR2kbuqNA+N25zvvnzFv23RGK1O/ywIJLZzMYlLe+G3EBmryraBCM5o7sAlsTDCom7NR3zbjz+TTLBOKzSF2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BoIachukbL648VIJ7Ww2DJbEYuOunoh4i13P0OCKKGY=;
 b=uoDa6hbwsUeNHtw/Z/caQnENJBgmue4JJwiW9rlMcNXoIxEvFNP3ln8FRkbmO9/oxz7uMI97ujThG/tsuAS3muajRUEXSrMqD7JWyuZhepgVAIhzEMOUDphNNsxBhS80VjK8k/OPmLj6/OtxXQlgxa9eCxO1aWwLYXj6OxU91Vp9iZ9aARghdHSOxs03KcDtJcqSE+ihd47vkKeRbUBywgbqr0m1HxnITFv7lr9vovSgbvNPstKXnZ1QlnwFyLy1EcBF3PoWEb6w05hh0oCYWI2sBjS92WwiDuU3LVUOjzhnHI8NL34Vyqy0ymI1omJXd7e8XatPwme6QkqXYM/p/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoIachukbL648VIJ7Ww2DJbEYuOunoh4i13P0OCKKGY=;
 b=IbmTqpKE0NoB+Z3VSDt89ZtlwjPSVP0AU2HmC2jkGnIDA2S6nzZk37Voun1fHs8t/qPTj2md3Nfgnlt1p49qLBtq1U2OPGpeG0/RpAzGCp5/mWmpFJj5ry31YYXRUtoUdCuJc1bYNTMnBCbFNG4hexBp7rch62+qr+tUsSfbaonusiW+rDe0LjeiYrfETvSjjWNcqiRdjZ5Qx7BbyafE9wF3mzo+lISmsBn2SNDIQNnxwv6rKynBs3DaV0T13Ovjm+hxSq0lDbn0/xuJSNPHXePoW/4WPzDbSMyF55Uvhp7uM5kLiWFWBWSOgOquLL1Zy/JX08chBULAd+FMrogmyA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DSWPR12MB999176.namprd12.prod.outlook.com (2603:10b6:8:36f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 01:46:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 01:46:48 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 26 Jul 2026 21:46:47 -0400
Message-Id: <DK8Z3GD8IX2S.2GMOCJYCT3BAS@nvidia.com>
Subject: Re: [PATCH v2] mm/migrate_device: Clear stale mapping after freeing
 swapcache
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
 <byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
 <apopple@nvidia.com>
To: "Balbir Singh" <balbirs@nvidia.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Arvind
 Yadav" <arvind.yadav@intel.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260724082702.2531024-1-arvind.yadav@intel.com>
 <20260724214307.a50ed52cf78fdc73bc42f9bf@linux-foundation.org>
 <2b2fe98d-1a7b-4aef-a1ff-0fbe43339180@kernel.org>
 <DK7YH5O0FS58.3OTH04TI72U0Q@nvidia.com>
 <c3532789-6b6f-4cc7-9d4e-cfb05cc88264@nvidia.com>
In-Reply-To: <c3532789-6b6f-4cc7-9d4e-cfb05cc88264@nvidia.com>
X-ClientProxiedBy: BLAP220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DSWPR12MB999176:EE_
X-MS-Office365-Filtering-Correlation-Id: 8be71a21-d0f9-4f27-5873-08deeb80ec51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|366016|376014|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Em/u5f5PPKEaef+pMd86ZLt1PYTDzWB7F9cbLigLZZjXQ+lsGUPv08N/teJC98eFh2z4UYgUCFAdhYDOBozH1+9rSF8Bdtl6oPNmbgc7NNZSiCHQ2LCTNqpv9R682fyl5JfzfOR/Wz/3SFJlY5eNYjRoOJfmA9E0nOARR4SQuW44XpydxxiajwAlfQjae3W4l3tP91LpkywxyhBLRVSZgr/R0Wk4Gh2AHPiq+hm7YNmdT3jy1B7sEKRmsNma3fmXccOZYPn4CBGAMrhrlSnNxiPeW8Lr4wmppZeXpLZKYLuSU+m9PG6q8yUN7C2gaD/asqK83ki0QinhwiTvfOnn6Zb/CpG0Qw+6b5Dn5V9bs33C3b3XBYCQCBIVfJugQLvnqKJHVyC9WWaRHl3wwqf/FZ72DqAXz5SJTV5VfZ7iqMcVXR2nrJTujrSdgE7Jvy3AumHtphX5E4ZdmaC1GEiNKOpl+6HibupX7iFh5gDRPWY8sePLMxqsEha3+UYPYvOqHHWATmVImm0mODS30qIGUP3J/6tXTh6QsL1gMUHRgGuMPr0OMW+4orTjdQVUndsWHH9sU23mWHWs6vfBHm6c9/6IEZbyedTmUIthHTWDoz5Jb9/kEWCk19a37biBYqoNUCgWpL24xZ0QOEFIOPYZdD4kwymc7WM4DCY6dYpr4pw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(366016)(376014)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0t2WDBiV3plamxXZmFPbmZMK1dGdStrNC9IT0xDRHlYQThQSG5iRTlSeGRE?=
 =?utf-8?B?OS94MGdHVlA1ZXptaG5kbHI1VEVRbUtldVBMMmdzUnpGQm5mK29OdXBLc2Zt?=
 =?utf-8?B?R1RJNTExc0QyTzlKM3lEbUdYSkZ0bjlaODJRVkR5ajRYL1ZScW9nTXp0SHd5?=
 =?utf-8?B?QmRtaWFPc3JnWTRWSjZkYzhBRlVEL0g2VEh2ZnU5Sm1uMVNtWnUzbUd3TlJH?=
 =?utf-8?B?K0Eyd2xRRE5zY3U1bXc3SzduM2FzOWJJMS9LdTJOZGtab1NKUUg4U3dSWUJ5?=
 =?utf-8?B?c05yODcrMWJlRUVrZEJIbk5yb01KU2U2NW8zTzNpKzdpRWRnL2lTc0tzNFV3?=
 =?utf-8?B?d29IdStwQ0lxMFYwSnVObWVuN2I5eEpGSDZQS25mRllZYVJUS0ZRMGtyTDN0?=
 =?utf-8?B?bUpuRjVLYk03YTBpZHVLczNqc2U3Y3VWQmQrRFR5QmhYeENYc1hJaVQyZXI4?=
 =?utf-8?B?WjhNdk4xZndtZlNZdU1lZ2pMd1g3d2xtZDMrUWlvNTJkOUdrTDhSYk5PY0E5?=
 =?utf-8?B?b2ZYUFhOY2s1MDUyTTNKUHhMZGdTQzdJYzJoT1huTkZwN0NuZDdBSGVRM2VY?=
 =?utf-8?B?LzQ3WjZmTmxncTZtS1JBWmFwUmhlSkw1MjU4QVF2cWRjTm0rQ2xaczBzelJM?=
 =?utf-8?B?MmttVTZkbTJsRUJjRzhWa2p0TjdhemJMYjVaUlNhbW9xcitiSFJtc3J1Tzhn?=
 =?utf-8?B?dExTN3dFaldYVDRRVzJuU3R1QTRHKzFvd2s2RUdEN3N2UlBGNjZvZlFEUlR2?=
 =?utf-8?B?aXRXV25uVDRlOTdPTlNwTTBUTHViUkVaeG5UM3c2WXVwYXhObEtyVHhoeUhZ?=
 =?utf-8?B?QkQ2ckIwQkpQTWNlYmptVEg2S0JBeTBWbkl5RFoxTVJzR2cyU1A4U0lhZjli?=
 =?utf-8?B?WlY0bnVqY2I2SFBpMWRYeitYQnRITkUzMWo4eWtyQ1g3U0E4dDM1MmNCWG1I?=
 =?utf-8?B?c2xmV2cybSt6dDFGdUYrN2N4RFV4SSswSHp1b1lVcWUzMEF2QXFnQTRxM2pY?=
 =?utf-8?B?NHJtU2tpWUhqWVY3TWNkS1Y4M1VReEFEd1RWUTlESjJRMFR3eU1YYnJSdnp0?=
 =?utf-8?B?aG43ZllkcXVDbHdnQVpsQktXU0lORHh3WlBTcUFVYlArZEVTekNxL0wzbzVE?=
 =?utf-8?B?WnJzeEVNME94VkRTaldKUW90TFdma0lSdXEvVjE2QlViZXBUOWlZNkxRZ2FI?=
 =?utf-8?B?QXE5Q2lqVDZmMVRHbFl5T2IxL3hsL1NBUVcvZ0FaWmZOZ29vLyswdnUwTkNu?=
 =?utf-8?B?bXdLZmxBKzhiLzJZNUN1TkczVENzdC8zSE1ONkpuT1BzSG9mdmVIOURhMENP?=
 =?utf-8?B?bFBFU2IwTEdRTE91dmdMTG05RVNSVnhJNVMwMXFJdlJZUXFjT1N2eDFGc21D?=
 =?utf-8?B?S2JabVIxOXE2dzRTaWcvOWdaMUViQmRMOStPcFkzMTY0WVFjV1c1c2htWDhP?=
 =?utf-8?B?SW5RYXFqbmtIUWdDSHMrTUZ5UWZ1Ym1PMCtNZ0Vja1FMclRxM3VJNlRKNlRa?=
 =?utf-8?B?eGNCOVVTQlFjNmxjS2htQjRaQmw2S2k4aE9vRlFRVkxvZDF0Mmh0WlBOUEZT?=
 =?utf-8?B?K0htZVRGY0tlY0VFZmNJUWZ1WjR4Qmk0TDFvNWUyY3BFZ1JiWkZpM0tYREJT?=
 =?utf-8?B?eUx5cDVOalBjeXEyZzBiOFRFV005SFZmMXB0allkYUxKb3FwbFljWHlzdUxB?=
 =?utf-8?B?dC9tUXV1QzJabCtRbURUVWQ5R2ptb2RmMHYxNzdyc2hYcVk1Ulplb2Q3Y1d5?=
 =?utf-8?B?RnFOdmtaRGFvaGxxbXlCL2JET0lTR2NYMTNUbnBuNnFmZHQ4clgwS0NWbE9q?=
 =?utf-8?B?Z0tIdGM4NUVJMU40dXFuY2UzUG9sLy8waGhBallnOVFWbmlwN3BxOS9tREE2?=
 =?utf-8?B?dFZTY1A3L1VCbVlCbmpVSWl4L2JHY05Udi8yRWZWTWlVUHJTeUtwVzE5S3Rh?=
 =?utf-8?B?ZVJNSzNUZ0YzS1RqUlFCU1FYMEg2cEtlNHJucXdCT25ZYnQ1cVNGb2g1WHpz?=
 =?utf-8?B?aEFBTm1LSFIyallXMTBPYjNTdFBCelhFMmpJQzMzaHVsVk9VN0pBSDlSQzZY?=
 =?utf-8?B?MVMrWkU5U0NaUnVNWjV3SGNjWU5FQWNOM2hYOGlTMGRZZ1FLV2tCSVprTG51?=
 =?utf-8?B?VkN0R01TMXZXTEtQUlM0NmVTL29QQldOazNlUk1jcmE5Tkh1dDhtRnhZYjNm?=
 =?utf-8?B?MXAxeThtZHBjVzg2aDhnSmlIbkg2ZDQ1K1ZIQUhYSWx2NVVHRlEvNUpobUlJ?=
 =?utf-8?B?ODNjU0dBaWlLazdBYzdPWXhFK0xJYUhObi9tWkhOVFBESWFaSWZST0plbzFL?=
 =?utf-8?Q?nQp15oKN3o1krj7iYW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be71a21-d0f9-4f27-5873-08deeb80ec51
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 01:46:48.7736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n8J/AzLgNnWhJobHfKMK/ERJQawyc0TsS9Z6ZmIY9HvBJRv7zWWIvQC7103PJwor
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR12MB999176
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 60690180004
X-Stat-Signature: wmoaqz54aockbwmkbu78c3ge89xd6i14
X-HE-Tag: 1785116813-361897
X-HE-Meta: U2FsdGVkX18DwIqM87rSIeZAfSqaxoTElskICaTpd0VUMSeXLsfzQACsJ04vXq1MWFEU/QVFCpLxLa9s9pOC+2ZZe2F0iwTuTGZEBbxG81NUXvZPu9SioJCW9rjtgYEHjOiyq6uNT6mU7HySqwFQtDlIOMnLq+SaPM20uyDBdXaaPVjOS7Tv2AeNjo/1D6GIy5K3bNAkFA4XnUqHn8n0WZCI6LvVyszbka1CbGFwK7OZ/LhiGW9p1bOJlJqy4WDWP43X3be2usse8mBXpWLXIRkhRGLwfIEcH2QWk2uleeZfz7CBbWwQjiyJ4syRZB/DJh1IRhT9m/DUTbGoiTohqG1rQTZs2Sd4fZDJxfU+//SGYMJgGAHKsEszwzlx9wR1cMluIexOFr9ABNKLYypgfUV+oll6V3NLwMv1lnNBkk8yy/khftlBj0rS6Bt7tplGbs0tmJ2gFnk32MXG+0Vfawr/7EIRyYmv7kQIgPwzbl0O8W+pRYuCAlxWlTFoaUN0GRtZlosXgXOaX6vGk3P+MjOeWAnQYbxUEHkNDApRrBg+hcAMXY+/d+EG4ZbfadJ00ubnFcMSThJeKF/gJ/g9unUWx0w7HKvYVAmKVm7uDKlkhR2mRSw7FnAQ02bCEzmQAj18imuTjSX3w+W4LO8XvHezBYzWgoCd2/pKQRXUIZK9e2OuW4MbvlG6njuADARSBvzXF9UhCv8v4aK+OAqka1gtoi7DVSZYKnflLRcsaa4qxjqr5FPAQqBEvAGIElIctIEFvy9wsszdyFUfuLBl62JLcW4hmeZSAQFTkk7Tej8CShROlpRU9z8w0Qr45ydACzinypCKStMmM9SYys3Rc9DVq1Th7kcmW4O3KJ/1WiHPO4vPfVbAeOoi8p0ZmYq0KZlBYvL+nMZSMQ16ZNEHz/oV5m7BZ5uVGtoI5dzHWxpXFjDdAwvUqrvyjrDdKM6fUqlQcwqBve55Upw49eY
 gEUtucNa
 SamY/rZDQ5vjrZjf4T/H4Ri6Ojyg2awmNeZZTaR/4mVcWqdQX6T1tv9o73fIzVaWNkYjzdcks/+NGthQpL69ETNZN2ZAE87K+yGvJm7QLZB9M1HIdL4IWDm7mvQOpCguXQ3oJtqZovX+oAuEh9e9leS36SHCaKGV6q7x+WywA1+XZNXP1qcMTSddGE26UNxmOry/3OgBrJjbryLJ75N5cWryUFNQqDts5cpUzEVYRLycpba0zdPHYFHqgZ2FO59Bu8x7RwhFj8riNKtfrHNRfAUdFiiEJit4IQHHMNhAOiWjUv2xE/fjjcU78HpQbGSemW6elUz2BZSH78+4YNcR4PzpBzutCpa/KX/BzJdpvknupVxqKWm3h25gwr8TaFc+jYcK/XxSMuYCd2cLtOuBZz+KeJD6L4BFv4TWhBU1vhTJL7LiXxyzlYi8+DWDIN8HGdH1JPUZuiLPyKuEHjgOiOkPEDFmix9djQ+ZYbDqZwRJ3oVDSn9yseIhXpH8zxQCIw2UlnJwyajV2/O5vxcPxaWUqnBvAMWs73L1gj5s9tXN1UKqev00RZyxIluKHFGEvfWogWWfhGeCAh2w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Jul 26, 2026 at 8:38 PM EDT, Balbir Singh wrote:
> On 7/26/26 7:05 AM, Zi Yan wrote:
>> On Sat Jul 25, 2026 at 3:36 PM EDT, David Hildenbrand (Arm) wrote:
>>> On 7/25/26 06:43, Andrew Morton wrote:
>>>> On Fri, 24 Jul 2026 13:57:02 +0530 Arvind Yadav <arvind.yadav@intel.co=
m> wrote:
>>>>
>>>>> __migrate_device_pages() reads the folio mapping before calling
>>>>> folio_free_swap(). When folio_free_swap() succeeds, the folio is remo=
ved
>>>>> from the swap cache, but the saved mapping still points to swap_space=
.
>>>>>
>>>>> Passing the stale mapping to folio_migrate_mapping() makes it take th=
e
>>>>> mapped-folio path after the swapcache reference has been dropped. Thi=
s can
>>>>> cause an invalid swap_space lock access followed by a folio reference
>>>>> count BUG.
>>>>>
>>>>> Refresh the saved mapping after folio_free_swap() so the current foli=
o
>>>>> state is used during migration.
>>>>>
>>>>
>>>> Thanks.  AI review might have found an issue with this.  And one
>>>> possible pre-existing issue in the code which Alistair and Balbir
>>>> worked on.
>>>>
>>>> 	https://sashiko.dev/#/patchset/20260724082702.2531024-1-arvind.yadav@=
intel.com
>>>
>>> Yeah, this might need another careful look.
>>=20
>> It seems that the pre-existing issue can be fixed by resetting nr to 1
>> after split is successful. It should also complete this patch. Something
>> like this:
>>=20
>>=20
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 18d097c388530..4a77b6c86ae4f 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -1193,6 +1193,11 @@ static void __migrate_device_pages(unsigned long =
*src_pfns,
>>  							 MIGRATE_PFN_COMPOUND);
>>  					goto next;
>>  				}
>> +				/*
>> +				 * reset nr so that only first after-split folio
>> +				 * is processed below
>> +				 */
>> +				nr =3D 1;
>>  			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
>>  				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
>>  				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
>>=20
>>=20
>
> Hmm.. I don't this error condition possible, migrate_vma_split_unmapped_f=
olio()
> will VM_WARN_ON non anonymous folios, but the design contract is for anon=
ymous
> folios only. The enforcement comes from the callers of migrate_vma_pages(=
) and

folio_test_anon() returns true for an anon folio in swapcache. So
migrate_vma_split_unmapped_folio()'s VM_WARN_ON() does not prevent anon
folios in swapcache.

> migrate_device_pages(). Also __folio_freeze_and_split_unmapped() checks i=
f the
> folio has a swapcache and mapping associated with it, prior to split. I t=
hink
> this is a false positive
>

NULL is passed as mapping to __folio_freeze_and_split_unmapped() by
migrate_vma_split_unmapped_folio(), so the VM_WARN_ON_ONCE() there will
not warn this.

None of the above arguments is valid.

One thing prevents large anon folios in swapcache from reaching to
__migrate_device_pages() is migrate_vma_check_page(). When
folio_mapping() is not NULL, extra pin count is only 1 +
folio_has_private(), which happens to exclude large anon folios in
swapcache.

Regardless, adding nr =3D 1 here still makes sense, since why should the
code below process the old nr pages after split is successful? It might
be an optimization for current large anon folio only case, but it is
more like an issue in the future.



--=20
Best Regards,
Yan, Zi


