Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE429E8B393
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 03:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972F26B0005; Tue,  3 Feb 2026 22:12:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9204C6B0088; Tue,  3 Feb 2026 22:12:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5386B0089; Tue,  3 Feb 2026 22:12:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A12E6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 22:12:08 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F5BB8C23F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:12:08 +0000 (UTC)
X-FDA: 84405300336.27.C628D84
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010006.outbound.protection.outlook.com [52.101.85.6])
	by imf04.hostedemail.com (Postfix) with ESMTP id 335FD40002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:12:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UxkwH3w3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770174725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnvAcJh07ncs2l9x0XIgTo2h+fWrOnfeZciUWrbKG7g=;
	b=0/bSd/aAWNxFhQ+O2pxyi4cIOW0r3Z+wfu/sPiJSymrzfCPFLo5RbV9E4ozkH3goXAgbg2
	mCrZ1XJHOKY+sP0Pc27maI4jy1mHgGjApnEJM2A1AiT7RxxkjF5iDszHokKwn0nBX53f1/
	DnAXz5pdj0zkwhPa2hkxS62dkJGZLpU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770174725; a=rsa-sha256;
	cv=pass;
	b=uJhFD3bn0RRg4WjmGSFzkMkAzhDOxI72+WKSprIT2VCrBx2SeH2vJv+1fdNeetY8e2jeiK
	x7BcecLonDzpAI+USgLcBNWP/87Q9+Wtm0uFeAXLdM2o8qoGmVqA1FDswTRKmH6IYzkzIr
	uNNnkZBbmKNa1Gb4eoJhd0f9qzRGbPI=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UxkwH3w3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uswGc5RzFPSPEvJWBIkGNYAdTR+Ck50g11tUuH2Lxt5gNy61jkYSnBS0slSBAqCvpVocrhZFLDFev2pYFYQxvm6rCZAdwylFyf98dROEmxUZiY1rlzrQ/B90G0lW5F/IAoz2twVqoplQaSme3OrAv8TqzK1L/A7fVngW2pBhWPxIQDPGGBrqTlg5IfA8WJ0lxYWKJW23quqnFc82MKswp8xV2W8+AmPVk/Celb6ucBzWWPdD7FXCtylHRLKcDlTkW8UwOQlEvN0WmfzhsZNyK1cFIuVrrHAsDpr4h0pbXOijB7axSY2Ib/iYTHPd16DHEJsmTo3e9ABDXh4ZEUCdDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hnvAcJh07ncs2l9x0XIgTo2h+fWrOnfeZciUWrbKG7g=;
 b=EEUFndRyBsl/OqkkdyxJ75iDM2cUG0032ec5fl8u1uwD8mbTc/sfa9Sf0t63i6zfbvPGamiI58GSf5mS1jURltkhvMbf7+tf3iKSeSCtR5dz65rSNHc/Q6u7RgxX2P4XUZnifJxhLBjprSigEXseaV/DVMPDqLzkOzlq2pwQ/qTh74wO3kSVNBa33+zjN4/fRHEmKxndqTt9njpX+upZyDfv9P5dafzns2TyCoyRRpc7wDpJDAsU6eo/icCDnuPOOS5nwq4jDI3dWi+VB0N7oPHyv2YiCdKiJ37yRcCv/BFnsPO1vO3R7ryGkdribUbpW70h4vdsz9bvp7feldOJMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnvAcJh07ncs2l9x0XIgTo2h+fWrOnfeZciUWrbKG7g=;
 b=UxkwH3w35lo9Ni36GnCaN4lxOi2/lpDjfeLND3TWMsAZ1bQnVDLBm26AzWKjY39iZyC7GAxos4SFiAXBFHfW82tH3vfWilf36dkzmNtdH4bzEI3J7DR7wj+or4A2ebm1y8r2vXCKAq4ggq4GJlkxy9L+H0+N0ySxQcsmkEadtVYyx5tTKtnqGA7R3MrjDlxz/T6L8RzCmxw3oBy8AN7FJs4WWG7hfJakr7JEr9DaSP7BsnBPOE26V6cPeFDMDLOZV/SJdzbz4UH3hkbHz0m93tqqAHlVlVNqEqFfOmPSHlYvBmnHDdeSkUkHBMTKQdXJvaSoFLMUao6LsAxkOKnw8Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY8PR12MB7337.namprd12.prod.outlook.com (2603:10b6:930:53::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.12; Wed, 4 Feb 2026 03:11:59 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Wed, 4 Feb 2026
 03:11:59 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 riel@surriel.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 harry.yoo@oracle.com, jannh@google.com, gavinguo@igalia.com,
 baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
 Lance Yang <lance.yang@linux.dev>, stable@vger.kernel.org
Subject: Re: [Patch v2] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
Date: Tue, 03 Feb 2026 21:22:21 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <05C8C526-0434-4912-9AAE-98A70A1841F4@nvidia.com>
In-Reply-To: <20260204004219.6524-1-richard.weiyang@gmail.com>
References: <20260204004219.6524-1-richard.weiyang@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR08CA0027.namprd08.prod.outlook.com
 (2603:10b6:a03:100::40) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY8PR12MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: 21b5d0d6-a1ba-4f02-cc10-08de639b28e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8avDQFekE0UhFehTbTJQznTXWCsRrUW/jNNMEltxSjZtR9fSpVeZgHBVXefi?=
 =?us-ascii?Q?oyl8HeHy//6F92lPnvS5BUEKOIIJ8s+vQTxG9D2mhGuU4WxeAcgsatbwTEIj?=
 =?us-ascii?Q?pcqq706vuBWiqu+h/1kDi5bklC10qp+nwEL5Gx/Y5Im6/c7Xg1DAG15xILHX?=
 =?us-ascii?Q?g2m72w9wuawopEBmzXs4H3yQpo2eyVRfcWgO3inh75yp3vqtyJY3sX32vwKr?=
 =?us-ascii?Q?Vy1iUzsfKmOTz9tTEaN3VQpIUvXnZS1YHrD8RlTPpmjKIdqc/u3ThUapN4t8?=
 =?us-ascii?Q?8RVy7NvtVudW9y3xUJ0GlzQpmiK0Q5dHlDe7ZINUCdlu0AbkqYHbfd5GDAkK?=
 =?us-ascii?Q?OGwwxgWD7Hk4PS6RpYIelsgqUiG59q+C7rIqX0TShoH7YzZzJ2ka3PV/KlV3?=
 =?us-ascii?Q?sjsT6o6nOwT+bAnlkDVW4TfoIZU+bQ8OuSRnnugUyb0HAFaLP9RfXjhj9gWv?=
 =?us-ascii?Q?ISejnL+qB1qKdgJTzabR4tupqw57qdzMWJaUmL5nUEtRjwpyTww3klOlLfMT?=
 =?us-ascii?Q?i969OMjT7f+8Nuid9alum8D/zIuB5F6E++vxJxgqMDiLOf2GDLRY1yjby3R4?=
 =?us-ascii?Q?cLFkRnDpBmkl+iWF5vpg8qjLexQ+gooBJWxt7jmGHvoBLykKvJPD0glIgNWW?=
 =?us-ascii?Q?a6B+tT3vWo4W3CClgKAAp8U52wPR7v7qKZ1cLL3KgTOzXmtc9YGk5hk95d1L?=
 =?us-ascii?Q?2i9P2sNTmmRM3tDHvVEfiv+aknjGRbqAY3cP2pc8GYIz6JT1jjtux7ujiP0f?=
 =?us-ascii?Q?OsnWhdpFr8xCWpveQJvfYok39mXzRFxbLAOKvdqgmFdNBwEg62dlgFq13A7K?=
 =?us-ascii?Q?owTIlAwq+oPvWaAPV+CxOWg9XomBB2GnbhAHU4VhdY6PHOhLRR8bl3ytOojU?=
 =?us-ascii?Q?AawN3CTYMBchjn10Sxxl1U1ASocKHlc5KHujVfplIrRPEVoST1CtQ7IxVTgK?=
 =?us-ascii?Q?aUmTCduwJIh1BU3Y7LFLPiSwlftnMSUUpbidE3VzbRrmfTSQmHo1PFnED5FV?=
 =?us-ascii?Q?iSB+vxOxSoNVaTMfQScYs7vnZu97sGysrje6PI4IasV7NeUsJwi+5FD99wXe?=
 =?us-ascii?Q?tXQhYvL/btFmIiwspTigUQWuXwgI6sYBXOYim8ucXdGENBf9ul1KhalIj36d?=
 =?us-ascii?Q?r7fka0s4u3NG6cVYyIwIUo5aCCqAkk5/ydobPMYrIZrZTTfI0ouqnYfLgqQx?=
 =?us-ascii?Q?eOLB1WwwTHz+c1361N6dZ2Onsn9s6VoZsE4sLM1ughZL7Jl55hk8Eadd7LSf?=
 =?us-ascii?Q?qwL+5Zh11Gbigz8Qj0zJYRwFx2uD3WeNskGH0c7OmgxXnS4sdmEuV8lPzOfp?=
 =?us-ascii?Q?3tCfcmEyNx15Dn18nNUnD99eV75zVNFThaShmVEeNYV75ymU7XJAXnz6vHOh?=
 =?us-ascii?Q?UNmUvPIcjOTOlIZ7ZICmyp9IZ0GYsSPNRBfx6fEABw6tsSsV7FAGDOVHWpZl?=
 =?us-ascii?Q?R3pxBh4gCGIgX+kNRMJetKoSSFgfo9YGdZUrdm2tNERPp+DmUeloI83T1d/F?=
 =?us-ascii?Q?Dt9vK4KGrbjIlYUDdU0JyXnFKvZnCx9u5D8JFlToRoEfLrty9o94dExwdQIy?=
 =?us-ascii?Q?j4gxqRIIhs1/5H3ky44=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ewrj/B25lwCaRjUQFXxHk6WMkxDOW+XGetL1yuO9lr+k2A5Y+FbFzXrKwp6C?=
 =?us-ascii?Q?W3YjMpZVrNB9gFs+OCWC7NbxMwG4+jDgxlm2YQpONjhOpclqwvpbMy6dT+B+?=
 =?us-ascii?Q?/KV6hYbgNEFO7Rf4XCnR8sLiIGAfjB4BCh6Ml6bX7Pp+/HxEXkAH5GuhGJqz?=
 =?us-ascii?Q?Lm/D5M+QEVeGBPnlJWVvRXXwYKqk6S/A9iEuaYMPf3Iad+pv3eQ+Ib891PC8?=
 =?us-ascii?Q?ygoRD6DRg8/wyKIWCCwpsawQDuAx62Z+1apzGGBGgOeVpY/BmFS6f4dOi7lV?=
 =?us-ascii?Q?QVdW+FjqfaH4wpdxXIjV+a5eW+hjSF8OASHFw+sxt8yCadMKKlGS6vTbhJZC?=
 =?us-ascii?Q?k6P4XBjYK7/8yCZnkgE9IJmBUi976yI8uM/8ukPSBjNXo4lwTowzEyt4ZwBG?=
 =?us-ascii?Q?f5y1pRtC9/wSzp0wzx6fgaGh57Zlog/6VNULvxkmuElaQa5HfaeSaodGEfSv?=
 =?us-ascii?Q?6vpuGarD2rkCy7kTRb5dnUmWfuh67t2+uSSP4i406TsjC9zu9hNT3mxEW0Lz?=
 =?us-ascii?Q?OG2wIqrVrEFcL4ixkE+0j9FoULOz9pPHH/xeAQwoB5CdoF2PsAhqUZ8+Pdnk?=
 =?us-ascii?Q?qc8252uwF2ktoRPJD80gDrXyNs26knINyIbQscyhQAhqJ4ik6uJrHqLGUo5J?=
 =?us-ascii?Q?fLIh3aK0OTtZQPbKX+DVEjb1dgh8RC2k6yxsMt8fPDD0hsB4gi9WqQEWK3E3?=
 =?us-ascii?Q?oHOHciQb6wrLNHytTVlnDzd06obLS78pyGxprt/SljfsvT0Xs59OoPKNTwcA?=
 =?us-ascii?Q?HXQG5u0MXOzJTpoPnQ3/isuOsfvwsPMjS1XLut4M//GUQTIY5ROsdsS9J4XK?=
 =?us-ascii?Q?SbXiHM5mmKjMyR1tyA2GsjRIxVNwVkeTmS2hTR+KOe/uKvHByjCOtX1JKc46?=
 =?us-ascii?Q?KrUWGufLwzJbf80kyirW+8rG3Kz2jjJm7A4bIHCnTF12txBWnhD5FbMFge+0?=
 =?us-ascii?Q?x03wQgbKMBpak9Ld2F9mdpyhXcWCPf8nN7V8ikzwgoSi7Z/0ljELQpHuzORF?=
 =?us-ascii?Q?biVZ4Nr6HDSncRmNx7SWt6d/1cikD0uKXsaNajUIi+jthG+LxXyYsdO3vwjk?=
 =?us-ascii?Q?cuU+5pajeQ14K+zm3eWqKC8WoTlG4Fu9jRMw5PDJrF4q3NOEzrTIrfoY/ipK?=
 =?us-ascii?Q?hv9YtYTHSTinbG9c6onaRF2swkC/YRY1k0s1KKzFrtV2Ky3LjwkIbMJEWGdj?=
 =?us-ascii?Q?fbIooeTtdk8ulNrmxi4Zz0UluJODHnFjWJRLZ6H/j3ZfQ4LqpHlw20ipV945?=
 =?us-ascii?Q?RTm4nnFuKApR+5MkapzMRTM6yOk9rS6g9duBCzdMdaaXroxS848tElcLu4uB?=
 =?us-ascii?Q?VnbFsG04bTdKDMY02G32/k6wELncIZN87u7COKV6JG/tAjd3Ipy02FwrFy5S?=
 =?us-ascii?Q?V4eKVLOjPKz+cGdjxPs3Hne2SouTciKMho3rl7j2ErfaFf5cvTVm0Uk/8UR4?=
 =?us-ascii?Q?l9uHU8r1SqrOynzIXH/m6orcsnlBoAoJdyRFLHJDvuhSHCR0Eb1v9nT+yZE4?=
 =?us-ascii?Q?ADa3b6mVajjBwlFwJiuuMteVXjxE50vBaDQT43Wb1dTctWcbvPO4NbEzkPHC?=
 =?us-ascii?Q?vOUol79iCHuuCk6EstN9aOOWSdQrhrNbWx4+SBo+JJpOxUh2SKX/0ZSWXCry?=
 =?us-ascii?Q?Ks/+nI5cv9P47uYt4cq63xNcwqw+wPb/kVqgqI/uMuN5aF5n5DEvJtYXKWTf?=
 =?us-ascii?Q?0OKB7BrhcjaLTqT0xp0Dam6VAeHrgCkEeX+JiMCMIkcvG1Bq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b5d0d6-a1ba-4f02-cc10-08de639b28e2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 03:11:59.1654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66c9iv4yf6ciaM5iKl62XfooGi9HQsT8e9e7X+/sF50J8DB/YVrr2fjLhhGwzV3k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7337
X-Rspamd-Queue-Id: 335FD40002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: u5oe4uqf99gou5ds9w1nh9htjt9tfdaw
X-HE-Tag: 1770174725-416173
X-HE-Meta: U2FsdGVkX1+jIlnj+8nH/AbTAYOTStXu1vj5R/0H2nTtB0Xe6eRjDnBf23kbIClBO7GfgVq8bZ+hEp+a+4N71NILpMJqqSuEFimRshy31eismJol99DPz/IgAEg6a7xqMj6N1qB3a25OK9Ls+R8Ln7JVhXqClq8BghtGdQiUk4FUbOF/G2ekxJrrqLnYwKmYv1hQuc8PwQPKd6kcnwxb5vYKx8kzgkfhsv51BuRcmuUxZfESRdnZbp5Z6X8/EHaO8EpYK58D/bO0+kVE5fajf2Sz3yumBlZOr3SGmuY7RADAB6nARSL8dqzl+6s+/dkhtr8hlPbGCRoq0norOaLxWkj5NvZZXYldIK1SJyC4+3Np3nlx0/UKabYzZT6Md0YGz2Vmgz3h5E0ghRwQC6EYhSEpWHXwT5dl3L6Ww8jPeEyyfXX4HY5fcONyLl86u3hVrEIgK0evxKZDhXXqiuddbHWWXDYQq+6iKlEpWfD911cg7r2/n5oBzfSGSxH5x+cZMTIO4O3meous7rBgG53Ma8DxSSCRrzUWjlqHxbbSg44QuDtZU5FZsWXj7tdyu+49ZK4puqFEg1QNiEgJJuXnR6kvWMHSdBpvvTffL+OhQQB4+krXbYMRaR2HknQoR7XSaY79sVRdwM2hmnl72NfxUa0fWHknsSHrmwXJ+Bjbggd2NkgSZa6brFqcF/OihoLvihYbNTwgxVspn2LdI89gdfTSnYEcKnx13QCjD3jsPygJlG/z33kOSkeqj0hyUqJR63/Z6I2LiKHgDDT+pCBOW5BUtidtJAy24fPtDNshF02rXksY82KFc+Ee5xWzcsSdUCFiLJtM0OxuebchVDwODrmwSdlIPM/JHPivPp3fYo+3u8c7GK+yjunm8c2u6bNMTcg9qMnyfTMDH/hcvxoEPvASe3C0Tfq+QLFnKq5Sn7qPiIdb39MoQXqGTt/uZmYrAHC4dZFV6YTVNefMjXJ
 dpXu96zM
 dd8cwKkkn7mZjFNJNQDbz2VdXavyoh+Y3kjIIa6yxtTQJDPL7JFk/+6Dduw/BXribRW2Me9xIX2ZYEgkMWto0v7+FntC8QrnwiEp42BzzdhwCz9Brh1feNrYwVty24OHTzx5QJ1q7pT7IokgENpZKE0f8fffe8EOnj2xDwGBnp/GPzBIOTPXHD40KCLxc02k8E/1eet7fbMvwQl8LyQJI4LvcHFWsm2OK9I4Dh1LoEpxOtuPp3mPdn/2579gnNX1jf8f2iY1YutM3pVZUyJEJ0g5krPwvtsXdNkocTTjT4sGEob0MpNNuVKYp9TKvVdE+hHDpASYsvMR1/x6yxE1UEFaxv6nkYDIW1/CtoDwh5NDiZ5pkRsCgfdU3n6GhqHMkfASb13fUq4KyyoS0FTE0zrmBGuHCphby0CcRsRHGEsXRJ4aO0WAzCsJIaY0EuH83SmB6a/mgW4wnQ52xMehMas9sDICvUuFK6YiVWLt6fd9mnZGxyM6Z13Cef11xrXqoMNEU+WeJPY4R+xu+nxjFN26ZI/PqpVTcXzKIjJj32PA9xtGzuNQ9n5tzL1wls7DTadJ1CSa3g/isMc0OWB3a0fhAtCWRn3s8FgRRfKCzTE1W7ZL0YT3eorAWGaZFgN2JEk21
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Feb 2026, at 19:42, Wei Yang wrote:

> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
> split_huge_pmd_locked()") return false unconditionally after
> split_huge_pmd_locked() which may fail early during try_to_migrate() fo=
r
> shared thp. This will lead to unexpected folio split failure.
>
> One way to reproduce:
>
>     Create an anonymous thp range and fork 512 children, so we have a
>     thp shared mapped in 513 processes. Then trigger folio split with
>     /sys/kernel/debug/split_huge_pages debugfs to split the thp folio t=
o
>     order 0.
>
> Without the above commit, we can successfully split to order 0.
> With the above commit, the folio is still a large folio.
>
> The reason is the above commit return false after split pmd
> unconditionally in the first process and break try_to_migrate().
>
> The tricky thing in above reproduce method is current debugfs interface=

> leverage function split_huge_pages_pid(), which will iterate the whole
> pmd range and do folio split on each base page address. This means it
> will try 512 times, and each time split one pmd from pmd mapped to pte
> mapped thp. If there are less than 512 shared mapped process,
> the folio is still split successfully at last. But in real world, we
> usually try it for once.
>
> This patch fixes this by restart page_vma_mapped_walk() after
> split_huge_pmd_locked(). Because split_huge_pmd_locked() may fall back =
to
> (freeze =3D false) if folio_try_share_anon_rmap_pmd() fails and the PMD=
 is
> just split instead of split to migration entry. Restart
> page_vma_mapped_walk() and let try_to_migrate_one() try on each PTE
> again and fail try_to_migrate() early if it fails.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and s=
plit_huge_pmd_locked()")
> Cc: Gavin Guo <gavinguo@igalia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: <stable@vger.kernel.org>
>
> ---
> v2:
>   * restart page_vma_mapped_walk() after split_huge_pmd_locked()
> ---
>  mm/rmap.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

