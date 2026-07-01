Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD37C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 17:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533B06B00B4; Wed,  1 Jul 2026 13:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50B586B00B5; Wed,  1 Jul 2026 13:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421A36B00B6; Wed,  1 Jul 2026 13:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13F5D6B00B4
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:02:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0D361C3547
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:02:30 +0000 (UTC)
X-FDA: 84940826460.05.E539AFD
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013056.outbound.protection.outlook.com [40.107.201.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id B4DB71C0019
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:02:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="oUcOhQ/m";
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782925347;
	b=FnWo397pvtzPfhOISTpcjRLOSw6oc7R2zp9IRcxly0XJHhtnUz3Y+o9wSwcfz1H+P/Noqb
	X66T/bD9mIcxwtPQho8VhLx/iiL7lK+O+yO8kx1UnMhiOL7cnqQtbr4mTw9+T7cveI3wMY
	35nuzbeHQiFNm2F4Y/Mm+lmrb3+dw0U=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782925347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVnBKJowPjp71E/JDMtS9AVKXxwYEIDe9pbguoW+1QA=;
	b=Chxx7eTpexPQC3yYx9fRPIzsZbLgV5GubthkkurI8M8dTYjKDc7UqD8Ko4HwwgJMnonb8u
	Uz+35Em3QM6g7rRw1p4tWybtaShYYpoa3w6kfF6ppK0NPgqd8TPs370zS4SMsbAMtwU2uZ
	6F0Lnkv9Rh+LcESg+aqGHmXaNxzqFzI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="oUcOhQ/m";
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YL6qBXuPLCj+ro7omumsKkemGDAMHikO7WUk4N9T6f+I9yU7RmZFTZVpKY7O02wqYt+PA3BVceIVKs5n+BRBLdLilDCz60iibDBYoSh248S1iKqsdVjsyxvTCrXXfC4gyn5XJ6PrJ6Y0dvojFyEIZtbF6nbnHBy18+XhGuEVXOAJVEZlC0UjOq5ZVrhStGubyzD/1rgbQcrnCvLEZgieUp8o3q05K5WQ1sCRcQPVPc6rvMZMRwB4hcZV8c/ABV12YZkDubKNPLhdEWTSTb2EiLmXUudd0oNj1+VwZuj/8KRZCiObt30y6jVP72cq1TpcjSvNL8fvWJtICuimY3WA9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVnBKJowPjp71E/JDMtS9AVKXxwYEIDe9pbguoW+1QA=;
 b=EnlAkqW1+jGSbsi+i9vaaVaMXPsjU77Bd+uQUDRudbfV+rKMRVZHUGaU+9IOM6ZAg2oW7PQYUC348ydi5JlRNpMwZMNBP9htlPXASMel0NVUA5jDdUL+Sxg6fkFOS4xZ09+/Yej5KpRzZZRNbb8gcHiKJUwmtg8oGZAnWDQW4T/eUZ2+DVXoXVZkgK8fGd2ae9MNrjEB+M/kmQxbqXwA6i5Q7v8VPSDfyo1f1sTkrJNwH8/dgVcH7syATlnj0qcKnyIX2m3HkZ57NXZYI+ArMPhv1p8cFSjKUz7C3/Eqs7QYl2Y4kVqtm1sbWnjSPIZEqZ1yY9liVKAHjzy7Zhwydw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVnBKJowPjp71E/JDMtS9AVKXxwYEIDe9pbguoW+1QA=;
 b=oUcOhQ/mvJc/YBPv/4XJ2/PJ8q9S7cGPm5U+9AkUCjzLmOppbzAE1KZmruhHje05yfj4Fs3hno/Nk6z6umcGF1mKFPrep951IYQN5MPHLe8WzcvDpPl3fGkCY2P26nI6tB5dMxUxg1+G/LYgH488BIpq7YeIGJEI75P+zMp/H6x1DBRiO5fMmLNcC+DwEhRXVUuGeA6FfzvNTDMkQHY/RGEwsutfdpvZNTHulMtrQgzokekM0kt2ERVAt1EVIpqgv4BVrxsk5CdAchfa8iqsyI7tgfRqQ8jWUPecyT6yOLiVIVxTcWV7LwtrA5ku0E/QQqfWked5huy/b0Z60/Y06w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA3PR12MB7999.namprd12.prod.outlook.com (2603:10b6:806:312::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 17:02:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.008; Wed, 1 Jul 2026
 17:02:11 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, david@kernel.org, gourry@gourry.net,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 matthew.brost@intel.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, kernel-team@meta.com,
 sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/migrate_device: pin large folios before splitting
Date: Wed, 01 Jul 2026 13:02:10 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <78C557ED-3CF3-4558-9BA4-C43B30E63F67@nvidia.com>
In-Reply-To: <20260701140638.840773-1-usama.arif@linux.dev>
References: <20260701140638.840773-1-usama.arif@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:208:52d::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA3PR12MB7999:EE_
X-MS-Office365-Filtering-Correlation-Id: 5244cd9b-6cf1-4a6b-f375-08ded7927e39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	QN3waVmYev3aTaN7lIDal7gQesI5wti0SZ2GcN4X6qJl9btkYs68BnlbLtEUpzrT6vD2h5+y/EDbg4Iw+icZt517zMJATkBbOPV+uRhOmedmEs5pUeaKUrQbNMgoWrKppp6Gusy2kSY/6cg8e1tFLwfdkp6uN8B6ERRZeG6YnJwm/D/0fGsvEYnAT1ygBdletC8fdCw7MsMNMqj/7qlkAiad8Kgelyg6d//I1nHudq279KMI1WT9ut8059cEsylWfzgSQti+8MbXcWq8odCtv8Y1GirUtPXq9n9hs6ak9mcnqJ7fNKyikIukc9AWivdEWiyQ29KRUBz64HclekgVeXvwM9Fh19kUSKawJFN7p2P06MRAEV3JqGQWbW5l9sH4N5lLwWXQY5M5e2IS/gWLPSl4Uh/QGcr5kOX9h23IDe66qxVzabb4dJDakUyv0eUCyZxG1mrkKI65GorjwkCBfUSvx83HSSYmRrhgSb/hGwRpk2aEZyb4KKjLYvDeC3ose2kMOklQWU/G/58tWBjA/KKfe2hgscb+mnsPzn/eoRq1SBA6YtvHPx6KEsUaGx/AugbvcBjWIh2XcsfiTHW2E8qL8azs/1ZkeVA/rLt3TN9aPQbvg4/D0d1oHA1QZ7EPUoaYwDrIQCpGmiGEkhwiPDh5j/fwiHeUTjnr2/ddWAk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0YPzBn4H6WS6NxaozeqwFHEndKStp9V5G2qu3NlW79FtNsI4PPGVWe9TMUaF?=
 =?us-ascii?Q?hrCabX1QKoJKeayLPKXpjl0lzzsBNKn16uoOzfSbmv8BXHqKhRplY+29efKH?=
 =?us-ascii?Q?sLFcgC1m19vkn2gyyNoxlJje8x0os7ZuPsaz5MHObrw+jX3jmKjpcUhO3ZgP?=
 =?us-ascii?Q?A4HLjRE/9+a/OHnSF9AOb+yBo73IkJ0vyodMMhg+IVTn/xq/UTaTf/+R9STC?=
 =?us-ascii?Q?XtcXTEeWeF75BAhZwtLjhhjFyL6vcSsNhHnbXTZ0OjIkRdYzZOjwgXdZPyA2?=
 =?us-ascii?Q?h9bKMVNafH/CVprR91wAXLEph4yyf0uTwjyL38EpnEKpybCYcwP+7Y6uwmdl?=
 =?us-ascii?Q?9MiN8UsI22Aq9OA/37dgMmnqrBFhfBPIf/6RNepbnkHenfElpiNJ7zDFchSd?=
 =?us-ascii?Q?dHadeqDj3Y4aS15MppV2QQS7m2D0yQ7JI+hNLKt2zKmvltZjjZhN96N1wI8S?=
 =?us-ascii?Q?14SAMxPhO7wboOVasJcgW/mpNK1mC/YhhirGpAwizN87sFbpj34uM+uRr4h7?=
 =?us-ascii?Q?t8mBxcpjiF06jCj4SoBnJq0aApR/HjbyCm2fgqITWoI7hlC1bPScvhv2dwL9?=
 =?us-ascii?Q?v608XRKd9kKSqaP+3YgRgTB7X6e5MXkdq/yKDZ4qD5nX4K8xkUzz+yscaxL6?=
 =?us-ascii?Q?SZdSUDZKFSO5U+NyIatczq3S3FyH7it8GtUeNF1qIuqeBoPqVY/lx+DbuCh9?=
 =?us-ascii?Q?Svkp6q+uXlRLnDoJr5kuJpxkex7glKo1OUBSzLndBAwjytF6EJx2UgKQQCYW?=
 =?us-ascii?Q?YnwTMOvEHBSSE3oDtzT56sj0EuAOnMJ3h2s8XIEJyK0/rdIo/EXAVcAmFlIu?=
 =?us-ascii?Q?JfTibswiG5/0eXDBQ03F29u1vGuxLLW8BHRmvYNKmr8qjId28+CCAs33THtE?=
 =?us-ascii?Q?75fgrw6iOEdz2VSQH6ceEqKGRD123lyF3hLgrCoR+QmFbyxwqMZOJBbgYk0S?=
 =?us-ascii?Q?laC1cUpSRH5wQGNgMAE7zhMzy0DrTRl/V9D+Dsq61nuZlri7hJexJyxqb2Jl?=
 =?us-ascii?Q?ywAZ6+buuDNaEowkOL1HQ6X8XMnZ63vPpn+O34aLC+Rg8iAqBla/BbqCB4qA?=
 =?us-ascii?Q?UMrKG4/fcfGDEHxUDpZGnf/9q96vL/LLjCVBPv+LWL272MhhY93P//vMy43h?=
 =?us-ascii?Q?sWVi0ksTV2tYiko3W/08XqyuO1c8kINd2w+KEwMZyZ9Rn9GWj0mpBTm7CrIZ?=
 =?us-ascii?Q?hktr2c093nFkBVMnzENyPvjzMTaCRQNWletTPPbsiRR9uG+ZVt824hNayYLg?=
 =?us-ascii?Q?ABlJ4DPOysDBMXNsUXe/G98V69h2kjbK72/j0CpmtIXejtO7XIwiG4HSJSYt?=
 =?us-ascii?Q?g28ra4Jl8pW9q2kw25lQWZcqnXtr3uvU4HVaDHG0gFYlnrmy28Y8PfaEdoUf?=
 =?us-ascii?Q?pjsd7qNxxrPaPZkfjP65OIBs9bMkA85CNMPZgxcub7iezWkwT1NG0bNiNsxm?=
 =?us-ascii?Q?1u4xH6qOc1OrYNSOBx623Ryo4YBJ8hOnWNHfmBTqalekaM7FYOEiAYCH7NYb?=
 =?us-ascii?Q?h/fSGQWxCRtKuMMlK3zjuj99wcFkmZnMFxiXOteDOfyAG9qd1cXKvHzow1L7?=
 =?us-ascii?Q?8bGu3MISEysJd8DTotUM7qEq0zo5JbP6z2qPcWAa8vjO6vaJN9yB7wBGzYi0?=
 =?us-ascii?Q?EAq3c7/zKWBOMKTJhGoTeV0HrbaJPjsxXuM+sv/niiW1b1k6XJgqeOfIOOXf?=
 =?us-ascii?Q?If168l+vfyCjUQLn9o6c4EsS2eJDDgpB+GeS+11jL/SiRfPPBjwVkYdJn5Yr?=
 =?us-ascii?Q?Oq0H6GtHLQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5244cd9b-6cf1-4a6b-f375-08ded7927e39
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 17:02:11.7796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9y8RTHlCSGir9/WnynHSlKOgAv43R+QY1+6njZMKmfnuBFpN/O5nczYMVDTWm2N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7999
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B4DB71C0019
X-Rspam-User: 
X-Stat-Signature: i3jsj4fsn3mmku4cwk34w5wuff5za9s9
X-HE-Tag: 1782925347-358152
X-HE-Meta: U2FsdGVkX19UUhmmMpv4gFPlh2lfK/3y+q1kl5vf9PBx+dR9oxAjlpXNcGlje8VtAKdoHxj7mnByLHhPaH2X6wXSh28rplVd8FnZFUXJ6FX6hLinuGlISWg7o9QEXnP+cZF/vTMouJMkrF5gN3lyELCwaFMOqB1FJN9ezH48jwbWh2fczJbTART2SUnAU6Kbw7viJ1/GvETH1IHGwqRJ/cZfMc4W4oOPCGoj6rCUI5QNDnvEcZb1pFd7NTQUqFjP9nWKOZ/Cjsbrrt2MsyfgVeumoJ0iACLOADcbQXdc1t8NGKRcz6HLPSwAqcOgqffw3F0yXoAjwhXCE0MJ46kgqKfzICy0BhAhRTh3Jhq+5MqPYtmTwjoJvxfMV/+OQXRSTSKrmwsGvKZ1Bq3jVADZOA5QV9VUfwSk8HLGZXmx3f567wKYcDmlmjTLRJu8UCy4406k3JnZMj9MnnjgyxptNdjB6L+rq9/ylvraOCZgAsVS67+55KLD9ZDjjwziDg0VmGZqFM4EPMWy1Smrz4i2ASXNbZ/O+Cp8DlTnEzn5tPqD5ktedpwX8LdzNGgLZZEyAOpBa35NkRAEf29GZT/coh31ITBg6SgqVFnvPIxb9y3KeZ/3VWF3e4LRa9nEpKxDJ/RWYUGKe2pazsJ1aV0YV5GpXiRkzB8atSIZt0YXin+Iwo8LsK/GadHoaGeaZh3gvup4xjTwpHVwAPYa0kFnSBbHjm38wCDNYDUWNamYoNgOsUDfGKL0XLJZHZeAxWgZOU/Q22T9mwXympEPq6rhBwqYmQovWDli+/ATGiaPSIADyi0CeSQlFdjdyFFErsjTdtiwQ1XFqokus1hMqrZNbQzJOfGTwmQIftGoMLHhUFvuLJbx4Ej1XYIxe/3tWMGln9fiQX/WEkwM/u+hD8JXdEiMBGJhQegWKGOw41cCFoCgnPkQMMPwxiC4qD1/FMiycM5t+vR5j5zH5C9IiCo
 tixSgXG7
 91X6g9zqEUyLCOqTR5TjQpSaZfd5ogotZJr5ORxeVnvK+9od5c3BTh1sItmLO7ocApFGd2ik6OR1fBg2XZsYXhf26lv0vvD76tuVLTm+qvTdirt9JuK7BvwawAG7BHKgiqpI3EXxVDboyWkUO9vCNC/q39L6qulI76N6poqlSN075TTaycRONvZddcTDFO6rRbr9136LpojBrZ8xBW5hdmbcEWhEaU/CNO8mdP/pZcMiXZ1l0uBzWAJAa76RR0E4lnEXN3JgbNQuDmZPqyVgqAS9BCRM/D1eVtRPyyavD3ywg4GftJpupMKullYk/iZNyiY79peXoN3cAQx8ql47fFZAT/aEA17qhsiLKlEXVATUH1/ErtLAr1btl+66zoxqn9xJ++bmcS2/E692cz4nUjUB3gphRGugUFKciyb06wYO83boOsFpXeoLmg+sN5OXTY8o083CiY1AaJCiAkgzfTPY+wzgXZ75dhNwg95qfEEEZVYblCi3QbykmN2qqKNEmGjqE5+kXBpKxOG0WPdOpcrmiAQ8PKS3voz2nTQdNHbuKhEOEgZKde9wNRsiwHImGULAO6PMyLWnoNdFCswh/TDcKFmm212sCIkRLXMzwKNWvBaTGJdOFwN6FTPihLd1IOG9G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Jul 2026, at 10:06, Usama Arif wrote:

> migrate_vma_collect_pmd() can detect a large folio while holding the PT=
E
> lock, then drop the PTE lock before calling migrate_vma_split_folio(). =
The
> split helper took its own reference, but only after the lock had alread=
y
> been dropped.
>
> One way to hit this is device migration over a range that contains a la=
rge
> folio. The walker reads the PTE while holding the PTE lock and derives =
the
> folio either from a present PTE via vm_normal_page(), or from a non-pre=
sent
> PTE that encodes a device-private softleaf entry. It then has to drop t=
he
> PTE lock because split_folio() can block. Before migrate_vma_split_foli=
o()
> gets a folio reference, concurrent reclaim, migration, or truncation ca=
n
> replace or clear the entry and drop the last reference to the folio. Th=
e
> split helper would then take a reference and lock on a stale folio poin=
ter.
>
> Take a temporary reference before dropping the PTE lock and pass that
> reference into migrate_vma_split_folio(). The helper consumes the
> reference, so split_folio() still sees only the expected caller pin ins=
tead
> of an extra pin that could make the split fail.
>
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260630164143.1595669-1-usama.ari=
f%40linux.dev
> Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios=
 during collection")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/migrate_device.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
>

LGTM. Like David said, the comments might not be needed. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

