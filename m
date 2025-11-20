Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43647CD4F3E
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 04:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F44E6B0012; Wed, 19 Nov 2025 23:01:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5146B002A; Wed, 19 Nov 2025 23:01:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76D9F6B002B; Wed, 19 Nov 2025 23:01:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 632B56B0012
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 23:01:37 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FD7613B4A3
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:01:37 +0000 (UTC)
X-FDA: 84129636234.30.8DDB22A
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010044.outbound.protection.outlook.com [52.101.193.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8080BC0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:01:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="WrZ7ha+/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763611294; a=rsa-sha256;
	cv=pass;
	b=EqePM4cNXQLFJQBuivHm8T+LtCo4KKEuDiNJpODXdj4jbnR/v5AzqR935UHMSAVfzyji0h
	lH4Sl6QbvxDUssMMt/5BSsclCeBLS/k0EhbgwnTYW782H6FHDLA8/Hgv6Zd9E/OsOP9FTQ
	r8yCzB0n8EIArA2s2JmmmicSFInklHQ=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="WrZ7ha+/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763611294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8H4pbK3PzXou/lsjaM2o3PLu369tSmZsOqtm7g12uU=;
	b=T+1bA6An5pCR1HFo82ury910EJbc9psUtdfOdWbkjLva/UteiRx+1UC9O/7/Vt8Tjwu3wp
	wegdCqykRoEnifsN4Ke38GetzbKGTJc8v76CReTku27RdALISL+oP5qkoPzToZm3UTWPRm
	2Q/QE3RFQxCEPyq7W/v3/nlVoiIlFJQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H1j+ivX2/SUkoOtkzyEhmQI+XtiSkuozZpncACn4VZ8oKO1VHj2Ocfavz9XrrxNma7F5jKatNs66LtQKixaCmfNfojhADArUzG54+c0a0PGm21DuK4abG8NkW7Vt+rqKMYcRFUt7t1qxYoprAiIUzlhHuO3n9UgbgiEVAVcWt7FjrStxH6z4BA7DRYqZYoRp6T+G/QEQ6D6Jxj3HJWhfpyeQ0atKC9IzSxA9taPldpW+6HSYZVp+1XRho+8TfEzWd/6w4FuTI2eCdl6BXPQ1F63SX6BRAy2L0i9U2rclzpw6cWZAH2kmSbgtE3Sx1z5IbFOuIIjr8nCeMYHKtKBsCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c8H4pbK3PzXou/lsjaM2o3PLu369tSmZsOqtm7g12uU=;
 b=jimCEoFlnEdL7cKosyQrVncpXhF33rmRVAvejFZB3kzaRBDDqyYRl57WvZ68kcVtCuihwvldsMoiG/Wu7U/shH9ZQZ8zNTBMTcXNbsBy1jW4QmHwXims+BuIeQAweC6tsVRTIFuDP63do18RNf0233ojWPVgkUvxSrlzcxkqdtJPZY+B1QZsOhHrFyFcMFvaya0yEcsb6D45MN0wFqydPf3af8ZaGLasZrjcAjefP+OSil+dFIpUSC1l/R3tVqSDZCVbCMGI0jLpZDPMKpkyEjwOPYCkOu7/E2oHBt0P5T6O3uB/nBf+3mh+KZRcWMIZkIfGvSlXl4a20Zo6sdszzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8H4pbK3PzXou/lsjaM2o3PLu369tSmZsOqtm7g12uU=;
 b=WrZ7ha+/lie3y87EMG2F17OB77HSxmYIbbzOTj449Q9/gLXhVfahXIAdeOgArmBq3xYucYSqKo7XpwryHNbRouj1j7A8gBUsbZvbzQWZU2fAmdNU/tBVBtHMVnK1QD3NuREIqAB5nrdhQHncgxyFGIfYetv1F/Rdy/VfVpvjYriPiG7c+eefSlGzpxNY0eUE+pigDG8EuyTbX0men/T8y02TC0kRXHWq1XjQAEbvviDiDIZFcd0t43JXrMZ1bwdru5FDyaWu3iuUwNmfxl6IkpsxRF2lU86S4Fkvgu06ViLH0+cS3BO+WEvYPWQmBUJfIImn/hYRJa7BykDfpE9u9g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7914.namprd12.prod.outlook.com (2603:10b6:510:27d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 04:00:06 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 04:00:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] mm/memory-failure: handle min_order_for_split() error code properly
Date: Wed, 19 Nov 2025 22:59:53 -0500
Message-ID: <20251120035953.1115736-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251120035953.1115736-1-ziy@nvidia.com>
References: <20251120035953.1115736-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:208:51::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7914:EE_
X-MS-Office365-Filtering-Correlation-Id: 942c85f2-5f00-4ca8-b90d-08de27e94aa6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6dpNuy8GRJS5+Ln5ctk3kJi7zJlZFB9oypoTeJmPN9/kICkLpiGxVzp6zgzi?=
 =?us-ascii?Q?xQDsiepqC6/m5HggSNexXDmuVDq5hPDeS/6EowObFQMmJ2qwM0qxOBB74Gih?=
 =?us-ascii?Q?a5lecdDM8B28Ru/tv7VMVSuErmBVzRSpnJ7AI+Qa6Xendct5wBQGE6l44nKq?=
 =?us-ascii?Q?ob63V37x+C5qyVB/FhE4O2JAnTRpf7ITLJ7I51OZ3VLFvMLd4K6lr3fWx6H7?=
 =?us-ascii?Q?3XHHdX9mZBhA2F5B+sAAqAVOcigZZqjuk0R58WEkcI/Rgv0TKhn1tcPNVX+Y?=
 =?us-ascii?Q?/Mx/RBwLGFq54pvgUwIWFukPWvyu8mTUKiVasOmMOlCRNWHBD88y6MlKN9YU?=
 =?us-ascii?Q?Qk56RaGdBTzP7IiaJ/Jg5ZDfGueClZBBU/ord/bhTkZPVP53co497WF+W3d9?=
 =?us-ascii?Q?/8fbMe2j1fr51DQmAjXLUr8+TMtxkkOqPyyjjdw5K/E68vAhJAxUVBVya0pJ?=
 =?us-ascii?Q?ksDmXjcNetYIknb/O3XQw5fTO3vJ5fdNxKHlQr6GkjEnJuku8Ng+YAfkYDXD?=
 =?us-ascii?Q?ssvMZ0D1zC+xp2khB6lFvonJBepjs5KVqSUw9xrBktV4g5D/bk1Tcq+9zi6n?=
 =?us-ascii?Q?pAqKTfbsDm5y9pPANt3jWdLxbMUx9PeON8Dic387fzuy8eO37A1ysj7xmlvy?=
 =?us-ascii?Q?xfpFWYPOGzXyDBQnZ3l7vRVQnu41tqs3V3Rw06LCsOGVj7TH8B4kN/9lhAML?=
 =?us-ascii?Q?cyi20C804MtzjJulZpdxSKpMHRMCApO2KhKLn062LoA1xlOU3OwPmab5DnDa?=
 =?us-ascii?Q?+OXPkZD99pEzGGVCc0lWaOglaPDYj96Eg8+JIRWPX8Cc64yukI9J2jPC7qcx?=
 =?us-ascii?Q?ANtjMIsYtpfb35PYRxxde+ddtBtKFpLeiik5LRoySZqPaQAYTQKYQ0w9BvDr?=
 =?us-ascii?Q?GILcIBmro1qMFTkxHFk8edoPwzM+hEefBQtUJqAvWvy9LRce/S3J78ElDdH6?=
 =?us-ascii?Q?OWwViam1m738rQXpb0CibgYp7geNCmlMxPfoljPoEjUB1Ytpmf/bv/jsBCN2?=
 =?us-ascii?Q?XdiVpQzDUj+c5SdsGYxnZC0XYTpyl6DFz8AiUPSfy7N45+e1wtZNMjYJr3Qr?=
 =?us-ascii?Q?CpcI/FaPrE0N/cWajGqOeUmMgnGz54NPeTthfqvJVoTmCrpaONWPBypRHkIQ?=
 =?us-ascii?Q?b60SP+TcYJc88Qylldhl+LL0tfTqIK6gXdzOuXCdZtlntrIeRVqbGI8yCC6Y?=
 =?us-ascii?Q?LEXKHIfI6ah3R6dqYUTBmOsbyJJB4St4+ybOjBAQ6cEXh739G6T5Ro2TKDk7?=
 =?us-ascii?Q?ZlHA5EWR6NRcnjKy8vmoGn74Xsqz2Djz86bGzyEox0IORsn1H1NkCpF12LeJ?=
 =?us-ascii?Q?LTXP0uJi5gC9jfbH8/wa3yMK5WxrZTJinlthYXa/9nZsRdOltKvTLvTF30Na?=
 =?us-ascii?Q?7WrfH+518lcZw23+HxAifVnvybTK+PVTeQIGFmiYIueOZ6Edk7Cf0WrxIq6T?=
 =?us-ascii?Q?z7MwLvi9ucEhX0vqVFhjgTv7bZN+AWnt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8aLmUzcZ5teV5i7bOrFU/ZVp9wmELeG9aDUJyrBvAycKIjFCLjvLE3vmDjRG?=
 =?us-ascii?Q?Gdo+h/E7B3sVQ6J7Ij86JqisneIQSdYUQZb6c+bOytr3q1MIbK7hbya8nNDA?=
 =?us-ascii?Q?LApULkhPebDd0M2f6rhwJP3QG+z4R725bwz6YoEtSGLHjjHxUFfk3t3j22Jx?=
 =?us-ascii?Q?NqifoIzEwFDdp2VNZr7AGBFwsa3KzIGIuImkMsFRGLKRmbGwS0j42ffp2DNI?=
 =?us-ascii?Q?ySHIhPRuWO+ZeAfzhKjdxpooeEJ7CCReIXS0Lmhjv+bBDf2bq5muz45qTCYv?=
 =?us-ascii?Q?KnKdGxmvafYBwZRrw5b+K9RdgoBKafxAON9ETfa4No2I6Fq8kosPyIEN6tlu?=
 =?us-ascii?Q?UjxDId2lGDYzu8mhFXYfOvseXa/tv3YQDyhSSZT/dY4CDWRYWRBLS3jbJlsr?=
 =?us-ascii?Q?mnsOZ8P44VvtJjImFR6tk8uhghNS6eKEn3MRCjYOjqlHRp4i+6BNMDiPrE+P?=
 =?us-ascii?Q?17cbI3EfEvv3fxvIfrkwnI6E6VbRJcJZCj5CwWQYBCWNyBmlOGtdQ0jU6lnY?=
 =?us-ascii?Q?hRD4J6TyN6rdpNqfSkEeSo5+1lC63KX5abFL/UZHayeMG/5cDaLMYq5KMVE9?=
 =?us-ascii?Q?tM8MG3u0vh3s9EgwXVgEimDWq2WhKjwc5bcIDt6Nl5ICIaoV8V7JhYREH/yH?=
 =?us-ascii?Q?37d5gU8HepQZuk0A/eo9FOTAPOX1iiaL0w0BvX6D1t6wzhRjGH/ZZPB1+KZ6?=
 =?us-ascii?Q?2KRayeyPbNHyFCTqi2nw0Fk2+4/bIOuWGHjpQecDYOcUAeHeAf+BhK97gxo0?=
 =?us-ascii?Q?lXXsk2KL0KdQ74JFO6FBk1jj7U8sfo6+oy7MOsG0QVGg9k6ny7oHcpuGdy7X?=
 =?us-ascii?Q?/Cjx59LHVzmZFkM829+nOWeDHxh/pVCrSv2EvjMrcrdgZXQCioWkDMq/dYTC?=
 =?us-ascii?Q?1u8mPak3ATIYwJOasv9lBElxJgzi3gEE5F459U1f9xpKvUgjnlfHke5WHX9u?=
 =?us-ascii?Q?/1vzRdAd++JOEETdYC6QhF6NPSHZyNPxsUL6YktisFUeE/DbC/hg2suSedvX?=
 =?us-ascii?Q?Lw3w2VxJyne4iz0Y2PByzi9/gmS48kJHunMaOO5R0EMu85+bFFYostI52/TH?=
 =?us-ascii?Q?W+OPwPyxjPLikVR5SD2mvfw2ENgI/WDu23yD8Obovw1Tl+loqBGq4NwZhTZ0?=
 =?us-ascii?Q?MwLagfnwGr1krnRN4fymQuVn0uPxyJoPGXHZqEvKF7njF3kVpC+V7wGKdr7S?=
 =?us-ascii?Q?MSMNHP2vs5bAOMMoIK2PE/4sFAaF4od2yZHw/BtnH1aoFwiiK/w4KKwGe225?=
 =?us-ascii?Q?0NAYsemT5waAcavcXQIgHUGAl/5hBIydho0/TwGtS7hTdwD2TJPIurcNZVIJ?=
 =?us-ascii?Q?/irfX+EsSkb3TZ9xrutOBB7HJ2jZnO8RnBv88ReAg+b2bT/XbnEEHPbOLt9M?=
 =?us-ascii?Q?57R40saAps/BMsO8+dNjsznI3Y4KIlBn60ySpcNnwCdLn94SJqJs3Wqd4LFz?=
 =?us-ascii?Q?6oDutw/ZKFeredxqVV+54V9w96bWeQ7FgZcFfNSrKeIQZ4KUuZd/xTdENmwg?=
 =?us-ascii?Q?USAIy047RiQje08QIuL5rxUCxNDlWrdzc2q5gIbDQ8gi6tG/cUgGic5FVDw3?=
 =?us-ascii?Q?L/i3d5Jk28+2DFrvbtwlLPqG3xK341UFKlzt8P2T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 942c85f2-5f00-4ca8-b90d-08de27e94aa6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 04:00:06.7650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Qy7jYcmGzSZnaM8pN9sHAEr+Blxdx7GFrKoCZLtqAjnu6Cugu+CeOc/tUUmkfAU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7914
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8080BC0006
X-Stat-Signature: jzsdjc7genpspr56zuqjcy5qax9xuw9o
X-Rspam-User: 
X-HE-Tag: 1763611294-691467
X-HE-Meta: U2FsdGVkX18LPa1ikCDEAY1uh75EgtUXKa6O+PS55Wudo2E4UcVKcFOaKXydn4JqsOSMtFQQILP+dfV3g34YHQ7JJfSgFu7YqhQEE8zTtB3sot/hVGgIBXJIjw67OAk5NBGG1CvSe6qn8NO50Q/4qM8nT3OlkdXw9dwwiDtin8ZSssxXPQTPW5B1mHoxDfiE6u9ikFnNSDQ9o8Ta2IEvFmz1tiQqCAe4DvDJh3VltdJp1z9QAT0rqg7AuIGpXbxktFD/jzKEcW4QjEPz0G72pHgDfymSl/JyTlDHRi8SFSSp1N3dx4J+UNXbP9Um/ZupfQ//MYfpS+XKIFMnEkyuaUJNJktlc0rhM7JEBQcPypTrmDwbgnk38PYtWNc1EAPqYR5lhBjgUXOLn9stMZAb8w30raO31d/4NMkpE1GshktcTyHogRlmEiJy3PHb9BpyXcgU2ZU7hkIiFLtRbI06dWGVqCNb9Dxiq/UDjMlciUucs8KKvZVfL/tQUfUPPoKgP5hXp6gzoht9JJ9AqwF6sHaDuHTPepyb3ip8cbejCc6BEMA90SXrmbDFfArahkR65beSgTHEWisJnqep9Ti379z3/f/SwnaVozWTTuUn8HsafF/lVgxV3sW/ARJ07bj+/GsCKHGpsYgEG3EuPTYVGfdJ2JB8SxSCxVm0hX3JSaoO31Xb9S/Tg5pYP71Dc7Imvt68iwFQFwiOOd4tgZZfonro4ADLicv3xPbLfYnjKxF+A/ThK1kuJoZBoG78fe2zH19RzlzRm0uc/eG2odvb7PTltU0e/J+q99KVbUeVwRIPXxs90tm+lyYudJSchg7fSDYECcV1mLFDiHbDWDGdcQEZQrZAOk1YWusp7BabpkOIsxwYot/cRrvBXCfj1WRD5bjclpu8E6y2yUXySdGx7Mc2myuqRi4F1n/jBFIiytHCZVnSQvie2OY8k5PmF5mUt9hiFxbQjN8WYLDh2Cd
 c1VXYaGj
 HlrhpDDMRPnUKx76eF+uLq5vJJrGigplcSiu3ZyFtQeiiNziSxdvPJ4Kg4xV93TkOSh1KZkqY6S4QBzKD86JxfAUXlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

min_order_for_split() returns -EBUSY when the folio is truncated and cannot
be split. In commit 77008e1b2ef7 ("mm/huge_memory: do not change
split_huge_page*() target order silently"), memory_failure() does not
handle it and pass -EBUSY to try_to_split_thp_page() directly.
try_to_split_thp_page() returns -EINVAL since -EBUSY becomes 0xfffffff0 as
new_order is unsigned int in __folio_split() and this large new_order is
rejected as an invalid input. The code does not cause a bug.
soft_offline_in_use_page() also uses min_order_for_split() but it always
passes 0 as new_order for split.

Handle it properly by checking min_order_for_split() return value and not
calling try_to_split_thp_page() if the value is negative. Add a comment
in soft_offline_in_use_page() to clarify the possible negative new_order
value.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/memory-failure.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 7f908ad795ad..86582f030159 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2437,8 +2437,11 @@ int memory_failure(unsigned long pfn, int flags)
 		 * or unhandlable page.  The refcount is bumped iff the
 		 * page is a valid handlable page.
 		 */
-		folio_set_has_hwpoisoned(folio);
-		err = try_to_split_thp_page(p, new_order, /* release= */ false);
+		if (new_order >= 0) {
+			folio_set_has_hwpoisoned(folio);
+			err = try_to_split_thp_page(p, new_order, /* release= */ false);
+		} else
+			err = new_order;
 		/*
 		 * If splitting a folio to order-0 fails, kill the process.
 		 * Split the folio regardless to minimize unusable pages.
@@ -2779,6 +2782,7 @@ static int soft_offline_in_use_page(struct page *page)
 		/*
 		 * If new_order (target split order) is not 0, do not split the
 		 * folio at all to retain the still accessible large folio.
+		 * new_order can be -EBUSY, meaning the folio cannot be split.
 		 * NOTE: if minimizing the number of soft offline pages is
 		 * preferred, split it to non-zero new_order like it is done in
 		 * memory_failure().
-- 
2.51.0


