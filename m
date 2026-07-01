Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50CADC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165FC6B00A8; Wed,  1 Jul 2026 10:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13DBE6B00A9; Wed,  1 Jul 2026 10:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005D86B00AB; Wed,  1 Jul 2026 10:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5FBB6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:34:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 502BC8D9F0
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:34:40 +0000 (UTC)
X-FDA: 84940453920.12.FE568EF
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013018.outbound.protection.outlook.com [40.93.196.18])
	by imf26.hostedemail.com (Postfix) with ESMTP id 64A76140006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:34:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AMlXsmfq;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782916477;
	b=cxvn4SD9L5lDkjbeGf+Mv+RsXQ/GAfbpUG3G1D0pbHZWeVbBQN+RAzuKX5+c18VvhYMKJr
	l1Ek6+F8cOFgJkB+vZFPIRlBJbj/+r1kzt9/Rgt4CUZi2lCtDBP3OhSY7qVqyzp3dZP9mt
	pxTPy0FnvOsDPOXP5pmSA/Yp8L7pmqY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782916477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i057tm060UAKY0NZfnO872ARzyTPyH7TvJWzD+aMAzI=;
	b=zTbAI5NmJ8/FynhnhS7/rMrdtmBFo2IXAFp/r56v0vsFkTo5lHKpRiaWP6gQfRx2M5zB5A
	5alI8p19d+/pEuXYmaptTTGtkPPZBBU6IULvIsrs8OReHQlWGdH3DQi0VkGtA81U+cEbIz
	zYNO95BUFpXF2XBJIN93bUorU+0knvw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AMlXsmfq;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DKqGi6SZyyz3nF+3jCg62AQpIe4IKXq4ohbvIMWa1ik4zHxJheUdW/DgeHY/t1iDd1h6wbyWiJrM93X2exNZwRubQDE3yXBxk41q2wVV3hPmWSOE8lv05l6rZJM+ZktzC3vzRCDUveFb/fGAXiqUhvqaK4VNChfdvAH/E/WPjXica8RGKF8RdxTARZ1RL9+n1PS/tSOgClKZe84//XbjRjnZVA5R2vpEPNXpPd60WIp3R326qAIYaTjloAUfd3BU8Q4rR2NZC+4ux5cvO7PkSd7nhqj7FO6hUc0bqSYdU0M4TLm+hQ7GXwnaqll36RNz+DICtnYxAbAr9k7zNmBaTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i057tm060UAKY0NZfnO872ARzyTPyH7TvJWzD+aMAzI=;
 b=YrLYSc+HgFNz0fPA8kRU+EBJkC81q0cXcjkA1C6fX3bQT6YbRpbsVLVSCMzmBvO3menikAOgRH2Y7vL7ji6QkkNRdckTodsCcgI69WuwbPoKZoVBUxf0nmCKgvzcN4PBKpjjkB/k07FKC9oAN2ntWY1tqZrijWzVoM5e3/rzl7B17riY3a7gmRYgs/y2v1vMvc7zeBsgJdYbFawSWLsG7EVT7cksfTDj2TlrbtwgUAQHhq3/x+RhV/jagwMFg55F93s5yOygNld2R2/kMENjno6An4Ng5yT7W4+ngybOfcWg3giHrKcFXL0HLkt/QP7k1AggXjB1v7dWYwQg3SMDYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i057tm060UAKY0NZfnO872ARzyTPyH7TvJWzD+aMAzI=;
 b=AMlXsmfqESIJo+s0dHY393TRmstRYZZQoIdt1RUq4TtHwRNWXIAytMLDLBRACoOEfqLasJsqK6jNIMoBp2As1xwgmgIG8e7GKwDpC328UUg2qlW+hwsaSirBqOBtQM7atrsjcjCqc2M4ryLg6Xef9iYAuyzDgVDZwZ13H0Kt3vrHsKOUrcgC4hqEAU4X0KyHYjkFyMF26NH7N+8HKOKOXBCfHWkwCJjxP3f389EeJQqrBeM6adnFtHFREk46kHy1fq36LG9c/ceAbpe+w99FoWKxd4g2LFoJzUMF067bhwJbB/qkj/1gxRLZTltxTm/DigqlwmXGm0Xu2TJmDu27ZQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY8PR12MB7634.namprd12.prod.outlook.com (2603:10b6:930:9d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 14:34:28 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.008; Wed, 1 Jul 2026
 14:34:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, yang@os.amperecomputing.com
Subject: Re: [PATCH] mm/huge_memory: set PG_has_hwpoisoned only after new
 folio head is established
Date: Wed, 01 Jul 2026 10:34:25 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <618F067A-E2F7-474C-8871-B6D57554CC7E@nvidia.com>
In-Reply-To: <20260701134622.3152896-1-riel@surriel.com>
References: <20260701134622.3152896-1-riel@surriel.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN1PR14CA0021.namprd14.prod.outlook.com
 (2603:10b6:408:e3::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY8PR12MB7634:EE_
X-MS-Office365-Filtering-Correlation-Id: 903bfe97-cb7f-472c-a0e7-08ded77ddadd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3A2TBtdmM1Wvbz/yMII6cNl4neMqaLzY4P1lrdC/v2beL7RRVSx5VqOGzjKHGN2CC9qpmnm0YoRmFzjAI0Aqj3URgxt5nhGX3HZvVmuooMDt4K0GGPHZzVA6A7Oa1P4jaETZhZyTwwMvTYDnz3rUKlWoZ6AY7aDWuZdS+PeWx01mOzGPhRRQSZnElz3zzRn4/8EIlI1AfugVMq8F7e5/eMkdGy4g/h7F58inoEkemBk/QxnWq+KHnw+svgUFJNbhY+altW5P/t9nYWpAZ59fIv0PofYQc3VKUMu0qiv00pnbkZkhRDePjcW6ftJaeM3yfCpNTXEZ4c/EnxJmyYFuQbB3YT4+E1uFJDwcmOZjIeWp/oXGsXvtaA6m5bKHxiyRV1Tyzt8KJThuH1l0nl4UgYVAhDpsVz859ti0rdizxaNrN7/G8ICFYUbzdqEON89CnP+o6VE638xnalT0pqKJ+WG/sfyM4pUvxnSTdNoeFI8Olmi5xRJISYvMakSSgqEF2XzoKZmZHTlkrPHX/Sn614N6fHVvag79mHvYx0LhhKbLdYWHar15YYykpGb2AzA/p7BZhJw62gcRZAwJ3q9m0b64qEU+rQ1pS6k3VG7ORGgi5v9PnTx5sHLzgqRCOrMOi8xu3RJd02lxbuykJRdbxA7HsXb0qF4Wj4P9POsn4Sc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Bv4XOSxs7ZKTLRcbu1UO6aUeeWvz1p4FYncUufnaD7ngbwg88jRI/LZa4Unu?=
 =?us-ascii?Q?lR27mzIDZVBnOOSeBoUnKML5gwbktwmOZLJwuCS32HNUwgeBgaRBsYfhmDF6?=
 =?us-ascii?Q?Lwv6ZZSx+hAOndhlvIBFsRyE/Pp0I8y3lwm5x36fEw63e+9KM3ygcf7qTBl6?=
 =?us-ascii?Q?LP4crGsuMkwB0dL3Qh5hVaZnYZvqhsa9vWTc/oMt/ZGgZyfTtFePiMydYhkA?=
 =?us-ascii?Q?uElgKFnaOaDIAwxeqw4XJpUJ+pM+Nxb6RhhWpBxK7iLmttAaUm5/ZRnrvyUR?=
 =?us-ascii?Q?QEHc/IQmTdZkd/rN75UZe8ttys+gxuLiuAsw/W/Sju2jM7vxlvZseEsui7Pw?=
 =?us-ascii?Q?a84/yPWUW5S6rUelVU1Hs+IIvNC2SYW1WDNSUcv4kn8mrlen/uLHlTDFfiDh?=
 =?us-ascii?Q?cmJXGieNYViwVhesXJexnYjSsKeSG2xF/sd/DvqIZ0QBun+YC+NndRq/hA1H?=
 =?us-ascii?Q?Z9AzMiyPGr0cZhEJCm8Hk9buELEXVWO+R7AqXV+evuFGyoYgr2+fHUmh3l+q?=
 =?us-ascii?Q?rQEv8cmSWgw30F81/JaWw1iQCJzPxl/9aP7iZn25P2mh77QUmXoboiEaWhlt?=
 =?us-ascii?Q?lDfAag0/vh3FCG9fX0Ibg6hA7ZIfE6ouvyQorygiwO5Ap48BtKgWz+oX6oDA?=
 =?us-ascii?Q?PQ/EH/yLNORiNjdkZ9QlW5boF6B8tX4sb5qSDz/4k51zcDc8pfmMCbMch69g?=
 =?us-ascii?Q?tOgN4XIPZ7lvTTwXzM82wCXh+D46APwq7zgbE+FyvTrw+19TNv7iWCyllmfU?=
 =?us-ascii?Q?JGMkeh0lvENSwIA2dy5Bye/8kqlvjKKoeOOlomgI21g0QVC2M7EelGgUvimr?=
 =?us-ascii?Q?sJCiFsWIcoSnQ8pDvcUAzoGoDLG7ZZfFMcTfSJrcCQsdn5bUNF9ZNBY8t4pc?=
 =?us-ascii?Q?eKnc6OaeXoEkUZkc51J5c/VfBMK1T0E+mzR5kIIW0EAUvdkaerjLCMi9MI+m?=
 =?us-ascii?Q?VdQI20Vwz9g0OghZqYhG94HLs6UztTx/hG1VOrqMZoURs8qqCZkjtiBmxC+0?=
 =?us-ascii?Q?/2meO1mQU0kwZmfCx4Ftk2ym6ouuY7/7mZlm9ZUCxyEanSSNAmwRh743qvA6?=
 =?us-ascii?Q?U1C2hOiF0JtSNQb6ItXwxiK6x9yR1/UVDa/Zs69Q1hYIIVhEIMV6zTNjAdQl?=
 =?us-ascii?Q?JWUgfkZbNBex9vGYsmZQe8TrkzQCG8Sst189aA4oTlmhQtKEf+bN5mGk58g1?=
 =?us-ascii?Q?Qog2JtzVKBDRG6ZZ8/d5x0jeSgj3J082RK0VEBlhHvuMFhP/STyDdB/wzSWm?=
 =?us-ascii?Q?tkmjxkjP95xBGxMAawvFWy6LTeLNIfdPXCxlIXDGedscfVqbwIVkgfbBwZ2e?=
 =?us-ascii?Q?QEp2satndhWHd1KM00jBrNdskk/Km+1qSaOOVHo0KEGygjEyVdzkCHM7KKrP?=
 =?us-ascii?Q?cV5k1vTPaweNAYgIdjwlDdYq4krJq1Vgam83MOSVkbVLsy87J+jguAB5ElbH?=
 =?us-ascii?Q?STbvhRXdFqhvES9tiZkgArLRKk0w+lb626QqYC5My17NU6bEUNeWMW+pjR5T?=
 =?us-ascii?Q?ZNJJB5S2KMFFZB/LIywR2zlCyWXBR5BdEpg2EzvzdNBQTAaRAoGy6aptfS2q?=
 =?us-ascii?Q?huFPLcVJlAhsbw6/XWht5n4sQlKvBxSsE3G8aAzzQtcn9gh1qhRjALWlXsZq?=
 =?us-ascii?Q?iEjUHh5MF8AebLI+O6g7iI0xJfxnyldfe/bPLsYXTPq2Jfhg52on+LvuVCRG?=
 =?us-ascii?Q?x3Fk/a1XpwVMJqDPKnYvPFxctS4k7/zkAoe2ZjplGDZZ4ZT5+O9zLZWhK7kh?=
 =?us-ascii?Q?k47j9Mk5cg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 903bfe97-cb7f-472c-a0e7-08ded77ddadd
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 14:34:27.7373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VD4Sxo/CzIyvv9Z8QpQZY3OvBwdzCSOrVcR6dnDIhEOsZO+WtWYsmLJJVwvx3snY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7634
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 64A76140006
X-Stat-Signature: 4eehqwt4j3o3zrgmaapyej1xjbzbin6s
X-HE-Tag: 1782916477-230665
X-HE-Meta: U2FsdGVkX197dbzUG9VZzwXWzkKXae/uAsQkoL75u/Pb9Mb3zoHRjAdFuf5Q5CdCohC+Fp/LLoq5okl4xkEESyEMIfvVPcxv40Nzcey73QYTnAlof7fY04eOYbW3Zqrf9/CXdHnvh2NuJ+z3Nf5+/mpnPveg/sq5M7Z9ySMMh8MQQlK6G+c0STcFtomwqOXGond87zAPMjsQ63alAtk0+ACcm+Ezir+kNJD6mdDmf4fktJjpl8NcHhwRUywdVI/oGfsv+tX0u+wE2aE9xAl+o8VUGfkhJu/uxgplMw57cpD7StBgx4eta4CjRGmPlJMstrpBoZcQkX3lyyc5mdyhDnHqLHmiRDOzzzJ1I97njmBqsHkSpm5LX46B6GGAwH6q4MX7uYNHECe9NNkAeolEtOrHv5pKr9vMZPQgqQCrso0Rm54ES/0FIV9G2awqSESOFU5zK8id4ePZp53EORQBVIotb019WThai9ttJwc2+escXLu/o7il/LH3vheNzsv99Kd3VEnHSKgXFsFsqNomDtUZ+cEIusUAJ6ge1twvqKyN4Dlo9mJ9QyD7L4xlefpGtO/oOlQMSRw+6lXH/yufqL6yJDWNtJghGH9JvLH9TB4QKAv7X81Atocr3PNZNtlQeH3UA4LfUuPwpLdupD4UmaRuCnTDSQoPaTXbooEvkqAXwJq0FJ5F6WkGaazX1440Ix8FWSyZL2/JWfrjR4a0oH3nNrzFY6ReXsa0ZhyRkUPv/o5UhccIbEZJKYEgb1N4K6ufjzCmN7q+xQ69Xhv20M4x6H65IKUrfQ2mZaq0bbn98JGoP1G7745MzKBDgCKt4/FAt+PLHVnVqH0jg3QHuPTMCMAjQJkc+FenEM3Lj3sgXvxCslU2Azj9gvye66ZjYt6OXxbD/xlF773PHUjww1/JGHz2rO30uHtdOF+My2RH5lm80wfjAQdd5ra1Z8bnR3VzfF710akEBH1npNW
 KaroAPyr
 XXvbZw892AHSD9pSHmUEjGFpvWcppQKVmKuoFriPXdk0o+jBxwVPNXigrhcNqiWJ//Y6kgm+8TRyKr25XUp12tDeqh6hw2RFsq1sw3l9iwpofnYr6D7AX9H0EI9zwN67YjuosC8T69ZPm6MfYW9JOH7J/k9gsTuCkmnnhUFpOM6gnHgwWfMLbwWnXFe6o3hnm8KOfu/ABHRTZOz4ol37vSNW5n8cGXuP+PtBxtEvoTPzWioVjmlWT7aCLCZ7JXrkZ7iT8IFsESp3gqaR6DaQQz04xSby0NmXn9qYE+9se+WS56VtQ/Q6wnonwbdN5hpw4LveL2R//iSqvWqfgHg+oJRW3/0+BW91DPNo9Op/t4F2duSEnbSetF3XqkpFCkVSINNQ5W34+UhIGHabSU9P6glR6j1wRnAn1QBBbIykGjZLY8uvjFppPgitzornhyQFqU66kMIAM/0B5T4DvOCrj/ws8vPZmGRPgeHP0kKoaWuHiKSRxvZYOFOg6Pgv/VdhVEyLpjIXyGw+yWUt/rGywZ8khLQgelbqBBZ4HOhvyD6Gvokw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Jul 2026, at 9:46, Rik van Riel wrote:

> __split_folio_to_order() copies the hwpoison state onto each new
> sub-folio while splitting a folio to a non-zero order.  It did so via
>
> 	if (handle_hwpoison && page_range_has_hwpoisoned(new_head, new_nr_page=
s))
> 		folio_set_has_hwpoisoned(new_folio);
>
> *before* clear_compound_head(new_head)/prep_compound_page(new_head, ...=
)
> turn @new_head from a tail page into a proper folio head.
>
> PG_has_hwpoisoned is a FOLIO_SECOND_PAGE flag, so folio_set_has_hwpoiso=
ned()
> resolves to folio_flags(folio, 1).  With the new compound_info-based
> page-flags layout, folio_flags() asserts the page is not a tail:
>
> 	VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
> 	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);
>
> At the original call site @new_head still has the tail marker
> (compound_info bit 0 set, PG_head clear), so on CONFIG_DEBUG_VM kernels=

> this hits:
>
>   kernel BUG at include/linux/page-flags.h:354
>   folio_flags+0x82
>   folio_set_has_hwpoisoned
>   __split_folio_to_order
>   __split_unmapped_folio
>   __folio_split
>   truncate_inode_partial_folio  (shmem hole-punch / MADV_REMOVE)
>
> Reproduced by syzkaller: hwpoison-inject a few subpages of a large shme=
m
> folio, then MADV_REMOVE (fallocate punch hole) on the same range, which=

> splits the partial folio to a non-zero order.
>
> Move the folio_set_has_hwpoisoned() call to after
> clear_compound_head()/prep_compound_page(), where @new_folio is a real
> order-new_order head folio (handle_hwpoison implies new_order !=3D 0, s=
o a
> second page always exists).  The flag still lands on the same struct pa=
ge
> (page[1] of the new folio); only the ordering relative to compound-head=

> setup changes, satisfying the FOLIO_SECOND_PAGE precondition.
>
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Assisted-by: Claude:claude-opus-4-8
> Fixes: fa5a06170036 ("mm/huge_memory: preserve PG_has_hwpoisoned if a f=
olio is split to >0 order")
> ---
>  mm/huge_memory.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
Thanks. It makes sense to me.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Please Cc: stable since commit fa5a06170036 is back ported to older kerne=
ls.

For the backport to v6.12, the folio_set_has_hwpoisoned() is actually
placed after clear_compound_head() and prep_compound_page()[1], so v6.12
does not need this fix. (Do not ask me why I did this way when I back por=
ted
the patch, since I do not know either :p )

[1] https://elixir.bootlin.com/linux/v6.12.94/source/mm/huge_memory.c#L31=
83


Best Regards,
Yan, Zi

