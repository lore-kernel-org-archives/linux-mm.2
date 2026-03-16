Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7B44F53D6D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F7E6B031E; Mon, 16 Mar 2026 12:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C136B0320; Mon, 16 Mar 2026 12:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF72C6B0321; Mon, 16 Mar 2026 12:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB59E6B031E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:50:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44028C1904
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:50:02 +0000 (UTC)
X-FDA: 84552513444.22.D1EE850
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013054.outbound.protection.outlook.com [40.107.201.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7396140014
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:49:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OvWB0FGc;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773679799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6bOYjDA7v8hA38aYdgtmNUwuaZfAkv0CTWmftPsjqw=;
	b=gjgkxe0pBE1MW0tCEgLBWU+OqTW+j5Ibe1a6XvzNG1jO6YCbmckLZa6OBV21CJUwrkdhVD
	buagZA5gZmDpbgY2FqU0GB6lKqEDuwfbcN3KJ/w4E+ucFaSx0J3nT0XYYR+KXzStDEjXG/
	kqGbxKqdH2fCQ4RzuPNJt94WpZLGQpY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OvWB0FGc;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773679799; a=rsa-sha256;
	cv=pass;
	b=LzEdwAyj0RylsMDBoMANAAkXHkEZPRYO/BY3RoFip4RjOr3ntivxoPK8ctv8fNLeX2ZO+5
	NMiQFth0nHXA1jmU3R4YewWz1j50wrg2QS7pld6Mo7l8etxcaynvbt03JCa9KREGPLScRl
	OAXH67ng/YpuySCmnRzR82TG0VOsZhs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cbNmjSRnEBU0RUIUF3Zr1pGFsBmu0O19/X0v/3fksuusErJoKjKABAy56YIy+LVuhkZz1so0fi2EvxI/mWrb8/ce2A7jhZC19hJX57l4pFr+SUDNAciGGjydRBp+UVeb9yZT5qSbF279JlJfnxZd9ctBU7fybDcRvTQktxE6trTlkXwC5suZDkuYh1qt0NBlP3z+LwmOsXbB1I3BD/Wor1hbG2k9rwHK2H1M2xZZctl/F8SP6faBufIYWpjvVLiuafA5Kih7LbDQ1WCchrFSC5gy3Xtvo2/9PsY4GFJIT/pjiAhu5P+w7mPLdaNTPSf0HaqF/i1vFjcXf/M9Ac7UYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P6bOYjDA7v8hA38aYdgtmNUwuaZfAkv0CTWmftPsjqw=;
 b=g9aVVW2xNW11M48/Y6N1Q5qC/5N6+iwreHq5/eDIX9LzrmGoy5uYCVla3KDRyzobHDccS6IluISbAK4lK0kvIP2//LHJxNkabuaYBuMZaP1+fHeLA1zpbmd9sWElSahSQ1bIewJjcf4mp+daxPkuRG2b0n1j0U4Pcwn0qYTKV7pMS2y9aDPqQi7YRuQdIfYazThKbqZW2uPgwJhavwAmuEghOwoTSygKM5i2C7Bs/KvMTaHjNXlpMKQZRW44yJCQDJ0XMU676drCAEHay1OGyuVxE6LsthHfCjnI+75TIQQtWt3hAC249UBXTWp386RAfAs/Top5djr8fEP7XKU+dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6bOYjDA7v8hA38aYdgtmNUwuaZfAkv0CTWmftPsjqw=;
 b=OvWB0FGcFeKETYyOzUzKJXTCuSAt8yU6BTaFMRFfnRYf94Bqp6wXG7KUQZlpbNVm/g1VZBNHj927Voa8WYgzHmc4ZJ/V8BnFRVaCymkbHaqIF4G+ejEehT3H7XT7eK9mHI6aHOUOREVvLyts41gRLcBEWiMD3cypxFuoi0ODmyVdg2niiTRjJbG3iNd48BJ8ScZX3Njv1ftI7lk1ipNE7pODYYzKiw9fEEZcPG8rsK3aGR7ShD9211kPz3b06BWqQLWx1OByy5gIwvt6pY+o3j+xLhv5RNEnYpayCU/f1s3SLrHLHs8D4LHwUF+Z+/cx9+p3I3C4/H2RoY7WIHNl+g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA0PR12MB7477.namprd12.prod.outlook.com (2603:10b6:806:24b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.17; Mon, 16 Mar 2026 16:49:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Mon, 16 Mar 2026
 16:49:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>, willy@infradead.org,
 akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, michael.roth@amd.com, dev.jain@arm.com,
 vannapurve@google.com
Subject: Re: [RFC PATCH v3 0/2] Fix storing in XArray check_split tests
Date: Mon, 16 Mar 2026 12:49:47 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <87FD20AF-55B6-4129-9AED-E2E854593883@nvidia.com>
In-Reply-To: <6ada27e1-8f85-4b85-8c25-bc9207b2624d@kernel.org>
References: <cover.1771831836.git.ackerleytng@google.com>
 <6ada27e1-8f85-4b85-8c25-bc9207b2624d@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA0PR12MB7477:EE_
X-MS-Office365-Filtering-Correlation-Id: 64edfc8c-dfc9-49b7-9ebb-08de837c0c99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	TtarCTiNVnz9YlZuVYzspSm2RIEOgGyI0xg1HV/OU+KYws57z0+diFxMi3USOJWOlKH3d1cJdWNQFioPw3JU3+B+wZgQeSrfF7X4pgiACWaHBTH6dpNDE+0I34YwLTHstyr0aRbLfWktB1g0SdyNqSUFot7+SVIupQIUOIpxqX2b015iJ3ttwao60hLJ2rqNGX025upmxIxJgxAr7eTrd+mteviC5iRAdmFClOpm4mJX6EM1c31g9H2x1pdACcHSCG2yUKDUGnz0+TE+24MVq9wfIvHaYArKN5UMK/lW5NHYYSKE3n1gM84dp/uuPDNus1z598GtnN0OWElV1T7MiNH7LKhqVtZsw1W2w/YVMDni/en9MIObQvahImc/4r/7jI9FMkLDg+07fKnqHDUx48N6Jwk4pJU/b7BVCZa5KamhKnIqo1bhKWKMNDShbhLgKyS+UogVYzIPYEqMb8GSTBflWCLRuT6jJJHvkhAiFuKSCV7WzVB8t6MHRBA937RTIH5oUW5NaaSacJpKkCRRcjdKNfBT9Tzge5bg2XrV6xa4lsqZJ3WrggBJUa1IYGULMr0AaZAjBmkemOjSOaOLQ6dlSXAG8+NE5kMTUEaytIRzUB9ahJqweRp/4+4Sqjvv9utS2Bm8TuBKro+upAsZHRBph4W8jfjsVHOMV7x1AzkdK9lI+hU5luXarA9pjnJImXz+aZUXp8ip33VWb6SfGhJna4GUy/NUuyu46BxRD58=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w1kIV8bw0/XMTjJ5gR1viBIkejneAq66kYN6E7a94ncdp35kxNimYWdiaqm6?=
 =?us-ascii?Q?U2Az8R3LziKHIdDZCqQ7eB6hO0jbL+2O7y3CWzlIQtxt3Ly1dikSe5223wZQ?=
 =?us-ascii?Q?KIT717K3DRADCMUuYTr/nYx006ZjCt7CS5b9GVK7fxZdpxjDYeVfaHLucRYx?=
 =?us-ascii?Q?HVlJvtfhnEzhwsPQYMNGax1a7tVLB1+t58a+cRHSX5qALFA9qmQz9oBhT3yi?=
 =?us-ascii?Q?GglEN++aKzCecAeB/pYJaq66t+LtHEI5sNM/EwBW4Tf1u+/+GeEGv7rUE3uy?=
 =?us-ascii?Q?FZpvS9dRLUkpyE/lrxzzrMQasFA4ZfvzVLbr/YGjbE16oKI+Kz/x1p3lh3PJ?=
 =?us-ascii?Q?vy1JcAY1CqqWEhn8W/YpMlg1+24vY29QxFU2VMkUSCpdIQX7alWUE3J+l7zz?=
 =?us-ascii?Q?46ZebbQSFsd8uEUZoXTFW9b3Y3PEwpOtwI5YcbfKPnHzSVXlznFwpqFExldF?=
 =?us-ascii?Q?9ZoP2bMdbnT9k+jDIOqPny408BNRYIC4sNuzY8OCcBs+K/cbhOZMr3JZy9lN?=
 =?us-ascii?Q?Yw/MBYxYWnewnIIQJLyMyD48IqYJKItZD4bJmkAdREOxvuG16uvXVoPGuqQh?=
 =?us-ascii?Q?8xjj3OEN9ufGO0zb5xQ/O0Ojy6SMR5glmeuXnFDctISQ/cSNgx7GOog5Xo1G?=
 =?us-ascii?Q?D8135r0xK6wibO4bb5GYTfZS5G54Pe0Jntd7a2SdWyKVwOTmT52WAON51cER?=
 =?us-ascii?Q?7oNyJ4TNP8K1yUSQgNmGqm2ypmpVJ0TQsBgo6lai9mu3g7al7htaCxhO3WV2?=
 =?us-ascii?Q?KTsmEpNssh54J1i2AVkaaIIjc3U5diJGCxQbEgpcg9fI3ZQwlLznpfhADkrt?=
 =?us-ascii?Q?t8v48dDyIOKeIo+W2mqXMg8K4es+wJeYVzae3An+ZUtRTLSq7iy1KxDVxHOQ?=
 =?us-ascii?Q?xSq90/vA8omXDEvpr8wsSg9ke6LivFoC8BRtIcW8EWYJB+v/aY/4cS+m7aRm?=
 =?us-ascii?Q?iYSokCYZERlo4Bw3W8auJ641K8k4kGqtlOJjTXWRHXN/HhAhur+g1O8jGvhb?=
 =?us-ascii?Q?4rxhStFaFjBcejc2MBDLz8dznl6a4GVbZlZMCQIAIb13819pFW73MhVALrTj?=
 =?us-ascii?Q?yWB1lhFyGZ/59tkxrUs8gfnSHY2MRh75BaCXoOqliAlhnF6M/wiZysGCl7dv?=
 =?us-ascii?Q?uUeXzUylidpoy6q0qWlvg5UoJHGvnOvXCX4GjKlCrEHiteoH+VUKKbbutXA5?=
 =?us-ascii?Q?aNSQTZTsxj+m8dSwjyL8ly5BxTsgO+ssv02igozeoMyw73zP9Lgk8mUf1oIZ?=
 =?us-ascii?Q?RVqJ8kcjHENBRrVxfIJrzOxxooS9cblCxiIlct9TKonXWmVabph9ef8q2JZe?=
 =?us-ascii?Q?bWKTR4iJPZ8asvSfNaQg72X6iqKn/yD5dC9Z3N8QZ9TGG80W4PijWsV919io?=
 =?us-ascii?Q?KyuIZZPTCn5XiaZNY5SMQLFqnrroTQGqMZMVv8r2pJGjVJoOUuyZl9sDpyPN?=
 =?us-ascii?Q?gJT1T/1QhqQJxUvKaW61K/7s5JmMuENSqjtEP1xbGtSTq3d7Dl1j1TNRUgJT?=
 =?us-ascii?Q?V2Nl96/riXPjheNhbYUsIpaUrQ6SuZvoirhZiGRIfCExztjUL9R6Sz48Ksi8?=
 =?us-ascii?Q?OM1TEW59CmLgoX/8cJYv8bJxLFiwo7jm9GL5XZoHE6USB2eOIPQNJ1qfziDG?=
 =?us-ascii?Q?QWR3mASA9Nw40yObD+Idd0suQQGidvCqp7U1Cdgf6CcrkETzWdCD4YO6qzbG?=
 =?us-ascii?Q?91gxlO7UDVjvT2LxXUUwHm2z1ujvfgou73x+OsvmbMqVL7IQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64edfc8c-dfc9-49b7-9ebb-08de837c0c99
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 16:49:54.5797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BTgxC5FNB5vP5ee65o/XuC8p2nw/cLZpp6Bm1UR0sJ0fQd+s1ZQ9gkE0uUvmUkso
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7477
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7396140014
X-Stat-Signature: xtpff91agp7m3bee6edxy3wz8oo4np3p
X-Rspam-User: 
X-HE-Tag: 1773679799-315393
X-HE-Meta: U2FsdGVkX1+QHp4CgVtk3/d/XcHqQh+wuH8iOmhj/PMuQQP5Yc+D8h9WYyZlfXBIpV0il4YvliallzWhIE9gBCqEQeo6G1PbHETJkCoujG64/Xt9lEmTx6KDa+6fbz4uicObf5g2ri4tffjy2P0CdoLf2q0tRsR64k+zvi9wlxHqKDcTNwBr0Lq7ruBzjayXJsPXFGfZ2ho5qk+LB5H3uRwUFGHAE1+WE2qauGVXFUpqL3gaeXw3LmJtMiEldKtbipXRJByl6/24F/VUGhgHOZEPootDyx0yzBWOUUaudpBRjK6+Muihs1YAXvNC2wToY3nQa6flgzWpoKYr2DiIsScKER2FJAdt/mhiYr4hkFkA8+gMEW8PnMnJmCjU/eUE4PD8N3U1bUY5/ZISX27DkbBLcOWGkshUW1MPPtip6ujtm+nICg0snWU2RCMGMNgCLofC8CKGUaFC73KG/FcWRcy6M0qKZtDmoppj8M6OFz9w0z76PfkqUNnANq8TvSPXZ9XF2WFTGiLMv/YWSsWBNNt/OnrMXV4GxA0Q5W2zjwEUYFSb8aK4lz6iz7yeoHY/Lw68xxWI37ar/vnmmAilItFDYyVLfFhjzuDSvmDDoDiC7YEPlfM9iAjN7bfYUOsyjD3KRl7FK9W9jXeimESk70e2gPR+1+GHO4I9ww4hCv9b4dY6DayUdWX1HRhcVeDjU8qPRJi1jYEFsPdn5F19bw6Ga5fRIHbA0+bSlzdjDvqSqnv2RMqspARvdrOq+qWzdgD3UeHmBONNcr/5JS4KE2NRCcPG1EMQEyS39po1CUwFOgqr+oRTsIVxc/ticjxVKInkrPWFOFeC4qkm0ifctUVnr4NVs/GTnQmWyKSo639x6pxaspJ9g+7fgvJjMqrY4KMYVEGtOra/yCv2P52KlW+b35QTfEz7eFVdGootT91fBC42ox6wEhbGSKvAWB+VHMaeFKkUBK8dIX8UhYk
 +EGYhOx/
 xnaZQgxnmjlAarSTbarpNGBygEGmlKETS0JIXk9SMLQzQd6OE+rEqDnW2+3cli8v7lYYP1tMsp2WS1WGsbLYaoI11C/xEt+ujETHfza2om4mQtDMA0xMoNy1yB2zwszLi69tIg2b61ZjrecLuYxYCrumE0NEJmGH7xdpUEPnqrn9pnHP69CiP9GZo7A3IykduWXVrw1vW0NqTXlh/VJmjty3lrP5qzVf/eB37xQr+Zlb6mTbU42tY91uytHVSDYK/FS25VpXcFmCSJpbgw+HPPzncuWhDsGpu2Rtk7vBpJVYWgOxd5+HEPs09mFq+/9VVqiuCjH64cA/Yg4eMyBu2DsPhzMJfoSza32a/M/DJK7CFmGCXHPJ1P3o3Cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Mar 2026, at 12:23, David Hildenbrand (Arm) wrote:

> On 2/23/26 08:34, Ackerley Tng wrote:
>> Hi,
>>
>> I hit an assertion while making some modifications to
>> lib/test_xarray.c [1] and I believe this is the fix.
>>
>> In check_split, the tests split the XArray node and then store values
>> after the split to verify that splitting worked. While storing and
>> retrieval works as expected, the node's metadata, specifically
>> node->nr_values, is not updated correctly.
>>
>> This led to the assertion being hit in [1], since the storing process
>> did not increment node->nr_values sufficiently, while the erasing
>> process assumed the fully-incremented node->nr_values state.
>>
>> Would like to check my understanding on these:
>>
>> 1. In the multi-index xarray world, is node->nr_values definitely the
>>    total number of values *and siblings* in the node?
>>
>> 2. IIUC xas_store() has significantly different behavior when entry is
>>    NULL vs non-NULL: when entry is NULL, xas_store() does not make
>>    assumptions on the number of siblings and erases all the way till
>>    the next non-sibling entry. This sounds fair to me, but it's also
>>    kind of surprising that it is differently handled when entry is
>>    non-NULL, where xas_store() respects xas->xa_sibs.
>>
>> 3. If xas_store() is dependent on its caller to set up xas correctly
>>    (also sounds fair), then there are places where xas_store() is
>>    used, like replace_page_cache_folio() or
>>    migrate_huge_page_move_mapping(), where xas is set up assuming 0
>>    order pages. Are those buggy?
>
> Zi, do you have any familiarity with that code and could help?

Not much. But I used lib/test_xarray.c to did a test:

1. initialize an xarray with order 6 and set entry to 0,

2. add a new xas like XA_STATE(xas0, xa, 0);
3. xas_store(&xas0, xa_mk_value(32));

4. add a new xas like XA_STATE(xas0, xa, 16);
5. xas_store(&xas0, xa_mk_value(48));

The outcome is that xas_store() does not change xarray structure,
namely the orders are preserved. No issue is present.

After 2 and 3, the xarray is still order 6, but its 0-63 entries (all order-6)
are changed from 0 to 32.
After 4 and 5, the xarray is still order 6, but its 0-63 entries
are changed from 32 to 48.

I will need to dig into the code more to explain how xas_store() works.

Best Regards,
Yan, Zi

