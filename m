Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDA5D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 14:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883486B0093; Sun, 18 Jan 2026 09:52:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85AAB6B0095; Sun, 18 Jan 2026 09:52:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711B86B0096; Sun, 18 Jan 2026 09:52:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 44B886B0093
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 09:52:05 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0255EB9D08
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:52:04 +0000 (UTC)
X-FDA: 84345374610.19.06FEDA0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id AD54A2000F
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:52:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Tl8jc7yT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LZY8gujp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768747921; a=rsa-sha256;
	cv=pass;
	b=Shqp6g8PL04n4FjF7EdxPJgjX5lrYpmbK17cSOkYX8B85gt4eOhhqjrAMXMv6L4Kx+8lxP
	iCD2h7P3kpQfIhPpCSzUCNDTo9nF4YffQQ1erMtHlRbmi7gnH0xNPKdj42mZ+MFULhRb1X
	d6416RdPYB9svrQKZssWghm3dConhwE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Tl8jc7yT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LZY8gujp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768747921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJpEDmemwWOGc5ENNDA/APFMXrfvdv51ILJ5AT+hVTQ=;
	b=fDXbt6AoKAXPq5oD5HIo131+VaOzgnkPsNb/rxKwML/iLICRrOrNZ1lADyhH+i5MoNDX8E
	QoSim9ufRf6IlkXCMgr6Js7B/3jI3rpZiFGdrlApscnYRIb/+Ou29UcK5ESqQL6zs0Ld6e
	ECynP+r4wAzdjR0mQz5KV0cOMnriWEM=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IEdsjv3522700;
	Sun, 18 Jan 2026 14:51:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NJpEDmemwWOGc5ENNDA/APFMXrfvdv51ILJ5AT+hVTQ=; b=
	Tl8jc7yTlNuzBTqFZ3VYw0nhk4kD0AOGVuvBYiCWFd27r46EhEG0/W3iYfseWKLF
	uKTM28kKU1rEPlAZu0cKbn09xlqqzcAUAqyb8Fz+T7b6Pj+I3fENthX8sYlzQSG+
	X4mcl1Ks8lbccHCwLyuJAHsLZ8jBL/cKvAAo3pg7QSJt/4jix2s3delee7oi4RZ4
	mSANbQ7oqUYvYI4meG66BlOsXfp07anfQa9gzNtnhItg+dfomJhI83xoFC2PNcM+
	Ra0yUaj/H1+dszEQXc9Qee2oQLOEDNXxYqjsAdafj0BHVJflK0WUu03M4DQqeL+U
	usDMakQcSKUmMPUwy8mFnA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b89brx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:51:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60IAZ5Ox008406;
	Sun, 18 Jan 2026 14:51:53 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010057.outbound.protection.outlook.com [52.101.61.57])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v7eut8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:51:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C54RC+r7mJrA4ANp18xBLQurb/bEX7QyA6tcwamh7DMcLBc5+BbfWOu/Y9pLn61gUgTDQfjKMhft8/Z5ub/tXI4q/6QkAqOV/VESApQds0HLFaskJV+0J1XmjtbEO4vESSii/QkWqOgAG99h+RU1UDlRsWjWiTqIhvsDLCH5qQ4pQ22IeXrp7eisK3j8r17d9pcdzg6R42rtI+vrkXsnylxO8EEV0DpEbAgb/nWW+MwhJjgZbDeceZ/D2chyVn4zauA0Xo5Um7TLfwuhN3ziu+MPG83NNiPDS6IO/e+Wzv9WFu2Zq9z4GNB9qmhMyuKThycsIQGNas4Sx5nvldvyxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJpEDmemwWOGc5ENNDA/APFMXrfvdv51ILJ5AT+hVTQ=;
 b=UirXPmEUliUP+TAyQVRBz/nipIewEd0wfY7Kff8+j5lwU4myltRnwjimMWYAcYDJCAhf3KDjOZ+nWIHHJzI8AJTTXii9KJenVM8zCGXeFDiHXfzTq1TL6evPMipSmAeeEkEC4Ng3jWCI2L5dJNEppYIuReRADAf02X5pwcTtBSR5D0HbYDDWM6CIbKOe/2mQr5TqCmJdbtkyJvaCAchV1cEuxdyMC8EoUswd+szYxyrHWEiV346oxpCyuuEw+gD8biISY2reCCwYC+SEYYvk5LgehVPA4T22J0RJV9RTv90E4Xy6pDiTXAqUUYhoor2XiRMGXmLLiKFrT06tuI1Grg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJpEDmemwWOGc5ENNDA/APFMXrfvdv51ILJ5AT+hVTQ=;
 b=LZY8gujpDm2k94XHk0zZ3Md5SuglUVi7OovBtcrLXN12UBZi4bxl8xTP8ZPmoiIvYhZ0wcOBM/54pI+/xaED3TL6YxYj6MzmTNNugHwRThBqs4XAkW73V0RDHACrIwcNJNADsXMZIZa+TRSNhzzuLBky9OqIVIoobEIryb1lU+8=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB6723.namprd10.prod.outlook.com (2603:10b6:208:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 14:51:49 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sun, 18 Jan 2026
 14:51:49 +0000
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
Subject: [PATCH v3 3/9] mm/rmap: skip unfaulted VMAs on anon_vma clone, unlink
Date: Sun, 18 Jan 2026 14:50:39 +0000
Message-ID: <085a25f7528e1c8c687276e9b856e88dc8f105ca.1768746221.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
References: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0039.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::12) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 7758673b-58a9-48f5-ca2f-08de56a11c4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SwOA1hbCSs6D7m3diiRWzs6JPpXGpwdG97H20PgpBAERnxqVcph/VghDGKvp?=
 =?us-ascii?Q?DOyMu4c3TwWG2vi37GoPTfmFwO+uG2KmZoygUfBH1Tmixq/rN0HADrrC29P9?=
 =?us-ascii?Q?ostltVC0kEgD3Cga4pWDjA5d+z6j8lYZNi3v3seaNranFtNXN+LcVS6/MNM6?=
 =?us-ascii?Q?iBgSCfUC9L3M/difXwPiGGHC6BykMyqQp61bdKZ7ZpvE0YNXGEukB3IH8924?=
 =?us-ascii?Q?AuokFi3J9WIfck5XajXqbpa8824zgPaPJp1v9jPmcGbmN8la/70LTVgFwueA?=
 =?us-ascii?Q?r/9rU/ZtoFkmOwcu3WAvUBWBGNMdKzsRKTNh/gh8lbS2D3IHqcxp0Yb/4vE1?=
 =?us-ascii?Q?jsv9pi/tEl/v2xhm0AguYLzPz0RLimjEXCHhmDOXu0AncrcCG5R2S1Is98dh?=
 =?us-ascii?Q?CKd/YpaOScCvOdmxrA9F/W9ma1pv01fTi8du7N3EZL2Bg0ZcoOzc0+eDn19j?=
 =?us-ascii?Q?ZJnWhp6t4KMo/ZqdY7tOOnEKbSbW4sLU3gtly0R9OTldaxyOxMk2KdVPGWvP?=
 =?us-ascii?Q?Y8y4Y0bPiISfz1yKCfg6honT/Ws8jhcEP+W/SPIyLX3vu37gAwzewPhsXA7G?=
 =?us-ascii?Q?uqCKZ4eB9SeiLJcwjO7JBvb5P0LXl5ycSx9JiuvqyDYl1e4ESgMxzzogLBcb?=
 =?us-ascii?Q?UxGg+lEWZL2PyOZh805lU8CIecjh2aQFBBfe7z7X4cfL1WuM2bYQ/wjJ8Ja6?=
 =?us-ascii?Q?x3dbmPh6vmxNwzCi8ShwZNraSycmiINKg1yquQMS447HlBQA5LKYmmHmWp+E?=
 =?us-ascii?Q?1RusCS3Zhb3EIU7tO5JGauz7MQC4iE573yYpCfr4bEE3LJ1hhxf1oNiejwLc?=
 =?us-ascii?Q?pknVjsbaTt73C7FcRSZ3Je3/qAl0nqRM1KYter134aS3XJgBDNiBQkQ+LP+l?=
 =?us-ascii?Q?Ba0VoLiPg8Fm9tV2k7xeNDkHxw6mbLBmX5Wv1DIYdEMWzN1rPkDWf6fxrR5R?=
 =?us-ascii?Q?x5kjiwAeXJCbJkmC4KGK4xklVknlMAORSYFbEDJZWstXN2Isq+OUoYHmKyzb?=
 =?us-ascii?Q?VKmmuMTwy/+pjeoFAPBnX+1P7QPYUHGNqLp5z+MaRT5G0q0brLGK8TVxyDoF?=
 =?us-ascii?Q?Gd0wYuISXEEbmI4Qg4p+ReMVy1BVBOdRKI+tYLYc2EZRWPfkVdpmVObPuuMu?=
 =?us-ascii?Q?Z8PzwDup8PEvo3+HsRWFglwbDap1q6xtyxPSWCaj8HORd/xuMylDzEB3b3oF?=
 =?us-ascii?Q?zVUuloWcHOhm2V0yPnh8ii4FKgAN8pe7qyiwY2eFnr+UTG+lQ+SsIPrM2QY1?=
 =?us-ascii?Q?Vas8HKcwrlChpd78UzPOZiccIvzRKDs1l4CNLYw8F/H4xslajumVk63TEy+O?=
 =?us-ascii?Q?vYBp1EIdk9wsFa4Ycr6r+ucYUOKx78xw/LLeO8qHxme+c0qz0SDU6nDsytjt?=
 =?us-ascii?Q?1LA4uy/pgskrsA3ILMV+XMG0GzqvlT/YYnGO4RBQeHJXRoI1pDrJkZr4+itE?=
 =?us-ascii?Q?KQICVSoQqoL4QVux0xBTi/6K7XHXNMW4ztZgqrm3v9s/ZvuQnbsG3OduNawJ?=
 =?us-ascii?Q?Fef7Z5sQhMg+A5qNp6Wz1aBlveA9j1rH9hVzbTPKsE+EcfpNmj3wQcJjDztl?=
 =?us-ascii?Q?rwHKATlIGnAIrQvA2Cw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l1eTJbDeyPCdv3ClfeXKWaLBClhbaZJ5avZAw3AAioOJknp/KfOm4MJbdbxS?=
 =?us-ascii?Q?aH6VAGZJ9O1H77llKAItaO1vuHJTq1D15x8p8+wepc3o5HVCUA/IFKUg2KKo?=
 =?us-ascii?Q?8bahHnDA5B8EBVK7DMotr2Tc3KGKHBrTTLXEJCwko3X0l8wqYFg9X+MZL2qp?=
 =?us-ascii?Q?C99WvNQAYXcTvMVbV1E/jne4elglbi+jdHq6CdLyge1K9v1g5lE6iT2Rssce?=
 =?us-ascii?Q?WJJa+USSpL9pvVpz+goxf8s+X7/nvowhc6ZYjRH5E1B+Dbo4+OTgR+x5nR4F?=
 =?us-ascii?Q?nYJHRuCzOezesoPCEZKQLyaKY4ZycVac5dZsBc7dB1uuEYNFKeDeQBi6bsXY?=
 =?us-ascii?Q?Fx1skVglHC8skvNbAE2Caiuch7nWgERC8zMYO0FFutQ9CK9Orc3MEwAOd9DJ?=
 =?us-ascii?Q?FY5VfaqLgU7j4v1nsCju1USjy/kmk7lSSNJqt/O41/t2EMP6yaIiMOd+PfLw?=
 =?us-ascii?Q?kJbHke/8Q+rsQw5P1xU5jiuY6S0rnCQIbjm6lAiTg7hGi5cv951npB/9Vr1d?=
 =?us-ascii?Q?knenzZLo8QH2CqeXLqN+5822s+WfVxxXoqBNu1/CoJewlQaTMnTe3mnVR+Rs?=
 =?us-ascii?Q?FfKsGusFsWZOGA+bQJbhLnzwqBo5bfqI8QwO4yHakJ60OzdqcfwTiYDALTgy?=
 =?us-ascii?Q?baJlsMVFxbFz0QVSqW+JVmLpRvI34lRB5lDU1DhGwdR2pGAGH+BtVDH0nWt2?=
 =?us-ascii?Q?sQnhW3Pni8VfrqmCw5LHvTVy0DcRXDNYkF3F8q9eecOyuF6oD2Y31F2LLSkl?=
 =?us-ascii?Q?Eud2CsxEAiOGhb2D4uC4bFCt5CabXv7E8To//GqIxYJMlyjVlcAWtEOZCZs7?=
 =?us-ascii?Q?HSz3KXlFcvpTK9GCLcAx78Y0Ro7bfUy7QS2f6+lVsFkgG8Gcdcom0b/55l+A?=
 =?us-ascii?Q?dDSMEHG2eFRv/s90zAhejcxUKiViEKAjOUDBJ2JL3RG1wPiMawTqJj6CsXJK?=
 =?us-ascii?Q?HjLWe3JBxRkdUQEimM3MMSCDMyesBrAFnGeS3EIQZWPZdEzqX8TsJQZPjQYQ?=
 =?us-ascii?Q?1SEsq+wSoV/RPlZC7P61t/8qTdSppgsooNpP3NvnUHy7DI4MjkKf185kZV7q?=
 =?us-ascii?Q?Ggn7wZuhwSoYgr8zWsPoyEyFMXbbnXJSHlfFt280hI/reno4fI2f1v4nGm8V?=
 =?us-ascii?Q?8hBgqIEABZxSg0hyRH2LesE/6ORRl21BwSnaTezffw6+SQUgoJffDPftgmZp?=
 =?us-ascii?Q?vDEjrQ6AC85BUWmk/9re/FPUZCp/wwdk/TrR4Djhfgc4Xmori+ncXt2/VDUu?=
 =?us-ascii?Q?jVc5rvNg6GiXwIB134mCzrpUVuAdbAQlcW7wzKvolyshgs9owb+Gie4dTZIk?=
 =?us-ascii?Q?cxWJZAHc4AwqwqfjgVO9AzBYJQvlAItGgPRrJnF3nuaASsd68iRmKFuJpcMU?=
 =?us-ascii?Q?mQkPB3KOggwP1yF8kYGeFYQ56xg4b4YMlJyiYTMK+UgPhXNWijGe8Rv7B79i?=
 =?us-ascii?Q?qivi0wx/oOr9zhANqqSp5wxpQQ007wHbbBf8ma2wzwuU2cIHg0u126eRP5/6?=
 =?us-ascii?Q?tfNQENOgIBs3UYs0A6h7xY4a1WzaxJJESLaNBJ6nR9Iu5v2aLLL7/hNUqbZY?=
 =?us-ascii?Q?nxjlx9bRmYsqdVQO0AJB6OviMuuyOwwR/fbhH3sSYTCthOgR5nLheoimOMdw?=
 =?us-ascii?Q?3c0Y8nsU6gKFa83xL0oEfOoPo+A9ywz7vqoqYk8mVqx2Jvvp4Ajlkdcx1rYb?=
 =?us-ascii?Q?1e+/82pWXdC3yee+svDjle0KEbo7lR4qKgndb6fw6bpubHLCCATgy5kmg7Np?=
 =?us-ascii?Q?TJq2x8+8/1nOrj8g006DzjBWKyfeR08=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uMqvLLADAjz99kObRw3oGpf1nbmtoIZZ2nxdG+rha+ShYsDiQ/aYLHK/ygaNcJap5zna2btSdkmRiVIejUudDjqdRKlyNfv85UE4kNQ4AGODmyadGQiUXmEDED85+cDNLWbzQlMhQZ3rKzmjeFfT87PW+leFOSbKTDqrqOwLSZCoxIezXW1OO8iAWsa+y4aFx3bLlB9GVAQmw4NiGp8QV6yCljgXQwfFikl3999dpz48ASQAN1wkod/Dij5dbjRwofg3UAoJ/myzcjm33PYORG+Mml7Pc/3zHXxCtjpMdsmKhm0XVG7FL0OrBSCnWvIBr2e4Pt+xodWYBepL4WZ5Q4hAhh1uKLJsLibQAWypSl8tv2+7qXrY9oDasHNGyM+rrlJa9M6IzxelRL+/xlWnvGg8lyNmmf0Kb7J1wOhiK+aDeeREHZSFD2DPm2MGxx3UBt6hVBo/fxBXq+PX2IuRm+IMxgtSLRNE+SB4G9iC6LsFISRAsiP6zeQnxWwUyFFHlT6gDW9vBtEII1uiQW1fHoIDKqKx3t1shYO8XalPV0Uffmgc4oVXitHyGOQoryC7hL47kCN3PyHwbL5nHpxZYnmfNhzs6ZKhVzf6+NEHEyQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7758673b-58a9-48f5-ca2f-08de56a11c4c
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 14:51:49.8399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cjmq69LgWNduEXCz9VackBUu5CvNvzG0+mJuq062QN8qE/lEo8XjCC0cHyEIKJxbBqAep0kNsA8/SX8x4zGwNfMFJTS9MQ06yM6IOBVwASk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=910 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180130
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=696cf38a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=h3eYx8GIHpVDmy_ILAMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDEzMSBTYWx0ZWRfX9XZfqtUUa0/G
 Ud4vSOjoLsNHc/fCMem1Jm4UOFEXdlQksgKZfwxDgsGhCJVibbR6/ZgNMkHUQC719F214oydO9B
 q0b+B0kLAhfB8wZl2bYwN7arK93kxw49CBd518QXGRngdwX1zuzRdOxagirM6C1HUYjrXYmkO4A
 IGLqI+PkU6i6d6tlBAnYMbLxwF8c/9lZ4whxFAjb846Ks6XqgLlYoFbegMchrtmW0AQBJ18syMv
 O/mohan1XNldSwZLSIQ6tqeU2WAhaz2jdY2IZVWMinuYF67n7cHa5VjddaWYv9OULkWIlORs4uC
 hBUoI8X3yrkt7uoGKdc7Y6RDBU+1eNVYt+OICA59Wxe+/YyUhx7TSixLcEikC0uOiFj+G0UHj04
 7vzjPGsavc1whJR6UnYVHCyqF0GCMfX3hQgi3lqiv8XZ9C/WkcxW3n7vfDCf1lmSEiQxR68DznR
 3GyK1QGzR1MnXuruqEw==
X-Proofpoint-ORIG-GUID: epcL1gVgMXEPOuoB2pV32wvLOgJCnQGW
X-Proofpoint-GUID: epcL1gVgMXEPOuoB2pV32wvLOgJCnQGW
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AD54A2000F
X-Stat-Signature: m4j368qwunesm1e1jmryrquwhdqiwqrq
X-Rspam-User: 
X-HE-Tag: 1768747921-436768
X-HE-Meta: U2FsdGVkX1+YyfquOUeUq5utCbH0Y79oA6BtMlzJi2ChFIr2IiRntARJzfoqPew7SY+6wO+2TPXSANmzWGKLdKYg56jZaBS63M78cz2VrgHoEqzc4G+sISavhyTTU3ufJLUctQe7y49nUI+SgRl3hbovZkkWC/xBMA/a/GsgchxUYyPbWzIov5Bh8PAR6eiZ3LCowP2kyAmDxxW4SL2UyhFouledOHgHx3aWLfvbMW8piVMu9i2yqzYCmT+8c97REgDAa/BaWcU2zPhWrzZmLMWj1ANMfQH85S1CiPXXigjren5FvPb8YZs7wu0WS+RqmWpICevoaXRZ2bHfQEB0mzmGQ5VkMXvGSCT76rHLE3MHCq6pXqZolBuwkb5WNI9jB1nz1mmIDkCcqmHN8vTO1mxbKHhFNOhJSY1Dx8jSt+MGv0R/P0fwa8+OiRgaD/fnIluX0xZcGr/IgOV1GuNjHjyDe6X8llNsW7ecJZuJR4y3PEbgFja2o7FVyN74r3vJLg3ImHkmVTNoWAWChhwPyRd61hxIfJZ0n3mH4HWNFmo+iuSs8U04lLnMs6MPY/snPs3AKG1qQwtmdjg23gO0zB128AEjw06GBelySwyMBLc+9eHONYr5V1VEcik+mymlm/wkJt+oj+02nlSspCoZWt4Qg+fAYDlFncHmWcEGsq0ogM5eGSGwI/caOGxN4POCTFHFen8A3X3L1tuOOa66ozVN3WAh6MyXC9A/B+Tor1MvpkXKiO8TJ5Qr1x+dOPwiBtCvAIKgFQx7O7/rmMVFvOgn4Lmr4BZOALK1CWRzOKWJyVQnxE6RGIjwtCK1hdK6vWMC6yfOJfVwY5O5FTaZru5SacHy+22BNW6X7kwUHugiG/hiejw66wjQCM5Bpt9kHfHcllTt5AmDruwaA7WMF9LtLqxjiMbIskeDYhg9VJeWSAb9yedJwsMus40niPXRIaQWpejeKGzrkU3dKHB
 Sg7KMajO
 axn9cBgmRHfGiNNBFh4vIfMobaH4kL4ynxJPBzQaUSDLlUyjTmEceLQMaKYO/zjclV2LrBSSLC+OzlbxMoKcmVmmP6bzQ30QA6eaQ+a+9X32TeaiQPgPBPG5CHO95xIG9HNKj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For both anon_vma_clone() and unlink_anon_vmas(), if the source VMA or the
VMA to be linked are unfaulted (e.g.  !vma->anon_vma), then the functions
do nothing.  Simply exit early in these cases.

In the unlink_anon_vmas() case we can also remove a conditional that
checks whether vma->anon_vma is set.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/rmap.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index a45b011e9846..8e846ccf7835 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -314,6 +314,9 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 
 	check_anon_vma_clone(dst, src);
 
+	if (!src->anon_vma)
+		return 0;
+
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
@@ -479,7 +482,10 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	mmap_assert_locked(vma->vm_mm);
 
 	/* Unfaulted is a no-op. */
-	VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
+	if (!vma->anon_vma) {
+		VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
+		return;
+	}
 
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
@@ -503,15 +509,13 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
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


