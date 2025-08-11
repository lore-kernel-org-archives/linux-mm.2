Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B18E2CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55E5E8E0017; Mon, 11 Aug 2025 04:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50EE08E000A; Mon, 11 Aug 2025 04:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AF688E0017; Mon, 11 Aug 2025 04:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 231CE8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:37:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E853F140731
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:37:41 +0000 (UTC)
X-FDA: 83763823122.30.2B1AB38
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9F19020003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:37:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KWmLdYfa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tO9F2p0s;
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754901458; a=rsa-sha256;
	cv=pass;
	b=b9udWLp7+7qGuIvPHQvB5ohdoQfgFN7bvH4BlHATI87g7lT4Jywgctm11o5XDAPnG0v1Lk
	RJ2nE+xAXGiXXCpNML3gB0mPv00YrbPjJpIx3JZvZJrbTkLlDPYCDMZh7zel+drjz6hL7R
	Jar1Er7HF8n40Yj6J9b9pHcUWx2sKgA=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KWmLdYfa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tO9F2p0s;
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754901458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RveQkbLBMmMC1UC1ACnAmC7AzNS8IHkWHeyeoYnCwds=;
	b=7mqo28Ypp5p8xQyE93blSewwQgSdWej6s5rAmi3a2z2A/rSwD01Ouppx+IykbCWsL3ny0L
	D66SRnoPlz3sFbL5bJgmNyHN263UnMjYyay6h8yzm5eJfp8P+KlsBJoLyt1ws6VsVFUpSx
	K9r6glEtGqJHlDb10M286a1aZ5inVEo=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57B5uIVB015118;
	Mon, 11 Aug 2025 08:37:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RveQkbLBMmMC1UC1AC
	nAmC7AzNS8IHkWHeyeoYnCwds=; b=KWmLdYfaaQC+yNTZVKdkgQ2V/XcpO5vuxp
	hNwB3A/I5UDh05X03xdcMTgg8KmeIa8U4CMvWCGY3zSdfa5WynAmF97aEJaFaQ88
	C1QNOizHjD1yDuwQScrOzs0Vebak03C94fYHympz3OSszdOXCk1rSMaJarubWn0F
	MjnAgoBEN5akjvW/ENfeKSBL4rAXE4Yde2USizCVGJq/nq6iFX9wJT5Q9lzwWMRW
	BKP7gJC+nP7VNjAl7rHErurcuMDf3SYOclUpxBtEvrRZ8ULF3HgpjmVUfnYwp+mB
	oNDJ/qsVTwVw3bfUswXlRutngNbQstX8N4DhTZsZ9Pb4blkDr1Fw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw44t1sy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 08:37:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57B8CPW0006485;
	Mon, 11 Aug 2025 08:37:11 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2066.outbound.protection.outlook.com [40.107.212.66])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs84e3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 08:37:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yafpcwLOw926TojUf9vHxYKYrtkb9ZbRDu52yKRBeL2geEi+tGTDqLJQMb3CiXtvlGGtKZxo7I77TFKgOnKJZHUTrkTFOMQ2iGaVl0Lqi1fMalo1UiwULfDKWhxml/zqXIl5hxV8Db1qYATjpS6f+gYAN5/qWaT7KIB+eAkfea52/tkvlNAVub0k+HbM3afS9tcN2xfwHUK2X8smwZ7CeuA4Bmvf+AhRYFbmefrg4yQ/kL+s8cmxly758IG+t3LZgmUqVIwsBoFVIbu/m3NK5lvMCwJI//A8y0Eug0H8L1r2YMwGkPiJ8fPKIfimpr0spGxXFFa2f6ANPyfA1qOCJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RveQkbLBMmMC1UC1ACnAmC7AzNS8IHkWHeyeoYnCwds=;
 b=rwLud9PWZHuLzrJgjjx6AL8GagM8gNRZka7n4+4HyxmdikLJ0A62i5lrLNTPfnqTZEXG8ujUd4LLxzQsRvS1zZO2jPHAZYDTq0X54uTs1thahYvcF9GtpmxOcAJ8gkpAcrSUIe3NNBsK0OvPHwpICSW5z3vmmhwjsoHwJd76vI5uc46OLY/G/UbZglCADDpeI/kXDcFv9BZ40hk++R2pVhLNacn8minRqYZ/kOgfCL05vSTiKkjQL1CBi1lla4VN6k6HKfr9iI9IS2Tuj1Q4CIbXUGfbzu9NpIUr03ZXVqw90vhPF01zDu9bc78EDkUPfQNOYR1jbe2dhW3RX/di7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RveQkbLBMmMC1UC1ACnAmC7AzNS8IHkWHeyeoYnCwds=;
 b=tO9F2p0sQqP0e+vneldakjm5xdca5tE9/MJV8yjmdoeBruWSQk73+MiL3/u846/3ikVfgotp3va+id5vbu686ah9gUljbrcgF5ISX110i3PS9hgzvp22ixOgieD+IrsgN00vP6gJU6Ctu8DvosqwUTyRoB/aCNsxDxfYbVlUmJs=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH2PR10MB4294.namprd10.prod.outlook.com (2603:10b6:610:a7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Mon, 11 Aug
 2025 08:37:09 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 08:37:09 +0000
Date: Mon, 11 Aug 2025 17:36:53 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Hildenbrand <david@redhat.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kasan-dev@googlegroups.com,
        Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Thomas Huth <thuth@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kas@kernel.org>,
        Oscar Salvador <osalvador@suse.de>, Jane Chu <jane.chu@oracle.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, Alistair Popple <apopple@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>, linux-arch@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V4 mm-hotfixes 1/3] mm: move page table sync declarations
 to linux/pgtable.h
Message-ID: <aJmrpaeKKeNCV3G_@hyeyoo>
References: <20250811053420.10721-1-harry.yoo@oracle.com>
 <20250811053420.10721-2-harry.yoo@oracle.com>
 <aJmkX3JBhH3F0PEC@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJmkX3JBhH3F0PEC@kernel.org>
X-ClientProxiedBy: SE2P216CA0069.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH2PR10MB4294:EE_
X-MS-Office365-Filtering-Correlation-Id: 86da49e6-8ae1-455c-c61f-08ddd8b2426d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EAqD6QcUv931WFgh2M79m91rJn+ok1eprd25QjYOzO/Dh4VoiU9huStcUw9+?=
 =?us-ascii?Q?3WB5Yyat3A/vHyKwQzVRbkiIAraKpVBppQrChBXSR8YVjG/lY49kvIfErkCK?=
 =?us-ascii?Q?DAw1PnJBfiGFvAcy303Z2ljM+Olo0mB8Zpq2I3kuGnzIgLbUHWqudwh1mr6w?=
 =?us-ascii?Q?KbmKijiQy5Bn6KpWfwrU+3jLiurH3Eu08GUs6iMkcyrVANYdBHLtHcX0m00u?=
 =?us-ascii?Q?ksYvilJOUnidqhtatntWmoOs52565aUi5CTOK+gFWW78FTbzVgI6CrOHZiHG?=
 =?us-ascii?Q?NKGavKrDZNst8FAIjYrNoeBkmDViK7gRpC3kQKhXl+s6EDgildXzqHtWPVmD?=
 =?us-ascii?Q?EYNJx1CWH0RYw7YOGaD53z1pmo3LJuXuBCoUg/2Fw3+/LMgphtljgnMQolIY?=
 =?us-ascii?Q?PiPpegKcVo+Zhlq8j+22NYwWEFCDvwMA5C/UAzRN7UzkdPhbGmtddSM9mBiI?=
 =?us-ascii?Q?I+/AeYYpW3wen/WnOwJFwDABxvV0HEGkzjuJo6u/DlABJi28/fzoveROJVd/?=
 =?us-ascii?Q?ZQcGFSnnpRtx1MPbuwxUzMt4oJzRq4PLpm4BmPpxXZij6MG+GqWXZPLczpGx?=
 =?us-ascii?Q?+0tLtvIN7Dq6CBpcwap2x48JYIr1Z5fMtEXg3UbuaWu0R1t7C4HSs4jQr40L?=
 =?us-ascii?Q?7vW0MSyuMySAbz0rR/U19jvwDaHNJcWlEnYraougY0RRePhMO+koJtukv504?=
 =?us-ascii?Q?kQA3Ub7zRaCWLa+OOUzQekYSyEr/sjAb4NjWK3kIp9Ma6PZm1LehalIW4N6p?=
 =?us-ascii?Q?kPswJUuojjNEgqXAd69IMQzzQw/iyefKc1Xd6Nv5cy6pN8lgfPKqaw/FuiY5?=
 =?us-ascii?Q?zBx+Mz1EqM+q8tzYEWLtwdvN2chQ3VPOOEG9cjScRPSEvMF6PS8e1gt4PnO8?=
 =?us-ascii?Q?AQ2kjKa/dOwP94123TqaFSM3CbglVretWIhFEfgXADfXrDYtp17oG90YJWR1?=
 =?us-ascii?Q?oE9NkmuEdpvEOHoFxABjpqsxpR2WW3YNR0evheqsZbWiDdh1bP3j01wzoSCw?=
 =?us-ascii?Q?vhT3z/TS4aM42oz2m4mA4RBSodphcKG8eQgSQGNat7GwmuN/TogC6mEsQlWS?=
 =?us-ascii?Q?VnC9iN15hgsNHmPE5OXSX/JPM6aDfue9WbaVC3vzaCJ/igTtVc7Nrqa2PBwl?=
 =?us-ascii?Q?fOkdE3zzYOqYZQyuj4Y47CJO21jiSDQpMFichbpyHnW1fnihgp+gXpX6WVMO?=
 =?us-ascii?Q?x1+1l/cGGj77T1DkJAULDySp791ZYB9nnS24eWolAu18k0tfoYRwLLZtCg9T?=
 =?us-ascii?Q?e4Lq51i7pQGatVp1UuEUcevM8YgvEEPSvu7vb0hlhb59uo3K2cDzBqsYbt4O?=
 =?us-ascii?Q?epDtboCWKh1WXP23ekOKThtWBVk4GiDeejr/KREhDWmvkStTr5yFMzuvx99a?=
 =?us-ascii?Q?a7NIUOTT/HbWI1urA4W/tEhjoOeCaRVWjS3c9vV4K3brpXgG75UU1gd/CAgo?=
 =?us-ascii?Q?AossnFkz/7I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?82sve2IIpUEWfZpFUOCGP4tM8bVuijhIkbh0tQOi1PsdgJ5fGEIMdX0DoK5p?=
 =?us-ascii?Q?xYusDHgZpmJakJoQKq3jjclwUOpY/DrPfiGDnRsprZIXa3sUIIf3Cb8n8XcY?=
 =?us-ascii?Q?PLxuNBeNh+EzWZXxMcuWEOvYRq4Omla7ylyRtIsBGSctXmESjvsJiN4bRvD8?=
 =?us-ascii?Q?5SlQCY+eF/f5Akgy1W4igKyXcRz2hPgeanMZxdyNECbSg8+PdQ8wf2wgJ7m8?=
 =?us-ascii?Q?qaSxz7pYX8eHz0ea1jhKedpWttrJjfCS3Zh1RF8/fEHPqVhGuocQ7Ld7bD3w?=
 =?us-ascii?Q?S73OuJiiuuNM+E+53IrubOL/W1qD6IaugaEniPSPeQtid7I3adSLyY/zy10H?=
 =?us-ascii?Q?F0kqdSGuKG/0jL2cP0V2ow5zBLo/tiV10Gj8CzR/d0NHsjcdiv60Yy800M+H?=
 =?us-ascii?Q?mOoNrLwjkllyMZpHXzCW5RhIScuiDQP/N8lEDMdrIvPg9gFRjh5Ce23uHctG?=
 =?us-ascii?Q?A3dj6dIpi58twOxIA+LIVyv4E6FcyhUWpaRujnczhG+UpcPrgNfJoCeNtChM?=
 =?us-ascii?Q?IT/TBabf5JX0ynLeSRPAp2yMXJyUYjPROeafnGiH1b6twxweVV3HXgjDGNrn?=
 =?us-ascii?Q?J7hzjf4w6pb6WPVw9+BN6wppB34/asshYiuf4A/hGIxfDv2UuwVuV583vZv7?=
 =?us-ascii?Q?XTvu+AVjdpK67saC+Py/i/hwVeOmaxWxjSHTPpl8fsEObS9t4LXvN5P9fHJp?=
 =?us-ascii?Q?kZfbaSNb+0d3+xWYSZhzoQSsnG69JPXN9YoM/c5feEfCVBFrjpvUgkrHloZY?=
 =?us-ascii?Q?jHuiKpKFbWkiD/p2yqhz6rCb5Bje6mTOiu6oHDJXoYOxSuPfZUbmMd4BKawN?=
 =?us-ascii?Q?kO4TJlttJ6a74gdn9DjmpQwh1qeb49XQ9PdW+rrBGn1JKJZ2xNeqk5H7qdkC?=
 =?us-ascii?Q?csphpOAcKWY0Zs5NXY0Wbb/UzQv0xcA3rScMDwemctU4lsCNoJOwlKBDjYJt?=
 =?us-ascii?Q?v6GEmQFBN24FEdjTW1LaN4DPqMaXZveKKf0HHNWuHpVB2NcRQXLATvn70Kk0?=
 =?us-ascii?Q?I2LHeAuErE1je2QSuNX3QgatHOHbp/+pw8EXMwn5xuZ2U9Wwe7xKlTZnyHKh?=
 =?us-ascii?Q?H0TpRuPCBKLCcxZ21AAVxCFqfjax7ATn1yV5VsRBvjwuaFmQRWBVaOdqbbTK?=
 =?us-ascii?Q?i24MR8RFJvPkmsCul1xCwnT4h86GYZd1ML4j2gGmDKDGBQZuclHZpcx/U1ED?=
 =?us-ascii?Q?042DDesh2CNSsAN8XVsZ26jSQ1jQ/pDWRoBMdPj8KrT0CyrwX/p9XEyqV8m7?=
 =?us-ascii?Q?A0pzPoZp4hLryeI6O4zpLLnkElj2yPsxi4ITBLvXljm7//kCBbZ5ONxDQ5ES?=
 =?us-ascii?Q?KFSZ26A6QsyGWjLBNJeqQFg73rFXIz+lar791NgcQ2X8yNxGw3yvgFp58B+2?=
 =?us-ascii?Q?iwx2KbP9em5OjKuE2VXzVOiSEf+yJoHNTx5AeDAvdw5Wr9yFExM6mjPP3Kt6?=
 =?us-ascii?Q?HY1FrfczL2H0aXBPpXxvdOTToiVktK3NBtJBJeeycA/mlmMV+1GEqPW3iTbz?=
 =?us-ascii?Q?q0lSXp2Fs9zo5HdpP3X7yIVE2Oa0rgua6fFbptq+KtMIXd8wsGyyVhb1wcOK?=
 =?us-ascii?Q?0TrUBE+rc6SOYb37gjImR9ODCfVmri14HAMJFVks?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5n4l1gttv3sTWN9ZtXqb/M37Op0DSgOVHNX1TfbrjrBXuzZHwrizZuWR0jThswZuhDy2zfA6LDWCQf04trVab1+mXm5kQBt5qH9p1rzgK+N5xR/LFJSL9iqdUmmduW5+06EDhGHJaVXgISclBb03FsTJDSh7/He9g/NwuBhSbL4yCBRcS5tUyT5DdqV7mhQ5HJR+rWkMAJaZIS9cY+e9rzckaffMa4MNiQLa0I0KSo4r6lFmodB11xvpB5MLgFMeEGFliYzb8F7KwGA6TiahexWZnNVTng7JvOdoRh7ztUgJ2qQrbrOZltfk5oP9HG4uFzjWy1cY728hylVLJkD6j3T7z966Uc7+TZyZqAQcU3YGi9r76QFhdYkJxS9APcWIoLQBtpwZDdlyiz/PH+aolZEtuhc2sXYbZrzzkE2WVtYbiWkBvWaNT+Ugvt/fcn0fG0ULVlGAfIH/yP7HbFigR3VwYoGbGndOHzLG1oH3/YzlR2rE0znOOrgkgC2z6FXuUa8mR85bpISCncjqg3W/zz6NFFuKIVyMeOe6n0BGwzv0wWb63jUI18nwvjn4Je3RLPu2yO7vIf/kDbWmoTpTspj+j1FjEn1LO+VYyqkb6Pc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86da49e6-8ae1-455c-c61f-08ddd8b2426d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 08:37:08.8625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f1wswrzIWQAzUFKWp1jrGF3AC/yhQ/JZm6akFI4mIp6q8Efpju0k+oKpkuLpLiL5LpImOhP0V0mvGoehEwksrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4294
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_01,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508110056
X-Proofpoint-ORIG-GUID: yJRF1irmpsDlkPU_Io4wztFoYDrjOWZB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA1NyBTYWx0ZWRfX4opqey4dOHCl
 eXYSrshiIEHHGwHQ2SVPt9B/SdHvvBFcHhTWP1+Dn2hr2pAwGa8KxtJ/k4eR8i27smA82f5PP1h
 SlGWLWpFRMRAZ83TNCMP55y9sf2eYns3nfZoUiwLEqPY+Ku2zViJsp2cSUGP0ME8Lja3ojXzP2s
 0JdIN/dDrafaExF+Cwb0D0cP5Jk5xMddr3Q2DrcM5SqKOXX+ltWCFIxwUBFNU6uHWS8ln7kX5XN
 qveJ6Ko4vl62un8bJcKgE5WVNtbOSceAzdWHmKz5vd4g4xqJKKBjh0Pf1a/JRstRCOuitp5G3Gf
 bQOBqHCXoGlvgZENY08e4KzWJU/1Jc52uKrC7Ax8Hkmo6codhLWu0A5whNDMaY3dk3AdeS1ktlD
 VVdd3nXD970JKBcn8J/3wdh2RaeOxy1Non9n/g/U3wmgMeVpZo80QN49+FhbTzZFRxk5ZbHS
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=6899abb8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=0DxuVrdH8SgwYDiYD38A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13600
X-Proofpoint-GUID: yJRF1irmpsDlkPU_Io4wztFoYDrjOWZB
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9F19020003
X-Stat-Signature: 8xyq7b6n3xtpy6grws6fidze1ydpsjay
X-HE-Tag: 1754901458-942214
X-HE-Meta: U2FsdGVkX18edsXWaFKwQNWNHVYWh2JHl2+uHLBeuokSw83oTKXHMhpqEZUxmgtEcEzjBelvEratl0ni57+Wufk8NAxyHZzFVPrzpoini03uwy691WC5McdrVuB6z0sBeiWVYrk29l29mwT7LIsNXdSWKuUaslTrU+aYC8DfC/xyW/rToE8XugaXNjrOdUCARmNl051mqMGykiNZ8yN65kIl6GT4xhuCdBD68jyLBH7zUZo9c1B+yuMCEIM4t+WerNsJgaoJxngq1qvlKY00ap0N26Sh6XATrMp3anLI70c3SoiVeoCoPJGBsTxOsyBOIiXDa399lFoVYEimvxzcyNO9ONoB1Ew1iocAR1Nsgdwv0ZPDsUKkyLKUT6ayPvb9La/Fm4xqTT9J0AmrKS3frKyKG9xLZw/SygGoWIRE9R6OsugbB0V/iFAUUtawvDTSJr8EjOaSQ3Qu3FZMBDotrcaULNcgSb9XSBavIBIyTyT0UTZ3YTD4ZXa/Cl5PkfLE0yTDmfLvJzSbEqTqStPcXGl+6+N5glRSCxoKMfqGZo6vt/PvUIu2m+Jmro4iJpYNdEYIcr0IxtQu322a04wWORqpBlaNFf6sTW4N2VzNBIAECICitApiKHlUg2HRknEjj1zzfWpyw75k0izt7BONioRrK/pTx+7MJ6qd9m/4DquVMDZbH+i/Ow5UwrovoTEZxN966j3G+rey01hc2EEVNulZObe5k2UBNEjkxj59euIgU5Zz5ELLFcJujOzABV8NDf1hRyQonhW1nmsLNUJmMi9KcE05SZK/BMwPX9vb24yvCb/FfbxmEKlw78hzuZrMhIsFL7AEWVRbci1+XZy5LUDBR0rJrCCp82LJ6tg3ozA7Mr62zfpmNpWm20mVWEOA5cqWmioCmkebcydBZyvkvJipn6I6Bz23G8BrVQabM+uPcZ74xu58txeLZmIzAGW2YSXp1C7XuIfZrP1gXfp
 Fu52YxJ0
 Oy5lwAwG0ZG73QfZFjFeJ0poyAO5oZMGb+u9vgFGwUwfud7qa+MXFafaIEfqSMhGVaMZ8PNUIuGHOq2B/UevpUKAqoegWfIumRIvSIL00KyZyaZIl6L4RSroFFVI35wGHOhuWI4TLbEaxfDxn/k5ObTXRwgrjEtbQXp+njkmYKWJTG1Zuz4hPs2qFfmCzRRyZ+1RL7FzU0ZUk61LsuW80kVzk06HNeSQGK4hyvndP5QVSZOqrXuZS1eU5zN57gdQ5oJZOALJYqV8Onc2YsWkNZZyf69SQ/i6lL4J/LJzixhbt9V3GKs48J7r36fLWrsY8GKwsWHvvesCN4ikDfh+St9LnSmC/5zb5F+xFwrMw3WfXFkHt4RVxeKdmDkCj573uaixZl//RT3enpFdOKpZxWlUKHKjrtAn+dGjdMx3nUGUYat/G3I0tW70mBXjkxxMaFmZi6UYlw/YW6dcBKMVCXtxepvxO8SGImUiv/wEDVC3z+lg2gWjbtc1T2/p6pvvCw3LLpwscb9JZBasCG3OmMB2G4oSac9qq0miWm3CBkk9WURUcGGz/HcHfBK6HUUExnl3ztq4FAcKceecAhDUA+olCZcIeJYEi4B9ebhmGtdEvwkcUC3+TnRNahvqDNRiTDs76ryUsDzlnVJY1rz43vf4TqSsNzLQ+fl+2I2PjURoZaCoGw5p5pAwXi42OhgcYk130goh0LHRH60dHiI4ta4nNWt9L54GwgvQJrwwxLq5svAS4zmbUOY4xqqxx0+z+4NTBIf2cVc2k3iwnYhXTbzOxkiFYwGIlcnfXprYhiJtHLDwdufrHsKh6oK1qGADMguWR90Pf5ui6+Zi0xWIQYC81tJdMZOZB2cKcrrsDuanzqP7c0zmPVkGmF5gfrgCxTmDQsic1YxMMwvOQmmuh5Nc2jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 11:05:51AM +0300, Mike Rapoport wrote:
> On Mon, Aug 11, 2025 at 02:34:18PM +0900, Harry Yoo wrote:
> > Move ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to
> > linux/pgtable.h so that they can be used outside of vmalloc and ioremap.
> > 
> > Cc: <stable@vger.kernel.org>
> > Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> >  include/linux/pgtable.h | 16 ++++++++++++++++
> >  include/linux/vmalloc.h | 16 ----------------
> >  2 files changed, 16 insertions(+), 16 deletions(-)
> > 
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index 4c035637eeb7..ba699df6ef69 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -1467,6 +1467,22 @@ static inline void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned
> >  }
> >  #endif
> >  
> > +/*
> > + * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
> > + * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()
> 
> If ARCH_PAGE_TABLE_SYNC_MASK can be used outside vmalloc(), the comment
> needs an update, maybe
> 
> ... and let the generic code that modifies kernel page tables

Right, and patch 2 updates the comment as it uses it outside vmalloc():

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index ba699df6ef69..0cf5c6c3e483 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1469,8 +1469,8 @@ static inline void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned

 /*
  * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
- * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()
- * needs to be called.
+ * and let generic vmalloc, ioremap and page table update code know when
+ * arch_sync_kernel_mappings() needs to be called.
  */
 #ifndef ARCH_PAGE_TABLE_SYNC_MASK
 #define ARCH_PAGE_TABLE_SYNC_MASK 0

Or if you think "page table update code" is unclear, please let me know.

> Other than that
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks a lot for all the reviews, Mike!

-- 
Cheers,
Harry / Hyeonggon

