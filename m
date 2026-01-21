Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CBF8C44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 18:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6E16B00BF; Wed, 21 Jan 2026 13:16:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9DDE6B00C0; Wed, 21 Jan 2026 13:16:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80A96B00C1; Wed, 21 Jan 2026 13:16:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B40DF6B00BF
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:16:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 61E908CB7A
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:16:35 +0000 (UTC)
X-FDA: 84356776350.09.B0AF12E
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012012.outbound.protection.outlook.com [52.101.53.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 82C7D14000B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:16:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NWAgF1H+;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769019392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qQSgeTN37Y4vezhW9xHWIeeXqjndxBxGk8k/1ktIG8=;
	b=vK04T+UyFGaMu/o8WxxW55pyKi1+6rNfCYL2u4QOAkoQxT8HzgK8PB8O67JfS3FNIclWw7
	Ji8StwUEDvR1mKWax1NVbO94IwbGQUxwvU+Pz1wQf2QHdS4oX4h5R5iyrPp/JsYBdXlUiB
	6nD4WOMd/YnI0bVa2gOahCK4/MDkaGY=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NWAgF1H+;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769019392; a=rsa-sha256;
	cv=pass;
	b=A+WJmj7pePoTZfWSf2tW9k5dMOsgTuMeyFKiIaN4LdTTCnoycT417TiZIBtxLlxclpVuZ5
	IIhiOty6MyknadM2YxkmuV/zio1x475Aj9Qs3GjxyD8jBA6LkV+XrGN+ZzgAcYAdRYE+UH
	fzxqjCYeC7Lrl98d0qT1qCL4A/ry29s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aNUaTotO9WaiVuXiwb43oadukGcHCVLZEbdr8/DMnPhDs0k4aC5ck0Li6Wi8OQSrr6XzObevKC5atSPF2pl2OjGWu+jkUx4iE2GIoHYOuiGMAnb+tt7IJvDbeX6ctfyk9WsA68f0UTH6k4EREjyeGYSAnewmu/HqaTtPK3d6whTKfn3aeoeSwILcODW0hTZ+6tjzzmKNnASdejJaY85FDQEeeOjh3jAp6q+F7wFE90k5JOwJ0RX4vmLzFlB5DlGLicasvuDgcGHlDHZMF8UYV853KX56IGk/HSapgD7lKQeDkp3VmqlXO7FiAzjBAY1PiCGeiWDHpWaAhamTVzGGyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8qQSgeTN37Y4vezhW9xHWIeeXqjndxBxGk8k/1ktIG8=;
 b=if9cirPm15xDL5faDshm/aaJyKzqc68X9osPgSc85llJWJ7r2JHXFUQ8g7nhalIYVLaEL6/UczadWt/qmcvMIXy9ZN32I7PJnTIm06YKFEeXaX+BGobJITYycVoNt4olkFEi5N3IzyIsoFcfI3CVXEMPSGa6zkWb+dy14dGoGXHnEeTO2/bsi6aFGR8ChaTmWqcMVjmvtGYxdom8OpcX208UevVgHlxAjlFk77CFyV3Kh7rsPcCOf8XhP8PN1rOabFF5zxRW35aPF3XePiinww99jYN+VBxcR7WURXwU+PRS1l36l3xzEh+kjkF3x2ztE4CfkW1HC26TTgsK3naCJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qQSgeTN37Y4vezhW9xHWIeeXqjndxBxGk8k/1ktIG8=;
 b=NWAgF1H+gJGevn1ajR7/CNUKOn3BcNGw9yf9nxaz8CmsjBV9l9pCvkcrNRNC/VvOOfHmHmE63NR5wFtCnXsHlsZ/9CBeAuUKSRg9ubbIldcQcqNK8X5S/cv0lMSNUvmcwWecuFvXwIyxI1QjvP/nEiMmy+8my2jZ2xTe5L35GduCfxHVgrLOR7qGJ2C4OmUSF3OLDxwmRpDj308M4gY41///+KmDw2PriTP28G1X007RR7V0NJksXX/m23rujDbfT34UCziqQX5wHesQ6WbWtCpLCY340W9ZtRSrVvL2yCSntfM2xak2Dvzw+19r4XWfLxQ6L0N9Tbt7+HqlZJfn6w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY8PR12MB7659.namprd12.prod.outlook.com (2603:10b6:930:9f::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.9; Wed, 21 Jan 2026 18:16:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 18:16:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 10/14] mm: Drop fake head checks
Date: Wed, 21 Jan 2026 13:16:23 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <28A56ACE-55E9-48A9-9EB6-696695ABB254@nvidia.com>
In-Reply-To: <20260121162253.2216580-11-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-11-kas@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR17CA0072.namprd17.prod.outlook.com
 (2603:10b6:a03:167::49) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY8PR12MB7659:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ce79a07-bb62-4d7c-ebdd-08de5919323a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4XBA6Cw+d2sBytSeZSFzG3VGhMFpKr0IpUKweghbHqg97C1TzF+0RjQurtn3?=
 =?us-ascii?Q?IVCeITLJEyDSMZ6zUfLqURND/snyzcj7gtkwTlC+GKASGRswn7fyC69XbGaS?=
 =?us-ascii?Q?uT/CpfQBfo0EmGhGg1+Abx7xTWbTGBUZ0rjq33h3XF7a7n7eEghW64cOd6wC?=
 =?us-ascii?Q?Sn/P2FQfIrgQkpQyX5vrTXEJgevGOw+umghxRLN/h0qMJeF6Wq0EtWkHBEn5?=
 =?us-ascii?Q?JtAgW7Az9CBiCn2B0Oy1BPnP7LDQECvpvNtlSBWCQhLdjg5PXcmp/BigJmgj?=
 =?us-ascii?Q?phTluUth76ik+qfJtN33/cYxjHmrpVBrFU5gDcXiQA1T8jzAkzZiN6SKUGGl?=
 =?us-ascii?Q?h/mgKXK62x+frdnmXiUOzprtqazpardsfPQAahAGJjFhWi50OjRybQQbPq5t?=
 =?us-ascii?Q?SA7GbEdRTePEy1zvwSGK7zttY1+WmO3unZMDrnF49id5qjYIyFVA5GUKOnwI?=
 =?us-ascii?Q?jtb/uYBAIl35qjVJZknZFMZEfzF9cKy3gx3W5UvCsRjdrTW9L/xnols0Df/a?=
 =?us-ascii?Q?/CypXDydq/k3qTcOXkn2WDtx8X36ecD9vFQr6a78J/j8sTKiPa7KqszxriNQ?=
 =?us-ascii?Q?tFXnu8ykK0gWvInr9VxZpYETDchl6hN+WT4woHPytAaRS6w/btRhhcUXGj/A?=
 =?us-ascii?Q?4MF7UMMdvyJPncKuHYY1Vg7BNKaIbQ5hSVfv2uD6ysuIH5XSSCXUhSeoztf6?=
 =?us-ascii?Q?hUEuXkfJHrHcaD3hphmoInTz6WFsfV8o8vRvM3pkKi9Er23NE8JXtiSc0gHT?=
 =?us-ascii?Q?mBf6A6BdOUYlSFvwqBwWoEvpOf+Yak+7LM3olQDsgvwucmsgHbL5sIetajMs?=
 =?us-ascii?Q?YK60RDWauItgniMiHDym3M6cmhh/KkGpY75bYq+I1usSXp2iZWJykpvhhyBi?=
 =?us-ascii?Q?EXQpkXiYEvFXZuYs8+ajwaThYSWttRnjXWPtc9r+F70up5l/MCMCkihvqeUh?=
 =?us-ascii?Q?jB4bwSdPBd8BwT7hhgE9NdnV2cFBOxQu7drH85pGhltcrcPo85LWUYg8GWkc?=
 =?us-ascii?Q?NGW8BificpC4XeHhNhhW5tPpzOJmLCr3hqzr4RGe/dW2f8qYdp387CrFEuf1?=
 =?us-ascii?Q?l+bTbHaUgcjOrfif975suqJeJHspnRDXHh9HyPUR3PUYM66ZROcXITKVuUDO?=
 =?us-ascii?Q?vDM1V8Fx9T0pPNGv2YXJcCHEVvXq1y85XkKkU04+iYT/iCpQCHkaCzrK1EJR?=
 =?us-ascii?Q?iQNae7JlsKNHJc/w5+oKJLMcLdMlQFWD5eKuBuSViPs7pKaI/zy9LypLATiP?=
 =?us-ascii?Q?DUYHq9IjZUsbReexh08iR5lFOOYUY0qgtE638NeFO01ELkVJMIBiV/z95H9g?=
 =?us-ascii?Q?TP27T3KzGu4KU0ZjCrFp0mo/Ntns2VWozCPitko86gIyVGgV0pfH4R0Lxqc0?=
 =?us-ascii?Q?EPP0OmBtD4l56cdRfNpx9XBw7zES9wl1xRdoBMy/CXyvasWyzhEpFqxXbYQq?=
 =?us-ascii?Q?1xl8J727VCR0mytntEz+AuYaJKWPQ+IR+RAZCGWq6ymmUf/H2LvH0RN5W9UJ?=
 =?us-ascii?Q?yoIQd5N4OqgdFfdNpCd2gOhjhS8eSENbqk3/hjC2I0I6oFIMK+01HRDl8DjM?=
 =?us-ascii?Q?v6hpSfaXwlBDuVTmXR8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ohv0cJecKRp/TZotlASKsqtAvUa3bibOi8Fy79Di77hqvIb+8fQJaEyDEXRx?=
 =?us-ascii?Q?GnU5ErBXHfCGeOGGE1hW7mxddLF9CD7Jzd/8dQGh2d7vUSCmddFRDO322bgt?=
 =?us-ascii?Q?9ei4/8lt7X05y2EMEJwdWmbJVTky76wbWZV5Ta9Q94EYB/7KtZMS/pnZPS6m?=
 =?us-ascii?Q?L79GPzppIbQpxLPAGOlF06i2ukBUqPpPfd+Ny2kVSoBTKPcxWoveiDYncXOf?=
 =?us-ascii?Q?UhDSufaNZHkZR/ifqNvILlP61Pmg9d3wFhnXB670N+a4O4Z7CK7N0JPwBfRj?=
 =?us-ascii?Q?qwjDRIFZHi8r6z5vksbF2o4ovc55fGwXCnaVOP877ZbNe6Jte15pJ41JuiFx?=
 =?us-ascii?Q?4ZfOMzqswkeoEx2VTKpn98VB2/MKWyoszpARUxhGFU6hZ+0ZPHiUFNw4isRn?=
 =?us-ascii?Q?1IR4uTNLlRf8j9mPMth4D0Gzjot3nkJ4+t3HRU1kFp5Y/pYZpLEm0aPC8gLM?=
 =?us-ascii?Q?/7YTbs0CoW+3M1mgtSlboQSmHLMfemKsszKSGZyV9qtUT6je+HmNoUkAKqL8?=
 =?us-ascii?Q?VL0JIsgqm0dU1EIwqN9XknrSKQKhmrWAQR9kJf/wNpitzfFG8nJEl/xitsPU?=
 =?us-ascii?Q?kZoQJ2U1h9vr2iD3mJjExXwi2bA4R7ARZK1W8UyyguIMEFEt6SBNIohBYaBG?=
 =?us-ascii?Q?M6Lx9fDwUdbzcztuxLx5OO3gUtCofGyUyYFgYJdAUBAyMDgsJ+SdwLkWRZBA?=
 =?us-ascii?Q?Nxwz8LuCa3LjdYi9v95mBmWpMj6ZnKOUs+3/0craUXCgX047PB8H84ilFaaW?=
 =?us-ascii?Q?dt/5hus2vriUm28QzWt86uGBd49PKiFv0QoD3sdiIMa2XvoKyFdjemuoYQV1?=
 =?us-ascii?Q?GFJ/buKgOxAcHl9/7QRfJcpueu+WT6UdNDFPBtL9CZQDC0G8WuL0rzveUP8W?=
 =?us-ascii?Q?2hAqgrJiI/WsmWBP+Uhr+BwH5LvrOqppmsEOi0h4d5pEVF57bvUT/QpaI8hM?=
 =?us-ascii?Q?OrtDVQrO+gN8DuFOVi9ey1Z3e87J0Rhi5OMWR+a5h/Xk4SzIYyRpmVEVl1qq?=
 =?us-ascii?Q?rBV/Zong2PEBWn+rWEiG70v0EuvNi0a/Tdd24V1K6KlAR4xxhso8REayPTSl?=
 =?us-ascii?Q?tq/JTPwO60BPQrZS3pfVgBbZ0jwtkZR+BvsDNOuKMnScBoT8898KCuTOcGrW?=
 =?us-ascii?Q?XMKBwxcP9fmtQAUHCyg+QLMnbs16KhyuzjM2PNhimJ5QV2Gu2jn06IvAWGCy?=
 =?us-ascii?Q?XYBxedJ1s6GrwOg9iOh6LNR/bTU4aZQ4bbLefAt/iT9+2B6ccLHh2Gs5IN8z?=
 =?us-ascii?Q?GPXcvMJpfTKREbQyW9rV8ivAPFTz65WdwdWylDYfSxVmoiXai9rYoPuCZv5d?=
 =?us-ascii?Q?l1ZC8Fbgr9nMARFLeipXh8UgHy2Hf6N9ov+hOK47TrfBigifTVeuhK9Yn48+?=
 =?us-ascii?Q?tIYi1ARBA30DoP2v6velsCPrsxeSD138uRE3tOChjmr0eGWR41Ru2OCZwNNv?=
 =?us-ascii?Q?JEu6wLOGM90jf4+ma8ZrTfX2Z+LHS6Fm6O06TPMfdl+zM2SscMMSeYf+GuYl?=
 =?us-ascii?Q?3AaDEtUJ/vLgozCFfLo3k638k1bL3RuZ87zTP2sUQGIeB2/tBzZNtpA5Pwf4?=
 =?us-ascii?Q?TBBUUk3Gcil8I0ghv+/utY9ugUPwLq+vIn5u4kctmedVapgUJyQc4YwpA7gb?=
 =?us-ascii?Q?7rLjju4Lh2F2+p/0WP0rV2ea9bF9D7/15gxV3/gx+b15lCwo3jjjJBUk/WE8?=
 =?us-ascii?Q?N4c4X37VcmpxdK4/78KER2SbEwn86eBrgQP6HMv8CPMVUZUw9vPrtaXh6rOq?=
 =?us-ascii?Q?CF7nZRuaDw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ce79a07-bb62-4d7c-ebdd-08de5919323a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 18:16:28.6337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XLNFK+07fM5J93S2O2L0r0QWW2EgZO2L+i087v+ObGOre5rZ9llAmZ6n7nVG2oLu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7659
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 82C7D14000B
X-Stat-Signature: 3s1stnasuwnqrcbk31ktdxehpyioh19u
X-Rspam-User: 
X-HE-Tag: 1769019392-871213
X-HE-Meta: U2FsdGVkX1+jcLXZYlsiHKW0gnYltpZ+FfKWC5vbrw9ddD3lqxCA9twifaWv9D/olwApcaXmBruZVLyhOe8WmmZeVVnvWJcsaNd0hcpSA9jykazYLnpARzgSgSEyXLq08KzD1FsA+pYIcMkMWP+EbjJNEHVs8ahyFrn61eAlwLNZM2lfc7zWYy2Q2Y4KwA+zqSddj1wQcka0g0H7JehOeZJcYCNnsOqgDYlKWpLsVPyXDjl9jukX9w3Q7CeqNRWfXJEiJC0icXgErCMzEq2Wm+46gH4+Z6YWsNg5FLjnVtaPS2KglalajrbVNHQ53KoSAjGDtmpcVxNQaf8EkxDIOyDkXrli063zVeHvQLkXAxqyhh6pxgsTeSUCfvTaEE1FJPIKPtTdl3W74PCD4Z9GM3mmzwXMlevS59TTSD6CZ+4wu1YZTMSxQzvoUARlzVFuQnPFivKKdB1J6vMtyZUZbkuhMc4i0eOZcnjCKZ1PEIHgKFgcemwrFuLJ/nCQnUAZMXBba8eVyPpTq4m4Dl7y/3n+AaE//VZEtDbZo/oRYa2E4tAJeEjXbTkk4VVbKBVfO379jcbn3OvA/TmnjO4ZOg2dmMxGMO47nEdV0DR0GSaZ0LohqALzIh26Z8qO97N8ma7ZqRZuMbsZh0pCyW/Z6GlpJtvRb/haGTSAfo2UopSzxkUOFX8YSv2Jhhtqh7zcTULX48eWfrEvG789ewg6ESXVoLvHGAcTfYO3qBHx03+0mbAXy7zDGP+oqJc9WGvdXtfhsVGi+GynmMeMdgr32c1EZgscTmHEghtRReyIqVuMe7aBDet8UEU6e0+JprtlqE8RrLql9TW431oaIJM+ZGfr1rVz/of3WvRgF9sNOGhhCr8Otk6lO00fFu/929zjHU0tGfT8HyPDxF9pDOEIXbDYjgc4HAu2436U9WQ+y9ieYCYDs7j/YZIlS5U1ca1ZRctzGhIv/j+ZfNq1pNU
 T5dPTs6p
 +U/3brtmS/aiRt9ciInxDqPK6A1H+il/Dh33NDesFvH0eUSpl8JB0w+Mxuxwl8t3z9T5qNBLAeCY3frzSsXt9635Zqiwz344C+BjYWHpEfm4AkWMmBTdPB7mprm9tqKJVYvISej8TIPgz2gNLBmydraIImfQwHi6mmODe+hLFt4a87I7I+y0pijcy/jhnARosInjCqgW21JdXqiFYnpBeAHUJUHHxUNqRJZoPaXKQGHKNRMcueCwGdv7eAloWJisCWiRv1M5oe7FV7TYq2VtMhu9zc+4KBQALkaITtnwHsNY8KKil3CgkG+Ej6csCwIWUUNiCAUC0Z2AUhcH5dmpf8lQfLmxk+UPJRlqtDrtQ143uCQsL6gqMQSgC2o7G6Rtsn7Vv+Pz5zXLkeoQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Jan 2026, at 11:22, Kiryl Shutsemau wrote:

> With fake head pages eliminated in the previous commit, remove the
> supporting infrastructure:
>
>   - page_fixed_fake_head(): no longer needed to detect fake heads;
>   - page_is_fake_head(): no longer needed;
>   - page_count_writable(): no longer needed for RCU protection;
>   - RCU read_lock in page_ref_add_unless(): no longer needed;
>
> This substantially simplifies compound_head() and page_ref_add_unless()=
,
> removing both branches and RCU overhead from these hot paths.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> ---
>  include/linux/page-flags.h | 93 ++------------------------------------=

>  include/linux/page_ref.h   |  8 +---
>  2 files changed, 4 insertions(+), 97 deletions(-)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index e16a4bc82856..660f9154a211 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -221,102 +221,15 @@ static __always_inline bool compound_info_has_ma=
sk(void)
>  	return is_power_of_2(sizeof(struct page));
>  }
>
> -#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>  DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
>
> -/*
> - * Return the real head page struct iff the @page is a fake head page,=
 otherwise
> - * return the @page itself. See Documentation/mm/vmemmap_dedup.rst.
> - */
> -static __always_inline const struct page *page_fixed_fake_head(const s=
truct page *page)
> -{
> -	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
> -		return page;
> -
> -	/* Fake heads only exists if compound_info_has_mask() is true */
> -	if (!compound_info_has_mask())
> -		return page;
> -
> -	/*
> -	 * Only addresses aligned with PAGE_SIZE of struct page may be fake h=
ead
> -	 * struct page. The alignment check aims to avoid access the fields (=

> -	 * e.g. compound_info) of the @page[1]. It can avoid touch a (possibl=
y)
> -	 * cold cacheline in some cases.
> -	 */
> -	if (IS_ALIGNED((unsigned long)page, PAGE_SIZE) &&
> -	    test_bit(PG_head, &page->flags.f)) {
> -		/*
> -		 * We can safely access the field of the @page[1] with PG_head
> -		 * because the @page is a compound page composed with at least
> -		 * two contiguous pages.
> -		 */
> -		unsigned long info =3D READ_ONCE(page[1].compound_info);
> -
> -		/* See set_compound_head() */
> -		if (likely(info & 1)) {
> -			unsigned long p =3D (unsigned long)page;
> -
> -			return (const struct page *)(p & info);
> -		}
> -	}
> -	return page;
> -}
> -

<snip>

>  static __always_inline unsigned long _compound_head(const struct page =
*page)
>  {
>  	unsigned long info =3D READ_ONCE(page->compound_info);
>
>  	/* Bit 0 encodes PageTail() */
>  	if (!(info & 1))
> -		return (unsigned long)page_fixed_fake_head(page);
> +		return (unsigned long)page;

Is this right? Assuming 64B struct page and 4KB page size, thus 64 struct=
 pages
in a page, the 64th struct page (0-indexed) is mapped to the head page an=
d
has !(info & 1). But _compound_head() should return page & info here.
Am I missing something? Thanks.


Best Regards,
Yan, Zi

