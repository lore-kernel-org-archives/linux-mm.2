Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 624C9103E16B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1366B01A2; Wed, 18 Mar 2026 08:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77996B01A3; Wed, 18 Mar 2026 08:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67506B01A4; Wed, 18 Mar 2026 08:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3E2B6B01A2
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:23:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4887759E33
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:23:45 +0000 (UTC)
X-FDA: 84559100010.28.ACC4C84
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020089.outbound.protection.outlook.com [52.101.84.89])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4F30B20007
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:23:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=umXmStOL;
	spf=pass (imf13.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.84.89 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773836622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FE4zBXXCy3DcA9x93Ac42qtXup8Jlc2TBs91O/4/CiM=;
	b=HAM8KegyJLMFCBdcQ5umCSF3Lf3I+ujSWk/6SYyJrZ078O1kiEeUTV1QYkg+5vcERPiaAN
	5xEmnXKzk69Gu7fttC+62xH2d2om3eGZjCgaOdcfCZayjs6YwJRcMOwY1GKyKGCzdDdufV
	CgVKMjWioAxHaQ5Dg8ytHdp9oZnivx4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=umXmStOL;
	spf=pass (imf13.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.84.89 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773836622; a=rsa-sha256;
	cv=pass;
	b=4uDH1Xa1L6BSGvX2Aq5XsFM4ekizxlVbWcGkbQNno6oywXvuYckfi3ZS0psTXWVdh/GMuO
	p8fYg8BwRY0a6lCfhAyyRYCAcRNAN95TacmzaC92IonbG812lXnAsT3ASfS79BLb3Gk5j1
	16YdpcVNWnPneLWp8WtRghmFeVEku30=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LpWtl+zpKKeS/v5ngTBQtSn8ARKdZF9oCeT70ACs2EvuX3dSEEoYnzJUkHGdNPnUqbMjyVNN1gw/nJM5XjOmErybqDrreQfdK5M7hXBsNDXlyNySypg69R9EKG1mTves4xTaGXvLxFsKfOWnHGnHqI/XRHsPQ7OPVR1vK7UXJJTi6UKVxt/rszlJsEuE/n1yicCdn0HW90H1apU344IfH7tXfjUtU1Yqp44n3nH9NG3MTPHHWwiWCr7RQLiWw2R3nIsM7/XwUsLXz8nuYWFBBWR90il6cAr664vbtqo6rSGgTrt+umB9pmSEUHeqp1NU/Jg1p/Db9ITJFoMsSo2leA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FE4zBXXCy3DcA9x93Ac42qtXup8Jlc2TBs91O/4/CiM=;
 b=e8b1ZbBJSPyJUi3V7ASRqCHj3U4BMJgsCQiFQbUGGPQBLkb3KqcNf6vwqocL+rzdJia2sKgDpRi5HT3Eg0UVjGA8gfxBatHLhXOf6JwMrej+if6dT3lrN/eE3ZyvA/wwY52lTfA3t2KaaNxYOxZFgnGqsM+xv+VuRie9MzVgWyb7zkRmvqs8XR4BCcMxx4bPDEpGHmXSfbDCdMsmHylyat+W5m6ZG0sKsC7fXAfXz55EpW98CdHyQ8eFfU4+t/t6zFzUawx3cOyhpXN/nLKzNL1CeANbGSW5vrEZhNF/E+MVebrUEQFeMJetED/6o2yv7GQS5AxUvumQDoB/bFezeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FE4zBXXCy3DcA9x93Ac42qtXup8Jlc2TBs91O/4/CiM=;
 b=umXmStOLJgtOHIhgakpJvXoBn07fyq8daGW/pNappU0tU+3IKChsFeUeQFkoR2sV3Ao3KWsbgcipSGQFyyHp6RvAJPNs0PZB+v4Spztnt6ninJ2z6wWbVtQcg3phEMHzxJf6VV9LYqXWQ6Goi3MpR8Z6KOSELAwE4nGHZRjAt8pT5kPfhqccUPPOyW074DA6zrqKITRmpPM+hCKweTM5TnJO1sfqVV0dPp3055zOIPMo9/Q/9LsXN7P+U7g+Epxcx+nNtaraSdfIWasTWquJPWzD7RMocVf+C4/vD/FARurIN4/TxeZNMAkx0Td/2ICsJls2Yo43gVyK5fhm4vjsBQ==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by DBAPR08MB5830.eurprd08.prod.outlook.com (2603:10a6:10:1a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 12:22:15 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 12:22:15 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>,
	Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v6 5/5] MAINTAINERS: add a new entry for testing pidns init creation via setns
Date: Wed, 18 Mar 2026 13:21:53 +0100
Message-ID: <20260318122157.280595-6-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318122157.280595-1-ptikhomirov@virtuozzo.com>
References: <20260318122157.280595-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::14) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|DBAPR08MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: acbb3d7e-60d4-4d74-28d4-08de84e8fd30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|52116014|376014|366016|10070799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gQhYblgzAD57+uzPA6wukGUJH7vU82SkqBW8zQh1pL/jYiwK9g7kgrDEj83FJW/KFNzO1B9AWgYPbrzMaUAe7QWxc5QJmafC0gqsLwUXE8K832iHAtXmNcd0oSYrIy250PNLCAMguXxeY0R6J3La2Fhlks80+H5QuQv6MLNlaW6Han20WsSrr9U8xnxNRDjUWstWrNiY68wzaSyWz/FrCte9SLwsOxlTUzWoySIQR5UA4e1GnHFg+yJQmKjlH+K/8P4pBnF6zVPOHt4AoH7/eKdO5Wj+EDonobaXykAHJkH3pkwcoFsSjwixXhMpB8+ZkgcuurGXIs3YcuBRdqtLo+CrHeLU76s7CR4HPMQMil+2plz7RTgBjlAAWbRI2OpcbfxmBbV7JcJfBwN/AwDiVvb2q4O8R2JpDvaie0bo1ScnwAh5dG8hkU8j/nI3ed2COiamXzMIxjoswAFavFVSdPce1p6zHvJvPNoJ109LFVVvIhdAYBBWIa7uIGuvVTI5sHGd01cMk30+KupqI/CayCAu3ehrGeS+8xtPrCFT1WKuJS8l2ufu+L+Hu4jMdBpkil/4XiRhkb5sescb8Vt/FmNl2iV3Z7cOhnMU6aAqedV+pDWQYU2VCADVwAVqSh5VAGdLuRRiyU3+DCUpEvxDecoBOZ5TcPyIuktJ7yRRsSeFWzCleZSlwIEgMUuhD+35LjIHnSbN91d7Hl4GMXLTtr1AJqTdnqc6KVJApQ6n4e4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(52116014)(376014)(366016)(10070799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ldWgO/n3IAgjS1XCOg5+ckKozgseS8xwJCnzb5cmMXU9PPm8tV7LZJOd7MWe?=
 =?us-ascii?Q?gj1McvPKZq8UFGUO0E0eZHql3X7J4xc/qAZCaH28fhmc11RYLfZX59DOsfVj?=
 =?us-ascii?Q?u+MxjBWgBfYh76vBpkJydBSRyEWlNCAWe0fGP5UNNALSeJUSE42NCO/JaZiH?=
 =?us-ascii?Q?Hv2dCvHYGvMZ+7l0MJgE7Z5M85oksqNlz512WzkxLPn27HSiY3GzbR1gxY73?=
 =?us-ascii?Q?1zVmb5NII02che/w5P7gZmbUDINycrhr1835iW4RuLebROpYR/0eimxwiDqP?=
 =?us-ascii?Q?5o07FF9Xkce0wZzD0e7g86Zy3rvG9CT/ujq/1B3AfY5Pljz7ibDcRbBlpPCu?=
 =?us-ascii?Q?/A6qVseXRtwGKPTL/1rwLD+N5RQIex7iAT7b6unrjC3DU5uOEuqZucUuhGrp?=
 =?us-ascii?Q?3dkO4Qp3vGAOTXYBT4PdhHFkYeB9ZEIMBa6M7mgh9JtkHlf4mt49WWrB/MAA?=
 =?us-ascii?Q?aJplcaoUWLLBGDGAWcgO2zlS+No+6rtX1IL34LQyvDbYDv77+X4UStooeK7x?=
 =?us-ascii?Q?VuSZwZKdA0MRi/oPoezPtJkP9Jvca9d9VHqJDl7OTuJ42UEiMRHgrJK8816A?=
 =?us-ascii?Q?gCLnYQY88HuphsxJ+u46Byupuoevc8y4HvglRgMVEt0jt2N6MlarWJ+fDDsX?=
 =?us-ascii?Q?Fq1hx3qwrSlv8BGiw4XyHQzougkDKlIE0oKQ4bs9h4X2Hdl98HhgkMLeICLf?=
 =?us-ascii?Q?JCSjxuusEbBbpriO2hVaVIvgW/ey4eurSOw//hxlkHNVRZ9TZcY7pBXrWU5p?=
 =?us-ascii?Q?weB3pVyQbN8KKgz5QpXgr47VHeyNCBxpJn9p6NRf4LeUkKI/7goS2wt6niHy?=
 =?us-ascii?Q?r6FLxQiMx6EpiY6JmqNrdWwkPVPLbBTKOYQiOtOhAsBEja5tL2KZKiSFuhR9?=
 =?us-ascii?Q?wngGSurcn2Wuaq3Dh+8t6Q7A2jD7XqS7Y7Nx5foznxTcUYAC8+p+EboYHjVo?=
 =?us-ascii?Q?KA9Jmg2C1S1fZ70miDeqddKx/Eny2HNiklT+kupH4PicAD/Zapp4IhDpkyTV?=
 =?us-ascii?Q?O5qyJi1udRbqemmSOn5jpld9sP/Bpqk7fIfKQ1EeNFQOb29pJmJLp50u+Aon?=
 =?us-ascii?Q?MimGKb7s5SsgfL0JgexxDhMUpLi3X3VRWgOUh4rTFbX7CVCXzh/k6gca8gIa?=
 =?us-ascii?Q?EhMbM6J7ZeedbXz73M5gKcQFmKey50jNLyrKmbLd8g3xpP6UuKmDHF1/ndDW?=
 =?us-ascii?Q?Esb6BTLqIp+9G10BsoNimsRpnZIlsYaJRgMmwbAQ/vUsZD8+J8vHDHgf7KJe?=
 =?us-ascii?Q?0lBUT75KbPBmPVMihn6FsxLFnYyTBpc+AMNHOYxPBlYGWi5wFCGuEAk1GyOp?=
 =?us-ascii?Q?rjO/sgjTGUaOO+kbfyOGZrLPQNNy6kNh241bYc5uxm0pzipVS45zPK/tKQtz?=
 =?us-ascii?Q?7spDuWWEc+87OMW3UtFwKxe16BZ/7sv3RWTRm8Do8IejNVb2/ylYlYA9kcXZ?=
 =?us-ascii?Q?YZGkQlYfirVmsqKFopQJPppPeLUgp3QLM5F3Z9crFpmAN8zs070ZLE8PRC03?=
 =?us-ascii?Q?ds2qZh+yovi3JvJopa4E4yeNZ0kQhEqmBYbuHdtr+R/pFFXlOgZ3ojfpu8jo?=
 =?us-ascii?Q?fgSSQ1JzPLENDuvExraWd7wH6Qp8VZb6t0K8vQQIHdxlq/AwdpkNHhk0XXNR?=
 =?us-ascii?Q?2619sH+CVpv4iosaHkM85CD8C92/mYhvJ5cmqFk7NG3duoNZ9PstGOddRkOy?=
 =?us-ascii?Q?5joZSeOcb1cnYMuhcgdxyEf2oTRoV5iL7W/mGBxlNpYo45LVcpEg8UEDM2lb?=
 =?us-ascii?Q?sF30nvI411QxmbC4WN6wlKY4Ba1DGtkgjTjIKyyjT5xriAsKNBCiOXrETsfK?=
X-MS-Exchange-AntiSpam-MessageData-1: /sbaz7FS7VPfT9EEj5M+/kxfdE/2MhiZv98=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acbb3d7e-60d4-4d74-28d4-08de84e8fd30
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 12:22:15.0579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G62Vf23DQfzumcd0M1qlotRMDe31M6UAy/h4bviUDFCy7mJ+C8hwmoUlXRqSgDjVvShDZB5+QCdKtEthsWA3t8yT+8e6nSCYp4MuzI6lfPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5830
X-Rspamd-Queue-Id: 4F30B20007
X-Stat-Signature: 1hn3kqsjb9a1oogwcws6kkuy6eay7tcf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773836622-439697
X-HE-Meta: U2FsdGVkX18WuHnYjYM6RXla13QSBPTeBZ2uLWEaSEEOiv/2nFUK6GRU5rezRGrxlubX8aplwr4Vm4sd3aAXcxRzX6cKcSObhHs+mLnL8zCypMRaLqroFbbve+WrwEy+BLQywxsTLyPZ9pPk/i/EoTTEL1WhJpnlDSxACjXFvRWsT0xuYmDAmj6+DfYLZk/YqVGiUR/BCzIASCQgQl8xOrxMGacmRfd/vKjiZkB65Jr3BpTsqGEnzBMmWuf1Z4lPj6UxshsvZ03Lmj2ChVs6C4J00YVEtSreyHsZcz3r8Sg7tlgtfnyNT7dDjUOtWbln9+AaaTAew8Te5JjbQ+2yEzz1iBn94WMmiHQnf4EcUylrjU5M+vRyPcZTZAnlJq0F3QpY+XQcH5c0ARxCRnT/hh6w7yizumg4oidK3zKYlSkGZdb60ppW2wQVXkp1aFw6IUj9Y4g2sU9dczWc8TGrFQKl9/ZVvN/x4VwbHucEA8f1eOtdbj4pHXX5ZNzWoZ0lwogeOa9734h0qO2NXFD4HzIyBdyPXIqGal2G/EC9KjoLSqxVGdniXGXEXDkIzjcv1tDDKZ1F5IYmvawC1LC+8v94ZAzQ5l8mzKgYd6VMQZOhQYbkbpVuo8t86z3NYZe8HFsDmcZtyE+HcFuBeuQ7Pfevr28MqcxXSOW+ZlWjB0V00XBJxz+4u5CmTfzaDwfyCxKHbXo8NrR5ONmchZobFY5gytnK2BTEKRxU0Ng3T0Q8tt0g/Kts+GEsJb+RDrJ2zvYHv6yCgIToClvWFMC4Nq9FTRmWqIMxWbmHQyTgp1f1feS7/6gewNNdguDr0vrizPZUbrFx1AzW3hVxCoeLoXPFGYku8H5PcN7mAiefr2NCyCK4p00bmTDy3QnuKFJZB3U2RD3V+fqANFglsoF/YiASqDqNgoC8hIe64ktqDpQHT6HKYDeJAYysF3U0xkTU7E7HSOqYUa1WiNhBJQb
 yMWZscWP
 ymoiayF/Q5vs5x/fSXqkVPwHPysVZgWqUcagzM4ClC1H6YSbR60kax9tvJENydRELPyciqj7oPkN/XuhpXxgyyKVxHWz/BI+Af55U55LAaEXZott2jHRqngpM173KybuKejzkPyauLHjIgD+E4qqTPonqGyJrNJBIHhoATc8bYheYkM+3z1eUkxTcfujgWBfsOZYQnJYrbT/Z4ASfb3P+dvkR2IiMsNnlL8j+w2QxB6/cx9YIUSul+wypJEwnoVXrKiD6sl18Glb98g8CDgn/tctc5c2MPtPvooP9tToYXTfbfNVv+OdaqjPbOy8frAUovrKE4COmC+sTzZ3uRVMdxrQw7DN8ORH/tXYcYAHzQUqiLqIyM6fFxj7EdJDHh3OQU+NQaU8lp1uS3QRcNf/bBdjcBnZabHhy/wqkXPruBJA3f75KA/tG5ibZfIMbmSGFUxDoBCWzLHRVA2RO6sLnyemMKf3msY6LKUm+91F6sWhXIEI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Christian Brauner as a mainstainer.
Add myself as a reviewer.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

--
v6: New patch.
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d7241695df96..215b805d4321 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20766,6 +20766,13 @@ K:	(?i)pidfd
 K:	(?i)clone3
 K:	\b(clone_args|kernel_clone_args)\b
 
+PID NAMESPACE: TEST INIT CREATION VIA SETNS
+M:	Christian Brauner <christian@brauner.io>
+R:	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	tools/testing/selftests/pid_namespace/pidns_init_via_setns.c
+
 PIN CONTROL SUBSYSTEM
 M:	Linus Walleij <linusw@kernel.org>
 L:	linux-gpio@vger.kernel.org
-- 
2.53.0


