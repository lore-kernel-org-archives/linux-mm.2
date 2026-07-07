Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A535DC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:34:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312B06B00A3; Tue,  7 Jul 2026 16:34:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3996B00A6; Tue,  7 Jul 2026 16:34:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B626B00AA; Tue,  7 Jul 2026 16:34:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAAE56B00A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:34:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A6891C3B99
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:34:34 +0000 (UTC)
X-FDA: 84963133668.18.EB8BFA6
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012026.outbound.protection.outlook.com [40.107.209.26])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4BEA340004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:34:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qPWpNWw+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783456471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ScIr/j8NgES8SjgpxPAR20wLo04xff55JTRN/Mt42+U=;
	b=KdPrNhC7rLTh+OOZlotnwOWKrvs0uKewcoyXkHGfL4vsRoOJANQU2V27RMIqZNj4O+1T3W
	FTPgTRaWqgNfT+dQKx1bD3v0XrxFSRNdI9Lmf2MKY+P2wbroiZx8ZOJOMe9e6gurAzWyyH
	cbx5nWFJNHGBB3TuxuANMRUhFxRK+6w=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qPWpNWw+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783456471;
	b=AfcIJWsuNA8lgCxE3HxK21sZUtU/5fFLUV3k8ikuKnFZQdeBHMcF6RQQyYVf9Vk9MzgKLV
	pS31D6mCABHH9AapbX6ZQbZo7TLip/ajy3XFLhOwy4c1MKYmiPVKVeAd9vPJvOFvQ+YEBL
	DoBg+/hLK35/xylexSecCKC847ianbk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XT1/cHrlebifSDanWOwP8j+aAbpA/IE4BFgbMGm98fxU569FC2UcNfUJae9UsIPq7gICPT7ohzhXcemOeByRRaCfXyii4r5tDvbsdtzmF6EZ6GovzYKTELa6VDcb+p2wWRIxzyV0ML3I6CNzhsQPMH0cQAGd1oPRq9prafypdhuSVzbAVSaudKzSoTjpipjA33b7PnZb4PbYnR0kbXmSCyluIjCAl13Wf0BJ9k0RRNkFpVmGgBOitkguBKFy4IaZwrtF6l0hfK0EtFml21VFqj1PLxS5GHpFNqktfYgMUBtLqvy6L18SDuyni7hQQVL6yYLVBtJIU85y8fZtt9wf3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ScIr/j8NgES8SjgpxPAR20wLo04xff55JTRN/Mt42+U=;
 b=IrwkBGT/o6Il9+jKEy55Lz5buUT+4QuggdGslPqOkvW22GEKxG8bE/cG8Ayc6rRMHIjAehDQwx57GPlK/8ms41QoZlwZebtS04WwdAqHGNxWobPTUBMM2Hx2+Z0BU6xgTMqeE7F2b8P/Vle9UWuwvVMnNJSDLetRqIDA2NxETj8CLNP2VZd2mxFfnlwnhlaQi/N0HVjh+dEfDV1qjGqoqF0/y2pOmWndvo/jNPowTp5+hvJ2fDSY+HQZ/fjCMTN7vs77v6hzwWreNeUnwZiGYPM/8RKI1iwZmATe/JDH4H5ZrCchnSU6zBZ04J0fgFXL+5+Qsb6rUOy698x6XNhaFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScIr/j8NgES8SjgpxPAR20wLo04xff55JTRN/Mt42+U=;
 b=qPWpNWw+OUMmIAChPmkP3Eymw4EKzBdrob6d5rDuFjjZx40keS06wmIl+FmNcr3c7Oc4QEKTOmjYZmsaxJgo+5qMgeKuFAuOk3hiCEn9vsLgyXfkSCnmKNHI5O8FhtM5nYU6sPh4sBcS3WbCcxk/xrrfSJzTIO2yV+g7lOkjUtcI+otTPmF1IecEpegE11iNHk+wHR1QMna6cG/nVkDfImiE/S2yWkXyYHQBdUnpr9U1zh5AojbZosKJBeKSQv4r1h4pKmSDUzOVFFsH6wb3s3+Ono5iLVc4mj47BR+tSAnhe+//QfaEZEEYKXhgp7Z5dbIUlDozgYvjjraBN8UQFw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN6PR12MB8591.namprd12.prod.outlook.com (2603:10b6:208:471::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 20:34:21 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 20:34:21 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Jul 2026 16:33:42 -0400
Message-Id: <DJSMJDTLDNDJ.1KAP9PWH9H4Y3@nvidia.com>
Subject: Re: [PATCH 1/3] mm/mempolicy: skip device-private PMDs when
 queueing folios
Cc: "sashiko-bot" <sashiko-bot@kernel.org>
To: "Usama Arif" <usama.arif@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, <apopple@nvidia.com>, <baohua@kernel.org>,
 <baolin.wang@linux.alibaba.com>, <byungchul@sk.com>, <david@kernel.org>,
 <dev.jain@arm.com>, <gourry@gourry.net>, <jannh@google.com>,
 <joshua.hahnjy@gmail.com>, <lance.yang@linux.dev>, <liam@infradead.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <ljs@kernel.org>,
 <matthew.brost@intel.com>, <npache@redhat.com>, <rakie.kim@sk.com>,
 <ryan.roberts@arm.com>, <vbabka@kernel.org>,
 <ying.huang@linux.alibaba.com>, <shakeel.butt@linux.dev>,
 <hannes@cmpxchg.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260707135255.292870-1-usama.arif@linux.dev>
 <20260707135255.292870-2-usama.arif@linux.dev>
In-Reply-To: <20260707135255.292870-2-usama.arif@linux.dev>
X-ClientProxiedBy: CH0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:610:b3::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN6PR12MB8591:EE_
X-MS-Office365-Filtering-Correlation-Id: b2fcf86a-b14a-4a53-11e7-08dedc67202c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|7416014|1800799024|22082099003|18002099003|6133799003|11063799006|56012099006|4143699003|921020;
X-Microsoft-Antispam-Message-Info:
	UyWT2S6F1Kg9n4lM+wa1B8fznABKlYT60T8mzZb0fgHGJJmT0UUAHugikj8qJeb7hM6qQhr/wonzWr4y6/O8HUY1uZN9KzMU8LiQBsOTmIrUQhh0fex2hZy0hC4+svPCq4pPZltokaDLFM1ZlC6G/0emmBuhdWuhBZcAkU0Dsutkt3/7Z+3fwPPN7f1Z/KuKn2ciTkMk1y7R62NL1N3leym7lD0NmNJxlAfMhPPEezmS3npgwS/B89M2rEZ8U8hLoiVdRHzJfvHER1BhYf0eLd8GSV2xiK8IkbpEJLPZfbSW4X+fsmZz06snPhjy9iH9YGQSwLmYGFqQvdGOtaNlfBUZlqmn5FbBihsTGXoFf6WpKRmxqr+pYMGXYthbkC6y2BJmQ4WsJFa/jlZuaOLpV2mrNYjRiIqSBx6jhV8aprdg2KbVf3JWLCL9pZI64WImeCMgiV15rV3Rwk1BMlB6hUnDn9wG+X35W2JjMNpEkIh/aPCsk3NjI1G1tlqCgUiWVcTG1/qItwwDyE4NjlKXrQWsGWaJzJzQgnAXgnOoGJpC81RpuNdfax5/wan4QVyMlLSfUs9qbkVUDHjd5yDeAVbMtNQItwYdOD+K052zCRen17WQ1zqeN2WKYQO0lSD9F3ZRYntETP3CSWm/ZuIJtVXf26WHC7S4iZ2Iua1+VxwEq+KWhX2m755VksJo0siHi5j95Z/jhi52diAPT+1FiQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(7416014)(1800799024)(22082099003)(18002099003)(6133799003)(11063799006)(56012099006)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjE2dDBQcGZaVFJ5UjYwVlF5VCtESkFsV3ovc2phVjFRSVRpQ3NkTFdwMXM4?=
 =?utf-8?B?M1dZa1Exekc3ZHd5WUNiNFkwRVZWaWc2akJuUmNxa1FnQ1JuNHQ0RGRYMVNk?=
 =?utf-8?B?NlNtL3hEMlRYQkxYTjJyK1ZNUVdFbUIxMWo2cVpvWkx0a01TWkkreEtEZTBG?=
 =?utf-8?B?MklUdm1nUTdEUklaU1J3eVhLVXp0cUJmNXREZUZCTlAya0FTek5UT2o3elpv?=
 =?utf-8?B?c3FPbUVHRXJrYm5RMHhDRW9laE9pdVRGL05Nam5tRFIvaW42cm5wcm1BVlFW?=
 =?utf-8?B?L3dRVG9lT2FzSHNmbUZWWlhENDY2eXJMTEc3cWZQbEpNSm9oNlFKQXJRci9W?=
 =?utf-8?B?clZsYmZuSFFPQnZxNEtmU3p5aEl6TGlJdWdBNUM0WlE0WlJ4SmZFS1FndlVh?=
 =?utf-8?B?N2hCVUtDWlV4aGZ4aFArc3NIVDZzRGs1ODNQbFh5ZHlvdEFFWjJ0WmZPV05x?=
 =?utf-8?B?Q2F0UzZwc3c2V09xYjFUTGpKVjkyd1RTemFML2QyRk0yKzJMNEFuc0tsYzFi?=
 =?utf-8?B?K2xGL2hSSjQ3UytQOWxndW5wdkRoRzRGa2UrcHNTSkhFQnhENm1pNFdpdEZP?=
 =?utf-8?B?WmdLVEUyVTlUc0t2bnFWdXVrSTlLSEJ0VGo1b1huQncxZnhwK0YwRnlPTTVo?=
 =?utf-8?B?V0hISVJtM0pzZU00bC9MLzB4WGw0aWl5Zk1icWVlQnVYc0xHSXRXeXY2dmdk?=
 =?utf-8?B?cURCN25IUDVGSWl4NVgwUGs1V3NmbDZVUE1mbFM5QXR5RDNMSzJZNjhOaWFJ?=
 =?utf-8?B?bHFFb3ZHTnJ5NDNZbEJ6VUxoZHR1ZldhWmZZRlVJUTRvMFFtdXlGQVB5QTFw?=
 =?utf-8?B?T1ZZRGJjK0FyTW04ZWpITTFFaWlXakxGaHBNUkNwdXRnRzJTazBzTEdNbWd4?=
 =?utf-8?B?TVU3c1JoczA0OXduTzlScGkwcWRFRnJITG1sZy9WZnVLdE9FL2s0RlViakRq?=
 =?utf-8?B?ZnR0U3hvQjA5ZDA1U205cC9CazNiQjdYU1IrQ200OEUvZmVwK3RyVTlKSFJ6?=
 =?utf-8?B?TDlCdzhGYjMzMWtraUhRekdvS0RmNHhPUVJlUVd3MlljcW1Ed0VzSXlxTnRP?=
 =?utf-8?B?M3BMUUVQNmpwc054SE83dVF0THhHOHRsSCtGaDgrMVdCdE15bHZZanZkOXhv?=
 =?utf-8?B?MW1EOUZhaUVMNFU0VmFPTkM5RyttT1ZMNkc0WUNWMHhnd0tPTGlHRlkvVksy?=
 =?utf-8?B?SXBieU9wVk0ydkM5RTBlU1FmMnNFWTN0S3EyNG5HcjhWbnhmd0x3cEdaNXFQ?=
 =?utf-8?B?dmVqNWVzZDFWdE1Gejd5bUM2dXdFaldUbnNjamY3Sm8wMW03WVlZdFNnbkpV?=
 =?utf-8?B?eGZkUmRUd0tmd0pIckRHRitQQ2xMeUlwNXUvUUt6TjlhU21nM1U0UW5GeFBR?=
 =?utf-8?B?b0piWnNUampJU2xSVGVWb3p5S0d5MGVGMXc1OHRaNVlrRTlmaitOaTN4TjA4?=
 =?utf-8?B?SC9iMWxyU2FFZzNHZlFJK2EzRFE1SzBPOS9IRFFHckt4K3k3SW45Y284SFVR?=
 =?utf-8?B?K3U1Z1VVSjd3bGpXTCtPemFnT2FzYzh5UFlNbEtBZEhDa29mV2JBTHBLdkxG?=
 =?utf-8?B?TlY3RGZWdFhPcTVjNTY5ZFpadW1jcW9Ic0JKY1FQUXFQdzl5V0JhTU50VTg1?=
 =?utf-8?B?Q1pUSGxYKy82M1dsQ09oUEI0ejNLNzNZQ1JhUjhXalNHZUQ0Tnp0cjlySjZ5?=
 =?utf-8?B?ek5oT1htYUtZQTlzV2owb1IxclVlRllpaW9UOHJiUXhYSEpyMEUzaDR2MDVJ?=
 =?utf-8?B?ajFBMFpvL3MxL3JxbjIyNUVyeEpLNWNlVDJmUVVzSHIwbHRCWWd5WlQwV1l2?=
 =?utf-8?B?YnMzWm0vQWRYTU1XSjlFbTdSWlE1NDA2MXpUbnpneFk5U3p1V21MKzRzekY2?=
 =?utf-8?B?OGgvdGZIOGJrN3BvNS9VNC9mOW5OcStncVd5V3FldmZ2MWFkMThWYmg3MnV0?=
 =?utf-8?B?OFVhUnFDSWJoQ0JGWEgvaEJJWlVxRnVIdmZoMzZacEF2U3BVSHN6SVlnU2RQ?=
 =?utf-8?B?SDNIWlN6UHNUOWUyY1I3NjA3S3RBaFphaVhWbWNhWFpZWllveHNEaVFveVdO?=
 =?utf-8?B?R2V6K3BZOE1LMFhxUGt6M3UyeitoenVBY1RkSWExSTFXVkN6Q2JVOW1JNUor?=
 =?utf-8?B?cW8zUkxuWDU2Ylo0dm5lcUdBdzhPcjFNUWdJS2RnTGFjcXdYTTFpclpRa0JE?=
 =?utf-8?B?czV2emI5NUN6dlhwdUtNVTFkdlJSa0F4VEljMHJTeHlURmNBYXZ2LytaSmEz?=
 =?utf-8?B?TmJUeUZvem5oMXZaRzZEMnROSy9TMXBWTFhIRWZmOE1YYnNKTXVrVWtQSlpr?=
 =?utf-8?Q?VI6eEJztAQruVNNjjW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2fcf86a-b14a-4a53-11e7-08dedc67202c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 20:34:21.4897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+nkr1RqBozXXAPuCyoShc+LLp3DM0BK0hHgrZ4bAgbkWlQxEk1iKwkdU6SZ3L2p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8591
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4BEA340004
X-Stat-Signature: xpsqrzbe4rdod71ty68qgqsg3m9toztd
X-HE-Tag: 1783456471-940382
X-HE-Meta: U2FsdGVkX180CtBzkGI+Ua9QeiHCBFsxDkOW/OOpcgrG1pyG9ZyQ6iL1juee8GWbG0CHvDjbLLY+z3HoQVcYl8QB9SJBZyA92nCFx/g+7PFKLcc1CF/FMGYeScBZW/USWtauxtMw/ftt4+INRe2ppEtx5G0b6CtsCx21QwQrOZ9W73nZBohKbIwC1jMrF3lidj/e3Rv2pTnaZqjglXCP8sjJ41VvOTWv/TLYPH7BuJqlw+YAhAOjZ39aaAt15gcx0EyRxSzRKRS4R3XpXuAYW5UftURGdw7+djMkbL8yQkd60z58OawWMwRjRo9e5yGC+BFIPLvYQxhu5bPV9KM2J/QvbpwWrK9vy3Wl6DNsXXtacNfoCJXATQOEuT/5BptfbNpuM1PV2hYIDY3d4TnTD0/EYNZEbFnPnQAZ2F+UmbJDqjuECdgOxQ4tEqWLPqFpMHJB1lkA6XLH4wM3BnCIOw/l4sH+lepK9hjbMkA77n7y7Iz9CYY2URwFwaHML/+qHdDeTdrivWM/Ymz/6AMLk6UQuboEH/Y8J/ppYyWHyh0qBXwzkdWcfiXWrrRYMN22FC581oXa6JwNa5cJJmgJ6aYwCJi0cO427Q6D/rLWVVRCRZxOWETo9J/4pZPa+F8SWyxrUAP9JRz8o7GfadzYSNdg4wDz5SIF+PxxN0UJ6FqREl0pWwv9lnOoUt/TgT4JkWlT3wL2plIAfBbthGClOrOmvfKF8CySAIVl0Hsa6Nfd7wYBRYP682i08RNNsnTf4A8/Me3iMJvainbLCFwdDwmB+zoHD6KlACo7slZSF86Y9oTcqSwdARqTsdsMIDeYFGi+7qs1lg39dmXmVMfbJDJY85SKaQpi2CB2MYzqi0kpMSSXqpLm3sN77SzLCEHytYSm5Xogv1YAoj/5JFY+pbvOhF9fER/r521kiIJX6PX/ian8UMKdycjCpuaxP4wjMpmpcr4TP23QIzILO+o
 iFHXGs1o
 zULGz9e344Kbcpbjau8275k+5tpF6ka5pYlF1stzbOytf5iDMykyvpi0MifyPEu3vCrIdfnIlnZdsm76jyYMkqlp5i/iCZGdTrQIz3wc43VcukJ8C4u4/CvN5phT49CeclaTsOkg/4ojui+MvO/OfmMTOB0cJJ79f5l3hwgTQNVciLfumBAAWWgKi+RF3FGEL1OhIruoWwru9EsCIoRtzfnT6kdPn28dbi07ydsZCJVpbhctO2KAcy5TVVfH2TSHSB9pZz4uUOPRXO0KTE5qReJhoN80hjcCR4NA1gpw1XZouXaMc5DwT5ZQL069k0ommcZgy58CP+2d6rmpTqqbUY5CYtZA86OwFf1fHbt5x50IweWec8fl75ZDSh7EBG54HKLG0ePZVk7w1ALUf/AfcBLJnD63f0ufUMS3qi2Qn5yazbQEbK4UJfCDcUw1wzz4WKWdQr9nhDpkHJ458yhrdVn4Slbk82tZ3LKS2Jt72oSi7VVnrW4IePgh0oTDr9hWsqpZtTW4dt37inQm+4/Wn8YDArQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 7, 2026 at 9:45 AM EDT, Usama Arif wrote:
> queue_folios_pmd() is called under pmd_trans_huge_lock(), whose
> pmd_is_huge() check returns true for any non-present, non-none huge
> PMD - including a device-private swap entry. Passing such a PMD to
> pmd_folio() extracts garbage bits as a PFN and returns a bogus folio
> pointer.
>
> Potential trigger: an HMM-based GPU driver migrates an anonymous THP
> folio to device memory via migrate_vma_pages(), leaving a device-private
> PMD. Userspace then calls mbind(), migrate_pages() or
> set_mempolicy_home_node() on that range.
>
> Skip device-private PMDs, matching how queue_folios_pte_range() skips
> device-private PTE entries by checking !pte_present().
>
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%=
40linux.dev?part=3D6
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to P=
MD operations")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/mempolicy.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 914f81863db5..eda817539c77 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -659,6 +659,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_wa=
lk *walk)
>  		qp->nr_failed++;
>  		return;
>  	}
> +	if (unlikely(pmd_is_device_private_entry(*pmd)))
> +		return;

Should it also increase qp->nr_failed like pmd migration entry above?
It also applies to your "if (unlikely(pmd_is_swap_entry(*pmd)))" in the
PMD-level swap patchset.

In addition, since pmd_is_huge() returns true for all non-present
non-none pmds, other softleaf entries should also be excluded here? Oh,
because there is no PMD level hwpoison or pmd marker.

--=20
Best Regards,
Yan, Zi


