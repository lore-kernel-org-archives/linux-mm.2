Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87E60606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ctFntLdm
Received: by kanga.kvack.org (Postfix)
	id 9B49D6B05DA; Tue, 20 Oct 2026 22:45:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98A956B05DC; Tue, 20 Oct 2026 22:45:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1CB6B05DD; Tue, 20 Oct 2026 22:45:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 647996B05DA
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:45:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8E5A120417
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:45:28 +0000 (UTC)
X-FDA: 85345092336.22.4DF5A45
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012049.outbound.protection.outlook.com [52.101.43.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id E2DC820002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:45:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ctFntLdm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOpoeVuO/9jTshhRRhF89REB+rSHYkmJew0M6PFaFxE=;
	b=u+qvF+SvR9w/ZfpHXfF9VK/GKs30WgbyyZBBFg7gqu9DACRL/PZ8gNyKehNjYu5UupmeXO
	P4lRzTTdUolaAgVKj1vSz52SX+45wRDwLRChtuiygzTIthADHLHC9DcHsUYoP7i45xGjEd
	G5CeWOOPC4jK/e/l0j7CpHbAMwto+TU=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ctFntLdm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792550725;
	b=lfCS/ieT7Ntz9kapnTwS10Iw8gS7vB6zNc9JjtzS9OYqSs15hVccUKbsm/AKn8/+4a/huF
	pwi/shttLSYg9u1NfTdLinH0sffVMJ9iyS8NGdKFfgiBPGb5wfZ4PcQBBNxqwT5+S3IjyW
	sqE0XcsyeIYQNJO6qgQu2fieFm52RKo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T30huldDyAJwcrvZ5GfBO4LtQ5wkhTJSZQNzx6WR/AXnUpem5Y9JC//Ou6KVUN0EIV/PkQQ/eKs+En2YYPMIAaNuQRpwXOmz6UqIl3zOmIAegYw2DdSzDeNmmyUZVrB3RbhIJBtkJ8O2e3NPPQgsuWm9zjyaiE6FUCRHpqeH3iCq5WCKEQ47OYMOpsjvW0NFP63Ybg/Sa2Vj3073Bsve8fyII94Mncg9LzEr0Gz/762bKSW1lo9A0jVtvbJwSU+mgncBn0NizGryMuqKXmSGajBClne6MZgsZ6In3WNj98mA+sLy2F4v3tOHIfdVKcaMNHONZUN+Fti+pxli6YSjHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oOpoeVuO/9jTshhRRhF89REB+rSHYkmJew0M6PFaFxE=;
 b=IoVc+Stjzm0LULRIRoc/pH2WHdy2R6CuJi8T7hIC/cayR+9j3LORXejJ58/OVvJz+mFLptZDwSAkTuGQgHLXrJZ47LmV45dS0EnX7Hq9+rmSfNBL9njcAuVm6sxUd2gbj6GnKojPEOhsUfJFWXP0LhOKLzRXWENIlDWdoWq6ecJ00pxzNjlq6LZHXIIvgOlwPct+tvOvGqZdaSNtL25U8bCkUFIXBdvLHYjX1Ylgr5Yxk31jRc2UVYqDW1BPE9rPNyUeLUp6BH2Bb448p5AnWdjE422nTaBUFp76JIRWeH4mlPaGI4FDAaot2d9UqSJqn3sXlhkbUJyvUYEVMw116w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOpoeVuO/9jTshhRRhF89REB+rSHYkmJew0M6PFaFxE=;
 b=ctFntLdmLc2nLe5yFOrHg+//3B8Ua4ALTq0Rkf5jNV12wiudHXP9kXO7c9DbS7D5cT9i8cwIZGHUL2N1rSwal2W4WYaDixccT7RKlP61L9oUX70/UAskYqg3HX41aWkZhAihiHSLVtwnsYBbnpNPhMPKtnXpneQY6MMvXjg9dBP1YEoJJVYYjPCNixOR9wCR42in407GiCzUkptawEUfjOjiwwu5pQp4TsqE+bh2ABWcpMDzwyZ3B5jpzRhF1VUs5XDsoRy1nEeAA9p4ZfGsPuXWmZwsbXgnDuVOxmWrhx9pdyclmc7gtlYpgBIdEFKcEoVefLzULS7DyX3UtJSNHA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB9008.namprd12.prod.outlook.com (2603:10b6:a03:543::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 02:45:21 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 02:45:21 +0000
From: Zi Yan <ziy@nvidia.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v3] mm: unqueue deferred split folios outside the lruvec
 lock
Date: Tue, 20 Oct 2026 22:45:18 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <EEAEAD85-40E5-47D1-92BD-25B96FD5CE4D@nvidia.com>
In-Reply-To: <20261019230646.3510790-1-joannelkoong@gmail.com>
References: <20261019230646.3510790-1-joannelkoong@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR08CA0014.namprd08.prod.outlook.com
 (2603:10b6:208:239::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB9008:EE_
X-MS-Office365-Filtering-Correlation-Id: e95c7d6f-26f9-43cb-2ae8-08df2f1d5940
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|23010399003|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003|6133799003|4133799003;
X-Microsoft-Antispam-Message-Info:
	TDR2R3OT2/P5IRP98dDj2Bg3nClsWzKaQiLrsZ5PbDFNC2NcxfsS/+uX0BRC/Jr61aRpZIfuH/RCeSCuPKk43BIj1Ns2waO23NBD4TsIzYKs/aDua8kVr+vpezd97QirEplm1KdD0PPv1MTujfP4mxN7mK+8wxSNx0iLccYdvduRzeWcX4OfLw97ftV4fNJIMtMfwDU1cukOA6mtlsuZI9gy8NCv6ScAI7/IzcEIdJ3Sjzu1iUBtvQoDe+E03QQYuFrNDmGhPnolgr1vn1Y1ysBlHm2n5zJRqlvpMgfVyoPYMNdufXAvlSlBvh4x7KZ6AznOwz27stf59Ru5GaOPLiYzYoDQDgLzBvBuX9IwtkupO6dS/XGsyetBIbkbgGkIk8LvSdZGvZA2vtnJ1Ry32K5c+3HpmkJKPB3ORI24uAUBZ5VPkmcLTiI1736pdqrs6LYZzOakFJ+JRE3MlAECDSuh5IH4Z2jDcc+6KrLwBvrtigqPcqlxUsjg8LqAze5HxwZelRuT7vGjMuVSxanTPRhVQBzpWs16SISGOMAvDwS38lgSPm4nZ4MvgB0ewv0yb/fu1vU5qtQNg6xZJ2DPhG7Ic6JI+NmB+zCfYJq6zljihAD4dGAjmecNzoC8coax71j1Mrv4ZiIlffLCKxd+YULWEDSdMfPqkEVAY5ls3B0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(23010399003)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003)(4133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Dm301+454Q4jpMShjshD4PotYsR7Hv0BZiQyKQMMuMQ5c5bieVZZgiBUwSIt?=
 =?us-ascii?Q?2tA9dHDTxIfBOwptEwGGB5mz3WaJguyDMCtAaX/7zJSrJw9KMZh0vxXe/E7u?=
 =?us-ascii?Q?e2RUYrzqDTSOVmbLDxJcmgiBSc/bR43vlPgqtIp34i5SnohLgjsSHqk85Rld?=
 =?us-ascii?Q?2MOYKAo8u4SAlcUDRWOzg9UexASgYYNMlwnZv91BMqiCOWJ+2SwR+e08kY0Q?=
 =?us-ascii?Q?7gE4ZBrV32om4kmxRrtzwZWzGOXfgLTkz2V1BZvy0Um/T55/XMe+fWGAgYDC?=
 =?us-ascii?Q?++Sq7FMdtbkCOKNFtmy/+ihi63GMHRadaBCCCgeybAsU64HaWGpyoJLoUJg1?=
 =?us-ascii?Q?sUhhDqOpNcotFkBZzDr74U7cymTrHKRbyduZA3+mQ7zyXpUCaocSkH0PZU4W?=
 =?us-ascii?Q?fk69mjZYpCrkg0LyLaE8lcjVR1kOjt8ZqsyOYXwdgKAeNRnbxTy9orLoBpB6?=
 =?us-ascii?Q?m2xM0OEDbJNLBeUas3w0NXy7bUTTH2bQmWy4tR6fTKBoPSKXl+YowdpfOU5K?=
 =?us-ascii?Q?bx+CZ/DDSLZHiDW8/xfZrBfKOXuf7m3SS0/hbnHrcEdzcWFc/FdUE2UZacP0?=
 =?us-ascii?Q?/Ed2KFIxZ+OSiURzZ4MvSztY3w44m7HjGpxUc63VXza7yVv+Z7UHY3HKfDA+?=
 =?us-ascii?Q?jv7PPNFxotmy5tDyJ+Eh/1XweToAe0JX+RjfuhgyHnx9EeZRLjkT8IOmqSRp?=
 =?us-ascii?Q?+rJL6LmUI6BzelihFkW9dAkVewUrtpQ8MsFSbbTCFomJ9bOsHlgPE5JVi2rk?=
 =?us-ascii?Q?SUxd4WGC3T5hCJcLbeJLfVFv2DGrx+2QHhPOsKH4AR1s29uiO3sAlLRnOD/g?=
 =?us-ascii?Q?79IIAWJrXwJBhLRd36ygT05rFF5mp0r2i16MBIxvY6c5+pM9vub02rFJk5nF?=
 =?us-ascii?Q?33eJH9/FJaZSZWr6qFpKXOcdZUj259+fwUIWX0A7FnjfYCDPiREBCBE19n0J?=
 =?us-ascii?Q?N2BBriApQtRqHvHEUHHFvIH/wNkuOJbaFc6+a9QJJQSiyEbXVeS0Ya9L4cKS?=
 =?us-ascii?Q?vpqCvmbwpfcEzAKLTBqnUGIvKnVuvJdBMLb2X99KMAiw429Zy1VSSjmje3xO?=
 =?us-ascii?Q?txbWlQuO4GCC6BDmV81Fr2VSm6ANwJx87+Vrjun6WeylMdNDZUzIUYVCgmUY?=
 =?us-ascii?Q?GDbs79fXVxPcvcEGVrzUK3bHCdnc0t8eJ+3zBzmp8Qf1djl8JnSi6z4n7h4x?=
 =?us-ascii?Q?LR2pW61TdJwHUV73mdj/94CVY7Z6ySslSfoU4m0TuTlJFPHofXlteukA0msc?=
 =?us-ascii?Q?XTat9/CZudSEm6tj2qrkxqtHujHSA9ZrOrFVcuqkCC7kNqTYArrScajNwQU3?=
 =?us-ascii?Q?+9lplr6PGHsaetP7d3VuYo+gLAFtqqO9dwLet/CceZZHCU6Z43yOlCLc/K7d?=
 =?us-ascii?Q?o+SAA/q8cb9nL7NO9qYFDVwa6pQrWENWI/5fMh08ovxr/km2OqOuUlHPPGCu?=
 =?us-ascii?Q?ZVhG7jJdMOdGoAzrc+4HFnYZ/LK6A27zNaGCSqL6zrPobFOZmR1VXrEzw3gc?=
 =?us-ascii?Q?39kzKekevmll0CPqA3hZ4B3zEsaAkLa3eOmX0sjEIZSZT8902bVxah80lTDL?=
 =?us-ascii?Q?04LF5DBzYbkVgizMl2sYJcp8yA9wgEa/TmTwJ2QiumADcKLqQfj8/Fig2IA4?=
 =?us-ascii?Q?SlZ7BOInY8JmunNb7jF9frG7wXULAD0N1OAfXYPxU7p9hOE0s/iDFK72KVpz?=
 =?us-ascii?Q?Wg9yZXGIXc51DymQaZxFjjHOhTeo1rCaabU5nXUcD+xQ/eNL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e95c7d6f-26f9-43cb-2ae8-08df2f1d5940
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 02:45:20.9795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wTUAK69kD85RqjiQhyqSfQ15i1HuAYLX0UTaJ1NESJq1WdKZaboIE3XmVGqDrRaA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9008
X-Rspamd-Queue-Id: E2DC820002
X-Rspam-User: 
X-Stat-Signature: ysg61nnwhahkda3g16fmgdyx87u85g3y
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792550725-53355
X-HE-Meta: U2FsdGVkX1/oam2U6PebrDMFNdwaxBRG7ajpQSpmOtNbSJ4R1o0W06JKM4G2E73ErekdzB58+FJb9E7J67JPx4y9OMKOMv/YdUKsz9pRNSd/NKkNE1gjKapJ3zsYZ+sTRtw+5rz40TSSzMpxWPio5hTEnbhrD+eUuMEm9CWrGycqOJ52UcpAoIdI2sLM72yoeMsG9c1JUQPcdi8cA/YmuCqMgFap4s0t3xn6QRzMbka79AGO6tctLniooJgd1hxyIKV269RFNrov+198GBpGngaCvDjjC82TYSSR9A+Kadf3H2QruB5gIdpedD+wzB53Xo8RIr17sHhMfD2rkxHuS8zLBaleGKNBMNgTYHGAP9GYoNxvJjTDIYlhuX13CinTbx4v4KgEonolzlUgp+aAhkiA1LyKbhineiMCymJF5u5+aybnSrbVoxeHdkjFArK6K/E24ErY0y0wdPp26yS88C0akR7uh+sSGMmaZu/Zgx4KysZJa9Jw7ATim/QZRuc+k1yMp+Z27FlcANCoYTfncQEfeY9yeYbo3JUnDNnQKB7cQAv0dfJoprikYnnpzVAN1oQDZEZhMsvmgPOPiHHjhhxx2WZbF3pjAkUs72tVRUiJV7Z1WAA3tRpibF8GkFyZHEqXKd/ubZ4B2o8eslRNq4v3RgXhv+LkwtDATSFRAeWU7gLFz+zGGge7LOFW6i6dZ0OS4cN47UDLobKTo/ve7oHDfDahB0ajmdGwnO+KgLBg0sqR3TVcWuX1I/3dvO3wBXb6I3CzW0iEB7M6Rxj3NARSTNpXA4GAFdI2PhbBL+OZ5ufLQ+ZweQx41XuhV2ZBVIDog0obYZB8KwlSDFB/2NotJF+zTOnNlVeChJ7b6t9DcS+qyBjZfe5iupDORpqALXJ3E1Cu1hCiRtRrlaEN92dJxvjqBv6ew4CrGHuU7HrU2A2aQ6E/IHeJ9mRvLKtCRyKtQmFibaDGwRj6A+M
 uS8Bsg3L
 au6vlv08maD5o0zTQL4jyLQa8DIFnMSqNyaitIolDfMiHACPibCG4FkqwvnIQ1nuIcH6IT3atyQzxsYecd6/ZLzg4IU5ko3ITWPAk6Sy99bgxmwRjy2xQmwGZw/OsVAmWwUHtx4GO3tbaX7WPJDi2ktjlb0+FoQobmCYEtbyD9lxa8XffUvDL75kfQDfOE9IX7uS7qLV6ICJzwr+iWShg9aCDdw9kqYZ5qRlzRcfPbSwcEuRk2DQ8akQ+Ro7ocB2hpuqtsj5f3vTJs/odUoLJ1YgIo5xq3sHE84nw1hDiSYWQe9M+1X+DjFehoI0h1t6JRYSWg6vsNCqwzIRsjvvrMgMD32P6K6NYteZYegn2RT5GRFFUsgxGSyXHaNyhrunySU86Yz7Cnopvqqln9KnR3r7FWe3GyGtb8PhHna3JI9cqY61J2rqWI4qR4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 19 Oct 2026, at 19:06, Joanne Koong wrote:

> move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() call=

> folio_unqueue_deferred_split() on folios where the refcount has dropped=

> to zero. In these paths, folio_unqueue_deferred_split() is called with
> the lruvec lock often held (move_folios_to_lru() always holds it and
> folio_batch_move_lru()/folios_put_refs() usually hold it for every foli=
o
> in the batch except the first). However, it's not needed to hold the
> lruvec lock.
>
> The lruvec lock protects folio->lru and the reclaim LRU lists whereas
> the deferred split queue lives on folio->_deferred_list in
> deferred_split_lru. The deferred_split_lru is a list_lru with its own
> per-memcg per-node lock.
>
> There are already other existing callers that call
> folio_unqueue_deferred_split() without holding the lruvec lock (eg
> __folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).
>
> Add folio_batch_unqueue_deferred_split() and use it in
> move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() to
> unqueue each batch of zero-refcount folios from the deferred split list=

> after the lruvec lock is released and before
> mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
> critical sections, which run with IRQs disabled and are highly
> contended.
>
> This came out of the discussion on v2 of the mTHP shrinker series [1],
> where queueing small mTHP folios on the deferred split queue was found
> to regress Barry's fault microbenchmark. With [1] applied and
> khugepaged/max_ptes_none=3D0 so that every folio is queued, perf lock
> contention showed that the extra cost came from waiting on the lruvec
> lock in the free path.
>
> Test setup: 2-socket Intel Skylake, 40 cores / 80 threads, memory bound=

> to node 0 so that all threads contend on one lruvec, with each of 80
> threads faulting in and unmapping 16 MB of anonymous memory 200 times.
> With only 16K mTHP enabled, this patch reduces the queueing cost from
> 15% runtime to noise, and lruvec lock wait time (summed across threads)=

> drops from 491 seconds to 38 seconds. Most of the remaining contention
> moves to the deferred split list_lru lock, but runtime still drops back=

> to the unqueued baseline. This test uses a worst-case configuration ([1=
]
> is expected to only queue folios of 2M and larger).
>
> [1] https://lore.kernel.org/linux-mm/CAJnrk1a2PpUGTsCgS7jct2KET4K2zAL+_=
h+te8G1MaU9bXs99w@mail.gmail.com/
>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
> v2 -> v3:
> - Move benchmark results into the commit message (Lance, Barry)
> v2 link: https://lore.kernel.org/linux-mm/20261017004555.2890038-1-joan=
nelkoong@gmail.com/
>
> v1 -> v2:
> - Reword comment in folio_batch_move_lru() (David)
> v1 link: https://lore.kernel.org/linux-mm/20261013221307.850803-1-joann=
elkoong@gmail.com/
>
>  mm/folio.c    | 24 +++++++++++++++++++-----
>  mm/internal.h |  1 +
>  mm/vmscan.c   |  3 ++-
>  3 files changed, 22 insertions(+), 6 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

