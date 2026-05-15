Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D7D4CD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4119F6B0005; Thu, 14 May 2026 20:09:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2BB6B0088; Thu, 14 May 2026 20:09:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289E96B008A; Thu, 14 May 2026 20:09:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 146A66B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:09:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 749A3A06F2
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:09:52 +0000 (UTC)
X-FDA: 84767721024.15.6F1F617
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012022.outbound.protection.outlook.com [52.101.48.22])
	by imf16.hostedemail.com (Postfix) with ESMTP id 878CB180009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:09:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=juIbQ0jh;
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.22 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778803789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3oUsqbffuHVEIVkT1ssp7xDk+m+EKEuD3yhh9fyzqIA=;
	b=6JPHTI4vyySZq8e7Gl53BFX1v+kTyS9WUYg5FAneppe+0bdy8n/8K7o4UGQ1QQOA4pIpEQ
	GJWCmXrc+38QKZ4hwP2Ff3dyCvRwJDYkl5BS8a52FnBeXqfd6ALhiVhAntOEzo5SYWJ9K5
	i37uuZ6RSAC7DZO2WSg6bnZ1cQwQqAc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=juIbQ0jh;
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.22 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778803789; a=rsa-sha256;
	cv=pass;
	b=oOVmuqTuw+h+R2YYbEoByOW16pcG2ZMu5Z3nu19NDxakMqAiKoZXSvMEUO9Ay3h0NGyJta
	v3ay9xHycei9+8jH02c1amxklmryf0fpJxFXr5CF9p+ccR0eq9174EZolkTkHwT1t9jLPO
	moQSGTuc+TI6xW1a/FhtLxB66OjWgl0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bk/6MKDO+qw183nA11dhiAXk9NydapT/145PXk2wL+6OIUaDazpKF0vS/xzALb/j7tCxIg2HminlF4mtqpcMjKMcu0p+URB3p0KNgVeUWnmFpm2q/YBRT6ud4duwo4mG2Yb6JsGK3kUvhQ8HE8a3MnYwsEqzwplK79CjFZyTuxY9Kg0vR1w7srTkzlVSTFyUFm/F4yVzLsFz51fhuz3gQSgYssRhlbrqqIdJQ3FrRAh1Qh42XuY8LiD/0ZWZ1t7il8OoNktXRu3KgBVy+1gtS7kE0viTRcnU04PzKHhys/8xRJxpcf91sHs/H9vb7v57Ut3x4r5Xk7FCtVdrm+mMzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3oUsqbffuHVEIVkT1ssp7xDk+m+EKEuD3yhh9fyzqIA=;
 b=AMNcyYTT/R0OPZpuBEFw88i4xmbsfNICNnFTtmEE7QkAOgpWB+JdJnmQy26YOl9YwZvuiIKpRyNY3kQBE8mNxlfOU1W0bQHxXClX+Y0Ou4dRdng/Pv5dHVRcIUylzgaIMCNQfMGqXXh25vZT6ch88r0NsiurwSRXYuyrlEnDtEMRVWSetH4rLmHQB+gyxLcEP6DT4sgdlVY1+AoK0En7QV+39FT424hsXDmaPNJvBWohit0YQhYA5QccHlrS2AfRfpFLNIJ5QhMNTiam/m4z3Nnk4iu8Q1ychX4ZCyRVbf9NuKQCMGpZCFKTGg85CpLW1sAnzauv0o020+JOFYf8uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oUsqbffuHVEIVkT1ssp7xDk+m+EKEuD3yhh9fyzqIA=;
 b=juIbQ0jhzx3q+fqbzJHvOfwfBr6m7r3PQYHGTMX4NVkRL5ltTBi9GC4ttaWwlscfVNlJjOx7+GUmoSIsnL0DFsZ2OfGbdPDch0qLcbHJMtIGhXAH8A2t8cZAtKtBZtU6CiOtZYt0rEEkUtzqa5pt7V1n5as9q2hEZQeZmNy0gCv2RbJuhOMBkOoOrVXBQ2IPswdXQtiiWQ1+oINpLrD68xULH1ctxssyI4crlsMS9RV7VjFDHFLqLwYuEW/gtq38DrFuihHkUQisCNKx7SwUDEcUwOr7Z2dgN1ALGH1CD9IEvVCExXeLHWmEbk0WvCIdaN9O6dVk8jfkJLyJMFsvpA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DM4PR12MB5818.namprd12.prod.outlook.com (2603:10b6:8:62::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 15 May
 2026 00:09:44 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.21.0025.016; Fri, 15 May 2026
 00:09:44 +0000
Message-ID: <08afbec2-bbe7-4e8a-8d99-8a5eaecaeee7@nvidia.com>
Date: Fri, 15 May 2026 10:09:39 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 Mike Rapoport <rppt@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org, Sourab Gupta <sougupta@nvidia.com>,
 Zi Yan <ziy@nvidia.com>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
 <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::36) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DM4PR12MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: 92e4070d-c644-44a3-0067-08deb21644a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|11063799003|56012099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	2AYI9AdG4XoaQZmLHuThopuJO0wSMXWprEIVOb854R2N4/QOJOSVxefol/EZLZ74wsAc6AUNkC8yfVemILokxN9cRgIndEgKhsqmU2wp5C4QrRm0SKb16V32nnShNlPFoQEE8/crFGt9F0Gt9oH+pMCJ7f9tACtkN4KcASMLnicnrAmGd9CTdsCTwYLkaP4BRocCVTYgp4/aUMN2siQsBC9RGevJsMCnrqQm4ObT5TA5tUZLiy8Kh9jR+QUcnjzp7HXSAghrhYoQRzcOwiv5LDZeuCXuVdaRTzhEF1vhN18z3Yu2iu4HZq7pkpFVq5nwtf7LbS2v3p0nDr/UGjdtW0K1JKQPxHOb6i6GxetgGTGYse5govPF1SvMdtNaxRd7WnpmOf/CTsi9HEleyFyjxT+2+SWVzenIwTeqKWYye85zaDBwlgnF00BIGrP1DJAIidqGKaItI88Cc73OS+nSanaGwMFdoTfN+S67hjJ8hyd/Qyv0bPH5XSqjC3NiCvROy5nMibEi17zMtpjZCEMBhc9Z93I55BGkDRHB0xmZoL9S21r0UudNQvJugF9bTOV4m+nZlyzfkjmadUz723k14/yXz2C22kFqIqZUiUC7TCXkBQVJdfvHhIhQW2VWfYRXPN4wp9yAPm9WbfhBBDsGufeOBbdgQD2Vh+8apkm18bHLx+ItJlkbeI3EJbIVGVrO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(11063799003)(56012099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VENPaDNzT3QrUzNGZUZ1R2x3NjMzM0tNK0Ixc0dMSkxsN0VLYmJNdDhGakJB?=
 =?utf-8?B?eFZHRzUrdHBDUEdCZm5veUxYaEZ3SDJDU29pUnJpVzIzZC83cEs0aUx0eHcr?=
 =?utf-8?B?dmFXd0VmYzJxZ2VhWS9wbkdWTjBTS0k3RlJ1SDhESTE3ME5NMGJxVnBrK3ps?=
 =?utf-8?B?cllBS3JFVm5rRmtYYkVaUHUwY1NtQWRQcHRnbUZJVVdkdy9nMkZrUUJhTU5h?=
 =?utf-8?B?aGw0aVFhcUJXR3B3eXJDSngrT2N2eFp0emlmMnFnYklWMU1lRVBsWlBJVlRN?=
 =?utf-8?B?SXA4Z0FsLzB5eXAwZnRkNmJKNWMvSWMvTWY2Ujl5VS9Kdmd4a0RSU0NPeDM4?=
 =?utf-8?B?VlhNODJDcXlON2JpempqMEp2aTBld3hIYWhvR0tXWUhMTU0vdktlLzRXSVlD?=
 =?utf-8?B?SmhPMmJoQ2t1TnZVL2Exc1JnYlE4YzBjbDN6UUhWOEhiYks1TkVGUHJXelYw?=
 =?utf-8?B?U044RjBHcXRJejdJT1ZvVnVSNTJOK1BwR1lPMmR5UjNtS1dGV0lpcm5QZFFL?=
 =?utf-8?B?UjV3MXFjSExzZUViRGpGT0luMHBoT1ZVSDBvY2c5bWs4R1dDU0hQUkM4cDFw?=
 =?utf-8?B?TndNZU1jamNIVkJXMEZYWmNkcTBURDA1S0cveS9IZkxxQ1hxTHVxRzhvWTNM?=
 =?utf-8?B?YmJuTm50MysyYkcyejJ4UVdLdjhVMGNmYWFXSVczbUkxbkhBbFpLaEEzRUVt?=
 =?utf-8?B?LzIyLy9pMGRSNVlZUTNrQVZ6VlJyNG9kV3FEMWpJZTE0T0JwK2RjZEtMTG9O?=
 =?utf-8?B?aDNCenhCSlJudFJSQ1AwZUkvaU1aa0R4WXY3UzZXWG15WUtBUUtnTGJnTTkr?=
 =?utf-8?B?aHczdFRaR3RCQzhaOTRyUXdGdndZWXl4MXNPeCsyMWJMbmdkN0Uzclp1dk1w?=
 =?utf-8?B?RHRvczVoU1pwdm5YTVB1TDhHbktTdFJBeXpNajIzVEwzc1NIMHdCNXU5M0Ju?=
 =?utf-8?B?OVd5WVFyVytZVTh3QVZOWFNkS01KNHhYL0psZTZyem93VGRtWXZ2UjRNeUVF?=
 =?utf-8?B?WHRINlJBeFVHSEJQT25UUmpHVDVNS1RFdWlPcTI0RCs4MEtpZUlGYWZGVElo?=
 =?utf-8?B?c05ndDU4MnpVWGQ0bHVRdzRNdk9YZm9BNnJ4ZGFRbU5BVHEwekJDOVA4bzVa?=
 =?utf-8?B?RGU0emdjSmpzSDdQaW1oTGdGZ0RtdldkejIwK3JLZGFpb09WdGZSODdRK0px?=
 =?utf-8?B?VVJuZEdxT3dYQ3BHenBBT1Q1UGx4dHJ0d01WVHNEdlk3dWpud1ZHMjQvMFNL?=
 =?utf-8?B?ajgvd1BrcWhRMXhiOWkzM0xlMjZkN3dQdkVNTTRTVHJkMGFMRE1zNmRySWJZ?=
 =?utf-8?B?b3pYMzJ6THJMNDgrWGUyejJEaWxKWEJKWnkvUkp2eGMyVkwvRVpmT2k4Q2pt?=
 =?utf-8?B?SWhMbkpVeFBGY3UvVlBMOHBUd3NOMEtGN0h6SjZ5WTEwRlRBYjY5YlRpUFl4?=
 =?utf-8?B?aXl5a1owWXhKY3Boc1ZOTXhnWkxURGJVbjE0bkF0N1RrdncxUDJPYkRnMndJ?=
 =?utf-8?B?WUlDU2U3aHRvY3F1a2NwU1Nrbm9jc0FVKzZnR1BhVi9pQ0djZEVZZ2R4bGlG?=
 =?utf-8?B?NUZBZk5VS3dPaktVdU8zWmNLd1VoUHg1NndrVXdwaDJXOHhJQ3NBblFvNEZx?=
 =?utf-8?B?QkxKWmM0Ulh5SE55RGxXa0NjL1l4ZjcvdkN1OW5QWkhoQ1phMHRGZDJtNFZI?=
 =?utf-8?B?dHo2T1d1L0x0WDhqUVNMT0ErLzBRZmxoZkZBTyt6ZlNHeWRTdzkzVHI1aS9Z?=
 =?utf-8?B?OEczOGw4N3lld0NXUGg4UWRHTzlNdGR2WDYzbkF6d2haZkRxOHlwaEJndjNH?=
 =?utf-8?B?Y3Z2VGRjU0JGSVZhYlpoNElWLy9yNjk4WlRiUHBYcDkzdnI4WlRiK3FiU2U1?=
 =?utf-8?B?SXAxRkFTZGR5QjRZQkw4T3hLNXB0L3VrakFhYktNeGJHOC9DWXhmajJUUndt?=
 =?utf-8?B?ZzFoTnArMmJLWUZwUzhzMkZtQkVoUFVpcE5lcTFxYkVwYVVWUkZzR1M5L1A5?=
 =?utf-8?B?ZnlMeW1xQm5CMi9TTDg4MzJRaGMzYkExdk1vazRDamlTMWV1aDRURkxBbHhk?=
 =?utf-8?B?MEsxQ21OVTA4WTFVL2N6VUU1ZkJvUGQzRXJZQldLMWhYRmh3ZDhGK0RZQ2Zr?=
 =?utf-8?B?Z1JsTVowUEZJeU1qa1RES1o5VjVJcWRkUkZiVXJqTTlXdkJjMnF5eHdHaEc2?=
 =?utf-8?B?ZmFVblNsOVoyaXlhSWh2Qy8waUVBTHQ3R3RoR0x0Vkc2VlpsRUhMRkFPU2FM?=
 =?utf-8?B?S0ptc2p3QTNrTkFLVjhhb1AvU0lqT05TZTFyczl6NXdiZVY2UDBPelJ2dG93?=
 =?utf-8?B?M2JZNjgwNGxWVlJCREQxM3MxRTh5YzhsNW1CTGdLKzNjUGVsN2tHZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e4070d-c644-44a3-0067-08deb21644a6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 00:09:44.6242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kiC+3l4OmSnF/Ls3q6JKXyC3zv+m8wXnC225aybTvgrx6BdFhMaX1Ope1RtpSedYPCH2FwoUcQQXVrQOVI/Y6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5818
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 878CB180009
X-Rspam-User: 
X-Stat-Signature: rzn36nxtkhdtiwb8r63xog7omahr6nxm
X-HE-Tag: 1778803789-150560
X-HE-Meta: U2FsdGVkX1/Y/2S0QclYX53z900/JHky86fN1vmPB/Jrq7dCisqwZnz8WJWkrxqK5gQyse/H0pRESsLmi0FlUc++BofEJVQowWC7HyzyGwwD69maF5MpY9CFZncCmzO6fcX0uIN4GOp1g/LA9fUUOSIxOMSjRYbi1bJx1iWNWYSP6MJMV58QzB88QiA7rf/4peFVyxQ4zDpOUz9xRb0t72IX6fyWlX4IlkSp73f8Vxa4D8p2rdS9vSAVCenkWYHlq/k5vw1FWHvVzysCMj/JdoJQ+4A2KfLOI+iG3Nvo7PQaDwpL1Os4QTePEo+gKGdPvlBH2vcGGUOYjIID7p8okMN0kA8s98VQlifuGQoJhBaAHL/R7+nMJp5pF9lbT/roF8TXfKLVzpVnWeLoLHiyFNGOElVvYZRnp1W3MUyreo1NISOUNB5bD4rA2oweppa/XMN4RAmh187hXnB0d6As3+yn4z9i3u5YqZQAwquOyMPNnYEiIlJYmCD6ekmxseE3a+BssPZgIDKw8AiW2Wv9QVJhh2C9ZNaAqtgMgf1Gqb7rIhjC+vcBwodRLuJ5RIJuRqZPy2WdddCeKKHj08GXwzakv2DycZ6EokrZ1B6jWW3updduRRvWgWBWKaMjLKxd0YVgtUaY0I7wlyC2UFN1Qdctusf/zFufTze78TGWw3miqK/NY3oF7YSjpRY1kjaQCyKWb0lJIUHvnUvgv/g3+5k2OppxFzF2VvdyNptuw0KySWE/ofu1k3NQABgeTAgqCd0tfGyX+sJg/VDeJboYqlOzKzUUH+KlclnQiMe70rknLl9n2lWXpDYJECc6F8GfxMY7Wa/JNjVE5b3jf5BPvV9mk4lHS2s01MElR4bo4jyMXrVrN0W511D4OWU6uzeivnjJmv2XKY77RC2buA8NfX05YTcBrcTxRJtsHMr0D5FBjfnV7TMN7wZhicJ8brI2DUEY7z9XmZNqjgi74wo
 O8ngu5/V
 fCMINR/rtCTcFXSsul63nQ3utNaLPOiQyvcD493eXb+m6xwJ/rYU/ekojSdged4CgGV9O2olncGldA69y7eztE7ni6tXjlg2rKOjUbJE1b9VeIJhARspKQVocV5o3bwCHs+KaQbHG3Z5GUNbX5TxAtus0KtfjzGZgDGPGGdpMel5N6cg8HiAlCQWapr7HZeUaJfZAuXQcVgj12CmX5npMZxA9Lfyb+Pba6at+xvgM+fhmrZJqbpJgRZ0FQuenaPw0O2JcXfEgUNpPsXDvBbYeJvmEkEACVFtUojDEqOlQHCWC4rV9Qbj3D+a3mUx/hDVKVUbizdjZmCT/IRoiZQ4WxjBUVW4pMXhOFRQW7FONzidvN1Il+A7WNJjmI0CjqnV8X7pH86FvqmkTWEjwVVKGg/jY88INXlAeLXwZONwAYUJYRB/AyskuF6mMpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 17:52, David Hildenbrand (Arm) wrote:
> On 4/9/26 03:46, John Hubbard wrote:
>> Since commit f002882ca369 ("mm: merge folio_is_secretmem() and
>> folio_fast_pin_allowed() into gup_fast_folio_allowed()"),
>> gup_fast_folio_allowed() falls back to the slow path for any order-0
>> folio with a NULL mapping when CONFIG_SECRETMEM=y. This causes a
>> performance regression for drivers that allocate pages with alloc_page()
>> and insert them into VMAs via vm_insert_page(). These pages legitimately
>> have a NULL folio->mapping, but they cannot be secretmem pages.
>>
>> Secretmem pages are always added to the secretmem inode's page cache via
>> filemap_add_folio(), which sets folio->mapping to the inode's i_mapping.
>> A folio with a NULL mapping can never be a secretmem folio. The
>> NULL-mapping check was intended to handle truncated file-backed pages (a
>> reject_file_backed concern), not secretmem detection.
>>
>> When only check_secretmem is true (and reject_file_backed is false), a
>> NULL mapping is sufficient to prove the folio is not secretmem, so the
>> fast path can proceed.
> 
> Hm, what if secretmem folio just got truncated? I hate to rely on some
> handling in the caller to detect truncation differently during GUP-fast,
> but this function returning "true".
> 

Can secretmem folios be truncated? I assume you are referring to
ftruncate(), I am looking at the setattr implementation of secretmem
and it does not seem like it can be truncated.

> Zi is working on a way to distinguish folios from non-folio things: that
> we can identify whatever was added through vm_insert_page().
> 
> Because that's really the key problem here: vm_insert_page() pages are
> not actually folios, they just look like a folio today, but looking at
> fields like ->mapping does not make any sense.
> 

I still think this is a short term fix worth having until we get
Zi's fixes

>>
>> Tested-by: Sourab Gupta <sougupta@nvidia.com>
>> Fixes: f002882ca369 ("mm: merge folio_is_secretmem() and folio_fast_pin_allowed() into gup_fast_folio_allowed()")
>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>> ---
>>  mm/gup.c | 13 +++++++++----
>>  1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 8e7dc2c6ee73..3ea661e67eea 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2784,12 +2784,17 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>  	mapping = READ_ONCE(folio->mapping);
>>  
>>  	/*
>> -	 * The mapping may have been truncated, in any case we cannot determine
>> -	 * if this mapping is safe - fall back to slow path to determine how to
>> -	 * proceed.
>> +	 * If the mapping is NULL (truncated, or never set), we cannot
>> +	 * determine whether the folio is file-backed, so a long-term writable
>> +	 * pin must fall back to the slow path.
>> +	 *
>> +	 * Otherwise, a NULL mapping proves this is not a secretmem folio
>> +	 * (secretmem folios always have a valid mapping to the secretmem
>> +	 * inode's address_space), so in that case, we can continue with the
>> +	 * fast path.
>>  	 */
>>  	if (!mapping)
>> -		return false;
>> +		return !reject_file_backed;
>>  
>>  	/* Anonymous folios pose no problem. */
>>  	mapping_flags = (unsigned long)mapping & FOLIO_MAPPING_FLAGS;
>>
>> base-commit: 7f87a5ea75f011d2c9bc8ac0167e5e2d1adb1594
> 
> 


