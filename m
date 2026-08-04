Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B969C55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8C66B0105; Tue,  4 Aug 2026 10:41:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F4A6B0107; Tue,  4 Aug 2026 10:41:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7479F6B0108; Tue,  4 Aug 2026 10:41:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46F926B0105
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:41:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5571A01F3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:41:10 +0000 (UTC)
X-FDA: 85063849500.14.CAA67E4
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010049.outbound.protection.outlook.com [52.101.46.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id C044080005
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:41:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DDvziXqT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of jgg@nvidia.com designates 52.101.46.49 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785854468;
	b=ZZ4Yx4jtpWpnkJvFI6p9T27yLUdA13hhRgGVSxKs8DVHhYF2sOmJ9haX7SAnlCwGoPSU4e
	/M6s3VwW4UTi+uUvyUZcUgaXzjG+MlhRjauXneZWOdxTe8dMPk3lkcqgzjFNJrI6F/mAxt
	j/Y8YrLxeP4SAe9JOmLNVa5iR7pjCWU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DDvziXqT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of jgg@nvidia.com designates 52.101.46.49 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8erEfFvSbeDCIMfYRcsIGu36kvt3zwWMZC1Z4/yHsyA=;
	b=Nh99AhpjzTPXFxwM3SHT4sviNRTS9v5+YKs9wF6AVSF2Oy+ir4sImuMPdv01QUJBsLVDDC
	1t3uD0NUJe4JBJ584au5IwLvy4KcU+tsP/eFT9bqlVZA2ECdyAd6pZHXilEqiQRYMVgWQ0
	O2RxzjM8fCFN29/G58lu7jQGjDgNeP8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M6FdoZ0i/shQXvP6Y9gVkqfVp+4QX/7ptfYGZMYQnRfStJ/7NWcBwrH+FjOyp+hYWCw/sLAadn00bF/Vvof1akpNfChdMn0gg7BGUXEVddR8hoAgrKcU9HHAkvcZwSMTDeirTaRl3dvmZvGQf+hNZEvUqLyOvxKruP9bfAtV2sr+2zRW/s+DH3co1d4fBrUO5Ik3u9jcoxh/W3jxWrveZMss6vljkM4MOcK3Yy53t/8p9gWFXJcla/Sp9nVO/UVDP4FfWrfApENqv5SuRgn2AFAj0AWO5qdugrZnYyGwanREON1LS+vgQmwA0q9fGVTPcmmXpJC0UGsbWxQQUC055A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8erEfFvSbeDCIMfYRcsIGu36kvt3zwWMZC1Z4/yHsyA=;
 b=HIy15dCaAjcOYzQdftjRn23Wd4S2otclHzFmcbGmDy+a4cwqhFXZf2Tu9uFcOLLV84fAMICxOMx9K2DTLWmncakfetgyIT5YguNqUdiumx6Z9/UvBVvW1/HA8l4iRTQa+wKNTGUaw0x27+sI3TX70WRKMivFYy6jS0n65UCBUBPgi1z05g/uOuwAJgf5BN8QXeKYuZNmrJbqspti32wW+qKRHOGH0Q9X22lZDWW+nV8AD6cob07nZ5UWROSrhnndnCwsEupYsdYB0zejcuDTEpd3HNS6LwIv0pPdEJL3FfZ4gV7iwRLUgF7usMUAqH8Oq2XuRz/XzgFS7lfLT8T12Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8erEfFvSbeDCIMfYRcsIGu36kvt3zwWMZC1Z4/yHsyA=;
 b=DDvziXqTiC60BY+8SZbaOu4yuwi3lddK5AaXxmNYs7l/iYIMu+gU/1MiRqePtIPscQM03mbOPDNFKPDld2QyZH1RkU8NCXDMDVJri3Tr3X4+g5JPnZmflw5KpYY19r/AZMPwySj/8t40GFwrYw6AhD5QioODUDSjB5GTedSiU/EN6UEvv6uNxE6QOPApUJDUFjlsVgqvVMqm+QrTvJr7y1xa0Mjv45DSYvX8FyuQj7EEcUFMG0tARG51GdpYL1P1IQkAndezVe7itixYV+L+djzRfNTwssXHFit2NbbVwv5pjV0thcddcJLSorjRA8YB4OFaducFY/PoyH5dsMTuPQ==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 4 Aug
 2026 14:40:56 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0292.015; Tue, 4 Aug 2026
 14:40:56 +0000
Date: Tue, 4 Aug 2026 11:40:54 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org,
	tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com,
	will@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com,
	gor@linux.ibm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <20260804144054.GE27883@nvidia.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
 <anHuLy52o5S9Nlwp@lucifer>
 <anH1CgpwS3PHeDRq@lucifer>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anH1CgpwS3PHeDRq@lucifer>
X-ClientProxiedBy: YT1PR01CA0123.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::32) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5757:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fbe9a1f-c0d6-4a03-7af1-08def2366440
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|4143699003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6yK71dAzdlbcgQ0vQZjPVOLLtdp8OBXWIsiG/YuVvC3L0bsPHLro6PXhC0wFekMAxrSI1FScqOuGbthLSRw2p3dOvr7IWMbIwjk7DSo7tlXEw/AN5sx5/ZCIih0dkwer899V68yEijD1oqSaxO4U8c062fXfBVAyes6+8/1gbZHBdpMh3FMuLCP4NsEokTORvxSIBPVvlYXurVQO/2U5Ub34bPzV4mrmk38iH/xY55m5xBqb/F5O1+PEdFEN8M03qakWXSRt0SbD9UjAXc8GcMBf94ZqDnZ9Rfk1GNQrtPavBb1Fp6D6Az37zm9qQnrWnk1h9vnwFEYK04daZ4xvEQCthyE4+UslOmGOqyANnPZbf4qlt9YfCMdSejs5JtbdUDcI1DkQnxlOJzHMMCmD8Y5YEkItKk71abusz6Wfgk4Ze842nfAaDNlRUls8lHxNASFFPdvJcFvQbrI7b6XDVKzIkOe+zm3qf7eFpofyJGSZyBaIglwuo7d3CgeGM5088PIzjnSvCzB33kDnzQ7r6AJOe2Hb02yzaoBFyUHBlMLV+BLZBuQcYqGPjh0HX/3l0nK+3huTB7/icyjpWSAYq0UlNHnOGWfw3JMiSNxOMsqaD3CHABQuV7JYc7KOQ1j3Ys2ymsH3j5BgD1SKFIpHHoU1/6fcfblaan/BZx2u4Io=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(4143699003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y8YfDVQaJ3Z60mSgK0vBLBKRnM2trzi/CNtrPXx8Pka2/TfHvDM7wFl8Rqe7?=
 =?us-ascii?Q?BcfyEchVKkRM0R8ujsj5KrkXXwJYcnBVv17zA5eSWNqPiOIpb7Dokheis5tH?=
 =?us-ascii?Q?jptFrZnlBbkmGqrZqbHN8ukENMOf3wphFrr+swmpeL+xaUt5IElXWv+wstKV?=
 =?us-ascii?Q?PudnlaAiWsAH8xE76/Dc37gWEEU6tUUBgt48B2v8/axDfcmCBNk9YTQQvcmR?=
 =?us-ascii?Q?W+COkIJKUhOh+pUZZ4tKc9hO+JkoSS8LdHgFQKmgEyRZv1f9o4o/BqLBvUba?=
 =?us-ascii?Q?QvepP0tOFphdZ3G248CQnQHyMp4QvASnA4ekr70bLtv8K4eKbjUmxF423vPx?=
 =?us-ascii?Q?NoklG+sZnyz0EdqIaDkxFb9cs/qeEXzwnabWWEVFY/99q6+cXtXZSreShVSO?=
 =?us-ascii?Q?CSipy+woCh7Vs8Q73a09zagBF66Vvp6x2k25yvxD+Huko8GuhjCr+P1WDxHY?=
 =?us-ascii?Q?0Kkriv2QkAHaaJYP0/6xcuN1AdeSutPMsBX41VNiTK/nO0B8RQDu64phP9Vd?=
 =?us-ascii?Q?FDM3qGKZfJf+bP4im+iw6zRvOCxrhMqf0d8Hce1a6XnR5rsGgOBcL//qMTqv?=
 =?us-ascii?Q?0aT2BhAzUUXj41Bsfnda8UaWusrHHTPAy8rd2+Lb0KcHIgBKS+IdlhSCWjj/?=
 =?us-ascii?Q?Pjp+AMrQV4sLKddKf5rlsLMydUWA60qtaNWY7f8asXeGwvwbKu6LRWl3rfZ4?=
 =?us-ascii?Q?AUJFLMeSB0GR/P+8bXIL2GJFjbiOSMUWPS8Ze1TQo+OkcWKmpMM7/fAzouX+?=
 =?us-ascii?Q?pMdpDVbOmARor26YBrHWG9GwCKMpckJpKBYSWhdq3Dfs4PPE8HQT2whr/T+0?=
 =?us-ascii?Q?We7xV7Zx5UR9akl4Ygb5hVzarSdfRNNI0WeXr8bRYV3MnOgFJLZPONT88GoH?=
 =?us-ascii?Q?vUjuUbKK9Cg5Q2+zr5PSTsAVqZ0BuT20fFrsVfxfTSQsyvA9zEN6Ufv8iti7?=
 =?us-ascii?Q?EKHZh/uqCV8p9cv+aKl9OKUGopu7u6u9EUUvCZKu6YI/x8yENCXUGoYvMRnw?=
 =?us-ascii?Q?yY1UN+5SJf8SKTFql4WxflrFiLLgG+iYgbhnTzpI1OFZJ87/d5pwELjxQMWI?=
 =?us-ascii?Q?End74D80i0ZOnd9iEb5UaYLpK1/cZAw4XmSPegEMATMRKPJ5TP/Z7JY4U8je?=
 =?us-ascii?Q?k0Fg2ob8VqP5hc6Ih4UVJCpbRBhr+khzHqAyAeu032bmamnLV04rw+eqq3ym?=
 =?us-ascii?Q?dPEZmW7G5fYa2v53EErrB8b4D6ppWVYbr3Fwz07ckwaWDZkbQubt/lWptaBn?=
 =?us-ascii?Q?PyMss/ba/etKfI7jlGRFtPWkebEtxRx/vhgoN24e+QBQ+GQodelq0FumXw1E?=
 =?us-ascii?Q?qY2H4P4AxnINn9+b/oHvG778rCgycfhA9uTG2KlXbqdjWFKtCGnWHAb/q7FF?=
 =?us-ascii?Q?DQLBBNcsmp/5Ce6Xcz1sGPYrM2EC5tGa03S8lfU2BTqmMGFlbVMtrOw0m7Nn?=
 =?us-ascii?Q?WgR1GSRilKL9W0IxgBwSKAktbDAtLW+lpgnP0KITdxAh6VOn7IoZ6cDrWBjB?=
 =?us-ascii?Q?nb9vG8Tmagyd6rS6M8W/sA+nDw6cabL1bJPFGyz9M5aj2/m+jnZ2U5Ce/G8i?=
 =?us-ascii?Q?Fuibbl930iW7pKM5NijLla7Uz8Exd+c8HDAHAXBUmN+pchAbD/iwHS6KJoUn?=
 =?us-ascii?Q?+guQmr3hpdnJsYcIyeNlF/MfyrfXmGx9HqopPogVOtO995LY5CbQZNIa9/CU?=
 =?us-ascii?Q?If74A0tGTZA1GoKJyq5/L0BBbFtObc0+puGo7Z/qM3aXI5kO5j8LD2SO0fWl?=
 =?us-ascii?Q?fF1pSVd04w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fbe9a1f-c0d6-4a03-7af1-08def2366440
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 14:40:55.9431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZSyuQ+HPN4ZgFYbesBP6cJHx6x1HJLIkQIPRJ/AP8bmXljRIxrXbgpNqMSxWQC5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5757
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C044080005
X-Stat-Signature: kj43r79oh7reuub7g71wgahyczt3xd96
X-Rspam-User: 
X-HE-Tag: 1785854467-847641
X-HE-Meta: U2FsdGVkX19SKlx4jUjDDve15gBBdaB7+48AA5yGjCPG+tcXGoFqm6P30+Pb3/fx4gH+Y40ktVIaBHin0aO3BaK/fyPS6EDX3CrPlroXIGS9BxDscNnP89N1onKvdkHZT7BiJVvkzIAVDrv6Hj7MXEBbjMXyYYX98mubJ8mFL7Utb04FdeKV8vMGOZL1UtGA3L+GiPy1yKxf8S6Pxnso+iAW3nApbjxZk7qWmKAp9iyuJosSIVhciQXnyyU8GtdtcjA45y+gWXJAtSTOT2nBvhCCzC/sneOa5dqJ+7sSKuthYhV4thrE+AWLgAC1zCmcElq6nSmLyukISzOJvpg+IRlJg1bZz+xrKExKCqw1bqZ22eZ9YKmOS9NdWPw3zJYn1yM+mqTsGUaJGpFU+7DiLdobJkH+BfAzA6pL22ORfV1BFTZH2kzpm875purrVDcMnwwzYvgS8DUCg7EkGENHLWIEiL34psVEKsVngX8rBE37do27MfMVhU5jfK3AxegZFHkl+KwJ4cojJUpI4n1mMPh2UVJFN77dOJoTTmOz3RDLcdHrw1zHZ0phX5Q7ScubKULc4cevdyulmEjVqm3LIRUiuc69VA8LEoLA3JX7/id9jX+s12Lsi8gJiyL6MRKpVHee1xfkOHi1nHpAamFamDVtEkJMrasS2IrQyFufNEQD5M6hjYIU5V+wx7AUjWbdfmeQT4p5F5KcC7fb0OGWRdd3a3AE2OgWs6LaA99jlH0Kkc73SRAfoLoBLG29DI55bjCqN15s/wuTmxq8OWIdeNypLIrrMZ4p+44FgkNqIlPM2s+484U1UFjrd+X49zsvWhJOR9JRjGEkrXqEfyJGutgalYgZ3tp5/QmDXIexrlwmqcUzD7gSo6facNiZY84g2ywvi2ntF2wd6Z2NX1cmHkE+lNL6bv6qAfTFu4+v+jKLLFokH3Cm8x5F/rKfMcpyxINNKeD95fsZjwsDIra
 y6gkSPrt
 JyRrIpU9K4yD0SqMU7K/YLZpi8U1EupzyXdlAlY31jC3gU9isJJceQlysXCo2vXdNkDVDg7WcX4tD8T2FpRq2Y4SWB3Nxd48LAFT8UKvA1iUuj0JGhEtwX1Gea6knb0WLqKTsTlDSu7NFn0PJdAX2jJIwkfSwKWjKT+cEq/g64bAn7RL9DvVDoA9jCadTjsOViEfsNWSOP54puvNvI4F/sB1XcBli/SAdQtQoJaHLpo8CMPEGRBaybi4gG7txAC9ApS2ubWQPzWyXZbGH55ln8R8Sg8/UePg6wKbwtT7Z0NrwCLJoxknvmOfwBqj/BqK172u4SSAelmA3hcjJz9kdwDmXhn+KPAURq7ThoM59XoALjNZzylERhBWrNctINIAuJ6XoJOWXSgrVfS17yMqbmmSYROQbVC5m2DtmRoHizLDwchOXeiowxL9uqwu0nWCkVgTjR9NYw8jG8ymUWELzgU7aacjrDFciCvdNuFnzqWmTlUfJV8OHCh32+G00h074BTyXAB+4K/kUjdFHk8J53/24s+h17prytqmy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 03:21:14PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 04, 2026 at 03:15:03PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Since this work seems to be very much arm64-focused, perhaps it's therefore
> > worth looking at an alterative solution that's specific to the arch, like the
> > one suggested by Mark ([1])?
> 
> Oh I hadn't realised Mark had already posted the series here:
> 
> https://lore.kernel.org/all/20260728123859.2911495-1-mark.rutland@arm.com/

It is a really neat approach for CPUs that lack the x86 like load from
computed ea trick and should solve the original request.

That said there is still a merit for things like replicating .text, and
I think we will also have some multi-socket systems that would benefit
from this too..

So, I think the question you ask: if we should ever consider divergent
per-cpu kernel page tables - is still interesting..

Jason

