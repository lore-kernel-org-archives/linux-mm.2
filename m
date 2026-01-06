Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64495CE9D47
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0DF6B0088; Tue,  6 Jan 2026 10:13:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC90D6B0095; Tue,  6 Jan 2026 10:13:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B737F6B0096; Tue,  6 Jan 2026 10:13:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7B246B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:13:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4BBA41AEC3
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:13:05 +0000 (UTC)
X-FDA: 84301881930.10.943C5C7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id CBD4E160009
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:13:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LYltE+Dn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Q/K9eUrn";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767712381; a=rsa-sha256;
	cv=pass;
	b=fbfSPOsP5uI4ZSFrus8IjVtanxkuJFuD386zG7zVpBs0hommpMDyTdt13JtUK4FSueclzY
	0GJi0WfQBo5nItMB+VkOP74ZCduf45L+MEn1D6hEL6Df7V41gWGf20nxU1P+A2WFmWNVvd
	+7Q8lIogUKp2jlJaiOUEebeAmcnGCzU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LYltE+Dn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Q/K9eUrn";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767712381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Xu/pXGp2SR4l1EeLkd5VlOXkM13b4TsURHMf2J82Ss=;
	b=VBz6wGVerU4eLJHFB1GbOZHX+sGEqPRhrBPzJ54tUd6rzxcFI7fbBrtQ3Y3rXsyRrGK0Ui
	XY2VwuD0/n5LuwiAKhPdWSOzDXFb54QKM2SsajhcMIrjAozDeO5JmcIwIfw3ZSTqU20OvR
	l4qcbq1xUoqV6/7wzBv9+tKSVaGkkk8=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606DEfjx166594;
	Tue, 6 Jan 2026 15:12:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2Xu/pXGp2SR4l1EeLkd5VlOXkM13b4TsURHMf2J82Ss=; b=
	LYltE+DnK29Tv77uqei/5WVmR/naQR6SJxgD9MSjx03WNJKOb6uaBGLtUciVkFff
	TACE5xzRVq74b/Ogl/vTPZhVJnN0H8ugAoIrxtZMy5ImAgT6O65YnCPwqmhN1p9c
	hF66O06joB3xwzLYCHGaeSlwVUyTgEomaDZwdZ678XQ9+8+VGkbcGX0Nwe3mr+go
	CdurvloJ4KXl7dnSaC86c/N+mNKh5KENyNq2blYSa17JQcfliZqygcG4CIAJ8n5b
	38kmSuzRsHVijsEVg7u5BzO9Y3DiNLoyJGIx74YRiF1wGNRbLk9WqRLLkG+8PZWx
	i5VBTN7NdAuM1GNRuGDXvg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh33x065p-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:12:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606DOK1v013560;
	Tue, 6 Jan 2026 15:04:43 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012052.outbound.protection.outlook.com [52.101.48.52])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8ekw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:04:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M/yH7+HtnP9hryn8sYzp1ZNF+1PYmRGR/BTKRGT+jYqxfdvjkdakgoXdfR5TJvNRODuvBRKStifnGWzoKMrDq3PX2k77CL/DYA5X+v/1wxWe8ZA4h+G+zF6+XhUzMiUPS2WIHlGuhklgm548Ww/PxNWZxly+dDuNguOCznx08f/XsTqAS4jRG+NZd/8Mg/vZerbBBqaB815qKLGt9KJgwrysFdlG41V4wLp8p7phxJfJQ1ZUgVPZwAndvLqvhYbTm7bKtKI15jdtidkRmNtdgFHHZy70zhSXJyIby6j+d5B5uIrozF2gASwFtvonj4+R2SKlZALKe0ksOspVtw1O8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Xu/pXGp2SR4l1EeLkd5VlOXkM13b4TsURHMf2J82Ss=;
 b=iy/j0k9gXjIdoVD7o8r46koaLyIK9tQMQyKD2SEjzREz/0c4rZ7+ezPq2+AXl1V7K6n0eOoyKyKVVZanLy1reiJvGqjL/JgUANy991tGPkoT1qrLhWH2gt8W3K8zs+iUC8VDVn//VsQNSx4Pjcv498RGqetfSCRPql89GGvuEElkX0T6+Urbn+NeKCEr+SZjRXgy9ZSwJixQgcOFO/77UNPgKQs4KY+H7eBb7At7Ig0Hd7kdadHGTM46TWV3yc073oVtU0YhfwnOmwJvc/UkhWYeEjhj9mr2v27d/i3AmegfdtsNZwqs6JZeTc82vKq6OFg5vXk6i5fB/qcDQKLDow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Xu/pXGp2SR4l1EeLkd5VlOXkM13b4TsURHMf2J82Ss=;
 b=Q/K9eUrnoW9yfCbHenioVR0sETO5Hxi2d1SzMFmk0Mqyumu8h1DJp4KcXtyrOhGFjLRLw82a+QE5NSLJLE5+5RdDQu//CbrFOHxVOj8kMSBCvgvlakw2mu7SO6YUZkBoCljNryefVhv+9skBTWtRby5wRHfJXti78jPkcxL46Ug=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB7097.namprd10.prod.outlook.com (2603:10b6:510:28f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 15:04:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 15:04:40 +0000
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
Subject: [PATCH v2 2/8] mm/rmap: skip unfaulted VMAs on anon_vma clone, unlink
Date: Tue,  6 Jan 2026 15:04:27 +0000
Message-ID: <f0855a0b4e68d877baa222a636a8a14c4e820bf0.1767711638.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0031.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: bc707ccf-37ec-4896-d901-08de4d34ea79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ElTKTTZs8G9YoXqpWoTbKK4gSQ6Bp4X36pahLCltQRYiGnHvSS+7r7S0R/iV?=
 =?us-ascii?Q?KsRoxsX/o9C/7n1vsgDsdioOs3+xUIMzlmpzQN3nal/qpeBoCJ3cAYAmHaf9?=
 =?us-ascii?Q?M/e4VoyF6EWeVliXUpujppVgX2hg1q8EN8enyM9kF/GKp6MNarSQspI6twQ6?=
 =?us-ascii?Q?JGrDaEODrs9Z8aKMdHdV5ucDvT/WawikYZ4Gn0yVDFO13EkmpKAhtHzb+4B5?=
 =?us-ascii?Q?KYk++40Q3OWK/VQiH3rzlz3/AckDC5ZhhZQin3319bAeoiTRWdDOyNdQe0Rm?=
 =?us-ascii?Q?dvn6NzcZnWPuFoycZqsR1uSrbRm5AK+FlB5mE8cZGgVDUlmvqT9LQQVqVSHb?=
 =?us-ascii?Q?zttub4tkxSEhVhC+7QxE6JnjP+AH7QttfEWeosOVXLwIY/PNtYw4uGsuXilF?=
 =?us-ascii?Q?ru4WB7GygIqTv1Rx2dhW7tS6y78HJCPuUdYKKIJMVnOU4YKbhpXzE92bVnuX?=
 =?us-ascii?Q?CGnr7DKexvhn6bC25fgRDDNn28zCjZk7od0MO7QmJT4DgjDeQhOqPje+kYk8?=
 =?us-ascii?Q?Q0Ip7QvMKPjlX5QpSf9u+WJ0sGwueLVBLFXtCku3wj49icm7GtAlUe06PkIp?=
 =?us-ascii?Q?UGp5dbSWX6c5E/FcuK8tL5DLfRx153R2JY8+FaFMk0ZJoeQz7bm/ppiL+H6i?=
 =?us-ascii?Q?s/ghJ8LJ37mKoc544JNl4hb7KvrOnvKF0RDJaOdtiNBHsH6vBP9CzPC1V3CL?=
 =?us-ascii?Q?1Lid/TXRsbfX+gHyRRUE2ppjqZT/pPg6KQnFb/OnnUjVMS5ixOJLsPQ18ZAp?=
 =?us-ascii?Q?59Nt4L1YLbdjli1MACnu8gJHYQl1JJIyRfWSJWDUQpTXms01gsoQConjWBvK?=
 =?us-ascii?Q?9pcreVWQxT5mFn9d0O8pTNhYUuLbvptfxqHKyruUIWA4XmOi6nz2cZI5FTY1?=
 =?us-ascii?Q?rchMSmCpIhXC6kfi5qdOjD98KSxF0EiMoy981jKZSZfCFXz85k3ne6TB7wzV?=
 =?us-ascii?Q?8sOOtubQhrncll6VrZLg35qrpgnESfnrDIHE8G93HuOk4u09cW+jnOlz2Xxo?=
 =?us-ascii?Q?cMQIDzz36Go3KLscR3vLKt4A4NiNRL6NZUgbZrz9S5lTgImcQ7oW2ccEzXJv?=
 =?us-ascii?Q?pWiRJWnCTdd8Wiztpnxo4d5qNi9b2kHkFi/ktgr53kfuq++8SgzM/skmCgnu?=
 =?us-ascii?Q?R50U/yk/gErNLBk+hu1xJi8YiTQ8GK8Lt46c5tmZBqcqyiBHfKfVXz3cxfI2?=
 =?us-ascii?Q?q3UQaJhiVcmoxp4+RWHWWpCUa27Byp7G2PGDNcSoXjopNYwA534Y/9r9VCTO?=
 =?us-ascii?Q?pM0iG5SrVFzKFHTogE4zL6i8bzxiE6CwS/Wtb5kj5qF4scDrsXURwf72XUZW?=
 =?us-ascii?Q?at9iBpkH6+flpGxhHtpvBhfDVT6c7GhdAV+UBHE25xUl5bpBlmV5Q0mK0Z+B?=
 =?us-ascii?Q?McOb1HG1PHy6kkhTdXv25muBUbUtN03vilHPdjfQGBeZ+oP+pIgISK3Z669L?=
 =?us-ascii?Q?NOiuVIsKPHfK/85SRBkMFl/EFnV4iX9X?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BVJG4PsU8AVaEAbXCtGyEcJ87eWoQR+oNzVZSNkb5QgMTYV3Wzic4JrYPwlC?=
 =?us-ascii?Q?STAqUT8h0G19DCUVrVfCsQGy8Olw1Kyk0mK7uDDm8gDUz//WQJE3KWvpwQ4W?=
 =?us-ascii?Q?4wX6VVTyJkIelaohfiwFdmL8/N7ebV1kCwlpXsv+NoSJYDlL+LMbjVI10wxo?=
 =?us-ascii?Q?CjRi4nFXkBHG89WFiLducDRhk57S+U1hQpEih4waf4uvoJU29ttZzKg2xKkc?=
 =?us-ascii?Q?PpR/8QzbldK3B/razT5FGh8/qXDVy90TkL5BMfGTiR9/aH06cJqSky5uveSF?=
 =?us-ascii?Q?PZdr5Z535uqKIHbJnBGea4tPHNq/Z6WIfl6e5kQUudYgr4+9iA6HTr2jlKMY?=
 =?us-ascii?Q?44Q8KyHxBWJ8DGRJ6aiFaoMVj5g1OdNMnD9+kHnF45hajne/BGxbXtIwSLJU?=
 =?us-ascii?Q?9jF7BExbGmhADCzOyo2A6uyiIoutb33RdtfG8ovQU3ipWWynhFud2AATwzrA?=
 =?us-ascii?Q?rL8E/zt/hkCCcCbDPwdPLGQEY/RkEV6ZXRx+Ii8erg3vn6SPGEVbI+Mzsjmf?=
 =?us-ascii?Q?acuQhj3d8Ae76j4bU3rXY0L+ZLYmpBPu12Hh4ejvkchXNzQAFKulgVtW7Hbq?=
 =?us-ascii?Q?Q+htUBm0lbdGvYnodFzbVgki92Po93y2ycv2KbjfzT18ixsJXS/QujneRV+8?=
 =?us-ascii?Q?tQpG1g1lpfpk0Mr53CyZK6RxvruwatQM9o2A7th4FV914RPQ7eVpITKy6iJj?=
 =?us-ascii?Q?8BKRCjH8zFE3jP6uVVdK9fj16PGjahAOnAon3rOYk9P+gteLlbICZYV/F8y7?=
 =?us-ascii?Q?+/NZxF49nQmD6NUpEO5BZKuDFzvmqQ05NNpeFws+SdGrDqFzqqTcA3wp+pLe?=
 =?us-ascii?Q?gBe00MPTpJclnDgGVVUN8mTlFk5elwMYEBKMe8FPcRBveSkVqGHGDNlUZx9y?=
 =?us-ascii?Q?ewIoZ13PvPH/7vUVxwkDZAjWaiRTlum3SDeLHGErDUJtYkFPRpPxD0OjyH2i?=
 =?us-ascii?Q?pHxWqUGpnG8lOaOlWkuRwIFZqItXF/qiy20KF7sT+2a8jZsU3I+J2Ekr4Qvq?=
 =?us-ascii?Q?lAKPvn9Rf9AR4IjXyIIurn2s7/sPcrWcCaXeJ2Zw97xJegj9TYQDJU25TI0A?=
 =?us-ascii?Q?Ygb7gmJLWOCxqih8DPzHxxghdHXJUOmM84MZjUb3krc/Llby+XGSuiKHWZSw?=
 =?us-ascii?Q?Qxh5VbQ0ljgG/tkXUuvnI4sz7ZrF48+ny29YfA49WS6Q8aCrVBTN/Aem86aS?=
 =?us-ascii?Q?XpQpP7wX1RiSVITb9eBawCMZou0MhjTRA+4PPKfrql0HGAuHfUL/0Or8B/BI?=
 =?us-ascii?Q?poeukhRE8KPsWqf14nmW6F+t1TlOloXxrYqZ/yEbgvBniKsPI4bOfXRnz7PO?=
 =?us-ascii?Q?SsyuJqYHoGtWLu/no3FKgyZzFWetGJW2ChuWHnKc5zozt0fOsiMGo7BkR1R2?=
 =?us-ascii?Q?+No1Y2M+Nm+sf0w+qFGjM8/qas4R6WeFmuTMYZl6iNojW8k4V/xzscfcA8yz?=
 =?us-ascii?Q?hbARuOt3H+TQLJLuOJmE169xpGcmjts8cak5Qsd+p5Cd1OpitatWfmLSzoSl?=
 =?us-ascii?Q?RpwHr1rYqhM0Qn3Q5hVNVaBt77WAwwj7OXmxfrc0uMfiMRXjMdFukiTWS87b?=
 =?us-ascii?Q?aG4ZbYIDjS1A1E1fPflmadxYNw0s9SwmYLdQmVwScuNM8Aw012dGTyzWUMSI?=
 =?us-ascii?Q?040da5sMsAF1xuzFe2qYVaDVfzxNsU+jsniBQNVaoYTeOSI03YGG0vqRd64v?=
 =?us-ascii?Q?ApWsFkrAe/k7VA7TQCwOq+fn6535k+qWAUyyQXBIoSUlqOkgWhtVVmXs9Pij?=
 =?us-ascii?Q?qSmLggQzh5fr1y2sJV8xMmPQ73jgi2M=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HWHs3z0iUoPHO6hU/B5hND0+hnm+fQdXgWChPYGJdtm8wKQ3JrCXMVjSsiU7XskKCYADYNas20cnXdspBSead5M/8j7vjlZ44Es7/jLio5WkRMsjjhWancFhkFdGRIcksXQknsXoXH9qItli92W9jpe9zOHGRUBtZevSjtd1VvfkaKOrVJE9yYR2SKvDzAJl9r5OzjKyCj0O6rcGHK0m1VAO2Vv3URsyAVd4TM43PCbUUZc7v1OviFHpUu7O1v6AyUxKCrd+m36aDXFT/xoVFxowpWlMHNKw9cKV77I17useyZ/9JLf2hDmI3fPATcNvXa0c7OOELX9Rt0dUqxIGPlpT7wkjnReBWKlWDluGk4VoyuVugU0k707VWfTq/hrG6Z9NavvAnN0VnKaJd4kuv7rfTTy+kgj2ErPo/bc8rqDQ/4elAcjGfON65ZnpBmTuhzSVWmyQNIURUWhrFFV24qw1GE8X4vLTBB+HPcuKF59LwtGKQNJsI/9NLtDfEIZO2rVX238bzBK585zXm5ukYaPO9RIn3pmbTB0MemLtN+yd/zcMWEWxFmj1rEdc7WtHgM8SidlMC9CkuMxNxIYdbEgxkAdhryKHRpZocmHy6qg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc707ccf-37ec-4896-d901-08de4d34ea79
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 15:04:40.1773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GJAOEn31uVvrQ79LNtSQbszQA+nsGqviBPDd6GetlC7bsf3TkJUwCSaEWRwVOOhjiehoIYWP3M+F3qDNAk9OcCXI8lYok/sjv6k6+wthVqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7097
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=936 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060131
X-Proofpoint-GUID: jz3GHYn9O1fTKVxgCtNODMuJmIuPQy0O
X-Authority-Analysis: v=2.4 cv=Y4L1cxeN c=1 sm=1 tr=0 ts=695d2678 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=EoYbDyGkc-fg8F-L9o4A:9
X-Proofpoint-ORIG-GUID: jz3GHYn9O1fTKVxgCtNODMuJmIuPQy0O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzMiBTYWx0ZWRfX6LzDI7KgIM4z
 Lkyy5J5GN5FdeZKmBQ1lRw51vKezKcwwWOfjH0mm22d6jI2WyIbY4CQX3iLQUto25OaTxj+zixH
 mDa7CvN6thtkVOcyB1qgzUU7Z6090bVOT1xp6sbUpWNj0WFkNEYTzEhaFvvBAHPqW5WT6wRR9Ah
 07DTOyhiHjjjNh824HZaykIQ9fR78ZkFbwCIueI59pNKJ8bdjNIvnbpqm+umE++yh08uAh3j2uU
 rNEBYuCb4EyDprUHML/VKoT1H/4XLLe77DQWsWPwV52oLdvcsHt3nVvC8Q2z4bEivIcleafJbQP
 xEEWQykeMdVe/5rXP0LW4lqZMTHu7+WpQNjRb9+b8gB3JQSzShfu5r9xtLMVUssRBRhYpfs+Fvd
 w5ayeISDir5JY4urOSkkf2VkXwCl3OLFdOVpsdEzpA5s3XCyQNSHgqZSUU0opvP76q6NzMANUHJ
 ZLGHj6gSeT7a3nKheww==
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CBD4E160009
X-Stat-Signature: w91q3noofxkkrpdw9kddeze8h61num6n
X-HE-Tag: 1767712381-147854
X-HE-Meta: U2FsdGVkX19SALQpXvoreXC/x6rME7PLLR15k2OmbHBPUZ0Zj2LIng4DwkKlhe3NPnW9ANEyK8SQxO/mUpcXDhQrzCb9FmR2eXLxV2ZYDDM3wY2goX83JTZ8XeqjefaRIhkC6UGy6Ox4U/v7X8y8qxw093CwTVuoVwqP21pl/6ta2QRZcY4eW6813jsgMwJttcVqDYIeDLVLUj0J+jeKo8pdxbTK1T1nHZ8WDFMcC43PojpQVGmkpLHrpImRqGvBJE8Nd/dX0xUK/yxoPiOXJcy26PP8Y7kVAOrvm6IIOIkHrVGc9uQUJ6PDaa9gJDiip4c2clPG/1GXyZtkq/QxVv6f4qArPcJqwNhqlT8BwEz4k0ZcZDDS7ZB7d5C8J0H4UEUWRNiuD+DRX4th4+VVRXbUPx6LtjUCBBRvAd0+9z+zoMc/PXO9zxk+cPqxDf6q4E/fKdDHD9kK27Q3GmQ5Oj5fePypT9GJGWiQ3xUSuFP0yJGNcAEZHMyLutvN/lOxfp6kokIjio0+Ku7lZQ4EpktG5cQcYarbu4sl9CIWeFcaNFrzT2t/NV7xxCfBItkWcd95zqDDQzk7taduBcQhY9wABaPMZuuTTz13NZKZWwKyU7vJd3sZCjoVMqYg+Nsbgymd8eeeVzqGSmYASfIlC/ZWhib0YuV/s4/efcPvM5mpO8X13QOVmbX7mMBZa4COhiuYCec3/tROTdETmK1W7bcBFnYD1B2MtN2Teaa3nw9nN/Iyt/QuTsnQyl8Lt7fTzAsfrCkwsH7H4wzjbg3WIM+lar6X/KaUr1RxShpij+BB9Jcg1qSvdBu495jtLESiB9ewx8P27BtUHC8BEiUK71cwYcqvdcgkFwvTry5JUlAVQiiAm2YFN5m+nohtXM1bFaAukOuBiAZ1gRZakVBWMRY9NGcE0qfuC0wS9edFZsrBBHNF100lLje+bj0vaNv49E51gAXqxDenDT0bsMD
 fjhLHW34
 0jjZclhCUvqpMmrrvx+VYbnTh/nr+T5DuBR099M1yJv25wVzhRc+VM3WpWdQXJEc2GNneFm5QPG/jQh/qckVoLSZ3PLuip8vuuPys2+PznzrfVZBzTQ2JCw1cfanqtMeZpPqwCIEDyRMtJw6LCgqk7e/p8SNiymCmsUV3I88VJyfHv7cLYXysmWlJXbEDq49zHWbNHIDiUvXVOViwwu9CT0CgF7ze5Mdce5shA1yPhYxIfqCmAcnJJTJACdrKQCkdLd3xxqcXbqIrJnT3I16BytXanvphlHHN2mJ0he0qQZy9ccodHF1Pm7lVOU3TxD1A04YQO1aIP22YZwtYBRtd8kUaQsk0TFl6P9poX/N7KswxWVCM1CiVv/MOpqMRRgbCvQcoGBHe1MRD583LQDC55LAzsUTbek/xexWHOB6xSu53b063TVpqlHsa076GhC4EqNP5tZ78M883R5E4wRv7E9cLoAg8g7kdrFPShPAV+60EyACY5sDvXn9td7NX0f3RixlXAs/r0bRkz1qh/ax60wfes1Qs0ZGYgcRln8ZqmiqzONWbydn8LMY9eT7HEl/9bP2nBEIkWC3xhlj/+hKnGVqa8KQoUa3EcgONV2sL7Vliy/QNT5lAFG4b8Sh59zWsHtnO5Wws6XuXTgrBy9LYcH4Umw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For both anon_vma_clone() and unlink_anon_vmas(), if the source VMA or the
VMA to be linked are unfaulted (e.g. !vma->anon_vma), then the functions do
nothing. Simply exit early in these cases.

In the unlink_anon_vmas() case we can also remove a conditional that checks
whether vma->anon_vma is set.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/rmap.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 54ccf884d90a..de2cbe860566 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -314,6 +314,9 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 
 	check_anon_vma_clone(dst, src);
 
+	if (!src->anon_vma)
+		return 0;
+
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
@@ -474,7 +477,10 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	mmap_assert_locked(vma->vm_mm);
 
 	/* Unfaulted is a no-op. */
-	VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
+	if (!vma->anon_vma) {
+		VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
+		return;
+	}
 
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
@@ -498,15 +504,13 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
-	if (vma->anon_vma) {
-		vma->anon_vma->num_active_vmas--;
 
-		/*
-		 * vma would still be needed after unlink, and anon_vma will be prepared
-		 * when handle fault.
-		 */
-		vma->anon_vma = NULL;
-	}
+	vma->anon_vma->num_active_vmas--;
+	/*
+	 * vma would still be needed after unlink, and anon_vma will be prepared
+	 * when handle fault.
+	 */
+	vma->anon_vma = NULL;
 	unlock_anon_vma_root(root);
 
 	/*
-- 
2.52.0


