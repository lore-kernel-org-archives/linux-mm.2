Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48A1606A33E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aPF037iZ
Received: by kanga.kvack.org (Postfix)
	id C66DD6B05B4; Tue, 10 Nov 2026 11:25:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C17506B05B6; Tue, 10 Nov 2026 11:25:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B064C6B05B7; Tue, 10 Nov 2026 11:25:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 822656B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2084B160475
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:25:26 +0000 (UTC)
X-FDA: 85419734652.29.29B51CE
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012029.outbound.protection.outlook.com [40.93.195.29])
	by imf20.hostedemail.com (Postfix) with ESMTP id 324A01C000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:25:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aPF037iZ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794327923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVQ1Gad4wlBLHpJLvsZR8WLtZuc4RJ1B9UQYRoHfJAU=;
	b=VU1cetBT9J6DzuQiLR3RV1sgV3Mf0Vy8iOQyeuIkmmmCCKDjePNJiWF4KSarcS2qp0goVJ
	g6ydTPBUUK/FU68W2ma11oCIo2mKDoeMtZ53416Z9BOY7xR0eFWeO5c/37mkGPCfkosT89
	/2Qgdl9uAMb+JExoLJN2E3r4uDInyWk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aPF037iZ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794327923;
	b=wW4kqziFxA7fBLEnoZHi1JlGo+4ySHzYE2VJhKahoPlq4iVPdIXNvwG6sP/+ECJCLqtHS8
	jhDlv4CZ0jp4NKIcYbrhhrg29jetuoCBIDqb9bMnUvrXAohTbQ+Rm6akof8KWatvu+7Imc
	7eb1q3esDHjHnL36dxV3i8PnvnVh4WI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M0s5h6IXB7Bv/3+tU1/t17p8hZBu/lsYf4AIP0WqX2ip+XdqG9yDRq7PFIJjWBdOZTlc7BjjJ4BJ75s35QFHcaH5OkBQaCkd+3kPgw4OOK0rxnwtLcdaFfvB+3KAIhgwbuze+r9XUTJ2C4tP1v9NbpzfohxvnSrUpQFwfysZAfA+/RdLxwsBNiKIzYDaIoHj5zH+R/fL4Ly52IbOb4WZ58nl+uNHprAjryG96oKHfW4lQZ/VeGkBzq+hlZiWDk1qr807WFu5aOK1THOpUKJ4gkBGfn0RDRhRbOseXYbK/LWAszWQazEJEQzgCWzb2EyD6r6qc+pSl4lNTKEm8D6o/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVQ1Gad4wlBLHpJLvsZR8WLtZuc4RJ1B9UQYRoHfJAU=;
 b=eG6CPPFc03BYtPOGLbuv4B51q7nNhhIwOa18ACKnSqhxWij5gkLQt7+kuhoPhkYG5+L3IrVAmFK+lJ5Lu/RZrxRN5b+/GPVIvmc42CRX78HzJGbEKpYewU8Cn1D7PSB0oi2hoiZyIjDH/ev5xHyR5JJbqga8YQEwvzbZO+s33GozVqmaeGVhW3VRqorXgSbxPiaB2MCOF2gOsooiMx5VnAhhiwFk/8EOMB5fZt4v8OyQ36RzTMn4uBtJYrKRiTk5YfagHAcSoTf3u0XszAM54OVU6poXs6uN2IluHNuKqbD6zeCrOJnFkeEV9ce8hsMCcXFvpcc+xmQcAklbBiYMWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVQ1Gad4wlBLHpJLvsZR8WLtZuc4RJ1B9UQYRoHfJAU=;
 b=aPF037iZgw11r4OYxU+Yjc5IvwEDLIFPYJ0qmaymBA+Do/IqC2LCMkxQ8DgRRpqIg5nb171ypW2RAOmMZtrRNtqwowyWvEMexQue4eUJJwu66HMyir04Cnos/R6ZmTVc2ZGg4E/uYHTjrpOOUmrYhEktOTS3ZiDH49PK+T8SgefsItKiLelr2yZY1UFq/UTZfD3d8YHpVT+G2WhvFA5eFx2Htl/uA80eQUrjjRTwzKelfH+OiDluPuKVwl8h6k6FRbbI2VF2yLToAQejXaLNSRpa0UZXbtcbOkjWkYnmNBn5U2NjOBWnfoti0/U53DAUXePnC3wxE7IUT3hx5gDw4A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA3PR12MB7860.namprd12.prod.outlook.com (2603:10b6:806:307::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Tue, 10 Nov
 2026 16:25:16 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 16:25:16 +0000
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
Subject: Re: [PATCH 2/4] fuse: don't move pipe buffers into the page cache
Date: Tue, 10 Nov 2026 11:25:14 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <E2659C58-E0CE-4078-B959-D3F61C042AD3@nvidia.com>
In-Reply-To: <20261110145241.536019-3-kas@kernel.org>
References: <20261110145241.536019-1-kas@kernel.org>
 <20261110145241.536019-3-kas@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN0PR02CA0014.namprd02.prod.outlook.com
 (2603:10b6:208:530::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA3PR12MB7860:EE_
X-MS-Office365-Filtering-Correlation-Id: 49400587-862d-4c08-5d9c-08df3f473439
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|261026140227099003|11063799006|4143699003|261028144727099003|56012099006|261102123227099003|261021121427099003|261021123027099003|261022105027099003|261009223027099003|261026121527099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	W8jYALF9ssjT0fsNS0CZBUJ2glyIS6t1HyIO1llcVWYQeWoUCqODyJyGE34rYjBnFLt5RT0x0RP1wFLx0PWUwUr1REVs6diz9SbhJ/E5+UGgVpWjyeIpSJ9HbmJraO+nMnLNSGYIAFsrb89Jka4X1s41W22ZqjE1A5EshvxJPRoihglqLXkF4LihjLgEI+uLKoy7/setGr6oUiNyTBw30Sys2xyNiS/Nuh9RthO4UDfyBvNWvLGFp3FHR25I3Q/KMCA+AgEfkMVnPlvgzyu9kZfj5HbzVkUsg+J5E5xC/6Fa3zN0K1M5BeD7kfF2tw3ia8Y21xfY1lA/KrHMdsg9FZnTacDw8ielEzPMIj7o3PmTVxgkdMZCY9bhzS6DsnGMoAprgL5fhvEdaMQNRQDQiNBEA2LAX8mz5BThBFMdUfKlHh1o2SMgcSbKPtQQ1PHQyx9z5jGBPOclsK52fvW2/DNWYloXOolNhsGBIVykq2J7lcx/Tnpy8RkFkiAezbfE4X/+9iD0Bw7ixZUpGm5NVQ9yByByc30uriRWcCepbj8PUNMMCLncKUHxmyWo8H/4g7V91se2WsKPHHrHk6cWDyoBu/LDJCqCcYUnuAXiVBX9vbiSl0f59EJwQlt2PwEU+XfBDHcGhYXLaumQEzRlF2002TDoFOlFPdLY2q2iA9o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(261026140227099003)(11063799006)(4143699003)(261028144727099003)(56012099006)(261102123227099003)(261021121427099003)(261021123027099003)(261022105027099003)(261009223027099003)(261026121527099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rFtCxfcRNL3ntni4crmxqyWedXy+I39g5w3t2/tEctBCFrhqWUCokcFM7X6H?=
 =?us-ascii?Q?UDtyF7i5LTDK6ZQRcL0zV6Znh3l1HwQrB85BK6sG8JuKeJb+vCpzv6s+9qgc?=
 =?us-ascii?Q?xBDJaHVKFszejptUPmSo9XiiFEjC8s+cjB3soviJYVqZHtjyxuKv9nK8niUC?=
 =?us-ascii?Q?UQJ8Xpm7z/yY5h08c9p9JwIUs9lyLQYXlNlioEEop9GTcUZZywgalrU5CM93?=
 =?us-ascii?Q?SpGrx4IP/8s7QbOZx/4ov534h90p+Cy5yp2RDF3JfgFO1pth1kMsRKt/Jdys?=
 =?us-ascii?Q?g0Ccf32lNA4sXP88BoyLyWWqQWpRcNEIOgzwZ7tof272M/QehgeJkrGRrg1f?=
 =?us-ascii?Q?hQn1OW10W5ug20yzQkRSVxmc8GeaBw+TwRtyHZEKsjPoyjOYx+NV+RaDfo7G?=
 =?us-ascii?Q?idKs/C2eSSXuQtjUtlb/PtDyR/Shwb955ui4RuUUEeH4fhg05B7o4ILesMmt?=
 =?us-ascii?Q?5LKZHmNQ4Lf4xhncNHXt3x6xyaDQmpSYklUvgaeBC2K2MUIHvWj9rKOZGjkr?=
 =?us-ascii?Q?mIKO+7M5vYzNILFiHUpcF1XB1mM286P5NMuQiprP7xCtCIDGULEO2IH2yPlZ?=
 =?us-ascii?Q?/lHJiHjNhVKVtlgpPZ+BsF8WGecFuoCCiRtda7z+zXxCcQkNctXZZnUL5qeE?=
 =?us-ascii?Q?KDKQfRmcFdTH3cy+3tLNkg7ddOcguXK9H9qfDa7BNVyqUDRs5+AVurMU0Cy1?=
 =?us-ascii?Q?S2mYwehcGRrIaaBcWo8yMBJIRsU1wbmaT3Yedp3hc8bqBUohBM0OrPgWdT4K?=
 =?us-ascii?Q?/oSNjqmNS/pflqY/P6Yt8NGMi4qo8Wh3KCPLcsi7g78XTu4lgxMW/b5vx6qZ?=
 =?us-ascii?Q?ap4L3zS01uzfCbt/IzYF0D83kLt7DX1C/02dx1VmBJ26P/MJcUlOGsQVXpa+?=
 =?us-ascii?Q?bgoyGRswnXK8saJ0S9lI0nrwITAINjEgiFuhzE5owXo6tWnWzd//GImH4BBs?=
 =?us-ascii?Q?HiyhOfBm7VZuSC9bOTCMKczA3vHnDYzDeEK+9CiIVwVTf/3AJDBhrx/ovwJ8?=
 =?us-ascii?Q?P5n3dMabyX1sg+kceJ11XGSZfcw+voTh1FpFGXtBdLfj7+f8rUyrc8nlID3d?=
 =?us-ascii?Q?lDIu2LBSKPvUzFz6QjLOrxxh6hOM+o/aOKR4n928FJ0/7tv+t/tPogrI3w2Y?=
 =?us-ascii?Q?lvIFK5RPVuwDHIUBtKOhmMuggoI/H0dbkYhdzMl37MZJTAsQfeh0vg1fQQcb?=
 =?us-ascii?Q?Yts5VbUBy4L26h3oOuHFcBcXxOtU2qPHKKMwAhCl3V+Z0QNGNCQlMKLqt19N?=
 =?us-ascii?Q?2+VIJid0QBualFqg5p1uspYVh9OLRW7hfF290pBpXx3kyVbdg+BlFF1UjXyI?=
 =?us-ascii?Q?id0V55gozLmJBCp0xOWD/nTeeI4br5oc0Qthri5J/xmvrOx0jdihRbD/9HHH?=
 =?us-ascii?Q?BW4MT0CleugMremID87dXyU1UjYCoXRT+JQEVD0qVhD92c2Hyzp5omicclfB?=
 =?us-ascii?Q?KEsPzv1i2jzLo1Id4g65JKFcXUtMCVVJdlt4RczB9M/nktxytkKs63ajdhw5?=
 =?us-ascii?Q?bDtnSzX0OpJQkq7BHdodKEOyXTwsG7amIdwsiUo8LguytD7tdrLQQEsZ1z3Y?=
 =?us-ascii?Q?hs9srQp6044ZeyoZ0+Kwe/OFdgYLlIhA9/IvPHaFfg5BM7Me/ZO9haApnreM?=
 =?us-ascii?Q?JTlMYQiaj5W40GX/nTDezT0oZeieW3euVTy1UBG9AHQoe5s24pJItQ/oF4gm?=
 =?us-ascii?Q?+62JS5JSV7sSgjLEKeOAaZD9Tp0KCqdoMGbBqFwrBTbW4BzR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49400587-862d-4c08-5d9c-08df3f473439
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 16:25:16.2389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nr5Yvu7Kb0f77kzVIez6qS/+Ii0p5BP8RyCsATwfi5hLqNOyFdbxovJcstW5EhEi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7860
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 324A01C000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: shwnaa538xabbju4zse6d4ame851obfg
X-HE-Tag: 1794327923-796460
X-HE-Meta: U2FsdGVkX19oP0p63z2GY5lV8iJhpAToN9m9U7LBF/0JOK9PG+MIaeMHAGBzVEr1hxdG2EF3IjX1czJnF7wMJNIuD07ekFGNeBto0k/SlPZmgsb4aKiVAE6Q0OkxpKs2HnqG9GsVAOqRiRgQi/U9zv014hR+X3dw9ivx9JH1Tk+Ny9FjzvRKFJY0J1LwebUJfNx+r4V7YT86kpKNNvuafj8Stx/4C7Bm5NzTtpbtd5+rrjUTzlwHu1cKVJyMAgG52bQ8FYWDvGBSHbyMVxjJKfgZfotD9ZNqcNvT5na/xSIMPuR3aL5nNtV2zXqT9UckTZcI7uCXxYWRh+YH7qflTRW5mTXJNxNXX97TS8AEdwoxv+P4XzNEGSgSmZOS11UFMiAqyzF4fKmhLjUYap5XgEmHzdjXD8Gwfw8WXMrst75i5fngESjW926mK5GbCi+tPK4A7mTUcyPX272237I9RcNpXE6Sdz0XAF0Q6+HjOXeP4rhhLF1yHIoy9ycjShkVe4kswkzJfWCI4eTDs5QzcUJJDnD0n14z58jQKIDXaLLaVY8+rf/SpsGsZWtDclq0CpAPwT4UFiczKfwI7aSea+x1AKudmF7K28Z6Jj0fRNlw0U/Fq8hZ91jn0zhvkhPVGtENRBYfki0xb8ZV2G++wP9Az436nTMUFgktyirg2vjWosaJr5g/60ahatGwIVVazXUZW6UYriEP7rbEfKDmT86ZvjqOUvrsw8RlWUmUwUMPHw9l7a/HhwNv4YtugJXNu509lXZJwj95GNG775mhDl9R9tTOMyCwDHn8q+/Z3Bu1CoOwIwvA8SQ3n3pd0EEsniCU/YaR9vBdsyVBsQUGe8+2hnEd+GgxWrfHaFtsBLpfmcXYDtLQaM5DUkgR1VMVANE5EAgdh4fRkSIxMonXZn+5Kw+MosLrN0CwW1V0RU+oJa/ZFGb2U/VwfvcruEM+J+tqK1iT13mEkSf98Vb
 /onstYQJ
 7hdTBwmDmXVyieRvIcAukBoDy9iiUlyn+yxCzbhDprcIBRmmISjgvQf7oJQ7h6kL/B8oBQ0VMi4lbuUqPJoHng4f5MIgaqCHY82Er9HjjeaOScCWz+0mZoORGjcPNrfw2cHfTrtDVEDD7sT1xCkP0NaRqqw6qo1Jfa7NgpC531zz9FlC7jRo7qVNun28mB3eCvS7VXuuQ9jd9dgeBJmvZ9oNpTWsIuV/jtu+tAAUiD8F3vFSOLhiuAFyVhUhWjp6cXFFTYr0Z+fCORs0bN6huz1NiYaUWAjKTxNLxO3Z6R5WImdLu1kWmTH8WADXBsf9fHD7mBWwDmQPoCt0fkXB6xtgalD3979n9ZJHRgpWHDjRo1f9LKYgqu7yBPWVeYyhKceiSF09mdeNjmAARikKcdWM3cqxD/kK0oL3TVrlmbXhejkGj5KAmPh3C21jw/epkum16xt3U21WWCcCBMm8kCmZr4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10 Nov 2026, at 9:52, Kiryl Shutsemau (Meta) wrote:

> A splice() into /dev/fuse with SPLICE_F_MOVE lets the reply to a read
> request steal full pages from the pipe.  Each stolen page replaces, in
> the fuse file's page cache, the folio that the request allocated.  The
> page can be a page cache folio of another file, a page written into the
> pipe, or a gifted user page.
>
> Always copy.  The server sees the same data, and the move was a hint
> that splice() never promised to honour.
>
> Keep advertising FUSE_SPLICE_MOVE.  libfuse fails the mount of a
> filesystem that asks for a capability the kernel does not offer.
>
> Preparation for removing ->try_steal() from pipe buffers.
>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  fs/fuse/args.h       |   1 -
>  fs/fuse/dev.c        | 144 +------------------------------------------
>  fs/fuse/file.c       |   1 -
>  fs/fuse/fuse_dev_i.h |   1 -
>  4 files changed, 3 insertions(+), 144 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

