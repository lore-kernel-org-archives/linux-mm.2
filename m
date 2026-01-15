Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C9B2D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59406B00E7; Thu, 15 Jan 2026 14:38:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07906B00E9; Thu, 15 Jan 2026 14:38:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0236B00EA; Thu, 15 Jan 2026 14:38:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B597D6B00E7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:38:01 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F327160437
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:38:01 +0000 (UTC)
X-FDA: 84335208762.25.CFB86C0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 248DF1C0006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YiuOypUl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gcCNigVd;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6LVtlBaoIPDMMFIKc3RvjVqxlytWTaBi1Y0k9XZQcM=;
	b=YTaPg2CFy3McqsU7T1+Dj7+ASM6XJGENcKGXMqpTtoi6nv5Gqwz+rLwE1lJ1FXrkUx2/gb
	Ypkt6fzGQvYLa2jPZ2YmpeuKE2PQQJsd6nSOOOCSGO/IucEdqzpNpsxCPv/y1I4rwhprTG
	3olB07oeIuK06ptVloZVpj9VDjECuUA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505878; a=rsa-sha256;
	cv=pass;
	b=njkTNdxGI+lrEB9AV6NQrQwtfTWM5E9o1az3YsgLfbT27mw46su7zgXRazMWu9kYK13Ryh
	uMivYeXTB7/xBn49uw9bxkbmq92/TljtdL6ifjtGBLeyYblyadBXEF5p0I/h8cqYlXAV0J
	XI1vFDevBRFQRfNRA6FuI45Amx1mqsY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YiuOypUl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gcCNigVd;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FFlQ1f2811528;
	Thu, 15 Jan 2026 19:37:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=j6LVtlBaoIPDMMFIKc3RvjVqxlytWTaBi1Y0k9XZQcM=; b=
	YiuOypUlseKL1dca9t6g+RLbEzpE9BAGIwdylUcAFPaudjk4YAeZmV/AnKi79CKl
	Pb3GVJpvJgm7RC3LpuGz5roV5LwELFf1Upv3PUi3ohB5OQNC9v6EfoZbm/2O++Lu
	X+7zELTVArPaLH1S8ASRqfi476nEn8GvheSQQzeZz00yHkGxJOMyKY7DxB7bB7Ze
	ZZubucyehjtOkoxyCv2gRsDnvrNICUHnM4smkPw5JQSgxxWihMhRb9M69wLswkJI
	jHUcU8qIkFppbEVSCZU5S+8A9MObwGmjyldoUqhEjVZ+cx/p/WdeRAI5ADLu+Sq+
	RxhHQNMzb/h+FNOlIWJ9kA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7nrnrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJ0Z8l008270;
	Thu, 15 Jan 2026 19:37:50 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012031.outbound.protection.outlook.com [40.93.195.31])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bffgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p1hI1+8PuxKR2tiQ07MphKIacYtBTS72iXy6rrSP6yN2UhQYK0TfgVQ4+5SV30zvamKXdsi4WdDtHLa9t1ryZQ4sR2glLzJSTZnFZEKV3RnUWoS83od8/TqVUtfWyjPF1wPvHTOk/Q2+3l17heMpYNZweleoYoj06BVChrDLXxQXzd0gy4/ZrEgZ1ZA+RYqqBebbOQg1m6DuAaMl7kEncVthyE98OL8NP9KXcfZLF7WE6ZzAEPB8DRQIXIr5igVr2FFkzR0C8P4xBM4FuKzQK9M8YgCv/MscQBQWwD+YPZq3vqgSIJ+OuwlsSmzSi4pfSn99+vFyRBsFQs+JySDI2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j6LVtlBaoIPDMMFIKc3RvjVqxlytWTaBi1Y0k9XZQcM=;
 b=RuCuKm+hL9nc7HEhbIZDp+cD/iuVTU7uyFO9YBnCxbH31eOZ/8BzCwAdoYAUy07/q8zguhH+r4/Ktuf8ZXtwBdv89TazH7BpHf7G77qN1Z/Qf4ACVXDJj8FeGRx47Nyov1it2axecUXWJSZjo6dngK5PZZGvwcvRUaTRBzTcgaJw0QNNimASha0gzd79KoecMe796eR3gyC0h6zq5wMMRCz1oaMOVF3iXkW0Q8Go2JAeJKIbKYk+V7FgrHrOoCkKZ95TALxbZD/a7GS+wsd/WVUuyiWxNZDV8k+FtahvDcWQvRpdQn33SjByp5vmFaCGD3NENQviRO3ghbMoYQSBhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6LVtlBaoIPDMMFIKc3RvjVqxlytWTaBi1Y0k9XZQcM=;
 b=gcCNigVdkrgGVfFoZjv6zBPhzaH9e5gz0clmS6XozXirHhLWww8+FkEHAiADVcY3Tz1KPaLzcKgkJzQHEyyKLNBSLJ86N9OZQCNU4Hndp1WQJzG0VuWfCaWTS9shR8JHbXhWKC5QLQ2HM1EYLr5xr7jZPgo35A8sPXPmiqpZZhU=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:37:43 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:43 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 20/28] maple_tree: Add cp_is_new_root() helper
Date: Thu, 15 Jan 2026 14:36:39 -0500
Message-ID: <20260115193647.1695937-21-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0131.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::7) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: d86ac304-7341-4245-080a-08de546d8d4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sg29pRtR48NgfmvW7/9OaaAIHAvpue3zlZEUpNzGbV9xvHthva/PGXd3JvUq?=
 =?us-ascii?Q?gfuL25zYPyO0tv7p8aTwetDzO5SI46YMqyMbv/G/JqVOXSU3OQUhpYi9KjbM?=
 =?us-ascii?Q?gDo1uREiBGZdezx2+PNXfRh0Y/sT7jRfvo2bKIQa+3UphEG/NCIVMW6HNphV?=
 =?us-ascii?Q?nolmwBCnGLYjecrHTzHPKYnDl+pNPDlFdhJZzVGaO9MyV/IHt0LXFTxk5fpS?=
 =?us-ascii?Q?IUb9wztHqciUTL/RZkouELD/0IpTx45029o5Ne9WgK7KHEq5HYgMqQxl94qs?=
 =?us-ascii?Q?IVFsr4PZMIuwoKJI5rWkMy7/xcPateIopZSs0EIyVt/9jkanGSyNT6Y2ds2k?=
 =?us-ascii?Q?7GY8GZjm9eg0FSiwPUv4JhVuABt/bozcY4aDuc76AgXs/nMrvtubgDrIfPhS?=
 =?us-ascii?Q?TmW0/+rEwo58WwV1DwJXyH2/uxdWKPSmlBOUCYzJ6htMEl6Up7LJ/tzcdDGI?=
 =?us-ascii?Q?Q0lNaqwe6ZLPRQQ9dOTluHCOOZtqdyhOrZmfkmQL2tendaZ456anAK8QhSlX?=
 =?us-ascii?Q?VCc1l5GnPatoUFFC7eglhi95TiUrkZ96inkxWENt6KKjIyD4ibvnvnFlGA+I?=
 =?us-ascii?Q?+XyNycal0B4dJHSUaKJW9DWa3TOwhS36fu5IPIL8NmQOLyhzEnJVl/MnbEZx?=
 =?us-ascii?Q?evpfWnaUxWt8GZVYhMxvNnkE38dkZSXXq9UQVLvYTkPBQyFMUI7ntL1Supck?=
 =?us-ascii?Q?m/T2GLoFpG5jva1tCejSkHHpWsB/bZwJKSXy94ITn2jFbXWFGRzXaceKiIkO?=
 =?us-ascii?Q?ci43nVpJBiDNpNXaTIU73Nf6lXQl5rniQBW/XrpmfZEdMDCzdV4nxYADvFdw?=
 =?us-ascii?Q?ozroE0juHnMVZhbnPdQYNquc5cW/EbTwjg4t5YEnpeXMP5DlXuOoirCG5Dzz?=
 =?us-ascii?Q?Im0GP5qjPjRpqbPltXOa+j7J/Ue1uq4dtAPkWnuWIcmOQ2EYtpAXXjP33E63?=
 =?us-ascii?Q?tUWLg3ZtW7FRs0GnrzvWcbN+D0uRo5Zfg3olJhYDnXTraNUsbxEailD1ymhP?=
 =?us-ascii?Q?G8BRYIGNnNnrguZ5Rt1TcdYtfhzy8+JeW4UOky6mgN6MQQeLfomjRzUAKxNB?=
 =?us-ascii?Q?p864da4f55bhe0vN1BAsGs9tkagXy244TGAE7z821qGqVvFbFPi8wurp3jjh?=
 =?us-ascii?Q?xOsa9YOdfGx+pbibndrRz76lam8lcjLUk8AB0PAGQHJKk81lmD31KY9zVl6x?=
 =?us-ascii?Q?Hae0fTc7HOoUECreM2XQmoatFD74nIePNT34T0aU29s5xBfv3r/FkpYIdXt0?=
 =?us-ascii?Q?Q8SVOv8tgF0JtpjWhuseoAI6glSUxaT+toxzPCoiRrpKZ/y20Qtr1TJLb+WA?=
 =?us-ascii?Q?wLmlQ2gKqPP70Ks4Iv5pkbsMqUF/+c0RCAqeh+N1dSnaii8sAxWqRRg7+rbK?=
 =?us-ascii?Q?+31U2Mg8/R38StpQeKeOBbaXEfbKpDF21RiLBlfUJqMvV5gmziUgvTF2Ae3Q?=
 =?us-ascii?Q?jiTuSQR/IiDXZFcPA2WXqSo4wg+LS96TUwWnS1JfmMmGAkZNA2TEwl5eltq9?=
 =?us-ascii?Q?u9HjoxRGrAgY9RyepOH+BhAHaXa6trdkfSmBfzp11jGtH7N6A72uPwgZKFkI?=
 =?us-ascii?Q?6BzhGlOyugHkoGcNf+c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KTJ1cq5qKf+FYKfgsgTBUKaTduh9oR1RFqnBUzT6KoXUqSyleu+adVN2Y+2f?=
 =?us-ascii?Q?CHoKwBhTw2N6b/qiY8tfsTKVn9imA3EC5GqJ69xHGQ+wIJdheIUfvmjWNiIb?=
 =?us-ascii?Q?0tmaFYXpL/gVTJB6WOEQvBEvkWq0LD1MB4TdtWfMlWJhU2o6rK1N9a8c7oo5?=
 =?us-ascii?Q?rNGK1SuikVin5uqeW+O9vdx0SxcYjGkqxjaLTBaDHgU9b8dKJxRIyovNw6qL?=
 =?us-ascii?Q?OUorT2sXE+ZgP7HH+vcv48+enpoTeMpTZ9zaRG4/IkAZ6F/qTz+H0S4ibeSd?=
 =?us-ascii?Q?Fi3npVTxOnEPHm85tSJVhoOUkCz+ZBJZSHlZKDc7/CcmGcurS0ZCXvZYDx/M?=
 =?us-ascii?Q?xZpuK5FMm5w/4T0QaTkgPLAUlvueYter6pTCGglbwVU+2p7etFnFp9LZXnkH?=
 =?us-ascii?Q?7Gw++hH8viKI9EVr8Xdmqr+g2q7UYnEzCatfcKnAJwGDr9TLLY0r9vtSH9TY?=
 =?us-ascii?Q?j8gbPYs2Sz2wvWP2Y5hvnnkKGCiUw7JXENSoIBFgEGzas6bQohu/mSodLE6z?=
 =?us-ascii?Q?vDUuEJCPtljid0MfAxrZxgXo11DI+y4ztTIwa6NS/HKzUIAvidc+Kdq2KpOz?=
 =?us-ascii?Q?ows12pWwSgP5BV6celbbBfey/p0h+U01StciEbPq5STN79wWPSfupH9WGugG?=
 =?us-ascii?Q?khRGbCl4QD1UAKNE9BeQ9gIdE6L/1GHgLs7x8Zq+w9UdFrPDJChAqBn37Sj6?=
 =?us-ascii?Q?Mn8XMik076Clih97SGN6TmXVXutEWTvmNs2wyOuBD8sxoYBZa6ihn08nCC1z?=
 =?us-ascii?Q?ybuYkPdv8y9RC+67IzhkcluJKvieMzwmLIJYFMupnYq+2v19phTdrulyuDCr?=
 =?us-ascii?Q?RhJp0E6u2Ej2g3BIErqfWRwIDA/FjdP1H5XCsW7yruHhaduWl2o5JpJyaD3M?=
 =?us-ascii?Q?E4q7lkYXjJX2qDNHsLk4L/RIMUmtrIhI0W93re/epyI1Ldpuowwn9RkqbG9q?=
 =?us-ascii?Q?PWu25EMABV6FTMKV0E+0AwHKl9CIPiK71v6V3YApRAIZ/rdgkpIr6fhy5Icg?=
 =?us-ascii?Q?ZVv781UY2BYmnX062Zf08wbs91yMGSjzGObZpcTLth34Clh4rEUGiJ6uyvAK?=
 =?us-ascii?Q?QFj2kndzYXu7quUdhQ2xpvhmyi9YZcGHd6173ftnHYqh+csOYa2Q3D34Lch9?=
 =?us-ascii?Q?C6S1lN9kwnI0avctsZxiil+KhoSDOUCs4RmkRpwaV/EDoS+VdH/Agx86jKSV?=
 =?us-ascii?Q?HceYLcZEcL9HnmybypgFN3yMB5ZCmhm94XAbAqtQUU7jk/VOUKOKfc6wTDu6?=
 =?us-ascii?Q?zwzpjGuFY3FcodHfO8ITb9l9vhc56I791Djtu8s9k+YKCa4b1GCzlxyqjeO6?=
 =?us-ascii?Q?rugc1UM6QePpaBSvqlpfVBmqTCihybYiqrmJj0pXI2rB9kxYPdfjM3QYVpqC?=
 =?us-ascii?Q?LU1/IxyJ82K5vs/zrQCBaarCK8GBWRIonZ6p7tHMcOiYDmoHglXGIyegjrq9?=
 =?us-ascii?Q?Orq9imr6lS7ip9BO85CNiiJPm5DIIt7x6NIWF7UNizBGFO94PPyAWwDbqEo1?=
 =?us-ascii?Q?kA8JvLu3SSghSIN+ycdWS8WG1Cuon9KrYdmZ02CV7SG5vcbsS4q/JtIEolom?=
 =?us-ascii?Q?iDjYwsd9itpoc6f2QIfmP0hNYcbRejIQSiDbsNPQopkscaMbMfkca0be+nrc?=
 =?us-ascii?Q?hwaDuqBIJmmffp8pNyz8Bfou+vo5Gb50ivEVUzNh5W66b8Z0Mmz/wMllCiMs?=
 =?us-ascii?Q?3u9r6eUu2KEGmz9XXrWn8qulB2d27KWtIh/ms0Tr7vlK1BxozLmpYcicDINx?=
 =?us-ascii?Q?kO58pG/MFA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5NDw9b2gtzvbGRGb3Khwb7PpsAdg704iWymfu/njAkrk/POLEVmDeYGcUwiMresJwijKYSP8SHcn9EN3hnDLCK0Bf8fA02wxexW865TryIzz+jbuFFNFSFsCQdXdPPwcM9n/Twi7WPu+y+tnx2kFJd2FSEVoc72VHJ+dRfG+mwwWNHh0fEeOjVhgPzsuld9MPIae7kLja2WYL95HwfNuuuq8KgG/2oCUj//lSxaQV4/CoHjpVb6jdxZnPb0P7sD7A85MEuY7i48H/Fhr1VsOwZtUGSYiJmmdg4gWtHCnylxrVenZ/2BJ1SZIXGopkiAdxnT5oUepRX8L68x9tg34pxxIIPdLEy8OEVb8i9P7Ts8gJEaEWcZtPMyGr+dnqefD6eAnZJ1l3ornW70x8zExtP/Typ3tCJt92s78RAws/uSr/qWZqmAU2P93+JKGQledhxnV3AYrb9qRs7RKVuD6eslQ6qvsDr30qyXm34RE1byUptwY/FOm77Fi0LGdtH0EOsxbemhD2NA2tvzlkSCS673AXnv1IW5Bc+M3fVMoEYvjhtTjaRGGbAsl+o8vIgPas3P2BnYxOCPFIv+jHAWp2DfcPe56UKS33i9IcnkJ8+g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d86ac304-7341-4245-080a-08de546d8d4a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:43.3119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HTg7l50QK+aL+xqlLDIMCIl83UWC0xPOlu3h+01mWvkxabOQmqSdkGTdZhWPT7vBlkSiXGOkPRPwgAk6NQMQsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150152
X-Proofpoint-GUID: ckCd-s8DNuoAA3vfYiNX1_Rf7Md8rZ-4
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=6969420f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=-GcjlaOfWHWovNXw6HoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX7vI6uR/Tc1C4
 HlesWOE/gV1cRC5szcj7XmfHvSABOALTdd4iPg2xTh2u2iG+h0Hnf+QG6CtnJ3n5iSjOUCm2uqE
 UtZo6yIhou3b4x0g9yvaYTo80plABgQUKkLAd3kvU1/QcvAVIH8X3UDWN3eUfkuX9BJAIKQUhfL
 aJyV4Zbm+ScpefBLfZhFTnckWCNU0gstGXffg3Q9Hx5IVu+rCzlwfOJo6a05bbjUraYSxMyMDkt
 ElwV48o7R2/32Zs9fZPKZz/7ZPH6ViOhO/glulxcIUdZfeAUep9w8euDkt58UAweuh5twHXH2nd
 g4aQdacmV5NY+rzpdJw7n3fEj4iCOjOEXxQwNhpkQY8aIToUrex9kfLxGlKEl9dYHwIMFGmMa9e
 ge98g24hqIypQMY2j7RLzxmQ7sCghCA5d4a3EgeS8T8j0i7r250ble7CzbHphUvDKUeTr6ExUFL
 hD7G5MtYq+BfK4mkQjA==
X-Proofpoint-ORIG-GUID: ckCd-s8DNuoAA3vfYiNX1_Rf7Md8rZ-4
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 248DF1C0006
X-Rspam-User: 
X-Stat-Signature: e1jgcuiz9t3qdpa4okq1x96dobqu4hk4
X-HE-Tag: 1768505877-257241
X-HE-Meta: U2FsdGVkX188PASkFJh2lWWxt2QOhBepIyRcmbaxV9aYyftLI5Bd0EDYLl9Bn5zXLVCCOzBTRCnuFVRzQanlDacAPSJEnjwHJh8M2GMc3n8ok+jL55oQ71OClgePn+z0gZzykAWkppdij9D7VRKrabVxnCdnX4mCZtzSoNqW1pivtxBoxS4ECHpz+dKUpsHpFlKC0IzEIFmZ99cr60xa8mZwqYtHcjQQGhXVbvgTcVIM9j99BkzdIIUQjCkizS4q9NllVSD65MKFju/94+Pr7dJC6kdXZHGd6v4CRmUX+psoWqY36YKDDn/QWmMHNO5etiCiGNI+2lJ0Krw+KReCELqRbqkdGTIIEY/aJ21D7CL/NINtbLNzEjFe5M/vEkzMCzw3OXc6sVIZfcXJvz7lt6Zv6TtkcMMBrixBPIwL00kqOwT+AGqp4HDZEPZG8TIuIOX/o6fO6c660Hd/DvVIAe6Wg1n2cYxXaEkru2Rh/0LpzUhGVQ9es208zvvLmggau0I75Kz9BPpkwhJ85EjoYFp2kCzBIPffXrLPwdVBNuCL5DJGTVX7/5jL+BetlHRnljKjSzJjOWO69spcNojlACwFHcvs6Lh9QPMQvumEAM4TDkE8+Er5YdYxMmG0gg+BH9WcteUH2HsGgdfHjw0pEsLI4iRCSp19wJpNOWMWZ8StYzIB8fRLkUnYBC/Vv7EW5qKpyaG/P99KTHHtXXYpH14DJrg52fIwY3++5oo0X0Cd6Tw1oasU+Fu53mWZ4TXx/Yey3VRNiRFDQXWmHnb9DZjQQrLo7M4GArf+8yFE45TGtsDfNSninqIp+a+/YfD2tEml/rbjwf89ThdV9DC60h+RcdbBvpzjQ/U+EH8LggBlLOBulTASTG/46s57DxQAY7nNZQN3MX6yKL00J3I+bVSgE8MsaCvM6LxLOMAE4e5nbmVyAzbxnvx2Tah5mUt0AXcJrPAKdhqSoXI0Dg5
 PDc8+xN7
 Ihh0SCknwECB39ViCOcgKphI3R+b2i4ReYnhzThhEzOaNboM3TPYcP5sas346dHNVdv1xcZy04L5EWp3k5tlZ3tmqzAqMijRvl063GhwLen2rlgNQd8x/SsvagGMwfsFxFGamUfOZdTjv2TWl8BPR3PaaoZlMEHIfHYq81p02VAOw2zYO1kx9sSdNHvC0tIRYCJbskhNwtfaPDUsL1xPBJMvPnlJtxZnOea9HLJ9IA9+WJ9Rpq8knOZvOnhiN3ZvUuq78jX5RtA4SBPLfrjcjp2GzNDsTWNVLz/zkVrkbsEIBzdQ2u7CRSzodc3g8vOgVZvDdcs6M0jzdBN+/3i8cXE0zpMPqOeKAy4IC7d0uK/vu41U+D67cAP/WpygGU5knZxnDXb39zJFUJVhhqeue1evarNnjDXGRfYdtBBVREp4QiCuTIN9qwa+Y3eyLZArkaI6fo1qgGFFU9Lh7NER6gCtrUfd6cOYUnot0M5t0ts/KJIK8JKYmvEiFa+Q2qan/YC9DQv8xRd0idKM0rZd4NcAETPVt7yjHvUApGBNgCimaEzlNdBHAOrl08bmfQulv97K4vmMYtlTrVrzyDSaNjtDCH4n6G+Vhd/WY26ml/AxN/mai6+3hIHvaBM19iXGwar3vHUwq9e5q9THfar0+wWSJvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a helper to do what is needed when the maple copy node contains a
new root node.  This is useful for future commits and is
self-documenting code.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 56 +++++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5d871d91ca49b..d9313e63096e3 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3314,6 +3314,36 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 	mas_spanning_rebalance_loop(mas, mast, count);
 }
 
+static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
+{
+	if (cp->min || cp->max != ULONG_MAX)
+		return false;
+
+	if (cp->d_count != 1) {
+		enum maple_type mt = maple_arange_64;
+
+		if (!mt_is_alloc(mas->tree))
+			mt = maple_range_64;
+
+		cp->data = cp->d_count;
+		cp->s_count = 0;
+		dst_setup(cp, mas, mt);
+		init_cp_src(cp);
+		node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
+			  cp->dst[0].node, 0, mt);
+		node_finalise(cp->dst[0].node, mt, cp->end + 1);
+		cp->slot[0] = mt_mk_node(cp->dst[0].node, mt);
+		cp->height++;
+	}
+	WARN_ON_ONCE(cp->dst[0].node != mte_to_node(cp->slot[0]));
+	cp->dst[0].node->parent = ma_parent_ptr(mas_tree_parent(mas));
+	mas->min = 0;
+	mas->max = ULONG_MAX;
+	mas->depth = 0;
+	mas->node = mas_root_locked(mas);
+	return true;
+}
+
 /*
  * spanning_ascend() - See if a spanning store operation has to keep walking up
  * the tree
@@ -3336,32 +3366,8 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
 	}
 
 	cp_dst_to_slots(cp, l_wr_mas->mas->min, r_wr_mas->mas->max, mas);
-	if (!cp->min && cp->max == ULONG_MAX) {
-		/* New root */
-		if (cp->d_count != 1) {
-			enum maple_type mt = maple_arange_64;
-
-			if (!mt_is_alloc(mas->tree))
-				mt = maple_range_64;
-
-			cp->data = cp->d_count;
-			cp->s_count = 0;
-			dst_setup(cp, mas, mt);
-			init_cp_src(cp);
-			node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
-				  cp->dst[0].node, 0, mt);
-			node_finalise(cp->dst[0].node, mt, cp->end + 1);
-			cp->slot[0] = mt_mk_node(cp->dst[0].node, mt);
-			cp->height++;
-		}
-		WARN_ON_ONCE(cp->dst[0].node != mte_to_node(cp->slot[0]));
-		cp->dst[0].node->parent = ma_parent_ptr(mas_tree_parent(mas));
-		mas->min = 0;
-		mas->max = ULONG_MAX;
-		mas->depth = 0;
-		mas->node = mas_root_locked(mas);
+	if (cp_is_new_root(cp, mas))
 		return false;
-	}
 
 	/* Converged and has a single destination */
 	if ((cp->d_count == 1) &&
-- 
2.47.3


