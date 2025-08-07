Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936EFC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216746B00A0; Thu,  7 Aug 2025 13:04:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5556B00A3; Thu,  7 Aug 2025 13:04:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08DB46B00A6; Thu,  7 Aug 2025 13:04:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB5D76B00A0
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:04:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB01BC096C
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:04:43 +0000 (UTC)
X-FDA: 83750585646.12.60545D8
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2065.outbound.protection.outlook.com [40.107.95.65])
	by imf23.hostedemail.com (Postfix) with ESMTP id C2CE2140019
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:04:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hVJKySzA;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.95.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754586280; a=rsa-sha256;
	cv=pass;
	b=eHsgs/0Ewfqve2swUrS3yrSGhlT/jTXKiDWLVO/Y5RY/N6uFw7FjEgzUZcyO2es+5czfgk
	I0ncnbEvJRbFvHopMSJGPSiu6ReVjj0CKtYuUiSRxi5HeG8O6okfnvBgNIVWIkCtc/Ng0F
	Op8DvMnnIV6cE4Lnvbaba/9fRPDIiFM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hVJKySzA;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.95.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754586280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5M1vng7PZ+jePhiKKGxdoAcG5blZS4w5osU3jAdNhI=;
	b=uvSXIyqJ63shIF6fg3nQoAITObjYeZFfGwMABFhgtOBuCgu4xfnwVGVQ/B4d0TIcYdTqoN
	Bgy86yR35yxLwZ7JvJ4q6Z6SO/vSG3w+t+Qsr3GM5NECWyXZOclC0l/nAtXxqq66byLCwr
	q6Vlp3c5DQK/ZNUDTwR4y9U1ZtS1c0A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BJVVk6wPflYpdPYV9tvDf4TJo5ZdfoYXSW+7DssxiDZFl6HwzJ70G9MH4OvzWWm0Ah0B8iYfevaYAOqftvLrVz55xWMHEJWZVkzH1FEnbQ6Yt17jb+BKPvRCl2XbhBYswq8tue9caAImsyt6aR8D2NsNOp/dwSB5+kYAMwkI5/UXBhGxhLYGhcBhRHJNu+wRHj7SgktwQ+9T1aHfMqbxyZnw2CIz03ISMl4g0x5WlG1enG7dMXXR52LR15shfEl2a4bDlslXqJtl/99uRGGWRj7sKAgvWOtBVzycI29b8e/O3D21xobm5puVtReLeUQLSffrfZeq6K5fisjDCh1TRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S5M1vng7PZ+jePhiKKGxdoAcG5blZS4w5osU3jAdNhI=;
 b=S8oUAWEBr7p19J7tMwIFg7x8oaEKn/qarRWrMZdUPRhTS3Hb7AbEeHXiu5SE7udd1Icon/D2ySDl3NjJWyujQXJceeNBOwQ9WBGx0LYj4+Vh3AfKqV56arwNGDbz+cgj1F528VTncPYJ2gziUNSK7+3tvW11tt29tQpJcq4QGLC9bGVKW3QrMXBJ8WQK4vixh+kxnldfvd227spBYEapQPvcRBASWA7q69WdHT2+2MKNl8pt9pgEyaUxhLjIDB59t4pcXl/lW8J1YekUIqZUrfrdJdAsLWdcPJNnm05x8+nVLjRBW+/ohGcQvdrxyPup6SB7bMBDOOXABvCy70bvgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5M1vng7PZ+jePhiKKGxdoAcG5blZS4w5osU3jAdNhI=;
 b=hVJKySzA6Vo6RXEgGujh89hpaw2F6ysh++ZxBpQgMMJMkRZpqyKbHIu+h3FB2cLwpXhJm3eOpOgNjFwDxTCCCrcnd31FafZfdqg0SWmaBeJAb8AMxXoPdTtJyWUlXXTWOQqfuAZ2HUfQsw0VGv3K7gf6qMyVJq+VTq/UkCeLJVElbehjrkgilZvGOBRLiP4lOX3YUZYVym4AZAAWF7+ye32yBahStGvGeUuyWd5s1WZdcCBUF/m9B+sBimrvXomFvkOxbX3LU5NTOhrPFGIhkIyq/hrP1Yp3UsSbWRB8LMmlUpkkFXmcdz6QzohLzNC2QlnuEn/m9M+4egA1Q1qk0g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL4PR12MB9482.namprd12.prod.outlook.com (2603:10b6:208:58d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.17; Thu, 7 Aug
 2025 17:04:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 17:04:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/huge_memory: move to next folio after
 folio_split() succeeds.
Date: Thu, 07 Aug 2025 13:04:34 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <30335873-106F-4154-B035-4310089849E4@nvidia.com>
In-Reply-To: <20250807084502.vizmxfum7knsr257@master>
References: <20250806022045.342824-1-ziy@nvidia.com>
 <20250806022045.342824-3-ziy@nvidia.com>
 <20250807084502.vizmxfum7knsr257@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0934.namprd03.prod.outlook.com
 (2603:10b6:408:108::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL4PR12MB9482:EE_
X-MS-Office365-Filtering-Correlation-Id: 86a360ec-00b4-409e-41dc-08ddd5d47d3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9MU81ZeOmPfSj5fako2LC2ZcBiORcMa6kOObsX3nwphkXsAz6E79JTni2AY2?=
 =?us-ascii?Q?PHcON0Y+F9RUmOAR7dtvvCPmYeA7pg0e4F/51VYLOlYakz1FIVLv5caVwqxB?=
 =?us-ascii?Q?6PkDsgxO4fm7zFSyQgWYH/rfLKOyT1SnMbEVquf97ZDG4ZcjTE3HEExb84gp?=
 =?us-ascii?Q?+fbKG9BG1F+A9QhqX1/sTe/7mrMTgCRNBGlzwCs4W/EIuV+1JsKPze/MkyMj?=
 =?us-ascii?Q?JqIflW6xmdN/E5yKJC2yZ2O/uNCr2s+pK5X8V8rpXw6U84HDch77070SGdhw?=
 =?us-ascii?Q?Z0dZ6eUcVvzqBC+JmIRs3Qa62gjXPjOfCZjO+RVCHY2hHB+4IwAW9qYZjdQ9?=
 =?us-ascii?Q?G/HT1y8mWs5GdPZiqcfOtwYvviSIgo60rNAzGhtyCNy9bvDKsP99fuZbibb4?=
 =?us-ascii?Q?M1GLCey6Qh/IfcZjbgZX9byhgynVkjrfo5pEIEyWUhy+vpbgNnI49VmH59Gu?=
 =?us-ascii?Q?kKUqJvclufTMQXp92pAyBjLdARXE0j34QJjRmqtoICPaFCaRNtQv/s0PSpKt?=
 =?us-ascii?Q?0iS0iYXyU9/kRGhasxqrgpbqFJiOQYLkFkzZbAAXX0VQ3HE9puntmlclA4TF?=
 =?us-ascii?Q?fjZgHjjmWB9al6NUbWV7yaKz/AHU3RNUV6lbLYEv5auaItfXpU98/1q3uLTE?=
 =?us-ascii?Q?2woCF9971GPZsqNC3sfVSVLG5IDZj95EcGMJr9+ovP7qaQQcWFxAMNTi3Vp2?=
 =?us-ascii?Q?Qea4DxrCyjakqQ8dc7UcFJKQYPyc5ydbXBc4NxZF3JW7bGUnBqnwo9cd+gv2?=
 =?us-ascii?Q?3df31iix9hUjXBTc6FQbqcqxdR3WkEhFCjO7LlZzYl3GRBuGXXvA8yeD0mJg?=
 =?us-ascii?Q?C9+q7xQ5nLyuTIiFww4m5ww1QTslGY4AAWsDrjKitkvxjhOk2sUvpCvJR92E?=
 =?us-ascii?Q?Ebc0cZlPSquHm/dPRtlSnDHesZd1c6a8PB6deCrccd6LkvrtrwjlL0XFtU8g?=
 =?us-ascii?Q?4ngJInMgRetgP3DJEq/bwFvufbs0TqunsIIpvdVKeCEcpHNE3kMbv9DTtYS0?=
 =?us-ascii?Q?3dTE0Z3ig8xR2LTqp82ngCMJ9NZK+U+YBI6jjIeHEg+17VflVesDyuxS/QCn?=
 =?us-ascii?Q?2ZAh3szKCXxSHxUDtWeE8Yc3pdVyg0RQRvgiwMLSjwgPD1NQpdezcxMZO9tL?=
 =?us-ascii?Q?1IGPSldd9Wm1SV0LS3oB5TXZSXg6tgJXHLEdyPcvselKdCewRe68TYF92cvX?=
 =?us-ascii?Q?ipda8uuGfbnA7ODc73Im1ofpFlR12BB1Fs0Edlov+2ReO40IkL4CA7dk69Mg?=
 =?us-ascii?Q?RoTNQ1w000DbtsU/cHHMjWNc/4NvVwJYU1zTOttrxOuZh4lCEAEkvcqKt4mh?=
 =?us-ascii?Q?jGv4dFcnhF7nGgMApwgT3CPvZHU+FLys0H+bdblXX8P+5CEy+JzQl7U7S2QG?=
 =?us-ascii?Q?xunpDB8tQd3M3L3wi33o8aDZyLx+f8240a67nIpvOB3CJ6XYORQ9UDJ3FALz?=
 =?us-ascii?Q?y7Q7xOkDJhM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?STaQF1ptFm8AtdYfZw5ZG7aUQdCkZTeKRugMTKZaP61k+ZyhmwYFe1O02txZ?=
 =?us-ascii?Q?0b2zuDB90ugzh5Cz1uJH7+K7C7i3nAW/g88R73OSVDHcm7SWRsczuEDz2+72?=
 =?us-ascii?Q?hXDQdjLcUL+nCILRAlTW/3XDqLJ8R8zdm32WAlaNZfeQeP0y5Bd0nzwzXON+?=
 =?us-ascii?Q?YlAc2rYzk7Ou783LhZxRiPf9yfHyBeHzhs25K/56r9OPpi3Pr27zniHEzHw0?=
 =?us-ascii?Q?B3zjC4yAhrO7M9RqXFjKGD9s6rf6QIlS1n3xbyZ/BJgtAxHjklrwTJ1C+wnx?=
 =?us-ascii?Q?5LVIeBkoWAYLNhGxM2d2UpSic7HSBQhM+KzdsZtrhOduNTqdOQJolYMN+l8z?=
 =?us-ascii?Q?AuiK3tY1Cjcf7MicH2bpvBh2iDbH6NmvH4S4u3H7zsL9SxoxanJMxVZBHK7B?=
 =?us-ascii?Q?/6dFIzTxwksuXev2znOF/7EwZUxLFm8bCqgFlYaCN+ut5e2deeEXaIh5IzPu?=
 =?us-ascii?Q?0SBxueOCmhVHTNaWaZNi/jw1trObms2OLNsjhYvfuKOoUnd97ohYGPSC1nXM?=
 =?us-ascii?Q?T1fF5UOQoI/eb/Xv00ZJpRLg/6XYWy/mYGg/wiMUpWYm0RNUaRuI+LJVIskK?=
 =?us-ascii?Q?eyg7kuPd53H1FTjHX74j8lMhBzQmYwbVsKoojuqtua/XzanDd5YnKa2MdF2I?=
 =?us-ascii?Q?lQZ4w2JARek3T4iJaCfsqKt0n8In8grS+Yml9Y9P0ntITFenMzaCbcXU5O7C?=
 =?us-ascii?Q?/6V6jZoxxP1GoftHBLpRKWM6v4uNoxm7G8jJmnuf7trbXAnaBqBHPbWm2DSg?=
 =?us-ascii?Q?4896uQJgvmlk62bE6UzKIb16xmu0x+0MR9jhSzJeatG2b9inEu9ZUuKXc4AN?=
 =?us-ascii?Q?ieHP80i69fs01zbDHCBoLxkcgPQVL88PlTfph+/bRAEE69NXtQaA/rT1V/Qu?=
 =?us-ascii?Q?+yuoza5kdGF2W3/Lwxk+8KTZ/JQDpaWy0jQ9GgAw9lusGyYipPX0pOxVfbCO?=
 =?us-ascii?Q?n370vx7FJ1B6BmpWFQTK8/LIwOhSplKc5vw5PbcMmXIhzgxDma5DXqhHkLb1?=
 =?us-ascii?Q?vMZZbLKbv9MUsDbxPYNaSrHcOgBWyB6+bIIJqbojY3fESC2YgY/ybPEm+M07?=
 =?us-ascii?Q?+/0FsJTy2FN1VKsY/3Uty+ECty8bIPWYsRF+I6wZUYpBRfwEP7r+zBcDo1i4?=
 =?us-ascii?Q?kOb8GMgX+xX4Wi89R4eu3KM3Yx3IDtgaACNBZJSyLWfx06iXTGX3YqTRzboH?=
 =?us-ascii?Q?9pTG+yuskDogRYDSwOj0BIpns8zAenCXNqAcH/k/9NE/UYSTuVDXhJWIfKOA?=
 =?us-ascii?Q?FWFJMqz5lKiEFxUbhgLmE8f5oTFvfqPqaEQ+n/wlGWUqOm1Y2CYeAtxIfaMS?=
 =?us-ascii?Q?CrW1TuWfNViSsqrqUNJOU8twWjU0XuaNpN6g2YDAatLTdJB4atzT/39nJTT3?=
 =?us-ascii?Q?wiJWDA2NCyWP4QDbisoUjdB/MYC3fT4UOn4IupF1MgEImtzDKFlfRShlfCn4?=
 =?us-ascii?Q?thm8yJZrhbKUT8hSTUEwwDiBXDzN1DFFo8EErUdbYxcly7wU3fMdFJk03UGl?=
 =?us-ascii?Q?vrhll2DOJ8UzWfSFfC1BQhRXNK7jTCq4mjAAqlzUlxLnqrfHZzP5RVrCkyP2?=
 =?us-ascii?Q?mV786V77k12cTKvz6a6oL82jjhOE9yiE2A2zgvky?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a360ec-00b4-409e-41dc-08ddd5d47d3f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 17:04:36.8664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RCxq57M7geJ10hII5xW2kx4hni/nMa+Obr+KiOsFoOXODQwXTSwALq6MFXGNflk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9482
X-Rspamd-Queue-Id: C2CE2140019
X-Stat-Signature: orquw6t8mwcb88wnxrn1wos4e5jxekqn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754586280-689433
X-HE-Meta: U2FsdGVkX19G33xJzlDubPDwOSFog0W0akES1MksoEtjlppsgtSZY2uwCW5v7bbmubbiBdW+mEd3yf7Zl2DpKRSYkIbbiYGk5DY+baA7zMtO0R+Jzpc+0/wA7QWiaQ9hYWnd4n1tx5PmKzoYdnLhcAaZhg4e31fljzcnyUTo76fy/Y/kLeDO7b5IZAW6PxdG5Dhd2bdSCY+NqkZFAQXsThzAMHykA5siO2HOSWVwfPoar/W+0Ai4HBAcFgZBg8GAWIj4bzTns84gRjRMamfJ69WaHqa2zjF5GmKhMzFOyNRH9ELhOr9GReyijnIC81G/n0OBvkzpgZhgyOGvw66aoLUHASVkGXF1E7U1D7fcB5NKUo8dn4RVib90b+Cs16VL3DBdefjvLtiZGazzQNjlHRYqEewJTHgbp9YQazp0hPuu/yyYtr67W26i29iP8oJhU2uFgo3AOeQquH86PCCoRqryHE341TZLrLbj7p8saLfM0hWt6bcWPtDWK+Y9hlfgQSz1p3OfcRcaidP92E6L2gx9j6+Hnb7p69V4jt6J965nyNOpBeI7yCqaCT0AIy9YQuF8O/7EB1ncf/a6z93NJAj75v/3nzKbjMQh191jb+R7YWI1oRlSj/rnClQZobkaT+/yXw8eFyKoAYIjgtp2385mTgcPmD4u5cCDahbeDnNX2+Z7fjy7jcH4wrSclw+A3avwkQzzUCfyYkxmMbCsn+/U2r4Qlsy0nFOfIkbKMBeOZFXg5L2U+qpzandOOvyILbDlIIfnHtFEPKHsmcjzrMy2cnEuNIdIqaT8yCEAe/ChZhM2Y/4T/8P7AMPLHJwc9XX1bWS3kHk4R81mYD28yBrO8Ini2GMJgrtpxjUBUbdsER9uHl4cdDBohQEtPaeXTipBkgv+n8m7TkorGi7EqJ6Pu2H/8tM+Pj/r893tiAWdmLsUvrLXT74/JJ22QXJvzwgnuW/j41sm6Ngfn6t
 enr2jYm3
 v0EBnsSd5WUFm7KY8Yx2d7QbBc1bgnrR5QV4GyO5ORDtDOF1/F8qLB0DRtlAZ33g/jYLnlNtmyO5AYxN23425xbbROHKc5q4nEu2L0cbGTPuW7tFGHTZPaae2Xmpa8TRnd4VOyhQ6568cwgLpQJKMPsFWKPiMagGWQHmyxgvkRFaJGgVw4Dh0H/5IjwvTFmZbaI1zwoYS4t/i69sjRMi+LnSUGzU39KSljU6HR2Eswmjkc+rdWMI0AHd61wuuzlVMVDIIJyIrifQ4HGe89w1cdtyi64MHx4vqtdhLZjxcohMV33vo6UCKRlyf8Pv/CmgksPyTsu/OrAkcfLv/ukezm8zWdDDvKSjC14eG3InuJ6rfsVxSq+lTBgkDt88f2M4qSI5rMww1wiHyBzydZsgolnUP4zHbxDtLPexj7LA1OPFcUZgIa0wlWD3QIOA6xYuLaLITWx52UEY9HANiF4dxLfuzSiP1SmerGln+WG8nBuRh4eGNXleEpvQzwYQz9oD6+qFGX5atZGW1+1PEs5KI3ITt//NWCOGy71TvRzv4nk9SqIc5vuw0CtdJNcvw/OTcYH86jK0/MZCt/6nh+85pv/3fWZWw0SZfoxFI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Aug 2025, at 4:45, Wei Yang wrote:

> On Tue, Aug 05, 2025 at 10:20:43PM -0400, Zi Yan wrote:
>> Current behavior is to move to next PAGE_SIZE and split, but that make=
s it
>> hard to check after-split folio orders. This is a preparation patch to=

>> allow more precise split_huge_page_test check in an upcoming commit.
>>
>> split_folio_to_order() part is not changed, since split_pte_mapped_thp=
 test
>> relies on its current behavior.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>> mm/huge_memory.c | 18 +++++++++++-------
>> 1 file changed, 11 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 8a11c2d402d4..b2ce8ac0c5a9 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4341,6 +4341,7 @@ static int split_huge_pages_pid(int pid, unsigne=
d long vaddr_start,
>> 		struct folio *folio;
>> 		struct address_space *mapping;
>> 		unsigned int target_order =3D new_order;
>> +		long nr_pages;
>>
>> 		if (!vma)
>> 			break;
>> @@ -4358,6 +4359,8 @@ static int split_huge_pages_pid(int pid, unsigne=
d long vaddr_start,
>> 		if (!is_transparent_hugepage(folio))
>> 			goto next;
>>
>> +		nr_pages =3D folio_nr_pages(folio);
>> +
>
> Could be folio_large_nr_pages()?

Sure.
>
>> 		if (!folio_test_anon(folio)) {
>> 			mapping =3D folio->mapping;
>> 			target_order =3D max(new_order,
>> @@ -4385,15 +4388,16 @@ static int split_huge_pages_pid(int pid, unsig=
ned long vaddr_start,
>> 		if (!folio_test_anon(folio) && folio->mapping !=3D mapping)
>> 			goto unlock;
>>
>> -		if (in_folio_offset < 0 ||
>> -		    in_folio_offset >=3D folio_nr_pages(folio)) {
>> +		if (in_folio_offset < 0 || in_folio_offset >=3D nr_pages) {
>> 			if (!split_folio_to_order(folio, target_order))
>> 				split++;
>> 		} else {
>> -			struct page *split_at =3D folio_page(folio,
>> -							   in_folio_offset);
>> -			if (!folio_split(folio, target_order, split_at, NULL))
>> +			struct page *split_at =3D
>> +				folio_page(folio, in_folio_offset);
>> +			if (!folio_split(folio, target_order, split_at, NULL)) {
>> 				split++;
>> +				addr +=3D PAGE_SIZE * nr_pages;
>> +			}
>> 		}
>>
>> unlock:
>> @@ -4438,8 +4442,8 @@ static int split_huge_pages_in_file(const char *=
file_path, pgoff_t off_start,
>> 	if (IS_ERR(candidate))
>> 		goto out;
>>
>> -	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - =
0x%lx]\n",
>> -		 file_path, off_start, off_end);
>> +	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - =
0x%lx], new_order %u in_folio_offset %ld\n",
>> +		 file_path, off_start, off_end, new_order, in_folio_offset);
>>
>
> How about move this part into patch 1?

Sure. I missed it. Thanks.
>
>> 	mapping =3D candidate->f_mapping;
>> 	min_order =3D mapping_min_folio_order(mapping);
>> -- =

>> 2.47.2
>>
>
> -- =

> Wei Yang
> Help you, Help me


--
Best Regards,
Yan, Zi

