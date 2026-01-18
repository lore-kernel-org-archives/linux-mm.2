Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 619F3D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 15:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4386B0005; Sun, 18 Jan 2026 10:32:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451CC6B0089; Sun, 18 Jan 2026 10:32:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308BC6B008A; Sun, 18 Jan 2026 10:32:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0CC6B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 10:32:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1363160502
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 15:32:41 +0000 (UTC)
X-FDA: 84345476922.23.14D1435
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6511140006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 15:32:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="n4j/nT8b";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="nTb8WE2/";
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768750358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ULFEYrc5se/3vlb/l3n2u+x2S6JHx7geI3w/EG37CMQ=;
	b=DzvM6PBITbXbtDShk1hDpbwt9tYC5YPamhekF3dm7vaR/1ZRayAcV7KRtCVH/SDO1ooUfL
	D9CAZsLFIOwXTIYPw2uDI4RdGYJxPQ27De1dcCuqxIRxqAReHJMRCCFUL+YRUjVo0loc+R
	jJLUC430KF3ha6EmYPm+wwXjg5o4Y5w=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="n4j/nT8b";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="nTb8WE2/";
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768750358; a=rsa-sha256;
	cv=pass;
	b=XjnlUp2iOFCixCDbvDkMkCXvF4oLjyrv4G7Uo23XGlnJwNRT4y6UYK6PUEGy/jcTc25ilO
	H6BnR0Ziip2op5MMeUn9435XZfD3dmWfiCdcQHBoc6ESy+3POpbRbcXZYxKZhazqs0afvu
	SVdAvFY6lMcra2mwDIUvdthob4S8Drs=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IEZ2G33666626;
	Sun, 18 Jan 2026 14:52:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ULFEYrc5se/3vlb/l3n2u+x2S6JHx7geI3w/EG37CMQ=; b=
	n4j/nT8bPlXapbLv/kc+bMw2fqrb/AEUfzCqk/L2d8N6b52K/LhIdWoJCtIMSWVS
	JHtMYGA7DVStHivyl1p7Ps4zbM/KiFfhkXUAtrs9l1zkFvrxMATOu09tE9hTRQhH
	2LnylPH0mssxaWS4rmHIVEt0MHxKjjqrAzo+MkT1goLYtIi3awf0K/fS3j7Zc99j
	gUVksnJu6NIb7RtM5P/TVgwF5UPMyKrlwt/gW9DTNYE8TUEqBvKsLqaUE72YWWKQ
	Rv4UmDFeHsKvEfWYKD0RTa3tyUnt7xQ/C90V02BUmEq4XNk8QznVuFFSnQXbHsiO
	qdp6t5W4JVkJL+5TbSfrNw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9hcdw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:52:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60IBKgYk040563;
	Sun, 18 Jan 2026 14:52:00 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010017.outbound.protection.outlook.com [40.93.198.17])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vb7dbf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:52:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HNBcZoLurVXoQQ11L08hHHmj0JfoDHvGP+tJaiYiUakEY8gQDw2ByHlkeYGmu4diruJnSGSeUyvKQY0/s/6KRFbOKl6Nzj5UFwkdOHdlVPyUKY1o+HXQd0OsVeUKNU12fhlzTFI/HcmYPL7d432Z6wlZoTxuo4eC4Jum2hUQi8M70e0u3te78HZk/Sf9ruFG5eJ/va8U3KROfbNLaWavaz6OAz4M9dwKfFNyGkNKkk2HulzpGSE43fajTI2R7UzXMup24jEClpId0GlNVsuNzu7Hnq7BLhcZmXMr4SvriOUrooFf9InB2wcG+bzYqb6V5RdaMhEgh64A3FG4yQhUXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULFEYrc5se/3vlb/l3n2u+x2S6JHx7geI3w/EG37CMQ=;
 b=gTX4AmS542sdJFfvzk4wOZ/+KLy6tBfco+nLK0B68ZV0GIfAX9iHZKKUyHTTlKuThdVN5ATRGrP7Ou1XXXMzAFSP0KR/Iz0oOY5NcnS7pFR/EMcGPxhzO9C9srIxCmqlkGmq1ZG7e6pSZ6xqplaUsj4KpzK5CQr3XVnx8SM1Hctlk9XeAEiVno77qdLL86cBetlFcZXv1DnAdK5EexlFtCn7rG9ishWodGXjT+wRVYY519AwYVYxuzZ6H1JxCEyOSVLJcmKXtK1Td2lqTpGLamp+aMWklzyOBjnIV7nGexZ45Bb/OxxQ4LOofvF28cJ/Ytiux0fhEFzy00+F3WrBIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULFEYrc5se/3vlb/l3n2u+x2S6JHx7geI3w/EG37CMQ=;
 b=nTb8WE2/4p7R4lFM6ETwmRUWa+ObMYdfDOENygsvvO5ytcP/RdT44j6EvUY7yFA6aOZdOenIyWl8MkK0znqmXQHA1jhyTPKhxG/kNrfH6hVcuEPy8FPZoMZHEvmOTLxW6LKNx5Gm8WAOQZi9dAEnVC2+kVIWSn+N7FIG8ltDZdk=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB6723.namprd10.prod.outlook.com (2603:10b6:208:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 14:51:57 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sun, 18 Jan 2026
 14:51:57 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/9] mm/mmap_lock: add vma_is_attached() helper
Date: Sun, 18 Jan 2026 14:50:43 +0000
Message-ID: <0172d3bf527ca54ba27d8bce8f8476095b241ac7.1768746221.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
References: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0227.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::13) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: df268116-29b7-4863-9e03-08de56a12110
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4v9M8TfpjhqBa18vnY/2JWZT/yyOwtiXzP9KXibg8GPnJ7/QurtPDt+FSsmf?=
 =?us-ascii?Q?XFFJyIjSSjUo9QmOF3ZTD8zQ1N4iMesn6JNld7UlXpOMjJnU5iD+rRbG1NN9?=
 =?us-ascii?Q?LkX82Wv84uXNVhQzRsGk2pYpkfun+MAx31kJ1Pp2en6W6qcWbRcEa9KTs/9H?=
 =?us-ascii?Q?DXUZAHdTuJ4ezITsWRbSFmjbDHWT4jD+odQGYv7uZjegg5yds850S2VAdi/V?=
 =?us-ascii?Q?HZS8tTe8QcE8qshK6xNt4GjDXJm96lGVno8FlP9ct4rLQ6uXFWyMaUAkPIGa?=
 =?us-ascii?Q?LAbkhbcvA6qEiQ5diIGk+dnv+7PLPqLjUBKw8xvAX9A9DLMLIsfIeXy82D2n?=
 =?us-ascii?Q?v4fkaxqgLgMQJrcxIOAqaQ/Hfiw0ZFkMyyBAyvv2TIUuROd6asLfmez7HQ/O?=
 =?us-ascii?Q?4sKXB/1yTMyx7I0bYC1Wr7rgVukRAW0D3JZutq+TKyN8S6CGTHktbgaWR3s2?=
 =?us-ascii?Q?bC7eMD1sPMOijcJkHwDewlVw5DU2mqAd8r8J3fhNEkenaJFzw+WvotyteOr8?=
 =?us-ascii?Q?KbsFHJjobrFLMWjonOhCBWGHSBcj72ddkuWrk+HmNhYpkYskDoLoeoeFfCPZ?=
 =?us-ascii?Q?57eUZP6gGyaXd4CfnXJk47UaSY7qqpFTpyjUnT82AVeetc29i9PCBjwUQESu?=
 =?us-ascii?Q?1jZHPDW4//2H6iKCTVOilxR96GMrebKh3y4bOkJpKcenVlhpn/HbgQOy2re0?=
 =?us-ascii?Q?wp8IqfJuH+sF7iJ+sLokEPhSZQLgtV0ZmqDJGGDV+Y8Y+X98hIzUlTtYib0B?=
 =?us-ascii?Q?jPg4qSXsvEX2ayRoKOkX2+yLQ5VQuO1zl3y0B7doHkO9K9d3xKrfZzvjw7/4?=
 =?us-ascii?Q?WY6WlRMnMtj5KsyPOjQaugpxVoHUlrp4LkSvSotP+cbr6eiqwdo74PBjZvJe?=
 =?us-ascii?Q?Yjymr33rgvhPIX4TbmEfU6g+nHGw14J0ge3EMCbwEA7aQIsu7BE9bBO3EEXz?=
 =?us-ascii?Q?YwHEavOJoBsWdCTNZjbjib8ZCntyZT0YDij9rs8nfBpX0L8Tjxc06GyFH+Ir?=
 =?us-ascii?Q?f4nyc5HrKP1o/xvt4ksfw19Y6YV3ClS516KauHUys27M0n4XVNgAk3otZAyf?=
 =?us-ascii?Q?BqAOydh4YE9gi+ncMXKRjVuDVOAkfHWMt2T3nOEvuwSLA47/nHSpPn3S3ZBe?=
 =?us-ascii?Q?BLrc1SPcF8NCSbc+ia7t//SQmtozzeSJwr0WgieeM802yUrzKoFZudL56Mk4?=
 =?us-ascii?Q?o3RkuUTthFIa0ZZAXYRU8EjlAFblESeK2yMmk1Ta2zco2dOIlLWOcmDmZzq/?=
 =?us-ascii?Q?c7RTWzEa5+QxN23KMcfgZfIvJ52UaamlzgwVd3pYQP9+HvZm0wdkfNEdvl9n?=
 =?us-ascii?Q?oktXHo7nHP2k07nE0CoOHRGj6mQLtUDBFnX4kLsuwVfM4AFeAFQ3wPv3IEbt?=
 =?us-ascii?Q?ZC+P3mqNJgCHdVR8JQMzOzaIYE4dKVJimcctir4dcwx5OSp0mdz9Z4AHNjCz?=
 =?us-ascii?Q?z/RCn96qiPo7Fb34oyFPlVt4+d6bKlzGo/f9Rmw03RPAtcnpL80oj2HxUNrd?=
 =?us-ascii?Q?FAthS3gRKpmMOyp7ovJlTCg/Q+qdZ633W71CY65rNacSAu8+UMfzidoetoPN?=
 =?us-ascii?Q?xrGpK9Ey//kaHROjjaI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CWS7DbPhcyG1b/3SUoXzm6aTnm1wbX/0iaP55h61l5bGF95qGSSjVgegoh/t?=
 =?us-ascii?Q?kDRScVfx7ZjTX4ol0PlxhAp4MkT+OvEFdUr8Qg7HyE/TMguja3fSI3Lqgwz9?=
 =?us-ascii?Q?Rxt+YDusGXfpBgJvqV21Vq1rNxdAXIu5F00L9KUuvsDdtPtCK6ouRcndDwcI?=
 =?us-ascii?Q?Qi9FYsrEd93JPHB6EA3jPflJyfPJ+ia+slzyVqKzlz0F7nXCOgyMjCUYsr4x?=
 =?us-ascii?Q?LeNrHS8fNdNeMu6OQKvCidNCB3GNjA09SdV89UVQ3rfbZU6+qSLgGVc8koO6?=
 =?us-ascii?Q?CV90qEgQkHEWuIjQyq3bs0fZtBzapOvzsNdNh5TPdO7dGppuIpnQyl20NEnN?=
 =?us-ascii?Q?Tl3kP8f3o5AvjG6E5Pw8JJTWa9577kXLSaGF+28tCi/fTCieZUQKI9fGKrCF?=
 =?us-ascii?Q?qo27p3uC7rho9MxGhw+Xa7sgfAZSvPmoXPNz8YV6HbXXZph1bFcvRFVtI33Q?=
 =?us-ascii?Q?qLfB0gM2NDs5yz6ZDz9Sfyu4fNlqeXoeXyDwlFmvFvVhZv6Zxr0SUOW+xZWY?=
 =?us-ascii?Q?bfPDeGwtCIh90hvk97qCacf6PfbSekm02E8bQVfVy7dPEwZxoK7pmpIXAgoS?=
 =?us-ascii?Q?4QIN9dL01jSdLnGvaXJk/xE9tGiKpMqxWdzjAq9jqtAfypYtox4asvhl43jS?=
 =?us-ascii?Q?8Tw5+4ZlPiBy2+dBVL4e1i3F5asYw5BqHXt3DeSpoZPfAXWk3IEKmt9wuaAa?=
 =?us-ascii?Q?xy4D6pbgFFX9Js+bCt5bi28D6bSlEN5F/FkHvWsqctoZe9dmgKg9FL8kcLYT?=
 =?us-ascii?Q?b8IdG09rsFT8IXFmoF8iyBTCbcCgGG82pcsVAjt4xnYeXsFe5DfGD+sbdlFP?=
 =?us-ascii?Q?2dkx3AdTkRitqze9B+5vEy1qGT6rvDbN6YhKGTLe/H+XNRzdNIj310doQE/4?=
 =?us-ascii?Q?j5AuXiWPEo3chdlGbLYBAZOQRIXONcsrY6Dc589PrZT1kmmV0yxQeP1Qq3rv?=
 =?us-ascii?Q?gc4/ZEs8vYKfNepfZnXYkrdZofVg8OHgFwOZkDRfaBLtlGw0P68hvV+Fx711?=
 =?us-ascii?Q?8Vzsok/juXSGahIhqy8jrgHUQgTS14UW53G5RDRiKppuQm68z8e6AT0LEqAh?=
 =?us-ascii?Q?ewZqlUncEaZhJa6tAGxtw6rtuBAjfxX8GqsDslLYUSdKifphIYXp+zqyUGVz?=
 =?us-ascii?Q?38IRgZQRErCecf8/oLWC0raiYs0I9SmzwcPx9NMIEe4pPAuZrJSVl8DItoW9?=
 =?us-ascii?Q?m1MUEJThVSGwiIdFZ1C1jl75+EJiIDNONO68DfVvKUPUswPTaUjBS0brNFHu?=
 =?us-ascii?Q?kGjhorIAXSLqZ74t5CbwHnnSs1a8FYCl1FwcBlPP2XFbYWUPcczwLEI6wxHE?=
 =?us-ascii?Q?piBHJYfcj91LwQrHxeUq8QwZXL2VIdGqXOLEupXxVHSNMbULjihqXP17vOCc?=
 =?us-ascii?Q?RF7XpEihLDgS0co1Q3baCx7c+81VmWqrCEkCla6NQMgaIEbNImiHjl4Xgfpe?=
 =?us-ascii?Q?AMtkGzNxU/1qRFwIvnzZQXLK69+s0cHaX7SZ5S5+1mPKMeiR6rsJXX6b3lCD?=
 =?us-ascii?Q?H6aFcHwi7bcXTaShK4vv087BxSlqFKQwm3lJ2s+gBCVvTvEsTM2iOBAAuKB6?=
 =?us-ascii?Q?ZI9Cv60Gn6qQaW8NyMiPSbdGC4pahDaImChpQm3ZSJQwjbsZyq+MwRb533H+?=
 =?us-ascii?Q?1RY0cGRSikqSd/rpaJ/izMGTzDbIO2+PgEO2kmWvUZKMfF5AOXP8tNe23Lli?=
 =?us-ascii?Q?IS3KNP1EHFuRuRK2cPHi6kOv76tNAbf9r2s22gVUOwCynWM9YofBenvC2ESp?=
 =?us-ascii?Q?wtGgEzoerSIWOPFjAp8i1/h0LYp6U8k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QjI44wUHJrOBudm7aPFvJUKOH8p+zuZ08TgnvHUu0BSoAgihg5F0z81787FfPla6AyJjQvWFbh6T6Nk8+2nNNLSvyfDvJ63PYUO+mqw8VhuX4Xhgdt6ELOXKn6OoDv+LJjofrQ6+ujwau5uNuSoY7oeZU1xvVyOgvTxzq6yCawz9Z18UCNAtaoPYhsNJMjyOIf603ZjJ+5zZqiQGSiEYbUsVj7w+gYxEEzN0/lBmpO/irmeixGiCuO4gpLIm9WSXPDToyL8fPqa760K3lrciOtjE/BYgc9r+ekKAqJIFMDyUUrFzjltPXVAx/aQaMJ14RSpg1ijD04qYQ3yUf2dgdTm1nX6z6x2wjyMOeAVAB8O4XaUVC1izjH6R606c2uGgzzJKJWcXVhl9OhFqXj+knRcYLpcB95uozfeo5S0yeDY/lNrc0gSPwiUjPVuUhXrhB/MqZmQe0CMh6wrXSyB/M44t/HxOjQiEQCVRU2Mj1Uy4OYTdgprF+AuC+Xepf4T27AR9YKoqDQwW6qi6g4XAV/voWJ3deg/RZyhykXsJqxc6TyHPpJT2SPhnHPbfdiypTW5S763OGv7Xrix78lGJupCOx1qLSTb2Z8U2XOYBUGA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df268116-29b7-4863-9e03-08de56a12110
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 14:51:57.8477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bwzRhTcQFk0Z5xL8ZTLbKSnKxGdPxJrmwmmGwlvLMTmex9uEgdoJ3H6UFMuAPLJUvPSCDCg3GszMzIj5EM4SpGlKjtCek3tFN1rJm+DYu4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180130
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=696cf391 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=_f7RAM-W_OM-GOxaregA:9 cc=ntf awl=host:12110
X-Proofpoint-GUID: oCSU6vXRSZeGoBe3-SnuHa48Z1o4sqhY
X-Proofpoint-ORIG-GUID: oCSU6vXRSZeGoBe3-SnuHa48Z1o4sqhY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDEzMSBTYWx0ZWRfXw/D99rHh3y+C
 xIdkY8ARh67ren9Pg2M9wFz2tzIZL0OKbxJneBMNJEmrIUKLiD41KwiZol9Bvf09zK1Zt/emgpe
 TxDK3AihVstBzTzWcc3FnZi0rlq+MYzuB2JIzxYyqPhNr3ML/nFkpRt8GsXIHzGtPwN6sU2mgir
 yWEUgkFe8ppM2eydUmC6ru+CxuQRh7r0Spp1+ehYy1wOGcB3gjI29cvRAeni8K8mAxLYrIhi4cL
 rmc7UadTremXC60Ur3I7KmE3gGQ2+zXpHJv4tuPRckJtmfwGCkTqL2sT+1U8Z6uRUbYR03ZRAt1
 yGbaPMRN1aZ/iedn+m+9BG0HNzRyMUgGTYczhYPNINJPz/vVQRPXzM2uvVftunNZ1w+mxDKZlex
 C8jjExuLKDBiGY2OuJpKG1k0UDI0hBiscebTrcPcYgUTjz9MYPA+ixEcWoUivnMaF2SSaOiN/me
 texubIOP2U+EzU94MOoVSIy1NktmJwpR7/sZrKy0=
X-Stat-Signature: 9tys7k3rqcc96wrkkbzb8sktrdabuhqn
X-Rspamd-Queue-Id: 6511140006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768750358-641972
X-HE-Meta: U2FsdGVkX19MksTLKOXIp9PR207SAcqyL71lHezDMBjgxhpIrLBf3kCCL15qpDIG9SAUVdHXZzYPmlpPqufaJm81VB2fhWSXAMd3kCl8Cy8V64EPjk7N+GSgFHspBYJgnx357nrdhmn9G6b7XZvJ1QWdqQPza2PyhZSPv9l9kNd+54eCDwEP2MtcHCW7ZSX6VxP/blAZR/EsDQDpn5q9n3uEVrPrThc276WYnJugBRTPwWQTRug6HMTPSeyLbAhMaYOsmmQ65lTmTfC8T/vUjzF+K9F246XM6Cg/dig+pJ+hRiDlX0NDsfhHXSwChSR3gyCRVZRzYNQsJaME+FLH5vDIWxPJvpfPH+d/Fr66/rAh+VZGgZuIue3ZB3RQabqwPsSTO/MmP4tiM+ClJwNx4vaWIsys7Pagv+GC9w2NdPZrHU0I5u+QYCb7Y5Sd5rUGwG7gEultRX1JAV9gxOOVhyRZvswWc3+18Vma1CyXWmn3/AWzqHhhRapJu0Ckh/Uy/hkWlpq3IfV4p6U8axzNCCmcjpTJHfQrMaMZCF3ZPgBqQ9KD+gV1nwZJiZdBVUA7djYXWeAe9zi6uWrRArnz+oypHdHA1Dx+0xhZ+R76e5Az4c6P7Ns+7D3+sqY/HmouuhNJR5vzprilK6PIsuUTCJvvupKpmI69oKVWUkE6ykGfcIr1tiYKEW+NAzqBd0ARBSFgRp4Y9rWTk/P+Ol4VmQgIETcmjvWReqceUOAoh6gQ5ROt5ix+fue4KJ466fyyjGb2fJ4EyeIrGz+ARqPKXUywiSyHrkhPaIlOVB7nezEYgGPEiTcg5UL3K1dle76h6bUwR3GbyQMorX6vl3uv6luqpJfvUe3GGKuEy3LSUaibmrxeSNqUHB+CR6rjfyEJTOvZLKm9ul5rCpjAXvHzw0OAkWOKfgI9GWa0M8SbBw+HO+tnTDHBFqMdWqf/vL/zlVwt0KRuSk0nRwQ/fIm
 oeabLUFV
 g0Uf7RxKfpxJ2UImeEOceZ4qa4E3JdUC8BbYT70Vs67w0Y7IYOmAPiCGpJ8JeLqOzc2z2Wem/QQ9vV5NUD8XmSp/LdicFSNes6Q/8Iy2a3/VkzoQYwUrSWq0y5+4HTaQ1KZXiokBDODqj/qgXoaxnCSsTsBYk0de3ElfDOGvHrMJVKlZACUged9jjdWiYe3m523RYHByV6D7jl31wDIYwLH2l0wvj3Ezxy6NDdQvSYEzLWmjnIiVPxVIfE40NIE/gUt6KLVWKfYDEhu2tPcFk5kYyRb3CIuBZk6j/52UeVL5ZVW671Fm7aKuzT7fvIN33lkS8kYf9Vg6bbTu5uZNV/48PCMrduNgtAfm8sOJoFmw8hgVQC6Un5QLuDLL2Nn9EfUqCOK+b6eZm6J2pyMobeW5wEN6I0pN4pO2mz0sbwrjrAG0MPl8JoMhiu162jMAyVlO9FwbiTsa301e2Y+qO/DumWJjZlPJGdvXvoh6psq05d1T/+wfN4P1Q4AXxikfeTGaBZtOli43KBjLtdjcFsPLZTpPjYJotkdLtsDhNi9JQKR+wT4PnD9yuySRUGXEzogM530ZhtL8cABf/hNgnwQxbjtrKDh5cv7jVQwGX1ACxbUNwzpBtBQ+Oz2fEbosxspkT3pUSvHXLRnSxTQqexdO5AyoulavVaGo36vJIeWZMPQTBbrCM/4kA7XKO5znB61seUXD+4vCD33gzZWMc18T5EdeNJrcuk72A0RpCh+1EhLCXBssWonM/lw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This makes it easy to explicitly check for VMA detachment, which is useful
for things like asserts.

Note that we intentionally do not allow this function to be available
should CONFIG_PER_VMA_LOCK be set - this is because vma_assert_attached()
and vma_assert_detached() are no-ops if !CONFIG_PER_VMA_LOCK, so there is
no correct state for vma_is_attached() to be in if this configuration
option is not specified.

Therefore users elsewhere must invoke this function only after checking
for CONFIG_PER_VMA_LOCK.

We rework the assert functions to utilise this.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/mmap_lock.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index d53f72dba7fe..b50416fbba20 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -251,6 +251,11 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
 
+static inline bool vma_is_attached(struct vm_area_struct *vma)
+{
+	return refcount_read(&vma->vm_refcnt);
+}
+
 /*
  * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
  * assertions should be made either under mmap_write_lock or when the object
@@ -258,12 +263,12 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
  */
 static inline void vma_assert_attached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(!vma_is_attached(vma));
 }
 
 static inline void vma_assert_detached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(vma_is_attached(vma));
 }
 
 static inline void vma_mark_attached(struct vm_area_struct *vma)
-- 
2.52.0


