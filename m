Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5480FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 14:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ACD46B008A; Sat, 25 Apr 2026 10:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05DB76B008C; Sat, 25 Apr 2026 10:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67C76B0092; Sat, 25 Apr 2026 10:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D06826B008A
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 10:21:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FADD1402F7
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:21:09 +0000 (UTC)
X-FDA: 84697290258.18.1A4ACD7
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010062.outbound.protection.outlook.com [52.101.85.62])
	by imf12.hostedemail.com (Postfix) with ESMTP id B89354000A
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:21:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XtrWxuTT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777126866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tp1Vq5uw+azdTa1m4G30Ct7WIlp2/l/TDVdySriNCkY=;
	b=JKk6qPlcHQVcZT/FM9k3fE50MPLT4DW4TGAWKUv9KB7asEFqm5nwEhmMkz0ZL46ryHyj5X
	d/zOjWHYNAqxIJ+3YHQxd6z3Ou+nOLfKGovayQUHcxSlj2mlw7U/W/lLEST3I3GR3+lrh0
	H1xefZDgHn5BMtB9znttyD3ToTrsp4M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777126866; a=rsa-sha256;
	cv=pass;
	b=LtOglEZ8JP7NzdQ5TcLB0RFQLLPpLfm8Rn3MCdNtb7PUiAi9kQh3bhiqsr55vKDRTG+EyI
	L6TQCV4PBn1a+oseISdjpCG0xPSSkEVxS39HwftqANqNyTQdMfEr/nSJYRK2KThH9RBYz3
	OGWCHms4FcUChCOb3psZbFn/0SN9CUk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XtrWxuTT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NoE8ggzj8/5Tv/RcoQayk3ro/dIQ4Kbl6X1sEfTPt9fJjLHUtRyuZnY4RC6iF3e1HA/WtYeJyCsCMTTcyebGSQc3KkbShx8wCmd460ptcCstJGBu9rAxemifgTW7mxhIgb10pi2CeLytDT+6OaS7fYnwG7sMnBfnOeGXJk1PPjQaFOrmK1XRNFSkfdluomX1lSRTbGAvGt6hqODcsN2oKmjEs6lqFgNWgzzH45iHfxMWRBAiXhmFLqYMihIr93pLkE8N/ehpps8B/O/IAmvQxTG6STyzcEzFRb4e2sC1nS63o6+3o5OapEeuZRNcRKwHXMnYw7RvuQjvIs45u4ikyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tp1Vq5uw+azdTa1m4G30Ct7WIlp2/l/TDVdySriNCkY=;
 b=qFafpr7F1prNTy62aP4sH5r212zHZNrN0lYE1yFSyDD2pPEHfblBwOQKTeEAE1+DP7CjJi28GKvwCFYD8z2/Q+/0AQc8ZxsENLoqTanyTS5gLHVacnytSj0ozFaImbTq7OCMQKXC5reHlzSzrq8Edp9bY5D0MGoZMM36cWnLLU72os7nxVZS2JvJFQuFD3fUg1Fo7vGCizGKsjhZrdfTgVXpQOyoJr76sfUScCZeOUQporw+MjEeiA8AWxAClEIzqwln+BUiegcg4CirAoIVqd0WNdUz9cgA90wUqpFilA0S3QMcOPCQ2jcNwXqBPYpq6t0T8Wv4xAixtYdhuUckRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tp1Vq5uw+azdTa1m4G30Ct7WIlp2/l/TDVdySriNCkY=;
 b=XtrWxuTTewGW2lOn4tGbkzZDs2AkIDLkV9Em4PNIBMt6TbBy6wXP0zpffYNKcJBZTwQnN+MapXXWZHyDSkqeplIXrtPbxXsIwLr1LKDFNsRmmrGj2lp3xQRzU67aI93TJUNsAo4hPLjDgIvnPp2Cn86WkMlJu/BWbwchfaa9z1WW3h+w0Z6/eGMwjIC8pq7DhxW/Ax5h0ivgxyZCBG+y8n0As8SPXEQ7cY5rsUiLTd+7Dj/VM5V5zZ338MDlCTchkvI2TfXVIjIADN+pnVkSD17oCbdcQdtkfFmrwbp3xfaewLE7MJav+ubNtmx/H1cvwjRF7ELIG/m5944Ax41Y0A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB7035.namprd12.prod.outlook.com (2603:10b6:a03:47c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.12; Sat, 25 Apr
 2026 14:21:02 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Sat, 25 Apr 2026
 14:21:02 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
Date: Sat, 25 Apr 2026 10:21:01 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <5D99B763-2544-4130-9117-9E6BEFE6A2CB@nvidia.com>
In-Reply-To: <20260425134453.23769-1-nueralspacetech@gmail.com>
References: <20260425134453.23769-1-nueralspacetech@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: IA1P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB7035:EE_
X-MS-Office365-Filtering-Correlation-Id: 6304c229-536a-4717-72fc-08dea2d5e14c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JKv7ycQwtHDxcNLTaqhzT++KqhnNneqQimsDwnaHlHQcdI0J2mBWasy5LAmC+zRlO50BUwhAssn0ZmUi/K+lXd4QspcHEJBFkO8DpygwiEYPs2bm4L/u8F0NcHmarLjIVhfoN0ICs/v+yIvAAwgkumDMDLv2iXOxJGokZeBFPj04tb0iex2bkOMNxtKdrIubdEpkRsp+4G0gnx6wBDVxpx37rBSwOJtJWlTLg84dCQYkrDM+xScAXQxrbDCQ+WJ/GnA55gcnZcTRTgBtF7tsVYypZ1RXNcQVPkTjoKVZw+IMnvDJY0Sg4KgDNOwzlLCpiuxOwyx/YHN+i0BvgRSt4i8fyW0ldThdContJDNsQJ3P84Cdc6IcDW54scXccumsbexyAvpuZYSzIznA9cONJxsk6ys4LKdDLY5Y9dW0orGHQHjGZH2Ylt1uB5O71mNwudX4gjmiR941OvJYgIDUfJguQRW3VGkLkIcnMFgvQj8wBo7RFuUU/vUhExC5BqhxVlWn4khCdiXMpNYq7j9wKPN9QRi88L+3MuE0CqyW6DjtVe3y/IqUWo4DWbYzqJiaHNKd50aT+fK5qC0MoYbCHD0/VOrcGgJjnGrG53EljH0aOG4Z8a0r/NYvBs2fvVmp7323huIY9oniBDvN/bmn6mspqLcO+xhSSnHN+1dNhS7rGC1k+Wf9ASWf8RtzIPkXHAqrK+2JFQB+PYi1HhjikYmOF3camaILrle6PN3sV3Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a+PV9u86sR5agbvUujWMkGgcN30/yj6Nahuqm+GV78BlkgIPZDwapZQ8XdaB?=
 =?us-ascii?Q?bKvgWRxVS5MborHAPTpXbFEBVvJsNma6xAq+IsVYD0kmr2ErK3tnkiKTw/He?=
 =?us-ascii?Q?Q4L8u7TUnEc/QYkz9yx/Nuk50MexUtpLDkzRj5c6l7tCqpDCXS5h2trqjVjD?=
 =?us-ascii?Q?70MGHYzFTp0GlKfDjXRkQLKq5+lvOdQvXshd/IVSulhI99Rd0iKUlO4Nx/ou?=
 =?us-ascii?Q?ukiV3puR0igcwczCQUzP6oQUkbZSXP225v4vQ5T8B7NqBbM72A7y4YgHNOrV?=
 =?us-ascii?Q?SPlM6PAGDhPg9C4Y32sFPXthI288iTlPxVTrPX8RYC74XTQCxTsgOpIR8O+C?=
 =?us-ascii?Q?HMZ01jHSYKvLZEbUQ07TYMCdUmhj+Ad07rG3nmHjB9FPF1pn68XGt1agfSA0?=
 =?us-ascii?Q?2Wb81e4xQP4UUkgI4mZYunQVz1j1wv5VejSJUrFbxL41aYVzfHsO35p+8XGO?=
 =?us-ascii?Q?xtM5NYk4DVX/8FpiwuFXbHqWgIT2F+1N50YSYOfDXvYgvcvFiUDW/4XijaFe?=
 =?us-ascii?Q?dcJpsFAos9kHv7rlgF8gTpL2mGht3wJLWh/KWXtMsrl+8KM+3asPRg3zpPqn?=
 =?us-ascii?Q?wkuFc1NOIGmc/3bPtOUDSoK76OJfdUhOwntRTduajUVhSQnfupH9EGi42r/1?=
 =?us-ascii?Q?q0q87uzrIC8QfnMgpg5pz9mixiJCv9ANpnja6AeVYQ3fThx5bRi0yM3N72Nu?=
 =?us-ascii?Q?0PcXYUSHxqQhWiCWUbGVCeuhkqP+tYjuOXbWhOWkHJ4koWXJxlamKKMtuiN8?=
 =?us-ascii?Q?wkG7xEqFwbpS/qYzId0JEw6cGzvkkhZ623iJauFoD3f26XRIGKg9+EaaCCWT?=
 =?us-ascii?Q?OJvMGzqC3XwDfP74T4pZKDWhtkYj6QZIykahhapP/9LF91t1KdVk5qsLU/EG?=
 =?us-ascii?Q?O5FlZ2VSXzwBOWNXl/81aT13ZgsdjRhjr81P21jO1VPHqTXK7n2V8O2mcI+N?=
 =?us-ascii?Q?nHaI7SIP/wFypirZ79D0yWJ1igWkiBhVXE/zoKADHQlwkuMnR2x0rBOZg1xg?=
 =?us-ascii?Q?n2izN8LZlebbnCJdIrzrIdJIJT0X+FFmZcabk9MWEL8373LLxFvAd1jBH4Vf?=
 =?us-ascii?Q?eSXCmYPnsBG6q3tQieaITGtiTcXG9NBO4S1daDHfyqdwEHdyPx8OYoKh7XID?=
 =?us-ascii?Q?UXy6sCc34lp8lo2pu04VXnwGWwhncVg2xb0TFB54xHy/+2sKwSWyb9MDTr4p?=
 =?us-ascii?Q?sLPukUk8HC2juBxesdTEfLONRi2eqs8e6yT1/qtoVmGl5c3x3zewFnKTT3aJ?=
 =?us-ascii?Q?KgefwHFq52Dveb66W16eOkeInTL5Y4yYpSfqwegddUzlagEvHX4f0qpFqHE/?=
 =?us-ascii?Q?yA6cZ7McJdIafBDxtKIjCPH9I953tqpHAQpOCo+4n1gOfck3lSMPPiLgD7XX?=
 =?us-ascii?Q?3vA8DIxtQX6yC6z73ADNsdRrorqN8GdaPowf1P4cZx+dhUeVXoyFUzlt8TMU?=
 =?us-ascii?Q?JzXRpaTaALKOGt+8Visdx7aULh17b2tw3s+zozsdQj22ts4fkMmhU5P7BfGq?=
 =?us-ascii?Q?xr2y/SdwsWoHw+ocED2wYuzbQ4oxyaZhf4nLlae/elPoc05FelMH+CJOQPyO?=
 =?us-ascii?Q?m3IrcqF9KX+8fOH2uNy+lpxHf0S9psbyyon9ComKo6DKpSXJf1JUQjGRCUvA?=
 =?us-ascii?Q?/emx/dIO1P/KSqrd9f31jh8eBmxtT6r972GaFc/psOQ3L7VrML0D5fseGh+A?=
 =?us-ascii?Q?LykWfC9l/tPGpx8ELpWy0GMt/6Y30V1DEtstK6wPXMsmnXbQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6304c229-536a-4717-72fc-08dea2d5e14c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2026 14:21:02.5689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YtMJbbvOYgUUpAO0rlzrGHDcfQyIBXAlwGS/HxiztOScLLT5na6wrNeMhiCc+l+4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7035
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B89354000A
X-Stat-Signature: mtr8i4ihpb5xrinxmsrjozeunqabppds
X-Rspam-User: 
X-HE-Tag: 1777126866-346050
X-HE-Meta: U2FsdGVkX1+TI0KvZwhvH2lTPCNz37LB+tqszqUoepBSD2Oa0FrzuXG8wUPICG569E+3en5GwUukpXBri8ABzTaps8fGTrvQ8hXLLzToxkjlL2Y58IFAUwJVG33s9+NiclBQZFTxEXOCyY68dHr0ghq9eyFSkBqF8frE7t+7NTQnpIl/YecAZjLN9XtTj9jy5hS9y2SzAYtBrdcEvhpl+5m7bXHMn8caNlMYNZRr8POHHgEN73HukzAhvn8bBykp+J5Wjuxkivc1iwj5f6+1iDvwHxv7CC9HHBm0LU/t8R4XKMpzAwSg+IpXY3NYOAdSy2gs9B/PMQZE4+4DM0Y6gHgVUCJ+YA+lT1MevrheDnYsldUwjljG3tz/DdLdEGhT1Iwo3uoaMHpq2ySpZWEFzSlthfL169cgALUAlLAu60Vs2EkSorQGf5/oR6G76uqvLIRpas3L2yvhPpL/qcYxdLjWrvrTHRRgZ+lzXY4RiwmJSPi9PQp0NzFPvpiigcjTN1lTLXZFoZPkgI+wNfw9xK97bVN3bQMF6pxB+ZLdTEqepSkooglA73VbHp1Vpgy6l9dGKrhgd4s+RQZ9sxQ/gxyrcFAfPVojWT3X2nXYWOw9fdEx8/OuIlszZ3cTV+6qnE2DWS/B/kc+lo9y63BUW4x2xiMnBGqnpucqr13s2y68P1/2EpQYhDpmmWrNZ7W+M5x2KD/dGllRs+9vKkm5OwJvQya+P7A9/q0KFUj36X6DdLM9GoixpVpcLQT2pWF8RmzXyg54Np0qlpaN2/XjkoHvwoChldSBovfd3PR9HP7/FkYYVVpL04ikQ09Jitw2fZDxPXQM0bI7Y2dKMjV5+4To3d1K/LC0WlKyksRmTJaC8/DuXICOU2sFienzmXtnrJ7A31xY4DO0dv1/71xln7AZ0MZsaGux2pZAvsBXUQzUAJs20BPXm8UTKMfXc50eo75XSj7dWpKdHvcYO60
 tz1RVfbX
 7vAuHdvoRD1XE7irkqMYX+2UDO6vYN+j3hQsrvm6VvM3Q2tuaNORA0NpiMrbv0B7GM6QuMvCGaRGy4ZMwqIvnPwDxi3zbRPA3LP4RrYRF7LmqcTmQPoVXHLI0xd51yiarctXPSn9+Ci+DWKW1Vzt6hN58ZMtpFR7gywepdJBfVUqwKlQRshnK3LOudKSSzpyaPNvzFnPX07reyVXQD86pQgugNGnDoy9JvmFagomBPIFc8XJ3iS86LKs0eoArtcxb5TA94VDEDErEhWJXd7SkwKX4468KqRxKcKMWqDDZmtga+9BaB6KA8UkOAUDyWMCm2kwMYwb/VZevitKEjS/7Rjiuz6dO9S9xsoA8KJHHekn0N44oOgQbRxArq4vN+Y1hNIF1gzG6WeP1aOR049GaULfhfnn9zHET+yDwn0FwKrrf7BKm01YNreBVVIwaRW9OJk8UFQ0jD8O2P6RNbAq7UW3L6cQ7XQ+5ao4m2k+yujBWjx6MdlpZIgEAiv5YxS8Vr763
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Apr 2026, at 9:44, Sunny Patel wrote:

> When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
> to a PMD check failure, the pgtable allocated earlier via
> pte_alloc_one() is never freed, causing a memory leak.
>
> Add a pte_free() call in the unlock_abort error path to release
> the pgtable before returning.
>
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---
>  mm/migrate_device.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index fbfe5715f635..457bab5c7c31 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -893,6 +893,7 @@ static int migrate_vma_insert_huge_pmd_page(struct =
migrate_vma *migrate,
>
>  unlock_abort:
>  	spin_unlock(ptl);
> +	pte_free(vma->vm_mm, pgtable);
>  abort:
>  	for (i =3D 0; i < HPAGE_PMD_NR; i++)
>  		src[i] &=3D ~MIGRATE_PFN_MIGRATE;
> -- =

> 2.43.0

Actually,

I think the "goto abort" above pmd_lock() need to do pte_free():

        if (folio_is_device_private(folio)) {
			...
        } else {
                if (folio_is_zone_device(folio) &&
                    !folio_is_device_coherent(folio)) {
                        goto abort; <-- this one
                }
			...
        }

The lock is not taken yet, so you might need to add a pte_free() before
goto abort.

--
Best Regards,
Yan, Zi

