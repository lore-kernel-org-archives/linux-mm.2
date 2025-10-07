Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF57CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 06:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F4EC8E000C; Tue,  7 Oct 2025 02:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC878E0005; Tue,  7 Oct 2025 02:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494B68E000C; Tue,  7 Oct 2025 02:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 351AD8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 02:18:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3457BB58A
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:18:07 +0000 (UTC)
X-FDA: 83970313014.04.2C0742C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 639E48000F
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:18:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MGHMc8iU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JoFRvaUb;
	spf=pass (imf02.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759817883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwLLhW8jhFtdvq5XRHiGOp1gf7iyxym3enzYxE155XI=;
	b=bm/C3hIBu9ggdaVNOQIHanCegyFskBNuouP9RlsUjZaxLfM6iiwOstJa5OQYh2/xDDr8J0
	FGs1qbtX40XEwmuACramPp+HI/YFlFmEyl+XhCSFVraT+tFYS1p790a5kR9GicgQ6wvaaG
	pXwvK9cL+PZl98Xh+S7T1Chyra/QWec=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MGHMc8iU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JoFRvaUb;
	spf=pass (imf02.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759817883; a=rsa-sha256;
	cv=pass;
	b=0v68X2un4HH1cbqch1W0FFwukwLkGO17MhBbqWtyvOcrQvPn/NuWOiStkvwOSEAYq5dzxR
	YHoArz6jr/wQHyj+K+EBS2yKaLK/iMbdkAhwxG9G61/nC7Sus1auUHZZ2ZPO56+Aa3606P
	T0Sbi6HVzrHKoP+CBqr8oEaWnYyYzdQ=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5975e15N026292;
	Tue, 7 Oct 2025 06:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jwLLhW8jhFtdvq5XRH
	iGOp1gf7iyxym3enzYxE155XI=; b=MGHMc8iU1+dbWsT7EoY3PNncdohWFa1Q/h
	eK+Af0eSd4M7zW7LQhJBZlYpE9pZYuYjlpvYQXKem+keCoVSgR/0C27C+D/57VmB
	CIYx8asEdIYIpb3FLK3jN3e6UT+cAjrrqfyZFv8taVC6MT2R4EQ5TaU61W5sYCKl
	tD9JqK8e6FzDJ6sNPHTNpkUOdIKswKlgdue+XnkL14zBSLnaqowJkInKnUb5IA4w
	VsXAx4qGK1RN8qjO3HoOgExBFXvhtgbXNJGHgD3NxDM6gBCd+kc2tgYEVEvVGifs
	hLM2+tKUsDRzctFBjB/rgLFbyFCUnVc/zJKuDx0K7GmHskTVlb+g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49mvwf0276-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 06:17:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5975u3Ox029855;
	Tue, 7 Oct 2025 06:17:39 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010067.outbound.protection.outlook.com [52.101.56.67])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49jt17scvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 06:17:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r3MazOPYDoX9pqNbhz7LQ72vtRvJckAr0qCl0it3T6gwAXEDHX/BSQWq8TvE5YL/R+5FsEWnq1P0dAWApQr4U0YhBkPKUIhWBEWh8xN8LAXzZQ4DLnran7EHxMddyP+xxXUOgZ8Xa63lxlTaz/S+uzZo0j+rnRLGhg/1yEDdDEakVo2VFkOHOI6+JqDI7UkNY9LaVpsdorNZVsumQzf3LxMhPFTw54iKdVDLNV2aEnrE5x2VCAwTMnSFWYsAzfsuesYCsGfm8wShxOJzt+To04QwcY2N0mAQpKuOqhY9aWGTpNKlwZjeg6aNJaqyxN7tPkJM58QM7icHX1aY+PAOcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwLLhW8jhFtdvq5XRHiGOp1gf7iyxym3enzYxE155XI=;
 b=g7J2tYm3umHEpj8HWrYiOzbmA8ZNfh9vKDZgnP4+Sacf8YN4P2z00z/8E4T1F0yqFvuJoS1k7KVrDeiJjeqJV8KbSCLUTZE87mlHGJPeEKsuuYlCJxpIAHCYja0n4CBGIga7RcfLaZd1DsloYs+Xr26C9HJn9lO8Um+eDFJ+V77lVSm4gSgYngWULIzLQdH/BIYI5kQZB99sx5cg1JV8kmvIHkZYzHvRWMeupWGzPcI8Gx40s4hxH0j45Y2+h7DcEVkwJ+kOFQ7WAK46z8SF+QKzuX5zu0lSXJnaBy2F3YQqgqvRihAO6zrtlB2GEfudfb8KAmGscdvWzmyoypkcfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwLLhW8jhFtdvq5XRHiGOp1gf7iyxym3enzYxE155XI=;
 b=JoFRvaUbSonYYPr7cns1tPOdXv6ocZBYkOsBPhW6+nw4Hu/OiUDcV8SPk/lJSFNVrWVMnSvZDE5LHpDIVnU9nFyJy5xuzBbWOS4tcz66M5my8wguNqGp3DMjjGXtyPdnigL+UN+qXyThBp9ZHpyTBCIi27qgZNYfcNNt05tS5oc=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA1PR10MB6784.namprd10.prod.outlook.com (2603:10b6:208:428::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 06:17:32 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9160.015; Tue, 7 Oct 2025
 06:17:32 +0000
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-14-ankur.a.arora@oracle.com>
 <20250917144418.25cb9117d64b32cb0c7908d9@linux-foundation.org>
 <02da5912-b77e-42fa-be1c-d10c915730d2@amd.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Raghavendra K T <rkodsara@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ankur Arora
 <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v7 13/16] mm: memory: support clearing page ranges
In-reply-to: <02da5912-b77e-42fa-be1c-d10c915730d2@amd.com>
Date: Mon, 06 Oct 2025 23:17:31 -0700
Message-ID: <871pnfgrr8.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:303:8f::19) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA1PR10MB6784:EE_
X-MS-Office365-Filtering-Correlation-Id: cccb230e-c785-40eb-2a4c-08de05693333
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r1oHu4wnxrws36nx5GZrY0X37PhOMoXoxzlEMCrXe1tkZ5LOPcyqAaJZx5kM?=
 =?us-ascii?Q?7Pkgo5GskdD2zKeZQRGaIOPbsi2Qwl5yypOE0gYaoqSw2hZqvUfpf0U92J0C?=
 =?us-ascii?Q?d+3HDqAvQ10dnb8byq2qIaZOjHnWp6MdktrxRZSp3fodmg1GAAtgPwaquX/R?=
 =?us-ascii?Q?BOuBEVTEvst0jLXREO5QYvuoBHJu1ie/ua12ht6p3XMLSfQYR3kP0P0yVdjD?=
 =?us-ascii?Q?TCZdRHjZQHxlHq/HTB3sfNGE781Qd/pmMzYQRiTmdu7fKFTKchIENNnOqdHm?=
 =?us-ascii?Q?T9asQbl2AzYzJB6LiLjheAj4xcgZnnc+Sxkh8eehbK/6Eriot0pgD9ZJrS2N?=
 =?us-ascii?Q?xiQhy6YeTk5XH9UwKDRU+gLxnNqo3NtdgPSJyMXkUThQMs7KOV+11vYiEQve?=
 =?us-ascii?Q?D8A7RDjg1ZYW8AYqx5zfeXmqCleRWUnDtR6KXv8t96iEDm2YlOWF6viEmPTN?=
 =?us-ascii?Q?/E0CGsU+KBFLFerFWlq2dJ5DnBuIJH3Whkqmcw2gjguhk2AocBm2+h8tfOY/?=
 =?us-ascii?Q?2CPyIWmZUIjwiAakKwIhZlD8DPhuz+TlzMNT3IxeXS1FW2U85/DuSntq40cn?=
 =?us-ascii?Q?EkBjjOYorebncLcsU+/ZAnt22fHarKpTrEjyJBB41iE/bEy+HxmJmHUKb0zs?=
 =?us-ascii?Q?4eZqqnBDj/lHsZ4O74rHOl8ouGJjgJfxvFOPYx1Ib0kWrHgTPShgoGQHsb4z?=
 =?us-ascii?Q?LpKdQEzOUrxpUyk30ylZPXgScJ1Hz0sJ6bjrPh0sOSmu8YCe8obHrzyDtiQ4?=
 =?us-ascii?Q?KybUzrG2Tbr7pII3/9nSiULG7OWdQSDGTKyPNVdku9ISoDmtUDd9W+Fv9SOK?=
 =?us-ascii?Q?TUi95iiqZYRC5IaKdJjVp1alJkAuTCKLViIDA9Upp6Tm6EbxSMhYeG2VHyPP?=
 =?us-ascii?Q?nXFLiqIrwnQ5Ny2hilTZZ86Kl+9mSxY5wsgI8kx5lTOf+1WyQb3heQQz5RAy?=
 =?us-ascii?Q?SexN6GBVXScSrk3Kmhp6CuYX6WEgTeOr/Unynov4KppH7N0t10++rGYTr/ci?=
 =?us-ascii?Q?hilIq77/emYTve12H+Iv2LhiFAEOce2oBw9E0zoZF6DI1PbFMe6UDZTTniZ8?=
 =?us-ascii?Q?mTFqSWreq6XYvvdcXpu0UYSoiu0BKDbQWQFd/T2OXAIxQ5Gw+0gEwaF6DONO?=
 =?us-ascii?Q?LkzLrJFLCgX8fVkRCvqfA2E7SvJZsDdo8whEUwRAa95HI2z03kvO6J48rm5t?=
 =?us-ascii?Q?q/YY2tdk1I4yNCbMLAQlqW27ilyG7GlpEHqDAiP/FIsQ0Zb6v/dbMoFVp6/C?=
 =?us-ascii?Q?VMfZ2EIQx7V0hbhRQm8GMcEOE6YL37X7P2GxtYoO9irxZRHapTw7sPFqk6+2?=
 =?us-ascii?Q?uzbeO2Bp2NFeS0V93wVL2axqwlT33XPUGkHh8CoMVKIOboHaOZpxEmd4dmYv?=
 =?us-ascii?Q?IsMxQsJJZTShITdICBNUOVw1hB3RD9lyUsH/8Osm42E4k+C24EwiEgKJj/KT?=
 =?us-ascii?Q?o0AmVtMCzgl7LB6465Uw+os6bwBMI/xQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yt1agFXx6cxLG0Xth5p0ViQFK4MMCCy+qqOidala6vZ4PPnUDQose0g1x7LQ?=
 =?us-ascii?Q?2vDN0o9JeoIaYTskAqHXWQuIS/vLm+FLLMnXGBNE62egvdILS9CcPFyMBJwb?=
 =?us-ascii?Q?yyNSJRpM5EUjlOpqZAXRwWpPuCzw07y5tutuHXchcXE/pATLUhmfP7jJ9G18?=
 =?us-ascii?Q?eq94Fnx7TkyEoZ2rOwnDVitE7WLSmIJtd+/GjkYTOT3AaVEWKy9/5Iwja3jt?=
 =?us-ascii?Q?zcCfSV+T31xzkd2UOsZnX2fr4KW9QXS0UXEuU73FLFNOW184YE0OFwAqI3Da?=
 =?us-ascii?Q?zwGdzHLItJl9NUlFLzXMrVjn9nxiaiEhiiJiyitiq82ApGCpbtuB0x5RaswM?=
 =?us-ascii?Q?/5Qu7NrQeyO+7Hom29l7Ynmj+FPVT9GndF0j1l5sCgZX/5lXV3OlteJXmWTK?=
 =?us-ascii?Q?4NBF6wNDAazbkAoToB0Tf8NMEAt5CzxpCkz1jTStKRyLLbmZlvtkiTUJ8vU+?=
 =?us-ascii?Q?+cmbZPCEMGxRL9GENEhFMHWmBZOckC77jZ85j5cuBoskO6/tkYWwkwYRh1Dj?=
 =?us-ascii?Q?RYl3mn5/J4yEBmWCcliWB+a1BH3PWgou10bnRxkvagjvHDABg1sEb1ZIp4HP?=
 =?us-ascii?Q?2gqX5/YKLcX2aK4rl6M/x3DUFoY45Mv8p2kSy8aC+Kk9QbxH5RfKt9VmE2X7?=
 =?us-ascii?Q?XE59HmnUASZNVsm8F/wUB9dFmZ2m/1e2KHUj1ZGXWnqigXCzEOgf6eZqpufu?=
 =?us-ascii?Q?r/VMAcKocUc25DUklidppr2vWAhzxkPm3AIEQx09Qhb0CQrkrfKaGzidljyD?=
 =?us-ascii?Q?J6FQYIpOjTyDYOMlWTB0BJ2y2dj2KMhU+/YcXEG2BBwcVJqZx+V3snxoMcyX?=
 =?us-ascii?Q?KScw1F5i0tw0eHo0CCZ3pQKNsaiy5Ihc4kCgMOsnbIM7TUt5z1SYR36mI1S+?=
 =?us-ascii?Q?uuTBmYT3Im2YqbRQq2bF4qxU7lLATQDMrx4hkL6FzfZakvM/YomiNs8dFmJJ?=
 =?us-ascii?Q?Qn05jzEKQzEIr02fulbYRMTLbfJcA14HwNYZShBCGW/4O51hy8x9IAUV9Ny7?=
 =?us-ascii?Q?hW/sao18HSUefFe/vKMP2Vfzmw6nk/+FI7w89lXN8Cwnio7PUf7XaIyesI1x?=
 =?us-ascii?Q?pF2JuUSpOl4UJHXVWdLyS/mLaM4fljMTbkgRkdx8t8ElXM6c05MsvyL9Ie8P?=
 =?us-ascii?Q?M4AqTW+DIBggJY1ZY7ObFhPrf0Es12NFtRS0dZCaYWkgJh8zxkwpAVcA7plc?=
 =?us-ascii?Q?Vmga1m/NzcP1sZzfDuk3dZN0/9MoICEpk5olEu6wmTjS9EtQ90ZCzw90q7X6?=
 =?us-ascii?Q?DUeBuXT9RPQo5MQgD59dGjhEmLjskLHjCfxsp30iMro3N4R0NFAmhZYuw7xO?=
 =?us-ascii?Q?pMjEVGlV4p0K4a1UYSAIY34CcNafQGo0PZq6Vo3q5e8ACmWIlzGcLyXzJKwV?=
 =?us-ascii?Q?SygqbAflD2QtjEAgGrBpy/ywI3QAJkCXZZd2p/Xc58kkslgwlyWAigEIzNAn?=
 =?us-ascii?Q?BkLSP65Lt1jpvj0XM5ZpntNCbmWMpdz5mhM6uDLRfUJBHa7CVYUblw/DKt1t?=
 =?us-ascii?Q?4R5AA3pQxo4bMqxXyycfNWgwdKktSgY0HP/rHOPlf2N4mb+HGP4UBAt5c9YJ?=
 =?us-ascii?Q?UKrnzf3THgw7rj44PxAzYUiVKXVsryzEgNVpCO/5LD3F7VRCzFPeTCnk9trM?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X18Id5mzn+0U5YbqGzIM0ojLO08CASx2R2H8LnAurOjdW5QhzHz0hIdw8OLeFlbym5150cfQKS6RmTqzLcMlvNiDjVtM5VQUiB1ue2g4J3sgZXZ1hlUx4iS6UBkT9YynW/+6HY65qu0Az62TdxTKYRXnPeztfxREQjT7mSoMB6l37tFcsxzWbbpNjtHbxCli6iLgpZtuygLWL5VhQ2A2SQ+sXS6fmJEsqs/gVFT5vUksDd+Hg0t6uG1p6pOtLNiA6zwpdWr0QI+ga604r3zgf7YyegICdTYO4oO04WRbzYJ/BMwRPLbIwFZLEuOmyJ5B3I3VrNYfPn4FkGjJizda5iagzKuIB8Ts5wQSA6lkicjpkXaJ4lOov3YaUxk7BaVJcb3gjAKp3nvgDRw3AX+Fii21wus5HVvUnq3mAHmVFQVFqZPjp1slX4N+aqmr/VWR55OLFkGMvXf4od2wcDX5byJd/KTfSn/WI7ZHlR2AIhnMIoQ6nKAhkY9nizEOqhhuM54suO7JiyCdPkNMYYszu88LiX4qpFAqoK1FsGsklht3h1o9vlyGLrrVBBqsPz2FeaTT2RD8UpB+fJvUXVHYbOGeak9CVporoeVLyP5TD0o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cccb230e-c785-40eb-2a4c-08de05693333
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 06:17:32.7124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C4XgS2cMV6LVl+T2eSHBed8v6JS2wkuRkT2EZCkr5/vuNlt0RuThKSUNq2mYqDfhY4OYFuNhODrq9NpV8VWxXHcXn4rtW+g/IbOgzwXTT00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510070048
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDA0MyBTYWx0ZWRfX5979PSJjHTke
 8KEIVFRegs2dz0w+0iY5QD9uo08Ur45bwsxBnq1vpZ3j9gX7TtEfU5f/qQQX1pxc4EW9Y9KeaOg
 6i8ecA7NbEWUdWBwe6p0m5zTvCmz3UPkcEh3DH7GKJFkp2yAEjqUxcS9Rf4jsCuaSORuFLRYyLc
 TKfHkcgOQ2SMJhjamjwR1M5k+zmYUYdu6MEItZZEMBC4avqIXMZOjJVc8IZtQMAqekIQHNBW9S/
 43h90zzhbJRFNYI5SGst0OahUNhFg7yZg+eYeYIsjV2NZPbEEg/C7MmUxOFHomWwx1ys96zWWMz
 bKWiymDsZoygjFl23kC5MEUTnaszjgtIJDsvSjnI2EgJEeE604x61BOv+PQWiJemyDJa+z3CAno
 Ya8BXtEAEvlXmHDA2qg7ZdEaQIW65eMERVN8RoBlHpsPm/o3+TE=
X-Proofpoint-ORIG-GUID: 7NnEx7-uLqRWKP_F9aJJNQTK-KxnBjD3
X-Proofpoint-GUID: 7NnEx7-uLqRWKP_F9aJJNQTK-KxnBjD3
X-Authority-Analysis: v=2.4 cv=PMcCOPqC c=1 sm=1 tr=0 ts=68e4b085 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=zd2uoN0lAAAA:8 a=yPCof4ZbAAAA:8 a=_OrDgAD2IhgNzo2bdpcA:9
 cc=ntf awl=host:13625
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 639E48000F
X-Stat-Signature: p4x7hw3d411it9n65db5uhufaqd3e5ua
X-Rspam-User: 
X-HE-Tag: 1759817883-257682
X-HE-Meta: U2FsdGVkX1+UYYTn+cNFCH8hQ/XFXSYSoIM4CYBTgbAjFdZ7h0MatzDJ1wzM+t3sIM5OCHokzd5GE8i4UPV1WIKivHkAXY3PEpzGt4gJbDZiBX8CFpYYvWWGgML5XVG6+t5vr3W+dIDzQyrsLbYx+bKBKCjVbp7erR5oI/VXZY6lHxVa3Bl7Ck0BWYiq3s+ILY0MEWA6ags+4UIONc1TU4MhI84GxSCm6MS7XZ/3Z/NJaCj4xZM2iXMCkl/xk87L6IXfVZTrVHgV7xPwz3WJ4MljP+DosYV86nIBfoOGLzE0bNAvznJB7EoDA25/uWGeXBe72CN7cWG/swBps6dxH8dsWX2M7/cHVvYrQTK9mrOqqAd5vZeILxeV3PZUffgU65NWIKAHLSxKbxh35KcbfmXp7Updu0UNb9zkfp3KOOZNTGhjMGJZxt5UaNnCfXXG55gYS3KTiwZEVXCDdC7NuF2RJbT/+zxJbIc7EtXnZ2bkVu1X9ujpY6PCbeKG2NEEAxcqWQicIkLo6cm13OJYpMccaEWhr2zpBR6JXTfLzfY5zVdGBKhL/ABf681n30FcNV90w7pmJwFZAE/rMZIfTWoSHsQN894+x1WJevt7y5fTZWeaapv+cVeV1UzibjD8VYotja3nmJIm2ZG0BUkW4mTd5jx1+gKy1wjSgcLQM2hssRbAK2g75xX/v5KS+i54+rw+A/LUh9a6rQXTsRu8JxQvAQJCLXqPr/eQFrA0lYdilNWhkP9WcB0MJlhMeIETgAhyVRv4tr/yCXXI94JiIRj2vtII/x/i4UBYddbgczzp/VhS5Yw33nKF2d046YKfqoP2muVgrCy4UOo62ifFG5ybJkW2TYtS/TQhwdYGLmC94/Cm6lYKQildWKE4KrplOPgvsCPrw3JUDwQln4BQo5ctQp7PecF/Yx8j5rnEn1/DrYsX2XRSmh78aTNadkGi8v0RlaeAq7nJjsz6Fhk
 WieHyhLN
 fsmaM6a+aYKIqPx5C4/iarEynSZEp2Ih8CQqBkvCjAm5KjOVcxDsKnKcRNBzrNTa5hmuWiIDKO7WcVfGdWqNPO/mb14If6C3zvkc+p0Hw/LUb4KDRRNDBoADKtsqMBHGESRU94rndDU+7Z0o5UQ2RXq4JlxTVvaywut+wTyz3UkCHN1g1beY3Uu6B3cnd52K+5sI1Smb9w942gqi+OiloKCmiszSuDy2HnIheUpRqKIzF1Ta1eW1TW4fMsgaC4XeEHEAAELiZxzjiUOkMdB9IcOJgJunhzSALEB2pv/tZcHiLQ/EO27SAfbUt29aSxMJVOWQG6k4WztXLQhOspLQ0lgcLATkY284FErtiop5cPfThzlRWmqKSim03h0f452U9n515Rwb56Y3r61+lvIvf8nxjdKn7ZJf1TwWihzbyYYocbQV5L+ZYQ3fV55y2YsfVDBso9HMpJ9hbL1jQhozY9K858rgyTOptdduX+pA/oQ5aC0WIg7LhCDHIkpub5HAshGhVfpCffSNWU4xkPiO775v5S548nYXgMK/bTTx6OH4Fri4gMXeS9Rxt9tw62kHUUkU567YACn2hequ1c/0pOsRx6uDlYiiQqxJdluhxy5/Z1aBQpOeeakeJzBnCXYhekx04
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Raghavendra K T <rkodsara@amd.com> writes:

> On 9/18/2025 3:14 AM, Andrew Morton wrote:
>> On Wed, 17 Sep 2025 08:24:15 -0700 Ankur Arora <ankur.a.arora@oracle.com> wrote:
>>
>>> Change folio_zero_user() to clear contiguous page ranges instead of
>>> clearing using the current page-at-a-time approach. Exposing the largest
>>> feasible length can be useful in enabling processors to optimize based
>>> on extent.
>> This patch is something which MM developers might care to take a closer
>> look at.
>>
>>> However, clearing in large chunks can have two problems:
>>>
>>>   - cache locality when clearing small folios (< MAX_ORDER_NR_PAGES)
>>>     (larger folios don't have any expectation of cache locality).
>>>
>>>   - preemption latency when clearing large folios.
>>>
>>> Handle the first by splitting the clearing in three parts: the
>>> faulting page and its immediate locality, its left and right
>>> regions; with the local neighbourhood cleared last.
>> Has this optimization been shown to be beneficial?
>> If so, are you able to share some measurements?
>> If not, maybe it should be removed?
>>
>
> I reverted the effect of this patch by hard coding
>
> #define PAGE_CONTIG_NR 1
>
> I see that benefit for voluntary kernel is lost without this change
>
> (for rep stosb)
>
> with PAGE_CONTIG_NR equivalent to 8MB
>
> Preempt mode: voluntary
>
> # Running 'mem/mmap' benchmark:
> # function 'demand' (Demand loaded mmap())
> # Copying 64GB bytes ...
>
>       34.533414 GB/sec
>
>
> with PAGE_CONTIG_NR equivalent to 4KB
>
> # Running 'mem/mmap' benchmark:
> # function 'demand' (Demand loaded mmap())
> # Copying 64GB bytes ...
>
>       20.766059 GB/sec
>
> For now (barring David's recommendations),
> feel free to add
>
> Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>

Thanks Raghu.

--
ankur

