Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33423CE7B0E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 13:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92CAD8E0007; Fri, 14 Nov 2025 08:56:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD288E0002; Fri, 14 Nov 2025 08:56:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72F4B8E0007; Fri, 14 Nov 2025 08:56:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 555AC8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:56:26 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0DB7258BA4
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:56:26 +0000 (UTC)
X-FDA: 84109362372.28.C48B8F2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id A5BCA1C0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:56:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=p1irbOEh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=z9NczmV2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763128582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUMKclVBzx2EOjepMV2sCiOsBxSJuoBarCMKssAsb7I=;
	b=0lqL/5hwi059DU/IPFDByXsv5WvpkrCIN0SYXHcor/Xr0SKP+uFHHWrq8ECD8wV7OGqhOS
	Sdo1yCVwKVw6Edc9M3AV7d0hByrkg+tgvgXX3UUiAELfswg9rzMKRmwP9IcToIPDee8MzD
	B6nANGK8TOFXks/rdfeeGCjwa1z/cFA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763128582; a=rsa-sha256;
	cv=pass;
	b=NFjoaKVDYrDjHB1pjNN37IPnY4aG50EaW5+6PcETf896gXfBu0oRROjGILppD0GqExshGs
	Abnv0LaGdwnFFjITx3Au1VuF/t5O2ZeZT6KfQkfnHPmbLb8hIef6ZjFKvdiJOXyHFbRQl1
	jhijczCwlqpQm5JCS0/foXp8WWpwbWc=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=p1irbOEh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=z9NczmV2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AECuMjN009348;
	Fri, 14 Nov 2025 13:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=SUMKclVBzx2EOjepMV
	2sCiOsBxSJuoBarCMKssAsb7I=; b=p1irbOEhyTmgmh6SocQ/3mf1Gx3gUo/NgU
	BItfVzk23QeN9qiAs3sO1WniOVBh8BnZvpJgr9eliZ1mOKdFQDkhKGs8dBh+ED0Q
	w217asY1iIeWsQ1Q/Jl0rD6TDHWGWROoogWaDNxPR+J0ZA7eOIp3kYVkfCVd6Lv7
	JKHaJnyWQthcrjk7H15sitF+A+zrhiMGWxLUTd5Ch2x6memey7Hqn9pYZfeVeWOb
	ILxA4++CYJ8AJHJXzYXTLrqMFB5NUWc5ob6aKoa/PbT9OGwILCe/KseBuZebfiGw
	YHfdtVhdDZuYY9k631VZu9XJUqnu7MPD9s4LCMyxLgVUuhcfcypg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4adr8v172e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 13:55:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AEBmPmd027830;
	Fri, 14 Nov 2025 13:55:55 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012030.outbound.protection.outlook.com [52.101.53.30])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vahn3k1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 13:55:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rr3q+rHd2eNTYotjWH8gVrxlL5311ADu7mRTpTd7q40nCQJHJ8kLxlVwXVvuUXxfNT03xJtqhOdKFi8RnIuhJ1OhrN6es3aVpC+4J1FZhNvONd7T7ENV5LS0v2M8Xn/17OQcpTUL3Q/qEqZxidIxVHf/c9XOTAqBTN2VApVlYt3IPsdJrn1gU+GWc8eupXVSFjD/rHH3WikGBbtBeqKDYtUJL7O8Hbsdhf4YDC7OHYw0svN6G8HHbWMvsEZ9bJcWuweY7dRBh4NBPICwj4asuLFBVuzJAZ8bst0OXcSuv5otWj4oP+/LSgTkrGb+NdDSGNgBiToUUXmxZzm/3Y08PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SUMKclVBzx2EOjepMV2sCiOsBxSJuoBarCMKssAsb7I=;
 b=BSasAoR20BIhGLRhmFb1ThSQbMzMY312/TRZUM4x+oCHN6o3xOdjxD598m6/SWSdVEcB5ZEsJaYZ9qKX2Iu7ZPOXD4LK1yEXl6JC48AmBcCu1Zei5G7nPlovz4BD8nNx5o2C/8RB5z4Yi5BR2U8gmV6Xsa6+fZJ6VT+KekGGp7dP2yiBWQr+oTjxA5sGTkftdL9qIgbEb7OF+afjZzeZgGB7JxJLMUafvlANqAag3I5BHqtxONJJRF3jt4VpDFWsV5foAF48lHoYhWc5vGOcQJ8vC0a8surufjJaFfb1639xe99pBVIthG6KdWNRX2YsfaRlCKvQmWXGMOSyIibXYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUMKclVBzx2EOjepMV2sCiOsBxSJuoBarCMKssAsb7I=;
 b=z9NczmV2vS82yJtk0RMd86NebnNBKQjEQmHPioUxZthE3aijWhVZ+T3Kh9ra+vLYWAAO6S9LwRTWSRyxwOIqX1MlAvsm9KmWKgdZe6IioDS6sBTy8S8M7EodU+UYcr1OuIMbmGTVc4pqEUd5qVeQ0YVda0GdU6C716867XeFh3o=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB6594.namprd10.prod.outlook.com (2603:10b6:806:2aa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 13:55:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 13:55:51 +0000
Date: Fri, 14 Nov 2025 13:55:48 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
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
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm: declare VMA flags by bit
Message-ID: <e98d913e-71bc-4b58-95ec-8ae054c43120@lucifer.local>
References: <cover.1763126447.git.lorenzo.stoakes@oracle.com>
 <6289d60b6731ea7a111c87c87fb8486881151c25.1763126447.git.lorenzo.stoakes@oracle.com>
 <aRcztRaDVyiDO7aH@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRcztRaDVyiDO7aH@google.com>
X-ClientProxiedBy: LO4P123CA0326.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB6594:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ec35a40-9529-466f-b37e-08de23858575
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AdigMA8AMn4890S8j904qz+v8b5gLpFJZoMp83HmlKj5YfbSjljYQ9w54c/5?=
 =?us-ascii?Q?ZQpTk8iLzi3E5w56wsBa6EkNXv/kGdJtmg8OPVao2Al3eFPkCbIChWmSkTh8?=
 =?us-ascii?Q?4XL5cLczQkky9bPPHp0lOJyTB2dTk/hkH7G7mQEU5xlg8O124+xO6fNGh2Pu?=
 =?us-ascii?Q?pGz0DqtD3zY8qjyy+O4a2qA8V/4h7Ytvg43lC7o6OGIMj2Er13HelHoOh7D4?=
 =?us-ascii?Q?v7x3NyrqtW3AKWpdGMky1y9JHjkKzdwBzTBdt8yNKib4FsL+rCqOcJatHBsE?=
 =?us-ascii?Q?VRdJ01aMKHGVSHp8kKiEwkJB57iQpb0KBxYS2jY49hRKXBt5E0xtKtvtdbOb?=
 =?us-ascii?Q?JwA7aH429MAFcnTDr0F4VNZMvf5Los4qYcpW87LGWroPW6KF3kgBXYg1nqoY?=
 =?us-ascii?Q?VrcJzTL/BpC0CCxRsjqyPy/ee+xHHzpLDDRfJwwXQRuCLKvyNj67Ltwa091M?=
 =?us-ascii?Q?Z9rAdr/0rdNGU18yTZsSWf1g0ijrf7xXG/R3+N+oAd850jCtekQHq7Ijo3uh?=
 =?us-ascii?Q?HnyUkM7SmqRJzZVi+RuwR1g2pBcKGZhGNlGPa0G1AxFgJq2qRPC7LQYoAOZy?=
 =?us-ascii?Q?ZLNexOkYpAekpMXyq6upO+lLW4mTjhKb8W02RBjmRv25dDBoi0kk6YH09wKt?=
 =?us-ascii?Q?jwSkd6DVNbOE88uk3XXve/sRyPPDUu2l51t2mfz0ybcFSJ8ogNmU/G4or5Gq?=
 =?us-ascii?Q?TXlnqSpMSQwxsJW0xvdfnjpg9lLinMPnB0/rJ/Vw1jguU1TllbYy4G0rWGjf?=
 =?us-ascii?Q?36B7+rYU5KQMMqwwf0O+SLnODgiRs3XvxL7vAQWqz0vGlp8A9VR3IYIPCrug?=
 =?us-ascii?Q?brqQdvTsBt9yQo7xjPSiJJ7U+cb97YRJI27CyDLj9W6JJ7gOasNS/tEc1cOm?=
 =?us-ascii?Q?tZhA2QdSeLroRGxamI3t/wKUef18AhPT1D4agzxeEo2g8Ole/X6X/9b78BEm?=
 =?us-ascii?Q?58U5ud3jDeA846+HbG8ND7T9W6PcF5/eAtm4DSFTowpGIhlMzu40xNr8Jm4u?=
 =?us-ascii?Q?fKSdU5lGh7Wh9Wwipv4mlseuCCVL1Xk6X+MFB/IEgK+6k3waflPhkkFW9uNM?=
 =?us-ascii?Q?7LFmiZ7EbyBlNrN/QqADUzePemPQwmWhdF/6t5ZXCJykzAy5qtUystVIbOPU?=
 =?us-ascii?Q?l/wuqdFjYxId6jbp6fA7tFlnVrHSwyVi4Q7Z62APRz6Bmfwpah2oFetHavic?=
 =?us-ascii?Q?vcR36MwC4BipkYvxjF9kTv17U5lL6HYv/MHUqYTrEcV6FcGjPFDJwQy2rb59?=
 =?us-ascii?Q?R2SnPlQSnnJnGT1TQIXoObDdiLZTQIh01UA3i9XQJqh2U7rfRl7j1bTkFgdZ?=
 =?us-ascii?Q?R7EZFl/C0OY0p8up4zlrN4hO/lokbZh8UyVyzfxN33cfUG1EeqoO5ecnCD/L?=
 =?us-ascii?Q?Wsp8lmGWpzkHlXt6EL1ZJOj7aPneLqJw/wYHaqWMWV27h8Zzr5+/wVMcN6b7?=
 =?us-ascii?Q?2m4E0yvTLL9c3xxms67wUSs/DqCFnJ0y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p+M093dWDJcwos180ZupREIXlrvScta9aWlWXxl3aKJYFOeAAGW6FdF3tamP?=
 =?us-ascii?Q?5ZfsBmK7YZFTwbF8dYa2NoO/gEYxa/MG6hffid+NcxY3wWoDcwJZMXB0N+z3?=
 =?us-ascii?Q?EiHGh0g8GvzG1v1nBMoaHzPKWHAbhjFtBJ0VW9xn4Lv3HuqdKw4GY1Ff5jv2?=
 =?us-ascii?Q?bhYZBRtFlgMeDKPwewdXEbJEvdgjXr/CergoM2sJud+DKkSTPnvNobwZWyy7?=
 =?us-ascii?Q?FNb/b83RpLByBQMzHE4OT0+jSefUNtjSpA/pewhucGhFOERAk+QzlT+AEgd0?=
 =?us-ascii?Q?CwweXqqxNfUasjaKRzaTd9WAWrnwKwZIJ0zAHMz26vKivGuImvcWkFBdn3ud?=
 =?us-ascii?Q?psYM9h5frLE5SV3Ghoq0A5hB3UwJZjCIMKrO2/WFBIa6sChcKVEFfMtIULyi?=
 =?us-ascii?Q?opel/VN2xUr4KP8ndviEjPyTJ4C2BMHMyeAETidLKSQ4VCpG3xtE9uHnamWQ?=
 =?us-ascii?Q?0AoAOAsP+x5wbZRmog/aTBe349RnbAXFbob3c/f1tUUUVGg2TfVo5K0pdk0p?=
 =?us-ascii?Q?EuTgc0KcpLM4XB6PF37aDmL0i2SrJVygly4ECi0Msi0sMxFn7OGcRmBzImF8?=
 =?us-ascii?Q?1KUTfNjc6SaQhbfLRjs6Wj5aZ+JgbcS3+vXVSMI7CmWqWlbRN8DpmBFv85VJ?=
 =?us-ascii?Q?2TlK6UqIFDZE/KxJKFmEUXfAYS1OEi7xCZHrnCy450Xnz+1FHCwzf/NmPIJc?=
 =?us-ascii?Q?HaiAZkUKMpNBbMazHUIMluN3ZTX2sLHpnX7DixKUQzTlfMzNTB/kTm/P7ggI?=
 =?us-ascii?Q?Y4NoJo3N16Bg6L1tUUW4B8Gne+k6tXPAfLK7Itb5ZUlwxGjMBRhFihfm+J06?=
 =?us-ascii?Q?4mJv8Xo7pCyUlUoNwr6kGs/JC564eUj1iR4Cfv99yzJ5jL0u5DeGa3mHaozs?=
 =?us-ascii?Q?VIkk4TLyVtxjohlJbOD+CMSe1jTQoWHk3FPacpcBgQ4aM6DYAIXl3u3kTk2p?=
 =?us-ascii?Q?T9JjkikVzO407jgwbSzVQBW9R+ECEg8thtql6GCnhviyjToC3umT32SA+dLW?=
 =?us-ascii?Q?EpnQMrKt8BikBVWPA9v4j1wTcA6NlhCfIGlz8+cvYn/sYDXm2u57aAizkQ83?=
 =?us-ascii?Q?in0q3Obt1EWsGqsUX1QCPttZrW7eAeOcyTFWArXzV7o4mm8Bygs1G9/82sy9?=
 =?us-ascii?Q?4M0+LS52EAHQwxu3EfHC52/+izbqPTDLF0dfRVSVxoJyJIgAsFlOtSWmM+fy?=
 =?us-ascii?Q?c3MQuNhUrmIYadiRzHbJO1BktPyyHUCyVHDfDEhDnWsIwX+E97K/7eghybJl?=
 =?us-ascii?Q?ZmFwsZuqyb70h3nqjBw0KAz0Gpw8MPzq19CRnSC3aF0kFUYvp/SVeW3PPl3h?=
 =?us-ascii?Q?2P5xH5reTZ5Mzd6Y+W5VPc4ECzqq0zyLyzxqndGf9SUMAfDu/NJ1ZfNwcVDt?=
 =?us-ascii?Q?X4/BBPhciiqegC/upecsX4BOFvuCrT+QjTQjsbSHNMaSlv5aDxVYqgjrBqGf?=
 =?us-ascii?Q?ZSL2aMJdCcqW+7JJHrqiUYxe6CZvCGQ8mi9Oho5jhbrbh0kiVXhkGkmzOqS8?=
 =?us-ascii?Q?kxqCYDdQdlQ3o5usI+cuUrsW/s3KTtnB29RAlL1rgXFd6PicSzyzEKqrg2Xi?=
 =?us-ascii?Q?8dKi6NOM5oG7sHJjB71yasWlg1SVyFNoM9GWgvTooUIsMEZzyU7cbaq9tXFE?=
 =?us-ascii?Q?MA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	krUlk5SOaHYE2J5VTDkL0N182ZQJYfnsAKL6IKQ/aJM/xqCWK2L3FFIkDyqc2b7qSuPJV8gKTBOP3UtQzCzktCYQYgVY8tiN61DmFeVFcOdQqc0sm7xltztBU2OkE2x8C4RRwMw5s1Gdbe8CWsrTyIOf+sTidpHj+GRqbrDgcBqSx3gDhnO+waVohO9HqeebvWI4ZhWApEQZxt9DjpQ0rGnkhmtO0EHu2QLhk8DGX0kpCfyPLzmHIl82zV8hj+zLLlTs8pDgCqu3blf6rB5pyor3QNgTmG2ZHthV0sePkJrlMAvXGhwA0XUgmM/uXCXvLuiomew5KmuKmKXcQ0Nh+grWBj9DY8lWGL+LdWJfrECX3OLICdR4SS+phVHpGMjXe+xzf9A7nVw6w81wYmKK5gRGVY0wiXvygUIzUREZ3QgF4GScio1pEHjs2ijvM+kVTqsZJ2FJReljbHDQrVQkg/VopLLFOxeoMBWBJ4lqskF7ix3yoPAFMuHyK8uYNqlZG6pR2FWhJNnBJvJiUlp+xqNqCNqhd0p5+6Md8k2Jc9JWxDhRybbr9idbBj4MgD9oI2y9/3YKN8xAuG/19lCqSdGBumjovA/WJBskwVbMCgA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec35a40-9529-466f-b37e-08de23858575
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 13:55:51.2075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oIwU7S4UrU2gl2vzoLK7vdgVAi6cuPr42ZlH13tEk2X84qt+ZMCoTk3prsVHVa20EONRrfK2PtgN4YnPzCVGgTC9EbGe5ygbL57wF97P0kQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6594
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511140111
X-Authority-Analysis: v=2.4 cv=YP6SCBGx c=1 sm=1 tr=0 ts=691734eb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=LCONacxMZmM5ZyJIYTgA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13643
X-Proofpoint-ORIG-GUID: mtF9EFMoVsT8cdqbeEUGaRVXIL-OWEuI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEzMDE3OCBTYWx0ZWRfX+OeQe3iebGpO
 NlskpcPpVvj99gNmlbP/2E5gfxyVmLdwiQOINVIlzDG2G12SOwaDbYcQQxAc7uwmnlzhA0ympdB
 eqxBhq1unxwtfbolh+Ylnu8qPs0/SwLQ1gxVPsUAk+gBkZJqKDvc7TNTdGLrzwqBAolSTux9pKf
 zoCfJBGBq1Xs/5R4STE7jQoN126IVrlilpRFd5JdNbMG8pUBmj+6etfdG/3uh4y6psBz4/ZQs7W
 ZMAPsFJfjrZ+0gtvZSuyRzkPceKm1LRO2E+NBXBv22f10+aR5G4ReMO64eYO3hY05FOBf4/QM1g
 +wk4pg1WeYUmgtCqbjDH27X7RGtaIqiq20O8pVY9erpansGQLoPmXnGIPsTJlkAwt9kSeT6hph5
 k1Wzc4nMMEkf7yYwEYo+eQyqyKs5f3PkuBrqazEELADD2Xdd6A8=
X-Proofpoint-GUID: mtF9EFMoVsT8cdqbeEUGaRVXIL-OWEuI
X-Stat-Signature: 7w8ozu8f7yirawtd5poszim5eyqatie9
X-Rspam-User: 
X-Rspamd-Queue-Id: A5BCA1C0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1763128582-222879
X-HE-Meta: U2FsdGVkX1/8tJVr1Ac9V/hhvr2f6Ev5Bvq/XGrPvzCOR9a5kCumH/teYmtWWgQQ85CkzTkwvxQz5YqqrF3Qf701cejeXcWGtBrtKotR5PA/SZLuVS87XU4VLr4HfxzOnpqsraSjHY3vWcjQ9L1DDql0J4pYWJNB0E1//S/9k+w1L3jSbNpOYHIwXwWTX+DX2vIv/WU70e5eEx3gp1Q8u61xxGjNf66jKUpG7lU0NkZHPSViIgmGqouAZaLU01p3DyiP6bd1bOQRee3d1bnavE1y3IlaveQUZlr1mTDwept2VCrye0l5gN+RAdtMdveHPcJDHPqyZXkVVuJVEabCla2qJdoCU5eu8d8dOyO3krHL6iF06/32JWgdEN278ycbfQ8Duz1VWaqFErR/00hfX9l4omCOaeUc8XAoL3eeqMSHyAfPqvRIP6JZbRlCRdvM3e71BKz5l1QiuYD7wDF2zXsKlRWB9d2X5EWC+g9pBDjx0FkSvVQkBJlKpdhozRIOKYAdeQZBAZpQyw2Fvmsd8Ki6IfDtGW0rKwyst0Oq3JOeTz+nCRaElad0MV8dwoUDAlGZjXhnP7VmivumqZcYaFWq7MpfCGeAmkRqp5v78w7sdPEq10V5izgJRbhlQc6eH35HcMWU+E9PxY+J+Ucdn6R1Zhj8RRSreKxlUNTHGihy/dD7oIiNAxQn/ioYQB772lwi0RxKaCBLbNA2Lmmfli9soF5QEwWJJBgCgA0blYy/Exfl4RYsGgLpqV6oD3zI7/zkVq9CdK7cDsP4kC98Ty963x5uB+Ujjt3EHa0Y0E4W/5tCpazGy5F21TuqIjUq8g2ZaAM6PXWs8eQ5l+XDmUjr32faV0WmGUxwscNvszTCyrfkHg/4GExfbqQvRBATzdQXaMkdcvSJKhySzVD2WG5KKrzqUVmXl2jcjricVf8231Pqx6NO3zGFkzKXjaZlH4GDaNeV3SsQRAWgWKN
 7LXXm0IG
 xXvAyuJv3anTKKbfKVF7YbH7YVD3LZoUCi8bpmeErHi2T8rt21cdY/1LPafkPOi5cWwP/eaSm6T4sxf8yQre/NVv8rJ5kzcYP9y0RqCeS8KdxrqYnOxnD4BsOLdsERvRlmATv+eA06FaLSTuSwvfcphWWsdNsm1OWo8vX2upbOwo0WXRv+c18QZniDMts6FGH5ezIMqdaHh5A8Kl0QdHvxwDFIUY2O4pZiI+keQ9sO6yV5hIg82qPEug+5Qrs7cQfUVzjOCEZmGjrr9g8Xyotfe38GGHtJxOI2MlFtBnbHwgoFPFuaUHaNjo/LrVS7CdPkCGS3PsrNd76JzDKUpMN5tAQqCVFHGDUftQ03j4R3F6YQ3WYuE6dYRw43OInppxKETFzM68YeDVpXHaiRo/fLPWMaQUabvuFiIe5ZRshFrJMXZZ5xTqnqqWIGdUgISzB27u+P6zaTeRpmmBal1T+zrb4z6tQTUn/jQC2xap/vCq/MMwtFbmhfrecAX5CS6yZXhmiLIM/JIDY+DBNngUrsfCaYng1h9rTHW8JTlR6M15NGD4wu6n83Vs/oywoz0tbM+Cqf3yHZlovUbZGCZcC1BnIeJFsHlhC/CAxIKfvMPajiUu4xSBc4vg8mpL6s80y4FiZnSdJ9mTF2pXQqn60BHM7wpb9SDmq7odNQaO7G2k3vwZuzazttgMme6D0vXH0lNsQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 01:50:45PM +0000, Alice Ryhl wrote:
> On Fri, Nov 14, 2025 at 01:26:08PM +0000, Lorenzo Stoakes wrote:
> > diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
> > index 2e43c66635a2..4c327db01ca0 100644
> > --- a/rust/bindings/bindings_helper.h
> > +++ b/rust/bindings/bindings_helper.h
> > @@ -108,7 +108,32 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
> >
> >  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
> >  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
> > +
> >  const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
> > +const vm_flags_t RUST_CONST_HELPER_VM_READ = VM_READ;
> > +const vm_flags_t RUST_CONST_HELPER_VM_WRITE = VM_WRITE;
> > +const vm_flags_t RUST_CONST_HELPER_VM_EXEC = VM_EXEC;
> > +const vm_flags_t RUST_CONST_HELPER_VM_SHARED = VM_SHARED;
> > +const vm_flags_t RUST_CONST_HELPER_VM_MAYREAD = VM_MAYREAD;
> > +const vm_flags_t RUST_CONST_HELPER_VM_MAYWRITE = VM_MAYWRITE;
> > +const vm_flags_t RUST_CONST_HELPER_VM_MAYEXEC = VM_MAYEXEC;
> > +const vm_flags_t RUST_CONST_HELPER_VM_MAYSHARE = VM_MAYEXEC;
> > +const vm_flags_t RUST_CONST_HELPER_VM_PFNMAP = VM_PFNMAP;
> > +const vm_flags_t RUST_CONST_HELPER_VM_IO = VM_IO;
> > +const vm_flags_t RUST_CONST_HELPER_VM_DONTCOPY = VM_DONTCOPY;
> > +const vm_flags_t RUST_CONST_HELPER_VM_DONTEXPAND = VM_DONTEXPAND;
> > +const vm_flags_t RUST_CONST_HELPER_VM_LOCKONFAULT = VM_LOCKONFAULT;
> > +const vm_flags_t RUST_CONST_HELPER_VM_ACCOUNT = VM_ACCOUNT;
> > +const vm_flags_t RUST_CONST_HELPER_VM_NORESERVE = VM_NORESERVE;
> > +const vm_flags_t RUST_CONST_HELPER_VM_HUGETLB = VM_HUGETLB;
> > +const vm_flags_t RUST_CONST_HELPER_VM_SYNC = VM_SYNC;
> > +const vm_flags_t RUST_CONST_HELPER_VM_ARCH_1 = VM_ARCH_1;
> > +const vm_flags_t RUST_CONST_HELPER_VM_WIPEONFORK = VM_WIPEONFORK;
> > +const vm_flags_t RUST_CONST_HELPER_VM_DONTDUMP = VM_DONTDUMP;
> > +const vm_flags_t RUST_CONST_HELPER_VM_SOFTDIRTY = VM_SOFTDIRTY;
> > +const vm_flags_t RUST_CONST_HELPER_VM_MIXEDMAP = VM_MIXEDMAP;
> > +const vm_flags_t RUST_CONST_HELPER_VM_HUGEPAGE = VM_HUGEPAGE;
> > +const vm_flags_t RUST_CONST_HELPER_VM_NOHUGEPAGE = VM_NOHUGEPAGE;
>
> I got this error:
>
> error[E0428]: the name `VM_SOFTDIRTY` is defined multiple times
>       --> rust/bindings/bindings_generated.rs:115967:1
>        |
> 13440  | pub const VM_SOFTDIRTY: u32 = 0;
>        | -------------------------------- previous definition of the value `VM_SOFTDIRTY` here
> ...
> 115967 | pub const VM_SOFTDIRTY: vm_flags_t = 0;
>        | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `VM_SOFTDIRTY` redefined here
>        |
>        = note: `VM_SOFTDIRTY` must be defined only once in the value namespace of this module
>

That's odd, obviously I build tested this and didn't get the same error.

Be good to know what config options to enable for testing for rust. I repro'd
the previously reported issues, and new ones since I'm now declaring these
values consistently using BIT().

But in my build locally, no errors with LLVM=1 and CONFIG_RUST=y.

> Please add the constants in rust/bindgen_parameters next to
> ARCH_KMALLOC_MINALIGN to avoid this error. This ensures that only the
> version from bindings_helper.h is generated.

As in

--block-list-item <VM_blah> for every flag?

>
> Alice

Thanks, Lorenzo

