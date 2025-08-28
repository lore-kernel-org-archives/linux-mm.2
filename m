Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 622B5CA0FED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 00:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82E156B0005; Wed, 27 Aug 2025 20:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DEE66B0030; Wed, 27 Aug 2025 20:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F566B0032; Wed, 27 Aug 2025 20:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D9EF6B0005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:55:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF64E13A28D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:55:21 +0000 (UTC)
X-FDA: 83824347642.02.B522450
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6FF3CC000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:55:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NEYnlYbz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U80caBFp;
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756342518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbZD8hlqXC3JI+N/GOKNBY+RHtp3fHxbAYIT9Jl3O0U=;
	b=JuhYRYjw+xtG5gKpE5Wq0bjoEl99p9YbREVu8IwfX/3/PwcdvbwCgI1bzxpXVhAgBT7w0/
	l7VdbjTTjfFhgNMgIj2R4TahDuP9yRpk3aCGcITM5uw+Z1kdkhrZG/bAowe1gMFpLV3Xek
	jMqWW70FiPyxFYeAYexYbtxS86plzOE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756342518; a=rsa-sha256;
	cv=pass;
	b=ZXDFKuQZzqCi9QzuvKtJzmmLTRMZ92W5JjLqU8gM6Wd8zecvPxuz4gUbYHX6Kv1jHpg3v7
	X/wvFL+WzmiEqFOU71Y6qwpu9sJ48LYxxxNbY3uqzMGK7XyVMnGA2Cgxoy/Q+aG0k8kSmG
	ilMIIQUToAGA+Yrpm4IsvyuqUuYMkAs=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NEYnlYbz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U80caBFp;
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57RLHM2j003693;
	Thu, 28 Aug 2025 00:55:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dbZD8hlqXC3JI+N/GO
	KNBY+RHtp3fHxbAYIT9Jl3O0U=; b=NEYnlYbzRiVEfJAj77woVhqNnwYDNMYloZ
	KBpfHUFoBZnhhJWtsY3wcgTtEamyEu65WbPhOniEJtS6GxEZWzoprRSBjOecvHVz
	NSvym97l7B47/3aTnxM9D4uMg2HMCA7AT9ACb3Jheoev5fig8SBAU4I82CbsHoT+
	R5jTOceqCr0QG3YoOlRj6fSH30ezcYmgWieG3SXIh5QoIBwa58ETBBElNunKs36V
	svwbPMFPsxnFMHnALl3aJJLUM8TZ0FgPGj1QU7S4iduFhA2uO8hFIkfR27fRM2hm
	HoriQX60mYumuK1t2+NXSaOpHoewT4dFxVoBgT5aaEfebAmRH/rA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t7dbs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 00:55:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57S0ajGM014573;
	Thu, 28 Aug 2025 00:55:15 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2046.outbound.protection.outlook.com [40.107.102.46])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43b8s1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 00:55:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cxmyayKdr9cLcVwRbteKpW1Zmdhzj5+wURi/Eqr1qMI5xbQCR/ManODEu5Cllep0EoRCcJsgF1Omwd4Qzm+5Lrv1cvnwbrYbm5y8GryWe5BvAplVLt+5DZeTbdV7b810JhuUBQYE9l34udRodStEwgm9BREE6hFtyKQmbNPdKEMcs3OJ5UrVY+7Ctx3uRoZTZMa9G0OC+VBbdKEIJBdnWC50DMAoGIGFEY35a/KkWAySTtFp7+TDm/TD8aAmPxR8kD7vhKdMnr52Ac0eQm1IYdYEXHD2SrIV/6Z4aVr7t31zAV3WXWq5Oy3gHcZ9mdaHBFUEjKBA4d8B+gEgsUtxhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dbZD8hlqXC3JI+N/GOKNBY+RHtp3fHxbAYIT9Jl3O0U=;
 b=zUHOrQBjnhYtItmD0sqLcQ79qbDwMoUnmDu96HuDuO/VHskT+xs07xn+ap42F/nAmB7hgSpErWnzktcoqfnEpOVDAmE/rO/afIoI3V6ZTIPt8JgGH8V8ZJvUq2YcqPtk0UZsbDM7G7HakWs0YUEx5hWnxzMooybzpynpn0h+D+ee+9JEELWTTXikgku5p6w6IUdgmiWCISpo/+AP8bY5GRZXYlivSacqSUyulWBhUcqbAqjYlILebRj0FjJD12vECjinDpg+dTmoeFo+LWTe9qq3s2281zgv3NVgx+8xnq3vaaQk3jJljI1FHfEtXGXf6nr9wdrSP8osYu145/EeHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dbZD8hlqXC3JI+N/GOKNBY+RHtp3fHxbAYIT9Jl3O0U=;
 b=U80caBFpUJwru7Jbmqmg1MAnk0p0BZdU+ed4OAgin8GeSrgpsXhifG+BwjjdYK5UrdIAzSOYQ/254RqJ/he5Sn1THn8GOwK2H4EI0cUpGDEW4hVrp51DlPkhZIod8yo1vtpPKwHNCt1WcLV3z7bh36ndI7/eYhbYncmluMQTtS4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB6750.namprd10.prod.outlook.com (2603:10b6:8:133::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 00:55:12 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 00:55:12 +0000
Date: Wed, 27 Aug 2025 20:55:09 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, WangYuli <wangyuli@uniontech.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/testing/vma: Clean up stubs in vma_internal.h
Message-ID: <tldxsryzvi46gpcnbn4zusudc3pd65hbgvnhybtkkdusyfxj6w@6qy6k4gwruuf>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	WangYuli <wangyuli@uniontech.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250826102824.22730-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826102824.22730-1-lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0263.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10f::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB6750:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bb28e8b-3530-4fc9-6365-08dde5cd8b3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h3YEiJouHqt7T88bSNLkgf2UOUVh6AD1yF8Lx12T+YkaJin+6R31HxeKwV2d?=
 =?us-ascii?Q?uHjLFGf2BGBCVhxyOuUC3m2faY3ibyG1/lqb3N8lvoNzXyRyCczENnQdzm8e?=
 =?us-ascii?Q?pltGTzB79klmgUK7BPm2mXsDkoonzCH0JHELlB7Snts7vDOHamPcjoTU769C?=
 =?us-ascii?Q?9BYhaKJwjQ61ma+196O2nqHBt/pplSN9+HEwKmwv2wImdXoTVA9EwACTy3fb?=
 =?us-ascii?Q?gicEasmg7jusJyfrE31/GNZlPdDTmAa9vhiwou1f41xELfIFmKpuOENR3ntw?=
 =?us-ascii?Q?WW9D2jPhV+zE+phrhtf/NYeBhPQwODjfaC9PYgGCXn3g5yLXmNXj6T1sXaTQ?=
 =?us-ascii?Q?Gso8WSDFynqShNEe9jbvccR4PNRLcYSFDefwfihikVCa8ciyw0qTpdWxPXPx?=
 =?us-ascii?Q?qcO/1T4hjTVk1fNMnMUoEE2UY6osWeBC+Fqz+G9rr8NQVjpSsT+CPVg9+dgP?=
 =?us-ascii?Q?5Q2XzVSpYCGsHwGvBKjOPaDBosW84T67N4nP67v95tQLKK9yjzYAdRba0/86?=
 =?us-ascii?Q?RuJeyLKcyUaG24abzqRvXZ5ZDwIG4PlqrhCDyLTvNRk6VF8v+E8bBW2+4RxR?=
 =?us-ascii?Q?61TWvumuxhF1rBtg4JG65LWTB9KuycBIhC9G8BgrRl3evsKK5aCXUIEgMH98?=
 =?us-ascii?Q?MSyjb1MHxXdC+58q7deR6g6YHVdFNFc2H/JxofE3sPOF+IP2KvLxrPQhieQB?=
 =?us-ascii?Q?Z1sVMi/hEOxr8RxDvZStDFv4z7wlF4r+5U35/889Q7sVKGy4fdVaFoXGbeWh?=
 =?us-ascii?Q?we7BvTRrAileNSc1pocRQnUT2TAM9GC4M60jU/HmBicceocDcOGlpF5uf34S?=
 =?us-ascii?Q?RG//UFllcGV4KvNPsTP84CkzaLpIHLAnqLCXf+BjS8WiCQH5UPGCXV+NfPcO?=
 =?us-ascii?Q?0tPb2kd75H1bbuAJRZxYHvtC1yGei+0jhSVmFM2d0YjFzoN4qG0gARQZ71/8?=
 =?us-ascii?Q?fiK2IvNu8er2xJ4p5ew2Cld0InPHsxk8KiVK0RwDl2LY7vaHmZ9vAo6Cw3rs?=
 =?us-ascii?Q?88uAVZnOEPzzOh9WOTkcaTMQZ+1BwkHWoHNd3xhuN+SjtkqJdsctJcxqKCEP?=
 =?us-ascii?Q?JSQMThN9Md5dcX4lDDbkNDzDPs5pQr4vETQpxyewWVPYdpiN/+MXZUp9Whpg?=
 =?us-ascii?Q?zAB35a4L4w7WJ2c5rMjCDgCq6S8g1HMTfq9aqsUjGDPxIbZ71RbznO3ud0WB?=
 =?us-ascii?Q?uZrQk+GBuK1bXLxdNT+91LaLJ9mOQp9acxcy4rMWud5jTkExilbkm9vSP4jU?=
 =?us-ascii?Q?Ai923WWIkfkaBR+h+PyvMYa8vjeDwdq7TmHDeYqaS5h6fyKcUi4t7uZFQNah?=
 =?us-ascii?Q?5Doe+55QgGJmigwiSUqp8w+MTmqblQaKut7LY/p+F/xlO+9Sq9SIXeDnryXS?=
 =?us-ascii?Q?AGKh+2JKk/YnPLb4OxwvB+yhiaa7Z6/WF8IvWwenlKs10ZJGu8e1+VMKvXxY?=
 =?us-ascii?Q?vHXi4Z3zvG4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HBdnUHP4j3HmOZSKTl04pSX8lnkGEXwLLy9T20ZjyR1aSY6OY3vXbuEMc5Bl?=
 =?us-ascii?Q?cUpEU9yJIsb+R5xIQtl/yqzt0l4fKXwkvgtQztO9qobQOx5QMscSftUQusVq?=
 =?us-ascii?Q?U8gO4Kmbgem0EHrSZ2EL5PeWIXZqAbgZA83UVj78H9G8Q2NU/nB6SYDIerZI?=
 =?us-ascii?Q?au9fz6hh2qsMb84hjJ7jjOC+tbeYO5aFoOwRyV/CSrRfPdC5qVtgNB6s8YOh?=
 =?us-ascii?Q?19xRgKQNrfMnb0VKfVTWFNltrt+N7PsW99kiLcVMxL4jsOM7A3UtR5r6KPHy?=
 =?us-ascii?Q?WfXqz+zcRMiyk9juuVnaIgRJ8ezyI99Nc5aP7WUtQAyM8whGmgvkpMIpr/iW?=
 =?us-ascii?Q?sHwUws53sj6np22LASUa22Dvz/BaXSwyfvuv3UolKik0A7xBHIlApAnVzRvF?=
 =?us-ascii?Q?FCqv7RMBhhtiw9nY2y406gDZEpi6+x7jr93zOccFMX9alFgMncD6X7twKSkG?=
 =?us-ascii?Q?jSPTVDyi+iJBO0b8p5L9KVkzKBq/J1ZyY+9Zw8vgC2mqhU6DgMalp0Ahzixz?=
 =?us-ascii?Q?E4OUrVhesUMN56r79asFsH29wdHCE1HjiNPWBnmou/1sYuEw8i9rI8OrirJt?=
 =?us-ascii?Q?9QOfaRf6h7pTu9YFQ1R1yTT6wg1ZstULlIwWmuktG1U2s0QDtXQvoo//mkLP?=
 =?us-ascii?Q?kjZ5sx2Z/ksB6sYLGWFdltnLEWYODcOx2PFqYIPM5pcnsNCbrCSeER/HBp7h?=
 =?us-ascii?Q?3+qQsG6AINZca1vI/s+33jIico28JkuPedNdjxQz6AcJkLVckV/B8TlTiMj8?=
 =?us-ascii?Q?j0CEhjlqdUsqjn6mfInQ1Y/w+XCwulG8xC1XZBdV9cy+S0ZameyjU9pmwRvu?=
 =?us-ascii?Q?cc5j2i8hZXZ9ne6n4KKTNKJUUJfKX3pnhgr8ylT+upQJ4/iG6SdMeY2wjEe9?=
 =?us-ascii?Q?UNiu3bDuPbuk4OhU7ZZax0AjBPGGilnfAL86ViD+uUhmTLd5uFiFGaC4l0D2?=
 =?us-ascii?Q?kgNIfK/IN5sK6Rw24odFhl4bCOKninkVFBNmjjYezSXcvkFOvm6HFm7U6K1H?=
 =?us-ascii?Q?FLZCj2tr0t3Uiiiq7ino+s9xukQrpUNZRX3q2xHovv80yCY5wQuMN9vcunLV?=
 =?us-ascii?Q?9nkaa1muXVmtrgZELP+0zgj+YoUUSB/2QPE+wVMR7A5d3lGwQ3ofEbiH51Wv?=
 =?us-ascii?Q?fSpivVqlt8j/jPPY7fuMDod7rArmNNR+90CCfv92jvodubk7Hd61IVql6dKZ?=
 =?us-ascii?Q?d2hhSkYziOAYn3zXrbMTtgcsz0+mpSfr1znL6oRk8C+F5TgMZ9f0wxuh3kO6?=
 =?us-ascii?Q?2vTGZjzWmxqR3jUgVlnmC+3RF5pgcgTFS8IiwYJekQqbc0NzUKDWmZZiUoyJ?=
 =?us-ascii?Q?+Z0vRxyM3KaTY4Xz6kkxUbulyV4clUmjeBKYnsi7+bc9L3jcAvTiHG58bilJ?=
 =?us-ascii?Q?oDK3cgzNIf29BkGNwJYl/i+Dlfy4m5fLhTbNM860VjrswgJjBjiWRb2TmYTN?=
 =?us-ascii?Q?6tJB0ea28N4asPqVpRMb2Hz/7+zQaO38bq3Sx1vWskrde4V2rQcS/YNhNui1?=
 =?us-ascii?Q?D2rvo5VPVXOJR54c90fGiHi7LPgzeAzfSnjl6i1jxHpVSK092MYymBtCbfEm?=
 =?us-ascii?Q?jtsRcw+RbAdmAAiccTXp4y/BPNKsol9MxXnLBCvD?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3o1e0Y9FpV6AKihXbsjn3E8OJPpU7H87j5RwsMixvGg7ZnbEfK2UVwMN6usstN5+Rf6KBPgaNHSfRgtjQ+jA6kHPJCYwMGNZUID6XYFoFL805cwPktY716nkVth0tpcQLtsZKJv5x20KP2Wwq+eQNCs5tfh3ASzipmmEEU9SdtDAiyoAqcD7/5f7/NeM/XtY7kJYFk9malFt6JL3xqv6AOZtCbJjR41oa29jGKTvfp3hMBEJrihrGnuAJwcXpTT7KLTaD35a/jXbYdEBkcXqqz7/P71C1jT315W8x14Uqjd7TOqqL7uufl/2vhhR4ue106JTtNNlEUVGzN4Awuy5Ekt01na+o3lWXQCw66e7GPSCD0xvuTxoP4hc0bp/HP71fYYTkjceCNIRPs/WQ4Zfe0lGDMr8gny+j5J948ah08D1+EvjZKJS+WEu0GrAzvfx9J1lCb24UHi8Q8jNofypyEb6pTG0WqlFTPzTufne9fKJQ5RqF2fynfEQW5iNCJFXVO3Mo9sw2EG4MbKsGUy/S/1SN8sB9A1xrfricYLOQAXFNpbxAOBZnLSPM2uYnSHAV/M/xgC93PJm02nr9rMvkSEBVRu7xU+Yu39sppryy1o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb28e8b-3530-4fc9-6365-08dde5cd8b3e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 00:55:12.5256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0vwSGZuWUjiScGjyx5AIphTqtKvVZQnA8qMJ2f+Aw90y+XIDGTuIQz9ADCH1Adarb6EEQz8+5meo+Rf0S3cwGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280005
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX/B7A+yFKrFE2
 F3W6sGqAMiBdVp3y6urIbd7/4pIZq2fX9BLqPUbscNcXYQ7r5sjeeE38tfIUXTtBcGQBCMbTUIr
 LcCCUjKWPw0TIDDcUYrXgp3HZeNz8gzIIIl3xYdoXbNQ6EErtCcqZY5V/dHCyt7DKvZSJkaJZ7k
 dFcDUdJxxWaFmzSPclC3nqdEOV606ZLrU2EIU6MV3L62Io9Z5Z/PtI9XGVATaZfG65bUF6F8XqQ
 i8YnClYiyR/RNYcfQYaai3i+1XA/E4iCatgDTj7V2dv+RcOcsGJxMV+jF8s72Ozwu0RfPNbbh4P
 6gNSYTwok1dfLgqw/UuMXhhQ/tioOM3hKXfXyuuA79KlTmPBeZB/RYS2P/+HKoIP0jgFnvQOLBg
 u0wZdVKwGDjWhlWV/87OkfZFO4p1nw==
X-Proofpoint-ORIG-GUID: Y6hK-4_UZ-DTc21zhKTVqabOXpCAWdT9
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68afa8f4 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=iHwBjlyiAAAA:8
 a=yPCof4ZbAAAA:8 a=1fopFEKFwiSSAcViFK0A:9 a=CjuIK1q_8ugA:10
 a=uNSKXYNwxGiU6LD0JREI:22 cc=ntf awl=host:13602
X-Proofpoint-GUID: Y6hK-4_UZ-DTc21zhKTVqabOXpCAWdT9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6FF3CC000B
X-Stat-Signature: t61hgxa8x7ufxycienwha964n5iokhht
X-HE-Tag: 1756342518-547866
X-HE-Meta: U2FsdGVkX1/EP8vdEbSxFNLzvr7qiSAxqzHMIhSV7rPrt66kDwfia7IVygEsFe4I0zhx6EAzB3tKWcasdvb1gewxEYzZ+9WVp6tYh9sr/kFyHc0iL6YnRj0xN+Sor9wFLquvZBphffmPSKCSnd9zyOwAKO2NF4PqieoqqsqFDTRrgEW6v2R87s99vPcMrWu1vtk60Oyct8uk1prRav/QudW7XP0mGOtYoZlrSGZ5rH5cmawr4/F/zzIA4TQ++byClfdI9BJmTx+7Fm7mE87IXDsZ+k7OBcqga6MDTEL63lx8IyXCz9YBNww17/GiHR2sL3mzMKFa8TZnmEbqsxFcB1kxyKxbAATV5EvV1LQFi5LGV8j3ynbTT+TWWZ6A5za1r/0yByRQz9QymwB9a7HoaiKZUgEN73V9S3AxmLy2Nb99GzFB4qen1713eIuayx5Q0Fw5GGtmR+CASFfKUB4kc2S5GtM6l/qyXoY3Eo4OFCjLbiIgeNJfPrCVgv9552P7FLpX0kYUoAh7eUaj5wPlOb4YYuy5kH5h03TnPRf3kscI+lub+2MB01aUVdRXJ/WaXHVBCvhWPQW8iVGaIv1MDcRh9/QY+4Q6xF63LGJcp13A0Hkkh2MxvhFDo1Zcjy/qoJQIwsCvJiwg3IHWpk3iNPdAfqCqkTkABzyMSjMWFhIBSEQPga+N1uKslW+J6OSVIvt4//CSZSo77pyUSdRG6gV0ZA8MQIwFZ2T2EUMXs6+ziMKfEr0rfTofNV4La770NkV94UjF1UfajksZ7HeBG/0iIv83DRs/G41aVpjb7VGvQRchatbn9i3hXYhW0+u1NwGB21Van7ML0CueR1QSeSn4OSE2edSl3cm/6rpYvHIbk/9aBwod1FEbG3Mw83xYDdsdpXk4OrQqgPyXqeQbgLXy2EzTfNqkM2w1nkZN5Pk4N2tePZ+zR6zJbTPDdLConTddvR+Tb1pMgxTTzPa
 OriyY1m1
 ummXIoy11tIxrthbG2GBfjeR/yesz/mvkF491z0xg4g0UYwoRDnkS6iiYIqyYHSxxCDSFQwzGDpT0kHL8vlWhvpMpzxEBtbpq+vyG8ZyUeBOGrmEdgwztfZIva+5R2Og4I3G0pg7mYsEGSoA3HKfkDef1XDlM2DIddUkzRNjnX6mzOBlcAB0OMOiPd+xWKIdSWppAhSPkoTO8ovEEATDK3uhbK7z55Sxb38nNntCxdRJL//7BBqkyJ+iH9YzA82s9+/F/JRHnQ8Thh/v5BnuovaVfDQtAInU18JzVKYZgjFP0orOJWPRS2mnpU309aQRf6K7OhK3gZsINg28VvrJx6pgY2DCvzZwurBrQwG6OifxoW50OgdMaRDCBJhPUlQ/cbPi3F5pjAALWtFMNIRvsSRk6sV2lGlgm/efS6I+TAa/Vvxn/jlCykD79uaLMSn3sfnDFR0hVivvaeuS04dxFpJIB26jQ826gabtFfEZ1mOseU1YBnfH/zXpAXt+dXgozrjQ8+LC6r7wUUvCFWRmvP8FYT3DE7uneFi0LVlit1i1NdujxgijcuEdvX9bMqdmNGPxon80/VPqMCKKvakRvhXS84+BMZ4ZOEQbp9TN3iTimDZIbKK16KAhzynJT7vBBtQdsrYzl2wO19p45hkF5X6yrMUY/max5sDwrTHlroS9EUDqavGWtMrVeeuP3Wu3cmAwHBDirq0R319gz1X7KYLuF7Ju1yI6eyte5+v6CVm14xWSEU9qhHnx8ljUSLU+Cjyz+IRF3f1Cdl90BeagyklN+4SvvOSNuxf0KOWdHT2IoQ18dazcHY6PBB9du4QypJWlQHwf/xk/6yVSS4cCyBhgIIHXEbcU75d1Jg8aFPIEbwM91r6dSCT9R4CKBUGWj4lcYyzkkQFlA3P0qB1XBpZA2jg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250826 06:28]:
> We do not need to references arguments just to avoid compiler warnings, the
> warning in question does not arise here, so remove all of the instances of
> '(void)xxx' introduced purely to avoid this warning.
> 
> As reported by WagYuli in the referenced mail, GCC 8.3 and before will have
> issues compiling this file if parameter names are not provided, so ensure
> these are always provided.
> 
> Finally, perform a trivial fix up of kmem_cache_alloc() which technically
> has parameters in the incorrect order (as reported by Vlastimil Babka
> off-list).
> 
> Reported-by: WangYuli <wangyuli@uniontech.com>
> Closes: https://lore.kernel.org/linux-mm/EFCEBE7E301589DE+20250729084700.208767-1-wangyuli@uniontech.com/
> Reported-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  tools/testing/vma/vma_internal.h | 167 +++++++++++--------------------
>  1 file changed, 57 insertions(+), 110 deletions(-)
> 
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> index f13354bf0a1e..4b9394d75b34 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -692,9 +692,7 @@ static inline struct kmem_cache *__kmem_cache_create(const char *name,
>  
>  static inline void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
>  {
> -	(void)gfpflags;
> -
> -	return calloc(s->object_size, 1);
> +	return calloc(1, s->object_size);
>  }
>  
>  static inline void kmem_cache_free(struct kmem_cache *s, void *x)
> @@ -858,11 +856,11 @@ static inline unsigned long vma_pages(struct vm_area_struct *vma)
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>  
> -static inline void fput(struct file *)
> +static inline void fput(struct file *file)
>  {
>  }
>  
> -static inline void mpol_put(struct mempolicy *)
> +static inline void mpol_put(struct mempolicy *pol)
>  {
>  }
>  
> @@ -870,15 +868,15 @@ static inline void lru_add_drain(void)
>  {
>  }
>  
> -static inline void tlb_gather_mmu(struct mmu_gather *, struct mm_struct *)
> +static inline void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm)
>  {
>  }
>  
> -static inline void update_hiwater_rss(struct mm_struct *)
> +static inline void update_hiwater_rss(struct mm_struct *mm)
>  {
>  }
>  
> -static inline void update_hiwater_vm(struct mm_struct *)
> +static inline void update_hiwater_vm(struct mm_struct *mm)
>  {
>  }
>  
> @@ -887,36 +885,23 @@ static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
>  		      unsigned long end_addr, unsigned long tree_end,
>  		      bool mm_wr_locked)
>  {
> -	(void)tlb;
> -	(void)mas;
> -	(void)vma;
> -	(void)start_addr;
> -	(void)end_addr;
> -	(void)tree_end;
> -	(void)mm_wr_locked;
>  }
>  
>  static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		   struct vm_area_struct *vma, unsigned long floor,
>  		   unsigned long ceiling, bool mm_wr_locked)
>  {
> -	(void)tlb;
> -	(void)mas;
> -	(void)vma;
> -	(void)floor;
> -	(void)ceiling;
> -	(void)mm_wr_locked;
>  }
>  
> -static inline void mapping_unmap_writable(struct address_space *)
> +static inline void mapping_unmap_writable(struct address_space *mapping)
>  {
>  }
>  
> -static inline void flush_dcache_mmap_lock(struct address_space *)
> +static inline void flush_dcache_mmap_lock(struct address_space *mapping)
>  {
>  }
>  
> -static inline void tlb_finish_mmu(struct mmu_gather *)
> +static inline void tlb_finish_mmu(struct mmu_gather *tlb)
>  {
>  }
>  
> @@ -925,7 +910,7 @@ static inline struct file *get_file(struct file *f)
>  	return f;
>  }
>  
> -static inline int vma_dup_policy(struct vm_area_struct *, struct vm_area_struct *)
> +static inline int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
>  {
>  	return 0;
>  }
> @@ -952,10 +937,6 @@ static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
>  					 unsigned long end,
>  					 struct vm_area_struct *next)
>  {
> -	(void)vma;
> -	(void)start;
> -	(void)end;
> -	(void)next;
>  }
>  
>  static inline void hugetlb_split(struct vm_area_struct *, unsigned long) {}
> @@ -975,51 +956,48 @@ static inline void vm_acct_memory(long pages)
>  {
>  }
>  
> -static inline void vma_interval_tree_insert(struct vm_area_struct *,
> -					    struct rb_root_cached *)
> +static inline void vma_interval_tree_insert(struct vm_area_struct *vma,
> +					    struct rb_root_cached *rb)
>  {
>  }
>  
> -static inline void vma_interval_tree_remove(struct vm_area_struct *,
> -					    struct rb_root_cached *)
> +static inline void vma_interval_tree_remove(struct vm_area_struct *vma,
> +					    struct rb_root_cached *rb)
>  {
>  }
>  
> -static inline void flush_dcache_mmap_unlock(struct address_space *)
> +static inline void flush_dcache_mmap_unlock(struct address_space *mapping)
>  {
>  }
>  
> -static inline void anon_vma_interval_tree_insert(struct anon_vma_chain*,
> -						 struct rb_root_cached *)
> +static inline void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
> +						 struct rb_root_cached *rb)
>  {
>  }
>  
> -static inline void anon_vma_interval_tree_remove(struct anon_vma_chain*,
> -						 struct rb_root_cached *)
> +static inline void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
> +						 struct rb_root_cached *rb)
>  {
>  }
>  
> -static inline void uprobe_mmap(struct vm_area_struct *)
> +static inline void uprobe_mmap(struct vm_area_struct *vma)
>  {
>  }
>  
>  static inline void uprobe_munmap(struct vm_area_struct *vma,
>  				 unsigned long start, unsigned long end)
>  {
> -	(void)vma;
> -	(void)start;
> -	(void)end;
>  }
>  
> -static inline void i_mmap_lock_write(struct address_space *)
> +static inline void i_mmap_lock_write(struct address_space *mapping)
>  {
>  }
>  
> -static inline void anon_vma_lock_write(struct anon_vma *)
> +static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
>  {
>  }
>  
> -static inline void vma_assert_write_locked(struct vm_area_struct *)
> +static inline void vma_assert_write_locked(struct vm_area_struct *vma)
>  {
>  }
>  
> @@ -1029,16 +1007,16 @@ static inline void unlink_anon_vmas(struct vm_area_struct *vma)
>  	vma->anon_vma->was_unlinked = true;
>  }
>  
> -static inline void anon_vma_unlock_write(struct anon_vma *)
> +static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
>  {
>  }
>  
> -static inline void i_mmap_unlock_write(struct address_space *)
> +static inline void i_mmap_unlock_write(struct address_space *mapping)
>  {
>  }
>  
> -static inline void anon_vma_merge(struct vm_area_struct *,
> -				  struct vm_area_struct *)
> +static inline void anon_vma_merge(struct vm_area_struct *vma,
> +				  struct vm_area_struct *next)
>  {
>  }
>  
> @@ -1047,27 +1025,22 @@ static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
>  					 unsigned long end,
>  					 struct list_head *unmaps)
>  {
> -	(void)vma;
> -	(void)start;
> -	(void)end;
> -	(void)unmaps;
> -
>  	return 0;
>  }
>  
> -static inline void mmap_write_downgrade(struct mm_struct *)
> +static inline void mmap_write_downgrade(struct mm_struct *mm)
>  {
>  }
>  
> -static inline void mmap_read_unlock(struct mm_struct *)
> +static inline void mmap_read_unlock(struct mm_struct *mm)
>  {
>  }
>  
> -static inline void mmap_write_unlock(struct mm_struct *)
> +static inline void mmap_write_unlock(struct mm_struct *mm)
>  {
>  }
>  
> -static inline int mmap_write_lock_killable(struct mm_struct *)
> +static inline int mmap_write_lock_killable(struct mm_struct *mm)
>  {
>  	return 0;
>  }
> @@ -1076,10 +1049,6 @@ static inline bool can_modify_mm(struct mm_struct *mm,
>  				 unsigned long start,
>  				 unsigned long end)
>  {
> -	(void)mm;
> -	(void)start;
> -	(void)end;
> -
>  	return true;
>  }
>  
> @@ -1087,16 +1056,13 @@ static inline void arch_unmap(struct mm_struct *mm,
>  				 unsigned long start,
>  				 unsigned long end)
>  {
> -	(void)mm;
> -	(void)start;
> -	(void)end;
>  }
>  
> -static inline void mmap_assert_locked(struct mm_struct *)
> +static inline void mmap_assert_locked(struct mm_struct *mm)
>  {
>  }
>  
> -static inline bool mpol_equal(struct mempolicy *, struct mempolicy *)
> +static inline bool mpol_equal(struct mempolicy *a, struct mempolicy *b)
>  {
>  	return true;
>  }
> @@ -1104,63 +1070,62 @@ static inline bool mpol_equal(struct mempolicy *, struct mempolicy *)
>  static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
>  			  vm_flags_t vm_flags)
>  {
> -	(void)vma;
> -	(void)vm_flags;
>  }
>  
> -static inline bool mapping_can_writeback(struct address_space *)
> +static inline bool mapping_can_writeback(struct address_space *mapping)
>  {
>  	return true;
>  }
>  
> -static inline bool is_vm_hugetlb_page(struct vm_area_struct *)
> +static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
>  {
>  	return false;
>  }
>  
> -static inline bool vma_soft_dirty_enabled(struct vm_area_struct *)
> +static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
>  {
>  	return false;
>  }
>  
> -static inline bool userfaultfd_wp(struct vm_area_struct *)
> +static inline bool userfaultfd_wp(struct vm_area_struct *vma)
>  {
>  	return false;
>  }
>  
> -static inline void mmap_assert_write_locked(struct mm_struct *)
> +static inline void mmap_assert_write_locked(struct mm_struct *mm)
>  {
>  }
>  
> -static inline void mutex_lock(struct mutex *)
> +static inline void mutex_lock(struct mutex *lock)
>  {
>  }
>  
> -static inline void mutex_unlock(struct mutex *)
> +static inline void mutex_unlock(struct mutex *lock)
>  {
>  }
>  
> -static inline bool mutex_is_locked(struct mutex *)
> +static inline bool mutex_is_locked(struct mutex *lock)
>  {
>  	return true;
>  }
>  
> -static inline bool signal_pending(void *)
> +static inline bool signal_pending(void *p)
>  {
>  	return false;
>  }
>  
> -static inline bool is_file_hugepages(struct file *)
> +static inline bool is_file_hugepages(struct file *file)
>  {
>  	return false;
>  }
>  
> -static inline int security_vm_enough_memory_mm(struct mm_struct *, long)
> +static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
>  {
>  	return 0;
>  }
>  
> -static inline bool may_expand_vm(struct mm_struct *, vm_flags_t, unsigned long)
> +static inline bool may_expand_vm(struct mm_struct *mm, vm_flags_t flags,
> +				 unsigned long npages)
>  {
>  	return true;
>  }
> @@ -1185,7 +1150,7 @@ static inline void vm_flags_clear(struct vm_area_struct *vma,
>  	vma->__vm_flags &= ~flags;
>  }
>  
> -static inline int shmem_zero_setup(struct vm_area_struct *)
> +static inline int shmem_zero_setup(struct vm_area_struct *vma)
>  {
>  	return 0;
>  }
> @@ -1195,20 +1160,20 @@ static inline void vma_set_anonymous(struct vm_area_struct *vma)
>  	vma->vm_ops = NULL;
>  }
>  
> -static inline void ksm_add_vma(struct vm_area_struct *)
> +static inline void ksm_add_vma(struct vm_area_struct *vma)
>  {
>  }
>  
> -static inline void perf_event_mmap(struct vm_area_struct *)
> +static inline void perf_event_mmap(struct vm_area_struct *vma)
>  {
>  }
>  
> -static inline bool vma_is_dax(struct vm_area_struct *)
> +static inline bool vma_is_dax(struct vm_area_struct *vma)
>  {
>  	return false;
>  }
>  
> -static inline struct vm_area_struct *get_gate_vma(struct mm_struct *)
> +static inline struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
>  {
>  	return NULL;
>  }
> @@ -1233,16 +1198,16 @@ static inline void vma_set_page_prot(struct vm_area_struct *vma)
>  	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
>  }
>  
> -static inline bool arch_validate_flags(vm_flags_t)
> +static inline bool arch_validate_flags(vm_flags_t flags)
>  {
>  	return true;
>  }
>  
> -static inline void vma_close(struct vm_area_struct *)
> +static inline void vma_close(struct vm_area_struct *vma)
>  {
>  }
>  
> -static inline int mmap_file(struct file *, struct vm_area_struct *)
> +static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
>  {
>  	return 0;
>  }
> @@ -1411,8 +1376,6 @@ static inline int mapping_map_writable(struct address_space *mapping)
>  
>  static inline unsigned long move_page_tables(struct pagetable_move_control *pmc)
>  {
> -	(void)pmc;
> -
>  	return 0;
>  }
>  
> @@ -1420,51 +1383,36 @@ static inline void free_pgd_range(struct mmu_gather *tlb,
>  			unsigned long addr, unsigned long end,
>  			unsigned long floor, unsigned long ceiling)
>  {
> -	(void)tlb;
> -	(void)addr;
> -	(void)end;
> -	(void)floor;
> -	(void)ceiling;
>  }
>  
>  static inline int ksm_execve(struct mm_struct *mm)
>  {
> -	(void)mm;
> -
>  	return 0;
>  }
>  
>  static inline void ksm_exit(struct mm_struct *mm)
>  {
> -	(void)mm;
>  }
>  
>  static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
>  {
> -	(void)vma;
> -	(void)reset_refcnt;
>  }
>  
>  static inline void vma_numab_state_init(struct vm_area_struct *vma)
>  {
> -	(void)vma;
>  }
>  
>  static inline void vma_numab_state_free(struct vm_area_struct *vma)
>  {
> -	(void)vma;
>  }
>  
>  static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
>  				     struct vm_area_struct *new_vma)
>  {
> -	(void)orig_vma;
> -	(void)new_vma;
>  }
>  
>  static inline void free_anon_vma_name(struct vm_area_struct *vma)
>  {
> -	(void)vma;
>  }
>  
>  /* Declared in vma.h. */
> @@ -1518,7 +1466,6 @@ static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
>  
>  static inline void fixup_hugetlb_reservations(struct vm_area_struct *vma)
>  {
> -	(void)vma;
>  }
>  
>  static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
> @@ -1529,13 +1476,13 @@ static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
>  	fput(file);
>  }
>  
> -static inline bool shmem_file(struct file *)
> +static inline bool shmem_file(struct file *file)
>  {
>  	return false;
>  }
>  
> -static inline vm_flags_t ksm_vma_flags(const struct mm_struct *, const struct file *,
> -			 vm_flags_t vm_flags)
> +static inline vm_flags_t ksm_vma_flags(const struct mm_struct *mm,
> +		const struct file *file, vm_flags_t vm_flags)
>  {
>  	return vm_flags;
>  }
> -- 
> 2.50.1
> 

