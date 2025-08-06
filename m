Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9814CC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 19:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B9388E0006; Wed,  6 Aug 2025 15:16:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A0B8E0002; Wed,  6 Aug 2025 15:16:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031278E0006; Wed,  6 Aug 2025 15:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0EA58E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:16:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63C4313663E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:16:37 +0000 (UTC)
X-FDA: 83747289234.05.BBA2C92
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9708C18000F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:16:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iyV1g9o5;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754507794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAjjI9HmbB/P6UqOr4xvstTFTYW1BPWxEG5HiPvXqno=;
	b=HlOF3ye7q5PkkTnZVSm9qJ95A6UpDdDz56DhMt0NmOuoHIdzIkvhTGIJW4Mlu8Bjw7K8zj
	am/hnW12FyaOXPorxZXzJoB7kw4nHYPNzs/nSdF0CprVgTOjtnUDHVDpwcwRxnjdzSfSrI
	mKH5s5vdj2En1IujrOOKT0WA3xGi1/k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754507794; a=rsa-sha256;
	cv=pass;
	b=VpBxLRMpRczANlfbgHW5xl1fhQLuFPdtPA3UJ2E8X01QjRllUJSQgqByQoyG2hGf8eUYTV
	yId5DfiApWqcdKQyWvfkxAPzHfO0bg6JYUqaQm8H0TiKc/R3a8okUvkgchBp3rvtMdblt7
	bH9aU9DQt9HtSVfgLUC0K9wYdxxDJlc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iyV1g9o5;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fz2QKD6AM/p3JHVVpGpo2LTZbeOzYsYOHozHBdrTMz/qVkmOcr8DSgXHHZxm0jY7okuw3oUp7Uq7RpsL9nM7kirSO+09o/phCPDjNph8VQ6HUIJsYOis147+7f44jNS+R47uXPJz3hSD0gS42DujHPhJpeXaSkXOemkgxwH5xUWR4kGBCpLUdRCam2cXvOtZZuTfD7Ul3o+kAbhqYR61mPIc+ZDEsoTxIYCJ42Ai4erBCEYJ6K/rXkUTpZoVDbEHayXm9h8UL+DstqM1P4J0VJnHbbvxA/tl4bBZhRXoDyLvcRwQrft8QH0ixBhKSNsj3GCg7ldZd8RqBv+JtQGJuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAjjI9HmbB/P6UqOr4xvstTFTYW1BPWxEG5HiPvXqno=;
 b=X9ECw2utSCDMWAl1WAxVgWb+6iuZ/Iz53hLGlYMJXQchVnyukQDyMqD5nZ2m5sZr/YS74lhyaqkEsntbebn0XnN6F+piwrzgimxIJ/d66DMci9nJuDvQLvEXcXoXagzmtmdeW6ZpMpHhDDvjQn+Qom/wDxr2ewBDj+dveanL/bD49h4eFdpN2sTVf22QKwAchpmbm3RUTWzeqW7dHh8sBZ+dUrD9ckWHaqoa+oRYzyqNJh5Y62Y2cVcG/NxuAeIxEoT7NT7vAGrFSgm4KGbsNyPMNpQqc8DIeuI1q1ksveHQ56Ahf18/ppMUD1VGY75wMghRqrwfdMHxiDgYORpzdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAjjI9HmbB/P6UqOr4xvstTFTYW1BPWxEG5HiPvXqno=;
 b=iyV1g9o5Qt2BS2GS3+muspVMeZuwUXlRYrQ/whbjYbUOLPiRdhL91iuWeS/0kDW3fldNzjuxM2t9dfh9LFXTZs1aD7hTsGQiUeTmLweCu8DbEyXdFwXNMcP3VF9UYZoQG+aZmDCNyrS8PIQY86Ob2tV9gsdYexa2ysVRnsLZ0d/tI3REHi8YzmWnEZf0EgFvNGggULWw7AR0C0VuI9hi2oDXlizVI/OWnw9hNpZqDBJZvlDJlOlgCkAKcVp2yBl3dwpH7epHTgRzvXE7nEl12yMixerfBFuxbRe83pA2ylzT+vTAIA1DwsPYiuY5TvH2xDMoxgY05ZTgVznmEAzHMg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6136.namprd12.prod.outlook.com (2603:10b6:8:a9::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.13; Wed, 6 Aug 2025 19:16:31 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 19:16:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 05/11] slab: Use memdesc_flags_t
Date: Wed, 06 Aug 2025 15:16:28 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <FE260A82-FCD1-48E8-80F0-EEE440E3F936@nvidia.com>
In-Reply-To: <20250805172307.1302730-6-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
 <20250805172307.1302730-6-willy@infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0055.namprd19.prod.outlook.com
 (2603:10b6:208:19b::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6136:EE_
X-MS-Office365-Filtering-Correlation-Id: f25f196b-1838-4761-5b29-08ddd51dc040
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8BSAXpWO45hE94R4f0XSWgFQ6lXRQ0NwoLmDLGqKSiO2LqgIoLA2cgEEdtVZ?=
 =?us-ascii?Q?5QlHH/SOG2/c6xxbQrKVzteoYED7dWdBmfH7VuuNQR06K7y/mVF6NNqwnX5g?=
 =?us-ascii?Q?x1Afn228j1EPCH5ADFEeFw5ksXKwmCt2fU3PkcaNdUBQyPY4WSWaKiKU8mrO?=
 =?us-ascii?Q?fGJeeCKgP2JKYxNkSMe4kQcN1xS1U5Nmf3SVQuEJoBdQCiHH9LHfJ30sV1B9?=
 =?us-ascii?Q?/mJnB5k51sZNYk21qISS6bZp3R+ovthq62n7x8wqbrOrsdv7fO2hK7G2WlPj?=
 =?us-ascii?Q?/cL1lcPfGLIoYRLAC83UDoU0plIv6hTWNpSeAf7oa5y/IqPY5J0uiF77CEhx?=
 =?us-ascii?Q?Ilc/P7JtDqg2EX43qK+GzJ65R1TPPzEbrmwm6TdG4D3CcLRUPjHFalPWwYtG?=
 =?us-ascii?Q?CwG2lQS1fsbM54HLx5D/ZZvColxoigRUwULwDm7vj6UAF8314sRmPLRlZq/b?=
 =?us-ascii?Q?NFjYgsqpRiMJeqeZQ8q2O71PL8ybP90pB9/eSWncs45UxXn0EnTQTCc7Y/xx?=
 =?us-ascii?Q?+zyWj1M4T/6VblVYaW79y0ofjI+ywuMkKOmsUv7Lfb3idW+0E56v0s1Y3ER6?=
 =?us-ascii?Q?2W21pc+aXnzwRFjJ6jHPeVI/j++RbmSNQ8trFN4ACyWBnQ79X8vCMo9RB31j?=
 =?us-ascii?Q?mS9DiHSBatBOipEA/YJtMBRoTiFKykaVhvYKOYnrDbFatbvd0dlOigVkHPiH?=
 =?us-ascii?Q?PqBjN6IrOaZWU6kR/4mYSjzeTcVvkzOEYHbxWztKUKpkfUmJFlHa6do45Cgi?=
 =?us-ascii?Q?QrSKlWyJeBssig7qb+err87CXUmgGNOz3p1M2g3pKAmlJMqSGwwlYmqk94tl?=
 =?us-ascii?Q?dK7Z1yontPcNNyPvXtKdVELpQtEqM1DG+cQ6Y4iU1Nitge4uzqB/j8RWMOCJ?=
 =?us-ascii?Q?f9kn5uj+vN9GtF6Ap/pJPXsDD0CoecGHL4W0bY46D4uxWSpx+2q7p+8Io1Mm?=
 =?us-ascii?Q?vbOrHhkUNQiPStwEiU9FpWBM6CWxPdmJllxpKdr7YYvlFoKqdyKR3T43n3V9?=
 =?us-ascii?Q?7Uk4Gv1uG0SIGWJyjLn+yCSHASdOUceikdLSMSK8sr4P5DmetuOZSpJZwJIJ?=
 =?us-ascii?Q?S2bJAAKE11mdq4/DbGtjx09OtcizkgAoneMnDZCdtvt3olzgA6M69doQUdU6?=
 =?us-ascii?Q?oCXI3ekncZKBpyfiiT54CSJWM9+mEfC45qAW8ff+Vl91X/RKUs+ifDPF12+0?=
 =?us-ascii?Q?qXN8ApbSAzFaPay50NHZlF4QU/Ha8GgldGnJpwc3EefyF1KKOG0y/6YjzLd4?=
 =?us-ascii?Q?KcwDHGN/pcR46+DIIFAXyI7eRh3KqSpvQaWFQhcT3hlLmea8QmiS0lPOhD9W?=
 =?us-ascii?Q?yhe5Gkc8YRfJe7zjeBeSlBzUrTWJ7uPQaBntYG2wKJmr0FF1eCb95d+dsQ20?=
 =?us-ascii?Q?7v2HPA56y22WY+y3m7FnkHLbUVhwYtqALYRidkzmgef22Rb2TX8t5kq5dRbb?=
 =?us-ascii?Q?Zyly40nr64c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GH2Yr4xWCe1156Pa3qqUhrq1Yyt6F4JFYeq3XXPqQYGEDwJ5C19vPuBRASca?=
 =?us-ascii?Q?l4TNFImMuZU23awtSw0/U2bVoUpkOSWDcMquZ7FAamPyP6b3dbZ75ONy2fLF?=
 =?us-ascii?Q?y0YOvygGXAE4m5voTQmqLl3Nu9hsKsBly5jS0KjGbWpEVkTaHBRghfmp9H1J?=
 =?us-ascii?Q?IRrDN1jWcSeNYLHdB/1ouy5qEkKxxNKr4RLF3ZZLe97i305S1pxwGeuyZWGH?=
 =?us-ascii?Q?QVYhaoJw+UvTqagR1xiq5D/4my4aFEtjceS2yJUdMyZ8NKdW9YisY2vaHoJD?=
 =?us-ascii?Q?2B8PDqS55gt9lAtubCh8wX4JuqgnmECdfUvql7gG4kzi4HmimMXHvQWkDlwg?=
 =?us-ascii?Q?voVpv7NVLbzdxBvv4/qUABiDK4HD0Io1Q54cZlDmIYbboVXz0yrmjx+hKHG3?=
 =?us-ascii?Q?51RAjDYjdkxybBVXHrn04PFLagec4N/qUwXpcTSqy+eo+UtRR6GEPLptolm2?=
 =?us-ascii?Q?RG8w6nzODDBgSXfmGv8AMc79Aq5GELd/rGhbumPJ1FhsCj79Zo0JzlytP4sr?=
 =?us-ascii?Q?YRLQ/pYymjTPy3PQ+32jkG7yPLota0pJYmdlBd9lAlvUxhdpsu3YAEe/fmyg?=
 =?us-ascii?Q?v2CaSxvoc0Owqh+LlX167UTFMAUWrGA65s/EMUeAiQnB4YmhsnZYRiNiYbew?=
 =?us-ascii?Q?w0Ol7pe6yXnjpxx+vCD/HW1F0s4dWekTXAXgTsQh0xNyNJDmyA4fElVcDNjl?=
 =?us-ascii?Q?LYBCcTnz08y6N4vyhck0WwG3nigJEwOWrALNbSqsnA0ihjQn+tRlwIx6wqqD?=
 =?us-ascii?Q?UTi1vLo6I5QLLCBTJUoP1xLQOAkVEaGDgWUwCmdjFj8dTGEKpqAVGmrLR5xa?=
 =?us-ascii?Q?jywUmTzeCrxzRZeL4bdY9ELVBK28Ic5dJxKe2mVKRzTW1w5E8Cb7Pm5ZYT59?=
 =?us-ascii?Q?xWk31oPV8nFHBLNVBOhYw9/c1kVjADO0g35Q7dCaus8fpkhQDNXXIK2yOvSy?=
 =?us-ascii?Q?qc6jeecKSmNxuSJV3pxm2I8MlUujfkEdtj4fipjoZpAhWIyDTP3ixXkmgH5x?=
 =?us-ascii?Q?IrcblHgh/RZnijYzgOCrJ29TK5qfwgS62SQUu9JlB/1KsDZz/57slmEwnSXD?=
 =?us-ascii?Q?EQevJ3ybJO2c1j4mqMJ0Bl7ypOKUzePVU8+XI7mMoYhpd77wNAi3AMqnzPxl?=
 =?us-ascii?Q?Uqmj/ejwJcv+aybz8jDFNO1NElk3qgISemKOlrECTBIo53fWRsW0L1+SH9+q?=
 =?us-ascii?Q?n6qNbxVk9UzbG2XgeaZak9OhVnV4CkQOazjcY7K9POCwMwWFy2mdIWT2zyB+?=
 =?us-ascii?Q?2p13IwTSuXI4v1aSpfR+3mz+QpdsxApgQdhFYwY+PRUyx/rY/7Bl3RXMZE6d?=
 =?us-ascii?Q?7PLSK2Ki+zFGHr13EikG6eVGS9XaKzt3lfuTndUEUnVN/PDMkU8dIIKrvdXO?=
 =?us-ascii?Q?ZoUlwZhw9nhp8fOghIHQ+aV9WQIP5AkoShFjdhCG03ptrtXpoB5/1zZHSqvY?=
 =?us-ascii?Q?grhuIkmgFBzFpsT8VQ+3eYdPJS+x84vTgHp7TD2o9UoJPYZz64oD6nrOfr55?=
 =?us-ascii?Q?r0NceGswKsxfvTGY5/pzi1wOHuxF2KNLt8lYrtSMBO8EDZQg7fzvq6wYof+4?=
 =?us-ascii?Q?wfpf9N1r2s+6lv8uxN4tRimbwTXn03tfa2SwgYIP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f25f196b-1838-4761-5b29-08ddd51dc040
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 19:16:31.4205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rVd9tJ6MyDWjVkhuLKlIDu0Biot8HuwbVJ/zybzMlkp/FKURwFEyrUqz+R/AMGNo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6136
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9708C18000F
X-Stat-Signature: w18gcir98ophwxb5r5wsy7b3sqcim6dm
X-Rspam-User: 
X-HE-Tag: 1754507794-768362
X-HE-Meta: U2FsdGVkX1/Z/yKJSKXgId+crQXkuIPNDdq2qKBHZ0BG/Fi1tH7PxFUMNogHhN6SNTZIEmYFC6nHf6+zKJdGKUvY8037uM77iEUFaw9L2B8C74QoqlKaDnwMS41IcgV74c94HqSRRBLHuYVKqarSlcbiZYZhWkFMwr5LjwR5vc4f0JHaSQgI1yG6P33RYuZo6RIZpTvBpnhZcfEYmM0mncBYIz/B0RkYkp0E/hs1JLXX4idnXpZqUNaOpwDpOhqORh2t+Ebo+eYztKCUbgK14/GE/pIsVHymsggRBhcEZbQaPluhOKyPIeMRIrM9lY7qs3IHCfkaLKBk31wGh/VRHWrDO6H/AKrfmed3FDUayb6MXSCCaARqXXv+5C7o5Lp63nZfZIOOyAPRJVetIfwq9NyISextdzflKB98Rj501ipZcqlAk7s6t7WghjmBWTruZ8l6j94Ly6TXgqB0xdVnd/frz6zU7S2wwV41gS/HCRyxwg/UcfG3Pwqwtk95bSPZkHIc691lkk4DdDc6WF4Je4x+fDV0SURk63J4nP+KDzHqj61XqZYaXsIltWCmCCKBu2Fi0UU72YPsFLE7CM3H/MZFgOuyYd7MAxY1Bxc/OEThxSUBTUuZgUGAVpcg9QLDS16rrWednrKbyU4gMSEq45WSwNB3WZd8uSD4/3MUFJdiJUtB4kAM5TuDhor+uqJDnzucM2/Kdh7jICiDFY64bViqO+TMUq4sPfdvSGBcx1RdKFyQUBzct1b3mpgC32Ru5+nNGZ6t+/rLJYryWm15CpNoccjYAvlu3Wvb0Lw1iVTfFmnC0HiNbjtA7gn6/gdblr14Jl2FMrT5N6Cj+LZihPa3LPLqrmFldTCv1WcN6HbSpcQEgYv8NfU6XT7NOHAsVV+lk3DhjvyWR6zwPd4Qv8GWOtA5LV0yDpcB9LZ8ciprkyJKWtpET7suHt4pIzoeFzmQRddIaHomIQau7bU
 uTvjNPA6
 YOcdOy9nMhDsFrR/AFfXn231ETvtB4zV6JKn6FHObjr2LPGQ5aJknBcVOvJOqwh3q3qugpdSYQvCOhfq6YZcm56X5owelo70eTbJECOgW1ohb/+S8eUDr+vHAck/TqLDtgy1k+2lq+ODuY2rKRBP3zSZJ1/Z6BBmKdtcPkFnCRUfL2G7LxGm8LIs40Lp+ngCNg/dBYJ7M9xqIVfUtKCOyqiqdB4SJ1PzWVCRBJm/cKG7u189FLAso35sTVp0HfOc+AYvGutVSdkz1DsuiSCoPf70yPz4Cl2j6ons58vYAo3TxSwuJJhK7yIIngb+4y54YZ74cg1CbcxBIzgBgi57uozD7S4RrpzGqd3IpCVBI3TiPtuMYf1O1pzi5H3SNLQLsftzo1Ga1/YJeuZwVNUbUg6oeSkwnRPbqoY1KzKHJTHRVHwx9frfVj14yADcfiCaHimuKX0+XV1a/yZP/c3EMOmIaz68Hw8EuxXq0Xi5Hn0KUlzbEoMVA/0DYaVkivG+3NhBOuV9d0+RTDpeILW+umLJhXW4ao+antvoLk+hCaqqokFQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Aug 2025, at 13:22, Matthew Wilcox (Oracle) wrote:

> The slab flags are memdesc flags and contain the same information in the
> upper bits as the other memdescs (like node ID).

Yeah, SLAB_MATCH(flags, flags) checks for that. Ideally, we might want to
use the same type for the shared part and different types for struct specific
fields. But that would fiddle with struct variable bit width.

Something like

typedef struct {
	unsigned long loc : SECTIONS_WIDTH + NODES_WIDTH + ZONES_WIDTH + ...;
    union {
		folio_flags_t folio_flags : FOLIO_FLAGS_WIDTH;
		slab_flags_t slab_flags : SLAB_FLAGS_WIDTH;
		...
    };
} memdesc_flags_t;

Hmm, seems very complicated. Never mind. ;)

>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/slab.h |  2 +-
>  mm/slub.c | 18 +++++++++---------
>  2 files changed, 10 insertions(+), 10 deletions(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>


--
Best Regards,
Yan, Zi

