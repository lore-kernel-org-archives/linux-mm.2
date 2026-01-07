Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A6C2D0D162
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 18:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF2AE6B0092; Wed,  7 Jan 2026 13:26:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9C26B0093; Wed,  7 Jan 2026 13:26:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3546B0095; Wed,  7 Jan 2026 13:26:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 844FA6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:26:35 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3873B1A049D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:26:35 +0000 (UTC)
X-FDA: 84305998350.25.25C8C93
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010051.outbound.protection.outlook.com [52.101.201.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5578320004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:26:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uMaOJXIQ;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767810392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfJ/R5/4ZANRIt7eV5hQWb9pY70GRRzdh/1PVqqEpOE=;
	b=wfvvTxRBQwPDLCExwNM8xwPEdjToaU3GzsCefzsz7kXrM0QQn38Q3qcNJOf59tsqE33xZE
	GaVDV6F/T25y91NkwkXsCE5U0Lpy10cq7jOimYEHOfzQWtmN8Tev2LYGQh0rGHAn/sxQbV
	FiRW6NwevZs/NKS8nDdVPqE/GNHrbzQ=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uMaOJXIQ;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767810392; a=rsa-sha256;
	cv=pass;
	b=xAs0TYeubVvcGRoaa6fAzwEVajG0DW76u0eILeogj3SkTGygiyhdkg2W8KELSmfBE3iBaL
	iHF5zqsTcJ8pAjZPmqa1g+v0DeGlD81y+W5y7eoUGDIWgRuMcuWjaPbikYYYLnDmb/etpp
	zp0AlFeiv+1l1xqzz6cn2z9fzr7RqZE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ut0g1Y//fdFTu2ky/Mo10eh6LKoxdBoNCj48nnT4eJw04PBFwFVvABJQRmtoYGV2WAEyRd1h8ATnOPVx8oQk0QS6MPwFoFZavwIHtD1yzADnpOGORtDnJS4eMORH2uH9i7XxZhLr9xJFenhFPnUU8FmYs+Ofxk48IGVVLNlYqjXl6OUM9w3c3FV8vMAg/0HfpVOga651yTC+FHtVzDsNCPLSRuwGJyiekQaJyoLEA505dcmRS685b2qGFxB3evX33FlrjvPxOrtghpc0Cl5bCgwDa8mSMTbDEU1EbWBinvprSQwLaiHnW/wRPNTAeZ5G7wN7Umcjce2lRiYMLo6qvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vfJ/R5/4ZANRIt7eV5hQWb9pY70GRRzdh/1PVqqEpOE=;
 b=myu7b830jKItE9+Pjd3hFUcCRGAiiLVQ5mFu1KSsOGNjnPl0+zDiLv54JGej2U44SDWKDm1CEkCD0wRsFD5YxbpWMz5g1HjSvhtFA4WDBZsncrvA6+lVoJtVzzPbYQ1JiLTCaFT+t0kP0fwEv0MxUwW2jqguWR2YUy+w6lPj6uqMft8npYe62JHGuguCHyw+xMAgfDVAwTE/hcaRWhQuyCgYieWJwP8cq3qSnzsE98NROzyFJmbc8vuuPBNS8ZiNjRdOWgN8xqehZgm4dBWxKNAPn7POT8Q8gYmHSPNawBkDg4TJeoHDn+sXrO9xBLL+ew/2he/C/9mpJ+6GTKjeBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfJ/R5/4ZANRIt7eV5hQWb9pY70GRRzdh/1PVqqEpOE=;
 b=uMaOJXIQ6DKg9XXCV2Q6+sx0WiO5J55XGvnerLkWMG8od6+M1Fz2uT9INwvRv5k98wZjIHidBo+BcM71zu6ryQKAQOibP5NfgWP9PXA4TH/tIlsBUZo7e6yTgP5VWu942Au1ariRGJp9Bydc+OH147AZzSd1C2/7dfnGCGfMCeID9uqtLZH8iNo5v2baekwBwHGKVDjGi0VFQ5g9qp5Js1TMvvWnSLZdiJI6LehDcktEln4LIvjgPNDG50HhZrgd6cbgRysiG6OxBwYN9BT5qraavKHdIsdjWSYbdYe41A8XWxgOTSmsCb8yIs9DDnZ4sn8cCM1j9vci7Xd19bzgbg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6929.namprd12.prod.outlook.com (2603:10b6:806:263::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 18:26:27 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 18:26:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic folio
Date: Wed, 07 Jan 2026 13:26:22 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <2969136D-0D76-4055-B0E4-992252C000C9@nvidia.com>
In-Reply-To: <4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0270.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6929:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d0b246e-de39-4f2b-2b02-08de4e1a4531
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IaJuYUpuI8wa+fUE+6jbJcFVgI/GJvR/552lxugZR0Pjq4SCGlW4i7ceyXAk?=
 =?us-ascii?Q?a65RNsS9BqR0g3wP8EA/YhryJzeXUGCpFNBCGD4+bwDM+f9SAStechM3o9OO?=
 =?us-ascii?Q?HtV20NsGlZFqhPBE4HvWjduxBd9YY12fN0Kjak9RYiD27ImYGp1XfURO5CEL?=
 =?us-ascii?Q?M6wuIMYJI6+UN6Q763rXmT0OTsd/gI8P5jNrbZExmh6FIJjfdznFHe7FrAil?=
 =?us-ascii?Q?LCrpKIG55zZ6LVbYVzLKNjwBe6eBGpn3pROn6TFPyrL19oK/J8XOc1YZwECF?=
 =?us-ascii?Q?OqVsPPLF6ZuGOlRgBSCiutw4fHuchYGRNzc7YlfzfNQte4aEwy2lntoiHYUj?=
 =?us-ascii?Q?GyqTOPFwVk6N6Jwp5JD9AjWpXAMcqHjLO1ZPdPJvqdrToY90MWSNHKgsNVIY?=
 =?us-ascii?Q?FSpj28FRPg7nqXJEiEst2OgPC4aGhFPEl6Ljrcwh0p9dbkeU6aG/w970Jm3M?=
 =?us-ascii?Q?yWgRhD7D/8Doyh3S6ssoUO/nDgJyBcIeFSa+Q/aeKxhhpM4UjsdPxTmMderZ?=
 =?us-ascii?Q?sY2Pm3xajVEYnaOMcyRlEquStw1D5roD0C5BbkUhCYjprvLJ+/BdNKKQDvDp?=
 =?us-ascii?Q?9vqTpy4FoTh5fxA94vFwZWkqILIK9BAGsU2RVp+GqfJjMnh4oIaxkHD52za+?=
 =?us-ascii?Q?DVzfINTTmw/E+c04yWo0DgK4YIg24su5PinviePNw3dgFt9jGVmvOCsdrw/i?=
 =?us-ascii?Q?yA+syk7awR10z+HqP1CSk36+4hVm5VmQboQ3ybbzRraBfjfvrRliI8w6TC2+?=
 =?us-ascii?Q?MwGuaEuC2+DVEiMhIbvLblx6kTuLgnX24e7Ari+nqTvbX75dVwewe0ylAEk2?=
 =?us-ascii?Q?iB+Ad8WH5D/yL52uGnRGFcnWfI7GkLtj2NM3MKTRPOgqlA7dmQkJMMwWvzB5?=
 =?us-ascii?Q?1vod6CslYlm5JWGvYQLmGXRJf1RLljxuu5kOqHl3sra1AKIa3i9JybvZeQah?=
 =?us-ascii?Q?GzHdX5gizyD7JZX6oVltTO4TCGXvJZj4TYYQbrdU0znsc71xCFpcSt+/MaLn?=
 =?us-ascii?Q?w5SZFGOUNyVvgBtN8eAJRx/DuCJZlzAn5wysDc5hS6s1PzO2EfjkBVhKvXW9?=
 =?us-ascii?Q?SYqDNrcprv3H4t5XP7UBNVwxnW8M3YT1UkE3mdmFPEwxDXAJ2/or7xuYPsfW?=
 =?us-ascii?Q?kOIou4dbpD1pN32yeNpinlPoBxuBYylE4LlXByQTZTnMlYcCsp64D0bJIJBB?=
 =?us-ascii?Q?wW0vKl3bIRDt4mm8Cv+4+v+p9+wPhGddPL1NmfHdGDiW3Zjn5iwlRyKdUGQV?=
 =?us-ascii?Q?vHjUHYtnIxLoJzbXBRNUqpiCqhBN3FuhRPRs/cJ+2YvqsD2DYT1Nsyfy2337?=
 =?us-ascii?Q?oA8iAdFf+iMlOrnFkGWzn82ECDJTlH6Q+HGNHBsQ9h9nq6SNa778PQqLITR9?=
 =?us-ascii?Q?aqepdiOXN0oCcPZRmHubz2hRRMGmWQd0tfANG9krQDmypTOPn2XYhevSNf6s?=
 =?us-ascii?Q?O5ZEUIXHpaqjWnniFL1t+JVkdjFICUsA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EgftB03eeqwi8qYoRgkkEx7DTSFVDPg58ipfMR3oBT/hdLfi9w4uPVQPy7cB?=
 =?us-ascii?Q?h5lC3Z8kJ/ZWFztpywZShpZrjS8oD91lO8RlU7cU+V0InmYtfEjVkcELLTiT?=
 =?us-ascii?Q?TNB05dA7R+MsNuFRM0IZaNPPo3mn+WEvJCbkqqa0+icdBN/hjk49/3GTsGch?=
 =?us-ascii?Q?3i0vpHaERbPDt6TEw87y+qLMFRx8KCiBzf/PRcDKeVghoobu5xmaX+HVehyv?=
 =?us-ascii?Q?KGFLKiNJtUWM3TAstUsrVVdNlO0TAq/D9K9Q+bALivicUn6m6iozQgwMylIY?=
 =?us-ascii?Q?NH729Wqi4bbRwCjS8vqhGu678KIcNmaXLWu2H4wGRMe2RcQa31/pdRV8ISRT?=
 =?us-ascii?Q?YjWKTOCW/RraQUJZJ2BxB3i5HO0ucIr59JRBiydt88x9G7WY/XNlbr8+NG7r?=
 =?us-ascii?Q?HpxQ315Z1JytBue9m6HYqFl7wJajVQCxDfszQUgwaa7kkw8lZ9aLn/DEQs9s?=
 =?us-ascii?Q?Bcdi9a39pQHnNyeRq84tF0OyQJHyWp02PpBsdTw0668lJVTMeLjYh9+nLe8b?=
 =?us-ascii?Q?6XESIN9dzes+ESo1z0yd+A8paT4Xpsyyb5m9bu2ffBXWsBV5vruzdLoxaaLq?=
 =?us-ascii?Q?slwUq12jXDhlXClBzZtWotiSu7xTygHfgP7R+PVWYpcvig8SSTwyAlThdeNB?=
 =?us-ascii?Q?YXBNzSbPpUM1rDA9QLETjwOCAduvfcR5Vt8GXgW08O2HxmvRZz+IeNqZT4BQ?=
 =?us-ascii?Q?w21doz9Nk4D8tOKxrJnkbz/taTcGoXX2bVw/5V6htyG+1KBkE04BvJanxY4J?=
 =?us-ascii?Q?MorYt/CzZVmh9/tC6oHcLr4t10hVbxuFkjUpT17AKEBLAmByOq+5ykRBfiEw?=
 =?us-ascii?Q?UUOHGfzbB0iRRUGoUNU6Rcn7ToOr8xF1JGa97s8n7oD611DhTZIpg2szdn07?=
 =?us-ascii?Q?6jZya2eS383+ImUW1oUdUF6EjV9YeWcGozVzROEZ3pIGubCl5q9VSwUDWnTp?=
 =?us-ascii?Q?pJGXUoVLbRBYv3j4bOd0BaRmh1/AIwbnv4kZ7ZrLip/J/O3HLy5Dyg8AH4l8?=
 =?us-ascii?Q?sEDYd+xkh8Tez1la4RADLZ8t4xx6ZY0Hgdi2uPn7edE08R0sKq4MxRmpQaMM?=
 =?us-ascii?Q?5Tbbs+AFF+a3tQ0L8c0DfXJsyYkXJwqyVETck8y0tpp5H+5WiYSRF6KDLxhy?=
 =?us-ascii?Q?aY7Jis8+sM4Jps9vUnH3qCZKR5f3HBY51kWAwV2Vwo842ckAaeqsaRstNLvf?=
 =?us-ascii?Q?GjhD0Jqb7tK5Wn4rQfD48y1r02+DG88/BIQ6Msv18FoDNOG6HpBL7zYPwRQE?=
 =?us-ascii?Q?anPVhH4VwGvpP+oH4d+Pg2pnuaE2h6VxFj5uOSzspCiNuH6ZUsmaRYKfuF8j?=
 =?us-ascii?Q?fClpTo06paK88edbbcLPtQyD8kAt7e9azrsTlLFpcAWbuOPLqUOjjiRkFtBJ?=
 =?us-ascii?Q?H2SYngd1r99roIznZlLUXzzv5ooJfQ/hpwk2O/C7Zx+PJ5k/5X3mHdYtSOvi?=
 =?us-ascii?Q?hQ4hu4EmzyfbvzDHH+vLFIIttznu+WGvlmnklsyZpMF1gt2RLZG6CGF7KENh?=
 =?us-ascii?Q?ovvT351slb7hT2RWbUuoVl03ltrxH8heO5PpePBlLUkm+Qr9b8tVuMloEXgH?=
 =?us-ascii?Q?qrWB/biIbW5utNKvArfq6khzeDPfvijCHoaQG3bA4KYDCSOqGbmn51/VYRR/?=
 =?us-ascii?Q?jv0SFj/vyqTsm7ahprod9gfEixivOAVcsPxHEwzllylJFrquEFehaUm3fZhb?=
 =?us-ascii?Q?Cs8WV3MO7ZBlyUxOKqYkGCWxb0BGdyG3Jercy4zNqdtj9srowYcBJBhh2Ypd?=
 =?us-ascii?Q?BuU02o6FxQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d0b246e-de39-4f2b-2b02-08de4e1a4531
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 18:26:27.2090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l8mEFyvBvy4gDLmqQHwWjJfx4fZhhvbrbr3UEQgzbcsZlLc46oKBR4+MW30D5QaK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6929
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5578320004
X-Stat-Signature: 7ztgyzzqarmqocn3ad1165xx4jztyzpx
X-HE-Tag: 1767810392-102906
X-HE-Meta: U2FsdGVkX1+9CBhmVTOaed7QIUHEfsn9C68Ab+r1Kuaup8hpw47xk04D55XjYKWBHOW++j75RYa85+uCbLT23AiNy/aARfHcxRRw90OvWje9wuXuDK6FuII7TCKPVjVFPyzDN+2+lCIlkH+xF4cHxv9mRAppkRYaE5dUKj7E3eYk9F161BeGwYBp2Dtnhiuq+07TPyoyFDaDpnyKZwtc9j7b0sPjzrrZA/v6GM7a2m9XoAaOsTqXYBbkoqJAYkUhbpwCKFjrU87x2UMwmD2TMXEHkExCNWq27joj2lsfgi1OwEtC3gENXCsBZB4nK4dOMKFen9567gyRlmZEkGM4beYelPwwtNblqp5L6LRWrF/oG9xt6gislTzUvK6xeGpGNRXU/bGSy1adpFJB953Gm9EWQkf1aevMwdfVPZzElHDtrSUH+c4KP+SCfc7Sb7RWPGWtaOBF71mauvPRrqz0aulewuG5bXWlv0IUrMilsUMPmaulQ0RjtsBGTbR70i051beaWeCh/OepRFQl1ojayoA46SfnrLm2hVdeuONfh+9uhDawqzeYEqjHrnpSsJ8uW92W4dwW6u8hIAGvcgCDTKK19UMu2C28ZjuEtdptHnV4/kEki6XKfCwnn43sxfTXyeEiPpDbfWHJ/xMNzE84gp+c89QPMCbkNmNTwJWVTgKILkRk3zotmpFBXsZAVugVMzkhqHoxLJiYFm8Kv9nejKxavIbLMuDkw50jKxFlr6phBoj24Mvv+Hr6fcvBSJWEfNgQ7YIfImBKYEWqWvG2D8uLPG7ojwGtUrQxA0p+/zomFG5dL9/Ijc2JDkad7Yzt02CNpiHpVpz94hxNavFL1NwTNMtsBATwN4OF2FLP69bikr672Y5SHoyJrny6hQ6mWdblOpG2m6sCMYLLjRjIVUoc5wJ80BYYDcElBLdUx1J51O50eWZam62IeEFk0Dibd+IHGv833ZmWU2p20Vl
 L27G6Xrq
 RGcvFYsj5hJaQobqlyGL3UJ6HdOOjLcbeeMWVnARXbhPsoBLhMDAdZbL6zWlmCDKiom/fdLq9HJP1speAfYp3Va4F/JsQP+9FI4Uq4jNXWMKXYOdzpdxJJygwcsABb5ausC+AJXNG18gchbmLkHJ9CkOyCZAt73OPRC9kQl5VOY/+dThPZuPiZKvydn3eMekAr1ok+pCZ2I3V/A7jcGOvTFNvTtaigYAV8OKbE/xRpmeHIIU1KDjQaeg1dHuuc+2qISx1dZ76Pt2TFXqS9OXgO5TYYQu5y0a1GiQtiiN5MZujnOGUfeftoNmp6YJB0cCrWWKLDxLZTmNNZt/qh6JwBWC0ASY1d2N0dimmjnWkDsm3MWg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Jan 2026, at 12:31, Claudiu Beznea wrote:

> Hi,
>
> On 12/30/25 09:24, Kefeng Wang wrote:
>> Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
>> which avoid atomic operation about page refcount, and then convert to
>> allocate frozen gigantic folio by the new helpers in hugetlb to cleanu=
p
>> the alloc_gigantic_folio().
>
> I'm seeing the following issues on the Renesas RZ/G3S SoC when doing su=
spend to idle:
>
> [  129.539064] Freezing user space processes
> [  129.545037] Freezing user space processes completed (elapsed 0.005 s=
econds)
> [  129.552078] OOM killer disabled.
> [  129.555335] Freezing remaining freezable tasks
> [  129.561405] Freezing remaining freezable tasks completed (elapsed 0.=
001 seconds)
> [  129.636729] Unable to handle kernel paging request at virtual addres=
s dead000000000108

This is LIST_POISON1 + 8, namely at __list_del(), assigning to next->prev=

caused the issue. This means list_del() has been performed on page->pcpli=
st,
since list_del() sets ->next to LIST_POISON1.

> [  129.644674] Mem abort info:
> [  129.647456]   ESR =3D 0x0000000096000044
> [  129.651190]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> [  129.656482]   SET =3D 0, FnV =3D 0
> [  129.659523]   EA =3D 0, S1PTW =3D 0
> [  129.662650]   FSC =3D 0x04: level 0 translation fault
> [  129.667507] Data abort info:
> [  129.670374]   ISV =3D 0, ISS =3D 0x00000044, ISS2 =3D 0x00000000
> [  129.675837]   CM =3D 0, WnR =3D 1, TnD =3D 0, TagAccess =3D 0
> [  129.680867]   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
> [  129.686158] [dead000000000108] address between user and kernel addre=
ss ranges
> [  129.693267] Internal error: Oops: 0000000096000044 [#1]  SMP
> [  129.698905] Modules linked in: nvme nvme_core snd_soc_simple_card sn=
d_soc_simple_card_utils snd_soc_rz_ssi snd_soc_da7213 renesas_usbhs snd_s=
oc_core snd_compress snd_pcm_dmaengine snd_pcm snd_timer snd soundcore rz=
g3s_thermal clk_vbattb rzg2l_adc rtc_renesas_rtca3 industrialio_adc sha25=
6 cfg80211 bluetooth ecdh_generic ecc rfkill fuse drm backlight ipv6
> [  129.730189] CPU: 0 UID: 0 PID: 282 Comm: python3 Not tainted 6.19.0-=
rc4-next-20260107-00002-g608ca48d0994 #1 PREEMPT
> [  129.740765] Hardware name: Renesas SMARC EVK version 2 based on r9a0=
8g045s33 (DT)
> [  129.748223] pstate: a04000c5 (NzCv daIF +PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
> [  129.755160] pc : free_pcppages_bulk+0x12c/0x204
> [  129.759701] lr : free_pcppages_bulk+0x168/0x204
> [  129.764219] sp : ffff80008392b7e0
> [  129.767520] x29: ffff80008392b7e0 x28: ffff00003cff96b0 x27: ffff000=
03fe25700
> [  129.774638] x26: ffff800081e66bd8 x25: 0000000000000001 x24: 0000000=
000000025
> [  129.781755] x23: ffff00003cff9680 x22: ffff00003cff9690 x21: dead000=
000000100
> [  129.788872] x20: 0000000000000001 x19: 0000000000000000 x18: 0000000=
000000020
> [  129.795989] x17: ffff00000f3d0a00 x16: 0000000000000006 x15: 000000e=
7ebec93d2
> [  129.803106] x14: 0000000000000005 x13: dead000000000100 x12: 0000000=
000000038
> [  129.810223] x11: 0000000000000000 x10: 0000000000000001 x9 : 0000000=
000000000
> [  129.817339] x8 : 0000000000000000 x7 : ffff00003fe258a8 x6 : dead000=
000000122
> [  129.824456] x5 : dead000000000122 x4 : ffff00003fe14628 x3 : fffffdf=
fc0f799c8
> [  129.831573] x2 : 0401010101010101 x1 : 000000000007de67 x0 : fffffdf=
fc0f799c0
> [  129.838691] Call trace:
> [  129.841129]  free_pcppages_bulk+0x12c/0x204 (P)
> [  129.845653]  free_frozen_page_commit.constprop.0+0x27c/0x478
> [  129.851300]  __free_frozen_pages+0x1a0/0x63c
> [  129.855562]  free_contig_frozen_range+0xd0/0x118
> [  129.860165]  cma_release+0x7c/0xd8
> [  129.863568]  dma_free_contiguous+0x2c/0x74
> [  129.867657]  dma_direct_free+0xd8/0x1b0
> [  129.871482]  dma_free_attrs+0x84/0xf8
> [  129.875140]  ravb_ring_free+0x5c/0x1b4
> [  129.878888]  ravb_close+0x12c/0x1d4
> [  129.882368]  ravb_suspend+0x60/0x16c
> [  129.885935]  device_suspend+0x148/0x3f4
> [  129.889766]  dpm_suspend+0x1b0/0x2ac
> [  129.893332]  dpm_suspend_start+0x54/0x70
> [  129.897245]  suspend_devices_and_enter+0x124/0x4b8
> [  129.902026]  pm_suspend+0x1a4/0x1f0
> [  129.905506]  state_store+0x8c/0x110
> [  129.908985]  kobj_attr_store+0x18/0x2c
> [  129.912727]  sysfs_kf_write+0x7c/0x94
> [  129.916384]  kernfs_fop_write_iter+0x128/0x1b8
> [  129.920815]  vfs_write+0x2ac/0x350
> [  129.924210]  ksys_write+0x68/0xfc
> [  129.927517]  __arm64_sys_write+0x1c/0x28
> [  129.931431]  invoke_syscall+0x48/0x10c
> [  129.935177]  el0_svc_common.constprop.0+0xc0/0xe0
> [  129.939871]  do_el0_svc+0x1c/0x28
> [  129.943180]  el0_svc+0x34/0x10c
> [  129.946319]  el0t_64_sync_handler+0xa0/0xe4
> [  129.950492]  el0t_64_sync+0x198/0x19c
>
> Using ./scripts/decode_stacktrace.sh on this leads to the following out=
put:
>
> ./scripts/decode_stacktrace.sh build-arm64/vmlinux < out
> [  490.453272] Call trace:
> [  490.455711]  free_pcppages_bulk (include/linux/list.h:203 include/li=
nux/list.h:226 include/linux/list.h:237 mm/page_alloc.c:1525) (P)
> [  490.460234]  free_frozen_page_commit.constprop.0 (include/linux/spin=
lock.h:392 mm/page_alloc.c:2919)
> [  490.465881]  __free_frozen_pages (mm/page_alloc.c:3003)
> [  490.470143]  free_contig_frozen_range (mm/page_alloc.c:6977 mm/page_=
alloc.c:7379)
> [  490.474747]  cma_release (mm/cma.c:996 mm/cma.c:1025)
> [  490.478149]  dma_free_contiguous (kernel/dma/contiguous.c:430)
> [  490.482240]  dma_direct_free (kernel/dma/direct.c:351)
> [  490.486064]  dma_free_attrs (kernel/dma/mapping.c:688)
> [  490.489723]  ravb_ring_free (drivers/net/ethernet/renesas/ravb_main.=
c:249 drivers/net/ethernet/renesas/ravb_main.c:260)
> [  490.493469]  ravb_close (drivers/net/ethernet/renesas/ravb_main.c:24=
06)
> [  490.496950]  ravb_suspend (drivers/net/ethernet/renesas/ravb_main.c:=
3225)
> [  490.500516]  device_suspend (drivers/base/power/main.c:504 drivers/b=
ase/power/main.c:1965)
> [  490.504347]  dpm_suspend (drivers/base/power/main.c:2049)
> [  490.507916]  dpm_suspend_start (drivers/base/power/main.c:2282)
> [  490.511829]  suspend_devices_and_enter (kernel/power/suspend.c:523)
> [  490.516609]  pm_suspend (kernel/power/suspend.c:621 kernel/power/sus=
pend.c:644)
> [  490.520088]  state_store (kernel/power/main.c:819)
> [  490.523568]  kobj_attr_store (lib/kobject.c:842)
> [  490.527310]  sysfs_kf_write (fs/sysfs/file.c:143)
> [  490.530967]  kernfs_fop_write_iter (fs/kernfs/file.c:352)
> [  490.535398]  vfs_write (fs/read_write.c:593 fs/read_write.c:686)
> [  490.538793]  ksys_write (fs/read_write.c:738)
> [  490.542101]  __arm64_sys_write (fs/read_write.c:746)
> [  490.546014]  invoke_syscall (arch/arm64/include/asm/current.h:19 arc=
h/arm64/kernel/syscall.c:54)
> [  490.549762]  el0_svc_common.constprop.0 (arch/arm64/kernel/syscall.c=
:70)
> [  490.554454]  do_el0_svc (arch/arm64/kernel/syscall.c:152)
> [  490.557763]  el0_svc (arch/arm64/include/asm/irqflags.h:55 arch/arm6=
4/include/asm/irqflags.h:76 arch/arm64/kernel/entry-common.c:80 arch/arm6=
4/kernel/entry-common.c:725)
> [  490.560901]  el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:=
744)
> [  490.565074]  el0t_64_sync (arch/arm64/kernel/entry.S:596)
>
> Reverting this series leads to no more failures. Should things be handl=
ed differently now in the drivers? Do you consider there is something bug=
gy in the ravb driver?

Is it possible to do a bisect? That would help find the issue. I think
the series does not intend to change how existing cma_* APIs behave.

Thanks.

Best Regards,
Yan, Zi

