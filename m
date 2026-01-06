Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2013CEFCF8
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 19:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3026B008A; Tue,  6 Jan 2026 14:27:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AAC36B0092; Tue,  6 Jan 2026 14:27:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A8F6B0093; Tue,  6 Jan 2026 14:27:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D38D26B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:27:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BE788C9A8
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:27:56 +0000 (UTC)
X-FDA: 84302524152.03.73A6084
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id D008440013
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:27:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=j07vqgbd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iYornYDK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767727673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jew2ClAbp71rXXZb1dTuUtsk0ybUIlGqYJgETLyixPw=;
	b=afVzOwBmyOvsG5t9bUiYOwJHsx43ytqyrQbF8cbtfT5yABgi5ZPQMFZjJ90azundIoSl78
	imvMdo8uiOhY8aJvZEa3C9smoNY0FhsH3UEL/8vY816lwH6r+1hmrLC9V6l5b7nXfZCEA8
	MB7+J1v0o3ZFVl8VzJ7c5Znr3+YRQy0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767727673; a=rsa-sha256;
	cv=pass;
	b=frCyTAMG8klC/4H0imXLLhlZbA5TMogv46z5xLsHJmJTe+QtUP9HXGRqCmiK3JlH0ay72J
	2064PDFlIoP155kSAbtpW2yaV4tUy93Js45U43C91/nrO4UYcUAcy4H0yu6rWFP8QbhKdY
	GsECCSOu03knZcuySFdWLobu8WnfovI=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=j07vqgbd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iYornYDK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606J5x55007758;
	Tue, 6 Jan 2026 19:27:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Jew2ClAbp71rXXZb1d
	TuUtsk0ybUIlGqYJgETLyixPw=; b=j07vqgbdatIZPCCrHYOm8VmyNwZkgkp5Yz
	kTtd/KQG8pxMGXDkjeGCd5UNUpk05y//fpMG/vm+vzBhMJAVFcyy11jvJ2iNlzsj
	haotLn9Dh3/R++fAhUuuc19F/KNm4OGnM5otkSEtxZrbjNGIhbRj/Nd5dOuX3J32
	nbJIhGgpdhxC/AgC9/qeA2dSFSN4AIUUqurf0ifIZkBg1JF6B88foxFKerHSwxsk
	YcIcWEKoV2somRlCNyaDiZ/VRHqZovvfsEZ1sGu86g9ZOKW3N+IUge/UFjoWkzGB
	bHODQn1I7ghCvDElEiBY2x8grIa1dSOq3cVKLzrivt8zQM3Vnv0g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh88mr1kp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 19:27:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606IoG5X026510;
	Tue, 6 Jan 2026 19:27:45 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013039.outbound.protection.outlook.com [40.107.201.39])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjk8jw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 19:27:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MxqIAbZmZ4Pf5VvFcbw8n/RKhsfCppIA4HXSlqBcXk612u9j3it92Uou3X/okjOVG9cPEgyqodHOATacK9uIm4VNZIptg+0MMvv4kVXeRZ6ktHBvUPRRPArMS89gs9Of+NmH2Q+El8ulDPq9E0bfTyTDAFXuuY8c1n846gQIyhHt+68Mjy/6vFyqzwCTlzukK3EOnVp3zxOXDm9QiTzs4vnO5J28Bh1Tixsrhlk/oFJc46sP3athHgm/LDTJC5YRlT92sC8+g+/gqPQxZibBGALLa2FunSyH5Sd9W3W+T0cmLv4F3cgEFtcG5yARS76Pb5nF1pKZPevNLx5SlzoZSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jew2ClAbp71rXXZb1dTuUtsk0ybUIlGqYJgETLyixPw=;
 b=rFr6j5IX8GMnN1M/ND9hWtOvGaEBe3THXz2W3tshRxsZN6vSTNBnfKiC+Z7YgkG+sJe4ZV/xJ9XC7t1HVrE39j2bysV6bzmjUy10o8Ji7VGsJ47ZmlM+e1MBP+XbIAD3DwRs6N3++SAmRCw5A6eCyH5N8zrDY8Z8D3BVYYY57SCZvJSc4TZaQvN0VItNQj7hd47D3Sdtizze23rlsvA2xYvtYiRx8tMECU4AANIGgaI7DyEoV1v2ZXZ0cXjDByyp+/XEMvbVuxOKIEMDq/t1KWke1iDj7Lk5cD9KzcLHnUximb+XSAd1CejgoKtjy1LgYfF8vLrVIfi0ZqhUIRUmZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jew2ClAbp71rXXZb1dTuUtsk0ybUIlGqYJgETLyixPw=;
 b=iYornYDKBCm7pSqsy7tAcUwGUVi+DAp3Ch4l2Hyb5vyRmpFo+iUH4/Qxs4XjY/WJMD3lv5nuX9S5bhOvKKRKCsCS6K43cw69UYcRSD5oqoD0pouxcIVaAryFpIEQeXNPuom7Dg3jswSTF5k3PcVFNiq7nKRB19YL3mXy5DmpfPU=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY8PR10MB6907.namprd10.prod.outlook.com (2603:10b6:930:86::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 19:27:41 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 19:27:40 +0000
Date: Tue, 6 Jan 2026 14:27:37 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] mm/rmap: separate out fork-only logic on
 anon_vma_clone()
Message-ID: <oecut2v62gxlisp24gxgzwzxm3y3kiqcbkrheuxwkwyrb45apl@qtyhfsv34wi7>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>, 
	Chris Li <chriscli@google.com>, Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <a4f87ba914697a47419f12901a995759fd977fdd.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4f87ba914697a47419f12901a995759fd977fdd.1767711638.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT1PR01CA0145.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY8PR10MB6907:EE_
X-MS-Office365-Filtering-Correlation-Id: 3772af7e-b712-40e5-3a71-08de4d59a876
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dU/ZfNVTaYoDmQRxlLIjlW41tvSY3LizeOtt98lYVk/yl28Ycy4XuTQJCk1W?=
 =?us-ascii?Q?YmxYndEUTw07lBBrr565/Tb4C3wbAwR/Hf50L5v8dzS10JNiiMYSQkSC5+tK?=
 =?us-ascii?Q?nKoBfuqqEgGh7tGygqkQarlZMh5a0Iy9WUbjkfdu5JrrrwVd2BahTBvQtABo?=
 =?us-ascii?Q?5wc3+8wIeP9wymuucNPIQ78tnpGR5DF4e3tSqink2jKX428FeXoApaQsZOJ0?=
 =?us-ascii?Q?5gtLwJf9pIVBAVgr8Z8Sk7BIxr/c/TY206lXIVicsq2Ghq02Z9J9r3MdeKKH?=
 =?us-ascii?Q?f3uFViKCXrESOrvJJkGLeVeZOEQ6hVtZBlVk6pODjJtMSpl5TxLjDfqJ51SO?=
 =?us-ascii?Q?uq4poRI4U9BH+86XzOnjFr/kxcMQG33Xx24KK4XobZXsNF085RFqq8XqjbsB?=
 =?us-ascii?Q?77M4rwf9YMeVy/bis4mHpZbMVmvOK6AiYM2JJYRa8s/4svqFZvRpJPpdTKzF?=
 =?us-ascii?Q?6TPV3DTPiLJgDlmiuOLsdqcDXZodcyb0E+CudQjSuhrxAHcd+sGm7eAPZtER?=
 =?us-ascii?Q?KiWgY+rsYCH5VFv2DoHbuw9XYoIKtcp/q1ApNKhkJIcRLJkP4DQkp+2U/Nik?=
 =?us-ascii?Q?AcSKYq7mE7gQstZFgi46CAb98nGecd6x9YttdaRpoOC2v10+VQiiyGuCzIkh?=
 =?us-ascii?Q?fqStR9WCYaXEFZbkk9ofbV7lBkSGVRN6zTHq1W7YDkMSy+6+W+scM/YT8TWT?=
 =?us-ascii?Q?GQVfWNyWfDDsq225B5VVBmBMFcA/HHzOwoMTgQI6GmNoJt1mbqtBakftQBPx?=
 =?us-ascii?Q?kqvYsGuowzd17K/F57VZ7aj9EkbQ959x2IgNyBl1rU41P2ImBBImx2zCGLOF?=
 =?us-ascii?Q?Vxt/UUPguKS987HZkYDSXAjRHKwPRjdTRApMpvXG+CchNaeiyui6Knv+08QY?=
 =?us-ascii?Q?bK8dcK7Wj1MKHBNlZ5burPDOvuI9dsje3J34ZBl2spplAhnXwFgi9/K9jpo9?=
 =?us-ascii?Q?9ULgL2ltQ3OsRVrg4IUq6vSiASJhmyvdFtcrmhRFFLJ5Q15vHoqPw0qYJ0EH?=
 =?us-ascii?Q?weZuCnden11FiP0jLV1SQBSEZ89kLB7g2VUwT5XS2WLj81O+1DSt+X1OCHxs?=
 =?us-ascii?Q?GJDBja40cTMPU1GOao7/hW6k+2UrAPgnvvuCPM2lhNl0zrFxGo5VmD8QiyBQ?=
 =?us-ascii?Q?F/502FF77L4LfI0q806C/Ii1F0vhqYRbVh8dsEyS7sOP9dunzShbR4tzMJsV?=
 =?us-ascii?Q?coOiO/7811MZZXxmu0ZVItdQFsZBpTU1L1i1Uo1qgml7pjoVVHyTRVcFywAU?=
 =?us-ascii?Q?cABAuAMkuPVnng8h2NYbItjpAjroeqbDfE3bhAr5lmKuKeZUc3ubUiLU0OuM?=
 =?us-ascii?Q?bVXKuO2uUmi2egNjqPx5zn9GhJ4rN8u7YbRHuHjJNxDFwKyvqgwfj1052Ujb?=
 =?us-ascii?Q?Dvmoc0ZW+uxfjeotNiGfyAe/+0TJoYaIcxlYYfJaA6wBtAonom3YeMXO+Dwg?=
 =?us-ascii?Q?LKeno6i13NQtg5YfMRZ7Cz6helaZvNUH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EzsuFh7ASQ6L6t+Yvcesu54lYjSFu9fzDd5B08nMRb3gBAIV6DH7ZJ5wTVwF?=
 =?us-ascii?Q?KVx1cbPy3YFfCZugrNGEd18SG+Ws/2xopZWO2vxJ9eyMl/nQIw1m2HcjG2q4?=
 =?us-ascii?Q?5es1pn4LSO5AaZAG5DnHvD7hrzfMW4xgreyT0Bn5maaLiXpGa2JsHBawtsIe?=
 =?us-ascii?Q?/H170r3nSsjfFNZUzTSrnIuS4Bdb8TN3CSIlYvsn8QSs8FU8lEUpYUVTdwOo?=
 =?us-ascii?Q?A/Z8XekfLXvn7+ESRZoKgSbT/c3nsCpEPGLD3mfn/lTDq9Ivucz8YGAoiYoM?=
 =?us-ascii?Q?ARWzVs4Lqw2MbTGuKKhJ6k+3gXEyjocdGJzbgWeuOVfi5wvFH1Q+L5B4lA9x?=
 =?us-ascii?Q?zTQ0DdxAMYTXpdvydMF5RvWo4zj5LW/fmHjg8Kcz3Gj0020YDNRpmlfgdRRJ?=
 =?us-ascii?Q?lqUL5DzxUvzNc3j+xkHdmzzvxTOJn15DBnNaAGGv6iWJossVWu18IJn63aQY?=
 =?us-ascii?Q?HkO4Ktfp2by1o6d5yJXgIStsGOobsIY3IsRgcvn+CHGfPDH2VpG6UHLX7grS?=
 =?us-ascii?Q?WJTJj3K3H/G2I8+CBBODBR6VUpN6ZkRxySoJp5en37+Tvs+9pgRZjYVc5yKZ?=
 =?us-ascii?Q?Ho2bJSvhPwLYyL79rV97j+8lYxfHIxPoBggzWQyf2pjMf1RlbdrS0E686uuC?=
 =?us-ascii?Q?gO2PRhDg5vU4i4ypG72MeUWhA/qush0e7Gq1Izk3koeJHNneBxbLnErd+pzQ?=
 =?us-ascii?Q?f8N7kX3wXK6Ujusx/o1OQvcdXId9/o+lJF5ocm42uqxLAxxLsOB45LHI4oLa?=
 =?us-ascii?Q?5mGD/UdblhAhLfi+VVvib+JGr9QbHEg47svI/mZ4XcPgrLId4GmeFhcZw69k?=
 =?us-ascii?Q?Sz+xvMAoe++/+K23fMXPXWz11hDWUl1l+am8kBnA6pDw2M10pF3NSsbqXTbT?=
 =?us-ascii?Q?IlQT/J+ce1w8PC8Fl5A3z8MTjCkv7X2wUrg6r+Ww9AEvgbA9chdCPVGZ+uCW?=
 =?us-ascii?Q?DBOulGvruKXWfJlQlrWIRS44X2G4MB3dxOZk4U7Pzp/MexYZ+ux2IUXGDFGq?=
 =?us-ascii?Q?njdJm1/c+/i3goBLx+aZazrS9w4nUCYgOuukpaQr36Evh7ZuE18GvivQh4+w?=
 =?us-ascii?Q?10yrm5sA5UPu48GMo8EwEvJLg/x525oE+a13DVAhJLG9Ot7MZ8fjmG5CT3r3?=
 =?us-ascii?Q?DEqzMmGwHLHMb2QbSXjaUPgLKOdqJPHgqlJWtgFkes7mto6jTfRznu3xH1fu?=
 =?us-ascii?Q?+hLPQynSjkZq8Q265gPxGbckBbn/+msrFatObsX1fwlOUJ5jySDWa8JP9gIm?=
 =?us-ascii?Q?XG7izZhcsWp/o13i+GoP+GeWxdgFdHGIaoPP67W8iDnN8ukHK0nV5GygiWh5?=
 =?us-ascii?Q?NjZOfu6aWbuPmwdmYzRfC/319QIYKIIYQHztQ92y6wRtIdQjr78s3KhaWvUN?=
 =?us-ascii?Q?bgIn5cJoHJ0gRD6duNqVwiw86H6fFlVZ6K7wlAcqNU+WG2fy6hdEr8V4EeFf?=
 =?us-ascii?Q?bdYqO70IZzJqlVEtai8tNdVwE0X4//kNtA2dDA3KX9LC/Kt/TjDWdmnkNM+U?=
 =?us-ascii?Q?8QrTiWGLXg6zFp/8Z56oXAx/6S1k65mETNKnEwVlTWm7WyLN9z9rdCaAkrwu?=
 =?us-ascii?Q?StFlumz/dfqcFoJ9oxgULvpY6+LtHR5EH3vt6n1m4tRv//T5fTC19sxuOgYC?=
 =?us-ascii?Q?HDCGI+kJ8ORXejTgdbiFYKFTVujgzfXSlJsdvqteRqeJTw/P9tB8bcl8k4Vd?=
 =?us-ascii?Q?ARFusvoYGGEdHM+q7sur2Sw2c2ABjtCE5t+pgDh8Zpec/n6hBmNZLC1IXHnY?=
 =?us-ascii?Q?kG5k5zBQTA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kuvnbWZfe0iroKDY9+aSmkP/px6Dv89rVpjnb/2VdFp49WSUNdD2nwFaLX6COUZ9LMsuHA5YroTM7oJnPc0tdjXqXj4qR0Epa1TaCif99vl7Jf3JALeZacI+T8+c51OFsrWPXW5ItmciqRfFbrI5OQG9hFJz+A8KCyHZE/g/uPZFcaugkTi+OA5xhSMVMlwcgZwC3ggFkNl0zLz8l0HNOWlvnjxgXbCxqUFFEL99pBsprv8DSnIfUWs03yblnDf2cnGxsDeyxyVO+HrAvH3PEwz1dP2F7lGDw24sHiM7lLnrrTsbx1B/fwXCIWw5zlASzZsWHH/2uOzwppOszFWDDv4rRnkcb3rQ3OSMECOmuXIeZJJ0sA9aKmGmbxx3Q2vSTwvarJW3rBsmGhIm+0KHBv+dQGcoCsd1xrhl1n7b0xFuG/aMHnx38/H4ZyQfFj/I2XqxTuiB1SVeJLdchs5CiCTSw+hZBRCykXudTkQwSsq9JLjSPDY9S7ENAmhkh+lzMYFRwbZpv6pz6GPQrFxw+H7LKg4+QHiVR4RrLDPSVh3Bl38W/8W5V08jHVB9GnD+L8es14VtD4kooVDXNjez+ZEnvrJxKqTkokRhdThOWF8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3772af7e-b712-40e5-3a71-08de4d59a876
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 19:27:40.8643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CTeRnLnyC1XEEaP++cwqH+j8dGcBfsBLNZZ9YM60G9Zo0Lp5vR2I75+49SVLp7MzfHOxSL3fFfRORapJoj+pZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060168
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE2OCBTYWx0ZWRfX7lXE05lksKv+
 prnOQlccu1O+9KuD0cRrhHN/my8S2ZPo7aBy01Fazl/TQphKB6zmDhHGKXPg1J6aGIWd9DQNtuD
 iysxLoV5/RZPyhQZ2EgdfM26Ujg5J6TZShFFiDI6TxSl9ph6od/7bxTV/CWJ290tTqytaUngj4C
 epc5snD01/vNAahIkj1tPNejNNh6C60Ndlfp0jXQbqfXHMxO+PCUwqqxjeaL9PaxBl/wSQZk5Zz
 wUQVvA7JTysy6YG58tRxUEJMJ+7RuVwyS4CwhlSp6dcHGVpS51LB/YWmtH6zasp2PsCBfFCl4/C
 PM2ePe4gP9mq0X6AceI/pm8fKy72AFntY6t2QzIcB5mZ/GoYEfEHgGzSymq3Fzcv5lSMf2ZRDb/
 lTptJGFImfJCOFzczvrdDvrXYFkVQPlG5rMe4Va4XamJn5qx9OtODGtN+kgq8jcJRhos9qWv8y8
 0dZc0ad3OzaS98WI4WaJBxVLdzKXo7GR2fCPEnEY=
X-Authority-Analysis: v=2.4 cv=UYhciaSN c=1 sm=1 tr=0 ts=695d6233 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=z_2foXKho-7GSaKOSxQA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12110
X-Proofpoint-GUID: spK7anbZck3zyAJkQrvRlG5pA9K5Z7oi
X-Proofpoint-ORIG-GUID: spK7anbZck3zyAJkQrvRlG5pA9K5Z7oi
X-Stat-Signature: 8838agbjsu4mtpj6icygc4j1jghg7to7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D008440013
X-Rspam-User: 
X-HE-Tag: 1767727672-355875
X-HE-Meta: U2FsdGVkX19OIuLCFJ1swkUeNZ5CwlAx/NWpQdy3ZpkRK85tbUYGubjD7wKOdFkmmrhd63fDWv7mhFGCeityFtk5xyzVJYu8Wmb8XB/j9K72W6AGlwBErajhyJoe6KeHuZRYysOUenPTzVNrU1LXRfIJ7bXE8mxekUgsVZ5zH48oSnIdAEmqm5L+3BLXSdtleeSxePFGX93iv5dN/9zJwVcOcrv8cTWzJ+iLNtZUtrsxjn4/UbngfZtY8kC0ZjoGKI8LHzfvwgSG8fQgwFjp9oFVv6FnTCyhuZzrHh3A4eacNF03A9saXxCMX5LrzKNeujGLmhiU98dHY5Kn+5B3a+dh0iqiE0KZbQowpnsJ0aGqlu07/F2gAcudJYkIm2YXcL+8oB0d2+RFn2hd7A0E/Wggc5qoL819IurRjddu+AaLtAXab99a8lr5Xh3GFrcODI7WbEAaToN0u+MmdGTV09PO8P5Rh+KcVU60RAk6EONCIXAnvaB5DxFxYKjznIMRNq4+y2Oz9pxkx0kgsVz8QpXlwDQlmXw05of21G3N8rnWwywNGuvLPG19wLUiG+4CGrhnl6RX9fUImcKKJYxczUCCFdkDelHDR5yQTI/0zhKB3Lpv/1hmygMziloYWn45DwMkW6PyspQI/AEim30bGzT4XB06M4Ri7M4nMn9YlYabSmoBZbxaCWX3LhWk4hBIe/sFANfsc5XkaJfyjOJS6EAyh4TRpfBAFwOrM67getYZBgicpVWGJ0LNrEdp7SE/0hjSZMz0LdruU9VSpzTD4JAFR4eMkvm8hzV4kf57zvUEkb1V3WeLMeeNfEFzyhQyFzDI1XSwPFaYcH7cQ10/5cAyMo+M9zB9Q8DzSazuR+knrXj40dbQAAM65HmpTQTSoJo+KwkaTzCZAdvcAAWfrQbWewzjUgWD3kPjc8C3SDBSC148fzZJlIgilwe1j/M3pdTAtNorLCp3eQJEQI1
 z0pN+I09
 UJN/MsjfCfHq1N106lHr/hRQUx6mJKLGRTlshvnC8V/bXf4UNKb20kzFSxxxWDTYArE5aLx8yL+mDzGNbfAGFDWrpAuv0xexQezpYt7i6k7EI9M9Ld52je0iGvUlwJhYHmNBz4FFGlJEvdUJOSh/VMCuyCR7mrAWpfpTuXV8EhcI9tmioV/c3Jeb8b9SaXSNsux68gbDq/dlbB8yWg28PwyudhJAOnkXjJA25lvre/fqVxiQnraJY3XB4QKQ2lc8pt5HXsU1FjLbfzdgr3ZF91A6aDrcw4eMjcqfyCsrQv7GdbjzKUEKMvV2tMSrRGoTTkxrDEiaZUhHYle4+/vqppLGdkBqyPxKkLEg1QWEnT2/JPl5QNXJm9ozSZAY9IRAFghqlhhj1tOeCN5uWdFmT9yh2Rn3uIlFQHUWJ7TRpQlGgpP7QeeWnUnG9dlhzqp17RJj7zjVwx8k7U1RUOu9lJO8xiMj36yu5BZOYEZNRXkoutVD/sd7siVhAGzPcEP2fYuZnftY7dRzQS5zmhc1i6iXZYx+FEMbNizjuIX99Ph8Ji/SrMg+6Mya7LBgd1+uWt7YIarGs7AmPWpb5hP0LgSqG4EF5E8iewH448JPTIvmnwhhYZsdFiHXJgpkumnWgMQHu0txoe21McZM+mG5CjUnicDNeAaCeFiz5ZP6Wv4frtXPGIthMm1whG8gnFfB12463
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260106 10:05]:
> Specify which operation is being performed to anon_vma_clone(), which
> allows us to do checks specific to each operation type, as well as to
> separate out and make clear that the anon_vma reuse logic is absolutely
> specific to fork only.
> 
> This opens the door to further refactorings and refinements later as we
> have more information to work with.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

A few minor things, but this looks correct.

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/internal.h                    | 11 ++++-
>  mm/rmap.c                        | 74 ++++++++++++++++++++++----------
>  mm/vma.c                         |  6 +--
>  tools/testing/vma/vma_internal.h | 11 ++++-
>  4 files changed, 74 insertions(+), 28 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 4ba784023a9f..8baa7bd2b8f7 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -244,7 +244,16 @@ static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
>  
>  struct anon_vma *folio_get_anon_vma(const struct folio *folio);
>  
> -int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src);
> +/* Operations which modify VMAs. */
> +enum vma_operation {
> +	VMA_OP_SPLIT,
> +	VMA_OP_MERGE_UNFAULTED,
> +	VMA_OP_REMAP,
> +	VMA_OP_FORK,
> +};
> +
> +int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
> +	enum vma_operation operation);
>  int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
>  int  __anon_vma_prepare(struct vm_area_struct *vma);
>  void unlink_anon_vmas(struct vm_area_struct *vma);
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 8f4393546bce..336b27e00238 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -233,12 +233,13 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>  }
>  
>  static void check_anon_vma_clone(struct vm_area_struct *dst,
> -				 struct vm_area_struct *src)
> +				 struct vm_area_struct *src,
> +				 enum vma_operation operation)

You could save a line here by putting src and operation on the same line
and tabbing only twice, but sure.  This is true in earlier patches as
well.

>  {
>  	/* The write lock must be held. */
>  	mmap_assert_write_locked(src->vm_mm);
> -	/* If not a fork (implied by dst->anon_vma) then must be on same mm. */
> -	VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm != src->vm_mm);
> +	/* If not a fork then must be on same mm. */
> +	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && dst->vm_mm != src->vm_mm);
>  
>  	/* If we have anything to do src->anon_vma must be provided. */
>  	VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
> @@ -250,6 +251,40 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
>  	 * must be the same across dst and src.
>  	 */
>  	VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
> +	/*
> +	 * Essentially equivalent to above - if not a no-op, we should expect
> +	 * dst->anon_vma to be set for everything except a fork.
> +	 */
> +	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && src->anon_vma &&
> +			!dst->anon_vma);
> +	/* For the anon_vma to be compatible, it can only be singular. */
> +	VM_WARN_ON_ONCE(operation == VMA_OP_MERGE_UNFAULTED &&
> +			!list_is_singular(&src->anon_vma_chain));
> +#ifdef CONFIG_PER_VMA_LOCK
> +	/* Only merging an unfaulted VMA leaves the destination attached. */
> +	VM_WARN_ON_ONCE(operation != VMA_OP_MERGE_UNFAULTED &&
> +			vma_is_attached(dst));
> +#endif
> +}
> +

try seems to imply we can return something saying it didn't work out,
but this is void.  Naming is hard.  reuse_anon_vma_if_necessary seems
insane, so I don't really have anything better.

> +static void try_to_reuse_anon_vma(struct vm_area_struct *dst,
> +				  struct anon_vma *anon_vma)
> +{
> +	/* If already populated, nothing to do.*/
> +	if (dst->anon_vma)
> +		return;

This is only used on VMA_OP_FORK, how is it populated?

I assume this is a later refinement?

> +
> +	/*
> +	 * We reuse an anon_vma if any linking VMAs were unmapped and it has
> +	 * only a single child at most.
> +	 */
> +	if (anon_vma->num_active_vmas > 0)
> +		return;
> +	if (anon_vma->num_children > 1)
> +		return;
> +
> +	dst->anon_vma = anon_vma;
> +	anon_vma->num_active_vmas++;
>  }
>  
>  static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
> @@ -259,6 +294,7 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
>   * all of the anon_vma objects contained within @src anon_vma_chain's.
>   * @dst: The destination VMA with an empty anon_vma_chain.
>   * @src: The source VMA we wish to duplicate.
> + * @operation: The type of operation which resulted in the clone.
>   *
>   * This is the heart of the VMA side of the anon_vma implementation - we invoke
>   * this function whenever we need to set up a new VMA's anon_vma state.
> @@ -281,17 +317,17 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
>   *
>   * Returns: 0 on success, -ENOMEM on failure.
>   */
> -int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> +int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
> +		   enum vma_operation operation)
>  {
>  	struct anon_vma_chain *avc, *pavc;
> +	struct anon_vma *active_anon_vma = src->anon_vma;
>  
> -	check_anon_vma_clone(dst, src);
> +	check_anon_vma_clone(dst, src, operation);
>  
> -	if (!src->anon_vma)
> +	if (!active_anon_vma)
>  		return 0;
>  
> -	check_anon_vma_clone(dst, src);
> -
>  	/*
>  	 * Allocate AVCs. We don't need an anon_vma lock for this as we
>  	 * are not updating the anon_vma rbtree nor are we changing
> @@ -317,22 +353,14 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
>  		struct anon_vma *anon_vma = avc->anon_vma;
>  
>  		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
> -
> -		/*
> -		 * Reuse existing anon_vma if it has no vma and only one
> -		 * anon_vma child.
> -		 *
> -		 * Root anon_vma is never reused:
> -		 * it has self-parent reference and at least one child.
> -		 */
> -		if (!dst->anon_vma && src->anon_vma &&
> -		    anon_vma->num_children < 2 &&
> -		    anon_vma->num_active_vmas == 0)
> -			dst->anon_vma = anon_vma;
> +		if (operation == VMA_OP_FORK)
> +			try_to_reuse_anon_vma(dst, anon_vma);
>  	}
> -	if (dst->anon_vma)
> +
> +	if (operation != VMA_OP_FORK)
>  		dst->anon_vma->num_active_vmas++;
> -	anon_vma_unlock_write(src->anon_vma);
> +
> +	anon_vma_unlock_write(active_anon_vma);
>  	return 0;
>  
>   enomem_failure:
> @@ -362,7 +390,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
>  	 * First, attach the new VMA to the parent VMA's anon_vmas,
>  	 * so rmap can find non-COWed pages in child processes.
>  	 */
> -	error = anon_vma_clone(vma, pvma);
> +	error = anon_vma_clone(vma, pvma, VMA_OP_FORK);
>  	if (error)
>  		return error;
>  
> diff --git a/mm/vma.c b/mm/vma.c
> index 4294ecdc23a5..2a063d6568d9 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -528,7 +528,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	if (err)
>  		goto out_free_vmi;
>  
> -	err = anon_vma_clone(new, vma);
> +	err = anon_vma_clone(new, vma, VMA_OP_SPLIT);
>  	if (err)
>  		goto out_free_mpol;
>  
> @@ -626,7 +626,7 @@ static int dup_anon_vma(struct vm_area_struct *dst,
>  
>  		vma_assert_write_locked(dst);
>  		dst->anon_vma = src->anon_vma;
> -		ret = anon_vma_clone(dst, src);
> +		ret = anon_vma_clone(dst, src, VMA_OP_MERGE_UNFAULTED);
>  		if (ret)
>  			return ret;
>  
> @@ -1899,7 +1899,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
>  		vma_set_range(new_vma, addr, addr + len, pgoff);
>  		if (vma_dup_policy(vma, new_vma))
>  			goto out_free_vma;
> -		if (anon_vma_clone(new_vma, vma))
> +		if (anon_vma_clone(new_vma, vma, VMA_OP_REMAP))
>  			goto out_free_mempol;
>  		if (new_vma->vm_file)
>  			get_file(new_vma->vm_file);
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> index 93e5792306d9..7fa56dcc53a6 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -600,6 +600,14 @@ struct mmap_action {
>  	bool hide_from_rmap_until_complete :1;
>  };
>  
> +/* Operations which modify VMAs. */
> +enum vma_operation {
> +	VMA_OP_SPLIT,
> +	VMA_OP_MERGE_UNFAULTED,
> +	VMA_OP_REMAP,
> +	VMA_OP_FORK,
> +};
> +
>  /*
>   * Describes a VMA that is about to be mmap()'ed. Drivers may choose to
>   * manipulate mutable fields which will cause those fields to be updated in the
> @@ -1157,7 +1165,8 @@ static inline int vma_dup_policy(struct vm_area_struct *src, struct vm_area_stru
>  	return 0;
>  }
>  
> -static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> +static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
> +				 enum vma_operation operation)
>  {
>  	/* For testing purposes. We indicate that an anon_vma has been cloned. */
>  	if (src->anon_vma != NULL) {
> -- 
> 2.52.0
> 

