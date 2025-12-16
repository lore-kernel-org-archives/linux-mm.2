Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC436D609AA
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194586B0005; Tue, 16 Dec 2025 10:39:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C4A6B0088; Tue, 16 Dec 2025 10:39:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06BD36B008A; Tue, 16 Dec 2025 10:39:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAE536B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:39:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B8A914072B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:39:04 +0000 (UTC)
X-FDA: 84225742608.09.4AD611C
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013021.outbound.protection.outlook.com [40.107.201.21])
	by imf06.hostedemail.com (Postfix) with ESMTP id BFEBC18000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:39:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=o+lSYqWy;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765899541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMEb1GqHCdOpy2JjcWSH/ZA7xefTmc4iN+/B/n2i5uY=;
	b=gsWqS2/BG69j61zIKFGY/mL+iZ1YIF8NDqauBSZE9jj4Kj0CTM8PytW0qnAuWnVyKAswoO
	wul256Y2PmUfa5s3ZevBYGh02MyuoWLKh63gGHadXFDgbzriwGOLuy3xXLVjPQzrdpLBUi
	nMUImpHM3z+kHoIUIdbEIHPoRNT+h7E=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=o+lSYqWy;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765899541; a=rsa-sha256;
	cv=pass;
	b=aK8k3koJgS3mNxyyErX6z/fCuizNOVw+iZYS9cSSMgY2kRsSZPMZLGkpU2qR+pWHipryUO
	Iq1SznrBxI96JsisiNOzo9lU0mOIhcEaNThsSaxz+ad6esxnBuS0IstP4aOiDAYDdugMmG
	x5UkAbPtHK97yI5Hj9p9z1Y3ypnG48s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nTM2IiyVkgU2KPueryN0m/5oy58D6fuPl3NzFwQ2ennCXkAsgRZgVMn0r+WuHwXxvzW1DsL27jkp4gjtMi1AoRETZZ2sSuOiUAN8+7/QbkrBENaIMuIuqVNHO0qgj5maFlvPBovvvKGwR6S2dD3X8V96q3wv8E46giCcKAJdQxz/j3slVYH0c919+LT5Uy2y/jgcrtKYcwS1ykNPVEjCEgIE2L7N2eQxvVdxse3RusVIiettC4bBdUpcLuEsxV7A63uOv9lcBjIF0z9An16dznT42/EKX+yLN81L6nIUT5NE78ez4tGfl8ac9C0ihdboB6ZiiapZKWgpRYgjgQVvSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMEb1GqHCdOpy2JjcWSH/ZA7xefTmc4iN+/B/n2i5uY=;
 b=gBKswyS76YArCu4MHB0eP3VsLb++JAG0SqIeSHkgdMxdPQZpHoOX9ibW5Usn3Te72P5j/0NX/f1FqrjGMnrGukHQTr3hDIf1IjfEOtXz02uJiOcbLPPZualtUxLgg0+9UbVQfKuunhiG9d2utc+PNyIr4nSxFW8aR0EUKLmz3PwPbL7zZWnqOySYM4cbkED39CpUfsZ3ZtOtN0fp/ix4FwEUnVdJ9x33YseoAsYRAdUE94erJaxbGlgxfLt3ybD2VPtfm4b97wvt+uAjudMHQMydfdx14iay9J7r3b95tSKrc+4xYvQotwQti4m+MNtugyKUUfZ3DFYNQn7CQ9J6AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMEb1GqHCdOpy2JjcWSH/ZA7xefTmc4iN+/B/n2i5uY=;
 b=o+lSYqWyS18spfFyIGI/eYWQlL4NmjTPDVVmb0f9nIecsaYMabw+d2Np/pWePwOyb569skW1/DXgIuIv0ld6IAap37/TQxI15IfTRtCPLC3TJnsyV84XQ3qMzq127cmt+AkWYQx2G4Xetic9iIsxrapf3/kw5NXn/Lwu/W/MYjs5nG5kyChWSQ2VZ++bVDfvbx7lS7rYlfYKD04BOXvr33xAtM8CkJtz++c5nfIUUMLJC6AIGz0ipIfmvXYk0s/ygMZRNMNwIqwRYDP0Kj+sGb0LtIVQNq0NkcE/T4iiCU3kDINiHZK5KZysvIPPZQvbogIWJQLnGGsSOJpCbcRoNw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8690.namprd12.prod.outlook.com (2603:10b6:a03:540::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 15:38:57 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 15:38:57 +0000
From: Zi Yan <ziy@nvidia.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/khugepaged: use enum scan_result for result
 variables
Date: Tue, 16 Dec 2025 10:38:54 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <D9E6B402-528B-46F2-B4B0-9CD9549A449F@nvidia.com>
In-Reply-To: <20251216111139.95438-6-shivankg@amd.com>
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-6-shivankg@amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:208:32d::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8690:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bfb9daf-5d1c-4c37-b7df-08de3cb939b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o5GJENKFx7I7qE+zD5hY95znqlUedD9dsOmwLgQAuBs/C5V4xCz6eNFVjoE8?=
 =?us-ascii?Q?tMBVKohKffIB5eWIhGrGwaiJuA9Lc/KGbhXb42xoHhTupcDdRcQoctmqq11c?=
 =?us-ascii?Q?sy1xdP9rrD4jvEG3ZhQr1ThfgXOnVDWthDTftWD0QJyeo0Y+DpKCi8hXIgFm?=
 =?us-ascii?Q?/uBA5ElDXnmYElckMs18pXMyHEhg+MXRIUpWphIqHh4zYvNrwpRpwZbT7c8X?=
 =?us-ascii?Q?RT8tsgT2e1mCvk5Rm4Vrg0S0oIhpe6foJYG5/p0oOz7WtgcYpdqRFfhh/u5P?=
 =?us-ascii?Q?dfpOgWQ4c/rAnRcpvj3tNKDYZotMqkDG3/LdUUWlJtOqJzcybhmf5dNnlQTO?=
 =?us-ascii?Q?wtzBU3wT75BIc9R+ZaTQjhXsjicMmed7Z3sTZN3KDgy7G0VlsDdaabmspvto?=
 =?us-ascii?Q?rkz1M8vioOy0Ma4Kc5ZpwOyfAzd1mpHcEVr3uE4O80YOjq2TaVKBWq/PE6dS?=
 =?us-ascii?Q?O+P5uqlVg/AweqShmb76U3IgLMBTTcTSEXdARwkuFUymLhwX0aY7gwIvJ1U8?=
 =?us-ascii?Q?UySKcrONI75v3L7XBqNhpFagDfdRTnqOFHxKi1rxlMVX/Uujf7wLQx/G6J4V?=
 =?us-ascii?Q?R8WpCqbNeI1sZ4L+JPgHS71+TkgKhCP0da0Z19VRDqHtlc9EcAScOxdcrL56?=
 =?us-ascii?Q?o3CMqKhop7nvA7OiPyu5yL70W8iUSHEceI5ScN7YeOXk4NMBCpqycbRu0727?=
 =?us-ascii?Q?PYSh+OpmkVRlSLO67drenwx91F9PTpsB9eZKSQkrVFtzpls9LejlgXhtoNcu?=
 =?us-ascii?Q?lhMU3vzgppS/f2sEvM9UD1LxqTKmVN1QQk53rkrJHs26ii7mdU9LVKdXEdcl?=
 =?us-ascii?Q?Nz7hOwSPyKANnccdibYeEn+2yYuwIHFN2fQKkx9j9y2+0AT+UeHY41Dl2JBV?=
 =?us-ascii?Q?gflyP0KmnEpvk7WOHsmD8NVmVojoHEKI8yObLTet2xq1ve9UZajqz6hGAks+?=
 =?us-ascii?Q?PmsF/yOMiUg7ZsStGG1BzeybKYSQ5DsbTdUgtFkxq8mc5iDpmCmH4GCGuk/i?=
 =?us-ascii?Q?arAtDK/J4pGCtd6hQRdzRoWRocOGJgRGbm3pgQo07ldL83FTGRl07sgM4eP0?=
 =?us-ascii?Q?/V5hxcXRBdzWOGLlUnUgVfLcu0aV83Wp1qkiTXJa5uJPNzW8lAZaIvFLwI5s?=
 =?us-ascii?Q?AL17EYo3AcOVrGhZTOGx1z+/zSQLZH7UGCCYZQJi2MnILvnX1srTd4rdMEzP?=
 =?us-ascii?Q?yQtwZMw/sTGBreIovASu193hMU0BP3gMY67b9X86mRYpM2ZgjC6FYz7kCCkk?=
 =?us-ascii?Q?npjhhKJbt91S1dGtLqT2B56zRODRysxpQLPgW4RXOBjEaUXeccsot8sqHFuo?=
 =?us-ascii?Q?mg7h/ax8VsvW1P4YsaTzZGKK9OeB8pJUsiiSEql1zy7ShZI2PkCwXZNGqLd9?=
 =?us-ascii?Q?cqrsGiIOumqRcu/XrxKZNvaz3jGYR9DtcefW/Nt7yoEX6k8mHd0Vnoni++zb?=
 =?us-ascii?Q?Ilgx59qbDMs0daTXyfNpUhXA/98ABKth?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kVqzP26xb3y6lz12CO0cYP3zTXxTQWkXbc6GMB2zeDVIxQYoQ9SRRVB0U6rS?=
 =?us-ascii?Q?ZUjebRWvp75D1CS6Fd7BWt/+aVQOEM2iWukcWaVdvC7BvsVh0IFprWq0xnd2?=
 =?us-ascii?Q?pRGTCItT6rnRMsGCofsoKG+k+Bo/ZbrYCiTQWyT2MFgZz+1dXdb8J8JtOnDC?=
 =?us-ascii?Q?aqzZSlFsgsmZdXX+r2uAAZUEwrUzmsxfKHE6m64AdHIEqYUQICpdFiVP9S9F?=
 =?us-ascii?Q?Pi3DYAuXu3v+QUCPfnpBvZ1YQ46sjU9SaK52BaQfCO9WqAyzpJ4tj+ABb3oH?=
 =?us-ascii?Q?sHcCm8AMdxGBG6+jeTkt9v2LiOXxuzARmOWXDYn2MFxcUhvpp1Xoso3H2ZbZ?=
 =?us-ascii?Q?rWoIub7r/oI5phjXLLaCCiyhnTb2e/fne0SEaUf85vQsJyunRkA6hzWRYO1X?=
 =?us-ascii?Q?Lv4nP/39OHhVjKX6xe5AR54WaAkur9f9mZXViTEB5K+jdj4H9qSy3wzI6JWA?=
 =?us-ascii?Q?5CyY3LslJ4ElCeCBQs7oBySKMjwM1aRlOyE5hQOWOtc5lVX8jzF0DAVs/uwb?=
 =?us-ascii?Q?Ou9dvYedsWtJMGQCW+T9qo7JpjyhSb4klHVQMrEuNTfOE2pabGzaGGblQJaf?=
 =?us-ascii?Q?LXSnkO4oaPyrTq9feRxWpAuanpoElU3RC58LIgis5qGHTGpZZ7X6dOerp3ik?=
 =?us-ascii?Q?T7rmhhLrxphH0lDu0GjQq/Ke3upz3lFjMrzNqm+I6rN5KyIEru7MK8ZDaulK?=
 =?us-ascii?Q?LUIwgjajWk/627JpK8lQ48Boe0jJb3hMaZDSdWUft0LCFtLgMoCBUhq3VfWO?=
 =?us-ascii?Q?iAhwsCXjmsJ3FLM2Gt/UpnDosw94/f+gvIN46Es1OvWLecwOd2kphocDiwgl?=
 =?us-ascii?Q?CiJ2U7O4So3bKh0ocIpuPZzRIjpwHrsCtUQOMmS3s8AluLoZwRXDVtnvJuWF?=
 =?us-ascii?Q?8rwkLonetwt6u3jymgG6b50iISRra3UwIanGa/pWhPxFWnjuvgb7sdYMLwoV?=
 =?us-ascii?Q?DY0wpHFi6EEC0olCKsR/8CvPVTtrTZD2+5H2ehGEGO0LvajhoIgOM+XxsL8T?=
 =?us-ascii?Q?seU2gSZqjZGVCKcrCJ+DDFsqDAAiezIW98qAnN0Tzq67Roe6i4jXsqSu5bxc?=
 =?us-ascii?Q?LJUyIbEQz3dyH9pd61MMLmEptl9yqLLzQcbofJ+5GT4vvMhM4+hpO+8pn+MM?=
 =?us-ascii?Q?NbaKHiYD8vjCFGBYSgbKxpV/HKECTbY++iPIqDw+oIfhkpgXIy/WNCOkvuiI?=
 =?us-ascii?Q?K+jvvlEWq5Acq0elYF5qp2/UQyboqcX02lz2KJ31FxSZ3rXvyS+ixqwvCkol?=
 =?us-ascii?Q?pdSO+oucZoOgHAas1T3PYuj05EqxdAcPGEqh7znBKqiBPwhO0OGo9zZ9x/Iw?=
 =?us-ascii?Q?EcoYR6QhOxY7aoL3Rw6Jg5ucuv2G0lFZJGOuGtmy4t47iI/k2GaHlHNt01nB?=
 =?us-ascii?Q?XcgggBZCdmLjJNTEQa7C7ul0ppTkoltiVjME1o2/vXNeeMQbeDTnyHcGeYWM?=
 =?us-ascii?Q?tkPPhvhRtBFquUsrNa4NTQFZ1K9SlYC5xUtSXpn3WryyD/u2zMtFk2i0ZtBx?=
 =?us-ascii?Q?zK9eD3GAeJarcjNSZ6EmtM8K/6A2nKp7ToXLNuRR4s9ibINnzDPV9dVDo63m?=
 =?us-ascii?Q?bW3JS/ly8L0ph4PwYvoY0kxClp1x5Q6/jcTQbaHZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bfb9daf-5d1c-4c37-b7df-08de3cb939b4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 15:38:56.9448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQohPqiCAgzWB6niGVZSmfEiElGIIClzTJkqLywiLHp2dugWLHlx+EeTpYFPUcEB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8690
X-Stat-Signature: dcst4xbgx97gur93dqoxuwsaoiezzuwu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BFEBC18000B
X-HE-Tag: 1765899541-322356
X-HE-Meta: U2FsdGVkX184MBpszvQtoWw4gmzH18eV4ZsX0qq9WIT5eg47Ht9tGLVXRFM5k+LxNMChRTlYWO7az6eujVThTbkKoaBLnuU3LsaVBhmJ8M4C7BrrNPsHHzJXH6sZKrb3soQIii3J9lKbjOIDZSJxhFdtHwcHhXIigGsVzNYQEQhQQuj0/Q15r+EO+SyODUISlrGfwn7J8ikkwk17peIsOeQhydf//5/2tiRKcNR3EetNvn3vXQG0X592Uu5GhVjsnzHoZSt+aaDpJL3LxCOF2eVTKuZIArOahmiZIofPGoe0/4lRWcUe7CUu3WO1R6ettp85RR2nJGfQFXfHCVHB8bnMmSHZcst8aB2tEvkbkao+fxIs/Cp19xBGLvzWpXjhMb6KlQ2QuEuBb2GRX3R+TdmLpdr5+YdTtgl1qArVM+CKaBSXa9yUw2kWBcwVzpi+WzPQQBueAyvlM37b67r1SHYSQXkPdtNreFVmARye/uaRAHFIMGvJxM11/9J4H7uA4kVTqq5zbYvA8dV/MPB47SRXzIzyl+g1zk10ALcazxY/lIwJq2wGvMZqxo8+SdlIa67FaTK5wbmGrRY8ilyHTl9EEgp7ziN3pYPZ2uMxysNcRw+snWgCDiHt1e5W0Bajhfzqnqsxe/J/PzJY7NQDPVrgwhg4Omdf0D5Uo1Lzic7UT2TKQHSxU0xhESRdfszBgU4ULCrQ6HnziPn7or5gbbbd1bzGQqVaPG9pk/LUzYXcztH+mpAdt8V1OEPBEDUajRHfio9RsZdDgrBMS0JyfUF1zcDFum72xjAdgCXGFPb2JTKRWsVmazw+nA5oNYa7Dn/OmzF24Uh/SFzmpv/13S6ChLPZ9uEX+j3hQ/PW2NCp2VkY1HZJ4f4cMO/uKNwi3l58zC6i3rrPcu2G09do2jOP9Ou179LyC4iD1evI118zfi4DSuo25b729GFwltLDr7SkjzWqxCv+fKGmcHV
 c9W8/z4m
 EwbuHGeeN2QFKQnlUIkLfeha741cwH+tM5CrYzMxKwYsKA4Z+x60pxFhb7ZDvkjKIbijrBkrryoufUs3yMKoprhQdthaOcEVziiI68fb+nru5Jbi+tt3g4jh7RrvqNHL1nO+Tz4fHqdMbjiBoJez1GdQ3lcZSfPcSt7H1Wfi5VFbY3NNs3fjOlYm7iS+RiYH9EIR/wa9JSjH5J1VendYUeVjgLsjSoS7PEX0nZQO7EpFvQQXgywnyE8I1VhsctQcpyy/YrLQxHLrCOvFymxBl83KxhlRps8zu/e2NdkNyfAr0lF4461D6ATTNNt/5yoSleynf7fAmBWLagtBYZCCXeo5Qf1bPD8U2PE+wIV9otaSq1hDdBJI48kdSxD/GBdQuxslD+YHpWis1UC0MRvF8uzqskxlMI8I9v8GwUarfPP1ZdJ0w8mY0JrxaGvo3hGyRW59bcBncQq2LXLU3uzY1fQCBbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Dec 2025, at 6:11, Shivank Garg wrote:

> Use enum scan_result for local variables and the result pointer in
> khugepaged_scan_mm_slot(), instead of plain int. This improves code
> readability and clarifies intent,
>
> No functional change.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/khugepaged.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 107146f012b1..65b1b778378a 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -547,7 +547,8 @@ static int __collapse_huge_page_isolate(struct vm_a=
rea_struct *vma,

The return type could be changed too.

>  	struct folio *folio =3D NULL;
>  	unsigned long addr =3D start_addr;
>  	pte_t *_pte;
> -	int none_or_zero =3D 0, shared =3D 0, result =3D SCAN_FAIL, reference=
d =3D 0;
> +	int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> +	enum scan_result result =3D SCAN_FAIL;
>
>  	for (_pte =3D pte; _pte < pte + HPAGE_PMD_NR;
>  	     _pte++, addr +=3D PAGE_SIZE) {
> @@ -786,7 +787,7 @@ static int __collapse_huge_page_copy(pte_t *pte, st=
ruct folio *folio,

Ditto.

>  		struct list_head *compound_pagelist)
>  {
>  	unsigned int i;
> -	int result =3D SCAN_SUCCEED;
> +	enum scan_result result =3D SCAN_SUCCEED;
>
>  	/*
>  	 * Copying pages' contents is subject to memory poison at any iterati=
on.
> @@ -969,7 +970,7 @@ static int check_pmd_still_valid(struct mm_struct *=
mm,
>  				 pmd_t *pmd)

Ditto.

>  {
>  	pmd_t *new_pmd;
> -	int result =3D find_pmd_or_thp_or_none(mm, address, &new_pmd);
> +	enum scan_result result =3D find_pmd_or_thp_or_none(mm, address, &new=
_pmd);
>
>  	if (result !=3D SCAN_SUCCEED)
>  		return result;
> @@ -993,7 +994,7 @@ static int __collapse_huge_page_swapin(struct mm_st=
ruct *mm,

Ditto.

>  	int swapped_in =3D 0;
>  	vm_fault_t ret =3D 0;
>  	unsigned long addr, end =3D start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
> -	int result;
> +	enum scan_result result;
>  	pte_t *pte =3D NULL;
>  	spinlock_t *ptl;
>
> @@ -1100,7 +1101,7 @@ static int collapse_huge_page(struct mm_struct *m=
m, unsigned long address,

Ditto.

>  	pgtable_t pgtable;
>  	struct folio *folio;
>  	spinlock_t *pmd_ptl, *pte_ptl;
> -	int result =3D SCAN_FAIL;
> +	enum scan_result result =3D SCAN_FAIL;
>  	struct vm_area_struct *vma;
>  	struct mmu_notifier_range range;
>
> @@ -1253,8 +1254,8 @@ static int hpage_collapse_scan_pmd(struct mm_stru=
ct *mm,
>  {
Ditto.

>  	pmd_t *pmd;
>  	pte_t *pte, *_pte;
> -	int result =3D SCAN_FAIL, referenced =3D 0;
> -	int none_or_zero =3D 0, shared =3D 0;
> +	int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> +	enum scan_result result =3D SCAN_FAIL;
>  	struct page *page =3D NULL;
>  	struct folio *folio =3D NULL;
>  	unsigned long addr;
> @@ -1492,7 +1493,8 @@ static int set_huge_pmd(struct vm_area_struct *vm=
a, unsigned long addr,

Same here.

>  int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>  			    bool install_pmd)
>  {

And here.

> -	int nr_mapped_ptes =3D 0, result =3D SCAN_FAIL;
> +	enum scan_result result =3D SCAN_FAIL;
> +	int nr_mapped_ptes =3D 0;
>  	unsigned int nr_batch_ptes;
>  	struct mmu_notifier_range range;
>  	bool notified =3D false;
> @@ -1866,7 +1868,8 @@ static int collapse_file(struct mm_struct *mm, un=
signed long addr,

Same here.

>  	pgoff_t index =3D 0, end =3D start + HPAGE_PMD_NR;
>  	LIST_HEAD(pagelist);
>  	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
> -	int nr_none =3D 0, result =3D SCAN_SUCCEED;
> +	enum scan_result result =3D SCAN_SUCCEED;
> +	int nr_none =3D 0;
>  	bool is_shmem =3D shmem_file(file);
>
>  	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> @@ -2296,7 +2299,7 @@ static int hpage_collapse_scan_file(struct mm_str=
uct *mm, unsigned long addr,

Same here.

>  	XA_STATE(xas, &mapping->i_pages, start);
>  	int present, swap;
>  	int node =3D NUMA_NO_NODE;
> -	int result =3D SCAN_SUCCEED;
> +	enum scan_result result =3D SCAN_SUCCEED;
>
>  	present =3D 0;
>  	swap =3D 0;
> @@ -2394,7 +2397,7 @@ static int hpage_collapse_scan_file(struct mm_str=
uct *mm, unsigned long addr,
>  	return result;
>  }
>
> -static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *r=
esult,
> +static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum s=
can_result *result,
>  					    struct collapse_control *cc)
>  	__releases(&khugepaged_mm_lock)
>  	__acquires(&khugepaged_mm_lock)
> @@ -2555,7 +2558,7 @@ static void khugepaged_do_scan(struct collapse_co=
ntrol *cc)
>  	unsigned int progress =3D 0, pass_through_head =3D 0;
>  	unsigned int pages =3D READ_ONCE(khugepaged_pages_to_scan);
>  	bool wait =3D true;
> -	int result =3D SCAN_SUCCEED;
> +	enum scan_result result =3D SCAN_SUCCEED;
>
>  	lru_add_drain_all();
>
> @@ -2790,7 +2793,7 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
>
>  	for (addr =3D hstart; addr < hend; addr +=3D HPAGE_PMD_SIZE) {
>  		bool retried =3D false;
> -		int result =3D SCAN_FAIL;
> +		enum scan_result result =3D SCAN_FAIL;
>
>  		if (!mmap_locked) {
>  retry:
> -- =


In addition, the return types of find_pmd_or_thp_or_none(),
hugepage_vma_revalidate(), alloc_charge_folio(), and check_pmd_state() ne=
ed to be changed to enum scan_result too.

Best Regards,
Yan, Zi

