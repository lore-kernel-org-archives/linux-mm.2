Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 008D8C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF18F6B0095; Fri, 11 Sep 2026 10:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA16C6B0096; Fri, 11 Sep 2026 10:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69636B0098; Fri, 11 Sep 2026 10:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A89C6B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:58:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50779C0289
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:58:02 +0000 (UTC)
X-FDA: 85201786404.02.E253A8E
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013012.outbound.protection.outlook.com [40.93.196.12])
	by imf06.hostedemail.com (Postfix) with ESMTP id 805EF18000F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:57:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jCrknJHL;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789138679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5zHz7C3SYtPtFBoVWGT45/Vhw475AS8QamE/epO6Hw=;
	b=cJnBZZ6IA4AfNpT9m1dPFTX1tTCzCGPUPNXbYHyatGcDDKca+Xays9SLcXvEEvXPa6MFKC
	wdL+V0OJRx0sMBTeCRA6qCvrK5SmzVIqcBXujjZ5Gvs1KUjd/U8E274Je2UukaWSPrqLF0
	Wc6kOtKug5+bRiSx/kb/TCWa3QYEdBo=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jCrknJHL;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789138679;
	b=rzSdbOQHKo1+wzrvjR+hW9GaCDV6wvZBGhdXeIvOL9Z6mIMUYzHC0gI9Zijxy7rKKAEIGq
	0i1DWhV6VcyUVPZI9MqBYYSgiKWOs3hx0XCwU6h2qCZQgkjjbbzXXZmjdW2IxK9HxdDk5n
	imbZchQAtqDbqcqcjpn2Y9A9++4A1as=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fLVlCUoQaWCPVetE4UhhOT1l5QQ8Tzv8QaIHqe3biGI/jDcuRCM3+FHJtWxJ/9Kjj9PfeIzIjxl3rFQKbODm0maroxyRYVCPvfUj5eengme+rKPXPi9hk5ebq7ShjDmpyFVbV0XLYKybUDKBPwV70VWWwg3baQm1ef+Z7F9lLwoIVKRLj8eDw3TlQNMPAis5wlxAYNSwjctWYuFG0V7gxfH1FBHVC2xvK5xJNMRERYGP0t65Ah9iXiKiWc+bLFxFQEjet5HWtXq7+8DMeq4Wo/6n/2BDnZ/VvWa8p7QekcHxSiRZqKqzp5h6fXV314QKcyNllIvpkOFe2u94MkoX5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5zHz7C3SYtPtFBoVWGT45/Vhw475AS8QamE/epO6Hw=;
 b=hxhpTl4GQnzcYvwjm7GABMEMonFk+LM3YUBrPuUEmdAjrFTQTFjYtd5PUuDeQjTo/TmMsV2Gwwt7zi/V3qIFLcJeUnwloNMk64f2BXUsO6xaqWuWPbz2VP6YJHqnzlGsu2mV91ROmlt+akOqAfLM9/sWSt1Jmb2VksJU+AafKQfFak+bWUH+4QSUBJpsM1ZhIGJWyOdy1mAUmETyW+o7T7rOh8S2wei28RNqTPmY5EuXNrPpVd/NXuMCMd30Df/4u+DaJNbjh5UVehUhv5aa0dVvB4sRf8sPBppq1lhNOnbJQuGrZHrx5p85eL+SQEawwcxRhv//9aR9tudFxrzEhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5zHz7C3SYtPtFBoVWGT45/Vhw475AS8QamE/epO6Hw=;
 b=jCrknJHLmNuavyeJy7xzRAjhf+nXSzccvlkDS8AVqKQpUyq9tAga22pXMDbTLIzYVWfNPLqJEe73dSh+fPlCPl8sc3+4eUyuN1KKR4gbu2amKNKSLxJBfiepVuGpgTDAqQDGDeOX7xiT7RnV/qZ5NwYEbtWiPDOmktg2peJ42V+GdcYm/uResOcN+pArfLSXDrnUd661KIaPQuHpOIjtfRIO2JkvASOjKWLIsgq0T05TuNDxt3daERLwdKgDKJEAJDaD8srHSk7YYmZc2IJir+7y7UQldKp5QCKvgbMdZNi+pkS2L73+GHpDLPYZnQvbNp2rHP37NqPWzFN52OxOnQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB6934.namprd12.prod.outlook.com (2603:10b6:510:1b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 14:57:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 14:57:48 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 11 Sep 2026 10:57:46 -0400
Message-Id: <DLCKQ4T6VJZA.3KVN87GD21IBI@nvidia.com>
Subject: Re: [PATCH v2 09/12] mm/collapse: open-code collapse_single_pmd()
 in its two callers
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>, "Liam R . Howlett"
 <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song"
 <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn"
 <jannh@google.com>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-10-kirill@shutemov.name>
In-Reply-To: <20260910120238.2529819-10-kirill@shutemov.name>
X-ClientProxiedBy: YQBPR0101CA0201.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB6934:EE_
X-MS-Office365-Filtering-Correlation-Id: e5073c25-1685-4186-2b76-08df10150b9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|22082099003|18002099003|10067099003|56012099006|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ACYiBm4Lz+58cGTkniLtYn2hWqS2U1Mw2cTnpY+5THkUUiAFHPN3cIco866vXGRh4CE4v3dniHhFawzbqHHlFtUcZehkSXoxQymtcHa3B4CHoZ9Idu3/SwSTHAqBe7QCS8HxgfHk+jGPIRXpNL7ZWi1RbXcrjdkNLbWvZeGO5A6B0a/hdHnkTySIxZx33qaUBpyxvPqhFWmSn4y43LfD1ZgGXtXhn2FOIHXgj3hRWSJSDQthqeaOlJ0O+FiGp1MhMsPUQ2rVf69/XM8ES+MWQAHZSQ6cs2AnkyypgiW4Aawx8PcKuc+HJHn21Vi348T3B0bi4mWIJMEqcvOXk0YWIFNrHgCOBUCVhCi1Q8eCrY4jIXUQd/uZAGCgJSkVGaJTeLF8RoLEBlPKpSPMmMqKUzLABaqOg6vWIYS+mTXdc4RZtQSeXthPCB2eWN4SSk9WY+RWjjbWw63Qb6+tezFJwoimo9Te6bU8ACO3gYiCDH79e8OIcQFtcvFyXHJlSNZ8p4FKjU5wLSPgp1x8Hz2kfAFSOWnFsUC1BT2RNpcyrE2X0xdcIMD1JnIlQ48jje26f+x40jklFSzuNBVRx0yuGBE3yphOIG2nGGQs1YifnhK1S1ys5y7eRpuSax+U1ngKKNTRu+6Ctnu3KuLuwy0JTHhwggf6p4Bjyopvx5QM1g4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QjR1NjlScmpaT0pMb1ZtR2tmekJwb1VldmtKNzlPQVMzSFpiSSsxbm50Y2NG?=
 =?utf-8?B?Z0ErdzlaRHRVcW1DVDV2Rkxoc09XTklvRDMvaTMyR0pOMGVHZjFjcnN5VXcy?=
 =?utf-8?B?TG1DZWpVQkFTSnRoRENNY2xGa1hSRHVmZEdBNHE4QWZDT3BPTitoTDE2R1dz?=
 =?utf-8?B?UjZTWnZ1QUxaSE9MYkJnMWFMdERJRlg4VFNNUGRHbWVxUkdQU1Fiem1LVVUz?=
 =?utf-8?B?SGkydWRqQXJ3T2E4T1ZEcVdSUlZKL2lVUkhOcnFWMGtIeE9qMEhidmluaDBq?=
 =?utf-8?B?QjVrSkFkYXJHK2VGSEZGYXpxL094NlN1cmN3Y0RUdUExZi9NcksyUEJrdk9s?=
 =?utf-8?B?WWFydTg4eDFuRU1uU0RtYkZQMmIxak5mUzhma2paZkJNU1dRYngva1kxcUZs?=
 =?utf-8?B?YXExQkUyQWZjQzR5MTVpdGpIb21vM1lZRThiZ095eXBRZkJtZ0JVL2d3N2FK?=
 =?utf-8?B?WDc3VE5yT2F1SFhNV1pHdlFDRncrekwxMjlsWFF4UHBzS3hTckpZK0FJbWtO?=
 =?utf-8?B?Rmc3TWl4dm5wNitXS3RyRXpDWDNuTXM2d2ZpOXlzbFpqa2pKNVlscUxiM2Ja?=
 =?utf-8?B?ZG5FWXdRT20xd2U1VlcvU3hIRGRxSDMvVHhrK0dQRDhrVTBLQmtJVEJXb1RM?=
 =?utf-8?B?djdMa2lDelFDNWMzTVVtYjZoOHFjZDN6TzVPYnU0OEU2YktHeXpSNm8vSWdt?=
 =?utf-8?B?d2RURmxHZWtFYnBtTk1odU83dk9DRU9oOFBtOEFoMGRPTENDdzhkbkVoY0VP?=
 =?utf-8?B?eVM0eUQxenVsMnV3OVdzN1NjSkttYmRxa05GWUJwQUZPemJmVjBaZ01YTzUx?=
 =?utf-8?B?V0xKZ08xR3dxdXo5WmIxUGIrMG9ISVlsNXlNUHk2U2JRRUt4c2syaHoxRVZx?=
 =?utf-8?B?Vi9mNFlja2ZVc25TUUQ0Z3RVY2ZwVThhQ1crR05KeXh2endXWlljM2d6c3dQ?=
 =?utf-8?B?SEhoUVhaSktrMGdodzRDL2lMbTh2aE05cjNFbnQrZlIyT1YyT2Q3RWo4MmJ5?=
 =?utf-8?B?eWZTa2xjZXBHRzNDRFEvbVBiOG8zUWhqTVhmVHA4WWY1UmJlVVV6eWNsU1JR?=
 =?utf-8?B?eDlleFZBTnRyTVl6TVNDMnVHK1dlclpkS3V2bFhnSHU3aVMxMEVXbXlSRTZH?=
 =?utf-8?B?S2dSZ29uRGE2SG5ZY1BKSnp6RDhqNGFHVElXMk9qR2FEZmpDcWR6QmFrbmhF?=
 =?utf-8?B?NGY3KzlqWHg4QnNaMkpiSnJud2swa05JVFowWnBnd3JOcy9kRG5Jd08zby9F?=
 =?utf-8?B?TXZUUEh5dlNpTmJ4RHVpWDNHUGhOYitCZEpvUmtVK2x6WnlhelZHZTNyMFhh?=
 =?utf-8?B?V3FRVXpSblFESUUvMTZqdi9wQXFhSWZOOWVyUThBeWxWVTQwWWo1V2QrcS93?=
 =?utf-8?B?WmdnR3pLSldvVkFLbDIxb01rWVBHK3ZJU0JjUTN3TCtCelRtSjQvSDdsSG9k?=
 =?utf-8?B?TXVBTjFQTUF0eGVSdkt5dElvSEh2SGJBcHJha3BZS0hjcUZWVjcvYXFWWWdM?=
 =?utf-8?B?bnI1VHBHVHlwcmR3MzdwbVVaMEk5aHlreGNNTEdtTVQ4K0tWaC94eEdXMUNx?=
 =?utf-8?B?UU9SSCtxRm9Bd213bWw3YUxnYlhyTkVHZWN5NU1XMUQ0Mkd3L2QxQnI1cnJ0?=
 =?utf-8?B?SDhHUkhIN1JhSW9HWUJoYnVpVi84VG51UWhCSEtEODNzTDRSLzQ2U3VoMlZG?=
 =?utf-8?B?QTJMamYwVTRqOGJEMXpYOXVtclRmczNLczg3TGxoU3JrTlppVG5OdlBYb1p6?=
 =?utf-8?B?K0ptajRIODB1anBVWVdnUnBSWURQdGh0cXIvTUcrOVdFSnFyWjB5bHpoNlRF?=
 =?utf-8?B?UTNCTkQyVm5Ec1J3R21MV20yVld2VXJMT1hEcU9HbGxOaU5kbmNwbVNOL242?=
 =?utf-8?B?eWxneUFHTk1HYXhlV2VST0RQc2ptMHQ3Q0hlY3BsNFEyRFIyeTJPTlBCOEhl?=
 =?utf-8?B?dzdNN3hNZ0ZlejNaNlhzYjA3YmJiKzAvdVlVSHRXb2xRREhWTTBydzc2NkdJ?=
 =?utf-8?B?M0VOa3lybDF4WUQvVzZBcTF0MWZjbzE5WGd5UC9QZXF3ZmdrNGhjUmtyeFpI?=
 =?utf-8?B?cEJ2UXJnb1pwdGJjUkplOUVnU1ExdmhKTkNjK1drUkdsdXpoZ1hzc0VIMm9M?=
 =?utf-8?B?RkRDTTZTazMzQ05qVFBMbWE3T0luMUlub01jUjJaTjc3Y0JPVE00bDVYQVhx?=
 =?utf-8?B?NXlxaFMzaUplYkRmNktZYVdndExPZTkxL0ZIbFRxNzRSbVYzWHVqcXl1aHcx?=
 =?utf-8?B?cjhWNWpJQnpoVmVtZDNXc1F4ZmowZitvYUxqZjlMSDlqcTZxRmFYc3JncStl?=
 =?utf-8?Q?Sq93otEV9gvZfmKR8t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5073c25-1685-4186-2b76-08df10150b9a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 14:57:48.6731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0LyRzz/HV4iaaaeKdlnDgnU5KLZuPRXBlLTnbv/zMRQXnAndP4oAPIv6XSiCnp3F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6934
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 805EF18000F
X-Stat-Signature: 4rfo761qx1r5uhd946ciruxf4uaw7x4k
X-Rspam-User: 
X-HE-Tag: 1789138679-123979
X-HE-Meta: U2FsdGVkX1+LAuHbuby+eAI6iZ2YYAIhmioHxVTYYhCpC+4TAEscZ2H6PaLQnHAw5Epv+PPB2jJye4oxodFIkm4Uoa9LXaKpbX1kfLjnqKmjYapQ+VtxbiM/HQrwi2Hh0ZoNZ/67DKOympwGWrmaPRhhG+0W6ExfXiip+YiH0FqOAuEy3xPNPR3hzIHADiMVE6nYNVv5TYsP7hSXSCwP+5kB7gh/qQMkhoiJR4u2vRK0uJJlg6UC9kHZqS6i6t+kqtaH69+JiZuNlxGk7zGcqK2kOU4mdotqasQ3unQ/9ZrV7EHWaF6HrYZHJlWN60hixFV7SqVSKQ4EpEla/bTbcYlBAzacm8kebpcB4Gtq4vkukZdJfzReEjN3YqGlbXcSoq0CzllDjmEAHasNsFogrPqpfFqndhXCubmur8AmlDJ0nHdDZ+KNQtRB4F0orIlcO5H7wnFLxH/he334cIhkZAvRsf664+dYOoMdsx9PXArznMHhIfKa98+sh/m66pW8usP+aY1iOJQCG9dLpDjDA/iwATCv5UpMvo0rAiB2uVibpPO0HtKxb6Gc+UKT81MnSgLuL4g6O8DLBTT5IBKuKvIUbwwkdobVbZ6O5ZFiFBjdKq3/Mc/6g55r7AUwTN9CvySHHNoPQTD+dkQN4DrXMULp7oxrvODQTaXyNsJpvqHdXrihuVc2GwWQnylH+ahbNIhMzuGVITxcHJ9emSgNp22dT46f/LTRSkAEgBU7wH9OYhUxuDgVSKNxZt+n5g9ItPmorK/VuCRGqdPzTLykfCD3coSDDC1DAmvNtio1CCIlbQ1MAxXVZ6usKnykxmbeGcfCbtWMOBmiPrPHFelcl4pgzjAp7R8Nnp/L/hkKA2RquVUbF3GxxaS5r/WJnODEh26PBuNu+ch29tUCGTG0DoTn9Q1yYxg1sDyyCyT8SNTf5dKPjOEccBIFr/IBJYXi58nd/mGG8fsQuG+uWcZ
 OHwK6q+R
 hI2mvafziEZ3C2ZoLYj6rD6hbt1ZR0fzCcprfqM7g0XwUxv0XEr9biTUt1q6afBSBAeDXZiImldt/R41GhSbK1rveEnrnlCboDWWVpuEZjd7FkXvb8uaOXWIawbmBEF7GFQEFgfu/VaPozdFO1zFF2qSWkVK6IDV68MS6Cx21z5ItI2wb+AYz8pdzaABuT9x2ykxViO72FiyFP6XC3l15MysYA5tKc1fIu276REulRe1c5Ylx+J+bLBtYPXWyIiusF31MXU0L24rpT+oHypUQUG/eXEOxS7mHblMFfmAVg9cdaTpWba7nDgQzKfWoJZC91YW1LSL2JMBxyyWHS9Ugb/83xm8qDDlOp3kuRj/wRe7SmTYH3dd9sZwbRHB08ca9nxJDu7fGPaQNs5H+g2YrsM21a69VHU1cDsXV2MjvizWt9wshy9V/1WjzJIaui07ELCTDfCYPFC1cG6poNRHceQEBSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 10, 2026 at 8:02 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> collapse_scan_pmd() and collapse_run_pmd() each have a clear locking
> contract.  The scan is called with mmap_lock held for reading and returns
> with it still held.  The collapse is called without it.
>
> collapse_single_pmd() kept that boundary inside itself.  It dropped the
> lock on some paths and not others, and reported which by way of a bool it=
s
> callers had to carry along and then act on.
>
> Open-code it in the two callers.  Each scans under the lock it already
> holds and, on SCAN_SUCCEED, gives the lock up before running the collapse=
.
> khugepaged's lock_dropped and madvise_collapse()'s mmap_unlocked both go:
> the code dropping the lock is now the code that wanted to know.
>
> khugepaged's walk carries on to the next table while the scan keeps
> refusing, and ends once a collapse has taken the lock from under it.
> madvise_collapse() re-finds its VMA after a collapse, which it did before=
,
> and now uses a NULL vma to say that it has to.  It still reports the drop
> to its own caller, from the line that does it.
>
> The lock is given up and taken again at the same points as before.  No
> functional change.
>
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/khugepaged.c | 102 +++++++++++++++++++++++-------------------------
>  1 file changed, 49 insertions(+), 53 deletions(-)
>

LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

One question:

What prevents us from doing:
while () {
    1. mmap_lock
    2. scan_pmd
    3. mmap_unlock, bail out if needed
    4. run_pmd
}

for both cases? It improves readability. What is the downside of
dropping the lock during multiple scans?

for madvise_collapse(), I see mmap_read_lock is held when it is called,
so it can be dropped at the entry and the code makes sure it is held at
the exit.


--=20
Best Regards,
Yan, Zi


