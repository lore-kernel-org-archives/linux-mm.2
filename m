Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 232F1F531C3
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CBE86B00BF; Mon, 13 Apr 2026 15:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A44B6B00C1; Mon, 13 Apr 2026 15:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7934B6B00C2; Mon, 13 Apr 2026 15:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 670326B00BF
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:21:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 461AE1A02E9
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:21:51 +0000 (UTC)
X-FDA: 84654502422.07.71EB7A2
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012007.outbound.protection.outlook.com [52.101.53.7])
	by imf29.hostedemail.com (Postfix) with ESMTP id 812E512000D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:21:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jqPCqaGN;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776108108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoBCnPTeqfrm1QRjZz+gi0AjIAZR252PiL2hmCWGEaY=;
	b=snmuts6keA9gBJc5w0b7JYBazxsZHnatYzp6ZeGmI7JpdbdL1IoSNYk21tLd3lfbyqMJvK
	n+IySAmDbKxCqwQe6OiHV2QOF6ix4IdeLaKvAwYbC6RxWeXJDQ9XIzMrtlM6g9tmbRLb9Y
	hossfkfwWPPnDOBjyD6VEmA4qHbeei8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jqPCqaGN;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776108108; a=rsa-sha256;
	cv=pass;
	b=8TlUimRbhuM0oy8RCW4CDEVlIFYxissPaXSvjS+Z6na+TZgfORbYEDvJyaByuql+5qGXrM
	OvCGK/P5lbq0BSkH8QFuNJdOsf8Qh4hJs3GbmsTq0b8q+gKFmkL0kbHgqpxKho45ubKXkr
	iuxLIqfKwL41hwIQ+kAkTo3aoc8bD4U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kqXeHDOpVXCTk6vHNVdWzcMOEHmnzKvGvIvTKPs4RAVFW2UCb/B8ACx4tOfqzc1OEMgAMTVRPgqVB2wRSbjGJBh789/3xxWEIV26JWT1pkZjJg1f3ubMHB8LyKPjD463T3vRspKqSjORFaJUzUrHF7haP32GuyJe6X2bRjCKt0Pn/QOq8EWfwy9GqozTC6p/W/tGBmZwrzjCzOcVUKwkER8G+6rwalqjGBp3wYP7TDTRHrbt9GYuLpO4ClMBAo1t5pJmNEvKyw4pqcv2FHUsuUfNZ8+4UfolnPeMv0eei7r1L76wuNuBpIdmzus5K9bFynC7jcodzpM33ZRGulFI1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BoBCnPTeqfrm1QRjZz+gi0AjIAZR252PiL2hmCWGEaY=;
 b=oVsL5l0PmwormmoM877WeMY/BYaZi5uPteMKYxYqBdss8vAxU0ZQn+1J0UeigPOyCMBwkvIr9AARf5PHvkAwtWMfB3Nbrexx9ehJJxvb1y1Q7BzsUCPbbdoqniLAQaMaUrMrrq7of+xoy3FDmvTHt7gM/t+w76CppgaD89+Gh/j+sOlVhxjfgRPpOS0iN1N8dmu9pigL5CFQNZjQCwKP5e8fWYlauIQwqNixL5Cf5kjwgNXZuT9PO6ah+/n9WkfreLCqeCjxG4tp+dWzEavgaW1LSchA1MO9z1ktr6CuPq6Ocy7WLWQXEz5keTW07hXW8z+IhdikmXdtOZwczC0Dxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoBCnPTeqfrm1QRjZz+gi0AjIAZR252PiL2hmCWGEaY=;
 b=jqPCqaGN8j2rL+NVGPNsWL+SQDZiwK5P1pXUptn0gKCkASwzLigD8M/Llh882rw9oXfJPO28oUHh1k+l8w+6VzdKRWoXwPuKaTXMZMIv+r6El5vebAykXwdL3XWu/siD5lwJrkNLFTD2AUBzaXfupSw46LPLH2xLZFp9fieFcfq+eFNA8/6HGj8laRHBoBT3WoSxulDh5JaKVH7PRWfAUr+7nkXvl2pPRgQXiivLiabc0CrKhNnd1Xs62nuIjjF1l0htxE/sI5+3oYCelZZxHlptqkKh85M375k4b+l3gMNONogwATkc6cui/RHQJ4Nk+TzeBOIPJtV/TmTvICf51g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 19:20:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:56 +0000
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
Subject: [PATCH 7.2 v2 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS from comments in guard-regions
Date: Mon, 13 Apr 2026 15:20:30 -0400
Message-ID: <20260413192030.3275825-13-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0291.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e95e092-29a8-4c2b-35ab-08de9991c989
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Zscl4/LgEGzPrCZJSbRaWK2vHOPlV5WBNISOc1NOmKOfS+8EEdUAkOcZgvnY8yCxzlYf8IH8URUFixBzyGQMNUn0KtGqJwfw+k4jHdQqQUd1nsBtgWB8SwhtVRMyURTvEs49IObnHLl6I8vCtGSbf6bV1L0f6QG4XQdNpN/H6J1XKWkw+nHvtc8R6Z4m88yQr+FU0x83LV4oLOigFBxSvg8SvPJAqxjyyuK0XtrCFTrHow+O9+UluVWCoKto3bDLHxBrqxSK4t9nfxygvm+lxKsTe5rfNFfIsllGZvLEk4lyQLO+DLFfrVWVX+DVLICDLrPZK0Bi1oDuURb5FN2fjqnyFhCmHU3s1mmnOiknL9fL1JLSP9Mky3InIK6ZmVN2hJSkbl/XkWx613ima9sn7mB/CX6D+sAuNm0JSd+jtiuiZWlcFlrurK96VM1gs7kUNkeWMAuZY4+j/A/9FuFympvcxrphuByGonQn4THkB+yI3RWzJtUFDGvuiCYbi4xa7XhZ8WUfAiZwQ6ZTBrl55K9HDDU2rUJy8jA/yi3OagE0Mow3RSc3nlfCeHXFlCOu+TjjLqrgsxXO90D8Oh5F6OkGyNYusEKbaz4R/beKlulnCuzfNISzWDgOqoTXOOWB4KLDXORrkMcJImOGBH0olSUGwRRlA18woG6piwE6mhesRL27x2PvcQ9jN88DCEAPrAPqRhqP+p+OPvfIeyTSJje9JV+wogVJ69i29r1BCjw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g8qvfWn1QpNvII8JjI3UtZGPWwYKhrAFlMqV+uEhwKX1rWgqpv0paf9WFiIt?=
 =?us-ascii?Q?pKA6zd0WaDoVLuetp5f1OXd7dOtCa7AqsCAVdCxPvpNg46CNj+xW9VfcjADv?=
 =?us-ascii?Q?FaS5FQVwWCrO8Qf5FMpfC9a3bbFqDWC4MSNzF0g2v5FnMuNl9xscx/8m+pjb?=
 =?us-ascii?Q?uNkk24AD152310eZuyUOju6HSJP8lPAp0PUgaTHJVq7e+KudKQCjjMriCrwm?=
 =?us-ascii?Q?/9b85NjOlubq0yD4EikXKEkgYoMlVQJV2vwR929L6nIbOnKjtJFGL9Mnz6b8?=
 =?us-ascii?Q?boq0ikZ/yMLwdi+KIbNFRxcBtUpLoalhHh4WYI9crEJyWK0wgjRM/j16bbln?=
 =?us-ascii?Q?0XLpKtyYmG/uKIrDkH25LljJN2dwlpWHtGb+dlE5BDrR9cZcn2duE8HZPeEz?=
 =?us-ascii?Q?f4xk8lVRhBIzXC6y3tdMO80Ene54WOjfJ/akwLfgnPdvIJibBP7aP/jxOHmj?=
 =?us-ascii?Q?kar+UP6E8jVKK79QKYOuXZTIOD8V4fGXWa9I14cKIFBLTBD8fghRfUuxc1tc?=
 =?us-ascii?Q?si6G+3j7e/cuToukcqJTcwQ68hqBlv6iUwvk4OdawvUEtnEl3Wow3VM2dzXy?=
 =?us-ascii?Q?TdNpht69nBYiUm7DGqszFFbjGAZF0IyV+Ja5KfhMrMBUnsJAFyfa2OpS7hdK?=
 =?us-ascii?Q?aPdhDoJBczV6OtGRzjoJ5/EgTM7T9iaOCCFMZo1Me5BDGe7tjEeppGYQ2f87?=
 =?us-ascii?Q?Ag5r1AzBkE0dvHl7RbE6WR/kSzEs60uOWZ8a6pDRKyNoF/kxFo2uadPFr9Ya?=
 =?us-ascii?Q?Wkk4ox0klqck3/eFpNcW9U1YlR0Rop8sHg+2h3zliUekDZqJoDb5hIv3OG/s?=
 =?us-ascii?Q?RIgLhOB7aPfLePEnZoK0txNGwO9I/vRP/R/wxkA8vMc2f1zyjfRAdE1TqHld?=
 =?us-ascii?Q?hoMv+T1n/cExE7VQMLKiPPXDqwalCytVWeLFmZ2qMDn8e79oKxNomtt9HToi?=
 =?us-ascii?Q?2/pYMZrEtZMdG94mwVzuTyfhm+DmhB4oEgM2E7GU35KxKt/Q3dPHoHbQvKYA?=
 =?us-ascii?Q?aKC7S6wwGXNCp+iNiPUHiHFwfJs1qp1uq5kWY4G5df7LkQG3To0wFTIJ27Pn?=
 =?us-ascii?Q?9Cv3nj2yhn+gIqfJFnUiN9llDiAtodawfyE0yen5YRjE2QNC6HeE8q2jmufU?=
 =?us-ascii?Q?8bw9QPtFxlF1Z+P9pc90nAeyUG9pYBAEoCmB3zBNCbxqcnQ9x9urjxVgBsAu?=
 =?us-ascii?Q?Urr+rSzyi9c0rDn45i2Ntyx+beu7UTtQQTSmafL6iCJBmE/2APwojrr0PhY7?=
 =?us-ascii?Q?AYVD5Y5ZB5B1Gpw8LTqjFk76GfopTEPlUSs8e3yHcF9OQJLhZ05Tb6NHENiK?=
 =?us-ascii?Q?yQSQQrhPT/KUgF8AYK1PNpwDdm6X8Nko4NTBFhorX4AV7nGoHuWrlt1MYvVC?=
 =?us-ascii?Q?z5VQDn+twQy+x54Nm32OwHtHtpD1e5Q4JdW0Oy1ob6wEXU3Nia6cPRtzTGgr?=
 =?us-ascii?Q?cC0yvwqXad//dia5uDTVFLzs38idhYMMthLQtCR50nO1NWkYTF/KLgFXLbZn?=
 =?us-ascii?Q?H4GwJm4NVf/qITN78INTYtJ3HD/7LMR+Qr4aeEigQp93ru+/ztcMpZ3YXOjT?=
 =?us-ascii?Q?Tvjdrc7cYbm4C0hxCPDreFir23+yyRnYzJkHEBOaEr+QGsFmTPpnTJZjtR4G?=
 =?us-ascii?Q?f6CAzZVgl57bmE3QcXiMcs6T+gawf2tN4QhKYeoygH+9F8mnzXk6rDFUqN0D?=
 =?us-ascii?Q?0m9sQDxYv9VfOrgsPZ6n07sNZuOzCpXONUhpC1j68k3xOzqN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e95e092-29a8-4c2b-35ab-08de9991c989
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:56.5524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2GR5eSQMyQ5i2AQ39DFUYEYI/S3i31Zji1txd+Yvp8hrWGRNTGL5EcJpi6tp8Iw+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444
X-Rspam-User: 
X-Stat-Signature: jypsckd9e6i9ttmb6gefoubhjjt355ii
X-Rspamd-Queue-Id: 812E512000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1776108108-174172
X-HE-Meta: U2FsdGVkX19Zgy7Qf5vARb1CqMN+bFEXZKzo96dyNwjMRIuCpOVhjG5hzzIUW6pwRzIPMTaD1gfE/9sDEvMMC/CfTHtrVUpi9/pVGv+Ygk/169bESdEZpiZSv3KEL1jkD02J7O4vBOIfLDiByiEx+tDgjwmEmu+ZHHbLuLxz8Urd8i0Y4I8kNAUySGCG1oy5mcFHi2QjGBSsWTQwdSqDciXRlO14z0NK0gMBcEzvLvWWDlXklBb6V6eYHzY3bBXAMDrpVKH9dP4SBZiDdKmM0Tte22/4qwhOXo+nFFYW8O4qrBVU8Mf07VEzvbng7QBRrZcn580ntSXB12rzDuAAJ3xcXd736Ns9iAOUXCL45BvuMZDo4kyDDR6lputaolgAOS44Fo099aML5RCP6WJOIXXLRyzkI445zEBv8V0exowCjqfpNTPCcpbRVd2phKwOO6yROSrrJ2391LMqScXM5yomi1DnFQWR5lEZd1rEKQv08NT5GUADWpZ1ibDbWL+b1VNAdEENgeeM9fGdU3QJt82IRM8M2nTnUVX1ERhCt64vGBSYYLTlstXUn1Y2tN82InORKIyetEJrR5vpFOAPCjk9FfsuwkuKuEksxA90fuzb0e+1vwiOi0Lr/ERRJaZI78WXAfMnaXxjrfcGNl1lfXLMdDzVnzP+7ifBc/dDfwqYTVb2NXqRBEjG0lfMCJrOCqo00yex82NoTjSx8nxUx9WfP/T3DvJ/nh8r0oi0qUVu8NnRS5NVO7tVzjQrgkeKBdRU32vwhhlSeo9tM7Gw0/x0EG+mw6XQb31ruwHeTUklULTi7MxbwPOn3hkqSe0TxdaWmmrE1KwuVpjDzlH1ledjFDgvWw1QN7OcAt/67o2f40trnKxMZ/S+hj5HHp/hATI8sgplsA8UgOipgglNKcuZboZok/N6zm1i83vq9+WgkomOEpVFToB7vGkl2z69dNzaMeIZd2MD/gu5G/E
 yngqdY2e
 rAXzTk9gjMBNIefr7xR/w4yFKEi/hJDIOvNJJ2wq8g4ybBYmfYabXtDtB7YeDgDk6ONfG3VLRu1S+JEA2ahEmWBCqZDedNiKsGlWCkYgDY5mQXAX4yCz6IpgiscjitrDCvF6D61kiOg8w2rZhgF6QQ4GoF9DO8xIzhQFiB2dhvE6F8Hy9RVD5i+4XifBDWp98K8Pcpd2s2tyh3L9uyP4mQ5k7rvxddgapcl6rtKoj/PCY51/+CncKVoDAt3WI812eAvumMtxTIR3HYZznQOLA+60nMJCSCQYchpgHZWXR3bXKdTEqKwuUnHilc2CxwXkWenFWhN1l7T1JqNvdSKgxCmNvLRfLLQaKzJmJDpIrRgCfP15XKnD91kkudxFpwupJKSLrisZArEi7AdCdgWllbkYtoPo1Y6OxCE5DqVT5C+8BhyJqYQBK5/vbvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Any file system with large folio support and the supported orders include
PMD_ORDER can be used.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/guard-regions.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 48e8b1539be3..13e77e48b6ef 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2205,7 +2205,7 @@ TEST_F(guard_regions, collapse)
 
 	/*
 	 * We must close and re-open local-file backed as read-only for
-	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
+	 * MADV_COLLAPSE to work.
 	 */
 	if (variant->backing == LOCAL_FILE_BACKED) {
 		ASSERT_EQ(close(self->fd), 0);
@@ -2237,9 +2237,10 @@ TEST_F(guard_regions, collapse)
 	/*
 	 * Now collapse the entire region. This should fail in all cases.
 	 *
-	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
-	 * not set for the local file case, but we can't differentiate whether
-	 * this occurred or if the collapse was rightly rejected.
+	 * The madvise() call will also fail if the file system does not support
+	 * large folio or the supported orders do not include PMD_ORDER for the
+	 * local file case, but we can't differentiate whether this occurred or
+	 * if the collapse was rightly rejected.
 	 */
 	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
 
-- 
2.43.0


