Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8750AC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7306B00A1; Fri, 17 Jul 2026 12:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767EA6B00A3; Fri, 17 Jul 2026 12:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6301A6B00A4; Fri, 17 Jul 2026 12:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 191E46B00A1
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:14:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DBF3160171
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:58:59 +0000 (UTC)
X-FDA: 84998575998.11.993D14C
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010002.outbound.protection.outlook.com [52.101.193.2])
	by imf25.hostedemail.com (Postfix) with ESMTP id 25BC7A0012
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:58:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pJSu7snz;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784300336;
	b=JJicGiD9qZqk4j1L1CHNmDuhQJUDeVmCaUG1KcpkaiOhNE7gDAOiOf55PKjZqlZA1r0RQd
	/eEaJm1bCNY0NdOEmC5ESHshPfG6mgNw22hsvIBxSNW2lXtrbASQi+afKhv2LBF7L5z5wh
	nJkO/szTpACn8BHQNaV1F5Zm1QvF+x4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pJSu7snz;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784300336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhZ/S/tTHHqHa2snbuLoPRs6BaukTB8jMMO0LkDQZGs=;
	b=H3zDM19xidkknBfg6ph0sSRJk+Ufkl2x/faBP9+Ad/+2U9ZcgrKF0k8dYzo9i0xvGtIPkF
	Hi/Hu4uMLmLKIxEQDQmoSKLNku8U/6yABIuCIeo7tbTHKaxFm1iE4F9JsUhnpS1Wsz6cPk
	T+v9xANK0Fp7xmVawwwXyusegFmgmW0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bkwaZlXNjyd9PASzQbXIGlHMKO3VLB2+GcCtMi7srkyzEgJcnAZDAe/cG7Ym5b82KHXRR+Gtf6y2UUn8rPjEAr78395apPqOswBm8unzy5TuWaachpFr/vexPszEIg3vlh520W8d5OvSp8ZATlXlHJfY1xc7YpWVU9oN1lCEM5LQ1gReYSfgYQP37Hqs0Tlqh92CzMkSOqOrbur0O5fZwPmb8RsdH4i96L/3ni2iU0ttI28GHZOhyb/nhzBQyy8DMWi5amPorE82+8zuOncwuYemY7PL9SJuI2ZuLLmG1CQ938/YB1fS7AiVhWUwIdQ7nnDFhH6bAFufTQgv9+X1wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FhZ/S/tTHHqHa2snbuLoPRs6BaukTB8jMMO0LkDQZGs=;
 b=jHfJxSkTxkddY3Mn9gCg/AeyTcEMtNve733ttkkXBtxmudQV0tjN2Za8jalS/6zbJ11ZVmUkhj7w48L2aS93BuWpl5KsvSzK01cFXgnu1AbwkMMgSzYw+t1w+jRWF/ZKTMGp1aw0+2hmZGpB3O28BOSG6lZLUREvuXUsSwbKORmEKii6knICrSH6BFOg9VpHwNhAYZrYiYVAqGl+vVsDnOQyu4sJCp4s/BHA3eHBOVCAuFhoUa4BY49yBPeOxeoLlNUKJoJ7F3HnA6JNowy4W2veg/O7n69wrYe7Rv8QKOL0v79mxBJ1OSZGYMv8oxMsZWO0nETwH+sA/h2o7Dwbyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FhZ/S/tTHHqHa2snbuLoPRs6BaukTB8jMMO0LkDQZGs=;
 b=pJSu7snzDd2BlPNLmyAe6kciAxSmp684m+5+EztWAv+zZi2SPbBvAXEj2ISjC+NwllqL4rTMr1fBHCL5cpsQPL6yJd5ojXjXe2n8c5l0w2JIWSsXFYKG+470YYZOFbuGpEr7mjGGN5UL/pvuNekn/xqoUdhLKxxOuF4nYS98DGYC5e5ZysfTLvUhqs0SKUTHF5brpuTkyAtrSF/wnC9FteW9Mlwkw9+lRilERyDpF/pF2+eNlu+4m4bqo4Z6RNI1Qq1CiNuMFW0nDfUAjguV1nCo7eDYGx1mNA3EN7y1azSxeBEk/AMpE3/j1Kz6yXz2bGjbxYB9cDBneqU5nxXvhg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB8176.namprd12.prod.outlook.com (2603:10b6:510:290::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 14:58:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Fri, 17 Jul 2026
 14:58:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Nimrod Oren <noren@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Liu Song <liusong@linux.alibaba.com>,
 Hao Peng <flyingpenghao@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/khugepaged: cap pageblock contribution to
 min_free_kbytes
Date: Fri, 17 Jul 2026 10:58:45 -0400
X-Mailer: MailMate (3.0r7020)
Message-ID: <8E9B69B5-0FBA-4CE5-B737-B83AD1FE52C3@nvidia.com>
In-Reply-To: <alopMtyPYdn7vDoC@lucifer>
References: <20260716173504.760369-1-noren@nvidia.com>
 <alopMtyPYdn7vDoC@lucifer>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1P223CA0014.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB8176:EE_
X-MS-Office365-Filtering-Correlation-Id: 072b36b7-0841-4461-4a0b-08dee413e757
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|56012099006|11063799006|6133799003|4143699003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ZpH+XiVjZBMJ6oQvyZE1R0Ga35OtJQR3ba6cyExFZ5KWniY6L9zj0NCrYl/G5AZ5XHdH8DgUXPyZGj5KVaOp5r9xs9SQhA94bzyCSF+PXBtJ5ClogLLCJyos9rZBmRwJ/DFQmu6FRnXsy83tNqjLe4KS+/Wz/xakcqQ6xZDxRQ4mPCbJLNO8WX+h2DGN19AtrEdBRp/PfSf6PdOuM+kfvfHQINwVmCRvzmsZZ9ggO/SBZU3/d6iNV+N9xaatB5TBqohD6C5jSR61VzSzAEv1B7nTZBGesYTOYtEB6J8Yn/+nkieCsAN4oV4vNFEGecJJEFNeycwBwwEeU+D1WPGErKx4fLl2UpEDnws5U4/w/JJB0GHdU+qyJz6nFh0kGEtLaH0yqGLFyiGrxhcKS4kOhZ8eTZrhVAG8p0IaJHgK80lY8t+5NkS4Oacx9G23AfpVovjXyOVG5nfCAk+GumqWTLNRpqCkxO2KQeVDw6+F2deQpjuTkaCsorl6udIWKcOh9HcMOx3Ox+bCp/QRVaBOxmIvfongjIt+QnDtT+mosrhgsac0j1dhHXLehbXaf/SA4eeo3pOBDTFoeTSOzXz+1hQ+h3kOYxDkgpVn6nVeNqN+cC1S8mtGDCV6Ijcsois0uRBZPSLrn8bhVogV9w/66rr6Dlu2/jkYZ17BqrBIiOU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(56012099006)(11063799006)(6133799003)(4143699003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y33iEU19VVY6Q2DWAN0SRpB6E+qh/tmGj7O0di07txGS8WeqiKsf/icZHiMy?=
 =?us-ascii?Q?Z81A61FZIkknV/qGf6NFWvPSHkOnl2eJrjaGHNEU6pPKxeq9XTs/4glrluOE?=
 =?us-ascii?Q?yffyklRvpzf5kFukguKPmHD4ExvdWeIN9HK3tWJLvamWxAtF9e5SyKpZyKMs?=
 =?us-ascii?Q?W/JIgYztRzApg+40xQiwE38H7QeTGTfRSTIvx/JenrjeKT3cpyif5OxC++TT?=
 =?us-ascii?Q?aDuDcxG4AGytbATnPuZ9bQjPuS5lbYoF1zMpNvBlh+vHIsSZYGkUae0tlu3s?=
 =?us-ascii?Q?RMHeVTn/FR9CfqM1c+xMEejc76wzyapmlJ4F90wrT+DTGYwz5riaVcMT4v0h?=
 =?us-ascii?Q?bVEyMWhVygFm/Tm508DhmzNTio7kRbeVIljDLyVIL0xeYzfqUqZ5RysqTFTi?=
 =?us-ascii?Q?n73P8k3saWA23l0Ot8AWdmk0benhNbxANC6vE2LpWFU48ciVPDycB0vOylbT?=
 =?us-ascii?Q?a+ybMOfNG9A/QJl8NeLuj/44DBD/ebQZ1a/OsboZC+LwhWeHQ/8OOR1XbOoe?=
 =?us-ascii?Q?Wj/y7p6Nq98U8fbtTgAEdggzTpP9xRKk8xRMm/U7/HvWYG4AA01QXafmEHYb?=
 =?us-ascii?Q?QWEgAz749lZMEzXhBdegEdk0VEk0/XQwXHnxhsUFHv3FiL9SmO82Nm5NRl2T?=
 =?us-ascii?Q?3gadbYlkl6quSbghXFb/BlAGV+93C4kUNlbtEBB676zs/R7TSrswcZg5mCzU?=
 =?us-ascii?Q?E2uzBHApFUvPZ3pUxedUljwP3/Vxb4FRNZ+zHV1r7Ys4vFzZ0XXPFxp38U3d?=
 =?us-ascii?Q?w7Aq5lvrr/zWSKXzr9eSKRFXLiDgywVowAfuxfLx4JXu5ZkUzA52Iti8w/1s?=
 =?us-ascii?Q?ap22HiCeHBunnbKBmbX8ZDI66O0gRXNLznJOBYvTQY082VFdZMjS4LItjHab?=
 =?us-ascii?Q?37sq0eDDWSjpIjlm6MVXnZExiczzz2zO6AeNBQCJeErWNyeVkApuLaotaVHl?=
 =?us-ascii?Q?gyYc3gzcEDISk7G2PfVRy+LawC2mKZoOUnLNRSy0u0U3kHxGNmTOcpZNChiC?=
 =?us-ascii?Q?rSDpFEEssL454heBI8uDPzlFh43/KXSvuFq0lENnh048iePB3YLJYlyhV1vt?=
 =?us-ascii?Q?NeUMt8Dsa90gkYqk5AvgEaddW1LVrt2Sfb7kpguz2nsJMY9+itHfZysc8+Gn?=
 =?us-ascii?Q?SPTuTjGYJIO7gLejbtwkccevTN3iQO6dy2IdGsRQaI+mxd1DTQLf2wNtzaLY?=
 =?us-ascii?Q?2kK+pWMfBTIQuy1VCMs8WOCh/9HN+R4D7TMJft6mHvS1s/sZ5+3Ifsv16FMb?=
 =?us-ascii?Q?prviRfXof7bLW2bVtmwwOuzc9B56ohKz/8ZNlq24BHcWM4LUUStw4Csfqy7V?=
 =?us-ascii?Q?jtI+98Wb4e5ngyixJuSpUtCibsVpKkuAEI9/zBxPq5iGb2Pefk6/5xPjwPO3?=
 =?us-ascii?Q?qdkAmKyKFI0ic4m8g7NSxnhEsYXCu0BDFft03OZzgCdrD5ipaMaLUuWAdyJ7?=
 =?us-ascii?Q?ZDi06UZGQLQ67d/X8goLqgUJBAZ1BrWjdelb/TzmgDw1GJEsZUds3PH5ZZO7?=
 =?us-ascii?Q?pwWKmFJpjQd57KaoNZZIJtZV+R016Vg8z1X7AyoU0obAntGcd1QWGiQh8iBY?=
 =?us-ascii?Q?mCVihptHalqkAs+KdVR0183gLIARO6fbDcuOUNqTvuTxJJTJjquGIBlgxcNF?=
 =?us-ascii?Q?C3gCVpljiNu9+OgaZ7wXCg8NlgDUftnsFUPM02QfRxhueWhNAmerTuVH1TlK?=
 =?us-ascii?Q?9qqvVelj8hdLf0PD9UYlpq12W0wXmDqx331oC0L2Vt4kA/nr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 072b36b7-0841-4461-4a0b-08dee413e757
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 14:58:47.2275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQm9AwZ4gAhkd7qr+3kvtDhiRd649loJhxC492m5XbkCX+eMxIVHrCF/Exh56Gf6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8176
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25BC7A0012
X-Stat-Signature: edj3q7cnxgp4gm6eu6r4graxpdn7docr
X-HE-Tag: 1784300336-835789
X-HE-Meta: U2FsdGVkX1+M4abqlbzeDcP07ENc8eO6rX1kwSSn3rSvQZeg5l9Xwx+DpRYf/xznKdb70UsduEfUelbbnLfCbmLcc4CBuH3wYwKSZPXROvqj7rO3OtQJLBzoa3a7N9lHZSKDPgUbDrcTtcpbI6RDhJ7I5HGTnRmEdHNrlG8WZ3dL9qbPQZwJ4fXL/5T9SAjcbmweItj6NRWQPz9SRjg0EdOg4AWOID9ufT/m0cghHnwE2ZImgKRu2ynsQ5+hMMBIgf5HectT12gBop21ZeweYW0+BwlkwQkB6+uamW42gIxpUi2BFXnaZaxTZUmxeVQwg2sLBbziGGRtUElMpqAeVpWTXUxq/vjGFh+FK5BfjU1r5Q6lgoRex5KePOEix284saj/dxTWgchKI8+BvkbqTqO/uq7x3WZF0FQeicnnR2M1HYsdqeixhlPVE5uFlOVG4gDc2f4F6Np0FPbG333Of4cOikhtybcJQ5X+9cBEBKaxJ7Wp324UV7gqxsyE1BJrZ0Xc4f4dfKwIammzvI8kvxJvJl/T+ZMsdjw0gIM/t8CIbQjZmgse+lbClakwzg3DjrfCgawSux6ABxyipyxFaALWz5PwIljIeW/mHPsb6J3nAL8XiCl4fEVk2fJG361GveEgHIB+FgovIQp8RSXRvIJkFvCpNIpfNe5+6TWF1s2oAb1W/NPGtFIuYCjL3ge1kVq6ipsSUWPX/fuBm7lf6inqB7d4VQHtzaYB2c1xub1mZ6Q9qge1Qj3VTtAF5f7lqTfjiY65wPZWMkJRd/xszYa3VgMSBQKXzkjvV5piDk12HznZjr3I4e5FErqQGLNryQ4Iv48K7/01Hvqql3otfVldLrW4TyRi7kCcLKXOS/8Ta/KMVyotoxshM58xwoVE/i+LhsWIvgg8wMTj5AW23TSepAYIfCwWi2jQqhrSEdJfT2Ey9M+IBFEie8AXuO5QvULtzEIleuNnIEOMrQu
 74HBzBX6
 pf4k+FAr1IVBIHmFfZAovPYSAt8BoDKkTe1QC44OBe2vBHRJs/ptFcH9BlDKLkEbcZWeyOV7eKU0PtHtMTsc0qi2KjLcwyQ1sTaerRbGNJWxlmqr+I7g5yb7lxcymyOvHUwYpYxeD3NqYfzhD0T5Vr8/2l9pX5LAhYnZ4vXiXF4ibxt19MP73H4W5m4r2pTM3NiqLLKC97dCmdHv/moDputaZlnu/k/sOYd7YOeDzP7AQ2ies5IksmsMzqxfdyB0siRyufu8XR6zEMZX50cQUtFP8buMCQ3EFBmy9aUVfIySe/ZR4Vv+BLV0LQDe81OyH2zuVjMHvCkw2uu6UcfCJTGI78HpCuoUMHPaD1pkfhcbv7s3qg+DJLbeP1fZTzIST02ggXy7gUX3KYM6zJ4PAFWJKBfWGrbUbyWaOlO2JSTpTnnjgB505BA6Xukk9UNOeWnTpqpNj8QR7U7BBAwf8wT6M9LmG/65J3pIQ4OsKR8G6VycIg6P+mm9uXDOfWb9fzOLi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Jul 2026, at 9:36, Lorenzo Stoakes (ARM) wrote:

> On Thu, Jul 16, 2026 at 08:35:04PM +0300, Nimrod Oren wrote:
>> When THP is enabled, khugepaged can raise min_free_kbytes through
>> set_recommended_min_free_kbytes(), using a heuristic that scales with
>
> Nitty, but that makes it sound like khugepaged (the process) itself com=
es in and
> changes it, rather set_recommended_min_free_kbytes() sets it higher if
> hugepage_enabled().
>
>> pageblock_nr_pages. With MIGRATE_PCPTYPES equal to 3, the formula
>> accounts for 11 pageblocks for every eligible populated zone before
>> capping the result at 5% of low memory.
>>
>> This is reasonable when a pageblock is 2MB, as on common 4KB page
>> configurations, but scales poorly with larger base page sizes. With
>> the default arm64 pageblock sizes, the contribution per eligible zone
>> before the 5% cap is:
>>
>>   4KB pages:   2MB pageblock,   22MB per zone
>>  16KB pages:  32MB pageblock,  352MB per zone
>>  64KB pages: 512MB pageblock,  5.5GB per zone
>>
>> The 5% limit does not make this harmless. On an arm64 system with
>> 128GB of RAM and 64KB pages, the current calculation resulted in
>> roughly 6.3GB for min_free_kbytes. The corresponding aggregate min, lo=
w
>> and high watermarks were 6.3GB, 7.8GB and 9.4GB.
>
> Yeah this is an ongoing issue (as you note below). We definitely need t=
o find a
> better solution.
>
>>
>> Automatically maintaining multiple GB of additional free memory to
>> improve the probability of 512MB THP allocations seems disproportionat=
e
>> for an opportunistic background optimization.
>
> The fact it's in khugepaged.c doesn't mean it's just about khugepaged, =
it's
> about avoiding fragmentation for the purposes of obtaining THP pages wh=
ich can
> also be obtained from page fault and MADV_COLLAPSE.
>
>>
>> This RFC proposes capping the pageblock contribution to the
>> recommendation at 2MB. This would limit the contribution to 22MB per
>> eligible zone while leaving configurations with pageblocks of 2MB or
>> smaller unchanged.
>
> I guess you're trying to do the most conservative thing possible - but =
it's a
> bit of a cheat really.
>
> I mean does it really make sense to reserve 2 MB for the purposes of ob=
taining
> 512 MB PMDs? It's essentially giving up on the idea of getting PMD THP
> altogether but pretending you are still doing so.

Nimrod and I had a discussion about this. It seems that on 64KB base page=

systems, 2MB mTHP is more reasonable than 512MB. I also assumed that peop=
le
might use 2MB mTHP instead. min_free_kbytes targets getting PMD THP when
under memory pressure, otherwise PMD THP still can be obtained.

But I also now realize that capping pageblock size at 2MB might also hurt=

other >4KB base page systems, like 16KB base pages, since its per zone
reservation is 352MB, much bigger than 22MB.

>
> I wonder if it wouldn't just be better to explicitly check the page tab=
le
> size and to not even bother trying for > 4 KiB with a comment explainin=
g
> that it's not a worthwhile trade-off.
>
> I think that'd be the more honest version of this patch wouldn't it?
>
> Or maybe we need not be so concerneda bout scaling across zones...
>
>>
>> Earlier proposals to resolve this problem involved disabling default
>> THP on affected systems [1], adding a knob to disable the
>> recommendation [2], or deriving the recommendation from the largest
>> enabled THP order [3]. A fixed cap requires no new knob and avoids
>> large changes to global watermarks when THP policy is changed at
>> runtime.
>
> How often are people turning THP completely off or on again though?

Not only just turning THP on or off, but also enabling a new mTHP size
or disabling an existing mTHP size. (e.g., anon_enabled_store() used
by all mTHP anon_ctrl_attr_grp).

>
>>
>> Reducing PAGE_BLOCK_MAX_ORDER remains possible, but it is a build-time=

>> policy that changes pageblock granularity globally. Its effects extend=

>> beyond the scope of adjusting min_free_kbytes.
>>
>> [1] https://lore.kernel.org/all/CAPm50aLPxJCiVTqqwiz00oMNiqHggB84sXB3x=
=3Dtv_HUAd5UktQ@mail.gmail.com/
>> [2] https://lore.kernel.org/all/20230817035155.84230-1-liusong@linux.a=
libaba.com/
>> [3] https://lore.kernel.org/all/20250606143700.3256414-1-usamaarif642@=
gmail.com/
>>
>> Signed-off-by: Nimrod Oren <noren@nvidia.com>
>
> Thanks in any case for taking a more pragmatic approach here.
>
>> ---
>>  mm/khugepaged.c | 17 +++++++++++++----
>>  1 file changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 27e8f3077e80..c0570bbb1f4e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/ksm.h>
>>  #include <linux/pgalloc.h>
>>  #include <linux/backing-dev.h>
>> +#include <linux/sizes.h>
>>
>>  #include <asm/tlb.h>
>>  #include "internal.h"
>> @@ -3066,6 +3067,7 @@ void set_recommended_min_free_kbytes(void)
>>  {
>>  	struct zone *zone;
>>  	int nr_zones =3D 0;
>> +	unsigned long capped_pageblock_nr_pages;
>>  	unsigned long recommended_min;
>>
>>  	if (!hugepage_enabled()) {
>> @@ -3084,16 +3086,23 @@ void set_recommended_min_free_kbytes(void)
>>  		nr_zones++;
>>  	}
>>
>> -	/* Ensure 2 pageblocks are free to assist fragmentation avoidance */=

>> -	recommended_min =3D pageblock_nr_pages * nr_zones * 2;
>> +	/*
>> +	 * Limit the pageblock contribution to 2 MiB. Larger pageblocks can
>> +	 * otherwise make min_free_kbytes disproportionately large.
>> +	 */
>> +	capped_pageblock_nr_pages =3D
>> +		min(pageblock_nr_pages, SZ_2M / PAGE_SIZE);
>
> Yeah this just feels like a hack, to be honest "let's pretend a page bl=
ock
> is 2 MiB" essentially :)
>
>> +
>> +	/* Ensure 2 capped units are free to assist fragmentation avoidance =
*/
>> +	recommended_min =3D capped_pageblock_nr_pages * nr_zones * 2;
>>
>>  	/*
>> -	 * Make sure that on average at least two pageblocks are almost free=

>> +	 * Make sure that on average at least two capped units are almost fr=
ee
>>  	 * of another type, one for a migratetype to fall back to and a
>>  	 * second to avoid subsequent fallbacks of other types There are 3
>>  	 * MIGRATE_TYPES we care about.
>>  	 */
>> -	recommended_min +=3D pageblock_nr_pages * nr_zones *
>> +	recommended_min +=3D capped_pageblock_nr_pages * nr_zones *
>>  			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;
>
> we're really getting into faking stuff out realms here - pretending a p=
age
> block is 2 MiB then doing calculations on it as if they were.
>
> We'd be better off (and more honest) with something like:
>
> -	if (!hugepage_enabled()) {
> +	/* Avoid excessive memory reservation if page blocks are very large. =
*/
> +	if (!hugepage_enabled() || PAGE_SIZE > SZ_4K) {
>
> But that seems perhaps unwise.
>
> Maybe a simpler version would be to just attack the issue we actually h=
ave
> with it - it uses too much damn memory :)
>
> So maybe something like the attached? (you'd probably want to make this=
 a
> sysctl or at least a defined value of course)

The approach below makes sense to me. In terms of the actual cap size,
I asked Codex to check what possible pageblock_size and their reserved
sizes:

1. 1MB pageblock size (s390) and 11MB per zone,
2. 2MB pageblock size and 22MB per zone,
3. 8MB pageblock size and 88MB per zone,
4. 16MB pageblock size and 176MB per zone,
5. 32MB pageblock size and 352MB per zone,
6. 128MB pageblock size and 1.375GB per zone,
7. 512MB pageblock size and 5.5GB per zone.

1GB makes sense to me. 512MB might also work.


>
> General idea is - if we're going to cap, let's just cap instead of
> pretending that page blocks are of a different size.
>

Sounds good to me. Thank you for the suggestion.

>>
>>  	/* don't ever allow to reserve more than 5% of the lowmem */
>> --
>> 2.45.0
>>
>
> Cheers, Lorenzo
>
> ----8<----
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 617bca76db49..d9e1e7de5494 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -3092,9 +3092,13 @@ void set_recommended_min_free_kbytes(void)
>  	recommended_min +=3D pageblock_nr_pages * nr_zones *
>  			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;
>
> -	/* don't ever allow to reserve more than 5% of the lowmem */
> +	/*
> +	 * don't ever allow the reservation of more than 1 GiB or 5% of lowme=
m
> +	 * (whichever is smaller).
> +	 */
>  	recommended_min =3D min(recommended_min,
>  			      (unsigned long) nr_free_buffer_pages() / 20);
> +	recommended_min =3D min(recommended_min, SZ_1G);
>  	recommended_min <<=3D (PAGE_SHIFT-10);
>
>  	if (recommended_min > min_free_kbytes) {


Best Regards,
Yan, Zi

