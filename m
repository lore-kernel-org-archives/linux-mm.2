Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44EC0CD8C90
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 17:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC4B6B0005; Wed, 10 Jun 2026 13:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893486B0088; Wed, 10 Jun 2026 13:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 782476B008C; Wed, 10 Jun 2026 13:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63ABD6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:25:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5E821C13C2
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:25:37 +0000 (UTC)
X-FDA: 84864679914.14.166C9E2
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013053.outbound.protection.outlook.com [40.93.201.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id C873D140005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:25:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=orWE7kcu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781112335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/82sI+dyFK0GMQe3pQZkdcFNhE5Hzfx8JghZEcY8rl8=;
	b=Omqj9tSFrEhiVqdzp318r/rBUVoFQVkr/Qit6lChF+VoZg1O48B+C0Pus9mK1TfWNnb2Jx
	2cpxfoh3i1uNF4+J2lrtlbLX+nODmzIAxoY+n8ZhqPkeIROiihUxbyWQDrq7OJpI3r+gqM
	TePo2rzYEMAs7VYiZ8BRlWb3+CVurL4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=orWE7kcu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781112335;
	b=ywctyX2ZfgIP9f97Uwn3nkRVSq47UBvnGa8njFrO9IzGoF7VNNctDh1jxd50D4a1SlRv0+
	9QOliPg4TUuLTCBDr/k8Eu0I3xOgu/QW805QCGjqyscvDig5I1ZBMbD6khDQtIWS3LDGbE
	pCBcVjvhaBufsWsPVkHOlLXjWdlTznY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qKSIHTQt61L7b1GydmbY4nF7IV4E1NBLr8p3DC5VFSCf/a72Tf3XSZiH0uAN+6VHtkh1UUHq6XDYMXSSzX7Y1U6GTtCvKgsfJgKXgDRcNZY7wh9r9k52KyaORlo4B0Umjlidojp++A3OsezUNgJgFjPl//ZNP6J1cpWeSv+w1O04zp5JfmrgqXk/xoQXNGOpI9poaQ5RLWYk5ZBEZLQXyKg1Hw3EPfZRhUHmig4QMRgZqbwEzYFPI0XN/JON3tgo1wSsodXg71UVl28DeW/y2+wZyAbN7nKOxqH73HYLB3knVOWvDdwyCSLr7uGDJ588zLNJLuSUE2MK5LEwojrBzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/82sI+dyFK0GMQe3pQZkdcFNhE5Hzfx8JghZEcY8rl8=;
 b=vhqMWyi2RJ7p7ZvwKU+hgLDMVupcg1uNDPuCVgN3njr5tc/wZ9Ky7OSPTlhCM4PN5ydYKfBL5t0oPvpuRPMf2QPTWTfNc5CEcPkXZRIkEXBsHxd5jRX2mxR6qJc+cQj1lRsLSIkWtTYXAUDOj65q9JaS8fcIm362R1J36zl/Wjx+80vRfLZta5ekYuPkc34GU1ukjo12XM29HFfxQsgl0giDUNC7lkqX2SdZYVfN9PnnYf0Gz5K9iK47WAw6lKSut12W7WDMzngh37LIhD4kBAibFX9oatIDG1zTP/InXSptl/jH0EB4vAZHNnwK0XjfA0gm7mJmOvgH56m7bPnALQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/82sI+dyFK0GMQe3pQZkdcFNhE5Hzfx8JghZEcY8rl8=;
 b=orWE7kcut9DAXSZtkPVxp9JAz90ltCTMduCCc6cr5Fjhz0Wz7q0mBs1OsoMrnxVxIBo1HnoW2eegZuZSv2AE6LUPaV7xjJ64fV+wccSAs3/xTskt7nRkAD6gxeHXAtMcK6+ItGi/3X/5NvxWVGN+5hpdYnPXWORefOI5o76iJGPsghu/KYJpgsFgtpVYHlZ8nMSppHB8dmp3X06XHh9QM/u9O08n6g9WM5X6xIw9h3nsIeA9IZ1qDuRVYmLLdaEyFhupSHAAWy5VtCGCSrIrtcxkEMkc6hiP41ArpW1x56uEE4X+QBqEB1h9ypj4bLV6ddJE0hipKlekPyO/8YZNcg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6970.namprd12.prod.outlook.com (2603:10b6:806:24d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.13; Wed, 10 Jun 2026 17:25:19 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 17:25:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 Zhaoyang Huang <huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
Date: Wed, 10 Jun 2026 13:25:16 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <12FE92F3-B8C3-4D4E-B86A-CC2034734466@nvidia.com>
In-Reply-To: <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
 <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org>
 <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0105.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6970:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f99a6be-87b6-4df1-f10c-08dec7153eb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|56012099006|5023799004|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	CEbz4y1SCoQYbH+wp9p0G4FhQotnuXBJBR5aPRJfbiRGhpog1iiRiSC1M8FddehTpq+MzaVYv6oEsFmX5NSYCpK28pD3EwFTbxnS1tpm+K7keHnFByBMLN6xe1PCMpexMOrIqvES6TmHDY7E+5oR6gKdQVnXHx3+XX/PdDPCW8ssz2jz8x3qAy8F1ARaITtlnLxawBTsxnLPX4sUJZeOq3mSKdPjvH3/HtQWp2hkNZawcay7voGhe7hhx8JnBXi0gfAG7+YUDTJdwb/7rDzTMDUgjyNWe7Ei5032OZnNqlGv1iUx0SXChz80sLyDa3aTb1anchccOEA86NRPOee8RMvoSTXNkJJwAK4t1vmurqOP6yoeBGm21kJc90G2r8VfCgoBaJHqhSNqsd28Q3qlCNashTgM6KNMBV5UGgnBT8tKO3cTANnZJyntcH1ooLR2wmVdDB95SzR1MI5jMDkxBqKlKyhFlqr1CMBVZGAX8hVNdbKPL3zyozsTvAyd6kPByq8P2qLWRJV7MF2S9jLKPVi9wC6QTpgrrNrKBCtCa7H0u4oecLAljCppiBCjvLfrGwA2yRxaw/nMYjj3YwJocnA//Jb+NCMDZiH/f+Cf6cexY68qVvymrcWSChEWWJslMfgzNDrjeF0lZF2eXr4BOIYTNopDxciOlwXsYhsSIwxqq/oCUXemZuBTQJ2rhjMh
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(56012099006)(5023799004)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HMBFncUReMif5es2ZDMdjr14iugMhssCDEznh0WxcvNWyGMlJ8rX8qJX4ds9?=
 =?us-ascii?Q?TgEEcPY4FEVlAymxeFayTulP+D7K72tD3gA9Kt3h1683eFXomuLwbgwoRb+u?=
 =?us-ascii?Q?oHKL77R99BvDeOrx/hlzwIzvcTSsQs7HfUbpRjzpHSpG/C0c8AIo1yXK0gTV?=
 =?us-ascii?Q?tFvaVV14IGbHAdp00atpl7hpdnDuFFvyr8uGDPGC1gtlMA0ZMAY4kzboPq7Z?=
 =?us-ascii?Q?9f3Gd0nzs2qiYE0m3kZGcgeq5LXu+ZVequV9t2bCABNZNikIypZ4iWmVwDns?=
 =?us-ascii?Q?tDa5mWPCc70N3iL9JxYLXDIWE4jmcunE6KvWOOVUleJDnOMkkl/ksPZyiub8?=
 =?us-ascii?Q?K8FZ5lj3pXFn2Q5pzDwEGU78XbKelv2NWzV1C8fEB1uz8BSOOf165nwN3pdj?=
 =?us-ascii?Q?g4fVtj05CmkQwB+G/1J5o7GAUnNPkf7BUI88QqY9ZephQHTbV7r+CN2/hxez?=
 =?us-ascii?Q?xjh9pRwsA/CJySP5IQFV/T0jj8eRTxEB3yt4a8YLPOWkAWi+2kXDOeFzYxPz?=
 =?us-ascii?Q?HYAHb4PgpSC0qwiI7aFdyXkos9Ms1SGJt+1lBabUtCXYA46piHY4tEmrdPYq?=
 =?us-ascii?Q?5IGnMUgW9s42HO6M4mXlmpjBTzB8xSw1jS5JFYdp5FThJIkZ8Gml8xetAbS0?=
 =?us-ascii?Q?bt/zYhAcxl28mN1dMKyYZb0Q/7JG9/thjeZcvtIB5oIc/jK5JS5b+TPJ7a0r?=
 =?us-ascii?Q?o1cUEjQICjMkjObx9BYNdSYspCJgUMuK/IWeX0wACBI22fCLTh2WoI6K1lL3?=
 =?us-ascii?Q?g3nf/iNIPyD4F+uMarlL/7MTZm75VsXPDCyS0ICe8VzfOUahgA1B6v7YcEMZ?=
 =?us-ascii?Q?8jW4gfQA2jpHaIZQb1rjjRDjPX1lvhOxz/LFjBRA/Q0ZMT9AHQ2TfprTTpKu?=
 =?us-ascii?Q?kYFB13ajiPZLoBno2wdjYVVKDJIdr4/22Kwo7cUPsh+K1nwR0g1+c1fHaP5W?=
 =?us-ascii?Q?R0yeZMPVCC64UoJ98saP5LBlkoWa5+BzKyE4TSN/cE8PQEFoVlwWYtAb6tR7?=
 =?us-ascii?Q?qrKIzYwRt/NO6RCpgZolQTsTQKSmcYZlNPH+db3VsOhs/Erff6ZftYcqowy+?=
 =?us-ascii?Q?rDvFhPfxz0Ok0AcYr8pTpt52tn/7zdqDyc9KPI5400MD20MVaDEr+Nf8XyTK?=
 =?us-ascii?Q?suPux28yJe8A+aLF4qYk1PhWZcgBEda71R7JxKQV2BvTl/hntwBC9oIxAkxQ?=
 =?us-ascii?Q?LvcF5hFFUWjWo4VPsEWWPY2b/QCjveGzA8vPT7NOM8DxsUKqDKzVbMJTWElT?=
 =?us-ascii?Q?t3JDiEdeH3QZzweBoIayn3R5rvy4ifi5oZcmsx4ETWwSzfJW+cNrzQYm0rqu?=
 =?us-ascii?Q?ITpqQqaeZrFmHGg7zJ04GpxGSDq4ZWCt7HtRwpz32VQ9SEyHSLGo70/qDfIt?=
 =?us-ascii?Q?c247nt+tLl4t5TsRaQzA7kfYngeonui60kbTfhh/vDx/CfzsEAT392qunaEg?=
 =?us-ascii?Q?bzdoQ6U+VNu1A20IabULYfUQE39hh8adYVP4a4JMBw6iLOFqd7wo4V6yzoO2?=
 =?us-ascii?Q?ojUH5JaqaxewX/g8V7CN1r3IZioAuZEw+b9puW1PXa8xxTVUwVKtzlcJjgAO?=
 =?us-ascii?Q?7Ed0vmYHFxDnGh0Dop7GCA0JP1F1avNb2ENu1I63/DdA8qx3IoP32mTYLLKp?=
 =?us-ascii?Q?d+DwnZ0GV+mmZ6ChBevl3iHQTHdwcEUJ2V4WnppnUM8NkVEPTiSPzbu8lTmg?=
 =?us-ascii?Q?btbanb1IuR2zT17/xQd7REB/YxJvH9BFvPBH2KyZbxciNk0T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f99a6be-87b6-4df1-f10c-08dec7153eb2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 17:25:19.5260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cbE5MSrb12PBbeWHVUUBzhjA0A5YHrWHtQ1SfUrKy7CFOsZoSD6VCkEmZ3cC5edr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6970
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 9cze3qypd3safiaigdikrmdcsxw5tem5
X-Rspamd-Queue-Id: C873D140005
X-HE-Tag: 1781112334-92955
X-HE-Meta: U2FsdGVkX195R3qXhPCpsQDNiISE4Y3l+cyVEj0EuyODzK3xGJzHxISLL9zf1Zu+ISQ4+XqSnU5LR3y8gpk287adboOIlTGNXcUW2wv8nk3YEjDcGL/BwUTEBnBNyQeKe+WKKOn523iwhPPjMVPZ+d3vUBzCbpuA0Pq8sFdyDb4uv7NsLiodXs2f1OFJZ3RweqApyxRYKZ05Z66+YekzhmdxCTi4la9+RZnp2Auy9UUbwDN9yXyYeqZQKxtdEmQtW40E1gYr+NPt5f+Zj4CkyVKQV6ii8YYkGK4WLED9kNZJjjiPRs8h9EhdMAeZGu4ZeRBBKdwU0i20Rl42TITi9gxFP1cceH1wy/Li4kiuDSxtPHaQr6+CzrSayVCSfhantBwrms6oYSjsiCIyZ+ssMqXamOt7q0jKm4Nrb0IJRDAnlhQukgpJGNQj9vCPIbh2a+a62qk9NgJLPC4w6D7Fl42siS6Ek+QqZV6X3AlT0wOTBl3THn+5ZXgQdHxEc+Fhs6228aa0asN7yusmPLTc1C5rsEgpsSDZqIt4sa+6/vlExn2EhyzxZEah8lOIVZBw7S+qxVUKElTOMjY1uzeTcUU+dYRAVVDF03FFJZuYHszHJwtVodgeNtCuFqjb1B5InszboPBeFgixgJvFna3bmThqmp2sCi1oWHK8kv4Dsic0kcORMlb3Ix1aXJmnVPoTj5FMRjkcuoSMDUcycs8nBZ8oev4XxK7YlG4w1WMzTpNjoGi3hVKkHeZJ3IqcD+6I3L4McYL5hORLxeQt1i9q+PAQwUpzVYYSurEm5tQLJF3S3OQdxlbP5BSELAAxnTSV0NYCZu+d4ZsBKGRe3NR5W1afoT2DFovNA27pXWkQ1zZbF5NMDlaCKkWKdcTA9P2OoPdtvHNJpTbZVMh7xbsaApqw6uMmZ/yLumFAliTHRfD9WXTTosHb5Tt768fkeBc0weiOFAdchnOOfEV69KQ
 svDjwz24
 V8b503o+aPlMmGxUMqiI3G4jmmAf07jWZ6r62LPSN/9sU7vuNrQzXR6KXkShEq+tVtD7B/nZtt98Tue66P1OhzSObN6CKzZtMwS9HXaY93trwD5Lwc5EZlYFbt7nKyjX/7rBsWkLSVz7vEeAsgQREby5qpDSiGZXY1RT19inSC7ZovOzCAUwA2m/vGZY3R3WMhbiWbuY9kX8SKz+Rcbhhsl/yFDeXf4ANdmFoUydT56V2ZkBE9IzPQt5WyJlkUC42/Axj4LIZyLsYsGJoGwt14+sdnFvlJVFYHKyGOdcjzysBwDM0EzZMfYkzM42Dv1QtaQZFo+uNc9YP9alEPIfld72fsMvTRhjez/N7E7hmSJi9WgZ3JzqM/YZRKXvMau6HH5Yf49rbVPSZ0szO3kNpgvncwxYGljc8TVlOBrsqmitE2xaw3oFuvJq4VlBhCRjAtEoJkdY42eFtPboxOUcAjqaFXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Jun 2026, at 10:38, Zi Yan wrote:

> On 10 Jun 2026, at 8:50, David Hildenbrand (Arm) wrote:
>
>> On 6/10/26 14:05, zhaoyang.huang wrote:
>>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>>
>>> The kernel panics are keeping to be reported especially when the f2fs=

>>> partition get almost full. By investigation, we find that the reason =
is
>>> one f2fs page got freed to buddy without being deleted from LRU and t=
he
>>> root cause is the race happened in [2] which is enrolled by this comm=
it.
>>> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: r=
emove
>>> non-uptodate folio from the page cache in move_data_block").
>>
>> But I assume, that other FSes can trigger this as well? Any insights?
>>
>>>
>>> There are 3 race processes in this scenario, please find below for th=
eir
>>> main activities. However, by further investigation over the code, I
>>> think there is a common race window for the truncated folios between
>>> split_folio_to_order and folio_isolate_lru, where the folios lost the=

>>> refcount on page cache and remains the transient one of the split
>>> caller, under which the folio could enter free path and compete with =
the
>>> isolation process. This commit would like to suggest to have the foli=
os
>>> beyond EOF stay out of LRU.
>>>
>>> Truncate:
>>> The changed code in move_data_block() lets the GC path evict the tail=
-end
>>> folio from the page cache through folio_end_dropbehind().  Once
>>> folio_unmap_invalidate() removes the folio from mapping->i_pages, the=

>>> page-cache references for all pages in the folio are dropped.  The fo=
lio
>>> is then kept alive only by temporary external references, which allow=
s a
>>> later split to operate on a folio whose subpages are no longer protec=
ted
>>> by page-cache references.
>>>
>>> Split:
>>> After the page-cache references are gone, split_folio_to_order() can
>>> split the big folio into individual pages and put the resulting subpa=
ges
>>> back on the LRU.  For tail pages beyond EOF, split removes them from =
the
>>> page cache and drops their page-cache references.  A tail page can th=
en
>>> remain on the LRU with PG_lru set while holding only the split caller=
's
>>> temporary reference.  When free_folio_and_swap_cache() drops that fin=
al
>>> reference, the page enters the final folio_put() release path.
>>>
>>> Isolate:
>>> In parallel, folio_isolate_lru() can observe the same tail page with =
a
>>> non-zero refcount and PG_lru set.  It clears PG_lru before taking its=
 own
>>> reference.  If this races with the final folio_put() from the split p=
ath,
>>> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio(=
).
>>> The page is then freed back to the allocator while its lru links are
>>> still present in the LRU list.  A later LRU operation on a neighborin=
g
>>> page detects the stale link and reports list corruption.
>>
>> Complicated mess :(
>>
>> So, folio_isolate_lru() really only requires the caller to hold a foli=
o
>> reference, which can happen given that we did the folio_ref_unfreeze()=
=2E It can,
>> for example, be triggered by memory offlining or page migration.
>>
>> So we really want to not allow folio_isolate_lru() while we are still =
processing
>> the folio.
>
> Or we should defer adding split folios to LRU after unfreeze.
>
>>
>> What your patch does is, simply not add folios that we will drop from =
the page
>> cache to the LRU?
>>
>>
>> You should describe here how you are fixing it: "Let's fix it by..."
>>
>>>
>>> [1]
>>> [   22.486082] list_del corruption. next->prev should be fffffffec10e=
0ac8, but was dead000000000122. (next=3Dfffffffec10e0a88)
>>> [   22.486130] ------------[ cut here ]------------
>>> [   22.486134] kernel BUG at lib/list_debug.c:67!
>>> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP=

>>> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
>>> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
>>> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS =
BTYPE=3D--)
>>> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
>>> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
>>> [   22.488539] sp : ffffffc08006b830
>>> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 00000=
00000000000
>>> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: fffff=
ffec10e0ac0
>>> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead0=
00000000122
>>> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: fffff=
fc080061060
>>> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 00000=
00000000058
>>> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 00000=
00000000003
>>> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe85=
721f0e25f00
>>> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c656=
45f7473696c
>>> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 00000=
00000000010
>>> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 00000=
0000000006d
>>> [   22.488647] Call trace:
>>> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
>>> [   22.488661]  __folio_put+0x2bc/0x434
>>> [   22.488670]  folio_put+0x28/0x58
>>> [   22.488678]  do_garbage_collect+0x1a34/0x2584
>>> [   22.488689]  f2fs_gc+0x230/0x9b4
>>> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
>>> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
>>> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
>>> [   22.488725]  invoke_syscall+0x58/0xe4
>>> [   22.488732]  do_el0_svc+0x48/0xdc
>>> [   22.488739]  el0_svc+0x3c/0x98
>>> [   22.488747]  el0t_64_sync_handler+0x20/0x130
>>> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
>>>
>>> [2]
>>> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2=
 (folio_isolate_lru)
>>>
>>> F: pagecache refs =3D n
>>> F: extra refs =3D GC + split
>>> F: PG_lru set
>>> move_data_block()
>>> folio =3D f2fs_grab_cache_folio(F)
>>> ...
>>> __folio_set_dropbehind(F)
>>> folio_unlock(F)
>>> folio_end_dropbehind(F)
>>>   folio_unmap_invalidate(F)
>>>     __filemap_remove_folio(F)
>>>     folio_put_refs(F, n)
>>> folio_put(F)
>>>                             split_folio_to_order(F)
>>>                               folio_ref_freeze(F, 1)
>>>                               ...
>>>                               lru_add_split_folio(T)
>>>                                 list_add_tail(&T->lru, &F->lru)
>>>                                 folio_set_lru(T)
>>>                               __filemap_remove_folio(T)
>>>                               folio_put_refs(T, 1)
>>>                               /* T refcount =3D=3D 1, PageLRU set */
>>>                             free_folio_and_swap_cache(T)
>>>                               folio_put(T)
>>>                                 /* refcount: 1 -> 0 */
>>>                                                                   fol=
io_isolate_lru(T)
>
> If refcount is 0 at this point, VM_BUG_ON_FOLIO(!folio_ref_count(folio)=
, folio) in
> folio_isolate_lru() would be triggered. Maybe we could just return fals=
e in that case.
>
>>>                                                                     f=
olio_test_clear_lru(T)
>>>                                 __folio_put(T)
>>>                                   __page_cache_release(T)
>>>                                     folio_test_lru(T) =3D=3D false
>>>                                     /* skip lruvec_del_folio(T) */
>>>                                   free_frozen_pages(T)
>>>                                                                   fol=
io_get(T)
>>>                                                                   lru=
vec_del_folio(T)
>
> But in CPU2 (folio_isolate_lru), lruvec_del_folio(T) should remove T fr=
om LRU list.
>
>>> later:
>>>   list_del(adjacent->lru)
>>>     next =3D=3D &T->lru
>>>     next->prev =3D=3D LIST_POISON / PCP freelist
>>>     BUG
>>>
>
> Why does CPU0 still see the stale link from adjacent?
>
>>> Assisted-by: Cursor:claude-opus-4-8
>>> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>
>> I'm wondering if this has been broken the whole time, or if some rewor=
k allowed
>> this to trigger.
>>
>> I assume the issue can be triggered for other FSes, and we want Fixes:=
 + CC: stable?
>>
>> Looking into the history, I think we always unconditionally did the
>> lru_add_split_folio()/lru_add_page_tail().
>>
>>> ---
>>>  mm/huge_memory.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 970e077019b7..7465525a94a8 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3966,7 +3966,7 @@ static int __folio_freeze_and_split_unmapped(st=
ruct folio *folio, unsigned int n
>>>  			folio_ref_unfreeze(new_folio,
>>>  					   folio_cache_ref_count(new_folio) + 1);
>>>
>>> -			if (do_lru)
>>> +			if (do_lru && !(mapping && new_folio->index >=3D end))
>>
>> It might be clearer to write this as
>>
>> 	do_lru && (!mapping || new_folio->index < end)
>>
>> To match the page-cache check further below
>>
>> 	if (!mapping)
>> 		continue
>>
>> 	...
>> 	if (new_folio->index < end)
>> 		...
>>
>>>  				lru_add_split_folio(folio, new_folio, lruvec, list);

Talked to Claude and find an accounting issue with this. Without putting
EOF after-split folios back to LRU, they are not going through lruvec_del=
_folio(),
which decreases NR_*_LRU counter along with removing the folio from LRU
and it causes NR_*_LRU accounting errors. Note that the original folio
is on LRU all the time and LRU counters are not modified and after the sp=
lit
the original folio size is decreased and the after-split folios need to
be added back to LRU to keep the LRU counters right. We will need to adju=
st
LRU accounting for (!mapping || new_folio->index < end) if we decide to
not add them back to LRU.


Best Regards,
Yan, Zi

