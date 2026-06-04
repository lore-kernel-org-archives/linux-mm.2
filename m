Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41104CD6E68
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 08:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5373A6B0088; Thu,  4 Jun 2026 04:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6B86B008A; Thu,  4 Jun 2026 04:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5A46B008C; Thu,  4 Jun 2026 04:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1156B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:14:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0F0AC22AC
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:14:27 +0000 (UTC)
X-FDA: 84841518174.19.F313977
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010028.outbound.protection.outlook.com [40.93.198.28])
	by imf23.hostedemail.com (Postfix) with ESMTP id C378D140008
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:14:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qrZ7NT6r;
	spf=pass (imf23.hostedemail.com: domain of apopple@nvidia.com designates 40.93.198.28 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780560865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2BCbHXFYeqwBA4U5rgoNiZvvrCZ2xPPKJSxut6nFTM=;
	b=SSDxuBv2nF8+Wj8jxghBp14G+tR0hh6oLQUK5FUcVTVjNV+SuI67pQxmk9nQ5sZ+SCWv7a
	H/OyQnrhGpWU8/KdnZ8ZSdkmu4IyosqlVA2W4tzcrz00VtHai58PJWInUjo+cyoiWed/Yr
	ftbEcBnj99pSpDlvoxw/q9cQEDXqrok=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780560865;
	b=l6nspH/gkNe2lUEMu2XONkG1C1H/i+qpjKWn2CReaP0KKS0SXPrOiEk/RLKjPMfji1P2oX
	eJFDaW9eep+lCLsqj9M1/8pHgKwvz5NcFix4qMpa7yzkFA8r9V2c5meGLZ0CrlB6nMyBwi
	TiYLA6bdQTWLU+BC1gxh08mMk4D4c18=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qrZ7NT6r;
	spf=pass (imf23.hostedemail.com: domain of apopple@nvidia.com designates 40.93.198.28 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oWeC5QC9HFGp1adJSH7iO9OFCauMCDDCY3S8ZuovnEj4ko/MNKTbDpVnEirQfpjlgHdIPNc2MFGUhwxr2MkX3KykuRdJK/YZaBRy+qevh/GAlGUleQr8I4OzfWhh8JvMEvmPD2ei9CXRssJgYAAlByfs/4n1uRRocVYSo4ckXm3Gm3r3DJXTbKePQKPmifYl+kKAqmN5ei9nHW6TfPSZwo6N1WbUIWUZltR/QyDjtprjfLVLvv+iEZUMOEJhPwkD8i90TNS2vvKTcFVHHklCyGI0etUsoPOB0no0L9x5GYXw5eMsrg+V2XkxCPA71e9f8lyX6+erpbrnE9oGEG6zWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A2BCbHXFYeqwBA4U5rgoNiZvvrCZ2xPPKJSxut6nFTM=;
 b=UgnSaUuZwqS8Vk65z5hhaCt5z1oTczYAaH/ceHgowd/QVXaHZjJ/Suigm3fRj+FVassxfbZK9cYTHQEMdG4oY1uA+QX8tmY6YcLmG4oW8kQSNgDZxgC3B7e/D7E+yKOvbTE79xKdEeGgBv3VA4x3RWRhq50Sgf1r5QX69XpJNZxfLsynW08engdBy2/kjKC0JxuQYT+xefVTAYV1tmLCi8ZEL333ZE7eruQ0owuUmiufIAVggOxwT2GXIa+jtPvfeBKAUXFBs59etrOzx4XBsP5HbXDTKWzItwY+EZ16qOUygT3HEXNFyJk0favL8kqTcB+NNtmh9iK/lIfh+PEGMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2BCbHXFYeqwBA4U5rgoNiZvvrCZ2xPPKJSxut6nFTM=;
 b=qrZ7NT6rie54aG2/6nXpHemiwMmMtidI3+9aLbB7w3RXbIIfEK1frD/8Bu35vz0bCkMsoyq9ryhngpbHtuDq/90Wvot7Q2JG6s72N9A6p9utQoQTy6+PAm1sbzdENlWsZNU0qNYOY6imz4EUCbk/p+bLzkZpe5C29d0mPncQhMBCAqeutUTh1LQwUnDykYeOA4+cIUwOflkBJBNOmB01sZtHTNrv9UznSUHmpquEkvGnWwjh+BwQJrTB02xgasZ4hPuZy1C3bUFhqyKGO9bDth3yxbZB3TZRFF58VlK7uvvwsuegd6A8GOulw+bb0nVuhjd8oTyLA6ApRpF8g8lEkQ==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 CH3PR12MB8404.namprd12.prod.outlook.com (2603:10b6:610:12d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Thu, 4 Jun 2026
 08:14:17 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0092.006; Thu, 4 Jun 2026
 08:14:17 +0000
Date: Thu, 4 Jun 2026 18:14:05 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de, 
	dave.hansen@linux.intel.com, david@kernel.org, kees@kernel.org, mingo@redhat.com, 
	rppt@kernel.org, tglx@kernel.org, linux-arch@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v4 0/8] mm: speed up ZONE_DEVICE memmap initialization
Message-ID: <aiEoByaQdRR3xtM5@nvdebian.thelocal>
References: <20260603080152.64728-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603080152.64728-1-lizhe.67@bytedance.com>
X-ClientProxiedBy: SY6PR01CA0046.ausprd01.prod.outlook.com
 (2603:10c6:10:e9::15) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|CH3PR12MB8404:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b08a133-4316-4d9e-19cd-08dec2114552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|6133799003|22082099003|13003099007|3023799007|11063799006|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	tFKuR2pvWD5mkQJcjkR5H93juAJT4rQE8CO62fO0nx6K+uRdjSXWL7tP5kmfiA8l8I/vJBwHQbFlSJuh/I1ST+Fhqnjhj7d4ZXfXuhH4BWlo7UsipXp8IPRw9SW9lIhrJZphTnDAoLCLAKGWeyVWcGsOWzwCNKiDKPMZPRqDt2xWtfX3owwO30h5P660Sn/x3yTiBh0mZGS8O/rqVLM/doPsH6mYQrq82S9qqbiVe3cejXK+Xx3ONtyuptuYOSjkEEko5HaCZLvdNcSCqjfbO85RXqQxkh1kTWhGBbfNksAvRGN4hPhw+We/RGlENEhadL8sBhFcAko7aCCv41X8QA460ixJzljGs8pkPkbJRfCjlxLtvZBK4B/hfMh81biZjQa75/5YjWrAWzs79QZqF1xKm+GZKlkkJxx3sSnMyoXK5LDtK1PBzFzC0oMEZ1QP9khIxj50oTe3FsCIAu81CMDncqe1IMaYBHyWg2/d9cdbS/YePhUXOKQdcRMvS2T3eWE97OVG2IBSWbd7nmaASJ7cRBV/XLHSgW1qQk968vAytNml/+7htw0Om0Tg1baZnWA1SDBp3Me2E1oyPU944Jgx941vez/k+vW6utuVlcbrTpH8EWNxxKta2jOtbA4wv0Yw6dLMSTfXYM4/m/rEgoA0vGjCTgcp6t0xHXQEhaVVLW3atXMpRCdkHV+RA/7lmSve/MHgXU2IHhixqKBXBw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(6133799003)(22082099003)(13003099007)(3023799007)(11063799006)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iP9YPVUpawVfq5oighIGBDyMMjuMeFFJKyaNwiynE4HClUcdmyBTAl6kCRJu?=
 =?us-ascii?Q?2O6540XTYjUSKS0HqjPGwGTAWnCbOg1pOA+xK3mkhOWZrygQSuxUh1yrZxFt?=
 =?us-ascii?Q?9fzNRDd+KE/zOMKfVy4CUedclT6A10coJK3RH8OzTJwz1mUiOVfiY4YCCpUz?=
 =?us-ascii?Q?jkR+vesAwNWxj92jHPqPa2za20ChZOlPnOcrIPaeJnnUrYGDOskg9Hg1PBbh?=
 =?us-ascii?Q?zCgHYE3voNab3NFYtA8h5Bt+NE9KnJevUBo/mhA4vZij/BZyPl8MDSSeaHao?=
 =?us-ascii?Q?bdyzBfIDFitg2KtQs1/IJM/wcHGL4RH+CWKNwnkoa8jao4MyTsDMRT65EFXn?=
 =?us-ascii?Q?NQb0IeNL8uzAwcIcarspJJfvrlCjQbcMfDcWysUa81BKsqjXiKHGFD01dHlI?=
 =?us-ascii?Q?VYDwcHGOZ1HPQQF+9h6qrx3CvyPu03Qz6ORc7G2H/uKKGoddpdG5sBwIlOTi?=
 =?us-ascii?Q?Ca6olqAYg/trAWvyKbPDzQq7/m78C1UCreYUbxDHGjsnM9LNwFHUeJSk5Wut?=
 =?us-ascii?Q?Dtenz12yqttBYWI4qli25Oh1JD0jdQ6Lc/33jNvvHhKnYenEm9QJBagFaMcc?=
 =?us-ascii?Q?dr2JjR3OKMyyeoXZ0C/dkaY6RpAFWpuflNfGHCPBTA3YvU/S6clvJ9XTNgT3?=
 =?us-ascii?Q?HCxeyBN3eF3fwimoICyXuzIyLSPCtpl7gcLQwamIZbEzvK8G0u8FncdmZkvE?=
 =?us-ascii?Q?HRGP0itungtaTeF2e5asB2XnM/de2vc1S//onouJHqQMZCXbAqq64TZtbIUs?=
 =?us-ascii?Q?kr6MfP9WeUzpw+9h7UtD+s/SU/a9kSj3XgHsMlDE3/T17LELYtH49aYzMwQU?=
 =?us-ascii?Q?cj+etwDSQ/EbqLnuqqfRvgMalJtnrErqIztUIsGOCxmAvzz7R3OhL26B57V+?=
 =?us-ascii?Q?VUPyD+y6fKH1f3h0g75/qGpE+r5PhDpRt6EInFUkezXMXHL0c8CvfiZMIwjQ?=
 =?us-ascii?Q?Y6tdhbp1jbTZ7gQ6ZFahFPu4XKD9AYtfmDVAZHp+UvMUNw+BNoZKTh4oKcLu?=
 =?us-ascii?Q?bzoHuxcGq6woQLJY3jlPFvhUd+UjDnrd7MFTEHI0zjfoKvxe+6HZAP9qci8S?=
 =?us-ascii?Q?4z3DxxRRX4TNMBK5+F1UDlpb3SXkKFeolaYWHc1JiNPo/jtp0Em8eggfKode?=
 =?us-ascii?Q?Z9m3SEwKwXpt8r0A45JP1V67/R4SOqJwesJVZ7UjoNdRxYf6JhHXyDQ3KkP7?=
 =?us-ascii?Q?9QMjb2O01Vk3BhApo1eUUeG0EfOdb1ZvtGiBRGkG+7XYwny/CDgel+wf2Lz0?=
 =?us-ascii?Q?+syjxmmQnZQZi1mMa2fpmIF8MJpvtbbn/tOZwDNF+F0r9L1FJ9JWwGtoYg9e?=
 =?us-ascii?Q?iipHeVXSLlAXPIM8Hl06a9qjX7iSuijg3wzS4zYr/DihBUB/uo4XgaSx1s2b?=
 =?us-ascii?Q?VOR2P0gkRKWwkUNO23mtw4aqpUts7mvs2uTEq9M96LHi/Y9RKzidTrJuWfyp?=
 =?us-ascii?Q?fvLeQY8tLpSOuntEQApXVpGQJWGIJiIYyYmZywfgAV8h0gZQa7YHRJlKW3nd?=
 =?us-ascii?Q?pxlB7eqkZ1esSbv6wLQEB6SI7bvsHoBx4/a2QaZO38mnWMeLh+iW6TVgE03X?=
 =?us-ascii?Q?PDZhXtgltcFhWzE1vydgxYUS5iz31uqqwDRdxb8fj1prcoxLyn1faWlzmQRU?=
 =?us-ascii?Q?/0gwVnyar8iunb5GlPrHH0ytc13N8hEIQX5TNylUvNUP/drxzXfKAYXd1dBn?=
 =?us-ascii?Q?dp0H+kbCj/vQR84X2bW4HwpY84jOANhWBxr6QcA3H9F9xarfFQP/J3kCIG9b?=
 =?us-ascii?Q?4eepqqfxgQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b08a133-4316-4d9e-19cd-08dec2114552
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2026 08:14:16.9839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzHhLcpS6H4wTUiNxCa1EPFchbM3nBh3xfdjgXbSFfy9nWfn10vLZXMWn4qdFJqQuTIAucNU6VNkHmMBJwuWaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8404
X-Rspamd-Queue-Id: C378D140008
X-Rspam-User: 
X-Stat-Signature: hdbn3rg7dsik4chz3f4sb6hnaiw6h7ps
X-Rspamd-Server: rspam08
X-HE-Tag: 1780560864-972386
X-HE-Meta: U2FsdGVkX1/03Whc5IbSHtFqmKkV/YElqkeLvhqxmBgxzS7G+C/k/8WtMW8vo0Uaqmb5zIbjzJv53tCJFSdUttmXcE676xMknjtkQpZJceebMmB+pGDo8fpfr0P39OEyvNKqAIEhTTwTbn5tgJPKte4Dkt31K8R2eq8cw+CTgtjlyhMLvyqJdGD4mgnpniRCqN1mLHJSvOGYCZPryH2EnvUpRCFW/s2Pcq+XCN136D7NqvG0Q01BfeTgEhDvZeQ4yAPxrGDYxm1hK87agSBnLbFupiqTTv713Mcq6siG0Xa3vLiGOcjRtLhzammJ3XRASY/WVsL1WOreND8hnVpvnw0m8ZRxGWmk+OmfBUPZieFycnABnrIe8cD/9VKnhfqwwtn6WPD5+R8FY8bbkSSN9/g1AMxiI4VVP23vRJK0O5jQGIOEBbojai82YKP/U+C9WiQW431GRr3OZIjThlMoQSXUCZJEcpjecGXshWBqwIvY7y5scFjNyD3xKC2r5tIKeCOQPKLiiC9tQ/LqPP5YAFNPvF9CzJIpLHV48V/y9AXkOtLHHbKWzYzVtsj6/IdUYAvwXsdnpwIYPJ7dvxXxQD7wyjGj5Y4F4D6JDlEcTKuOPZV1Idj5khgdhDWQjQQRCHxHA6rbadWAmCzrRf/Ff1ZIfhKR/KOPdXrK1Lld3MiH+/T9S5dRSdmtsc0mGIFZuYow5agTVhcaYpG/c14TFPPNn0iI34bPCdRYME7/yAe52KHzlPjlmvroUjlfg60kPoq7hcuf0TY0E8o48ld6i9m8eTCHDGWU335Z0iu0aqazEOg9smPzC3NY+YF9WhkUe9V8wAIwGZaokqufdnuXNj/yF2DQWjlNdbVTUqvyNXIsWO3ShQyu9seuzEqeemvSED9Vv8z7fQw19yVtOKIOQzqbFEwt82GjT/yoDWV9PpNUseAtJAwhHKOte+qoGaczBNC8gQ1Bz2ji5E7Je4V
 d3KvIeqg
 PtRt/HkZf9XOIuYQYCthMiTmaR7qnkeCXAl0c7+OWV0jkVJhlGXOvrNpcAS8+5ij3j34Am1FTKeuS1hj24SbcOIDo3U5F/z3rRzoonZSe6OAV1X9D3rv3yF2Y1GM9CEHSDOhf1BXrBa41wboLRKNw1jPuia6PD8IeWFPpWDEEXiCq8mzsHhuzW9SlWN3rQt3SwGg7OkYvKCAPPwBOG4asXpoffCzjJG2duiZVCSLf4nhDnkKKAdKZ5xMzu6ExfyfD+TrAKSIJMIUeFFQMhE+cvoXN5fJWP/RsUlu+GnE1fzKaXcpDqVL+lyYa+5MofHpcCb6ry6E5OJV3KVeeBZ3mjsjDnDuLzgbbEVD7qjcnsfz0TAmedsxJjtq3OI4cUCIFjhLccA88REhSwaQ9owhYTk9cbSdGiRQTV/sL+Yy889N41S042/AwRATZbdVu0yCtO6mdwIOLEerlSi65dyArmDoPOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-03 at 18:01 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> memmap_init_zone_device() can spend a substantial amount of time
> initializing large ZONE_DEVICE ranges because it repeats nearly
> identical struct page setup for every PFN.
> 
> This series reduces that overhead in eight steps.
> 
> The first patch fixes a stale comment in __init_zone_device_page() so
> the documented refcount policy matches the current ZONE_DEVICE code.
> 
> The second patch factors the reusable pieces out of
> __init_zone_device_page() so later patches can share the same logic
> without changing the existing slow path.
> 
> The third patch adds set_page_section_from_pfn(), so callers that want
> to refresh section bits from a PFN no longer need to open-code
> SECTION_IN_PAGE_FLAGS handling.
> 
> The fourth patch adds a template-based fast path for ZONE_DEVICE head
> pages. Instead of rebuilding the same struct page state for every PFN,
> it prepares one reusable template through the existing slow path,
> refreshes the PFN-dependent fields in that template, and copies it to
> each destination page.
> 
> The fifth patch extends the same template-based approach to compound
> tails, so pfns_per_compound > 1 can also benefit from the fast path.
> 
> The sixth patch introduces memcpy_streaming() and
> memcpy_streaming_drain() as a generic interface for write-once copies.
> Architectures that do not provide a specialized backend, or cases that
> cannot safely use one, fall back to memcpy().
> 
> The seventh patch extends x86 memcpy_flushcache() small fixed-size
> fastpaths so struct-page-sized streaming copies can stay on the inline
> path when alignment permits.
> 
> The last patch switches the ZONE_DEVICE template-copy path over to
> memcpy_streaming(). It keeps pageblock-aligned PFNs on regular memcpy(),
> uses memcpy_streaming() for the remaining write-once copies, and drains
> streaming stores before later metadata updates that may depend on them.
> 
> This is not intended as a steady-state data-path optimization. Its
> benefit is in pmem bring-up paths where memmap_init_zone_device()
> dominates device online / rebind latency, such as:
>   - fsdax or devdax namespace creation and reconfiguration
>   - nd_pmem / dax_pmem driver bind or rebind
> 
> In those paths, the kernel initializes a large vmemmap range once and
> does not immediately benefit from keeping the copied struct page state
> hot in cache. Reducing write-allocate traffic in that one-time setup
> path can therefore reduce end-to-end device bring-up latency.
> 
> The optimized path is disabled when the page_ref_set tracepoint is
> enabled, and sanitized builds remain on the slow path so their
> instrumented stores are preserved.
> 
> Testing
> =======
> 
> Tests were run in a VM on an Intel Ice Lake server.
> 
> Two PMEM configurations were used:
>   - a 100 GB fsdax namespace configured with map=dev, which exercises
>     the nd_pmem rebind path (pfns_per_compound == 1)
>   - a 100 GB devdax namespace configured with align=2097152, which
>     exercises the dax_pmem rebind path (pfns_per_compound > 1)
> 
> For each configuration, the corresponding driver was unbound and
> rebound 30 times. Memmap initialization latency was collected from the
> pr_debug() output of memmap_init_zone_device().
> 
> The first bind is reported separately, and the average of subsequent
> rebinds is used as the steady-state result.
> 
> Performance
> ===========
> 
> nd_pmem rebind, 100 GB fsdax namespace, map=dev
>   Base(v7.1-rc6):
>     First binding: 1466 ms
>     Average of subsequent rebinds: 262.12 ms
>   Full series:
>     First binding: 1359 ms
>     Average of subsequent rebinds: 108.36 ms
> 
> dax_pmem rebind, 100 GB devdax namespace, align=2097152
>   Base(v7.1-rc6):
>     First binding: 1430 ms
>     Average of subsequent rebinds: 229.12 ms
>   Full series:
>     First binding: 1273 ms
>     Average of subsequent rebinds: 100.17 ms

The results here are impressive, but I've been having trouble replicating them
with hmm_test on my local development machines. Both an older AMD machine and
a newer Arrow Lake based machine shows ~3% worse performance with this series
applied doing ZONE_DEVICE_PRIVATE.

This is based on measuring the memremap_pages() call when inserting test_hmm.ko
in a VM using the following hack to measure 10 64GB memremaps. Is there an easy
way for me to replicate your results in a VM? Or is there something in my
testing that I'm missing here?

---

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 213504915737..a1d5463dbc86 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -34,7 +34,7 @@
 
 #define DMIRROR_NDEVICES		4
 #define DMIRROR_RANGE_FAULT_TIMEOUT	1000
-#define DEVMEM_CHUNK_SIZE		(256 * 1024 * 1024U)
+#define DEVMEM_CHUNK_SIZE		(64 * 1024 * 1024 * 1024UL)
 #define DEVMEM_CHUNKS_RESERVE		16
 
 /*
@@ -565,6 +565,8 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
 	unsigned long pfn_last;
 	void *ptr;
 	int ret = -ENOMEM;
+	int i;
+	u64 t0, total = 0;
 
 	devmem = kzalloc_obj(*devmem);
 	if (!devmem)
@@ -613,6 +615,22 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
 		mdevice->devmem_capacity = new_capacity;
 		mdevice->devmem_chunks = new_chunks;
 	}
+
+	for (i = 0; i < 10; i++) {
+		t0 = ktime_get_ns();
+		ptr = memremap_pages(&devmem->pagemap, numa_node_id());
+		total += ktime_get_ns() - t0;
+		if (IS_ERR_OR_NULL(ptr)) {
+			if (ptr)
+				ret = PTR_ERR(ptr);
+			else
+				ret = -EFAULT;
+			goto err_release;
+		}
+		memunmap_pages(&devmem->pagemap);
+	}
+	pr_info("avg memremap %llu ns\n", total / i);
+
 	ptr = memremap_pages(&devmem->pagemap, numa_node_id());
 	if (IS_ERR_OR_NULL(ptr)) {
 		if (ptr)
@@ -629,7 +647,7 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
 
 	mutex_unlock(&mdevice->devmem_lock);
 
-	pr_info("added new %u MB chunk (total %u chunks, %u MB) PFNs [0x%lx 0x%lx)\n",
+	pr_info("added new %lu MB chunk (total %u chunks, %lu MB) PFNs [0x%lx 0x%lx)\n",
 		DEVMEM_CHUNK_SIZE / (1024 * 1024),
 		mdevice->devmem_count,
 		mdevice->devmem_count * (DEVMEM_CHUNK_SIZE / (1024 * 1024)),

> Li Zhe (8):
>   mm: fix stale ZONE_DEVICE refcount comment
>   mm: factor zone-device page init helpers out of
>     __init_zone_device_page
>   mm: add a set_page_section_from_pfn() helper
>   mm: add a template-based fast path for zone-device page init
>   mm: extend the template fast path to zone-device compound tails
>   string: introduce memcpy_streaming() helpers
>   x86/string: extend memcpy_flushcache() fixed-size fastpaths
>   mm: use memcpy_streaming() in zone-device template copies
> 
>  arch/x86/include/asm/string_64.h | 140 ++++++++++++++++++--
>  include/linux/mm.h               |  19 ++-
>  include/linux/string.h           |  20 +++
>  mm/mm_init.c                     | 221 +++++++++++++++++++++++++++----
>  4 files changed, 360 insertions(+), 40 deletions(-)
> 
> ---
> v3: https://lore.kernel.org/all/20260527033636.28231-1-lizhe.67@bytedance.com/
> v2: https://lore.kernel.org/all/20260521040124.10608-1-lizhe.67@bytedance.com/
> v1: https://lore.kernel.org/all/20260515082045.63029-1-lizhe.67@bytedance.com/
> 
> Changelogs:
> 
> v3->v4:
> - Rebase the series from v7.1-rc3 to v7.1-rc6.
> - Rework patch 4 so the reusable head-page template is seeded from the
>   first real struct page, rather than being initialized directly on a
>   stack-resident template object. Also add an explicit !nr_pages early
>   return. Suggested by Andrew Morton.
> - Rework patch 5 similarly for compound tails: seed the reusable
>   tail-page template from the first real tail page, thread
>   use_template through compound-page initialization, and reuse that
>   prepared tail-page image for the remaining tails. Suggested by Andrew
>   Morton.
> - Tighten patch 6 so memcpy_streaming() maps to memcpy_flushcache() only
>   when the destination alignment and size allow the transfer to stay
>   entirely on the non-temporal path; other cases fall back to memcpy().
>   Suggested by Andrew Morton.
> - Rework patch 7 so the existing 4/8/16-byte cases remain handled
>   directly in memcpy_flushcache(), while the new aligned fixed-size
>   fastpaths cover only the larger 32/48/64/80/96-byte cases. Suggested
>   by Andrew Morton.
> 
> For changelogs of earlier revisions, please refer to the v3 cover letter:
> https://lore.kernel.org/all/20260527033636.28231-1-lizhe.67@bytedance.com/
> 
> -- 
> 2.20.1

