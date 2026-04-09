Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F27EF31E43
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 133CF6B008A; Thu,  9 Apr 2026 11:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4D96B008C; Thu,  9 Apr 2026 11:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15596B0092; Thu,  9 Apr 2026 11:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E40106B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:44:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC47C1B834E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:44:05 +0000 (UTC)
X-FDA: 84639438450.18.1ACE3EB
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011024.outbound.protection.outlook.com [52.101.52.24])
	by imf08.hostedemail.com (Postfix) with ESMTP id ED2A9160011
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:44:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZpyZre8Z;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775749443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YQdgFvzFvdqKokqqFaf1qZ5EFrfiR9WD1rOuAfkrqxQ=;
	b=YsYDvB4oVeKkAvdW7BNVeHRUiCYlXkUnScmLB+c6M2AoDnl1IhT7PihmXB2+d/xRz6EDv0
	2yJSnCIFo0TQUlAKlnqct3fVwMceBElZbq8I0nhJr/wNdJxbrKZSHbgV+mrQB9cqIhwc8e
	Kfn/xj110pQsoG9XjimIqZDXpoIH+xc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZpyZre8Z;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775749443; a=rsa-sha256;
	cv=pass;
	b=yG1K/zNOVjTv5jmYo1PUy/ICONlJJC70SBwaF/FW+kNj8bkjJmUy5mtMoLLtpoGKygrfNa
	Hdz2I8cHgZNv9OtrjiHypZMUFpO8ho1s1tjmMrigdK06MNWOHWArAh5zV96U6dmr2SDHZ4
	2rLOELduvFohcHW44W6Sc2/4sufBJhI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qXH/PacrRBGDtgMAceNQXQ8prdRx/tBr0gJan955al0Y34sR0iFLLPf2dxzgwPdBxp4hIVcu+0cDqGo5POJUhA5H7w5UvdYSanuoeytqPNZeclg+0aogwFm/+WFqh5GdQOY1vtARHGJ8lPehyUJ7UzibV53ycl12B0HKpMEY/scQ2JdsaBcSoQtLRcE77L1ppvzMU/KPimqc6yJ4+4SZBDjYbz5eeug0PCMfc1IviKgEnJ0kjt+ZyNb0VwmqGvRprAwuHy3f2sCQmzOmWeVciVJK5S1K6jWdcTjIgnE/JGPH+2Wtb0yGYeDACDNRqCaMgMAzIN2K4A63gSOBOES22g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQdgFvzFvdqKokqqFaf1qZ5EFrfiR9WD1rOuAfkrqxQ=;
 b=K4QVQkjkjF+b2iTtdda6gOhZU1pGig1oFw4UtA4mQMoyAuZCqyn98SUohzC097FiYmNydo1MWZv+toKG9y/fQOsmKIyPiLecNZ+Td4AqoSZOgQURFnjNgmt5hL8DGrPbiTdMpSBv3CjU7eri5akQJtWi3Iq9Jntz6Yy6WgCUKr5x5xT3UsGwZyheGm2xqdMXumDkI5iE9tXW/nE6JoaLZJwqmigT5AqStpMH5v02+H1Rpc7owIr49qhNe5ui8t2jOsnYNNbePpPYwfNBAkzsUB+qf22AYznLt4vhVOW3J6vlv/3E3e5tVCtTeW7Izs2w0fFtKvewDAwWB/DxOysuaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQdgFvzFvdqKokqqFaf1qZ5EFrfiR9WD1rOuAfkrqxQ=;
 b=ZpyZre8ZxjTFOoUy8uWRA/8MXq88qMEp5DaGxujlgfZ6zeOEAwkcNWfnsgvS6IhKFaKOOgoXgBMRria7gZqDRijC2pfws2UlnTDsUAXAwL5y+hpeINiAwU2xJFeQUrTgttpXOspzglkS4G656vmmNoOdk9BA1MtBstnnH53oTd0wshYlub9fPKcTrgdAFYAuoRlMxtsf3qWh57j6qsUcXiWEBul8Qyuz9CEhB20+8FIVRVq2bAHRiQqKFB+L9peqrWsJDEg/92dAXb2uSBKKFZxyLgYNbw60f5vNEHS7O9/g/5klrmb9XszCUnm8M1Co/+cUI680iujAUaakuN85+Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS5PPF7B9F1F8E0.namprd12.prod.outlook.com (2603:10b6:f:fc00::656) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Thu, 9 Apr
 2026 15:43:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Thu, 9 Apr 2026
 15:43:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
Subject: Re: [PATCH v3 08/10] mm: replace thp_disabled_by_hw() with
 pgtable_has_pmd_leaves()
Date: Thu, 09 Apr 2026 11:43:50 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <AD547E55-0F8D-4DDA-8B5F-D11D40CAD0AA@nvidia.com>
In-Reply-To: <9432a2398caef7261ca44355fb7b786bb20bc15e.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
 <9432a2398caef7261ca44355fb7b786bb20bc15e.1775679721.git.luizcap@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0027.namprd14.prod.outlook.com
 (2603:10b6:208:23e::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS5PPF7B9F1F8E0:EE_
X-MS-Office365-Filtering-Correlation-Id: 59d7f41b-4bbe-438a-17a1-08de964ecd33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	6wrqzfRP9o/niMgAsdCW3/wWLD6lIEBLOxQ4rpsXdEY3RA0oLO2A9hANdQya7jWN34EvCA2/Z2bn6EDNiqjJ0j4T6obV+ZkTpNW2yO2XNHe39BoHs6uXRWKQ6UVvRqt+xlI+cpqC+vhjIHxU1GtV5IMtPuYJHdHnSI0KGC1/VRMk4AtKPGOT9qay59MVEuY8X4ooO1q95Ap93lERIBn45tzMl/5/nrRkdhddTLG4xn3x4NiQ4SBuSnb83oaMHlmVZXaVmNaUMJL73rnAD1xUfVc4nBhpO9b6GTVv+IG8oUTkTgT4YRwOLBqlzauJOQWtwl8M7pOCvoEfM8dp6UHCpuYQ4vg7spMcQyfcz8olUMSz8ugWJFhY6sMSp3lcBejAxr41lnqCNKY5W687QTY5+fe3Nzl6i2/GbVet5Q00Px5p4CCKpDJ83ftw5UPNasgro99V0CoWXTFuBLbg1l4lT9/9L+y2NZjRsZNXKja25SB2KrMvNIzirkC1RLJ87W/AQxl6qifPtJ3BCi/1uwJtgNmOQ1KOYa/gskZQmgGjRpciZeCiHJJbshoRqGhQwmnucoCiwj0vFKx3HMS6URzRSFKkYdooIaxYv3ySwkKynhXtOH9LUhcSHw63RXVU8Udgre/WkNwSEzie7MZzLZjbRcWwhKqoDWM8B9TsIothkC9uNB3cm2F3mCHtZrGNSC8R1uxVJEOnE1qXF1S6h25G19521Ixxuum8ZFxc5EutwdM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qh+226NU8IXLH+UuUl3TPxnap2A7LHcITUPuf/G4VtixcA+slDO6NkGwRcdp?=
 =?us-ascii?Q?dAIDntsGwyX5rAr1ALDwh8Xd5hXd91BJs1CO7KgnPhIY5e0gd7qxMQRYWDbE?=
 =?us-ascii?Q?Vp8M/C98/wp/X2MgqPUhv2JdtbOYawIr2PfXNxkTMTIuM3UYCQ+gIH0AnZDu?=
 =?us-ascii?Q?9FP17Pw3D0ND7FQLlfdBr1uOBU/MPzP4y19h2qf4yLgZcVy3JaOQQXgTn6IB?=
 =?us-ascii?Q?63fsOLP6tyvuOMESyW5coezOtpnj3qB6nNpYwZ4OWfgmMeN3vGrm0p2mSYMs?=
 =?us-ascii?Q?5jJoBoC189iZ5piJKpKWSdPZ65AQCBBTxY297JmjXorgHVnpmmkVpJeD+eFM?=
 =?us-ascii?Q?c6tl2sA39blty5Louphv2bixlwI7fNl3lZNIWUjezilkRX2AlpBSJwWuJ5AH?=
 =?us-ascii?Q?ndrRuGSqaFmtqPV0Pzu1qtFPHXoVflI2wmOZgC8JGCiNsSwDmCdwWvuS/EWo?=
 =?us-ascii?Q?xoRJZw2QgevztZ5dLyst8wye8H19Yb0qdNy11jZYcFRFh9uib9HYogEua/nl?=
 =?us-ascii?Q?BF1blDbBOGGUoYch781Y2yswQqHjmwiRCku1Whs3YPg0XAey+rFq8RSecG3t?=
 =?us-ascii?Q?8DVsqxZktZ7PWfI6UKWgFaRTRUfFQbIGxRgaC2FZP1dakYNa++XTON/fH8Rf?=
 =?us-ascii?Q?6YF8pNWXnil7HFhal7zpuXjmqeEb7fP1ImC/KlyXAK4VCdcHB4aEJ9Gmwk/0?=
 =?us-ascii?Q?zovXWRCK6vNHMk/O4inOK6KymETi7zx8SsKkXMl04Gz85xwcnPDFFxwmEMdt?=
 =?us-ascii?Q?0CYelCZ5pgMc5WjHKUHyxno3rwUt7kB83q81C+nyIPE1KdtQB6tmzWD+pbSF?=
 =?us-ascii?Q?PhCVI/Tb4SAnohhwqOwZ1NSNvwvJ1n9R39OAeQKMFnbvbkz6FFXMuccPnPZi?=
 =?us-ascii?Q?fJMh/5oyWrxIxSJLqCvozAKcQnXWrwfAoIQWBQw7cbCm5eVENUsQMLK/T09M?=
 =?us-ascii?Q?vHiFOTrR9xmA+FowjW/2+/LjBpEubZs9Am5Zu4f5lkEu57aoc+3t4GK+t9dq?=
 =?us-ascii?Q?GqBYNquM9II5sUDZCSLKBqwsSusOq9voO/AJH1hXAFGB/9JpUCVcfFAdqaOw?=
 =?us-ascii?Q?CjmEU9Sp/jtLmE6YKm6+9vvdAbHeJbJmg7shjgs3PTTEBJEKomKSZZznICRv?=
 =?us-ascii?Q?fz8LkrlG5xE5qLfJQdrVKeouREUawcrRk+fQXjsdtcPgnBQ2HgiZ1e/u3N6Q?=
 =?us-ascii?Q?GZ32JrPH3MegsTO1FLjx8+KQzpBDKdEXfKEblNgj8aL8YoLGTB+wbYQERVrT?=
 =?us-ascii?Q?bDQmt/5Zh9vi7NkcQ7Zmd28fFLSgGS292DbP3nDpirDG0txGHWXY4GOzy87L?=
 =?us-ascii?Q?+j9SZ0Vz4V8q29nfPir1//9xvJYq2BjUS1m8olAKGo8lh5sd4DNxEMW+iJyN?=
 =?us-ascii?Q?s+EcAMbJx8oEp29bZX0O4FDjrK1xH20qNQLa5HmNN0kHB/nDFVJ3mv2lD94l?=
 =?us-ascii?Q?4TZYJ/oTgbYJ4p+iqA1GFerRZTTabVe8GcXZf6y9yutxrfLjsgSxZn5dQyoO?=
 =?us-ascii?Q?h+VpFErxTCaE8SpEJ8y9hAMESfjaCQqiEJS4nOTl6NUxQOqrs86cjWGMGaZt?=
 =?us-ascii?Q?PxE1bVRW9qcK4dYmC5W3ToTf0CfzFzgeGU7UXj0Y3f4Jf5DDTsBRdeVl1zRl?=
 =?us-ascii?Q?GUGSQGE+PuYunNpgXgXcM3BpdDcCDSfya/YGiUjnK1xGF5kEVHwtLngApAso?=
 =?us-ascii?Q?BGugfdxwx7HfW0uhgdknpbkLbzMpzrK5/8RGxrAm7EhE4mMrfnchvEaTP84l?=
 =?us-ascii?Q?/zcZILukCQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59d7f41b-4bbe-438a-17a1-08de964ecd33
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 15:43:52.8782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lf1jPtZlDUKIjKNrzcuZkXI+gM2jipHHOdQG4d/LuxwuuPv5sZs5fcDK3uudnluJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF7B9F1F8E0
X-Rspamd-Queue-Id: ED2A9160011
X-Stat-Signature: jwdmteim7eeom6gajp4ihjc3zotm7hfk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775749442-667384
X-HE-Meta: U2FsdGVkX1+PmuxFSdgmb9Rki3Ovhe7bi5F2XHawShUZ3SJbn6RYZB2jBtU1E5Sdz8kNlPUbF4SmGkn5hZpU3fBn8BrMyIuFVsdFTKcD7BkFGfTMma0yTIXTwpD3gc7fodZH3gXNdD+Gcu6+YFP/VWf5tHjBHhlzczlrkEx0fXsQw15YpW0COF4DDyDH6ktErUDc0JkS4cIGOq2587jfbeEB6SCAtZXHB5WuyE/H/CxNH9BnLO1P43dU4n8nM82Q1/VNls6MYTn3U4zvfQw+MA79xyeJBAQcxSY+lGV0FWmr06U6dBtZeawt3Xtv+GqrC/XBpmo5UACuZP5jkryK1zCHHvGEDHRLcbl4L5CELkS820sW8iOCzL2fuC8dh7OHH3m35JjqxofvhQYjPCqVTvR8Fb2c2Jm14ogUx9fLx3TWgjCQVMRqAfnJQoveasWCgxrwOfP6LFylAbI6ym0LroQcb014Q3PWTybOJ7xE78lXO/DoVOeoJ9WJ5ysOinBIJJYiTP4+3et1m9UchbS4h1hMyMMX9kiZ43mijCB2u5cLc9UdEzpag1Up0lCSbs5TbNwMiQYca85Jq+dudnCDk4v/vkNetB5LqUqo0Cd7sBgUNZ8Cfqp/1rX6b2YvZpO+kB0q183VsCEI9OAAYjqd+hDLXS9v8A4LEnuvVc2TnCdxjEA6UvPkZD6JvRJqF8zh0l0HNGsjBh+G1g2mZwDod1E4OxnMF4Ukx/ZKLHr0azmLt/QmtAzHezHn8KcahgZAVOZ8dY+vODCH3txlbeDTWW8jCv7o7wCXDf0C6ZctGfOWCpCuK5pB7iSve/Uv0UgiBql3ZrJNTfgit3j9OZnV5801q9ApT4jyy/PzfZgp1MkANnckSI1TzWXVcyjADYnkUw0z3LGFLHhXzVdjzW0Se4H2miCROsSfA804LU9l3MKJvLBUfFTGwqa5yg/i+qdcyymlqVyDbo4PRnoBStM
 k6pUhLpf
 kVZ6pBkseqrVA+tDjMQRjbKVJqLLhlJocFTg6Mflw6qJKexo8HQjrhPM+OP3FbtZpyCVwMjF7RIwD2isHUaqJsitUxLKP5MEP+h7oNOzBWRQuuOBaCoRin3clQOC7Is6egif+p+IuhvWkn1zYbGb2aEeBvEM0/NOQ2/sSmy7dMKH5/NDddW7Dd6G1mKSYj/aoJ4hKH0RPcpP1xprY5OFeFrcpToVmwQujpLQoiQ1l+BasVBaZT1JYfgezh7KpB3uAk8brYxZKj07B5yENwhwZGGCKsDH4vWDqn8hTxKd5vmM/5/lzL/1lx8f3CvBkm9/lPnGmBfBFSzWXN8m9pCjr6iJgh2PnhdeHDHol2B5C2ygprMH4FZD/3lbftu6HjWggCmaaqChIbpzpJOmwWaAG51CgKcQcgL10X2JR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Apr 2026, at 16:23, Luiz Capitulino wrote:

> Despite its name, thp_disabled_by_hw() just checks whether the
> architecture supports PMD-sized pages. It returns true when
> TRANSPARENT_HUGEPAGE_UNSUPPORTED is set in transparent_hugepage_flags,
> this only occurs if the architecture implements arch_has_pmd_leaves()
> and that function returns false.
>
> Since pgtable_has_pmd_leaves() provides the same semantics, use it
> instead.
>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  include/linux/huge_mm.h | 7 -------
>  mm/huge_memory.c        | 6 ++----
>  mm/memory.c             | 2 +-
>  mm/shmem.c              | 2 +-
>  4 files changed, 4 insertions(+), 13 deletions(-)
>

LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

