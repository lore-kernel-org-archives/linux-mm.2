Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86A79D6CFDC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112396B03E4; Fri, 23 Jan 2026 01:24:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86766B03E6; Fri, 23 Jan 2026 01:24:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7912E6B03E7; Fri, 23 Jan 2026 01:24:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 260F36B03E4
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:24:47 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA3981AF701
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:24:46 +0000 (UTC)
X-FDA: 84362240172.27.950E57A
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010036.outbound.protection.outlook.com [52.101.56.36])
	by imf01.hostedemail.com (Postfix) with ESMTP id 30FE040008
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:24:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ebLYpcdo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.56.36 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769149484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+sCdI7CXE1phQDuSk5W5X7UWsQbj3O4orbU6eVepQA=;
	b=6jvVu1WYTgP+yKg6Zlj7P8ZOO7zfRp9fVPVe1U+jqf7qU8OucW2kGHFbI3Js/ugFlGIK1R
	zkUgPEn8EQmkAoIJI+1RZK8iY7vYcK/SFpuEKzvi8KwwKPxeNKfJnxmbB/Bz+fapHQhrwy
	HknWFMn6qNsPXejHwZlMknXk1aHriPI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769149484; a=rsa-sha256;
	cv=pass;
	b=5uAeXNgzgUrCzfyaRQSpbKuhzUtyWAeiCHp0rfYogopWLT1cx7ou5PQ4yNE+pS9XJfUeHz
	CwKPS+Bd9AsZWhk7soGLp9tuRQh5MfbfCc3ZDuL+fu2PJ5nTnLehie/iPU6cqilVa7v4+Q
	fNR50F1tOGGahgxW1YhQ/6wfh81MEw8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ebLYpcdo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.56.36 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X6N4eBQdzmUeGdCE2gdVWNQFPkBQRdu2hYjuKbOVTrb0zC2K95docfHXWDzqfPMSJuUV7ucfLVrxdTsxn+m9GMDOygWS9HZNDTtYtG0urrqxrXmRh0ozZ3jUKSvRB2Jgk+YS99Ip1IKI9PKk5dBGj1g01hPycGrXO0mwYo8GntsI4DiBVr/Ktx8MDr3OgpwbTo/8Njd8JYDDeK844/xUQMrVipCV9HIwDjxwXTdFB0gIAdIMm/RP83deXfjo34iBT2Yay8NYfU3Q2E68amwb3gCqJsFKbKigq46/z09+kYVB+k4Mf0h/bCaUdABl2L9/1hNl+SEcMBKMpHYxM7UxVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R+sCdI7CXE1phQDuSk5W5X7UWsQbj3O4orbU6eVepQA=;
 b=x75zcuxoNDCc8eAtl2y51gcZB0gYzITXr5ztNZ0LtQCqMKGCObR4vvF3cXJXYOp1f/gnrXMo5GQkVyi/gJ38X68JDWE/J9h4HdtWmbaLpDGWKnlNleNIvRRQzUYl+wMLRRy0ZbaVmPmJ+sGFVxNcHIeaKjW8WNgQ1hb91yO+zR1TqhAmjvPdJHoxrp60fu/NHbpiG5fbtYbK0NynZtjiMljRJ7tXH6wCnyuxzXW7TGkHA1086OCY9caX27oJR0P4bbLUI1msMIY+hppKDLmpx/WEdgMMEH+WGviyLJCPw9An1YLMqWHzVgfWzZQjD928ThbOoqtLB5aZILGWeNrE3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+sCdI7CXE1phQDuSk5W5X7UWsQbj3O4orbU6eVepQA=;
 b=ebLYpcdo473lNFtxrQjPWmcZbmvh3BxeMnjO/vjz5KouvLY0szehpPP00qhnix4TJ3Nl8BRZjQ/FOlAC4HvP7Jh9fDJ/J4uVXxFhBgBOH/g8vYPwCoEiz/tmkMA1w7Bi0oKZ/iKWq47zYRWzzBvE8UGvEQ269d+gjPsqTt/DpO57CFXToxg571fbKBUocbcxkJ0AdUDoYouMmvY7GheEiA899S1fD9dVzAAMrHguL8+t82dMYDPzWwLWLjvMUpOf5v8DG5WBaU0x0dKMgHloxnv28+21piuLIy7YFRsfKfVJB0LWkiAVX6IBphSsVIVy+ebOtviKBjGNb/0h6tcI7A==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 SJ5PPF01781787B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::986) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Fri, 23 Jan
 2026 06:24:36 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 06:24:36 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH v3 12/13] mm/hmm: Add flag to track device private pages
Date: Fri, 23 Jan 2026 17:23:08 +1100
Message-Id: <20260123062309.23090-13-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123062309.23090-1-jniethe@nvidia.com>
References: <20260123062309.23090-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::7) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|SJ5PPF01781787B:EE_
X-MS-Office365-Filtering-Correlation-Id: 443e36ef-9d59-4bd0-680a-08de5a4814b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aKRsFDU2guNFGTaEJiklkLBWMurXGtH0iWaYdAeOhARwqn1fbRhfBvn6cLuq?=
 =?us-ascii?Q?nvKCJ8r3IrnBSCBGilXut2LxrM5g5tcoY407fm5iWGa8bltzu/cy9/nVo9ar?=
 =?us-ascii?Q?vzc0AvR8bPVZLWZL0YcM0FmuypHs0z/H6UWRi1lsF3KWx6bKylD3p3XhkdR+?=
 =?us-ascii?Q?+DLUYFBPNCUVGxz3u3s7hHyRtyFU/ikYwVkU75JoFCT6KbRaJdEwIkptwFin?=
 =?us-ascii?Q?BXQsbu5R45qPYRCjBabwWSf009Fhpzuqj6rbfSM6uO06GX+3aldD6LVne91U?=
 =?us-ascii?Q?/0MfR3+vXZ29KnRq+AWuonrVTrnemxV7Dg5baWaOQT4Bb64h7psG5sjNKBEr?=
 =?us-ascii?Q?5S0XnNR9txuSpJCgeW1F1w5Im+aZmnI9yWulv1/LhTiOGd0hq8PEQi57P+Tj?=
 =?us-ascii?Q?g+QlyGciOahsWfUQB2AGtHJiAMK+79ORZAxxYBBKISg79trPwZ61xCDxw8Rm?=
 =?us-ascii?Q?rqvjhPPZuMdQa2ogETkd4oUirmCSVqW+Uag3Q5Lm1gFwC2D2rGvWi5wSiUeS?=
 =?us-ascii?Q?rfMGIMA2DiiCfqkt3Z7PHkdIqgTjPz8xktCYgwsqkKnQZHf00agYr7LfmrKA?=
 =?us-ascii?Q?bqe6DeYJxCyM9cNLsHWiOAEDfcd5aLkMIFiaVLBVclt02/xf8eBr4Mz9b71K?=
 =?us-ascii?Q?JX4wzrAY5rQaI1k2XBKv+0Qan9z/Ar3LQ6oAtn3ABcFc5kFdjL1L++FzQI//?=
 =?us-ascii?Q?LWQl+fFzCTYrnVNuEEFboPYsF/VNOctZ6MKuElr6gVvkREh5DsvJyJaJmNHl?=
 =?us-ascii?Q?rRfsyOU5dZs4Z/drZD+gzbQLnjgtVKJWVHh8YY8jgILwSM8Sla84Qfjy38PO?=
 =?us-ascii?Q?nC44x/s7byIo3CEuGw08RRks8PQVSsR7mn+9klABaBjpFIKB0fp064+kKBFI?=
 =?us-ascii?Q?Jja6xbO4NrrueUKYkKCGgmpnc+K7aCd/TVtHN49WJmx9ZUcFZeN0aEx7Bb3y?=
 =?us-ascii?Q?gGrGNdsLprI38hCZXrnW+8JNevcTQU0tYsv6JrABqfphw2a0jjKzJIoAfRur?=
 =?us-ascii?Q?gIaCSAnT5qXlvTg29TlidMT88hRLuGrq6x/Y92fmvVyZ8bHp2ZGUBTtbzLZu?=
 =?us-ascii?Q?K4NbKpdEtoyah6gIxsFi1pNV6V8WE36Iq4uv5Zko8+B2TH5aUoI0+IW/wLE9?=
 =?us-ascii?Q?7RhkDNCQYXrPpQBBL5WZxLhWMaO0phnt7q9x9otpoVrGYqmJgfW9XEqGp4hD?=
 =?us-ascii?Q?v/VOXeI4dJ5A2g2iJg9E/f69OBsJtf8qVKOcryWVYNnRZvBhluruQloAZPWd?=
 =?us-ascii?Q?8ANOmxwg/cDBN9D6Pu9VCJ0duIJK5MvVD2uuMNYs8hdnfyShR9N06fy3m47N?=
 =?us-ascii?Q?i9cbvA2XxJNm95anU0JMSQz2f/E78IkfgtqzZjJK34GjO2bMxkXLPfvK/ofL?=
 =?us-ascii?Q?QxMGcNVVOMghPmbW8LoLZ/xy3/e+uzAYzD7Xjw1OquumvtkVGqDVfMd2b6wa?=
 =?us-ascii?Q?FcggGOZuedzTpm/zuJ3s4sYv97z5xECYPYhZCcLA9MGadmzHSqRg/fa1Pb7s?=
 =?us-ascii?Q?uWH4G3wDwW+igOqWEu2Q/2x1jes1nPdRKGa7QEIVF8HO6jNmCp0iwWM5x1AH?=
 =?us-ascii?Q?eFHblSMJCO7LmHxxsfo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ItT8SGR88oFzDle0wfe9/fuIOA16FNEPjK+E9PzG2BCoLcZiBbI6iALkwm+F?=
 =?us-ascii?Q?5epDGOebaaNUO2uhtT9kDrkF5yWbxfz9BDBitv1VBIC13D2YTYQtljkwaX+0?=
 =?us-ascii?Q?WQGZRK+1FG/0HgdPhaDv57GVBRpy4h+I/ZgHrqORjjMLspRCYPckhz9UOV2B?=
 =?us-ascii?Q?Kfdb2nzqU0sWEu+zLYF6znLdX0j2X5juCFomgf5UJLItXyq4pE3nVuixeAxC?=
 =?us-ascii?Q?7DHBktb9kDs6MzHvhrZAbCrO2d2VA1PDYwUlVwN6VzSostN0LPwIlnBHNvm2?=
 =?us-ascii?Q?8bAzIenJcjefGoRFklCXga6DYTCpXxyC23fXLL39AfCI76kXfAyjYs5AcdFj?=
 =?us-ascii?Q?SPXmesHGJLpXDfgrQweciSFr6X8+CchvgIpFnuenMoxRPNwj+Mcx+XbDhbw9?=
 =?us-ascii?Q?E+gGG414X0fvvPkA8LwMQ5vMsp2oga0cco0Xgd01crqJZPgVz5vgDmUVj/ZN?=
 =?us-ascii?Q?ObaYjpYc7pdSyLz26JLZuM61mIJ3qE6H6jkBcIm5l+cf+48UDzIFrMlOHd8J?=
 =?us-ascii?Q?yIJW4QzJ5ntNnwpN77r50tYMHZLb4X9H02YU+tmfRIgkXWoJ4S7HerC2Akqp?=
 =?us-ascii?Q?4rKyNvTyvNJYRyzbXtxttQyF3+9IlsYZar9ktvgGwokozYEWkTdbU83a7GNG?=
 =?us-ascii?Q?pGqyLLmDMuFlWGY5I+iFkiNKTK7NziD0ldVXxfd8RL2lVdQFYkoNRwYkQejg?=
 =?us-ascii?Q?WSdEfvwkX5zKb+jDYPQCNMpeSqKLbuEYaU14ln/KBsVIUag2RkVS5+WiVx1K?=
 =?us-ascii?Q?Axm56COSGJZP9NUcmemrGOcz61pV71Tszxfxpe0XNHZIfMAwo/WXnYVkB9wt?=
 =?us-ascii?Q?QF6P4RiTq2kwfkW3IHvatl4Gn4d5h0CBO6P1Evet1pqRWHoMhbDtJtZkFr08?=
 =?us-ascii?Q?lAbqJKMhKatEOz4yH3oJwHCPGfpTG8ICHUCYGXnLL8lqRTbh/c3kdaGpNiWI?=
 =?us-ascii?Q?vD33q/DgUOiBJFLWTW/jbKarKBUffyrfWIaS0eSFEQx1hijOA+9Vvqft//SW?=
 =?us-ascii?Q?dYsjbFfXNS3dW3B/73gnRRIQkwoCbAXOCRKS7B/mhhoLJ3s/TdcUGMQgRfpD?=
 =?us-ascii?Q?cnpFhc9y3f3sW8biAh72CnTMvYSFmYxxReu6nfCgqy1e0XywJA9cfprFZKXB?=
 =?us-ascii?Q?Pzvevnpit7Md/eUheZ2oU0t1qJqEK0KnsShADo+wtHTghGt4Z+Zz63xE6MhO?=
 =?us-ascii?Q?Uec8H0BF4F4PvGoNlbh5Cp2WYttOr2kNz7PmW8WMwy0rLoIoXTcYbVtT7VQH?=
 =?us-ascii?Q?9DO5iZeo+HS/5w+yK+M4brVX3cNY/w+NNrcuDZ2cyWSt+xS5A+IfHF74sTpm?=
 =?us-ascii?Q?DzHskMz5Db64ij4MDx1hAMfzsvq7UFklMGOfFvMACaezYkWquvGrTaF82hBx?=
 =?us-ascii?Q?a6VdOvjudxt223TA/7FYKhQDaA0ndAjNC0wCCsbDS0vmxzNDzPUsUfhaSUxe?=
 =?us-ascii?Q?iR1GV44SBFnwCiAinQJfJLha8ZIAiCwuHeJo3kpLwB4WCZO4hu/iOUv68AcW?=
 =?us-ascii?Q?HkUNn20HGnGk2LASCvewajiHiZQOi6+JrrzronaCZo8qMqLgChcnbD4wQ/Ld?=
 =?us-ascii?Q?Uw+DXCyTWJAJl1QxLBT4h4oysdZ2JnFhFtEd5QBR8AewB/xBlFmDyFy9rG5x?=
 =?us-ascii?Q?lxkYEu+R3uQjBA+TpbkJApBQfthNXvwRm1VftdV6UE2NhTM6Id2pe0uFi/U0?=
 =?us-ascii?Q?4//mZ3HTMKxHAieYFneJYDH/qAzeUDkba4q0aPUfWfNm5pPfd3kz/WnnVUp/?=
 =?us-ascii?Q?tpzs8YhYcw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 443e36ef-9d59-4bd0-680a-08de5a4814b2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 06:24:36.6103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +UeLajU1Nl4sfPWSa+RJWFimmMgSEDvm/VPF9wJopf5LqZmwK95Y8VBhtsbAa/xchIq57qY3vg3e1Lk4mMtmLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF01781787B
X-Rspamd-Queue-Id: 30FE040008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: nnys4oonzo47jz55am6j3xbpzb1kfa9d
X-HE-Tag: 1769149483-814470
X-HE-Meta: U2FsdGVkX1/UnaAE5LVT5GE9hOGXH0/ZSheS5bSNZCSP4Vv/ob3rvRLh74t8ePOStpgVuSy+XaoG9pqX+5nR+rw3KHPFSHbH7PJTMz40RBf4BO98FWHZeE3xD3iQyCW6pivHgftN25rqd1OiRncXY/cpE14kVApmWFwAOaWhWCSXyaJPBQDKneTGIytIC7L0FCSudrLMczY5N6pJZ/oVdZ5iPKq2S2+Cx2mh1/sX/YFfj9KkDEv4uro5UuVZUuc9U3vuhF9quxBZOqN6W2gOHDTOXAmD9bdPs5N7rjt4Ac24QNTS/HaHYbcx2CSbUPGTt2j3P0B98syJ7cgm/Jg7r3M9Ccc/c2CQetObLebEdZv6pKhw6EQs4uWZSwzefM4lefqriVYN1tdHFlGXQHVApqBTOOY2JoQaIR5DrTvkMzKx6mE+LZ5vz0br0q0PuNsC3wGjb1MCcTFNB73i5bek0ll3YjNbZlvTGjKWdb4VhPhoAetpG1zcwKp1rasiZUG6RfIIasrsS5zhYzmZqU6QlhYs1cIAjbc2hP/kMmc+ayPHvEjZyGhxMmFe3ga6PA4meD4F2uM8p02F48NbQUL4g/OXxvKKbqnUA3gUf6oBUydx/l7GKhy7ibqbDSahABhgDKeDB504ryE5/HnX+zD8cKR7sypI9h4rc7+TIoKaINvR+d691sMIwrmYIY58MDYrYuThp3UYNod/ujn+SzCshdV72nvo1p9KRda7rzEBSGr/xsLXxBYKtYjMSWrQVRnU2aeII/XmJGqopakoVbAF2bdL5skPTLDGpu0SMl9pYAph3ymvX7ZwMISnDhYrVWpmU1TwuoPpG+5DStZXbic7bsagbP3ybShsfZJ7uXdbdjVgRYSuMU5oz3BoYQ4UiKHq94ZZNqcPvLMUZCYJZUhwdLN86TfSsMU7nfnRY6o7/6yRD/1FmqI2dgNjo+W4QsspBLVDipdxpHmJ5sWSi1X
 UvfvHXMh
 W9lJb31Gg8zJhM0gB8Btzvggsw0q+PI/6X1v3X81d5G7n11cZzuX/sMIjt8YTlwHMHf0s+a/iLmEygrTIKGtrXNsu5sXu2gm3gG6STjR7/A2md6hZfdRRkvJPK9ltfi7tirMEtE6Lga92r4Uc/rcCUt5L36Ep+pLPkCGOJWFeGATKAjUtDlcLUokySi8POz8ioFQg/AZjN+IIdk+O3YOBk4q1fXSl/kYATyQKHBwJMNOEdCvZLlfwpxsBXuVH1mIhUCNjbFgmP3g8S4GUCuHT6prF6UEWqdJVfEtyzFJMTlU9ejJCYplt6lBC6E27oiYuT6A9AAVqJqWjes3BrbD2YnPmLx/7vHMpLuc8iPkIafr7A+HpH+UuNzRoirRmONq7ZBT4jfafYI5wosv5WofPDi/472OweD0E9aIh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal pfns and must be handled separately.

Prepare for this by adding a HMM_PFN_DEVICE_PRIVATE flag to indicate
that a hmm_pfn contains a PFN for a device private page.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>

---
v1:
  - Update HMM_PFN_ORDER_SHIFT
  - Handle hmm_vma_handle_absent_pmd()
v2:
  - No change
v3:
  - No change
---
 include/linux/hmm.h | 4 +++-
 mm/hmm.c            | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index db75ffc949a7..d8756c341620 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -23,6 +23,7 @@ struct mmu_interval_notifier;
  * HMM_PFN_WRITE - if the page memory can be written to (requires HMM_PFN_VALID)
  * HMM_PFN_ERROR - accessing the pfn is impossible and the device should
  *                 fail. ie poisoned memory, special pages, no vma, etc
+ * HMM_PFN_DEVICE_PRIVATE - the pfn field contains a DEVICE_PRIVATE pfn.
  * HMM_PFN_P2PDMA - P2P page
  * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
  * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
@@ -40,6 +41,7 @@ enum hmm_pfn_flags {
 	HMM_PFN_VALID = 1UL << (BITS_PER_LONG - 1),
 	HMM_PFN_WRITE = 1UL << (BITS_PER_LONG - 2),
 	HMM_PFN_ERROR = 1UL << (BITS_PER_LONG - 3),
+	HMM_PFN_DEVICE_PRIVATE = 1UL << (BITS_PER_LONG - 7),
 	/*
 	 * Sticky flags, carried from input to output,
 	 * don't forget to update HMM_PFN_INOUT_FLAGS
@@ -48,7 +50,7 @@ enum hmm_pfn_flags {
 	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
 	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
 
-	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
+	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 12),
 
 	/* Input flags */
 	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
diff --git a/mm/hmm.c b/mm/hmm.c
index 4ec74c18bef6..14895fa6575f 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -267,7 +267,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		if (softleaf_is_device_private(entry) &&
 		    page_pgmap(softleaf_to_page(entry))->owner ==
 		    range->dev_private_owner) {
-			cpu_flags = HMM_PFN_VALID;
+			cpu_flags = HMM_PFN_VALID | HMM_PFN_DEVICE_PRIVATE;
 			if (softleaf_is_device_private_write(entry))
 				cpu_flags |= HMM_PFN_WRITE;
 			new_pfn_flags = softleaf_to_pfn(entry) | cpu_flags;
@@ -347,7 +347,8 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 	    softleaf_to_folio(entry)->pgmap->owner ==
 	    range->dev_private_owner) {
 		unsigned long cpu_flags = HMM_PFN_VALID |
-			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
+			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT) |
+			HMM_PFN_DEVICE_PRIVATE;
 		unsigned long pfn = softleaf_to_pfn(entry);
 		unsigned long i;
 
-- 
2.34.1


