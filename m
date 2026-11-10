Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87374606A338
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gudxuXxw
Received: by kanga.kvack.org (Postfix)
	id A22366B05B3; Tue, 10 Nov 2026 11:24:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F28B6B05B5; Tue, 10 Nov 2026 11:24:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1F16B05B7; Tue, 10 Nov 2026 11:24:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 648576B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:24:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0317E1C4131
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:21 +0000 (UTC)
X-FDA: 85419731964.25.F608A91
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011007.outbound.protection.outlook.com [40.93.194.7])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1CE42180002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gudxuXxw;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794327859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WuTURMt+GVaaHmOPrSsXaBKltS+dBeLJAN3zzUBJorA=;
	b=bn++y4pG2tsHPJcqqZxznnj84VJOJhqW62Qnnpo2eqY1duRKNm4MO26J0ZlGfRwmVR/k4/
	90Qt9KsjEGNpkzWrVmRH12opo9UbtK58yCcq6bwQNQxqrmoGa1Q/TRrvuQ3gH/JhHaT4MT
	+9E6Od2m4grs/+7c+IivbjK1VgQYMHk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794327859;
	b=ys8321sopaHvgSv4/JLnrD+f/5nMFBTnMUNPohjTHuGeBMjrNtygwJQjrSsTKMxIu4o1yI
	iT2JkMiPBRLKLJI+k35U8xfPhb43K50U4TEQ+Un1Wfit3CRQ3CSnCTTmAG47Ss6TxZYEtw
	XtBX+W+TdW4k8iHugDIJQw7xf6vEbPs=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gudxuXxw;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X6oaC1UzM84LXNJll3IKiOM0u9czb8aG8kGjzSlv5D9miNT1K59ma01+zxIrORkpc5jmsbbfFmBqhiUAGs4hhj+FZuhJoIBBLj1uYAfbzHDB8fFJj/2YEXDp/7GGhhcACh2R/z7vGAN92ti8U5aE2NRlsbr2DjzYL6XqE3dsfUpvfiMb3hfTxsoEPRWL8opTw00kYXRX4JGSCicBeugAHiz6JWfmFnkZteSQOrkcAq1ZdDrziKVohT95xVUYk7elv+GHSmJ2NX7XUeSqYvKzVD3JYEHiV41wiUWIAyoKouIUna55ErBgQElJcD8pQkXpJERL9WNvaHr9lkH7XL2p7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WuTURMt+GVaaHmOPrSsXaBKltS+dBeLJAN3zzUBJorA=;
 b=QR9TYr/4zwJhva8sX+6/jOt5R9bt3cqHKGvk7K6PwVCwCg3XRiJqieHISrllyOTI6nJPUoZyAyNk64Dwir5m6SgqWSI+gPzlL/AZt9cRsfhnDzfSXGZ/Kjfys3BnLxUKWb/J70ySjLKdNGaAFb+g2YEVLbb6OO27B6shs1mmnaE+vs1a+7m5zqrPATXR3wodFy3oH12nTIKPD783wgdws0Vox1nGzddkXW+EbxB49ALGNXKXET29azo4sCvl+lpxHdGChI9ojYziN528P/9mv3nHMBVggVOZjjeQ7tAl15cRN6srgKSl7Y+iD48yItKTrZdE5AczouLTtVXe2A0W8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WuTURMt+GVaaHmOPrSsXaBKltS+dBeLJAN3zzUBJorA=;
 b=gudxuXxwLenYHGX4tZwM/W/kBPiGLYa1C2bz5eN+3jNen5nJprbWSe7JUraHS/t+Lx6Ori8TB20f8liJkPrDiGlI1Ujn639nMMx8NdDfC8kO+Iwr+lbBNDpdLq8K02MIemynsZZy9OkCRDa9OzH26YqYLuYW/xSrYQffWjO9aVeHcorZCAnsmPRDM2uSEd+dh0gwYZT8fEywLHrUfYdZYcfkCRB7geSJlCVaj7crzrJQISlrzmtnW6nUiBwYx8cQ2nbC8oIegJ3dlF/oi1wGaNHbxqvvOfLmxf+N0NekpgzT0ZPG6+aUyUVBySSqStVbjiJTcEw4SmvQBiGzqG4adg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4140.namprd12.prod.outlook.com (2603:10b6:5:221::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Tue, 10 Nov
 2026 16:24:09 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 16:24:09 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
 Amit Shah <amit@kernel.org>, Jan Kara <jack@suse.cz>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Bernd Schubert <bschubert@ddn.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, linux-fsdevel@vger.kernel.org,
 fuse-devel@lists.linux.dev, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH 1/4] virtio_console: copy pipe buffers in splice_write()
Date: Tue, 10 Nov 2026 11:24:06 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <3210F1F9-275B-4962-AB48-B139FA1ADD33@nvidia.com>
In-Reply-To: <20261110145241.536019-2-kas@kernel.org>
References: <20261110145241.536019-1-kas@kernel.org>
 <20261110145241.536019-2-kas@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0327.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::32) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4140:EE_
X-MS-Office365-Filtering-Correlation-Id: bbc436b7-fc16-43c1-36ff-08df3f470c37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|22082099003|18002099003|11063799006|4143699003|56012099006|261026121527099003|261009223027099003|261022105027099003|261026140227099003|261021121427099003|261021123027099003|261102123227099003|261028144727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	6VRDSEl++l27nzZi7lt3997xQr9rv8S/ydgkfsnw2pIc67WAlyuNN60yabSgAPY9vd/1YGBJqWDbrl5menk4m6WBd3ztnpN+OVOlYWgYx9KEzi+AWLC+QWCZLpJ5K2hKnqU9JhJOTx6cAKHts6n3XiwRfAYhsmsBPyrIC1rjN/BIWFPqqij38Q7MuEP5jgv0gkOkld0Ce4AkTonzxqmUgTt2gc8D4VGK6Pv4mQwyVC58wwH4rectu8WHGdeN12AULmzkMylKS0kiG/XgB6F+hmxZUzk9RnmyQ3ogJRYfqkzqlc/w1NUHQwuuCyImUixbMzMdEDAkFVIOtVEueVRZKHWaRpcCshKJjY7UnGvpy87ORomnmVVG/vAx6JJeiPP85rkuJkC+O5It328ntMAKX8dfqLsFv1gaUKpDJHFctHMhgDkU7H7B87t51U5vEVatRd2J2U34Afa1VJKWqr9Ps3LwdcKtc5a00lEXiGumhKeAQPPTuWNkp3TYowz3+xpKrRR0x3QSrn1So8cv8YuKE+hItN7OnZLNsT681yg5fn3Mtn1lJAZ2g4ruAx9vxv93dbHR7MDnyHRcWjPtEbcc8lRTuSD8apZS+26p9GnDzHBJfVW7Cu7n3/CrwEEbcGmGR1b3ucZlzQrakAJOe3d+Wn7sov/sC8oCQfw25o5UAj0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006)(261026121527099003)(261009223027099003)(261022105027099003)(261026140227099003)(261021121427099003)(261021123027099003)(261102123227099003)(261028144727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KfiV0texI8BFXsg2ql3DdG3tVClLbc0/GlFXRnGlc22TDCwG0lfGZuivjlqP?=
 =?us-ascii?Q?kN/bmzKiSbwnHYZA6lSinQRSf7p1UEHR0Ul6r7nIyQrkOVGG/cIlASDCrko+?=
 =?us-ascii?Q?HjjkR9s6wRFj07gFrgGoETrh2j8TKG17+WKCC/eM1Q5uzUoLjR2Nqcx9FJ5b?=
 =?us-ascii?Q?TqPfXyeYqvDz1SQ0biMR0bRIrxRdzKmtCwzt4YATQPbcOcJUp/xeIZ76aFpD?=
 =?us-ascii?Q?KWT/zxMD+i0XHS2k5fPnh5g8C4bphJIg5CGgEE67zmE/rs0SBlx1QsMQvyjX?=
 =?us-ascii?Q?ZJaASxLL4zWXNT8N+iJo6L/ZojzB8XNA+fuYMlFupGMpKBsx9z/op+puf/8+?=
 =?us-ascii?Q?C5yeUcNEKbjKBuCHN6ElDrq26w9Li6A6o8xXEIhgY3lF+iczGUJgOLcneXA9?=
 =?us-ascii?Q?FVa2r50xp3et4FJxIph+1JfGkk+EMPfhihIVNn28icFIqIeSSvgh5bMlg65r?=
 =?us-ascii?Q?Rp1hsTksyvOHKaYX7isJNKfF+TqgkB95iOZpMTFbY3W972DHDf11ExBV7GpD?=
 =?us-ascii?Q?k70tcK1A9eeqA8wUxt/Jz/QVBhgODbKx070FgwBw67KYL/tVxh6u0zhi1tu3?=
 =?us-ascii?Q?CVGH23vfKxj9yiNgIDFAdNnfuzVPL+ME4wwzMel4iavDFfz/Cu18vLahXceO?=
 =?us-ascii?Q?qbs/APTlIf1WYgB8yzDy5txIvhN3VPCC8fL0PrCdM1IMbvWtO/8YhVDxa5Eb?=
 =?us-ascii?Q?WcFeQrmUwfpiTCRRdrpDErkcyYkQ5BH/SgDaBh1FYUCK3P78/qJXlbP+MRtO?=
 =?us-ascii?Q?vWBGXC978vVyKZpE0Z5y4QdGKyJDAHbwS7zicVtpchTQhvmhiZnILv8GOco3?=
 =?us-ascii?Q?MRyNiH/rcG4NTxXpcXGdJhhGwMAQjbxfENQsJNs7m6QaVp1YZnqLn6jyUJZl?=
 =?us-ascii?Q?8XlPc66rZc6c54HPadIJjgQCOuNJ94x1JhEBGHG+U2FwImoMswmKttP/GWj6?=
 =?us-ascii?Q?x/BnABMK+ThNJCV7kkbZ3VRgaT1jXVtOvA1K/rvByv/ZypfGORSq2D1QakfV?=
 =?us-ascii?Q?j4JYwhn5mhpyhzLtMPsFLmwrz93Y2y9DS0zBLBtn3bRLsIzKYcNCKMLTRZAZ?=
 =?us-ascii?Q?k+8GyUEHq/LzGc3dv7onUc7sFD9YYlHDe8rQAiSUVYK58RrAKPdhnNh7dCfo?=
 =?us-ascii?Q?dpBwtbVcuS0PGbbUXzg8WFSO+xkvyWP81gUbDQJofgINpIBfVzvK0s11GT8S?=
 =?us-ascii?Q?gS9lG+GjyDuyOeNS/ygqRjD0JE9eifj0vSiCsIWa8lJoHZh1heSD9e8vhVhF?=
 =?us-ascii?Q?Q8Lat3YX4N7OkzueuHTHRRreBLqC/dcL3o55Etan8RPCUq53XteYgE/SgZUA?=
 =?us-ascii?Q?rfDj84Z1viNBPM/oR1D9aVwOMOA0bXLnOGoZ9n+bu5gN8MZ8Y8qWo7eJWOMY?=
 =?us-ascii?Q?QQmIjVaZ807sDH3rikx5wqOL/y0pOc2jbFwjwvzIoIAoCaP8grVW+N5wI3By?=
 =?us-ascii?Q?yI4pR0UhfHK3dXMPOsRwioAvafaniyJaZl1phucmsdYQrwr3BboxMXTp1QkH?=
 =?us-ascii?Q?IG9p9IcYsv/1120gmA/rDApL6e8PrSUK51u83Bj05+SL9Yfd4lHJRMsPMN+9?=
 =?us-ascii?Q?IsMn1BH3+CRXiGJdv/VvOorZkc3fsPR/IzH84jaZC5wjq0FgyEx6sUTj7d3O?=
 =?us-ascii?Q?Un7+4d0hyg9ILgZFfERTclcP3mw4tXD+kbodsHp/z+uw2kLWx189aVTDnsOM?=
 =?us-ascii?Q?BEqbyLhih+QACjUf+S5Sl4P1q4fUC3H/YmlXcgG5EkdYPeue?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc436b7-fc16-43c1-36ff-08df3f470c37
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 16:24:09.1474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1NQOzA7teSmq/wxM/Oktyi0JtVcP6LAIiDw3gDeS4ADTf0UyiZakIAWLVcDMcy4U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4140
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: p6gt48uwpg7ykpgs44duggpp6wk6zi1b
X-Rspamd-Queue-Id: 1CE42180002
X-Rspam-User: 
X-HE-Tag: 1794327858-149048
X-HE-Meta: U2FsdGVkX184+vFllGSqd6ZTxX6WWLmpU0LLtl8X46aVAJvMCSakpM1YERrJWIiduEO6fjyvoU0kfPgh6Byrhg082Gq6rBq9qvAvfSnrzNDa4/TTAGhgutzGwH66nXNXi0khQSDpFvGZT3qgWUOVkd+EhekUKpIAk6gvQB56NL7YosYNw8f+1EeQKa++ZAKCpojfMpPm6MZ2pI6JO0+UgD4gt3BN6ip4UqSWskWfMfa2H+nOg+34vN5HURLMUkvVemSzyU/cpM4SRabrneOo6lQH+nFzS1vrhGWjIot7bFIs4+ZpoVUmTbIMbA+uyz90YE+L1rMkmTg2dmvSyvV0X2boaJYoXZLG8XWnSE9uY6msGdTHZTWsEziu0Y6RCPV32/hxepk3FV0PvHwbn4CDQQP5SkJo23xeT7Heu5d/2I+Mcxjca8em3EXj7Oxt1v84EYkLcqTvbSGuFG+hAC7egGoUc0seQCgJIeIRlmxlCz66eIkTDyVVp5CX2TClw2zUN8ArHVwaibpolgn+oR+zJ1DskZrBq1RG3pyaknvihZi75FjAK9GGpPIGrOu7hzQ6/YCSZxxSLa4D7yPuu3HZRGXp6h2lu8MupOZa/AI3h3a0LWHgcBvpWeRWXI+4AoFv2ay7bR2My37YIOgSULEGI4Kubrv1rHjldVZxSAhHYMl0t3yjQuVKYKAoP/EblY7auRyPjoBUJ43esyGb/F+t+5xRklTm4AwUPUccZISRXCojusM+fmrs8Gmh7dIniIoQ+2SxmbPyLnsZrAIibyK26uX3LtVWFidce7RkrdlRwyD/fvhhVZxRKgQZJZSHv6KouA/MCxhV//jd/xF63o9tAJxx8p/8r6NBfWvYm0JTfirtLpucFqAIfdFB7v/gQqSAndMgN4XjX/pmJyKkBE2mZpRFhEKqeXBDBaRNlwQlCrzp11rbKeRV2HkBwaMd3x/iWR5qN3W1pLs1TSkE0fN
 HF0S53xn
 Eu4P1usWs+T0Yy0lFATamkWsMY3BrEsFxqCszuwH/hT1ghy0sY5tua84+8lU4aHQnkNgJUy5p52DbbgZez+hB39HpqR+lF89tdhuFlWGZD35mu8Ni89Qj9KDl/Yk6nF1Yf3W6A1XHmr1j6WoY4H35Tn5d5FkCwaj5QbIHSwFT/Y+WEFSeLwZLLOqSlvrUzvP0FyZ9OuEsvekCG+Q9CmdfLo49qSV4nnML3lr1inYiKxLEJg894ASMnTeTD0YEMQqPbhjWFWXaWLMDwFIXnS/h8u541kVANAj0tDGS1Q9JBNs23KlVn4N5rbDl4KljboUIqRuTuDzplHPOkmAJEUAKkX0HwCJuo/8E9dkiFuf7XhmKRpgVRGFixiaLwgZo7OaOSa1hSq2wT0c+qRNZc/kYlEzs5GB4iRnY8K+FNvkjtdEUI2Ass5xHZ7UhIOjNP4+Lg0naMpgvg/tcCvfXHImKypax4LsabAkdaTN+RznnqCwscEzHqIgFpnGVJs/2YU4UuHm4GE5/XbUOkKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10 Nov 2026, at 9:52, Kiryl Shutsemau (Meta) wrote:

> pipe_to_sg() tries to steal the page of each pipe buffer and pass it to
> the host as it is.  When the steal fails, it copies the data into a page
> of its own.
>
> Pages written into the pipe with write(), gifted user pages and page
> cache pages can be stolen.  The ftrace ring buffer pages that
> virtio-trace splices cannot, so that in-tree user always gets the copy.
>
> Always copy.  The data that reaches the host does not change.
>
> Preparation for removing ->try_steal() from pipe buffers.
>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  drivers/char/virtio_console.c | 39 +++++++++++++----------------------
>  1 file changed, 14 insertions(+), 25 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

