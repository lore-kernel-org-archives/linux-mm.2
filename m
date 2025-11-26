Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE20D10379
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 03:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6B466B0006; Tue, 25 Nov 2025 22:51:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42F46B0011; Tue, 25 Nov 2025 22:51:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31D56B0012; Tue, 25 Nov 2025 22:51:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 903816B0006
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 22:51:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A33389891
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:51:47 +0000 (UTC)
X-FDA: 84151384254.26.5BA8C07
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012064.outbound.protection.outlook.com [52.101.53.64])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7F4C71C000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:51:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YI9dtQZo;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764129104; a=rsa-sha256;
	cv=pass;
	b=UoVeeeGMusVh9Vgw0IOP3cJgxEGWKPolbd5fOuwTQLDU/HLLIDu31+IkG6nIBWK16JDccm
	hCMcmivjX/nJ1/ETlLQpp2YbLmzyq9txZNSjM1x/gye/428N6Xl2mpUOnoLJ8CL0BJyCiD
	Yyn+OXwJ3UlfVW4VxR4cipdK4nyt3d4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YI9dtQZo;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764129104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MmAxdBKyno/6idkEmNjxudCr8arK4EkKmSpGqtcBPWg=;
	b=X0uXtJU1dpqurrY3vzHd8bLEbhN06zE8J4gbRtfi4u/EAagykxqxdo4p/TsydHDmHc0M3z
	v1jI4cfOML6nExjZpVEjyyZlPO6e5HfNQkvGXjg4GOnstBZv40FQRCN21KlIzyIjoNaOW4
	NLsgssMglFCIV33Dli8R3koiysPV6uc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vL0ycvb8BQZfGsLi+p+7DMV5DuuftIAu6pKvUsB86Kxq3GILWIOJK73pVyuw42caj0KNCG8mwk6ZZSmQ1YT2uEG3uo6XqrfnnhDvytFr7CeMTu9Tz3p7O3oU+upnkHu6HeUn4S7Q8rVd1Ju+oBuJNBykGK8j+MQElEr2P5iYrbteXp6reHqRFw2uNHHpBiaHkZg1WdjzKKML26qMsP4CLc7duHM1MXVmaqf5x29tXpNVuJtNvoTwwL4hF0Q21nIiHnbmjw9F7yNVQFJLgufaeWy27VV/W/9JHOkpJzzI0nwHqRCcfrldksALfDe7xjlCmWVM9+0xnkaE1kpqa/RpMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MmAxdBKyno/6idkEmNjxudCr8arK4EkKmSpGqtcBPWg=;
 b=h6RDeGKar65cjyZIS1wfMUAoNbiSVcORv1Ros7V+cEXB65dRtY97GWmq0hIOHy6GjKyFN567PBxwdNHiaG7ZAaLSq6UCYa4581u/bMc36iWcj7hPSoFbe15TTma7S2OMjPdujAPSydTMUppU2NGmTkHp6TxzW8vy/cSeiHDB6C7Rl0RFm1ym08LrxefQcF52Besx1R1R14oj0odK8EsfwotEDkI9ZVdmD/ZkYu728ODxNQzPtQVkKPSPt/SHuIOm3ynCdBxVPS5PvC4zrrt9x+BnV5dVQn2YEvqnGDtfxGFIM5zJCchLsYufa6PN/SYn2ckxKwNLVeEBphl106HZQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmAxdBKyno/6idkEmNjxudCr8arK4EkKmSpGqtcBPWg=;
 b=YI9dtQZoauAKxu5zSwMqaFXGfZ2ob2/Li7Al/0TyrUIbZLOhBrqeUIeaLmJtFeWo+V1bguS5Idjykt5mVEM9X6Bdda+lesX15VPrFTh+Rb9rW2xBR/ccy0quEjbDL4IMIxjgJSlRifBxIEBxcnJSEn2Gb1nE4m1i3z0AaPyXGlh3KLnNLdceIxHUQ/1gdxxa5cAODbrm0/LkVq6wT1tLNaOLUqqPa11cWxEmJT0ZUDV/WJV5cGSnyyX1VkDOGix/ga9xHstwfrVpOP5hFVdFVoWf823xOs4Uyv5c2uW/HP4uwviDogvLNUDZSvWHKGLP8OCHaHCCGWtQjwe7xiM1VQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV9PR12MB9782.namprd12.prod.outlook.com (2603:10b6:408:2f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 03:50:15 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 03:50:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] mm/huge_memory: change folio_split_supported() to folio_check_splittable()
Date: Tue, 25 Nov 2025 22:50:05 -0500
Message-ID: <20251126035008.1919461-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126035008.1919461-1-ziy@nvidia.com>
References: <20251126035008.1919461-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:208:91::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV9PR12MB9782:EE_
X-MS-Office365-Filtering-Correlation-Id: bac5cbd6-dd2c-4c03-a0e2-08de2c9ee885
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SBci8q6VLWI+gV9udkMJtyuPuCMhALEqCqh9WoQkuQSzy/7rzoKn33UlIYos?=
 =?us-ascii?Q?JCldqAHJ5VLDNx3kn6020Tav0b/Q/wyZUR3ndPirlqbUGxQdzoaNAsrzYIbS?=
 =?us-ascii?Q?sFsvdmKJBn9s3VCAM1US1+a1bE+PJiI2vGGstK2FMbLBxVtbueM1aDI5a83M?=
 =?us-ascii?Q?uUrSfDM9qh7Qp30kdDdlG1tKAKlfSpjfhJG8Pr2t7/HTnqdjgHHGvFqkhaKy?=
 =?us-ascii?Q?ePyeu8uou5kDUu+0bE0ZxILn01N9dsK2wxzeU00Xt3cN2wPllif1Ci8ljb+K?=
 =?us-ascii?Q?9rlOommpzraWD9grVTObZtt58TFKfrqK0oldHUJpMORmoEyYUgieYLshAxqH?=
 =?us-ascii?Q?k/RW9CkSr2NdNQQISP+ZqKqhsCGd7HpOPtaHoZqb19zcYQ5CllmG40576iI4?=
 =?us-ascii?Q?Sx0vmiYwq54T7Rp2282yAuzkKVoHanUm6h4wi0DtwonvEcUa+33mXQWFHVyW?=
 =?us-ascii?Q?w7m3Ia4F/g50zh6E36ZMOHAA8PrPIWgriNo+AqvMZEw5gfnnbFnbRaDqGI5M?=
 =?us-ascii?Q?1b8j9jJ8pSGjuLaTv7RDyvwwVh/iyt+SQuRcFKHdZtIyKRDXFteiIGm3LR3V?=
 =?us-ascii?Q?Koylti6PpTOcfVfrBL/1zCnqFxtKmKwJKPzlL4TyMDtrqYhB0LndvayDC8h9?=
 =?us-ascii?Q?TvJSD9jVh4QrtStp4Bw50QqqtrStmi2SV1Iibk4BnTpH4JhrwHLjqP9IjZEz?=
 =?us-ascii?Q?Kuff7oy6+3/9Tdfrg/terY7lhj4V3m0mFjoYJiuqiat8FwMa8Xh29nS5DeP8?=
 =?us-ascii?Q?O2YoTw0ZZXF2BvwLzMnqiELpozBkomLB6gFHxrpw+cP8Ev4HyNdMlhzWb5t8?=
 =?us-ascii?Q?k54V9otJ8P37eak234lLWjwBjXnoF0KEoAGvnyGf/ye91gIM9JAGdKbsNiLH?=
 =?us-ascii?Q?d2avxMCSBVoJv7GSk0VmltdRgHyiK9VQPjeF0VZ2WRCUIQVXB6plX3Uq8Sqi?=
 =?us-ascii?Q?mmg2u0WsoqNVvMLCsvqKzr1MBeM0Zmjzyx2NFhoBzReJqt3Y2PiAupM8mSmS?=
 =?us-ascii?Q?WcxtHyI5ztD4DO7XfSrl7n36v+p3d2PXDLko1iLV+IUoqmomNzQ8cTmqhJi5?=
 =?us-ascii?Q?DQFqMTsYTQAcQzE9BYZqWTN9dBWParZerprD2mlE4T6kJPEyiecblDLZzR8e?=
 =?us-ascii?Q?YIZKOOoHX4b7PNu04vtQcCuPo7qWMxZMjSrQhn/1GaiqyPioiWiwjpJNMW6l?=
 =?us-ascii?Q?VqMW0VmPv6tqd6HUFkbFOZ8qbaFPnPysPn0GaieW4AtpWrdwQceXeDLVydAW?=
 =?us-ascii?Q?hC3OBK7rp4mD9wzTiWeL3C1vlNOytCmMQf7iQaP+bx1dxM+oB30YNtBwALnB?=
 =?us-ascii?Q?b1BtbHrhGM6XCbqtgufXYjP+Vk/5Qo/AUn0RTNswLmEJnSzuhwlyKzBsU9IK?=
 =?us-ascii?Q?X1IV+my0WYBzvxFUSod59TEFScr0rNQRCcoblt90O6/ThmvQLJwWUibCESQZ?=
 =?us-ascii?Q?0+w0jzom9ja9JW0TOd6ZEBz/RrMDrWwP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tSCXyZ07IvL6bMwzLdyENyo+4E6K/6tLyLIlNA6a8UnT4uqqqx701k3gMdaO?=
 =?us-ascii?Q?0kyP+ORGkrlcRizpQ6tD8Yqry69hwNVIreYG63izWbYoqaN8ASDboPqrSS8g?=
 =?us-ascii?Q?NyBAzNuo/BJko7LS780aQ2wgEsV59pNTT4JJV0MbgVYasY5tNY6FNRDnF+/f?=
 =?us-ascii?Q?5mBD2zp6WqGAaBgzIOSBmkgQPFG7cNnhT4w8mgYqxV/YgaSL/5YBD5PSgly8?=
 =?us-ascii?Q?58WKpfiedawGAe22/3Cagb/VYVxByMiKItQBOmTIlrTS4vjx8O4WvIwg/uGV?=
 =?us-ascii?Q?UP2w/XKevCzcxRqo7puFtvXnIu7DgLWoIXS4IvWpYLE1enRdECfBeKOXi2yS?=
 =?us-ascii?Q?vaoJVV491yMlwr+vlJp0urFw9hddvEsb+Wp5UqkZ+QUPMRlstAFdN/+omDqp?=
 =?us-ascii?Q?uKxAXRn8Ra2X++IuI+U4dYjsVyn/1aDPVKObOedByh3B5skof7vm6blE9oGh?=
 =?us-ascii?Q?CM07Sh481F0JD851TiVaOnmVV9jPW0IXXznIZIQOP+xYlk3JHBwZAk2F+PxU?=
 =?us-ascii?Q?kgaWhL/Bg2+SHRQ7c0mbk4n19MCPdQW7pYpHhSAf2n2HDjI34hD1C3qrLJWm?=
 =?us-ascii?Q?O8nQpi2TnDQiHs11nFLKDo3l/ptKgKrfWAGMj6983ti9g4n49K/2vBLLOzKN?=
 =?us-ascii?Q?1bEGtLbHD0qV0dGghRVrr5Hamu2BInnw6ZnKH/7bzPJ54mAr4uu/TgMn1gZw?=
 =?us-ascii?Q?+sgXWx3CPV14F8dHLbz+zvObpvAgHywEhvjNE7xBUvaDqznoDvyomA1y6MOS?=
 =?us-ascii?Q?eIrfnlcKBoxvToV+NF9iT+xnZ1GXO0WgLRRxYKOgq86GTKH3GcF4xkWZy7ez?=
 =?us-ascii?Q?6toCZO2QiXqId8lNfoWvIPagvxiC0sgFkRQP6OHkbnkmaEZOIITIBNW0SiTR?=
 =?us-ascii?Q?64tmWVqqUzSXidQeF3y+cX4XPHliPZsHt6rHlYG6uX2TTgkCKjT8CwXc4waD?=
 =?us-ascii?Q?obZttxq5VSyCxcOvo/+QPvebMqFtTPav54muEaBxCVjZMoTueCCbm18UbAgJ?=
 =?us-ascii?Q?l7ioZOhIr4JMpdG1Ox77Twxj++UGm+N2F3PlnnxcBS9oKEO9CWOQcnjoN8hv?=
 =?us-ascii?Q?WKRFTMAG1/Xf1k5/mYmUlsVYvZ9bvkkq1bDe2Ybfc6H1WmS8wCBb5H9trMa8?=
 =?us-ascii?Q?AsZl1pb37AVsIUCSlFEW2VJuaiQgKyl8mG8p23MPEh2uOL97tJaDi4Og/gvz?=
 =?us-ascii?Q?M2qRc1i3dtvcrsylK1pwhLgZEbkGzJpCTojCxD8/MSu5qZZhSp26Gk5ZsP4/?=
 =?us-ascii?Q?UgnPhux1ruKYXixVxPtSMPGBvdygC+L4ht+U3NIBF7fmCCwYTdfw6Pr85yDA?=
 =?us-ascii?Q?CTjiJ5Pec2/Yt4EXk/W5p/llJmc1opA/RNh+rXqRiDiaOAgFGlVhbXh3C8ih?=
 =?us-ascii?Q?DZUsYxBNkf5tt8DFkhL3ermb/f39dseo/UtQmm6jFNhhtUJ39U3IvVXCt3vh?=
 =?us-ascii?Q?oxeLeMfSvKukaaXJz1IhhT5req3hTfUtrJsUFukqbopaXF2SgA9h7AI8y8DC?=
 =?us-ascii?Q?GCLa63Oemc9nINiEDe0+eiXfom+OTivR7hVhWr+fU6GLECOfjpDO1u0tmCw9?=
 =?us-ascii?Q?pa4TFs0FXQEOmnZ3ipuMPh4cJ7bSbGlTt5E+cBUV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bac5cbd6-dd2c-4c03-a0e2-08de2c9ee885
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 03:50:15.1758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rwP4fmU0v9vO/2CONEN1xaoGGNZ3MutWLd0nUGUVXq+tXi4bO7X7lrx13k9pvlN/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9782
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7F4C71C000C
X-Stat-Signature: kbfso7mj7sod7qg36gsu1yqt3r5zbh3z
X-Rspam-User: 
X-HE-Tag: 1764129104-218427
X-HE-Meta: U2FsdGVkX18GL0FbW3bmKo+P4db10GGY+sRhQrtYBVcQqW8jDwy5rkB7vA0TuuzbNMUpG2cWkP2T8xzEdJh7xODsG2JH7wY6m18M5elA0rJhlRY+REO1LShdf4Y9K+bNeVcnGF68hiVkUHVywsaFdyftgnVn0UCnsmj+PNHVQUKxUfBzIAzKFsmyk8jpW4njLb2qneTUyQJj3N4SgKNJR1bmy7x04o4NoYQb8idr8WZGAfbYSb5WGIfd9t5hSvI5t2XcHa57B2JuFhQfnbCwNQhVVaC6nH56kKiqX/FtfOF4YC5HJSvqSnwOvyb5M0K3A25mZkjf0dARf5kNuCN2qrzpUIT5pmEweZoRdo+jie9Vu3OvSrmF9yLFM4W/dFwcIhDM/1A93QbckrzRHnqio0ktqfpjzg8m3++pS6efwViIp47W2eg5c/JviK9rii/7pR4Q+Z2fjHxqR42sTl6bDB8oulEEZwh7B3DP/zmOsizKViUSqfrLPoOXCSEabeMAkM7Yo8XIcAvXD5CU/EqNxJV0va4x3m8X8HUyMhiqOv0njhhpizsIe516Ss2VhdqczVr38/LIAW4quBlsip+lOsvS6l6p2SULxCwZPgBWNTcD4fjfYUaWQheq3Cisv6L6+cSVmKXZ7OWVznV2T3Xy2aMBzRMBlqFp+mfs+8EIntCMqMvOGxPoVvK2SQrJ76qKxtSRgsln3Be4V3Afs2u1jEggTNqBhvnlZbfXJATmtSv98a3vS/2Q5NBvR0aEAqFOUG3y2UK3Tjxl4PksBW5TAEOAmwJTvCxMuj30zX75U24rNoAduHlVOwy0M1LES++Ools5qkZ6lf96sj0ifZ0GiHnsi9cms55dwkFdCIxxK4ZqCGCmyW65NKKaHvneALd+CaRcLsIudAvPO6h6dIyXznGDqGcl0sJN0X5X8Sot7NpqZwdPWAfogjtfF93MyqSL8cv+mSAxkpTLfT9pJzS
 I/osdXBh
 Xo8ThtxUe9msX/7S2lH7lO6wTqwEK7p+8yO/h6MtFUNldSahHVf0ud7fpBIU2zyIhlCSu5uVEMwf+GoMrFpNpJMiv1DwGXDAcgKvPfLJg6VCke4W/dIsJ4RlxgJXDhDuhCo9NHgGJ8q62AKHNaSB1Wpfxp8T5yoqC4iwME20YVOi3hYlANyKiie7NNeaALl+i8fB0s15ViSyUt2m6O1oDE1nyb6WXdSIfuAa5xpQuH9cITu2sxStePL7Kgv4X0LlqCALKjXqc8999V/h1F1oiYXVL6o9tniAamFPH0R+3q1yBhfqPtnP1ei6HpM2XvksSXPjugMGRniJnFcWlcs1gzf32Uxjkb9VJKrCvuLHhSe39XRz9PCb+vqDchpt8Ygn0XGX6iqFvhTeo6rJuZn6mZd9hnkwa6mfaWjUJKnn8LuLxl/CkyBBOr7YzfxDo/U6meV7Qk/FK4HczRyfXThyLpA3bE69iZh+2ody+30/s8B/FNNoRfTJiIOseJYLM8DgVD1AknUvy/Iyzsv0XVPo7+SLrqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_split_supported() used in try_folio_split_to_order() requires
folio->mapping to be non NULL, but current try_folio_split_to_order() does
not check it. There is no issue in the current code, since
try_folio_split_to_order() is only used in truncate_inode_partial_folio(),
where folio->mapping is not NULL.

To prevent future misuse, move folio->mapping NULL check (i.e., folio is
truncated) into folio_split_supported(). Since folio->mapping NULL check
returns -EBUSY and folio_split_supported() == false means -EINVAL, change
folio_split_supported() return type from bool to int and return error
numbers accordingly. Rename folio_split_supported() to
folio_check_splittable() to match the return type change.

While at it, move is_huge_zero_folio() check and folio_test_writeback()
check into folio_check_splittable() and add kernel-doc.

Remove all warnings inside folio_check_splittable() and give warnings
in __folio_split() instead, so that bool warns parameter can be removed.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
---
 include/linux/huge_mm.h |  6 ++--
 mm/huge_memory.c        | 76 +++++++++++++++++++++++------------------
 2 files changed, 46 insertions(+), 36 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 1d439de1ca2c..66105a90b4c3 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -375,8 +375,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
-bool folio_split_supported(struct folio *folio, unsigned int new_order,
-		enum split_type split_type, bool warns);
+int folio_check_splittable(struct folio *folio, unsigned int new_order,
+			   enum split_type split_type);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
 
@@ -407,7 +407,7 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
 static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
-	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, /* warns= */ false))
+	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM))
 		return split_huge_page_to_order(&folio->page, new_order);
 	return folio_split(folio, new_order, page, NULL);
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 041b554c7115..771df0c02a4a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3688,15 +3688,40 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	return 0;
 }
 
-bool folio_split_supported(struct folio *folio, unsigned int new_order,
-		enum split_type split_type, bool warns)
+/**
+ * folio_check_splittable() - check if a folio can be split to a given order
+ * @folio: folio to be split
+ * @new_order: the smallest order of the after split folios (since buddy
+ *             allocator like split generates folios with orders from @folio's
+ *             order - 1 to new_order).
+ * @split_type: uniform or non-uniform split
+ *
+ * folio_check_splittable() checks if @folio can be split to @new_order using
+ * @split_type method. The truncated folio check must come first.
+ *
+ * Context: folio must be locked.
+ *
+ * Return: 0 - @folio can be split to @new_order, otherwise an error number is
+ * returned.
+ */
+int folio_check_splittable(struct folio *folio, unsigned int new_order,
+			   enum split_type split_type)
 {
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+	/*
+	 * Folios that just got truncated cannot get split. Signal to the
+	 * caller that there was a race.
+	 *
+	 * TODO: this will also currently refuse folios without a mapping in the
+	 * swapcache (shmem or to-be-anon folios).
+	 */
+	if (!folio_test_anon(folio) && !folio->mapping)
+		return -EBUSY;
+
 	if (folio_test_anon(folio)) {
 		/* order-1 is not supported for anonymous THP. */
-		VM_WARN_ONCE(warns && new_order == 1,
-				"Cannot split to order-1 folio");
 		if (new_order == 1)
-			return false;
+			return -EINVAL;
 	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {
@@ -3717,9 +3742,7 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
 			 * case, the mapping does not actually support large
 			 * folios properly.
 			 */
-			VM_WARN_ONCE(warns,
-				"Cannot split file folio to non-0 order");
-			return false;
+			return -EINVAL;
 		}
 	}
 
@@ -3732,12 +3755,16 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
 	 * here.
 	 */
 	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
-		VM_WARN_ONCE(warns,
-			"Cannot split swapcache folio to non-0 order");
-		return false;
+		return -EINVAL;
 	}
 
-	return true;
+	if (is_huge_zero_folio(folio))
+		return -EINVAL;
+
+	if (folio_test_writeback(folio))
+		return -EBUSY;
+
+	return 0;
 }
 
 static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
@@ -3922,7 +3949,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	int remap_flags = 0;
 	int extra_pins, ret;
 	pgoff_t end = 0;
-	bool is_hzp;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
@@ -3930,31 +3956,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
 		return -EINVAL;
 
-	/*
-	 * Folios that just got truncated cannot get split. Signal to the
-	 * caller that there was a race.
-	 *
-	 * TODO: this will also currently refuse shmem folios that are in the
-	 * swapcache.
-	 */
-	if (!is_anon && !folio->mapping)
-		return -EBUSY;
-
 	if (new_order >= old_order)
 		return -EINVAL;
 
-	if (!folio_split_supported(folio, new_order, split_type, /* warn = */ true))
-		return -EINVAL;
-
-	is_hzp = is_huge_zero_folio(folio);
-	if (is_hzp) {
-		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
-		return -EBUSY;
+	ret = folio_check_splittable(folio, new_order, split_type);
+	if (ret) {
+		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
+		return ret;
 	}
 
-	if (folio_test_writeback(folio))
-		return -EBUSY;
-
 	if (is_anon) {
 		/*
 		 * The caller does not necessarily hold an mmap_lock that would
-- 
2.51.0


