Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65499CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 18:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0549E8E0045; Mon, 18 Aug 2025 14:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 005E18E0001; Mon, 18 Aug 2025 14:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9B148E0045; Mon, 18 Aug 2025 14:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C58F18E0001
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:49:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DBE01DDF2A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:49:31 +0000 (UTC)
X-FDA: 83790766542.28.5FA115A
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7BA0414000A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:49:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aTcypXch;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755542968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m20OjFZYeOwycuVn8HX293tF3ivcm3fsGIruEV+rQ9U=;
	b=lT/D28GYxmpilL31xkXenIAKjNI9Wcn8LPYxnN345YHhUs/1cXeWXQP4dUHNjhCo1sNkbq
	GH+kSs2ourHf+X6Dy0Fo2KbEtLR5fxb1q3f4glRKjbO4XgyM5kf0VlzXNFH0Bq1KWUvFst
	zuuz4wRJ3Wm19VR3Wchwgt8wBckg4jE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755542968; a=rsa-sha256;
	cv=pass;
	b=8g1tZ3tN9BgbQRFBoA1J94rOT6E0buaVAJYk3jVpdADzG6H2yZFDP3AgR1rJfYVu+Ajv/8
	/c6sFXtYYyRwsCNXGnBhm8I2Q1urM396BvsDJaUzRlwIvTGhg5oKPADiDg70jy/3RDJww5
	e9yVCSNF3qXDUd4HJZcz2pzSAYZmac0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aTcypXch;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T7UjuiZ1/xZhYXCpNTzV3Hi3j/iiS3f3iEpLnfHHt4FyvRArsSS1hlBoTTk1Q6CD7EgWYXKcTtaKXN1H8FTxdvQmpBPt0SlaLl/I6WaGRBnOnPDjFIJDBhQp27KBfAJOMGScAvkY/O053QHlJoKr5a+jLi0ib3lSEZEuULrt8SHPho15j3dDjv2O14avyw40pMseDx1zFLqpTyoPo7GZgP9IFhXguUvc1/W+rF/dPRQFI6I9osd5gZSzZJjH92HqXpXeB8AM4UfG/CbnM03ddYDdh0YY454ugPFdr3K5iOMwb7RMmbEp+v8KVZeQhAhowi2ppkDN2XnVR9i/Pe1DgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m20OjFZYeOwycuVn8HX293tF3ivcm3fsGIruEV+rQ9U=;
 b=Nn4k/qo5t1pyOJ/H5A/QUWHzGsjCOwrB8yvMT+EY7yD9pCYzoZc5yJEXfN3j/odMU+q8kMuKiuuYflCZNzTM5oG02cuv3Uh3x+BHgzO8PF2GkfZiz3g1mS5S4bgx1Q4ucoO4O2X47h8rk0hphaCbs10/GGX7SM7Ha8CF12eZMiQ7Pf+v5CDJcGswmwmqJB+1cBXED5kdTofm1OftedTWO8H16StmD06zrmYSGuPBgQTpdYmaYEOX+s3br1odq6RPuN0bpqHpZLjCMRkimsbLgaY84/PHRB5MArXgsTqzzlo4dzEtfJBl7GN8ccUkQCRpgWz8c6OHG6QoWphImzAiPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m20OjFZYeOwycuVn8HX293tF3ivcm3fsGIruEV+rQ9U=;
 b=aTcypXchXMPCZiNHmDAaVP4A44PTF+fwcgli0qZH1J/J7d8JuLDYl9FmLkLQ1/o4pwr0e2EXBlCASzFCIVa2gc7w3vrFs1WubVgQMaHm+0EXWIBhtUt5F51Auka9qhzTSZDUZLsX5EQMe5jsBg08EubHdn/Ccn8NWSuSX5hm31og68u72Y+jxGrb5VdwYR8MuNB38098I7Z0owh1PYLnHJQr3SPII1bFKinZX0ONqLpigDUWAfaEcjylwXpdrZeIhtoL6rYFgafIV1V6+QFH3FKaURyAtsXLIk5II8sIrrMWQatpDDvAp2KjSCCuP5x6KdTV2Nl4mUNAPP6UtOixxQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB9342.namprd12.prod.outlook.com (2603:10b6:610:1cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 18:46:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9031.014; Mon, 18 Aug 2025
 18:46:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>,
	wang lian <lianux.mm@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH v5 1/5] mm/huge_memory: add new_order and offset to split_huge_pages*() pr_debug.
Date: Mon, 18 Aug 2025 14:46:18 -0400
Message-ID: <20250818184622.1521620-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818184622.1521620-1-ziy@nvidia.com>
References: <20250818184622.1521620-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0048.namprd04.prod.outlook.com
 (2603:10b6:408:e8::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB9342:EE_
X-MS-Office365-Filtering-Correlation-Id: e0b310a5-05f7-4eea-a9c6-08ddde878a77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oYRQB31UH7y4lqz5K1EF3Y7B/FZauX1lZAcTMNWtuHgTMGh2UhHzcvf10HWs?=
 =?us-ascii?Q?au/WRun12K5b98izWN4fW8SF32tSACixG1yZhT8o00M2RiSU2BrexWoTSOn6?=
 =?us-ascii?Q?B0CqgNAA2sV5jko7mGWvJhpA9FjzlnJ5dpcq7imUtd8IwleDMGwK/XmUpP3+?=
 =?us-ascii?Q?J3WzMLAZePutCFTkC+1eV3ImY6N+PhIE/CRvnD3F35Jq/rayoQFAkyjIIerZ?=
 =?us-ascii?Q?sD+3VRwT93T5nesMfOUEQXgRZrIZsthvhkPurR0YZKmkwgWLpPVDCJoKmYgQ?=
 =?us-ascii?Q?s1JscINp+nZFnvoJUKlH+IB9EZIo0MEYtP/RyLGMcvvkixXtia15iKLmnmfG?=
 =?us-ascii?Q?wR3KkYFPBYYkIR7v/tAKSmXEUybIEnyhluZabbwEhGft10hQVwleVYq/tJZB?=
 =?us-ascii?Q?LE1k9caYzxMTdtvEpBc7XLWcRE2Y3EWKuRaGtzxEwMCjL6nXYpHOjBQaxrbt?=
 =?us-ascii?Q?2g2oD0XiQw+YtNsKr0iHkI+IXA+cduj835kXFhsHyC/EXohTw1VLZm6FoYud?=
 =?us-ascii?Q?13eyTpCPMBXcovLqxa4ejZVN9/QlpzfJZBawQCPDJ48sMDGSP34XwZXk/cDw?=
 =?us-ascii?Q?nJRUqou8h1PY5SqcyPTy8hDLmapGGvExBUjLKIRHlf3EweQa5cfZXVZXiPrW?=
 =?us-ascii?Q?LVoWGAUegEn+3HUusJNGKe6a0ERC+hBtVrW0vbNkIWLnt9gI2AsdMUBwOhaq?=
 =?us-ascii?Q?0FIbZ4Fy9jT/Y37OBPDDZn+ofK+4aHLGABsqsCSv88PkWUFHidQCc6wgP7sX?=
 =?us-ascii?Q?7tHQNlyCGa9m5kHCqzqgnTmg02DEpEVehaGYqLnvHNd91aVYyrH7eeKaucBQ?=
 =?us-ascii?Q?mgmxJQVi1CeUqnGxE3wywv5+hbSW0ajngRrOGuXowlqk1+5bukyrFfs+SA45?=
 =?us-ascii?Q?9zIhY1z6GLCb5ROaBisBlZZqKGr3feHb3jCWRZUW6b1VMwuQLCaGHmjimOj4?=
 =?us-ascii?Q?quF8HLnch+gJtrhgxvJ4npscIBVPv9GqbpGgEmQe8jA0YOldf/+z+GDXR0ml?=
 =?us-ascii?Q?mFfLEQI3/ekGH5DV6skoXf29DepU9xCAP2F5IDk4FzpvdtjNK+dw8vpNJo2a?=
 =?us-ascii?Q?n74KoYKATMoxN3E21l9U87AKbrMk+x3aahgkGkzfkrGbJGzCVpU0t7fYhfVX?=
 =?us-ascii?Q?3uE7UAkT6yeYzq/Kv/o/cjzEKTiA/t7jwNxeGRNBuN0el6geCZjmHPBD3okz?=
 =?us-ascii?Q?3DbBLuFWQr3wOtMTg57TNttIqG89XtgpAxeuwOOzeohLs3IFYXCIIgmxc9rw?=
 =?us-ascii?Q?fkh8JADkQ7ugrq4QjhFliniKc+/cJwNoMbCpxBT/GulcRrtcLmCiM3w3PsAK?=
 =?us-ascii?Q?Yfy02yhhz7oYlY7ko9xapBVGqVPdVOPSRsSaCW9RxYqKjhoNuL7n6tpat4h7?=
 =?us-ascii?Q?nFX9VMCaHykWmj37XLdeHcfTKZTmP3B4HgLt1TkqexLrrin+nw2v9lalotZK?=
 =?us-ascii?Q?y3UeOQYxbuQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?758pSkuQrBhzeaGfLivuoPaix/DPP0pnJ9PEdPtZrqdiFrJknjsdIgem/TSh?=
 =?us-ascii?Q?0Wif19mqU50gUsfJ297Ec/kySC/J3KNXgzJI0eUodk65kQlNivHAux/brGAX?=
 =?us-ascii?Q?q5NfKRCX5j33v1tIFB9goICgj1DDu+MdfU2khYKfNxZFjyv/VCJcO3IT3B/J?=
 =?us-ascii?Q?PfwF1cKO1ZWys+AutlM0kRG1p+CbK/E1+unMYHHyTBe74a9FWpTvGlnqh3F4?=
 =?us-ascii?Q?o5xKgF/R34by810MyH1xatmk4EpjTgSC8ueLURxVEifzg2OQ64FG5Awo8JkA?=
 =?us-ascii?Q?TJMIR5JtEMUTWeY4yD140D7GSYkEQsOypZqk/BiAxvayyUIk0yQOiLScLGaS?=
 =?us-ascii?Q?6HCk31lAoCVMDQmWXEGavoS7VgLvFl2FfHEweyB2ziJyyA8upRrJaFrAxupa?=
 =?us-ascii?Q?jBqbVl1MgLTRahnW2edFboNSkMwYkaj/VGqm/zPUXpydubEQOkFEMLcoyGTy?=
 =?us-ascii?Q?1R2mFyBRd10m3EfPHK6r304rQzZ3x6q1DrdGqGupsxVcA+FSX4cwqvlblyNx?=
 =?us-ascii?Q?gxKzC7PZdZuDRM1MaRCMx5ztKiy9suCvTciiqKIHlHwCf77HZB88BASR/+IM?=
 =?us-ascii?Q?692RrI+ADka7285zJ8xhm0GXNb55YGQ8fMkrsa/YzR/9IiCKulE6ufxMe8J0?=
 =?us-ascii?Q?NR6G4WRuxWXzzoOHJVWiZl64ArLwXfidOFz45lQTXXLnN8ezo6m/j2FEQ9Tp?=
 =?us-ascii?Q?Kdfbu90xa5fgOZXftF4CNSzjd9U9PhyVmLizGzrEq+GlN+iBzGjS7JCaMCCu?=
 =?us-ascii?Q?Eb/R2oDWQapvdQGPMW0iBirYUCwhxxQk4EhWRbKAD7VXVrZK8uPwnNhnvJgH?=
 =?us-ascii?Q?ubga7aCq8+z2viaopkMb5v56E0gUDj/Ubm6nj2ikYN4qJ0x1cXZsj46YwENH?=
 =?us-ascii?Q?oby7dvrN8aRaq/nTaTcgghTq8ZR4bNI4Py1DQeZc5qnOmFQFLlTN3Ym5sNpD?=
 =?us-ascii?Q?psN2bGTYMwK8aPdJe/uWiDz0Ml1yuWaIkhtfYi5SeFxbHqgYMdpwg/PEVU3Z?=
 =?us-ascii?Q?u0gu/VNsJ3046OWER5aPf2xWUFKw6ruBzSpHzIWkq/JSJzvDR2wnYTg4orD5?=
 =?us-ascii?Q?oIjTw9u3P2Uk3D2WCr4cNSd7S/XkcotFa3uOJJ0+ailo9ReS0JVPqj5S+oia?=
 =?us-ascii?Q?aMS8npNocoWG7dsw4lO+4lgFkg0LhRi4WUgGXMviTVotHcZV05BtkTtiJsYh?=
 =?us-ascii?Q?jQB2LVati3/rIZZg0QjW/YNCOXNdCwSBVPP56ivgPvNOtyWyUjbdBRIkRXKB?=
 =?us-ascii?Q?lqXY7sTsWIJCsKuGo843748tpPNumDkA/3ghcqCYpjEea9YXloBsyHsjfQMI?=
 =?us-ascii?Q?4Nwt03wNAvDHbhru3lgYkUXs36luE0osnwZpvE5Is0Td6y+cBMoiT20PMUUR?=
 =?us-ascii?Q?BngWjb/bosIpeqxPy30cHNwH3v/xRWrfFWVchuUoPu0jRTJOFgAu7tlBwEqa?=
 =?us-ascii?Q?z9qEBm62GLf70FD1AeraOvb0xdbk4AZ14az99uxpK3OJNqTD4h6rrOr7mgDP?=
 =?us-ascii?Q?0sUBAac0UnnrfewbR3wFMnnuo1pB/QSoj6AF1ALxAVaUBIC4h9X7SAnrnQDu?=
 =?us-ascii?Q?HQ6HKjx0gchVXdtF5n1S6tWAlA3X6aHLSctIPI3I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0b310a5-05f7-4eea-a9c6-08ddde878a77
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 18:46:28.2658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1wcYbTlQjFaMT1BWjJaw/NSNF9cqpDMOzgcG/bfl0lFyvLHI52nR2uxpkda3UEVq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9342
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7BA0414000A
X-Stat-Signature: t7rpm7ndrzk6r8cbbqh7cz73mmzf3eau
X-Rspam-User: 
X-HE-Tag: 1755542968-470241
X-HE-Meta: U2FsdGVkX18Go42Rp993VjbRnSnOGzh8tteQKJS1c9fdenfSAVgmzj9bLEhAyZvYzuHJyjEDv1WJEpwPnGMA94QwFjFUZCc3/pC/QtjxfO8UTcqXGB4YaAvxX7LNRux+NpRHSFLEmDcpPx5xruB15q/MRdb9y0sYtIEsKklWFSxooxMzIgxMFSBEdSaswPzQHroTTpOsdXMqwxqYeJZnOzEDrkYaQ1XFsOuX8KzLJRtfXxm/0TTXsvP+uck/hKgOkOiJm24yy5+nXFIySRaAm/r1bejrU2bhXlf87aME6zq1J/YlvzCqRpV3tr1V+yUzmGTXPuBRMw5o94FjgcITnj3zL2FGTmFVAVtjQnAoQBy2dySWooddU4YBJRMPyMJDXDHNbrWl6XR9NMB2K2dJZNZHdFyVJiu63l1ji1XhwsbUrDw+38Zo7r4aOZSoK3DdlebElvK/QFQ8xlrTkdLShQQCzH6sbEF8xuiHULnU9zg1m1UWnyMYX54xHTADB0Glou3JqnCxJoHS96SXofKJn/PTlUO7+pP+MeY9D7qhoyXDAfGLtOBe8SVN0Ypg88MnPZinzTnjL2Eq9ZoBOmpCaexWe+K3tFuufq5aSZ5XXmNjKXRmFVHpK/N0lVmRe11m21UZQasvqmmk7d/iTqTEI1eJpAm5qppZttUMrou70ky8rfDUH7y/+CXtiSojMxI0WlIe298JxEd+CfRtnfGpcArJO2gULoxrH+9Tmh0Qrf6d+5PdQAzD3XJZPWapaeqM4qJFu0dOdtLE85VOa2BuipYp/iwCiZ1pZisd3ZMmpiS7heehFc9KtDBTCC0RZm/JwjVqDiKBcgFPQ7WHs94X3p3T90yJysw4S4D5FYZoPGL8NF7FD14dEzFl0aY3Ptd7bvMUJQuzYsRQFNB9VSl9QoePpkIicCs5SnUwr0/pVABL5NUvW+5bVwyHYHGBdftaak3mJ19niLQUzmTV2+I
 shJK669F
 MFZkFjKyr/47dssxYFjQ5/H0rWz5bKWA+36Xr2udLIZDnI+D8n7Vnm6buadT3zf7yNlIUYMbaZtgyPZurOzf/5psQpim6bJhIrsUFSoPpoNZD0TZuV4mU6yWSwVNZsEKn0R68BNuE1wQd+3S25bun4lVSz/opENKr5+SOLGn+iON4jCgAg2zli7sK+EVU4hrjnGVDPqtxXwsuHa8unfDMl77yL5l093zzp7J2sIjP0srd05mIrAwKpc6wI73fC8fNpXiabyNKNFaZXMrrQo5CB5YhinFV2HApfi3AL6sX/0btVtn+djUduUl/+cvje6iLGi0qtEMjlWrXptiqOgmNVSTmSuyOa+t2ESdbDNMhhF9NJkw+ARaXuuoVUmMwPCPc/rFeE/Qzp1W8x+rgy3wkMvjL0LpsH6g1mPUoxI9c7KhvMjF+Ebn8sSOLH4utoaeb77ckFIK1/WUsFfyhAeKKhwXJmSJZyf1aFZ0EtKNtrhvnLX54b1/i7qg/JFwn4YK8O/1xcc2vktdo63LU10wMbZxb3uBTSQzvGhsTONIn4kBrYhLikts0ww3GVFb480dkXzQvdVB5II8ZrbGi9ixxRf0vadOKOOyDtXa8FvHjA2x82TIkU4hmBypO5dTi/aGARndlIS6W8LujQWKwpmBlhDLinkiggPOXJde283vEnfxo0PFIhBWjJl2SXPM4CnhrBLA+YphUVSyGe6Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

They are useful information for debugging split huge page tests.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index aac5f0a2cb54..2a47cd3bb649 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4320,8 +4320,8 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		goto out;
 	}
 
-	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx]\n",
-		 pid, vaddr_start, vaddr_end);
+	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
+		 pid, vaddr_start, vaddr_end, new_order, in_folio_offset);
 
 	mmap_read_lock(mm);
 	/*
@@ -4431,8 +4431,8 @@ static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
 	if (IS_ERR(candidate))
 		goto out;
 
-	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx]\n",
-		 file_path, off_start, off_end);
+	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
+		 file_path, off_start, off_end, new_order, in_folio_offset);
 
 	mapping = candidate->f_mapping;
 	min_order = mapping_min_folio_order(mapping);
-- 
2.50.1


