Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA1C1606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 07:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=b1LRQJb9
Received: by kanga.kvack.org (Postfix)
	id C5F526B0606; Tue, 24 Nov 2026 02:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11506B0607; Tue, 24 Nov 2026 02:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B261A6B0608; Tue, 24 Nov 2026 02:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 758C36B0606
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:00:24 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E9C2C1A0A9F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:00:23 +0000 (UTC)
X-FDA: 85469113926.21.8B2814C
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011022.outbound.protection.outlook.com [52.101.52.22])
	by imf18.hostedemail.com (Postfix) with ESMTP id 219901C0009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:00:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=b1LRQJb9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of arighi@nvidia.com designates 52.101.52.22 as permitted sender) smtp.mailfrom=arighi@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795503621;
	b=8eua6M0X0AI6wgU7ak+jGEVqUNJn5QIpyrH7IJMp6WzRKPTV7T3cuxNONsNscIf6tL2JaM
	mOB/irPYJ0cmJkozVY/8QPbCyAPLfzvveX0dFpOtFO8ibPaVzq02JrC2c0VS/DSeYXepY/
	ixxKaSNObv07J9RUvF1cEcUDUARCIss=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795503621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NJ3gv24UIjE0zVTLaH+kwYwWWQ1Au6Gv9wJxq/NKcpw=;
	b=BKHHBZhELHGGGhSUSXE0+1xzIdvga6oQtKLIClMruan2RIWpPlHXfcQKqeWk1QW1x1Dn2/
	AX/gy0td+3XEyOb7HsE94T18Irw/jnL3UC9vs+JGCSJPim56eCYsbAqrm6ASohawkcls25
	QZdn2ndW5JHI/mP6Tb1UPonX0AMoXpc=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=b1LRQJb9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of arighi@nvidia.com designates 52.101.52.22 as permitted sender) smtp.mailfrom=arighi@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rboXleRuPYOE8euTf7U+LZOeIII8L0ZQCKqY0Rw2NkIu+YP2DcK8y4p2zJgCByaL3NLp1Gjjb7u3VPlSrokC3LxiILOrCEQ4yOfDn5pBhdTKxK/Sivfio1U3FvCzTwCrWQRkrt5Ar8qksQcDoOMgUs4EN6s74mM8iCujNb9nuyRBAa+f9wOGq0y0T1kCNqL/lp7uS0/W99ldtkox+6ki8FO/i2Y1kY3PwrrsyVHzHhrePzlDnDuj+Co0MWs/FQjKuBgZxkHe2M2HzZVex8SCfkceOAUND/jErgvxJqqxHa4wy2/85gg1v/mUe78zicZrjfYzV2vWHop694ts6d+DCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJ3gv24UIjE0zVTLaH+kwYwWWQ1Au6Gv9wJxq/NKcpw=;
 b=oU55GPvxZZ7nf7K0Jul1QbEke1DwFF9sXuBYx9eAG6Zsg/HB4iFW4yLyt4PWsPeTyjSwMF2Lga5K9M1x2fvnMzxgZNweCFUEwQH3FVFoor2aFTDM0RfGSpbcFKfVajm3VbuXkSeyJSvd2BWmjtWhXvHCIdlDokBDiCahRu2QZ5P+1ErZrchu8vxsZH1gk/6TduhSjuiAp5jbgc4xEp/ylSZxlv/Cy3k669lw6/rsJYk62X+84iIfkXrqP7eYGLv/S4MHL4Bh3zDjAx7e2B8bGb3VqxVVp8YWhr8S1n1egDInYb18mZ4HF390G/FRUnuhRFQ8kWe4iPKIZXgB+QXPVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJ3gv24UIjE0zVTLaH+kwYwWWQ1Au6Gv9wJxq/NKcpw=;
 b=b1LRQJb9922O5rWBLlOw0Cf8GuWRFNoAiu72E8A7nyWKpnseCxEV3xmnj6ApebVotUbBDI/L05UsOLrtjbB4NERzpC/W2NqoSiczCpj9lOwBkV7TdO6mFYwXgoyUNGz64LoHU+CsYpgqtKYzeqlvgMfVlZDEPxnADiihBU1mxnOFIBo9EEloXh5F1U9wZ7jX7rwEkDSXXVR3R1DQAZRfP8BvMQs0CL8zqbErhTAPtX9mIW7HFZbhuulpk+u1Wy0nH4gNEJUxPUCSFxhbGGxWgVMJB+qOUh22BYzjcYyXqN8wJLM1WGYMNSgYtNguZdoDCj24CIALc6+L2LUsEXMB2w==
Received: from BL1PR12MB5174.namprd12.prod.outlook.com (2603:10b6:208:31c::19)
 by LY0PR12MB782425.namprd12.prod.outlook.com (2603:10b6:404:22d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 07:00:17 +0000
Received: from BL1PR12MB5174.namprd12.prod.outlook.com
 ([fe80::58de:822b:868:96e9]) by BL1PR12MB5174.namprd12.prod.outlook.com
 ([fe80::58de:822b:868:96e9%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 07:00:17 +0000
From: Andrea Righi <arighi@nvidia.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Tejun Heo <tj@kernel.org>,
	Vladimir Vdovin <deliran@verdict.gg>,
	Gregory Price <gourry@gourry.net>,
	David Dai <david.dai@linux.dev>,
	Balbir Singh <balbirs@nvidia.com>,
	Lee Trager <ltrager@nvidia.com>,
	linux-mm@kvack.org,
	sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] sched/numa: Don't act on stale NUMA placement state
Date: Tue, 24 Nov 2026 07:59:06 +0100
Message-ID: <20261124070011.2498455-1-arighi@nvidia.com>
X-Mailer: git-send-email 2.56.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MI3PEPF00008BFE.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:298:1::469) To BL1PR12MB5174.namprd12.prod.outlook.com
 (2603:10b6:208:31c::19)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5174:EE_|LY0PR12MB782425:EE_
X-MS-Office365-Filtering-Correlation-Id: fc6026a8-c670-4a48-920c-08df49f89896
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|18002099003|3023799007|261009223027099003|56012099006|261028144727099003|11063799006|261021121427099003|261026140227099003|261026121527099003|261102123227099003|261021123027099003|261022113327099003|261022105027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	8u6txuKhPNgf8JX6DFRNSOOFf63epoEGwHJ+yS80ee8v8QbMZ6hQqPQpxtj5ypldAE04aYXfUDBy4xWvbIe76aPc3Dvg4fuyS5g7eAubec44qK1cZh3WUKeTl38Z26lpb3Azt4lHBpfFYECD5oP0f6wYT5FL525oJ0cEyBMEH2LEPb5hz3hjkqMO4FWMv1lt63ILn937b3c0mqOLOKB9AeTxB5ii0dBpc4K5EDsdrdhntpdMzkmEgQ4pD08NXu3XMu0M5f5AcqtTisZCNQJPZ2JIZTADD9uagL7nqecpi3xsislorXBUDLYGMw0ysaI419ivHDXQDIEFjoXhq0ggYCy6RGe+uiqbXVFMVsN49Umbl//d+AmgK4zE+4BIZF5QcwHuux2WhHLpuWXnANzrdU9Go1FJVWLWCK3HE+9J6FB9o6az6EXULTGdJaL/6HYS2ZzWaWmpdL0Mj+YA07hl6shkhDJiJ7Ck+taq94Yit/9fgZG4/P7AriXQkhySrawEWY+JB8okjbXDRi0Yznl6QYaVXBG1GJ3y9Pb3bQHODddPm6Nkq/rfRuwPfahtVycLzk7B6EiqnIISdBZatZNcC94iLGazaqcPxsqmG+anHyelvlhwBW3F2KQ/rv29nY4QzJHUZ3zjwX2uIPzTG8GCUIB5+BJyGoS5WV+T1+56T4I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5174.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(18002099003)(3023799007)(261009223027099003)(56012099006)(261028144727099003)(11063799006)(261021121427099003)(261026140227099003)(261026121527099003)(261102123227099003)(261021123027099003)(261022113327099003)(261022105027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9RlIeV977MfF1q3WBoSCAfoX3/nAqOk74h3pIJt7UKDDUFo/+OvNyQvrOsWk?=
 =?us-ascii?Q?GL1vT9FvA4uX3E9tFhX/2udplouwGmf3BfjbJDmDcaMoV+5HVZzK0mV+Dgsy?=
 =?us-ascii?Q?znBOmi/Tr3bDR8+yNsdahHRgd4yJdsXegQZ5VHPznbixw1uRcJ9sd7zc6ey8?=
 =?us-ascii?Q?bitKj4Qk53gul8GxLevUwE46GhBlXbWvbHF6Oid2CofOBUIlTapTbTckJo8j?=
 =?us-ascii?Q?i71JVGjR+kfPA/HICucWM5RAHXPTPfm3YC7OaLayc9IiM/ZjhoRRUpVO1jnD?=
 =?us-ascii?Q?akhUHuNIhFk+0hZs9drM0HK03FTS1p8tH3N2nhBlWIcsyI+ZWdmWCtlYe04/?=
 =?us-ascii?Q?NmS3JcLItLUIWLdL/+6EBDGsMgZJj+DV7j/ZxuBWvbf49iT3CdgLil0Regw7?=
 =?us-ascii?Q?JzZ67Dwwg/9RTdN/l6DBNdyueYUC1XaZTah2qasDAxvT/l9mGPjIWxr7fFk9?=
 =?us-ascii?Q?HcFAc3OG3wTeqB5rJMZeH1M7VKjT1S9ZLf1rgt31BODrnqdbJbhiUIt7YiZ6?=
 =?us-ascii?Q?+cGKUn3KHu7b3m29buCdVRyM8Mbg+qPUDMp0t6JSK9dllVidZqqmBj1xa/s4?=
 =?us-ascii?Q?hsOhQTeMTv/23pX+zjBBjl9nk0TKGKsuSOPJ33THkfY8OzloGdop5zmDAatt?=
 =?us-ascii?Q?p3Zx4TTZOkwkZpm9zOjfcUgfeGF3Pv4hTL5amI9tHbgw/nANSr/jIwPv9dXw?=
 =?us-ascii?Q?uNgdekPF8W6AO1nEaSY1TpJpOUu5TYNoDu00FBDw+gpu7t+nlp3rLnAvn6a8?=
 =?us-ascii?Q?ciM0HaEL8+sL2hV/IRq4LwDdYDDstYaB4xA0qRi76U4/9yQi2iUfgoJRtoKA?=
 =?us-ascii?Q?oOg4n3pCY69uFSLqDkuuJh6qp0+U1ub/OMYwZirV5jyKtilP8e0XpiKZ6JgC?=
 =?us-ascii?Q?wAA/szcMgzJnFzj4Uj9R47FaGhYMuDdV4OgtN4ddYBZbpexs5IXwoHDok4GL?=
 =?us-ascii?Q?i6L6WsU4NwUxIPLzpEA+HOZB7jvsFHmipolhkLuDB0IegIDUXD7Q6LojRzWH?=
 =?us-ascii?Q?Edp30Cxzwma2Y4s7YxzvLxoNIYPm0Cz18ltL6AQQPXwoaZcvkGu/+Deeiz96?=
 =?us-ascii?Q?VM2fdmJ6GkyJRYFl7l+EYZNgKq7MiI5cbozwn7/99S62KYI1Xz0aOBuuOInX?=
 =?us-ascii?Q?0hgAjgmUyreem2Bfl4Hf/XxO9v2g7llqwmPw3wkV2yqdt8ZWi0SUVRpT3xSZ?=
 =?us-ascii?Q?TCRWtK8QJZJ/drEHkBtbs+pP9yktAXhVskQvjPyZd51J4HBeg2gtset3LBaT?=
 =?us-ascii?Q?BJdxI9xISJqg2RZVd9jB3rqeVCef9X/N07V1DhQFsAM06t70wDjZACdgvzOC?=
 =?us-ascii?Q?+QLn967o0kz/t2x7CZsebQhF7Vi1vmqyYv8M/6VEfipG8AeWTvcSiqQMFyj6?=
 =?us-ascii?Q?S8Ny7Lf239z8xPkKWL89ynKdHGk4qdCXlfGFcGOIgtfoOZdOJkr0N9Vf9PUy?=
 =?us-ascii?Q?BaCcdXKIsk2IEBFFUpFWFaAEIXH2XPB+TbpbCaRNO83woqdobnV1MiAXmBLD?=
 =?us-ascii?Q?ibKuaUc6fj1FGTSbKQJGREyJtCKKv0svSxMb5d91Mgfs3Ee16NXAwaKNfG5q?=
 =?us-ascii?Q?32NV5Xk95u5UYm/eYymcdDrlzZchn9zoZFK1G7CCwinv6PXoRC4rVgqNk4d1?=
 =?us-ascii?Q?M8mjyxx8HrrIRjw1ykRHlYINHe9ZBKRmeAozaEbMKAj8klsRaOp5YqTQRrF/?=
 =?us-ascii?Q?+Ydxt9pq/jzbROhRKvT/P4ndqQ8iH+8I6Sdlun9gpjw9vsHW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6026a8-c670-4a48-920c-08df49f89896
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5174.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 07:00:17.3519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gEiGiML1xQ7WyGxzHkZtDd1Pi2b8c0+/S/T6CJdUzFnrhjUv4ACl//Qyh2T3EW54mm7w++dyAkO4GurQGgeEAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LY0PR12MB782425
X-Rspamd-Queue-Id: 219901C0009
X-Stat-Signature: faap745smhy7w199ta3tixqnsy974jp9
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795503621-461399
X-HE-Meta: U2FsdGVkX1/hJDqrAHiXsqnRzHHlSIyw65ZTzJ1O5kSUce75g/NyeG75OBTY05mfVJZMYK1P6LRGeyIrh5gtW499xdsqp7k/IPcwNBjCLzmjFj9kNBaOZpn6mYhGNiUeMC3qC5Lhuu4TbYIeZwVh/gcfDMdlV6R0VEZO7Cj10FkjiH3QPTqtykxSIAw9DOZs1c9jRD/psorPRIPW7eWRDmf8OiCz9dkyHtRwegAwF62Ha2m4ur/20nTP7N4aKhn9w7HKQi7WO61RlCcw4vgAdxxHpGXW60kaYyz7rXWvCKG+63VD7BIOYZSkAu0MHN5HjLV8I9FBwvafkjOdsp3TrNxZSUcyWqwJJkyLoDHXAENPsWxeNWvzcf9hPXTeXvdGDL5iJo77OP+b9MYAS5DaVb14OnqjKoqwKBuACThNZlHnc33+CzUGDOo/oTTarGBMBC2RbryGzl/qmeFEYQbjCu2MagpcWacuVoPCfzzB1s6dQC/bmWFWLZeJFIJCkagj4K7AUH2DXN3kAa282nzkkIruO22fv++hhnehBVYyemLtlOt1htxAohivbqjxmAHA83fEn6Va1Y0LL3DWlsZ6pz3mInhe1DmFPXRuiWKJksATlRzIxVbrRsAbLRtwNyLUkZhkhnzZC8rZU8MoUJYyl5KzaAoAJv5jhzvz1knmyEx2F0DmbgwvLS7eoHwD/yD+QllfqHKz1oW5m7NnpJ4koqSd6imGntXZoowRPHNdVXVa7yq5X4gYx1sJH722TZKPE41wPGnXYituelFjNjY1i49fe+c31WXhDiCjehcmXUbVjfT8yaxa9G9/YRuii2DKApy3XoKHGh4sk9OX6S6ueQGh9FfGQRos3MmsPV3FjCH52tTydz0vrbLZ9lLFIQpDkJcOTgMDVxU1cPWpJB4hxuFYvV0/PW7jk9m029FPqC66x8E1Y1COpdiCYgmbObOMvY/ISroU1wL8v8y2/Ih
 OIAWdxM9
 +nHVdyGu4Wt5FHE0WpY75Q+LThhY+ei344XQv9Iom1qHNydl5GZTrc7+1qBHOjpnirvApW4kqAqHwle3bFgQwiw/mnIAMqPsML+I5awy7dDmyAX8Ap6XMPZ9BBcEm+ARXSQbsHl0LkCbwDdvyv7Wt74p6fEIh/KE6fCsKuwyXCZDskCjpj90SCVSeGCJRc3PXrRgfVEHYJz0TH0jlDTTbrvF88qOgQz9cFgBx2iA0t4LV15MdRR6W+w51KB9IMz4NThbIvRUI7fj03hGo40Q8V/3s9i2lxqyTJKv/o/EHoKuuxR0Yklr+EJVVACsuuBC1g3tz66YvrgXnrYzVmlZ9tmWoOnvHYz2Jsg81Uw9d5lbZJMJPXj45u9hwv4EXiuwAjMpkwZ/am4LCgidJwdZquSAgKXiGC3AmnAXKMj3Y2Uci9HZlmUbuPEZzQn/5KyHxL2e319ulXqnYODpp5pPKdIzVX1my7FdB3QUZAQxSJLinjumeJ+vLwioq+YWRP1H2SB49tc0nO3OlA2ScSoapK/wZzrUifSHW5Fjnzleom+l0Z9/64pLlAqU5Gc8cYO9fFTIfQpPiWiBoTuM32KLxw/ntfI97fRSppubLuu79/fPxjnRYlCutBC0Y/owhVW9FyAvwqMuK/S+kncQZ1ti5g2BNTTAFKe58N0yAp1hipWSs5c4mEakDR91Y5UYt/vewjcDJivX1BQB/X4JE/I6mbB1kKJDWFAggd0yASQ+SttKYHa3uRFHcvw0/M3DlxtjZi2Nxx6qXChBRR5Xuj3M3e51VePJ0xFQA7QDU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

While working on NUMA balancing support for sched_ext [1][2], the review
pointed out that some of the NUMA balancing state a BPF scheduler would
read, p->numa_preferred_nid in particular, can be stale: NUMA balancing
stops updating it when it is disabled at runtime, but never resets it,
and parts of the fair class keep acting on it. The agreement was to
clean this up first, and then build the sched_ext support on top [3][4].

This series is that cleanup. It has no dependency on sched_ext and fixes
the fair class on its own; the sched_ext series will follow on top of
it.

NUMA balancing maintains the task placement state (the NUMA fault
statistics, the preferred node and what is derived from them) from the
hinting faults. With numa_balancing=1 and 3 (NUMA_BALANCING_NORMAL set)
all the scanned memory feeds it, while with numa_balancing=2 (memory
tiering only) top-tier memory is not scanned and only the folios
promoted from the slower tiers do.

Switching numa_balancing at runtime doesn't reset any of it, and:

 - with NUMA balancing disabled the state is not updated anymore, but
   find_idlest_group() and the fbq classification in the load balancer
   keep using the preferred nodes, as they don't check whether NUMA
   balancing is enabled;

 - PTEs armed for hinting faults before switching from 1 or 3 to 0 or 2
   can fault much later, and still update the placement state, migrate
   the task and migrate the folio between top-tier nodes based on that
   state, as if NUMA_BALANCING_NORMAL was still set.

Patch 1 gates find_idlest_group() and the fbq classification on the
sched_numa_balancing static key, like the other users of the placement
state, and makes task_numa_fault() drop the leftover top-tier faults
when NUMA_BALANCING_NORMAL is cleared, keeping the faults of the
promoted folios.

Patch 2 does the same for the memory side: should_numa_migrate_memory()
keeps promoting folios from the slower tiers, which only depends on the
memory tiering mode, but no longer migrates the other folios without
NUMA_BALANCING_NORMAL. It also stops a task_numa_work() queued before
NUMA balancing was disabled from arming new hinting faults.

Patch 3 fixes the choice of the swap partner when NUMA balancing
migrates a fair task: the task running on the destination CPU can be RT,
deadline or sched_ext, which fair should not move around and whose load
average isn't updated. Only pick a fair task as the partner. Vladimir
hit this with sched_ext in partial mode [5], and Peter suggested
checking for the fair class rather than special-casing sched_ext [6].

To see the effect of leftover hinting faults, I ran a single-threaded
task on node 1 with 1GB of memory first touched on node 0, on a 2-node
VM, and switched numa_balancing from 1 to 0 or 2 while its memory was
still migrating. Pages migrated in the 8 seconds after the switch:

                    1 -> 0     1 -> 2
  tip/sched/core    184158     114703
  this series            0          0

I also tested on a 3-node vng instance where node 2 is a slower,
CPU-less memory tier: its memory is marked as soft reserved at boot and
then onlined through dax/kmem, which puts it in a lower tier:

  vng --cpus 4 -m 6G \
      --numa 2G,cpus=0-1 --numa 2G,cpus=2-3 --numa 2G \
      --append 'memmap=2G%0x140000000-1+0xefffffff'
  # daxctl reconfigure-device --mode=system-ram all

In both tests the workload runs on node 1:

 - numa_balancing=2 only, memory on node 2, promotion rate limited so
   that the promotions span several scan passes: the promoted folios
   still feed the placement state as before (preferred node 1, same
   number of recorded faults as tip/sched/core);

 - numa_balancing 3 -> 2 with half the memory on node 0 and half on
   node 2, switching while the node 0 memory is still migrating: in the
   10 seconds after the switch, tip/sched/core keeps migrating ~40000
   pages from node 0, with this series node 0 keeps the same page count,
   and in both cases the node 2 memory keeps being promoted.

With numa_balancing=1 the memory migrates as before.

[1] v1: https://lore.kernel.org/r/20261004072901.3579967-1-arighi@nvidia.com
[2] v2: https://lore.kernel.org/r/20261027041536.3317971-1-arighi@nvidia.com
[3] https://lore.kernel.org/r/20261027105056.GE2668564@noisy.programming.kicks-ass.net
[4] https://lore.kernel.org/r/20261027115410.GK2668564@noisy.programming.kicks-ass.net
[5] https://lore.kernel.org/r/20261002124559.10367-1-deliran@verdict.gg
[6] https://lore.kernel.org/r/20261027104317.GC2668564@noisy.programming.kicks-ass.net

Git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/arighi/linux.git sched-numa-fix-stale-state

Andrea Righi (3):
  sched/numa: Ignore stale task placement state
  sched/numa: Don't migrate memory on stale placement state
  sched/numa: Only pick a fair task as a swap partner

 kernel/sched/fair.c | 57 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 7 deletions(-)

