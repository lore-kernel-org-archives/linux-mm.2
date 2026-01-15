Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20705D44C4C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 13:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27BE6B0088; Thu, 15 Jan 2026 08:43:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2466B0089; Thu, 15 Jan 2026 08:43:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80076B008A; Thu, 15 Jan 2026 08:43:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4E9C6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 08:43:22 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57E52C1991
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:43:22 +0000 (UTC)
X-FDA: 84334315044.20.A76256A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id D36974000D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:43:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SLMerefE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=texLJduj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768484599; a=rsa-sha256;
	cv=pass;
	b=YEeiDnb2XFwbKzdwuwN4b+09hfwXaGvAnbU0cV53IWeVxAZuYwAP01zRJRbHy3RTC0iYjw
	xWRCe6q4/X0JBoqAy6ocUsKcnmQPCwM/k01vhW0VOLrVP89JLZxvTiAw7Rg5e015qXfoOQ
	HDg7NPtYC/gCzZ/y0PapoUjOYtNWIzc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SLMerefE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=texLJduj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768484599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+j/2PhzPw/8LQyowMsbdWnOj9ivw4ofimvBa7zRHiZ0=;
	b=mK7ZZ6CNCrTr/vx7hgjUEGBRb7TKlbLFWLoQl5misUy8hnQQ+VbTdjRccr1fdVDQ9ZLqlk
	7sZ9iEyAE1o39NBsq71dANjKiGuBTSnqaRlyLuaPoCdDGvBYKHmhWWXpOWF56zEozUZ61s
	iONkVQif350UyDrxFfoBgyTYRlfG1XU=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FDcuia3643762;
	Thu, 15 Jan 2026 13:43:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+j/2PhzPw/8LQyowMs
	bdWnOj9ivw4ofimvBa7zRHiZ0=; b=SLMerefE11fiGfnacnTFyaMyp0hsG/z5Ga
	deGrIEdYWfUHA2zMGi1Ak6Vo+vsGmIWFw2mnQppz1GtIbpnUGlfaXtxSeXG5Ie5b
	k6MoeJZiSbWHtLcN6Cqn8xj1/X5SkzTNbcTRhROtTDs0HuHy1ptvmRyDxKS8tou8
	8vuXGuFMgGv7CpBptGIkpNklXJLp4GjuEoJy9PxcklHtsKcovGdzNVjNrmAmjImw
	nYn1HqzYMOANIMMnEupIQD5P0JJ+qOrt1di79+9sMdN8bxI4RkrtWnSKCjLuaIF9
	ZVCst5sU6moBVqAsRlXKKtLDgL2s1+Ur8mntuhhhI1IElKC1dnTg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc35ba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 13:43:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FCd3jR029335;
	Thu, 15 Jan 2026 13:42:59 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013052.outbound.protection.outlook.com [40.93.201.52])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7n46rp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 13:42:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s/okM7U37XModD/ZRjk3sgy3hwOKMZoCYTu17CKYfXXRi1Nx/EeFCj5GMnWSYHQCV5XmHoT9Plyd5m768wiknBX61YOdaVMH4C116CK65Qjp5Sd/MgLJD7hVtzy2Y8olpV3yzAiCUkiTwp+Gerhs3+66AVEiPJ+CFNpdk0cDiiRMMaSSbsklRqcnpGDxAx68mOM69J8YWOf5+alBmJzFu0Kvy/ij4SVlj0fIffZZcQ1VBWZ64uIADuPUMTY8BDIBUT0IqXKZa1tyrneBC4F3P9/GKa4CwtD9bXcnXibGLSn3d8/4LBfBCyh2TwSIsLi/1S41UbSSBQykEFx5a/UMBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+j/2PhzPw/8LQyowMsbdWnOj9ivw4ofimvBa7zRHiZ0=;
 b=R6SNuRQp4iXo6jBaZhRDgWc+smTqHu5a1MIycqzFOJrw6HFl4Hww9IxJFHPUZH8fvXgCHUYEtGtUfqzdw6vjrzg7CAIt4Mgc8EC8Rb9hjNZKRL/l+O6/D6ttv0HZ3fqo/Fi9qogArdnpLVWetM7n4mu1mRPKNrVgLDyMTBVdTYOoECTYsyBWuC065Ora4TSC2+WSqsy/Eb0wZfZeV1NR2NDs7EXK4tYyXvq+jsVhrnQpAHF2QfZBvpchXHGlYJmW4pU4I108qHd7Bi3/6P4aGc49pV8dTkxbVuOcDaedpUhVFxzVJ3UOLgHnskrn8bqH0Qmrf2GHSnFVU8hw6sH+5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+j/2PhzPw/8LQyowMsbdWnOj9ivw4ofimvBa7zRHiZ0=;
 b=texLJdujv8yBnJ7R40EJXKGE19O2yKXlA6oToiSwsyU4dq59WUv1IOf6LrEPKOKPcKohLAq9okJO+6jxygupJLRZ9Z+FJOaQwmDgN1+0nwVyuVJDV/7tIm0CKkwukFGhn1LXdf1DsfVyGsUd6zXm7XbYhpRPitmPlguO9JHa8VM=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SA1PR10MB7739.namprd10.prod.outlook.com (2603:10b6:806:3a3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 13:42:56 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 13:42:55 +0000
Date: Thu, 15 Jan 2026 13:42:58 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 18/23] mm/vmscan: drop inclusion of
 balloon_compaction.h
Message-ID: <bfa2bc0b-7b28-46d1-bb2c-0979b6b30445@lucifer.local>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-19-david@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115092015.3928975-19-david@kernel.org>
X-ClientProxiedBy: LO2P265CA0264.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::36) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SA1PR10MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cfb11e5-e87c-48bc-9766-08de543bfcf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HmeauldW6c06M0hpr/NLfSpuTiPUnhNsmOcVy7A/Me5tWWTfo2nCxMPpbzC8?=
 =?us-ascii?Q?77ZftY8+pGk+kU9NrNelfjyasmvhJ+2jmEclZngl0CDccXsQYhWrmDheSlq6?=
 =?us-ascii?Q?Rioom607r9/utm8rNlJGgw6Pt4WccfCl7UUci8N5Zi+86Slzdn5uPTlzXzY7?=
 =?us-ascii?Q?bfhN4q2knp2zof7873kmf0HfEAohjRPuQuhAjP9BzArQq5tK2FK+yJOpT5KB?=
 =?us-ascii?Q?XtDDTFzoyoDV0JZRlMydhV036nJdW13fNqoEeiMBpUO767qLjXf82teWDD4e?=
 =?us-ascii?Q?6KHO1rGeRi9g8Lqzdn3ONbsZQo/A0lLKdDbCkhmZzOQDO/gfDSfz0teLoCGu?=
 =?us-ascii?Q?shExhuYVBq3iCq0mQGGt6u3DOkVotGUVwpoGP3aO1G5LA3Orm1+QgynYw1Zw?=
 =?us-ascii?Q?Ze2U2QTQFfdFQZnqCWHiRNBNRGVlQ4tZbIshADvcQYihnCYSd9mhG9L7PcWn?=
 =?us-ascii?Q?25AAhbWWg3nd0VsUKBW5GH0WA3oGummJ68bLaLqco2pSZQfEBpc7CPIF6pRe?=
 =?us-ascii?Q?of1mIqKYPzD1c/XXGnyL337C/toeT1e5HIzzUM2w/oWRj4QkGq0Ld6OAq4/P?=
 =?us-ascii?Q?3izr3IC5nFFPmFhOsM0FzqGYMyZburPXSFmrddNgy2amNM3W9xQnpYZ9VW3T?=
 =?us-ascii?Q?vWbaqpYBrLG5/z8t78GFoJShKxP+oR6qCq73yApWWnMwb5tALN+l4+HPUemN?=
 =?us-ascii?Q?/3Huc1yXLQ4PyJg9kpdvUw8u4Md2sy0ulkeTY2W4au9nrfic2ZwcvDR40Wp3?=
 =?us-ascii?Q?74WUu2WpB8ZKA4eRDys0wqYcRkaG5DtJ18oEp/L+h6yKknWh8Obk70eX4aWL?=
 =?us-ascii?Q?MS94bo/8v5v6YaTYtihTlZHtpHbkmL3P0bQyNipORqOx+xElxZojPxzHAPEu?=
 =?us-ascii?Q?xfLLh5Aw2bzKsBBd38qi9oVQKbsPm5R0sXuB3ApXch5ZV4+Gw2QShNiiOF6e?=
 =?us-ascii?Q?HIn1xYMya8NpMAEwTszAqiQTJ5obq3j+EHUMDdhagxxKsTwguXDWKducnJcW?=
 =?us-ascii?Q?iSFH3RZWYIgYYNplOlnJHt8tDc8s7OytWZolwzZmjBZEJisa7Vy/yvLAL1i1?=
 =?us-ascii?Q?ehKe6vuEqShU0eoAwkvcdkn5gy4xPgDo7bDUKou2ewoIzxnZqqxwBUaBfP15?=
 =?us-ascii?Q?5TfeToMBpvo40pqXq3ZhBNOfV8KJ97s3BLj1MVtdnY1G54RrTof+O6SWn7hZ?=
 =?us-ascii?Q?g5AHMiZGKkN4oYU+PadUSL4AiIIH5EG29a2JPkMwnwJboWLl94dceqIby7WN?=
 =?us-ascii?Q?ZoX0LB7i5kqJ66WDaeOrfq7bJlU+r6SRNw2LftT6OeA7Xnot/AZA1yrmos99?=
 =?us-ascii?Q?e5aTtRHzVmwtCixQpX54sLnQ6tqqNdGzsiWUV0mPR67nokZJzctr1HF4lvcG?=
 =?us-ascii?Q?5BtBLOIU456DP6Vq62Ho4JvlJu85KRnQSijDvkwQwm24wYUQqI1X7F9W1o6j?=
 =?us-ascii?Q?WPOV34XgjQ/F35vUTX6Ns8JPnsVesEttZUXchhxRSMWKF7+drHjPG+AfCLPL?=
 =?us-ascii?Q?9YE6NGgKIG41zgoL81GMUutBE9DTDjUjzy421TJBjAitnvy0In+rxeF+09yB?=
 =?us-ascii?Q?0IHOuQScfbB63msP8dg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JXO3tHO8H8bkCaAnkFWI41dhWgU/kjG7R/SZQuW6Tk5/FZ4yEZ/atKVJm+Qk?=
 =?us-ascii?Q?UdDs4MqjN5xLLL0PMuGm3DY8m20ECLmUwMsMP+umQU5wwaALI8I2Fa99rYiP?=
 =?us-ascii?Q?gl54iPk3UrM/7s9fw7N7CXepVggNgeUiZEnmcK8H23il8w4H0KxwuAF+OmMZ?=
 =?us-ascii?Q?PaM00quq2VOiFqY4aMxPlxStMxoIP5+3VPh0qfjTJmQs5k5usOgy5LOAbR7w?=
 =?us-ascii?Q?Dp1j0yTbi6xpBAdqmqBdIORfLMz9NVjk3uUEKKWOHENcjuVOO4UVgqBXG/1r?=
 =?us-ascii?Q?XFVanrk2VmIXHjXICoMKCMQdB6RFRRi5o3BNqby7XkoRZuzuBCdYpr/Df4qw?=
 =?us-ascii?Q?c3b8OVMUGn2GwMX/Qa7YmWBJ4cm0IFc5F/3zmgAsdSySNBKl2R03TO+MsXUk?=
 =?us-ascii?Q?Fgge/S/J8o6yXicFYWU6YXY0CtfhWcOTbwOwFYFYVChrnCcZk2sczvEPv0+5?=
 =?us-ascii?Q?a7Ee6b23qvI53HSot+FJnF1HtV7FhiKCy7iLnXnsLW46gmO/dmE8m3rC0vea?=
 =?us-ascii?Q?BiGF7IYSJrkiM1tz68CvCr9ZwO9x9CeOlMtUhdCfFmNYoJ8kpP3RT4sZ+6Vj?=
 =?us-ascii?Q?RbJ/N2vWOJCbvo1ojGCVlSMgKPNTHJ6ePcAmolfl2DOyibO++eETjVR/5z3L?=
 =?us-ascii?Q?nsL9rZx8FYijKuvMOBmIBF/ETsPinT/h+i1Zas72Ksqd+PU1hdcsjK0/udqf?=
 =?us-ascii?Q?XQCbWBByHrpwd/PWZoZUOvozVk5LuC4hpb+cTPg9nhwG5QLvUQuFGFXzRmc5?=
 =?us-ascii?Q?BXCWHY++nrYDVG23neNk7VWqRgY/G1O6BpzCHSKyPlgOaXHxHS7tsxUiOY8L?=
 =?us-ascii?Q?RrRf+rS3iLRPj1FJ/UbipSntMkzYJxSICCBvZvSqLvvc3qpjcQEwBsBzTVZ8?=
 =?us-ascii?Q?r+ADFAz6i4dqaJkZiDFxYxQ2BkEbPF++ilVaxImgljKAMGc7suYkKQwFU5eJ?=
 =?us-ascii?Q?XB9ydUDlgjkjDNm6yjlzl5G3gPMAZsKpolojxBDWB1zwIqcHW+BJioTeH+Ck?=
 =?us-ascii?Q?LOvR0uoGhtgw6tnumDhA/o3Ne40m9wSFwCw2av5g4UbIMqfRuGny8h3rStDl?=
 =?us-ascii?Q?2BfM++ArI2q69sMCIK8ek8BCttxPBlCKiMqMwnbWRydbrUt4hAPeyoq44vmh?=
 =?us-ascii?Q?m1Nc9rOZHgQc3MC2orFs/GGTh2pyym0LEaJ68yK4cS1HvWcYgbD8fHtNVc+V?=
 =?us-ascii?Q?hXn7B3UsLiafHG/oJequzBdMY1+ymMp2UHdSPozr1ji6exlchL0Jv/bQ+H2Q?=
 =?us-ascii?Q?lYLSoUeYlT2zSQsNa5oxcKjQ8KVeskdUvaubVc3tSZAKMsiuAr3P2JWyS0x3?=
 =?us-ascii?Q?wY+XSfAEPr7fRDKt8yed6aVhCmZGLJSWIqC9qsnqx+im6sBK1VzL/Fkmx4QD?=
 =?us-ascii?Q?RgtE6e0Vi+PySQNR/2+VWwx3W67qEMec1JcaDcvlT6NzwDbJqgmFfQvr+L6T?=
 =?us-ascii?Q?3VwAXMXUHAwY6bqUwI+3dFWwDObXdknf14VjYrjWHk74YWCIYqe2p8CPl2Cz?=
 =?us-ascii?Q?W/0En/xnVCtg8j9bflmCxsEdCMlFXwOFv9OzzGO6+rF5afaicpyIhV5X3W5D?=
 =?us-ascii?Q?QrSIZsyAzLhxlj+8Z1k9KQ5QbBKw+mt7CJesAx7r+5hSn7dVGxl/R1ZftkmD?=
 =?us-ascii?Q?7TowGVjBWpVOXrkOmunMbam3MlZO6YD0yjVQVemHZTpXg2chr1qBU47lkapK?=
 =?us-ascii?Q?r2vLaF3EUmd1Es/mEswrjYzRgwDr1mLErnIENU5UnOYhBhFUDU8LypYdXwA/?=
 =?us-ascii?Q?lJ8qPbscJ/ie9H8UKPA9L+3UX0AaX3E=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XyTaXRouilmHzymHN0KxGCpiIrYeU79j6aloMS39I000TwdyqI8XGwaFjVtFzAk6l9sgwrtIKTPPjjCjbI23MtjViiRh1re9+as+wNIv+kCMsybXGMmXGwcdaidHt1kXANGCz7kkC041bkbRG8zMWFJjhZECGYVvIZ2XovTj0vo7Rits1HDPGudF6oqAhffHMIgbCIFAh5QZ+AnvR4tI9p78t+ve9AWjBOt2XkhZhE5vNluOyzl1rleGAkgOve7puIrF1v6hIPIWTAsgw7iWO8grbdTCgPkGQE82cPjt39BbnMF63m7lTsLIO1aBx7+0/jgI2YdZdsaUmjkglfo7u/HOnI6vn/7igFzmcx8VQiCYNnhJRD88QKtkCBQiHYL4HQoAp4/tPW8bgpFXOb9yaij2Y3uWBBV9dH4L6hkz9drr3dli3gBQ0sqJEe80higg3uFzsKexusovAh6+CgPe+tAXAquZUPBxldZOqNL+FeIDdjCiqtQf2VKeYs2rsA0J/hpfZTyLJHGRQ2u7DpDo/ye4yi0bn+B/2JGBDITmNzayygmZOiJ5WQtY8s4Uyd4nYtO6eWG5cprQ/obkagG957LT27aLAZr0Es8/A9WDnJg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cfb11e5-e87c-48bc-9766-08de543bfcf4
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 13:42:55.8454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rFyBcnzZUaS10pOqpvXAGcfa6khrVgHNzMx0big7FKWWOBefsowBiOuexv4rE+QLJgCX8FT3ajThn3jYZgETsaFRsAb4yGFEl+5oIXpUsfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7739
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_04,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150102
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=6968eee4 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=diU6KDi3MGm7l26VfzoA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12109
X-Proofpoint-GUID: 6osi-erO5BNEcOfX2v-ZDxjZoQyiGQ6H
X-Proofpoint-ORIG-GUID: 6osi-erO5BNEcOfX2v-ZDxjZoQyiGQ6H
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDEwMiBTYWx0ZWRfX40bKqxntxM5F
 Uk6SSS+kJoonxUl876Px2GnOCL/Y71h5Br73HUs2R53SH2ulZyh9c2ruR/h2UX0+5eLXpq+QuM/
 AXVS1qeTBypjwpQbX3uSTzkvHKnOLWVEJQBPV/zHczKrccCZjRFplXS+A48wMjyOlyHxolotwQA
 FC91DVnvCWmYdw+jwtr1n7o8lNn1BHCr0dMdobD/LFAkeHPgy/AlZYWrXo7OzVDXe1MOOIaCPTK
 rLnn4l6ClDU3uJUnSxotvzRvPrJC1bpRBnzi4I3Sqn4h7Q//Hpq8DE70rgZbzVzM6bwKkij4j84
 zWK32ZFfhqS8CSjM43X53VniF/GHAZsiDc6H+y0XGw+6+8LpI1QuGIfpAJMrhbfmo3VToJ+nw4u
 XFz4Kt3TjX54M1v6aZUTqX0xKh4R4PydOAqOqPz1PkYaaEhiYkL23HlxKzaWkZz4RBMiNtiB/My
 SrXScreTySvtUomB+8ePC3akX1qPkgxs5txU9fxw=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D36974000D
X-Stat-Signature: aawjn85ixco9jc5rjnpu1tnbkyuybhye
X-Rspam-User: 
X-HE-Tag: 1768484598-268264
X-HE-Meta: U2FsdGVkX1//5QXmr0EKcr9h9fdT0e8eTK4GRu2+WsJR0wQlsUc0nqzfusufaqYh85WZ/LwsTei3fqZfZmia844lS3GMJ87ykclc5ArH4HxwpI+VdocV8AnBduvuQF+XNPphXYxXi8hk0aNqGwMIM+sJ7RXtV+8+RzFbGt6wBGN996It9ALVS2mr5YYFp79k7KwKnfYbpM0DDLIp4FaS5Km7iSXwquTXhn2uqJi3cEfbbj4DemzZJmUYwemPcW7fUM4UJhQaAt0JKIuKmPbuC65gwsUPxm46xY73RVwLgPD2S8Sq3tXOipN1tAGnAJWhH/B7Sp3wyUs4FndXAUxSAOL/afNp5y5fgWwXCc6XFx440996DvHImLNjLxblEFleA2OWk99iv5bl1BLFJKPfq3yUqseM5hsauqtKg6VUzFqGKXyQGxesJYhf+2sto5A7xTQzcluCrL/gOWEluOGMgrfXDF5p0ukpHDP6fb5HlxOGY6XwhgmMiarTA55bIJaepijaaEv3PGO64+fzy2DOSpqzthO6XdlgxLc7dT7QcskMlQp7r6FhaR+RXRhuC3tMUpo3RdJJj2C0ZuzNAg66WPT0xghmB689CHaGYFhISLhT2C+p2B8KAgTbMLqE1NU9Mj/A59TfietVqROYdq0jxJAvL609dm6TzPoFWzHjUda1jDh+oddKjUBLMIYVlJN8FfM/wJMn3pLdLlSrV64E4YtUv5K8r7yH3/8x1ajY/WhCHsx62caHSmYg8uqfMJZz4KLtwk0NBdxzLrSIbW7Tmq/oBo0a9Szn47yVXzYxpqKmtG/RLfbmb20/EimRW5HrJXwILETXj8ExZUKzrsJ9sLGEo/J/AKBwJOg1K8wO7Mdnz97ZMyN9eUxgFsV+cosSbT3JDuO8FBSa9epHnS5PG8TbfGYEp5fodcdO0u1a+AKK4FwREqesigRGA6XTzMFlD2e4S3N5BNEO8+Q0b24
 tRdm9ZI+
 f+ZBV60lniuziqX1YvUvYbNPOPtXzHZoXkWDyasYUmrz5OLBRxnS2dwiRmyNBbU9xy2HHU6s0Ax2vh+zCaTQ3CQT567RwsYzNWhcIiLlrM+rdKcv+5XRqajuJur2HIlkapQiEJ0LGOHpVbJidYj6vEX87MUWGrItUUdmDsrLJo4heU93V7lOMgAYABgUbQ6n2lgZqRO2fdrl7DAZsmHkd0zOtxltyR17jjRdM14TRtc7ZaZ9UglzX5gK31tQGKbEbSxDvtFh0WbiIR+9aoawQ9fF/EVCoY2iLTPeH6zssdvfQwV4wEfv2i8dGhXkKp1ftu4U9F4v6Rk+OMEuIWU2LRZubTHV2YdSC1pCoof/VkO3G8JmToesscCODbEDW5zVZsyEkXxe+CgOJ4dMuGMoNPf87I1moPT7r/ZZWYfKj8mudL+4JDb03xTRuNr+yTZJg4Z6zE2zBvkzsnA4kZK7KAMh/iuSR95JR2tUO3/6BTnF3dNHgduYhx88oBFvlURHLITw/vqucit8kdGtAWy2czFsyI5jZUdCvvJeu/WMWJ4onPBA6hOVc7wMhoP0CS29UOT41XnRYurr0Q7wQSoraE9RJQ3b/kIh2ViVhOyUi5ZN7RBwdMszOT4xYfCIZQaPlbntIW/DX0aomaxBszl1OJzTOakroQzc8QiI2KMvbhEP4Y6QAPHa4o+s/xdttdAH+b9pF9JXqNO2UNWuIUPrxW1qf9CsShw8rAIDgwxovpO0Wn6kO765VSTq4gA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 10:20:08AM +0100, David Hildenbrand (Red Hat) wrote:
> Before commit b1123ea6d3b3 ("mm: balloon: use general non-lru movable page
> feature"), the include was required because of isolated_balloon_page().
>
> It's no longer required, so let's remove it.
>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

Seems sensible so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/vmscan.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a0e3f51de749e..cd9f9a779e89b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -63,7 +63,6 @@
>  #include <asm/div64.h>
>
>  #include <linux/swapops.h>
> -#include <linux/balloon_compaction.h>
>  #include <linux/sched/sysctl.h>
>
>  #include "internal.h"
> --
> 2.52.0
>

