Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 486C3C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9316B0129; Fri, 26 Jun 2026 14:29:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CFD36B012A; Fri, 26 Jun 2026 14:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF9A6B012B; Fri, 26 Jun 2026 14:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3EF66B0129
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:29:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 614831C320C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:29:33 +0000 (UTC)
X-FDA: 84922901826.03.292A105
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012065.outbound.protection.outlook.com [40.107.209.65])
	by imf17.hostedemail.com (Postfix) with ESMTP id 868D34000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:29:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qp+U4IQj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782498570;
	b=LnPDEuDST7l8BqqVd9L0EBfZ66WEOxrAwwA+ZrlASmujEp4++Bk74t3rULsifw5U5+XFp/
	UZXuoTnRVaFTNcSB1D5hm1zY86yScPX9PVH2jp97QvnfasbbxMBzULeltGwxUe2hBA7svD
	3LigvPxULhgHMPSEREiUeqMx/7Y3/RM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782498570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzQgOPdWw4YBC88unmzA4sFC1cXc12JJbSp7XisiPkI=;
	b=RmzADNrpQ+AqCl5xtA2YhgLxOrUzeiSiAmoGwsDyi4fWJ2+Rr2S8d8XEsBxUxmDrztcSie
	pfTwkNfunxztPYhZwnTYSnqCIYFZvZfIMiR5QV1R9O2/PHYj2Lid7v69zvnj9D6riYaWgk
	U03W5t2ZOfdKD0347a5BA9teDjA7/nA=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qp+U4IQj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pL9uYvuT79gcmiI5X3feFlivXQty7sWyI32l1khMLe6q/NgyEEo18mCFQjxZ4cDSaBNKfJp/noI+Eo6CPQ973IOx9lSoRwLjzthZp0ppspiL5v0qOpV+tANVJ+PFGSXJkbKGN/nLpenFSqxftH3QGFKkxwGyP7L1QMtMgKz7w0ajSRNH8RVQOeNXgO1lFaQ0XsZZZ5r7VmNy0N+vwQ1TzrFpeL7ei68ZCBheDFfsWxIjtTCjdUv0lJ0pWquH5ODQJQVQv+8cZOs8DUYeruHq5h1BIoMiExMAjgB6qQs5t7VH1howmexliJMjYP1VOBwl0kpXrOh62+HPQbuMc5/tbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tzQgOPdWw4YBC88unmzA4sFC1cXc12JJbSp7XisiPkI=;
 b=faghYYobsP+8O3RGDfISIo9anMFQA4+q7xvvVCkrlsxcqcZduauSpo3Qm2wb/J1kjAZxRRFfDu8TNLK5V29XKAG+HEUAku6ti7Rb9Pw7aeVsWpGBHklXZWS+dFYebiK9ig5zXgMBkJYuXd1+Dy32SgxGegzuneSFFSwbDAtCPEWUhqUj2nf+uAYWFihFIe7iiqaGdNNmznezFbtSgGnP4XbSGf+DgkWyzuWErbfQzsFyJ3+TjPF5XVJzEMjnYr+aT8nR6fawPm/0qFoLPZbsqJ+boWZfMXS8kZK8+b9MTtS0qVSd4n3CwCY9Gb+btJR1kPr7brYaS6VgJkIQbyqZ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzQgOPdWw4YBC88unmzA4sFC1cXc12JJbSp7XisiPkI=;
 b=qp+U4IQjl5M7EFDkMf2eQEQtEUQ970F77Ndv7L6vy3zXEHe+G9aE1CmdRwwFR5fYGRBz4gVQmE25xYFzpU0u8oV/+LUmrK/A384UE7iCNhkEV20j7JjX9mzI7PZ5g/E8rVH9XpwHSqFJfjVwjeRr8I/ISQ6ow4ZOSrzBSDWLrs6s7bfUcTYaOQVHwC3PXrup7wrHofiUNqPtqPnjR/nsCw1j/S0N/+ZMNYpMX7j9qqjRF6SNoXJvGhJrjq7/VdMhdWP+sjeJCbnB2t0snvhwxVzNqWeLmZvTOEfq4tvULzRjlD0hcfSmJ58VlqOayHfYd9QFXx/eScVLfp5K2DO0cw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Fri, 26 Jun
 2026 18:29:25 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Fri, 26 Jun 2026
 18:29:25 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 14:29:24 -0400
Message-Id: <DJJ707PKYUZS.3VQ58AKYG0XNP@nvidia.com>
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Johannes Weiner" <hannes@cmpxchg.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
X-Mailer: aerc 0.21.0
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <20260626182215.1107966-5-hannes@cmpxchg.org>
In-Reply-To: <20260626182215.1107966-5-hannes@cmpxchg.org>
X-ClientProxiedBy: YQBPR0101CA0132.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::35) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 34e5a745-9e2f-4739-2ae2-08ded3b0d9de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|18002099003|22082099003|11063799006|4143699003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	sesGwDeyUy0+mZjqd5Y37t12ZvXcppRAzLhFGor+HmONrHdMqo4zJ/XIK3RSz2VCGVPBFM7SGB2iF2gjZJZ1t1vIFyxeFZNk0F4EUu0uFunsK697/Uphf8HTsfn9eJuCG2EeufB49QNIdrkTHT9TjP/NbSTsI55dOFRPT2ys/7vTQkVfotW+dNJU/LI9vo13e7G+AgVFEJ83NTDcdXg/iIfGP3JG8wJCqlJaYIjTKYDxjvYO14G43cAgyfazRzxRd6ZfyZ3R5CzDQbkDB9tUl+FkgE6a222FeR4UZYmsYyoqoM8eVwygn3MsXNcUnpIGasImGyYmThZlOY0JOmglQ8GDfFlyV6EGVDwUmmUT/8kLBXPJovayOH2iADv5UOhQYslIX6Hpeag044fUV4GuWSYS8usoMedhZzIY2jDJygHdYppcBIUNRbLV+b9ITcsKb4e+YC9HXuYpmTABn6IM6aRN0xzLP9rjSQyiji03urpMBFy/F9xOShlyjbW7oJ4wWrV6SItwIAG+kx40E9W+KxIjOx+D9GJsUrN62ve9/4be7ABzveCyJpQ1oJS3e4Zj8hIb/i/V5kH0NcIQii8NAa8AXgS9ejKABQXWldyaIE+INud2/jc0uPrOGSwtPTMZYccux1Xijv6uuqSDE1tJCi0Qb5aIa9ZGtmn7uqwMiv4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0p0cnRVUXhocTVEeURuNk9tdjM5WlFOVVlGMkRBZkVidXd3b0xQeFYxTzIx?=
 =?utf-8?B?WnNHd3Q4aGtRMndGSGVqaGRpbndOeHB4ZzBzVU13ZnFpa3hjL2xwNW1XTTla?=
 =?utf-8?B?akttMTJDNzlyN0Q2S2FuMFl1SnE5R05HMVZpZC9rSnRRS1A2UTlHU2dlZzN6?=
 =?utf-8?B?ZHQ3dms0N0hpbTBKNFBiVm8zclBjUkNmYi80RzdEdDBYSENMVEN5VDZhLzV6?=
 =?utf-8?B?eGdtb3BmLzRPQnVmbEZ5elRRU0I1VWVsNVRMT09tTFQ1Nlp2ZE5jNnF2T0t2?=
 =?utf-8?B?Z3R5bVJCS2laRnQ1bVBaN2tKS3hhbG1GMXVWeHpmZXp1Q0VmSi9lTEV0SVVU?=
 =?utf-8?B?eG9HMDZxNGZLd24wSXZ5M2lsL3NpSXRVaU5QT1cvRGdhcU80WDNxd0xpMTAr?=
 =?utf-8?B?ZXFVcUZTdnhkK1ZNT0c5ZmZIQTZ5WTNYQWZva1BNY05jViswS3lsVFN3N3F1?=
 =?utf-8?B?LyswNHlZNUF6WUY0SWhNL3h1bHozNmtLbGg5Tk1SSHhGNUpqMms4bzNvaTdO?=
 =?utf-8?B?Ynl3MDd4L3o3NDhydU5Oa0VlbE0xNEdzeVRVYjZxR01OUzR6WnlSVk1YbjJZ?=
 =?utf-8?B?TVpKSk5EUzl4b1JRMmdubW9IK3QrUmFQbWZtSFN1dGRvT2llSGduMDlGczdj?=
 =?utf-8?B?aWZoY1F0TUVxQTJSdjhEam5tcUZmcWZkYVJxakwrSVpZeU9LZFAvamlSY2Fh?=
 =?utf-8?B?YUhDMVVzc3dmSU9iZWtkN1JHa2FQc0xmbkFJTExCdExJQ1lEclp2dnpXV1RS?=
 =?utf-8?B?cFJHU2htZlJWdUFVZngrSk0vUjhtSUxXaWNqVVdKRlVHK0prZzRFV0pIeGRq?=
 =?utf-8?B?aDR4UjNuTmJMUjJFV005K1g5eU5ucVcwQktYbFR6cjF0RlEzUXdVQVNOeENM?=
 =?utf-8?B?VUx4R0VzVllrdENETjNPRmRueHlRc25vQ1BCYjdXTzBvMlBZVGlISFRNTFIr?=
 =?utf-8?B?U0VRY2R4S2NYazFYVi93WXVSYnJaM3dvZmV3TjBNdGI1djN3UUlhcEdlL2hN?=
 =?utf-8?B?bCthUW9IakNFNTBzQy9ONVczQmw3Vm0waUhkYmVid09QcExiamNXV2V6NEtS?=
 =?utf-8?B?UWRpT3AxRzVCdkcySitNWm9UMCtOUXhMSVJXanZEQ1kzN3pHSmRqZ1FhRHZJ?=
 =?utf-8?B?NXQ1WHFiekFWL0lCaFBra21GSmNkWmZPczFFY2plcUFvR2ZUMCtTaDhmMmFN?=
 =?utf-8?B?TDJFeDdCNkRabktMNlQ3R1FGWkNDWkJGNXJPaytJSngrZGdkUUdRVWNnMVdl?=
 =?utf-8?B?cy8wRkFTbTdpaG1FNGdYRzFKWHY2Q0hiVkRjVUxtREJHVUhTZHB4OTZTZjFx?=
 =?utf-8?B?cjhkQ3FiYlFFa1lNTnR5MUM3ck9VSDgyaENsMHVESUtLaXgvRFNFS0lCS0Rj?=
 =?utf-8?B?akZ0TE1hVUhFdCtqN3ArWHdORm1pM3h0eDFHYmU5RjhWaHNpVWZVNkxBemFi?=
 =?utf-8?B?Y2FYdWR2Y2I1SlI4MHhuRUw1SEc2VEdOZVk1MW9iYm9NbTE3YjlUekFqOU45?=
 =?utf-8?B?Q3hHZC9lbVJhd0kwRzdJdzBuc3dZZjU4WFdIempJN1N1UUFoVDh3YjREQ2RX?=
 =?utf-8?B?L0dTZXZia1drVStOMVBJcWlIU3puT1NrK2tJT0VQSUdlNjdOT1BpQ21zR21l?=
 =?utf-8?B?WldjTnJ1aTRSVFh4RXFzdGFNbGpKWVJtUktrc2x1VEZJK3VJQ0NPOWg1eTVG?=
 =?utf-8?B?OWZaWXRvc3VjbG1OMkt1OTB6NktWOFJOVkIxWGQrbGhjOGsrYVdRZ0tMb3JS?=
 =?utf-8?B?Szlmd2ozMWVCY3pPdjI2dHJ3M041UzJRREh2OFNqTklJSTJxSG9MOUp0UFkx?=
 =?utf-8?B?VWRFeG94NzlSU2ZTaDEzMG9nd0ZzbUwrQ3pFQ1k0VGVzdXNkK0dFdDdCai8r?=
 =?utf-8?B?ZDJvclo1dmQ2SkUzNWsxSE5JMHQ3dERpdmFCUStuSDRnMmV4U3N2YXZCeUlR?=
 =?utf-8?B?VW4yZ1dOQ0R5YldXbElwem1mWVBPV09OdkZmOFpwek0zM1lSMU5pblRQSW5v?=
 =?utf-8?B?Wm5nbFY5T1Y2QUJwRUhUNFlpUFJUS1c4WEpJd2w0UGM5dXJ4Tm1UMkFab1ds?=
 =?utf-8?B?YlhDK1p0ZzJyMm5wK2N6V3FxaGtpWlZHMGE2TWpVM0ltSVQ4bkdwVUFVcXlB?=
 =?utf-8?B?T3dDeU9sZ1FGa0I5OFZQWkNDS0ZhclJBK3h6dUgvMkpvdWp1clVNNnlGaDZI?=
 =?utf-8?B?NnNlSkRsZjRFd3ZBYkFqbUpmUVB3ODgrSEorSi9laXZlS0pqTmk5YUF5OTl4?=
 =?utf-8?B?MkRrMzI4SjVaNVZ5cm9FS2o4dmFNbEVhQy9XTVZaWUtJVEpSYmhBOHlUN2kr?=
 =?utf-8?Q?I0el1CIWIZzTBYY9eA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e5a745-9e2f-4739-2ae2-08ded3b0d9de
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 18:29:25.7166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GSQtJs0hb+66ve42fWB+APmkJ1RUw0AngE/vMrEAJEyTwB1UxzhEibve5PK48mFM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 868D34000B
X-Rspam-User: 
X-Stat-Signature: j41iae3q441yzatq648a173hus7city8
X-HE-Tag: 1782498570-761418
X-HE-Meta: U2FsdGVkX19fJhmzxMEVjuOBOZ7vMtR8xCCngEBEnmQQwcLuqEB1sUE6a8+ZxLaELj5Yf1MGKYmhX7+rYqXcYmpeS9pOUp2BwB37MW4ErrS2J5W0Fao0rl3y9jZh4a3P7WmFpfckJ9+MfsyQGt0Ft2ghoC+XtS7egz5/kj5EiwotI099+TJRyazj9+NZBJtx0Lhu5vOn4SNVIFuWQ2yLoYGkkPNcolu3IifGYcnHBiYqG3q17orvuA7UBNzH7Nh5YcHY2baH10yCU6u4j6gUeHKycOxtIc4S9LnHgnqtKkharYudLXf11V/0/XDBGVNMetBVbP07LKWPOaZTGGGHDBgRxAKv+6vn6JCVw5V8zCSW7Du1AGvS181auEry5HpEEiiBHlfwgIQ39HmQIja8q1SK9Slh53KX87oqTzIL/HfiqW0m3EC+YNZPGZeIWBfBaWfnPVuvGTJ0zhaC4gnGju0J0PGvJ0L9gHEv9WmsOHIqDk5VRvXEyYMmnCoCsG2Mli4ctWpT/TSsPpEdqPdKhG09kZthLkd7jELAbLEhFiMu25U6MpX1Jyj9RLCZoezk4bCN/QCTRlZuQItbvxsjNzVY2KmGYOGGtw6wQ8xAfAxDWeaUYt3t7sVsgKL4i116mXnCGQGs6iywP8+Q52gJZn734dJXsCGfks8kEveT6hWwhtl4WjrRmc6PjylIfMksaXOpAVVgQhaKcuaJS4gEVOddHxN8i+wFqq39AkSsuXpl7vDKmvHe38K3zM+xfpMJhdSgO+6DfHfrcSZug3st9kCjxIlTxRs3bazGaTiz/eFvlyfnYb5W3PqmvWYXf0ZJXKgSxFDcOlaoyTZyCSSP/j1c/zNTGWpIekE8wNtSBNqGIC5gz0vi0XU7vfgVt5efx9z/jzhU1KHMNOuKgM+CxEmWR6c9CGvegHNbnEkvjl3NMG4d0mth0G8adZSKVeVEK2o6AdhiiP0FvtyGtOf
 XeMEtGhC
 xUHOUoEuy1U8nJx9txLP1LEVXUBweiZZuMpn3Ayrv0i5fs9i6BiA83KalcjcI0eHbsHhb6DdYrWWOLqMEJfsmTe+ZUBglZICTOnD2hzyfk9TacTlL7Uu4XND1EuA6sMRJiAy6D01cSXICptL4uXO5wO5Pc45Tc1TWY1mLp9mtITawW2yG/9UTszOdQ68BJWeSD1hJByJKWquiYa6WFxP/nsk05px1Ow3v6yh9Bbq/2ogPX8KPgw4KHaE7WdZmcFVf/U7i4Dt+OVx246bd4YoC0S3Pe01R3dqo2r+9ZOH33gABUYdHjctc64AOP7BesTL3ZFxwRp4W0BGkR9HNoKCguBnLEpaQsrzyUTZbqUcmcYqAKsvfbfGK43uTtZUPNgTsBJeiLtendhcG8UWZPlw2R6+Vy+6hL+D3cyR0x4KVT2lazMKEnN/MvfNrSL5EnchFdLNHF0xVbqnOC7B5//wXyh3BeZz+AdIblrhaDWv/9tLfdGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 26, 2026 at 2:21 PM EDT, Johannes Weiner wrote:
> As we deployed defrag_mode into Meta production, pressure spikes and
> excessive swapping were observed on some workloads. Tracing confirmed
> that this is unmovable/reclaimable requests spinning in the allocator
> and direct reclaim, causing excessive amounts of swap.
>
> The initial plan for defrag_mode was to rely on kswapd/kcompactd to
> produce blocks, and if those are overwhelmed under high pressure, let
> the allocator fall back (__rmqueue_steal()) after its retry loops.
> However, that retrying results in more reclaim on some of these
> workloads than we'd hoped, sometimes excessively so, spurred on by the
> !costly order conditions in should_reclaim_retry().
>
> The storms are dependent on the request type. Reclaim will inevitably
> make room in existing movable blocks, since that's where the LRU pages
> live. So if movable requests retry on reclaim, they make progress.
>
> When non-movable requests spin in reclaim that isn't productive. They
> cannot use the individually freed pages, and the process is unlikely
> to accidentally free whole blocks to meet the ALLOC_NOFRAGMENT bar.
> They spin and overreclaim excessively, which tanks performance and
> triggers userspace guards like swap exhaustion or pressure based OOM.
>
> To fix this, send non-movable requests, regardless of order, into
> pageblock reclaim/compaction. This way, they help move things along to
> meet the ALLOC_NOFRAGMENT bar. After this patch, the reclaim storms
> and excess OOM rates are no longer observed in production.
>
> The longer-term plan is still to have all requests, including the
> movable ones, help make blocks to spread the cost of defragmenting
> more evenly and fairly; combined with proper watermarking to reduce
> allocation latencies in the common case. However, doing this naively
> unearths scaling and concurrency limitations in compaction that need
> to be addressed first. Promoting just non-movables for now is the
> minimally viable bug fix for the above issue.
>
> Fixes: f38356df6474 ("mm: page_alloc: introduce defrag_mode")

Should be
Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode").
Since I cannot find f38356df6474 in the tree.

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

--=20
Best Regards,
Yan, Zi


