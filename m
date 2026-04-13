Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 125ECF531C3
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5136B00C3; Mon, 13 Apr 2026 15:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC7F6B00C5; Mon, 13 Apr 2026 15:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ABA56B00C6; Mon, 13 Apr 2026 15:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 598796B00C3
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:23:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1ABC3C1624
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:23:07 +0000 (UTC)
X-FDA: 84654505614.13.A1EBDF1
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012061.outbound.protection.outlook.com [40.93.195.61])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4C3F812000E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:23:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a8Ww+TYU;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776108184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PyHzfYdAcd1o4K499pb7pf/Ryc6UfaIgPSO5VqSG1Q=;
	b=hEbV7QcFyqFFmo3DjOZxFRIGB4z9J7FCo7OOzZLiztd6lAws4feKdua7ILNcE5+K4CTAxj
	tusBYfgHUkgLvDfCy0HVldmW/qS0TEKVDiSAFo/lPHd1aJetctkIWC9vSjXGXmNg0ckuXz
	uK8HT8eUBsjJ1ePf86yc5OpiDa6ic18=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a8Ww+TYU;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776108184; a=rsa-sha256;
	cv=pass;
	b=y2U19VYpFsE/caTcsimFpNqbnpVYeWBUV0i98k1MzEeHhV7q81kKPysNyt49zQ9zUL4rSb
	O6iXCCExS5eqHJ/YuS47/WgsRRz/MQa78VOUD72nAKhLJt+BaLOd7svWx8PSwLY/oTiDA/
	JPV5Xn+25nkBYIoYU2ohI9be08E1YVQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QFKcZYbtBFZoLabneBqewnkp3blEQStbZGfoduOwRDHKoOHUUanoS/A0ccF3N6RYRImd0Qz8iTLInjQrkJPUvBqSXYGOT7jEa2nTeuhngo7ItcrUmZd3xZ8h0yojbOthyL81HK1DZeSbDle01OlDdsFSjfuN66atSlaMZVujVbwnv/PQ/Ox1BBeUtzOadQFdMPovnx01DoTO9Sk7ld/xrgdgFrbnkVGa+U9SqiUsKen1CMVgBHBqDNXpE0vg8M0oHsVkv2dBTFJyAnRB0sh0N+iaHlTiCDTTXxN5s6QByjtP9dNRQ5ASOHN39L8yWtONNnX6pApWv6UmrjlyF8MZWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+PyHzfYdAcd1o4K499pb7pf/Ryc6UfaIgPSO5VqSG1Q=;
 b=ebnqLYHWE66wB2XcY6ZvfC9hxZR3+F8sD35Zw4n7KD/17MLJ8pKkkNt9kxoDktexyWtGcUklSX0muI6bGJL5MmPekGcbRU4W8r0zFDw7rLd2cYzfns6b7W4d4YGg4yKp7xOi8UysGE7QQdb6XhxPg1vialdGks7OMVVPDSDSXuEMYpjOAEUMKGfqpOHo0ERj3+GkJX3AWut4OESutavraEltoSHjpyug0KvUaRHEuJdPUG1Pfyr+BxMmFylyJatkjthQiyGoM8aMN7bc+JD5xKt54yROQqeCujHta+t0Z0xzLxft9SpEHNjNYaXSPL2I1IAliY1A9fOw7idcs6hyBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PyHzfYdAcd1o4K499pb7pf/Ryc6UfaIgPSO5VqSG1Q=;
 b=a8Ww+TYUq5FbIxgweRwiMGoYuJPrMVPqaOoQCTv+ILCycjQtWktlfqWR4ws0fe+/t0u6pvFtivy0Fr1tV4dYu1M9k6QF0TuncvPgpGnRNL1tmcdyi7tdIbzNYSaMuldadg+skDs45pePvfRL+6X4JVC3Y0h2XzapAeJgPMTtK2UXxoEuWcpDLaWZpVwtQWsw4+2blxDs3zdAmKEb37lDX663HXPKgqxMFMUpUm6583pqT+i2p85T6uIuRzRsY9bkrbuStpWj0I0Sld2d+LzY6FVQXvn8arMMJCVWkb9/jj7EJ2GA/XBf9pRDzQG72KYf98wrQvbBDCoIES1EgVgkiA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 19:20:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:52 +0000
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
Subject: [PATCH 7.2 v2 09/12] mm/truncate: use folio_split() in truncate_inode_partial_folio()
Date: Mon, 13 Apr 2026 15:20:27 -0400
Message-ID: <20260413192030.3275825-10-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0006.namprd19.prod.outlook.com
 (2603:10b6:208:178::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: 286c44fd-c02e-4699-b007-08de9991c70b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	8ymQvvPmP1aTw1psNbqogMstwcyt6kCxjfnfUeGOxCuWPCZlwyhcO+U6w1uLD9SH3B2+j6jhTtDFFeUmH9Mwn/N9IuN7xz2wTvKRA9kmGT3hoYDozoR5wW9rIp4tgGUP5m+iiHmJutqLQ6N1cXro7BIpQ2Sd57pOcfwiqdHWWAVrcq8EzZis/YQIdrxPPqXp/v9YDJbxlaXbW6ERETVHPaEVr6fD3oZEy4ZlLG1M/FE/YEWRzBCSYArp4x8fmDoWyr9aakyOf7fIcdPEfEVYYMaQWSyL9bQffZZp8vYPzPgFaty0UUR2EcJoy1zGSAtIO7FgvAoXddLuKq/nP+g6pQw/qnBrGgJ/Nh796LdBEb9cdClzbwOaklR3TcPMwBrrKPbHsC28J9m1c5HcLxRrwqvNsCwrnzoTpSJRDCtjHcQDGU5lixG8wbCsGF9ruJRqWNRPmBNQreyR+dG4/lPs5uAhIfIMvsdGLPNYSe4ZLJo7kCtH0t3gpkWX5gFTxpqpbwAv2uzQS9SlLMn+zUe8Z0M0MGKU88us8xWDURPzAXESK2GjzZvFCJXPwGbVrvZG6Kxqyev9KA3jOYrcyL4YzCCWr905n2Yrsnx3srG2SQDYx/oQE9JMlDMIWKrT7XtvEb9bA5c60tcaPEFPSG3yRynE89zST0ZB3bPcUKp0kDibGK3uGPlXEhG/eELp2Xk7qa5GNtwfc3K4cG6qM9NaJi7FY7NHQw+N3q5L3orshDI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xAF9TigT68TP2dKrf+UsDBtuuz/UHoCG4oZXV7mfnKwoVpDfrFJGNwyDIjsf?=
 =?us-ascii?Q?OVmdrxe4gudr/qNso6PBurftuPsphg2m7VPqmQrrhf5sxm5zURc2mCEoZNR+?=
 =?us-ascii?Q?/by8sknTcRq4LSZCzcvkhGdCyehfnjsj/lOoJPmfnpKgUF+/bIxqvA+3FWeH?=
 =?us-ascii?Q?jtIWgvL8UPIohDyk0KUXYa07uVkTqaqLuQnFD5Dx1c23UAtUUO13F1vMwx88?=
 =?us-ascii?Q?oOnrTOHGHxE5g7irLCYYFIXPYrZLFpw572pGnKjIvMDPQGhlf67sC2n/QdxM?=
 =?us-ascii?Q?KmaQdjpixkEDrztH01HjBRJLEtrit7KEUFT5UlYlizlA85w5EFotfb616dEH?=
 =?us-ascii?Q?ODEpJWgSgfErCvLiGEND7B4x1M1vtdWBbmFjeiAHa1XZarJLF7rLxXUPKYzn?=
 =?us-ascii?Q?F9wr2WjYnnDYygq6LmmRvcWCpNLYHNHO+MV3V4O+Dhyne0UBRfdiqf9iGNiA?=
 =?us-ascii?Q?H3uiZBla49fVFPHh1XqjK29OoYyNcqCV8s5cWyaJfO/nyd/SmqBr2iVZcE2A?=
 =?us-ascii?Q?b8otvgsWhwba/fVrq9wGLGfsbmBSkZVgteUUapC+IK7D9dQBpKcIwOSBhqkX?=
 =?us-ascii?Q?zkct0mGT1NFgRTXYtgJ5/K/DuXTnCa9S1G2Qv1i4r4fUGIjUxnS23lAN5LAo?=
 =?us-ascii?Q?A2L1RMPtfP/2X+pUlBcC2G1fHODMVdUTAyIEFVM6esjQzpgnZp4bYQMs6Nua?=
 =?us-ascii?Q?+mGS3PC3QtMgztY7x1/QkWvDk83nVo2zQqKLegiT9DKUxL0JdfQLcUrgVtYP?=
 =?us-ascii?Q?TFtIEiarsz97iwcsyg/PIjwE6FBei++JYzQO2FQiTicS395JZ9WOgawVwcrD?=
 =?us-ascii?Q?wJ3HXytpK76W/mdBEPoLlTo8OVsOxxsKazqT4++UfMMtFMYdd24xXk5ba2Sc?=
 =?us-ascii?Q?enJ629FeRWIS7c5wt9ES4jcJiGTtWZzI1BSjTuzYNi1jeFK1/mrHafnprBH7?=
 =?us-ascii?Q?rTJ/syZTdCnJ4klDjbOItzK6Ifj10YYDP9BKixnJ6EohfO6tM+IzUmXzgIJP?=
 =?us-ascii?Q?cAyjEYMO+1Dc2V3ViC2zh1Za/akYDpmSf/woRkqZf1B4Gw8jQkyWDTLnRfiz?=
 =?us-ascii?Q?CVDZxOYlteZcBlt6pGMT+QLXLkdmQdzEBOyLfym0KuI+2OTcPtezlvoCiVFK?=
 =?us-ascii?Q?EcOfUCGSzjyV8d9X/SSrDH88mb6GTYOv/DizzQ101CtmhzNWi6mRJpy8sCrJ?=
 =?us-ascii?Q?FN+/tDqXcf/uEkRudYX8bcKoVu+atCnn7e+5Og0fckgEgVcYAIOM1EftA1t5?=
 =?us-ascii?Q?pqOOFD2TVSYKp5UcfswYRyz7tMsLz8OBSMm7QtZOrKWvuCa97+Fc1cyphrxw?=
 =?us-ascii?Q?v2LhFbw9Ypx7f6NjSXxibkpz2Qrqwue+6/MGpmA8aJIB87EQryCD1NS4s5Vy?=
 =?us-ascii?Q?SBPivGWCRNmtw4BsRk+36pYQhnIMlrPeuSju5k1NK0N9fiPcmAlHVQoavYFY?=
 =?us-ascii?Q?z46QHhjCrza2FvZZ4nTrZkZhcWMtViAdifP7HcHLoxvpaqD9WgVCrv5qJc2N?=
 =?us-ascii?Q?QyIsNXNHsQw4KGQWVx8r92sFx3xZ9knyPMVgNUCmJ2EelVRHRjVBqUikhmd0?=
 =?us-ascii?Q?jPBE83pKP9fwbQxFBrWDvNt0OZ1nuwisRIfdUMruw2tFVZH0RJTngclVbxR8?=
 =?us-ascii?Q?zHOdX9ZFEiDR8COkxMgfTQfarpZLZwDEVzD18CN/EWjSmC4J30sn55N/wDWl?=
 =?us-ascii?Q?BbZs27zk3X7sPcAt/G24f4pRkbksbKVA/Ieoo+E87lNGD3yk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 286c44fd-c02e-4699-b007-08de9991c70b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:52.3362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XT2ZEk8vIb3qMbJH5+gfrb2OTgoRCsP7idaF7urjPvQJk0siXgJhREHTMEFFPEsB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C3F812000E
X-Stat-Signature: oozeboejmdc8y75owx638zb1y81yhrk9
X-Rspam-User: 
X-HE-Tag: 1776108184-443711
X-HE-Meta: U2FsdGVkX1/LVXLzPyW6LtmuJFq2TNTEHNpQAZdwLSiejAwyi5u4gLq0dvZXJBhg9DA96DdTacz4XaH7N+v8AooI04xl0skXzo758L8ezgKUjX5fuTvumpqMrGpYgNxyfBTwPggOewy0WoeptGRl3E5lac6im/nhB8RI70Mg+qd2UmbXNni4CwfLWRFvpNSuqS0dkBJWZatVyb/ViF0y3bCyrnM14K5DZ0JNh488XqeOtwqTPphKbL1klQlEmBJiBt1jIqVHwO6M06aFb4onP6shJF6jH5keMzS0f/UddI0ZXT0t1Ka+mW5556F4rqC+31aitFjJ1TPc3kY3q54yHXU8cbzZqInA6ZkmICqmiSWc4jUKe4h5jA4rSwYSqyCnUAxRI6K/fiK6UhnPmC1S7RsywpSpGL2qu08BB+pdAa3kxkALiSISmU0mMQfplopcZ6B2Y1Z2uJjh/Ax/J6d/94G4aFEQ2OOrNe318tyh+ZUaaW5fqQgO+H0TxIhwZ2HAUURqjFaSMpHL7Mp2NFZKH/hEX01rfwzEqwy14Khlp2kjZ13wSN8YYYnht8AhtBNknyzAvyYDbBh58TKutWG/sCig0PGlsM3gZ/ml+eLG6lyPDK1w9vK/FIreSq5FdzNe4dliCvfrUJvUPo6ExttJMx6cOFGauuFyGb7So1opMxQ67OUu1uv+Af2FFfOqaqKTOu+5rFrQ3jqG1geEZXZX0W2eWa9KUiHfuWJ1KcPFRgCqA4mVlEzeI4msgFKWLOP39D+6ytnGhFUfuzgr+yapdCQi/YREL+kLBruL09wKnEZEOSfiL4M7qIjT/2eiZN5a85fdS+vNw4kRYzNnKxPaoRzPs4V6KHibtMu8hMXBU2hhHxukqJJrFFtPwwYX66zVnUN/8XyD2EPHG6SFuq9YP1PxRfT3freQMgd/M1kLqvYCYzs0sf0MkD81tyck/QIAdN1UONoIqTLnZ8Qtte1
 CYH6hB7t
 Qoz+vLSueqKu9PUi6yBYEThX0wJztznrGWV3gBl4z+xCzNxQ8ivvM9lPD3etM4Zr8QWMHfFT+kKVCbL2AzaJ5wxyNZiaHfotC66DXZWCHWgUfz1M01mcGhe71O6VkYMobqhpzGzfsgdP2zi33GQQpNROlaHIuGHC/rJ2V6XEJZRf3RlEgXcbpn2F4TnNdHPdB0MRv1Lby/u+fZrZ4cIgA5iPppLTFyHmUuyOkoFYpWeWIGeIzHDcezDq6T/AKs0K8gg2fV7Z+NASUynGMeYZKRRpBgoi0JrUDexWi9sQZHHUtZ2blp/hinxwdIAuLjc0usdw5qfjgBr7Dm5mQKLp6M9458y+6t5G/KYTIbmDCcC6brlrQBh6HygLM7HTJ5o4Sm74sEJOytKOfzFjilE1TH0PS5fKSmRa0As6WTpqxzhRGs3VfoiVM92mAnG4aZy3LTbdpTCZesgL93jziDcNECvH1rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
not. folio_split() can be used on a FS with large folio support without
worrying about getting a THP on a FS without large folio support.

When READ_ONLY_THP_FOR_FS was present, a PMD large pagecache folio can
appear in a FS without large folio support after khugepaged or
madvise(MADV_COLLAPSE) creates it. During truncate_inode_partial_folio(),
such a PMD large pagecache folio is split and if the FS does not support
large folio, it needs to be split to order-0 ones and could not be split
non uniformly to ones with various orders. try_folio_split_to_order() was
added to handle this situation by checking folio_check_splittable(...,
SPLIT_TYPE_NON_UNIFORM) to detect if the large folio is created due to
READ_ONLY_THP_FOR_FS and the FS does not support large folio. Now
READ_ONLY_THP_FOR_FS is removed, all large pagecache folios are created
with FSes supporting large folio, this function is no longer needed and all
large pagecache folios can be split non uniformly.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 25 ++-----------------------
 mm/truncate.c           |  8 ++++----
 2 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2949e5acff35..164d6edf1b65 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -389,27 +389,6 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
 	return split_huge_page_to_list_to_order(page, NULL, new_order);
 }
 
-/**
- * try_folio_split_to_order() - try to split a @folio at @page to @new_order
- * using non uniform split.
- * @folio: folio to be split
- * @page: split to @new_order at the given page
- * @new_order: the target split order
- *
- * Try to split a @folio at @page using non uniform split to @new_order, if
- * non uniform split is not supported, fall back to uniform split. After-split
- * folios are put back to LRU list. Use min_order_for_split() to get the lower
- * bound of @new_order.
- *
- * Return: 0 - split is successful, otherwise split failed.
- */
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
-{
-	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM))
-		return split_huge_page_to_order(&folio->page, new_order);
-	return folio_split(folio, new_order, page, NULL);
-}
 static inline int split_huge_page(struct page *page)
 {
 	return split_huge_page_to_list_to_order(page, NULL, 0);
@@ -642,8 +621,8 @@ static inline int split_folio_to_list(struct folio *folio, struct list_head *lis
 	return -EINVAL;
 }
 
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
+static inline int folio_split(struct folio *folio, unsigned int new_order,
+		struct page *page, struct list_head *list)
 {
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
 	return -EINVAL;
diff --git a/mm/truncate.c b/mm/truncate.c
index 2931d66c16d0..6973b05ec4b8 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -177,7 +177,7 @@ int truncate_inode_folio(struct address_space *mapping, struct folio *folio)
 	return 0;
 }
 
-static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
+static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
 				    unsigned long min_order)
 {
 	enum ttu_flags ttu_flags =
@@ -186,7 +186,7 @@ static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
 		TTU_IGNORE_MLOCK;
 	int ret;
 
-	ret = try_folio_split_to_order(folio, split_at, min_order);
+	ret = folio_split(folio, min_order, split_at, NULL);
 
 	/*
 	 * If the split fails, unmap the folio, so it will be refaulted
@@ -252,7 +252,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 
 	min_order = mapping_min_folio_order(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
-	if (!try_folio_split_or_unmap(folio, split_at, min_order)) {
+	if (!folio_split_or_unmap(folio, split_at, min_order)) {
 		/*
 		 * try to split at offset + length to make sure folios within
 		 * the range can be dropped, especially to avoid memory waste
@@ -279,7 +279,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping == folio->mapping)
-			try_folio_split_or_unmap(folio2, split_at2, min_order);
+			folio_split_or_unmap(folio2, split_at2, min_order);
 
 		folio_unlock(folio2);
 out:
-- 
2.43.0


