Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA14BD6CFDF
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A6E96B03D6; Fri, 23 Jan 2026 01:23:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4512C6B03D8; Fri, 23 Jan 2026 01:23:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B026B03D9; Fri, 23 Jan 2026 01:23:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CF9E6B03D6
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:23:57 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C85B3B7FF9
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:23:56 +0000 (UTC)
X-FDA: 84362238072.05.0262F34
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011031.outbound.protection.outlook.com [52.101.62.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EC9F620007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:23:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KcNDYk+P;
	spf=pass (imf03.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.62.31 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769149434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xD+Pvh4eETe8DHjrfq7a8bC2+wEQ/sG9UjQVVasxINA=;
	b=CscT5h98vqfYc4p/yliuZNs8AkZWqPI7tSXVux8X03mXukaXBzwHK8zOcm9dWvqPDpq93V
	qupjgrbyAofzuY+QDUZAHPUeYlMPVmG7QOg2GNhimizzkYdJ7tA91OsO9WDkVykwdasAEC
	pVzFfxFRIPmcnO4fE8LqrNn53VbFaTU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KcNDYk+P;
	spf=pass (imf03.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.62.31 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769149434; a=rsa-sha256;
	cv=pass;
	b=q1ZUR3iJ6l6ZbcDO63hurcUnasj0cEbo6xWucm/0auha3ueYLr9AWj6VGGtCp9ZH00RGmO
	O+9wOntM3T9jkgXqlmjhN/zV1vxfq6KKd4uyz5Em043UfNlMDvXlNgIdOiJLOtLGN3Ea9F
	Bj34j/dqoJibmDGSUn0V+xVrIZjMpF8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wizd7qBiQkJ1V3/b5YKQ6Ngd+nUqmFrvJ/BKOjDaJxHPzxzElgPYKd3AD5ZDo7nC1Ul17iXd9CS1VxASWjuytpdUOIjshmbqnKHaNaCA7e+H/U2EDftL8+UNKTQm6GCRURh26XJk/wa6fvTgX4yFP0nfNbmJsKcdNI2BE6DAknet3Q0X7RxSFnyncnnt15FVZnlMPydmOWto3Qq6XNObY98Gr+BVX/RGhBtbP2yNP+WDTnmWVt8szF7Yl/JQOwlbgOqILu39CKwkltFGkvIHug2HsC7Mc6vrYxDRm5/InXbc3VueJq68472gV9xHp1y04TJdfGp01MX9X1o5BLYBVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xD+Pvh4eETe8DHjrfq7a8bC2+wEQ/sG9UjQVVasxINA=;
 b=cpa86Dd2ocNWlO1uwKbv3matZMqAP7Y0mxA9too0tzhCPD00WMfTw8zcme33ccdeCHtIA+la6HFbyDgYClhXeYAQTn9Sm6c3EnQBOTCGoTCoWk0czuuG/ED2/K8B3m3sbdmQJBzHEtazV9E6ptu4BvKEgT9VJIm7OKaTL7MLmdqCK0yEczkXSMpi8HsnrWF/tLmOeA0Iu+j+HM1rDXGEPDM7zaPihnnvrqA8zTTi5jx2LP7Ch/UF+Y9nA5PFz6PuzkmV29VsDciHuSQnKlc1x4/Q7p4ElvmdQaIz1FklOdcR7dpM1TMkzE+NUHzXzdCDxFj8xKtbhE2TCjPTJlxT7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xD+Pvh4eETe8DHjrfq7a8bC2+wEQ/sG9UjQVVasxINA=;
 b=KcNDYk+Pz3KF9sBLsZrZM2Gd9Gu8A8yhmDOA7AURKD+dl+7TvL1+76uwLR9i8nIGp2857qwbXPMwmiWwq8ZrT2e/KenWLqwGNfuUIUBcP+WZ+UM2o1fCfYZ9fdaJ3GS2fHUu5IXWud9xjUMw6+heMrdyxx5hCeOw89pMon7os92/fxSHK47IJxWjk2N1NkJ6XgPbHk6bvCAOduvtV0nqXTza8tflXncYvOj0idihnuvI71YWaQ4NSHdDOaAtlQmSgDEmJqxswhMj9zBpX2uYVjpHjAqwmM4dLNh70B2uzQ+U9YoewnrKDHMiH4oWWt5GXZkbgGz6lAkJNQhbwnmYNQ==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 DS0PR12MB8020.namprd12.prod.outlook.com (2603:10b6:8:14f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.11; Fri, 23 Jan 2026 06:23:49 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 06:23:49 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH v3 04/13] mm/migrate_device: Add migrate PFN flag to track device private pages
Date: Fri, 23 Jan 2026 17:23:00 +1100
Message-Id: <20260123062309.23090-5-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123062309.23090-1-jniethe@nvidia.com>
References: <20260123062309.23090-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0028.namprd10.prod.outlook.com
 (2603:10b6:a03:255::33) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|DS0PR12MB8020:EE_
X-MS-Office365-Filtering-Correlation-Id: 472a69d3-daa7-4611-97e2-08de5a47f8ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j+JA5zzMfaYbruHYBT9D9glM5gS3T1YRSrXabi05Whza77lzXOM4AR4t3HdI?=
 =?us-ascii?Q?psSI9us/J7car8yH2tiQJpBjlFb+Awjf9gzQU4/o6X57N5/Nl38z2BkNbN2C?=
 =?us-ascii?Q?NL2BMJSbHll4JNdIn97UcVMrxt0UhezFBUG4jIDBEeJKBNyI5f273a6K82gd?=
 =?us-ascii?Q?PTXKsUYVHJvvrLQrzfzhtrRQ1HLTjIm0uTi+fqG+y96PJTF1UI3ZvlM7eaVQ?=
 =?us-ascii?Q?1ZRm/iFiu3UVqPXcCpSYsCCBAMNnkLsggSHN8zpZ4SViFMGsaM5sBoFy3Kj/?=
 =?us-ascii?Q?QkhuEKs85lJj+QiL6wlVNo/FlNgKw704Tyj8vQaQQ/Rpe8fmE7Kdhp3MWtmc?=
 =?us-ascii?Q?2Y4U76+rzKJ8igbqh8nMM3r6JjAN4twaEK4cn9PMuzYpxEZqhS9xkIJmx+Q/?=
 =?us-ascii?Q?plaKbTQ4CybZrQboH5J7XyMJ1lXUk2nwkDwxmd8LNu/fuqOBk+TNphdE40u6?=
 =?us-ascii?Q?rsUA/Ty54rQrOfXJs1pI21teDmoZxLYLH1ZpEKH+J3e5lILETlM/GHWaHM6J?=
 =?us-ascii?Q?TaaI4j68wR0sD9fn6ZaUzjceskP9Wgt0hxa19125pf1PRdveLdzdQE3+rKNB?=
 =?us-ascii?Q?Ouns19fYoS5CZ9dF7HU2oSEMnPD66kaoaHgSrYaXWNl63R1JPK8+cDjMPEut?=
 =?us-ascii?Q?nNUhIOuVZZ3ehNTNQ+9gfTLUQjgvUHpouHim5sCaiJR6OhrPUAkwHT9NnYfR?=
 =?us-ascii?Q?wKdhCFSMqfQNkq8ajMXIic5Zm/BAORJoYO9dDUtnXshJO6P9JveFB0BNMgsb?=
 =?us-ascii?Q?ARDNqjqEY1LLtEHjgbRUD1MJwveFxkLFb2NSgf0cXAd2koeKeAEJMSsNH3eN?=
 =?us-ascii?Q?6ErfmrAQrsdufxynUHgwh1NcoXLxhj50CDDKOs4512HVCD6JWPAtR4MEFF6X?=
 =?us-ascii?Q?iKroaMHu0ATHDPXUFazQOWH3+3d26PXY/enj+T4x8kXvjG4IsxlIC/BqOQ55?=
 =?us-ascii?Q?z9PHgmxG74KgDCDS1nR7CgjSkt/wA6ms6MmjhY7s7/kOqEB+qug02OX9KqNO?=
 =?us-ascii?Q?GypFTxKVapmQCbSM1NHeoE7EbMXLYUlcgCbWdIw2gPt0ludvuTIqw+Gge/Gs?=
 =?us-ascii?Q?P4Ak0kDL5QAEFkR4bB2AULH5qCwaG5cISyxPv65OXaCudUz2gEpPX9fOAqHL?=
 =?us-ascii?Q?koQ2BlIHlcjLiVgzN9OuUZw4M6Qee1bzRrMIVdSAvKlSrOAXR1BfI+R3nZDC?=
 =?us-ascii?Q?8o0EYmuKoGT9NL2/xDMKbCFCsD8sICY4m4u/ESQFxPs0ljqARnNd6sbmwVrr?=
 =?us-ascii?Q?aOKjw5/JzTcfmM5s+f/OKZW0z+WRe8RPpf9bs4xnoxuNlDKlIgA0Ju9p0HnU?=
 =?us-ascii?Q?w6f6e/M0htXWs2sfds3efr102AwpJ0mPjn5Jk9mbo+vnQEpiwhRp4lvzDbyS?=
 =?us-ascii?Q?qDW6v6bNG4gTtxXMXoqLnkbtxXNCMWIWRwn9715j0wXoMUrtvV7qJlCZ1EF+?=
 =?us-ascii?Q?Hd1rlYKm9ubk/49cFpDe317uzr/DxRn6r0vwPc7FGvXzA+2dGbkeaV8S6hV3?=
 =?us-ascii?Q?tqSvPwOPl2Et4VeGO2Ksenh+mN0WoNs9E1kiVufu5/ma2X1Fqg3+4nNPPD8W?=
 =?us-ascii?Q?7zQcpB+2warx9/Q3YOE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SV6nXNNkd+o7ImN40D3i5B6fxQMiMed5jRJB2TPuC2LHzUx6MrQq64T6yVVI?=
 =?us-ascii?Q?rMBA2Ywk6kUB0nBWbTwFonbM9GsIwhFoqJYELsAAt6zsv055j/qKD+4vAdxf?=
 =?us-ascii?Q?U4Aq4HNIHeiH9nYgsvDyKwEuPHuiyg728fd4ydjCIcjFc6ZfvWQAOE+yH24u?=
 =?us-ascii?Q?LoihPlAMYtgkx541FlvSVBiA9TqqYRWm68FeCBRnHI7R+H+wfWsXh0OoKXVs?=
 =?us-ascii?Q?lpnS6ASMg0ASa5t7V9+Bqhyi0XDhum6BNfQNwshyFTnV8mmIkRJ0MaTEhT8T?=
 =?us-ascii?Q?8QhNFPsNg+N7iB27RuWs3HJPsr7be8vbBIjmEA8uUTRsP5MlhBA+UUwopyUo?=
 =?us-ascii?Q?nuP/oCeoSjRT7xTMlrACzFzfIvy9VMUjxJBocMvdg2HlmbyG0oOMy4q3B+zc?=
 =?us-ascii?Q?sYQEnjNfBPBO0kmFzyPVvpJysHaDK21f+vbjytiIS4VV55FtTf5ZhUfYFM9w?=
 =?us-ascii?Q?OmDSH5x/Xxsl4dGHkoSuu0gEw3pJww0Ou3i6cWUwSbpkm2//zi/hYAJsTDd5?=
 =?us-ascii?Q?doPCVPnDOfBv6Y3hjK8WuD1CiM/ZIotPYD2qW9SfSJqn+YxchMrVJMRli2+B?=
 =?us-ascii?Q?5ewh8Q2b67qJR8+Nx9KuwGgy4CN9ROz8RnxpIPI6scxI939dpxWXtOhJJUz7?=
 =?us-ascii?Q?BZqXrCngdWAAVqK5jzwaMmJkFt5O5llYR4VkIU0pOg5WmCGRXlcHxiCM74cr?=
 =?us-ascii?Q?KRoGCc8KjOyaHGgPK0U0vNZKI5zCNMDueMOApIs+hAEI/ph5bwVsXTDsdF55?=
 =?us-ascii?Q?mp+0IWPgECLAArwY4UB9y3ol81c+iI8ih6DBzIo5fvF/Jqg60jmA1HpueAzA?=
 =?us-ascii?Q?AjK4kYi7JSRRt+cqGDISEwFhU4b98A1aUcd4a6nZ62s9HQE2ei/ReZ24FHW8?=
 =?us-ascii?Q?mtUdFz/WCK8Sqc1+jQAaezoM2qn8YNjbCpTsV4a2FrQOEMM2s5ZqUL9jdS0E?=
 =?us-ascii?Q?HjYLjnNYRHFfxI+171thUmTiQyt5auCRdGRoLIHd48ljrxYZ270Irp8JG/nS?=
 =?us-ascii?Q?JQqdYxcg69wgcR5QgNy/i3TFvPk3ApubIcZ3cBWjL2yEpGlIvtB6FzMinHOh?=
 =?us-ascii?Q?HaOujNfRqF6Mlank8flZxh72KVdUVL0kvx2XqWg/nHaD1GKreF1TBVuzVgT3?=
 =?us-ascii?Q?Z8LCsw8oC9Ey+9+we2Is7NodgciwOXGWoGzzQ4R0VxC9CWZ9htMpzfjFsH7v?=
 =?us-ascii?Q?UpquX5vEqHotPryX28cE0OSgmynR+yN27+nbWYA5l0LymJBX+MP3H+VQVT2L?=
 =?us-ascii?Q?7iICtIhd1Xw3wyKKeGdz+fENxVl4H2WPzsDYnwFUHZddGBKy0Dd3MiYOsMaX?=
 =?us-ascii?Q?bsrqDIYAacFoCQ3Fi+32XGTT1U04RUbqF7O8ppbbHFDeHcsVXVKFIsxH6cl7?=
 =?us-ascii?Q?zZqiMcMF0tnjoca5mdYKgeQWWg3nRtpkhNQoMDtZp3VToRUDdkMbOBGF+LoU?=
 =?us-ascii?Q?58FUz4tjcLRZlcouWSi6QNF/wJdyGCft2pQ30DdE4l9Cv0JgRQQ0Iz3UDCgf?=
 =?us-ascii?Q?REIUTn/C5vuOYLo6jKbEl2kPZ7SU2wFQV5nK68G17ZUMm/24uslg7smde8Jk?=
 =?us-ascii?Q?hJu5+W7aX8C+RVvD3gUF3mDjUuKTd6GUTvX4caunbDkdzU0f2Jfc3gcYyh9N?=
 =?us-ascii?Q?2pFMu3vCe78vex66uyJfGNuNPi9tLta+3+AvT7dY1LPhWBzYY3LDhFF/Hpv5?=
 =?us-ascii?Q?+SiCVgTHToELq26Egs9vVwBlEth3kqAlAv/w8Fm5DGkzXigJ/q0Q8eZhjIwJ?=
 =?us-ascii?Q?zUl71hFCvw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 472a69d3-daa7-4611-97e2-08de5a47f8ad
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 06:23:49.7043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2bSGOKxy5NX0Dg90VH5ufjdruBmFvoMcYPaeteRuQuDYOy+oVZQmYWoDkvSLKG+rM66xCkI5zCn8aa18i2AO7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8020
X-Rspamd-Server: rspam12
X-Stat-Signature: caiquzisxqbiyd79r47huzozytothukn
X-Rspamd-Queue-Id: EC9F620007
X-Rspam-User: 
X-HE-Tag: 1769149433-387716
X-HE-Meta: U2FsdGVkX19oD5S0YjD4RBFbd12wCIJW5yYcOwjt0RPoAy1MmFJvdfl0CwwzHgyz0BRyYTMuT7aUV8EYuaajzPPcrnEflEFVFyc6ITwl0QzwQZrmRwWBRDdexeE49PsE1/tCrMcVymE37HYQWAeOmqiHIYly884OK5YyC1osbLUKHFJrBwy9f+OejLldZ3ltgu4VN6N6rGcFEnkzvtjps0J1/7EBx+p/koPuvyb0242LkKDm7eLuYK/loM853QPJvIueGfzG3IcJAPdvzdnOGf2oebI1ZULpOGN3gbyLuIYv5Gl8d4hwdZcYi3jnKF9OUNLrkx7v+unt2EqHehPSM/fQeExOA/12Y7UZ0WGjOTpLSe06mFhVOGjvMdPK7cG0VV8i4xiAuIpBeKgSQV6zdt4/vTQEVe7fJssB7AxdpArIDF0sp0UzVBX+FPlVO79q1To+ws1eDKOW1tYxi6FHxmYOm9eceZ87pqxkYhSTvNSHl4CLRzJLg5Ov3ZLT55iwxQ+NK0fJ1582idn/dzWkwZRe6bGnhQYq21/e2d19WdQ2HRnFZ6FD3VC+aQ8Jl2kP/C0CZQO5IDVusF7z3YAnTdeeUsl8QBNzqobPgk6tOTlhaOluZTIIGEKcA7y4MCn4fN/hV0WMs2u2ixmYM+PpxolZUPnGIy51ZCtLsFqU2uFfCdNGfZ9dWuyzShqb5iUFF0rYS1B0yh++AF/FwzMMuB2g6r1kVqaOLbGWyEmJBV7fpc7DqMH4HIU87jJm/j3PciEPpyaIN73GAemTlwRGPjBsLOfrgARdCupKqVEE91xyWuWOIKzHn0ZkIHkfn4XGSwtcOM1kTrsXav94hhexwWcia4jwoIkeR0uI4F3uC3E/AKRfETmQ/NDqZYyp/7Z+BbJGM89rz2aGf/K/w31guGnKfnxdGnPWEhe2Z0OWkceIFmaA7D5F4+I6vuVpgcVHxP9ZG3yLN4+WSJc8+en
 v7XRLNbr
 kXTHbEMhSJB3Ke4UtOCZz1aIxhNgkh4v+y2hBRg/swJTp7/VGmYCMZhkUv78FMv9QEan3pGPB0uZe0qB1dyQhaOjYwTVpUeuSN68+COoiQkbR1CWWfxxFPSQJyvhpBBtIjBAKAYsjuNH9BXK2DkMEABAxzIVeXh3P0MSgY0cCVzztTJqQhxRyTt0ct3+X1FdmjPWqFZqlU9fUhESRETTnwMTyQbNbtIS1egyUkYF1zbI9A7EOwYakHrVMi3BjwzO8yOqyVdVZc/6NBv1A1Q+x4oK5/9q6iHQ574dfGnGlNxKLdRap+cEP0+E/EJsq8Ywafgi3xGnn0oMJ/wDE1wDnRg8pMR7fuv78qVSLMGfCpIoHtJ36AM9bPzMqJbF7R3NkZFEIhICvdvdkDVpyWGeRnsj7uTpwETmGADNQ051bVS20AfXm4rY95ZSu5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal PFN and must be handled separately.

Prepare for this by adding a MIGRATE_PFN_DEVICE_PRIVATE flag to indicate
that a migrate pfn contains a PFN for a device private page.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>

---
v1:
- Update for HMM huge page support
- Update existing drivers to use MIGRATE_PFN_DEVICE
v2:
- Include changes to migrate_pfn_from_page()
- Rename to MIGRATE_PFN_DEVICE_PRIVATE
- drm/amd: Check adev->gmc.xgmi.connected_to_cpu
- lib/test_hmm.c: Check chunk->pagemap.type == MEMORY_DEVICE_PRIVATE

v3:
- Use adev->kfd.pgmap.type == MEMORY_DEVICE_PRIVATE
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  7 ++++++-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |  3 ++-
 drivers/gpu/drm/xe/xe_svm.c              |  2 +-
 include/linux/migrate.h                  | 14 +++++++++-----
 lib/test_hmm.c                           |  6 +++++-
 5 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 3dd7a35d19f7..5478e41877e5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -212,7 +212,12 @@ svm_migrate_copy_done(struct amdgpu_device *adev, struct dma_fence *mfence)
 unsigned long
 svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr)
 {
-	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT);
+	unsigned long flags = 0;
+
+	if (adev->kfd.pgmap.type == MEMORY_DEVICE_PRIVATE)
+		flags |= MIGRATE_PFN_DEVICE_PRIVATE;
+	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT) |
+	       flags;
 }
 
 static void
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index bd3f7102c3f9..adfa3df5cbc5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -484,7 +484,8 @@ nouveau_dmem_evict_chunk(struct nouveau_dmem_chunk *chunk)
 	dma_info = kvcalloc(npages, sizeof(*dma_info), GFP_KERNEL | __GFP_NOFAIL);
 
 	migrate_device_range(src_pfns,
-			     migrate_pfn(chunk->pagemap.range.start >> PAGE_SHIFT),
+			     migrate_pfn(chunk->pagemap.range.start >> PAGE_SHIFT) |
+			     MIGRATE_PFN_DEVICE_PRIVATE,
 			     npages);
 
 	for (i = 0; i < npages; i++) {
diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
index fbf5fd284616..a8aad9e0b1fb 100644
--- a/drivers/gpu/drm/xe/xe_svm.c
+++ b/drivers/gpu/drm/xe/xe_svm.c
@@ -770,7 +770,7 @@ static int xe_svm_populate_devmem_mpfn(struct drm_pagemap_devmem *devmem_allocat
 		int i;
 
 		for (i = 0; i < drm_buddy_block_size(buddy, block) >> PAGE_SHIFT; ++i)
-			pfn[j++] = migrate_pfn(block_pfn + i);
+			pfn[j++] = migrate_pfn(block_pfn + i) | MIGRATE_PFN_DEVICE_PRIVATE;
 	}
 
 	return 0;
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index d269ec1400be..5fd2ee080bc0 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -122,11 +122,12 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
  * have enough bits to store all physical address and flags. So far we have
  * enough room for all our flags.
  */
-#define MIGRATE_PFN_VALID	(1UL << 0)
-#define MIGRATE_PFN_MIGRATE	(1UL << 1)
-#define MIGRATE_PFN_WRITE	(1UL << 3)
-#define MIGRATE_PFN_COMPOUND	(1UL << 4)
-#define MIGRATE_PFN_SHIFT	6
+#define MIGRATE_PFN_VALID		(1UL << 0)
+#define MIGRATE_PFN_MIGRATE		(1UL << 1)
+#define MIGRATE_PFN_WRITE		(1UL << 3)
+#define MIGRATE_PFN_COMPOUND		(1UL << 4)
+#define MIGRATE_PFN_DEVICE_PRIVATE	(1UL << 5)
+#define MIGRATE_PFN_SHIFT		6
 
 static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
 {
@@ -142,6 +143,9 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
 
 static inline unsigned long migrate_pfn_from_page(struct page *page)
 {
+	if (is_device_private_page(page))
+		return migrate_pfn(page_to_pfn(page)) |
+		       MIGRATE_PFN_DEVICE_PRIVATE;
 	return migrate_pfn(page_to_pfn(page));
 }
 
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index a6ff292596f3..872d3846af7b 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1385,11 +1385,15 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
 	unsigned long *src_pfns;
 	unsigned long *dst_pfns;
 	unsigned int order = 0;
+	unsigned long flags = 0;
 
 	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
 	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
 
-	migrate_device_range(src_pfns, migrate_pfn(start_pfn), npages);
+	if (chunk->pagemap.type == MEMORY_DEVICE_PRIVATE)
+		flags |= MIGRATE_PFN_DEVICE_PRIVATE;
+
+	migrate_device_range(src_pfns, migrate_pfn(start_pfn) | flags, npages);
 	for (i = 0; i < npages; i++) {
 		struct page *dpage, *spage;
 
-- 
2.34.1


