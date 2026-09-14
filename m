Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC6B2C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA9D6B00A0; Mon, 14 Sep 2026 11:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAAB06B00A1; Mon, 14 Sep 2026 11:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C25986B00A2; Mon, 14 Sep 2026 11:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FAEE6B00A0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:00:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E96A64016A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:00:52 +0000 (UTC)
X-FDA: 85212679944.12.939C9EC
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012012.outbound.protection.outlook.com [40.93.195.12])
	by imf18.hostedemail.com (Postfix) with ESMTP id 069081C0004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:00:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ehCCoP5W;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ehCCoP5W;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789398050;
	b=F09wENtdzeD37O6hrvkmvmAp4VJb0oYkz2XI/eduiT3EEbWPVM+y1xZHcN0E32B2LkLvnV
	1kCHrahjYeGvsLthMiQcF+Kll5nsj4fbtQO4X5MIAQj2i2du5uGyo9OythnILn3FyiQmnR
	wU8dCSqbRiRjpIsvxMPSJQBQtTRT0VY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKODAqXlUBNguKJ/OvO8Ga2oaReMIksDfsNsnyy435M=;
	b=kRugc7uyziJXBjh1OxnROrwe5FR1Lqovi393mYcjCfuiaOGBYIiyOvuyIQpIJBG3iBrjYG
	PUx26qTJldWOM2kV1D9F4SX+bmA6QrfqNY0WRG0rWXagcsgRpLU2v1pLCpZZ8B/7sCA2zU
	2oMICN3lrZs1JUNvcozlS3UE2h2fX2o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CS2X9Vg563O3gDrkK007qWXZsd3JS4rWak03M/VQf4JYe8tLTs20eqW9BsJFmrCtKgilyOkldAMXW6mD2stKvb4uklqt0CPUAKycI7rMEkOTKyRg2+IYxNks64tikgotzzTZkXEDm6Tc0/B4nq8mFtCKs7VtX86VEMIKif1mtt3z3RF5/y01Mjl1tQzZzhR8VwMMl3GfLv2asMmozEu3dx6bOyTyJ9fzCxVhFIQ3y52lAy5XwtkSzomXgPQfcfrkqY0E32gmcvHVEPa9NV5DWBSktwBz5CIOUQat2Bq0CSdh297fnmg7y8Zuu5nrTJP7B9JcpTkRt3v2AnlkrN50RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KKODAqXlUBNguKJ/OvO8Ga2oaReMIksDfsNsnyy435M=;
 b=iQZprqxahn3i1oHQ1KTkBJNavk0tvIOQ90dO8BE8NqAlAxjS7DY9Rd9TzpFEDfmxUXflKrNyKtqEVbxRxMrumaCOPHD+ub5RrNhjSeGFnYmMotBsrDKWXwUGM5kAYILKaPqBgNaqLet+Ih6OV7mhFissu6QkTc/M0ZeOKyTCiEiAH8OiWe5Ra2FhbbD8Jwcx+hffMRWqoLlR6cl+rEkx50s/NrKCGKmCBz1Uwb4JO+c8drbCjsfdJhcxX5YnmYdp8UlSzhPvQ04nQxhZD9808aBLpzPTQf9NfMSsmfLItRwGalID2nfs+kU3bXN8f7r7700vxun+OERMqljWPSO/cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKODAqXlUBNguKJ/OvO8Ga2oaReMIksDfsNsnyy435M=;
 b=ehCCoP5W6v7hsRoqFL4sWNDz4C6BxQ0edjd2pb5tjAzCBoFQrq6rxEfW2q05p754U+j+58EIBFzQsxaRHjNP2XKIEXzLakHm4hC8lQms6yqimlQ/5GJQOAG1Lj2ux8wz3BzW7BlPt7UfglTextD1Q/QBPos4B1S8OyyLbhogEHiG4fUSQ8P/yqovO+SMsJiOP9Jopc7dTIo6r1mW7l19QByLorhOV314m0SPX977mK0VULjwej/bB7TI52YHex0+MvhenIqY4l/GxD88GGMT3i5LsHkCjUSfW2YujTcqzzzQP3P7iraSq/cFc5OATf413WnzEtW8vAQ6p6RS+MdeSw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV8PR12MB9083.namprd12.prod.outlook.com (2603:10b6:408:18c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 15:00:33 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 15:00:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
 Balbir Singh <balbirs@nvidia.com>
Subject: Re: [PATCH v2 1/2] mm: refactor find_next_best_node to
 find_next_best_node_in
Date: Mon, 14 Sep 2026 11:00:32 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <34108CA6-44C2-4F63-B9EE-C754F3053B5D@nvidia.com>
In-Reply-To: <20260912030424.2889731-2-gourry@gourry.net>
References: <20260912030424.2889731-1-gourry@gourry.net>
 <20260912030424.2889731-2-gourry@gourry.net>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR20CA0052.namprd20.prod.outlook.com
 (2603:10b6:208:235::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV8PR12MB9083:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fa624b6-9bdc-4432-bfeb-08df1270ec2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	hsbmttQVoDkg2RbXRqncig22tfIPw+oN8oM2FZ6TbhR+48jeIdDAxvx5zf3DN31yvOXlkbFokdYY2CJS76ymaTp7/nYktnSMmZgHjjq9iZI3BOjOt3lHW+A/AeCCMnvsFS8BMxmYTyQnPGqh89QGvJJhJLsj8DjItzjReA8MQH59S4cc64Ex1oDW6R00xRYmjUMGs354M/uKdT9S9XXGJaGAuzBvs+ZMozLASePzj22Es09YNos//C8xf0ZaDtX4+ofef2uluRt54Fohs9kjKMJaBSz2CDCAo3h/FPJmgggi/u+nK+s3TExMt+YMVoP5e72jcGIIRnuzJ0Xs6yP+U+DzopgzOnPmZzn7B5MJSIRBx/SaaqOba3gXqjb4UWpXmM/ZvMmIOdj+MOsg18XYuds++oDLw53sAukL0gu39q/SibRDDDv7nBP3h7No3rdMVIkNSpJEryF8sQRJxbQS9VcbjtdR3IzgGeBtL3uVqPiuafjryym0KNWZJl7PEbXFFDehwjl2I1Dz80mmyb+CIol2FWs5po74LMlTgMrypoW+DCu23KniJVUDUWS4BUp9dsAAoI62zYwvXycuk8elbrfPSJLglyESNzo7PuMkcBxcp685mQNigIoVnFifj6ZIkM6fZg/b3OYDbTGBtzU5w3v4ySRLDKkIYu3+aT6U2I0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ddVDf+WNzyhDXvq2LWZkhUxS5ooKvTStmDdG/5jlDuglEBZT4DS/75nY9hof?=
 =?us-ascii?Q?G9rZPzqo1mzdREEulYURVpyjMqJ7Ub8hhItNjItaOwI4Nnet7Ibj3BvJE1tv?=
 =?us-ascii?Q?sBwv3OBZ7Aycz6Wv/aE0LYbWByZkp6+hM/dmK44DW64jYYwjXUdBSyH7rcnP?=
 =?us-ascii?Q?ZEr2//YYNC+CACHGdTtXkplMaSPNG5beePGCFO+iu5GGN7FTjdjEbPTMxGY9?=
 =?us-ascii?Q?Tl68Hhj9bin+2RicITKanl/hGBvnSCtu5nbRlLQ82wquqnzQU1HSxYzJzyOy?=
 =?us-ascii?Q?X6LdGlWgxxKvi53WCA6AL4SYmVlpIZasVHZEyzL6iyLAYnVNow6muKO174lR?=
 =?us-ascii?Q?F8cxtSbhAyskMNwDO4uhqLhzvMh4Ybcia+pdM3Vi9J/jOpAsMjUYqfKAA3R7?=
 =?us-ascii?Q?hp7vIYLwirBlV2wLoHl4k+yOEX/izvrntHFBrsIM/mQHuDVl/j9wQDfG//ta?=
 =?us-ascii?Q?aD+RTRZy5XkSg5HkwNdXkKI5G6OBmV6sE4Hh+CaKc/M8MyYd48yax8wClp/M?=
 =?us-ascii?Q?HVLJbmmvcZhDIUnRlLV5zHNO5iOf1u3zscksTqSofdyj7jiQfpmDvx8RJK6j?=
 =?us-ascii?Q?KgbvV/3NM4kD3+jsqjXZLHmEygeOu1gtg5k3t1td5zebaD8hmqOk3rWrpCpn?=
 =?us-ascii?Q?ebwBkFm9OjfQjVCTJm0bSV+vMrmwBkoaiW7TrfRUZbh+NTnqvetnBoIQctP3?=
 =?us-ascii?Q?folYVo4Ze06/xwipWiIU+tWUcwR6+mEAFG+oQLFRn+x4EokBR8JvFyMYS3hd?=
 =?us-ascii?Q?/9cVjp86V0dOk3O6NX6Y138Jel5bGQ7WbqsoNWbjUw3lQbbyaTWursK4+m7n?=
 =?us-ascii?Q?Ssh1UnJXNOcy+weCgOCxU67KtMUnLOj5ISwA6L8E3HZiOK6TIcnbbRkwlewG?=
 =?us-ascii?Q?Pf+LSPrAcWziBEi0l1zKajKjVbOtMEa8oGsyGwQG5uE4si4DW/6OcE47ommM?=
 =?us-ascii?Q?aekHtR7Qjf9/eRbFovU9X5cGZE6dR5rbXg3vmOvLz7fHB4OsTBpK/v6H4JzD?=
 =?us-ascii?Q?LiOgWhsq/w/i5/Ycn3kPpaB5yBcRz4lPvxz/5gjdxoZBWj8D1SoTZPFx1lAU?=
 =?us-ascii?Q?CqxUHmCO2XB70EDSaSBTA3esy9ts37ryClPxKtHNrEY4NlEeUIuZDCY/NNxM?=
 =?us-ascii?Q?qRJEPy6XbE8C9e/+Sz8EascuWU649fjP44R58lQKFzfzqXFswyYq6I9oHymx?=
 =?us-ascii?Q?ZJV0iHIp66lSlTw8eiBRHhp/QUQHKqSS5AQTwyCWkZtm9WPV3rw3/5/kKq19?=
 =?us-ascii?Q?bs7TNQASaFaFFDnf6SzOzBbWJEsfzPznLOsuhjDYexD8HFy/aTSmQXaIYG/S?=
 =?us-ascii?Q?FqvHKxxULLJv8qqSy1iaYNx0qaD7Jt2bubp2xB7YofDvqLpQ9WgvhuBDm99H?=
 =?us-ascii?Q?B6gg91MKUWiEO963j//wwNoiWXsRFwQNV8AQaS6WjBQpfWpJx1Hn6YHADJOh?=
 =?us-ascii?Q?Bb9hbtme4bKH+I8Q4pMPoKLgI21JbW8Ldh9TH+sINBd3oWJcBPhJprYS4Sxv?=
 =?us-ascii?Q?UsBq+rOIZ9gFQRQdLiHwPNAdD3U4NUYdp9M85lGTc+9RQu799itXgalxGVdp?=
 =?us-ascii?Q?FOh7euy2qtH5nzmzUZ5wmB4kXw1+r/dqZ8yQW62l8NLOV37Y3JOn2CsDyVVP?=
 =?us-ascii?Q?cwJy7BSZyV5EKfXaU35Zx/SGXVv5x+oMrdr5KWK/ogZeHlmBcHL1lpJqXaki?=
 =?us-ascii?Q?tKwFHgv7CxoEWsSx3LADq+915q2WDELDdl6yt1CcYQBOO1oC8dzyVwoh39/H?=
 =?us-ascii?Q?+JI76i7+Sw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fa624b6-9bdc-4432-bfeb-08df1270ec2c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 15:00:31.8914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f3HCzA5lD9xI/QDnFpoUisIAS+iHLQgwWdCb/Bt499RcAsjB+YN+NTvqfYmMdpN1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9083
X-Rspam-User: 
X-Rspamd-Queue-Id: 069081C0004
X-Stat-Signature: i7mrx38guoohni4zpx8t43qs8wi3d8sz
X-Rspamd-Server: rspam01
X-HE-Tag: 1789398049-11323
X-HE-Meta: U2FsdGVkX18L/lXJhyqaHsAWfk8cQzyWcWYwoi5HBiItluMSmWFzj1h5TUusJMMK9z7SWi2a51nFwevX0DbdmLQireu5yVPwzHt1kkMM1919a9mj9X1eQexOQFKSchUUKjqh3Kz4fTG0a+6s2XskEmiEA4837hEBkRzbk+NC13BAr33I9RMSWv2F8oPNO9kjL3dp2UHovNKrytHllwlM0N0t3oViRNMQtltr6dt3hh+Z8J30093Gi8OiaymTV81ksV/g8io0g2q8BmB1wJw6wOEh7XUYDcrHv5kMMAG5IB8YQlXhaIkBcy/MiY1s1LBqfKFkmMt6iMfbcEC2wCzc++rIPn7xEcDjUE1Fnfa2aObkIz+KdsjWFSHUvPdP4iS17r1mWJF1+uA1SwOSc4DDS26kdKrSD2Rb5UB6K2Wirr8y0Kx/Nn/1P3KTkDW7nqCb9+qMtP6ZVbhsK/GANh6vjr4nY+KDPtoN6DVKb8RoSN+lXwZ0ABwVm8IGA0JS6hEsCSQD//kk0SdEWshhUdc2t2jfSdK6jozj65p6eUMJe89376KcWytsJGXGN8e33loYbpVnvrJ4sCDvjs8bAJq+/YS0htofFGfR22tE9F6aqHi9jP8dqq1c0B5Z5dzNffcNujCRg2k5xiqEm/WU8h5vQc8dDGipWVm3r8l9yEcb5gbEfKSDaT5Pc4IVTXzXpqB+iUoCBsJ0b+cnaD9BWY/TYYznaeNIaZ4LQI4kHHNbh91eXaVxigLjJItauDeodJ47tRzxVNyw09urGGnYE5+zDPpqK0xtOuIsirMpQL6+mOe4Jga5JT6MsLhWGu36CX1sZFowvzfkuh74GUDve6uNwhplHFHikQQLQoo89FoFX0HeegrAKHPT/gN7hx1bLPa4gLi7lA9CukmqPc/xZ9ysBXCNBOK/+zkWxMnZcvqQhGU9vwFi4ziroegvoy0IiyQtEuxbxk7zYol2a8IcfJl
 yYRA6sQN
 G5FG7h3D+9nhLnE7ZOR/IRRrxD3Ee4k4G/7Tfm2lmncAi/Z/N8I8/ssTU+zitzgA04P+wdpa88GgqpztcTzpHYO78Vp4e5bV9fOGrkr5x+Jfav2LE13P3eQ+mbFjSVlSxGSBBqM58NP5dDkjOHuJ+na3luCy00m/HuzwDQoVthQ+wpH4w8Gt0ajhZO3sXBg0IJmIZExdfbQ/Wn2zt2fZn4urrxa3oseecxT5sWjK4CmPZmZLv9oukGHAWn0HJijAeeuipUSmQy3fwMgAo+OR2YI180TeL0Sx1iNloYF+R5KjgvvXKSMNFqFHksj+/agYksvb+lZ2bUBZhvv55iEGj8vKCm3JhJ6qUHG5B+tG5eqWwg0NJrqLQ9garnmhiNXhQ9/ojvaO8vLpdMdRkA/njCGFFGV5OFrTvMlURPrOfhVtyi1H5mFav3GnErQnrjhc+n4upYNdDdbD4i7UcSVYthvTpQFFx1GMGrpPPtK/0701gZPnlVBURrCEmi/IlN0k9XHmuuFvzBkJXyJM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Sep 2026, at 23:04, Gregory Price wrote:

> find_next_best_node() picks the next-closest node for a fallback list
> from the full N_MEMORY set. Refactor it into find_next_best_node_in(),
> which takes an explicit candidates nodemask.
>
> This enables building fallback lists with non-N_MEMORY candidates.
>
> No functional change: every caller still selects from N_MEMORY.
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Acked-by: Balbir Singh <balbirs@nvidia.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  mm/internal.h     |  6 ++++--
>  mm/memory-tiers.c |  7 ++++---
>  mm/page_alloc.c   | 13 ++++++++-----
>  3 files changed, 16 insertions(+), 10 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

