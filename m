Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC74B606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=jKijMHLj
Received: by kanga.kvack.org (Postfix)
	id C624C6B0952; Thu, 22 Oct 2026 10:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33676B0954; Thu, 22 Oct 2026 10:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFB5D6B0955; Thu, 22 Oct 2026 10:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 817206B0952
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:16:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84A2D16014E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:16:56 +0000 (UTC)
X-FDA: 85350463632.30.A412A38
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021142.outbound.protection.outlook.com [52.101.65.142])
	by imf22.hostedemail.com (Postfix) with ESMTP id 38B78C0015
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:16:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=jKijMHLj;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.65.142 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792678613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhjGZwZuqNHbuEfMk7HoJKJQFlKgzEXFXYXiuiGYym8=;
	b=WgMLReO4p7435M6PmikVQoHPdh/kyo2zIU+IUZkewaUBk3YVmP0ruaAHu+iDOQwouicnc0
	2Ne1tBEuHR4Znq0AP0cPUPRDsfyqyhHmsy09o+JdQjtAC7Gko+J5JvmZAQK7m7n4vT2O4n
	3bC1emBX57GKsYqNnhcvRnSIcTojzW8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=jKijMHLj;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.65.142 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792678613;
	b=gybFkKtP7Exp1FBgnTkVLWvWnfjcHhfsHyZyD6X0bhT+gl09nz8HXszSnTYhkQD/Lk3wBT
	qSqwhxLCnq4JTjhiGNpnvjyMHzLWkxvgYRZa/gWEOv+jrCIcS9iUEWT/ARbxvafmZJfiY0
	aF5eNXEwR7Q3CcJ5wf4v0/A+xgR9wo4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UYbnKouFLMgY3049iJ9awyIWRe2lsAmbmnSFW+vSLXMSokCiSz1pL5Tfg2sxxE1NmKL+/GlVwEYBls9zbjwHWLxjgZv0XREIjqLZ0r+ry+jNMztxar3ywliUd2bXBjmHbN/vcHv94TQ/p8jfGjtFZMJCCa5W74Vgp6jj8rDXMx+cHTQ1S6BJvZjW6VO2A9E1z/zBOvQ33m3+KosBaaOdQ/fOT30Jv2L73QUNnXstTqV0go+MkbcGJvIweIiVvam1vfC+opXsbacZRTTGaTwggq2FDiG1JekYcHDN94rBmSk17FK/mnpWQE4Go3udZdtGoCnogqmLXCHrtCFrTkQwJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhjGZwZuqNHbuEfMk7HoJKJQFlKgzEXFXYXiuiGYym8=;
 b=J6hYHKDTSjpf1rC6kYcUv3gGfAVLMaggE1PVWdiZiq+eDCY2mD/0mhce/jiDqodnFMFZDkhlM2OoxfZxIxwEtu9If6bVmrGBLG/ATVVtO3qx5oxUfDCtsABLn2EfQSeycsAMCdRtGVXZWlljgmyxxaJOeqIdRxwG7sMxu19OUoW3CoUKbBaGMSV4L+l5tXwVLjUlO2A1PPq7DSns8bDOP2Cv96PnwMCjedrGpo8EHuGLA4rxymlr9GyJxp29yGokaBETHZT+X+rldtrwmWAfAYLpabJVfp2i3Q4qrNzimKFax1VfaOaR0UWv879s26Y/TuGBkArIhE74PwYtX049HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhjGZwZuqNHbuEfMk7HoJKJQFlKgzEXFXYXiuiGYym8=;
 b=jKijMHLj8nQ5Al2x/o4SpuofMNHW+ju5pXgWf7WVn4Z6X1cjKbjOl+uKPxZSdCH97ZfXzrLCU9HDUe8bfm7TJ1SQoj6ffRVpa433B5yZ5TBC7qHFJHQ2r8hNZM8QOjmBe1R2HhV/ChIDPHTuNyuMVQbvCWioZ5YlprJbww+Kqg0aSwEyArn7bwNXmlntEYqTcc3HOAFSAxiP2LHoZdH+S1FVXavXxY/k+oKS9IhsdYJ9Sx9RvSY/On6VeuznOIU5oWEvvjI7/rAzYFzzWigWjbOKGW7Thw0pv6QjYS7Oo5MN98N9FC8h4VKAXn1NmUaiL+jnOk74D+duVPUjJ1dU0g==
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20) by VI0PR08MB11667.eurprd08.prod.outlook.com
 (2603:10a6:800:30b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 14:16:48 +0000
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a]) by PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 14:16:47 +0000
Message-ID: <88924d54-40fb-45f3-a575-48ec7dc9bc2d@virtuozzo.com>
Date: Thu, 22 Oct 2026 16:16:43 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] mm/rmap: duplicate a PMD mapping as one in
 folio_dup_file_rmap_pmd()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>, Alex Williamson <alex@shazbot.org>,
 kvm@vger.kernel.org, =?UTF-8?Q?Lo=C3=AFc_Molinari?=
 <loic.molinari@collabora.com>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-1-66f00b7a564c@virtuozzo.com>
 <atnEFyGRYGGf9shA@gremlin>
 <71101695-339d-4f8f-b9d8-dfadf7dbd0ed@virtuozzo.com>
 <atn3SPG5MKpj2Unj@gremlin>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <atn3SPG5MKpj2Unj@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VIVP296CA0064.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:800:35a::13) To PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR08MB10708:EE_|VI0PR08MB11667:EE_
X-MS-Office365-Filtering-Correlation-Id: 351a5001-3f27-4ced-3a87-08df30471b23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|6133799003|22082099003|18002099003|10067099003|261021121427099003|4143699003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	831GGQZ/Itmj5reHTQZJTMgerDpBtawATZB9dMBYNM7/2+CBHpfa8Q0oQz4trlUGFOEjmnoxx1OsOjbL1kpikrBhkM8BCyXOAY6CuTUtnQSGcHgsWSDUyw91+coOzpVQt4dlfG0WdXjbtpa73OBkOtrji3a/RV76S+Ec4oHZqbvfleCnY0UjA76D1yiVUOotODcjrZ8rbdNrS12my8xe4+ijvVLxMl113iGbklQEYNky72u66H/VCB5H45S1F3jr8Aki4Q/nQsbJeKwK7/jOonodxlhJfKRCBF4xiw+RVfKmpL8qHhuYJccjYlEE1TPMPqM/f/iVDvqj2tJ1TJRHuL8yBsAoNPvjjVlFZlzFWgFqQOFSZtPwSQ5fIxBkK1fXrUII3zHP24MWuXjzyU06suR81yj6xYFs2L1bQOM3CUtoarvc/tAyOMkggL1hwCpMG7QOfWXlCDP0vqGNUfaZ5lhCnilEJl6gfnPZxBysj4ZPGcgspFOx97VY0Zvs3t6w8ebB8FP2pGEDYFo/QfzqRaBLwl6ye+J/ZWb9ZpVCR1KULMiTkJZmjRcjBZ83iAKCb8nqysY3gBxyNb5P5dfsyiUXlNjEUQnAWKolyPSoiDNkQ9aFEUceMcOFAZ/+bCvDcTvYlEDoPRZyn/3cNKqjSrj+ZmQ8bg/RQqLiQV9w1K8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR08MB10708.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(6133799003)(22082099003)(18002099003)(10067099003)(261021121427099003)(4143699003)(5023799004)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akhYWGswSEdlRW8xSDd0SXJ1Z1RFOHZHZzBYaWF0OTZjMWJxSllvd2dweVRB?=
 =?utf-8?B?ZkVKZlVMZFhSZUdtSVd1OUUyTDlXRWp4b0hGQzdqR1ZEdld5YVBjc0ZWN09O?=
 =?utf-8?B?QVdwMzBncVBQVjBuZ3B6QVNFdTMyL0lBa00yZUxQWmZxVGFyS3RFeXV3OWgv?=
 =?utf-8?B?SVpsd0JBclRJQlh0TVBiK0I5cElSWjh0UG5WRmIxcUZQOTZWZmFJYlNhd2NI?=
 =?utf-8?B?QVJXbExKSFZ2eGt2emtWVnI0Y2tnckMwMGxQNk1oR2U2NUhkdjRZdDhOblBa?=
 =?utf-8?B?Z2ViOXNGRnFvNUNnTkY2Ull3WG01N3RhYzVER1ZkdHR4Nys5dHdFV3F6NWwy?=
 =?utf-8?B?RWJ6V1Fsc3hkT1VOMVdzckVqbkl6OVlHYndkM0RCMzgxRmVCMTJvejBqY2sz?=
 =?utf-8?B?R1Npa0dZMTJydlhwcVJtUmgxcVBvT3FtcTM3S1BVMGZSUi9FSVJRSlN3UlB0?=
 =?utf-8?B?TldianFqU0p0YWFEZXZ1clZjNXpqK2dSaXd2NXFER2wyT3VQaUZXRGR0d3pr?=
 =?utf-8?B?YVhNbXRpNklxM29mRjIrbXg1NmRiczZ2MStpUzBJU3ZBZ0QxTW81M3FtcC9r?=
 =?utf-8?B?bnRxZ1I2SEM2aDNjYVJMUHZ4RUNSM2lZSHVUVzZ5QnBnbWNCV1czbjFtaXRM?=
 =?utf-8?B?TmFlb0J6TSs1S2F2bXNydFdZVkZzbXNxbkwzdmJUU1JrU1BKVFV6ZTh2SnA5?=
 =?utf-8?B?dnBwRDdkL0VSWkpKNm9GL2RFVVg4TUtKSVpNVTBpaWVqdG1PSU01UDBYU3Vm?=
 =?utf-8?B?Q0tMMVVlV3hUN0tETFdLTHptNFVoRnd5ZmJQNTJBK3Y1bU9Dcis5c1dJaG9m?=
 =?utf-8?B?Q1RhZDJwaklTcE5LUitPcDQ4NzhrdHp4eHU0R284YUhPSXFyYUlSdFBQQ2ow?=
 =?utf-8?B?Z3JYK1VGeWhPblFUOXVva2tBWkEzZEdBMTZuaEo0R2gwK1UvUTN6UmdmbHoy?=
 =?utf-8?B?TVV4blV5bHRKa1Y2VzVDTGxZMjJ2dW8zYlJ1cEQ5K05iZUk5YU9Yc255TmNr?=
 =?utf-8?B?Q1BwdGM0Uk0vclZORnZ5UnpkMTVxcWg5NTFKNS9pUnZ5eEd2dW94dnVhZ04w?=
 =?utf-8?B?RlFmZm9pYkgxYWs2ZXJDUTZuTzNsRHZMMVNnUUJycnM3aVQ3ckg4QjBlSDAz?=
 =?utf-8?B?UU1NOWhzZnZWUGhkOXMxVDFpSUdkVHVRSVp2TGsyeFRDUTg3VVRrRTNtQnhx?=
 =?utf-8?B?Y1dyUTVFRHMvdStQNWNWaTNpTTBZL0VsZmprVUtrc28vSVo5amt1eXl6YXR1?=
 =?utf-8?B?RFQySmpYVGJoTHBQd3R2MURqRWZ2R0IvRzFLRWpjbVBtWnJ2eVRGMU5NMTRt?=
 =?utf-8?B?NnA1RzczcWMxdi9UMjBTWmtKVWg5eFA5cGk5OTNQUmFmcm9oZVh3SkhPTHlP?=
 =?utf-8?B?Q25ZMlZid0ZpK29TbDBWQzE5SVlDeHZUWGVNdGx3Q1ZpV3owRnBSOUdGR3VT?=
 =?utf-8?B?b3dVRUd3RGUrRjhHSXVlSnlRdW80YW1iL1VLNHFMd2JJZjdQa201dnRkcG9H?=
 =?utf-8?B?MWNyUHJOL1NBN0lWYzJDK2pMcGtOWkRaRzg1c1oxMzBuNkNlSDFrYTlvUy9q?=
 =?utf-8?B?dmdUTGpWOFVHSHBIVmIrbU1xTGUrRnBrblczMjNUREtMN0RLSDU4aDBMQU5T?=
 =?utf-8?B?eXlBOExDUFU2UHRWU2hocXlMM0RiU1E1R0JhS0duMGpFaXI5VEVEY0ZHQlNT?=
 =?utf-8?B?YlJtTU9PeU9GZmExZG9DOGcwSmFIT204eXVGazRPanJSbnk3eXV2ckRPelJy?=
 =?utf-8?B?K1grNTZMaEtkbW9WUEhEazVQbHF3WEhyaFF4NVNHVzRsRjZxc0xNSXFSK2Vt?=
 =?utf-8?B?RmhibmQ4eVlMakpVOUhtNzJ1YTRyeStjeVVSQXE4MmhJTzhqRERRV1o5Mjhn?=
 =?utf-8?B?Ujh2bExpZk93Vzk1UzBjZDBab21jNEtQMjUzOVBUWldCVEl1NEpLK1U5V3I0?=
 =?utf-8?B?VWdOelRhR2ZNUlpTMU5IaHYxZEJWdTFpdlo2aDFpdGhsRHFOSmw4Tkh1eWxZ?=
 =?utf-8?B?RmUzNEpLVzFkZHRicm0rdDkxbVdIaTZXUlpnblBkdFpJQlpnVTFmY3diNlRM?=
 =?utf-8?B?SnliSDkxYmo5UytTZTY1dkh0OWhKSGFoampmZzNVTFlhdXh6SzNvR2xsb1JS?=
 =?utf-8?B?VzFhUDQ0U2xEaTVTWkxtUEk4bEFvUVFmRjVVM1JhZzIyMW1Cd3U1eTdiN2Y0?=
 =?utf-8?B?Wi85TEJ3L2VVVDZycWpqbFVwYnlXVmhYOWU4K3pPNDkxMWtZajRvbVdFZ2tU?=
 =?utf-8?B?NXJ0Mk9FZDJMWlQxVjR6cFZhNTdnbkxObnhuM2g1Yi9sRWlqMkU5MDd1bHRE?=
 =?utf-8?B?cVdXUlZwOWVheVFIQnd6RlNxZG5HYnBXL1ptZVl0Y3FOVndhc2w1dz09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 351a5001-3f27-4ced-3a87-08df30471b23
X-MS-Exchange-CrossTenant-AuthSource: PA6PR08MB10708.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 14:16:46.9454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyTPybURWI2u6GkiAwBuBxszj92zjjlqt9xM30qZHsIb1De5xS35FXdULJX/NcXhWNRxAgQIUlS+zQYYjYTXUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11667
X-Rspamd-Queue-Id: 38B78C0015
X-Stat-Signature: wxq63ps5r6o9p9g58zt4oew8sdw4a4n3
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792678613-752658
X-HE-Meta: U2FsdGVkX18cBxKhUdoGB7oh38SqLjJbhbLYaX2xv2RL9EoVJDsC5S84Py+4iARIvvhBAKbxB9X2f0CZJnDDfWKMG2BKadM7PuAqd7KbWkZHScQDE2DBwtSld4Q2zZqiKcV6T3rtEOEJZFM7sxvUJm4L8Xr2OUtPSFWyXtZUGT0ue+6x9Mgr2EK825gNFyL6ln7nnXq9agYdFeww51UI03YH2i/7n5exEU08PQ8UCqIACPUR+Ept27dd8yFdKgHyp2CwOWbheQ0rrsCyY7DoDx7b2Nf/HPhpSJ0ygldcVILRO6BpKU/uRkYzBDaH/5v8lYxdXa4FXBlouJJj886rGvh3kY4EBdqx1qPgd0KVHQVHV3HYLIQ5ffj5AJtMKFGQVwR8MmGoie/c19LTVthN4Rx3V2EZnr81t6yNpXSVBkQt92SttFJ/LzsOdrnxPcNS4UYXLwCfy+QZcWUz47CBXQqg7YrUGoupIsWW4CRhR+Kge1veJ6IFhJvnCUF5DwMOLMSo0ri4MJMb7FfJnoxeK9+Ebd1KyVm+o5tj5YFg+4xr29cznC0yuGEtjmqriQql81gom8vPDelCkq/AVf6ajJzCvvixvsHicLwtOKFa4EENJyxuVz1TDATgJ6QAkbBSUiKS3Psp1FaWudu76sKBn8UUWuzNnGt9KqIjG5nvIwGzoADgxqBg3OH++Cgq7TMTcy8WpoNu7yIZzFutvUPOlhDlergw5j9OPeY6a0+5zx+ZyOeL5kRbri5vBjDMW4VQuYcCswRdjxW5gY/1KfB4h0bmWXObbs2ox87EhVai2E7EH8tAt75HG0Kt6y3cW3S+dryuVoJSxFGDNjd2RmY0izrg7uaSfmMnDacjj5yG+/pXJ0yYWA32sTigZy+K4uYk+hy405pIieDKjddNcPQTffvuluM3k+yvjyn8N9ElGr05uIC0aQSCWjSdouaUhvwh5tuWAsgwCEjtpDfpkFU
 3O62M+ek
 y652BHVbByxlyzUKNdwxhTm4wQ1ESi/Cfrl6t4CvnUaHGT2lm7sVwrKhJ02dcEmlIuKxHhR+sMvdMGKgZW/s+JeY5DxMynRSwcya6FJcjD3lPYCvYXKAZtVonPWdVswIn1PQJVONbnr+n7QQvNrPizsDqOJeoamkEUoJvYRx9Te6qxXAKnPdEas2W1BU9i+V3K30VYqMSEt3n+wyJa1PXpRoA7a1K2ZVNGKZ6YH6z7ra/916sWDgePgTVewXo5i+BCzhUs7pvaNifoP4b53I4uxJibp2EQkIUUvzGHr/V785902KgTfq36hhgi+2/pFVNCHiotdXU8YLpNJfMFP3tZh2K/mZArzkLEeB2aZmP47J5B9zs/67VZhq7zmv10Oq/RgzHhJBwSBoWhHxXkMFN0qYWxiIZLxgZPtGzG0PHpNnTLOhg5P7tSBuUeS9tzyCrng+VEfQt4ujCFv1Xa0P0DEI6fdkqkfqULuNu7M7n/EDN1eQsWycJvwWT7z28p5oM6pFtu9S8lv4gJ+LC4n8htk/ZnhuougyTiGLGnFYIcAs7SYS1Vvx3g9962qpzBSkuaAsu87HNs1SWrdU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/22/26 14:11, Lorenzo Stoakes (ARM) wrote:
...
>>
>> Both functions were introduced in a single commit, i think it's a simple copy-paste issue.
>>
>> The helper never had a caller, so nobody could hit it. If you prefer, I
>> can drop the Fixes tag and only mention d8ef5e311d7b in the changelog, as
>> there is nothing to backport.
> 
> I mean, it seems like a bug to me? If there's no harm in backporting it I think you
> should add Cc: stable@vger.kernel.org in that case actually.

Nobody ever called this helper till the patch
   "mm/huge_memory: copy file THPs at fork like copy_present_ptes() does"

in the current series, so there is no actual bug to fix in stables,
so may be not to add extra work to stable trees maintainers?

The other question is: what to do with the actual bug this series is addressed to.
i don't think the significant rewrite of PMD handling is a good patch for stable,
so may be we'll need to create a minimal fix like my 1st version to fix
the existing problem - especially for stable trees.
Or may be not to fix stables at all.

But let's first finish with the proper fix/rewrite. One problem a time to solve.

--
Cheers, Konstantin

