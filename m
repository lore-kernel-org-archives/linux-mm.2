Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4F5C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 17:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5458F8E000B; Wed,  6 Aug 2025 13:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51D828E0003; Wed,  6 Aug 2025 13:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE828E000B; Wed,  6 Aug 2025 13:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 277928E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 13:19:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDE90136611
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:19:04 +0000 (UTC)
X-FDA: 83746993008.24.5C7959D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id F38D5180007
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:19:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JrXs+Uw3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="bjWm/yyn";
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754500741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgdXnUuZIVR7CXnUDBC2GUEuOGWr7A8AJ8BO/Pse4Mw=;
	b=2YGI1RTCtnsrkmlVwNkOeKy94pXSKDOjMptv829dk7COpHz4cD4Bn7doghe5mhbQ3ySLGu
	rkP5I7+J0vOBhBrpZFaOKykRJOvSQQI9DdBIB0g8DxhesVIuPXQ+63LRxr2bjroWSirl7X
	Mob6KSL9GHE9L8YganbmzUIi7EQXIgk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754500741; a=rsa-sha256;
	cv=pass;
	b=mi8VlNPSD/A1HC+OwgB+IArV/1rRvsV/OSFQ8C48mwg+8pliF7i+kyaoVEHOwxHccscz5i
	z1MqeEussKXy7+mxL1nSdfXAQjHIEdqrPYWavgChDp8jiMxBA5Q/A/4InOrKYMTxytyWyq
	B32XtmQ/dFiw0bvwXrng4XREddHICuI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JrXs+Uw3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="bjWm/yyn";
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 576GRMhT001599;
	Wed, 6 Aug 2025 17:18:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fgdXnUuZIVR7CXnUDB
	C2GUEuOGWr7A8AJ8BO/Pse4Mw=; b=JrXs+Uw3v43zBbkPc/lDzcvnPk8MpJPlyI
	q3j790xpY7gHQV0mtQuvCbPLRAOHXr14a+3huQgkExlQAuiBvj2KPN1HH5az66mE
	EQ9S9FdVyVyikUfRGrgGvV5Fpfx5fjtLm2FAZ3wAma0w4F6pfgxTidWy7Bd7iVwt
	w8oZ+bJn5cyGWIyLrFAFlgWZOe2tRL3Emo4D0lBP73eCqnQns//O6/WbXPWpaLEc
	I1vRWS4i/AiRcFQzSEfgMZa2B9go/BL/ZUjdZ/QbHXgMo2/KWlgkrNT/W84W/6nA
	FSarjZwdzlL94iVHNFi55Lr63ov3vUWX47u3tzIeOB9611Y1GkPQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvd297x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 17:18:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 576GoOFc028197;
	Wed, 6 Aug 2025 17:18:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwmj2fa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 17:18:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k0x7QRnqxzkogvzb/43+x1ZwCkleS3y1u5hUN9rN8sG7HWUna+XT/M3ULlzEFM29WESnE61vxUQXAxPStIrTYpFegLt+PRev+mVy58/sWiwZNlegauBsiLqHQ4mcuNIP8xBE/sq3NTHgWqK4jc6X+Q3hA6BCDYuoFZH7ugGoOF+SlwxE9WDVLjUdkINt1QECxYakxCu1x+m69oVW2X6C46R8/uH3AldSXlABX1Xv36hX5I5KouObXwFoyAw+MLqo3+Z8NK+JzLFL9msmzCj/ce9+xH1OS7hu3YLSbJMk9O+xAs0zp81O6t/feRVq9s2PBY1nIs/52Eh9NF+G491yoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fgdXnUuZIVR7CXnUDBC2GUEuOGWr7A8AJ8BO/Pse4Mw=;
 b=Hg4ABhY824gt2c2/Tis/445mWIh/ZHE79/w/0wEEZtqfm2LlfK9OCsTMyTfrbIjdBNdoxJQQJy7rIz0AD35lr2rpa1nQbVAjwnxXT8voQKoKUv4ZAABXh98kRIg0GaY9pZLapN+VAEgORVxAyTB0/REGWTnva2NoFvxmfa2lDhsXVqK9+edxnSoyklt1SHQEhzmyQWg0mpHTu+BvLfOXq11SCfCcEHcnkU47ROkHL/VFlzuYN40l761vJm+5QT9VRWcWw6cRxCtiscn82wsZhvsy1vV88tQRGooOWKfFll6agfPEx+HH3Fi8dsKABZU7S7jHYKgAFGxBQ2DsCZFIzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgdXnUuZIVR7CXnUDBC2GUEuOGWr7A8AJ8BO/Pse4Mw=;
 b=bjWm/yynqncB9PCdxWXqTcKjzLB2Sc5HsxZrhg9+j4yfzJI1QlyHPn6qgfFcl3bV8dSLF7sdkJ2s9lbw3keHQMt30o2N1A79TDBhfNtiWNuRA7P300egk3qw/hMj6Xpl1v8voYo56pZQDEGvWUm+orBC+RAcKdsYqHy/r07AeHQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5820.namprd10.prod.outlook.com (2603:10b6:510:146::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Wed, 6 Aug
 2025 17:18:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 17:18:50 +0000
Date: Wed, 6 Aug 2025 18:18:48 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, 21cnbao@gmail.com, ngeoffray@google.com,
        Suren Baghdasaryan <surenb@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        Barry Song <v-songbaohua@oppo.com>,
        David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
Message-ID: <a00a8cca-e435-434f-855c-a3b56f2aece4@lucifer.local>
References: <20250805121410.1658418-1-lokeshgidra@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805121410.1658418-1-lokeshgidra@google.com>
X-ClientProxiedBy: LO2P265CA0008.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5820:EE_
X-MS-Office365-Filtering-Correlation-Id: 386712ad-a7cb-4b83-6b29-08ddd50d4fd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Pe19i+hQegO0mxDneAqbxGqrEi3f+rXBJJnA0BcTg4UME/IU42fdqaGUv0EQ?=
 =?us-ascii?Q?KRWAeboWQodgPEOSbjTrfiMddt9umIGMLYiaZpcd2wwvcnts8e+4pkhV3pwa?=
 =?us-ascii?Q?ajqKM8QXlfoq3cxYSET1q1VhhlTiZUsdY3PIwZAQEVP8xrGpC/oNwV9ZgNsH?=
 =?us-ascii?Q?aOMP73XKU+Jujw2aJQWw+HOpsrar6nqzg7lmxEpPuC4BwhQxOXmqwd1wbKIN?=
 =?us-ascii?Q?v4AmO4w2m3tnyfV84xCQYFGOB8XK1E5kburQ1Cru9opoZswUk0Ep9K/1OEgI?=
 =?us-ascii?Q?6xQXFZQ+Fx78WcQ3LhHs9LpaVQd1OkXwODr2K4abPzxRRpIsDU1Ax5cUbRL8?=
 =?us-ascii?Q?xEQmxpNwEwDTbQCxIIfOwN/ZOsWhMKLqBxrLLGFj0+xwqsd76Q6/vfCxjNwT?=
 =?us-ascii?Q?5MYK9Lqjz2CpuqHsqGMkh6OTZFcJSnEGlRT2m8o6rwbUyV2HZ5qqJW1b8C3P?=
 =?us-ascii?Q?XmmkyBLPytSz8TB48uOlK7pxbnYYLhLjLJ4x+IumLCKSgQY/EDAyhJwJKe3C?=
 =?us-ascii?Q?wE3bvLxwi6N7yR3qgDG23RkFUhX/HZVmzV/gETX2W+lPgp6v/Ub3s+5U+ZkJ?=
 =?us-ascii?Q?zknabcnwGfxTBZG92EG8yhSfgoQnfxRpDGOjdC9r6UXCvfWyqoJ9YoTywfu+?=
 =?us-ascii?Q?ktAJna+lTeWhwrN318a2tj5leYAONv9GLA6nyxz6JcThEa/nSIUc86E5We7r?=
 =?us-ascii?Q?4j7+A6mNayRh61pz7rf6SZwVTPy9B//80LTdGqMgJwjbItvztBVV7xv0ZPFR?=
 =?us-ascii?Q?rRfO+uoocdqg7oxEd2UiICfxgQZmaV7ZEufcjIkuMnnT2XcRPR5QEZLeYn+9?=
 =?us-ascii?Q?Vjp/F+3ss8fDHkGFCryYm+0YfpGUbvApgPyS8P2XsBHwv0SN4bhJmFKZwibE?=
 =?us-ascii?Q?1loGE6tTsGUPS+KAv1albLMP+ydNkscGWDcZu7jeuwFqhKrbfTxhzDB4NI0i?=
 =?us-ascii?Q?oShW8rLTmpWg1y1QwYa6/ChPGescwqKmwh5Y8XvPMxyJZRmkdFHYOs0xWdXF?=
 =?us-ascii?Q?bnQc8zJOtW+NSHMoVdCdBLeb3VFUZTHlBHn0oz0Pe8bbI7tNzy8vZiBWCUwi?=
 =?us-ascii?Q?5d9ElNdEzsrY+KCtswOv8z7DknfO/7CGDaEuCjNZ81tNp6X6tcY5FqEOWEhl?=
 =?us-ascii?Q?D0dwU1X7i5sBynR0CDQkI2TerxI6pN4YmuxEO4t+bs4tA4o6rEQ0fGR06CyJ?=
 =?us-ascii?Q?Nk5OE2AbStJ3gPy89ed8EaH0lnpUrUgnTnobVGq6P07H0D34JBMORYaV+Fiw?=
 =?us-ascii?Q?1Cl9OBEVhVjRs2kFohWWiVr0Lov9J1M7SFRqV7d6LzKpM8oGRdzI7NMYASsu?=
 =?us-ascii?Q?9N0iMEQu6U33NaK31reUDWcP5jGXYjNhbsbuZ6hUyk/aZgw2gBHm6rpbeTRQ?=
 =?us-ascii?Q?jnZjyxERS9232EF9c0SUnJvn6yS+HX4snOhjdD8i2p+jgZu5EMudf8rOGVxT?=
 =?us-ascii?Q?uDkFB6hNu0I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WwYdInfL9vgQTpO79j6aU0+6E6QH9NP+wDyP1HlaE90rcCxzg+Ww2U8uuGyN?=
 =?us-ascii?Q?pU/pH9piY1NpDbEX/pn+Mu1MZIMizpHSitRnWukFf/fJ6R+r346+/f7/xMx3?=
 =?us-ascii?Q?gfI8zfAaB41c6geUC4XZ25Z4m2eEd2e9DdJ3BQH8haWtWBkiHjuK3E2fT4jQ?=
 =?us-ascii?Q?dyC31gk818BxrycHRsKFrsUjq8xE1Dtfswcqza0G2rny5TiS4O4ufltpoCtv?=
 =?us-ascii?Q?mdqdYsORqDMJWQsza/oxOnMsWOrcHssAaLqFpHlfx/zGFbW9VWXS64ch4x3C?=
 =?us-ascii?Q?DbQX+rem6YTRYj1aitmmjweNv8OkwnCkIp8AM81xhhhi3lMdWsFnA4GY6rKu?=
 =?us-ascii?Q?lw1JBzh3ot5iwc5Aeaqf5oDK4nPj0DePyl8hhVPnpXrjPUvgbCgickxTesKh?=
 =?us-ascii?Q?dXiDgn4j1ZFdT7PqT6Koe7G08hCqJa4U1d/ll8hLFb/6aG+Bttz/y+bEwG6W?=
 =?us-ascii?Q?C8LDEilMA/tjT+Enq2MAuOTxB3wSHQtmiWVzlS4IGDRT7QZHSGloPtW2Zi9Y?=
 =?us-ascii?Q?96xfZBnjXLNXsLwkApJFXDm+Xum0ycFB+jQIFKt7sYbNXi9mR5Scpx5QqWfY?=
 =?us-ascii?Q?Mtv/XWNO0Yvvthz7suqIdcPsG3rcXucZqntLuxtmHMN248Hq4aHuFORBg+5X?=
 =?us-ascii?Q?bnnFGo4Eb9d2QW0bEqVypXzzkQubx1k7jgZruEXXTmQi9Bkzd5zMV0ppXn/C?=
 =?us-ascii?Q?1THjICuTFjFisHWGJWsjpFcSYWFTiOIREGkSpCNwCbq0PGJF0Tx5AAjVvRNQ?=
 =?us-ascii?Q?jEi0FY4unX1ZyldqAB3H08Mmc9tGAVYVx0PkiwSi8DDly4OnEqYEOux6Aoq5?=
 =?us-ascii?Q?i5xJDJ7zw9Pzp+izZE/uHXtktA+skxpUYv9q/ubI2V9sTsHwIGFW8GS3+XA6?=
 =?us-ascii?Q?vO7RJ2Y/L8Y6aeiQV6J+vXGVuQLosTcDwJQa1TWENtdqH24EKgq9Fyogc8oB?=
 =?us-ascii?Q?qiuRweWH3jhu9Ff5uAUpnMbXjOn3ENH4DATOLab5V8sD21gp/RaZZlRIaK1M?=
 =?us-ascii?Q?TVZIiSG3d74Neh7tzETKyJriTsrgxO5Zm7dMxpwcWR/byVOQHPcdiUwc1tPV?=
 =?us-ascii?Q?ORw60+5W1Q4P8qM54a0n9VmyVEdvR9c1uVLtUtvawxBvbTD8/JhRJtusQKWg?=
 =?us-ascii?Q?ofOWQC1xT2KY1Amx7DgFTvTtB1IdM6HfhSyx+WhfDBen4aIPE6jb2L6xob7S?=
 =?us-ascii?Q?EsLHGjFwFluS3p9UtUgqbjhRY3Bxcpy9aYjq5kG8TdTEoKjBqJ6uWKUjnjIY?=
 =?us-ascii?Q?FPlsQCLZfE3R7lvugqgEUVzd2/GK5rYDjg2QIJKTjzpt6HyRbcAFzEA0oLet?=
 =?us-ascii?Q?WH25iwyC21cy0BfCRbD8ZyHsbrweztnNcwh7DV8UeEWDJ4Cwk4TSaS5AqdFV?=
 =?us-ascii?Q?YxKVOkYxGiTaZgN6YteZlVUJ0fwauWq+TE6vm+Oyy1sMe5Jbid24/8a5Onw9?=
 =?us-ascii?Q?wE4s7ZIczW6dAxXOgzr6AAXPwxmikjk6RKXIJMir847tJjhKb+TVRkSrTwBa?=
 =?us-ascii?Q?oMW59mgjLRAtRzfD+jMJ/o+G4shxG79zJT5rhPcIXndIfXAwaPmzrxd52Gp5?=
 =?us-ascii?Q?oIOp/zVsuF84KrquTQo0gTIsYN7tb4skYia8b6bLr9oxq6tEim6AzSZohMGB?=
 =?us-ascii?Q?Dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kR9TrLGFahGzf3oROVKWgoPRqIMk6JGpO09zOAkSjRMc7cHeDJyo2sW4t5h/3x7BRicCiNTMmS6k6ExVLSRJcL4Ue83yBmqdbR5Dq1NoC1cn3KsN9elD5fLBeomiGwO/3PN2xpZk4jP0koKTGZ27heiT/tiMKZP1DZWT47+b14QP4bwuwPohSrIwNm2n+uFGdLeVd0sRY6a95UwLM3SOp1MbFqtln3s6hT1D/+mCd1ZjOxscQeW26CJRiamHlw1mguWm2RxoqJlufjcrfEK9kPuAgifSkAcGPSqN+REUiWXO1kLOQ0f/6B3nYzjRF51ITHFh778CE+p7UsYXOpVaaV33XE//gcF979L6Ym3Ok+CAa0ixhSBaXsbAxlzVjCJdZ5kAOOSjZzTfwBLKWCWkAAmwX7aIev0ffEgxQ7md1ayOl3tivNx9aNWE2D+J1xCsfGxR9Ez2vHS5/tiiRHQiqQuqQuOWBXVRytbU79mDCQ0xUPv2PSL4X5BBjIHXaiVdJrRqwKYJgH61Lvtu1vWZB9vl9EOgopHxANIx3aBIHMCtxQ0kA7WpG4zn4+g0ttkZdmvQCi98y5LNwutJPTsVgJqkyb904OIJmFb+zcuKT78=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 386712ad-a7cb-4b83-6b29-08ddd50d4fd4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 17:18:50.7904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dbuYC8/Zwrj1jLoVmOnlmhnLjyMkqdhL+YL/K+oNk/NN6vDA+BvlBmSMBHF+c9Pd9icb+ZNqOf5mpHFU0nOFz4qgW5fahnsX2cHA8on24Gw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5820
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508060112
X-Authority-Analysis: v=2.4 cv=fYaty1QF c=1 sm=1 tr=0 ts=68938e81 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=A2pY-5KRAAAA:8
 a=20KFwNOVAAAA:8 a=hQ-OD_F_bcHfIMsC9RgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: fx8uIUe9IlT5JzHxnki__gcMvaw-QalD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDExMiBTYWx0ZWRfX7lBqOacrnw+H
 JT00bT2z7Ng3pQDYim3Fd8pQqrZDs9/h8olZJa9dRrWIYFv7jVKNms7K+OoDVvX+4DOutNty8BW
 apCRZujk1/NfJxvIrzfU6Hk4S0XBn+QmBaPlejVIb9gwZGW9O45DdiUC/5Pd3OP5wmgPVx+7IH8
 Cj6QC2SkC6nJYTisz/PKKmN6PZgXR/HxgGV2L+F/vtcqM+1Mw/REcVHAUTJLmWuaMEW9Upixm01
 vRWzsMQ+CeM8gBe8t+bny2vQqfcBvr332ZnbcO2VLGNPUAlG7+PCfJ6lte4OrnuiBZIrmmsHXeA
 t3HId9guFXbtGzN739xKKSjxJ3pS3d38rhbOosgqlxpqTouGK6go4BxdkHbhEDmmDLnfeFrxji+
 kkem/BY+B4lCWHmseaMO2wI6ckDVQEl8098R0gFvrcmP4LfX9WrXW0SYrqaFs8Ip+XEF4caV
X-Proofpoint-GUID: fx8uIUe9IlT5JzHxnki__gcMvaw-QalD
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F38D5180007
X-Stat-Signature: n6khz93u8iqbhhr64acr411uerdbgkz9
X-Rspam-User: 
X-HE-Tag: 1754500740-335397
X-HE-Meta: U2FsdGVkX1/oeiiYkGhP78MDWpZQ4koZgWPVZpRNgj63cWNjyp+TGJuRemTuL08Fm4epXgk37zXVZ0S6jsbd+5I8x7lZsMVZqWo3jrIiB8pQXElZMzwLY91kb6TjAUn3zH8VIGu8H9Lzq0bTQSAkTZqESHjdmaGfDxOn+8+d6QkvOs47MNsOwqY7G3Og3pLthqIlaY0vKbNgdhSddKG0IUdl9eKINS0WibJReO6BnzLTJjKbax0MLQ/cdcvMFa0iopGdTJpUQYUXoURQ+Y5ykMSgBMszl0JdPqLu7ZiNQbRMI9XollVWSvo0c/UFGZ0R2fVbEKvNYM8pbhHchTRPsYXo/kwdBEfbTHKfEYEgI2wqN5TCRU3bsqIWAl/mE9ksG+T/FVq2yhO/OnphQT1FRRKU3RuaB2Nr+8qrBez6+++h9wWp03CYKcBiL+TuOoFI+u7lSZm+Vue8UkFZe/UfvhfvYKVv/+25AyIIU8pi1qE9rec1F6yVDH9xPathaDIkZPND4mle6o1ees1SGXDHIsqMuwbJfCis60jxCi298WCFr9oM7yajFAAbUYDlFt65wEmh0Llg8yS7tEP3AoiXAksLcksxLv+oV0Y022G3Vk4NZsM1dOFBapLCW1madRxzErxjCT17T5Bk/PpZ345W30lh7xDmfNW5QoOTTd4qKB7+sn2p56RmzvewJG5e+weLcaUvursr2Ayy9Ag7o53S+QUPUUSTBOM0iSAIBp+1iMjVjSJBJHZfEctu9FIlETWmnu08jzLMl+zz3bTkwqUI/A/IzwBO/ZFopUfU5C18TPnMWSWN+Wfs/YYSQue2LnXaH29P5hOamZ1ur9Kl13nE17yu9sO/xmaMvij+wV4+ipE+RhTipsIy7SuBcq3qMHYRZupWCmWGLhpKDPa92sUC8A//BonY6KfX7puPXsX7iGE6S108jhWX5OaUFn4Rp3pH/inp1LcIA9M3IAAaTgb
 S7KdK5eP
 CkogsAlp/BD6ajPwx00tAVYO7bes+DU9Loc6fcvgepwaGtJ2XeRhmNM0jDSHQyZbxaw6O12aE6BB1YEjkH5UOF0r6/XSigUwuk6CrBWxSRUUZNxiJmI4cGMgUpT5k6lp4s/d7uuK7P5PMM12nB0seRtUoksNqpsRDIY5PnYUKAO6Z2eVCm/cpVnxC9+OBVg33FtfwycQup8rDHBxKxd2o+HzmOUWAQTwDsOjqJBATQevpcmRdN61ysmbloxM+2hqKsOoAAiGluZnGUkg8K4K7ZMUQSL+WzbiS88LQHeFbAjiarw4dNpPODyqJhe3qAHdBjzPdg1+ey+jomAVPybzh547ocFo5ml2HXl377BWWrsiOQoWoHfWg0kuf24DrI6TSEz2Xit4L0Y7RnZwwMm3jaccz8zzmBh226iFUJQYBM0RyN4MIIMaddgcTW+YlT1oGIPzu3hRfnVEuQdqvyEu3tTk7Nvra5PT4oZhR5r+/aQA6v1u3nHVzg5W1RXxyiV8xbIGNakL/igzqBJd8fIaTcYOdqvRe2P6b5jjUlQ/SWRcWu8ogADF+4/VHENJby2IpqJwCmFDM67aWXj4IRtuI1nAyu5VuhonyP80qNh60zmXXsZL9AZAVSt+Jhk7EczuOccV5zRf+QgCiaPTF8YTjcZhs61gfw2ztoo87Z2Co3rKYZc3TwZDcI1atS633n/6nvmJU3V7Gpa7n2i4IjHB4s8jqk77Ml2xqiiLMIiTu5cvd5Te0M9xqQGad4gqQYGJWX38kz5GxeN/TxVFDKWeXrdl97bYqMFiEAmQZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - Could we drop this for now, please, it's splatting and has broken
mm-new.

Lokesh - could you make sure to run the mm self tests with CONFIG_DBUG_VM
set before you submit please? As this is splat is occurring immediately on
uffd-unit-tests.

On Tue, Aug 05, 2025 at 05:14:10AM -0700, Lokesh Gidra wrote:
> MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> for moving present pages. Mitigate this cost by opportunistically
> batching present contiguous pages for TLB flushing.
>
> Without batching, in our testing on an arm64 Android device with UFFD GC,
> which uses MOVE ioctl for compaction, we observed that out of the total
> time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> ~20% in vm_normal_folio().
>
> With batching, the proportion of vm_normal_folio() increases to over
> 70% of move_pages_pte() without any changes to vm_normal_folio().
> Furthermore, time spent within move_pages_pte() is only ~20%, which
> includes TLB-flush overhead.
>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Kalesh Singh <kaleshsingh@google.com>
> Cc: Barry Song <v-songbaohua@oppo.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> ---
> Changes since v1 [1]
> - Removed flush_tlb_batched_pending(), per Barry Song
> - Unified single and multi page case, per Barry Song

Splat, decoded via scripts/decode_stacktrace.sh:

$ sudo ./uffd-unit-tests
Testing UFFDIO_API (with syscall)... done
Testing UFFDIO_API (with /dev/userfaultfd)... done
Testing register-ioctls on anon... done
Testing register-ioctls on shmem... done
Testing register-ioctls on shmem-private... done
Testing register-ioctls on hugetlb... skipped [reason: memory allocation failed]
Testing register-ioctls on hugetlb-private... skipped [reason: memory allocation failed]
Testing zeropage on anon... done
Testing zeropage on shmem... done
Testing zeropage on shmem-private... done
Testing zeropage on hugetlb... skipped [reason: memory allocation failed]
Testing zeropage on hugetlb-private... skipped [reason: memory allocation failed]
Testing move on anon... [   12.230740] Kernel panic - not syncing: kernel: panic_on_warn set ...
[   12.231322] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.17.0-1-1 04/01/2014
[   12.231655] Call Trace:
[   12.231748]  <TASK>
[   12.231830] dump_stack_lvl (lib/dump_stack.c:122)
[   12.231963] vpanic (kernel/panic.c:448)
[   12.232088] panic (kernel/panic.c:312 kernel/panic.c:303)
[   12.232199] ? move_pages (mm/userfaultfd.c:1964 (discriminator 2))

Appears to be:

	VM_WARN_ON_ONCE(err > 0);

[   12.232341] check_panic_on_warn.cold (kernel/panic.c:327)
[   12.232502] __warn.cold (kernel/panic.c:839)
[   12.232628] ? move_pages (mm/userfaultfd.c:1964 (discriminator 2))
[   12.232764] report_bug (lib/bug.c:176 lib/bug.c:215)
[   12.232891] handle_bug (arch/x86/kernel/traps.c:338 (discriminator 1))
[   12.233034] ? move_pages (mm/userfaultfd.c:1964 (discriminator 2))
[   12.233174] exc_invalid_op (arch/x86/kernel/traps.c:392 (discriminator 3))
[   12.233312] asm_exc_invalid_op (./arch/x86/include/asm/idtentry.h:621)
[   12.233460] RIP: 0010:move_pages (mm/userfaultfd.c:1964 (discriminator 2))
[ 12.233615] Code: 5e 41 5f c3 cc cc cc cc 49 89 c5 e9 e1 fe ff ff eb c4 e9 6d ff ff ff 90 0f 0b 90 45 31 ff eb cf 90 0f 0b 90 48 85 d2 7e c6 90 <0f> 0b 90 eb b9 90 0f 0b 90 f7 c1 ff 0f 00 00 0f 84 4e fe ff ff 90
All code
========
   0:	5e                   	pop    %rsi
   1:	41 5f                	pop    %r15
   3:	c3                   	ret
   4:	cc                   	int3
   5:	cc                   	int3
   6:	cc                   	int3
   7:	cc                   	int3
   8:	49 89 c5             	mov    %rax,%r13
   b:	e9 e1 fe ff ff       	jmp    0xfffffffffffffef1
  10:	eb c4                	jmp    0xffffffffffffffd6
  12:	e9 6d ff ff ff       	jmp    0xffffffffffffff84
  17:	90                   	nop
  18:	0f 0b                	ud2
  1a:	90                   	nop
  1b:	45 31 ff             	xor    %r15d,%r15d
  1e:	eb cf                	jmp    0xffffffffffffffef
  20:	90                   	nop
  21:	0f 0b                	ud2
  23:	90                   	nop
  24:	48 85 d2             	test   %rdx,%rdx
  27:	7e c6                	jle    0xffffffffffffffef
  29:	90                   	nop
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	90                   	nop
  2d:	eb b9                	jmp    0xffffffffffffffe8
  2f:	90                   	nop
  30:	0f 0b                	ud2
  32:	90                   	nop
  33:	f7 c1 ff 0f 00 00    	test   $0xfff,%ecx
  39:	0f 84 4e fe ff ff    	je     0xfffffffffffffe8d
  3f:	90                   	nop

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	90                   	nop
   3:	eb b9                	jmp    0xffffffffffffffbe
   5:	90                   	nop
   6:	0f 0b                	ud2
   8:	90                   	nop
   9:	f7 c1 ff 0f 00 00    	test   $0xfff,%ecx
   f:	0f 84 4e fe ff ff    	je     0xfffffffffffffe63
  15:	90                   	nop
[   12.234294] RSP: 0018:ffffafeb00483d70 EFLAGS: 00010206
[   12.234484] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000002
[   12.234738] RDX: 0000000000001000 RSI: ffff90afbb433078 RDI: ffff90afbc7f0080
[   12.234997] RBP: ffff90afbc7f0000 R08: ffff90b037cae540 R09: 0000000000000001
[   12.235255] R10: ffffffffffffffff R11: 0000000000000003 R12: ffff90af01acb980
[   12.235508] R13: ffff90afbc7f0240 R14: ffffefc386e80b00 R15: 0000000000001000
[   12.235764] userfaultfd_ioctl (fs/userfaultfd.c:1925 fs/userfaultfd.c:2046)
[   12.235917] __x64_sys_ioctl (fs/ioctl.c:51 fs/ioctl.c:598 fs/ioctl.c:584 fs/ioctl.c:584)
[   12.236065] ? ksys_read (./include/linux/file.h:63 ./include/linux/file.h:80 ./include/linux/file.h:85 fs/read_write.c:706)
[   12.236202] do_syscall_64 (arch/x86/entry/syscall_64.c:63 (discriminator 1) arch/x86/entry/syscall_64.c:94 (discriminator 1))
[   12.236345] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[   12.236524] RIP: 0033:0x7f457600fecd
[ 12.236658] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
All code
========
   0:	04 25                	add    $0x25,%al
   2:	28 00                	sub    %al,(%rax)
   4:	00 00                	add    %al,(%rax)
   6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
   a:	31 c0                	xor    %eax,%eax
   c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  10:	c7 45 b0 10 00 00 00 	movl   $0x10,-0x50(%rbp)
  17:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  1b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  23:	b8 10 00 00 00       	mov    $0x10,%eax
  28:	0f 05                	syscall
  2a:*	89 c2                	mov    %eax,%edx		<-- trapping instruction
  2c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  31:	77 1a                	ja     0x4d
  33:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  37:	64 48 2b 04 25 28 00 	sub    %fs:0x28,%rax
  3e:	00 00

Code starting with the faulting instruction
===========================================
   0:	89 c2                	mov    %eax,%edx
   2:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
   7:	77 1a                	ja     0x23
   9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   d:	64 48 2b 04 25 28 00 	sub    %fs:0x28,%rax
  14:	00 00
[   12.237333] RSP: 002b:00007f4569dfed20 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   12.237599] RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f457600fecd
[   12.237854] RDX: 00007f4569dfeda0 RSI: 00000000c028aa05 RDI: 0000000000000009
[   12.238129] RBP: 00007f4569dfed70 R08: 0000000000000000 R09: 0000000000000000
[   12.238384] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fffb974ba60
[   12.238636] R13: 00007fffb974b830 R14: 00007f4569dffcdc R15: 00007fffb974b937
[   12.238890]  </TASK>
[   12.239094] Kernel Offset: 0x33000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   12.239480] ---[ end Kernel panic - not syncing: kernel: panic_on_warn set ... ]---

