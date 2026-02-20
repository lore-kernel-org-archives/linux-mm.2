Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDADFC531F6
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 00:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D7BD6B0005; Thu, 19 Feb 2026 19:46:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0851F6B0089; Thu, 19 Feb 2026 19:46:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F8A6B008A; Thu, 19 Feb 2026 19:46:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D78C46B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 19:46:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76057BC3E6
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:46:36 +0000 (UTC)
X-FDA: 84462994392.10.913BC40
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010061.outbound.protection.outlook.com [52.101.193.61])
	by imf13.hostedemail.com (Postfix) with ESMTP id B2CDA2000A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:46:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UnPzSo9w;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771548393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNGla3EPjchP1bGq3rV4aRSqGWhqTv4q4Prc7DIIGcU=;
	b=lit3Ll+tsaW2/vnFGgM63G5IAlrxeSkvumHeZksV3cnZFKe79qXXj401IIkexgZMM7G7Dv
	GEaldaeYdCUkMwvsYSd/XTZYnvm707z6dbsMIULHFuNMU64PijW7ZVXDh/U+n74IJWAEsI
	5lBqCJ7V+vJl0F1LNVO+FcvioIyjtRc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UnPzSo9w;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771548393; a=rsa-sha256;
	cv=pass;
	b=e5b7fCqFWiaxcnUBsUnoFa3vs/VlK5AHZeMNAelgX4QvPHjdNI3c8t4cTVk889uba1hXUD
	LMfnMB5MSYkWhWqLYG/Wa2uxcQ8x2odtTI683HIAZWIAjKXGq1VpcDk9hpnXFxnvb4z8wK
	51/fTzk5mlSvhAqAVQauv44WuOB7OlY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F4rsDvUiahlJUOPVSy7ST6G2TqmCtWgaYqaYJpZ0RrfJn3WdbKVcxbhw4f1KN34+84n2oHzkCz+8bnA7B5F5ntNtNNg6+wPcxCAZ3fmsMkWaFHIKtLmBI8k/NPxSwuIkeFgudBPpUxT22IYzI5mlCcMLBwWGFlPXvC56b5uOjhutOTIezsv+O3qaaodosqugz2Q/ZT94teZz8uoSadJWpD0C45aQh5FRYCIKez/yHp13Sjdk207nxPSCrfXjrUXrLATyrVgoffDkgc+Muy7hgowv65mZGmPDKpzU1zw+n3dH4uPhnV+oiy57rPfvhW8YSKLN4b/ftatdzHq/ouq8cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uNGla3EPjchP1bGq3rV4aRSqGWhqTv4q4Prc7DIIGcU=;
 b=e+lr8dESb0SWjhwoqjvfAyBb0dD4x6emSRVZ2v4UEhZJhE5qfeyxSmHto3LBdYGYzls4k+wD7AYvg8h2k/8FJsPvbTCnrU9JqmRZ4PTxL56ySVe/bOY5NI1jadtvFTSGvPUF7t6itMqtIF6matr0LvXDINRnDCJLQFXJh51ZurThmtFX41a/5+k785Uz8uBeP43D1EwyiGZb4EqbjyZrQTrxXA+K4IcgemPMooilrHyoN2fMRXf7hlXAcNlv+FWGG/7LMd0X5xb5wDIzdPgpwr+t0pgk/3nIW7mvc5uniU9mtSEDicmPc/jEyDoVfQfjrf74g9F6L62fdTnGKo2cxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uNGla3EPjchP1bGq3rV4aRSqGWhqTv4q4Prc7DIIGcU=;
 b=UnPzSo9wtK+vN0BQPMew2w3BV6MtMKaIfTUte+Pv1Ru1ouFQToY89pK+MlNQbW/CK1EOEsu3p47DNooaJQjUpPzE8dcjdUZHg8ZXb0uoqDQ8oVQBtx9OacZxxmsOk5oHerjxnlhJsGkAnr02dfHni9CZFjF19J6046XAX2rWvQ6aiS2liPmD7qq71mqFF1jYKKb7nOzUX0zPYlXoBzJtaZOEa4dR90Ex+qj7w/bMDJ5eqUJ8iVC1rjsLoDWpR01vXraHJ7gT/INAcX7TUV+LZEgzCEuq+R6h5j/29GB5QJ/kf8Bb2ax8DEvlr5ykdhWQ/d28185uGs4plXmLKj8bag==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB9282.namprd12.prod.outlook.com (2603:10b6:610:1cb::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.15; Fri, 20 Feb 2026 00:46:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 00:46:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, mst@redhat.com, mhocko@suse.com, vbabka@suse.cz,
 apopple@nvidia.com, akpm@linux-foundation.org, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
 hannes@cmpxchg.org, joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, rppt@kernel.org, muchun.song@linux.dev,
 zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, surenb@google.com, virtualization@lists.linux.dev,
 weixugc@google.com, xuanzhuo@linux.alibaba.com, ying.huang@linux.alibaba.com,
 yuanchu@google.com, kernel-team@meta.com
Subject: Re: [PATCH v5] mm: move pgscan, pgsteal, pgrefill to node stats
Date: Thu, 19 Feb 2026 19:46:17 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <FEEA24E1-D62A-4378-9D80-04E8BFE6D6CD@nvidia.com>
In-Reply-To: <20260219235846.161910-1-jp.kobryn@linux.dev>
References: <20260219235846.161910-1-jp.kobryn@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0056.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB9282:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a8097c2-16d5-45e8-3cf1-08de70197911
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xAl92eCCihAuBrBITaqjTyxlA0/ibos7oLXSPbRPlmFNMiip9fN0sGlAzZiX?=
 =?us-ascii?Q?FcoLM+SQd0+zr3/4RvLEMHfKDQBPgz4Q2nKUqpcQL/HnOZhdOJYMxzy+g1jr?=
 =?us-ascii?Q?oW4WfOd135CmZMl4GCWCDjP7bT8+4/f4w71BKkMLo4Ncj7bwhKntjc6/nRK9?=
 =?us-ascii?Q?birux1VN2rPHQfh2pjVtva5KQP3NUZZxCnDkh5goT/n7Hme/5BxIMPPtUHpf?=
 =?us-ascii?Q?VIQ1B+6QLX8EiCmi4RXjEU1cWmyzQiUUeMeaJfzz+UNyCc8C9iH4HXJaP65M?=
 =?us-ascii?Q?TdU70Yv9Dg05XdRWrvjbL68l80DY5TKbgcDiaz4qjKZOVWpcC8WiJ+r4HE5J?=
 =?us-ascii?Q?YFsPsYIO7+a1yabcJjmVGMAfQ7uXaGwBOn6jTSmnAl1KWuBHYPHMjXJgDPTg?=
 =?us-ascii?Q?DpnkWGZsrxGQE46a2thNXXLR0gLIbhPqgx8QgZGk64HFq8BChtDsSTVV7J0v?=
 =?us-ascii?Q?xd9DpGpb0CcU8y8H9BidTEDfjPUVOGtQGs3/CBsVkl8ECblO60mfNToOjBJW?=
 =?us-ascii?Q?z0MiiC2xmyTMz8FWDSeem+AXiOPKXPRTsMZz6AFKlqJbf/qqJiFaNTgzMSXV?=
 =?us-ascii?Q?l88yTzEE5cS/0W33NT646tFVQ7VEAQekB4/MQJZWyKd5x1LZmfuknglHmyck?=
 =?us-ascii?Q?Q3rDGzbiy72I67X3wH/mkdT2IHrElMzjc51FUCEUlomibo8GBVlLAyvR75ln?=
 =?us-ascii?Q?5qPubkbhiJXa4hmXOUogVKN1W1yRVVe9ll1dAUDvsw71HOo7VlBQA4W6qHIO?=
 =?us-ascii?Q?f4LEKc7R82MAVKmBgLaqb986LykqhgFu4HqdXl7E0DHKMrL9bP1kJl87DciV?=
 =?us-ascii?Q?3xxEXIFt1JykubSeUwrPKBaAGTDPdJvmzbOHwIUYw4YOOpq3c6n3uiycnGO1?=
 =?us-ascii?Q?OXSBSJNGAJRdzeQ5KeBs4dlLqEYInu3iig84kFiBvfagO/bcJDrKbhmCJ2of?=
 =?us-ascii?Q?8l9o0BB99gbpFeOMRIJFKCj6nchutc3JTDs2zvik27uEdcPhCi1mdTBsSeuG?=
 =?us-ascii?Q?0iq3aKEaI+qMx2Truwizm/J4UKd/vAeyplIO/P+Qt0WgQmLbIQ2z6apmBdNi?=
 =?us-ascii?Q?wnzwvY3TkIIdNgvbaWwFOVN8pPejaMxV6QW8us+vb7Mu3uqKn+dY87E/PmoG?=
 =?us-ascii?Q?4cajRzvcEapO/3tCTLZAqgPGbnoiBgkAmwWvlCfPRQnpALq7tlcMAX6SmLDN?=
 =?us-ascii?Q?7IocrCch9NDrvP5WpBqlKOsIGsX2e36YUOsMeJA2s0O37UIvJwyKHWP8J3Pw?=
 =?us-ascii?Q?9vt7DYTAEheUYR4r13GRSF0/vy/xJa1+i/kHbp7+HieglAP1vF7RmjcZnJwb?=
 =?us-ascii?Q?5QmSo9ZDaOoT2pTJDuWbuHxp435zKU3b2729ogwPOsmWZJe4Q30e5/+J4eJS?=
 =?us-ascii?Q?Fk97+VK99INXtOHSKkaDrTkq2s2ut0QcPG+AbVJ0dMvoTCCCTuyS3nIfHRhQ?=
 =?us-ascii?Q?B/oOpvFzN8hX9l6IlmEdkW5xUf0zIicKxD8/GSsBG7Ad5Kgl3bvoZnB2OLmU?=
 =?us-ascii?Q?B7Sbn3eXr43/prSjcK8u6aQ0DasFI4iak8xW5Cpb19am+ywiEIIEf7Si7lNw?=
 =?us-ascii?Q?i1bfNWwdr8viBkDjJjc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0GcUWp7SZVhCZed5VJR5HKcqEf0fZu3JdyqLn/7LEBEM+Y+vV2uhqUSF1ANc?=
 =?us-ascii?Q?q4a03UKhWboQKcMJDMFObBrrKbMrTE/5fcvAQjeUwQKnlgbZTkXReh2Z6MeW?=
 =?us-ascii?Q?lJjL2tzCrANf7UNrBQEDCpSaMMKyrtA0s0F+EG0lp/tX0CLQNU9JvLCthoBf?=
 =?us-ascii?Q?ux5xXroO042r+2RvJKXoiVtDd6XUeyS/fpSj9y4Oy5uP9MUvSmmxItLaESLC?=
 =?us-ascii?Q?c0BDUjiPutq7JDsAJnBPb4x+QiJcw7E99+3wAj+3L9LvU33bvArZl4I5HmdZ?=
 =?us-ascii?Q?L7vPPEKhEXxNsjxG0c93vljV5A2p3IaT1dgTQ/yn7ciRxhynJcakbS8g/j8T?=
 =?us-ascii?Q?93Fu72hc7JgAqHK+fPjsaM8B4BQIjGahB+Nv5pSFUC5YXNrIIZL3LIu7nMqs?=
 =?us-ascii?Q?wwErqLdf+5YW/N8wW5+raLRGThz3yEx4A2iF/pB+RrdZT+V4ic8HjEBg9wnr?=
 =?us-ascii?Q?d64u3SfyRbJ6qeJ14+TeJxpcuihkP7dMgHHU+sZ9CPmFPUcVjVs+cfFKMabs?=
 =?us-ascii?Q?3ud4Nq3CG8CY0LlvpY0I6CshHx/sr9uICER5UAHfhQ/gR8NBDoLxlN1unfjI?=
 =?us-ascii?Q?0FFCpxqCMPxOstb3YJ/gzxe9AJPyzOXjQ2QWfbhapl6Z1YsIZZQ31IEMUYe0?=
 =?us-ascii?Q?f/ygaAItHnJZPgtEXDANweAqMCk2qGNp3mo5+DassQr1M+IQlzJm4/3rq+94?=
 =?us-ascii?Q?KXuwQwkXQdBPoj6mzWONVLdUP/92EZyhw0q8NzzAGjmhDSkYFyJca6uMYSF4?=
 =?us-ascii?Q?S72ShO3baDCe22qZXcBtL3t5+JxVKO3RrdzD+7EstvBv66tYxQGCCQs0aUp0?=
 =?us-ascii?Q?8EPhxn8CXMxZgzCEbBHQ7+jPnMPpbOlUywRzr5i2dqkORVvGM+7cXVUtHwdO?=
 =?us-ascii?Q?1p8ELKhRkxi6EJ4BkJEMau4oHJm8CjVzVDCB464riZhqfLquOU6rcaeOEKBW?=
 =?us-ascii?Q?8dUYjvzmLMaVpXOeAsBjNvw6PkgByWSzTipBVtFpnjHSheXhA6aYIKK9AvD2?=
 =?us-ascii?Q?3EuTu9Ajzber2qR0jzalUrNg83mFOG1mCR+8mn3RyjrKytl1HzVIQSzvRk8f?=
 =?us-ascii?Q?TTxVC7cyEeSEgVAdFkUIs2pZptfUMEkyBv6y7Lrtb6Vu40xLAwZkGkAWt4Q7?=
 =?us-ascii?Q?uUReWSjD1pwAzp/OhIS7wGFKDzjej3aFl1lqQKYljRV21/SNLjwrs2YNjTc/?=
 =?us-ascii?Q?vyz0oiu/dLMIpkLIlZXqlB+Gw6dqiEI/jXNhHWczt/T82d9n4MCUILccwqIA?=
 =?us-ascii?Q?9V6gxCEWYG6w/HpgofopW45mqo6dynxW6QTrBemP5OOxN2eOcH8uWGP7gGbC?=
 =?us-ascii?Q?XQh/aKO4osmCbGuPRggTgzORMF/RIwtTKuoMJLyFKJ7qxxOI8BXvSxqHcXru?=
 =?us-ascii?Q?QsQJQJwQI96vHz/bPElP0p1LTfKB+nH93q7TprNrao7+IFG3UjMjDuMpwwB1?=
 =?us-ascii?Q?W/0WtglKTE6H7gbe5FVA/cgq8NR7FrAfhpgwoE01HZUonLjuZu9YifOKPsFu?=
 =?us-ascii?Q?Pwd/L/FlhUXcWK6CH6+P2jhe87tOqmZhyiwoj9PVS5hDU0jQpykTxrfjP+1I?=
 =?us-ascii?Q?OvWSMqMT9dPmpRlO6melVQDeWtiZ7UlW7EGpwxRoIq3yCszUYyDKIVdf9Jst?=
 =?us-ascii?Q?2nLRa8epK1cWHwliPSOl7r2mJi1i978yszu/a7UPjDOHeOAtUBYgn3prVNad?=
 =?us-ascii?Q?6EWyG0ek/zPsMeoqqTyqoh+DikLgu4IvP/Ac9eZp1+KYlHra?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a8097c2-16d5-45e8-3cf1-08de70197911
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 00:46:24.2294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z+1XysDdh5IcszGtnUj4vbfy5dkhAgAj9exCrIj3+VcKlU8zOZI3oNNodoy2iF5C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9282
X-Stat-Signature: 89dyzbjy98okw9z4cjkou1htoxq5oqdg
X-Rspam-User: 
X-Rspamd-Queue-Id: B2CDA2000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1771548393-912243
X-HE-Meta: U2FsdGVkX1904/BGamKrdiChtC8/dRQ91ZTkMn35hob/3+evoph1GFFqx76VQkkOZly024dOlMsclKAOcGhfyKhjSaIDPmCoJ+iYe2pXKCj0NwW/Z3FESTkxHSirC5dG/2Zy9tWzBqjHlNQPpb1jxkUt42hVXSzDC0MFggkXCI+0binE+Jm6K56U78tiSGDaKtBsN8aPji4edKdngsjcBChlq5pPle7bPpeYkzt/f1vmcY2Ox5vPQwuE6iWEwCzB81xt616UnXdDxDmltq9FKoqdhNYh+19utfHor6p8bIvxfJcTNRgEszRRld3JuiopYd3fDSmImP3+7teD+cBOaw1vQazkaJUWmdEUs6IW+zjBUyBmO9S6ae1iYmZP01V/1rEMjLs94tF5X6s2R11fZZFj60oH2bocF0w8BwiP0SeMaLaoC73589P9Gsg2y7WpImLYXgVMYLBzEOg0fIs0WidLTqB8CxzbDmDLiWt0Y4HC3mQ/wP3Ovl86yeIwOyDoVsXMl+++PPGUw4L9dOhJ7d+9mh31rEPzpBpbHqu/DmxsN4M+LrhoIesfKlywJrAgdbDrKv3e6DXtg1dGq1rEsK1JnM2QQOZpHncZlZN1ZRiIFAervhrCmOFjIgzwZjhRSOgTnaf1noxz7/qmdAPfDxOjRVZ23DbJnQyfp03jBWOHWHhSVZ7Bxek1uVZxdefrhfZF7LQ0YlWiweuAgZ5NBtwTMDJQIH/E4Z40EQO+dPmVsXHuCdm9t045X+Zy+IuncibJz517I9RxIRLqGJpTjK1IUrLl5Nt7Yv8zOShX9d2iIBFzGCzlIpOSmjDtz2xMi6QanzS6/VEmfggHi9Af/Fv3xXszoUOgOHGnnkwZP/r4IK+4BqkzmL8nuN047843aVBBmoLashF1xLWNmy9N2KD4yeEDt6vfJ8nXy5INGYT5zJJTprSgpML39/7X3utOA7Q98dhYH6pHu3L8HEL
 tvoSO0Rr
 YXGcatzrMbVMJ9pkruCEnvnHHJ10O1W53ZOQysgwBWUhTRgZIMP1WneqpNmHyzhHgoRY4qL7cPYsoSStLXzc9jnHlk0KAh16Po/NySSMoZ90DK2BM/IrGer2gUXek2sVcxU/MwJy2ABFzJQC74o1JOeKPjr3c5kQMQSgnTnYD7yeStGekC2pdbBjO2g2zaN3xu99dehJc8D3GW9kglXG2V0qYb7Yj1EgmcSVp8B4+h03zHQ1dIrJB18CT0uNBNUiXj1smQlimDoz75xhCxAt00aA4RtGWYsXrEKaYDUTChQKy2tQk15bIZeZTm0lXhfyttgi2w9D87z5LLs8811P7awtSv7WaKcOl3payS5Jhr9GWrbjhZzzCVxWv+oXF8rhpAU2oAiWR8N7xa9DHwIH5Qhmn8C6ML891GltBNwr3aNX8JPaTJXGhnFaIkd2HRp5oGw6Nw4P4Kv0aWFeEvRrKumpghvHJM+3nkXcKkm9LksFPudfCUNuEfzHwlrtFVL5M46jiiluLt/An77qoQF+zhFOYX518tV5dzrVeOIhIFGIp7Z1FSTfEqv16xrHEnwLvP/8HAen50N8OsjI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Feb 2026, at 18:58, JP Kobryn (Meta) wrote:

> There are situations where reclaim kicks in on a system with free memor=
y.
> One possible cause is a NUMA imbalance scenario where one or more nodes=
 are
> under pressure. It would help if we could easily identify such nodes.
>
> Move the pgscan, pgsteal, and pgrefill counters from vm_event_item to
> node_stat_item to provide per-node reclaim visibility. With these count=
ers
> as node stats, the values are now displayed in the per-node section of
> /proc/zoneinfo, which allows for quick identification of the affected
> nodes.
>
> /proc/vmstat continues to report the same counters, aggregated across a=
ll
> nodes. But the ordering of these items within the readout changes as th=
ey
> move from the vm events section to the node stats section.
>
> Memcg accounting of these counters is preserved. The relocated counters=

> remain visible in memory.stat alongside the existing aggregate pgscan a=
nd
> pgsteal counters.
>
> However, this change affects how the global counters are accumulated.
> Previously, the global event count update was gated on !cgroup_reclaim(=
),
> excluding memcg-based reclaim from /proc/vmstat. Now that
> mod_lruvec_state() is being used to update the counters, the global
> counters will include all reclaim. This is consistent with how pgdemote=

> counters are already tracked.
>
> Finally, the virtio_balloon driver is updated to use
> global_node_page_state() to fetch the counters, as they are no longer
> accessible through the vm_events array.
>
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> v5:
> 	- rebase onto mm/mm-new
>
> v4: https://lore.kernel.org/linux-mm/20260219171124.19053-1-jp.kobryn@l=
inux.dev/
> 	- remove unused memcg var from scan_folios()
>
> v3: https://lore.kernel.org/linux-mm/20260218222652.108411-1-jp.kobryn@=
linux.dev/
> 	- additionally move PGREFILL to node stats
>
> v2: https://lore.kernel.org/linux-mm/20260218032941.225439-1-jp.kobryn@=
linux.dev/
> 	- update commit message
> 	- add entries to memory_stats array
> 	- add switch cases in memcg_page_state_output_unit()
>
> v1: https://lore.kernel.org/linux-mm/20260212045109.255391-3-inwardvess=
el@gmail.com/
>
>  drivers/virtio/virtio_balloon.c |  8 ++---
>  include/linux/mmzone.h          | 13 ++++++++
>  include/linux/vm_event_item.h   | 13 --------
>  mm/memcontrol.c                 | 56 +++++++++++++++++++++++----------=

>  mm/vmscan.c                     | 39 ++++++++---------------
>  mm/vmstat.c                     | 26 +++++++--------
>  6 files changed, 82 insertions(+), 73 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

