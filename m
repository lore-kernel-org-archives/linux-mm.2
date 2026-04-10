Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C75E6F36BA4
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 03:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DB916B0089; Thu,  9 Apr 2026 23:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B23B6B008A; Thu,  9 Apr 2026 23:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1216B008C; Thu,  9 Apr 2026 23:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B18E6B0089
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:24:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4BCF140345
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:24:01 +0000 (UTC)
X-FDA: 84641202282.05.8AA6BB5
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010002.outbound.protection.outlook.com [52.101.61.2])
	by imf26.hostedemail.com (Postfix) with ESMTP id D7E1E140003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:23:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=S68G9wHQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.61.2 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775791439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ywfFR5zYQTMTN2u68wXONnU1rW4L/0c0JjM29ZLB0pA=;
	b=l9qFVACPego4luTK5SJ+XOo43khPC0G77CY6QCCdJnxdVhRqyOvtX90ucuoawvU+nEI5zt
	qgyPGqEKlhFe+z/RBd2xtGgLMBrlsW+dkaqjGrr3t1jFhwtVNTiAJ0KJUc1gdx9W05Ti1E
	I24o2jn5juPwlKMoRezSZXR3KofcYWE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775791439; a=rsa-sha256;
	cv=pass;
	b=73CSlBn5wzd6ls8IlcCQN/8Usrr3jhLnMd+0+58SsdXsh7x+RqvXFTp48gkC+ofAsuaOyX
	9Y8b+D2dlILeQVwezooDFS2/kxg+iIxJlga4O2yjbtnhzs/sHjK81skHK5Ccx6/tcZH6yA
	wv2cCzUXbXydY5c5wjMKkB2ORr2bFRw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=S68G9wHQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.61.2 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P16u1yw8+fQ2SmoKUF3fVgqjt1UqY+b/mkfRDJuPaEyDttTdTzBhJfDNnxSL7VmeU2oIF9lzrbfQeamnHO/ySkA/Mbs16xCGgiKQ/2FzkqCF7nR2+ILwSXWhIabW6JJfvlloHHni7XZU6sFY6N1b6yK9VtkAOIJhIOuNzqQ5m+tZ6HukZQvDd8N6Zqy+cgmUZWUhDBded/BoSEdb6xP6TXdOVPN5aDg8mNZDYJogQjKaqs90GBb9/fIR1pV3w8/KG2lKqe3rJgtX8RgsOQJDplkZN8parQczlaSlrgyduRlxfrIPohv10yETBERv4yBWBrCilATDhdl9pbF71u6YfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywfFR5zYQTMTN2u68wXONnU1rW4L/0c0JjM29ZLB0pA=;
 b=P1JxBt7Ea2YlVesLyzaUkHEv3znEydX09vXT0X9Sk2UM5T/i1wgIKkWAeRr6rH0XbeftlKH7JjObngc1aEek+STIvnVHrzOafD6x3g35Gblw2CYGzIdt++tEZl+by1R4cKueYHzJSfsuQ3BuRXz+wrDzKT5dG10rm+m3vurbD/C61P/sFaxw7pisf/K7LKmQR8YINMvuYVbWDcO7EFvx4ItUwNXPj/R0mYv7aKO+Y10mJ+qbs7+n0dSoZ4IZ5wOkp4O6B4Q0bNNMn+K+c3L52QnyHiDRsklxTBirW0yufaKEz1l7a+7QQ8DOQ1uRksIVz8X1RowsTtNXtWp/xxHoUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywfFR5zYQTMTN2u68wXONnU1rW4L/0c0JjM29ZLB0pA=;
 b=S68G9wHQXy2tkl9O/l3PKqZVaACvwBnj3hm0vx4umVqvH9z4tLygFKZrkE7Vix9CEM64wwkreGCsUZPVSMHBA5sOLbCJWyQD/ojDiMp39aillOcM12BYPm2i6sGWsrGVPcAhBxbYQAFnuguF+xXFoE+/IbuFOYL35O7iZJ/7qEQ3QmJPZ4CjASn9A058CcbScD4cAXNxR+aQWzrRzaV+7LOVNcBExzy+uetBy39tGG9c3Q9JkyEBUtKprWe4MYaBlU2m23q2BRKyX7wRy9yA3FiYNx82bHDmOOhJlx1/0/qRLRFe1r1pJr7gzI/JkmF5aijF44BVADp4Y2IZ0OfwOg==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 MN6PR12MB8472.namprd12.prod.outlook.com (2603:10b6:208:46c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Fri, 10 Apr
 2026 03:23:35 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%5]) with mapi id 15.20.9769.020; Fri, 10 Apr 2026
 03:23:35 +0000
From: John Hubbard <jhubbard@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org,
	John Hubbard <jhubbard@nvidia.com>
Subject: [RFC PATCH 0/2] mm/migrate: wait for folio refcount during longterm pin migration
Date: Thu,  9 Apr 2026 20:23:31 -0700
Message-ID: <20260410032333.400406-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.53.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0070.namprd08.prod.outlook.com
 (2603:10b6:a03:117::47) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|MN6PR12MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a08c36a-17be-499b-233a-08de96b08cab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	oHQlrSRACNyoWqz2oNg/KHjixeRwqs2RKFwkpMolmJNDbTKebSRdw3pHUbU0Ra8OKAhaUD8+1Iand5MpsEYn33fKuur3DUaPrSLuRH2lZE8WgqCu+WJKuE3miZKDcynsTrM52BUoybDl9mnr4YeeUNd4U/faE67LI/i1240RavQk7FDkhUpj5Na+d7RsFCjV3AfsxpdH/Hl6A68GquQEY5kd7e8sTEDmyMkmXZL35A7M/a4KsMSAapORamY8uGUGntzyk/wqgWmzCnkFa/C3QkqJuRISPPJA2z+I+NhNZhlbmqA5aQ//zeSQzRLQ/ZwVHN1f5XnGqLAIdkQ5vvSeFzFIteX2G9ChTWkCSOgy375MuWh61vQ9J4H/b30+qQX/Hwe2KcLSvjeDUICpY1kOJoofvXZ2jUXmFGf03DrbgtmnW+hKup7065244bXng0iE28oRl1q4NdNy5H4ZMhOzu9VHjbO1LE5PtMmrFMA36zhg+HvlWa5fL1KZ/33liY1iTcl2fKUFRPcMn8FlbP1TKS3Xak1biF0ZR5+xCt1k5TRyPzVIU9UVjl6xtP0XtY2X4MRuOZ8vRWrJ8013du5/t/d8/jF+YOC5BicgHWzL/zBgBM/oqVcGYrOp5KvL5GETtvdV+uRJ3y+q9VVyXTCd5klDXCPMkboRwZLvZ4vy0THZtFqBsv4rSOHDb+HrKECqnKB75N8tn66mrMxvFciC/m31ONBebOuVLGagsPp4iS4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xh0wLTYqlE0bgZDd01LY1Ij+1QJH3E+11dqqjaAnVDbuzk7V4yyRxPBhZUND?=
 =?us-ascii?Q?9FBncxTsE7eMO1H+bEz52JTQ0CFAZNyRNRm3EBk4IWKcbV8kiM+1MFBc4kxX?=
 =?us-ascii?Q?fD8gWpWsKJHP1AyG9DYI8OIKVTH+gGs7gcwtB4aIngGJkkbymAYcjetoRi5a?=
 =?us-ascii?Q?d19fdzpIOMau9RLNt8NOX5r0dz4J1HTUoau2AUyvmHOZv3dFL1FcH6+GRW+Z?=
 =?us-ascii?Q?v27Om2IqWS3rgtpimCFzAJ4CSvXaFlv/v5PrgMIiCcA1bTXtNVbIEJJn2T6A?=
 =?us-ascii?Q?NYadR8PxhFm/B0zPPj3JmK1kiGXPOMf0vuLgqsj8cZbLbJr5+RB4srOwlaJ4?=
 =?us-ascii?Q?zl/l1x2t48WxRwbdiTguLhduVwpx9CKihzQFcxTvRs1lKlWG0+FYARCP2ifV?=
 =?us-ascii?Q?zwZFZw0q+e7ZI1l2GWONk7OEzXwwZtt8sOyviomQnAqV/rmt9z80CRSg50fV?=
 =?us-ascii?Q?pwDjnMmJZ6hs3jCVjXoq0cxraVA6onY1C/33DTIRFDuy9zUDR00awsc2bXK1?=
 =?us-ascii?Q?bAmWZ45fQgMd7EaMG/Ba8jxanjzu1i6ApfizbW8lRMWtyvtlryRfgDnFbFYl?=
 =?us-ascii?Q?TyANHh5IJ3B26ORzzkaiNaMz5aUW2qYj1pweOS3+Eck8DrbtsJFR4qrKHcyd?=
 =?us-ascii?Q?09DYZNccHKoxOhEXB7vnVzuNdueI3ioEUkMRjfN/8c1u8KNbYU0xG9URHGAE?=
 =?us-ascii?Q?P5Sw4qSCv2mOD3UJ9KbQutydbLfWUgk/gS3aTJlSFukp/PVTCykae4PBrfeC?=
 =?us-ascii?Q?z1WhjwzJosMKslrXByhlHLXGm9YC5SVTQjS8LVW2dOS7uBxsXktlRMu1OpVd?=
 =?us-ascii?Q?OkblcVk6tS5UriPk9X7yq+FEscJaOg36z5qUdlhPB/raAlmavx+vxo4/hRNr?=
 =?us-ascii?Q?Zxr15Wyq5VJn3txcfGvp1f2D55RavEukUerT1cq0lCc1b7zu6be9gpQxh0xd?=
 =?us-ascii?Q?W1Cj+ClgHCMitmlWvRBljDUcGwcusloB1HEH/VXThEqh9iPmsU6z1tzFSTbz?=
 =?us-ascii?Q?joZwnzrMV95Jsl0APA/6WJcmmRKJMHdALa92J+lgoBHYQ3qY8cObMvt0meUX?=
 =?us-ascii?Q?uFmuQmVhL6OUlX/qxL/UQV1uR6xzo/0+PhgvBewoEs4748qxj40cuYce4vUk?=
 =?us-ascii?Q?z/rQtpVdVdkT0HDOK6YOBfgMaLCbLZA6QCPQnoLImPxol7h5phrYv4RNDYHq?=
 =?us-ascii?Q?LFBIvtnSqweqyYY8aBsQgaBewtez1gpLf/l7I9mfj+mIPhAo7YmAlF+v8uh+?=
 =?us-ascii?Q?nXYpOOoGECz4P230dk4mc451gSbIjbWep7I6r7EjbtYK4dBF+viOoGoO5hrF?=
 =?us-ascii?Q?HiPKcX1uC1oZC9ym9B1F91js+L4w7g2eg5mycNxixHkWYBbodcnkHosfW2+3?=
 =?us-ascii?Q?EX1maLeSvhhr7PPAvUS689VtpqdyDi7UPZMw46QeLsa2SpyGBWW0vySt8K4e?=
 =?us-ascii?Q?B2Ra2Kt1h0lyGPLQHYBfpNWiMois7v9gumHY/ReGLaDxG/Ll2wpKNmbKZOZp?=
 =?us-ascii?Q?5XxzC8IRq+3uHmmVw2k/Jg/+SZ3qOi4KFBf00oOvZcQ0AeGllZTuOH0+Fp5k?=
 =?us-ascii?Q?SG+xYaJrlptequr+xYbkanWyZ1rTcvXimL1t7ewkYPXIahMIGc1DLu8pWykp?=
 =?us-ascii?Q?+PNb1vfeeia8QuZgB2I+R5IpDrMafolj03/nffv79nvPbAiOWI4n8644jAvs?=
 =?us-ascii?Q?5h4a+pwcvMJpDL49u2e/auYp4AY4Uy/Wraft5fo7/j9YYY/rZ7/v6Su/1p4r?=
 =?us-ascii?Q?MI4Qs3kp1g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a08c36a-17be-499b-233a-08de96b08cab
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 03:23:35.3411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +GkqzJ6a/nPCZb2ToEwZoTJTVuXYBJraw0oyKEPryN0cFhDJwUyPQGleSiGJmxwyqpRZnGxtAua/Z5/KAfFEqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8472
X-Rspamd-Queue-Id: D7E1E140003
X-Stat-Signature: byopgsdfsu5jp1fqpuxyrgnrjxprhsc3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775791438-582261
X-HE-Meta: U2FsdGVkX18nAzg6KmorZCcGDDCSCfJAiZafxniduhHvivi82edlsBvJTq3dwnnNwrKsGXhH/mzF01mHjlF3AwAIYHXA8SWoylK+CF5h7eFnIImcvurPVFOVazagD2lkyH4TDBtWpHQGqwwZhonsl0zPJYp6IpSKhvDIkk7APqGdqAzKyeUs9KWyXxPUpwWoLPfFbUOmzAByG5m/qr1sQ8PzTrhgCnkWr284NazIomUmF+0DXFTNF4i1Ku1FgQ1HCHzZtPNNtddaFuvCS6srRdHKDJ/G/5wyfVe2RSwDtnEKohA+beCEwH40W/hunCyAMCKfyVgRyRxKCFL/wnVT07qx2wccIYIifWF9F1xizlVsc7w8ovKBVHvw33xNrWewzH/wqoijf3SUQSLpU+oJBuxi2G2xULc1OeMKVKglm2+dfVv1vddG3rzPHuqE80782T01nW+hUTo92pqt/ZWnAdT7fjTzK4rRMDqtdL5p0e7iicgXkxsWfAEgV0rBEbP2BaznNUidvPsdWqgK2zY5x/gWGzUp0jd0mIeA32ihLVKiAMWhKateQ4gakH1JYMDzJNxcMXelMs6NZkJvdDBJLATTVALpp5bS2gyhOLYteMgxq+gb/xRQn2JDdElPEP1+8XKceS1VnLLDSOHTdERWwFGuLPnCXWzfinh+0avypwc+lfiMkkk9uutSllSPwh2rrseapaUQKMIXGy6mn1gAkOvOLq3iQf6DumeOHJcd/i1dp9JVOTFsAbZsSpfAsiH4UUryy8qE7V3cfbE3/r5r38LfOYoqhLqAx78CAPeQxJt7D0hrcqNT7Jpt1grZ30HnRbG/f9VXQVd2pJ//F2prfaieiBCnAR5rfzfcRwLNIZ9+mz8B9Vk+AZGyL/3IP0fp5w0feyiRI/uMiQ8/B358dbFG8Wpooy0jrghJFMj3v4AdTb+YYuY4Fhf+7LlaR1C9aUxckcoFijzL4g3xUbO
 LBMi7ziQ
 3txiWeIS6xQXMC+PkArB5KzjnbbgdtQZfxiZyWlKvn0nSWhkqCLYZHZaEsUux0Zl6Ig1YUfMyaO4AxRH3pAfXojoaBAuUdQ+gLAgDmOAwwb6z9z2/SKnupZaWq6WF6ytmd6CFYIXwsxPyc+IPKfSzGkuYS1JFxYy/7hiYOMaf7HIUSxS7rzIicIA6zRLXJUDdaNwfPa67mci1Muf60FUSWYLIxUhpbJy7uSAoToaJkXM5SaKJkqqzEvolZszdFQvlyNsTZtmFK1L1hnMa0Pr2SY/oh2KIiG9QXoYrhgeqcVAFnLVBh5cfgoSAxr+m0eRrLn4gQGOe8lzo9ZwV6Obv434r+BG/6eS1e8NBpUp8tfyi2tDJsPNYicIZ7S8uR5E6/m2RBmVDxCgooZEEPvYBUDf9FkVmr9GRRgTD11BcpVrICyhbKX9poFgj2pcv7GyMkFSxDUZrDakKPAomRRPM7NJ4WVfjck3UKJTs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This adds a bounded sleep to migration so that FOLL_LONGTERM pinning can
wait for transient folio references to drain, instead of failing after a
fixed number of retries. The wait uses a one-second timeout. An
alternative approach would be to call wait_var_event_killable() with no
timeout, but that doesn't match as well with migration's "this will
probably work" API. In other words, a short sleeping wait is more
appropriate here.

When migrating pages for FOLL_LONGTERM pinning, migration can fail with
-EAGAIN if a folio has unexpected references. These references are often
transient, but the current retry loop gives up too quickly. This series
adds wait_var_event_timeout() at the retry points, paired with
wake_up_var() in folio_put() to wake the sleeper as soon as the refcount
drops.

The wake_up_var() calls in folio_put() are gated behind a static key,
disabled by default, so non-migration workloads pay zero cost.
migrate_pages() enables the key on entry when the reason is
MR_LONGTERM_PIN, and disables it on exit.

Toggling the key is not free. folio_put() is static inline, so every
compilation unit that calls it gets its own patch site (roughly 500 in
vmlinux, plus modules). On x86, jump label patching is batched (256
sites per batch, 3 IPI rounds per batch), so enabling the key costs
6-9 IPI broadcasts, a few hundred microseconds on a large machine.
That cost is paid twice per migrate_pages() call. Migration itself
spends several milliseconds per batch on LRU isolation, TLB flushes,
and page copies. Concurrent longterm-pin migrations after the first
just do an atomic_inc (no patching).

Matthew Brost offered to performance-test this series [1], as Intel has
tests that stress migration and good metrics to catch regressions.

[1] https://lore.kernel.org/all/aX+oUorOWPt1xbgw@lstrano-desk.jf.intel.com/

John Hubbard (2):
  mm: wake up folio refcount waiters on folio_put()
  mm/migrate: wait for folio refcount during longterm pin migration

 include/linux/mm.h |  8 ++++++++
 mm/migrate.c       | 30 ++++++++++++++++++++++++++++++
 mm/swap.c          | 10 +++++++++-
 3 files changed, 47 insertions(+), 1 deletion(-)


base-commit: 9a9c8ce300cd3859cc87b408ef552cd697cc2ab7
-- 
2.53.0


