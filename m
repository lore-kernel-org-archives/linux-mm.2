Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF4BFC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 16:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33506B0088; Mon, 14 Sep 2026 12:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5A06B0092; Mon, 14 Sep 2026 12:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57676B0093; Mon, 14 Sep 2026 12:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 757986B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:25:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C414A0105
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:25:07 +0000 (UTC)
X-FDA: 85212892254.30.1531525
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011046.outbound.protection.outlook.com [52.101.52.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 56EB51C0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:25:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kM3mnivu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789403104;
	b=h720IkG38dRRYpZY2cIE0OcNyuIE9kYjTqSPiCEtQkmVjnWV9MJSYT4JW/RTTt7j/4fKTl
	tefTNXhcQOEGoYCuRhmuLV9dG32UaSL777cZR1BaO7FICUE8ToQa7aWuL4yfMsFnLPMPDx
	5NlkNxxP6i7elf6+IigTr5TMVX3QFnQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kM3mnivu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789403104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XrySJZJHv9uKqtuSvBa30Qrzuo8yFq2rvwl+NYaEIns=;
	b=TgPB6gp8N+q73gjRVrGPeYDE+wQgu1IHJhbp1Eq28VZnh6XXg1okncQmRjvIGekuX+yRlZ
	8KLH1GDodtRfJlnA8liNCBm3Nh0ZvX/G8J+PnoCrdB4SOcoIzh1r0i8pLNsp1LzkekKzSx
	K5cfLImy2yku078wLtrLXrYtjPIXRUI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gK/NZY8R+vNxuec9qZwJxV33qj1zvSKyPorIbXBj/0AsMSPZsUTe6Z8iNiMA3sDfQrN+7B6jN230FQXEnaXz50aHKFwc3FXS3bnMlPvR16VZRkNwOO5gAWrDElrs71/Zw0lS+mVZZ+h4le9JIfA86whhQsHuDsLcffK90FIdp0e81gUAO3fXFZShhcmWiaBMddX2R0Zj0exE2Vm3IL73aHGdAUa5dYBKnraIhTL3/7L0H/ca2RKiyN4j660NKWTkuncQZ4cbWc0D/TxqvXeF8nCsxfosYJ8aThQGBEZWDwwSGrADdFjq3dqBBYggMhbhfvr5JoHy6hg6yp6qvQCHNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XrySJZJHv9uKqtuSvBa30Qrzuo8yFq2rvwl+NYaEIns=;
 b=n736RUgGzYBzDwW2Ji8yrc9qBNZYbLKV7hMsLQspJ8826Cu3Blda+zq+qfrR4NGHq9x6ZAmEke0/XNqu1ejdv7HyJiomtMl+/LFqxMb04DBXqmucIJ8AQg5qyqqDLE9bfmN/7iOdsej/fCd0sruB9iafEdBATnVDuxN2qxbotCDcKE6H9acn7LL5AlZGPgnQbreWMAm1SeoyzU9s1cLYe2blqVChhfujWDa+5eXimm8KbuCI1wAQjG/+96VHdeE5yxiVW6HAPXFT1dmc+41+HHmYgfb0eN+v7TLju+jcFrAilHNFsFLDPpvICWvm8rXXwJqmWqnP4bMK46tULLXCow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XrySJZJHv9uKqtuSvBa30Qrzuo8yFq2rvwl+NYaEIns=;
 b=kM3mnivuocAlwXWqWNTq0W3uDN4a21bUEf9ZUloji88zs516cRpnuoxI5EkWFHS7+PdnlTMuV7m2eqbJHsSjTFtKatqkBRXHWyoGvmuqExH9BX6KhRTTrzoZcOgMf8ShH6Z9VcihMibO7ax3gUw8qyekxcLOotr5yHXcBSraA8L20oikC5UEC/1A9X5WuyFndN2+9YmdXOnSAHIWfVz+9tcB8fBV6fJ2Pyb9Olh5hxvYQVNzObpPHmJTYrCgTRlIWdR3+jCITIHE0jF3NexE05vsIv1sxR1hm/iidcHUlslqgrysabpKeAwZGNAWXnaW2ZwhTxW1ozL9fJoEH/7h6w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4048.namprd12.prod.outlook.com (2603:10b6:208:1d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 16:25:01 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 16:25:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: sashiko-reviews@lists.linux.dev, yukuai@fygo.io,
 linux-raid@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org
Subject: Re: [PATCH 2/3] md: Use folio APIs in free_page()
Date: Mon, 14 Sep 2026 12:25:02 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <2F873AFD-7428-4937-8F4B-A2346D1149B3@nvidia.com>
In-Reply-To: <aqgfA0QFi98gXYG2@casper.infradead.org>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260914041830.2072626-2-willy@infradead.org>
 <20260914043129.C6F8D1F000FF@smtp.kernel.org>
 <aqgfA0QFi98gXYG2@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:408:fc::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4048:EE_
X-MS-Office365-Filtering-Correlation-Id: bc4bfb60-e73a-46d4-b5a9-08df127cb96c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|6133799003|22082099003|18002099003|4143699003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	IWwlpVWScr3/p2Y7u7hVw/mx0r6yG6FuVf0hpOTJP6fiPdBTnpextpU369CmWRbjCZ+7+soUzwh/uYAr/d7TD9E0Cg9eTu5mRUkNu1vONKFBHp5pBBeyMd32ES4WEbo8HCN21x2gAlofSpYh+BOIAYwokaDu7ze5GWx6AQAYj6mCyaoZFUKBBx/0ErhXYy3PoyVbBu5N7Wd7MUeRnGK77v+q3bo6MRksc5bXgtXrZ3Z1DsSCXgNgXwHWJCdIv8EGLEtYEuSZ547nQ+1MkI3Zjv6lmw+JnHyIinp6k/Cd2S3UtSCPb3ubGPdzn7Dvjy93FQm3dai3cruJiHpVCGGinIz90pTBIHbqpQixKgaH8XRfm/5EA7ESV9moZGWMjuzTveqZmvguIBtGhdmKQBg94qviZ2sJgkViy+tBCggDiYDhRhcK69nUMjXXeYchEuh12ffCBhN29BbyHv6YRplqtzAmGtyf6Vi7FFIsGa0AC5774Ndi/zxnyi95W3woLLQjbFj0qicy3vT3FPUL8oyqVy6ZgAZ7I08h7jChFg+H9pYS4s8hPv7Jd0bha5fjQa49dmoLeO5tj/+JWoSg/ybjoI8V+HLotJV7xyM1bnEqnLWHePh186nfLVVeUFs9QH2rjtRWoEArJMULR6KhsZmlWFizPXHcnwl1rlNCWCZqkH4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(6133799003)(22082099003)(18002099003)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXFrWHMrRlhUQ0JPdE1zbENaVGNqU1ZpczZXRk1pb0NLNXRrdHRlMmlwSVVS?=
 =?utf-8?B?V3hScUx0Z3hUbWMrTHgyUzR2UWFPOVloSzNiR2Z3VDJ1YU9hZ1FjRDVtUEd2?=
 =?utf-8?B?SGFvcEVIQzROc1FlNzVxWXVOZE5MSkhTaEtCNGxBMkN5Q3dsRUJ3THh6WWI1?=
 =?utf-8?B?bjlMQjdlbDFJMEZpejcwalkwR2FIZ1k1NWZrL1hpKzAxMkZPOE1SNDlPMVR3?=
 =?utf-8?B?NjJIeVAzTDBmOTBDYjZYTktiR0hOVkgvV0JOaEpZdGRmNW1rYUZ5azRFWXhW?=
 =?utf-8?B?Q3gzcGJTa3puOWJIYTRmV0dGdWx4KzI3cVA0SUxiK29kMllFL09tMUxXc0t0?=
 =?utf-8?B?Tm5RTFpib2d4U3pVYnFMTXFNa0RPUTZ1YWNrZ3ZiTnVlU3NKZUtBYjY3L0o1?=
 =?utf-8?B?ZU5xcW9waTVUTFAyMU5GUkt0cTVCbEY5WFFTOEtOM3pEOFRuTGU2d1c5VW9y?=
 =?utf-8?B?QkV4Q0UxZ1RoNjExUzMvWFJRb1VIVU55SUc5SlIrQkFudUYvV2ljbEswWmJv?=
 =?utf-8?B?SElvVWgwVjhhU1dqRWhQbHlMek85UUlkQTZJblZsMFM2YW9pa2lBdzg5b0Vt?=
 =?utf-8?B?d091dTRpbFp0R2E0ckYvMGMrWlM4RDVkT0twQlA4L2NVRjJ6L3FiRWM3b0w0?=
 =?utf-8?B?RHN1a1RkV25mSjJMS1N6S2pHOVppOVRMcnFPTklOdU1UYUpkU20rdmNPYTMx?=
 =?utf-8?B?eVRCY0FSQm13WTZZajBENlRnQThHcW0zM1htNmFvZlhTWFNnTGhTdnNqdm1S?=
 =?utf-8?B?N1ZvVU81a2VIU0NrUEFXTnlUcGhDS0tvbmNMTEx4TUsvSzJSbE1ZMTVSVElO?=
 =?utf-8?B?NzVZbE5JZXVSV2ZhRjVjK3RMMGpXam84TlcyQlZzWlJDRnFjYkc5K1RsZzF3?=
 =?utf-8?B?dlRDaC9ick5ub3VuY3hrUzZsbHgvZ0o4d0lzQ2p6eVd5M25qM0k3c0JuekpC?=
 =?utf-8?B?eGZmVG40VE1rTVdCalc5a2h3SGNyR1ZDVCs1N1dGN0FnZEdnN2QzeUxYRlZm?=
 =?utf-8?B?VnRNbS9HMjU5UW1CTE9HcUhEbXhnYThaMWFic3dGMFFSUGVvWlJvTGFXTWM2?=
 =?utf-8?B?UUZ1QjV0UkdTOGsvQkR5Y1FRNG50YWVLUEJMN0RveU9XOU5ZT20waXI1SnFM?=
 =?utf-8?B?bStPOTBMOGh0V3hoQXVPTXlyVWpxMHJKTUZGU1pMbmQ0UEU3SGVnbXFQdDNC?=
 =?utf-8?B?QTNxZ1lVeitCZ042dXZSaHNTVHhlb29pSkFONVV5Z3pLalJ0cFlTdGROV0E1?=
 =?utf-8?B?NTZiY0kwekpyeUlKUmJjQjdXandWUjBmczV5OGtxRXhnOHRPWHZMS0VxTUhS?=
 =?utf-8?B?NTl5WUZwaGtkSmlDV3ZjQTFIRzZGR0ltTUlJUU5FeHY4b3h5eXRRYVlhS2ZG?=
 =?utf-8?B?cWpibHN6K1NPejNib2FJMFFpTEN5blY4OUo4Z3J3TWhwYTdEUCtkUUV2bUJY?=
 =?utf-8?B?a1pVMG1Hekd0eXhyMkQ0ZkQ2Qy9qa0UvZTFMYWhxM0pYcm9qOXMzZ2x3aVVC?=
 =?utf-8?B?T1FlTktlU2NWWTAyMm9SR0ZtS01UT0VxdC9qTHJIT1NUQVJLcGtQaWtTTUlp?=
 =?utf-8?B?YWdpRWxXNkNITVQ5RHNsa0d5cGVUeXBjS2RuWm9ZZ0ZUNHJCREIrSDVsWGY0?=
 =?utf-8?B?b2Z5ajZhU3pPM2ZQaDl2UjZ2bm5CZ3ZaWllSQ2hjL2RCc21pR2RaRnJ1VFhW?=
 =?utf-8?B?VGtSMG1UL29IS0ZIaVc1K1RiYlhvMWFnZTdTVlloRDgvc2ErS1d0SEVNOW5Z?=
 =?utf-8?B?ZGJSWmtYakhmUWQ0YytiMFF5RldUL0t2U0NqRDA4eW41SC9zMzZubHR1V1RN?=
 =?utf-8?B?bTFtV1pqaDd5RFF6RXhLNEN0K0h6ZlB3QmR5ZllpZWVUcXFMWWxSMDUxYXJr?=
 =?utf-8?B?Vk1kdS9JT0VzNVBTVFpEZlNCK3ZOSVVXR0drZWg0NERUYVZEbEZOV0pMVGlv?=
 =?utf-8?B?SSszWnF6UWpGd1dLS3BGMThHUkF0M1BSaWlVOVZUcFFPbXNwR01tdVJId0h2?=
 =?utf-8?B?MFJSZnd5aWZRWVBxQ1dOLy9wTGowME83cUR4cFpjd054NW9UcXk2TW41SDRR?=
 =?utf-8?B?VGNpMzFZWDBua3BhTnBBc2pPNHJ4YU5XRzJCNWsrRVlPR29YNm5ZWHZzUW1y?=
 =?utf-8?B?bmt1K21icUdBSFc1aUdkTU9CaUV3UVNJdWk0ZG9HNE5RZDVjaHdMSkdOankv?=
 =?utf-8?B?SlhLV2MwWDZTYnBCNFFHSy9GWFVyRDJKQzk4QjViM0hlTFdmRFVJMm1jb2Fi?=
 =?utf-8?B?OGVmbk5lWlg5bVU2ZXplOHhiUlp1R2xzZ212ZGxpclNRaG9aY3MrR2ErK1Jy?=
 =?utf-8?B?TW5GUjdCajhxMlI1RGZnNHYxOU1YTWV4UlA5T0E0TmlhT3ZzQlArZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc4bfb60-e73a-46d4-b5a9-08df127cb96c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 16:25:00.7597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nxs6wl5GqhzG2l3XmDeaapDAAT/VoAzy4LYf29IRaHN9HolZAQ07Y5SY2Ov0OImM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4048
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 56EB51C0002
X-Stat-Signature: ww3ej5hzf9e64cwcxs5k8qxbcqpgbguq
X-HE-Tag: 1789403104-302419
X-HE-Meta: U2FsdGVkX1+mYppoUTBLX807EfmHiiGE+t8c84Iw65RXgU58zqDyDGbf2ZHqi9gzpGgpZOC5fkGaFoDQ+uscYnErgNyQggBpRw+2lmCmQlKMD/VrP0nV6oxthVwvnHWZfAFf1t5lVKBGz/7CssdDjYN2//hygSFUrVWYLV2MhU9W+etPQ/Srf8e9/J3HKFyQJy4VjBhnxqxaOtZ1IYrl9JCIxqtoG3bfjstlzpobpP2BcFY1s+LtQiaYSG09g6hyQxHmv0sRr8WBtsc0rWjebwpWjBeGRCYO8MYGxM2wN478wztYQZm4dIxoXvRyDyO7IOivx4oAZVY1gcS8P7SkYA8ndwIIzw7hVfu1LfuQh2EJpwSbvtRj2u+ZlhDQzI0tYvcn3ZkvtXEmdxiqRjhyJTq+IQBNjNly3+Lwqh8M1zm5cT+cFbQyYHtIgLKhMTwpYxG62koBRsP+Vnm0dcOnLd6Q7yuR8S/WvywoE07JNYaqB/ssSitEteHnXOO+jaAc6/72Ex3Te5MqCuoclTTOM+SSC0rOy/9uX7CgMl6f/U2x/b2kb8k5Z6oxtgjmCtHYdbxeb8bmTg40VtJnaMFsn2uhj7bo9HsTTtu2nmiaV7s701lU8ZzyhiuUo2iA1AjqdEN2jPMTInP3JviXlfkV1SJl/na/4A0RsAjyPYMi6NvkwIlIiRZqrsDQlQwjO57PrV3MLybd8tBoI77i1NkMY6jI742wJzsG5x7U135O2+b+WM6oWw0MNrPjcKbsY5EvfGN/npS9Ky0wlMCIMBuFC3SvO2YrFUNCNzmklducY/Fpa4tmpH5TeX7saRlWG+HtzW71l1IaVa/x+yHDagpE+HTBA7PD3zdXUzjvdYRlOEh4VcM3taN3FXKRHEUbUr2Qd4pf3AeQ+//bewZ8p528jgiB9QCU+NtGHm+Uwx1JZuSoC9q6aaCXCLCpyfJxN7j2pZXL06ix7RfIdpeDryf
 cMc6vIJ3
 JXuSeLsK9iH7abNmDT8y+bY+EAxrsApWkFggaqfurP0bpcEGPRoO0YHpzG6Key10+OzhGwNVQaZ4GcIIl4ZZfVG2v8mxn3Qm0c2+m6enIHX4JOI5yP36Nkw/wND5QYoYyM2smEM+XnCgYlkRnVFpwGWrmNSmPiNFpYgE42ZMu7hXfRGtyd5NvwJpDzjTErcedVi15WxEx4ZOAdGe9mNAgj0LO5Hm+IURbf6vJuuxr9pMzjZ2WTyBPqUfO+syKx9ktgFeJM39zwKsghcoaD15HHquEbxxnE8jl/y6Gt+Gyy0LrbcN5Sv473eoLSZq+GajLcKJLELLGtStTkW1oXoAUk4eK/ntLIu3x0xF1tuPUJDZpX5YZuNbQd+r1SditnKPhomlPBkUVYJvu989cBfguvUo15LaWGlcecIwxfR4FtBCCE8oQQyuZpVOy0/84/qEQKhG0Me681l0+r8LiLKEaiVG3uZeh4ofulgBqljdEaLKqA3mye4iVmjCQAdcRTj50PGnVLG2fUHNGzQwpLthi5u/tsoKcWqXP7ydV3Ow56lj7GGvdgNqMdKwu6VMIjDb/3Xk1FtUw6dHVO+I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Sep 2026, at 12:21, Matthew Wilcox wrote:

> On Mon, Sep 14, 2026 at 04:31:29AM +0000, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential iss=
ue(s) to consider:
>>
>> Pre-existing issues:
>> - [High] Memory leak of internal bitmap pages and uninitialized file bit=
map pages during teardown or error handling due to an early return in free_=
buffers().
>> --
>
> Yes, I thought the early return looked weird.  I just believed that I
> hadn't looked into the code enough to understand why it looked weird but
> was right.  Since the AI says it's wrong, I'm happy to believe it's wrong=
.
> It's probably not really a high seveirty problem because most RAIDs are
> set up once and then never removed, so the leak doesn't matter.
>
> The other thing that looks weird is that this code believes the b_this_pa=
ge
> list is NULL terminated.  Most loops over "all BHs attached to a folio"
> have a circular list.  However, that is established by link_dev_buffers()
> which is not called by md-bitmap.  So it's correct, even though weird.
>
> The good news is this is an easy fix:
>
> @@ -536,9 +536,6 @@ static void free_buffers(struct page *page)
>         struct folio *folio =3D page_folio(page);
>         struct buffer_head *bh =3D folio_detach_private(folio);
>
> -       if (!bh)
> -               return;
> -
>         while (bh) {
>                 struct buffer_head *next =3D bh->b_this_page;
>                 free_buffer_head(bh);
>
> I can submit a new vrsion, or Zi can just pick this up.

I can fold this into your patch. Or should this be sent separately
as a fix and maybe a backport?

>
>> commit d68f524234e61e6567e52a27e09b9d2546ab54af
>> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
>>
>> md: Use folio APIs in free_page()
>>
>> This commit converts the page to a folio, removing some of the last uses=
 of
>> a few page APIs and replacing two calls to compound_head() with one.
>>
>>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>>> index 5f1637f974c15..7b42db87d536d 100644
>>> --- a/drivers/md/md-bitmap.c
>>> +++ b/drivers/md/md-bitmap.c
>>> @@ -533,19 +533,18 @@ static void write_file_page(struct bitmap *bitmap=
, struct page *page, int wait)
>>>
>>>  static void free_buffers(struct page *page)
>>>  {
>>> -	struct buffer_head *bh;
>>> +	struct folio *folio =3D page_folio(page);
>>> +	struct buffer_head *bh =3D folio_detach_private(folio);
>>>
>>> -	if (!PagePrivate(page))
>>> +	if (!bh)
>>>  		return;
>>
>> [Severity: High]
>> This is a pre-existing issue, but this early return skips the folio_put(=
)
>> required to drop the base allocation reference for pages that do not hav=
e
>> buffers attached.
>>
>> For internal bitmaps, pages are allocated via alloc_page() with a refcou=
nt
>> of 1 in md_bitmap_storage_alloc():
>>
>> drivers/md/md-bitmap.c:md_bitmap_storage_alloc() {
>> 	...
>> 	store->filemap[pnum] =3D alloc_page(GFP_KERNEL|__GFP_ZERO);
>> 	...
>> }
>>
>> During MD array teardown or failure, md_bitmap_file_unmap() calls
>> free_buffers() on these pages:
>>
>> drivers/md/md-bitmap.c:md_bitmap_file_unmap() {
>> 	...
>> 	free_buffers(map[pages]);
>> 	...
>> }
>>
>> Because internal bitmap pages don't have buffers attached, (!bh) evaluat=
es
>> to true, triggering the early return and completely bypassing the folio_=
put()
>> at the end of the function.
>>
>> This permanently leaks the pages allocated for the internal bitmap's fil=
emap
>> and superblock.
>>
>> Does this early return need to be updated so that folio_put() is still
>> called for folios without buffers?
>>
>>> -	bh =3D page_buffers(page);
>>>  	while (bh) {
>>>  		struct buffer_head *next =3D bh->b_this_page;
>>>  		free_buffer_head(bh);
>>>  		bh =3D next;
>>>  	}
>>> -	detach_page_private(page);
>>> -	put_page(page);
>>> +	folio_put(folio);
>>>  }
>>
>> --=20
>> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260913-remove-=
pg_private-v4-0-848550f7574e@nvidia.com?part=3D2


Best Regards,
Yan, Zi

