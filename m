Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E06060A260B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 00:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wisc.edu header.i=@wisc.edu header.a=rsa-sha256 header.s=pps1 header.b=rUKCEgqq;
	dkim=pass (2048-bit key, unprotected) header.d=wisc.edu header.i=@wisc.edu header.a=rsa-sha256 header.s=selector1 header.b=NNoc65EI
Received: by kanga.kvack.org (Postfix)
	id 4B7E06B05B1; Mon,  9 Nov 2026 19:00:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4689D6B05B3; Mon,  9 Nov 2026 19:00:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306B26B05B1; Mon,  9 Nov 2026 19:00:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE8556B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:00:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 651C2A8584
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:00:51 +0000 (UTC)
X-FDA: 85417253502.08.BCDDA9B
Received: from mx0a-007b0c01.pphosted.com (mx0a-007b0c01.pphosted.com [205.220.165.71])
	by imf17.hostedemail.com (Postfix) with ESMTP id E3C2240010
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:00:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=wisc.edu header.s=pps1 header.b=rUKCEgqq;
	dkim=pass header.d=wisc.edu header.s=selector1 header.b=NNoc65EI;
	dmarc=pass (policy=quarantine) header.from=wisc.edu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of san55@wisc.edu designates 205.220.165.71 as permitted sender) smtp.mailfrom=san55@wisc.edu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794268848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2N7XvojXWJxGzTORGcICyZFtbLysi8Gascnnw3ZdG4o=;
	b=UqISpNdSJ7nJS5WbRSvpIR5y/JmzJS5rRH12qx11O5nqPRvoE3YHQyLW+nRwHPj7bvpx1B
	syc069P0peG+N3ja0fEQR8YfaUOMqlUSSXTdGoSWUGi1UZ38oRyVuV7dq1X8mLY9vAjy42
	pNAUctmzCVrO58pAFyXoQmRlBQvAd7c=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=wisc.edu header.s=pps1 header.b=rUKCEgqq;
	dkim=pass header.d=wisc.edu header.s=selector1 header.b=NNoc65EI;
	dmarc=pass (policy=quarantine) header.from=wisc.edu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of san55@wisc.edu designates 205.220.165.71 as permitted sender) smtp.mailfrom=san55@wisc.edu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794268848;
	b=M3gaXdhkL61mF03/iUygLm4hC6NwPcrz/5WsfWVbFEnmliXEMr+sfYUuITvYhYi1FGzCjq
	WQDdwfwrkqYm7s5u9EevOj0j7/H/Nx+a4wsA0dGKAEbM1GbmtfEY+KoY2btHUI6/BVy/t+
	856MRrGgRa/t0lDY4PTQigP67U0STgY=
Received: from pps.filterd (m0316040.ppops.net [127.0.0.1])
	by mx0a-007b0c01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A9L7LHo3196546;
	Mon, 9 Nov 2026 18:00:12 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wisc.edu; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps1; bh=2N7Xv
	ojXWJxGzTORGcICyZFtbLysi8Gascnnw3ZdG4o=; b=rUKCEgqq4G0ykBz1/RWEd
	qYUKh7w9M7p50TPJLUxjOJNdIwkVwSUFMLEaN0VkZjKD9p/YmasO7+HUOgMSMzLf
	72B3Prs2GvHX3A1BI5nh3W4Wh1H4/IT/iCUj13oNfleT84PnqymndND66xjCPJwF
	joRiDuJUZVq7vRWA0UiLVIry1M3WZe3VNb7yZ2u2Ut8U4Mg8ivLud139GE3A7Vm/
	ePePi7WPCHfRzIEkrBBgFLzkS8NzfCKijOGzO6SIsvrw8Y3t0NENlWLA46tpd3C6
	ld8meHc0aaLkz7fukZtc5li7bcpv7jK+hT28e2POIrIXuGnCuVHgavTpuxOMNln1
	w==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012069.outbound.protection.outlook.com [40.93.195.69])
	by mx0a-007b0c01.pphosted.com (PPS) with ESMTPS id 4humm8hym6-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 09 Nov 2026 18:00:12 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V4XFI9+l0iC1WwkEKWZrx1jfTdgT5oeK38fHIlHk3dYbgIEwl7gOkIzgav+3g0rj0Nk5HW8lGKRqxtCLXry4vUwIdpIEIGv4EjokGlHfBr2r6zY8c+lUEXipgEuuLwvDgy50HdGgt1AZP+kWNrRz0bUatQ9c5fEguFlNWwq0rwQAaMFYAH2VgroDnpiTH5U+RjE08t2FWVODJvbsNXfW9sq1mRf7k327GxGVfkUm8m/Ai+q3WySxMYdHpjOLoLzqbPnRc0XJP9xm04MIjWOgfyFqcr1bHtIu+4jBNm95sqhmJ8PrQi7VQ7/+xbF9B1WWsXZu78Khm7B+07MKnU7W7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2N7XvojXWJxGzTORGcICyZFtbLysi8Gascnnw3ZdG4o=;
 b=Q1LYJ0caAMznAhxYFulDJU6djLpVFu6YJsQNlsrZB0kcxgMjRrBzMLUUzXoaA+hipwOOPVvXsmCuh8EmgtY8196O1QS2aupj+ysb6za99a5AemS5KszIP4gzn0FjmTNuBrTEfKGEmUFdcyXHWFTMSCsmIjj/bHC9eHnSRtMZlqTUoCP0Er72rV1gQFESh/vw/WfTNgDO8Yx521NtZrOHuD5GhDXNGpt/sgPrGQBgL5zTXG7HqrdEcuAQHEx3CqtmRqi/ZN7JPHcMAoyF4HBQI+gwdYtuRLZDfgT0lsRZ0MUvy9+lWTEUtpY3yCsK6V4x+Y804lmkYm8z+HaPqShQzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wisc.edu; dmarc=pass action=none header.from=wisc.edu;
 dkim=pass header.d=wisc.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wisc.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2N7XvojXWJxGzTORGcICyZFtbLysi8Gascnnw3ZdG4o=;
 b=NNoc65EIFQfJMAI04VHN8AvF2thU8ZZ+LrKRbYySPGJOpi5ofLS7tVUwRMD1Ny8226flomSDo/97rZuZRbTiSw/6QDDAc11769ceMpLyOlTsAe7RcrqnzFJCaudhTfjNQuK6tfqFsT8E8EVrd72i0b8aKd9GhkCHSXiGFWOzy9klhAwkqIh/cx5mhST4wAOKzEv1geuNDgd3kA9f9A29sGInSPCbninxXFZr8/Lpfv+OVSboBJtIcQAIAz8d/qaK48mEdcmp5hlpN1/h/YmNYAG/CVU/sJWS4kfcVGsMlPn9HSLu0BWCU58b4quJUicL6ZI0xasiXD8MWa3OS7FglQ==
Received: from MN2PR06MB6639.namprd06.prod.outlook.com (2603:10b6:208:20a::22)
 by DS8PR06MB656475.namprd06.prod.outlook.com (2603:10b6:8:446::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Tue, 10 Nov
 2026 00:00:10 +0000
Received: from MN2PR06MB6639.namprd06.prod.outlook.com
 ([fe80::c7c1:6e17:5f9d:1245]) by MN2PR06MB6639.namprd06.prod.outlook.com
 ([fe80::c7c1:6e17:5f9d:1245%4]) with mapi id 15.21.0592.010; Tue, 10 Nov 2026
 00:00:10 +0000
From: Seunghyun An <san55@wisc.edu>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>,
        Vlastimil Babka <vbabka@kernel.org>,
        "Liam R . Howlett" <liam@infradead.org>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] mm/rmap: use vm_pgoff for anonymous VMAs in linear_anon_page_index()
Date: Mon,  9 Nov 2026 18:00:01 -0600
Message-ID: <20261110000002.1834454-2-san55@wisc.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110000002.1834454-1-san55@wisc.edu>
References: <20261110000002.1834454-1-san55@wisc.edu>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::11) To MN2PR06MB6639.namprd06.prod.outlook.com
 (2603:10b6:208:20a::22)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR06MB6639:EE_|DS8PR06MB656475:EE_
X-MS-Office365-Filtering-Correlation-Id: 16a5dd4e-e7af-4aaa-31e0-08df3ebd9678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|786006|56012099006|11063799006|261021123027099003|261021121427099003|261022075727099003|261022105027099003|261009223027099003|261026121527099003|261026140227099003|261102123227099003|261028144727099003|22082099003|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	DK22kIKnJsb6tCa6tH4XzfTOomHK6uK/C4VoqKBIsLicACWJPJ88uv4cv/u3lPJIsA0IckTeehjapUBJvv2MDn8PHfCzhj4bHQRWE1rpAc4jhPdD81wLVMzPCpqXrEDwnE/+9cHBTLn2SHLTtgyD1Ocqym9ZG0wmIJ9nqfwQWf6oNxt/UaCbbR52/HqtXwDt1sJMgLrGfOh/caUbBCFV1skddv+0AzABZc4qN01bsVDnDyLQQMKe7XBpGBlqRTz5SnDlg5G982EzaoeQPZ6CR9HlqVKyrdS4orqxCGo0s8mWK8jHghYYy9b5UYnWnJqSgl/HUr9drldL61W75W3iAAHVaIPmBaG+2ih72mV0IvCmzXT88/m707N2KVQLmlr4Gh/KPXV1lt1xVUBydG/LH7AIWeMOxun29H1QbX55DXBegwPBKIWkm1qm47MZ+L79Kh2r1Qm2TlZr8pLOlL1CyndLu/lHcN+mbhjbsFIwJGQII9BtBZonTF9N3jExW7WQ2Vfqcx/vUgQCxSMFp7Jwf4BesSpXwxYEGIZ/S3tjRtgWpmy6jB7QiDNZFYu+xoCWyUUEInjXLjaQqZIa9HAexWOXEff5JBujI1DsSGksQMsoGuuEl8TmV3PJTioE7txBhhWPd+ybx4fONfwFefvevGDt2BzVqD5YwmJGLqDgQ+o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR06MB6639.namprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(786006)(56012099006)(11063799006)(261021123027099003)(261021121427099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026121527099003)(261026140227099003)(261102123227099003)(261028144727099003)(22082099003)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DDhBwf/n824Unam5kUk9kGaK1QC0Eb6wek/JTKq8pt8aoG+2UlxB8x3IVq9B?=
 =?us-ascii?Q?aarliqqJuoWPqW8Hf+wFTgfK0LWg9XADswoeUZyHf5rYOxcg1Maaecs2H9au?=
 =?us-ascii?Q?lxt0a3yu1UAMMD4iL6Q6nyUoD9N1HPdwxJZzJP544OdlNyPYDIMK3AElB8GE?=
 =?us-ascii?Q?pPwIwv7C3Jwf00JJQJIQFYkoG/7Lf1L+IEIWC1hp9/2zW2wQKemi1Cg5yJR4?=
 =?us-ascii?Q?Y0mo//aMY3ChvGJgnxuhdw8qdNSFjYTtTRyknXeIj6I+M4c826lJWPgOZyId?=
 =?us-ascii?Q?2bezjtuBJnhrmyi5ixV1YB8jNX3gZNNJE6j+fAw4yO5Rh+5qEX/H4ur6uVTI?=
 =?us-ascii?Q?7gC+vGfm8MmSxuXTZ8kFKirTxmq6E9kDPlK3n1HXZKdpW79LYgGDBFyuEka+?=
 =?us-ascii?Q?a7NWPsOOOMF49j8ve0vXAnp6saUZKZ8+4+BZdRxn2Yyhp4qpQXj9AdypghrY?=
 =?us-ascii?Q?tzr5/i4VsIFY59Nwc4M4U/wI4lJ0R/mhg2YLEAs0q+VxofjSYrUL6MvlIWq1?=
 =?us-ascii?Q?pn4kRKLZ80TPOOn548rfegIe6mW60eMY1ZXQX0SGw2b+bPpXNELPlmcfXJ1A?=
 =?us-ascii?Q?ScMonO4w3aFA1a1baB1WGMysKx58XGvuSmx7/u7OsV0tbrGkw+qVz9NbEd8x?=
 =?us-ascii?Q?VydtncfUC+eYx3X7RzuRH7hSHl/E54HRQJ78v+l2w5QbtuaJj4ydr2sfhfc5?=
 =?us-ascii?Q?EuIzKBdu6oRxH0ZezSkeYgq5oxetdJZaRQ+YPS4yzJRNyt7JP7Hsk+hUsxF6?=
 =?us-ascii?Q?auh93rAi4jETiBUk1BpdvyZjZo5dFGZsdYEV6fu+4aJ+vIxzuNISjotBptAM?=
 =?us-ascii?Q?a4Nb6Z+EmQrFczSBcGsY50Lz2yVbJ1aA8gQu9nmvAc9Kwj0T7TWWGcITf1Cn?=
 =?us-ascii?Q?aGlMTAWc3rO56ZcI6RwH4+jwdUNB413MOP7d+mmpGk98EKeJJ1+YvjZdpY0p?=
 =?us-ascii?Q?ICy+ivyCbhxC6uVQ1mSy8dANdGS/x4sMaXs4atU/eJ1wWu8J1krZ+muAPVyf?=
 =?us-ascii?Q?JZgPuLhBczVFhfRwkMe6Z6GSNZf6jj6UVugvSc+psH27+liB77YOp7iqurAO?=
 =?us-ascii?Q?hKoQq0jHh3dKOyce7nKGM2CO8vPTzmOouKMsG7zjctP40fMDonoVokGLB0Ad?=
 =?us-ascii?Q?3TL/95w2M6tIbYZm7piZVLhTbLzbURBoO+fygC8J7h8T39T4tifq4C21o0bv?=
 =?us-ascii?Q?fOkdxTvN9CYCCfCqL3HccrekO5N/zE09JgFjY3TyVuvVvyMJDj+It8W9OGYE?=
 =?us-ascii?Q?3o8qpwkojwq67BnlLegcPwgm7AqnFSrGz59tjYXkjXUzBz4m41omWPh6LS6m?=
 =?us-ascii?Q?WqJh+V80y/Z/gcYEWm1uuTkx4F4h0FApCl8XYYOXH0zeoCGnCB4iMkP6SOaR?=
 =?us-ascii?Q?EktstUZfVxKbz/qy8davGpml+klGUQ51+HGYDKC/OQnclSxZ819qjhGUvwHq?=
 =?us-ascii?Q?RwK8tr/hl2K5D4l/kwYKVhtDX4gxmRXAdybrw1BCMrSNkS+rIhsgLlzbj6mj?=
 =?us-ascii?Q?NGEn9+nvQSJFKJVJL1Tz0xygJDMTq1fWzQ+1fZR+xxameUyFnlsIaYisDyyh?=
 =?us-ascii?Q?Y7rrv1hkfgIkN2iEYwoR/1Tn7Mu0iDRp5ynjyBO3FBUE4TEKHirj9LuemcMQ?=
 =?us-ascii?Q?tI3Q13jmdUZ28xw7yui0UpKtH6bKBg1nVIDt4Fkgqx1n3Y+3OZQXeiQ3vFF3?=
 =?us-ascii?Q?GTFX5NVGh5IvaCRHvSSHPCP0D0wnuzdSjOh/wOitXE3z1wUY?=
X-Exchange-RoutingPolicyChecked:
	hL1oW5QU+p6LR0rd4VSSs9Cp4T4RmK30yeTIDRaGEybMjndtfMGcEYari/5ISuja01lQE+V8PCrfxiUSM+r2sqcnG7jits9+uIEiyJ7tTxL+KqniDtUqZTZTjqoph+69B+Awjhl00KnNkkSU3OsDhRuJU6EX/mZ4zXxiyJOiGUcxX5iO2mXICkGEHgo2tYMHB+jPl4n6XpV/8reWIR2EjP5wR2Q2bDfQt6Nzw++F7DlpKbvBHQMq12//uLDGiRpRPTkrYdhzeCpWvTj6/s0cF1IP6ztjomYzFM6xjwPk88teNIPI43kK17xwQHU14gwacL6VyVu9GuCmQYJEX+szWQ==
X-OriginatorOrg: wisc.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a5dd4e-e7af-4aaa-31e0-08df3ebd9678
X-MS-Exchange-CrossTenant-AuthSource: MN2PR06MB6639.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 00:00:10.5132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2ca68321-0eda-4908-88b2-424a8cb4b0f9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sIZV7Hny8jINwhaOWlF4bf5HQipwIKn2VxGg2Ev4ShqQ4kP51UT2gZ7RKCe8fcCA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS8PR06MB656475
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA5MDA5NSBTYWx0ZWRfX42VNvVEqR5+a
 8Ah8mhTktsIpUCMaeAvVS14v+HD1HELYAWxWQfNEq7Qlt4hRKuZ5biezOvrxD7Qf2HJvr353U2Y
 Vcqdf4f3ncuAPn+7Ae7z3bKpA1vf8CI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA5MDA5NSBTYWx0ZWRfX9SVuYtm2v4n7
 zntv6kQRQt3wg/usWwrn9cRVWzJ0fOt2U8EPvcIYTgN+pz8ly/euhF7PCqRciFIT6GtlOYdx0n4
 rHYQtBAUi5Sj2ncPOikmA0vNbodrsS1ApZjeYL5+F1foMRKp2iu4NealR30rKi/32iR2NIDeX/7
 rX9sGsWEsBBE9fSOqSL2hnx/mLTK/BmbQz8PLXVvHTVFXmeU18lvb6+BCtiZ1BNm/rcRmB/vfj2
 g5k3WHszGakhM4zgotnu+B4KQ/yN+8anVLNovu652us/VLjZ+96/35R+SoU8PGy9zzrUHvWEbQw
 MJ+OSfpLj7XhVOqOArQSYvKEtE/X1/vjXJf922zajf5TLpGnyyiN2PabAn2eh4H1B0iRnQlVhRi
 iImMDqRDKlmGKTKWdO+J2IFwBOdRcIuEtxhIEiSkeiw+k3Jcukkg1wjHYbQMfjG9BTZr2Vq1T6N
 ERoUyQl2ONaRBXATS0w==
X-Proofpoint-ORIG-GUID: uZ1b3VBmI1nphSKbOC3Fsz9ATXoO8cld
X-Authority-Analysis: v=2.4 cv=HtDjiETS c=1 sm=1 tr=0 ts=6af25e8c cx=c_pps
 a=LyZwXkN/zJaPlZXKe3eCLA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=U-hppK1rdbEA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=ZyELlZqCvD1aXIDzc3I-:22 a=-L2uzytrI8BeDALVFixt:22
 a=5ZOWImBc_jjzkh6oSOkA:9
X-Proofpoint-GUID: uZ1b3VBmI1nphSKbOC3Fsz9ATXoO8cld
X-Wisc_ValidFrom: true
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-09_07,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 clxscore=1011 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611090095
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E3C2240010
X-Stat-Signature: 6sooymfza5r45rimjpwryctrcb86zeie
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794268847-436339
X-HE-Meta: U2FsdGVkX19LYeV9zI0tfIR3VEDHJaBbA2rAyJVWtlQylhWrneb7PFraVvf2ehii32F8WMw1+dFjqtltrQ164I5Rjfd0GFnpmbBCqptKlFzyT8y7b0fZmom7SPy26OqarW2hOL1wBFJcldg8vRVXgb1RJFGIycDYhlCG77LiThalJi0o4boDw4wSUYQ1KuBx5a4moVukPy6xVTe81z/nVQv+rKh7ktnvsp8/ppt7xgP4CMrE0YdE9XYbfRNHiib4p1UWJ1wyFzUZwEk8QNXWSA8dGg5jAqKB4Hnx3Ga+T6UEKEcCpAiXJGk/wvgENxPAplqMzEOfr9Zbx/0FA0RCEFplMQydcnsJW4ao6iZrafOIxU3R3pFNrwCOmxzdHaIWu84s4KO9ipP9Bsw51k97Q2IisZ4HptxJUx4SSCj4GfQtfGVRX8mA9kE5/LpsFMUycno4+YlUYrWTUeg1Uao9TX2ja0DBve5q9FtAFnY3zwNJzvyUh2sR04gJlEVtEshuuqqc0Vkmsqf8LeVQ76IuOf4CyMVXELnPlxFmc+zT5QpHE69FH07BkJCAfH+XEEXj2MvZKHasBA6GfwWkrCWjsLDMgbbAr2dA0dlVXBcGWhY2SGucgVPlV7kKUw+HG2/9Ka7tHdp3NwIOlff9NqjRquZMRG4ukuCbh09LgSqp5zyHO7xrFfxypMKFh5p4kX8Wlbz9+eH+pMBAec7CXKpYKoMsc4oBK1Hwt1u7/70Wu0dsORD9KLUZFh/0PoTo1y4vExg0u7jig2p5YK+dlb6OJoZ1L8fkl7OK2fdtei0M718+NP33VgK5YVHJGUAjtAo0He/EA3Y36iO1FtqyQfFuaUikmVo2HuRvLU7z07QkS/wyBaEyK5auF/ysPWFjs4LvJjy3OhkWaeuepKRzn7YIlof3LySaHQ8AXqzNpecJpsRYm7wXrE56s3Sndxk1VSlmkLqdgm77G0B2A8SY41/
 5TYXqw0A
 bXnUM4LDvMWcbx8TDqMQvDxv5sU6ezxNaNB0TrHrosihdj+4UMZID0ArJPxlr2spevBDeWLFvzptVV4Uaf3g2a3Au91xp5Kdq9SSZ8YY1NWJsBgepPf7ec4T1mLsxlEKc5ZSPEqeq6JxGt4+Eb8CCV4ltoa6t6ahR3rHEQtUMk4fywiiSGpoht9GNlNj4ger8K0H8c/IuDOovGj055+/ZPf4zpT2Lo8BYGFcZYPmyfOl6r7aL2h3D8ZHeedmrLC//gkU8k+s9WJR6StnMleCk5ELQRpMO+O8JivGfQTHGXWhRcx6ddr9sL0ek9MG2Ms4UdOKoZYc+DObzXLRVwmSS5tmejDI+vkYl4K8Uv4tMZfg9RXc9UrdTHvC8YZKRPoYZnzgpjwkpwIqo0Q6PuK3CKAWLP3HRCkJR/WMLDg5vp6D155eTtyhE/gIDASjXb72xOo6zaUlx/rcVikZMEJH+9pi2uadfo/9nJA3PIcMiaVA/dvBoQM5pEiHqzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__vm_anon_pgoff_hi sits right after vm_refcnt in the vm_refcnt
cacheline. Since commit 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track
MAP_PRIVATE file-backed anon folios"), which made anon rmap use it,
__folio_set_anon() reads it on every new anonymous folio, i.e. once per
fault that maps a new anonymous page, between vma_start_read() and
vma_end_read().

When several threads fault on the same VMA, the other CPUs keep writing
vm_refcnt from vma_start_read()/vma_end_read(), so this read often
misses and pulls the line over. The extra load can force a coherence
transfer and makes the following vm_refcnt updates more expensive.

For anonymous VMAs the anonymous page offset is always equal to vm_pgoff
(linear_anon_page_index() already asserts this under CONFIG_DEBUG_VM;
it holds for MAP_PRIVATE /dev/zero too since commit e59c9a971a9f
("mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous")),
so compute the index from vm_pgoff as before. That brings back the
pre-series behaviour for the hot path; MAP_PRIVATE file-backed VMAs still
read the split field. Keep the assertion, the other way round.

Moving __vm_anon_pgoff_hi out of the line does not work without growing
vm_area_struct. With e.g. CONFIG_ANON_VMA_NAME=y the struct is exactly
192 bytes, cachelines 0 and 1 have no hole, and the only 4-byte fields
that could fill the slot next to vm_refcnt are vm_lock_seq and the lo/hi
halves. vm_lock_seq is read before vm_refcnt is taken in vma_start_read(),
so it would just move the miss.

Measured on an AMD EPYC 9634 (84 cores, 12 CCDs, CONFIG_DEBUG_VM=n), on
mainline after v7.4-rc1 (the base of this series). Threads share one
anonymous VMA, each faults its own slice and zaps it with MADV_DONTNEED;
faults/s, median of 3:

  CPUs                      base      patched
  1 CCD,   7 threads        2.360M    2.369M   +0.4%
  7 CCDs,  1 thread each    1.738M    1.982M  +14.0%
  12 CCDs, 1 thread each    2.288M    2.548M  +11.4%

On 7.3.1 (with the 7.3 variant of this change) the same runs gave +1.9%,
+16.0% and +29.4%. There, perf c2c shows the folio_add_new_anon_rmap()
load at offset 132 disappearing from the vm_refcnt line and the average
load latency of the vm_refcnt inc/dec on that line dropping by about
45%. With one VMA per thread, or with processes, this patch alone
changes throughput by -2.0% to -0.1% on that base (less than 1% on 7.3.1);
the next patch more than recovers that.

will-it-scale page_fault1 threads does not show the difference on this
machine: each thread mmap()s and munmap()s its own region, which merges
VMAs and is dominated by VMA write locking, and its results vary by up
to 10% between boots of the same kernel.

This relies on the /dev/zero commit above, which is not in v7.3, so this
is not tagged for stable: without it, MAP_PRIVATE /dev/zero VMAs are
anonymous but keep the file offset in vm_pgoff, and must keep using the
anon pgoff field.

The tools/testing/vma copy of the helper is updated to match.

Signed-off-by: Seunghyun An <san55@wisc.edu>
---
 include/linux/pagemap.h         | 19 ++++++++++++++-----
 tools/testing/vma/include/dup.h | 13 ++++++++-----
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 73af18a373..300ee83fc1 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1122,13 +1122,22 @@ static inline pgoff_t __linear_anon_page_index(const struct vm_area_struct *vma,
 static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
 		const unsigned long address)
 {
-	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
-
 	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
-	if (vma_is_anonymous(vma))
-		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
-	return pgoff;
+	/*
+	 * For anonymous VMAs the anonymous page offset always equals vm_pgoff,
+	 * so use it. This keeps the anonymous fault path (__folio_set_anon())
+	 * off __vm_anon_pgoff_hi, which shares a cacheline with vm_refcnt and
+	 * is therefore contended by concurrent faults on the same VMA.
+	 */
+	if (vma_is_anonymous(vma)) {
+		const pgoff_t pgoff = linear_page_index(vma, address);
+
+		VM_WARN_ON_ONCE(pgoff != __linear_anon_page_index(vma, address));
+		return pgoff;
+	}
+
+	return __linear_anon_page_index(vma, address);
 }
 
 struct wait_page_key {
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index dc4927d262..f3d69b0c74 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1655,13 +1655,16 @@ static inline pgoff_t __linear_anon_page_index(const struct vm_area_struct *vma,
 static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
 		const unsigned long address)
 {
-	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
-
 	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
-	if (vma_is_anonymous(vma))
-		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
-	return pgoff;
+	if (vma_is_anonymous(vma)) {
+		const pgoff_t pgoff = linear_page_index(vma, address);
+
+		VM_WARN_ON_ONCE(pgoff != __linear_anon_page_index(vma, address));
+		return pgoff;
+	}
+
+	return __linear_anon_page_index(vma, address);
 }
 
 extern const struct file_operations zero_fops;
-- 
2.53.0


