Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84246CA0EDC
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D40516B009C; Sun, 17 Aug 2025 22:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9726B009F; Sun, 17 Aug 2025 22:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B43956B009C; Sun, 17 Aug 2025 22:13:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8797A6B009E
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:13:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 487C5BB4A1
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:13:48 +0000 (UTC)
X-FDA: 83788257336.28.1C1CF30
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id D87228000B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:13:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iQQqOTXS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U6LruWY7;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755483225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7QMCU6tWbOxm94zFQkovMYQ7C3m1XpCNRwTdxMxF43A=;
	b=eqPuO92FTp7EM0rfQl1yXQpBOirrZmQimjR0Nmgm2LMQZhzbCcbc62zbqATC7cEI2KmFEJ
	ROi7bBhohhUV4M9SYe1b/WYcti6wtLY4oBSRnSZ9qRzxF9q8bqYgoHPmRLCDCWrPsgu1Df
	HhS3DbcJgrs0cOQRq1nZfvehm+iPWtw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iQQqOTXS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U6LruWY7;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755483225; a=rsa-sha256;
	cv=pass;
	b=TLUnfaqPadFm550fLvdIeCCKF3ZYasH7/iVvyg9j7K+ygVI+DvRAxGNpG6YC6s/Ckmm46u
	LVa47BnZ1CFjWDuaSM5I8TNPQeYNfY0O52J6WN/k95CZcCSj/iOI93UPO5NjXkH3otepCU
	REOEe2YqxA5166KEfu0sKFfcV3Q+gOM=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57HNU3W3029042;
	Mon, 18 Aug 2025 02:12:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7QMCU6tWbOxm94zFQkovMYQ7C3m1XpCNRwTdxMxF43A=; b=
	iQQqOTXSgrolq7C9dY6Jh05pkLNp7nKDBKPtP6ikYmaS1rT3vPl1e1dECdC5NlS9
	/P6wZtX697nUgrl1BhBalUT98DzCTAvBa4R6JDZA1OVu9T1dKg8/uwXzltJdYOoW
	d0hGG4pbeAppueZQXQQ94KN55WsiJuT+1yfwAtdT3WaXS+U+X00Ai8GxS6ervmNG
	67ruhzER/uopdGAWnuQw0PQKbnK2r6p9bnFKrrDhrIUa9cfvSiTdCWaUKQEgawOf
	pTPZ1UKzf4EjPJlCtb/Ky2Cr/2eM2glrbR71/9zZbqi7lc13WPaIdnnlZP6+fH8J
	NNkWOXhhaIObcfqVz4EhhA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jhvd9xnf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 02:12:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57HLlWHH040164;
	Mon, 18 Aug 2025 02:12:55 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48jge8u1yg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 02:12:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cEQ1QmtFfa2Gxug82kyU7UVBjCYhdUAkD6XbhGoadc+SgVlValbTozZaOlpBosSilKp5Y4gR5j5xmXdjjh/mC1ySwNVnzeJgi8l9sqcQTGqOia7SppCxJo+2rwfRMKyHSLIdjtavYCbwALrH+sF4meA+n6TT9ZhapIXf2xTPsbkFj4DmQyT6Jlw0C4qOEoZtOdHw59Cyxw5bcBM25r7snKrgljUcAv+gPjMbuIpQBwNWUjdH3ddRTbhrxKFMvTK7oaO898LiE64vh45fJuUKdYE3HguFJ+i5+XB9HhAADtHUF1Uln0D4+6lssX5h36U5MOjjvdnV+8AecLULQAXslw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QMCU6tWbOxm94zFQkovMYQ7C3m1XpCNRwTdxMxF43A=;
 b=cWAMpz6Ka/+MOepH2XhEx6Koo7f2yP+1Z6JvLmuhigzTUTLpAdB4q5tYlKwk4P/KSwCyFDqKWsoemtpnlcSHSIP3+VMvIbi4P8BnU5CAZY7zM5EBfdzCx3+qNUrCx7KpYD+f02qMUI1esCec3dgfCNBj/7rKXdINlllyY5p1i1Qi5LRW4XEL7FCldjNBD6b1TQ2dNfy8QAjsY0zQTkshnbAsdT2jNtRFc4A9o6V/GYYnedLKvjtIzJm8vzJrFk6RbqyfVj+Wi53TqZGj9HXqUHZLpF9m+riOKDtCvfGH1dnHcax7T6ABfGEOpIb9cqK59oIWyroKviCRztuhWBdXUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QMCU6tWbOxm94zFQkovMYQ7C3m1XpCNRwTdxMxF43A=;
 b=U6LruWY7W8sfsdiMHhDhBnBsnG6i0Z48HJA/+r+5msiimCL+7+X7p+dkUrE2+kWhCY2rOsm4RyEnGDRdyhv6fBhSNehUYix/IfSwFVIiJfOAkyqnmbAsf1t8wO+FZCATVWrV+RwSTQTgEAxRo+3/m7bYUi4VHVwWjKi7DedMdyA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4690.namprd10.prod.outlook.com (2603:10b6:303:9f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 18 Aug
 2025 02:12:52 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9031.019; Mon, 18 Aug 2025
 02:12:52 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H . Peter Anvin" <hpa@zyccr.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@gentwo.org>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Juergen Gross <jgross@suse.de>, Kevin Brodsky <kevin.brodsky@arm.com>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        Lorenzo Sccakes <lorenzo.stoakes@oracle.com>,
        Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@redhat.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Ard Biesheuvel <ardb@kernel.org>, Thomas Huth <thuth@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Peter Xu <peterx@redhat.com>,
        Dev Jain <dev.jain@arm.com>, Bibo Mao <maobibo@loongson.cn>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Harry Yoo <harry.yoo@oracle.com>,
        stable@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH V5 mm-hotfixes 3/3] x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()
Date: Mon, 18 Aug 2025 11:02:06 +0900
Message-ID: <20250818020206.4517-4-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818020206.4517-1-harry.yoo@oracle.com>
References: <20250818020206.4517-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0047.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:115::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4690:EE_
X-MS-Office365-Filtering-Correlation-Id: f13d4e32-9870-4f7c-2ae7-08ddddfcbc46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bn1nJ35HSGbSG3NvwMsmij0a1Tl1KoSijSuF+DH5nwh1o5miHCqZ+r3LnaYt?=
 =?us-ascii?Q?wanOxCbo6LTTZD8KcFwQZ3LUkW9bCe8AGlyGFW9Q7RuNOxt/C9/W6xq4h7cm?=
 =?us-ascii?Q?NptBmPPqyIa8ERV+drZGw0QKYmjdNOK51iBoSU/QN7WqNuU6xAjEOZDE6gWa?=
 =?us-ascii?Q?DSc/eeVXhpCANlicrECS0kjh0qdjzDX0ll5l7erXYEA/J+KPz6ezwLabKcKM?=
 =?us-ascii?Q?ZxfGKr/6ICeCReHQ005xWrRF00M3YiSOJ/e8CrF8TRvojh89Wk4w57c+UDI5?=
 =?us-ascii?Q?FMKQR8OWoEwehMHrfYLgIVCWST2b/puMb44VBz3tSM6Onf9QVZGTV/Kre6BN?=
 =?us-ascii?Q?NQUTueWl6S91fd9breu5FrrlSEEr4STAM/bWwaZ15gEmica1J/ptcg4BiqvU?=
 =?us-ascii?Q?sbNGfFjQvbt8PE7JS/y2h9/sPQtw+mVUfsfIxiEfPB6UYrZnc1r3iHYkkU/b?=
 =?us-ascii?Q?Ka6ZHInsPExEZwjZzBXini+4abwJOMu0sUVZvKidjC6dpRrP32AoQ+5iF78o?=
 =?us-ascii?Q?ioGKdXYZoGhEQn94PvSZYlbXDNFywdip5tfq3Vit58J9bhBbcUFbpBbu4eWa?=
 =?us-ascii?Q?mOwQ/hLs20tF2MYfiVy08TOyvDSGqEQyBwlT70r8w4iEDcgu9bW+aiAkkwb+?=
 =?us-ascii?Q?W2WsW9dKEvlcQqwjRsqNmROUx1cslA3kueiHoHjjTfQFcM6z30vfl9bmeMOR?=
 =?us-ascii?Q?DAzazg16vZu4TJmYRPbp2TQwI/E5C+O3zcMnY8xLDRoqR09E1c+1X7JKl5Vd?=
 =?us-ascii?Q?NdKyaePbpOj/n/K3ESrq/VXeHF7kZAfs20kCUkgVxeqCkkzUVh2yMbUrC8dt?=
 =?us-ascii?Q?wyA/+S14Fx6ZfxjHCBqgrr0aQHsIO3b/WIo7AzTO2mwysd7CHROShevA5ZYI?=
 =?us-ascii?Q?28ZkS5DcC75t4Dro87Mu1TXGL83sRWu4mlpDkJyXG8EDCZCB8P6rzSl37Lgx?=
 =?us-ascii?Q?1BtimKssJ5pMVDJSCDsbZkq/vH7gYfXCNhipDo6i9UHWivBrHXpf5SMz3PvB?=
 =?us-ascii?Q?FDE97vlZg9jFQYyiO+SkrCIHsa4Lqn/foDUyhJPHEJOLibQEqOYDgd2lcqdy?=
 =?us-ascii?Q?AHcboFU6AfuSXaVF2t/dzMgml4JYNXxwKhjOwi50N+m1Yb3ljZMkWUu/oFt0?=
 =?us-ascii?Q?0AOdnzEzzChDrPQawuEJN9Vxl7kqaTeOm6tGWPCuzYvkKmv6HWhytdZOrXGE?=
 =?us-ascii?Q?PudedhNf6Cir1zsfmIdhnzBY1cKywVBD80n5JUXIw7FsWFhKju0bWrAcdnWC?=
 =?us-ascii?Q?gpgzWQLA5VhMMuajNV1YyXDCEFQWY/e7/dus5cwblpA85F8JvQVIQv0tNMWQ?=
 =?us-ascii?Q?Zs2Cfplabcm0yx2n5TVPhhxMmF1O+r+xyJ+7S59m3LHeYv6SHTMt4A4bz18x?=
 =?us-ascii?Q?Xzp7z38=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?drmQUIah0zvU2ya2gyFSyMg/O3QCoSODgzN2O1LhziTrZDdQXPJIhAvDQQQo?=
 =?us-ascii?Q?GoZZPTAOQQraPAmvHsDJxsTdUAJhY510aBKnq/6LnAWSMasAPPyq/RT5CbzJ?=
 =?us-ascii?Q?lPmBCe91wbkOtBYfO/ga93oqxcIA5SFOjDpTLY0u9zOhCxELnW3/LdyWTWc/?=
 =?us-ascii?Q?ODbW80N9Erthv3Ua2leLi9kw6xXJwx21BM5W47yDMZ+MNDzNMP1vJYRsISJ3?=
 =?us-ascii?Q?HkD6z6kKvJIttGR8z1OQXRcCw/NPWi4iGwvk6XkE7cdPIyIt5amQlkrZr6To?=
 =?us-ascii?Q?Sthc1/TJiao4/XcRDhooFTxBzbt1TcEvDr9ONzPIN3K2PjcJDUEJuuFNYpDu?=
 =?us-ascii?Q?+ihBDph27qD1HbnS01iXLbsnOAkF0Mnl7yZccWzP3yudtfOiyP1FvrSFU3Wz?=
 =?us-ascii?Q?MwvzrXM85EJybirAzpOn1hKC0w2wXOOjaFMyUftzArI6/TIFHXzTZwWL2TsJ?=
 =?us-ascii?Q?TQK5/rm/VEnLEM5Uxt3/C6T6AcRSTL5IX66z4H2MWssafH0BHxgk35S2tenB?=
 =?us-ascii?Q?8m4dMCtJFXByF7UNcb+aecOHK+UJ4g98eqxhwgE1yhtKzSPTnVrm0RKMSJlb?=
 =?us-ascii?Q?cflWxWO2Pj0e+rMTMYLl3jsnDh6d177ro2T+7LqJZmj9RCexbp2XHJvIfyeH?=
 =?us-ascii?Q?YznDgluBcQ5n2HVIzpAyn445KThLaZWGwM3zn9EJC2cpYE9pHUYK96gV9zwQ?=
 =?us-ascii?Q?RBqeDps1HkW5t9Ni0Mr291i6u4dpW4k1vOxLur1aXVGG64+nDQt3SgUgtCey?=
 =?us-ascii?Q?Y4zWiYJZqx1ZLiuDYh/9hV1xLLHPF5s+SFtAkXNeJxcccvX9vschM6TkHsyi?=
 =?us-ascii?Q?nWNWYM6YKM5JPBL4doxupnlx5Ith2y9CcDZ5sLfsBUX30iaOjaSQgP/kZQhP?=
 =?us-ascii?Q?fn519cyKBgX9rNLUhw0ZCQxwRz50fgT7np4Pztg7Ovo6LYl/OaxnUFnDPr1d?=
 =?us-ascii?Q?4WqOvj029d8kSxIq+FV5mIQ10LyAFxYYBothbdaNiybGzneLUmygATo8UIj1?=
 =?us-ascii?Q?XX1ahR1BJ8iMr6cqMeBOIWGOlvDRY9hyT0GlaXTklIuLLeXK8GrxJ4xkkHut?=
 =?us-ascii?Q?Lkoy2dxmvToa3ju5vBQ6++z46BUPCpy92m8o8QJv7+z3zv+8wt5VdlsIurX9?=
 =?us-ascii?Q?yByAoy7eH+Wp72+Ov0fTH14llY8AmjR8jTddSZvxo3nQPJJyuLOmtcsDXG8X?=
 =?us-ascii?Q?6B6n5vltvhKe8w2rn/4VXGLmmKL23Qsbt+LGIqiW3mp/k63DrOZQJZIU1qH7?=
 =?us-ascii?Q?DD4HHFj5bC/MCBnGuC5aaQQCCw8utJnEIPbwa4IPeEyLuCER4L6gMRJepyR2?=
 =?us-ascii?Q?t1cRB3Ytpo3VZxbYaDzTODtVRTg1HovHKYskCywoRZQX1b8gWw8WRZaZIMSX?=
 =?us-ascii?Q?2js0ydcyw0YsHvvK/coAMc/IzCRszQHFDMs/Hrqq/IdF3RfIxdNfwlWBNRew?=
 =?us-ascii?Q?AD2g//qjJL046ICGRKOViqCTMq3KIapRypXm6zbs6pbjGsJZaoq+fuAzzWMh?=
 =?us-ascii?Q?uTM0YCN44BsyL9jpR0OR37dFS+CNah0a63JqC5oGTl0ckO5UojaRZ9Z2rNyF?=
 =?us-ascii?Q?zjWGiJVuhoicgLrGy3Qn9iJbnd4ST4Cdq74ErQ/S?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ykEi9fD67nq89cytpvEFi+kXMFrOj0EZ0uJw/+Tnx6+/W5KZ85KHhqfy7o+hB8EoV2lWM+04cJJbWSRd2SYroxp2SoaaL9zy8Si0pjkMpdqchDJQNTgml3kZ57ROo72ZrO1h6PzGYT8K6ch7shUobte9h/jn//USBz33EKOr7xT06e4gM1lFoWgZ3e0VcRpvCIWoBvYiEbMh5OQzL1PD4L9kmXOsrPa6qwGdIMAHpoTw6UXSONY5IXSmkRs0hYHDT39QTlKAXItthd1yGoCvV1y1ZCDLCcHF3ofrXHdozykHpS372AC8BTg1apJmH2et4Yaqizuhg/GsBBhecs5chdmL0iazkBoAR45l4vIknuhALcA93FV8PZNlowTbbh12SSIMXAUvK27GYg8J+2/pLXwS1aWR9kqfs7AVYWlS/Eg9+za4NGOUKJ2BOVBcXgC9sH0ZePpr/5yKdKain7mmISR7Z2mJHAs0pjMOvY2AjZxdJLJRneOnDTBl1ee2GjIvup8SoMxAdvotLmi0eLmU7Pgvx5/Emq5j8FDq3YpoG9eWW0fB7M/DGqa1G5DIZG9UNVbIfR13P33Igl/uHRsFWWc+pGfBrQXa8UMBXLLQpyw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f13d4e32-9870-4f7c-2ae7-08ddddfcbc46
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 02:12:52.0655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDU0cQJO6HS/7MRBAgxwynONGUfBESwg3Y2k6uF+dqbF4OlsueVw3H+bmhWqgoe3XLm4JJuEOoct/KI9kmMnGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4690
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508180019
X-Authority-Analysis: v=2.4 cv=TNZFS0la c=1 sm=1 tr=0 ts=68a28c28 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8
 a=vcVFF7Jsdw0vqU_NxK0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE4MDAxOSBTYWx0ZWRfXyklC4Rqu9vcA
 MX4Sv7ns/CN8BWtwMSTj8cQ/5ngkDaaMI8YXd7IqEGYNE3UvdNp4daR8wVMOj/CqsPhlrs8PxZB
 tSYXxcm1n5D2YNqhYdBWU1Gyt87sEnKxA+erCVKs3odtaEVzLCWadGjNagO+8bPujnt4PSTibQS
 hUjB5QCJjw5gOk1p2MOiV4DQD0dQgM9UQxCePKpyb3E6/v2yrWmJGdNbVugO+cvs3WZ3O8PWaeE
 s4a0tIn9V/DQCnJyN4KoQw48qIgRNL5ZQ6x5qUOm8qr2O2zbMxlvSpSsO7aGP6uJQdohf0rmJL5
 0BzPMBqhjtwa4EElUe5qEE9slgp0LXoj53Fw9woAbRWO24Wyov1358wzzNN6lKOlpcFfwLtqbSe
 uQXjeRAbKLdJK3IqaiIY9mBkxpObZfZHFk1mdUrEV6SFSbSYu9zT/IhsXLwz6v9T7eLUxCQ4
X-Proofpoint-GUID: K8znfpKXwoAn-lhIKHqD7P_15AeNZQOK
X-Proofpoint-ORIG-GUID: K8znfpKXwoAn-lhIKHqD7P_15AeNZQOK
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D87228000B
X-Stat-Signature: o1h58wzzi4ww3sq38a66nfqfd9cxw39p
X-Rspam-User: 
X-HE-Tag: 1755483224-758821
X-HE-Meta: U2FsdGVkX19rvPwXl6ONJHb1Vgo2yYRLdTJZcRmoJlYFS13xA0kt5p4ogjQfboIS3rI2hfEcAsFLi31QGKuD+YqWxyXrFio+xn/3/1U8/vbu3hqIY0QjpN+32V2Zdt8PmeiGMIoWMgojW5IlORKo/ZSPbtjacEpMxksmCOVb8v9uXGR+4G1CisYVulIVlQ6mFrGjCoadhNKl/lH5qiL1Me8hMGAPk0iUQbaDFIPPH2XVp/5BABYviwC3A0XazETxl9C49IyX+BM3cZRyDlUA28I78YL1d5J4l73hYfi0kHTVb3SxqsVtVqSgCXKb+2Gi2e42ycZv/Va8feIWqoElaNYeI+UBjaPdjz6KQmIhOA6Pir0uk9j7v89iuZcZcm2t0I3whiMr4LVbm7wfjT6KZcC8gLY8QMDWfO3weMayt5vkfoFCitzPg1s3JBxkIciXuoYjsvrIgowq7iVeOC4DDYcy6LW2tzIN/HuHugSqo/lX3rBTeF/v2uxdwzBK/e7zUav0MEj6yb6fMT6CNs1K2MEBfAIfl08DeUgbo8xCfZ41Bdop8/yyGRhXjQ/2Lay5n2ivdAkzjt7lqszr/hSLH+1R/+1oPrpy0eB3xt7eeq0G/RKNNBU3vpPGrLU78SP3Rw9mOP5nwUwBURQvPAemBIEy5AhUckA5LIDXhTT1oYG9zHC9oGB1csKxI79/SgpsrkGJ8/bshGkMPKlytn5sYGtUKJ/ogG5Dqqr/W/PVAueSwEVZomJS4nv9d+jNkDnx/aTX6ZIpNF6JS5pmeKI8+4y/MmUPPGs1yLZ8BNsiV2J55UVhjvfId8qHY/B8LkYSv5Yv6mI4aEuVkcqlEvN9IF9qCydKOjGd23oZ0aETgZzLP/7SWsauwJJ1Z7edJ7dv9ppgM6DgD7Baf8sUbldfqXfRcm4GOf7B3X+utKXyWj6tUkPN2sdLx7GA8PE+hYqhSRCdIsM5bZomQy2gYl/
 0XuOIX0b
 f3QCPU2Snh964vO+wOQ6baqR1SOIB/u8JGyA/ZgPHA4X50KIXYUfJ3uCRnMO4tuEGM9EpXPdsj48flh1W0Ka1UQxDj+7DB9fRy0B1UGme22eOjHOZpBHuUT8PYzAZvdIlrdW3gyzQrQg4GuPfdi1KBj9relyT2VBg8MRSVTvpARzKyMT4v7N53FwD4nPJyRD+tL9oW+Ikb/pgX3q9lhLKqvnvRn5Q12o3FSZZi8Nf7uQXZVmkbiCCcy2kz1Gh7rew1FvBoPYVpno83bQpxW0XaOifN+xO287k/gfoUdFILVUiPsAeu8FfsBEmr3zmZWgmUkWpNCzCWPCKDB8hqXcgMHRpAzgg3udeEK+1OhUTqASF+2ZrkpPIl8lfTExXEn9OgyC4SRd8f6gAa3kP3mIv2cicXPWUUT8E0gfZojLblz5x/KOSndmtVedpDX0PKkDFG52/uMZK3Vd6EojgMDirZxkPQZkMHyQClD/sQwgaaOnkY6B+uPYrftXgocJAYuFSxV7m/lRxcxQ0TMI9c/3dbjhHPgFV9fl/a1Nl8n6sSwKSazP2u311gc++QwdZxqWJr+VyqXvRAlr5emNyR9bgLQXHjSPnQrxMNcgk7NuWby6eeHCdmRLySV2E3YkeXNqGN1F6SkVzVittpxogW89FUMnzb1ltMSVEJFjC2RZfO1fg9GaEDT3RA3MPEn21HopwHXp84utq7NcyY0/hmz1x0UCgzGUjP5/pytk9hA9QBaLsWYh8tXrAgDtx5cHwTZc+M+VjfrRDNJaQyKzIfKCIaKA4UzbWleRLp3GF7aSB5FgIQtw9AvWGrKvsAx6MYxgXFC242VI02PUIzxQBTRmSvOgo+wVbvEJSKfPzqphHIvXGPhBXmzDuwq+/l2ANpiUjrvMVdR+OKhKVtTQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to ensure
page tables are properly synchronized when calling
p*d_populate_kernel().

For 5-level paging, synchronization is performed via
pgd_populate_kernel(). In 4-level paging, pgd_populate() is a no-op,
so synchronization is instead performed at the P4D level via
p4d_populate_kernel().

This fixes intermittent boot failures on systems using 4-level paging
and a large amount of persistent memory:

  BUG: unable to handle page fault for address: ffffe70000000034
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 0 P4D 0
  Oops: 0002 [#1] SMP NOPTI
  RIP: 0010:__init_single_page+0x9/0x6d
  Call Trace:
   <TASK>
   __init_zone_device_page+0x17/0x5d
   memmap_init_zone_device+0x154/0x1bb
   pagemap_range+0x2e0/0x40f
   memremap_pages+0x10b/0x2f0
   devm_memremap_pages+0x1e/0x60
   dev_dax_probe+0xce/0x2ec [device_dax]
   dax_bus_probe+0x6d/0xc9
   [... snip ...]
   </TASK>

It also fixes a crash in vmemmap_set_pmd() caused by accessing vmemmap
before sync_global_pgds() [1]:

  BUG: unable to handle page fault for address: ffffeb3ff1200000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 0 P4D 0
  Oops: Oops: 0002 [#1] PREEMPT SMP NOPTI
  Tainted: [W]=WARN
  RIP: 0010:vmemmap_set_pmd+0xff/0x230
   <TASK>
   vmemmap_populate_hugepages+0x176/0x180
   vmemmap_populate+0x34/0x80
   __populate_section_memmap+0x41/0x90
   sparse_add_section+0x121/0x3e0
   __add_pages+0xba/0x150
   add_pages+0x1d/0x70
   memremap_pages+0x3dc/0x810
   devm_memremap_pages+0x1c/0x60
   xe_devm_add+0x8b/0x100 [xe]
   xe_tile_init_noalloc+0x6a/0x70 [xe]
   xe_device_probe+0x48c/0x740 [xe]
   [... snip ...]

Cc: <stable@vger.kernel.org>
Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
Closes: https://lore.kernel.org/linux-mm/20250311114420.240341-1-gwan-gyeong.mun@intel.com [1]
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 arch/x86/include/asm/pgtable_64_types.h |  3 +++
 arch/x86/mm/init_64.c                   | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 4604f924d8b8..7eb61ef6a185 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -36,6 +36,9 @@ static inline bool pgtable_l5_enabled(void)
 #define pgtable_l5_enabled() cpu_feature_enabled(X86_FEATURE_LA57)
 #endif /* USE_EARLY_PGTABLE_L5 */
 
+#define ARCH_PAGE_TABLE_SYNC_MASK \
+	(pgtable_l5_enabled() ? PGTBL_PGD_MODIFIED : PGTBL_P4D_MODIFIED)
+
 extern unsigned int pgdir_shift;
 extern unsigned int ptrs_per_p4d;
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 76e33bd7c556..b9426fce5f3e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -223,6 +223,24 @@ static void sync_global_pgds(unsigned long start, unsigned long end)
 		sync_global_pgds_l4(start, end);
 }
 
+/*
+ * Make kernel mappings visible in all page tables in the system.
+ * This is necessary except when the init task populates kernel mappings
+ * during the boot process. In that case, all processes originating from
+ * the init task copies the kernel mappings, so there is no issue.
+ * Otherwise, missing synchronization could lead to kernel crashes due
+ * to missing page table entries for certain kernel mappings.
+ *
+ * Synchronization is performed at the top level, which is the PGD in
+ * 5-level paging systems. But in 4-level paging systems, however,
+ * pgd_populate() is a no-op, so synchronization is done at the P4D level.
+ * sync_global_pgds() handles this difference between paging levels.
+ */
+void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
+{
+	sync_global_pgds(start, end);
+}
+
 /*
  * NOTE: This function is marked __ref because it calls __init function
  * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
-- 
2.43.0


