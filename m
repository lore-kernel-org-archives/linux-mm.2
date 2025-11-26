Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F885D1118A
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974E06B0032; Wed, 26 Nov 2025 11:59:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C596B0062; Wed, 26 Nov 2025 11:59:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815456B0098; Wed, 26 Nov 2025 11:59:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB396B0032
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:59:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C906C13B96B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:59:42 +0000 (UTC)
X-FDA: 84153369804.16.E377F4F
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012006.outbound.protection.outlook.com [40.107.200.6])
	by imf07.hostedemail.com (Postfix) with ESMTP id E93614001A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:59:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SpojF9tf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764176380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xl5lnIdOOTgG326S/pXPnsGhfmlBj4+7eWOdhdwo0+g=;
	b=YGAYRS8jowTT8uLvBfD1QE6HyqFf+kNaxrJpomqRg6zDqpDH/THTntzi4YdA7fAHyvD6io
	Cp/OGOpsmUZGfh5EcK4U6WBJWkvzvjFkkJMjTS2E0VrC6GmzC5P1Pqnn0OJHppy2Jry5KO
	e3CDqQyA907k77VG9r8WSMcHJIzblPY=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SpojF9tf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764176380; a=rsa-sha256;
	cv=pass;
	b=dHKsVa7RjrHb5xwTkG+2UGoD5z7hgfotKnA6t/K0pSOIyOtRGOLOLnF00H5X8TyD+hlXzS
	T+ZPdff+nCO5uxtD/cgPScRsSWQdEfPYq1weSyLVKxHtH+LsBjaglF6C2+utgMutFWQdAQ
	Airl7FMrPOX3xMjuojU2KBmq+98eL3A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eyyenX2HjzaHDK3bC64HYR4MG8pWSvEIj2//ZnL+gA5OKbnVSNniIFnSoXabh+CVCCJKMlbDjwM0Su+u1kQsRynkLAfAktg1ECTX8U9EMgAL0Kw5NoPa/f7Lsnw2C+MKnHzYkO8n5Nm2r7yxHU56d2wOcIaULqSk7hZfJqPME0YAKlJ40DHNivb2scN/VV638DtQLJkIE7zDyOh5TyLl7Nb/jhUvxXjsqdhfcmfwZnGo9lw8/UrxRPnTYtwaEqa9Hf2EF4xdFrXIgGyTNK9+g/1wyoBkHepHRiW3hlSquiQI97MGA+fGhwMtuJy/+JD7zC6q4C3ZW224FbWCF4XVag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xl5lnIdOOTgG326S/pXPnsGhfmlBj4+7eWOdhdwo0+g=;
 b=N17+7WVriU5YnqsuzPjxZT0yPd8McCv7rbYCP4VlHMoFRXZig5OZL4GSOFmFNyg+Uysi488ykGj7u1ClQyQl50I7uTxCMGqDc7R63EyXGs8IPdGD3motXl8d6AmtJERQCR+lJjKfDLu7nVbBCUHyu2DcrHQbfWC22qtB0ykPfIW+Xk+h0FS1JGPF0WD6y/Ig+PyTrH7DqUZEDiGU4YimuskWd+bM/Io7eIpP+sYfJZIIaNeecTX7KnMhZLWd+d6dJ99pfssHyedCLeLFfftg+/AUih0jZCn1fQPp2iK8wR4o95EDTGLX2IX4Xigmm/QTaZ5pmyeQJmAHIMLNW+3hvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xl5lnIdOOTgG326S/pXPnsGhfmlBj4+7eWOdhdwo0+g=;
 b=SpojF9tfAeGhuMrYg2smtWU+KW1QA7kaBJH8BztOUldzjF8zvivOyk5AcVSI2DBZB6C2sNnAv8vV5FdMzLFjvu4YQJCtTrKtnRWo/QfO8VskGEVQGALw6IDEaeaaD0gXzM/Njl6m+d5WKuuFFWJT2e1Mi3MC65tXxoOvxmCb/hM7tTMrG6wXzpKv4RaZMJBOCfUmHanaHlAFCyoEltEZtYRsnjPUD2mJrviJlnrLF/r08nni62DGJRYT1tNGRYryi6vMkvldkAM6XB/9oLNxiNBVtuuoueiLaUEsd0n5KC1r1MStJM0xOMUz9yV8CfG/dAIVHe1gbL9hgFTpr9fXQw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH2PR12MB4055.namprd12.prod.outlook.com (2603:10b6:610:78::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.11; Wed, 26 Nov 2025 16:59:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.012; Wed, 26 Nov 2025
 16:59:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] mm/huge_memory: replace can_split_folio() with
 direct refcount calculation
Date: Wed, 26 Nov 2025 11:59:34 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <992DA160-BF2B-4D38-B76C-481F49155652@nvidia.com>
In-Reply-To: <71b8c4ab-3f4f-4b45-a9ea-706871463a83@kernel.org>
References: <20251126035008.1919461-1-ziy@nvidia.com>
 <20251126035008.1919461-3-ziy@nvidia.com>
 <71b8c4ab-3f4f-4b45-a9ea-706871463a83@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR20CA0048.namprd20.prod.outlook.com
 (2603:10b6:208:235::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH2PR12MB4055:EE_
X-MS-Office365-Filtering-Correlation-Id: 4082bd93-4e97-4a89-fc50-08de2d0d2dd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bsb5BrDGx/rzhX9hgeu/4qk43mXLSgKHhfkaYsh13SMiOHlz8cIePIF9h6Wm?=
 =?us-ascii?Q?2KLFeuR0Yrr8bJMqXY4OTJ6/ooXPlqJDwqznk1NYSSlWkw9jUlZ/O+DCeIei?=
 =?us-ascii?Q?kWtauxg3Vt6dGd3bNKv7naU8lOeEU5wlrHXE4qTqhjRNCQ+IHem1z13B3FnB?=
 =?us-ascii?Q?E3UViXLSmqXBtZdMGCIE4N7K3GCOVuol0YxTZJijjyau0alIU95Y6p9I5vBh?=
 =?us-ascii?Q?jSz4ySC3Wpq51pWWhQGBX2AJglVgp23BYtv9NWcrj2zIApvhqu9oZgEvVu11?=
 =?us-ascii?Q?3T5jW5eiG+so0ej7/KH5jwEdRrf4KhRT00zjnc92YVoCU63m/KJfaM9lVvSQ?=
 =?us-ascii?Q?pBY34nX3wCv5rKdB1LmCV8q2DtVgddY3CPOtVKRJYnQ6wvSnG+mL0PEAvhGK?=
 =?us-ascii?Q?DeNtOwQi9B4WMz6krvVnNfJZ+62Szlpyk+MXu13xNAp6jAIGhIjjngCVjBOk?=
 =?us-ascii?Q?58oeXoKkUHqJC3TQZM6ugUwzcB5x9EYyhPCC07CvZWoIxA9Dd0zt8biXXkIg?=
 =?us-ascii?Q?EW9x7wy1rLmcNW03xrMIePDu+pTRRyjpa5h0akyIRJZl/GgjptOXw2fa0Zza?=
 =?us-ascii?Q?yAau/LsF7NTRkBTiB6m7MiRmKOMpBY3iEKaFGVFUTzjiWbdDPH2o4n++y3f/?=
 =?us-ascii?Q?T3NfRm0q8cJTbo+n08+epU41WzpWOfunK/bg/0xvp5v8qDbI1OWZ0vJzXQeI?=
 =?us-ascii?Q?Hh8UvmEAPzUc9HXjv4Lb1KAFx3JZQOVsRYxbIn0Fv5ZXCinPOOXeyspCjTRu?=
 =?us-ascii?Q?WzUjHQabf/sdGpX69fjVLyQ9NHPCejMYjSNQ7+HMAwN76JnlmETs5wbleJtD?=
 =?us-ascii?Q?INvJf8JiiwrwZSMT1zatB7yr0TCJuDxR5Tg1WJzM5woxpzZof30wKrgvYPe9?=
 =?us-ascii?Q?Ajqu68+h/qCtM+nEGgVM4YUqj82pMU8HywmBcmCiOJZL6f8obaUKuD6GFo9C?=
 =?us-ascii?Q?8ls/wfIW0A6vq5BFkcEoBJOzPVvfdzuBzvP2LE1C3YhyksQwJ2/WQYQkypFW?=
 =?us-ascii?Q?MzTL8GUbURofqXu5yx+IM5A+qWKcZip2CtkCPTd1Fp/+IOZXjhPwdsN7ngKS?=
 =?us-ascii?Q?58keVdk25d3bb6LL6zxFrS25mUodabdBsKUdVhbhheb8Y23OSzuTyyy9H1c5?=
 =?us-ascii?Q?+N9E0VAdtsF9600vcdu80e1qZSXlRTCaE25VRromebbbjLKKN/qe1Z0lYe0a?=
 =?us-ascii?Q?4skqog/2zLIe4OhR0VdneQo/Z38FdjQcDTTsM7E65zLVoYnvy2A/ANuZIE1L?=
 =?us-ascii?Q?B0jVUatXUfulGb7QBSYvUV5tAXuS2W5g3I83faDXqevseqZJONeWoj0miGLe?=
 =?us-ascii?Q?+r1vFlouF4bQ8LKhApe9wFejSlBHnDY+B4kSZiPhiXJGj5ob75yiktRwgSRd?=
 =?us-ascii?Q?CsLT2Hon1EMnY9+VcehDfWFYUTdXYsWR8HeIZaPjxdFC7HYXex/zh+7fJ/Mh?=
 =?us-ascii?Q?XmqSqHhTwziZ4SgnyeYQG5z4iwnqAI6C?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?akcD/vdYqysa8izzy1QJuSsCN1LF4qvwhE656skVuauP5GadOkrnw6Ir5cmS?=
 =?us-ascii?Q?vaIco28uMUNpBHYFk8ispk9lngBmLH1o6Z0UwDrfJy5YvV9u31aDdC8yZlw7?=
 =?us-ascii?Q?v70xAdh+21iBMS4CP6sGZcHENU3pKj9H7ueVC5iagSX0pJEj/7QSYDCfqY5m?=
 =?us-ascii?Q?UBx3msrfoql6AnDlIdJCOInDBxzcypF+gljXkajT6i5/Kfa7uzTtPw7ldBxe?=
 =?us-ascii?Q?mrMuLcPglGg8Yjw+Da75cvh6LSyaRudhoV2PM0HFILJzficSfBpMHgv2vEZL?=
 =?us-ascii?Q?oq9z4lf5YH+DZRrGDJyWdoXPeH696T6IJZCLU4iIJaXRsEAnTarfmicpQKh1?=
 =?us-ascii?Q?PW7gjfBFGXU3YeYZSVBSswXHYQv0n3k+/Wga1aed+NlOtGnd/XJhFJIT4XI6?=
 =?us-ascii?Q?OPIo/LiDmKW7XLafeJlIDoETV8Uz9Q4AlQs7zjCK4kLVA67Q1Xsl6ZOUw3hV?=
 =?us-ascii?Q?poAPWxvn+wPc6qnlhIos1bse6GKNt+hJQ9R8WZCodx83Kgw7WooKrwPJ6LZw?=
 =?us-ascii?Q?+1ZXPInnOSa5s1/gd6c6EUwcX0nwc0yVL8yJ7xvfd3IruJ7zDvRAqftL9eY4?=
 =?us-ascii?Q?VHXwSd3ykRl+02yjCCtoPsnC+SjmSRZBums5GFDSqmSFynZ59g4wbbII/ptg?=
 =?us-ascii?Q?T5gGDvgMKsFUUInffYn5o+9Ufm8AXy4QKLYzdqZnqmRCIwd8ihsakWRdKQeN?=
 =?us-ascii?Q?IlzwNkZmo6V/wO5LgtmuDG0SmCv77uVaWP+gQJOcDjt7uJvUs6MSOEnoGc39?=
 =?us-ascii?Q?pGYDSkgHX55cYB1HWF99dIg4lwo6XrdAYkgrFVK4XxMzQt+wXbYvoiRQerdp?=
 =?us-ascii?Q?LElKErcJ7FlLi8+hMWhG0sQYJr2fL1TaW0cO6mVkFkJ6D4JJZzUzVwvTx23H?=
 =?us-ascii?Q?okN12M45BevvbHYceh827gZXNhNXjx+yoDoUXeggg0vKRK8eBq+8jljpUBZh?=
 =?us-ascii?Q?kASQl4I7jEe5N9FW0ktqafpfaDg+F/2aEMFySoz4D0l5ZsFpSJMVCS3h9EXs?=
 =?us-ascii?Q?j+vBiP05AlFrGzZNzR6mzRVPS3oZCLGamXjYrttYRf2Fn0fWSP2eQjqjCO9G?=
 =?us-ascii?Q?2fr1qftOAfHu71psNBY5dFOJEnjoHQDpWHDc7s71YXo4PG/wIAWQ4YFa15v3?=
 =?us-ascii?Q?QVE6GtUOf5GhaMcaOgMWNaBVQueic217lJW7f9r/TBcqxC905pqTr91JVjhl?=
 =?us-ascii?Q?tiZxD3c585Gwk2OvIjwqFjmZp6V+EdQnFxratD0ml0KCxzrP6XY+z4BH+li6?=
 =?us-ascii?Q?bHuSsIZdxaUKyKJDc0w4Z/RjGmdUmnBgB3m9Vhnk7bgqBDbIEpXXIFuPP084?=
 =?us-ascii?Q?rICZEwshBBVpv/g0agQrrKk9v9P4lX0D6Tq6Kz2POws4PyNV/MvRPt3hXzHE?=
 =?us-ascii?Q?t4qFYJZ/oswXcuG/uDh25kNAL1Vj3BNf4ufTIuK8SBaE1cwWE/LyIl0bFVQq?=
 =?us-ascii?Q?3nUxp+Fk6rLTwurdEUpb9eY/nZvPR0xCibI055n6Q39Lo0R8Stz/lsVWuiX8?=
 =?us-ascii?Q?3EQIcCf64zEEFG4TiQsd4dX7oJtAMSe0T2a8mqB072jYWPmU04WQQg7NLJQk?=
 =?us-ascii?Q?n3Czuk3IfF311ncgUeTNfJQp2+PNwbZZL1IYN3Eg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4082bd93-4e97-4a89-fc50-08de2d0d2dd0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 16:59:36.0696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jBfAWrg7czVIrtWylNPNMdrzfxCwjXmY1uaPd7ilGUE9YgXRcT/jGzu/niQMOv0R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4055
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E93614001A
X-Stat-Signature: ru9iwffqhpnroo7wypmi7r55naf153pu
X-Rspam-User: 
X-HE-Tag: 1764176378-937986
X-HE-Meta: U2FsdGVkX1+zZ5wYd+PRATET6CwHNDfO+Bv3xo1Xm8LMr0KIitt45a8uIIBHD9mRn7Y3R13xGyA9BuYxffBDgggQh3e8jAfnxhG4eHOU+yDk7ogT4e9oanwn6dCkF3QgmAaau3KMhThfcXnslMHIlKftGL8AoAu4YaIdcGK6RH5iy6mqaUOH/UWqck0wOmc4QE85kGh/iquv7wAQFaTtyhBMBDT6ARnYlncojwXvRxowxtOgWRyor2Nekh/k7k/1EPX7hVbfikADOABXvzz4CPOhFbd4qr5JKCv8Od1BNnV/YEouOMb8e6GeUTn3E+RgtLDtE9zzjCUATkd1JbO0A6iiSLVHL8nQp7YQABitVk72j8gexBmCGKFwOBIxPFKez8081L1W8FfCmCf4mR49v50gm4liRpbgv14kg2aaYdKlIItifQWEkEFmfoxFZ7FZA3QjaF3VQON8k0Hmn1B8wrHnd0lLQdr7ViH8r2iUF9kg/HRTUmWnI3lewYI6P9WFydI4Sz3Ky7u9Mft+N3hDJrHdGY117yD9VqSGwEsX1e8TM7xBwmFbSz6rJ+gf69WerKkauOrrNQI67GU/Co+v3Oni0/TWXgTSIatHLSNMWhkh8rXlHH8X3XKtmivi4R19O6Vz290Yut2In01Np+UtBBaiW5+enSui8WJqGd+URTSvflfrr/xaLAK9QItqANCkVaJ2l5xsvPm8vfO+1c8+ZTrcGhXpK2RrHXYBxD3eWUmc2R0dCWD+cw/L13crykncjp0+tfPWxZK1F0bYKChgexHZ1q6zQV6JJEtOms+vgPoVeeU0hObx/6xNde8yb91de7h45Kfv3p/MeMO8E3EFfnAK+i00DZcnAveLQj0d4oVyRIsvdcB57iFsfhklxXwGSalmgm3wCX7jZbOehTPxTz9Ah8RnbexQPLCAx28WG4z9KVpqVunG6H4dAb8KL4veMQmiRLZK66/5DojzVFA
 jfwOjLF0
 rCefROjvj1GimH9VTn4Z8LeWZwmKiDRMNBRGwS/X4w25RK2LliCg/sh5WGpQMFg9AAAzRdnzU3zNjbNbcUCi5gYABfmIZA5i2f/Us2o2r0HGDrZ2fnZs7lX3E8p1DsMcatlfmdzgutny21kxmTXdA7z04JlbtkZxoqwFLRyPwEXOd1LbeuEVLyV9MhTit2N1zS27J0NspLCRMCb9ILSSAGmlG3qGhOpRWwbg5j98PH0RvvLUJesci12gY8UsmQ/s7Kn7BLqOtdQgndOTo5cUNPjhgCT2pOtH0sQqiscaB6hh7eS9BirzQOi6mI/GMGY7n1pw2LhdmKlYizxc2Dot2VZMm5/Y0nzOddqCkA4YAEU8hH236A30LjU0Od+MlJdfEiwrAkrc9fwBQkc5a81fTkeGDaZuCD170j1aMb3S2SrqRNCb2ipWl+DWoIoziQlpBPjjr6l9MPGB0jmX8jY+K1PJQUe1YXcrPZ+hScXtKVZUMs4g9zA5rg4uTkGhRIQ1JnkBh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26 Nov 2025, at 4:56, David Hildenbrand (Red Hat) wrote:

>>   static int __folio_freeze_and_split_unmapped(struct folio *folio, un=
signed int new_order,
>>   					     struct page *split_at, struct xa_state *xas,
>>   					     struct address_space *mapping, bool do_lru,
>>   					     struct list_head *list, enum split_type split_type,
>> -					     pgoff_t end, int *nr_shmem_dropped, int extra_pins)
>> +					     pgoff_t end, int *nr_shmem_dropped)
>>   {
>>   	struct folio *end_folio =3D folio_next(folio);
>>   	struct folio *new_folio, *next;
>> @@ -3782,7 +3773,7 @@ static int __folio_freeze_and_split_unmapped(str=
uct folio *folio, unsigned int n
>>   	VM_WARN_ON_ONCE(!mapping && end);
>>   	/* Prevent deferred_split_scan() touching ->_refcount */
>>   	ds_queue =3D folio_split_queue_lock(folio);
>> -	if (folio_ref_freeze(folio, 1 + extra_pins)) {
>> +	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
>>   		struct swap_cluster_info *ci =3D NULL;
>>   		struct lruvec *lruvec;
>>   		int expected_refs;
>> @@ -3853,7 +3844,7 @@ static int __folio_freeze_and_split_unmapped(str=
uct folio *folio, unsigned int n
>>    			zone_device_private_split_cb(folio, new_folio);
>>  -			expected_refs =3D folio_expected_ref_count(new_folio) + 1;
>> +			expected_refs =3D folio_cache_ref_count(new_folio) + 1;
>>   			folio_ref_unfreeze(new_folio, expected_refs);
>>    			if (do_lru)
>> @@ -3897,7 +3888,7 @@ static int __folio_freeze_and_split_unmapped(str=
uct folio *folio, unsigned int n
>>   		 * Otherwise, a parallel folio_try_get() can grab @folio
>>   		 * and its caller can see stale page cache entries.
>>   		 */
>> -		expected_refs =3D folio_expected_ref_count(folio) + 1;
>> +		expected_refs =3D folio_cache_ref_count(folio) + 1;
>>   		folio_ref_unfreeze(folio, expected_refs);
>
> Can we just get rid of the expected_refs variable as well?

OK. Will update it.

>
> Apart from that LGTM, thanks!
>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Thanks.


Best Regards,
Yan, Zi

