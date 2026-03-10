Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02822FD4F1E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 18:40:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357DD6B0089; Tue, 10 Mar 2026 14:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4B16B008A; Tue, 10 Mar 2026 14:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2336B008C; Tue, 10 Mar 2026 14:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E424B6B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:40:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72F5D57FC3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:40:55 +0000 (UTC)
X-FDA: 84531020070.02.E96A274
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011070.outbound.protection.outlook.com [52.101.62.70])
	by imf21.hostedemail.com (Postfix) with ESMTP id C95CF1C000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:40:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=beg9iwK1;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773168052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nNGnB15J4CeR6Mr3l96V+extri0ZVidlCr6OR5s6iBs=;
	b=NOzU81lEtEu6Uk/jsfPfas21efo4vvBAiebaKeVMhWMoiVojCCOzvlf5xAkXg1KoICcp7t
	L8KLq+SsjSUXbXxppa5tOy1w1am/CT/6/BJN/4IkXbuS1coopVU7NRkJJxX8p66sYAkkDx
	6SKCAy+zlYfq4yapY872pSgTmnkrVMg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773168052; a=rsa-sha256;
	cv=pass;
	b=T8K+1MeRK18be37JG1h3ZxdrGaxIVgqpY+ZToZxd08vWVxZOHo9gZ0zJ01CoFGr2axFk6W
	6qjQ57DHBSRB4eYbnk31tMJDQG4SHvNpCVbs4d/tqYZCdtd8HnGF/BBJXGJk8kEOLNuldX
	atlPzSQ26vNol+JvN28VFbJEXyOVguk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=beg9iwK1;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XQfl1DGCmNuSE/kEw4pQbF8vgCZ2JrIBVx6Z1FT+svTaLvxbNEMy04+7kAJgVbliA+HtldJBwnXTOV/4jfaKokKw/s4K9ortAxB7fVSg226+9H1uNayM8kBzZU9+hwZyJ3jUMsFdA+flomZt36kNtR3/yZ6v1yfX/RKE61ELsiVUi/pXrVyYf50vO/qZou/IKrc083cdR24agdgPmDzEHAQ32Ze7P6/d+tCHVqgA3cpldsz5/8rxxUdIK3jFGodxyUQUHe2U4V3lr2514lhPnLKPXASZdKv48fgnI/4xPrfF75pta6BuV590j7U7SYxy6OvcTbd4BZ5ndCEXw/E3UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nNGnB15J4CeR6Mr3l96V+extri0ZVidlCr6OR5s6iBs=;
 b=R+0FGuBCrzCt7w2qscuKiXJ9CA9ins7cGynAMnidbM6Z9WVZqDXmoKGk75q6+Bu0lKFKfkrfibXTYgyx7lyxzWMWnaWvgyuiAZLPUH0EgaxMv7rIhAVxsOTgL6M1stTzr2pDonvz1BWmccn3ggPgmQF9/yVmGENx0oDFwFk491Ps91a5CDE4bmsrtPE6RegycFvhE/4C9uFSHKNI9uF1Tu2uSwZi7HKFOJ6PpiI09F4jryZHpS9n5lwBwscb1fr8MjAxPp3A1sa1glQRV2AD4E5XS/CWpb0PQpnPUT56mhZ9H1T20yKbqd9ygG6PGWM3NghuMY07Pnk1SBYcms/vCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNGnB15J4CeR6Mr3l96V+extri0ZVidlCr6OR5s6iBs=;
 b=beg9iwK1iX+Odyoo2MZhdfuYDFON3aKaYFD21ItB1aN6rs8AQL8j0hWB4Wzr93uPq5B1AvTzFe/k8C3s6PLYXIrjvudLUs7fL5LuyttAlNhvf8v45OxTZZx0wBtLNcMjRgvmkaJAL534XP3jkknk/2EouM4ur2yXE7yFKpxmzfoic23gF/FECm0YRsaw3nuoO5meE9JFLTbrIcUSzTy9HTKcblOaCsY65eV9sxIj+x4YXEEnLMQxJzhmi/D5sUTaiagGJpvmabb/HZsvhujCNgYF5UO9mLPv9R15dLNdqyKyyR7aeyqkhQWjFWarecONDo9ZE/vGOZX8mu4QFfYZ6Q==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by DM4PR12MB6400.namprd12.prod.outlook.com (2603:10b6:8:b9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.11; Tue, 10 Mar 2026 18:40:46 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 18:40:46 +0000
From: Zi Yan <ziy@nvidia.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [PATCH v5 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
Date: Tue, 10 Mar 2026 14:40:40 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <B4212A5B-4161-493D-AC18-D7022614B4FE@nvidia.com>
In-Reply-To: <20260310-thp_logs-v5-3-686099175bf6@debian.org>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
 <20260310-thp_logs-v5-3-686099175bf6@debian.org>
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0013.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::26) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|DM4PR12MB6400:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fdf5091-b592-45b3-fde1-08de7ed48aeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	UueluYDaRE5U04qnm30KmimtVN2eIyt2E+y+ycWp3asTnvAFou8S7oLQjFQ96PPhbBgp4r11FORelHAWGW6HDNxzKL2qpPPKuX9swrDH0sowUurtvIHjyGOXyXKXkPYaJHexs2aIOxsJnayiREsoNgoYIXGNmIIm0WKp0MBXWum7KyoYadU8+Up1fY5x44fvhZ8NRRpjmnQtFnoxCJxmAgZEyw/9pTwVS9x5svO2yoUSNMFJqfuBB4un01GEDslJkf1y4pG29q4vFVPiUO5TAAiZjUXMAxoa3QpFz7VD0yzhG6D3iCu7OSDjy8+NnZCE+91FhJF6b1Y6GOf5AsiS5qlB465bTpaIpCuWQATcAt4pzyvtr0hETuxc6CufXrk3HLAzsgPW12LQ3hX4s2JjNgfvWLgTPF532hbssze65EMT4b75p+JTmDEkUcP7GYw6C3vGtE/3oIA3ZuNvI6C4BR35MEWLST1RBcs5HZTEJp477PD2plZrgpbuqRlcJ6f4UL3EXhGAjoPAKr5H3QcogarTviX93aYBDOu6J3LzWDh0Z+j5zyTgln9wdBLN7pLcGoPuSFmX9EabQ7dIJNxYTT3kyNgPxbl4r8KvGBKTA7Gsw46bFSRsp9qVc68NvHG65nRR15ovMfG7Re7roSExVzuLD5qgG/gvemvcj+6Md8pRp6MG7ZdEpFERtL7m1G/h31fQ8wWnJjLIe5wdsZlyz6gWjszB7WoyGLobSMwriZY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sOpVIy+vlOssXFn4mLskKqs7pKJxxdX9egnFiNn0Zx7YBAsP0nKBvHnDM9bI?=
 =?us-ascii?Q?xY0jN8F+Jpu/UTDlA5tkAI6FvoFYUQcDW2y8+OVMEF+jxESPVC+hpTfg7Sfr?=
 =?us-ascii?Q?zWRGL4P/jC4pmz/xFOB+h82frb86udmtXFxoZOrbCyJzTUA8jNm6eElJ2QvE?=
 =?us-ascii?Q?+vvkxkSfviYI5Oh20hLlA7aiiyhPC4hqwv11YPkOlnrRCVGpxXJQi2qV6+rW?=
 =?us-ascii?Q?+XlodeQUX2jW2J2s4StIV6k3EQRt8jPiY0u/bYwytPTbFHEMVJXh06uGD84X?=
 =?us-ascii?Q?g3xTLdt0xlGZzvQnBhWQ5BVWfc7zlUi6jDYHrxma7ZlgIYsrYQ+iP0oy+c+F?=
 =?us-ascii?Q?duWJVrd03Kl6Ov7l1AUq9M1C428vA89Vw4GkJHHRZCzGsjjlxHs8d/rV7ngN?=
 =?us-ascii?Q?c92mMYXxYfzOCSh7JuSNDFqLFea8wUuiHm08CiAmEs0O0jCG+38CaXkSRlWE?=
 =?us-ascii?Q?IsC5T0KurNk/KKZIO0xoxoK4JN3omCiwbGryIJzQby7WamQtxJ6RxXvR0PC9?=
 =?us-ascii?Q?9RdPctAhnsvYSi8qGTwMUbisx3rXgRwcAYKSVW0JHS2f1fJoKdVMgrh0gqiR?=
 =?us-ascii?Q?ZkJRNqR8X+IKrBf7Op88Ax95VT6WI0OVU38fJLqLXNX6CwrqFk5PDC623wrX?=
 =?us-ascii?Q?+AswNB2WD3v9KOydDbidu1xCKFT8jwErxZ4SgEc1LMPLCHaAo8slXbn9o98B?=
 =?us-ascii?Q?gyGzi2ruqSdgO5SocmE9gHIvzLL41LuT7jfODhGlpneV2kapKaZudbQyAPUx?=
 =?us-ascii?Q?+TYfyrL+vj4IlW+5BXqNFw+n4l2PhKqcKaP4K5hpo1/sfTRxwEqW2JnPvaBb?=
 =?us-ascii?Q?QOUfLO6Vu+iekfhUwEKcFTX5gctnL5zYjI11qz3PebSJxX8Q6sVlsMfeQiRo?=
 =?us-ascii?Q?naGtvOed5/At3z8PnbjEZo3lyNfgPMFcaZMXZquKsxMseKRnI1h5L4mKyzIS?=
 =?us-ascii?Q?jaIk2wUoKvYBYrzsvuKXkN1AwWrgApNhGJm0K/aoY5GVpuUGI9C+f8W3RnGu?=
 =?us-ascii?Q?zrvhEuovXbBWg+BcmmEPBg7WWtKbdybSCzlZlcvvQaeONwNEW+73n2REN5dB?=
 =?us-ascii?Q?T2FnQgxf33ePLnSu1I27G+thMfiUjNsW8w+sQkUu+7OaInXCxAbXJlB6v8aX?=
 =?us-ascii?Q?CmEYisGSO9Pl7fu/LvkVB3NB6fu/a2bAfsAS3UhGpboHJ7t8ZVQAtfWB6hjj?=
 =?us-ascii?Q?DlN89cBYCz8mR+RDzgNbYniAi+7vMdj6LU9y/SMety/Fcug1rmA/U9Ix9Umy?=
 =?us-ascii?Q?XJzn99eWVtjExWpEz/4CLqerxMkrMAwsKfTcUg+X5WBQn8LTRbLQsofLSUio?=
 =?us-ascii?Q?SgKnTH3hpL9FP+kFvA7ndmQB3706gizlEzgFWd42zjkMtErmQQqz8Hai7dI5?=
 =?us-ascii?Q?8MZQ+cTq9ctqOJRrxF+CDIvz3mU3sYfNtYtRzW819smmbhL7dA/P8vVTdhp7?=
 =?us-ascii?Q?cQ4nGv6Qggi1B6tB/m7ZucxWt9YzRrgg5PNdACdgHAbvu0zj6bdwiQsGH1Ga?=
 =?us-ascii?Q?ImTK2GN0Dn5KB4ohDStyADAU5qxWgHjPtDgJS8ZFTP0w2f/bC2HfrSsgBjQS?=
 =?us-ascii?Q?qK+vJlDu1P+6wKtBVEP4GpEq0O/YG6rfbo1xiquohB4iLTsmND5jbHqZS7DT?=
 =?us-ascii?Q?tEYEu1yzHzJjEgGbQqOMZilo3MKFSpR1mlSOfVOnPEyjm6+Dd3/d3cWhSjIa?=
 =?us-ascii?Q?yoUBOLCWRZYHAjexQ6wf4rRb3jlk6LXynBCwzL/tnSAMyj69kM/jDR8RFUOW?=
 =?us-ascii?Q?xEZLkoS9XA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fdf5091-b592-45b3-fde1-08de7ed48aeb
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 18:40:46.3123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F8CE55GQsLRhYejA6bH2gWwzn7chP8VXkOjlV4snGT3jfV9K7fOXQ/GcViQM0bgY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6400
X-Stat-Signature: jgee4ay4pmt7u7y8px58ocd16tzahgpa
X-Rspam-User: 
X-Rspamd-Queue-Id: C95CF1C000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1773168052-874631
X-HE-Meta: U2FsdGVkX1/dAGWs0Zd2QZ87Vt3mdk67P7e8C4mIwW1iuICDMspWuELpZJe6RVAcltntgCh7dDXWKpB3FYCaksVJv380qiUT02urCRfC8W8pjjFztO6Pk+G4650Qot9+PZeM+LrbzvPxSl8Y8x9lsIM2B3X6R3cX3lwNxmw7bd+MNARcesmd3VECQ2f5ZLZ7HoYd86sng1WrHa3vqcKI4boj4mxZU3C1uv/lhrjFTe8gaTlDkwFgYicHtNzlh5Bn1+PUr+NgLT5pOJDYdFi0fm1zD8bqhyUHKQbPYMyeqhIFK2bxxp+vGWhpvOYWhaBGX1AlU8rprT9pNT+6xA6boWvkl0fmyPv64U7TEmlnr9PvDp4w0QClvGAJ1aNJA61ktBXPiaL8WuRNkd2zSz7ojg/Aq6npRfBnR1/xOkBOOKXxKtLw7mVSUAJUGE95NEMMfl1ey0pZRgersBCZnQRnjwCXyf1KIrpuiMOjm4FttDADIdjCAoLDP8OZDOsdo4rjynXu+aosTGa4sEg0/teFX3/dYatK23sH7L7jY8lz1GL2vrCzNFq3dMpVts7mc39vq18W6Vu7aC96qxjG3TQt9M2fBoq6Sh5R9Za0F/VvVJMQcIWqPLE7c+dLVVlSe6Awd6JGKHdaQ1H39mIPu7kcyuU2yRih2dhW7MX//eZpIkyO3YJQc+Q9cZokLZeCbzYP2Rl8JBIWJkD8of60A3SO7bxUcfoZrauW29sQ90RFrL6PL6cpmGaOYV/iBwAzZiFNWgaaG27EZmtsFy7sEHO6zCYy4FdeYtP6uHzu1wveGOgVaQMii6nESEtT/zILUlTdFTKMHGU5dv8BEta9VEHZRjywNjDl9VqwAicZ8WevYiboJWKUzdk0pIg+36Cbq0HwgIOptjM2Q6ivNcqdfK2vcy5rgmcAaXzIE8bI8dJIbXp3JlDYnJqubBu7bYnnzknFLkQStg0bWMlE80pP8Xn
 iEAIPFsL
 eeJ4FsgQ/B9i2Nc9DarbTbXgJ2wYiOwjef9plz4K+jlTcfSCaiVzjmHiji+slftEwoTpA4muhqnUzA0YrwUVUbUF+usnnk2V0Yd4NlV0ghm+xT5uEp5N9Fks2ybQlxL/1kdG/lZ2O9CpQ11rdixEqn1Id2SZvlh+h05uiEElWML1p+R9E4oZ8rot1ot8v22dZTm+V1A9AOFJoS86woCE0SevLGZoi29299edXhJ+cpSQmk2arnDJzChi0KiLEx9YM+qFCzPlT/CXdrfRIMT+yzAl66NKs/o+H9pYOc+eOEh09Ld0SEBkGOMk7+sj+V7CMICeJLfWAudaWUxxbn2copqizeRyEhjgwwkxZLAv7RBYKYnprANPeLdNgGyjSYIzWgHU2GXvqmuciW74/HinAF2QdmE0Zv2CD+GKSGGbFvg+O5U1u9NbX5rKzebz5ZEomqHXx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Mar 2026, at 13:57, Breno Leitao wrote:

> Refactor enabled_store() to use a new change_enabled() helper.
> Introduce a separate enum global_enabled_mode and
> global_enabled_mode_strings[], mirroring the anon_enabled_mode
> pattern from the previous commit.
>
> A separate enum is necessary because the global THP setting does
> not support "inherit", only "always", "madvise", and "never".
> Reusing anon_enabled_mode would leave a NULL gap in the string
> array, causing sysfs_match_string() to stop early and fail to
> match entries after the gap.
>
> The helper uses the same loop pattern as set_anon_enabled_mode(),
> iterating over an array of flag bit positions and using
> __test_and_set_bit()/__test_and_clear_bit() to track whether the state
> actually changed.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 48 insertions(+), 15 deletions(-)
>
Nice cleanup.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

