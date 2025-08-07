Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC3EC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 321F58E0005; Thu,  7 Aug 2025 13:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9DA8E0001; Thu,  7 Aug 2025 13:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0EF8E0005; Thu,  7 Aug 2025 13:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE718E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:02:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8E4D140934
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:02:43 +0000 (UTC)
X-FDA: 83750580606.03.AA42C83
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id ADF291C001F
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:02:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=phZL2UTK;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.96.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754586160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpGoIJs7rUC9IK7WzjGH7rQqrnD8R92iJ7efBvY9rZU=;
	b=4FYOH7T2QigzV8+UQZvvwe87kipH6mcPq8gmAmCKG1/hNN2D8B47Xi1Dx9g4mI2TVI9X1p
	xIZL9xLfYzZ7Tce5Xh9mQxBTOe/dXoRk9C220w7GdbuBZ32PgiDJdLnrIHmO08zUXAmdu1
	LO4wtt8oo7HCIVSdhNyGYYGFL4UQ0Vg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754586160; a=rsa-sha256;
	cv=pass;
	b=0XeveHO2pmM2KI3ETCaH89qSsSsjlAnYR7FFL7m9yHrTXEoLHPVZN+8Sr40R6XkmmbsMpf
	ryomnIBhUOEU+YWlel4uRuqsNcXRjeYwBzR5pDk+JayzWBR5wKczOoe0IliJZNzn34nSlC
	ke+dxWw78/DWp8rTI+diGa7Dp+xVjjA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=phZL2UTK;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.96.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J7iHmULboGQ3CIZJlnaiSfg66iLvdfmPBU3dR5Y5u+7HGgT4labQbvoHXqNJKInsp4M3Qbqff39id8ROSnlLu0bsUC+gFBgEZwAOwbg9y2V/V8EP27Wvq0IFuzQvRDThMr8Cd6bT1L9JAGhPiY8Zltmxq5CE6+iUIhM7vKxD+qInxJvCgeH8SsNcY3TR7bGa2F0hftDj6aPTNkSZBporUz/YO+8wJkaip9bYFVQssLz0Vhpz/Qfinp7jd3GOYhNfATe+4UpHSDKyX+ywtMweBaVcvPlta59ir1jzdLW9UAbX3Q/I1dI+OvE4yC6rlnEZlQkrnots9LbpqHO0z8VfCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UpGoIJs7rUC9IK7WzjGH7rQqrnD8R92iJ7efBvY9rZU=;
 b=pFuUXx2Rf+v5rXAn9c0vXTt2gXTiTU9rJRxmhWRq+rXtekE4BMDBIwWAA0aHUJqqm1w1QA5XF/67Nx9LDX04y0Dcu1rpY9K/4nIngEwVYwg3vgklfxMFpnIrMXat8Hs4u8Hfb73/OqhPfP0/YCSMZC2DUfwNWutffUASEPkVudn/FpKiF85Eb+qo1KwyWZbZdOgb4D5RxD+pLBP+NEDEzZ5mZ0YGCfiiju4+zeus6lcHtTEoUKPEnGJ3/kZ2Yhv7HOltMi1no0aRhEFkrLvqdZePEQrZlGLXuQDTamSLou/vnuY4Y/+zI7he/aLi/+PuP9dTRh1qNnDDdiEOcLusqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpGoIJs7rUC9IK7WzjGH7rQqrnD8R92iJ7efBvY9rZU=;
 b=phZL2UTK0NKLI79J5nIM2o5UrbHUI3HXcWB8KSnNpPzSIc/lfxDEG96R99mmljA7/HTSGfAd5fnD6Ba+ct6r8MszGb8MJxHNXop3aKl3a52SmUJ3ksGfzOFFeITnYWX/e7FUqqXXhQerA/T8vXqaNNPP0sq4RHqnaNWElLostutxzqbv/9juyJG9JG+DSKPcIBYFCu1nGcRUXD/1kw00bqF08Mt5V8yjdwt75pG71w1Ru6eiVj13ysLwBg8072DNEJTgkNFybeSzlaODLUwo96aWl7AFcheykO+q8Ayp/9mTFzL5HHYHwx+279PkqmD2PgAswBTGmCktNnquFFhWUQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL4PR12MB9482.namprd12.prod.outlook.com (2603:10b6:208:58d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.17; Thu, 7 Aug
 2025 17:02:34 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 17:02:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 3/4] selftests/mm: add check_folio_orders() helper.
Date: Thu, 07 Aug 2025 13:02:31 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <898EC7C6-8AFE-4CED-AED7-C59C5CC03EB6@nvidia.com>
In-Reply-To: <dd2118cd-9209-43d5-9c73-8e3989931841@linux.alibaba.com>
References: <20250806022045.342824-1-ziy@nvidia.com>
 <20250806022045.342824-4-ziy@nvidia.com>
 <dd2118cd-9209-43d5-9c73-8e3989931841@linux.alibaba.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL4PR12MB9482:EE_
X-MS-Office365-Filtering-Correlation-Id: c752f727-d047-4abc-ec05-08ddd5d433e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bcct5+RmU7/Xd9UqaCtOnnLTIwbeofMv948H+OR48fpsgBArq57oziz6tGR+?=
 =?us-ascii?Q?AQzGTVGf/l4J/UlKCSD/HTECfyD0IsmCkMdYO/E9y0j3AdC12+5OrwJpi3U9?=
 =?us-ascii?Q?MMSyf+uxmpPQJ3fPtvyd0xXbF4n0qARDvcVv2vHslKc3U/9OeTuoe3f/fXWU?=
 =?us-ascii?Q?AUt961s2cO9ahf3w4s2aKUY2EZ56b6BR5xvu61Vzufp2jYyMH8b7IGSZUBqo?=
 =?us-ascii?Q?Z1frJqwcicFluWHT4md9UwbDvKCCrjcigevQjdBuyGijkBzKBQrHCK0075WK?=
 =?us-ascii?Q?M2ofyw+dAi2e4wDPHjZkzDZW7P3C3R0qqjTaDN8XNGVa7xzMAh2XJ9aRmc8U?=
 =?us-ascii?Q?cZGyFW/K+ZUmEFdQ9zm+CKhROlgUZrZUC/1h3ap4jEOfDfrJ85Iuq2AQww3t?=
 =?us-ascii?Q?sILToaWHDgmkhQGpMl4+pmIJ3tI0lstpC8ozZOgjKEydLFQrEJ30fg1Yiv6P?=
 =?us-ascii?Q?fsVQj4ln4x4glw1JhqJvH0983FEEBO5ZbicBN7D8Iv98k8JXpPZ1PF4QlTab?=
 =?us-ascii?Q?gsCf/aP30438vLg6I9QXxy0RqbO+ztuJ8UZ8pLS7tJrQ3objkC83Sx0W0LWv?=
 =?us-ascii?Q?Nz9W5QMP0r63hKvgXEJ2Sb1EkjW/CIBxV/jU1rZX3yh1BXSBqtUfZDEml3f/?=
 =?us-ascii?Q?RAaRm5uQuaqUsjsbmI32W/AI1PuaYbk7q/120joEFXn40+4SCkoAEyNejGrb?=
 =?us-ascii?Q?YbzSondIOU8fbQo0/BsWSFcELIOSV5T4sHue29KcgRXViNzAKnGf6mpvOzSG?=
 =?us-ascii?Q?TtKMXg3kp8rcrIVtOulu0fKL6o+TPmMk0US4UfRzJB9YPz6VdLlDKT2IR97g?=
 =?us-ascii?Q?DqzmMtI9y2HfCKE48wv7G2ZK8JR2X+iLe3Q+Ga9itRqAhYhs4UqkSlZj/Lp1?=
 =?us-ascii?Q?rjz/jI2KNCYy7u9kSGVlYjXDA7fQY8vwApuYozWKMazXTjq4W9boy46rameW?=
 =?us-ascii?Q?uiVZYX01QD1iOAV9MJBiWy26x3oquoOtfn903H+UabLUlTHN6Q41RnQNog45?=
 =?us-ascii?Q?AYLI1IEc0oZDBmDK2e6m65XKyxzrRBFFEp6Y+QC613Td8oa2sody3hem/9Cy?=
 =?us-ascii?Q?nDlTKXT0xHP3Ryz9PO8UMoWgUjW8E5rQJQbZnWGUT9+A8LAfTGlukzjXYLfH?=
 =?us-ascii?Q?zP9Dn45zR7NzZdD1nQRAhODILhvXEpQobBufZaS/lJcqUBEs/ZcUr7KbKJlR?=
 =?us-ascii?Q?P1LTs1xq+t1Rb1B/UmMI2n6bJVzX7vMpntsMbT6MN+GMTpI/Az1kYlPmoBQ8?=
 =?us-ascii?Q?2HTDRX0U8VeDGFMnSvJmSlK9rs/xFLauD/gKtqyHyVFpznoqyL+UBlxXkQsD?=
 =?us-ascii?Q?1f1DGW1to/3tq1JIWAlh3zEJcQGuFpJ8D0ATYvLR8vc/eDrIRpRNUHrpfc2d?=
 =?us-ascii?Q?qJEpZmedtv88hIu1b7cIxFK8LoCYKu4p/TrdS+3qMJcIk9ykQapjsL+XQYTw?=
 =?us-ascii?Q?CdmIugwcSYk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pqf8UqoUUoJCCOEwuiJ0GaZhuOlgXhyhTZxmIsITfWi+54m8NWNlFOJvGorR?=
 =?us-ascii?Q?u7YUWfyj9GniS9RSEioUhcOWk0tz9OlTakcC0O5osmHt2pCEeRlJ1v9UhUNJ?=
 =?us-ascii?Q?TsC4EZctu/okFzxMKx8J9X3gGBdInGxQwR3FO2Qfls5+Xc7RJJHK5VPjzJNO?=
 =?us-ascii?Q?U16oDFFIEZ5VD22F8g12V9/TRlKJk8g6jOPX41BPWVrKVnFQnGlYQHXhMLoA?=
 =?us-ascii?Q?fpYZzq7Eyp2VQF+aslAgRjzMoNl8FFGRc2AVOspUUlFwhrD5E4E35j2yqCzf?=
 =?us-ascii?Q?DXBWVN2wCQ/dPKkvCqtceCEz8zk+SO835jpmHUl3b71LUNr6k732sw8SrAEK?=
 =?us-ascii?Q?eULDeXtrVociNMYcCMnDYVs5SLUX5EZ1wPrMnSO5rYm1Od7sRPFy/4xp16Cg?=
 =?us-ascii?Q?uzwoaCg+TL+bNn1DiJt9CwCjmcFe8JIXiHGieLOr7rHtkNcV8bpPHVrDHEFt?=
 =?us-ascii?Q?Ri2RhphoruL9dUzzc+Z2CEhah+FSKHKA0vO/lqAXuujEKAn+Wo04rA6NrQQH?=
 =?us-ascii?Q?CD8GwoBbdGEh0942XgX0vcAvgfXUrxOKrQhjBImASkgel2NWT3WqgBawrwAq?=
 =?us-ascii?Q?12yqF4Nau6/vF5HGSptIwo6u8Do/PUXFFuUPx8nBo3TvVVkWuT/zIiYwcdqX?=
 =?us-ascii?Q?ANOFKthaF3hUuOYrKl/FtD68pIZNhJkkmV832MmM6tOt5tkjsAyo3Xiw9OcB?=
 =?us-ascii?Q?hFPwxmkwwp+vwBlWUm/ZZoSwuBL8tfiMqyAiPCIYknQIhUANowd50EmQA4+r?=
 =?us-ascii?Q?ikB9NDvbrttEFqOgtZUQqHqJlhk3Eh5acNkzS0fjR/t+QjYaqtUMfefnbGj2?=
 =?us-ascii?Q?1GFJl2pURQlIIoObXKSr8N4v/6sB2j4u+Ed9OEUOYY2/kl+bXt/JGKM9F4SO?=
 =?us-ascii?Q?janmLkhbGuBJ4CyQjrHd52/AN5IXsi2HtG6XnAMPMbiwZD+25LyIJ0gBFUsg?=
 =?us-ascii?Q?mUogA8l/+11VGIov8Excf+k38i6T0dLPLjyksIw2cMLFn/Ixa0sUL8PkyiZ8?=
 =?us-ascii?Q?M9vfujTzFDnkfos8n6uaoK7chMrJcv4c0oeyfeD1TkOF75vnAOnDOEK9jloT?=
 =?us-ascii?Q?etVcrFCfNak1NoDUMzyowO3nCRW07cit4VXkZgMVu2Hj8sboTK9VRovHRdfL?=
 =?us-ascii?Q?BdIcZ61b9UP2AVseFJzRI8IPDtvxzuLZrnRwLA0I4PkK5Qo1W22ykIx6RNqZ?=
 =?us-ascii?Q?t7T+3x2J4YRAxES8Asj72xnGLShECrAmwkd2J5fe+n6qTRDHAvmkA+Jahi07?=
 =?us-ascii?Q?LR8nFP6gR+k5k/nSw38ldS6ud0kztrMKu4S/I3ZoQc1TpH7IK2C3j2eHHnz5?=
 =?us-ascii?Q?4+xwYklFR7xHP1OFaf9b/BXXB0PxVakwUM9DPECoF4nF6uZ+UXmvagF5mn8x?=
 =?us-ascii?Q?QbiASE+t49yxEfbKvreS1gxOaszZ+jikdjTh0tnYp6DXfkNRWHcRnnD9kyWd?=
 =?us-ascii?Q?2nW6WE9SZ8srx3RYwNsUvoLTpWAI3LEu+lDiZMPbWA6ARF29e9AEQ2CRI+sb?=
 =?us-ascii?Q?ZOGCDwVeHUGPV+bAU1NVB0gKCSse4d/Mqob6W2wkBJEri5xjjlWvfjW5H2aZ?=
 =?us-ascii?Q?hvKSdmHNX8gKsXIaV02dv7zI4QjzfHTvDnCdUZhH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c752f727-d047-4abc-ec05-08ddd5d433e5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 17:02:33.8069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mB08rKstu1ecP8uOyH4IbW2bEqOas2dVWr5PI0RuVdSshmj8GA5bN3D7j9uTwKxg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9482
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ADF291C001F
X-Stat-Signature: kzo7dyqptp5u6t3mw1mhf57k1cwici1q
X-Rspam-User: 
X-HE-Tag: 1754586160-230323
X-HE-Meta: U2FsdGVkX1/xz96J4iOS8Lj9MV2/9EyTggrpcmud8umI7EuPaR9HiJ23tSUIAhCSLx5NU+ABUsR89zpy84G9hemCCgd6rfUzT8DCy0HfEGMc7ufhQoLK5mp5+KXnfmN3br9iLuVo0HAAFcbqGmN1hMv7SlicYDZA1ov4uawNMfNvcQ5A/XpR+drMXcEXHl16ngA3/joQnhw+mgc0P90SQaIo7TivAhsyGcEjcRzOt5Lx6dJo/jH7ah44jbv2Dfl1ZlLcA9KpUsuaU1jc/WXRyZW0eoHIfBrc7qAH6CSEQDhcaKKr7yjSQeZSSNwrmsoAGfPwlXpLeeS2TKjLsJ30HR5Hg/UUKnqrqG1rNexbnVYWP8yAsQbJCbBoEQA8N9HBRGbqswPCtF1/LDeH0pe9f17cfX7iCYrWwF3rQdNos/lMGDaqnzGlOQ+UJGfPjP90lp+VrRKCtSradRUUI7lL60IMve77G6pV8IvHgfH7/cLAoYXikNwtklWs0AqStmnV5Je7yMqF69CzXhP3jTPkmVeLiIgLe3cVBYFM6wtKgP9dzMXHObhMrrlQk4Z98S/jkf5SwUjT4HXOygmOukTAVzgZn+vN/sPZEB4oGNqBst/2iZn0Vi9GCkmadr2pmaf8A+oidL6Wf5LPV36Ah967YGxo3H6sPjtxE0N/adzZC/DE9+5i9DPEpmbJJASgonRyWfU4JhCFavH7sktMQEV+zHp/kW6bM7F2i0/egllnaB41UAGvIOlqfssWo49Jn2Vyw0O9noaaByg2hhS5KDH7OVFFCiZ1lsIuaNZvBNb912TQtvGtrecqYXgMtdifyS5bvWCYMBb/atvPcRFNcjkT4FgNLJ930A1ZafN833c6/4HfcPcl11A78MmR//f1fR/UKGH9/Hoi4/fLXiBREePVL07NRjKbuH85rd/HGS/sZA+PYLbpoTQCZTPefGMCQg4SDOqqbA5Axde9/7EHULQ
 5m08toQH
 BS9Xdit1K+rfxVoet8bNtaO+YPX2SUyCYpF9JeQJ/gp7MK60Xh1o10lDc96CtxyP9q0A68SO+Vzf6pQ61W58FOACer3XnMADFNxDv1uXZ8ytzsa4dwn9z2465Li09kxuaTHzNe34tLs+PsEIdXMRgZRd2nd4vkV1AqMhvGQ8DN8GPsuI9FCUSGkphHFJ11Pbdi9hqp0X7P8y4FTUfpsMvG0aj00xRSqE4EhZq+QocfeDzXTOLo1RSmnKb4S5zGxCtSUOgiCkufhSuiyxEGNT67jDIuDbLm0yVCOnOM4I/lyeAPrLnF+ZBVs1n3ieW9JZRma5uKFgvF3PfHyxqn7js/6pcdkZviB0sLYUH1LxUGJIdx+1QMD9Zhpt5VkSYPZS80k9W1+hMfGwGC29kVgzrqr2OfE61a0sveIPFqNgKzMWG2yetto2J4k12JyXMlm53m7Rvox/rMbrH7XSFq4U0+XJmAba0uzhPw1sy5MzWCAXqTat/ojiVq6XQ/+lA4HBLSB+UIKdsAaCmykRMwjL9xdfhww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Aug 2025, at 2:49, Baolin Wang wrote:

> On 2025/8/6 10:20, Zi Yan wrote:
>> The helper gathers an folio order statistics of folios within a virtua=
l
>> address range and checks it against a given order list. It aims to pro=
vide
>> a more precise folio order check instead of just checking the existenc=
e of
>> PMD folios.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   tools/testing/selftests/mm/vm_util.c | 139 +++++++++++++++++++++++++=
++
>>   tools/testing/selftests/mm/vm_util.h |   2 +
>>   2 files changed, 141 insertions(+)
>>
>> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/self=
tests/mm/vm_util.c
>> index 9dafa7669ef9..373621145b2a 100644
>> --- a/tools/testing/selftests/mm/vm_util.c
>> +++ b/tools/testing/selftests/mm/vm_util.c
>> @@ -17,6 +17,12 @@
>>   #define STATUS_FILE_PATH "/proc/self/status"
>>   #define MAX_LINE_LENGTH 500
>>  +#define PGMAP_PRESENT		(1UL << 63)
>> +#define KPF_COMPOUND_HEAD	(1UL << 15)
>> +#define KPF_COMPOUND_TAIL	(1UL << 16)
>> +#define KPF_THP			(1UL << 22)
>> +#define PFN_MASK     ((1UL<<55)-1)
>> +
>>   unsigned int __page_size;
>>   unsigned int __page_shift;
>>  @@ -338,6 +344,139 @@ int detect_hugetlb_page_sizes(size_t sizes[], i=
nt max)
>>   	return count;
>>   }
>>  +static int get_page_flags(uint64_t vpn, int pagemap_file, int kpagef=
lags_file,
>> +			  uint64_t *flags)
>> +{
>> +	uint64_t pfn;
>> +	size_t count;
>> +
>> +	count =3D pread(pagemap_file, &pfn, sizeof(pfn),
>> +		      vpn * sizeof(pfn));
>> +
>> +	if (count !=3D sizeof(pfn))
>> +		return -1;
>> +
>> +	/*
>> +	 * Treat non-present page as a page without any flag, so that
>> +	 * gather_folio_orders() just record the current folio order.
>> +	 */
>> +	if (!(pfn & PGMAP_PRESENT)) {
>> +		*flags =3D 0;
>> +		return 0;
>> +	}
>
> It looks like you can reuse the helper pagemap_get_pfn() in this file?

Sure.

>
>> +
>> +	count =3D pread(kpageflags_file, flags, sizeof(*flags),
>> +		      (pfn & PFN_MASK) * sizeof(*flags));
>> +
>> +	if (count !=3D sizeof(*flags))
>> +		return -1;
>> +
>> +	return 0;
>> +}
>> +
>> +static int gather_folio_orders(uint64_t vpn_start, size_t nr_pages,
>
> In this file, other helper functions use userspace virtual address as p=
arameters, so can we consistently use virtual address for calculations in=
stead of the 'vpn_start'?
>

Sure.

>> +			       int pagemap_file, int kpageflags_file,
>> +			       int orders[], int nr_orders)
>> +{
>> +	uint64_t page_flags =3D 0;
>> +	int cur_order =3D -1;
>> +	uint64_t vpn;
>> +
>> +	if (!pagemap_file || !kpageflags_file)
>> +		return -1;
>> +	if (nr_orders <=3D 0)
>> +		return -1;
>> +
>> +	for (vpn =3D vpn_start; vpn < vpn_start + nr_pages; ) {
>> +		uint64_t next_folio_vpn;
>> +		int status;
>> +
>> +		if (get_page_flags(vpn, pagemap_file, kpageflags_file, &page_flags)=
)
>> +			return -1;
>> +
>> +		/* all order-0 pages with possible false postive (non folio) */
>> +		if (!(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
>> +			orders[0]++;
>> +			vpn++;
>> +			continue;
>> +		}
>> +
>> +		/* skip non thp compound pages */
>> +		if (!(page_flags & KPF_THP)) {
>> +			vpn++;
>> +			continue;
>> +		}
>> +
>> +		/* vpn points to part of a THP at this point */
>> +		if (page_flags & KPF_COMPOUND_HEAD)
>> +			cur_order =3D 1;
>> +		else {
>> +			/* not a head nor a tail in a THP? */
>> +			if (!(page_flags & KPF_COMPOUND_TAIL))
>> +				return -1;
>> +			continue;
>> +		}
>> +
>> +		next_folio_vpn =3D vpn + (1 << cur_order);
>> +
>> +		if (next_folio_vpn >=3D vpn_start + nr_pages)
>> +			break;
>> +
>> +		while (!(status =3D get_page_flags(next_folio_vpn, pagemap_file,
>> +						 kpageflags_file,
>> +						 &page_flags))) {
>> +			/* next compound head page or order-0 page */
>> +			if ((page_flags & KPF_COMPOUND_HEAD) ||
>> +			    !(page_flags & (KPF_COMPOUND_HEAD |
>> +			      KPF_COMPOUND_TAIL))) {
>> +				if (cur_order < nr_orders) {
>> +					orders[cur_order]++;
>> +					cur_order =3D -1;
>> +					vpn =3D next_folio_vpn;
>> +				}
>> +				break;
>> +			}
>> +
>> +			/* not a head nor a tail in a THP? */
>> +			if (!(page_flags & KPF_COMPOUND_TAIL))
>> +				return -1;
>> +
>> +			cur_order++;
>> +			next_folio_vpn =3D vpn + (1 << cur_order);
>> +		}
>> +
>> +		if (status)
>> +			return status;
>> +	}
>> +	if (cur_order > 0 && cur_order < nr_orders)
>> +		orders[cur_order]++;
>> +	return 0;
>> +}
>> +
>> +int check_folio_orders(uint64_t vpn_start, size_t nr_pages, int pagem=
ap_file,
>> +			int kpageflags_file, int orders[], int nr_orders)
>> +{
>> +	int vpn_orders[nr_orders];
>
> IIRC, we should avoid using VLA (variable length arrays)?

OK. I can change it to malloc.

Thanks.

>
>> +	int status;
>> +	int i;
>> +
>> +	memset(vpn_orders, 0, sizeof(int) * nr_orders);
>> +	status =3D gather_folio_orders(vpn_start, nr_pages, pagemap_file,
>> +				     kpageflags_file, vpn_orders, nr_orders);
>> +	if (status)
>> +		return status;
>> +
>> +	status =3D 0;
>> +	for (i =3D 0; i < nr_orders; i++)
>> +		if (vpn_orders[i] !=3D orders[i]) {
>> +			ksft_print_msg("order %d: expected: %d got %d\n", i,
>> +				       orders[i], vpn_orders[i]);
>> +			status =3D -1;
>> +		}
>> +
>> +	return status;
>> +}
>> +
>>   /* If `ioctls' non-NULL, the allowed ioctls will be returned into th=
e var */
>>   int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
>>   			      bool miss, bool wp, bool minor, uint64_t *ioctls)
>> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/self=
tests/mm/vm_util.h
>> index b55d1809debc..dee9504a6129 100644
>> --- a/tools/testing/selftests/mm/vm_util.h
>> +++ b/tools/testing/selftests/mm/vm_util.h
>> @@ -85,6 +85,8 @@ bool check_huge_shmem(void *addr, int nr_hpages, uin=
t64_t hpage_size);
>>   int64_t allocate_transhuge(void *ptr, int pagemap_fd);
>>   unsigned long default_huge_page_size(void);
>>   int detect_hugetlb_page_sizes(size_t sizes[], int max);
>> +int check_folio_orders(uint64_t vpn_start, size_t nr_pages, int pagem=
ap_file,
>> +			int kpageflags_file, int orders[], int nr_orders);
>>    int uffd_register(int uffd, void *addr, uint64_t len,
>>   		  bool miss, bool wp, bool minor);


--
Best Regards,
Yan, Zi

