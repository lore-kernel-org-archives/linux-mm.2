Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C01C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D9D8E0025; Wed, 23 Jul 2025 09:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B758E8E0002; Wed, 23 Jul 2025 09:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64058E0025; Wed, 23 Jul 2025 09:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9428D8E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:57:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D8A416068C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:57:58 +0000 (UTC)
X-FDA: 83695683036.11.FE167F5
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6128F2000D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:57:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HFUixBrT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753279074; a=rsa-sha256;
	cv=pass;
	b=VjoL5N+WWECOIt1gYXDY/r+HwecO4euSihvBkryj4bJ63IfTv0zCzBhwVLYKXU3nXXgxyH
	uQSygvX4crgjEg9MpEyfmrW8S8nq2+zD8bCt7SoJk/t47DkPhu0VU8Ib4d4X6ddiIC7vep
	VwYN+2Tvgyx71n0sfW90aZoRCH8hv1w=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HFUixBrT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753279074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQM1BjclQEgtK5+zuFQm1OwUiZLbw3hbLavksuj14bA=;
	b=xM/PbaTj3jsgx/+xix8qSdGOlkx//ndjF3mQcmxADYZOhG8WHVDfqocUIypfX/duMTG+ii
	KTTWwaqsU1ftyDgmgb2CyUG4FQmB72E1k4cbtnUZdUMVEyf/tm9/tCJ6I2bgoFq6xbTzBi
	M0pihrnYgJtOehxOInX4F7OitMXGf0I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xYI1aLiBzHmOBc0JzBU068wNLHfxMjNAHOk+f0awy9/dkibKkKO4Fgh+Xr9fs43GGjzJeyqAxqvAJwFJjC4lJEXTJZvyZQFhiY7I8twOfmSMgeTC5XBXXIRSzTKRtCRfNFTGUmlgw65fsJUuQfr24SkQDoVeFnnWSvj+hcH3ohV5ZKTR36Q7b5DD/s1CGNJ+WhoCDuo79dKb1ng7mXqWFtErN46PG1TcEyQy2KF3WuyEDAmXo/gvlECNv0ae/fJqJEwTft/z3LlbuX1+K2pRXfCnmoF/tXWi4O1fySMu9Qz9l8q0vjPqWdam6I5UUSSqbElCpw8G3vxruFYw8sUvNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wQM1BjclQEgtK5+zuFQm1OwUiZLbw3hbLavksuj14bA=;
 b=Rtmg5IVBRSYk3BQHVTXLAGlu/N8X8FYsmrbBdHxNG4i4oNGLAiIfKiA+XYBEUr2/gWML/FrSe1gYAJQbNcLzd7yQCyLt09Anz772eisG25ZB1WS9KMfgofGzTxuXPxro0OLeTg3rrbXBGKqyyn1qEKn6J4nKfUD8WOOwJbtCwoP7fBJTl16HYZKLOqeQ9VVLkaUFXN2c42lunNkcsMBQk1HFcoqFkYXd8lsc3mt2Zozhob5bkUlOok+mxgG7XByVy4F6hqaFjX+0UAGvZk4O+aGWs8xPq+K+F2g0uGp0EmnjqgN7RS8WSdatONRkFtuY7zBiBUEbc+avhJUyYuxCUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQM1BjclQEgtK5+zuFQm1OwUiZLbw3hbLavksuj14bA=;
 b=HFUixBrTNkxfyMCYd02UPt4zOYoCXTJVlzDxpbaNby75cxBjOrTBXkAf1GslmuUBjASNZXno97L1AV8n+o/aH63m1G6QOeUCAkU03Qllok4b1ox7MQxBSuF7Wa8I2Vd5cR2vs6dWesH3qQqVhzEFfpxuhO0Rux/mjVw7ilC6ljTvAXpannJ1z5LFDko3naPA6X8gnMtItis5l90wT2vyc7kHIhGRcst7AuJ9pVlNqD8KdnC3DVMe1UB6qgbsOUadNcHCjVMZa2Na3o7s6btLZkdNuBPF5Q9oWc0S+Jqtq5qKZAd4KbvKowwGY1BKvnwI0/qDGiKDPXTnWJlFalVsZg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS5PPF2FA070BDF.namprd12.prod.outlook.com (2603:10b6:f:fc00::649) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Wed, 23 Jul
 2025 13:57:51 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8922.037; Wed, 23 Jul 2025
 13:57:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, ryan.roberts@arm.com, david@redhat.com,
 willy@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, vbabka@suse.cz, jannh@google.com,
 anshuman.khandual@arm.com, peterx@redhat.com, joey.gouly@arm.com,
 ioworker0@gmail.com, baohua@kernel.org, kevin.brodsky@arm.com,
 quic_zhenhuah@quicinc.com, christophe.leroy@csgroup.eu,
 yangyicong@hisilicon.com, linux-arm-kernel@lists.infradead.org,
 hughd@google.com, yang@os.amperecomputing.com
Subject: Re: [PATCH v5 1/7] mm: Refactor MM_CP_PROT_NUMA skipping case into
 new function
Date: Wed, 23 Jul 2025 09:57:45 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <79AC7E57-CCB4-4FD4-B78E-3A2DBAA4A3BD@nvidia.com>
In-Reply-To: <20250718090244.21092-2-dev.jain@arm.com>
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-2-dev.jain@arm.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0055.namprd04.prod.outlook.com
 (2603:10b6:806:120::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS5PPF2FA070BDF:EE_
X-MS-Office365-Filtering-Correlation-Id: 1117d887-562a-48e4-b0c9-08ddc9f0e9b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CPqnwJ6WxOtxJzQEBPtr2JKIhu33k3xYpiwsqlk23yFbFQ8Xci/Vloz6JlSP?=
 =?us-ascii?Q?k7GrumRbf1o+Cb7m5nPFjvP9jqk4drnhZmUc7qpbejUvZax84S6Q9l0ngqX2?=
 =?us-ascii?Q?ndIiO9ZqAculnFWFSpEcBVAZ4RJ2M5A1GiEK9faeDnbLPO10AxdXNVf3CBWc?=
 =?us-ascii?Q?YhrcfEUtT/zg8mnGoeEYUlmcqu8N2Ekpr/43OmlNATLC1S1XqigQ/zqEqRe6?=
 =?us-ascii?Q?1tIzVs6omiCwFYM2lzQHm4/SQUZK4JN9ERit1Y/5nUi94glzJ+O8MYt2kXnc?=
 =?us-ascii?Q?fod9kRGOjdwLh7Arx5N+VJN+3wCjo6j2TJoxFC8iHVhB5MoPPqwV/h2NpRft?=
 =?us-ascii?Q?5TeQud2FKeqrCUGqKMEMiWxno+pnj9GU2aDXhDrFiO9se8w/9nyQrI1oBNqQ?=
 =?us-ascii?Q?8aSj3wjgvC4BITPwM01QLvlzCSs2OiZi43/V8RDgVyEDx2831SaZthiUbttz?=
 =?us-ascii?Q?Gx6Hz54SSYnN8SPl9eTkaFeQ3wXjwCNMF0qyzl0ps++Ru2r2LWGbrC+h/gb5?=
 =?us-ascii?Q?KTWO9Rs5xB5dzM4tl/HPyrass48j/oxldvjK/KVmpSZ24C2gXfYF7XJYTglS?=
 =?us-ascii?Q?JQJHPAqQ7zxLFh1d7GSUEN7p9njlA6aGncPdLgStFmz7VwSXHj17hB6W2v+J?=
 =?us-ascii?Q?gtmDVrpgcH/nLhmh2MogMxjEOW1buYxg18PekISbrRH+OEIq4l9pQnIgj715?=
 =?us-ascii?Q?5fr7aKKjd7cStEci7WDp3KWJOGyi+CYPw5CU8EUgFXzPT2i+DzLM/u1oYveB?=
 =?us-ascii?Q?qMKo51WKVrqqFlr5FTVSdd2XFSsDQQ80DikWmLkSwEv1FngtW75QzN1sbVhi?=
 =?us-ascii?Q?tePXMRh5VszRmj8UNbJhYQpH876IbuYJPzSN3U5xEU6oxfXovsIuRU2JOVZq?=
 =?us-ascii?Q?nw8pf7dGvpoxSmx20p1ySCjd/5ILKxH4KOOGs0Fmm6teBdnXWQQQ7pE4Pik+?=
 =?us-ascii?Q?Auq1fCcmB9IWGjQkMeTN+1xolAE+Ro83vYY2NpkjiR57SqLjGV9E/d+DMFGG?=
 =?us-ascii?Q?YYu7RGC/n1taSElzRucRHQisfGzTg2GSwd8mSfBm1jA6tMKXm7gnH56K4B/u?=
 =?us-ascii?Q?6ILOn64P8O7K/zIGZw0I9bFe8l4WOKAkBNoA+D+xZmX7BgOx8PMjpnU2WWof?=
 =?us-ascii?Q?nExfOX4S1bEnAHKAu0TaKk3XPKJjJsFpFNnA24UkOQDiXuSynScqfiaaaxmI?=
 =?us-ascii?Q?SSpGbnTHqPYd+k+inkFcHtyd3u81XddOeLnGx8UQz8lIrhcRCUJGf6CfMUPc?=
 =?us-ascii?Q?efETDpclBKpsJBapBu29RhN9cnhc1WfU44L0YWzi51FFYbtOSwZH7VwztR3E?=
 =?us-ascii?Q?iwKMjnRpgb7Zh+hiEV+9o69ryLKbO/BR87TF1LdEmAQjD+WzofovUCIueZXu?=
 =?us-ascii?Q?aRXjZQXjdAz3iT4tOZckByA3SQVpzWvow9/KFWUIkUy5am3vzA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?muRcp3/a27dOs9Nrv4TS0ZLrAoIKy0ccms/mWqb4/OZnKNc6t+WzXOocS93q?=
 =?us-ascii?Q?jb4e3WOIoxNFb5zdTzVv/Aa8s+v2JscFK6UUK69yQTklSI27134yHYv2idYB?=
 =?us-ascii?Q?e8xHFJpDKxBTxP367U8i5e2s0YX5TeMg5OYjWbm3RNRxmK7iEoCAQlPUwdsj?=
 =?us-ascii?Q?cZW6+AYtXlAbYCCThuifdoD+M5x4eAbBTOyXiLSCIxesYOCOX98bz82zg7tN?=
 =?us-ascii?Q?Jp5fvtWUkhvDEjMLUXRAr/gcQ6FDKB6iuc70gsfhjzbETi1dEbbrgwDQFv91?=
 =?us-ascii?Q?WjoA5XgE048BWUALxB4PGqQuOysDmMHEl49FvrhhbXMSDPr7QEi5Da49YGvj?=
 =?us-ascii?Q?dz+GMH7+06D2SqLCjvpCsQWzAHr+huOGngr1Lx4E6BO8WwEfOSQaL+Wj4sgr?=
 =?us-ascii?Q?Wb4uFnW3FmqfrnbfdtfVALuMTVbdOD4VF6cay6K1pbEXAJR9tQ00s/b1lFk5?=
 =?us-ascii?Q?PM4YxkuMr+IerkPmyd09UyinIuS/K1FotpNrzr3qTFt16pVrgFYU60KpXWf7?=
 =?us-ascii?Q?pwiH4k+qCcMxSydGNU5puKFQ1sBMNIoWEZUygmOQ/OJfEO6zV8NjBlNbrztx?=
 =?us-ascii?Q?jkphAbPOPXYC7gpygXKn3TxjhlzkbrEbLpB9Kbj/APpn3cMb+9chawMJAjON?=
 =?us-ascii?Q?9pKuCR1Q2uoCkrAq4bgkITCAEJH/X1S3gVk/kkvaSfz0GLwZl1F9DIJP3nzb?=
 =?us-ascii?Q?uRfYDs5ehoHJ/rsrLgiM4u8MokdE7j9JyXmTC83KbkbPflJRfLsXOHvSJ1xw?=
 =?us-ascii?Q?kZEBlq941wjT1CWdo9kc1xfmQzxQu6kPDt1SwdvzR2yFAAiZ/V5F8rstC8Ur?=
 =?us-ascii?Q?jq8LrH6jMCA+JouQVvZUa/6mGE842IypN8pufipZn5XBnLGfld7dtsZdt1B2?=
 =?us-ascii?Q?uCBh5CXJDbwaQZbTNd8d1qP2sxvhpcvRpydlRdW3/nf3WOdEBy9W8ZM1A2Pi?=
 =?us-ascii?Q?bwBzPCMEE3EdzqPt+n/rpFF4eyl2Ib0Ywahuy974uIlknagoSXeivXSkjb8s?=
 =?us-ascii?Q?pXVcbH+bL5AVws7uht9EH58VlDUnWuroZ2yY11VEw7QX9tcg3jOPzAMt62q8?=
 =?us-ascii?Q?szSqxre8hbrY6mMD7npUm0Y3qB0IGUNQHJD02tZ31LrGxgeT+0Mnj3xC56k8?=
 =?us-ascii?Q?I1uL6Q1adstGKphaaDiGtXyMXAawZj+GDH6q+z7nyNkGSxXLd53vEWFxRfL4?=
 =?us-ascii?Q?DSstGnFN52Ec0BALHlCiTbOL7je8MiwvdfPCufPccD21iLRKPn/gtnmR5k9d?=
 =?us-ascii?Q?ebYSsumdK06LnIKvo13v+802lYi2WVWlqRFYnxp8gxUc5VcxPJgCC1hw9dZa?=
 =?us-ascii?Q?1Z2UIcbRg3j8BS9Xl1A65liKj7fgTbuDyQb1SQlLyymZqKCB95x5bnp/hCa0?=
 =?us-ascii?Q?O95ztGkVWK3WVCaldv893GHs6NiRkRbD67xmE+B+gCs0kfeG8tBjA0+GgXWr?=
 =?us-ascii?Q?qfjWEcPnblC4ZymfBlmyAVazTL7bq35DQk6DEVjeRPbuxTqPJNlMhcIXk6d0?=
 =?us-ascii?Q?uwL15EEVREjpZiAvAJx7jSDbIC0nM8eJgrHe88k8naE8NjAIT2vqcgTxQMIX?=
 =?us-ascii?Q?mWLEnSoWKqw0iSJ7NBUEJx0neTklqh2cQ+2bN4lH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1117d887-562a-48e4-b0c9-08ddc9f0e9b1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 13:57:50.8131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kgykpWwL/UkkSF+6C7Fv3HWjUnx2mr0TWo0r5A1pmgNUbciDhcAYA4ee3P8yl9YB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF2FA070BDF
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6128F2000D
X-Stat-Signature: qggddhh8ezn8sd671dye6c6kfa5fkm38
X-HE-Tag: 1753279074-190659
X-HE-Meta: U2FsdGVkX19vBY1wRalT853nnfIErSXBewG+Q9LXZ58u75yNVV+MkTz7PMdaqQ5+LWHOAfDesUR9inV2WusllmRipuh4F+1mNNnklswh3OSPhjaunz7gvdFTMaglsgk4xFz9hVC7p5UludLjl0b6G7IfCGtQ5P5BxFaBqAJSthTQJGIZS6aTeGVrKCV2tRZTRcn/ZezFBiIQbH5FCATr99FswO5REWWWRBwn4x6b7eyGVG3ppHZFcTeJJdfgU+RQ2ulKLiKy9lxvEZw5soHZ4XVwKXcpSDWxTxna8KfJM1R+hxD5Lz9xUj69eRxlYeCgQTW3B38S3abDP0TU1XpFdsnvOiamUpem/F8bQp2yXU5vN8cJhejj++j6xu8AAd3lNCgRzI8o/nWCy40gVnLq9FcAWoFd82HS6kyIo9ocGQ4amUOnY54l62VHS7xOQD7B1cimaaUuMAwDXitGTb9+mOvWS1NY19mXQuLQsqQte7L6pkjG+qEZIYtSn3i1fUyKkLSnkgHNgbYhtDQpdSl4Z565NcF/sjTrH2FfwMiRP3ljKhUdwCGr8WuKK5/gIR/cOZlFNIAAq31LvKig5aBUqUcz19SLsVjv02k6YxzpO0SUUGRW4O0e1HNjHkKLUB3peaPdKnlo5nWHYffqeIuD6GRcT4X+7SDbnkOBywfk3cxv9PaQXtripcedAgAZHT6x2lgyGZjr/sXlFsS98vX+hIA0b3KojP9qwj59IZTTVLonJJFRRivgT4zQglOBFzQ+x/QUwlV1rdq6utQiinj90NuKEq5M2zWYVqAwyX6WVNi181Pj2IqaHHMi02aBQy6E3A9VS4a+T2YRQWhA4Svz/AeNN4QOdBajn+cxbpIY9T1BqO8lRBHtf+iaIZJapTo6VphDM6J5FG478EF/u17TyIQB16/NFpAA4u7LuxQFgj0Ez0Eb9oPP68xoAS5R3egblCioVmqJJt8xpTa+1lr
 CIUtpcj6
 +Wu/D01KJyRfC9oBCgD2oo3kTH+WRQeSJIZqDmBUeg2Kj6xAyO2FoF6kA4Dpt2Mmoc10cHvWvUDhi+zu6+L9OwHAVnkPZd3az22Rn2k6qF2FvL71R39zgNXRKszqjK7LnyZAMnu93CAAG4P/o2ICP0wOINv9NKiB24bsMZRCW8iu22KEd+5gYGRg0jdQn57XjEzkYdQL1S27DYXWbX+Bq4MInVyJN5jJmFoE1X8Kf7P+Wy09zSrsgo9Ei5GFClsGNgWcGSYg/MnHrgG2/rqhn/pUT7K9QMdNLLiNxiLVHJv4ZCTqpz0DTPjNqUVQg3HuhUs+kSbOKzf6Z5VHZGj7FHSXHXDLZdUaOxTMhp1UFqgLBxZf6Y3cHOzMB+jPG3ApVkYOO/V8W3dl6U7atf6y0nVu7107NBS0On4n+rOlCiVCDPJYvtiguc/tI2OB3RXcfL8J/AvNjgZ9J6Fsp1TcBpmRA+PRa0y+kwVYCOrQ/xw51YYcZqYMWKGS/7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Jul 2025, at 5:02, Dev Jain wrote:

> Reduce indentation by refactoring the prot_numa case into a new function.
> No functional change intended.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/mprotect.c | 101 +++++++++++++++++++++++++++-----------------------
>  1 file changed, 55 insertions(+), 46 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

