Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37528CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 01:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C69F8E000E; Mon, 20 Oct 2025 21:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69DC18E0002; Mon, 20 Oct 2025 21:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C948E000E; Mon, 20 Oct 2025 21:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 47EEB8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 21:28:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EBD641A0381
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 01:28:25 +0000 (UTC)
X-FDA: 84020386170.02.BED3508
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010039.outbound.protection.outlook.com [52.101.56.39])
	by imf29.hostedemail.com (Postfix) with ESMTP id 354D012000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 01:28:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=izzQos9t;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761010103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5Icir8ecEG71O3gSLmhGYuuD8znu7RLx68xFCIUdas=;
	b=m42wUDFS2C217CNM2anIfhGTTN5A3Qnlt1klGBSxZLYnuyTsM/Q5OnX9xsWbvtjX2oAXdR
	Aj2EZ0bu1VuXHOncfO+nBXREiOjbFym/Adncyz8PXo6EagwxtmXIyQVAYS4lvhxN3LToVb
	gv8W4iH/j0GjQ0EBhvl74zuKILt2I0w=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=izzQos9t;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761010103; a=rsa-sha256;
	cv=pass;
	b=CcnlMJnhrQud7YGIJrRfgb2+I2ZnZK4VMXrFWJK4LCI+O5Iw4TU3x3azXN9SNZCtf6jphL
	1v1787NbrqlARrGaSHfEP/b2EF6qgbhFnvSrY6cn3kVsktfYt1o+osO/hRr1gW00csgrvh
	Yf55ubH7tNNYYg5DLWc26sUAx2R9jYg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SJIt7BMW/sxcFkETA9bJA5rFUOqDoeECWgiF+3ocuPGjevYP62dmXNnjW/+0zSyJhBpDoOPJLA0+b5DpP0g2qjXcINwbOaKIvMqUh/QutWM9u7lvuVhyW8gzFBS6YhtsLW7/NPQHyapnurLy8wJC5TpWSASSWsLRLPwmwo3WXQs1uprSDcJpM2kPIE82XUMEjJLwXnYjoSA0DU2CfrhjVtsOy6WK2sCPBCkVSztdT30esS+FY/9GApvSpOmHOflze7c3AFApWUtGIt28Jzs47edlG1dnCD2daWnchQcwdOLeFzZgUFRUsAEBV1OOHOyt+cX05AsSH8gkgvDPrFGtdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5Icir8ecEG71O3gSLmhGYuuD8znu7RLx68xFCIUdas=;
 b=dE8Vt8tWnKwlUGXP5uL6LSrt6fS+KrehJGfQS3FDSlo00i/+GvT1D6BJON9rsdHNHeGbajJ/H4WT74n6jm+UhG2px8+JryP9ahwlJz+FJ3s+oMmTekoSX0AXX3w+3srhfIUfpVyuL+D63gOL8zaLBOIIAT8umyhzQ5jXKy6QvazJu1zV1RvmRPubkzXptil3VmuDgZgX2G4B8eMf+CRfs1WBi4LQBhf8Vk3DvHyWkJf506vjSYsLZzNDsyBClYIOFr0JMd4kHvKsyU8nBdh2QxIW2eDTA19XphOcNi/pm75SYqj1KlZyE0kWeAFifXO7PC7Bj1G8g61dnMASUQVvxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5Icir8ecEG71O3gSLmhGYuuD8znu7RLx68xFCIUdas=;
 b=izzQos9tH7aE/tgAsJmacJInoX3pI2SwZ96bGY3wW8MFXQjv7AtMwxxJ7bUC4C7ypwBiOqAKU6JnUKM+TIjc1LNY/hmWlsbRkc34iDjmTWb7nm8JKHN78vAWYTtPcvILAcFldqmxucOtTKjkHUl+D5MQ1xRCEm9XHqbM5Pr3hEFN1lpxsQ/JegIG6FvoHw0cl75pBp1lHFKT8mARdNxcXSraCI6WEbDnkz/Aq93JD2a5F+4LhJtAeMmGWLvXjw99PogP5vLvAW7sMrMB8cE/4ht/qW7Cl8zgywClnEqc5WaX2WS7cywzl06kr8LhgPvQFbdfEOzwUNA+mHBP5XEZYQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8416.namprd12.prod.outlook.com (2603:10b6:8:ff::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.16; Tue, 21 Oct 2025 01:28:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 01:28:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 David Hildenbrand <david@redhat.com>
Subject: Re: [RFC PATCH v2] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
Date: Mon, 20 Oct 2025 21:28:18 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <E787AD03-DC67-4B5C-8BF6-C79F3C583D00@nvidia.com>
In-Reply-To: <20251021012533.56rdl6v76plkw4nl@master>
References: <20251020210816.1089910-1-gourry@gourry.net>
 <20251021012533.56rdl6v76plkw4nl@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0701.namprd03.prod.outlook.com
 (2603:10b6:408:ef::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8416:EE_
X-MS-Office365-Filtering-Correlation-Id: f1b0be70-0878-41f4-ea57-08de10411e39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k+CLFH/i4tpQRzYhb/ILV7vEJqNcEwfsznm3lJNyVP3u8jAoMoEzd2jutQ7Q?=
 =?us-ascii?Q?xRqk22jRrGr2qehSYreA4WvfRt48+YHCe1k/iuwlX9cYSpbHn6GKIrfxzBco?=
 =?us-ascii?Q?p51xrcpzC3tlcrxBY4CKQLu/naFRXQQiTQGCW6f+jVjzkjHerpPf2c78mJ1x?=
 =?us-ascii?Q?++RZu3IE+zfzAih3N79QutQxx+Tm1k/0bdGMHqObYu5qYXkX+eXVxFleQ6BE?=
 =?us-ascii?Q?Cjdv0OgrQtUmqZ9wpUJKFnmA7nPqCz8ClWRHzhDr2FCe7t7ltAJ+GGHDzCfl?=
 =?us-ascii?Q?DG5VlvhKL2aOnSlW/y+rxXgL50HmQmrm7FwG/vsu9vAv11NXZzeC0KXzVFBO?=
 =?us-ascii?Q?O18dY72rDOrG/XsmhOGClpFprE+m4kkkJPq6j1ra7pPd+BHlbuwh5J76G4k+?=
 =?us-ascii?Q?lM3/quzJofeN8aGefjQ++VhsT11DcrOyBAjmWzf/1sgM5Lb00bHoVkPmBe+S?=
 =?us-ascii?Q?HdCtokn2Re9ZVirOQS/xHHAnPK93zmKfrHtkjH/3AY/4pN5XBsW8/HFirp4Z?=
 =?us-ascii?Q?GVt+9uvG5/A8bwNw/wJmue69BnKtNg3wQTRcGR0jy/rs/mgzkMFgmMtZFzdG?=
 =?us-ascii?Q?LDWspn9RSzTIyFajjBTImnHEqGygPvGi7/CWEEOZE9qSE22qhpbR1dcEbfwQ?=
 =?us-ascii?Q?aDltIKbn2Pzuv7LoLeOC+8xvVct9TM1KH71IhTQEoc+GvwbCa3fyGUMvEe9n?=
 =?us-ascii?Q?HY5XXuZdJeA62auQIoNy3lAOrjtug82tLRE6ojg8932BBCnGG/+yrGoXjsqR?=
 =?us-ascii?Q?8neU5ggo92uA4qD0agCVOdKy0mFQDFZbX1zSpaZlL3NOM5xBXDFGEPw2DhCk?=
 =?us-ascii?Q?KgvJijmjNO1KkF+t7WVB3gE9biWCSFiIbOuXfXrLzs5gNm4ZzUp+LNDY3r9N?=
 =?us-ascii?Q?Nkxh29WAyp2C5dh6OxVKvrWXDSvNsxYkxGTuIC4D21vg2C3W7rUNsR3axUIV?=
 =?us-ascii?Q?vxWXv+V6QVVI0/qOAKvVmKYyJDGUkxUhZrL0Xjmmvphrbdb0BNfQptCHQm3Q?=
 =?us-ascii?Q?W3fRXUeXV2dL3Ffk9WKZ/+M2R6pBaYjG8TbVgo1Iy5areZjoc/lSGZaLtUje?=
 =?us-ascii?Q?YM6NIVQClvvVgYq4kAuiW8vvRV7KrAiq6JDEF98qpG/DfmVNhsOIGB7/ybo5?=
 =?us-ascii?Q?mSHIQbM+dtymYqxDH8Ea+pX23L1PlokkGBi/hcK+rnepYrJThMRplgzpzpzN?=
 =?us-ascii?Q?x1xSlAkXwL/PLC6ZRjCL6fXY1xwmAvj966j4FNu/ttWZPw/dp7Xw+88AynYM?=
 =?us-ascii?Q?Im9SfYm9pcPV4kTQPPX7xiO/tipw+pC+ntj7fsXA0I5L2gi0q7cgPcpCvLdU?=
 =?us-ascii?Q?wM9IU55/SL494rz4RUC2e8zG1VyIBvIuyEDS0PrvLD6Wnv88dKq3tOZT7zyF?=
 =?us-ascii?Q?OuCXns2FQ2QtZWCYDpSCX9rkU2kU7rmvY1kH/iBdnFI6B7IWmw4nJPEFrNGq?=
 =?us-ascii?Q?Ibar6GqZFKEyxOQKp+GzqPFKFKyUr1Me+agn06LFZsHXAOPDwV9/Cw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a3gyABQrdivJZnuirqjJqCGpyACec21uIYSgL57HjamtSFZDyFCixsBVwKHt?=
 =?us-ascii?Q?FEQqydsiRRPKgiwN7uDkBolLOPsmWnhN8TAJLSOaRubETCXply/oryYCXKl8?=
 =?us-ascii?Q?Z9c2xLd1BbzGWk+9H6FFu9P0jd/nKGQNIBTJNcldJTBlUPwFx3ftDWFfeM0K?=
 =?us-ascii?Q?VsnXJBavZ9NScadzahfwXwlbC2iOMYJfZ0QZvBq16tyyrwFf6RVILy0kKV4T?=
 =?us-ascii?Q?RpF31cQATUyh4Mq8uSzBvezkgQhTx2qUjAwWM2SnXFxaeoKrs3TteKI7F8qy?=
 =?us-ascii?Q?spqAaI39PkuHfz2JKL5HqEJitgk0LI+gz2Zg+VhmuzOyf+n6hQg0BQf26v5L?=
 =?us-ascii?Q?ejMFhUqjizzgJjVs+qgYoPG3eCyqi5p7uanT6JPC7sZh/OEaMxI7dF3P2E96?=
 =?us-ascii?Q?lE3FEmZgNGtVadcR6UJ2iOoNUeg07cGFEratxtHDG2hpAOT72zGWofqHsPXM?=
 =?us-ascii?Q?RI/JjXMIdLFeIVqD+73OQG2MxCG0AuFSxojjHruacs0nuVsTqdpDIO94qIoa?=
 =?us-ascii?Q?alPukj6QWJF403LRPCZa0ydyx/YhMGSpel2B6OmqLES+oHIdW+uN7ojDK9VC?=
 =?us-ascii?Q?hT6vcqiAAyvZvkR91DoZNqtlS0bCf5/TsBIoUA9NYLfeezQN9MUuUm8JO3J5?=
 =?us-ascii?Q?qf5KqCSkc+2baiMO88HpLsT0dfmrBtQuCSkxRI1rtU6rz50xVPsseYM0Y9RN?=
 =?us-ascii?Q?LmU/g7zxrm0+Btkzfx8ZoXAhFSSEHrp5pURH1znnoX4rsP8OnZCVI3I5dz7o?=
 =?us-ascii?Q?yLMrJa5HgjsLHtTwwyE1V+nKstq1/Gy4g8GG0NS2e9bXSqW4a+lQZb4Y0P/t?=
 =?us-ascii?Q?E8v/SMdpwBnbkVVpXT8zmQba8cxnxUsl2kXGEb3eY2MzcLxeW50G6dCjwPWc?=
 =?us-ascii?Q?cLdJvejbiOvET4T6GTY80QIamrLXCSu3tzrTeUKmj6hRpIT+3yrDT2OjY9/Q?=
 =?us-ascii?Q?uBAO1HTjp+0rbeg+3m1umCCxYve0/8dTxjSgA10507CP25zSsZfvODRMHe8E?=
 =?us-ascii?Q?ByCVxXV6F+o5aH+BGNK1MV7I4m+A8bvpw4F/YFZ3s7JZRlqnDq6GxWtHXLSC?=
 =?us-ascii?Q?zLM01EGWMHUkAGlUGOEXC71UY32uYE1/azXcArE/KAkzP59ZFJSt6zjLapZs?=
 =?us-ascii?Q?2b7EZE1wWxNzj+j+qcnFVTRhyy2QVyhzNHo7njXAOxbHjjdgPhazbdhAvYYS?=
 =?us-ascii?Q?XeLu1Uc+7t3dr/EBZvZyo4qjQdiI8Y3OG/meoryUcHZdcEKmqMvPbSfHwfMQ?=
 =?us-ascii?Q?Hro0Ob0KCawFqy9BVrBqoPfIQ9yYEJiFY7Ayz2rY9Z3FcQq8GwMm6SI0eo0B?=
 =?us-ascii?Q?p+VU/VEUoHcSKC7XDNNcis0Xzg7WSvnM4XO3TNty1DiUHmxJxpYS/Tt/85WK?=
 =?us-ascii?Q?szmaEac9TBKljXTPUmoKjGPUfWYSOafBmJmVxTMmqn3Przew80kXXvOKFqbK?=
 =?us-ascii?Q?FgrjRGfIRo3CzVMsfddG4qgaUk53Hb6NvGDl6OmRRoyJQxoPO+dCJX1DPye/?=
 =?us-ascii?Q?j38kND7b8Vwxb6IGCmBB0oeFjlzytz8D6h8F6jjPghdsfeEanLekkmP7H2Ae?=
 =?us-ascii?Q?YFsCbr7f3eLskCWz+zMOsHXBUKZQRDyORh9vLKwF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b0be70-0878-41f4-ea57-08de10411e39
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 01:28:20.0687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uu7EPPrOBom++TKN102ormF6FgA0w5Lmg0e6KJi+G9QXhjIXES9YuwXw6PQWQRCR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8416
X-Rspamd-Queue-Id: 354D012000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 54jjhdpjwp8edppg1dqmmro9ses7ergg
X-HE-Tag: 1761010103-829422
X-HE-Meta: U2FsdGVkX19D4zYAaeVhFv4vCGpHcRzNi3apjnGal9KwxCOdk8428f5aZQco2rnEYEuVX9Ttp8ArOTUI4+zYSF6AjYAzQKutZ+cxGM2uhv2k+wlgt4fI2/rf/IVBTSiKdVopGqNFAXILZUSJp2ysffrtc2xf3VaiE7COt23ukPle77Z/Fst3XQJljCJUl1HzdzCHE5wndxYLvU3yN+DTTVsPHxlfBYs+ol8eblXc12iZ8WtAT0JC+qcTtoW5v2oSFvo3cUsg4JzzOuZkAtSd3nR4LvQhiuL3bYrt1Yn5dLAz1mujaG+FMCpGtg2y0bS7N0ivPeK7idbgQxo+QBamx03gLtOOCtnA1hqKvsBt8czP9QOT7j090O5W2ktPH1soDb5Xmeuz3QHi+tTygJz6I33zwA45QgO9lnWsqxzxswYXLHyG4HjUlb+5w2w6t8wOYreP4wSAPv8y3sK1S1yeeSSRQv6iMdoVlwY5oXVbL0U/LxNE+3vhiPS/JmivxYhyGnzbfPXWjPyHvIgjeAUkIM998hMjNeAq+wggOBp/IJ2LdSr/ZMcs53rhiDm/f7rh/9eOSNeGIZIQKWljuaPzftSYYrzXG0qAJkVPS5pqAldHBb1UDJsHqtqj2KTSbQX59WSpLPCko+M49RJDBfxQZ4G2uizv73SBmS4RxPXCCq4phn0eIV3WqpEdBc9FTqdQTcEaxBWcAj68UH2ynmCWVL1GsHmuZcq92lqNPuUx3xNpPeziYYvFlHvtuRF0p1cS4IVmUqAm1Ug31oiX3KNzWjoV0CDX4nTb/PuqLwX8dx/7ZdmKXG5qkNJAGVzXhwBXe6gdUsQcdrKQhY0YECVz3Ym+SAeXwD/05vVa/oUz8jMi65JpETwZhcJxBydtExtm2Sn5kwDZ3GLXjhqPCszU1hlT36EQiX8glmY6QfJpFVgttZMTn6qGFSRKvbLSE9MNXYvAwLQZD2+XzxwF5hn
 VL9C9NdM
 yTKphiWtFykTKUxa6EC2X12RStGgHMOyKs2efSNxPQk6nOfMfPHC012NQ1MJNnoyabqnqva+FVu0sdlbVBnQJO4UJ6hE0dgGhM1EjoAmJBlEfHG0fsgocWx6FqvDFLupfxXNjotIjlIk+jI4HNWXGvB9Eb88NjvLBj+2l2/wgSDzLkHBP69BepIa/PA6bxHezBNNd41O0DiH0dhi9wAzk860AxxtkvVkJB0tKJJR3GEmtgPkpFI79JBDOBF6DinzGuXqqzrtDip0YRPCiz7LRNDzsT5VjAzrO24y1jXXP6SwDB0OPnA9GV7XG3lwv5oaLxJG5ufzno186GBUxFluACbYyjxSnLIaX2+9MKU4+4TMHqDSF0Z0WYISmXHPD4eOibHf3wGCZcKYJ3YtTOqdIKlcrH/Q3v0MIFDH5C2/1nMQ1uvocBonusSKAOL7aWUpQB8EeJjMOA409skJi6oV62xUDYJL+6yzuueXFpGQXQCcjc6gsd4fq0i7zE678BEUVk/kxFiATHwmZJmTLvkfQQhAvDNk33zdbbuGNYO9243WxgGKeT/9EUxPJ+r5JsuA6DbyTzbiiFRLdWUr33jY9uWxnBSRG2NCRvOS4sXW4GQZDPghZW490EDEghNUzBy8WA1m3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Oct 2025, at 21:25, Wei Yang wrote:

> On Mon, Oct 20, 2025 at 05:08:16PM -0400, Gregory Price wrote:
>> We presently skip regions with hugepages entirely when trying to do
>> contiguous page allocation.  Instead, if hugepage migration is enabled=
,
>> consider regions with hugepages smaller than the requested allocation.=

>>
>> Compaction `isolate_migrate_pages_block()` already expects requests
>
> isolate_migratepages_block() ?
>
>> with hugepages to originate from alloc_contig, and hugetlb code also
>> does a migratable check when isolating in `folio_isolate_hugetlb()`.
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Gregory Price <gourry@gourry.net>
>> ---
>> mm/page_alloc.c | 15 +++++++++++++--
>> 1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 600d9e981c23..da2e65bf63e3 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -7048,8 +7048,19 @@ static bool pfn_range_valid_contig(struct zone =
*z, unsigned long start_pfn,
>> 		if (PageReserved(page))
>> 			return false;
>>
>> -		if (PageHuge(page))
>> -			return false;
>> +		if (PageHuge(page)) {
>> +			unsigned int order;
>> +
>> +			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
>> +				return false;
>> +
>> +			/* Don't consider moving same size/larger pages */
>> +			page =3D compound_head(page);
>> +			order =3D compound_order(page);
>
> How about using folio_large_order(page_folio(page)) ?

See the discussion at https://lore.kernel.org/linux-mm/609E7E01-33A6-4931=
-AC89-1F4B2944FB64@nvidia.com/ about reading folio order without locking.=


>
>> +			if ((order >=3D MAX_PAGE_ORDER) ||
>> +			    (nr_pages < (1 << order)))
>> +				return false;
>> +		}
>> 	}
>> 	return true;
>> }
>> -- =

>> 2.51.0
>>
>
> Generally LGTM
>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>
> -- =

> Wei Yang
> Help you, Help me


--
Best Regards,
Yan, Zi

