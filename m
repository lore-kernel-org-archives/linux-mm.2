Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6C3606A887
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 19:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SHm0kT/3
Received: by kanga.kvack.org (Postfix)
	id 3595C6B00EF; Mon, 16 Nov 2026 14:32:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330FB6B05B0; Mon, 16 Nov 2026 14:32:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246CB6B05B3; Mon, 16 Nov 2026 14:32:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8EBF6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:32:00 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE764120253
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:31:58 +0000 (UTC)
X-FDA: 85441977516.09.94247A0
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010061.outbound.protection.outlook.com [52.101.193.61])
	by imf24.hostedemail.com (Postfix) with ESMTP id C83F9180007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:31:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="SHm0kT/3";
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794857516;
	b=Z5m4zQQ0TxdmcNLuqinMHz0W+9B5iIGUkH4F2K9sCKXhEw2xPcHXTQRy0UgP0WVGaePYRH
	X8cBFaQX2rvYiAAO107j/AyszXYVVqBffYkQsVArGkbVEA01VFd5gYDioQ4pt5VM8deJxb
	s3+sxlONmrG/wttSCzBsL+BTTOoVtAU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="SHm0kT/3";
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794857516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYPCpAb1FY9VNJpL+EWXBVDPnkM6qO6jgIc6uryhp44=;
	b=Q+5SyqPGDHBcGwjy9dij1PWbICllevurp/OU8aqvBeGRdjTcZrw3oDIAGtZ8ROGawDf7qJ
	lA+sgN4I1kXyhivLWRzj3gAzfBJ088QhH+ZKeT4HkawcTDMoK6Zf9BShyDXz8smZTGI9w8
	/vQuhZNfvc3YOxDpqcM3FWz5qSgCHgE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YGgpqNF1qmOigKiHniXPrat1d14QgWdoUhQABgDZ1xhGlkHKnK6q21hWa4Is642R4APdH2SKRO336qZy/dP07sQvrMYP3aTQ47eN6nUyk48Wis8K6za/B+gpG2CZDfMuDCAH7UuUjUc5xVAbVVdzmqlxSQFo9PVX+k+f71LY8jkWOijghXl/V8pFpxT1h8TZE1eeGaBk8EYoXJet4+nKYvEEZ5anZS7mR3GIUs3QEJN692KAWwS5aid/11WQDJFore8GTAiCn0Gjb5AiLUd7gCIRHfrKndwEzQK5WttMPhUfKiwnxNp4E/RT9a5gDBVb0DkT11URAhqMbKOY4YORPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYPCpAb1FY9VNJpL+EWXBVDPnkM6qO6jgIc6uryhp44=;
 b=C03CVx8TxzRKhtoBjVXiMpL2gDSwvR/w0xo7LZmi1Ugw5j6zykJb3hrBO/qxmERHFFAtyi/3ZX/1NeLxkTOXcoKQNNq+D7Giv1qGR4P/D7uMJD3G8x+4vxGD/NcN52bhO6ObW6/6pPWlEIJTzG/Kj8FvEAKO1AiezfL0sMw1eNeI2lN3P840FNreuV5Ll2YdFq0D9O2Lix4vvYt1FhEhCA09ZcoVlBzu1bnxvfqVXAd1UxcdP8EI2aYV+TWTgwe5GSbXVPnZ3I1P4+9rx8lFaCswemV/agW/kxqV+2v2jbp3QLqVq2ZAunraz6y8PP7RTVw40lJX/wBDx4VnwASQVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYPCpAb1FY9VNJpL+EWXBVDPnkM6qO6jgIc6uryhp44=;
 b=SHm0kT/3maonlcGqV5ITWbYkD4WUpKcqU39krG6nPNmrOB7QH3UBzqnXelGIu1+PWAjY0aivG5Zml4F2ib4BTGkp8Iz5gsxYyYzTFmRtGDhL2PKuQlNku1oeBt+d3d/M0shRO9LtvFbaEm4PoEpx4juSQmBqkdeVHdPL73mgsro/6ZpIs3px+4gLldVL3VljQBkXU4iK31kMys8zD8jzhsvzCJc40tT+20UDGfw2eo2KbF+8eGGc3LQQdqkPRBxpasxQBkN+j3vw1I1h8pokzXGUscdR62eX/gLDK/BqKNbIJiyEF70SgcFcrDl5e2dsHPXk8ix40OxsBUbbW6/hZg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB7941.namprd12.prod.outlook.com (2603:10b6:a03:4d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Mon, 16 Nov
 2026 19:31:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Mon, 16 Nov 2026
 19:31:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 kernel-team@meta.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm: don't PTE-batch a swap-in of a folio with a
 hardware-poisoned page
Date: Mon, 16 Nov 2026 14:31:44 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <7D33217C-8F16-45CA-B88F-9A619C4DD73C@nvidia.com>
In-Reply-To: <20261116063624.1382944-3-usama.arif@linux.dev>
References: <20261116063624.1382944-1-usama.arif@linux.dev>
 <20261116063624.1382944-3-usama.arif@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: CH0PR03CA0373.namprd03.prod.outlook.com
 (2603:10b6:610:119::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB7941:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e1977d4-4a1e-4b09-3517-08df44184144
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|7416014|1800799024|18002099003|22082099003|11063799006|4143699003|56012099006|10067099003|261026121527099003|261021121427099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	nCRwJqXzfSfI9Wt5N4Id+g2cPqAcMbZ7QYGtOvnu60QuiRkR1RI0mNgkJ27rNfz/O/TVM79oHdRQ7d0JtEYDJ1Wiy5t26fZVXyQ6w/xQSGfXfVXpZa7U4eNr8roX0FcpgWNYhp+mSQUxxvX+8SmL93PHJbwdTlSck5GH6D/dm6gtl306KxHcH5qdY8zqH3DzYyicyJzWNrbTGINj9GgjIbOfHP5vjIjvYrP2cxh3XaUrVzHrznOsCi/D8PhVCWz4CbBP3Rf6Amwa3ZS+TGFeu7nsmdngnrTEcDuBK3Dp7jcxkWob5KaS2At0lKQwJ1q9+3Gz90H0krXW8Zaw/n4LFgMT8H6qi6qmA3O4UJULqJAqV28EtzlT16WmN84Z+MyqoWhXb1s0KwKQwvWCph8YjsNTR+x29NIfCymu9UnOoaq2+FLj5P6njJJJ87PT+uXw8vRri5DREs3QOH5HwMPiMfzBeAdhVBVPGk0b6GMKzu+siHiBfH+Tyd/kqF5tMtIxge+pSKnHNVTL5OM2mg7gXWKC+ps1VAMkee/jjC7nTtpZMUCm4beg2bkIIHEw3cXmjT4TpVxm8zgarwXmoCwxqi2Hl6zZgcPT8QduKJu80CJ1z/MZilSJVgXGEqaLhfiAm5eqhnBOmEk+55Ujd1NvYgpujqHqlZ28nRC5u8J9Sis=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(7416014)(1800799024)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(10067099003)(261026121527099003)(261021121427099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YgdjFNU0zB9qf+7R5pAkxgh5VXwgI1tF/7xUJtiTyDJe6n8n/5Mq619pOxc8?=
 =?us-ascii?Q?+7l3inTTJW10l5yhP4nMfL1rV+0JSK/osNWlRV2zGoMFZRDjF+8mq9fzZnX6?=
 =?us-ascii?Q?lXkeWtWPcvuUfKSprIjftF4+eGdEUsj4ZoJ3iBqPAS9vg8n1uVdXnM/Cy57H?=
 =?us-ascii?Q?ORPWkUrOpnRV3uTBHJ9tI0zoWCYTkuuntDp4+yep4w5f4jPMMk9NY1hW8C2G?=
 =?us-ascii?Q?8CLbZLt+bzA6e7/aWvrQ6R38KJAaZ8zJFeCRfrR6ib4etqWADt9NHSpxCyP8?=
 =?us-ascii?Q?GIJ3RM6c1DHx7NTfqDdj3P+HdBpfEVVkOmvT2TOKp4dRn7PxNqivj9CxWpIg?=
 =?us-ascii?Q?Ksmqhd9fYBkkonCcU42p3DpOYJnxb2jkANNbJWhaIaSmfU8isr2zg2I0WKKg?=
 =?us-ascii?Q?Ab4bi0PSSJhuWrTxhgEAPwaH5hVeeYVufaOpeEW8S8BfLhGvMUDdNv94d9+W?=
 =?us-ascii?Q?LA/ZaETRPvfTGmY27YnO49MzHZH7zEUJWTDQqehVG3Dp2Y7HKhd5usJecjLG?=
 =?us-ascii?Q?oh96RWlWaOi6GPSa1Py6ER0rx2GJW+kmAsNfDKJdT5fIbgzrEqLV9hJQxGhJ?=
 =?us-ascii?Q?/pZaVyz3vsDCG4Brj6CGW27h8gp4ZEPO+UgpcZixKqaTyKwB5m3KfazqFoBd?=
 =?us-ascii?Q?lIV66RNgSRcc5+l41XWKNkdhRyW7fHIka3bm1ca19CMzMXHOx2ost+b+BK6j?=
 =?us-ascii?Q?er6iCCG7g3XfFp5tjLiA8xH3Hp5OGDw70r0kgao9qDXTrYlr50loL/ZjwoZX?=
 =?us-ascii?Q?n/OheiJv4eO7l54Jr4W8gQAUYDXNyTN+QY90vvcdj/T9iQEuje1G0tMuYqCi?=
 =?us-ascii?Q?aMNu/VnmgHNQ7hAOz3oT1ako3GnDI+Faldkb68Z+DXqT69ZmzP7zGSstvoDj?=
 =?us-ascii?Q?cr9T7Q6JnxNL5BJ8tj9hlLPvIzcapTFx7xo5i5cr/1H0B/frrePm4YMFBQSh?=
 =?us-ascii?Q?ihcwVFwep7QmDjqEOagsiMUnsT3t1TS5lSzg8GVy+qPdztf51SKBlGkhF2PU?=
 =?us-ascii?Q?mUYZKZcEiB+LpJlpRpdWJoJXiwXZKmqX4u9tY40SBueYfLps+IaLNZ5oWmjf?=
 =?us-ascii?Q?ZVAdAhPos8TK7lEb7G/GxYerL7n8+olRUm7gKMBHoNiibWabJM8gmGmBFzo3?=
 =?us-ascii?Q?IwPwaTtNxUWQNDI6MJtrcWFP4PCXokVCAN6JWM7WzVA9WiROe9TdF04BPOSr?=
 =?us-ascii?Q?/ZNPXR+09jDQsnk5o2txukhxRbbtK5UL8B0epC7EuEu92lwDq1mkj3FvznZ5?=
 =?us-ascii?Q?yKyUiR84kQz+wX7WV6X7dX+1CCpeSRfeQtTsQRNVKQ4XH64Jj5Dv2JHk8cZB?=
 =?us-ascii?Q?TMFrdGjmlQvOd4nIn3jk4Wuqs7nUxeGY/0H9x+TwDJu2SwyYcZvwIOts0VlA?=
 =?us-ascii?Q?8fAuXY5jqfxh7e/+hM02CfWm2JS2T12upV/zLDsUoOykaAJxEJN/X4GMDY1s?=
 =?us-ascii?Q?MOBYtmKQdDXUUrWpsJudWYUh0L5guCnq56USOjKG1nSS+AOh8nU2FMvt9Usu?=
 =?us-ascii?Q?wmYCt3biRHPKc0dW4GYcNgX4Z8LZUlxfW2/vWrCDmDKZw4iI+oUqo1k/FID0?=
 =?us-ascii?Q?TzP6H/GQP/RfiC+DdB/Jj7/Qd27W4l82sYZoZiorozUO6CMv6z6yXxZllC1l?=
 =?us-ascii?Q?pvOwVQcrL2K35LpHq8rlE9tXJmANqV3M1DyWGhuSkkdg2g7IqQoczWvwqGcV?=
 =?us-ascii?Q?q9FVlFZYy6QzAdTCqKnQ0DahbevO/3OvDUwq4/8ewwdkkyze?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e1977d4-4a1e-4b09-3517-08df44184144
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 19:31:47.5892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nabj33zV+YS9WAFlAhidgsEaHMSpdd70tQZ2yQLpIZfUCiJv/HtzBT3fGK1Y5xD3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7941
X-Rspam-User: 
X-Rspamd-Queue-Id: C83F9180007
X-Stat-Signature: irser5fuecz3317gkdp47t37kq816fts
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794857515-265806
X-HE-Meta: U2FsdGVkX1/9939TbIsR5wPflK63mw1VUBFS/Ew40fubV3+uFiKnEBISQ36BxFAVY/BlVp6ii88kqOhIyzL8T5DTzMV1bqaOdDZ3Pp4XJmSuw9UuZ7Im7MnZMp3r3KBX877A+8Ml02bd8AqEivAFxNmLW9iLeghnUu6PUqaFrklzBUjF+YwN6OxFOMw2DiptGhuGMZ90MzELvWy5BQ7yXI8Z+8DuKbglzV9Qz9CEg1eNfBbKBapbNCpcyqtfR9i9eik/ypQH8AIBeCDvh20/YMhdoX8G7n56M/3yNnrxiLwJtIJGrjGjKHyf0OR59ICb/5BE5nZqavyz+ltirqoQXkTPaIk58tBwtmOBpRbyR0EjnxI+97SGQ2+K5Q5C+HywXmnd3INx1/rcfYm01FJnrLFCB1Np8vCnKPeSuPkS3nWujGy/ZqYzvaJVa9UYLH+UP9OIinJHpb13S13jrLotWfRoys8425tiErez0VyEgjIVxi5VD1Kzpj86oFD/lX50O+8AkL+JDiveadsT5xc81M4UL8LINKiLWqjfODU//nP7PKS30FBnNsfDAjAAlvazh3sdYMIWWsEaBNVZfuyLJKnZIIHvU/rA+hCuleD08xfAFZMn5vs1licdLslcgdobUsdIQXMU82hWAyjUJZEpnjHaU2A2Weuumsp6P8UoLjYesH8mzkDM5yDn3Ultc0pvJagQo4SiJpEKcKBRAeTkAEfGCuphscAnnJs7fClYE37fpsKUcN6jjdD4wjht6dwq10vCQnNzxp68NajwD9sQQ7OTTUS3p6jTrZPlWJfDXWQ3ZUCkleaJA9VkTagEriodXJJPdaA9QrLI445+GPVj+yyRY6sCOC/eWG9K4N4cMrfZS5kXrYy8aT6vYHELtncw9jIkJSquqQ/yHpXL25SZTJqzJi/uEgRc3IjIILt4jpMiSx+fc0zGbPFdK9gUYRA//o+1ymgW2p54dXlQgQa
 9dmQlyOR
 +dao9nmoqn6SLhJVxPWG+UQAlYsSvr41duZlXztog4JEnWBeVMDTWFTgxOuBCNh2hGcm3h3OykviwjfMzZ0gMkLTCOqDIF8tWsrD/tEsqxAJGnGCqFa/kL72o1rvBsHzhWSnx8Py6JfOb/T0ex0eSCxBQHbCiQi8Y3gEHxKa3zNdClKIYAmwgps2GqA/WKJ/Y7ZL2oUtVreJJ8qdw9/cgpBizul/Rw+GMdHwdlO2uJ7hLxulKAJuj0kpUVB/3tXDrVa/c/5H0Y3DETtgSn3s6wi16CpR/p7yH1/vkbKUvOqJ1jOdTWI+G68vXhFO41Qv1kloLc7jqzqyMQtas93kSoZjXKJW1nDbRIkp21+I8ldtBnV9Wo3KlQO0WlDjcpnNyxQtG9h4gBZkS3wOLaXqQjEc5Z/fqg5mBrVsgHIaMdQr7SEOQqZ2Q2TMIkJVgVvEW+fX4e1U+9Hy1MlD7l1vZT9u2rGaER2J94HXkTXqbMYaXqAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 16 Nov 2026, at 1:34, Usama Arif wrote:

> do_swap_page() checks PageHWPoison() on the faulting page, but the
> large-folio batching path then maps the rest of the folio without
> looking at its other pages. A poisoned page that is not the one being
> faulted gets mapped anyway, and the fault that would have reported it
> never happens.
>
> Skip batching for such an anon folio and let each page take its own
> fault, where the existing check catches it. do_set_pmd() already backs
> off the same way.
>
> Leave a freshly read folio alone: it is not anon yet and can only be
> mapped as a whole, and falling back would free it with the poisoned
> page still in it, which the retried fault can then get back from the
> page allocator.
>
> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/memory.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
Like David suggested, it probably can be placed before folio_pte_range().
With that change, feel free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks.


Best Regards,
Yan, Zi

