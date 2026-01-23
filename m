Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 854BAD778B1
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 20:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605016B0550; Fri, 23 Jan 2026 15:12:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CFF66B0553; Fri, 23 Jan 2026 15:12:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28BA56B0551; Fri, 23 Jan 2026 15:12:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6FE6B0550
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:12:41 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF3F7D3060
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:12:40 +0000 (UTC)
X-FDA: 84364326480.06.7EE183D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4B5ED18000D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:12:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="buAn/5Cm";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kwpVg8HD;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769199157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=P9o8NLTRVj5hqVkwSm+ojaQo7CF+VXlZe5NNbkWHI7w=;
	b=G2XT4pgHgmHF4TkOfeqXaGMEq9d+epRjU1/dEaCqGJO/VjZU+1IvUC3E/C+U3tYWk8W3HL
	e0HN8bo++uq8FASRDmldouL20Q63wsDH6ccwpqJsioGZTUEiymrE9xP+B+PhSkxwi5A4Zv
	4Wg87WTjGqWWtyJDMuXAwuxR5SlJ010=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="buAn/5Cm";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kwpVg8HD;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769199157; a=rsa-sha256;
	cv=pass;
	b=uieWK22l5DKsEkUdyO3eHNgDsYZpy7Lti/ZTbjAcSM3Th4+990AoSfDO6iBusrvnXWQO9r
	tbXrMEbbLvHsv2144QDKQV43Pz7wWRqyChdSUspapr7F9A288uKnxWedOECVSQBn3kCcQw
	YRDH5zf4fsnGr6yjrxfE1s6sVE4ZV6g=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NA8XFE2270710;
	Fri, 23 Jan 2026 20:12:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=P9o8NLTRVj5hqVkw
	Sm+ojaQo7CF+VXlZe5NNbkWHI7w=; b=buAn/5CmqboNfPfSYBpxcfVaEdGAwCOP
	v7Ty2O2Dgh49d3fs618vrvSychLy4qRhxhhWBfE6jJKqUZPAhUwqgxfK9gEoPE4W
	gy9zoNx4XpbHnboS36IahP/7uDP5O2nYQ8SS7nPtKLKeTB2LctbFi+ESyH2NIVyQ
	VmbWlEu7YhtHSY2KJRELhVTggtPHL1AIB3PP3qiF3igV5NtkL5DanA7F6KodVHZj
	55Vjw3eQU2Hu/RpKGWvnlJzZlhJBHBNv5+W7jduWyT8baDrojw6m/rJwJUSUJ0Ih
	HAYMCZYNARlwXAAFzLfPFlu0LOxCwhTPQawq7FLZ2HsSIM5B1jK8XA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9u62g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NK4eN0033115;
	Fri, 23 Jan 2026 20:12:24 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011002.outbound.protection.outlook.com [52.101.52.2])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4buyvfba2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x/A91/h/hiNLoPeZpE1DgRLaP2JLHW8ZZ3k5zTv546VRXL1yWhnVN1efu1QUhJKStmSuoIpCYczb6RFhSpEppxstb2P2eGOOpfH+jQiNMwGzifEXKdbCajPoscDcXYI0Stq996IBIhzPRb5eww50yHeXWbGgC2es52XtgWOuC4CXppeNAs8veQDV84MO21ZEfUQVvkifOZRkDAiEVjlNd0hTpI9Cu28zAeDeof2dozyHY0ks/5T4L9hpF2kv+KxhfvJ2rsgQdjvqOEEDDn5kD6D6h3G+frx44ForJBkN9JY5M7G1QaHYOX0GCcXdQcg+Zt5F7Q1CZWRG5YK0njGLiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9o8NLTRVj5hqVkwSm+ojaQo7CF+VXlZe5NNbkWHI7w=;
 b=h0ioyTdmd4cx+xzcyK3H1FU4ilJQ98v+iBpmmA4GEbpY+nH8slxzOOH1rPzV/UwXeI18Uh1zNrhYGxm9D2VEXOh6GX2c+DsAVEq4BlrxqykD8/DLbWnnywFPP9SRxFyG0qQjfJJCQfHMILWmyG8tu/1yGS3+1e5ilTUaPiOLhuLTad0lBrkkrDmQrWtfnhS9qC9z8j1+KpcN7xgGwjUnu6/NPXoPjNHrfW1cjo3e21VP6MIHxqWEcMSQLMS07Ur16C4H/QTIHoFaxm0yUb6CglTdyApEiS88WNuifYdNoo2vmAxk2c+bDwqMhbBgFLcYvaVW9tzGSPx5NIgAIiaNKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9o8NLTRVj5hqVkwSm+ojaQo7CF+VXlZe5NNbkWHI7w=;
 b=kwpVg8HDVnLBWtvbsMdrL3Vbz1mlATj0gX+J6c+aGVXJrocEwfapk8Ifg8uyyXnJp7bf2Fa+bI8x993Yd7CkV3uInrEtuDWz0oMU+c7QwXoAoqiJAKdOtD27ntz2+Upyj2eZgY6qlMzIY7sDb6ar+lrf4vvNwAs5A1z/BICz398=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 20:12:21 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 20:12:21 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v4 00/10] mm: add and use vma_assert_stabilised() helper
Date: Fri, 23 Jan 2026 20:12:10 +0000
Message-ID: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0283.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::31) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: fd5428be-57ae-46a9-cee6-08de5abbb70e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IcrpmP1i2BMRD5T2Jhs8Bu1R/ByiiywE2E1ROxjhZgjAidzk8JomjmuazJ1/?=
 =?us-ascii?Q?C5eaY8QJPlzER55d6b+bAqk/p+V6NrK9xIYnfgFCEDBugVtUzpqzWd6VpLJa?=
 =?us-ascii?Q?cU/qnM2/P14vIovjK+nVyrVQrImqzDfrkUMtirSnCcFIKGiwsR0uml47DYoN?=
 =?us-ascii?Q?zd/HVyk7KOim1CUp31xn4Mr8ikHiPLEOVcsYJcgcdb3fW2X9OtPHBq+TIffW?=
 =?us-ascii?Q?QcQvdEXRgApUeyqnmbm6ugMwOzF7ZaoHc+WgTcJ65FR5njPsQuGyKWJlZC+5?=
 =?us-ascii?Q?m0NIlEdXc74zV3MDRM1oatDvm5apZWQ7+bqeJ2T2kxhu/H0GaomW+ADQDhlP?=
 =?us-ascii?Q?pE8MRosf3Qq6cokoY9uvyMBA1fhGeQs4SNedr9p2jvumO1awJV6343bNYoJy?=
 =?us-ascii?Q?joC+XewxsvhE5BBapn+5KMk3JRPZKty95uu7O7biqQVPZ5m0xUYhGcVOS/f0?=
 =?us-ascii?Q?X3KOb1YvZyGqPlNbRNazl5QLI1fMe9Ufi4fqTs/cG4GrBDFpTfbis9Ro3xot?=
 =?us-ascii?Q?wFvHsFCSZqLLUUnFKVtyePN0AVNdkLWX3Ad5f8PHgthSG0KewdH1CJ51BXt4?=
 =?us-ascii?Q?YhkWYjKSYLvU6+HQ58zh0cYHhzcaWgCaa2UrvICWm6qnDnxjJ2xhuA+9DaoD?=
 =?us-ascii?Q?ovtDOBQ0ImoltPszIJVxYjjoteFwF02lFZpM3PrccbT+5IOp1ojZSyY2zFVT?=
 =?us-ascii?Q?be9PKCad1nCVKyDfLDzh8eJMmSnDLR/ffTcRrtcHFL3cXvJHLVoY+GTnhYno?=
 =?us-ascii?Q?6sUgnhfSimM61OdyIZLVnZTPl530zi2KsGyAbSlBJJeIqU2JOGtmnu+0L/7J?=
 =?us-ascii?Q?thpnIA6RdLLB5ELN7qt+INisUacyXMCJcgbNRMIb+ZztHH0gp9mF4NfESw2S?=
 =?us-ascii?Q?oXzvPPocHPRxV784VMEJz8bCspip4GBtITrRYSKbptMXcXnSfVAZtNtj94on?=
 =?us-ascii?Q?uZ3/10i3ljwRnINAFTiqj+aXqK+Jw/VORnqQGRz1ch3Fwm1Z1uq9IQMf5KBx?=
 =?us-ascii?Q?+PTqiJia0YmoBTRBvIwVtDutO01N2ZRLZoOjPSdOTRVpympdjibVOXkl9F5H?=
 =?us-ascii?Q?8WTbB5bxqeug5u7c4ibETBERpDbrzK4yTJ3ElmeEBmEV2Ed+XXMAISdS1rJH?=
 =?us-ascii?Q?PqzKmeJaY377VlZlm75OhMfb1tR48afT6XjWzCScAVP4foZ0RV+FrJmZq2qr?=
 =?us-ascii?Q?pPUJaIvIYSS+IOhQSrVjzylIhjl67haRivm5a4DhwgToI9/VDH0jCl1udwQU?=
 =?us-ascii?Q?ZQgro2JIaK3XLdRd4c7j/fBtZRbP56AygY9nF43C3yuWZHvqchlbZX3bSOc+?=
 =?us-ascii?Q?nvDQohL/2GvPYBi7u5oPHQWqXiNK+f1iemY1OYcY+w4PKBDsiXSGTGfjbzZK?=
 =?us-ascii?Q?0/5jko0zHc8r+NMyD7qULKvsWj4ivYgRyAMuC4JkArjmi+P1MD4zZu3Eyvra?=
 =?us-ascii?Q?vumqPoNv6T0cDdqH3KvTy9jBUsZRQ+Dctfad9WuNDoGb6osnMEOaSC3hTgCc?=
 =?us-ascii?Q?9vn+6P4q/32x8C9fdOy4H+ZTsZmxqWe96OeshIOwFvw5KlyJzeJBy8igwpLo?=
 =?us-ascii?Q?WQBpSbh9xQ07ACZOcB9oFqTkKhkcdfDp9yMZSUo/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uwVaoLakgMq/28h5hj/bR7Wz95HCDfLz5jvQ1N0/EqPT96eo2+wVBbzQSPbT?=
 =?us-ascii?Q?Pp0+E5t+NT+4Ds6cpkGuvg3XNFMlQj76tcbd2oOzBe7xghRfLkJasijBBMiv?=
 =?us-ascii?Q?lD5wcz96YC38PoIPrIsr+geleYu5XRUFcw3wmuha4Gl3Ewzg1Fzj2Sn4D1Ro?=
 =?us-ascii?Q?LqsQpud8l9Dtyw0WVc8CNrc6QL0ZQfebzU3OlK1geKV1KrmzbTOROy7Xq0DG?=
 =?us-ascii?Q?lgk9fF6hWrJX967icGNJZ6/EShlVEnV4NeKBVQEaiH1N4Alhqh5qkoz6afI/?=
 =?us-ascii?Q?SgxCdTYlmsyUEwAYTgdPcZ6PpsGqzJW4da0LFnR8Txyw4aefNACGOxOovwZR?=
 =?us-ascii?Q?Xh9at0gTQmWJem7vqtyiin/vn6SbL6yKLu++ozmurbd1kcxwQkVfwXDVDbDC?=
 =?us-ascii?Q?tbDuneeO5yeHOFV/10yzwzcVXxtlE5V8YkiujE1+jpmxRz+UeQZkmePbIoP6?=
 =?us-ascii?Q?dL/WIN5Gc5N9ZpzMW4rmVEEfoxBoKrtza7V6n0K5QRHBwTXBgl8UEY38YNTE?=
 =?us-ascii?Q?X7ytuH7rQXlrotbHLk7lV7c+Xcnui0mf74229ornEoRSGLP5nBaXLnbC2viJ?=
 =?us-ascii?Q?x5514lItZ2+9k42+SQB5OGLHr6GOrvcV3J9VF3SeQ5vu8dO+wR14j6s+ognZ?=
 =?us-ascii?Q?O4Wvuq+dlbxXXD3Ja9Bds1Q5UkTQmxgtUU/MicjVMWY/r9RVNIahapSstulw?=
 =?us-ascii?Q?BwmOp0hHH4YWpCogh8QMv79EdaFBhS/SVSApWW+CIRtj11fzh3kPTZss1dV/?=
 =?us-ascii?Q?gvuWxp39KY6qNCSE0YtWW9L/FiOKCl7HwK0CHcozXxH3JFqpx8oXo6Xbn7Fc?=
 =?us-ascii?Q?VltHBpQe+Fp9NbaKWulsgtHnYIlIGsYZ0B16nITaN7r3Um8lj2M04SjDCjYp?=
 =?us-ascii?Q?ciwEj4qMB4l0INVtgZlauibdIheo7TSY0I4aKoCMbtxL0GBi43O7enfXwGM1?=
 =?us-ascii?Q?cCSSXXjJbObiLz1ULomHfBhBaeIE+KfY9D9lUA1+JBJDaNZtTe31671Z3UXn?=
 =?us-ascii?Q?1pSG91cCLs+4SJLCL/1PTsCpnOLXOKpU7sSv09heH7oTc1PdUyrRgYJ24nKv?=
 =?us-ascii?Q?4Lwps3JhL3e26DYmzkEVldxdq48m0dD3AGnB3flEefR0LoC4sUh35aMrj9h4?=
 =?us-ascii?Q?djTmqcGNLDauXC14ExmY+6sKWkhJic3zaoPqilqrc0fsyu7IOyalPQohDz2k?=
 =?us-ascii?Q?wJzdHcX0p6AqwarP6MUbqQkbGdnHv5R69+P6M8Wi7xowOqBof4JwcawezkC/?=
 =?us-ascii?Q?OrjO9SeuFlxBGasDFodJwnrZS7WWXI2+ZKZwAHES+/pNvAIe8tKsmWdiOfl+?=
 =?us-ascii?Q?kxS9mnZYjAjjbRCPEgKiV6+skmWlYdkLaM3kR9kzIvw1hfBPXTIkq+Z+ZTLB?=
 =?us-ascii?Q?m+uUqWkiyYq9lMLxJ/Y3RBGncJdIMHYS2Rng26lE2x/nyeGx1E0qsv3E4y+X?=
 =?us-ascii?Q?QFb68CO+43HE4Vv2LC0l9q2Va7J6ACzeQZ9t1tu4RfHkKKNnNq5tm3bLCLkJ?=
 =?us-ascii?Q?bRKjR0aWY4rQdlCy5TzM0kEmO/rdgy8tWbQleSEemY2wEzJv9/O705DuzKZa?=
 =?us-ascii?Q?KiVU8+aubtsAU5T/W1ln0rbNgF0lCsem9k43O1NCKxzbZnC1taO0rjguB1da?=
 =?us-ascii?Q?x+DpUzE1isvRQ70H+kE+Fg5DbTqPuBp8GV7tPFYolZ8b1BSkCyen/O0U2EpR?=
 =?us-ascii?Q?MT5gSw5FIbxO35SGlFsyLkotNx50e5M2w60vlsk0nnbMyYiX+p+SR1lZh9N+?=
 =?us-ascii?Q?+aPzV7lCpyA9cBTwUla8gkcPqU3jFqM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D2bEGBGLfAZY5Oh0pz11rysYllylY4376XSgAl9YYxvWcMIb5sf4KlhBoHIYfDlYYMTAVaXA03XXDLO/DxpIh6bHY2/YQOqSTYRQX1ThpoGqYZxudVBrZnliNnjz7M9diIdE9DI8QTTCn/UPILEz+WAUdptN8qji2/DAvkG5JXs17SmORgGQ+F8ez8PcWyWxuoopMwy6+I8um1CW3+6ESX84EzAwKz1IjU+IGl00GnRcUSadQmlQO2MmPhuCpb+hvY0umuTCNf5IxaoepfJ9mmA+gKkdHqNgy1DtSDEsvOvwAo6IjGBmmQT4lxM+Yc9IYtunezxAW83K4vKeOgUDKK9U+q4tWw3dInwBYJFDcr1SQPJuWxNgdqcb2Q2b9BjhHN+rSG/N4c+2WjH8YlHtEaqYrlOexuucE4XIVxqkY7lZoqTlqWwjbJH0LXjbFABnKKVGycS1e5NocVQDUsEixD2bGitTX4wlFCxdj0sHHcS0KQ9Oxeooblv5hGgTlN1Yawc1+Rbz7V5SRdmGEv6bAI37zZFlLXHEqZnw2HfN59d6f9J4spshpEQR9CD0D6q2e878OAlE/+6rhp+/65qlvZGE5aZNnicpXVRXqobo0j8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5428be-57ae-46a9-cee6-08de5abbb70e
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 20:12:21.1208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6IkVXl3VU1ovZTaBNLW0m8wew3HNlt5yOBRfmvAf5Y8aKwjTk93RGyap0vbvtdk8CETq5sWKMFzz7biCvhOCt+9T6pTIQ3Cv9/qTymObkPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601230154
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=6973d629 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=QA_wwW9TaXFp0PUY0q4A:9
X-Proofpoint-GUID: XaL2NQC1412nYHMItwAKaaWhu5-4vd1D
X-Proofpoint-ORIG-GUID: XaL2NQC1412nYHMItwAKaaWhu5-4vd1D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE1NSBTYWx0ZWRfX0MU8CllOUu/H
 G50RqYhd4DlfU2mhaGMMR2EQkmVeksiodFXBTpkfgkoTgGlA7/B00YOkrxwsb7AY4LHYmSLNLc1
 zV+vvcxSsUK4ELb1Xqi8Pvz6MWuE+eIuGheEBwOVKKaQRKP5Y7x0a0BiWwlzNM8HkYwOWctQWe/
 UeDeGjKZVROHbjUMRm65UGpYIpJzIVeVrYnOMkZtxDZxx8D5GHyxlCEttJP4c4YYjDJxZwsr8l3
 KJg16LJrCBaIRnO97l+1XRW9UoO5TKcfQXTLkH2OQLbGKQHhlmAEqszzbSGWiIS3p6bI4nB/Y06
 VqNxUMIrtPCej2x9DmekqEgr0Q0W6ZhvU99Obmat9lUGWe0Kbd+YzadO6xFI+PoleFRGS5Hkrvu
 N9CSspvQUsxHRCv5mTxqRMpvbS4CKEabG24yxY7A2PCFjJGhmwPJVt7TJ69nMmDa61onYgoZ6Nq
 Oj5zhE3ZVjIaPTNZYEg==
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4B5ED18000D
X-Stat-Signature: bzc8w3ab17jht9c48y5oybukfddedo4i
X-Rspam-User: 
X-HE-Tag: 1769199157-102734
X-HE-Meta: U2FsdGVkX19D2tzBCS5Zg6teon2K9mZni2mk19UrLWH9kiNDQVNG2vZd/7zfLnbMe+1pFPimeM7jnJzEDYSuM7T+fN6b8U9DWlGDXaY4/lmATefVsZwKIrUKDUVdzwSDMj6t2FxH2u42EFtaXZ5cD/RpY5IpI3g803Tq2u71tJwXHB60hJfxpy935xwUyKzHYTit02xzHbTDdvFDRmdzqxCXDtc0EVyqX/3Fc8hIR3HeZ+UDV9NtfK/XDgg2Pi7It81bFql673l9X1QAuA4KgZYuISMj/TdXv5hbAaQBBhZsseFtl0zCajopjEsRAYDo8MJFpX51jG4BiU0YFcV7WOAt1+fwWbAFO9m9ZBiotT129pQbg3MvhMDSWKCmlofBHit283o87wIrde00O26bVHStAlT22kzs/q/Udox1gh66leyQFh5e0CBQ8+pqbNofe6cXUungJnL1nvapQAKCAgNXRiJTjvthhEA/zV5baHbhl8/lc594fJyw8zZvni1DAT8AViK9VvRlwF2VWbhvRlprupmyhIrqcVlO1cMNjY9oAJPf+Dq2FIg5zO2clrBM9YgLsfkb8jimVH2q472N/X0avhwVSEXyZLhFLV+vGIK/lg0QEbBC473e84RCI9lJ+4pUDZGMndCoPGAv52eHuC0+ftpiL6t4H1WR++LpFbt5cyNOgpeKgm7/reOpe/pYI8EMvOpAzUdf/ekIajPJDGbLhuXVyxbLPYf51SGvibRccUOKjq2YbEEcK8zTYUNGQ/Aqd50Cy7W70LKikuvpYpbQe+VrOjc++Dk3pbr/6WG/U11sgjNc+tOMuqKUefaGVXN0SI1ORWgxatdK9Y57nNkxait/M7Uer0qkYlLU5FdSA1QwqcqongHAYnj9AcITOJnrVKVxygBCgzda8zttczxlXNX6Zy2nKwmGyy7f00ryoLxkt+QP6C8bp5MOWu+irCvnFRgs7l4noJYjkA5
 TebVGEO8
 A8MbCwLCDbJcaWJdEbCVCloxWn/TqBnazC++vvsE0zA7Waab24lsx3ACGIeDQautNzUit+/DT/9fOMBjFYDpQ8+AXfae0lRGSPRVYYQzCNSQA2UkWZabHkbUfjN0Nv2ABfWfXRySVt7vMg2l0PiTiKnbNUQeocn8y7MTXJNbErMjyNV+P3k+5emE4wlNf7fwTqWC5+ib1cRVj3jfLCv+T5YZjeqfdgW3npn76k83ns+0b6gYqbHKzbSHZXnqR6Kc1EN7XLNfhapENnbjfLRTpAJfRmzYHxZQvmG4xfVFeee6V/Ir6VNiiA7C2vlvi6uTRtzqTaOSYS+M+o5P87Bm4pPIwsZPP2OIrz7CVic/3i6ZlstLXXjyizQlRVNjYsFiCniDEcdbgoL6Pd4QvYA2xh0tCvp/CrCFqBmhVYw4Mr9giSwYOsBidB2W2i65O8+017dWPoPueGQXl6N50d1GvdOY/FcQbpK81lvOkVo0B25DxtmCm+nROL7N5uN2nbmQ9ZIxjPMugaaJudF6qUUKSB8ylMT5/Ue4KGUH7v/sYPL+VHVqHWl4oTwTIiyLR1PZNjpGkWa8a2ygXri8xIZvbzkrufYgp2cfagHlWvKf2Gpwb9tkAqYFSo5dl08OD4smApyC3U5vo/AYHpZakVw11ZfBkn5jpNo48tWPoYG/Om3Q/Y2acadJoxhWIJKffVah+WOwjli8YdWH7u1GzJfEN2DO4g14srM9ijTiGl7V4ZXmnUF2vlbiVnCLbhw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series first introduces a series of refactorings, intended to
significantly improve readability and abstraction of the code.

Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
be changed underneath us. This will be the case if EITHER the VMA lock or
the mmap lock is held.

We already open-code this in two places - anon_vma_name() in mm/madvise.c
and vma_flag_set_atomic() in include/linux/mm.h.

This series adds vma_assert_stablised() which abstract this can be used in
these callsites instead.

This implementation uses lockdep where possible - that is VMA read locks -
which correctly track read lock acquisition/release via:

vma_start_read() ->
rwsem_acquire_read()

vma_start_read_locked() ->
vma_start_read_locked_nested() ->
rwsem_acquire_read()

And:

vma_end_read() ->
vma_refcount_put() ->
rwsem_release()

We don't track the VMA locks using lockdep for VMA write locks, however
these are predicated upon mmap write locks whose lockdep state we do track,
and additionally vma_assert_stabillised() asserts this check if VMA read
lock is not held, so we get lockdep coverage in this case also.

We also add extensive comments to describe what we're doing.

There's some tricky stuff around mmap locking and stabilisation races that
we have to be careful of that I describe in the patch introducing
vma_assert_stabilised().

This change also lays the foundation for future series to add this assert
in further places where we wish to make it clear that we rely upon a
stabilised VMA.

The motivation for this change was precisely this.


v4:
* Propagated tags (thanks Vlastimil, Suren!)
* Updated reference count documentation in 2/10 as per Vlastimil, Suren.
* Updated 7/10 to update the references in the reference count comment from
  __vma_exit_locked() to __vma_end_exclude_readers().
* Renamed are_readers_excluded() to __vma_are_readers_excluded() as per
  Vlastimil.
* Several more comment updates as per Vlastimil, Suren in 3/10.
* Updated 3/10 commit message as per Suren.
* Updated __vma_refcount_put() to just return the newcnt as per Suren.
* Renamed __vma_refcount_put() to __vma_refcount_put_return() as per Vlastimil.
* Made __vma_refcount_put_return() __must_check too.
* Comment fixups on 4/10 as per Vlastimil.
* Renamed __vma_enter_exclusive_locked() and __vma_exit_exclusive_locked()
  to __vma_start_exclude_readers() and __vma_end_exclude_readers() as per
  Vlastimil in 6/10.
* Reworked comment as per Suren in 6/10.
* Avoided WARN_ON_ONCE() function invocation as per Suren in 6/10.
* s/ves->locked/ves->exclusive/ as per Suren in 7/10.
* Removed confusing asserts in 7/10 as per Suren.
* Changed from !ves.detached to ves.exclusive in 7/10 as per Suren.
* Updated comments in 7/10 as per Suren.
* Removed broken assert in __vma_end_exclude_readers() in 7/10 as per
  Vlastimil.
* Separated out vma_mark_detached() into static inline portion and unlikely
  exclude readers in 7/10 as per Vlastimil.
* Removed mm seq num output parameter from __is_vma_write_locked() as per
  Vlastimil in 8/10.
* Converted VM_BUG_ON_VMA() to VM_WARN_ON_ONCE() in 8/10 as per Vlastimil
  (though he said it in reply to a future commit :).
* Added helper function __vma_raw_mm_seqnum() to aid the conversion of
  __is_vma_write_locked() and updated the commit message accordingly.
* Moved mmap_assert_write_locked() to __vma_raw_mm_seqnum() is it is
  required for this access to be valid.
* Replaced VM_BUG_ON_VMA() with VM_WARN_ON_ONCE_VMA() on 9/10 as per
  Vlastiml.
* Renamed refs to refcnt in vma_assert_locked() to be consistent.
* Moved comment about reference count possible values above refcnt
  assignment so it's not just weirdly at the top of the function.

v3:
* Added 8 patches of refactoring the VMA lock implementation :)
* Dropped the vma_is_*locked() predicates as too difficult to get entirely
  right.
* Updated vma_assert_locked() to assert what we sensibly can, use lockdep
  if possible and invoke vma_assert_write_locked() to share code as before.
* Took into account extensive feedback received from Vlastimil (thanks! :)
https://lore.kernel.org/all/cover.1769086312.git.lorenzo.stoakes@oracle.com/

v2:
* Added lockdep as much as possible to the mix as per Peter and Sebastian.
* Added comments to make clear what we're doing in each case.
* I realise I made a mistake in saying the previous duplicative VMA stable
  asserts were wrong - vma_assert_locked() is not a no-op if
  !CONFIG_PER_VMA_LOCK, instead it degrades to asserting that the mmap lock
  is held, so this is correct, though means we'd have checked this twice,
  only triggering an assert the second time.
* Accounted for is_vma_writer_only() case in vma_is_read_locked().
* Accounted for two hideous issues - we cannot check VMA lock first,
  because we may be holding a VMA write lock and be raced by VMA readers of
  _other_ VMA's. If we check the mmap lock first and assert, we may hold a
  VMA read lock and race other threads which hodl the mmap read lock and
  fail an assert. We resolve this by a precise mmap ownership check if
  lockdep is used, and allowing the check to be approximate if no lockdep.
* Added more comments and updated commit logs.
* Dropped Suren's Suggested-by as significant changes in this set (this was for
  the vma_is_read_locked() as a concept).
https://lore.kernel.org/all/cover.1768855783.git.lorenzo.stoakes@oracle.com/

v1:
https://lore.kernel.org/all/cover.1768569863.git.lorenzo.stoakes@oracle.com/

Lorenzo Stoakes (10):
  mm/vma: rename VMA_LOCK_OFFSET to VM_REFCNT_EXCLUDE_READERS_FLAG
  mm/vma: document possible vma->vm_refcnt values and reference comment
  mm/vma: rename is_vma_write_only(), separate out shared refcount put
  mm/vma: add+use vma lockdep acquire/release defines
  mm/vma: de-duplicate __vma_enter_locked() error path
  mm/vma: clean up __vma_enter/exit_locked()
  mm/vma: introduce helper struct + thread through exclusive lock fns
  mm/vma: improve and document __is_vma_write_locked()
  mm/vma: update vma_assert_locked() to use lockdep
  mm/vma: add and use vma_assert_stabilised()

 include/linux/mm.h        |   5 +-
 include/linux/mm_types.h  |  57 +++++++-
 include/linux/mmap_lock.h | 264 +++++++++++++++++++++++++++++++++-----
 mm/madvise.c              |   4 +-
 mm/mmap_lock.c            | 173 ++++++++++++++++---------
 5 files changed, 396 insertions(+), 107 deletions(-)

--
2.52.0

