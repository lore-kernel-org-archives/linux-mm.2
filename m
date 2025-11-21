Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D035CFC296
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 17:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58026B0023; Fri, 21 Nov 2025 12:29:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08786B008C; Fri, 21 Nov 2025 12:29:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81376B0093; Fri, 21 Nov 2025 12:29:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB7256B0023
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:29:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7BF459FE9
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:29:08 +0000 (UTC)
X-FDA: 84135299976.10.3F2E724
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 422BB4001D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:29:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CifrfoIB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DXmAdX2Q;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763746145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Du3icCL7iEJaqZCevabnRoenSLAvUlp/tI2lKF00qTo=;
	b=lmRHVfprkF/pOsNcKScuD+kJU09nE2FLYMHE4yC5UdyBhJd/4987onBwamRj0oLDtpOwn0
	BlVDyhIh5pUjye/u8aXPv3beceRMBt0DuEnfzyDus5x/6rGwGglbmBi0dDvdi+/7ZbimsZ
	ot2bI7NZGZLNcoWXdyVfZaXg6Y4t0dw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CifrfoIB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DXmAdX2Q;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763746145; a=rsa-sha256;
	cv=pass;
	b=whfI5ubSsDST+p1M34Na4982LkDPNjWFkTAO+1UBKAkkeem/khytQS2cg4Wvgrk3C52qNf
	wJpydyEjNlu4SdnFNlidH64PhnxcY086xXp3/Dj7YWG0HXEiJA3D+z3fEXfKVB86JWh1Ph
	CE8loQYtD1c7Y+cEJDgwC6qUZ270ehg=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALEglrr022342;
	Fri, 21 Nov 2025 17:28:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Du3icCL7iEJaqZCeva
	bnRoenSLAvUlp/tI2lKF00qTo=; b=CifrfoIBcNe0DCF0bue1Pu73KDkGW19Ifv
	KOlBF6ezGRPxwqGErRmb7SF3J+pcX1X/ac1HV0OgimJ2N1sgvu+MnOdeNsJrTjTh
	rqZviPoQjwjWq/0yzRyNQo8Eb8/Sp4GsgackbiSBkgn4w265H7D80F1EYC/VsCgY
	Tvyugvvld0mJ/h70tINneOfpr7/4LmxfRNnwK+HcWeKPL3T/eFe4JSFKQiXH+bYy
	XyRuLtsRBBzaVH9UuZxlsu0UkONuNiF8MLlK6TFywoqC1UzoTdCRH/9YLyqKY6VT
	J4XIbNrNA84dZ/qXkFIpEiSgFpSaKyKCUXH85cdrZnzwUqvne9bQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbmayq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 17:28:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALG0ngm039923;
	Fri, 21 Nov 2025 17:28:39 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010040.outbound.protection.outlook.com [52.101.61.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyr7rw4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 17:28:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j72Itv9GnkLFbFt+hNSbiI7Ln6DANLQ/Fy0+MWNZaeEQ08brUcX0PFk1ag2qQmL2dn+uLSL52jd8VOBhMET4G9Tx+rFvROKudkgq/7meDVjbxL/MCl/oiQDBRu2oUb4Ona7rzk0a4hrjt46qAQ4+kzNM923rSEjK3XxYGI0T2vpyySCiBwxSo1fB5+l7pSBwVXDxm0ZwcsoYvSOxuvhY21oZmwDBbUzyK+xNKjmyGPUsIwdDCjntzIz2wIIED5tQVevzTh25WTAOrP7kbPW7zJU0Y72K6zWG43N/E0RdmE4+B53ugrmNWknzCGhBtzNYF7NGhnfpRz4wxpXZjBREeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Du3icCL7iEJaqZCevabnRoenSLAvUlp/tI2lKF00qTo=;
 b=b3fmMzvZnbBc7DY7pTemkKT6YdVUvb7kb1TbxKBl1RNLD41H9BHUWD/kaZSsdXY812TI79a7L4pQ4hVF8QYnNBQYNeMxfWzx+gj02d61gMo21mE/sinMGdvZWhZr81mHSooBYS+N6VIHSFAmuM+4aP189mb65Qtwl2Np8vmlqvL4JbG+yWatUnZFtg9M7O+ave+XFl1sEpbnOErpztoVLwQ15m8BbQ3KvfZxsrGGUA+3tjB3ZuJTMv7ROE75T61FFs1G9vSrTYgy3SgiOzywUNE7pqezMqxQpOg/FOevPDnFKuqkJTuH2vnm0eAkeYtZmwEKT/2jU299sH9nvHYA9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Du3icCL7iEJaqZCevabnRoenSLAvUlp/tI2lKF00qTo=;
 b=DXmAdX2QcVzkqDwDgStA8maPldT1ORIJ10Bw8rbjEj1jtiRUNBUVzELnIparrMgiJImmqpLpa6YF20NKh5KaAJQyOvwRY3H0YH+uvI05p32FSfz97F0ytF92lpq2ePieR5x+N/Hy7hg5Vp4fqIjxxVfqLMqmKIbF4xreuuoIVLE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.12; Fri, 21 Nov
 2025 17:28:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 17:28:17 +0000
Date: Fri, 21 Nov 2025 17:28:15 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jann Horn <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Pedro Falcato <pfalcato@suse.de>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        Bjorn Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
        Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v2 3/4] tools/testing/vma: eliminate dependency on
 vma->__vm_flags
Message-ID: <4aff8bf7-d367-4ba3-90ad-13eef7a063fa@lucifer.local>
References: <cover.1763126447.git.lorenzo.stoakes@oracle.com>
 <fb709773edcaf13d7a2c4cede046e454b4e88b1e.1763126447.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb709773edcaf13d7a2c4cede046e454b4e88b1e.1763126447.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO2P265CA0271.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 91579c1c-95f0-4835-b709-08de29235bf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/MMY64P2rdzl/VgQQzfyk1N3meNoTwVQ8gF9EGlAyGw3M5lsSY2AQQj11Xx6?=
 =?us-ascii?Q?HgHPJUNYsNODuA8p2IBdq+08o3OjzySE9dsNHMkH/iwsb0talBb4MRRWW4im?=
 =?us-ascii?Q?ZzqgzAJyr39qi63cya14mF4YRH2mxwpscyGJAs3+c0Uojf579RM7E968y9qu?=
 =?us-ascii?Q?Zmbmq5HwftJ4DKnXEbQNMC1llF7m/clZ3/F4f5vd+nqTDoe2dQtVCQGNfhtB?=
 =?us-ascii?Q?RLtvb+1uoTojkmavcLGklvwCIUh8VzXtrdEcj7dUzxoJ8Og+OgqN4XLclSdx?=
 =?us-ascii?Q?xx+LJM13BeozJW23ECV98cPQqNiD1zUjvgPeVpzWOS1NmKD2syuiaZNsK9+3?=
 =?us-ascii?Q?oTjg8r3aBxuIizBxZRzWdd4WEpDBGmbTbjzcxpwxS0ztrjwjFyPKYv4Z19uQ?=
 =?us-ascii?Q?bSWvz8yoOR2Tc3Kh/FfNMGKYLS3dwW5IT5IjOyfL6dJmwhHhM26Iq66tOkmE?=
 =?us-ascii?Q?5yb9JrfZG6zQ17dGoCvIBbZTBJ6i+Vv5mJYVvr28tg3oBqOeRINlFPsMpDTy?=
 =?us-ascii?Q?TDb06o7AdbHTpiuxEWax1Oyqdr0YER++ZsiQ+/A4NlZAAbDsg8D9TxvKcvIK?=
 =?us-ascii?Q?P1YTiKWWxTcZLG65CADIHVkexYxHbzNILgOmkkmbrBuZK0KtJ8Vmyg3jCJOp?=
 =?us-ascii?Q?qglxm64CTmMINQ/m+zM0S5mgtDMmztGEz8N9skkb7/+w6TliDaZaHloB0w4M?=
 =?us-ascii?Q?AmJm8TpWhSZ6/nhWY/5dMJp/N4EBKZy1+/w5RU/1ovL1mxo1LIYMMv43cF2G?=
 =?us-ascii?Q?oUi+GuBkNPbiN/dl+hUonWlX4uX9mUKyTzL+BUJqviJA62pBBEIummuwMaGD?=
 =?us-ascii?Q?Gar3za5xsNLOhqsc5okv1YrlWG+7+z4wJj4vTE1EDYcjHeLtxK2z9MKf1xYy?=
 =?us-ascii?Q?gk3KOhObXGSqFvBdPYQVBWHgsKUpUq1S8xSYF4fM4uc5PtkvZTfTuc0hkrnS?=
 =?us-ascii?Q?SZho3CLVN8I5qSelHsgdvrnWqB4zAhZcoUXEd+9fXwLDlWiGdMrjltVO9zBK?=
 =?us-ascii?Q?bXZSSWCDu3n6qjEvxYPXG5+JI7oinOmJow07Tx7emzwo1ZumaIlAIr/wzKYZ?=
 =?us-ascii?Q?ruDOy243/LCZaM/7yKW7pmYQXCQpAiSdGOAQul3oSToj8D6XyzM/2RJdHsFm?=
 =?us-ascii?Q?flAiktjJDldOWZw9e7a+Z8box3FDrhSzIeD3Mu/14TQJxDED9tHt902N3EaX?=
 =?us-ascii?Q?2Fyg/A5vXN5CBS9ZG6JAJgPfZrs7j/Qs8+pYJG9cL+w3ItRFMHjBRVAGRd6v?=
 =?us-ascii?Q?jerGOoCHA3BowBSRRgdMj1T9KB0rd8+1acfzhC47BFWSCaBce9Iejne3J68X?=
 =?us-ascii?Q?fHu7TsYor5pfYj2w/DGIVUm0JtR+knVAqu3UV723K/OLuZUWzUpoId9gJkFg?=
 =?us-ascii?Q?qrNk+V/hXoHYKor0ElIcdR7Ags5y3FeKum9RgkQWW9sQAhJqShc6luVpVO88?=
 =?us-ascii?Q?0OhGFnm0ESg2JWSG6mj7XOl06uuNumjJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8GY3ifWQbzqIj7y1bH/NYc6J1RIxDM4sxZTeJ7oRAFoqLsqydmzMPNcJ+m4E?=
 =?us-ascii?Q?4UFeRKt4PwzoAqjhJuZgYMH0OYq38Y61Zbgp4ni+Zyrv9DfvOUY/8Xh9hPGs?=
 =?us-ascii?Q?e+SFVziqFVKOdVZ4ciOsN/NAsusdNwpeIQXSlVau/m0Prlh2ef7uAJ/yBl3P?=
 =?us-ascii?Q?Cj4zEacvY5uOaFtRuto9mHKlfWm2pMnCiPi6Ff+8+FNQIi8cPgx36gV9bFIW?=
 =?us-ascii?Q?FFdozF5Mlf3lJDV7qJyf7aWHEZ3A99NSQh7MxsuA5lAd8mq07/sMZt+JMgvk?=
 =?us-ascii?Q?phgrIfai4Bqq+PtLMhjbjak4Txd1iJZKoH0euObMh7JbXT1GRPDO5riJ92Rv?=
 =?us-ascii?Q?oDgYpYcPYnjWJExVugSqaC/fmYt5+3L9zOyKzqf1V2mzqu5k49mGy7UloXvZ?=
 =?us-ascii?Q?fkEaXghUcc2jJTDaTX4JBJaN1g3TogbsDKP94HTh7g3QWX528jqMy8nXi82s?=
 =?us-ascii?Q?Jl/XDeTO9c5xXtOqUbt+qIGlnG8AnnFRJUy6Ia85XueoJoD2gpySbLDfJUcP?=
 =?us-ascii?Q?ll4AM2cht1J2xB0vOEnNGB1X7VbSuXXKhfGyctCBX7XXe5jixEEfVkux2ZMU?=
 =?us-ascii?Q?uCUMxAJhKeDBJ/izFf+BrgZ/WvGoOg+93fA5e41zEyFOJZYWuvFj88Gz+SKH?=
 =?us-ascii?Q?gVyZzXzljQEhzTbhuo6jWpcCSY2Wyhf0WadQeRL22MTmZjx12VKIVNWwUnYB?=
 =?us-ascii?Q?YGQrYgFqldaRRKg/5tHmgydodLcnQ4RkHFzWaAu9Du0yQplfcAvVMIVDUXhI?=
 =?us-ascii?Q?+9AUijQbgENModaLRJ8gRuDOJFP2b4F6qpBEapAkW6i6cjCbSIq3fj8QNUyv?=
 =?us-ascii?Q?4tjzeimYwNNJS4U8BHg/JmqYT4WsZbc9bnojt0cOSbzCH5Y8j6XYUJ/7uk83?=
 =?us-ascii?Q?YtEWB1C4CmrFGP/2DN8665lrfxyEw4uET2318p7KclFZ2VS+vGCB6+IaDgdp?=
 =?us-ascii?Q?qhlVEJWA9hvLpj1l6oBggT21dT6ZkVulUI/HyP7VL3L9pKM/D5CXJJcxJEyj?=
 =?us-ascii?Q?dSeo4sSR3RCJiLumFryn6Sp8d84bcTXSul0R/qaC61FPl+3VETdck+Q8Nbn9?=
 =?us-ascii?Q?0nzXlIAj30l0u7ZCC3nBSZy22M54MzGljViqzRmUrbV2428+AAB5GS+nqybD?=
 =?us-ascii?Q?SYS8kbvyvzVapST0eVbYzsiH6jCSMEsgmMTTSvG99WLqTtY+b48Y7oqO35bp?=
 =?us-ascii?Q?wa3IiLzsH+pfltaVoAOjHRaE6WI7SqszcdPuEYIt7X/BnNysNQjqijL5Dl3H?=
 =?us-ascii?Q?dkfvsSP/P0Z8aVE4FffnSY3aYSNcv+Lx2M32bTYBbrpooe3c/3AEC1YuTpFv?=
 =?us-ascii?Q?RFHuketoYk0HFcVPlshPhYkET0a2IqV4FiXJnZM0u6UeJI1d23+RfA+v7u8y?=
 =?us-ascii?Q?Ff0bxdp7GAJGW1V7CLPFHXDRSoqo7J3e/hkVf9+SOvNJTZVTtmPK2rGL74Wo?=
 =?us-ascii?Q?wfwwsuQKqgGbohklaq8dXD1LrZJ3IjNLs7srI9AA6nag7fTcob4JP0464gTd?=
 =?us-ascii?Q?4joioaLfuev5x+o7Qrbzhf33jNIlYnsFhJDjpznYcG94pia2ppwcd3v1AVx3?=
 =?us-ascii?Q?1ncDP49F8lldS0mnAM0QA69sFDka5NOygeyv8IErq1o/lw8FICXeplTNgmO9?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yi//XiyoHGi9Y3qvzN0dKcUUh0qnj7txp7oDUpZTjKSx3AWb7c0yKYQcJLbgBDf7jCAqnbreeRSFjjoRzGfHeULbNYTRYb0rOlBLP4ZQvO/UPaZfsomaxOg8EQCOFoZOKzbAr+YujGACWRgpeC5D+Woo0+Liu1wffWEOXL68XHuDaR1qa4IIGQwf/Tokx18aOeIJIc8xMYPENrHzoZ+IPf3qtqtDRYWaSG5syhEVjD/3iXf+q/SeWxgBLDiqtFSwxq7CravD5sx6XuYqt2ssrVbjQYOxSpqp8jMKgWNgOrD0trvIKb2wU/5ENGmcksKJbFHTLTmFK74pDf+rvDIFdef5qmP5XV43q/AA+rlIG4XJcdgZD3d8C0ZfR7T9vE4YUdV4FPhNhnNrUHNfhzmJQHoW/2C/WvSwRfmQJx2s3aVU1Vyqqd0nqBiRDyyX5hOYzJOP3DtdvKSYfRB0jPzvohbPRLYD6hhcPgiWscatlabd3i1a/uQflctfEBBx+3k5EzjHCABcJiY/mBsPegDFJsO5Vz6RPB8Nr6nPPgA8wBuu2B/zeSnhUO+BFzrATR1DcVfqXszp3/5X8nePItwunTW3Ab3zqG193BtkAVvtldQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91579c1c-95f0-4835-b709-08de29235bf1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 17:28:17.7110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldQtffEMvVhQm1pcUC5Sqor7njZ9zfrd6e4Jeoj7IOirN7cjb4vZYQ/Gw39NkHc1H8I945fmXAVLa304lDE6c+J+zmQicGdrlbcmDs/gE2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_05,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511210130
X-Authority-Analysis: v=2.4 cv=BoqQAIX5 c=1 sm=1 tr=0 ts=6920a148 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1AWvfZUCizywWEugc4YA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12099
X-Proofpoint-ORIG-GUID: HN8pMVDde9bNduW6TtOyn5FZhYBAK81S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX5DTOq3kBUWj6
 jjGEgvyrICdd/23jztkO3aqNEyREKzIo5AJ/X/t7hpCYz4dxXs5nPAuG/zdqdMQR5z1l0HryaO8
 pnc368SqiSmfCgoj6w+F/Sx1rKamZWdtIrtn8aPsTGeCVsfQrVsH00yPaNwe1lf3PM8srrh6Iuo
 pX1iSnmIJdptBwArwxCQG6RBdXY4m8VZ0ZLwL1/FmJa2+Iy9H/fp/fw/ObqTLP1qLoFG8hpnSw3
 lFdHW5CPbiB8CnP0Xf+jwdFfZuOsvxr7idxGyFGhhLc8VPR/h0BUJ0OH4l0JY3SLJMLq0KkjVCq
 I2OyKir/mWxCdVwHSjO7UrlGVTf1Z3AHKXBx612f3B055mCq/HEFlDA5M3BEFCzcz5LgwylEzQC
 +mQKLYHbUfoKNeXxMzXoIhAdQpls15TFDInYYJDrx7RF3Uc1SMs=
X-Proofpoint-GUID: HN8pMVDde9bNduW6TtOyn5FZhYBAK81S
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 422BB4001D
X-Stat-Signature: uy81ifjdzjejbotripuo41qwiiisy4uu
X-Rspam-User: 
X-HE-Tag: 1763746145-768000
X-HE-Meta: U2FsdGVkX1/WuAASj8wEqMUmdKol6+ynsexxmVFYRhzuWobYBOFLD0RUH8kTL8cFpB8eVF8Si656ijx/OFhFXPyPWg5urE9dxV8c8j/CyHwtmPkHAZFWTOMxvc/UhNzRCo8vNPz9m1KN2tJQTGBh7dZU4Sk2FEFaeLXVzsCs+gbFe4y7Pghca6/Nesrtp/ICUdIlOvqSTxJ+H4EC/tGrXR4MeLb3R+hkzFr4SjLCO58lV9cslLVxPvxUjjtjgvCQqKlL8lLr3Zk1Yn3+al9mnndAzpxr7m9+OKVlpoExl+TdXW+nOA/Vr4qkTkknGYKOdguwiN/BKWJzsZS4ZwrHdk6uxYdSJrQgrvEup2DBc4Hym5QZ/yXHON5IwOWYcye29L7tCb6hLCW1GbEwim30FPY1VcOQLBSQiMjMYQhIF18lrXXlCBF4AqZ9EeFIMz3EGgnu2HOx+EHimFvV7kBIpTv1n4S52ISC3zBm+Dr6rnZSY4sM//zYu2PYbphNq+wHyMKV0/6KyJjTVj4/hpZ8phqQoGdxewi9yS4v45AsAIzUpRVd+VnF0TXlzcYuaIxhZt/EsNgi8j+FoOCgapCoXndjjFliMV217IqZeCMrfjusF3lyUejMcBJD+iSyt8X17dztKexDMiUAaG4EAi+OrsTUpq7+ZUBj3TUTAo2B7fYrhsTf+vfZPBqE3aGJ3TtBh4ku284o++73J+SwVGMpERqgkHesGJO9WOV5tCel43LQHAbMx6R0RxcCVExQ7ceBT1LO340eHvOF/pJ+mudldGrzY4fxRShnXO1B5WyGm8Sgj1+LDT8rK03+XIBCRITvP16GGTe/RxRiaSgLHfWWSoykkSjue8/zDmijrqQM1GDdhKPVVY+H0EtQfewG92zU4Xg67jxfT+TXaZ61rhn4yiRNzp+B6L4VFWBn1sDjIG3wlSxTCoa5LR+RtY2LU4c8umUwZV3T1ttvrdUWHAF
 c8ZK3aL7
 T1XgQtgD8LtvcbRXealrsWiHFqNt5tWVy1saXneh3YNlPABrzqdBahinDFx9usksVfzOkbZ24k+/ob2Urtf5gmxUo9ZmUyzawHUlrVGHSC0V3a2G6wwIChQvpV8oj068U6+Rpc/KpXkhKamfIEakMdOB4I6n1jGgGof8Ntz7SSpORVA8ngebRpawjgOr3PJ8fgF7AnsKLf/FOpV/57UZcZqt8OfVfzAPFyM3FgL4jGhGToiJs0oFsl1VwKALNP3SoOne8cV0kT3zeVI9C1js6zV7aps0O5DiM8/XH6Fx49asOSgNXwelF3UzxF69PNwNSmobP9cdrg2alXZABDc185wshfGi2fs271/H8N29evAqK0Z5M4SYkl0iDTD8KNLeKBq7x6GhkGP+eHGNSgnYbXc20FPSclYG0AZAvm1LNrgHDyTGMyKBLWSMSy5IRg/r5M/Kg2Jn9VbokoREujb33jeOgSwwdY2ybSFZ53vcwePGCvWEbyHRF7prgaiAXBL+BdRasgVWXsaTLOev80S2RVwsX1LirZChRw8FEpNotTYLbPAMe4Qou98sGZ7AACfYa3zr0DOZI73RIboOK+e3tJkaP6s3ANCQX9jzWW9uOA75EljT440+Utw1fzqtDIdW5Hljo8Iei3/8fT9lwsOrAiNfo0A+jb8gqgaLp6zUg2FOyCi4qzbSYPT1qwvRjP/ETUsBsNYTkVOVcK8H/VVIEsAw6FtxEUXX2BMT7Q8Hx9PaZSWeUXWgGNiqMWOyENBEuVG6a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Some small silly issue here, for some reason I seemed to have vm_flags_reset()
available from the VMA tests when I tested but err, that doesn't seem to be the
case at all.

Again I realise this is in mm-stable so this might be fiddly so we might have to
live with minor bisect pain :(

Cheers, Lorenzo

----8<----
From afe5af105e7d64e39a4280c7fc8b34ad67cf0db0 Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Fri, 21 Nov 2025 17:25:18 +0000
Subject: [PATCH] tools/testing/vma: add missing stub

The vm_flags_reset() function is not available in the userland VMA tests,
so add a stub which const-casts vma->vm_flags and avoids the upcoming
removal of the vma->__vm_flags field.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 tools/testing/vma/vma_internal.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 37fd479d49ce..f90a9b3c1880 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1760,4 +1760,11 @@ static inline int do_munmap(struct mm_struct *, unsigned long, size_t,
 	return 0;
 }

+static inline void vm_flags_reset(struct vm_area_struct *vma, vm_flags_t flags)
+{
+	vm_flags_t *dst = (vm_flags_t *)(&vma->vm_flags);
+
+	*dst = flags;
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
--
2.51.2

