Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A1C1E6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69B26B00B8; Fri, 30 Jan 2026 16:01:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDC76B00BA; Fri, 30 Jan 2026 16:01:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770266B00BB; Fri, 30 Jan 2026 16:01:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EE726B00B8
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:01:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 107008B8B1
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:14 +0000 (UTC)
X-FDA: 84389850468.18.D099867
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id A45BE1C0016
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QkPexreg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=T8ipQ6Q3;
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m31wVm3xrbms261iI6YNla3eOFHUlW1kVlFsSJ3MWFs=;
	b=UqRdgZBxzrcZF0vKSGuOhnZvu/53Yahqf3vlNC9YQHqEiCvdTfVwg+W+3+G/R71rF3ZJm2
	YvQeUZHk2iBqLa9twVs6hYjA3HfzcA/fqHwdIUQMa2EKhMQ1As7LhrxO7oxxhLspivZbvn
	nkFDo8dV63+6W3PH4LnIZeawVqTNvwU=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QkPexreg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=T8ipQ6Q3;
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806870; a=rsa-sha256;
	cv=pass;
	b=kzgR6CCikBUoBL/p7KoJLi7/Xpis4o2KlXat/sV3MHqRPYRuvPbxB/xcOSL1ECzDSjAg/s
	7Zhj94zleFtZNOK97OTBK3j8JVM8Dy5+O6IcG72hr+kviY9i1wjIQxIqeZMBAjhlf7k1eE
	YVHna4WdAtCecsXWD3gvT9AkxLsNLug=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKEkB5611033;
	Fri, 30 Jan 2026 21:00:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=m31wVm3xrbms261iI6YNla3eOFHUlW1kVlFsSJ3MWFs=; b=
	QkPexregg6nZE95uqizzrH3N44gdGzuGse0tm1nXefA2Wiihlnbb3RxVGLjtjHj+
	b4W6D5tyYvdEIdTdSdwyr8gl6NixWyr4GEdma00LhOpMQuWVaRu97qdcOkx50NR8
	HRpp3QBNXCZSctpE+NRbYzEV0iyjfTGP8RZUbyjdEZx0evdCE4PvYMiX3rtdTPd1
	TQH4KB7a6StkSfrd4SxykvdqIr8PFg6RRVAmyrCLFQPfskuhjNZryKOmMZS2CPvA
	C4QRy0b0ky6ydCeg0nPycg0sNKGB+6/asR1gJ8JSSIe+kqcyFIPqdtqY7W3TMR33
	qVyehn3AH/pH1cBqDkuytg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10d88bn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UKQdxu001917;
	Fri, 30 Jan 2026 21:00:13 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010057.outbound.protection.outlook.com [52.101.61.57])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhjqu4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qVuAbW6KJp1nXNnk4YOlNMVAH7nA3VIP9sLmZBYrjb5++G1rbMCSnCR/v9QM8sMkyZZvTn1tvZtb/2YeVZjlWHS/6A04MfXF7bVS5ElRjbVylOC/E3o7kzD24XvfCnLhPKITZBwFb0TDAGUbMhwMcHVmgZXkCvXIetgrshtCfajRPQUQK/ADZ5qWCoDYF3TAaimOpLS4MdZiTl3Iqg5WlmtVgIpyr4Hs8PuSN30oWL23nZsmNxg70e23STvbY8osn6yQ/ZSy6umY1wOo+ktCzRvdOp/i1QgQ9bOqpQwObTdEbyGHSn5MFw17ljI07blXMu3TdHznqNIJJ9b8xObpoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m31wVm3xrbms261iI6YNla3eOFHUlW1kVlFsSJ3MWFs=;
 b=R3VH+sDO9gMP8C1bXq5KdfLO5QOFvjqSnnd7OHNz7FzCrRMNx1qgDnj02TY5/aYUud410xEf9IqnrgCrvnhZMG5GoNNW+CQvDXYdC6oY7XwFZh2DBhf6olyA+Bs2LD6qZzQXDYjjfMYRJRwutEr9En67gf6jom0yGcNWKJPQyPVNbxhwa4ZKrSEr2S2IqpbuC6RPQSnxjsha2MftI6fC02KqDwFCxFIYooo3swgJL+ryW6Ma64Kn06pPfHsq8i32Z2Nm03EzKPa51RMayfA7+ZHym2wavI7D/qA0/t7KJ9uk27kX0oF87TqJibML+zBqts3rc+78Og0ZSUit784QeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m31wVm3xrbms261iI6YNla3eOFHUlW1kVlFsSJ3MWFs=;
 b=T8ipQ6Q34sXiwRmEbKmw/CsZwfbTOwCI9AouiYwKf3ZWLED4EMw7YGwS1BRs+VnDz5nbYvZSmZlvHXBvSWvVeBV4i2ZSeJ2qpc4R4se2K/gM+2dgzIyXMp5pOlhjW1jcvYuLK7LUvEkzCyskSWjwc/K735Ex37bl6D1RpQePdwU=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY5PR10MB5961.namprd10.prod.outlook.com (2603:10b6:930:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:08 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:08 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 06/30] maple_tree: Make ma_wr_states reliable for reuse in spanning store
Date: Fri, 30 Jan 2026 15:59:11 -0500
Message-ID: <20260130205935.2559335-7-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0105.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::14) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY5PR10MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: 9895d006-64be-4b4d-1fc5-08de60428d02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/TCsa6MROsqzklLJ43s192lNovnMnqMn9TgsBvbp88kCkYl+AD8YFXPuQ8UV?=
 =?us-ascii?Q?hlVN9Dzh9gVtUPZjBys9aJ4IWkeiR3B8LT1lHF/zIZGpcOesZM2JBMRsJdeB?=
 =?us-ascii?Q?q1aHGld7NAsfmIKn25ChWTtHEXTfaN0+32gvoGC4yNZbHgVVc5iHe/DwWC0b?=
 =?us-ascii?Q?a4bgpAzDVpC1WuchcXIq76AcLzgTj6rxFNtosZi+bFbSaxIrB9hyoGjw2Ywd?=
 =?us-ascii?Q?SOZdFRu0Rfiswiv8VkaOVUBCpRsDyuP+61LmM9eClTGDUhqqSX5anxRn+lSL?=
 =?us-ascii?Q?5U56uCL+5zZSJQG3Y2cubTAanLi8lCOHr3ibPHi3AwyvtHfoGRtLfNKbxy//?=
 =?us-ascii?Q?i4+3NHBE8j/s0xQy7zVbTksZoqb2IQZlij3gZmnLcN6U6Gwdd3Mu2O53Ycjp?=
 =?us-ascii?Q?wURrZF2hQQW/lS7kWAdUviyadRHIqO1hdkw8XEICNeMIM+cZrwqcrWVBr2O+?=
 =?us-ascii?Q?kCkCEzEhoXTOLhbZrb039KpXzMvaAT4OymAUsLtmNkE4QbqKJZbKrQmz+9dH?=
 =?us-ascii?Q?YO7ckwv9EctMANVe/sYZLLlYCheQ53X88WgKUq0g1g9ClNbSZEofxVCZEAUp?=
 =?us-ascii?Q?sciBa4nIXHN7wJRAUIDyyoVA5kI8JH/1TEL+s0wEpkgOM+zsWCxHnvS6BhTL?=
 =?us-ascii?Q?Z+/fYKak2j1UjponKEVnHRaHhBhm7NFfdJS+1WOz9yeWQWa6VOX9t/q/ldhd?=
 =?us-ascii?Q?t7dLvsTAAdYz5ZxpACw59+Dxi6RgwXrKkdvHZ1ceGlxV6Xisz2jk+5aKniOX?=
 =?us-ascii?Q?o4RJfeS472S1K4kPAs5AKLkHvOMBElBqc1WXTr+49FN3M8SAILxVJh46Up5Q?=
 =?us-ascii?Q?hm7wgOLmRNz35yN5Vy159o90tX5DvA26kpOS8dOlt9Qag6DxBmgW1ryAYyKg?=
 =?us-ascii?Q?cELafrB9aCOFLfQRVansW7rtX0d0o5a78h2ISzFvvVEEehi+0AldmyKNh46A?=
 =?us-ascii?Q?56qQUToUgPO84i0ba5K6aAA8bGYvZSvezN3mZGdTu0OqXUgqROZW2KnrfpfJ?=
 =?us-ascii?Q?yYIEhxaXoTSEwuJs0l22ykfKajwEeiFZl1tP3/J6JSJ2e3ItAfoZ7Mf/clT9?=
 =?us-ascii?Q?FN4MMjDk0SxWNR7qRLRP4r9DpFyiXUosIIa7Juc9UCoLuxp95dCGA8weDK4M?=
 =?us-ascii?Q?khURTkUKd89mjtB+p4vf/CObM8iOL7564mEx66v8TBnPNS3wrg3O229iMe9k?=
 =?us-ascii?Q?kIsLY17q/eA0d3yNCakIOXzNwOaiZD26MUZOusnNxL3IC1LbQGiO3A97b5zW?=
 =?us-ascii?Q?APWzp7NBT4GFiglQFYqmHOAhqmVzITdcIFrlaZ/S+EZfZu6fTCc0WHApmK0H?=
 =?us-ascii?Q?MEFIwpsaidQCeonINhwofIT/TRCdIH0zpciOeDxojyDa/SjvQrADco2OUaM8?=
 =?us-ascii?Q?lzwsBWYGediJx4wYKHApd40quZ2o/AcexO1G+fHXajtmFy7rvTeCajgfukFP?=
 =?us-ascii?Q?bnIOY4PeJlwYjGfFvoxJHU8fFLYNO+XFhUpd2X2127y3FUREX2U9NOuzNslj?=
 =?us-ascii?Q?CY2KVf3kK38yeZArpBAGhrvL9oTixqtfsUu0CL57icpVoEuDmL+rO4bwjN89?=
 =?us-ascii?Q?cxoZvtT3T7LIA4pvFxw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iqwtNrErfgeSeNSYzWyhLjhUro4ucIkgJfG2ZdORIm1JGLorFu6oNP4R2bRV?=
 =?us-ascii?Q?FYanPwcbNUseqR80MF2yi1CsQAZDUXijy39ososa9dwV9IFnKuz7P00wfFPb?=
 =?us-ascii?Q?syTCRmu3iwzSI7qR9L9DyjEN/jqiJZoMWsl7tm3E3zjvrh675foWLh0hgm3D?=
 =?us-ascii?Q?PweopiMY0d9J2yrNvqdd3EVhoge+KZYKE6qAr1JuPomFAU5viOmAfsqvA/fa?=
 =?us-ascii?Q?90LQQ3K8uRMohQ1W4f92wOiW7PmF4vkGQx67/hk5CYmsYfcnT9xD82EwuWCn?=
 =?us-ascii?Q?Ivih5Cxgnch/iXSvcN5DDs1tPUTY2lQ2z0NrMW/GmKxrxqxPEImKbBhu6Iar?=
 =?us-ascii?Q?cZUmCv42XavJUN+TzhuOpxBtz5L+PHNLC57eP7FP5R3n7QbyYRB0foDVmwgV?=
 =?us-ascii?Q?SHj2E0ytJ52idqilxBQiTuVWW413DE9pzyM+CnD58Kz+NnWlzkzi48yW+Lck?=
 =?us-ascii?Q?sfHfmsmBLXDn2TgyQci5yzckqFcC/zmSPnKaClmvtSRh0QwpSbwU7+GNeLEF?=
 =?us-ascii?Q?wBSNlLN6NVl5B/Y8z/apeMWVzORx2Tb4NpM3XIv5MWc90ci2LkcS4l9Gmtwe?=
 =?us-ascii?Q?IkrxvHPtzHmDsrLpBSp6m2cwkBAP/MJbFwvb5BVjiE3nPJ0ohaEKYLadcXkm?=
 =?us-ascii?Q?McKhSfwy/qppXRUEtgNFZItZ71gszzd05TYHWHJOax0xu9dlJrM8La5uGOna?=
 =?us-ascii?Q?GwEaXfFvnjWKzIU54hRYVBUCTJ8p4VbjQRZKGp9zrA/wEbOkvxFl3GKRbglj?=
 =?us-ascii?Q?KXjN7Al6X4H0VQYKhdQUxc5KcsnRlW36g30eOqBtZtDe6b7nH/fupJlQKMff?=
 =?us-ascii?Q?6wOMvwXKsn9KykOTiHQCTF9std7yb+gKnBqoGgHRiTDX476yZWruD1g+jaWR?=
 =?us-ascii?Q?NwtWa+MKxwnHPG8/tOK3Di5G6M+3RtJ+DrwcRuPxZ/yAWShboaH5FMY3PW2Y?=
 =?us-ascii?Q?4O6TaGESmBk1gFoXKq0k0jetG3SzF4pSojpOYVzT/e787+zPs/bSlYWMzI3R?=
 =?us-ascii?Q?K+uTW6E/IO/yr5OLdQrn0LUPOLL3XDIutEhFTtrt5/M0Uhs9Wx9smTSZ9yRP?=
 =?us-ascii?Q?D5Nxd89PxK3hAFq/Lz0cryaqhhp1Fv8PjxYyQ0oyKF+u8q6vvPk6W4tKAJCc?=
 =?us-ascii?Q?YVxLllgw8uHJAFT5evZQbDoL4pYDDGGrek0gajk8S3C9dVyPnIV0aR5p5pdI?=
 =?us-ascii?Q?G6XX0GeqPs9Ew2UNvDQOMQGkFs8W37qIzXlHyIWw+B7vqDpZMqnefeZWg4n0?=
 =?us-ascii?Q?llht7yfXZUNhlbM69AjIsth/2UkX8hcwUGNi2YL57NFxiDFC8+BTPpHAcXxB?=
 =?us-ascii?Q?hTHA6pTBlAYKmPg7k+wqi5S5G56SzCMglVbJ5BqFzJqLJ26Y6kWj/e+qmb6l?=
 =?us-ascii?Q?gZxFAqLWyBCZKFJ1J1fHRQM667OhWdCz2rnlel9xKPrKqFRHITuNVkuJXyqY?=
 =?us-ascii?Q?Z7V8zHn2YTdIQKHsi02qa1O/g+BwY4DK/NnQVYonJ94eVT90ndrsJDoAUmgS?=
 =?us-ascii?Q?W3vrswzbxOgTO0C4yNyDT48v4JsQ3MLOTxtoN6MZKG/vA/+LBOCrWnEp342G?=
 =?us-ascii?Q?uCvLSpabqu8wcpTja1oISh1iS0pIhzw0o2//I6Y5ZjocT4WnfN+8K/dpDigF?=
 =?us-ascii?Q?uemnTvpgLXWbLds+f1sgxdJgm2uIwgwrbyxh8sUEtHIrd3YI0NZnwem6aslc?=
 =?us-ascii?Q?aFsk/pI1jGXAMDtP3qZA8D2msllqB61e/tmj+Y/dsro+P8TE7DI+BYuVerRD?=
 =?us-ascii?Q?/6LJo8j0PQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qyYTq0TlCH98CQxPeJt3rjtU5Ur0iKo5o/GCAauerVwQJnIk2qI3OA1XFnpetzU6/xoGC4xLX9dFzlWTjv8KLSMfPcEsPtdhls8qv6g7I1WZigsKPQZCVpMQqHm167P1BF9jelWvdIOCQgf0W3dpKoeuHSazq+nVFvndf6z+jvf4/SMUSh4KJ7NwV6Zy5aqWXf0wJSIFvzlC4bOoQW4kQAG3n24w7Iq3xlILAh9UAjvnyBRwQCkMmWIg+P9qboCXIOOaU6vncVMOJqNlha7MIiWW2JZPpoa6kT3BhqoIIIuI6KZxQVoGlyuLeDCFMO4Sjs3DUQcHlAjD0z++Ydr44xKjAp4OBzcOhwkVMSKW5Hi2xb1MS9i5G6JUkAjRsaokeud/d8uJ2Or5TcZYg+2zCGQVCJTRVqE50p6htKp8va76Qo3V7fqMT5KlOObKkeYQmQxcb3M4zNq3VocI4O5MKLyLJ81DDPJPDhJjZ4FgxDcmsxH8pmVd8nrhT9LkHy8KICIuslCQnPTvj6MrIaHr0NjzmKwHW4WkZkDr8om8YNSClMZSyB9iCkoCZtSnJLOHr4cfuIN3ygi7v57MZhhCi9J2QiYvzHlmJ1kToU+/ugE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9895d006-64be-4b4d-1fc5-08de60428d02
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:08.4214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I8Yx1f2uiR/tw7kOuMA1lAclmg9tQ45lVf3w0m9TfcE4Phulh5HhnEGSgfl6EBBKa8+dmqj5+cKiCdHSOP4QoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5961
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-GUID: RiFV_2mvdrf8s-eSNX0MOGPWFX3JqFmh
X-Proofpoint-ORIG-GUID: RiFV_2mvdrf8s-eSNX0MOGPWFX3JqFmh
X-Authority-Analysis: v=2.4 cv=YuoChoYX c=1 sm=1 tr=0 ts=697d1bde b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=gTX0PQgR-87UWUccDAQA:9 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MiBTYWx0ZWRfX3pbl4AnXLh6p
 kh6xMFjd+IfiuXJZr5aNp9xYlCU1YBlq2IkdySBkGws8AXRcg2OXg8a91kpXm1f+GuuQCwWUQhK
 GnJoyCn1g5zYCHxT0G8LBHXi5DICVRMMhtXWSUZUVI2VB8RYbg0nTtKMQxAs0Eo5/NVO7B8Cr04
 hg/l3VfcQ0HCAQKZHyHu2n0fu5ykmC+f6giW/vswrwhVF5sBASndjPYJ5xz0CJxtEDW0bT2N47y
 h3IqJgmCW6hFyfHBa2hPDpCGfgdRNB35cfkS6YK+FXik6k7gZu9r+Zqoz36jxzBK7pBkZwwtpK6
 CjWPh2pj6blLAuSQLS5glF2Lyb7HdG1T1QFIMRtEyX2MCgBGxh/v9wIZ2pUF33wJRLdIjwAvAJZ
 +hbcE76iIskgUouVkmjcyMBtNbR1tgviU35ZUdMZA8Wtj7viIMpEK2uPCSRNLH8CVCf8lzMWAXZ
 8yaDb4EXGauZhuyz8UrldaY2m2v+jpuhmBsYoAiA=
X-Rspam-User: 
X-Rspamd-Queue-Id: A45BE1C0016
X-Rspamd-Server: rspam07
X-Stat-Signature: bmd86o759u55ozxza9kxtx5fcdahw1rj
X-HE-Tag: 1769806870-409175
X-HE-Meta: U2FsdGVkX19+Is77Cjj3A2YTOrCHCq+zEn0pMDNU7ziuv78e4JVy61YRuVUueKSxyYQ8+2SNZ3TMwLOS/M+MKTSMWYpRNXrnukJ1ijMFcG2FBJKF/C4VoE8FCF4gF8ByO4QwxOCtZcLJtQNFXkpik086shog2ZLeyaYw+ladtpKWmmyiECrILFMcKUBfyIP/MqyqDeo3VBwmaXXGW+NKMdMo/NFV/D335h+treIFmY3zzkpZUDZ4YfCYKo/Luwi8DYLH2r30etVaj4bOUjkSwu6asDEPOJ09lwOulf5+txXn6ahCENDoQWR3cW3uv/VkQW8bwQWftlpi8AJvjiiSQe9IrFdUjNAaLlXV4j+wbH3rPu2td3in4kn5Hn5AXKVqHarstCezr5WEv+wTnb5/ElElauNeV5xb9+CxxMANsjGHcuZGiV5U154WM4+8wTpolYbWdr8rHC5vlvnbQaUso2c9cvJri8hi0RxAd4q8DmRVNMUxb+kKRl0h+CrQb2k3esm8auGbw66GWG/NsIeFY2QSHYDJs2ufVx+jagcOpKkeSLv/6J30+Oot03PqxLlQW6T34wsSkTB8nmipcI/Wn7Rheo6TTWZnKXflWwX5A1jagQZ0hP9JxBsicLfGTK0Dcp9nZ0gVZjP9dXBSKFxZ7kiZAZ9WC5WVqLaXSFI9vMkp9B8tV8fTc19OfDrr8f3dZoLSK+nqr/gDNyWxkF6yh5kkD8UMihSBd6et01facytn+QW/Bbyy7hV7PGqKJIGYLGLnGRi8NGQOsmHZACv+v8iwF98Z3DHRyj2fpRXqU7ZbaJcyuxs9ZrnPrxyEO1d4oeSzvUohv/mOL+dh1eWBeZxrp4oYbQgTxlAKJNMV+IMe/zTXMoYfwL7qQg2yslO31nGsAJ/ajGGsiUPCHZ3ui/dlRPgF+/IPlTE9c+tHFe6/ZF32SpTQYr9JqBlsGFTD4xk1a59tIunaVoTZPnB
 jX3CLxK8
 7pUgcLeP/nkQ9VpfODxol7z+I5ITh2gXrZf6DNPKoqwqSbwZvrqf77um7JUJKBXqqoOnsa44BdG+HS/GwbFppkZ1zHZ+QRc7Lka0v7dNl1Rx/mn7reh45g1F7UeZZvvAYE67Z5IrnUBRCWhTIhBdH+3Xgx9EQj5iFz3aydZbkwWznZNqUWiyO8OCEKOXPEYDyiuwYCKRcRDD0u4zwxaeOZwFMQeSh+jjwpDtNscAtYVibJC1V4csEK7rcWSeQtYES3CRcGLi3fDtX8OwQKegHK2vl4o99MwWo40d/h1TGsSq1HWjUZ+4kywvKMSt0QWF5piIalRb7ewSwLVKwjmSbP7uZXbv2pYq64WPXUk+2Og0k3LmXVUVCBmMU+kS8Qj8fsGSVVcBb7H6Hs7LUGG2HGLwSXew6tE9ejQg9t+rarn0obnLHkpDMsTTBfyJRpFPjMwJhfxQP6bi23BOwS2Wgo0VRBhQdbAoNPz4k4rvaA1/OhLcSmBxURTCZeDb9QoUmA2BEjcYFVDuu4GV6IHcGxTcxwzATnSYZWLFGiOWa2VSQG7MMYp8EKL6Q2fUR6P9dJx5ayEJC6RilVQVF6h91NBnSDUPWECVr9M8XSd5IVjekpnGsA9FMsqHr6NT48HX2wI6p5yDBcf8XMCFvFEgeanlND2btDEtVxyox0CD9WqtXdyl+7A/jWXvaHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mas_extend_spanning_null() was not modifying the range min and range max
of the resulting store operation.  The result was that the maple write
state no longer matched what the write was doing.  This was not an issue
as the values were previously not used, but to make the ma_wr_state
usable in future changes, the range min/max stored in the ma_wr_state
for left and right need to be consistent with the operation.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index fb14ce4a49c3c..ab14876bebf7c 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3319,6 +3319,7 @@ static inline void mas_extend_spanning_null(struct ma_wr_state *l_wr_mas,
 			l_mas->index = l_mas->min;
 
 		l_mas->offset = l_slot - 1;
+		l_wr_mas->r_min = l_mas->index;
 	}
 
 	if (!r_wr_mas->content) {
@@ -3331,6 +3332,7 @@ static inline void mas_extend_spanning_null(struct ma_wr_state *l_wr_mas,
 		r_mas->last = mas_safe_pivot(r_mas, r_wr_mas->pivots,
 					     r_wr_mas->type, r_mas->offset + 1);
 		r_mas->offset++;
+		r_wr_mas->r_max = r_mas->last;
 	}
 }
 
-- 
2.47.3


