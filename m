Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B829F99C63
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 02:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B8816B017C; Fri, 17 Apr 2026 22:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9690B6B017E; Fri, 17 Apr 2026 22:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8323B6B017F; Fri, 17 Apr 2026 22:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0E86B017C
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:45:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03530E4400
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:45:19 +0000 (UTC)
X-FDA: 84670135200.02.CF634F3
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011053.outbound.protection.outlook.com [40.93.194.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 28F94A0005
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:45:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Owc/ifuV";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776480317; a=rsa-sha256;
	cv=pass;
	b=euu7O9oXdMjHm3VlW7HhpXU872MeNjJWiq+wPoSY+AJYjwD3iJu6iWpmqtSfpICz1k955F
	idsFNucvi0U8SXX4twis/4JTEss1ipBCroi8zTvExSpU/7EWrn1DRRasPggphDiMgP6g1G
	A/t53C8LlWXj+Hxxim6LPlUTAXFVNhM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Owc/ifuV";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776480317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r617oYGbRhQcMzcfDyU5E5V9AAOVEsBjpi/q2Rr47AA=;
	b=4rQPSmbNvzAXQXmN+26BhpY7gpLE4wMXf/TK0KFlap0UvzswFdEhNaf3Ke/l1CyiEb15H/
	tUJt/f98buU5VATfLJIw3hZyeOKhLhk2sqSBouNbgQTm+VsS8KDo8zF7kQR9vBuxyntAiG
	0CB91G6pHPDGL82SiRItjz7IpKLWoMo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SJuAmyCBLiORbGCpr50GX4MudeizH+RgvVKqsWm5h5ZDs9U6zxad1jwi/+Y+YVoH6FyoyKH4ACnPhGgtzG7I6MUepVljhgIiZ3Q9vGpOBZ+jeJpF30h0ObTRbFFvOsFgBkaexZA+Ug79hPMwn8m9GZPkHBsc3rjEw5yy2QhM8nHig4T+Anilf4DeU6ei0raCAsoaNO/LVp6SvhupURg/xNjKeJQhycTd1SWRmQD2EW53Nxam1qltCCknvpAqya58n/CftLFsOm/3qhxrVDWooyW8K54TOfO+gcmlRC2AvoXrz3P0hV3v78VxSPqcCXBYGNmmJHAKUFoau3gmomSYZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r617oYGbRhQcMzcfDyU5E5V9AAOVEsBjpi/q2Rr47AA=;
 b=wUxJVCSfSogQ/vzrFmbyDY8KJcD0p6BSR1JuP4OyTMKbrl9lqFZBSMMZxbuk0fYN5XAMZhlHLbTnCBOQKPGplhefB4HFEwJkIdSQPnZ9viO5/Git3MfEu+G6slMZN6poeQOiHP6b/MEJNq+t03H/BCDm61ap+DeRokmCLMTuTBCTbQCiSsIQ/v9KcQBbd1QDIEepteEwaQongvi9qZFSimjSYJHgecJzeyQZoQyJneJ8NUGRyP3Yu/XAf3Jtd4pRgTo998l1E6+I7YVPC30RL5FAVCzcoJTY5TIquUkz6EqDL3vl2s9kcuFIC9xtjRQQT8dsUObhTya0/r2Q8l9xkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r617oYGbRhQcMzcfDyU5E5V9AAOVEsBjpi/q2Rr47AA=;
 b=Owc/ifuVsMzb15OsMHrYv8vnbofDOC3wLW9kJeiaKBLt2cafo0gCNp5+t5e3JBeQuu5VSuDWsSKGUkyRD+2PPvtzEQsTMUA4WxdgjgUNIQDi7th/HDwW5A9H2rBHgrUOJmA+OkM4karl4Pfmkrc4vmoGxO1gqMRSeLvfQCGeNXUU6iGcSQLTVCbuj94VdG8idil0bLNYbO1v4wtwUo3iFd9fIPVeodyw/feDMQDVvEqUp1a+4XVq0tRYB0p7jO7VYBdYKorRrTroadm9lI8gpeM9lM9wLTaS++Pe10LsSnS+B27VYcZoqBp5l9yXWoXD9D34KLP3cfzwkIVeluzEiw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v3 05/12] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Fri, 17 Apr 2026 22:44:22 -0400
Message-ID: <20260418024429.4055056-6-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0164.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bc8c5cd-a318-4001-596e-08de9cf46fe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Do8In7i3cPsVK9VRgv05roH4helfl7md5kLujgrmBRd4Vyj+sYG8cNTHupLxMVwkBsn+UllM5/2tVu19aP+eYMl1nfxwZ0ULZwuPUOOyrFtGt5OW3Un4l5ly4boDoGwzGIhEi4Q6lRRgHcPhPu5SmyMRH3/OGV2GxMwgQM7WCCjFzbYFjVu6eN30Rr/DyN6Kk9yefNRJicvxBUZNRlwOO4mwsFSDnBvOoZpooHbYmZiqGucEOlAsG+/x87SOqK4+hySILfBV/UuLU16nEPIQvOHNYl0mZEnI4v2iShbyX7BurszEuYdEMlGZouuH2phbqZAJoZPoOGu2taYY5OtR4ARUo+wMNo8TmATQBGRanHQBGNhq8eo6A4cJsNEDGlRwx8Auyn4lTJAurD5suflUFFwxZmIKi3PMRo22Tr+j9Mj/XNGCrR86fkYmtP2tbEUjF1GVlCWTDOsdtlr7/nqvAv9lF0O3uTdJHntjHGu1Zju9mGhmYxd1hJ1TfjH/OPhR9JMdF5j8k0KIjD6nMKvC0JhAOVC/wvqhzDxyjlTNDEpWfRMzoOnL2xp3EmmE+iKpNDfwFkotaFxAlsibNzdiWkm+eC6lEbnvINsuL4+HT1jyBtJslEPMq3mnOCuUz7j01qgjQfZNxQFAbmdnOfpFFIsX2V7yTMgXHWhIy2A6MkwsqFfHErcLI2awsIN69SQF/5TEIlm/gY5ZeZhyCqrMZki9WMV8NYLxT5nYblrNrck=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lSpD/HvpsjJIKRFkSfkDd8+d1YIpCrdlyENhHe6kCTqjbs91uEk4YcvzQov1?=
 =?us-ascii?Q?4nNdJaO+1EIeuYhlVamL5yr97XJWKlsI1RbH5i9fUyWaZ281MBt0bK1PqWhx?=
 =?us-ascii?Q?U/Azdl0wD5iRccboF9SSI04RSIuMySNUMfzzNq7XcRM6y2A8Iv1NFSVKd6S4?=
 =?us-ascii?Q?Mr1yAlJXeHbGrKLdGx2z4DlVZF1mIvOIg538qDyltydd+mK+yvG8D0dbpJ/m?=
 =?us-ascii?Q?xUpVeq0ngzv54Xh9hh+xEIY3aeMD5j+rlTtxy6SO5c6SMiU4VOClzVYdHesk?=
 =?us-ascii?Q?6PhgtENyPBAqrndRPhfhB/0hjw2INQb7tPY9w791qJ/5nr4nSgKIPlpnyI03?=
 =?us-ascii?Q?qoAvlbcksfa8E/bycdtlrEa+zBTwf3UirgzzER3nxZzyJHKrJ1JEqcVTxdMS?=
 =?us-ascii?Q?L82ucerkFZH36e44tay4y2XPguGBW9PHu2MSII4+1iIOr38xJaxSQ2abcyUq?=
 =?us-ascii?Q?RnArg2EkTliaLq0ETLhzr1HzFdV9WcLaI4ZL/sp0CMOQ8/H9+AzZZGbc1tSS?=
 =?us-ascii?Q?zNc36p0ZdLsNTyu6wUYpENX1DbS05fnjCBembkSYKbgtaqKX1eKXEBIZGcur?=
 =?us-ascii?Q?XWs4VqE4geBJVXk6e8CTfoozgv/XzImeMJnDDHAExBpBAwV7P5/Hejg0Tidh?=
 =?us-ascii?Q?tui32i7YKKgf9uoFsiHm3bWOKPVAUVEiulS2DhTSv4rYugsteqGB8c97ESmB?=
 =?us-ascii?Q?Qdtbjt5zIDfhDDg1R2EiEJpAcs9uxkXgW+XGKKW9BO2lesfJv1HMnG0QIVJo?=
 =?us-ascii?Q?wXpuXZiEsWd6Ez//wz3B+zlIAXzk2D6e0W1syFQVyHU7jB8gbUzfwqj8zihL?=
 =?us-ascii?Q?D2iKK8YqwjE7Nqp46od2EZicbxBI/wEXbWnU/FonTufrId8qjVu6fZ0s8/Hf?=
 =?us-ascii?Q?7rEI+tTmlL8wwq5FvuGFaAoP84N1pSvRlpwC6ocO0ZjNW8IjC4l+BPO1X1nv?=
 =?us-ascii?Q?XH+tlGkwr9DRhxZ28sP/9ZUOJo2jTJpk9QeESMjB40g6L6eQdxGxtAFzGnqg?=
 =?us-ascii?Q?HSAQH0wnbeSaG8lIVPxKkg0LSCuATSyWK7dXfcADZpgTBwIZfIxnmOob0ABv?=
 =?us-ascii?Q?IPCSp29dSXWErtzxTQHaSvA+Cg1t7rHPgEhJi8Bz0F6ur+esCsi4bMbWmZgH?=
 =?us-ascii?Q?DggpkAd8Y7qmERHvx5AWIgBgdyoBFuif79XLceIMRgR3yLOpB46likwCuNYu?=
 =?us-ascii?Q?YuQYGogjjB4zfWRLxcFsIS2gRlZNnoyCqXGU5lyDzi/P3KipxtBIOa/OpdVy?=
 =?us-ascii?Q?9Wg8HW9XGntpyc1b6Tih7jYBps7d3F5BMa6u3bJqJ7MCga1umlijT37nh7rk?=
 =?us-ascii?Q?BHQSmaUvxisjjMyCskGQ22dZqGOmXAqmWTvwJkgBgRE82NZF1eWVGjQCfRq0?=
 =?us-ascii?Q?kfGjqVBTNzGwXdoVQm1QTgiW5k72ASst4MKbbZDxE45R8Qks0IVT/Jhwn6c1?=
 =?us-ascii?Q?GWKYmqMxfknmh3wYP9k/tUJ9Pksrif6Mub3gS9MopF0pPD89YxEFcQHVy1FY?=
 =?us-ascii?Q?ME5Sy2+CCUDm95IZrSsjuwTqrmeF07GC5lYRHGcr3KvWdEqM3EzvxFvFiPJs?=
 =?us-ascii?Q?KRDxi39ZbGuG8HjZgH+mVhbFnCnhkBCgaEk4n/30h6ZE1gHKVVH0FsUqVIzQ?=
 =?us-ascii?Q?hJ0ao2o4HQyJ49IGR3vj31UWZIiLrA3hbxGkVmA2ShwVDj3/KzophA6LzpbN?=
 =?us-ascii?Q?LpG28XvJZbz6C5HGZFSvN7h3YLeak77sGs8WoTG1EieQxTnX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc8c5cd-a318-4001-596e-08de9cf46fe1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:39.7183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCV9mnfDjbK4gfCyRENIyApHlBoLuUq+heDrfyrpD26EH2XZENvPclistyFsIDkL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650
X-Rspamd-Queue-Id: 28F94A0005
X-Rspamd-Server: rspam12
X-Stat-Signature: 741hhkffoym7s66qgmrhuheagj9cdo5t
X-Rspam-User: 
X-HE-Tag: 1776480316-561045
X-HE-Meta: U2FsdGVkX19YhuT99rblyGP0MN5DtG2tsbTzi3Vv8zFJ5HWmoUh/TCPjTPZK/BArVuifWCP/Uh4S5o+gKwkBK5kPmH5Ga3D2VJzRwo6HBLFDuUBIiPLoDg8IIWyCE2fidYgzRwsa8XB9KHOuOoZcZeRQ90LNNnfwjwQxUlKwnHhqGmdTjUaLa7CyT+R1Yt+G/megM0N61mBotq4mUXWGTXvaXBQ5PakocM7nCEFrHDgo4X2ReP3dXw1tssJFrqlpLz7yvT/o0h+yAZGsw8lQ5qRl7scZ1Q1IcTCHcxh3upS4NJs9RwL9jM8QvGqgDpzMqzxgcobCtTUdn45dOIDDFpxNEx0EHU3o17MwkJcQ2iN/OWfH4iuQ0hfiS2zWrLebDGKCiYES3FL5TBdZv/qIjXUNZvko5fsCuWtOh5zULNcGWV0t7qT5QIZ2js0MIgLBrLZUUw4R30zeXyUqBKZF5+w0ai1Ad6XT/nUI1FRLdo3qEAxLTgugqcZcKYrj9ZtX3ES9q8g9j2WYQBapHSeNKykM677gLjNyk9O+NpfCyYb4xZ+p7jPCnELGtIUA1/n1D5amcijBdsJSUPFF7CeHZdeEgSUgZ0fOclDY/8RokYtYdR2/vsJ2YKIK3k0DZ5Q2Xyp3gKTTtOlHNuPzQMAkLpmLONm/949XpK8y46EsmdZGxJpWtkMec4zcUveZYKzBdxYPOYmvEa2PASFBDpmE6jQBroMauAN3XtdC9xtADmcyNpDcVT5CsypCWmsxMIb+2a3cBn2YJwaGEV2E8NcsdleXY7zXtrnHD74lRuh7OEy6Ivizh/HQ9MsC4dMt9MXYygUKDOinCL3dUvKierE6Ild3zM3SBNnxKzFNtlIir9Oya8FystN/RdSYih5RrbyPCBXzJPaqe79KZuXxgcpjmrzHwiqkVd+kyUHgVqbeEAeovcWqTW8WXR37wHP825RuZR6Ac97Xd09kgqC4+hG
 8y5Kxbld
 AAz2xUU1fADGtjW+l696sFSiJLAnAXAUlxWh8oKaK1s9eEJGJaSzFvegdln7W8dwTrUDcEyMZHwAisA61+KevkPZ4ymzaC3PW1GpLqpetVQaoW2Y3WamliLg77vdUoQMkn6tcOW7T3r0MTZD3YzYBlesmccjq93qY//FoSlBWq36RZXQQcttrL8VXF2mO/YHIHyxkIw5fzaFxufPz1eTWOD+yWqbfkU5IlOrvO7gbLsLJ8h+HedZp2U/b+dzMxiKFxfiVpydF65MSMzGYw9Hz3sByG1M359Bmfxrrb37MpQd8Xju9OcQhaGoT0OfDWg6g2lvlEtSOw3kef++alPVAQxAj6u4fPGK8D/FUBqZ3g69zIVWQ+nDyeywyWGSZs5YbxfnfzhGmdeTzzavQOBYivkkAlPcVvn+DecAt4QlEYeyv7+yRpuqchUKlrNlsWkYcMieq6N3Rz8EqghdaY+ShI+0zkPB/V8XjwTRr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
support even without READ_ONLY_THP_FOR_FS enabled. Remove the Kconfig first
so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits remove
mapping->nr_thps, which its safe guard mechanism relies on.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/Kconfig | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index bd283958d675..408fc7b82233 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -937,17 +937,6 @@ config THP_SWAP
 
 	  For selection by architectures with reasonable THP sizes.
 
-config READ_ONLY_THP_FOR_FS
-	bool "Read-only THP for filesystems (EXPERIMENTAL)"
-	depends on TRANSPARENT_HUGEPAGE
-
-	help
-	  Allow khugepaged to put read-only file-backed pages in THP.
-
-	  This is marked experimental because it is a new feature. Write
-	  support of file THPs will be developed in the next few release
-	  cycles.
-
 config NO_PAGE_MAPCOUNT
 	bool "No per-page mapcount (EXPERIMENTAL)"
 	help
-- 
2.43.0


