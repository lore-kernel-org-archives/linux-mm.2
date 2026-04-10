Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2826CF36BA4
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 03:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796146B0005; Thu,  9 Apr 2026 23:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76D456B0089; Thu,  9 Apr 2026 23:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CD26B008A; Thu,  9 Apr 2026 23:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55D5C6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:23:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E74AB818D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:23:48 +0000 (UTC)
X-FDA: 84641201736.28.9E82897
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010019.outbound.protection.outlook.com [52.101.85.19])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2007A1A0004
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:23:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q1QnBc6t;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.85.19 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775791425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=on70YThFz3lsPi13m35IjH9Ox2PXOcmEWPPzgJfDh0Y=;
	b=eWoDI0W7sDnjrDCb3Wl37CHm2WkrGgdFTjfwRDRlj4Xj2H8wTIWmUHfG1amK9Q7MWSWx4S
	Slsbn40ttSsPqAiP02SBg1HPhsh5p8GStDY8xxv/Sb0IrWpyqp1pXFQWvolhIGOqkznum5
	wGPfEAreOtiGlcbDj4rCDNv/fTSB1LQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775791425; a=rsa-sha256;
	cv=pass;
	b=0wlm+7nVGqwpMjJT0P0GMi7ztl6IPKWTdj+jpL1lGiYLFGso4iud7S1PRJe+VT7zxC+yjZ
	2bVeIQqL5TH0Odwf++RZDJvQS7ak+QEU8gaXaKPJMd+LEFNQY9KNHHS9yMhrIE4KV0wgG/
	8Tm76QDFZIi3tgGR59/EPekJXMUJNS8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q1QnBc6t;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.85.19 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bTq2C/ZwiygfjPgdCVQPx/HKUyylAIUM8zeSGWvzl7obvo1ehDZ21C281wYHjH/7197GXizg5ZFcihNaVfHhk70QDyFHp+rpry7HI6d/T5dHRf5pA9hKAPNiruChVj4P2KFTAz6sfE2IBote03F5t4kr0s9fS+HGMfcguvRlDIP7v+n2M5+OuTljgw+PUEr0m7h49aVnvcFMlxxTqPrTxHOcYkSGbQ+HpMX0SodajN9p31kllrTC/TnSKWchHd+Iplt2oJ0lWSJj+WsEv4GXSAbH+GluuDpLXlNzcy8+JTNlPjJmPrVrHRLJew4qRp1SPbJkNrMCfjp6FU7gDhndOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=on70YThFz3lsPi13m35IjH9Ox2PXOcmEWPPzgJfDh0Y=;
 b=BjpR//Bi6vnGtB0hjy6B1ksTk67jENmX592VRM5YPl19JPnxtUSt80s6HqWsfqyj6TxHIfCH9sXJz98Pu4ZW3hKtuIAPpf1iiERjT7bPSfvDnMGhbmXgtvI2Rb5pfE02pf6hHjpNWmyzMv1zaMkpzJ3QJ+tG/8t6At79H2UBoIl5wAj+/EK0sw4eI+Jpwo8X0nIM/Fbu4/eZSxkXHjTmJm1bpYQsDNmnCPKsRPXklt+ZgEzSAkURbusbvAQ4DHd14dLBLUyN3SBye889Sf6myNq/Gt+iXBDqDtWMrgJDIPNiRCDM+XDp8NCaC8Q2AbdrzU5VGfQPa5ZqHtbpji6jXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=on70YThFz3lsPi13m35IjH9Ox2PXOcmEWPPzgJfDh0Y=;
 b=Q1QnBc6tU6HgpMKBN2B4+SlcrFAO0sAmqP5sg2XprTu/caIuWGh/wU8pYObZS2JBnz2wOnB+EVQSMYqSjMn1jymYYRXjNnMYo2V3vN8FREq+TdMWxNdLTUAFaV6XGjAA2GVQbQF4Gak9/4Rk0UxTFKD03uEdtTWqpFfWM1gSfYfKzhyrwO4EdiWfUojB/dSNCuK9FBczHoz8ajKw29PFXMHyHyY4MlnhoJMmbqyHnUcPn9IH4IZEmjA7weSriwqFVS8D8baGTq9as/JXkV9ktZI8mR1XTmR8/qOpk4rdyiSiGjK+xf5yMLFvVG8w9o+dmdujlpo34W9PBZ8aHcUUhQ==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 MN6PR12MB8472.namprd12.prod.outlook.com (2603:10b6:208:46c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Fri, 10 Apr
 2026 03:23:36 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%5]) with mapi id 15.20.9769.020; Fri, 10 Apr 2026
 03:23:36 +0000
From: John Hubbard <jhubbard@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org,
	John Hubbard <jhubbard@nvidia.com>
Subject: [RFC PATCH 1/2] mm: wake up folio refcount waiters on folio_put()
Date: Thu,  9 Apr 2026 20:23:32 -0700
Message-ID: <20260410032333.400406-2-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410032333.400406-1-jhubbard@nvidia.com>
References: <20260410032333.400406-1-jhubbard@nvidia.com>
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0003.namprd07.prod.outlook.com
 (2603:10b6:a03:505::26) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|MN6PR12MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ab9a553-c821-44c1-61ae-08de96b08d8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	pTsN19CR2gMrv1FFOLr3VldKvCc+8tPLeZQPFsajqSZ01Y92BmvDu3IIpYzObUMfQA6s57NkywtjGVL6AVz8NAwkhB118QyrxM8YGMyJsSm08D4O/VYJ+eRPd+CpWgbov+yiJ0bGyuxqIy2CJpd1MrF7CvMgeLvYGa8jxGhSqEDiLacyrb9HNtVOwOywVPWOXmJVeeGEaoZ9i8h4m4wLUWHAm1uAr/rssJlYRETtAd+olz3/2RnkSxstje+F/rMUcMBkNDYPckardd6wrJwrdzwvZ3uXN3HJYqsa8biHemQPalOWkvNyRfpvsBEOCxswUCTS8H7z3cPyV2mZkKxUszKQwkCZamdTZRrvIx+cbvfLsRY9Dl7tEgeOx0wUi4Mr8UMNH/trXsQ+eLhL9Da8vv6yllj7PyCcLnMt3J8hMa1MpLO1Xtwct6ikVnQIgYKnPlqZPXaEM5lQwXMp5WYNh1ECJIAjrb7WdCYU68FtF2OCNe1u9fn/hM6ax6OGx6B9Qq+7KYtxpory6Fur8J5LN35myhmufgijq9hKZR/cs0FtFPwlyumMKLwduAkviYa2+Mc4rkWyRpNfEjtonqyDyV4w54/JFZsuSjl2eiuJ5QHAZuvKJvy6BkY/xPOEgPaXDggkGn6J6eUT+5QsKJETLM5GAcr96UZpVPxMuLpLFcNI5sGEUzo7NmGwqNO70tmzHMtWy+nPYrB4C7pMXv23pzBffA4Kk3piHgdeFhUl9HM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m7z8Y/F91uKVX9pJ5oaE9KYkTxaunpLSq3oBnAdsxxohzXwX8GA+cwEn7/fr?=
 =?us-ascii?Q?Zt1FhB9Uf5XjLej8wnUXE8g87sPVyAljatNIdVEaZgl9KQ04ETzNX7K6CUIf?=
 =?us-ascii?Q?iM3FME4HKCX7qJLkMggqjoRY59T2Ws8u+DE1ja0qysJh+nMmR1r9lQ+81Td3?=
 =?us-ascii?Q?jKX36uk98ml9kNUfPEibMm2C08OCGztpZIC87uSOm8gyT0yOLiId51gcHmoO?=
 =?us-ascii?Q?Nj+vT+cMnI8470Bo5yGMYjqqAkggt9tldpRdEG+jGu7ZYgM0rATch5/sROdM?=
 =?us-ascii?Q?VLwAVyKFWVIbwKXeK0Dv+hPOMGmPTBNtWE2wss7miNQMONxMOOYRSRlzPoHt?=
 =?us-ascii?Q?ucG17VsDsKDwgDwnDJ3rACpj56KGI1Qbxx8dWzyMkLTMIwASKDEd1KEovp4Q?=
 =?us-ascii?Q?awWHQXv0mhaVwbaFocyBe3nnB53uVWhGzFTjE8xp8ScVW6Xo4/OLSzaWI0i8?=
 =?us-ascii?Q?QuKt7OaOVE/MvH3qVOL/PqCxa0MDWrXWwKfQoLGzfwkkAcv11g8GpG9sicuV?=
 =?us-ascii?Q?VC3K2KI6xnM6qURrb8AAKfgcXXJQDvUYBy9WUlJN7FSmi+rqsRr9UfeK3LWh?=
 =?us-ascii?Q?uBWUQULPH9Rmaj9a1EeudPJ5MLBNw6htLLDL0O4XrAu2Zl/UWuO7NevJTh3y?=
 =?us-ascii?Q?gHi5gYA6w2bHi7Q2mTFknt+U/Zz4Xl33PBi3vxbaq6eCbsMGlnZuKxkfJIMl?=
 =?us-ascii?Q?Lvj2QhzRdNXleZAI99HUEAN9mnfnlUT3/GdQQMgmKWlNJN7eSSYuLg5nuQAc?=
 =?us-ascii?Q?aJiS3j9bC6j9o2G6mhveuKRPqy6g7g/a8TE2SIEalgOFwEDKEO0eOSkecKvK?=
 =?us-ascii?Q?eg1EddQKBK1Xho0twsqv2vmpd/36k5pEFTcDXELBxBsmkBhpHQLYnmuFpPIO?=
 =?us-ascii?Q?j0SaxXojNgNY8022lfsquzeTEhCdgKaPTt0U+NiTIF4QtscBuAsPljnCCy+3?=
 =?us-ascii?Q?KEdxDWblHMO5rz2qc+7GkZKSBaph2zRfZpnyp603Om4MxoKASmiA5RkiBjsX?=
 =?us-ascii?Q?bmAU2woDpP52L+jWo5nqtqgs094USnzt9hQjXYb8MuxbBflSgVfM6903p65b?=
 =?us-ascii?Q?e5udrO+VMabF5jEklFupOWJYmmQZSevx+usNP9lN7N+NbCC+BmFPkk+lRC4m?=
 =?us-ascii?Q?VPZ9Ad4S8+6+IZW+WAKnRf1CccLVC5/WSJIreIbDRTuKTHP5DWQG2lojYa4z?=
 =?us-ascii?Q?/bvb+gjynOTuuOaiRfUp8EVyeNTm6uYXR974WzJHbVDRkYP0MT9tLseWhHiW?=
 =?us-ascii?Q?YtzQtYVo0fzfHb0qhGolJP48vAzixM5qX+OVOnKOKP8unjitAsKROR+8CfLf?=
 =?us-ascii?Q?WVD94G3paTcLB+DMZgd3iykkcZQK6FKD53Nb9/vcPBqbpClW58/rmc/zL6JO?=
 =?us-ascii?Q?TUaAf4oDql2pUrPlS0EtP2G+vR1dPgr6DtLQJRKZv4Qvnk46YD6A7/qx3QF/?=
 =?us-ascii?Q?9flmaSGQ3GpY28jMIo12iL2BfcNbZ3tTs/uTmLguXbvkrK4/LvqCjpkVgTmG?=
 =?us-ascii?Q?LVsSF5GygkQ7IzJkXi9BXKadHR/TtWnMcaV6yC+JIvqlQm2iQ5MfvBgLmx54?=
 =?us-ascii?Q?c+S5X0fPJ4Y/pMR48mFa67I1ThABCIf1PIAValfElQqb5y8cM42cbvLSuEBL?=
 =?us-ascii?Q?x0v278kZX6hoCqA+htdrfGOWVeGu6ukqdFPhjdMldNWRm9yYXYlps3Cv0+Tu?=
 =?us-ascii?Q?//WvpAsdJIGGkzcD/iks1z/b/XaGus22JBIUGpfgI4xIyM0Y5hf0tnEOFoRN?=
 =?us-ascii?Q?oQhSdk2vdg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab9a553-c821-44c1-61ae-08de96b08d8b
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 03:23:36.7446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rKRzoThXGvj/AeUVLhiQ1iHW03uhY7fZB/EvzJizJhlHRBbAAw7xtbmkTqTjHD64C5dGGKtaOTiXayTx+RQe3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8472
X-Rspamd-Queue-Id: 2007A1A0004
X-Stat-Signature: b1xi8t8t5zwjj6h4mcppjfcjziqww6u7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775791424-533690
X-HE-Meta: U2FsdGVkX1922Ge9105l0+WaeGM96xqDvOhQROo6iujrjq41wGKSWSVs9zGb5yUJQBU4kwAAqksYX1SGAfNpL7jaUMNDJ8cATcTMLv+y4RnSrKsKn1gANZMTSTy/WMjlm7SePkEF48IBpe5M5PvrqFhZnaRPB7GQTeN+cid6UFp4rXTFWocT87akYpjHz48gM0DY5v2QdJwOcx9khra+uSsdOm2pdZMIr0JN4KJjeMn/+hIarHGbVCs0AIqaEqn5ZeW958dfk3LugPDBPculEBqeZvNJ1WBm3FSRJ3mMTGuMm/8xxPnuumdMCYMXrFgGuCEPKHQhSA39cbI3P8No2qlCBuSqsY2HMeUDqYbEptp1c+8SCIPTDWpAQOEjN5nXVcTB6xdMAOQDtTn9hCCi6s6El5Ojb+h+Sq/4+VbMTvumqMsQRnA/1f4Zdxia3IToD/+uTEBUg0YXMHKupwmuWI4gPVTN64qwWZWAtbm0sRDlkNB/jVvxb049SpDBuiXgaMVdTq1xnKZ1bEBqhP1dr3jM2d1851a6qNeW1T+Z07ooUeKR7rDf6hZg04E2rym65CB8Q8Tu4ySXOWSYvT+HcmlUDinAgVzI/i13/wd/09MbACMhuyj1+O4lMmlDkedXZx3nWSkyCZTil70ufKiQT/h2nyyCoatPt0IjPEYqNDajK+liNWvqzSWvPIca2C+Age+/2uxUuuNOM9hvkrJ2JJFQe7uazET1jJj4seoAJufAjVlh6lYeJJZWWLqsnpFlD/1Sl/6WRDvj0oQ17WUvDpTkdkP7VTalPBLwJ2VNVewGsMnAP6ThSkzwMUnlTc0aRPAU69/bHOKsvMakH+gvJ4C4bwGwy9z2bCWkX89M4f5JReuc4i5HH+6RASgjOjJZkrlHw2TwCbjFyha+chw79PI1AvstO/KaQMeja9TiZqSO1/kvZSTXx4R8M9WDDc8EGGyjtifv1LUNjUpRkno
 piawtAWi
 Zk1GKHqcXPb+LGMg7hjlHPL42MQn3861am/uquAAThX412k6nARjFXMa/pO1nM/F1iVbYSnQY7Lgmd9Eq1lWi6LVTQUWf1gnNQOZoTcNWRODalGHricA3SZBeuUn7DVNkkdYS8f/AG/yeXWD9AGYOwvp3Mko8S4t2v8whycqh6urwpHckPACImCngK+kqdIVGNABMj/TCeaop1Yi2llg+t0OExIoMChK+OK7t5QJB4k9MMsKIj3WPdJAn5ruoqs9NRD6LZzBq624WPra2OuBFjyloDtG0WnFS3o1nmTVRnyX50nXPEVTx3V5kK4VTlfmoPVBcdrjCRag2X3OQPhRVmti5td0DXPt+PoGi4v/l2MMJpbXyFJC2rKfz67qEVf1E/RuOncNe1xI0fzGW6x6zbosq62FwNgM907C0BLelFwJngF2O4u+I25SYRCR6iPXR7VPFw7T6Ob2Va81ZlF5s+PKkrr2AmHQTNBS8Bt4ktJAzEs5TbcmKf2gtV2HRb5s3gCWWeX9b/4xo9bZvAExWT2Y23kv0333v0NAYZIbft3sbI2/1WnFwSasDx0jbNqP1gC1v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a folio's reference count is decremented but doesn't reach zero,
wake up any waiters that might be waiting for the refcount to drop.
This enables migration code to wait for transient references to be
released instead of busy-retrying.

The wake_up_var() calls are gated behind a static key that is disabled
by default, so folio_put() compiles to a NOP on the wakeup path when
no migration is waiting. The static key is enabled by the migration
code in a subsequent commit.

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 include/linux/mm.h |  8 ++++++++
 mm/swap.c          | 10 +++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index abb4963c1f06..ccb723412c07 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -38,6 +38,8 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
+#include <linux/jump_label.h>
+#include <linux/wait_bit.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -1798,6 +1800,8 @@ static inline __must_check bool try_get_page(struct page *page)
 	return true;
 }
 
+DECLARE_STATIC_KEY_FALSE(folio_put_wakeup_key);
+
 /**
  * folio_put - Decrement the reference count on a folio.
  * @folio: The folio.
@@ -1815,6 +1819,8 @@ static inline void folio_put(struct folio *folio)
 {
 	if (folio_put_testzero(folio))
 		__folio_put(folio);
+	else if (static_branch_unlikely(&folio_put_wakeup_key))
+		wake_up_var(&folio->_refcount);
 }
 
 /**
@@ -1835,6 +1841,8 @@ static inline void folio_put_refs(struct folio *folio, int refs)
 {
 	if (folio_ref_sub_and_test(folio, refs))
 		__folio_put(folio);
+	else if (static_branch_unlikely(&folio_put_wakeup_key))
+		wake_up_var(&folio->_refcount);
 }
 
 void folios_put_refs(struct folio_batch *folios, unsigned int *refs);
diff --git a/mm/swap.c b/mm/swap.c
index bb19ccbece46..e57baa40129c 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -43,6 +43,9 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/pagemap.h>
 
+DEFINE_STATIC_KEY_FALSE(folio_put_wakeup_key);
+EXPORT_SYMBOL(folio_put_wakeup_key);
+
 /* How many pages do we try to swap or page in/out together? As a power of 2 */
 int page_cluster;
 static const int page_cluster_max = 31;
@@ -968,11 +971,16 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 			}
 			if (folio_ref_sub_and_test(folio, nr_refs))
 				free_zone_device_folio(folio);
+			else if (static_branch_unlikely(&folio_put_wakeup_key))
+				wake_up_var(&folio->_refcount);
 			continue;
 		}
 
-		if (!folio_ref_sub_and_test(folio, nr_refs))
+		if (!folio_ref_sub_and_test(folio, nr_refs)) {
+			if (static_branch_unlikely(&folio_put_wakeup_key))
+				wake_up_var(&folio->_refcount);
 			continue;
+		}
 
 		/* hugetlb has its own memcg */
 		if (folio_test_hugetlb(folio)) {
-- 
2.53.0


