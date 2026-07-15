Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD3FC4450E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C268F6B008A; Wed, 15 Jul 2026 14:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD77B6B008C; Wed, 15 Jul 2026 14:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5736B0092; Wed, 15 Jul 2026 14:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FBF36B008A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:05:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A401212025C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:43 +0000 (UTC)
X-FDA: 84991788966.24.767CD23
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022141.outbound.protection.outlook.com [52.101.43.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id AF6A520006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=bm6EncYm;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.43.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O95DtUyWMD06oTaLiZwi3Wfcr5BYuVUIdsRaM8li0Hc=;
	b=And/3crNtCeIcuYwl8hWZPK4EzoDl2GI2e4L0fISioYohxJRQQBD9tgJx+/rcr4W4C1qad
	2qU94yrNTbBfExldWw5r0PAjU+OOrFMW6CxoWmtCio7hGOoJl4eBErO9UqiwWljVLlty0g
	VwUqklFbWOtkVFZHxaDyiBtgGRNQMWk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=bm6EncYm;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.43.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784138740;
	b=6ZWzvFhbGNrtqR2lSkcHLwveIBvPZpkN8DT62t94NOIYZzNW/AqU/VIov7dmyiCkFI8V/l
	k0GopIPRX7pvTEvavyXrDhmdO6wN4R83qYn+ChWC5Tv2HFS3UXtCdwaNiMJH+ioaPDf0t+
	vNlZVvzDOskt9HqMksLe3cTPVAF5OWQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=babKOyGQQMgbxo91XOOC/3fzWzL/e6dYwH4OmlIYcjd4h/s67zWFZtf/XkHoMVnzmKZ3XQSQ9LfT/T038TJ3TkO4MbsAY9TmbFhxUnR8kEpLpm0xTFQvDuz+LpY/m6W7+Yk6QpY6Wb6psxAw5IqOYnee8zLPG12RtAczSJelGUt+PWzw82v4OlQMj9obDaX4OpS/NXM3LUGjm5o8RCugRlfAUsbFy55SuWfMU/bNhUDy+sMkkOiDiJs2Cd2Wf/QVG4hBktRbvrtHldIrHM6qhq8L+8cENtDsqEeFiBosj8ljwoDk90FQ/8YPVcPj45Q68/4sxs356MiRoUXfV+yCew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O95DtUyWMD06oTaLiZwi3Wfcr5BYuVUIdsRaM8li0Hc=;
 b=toMkkY8IA7+fyKfc5Ue3iVi0IK1A1gCKdgveP8pOCEUFpT+JQYDSrHPBNcOA1J+GSIw0WLCEecu1bpjSaFfvucDewJe8dj0ZocB+ExXCrTNdaviyWGngz/kwveoZC+5nTsbiammauj3U2KiwHg7twYff6anIb2QtOJkiWNioslU5zLoTYFSuiWcJqJKEJq5CmpxVCt0ukdEmxCht+AcJlqpyf1tLvJtoXjthw/F/TPVV6I9wa9TgpmTOcJqL30oHDW6SpJ2wuCK9crqoWXQFrBCer9aTm9I4FfUw/POzi/JVMiUlEsb79JlmGeBgAov/5jVTf6aJxuEZ+6xNkQ6MUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O95DtUyWMD06oTaLiZwi3Wfcr5BYuVUIdsRaM8li0Hc=;
 b=bm6EncYmjxMGikeRVTIW6ZzqHaAP8h8ZSmZr2Zkdyie3+fiWgymGI7rWyncl0VV2Z1pFph7T9HatiboOajO+wvFYnfTwauJSEQPPnIjbZvg0VaNd6T3vHCTMK2Aix0kOg3y8YodILfX9+Ggc4P6T+Rx04QM3EpquOjwX3HTBRno=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SJ0PR01MB6207.prod.exchangelabs.com (2603:10b6:a03:29d::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Wed, 15 Jul 2026 18:05:33 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 18:05:33 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 01/16] drivers: arch_numa: move percpu set up code to arch
Date: Wed, 15 Jul 2026 11:04:03 -0700
Message-ID: <20260715180455.515692-2-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260715180455.515692-1-yang@os.amperecomputing.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYZPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:930:89::18) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|SJ0PR01MB6207:EE_
X-MS-Office365-Filtering-Correlation-Id: 77476de8-d454-4c8f-99ad-08dee29ba9df
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|56012099006|11063799006|55112099003|18002099003|22082099003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	D2hNM/4PizZy/K7QwQIL5esPR4UJ0y8ULXnNrJ6lqj0UPwTAK2p4/nDyiKiXHYDsYy2YlIMCj3WgwHa2qn/o5TJ4tYhOGaZE0OZZbBI6TpwmRr8IXZYJaZmXgfJcoDbOdKukIzF3JpL6mHxc1d0ON3fk2x4nIqDSufX8cTIcIGrsy8e/8o1nX+LUXrFH7ONB8DRpP2HVUoQLXBwPJkZEl3NkVVvsf0gpLH587TrWxciKOOSJ16wOH4JB9rKjvdqu/dqThSPRDO0FuNR2oWcPWZZRIsYwgLmhE+YsiSBm+WUVaXE8102dumKXzPp3WDZVpKfmX48kQQY67r2MYvQ2yuVA9AGYLbbKVBhioM3eepT+L3k5uIG7zjL7jxmSOMsjsqIq064JRgGCT3vrtemdZth8+87ZzAlkRq0T5htlIYhBhSBlx6FjJ56iBoNkRoCRJztBzr5urGsZ1oMkHtiucMx7by1pWWqoexZWijmrtZUZzeVIgWQZvvlECJNC4tePtPX+hSRkMXkp/U3Sc0VtxBe+niNH5CvVxPMno3cm1LJJcu3+yQ4H7CrQwX/bpZe5Eb4S7d6Sfvs2UX2VDTzlCE4Nt1Sail2zTOGo0p1BrC9uFf5qft3AlI0iaFzH2UCtUrBNlNj5MQkj1Mxm3v6ts5z8XdUlACsnU0oO3L85nFNp7gHQmUIBOActflC35Eflb6IbSc5q8y5fGrawAnqKQg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(56012099006)(11063799006)(55112099003)(18002099003)(22082099003)(10067099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S4MBncjgk2i5Y5IbCFgPPDjipknOA+BYcWeN5SDMMnHlh4og2D3OK23bN9MF?=
 =?us-ascii?Q?k7wBWAcxU4Q6wdgCkb11+kbN25Bd3Mb3e8MNEo4sskMXkhoy93FgKhSX/eyN?=
 =?us-ascii?Q?rALLy7EDxKlMq+jJe8f4FhvGED508PnGpql8QYYIUD8OahH66GyNxM8QlLO/?=
 =?us-ascii?Q?ijlcr0gXlPkm8fLOEtmgs2OtGE7iEfWES4ZAodiv4CLJ118hN8aaYqXrOI3q?=
 =?us-ascii?Q?m/j8lLjCgYic+gGTGj3T2pTBPVLss9K0RuucO6e3S+Wx9XA+e+wudtIbLgc7?=
 =?us-ascii?Q?nlTJvPoNADlV9xcihQrO1jahlYpbve2iC5lMFY7b4NyDufhTMbXjPMKtibTC?=
 =?us-ascii?Q?AaQG8Qr/3B9ia3VfvAOWN7pOK0yRpxdeM8tH4OS0DXcGSspvBNVEK0r/k9S1?=
 =?us-ascii?Q?v/aUGEJvs6W9ZYb9H0f5Oya3+DVV5NU4uQL0NqaSyJWPZWTdQpr2Usqtr7FE?=
 =?us-ascii?Q?Q/irTxGbiPyiUsZL4wJGhsY8feJzuOl4q1d3qSwEmprlg+7+nLJNHKjwcOS0?=
 =?us-ascii?Q?c4Sf7tsCmZPjtP9vNGCekuOfUzc/q3NfKWu2nzh7MG338ZzreUbzjDyJNZV1?=
 =?us-ascii?Q?rwiMwuu+4eJD0yNSfEtaP2WC6GJm4e/92Ug4KgITI044y3vkf51VTve97Y6A?=
 =?us-ascii?Q?GVCcUtQDIBHex5jU1olGarWSnMnEDOv3yoorvGn6mdG4VS88NOHKNS/UuT0D?=
 =?us-ascii?Q?d4tbrpxOHlMTkGd0Ysnu6ukeQ8/WYI9GlRG7AgOk5f8ZkOgTDRdiwhmTPuQi?=
 =?us-ascii?Q?v6coX3pyvwm5uLZe1KXZ/i/gFj7HS3UT8H07kIRPEugQsksRc+DeIKlQPoAd?=
 =?us-ascii?Q?tiZGlj3Kvaa2rubdToLKZC/B4l6Hho/meDjpn4QB51ivp+1m3GbGjetzT4CY?=
 =?us-ascii?Q?D4s+efTOrOT9syCrvl0B3bDz2ik5W5TU9YL4B4syp9EM1pBz3GszP0FI5ezG?=
 =?us-ascii?Q?fkjSipmDF2P1gYtL9iGbkwc9QOBiX/8KyjjCmCnXFcf1sGwig3sjPepB+qMD?=
 =?us-ascii?Q?UwmQOPgQO31vz3I+vrnGU0NRD9yjmgPBlUBae9Vn06/f0vjk9GKuqoBlfam8?=
 =?us-ascii?Q?UjopD6SyHC7C49T4Ntze61uJNtYB3/G5HS7xXmsYx/AH62JlHkIznhc4Ay+y?=
 =?us-ascii?Q?r3X0sezXH/ITb7ubtjchebYN4pCIqWwk6bmSj9GXLvLm7P0xKlrQF/xtyg8N?=
 =?us-ascii?Q?53POyZ1lq5hA/Ay39VEx9GSXJyPmW3NcpD9JOWo1jTXLVAxfctIrLCg4IzHy?=
 =?us-ascii?Q?milpKUZVFCG3y+Bw9GIkoBYUfue9JHJqrU/tNgsNF2n0q6bLQtoEfYI6d993?=
 =?us-ascii?Q?3o+/RP1QcqVNOz1PrTrM4h5Wf2YAI0SDq+8TLU4D+pepFvDgNiqBbSJXCNFW?=
 =?us-ascii?Q?P8PrLXZyadSbGMTkP/QI0EMov/E3IvoTfnCo16QQo7s4GMketzDwqbmIDVRv?=
 =?us-ascii?Q?UK1ozbYXJMxv/Xk5DmD1mfWUrAHIzaPMwJ734O9HlNH+/cnzY9d5dK3UfKPV?=
 =?us-ascii?Q?lO6StnTObUrg2MHefoF5qGZ0PO4XjrB6lUoSrlzXNYHKTBfQT1b7O+16oXOq?=
 =?us-ascii?Q?ctsi/PYBEIWu3JZTbYyZ0TLxc3FojkJ40I6KqOMrQpbFJP9W7X7x+LJVUrT5?=
 =?us-ascii?Q?nHpx76QoBhaReEHGAsE2akQw7HkVsc9uQrZU41fwSeU4p4ttZek+GmaPv5rL?=
 =?us-ascii?Q?nMdTHdgHwpNP7NCWjkTj2NtQSEjJeSE7ZOaWTKNUkDqexg5Pxs4GDpeG+F4k?=
 =?us-ascii?Q?9WQC2HSbZY1LoUM8Gh0xynpQCKrbOHA=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77476de8-d454-4c8f-99ad-08dee29ba9df
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 18:05:33.1955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v+cyxQYtqolkkjEtSoewvPMy301RIW8VyQbWUztK0/zNolfj4iFIWFps6epSqn18Vmoi8l+z6HUQ3YtIPEppMcicrAd74SEy8LfY4TgHjXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6207
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AF6A520006
X-Stat-Signature: cyxub1uu9mic7jogi9i7p61acmhstuwo
X-HE-Tag: 1784138740-718696
X-HE-Meta: U2FsdGVkX19j/R/NVeXvE0xGtsauaKGQeW+ppxsnFm3IP6dDeUZYkN2krH+w8mxa90TCr1EMZkmwx2hC5a3Rb9O2j1gScNTYvl2K4d3gQpFP3SRui5ULL3NZwqf33wDw9dCGPK99m9/KdYzPnsdYkbwISbvhz9anOjY0kGXabwX3W7P9hy5nVe+OuoGZpmVs1U+VzzpqDsxBLMJUMVBdquOj1KGbtypCmq4rtiasq4r0M2MwPDCciefH04ykfAV5LabSv98POrHeYXNTsm6LCuhqCB38uLAM+4/eI9XrCQv5dKOEsyutE17D3VBI4BYS3es3jDY/k+P4F5xZzxYC5r/s0xOx8/wesady3u0DaTz+xePrAGfweg7Yx3jAA+eqdBZ0DF+3U/6veS/DP6PQks4yutzVsBlYAIOXvpLMbgQ0ZKgsAm4qF/dde9UrGUM92fD4KD8GJs6d2o/a2Fw5bBAPKV4Q3q6BAy5A8NBKQv/5uckaZzfIMGR7SFlkaozMdK95tba/4zqY1HxPzuTD2pVTCxHZ8J+h2LvZvZTazEqkIl3UNrVvB0qHuwfe2gffepqIcIr+2Jvu9/PPHlx69AH/eal7Sj7/MOcQKUDiuTXwptC5k4uuRVT+84BSWUTRhfVw+Zi4QyNGiyl9dahPVEnhLkIOpndhBNZYQY2hAYc0pez3cPy1rGfpop5B1kyjSXT2yZDDG8wxU6cgPkFlBR4PXCQ9/2ry3lGUtmlkPJchxr3b7Nn/TDdFV5o0t0VPbMZ5z6YDXY6qBVeWBxaLM36jGnMe0wEx03IiC9GYSduzDur1wXXFAVbbqSIcrcQOJnQXtyTliPMLJ73RxkAecEZeNgYaucjYFJUNJu5Zw8fgaL+gvUUSMR5oitvJGQvlfFHxT21RoCGDXxxjXAbRQBuGKVDqK8ojpv/pWIbVHzgGEgSGZ7GtgbM62qC1Ruto+idHVxIYDckAMfEXe/C
 NZpH8kp+
 qnGYoVXTZ7QMexkANwKnsp9x4HvrJhpOCuag/JgMKKIrl/5zAReD0eeuhH79Mjfl/r4gF83U/jN3SXkCk55y4kvkyvm3OjDm34HZ+3Cvs6De5Uv8K3HtHRNcrDwtbdBFP/U3fo0F7HWwNQxrmDOK+fqKfL5RHYm2kNQSkASIcL+ehC/26wm2exKu1zOtkhiGbibDedjSzCcWm5plzzfFwvrmOffNsnTQAqSsy6hEkCI4/VI0ros81oV179+PgsGED9lp3eBJFl9Gzhkn3qSufW+kug/mEHMgnXTtNhMtj6L9b0513x++QemaIJqb8Jh3DaniUiE2XlTbPP3viMKEHOIJHJLllGdGV+ONvdOAh7dJ8s8bv/dxVN/FDP/1SIochG+yi5usxuKDRAcllAoebQB675g00tbXuwglefu2mb4AlJ1N4U3OfxzQXx3A/C7N1ejKgjFns5UF8Ys089akxuhoYuUAeHuR2lhWMmxD+i5g3hVH1ZHUEyz1S5WbMXmn9+QfYm5LehJ8nmLSVkvIWvAqCE1n10r6E5l+dGP4jqwoNo4FnTicP/3V4mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following patches will need to modify it to set up local percpu area
on arm64 so the generic code won't work anymore. ARM64 and RISCV are the
only users, so move the code to their own kernel/smp.c file.

We can't leave the generic code in arch_numa.c because both ARM64 and
RISCV select CONFIG_GENERIC_ARCH_NUMA, so it will result in multiple
definition problem.

There is no functional change.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/kernel/smp.c  | 51 ++++++++++++++++++++++++++++++++++++++++
 arch/riscv/kernel/smp.c  | 51 ++++++++++++++++++++++++++++++++++++++++
 drivers/base/arch_numa.c | 51 +---------------------------------------
 3 files changed, 103 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index d46022f72075..0dab4e9c97e4 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -819,6 +819,57 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	}
 }
 
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
+extern int cpu_to_node_map[NR_CPUS];
+
+unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
+EXPORT_SYMBOL(__per_cpu_offset);
+
+int early_cpu_to_node(int cpu)
+{
+	return cpu_to_node_map[cpu];
+}
+
+static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
+{
+	return node_distance(early_cpu_to_node(from), early_cpu_to_node(to));
+}
+
+void __init setup_per_cpu_areas(void)
+{
+	unsigned long delta;
+	unsigned int cpu;
+	int rc = -EINVAL;
+
+	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
+		/*
+		 * Always reserve area for module percpu variables.  That's
+		 * what the legacy allocator did.
+		 */
+		rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
+					    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE,
+					    pcpu_cpu_distance,
+					    early_cpu_to_node);
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+		if (rc < 0)
+			pr_warn("PERCPU: %s allocator failed (%d), falling back to page size\n",
+				   pcpu_fc_names[pcpu_chosen_fc], rc);
+#endif
+	}
+
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+	if (rc < 0)
+		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE, early_cpu_to_node);
+#endif
+	if (rc < 0)
+		panic("Failed to initialize percpu areas (err=%d).", rc);
+
+	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
+	for_each_possible_cpu(cpu)
+		__per_cpu_offset[cpu] = delta + pcpu_unit_offsets[cpu];
+}
+#endif
+
 static const char *ipi_types[MAX_IPI] __tracepoint_string = {
 	[IPI_RESCHEDULE]	= "Rescheduling interrupts",
 	[IPI_CALL_FUNC]		= "Function call interrupts",
diff --git a/arch/riscv/kernel/smp.c b/arch/riscv/kernel/smp.c
index fa66f9c97d74..d420ff9dcf4f 100644
--- a/arch/riscv/kernel/smp.c
+++ b/arch/riscv/kernel/smp.c
@@ -364,3 +364,54 @@ void kgdb_roundup_cpus(void)
 	}
 }
 #endif
+
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
+extern int cpu_to_node_map[NR_CPUS];
+
+unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
+EXPORT_SYMBOL(__per_cpu_offset);
+
+int early_cpu_to_node(int cpu)
+{
+	return cpu_to_node_map[cpu];
+}
+
+static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
+{
+	return node_distance(early_cpu_to_node(from), early_cpu_to_node(to));
+}
+
+void __init setup_per_cpu_areas(void)
+{
+	unsigned long delta;
+	unsigned int cpu;
+	int rc = -EINVAL;
+
+	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
+		/*
+		 * Always reserve area for module percpu variables.  That's
+		 * what the legacy allocator did.
+		 */
+		rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
+					    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE,
+					    pcpu_cpu_distance,
+					    early_cpu_to_node);
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+		if (rc < 0)
+			pr_warn("PERCPU: %s allocator failed (%d), falling back to page size\n",
+				   pcpu_fc_names[pcpu_chosen_fc], rc);
+#endif
+	}
+
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+	if (rc < 0)
+		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE, early_cpu_to_node);
+#endif
+	if (rc < 0)
+		panic("Failed to initialize percpu areas (err=%d).", rc);
+
+	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
+	for_each_possible_cpu(cpu)
+		__per_cpu_offset[cpu] = delta + pcpu_unit_offsets[cpu];
+}
+#endif
diff --git a/drivers/base/arch_numa.c b/drivers/base/arch_numa.c
index c99f2ab105e5..b3b91ceed6a9 100644
--- a/drivers/base/arch_numa.c
+++ b/drivers/base/arch_numa.c
@@ -16,7 +16,7 @@
 
 #include <asm/sections.h>
 
-static int cpu_to_node_map[NR_CPUS] = { [0 ... NR_CPUS-1] = NUMA_NO_NODE };
+int cpu_to_node_map[NR_CPUS] = { [0 ... NR_CPUS-1] = NUMA_NO_NODE };
 
 bool numa_off;
 
@@ -140,55 +140,6 @@ void __init early_map_cpu_to_node(unsigned int cpu, int nid)
 		set_cpu_numa_node(cpu, nid);
 }
 
-#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
-unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
-EXPORT_SYMBOL(__per_cpu_offset);
-
-int early_cpu_to_node(int cpu)
-{
-	return cpu_to_node_map[cpu];
-}
-
-static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
-{
-	return node_distance(early_cpu_to_node(from), early_cpu_to_node(to));
-}
-
-void __init setup_per_cpu_areas(void)
-{
-	unsigned long delta;
-	unsigned int cpu;
-	int rc = -EINVAL;
-
-	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
-		/*
-		 * Always reserve area for module percpu variables.  That's
-		 * what the legacy allocator did.
-		 */
-		rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
-					    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE,
-					    pcpu_cpu_distance,
-					    early_cpu_to_node);
-#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
-		if (rc < 0)
-			pr_warn("PERCPU: %s allocator failed (%d), falling back to page size\n",
-				   pcpu_fc_names[pcpu_chosen_fc], rc);
-#endif
-	}
-
-#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
-	if (rc < 0)
-		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE, early_cpu_to_node);
-#endif
-	if (rc < 0)
-		panic("Failed to initialize percpu areas (err=%d).", rc);
-
-	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
-	for_each_possible_cpu(cpu)
-		__per_cpu_offset[cpu] = delta + pcpu_unit_offsets[cpu];
-}
-#endif
-
 /*
  * Initialize NODE_DATA for a node on the local memory
  */
-- 
2.47.0


