Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38DB1109E534
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 00:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3BD76B0093; Wed, 25 Mar 2026 20:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC5C6B0095; Wed, 25 Mar 2026 20:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B59D6B0096; Wed, 25 Mar 2026 20:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 739356B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:39:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1DD4140B3E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:39:31 +0000 (UTC)
X-FDA: 84586355742.23.070293B
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013052.outbound.protection.outlook.com [40.107.201.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1CD3D1C000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:39:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="dzRjW3/F";
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774485569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svQfZay0dCf9ut7L72mKvgrKnzOFGDro2oib7yVyluQ=;
	b=5+o0+PrtWiXjBQiTyVWT8M+j8ZMp3wbg9WLc1Tu0Ymxf+f61GCGAsebELH2Huz01RGCTDB
	zCAGLb8ndx2PtFu1DftYfMruzPcOcUwMyn+Q44SgKNrS/CLL6y9sW5INr018Mt1pN92Yoo
	1BC0pwl7yRVI5+oKCR7s5uIDu+qCI8M=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="dzRjW3/F";
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774485569; a=rsa-sha256;
	cv=pass;
	b=yVDTiqfii7p2SqzdKIhrI3EJ/NoJ2+vo5VZaCNZQbiC5kLvGjjwu/7w/qE5LS80ciBhMXV
	TKRoNiRFrJC38wFIgkATzACxKqo/Fk5RVKs3s95/hphgHnFhzNGksErzsbxRSEzkAYWJuS
	Zolcna28uPWy30KRkIol3Zbp/3+gUm8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ltyDZR8Si/3Y92MQLJFWKS2UPVSCe+nNGbkiBovS9zHDsJvQwX39ECHAvlAJIOEaj79VEG3pYcEfwAB3O9KZLg/KjzBjhVQTNYvWb2TDppCkYQRcGWUWLVnctOGxKAcqL351Kuv0IP8GCsSo7gkfkis7G2dz4qsEfA4u1m3yeq4bzCgQ6Wi097ZV6E37hVyTDAJe+YRrFxJjjs4F6twyC0GhSWEdbZMa61j3NzddgCs4zpLPybuV6cnm3vAe0sU7EyWThL/BzIHkLgAgrUg5UKxGXHlVlreGeemdlGBGJb9mDv/4fzeFQ3ZOcRf3o/foh54PnhPViG0Okmo7kOX+ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svQfZay0dCf9ut7L72mKvgrKnzOFGDro2oib7yVyluQ=;
 b=UshI3Uwaz1HHeJSEGUnq8kICYWBCispzS8qA8QjPqm67bHE1klWsVkj2N69YAMcCVxs6gdRs9uxNjv5XiCbaVpIGjKgjYLxW6W8vhbzwpTLjRYAavDTyAtb/WISS0yR3ZVuZRqZ8GamJXN0y1qx0+lpn9b4Hf8NBpt4vBlrq04qCifyEIH/7RbffP+P4GCUze9kqyxzl3qhrOiVijy7EIzKgzq9D5Vmqu63C3SY1DmQB5ZdZqM2u9t75IVyHpKZf+JePZTqVMsfYpSxy0GBi9sLP5vPNmHR85cPGmOYiboTHqtmNWJWDpLiZi6fZF+wfjuvBO/qKnvqlT+l5aJp6vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svQfZay0dCf9ut7L72mKvgrKnzOFGDro2oib7yVyluQ=;
 b=dzRjW3/F0gZo03lcOE+J5mwFcA45ZXYrmyvPr2A+ndzxqpzD5/OpTIXuZW8qBLLtMX+2VvZ/JFGyMiXUwNi1F57GSixa8tags2D3y2CstLI+j3ZYgKr2V/Sgv6aGxliI9y2USmk0p8/fGh6GXf03rk3ycTJfjhdjKs/E+mh2kxyC9veuI0fmmGEDk/W5AWgDcuGb18OEMHDJlpDFCnogaIw1bl5/Wiq3Z5MaO4mWQkMAVAkLBxihsiAnHAx+U5wDhUXCO6R5OFw6UJt1HqVXrjPrpNXOAdzxBqPeEfEoCoLWmEM+QBwmdRzWKiaNSYcRafNEIx2kJK7tQijaKv/bWg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB6222.namprd12.prod.outlook.com (2603:10b6:208:3c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.7; Thu, 26 Mar
 2026 00:39:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Thu, 26 Mar 2026
 00:39:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v5] selftests/mm: add folio_split() and
 filemap_get_entry() race test
Date: Wed, 25 Mar 2026 20:39:17 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <F2131A03-5BFF-4D94-AF12-199400218F5F@nvidia.com>
In-Reply-To: <20260323163717.184107-1-ziy@nvidia.com>
References: <20260323163717.184107-1-ziy@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ2PR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:a03:505::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b6f57ec-ddc0-43ae-e01c-08de8ad02016
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AmA2+zC5Npb6L2RtyBTNTiy504XUGq5C52P6+TPrbjf0YQpdO6YDXDCgRk0wE8/xtPSjNtSgEupo2cHmR3XgLBrpaaiBT+y8G3gXBuARQUbkP6Mov4Xa/qSz//UuoD+JOdHCqtXP5PVzbjcLB826CzYwBcBLeFP3fhQ+bCxQ4j1ThBL+bYsHBs7Rz+87+q1jH98hnhUsjY4JXsXZHVhhK81jepc9KwwwL1ilLNkvt/TBhfIfuclvJj4tjx00j9+Yo4rp+o0MnVyPycYvFfZOD/2qla669hiP6R/Ttxe8HYQ+sMuBknSgjCjXCVbejtHJt51iKKx23R1ihVpRooti0joiVwwi10UpuJAsZiaPvAsd1zwNQV9w2imabnIwSK2yCudQxnCIDNeHAQ7HI9muvohw6qBkjcUZh2M7Fc5s28A4b90eG2fKSQoh84rGEmC/5/Fehg2o54opv1MgEUK0woAT5dtH0eKTHoM1BgFZbw/uPu8OrNS8Yz3JL4vmg+sDtpoh67Cm7WagjpCjKb597R0uFst5IjtOJIJYTDFeNYb1EUSdJt88NqYZ+yBfbSRgiR8mZ89Y9bFkHFTeCl0tdYcV7xbfhf6JZ3R5Rks86RYJcneQfN+TLDzZ3lHODNaekHJvdB+ZW1SDpDNpalVvvZB7fTWDkadbYq5VScmHgId6+t4YXkioLNlWZMdEGsjdexAnVqwz43ptO/SJCr1sVc2cJXkg1+vDue7ZvwWvqPk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UtJ5wv2JGz6ajS+0980EFZdRx1MMWPAUW73v3YcRvIIh+Me5l9mUTuWT7VdB?=
 =?us-ascii?Q?LixYLVk9Wd+HXp4g5pkUx+q3qCdm1CxN3P1XpHVP/EL3k1sSCvTiRydudJQG?=
 =?us-ascii?Q?WBxjoPa4+5CWcFOpO4YYSEroVjXHUCTNM32qXQlvdW0DrUxDAod4J8kVn/0F?=
 =?us-ascii?Q?iVvpl1I43VkN68ZohL72KhiiiMf3rkliP4rdW6PsA6+yfSURalOHku9lRqGJ?=
 =?us-ascii?Q?SO8N8phv+v2keR1y3/6MTYOAVi7mEj7a90EKD+1G3KnTYqLgxQzdKaKalt0i?=
 =?us-ascii?Q?agHdPdxoNU33AYBWfWYL07RMQ58jUzate95F3+QC8GcIv3F3n6M2VTzjzTol?=
 =?us-ascii?Q?VWMKnWd/FP48J3MPHZiwxkX0y0AtZqlJ9Wyvw924h5E+1OH65xyDiE5PdOUu?=
 =?us-ascii?Q?kKLJ6Gcn+tth1cNmv35yZ7dgUH6lQfQFg8MgJ5UZJSzn2lN77lBOJOsNOZ3z?=
 =?us-ascii?Q?se8LVqsez1hqZUDSCoKzJlWKyCqZ+G2MVZ9InebekHrgcIZ9HjBdNVXDte4L?=
 =?us-ascii?Q?1WKp/a+eg4mV0FfvpkxUBADaVczFwcXKwkMv7QQ1lDnKyjZnkslNtnQ67pWo?=
 =?us-ascii?Q?0JWZkJ8l82b3V6ybz/+KeXoBzj9ud4qL6SiLgMT+aPrbGPXGw4kYNedQdEIU?=
 =?us-ascii?Q?JWM5IppoOZZh+6qloEd+DtN0T2fdembTBKWuCPNijE1wuz2GTLp67m/cCe5z?=
 =?us-ascii?Q?axCfe3b0ZDoyhLfjJLO0ZR1wTIM0Fb04sMDoPO1oRrmvfhL7fJfi5zQ5Pi1d?=
 =?us-ascii?Q?IqFFaeLncFpO7EUepd1XWZv/G+cZXX0UxMOmdIj1CgLgCb+FM5I06Re9vEKo?=
 =?us-ascii?Q?6/FDHacjoMmKvhVNu2eh+Ut2/2pCMRDVXB95Sg1TcR2JHJdXwEvJnVUlhyIF?=
 =?us-ascii?Q?FtYFT/jSqcOubJgZyR9U/woib1OpXoBVxFCjcTlkl2Jk8m2DP22M9Sx6yzgF?=
 =?us-ascii?Q?MOSIZKG2D9wTkcbHc5J9/ZFf5CB73x+0lCASbc8dlo71sGPObH7pZGVkAYcm?=
 =?us-ascii?Q?c17VkjPR66n1Q3fgSJIoSpJ2vTlxqVMWqqdnQLaDWThQ2bAfir8frksJ6nh1?=
 =?us-ascii?Q?qOl1+4BA5AI8oYXNPqPKpXSu5I1zlFAvo9tUfj0sxlzsmb70k6jz4LgY7dv1?=
 =?us-ascii?Q?+DwEgIO7li6e4TFxxhUTTIit8Gj1+7pSDL3X29Lc2Sl44T9YsF6pZl1QUNyW?=
 =?us-ascii?Q?4ItdR5sEnAkEHCpLSxSPCoFBfAJGTSGyiQU6gph9pyVFKb+DEHbotu68OKyP?=
 =?us-ascii?Q?0h30pz93H87gHACOQ/zyzdSFzBb1emAKFCN6Dvp6rDDwwXm9Xv4x4LzzyllC?=
 =?us-ascii?Q?8guf83oMpInT7ul1QxaoQauBGVrLPM2Q20kBhWR1C+T9Cy5rz2tsZ8lqOE0c?=
 =?us-ascii?Q?EFR7xZxd2CZNQNJJ7o3ds4tsoP7787yKtJRqIU5ROGBqyxFGViZlQ7uFNGgt?=
 =?us-ascii?Q?yNAnDXJhO18zItxLrVrxic9wL6Eav8C2ds3EnzZ0GkiIGPR16dRTyayGAU7+?=
 =?us-ascii?Q?5tTKueAnwCcGVMCNauKggJeMq9NP7Rxu90AX263YWozumJVLDLXBX0X5Yb4d?=
 =?us-ascii?Q?DxJYHAgNwdT+wysSworldQj+qYq7XJBB0+EHwr9fjoaDRheFiWg5yNVz87Na?=
 =?us-ascii?Q?ZBGn4BqaIT3ZP3ismiGA41/P0R8bTFZ6jl5I1XE6GhGv+VFLN/aQi6LaSEUh?=
 =?us-ascii?Q?qZDWtdtqveAmgeFBTTgAVDgZJDMjRyfhUcivNgSDc93kll5C8D2NWO4ygqSj?=
 =?us-ascii?Q?xuLgPW3Xig=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b6f57ec-ddc0-43ae-e01c-08de8ad02016
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 00:39:23.0789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uvrGzZ/6DCX3TGo4YwEYLnb+9vYhA61sAPHpbhNAMrudkNUKRlKRQqaRw8JPFYIe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6222
X-Rspamd-Queue-Id: 1CD3D1C000C
X-Stat-Signature: oh3emsxc83u7uzkq5x4haaqcjct86qp3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774485568-872767
X-HE-Meta: U2FsdGVkX1+4sfNmyV2xolYZpKzJch6UBF+ADLOVy2mSlq3IB6G9aY3ofxuV+Sv8p/sJx2MkKuw7+OrhpAEqDzQMLt6oS7Xh2rMu20q8+1jWZqK5gPvgU0bJRa0IhWANG36gdn0qrZCUuFVmUSMiEXiLODkI9aXTQ9FkgCIpbIH17A9bjRJ/m4m0dvQUYjuHHBSpEl3jyib7XVbDabK4LBNruTiUx6OR0hl5N/UDF6qwM7joOdZWX5bGGxNt4+ZRd48bKNw4E41kEBZgxizbZ2MjHnE6DfYWOjX9x85XpojkPCNtnoUERKU56exQqOKI5g4pLHjFCGh0jU6j5cs2QSybhnMVFn9tcJvoz2g9CI35fsZ1fktHIGQF2PZmJEH/sJ34BEHeBKs7iDcWvaMw7v8ZoaGBE3Pfq+N1rHTSian9+bWP3M16x2r02X6AJqIKeQHARI506lAKXSh31Se9vng8facH/Q+LYsbMvWm/CWrqMnKoEBAd9sgZpTSaXxCFwAv44EaZy+J43UihU+KwRJUSbkcnjXTKFQsYhoa+jj/L87bphzWrfmcH32+tQwR9BxDyC/8eJCcrCC03lE5YNI5mtU2WQDE2XrBeL7j1NbsgMumbj3G3GXMOTjvbog357SNxyJdD8fdlU7uPH0KdxWQkEcny+VytixeijhyxPy6WK08+K1lwEJqBTlkiXEuAr+UyK8TudBphcaFNKRqhVtysWYjy5Q3/l80nXa0bwy2CP3RcQylX9vpSGfslsoZU/YOubkhnByGl1YBu++VrL3+pJQvhKYrKfIWwNZOvyhv1bRN2JaBlXZaWVIPp0QuQYLpw/Iq9DY26XwCZzxFttsMDHcUHH+K36S64d3seOCRky8ob1lt98sq4+c/iDOwZ3iJw5uUBVGnmio8mBed/nIdYn2xr2dtmat/MnyJ2OB3Heo7Hm+FOz/rFZAbkrt/ADlerca05r05DLrC6qLM
 bflIeNge
 X+PUsJrgJEPP2UA3/Ry8N/IsIPcwdUBLmAt3nKoPLRukV2RaYyvcUtLTbsJe/x09p9fbCIBavjg7k2FXUbDmy2wEjrNemPGptIGbm9DBjzIl/JGuLfb9vEjdrnlSTaRa6U9g9lhHqGDHYfhusMkN2OubMRwKeVy7aP0sroWbZ7EWfzL+H6R4prx6eQDPq9EIoPUtEsKhVRMXF62E0N3qqxh9uUjIS7e9osyWg0hblUQkfydi1DaRzZDwC4F8KXf/1YP+DuIqmJOwjivfABi6L9ykoHexUOt0Du5dVibFmIHrRwABx5GkQGvlsWvoqA2hR0vd0YAYTzHG3rkImSYuaqB4r4tNP1N9rGE2pSruV1037WaQdqWzqU4ZztxPXYrBc0EydCXeO0VArZOqGIcQPk1AGc89XKP9GoLDH/eR7ScL47cnotECENrKiiVdrrIjerFAHX7aUSNsK9s07TeU/biOMySNGmmIxLz6gXhyHskBeTDAMh04dSrEExRD+cPxz5lDAta5bfkj7KI+QwIViduDM+chcqlIp55xDGscjPfgAzvwOPc3PK8PGr6OOTPXmkV/xO62OeFAZTZuepC8GknWwvSl0O8s+iuNg160vEuBvnP6Fa3vpFvuu5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

In case you missed this v5. It addressed David comments on v4.

In terms of sashiko review[1] on this one,

1. the false sharing one can be ignored, I can use this test to reliably
reproduce the issue in the old kernels.

2. the thp_cleanup_handler() one has been addressed before and
the chance of causing an issue should be very low.

Thanks.


[1] https://sashiko.dev/#/patchset/20260323163717.184107-1-ziy%40nvidia.c=
om

On 23 Mar 2026, at 12:37, Zi Yan wrote:

> The added folio_split_race_test is a modified C port of the race condit=
ion
> test from [1]. The test creates shmem huge pages, where the main thread=

> punches holes in the shmem to cause folio_split() in the kernel and
> a set of 16 threads reads the shmem to cause filemap_get_entry() in the=

> kernel. filemap_get_entry() reads the folio and xarray split by
> folio_split() locklessly. The original test[2] is written in rust and u=
ses
> memfd (shmem backed). This C port uses shmem directly and use a single
> process.
>
> Note: the initial rust to C conversion is done by Cursor.
>
> Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumW=
JdiWXv+C9Yct0w@mail.gmail.com/ [1]
> Link: https://github.com/dfinity/thp-madv-remove-test [2]
> Co-developed-by: Bas van Dijk <bas@dfinity.org>
> Signed-off-by: Bas van Dijk <bas@dfinity.org>
> Co-developed-by: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
> Signed-off-by: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> From V4:
> 1. added missing .gitignore entry.
> 2. used PRIu64 for all uint64_t.
> 3. added pthread_barrier_t to ensure main thread starts to punch holes =
when
>    all reader threads are spawned.
> 4. converted size_t to uint64_t.
> 5. used thp_availabe() instead of thp_is_enabled().
> 6. added a check on read_pmd_pagesize() to skip the test if pmd_pagesiz=
e
>    is 0.
> 7. removed static test information.
> 8. started iter from 0 instead of 1.
> 9. simplified test failure checking code.
> 10. added missing Co-developed-by.
>
> From V3:
> 1. fixed for loop stepping issue
> 2. used PRIu64 instead of %zu for uint64_t.
>
> From V2:
> 1. simplied the program by removing fork.
>
> From V1:
> 1. added prctl(PR_SET_PDEATHSIG, SIGTERM) to avoid child looping
>    forever.
> 2. removed page_idx % PUNCH_INTERVAL >=3D 0, since it is a nop. Added a=

>    comment.
> 3. added a child process status check to prevent parent looping forever=

>    and record that as a failure.
> 4. used ksft_exit_skip() instead of ksft_finished() when the program is=

>    not running as root.
> 5. restored THP settings properly when the program exits abnormally.
>
>  tools/testing/selftests/mm/.gitignore         |   1 +
>  tools/testing/selftests/mm/Makefile           |   1 +
>  .../selftests/mm/folio_split_race_test.c      | 297 ++++++++++++++++++=

>  tools/testing/selftests/mm/run_vmtests.sh     |   2 +
>  4 files changed, 301 insertions(+)
>  create mode 100644 tools/testing/selftests/mm/folio_split_race_test.c
>
> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/self=
tests/mm/.gitignore
> index 83ad9454dd9d1..b0c30c5ee9e30 100644
> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -61,3 +61,4 @@ guard-regions
>  merge
>  prctl_thp_disable
>  rmap
> +folio_split_race_test
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selfte=
sts/mm/Makefile
> index 7a5de4e9bf520..cd24596cdd27e 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -105,6 +105,7 @@ TEST_GEN_FILES +=3D droppable
>  TEST_GEN_FILES +=3D guard-regions
>  TEST_GEN_FILES +=3D merge
>  TEST_GEN_FILES +=3D rmap
> +TEST_GEN_FILES +=3D folio_split_race_test
>
>  ifneq ($(ARCH),arm64)
>  TEST_GEN_FILES +=3D soft-dirty
> diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools=
/testing/selftests/mm/folio_split_race_test.c
> new file mode 100644
> index 0000000000000..ff026f183ac7e
> --- /dev/null
> +++ b/tools/testing/selftests/mm/folio_split_race_test.c
> @@ -0,0 +1,297 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * The test creates shmem PMD huge pages, fills all pages with known p=
atterns,
> + * then continuously verifies non-punched pages with 16 threads. Meanw=
hile, the
> + * main thread punches holes via MADV_REMOVE on the shmem.
> + *
> + * It tests the race condition between folio_split() and filemap_get_e=
ntry(),
> + * where the hole punches on shmem lead to folio_split() and reading t=
he shmem
> + * lead to filemap_get_entry().
> + */
> +
> +#define _GNU_SOURCE
> +#include <errno.h>
> +#include <inttypes.h>
> +#include <linux/mman.h>
> +#include <pthread.h>
> +#include <stdatomic.h>
> +#include <stdbool.h>
> +#include <stdint.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/mman.h>
> +#include <signal.h>
> +#include <unistd.h>
> +#include "vm_util.h"
> +#include "kselftest.h"
> +#include "thp_settings.h"
> +
> +uint64_t page_size;
> +uint64_t pmd_pagesize;
> +#define NR_PMD_PAGE 5
> +#define FILE_SIZE (pmd_pagesize * NR_PMD_PAGE)
> +#define TOTAL_PAGES (FILE_SIZE / page_size)
> +
> +/* Every N-th to N+M-th pages are punched; not aligned with huge page =
boundaries. */
> +#define PUNCH_INTERVAL 50 /* N */
> +#define PUNCH_SIZE_FACTOR 3 /* M */
> +
> +#define NUM_READER_THREADS 16
> +#define FILL_BYTE 0xAF
> +#define NUM_ITERATIONS 100
> +
> +/* Shared control block: control reading threads and record stats */
> +struct shared_ctl {
> +	atomic_uint_fast32_t stop;
> +	atomic_uint_fast64_t reader_failures;
> +	atomic_uint_fast64_t reader_verified;
> +	pthread_barrier_t barrier;
> +};
> +
> +static void fill_page(unsigned char *base, size_t page_idx)
> +{
> +	unsigned char *page_ptr =3D base + page_idx * page_size;
> +	uint64_t idx =3D (uint64_t)page_idx;
> +
> +	memset(page_ptr, FILL_BYTE, page_size);
> +	memcpy(page_ptr, &idx, sizeof(idx));
> +}
> +
> +/* Returns true if valid, false if corrupted. */
> +static bool check_page(unsigned char *base, uint64_t page_idx)
> +{
> +	unsigned char *page_ptr =3D base + page_idx * page_size;
> +	uint64_t expected_idx =3D (uint64_t)page_idx;
> +	uint64_t got_idx;
> +
> +	memcpy(&got_idx, page_ptr, 8);
> +
> +	if (got_idx !=3D expected_idx) {
> +		uint64_t off;
> +		int all_zero =3D 1;
> +
> +		for (off =3D 0; off < page_size; off++) {
> +			if (page_ptr[off] !=3D 0) {
> +				all_zero =3D 0;
> +				break;
> +			}
> +		}
> +		if (all_zero) {
> +			ksft_print_msg("CORRUPTED: page %" PRIu64
> +				       " (huge page %" PRIu64
> +				       ") is ALL ZEROS\n",
> +				       page_idx,
> +				       (page_idx * page_size) / pmd_pagesize);
> +		} else {
> +			ksft_print_msg("CORRUPTED: page %" PRIu64
> +				       " (huge page %" PRIu64
> +				       "): expected idx %" PRIu64
> +				       ", got %" PRIu64 "\n",
> +				       page_idx,
> +				       (page_idx * page_size) / pmd_pagesize,
> +				       page_idx, got_idx);
> +		}
> +		return false;
> +	}
> +	return true;
> +}
> +
> +struct reader_arg {
> +	unsigned char *base;
> +	struct shared_ctl *ctl;
> +	int tid;
> +	atomic_uint_fast64_t *failures;
> +	atomic_uint_fast64_t *verified;
> +};
> +
> +static void *reader_thread(void *arg)
> +{
> +	struct reader_arg *ra =3D (struct reader_arg *)arg;
> +	unsigned char *base =3D ra->base;
> +	struct shared_ctl *ctl =3D ra->ctl;
> +	int tid =3D ra->tid;
> +	atomic_uint_fast64_t *failures =3D ra->failures;
> +	atomic_uint_fast64_t *verified =3D ra->verified;
> +	uint64_t page_idx;
> +
> +	pthread_barrier_wait(&ctl->barrier);
> +
> +	while (atomic_load_explicit(&ctl->stop, memory_order_acquire) =3D=3D =
0) {
> +		for (page_idx =3D (size_t)tid; page_idx < TOTAL_PAGES;
> +		     page_idx +=3D NUM_READER_THREADS) {
> +			/*
> +			 * page_idx % PUNCH_INTERVAL is in [0, PUNCH_INTERVAL),
> +			 * skip [0, PUNCH_SIZE_FACTOR)
> +			 */
> +			if (page_idx % PUNCH_INTERVAL < PUNCH_SIZE_FACTOR)
> +				continue;
> +			if (check_page(base, page_idx))
> +				atomic_fetch_add_explicit(verified, 1,
> +							  memory_order_relaxed);
> +			else
> +				atomic_fetch_add_explicit(failures, 1,
> +							  memory_order_relaxed);
> +		}
> +		if (atomic_load_explicit(failures, memory_order_relaxed) > 0)
> +			break;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void create_readers(pthread_t *threads, struct reader_arg *args=
,
> +			   unsigned char *base, struct shared_ctl *ctl)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < NUM_READER_THREADS; i++) {
> +		args[i].base =3D base;
> +		args[i].ctl =3D ctl;
> +		args[i].tid =3D i;
> +		args[i].failures =3D &ctl->reader_failures;
> +		args[i].verified =3D &ctl->reader_verified;
> +		if (pthread_create(&threads[i], NULL, reader_thread,
> +				   &args[i]) !=3D 0)
> +			ksft_exit_fail_msg("pthread_create failed\n");
> +	}
> +}
> +
> +/* Run a single iteration. Returns total number of corrupted pages. */=

> +static uint64_t run_iteration(void)
> +{
> +	uint64_t reader_failures, reader_verified;
> +	struct reader_arg args[NUM_READER_THREADS];
> +	pthread_t threads[NUM_READER_THREADS];
> +	unsigned char *mmap_base;
> +	struct shared_ctl ctl;
> +	uint64_t i;
> +
> +	memset(&ctl, 0, sizeof(struct shared_ctl));
> +
> +	mmap_base =3D mmap(NULL, FILE_SIZE, PROT_READ | PROT_WRITE,
> +			 MAP_SHARED | MAP_ANONYMOUS, -1, 0);
> +
> +	if (mmap_base =3D=3D MAP_FAILED)
> +		ksft_exit_fail_msg("mmap failed: %d\n", errno);
> +
> +	if (madvise(mmap_base, FILE_SIZE, MADV_HUGEPAGE) !=3D 0)
> +		ksft_exit_fail_msg("madvise(MADV_HUGEPAGE) failed: %d\n",
> +				   errno);
> +
> +	for (i =3D 0; i < TOTAL_PAGES; i++)
> +		fill_page(mmap_base, i);
> +
> +	if (!check_huge_shmem(mmap_base, NR_PMD_PAGE, pmd_pagesize))
> +		ksft_exit_fail_msg("No shmem THP is allocated\n");
> +
> +	if (pthread_barrier_init(&ctl.barrier, NULL, NUM_READER_THREADS + 1) =
!=3D 0)
> +		ksft_exit_fail_msg("pthread_barrier_init failed\n");
> +
> +	create_readers(threads, args, mmap_base, &ctl);
> +
> +	/* Wait for all reader threads to be ready before punching holes. */
> +	pthread_barrier_wait(&ctl.barrier);
> +
> +	for (i =3D 0; i < TOTAL_PAGES; i++) {
> +		if (i % PUNCH_INTERVAL !=3D 0)
> +			continue;
> +		if (madvise(mmap_base + i * page_size,
> +			    PUNCH_SIZE_FACTOR * page_size, MADV_REMOVE) !=3D 0) {
> +			ksft_exit_fail_msg(
> +				"madvise(MADV_REMOVE) failed on page %" PRIu64 ": %d\n",
> +				i, errno);
> +		}
> +
> +		i +=3D PUNCH_SIZE_FACTOR - 1;
> +	}
> +
> +	atomic_store_explicit(&ctl.stop, 1, memory_order_release);
> +
> +	for (i =3D 0; i < NUM_READER_THREADS; i++)
> +		pthread_join(threads[i], NULL);
> +
> +	pthread_barrier_destroy(&ctl.barrier);
> +
> +	reader_failures =3D atomic_load_explicit(&ctl.reader_failures,
> +					       memory_order_acquire);
> +	reader_verified =3D atomic_load_explicit(&ctl.reader_verified,
> +					       memory_order_acquire);
> +	if (reader_failures)
> +		ksft_print_msg("Child: %" PRIu64 " pages verified, %" PRIu64 " failu=
res\n",
> +			       reader_verified, reader_failures);
> +
> +	munmap(mmap_base, FILE_SIZE);
> +
> +	return reader_failures;
> +}
> +
> +static void thp_cleanup_handler(int signum)
> +{
> +	thp_restore_settings();
> +	/*
> +	 * Restore default handler and re-raise the signal to exit.
> +	 * This is to ensure the test process exits with the correct
> +	 * status code corresponding to the signal.
> +	 */
> +	signal(signum, SIG_DFL);
> +	raise(signum);
> +}
> +
> +static void thp_settings_cleanup(void)
> +{
> +	thp_restore_settings();
> +}
> +
> +int main(void)
> +{
> +	struct thp_settings current_settings;
> +	uint64_t corrupted_pages;
> +	uint64_t iter;
> +
> +	ksft_print_header();
> +
> +	page_size =3D getpagesize();
> +	pmd_pagesize =3D read_pmd_pagesize();
> +
> +	if (!thp_available() || !pmd_pagesize)
> +		ksft_exit_skip("Transparent Hugepages not available\n");
> +
> +	if (geteuid() !=3D 0)
> +		ksft_exit_skip("Please run the test as root\n");
> +
> +	thp_save_settings();
> +	/* make sure thp settings are restored */
> +	if (atexit(thp_settings_cleanup) !=3D 0)
> +		ksft_exit_fail_msg("atexit failed\n");
> +
> +	signal(SIGINT, thp_cleanup_handler);
> +	signal(SIGTERM, thp_cleanup_handler);
> +
> +	thp_read_settings(&current_settings);
> +	current_settings.shmem_enabled =3D SHMEM_ADVISE;
> +	thp_write_settings(&current_settings);
> +
> +	ksft_set_plan(1);
> +
> +	ksft_print_msg("folio split race test\n");
> +
> +	for (iter =3D 0; iter < NUM_ITERATIONS; iter++) {
> +		corrupted_pages =3D run_iteration();
> +		if (corrupted_pages > 0)
> +			break;
> +	}
> +
> +	if (iter < NUM_ITERATIONS)
> +		ksft_test_result_fail("FAILED on iteration %" PRIu64
> +				      ": %" PRIu64
> +				      " pages corrupted by MADV_REMOVE!\n",
> +				      iter, corrupted_pages);
> +	else
> +		ksft_test_result_pass("All %d iterations passed\n",
> +				      NUM_ITERATIONS);
> +
> +	ksft_exit(iter =3D=3D NUM_ITERATIONS);
> +
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/=
selftests/mm/run_vmtests.sh
> index 606558cc3b098..530980fdf3227 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -553,6 +553,8 @@ if [ -n "${MOUNTED_XFS}" ]; then
>      rm -f ${XFS_IMG}
>  fi
>
> +CATEGORY=3D"thp" run_test ./folio_split_race_test
> +
>  CATEGORY=3D"migration" run_test ./migration
>
>  CATEGORY=3D"mkdirty" run_test ./mkdirty
> -- =

> 2.53.0


Best Regards,
Yan, Zi

