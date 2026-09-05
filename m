Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92673C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 12:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493F86B0088; Sat,  5 Sep 2026 08:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D0F6B008A; Sat,  5 Sep 2026 08:41:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE626B008C; Sat,  5 Sep 2026 08:41:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F36F46B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 08:41:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F789802AC
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:41:15 +0000 (UTC)
X-FDA: 85179668910.29.92E9BC6
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010028.outbound.protection.outlook.com [52.101.46.28])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8F398180006
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:41:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CtDiyrHx;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788612072;
	b=0gqlAZlBxXY6fxoHHn75gJG2ahtzpbMwZSj7hDDUtGlO8ExHZwmP0ivaovyR69J8j07FKX
	8Djrmj12+QFEDYDrCydN4lD+yqzbdIcOTFojg4Oa5LppsXxS0DQUIta7GdZ+zue77S8Y1h
	EEZeqJqafNFlYgjjHtQeaJ5oRaTY+xI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CtDiyrHx;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788612072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eyjv7Xcj+ejbUzwiRc4IteNaILcozc6HMVGzPtPrMas=;
	b=cYJ58docexQx5bXp8nwb5LuSfhkjdYwN/twS66noMPVpGwE8b/TpZHyXUGyEzd31BTYBAA
	GQsVQYSzvy+h5yJca2IkEWzmL12yr2E+H6m75iWhGgC0zm760fH1cjqHNSYLnBzSF2qTsy
	yqnLY2jt32OGE/hnyAbCcoUQaeG0z8c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hETSmD9god6qG2MkaPxvGId7sM6aDXqolOKINSxj5AOqhzlsKwB/FzzF8fUtMxZiZsavX11iqRr4gShO7u1Z+o+wpSGheS63XS+Vg3x1eV4MTuoAp10JeyMy8nD2ysmS0MUsC/tzuFGPA1auls5Sxr7PdVsXNyO5VVXgW4N6fBNM1ZjuEqAtGet5PrbKUREbHwvmL7LgJMqB5jDuYugQWeZmh0uxFDwULPM3OXMCak/cciJ0uNXdjd3Y8T6o/tbbHO0TQodZpDoWXrVdfe3FfDHsKuEtdLZcd1NmrWzmgfB2Z8V3UaD03Ai9+uVDOx8DfTfk0OkR2rAdNWO1zK7oaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eyjv7Xcj+ejbUzwiRc4IteNaILcozc6HMVGzPtPrMas=;
 b=i2cQQvA20YP9XtR03NQd6gEQnAxHtRenrAEwfb1jN2VqQkAIHy060h2mqERm8iqbYNl1m0FAW1EfDLvOZIP0F4veONiDnh2RYaLFFWxL6FB6rerhLACsJ6FEuanxFr+8UqNaf1T9WX1SVSTH6JYUNeuX6HgcKEbh+kDJFtB//IYHdaH5DK4w+KfYzVXWbWYawmyfkbF+pAX7j+Movk+9mTvjVqDf16Oc8y1gxouy+owtdnNsHKCmwWGfo+12SMljGlIgkvJU5bZVliybPvNfWYRDNndHhvK40iTIJ2C00bkSUHqLBYWJtrXYK9AMgfsT/dANKRMJFeqxX+psUufp+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eyjv7Xcj+ejbUzwiRc4IteNaILcozc6HMVGzPtPrMas=;
 b=CtDiyrHxh6VA7wtTwhYd53PR+PksUwf2clS2ZMxQwe7KCL/Mge32Mw2iwOxWpZ+IB9Y4jR5C8QhtRwNJJMuTox9+RNAeRMSmBj3rNdPBbMcxbgC+iSdNsHEz1pHgCxEErx6K7FdrKVgdktHg8I+nyLMalG3QkGGE4wrAJwTqmXm7Ut4QTya/a7lojjAakSrmeEgZi6h4ymN8iHcFbV22wFHR8gu6+/nrPUqLXO/h9XkfsyU0Y8AhKOJaWZ8BBNzWAN4aqrQECRPmIpVcznAbDtxuB8ha7ylhMBF0NUy1Pz+5JQDGoapU9bHiYHOL9XvNrWiPpqh2O4wkMcOjlW78zQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW4PR12MB6849.namprd12.prod.outlook.com (2603:10b6:303:20d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Sat, 5 Sep
 2026 12:41:07 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.012; Sat, 5 Sep 2026
 12:41:06 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 05 Sep 2026 08:41:05 -0400
Message-Id: <DL7E27LHUEXZ.3B86XR1QN6PP5@nvidia.com>
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in
 truncate_inode_partial_folio()
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-ext4@vger.kernel.org>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
 <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <hughd@google.com>, <baolin.wang@linux.alibaba.com>,
 <willy@infradead.org>, <jack@suse.cz>, <bfoster@redhat.com>,
 <djwong@kernel.org>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>,
 <chengzhihao1@huawei.com>, <wangkefeng.wang@huawei.com>,
 <yukuai@fnnas.com>, "Joanne Koong" <joannelkoong@gmail.com>, "Zhang Yi"
 <yi.zhang@huaweicloud.com>
To: "Zhang Yi" <yizhang089@gmail.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
 <DL6S5JLBHSAB.1RL17ESZ1EK10@nvidia.com>
 <4e166a3d-9012-45ab-a011-0e0ad54143d5@gmail.com>
In-Reply-To: <4e166a3d-9012-45ab-a011-0e0ad54143d5@gmail.com>
X-ClientProxiedBy: BLAPR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:208:36e::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW4PR12MB6849:EE_
X-MS-Office365-Filtering-Correlation-Id: 4056405a-a541-4f65-76dc-08df0b4af472
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|7416014|4143699003|10067099003|5023799004|56012099006|11063799006|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	MjnHYHC04PZboxdIe5UjvpZoxXTnpoSENQ5RDkCGE1og1EdUL6ulhL7af/piBxhU2IwVkO267xHTeLc7oEq/56NZjJHcDSfOHIQCPe5nmsgAqqCvKlr9EBEsbfnnXuN2irHzTVAN/TzMuPB1hFI72vRKfcYS0UjyfWkGuro41z+2Nf6ARYxq1TviDFLWXdLCmpoT9E0lOurNv1Q4xHiMNtq6efq+xZU+4GyF/yjyRL2m4XzjuA7r9yLQUqa7+4TtTXJ5KG3Xa12lDqFs71FbnT2rzJ+jSrpHkYOT0EaLG1Duj1EeJGBn37fimngmS7DRyIMltzpYIM+reiMRfCGWt+iwNUpxX2PUynJ3+G8s1pGKAwI/9Sqn7nbOIciI3hRT0a+QmgF/3v9laSbxyPX75cs2/Pk5rJGAIsuWUdHJlYgmjSsxR2LzwlcKQRLsolfna/v1nqazusLg66pmofG5WwUgMieTWBvDEosQQmOUlWaZ5dVcEYalxkjqRMvkVO98n2DYB1fa7LgXIVMTqtvK/wOl456HLVdwBSmbht/reYiiAQ7uEK1cpWtdCWZ1fwQEQBISI4vYRLwunWF0+PdwyLR3Kx0mtu7WsdwKLzh2lSSLCIaYKYjT0BkECb+EbYqyJ8mGn5rIVDdhnE5kaZdHIhCM5ZmQkcxgwy/czbVokRc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(7416014)(4143699003)(10067099003)(5023799004)(56012099006)(11063799006)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VERsZ2pJSW5YWFdNL1FsSWt5NkZEZ3UrTTVZVE9mb2RwSFZsQk9kbVhNNXBV?=
 =?utf-8?B?b0ZjSGM1cU9XbFVlVS9hZW9WamFoL2F4aXNlZkZaT2JKYVd3TG8ra1gwamZD?=
 =?utf-8?B?V005OEN2MmpPcDludjBpcDhYQzJhQkhYS1BnaTVoaDNUZ051ZEhneTE2NVNj?=
 =?utf-8?B?SmE3R3dRUUFLbHUvcTAvTnc5NFdSN252NWRSdGNBRUFMWktCY1l4TjZValVu?=
 =?utf-8?B?S0tGM1I5cTdnYmRlazI4N21FdDlHOFUyd2twemF2MzdFdFB3bGpvRVNBak5Y?=
 =?utf-8?B?dXJiTXdiM0prT2Rid1hMcEtKQlhhak1BM000VU9LcnVSMWgvWmtXMEgza1JU?=
 =?utf-8?B?eUYrWEJZVlYybzVrMVpJN1RHMmZpODExcjY5SXRNbFdwdUZMY29kMmF3Y3pL?=
 =?utf-8?B?dktWTjRwM0hSMFRjVnpVb0RZWi82ZWlEVkpjRzFVVnJ1cDlnUmtpaFhtN0V4?=
 =?utf-8?B?UVd1c3Y3MzRoZ0p2bGVuNGYzL0ZDMTVVU3JCUzFoMExmSDBtSHd6aGxoeVZX?=
 =?utf-8?B?aVp1aURJRklGYk9VZTExd1NCZDEwTHYyWVU5cThnaGJhdHZXVmdLd2VCUXpC?=
 =?utf-8?B?V24xVGJnOFM2VldOWkdBTzkrRWJxVkszbW9KZnlMQWpHbVBlcjk4WnFZNWIr?=
 =?utf-8?B?K3FLOEF4dXlpMDRIZXZ0WkZkVVI0UzJ5TUthUTQ5Q0NGLzVwYWt2TXNSdWhK?=
 =?utf-8?B?bXExTGlSemlkbVJUdkNZSVJnQk83dUZpc0JnWlZmSjlyNXI3NzN2MllZMlNR?=
 =?utf-8?B?RVp3YTJvdEF1QkNKcG1WMG0zYmo1OVU2dGZaUzlWWE5DaDNBek5xWkN2akp2?=
 =?utf-8?B?Sk52bEo3cFAzNTFBcnJXUHlFc3BRRnN1UlI3c1J6Z0xWOHl0Umd2QmRvVytk?=
 =?utf-8?B?R25ZQ1lKWUorZzlmQWFZcVVlaXVuK29JNTBSMlV6NWJVRG9UWkZUWHZ6blJD?=
 =?utf-8?B?WTNHRVl3MkFSd1pLMEwxMG45VDUyQ1RtOVJqQkhxKzNVVzRVSEdzMHp1VkxY?=
 =?utf-8?B?VnF4NytWMmxEVkxNRlErbnVlYmtJRWZVaWdycjlVNHFGQVBDNWFtVURnS3RV?=
 =?utf-8?B?RkREVGg3cTVSejFlOWFFM2pZamo2NVF5YjEwQTRTRUtBSFkwUjVvL004TWpP?=
 =?utf-8?B?NkVVM0owZUpQV0IxZTY3KzdKREFIbmtweFNNa2UrbnlncVI3clBQalZiaThZ?=
 =?utf-8?B?SHZBbUF6UHJMMENtZzNxczNacS9KbzVIQ2tFbjMxVlk3Z2VtWjRwREVSZUVj?=
 =?utf-8?B?dVJ6MVJaNGEySDYrOUNEKy9zdlk4M0NBQndMTTJkYVRvR2JIVTlBVDJaTGE5?=
 =?utf-8?B?cHVnei8yYkdsRHpCY1FQeXU5UCtuTzg5WkVsQUZ6OUFNSDdyam1Zd0JmQks5?=
 =?utf-8?B?ME9Wb3J5bzFtbk9uMzZ0SHZITk5sZGhvMUh1SURJZVM3V0V3Uy9MditlUUIw?=
 =?utf-8?B?YVYwUjVKQ3QzbmFhOGhLbDZDNE1hVVVvNS9qbW5RMnROSmhQY0VaZFhyR3NY?=
 =?utf-8?B?QkdONHYyeTZXeFJveWpNVkJ5eFRJQmpEL2MzNE96ekZDZWszWFNsS3VmTU1a?=
 =?utf-8?B?Y3RDdlRoY1hOOE5UL0pHYnlFRCtMdUd1bUcxcVN0YUdyV1R5U0d1eGRVVUdI?=
 =?utf-8?B?Ym5NLzI0VUV1U3RRd2pDR1dxOGMzVlg1QUEzZlVRZUN3MU4rWmdOZjMwN1cw?=
 =?utf-8?B?VWxvUWViemhzVVp4ZWNOMTU3eUw5bFl6OUlPOXp2K1BXcFdsL0UzMFNES3Jl?=
 =?utf-8?B?T1prNGxkT0NxS1htUWQvY2x6bE1EK0N1RWRZZVdERnN5WEkwUlBXUEZrMmly?=
 =?utf-8?B?YisrcTMwUytOb01NK2hZQ21BMmVhc3Y2bENra0FncjQ2eW95WXdGeFFVODRs?=
 =?utf-8?B?ZmdnWUFYOHBRem5Kc1c3S2dVWVAvOGg5K0JEa2E5SDZFbVBSeGVldkd3NGFu?=
 =?utf-8?B?Tk1sdXBhbUdnS2l1SGhldFBJcXJ2WitVZTl0QkEyQzFCUXFySSt1dW1OQk16?=
 =?utf-8?B?K0hmajlNazBSWXZpTW1KanMzV0IzdStvY2lHaERZUndaTWFlY1RWakZGZVht?=
 =?utf-8?B?UUN3d2lFUDFyUXkzcGhBOU5oWk5BM3d5MStYVnRYRStUTnRSK2ZKU0pOenha?=
 =?utf-8?B?REFxM2lIcW9wOVR1M3pVWTVSN0lkRVA1SUUzbUdkV1ZpNGhwWEJFY2w5NGxJ?=
 =?utf-8?B?QnJqYzg2aUV4cGZXMGt6bUhKTDkzVXZVakNja0oxQ2dGWG1WTFBaMDFlZS85?=
 =?utf-8?B?WjJENW1FVldQR2xXa0F4dFFvVUNZTDZQQWdlUHFLam5pMTRRcGtRVXJ1OEY3?=
 =?utf-8?Q?rKdeXSa1motcBJFAlw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4056405a-a541-4f65-76dc-08df0b4af472
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 12:41:06.8438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pl+wmEmssfJb7CpHQ7MxQMLY3GuHW5WIEs3EKFewEXxFtu8G+4358K78HUHX8s9a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6849
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8F398180006
X-Stat-Signature: po8zfmebyyu3atisg937i5eqcrohw3hf
X-HE-Tag: 1788612072-457132
X-HE-Meta: U2FsdGVkX1+Uof1RUOnVyTWCobj4mSpePKZPgLkox7BWYFukQtt0PtJjbtiTKWGRoOJyLTvf5UbTBbbkgQP5JZVuC5VWDkCt2jn/IoNwInel9ax3UgMweF1vti/8KJ9LWnTDuUU7qJ5y06doKqhULd8wpAuIiw+x5GmUlD0uNzPne4xzEzgvbwYJfmS4LE7DIcXY/rJNPTnVBdklwqLGavogFtFN4R/fUgTQvCI30ghXOALGeyRZjiw7mkHzwdBwu4RFbU3/+8Qg3sQLRJvSe6q2s1/TMDeibIEk73z393qKlTAsU9zbYRUbt+y/z0sDGsTJ57OQVorxTj5TUDePNFkTqIV2vr1jwEhF0NKygRtk4bql4GgOsYbfj1KVbR1+YpexbNOrTF9UrfP3JOrusqPqOE+brviE19EM2ALJr0/clkPUxona2wAZZYUra0GfIJVnajPb7mT246Pr8Ep6bop6mzOFfmYSsPRQJnENVWbg0rC1RjxHwP1vg/hdcQTUJKLIUG6+BOWwU88j74IQ5fkLBVyCn6iRSxzI5m/9lTT2CkYlloLCK4xeAukqsqmN2Zik663vtOxRnsXvMRj2VJs6IkfGcJEz1NbN7Uua/X7rnJMmMMKA5fR4yVODMfbl9NEnmiw0hBx/akdqkdyeChFANoyXLmho9s3zpadjLjq56ZO7AooJNL89/56zewdbac40FVTaXhrjPS3Hwn1Nye2p7kQzNmdxQFjiumpO6/kYcwQLs4pwj1Af/OCJSlHJCTmgk8Ee6hMaTAHBtzEn+P1uciyDsZ9/m49H9PvPkL62lBKoX2YxiLtIL1O72wsVyWe01ry1zJB3K330I7b+Q3wYGAYf2ETJO4ylnGLAjWKog9IZ+eaRF11fWXyhXiLQY+bZn5GOVJRB2he1BVVi3NXhgST9NA1jh/k0GGj97Vz5tZv65Qn7HIPq7ym/rkWvP+fcDLHEbm46QdRitj5
 U95VVgdX
 Yc0FU7WGYzPn9owo8LnMj0xaXkPpF/pYM8iv+HHugWPePHwO+5FQ6Bvf8hkfuKvxwu0kRZRVGJKZ+IebQrpbKWiL44J34cra8AFpKlzJf5yWYYzr17lZSnSoAwl246Pq18MBNOKKwclTWYYPASfamY82FP1zw30T2oiRe6W1NEzK49WulS96rsD4uCgjU60K43Osj6aNjrlk6pu/LeANN3YPYkYxCEwM5o2mFv19PxWeja7LBRiRhFViKuN3s5f8UwQ7P17PslwXMmvcTedybJtRwUnMARAEefENCR94ARCVnlab+2EJ6+9Yg0e5Wl+Iy+kZV7OBGR3cj1QgQaa67JLGhVI9BikEHqBDBPw9ailvAHtxE1FjOXgEsktmgfPZXkmQPjOxu9Sh6ihElf/YuYrMt1KhJiGFf0bQdeajulwXYzk3fCJBTcVnB8nHLEt19FtuN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Sep 5, 2026 at 5:15 AM EDT, Zhang Yi wrote:
> On 9/5/2026 3:31 AM, Zi Yan wrote:
>> On Thu Sep 3, 2026 at 7:50 AM EDT, Zhang Yi wrote:
>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>
>>> truncate_inode_partial_folio() splits a large folio so that the caller'=
s
>>> truncate loop can drop the in-range sub-folios while keeping the
>>> out-of-range tail. The first split at the punch start edge is
>>> non-uniform, which leaves the sub-folio at the truncation end edge as
>>> large as possible, this means it may still straddle the range, holding
>>> both zeroed in-range and valid out-of-range data. The function then
>>> attempts a second split at offset + length to isolate that tail.
>>>
>>> If the second split fails the straddling sub-folio stays merged. The
>>> function returned true unconditionally on all exit paths of the success
>>> block, telling the caller it was fully handled. The caller kept its
>>> default end and the truncate loop truncated every sub-folio below it,
>>> including the merged straddler, discarding the valid out-of-range tail.
>>>
>>> For example, a 4-page order-2 folio punched from offset 0 to the middle
>>> of the last page:
>>>
>>>    truncate_inode_pages_range()
>>>      truncate_inode_partial_folio()      # same_folio =3D=3D true
>>>        1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>>        folio2 =3D p2-3 # straddles: p2 zeroed, p3 tail valid
>>>        2nd split of folio2 fails / cannot lock
>>>        return true                       # BUG: caller keeps default en=
d
>>>      end =3D 3
>>>      loop truncates p0, p1, p2-3        # p3's valid tail is lost
>>>
>>> This became reachable after commit 7460b470a131 ("mm/truncate: use
>>> folio_split() in truncate operation") replaced the atomic split_folio()
>>> with folio_split(), whose non-uniform split can partially split a folio
>>> and leave the end edge merged.
>>>
>>> It has gone unnoticed because a dirty large folio normally carries the
>>> filesystem's private data, for example buffer_head, so
>>> filemap_release_folio() -> iomap_release_folio() returns false on a
>>> dirty folio and folio_split() aborts with -EBUSY before any split,
>>> leaving the straddler safely unsplit. The bug is only reachable on path=
s
>>> that produce dirty large folios without filesystem private data, and it
>>> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
>>> attached.
>>=20
>> Thank you for the analysis.
>>=20
>>>
>>> Rework the contract so the caller is told where to stop instead of
>>> silently truncating the straddler:
>>>
>>>    - Return true only when a split occurred, false otherwise. This
>>>      clarifies the existing confusing return value semantics.
>>=20
>> Should we do "return false" for not split case as a minmal fix first?
>>=20
>> Something like below. A second patch can optimize on top of it. Let me
>> know if I miss anything.
>>=20
>> BTW, Claude also mentioned that if min_order > 0 and end is not aligned
>> to 1UL << min_order, there could be some issue. So
>>=20
>> ret =3D !folio_split_or_unmap(folio2, split_at2, min_order);
>>=20
>> should be
>>=20
>> unsigned long idx2 =3D PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE;
>>=20
>> ret =3D !folio_split_or_unmap(folio2, split_at2, min_order) &&
>> IS_ALIGNED(idx2, 1UL << min_order);
>>=20
>> ?
>>=20
>
> Hi Zi Yan,
>
> Thanks for the minimal fix. I agree with the core observation =E2=80=94 t=
he
> tail is only really isolated when the second split and the boundary
> alignment both cooperate.  However, I'd like to point out a trade-off:
> the "return false to make the caller skip the folio" mechanism leads
> to an incorrect 'start' in truncate_inode_pages_range() and over-keeps
> the in-range sub-folios.
>
> The problem is that the false return value was designed for the case
> where the folio is unsplit.  Look at the caller:
>
>          if (!truncate_inode_partial_folio(folio, lstart, lend)) {
>                  start =3D folio_next_index(folio);
>                  if (same_folio)
>                          end =3D folio->index;
>          }
>
> start =3D folio_next_index(folio); end =3D folio->index only makes sense
> when folio is still the whole folio.  But after the first split
> succeeds, the caller's folio reference has already been transferred to
> the sub-folio containing split_at, so folio is no longer the whole
> folio.
>
> Concretely, take the commit's example: a 4-page order-2 folio
> [p0 p1 p2 p3], punched from offset 0 into the middle of p3,
> min_order =3D=3D 0:
>
>          [p0 p1 p2 p3]  --1st split @p0-->  [p0] [p1] [p2-p3]
>          folio now points to [p0]
>          folio2 =3D [p2-p3]              # p2 zeroed, p3 tail valid
>          2nd split of [p2-p3] fails    # e.g. -EBUSY, or can't lock
> 	=09
> With your fix, ret becomes false, so the caller runs:
>
>          start =3D folio_next_index([p0]) =3D 1;
>          end   =3D folio->index          =3D 0;
>
> The truncate loop then does while (index < end) -> 1 < 0 -> nothing,
> and [p0] and [p1] are left in the page cache, even though they are
> fully inside the punched range and should have been dropped.
>
> To be fair, this will not lead to any data-corruption problem because
> p0 and p1 are already zeroed.  So as a minimal fix to stop the data
> loss, it is acceptable.  But it still leaves the in-range sub-folios
> behind and wastes memory, which somewhat reduces the benefit of
> splitting the folio. So I don't think change the return value alone can
> solve this problem.
>
> What do you think?
>

Understood.

Alternatives are changing folio_split() to make sure folio2 is split.
From weakest guarantee to strongest guarantee:

1. make folio_split() return with folio2 locked: but others can still
put a ref on folio2 to fail the subsequent folio2 split.

2. make folio_split() accept two split_at, folio_split() does both folio
and folio2 split internally: but if folio2 split require an xa_node and
the allocation fails, folio2 split can still fail.

3. make folio_split() accept two split_at and preallocate two xa_node
upfront: this should guarantee folio_split() to either split both folio
and folio2 or split nothing, but it specializes folio_split() for
truncate.

I guess for now it might be better to make truncate to handle the
folio2-not-split situation.

--=20
Best Regards,
Yan, Zi


