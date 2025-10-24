Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7103CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 07:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD84E8E0002; Fri, 24 Oct 2025 03:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAF9A8E0042; Fri, 24 Oct 2025 03:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA598E0041; Fri, 24 Oct 2025 03:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8918C8E0040
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 03:42:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5245913B9F0
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:42:22 +0000 (UTC)
X-FDA: 84032214924.06.469243A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 27586100013
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:42:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r0saK8PB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FfWdzUg+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761291739; a=rsa-sha256;
	cv=pass;
	b=1RgW4MQEih3BffToSDsZqwnK9+z/w64Kn0aijsaOo6BtUkSfOiV1/bLcoEOuZI3cMX0OL2
	lF2gmL6skDgTlHwa51IHMX/OxIHNazhkAZMALwLQQIaiuWPsxuqY5VOQl/UQItek7gRXHW
	a1HKwMXrKImC30i8H4lE/NimAC+qllk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r0saK8PB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FfWdzUg+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761291739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRg+V2/QNJuIOvfqJXKh8YDnb0Pk7yEMV7TG8ey5pS0=;
	b=ZEdZccoTnfqGaWjF55BMLygISP6Ey7YwSD8j+np8l0JbDVnSQD9A54DcqHSjKH2mu92KKT
	bOyylQnVvZCQSvwV+piZHI7dgKZ1wcUtmK62qa4AVsgfMRsKXxV8QqgtTmRTJfAq/tZbsc
	1enKWzLC4qOiMKJ8ruu5t5Mcg4uEFeE=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59O3NUkZ000813;
	Fri, 24 Oct 2025 07:42:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PRg+V2/QNJuIOvfqJXKh8YDnb0Pk7yEMV7TG8ey5pS0=; b=
	r0saK8PBPT5XcI8AdM6t25Fv0Jk1kaMD//ppw49vcPtmD7G00HXM2jAjZ+HJrz3V
	BWVk6D2Ay7TgPIVj8tw3pGNVXSjFYTDH0BXAupvS4EQYPlKlCQN9DzG617QWWU5o
	4TUsmmkaPiIFnTyfJc1UMOIf4H/NH+2VfMcPOwHp9d9xbnSbo+y6LuShGpWizIZm
	B8U8kpx9XKcE8l3TBwHsTZFcV5aqMz6mM8cmgm/Z48G0tBLvqrqIcp6yb0WET8Ui
	j3p4xs0RB9CfryWKQNQPCHE/kG+gk0PmgcMaNy93fyW5wXSKG/UcCkeOjIdsbysD
	75hMMvdkz6MRw5XoXFgNQQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xv3kv386-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 07:42:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59O7WQQs035638;
	Fri, 24 Oct 2025 07:41:59 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010032.outbound.protection.outlook.com [52.101.56.32])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bgm4xq-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 07:41:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u4DxmMGjURs0N+YX73W0PEqOcONdk/zT2SSLfbn1Ev1u+vfScAqtfY8c0mfJTAK8u4m8/dY4jsanHy81oGziF3rgVKF63j8vrfKzoPxNeNHQmJH1Rr5kGNRESoBqvO2mScqrsXcvMfTpRmqj4FrsDhbA3Arq34ZehqswWeOyua8HT8wyPARuPS0GLDnqvBEAxh+jNxAggdjxboKD6fapqdktI/QgzML/aAJ1ka3ciUujv2cYfzAWuWHVFUbuHqQHx5+oRhBrsTYrqtReCHYFcLYuueApRhzdLqGg0dKyvO1CtnP2s5JEDUDrBrLu+vyDwMVTp943APh9gOrf3rGANg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRg+V2/QNJuIOvfqJXKh8YDnb0Pk7yEMV7TG8ey5pS0=;
 b=Cvv67iZ+kgooh8WeoFG/qvfJinEB7tfVySXeJIuJEwjLcBMUkHRkemFCNks5C7vwd7VQ0Eg1k2DNHF670fhYU9SlGS7Q1pvAX7sS8k8wz+xCk0+lsOZ0B3dFnI1qvMftDnQJpanSnWa0OkkGztRfAPaM5w5T1rBMA/PGRXtW9TwhvDBcdZunVqetO+WouWvn7JbcCLvnfr7AWeKkeqxeZlgf9L/ActPtPSoBGSnfrkGHCJgYTBeFb1+gnTP1u7d6s4LPzJ3U6Vzwrsl2IHkftJcEbaJasj4kQ0lSx9mcDYKyb97O4rC9pggrcbdKnpSZZI1gofrZUtdQYQzoZq7Iag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRg+V2/QNJuIOvfqJXKh8YDnb0Pk7yEMV7TG8ey5pS0=;
 b=FfWdzUg+n4VM9/P3BVvsKMMJOZCtNh5dosFZub6QNvv2uoVdMwa9Jps5O0wTA1Q3RWcu6iQnJvwVoZmUUMXmUaDzJpRJlrRYWVaDqxvxE4yFAqt+dbnG1NUYoqUoFR/O3QxbAsYlPeaNQXOZtlcUaL1c/4Jtd20rgmfl4FE7Ebk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB6716.namprd10.prod.outlook.com (2603:10b6:610:146::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 07:41:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 07:41:55 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Pedro Falcato <pfalcato@suse.de>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
Date: Fri, 24 Oct 2025 08:41:21 +0100
Message-ID: <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0035.eurprd03.prod.outlook.com
 (2603:10a6:205:2::48) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB6716:EE_
X-MS-Office365-Filtering-Correlation-Id: d33e9159-8ca4-4a21-a27c-08de12d0ce14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pII3tf4U5ae4JYwbVBhutZhfOF7pvTDgP8D7eBdBOPdcHl7q+Yf6UZ5A9RO2?=
 =?us-ascii?Q?0Q9i/BOA/7sRW+JItMWmKBsmjX0y6Uw/sDp5QnUpsICG+z92JLPz9Rhkb0o0?=
 =?us-ascii?Q?WePfKG5ZBQeBsAZb7//+IvVdE/vzNYv1Y0HQTcnhezYuvrYMPXh4Oszg6lOn?=
 =?us-ascii?Q?vdsmlLPgEFdaHrrayRajNZZMLRJ64T8sTPX2O/JxSKqWJfVvgBbPo+mpMjGG?=
 =?us-ascii?Q?kKuB5VALTmvCrkiulu0ngHsz3XtOPetGAr9GBvYkKbSWCr7bVCaWoWYnnSO5?=
 =?us-ascii?Q?YirfSHKXWMpko6RjCGe86gZ2cXzuItKqe15rqeaIAt31MfzCPhN8dtLpAWJN?=
 =?us-ascii?Q?/KqZlN+n3auJsq+pyvpoHV0YpFdKdSqy+on/mGnAot4osS5q0Ux7cSBs0tI3?=
 =?us-ascii?Q?k8kTmuATVPlysUNw3/ZHUqW2Nwxwku0y0p898IxY+37mn24K6sIMA7XAACb7?=
 =?us-ascii?Q?yGFARxKYK2ZIRxSGRL+pelXyZ4N/P3QkbQJY5eKQrpVpX+4Xul+ZiT/uRBsv?=
 =?us-ascii?Q?MplSNUxy5enRovl+wjdWjyozZKuDr3ZSiAE859o0hUAuzYM7mzP70jvSfMfV?=
 =?us-ascii?Q?my6DS5542rt2OawbEVB0u65U906GR8w9gHAajT9/mpcZCGcGfzOs89gr+QUE?=
 =?us-ascii?Q?TKq1tTGEKkbdF1gBKW0R1/jABmBCPa+9T2tHaMITH13MNjeFy2EXJjMLJwKG?=
 =?us-ascii?Q?J7c6lss/xbiTkW+mMwnEndOpPHGYDZV9PRlfIW1mJhfebzt3UrpN0vSI/FUH?=
 =?us-ascii?Q?lGhPU+A6Co7R6i1MefRIDX1iyBLzuIwxziA1ojSkWXKYwwvO52U2upvJ792u?=
 =?us-ascii?Q?uabo8VGmIpxpGckZ+9R1HSOw5CYE7XNgwye7BHjAw5QILAOcr8SHDKETfN1c?=
 =?us-ascii?Q?00l8NdLgwhTSgtfzyMdCuFWRcDMUANXbdFWSTNg8rpCID10kK8a9LLJ8LSPD?=
 =?us-ascii?Q?SHUpFShuD++vUrGXT7Rqgx4i2HS/kL/boF1oNTCYKQ+cgFebe3dDYIHIhPKA?=
 =?us-ascii?Q?wct9O/fkcnO4fyHlSMsmpEwalihToF7AqLkpoROxqCoUL74XS8rdxpcUYHHL?=
 =?us-ascii?Q?oEH1mFpxnwn8br0HGRz9p2rdQQr5JzGC95b0i+QNvF9ZR6YHkNgJMKgmIb5y?=
 =?us-ascii?Q?2b+1Zeh+B5yYtltWQQcHBeDN65idfSFuQrMISy29JlPRmTVWw95jB2he9B1w?=
 =?us-ascii?Q?2TFLmZBJ9Hwtl0dD36B9SU+0sXXXTNGilJRXECQT+4EL33ldnZEUFEjbtRT9?=
 =?us-ascii?Q?2ec00UHJ37ywmYwpqXbbzbS4APT/fmqoTk69VnTvLGuSSmhWXnXhy0+HrBjY?=
 =?us-ascii?Q?D7n9cPdwR3CWLwGLh/Y12f2y/soPr+FT3CesaptRt0tMYsAJ9Ozc3KcBIzLq?=
 =?us-ascii?Q?GVPafKhH7QPB1OkIG2MQ+dQ5mDRrgLNMpj4CHggQZFWR6aEvfTiXs88wHZ1q?=
 =?us-ascii?Q?Est2V4KHBrPea8UrtVvuU+jTbJk7fU2n?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vuFR25BIJHtqYO/P0PhJQwRf8haIlNrQCFo0CBNjbqlCBv+QrGapkaNV9owZ?=
 =?us-ascii?Q?7ZEBLkgsN+97loNuOCe9FGGlXwMU0FcLxMESuGrUYsw9jRwksO8vfzD8dnw0?=
 =?us-ascii?Q?IHAa2w/GUZcIugbzmlz23wIsS55ivGjUybUbqac96LTJOVLul8j6a/lE0/i/?=
 =?us-ascii?Q?ajqJ2XS0+uRN2wSQwZdJdeixy9DqsFT4TNiXvnuW+5jfsaPA+Nb2GfmnacoF?=
 =?us-ascii?Q?WnhjpktUsykCoCrdsqTNDYaxUjwtRqd7SDfWsocMK4ENxs5DYZ3eg03IEWco?=
 =?us-ascii?Q?YPnRgs4XP5m7+WScmcFGJEzI2AtLWDL8Dts7ruxR4K/KshcLDPs9V/JNUm56?=
 =?us-ascii?Q?LjqwSFg0JdQrjjN2qxTQXZkQy3ftNvIBdjV+BiQsuvh868LTPGCJ2UzMQkW6?=
 =?us-ascii?Q?BCgu1gzLARQ1wPh0aAgbgBH92XWWXkSqeEXWcRLWJEYpsj/MhCTEVztECBSQ?=
 =?us-ascii?Q?KQntwb4iF6hzR1PHHDnimQupuwXXVf2HAscIOkFh1+5jzdLFLVaZ/4JrGImn?=
 =?us-ascii?Q?svoOxK0PaPLTL0BOftSsOTpj66+5wp4uIU4Xqj6gWL2ZNT6YCBD4XInarJXW?=
 =?us-ascii?Q?lg+xrMLVveOyE8fBbmOWQ7QT732yUM3FLbe/tW1QtodbHGlzP1TOKtCIUcBq?=
 =?us-ascii?Q?LP6bWRw0VXJAAqrWZFYDs10en1865VjX/wK6U7z++qV9PfCoC1E9OSzt4ep5?=
 =?us-ascii?Q?ULJB+zYrFMo7S2aSkQMhgW0mydBaSW5JtyBHG9Z19ePoi/ic5rlB4iMjQorU?=
 =?us-ascii?Q?gNINP83/aK0N7KX7WFQmqtEQDF7IfDd6yyVgd/WWv8/Vom5RE47LQomLn02H?=
 =?us-ascii?Q?sZf+5gE1FxJ1TTevblPkXCEDAkDcAxSv39EGoaVfgVykILuoLLVS11knhcci?=
 =?us-ascii?Q?KZEG9Cnge8vRqz2shr4Hz/z1tPt3RA79Rwb/XGakkKOREER+Xu3Pp24SMuKy?=
 =?us-ascii?Q?sdIUqAECFPlvDpej5t6MbYg4uDpFu6/ZvF3GCDejzOOWXJy1VufxjvwdxVxT?=
 =?us-ascii?Q?Wx4ZgGxuexVpxM2vXzC4UEz0WDOWPbe7WPJbPijPkVStLcexrs9dpvfA35Hi?=
 =?us-ascii?Q?4UrtX/gx5krf/uZQlrkh1bOZQf7PpVXHYbUSne3yy7wqOnlYXrwIkNFp0bji?=
 =?us-ascii?Q?lJARC4hr0JzwFkDr2/FrhOnSmPd94U+97V1XMgmXoLauWoIECws22+UvpnHC?=
 =?us-ascii?Q?daNK13+vviJeg6hRjBIKN0YNKtZVdqi20qOiPLSb48v6Te9XmGViSQB9HVYH?=
 =?us-ascii?Q?ZS2Zb3wB48FZALf7ey+NKkdJzrgaAvpaNE0+0VIaSY2okg7yPxfC/TlSKdcB?=
 =?us-ascii?Q?W8v3CUuZ75kWtyCb4GyQ504bp6qlPJ2fgcN+iHjOqLwXNw265dyuKWyDdBUy?=
 =?us-ascii?Q?iAeXhU5m7eMkhDXB9SPVWe5MCSKeOjeWaGQl+Pyg2vS2CH5wnGAPOlBtCaHw?=
 =?us-ascii?Q?OAVfp12/py9uEl4kwhGlVxcYR+2CX4Tp+Ayz26VFy8ErOlgD0P4OlGphlvBd?=
 =?us-ascii?Q?luXy9MzD3T/vdh0GOq7UjYqp0ix1eugcrItnlupqFR0m4JjXazBpKuKPpjGP?=
 =?us-ascii?Q?7nLz0us/WL9nYnP/cr9M0IF8HW5qKdI6s+F4zzmBRk1wJU4F3usCD85zgW3W?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/GG5g2On+VN36gy3JvSy8jStQknRbch1bUxKJG7+jBNk5VBdFPtDsewcrY8e+4HOd3eNRfZ7UDNTPIlo/TGmQsQ/zJmMNZWQ1p3nSMLsM8LzJBraGaVb4qe52ggi5Eb+9xX0T++3DA8HDB40B4rPSMBnrn2qltGYHJZOhlG7EPriuXdhqcgA8DPBmjy95H9D3iGuWTKGbss20ifqYH5eYNug7jQ5hvylepUWLVhNqG3mHiXq7QWQ4CcCiLbFvZKWhvXT4cVywUYy13vrl4JMMVsz/mPK9P1shr/NUy8CmnVqke5gEwcyGBnOWMBS/3BceCvlS8x+u2tEkl4SK36jGc3Acsfk1KUldILQstAwlmKFFpGuO0PwZxdZoo93zZ0RdGjJy6euJYL7f8EHxLfRELeOE7HA16iyesd1ApcpGQjHv+krFA6r6dmEGfPjtNGrB9b2VjWRsD25ZYYfBy/0TmolLwFL8hUicUweIyHGz++UMflX5z4RxvXK1phOx9rpv1OdDs7n+fGO6pl9aEUdmD8k8ueZeCXwO9RO+Xaw85YhRWygfXcnZ1Q7fbCLagEoDuDT8Gu3I8Aem2kVXi7thsIcnI/Z/ozOlzKeybWqUto=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d33e9159-8ca4-4a21-a27c-08de12d0ce14
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 07:41:55.5013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VYrVglroCTO2k6viyBanAUon4WDzOQy7gpKiveZ94T0Th+1V5NFVYwQGWbaHTVzmcu6W46ovF+wF8O8vLWYZ41ypX0XN4BmqntTYosZr+1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6716
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240066
X-Authority-Analysis: v=2.4 cv=acVsXBot c=1 sm=1 tr=0 ts=68fb2dc8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=r4PJAH3pRi85-HfG15IA:9 cc=ntf awl=host:12091
X-Proofpoint-ORIG-GUID: 3bdMkPLWsAUGtbcCv8Uj6MQ_9AsbDK5D
X-Proofpoint-GUID: 3bdMkPLWsAUGtbcCv8Uj6MQ_9AsbDK5D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MSBTYWx0ZWRfX6YFJFm0eOSNq
 Mjx3EPWyY55fUna0m03CxKaYxXNzpDeRKyNRHxKZAgntVv1gJGNa3SpxZgA6xFfhqsfRV+AbSa9
 LBtTCK8oAlNeN26/1Fo0Etr1rLnWMyi9lMxyFL4G3jNm9FjRg+c/DIoA3NFtisQ4p0TO6W//peG
 EzsHZ/5iJBwqbDL1cQ9G00GSwR7PACn6ZxYAydrkA1MhE4pg5k/V2M1wp6Pko9sujKZxkIYO1w2
 10TEBNIDwCNObLWdSsrvfw1jkkpgvAmeLsT6qnCtzlXPwgn2sMXkKZ3scFsUCGaeHbK6IWrY5iK
 wP8bCHGG/1F2e0PNdxNhUcjUEjfotR3DxmEdekGxZSW9x7zlUtNqPSr5lKlksFY8uf9/91WNeze
 AXxUy2ZmbVYk5uBZQA9xl6JWw4jEXiDdDlj+mtgoc9zEr0mqE38=
X-Stat-Signature: 6d81aoo51g3qs1raz3ykmo9pztt5h4ef
X-Rspamd-Queue-Id: 27586100013
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761291738-249299
X-HE-Meta: U2FsdGVkX19nVVZkwZuALBIzTd4p/6+Vicy/Xtx0tTzkOGPGKV7j9GnEYgI4/Pa3vCUHHizMsn8KF1Gz632AEf6FH61mly2TnFcczYFdYJykzVSSbXn7pkQyhvi/ST+G5Jq6RXP0ENiY6Fl14Znlopkuvk4MM+zo+34tt/klmpjYyK9KYrKfIMV2DUfuxrU6HNaFriN5BVETwD3Tz0sI0JrqLhDy76cmnCBm/bmLX/7rMPCAT99baKPdsB1rCptHS85Oy89mUThs2ThIZaRvIubJEWSl8Md5cCOsw3S1WQ47uob4aAGZaaRdjBK5jixbsuo0OiqVRb8hoZkezkvo8jtyr/7y4+9bkvonRD5/s6X3xWu7o0hEccS8aGAbE6ofRDTs+uI26+S4fNHC33P5xKuGAiZlOl5Wz1pdqL/DYC8hnMh4tbl3gR1O6SLFrIyvUQziX+K4B7rEKQBfqfek3Chn7WSBYGDqZR4FLOOHNHikOO852SIZHqhQYUuG+WyhQakq9BcmLYq1YWdMleSnMXl4zI5J7U70dbr0fhaM6PFLwofsX6kgUnJQF9evKMiS8SKgqM7iE2F7eSk1u9gBcRZTUr7lNgdPAC8JkcM0GBMGvdIJsqmkqZ91Oj5EJaSDdxl0e8bc/UgS+hMk0C5rjFiHWvPSHC1+DTlPVof6SiE6WHoh8ourGvouGhuVH2eMqNwWRt16WyTtte7LaT4FEJVV3VeJg1ufukThofky6uwTz28HxfzmvPThCaBQvhpE65cUrk6WRjgBfWqkgYoA/InylyLQtnwsiRYWA9/WLpJuTfVYKvsMnngGGRpUYl9RgbbYEGevPgy1KNzjxcV2HWTHDgCKfvZOMWrgTCFCDlLpJ5bm+gyE8T0cidG+B3fKXV4LHegNTTjX0XM1+FU4pvQqwm980kA72UcpWBl5XPRRdgbky8amp3l2BbOayvV4x2O83WtuIHixzMJ3dBC
 2l+VTrJR
 vhCyYJQi/qD1mZ2gVlwINYYL0FkIg+t7DeczwF5erbnJttInva6Vmd1jOVJo/oQGxtT+ZjdAM/XtUebQPrkuteNYtRudX+fCvfcMTaebUuAeY6DaETMmBWcAdH1rexh5LCONKcruZrfotTrgdMjQGCHyBUFNZVGRIuerAJc1uWp3Z6QKwmOkglvxTxHXI+46rn3IdoLYy1kdXuSQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Separate out THP logic so we can drop an indentation level and reduce the
amount of noise in this function.

We add pagemap_pmd_range_thp() for this purpose.

While we're here, convert the VM_BUG_ON() to a VM_WARN_ON_ONCE() at the
same time.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 fs/proc/task_mmu.c | 146 +++++++++++++++++++++++----------------------
 1 file changed, 76 insertions(+), 70 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5475acfa1a33..3c8be2579253 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1984,91 +1984,97 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 	return make_pme(frame, flags);
 }
 
-static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
-			     struct mm_walk *walk)
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
+		unsigned long end, struct vm_area_struct *vma,
+		struct pagemapread *pm, spinlock_t *ptl)
 {
-	struct vm_area_struct *vma = walk->vma;
-	struct pagemapread *pm = walk->private;
-	spinlock_t *ptl;
-	pte_t *pte, *orig_pte;
+	unsigned int idx = (addr & ~PMD_MASK) >> PAGE_SHIFT;
+	u64 flags = 0, frame = 0;
+	pmd_t pmd = *pmdp;
+	struct page *page = NULL;
+	struct folio *folio = NULL;
 	int err = 0;
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
-	ptl = pmd_trans_huge_lock(pmdp, vma);
-	if (ptl) {
-		unsigned int idx = (addr & ~PMD_MASK) >> PAGE_SHIFT;
-		u64 flags = 0, frame = 0;
-		pmd_t pmd = *pmdp;
-		struct page *page = NULL;
-		struct folio *folio = NULL;
+	if (vma->vm_flags & VM_SOFTDIRTY)
+		flags |= PM_SOFT_DIRTY;
 
-		if (vma->vm_flags & VM_SOFTDIRTY)
-			flags |= PM_SOFT_DIRTY;
+	if (pmd_present(pmd)) {
+		page = pmd_page(pmd);
 
-		if (pmd_present(pmd)) {
-			page = pmd_page(pmd);
+		flags |= PM_PRESENT;
+		if (pmd_soft_dirty(pmd))
+			flags |= PM_SOFT_DIRTY;
+		if (pmd_uffd_wp(pmd))
+			flags |= PM_UFFD_WP;
+		if (pm->show_pfn)
+			frame = pmd_pfn(pmd) + idx;
+	} else if (thp_migration_supported() && is_swap_pmd(pmd)) {
+		swp_entry_t entry = pmd_to_swp_entry(pmd);
+		unsigned long offset;
 
-			flags |= PM_PRESENT;
-			if (pmd_soft_dirty(pmd))
-				flags |= PM_SOFT_DIRTY;
-			if (pmd_uffd_wp(pmd))
-				flags |= PM_UFFD_WP;
-			if (pm->show_pfn)
-				frame = pmd_pfn(pmd) + idx;
-		}
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
-		else if (is_swap_pmd(pmd)) {
-			swp_entry_t entry = pmd_to_swp_entry(pmd);
-			unsigned long offset;
-
-			if (pm->show_pfn) {
-				if (is_pfn_swap_entry(entry))
-					offset = swp_offset_pfn(entry) + idx;
-				else
-					offset = swp_offset(entry) + idx;
-				frame = swp_type(entry) |
-					(offset << MAX_SWAPFILES_SHIFT);
-			}
-			flags |= PM_SWAP;
-			if (pmd_swp_soft_dirty(pmd))
-				flags |= PM_SOFT_DIRTY;
-			if (pmd_swp_uffd_wp(pmd))
-				flags |= PM_UFFD_WP;
-			VM_BUG_ON(!is_pmd_migration_entry(pmd));
-			page = pfn_swap_entry_to_page(entry);
+		if (pm->show_pfn) {
+			if (is_pfn_swap_entry(entry))
+				offset = swp_offset_pfn(entry) + idx;
+			else
+				offset = swp_offset(entry) + idx;
+			frame = swp_type(entry) |
+				(offset << MAX_SWAPFILES_SHIFT);
 		}
-#endif
+		flags |= PM_SWAP;
+		if (pmd_swp_soft_dirty(pmd))
+			flags |= PM_SOFT_DIRTY;
+		if (pmd_swp_uffd_wp(pmd))
+			flags |= PM_UFFD_WP;
+		VM_WARN_ON_ONCE(!is_pmd_migration_entry(pmd));
+		page = pfn_swap_entry_to_page(entry);
+	}
 
-		if (page) {
-			folio = page_folio(page);
-			if (!folio_test_anon(folio))
-				flags |= PM_FILE;
-		}
+	if (page) {
+		folio = page_folio(page);
+		if (!folio_test_anon(folio))
+			flags |= PM_FILE;
+	}
 
-		for (; addr != end; addr += PAGE_SIZE, idx++) {
-			u64 cur_flags = flags;
-			pagemap_entry_t pme;
+	for (; addr != end; addr += PAGE_SIZE, idx++) {
+		u64 cur_flags = flags;
+		pagemap_entry_t pme;
 
-			if (folio && (flags & PM_PRESENT) &&
-			    __folio_page_mapped_exclusively(folio, page))
-				cur_flags |= PM_MMAP_EXCLUSIVE;
+		if (folio && (flags & PM_PRESENT) &&
+		    __folio_page_mapped_exclusively(folio, page))
+			cur_flags |= PM_MMAP_EXCLUSIVE;
 
-			pme = make_pme(frame, cur_flags);
-			err = add_to_pagemap(&pme, pm);
-			if (err)
-				break;
-			if (pm->show_pfn) {
-				if (flags & PM_PRESENT)
-					frame++;
-				else if (flags & PM_SWAP)
-					frame += (1 << MAX_SWAPFILES_SHIFT);
-			}
+		pme = make_pme(frame, cur_flags);
+		err = add_to_pagemap(&pme, pm);
+		if (err)
+			break;
+		if (pm->show_pfn) {
+			if (flags & PM_PRESENT)
+				frame++;
+			else if (flags & PM_SWAP)
+				frame += (1 << MAX_SWAPFILES_SHIFT);
 		}
-		spin_unlock(ptl);
-		return err;
 	}
+	spin_unlock(ptl);
+	return err;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
+			     struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
+	struct pagemapread *pm = walk->private;
+	spinlock_t *ptl;
+	pte_t *pte, *orig_pte;
+	int err = 0;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	ptl = pmd_trans_huge_lock(pmdp, vma);
+	if (ptl)
+		return pagemap_pmd_range_thp(pmdp, addr, end, vma, pm, ptl);
+#endif
+
 	/*
 	 * We can assume that @vma always points to a valid one and @end never
 	 * goes beyond vma->vm_end.
-- 
2.51.0


