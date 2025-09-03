Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A297DCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 18:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069E18E0007; Wed,  3 Sep 2025 14:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0412C8E0001; Wed,  3 Sep 2025 14:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4B2D8E0007; Wed,  3 Sep 2025 14:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC5DA8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:25:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C3B386785
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:25:22 +0000 (UTC)
X-FDA: 83848766484.07.3C6C3D9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0EEA3180012
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:25:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Z1rKlLfE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gVRod7TQ;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756923919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQ/jDRyP0zgUu4R7Hz4iF5ffyqCjw8z5KbVkBYy5UhI=;
	b=Stdvzc+ky35oMcZFq2JP5zzBevSVadewTFSUaKevxHLxppG19EFj3upoZpn4KLQq3F998X
	gW6IWCdepD+SjuLM2LYu39msslF5q8Hd9VIVXJ1AmaNmiP38QIwMfKA71wIC2HgtLPVfaZ
	/WMhLVC/jKExINEiXh0X8mgNe//JNFk=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Z1rKlLfE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gVRod7TQ;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756923919; a=rsa-sha256;
	cv=pass;
	b=xhdWuVWeQQbtbtgK6kYUiNaFCqmWbh9/L9e9AOSSxdLLoNcHXnS6N3VmmKP0t75nFtl2//
	R886QyOCcl7GHX4a00Fu0xDzqoUzY+N+wg59CQhYKLaFhmR74aSZd1SBPMsJ0MJJJ5/u0z
	238tMTH1fOohi0eCgNsgmqy1tDHu/lQ=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 583I4iqa026354;
	Wed, 3 Sep 2025 18:25:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fQ/jDRyP0zgUu4R7Hz
	4iF5ffyqCjw8z5KbVkBYy5UhI=; b=Z1rKlLfE6uJc8HtJqlME4XFVWLjq/Biuc3
	xaOApGucVOmVtMdE/e1ZG1IW+IFqC3yLoSzh3jtXh6QR+W6eino8RAvDTcV3oytG
	Ihj7md9zUpBsSeKn6ussf8Se8ilRvcsQotZ0ijI6dVnKMRhhT8TumQUrXgkwTz2H
	FztqPFjethPBwD2oZdtUtpaOLUc/K8ZawTPbjYFhpGSKRvD9E9X24SQkZNh6tQcu
	nzitCwflDuoTKz8PBOYDaeVXODLjl9i13CAtNTWx+Rkl4rp6sgGjPhxlcWtpnnFk
	oayuZnBg+5eiNAyplY/hRoDN4UpZuCnVzctzfuBmCEBSjo6Vpv0w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48xtmrg119-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 18:25:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 583HjT49036197;
	Wed, 3 Sep 2025 18:25:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrancmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 18:25:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eYdm3YX2+Wf9/AQ8tFbEfc+LBJECEXL+rOrFP5DPSONcyICNSif9HSjkdEA64+8rPVO4RTcLVZ3M7dpMmKt2WoxL2j1DbCV5X0sI46Rt8tdOMrBmtROpd31p1DvV72m2EqMfYCihjxNyDbIW7n60EfuAelajx94AgZ+aXnVEf8xD195jV12DkVVmX5xNWDwDpJB+cr3e+opmYA/RoBYvA7j/ghJbm4WWUfeVeHkR7k+9Y38ziPf+a4SVdmvutaZvxdyng1Z/GmrkB7v4jnRpP+BgDQrTCVnn00B/skFGqKWGf9ueaHf/JbpZTFDOEZv03HKK6wDPbIwg0kNCneIgnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQ/jDRyP0zgUu4R7Hz4iF5ffyqCjw8z5KbVkBYy5UhI=;
 b=iLIDnDpHyI/srJG2OkEvkUiGCeglc/jOQO/kqG8Opw6mqmNwtiv9NFcRyPMHwSKXt206SotkpzIKSleKYf2H3u1neXVu91KQiVzGYV7D5zZlilY2XYLkQExuEyYomUbaRhd+/HstA2SdG2sPIPq+9QEOksQE8vzcn9rvXBOSu8l9OzkxKCM7ogp9uM30v/VKtKrfp/EVIomXyWof9h4cE1s5hirq9ZaBCLA346hb5BNOgET5vc1nuBt+FnpIhI+wJDy6td+q/74Bjm4dKxTcT2Q1x8OudVqjTPJ3XXEKPI2dVrgG8bggYghpOssjtUMWMcZZdunTzacM282nIiOzpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQ/jDRyP0zgUu4R7Hz4iF5ffyqCjw8z5KbVkBYy5UhI=;
 b=gVRod7TQFAFSZAyqgN9eWehpZ63pxJq5aUceYpsA2+oTEiRoHqjTEcE6Hv0YTv08vNwTcPKFf1rGuy3E/geZOfsV+GIbGYyLB5cgZb7DoDzx2dd694Y+KBE2JmPmRF2GZw6I5ZjdOqS6m8Li7idzvK2i6b+IUeVPIAOnfjPr3bs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB5092.namprd10.prod.outlook.com (2603:10b6:208:326::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 18:25:04 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Wed, 3 Sep 2025
 18:25:04 +0000
Date: Wed, 3 Sep 2025 19:25:01 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>, Wei Yang <richard.weiyang@gmail.com>,
        akpm@linux-foundation.org, kas@kernel.org, willy@infradead.org,
        hughd@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
        baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
Message-ID: <6f5db204-d606-4f7e-9075-29ccabbf927e@lucifer.local>
References: <20250903054635.19949-1-dev.jain@arm.com>
 <20250903080839.wuivg2u7smyuxo5e@master>
 <0a52cb54-5633-4374-baa5-199194dfc2e1@arm.com>
 <3bd9ff5d-de8a-469f-a7b0-41c192b23993@arm.com>
 <99f8cb5e-828a-444c-b207-2a12e13a45f5@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99f8cb5e-828a-444c-b207-2a12e13a45f5@redhat.com>
X-ClientProxiedBy: LO2P265CA0509.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB5092:EE_
X-MS-Office365-Filtering-Correlation-Id: 229540b4-e29c-4db5-fdba-08ddeb17339d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YMNfl60a4FJo47fLrghfZpXjn9eRi6coYTrHZWH8w8u1X1myeiuXG3gHqY6L?=
 =?us-ascii?Q?O3WsdnfOoi9G+xichyKj6yhg+amjPWvyyC7/1fC6i8s+0yAhNKo8YKRKt/CW?=
 =?us-ascii?Q?qU4bfSRUj+Wqviqub5oXbgmMX2FO5UGHMTmwg2vas7IrFAW1yaUS0WR/CHQJ?=
 =?us-ascii?Q?lQfFtULq5eJqQJHVhVX6Vrqo/6B3swH8h9X/cAmiHJ3k7Wm0EHMHCzeMJC1V?=
 =?us-ascii?Q?yy2ilSwAX4Xg76upAa3geev9XZ1tNfKQ4qRvnREAOjrX1whMGnY77TXsz7oU?=
 =?us-ascii?Q?oK6aDJhY4X0eWTxS7YBjPqGAam4i+JZp0aZO5TIZ0MJoFxGFUD46bGdS13FF?=
 =?us-ascii?Q?zE+xQBbW4nLXJ2QEk+IzZzPwV3NkJcVceo6S0WMlMbeTgX0ByObBNrepnkWo?=
 =?us-ascii?Q?6GqQutruMxh2CQrW/gM2faYav9S9WYpCQswTndRqKch7nr0d4wkTW/ESUPBg?=
 =?us-ascii?Q?ObKp3+SNs0wlbXlp1iQIOh0g8OwCsLS8pK6EtD4ISJVg8NRmivkgZe2u5a52?=
 =?us-ascii?Q?cHpfD3MwkOQD3lkRVbkGb4u/ZIY3lwGSNYs+5XzOESLRoHSyzznUBIj9HkUU?=
 =?us-ascii?Q?IqmO3uH4hdUSWe3oJUwTO9121eeZ0nilwkJCeSH8nj8wkyE80/+L6wcAmqKJ?=
 =?us-ascii?Q?SPY7BNjoRzqWDKaLkkK4JHMJibsRAV00WRBPoey1xO592HXUcAQJTZU/dJ5U?=
 =?us-ascii?Q?PjZBxw5wfssyZD6zKyel8cdD2KaMd1lBo0lB+l4EiAUViILD4yQI3ZsXigbK?=
 =?us-ascii?Q?O3va+xwtb9myvLtnahFdnhwI4mJ7f2GAlpRf1La79t1n1FwOvgl/MJLiuwh3?=
 =?us-ascii?Q?N0TLDBf7dq3hduVo0JyePAMp7RZxgG3F+PwFIungav1i8sVKZD6lCSOv8qOM?=
 =?us-ascii?Q?ikJ0lg7aupPkdNLKtYWllaUVNXuyeKA58Ld9dJXxvFzeysT47Skw1bQqbBUI?=
 =?us-ascii?Q?+umM9LduR3Ft9n+6cgxMR2NzHTHtf2C/VDy4J5ZtIpK07wJGebnHl8LE8ebY?=
 =?us-ascii?Q?D3aH446FVDkGdSyDDd4Fd94gVUX0nq88Fb224LtygwbaEldYOuWHc675fSv7?=
 =?us-ascii?Q?i+GyXp7DiKz+/LR0ANoKtrykWlXUJ0c6SNebkPqPin18i+jOPfw1d7zDrLSg?=
 =?us-ascii?Q?x/sxy/DHWu/+aKNRsBMcmqhmJIkomBbQLGxl3A+3LEG9u1DQgjgTyHc01Nb3?=
 =?us-ascii?Q?MQUr/QxRQx+rzXSUqbZcA6GI5gp6zKyGUP6tueH72/a11Y5U6Hi+FfguOlbZ?=
 =?us-ascii?Q?yjPZq69so85FoHSIo3dE7gwJpr16ABKJfyZUJC44fMvGf6LWL9lO4pQ/Gc4h?=
 =?us-ascii?Q?AQLibvCE3ZnFIxyxNT8LU+Ymbz2k+9MxDEm46zETdf4ZQUkNq+wk8iQcPbeV?=
 =?us-ascii?Q?gESi+24n+665DnRMR7c7m5g8aIWdaPKeeZl+mqaNgbh8uwJivKXg5/OX3Ut6?=
 =?us-ascii?Q?FoL+xlcCBR8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dMENKZHra0TyoEijosfCwvql50wmNewuriXF8vCTNlDyQ3cqXuU5B1uYv90l?=
 =?us-ascii?Q?rxoB8jjodsrbnTcFZyEVSx+GhaxZp8a8p2ty3cujqvKa8D7JlbYEO3A7UaVw?=
 =?us-ascii?Q?Vtj2VNavC1supWGPDP61Jn95BX5cPLT0xVhLRfI0SgMKLqSEO5D3IaQkqcZa?=
 =?us-ascii?Q?FpWMe1s9uzhspFPUXm93cau4FFpmSkxVWtUNBddPuN6NdnXIWXllQCOnno/J?=
 =?us-ascii?Q?2jgMmSLrxuzLbuSA+YIm6nxzgI/CnRAwe+xKA4sbxTF+xLffmCLL5OYEAnW4?=
 =?us-ascii?Q?8Ay5/289riIgYzFz5HM4JcOS182AEmyZ8ww4HIuZ8VFn/diYoSnj81nH8UWS?=
 =?us-ascii?Q?ADU8xH3uN2NYSazGS5KyLW41EciVXf9O7URSN5YebrTCwCMA48CIn3dtAVvz?=
 =?us-ascii?Q?Lq1+948aUYdE85ODREg/MXAq5x05waCsOYrqB/JmDZkrPnbpNnEB6FGtleli?=
 =?us-ascii?Q?PThBnTRAm7VqQV6HlAimz7p0MfN/Cjvx4GAHJOr+Knb9AVvWZVAOsm9/RTLm?=
 =?us-ascii?Q?7EAFHqKAozSo6+LpGAJY+CqeLqhGnsd9U6OxUiDbVjn8VETYRTV6hIerIqaD?=
 =?us-ascii?Q?3hrKCpGLYtAl+9CS5JB7wvB6a91Fq4uCgYUs6+5vyJ43WJeF9HxQ9ZpU1l4T?=
 =?us-ascii?Q?pgQSUtYy8EpeCp70MZRNewGgHMH5hIPUE/yPb6r0Ho52bFIJJhmgNn8bQ3br?=
 =?us-ascii?Q?regu0Z/14f+mZszBIpZrCT6c8yh/OZqum9Aeg4oXvDls7PJhQEzP7/sMC+fb?=
 =?us-ascii?Q?uMgnYdK2oa/k1b/cVQHI1yZgB11n9MY8+AaybuyXcJUCdH7eLXJ89/CctcIB?=
 =?us-ascii?Q?btDuaxHyWfVbIutsERa5Gmcvu/MUz7c+1sJqWLp9NjvGzdfi1vqzUmAP8zYW?=
 =?us-ascii?Q?MGxmLf0YqSyyopgFp4vP1kGEVuz2vo1XE8C6M8jKaPfPmsI9fltrMeF3pfh6?=
 =?us-ascii?Q?l9ACv0ItXHfS/56FI8r/S1VT8JNURcsVmhEdnDIBA6h4Soxwj6yRH2QHbl1W?=
 =?us-ascii?Q?5UmDtskp/uAQxSGsQyE6NpAgZ+cjl05Hoo2xme7ZuYp7D8EruLFzlH5ki/LR?=
 =?us-ascii?Q?12+1DrEbGZxNmjbzCFI5uYmOPY/WVFwF150JjhPlr4Abcoblt2AuxsJAzTkG?=
 =?us-ascii?Q?LTyeoe6aO/OV5L+6jVPDL9zro7LdnCHAleCa287x1zhPVT96+XFydH7VbSZ9?=
 =?us-ascii?Q?YLEUMxYhzqo0kaee0ARcuLBpW2hFcAXfP9+wXSFdHN5GxOtdanY5lRw7k8AA?=
 =?us-ascii?Q?yfX/PpnLkyoOAzTZBdV6R9ECnpOSvixiSqFjRdnEGSP6aoAT4DA/RCJ31JuI?=
 =?us-ascii?Q?BFvycZwpxXVSxEcTpteOhZahlNgo97LfofekY7Tz7WR9z/PUNW/yf5Ecr5bD?=
 =?us-ascii?Q?R2vW4Sz0EExxm4M6r1R/1w2lxMyNCX0izp5XLJ30rTMTwQI7J9z1qUk9+jua?=
 =?us-ascii?Q?+FH3A9u/oXSBAWbvpZn2u/TKxAK8eA5QBwEGCdOueXiyVbB837XWdq0nW4se?=
 =?us-ascii?Q?uOPXyMmbD8pC0GFSnuhAbUqKFdAFLiqffpr4Td8cdZpidM+2YLe1rvlWc1Kt?=
 =?us-ascii?Q?AF8PEpbMcwIcCL3yRM+Px+spTTaSy1qn6Cp5+9PkpxPTLTJY3Xu7VIchvedV?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x1+cEYCEuV1mi+K4X+rd8pNKtiV7voEqC9IJnDQqsvDyM+U/FnF2N8limKiQjdyH6cS7hr4vBTbgPx9CW+KdCSDBP3HecExjYwrx2F+LKTtoRei4tPd9yr0f77JjZLqFc4P454tmkEUdgjy4shY2+GQgbYA3CrRnTxEjaoAJONllP6v4aVDBYRVgqmvWmCxOaD0+y/FyV+3MrbG9xRpia2UNyLvyBThJoTN0Reap6eNR3BGkATXWlZ1bEL96NMpzwo53dVG1keQNr67geuhNSHmzBFd/6wDuViZGyqjC98gzx8qrLbE9eaok1FEsMeRiIRDcFVNMXsg6YujSJRGVrioPWZKU0nc+J2TYiHLncQvWZQkaXIaY9Sk7w58Rwlh5OouQ2mtnSqMVvH6DHYh/Fvs/7BXFnrkTOIyvG6UXXjeHeJxIXhRKDFcHTq+Like6bNseDVTmXUToPTmdbFkmRKdXvzjiB+rt9wyA+JJ910NsADEYL0gkPebmefWS+6V7fC/MSPGpXJY0xhU5pAp42YJdKtYtFtl2yYYipzQ2FI9m14ezBHsqLJrWfJQdRP0plz59rrByLl5ZFY89SKTM1Ni0bxEzMBOVvBuhgabpqp0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 229540b4-e29c-4db5-fdba-08ddeb17339d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 18:25:03.9917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aLWgGf93OzFHdXpy8CkpVgoMjkFiGKZ/tBeggKGPoHXYQrXKjdPeABNe6wMHtPWLLNCP7fWl/FdW1cdWc86QfOXrC7wJ50gOXCPAuwBGiU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5092
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_09,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=860 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509030185
X-Proofpoint-GUID: ozewlYMapFJ_iwUNhbzr-7UBBFQAPOw5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTAzMDE4MSBTYWx0ZWRfX45Zr4XfAMB+C
 Y6eureUhWt8zLfL/mpazel+LpLC8h7nfgKsUKCXrvSo4oRWIwcQj/J+kGa7NKGiLw3CXCwd2Ax8
 yV/0yyUhB/S6rDsu/kXo+STI1dbTOg83Jl+2P5RrAgjUmbZoitVGh8Eqjnm7ide5ztvkorxU6RU
 kHyLpq+cQsMccOqJv5XFBiS+3GjvJRvJOU+1WWj6YRkKu/oOIWb7nK/DX+kODbqv1Upufcia+YQ
 06UkX/XNrFol5VaGqQyCL9JefkCLP7cdI9xNgQaKyRHxeAQ9PjfS2qd5OvEOxCxgxEIqYeU4xCD
 dO+MP6Bu+VwQX5gnEYliAnNzyUNKfLC8aeVO6OpLduL1OJ9vZTdA8QJk3qzKUG8a5gMuYE73wSF
 RBleLjGH
X-Proofpoint-ORIG-GUID: ozewlYMapFJ_iwUNhbzr-7UBBFQAPOw5
X-Authority-Analysis: v=2.4 cv=HZQUTjE8 c=1 sm=1 tr=0 ts=68b88804 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=MpsUNeAMH11VS22DSrYA:9
 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: 0EEA3180012
X-Rspam-User: 
X-Stat-Signature: i5zurzcychrge69ao5e4a8kn4ryndhwh
X-Rspamd-Server: rspam09
X-HE-Tag: 1756923918-7609
X-HE-Meta: U2FsdGVkX1/JffB2F5tO9YXxxt8rdI91bFhBMcQnhYR6MQGPhrmZTaUnrHutvoyJa5itxVAH5S36GRJqCtBApg0ffRpD8sHczKUGMZ+VnCbAz111LpBaC0A+BfEVA5db07y/4X/C/1JpQSPyf++9pqUk7oqxuePyDnuCbHhxOgjUOPeWozNJer+HTll/KpGb33atCe5YwuPqhhXc3NHg98hWo+NYJKHH8Wi8QzQVH7tk/WUZGUbqPKkkvavnYi3ZxI+MdnJnJ9/DTvy0pGMRdk+3jW35/HA1XNYwGRsIaj4NNQuqljkmDiax1KcXmQ486VqxbhKed2X2ZUiA34yReoaVFuA75rA5rdvrA7xRSRTXE4BD/V/NxVZHHs4silmtL0yTKrID2YSzVO+yuAd7kinacBNaX8SrJIY59CL1m0nfpkyNfOfpZS1kzIvbkD6gs6RK1eH+5dV20yyENz2NkvzBwZylSoJ9ML8UJDCz1fekGTA2nLq0p5Ji5TEQq4yjC257Z1ipbppXZvGCuEZlrbHSkcSyzLrdkW0U+pLQY6oI8PS/KXDHhiAD5M4mbXdeqLRRKydYDxpo3EnFxcg3NwegfpPlSITWzD2d1Md03BD3ZVvWBj/eOXibDTiiqIrXWYscuVmdnkJRtuXPPzq2bVAqL2uI82vsVwssJOdtYjZSi866j7KOHkpOErygiQTBbotwCqxeaPJvsG53UnLAMOeYm8iHxzof8pyfMmOERueMYrSGBCbtqmm1B2sbAyY/wzQKYiOyBVTDKG13eXi4pXQyTaBGhIOJydrBBiQ5paeC8AkE5TWQ1MWWw/jg8/unC5GRT/EAw7dGNzlH//UbY04lo8m/oftrmS/fEM0ATudZmOUiSw+wtU7OPaKqi9smCHniLc41jQkrsW597dRNH2NpWO9vBNaRbCAZ+0BYWWK2vIVBbnAp4XL/P2wb183I58qz94HUN+muE0RDtFC
 I0Zt/odY
 j8iel3t968sVHansqxKOEH91dX5nD1IuRm4D0zSkz0GS6K2gYph9lCe8TYcmoQXc0Q/350JA7EaE6pPfQ+OZcnhbNt0RGSrbFcdvyIlb3DmpHqWkPuaKMG5xae9KyFSmRvJ/UpfhE6QJEoMwAsnXdO95hUuP8/qGTRLOCI5SYaZGW7M6LYx1waz+bPr1h9nOKAdRUNhkWW/3LIw6uaLLNX5Mhx6LGmfvgKTOSVQ8qnu1qRx911owRMdvPjNiJYHD/iHwV8oA7WoCiCaEDVHNyQlkmibNJfYdjHOb9L/R3pi4qDM39ULzTgXZ5WMscrYumb7qsgitrv3LXHZjQ/IMI0ROvaH2L6UdnrPIHHiaSQ9ZGKlwOUCenzWZqkjye/ncsmKPgE1Y0xpqXe8HOK/f+J0E/SRomdgEbhKsAoSln6WJgBZAyfOQTsPMapZ6CIDEwy82dVTu+DHnqtJhHDqTkXAYqWj8miZhZzIE3h39xbvryicdp+rP4xUYlTM+dmtcmroSQZKmMx3dRE0Cz7vTpio1G77GZAo3fR/KU3Guj68lWPGyNSeiymYvPhODfjaUyuy5fUBbGOZU+dUOY2+7XNymtxGRBpV6JvT0nxQxhvLrpbRioH9BjcBnfV0XgYH02ql51PCYQcITxCMG2x/+jSNjQ/FNbznzdMfK3l1OdF7l75ax4s0KEb0hjcQTC7djqfR8KDr9AyLYBtmczL8ZjJJo/6qCxy78aMq6dsTy1tGng+I2P2D+WRnFPejoK8rmcsXua0P/fkS6ZPEUOYBg9ID5aMqII7jHC2/Yl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 11:22:09AM +0200, David Hildenbrand wrote:
> On 03.09.25 11:18, Dev Jain wrote:
> > I meant to say, writable VMAs with wrprotected ptes. Maybe after this
> > patch, people

So, I think you really need to update the commit message here to reflect
that!

And of course, do a cover letter :P

The test results would probably work better as a cover letter as will be
put in the first commit by Andrew in any case.

> >
> > can finally make some real use of the max_ptes_shared tunable :)
>
> I hope not, because it should be burned with fire, lol :)

+1 :)

>
> --
> Cheers
>
> David / dhildenb
>

