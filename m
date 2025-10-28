Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 805DCCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAB628017D; Tue, 28 Oct 2025 12:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5BB18013F; Tue, 28 Oct 2025 12:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FCED8017D; Tue, 28 Oct 2025 12:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6338013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:34:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3CBA8C050A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:34:06 +0000 (UTC)
X-FDA: 84048070092.13.3940583
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id D5E481A0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:34:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VSydngFY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Lk3amsa2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761669243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g3D8WRlJTPGTaVry9gjKyyZXI3AquL5C1c9hMZEYYSc=;
	b=Sobv7OZ6AjQnw2RQhJbDESZYcMd7R4P5HrqnHe53e0T0izZKjRkTTVhFYfg/7NMm6hDNBC
	RmLEqsP0lARTAdu7hKcBVYGOyx3kvqF8EeyOPwIh1LK4KKroQWVRoC4SUceVHAKjtHmt9a
	3scGz8Aek51Sfi2VS/RNINgJ9sKkutc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VSydngFY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Lk3amsa2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761669243; a=rsa-sha256;
	cv=pass;
	b=f2wR0p3HCr/0PD/01wAkxe0qMFpe/7ZL+HTCE1jVoIqakSnpYsrGF0KizVhz3TI+ffoqpZ
	dWNpQ6NtTXS/JhT4/KfUa3NOgRUa4zbJ5q3BiXrMc+DGayH8uV5moXx1gPV6hsXb0isQWq
	gK42P92joWGbGaWHn27djIXRRjlaKjQ=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SBDYQf009847;
	Tue, 28 Oct 2025 16:33:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=g3D8WRlJTPGTaVry9g
	jKyyZXI3AquL5C1c9hMZEYYSc=; b=VSydngFYwm0VdFBZcg1n/M0sxJe8ofNaEq
	FmBOq0RM/rlksdBjNMqcqC2nEOG9fRisygga68oVXOACaTyVcYKyxZFDFODCC1//
	yK4bZmpdGuqsOztA0HbMH04kOYRWZE5DIki3VGWbRWeiy3ABluQ9EPY09+R8+SRv
	J3Mv2J9inMGAsc5E+uG9VzpTqXcp/KXs5CFhuzVI9lK7lN2g6bWTwQuHiwHz8Crr
	d1v3XMv9kTicNliu95buheeF3DCvvmiPC51BOArYqpmSFVQg8s0UdDdudK4qvnT6
	rIYFWta6KzGq7JCMQa+LwoED9aXmvN9sRMTSkG+eaKwDx6rjOg6g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a0q3s6kg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 16:33:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SGABvd015310;
	Tue, 28 Oct 2025 16:33:48 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010009.outbound.protection.outlook.com [52.101.46.9])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n08e2cr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 16:33:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R2nDbytL0hI4689S8OHLIVeSgIiiM8OHMUy+CA+yt4EcHYhfWm7/jC0jxZ3zpSdpG6VlENxasAW4mtg6WDEALkU1TG4ChiDQ1ff32W14jVf8IkwDlsdMZUYdD/hcrQhaoKsv2zDcCY+j3fRphDV1uRCebd0fcid0bg+5GUWfblZ014u1C3Id5chVcyeB5/pZPrwRYBdbJYwWWu5GPAQQEKPApbGjt/SGWlHPXX6kFlEEUFKCmI+v+iEwlS0U+OkicXqq97AoKilBNo7LLhtCSE4GyUC1nrRFOQgWSIbfl6sYNvvY4kCUpv9hY+KICulLZzkowgYl2K5LAXl0f1zpoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g3D8WRlJTPGTaVry9gjKyyZXI3AquL5C1c9hMZEYYSc=;
 b=AmIv0ulstU/3/w9kFbrCmzvl4o6xRCbC82sT4eBDzhxs2xuqSpcsDEVRM6Qo/HGIs6l5/RixBtjMrd/TUwvmMHal1WgD2ks2exCojIyb3fqPkm0v3G3ltLmTqgWGeLn54ox848SqFS6LFyOadtn9avN8Bxeown6HfpPZ1O9mxYB7UIOCW6HGBg8WEOkL2wnDUpyx22x4SuLrXzG4dialovCckOu0FTCjNKKLlbHRmtgX4UbcqjFJODM55Q2rpkLg7V/WHcK9Cf/l66z2MVKJM6QUjsODMAO1JIw4frnp7L+z76mAcylYOm60x/x4ujN5VqtAvBhzb1MfCLdhs3q07Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3D8WRlJTPGTaVry9gjKyyZXI3AquL5C1c9hMZEYYSc=;
 b=Lk3amsa2uEHo2tdyd6Rr1S4ATHG2TxFMB3iVl332C7CQJaTmGgeM9CTe9CmjN7qashdbXlfWpoqDdSkaiCAmybBxzGf3MQvYeSwXbhRv+HajagzNPwicH6W2GFZ3KoCPoQVbgr+aa9vntRssEoTXph6V2NcZL/0bBFXWvCRysrA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7932.namprd10.prod.outlook.com (2603:10b6:610:1ce::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Tue, 28 Oct
 2025 16:33:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 16:33:44 +0000
Date: Tue, 28 Oct 2025 16:33:39 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: David Hildenbrand <david@redhat.com>,
        Israel Batista <linux@israelbatista.dev.br>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-debuggers@vger.kernel.org
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
Message-ID: <bdf568ce-0e60-4a63-8d67-8d272e05fab2@lucifer.local>
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
 <811fd675-b231-45e4-b9d5-636fe63bde6b@redhat.com>
 <aP-2x314BKks2_N9@telecaster>
 <3d3bfa52-3e13-4d23-8ef7-6cb8b1ab7d79@lucifer.local>
 <aQABhaMC8xfO2Vem@telecaster>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQABhaMC8xfO2Vem@telecaster>
X-ClientProxiedBy: LO2P265CA0513.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7932:EE_
X-MS-Office365-Filtering-Correlation-Id: ebbed149-e9ba-4d35-ab46-08de163fc310
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A1Ki4dj42U9jlUlBvTVCLRCuMHSEqXQhoT1P2uKL2bYgc9gxZHzmqyB63gkU?=
 =?us-ascii?Q?6KkENQJgxRN8WD2r/y+J9qYMxEIYipc0Hkb2zeBMZ2jSaNR/Y1yPSzLV0mvJ?=
 =?us-ascii?Q?OSubEEeXP7KsPCOWGFzQPHyjh+3/rZe1cqiIh/LriC4tIIaPaqJJYgpTY8jL?=
 =?us-ascii?Q?8HOhnpfgvu5bwu0hMDgRLSlD7I/HTUqfz/Ew+zjf3bENrWdJHb1E3qO1La1Q?=
 =?us-ascii?Q?ISCPl58uHqwX5FqSwb9St5i2YgS7D87k2lUWw2oBbgRpEN4Hc65t9gO3nISI?=
 =?us-ascii?Q?ahJSiiSXOudvFrEja6+Icc0iU4CHosilNcPFzB5fXHaHrqlpMP+oW4Lncluy?=
 =?us-ascii?Q?SauG+jCft0X3mjDykQJXI0wpLFUS5/papvuouLHUjYbbe90WA6ehZifRyBb7?=
 =?us-ascii?Q?q2+Gee5rsbIROYFR6CRgeHooQlLqiKcH2w1jXhzXG4UQpScrhDFLdugVVWJb?=
 =?us-ascii?Q?O5CLzvL0fHf74vITTAc/FGeNRL+MHGWTsH64iWQr2ysvxmvjoV25tdWoUZyJ?=
 =?us-ascii?Q?0wLG7b3ARXnOfZseUMzeoi8Typ50ZKLX4MMmTSZAyrqcE3ix3mOB2RhDndSJ?=
 =?us-ascii?Q?II1ojKHMadwugjLDRGzkuNv8hDOYm+4pLQaS6/64Jtvmob4l5Oo3pamuWpmy?=
 =?us-ascii?Q?abH/K65LIjBeIn/gwwsO6ZV1aPtWoF1WuevxbmEuKeScvyIW3CE9VHEDVUQC?=
 =?us-ascii?Q?7LhhSrVHwQZaaU9kryUh/vQkJ4ShTqpgase9dNKIssvL5GNPqygeKImqSLsy?=
 =?us-ascii?Q?OwsptBWDjDHBUT9v9WIp+0i7k2bGjYZfOECOYENyrNMo2D4y5yEtLdE/kTKS?=
 =?us-ascii?Q?24tBbmySn4DezV/x39B9rZreGyUi5pIQiq0JY4Yq4PbSka8E11L+3G3Z48PG?=
 =?us-ascii?Q?gngpzfbZcNS7xKV0D42VPSX0nPq8xhZoK5MvGjOsBJ/ZbLNB2szwNcicpdzw?=
 =?us-ascii?Q?pdOGGKnK1PN4RTj3HideIRvfkgKh7Ru/HEghiNNaUGoxrSUjdqG4gAWJ0xRc?=
 =?us-ascii?Q?hUqtv7IQfqmAjBkQ2myyuXRqVif3PwD+0JMhW36rVdpKXQ+sXJlZp/EgAgHp?=
 =?us-ascii?Q?+Q0ql9eV/7T8DPMlf0imqYObkpwOcoZ/pyidBY/Oc+kB2L/g072Wq994DlAF?=
 =?us-ascii?Q?9UJ2W1w/K6l1elA29SeR1eowFfQ8sAz+PVFGbRPFk24So/LIHra+AbBNcHnS?=
 =?us-ascii?Q?mIvPEnlSLvXadte7XGp4XH6kpkXI9EFJN1eRUpQxrFVkMHhP+N85mLgzuBg8?=
 =?us-ascii?Q?TAG3B/SCgtZzWkzLTV+HtX4uOebtk5Q3/DAoBFvrJq4jCxVX1kkz+ScLTrLr?=
 =?us-ascii?Q?WvmMzwgPSki96NBwo8E7qNxiEPBQzyLzhOfpQ3J8oAvtqUiaeorpbPHUIs3I?=
 =?us-ascii?Q?q9fD8TkXr1NKMZYVC0gRIEFT2A5H3/6/HDL/Qrc3M/XTWqeTz2qpDlZmGOUh?=
 =?us-ascii?Q?C8Sh7+U4zM4GjEYUtjgDDCRoIvXSWJtg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oeBlU0nkLPi9tJ8mk5h/KEvEy3N2G3b+3qo9TMY5ibJ7hbvXh1n+kK9nPAMx?=
 =?us-ascii?Q?Dm51JSZ0LoP1rhirsIvkoYpb9GcdAR40C1M1h7iFKJEw5+RaMyZMfmJ3jDWv?=
 =?us-ascii?Q?4I3/1ATHMN9x2R+hxfxFKCQfYnZdI/j0V/w0jbuMh71QCDD06wpxEwlL1Mhf?=
 =?us-ascii?Q?huY+vup5klSwQI4Nhdr3EuBFe31vuU0DQbUsJthVoSl4EBOngIOijUTRbAYU?=
 =?us-ascii?Q?/YzdI71ywEC0Km8CLFRG7GhlKFSWAkN35jnLe9mKHJ7ENhYwiDr4VoNOcvH+?=
 =?us-ascii?Q?0kLBuLZA2WTBLKSXCK3riRNUS4k1kIupGddHTF5SxENf3BBvQ8zmFETUjiwG?=
 =?us-ascii?Q?2K4LcJdStXF7z0r+UkuNLN+fz79xUTMh9MhgGGaEzAAJaG351TRnEUa41F4s?=
 =?us-ascii?Q?GX4GdC7ic6FeX37wKPvrcgv1S3T11AodnMuBDXVRW7//RLEmQXwOAb3fQ3H6?=
 =?us-ascii?Q?BGSmtLRpO04O37NRbGPocqwGbMw5kXp9lQ1XwonpTSFIaZwEHDOY7hmkSIRB?=
 =?us-ascii?Q?yfnG4OCxepNHRCluWvlLtewXj6FAZJvMoWRdeLehIIMnPnMJ30IhROvpHYkz?=
 =?us-ascii?Q?n5zeaBDYkuHKbb8wF0r8QCvJ5WTIzUZhLwhNeLcLMbAjOG0Z1zMwTKb11TzZ?=
 =?us-ascii?Q?KROvr5VR1lROiWuZ1/+9e4rv9OIinWc9kace4WYuMvnFqhTn6Dnx0L01pQO9?=
 =?us-ascii?Q?mPgEZKe9fO1NUcJxqW9jxDYr/5VKoew2zsqYKRPyms6bB3DVpYPo15XhHIVE?=
 =?us-ascii?Q?FqKn+wbByxo0i/vfTRuJKCYuC8KvbW1j3HWuC7VPBDkudYq6m7Y/TtuM5pid?=
 =?us-ascii?Q?FYtGovPapmLyX0j0iPGRUK2bQ+O8jmm7j3J7ak2JX0bQSloUbv+G6PkeEuzG?=
 =?us-ascii?Q?xbJu9DczmJN9akYMkbwwP838eBJsY/gf0gdT7uqoa2O+htAG1vg5qILc0kdJ?=
 =?us-ascii?Q?2CiO84+yMUx4wJrD07HvHcJHoSlxcKYqizLmtz9Nm3nQWKRO9xhzvex3HD2a?=
 =?us-ascii?Q?RKKUUAX3T3oYVwYBOTv8CSaeGeSuo5n7CQ4Gs8+kWtkprJ1086CJkDOtLpJx?=
 =?us-ascii?Q?0DrKCI4uNGY3wMegHsUKezu0ClM6Lo3DfYWVTx8GNH5l+p+fH5efldwPFtOH?=
 =?us-ascii?Q?rnBuYoJH3vXwxbzcxFIlPKZ0zfNih3Fh6o/3JSwiILNV+DYmvJFhRKYm418o?=
 =?us-ascii?Q?AUeNtWH/Dz+4jhrxivx3oH8CsOPVLAt9S0BingJZ4BBjyeb3APIY1C2epRZM?=
 =?us-ascii?Q?OlpUhod/4b8jX7r9wKFUwtafLN40VK5BtJLFefdgVmCRi33p8/z8L2RyVm/f?=
 =?us-ascii?Q?k839KJekXjiX/riASQBP0zAaCc1RalbnHpJB25o0nxKh124NZluJmvY9iMcp?=
 =?us-ascii?Q?5Jf0YzVmbO8serdLz9j8RmVpVPJf79WD2pYy2D+uQptzMOpZ5aYlc6tSwQ7p?=
 =?us-ascii?Q?Wgb0LwPH2594NXQZeNC4eCK7hUOtsTmEm+7afxVETaoADXdQb+3eV/1uB13f?=
 =?us-ascii?Q?E1RSc2S4kiZQrFEmM7gTr03uoiZ2uhUun1bbAewApeNF8JHeh9BmaCDtgZES?=
 =?us-ascii?Q?sjoUvp9k7tvuHNCfOKyfdaCcQMjfLHR7QpPpX7YcrJ2ZDDQVz7yu6/IE0tl5?=
 =?us-ascii?Q?3w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XQuHAcNa/ncxgeQoV2ZKDW8cTpN68sF7EwpQK6cQKzfX5U+XtW4Rgu6j5R+iHRjMIalV+UDIHSkq83gN+SuTblN1PhRKrVv1JkLsqSFhi6rh75ZBTz/4mquIGC9S6yjGAhPvEyiop2iHtyQPKM9dwuaZu1UiIHhKlYWKhCI63k5uSHu8WOtKQCq4adi+REu97PZbE9/GL1HS4AH8cy0JBXA8/0dl9HE1+jKpkURgNhPLItW0IKERnhqSOfPizyGylO0ETKx1n/Db19Zo57EhIH5F574OAGs19+uHb9AWJkqQVEx7xLGGIYvGizLTm6Tz+yKambuJD9bHhzxqc7pP/FzGc4YslLkadIgwhb8HAwawE+6oX+V0FxBmp/0PQQUUNDWfqNxNILedZqiIzVejM/joSpioie//jV3nzqyB3scy1fakREwrTDcpjLiFrH1GsOFM7TKC2KT6PLSK17LcUGa/+SyzIwJ/TTG38yeAR00ZEHC/x4lAFEyOTjI21vaovPWLkXPnUVGo/NYGMhGAY6LMjuO2ZdwoB8I9StDxNeYrDHVPOTIHrhaLlmkM+jt7IUnE4iKedRkpdf7GtqRguRzWTVkzr/3gpcCVvIuQcQw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebbed149-e9ba-4d35-ab46-08de163fc310
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 16:33:44.6224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s5skuBqLI2NBrtogLsP7CeUs6rF6BzcCTbGxDvJVihM+tFtYLLDztSwSRUk8I1vBcvzz1u+kvOwrUZD2TihASb7sA47rOEwLXuw5YEJxbjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7932
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510280140
X-Proofpoint-ORIG-GUID: 21qdbjv-ildCiGbuV9ckintMCBjRzs4a
X-Proofpoint-GUID: 21qdbjv-ildCiGbuV9ckintMCBjRzs4a
X-Authority-Analysis: v=2.4 cv=Q57fIo2a c=1 sm=1 tr=0 ts=6900f06d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=ZmTw7JhCPtBkolO-odUA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAzMSBTYWx0ZWRfX9e4AfN2dhVMp
 QBpzISJxemvN4UDkBLqqHruWWsD1c7VN5HTsOqHZeTw13Sqi3jAgRucjnio9ep2Weq7whETARTq
 G7kWW7g+opwTwqNZUH8sSnHo90sZWeIeZ45/4jv4rx+tNjzYFdrzGrMRQ/79p1Fx5VSl7POFRio
 myaTjZpk3udcFi6uxyzASZcPwfVfR6uSaCM/1GubQ2+GqPU6gKnikf2JVyd7F2tkNtZ+FFmf19O
 Nki+18Pgs5emi/hKTf4pZoWTnE1n8ZS+g6nxo+tSM0EMOarg9vLvLkDamrz6JWSSsq0ox5mFZYB
 gKV+ViluP4WtO2jYIFs+X0FPpYYDa6k6jPPRuAV1jn9Nh0AVX+CVb8s9VWIB+1cuK93vknC/CII
 U884pbeHo0FrcziHp6oQbT8fysIspg==
X-Rspam-User: 
X-Rspamd-Queue-Id: D5E481A0005
X-Rspamd-Server: rspam03
X-Stat-Signature: 5m55agy8nhb5ir1fotgqwgukbyx9grz4
X-HE-Tag: 1761669242-719018
X-HE-Meta: U2FsdGVkX1/tTA0BIyRgEN869raFTMkKHw3qwqkZCqURJ07go+QLCVUPGoxOkwHo3Nwf7Eh+MjiEuYUHN7nD+N1CBlhPqDZxGPdi/axeAeNwyjfBJRAbGkV33DwHJ/Hj/sMiDeTods6dB1vCD93v+zP61uf4DQAcWD34Yb9Lkgx7LSkoWEyYsaGD6GiE6GG+isMwL2ZSTJCSFjJBGP8ibWLeFbrp7xWoj/+Av7HZl/dkK2Dy8i3dLzWJ2aa4OOxkzOueR0PEhzP6a4CCuJjusWYdbVI12QyVmQWXfo467C7DUPlfttln6OEXxa3AXGhXjsBlCH8Si+O+0UicksYwzikV/e/DqA0k32GgvngDyWyRtXW94iTSpAssuT/CkXafjqxnUeKncET8eNE43k4qDSRfEThHL4IFKA6OAvs4wwBKNhhpC4czZ4USxeCWMMSGXcopw8wNCAeHitIyOay0bFxDGXyfPfvkpIY3OUsp3O3BhZ2KndjYh16/GdiWVQqYUp+HyJvPM68uwz5bzju5FAg8lmU+1qGs0cZgLHwBz9aw6dtpZ2DFC87T94cTGXEH6KjBvUokSWGDqlgrKxnaRUDK9r9NsppeUKvAtK/tN9XPSw8Ldhx6qgL4VLzCMPgvWPa7uCgl447GHi5vPJAcvydkSdHgOORMPd0RmMUYyufGhHf6v5fG1OFulCAYz6Blcn6EOsJ67FLoOjEpkPRVEAMAtKUiTUJ3JNfxf4Qst95hDJ3+JVsFiQmsq//4JhQmZl0vzkwlqeQNkxYN+u5jPkUM6PSVHyLFR2loK4BYssmFWDAFDP4XTAtaBin4K+tuZ+CvjXa/QgNoQEay6r/dIHdMSGyKlTeBXfo37DttlFYZzdBjtPjoogld/37clxk6TcrCO0AagEluXBxE30mVoupff9ENaR5uoEfQ0p4kyOhP8GnViH9irrJvR+683VPIAPsXzhC3cTGFPc5ubzd
 FRp1fEp3
 5OeSWKmtJO5bbyPj8iF94Pa5zFpY8hc4kEeljKp/il8TP0mKCyWJuWnT5b/0gsZzU6abxqBf5701OkSk3NEah3c+p2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 04:34:29PM -0700, Omar Sandoval wrote:
> On Mon, Oct 27, 2025 at 07:46:43PM +0000, Lorenzo Stoakes wrote:
> > On Mon, Oct 27, 2025 at 11:15:35AM -0700, Omar Sandoval wrote:
> > > On Mon, Oct 27, 2025 at 10:29:15AM +0100, David Hildenbrand wrote:
> > > > On 26.10.25 17:22, Israel Batista wrote:
> > > > > The MEM_* constants indicating the state of the memory block are
> > > > > currently defined as macros, meaning their definitions will be omitted
> > > > > from the debuginfo on most kernel builds. This makes it harder for
> > > > > debuggers to correctly map the block state at runtime, which can be
> > > > > quite useful when analysing errors related to memory hot plugging and
> > > > > unplugging with tools such as drgn and eBPF.
> > > > >
> > > > > Converting the constants to an enum will ensure the correct information
> > > > > is emitted by the compiler and available for the debugger, without needing
> > > > > to hard-code them into the debugger and track their changes.
> > > > >
> > > > > Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
> > > > > ---
> > > > >   include/linux/memory.h | 16 +++++++++-------
> > > > >   1 file changed, 9 insertions(+), 7 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/memory.h b/include/linux/memory.h
> > > > > index ba1515160894..8feba3bfcd18 100644
> > > > > --- a/include/linux/memory.h
> > > > > +++ b/include/linux/memory.h
> > > > > @@ -89,13 +89,15 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
> > > > >   unsigned long memory_block_size_bytes(void);
> > > > >   int set_memory_block_size_order(unsigned int order);
> > > > > -/* These states are exposed to userspace as text strings in sysfs */
> > > > > -#define	MEM_ONLINE		(1<<0) /* exposed to userspace */
> > > > > -#define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
> > > > > -#define	MEM_OFFLINE		(1<<2) /* exposed to userspace */
> > > > > -#define	MEM_GOING_ONLINE	(1<<3)
> > > > > -#define	MEM_CANCEL_ONLINE	(1<<4)
> > > > > -#define	MEM_CANCEL_OFFLINE	(1<<5)
> > > > > +enum mem_states {
> >
> > Why are we naming a type we never use...
>
> As David suggested, naming it means that we can then use it in a way
> that enables compiler warnings and documents the code better.

Which compiler warnings?

enum foo {
	X = 1UL << 40,
};

static void blah(enum foo foo)
{
}

...
blah(3);

Doesn't generate any.

Nor does W=1 or W=2.

Nor with clang, etiher.

The better solution is to do something like __bitwise with sparse.

Also re: type, I'm not sure it is all that safe, or you certainly lose
control somewhat as the size of the integer you're passing around is
'whatever fits the values'. Technically it should be restricted to a signed
integer (e.g. 32 bit) for C11 but I think gnu c11 is using some compiler
extension stuff to just make it adapt it to the correct sizing.

Anyway, this is all probably moot as I believe David suggested these
_aren't used as flags_.

In which case I'm fine with it.

I'm just confused as to why we're still debating the flag stuff?

>
> > > > > +	/* These states are exposed to userspace as text strings in sysfs */
> > > > > +	MEM_ONLINE		 = (1<<0), /* exposed to userspace */
> > > > > +	MEM_GOING_OFFLINE	 = (1<<1), /* exposed to userspace */
> > > > > +	MEM_OFFLINE		 = (1<<2), /* exposed to userspace */
> > > > > +	MEM_GOING_ONLINE	 = (1<<3),
> > > > > +	MEM_CANCEL_ONLINE	 = (1<<4),
> > > > > +	MEM_CANCEL_OFFLINE	 = (1<<5),
> > > > > +};
> >
> > If it has to be named, can we just expose the bits as an enum and the values as
> > BIT(...)?
> >
> > > > >   struct memory_notify {
> > > > >   	unsigned long start_pfn;
> > > >
> > > > CCing Lorenzo, we recently had a discussion about such conversions.
> > >
> > > Yeah, I've been asking people to send out these conversions as we
> > > encounter them in drgn, but ONLY when the absence of a value in the
> > > kernel debugging symbols causes actual problems for drgn. I want it to
> > > be clear that we're not spamming these just to cause churn. This is an
> > > unfortunate corner case of debug info that leaves us with no other
> > > option.
> >
> > Right. That really sucks, but I like drgn so if reasonable I do want us to
> > make life easier there... :)
> >
> > >
> > > > The states are mutually exclusive (so no flags), so I wonder if we can just
> > > > drop the (1<< X) setting completely.
> > >
> > > FWIW, putting my C standard committee hat on, there is nothing wrong
> > > with combining flags in an enum. C11 is silent on the matter, but C23
> > > made this explicit. Quoting 6.7.3.3, paragraph 16: "After possible
> > > lvalue conversion a value of the enumerated type behaves the same as the
> > > value with the underlying type, in particular with all aspects of
> > > promotion, conversion, and arithmetic." Lorenzo may have been thinking
> > > of the stricter rules in C++.
> >
> > I don't really understand the argument being made there.
> >
> > That's just saying the enum behaves as if it's the underlying type? I'm not
> > arguing otherwise.
> >
> > Consider:
> >
> > enum some_name {
> > 	X,
> > 	Y
> > };
> >
> > void some_func(enum some_name val)
> > {
> > 	switch (val) {
> > 	case X:
> > 		...
> > 	case Y:
> > 		...
> > 	}
> >
> > 	// compiler doesn't warn about missing cases.
> > }
> >
> > This is already giving some sense as to the intuition that enums specify
> > all the values as declared specific enumeration values.
> >
> > But intuitively, with the enum as a _named_ type, it's _weird_ for there to
> > be possible values for it that are not listed.
> >
> > The problem here for me is the type being _named_.
> >
> > If it's unnamed, then it doesn't really matter, it's just another way of
> > declaring the values.
>
> I read
> https://lore.kernel.org/all/809f552d-3282-4746-ba49-066d2bd8d44f@lucifer.local/
> ("it's not valid to have flag values as an enum") as a claim that this
> was invalid at the language level, but it sounds like your objection is
> more of a personal style preference. Which is totally fine, the MM
> subsystem can have whatever rules it wants.

Why are you ignoring the points I've made above and referring instead to
another reply of mine? I'm very confused.

Can we keep focused on the discussion here?

Also I'm not overly impressed witht the suggestion that this is a personal
style preference. In fact it's something _somebody else_ reviewed me on a
while ago telling me not to do this... it simply made me think, and
therefore I am making rational arguments in favour of it.

But another point if those arguments (that you don't seem to have responded
to) don't suffice - I don't believe (correct me if I'm wrong) that we,
anywhere in mm, use a _named_ enum type passed around as that type to
specify flags.

We _do_ use anonymous enum's. We do also (bizarrely) name enum types but
then don't use that type.

Again, if I've missed a case then let me know.

So this is (AFAICT) _mm's_ style preference. And again, the switch()
statement point is a strong one... the compiler certainly seems to think
it's an exhaustive list there.

I simply don't agree that your reference to the standard says what you
think it says, or rather as I said that it really makes a difference to the
points made. And linux uses C11 which as you say remains silent on
underlying types.

However it's gnu c11, and you only get a warning on large values in the
enum (which technically is limited to int apparently) if -pedantic is set
specifying a larger value.

The fact that the compiler will treat a switch statement of all enum values
as exhaustive is already a strong argument against this.

Note that you can in fact have type safety even with these kinds of values
using sparse, a pattern I've used many times myself, and am using in the
upcoming VMA flag series (with an anon enum of bit values).

>
> To play devil's advocate, using a named enum for flags makes it easy to
> document what flags are used for a given field. I don't know about you,
> but I'm often annoyed when I come across an undocumented `unsigned long
> flags` and I have to track down what set of flags it uses. And switching
> on a flags value doesn't make sense in the first place regardless of
> whether it's a macro or enum, so I don't expect that concern to matter
> much in practice.

Yes agreed I prefer a named type, and it's irritating to track down
possible values.

But you can achieve this with sparse without having to put the values in an
enum for flags.

>
> > If drgn needs it named, then just name bit values and use BIT(...).
> >
> > >
> > > Of course, semantically, it makes more sense to use distinct values in
> > > cases like this where the values are not actually flags.
> >
> > enum's are kinda defined by being distinct values...
> >
> > >
> > > > IIRC, these values are not exposed to
> > > > user space, only the corresponding names are, see state_show().
> > > >
> > > >
> > > > Won't the compiler now complain that e.g., kcore_callback() does snot handle
> > > > all cases? (no default statement)
> > >
> > > Only if the controlling expression of the switch statement actually has
> > > the enum type. All existing code uses unsigned long, so the compiler
> > > doesn't care.
> >
> > So why are we naming the type... does drgn require it?
>
> Nope, drgn can work with anonymous enum types just fine. As long as
> we're all on the same page that naming it/not naming it and using bit
> numbers/flag values is a style choice and not a language requirement,
> I'm happy with whatever approach makes the maintainers happy.

We're not on the same page. But I'm again confused as to why you're
labouring this point in a situation where it's not relevant afaict.

