Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB37CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 15:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F47A8E006B; Mon, 11 Aug 2025 11:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0564E8E0060; Mon, 11 Aug 2025 11:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E396D8E006B; Mon, 11 Aug 2025 11:00:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0C4D8E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:00:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E9E080415
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:00:07 +0000 (UTC)
X-FDA: 83764786854.27.FC09253
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 205FC4000C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:00:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aMFLGXmn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W3kI3gq2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754924404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VEaFrpAtndZD+gA7zyz1GQOdJhKeGoU8SPbJXMJoDUY=;
	b=fysBrlZ6oL1kb/40bdp0dHXClOJe+c5EbvgzyoWbRJLtYsco1u+so5/zldqMlGG+iNRAoP
	pPILBVly5yVEZps4+pZWwAXAdjY/DHbxYTRJDKMZfAJP/XpRRwlWpjtGyVQdpgabjlJeFq
	IW/llA56ib3ck+cSO9vxIITo8qs7lA8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754924404; a=rsa-sha256;
	cv=pass;
	b=6zZPxAmI1xtBbHzuuC6LGzMOGyfYaaQdL6PgRnj5FsRgcqbKLgslq0ClftpQgW1U5+8Ga+
	McOEeRiH2U86d4I6sxvQnWS8RwHtTXvv7BUg8+Kx+4/m0jV3QKAiw5Nsvr3kKxtKK8TkSj
	XEWJWoVwWexipFeqdtobygeOA78jYJE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aMFLGXmn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W3kI3gq2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BEuFZp022462;
	Mon, 11 Aug 2025 14:59:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VEaFrpAtndZD+gA7zyz1GQOdJhKeGoU8SPbJXMJoDUY=; b=
	aMFLGXmnFsaxVe0wOEDwluo7QRzxcp2MJ+30i0vPlupo1SqQ1lw69uUcwR4g/vcc
	9dhbYApWnWT2wQ9A8yan6X2T9gCXtzGhq04zFh0Xdh9Nok+lLUbzY0aa44jIQcrP
	Qd/CwPZB1IfkoA4ViXeOCuHyS3BWmoL2q45Vkc97TyZl0rwSfNGs9wvjcG/mFzR9
	kd3iV8RAvuV/xw993t0zXBZApnunjofGIJeNtwFjdhcUgm0YfB6cuCDcHjkkzcXU
	ODhhLA6H92cgthoLGq7Lm4FcYDBey9IjePdeVESRGCmtf3GvyNWmx5E3MIWZh4hQ
	2vKK8mGiqn+NcJ1BYsgJeA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxcf2tbd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 14:59:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57BE9s4D017388;
	Mon, 11 Aug 2025 14:59:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs8rdmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 14:59:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V4Ha5tKrl2D7fvVJt3x98Km3Sk3djVZMmfDs3wZaIIKCCGxnyPsbXYil19ek2kEOc+gUlBcpwMafITVRLV6Ul5glHiTfhvyWmyo2PmibGElC4EQiDHRErGU33LxPo6zqcHS6rwE6a47q1g8XYuA+A7OHZlmYp/h+5draQAJ9Hzx7P81YEAw1PbliOFTZsEe56RXsatPnHZIK2c7yZVKjXQQYoGk1ZuFubcIKydx+8BlhS6yKsE0JidUixQB+55OkM0OKbYS6T9AwRkIKTnm2lCQDWrOBCFzhD9eKEACpwtBVOpvgDKuDuHn5UnkGsUi/S5IwY2X0ENR0fWPNy2KqMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VEaFrpAtndZD+gA7zyz1GQOdJhKeGoU8SPbJXMJoDUY=;
 b=YSIrD8dNmi5f9CiEyyH1sCHDczEKIcMlblhW65/V4S7XEtx439mM1r8XECu9nLfbt1bJyOgqC3Kfj+f3ghocUGsaiAeFOy4q9MVLDjqySCoqGx0YrP7YfHr2VY89bc1ofI26X7w7XYWF6265Bb/LCbjBNBIg6Q2M62iKoCQUVP0A/EX5jCd074fce4LJQERSwcwxxnjzz7OEo7+BH4qdQJFmcPmZrxVKJFd88qKyY8rUm3xRxxnaH2dCFuXHU/5X+Gyh7xLagAdIKG0IQ5H7Gnsx0mzeh9BtCY3qlDstWGHfVo7V4kJcdBX1UBwagMvIghL9sPZW+XTIrtjMqPpsjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VEaFrpAtndZD+gA7zyz1GQOdJhKeGoU8SPbJXMJoDUY=;
 b=W3kI3gq2MyST9CS0GymCdE4lxwYrXltNwsZ5S7Ki6k3Lf1g8I/u7R1NXP/cPxA6Dfb00QAiMI8NZF7x7SsS9xB1khZpcudqCTkU1Cxs9XDT+bzx3P4OloIxXNznt6TG+Yq7heJfj+bK4VK97zIoNIRd+C5IeT6mA8S27nh8Ae1k=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7553.namprd10.prod.outlook.com (2603:10b6:806:376::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 14:59:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 14:59:55 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH v5 3/3] man/man2/mremap.2: describe previously undocumented shrink behaviour
Date: Mon, 11 Aug 2025 15:59:39 +0100
Message-ID: <ab2264d8c29d103d400c028f0417cada002ffc11.1754924278.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754924278.git.lorenzo.stoakes@oracle.com>
References: <cover.1754924278.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MM0P280CA0098.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::30) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7553:EE_
X-MS-Office365-Filtering-Correlation-Id: 34d8e205-d85a-412e-e30a-08ddd8e7bbaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YBLa2zCnxZlQ7fG0Il7cbO0eO97uAa66fr4zMZMoeNi7AbPEQ8sA5bYTUsm9?=
 =?us-ascii?Q?enwMdad43wvY2YrYSbwL7NkZpPBA/NdR6vWrQYMHb0U/3gAZ37nD1LC54Dky?=
 =?us-ascii?Q?kUBonZNQwLqX4CZ/hA81AOx3EDab2VSNDUKVs/AZbYkUvORXpwytBPf1tCGM?=
 =?us-ascii?Q?tUF0/dW7mj7rn3d4MNvk6Nw37SSjrDHIXvtP2lJ1m947afh6cvrMCr55uCk3?=
 =?us-ascii?Q?kBUcFXCPrelXpNend3TFjT8S7/VqWa16Aavk5lC1VafmyYMQs6bMhi63s7sC?=
 =?us-ascii?Q?fl+NdelHUVjLu/NQa9SiY3bsrUw3aBjabGdbPWqwRMofUIt63dFEPgl2SF/T?=
 =?us-ascii?Q?IEfUYNAhu4mE9fD6XrQ3Z7sbjukefbm/V1yIOBSgFcpEwAZ+/QespFIqEkH0?=
 =?us-ascii?Q?u0fVP/b6+5ng6oxZ78BSi+jGO7hF9ypLX0bfBLiaDTNltYsZ90BntIrayAzQ?=
 =?us-ascii?Q?pSghsgQZJ+tOLoO3eiSuf660WEIFPQWCJOPU2np0PXMoO2BthfCMntMbG4rn?=
 =?us-ascii?Q?wXTxEIG1uyMWcLnFHCQ+JqGEWCEqcweQTz5PZBDoi6ATeP8+vYT9b/JBLSWc?=
 =?us-ascii?Q?UlFq8fHL0fpobsWRMgSjQfdam4Yz3ymbHr4thFUlTiEAmstnI7iKMqKaYCew?=
 =?us-ascii?Q?p/LHtCoSX42gtmTstxij5gkRrQjPjRZpR+Le3ABgkQX1QEcASVOhHbPsAbFy?=
 =?us-ascii?Q?d2GSm2A3L8K8QoEl2JIRTndy3EWYSzED0I16Ve4cYenngBpmwiP3SeHsDhSX?=
 =?us-ascii?Q?MPVIlKT4yQN8YdQH6FguRC/Jaw1q/3WhGUT9/o5rCBCDZh9CNJi0TnEXOC24?=
 =?us-ascii?Q?sUbScPcOakn81FmS5MkeNz0KuLjGVo3on0KOMdWUApDj1g/3CPHTF/8voP3w?=
 =?us-ascii?Q?h+cE4mQM2hPRNIttaFVmoP0+XN1C0yP2tJ2RFotiQuOdDDcZKm84V8IlYIC5?=
 =?us-ascii?Q?6nlfSAH0gNcVPC3Plai9eRxh27K3bTbFyGxZ2MWFnTkuSZbGNAmVDhoE0yVY?=
 =?us-ascii?Q?OoK/ZdCHgsFWU4DlsbnHpsoolroE9gYSWBkMnexoOa2D59Fv/KkyIwjf+XyZ?=
 =?us-ascii?Q?LLCoEJlf0/6zweoHRvSMDYEiGl7nJxkjzr+qCfK7VUNvS8ZHUvXN97RyVpjG?=
 =?us-ascii?Q?m0iBNy0JdWYHNW5wCLUiqr7gz6CFa+FyiRBXn36hmAOXMNGlfiJMZIWY9jRG?=
 =?us-ascii?Q?ipPOs+e2nk3WXg6Yh6o13VpFVM7tAlt5AaeUGonz8Cdy6A/XLG8GhRqZn5la?=
 =?us-ascii?Q?t7N+4OdPnyaJL8y0uFydaeJSvHIkOHNBWyWC3DQg7wqR3F3/P1821eqK1PWQ?=
 =?us-ascii?Q?Xhp1Gs7G/t0UZwqVvlodVj6OMSJ+IN35Y6uOPbiYAPvPFjWpws5eiUHaxInZ?=
 =?us-ascii?Q?ur0yqgVHrPm1W3/r729z7ZcMiuA7oFEtOCAWMxQPsodyED/+ImKUEy1c9wEG?=
 =?us-ascii?Q?gD9NgTYtZlw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C6eI7Krt1mULTXtO4wuipqEb0GlTe+317t2sSgeL0AsEbjxjYp7I34Bv+mN1?=
 =?us-ascii?Q?ABB9b9a++360gykhl2byiPMH58G4za3DSh77qqO7Wq8zuQnuGP9UGTKerFuf?=
 =?us-ascii?Q?67G8nOxMiB2PlD6AtQE4XoHoY7RIuPXxWdaSPYc1glcqrBM7/X9LfQ6/ZdWi?=
 =?us-ascii?Q?Ku0cujEtX9enVNlet5GN1I2iwKOGBOTZneiAqh2Nv6aCZISKKlQYMiTYFhRG?=
 =?us-ascii?Q?MInccseIx0WVNJx5DMmRqz8xxPo4vFAmAiBCrDjA94v7M5cyz5tFVbmXgTXb?=
 =?us-ascii?Q?gCITiD0c4SNAYg6WoPvgMwtF7QFYpSIo2MpAxjsNZ/NZlZlL+7WbS9hyAtqt?=
 =?us-ascii?Q?/scw9i4ERY/Xb2vKShrAtu2w5eVcdGjI1J52qyPkcatJPlcXWVfB+7v7rGRL?=
 =?us-ascii?Q?8QcPmLOGSmdREOXu3qWTg2vcwU5HVuy9F78nNpVk6OEzCUHEG1KvqLVzuYus?=
 =?us-ascii?Q?SC7L6SeQ7VP+ZsKhevKmJbijfzUAfa8d9vk1/OGiERl1TSh7i1kujYNqooFA?=
 =?us-ascii?Q?waxxDe147i9gUYArStKg02/ehKt7m4U/lPkXQd92tl5gKVyhQZA+HD38nx/s?=
 =?us-ascii?Q?HHh7tI4N3SXAHV9PAPYdrnkJv7JzvsOgpadJJ7ioEqGOeNh+XebEB699sozC?=
 =?us-ascii?Q?eEUqX3vuqdCTNlUQZ4+hPHdEMQtnLJHXz8D86z99oRLTVObh3yeJGjY0nhRW?=
 =?us-ascii?Q?NEk2Zjk24DnHzFbghykngJbbbWnGwFVd1AEHcjQ+DR6tibZaYtYU+rKRmSdC?=
 =?us-ascii?Q?WYO1s+oCxR5j6GQ9M4dRUaqSAkZubCZLKCme8Byd5DoYT+Kz9TG90or2/HS/?=
 =?us-ascii?Q?uMYVYPSxbn9r/J6mrsAaYSDjLl8vwt6ra6JR3IeenWEwpz0LTH4baI0Mi6JC?=
 =?us-ascii?Q?ppYOYI6oltlNAcjyQ+Dzgqae9gzfuxmZuWevPWS1zEHtH63uGEqUsq5ZFSNo?=
 =?us-ascii?Q?VosKHKQtWIusZN9mZY2l51R8z8bE86ksK9zcHZ1Wwl6ilB/DdZ+DD1f5Xo2m?=
 =?us-ascii?Q?oUObeYKuW+77/WbTP16xPy7YUhNZHYfwlKlaq6of3NvG4yqdGCsUVZYyhIgx?=
 =?us-ascii?Q?LoxW6vXFg6thDRKUlZn8vd8MTALQ1B8yXEWuJZdcOg5xMOkBOPf9TvoewqT4?=
 =?us-ascii?Q?PuD2EwktvzQCkte8GDP+fGtLxBe9+0giS1RojSyINZ8ESZ10OvdFkLkzSIMY?=
 =?us-ascii?Q?cxkY5M0f/Umz5JyOqSpo/3gz1ODKNwarwMJQ4dW1PiUEWwtpdwkFrpTaZUWa?=
 =?us-ascii?Q?o/b0vx55QpBNVpF79yGILAH3M0kObYd4vcj/QMPVkgyBwLPt1d7yUZ5z/Qkj?=
 =?us-ascii?Q?z6AJy7eAuU+LTmN/B8+bpcnkMiasbLJgLHThtcybNndX324NN6XNlPkQn1pi?=
 =?us-ascii?Q?5eVBqYO3RYAfNH7nBzS0cNErnSSF0MvHMoc7v4Fwa4wGWH+f/71q5W51waFw?=
 =?us-ascii?Q?baH4+J39qfna3h/8zATBfTHLj2Kkt1zz2yxutu1mdrVpm7x4Fw/f1CpwgQG8?=
 =?us-ascii?Q?G+tgX42sbG/KwKunBZgo80yBGwrozszrfb8I2u0H3xBCBRiTJf70/38b0VnL?=
 =?us-ascii?Q?V3zQTkLzzHLG8TIoByxDp4g6flz+JJaMFSCjyIAXtWtVOVXTgUaRZgeP2lUu?=
 =?us-ascii?Q?mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pJoS6jFKzGFUxaffvCAYjbzdEtS/DP1+NjWx6jGnTCcrKIkNzlnF2fz9tX3M3XIqCSvzPDtRy+mM5+Jv8QCO4VhfYCIT2c0pnXl7byKcMYGy1D3nfzJ57lAQQxDa2AP1KcFG58Qc7vZ2lGieQvOJE2/Yg4tW+jpSGUF5D2rdbdInzTF2m4ps82o3TMYF3nF3HvG+yzCaunB70l0yVxzYNJk7fyLXCWV46LQc0LO3fE3yblilBJZk31557Kswjr2GagOTfq2inTFqvyNiNCLrdF4m3piR3xQw8s0SHHIqd3CmNYuyxZ05VTYifnwaJGvu9U2ZDXAyPvW+roD2WuULecJ0IVgqloPpp7S3DUbWtvRDOxws+Qsr1uXTWfaJZ8nCfpUS3OeXCADjcFg257mEXcG924HBFK6tcvOccZf9bIKKNIW+eJ2uNNPqY3fsoQ4RsMTZgosfhaaD/CNGBai4F01xfv0WS9oHcWnaAuT6Rbufz8VSQKjDFcX+QpASj4kQuVcKKG7eijhQNtAlJARwdemeeQspjVp6yW1SUQ5rB0g1UnHA82CKKRamKS0xTlvXNp7jqH/BTTlNLJ/d5Mrq/KrL45uVqTmj7j+ybR3ASA8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34d8e205-d85a-412e-e30a-08ddd8e7bbaa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 14:59:55.4625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4M1B5qxf8kk1DblW3S+/VC00UqP9oRTKeHDqE+CrcGiuD7KK+J5cRzV3lBa4rLIv+6rp4gGUSqm0doYJw985oKujH+TFalc09BZ2+TpHkBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_03,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508110096
X-Proofpoint-GUID: UdmQu6YSnom5vGTdtuEnanXHRX4VLs1X
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA5NSBTYWx0ZWRfX8kDUj3O8gPBO
 z5cjXCB9UXXw4wErh0vYgsAnq2KeZQNdWs6MSMw8mJTS3WmdjCwxrVyXmpx3OUUvw9wGWAbQqR/
 kNJLQJjiSQ/w4QYELkPOA3ltyLLDQ5lP71cVaKlvyvTOjCwQplW0oUKOtc1DZjea1ROvo5tUjXF
 aQ+/zN9fKF14YnnyayHFPoCsTyCSCf25tY2nPol+LoNkiVwgNmpMY38ftshgwkDTUygLQaOTG0M
 iQuHYLicVlBRFrnI75eN6zzdTcQDhpa0GtSRKQ9RoyskXF5AC5nyqThZxIlFKF3PBBqXu28r5Zz
 F/CUx52845VZejmrYTJyFh12EuQ8eEe2eEKMDxCGsYlZ43f7Sfz/XLwZNOHZj7o8tOACceDrqMp
 KsRUvQ0CFE6V14O3Em22gJxb0FZolLEH9epYPBEzu6obnRG2lTP7oQcoXygvayfObRP8yN5R
X-Authority-Analysis: v=2.4 cv=W8M4VQWk c=1 sm=1 tr=0 ts=689a056f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=hqxEFHVobavvttKUrIwA:9
X-Proofpoint-ORIG-GUID: UdmQu6YSnom5vGTdtuEnanXHRX4VLs1X
X-Rspamd-Queue-Id: 205FC4000C
X-Stat-Signature: woqj6j7f8ejzrppqbmsp9w934aod5mha
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754924403-51671
X-HE-Meta: U2FsdGVkX18ql4yMNQ/0DNf/3y7PBqQvVK28DwyvEhkhoq0tX5KqY+I/qap7LR/DJZIbKBO+wJldIExMprkLxCM48T1rXcCG7ncNwyQaCeGQi+J9WiQgAPpakmFBuADdqY9jDIPv1fyBF9o+2UBFXOqSbARQH5zUn27b9KAr8Ed0682pBx4/aoQEZHJg4vq8tEeE+3iSntaWNXs4e6MpZSE+jyUOFb3X4gxEazLafxZmDQoMnqgHTXihTvTocxH1R2ce2D4oj4y+QgFFrWDj9f2+XgVWiGZHoy1Qqrz/N2Vl1/zyYFCxzmR9w7e2QadeygbyzPp9s+64xSDozVrU12Jgn9s8jGfb5Qo0rVeXJ/ME0dc9L807ItIyq8f5Wi5BDsJwmS/XkETsuue7Cr6AB3SiYjJ9N6Fk+A/6t1CC4h8POgMxn1ECw/Rvv9X1GfGtHtytr9WHyGPzSsE14FxloU9N1dgbdXseyjf4OlttY/0Ab3gC0BOCtFeIZTtH8n5RWWauAHRhWNk8JH8avZkl0TauOSaasXq0W3E/vFCek6fTTlJqsbu8LsqCMzeIK4xByuz+oF6qt3Y2ZtrIur6pJGBTObDLCKP20YNqEPc9RdbUxmIXpuEjoiP5fhFddPtdPQf37mKkpZjUdbZrQUaMt776GAYBTAfQr5BC8j7MHY4bQmg9ea8madPiT3zgtgo+GcObprwzxTI/ymv9EUFakQhc9RT0MkGI5aEnBjRzMT0bw3WfW0be3f33pEplfnTKIamyz5Kxoq0+rpp8diaTDSaiEbrTRUQRGlrHR+p/ScDepdpwE4KbKKm2ww+HhRLc5bF+0jngt4TLNA2fkxC+kooe1hKrLGIm1w99DlQubL5gpDH/F8QejvyZbdnehT2Lc1pwbzKgqsObfHK9XYnBvXR4U4TuF/UvcsALJiDIa64JTT1oKBa8zkC0aw3+DJxmTGqUNrG+e891C8qMLFV
 duK6m0Gb
 rLEMKHU9bOuJFHi/KeGB8VfJRDrKIzG4ZiZzAPTTTRUTbNW+lsxNYer7DmY9s0RVwVbb1t2GsqHv8eQvskV1kcqYKjwI134oEaM1g38OwJ1jRnp33d0dEIjs0f25biXs6Y9LlNZOkBoyPW4d6+Zy8OeEU1dcxpNh1C+tT7/A6lERKXkBUnNuIwaPu6/FnOIFGmzn8raSohGTzYuSFv3pWc9hfgd9Sl+ElX+TaefshiA37Db6Kd3ycanFU/oQPcnZ4DpwcEokwYDu0LLEclLZ1+WWfjOG5DdqU2lGgVfCLdG9wdet1BQ35nO5Fn8zKlpFT7DskPCBjdUIioubfOaJJkF+8hqPM4l8fQqYAUW8IVJo1cgqwq64g0WtG+BDZxUo6R9h9FLStmib4MdSJh9Mvp4J4IhoU8r9Akwmr01oXo6HjLCeFrxYDdOze0ApzCP1W+m96OdXSGvodw+TrRnqaXfBumcCh0N5P+7YgmWERSMUxwy3KGFYdJlx1Ns+mHobua4LSxA5xDJDnwz32dL0/+njftiTebZ5MWhhKHs/k+hzcIpd2xvsxUmgpjRnzKXbr/DYiR2KPK1YX5z1Ne4rvyuVjVl8EUGgGaQHbQPRFQT2rnf9is6q2oQNt8NHVIkfEGEpMp1+nMm1OxpaEhAlBcAoOduKpOpe1j0vS3BaIjFqbAbd/FSIiYE5xqot1eD0vyZjqTmOZO1A5mtt8SY3HBlMvxjZNM8xG0bFsTJTLM+iYUbY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is pre-existing logic that appears to be undocumented for an mremap()
shrink operation, where it turns out that the usual 'input range must span
a single mapping' requirement no longer applies.

In fact, it turns out that the input range specified by [old_address,
old_address + old_size) may span any number of mappings.

If shrinking in-place (that is, neither the MREMAP_FIXED nor
MREMAP_DONTUNMAP flags are specified), then the new span may also span any
number of VMAs - [old_address, old_address + new_size).

If shrinking and moving, the range specified by [old_address, old_address +
new_size) must span a single VMA.

There must be at least one VMA contained within the [old_address,
old_address + old_size) range, and old_address must be within the range of
a VMA.

Explicitly document this.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 man/man2/mremap.2 | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
index 6d14bf627..53d4eda29 100644
--- a/man/man2/mremap.2
+++ b/man/man2/mremap.2
@@ -47,8 +47,35 @@ The
 .B MREMAP_DONTUNMAP
 flag may also be specified.
 .P
-If the operation is not
-simply moving mappings,
+Equally, if the operation performs a shrink,
+that is if
+.I old_size
+is greater than
+.IR new_size ,
+then
+.I old_size
+may also span multiple mappings
+which do not have to be
+adjacent to one another.
+If this shrink is performed
+in-place,
+that is,
+neither
+.BR MREMAP_FIXED ,
+nor
+.B MREMAP_DONTUNMAP
+are specified,
+.I new_size
+may also span multiple VMAs.
+However, if the range is moved,
+then
+.I new_size
+must span only a single mapping.
+.P
+If the operation is neither a
+.B MREMAP_FIXED
+move
+nor a shrink,
 then
 .I old_size
 must span only a single mapping.
-- 
2.50.1


