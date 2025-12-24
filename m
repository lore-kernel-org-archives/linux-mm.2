Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E1CE74905
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 02:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E34DF6B0005; Tue, 23 Dec 2025 21:26:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE26C6B0088; Tue, 23 Dec 2025 21:26:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A5F6B008A; Tue, 23 Dec 2025 21:26:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6AA26B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:26:20 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 639D860703
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:26:20 +0000 (UTC)
X-FDA: 84252775320.13.53C4D1C
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010009.outbound.protection.outlook.com [40.93.198.9])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9B4DE1C000C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:26:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nx4Ugnd2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.9 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766543177; a=rsa-sha256;
	cv=pass;
	b=mLKohIej19gH0WLikiiFS1/nXzV07ZA96ffta5Fr1DYdEf2McRenQso3l7MLLbfDaIheDG
	9Q4gBrWYqhFK/b9G7/PqmxyCa7fA/EEvMIMGcTr3+nek9Xir5/Y/zPqJt23GXZiXrkX3og
	zG+IicCcWqXmNw2luFHLhdZcV1xiONI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nx4Ugnd2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.9 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766543177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fe971I7vctGicnmZN3rn6GUUD9cdSqx5fnZuxG5VU50=;
	b=KNeYZbvM3zEm1hQ3uVw9VB+vz5nfp2Fa7orQ59hV3lytbVTOUXAL3vmvUE4VJgfNPzN9n2
	Yg4tpWrzA3srt4hHRpx8DzrLWVJAx1rIBMMsyueLlMstWkH3stVNQ+VVhf4UY022smA8rG
	Ezeu79pW5WeLUiaJf+Uh31+Rmb4NoSo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mx5Rzuwjo/Xh5/W81OJIHkx3oMT6JVmcSoJpAchShZK6p9y+WKL7bX3R1ar7XWQlL9c9z3dasVBXEGzSqiggqx0Eyt+oB7py+gUt4bHAwlaoHEZkJuTbeHcv7RNSvcOTPtgbIERT1VD+umcD9JqyNT2UjZDtHt5ByhBiIosMRtiXSmtlNOth89I3yoFIeH1Pao32PLVASDOenEns6/yj7KZ3BACbAsHSAgbIVCM6z3D7jtZh9P/n7TjieyS53eGpBC+JGBI9LBoNa0UocLQz7ZGI6vJfGHPAJ7YtEOaVHXGU5fMkL2E/AAkTyAlKkrHjIwCeIIGvgnuaJAKlVknDXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fe971I7vctGicnmZN3rn6GUUD9cdSqx5fnZuxG5VU50=;
 b=YNzL55AkTxP8JEXPBGkE6UPwTILPmz4smZxzWIFKnaVr+f+oN8T8H4Rw8yDhsqUA9bGRab61gqrCDRcAlM38YmuydFq3nlX+iaJjq8ZeYQhvDcQq+9WJXC+WOx8yWW/MnwGV9tl564eCdyPQFU/dVmDYwns9YekydQ65TqThiDCeaJ7FJIeC7iZAF0tKWtX8VqYr8bVFty0oxZ/YXVtZAs5Cw10c5rDKiXLOrbabXDrffigw4CdwFUOKaiaCWi113A/dfMYoRePfiu3f+5sKmD6FNjEV8mtXPTT99rsVM29djYsL5uC7en+7UsG140A2GdX5runue/k1RHEq25Xmnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fe971I7vctGicnmZN3rn6GUUD9cdSqx5fnZuxG5VU50=;
 b=nx4Ugnd2xEPHsHecTCKT4saQNpZ2+oVL9/UgZiEYQtJjmo6V1FUtC5c6PIm4SFtF6GC0zqmVaBdJ2yFRW+A+B8vCTdRKP5TebmGYDYm9pCdlo9je1F2OzCWKIV90sGRwn7zkcyhwHWe1zF1xK8fmCx0JQER3SVe2gyV6WxC1kqFvhjSuSaFaE38HY3LsKlIcpX/ZlhR83wpb6rlhF30rm3bsF7tLtjCbUwehTuY0uTEBZcEJEkg6rK7EmNPUmWo8lVafVCpTE52N9kZRRXFLekTnsnCmqT75W7Jb08BIMo3+olGXyiZOaaiKrcX+TdVmcph4vyaSeyF5OYJcEfkdbw==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB8095.namprd12.prod.outlook.com (2603:10b6:806:33f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Wed, 24 Dec
 2025 02:26:14 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9456.008; Wed, 24 Dec 2025
 02:26:14 +0000
Date: Tue, 23 Dec 2025 22:26:12 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Matthew Wilcox <willy@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH 3/4] ARM: remove support for highmem on VIVT
Message-ID: <aUtPRFdbpSQ20eOx@nvidia.com>
References: <20251219161559.556737-1-arnd@kernel.org>
 <20251219161559.556737-4-arnd@kernel.org>
 <20251219171412.GG254720@nvidia.com>
 <513078d3-976a-4e6d-b311-dcfcfea99238@app.fastmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513078d3-976a-4e6d-b311-dcfcfea99238@app.fastmail.com>
X-ClientProxiedBy: MW4PR04CA0187.namprd04.prod.outlook.com
 (2603:10b6:303:86::12) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB8095:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d7b1b12-71fc-4b54-3c06-08de4293cf5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FfGIOQyH14URNgZzvp0KfG1PHBbKMeDHkpBMBq1b6fLft2MbXrU9HhhHviZ7?=
 =?us-ascii?Q?lgl5xMlYRG3aedouznpV846rSqfCbMXmC/uBswWj3fXMfQ5C3gjU2mywVof1?=
 =?us-ascii?Q?JgUFzzlOY3nG42mP029e/XyxY7RCB1YLIKsf2Ajhnh3mqltuEhQXVaxDV7tD?=
 =?us-ascii?Q?wmrp2aefHiEpfi7cBG+JhLLAMS2gr5stCJqcd2VtpY56ihAM0Vmu6yjSMZPj?=
 =?us-ascii?Q?rYOZYfrGvGms3eO3PXrofnISNhqUmtTBHU3JHD7BqhxMMSHzLTaa8ueTIm+z?=
 =?us-ascii?Q?Ki9JVeKm3U8bIhnp368zIzYw4PtupZOXGsnA3I3NYjR60FFYjEw/sEnrFEVc?=
 =?us-ascii?Q?K7+f8lrCoQBQqwlZ4rnr/Dn4fp89whZz43TNk0qNjyPbt/EBZE+HeDssay++?=
 =?us-ascii?Q?W+bGMhFZo6yWb1Ots3mdLdG/K4mDOJfVwNKRrInDgG/to7tc/pxt5fgfZEyg?=
 =?us-ascii?Q?oYjscZP/FhLRO0J0fwq5DfHMjNDQ+wsjtRcNWa3/j4GjE2WPBc1bkjqthy0Z?=
 =?us-ascii?Q?gDdUTTzB0rg1Ct7WKwyHXn7ag0kPtt883uGxjdX8h6uUexwWZ11Ms6VBTpVU?=
 =?us-ascii?Q?CmKwZWRUIG7LwU91dBiCDdORZDyVw44dUz37etehgduIy6mzzyVrHnNAPJpI?=
 =?us-ascii?Q?1QAYUMKpFzbtXFFawrQaOBKyhcxCy0+aN1muYcKRWVCx+O3eehmU5kx1a3m1?=
 =?us-ascii?Q?t6YhGBEn5EUb/mEOUkR/3WuHfYgTzrThZvYqoSu6dFxjYzDYuPHLheMVAN7C?=
 =?us-ascii?Q?aKO/hL4YlnmBFaLMAeHASMXYO5rxPHOifxnDLaBvfy5tWnYOusRl8acQB2U7?=
 =?us-ascii?Q?Sd8p68j6tFcJG6QOLpgR9RUdadDs6pL+JLxtbHSFrbHyv5Pns+R5nFbPVFfi?=
 =?us-ascii?Q?vo3pESHNUqv5t44OM7vLjRXNOZy8ujpRlgR0NcrxaUsYbz7DoMy79L6T53g8?=
 =?us-ascii?Q?MITx6FOmupGlSa9As/lcPNBIBErQqe/1bZr95MwYlJFljPWEVEv1lnlbRJYF?=
 =?us-ascii?Q?fTaQNWpSTjL0fdaCJgT/ccGak0gumrg9l/pqzUBOzZDnd1/eqLN590ePfBSZ?=
 =?us-ascii?Q?DZUdEXs6+Qmievh/dH4ZQEFkOE++g7B7s90ErE2ZVwdjudcsqCJ4RDzXNLhx?=
 =?us-ascii?Q?+kHAs50AlshMHKnnn+62VsUR6ez+4a7xD/sKRN3KyXNI7Y6Glnuk8yo5pFv5?=
 =?us-ascii?Q?on2+lWrsBjYiYsDIQkKyeznfFvJ3q5/4WQIOsJCc03LX06aQSRBpbugB7XEz?=
 =?us-ascii?Q?eBf2LvBfY+ok87zlaI+/zyaddoz3E8OGaDZMtu5ehyt3wvlz4VODSUMDmyGD?=
 =?us-ascii?Q?YECauAjRmA3TAI7ItBfMxRh4mxBeJjBHxgcD1Nb2oieTpXP3vU8jfADKfdae?=
 =?us-ascii?Q?BMYR5dKI1e5U40vTeEgfXhBdyDhHtxTe/Lu87YibrTep8B4PNpUYGTkcS/C2?=
 =?us-ascii?Q?hY1y2dSL0o30bVL/jKgexveyi5PPaWuL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+kxDzyl/dThwRaEXpYXkNI7XExGZdFars2UevTeolxu1Yiz9Zv7JQcC9f4/2?=
 =?us-ascii?Q?J1WbfGzFW9mKItjtKzSbNzhKC6uV7SO2ev5b419Hd2gVRvEl/CCKtB3YL9js?=
 =?us-ascii?Q?YOV8ggsbTqEUrF2VBIMKHtQl/oSpV64KtNl+zp56rsYGFUIPoNaZuTgJ/GHD?=
 =?us-ascii?Q?cWDa2LeMQn65EeXLhzboPOhX5p6f+DPBsZoyfzhSK6C4KK4HFyQY5KLvtuO5?=
 =?us-ascii?Q?Lh7kv/qwPRa/AQJ1hYcF4GTPv1O/5UCDMPqoiwxXILWch4/i0q9XeIktZODA?=
 =?us-ascii?Q?v/tEj/EV+htVTZ/jksA0kD9dI39TAPoMvCdRQKNYYtomY3gsrPCA/kSUZXnx?=
 =?us-ascii?Q?k6lqRM+kLRXQHtiPB9LnM4C96M5MYch/T6TN0hYabmgwbzP/OGdU2VVU5jdo?=
 =?us-ascii?Q?OjbEJurAew3WT4+NNYduyeVeGoUKmVOOmCNf2Nb/dwE9rVtifSYGaNPqCICr?=
 =?us-ascii?Q?dahkXAM+8jafixcjRVVdzohCxBGtNGedwphSW7Oy5tJzwbfuk+jujkSbIMfg?=
 =?us-ascii?Q?wD6mO0iwG8uGxLUdzBWXDAPC3qV0fAuS7VLff0dCXBKGNO1mI9IP4nggpnnk?=
 =?us-ascii?Q?AhLxHZwtE1QJXSJOFvU+Bs8A9znbbijps+vZSYhrd2WciT8WB7kK0VTzafb/?=
 =?us-ascii?Q?f5jxkYZSARzDuoDUq1cjDkWd4jAq/F4ygvbvJE286FS43d5Sat0pfpi6fHnk?=
 =?us-ascii?Q?LRO9B7PYxM173eFg1z/1AfCJitPQfoUTfKXk3zvA+3KGW/uYcf8YpG/zRu6H?=
 =?us-ascii?Q?ey2jJPe6KKT+qSG24wqr1YsYjd1anD/UN2fKRmUJTjqou6BO1V6B77XRQVlr?=
 =?us-ascii?Q?Q38lpcA43YDnDsj+ILtwO33T3B3OdHUSoEq3Y8XvyCLYiWJPr7qu8RvYU1e0?=
 =?us-ascii?Q?n9WqR0eF61bczo/WXcD0CgdVQzfWvmsB9u1P3/ZzJIiuhaUa81uOydB+itIh?=
 =?us-ascii?Q?1IJS0lnLfUKjEtsdmLccwn5NETr3Wq6iFsFv5iAKFjqEWqJt3vuOC27fAEic?=
 =?us-ascii?Q?6qSPcyqnzAS364NbicyXecAJBP+dshZXZPq/DKCeM9UAN80bbR9i3Kv9GwbR?=
 =?us-ascii?Q?sEjuJ2Zr52O7h18vV/jUtAArF5t5gIIztIEy+mHkQco7D3QaNsSCOsuZ4qKv?=
 =?us-ascii?Q?LpvZCU5TtTFbD6pFYo7T3wObJETFNsvVnRRoy4YnqqKiiHWKEMOkOuDzQtOf?=
 =?us-ascii?Q?Y5wREG3AWtgxpcGG9U3v1K8XskL1Pe78IZe/oaRi7CLp52rloFpRA3Cj1mQv?=
 =?us-ascii?Q?tVvMFwAiba471RpS/qFVAyG6vw2yldirnOZmFhYbXU6uYkT0ysSO9qdht8I/?=
 =?us-ascii?Q?R0yXwsGRg1HBxr13jwIf+VSTbQCzX+t3gtCm8jmB4yQ69iZYLGhuhI7v9z1y?=
 =?us-ascii?Q?CIbYuY7Kv0H1fDt/zt8hi2U/DDIkl2gMubYzK3LowIG/ooJkycsNBr3jABdW?=
 =?us-ascii?Q?/ik0LdZkoN+tQbf8AIvJQnyEZAluTs2GbgwScb4RkhaNidTUy6M6DNWQV7B6?=
 =?us-ascii?Q?tTcUJIQ47pUaBkHvC+VdXtQByZt+TmZT436HK6tY2FE4aim2C1cv2ZQWteVx?=
 =?us-ascii?Q?ZqwbyEvGBflRs604h5np7NBilfQkGulvM1bnuTC7PY8+5MayayyNqqIcYcpd?=
 =?us-ascii?Q?fBfVMPkovoiao8Z+1kbM31Vg3QNzCl3Zv8E3Ngrl2pXqo5L9+Svtk8jUpjJb?=
 =?us-ascii?Q?t26d3K5IXFHTy+XJRSKy1OKEtwOMYisyat41YDkbpAErW4p3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d7b1b12-71fc-4b54-3c06-08de4293cf5c
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 02:26:14.2322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CjYlyjUNBbQQd5TbjlAYcVphkB2MfhTVRNVWJpLTdWY0PTfXg+LwjlQoWivegRge
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8095
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B4DE1C000C
X-Stat-Signature: hpumwgiygzgjxjimf1mookida8arpo9d
X-Rspam-User: 
X-HE-Tag: 1766543177-456854
X-HE-Meta: U2FsdGVkX1+30AM3TW4HWyuNWUg/fG2DoXVqBsskRX/RWpdcB5hX/TOiQBDjtbRL0CEJ/Nx4BMh7NxpGA+DoXLyulygWO+0BkBCk0IcI+dvnXmrJC9XX5UAgKqviMWegTrCsjD+xe9Dt+0YwOzBHD98uBY+4HZRDuleOfke/UZ8CLICtOabplcPAYH50S5EHswhfN+ACHaOyLy75vYRaCqurAXjFxHB+Orj4ElqdJ1QDeObp7aSnJd1FJuVcZlKME+G7xtpmTv+bt36peIQltk44Q71TWfsaRWUILQDaalbiocGhw6sXmWLsh2mqWlV6ieKgODK1PHI1DLe8cE9RnOLUzqF95Hh2kWIeZGxGGsga2RnG4PO29GgyF9SmW1hZZbHW9o2YPH32FgsSix0PfHlVh9N4RV8D7pCAtAc75rpnVddSn8djxosMF1juuD/0EnEHqon6CrgwqOxziAWfm4HToC1m2LNaIvLup7zMJhCfSpEvRIOmo1CMwof19nbtXlm7ey2EQSa5VnekhdLmzpcQD2T2R4G/NEl9NFrZnMp4MstjWqAcog42QIq7MY6ce/2FbzdR0VYuYRwHMhlQAN1gUHncGz0hRcwqWDDrD/4/cx9lq7PtsbBKLVFzEMd64/ZWBDiorAMY6rcn0v166RyQvAF7TxeIcKBBfgK0vYb62tAwli3NenyxO5K6IDF8fET6cNwZOVpBD1By2dt/+NuRFvh5i8QT59/oNCPm0IVfbHkn8qqhoDcIZw1er2PtHhwV530dhb11hZuYppOBst2JGaghH37Fk5ZQbwv9edt8a/miWp+2wuP0Wzp8hhDx1XjysV8TYMtEdLZMRbQZptbWsOrUmiQN+wiLSw+6kZSeI/5zWaBUpLtoYlTj24Wi7IxjCoPxmD2TbrQomr3N4HRdq033rfiBbd9TFnqPyIpi5Bx289Vr/6TP8+yyHjXAP7zEqQmqi+R7be8hn8g
 3LaaIIZM
 TzZF3pD/9rAmoSM5ZFmM3X7jivpfKw/ozuYQI/4nMSexZAlGWOwojXWbW3Bb/mkL+sXLEN7oM2tYgh0+IcYxs81mUwf3m2Y5j8nKDHrLSPosvwS1Sy8H79Dl9vwx78/sU+6UpDDmk/H1oewEGkYj0IlqmPuBDuM3svDRt2LmmzgM8rrkWDgcv3XxN3xG+ubOLei1jrv43OPAYka012B2HZh5a4z1pCOx4AWucQFRe3yWT+sBFG5bMxfJtvPZaZPyFlzUlB7R01IZka3mtFQWMoZF9+WHdlF7EhrkD8uMKni8AwGwhOTT+Xy6K/BV4BZGQMhJ8rfd5xp9HugaVnQHQluoO9KuvZ6muTr05yL1sUI6qdLYOUnpnWAHtOVTlB1M/U2TmHqp90xaml67VTDEN3nevpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 09:34:33PM +0100, Arnd Bergmann wrote:
> On Fri, Dec 19, 2025, at 18:14, Jason Gunthorpe wrote:
> > On Fri, Dec 19, 2025 at 05:15:58PM +0100, Arnd Bergmann wrote:
> >>  arch/arm/Kconfig                    |  1 +
> >>  arch/arm/configs/gemini_defconfig   |  1 -
> >>  arch/arm/configs/multi_v5_defconfig |  1 -
> >>  arch/arm/configs/mvebu_v5_defconfig |  1 -
> >>  arch/arm/include/asm/highmem.h      | 56 ++---------------------------
> >>  arch/arm/mm/cache-feroceon-l2.c     | 31 ++--------------
> >>  arch/arm/mm/cache-xsc3l2.c          | 47 +++---------------------
> >>  arch/arm/mm/dma-mapping.c           | 12 ++-----
> >>  arch/arm/mm/flush.c                 | 19 +++-------
> >>  9 files changed, 16 insertions(+), 153 deletions(-)
> >
> > This looks great, but do you think there should be a boot time crash
> > if a VIVT and HIGHMEM are enabled, just incase?
> 
> Do you mean in the common code or just for Arm?
> 
> We could use the Arm specific cache_is_vivt() macro, but it feels like
> the 'dpends on !CPU_CACHE_VIVT' Kconfig check I added is both
> safer and simpler.

Okay, so maybe I'm asking if !CPU_CACHE_VIVT then the kernel fails to
boot on vivt systems, maybe it already does?

It would be ARM specific, all this stuff is only for ARM32..

Jason

