Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B94ACAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 19:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1BCC8E013E; Thu, 18 Sep 2025 15:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3018E00F6; Thu, 18 Sep 2025 15:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1AA8E013E; Thu, 18 Sep 2025 15:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD108E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:07:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15E7413AAD1
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:07:51 +0000 (UTC)
X-FDA: 83903305542.13.695271A
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010011.outbound.protection.outlook.com [40.93.198.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4D501180003
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:07:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EqYM8Wnl;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758222468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHQ1GsJyq37ZK5GSdbMI0I3uZiYr1KlJwQp2czvbGPM=;
	b=oQ1cBPte6Ir2i1dosc20wtm3Kqdd1x0cy5Ohd3TuaNUfA0Vi2/GRJ3GugKb2Hb1olbJ1eV
	C4Z6INdukoFJkDfRXq6B5q7Lwb2bT/PxvSZlfM8IoQBeUWb5wo5Ux4yWHDdeTtKPglxzWz
	YDmWtTuvSMblcvMW7jcr6vU2GsLCeVk=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EqYM8Wnl;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758222468; a=rsa-sha256;
	cv=pass;
	b=de7mRjc+FlPtppwEfgKU2vKyPVj1FB1UvS8fXPQ4bBnjbEI9WpyP0XLFO4uiL1OYQDfx7c
	+AzYdalCSbmf19qfsi58WGQkYR9sllFHSoswAcN45BQWm9pFzKDl1/A62KFJVe1OqxIQ/V
	aO05xMb9GDFoP6KtHWcxpc7/+e5rA7Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dfIZPUWC9wZltFoq7Ckv0gDtGRJHebPIJogDWJhqVV6Z29RW5tXuYQVCttPh0p9vQVHaIq3KbMcVy8DxAao0L4kW4pOuH4PcK6Sp8Nizg5bxqxauyGonyOgqk93FclDzSfpQjc44Wx2pZvkh55mscAHQg8hbVHRwJtXsM9+5/kKvhn9eRqIY+u7Y3ZjpynUUPFreSdQAXkuWLYoZ03m4lrr4AK8/VkcoyAqj13w7P7P/AhhuQgkBrUpB7oBOuXZpMOx4VI/karLeEKQAn0+IGxFL8O5/5Ep/zktu8lEEIUXyMgXjZFkpCN4lcpWKbNx5C3xo5rUcwJ3QKMEjK+AsQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHQ1GsJyq37ZK5GSdbMI0I3uZiYr1KlJwQp2czvbGPM=;
 b=WJi5xfuanz8qcgGnqPpJsuqTm7RObP0HoQmMJoPuU4R8oR7HR8QrC/txwYtk3i/N+dxRLhGsKpaixXNszUDj89twRITALiwy0gyXdYfxDkanGIV0Cfv8jx5eZ0nSx8zLCOjBpLm4/Trm82qcjaAD+wLHKN5t+esf0VzgWnNTWen//AzvA4loKnpN0hXF3K8il11tyHbrcFM+wUOedeOsqfeVriaN81Y6e/YyeSGzYGjtRmutL7ONkegz60Zvf6MjGBEeId89S8IOZ2buosYyH7hiZH+8x2TLIBv3QY0vwispK7Z16E3JdqZs296nJcJQrN9mvmbp4h7dQHBBxUa7+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHQ1GsJyq37ZK5GSdbMI0I3uZiYr1KlJwQp2czvbGPM=;
 b=EqYM8Wnl6TparRrGsu1HtVAzNd+gFiIR8JQEHobTYQ5qOV2B0gBRv6SHkXwwWQnMD6MoUFdVFepi1ZHOyYu8KtlfRqtvEMO+GcKkHZGNfDSjPp6YACY5CjFJent7IdRM64v+rDLxOHiFOWQwWYg9RJs4wL2uQFZbQe7lY0NHiiN0G1zh1+N2aiN7mww5oTJqmSzww03g+hw5Dvr+5N6hpqlxg0IEoCtSVzgHv30ZBQaTZX/9tIw83chGvXQnepiNlK5+seuaUKkVKLtd11fSnTEa+i8ezdY0+7n7MtINcyUCXA+0sV10aFTD+MkernIzJY790xbOEspxdnyPxrW0YQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 19:07:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 19:07:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, kirill@shutemov.name, hughd@google.com,
 mpenttil@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH mm-new v2 1/2] mm: make is_guard_pte_marker() available
 for hugepage collapse
Date: Thu, 18 Sep 2025 15:07:42 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <E6C0F9F8-B024-45DB-BD53-2BB964EC7703@nvidia.com>
In-Reply-To: <20250918050431.36855-2-lance.yang@linux.dev>
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-2-lance.yang@linux.dev>
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0044.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BY5PR12MB4209:EE_
X-MS-Office365-Filtering-Correlation-Id: d54abd97-fd5e-4ffa-54ef-08ddf6e6a607
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NeiCL+SWIip1DeH/2C4RfTnJGuZssLli4fBKy+XtYvCnb6wsLF7UcoadTOrl?=
 =?us-ascii?Q?Yqmsk0k3SIlof5LtlK8XWl8kWdVRUW98+aD8DleOmkjkQ9axMafk11HgN402?=
 =?us-ascii?Q?3EMNNugrMDjLQVyj1r2cE4G5f1TwW99t45CHEoMv8fyq7CNE2kYkIlbC0i2B?=
 =?us-ascii?Q?nPjHsCXd4wz5/Lx4Dsq8fEB6GLTEXypv8fG2lZV+ScChzTBfQ6BTVacrUEOn?=
 =?us-ascii?Q?w/ZtBYEO7o+HXGH9UhCNPBaV9nGtpDUlWLg5dP5S8qYQy1fDxyQ/UO8Q9XhN?=
 =?us-ascii?Q?vqGsbt+kDu759kvBi/XRZzT/nOerYv728Ai6KX7w0HQel7nr5dRF9jeG7gT0?=
 =?us-ascii?Q?p0FoI6nDKgM1uSgEia2M1rHWnjOGqHsrnM/gtpOcaZa+FrKOF+uWjBysiyOB?=
 =?us-ascii?Q?HLNuYX2YeHptod6cUtg6GpUqz6Y2B4IooVW8u3AxSU3ImRgNfIF0wrn4l5kN?=
 =?us-ascii?Q?f7hDRb/sMsSQXp0maAq7gZXedYBs8lozAGGYau1nxGwcprcDNnNC3WReIL23?=
 =?us-ascii?Q?iyXC00Lb+yl4w8n/5L2cRbtT+b1f6oaOHIAFmqgds9o/LTW6cy+pGe0dA8gq?=
 =?us-ascii?Q?1ebyqUxYzNrh8kVre6uIZA0jaPc4fZT1IEmphAav+CIdqNWZ3HW9QZXqWjMo?=
 =?us-ascii?Q?ZrDl2S2M4VjNUDKK1yflxxhfXqng/UyvVL83iPrvi0g9fpBOzLjcjgqvO4qI?=
 =?us-ascii?Q?Dz0MO7htuu1XDdFcLjnip5ED4zGQxrlmi+onZjV8hkin8iO1tO6kLFYf3jr4?=
 =?us-ascii?Q?KGsZa8GJzkA3dAaqajLAuqc3InfK7lZrt9QFjpVQ0ozG0ey31YGYDg6iMKCs?=
 =?us-ascii?Q?3YdhG/njJHXHUKHobBmQtluG9Uhbi5/uQvrkz+woGf7VJlbqbYMeOVaveuXY?=
 =?us-ascii?Q?tKNjGW+DLg+QfGebXhyT5v+7703PPnX//KEoU+GBHQEEi7nRXNhH3/D2Ges2?=
 =?us-ascii?Q?AIKlLHbAhYlgOFQwFo2A+uMVva2czPVIztBDZef5721Q15VN8yyo6HnGMPUS?=
 =?us-ascii?Q?SNcco7jnZkZrDT29kS6MG856SwxI875rJNVZ8+Zksn0mkS/YqDDHgaeynfxQ?=
 =?us-ascii?Q?rWj3pYjmUxHT5+UZ8niSNQ7NEFHfJlQRRsCBCSjQDoKbVNmFwSokFnmH4ApP?=
 =?us-ascii?Q?Tt8aXYJH9S+/GZmxavyKPe0ATlNgI2EIHshPKaw3gQSh7CTmIUCBi9mD4iqI?=
 =?us-ascii?Q?3vpbZ3h8+iJVXQyC0VejhiLfnHp834hg8iY+pm+2OuAlZ2fFx+M+80Qgv90X?=
 =?us-ascii?Q?lRrUhXctJf20qZKHBFpFwQGMYi9CLt0UOZas/XP9Yeh6Sg4msq7a/xm4d3Ca?=
 =?us-ascii?Q?UkmjufpIRqoL76g2dkkF1TRhyHSPfGY71Hzw8D5qua02g0hwH4fhVgUjYBBy?=
 =?us-ascii?Q?RZ5gXDu2Vwq6mSbF/qh3LrMdBZNgt2u47hXknd6A/goAMKexCg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?syBBEoadb2CN8nQfevmzADrsR3iWaQp13urih29wIXVlO4WhaSLo3ZhoY2Jq?=
 =?us-ascii?Q?mbuw/ke9bp+EeLqRzcZtJr+EAeyi/kkLedpsI6AJyBgHoOHsW/tXOLLnbE+p?=
 =?us-ascii?Q?KFppw1E3PRZHP/61p7fHN5vmC+arswNdZYFxUro9Vg5m7GdNn/hfUG+LjdN/?=
 =?us-ascii?Q?QFPXdQfUr/UmeHp/wHVL0kdydc9lUU8MGO0Q0Fq0nriCQRbEsZTCUOLeus/4?=
 =?us-ascii?Q?KZ7rhsTMzwZheY14kHu39dzjrG7NPC/ehtdfLIcYNP1bVJQk3mvyWtlj6xbC?=
 =?us-ascii?Q?RoFOiLlPrK98vMADWypeDVLU+23j9bY22yZPOVXXSCNCT1aJKJxNfrtiWYNO?=
 =?us-ascii?Q?3qEWXmdRzHQeo6y7miI6UBLa1dK0BhuL4Vi8+qOPRNJSnhQaP1ihdjGfGcz3?=
 =?us-ascii?Q?+jhIse76Zdfi0g7ubqF3h8YHwdWU/2z0qB4G/P2VskYASLS//oRywdqbYboO?=
 =?us-ascii?Q?SPYG4xW6Gm6xwLhD7Xj7EFMZvDkNqubI7mWSxpAliUi9HICgPfu/e9BDhPD+?=
 =?us-ascii?Q?7tkWQ2PDFXP79WLWpcg2LJ0jdO9ZbnFsg2UP/ZnCEH9Q5uxQq9TmnMhVu5rN?=
 =?us-ascii?Q?4Q0XuQLzxH7hDU5OXZv450xTNOirzU68rKPksvs6fxqdnQ3nEuFqApmNG+ZR?=
 =?us-ascii?Q?olDpF7KR1JkyBtTq6/GSERQ36IePbUFS8Ik3L6R4kMw/ey9APRe09dumsY7M?=
 =?us-ascii?Q?ovCkziBSl41RO+DInLJe02z8Tev42cEzT1M0g6GQyPbrTEoBf3Q/xcWY1scG?=
 =?us-ascii?Q?EhDBYbpvXgFePlpHcQ+h/fZhN7Vz80NP3e3gsLVvKP3/ZLFOXcnZgG5+WaUG?=
 =?us-ascii?Q?Xc7a0rSgl04vNtTUMkatM1aLZBjphpfT3nqinsB/QoApA/YjpcjFvAJR5SKK?=
 =?us-ascii?Q?gKxUqQOjCUCcv9OQNS/zaYBoLbd1sEvNXl/r4imPNh2qj8ozflkIzWDnX8R6?=
 =?us-ascii?Q?othHn+gfXzxq6XeMFTs8DCeijuOufvKVq0pbwXHTFAgudnTJllKiVu2xS8hb?=
 =?us-ascii?Q?NcW8M+Kv9Ylr1DEtB/OCtBOp0Y8QAJNNyHUMFBuVhirVLnb+Vvvesnr+c4BE?=
 =?us-ascii?Q?zTmdsu/J/GcEQ6PfhJNZgA6KXZZEDawTNyDxWEQKJer6il1EmwaxSQ+he82s?=
 =?us-ascii?Q?Rt7A6V4ougYuKLURbbb+HXD5Thnfc2zSeUwrLQijHREQ091ECY09E7rcW9FW?=
 =?us-ascii?Q?yT3584eAg3RtV73IAd989vzODbO4y+aP//RNMHEmSxVqMTTn52i2ncrXubsy?=
 =?us-ascii?Q?QkBFEJd/ZvxiJhxBuSBhORAIlzncAqFpN47ANP0RFgaLzfsu26og1z1WN9Bh?=
 =?us-ascii?Q?jGIqKDpw/HplAeaz8DtED7AfB/GHc/7PbkLLkX4HRDIPZ1EnDqgJVGRnOf9+?=
 =?us-ascii?Q?wlZUnIozaamOhouMdORiTwR5yGotVgJULBddRudrAEFeZI5YefGtiR/d7l3T?=
 =?us-ascii?Q?irCFQtZIIan962yO9H8YNeqDKAFM/qfV0Cebcf4B6RFRr6CcknKjXBZ00OQa?=
 =?us-ascii?Q?bbw/3d+NXw8sLyPdpYjVBdk4gLpO5fA2447Yav86pv9OLD8eafhzhxZAAJK7?=
 =?us-ascii?Q?shGJ3+Ykbi7GFDmihQmXcwTcKnR8TQon29snm9OD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d54abd97-fd5e-4ffa-54ef-08ddf6e6a607
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 19:07:44.6295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xeZzO9h7hkKwQV0N7Y6A7eoaAuktJaL1FM4a9bISIrLGQfs+eYp+y3O1euFFnz1q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4209
X-Rspamd-Queue-Id: 4D501180003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: pxxniwa36hks5mchu3uicf9t1ufquagz
X-HE-Tag: 1758222468-573040
X-HE-Meta: U2FsdGVkX1+9tcZ5BSCkNcsxi5+45UFNm39wxt/rVOi5F7FVaez3vpZ/5oo0ioZls2qepwuiVABkhQFD/WRIJg+CurUbItT6NeRuU7wEeQAagw7DyIFKLmHul6/Fg25Kl3LgGl7+Q7GiD6MjAAXtHh09rzAbQNxTjDc40wyYcd1iJnFXfARlWTVy0YjMHV1F21YH1Pmjy0X3ZUuE3tzpneweG1nSEt+sxoAF0v+895CvLeWixkVvcj8IqB6hdAdmNZc921GfynDaaqRR7oWJxrnAobbBRUcEESmI7PPnqYtm1lqm6J+2R67VolC+K9ARfgcyDQ5EK9WouNytSQTsVEd6Wg+8qFFSb+95X6i7th4Uka3cTfhblL5yRun/csaOZ0OfsAvM7oJ9EGsApp/gL55SoLTzR2BPwJK8TfKwLa8s/EbgU29qcPVctUDRuUfovZJMNHTdEJmEfkAvgKkPXeXEe4ir2Og0wqZWC4s23IUjNcspApBMu94Ax0FWANMfZp9B3/pVRSjUzP9tAX82OpAil0D3Fgl8iZnhMKjc/cGkKVvetkDHsbxZ0CMqRE/faTp1LGBm8nz0ql93bUthcNYeXShCdZJjBKv0DjIJ8fGRAwM739e8+PiHHNOaHrcRjQiaynzxO2QOyQoNrR07Tom3yOk9Rsl9+kjFY2+A23Gd1gD+CeLBB3DPDVMbT1jTxQkC8Jze6jBtX8d1AF3UCtUvRVN+ccLbslRdd1GmR980d97LYwcF/iICNm8zvKAYvieEr+PapldjzHTXuYTh8z/h0ibUzbnRzjMXJVMClEBWFTkdD+PAo3b9XUD2lcaz8ZqZbvIxyq+1627FDIq5QKCMKJ/76eGbfx6m31x77XRLhTfIz/srJYhKUEiig+9g7Jn3m+Pfu/yS3O6jUC+L1U2dUeWfepH0ZdhYvGGJacVjr8mSgM8CXDB/7KFU4Wt28z5Uq+TyzSQL1vn7ug/
 YtpcIeXD
 nNq4AKUkB5RpIHKrVTlpFHB0PhrDkhUJKAopvVadHjJvDVzW1bmRtaVKtyNFfzL9XwvNvF563J+gG4GNY8GBX/60PSRquOkA27hbOLbpWHATwF5PdxM8f8wadNAfMvGY0O4bySfthZ8jlznzfj2ZztR8nZgD9WgVvkeH3BaR8G0x81cAufryQr1w3LItElF42H7TFnWIchtE8Xr0+fr9hteBVBAlV472By7WODqWlpwPfODYj+h2CeIzAr1zsLW79MaiQrLVuqzzpvluvaR4cKD3L3Yv5ChhB9PP0t2hm51vLdyFA8sukK1hdwyrZcVdoBFOpwl3uOlLpSms8vSgNt0J4X/9Taip9ZNdXYp1qkLciQ0Qd01EdIJN+iDOp/2bOjHL9llxszHxUG3bHUCEIbbM7rVRhriEKlXrxKQrKgxTwRMyk29imBjFFTaxcYN54wiZsdso8+Ffp7Xq5WobANkgYwId5bdDOv30qxz5K8DkTsm6SxJoHtIHKJjDBq1kiDJ4htbT2y4I/pxEG5DT16dnz3bWKz35diWmf4gcjf6iPEYt5QOUcz+/1FA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Sep 2025, at 1:04, Lance Yang wrote:

> From: Lance Yang <lance.yang@linux.dev>
>
> The hugepage collapsing code needs is_guard_pte_marker() to correctly
> handle PTE guard markers. Move the helper to a shared header and expose
> it.
>
> While at it, simplify the implementation. The current code is redundant
> as it effectively expands to:
>
>   is_swap_pte(pte) &&
>   is_pte_marker_entry(...) && // from is_pte_marker()
>   is_pte_marker_entry(...)    // from is_guard_swp_entry()
>
> While a modern compiler could likely optimize this away, let's have clean
> code and not rely on it.
>
> Cc: Kairui Song <kasong@tencent.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  include/linux/swapops.h | 6 ++++++
>  mm/madvise.c            | 6 ------
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

