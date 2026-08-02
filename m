Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40C34C55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 11:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26D06B007B; Sun,  2 Aug 2026 07:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0C66B0088; Sun,  2 Aug 2026 07:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B396B008A; Sun,  2 Aug 2026 07:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3FA6B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 07:57:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C0871C0E0D
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 11:57:32 +0000 (UTC)
X-FDA: 85056179544.09.67D1CF4
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3AEFC140004
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 11:57:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=windriver.com header.s=PPS06212021 header.b=cgDUHWpo;
	spf=pass (imf26.hostedemail.com: domain of "prvs=2674b84dba=ionut.nechita@windriver.com" designates 205.220.178.238 as permitted sender) smtp.mailfrom="prvs=2674b84dba=ionut.nechita@windriver.com";
	dmarc=pass (policy=reject) header.from=windriver.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785671849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOeEXSxrgvzsVf74E5o1WcGYiLlhnSxEeFUWdkBT2Bk=;
	b=8S8NbXJIRuF6RPJ/SONwOU+4tCeEcne2faflHF/uLLKpEN9PG/BP6B2kKtY0QNj31NKa/O
	mbm6T9Ii7ZJj8J3FQwuBWCPF5v8/kHup2I2MzcL3tTSdsG+s0SnbY9ALO7PfWLnIYvutTz
	uZ7SNFvdSkXgBMG4yfKCo9DYEAQBtJU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785671849;
	b=s+WWHOYamA4bFNyFrwuhyVyaHZ9rZ+mtAcJCSHnJjr2x5qslg5D/HNgphkMFeYH5t++JKc
	mb9oL33HbvfR7cuvJ/+/q9qpIwZyf+QQ/Q+GARpEsZc9macEn1q15daWj6ckYf5sZMV9F0
	gLBInCRT75S0cmeE/+UXL57MdiSfH/Q=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=windriver.com header.s=PPS06212021 header.b=cgDUHWpo;
	spf=pass (imf26.hostedemail.com: domain of "prvs=2674b84dba=ionut.nechita@windriver.com" designates 205.220.178.238 as permitted sender) smtp.mailfrom="prvs=2674b84dba=ionut.nechita@windriver.com";
	dmarc=pass (policy=reject) header.from=windriver.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672BqIfj3140811;
	Sun, 2 Aug 2026 11:56:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=bOeEXSxrgvzsVf74E5o1WcGYiLlhnSxEeFUWdkBT2Bk=; b=
	cgDUHWpoq0k2ickuJfHLUHu64jeVjuAH5PVmii0caQ91oyWfIQtgofHLhzvF7KJQ
	iJtm3gHaAoCfXvqldaueFhruK+wvkvF0XEpT2j8VpcoKEyy0UbJX7NYOwEDDYoa0
	ZTOkQCjEG5zsBJrI+ZrMDiWWwEx1Z4ZTrkl8dzcgEQkyss/l6FwkGkWY1FjuiSra
	SC4gIeLFQcsJxuBdRmJaerd+IAVFyBW4vkN+DcNfCZdZ6++0ZMIuXQRmmAJKonqM
	r/XVWvJHL88BWdlmOJKrTI2Z9kGlJAG277l13LFWf/jHWXukUenTnpZvFfcv//ip
	DBC+qM0E9JCAryJFVPQOQA==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012013.outbound.protection.outlook.com [52.101.53.13])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fs60x1991-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 02 Aug 2026 11:56:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jkH3vhNtTHEJ6jul4N9vhr77UetZQ2Ry4I4wqz8LbYkSyNEebRPyTCvfIey/Zjd3I8sBu1vY2Tg9rghbxxq55GSa1MLln+wo9IVScKDTaz1uTVaBo7i+knBWcxAvDiJN94aFQDMt8QFk8V0f7nkuQajYFB/rlFlyhzIRKPHB0sDVohXxJZKq59UJWTwFfz2wLDaLTI5C4ubexsbug5O0IMdQaZF38f+Z4F49bSLdvLv5YdhAoRQbEngtIVBHYhASQwadd4eJXIp7+KyUddGl1IJgomRBUM3tRKmKzRqvNjPbVD8C0jgGnj5hZNMr4qHymlt7oB0YlUq/IDosG5bMwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bOeEXSxrgvzsVf74E5o1WcGYiLlhnSxEeFUWdkBT2Bk=;
 b=aTQjVVkxhFhmNhVC3UW+2llGwyuTy8pmebXx+IwLnMQPDmroIwjOkDHf4cM6mGhj5zo+PCItJlPLX5xOUuljmuDxp+Dk9CtQG2kVihYkCz6R0o/1VZOuFtR2ac9yxNA6q0dQFBELejQ+fg1ICJdSZy4g9AWoB4vN2BJ/uTFBfhMOwD50kI3CqEXalbk9FeZyqj8SL6EViPAk3ntxxuUwQgzr4iQ1ej7XDtPuCAz+HPyrmnD+eC1krVUaYovLXpXK0Sy+2VCMP/7dsSdl1RFye4yyqlaSnghjvoWkxRW1Uld8tanSoce/JAl0upiU75JbJtEkhT52BP+Mrs5DQ8SPPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by DM4PR11MB6552.namprd11.prod.outlook.com (2603:10b6:8:8f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.17; Sun, 2 Aug 2026 11:56:37 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%4]) with mapi id 15.21.0270.016; Sun, 2 Aug 2026
 11:56:36 +0000
From: Ionut Nechita <ionut.nechita@windriver.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ionut Nechita <ionut.nechita@windriver.com>,
        Frederic Weisbecker <frederic@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, bugzilla-daemon@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sched/isolation: Defer freeing of the bootmem housekeeping cpumasks
Date: Sun,  2 Aug 2026 14:56:23 +0300
Message-ID: <20260802115623.110513-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260728134016.674388f101f141362598240f@linux-foundation.org>
References: <20260728134016.674388f101f141362598240f@linux-foundation.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI4PEPF00000145.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:808:1::88d) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|DM4PR11MB6552:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d1e1663-c9d7-4e15-d974-08def08d1aba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|7416014|376014|52116014|5023799004|11063799006|56012099006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	W9XO5PpaFoI2kQi8qu24Iw38Yxdu31NgVNsnG4Ap3WRz6lwL3Isvfh30s9mC9o+/zbpP+BnorGAKe416SUYCQfXZFRK+RCogzMQGm6HtIXJsAJCwak+F/NIQYVoN3a909Mh6jJv+eqFANN0XwtZfdubgiMEIr7ESbNPoZoFMDFkxiqhuhJvPSLUA6eANHEDoEZ9c3r44yajzoDIK1yiAeJ96uAg390r6t9cFRwDXe/cDeMVnNB6hJzDDhm8MYuUuRMgsm3huCGHlazLgs4krWlCnCOT7bA0GBAMzhauXpmlzEwhphfOIlTS49P4VijE2N1W3aLBm8SWkCw/0ZtOzQbM9eV6jFfFpap08618vEExwp+d8L8ckAaZwgeBfmsIdXZuq6K6zCbGrJV1u8F1nX0skltG/ve8cJBXsGZKbA+XYhj/OdrV+WmhDJVEfxi8LRzaduaIeOkt8UjUf1dRHeEHBko7ZZjlM1U2GhHMwVYp/QbCnLr7JvrFx0XN8EPk8NXznrDofMwWQU5sn1a/K0x2zuOZLk9jr7PMt8d4QT25OU7sVouGMCZBLH5AsaNEnDIRXLQZi7+ICaY+ne40DlkUaWjgJrHAzHM6VnQXX8vaJ6cLQ6D9d6kp7u4a6o0VClKK+3ze/rZrl47JUnF4seiqJs6O4AHOVI1a2jOPb1Wk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(7416014)(376014)(52116014)(5023799004)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PyAL3S/lzzEBRmCW1QtuYa4xNYDypLIHRv746xzRHrRR48V86xNbftdJXFhh?=
 =?us-ascii?Q?uNBfE/cEtcZgM0vy6xKUpgDoC8eGVikrzfGvjTmz9v/PpPdPXQXJW9cPzBkZ?=
 =?us-ascii?Q?WkpioL0yyX1qi5a4BAlnWMK3Q2zeGNOLGLjAeYpfdEP/dCYLU/Fodx/IPtsK?=
 =?us-ascii?Q?fBbgDrRze84RZqobQ29qQE9R6A/QHUdgu+XYRUly4o04dLBsk57ldATajp8R?=
 =?us-ascii?Q?za5Js9iBkdDf8tMyAha8/E2mvef5ZOQPULTGwHcb4H1Wgwm/vIEbFMoMrhJg?=
 =?us-ascii?Q?RjKP1b2lVSAg5RSivy//kDDeXgd0KzUiCT1c7JIY/xdz3vM830iX8PCCqAcG?=
 =?us-ascii?Q?7vgWZwdI+AbtvDnvbSUcdKNUUeBgoNttzS3tjiquDjiFWbaei3o/k0nxDFpV?=
 =?us-ascii?Q?m2NufsGLJcj4OBdZ6fbN+FGx9c0hVCxkmyR2OdpeB7AC4geGWUWl8OKu+Ayr?=
 =?us-ascii?Q?Z6MkcUNZXH9X2ecjjv2Ppyc5CoAvIOfTq6d08B1mdb9yADAylk1pe5AeA7E2?=
 =?us-ascii?Q?ZMrG+oY/tidQYjEL9AMnwd1KB45PekQ4ZfixN3JJNvQEmRdGaHf6Q4yXddO7?=
 =?us-ascii?Q?qZcTS/gKIsoPb0SkLbGuftZeETdpGTRit9wGp8abbVMZlB+XdYbZai/7OBzU?=
 =?us-ascii?Q?f8CaOkMyCrmN5qaolLHGErfdYuSCXN2dhfXC9CQ1zehLHtHrCkcJuT5OLKGg?=
 =?us-ascii?Q?RAWR0yiKKJFLjXFHUAIUlZFqZIWv9mM2estV5CN5RiiL+P2E7NbTxoL70vzT?=
 =?us-ascii?Q?vSCmAngzGhwOce8uoxGDwlYkPkbEyhYVuocBDz691aOl8RcgXOHlFMhHv4NY?=
 =?us-ascii?Q?V4VDqDFEqUMpyYBF9vArVFupPZ7cQTg0lebT904OdfSchDcgdXdgXf7KFgvP?=
 =?us-ascii?Q?zgxCki18NHPEwCXR1Cl08/TTQWMTqi2ZOhlwOE2lq0u8ZBMlNaCkW/CjeXZf?=
 =?us-ascii?Q?rxPPsqqAog6lsxYHtMssZNsbecDqja6pghUuqY3T8zaIjeh8tBxTC3JsFCve?=
 =?us-ascii?Q?zWReYgfs7oOAkbtqZEsJzia7fgwso6LFVygOyrw2aZqqip7HUGf6ar0CNlbX?=
 =?us-ascii?Q?6bNAhFK6VA3JwtRv40wHhMzVBO/4LxWSEvW6JzyTZtbNJAbHsMZvKSdG1Vyn?=
 =?us-ascii?Q?PIrtMiIrDXsSdnftfW6nuRSq4A8BwyWGI0r9TkbUWfJU/toKTmEAX5OvIPYT?=
 =?us-ascii?Q?g+ts4W5U8DcDwfqEF//ltdHBWN+lTG2vduGip8qASJj9LBw/+vmDcreCKt7M?=
 =?us-ascii?Q?TG3B2RYmsZW1iZUP7MwEt0mWMMFGLoy2DBRGnXAhJpGRYpYuPuw/hZkHTAn0?=
 =?us-ascii?Q?TdstYxVgRh84VUxjMp1HdQkBkVehDsfqkefwenJ2aLj10i4xVgQgZHQVQSGq?=
 =?us-ascii?Q?jKMCN15y372vybAKxdQdxEX7E3zFpM2Ip/wbx8/QPYmEA1x9h40KBkNqEsEl?=
 =?us-ascii?Q?y4dlsnrDA6aG3hvgkwDuztl4ifmMDr3Civqqb2yBDbPYUsHmbdgvBMk7dTlA?=
 =?us-ascii?Q?qXeOUtpPdDBl3v8J1T55827ejP5BrZN4O3A4Wn0DcpjTZCGdXwxJW2KLvSV+?=
 =?us-ascii?Q?yut7frUwRsAMCmJfvBlpmtUOD8DsBo0Un6BtgZHL7mYeQYUHDqXzUy+8dKlo?=
 =?us-ascii?Q?3s7VBWDuCgXQ4hVEkVISgwTmJ3H1+vdJeUqhQsmrt1tTqfM4Hmqr1cUDIFKR?=
 =?us-ascii?Q?RQnGI9PKfXltWZYeaIFpmdBn6vRDMX+LhE5V3gQaD6RLu1w2eSUVldcKj4MK?=
 =?us-ascii?Q?00dDyUIoOcZFBpj5ye4MlbpK80ry83KdYHoILvTMsG8xCuNhdgXZZvpajryT?=
X-MS-Exchange-AntiSpam-MessageData-1: lfbrslX0dowYrjURP/dFbuBjVba/f330jZU=
X-Exchange-RoutingPolicyChecked:
	ioVf+/xQzxFYadzn1w8BInaPy+XwlSyIKeG4WPbpzZi3ZDX/5Z+bTMGB6RG/ytapNW0enLlSytsh+ehqbcwG2wmQ5iLGYwE7NPZFM9UIDmFUftOnVy3VxNV5B2IKYro3BOnZ6L9TBJq1odQUB+Mb/DHK5QLYaLDtrgQZzZmUY3ZCnCzb+o9YfAPVjdq2wMHtPu+URHOCdp+ri+9Vos87vJI4n8eOrWKP3pNGdKWitTXVOnLwakJBQ6Bs6IV7IfKJ1ZwiHNpJfTmHkCs2NhVVqQ9a+5KGmeYYDlZZX/c2Isyp0ts9nbQLnlWbKbB5V3YK6wkJet3vF7GYHjXB1KaF5g==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d1e1663-c9d7-4e15-d974-08def08d1aba
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2026 11:56:36.8217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bZG/UQyMFK1XQK3z3nFX9NtMVdPgF6STlYzLBVOfwZbMmxvgwigFbYzWrae9zOC03ZU7SVL1ZFDZY8HESpMgkIExjNAM4xrPVZPnvk+Guvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6552
X-Proofpoint-ORIG-GUID: bQZT1h8BM-dsRBQdzqUkCkajrJVhVUEL
X-Authority-Analysis: v=2.4 cv=eL8jSnp1 c=1 sm=1 tr=0 ts=6a6f307a cx=c_pps
 a=UidE1AiM3qFEYM2TBOftzg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22 a=VwQbUJbxAAAA:8
 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8 a=-13qON0VAvD1GSjSGt0A:9
 a=HkZW87K1Qel5hWWM3VKY:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: bQZT1h8BM-dsRBQdzqUkCkajrJVhVUEL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAyMDEwMyBTYWx0ZWRfX7r+wbjDt9EK/
 6snVbM3hLqyr7hsZUi9AxtF0TPW3oBt9kxRkm2jBGxuDA/FJkHPT5Lq2c7N3qNYvWl+D0XH8WWA
 TC45DEzJUjoLGVTdryf7sifs3X2zJ2zzAXBur+nLkVjsFqlXUtpcfNFyQGGuaKqXEYEq2emXRyi
 SgaZnQUqIOB4aA0OhMcvjC7OO7XAYKYXDlM7jiEliNnVYIlQM+6aBjCopuMNLxfnwdvDZkWUAFy
 ydjnzFKOMQUvBe0ymBrZ4E0AnDNOfGF3lGHrhdQtob7eyDB3YFPEHJraAq6YbC4HJjphL0BACw8
 4KHaYgtiA9W2Jd66b+TY/N0F0vc5weofkQpbhm6hbip7CtPIhJbKV1I9HsBhLWf/Q9IVIQhu+4n
 4y9dPqc7byJYK6w3c5cqN4ckMdSOvHjGdlWCNC+lzBsDp7agP8kIkNid98WaTg7+CKanFEXvEII
 VV6igYCVST6S+qp2OVw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAyMDEwMyBTYWx0ZWRfXwzBFWhDPS6ae
 wKZlxnJgxH2u/Fkn0Z1oXawaYOWa2VkCFiiS5ijQONIy1ox7peM63SlonkrYoKvqq/dKmWjKHmt
 ZDH2dGbVdK4I/+Yna9oPoRKAM1ifigZW9S02rRrcdmpfwq6SoMQQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 malwarescore=0 clxscore=1011 bulkscore=0
 adultscore=0 spamscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608020103
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3AEFC140004
X-Stat-Signature: pbo53tsi9hiu4wr8r6u7emqe5ybj9bja
X-HE-Tag: 1785671848-467718
X-HE-Meta: U2FsdGVkX1+4qyQgN/PeLzztaMx5jZvDVuNcnLU49b4ft9NaLdGyOIJo0wBgFaIPKIjywODNueAsMi0vePkiRCptfaAooRS1b7DfUJCUr6pkP/5dxUxmTn+pqzF8JwI/+NN8xyUT+mOkDx0lUWgkPd7k8rj/H3XJJFnnbjcsGwsJKcRylXf309iPBkDkku+ZKcjJSR+Ckyy3RbBQ1fBh1CYBm0s1OKWkvdvDtwa/wdRwiZcnv0v08f7+l8+Be9zA9kpp3I/pZbD5fo5WBzGJUjJAaIQ6mUVjUL0DKLscOD6MLDO/gzHhgKWkJzI91QjrNXD1k2PEYhOJjdQHCo9m+V2uv4CInq2+UUv5LnkXniGoOcBflGSZ0c2DEXqohFxTmAsirTGlzRwBxS2E+hoEQOCZSG1YBxDqEhsWyJQFW/Qo7D6s/luWZHdCE/nLtusZCKWNm1eOek8mdUicIRozS/gSf6JqJTATujO+mFanvzpwFPQHBHhM7sLljc4IXz9aCxkO/hxgSBGUe9WCVsWFGPdXrnJb19KQc5VGJawwCdauPM1zzGo7eoGbIvAF0SBRyTadlCGAZR/7sI+NCRfb3sa1+7PsCGBbGOTPkenFPXe5lmOd3z9DWiGmFm2kUAoUW+qODQ85GYZ5c8ovsdzK6+Ka7e9816uET02qr/e4er4MbekpofJ2EnZ6gw/G8sjAjn5tnlQPSlb0l3Brs93LxTRbzIsYbSvi9aCeIhIe0fFqyl77LY9ZdJCwa2jx9YN6dxq/ToTdUypYagS3c17RZ2skqwatJ+Tclk+8R8ndX7+mbLsqa2o1DP9flEjXgi3fTqHWNHStPLTrI1bbk/hiHAkoDmDB1+KG8TiOpNrt353vclTTUHQBiP74XqkhxulwzbHglhMSwesrBpZTvPucLrMsP1buucvN6gCfnCBNtjeHP4ZIcwKuntqyExOoYD+3M38sJtvJ9pA+0w724/v
 06nroAsl
 8ixcYlGMDlrGevlJ0mt97wrxb+yqyr5Mqy3cc8i1u1r5KK45quNg6mhR4+VOKLimS7zcuByRGwnHek8+uv57VvrXTs4IypzOC/YcwzRNwI+djAlZtCrzgHe+US7bwj8xOv3NUTd9xZblMgGEwy1J6YhgG/fiFf7j00D1TLww/XQGD501XLDVRIWsBsnSXZEodt9ZpJ30ihOBpoIrrSlFeEU46R4Rmw1AOsztFnV9svMtTKV3k5wReHyt5e5H+yDzOEf+GdUJWJg7gWslSc7TfwP8xV0n/SE0s3WI9mRYWYMtGz6aN4d6wn4DiWTD5a5CZSGWhFj2UFuth24gTQa0cwHWg+TCJbcfxozO5B4g0MDk3eVGNw0d8MdtVEkx140ZdW/bVGGsOFQwRdnFDZ7nW4JTIJ+5xuFfHjrkUwlnB+SkT5sTCmeJwn04XPR0uvZ/Oxhga0lGu0GNYpa0qrAuVTPsbXfJ05UjvQbgPBV1+GA2infrhaLSVacqQ4Ks6qaPzKJBPlDOKCvkG7HAsaS8th2J7EqqL+Xq6I+AUMNuCWh7gHkSr41Ky3qGXcyQM0xYjimnzBhc2WrHfpq6cDAusNPz1u0KBAAIN7Livi39nt3cBNKxNxJ+YwBx2q/exacOGUQ4RbdEGTpjQxkpzxZEIBFWDIDS89wEU0fAG/XVkoKlojrXyDs5DZApQKPBtud5RURyOSGkXBbgM87o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

housekeeping_setup() allocates the housekeeping cpumasks from memblock
while parsing the command line, long before the page allocator exists.
housekeeping_init() then reallocates them with kmalloc(), so that a later
runtime update can free the old mask with kfree(), and releases the
memblock allocations with memblock_free().

That release is not safe where it currently sits. housekeeping_init() is
called from start_kernel() after mm_core_init(), so slab_is_available()
is already true and memblock_phys_free() takes the __free_reserved_area()
path. But it is still called long before page_alloc_init_late(), so with
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y the deferred part of the memory map is
not initialized yet, and __free_reserved_area() refuses to touch it:

  Cannot free reserved memory because of deferred initialization of the memory map
  WARNING: mm/memblock.c:904 at __free_reserved_area+0xde/0xf0, CPU#0: swapper/0/0
  Call Trace:
   memblock_phys_free+0xe4/0x120
   housekeeping_init+0x149/0x170
   start_kernel+0x5b6/0x800
   x86_64_start_reservations+0x24/0x30
   x86_64_start_kernel+0xd7/0xe0
   common_startup_64+0x13e/0x151

The warning fires once per housekeeping type in use -- four splats on a
112-CPU two-socket machine booted with both isolcpus= and nohz_full= --
and taints the kernel with G W. No memory is actually lost either way:
a cpumask is much smaller than a page, so __free_reserved_area() has no
whole page to hand back to the buddy allocator in the first place.

Record the bootmem masks instead and release them from a core_initcall,
which runs after page_alloc_init_late() has initialized the deferred
memory map. early_initcall() would still be too early: kernel_init_freeable()
runs do_pre_smp_initcalls() before page_alloc_init_late().

Masks that housekeeping_init() did not manage to replace, because
kmalloc() failed, are never recorded and therefore stay live, preserving
the existing error behaviour.

Fixes: 27c3a5967f05 ("sched/isolation: Convert housekeeping cpumasks to rcu pointers")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221804
Link: https://lore.kernel.org/linux-mm/20260728134016.674388f101f141362598240f@linux-foundation.org/
Suggested-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
---
Reproduced on a Dell PowerEdge R750 (2x Xeon Gold 6330, 112 CPUs, 2 NUMA
nodes, 128 GiB) running v7.2-rc5 with PREEMPT_RT and
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y, booted with:

  rcu_nocbs=8-55,64-111 nohz_full=managed_irq,nohz,domain,8-55,64-111
  isolcpus=managed_irq,nohz,domain,8-55,64-111 kthread_cpus=0-3,56-59
  irqaffinity=4-7,60-63 rcutree.kthread_prio=21

Four splats at boot without this patch, none with it. Also build-tested
on x86_64 defconfig plus CONFIG_NO_HZ_FULL and
CONFIG_DEFERRED_STRUCT_PAGE_INIT.

The bad memblock_free() has been there since 27c3a5967f05 in v7.0, but it
only became visible in v7.1, when 59bd1d914bb5 ("memblock: warn when
freeing reserved memory before memory map is initialized") added the
WARN. Since nothing is actually leaked and the effect is a warning plus a
G W taint, I did not Cc stable -- say the word if you would rather have
it there.

I also considered Mike's second suggestion, of having housekeeping_setup()
make a single memblock allocation covering all HK_TYPE_MAX masks and
freeing that one region later. It touches more code for no additional
benefit here, so I went with the simpler variant.

 kernel/sched/isolation.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index ef152d401fe2..5c36e33bac50 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -28,6 +28,17 @@ struct housekeeping {
 
 static struct housekeeping housekeeping;
 
+/*
+ * Bootmem cpumasks that housekeeping_init() has replaced with kmalloc()ed
+ * copies. They can't be released right there: housekeeping_init() runs once
+ * the page allocator and slab are up, but before page_alloc_init_late() has
+ * initialized the deferred part of the memory map, and memblock_free() then
+ * reaches __free_reserved_area(), which refuses to touch a memory map that
+ * isn't fully initialized yet. Record them instead and release them from a
+ * core_initcall, which runs after page_alloc_init_late().
+ */
+static struct cpumask *housekeeping_bootmem_masks[HK_TYPE_MAX] __initdata;
+
 bool housekeeping_enabled(enum hk_type type)
 {
 	return !!(READ_ONCE(housekeeping.flags) & BIT(type));
@@ -189,10 +200,21 @@ void __init housekeeping_init(void)
 		WARN_ON_ONCE(cpumask_empty(omask));
 		cpumask_copy(nmask, omask);
 		RCU_INIT_POINTER(housekeeping.cpumasks[type], nmask);
-		memblock_free(omask, cpumask_size());
+		housekeeping_bootmem_masks[type] = omask;
 	}
 }
 
+static int __init housekeeping_free_bootmem_masks(void)
+{
+	enum hk_type type;
+
+	for (type = 0; type < HK_TYPE_MAX; type++)
+		memblock_free(housekeeping_bootmem_masks[type], cpumask_size());
+
+	return 0;
+}
+core_initcall(housekeeping_free_bootmem_masks);
+
 static void __init housekeeping_setup_type(enum hk_type type,
 					   cpumask_var_t housekeeping_staging)
 {

base-commit: 2d2338c93da79b3bfe4b6099a931d9468d539952
-- 
2.55.0


