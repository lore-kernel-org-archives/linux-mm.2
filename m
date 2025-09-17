Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44404CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 11:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7296F8E0012; Wed, 17 Sep 2025 07:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D93B8E0001; Wed, 17 Sep 2025 07:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553D48E0012; Wed, 17 Sep 2025 07:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB6E8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:46:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C42B986940
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:46:54 +0000 (UTC)
X-FDA: 83898565548.01.869F7EA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0654B140006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:46:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jPTYJVOc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Qwq7l4P6;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758109611; a=rsa-sha256;
	cv=pass;
	b=EiWdpjwrfxm8fRPVIQi8Q59V4MEbItc+xyPgvbQB7wp4lliM5L7ygSy7Hz5L9McmoFtmD7
	7FUaOZKC1D0F25v6dRSO2Ortp56xqYWQHThX2h7bszbf5pH7QFNZmLEGvKLsQcRfN3YIaL
	WLb7mtkr/ZFo0AKC+Jz/VCQ9aN2SQO8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jPTYJVOc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Qwq7l4P6;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758109611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OroCyR9EtuFWqgygsxE0WNS18z1tjMUSl/JxDypqqDo=;
	b=rdajP41HAV2OZ/nPYABqUtt1q8McpmiziEYMUPa5D5dYsXgxD4jaB4cinvODi45O9yxZT/
	LpgP7eoVmAWecj/jI1KsZCILtsmsT00haxT/UfKD7AcgNdBo0rDseU8V5g+deCUAIcSdTF
	rAfzRA4ZZ1cZNk9O/1N2l8ffGrbaJQA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HAQxNw008483;
	Wed, 17 Sep 2025 11:46:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=OroCyR9EtuFWqgygsx
	E0WNS18z1tjMUSl/JxDypqqDo=; b=jPTYJVOc/E1A43Z2sPI5gtqCRbZlw8/3BG
	4KNDnH4qxkF/UyZ81vdNB6IXriSdp6HqojbLek2FktifW2/IwuvK9diFbqk2T9H6
	XA+PKqDO2ZrkddUNuGQ6wWRB1+fdwgI/9gEw1ARwR8sktrhAGsO9SIrC+wcvkGrX
	IPt3iC0Xou5IN3b5b4dfa5J2ioRcJ6LqTB1yTdtR0uYnv7PtGv0HRPO1hjmx1sYS
	IgoxxuHrLu7GIMnkWl97+BnHzCYE7nTFScDz16/yh34kh+kEP0zcK6VnHAaRI7eg
	7EzhEyCmT9TPOeH12orU763g92BcoaaL3ehAzRcZtatkZ+e+g01A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx910t6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 11:46:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9Y4F2001649;
	Wed, 17 Sep 2025 11:46:46 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010044.outbound.protection.outlook.com [40.93.198.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dvtdc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 11:46:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xZNlvb4PoFP5XfxwUhbAs65XcjIWHe5YfBqYdYBQfNLUfvB/lqhyhs7Z2CwTClLz1Xpi4PKQ4yaUVbudVZQfFF7CXuPWxsHk9MOO8naTA24Ph0wg8LeaD+FKZo2vP/sP+lphsMAp2g+GhzJAixmx/A3nIs17LFZo3kWcIdDRT09OOP/lZAP9bI0SbQWq4hea+lZ7HRWv9Gxfx7n7SppV8ceEo77yFXwHz6/qzkqfOWRHuTfktRXqvQfZqxiXoRWxebnKAo6PoPSNSRKm7nqjERDotzTZQMzW7d02zJrj0sOX6leZeBRNw1WzvTgAvy3yJeHo6mmyj+tRWpfQEQ4LzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OroCyR9EtuFWqgygsxE0WNS18z1tjMUSl/JxDypqqDo=;
 b=rC/FGjAZNIqCBUKab79pTehE2zmyAoUawv+4ltWzCld0gG4HSdlpfaOa2DvFNfftSEvMeOf8Nw6S2JyVAHO+3Jq2TGEodrTUqwqN77C3G6DnkO1FhXdaP/PWcn+0ocfqMG8K0UGPtpItp1aYgCyM5EmQv0sprSEhSD/7Ult3R/TKsloVH43juDqg5+gkQr0yas+0NaxfV1RJUlRDVg7+xCTK6iq64MmW0LIGbI8waR7t0m9/YZd22LIt9bQ7HW2MO0K4Y7PLucDlKZl8QfNARYPjUnAJZorVdC/lO6iXVOweePkAFO63QCZ3Hzh0cQz4tjv+OOD4nyjOItw9uUl0QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OroCyR9EtuFWqgygsxE0WNS18z1tjMUSl/JxDypqqDo=;
 b=Qwq7l4P6xY7OZg/SsXHs6OSgbNLYwhWFZtHrhAWqI2vF0OPAgvtvV/89F9O4AFTAK+4J11iE/KD0C5nwKpTfgUTRk/WD+PE5Yv2/DaoC0i6juUbU/+FnLNooJMoRgxhlczzZDhpJz64e6wFAuOZFUnAfTd3ZZbDnsNlAlk0yKK0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB7778.namprd10.prod.outlook.com (2603:10b6:610:1b8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Wed, 17 Sep
 2025 11:46:44 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9115.018; Wed, 17 Sep 2025
 11:46:44 +0000
Date: Wed, 17 Sep 2025 20:46:35 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org, Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v8 18/23] maple_tree: Use kfree_rcu in ma_free_rcu
Message-ID: <aMqfmzwCu1N_L1qp@hyeyoo>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-18-ca3099d8352c@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-18-ca3099d8352c@suse.cz>
X-ClientProxiedBy: SE2P216CA0156.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c1::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB7778:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aa40bc7-214b-4e5f-0ca6-08ddf5dfdfea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nKl7D8NebrrPBLFn7hW7/tVquaYr3DnebLIu0k36Z74B3P+Eh4tXuOYMMHYR?=
 =?us-ascii?Q?QiLUE1EeskD5ubT47mMyAzCJ4///DwmKUAhDrP5c0l7ZEeD669WZJNvNF2qm?=
 =?us-ascii?Q?bxyg23FDBryCGgQX3NFJi7iNZtyCjtzw4UYVibarc9Ma3IQp0zblrb4VRIAx?=
 =?us-ascii?Q?VJBIW2WA1+6m0r8nUUr9EcwQcFauB6APVM06itK+Rhwc+42M2c8axi57lKNQ?=
 =?us-ascii?Q?H3WHAcXNWq4obwg5xpn0Ps45mQmBxqrYWB2ZJNxTpBZ65caMoDWVNSIQltji?=
 =?us-ascii?Q?n+yBdDqXUWrtMXcGWDddfCGREgc7USEVVSW4u00IPosaDHIf1Or2bxCsjyKF?=
 =?us-ascii?Q?7J4ZeFDGgJMfUS1Tjx0joq+gDU3M7+rgSRL2enVySUH7+zZpy4do4eJegM2V?=
 =?us-ascii?Q?av3j/SASRKKL7QGwNVxlIWnxRM/UsMgui/u/HG8XidgArYQEij9DAD818Wk8?=
 =?us-ascii?Q?u0vxP1CLVi7o41Lpmq7pSIQr028h2lb808b+dZ+rtZhCSpvD3EHjCkmO7Yy4?=
 =?us-ascii?Q?Tm7YwjyOhFiLrd7h4KgbpXkc5m47QATTm2SCtYRj63LqM/fSqQRtMU90qLdW?=
 =?us-ascii?Q?w/EGeRtoU0ZhmC09sx4yp4RIQciszY0ozBXN1upkiXtUmW86KGqmT//iXqaM?=
 =?us-ascii?Q?6dzXZtN5FTFBEDaOGRUOoWmoA0d9VDvanGb7H0g9pY9CX0gZRqUIgVabPeDp?=
 =?us-ascii?Q?dJrdidZ0qmsKtQy0rmyt4IeMkRTRXwqcgWLUZE3TcQY3aLTyRpzb77BZfgrc?=
 =?us-ascii?Q?As8vh1z4Ewxs953F2i4SrxYINQ7yA9u9yAejDxd+DIblkkPL32+6qtj4qKBO?=
 =?us-ascii?Q?0ip5FBcvt0IIiaBvN9WV72dFHPWQJBZIWhJS+4t188M7XtZTa2lcSXOjv1aw?=
 =?us-ascii?Q?pODCW+nKkTdvDR2M9tCn6yIhmU10BF0s2uOIki4GmrHVLTi9hcL/Uir/xUOM?=
 =?us-ascii?Q?Ppm51cACXC52zBDFDELNCr4sybZPr5Z9882X8XH+4WB9HyV5wpAUTGZgAd3j?=
 =?us-ascii?Q?K30QymCDb6oQuE0ZEZdWNmJHLymzc9eUCCInjq19ThZRrmG9xmFeqf+U1FWl?=
 =?us-ascii?Q?V39tGpJf+Mlh4YpAH3TcFLiU565SSiddJ2e+vZLqkuofFcdKdLEinE3AkLpd?=
 =?us-ascii?Q?Ilb3aSAQ5312DJe4T/T4N0QHmg7j2OHHdKEfLB6HwpK/BxuLMi4jAre0TIBS?=
 =?us-ascii?Q?NalqQU16NXnKvk6gpTnq3FjnkxNQBqbwNF0FF4sqxIZT3ye59yrqAC/HE/QV?=
 =?us-ascii?Q?82114Xl7YWZgcJ7iaVJ000/Dk6XVoCzL82FhHsBHYJ4wmQRiYXXgSlh3s32B?=
 =?us-ascii?Q?h1WrR6XF9YSyzjV3As4ue/XfqNRUWoXFPMf37H2q+My6yENt9rkl9nsvTecX?=
 =?us-ascii?Q?7VBuXgSGdsIM7MtaIY1ZEVaAJOLOCSAozwReIqM9YP16RFHrPb9MvXvcMSu/?=
 =?us-ascii?Q?jgyWyJ2ammw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/p4d5z6VBLIVBSEeceIsb+hyUoFiTpEWLkle9fWsBlnIWi519A3SxONiVwA+?=
 =?us-ascii?Q?VEWsE//87VFVsmGjCKQ6YCuUqb9kzE3pEwptI1Q/KfKT1jBavdOeYts/UhBV?=
 =?us-ascii?Q?PJkIieY04DFuibh3u8EF0XUcCNIdSeTePbJRhkVOAXm/Kafy7r7SvRorjOEM?=
 =?us-ascii?Q?7RmH4YtghXiVcyD16WhKfZx1jGZInbb4pxR8vTkiXrF9Rypa7FvSl68kBcZR?=
 =?us-ascii?Q?hwmYKh63SNoTlbV8Fv0Qm0JzuRs2JteXQjtizNTWOQSjtfdvIPlQrUF5KWxx?=
 =?us-ascii?Q?tLSrWNYjUsIwe51JmIHJJgDvqq5AmIWP8rwPMJ2pHY16sfHNvxR+b/XSHqg5?=
 =?us-ascii?Q?bm9PohXLUsPqz+A2u++Dyech1bX6pcSnGM4L34Wqm42IKTJ9UYze0KHksvCn?=
 =?us-ascii?Q?ZvgfdfzfAoiud1vizxU2/V0BfCtGkyfsc3kHcmUiLYpKDNDgfRUzcEIdShs3?=
 =?us-ascii?Q?goV6QiWSVT/aab0e7ekOkEAWq8ZpAyvw97PeD2KakV80WP4pMYyYD46Z0bU1?=
 =?us-ascii?Q?eIpPwdjoNH9+bGCSXFVpl9Cz0n0fdpxQrW7LputRk4thhRW0+niGTe5/fL+e?=
 =?us-ascii?Q?g+PlZ5i/LPNK3UQwP/xilUcPjmHbhJKfZ9MdaVuNTQFmPyCKRdBImNvnWafZ?=
 =?us-ascii?Q?AoK4e5ApnsGn2+Xg5I7gxfnxueGhmHjRhsIewhlZlFMssrRUS1zrb83hkmTJ?=
 =?us-ascii?Q?rFFM3hkVokW0z6lznXGcJjYhw2J9PLQ7ptSd/0nsAyWh0z+4oSF+ADCQQgVi?=
 =?us-ascii?Q?NsS9U6zaJaLmaBCv+M8d5upTrP2HZ93CnoFFmcwmVwRu1j0tpGePL8zkwgPb?=
 =?us-ascii?Q?xsiLLAU8CwL/vcpW2gZrOf4r6FmsabdfD6VCPjVvkfyFzKbgWlW0rwHTMxB8?=
 =?us-ascii?Q?0tmr+gyWhwb3NXMdL7YtRzyHIJ2wD/vluUXss1L+rgHkH1JVX95xjybLGPoY?=
 =?us-ascii?Q?x1b5wX+DLpww+Ut2jDlI9nvqZV3sSo1gnXvOL6l00yrzyNiF5IFdq/y5uELY?=
 =?us-ascii?Q?LjsB6j7HRNk9+zphS7cYKBtvL9SXup2aqV3V9WPJlCooXiFnqxF410UVNTPm?=
 =?us-ascii?Q?OXQbPqbnKy/5rrPmo6UswK3iRR6R0xZxkie41ZtNUlQT6+S2H65H75LO+zTc?=
 =?us-ascii?Q?2depTXIDKMDoo9OR9fKEmnDL/hPZav4L+m3fw+geZF3SfnkP2EJ7SDQJ4B0p?=
 =?us-ascii?Q?Swxj7LrT6zq7BBdqoqjNc/D00EAIgrROc0RWSdiTDffsALrzvXal8h4kATWn?=
 =?us-ascii?Q?387HZ6uVgsBosBStDfqzi8LRzAzDa9innxKJWv1P/7B3btY0rTRyQmQTerl8?=
 =?us-ascii?Q?YmeIYVBYrDnSUqKmhBXOKJ6WEqQqXj1bwiSmIpAyfbR8VUY4tk40Ih6Xx+cN?=
 =?us-ascii?Q?b6MfWgLN+WvPAOIbNvvR8U+MZy20bIfHYnkh5o6FqcK6F7gr15+mzDmIInSQ?=
 =?us-ascii?Q?oKrUO/LDRxr6d7XFeCgcDie6yMefLuz/Y0SbDLIu8GjwShrEd3yuT01Cs4zl?=
 =?us-ascii?Q?80X99rnJzuXBzfWKT07PoCOEeGHH/G7xnmr/5g1d6wD6xz6zLKonTUKqu+FF?=
 =?us-ascii?Q?KQvtEHI04GzM815REMOZ0cl1vgs0rXczJLvvDitr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Zfzg71IqBcZdo7YlQ1SksYoqDz+ghkpY1m1EPoDgXFCavgJ6VCviCxSy8NPHxP38BNY1/TVuiLPFXUl8zPeEtuZ0NWMPWZ8suUazcdNXTgBh1+w0+mjuzQULBPgGXXDsuXC6i7XhzE+/m99i+iRbRHOwiJMrBBKhqx4mYIwGi8Yfp+R4SrSktokLaIzjsi/V6EDd0/WJFlRBrU18khlQX3EAsFybuy0i+RYRdNUgLXJ+/mWjlKOU5m5SUJoSDxHRstNZkwIjCF4jSoE9LUsPMO0U4TSaJil5zHPB2kykumQebCI83evoq6r3IWnyV6qKOJZO3sapxvj0+IviwhpFb5iYdkl2VC+5W4dyXYnK+DTii7W7O+6AtBnCy81tK0oUAaukgEydnm0r30TJ5H6mFvFiEf703sC1Dg/QHAKsXRJnry2EjtOKgcYPXPgUseLHeT4KckeJFShEIVwe/0A9zmXtSpl7v+l/f2xgdhHnd26fClEJo1joRvx4Lg1nKVTvVwdXRUdgJpDViLG5v7QiivFAZiz8DBmukBCsnvl3t0TnhFzXxMKRdIqNu6PYfR5Df5noPuFfvUP67MAQJ6xXpYdsP6OeptmwSAywzJpiuWk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa40bc7-214b-4e5f-0ca6-08ddf5dfdfea
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 11:46:44.2055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yq+NkLso4VNdWNvCJOQhycJkpa/9fIIfzMJ86YhnHXfWYMhQlQhF0tkyX4JP2SngVQVPIsAf7ICQW2ctI7W+3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7778
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=993 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509170114
X-Proofpoint-ORIG-GUID: Ob2Yy0bTAc1jKdqS-A4pRkSsB_20et2y
X-Proofpoint-GUID: Ob2Yy0bTAc1jKdqS-A4pRkSsB_20et2y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfXyFw/RwoVSBRN
 rmEvcdkT+EdAceK42nU4bnl3zzRlHPDGeNWeLvnSH/hgP1lSULQJ2RBVFyEodALB3SUVT32OIbx
 AtulUsHiXARFw0cVcX5mNSCLRthBpv2LlG+8hqNw8TJEwsk0gJEwUT+7ae9xKbnNwDyrO0ye/10
 fkNC2C3n6Vr1nDdCPysRwqTyoZ9ChllpHJhyAxMYDJTmSfT6O9E49LlD+g9J70P1nlCc3HLoITM
 N+arO15zGVHo3+Q3Qf7Lt7XpGd7lZndnbMx6M2Mhw469Hq+oJkVODRWvUcLPqWQQvBlVk3bikRn
 9sR9CMbcbihCzaNzBrAKCykotif0bEONBKYm8WvSPVk8THKa3KUwiPMI7p9GA8oxF8+TRgfDqvM
 RYpScBCA
X-Authority-Analysis: v=2.4 cv=N/QpF39B c=1 sm=1 tr=0 ts=68ca9fa7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=fYFcBro6qNnNv0vqlNoA:9
 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0654B140006
X-Stat-Signature: ehxpm4tw4th7skbzrrq9mb4izrjgqc9x
X-Rspam-User: 
X-HE-Tag: 1758109610-172061
X-HE-Meta: U2FsdGVkX18AM1sONNDJ4A00OJ505s+JsEdWdmOTlVx/umqVHkgTP6V2qpqiqhDIpeYoim9UZUKFVAGzXxWl2/vaWS6WAJhOMV8GRwOBr5dMhAyVNEfbedJ/aTpC9ccj3H8yFhAe0UgdCOxyVb1ZUGtYcKWGaD/kIV9B6V1e0s99fwVzm3i7m2Zhr2TbHYKakRQR7QRQb1w1OgLNMjs4hKITkekLyPdJIcqtpZ+CD+0HAUxiBWg6nPLf3d4o2rxvnIWlWGxCl3z+4hQS7VKy1oC0vAJBVHrj54O6kvCfkMuW0mL3gFUkA1ZMxJzhE/XG8Mvs+Z6sArBfXFEPKEKsnykviOqe9IrGaju6yu6JwnkDzKZ1H6eGckaE1o5NlO2+lqtDEWZAVeI8taUkQ1+W2vHMqb22tCgH5PwDt6mrJ7l4Uu89oEhW3jmaiZ3lZmust1Bn4E2NruSdq3Gz/3NUHOrG4cmnNRoWS3g6FWAborwJkUF8OgurZKSVL4AX2REAtTKbUyP91dP4XJNl9x8ymyMaVmAGfP0mbIdsykgIDWfM/ZGIWs2E3bHR7BKFtAkwFaohaf5Ixrahuoljw6hFYi4Z7rcQwTbGFvjBmIhxiBxD53NN8aRHivoo4yUHe13XlTAW5fj65tuzRgGQMEitrWmgRpI1g6wm4750CFeReVXUFCVVIpEEdHLoXUZqg88uoGz9KbE6EIznoi9aYjsnOrDe42M/fm24X14ST3h0T2HNCI3tp2gzz4UMcEj0F9SV1yp40cSQTOSU8sRrWrj0x7ns4OIcuXo2fjpeE8kfpK/GteuCKB0KYh4kjdTPMU2pt9kp7nnF92TG9yheUtI78ca0cTjLZWQS0to5el1ev6+7rywf4vd85CatHY1uHIjY6uZ4yrBKf3AvEvGkos8rICvprGkQRFgP16Uiv+Exr9tYgx4myTcrhdrWnT6havgeb2HFwZYhXfOcVGTUO7B
 aH1Mm/VN
 +WH5QUKGZjQ1ZZV0yRwjuijci4OhdH0D314V2oLWMhNXIjA+7VqY3GWTZTMGq9ziieuZVozCOdUwGGbUyljT4I4SBhgilVEo6lvnCu+m5zWkIHO0uObLabCa75GfcyV4aua1kMBQFzhYKGlRVr1Q9xttemrnhHQ/f7nS/6n9qE2zqReIRthbQFbP8c/sF61vkv57f55HXzOzqCPFfG+iOGrDn33fT+kr1/j3Mh8lP2F+oRX+8iot0JhG2wWM12IfkpxuFo9NFpuxMNoYo3X7TLb9blXTLHR3dEEJJGQX1lBQUi3Kb8PeeozvIFG5DdL4IkGUaE5s6od5ZmUbbxQB3EP9rgLOPBoqQCIOkfs6GSJzWHynIc+7TbcD5MdY/E7ZF71DU84h/C3p8OcMTpPWXsW7FdWUYfjSc446m4R1VlXBWs/jSZa605TvUYtiu1QCwUiUNoOEa8jFzwvDdK7keSLOLtfAd/7KqZ+8B+c0bCUINnhGrUyvljumf4PYYR8Ss3XlAUNCmT/vyjPjeT2TWwxz9bnXNze/qU4MaP0PmnhGt5Vg2PRYU5WXzI7yyA+bF+Lou62tcc1VoTsn/f1oj6LPoufK2WLp3kt+8E7r/ebKQscTmWvCjwHj79NbBT3+gh380lxnDMa/Vg836lQ1HcRaGihSoRCNcXp9oqpt/VHU6ZyAI1quiFOtdebS3yNF+9APyfKh/vn5EJMZbOZKcUFWAd9fvDgCkV8loGy8m2Gq9Tndq0dXuBK79lRnTnPHf4LBejToobXAW7mGoVQseSYbvkIZ1eN3RIiDh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 10:01:20AM +0200, Vlastimil Babka wrote:
> From: Pedro Falcato <pfalcato@suse.de>
> 
> kfree_rcu is an optimized version of call_rcu + kfree. It used to not be
> possible to call it on non-kmalloc objects, but this restriction was
> lifted ever since SLOB was dropped from the kernel, and since commit
> 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()").
> 
> Thus, replace call_rcu + mt_free_rcu with kfree_rcu.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

