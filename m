Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 336C2C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202836B00CE; Thu,  2 Jul 2026 20:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B3686B00D0; Thu,  2 Jul 2026 20:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CAD16B00D1; Thu,  2 Jul 2026 20:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C66846B00CE
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:31:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB5688B919
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:24:56 +0000 (UTC)
X-FDA: 84944511792.02.02FDB68
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010041.outbound.protection.outlook.com [52.101.61.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id EC75912000A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:24:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tv5yOYKq;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783013094;
	b=gtkYIa0bLte46DlcdOxvOwhKylDWwRvKWdqZvCifjB4ZIsBeDJKBUtp3uNzwYfkkFu/2bO
	LJMYV4x4sKJuGWIqU0c7aYRSnS8R5bWtcZ6/wbUe485A7youosWo0WO2pMszdXb373P0rT
	Piu8RtNvEQ7FTZJ4PNfMKiyeixAy7GY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783013094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpdDB0Wgd7YfjB2Akt7cQkW7gsTe2KMmVUw/HaSV9Tk=;
	b=i411j0SElPYnz9VXItVRmg0a370aciGSVAQ9lQRyXwbRELDx70TIaIMd1fggxvIcHwMK1S
	LHn/MWIoXVpgJoS+yi753AIEpwE1GbPGfgOzWjp0XJ0DyK8dXJAUr4PY0+cJfIcuq7Cg0K
	/66MDaMWDBp/u6Rmsq6/Sy4yne7I9PA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tv5yOYKq;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iSqoHz6vtr32b+PRC/Pqkg+nFH4dwCdZySmJ6k+D/CvqFkUuWHALUgvXOKS5drzS/gA1aVFDpO4XTjGFUv68tdAEoSWw7Hergw+/Cu1V8DUChbwcLfdJF0xMw9gReOfnh6XRMJPX/zjfwxACfhOLUHP3THyoAAq+H0wiBFpkYxacxcMqwNLFTw5wqUiccw44A1JFh/zS60ft1cNXA2aHFaTOwzMw50+wHyaSvZktyWQW7NLl6flDKnuEXgKFNlqcmf4xu6s4hPh5RgtewjR+QfVYpU+P9kR4/x7MgkGnqI9prYrrBNMH0bATbtMlsAsXFkpl217q4FrAE/6xObogOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpdDB0Wgd7YfjB2Akt7cQkW7gsTe2KMmVUw/HaSV9Tk=;
 b=kd/ZoTIlNpUqNeY8AH6X4TID9jBE/XmpmkpKG75Ib3aE3eqtg+pLcqtx/0iJzgP7ltRA6+CEMTw/wqkqHI/KxGDuiOnkQQZ/Y6Oc5/1VRCLjNUDHXx3pOA+Q2pDVnRL+q9tc3dLJ1DalOX6hc0I9BKH9ND5fw4wlR/NbaBDz66ZCKSvYTEeYqCLGjNOu8ZJ51s0JCzA7wqoENJR/prlfSX0qDqnKNWpG3ed2hsB5NBPLuPUcZAwYzFU+56M682bwJ8Ywy/1KEnRC+am9ygGCzO57YCpcHZFzy/SzEgtg9VOHi/uH7BC6ym8dZv5atBB9W7kCzJ4tu5FKsyfzvSbxlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpdDB0Wgd7YfjB2Akt7cQkW7gsTe2KMmVUw/HaSV9Tk=;
 b=tv5yOYKqJJqV0CwD3ziy6gBmlvpmwckoIfvgkAo8ntmOev78UF5hloU0DMaWAWEfirdQNv5uVfuno9kYyxH5Zpw0c87J9CDRy2yDGQXhNBpNiALp8tUN1fx2Po42cCU9bNZiVgv2f/hwNHVsFp+NVtVQyeqJ0IjNNfP+7Tnxo+tIpNZoRWA5t2ye5RdJT0RCuHMtYxiKgDvavgnm0wnOCtuJMpAjYkUg55TLFFHP/Ykp3ao8lxBMxD7ptvsuHXGH/W6sq4/un05M15k6BJ8ZbmsyHTdDJr5CSq9GVdX1j/tqCoy5nGU2gl2MEXfsL1ZTzgEheibh9HvTQbu3wD5Z9A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB7907.namprd12.prod.outlook.com (2603:10b6:510:28d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 2 Jul
 2026 17:24:41 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Thu, 2 Jul 2026
 17:24:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>, Song Liu <song@kernel.org>,
 Eric Hagberg <ehagberg@janestreet.com>,
 Gregg Leventhal <gleventhal@janestreet.com>
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when
 collapsing
Date: Thu, 02 Jul 2026 13:24:39 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <2DA84662-F9E4-4ED3-A225-71054FEC3849@nvidia.com>
In-Reply-To: <20260702165409.164568-1-pfalcato@suse.de>
References: <20260702165409.164568-1-pfalcato@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:208:23a::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB7907:EE_
X-MS-Office365-Filtering-Correlation-Id: cc52229b-75a4-45f8-4426-08ded85eccac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|11063799006|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mbhvVNQn92zuJWSMGykvpcyftMNCMUMkTJMZ/G5ZzDJ5Kb7qj00fF5PwaJWz6aQ6R2gQ/4Ws7i6EFxnW0Cc4A/bg4GRZjlitV+zrOW5YbOSj1P4U+SaqLggEr7uMzyRM8PBmBWUeWLasdrUszXgOYBl+QX7I7HSe4FEt6GVrux6bHn7d3yQ+GTW+lHxpNLwX/baoF1WwxWhq/lfxJZWqxaLv1BuQYd8JktfMqKfOpQrCdm25WnRITmtQ/R7U4yu8w+GigEr5MroUvNQh086Y1iK8NhQT36U2VvjSsYTIDe8eHHCtLs7gi1HymZMQl/IDp4Zxgip0gY+G66gyz445CLun5qrhDTZvBm5KICCPbHGDP0YGgcc4RzrEhll7jahjaCa0i82yEpUjCD52RDkRuwnLTipuunPQHfPC7LmiqUhnW1K+uIAu5ChwupNtioGFMVlN50A9vVHXdFeaF392Bbz8qLA4fSrMveonRa0y79yXdsa5bXTVO9O+TQEWqfC+ngUSuCPQMfhMkmBwVWlyX6Vikymd83JepxrdFBgK157ekr9gFCxzKlnMTjUWi4nsYtR53SfzA8Td1WHvdn10kgBCdgVBY4YIxrUjY/SyHL85E4NQXyXGKx2aG0hZH/51TGcxLkhmby6ZKdVrZh/LkUxRI0TKEExIYwBEMC+lXsY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(11063799006)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gSxfSJ9vs6hmvqHKts23gXODNfXSxL0XuWGSPlDl5nwYoSUZz/d4XNb/j0Yy?=
 =?us-ascii?Q?YFOnPltpgnl2wBJE/Z3XDlyCkG06oSICYD1xkiRq9mPd+rstdLlpNGlsIlpN?=
 =?us-ascii?Q?SSLmrlACfXBsIHPlkeZpTjZiwiJ1Y9sDc5H4FwYV2Ir8ernxtWw3JR4JFRne?=
 =?us-ascii?Q?JWisJpg71AvQigtbs6BCblBxER8UBP7Z8xdwv2dj2LNrBG6nTmd0Hh2ApsUr?=
 =?us-ascii?Q?Mi30xTPhF9EWgvYN+iuM8RjRni1QVkXCESXF22P+CxbH5NUFA2KSqiRKj0HD?=
 =?us-ascii?Q?skZ2ecSMbGJOY/vnDfoKTp511FP6BrR1jeEisSSuePGsXKCzbS6u7hqxdlM0?=
 =?us-ascii?Q?2vp05+ln2mosHf8frB4dZUS/sPwHNMJ08Gfs3g5eA1wYXeSgB6+vfKJXVERD?=
 =?us-ascii?Q?NpaL0M3djM8DUAzhZs6RY5UY/Rsxz19wVvCs0ryoR3VQm6IMcBjh5Q6Na8WN?=
 =?us-ascii?Q?uiSlGIebr1w0DQCV/UnH9jEnnCoaJSYuBGzJnp+FtRiEjy6Hv8sGf12nSQi6?=
 =?us-ascii?Q?X4NJcxUYYzFhCWWilqxiYsAbFYnnIwYz/DaA/U3cMubmmbO8wWbP3lzKgaYj?=
 =?us-ascii?Q?mttrBHZ8DCGFeVFYMxXzO7GofigQp8jHvqO5alYRkw8hLQ7oax1o8jQtY6FW?=
 =?us-ascii?Q?bxBVWEaf6KCDJv1RgPXGQYPCxt+PLVgMgWSdXY7OBnDX6an43HH43In54ldo?=
 =?us-ascii?Q?mAJ6xMPF+Ks59tzNgQsEPxSULpS2x2GrihrtpJsX9iVwEBuU/Gz+LMKwRFEA?=
 =?us-ascii?Q?+gFGPXWEawX1/QKNhN2P53Q31WedRtPDAeEcfNdRk+vVe8QYevM4hpWV/y+t?=
 =?us-ascii?Q?pyijMAYBMw4jdSsr4zm8ADLx2YFc1ZiWqKIwYYogIzSChF9cHWW///wKnEn+?=
 =?us-ascii?Q?qVLcZeprPFdmvPiu4ebx5JsVDdjWHle3i7PEYDlaF0dltvaozPAxYJ+3NGQB?=
 =?us-ascii?Q?RBAXOuG6p03yLRpmHaUi8RrFw4Vru5+ILDqmctXZM8JqTjB9LEAnWvHhACH7?=
 =?us-ascii?Q?TvgLEBVhBDfbEpGZM2t3033tXakocrBUC/Qo8Tgg2B8jA/rKJ7GqDd7gF+br?=
 =?us-ascii?Q?PrLmP81XVAZ/+r/2WONW02PBxlSQ8VJhb0R11YsKstqx+hijfi05Aq11x+Xn?=
 =?us-ascii?Q?/I3Me7SkDszC2M8CYY7G0NhbfTkK+pW7SdxerN4bXBNb4IAMRB59PkEvHHdA?=
 =?us-ascii?Q?p4rFTy1GGLzEkZZoXF5+3XpRVuMJp+xplfC9q0S/oWHtdBr9z95l310uGmH8?=
 =?us-ascii?Q?+65KmE5kCTF4qNFW5YPyUh1QKuM+ITzAJh+SZGqY6h+LDHFPkpjSs9GvUvWx?=
 =?us-ascii?Q?WKZedaV8xYu4C1Vt9opT8tBvK3U5tM+ZcWdwWCsQQmYfMOwXwNdjvLqqXhkV?=
 =?us-ascii?Q?Lcw2mkGdxqbaWOCKQG5L4Jr0cNhprNuD5rUOMmP44QRfYVstWQqB9YGHW6Vu?=
 =?us-ascii?Q?oQMmqTet01B6M5kIG2/b8BhgmaNdKufUFYlYRjAKlv5uEFFZMcKB5I//geTq?=
 =?us-ascii?Q?Yr9SzZiuRsrRVHuH8Vfgo1RonTK38sLZ+J+4LKMjl/dwRU3GLMJeG+MPtDX4?=
 =?us-ascii?Q?pfT4+GnZ/Bktqle2RsVFCsfE+OnStFohS+mregSbqmTK7CK9zUrWKaHEQC/O?=
 =?us-ascii?Q?Sf2L2jzV44T6DRvWQT9FE6eBWL+J3ZvKxteTekdCdX9PqC1z1hTwi0PiXSQQ?=
 =?us-ascii?Q?SKZ6zDXl/fZ1Wy5NkYYI1eKOz3vOoSQCQS2x4CpiWi7IlgVZTG5vLPpSeuo0?=
 =?us-ascii?Q?wl/+JNwDbw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc52229b-75a4-45f8-4426-08ded85eccac
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2026 17:24:40.7496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZNeGSHEVW7PBwlF60fhz6cfEBxQ+BusNh4qBjOrzhCVyC2Jf0G+3JicpZpTgEHP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7907
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EC75912000A
X-Stat-Signature: yz9ejyxotndi13xsrkxfjoc6gcxe65r7
X-Rspam-User: 
X-HE-Tag: 1783013093-933347
X-HE-Meta: U2FsdGVkX1/6eR+1oMYQZxWL5jyr9VARagDtNd225CNQn1jfm7LdoXwl6NvtUbuABk3gEi4XsCuAGm9jehagHBh1LSlK4LlOY/VDZfvuO3VVKp/S0Fm63Lx4GAbqahJk6qfNkseeli9ihQQGUmdbkBrYJb147t+CyQt2mr4SwCgQS6LQKbu77TiIv6jBl1UJ/IsVzb0PuHYVY433P4ttRCDXJet6pO3VGFFvo6nVOHm5DOcmkBZDeQ5qrS3s3+omKqVSmLXlpLBjTLlXmlWh9JWz0qAeWvsDWcnAXBqaY1nUFexGBsIqb9B1B4qBfqKdOqkuAuYULmeAdFuLggbaqcHNYreAjfI7kbYlzsGuBXQF2aaDAXVlpD720DxJ7B9PZUOyJ2Z5mWzjkSHXF6KqD9EUyCVGttEWuOC1LoM4srztob30bMfvdIlKku5Ba/+daB1EFOu6FMXG4l/QWjDq9S81IlvFfvbBQZLsWhowZ2gxGGRU2d9LA2jzDLhiXBtA45ZZNIlOS9oIHwzbY8RcJ/nXsyhEfuj3d7TS7/RWFQiqi5Q1VgBa6kX9ZqnQTVotaxb/wOM2RQayjNgXojZzK4zxAIB2Q68Nk3pogtIDtaKdM8vlKJazD24MVUMDRxnolaJcyk/y5wJW563JTygr8p3yGiVZ6qtI/cxuymOm0/JZX7/njPdC/HD9NbLQxlIoizxpPDqiYeU9O2051OIV7inggk15BSxha5TcnoiJLcjAxQQ0qgF81Z1wCib5n7yPdOksmIu6nhGgVwwyliGpBXSssOA1p5bh8MxFCREYIqvvJ/o7y5WqgS59J0SowcQqMrBCp4vD0cwJlIDK3o1dj+jOy8x+QD4RjFkw4yz5vVQhasv6L3oZXa9sBrK+IRX25QC7Y5cgpWbnnXkeAxWaIIsgkXzakMBv6Bo+1Gqa7KDw/8y2Yv/xfz+gBAilvk/WE6N7vn1JEuPkah64mS+
 VafQfZ7s
 DfJYAOgxqhaoePtxSf8T2na8j5X69+wcoHEJf3wFSFMk8ZUD+hOba5dwUxkvzTaMEozdWmSmVlMkBxt5o+FS3SDTadhRh6Szt/9ond2xQWS/Z4qO1kxLSB8B2ohKBId4XhAdCwrSXAuLotfZPDsBQEjI4zJOp1lFqHO6mZS8BeW2oudpC4uDBiEsJZxSdan/y4wTeEVfAOD20PdaiIMuAzWgqKhM3gIhtO0T8Nri0pqo2lB4BR9hcAPWtBr2piVnAe+EeqCXFFhioea9l6iFQB7xyUQXnv42Z2FoW90BvL/1phE8gG4+y2TrWAbw50bnTkjUIjo+Agi1BlT7G53hT3swORjHQe2V31FWOkENDw2LDUoYXRQqliTAJc9UN2FbnDgCDN/tVAPDakQDFObd9VJYmlEu3pMvwMekUwgGWMHPExgyuRUPHOLF9RTXB62eieMPr6wcc+hOqtVYs5JCqUkKsmP1hFtysKuPKdVCYzwGjMUPciSiNeuimJAy0bYWgR8KdqxiFYxYKtJbhpwNYo5nXJ1ceAIf8Pka+No1K5Sl4hAwh1CA65Oc3jOsnjjNxCT1vo6TgxT8vEpGzRgaB/Z//3yJCPXhbXqSfIrKMyCWwVng=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Jul 2026, at 12:54, Pedro Falcato wrote:

> As-is, khugepaged and writable-file opening exclude each other. A file
> cannot be open writeable and have THPs (because the filesystem is not a=
ware
> of them). khugepaged will never collapse file pages for files that are
> opened writeable. On an open(O_RDWR/O_WRONLY), the page cache for that
> particular file is dropped. This is fine because nothing could've been
> dirtied.
>
> However, there is an edge-case: collapse_file() might not be able to
> coexist with concurrent writers, but it can coexist with dirty folios
> (from previous writers). Therefore, the following can happen:
>
> open(file, O_RDWR)
> write(file)
> close(file)
> madvise(file_mapping, MADV_COLLAPSE, some non-dirty range)
> open(file, O_RDWR)
>  nr_thps > 0
>   truncate_inode_pages()
>     /* THPs are cleared out, but so are the dirty folios */
>
> When this edge-case happens, there is data loss, as the dirty folios ar=
e
> fully discarded.
>
> Fix it by fully writing back the page cache (and waiting) when collapsi=
ng
> file THPs. Doing so provides the guarantee that no dirty folio will be
> observed while there are active THPs. To fully ensure this is safe, the=

> invalidate_lock needs to be held while doing the writeout, so that
> do_dentry_open()'s page cache truncation excludes this write-and-wait.
>
> Cc: stable@vger.kernel.org
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Song Liu <song@kernel.org>
> Cc: Eric Hagberg <ehagberg@janestreet.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem)=
 FS")
> Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
> Closes: https://lore.kernel.org/linux-mm/CAFN_u7H_0ECF3jixP=3DT=3DU7AH5=
=3DQ3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com/
> Tested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
> This patch is written against 7.1.0 (because the code no longer exists =
in mainline).
>
> Zi, I kept your Tested-by, but I had to move some things around and
> use the invalidate lock. Please re-test if you can.

Tested it again on top of v6.12 (the patch applied cleanly) and the issue=

is gone. My Tested-by still holds. :)

>
>  mm/khugepaged.c | 39 +++++++++++++++++++++++++--------------
>  1 file changed, 25 insertions(+), 14 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b8452dbdb043..0707d719a270 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2094,32 +2094,43 @@ static enum scan_result collapse_file(struct mm=
_struct *mm, unsigned long addr,
>  		goto xa_unlocked;
>  	}
>
> -	if (!is_shmem) {
> +xa_locked:
> +	xas_unlock_irq(&xas);
> +xa_unlocked:
> +
> +	/*
> +	 * If collapse is successful, flush must be done now before copying.
> +	 * If collapse is unsuccessful, does flush actually need to be done?
> +	 * Do it anyway, to clear the state.
> +	 */
> +	try_to_unmap_flush();
> +
> +	if (result =3D=3D SCAN_SUCCEED && !is_shmem) {
> +		/*
> +		 * invalidate_lock as shared excludes against concurrent opens
> +		 * in do_dentry_open() truncating the page cache. This is
> +		 * particularly important if there are dirty folios in transit.
> +		 */
> +		filemap_invalidate_lock_shared(mapping);
>  		filemap_nr_thps_inc(mapping);
>  		/*
>  		 * Paired with the fence in do_dentry_open() -> get_write_access()
>  		 * to ensure i_writecount is up to date and the update to nr_thps
>  		 * is visible. Ensures the page cache will be truncated if the
> -		 * file is opened writable.
> +		 * file is opened writable. If collapse looks to be successful,
> +		 * flush any dirty pages out the page cache. With the nr_thps
> +		 * incremented, there won't be any new writers (nor new dirties).
>  		 */
>  		smp_mb();
> -		if (inode_is_open_for_write(mapping->host)) {
> +		if (inode_is_open_for_write(mapping->host) || filemap_write_and_wait=
(mapping)) {
>  			result =3D SCAN_FAIL;
>  			filemap_nr_thps_dec(mapping);
> +			filemap_invalidate_unlock_shared(mapping);
> +			goto rollback;
>  		}
> +		filemap_invalidate_unlock_shared(mapping);
>  	}
>
> -xa_locked:
> -	xas_unlock_irq(&xas);
> -xa_unlocked:
> -
> -	/*
> -	 * If collapse is successful, flush must be done now before copying.
> -	 * If collapse is unsuccessful, does flush actually need to be done?
> -	 * Do it anyway, to clear the state.
> -	 */
> -	try_to_unmap_flush();
> -
>  	if (result =3D=3D SCAN_SUCCEED && nr_none &&
>  	    !shmem_charge(mapping->host, nr_none))
>  		result =3D SCAN_FAIL;
> -- =

> 2.54.0


Best Regards,
Yan, Zi

