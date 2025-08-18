Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0145BCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 15:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E72D68E0020; Mon, 18 Aug 2025 11:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4A6D8E001C; Mon, 18 Aug 2025 11:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12068E0020; Mon, 18 Aug 2025 11:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC9488E001C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:29:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F20E1A09F2
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 15:29:36 +0000 (UTC)
X-FDA: 83790262752.26.D779D7F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id CAA36100006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 15:29:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L2nQ9pgf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rpPWDt2d;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755530973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zI9tmdqoDdV9OmFtiulvBaDRZ8l5DWWaWU+3L6gUzT0=;
	b=O5Te6JoZ4dHGUJcUrceeDr+JPLnuzR5FzWkpZ2aU5z4EKGzEWuZIfdn3lCunqWhhyJ5Rdl
	Rcc9sdLanNdlIg7vgre0XwYWQYjK7LBM9BClyhvFJz/T6B+qHjoay2fVmE8kbC4KyPvhg4
	3DlVadQnHe6+CwJsq71O39z5wv7yCFo=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L2nQ9pgf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rpPWDt2d;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755530973; a=rsa-sha256;
	cv=pass;
	b=dGx5itY+zM65DxHlW6+boWKJAwzvbJrd2LY3TGjoEp5+j2CnoKZydW+8qN5iQogUMBTpCx
	Rxou3alwYChHiRfBHctuST1M6X/AF9IiljqBvSvsQObUr7SyHrcLKJO/Apy4Fil5QXjOtU
	4tGBVdLNCriWb5HpNtBqHVtXZo2Q5hk=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57IEtn7b011021;
	Mon, 18 Aug 2025 15:29:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zI9tmdqoDdV9OmFtiu
	lvBaDRZ8l5DWWaWU+3L6gUzT0=; b=L2nQ9pgfLoJXVWXNMNKYH8OnEKkfKU1m0l
	Al21ZMwBSU7mfeaCwsL8pZ7s02gIhzy2tG8einbVWafKXpOGoK1wGIrIEerl3ZFR
	je97CPZO5ulIUnQQA96nqBMlVRoWI7r3hGrvEZMWwPf4eALUWxHIWDhnt1iSG1m0
	I5QDSqZGBBLdQ8RZrYR/k4+KCFyhMNwGj1PLiFtX2vDf4tvDH8FpRpyJ+RolZanQ
	t1OCBT6Ypqf8nJ3r7m3VdtdIVQGIh6C/od9KYV1UQiEfciopcOvXhBHFqN4DrLuw
	mW0s48RTL30bHDN4bAfR+NjH3FITOAgGTgxHcDFXj8uW6mZB2LfA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jgk4ke84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 15:29:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57IEtjSD010456;
	Mon, 18 Aug 2025 15:29:13 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010035.outbound.protection.outlook.com [52.101.61.35])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48jge9ds45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 15:29:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d1QnYtg0qkJZt/Pph0JgqHMAMBy1hjG8OpilZil2wyK+wdDivzg2hN0oG0/ABZFqs3i1izEM1olRVpXR3maE1a9dnMLNn1zaOtLigH3lNGTi87Ti1MVzS/bbsl5w9ayqFUK8Xm1Kh5Y5BrJqmCp45OvRl1DCbkWm2BGWzsAEeJwi1617BTNF0pDENPAQ9ucTV/5voqkT/MZ7v6g3wgfJDFWUdXBtQ4+ZgHnsGOxatq+dffEt64R3zj0VUviJcGAWy63Ayj9JWoUROXD/DRjiOnfnCl64HGMfdYF3QtKEMC+LE4jicVE3Nijr78Mecce9y3AzYT9rJT1IPJ5E/4RQNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zI9tmdqoDdV9OmFtiulvBaDRZ8l5DWWaWU+3L6gUzT0=;
 b=tkIrhgjeAqj4qAHUb9X9i4rnQSqVNumC5J3Hko9Nyotn9IbqHBY4UI1ngqtRuLBGoi7cwq1J9v0Dzl2riDUvdBDgRfDbJZ9oKDt1U2US+0puzHwSCrIpOnXtplF65toM8Eqw1hOJ+PHYU1IZfTmJfOAsYXlPuY5HxzdUdx4kwWffElUBKWGze+AkvM4lOn+yhGpPnj8xGANbTLPapj1OWAvVUz89PZREqNUnEAvN5pen5jdj5kG695Czw12I+ILNo4XOP1z625iBuU2GepOisuX9FrFYrzNNEPyuzzoH8k3kPElGuhumsUh9Z7g2VF8uEj4ID6QgJKFNt7iL3eoF8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zI9tmdqoDdV9OmFtiulvBaDRZ8l5DWWaWU+3L6gUzT0=;
 b=rpPWDt2dV1rKFc08uNJtBQIRNXnEmitJbPMsCB1i/LPZxlkzb6Z9e4KYWqOIsIL51HBz0wbTf9pD+fr+augLEg3Gaud9wsg8QJ/xOZV5QB4niiJhwqhYntpGqH71X8FEFJDP6XgahcxezV4qmSPbAa5/HwJwk5xqR7Bd55vb5UI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8020.namprd10.prod.outlook.com (2603:10b6:208:50d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 15:29:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 15:29:10 +0000
Date: Mon, 18 Aug 2025 16:29:07 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 6/6] mm: Change dup_mmap() recovery
Message-ID: <2ffd00c8-b1df-4040-8c4a-592df935df21@lucifer.local>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-7-Liam.Howlett@oracle.com>
 <02d9e99a-d941-4ad0-b75a-ef8251fffeae@lucifer.local>
Content-Type: multipart/mixed; boundary="gfo65tvpl26qo2qr"
Content-Disposition: inline
In-Reply-To: <02d9e99a-d941-4ad0-b75a-ef8251fffeae@lucifer.local>
X-ClientProxiedBy: LO4P123CA0012.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8020:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f49ad04-73bc-422a-c13a-08ddde6bfa5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|4053099003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dgUByhgXxNdqwAPkxhki5g0Iv/OUHjsM4gCtsI3/kpaIQ85xevJapMMUQ8jU?=
 =?us-ascii?Q?yEI89haNX7HHyHM+rlH1cN4wf7d9C1m6EF+WA/txjmT3SpRb3HrD+M+Wwkmm?=
 =?us-ascii?Q?NQQlDLjs/G590tp1USdO4OYGwmHXX4sIwVMCC/wYSVraeImVi2Rm1F9VZSE2?=
 =?us-ascii?Q?T5g2RyMUGlMSJXMzxMGxbuvHezFApDpMzu84Nkp7c7ulYKhOVGvkWDwPNYf2?=
 =?us-ascii?Q?JmnAV4qSJYXngdE+xHAEMp9cfD8GszAdqYqt30z2Awu4oL51NjcVyb4TIg9t?=
 =?us-ascii?Q?gPYkrw4oqBhtkp/QoGwbZdSbVRegATUzFybU8lL/bGHVezQPwU51ESBnb0dL?=
 =?us-ascii?Q?40fFzrmW/YrBmHnkvxN1aAhbm8iJ51ncAGT0vMA334U5Jdl4PMZool+vei7x?=
 =?us-ascii?Q?TOixB80gFuf18xQpXFvOmAsb6OR+G/Wht16u4IZGm4kxLlJ6QmvB2s53Xbk2?=
 =?us-ascii?Q?8B8J9E5Uu+bmPCF8VVf/QpFkTzOY8u+wUDVc48QYVrOsxWXlm3Ic3ITWvgxA?=
 =?us-ascii?Q?h79eJxn3FtwSLf/n8G0YkXyg31bT0CI91NLXe589Fu3/wZskUsyrootCEX4o?=
 =?us-ascii?Q?j3SakFN1iqYSa37VgnQZ14+wqKuM95C3PM+tTJ4mIHoLxoCSt8+0SdSToet/?=
 =?us-ascii?Q?mGlRsM/4w0K4UIkhgsnlWhpsXfW9uhjDsBs7igN7wuF3+KsS8g9EibIQkBEQ?=
 =?us-ascii?Q?7jVdkVBAsh5ROYBKeUlO6WLhc1n8Mf80sEkNBtS6ay+b6qDu+Xwm6SjwrA7d?=
 =?us-ascii?Q?Z00AYIHxHwJjggm6559Cz/hNveMRlWdxznQNqjlje+yz2II+Phw13r3r3xFs?=
 =?us-ascii?Q?6s4y7eaIdK4ZcNHpx8GG//ypyhasHLbcQ+98m75Qh09qBj1J2Jeu3zZEZV8t?=
 =?us-ascii?Q?ioYU7J/OsYWo05vOB4E1n7E/Cu2ROOt8i9fm/4arfHoc+/R3oHytoWoAyoeH?=
 =?us-ascii?Q?4jgDdCc/8sCWDFhjiLSWQBFSlCuffnoPV/sKhh5iENzuMF2JWMHwtpItCPmY?=
 =?us-ascii?Q?3YojdjCouv/dFVJbuopPVb90mLpZAbhiTPjbx82DhePpyiVOxL+4pQrQM6s2?=
 =?us-ascii?Q?A50M/5GniHleUnlNiNhs94ztqTfHWJZxzXGCIX2iL91SkPvGxRZlt9AjKnk5?=
 =?us-ascii?Q?Kx/wfPm1m2OmUtNt4ZArZFYlFsMAX1fGbpPeoWH1UcHs+zHA8LV3z6mivFbN?=
 =?us-ascii?Q?DOV1bXzT/1/rurNEHFKiE4CVhCeJwz0efLFktViDPUgJ1AdPK9aXoCKqRHJq?=
 =?us-ascii?Q?0utu8eOcHIrnWPssq0que54SMKr+/WMKkV44mVZEUoF4J0D1/cNKBkejB26h?=
 =?us-ascii?Q?msHboLhsfx8W2Gl9qtVOwye+l1bEFMovDY86kUCd2+CEXyfYxDI9P5uOmDGq?=
 =?us-ascii?Q?e2w+JvPUB9OVl7B89CPR9ay0f/OJv43wUi/3RnEkoySS6nIQZg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(4053099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D4auweQMkF+lIp6lAR8L0ZmN+QDNrk5OwdLD0otCkzujyf6CQeh3Qe7ch9ze?=
 =?us-ascii?Q?LesbvuVttuggRxF+0clV2iRKKtxTxqWwj0rxskIDL1LL6GQyaoMRCTA8/POa?=
 =?us-ascii?Q?4maQCdlgfhKpB7KGQxPCUnBt9Tz5o8kxsDfa6LJirs9b7ibq9eFUoNVQ3UkA?=
 =?us-ascii?Q?s0TYTxWgGV0lTxtCvoFRiv7XM2HWLmDa+SLEUXb7qc6T/vjXiAfjKvFEsbNo?=
 =?us-ascii?Q?3tCfYuBbVbBXquNPx3ObKjwNk1kYybW0vvmTSslpO+RqKcfJ4E9ii6Ylak0A?=
 =?us-ascii?Q?pk7fJH/uEo10DeKfoqpuPkf8m6FXujSpjs53DDs5DLktMxQIKSF2NtNlqw9k?=
 =?us-ascii?Q?aumYqz5ezl2CEW3H1LboGBnaHyYjukUWdaAyetg9zSMU9gKLoupix6RbduyH?=
 =?us-ascii?Q?bAmk9sPoUuzSPWEaU4quEYU+unBIT+zcnaHFsUkjp1R0hRGNpY2R9dMXfyMj?=
 =?us-ascii?Q?YAuN4RsG/hRExeYuVdoRjq/0x2oXHi/Ddkgk/SgtkcaGUFKcz1ogrILEXGUc?=
 =?us-ascii?Q?70ohc6pSiBviRW/6ZDxBk2FIWKmYwcq3AknT6IAZXGGwlsIS/nuDtvMw5JJB?=
 =?us-ascii?Q?PdfNdm8tLn7b90d87S0kZY7XHOiIIAZr5turvZwNkR3M0TTTXYZgXnX+dPc6?=
 =?us-ascii?Q?RNbLnDAy8m329R1enMRRrmuDiVxTxDGVSlMnATLU8DBfopWsNd+ZtdxsjIsF?=
 =?us-ascii?Q?VdY/GFlt8RcCB0jGJYx4x5RnBxvsIHwj3jMqsnIyIO/C6EjLBCZp9RazizJV?=
 =?us-ascii?Q?Agd29KDpIyiWkHV/gru246t5wvW92Slsq6kblgF4UYJDWUj+4l59vwBMBMto?=
 =?us-ascii?Q?lUktBzlZQyHN/BO7GW+CzjCQwzK5X4jL5rtSAkdQWnhvzFMdLHwFewDxvE1w?=
 =?us-ascii?Q?8qXNwBMoD3P9mO2PPfyDf4j9EsHb598ibBM6Z726TJAWmWAFehSv5fj4T9fm?=
 =?us-ascii?Q?LnXP8gwYL6QC2K3vSmEZ0YLcUwNRT9ENXyzkdAs3QJm2ytyScBbadipC9j8h?=
 =?us-ascii?Q?lN9jx9EIZpa2QadjF0/AAqB1e677VYC/9lo6f5uCzBQvpeTkG67cNX1Zr3/n?=
 =?us-ascii?Q?GKeuSJ/xvifpzkMiBHsDgdZ50+7xY/aJTKAsppW3b0rWjTVzU8kiJjwGC24N?=
 =?us-ascii?Q?ek3dRIlqDWpaEMqHaSKBzl8Klr0Rs5qefDd9R+sSzFZ9+Yz2fPlZsxAKa+Ne?=
 =?us-ascii?Q?uOVL1PBzCqoh+j/ADwWRadHJsbfKAcNi31dLOJFn4K8CqJkbkQy0drh2TkUX?=
 =?us-ascii?Q?UW7UTST2uyEabi92+8lWu75e4HzosbUIP27hzaNe/a3qc5TjLIlPHjSEFUle?=
 =?us-ascii?Q?WGSTWvK9QLoTGP63K6yGP8VEJYV5bX/PA6jgh6+0SHHvi0jLnwUZiiSdMqi+?=
 =?us-ascii?Q?TnXZM88SNVdBZ8GSRdDnvxPCXgKF9PB4ltGrvKSI5JsLQp3/6MBsSjg6WrCp?=
 =?us-ascii?Q?5XbLYQDPmdnyL/pI/CsJIDtSYzuV4M8lc6BhsmzF86702lr6fs8yEX0WF4xu?=
 =?us-ascii?Q?5Ng0lafiqyaPAV1cXs1qZPqsvNBvaOxNQvYv9q45OSV2YR1mujUV//dK0vo7?=
 =?us-ascii?Q?BTbgi3N3inZpU+ANPMivtls21kpIoy/clzs4efFnfFahhD6+HELhCPvE34KG?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ofPZ1K03EEDJOQZbHB4quniAOjeeqgDWLc6QozGda2xVnRg2krvDS80drc5JWqkOeDNQSvy9mkArZCGOYrd48+Z7d7ESRZ1fy92Z8LWKDJi0GwGGpiRLTliRZsUPgFn2XEATVhjZ52MTE2ED6vkd9CQq6kOet1nRnk0a8no6en36nsDxherA8SPe3u4vYU4wq7bRxORj94auKEoTYzTrX0E57roGQ79DFwltO3KP0B0FXEs3eU1BbSKl19hODROlKqFzzF0v2ssVz+cZcIMjPpkXTOtZJMPYgRO1C2vvNeo8pmoRbRMhX1nJ6JmN8Pczp0I/FKr0ktsgAiMPFyinM0ql1krM4CiOFpORYm/R7NvT7GL/QXPkUs6UWi54qbDlWIS9pppTnlNxn8A6O3ofChkbVTeVXXiH0eqWX99XIQ3qtJpPt3KHIqKYQrGt7JkXpA6lVrSYMFkcJTjypCPWtN/viy9UCU8jJglqtcHOYIfUC2jAEa3PSgj3Xxrem9RllePIBrfn6kj6RqwMviYC8jRPGJ0eIfIOpBU1KlIzZPGhVnG7O9/TUG2BrxClTO7Yc1gWNIXP0g7wSI8GtPep09wdPQOeumU7nRFbyWdxbD4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f49ad04-73bc-422a-c13a-08ddde6bfa5d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 15:29:10.0659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ShQHcI8tkNWmCKUsHHV38sxOdt/n0YbVuZ/7vdmy5+z9Tw29k/Kvj4sr0X+tmlQCMJD3C+HXaeifyOFj0K56I04+yk2N4n+9m7P5CnVq+FM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8020
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_05,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508180145
X-Authority-Analysis: v=2.4 cv=FdI3xI+6 c=1 sm=1 tr=0 ts=68a346ca b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=83mGaiKUj1zuKksq-foA:9 a=CjuIK1q_8ugA:10
 a=GSebvwEjJFBsbC99ckQA:9 cc=ntf awl=host:12070
X-Proofpoint-GUID: uyltOL5ViSN5T4ACGpy9Jl9lzSgYui6V
X-Proofpoint-ORIG-GUID: uyltOL5ViSN5T4ACGpy9Jl9lzSgYui6V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE4MDE0NCBTYWx0ZWRfXzL46RK4aQevf
 XqVeXk0VvcOrN8wimeUEdGT2bBRFuTCmef73b1aEacXS7S6g8TMswmKgDqRLs3zHshe+0Wy7jFA
 UTYHwTQEaD9mnJa+o+6kb3aNdIFXnt19CYK6kSU8r85zOPU5zN+MiDZTTeQqC+Q4ySO2x3sCguD
 V90OE/1oKCG9ryziy9FXQDKU/HaG7VF/pOoHRndywaKFfTTJoiYdwPFsF8ISWfjL4oaxJgOLRrn
 BqrUWDc0M6RN6hJC4noAN6CtoVFahT/zd+b9wOeeyiuvViBAOPxUUzIKDnUxO3Ld/xBTWAkT1VG
 6gRF1u50rJMY5e6udpaSgtz5zWPtwGhVpdkOTQi/xu1dC2HsB0FUP9paAHGa4Cgnxg1gAhiyZti
 X7ponfhlHY+TJ3tg7qRDac4F9KRrb52+OU5+iZb5XdLzKZfSblPzt9m8MyzKDMvzHCfVle5d
X-Rspamd-Queue-Id: CAA36100006
X-Rspam-User: 
X-Stat-Signature: p7x9k7ywf4x3wptbbgo1npxycc6m7y4q
X-Rspamd-Server: rspam09
X-HE-Tag: 1755530972-923756
X-HE-Meta: U2FsdGVkX1/8uEr5cLGIhf35hY3fpbUx+AIp+I0lBoUK7NcbgLzP+d3269qs2nXy/UoQi3ePihOlrreWFse4/kEbZO3HpctfL7kkXU+od/lgYbnhR9tJs+WyllPgm2G7B5eoIb/ewhIHOwmZQXtQtXSs7KziNM2S6RDTfKz3KDfMPv2bzd6Qs9pItsDuyJPqAHImVx2pjxUd/9wkvIPIvoMTCOaw9xdIvUpEt+dva4UufkmvtpUa9bpttMZqHcOpkOkJbkcH1/UgA4Pvmk7hx9qBAZnYEc+MT9sT7CUZykf2WoLmou1gtTfNkVBPScrvmlTNm0fYIIA1qzPsNrklVmTvO+vin18toemG7gNrozrUmvywlYqjOhSVhofwShlw3rIeG3ELi02K9yCtK882IPOI39xH3OYx1RCu4FX+ZAmmc+CTYPrZZJ7O5e8Bb2Igko1TmNw7hMSmJ9RIJ/wnOzbaqWWU/pngn+RHSXcxGnoYMQI5yVzFtJ6HvuL8G5RX/6E4PH49L9zzO/IfxVxj7/0stIENQaqn1Rtt+pdPYveHSIIN9j0gFC8ETuMbcZ4gulp4CkcUca1rTgXua0yFV1mnUFFVc9DGmjhycWN+VbuFQkwxxjx9OB1c6l1DR4I1L4Zt54VCI94GB5HL6/kN1iTaz7I+UmP6G4wEAJmi1kjhgxMST3rHFes5hb6AWyZ3d/lmhryJxCeRPACjW/s14pCaipI7AKfDJ08M6bToXuB3t/8LpfPobHzZCqgxPx4EFbFrGdf965zNm+gWK4G0jeCFnPME8PCaLmHZ38ZtE5y6WZvGu8ZNFN3XEvRkJKIPmonjmCGpAsHXX3YUCtekzz2GefoTvNRxKwrUIexeRU6H6vpN0cTWB+bVIqeruxbWTaBTX6XoynvSKZlhRT+TR06sh/xSblmeGeNXRPaAL6P9F0S0N08yTORZTqvZskp+RpczESt3xth0+5lsKYR
 odOubZoR
 HIS72uIqeVV3i6+7y4cPO28Q8aldXtSOWuR3Ocp+P0KyYn9TbCHGcVQ8dOLKYkpJC7qu64aYamfzdp/RBnCNzej4JNgUgeZR1W1PrzqN1iEscQdBroEWh8r6WlFoJq0I+RuUZQsIG+g4jWP34W6BNSJga1yReN0yA+lssFzUa14lu/fboTGQWRHX49b1d0rtYpQk3xUj4bcY0v0Wadda6xQ2PkZrVGdhRRj3A3SRieCjlyN7HscU3fj6Nf+jPXKU0QdXQivFpDFJCqle/psNrDXZUzV0g5TSKdiI9P8f4J3ZPvi1pi1VBtychLsna9J7LpF9eZ+umJ5c00UGh+2pDynUg/xe84OK6iS06pab10M5OdcaJatOA50ox3JGIXKmSNg8S8zEskUkPzZR7VkTBCTGr58Y4Q3VX9T8NjDO0ptT8o1e6ICH3xS1ypKZA+EMowb7Wk3rCLDHosQJ8BAkQH1uc5o+FqBY7O52JME871MCV3mi+TkF9vpAY83wxYkAgLO759FF5zJvFnU39PPC16YuZ12G8HVJ+5g33x3RQwgaszJ8xNhpMOP1ZZJwbMLpGZddCHXJlYcntBpgPxd9ecJu6On7moHOhpu25SJpwoeH5bb7TcPc6aQNNiVqQhAsXJ+vGciiWMLANg0jwRuz+nPnLZ6lNmJeMuGn3sBk97plYDd527/knN5natSO9ftzU2LeFqZSIe8gXL9kdqYnAQgdyBVFZKMiw2jlIMfgigiru9KdczQwss0By6cZ0pV70wvCpbNgUkrMfqkarVBRytXy4zx+FFMW/TXIA4cKIfJ56c7QIkZ1vO1vCxy3fFmDdA0y6PPqiCG9B0adlFBlrcbIrreR42TOgG9GVUldnq5gayvw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--gfo65tvpl26qo2qr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 18, 2025 at 04:12:59PM +0100, Lorenzo Stoakes wrote:
> It seems your series clashes with my mm flags change, and this patch is a
> victim, it won't apply against mm-new at all :(

I rebased it/fixed mm flags stuff locally (manually) so I could test, so I
thought - why not actually share that here to make your life easier :P

It's attached, if I didn't mess up with neomutt (big IF)

Cheers, Lorenzo

--gfo65tvpl26qo2qr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0006_mm_change_dup_mmap_recovery_REBASED.patch"

From 16b7f9d7042de8cb7d6f86b815d3075cedcf1132 Mon Sep 17 00:00:00 2001
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Date: Mon, 18 Aug 2025 16:19:46 +0100
Subject: [PATCH RFC 6/6] mm: change dup_mmap() recovery

When the dup_mmap() fails during the vma duplication or setup, don't
write the XA_ZERO entry in the vma tree.  Instead, destroy the tree and
free the new resources, leaving an empty vma tree.

Using XA_ZERO introduced races where the vma could be found between
dup_mmap() dropping all locks and exit_mmap() taking the locks.  The
race can occur because the mm can be reached through the other trees
via successfully copied vmas and other methods such as the swapoff code.

XA_ZERO was marking the location to stop vma removal and pagetable
freeing.  The newly created arguments to the unmap_vmas() and
free_pgtables() serve this function.

Replacing the XA_ZERO entry use with the new argument list also means
the checks for xa_is_zero() are no longer necessary so these are also
removed.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/memory.c |  6 +-----
 mm/mmap.c   | 39 ++++++++++++++++++++++++++++-----------
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9f584c5e4f43..218b496dc9ad 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -387,8 +387,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		 * be 0.  This will underflow and is okay.
 		 */
 		next = mas_find(mas, tree_max - 1);
-		if (unlikely(xa_is_zero(next)))
-			next = NULL;

 		/*
 		 * Hide vma from rmap and truncate_pagecache before freeing
@@ -407,8 +405,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
 			vma = next;
 			next = mas_find(mas, tree_max - 1);
-			if (unlikely(xa_is_zero(next)))
-				next = NULL;
 			if (mm_wr_locked)
 				vma_start_write(vma);
 			unlink_anon_vmas(vma);
@@ -2106,7 +2102,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 				 mm_wr_locked);
 		hugetlb_zap_end(vma, &details);
 		vma = mas_find(mas, tree_end - 1);
-	} while (vma && likely(!xa_is_zero(vma)));
+	} while (vma);
 	mmu_notifier_invalidate_range_end(&range);
 }

diff --git a/mm/mmap.c b/mm/mmap.c
index b49df82817ba..ecfeb1987156 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1288,7 +1288,7 @@ void exit_mmap(struct mm_struct *mm)
 	arch_exit_mmap(mm);

 	vma = vma_next(&vmi);
-	if (!vma || unlikely(xa_is_zero(vma))) {
+	if (!vma) {
 		/* Can happen if dup_mmap() received an OOM */
 		mmap_read_unlock(mm);
 		mmap_write_lock(mm);
@@ -1858,20 +1858,37 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		ksm_fork(mm, oldmm);
 		khugepaged_fork(mm, oldmm);
 	} else {
+		unsigned long max;

 		/*
-		 * The entire maple tree has already been duplicated. If the
-		 * mmap duplication fails, mark the failure point with
-		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
-		 * stop releasing VMAs that have not been duplicated after this
-		 * point.
+		 * The entire maple tree has already been duplicated, but
+		 * replacing the vmas failed at mpnt (which could be NULL if
+		 * all were allocated but the last vma was not fully set up. Use
+		 * the start address of the failure point to clean up the half
+		 * initialized tree.
 		 */
-		if (mpnt) {
-			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
-			mas_store(&vmi.mas, XA_ZERO_ENTRY);
-			/* Avoid OOM iterating a broken tree */
-			mm_flags_set(MMF_OOM_SKIP, mm);
+		if (!mm->map_count) {
+			/* zero vmas were written to the new tree. */
+			max = 0;
+		} else if (mpnt) {
+			/* mid-tree failure */
+			max = mpnt->vm_start;
+		} else {
+			/* All vmas were written to the new tree */
+			max = ULONG_MAX;
 		}
+
+		/* Hide mm from oom killer because the memory is being freed */
+		mm_flags_set(MMF_OOM_SKIP, mm);
+		if (max) {
+			vma_iter_set(&vmi, 0);
+			tmp = vma_next(&vmi);
+			flush_cache_mm(mm);
+			unmap_region(&vmi.mas, tmp, 0, max, max, NULL, NULL);
+			charge = tear_down_vmas(mm, &vmi, tmp, max);
+			vm_unacct_memory(charge);
+		}
+		__mt_destroy(&mm->mm_mt);
 		/*
 		 * The mm_struct is going to exit, but the locks will be dropped
 		 * first.  Set the mm_struct as unstable is advisable as it is
--
2.50.1

--gfo65tvpl26qo2qr--

