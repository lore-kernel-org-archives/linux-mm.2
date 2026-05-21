Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09A80CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3894D6B008A; Thu, 21 May 2026 00:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361706B0096; Thu, 21 May 2026 00:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24FDF6B00A6; Thu, 21 May 2026 00:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 14B296B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:25:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75BEF120502
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:25:11 +0000 (UTC)
X-FDA: 84790137222.03.5500FB4
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011035.outbound.protection.outlook.com [52.101.57.35])
	by imf06.hostedemail.com (Postfix) with ESMTP id C8328180004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:25:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=q76hCqbQ;
	spf=pass (imf06.hostedemail.com: domain of apopple@nvidia.com designates 52.101.57.35 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779337508; a=rsa-sha256;
	cv=fail;
	b=cl5FMZCOcuP44Pmf4l8DKHGXgL7b6qG+tel1pBeRg2zGTI7C2EksR0dWs7PKCrGBAgAKN3
	wzcswxeXn+1nLX7sTV+MtBR2jeePQWVP2h5l0n9u4Jek0n8wMCsLc1CXgQy9ZV33NRRlmF
	UMfYrb5+aQJ6mLXAh5433tS3iJ7mJrE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=q76hCqbQ;
	spf=pass (imf06.hostedemail.com: domain of apopple@nvidia.com designates 52.101.57.35 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779337508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R2jeQp593tQI+raRY8n8eSHWl4GbwSn6C6eo/IUr1Co=;
	b=WJ1Lwh8Rnht73MHgp0+NCu07d/7oTrKCX0FqLaGaTdTQmIpT8Io8UnlGlDg8HQoidW7Zgi
	ugtQysWWR1sfhuk4WtMlGs9OFW5EQQvYGXJ4j4nU7cRpUHp191DcRwuGUvVAD4CsLvo3mR
	qIoiedrLSIVELfCK6lBTEHYN3s+i15w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MC3y+fc43v9oDeEevyicRx8525/qJvUVVhhjZ498ApK9PIN6h9VqGn7n4FRZBpihaUg09PcJGFevr6u5QPMUXVx0Um6SyLveEn+9uYKo9zw0j3OnPDVfQgoEcHBSok4pjTVluzLPwMnCC4MWjxSxCMRJ6MUBwLprEpI79KdnWvl+jqUe8uH6V/Ih2dgQu7ZAHzh6ycxSjPB7lYIWxjz41xqjnr2esrFLJPGg1eBnm0vJ/WW/fqj7wMLq/vRR1mYIIiusaqtiMx6zFN+FnDmjkJjgvCiuPoGQRW3nf8KjQKyYf6N8ZJ68RNbU7s+ISIVEsIWCPpY6eX47kc6DU0fDIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R2jeQp593tQI+raRY8n8eSHWl4GbwSn6C6eo/IUr1Co=;
 b=CIo9gR2sE3/Xcx+P8QaY67HrS8/g5ekFKFenYulE4m/3XCZA2x4h08TTxh2K65ipyzCZSrLWox8gSlggbLedO/fcSClGFozy1U7SrxW8E3Ns0dSlibMPKp2/1/hMO/4JIy+aNGRfRAHRULlp996xz5EW+l0LOHtzf7vlQHZ7DRcnCJa8zs3xtQcGpMLGF43nuFnroz6p3KaV5YtTbcxnw13YDnVkJ6egxn+qumj9Dmyh/u+2Oup52OjltIHA25+sBroNRqXkDikNPmvUNRL96Rp/qMDCl4jTDnWVgaoDYhdgRtT/qAnBH13hMOCt9Ko6SaK2TwxQLqmThGvTp5D2AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R2jeQp593tQI+raRY8n8eSHWl4GbwSn6C6eo/IUr1Co=;
 b=q76hCqbQXoFt361Bgd4xVHK1oTPno4mRdWvteVKR0YHdyMlRgw6V445t41l4H2J0LXwBH1PTKOH5D1WIXAKg3gYNcltEOec/Tha7Puw22nPxEnI/RLGc6QwO8tXtsJzTmPxYVu6R1zUSgE7CeVmnUp6zFg5g6JJRg58YKzd6mPqrKGLg1eRKym/GGLEkzMPp6D6P7JR8okqkAixNWjpFZwiX4DrjI36tBTIOV4JY6uN7JjQruuqiMusf9WniVkMAcsYSyfiwMrJZEiBGAvFgaW6mPSLqE33ZyRJOlN1gsrTSDp1ciRZ/6p6cBgfvHRekH6LT/tdZ1qx+jMY2/KiZRQ==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 SA3PR12MB8022.namprd12.prod.outlook.com (2603:10b6:806:307::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.16; Thu, 21 May 2026 04:25:04 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 04:25:03 +0000
From: Alistair Popple <apopple@nvidia.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	david@kernel.org,
	anshuman.khandual@arm.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	balbirs@nvidia.com,
	jhubbard@nvidia.com,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH] [RFC] arm64: mmu: use range based TLB flushing when hot unplugging memory
Date: Thu, 21 May 2026 14:24:26 +1000
Message-ID: <20260521042426.2128731-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P282CA0169.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:24a::11) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|SA3PR12MB8022:EE_
X-MS-Office365-Filtering-Correlation-Id: b46be326-14c4-499a-74b5-08deb6f0edcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	ym0YtS50Kl9k+iG2unwjgofQMKaTIh1r5p15HecbXMaJYZxM2h3i/DKb0DYT2l+e3KoSENy992ei8UjxcE3Hp2X/OzM1k9vgIzevQ1GXHLO5AX2AylXGCu1H48bdp5+KKiJXkLFuHYyUPZJsGIlXl9PA4ejb36V42caIjrdluWynVoWH0sXaTtRqD4+u2vQlYXwnIX311fgDi1lA+cpRm/mc6rWjKnJZLUeIc8lcjUjzHTMhFVSV7WJd2aMIuwgVA24SGLGUR8gCaYn5iepI+jwcmWC6F4JYfYOqClXIuWxEmXffHUTmqm7b3Ww6UJl0RaoJZrbcVSwQjgAfEOchJkU/j5b0fzeNlvVRQS9XuL7Lb4EpxeFl0OBu605UJJq3PImGOZYxT/hzAAk9vrT0GYfAqB7JovDqqB8RQEnmw2ZrtFhKoK1FDA5EBpjVgHsqnNbvpRACRV32vfqzRtj6ng8bNN59SmSwOIPWe9Z/vdHwTDJi3ljrVVU9Tyv84CtUZJTbOyVCvK7YeVccLapMkF6uT2N39bhh3SX4fEzbw5XMTHnUHlqVVYomEj7OWfGemKSDHl/zby4QawzCF91aPEGdv2ow62qbvm/mmh4ij8MrgqJv+XakhOiHpBQvMnSXHXm7ZhAPCVyMQvV4tV1Uap2+m7ctELHjLLq1Xwmyb//5VcztkDRnacu79ijWLs/2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+ydSm/uPEwH+nYE2o0Q4zn4vN2E/WJA3fpf7gXolAMVspBA2AA4iRVsgf6py?=
 =?us-ascii?Q?TBmbYVsOd5c97orMN+G54JJyvcTmgMtC7DXRCvSShwc23VfhKUJC5U3QFhd5?=
 =?us-ascii?Q?NSbLR2boBNqMGBDliGfsd6Tr1ZawcCDkMVAwDPXwC7NhlCKW9k/VSuRhF9NT?=
 =?us-ascii?Q?+Njpm65TPtQrmhLpZ5EApXVICjEnkHGU2T5C+W+ZClR/bwgB4m2uM/4XlUWM?=
 =?us-ascii?Q?6MTV9YjUEokb78VktDCx5LNpsC8DHDBjPBf/T0Sc9qtaoyeSXo+lckooVdnm?=
 =?us-ascii?Q?sx3Y1fdhdVJWaagXye4VSCjfTfCSilhVv3vQ+L+PzKRHF73/EuUgJ882scXr?=
 =?us-ascii?Q?Hl5r1GFWJldFDGVvRD8s9Jbrg3e5t9DLPCMiZxZd6+7T1YjCutohyv/WMNlp?=
 =?us-ascii?Q?NZhWdKzxtKQRBcduoSsDPjGRz3zbHqPAoUnj/GZQmUkLYhNm4WB/nqnemRJV?=
 =?us-ascii?Q?UdmKVECzaG8VtugcTgFRgZBtLpVVEUbg+Sy2xv/XJ48KV6+2TM647KsGojuo?=
 =?us-ascii?Q?IsFEDrD9leTKxh4KE6g7o6TOAwrJLz2QKOO8bk5BdAuBFCcgi6Dk55Kghhit?=
 =?us-ascii?Q?ZetlSzIuLP/YG8dNh9zMbPSZZV0AF8ajMPuRiBI62RG4U7h3Sd0sImhw2pgp?=
 =?us-ascii?Q?/Q8EsS6NJ5lx3X79MD6eqxYO5vQ54lCgzp1XvUZ1NR2sOXtFTMr3DlD5w78w?=
 =?us-ascii?Q?lPqcciv6pHOcqdQm8DSAehuu4eBlytn4hW+3twvFQxwd46l0udVvujssA2pB?=
 =?us-ascii?Q?FfWKVEO4GoDzct4nh+PtrZZX5KV+CJ60WOJLXsA9v38ECo4K10xBsBy+wC8M?=
 =?us-ascii?Q?ncS5zgnwpKUzVnanVFiQFVwREYt4UYR+AvsoJYM3w9Vvcsa/1yUpLfKb60oX?=
 =?us-ascii?Q?Xi+b03PcP/t/LWq4v6e86YP/TgscUyw2UF4+fZQhuseiNg2cqDXygIqLapp+?=
 =?us-ascii?Q?Pd2EdpV4eDNHxK0KHibjWGTt+F6ciofVa8FACqr8MHfBFHb4BKksIirWL6Wq?=
 =?us-ascii?Q?YuxM9WRT1lgG4luiqbEmvtsOjx08E40loR6d0H5EHPrMeiVYhqgbutiKpFoq?=
 =?us-ascii?Q?2XCXBFSWjDk4C6H4blTtCxmNCdcDs6S2iDsK0KH/wDZjmGwkZr7E74xgW6s9?=
 =?us-ascii?Q?TssIlN28ai+U59ha7wvAfu6hudLHKPKjdGeLFhXXmkt463apPjCn/+0iaBYk?=
 =?us-ascii?Q?luTQkxMd3pEws06QhkcWhbtB/8Q620JbJD1tofnrXNSMPw9XwCGf9cPBT2xA?=
 =?us-ascii?Q?dg6jsT64d5ZU/2maxwz/bjNouSH9/wm2OPFYkA1+AGD7to3PetCuAw8r+KTV?=
 =?us-ascii?Q?2e+OXPwLKBpi5mIxT465nw+to7Mv9C1nUfdV4I0FWIreLupuUGRzQphZMG1M?=
 =?us-ascii?Q?Qazzs3AXenstjAzhiO50BBtnZV7BIoIfNMjAgZ+1PDn4KhvFdhkGsmkuMche?=
 =?us-ascii?Q?oMGasSsHNGoasLhZ5+ztNiBtF3+2HfOSS54O7ZmyWCSmYa7HHVj7ExWhbdPP?=
 =?us-ascii?Q?k3KtCK2cU1yI5jd0qQX+5BXjNyh62Xu71i64UabFtBmyHVTGJ4tnxC9bLhGV?=
 =?us-ascii?Q?nx1hTqjFwPVDB+r6Go9TxYSYyhXC283i5Nx98XQTC1jiKqKXSxT5pdpSreF3?=
 =?us-ascii?Q?8Nzid2PGeDsNhnuqfiEUIIo0J5efqLoBj2nmFvTthaCSnX1j4FQ3ZRN81wj7?=
 =?us-ascii?Q?wz63zEhufC47oWbYD28J0ZpbPzv3HK7DydMVIYCksRdNK2RLh8SJiXsC8l2I?=
 =?us-ascii?Q?t8NfXT48hQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b46be326-14c4-499a-74b5-08deb6f0edcc
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 04:25:03.2890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nydznYeHvUOivmyAQ+gpJZ2Nqh4cUJmTptGFTEWl34i07TOecugcFYJDHfGpRd94YimYd13qonJdPAjZMMd0Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8022
X-Rspam-User: 
X-Rspamd-Queue-Id: C8328180004
X-Rspamd-Server: rspam03
X-Stat-Signature: f7chiacx5ns75pge3w5m9ket5ojx1b8t
X-HE-Tag: 1779337508-660890
X-HE-Meta: U2FsdGVkX18mOT8HDWu0I9duPSSnaawgTwzkeXoYE0dUXbiRQb346ISjDBgxnVeb80hYYjjJwYcfVRh5QTWCWddUfTpzgHaClaT5oVbbvdgE8XRSr99OXLSvMk0cBuAGhoEBY5qLYwDkGrnfNGL7QdFQgBpt8ePmpLAJq2WXlmKQT+UEoPm12qaqpbD2UnX1osZmXx57/mpyJhcPeyYQkjxVpanVF0+EsL28PFxK1qqYhRsZcwbnQT+wHZxIPJV/hS5T7LWYs64wAPwDJpAys7RkGa287LYTM496RJOeA6U700ony5n+DXBXCHMoqgCC0PMSJWYmCLjllDYA3qWWqgDzg+D55+IbETgdSCzx98yT5FK0y1M0xzzPHndC3r9qY0B5ZK00vcaQmxFSnZDv3QPQ0q5px5/w9LycQEnvYY9SaEv5NiROvBta2dhjsvRCQdio+DugjyEUlhMt2sapOpUjHqGAtciWQ4cLtPtdSQyKgF735RSjwoDL3ZM6UV5NhUIndLeoLj7kpDZu1PsT2QqNS5NmVVGuJirgwyxvP4SfixYzpy0e/JcJVTlEeXOnSS9G35vtiBIb4frR3Gdy86KgNt57jsbCjFQvITIp3H1akW78I2bH2f/SYDQ/DtiEZrfbfGFc8QXvRCE/R6lN4JQwIoQP9h5m0BM14ClhHvq1uQNtaAPyaFEavA2rIaGcyJsGNzXk1TKL29iNRxYib6/bi6kCwijudB7y9YbwoFG1+6Wcq3wRGmRyiqcWetnXgus4Fl/etBcdK/oRqTS2SyEhjfahsesfwWv1/jBSOtudW0F/O/jFp1DXzJS2euvlWyGcrhu3haT1UuJogJzR6ar1WphvrHtbk2Fm0UCb1AWNIOWvyJfw/oUbL7j37IEbJ2DLv8d6/oQOSkt1DqpNen1UqLGPPdlgYu5+EC6nkaMUwk3tLlDId2Z7XX8wR9wlzEiS7dqhCMAUQM030Yk
 pSaUK2+J
 C01XbWiqKn72Q9aJfm99ymGnC4iOSzOw8mGeLBQ2bZS92uzXXrzOAfALEKuM5p0t9uTJ8M+mkbOudHij5vnu7eytruvmpGOWpxks36+cZTAR94yyyJ4Fms7NrwvOap6EGzIdNW8AQXW0bxNrPF52r2hvudCAY0Su739XNZoyhKQ+i79QKlX2dCJojiEOT7Jf5CbELKma+Vb1SndcpEPmHv/lgjmRye4Xr8iOyr5AyLuigY6ais4BPczYqP6g5O0dbqnC51Abq3kOXv4uXQRC5QGnna+0F4kh/jvY77Lh6aVviA6pv0iHOpAR0BzofJOIGyrBGRYyt+dHuzgHNtVG+BmNK8dc4QMpG1X/pZ3uwkObDRFEHuse1rLNgW5n7nQQ96FniXVmk9jBNUq8SxAQJfD9HPnU9MgQ5ZYwNvcgLi60qxKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hot unplugging memory on ARM64 requires a TLB invalidate after unmapping
the page to be hot unplugged from the direct map. Currently that happens
one page at a time, meaning range based invalidates cannot be used. The
result of this is that removing large amounts of memory takes a long
time and in some cases can trigger an RCU stall warning.

For example on one system hot unplugging 480GB of memory takes ~1
minute. With this change the same operation took ~1 second, a 60x
improvement.

Signed-off-by: Alistair Popple <apopple@nvidia.com>

---

This is an RFC, because I'm not sure the change is correct as it frees
the PTE page before flushing the TLB. I'm not familiar enough with ARM64
architecture to be sure this is safe, for example I don't know if HW
can update PTE bits such as access/dirty in the page through a stale
TLB entry.

If so this would open a window during which the page is free but could
still be written to. Likely the safe option would be to collect all the
pages to be free on a list and free them after doing the range based TLB
flush, but wanted to get feedback on the approach before implementing it
which is the goal of this RFC.
---
 arch/arm64/mm/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 0c24fe650e95..75c773232c14 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1459,11 +1459,12 @@ static void unmap_hotplug_pte_range(pmd_t *pmdp, unsigned long addr,
 
 		WARN_ON(!pte_present(pte));
 		__pte_clear(&init_mm, addr, ptep);
-		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 		if (free_mapped)
 			free_hotplug_page_range(pte_page(pte),
 						PAGE_SIZE, altmap);
 	} while (addr += PAGE_SIZE, addr < end);
+
+	flush_tlb_kernel_range(addr, end);
 }
 
 static void unmap_hotplug_pmd_range(pud_t *pudp, unsigned long addr,
-- 
2.54.0


