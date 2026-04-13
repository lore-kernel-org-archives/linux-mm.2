Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93385F531C3
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4B16B00B1; Mon, 13 Apr 2026 15:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C486B00B2; Mon, 13 Apr 2026 15:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC876B00B3; Mon, 13 Apr 2026 15:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D65076B00B1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:21:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D89F1602F1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:21:03 +0000 (UTC)
X-FDA: 84654500406.16.9B8E544
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010068.outbound.protection.outlook.com [52.101.85.68])
	by imf30.hostedemail.com (Postfix) with ESMTP id A808B80004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:21:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e68eF1VP;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e68eF1VP;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776108060; a=rsa-sha256;
	cv=pass;
	b=RLzZo3tbXL7MNLWl3jIVz/V5XGYMedVD8IQFyhQyJBxYWUrdM1Fm8pPOxYNGRr0yzKgr6r
	23i95e0AZG+yLHQjAfC7ymEi6iF0HVQpIvaM0Yxov+LnjAZXSGecITQlwkJJr5jprQ08fb
	3Msr8E4WOzbVRrAwTrDngCuYahYIFd0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776108060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+5z+liynp469aw3FnXdrr/mMQViI+U3MfIRO5hKMWo=;
	b=31dfVvR92rpbRzumi/5l1ROf5voKnLbSmiNS0iX1zhEcLk/z0ers3VshhtOqaIjJdm4BzH
	3K0cHeb3V8ntwzByH6Qj3tezQmADuYLkLJOjZhLkZKkHEB6LbP5BNaw/Mzc+aByDe7yDnF
	o6ewK5yqjJP7OKLvPpESaYiZ02y4Nak=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UXXtlMSDrIOWIMqj3B2N1rcUPFGfoa/wbUPAhFg/ADCSXZ+3KymAdQvbur2rDFk7GuVf4ICp+y0jbLlMnz81DAcFtb+eHgWZZk5L/P8sFYyo/7La0oXp+SX8hVPXUFVBvW6+LptJR3HhTJgubbFE/fFH4QHYjzgTpun+QJs8C71PFJG8OQan0WZZ8OnRoH5YmEJn7AJcfYwRXzS8umTomWxAM3xozNAjm5uBIaVyydM/6nciZxmHMgIRglba1KYe0HT/PYIpn3klv0sSVS3b3hWmClgbSQbc/d3W8RX9AjVA7RtCHlrh/R+lVw0doqylYphFxqi7mkuY+o/HT7IlYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+5z+liynp469aw3FnXdrr/mMQViI+U3MfIRO5hKMWo=;
 b=cZEXP400N9/EjlgSMh4tR5yCBXf0hiNsM08Rn+xE5g6whjCNpQOhJAD7otUzicT0ofYVQBEakJO7bFOu4yH95mYV1HcEwouIwtLV+QIlWgJBe/UGsNtDZILiF0Hkd9Wiu35NUp9EdoW20wD8L3tCucNh0VXoh7JO7issexdEdAEepT0IS9h101+CKXV1w9nJA4fxGJaxWRT6QSY8UlREJSqf5jFr+MAi7VeD0/oItf/VJB1TeVxO3agkwRLc/tnbdY9cvUBgQVdtHTLBsG+MK7Y13daJqGlvDUlWde7b9YgcCNHZTgRsLlwvNyKFrJxhTZveSdFT+D1Cfqi3R9TRoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+5z+liynp469aw3FnXdrr/mMQViI+U3MfIRO5hKMWo=;
 b=e68eF1VPQQggWJn6X2TL+sYM1Auk7BQtX0Oshl0SQVjcV86mjESjrx9A3QW14k3cof2EnoIrajrto4tIJ2uDycvCXCn9YeTZGS/XAsaukln95o762cKfBmhOGSypqnN8/amx+AiCr6b2qcEtBLR0mGdUtL1W8pJF+pM1Q5XsQAY6JwYiruzO7/E6VnyN3fjp+AsDXu43xF9xa5Y3diXhO/35qp5Aa29T8T7izf34QrOGiQs+fU3kEySXwYztLPYDJGpp/kiYIY34zPjeildxWvAXqpKuxX53+4Z+vOvU3OrBjFdO0YYHGMaQ7kp3zo3ZHguF3XQLGhb4J5zHGpU9Gg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7986.namprd12.prod.outlook.com (2603:10b6:510:27d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 19:20:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v2 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Mon, 13 Apr 2026 15:20:19 -0400
Message-ID: <20260413192030.3275825-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:208:23d::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7986:EE_
X-MS-Office365-Filtering-Correlation-Id: fd6e2755-5b6f-436a-8d0b-08de9991c04b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	/D682BQFPE2fJKybPmFMU0tr+Ouc+PrXtT8oWGHRH3hVlJSWJ35RL6jGXBy+2Z30aCuTZiVPs8d/kMg69eI4H+owNqgrlSG2kDgeGi41+LxgpuGi/xgZqnGuJEnat7QY99r5foBCe0o6aXjDf5W+q0YGD3eCMoN9ifEkjgtBdgRukY1QxYOBb5VVHgNbtSJc/hJEj34eLt0g755OvA0U9+bU+sCbZmGGchNDgRey0mu7SxkvERJg9X6Xz78Rm9oEe5wdJA21blH7EJBL2c7z9aUvSm9jJTcKYDjqEWHe0erFeCBvaIjepxktaecicbcVxmrx1Dn4QMYqQz8Sw/X2Xgz03dH/CvbmIoaHX2v7gSwzIo6/ds4z+dRuhAvWVl5q2bRfiw7aTuEn+e2KIV2C7Vvd4bxd1b9HZ4E43VJx1OM1pkrCJfhAVGcMwr5Hd7o99+5OZrxnwV1KJbz3ziDYpv4P6lOqhshCm3KIANBwcN3pmQCRtCMq2kT9Zsp3pDAzpAI1kEeBvr+1QAsg61B3NtQaO1MorkA8qIS2pxq9pNt5m3SjfxagGmFctlw+oFE3AYz9mT9c0gkHc5sbRzOilbynnR1sE9uTO/4dUxZ0R0RkNOU8cmTZEYGHEpljRKHCnA9/RMs32YAgJPQICkv3x6gsMGFrrFkj+wIxIv/+oHDwb1hObDL9UXEWij7BWkT6pKzaOAElVD3xUx5MkY3BmZ4DqJQFwNoI+pfGu6aeueg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZtFacIShghHgjEzajCY5sKldXpfpJExC1oqk70V3EH1y1MRjSJ+OvPnKssLM?=
 =?us-ascii?Q?7DTqmgeuDrwHf1t75Fp8aoUNsU/xGspEfNdRIjcmM/Ch3hRLBzMGpLls6Ems?=
 =?us-ascii?Q?ftX0hNTectOU0HOgS3xnqzYAf6JOQ+RPdkKK2Tw+f1d7Pkz+nYaVnZYRmJAv?=
 =?us-ascii?Q?ihIEVoLEWOp0K3UrYnRfae74hu6Evs7z5TTdUE7j+sXD6UwJqx7BBf0wBIXD?=
 =?us-ascii?Q?1N241i5qrR0hGE2x/TYmNfv2IGnkBTNl3j3F1tp34PD3WYFvai9THMzZC37L?=
 =?us-ascii?Q?uh5IVhydiM3Coswbzh+6tFCsrXcHwk6L6zPSbNYqqF+LF8P6M9NWsaz5Xr6q?=
 =?us-ascii?Q?7VwdZHPMzEesuzYhX1wSmdlxyCCGdTh46bFbwezVG+VmMZBJvxXraqp1ZyhX?=
 =?us-ascii?Q?cpEIIFym59yp6nXD+CRlV6wuAUJreq2OyZIkD37/7NnSJFeX0zLR4ZwAL8c4?=
 =?us-ascii?Q?CjQtWgkEDwxcnD9CTZ//rjRWfOCs31fI97zN97KrtQLb4yKxLpwLOSBO1Sfg?=
 =?us-ascii?Q?EJiQe5s52/m5CiEwz0v5NXV7R9ujworRXeuGhiVcWTqg24OEf6RDc54mHRTc?=
 =?us-ascii?Q?blXUHRvT89Pk/eYNdeqv1FUd3NJGg2oyHzGN2AJYjnUzqCpGDfZEXGeMimwQ?=
 =?us-ascii?Q?bczB1yM5NTberJBm+trocaoE8Z8zPaCMSyPJ5I1Pb29DNA0fbhrj1UDI/wd1?=
 =?us-ascii?Q?FvzULixvqfgyQtq2Agk0CHs6dH8ip/3I4apH4VbO6pploQJRZgVJ3cUnZ+aW?=
 =?us-ascii?Q?7HhDbK8dDcLxSLIJFBATLhZUzq/q97dmbtF40MnmjbHKhTAXP+U758ZEF9LD?=
 =?us-ascii?Q?vtFIcLJ0vCTtGZMrMVevZelHzX9yry39qAOYKyPk2cGkaMDwSvuP8L1QcZuz?=
 =?us-ascii?Q?fcHv47wxgDSMwn9z6pBOKfvTFjvh1SoS09VsgvpOmdhA4VlyVhr2waBW1jkl?=
 =?us-ascii?Q?5wtTcNUjdBmMJ7lc74BsPOeMwvAvTk3ugrJ9PoE+mwc+MQj7H1dfMpEF53qO?=
 =?us-ascii?Q?6xHhDlz+DUX6NShc/RK7sRIHS9bP38ZtYK8wNuQW2E/2j+LJyJ6ne4k3AOIn?=
 =?us-ascii?Q?6fHedKl/fP6KgLQWmFUPwbxSweMDaxi/EiBoHIW1qCAL0EN1gd4XFIhpTuxe?=
 =?us-ascii?Q?SF66Moa+vigHS+GaqW1mMo4bfdbA3llRXtSTGr3FYVDdo9vi8zFA/6wD5+wE?=
 =?us-ascii?Q?JriwN8jYqjP0zNCPbsAI3FJKhPMwiFRXhQo3XVQ5OOMhdPdmLNBO80yCEkEY?=
 =?us-ascii?Q?a6HrV8WFTG8GHI+59QG7JLaTwlvlom2gzCVvtbS4Rw3+5hZMvmX817pgk547?=
 =?us-ascii?Q?wPIa1zTf2E19nE6F9pgifgE89EFD+NhHTDK3tOYbIX2xhMxC6qKcZWe3wxvn?=
 =?us-ascii?Q?CgxnfhCeZUDX7IXA+FjL7hs3o4oWC97vdjm68GfGwd9V2c5NkBT5aiolihsd?=
 =?us-ascii?Q?5FPELVs1gX29DmZzqI8Tcm4mbhz+O8F3J3AkLFNAF0CPFSWnO/5c7NANuXg5?=
 =?us-ascii?Q?YyX8AsZMbIkBcuIvgK7CLJ+ysvSxSqrlHQGM6o+LPjlqlfViOggbIvHR+glo?=
 =?us-ascii?Q?z/9q+wAfMvtuuHPiApjWnZcXETUWUC0nsI7V7p8oKuCZkSMcUUW3/VodePQW?=
 =?us-ascii?Q?P/4L1lE1ArXlzYX7qJFLG8B8iAUE9XrOLrp51iYK3p9yfsUhD02g9RNpsqVw?=
 =?us-ascii?Q?pm6d2wcK7iJajjZ7nCfFD7YcG3/Uyj5WIjREMe8WZ8PDQpL5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd6e2755-5b6f-436a-8d0b-08de9991c04b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:40.9736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Osjic9wG0tzCl0RhRM9SUd8cE00d0dnUzSsqNR4WfZfASGHGFK94X8KxQDBYw/wS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7986
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A808B80004
X-Stat-Signature: 3jsiebo1j1jhiay6jr6c5wiqhz1b3ezs
X-Rspam-User: 
X-HE-Tag: 1776108060-299254
X-HE-Meta: U2FsdGVkX1/NXm9cFD3J2XVQnWd28qEpgPZdEQ0klph/KVnFaI6kIIjkhlBZ/TXvfD6o/RfmH1ochfAUAvY9Oxaj5Dln9mmLuXQUuSe3LaiW+dAc428/39F6cj6Qh2eIbNncuPFUiSrJiBayc89wfNRqiUCCzuXrSIAbdsK7p7WQ8UczYH4WcyeSUkmii6D3MBaGTY+PXmWVirfdRSpbWtL5D7nrBqFR4hMT4FnSfXqoBZUFFSd0uLWuzBakP+qfFb6q2M8R2/zkfYxqa3p8cACaxw0ZwAZYIoqkU4NXGnnwtoXgHDJ20TX65c0As28Hrivf8yacMBltBDOiIAc8sVm38wA6sSsRpLZP5NuU7c48QIuqHq28vU1vEP3AUfSrobU9SYAnB3SXkZiRRec4gfIb/fpO6uMLK5FUL/pbyyBzq7NyJike+DbQ2yAOQWD8HBRiFn/GAhFKoY8zm8GjFHZKIXXxxDpo4KwGwF6tR7ZJJkn+8AEO+/6pBGXKqLUHS9Jq6UU4c3rwy4F5j6FcqoBdZsLmOigFuRHPswC4lgSubqKDnpPTiOVwdBtaNVDVNu0Pd0WTGFXsGvWr3Zu8iIHLO65V9j70+wO2juPq7uaWpM0xmfPem7P/uggsofHKOg5PuExxQYkLAmVpHWWAjLef/TnwwNSdXroWLzkS+rEYm104j6lTOLZXsckxn/2tgU+DETjZoBFUrOEgAG5X4cva6wIke+RJc03Ftn+/b9fgUkiZYr6lRGkTpWKBiD+9ffNXqa3BjMk4I/5oQnzSGFELswRzPugQ+oyBzjp9x9+p1QWPEmmITkkE5TZvgP4yXMNMmjHNClncj/n6tJ05PqRu6+6M7ImFbc63qGVoU5L8axtcYK1WptFl0v8yqcl27mdopb12a5gwZVFBh9oX07b92k+rc3thi4pterAwNX8GZSqTDnLZ3pQF9jBGsVnSOY7oYyxM5ReLDXRq2kp
 cRMhd1Az
 1CccQ1jnEXRJ6E05fd6d6tnlE+S4CwYFU4BSe5KPQFx+np+aMQSorNAPHa3iLbNhTWRu1c9O/DH8JrpJ09WcCdGdYhghqE4FDNnV3dqR1Xyywm7mhEjb92qDCFWakwIQ3VL8U7hMFc3WVnY3SqX8vC0bTgHdr8ISlayUD2kLVE4459/MVN0mJL4kX39ReAJU2wyKa5Lrt4NGWkTsq49n6FEvGo5YEedzh3EZhSGT9p7Rq9G6T0aUQYMjXoGYpIAC4upggIujeb0RvcROqsRYe//iJqSHYIP/2xlXhALPiFFlK8TV85X1DOww03pFGLWz4vrvOhi0OfBtWEFElF8pXGnxckwywgmm+oPumQoGEWK+Z7gsLOkK/1egw7YOXJADTKEg2lVbjVbZjw99Jx+Y4u7zRayikFnVF7R/poeev1/32IMqur4ubl887N90kAssECuG6cQtDaWJMDi7S3hmjaSld1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_file() requires FSes supporting large folio with at least
PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.

While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.

In collapse_scan_file(), add FS eligibility check to avoid redundant scans.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/khugepaged.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..d2f0acd2dac2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1892,8 +1892,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
 
-	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
+	/* MADV_COLLAPSE ignores shmem huge config, so do not check shmem */
+	VM_WARN_ON_ONCE(!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER);
+	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
 
 	result = alloc_charge_folio(&new_folio, mm, cc);
 	if (result != SCAN_SUCCEED)
@@ -2321,6 +2322,13 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	int node = NUMA_NO_NODE;
 	enum scan_result result = SCAN_SUCCEED;
 
+	/*
+	 * skip files without PMD-order folio support
+	 * do not check shmem, since MADV_COLLAPSE ignores shmem huge config
+	 */
+	if (!shmem_file(file) && mapping_max_folio_order(mapping) < PMD_ORDER)
+		return SCAN_FAIL;
+
 	present = 0;
 	swap = 0;
 	memset(cc->node_load, 0, sizeof(cc->node_load));
-- 
2.43.0


