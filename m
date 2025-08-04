Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9405C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C748E0002; Mon,  4 Aug 2025 08:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D9C8E0001; Mon,  4 Aug 2025 08:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463018E0002; Mon,  4 Aug 2025 08:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 379D58E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:57:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D19FA58613
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:57:27 +0000 (UTC)
X-FDA: 83739076134.01.F1F8B9F
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013071.outbound.protection.outlook.com [52.101.127.71])
	by imf22.hostedemail.com (Postfix) with ESMTP id C0E64C0011
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:57:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=TzMNZnrr;
	spf=pass (imf22.hostedemail.com: domain of rongqianfeng@vivo.com designates 52.101.127.71 as permitted sender) smtp.mailfrom=rongqianfeng@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=vivo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754312245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xxcjSHh6mpfvMOFMKx+R5TT+g5WbIH7m30s3mbboOU8=;
	b=4tNs1qXELxS0k//oa1KI+5KuBUshLB6TA+jJB3BtFzyvi9WZj2G9KoTaxaAmUId8Ms/d6j
	pnhc4ts7LOKJhcgqCOULhAWWdTn+g4UCXzYrb9WAHPWQA6IA4J3W+5owJNz3kCeyQEfdAM
	K9nDn1D83XkKnqKq7FKOZDj3J2j94C0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754312245; a=rsa-sha256;
	cv=pass;
	b=6Bi5nZIrheNVDHalG6bM5KnY3ltIs8Ie+g9jpKSORwRExCBcfPqiKgjmyMf5hRKTry5zDg
	wM+FzeThUPeeByIWRYb4KSDjJzbARZDPvSNFkJq0dO4IbSl/JlijMTW9+qE1BqxmRrffjm
	uBmOhSjwiTkMkj42h7GkF2pcIjVBIKw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=TzMNZnrr;
	spf=pass (imf22.hostedemail.com: domain of rongqianfeng@vivo.com designates 52.101.127.71 as permitted sender) smtp.mailfrom=rongqianfeng@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rUZtZh7od+uLEhx9rzqY17uK3SW/F7Co6LO0/fRX9KTCSDGiiRKf45ttM9dHDsscHYsnOoN19Krc8MrrDDdUBkbDUJN+Brfckz0famASLibp7I0mtR4CBtW1LBU8Wk79aLo/5RE+qZQYuqNZtg1r3LtftA94ecFfAv9slIx6ojSuh66kRb+5CR8B1cSIsTau6//QaCy18BELsp4n2bqGi8aducSBKFedUyAxrsLDxsD+gSQ3dLQeUCkJ9KJHHlCNcvZWrcUiO51flDDDwiB32PY0PCByrcJFjXQNKTiV1KxtMAcFNhNU9ZnI4jqItAvuilvvKUNxUcWesKxe+lAvkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxcjSHh6mpfvMOFMKx+R5TT+g5WbIH7m30s3mbboOU8=;
 b=orCb97Tn+F08Oi4whS4qz9BF2Xk+AoDdNGRkprVDH498a+G9esbXkv/qmvBfxfnkTgPB4lN61je+OetSWQrmHZlZJ3S3JE2yxCXgcd7MuwVogTx8eRj0NP0RjdtocL4D6QeDU0O3L8WSd0d2uqQ/txLHxX4ODJIcczjmT1en5bB65c5PQGlNPUa73H/ML9DvG4PF4fcYUHOjwsyLPHiRoWBqMpODnbl5h34yBiYksdfWRFrHSPDcnlrkZyjNrACZ2T7HlgsDhJgLmJrJn2mdMGMyXfPoUz0OqKht+5aP+cH1AckW2fx6baDFWkHUfFvnHk4Sj/53a6V6x2WgNWs2JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxcjSHh6mpfvMOFMKx+R5TT+g5WbIH7m30s3mbboOU8=;
 b=TzMNZnrrRNH6NCKU9ktPfgqyJw0K4LnKEt9xNDs43Qep3vVzVgoqU+Q/N2ZzZtSlDGtiB/2Tup5n27lOAYEL49KdRg7Mt1hveos9CSE8SU78E+ngbQOtznYd5CccBofxARZgnh8ECfqNy+xkNMnVazsu8hpITjXQWr2KhCbVVzy5i+qa2dm4oDMtksOz+T/swfjGNeyad/2/P/+k9MSortME+WvnRPAOCcGTX8TnL0DLQv2Ap4u8gB+yUvXd7BAIMbksPvsThpeY93et+NAQkZ+oBr+UmQiwK92X9FlNKAwRUp1ywW/I1gEBenkotryZoakJ3Libvyq2iDTGt4L4cA==
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 KL1PR0601MB5566.apcprd06.prod.outlook.com (2603:1096:820:c4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Mon, 4 Aug
 2025 12:57:17 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 12:57:17 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org
Cc: willy@infradead.org,
	Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] maple_tree: Remove redundant __GFP_NOWARN
Date: Mon,  4 Aug 2025 20:56:57 +0800
Message-Id: <20250804125657.482109-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0021.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::8) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|KL1PR0601MB5566:EE_
X-MS-Office365-Filtering-Correlation-Id: ec6a491f-8b49-4027-d967-08ddd35670f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?acampjXn/tv+NIHs4GocgDirn6XegyHZ6PZspsUvpXi1t95sqpRNMhdbbgLs?=
 =?us-ascii?Q?7zU3ALJjDPTeUZaj33tCYFVxenJhPBFIZscBarwMdwO1WE0z68p7JRAR7qFu?=
 =?us-ascii?Q?UPmJ7ZOaJwQnjLTXAr3Y7M8uwdXrd/+qIDtHDqvXPLDtHok4tKwLk9AIpdwP?=
 =?us-ascii?Q?F72LpPGlSazZfH0fEEEgCoJjkTvx1jLE5vt8OIcM5dqGyfZ7sCRR09dT24my?=
 =?us-ascii?Q?ux/wyAZnVfTfEHwgW+nspXRcC503gKauDSBpm8Jxn3ftJm1tSQMc6oDDC1j1?=
 =?us-ascii?Q?J/fQtx0ajmhnhdeZt0iMk0oQV21q2DJG4l2RoeORuCCd9ZzYXGmJVPfXP/ir?=
 =?us-ascii?Q?zsyK0e5F2/aoulJYG6Ehqw0RFGR6z/C3gxr8/oeh7wT5amqSMmlRmguk4CdY?=
 =?us-ascii?Q?UOLuoxFi39oLsE/J2mZxjy62nja6XXDYh06V0LK7SdJUwHKeDtRbjFa98ydk?=
 =?us-ascii?Q?SzadwRLiPgOf9Aa9Ijczf/M6Vg222wmplEYxd66ktviMqnvj8fy3WwXjuEpy?=
 =?us-ascii?Q?QHjwyO+p+P98BJzteMo/QzDPNJ7yRfN0nk+wFP7jAaOVzgZA0r2kgHqoxF/4?=
 =?us-ascii?Q?24ND5GVFo7lHED2mimg4/Hvcg/m4GCVkFqjO+drcCzFTyr1QDfxrSDNhxuEg?=
 =?us-ascii?Q?+6YilOIW7aBkZxNkIUX65fRfSt6cqRb7Wr2ybBvvNaLl+NplRPEbciZiIrYK?=
 =?us-ascii?Q?ZBWpCkxrNh3ivIRiaeiTg91+aentboYa5oFVaC0LyP2AouFjKg0Qxk7QnwNb?=
 =?us-ascii?Q?cqRzUvz5m+rNpFxNq+iTbEd3hAylIE0Qfi2+QehoJtHl071ydSOhmcudphfb?=
 =?us-ascii?Q?aZbXuboENge2hvQ8E0/9o90Hvnyyrbz4BkFovdRU53bJtto2vZRsG/OvqLMv?=
 =?us-ascii?Q?y4L7j8zgpzFGKtYkLtMyhkXa8TvB+D+0GRmQzS1/XlTWVifHLvprNlNX2MeB?=
 =?us-ascii?Q?NO1Hu/uSumXDhfM0u/LYgvo8/Ey78sTeHKlSrjVtZ1ZKD0iJjU61+/pYS0GH?=
 =?us-ascii?Q?dub+UilBQINvzBeRhfUNP8kmfwwQ4H7g3iz0pPA0p3mmPaYKNmz83RbQxwaa?=
 =?us-ascii?Q?k1jzbAlpjrMvEC6i8gt/UiLTtmfgctu/NWZ/C3o0VzBcxTeIWJ3oRjnTeG74?=
 =?us-ascii?Q?mttn2p9f6zGVmM9P+yzBj7Hf2oY8mCEDmqumfHgyJeg0oZDtDm1VcsJMQgCz?=
 =?us-ascii?Q?Xt+eDIYsD8Pew6o55RklK0YUuGBgfAZa6u76YQC5qGbLvAsu9JhH4Ndhl3dj?=
 =?us-ascii?Q?FehmobxApZYRkNDonbahKxZsEyLX+rqnueloLSMv4iL1yxOSOI69VnGsZIKE?=
 =?us-ascii?Q?Xuoli4HMiNjHrH8GcKTUHBeZ2AyNLRYT/6G/XzxXzmeoG6OwkrpT9E9CPr++?=
 =?us-ascii?Q?IZk5okoEmy+i0I5mgNqW4Vd3CD8PhoLFp9Ef6AD/UvRBvUQwfUTeKd4J5jJx?=
 =?us-ascii?Q?aWWbBPwLiNjMLVyWOircOahVk/ULnmADNsuGdVXZziD8ATiaV2nxWg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3uLQxECKBFvnZU8SELoJK+kGCdD7HBUens1Z2iTw+3JHGur3N760mA6QvCTr?=
 =?us-ascii?Q?s4uEOKRRMhyYLQD59t/Tfnl1E6yjyA3SixLaMtOAGBu6VbeQOsm7M7JLyf6w?=
 =?us-ascii?Q?3hRA36SDIweyfIkrFjq9vEHJN8WR6mCc3fK/faCMaKC2TQ+yniVRHvMzf4kU?=
 =?us-ascii?Q?3hTsQ4dPaK8WMSFCAWQx4vv5+245tZETxNmUgUaxxnjiNGzBY4tRjh3M+Ylc?=
 =?us-ascii?Q?lOtt4hiWemrz3I0xwBhwweZRBzj0iO28ql2NuouIfVW1wtHctli3N5BDEZyy?=
 =?us-ascii?Q?41XBLwNLLcdrZcvEBfZ63CoujspFNe+s5sKednrxB3Rv41XI8iveIx5KmShn?=
 =?us-ascii?Q?wo/PI2k4D84Pe5j5lYEonYIjMCwLefQmI2B5IMJEfB1DAVbM2ztoef2QJtDb?=
 =?us-ascii?Q?xnSZ44ABZHFqpgqJ1Dsj3yhkbmeiKswFsJTLPfEOSgCs3cstkC2xbwHj2mbL?=
 =?us-ascii?Q?u9iOCqh1nRZQ7iiWVgkKK4sAWWkxX/4IpTBlBTroNMhkB5DsmkXtt/neiBxp?=
 =?us-ascii?Q?baD345mW3XrzoIzAae5yDGm4zV0FEzZ0ay3HazvgL3qYOGLq1eS2jNSed7Jz?=
 =?us-ascii?Q?Z6E3/0qX+D1k3GdszlW226LYhT5gYtktSaJpSn6ZKFZMLrj6Y1Lo1T+Idi0Q?=
 =?us-ascii?Q?x1R+YSQMunpMyAWmrEjrPNwgYeSlbaQF52HPvTPwNAR2SnMPvU+OJO9QHb4x?=
 =?us-ascii?Q?47Om7EBlrwTg1tHhbaziVym4bcKGzRh0MeoJfa48qugXQOHVhA50Kz/3OehP?=
 =?us-ascii?Q?cyNUNdtUyaT20mBQOL/J7UynFhwsiH+Z53nEzE3WXUzxR9GrRqWaEy14imxW?=
 =?us-ascii?Q?3hV1b7MpjZ/R+4kwFI6zChxhrdv7IcGS0l8BkqgqtJW6uWJ3gWUxp5kweSud?=
 =?us-ascii?Q?LLdJmEIrnHq2Olv5IBUfQwDU6vef/0cf9dlBe+0A2oVaH5FftnqHkvE519SN?=
 =?us-ascii?Q?lOslKzEg2QLdygfyc7bENIozFa3LYiYCQKYMAq9iVl5ALRfJIMZfE9vxS8RD?=
 =?us-ascii?Q?QajFoXqfZui2VCfJzDAYoYstgN6GGopNnHQlhREyo7UEzo0i5peST+cceK+k?=
 =?us-ascii?Q?iSog5ScGeeqo6PdPr6KJzihU8UbjVrtOd8gjy2dz4y7hnXhxKpYR04ubkI//?=
 =?us-ascii?Q?hMF0CemJnCDD/Ntme+KqhEGFQupVZfmWsdcOtk7hc1WKjysM+aidx81T4Ef+?=
 =?us-ascii?Q?mgd4cRXLo7pEQg36igmVeo28V7dBN/jyrnoFLoOrMvIHbJ2jVzjpKka6Fsil?=
 =?us-ascii?Q?FwEjgYSaJ2jsTkQeH3fPSf9o7KAy8q34FHzJNetPLnAvuxf+AHc3A9fFsSzh?=
 =?us-ascii?Q?qyuUNgvO7KBHGK0ljcvnxm7JHvfaPGzq13gIRRyQOQ31NJ/Q5AmQr4WbUhPN?=
 =?us-ascii?Q?6u7skzXwDkXqy83OvgxV008lVCQf9UHZlVRCH8yxT4s2MuJ3O6eYVj2NCqtA?=
 =?us-ascii?Q?LZK1XEUn9V+G/G1uBpoeDbIb3fA1kGS5+NMH/4EZ3+zKxXNLjQ99v5YsYhb6?=
 =?us-ascii?Q?Dv27+vOMneBibJKIU7HPXgdc3hpDM2cxctAoKxbZ0fzHHczDIihL63e8x+Lf?=
 =?us-ascii?Q?E3cLrGmwEWMddL0KSloNwiNJbFrjlvfoh5PpMTHy?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6a491f-8b49-4027-d967-08ddd35670f4
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 12:57:17.7718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rvze4j0LDUm3S9L1zLasiuwkfqny8JQQ4eD7SjZ9qgg1xEL8lCWvC1W+O5FU4cn7+4gviQt7kl5HIp2Iea17Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB5566
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C0E64C0011
X-Stat-Signature: 9qyf6a3tkt6wijgracgygg1o571m7isn
X-Rspam-User: 
X-HE-Tag: 1754312243-151937
X-HE-Meta: U2FsdGVkX1+mczjvgfea8/kfzdVf5WFfDdQ8TYd0z27CrgWfGdDzCFTORAreWkEakgiGuLispaJ/IM3OAtfWdPrrhpHZDbcDY39vUAn4Qr/M10F+HvD1yfzzos4DKGoVzRAhGrgY0PKYTukAJ+/b6JIa9xbbiEIG2mBMkGhymGjarnzhRyfpOwdjjj5TGAbXz4RG7FgHsxRmAtCdaAMxpIlyhFjeUyPNIr2P4+WeRxQ4s0hklwuf9df/kZ+sWe+pwjMkGx3FzQ9u8zturHZoB5FByCEFc2/yNsnqjw2+EXP4Gp9gFRzhD+LhO05paqdg2X7E7BPH6FPYgrcDYNnXgmzeUJLHr/DB8mgHdr5wBcH/hS1wIdaElKDE24+xPnkd0y1EnqXC1o8U0+Vf0vd2cwSwaR7JEHCqm7um8uPjKWyXm+uFTtqKcz51gktPd2GzsW3DK7wCaC0zipAzx3Pe1NUeaBR7xxoUlkI5a3JXDqRJ4xRuCdkVMz3JjidZ69Bg55RM/7pW5m/iWKIvJqZgQopCMe9njE0PvfqQBHeO0mOEIMwGXbZmJRQah8hlrnng9SgVBJjnQkT7dcft7CRz8toKyDexJPJtmtgSUHQDQtI6D3i4Z+5atcnDXwkIluO0I/RLkPZn11M+8aG7pY8Tn8p4+s4aXWCb3M9wYzjSvUC/mf/aUu+t0x09epSqw+ev2fHmVhuwd0izdjXb9jly1q7cka1VSg4hQ4gft1if891kh0ZN3Hl/DDL34gpOGIvaSMi1L6iEwAL4/N4eEB/y43dEaDYQ4Aawxa92aCxxsy3jVP8n1iRsxW08ckhqxpd3YyS0Xbdz3hQYgBe3pfTj4IOdCH8LhTMH2nC+K4h95tzFzW5GUI6a2MQ9SepKQUszgItNbj2eetk7zCwo9N/9QCQw/69nohOG+JUS/OX6WNFPw/cyi5S7Eyd0nta5KsiDHi4hGkM3m32B5pGa63W
 D4Hv79ZG
 2smZsS9uaIyXMZHy75/sZtDkIoKnC6LbLLHkwNEm0p37oElH8+WE7HpAM149WoxLsMv+DMWoZbxq2vA5LXYoBOKhsdyw72t7BaaDTuH3Tn3R8h2BLBCSEwpcwsRhL4aTkMZ6zD4iW8EeJTOKdJ+HV+RLTqDZsAop7ZKKY00n9SyMDOTHpg/yFhTJirtca5hnx+m05RflfaQloNQ/xqSIMdjsKFOGANFSp139AI5HEkkSlKF6d7k3awdJjJNspRtMXZr2B93rqUE0Y/Fv9EGuGtRdadxjovWPobItheQq6zTFVpuZazz/1YM42NrnNTjH20QoHBXweUQxNaHqCdI1fgjXubfvrZkBnViSiHyr98ItgIVyTBIIihNeE6mjGALdyugt43kdzXSlJHKtDaYHiKNVrpTRmw4ia7W7C6Z7Jiy0Nb1Bugvl34B6OXUwxx/XQ+mGUvJUIujU2Hf22Fkae64gN1chOU804DLFHJ4Qh3PJqOd2uYDUEQjrw8TzRNS8HeivvwyaBSFAMgag=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT")
made GFP_NOWAIT implicitly include __GFP_NOWARN.

Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT
(e.g., `GFP_NOWAIT | __GFP_NOWARN`) is now redundant. Let's clean
up these redundant flags across subsystems.

No functional changes.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 lib/maple_tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index b4ee2d29d7a9..38fb68c08291 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1344,11 +1344,11 @@ static void mas_node_count_gfp(struct ma_state *mas, int count, gfp_t gfp)
  * @mas: The maple state
  * @count: The number of nodes needed
  *
- * Note: Uses GFP_NOWAIT | __GFP_NOWARN for gfp flags.
+ * Note: Uses GFP_NOWAIT for gfp flags.
  */
 static void mas_node_count(struct ma_state *mas, int count)
 {
-	return mas_node_count_gfp(mas, count, GFP_NOWAIT | __GFP_NOWARN);
+	return mas_node_count_gfp(mas, count, GFP_NOWAIT);
 }
 
 /*
-- 
2.34.1


