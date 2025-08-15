Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6997CCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 02:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15126900208; Thu, 14 Aug 2025 22:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1290D8E0002; Thu, 14 Aug 2025 22:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01792900208; Thu, 14 Aug 2025 22:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DED038E0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:42:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCA2CBBA95
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:42:50 +0000 (UTC)
X-FDA: 83777444100.20.77E1543
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0F4A540002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:42:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A56OLIvu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755225768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3Nv6QYq3hEmgjLaysO9MKN4vx+xGxG4ASEVQbXzzI8=;
	b=eeTi7HTFyNbr2RYVsU3rSmKaKXxwcO+3xVJJwbCjUu+IOqLuLqEj4T1lFmwNg+dHqBWoya
	e410ESfE07v5U4mfYYllMvmcWyJKHbAcqxqe8yn1tWJ61ujQc412476t96HSRl89pID9Ol
	ZG45uu2apTQVsjGJc88TysBbGRuuA/Y=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A56OLIvu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755225768; a=rsa-sha256;
	cv=pass;
	b=zbPBTDdLnNcbS0O0awzuhYGDooEUOom7sft9KMzUHnqcr+4zopHvmXgviicczzNV98oR50
	eDZii331yqHh0CgcyurDSexLXfQvkCitddjfaLmIMvMqia4+HYA78ChNbhEtSVHJqoAQuP
	ZAxAp+uo8S9FFwKdqGmjzAouYJGahYc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ejI5YGvE/Kn2QBXveWk+mCWuxeJ/R98HvhNl2k9X72/HbwFembd3ry+maPT3k4iMF2Sh0rqckPFOq/qFYMJLGcyqtDM1oOvFeQQqpzUaeqlXUg9vX7wSIeBuzF5k4Wea8FyDtKqG4JRq82wu9auACeLWcsJ+xXqM0oaZLFtGKrlcuIxMjH2UT9RgrQNNhq/8ND/zPCVeyblzCcThnyZxUx9C8PUCyjiKzbH8ZHvKFtAUHhS18mk3PefC9U2oT8rAI7/tRIM7hUxohXnUM38yL+YKKhBbjfOFn7LOV07L8mwqodFif+BODlzn3Au1pFNqe/yCr/Z96pCWfTK9EEE32Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E3Nv6QYq3hEmgjLaysO9MKN4vx+xGxG4ASEVQbXzzI8=;
 b=EY50rh4XmblYojsW94TQm4D1c1FLrHsBa6gEcmEko6oIFH4SFmqLSbXdYdvrsnnSArFcdpidn+Sxxs45DEwumbtc6OR3SgXZfwwqYSHQuceXvLYefBRvSqq0qyL4dYYiu/sdPWAZtpLonpOPsB65xhgSYHKJhAJgqvBy/+Id0J1iIIiVpUMxfFRxMUPe65Fy29vNqX+wQtiWwxOIno3zTu34VZnQXkOi9Q2Yk0PIOJgyHMlSB8n0adCWDH5qYZ/cYBodAfj2WP5hiwnvTFNV3RKovbYfPKtx8COb+wLvsBAn2+UcoWx4juHprfNB1q8+DyEToeJmmhY9Sl13IlEs3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3Nv6QYq3hEmgjLaysO9MKN4vx+xGxG4ASEVQbXzzI8=;
 b=A56OLIvu+rC0OHTsqhPHDod87zabCwRUDp6a2ZHPb8yGrvcTdoqPoXe5SVcliF5dswTQsAZD+k+THS7TRKAM6St+ZcFtRHiG90hZUgTp3ERBPE+Ll7DB33igtXnjzt58R2twcTV8ILT9x9W6VFUcMxTlXahkHdMC32OzV0X6Q1vRdJf0OAnWnbvoa1Jtjch2IrJzPAq1+VeDC3tbag6zyP9qVF1u5TAdPCs+ebyQtbPSp3C464wB48nK0GvTBy9wczmkNuZfaKnCdRl19q7rHD3h1YqmI7AImHskfLiqOlJWsX5U9mmrai0qDJt1LOZga8CL2OCiqBEp30OG0BQvWA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB7226.namprd12.prod.outlook.com (2603:10b6:806:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.14; Fri, 15 Aug
 2025 02:39:37 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 02:39:37 +0000
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
Subject: [PATCH v4 1/5] mm/huge_memory: add new_order and offset to split_huge_pages*() pr_debug.
Date: Thu, 14 Aug 2025 22:39:10 -0400
Message-ID: <20250815023915.1394655-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250815023915.1394655-1-ziy@nvidia.com>
References: <20250815023915.1394655-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P223CA0019.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB7226:EE_
X-MS-Office365-Filtering-Correlation-Id: d934b360-d5a2-41d4-75ae-08dddba4fa05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?stZTXiB7gwEEl+tSA0MagkAA827/GgGNATZiB7YpYCXcKcwd/Sn9cxlhEEV6?=
 =?us-ascii?Q?9bxM93N7PwcrB69WvJ03ZnK9RCtXVPd6WYV3D46jPn3qEaKLqUiSKidKxq6P?=
 =?us-ascii?Q?yURLhCoLwqPLCAxK4vBryAxMF/0owfVuK7SMMpmgBz+guYGCX1MKHq0v7kLC?=
 =?us-ascii?Q?m2InJDxCFkj66+hAFGNaKgehnzhvGjJf6weD+YsaQ6ylOZDjDHt0kPiIOTYo?=
 =?us-ascii?Q?amI3L9uxjKi6DjwZi9rVHhsGP9CsM3Ov8xS7pl6tPCFpzkkTQqvlGg5igATd?=
 =?us-ascii?Q?uHuF0gSMUd/g86XxDxpHQJDufiOfnlnWgFFlSZq5aeedSTJH3Y/JMxNUZfSA?=
 =?us-ascii?Q?LFgIfDlzmvfFzQB5lv0esitsNCg1Zjf5vVPqiadFtglmhH6cvtjFp2+eR3nF?=
 =?us-ascii?Q?MgsgUKJFd5V/F4RaMsp3hwqUYcvFoGy8jLPa1lE3aFSWvZnxBrOkS38Wzxws?=
 =?us-ascii?Q?Q4u0utxsh4x2dBlll90MO9mbAvbOVVsfHSzELOdsSySE920RmpMMlU0xq7lL?=
 =?us-ascii?Q?LDSTgVhM2959sOfxoE4ujzk0UJcF6YWAD7OV7jvxTsGTPMIlMUBKFVk6g5so?=
 =?us-ascii?Q?8kxwIzEZRMcP6wP1qb9vHW1N8ed9br3QgYVoWUMav4mXpZWTwuAv7q4yrPEb?=
 =?us-ascii?Q?M129HsJ5nOl20Auw4wJUR82uf+j6O2Vl0Qwlm2URUxfF0vjtUwf9sKdMzA3m?=
 =?us-ascii?Q?BwVULUdLb+GqhbIBqYBs7tpFoSiLPELqfWmZcRxxHiZMRyfAb6Djipiql/6X?=
 =?us-ascii?Q?1NJyU5Br4OOLqqLaFjgZ6PjdE57MbpvSJ4A4rc1GuRWSwgqcp4+tzHpB2hXR?=
 =?us-ascii?Q?ymor2HEW4GB8EWe8dCN1qdfPlq8Jl9zJxst2EMVzlQaD6LL41rLYvJrwu2CZ?=
 =?us-ascii?Q?j96UQMetRzsWtndKJ9c3y4zLCrSeDgvLtEP1FmgqDuUS3AJqnixCFBxyWsYT?=
 =?us-ascii?Q?PJX82njM2pzn4rYgJl84NfBkWkMedjQ6iiXlxqSK3XdhBOHw7gvFk6R2F2Xx?=
 =?us-ascii?Q?Wd8irSjXzSFS+VhFTToYuvX+SlijgprM50cfnaxqXD6XPR+iosTQE8DSoutW?=
 =?us-ascii?Q?0CJx7wUmSCqPy/mZ6GNJwRya02vxsxL7tQZ/Ht7EkLqHBbCRwGI8irHnG50e?=
 =?us-ascii?Q?3bDaoXmClAaBYsmUNfJ0Wm2plNPiwv2QcxtTPT8DcgMUiLYMnhcwCwGq/fnT?=
 =?us-ascii?Q?vMN4CffhcqdtN9HPhHz7kJHPvvAAHKu8KWTMl6eRUOLcZ3WnBGHaAQX6WDut?=
 =?us-ascii?Q?HqhdH0tWP/nT1Ke24FCnPc4XpKpRE4RVsNzU4gruzUsasKEasZwuD08KhjOz?=
 =?us-ascii?Q?xq7UwwSKYUHDBiY8gnOv4txESCEEf9K0h1DeMksPiD5QEhlRBIrzW1zj9uzW?=
 =?us-ascii?Q?mDTMb0H0E/DsxPlCOT4xNtgYaQcHlO9aY+F9oLgKcpc7uHwKL/tHIZIfsVa5?=
 =?us-ascii?Q?Nuh5SFvLV/0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hFgfGmnfWuRl4IOq12sCevXnjw1flkvwhdNPFS1Jc1Fup6fnKnGQON/X+shv?=
 =?us-ascii?Q?WYUeFtZYkpytTN36wK/EBMtjbO4n/ASec9W23PpkWjDDMPTENrwjU6XIbaNv?=
 =?us-ascii?Q?6bc0LDjcpPjjIuZ4aRBgY/DvAsTGudD1vWcn9NHx4eoiz4mcKWB56qNJp1vG?=
 =?us-ascii?Q?ml7KZr+9H72GpARejnmdl8C9mekOpfjeUtvRmgHLdZACzvyn/sBfmlps48WN?=
 =?us-ascii?Q?btPRPrKAKCeRP3UUek/UEmdKJf7mbEaseVL62ZdSRbpKkbqXevOPsiyS0mSR?=
 =?us-ascii?Q?Heh0Y10O6hTesxHno1LmRmvJuTZc9EvKWDQED80lDTVhOLgrUVA2z+W13Rcu?=
 =?us-ascii?Q?J5WztFhRyAZoteBw56ugPqs93fXJjh/SKTQR4wUj+/I5un4NiRmvlNKojTVC?=
 =?us-ascii?Q?uQKslIOdBQx9MF1lhnuJMz2GKaBlibxzceV8PgcjUXoiWvDupxr4G9po/fqq?=
 =?us-ascii?Q?cPruEkPQsw85XPQY1UTlkxrT9eOjwXRi6DLc4V8CdzA1KF7mC7MOWP8BMpBi?=
 =?us-ascii?Q?GGIoY1aZ1G6i+L9vDQcxWi/Ii8j22b1SC6ofDx7FTbOYGbbMbMQa2vUJuOB7?=
 =?us-ascii?Q?cEJrJlH8cXsoESjbJdSHpccKMIf6HiIJC6EHcOjz8px9+inTCRwYKWlJTW08?=
 =?us-ascii?Q?xHQVgnUL3SdtynH+yXNc8N+e+CdIGbEk47Ez0f1LR56Iz4TYFAOjMo88isIZ?=
 =?us-ascii?Q?+koPQpjNI4Q/luNRTZEuej0bw+nCjd5hYKCF74lxnwfO5l79b3ShsSQ68U1R?=
 =?us-ascii?Q?5LA8PyBaqTZJpYSHXkdxjD7d9D/BgZKS+Y8zNzy6KpkBTO5yEPqAY/njs8Sk?=
 =?us-ascii?Q?OEuFtFmkBaeOl7ulCdXZc+y8Sl1xk19zllFZbXZq8kjDixtyHBodrjKUMzh/?=
 =?us-ascii?Q?UHbfheza4fcQt2cAWo514h+nZmAK1vqO0YdvX4hX+2yA2TlqhQ9zHypqUxjH?=
 =?us-ascii?Q?k+gd3hT4VyUfvn1vBZ7XK0ZKUvodPAF6QfagzKWjcFMvrIVcHhVY4M60HWpo?=
 =?us-ascii?Q?HacB004PRX75ujV7RrzSuTQYcB7oV0DTnWVJbS2vweIOPvCMHgtKSoZY/N0e?=
 =?us-ascii?Q?XCeuHmXqbXHGacp+YN36SJCFpS1d1WfAy6b11oxk1qX7XinyLg1evK8ECbf0?=
 =?us-ascii?Q?ysk+hKpBa1b4HxTJdj2Glr4JKfBW41kxlO7Hr2TA3xkUF9m+9NKHXr95/6xJ?=
 =?us-ascii?Q?Ckd2fRLL3QDfDwohIUZtE3He6mJlo9AlWBv2Rp3ejRmfg06V9DrohvopUbQs?=
 =?us-ascii?Q?i73uLCVljKhaAaPI2iLK0mWv5PhVk/zs6f8tsgmptN7aZ+FbT/rSgdk14+fb?=
 =?us-ascii?Q?doHWnGExvLaUlN+32UsUjPbn+iSEsSRWQcE2JrKyVvKFknB6nE6yyuaTaSRC?=
 =?us-ascii?Q?6i86OsdcI8mdcKc9f31g8mzc7nrwO9f7nZUguY8uSf2huK3ZwbBpAkWehRrq?=
 =?us-ascii?Q?/QGM6BK7fJAe9FDVoUD88d3z/hY2GXRtB81WYv/80HV/oADqgX1l9AhwRSjR?=
 =?us-ascii?Q?f/oeI/yLPRk/7bF3RX7hL+09WZX33HmYbp1NIj4M/nfAwtfa/h71flf8gF/C?=
 =?us-ascii?Q?5U4S/j83vIkK+LwebhkMEZlPMQhxQq/PRBa7pHta?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d934b360-d5a2-41d4-75ae-08dddba4fa05
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 02:39:37.3406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nSTmaCNGAzvNnNicr7ejsCo5OuWznIjvItORs/ZtA9SQNNVki/8SN0+Ko+8boSOa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7226
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0F4A540002
X-Stat-Signature: nodb4zm1zb64yn6y97gfjiz63do7rn6o
X-Rspam-User: 
X-HE-Tag: 1755225767-572741
X-HE-Meta: U2FsdGVkX1+9QZmHuFLD2PTzq+OBz1sUbf5ZNsBg2BllYCya92prFFE1IkFKdFF6h7lK/GK+sTGlllqR1YbCYSBodOooaqV8C2u468rxPYHanmcSjYVf4Km3jqy8+62nFNmP5uyVKp3fuWyychimcOyzX7maQAO+93Rah9LLjGtYp2UNKcpPSNECKYUhCj+/lA4a5YM/qkcmRYmZybOTOGIl02nGwvIeJZ9GqBtpy6137sm4GsquVbQJYf+mfvck/h3GhH7Y1k5ndj0hCe3pLR4z7xPP66wOvVMblQoFWh+VErUqKUzrJ8/TIPd/IBjbkzvVZxmy1Q/QwwH326dH0IixPWgrF0bi/kRzfPqDzfhO8U/s62lUE43alMlxtDnUeGWOjskEF3XJeoW3uS4P4eKDmcVcG0sbBGu2CEOH2lowvTSPOh5Qf0009imZWsqV8NnVXMXQKVDwk1U/IRzS9RfhZ+KGG7m16wnCLL1z3wyw/EMwRnh0XQ/mZy/loIZLarB7pD4at6N15n8wt0jxJtjZWGn2tpXOSkicXrsKEYNQPDHQwuV6dRTiXg03k1sqU/krMWkQap4cEf15LdMrJIiBV2zNjmsSKkAqbmXf/T7ogp7TnX/eQFlIfL7fXnXXnO8GIFL5L+n19ZwNUiQ9aNZKgFMtJXZKQIDMnP5EQwrq6I8BanlKLvXQxKofz6XMtx8ZSBiKNtqHNg9+nVtx9GEIfQkhdlHYxueBALpwOKJVQBoo7xefJPKp5a/fG5kMY9MhNYb0NOC3lTGZa1b86gcctr0D1qq80+APNNGvirYjCMKvWDuA6rn+2bOqnePy9658vxAgWAkeMCMK9iruD0B2rcDf4+vaLR/CeXhzentIiL3bjS1WiPpaPKlrNCKo5sBZYnSipyBzC/+8IvCj6XXAxPmwsxhS9tnoFBVlLkMxdTJweZwtqyWrV93pWsBcHAus1xAgeSHwKbQ+YWs
 IiusgkMv
 IzGbD/GuJNoZdi60fNei/4TUUY4fc/tfnuNcL4eEziVaUA2pJpnYHLPB34BfThKtQ7nF7O2DIy5MmDLi8sEJYpapQk7mYnifY7i5xe7LAKq1RfDOKCypNUGsc1JZzxGMc3ldTkFMW7D1anMg/il4BCml4DAsEPIFvjKjOBcbOoUbyxqoRMMV6TqVzQRM5b6vnoT/pfEDNFmtHJ3qjDcJGAqR2XqwJjokSqNmnVI8U8Ygx26kULFN1pmGquOgqB2aKT65o1GmAXdStF2IZZejdbHR2i+2FYoNLnu4YF7g5uQPwMuSQfwWZ9nJHzvGUZXcJ+ckAIgrIxB6Nc8i6Xp3qOt+sYr6QEdN/F5EfnAWmfxRYY2vAEbl3jzC9E/qmfDbnvtNf2HY5k69zWIqTgDpq6npyCqP4BkAJ6/5Bpe3mdv/sxTqmKBa46mMZ8hAGHfC9HCJ9ASrhpIKbLNWEwGsn1PqhvKLzLJKO6V+8Qqj1rWSkQfthGjdk1oJdwLO6HlSkGYXLyUAciDpu6h4inM2RaXNg8Ae45fKUlN2hIIckr0FnvL6v88I+HmlGnc+YBw102FsyBN22Li2HdXRw5j3inVvAKHUynEH3r2HTjlMeR6YXxQ5D0lEVu+mRcgbRuw9WnIm9cOb+lRJhvdToC0Ol/rew4sxmkqda7tfuyLVMlbM0RXUHTXGeZNdjDosUDJUYI5kRwEpLxFmlOlw=
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
index a2f476e7419a..6df1ed0cef5c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4319,8 +4319,8 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		goto out;
 	}
 
-	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx]\n",
-		 pid, vaddr_start, vaddr_end);
+	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
+		 pid, vaddr_start, vaddr_end, new_order, in_folio_offset);
 
 	mmap_read_lock(mm);
 	/*
@@ -4430,8 +4430,8 @@ static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
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


