Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC99F531C7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5402E6B0093; Mon, 13 Apr 2026 16:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 516E76B0099; Mon, 13 Apr 2026 16:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D6C6B009B; Mon, 13 Apr 2026 16:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 31C576B0093
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:03:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CFC461387E6
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:03:28 +0000 (UTC)
X-FDA: 84654607296.12.BEB7BFD
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010050.outbound.protection.outlook.com [52.101.61.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id F165A14000C
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:03:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ca7aNGLS;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776110606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4oimbAB9x2nB+bkZ0xFzahpTlpDdH7g8/5iubm26M4=;
	b=zez0EB/VzPLo2ES0C61misjBJu1LDB9h0zX2YhfVrcHZfD3FRS/UuWiGdbQWDBOBtbW4pT
	HepZExFDvHfMv1E04N+xk1Cqr7PmzQUuRQDZSS494oB4gZojKkFWu/nWZMh3an6z9GF/V2
	0mfmmWR1ivkDRO0rnAbc+P7FEgK0frQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776110606; a=rsa-sha256;
	cv=pass;
	b=lVZ5p+soLrp3QUE0tHVv82IeSDw0+O2Pk9/KnhU3ckR0UGJ8r/2R6hlUem1PfS5nm+TJJW
	/qSBGy5CMwO7G6ZjPRM3iQkBjp+SbBVYUuJ8k+x+7C3JbRZkdS41JdoWAWEtt6x2wLHi6C
	YpxKyjZyyOLnZdPkvc7/Z3ssq/pY4sU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ca7aNGLS;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WHmVWqG+BIJENZGBx00sCrmlIEAm/i1TyIQj20YElhwDdXop9vKPc5N+vE75Cbh+ZvQgevZBMwmPVxJmZmFGqBX3FagPag1IeKdiRHl5fjePc0pWnvryj5c+1BPOLM8RGfcb69EFD+Vdw19IAjdHqrVlCaDyfgQvwref0AxLduU7WLuYmk7+ULDJs/TQdgIF/aa24+amuyR6dV5hP1vIq6n6wIiC/N6RcZ+V3JnQOfzNNQiAOBVoInleeDWvD9IHqmrBOiG+qi+N/jCW9CPOAk3S+5qRukf8JLVw0kj8eqaDPm2ApGGSqrMb7kvYJH8pihNGsM/4KvqkPQrMcSBiyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4oimbAB9x2nB+bkZ0xFzahpTlpDdH7g8/5iubm26M4=;
 b=CHUrvNyImtGaKagoPn13e96HMlbaT0maAobM16Hm4CPXbAcNPGHKAfXEIrxR6jXiwZVPSkQwkJIKVbQUtPE4W4cwFDZtjBoHQ9VoQPNW4mgT9GqbcNHineGja0FhB2JkA5qXNpfwC406v3R6zsfNMoO0Wq49E+pG3tlq6ZyPlAc4isMqxN6F116YmwnefOgiIyRFNd+g0aBWr3FHj5OQ3de9xKNSdpMwFk9XKHQwge4dp24crapafDFx1/UEeXRzumUS4KU9hpZbuc3hBMCvhjNC5MbOpVYx7xFdRbrteDrVtJuGJMGhUWfytc+whjz65d8nozKJziS2cXO9n8I7mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4oimbAB9x2nB+bkZ0xFzahpTlpDdH7g8/5iubm26M4=;
 b=ca7aNGLSpsoNAA1eVjDub6GecGvgA54Mnlc6/1GtRQJjwsTT/OfH8M8CU3SHgj6XMdKhqiNeuaOQ1SUjf4tnyDP51cz+/7cjLeFsRxxKDXQ1fL1lgUkdml8iG3JAZ/BuOMiyVQCcq5RuyHzng+miWXnS8zM1oPas0AH8sB3JfGCz7KFtUDTERB7clIdUYH6nOcU5xH/A8d4hXop21BqITcfZ++A/N4bUkblXKmttXV8Bnrj9g0HdKEC56g+CZsqUlE2kVHOtaoaTSr3JMQg1N1dZVv5Qj+rNvjG0YjwJPXj1U87iHps0a2SnfzN1urZ2Hew1syhjqWBPGz5fP55I2g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN6PR12MB8591.namprd12.prod.outlook.com (2603:10b6:208:471::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 20:03:17 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 20:03:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sunny Patel <nueralspacetech@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Balbir Singh <balbirs@nvidia.com>
Subject: Re: [PATCH] mm/migrate_device: fix double unlock and remove dead code
Date: Mon, 13 Apr 2026 16:03:14 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <6073CBA5-2762-4FE4-98F5-27BC92482531@nvidia.com>
In-Reply-To: <7579105a-1261-45db-90ba-5e660d202b80@kernel.org>
References: <20260413130927.13263-1-nueralspacetech@gmail.com>
 <7579105a-1261-45db-90ba-5e660d202b80@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR01CA0053.prod.exchangelabs.com (2603:10b6:208:23f::22)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN6PR12MB8591:EE_
X-MS-Office365-Filtering-Correlation-Id: 68677ff9-e5a2-444e-46fc-08de9997b431
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wB4EHGr02DGDSw/QmFCViw69B6rNzsWLH7U/TUTFMf1shC9+LV5SkpW8GzAs0PPz3uFixkOhFPq9NydDFq5RMW25QxOVhhLNWRfeISrk3bBs5p5q5OL1WiuogcuHAbNWRr1ocT07De7PHzBSiYRSNXZphJOaHcokbFEWDN9HAEyZheveDg85NWkjs354T3pdPNAgYGSEYAQuYkyGc0PrNeyMr0rDM7MqHT/iEOhSRI8xAfv2+BrYI5o3O4ALbgmCyMSGei8AL/6HGrhG2khSeUYom26FFS0kKah5K1RF8PBq7Bz4SCeB8p2P+ldTytJSBBCZ+JgD4tLRTFA4DaGYnftwiU76RSQ662zvNMjNfNdHxZDnE4h6hYY8tGXM4AcMfQHODnfyqwNxN3saF5r3mSdeMr3/ehcQUAW3LrQd7d8Vj/d1+NSNl1GvgZm+vHE7FWjrqDPhT30UA6UJ+1nwoHE4Z48ks/m6y4BU9A2e5v1b+pbihxK+ExU0PR7ExY9DJp2pAwXZR3gzDHVMYPvdeonRv/LJ+k97PbguE+Mi8gFrmt875BvrA45tly+PyLZx8Wk+hd58auny/3/sF65OJqXthVx6NAFWxRmkcZtYVuvK2CmZOTkgiNzY84jHjkRrjfQmCFah00xWfPjnYmXPWkPcwABX7huYdgeh1zFOkAsThMflvM65MtnyfuALIvu8CkODCyWy4bf/tEyl7uz5gkGG6Y1+AGBpR9YwoVB7s1g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zD9JTL2BKdAhoxgytiMHpm/MY9nblkEa8yTTfqR2yiwvzXZB3wcBpmFeBsWa?=
 =?us-ascii?Q?Nco4rBUmYgylfn0Sr3jG4y5T26US+NiRRnL1LbT83SyTq2SQ+KfKFY/ZvWrq?=
 =?us-ascii?Q?1ltKDmKz+dDk39kf7k1ASIFMjyHbENlgd8FkipuasyMSE9WSScQ1nfeN5JlC?=
 =?us-ascii?Q?A+AbhScHLF1Gnz8F+iUbgseY8JHdf9UGUU9KPYWGI7jOrT6WeXcUeTHI9nmi?=
 =?us-ascii?Q?J6GyaPRgQsFgF6xuGFPNa5JiYASr6bVBg0t0Yowxq/i9UHFD7wsxbykNGP9s?=
 =?us-ascii?Q?5uS4HhmfzdxWvPdbtE5ySr86uLQGgluPvGwCfjQd7sVIp3Os4A3LmmFfVRxu?=
 =?us-ascii?Q?Ev9oXwsu+1FGq+pp67wOxhZx1/f1AokRMYseWWSq7QYcxEuWNhp1BqI58PDM?=
 =?us-ascii?Q?IXSfgv2jv9nZbfGz92Ck/QYTjt8upe/O+2RVo9QlrymZiv5zqKXueGGQOsOg?=
 =?us-ascii?Q?haNUvsWgY2w/Q0c8FaFUi/7Iet73J0nCLISjsvsrjqrRFumcl4xFqnkdQz7U?=
 =?us-ascii?Q?Q3Lb9suNhKotDcHZP6MDePmzWYFT6TyCMLvvG0pxWafPY/lYC06/MUrq0Tzh?=
 =?us-ascii?Q?XQGa8hv8JGw4v4jlOybrNkrE0WMEfqWjvJrLSYHeztSi/I8H0p8KIVZB6l5f?=
 =?us-ascii?Q?GFFVBOaoNaMnEuERKjoeLr8Wx/gtoo8LZdB+j7DzzbLteMgj/sqLNgBV0d6T?=
 =?us-ascii?Q?WDY1u3i5Sd9HqN3xmm9Nckx75am1VZ/lC8Fjf97xY1zpIgBk8sQHbC1gIZyc?=
 =?us-ascii?Q?wpsRgrHaO09IKxlYE83fUpThT1fM8FHjzC0Y5f6xOHLyUhPOfOrAEDKdHCsS?=
 =?us-ascii?Q?esoDAbu1J9lE0VgIS36a11N09ECWiFplywN2Ojo+Agto7YtPnTvf/HNKtJfq?=
 =?us-ascii?Q?VeaxEzvhUW2BzI2SBERmMOfPOkqB9YfljYX17o+VywYWuwgt/MvzQmt4G8yh?=
 =?us-ascii?Q?jX2T1bgJ1MxFb+dMym3i0M9xvLx4K+DBXQwzVcangt0xzEWL6jXARgg0HamQ?=
 =?us-ascii?Q?J4hZzwHXWs6L4luqSu01xrRSEKFIKBpVp1zZlxkV1TkAbu7BV6YsgISSpjhM?=
 =?us-ascii?Q?t48SUXIhcCwF62FNNoxKR8o+ydLzGdGLjMHDO+EfcKmg/CFkJ3Wea5d44j2o?=
 =?us-ascii?Q?oLpZc17etfsIYXqzRCkIVEDmpmEonmuoAtIvgYwX3EKlIjq1Dou7GEoLAQ7a?=
 =?us-ascii?Q?6rMsXBkd9lYuJQjzlFcL0EHE0y8034u5YrnpA2d47qHq1oyzLsm/RkeVjDlv?=
 =?us-ascii?Q?zP/cDPJ+A4g8Dtb4gIKuzX5cvOTfDQQWS4EkXb1C78sX7xuJTHUTf/HgWTdk?=
 =?us-ascii?Q?XiOUIaOEVfcSy2UFC6oERmFcfsFGy9uzrchGho311KN72Uen6tl1lgP/k5EN?=
 =?us-ascii?Q?2fRxEGk4ZgzLUwx0CHXRdmUOMHVnjdbKyNOT9UpxEqNScqKBwluCz4wADaWU?=
 =?us-ascii?Q?r3MYu6uh0vMiS/jqR++6ILkkcu1ZbG6DjTBngOE2aLEC7EZBSktbSjQY4K8b?=
 =?us-ascii?Q?mb6ZGc771PQ4ZerlId89W324fRf1k+usCmG8DkaLjH3iAocYnMboz9xXsdwv?=
 =?us-ascii?Q?+dVmYQUSM6PDeIRWG14VcAuXXk5TLQJkHQDWAw2p/CmsugX68KR8AuZCHTku?=
 =?us-ascii?Q?3pgwphhIGJTYmENGqfqYI6ujevSqaPU0fUWC5TEdkmhx5jyjgR5xjeb7YIhw?=
 =?us-ascii?Q?MXUAn/3Z6wKiy+msXqL0QvgYNTCgOrW7qm1CwWggbLLXJcp8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68677ff9-e5a2-444e-46fc-08de9997b431
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 20:03:17.6562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V7/6ZwUCLndHmgZ7PJTP2y3UlGSvP+pogUujl4iMdRf3kZ6amqoVu6RSqz9o0BUt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8591
X-Rspamd-Queue-Id: F165A14000C
X-Stat-Signature: eb3omdmdun4bj3pud4cpiq9nfak8czsq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776110605-641257
X-HE-Meta: U2FsdGVkX19oWRNcD516rFn11+cvLpfyTS5c5Lbtv6RK2Y91sILoMLlIhI8SGouAnNsWfVgkJeofmTA6U3/28AwDx204cE2ZgNoIxG6IF8xZfsP1hDM+DviQYl3fSAluuu97X+fYLsr+S24YTx3hZkZRDbIisYApkY60cDQ364YHHOUp1UPv+4gAV4mj9QHqmNzzkZByZNTUr/c9OB+M0QQt75yPfIeRAHVqFMT0ky+moGRTG4cvbl5hnESjCU5FK42saTequxRxisu2IPNPhLUTdLBR+0K/qSu6+KgelUE9DbzoQ4YzPMjnMo4o1ve/VR70hBO9f9D6JQhqcPvuLVfjH9nT4VgPJaMP3qasEG9iCMN28k+VYOPc18AcwQ5RkBQVhUrf0uGlt5FK59+RpSPGA9+4M+ED6B8c0h89j8Uwnt9K+ij4c5GyX5UKFcCV1gtM4/9iGYKQ86rHYmsf0Uor8vFT40yYHvxEUQKC0lPSmjvmUBBBEh5GIexIVTbiFZfoCWRxvPhWq65Kgr03NGYxyh/qeFsicVsSJw8cXpTghI6W4IcIBQxuf64Fr2B+Ufz+TBq1YDm+5fohBeBAY6dOEe1e2eU3zigEv4GsZV8X+W5k7e+KH/XfJR1UdkQxQcUoRH8lWqow+0XRJvQ1yire4DBmMNU679ZpIf0qFECVg7E2E7tfjA26fwImMg8ShMBBoowjsIVJN6fN9wPRaVv4RcGOKJ+t4zLO6rtbjHtCU3hrmkEWCvvKQrBpBSbWLbDrmjWUugLk6y0BdSUjEtMSVAuOfDHD17hpOHDodxf8Zx9Bw8zvzxCVU3s+WZ8WZgI8Xi924axRUR0xO2/JsuGEKrFskMIUuCya6jKYV6/i/Z1pFfj2gWy3d99XxqfKWcyvH2WVKR5C4WS8EYGzzBrLqM0ymYfoerGuTKcAk9f/T559wiA553lWMfyn8F0MguO5f7exWILRfFfXwZr
 TnzsS5bd
 jkB2cKF0UT2hLdUkfdC4laRe8lB8AIRb7sOJB2vZyQcpauyHHt6i/FiwYiuOnRnBKpm5YHeSpQOGhiuGT2HM/yeQ7TtR3jYEmx5jPt8Ne3VIKhaqIIWw6C4qdgYnDDdncJcrx2EQE/8RBkYkL8SbvkKNqvdq0IRGWq4aq+qo+J3ALHmWtEZqpFfu3V0xzE27Ls9XS0xf0Eqxt86gz69jo/7Hr31pm/i0tVB9gKOnLbFpgk+IOQTxEc7DHSuO+rbIqdbc8T/NRZ2pYuARxEi9EWUbqp/eDVMCFADTHtIERkt5ArIYxetHSSqg2+01WXDgZDO+ko1wttGeocveUe0ytTMw5CjGtZrp497QmUoJ29qPxNrcSjflO7YdjFWIum0gO2WTKDQZ0GAIXYTJZp/1jvmiA9V4sfgrJloL6uD6ozmzgGmiLFT6TPxrkWcpuT4VL0wSCj/rybb0ObxYog+ZapGdhDzxqyIdBTHvvUUyOlUzx10DqNjSljvixovyiz90kg8B2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Apr 2026, at 15:38, David Hildenbrand (Arm) wrote:

> On 4/13/26 15:09, Sunny Patel wrote:
>> Fix two bugs in device migration paths:
>>
>> 1) migrate_vma_collect_huge_pmd() calls spin_unlock after
>>    softleaf_entry_wait_on_locked(), which already releases the ptl.
>>
>> 2) migrate_vma_insert_huge_pmd_page() has a dead else-if branch and th=
is
>>    branch is always unreachable.
>>
>
> Can you move 1) into a separate patch, add a Fixes: tag an CC stable?
>
> I think it is
>
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zon=
e
> device pages")
>
> 2) will then be a pure cleanup patch.
>
> Thanks!
>
>> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
>> ---
>>  mm/migrate_device.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 8079676c8f1f..0e005c26ee88 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -177,7 +177,6 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmd=
p, unsigned long start,
>>
>>  		if (softleaf_is_migration(entry)) {
>>  			softleaf_entry_wait_on_locked(entry, ptl);
>> -			spin_unlock(ptl);
>
>
> Yes, that looks correct to me.
>
>>  			return -EAGAIN;
>>  		}
>>
>> @@ -869,8 +868,7 @@ static int migrate_vma_insert_huge_pmd_page(struct=
 migrate_vma *migrate,
>>  		if (!is_huge_zero_pmd(*pmdp))
>>  			goto unlock_abort;
>>  		flush =3D true;
>> -	} else if (!pmd_none(*pmdp))
>> -		goto unlock_abort;
>> +	}
>
> Huh, how did that happen. I hope that it's not a typo and we wanted to
> check for something else.
>


Looking at the function and trying to figure this out, but find
VM_WARN_ON_FOLIO(!folio, folio) at the top, where folio is from page_foli=
o(page).
It is either a nop or a zero dereferencing. It should be removed.

VM_WARN_ON_ONCE(!pmd_none(*pmdp) && !is_huge_zero_pmd(*pmdp)) can be remo=
ved
too, since the above ifs takes !pmd_none(*pmdp) && !is_huge_zero_pmd(*pmd=
p)
to unlock_abort.

Back to the above code:

        if (!pmd_none(*pmdp)) {
                if (!is_huge_zero_pmd(*pmdp))
                        goto unlock_abort;
                flush =3D true;
        } else if (!pmd_none(*pmdp))
                goto unlock_abort;

It seems to me that the first if should be removed, since if pmdp is
not pmd_none(), others filled pmd entry before us, so no further
action should be taken, otherwise, the function will overwrite
some valid pmd entry.

OK, look at migrate_vma_insert_page(), which does PTE level work,
the above code might be intended to do:

        if (pmd_present(*pmdp)) {
                if (!is_huge_zero_pmd(*pmdp))
                        goto unlock_abort;
                flush =3D true;
        } else if (!pmd_none(*pmdp))
                goto unlock_abort;



Best Regards,
Yan, Zi

