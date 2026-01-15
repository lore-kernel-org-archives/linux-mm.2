Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8647BD4660B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 573546B009B; Thu, 15 Jan 2026 13:27:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA5A6B009E; Thu, 15 Jan 2026 13:27:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8E36B00A0; Thu, 15 Jan 2026 13:27:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BC2E6B009B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:27:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD92A16045A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:57 +0000 (UTC)
X-FDA: 84335032194.26.9BA0866
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5644018000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZaIK4bdd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="SA/WiShf";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768501674; a=rsa-sha256;
	cv=pass;
	b=EyZ1EZZVpPsgtTnEVFZRAFz/F7FjtLJw195tDpsCeFxRY35Uyc5dYof08z8n3Oqk+QQQ1E
	XuVeo1X6ZKN33T2SaBMxOHrI4htOUuzEwODLlhVRtqZBugLcAgXQtZ9iTPOQex6w4mHPiN
	DGQKnQQG3vDeXf9oio68gDUbuYVXMF4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZaIK4bdd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="SA/WiShf";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vy3h/3dMA1JkUw6OcY2FbjpfJW8L8hjcjTXe8NStvfw=;
	b=IDm5X51W/Ug03IU5Z65HnghFd7BZ4zj45YmZfWtQAXaDSw3X1W0n3fxE46hIHRXMRB4jOV
	Xq/p5awR/Z+Z4q6q7AnK6YDs6/jb4qLwmG0kttaw0IaZxabuoQ48hl0aod7YPeF4Ty9l5C
	bKfDkIngSiS/SgO7PGnHmlZp4rZ7ClU=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FEAZLp1940271;
	Thu, 15 Jan 2026 18:27:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vy3h/3dMA1JkUw6OcY2FbjpfJW8L8hjcjTXe8NStvfw=; b=
	ZaIK4bdd4u6iDfzGM3r9eq7BJfpJJbYSi6e3lRupiFvzlZruGE7uLhD0vSoRgnbL
	fMJn6dcgz0JRJ6a2Ilr9hYfO8EN34YC1zgno47DCTnxN6b6pBQPGfsvrYhjp8cug
	N36O9F6WTsd/tkHRYoB95i7AMKgGNWK6siKGogbQ/JMr10WQFdz2dyNVkKQ4D24y
	v9UZzyiNfnjDkThD9xcc8cZDyOwYYF6xRRMyo3v4a5j9fGxDQFMTsD2/Mvped0Rd
	FD1YPE15xpugw0tcgRNzdySbCkTZMmtUxnBSQ1jgml9yMQ26D9g5fciqAf37BD51
	oQzuIe8PpNdOZU6IzRt9BQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5p3bsac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FIFSbK040469;
	Thu, 15 Jan 2026 18:27:38 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011016.outbound.protection.outlook.com [40.93.194.16])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7fe856-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yew2NnULSyf6GW+NmivyL01AIKiPHZUIXbYDvK2QPBnbSJfS2xvZSNTYKYM28c/+mm+3kChdfdosZq68E3xR6BQ9dTNg2jGkHBegbkjTvRhxy6b/B6esf+RBarO9PxWMFknnkZ4YngD/M1SpiXR9hSa5a2bwfeYE8+P+GHmK3uBiqD8Ti+wUtAXvPu4MEdYjM7CbHvlsoCl523FTgJSd+Bj7liGesrGTDwOHBo85+hKnBQjkOVBvpCbUjVJ5AJQyg/Yah73jNuvqH8f0PY4LDAPeq08JqnrjeuSm723dmwKDVycowICyHqzjwl39WqURvltLT5rlLdMmuZRvSJ9htQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vy3h/3dMA1JkUw6OcY2FbjpfJW8L8hjcjTXe8NStvfw=;
 b=jXgsAFbTXf0ZGTdmCTg6+l3cpY71A8OtG5pC865Z6jK7gcbm0dYvZqhyrbLrMjdjZt5IJU7y/jGqvEC79B/ob7QqY80FbCy0qZ5ULX+jc0Bn/XdD6BnCPYeCl6EjmM4OhhJvH011s1E3dhnxcn9XMGfEvjT/oenbz7lGElPLK+a58xUAAnw4mFKupu4m0zBzrpCLB+IG3nciOmcif468RAJT92gz4Sng8Xc1nADCXt7TbuVclj21If+IlCBa3AH0Wc0GqNeSQShoFlSM7QlbZrut815aLAEcHVVEtes3/uISWvbgnmxTFlIHZLz8AOSni1XWlTxQ1azTp7Ht7/OF6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vy3h/3dMA1JkUw6OcY2FbjpfJW8L8hjcjTXe8NStvfw=;
 b=SA/WiShfGIx8VyscAJCUQjpfzk5j/DxILSPiZzdOWbI6L6PxxgLQeRCeBWOEcp4KIOs0ATgUDT282dmDwc2XBx6OiGtUdU1XYxMfiTYdHEV0ryUECUbQ52QeM1WlEPYryEgFv4GysbweWnzuceRY4Nj7aca4opYIxtFhrgX1sUw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7119.namprd10.prod.outlook.com (2603:10b6:610:122::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 18:27:33 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 18:27:33 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 04/10] mm/memory: Add tree limit to free_pgtables()
Date: Thu, 15 Jan 2026 13:27:14 -0500
Message-ID: <20260115182720.1691130-5-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
References: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0102.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7119:EE_
X-MS-Office365-Filtering-Correlation-Id: 97b3c68b-8708-44df-51e5-08de5463c03a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?REIhTWwJTbxbgz1j74JGaHrSv1wElXKOiiULFH/GGTUWIppIn69Vwf9vqhO+?=
 =?us-ascii?Q?UH1MBUbLphY7Y1vuW8GXMsMOqoI4jVG3EUmQi1lKKwKuCNsBFa0rrUAWsKYG?=
 =?us-ascii?Q?MUbOmsFYSOvs0VmFxp0QnUpRcku13mwDo6JPyIsMslbZsZWxmBZ5ZDD8GCkj?=
 =?us-ascii?Q?rIhQ8tT1x8SpHuXDZL8y5rACi8Y70rdZ4gNZ+J3Db6gfZEcR3Oi61fWO6iLt?=
 =?us-ascii?Q?6LjUmzKXBrpL2KqLlD2nNSA2XxeO0GOKLFP+dS1x1oszSs3TBBRtuI64jjtz?=
 =?us-ascii?Q?LWl4FbNZQRC972HnjzBTMu9ya2EsB/DDcE/b5YuI6eZIN3OjHjwV8VB1fXXN?=
 =?us-ascii?Q?j0K9G9lhVd0Niqk35XqQdxLAgXvaoy7oNDd+4lgxHCJ1pDnsxXhgnMp3OXC7?=
 =?us-ascii?Q?vd5U3PaE23fDfvIfcYSw5YQTKE7++sQKJ8ZzIww141BCFUlr6y4uzpQ/q3AH?=
 =?us-ascii?Q?YeMUChiY+vjoq6/3kXnJR4srLIK0hY9VCb+ch0wn1gS4mNXOt0FTXNGR+Iek?=
 =?us-ascii?Q?IoIeFYcEUYPf5S58aAasgRdXvJwsxiuEfOgfiK7p1hpjIoFEVd8wQUtuNzJN?=
 =?us-ascii?Q?auRDlcqGk24z3THVXxlJnchyY1bfR70DMKXGTpWUKY4xiZTVwZTNIYNGGIsS?=
 =?us-ascii?Q?L9so6z7cBK1dIqnFGjDutqLHGl4M+lO/Hpim8whWiQKdH28kaRp8oqoYlD81?=
 =?us-ascii?Q?EeW4mD0UmrtZJWafyBDTXxHeqxi5mYrh4vu8XIsr80t87ZH/1s4o6Soesd32?=
 =?us-ascii?Q?AFQXKXz6o3uMarwbLRdq8HRfu71AbKBfgGxNcD0n9wgWawIqzcEykddRC8kO?=
 =?us-ascii?Q?xppet239/yuEZ0wPsl5/cA9ySic2B9bLrHrmwmMCWPjoPMs4VEOpD7Mu1YSV?=
 =?us-ascii?Q?rlr9QYMwhdDEBJO1H0WuhJOIrm1p/EnfgfrfEj7oq6HfwZPANrGAV5xQepIQ?=
 =?us-ascii?Q?RQmJ8vkXfnHrWABrSXzucIx6ygPfKBjUiPKCLb8f+u52SfZ2j0d/ugEFebo3?=
 =?us-ascii?Q?GThwbzYQmbjwP0sDI00pnVzZfbvaEmfyeUYAIwaEpJ5dkP1d7Fw76Vwx/Q4b?=
 =?us-ascii?Q?m88Qt7Tz1MKgTMEcUHV6+Ya6CwmoakDDbTsQ9a+2eiw5+RQ4EwM7ToPpkUXZ?=
 =?us-ascii?Q?qN6Eft0e9o7srW0dQmJ2jyf3qmy1ZpIlyk2UEn6uPzUX6bR9BHVy7+MKMY0Y?=
 =?us-ascii?Q?4KUNh58OzzBLZ8oE+QJKohS2I8gwAhP7cjqZSFq8vZGosKHnIc7FYqWflgmg?=
 =?us-ascii?Q?NAfNwLsIFxIJOS/9YRLlTd1bEeh+gNpx/eCa6zB9lOZPFvTNu6LBaKeNR/Vb?=
 =?us-ascii?Q?qJa0ibkHHkTByfXNmVo0MdVyOA7KiAuw7EE9rSJ0QwKyvWkXk6/RjGmpFQMf?=
 =?us-ascii?Q?IVuHOn1WXKaD/LVOBOwdjPjSe+ztN676UhY66vRqcxu8TF3mlXy1wdKkR5z0?=
 =?us-ascii?Q?dKq0K1gevamokstg9WYurKp00qutxb6kXGSky0HXOyFVQv2KBnKkUTACjxlp?=
 =?us-ascii?Q?nmah+DPFJdDPlocG5p8EoNTSQbfDHzNtVZ2W/QcusQZJhS1+U3LupnKXCSXf?=
 =?us-ascii?Q?GGNBjgSGbgX+/aKlKpA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tnBlVRTqyCbW+bQt8dSj9fLnK4EimB5jYL5uSdoBM4d4VXhz1TuwRRT+caqN?=
 =?us-ascii?Q?B2ApkjsqmrnaUj6CQiO/MOHecDPdA3shwr6r8RGCSsUyDTw+1usCZ2gB5lpZ?=
 =?us-ascii?Q?/OA7ONvH39nWO7qplurmBM/9Jm+7TVVoV9BYvIxI/vzM7F6Pp5pjcDI8e9Gm?=
 =?us-ascii?Q?oyARISXbB7DfpVZWPNcNrtmfUj502y1H2gDhFCaPWzcARv4FGoAZ3DVfsXTB?=
 =?us-ascii?Q?VXNqglH7vbFhJH5tydxeHEJe223xnpuOiYtCWu8mqMRy4UvpYT3W1FXAAjt8?=
 =?us-ascii?Q?h6JmRq2ONODz4mKVDfxLgmcU9yRXkgqZh2DIxUQo4GnYP5G3r0fhexEmnbTC?=
 =?us-ascii?Q?xPjuxX7evaOIYyV2jwcswRPNCNCaJRgQ+F90GxdlBvet6mNYmaKjot2owkRn?=
 =?us-ascii?Q?jFHz3oEu7MBfeMSBFNLcZGZ/FKvxC8Bn/aC6C8qRThPGuz6HXTJcduL4175x?=
 =?us-ascii?Q?t921nF90SKsGB3eIoCI7MjSDOZELY/L7jRGUGjdgCe59+1TRejUkf2ye1CIJ?=
 =?us-ascii?Q?9gwCNy4TM3kpu/jcxn1QnN+GCDoTKseipC+TA3+zMtcgq5OaqGIBp6CFynvg?=
 =?us-ascii?Q?HR3q8OLz2SGQ0mwnj03WL24hvqCKchEz9E71kNog0MRtbkzBUZxbcjCHCK+B?=
 =?us-ascii?Q?g1fr4Z9YFtQ6ixIJx4rFklE6FiGbIx8VPADAExwM4Osg7Z85hnyVh1njWGbj?=
 =?us-ascii?Q?oa0ZaO2EqQSWWEdssSIGDvHoQAckU2gOtMGHuNCQK5Sp/OdSkaZhSw9lt5C1?=
 =?us-ascii?Q?g8y2ivt6vs3wEWVQOI7u/0+rfBZ8+SYW36G8TqdNUdFGQsHE2QXrgmVngu76?=
 =?us-ascii?Q?NKUEhtf6dqrQMZ71N1nfMhoNC9mQVqYCFadfK5FZrG7C1bnfoRgdMyCj7UX9?=
 =?us-ascii?Q?/lCgjYtid83qb8tS9Q667LmVXlX+enIJEmI++wFioUWsV00y162fXQlRPlV2?=
 =?us-ascii?Q?u00rocdmjAdyOkFaLS12rRmOv2L0g8aliNtGMEzsoj2YfAkikD1aZ/gfcoR8?=
 =?us-ascii?Q?aFAwxBg1aV4xx5WlEZZMq+jMnrwGDhVERuQcqtvmSP8hzjcnLow1emik6mKz?=
 =?us-ascii?Q?Dp4Uhp4xvIAY1sc8q5gB5cfS47qMdWrGwtL8zq+r/OHVp/WEFWh06ssVfuG5?=
 =?us-ascii?Q?iOyaXRqc2kW/QDSPeuLYIF0GhfhbNGLIHgXbWgFSW4TpMgBZHCWFQzgAIed+?=
 =?us-ascii?Q?EuHqB9u44/BE162ZuCYTGRGFCvEdHe7hETp9UP8fO4K5wKTrtoNKJA7kgf8g?=
 =?us-ascii?Q?iRzXa+MDUiv3e3lxzYqR4yvrbfd/nVQ8Kz+jBl1zJkiyy1bE0ycMNEZksi1M?=
 =?us-ascii?Q?jEPi7EgZVyNU5dUMuVwOJx95lmMAIdwKXSgBsK6/VKfB83dvqYlOudeb0PAo?=
 =?us-ascii?Q?lF0eA/zrXcd/m00rACsl/Yt8UHOxwNKbl8W32hEx3IboxZ1dLxKDIPFC/vYD?=
 =?us-ascii?Q?8NbTbZwdl7M9TGLELLf62sWcdIBzgsZG3w2sR7c9oF8wxmpb4aPy4zd2iDZZ?=
 =?us-ascii?Q?kIYP8kiid5Hgz5KjFd6gPWXHymMb36Poz84k5nUQa3E5i3+ZivRB31hjLqoU?=
 =?us-ascii?Q?1xK1yiZxMlV+3rqQ8cCW9B40XGaVqFQEb6pDVd6l6mTiR0n4a3O79pyFtiZI?=
 =?us-ascii?Q?R1vCnTfmMEh5DEgHBMDkZAIzEhCGrf15E7GUnNl7lh/TBOuy61YyZQVW3tZb?=
 =?us-ascii?Q?bf6WRnVka0DZbOU/OeC4HXTiEy5fGO7DfAzcdonFMzJr1gd5SW1GM9ngB3As?=
 =?us-ascii?Q?hbsoVTUR0A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o94Q0VMcmAG8Lyroi5qnua250bzSZRxfBPY2v032aROrCRnoh6VpxV0Pdz4QU9Ct53jfd/2Lg0EsxT58YTHR95m32SPLkK/adw+aCIwFyVpyM1HGzR8vWB6BG/e6Tu/5fukwgGpoylIPrr7gaDpnNC4Z2EQXDwakcD0K0AC2mT/s/traT9K+rmu1EXpElCbwHyyDX5VX35iLPIbw2/f1yMyeBCi3e/EPGeKP5br3y34HySPdvCqYAGska/5SzEX5XjFNojgda/yvD2nlhX+GhtlvSREcel2gDNT+RZCd330NE5hrcKDp4kJJv2rCWDPwmlj2UBj79/nsRQqusMY+eL1yxHUbwXzWCwBQlZUh2Pheyp/pM6HeI2ahyzE6DlS6KLqZJgr1GskWrXd7FQPfWiluLpcBGskjl7ZBOESwN28a9PJCUpGriMSotnAKWZGdizBarJiLDL505/htGRoSzVBdBtnUtCnyznwPmk7n6w4IrQ1+h4qSFLS7HDA/jQt5NTJePctG8aBQh8ptUjPQw4A9m0ULOL8Bw1yFGjd0ZZ143ZH7yH4dvSlJJGT5/vbvCnFA8BCcHHLTi+qUlHIImAFajVohuo5Ak0C2+0s/BP4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97b3c68b-8708-44df-51e5-08de5463c03a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 18:27:33.7804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4vT0Q1AWefmOTQBUcPM82WjFE0VOVrMyPWS/V+bc37VOqltRmBD5YG+rpiLDfv6MvIwIQDMGPFjrllhS6735ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7119
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150142
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=6969319b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=jQEhaW4UhibMOa9XUgMA:9 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: Jw2dCBWcgOiHzhPVNCdFPF2wJzfSZ9aR
X-Proofpoint-GUID: Jw2dCBWcgOiHzhPVNCdFPF2wJzfSZ9aR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE0MiBTYWx0ZWRfX7h/GydZHofdT
 8LZvIa9iLMyZPcca8jkLY+KHolPBz+xWeJBWMSprLdaCe2A3hCQsJPLWiwpcGdEKbljftHUWgA+
 /uwgRMRrttdAcvpdr16krhD9kZAQ1dMTu6fyoWg33vqWy75Wu/nS6iUV9SEeSeLxTmVktAe/c1n
 4IdKIk8R/iVSOi8kJHDQJn6ewjThpCi99MvMus7W5DgrS6thn+RCOmxgsyAJl5Eizgfs3oWriiM
 xoE97s9MYMPRUUfAlPtyUKYJd1C1p/WyjHKuJ5mHsReB5ifAqu944NpR6EWDBV8eiZEt73uJm/o
 vRvNfq2gV95kat1sS62wX0uWCGK2hLdxAW6vVx+oAL31E9QEWt8EHM0kSZyz/igZkhITUxaNzCE
 vhxq3i3S5EIpgczboxDstrXPZ5ls8GjLqZSj5IplRo8PQda/u+iXdqbn+sziK2eeltj5e9WcwS0
 zUd/7Z/N2+Yz/mN0yvLpWsLrtib1jUC4130duN5I=
X-Stat-Signature: 9syn6fyh9jo33e6k9szaeicmz3thgne7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5644018000E
X-Rspam-User: 
X-HE-Tag: 1768501673-494433
X-HE-Meta: U2FsdGVkX1+ncHXIYeuGjmIEpxmq73RuZ/+kKOC0Ft3DbHcp8XxUOwL+8mOWDjt4cmQoZQG8lfE4ATSFOP1SqrbDuU9ftFzbExky4TpJvyQJTYthksokF/uVa3yZkduo8tQZM/6dELGL5H95KxWdR64R00Ycr24ZCQqQ9qLiyLW6sWdNR40owmkN7xdQ8burzZ2GZt/regwFtVdxQW06QgfDg+TKGw5awrR0jEX4Rly545aGKXvY7dlP1DTjVWHilf9sOtG5Ac/S5FeXUbeJLSDx4CC3JP3WEZwTKg44iQcAsDteNFEVMfaX2RWfJQOmACmduzu1P2AYm3GtkC1nj2klRmFVrsDMyT3WO7+wY3WA8HJN3vNMNCZ0voPtLLyHylIWTWj//ESxpb5dK8RLULzqVQjhZNDmHgOzMUtjdugzSZ+faCXyFOYFhTFLEfXsv34wGcZPWrJZC1lFFywJv83y2m47WjF80eGRuw32BM/KvG2FUnruh0RKwEbZNVgulHcfWra2ZxD5icLW5sjg7gHasnNsjarl1dFhoA8zRB8rAMehaWum8JKcUqDPGDvKu53XqKMVWbx91AFT0oXAprMd7+UNXbTk5aSOV2QMosgPFXr34Y/Zhl/dhQliUzKE8OIY9i3CeJ7HX6EdGayIbqdoEyoLGbEFKQhetqq7fgDi5WSCsBTWYRqBMgQfAqYL+QhaSU41clKJUFRr1NzYiviNCebc4i7UWxmAr0U8wBgBSoK5hp/aBOofV3vHX7hfg/XTK9ya2tYYUCW9hnORzEGO0DNjro49PPhBZ90TXaHFXT3pdTdepJO8vdNeS65KPC0QvHLGLTpjpgk1AOO1+DXOECt8BnNrLdfK3AeNpLysNNu3K6oDAnBtMlcifEFtjApFVOPoga42wEL2qMd4XIx7fefIKDN239KcLM4TC0v1NM+3a0INfJovSkWDNQdBZsW5OEiYxsMYY71WLMH
 1RFY2M1r
 y6fgqFlPwGp92pZrhqQ3ztjzV7ux9aObmKsY+bPKaZrjYxAg6T6tIlajOvjHHdwvFB5Au86mgRFfbSlPbl99VUiAYikKcbYAcmRMc2Hc6v/l9kuWarA4p5o2WrL/mbQV9zWIMiLEHSF4D7AXupJ6NC1gWkmcOObmqb7ny48sf/u+E1jQ1yHkcCcLZ3j/kWij/J/PqQsVYXVfSguGBhXEihEKVED7aOiWyVPvTjvx6VIy6FSf822ImMqRYqJ+nRdtl3dlyoi3x7V1CaZkXyrDDDC5jo2+RGteC98r83wYI6SXC/UmixCWOKcUXZDoCLq+/IlRs+icCQMoUXeO+Q/pPK5ykMMm38JAHLTHH8d2WhZkSnpE824TXljZsXAawSHE7ZaobiuwJJc7xuQuUrJtkuyZZE1k2L3JNPsZzbgyiK0n3xGjWQsu/9CGTo54Lepc6rtWmOM4cpN/KLsQ5DDJ1+btRQAb4kDwPTelamSblyknAsyjui2kyq3Np29dqtntqpH+m3tCOhy7EK7OMIPRsoiex0TmOX+y37o5MH95Bt9vMTffUjhk9evEUZGdGWnBU1xEZxqdlYFYsk1GQa215biZ4HaMxkYiLr1Y8iO4NhGc8GUxgEFSpdAD7QTfZxjscuMW3LyikucTeH6h56UkwojCs2Rd1fAZrEsbEt3fAPO9JenuaAZrdZVlUfrcIiqd5yFxM+580wnlffYzlXtKNs8cV16G6PCq2jqZQFlRSVpmISxmY4dilA3OSxGiVF5nrb7ok
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ceiling and tree search limit need to be different arguments for the
future change in the failed fork attempt.  The ceiling and floor
variables are not very descriptive, so change them to pg_start/pg_end.

Adding a new variable for the vma_end to the function as it will differ
from the pg_end in the later patches in the series.

Add a kernel doc about the free_pgtables() function.

Test code also updated.

No functional changes intended.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/internal.h                    |  6 +++--
 mm/memory.c                      | 42 +++++++++++++++++++++++++-------
 mm/mmap.c                        |  2 +-
 mm/vma.c                         |  3 ++-
 tools/testing/vma/vma_internal.h |  3 ++-
 5 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 5afe55751fe08..2cdc5c9396f10 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -510,8 +510,10 @@ void deactivate_file_folio(struct folio *folio);
 void folio_activate(struct folio *folio);
 
 void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *start_vma, unsigned long floor,
-		   unsigned long ceiling, bool mm_wr_locked);
+		   struct vm_area_struct *vma, unsigned long pg_start,
+		   unsigned long pg_end, unsigned long vma_end,
+		   bool mm_wr_locked);
+
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
 struct zap_details;
diff --git a/mm/memory.c b/mm/memory.c
index 4b0790c8fa48e..9043cfda65b94 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -370,23 +370,47 @@ void free_pgd_range(struct mmu_gather *tlb,
 	} while (pgd++, addr = next, addr != end);
 }
 
+/**
+ * free_pgtables() - Free a range of page tables
+ * @tlb: The mmu gather
+ * @mas: The maple state
+ * @vma: The first vma
+ * @pg_start: The lowest page table address (floor)
+ * @pg_end: The highest page table address (ceiling)
+ * @vma_end: The highest vma tree search address
+ * @mm_wr_locked: boolean indicating if the mm is write locked
+ *
+ * Note: pg_start and pg_end are provided to indicate the absolute range of the
+ * page tables that should be removed.  This can differ from the vma mappings on
+ * some archs that may have mappings that need to be removed outside the vmas.
+ * Note that the prev->vm_end and next->vm_start are often used.
+ *
+ * The vma_end differs from the pg_end when a dup_mmap() failed and the tree has
+ * unrelated data to the mm_struct being torn down.
+ */
 void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling, bool mm_wr_locked)
+		   struct vm_area_struct *vma, unsigned long pg_start,
+		   unsigned long pg_end, unsigned long vma_end,
+		   bool mm_wr_locked)
 {
 	struct unlink_vma_file_batch vb;
 
+	/*
+	 * Note: USER_PGTABLES_CEILING may be passed as the value of pg_end and
+	 * may be 0.  Underflow is expected in this case.  Otherwise the
+	 * pagetable end is exclusive.
+	 * vma_end is exclusive.
+	 * The last vma address should never be larger than the pagetable end.
+	 */
+	WARN_ON_ONCE(vma_end - 1 > pg_end - 1);
+
 	tlb_free_vmas(tlb);
 
 	do {
 		unsigned long addr = vma->vm_start;
 		struct vm_area_struct *next;
 
-		/*
-		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
-		 * be 0.  This will underflow and is okay.
-		 */
-		next = mas_find(mas, ceiling - 1);
+		next = mas_find(mas, vma_end - 1);
 		if (unlikely(xa_is_zero(next)))
 			next = NULL;
 
@@ -406,7 +430,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		 */
 		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
 			vma = next;
-			next = mas_find(mas, ceiling - 1);
+			next = mas_find(mas, vma_end - 1);
 			if (unlikely(xa_is_zero(next)))
 				next = NULL;
 			if (mm_wr_locked)
@@ -417,7 +441,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		unlink_file_vma_batch_final(&vb);
 
 		free_pgd_range(tlb, addr, vma->vm_end,
-			floor, next ? next->vm_start : ceiling);
+			pg_start, next ? next->vm_start : pg_end);
 		vma = next;
 	} while (vma);
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index 9c8adc505d3de..827a64cdcc681 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1308,7 +1308,7 @@ void exit_mmap(struct mm_struct *mm)
 	mt_clear_in_rcu(&mm->mm_mt);
 	vma_iter_set(&vmi, vma->vm_end);
 	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
-		      USER_PGTABLES_CEILING, true);
+		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
 	tlb_finish_mmu(&tlb);
 
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index 0c35cdc0d3b7b..b2b9e7b3284f3 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -484,6 +484,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 	unmap_vmas(&tlb, mas, vma, vma_start, vma_end, vma_end);
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
+		      next ? next->vm_start : USER_PGTABLES_CEILING,
 		      next ? next->vm_start : USER_PGTABLES_CEILING,
 		      /* mm_wr_locked = */ true);
 	tlb_finish_mmu(&tlb);
@@ -1275,7 +1276,7 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 	mas_set(mas_detach, 1);
 	/* start and end may be different if there is no prev or next vma. */
 	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
-		      vms->unmap_end, mm_wr_locked);
+		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
 	tlb_finish_mmu(&tlb);
 	vms->clear_ptes = false;
 }
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 7fa56dcc53a6b..f50b8ddee6120 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1139,7 +1139,8 @@ static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 
 static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling, bool mm_wr_locked)
+		   unsigned long ceiling, unsigned long tree_max,
+		   bool mm_wr_locked)
 {
 }
 
-- 
2.47.3


