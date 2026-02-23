Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D31EC1128
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 20:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5852A6B0005; Mon, 23 Feb 2026 15:03:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532AB6B0089; Mon, 23 Feb 2026 15:03:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DCED6B008A; Mon, 23 Feb 2026 15:03:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 264126B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:03:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6D26C165A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:03:11 +0000 (UTC)
X-FDA: 84476795382.12.7968DB7
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021103.outbound.protection.outlook.com [52.101.65.103])
	by imf29.hostedemail.com (Postfix) with ESMTP id 07BD8120015
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:03:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=cCIDwskw;
	spf=pass (imf29.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.65.103 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771876989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZS98U/d8Hs+wz0rfwYbr50BDDbbvblM5BB5NFk0IGUo=;
	b=oyKxp3v5K1dCeX1BYN05DYKnpZdWR42hCV+7MDkOuDsL6dB1eC9j+SrAYuseppERml6W6J
	OKgteaO/vHeFkx8Xt4NzzsJMV0xkVs12KgfMQyNCZzOj4VqACb/YAzFtZktGyWp7FGbYwe
	hZ0lI3ud2nIPkXfd8Yw/pqMqT8GQcwU=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=cCIDwskw;
	spf=pass (imf29.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.65.103 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771876989; a=rsa-sha256;
	cv=pass;
	b=QJVWfJbQGo+Fb/YFW+wMhPZH3zAVC4Po2n2wPxkWmzExaeoZEBGF3ocb7CGqOEjOKKNxwE
	cBZAjwpfUZ510VZnzBdvW4D/nowqP4B+VPDViyer8OqVdTDE/Iix8EJfoHnm+YHqKDndZO
	xrBPUwmpNIhPmUNOySewuUSf0S68Xs8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mEXjpNVQ/1WwLbnNC5PirWCi07qP22LaTElntZ0SDw28zWKM3GxrxIOfmo0P6Po7IZy4Qgl6QtoW4Iejq/yQ9o6Qmk+h4j79xTJktbXn3vYYvWVZgF9F+AAJZLjfDRF5Q4VrMdgQUOPPDB32NqyDTLZ1qlYpyY4q5HevxY2UacuwibVQuhMrQuJyg5uL0jWr7Ta2mtTcVuw/Tjuv+4AdsjyXm5Vbf3VCQH6L0kR0kIWw0p2qZapADV2bqEkBNa/pCWHpzIVg3nQAEZ1jAU6qrNR1rd5+3FDhVllxcgBzkxh8gahki4WBBimssAiMG36JwCGPv6zVMGWNZOm+evbfOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZS98U/d8Hs+wz0rfwYbr50BDDbbvblM5BB5NFk0IGUo=;
 b=esMBS4lztNZVksN3bCz/ISGj/U7xx/0KugjYl2CgzMlNrr/nm9YzkIKtelVdEZeONP5DHCmbGYUvy4bW8PDrW82/wb7VjfnNOfbXbViykfBFxxY9dbNSUJimo6RME1VLbSu/ecQXZwkgZXJUv3cMrJUiQoKQsQE8wS4FfwhwEwOv6UkQofTPoaW4cGi+zyKkjKd4qfOv+k8zQAuXQMpF+QTA7HLf9fIoNvv/YgGf/4ugxlFawrPTgwHNA7tixEj6BB6oAvmy1ixze99ddtKLTuUPyrmjRZ5ZMHyvTEJnkhUdTmJ+zhNrpiwS3XXnHpKa4D6xmYfxSpxHff+C8CeJZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZS98U/d8Hs+wz0rfwYbr50BDDbbvblM5BB5NFk0IGUo=;
 b=cCIDwskwxRedNs6ZowTJgIVgMJQ3ka/X4Ax+ToL4deodMYONHAXsX0Wy1jzEKXF3QuF1LdVDm4WV21D2SUIwtV885q15GSk7xpwK4eGhnBiwu4BmLY99RSo3PG71UGh7NntKFaTD0jEhe1Ac6VJ2orS6CLpEMWeVRvxa4fX7JINZX1VrmR6mo/yMIaPJuFhMq0u4pxEyS697RLRQX9S8G1kn4RzDFr7dLT3h+i9NYqrzznJblR5XNHSxxVlqktlTj4HGf54AbfRyu2jvS2kavfjtnU8lz6NOr2jJ5iOHxeS+OK+9F3/6jkDleAGd98536rOHc6qPAZzZ88uPNwWkfw==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by AS8PR08MB8874.eurprd08.prod.outlook.com (2603:10a6:20b:5b8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 20:03:03 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 20:03:03 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 0/2] pid_namespace: make init creation more flexible
Date: Mon, 23 Feb 2026 21:01:21 +0100
Message-ID: <20260223200254.4104651-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::8) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|AS8PR08MB8874:EE_
X-MS-Office365-Filtering-Correlation-Id: 89e3be37-4d67-4def-45cd-08de73168d5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|52116014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y3pqODJGRytGSjU3SlkxajkvTWNyMXg3alBtamdLTmw5TEdSVFljUlNuOWpV?=
 =?utf-8?B?N2VzRG5COEpRSm9QbU1WZm8raVJGZGkvbDJNcTIraFdmODdCbmdJOFVlY2Uy?=
 =?utf-8?B?d2ZBTTdMMHhwRUUxNVJ4UCtXbllBdXpUWldxRy9YWVBmZzZCejBiYkVaaWJv?=
 =?utf-8?B?endUM1d6WEM2UThpdytCY1k5TUZEMnRhK1pIck4vMDFMWm9KNFkwaFJTNEZS?=
 =?utf-8?B?aHo0d2QyM3ZESlA4T0RsOVVIbEptb2pkWnlxZ1F4bzRhdGlHUmd6QTFQbWp2?=
 =?utf-8?B?Y0Z3WWdvbVg4TkdsZE0vTWdaa3d3bTB4bkJsNjNFbEFhc3NIUzhrMEpEc0RN?=
 =?utf-8?B?WVhYUjNGK085ZmVuZlIrODQ0cGpmWnhISE9iZnFQWk4yWDZxNllpbmJkcFdZ?=
 =?utf-8?B?bC9BQVM4dkpCMmppVUo4Y3lSQWNMRmoxTVg1U09uRUlmMzdCa3puSnNTc2Q3?=
 =?utf-8?B?QjNQemtxSnM5UmNKT1JNU0lOWVAzdVVQK2h2Q01pNUxqaEh2cDR6Zm1SKzdm?=
 =?utf-8?B?NXpaK2pjVzMya3Z0ZUs1dldJOGtCd004U3ZUdHJlMDlxYnJsTUF0WCtFcUFS?=
 =?utf-8?B?OEdQaEZSUzFBOTNZSitrY3FUM0FKV1BOTCs3bC9kSzlaaWlTdGt6MjNUa2tm?=
 =?utf-8?B?UFF2eWdPaUJPMG40RHhSQlBMUGxhUkpJY05MdjI2SjNrUUwvYXIyMTZnZ0dS?=
 =?utf-8?B?eTRzT0xLcTB0Um55ZElvaVIxeWs5ek0zVFdBUHE4MmQrOVZOTU4wZjBNU2Zm?=
 =?utf-8?B?TUFTMlREK3lvbFpoWFhaL3duVGptZlIrOUlJVm9EN1hleFp2cEdQU0N4MkxD?=
 =?utf-8?B?cXNYSkRTekdIc243eC91ZEdWWWNxNmJwYlhwaEdydytvUS9yd3FzemR0aHN6?=
 =?utf-8?B?SGpPN3N5Z1VUelFQV25VUVFZWGxwaGxaUFR3K1k1LzY1TlZIVllqdVpwYlNN?=
 =?utf-8?B?UjhjVUlZRStjclV2NFZKNHRrQ1BNd1BkS2orVi9Wd3VWYTVtZTBaNDVuamxJ?=
 =?utf-8?B?bEtnVitoK3R5TDRFM1c1UGVndy81dmJkVmE1SGhVdHVZcEtqWE9lSkJxSTQ3?=
 =?utf-8?B?MzZ1c1MzYVJtOWtnSXJPSS82cUJSeWRVcHp4dFBQUzRkSDFuODYrTFZVN0xM?=
 =?utf-8?B?a25XaXN2dEZ4TmcrMUNnS25MTHlpb044UThyTmFFS2swb2VrUklUSmwwMy9D?=
 =?utf-8?B?UFg0ejhWSWJDVXZPVWtnTE9XTjlqUTBxWUlRYVJMOGpEbmsrVmhMalljeFFo?=
 =?utf-8?B?Y2hhS01tQ3I5MU42VEJPK0RCUm00WkZCQUVzZHo0VUlucVFVbnZEbzUrWk1w?=
 =?utf-8?B?RTNxeVdFK1hyS3E1MUdmeDRXd0kwckNiWTJ5cFRQYnN2WVhhRFhDSUVJTTNC?=
 =?utf-8?B?dFBvMWNvek94eUV3a25lRWFhZEhnYVFURms2QStpcVFURzlHQ01mamdESmhn?=
 =?utf-8?B?QUx2R21GUHhTeVgzcmZqRTRBL1MyQXcyYTZMSk5UM3Z5T0xoaUw4YTNtRE9Z?=
 =?utf-8?B?YUdiRUNOSVl3MmtldXhFeGNyTFVHM0lrY0xkSVRiSkd3QldzZTZVMUg0YUYx?=
 =?utf-8?B?eGtEQWNHZFlDcGpjdzNralQ2Z0tiRzc5c3RiLzh2eEZOaXdMTnRFM3RGV1dn?=
 =?utf-8?B?ZFc3dTg1NkVGdkFNMGZ5NGMyVUlLSzVpY0g4cTV4SGh6NkcwMGNENlFMQkky?=
 =?utf-8?B?bjdpVlJBUzZ1QkJVVzVVbWExQUJyWGdyTHFnbE1DQWlBQzM4ZG81ZWVGUzU2?=
 =?utf-8?B?dmZpZlkva0QzZFZvY0JUS3g2TUp2YlBKcE5CdDZUK1dYSXU4bzZYRnlaZElZ?=
 =?utf-8?B?NkQwcEJZbEM0anIyakcvYzRsbEphWWVyRC93bU9MRFUzQUpGMzNIWHRvVDJE?=
 =?utf-8?B?c1VBeXc4VEgrK2g4TnVNV0g0TzdZdngxOEVaUkZrMFErSmltbjYyV1oyTTY0?=
 =?utf-8?B?NVBIdXVQMTVUZ2t3QXhJUkh1b0wwQ2syYXlicW5HV1VkWnFkbzdma09KR3pv?=
 =?utf-8?B?UVVWWFJVV0krUU1YZ1ZIUUtMMC9BRjJoUDV6cWZnTzhqTWMxanJOdGFQWDJH?=
 =?utf-8?B?Vng3TlQwUnhVNFpGSnRuRWd5YjRIWmlaMDZ5VE42U0RkRkdPVFZQMGZCNndn?=
 =?utf-8?Q?8tvQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(52116014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHk0WTRpTStpOGpRbmdOY0F0SzV1RkZPY1RlbmN2a3dZTU1kSGZZcENhM212?=
 =?utf-8?B?ODJ0Q2JhRVl6OVoxM1F3dy9KUFppY2krYkZxeFQrUWg0MndDclgvTElsZjA5?=
 =?utf-8?B?NmE5Mi9MRzV1b2c5OTRFaEUrNmV5a0RFODVTVHVQTnM4cEs4ZDU0dzdIeS9Z?=
 =?utf-8?B?Sk9GZFhqcHA4MlBtY3FpWk1rbE9VRWYvZHg2c3pLM25nbzlub1o0TWVkUS9F?=
 =?utf-8?B?cVl3UlhvYTZUVmZTbytjVEFFNUhobzQ1dm5yZnJzZEljalNUdnNYZkZHWmcy?=
 =?utf-8?B?WnFMMnA2K0tMaXcwTDR6TVJ0WDhpazdJc3BkR1luM0VsdW1ZV0Y1MW5PUDdS?=
 =?utf-8?B?SEp6ZldTWWE1dHBWS2tSVVhFVktFMi9WaFA2UFhvdnVVMk80UXpqTktJbkdz?=
 =?utf-8?B?UmRHckxSeWcwcStaQTFJVDY5bUxkUWpPbHVmWDN2WjdxUFBuYS92SW5USlZv?=
 =?utf-8?B?bHJDTzAwRGU2dzBhN2RlYThYdDdiQnk5RmJJRE5UN3I0TzZYSEFpUXV2OWJI?=
 =?utf-8?B?eUtzSjQvT0JkL0ZiVFc4SUY2K0lZeWpyTHl0WFR4N2ZSbkRxYVBkekk1T3Rm?=
 =?utf-8?B?aUNiZ2VnaDROK2VEdVArQkJ3TjJOMnpNVWpRNDVrK2lIa04yMHJNZHpiZkl5?=
 =?utf-8?B?Skh4c1hDZVdLbTJPQVZ4R1VxVFBNb0U3ZkJzOUgvWkhDQjM5WUs3UzRaRGtO?=
 =?utf-8?B?NnBqKzhRcWNFODIwMjZFNS9pZnVLMGRxNnNldFJCN3RXVzhZeENYbEc5b20v?=
 =?utf-8?B?NnZ2SHJKT2oyay85aXFkVytrODgwN09zTFhJcU5EU3RrZGE5aEVrSGdMcmxY?=
 =?utf-8?B?SndsejcxdWJleXNnT2lnQVpEalJqM2lkS0hSL3I2UExac0ZiOUxrSE91Mytt?=
 =?utf-8?B?Nmk1OXZYS2VDRVppTGVpMTVDR1oxVmxLYkQ2aE9lM1QwSVRDYTZpZkg5UnU4?=
 =?utf-8?B?Q1VZYnlrWTRXTGppcUwzTFBjUkVISEp4WDBEOW5vcjlLVWgzVGZmSEE4Mk9l?=
 =?utf-8?B?azl3d1cyU3pUSnNJMFVzWHBPVFE0MTJyTHVkMld1ZVQxTWQydzZUNWJrMi9U?=
 =?utf-8?B?RG0rcVJvWG5oeThJc21lamc3ZHdyNWcrY1pObXF2blp2TmZ3a0tqcjhuelVF?=
 =?utf-8?B?akY0VEt1dFVLNjVsOTFuU2FmbEo4cXVYemF2cWo1ZnM3ZDZZbEluM2JzZDJU?=
 =?utf-8?B?NC90c2tjdERtRFdrOU9hNStKaU5wTXprM20waDNZV1A0NnkzcURMV2NraVBE?=
 =?utf-8?B?bkZ5N1BvMExPcHpmTFRSSFdnejZzb2JKeGY1SlBNMDNqM3F4M3VJd0JZMmxw?=
 =?utf-8?B?NmhEMlB3MWRjbzl0R2Z4UXVVY3lDYXU3V24vNERrUnU1VnJsNld3SlpRUGJ4?=
 =?utf-8?B?bTk3c3AyWFlxTDhSMFIvK3gwdVI4alovZWNPSFRvcUF1VG1XZFVTeEppc2No?=
 =?utf-8?B?UzZKY0dZUzRjbCswd3cwU0U4aFpJblBnRDFUV2V2QkVEbEZqZC9sWVQ0Nmhu?=
 =?utf-8?B?TnRISzZ3Sko1Z0hQcG9tWit5UnREREZjeTFLenhQQUl3Vks4OXRTaXRvUFJS?=
 =?utf-8?B?Mnd3ZFRKSm1tQ1lSSTg4K0FKVnFSWXBpMUNPTEFsTnFiWUpwdytsOXNiL0p0?=
 =?utf-8?B?ekJrZnVablVxRjNQQ0xFYWJzd01wU1FOV2w0dmZma29RdEZRbTBvaHM0UmFl?=
 =?utf-8?B?ODJxQTN2UzN1bCtoTlh1TTBGd1pYbG5qWXRQa2lTK2dWcDdGWGd1VHU0UXNI?=
 =?utf-8?B?VzA0bHNZL3Awd2ZWZmpEZUszbnlobjdsZTZxRW5rQ09GcitYM2dYVFVhakxr?=
 =?utf-8?B?VTZzUEpHK2ExaEZtVVdSdXJjejdQTDhCU0IxRTFuejd1WWtnZUtSa0htZThn?=
 =?utf-8?B?cGR3eU9zS2JIZDllTkNWUUpIQWY5ZUZRanJFZkRTemI2eFdadFlIZFlrbFFt?=
 =?utf-8?B?YTNQbm85d04rZlNRM3pEczA0Q2JEaVRiTzVkOGk4bitiUDBPeTJHa2FyNlJo?=
 =?utf-8?B?UzdFWTU5dDZzVDJtc3REd0NqWG9hODErdmd4alJKRW1vOWNnbVVub1RHbHpy?=
 =?utf-8?B?UjJkOVJtTWppMExPSGpSNlRSSWdPaGhieVFMVm90TXhFK2xEOWJnRTZyYitk?=
 =?utf-8?B?UDU2dHNYS2pkYjA2NVlnZ1FtOHI2clE2L1R6SlM2bCtoMmJtK1JYSVZLN0ov?=
 =?utf-8?B?OG1KdnZKK05nUmxFenNYQUtmL0pBYWRpMEZQT0Z1Qm5LUUhseGplRVlSY1Ey?=
 =?utf-8?B?WUNwcVF5SzlLalBVUWk4N0pLb3ZETWJVNFJPNFVBSllHVUplU1BWOEtKRmlT?=
 =?utf-8?B?SnMyNlZ5a1ZGT1JhaG13d2tsQ0R4SDE3LzNjSlpqcTFLM09xWTJ4cERRR3Bh?=
 =?utf-8?Q?bgiebA6AR0FYH8xwH8IieUFco4P9pia/U6h+StoOqvljn?=
X-MS-Exchange-AntiSpam-MessageData-1: 5O8n/WVj1qh4Wwi4moPPzSdDPU+6l47PEsc=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e3be37-4d67-4def-45cd-08de73168d5a
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 20:03:03.2283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQng08+rYdvlwGxgmXsvdAkJQ17/egyyVwKp5kkU8iIdQpOgZmFdeEf1sQtBA/lkvUHIH+EcehD0k2A9Kwu1TAzMfTY+ohc9bMHMabaiGtU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8874
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 07BD8120015
X-Stat-Signature: cw44d9dug5p1wbjr9f6j9zcafowdzm8b
X-Rspam-User: 
X-HE-Tag: 1771876988-553458
X-HE-Meta: U2FsdGVkX1/YTKuJYVY43+rgJ9pIjJeUhUBJ129rlP83TEvLzH/2roj7hYjaCP1S07CyfG6NNAMoNV6dxoJ0xRpVLMR2czDj6AjNRO45orxcjoOECf0ahyrmMZ4dJ1jH0ucAqyqeVhS+7ZU3OjzvzCZUM1ZCFOyjFb2Vf5rsR9PF2kyVBorGS1k5S20Qjdi/K/hw5YxnALbzRVbfjMfYDcslEQK9gscDwKec6jvXhC8b/Izo6VxEKLQQ2UyG6tfPYvhIYNa2mCD8ECGII0zbhItYSkwxHeTKDNzls0mSe6H/mGDmPAmeulMhMoEaBxxsiyXfRS9cGY73XmD/Hn4GBde5QXpQmop3Knla5rNEV3BPsEgBmquPsRl2e6U2a/IwXvBGhYT1MEUlTpH2YCWW4v0LQy8G/Oub5Tibb37C8e2bju9tpFojJ3GNEVcWLgUQvKe2lcm9qjlCuAAZVMghROaBu0gOaXA1q93gUmTcpRWaJkSmyCLcIWwju078ozIExbDnYwZLmNIqtu5srxbKYDujcB5cngmEf3jv8aDMFdQbXMecJVnVrZOz8XePQOpu9aEFxImUYBGnYqBColUSuf4Hi7RDgT8uXUf5MTeWG0lFnPB8w/qiPrZGk7WniShdjxe/RxFaqzrhYNyYd/fUjVGhRw0l0Gz0qzhSU6vT8IhmON9irLosgOkWm37gZ/meA13MXRXwI3DMdaIolTeRY5hnHxbKcqrNsPP9KT8F6aKW1Vy9JIL7ro7i9NBBUp/jzUsEkqiYb/x/x0GxhpQHPUKkBLrzclVkESCSnuxJNGMSsyrY+WtKVhEImG3Ksw/eXhU2fPovLLmfFComr69X0FP3rob1D2ktmvSA0wz0vtveU3QowKaTvLbI/dFV2khz9HY6WyRnWMWi8R8PAdaY0wbM/LQrcA/rmDb7cX48jYaVMgax1U6pE1sTJgy5yUY88Uf3rLhnvb6PvRwtE2H
 B7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first patch allows to join pid namespace before pid namespace init
is created, that allows to create pid namespace by one process and then
create pid namespace init from another process after setns(). Please see
the detailed description in the patch commit message.

The second patch is a comprehansive test, which tests both basic usecase
of creating pid namespace and init separately, and a more specific
usecase which shows how we can improve clone3(set_tid) usability after
this change.

This is generally useful as it makes clone3(set_tid) more universal, and
work in all the cases evenly. Also is highly useful to CRIU to handle
nested containers.

v2: Use *_ONCE for ->child_reaper accesses atomicity, and avoid taking
task_list lock for reading it. Rebase to master.

This series is also available here:
https://github.com/Snorch/linux/commits/allow-creating-pid-namespace-init-after-setns-v2/

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Pavel Tikhomirov (2):
  pid_namespace: allow opening pid_for_children before init was created
  selftests: Add tests for creating pidns init via setns

 kernel/exit.c                                 |   2 +-
 kernel/fork.c                                 |   2 +-
 kernel/pid.c                                  |   5 +-
 kernel/pid_namespace.c                        |   9 -
 .../selftests/pid_namespace/.gitignore        |   1 +
 .../testing/selftests/pid_namespace/Makefile  |   2 +-
 .../pid_namespace/pidns_init_via_setns.c      | 238 ++++++++++++++++++
 7 files changed, 245 insertions(+), 14 deletions(-)
 create mode 100644 tools/testing/selftests/pid_namespace/pidns_init_via_setns.c

-- 
2.53.0


