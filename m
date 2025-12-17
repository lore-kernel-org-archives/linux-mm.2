Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB9B5D66B85
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 19:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA58B6B00A4; Wed, 17 Dec 2025 14:20:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52B36B00A5; Wed, 17 Dec 2025 14:20:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927286B00A6; Wed, 17 Dec 2025 14:20:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81DA36B00A4
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:20:48 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A51813C117
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:20:48 +0000 (UTC)
X-FDA: 84229930176.21.BEFE333
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011019.outbound.protection.outlook.com [52.101.52.19])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3839B80014
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:20:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PFD6+0za;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765999245; a=rsa-sha256;
	cv=pass;
	b=7MJrvgDK5AujZ/gOohNl8Ow8zb3K7m4t290epfX3l7bmEOJg9cg+GzLXne5/oOr9/+2Yzu
	ksuPB01cjlAFRSowD7GS62bHpDd9rBTwSoDBHnD6JTnQaFp27IL74cDeWF/RnQWljXk3As
	WE1ZNGusWZJvqDWs/fL1KDpAIdSRHDk=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PFD6+0za;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765999245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0qoXdhvXypQWxc/LRlE62BMbkG8c6DeWL4LoLV6/Q4=;
	b=dhEil8EfR6tEp9w845ZCbO/DUz8jIJ2NjThs38gormU20HudU+vSf1S/qrhoerOD2uKGRV
	LL6UaY3BzStk69sk7sedlEmbt0B57ERTuLtiA5wzmA7GMxfTFZ7a2jdyFA4IQ13JiASfQ8
	GODNOjjAfi2xBqoVCnsxtNugLM4SM+k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eKSkO5UYuNWVABawUx0CJTO21/dx6MsgRuaGbCuVqZNbFcynwehB/mXvFStHCRrXR2p5HofV5rExZHL+/c2rWAiIN2FFVBVQFOXOffLg7ruS5P3ESgYmeNgvSCLVZ0shVSWqxZ62NhV9ab8XsJ8eiFY/ArMTTY5RvSrUfVywB1C8u9v20G4NBL1ZSH43aOe5omxJDPgupOXAW4x6A4TSwLOudrvEJGeL8xwRRzs+2AioYhlBBprY/2bxuk1yy/SZbRb+cz6mZjPbkNTwrMK3zue6EmIFY9bP+olu7k8QVcPdKa342E5aNbUmLXt5WbMmWpPJXUnK3rgK6bJL+4NjlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s0qoXdhvXypQWxc/LRlE62BMbkG8c6DeWL4LoLV6/Q4=;
 b=kAbdOLGnA76IG/h2Efzac5pvuQCIJTlRe+d5ThzPUjfG4bk7x0XX3By/cL7CCmwRk5CmJgS/UajVWuX0RM7Hx3w8+RCs45XG/qdGitDcA+k5a2Gy9fxHugqJFyJ9bDaM5jEkkgm4SuB/NC7P0ZJOm9lRXprTY3rQwIgNB4KI+sSXN5Z5xlKWc3iQvYcoc3xtrQ/3v+xMs0czEwfCiUMXAb1HR/i0qY+OffoO6v6XJaCYLZpGz172/ryXiM1h/f2RNn5iblByAi8NfuDSZKBfvyVAMca77+wY7QTx7XrrMBxFqOCzdIaP2hAYxd8VbQ/oyncLPNGtCOAE6oe/t06UjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s0qoXdhvXypQWxc/LRlE62BMbkG8c6DeWL4LoLV6/Q4=;
 b=PFD6+0zaH/Ys3CIGjxdpPvkYwsn1HxmL57NqxYGi0ouH6hDCAj9PYJk+kXtB7ZAthU+H27/u8bNhTyGmjrEZH9ghYSdiFTmD+7rrdB4D35FB8xMeDL+k1lr/IG8sKQPD3JkLo4sT5J+9d2gh60985GWMnjlUOsUeB0FGLQnpfIpDBN20ba9lPA5SxlfBuYqZfvFPP1VKiSkKTVdMNYRaurWTURUNYH6OlgAUb7vdMe6mKtEGd5C+QFRISMvOmcjoaOMvjs67clzTvhjEXmreKjsdn1nem3ro6D0jC5vx5SZjg+ePP9FDS2EfKpsoPW2SJYSBioksnUPHASqVC0I++g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7875.namprd12.prod.outlook.com (2603:10b6:8:14d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.13; Wed, 17 Dec 2025 19:20:38 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 19:20:38 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v4 4/6] mm: page_alloc: add
 alloc_contig_frozen_{range,pages}()
Date: Wed, 17 Dec 2025 14:20:36 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <AAFDAF36-E02D-41E0-B40A-AA5BBC084F9A@nvidia.com>
In-Reply-To: <d7275c36-f5bb-4baf-8a94-b8522d4aef21@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-5-wangkefeng.wang@huawei.com>
 <D90F7769-F3A8-4234-A9CE-F97BC48CCACE@nvidia.com>
 <d7275c36-f5bb-4baf-8a94-b8522d4aef21@huawei.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0177.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7875:EE_
X-MS-Office365-Filtering-Correlation-Id: a80f2c4b-3353-48bd-3d61-08de3da15c3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sTTQAwdxBjgdiuRw7esiXn52pdzW1iVRAR7mvxUgJSfZtLT4AS8P46bvQUXR?=
 =?us-ascii?Q?mVgGOSJJ2+rScpNq5z7438epVcTEpC8IDxE4VzCMyIW8H1ZU1gVjdVKq1uvo?=
 =?us-ascii?Q?sJVqMYD+1PMNnU30YsWzJ1gFoQK4sKITBjz3HiCvYWPZ4B68N47zfHh28Ox1?=
 =?us-ascii?Q?0BiPtMBPMGuXEExlpzegf3OiQ4hifTudTQtbDDwhEsvTkPlydW42wWYNf55S?=
 =?us-ascii?Q?LBIy9hDkQ5SUIyaBS9xDK3wOXBIPPGitqapHLMU4x/BjzfoCt70bN1K0saPJ?=
 =?us-ascii?Q?TVHOXDnxIEiVLbx7dRRl2EbUW7uBQLtIRQSYRWGlf3b+Js1hzSmWwyALDNJr?=
 =?us-ascii?Q?7P2MEmftUOIH9kL3onNHB3R1BUPyKPNohwkwFNRV08paidK5xbo5x58aE0C+?=
 =?us-ascii?Q?dWVcYH8xOWj4VUk4yVV7nKxXU5NIrKAx4+0QdURS4fgybIrHfq1lOyrX6Dpg?=
 =?us-ascii?Q?6V/3T19oEe0jhLWVzvtUMIdBJk+KJoDxR7LVeajTTVxQg41gz2+R+ahSxqg+?=
 =?us-ascii?Q?aFUDVAi5CgAKh3TdmBzhx74bQC4mn8xAHf1AP7Y9SXwZr3d0DMqsndEDpDJW?=
 =?us-ascii?Q?8+NOuRcpluI62ct8xm2obfjkFOpsqpzyIQ5qX7Rw3GfBl7Tk5HOUSavKb2CV?=
 =?us-ascii?Q?/U3GwJ6R8U2zBVB6ne+QcjgKTOWdMhzUZ0PncMsql06BrKX1/wi1H8G9XqQd?=
 =?us-ascii?Q?JOajnN4qhWdsX6bJ6qxE34Q47iwYHkDlWmmPTF2WSenl2vOI6KRJbjIS21zy?=
 =?us-ascii?Q?E8h/ObNIHMKrNgUoJ34NwvqheUny/YF2IeIej+ho8odSpcOlMYmvrxem43qH?=
 =?us-ascii?Q?wo074drfqTuKQf6FLY1VOgijSReG6c3f/wqFA/IfMRMZtCU31h9zx+IBKp9Q?=
 =?us-ascii?Q?B4x8ky3LhyAhWbQw0gYuhFPCTrW4ovbQxYUyu/T92EMYQFsagGms26YTckUR?=
 =?us-ascii?Q?nc4zgR0zaZJ2jLPKivtD4nRvLSHJJZJhTIfDqZi8mU/ynnqZvD4971CHoKbP?=
 =?us-ascii?Q?/kuTjv/fzObD6/Vd844N1JM+4e4FdFfQgEmroTcb3d4HrqWBvrepq8XIn1fT?=
 =?us-ascii?Q?AE4KWJFCKkTOHXu8Hljp9+276y4yPs9Ny1iqjKsBd40HDYRf6ygX478cNbOX?=
 =?us-ascii?Q?fVrfwbe3+DUHJ2KhFN4x4D0Sf90vL228PY3auNe8d2juyCBIeTDuqfY2Zb7i?=
 =?us-ascii?Q?HVlW55lQlQV41J1IJi7Qq++jKQcsV8hlzXE11IFe7EJyDCms9tArOg7+StXF?=
 =?us-ascii?Q?rMIuBW3/34Pa6QE9Q3MuVPIG2nBQQ3Bk4an36mLfN788OAVWk80tSVB83muo?=
 =?us-ascii?Q?eYmXZvvcYmiz7YXv7LpMSOgpU8UQ/SGxGxe0pVZ0zSPlrzRlgXbf4L9lferD?=
 =?us-ascii?Q?++ey00T6ueutOMfKFS7rERdRuWoSRcVZ7QdGwd+zQIpQCmvroqTOAQpaMJ+d?=
 =?us-ascii?Q?0Aq7aXEHDlPhRXzLeSpSBoJD+GmBFqJ+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RnRYlUqE2BqOi6WBqPQJpOTsNTtpAnSlL8+pSsWdTDXozR5vfOwKUMHNgrw8?=
 =?us-ascii?Q?oGV+2YsFRBv1sRYTrKkgAX/ZmgL1ypudcbMp54XJ3Ag6Ef0qdSXygaBtItq+?=
 =?us-ascii?Q?Y+lk6kpP0Oo6THC7GlWQz/6ZD1FgnF9+skDghx7UYiA0UdvzPzdeVpk/L1tH?=
 =?us-ascii?Q?aOQeBSeM5KuMxonhmQDYp6HRssAMtlL8suzZf6CmTBh98SuOwYR4jFD7cBEC?=
 =?us-ascii?Q?9wWWRyXONFY3tNYlWCopUmlywI1JtOhXrvhYukxguWVbor5oXKM9mp2+P44e?=
 =?us-ascii?Q?WJmrSefNMG1XX6HKK819ZZECtppaqsHiMmeuJzVHZYDxmZpLF3+rmdmAEXWQ?=
 =?us-ascii?Q?D3mhfm41YGZ2KtcBQ/IbZeiaAb0cEWcJSkVjNMof5r/vNTlpB2Fzq2WxkIeS?=
 =?us-ascii?Q?vRAFSrxdIdFSqjM9Ru/bGjkH8jpeT1ehk2nI1U9brYRxMQprMtaK6MZlXx6X?=
 =?us-ascii?Q?EyIdVV4XDMeJl7iQ99pa2cE9UoNsTVJvT5r4OE0X4mV2QXf2YVO+xdY7r+GW?=
 =?us-ascii?Q?MHop48g3GD47DT6EvYJ2x5pvYf7pu+yV6PX+JQxsazpO2pArJXl4C3yH/JLL?=
 =?us-ascii?Q?81y+nMW5/856JDYMUa1HnPpJPL1p//BuoJIlQoUjD04uEFvMz69SJqYqPEod?=
 =?us-ascii?Q?RPpdyWLp7cjiT0cMsarFsv/kXk7IM8SmHeZOt8RlWFJ3/QxjMFbpWOyNqxzf?=
 =?us-ascii?Q?lJQkI7gpdl22RpVPeV6JjtP+29KR+nNtjSg+PeeGQgR3OcQL2eqQgegfVrYu?=
 =?us-ascii?Q?Bv3SjUid+KBvoB+t2bM1jRCV3kHABNRhto2LoqVgRZ6LDnG4QK+2wfMoDHud?=
 =?us-ascii?Q?HOjXi1yoQfUFAReaT1ibtcmuBMRcw9xph4Iobs5SGCC4QE4RdRFjmloQLFt+?=
 =?us-ascii?Q?qFJjuHICjnNk8eK+e/8Ss9lMLqR4whXo6tpyYoJWjLnhUbpzbS/MFT9tF2a5?=
 =?us-ascii?Q?I7E1iSsyW/necvyX8s2ag32logZTOdDKSG270HB+ZbSVsFNsg4VE5i6RRf2z?=
 =?us-ascii?Q?ARPOq5S1HLj7h3Ur08xgLPthM/NZCf1KFA/JTi8lwvT9fkdQC/uT5BTApWk1?=
 =?us-ascii?Q?UNCheGTZmjx+51PBqMBqOr2SZn0Lu0U5trwIZI4yBbxpdWp6Sg1wMlAdd4Ts?=
 =?us-ascii?Q?DJY9bySNQ+DCRkxp7Qz9eIGN5agFmzRmTiXhu0aJkIrGH/dC/OHz3G5IvlkF?=
 =?us-ascii?Q?USz/YiAxUgkwJVgaQt5hkR4He4JE213v8LU2i4LaIu/ShR0Z1nI3mTecLOf2?=
 =?us-ascii?Q?neWU6OF5/qim/5fe23v+aJIXoSPMVXANir+yjBZxDNJDqzKLs8TJgDbgHTm2?=
 =?us-ascii?Q?kaHT6qbsTMHG3zXJ2YD2wh++nhcRD8NGylV788/jJbf+IcPAWyM0fepTPa3h?=
 =?us-ascii?Q?VPXJ5bYLTqRxc34omkjjL8CgPAT8dTBY/DjYoI8h8HJP9+BItfbPubGVcJz+?=
 =?us-ascii?Q?h5QyZ604PUYjhEKyQUjhiwabkJ5wA7kSwFHGep8N0AHxk2p+4rMcmyJXSW93?=
 =?us-ascii?Q?Mr7XrdFMp0lTfSIMoyJosQNFT0w/FWMSrLLqm62P1rezrZIMG5smAOZBXHAH?=
 =?us-ascii?Q?gPClsyp3xglQF4ue3G5FIurgyQ3VgrWevzjj6rgi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a80f2c4b-3353-48bd-3d61-08de3da15c3e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 19:20:38.0926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BRhDJO9VQqIWbUvJ+7VCLqMZNVHNoqcSdUdbz7sz9n6kT8TApmOWfUO55pKyv6eP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7875
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3839B80014
X-Stat-Signature: r4zwnhs69ys14zgr6opo1h1bns4sq9y9
X-Rspam-User: 
X-HE-Tag: 1765999245-183866
X-HE-Meta: U2FsdGVkX18kkFR4KzN45f4jRzRCWGV1RqMTi+UeQ9ZwggMK8DmH1SbtswgXMBnoUTY56SrcxlSvaL28x7vgmsrCZ75UYYckdz3JWayBoisNlXcCO6lEwSsmsMEf+q78QBjYkz04io3hW83DwgRi3uJeEK3QZq0liS8a00OE+p4znB1fbdlVDmUZ6xmK9sHOxeL6OArZ4Djbh2NrhBKdYE4ehs3Hk42YyDRYa5c5JhYv6CR8EM980lAmHYdhcoM5vJHN+xUl58RpdSZfcj+oHqpeWShEapYVAg3VZ5bXi3kDPDimvcP7uSrnqp5x6JHFUSPnx4V3Af4ygCg2F2QfisYxrevzE7XuyBzwMI0viMR8nE0Fprf/fbZj1okcmyDJtvm+XeMhKo0nXWJgfRMS1dNCukllrPBulTOGVOLKr1vIrrsAWVGZ4+zg7TZ3IWRlncJjZgkU2JYs3QWTkeAsXwsnay9tWCBMLt249zb1f5SMmAhP+q40J/hpncnu+10mhvpaKZZqNKPCCzOO4GQ7jVYbwHIuDXC7U8dNW4OgroSCkGsu6B/PvlzLXeohBHsW/fFun6ubA9o0vE3eNX7tioIenqJCPArFGG6MbxypliSOklFu0K/0XAuF1qIAsH0D2g+tCnxoHvOGQiEXQw5EMDQwsiLCpuU1Cfnkp/5LESq24ZgjIuKlTtjmGnIeahZg7t6hNEuicWH1I1YJM/G23kXYnMQ54a7rb319sXFqNp/P2ELcog43BzVUa2l7MIAzFv6w1RnAaMQtpZBr0svVGtfOsqpwbqc3cOPIhwtv274QAGdhpxCXp3a/+wB64+tnI6hZPh3ubs/OwPWUZ6nExOiA+om2VPpgW6sTs/D9js0JLFQ2NFUDWz8Ma+G+F5g9fF64kBXMMKUkihU3245hFvWO/J/aQKyVHvTcXVQZrW8GMq1tDXQHTPojoJ7q1IuHmAWlSd2326OjzHn4XuH
 EzrWojIH
 RjFw/YTZ8/hZCthKwv/nw1ND2HVIHSd1FdbitNMMmb6y6iK/y83qUG5qlgSiRAXcG89KlBZCNRuSyMvWleQA/C7p/DCwZfL/Hnh1Gr4AfJh9M1NyV+eB6BFHzQTmm0ZeXqFMyfv6vr4wLjFV0qbF5jga0BWh2CVEn5AQUi0tWw7nnBz3XxftnwpHOn0nOCh9x82FMrn/DUGiJyDNzufvIng2lUaAjspKKkxjQ6PBXvb0zdNK5sOdvTHGBKM7YFH93mUePHoJEBPgHBAlbPj7CmKEE8Zu2aubJS5gOQqohm/ENcguAGsXVlkc576/iMavY7OZW/S3F8AHAtPqFHD7opZQql131g7lziB2JNZQ8ZaMVwYUXgASwRzjYtPKvT4CbyWHhCjxFvrSwDV9qnBMammPczNKrn4B1SnJdLXs74mgdFa+pprchAcdQTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Dec 2025, at 2:17, Kefeng Wang wrote:

> On 2025/12/17 1:20, Zi Yan wrote:
>> On 16 Dec 2025, at 6:48, Kefeng Wang wrote:
>>
>>> In order to allocate given range of pages or allocate compound
>>> pages without incrementing their refcount, adding two new helper
>>> alloc_contig_frozen_{range,pages}() which may be beneficial
>>> to some users (eg hugetlb).
>>>
>>> The new alloc_contig_{range,pages} only take !__GFP_COMP gfp now,
>>> and the free_contig_range() is refactored to only free non-compound
>>> pages, the only caller to free compound pages in cma_free_folio() is
>>> changed accordingly, and the free_contig_frozen_range() is provided
>>> to match the alloc_contig_frozen_range(), which is used to free
>>> frozen pages.
>>>
>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> ---
>>>   include/linux/gfp.h |  52 +++++--------
>>>   mm/cma.c            |  15 ++--
>>>   mm/hugetlb.c        |   9 ++-
>>>   mm/internal.h       |  13 ++++
>>>   mm/page_alloc.c     | 183 ++++++++++++++++++++++++++++++++---------=
---
>>>   5 files changed, 184 insertions(+), 88 deletions(-)
>>>
>>
>> <snip>
>>
>>> diff --git a/mm/internal.h b/mm/internal.h
>>> index e430da900430..75f624236ff8 100644
>>> --- a/mm/internal.h
>>> +++ b/mm/internal.h
>>> @@ -513,6 +513,19 @@ static inline void set_page_refcounted(struct pa=
ge *page)
>>>   	set_page_count(page, 1);
>>>   }
>>>
>>> +static inline void set_pages_refcounted(struct page *page, unsigned =
long nr_pages)
>>> +{
>>> +	unsigned long pfn =3D page_to_pfn(page);
>>> +
>>> +	if (PageHead(page)) {
>>> +		set_page_refcounted(page);
>>> +		return;
>>> +	}
>>
>> This looks fragile, since if a tail page is passed, the refcount will =
be wrong.
>> But I see you remove this part in the next patch. It might be OK as a =
temporary
>> step.
>
> Yes, this temporary.
>
>>
>>> +
>>> +	for (; nr_pages--; pfn++)
>>> +		set_page_refcounted(pfn_to_page(pfn));
>>> +}
>>> +
>>>   /*
>>>    * Return true if a folio needs ->release_folio() calling upon it.
>>>    */
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index aa30d4436296..a7fc83bf806f 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>
>> <snip>
>>
>>>
>>> +static void __free_contig_frozen_range(unsigned long pfn, unsigned l=
ong nr_pages)
>>> +{
>>> +	for (; nr_pages--; pfn++)
>>> +		free_frozen_pages(pfn_to_page(pfn), 0);
>>> +}
>>> +
>>
>> Is it possible to use pageblock_order to speed this up?
>
> It should be no different since the page order always zero, maybe I
> didn't get your point.

Something like but take care of the cases when pfn and nr_pages are
not aligned to pageblock_nr_pages:

for (; nr_pages -=3D pageblock_nr_pages; pfn +=3D pageblock_nr_pages)
	free_frozen_pages(pfn_to_page(pfn), pageblock_order);

It makes fewer calls.


>> And can it be moved before free_contig_frozen_range() for a easy read?=

>>
>
> It is used by alloc_contig_frozen_range too, put it here could avoid an=
 additional declaration.
>

Got it.

>
>> <snip>
>>
>>> +
>>> +/**
>>> + * free_contig_frozen_range() -- free the contiguous range of frozen=
 pages
>>> + * @pfn:	start PFN to free
>>> + * @nr_pages:	Number of contiguous frozen pages to free
>>> + *
>>> + * This can be used to free the allocated compound/non-compound froz=
en pages.
>>> + */
>>> +void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pa=
ges)
>>> +{
>>> +	struct page *first_page =3D pfn_to_page(pfn);
>>> +	const unsigned int order =3D ilog2(nr_pages);
>>
>> Maybe WARN_ON_ONCE(first_page !=3D compound_head(first_page) and retur=
n
>> immediately here to catch a tail page.
>
> Sure, will add this new check here.
>
>>
>>> +
>>> +	if (PageHead(first_page)) {
>>> +		WARN_ON_ONCE(order !=3D compound_order(first_page));
>>> +		free_frozen_pages(first_page, order);
>>>   		return;
>>>   	}
>>>
>>> -	for (; nr_pages--; pfn++) {
>>> -		struct page *page =3D pfn_to_page(pfn);
>>> +	__free_contig_frozen_range(pfn, nr_pages);
>>> +}
>>> +EXPORT_SYMBOL(free_contig_frozen_range);
>>> +
> Thanks.
>>
>> Best Regards,
>> Yan, Zi
>>


Best Regards,
Yan, Zi

