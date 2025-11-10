Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3647CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 07:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EF518E001C; Mon, 10 Nov 2025 02:22:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C65D8E0002; Mon, 10 Nov 2025 02:22:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08E758E001C; Mon, 10 Nov 2025 02:22:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E525A8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 02:22:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D9074C9D3
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:22:28 +0000 (UTC)
X-FDA: 84093854376.06.F265022
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2683740002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:22:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PyNc9b4m;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="S/KaTo9c";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762759345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJHuw4Kq4Y2g91eF5pnaQWzPdXacgtna729XjO1xJ50=;
	b=oYUkFEHucnCvU9RzfWV22FANk9C/T9vW6yExvFgoiJkL1jaEgCnISs6CZElZAP4WmNLGi2
	72Q7R/8Nz4rpsZY8cB1TBiAituAyLWqbDRScaGruN5hkORKbRIrU11zOWnxWx2Xvy0FbBC
	qzuxrKR4wfEru3iVUX7SvDZlbcwqAX0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762759345; a=rsa-sha256;
	cv=pass;
	b=ivzcIYb2a2N2C/1MawxSHmkANKkX8biXY1cPMXoryEs46z2/dGNs49hmHFhPYglgEGmPEF
	mjOS3s9lw69LB4fAwTt7p/9vJhRD5KO4lhCHljEa/WPVPwrxPKmGJcIlEKnTLmbqTEcQQB
	2+qa5YPzMEHs4jeNxeJ3TYsaLLvaUyU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PyNc9b4m;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="S/KaTo9c";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA6gHOv023266;
	Mon, 10 Nov 2025 07:22:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nJHuw4Kq4Y2g91eF5p
	naQWzPdXacgtna729XjO1xJ50=; b=PyNc9b4ml5akxwOKKmQAT25triXbu8sY4P
	H+AkQMcm/MbqWpC64lttNi3oOKBlKRkUzhLCAltVncAcu+3vyF3bb9IkZiyEzRq3
	55gNShm6ziBW7jsXljxZiA5dWgq/JHuXn/YKa7IKxT7R76sUx1spyJskzF7Gluq/
	TrIS131J5nKY4ZE6d8Jbb//JbeTtMm+2/OsDCk42ZO0y5FyrMxyiAH9XxgVJJ2FS
	4wXvMZnq0aGV3XH7pk+v3QyjifLjh9epw2ZsJFGiMI3ySzIDV56yHt8JJdjEL1sU
	ldqAnka/Zortx4Uv7ZlXSmeh8M+uxEmANqneHHhI0kjxBC45HcOQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abafhr3yw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 07:22:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA64uuE012740;
	Mon, 10 Nov 2025 07:20:19 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012049.outbound.protection.outlook.com [40.107.200.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vab9p3f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 07:20:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hVqYt7alBG5euKRb/F5NPFk1eiMvxqsjcr8cfto/8JhsLVx6DD3Fe3xRgWSWfxGWDKYRSPwioqgRGK0pxwXw/gs34wNQR9ygXDH4DumNmXtkgze/nsImWmmzOoQr3XCSMDruKbNQxa54oagcfO9HlMW5pM3wdgv+5G7158+lHA7YuWDAutUMg7MKSdM8APB3cvSvATEGHsCollirytiwwKlgtxwbKeUpysWMfBshNJqryBvU+UfOcnBG62nHSSasp12dzH4F+cStUKIQqGQHqJNQffhPFdRqPsP9/MMT0Rk+2VtOTSeQ6MuxSQx0gkDpyTmZDoNT3JP4K0yomenfDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nJHuw4Kq4Y2g91eF5pnaQWzPdXacgtna729XjO1xJ50=;
 b=bPh6VnPbNxoYqys6zIn0o0+4O2x0J+9V+BErS24OIzX5Zh7wGM/wXTO3TXJh/3DbWy11W1hmAHb7IwjnDbPQ5oCPG7hJ8IUkeqRv0ymdT1z7NrHkogq548i0/4XW32W1oSszR6iAAokiIOQBotaFtka9mTqU0dCn4IcH62q6tmNK7N7kdX4ozH2bT58X4vPtYtM/IQ4gpFZThKcfTnrqmcySbde6ACh9yjAZ6B0Eu1j2CNZjQLVGZVnzdYUKGXRkNPCML2c9TYgtDaWZvRgSFaYX6uIWtaYCoznoUvvNbxL511Ink8SiKlSGx+Ry4EvlkZ3CJ0J1N0Jh5dZMnzMTZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nJHuw4Kq4Y2g91eF5pnaQWzPdXacgtna729XjO1xJ50=;
 b=S/KaTo9cmuxpeJMIWDtboQV/3K7yXyxt1cwXzM8Ah7VmHFGLGq7y/9UhbJ59GR8WxA0QMj25Eo0GCvLfj8J6JDtsT/eU5+YIhjlT/y+wL7vBTuLFkb5E5/aOZXsr0BTvqDhktNFoRT0/uGkwbPjJghxUvRYRFSi8/Lz3Uf6e1p0=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ0PR10MB4430.namprd10.prod.outlook.com (2603:10b6:a03:2d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 07:20:16 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 07:20:16 +0000
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-7-ankur.a.arora@oracle.com>
 <77b2ae9c-2700-4c7a-ae45-323af6beaff3@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 6/7] mm, folio_zero_user: support clearing page ranges
Message-ID: <87346o582b.fsf@oracle.com>
In-reply-to: <77b2ae9c-2700-4c7a-ae45-323af6beaff3@kernel.org>
Date: Sun, 09 Nov 2025 23:20:15 -0800
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:303:b4::33) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ0PR10MB4430:EE_
X-MS-Office365-Filtering-Correlation-Id: d09a4736-e595-4625-6ed9-08de202998f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?krITUPdN1MzIpBmT+VnKHMf+KbfOQKTvGQqplzB1VqgzZR/j+s6y4gKPTW/A?=
 =?us-ascii?Q?v+n60azlcUEzFdNzm08DaPGGIJ5Q/uxqShV4JlZ29Wh5bQ6zyJN2RCtBjDhx?=
 =?us-ascii?Q?DS7nsGTPcw5OledGu1FH2E5Lf059khL59fIWVMVetnqQdxfTIkvxkq4av+7Z?=
 =?us-ascii?Q?zibvi8tx/Vk6g8cVcVvQmtzJ7v1kXbdY/lpk5IwRAj+kUK3N1vpfj/oo1Yf4?=
 =?us-ascii?Q?84RagdXzQcO2SQG6VcHrFd/05Rg5xemGYmgeYic/wCISY91Sig+elroBRyNN?=
 =?us-ascii?Q?PnfqUlXgsghDdb/nmPYsioY75Z+wEmtboXjaPkFgTQzUS1v4EmTV/4AX33Q7?=
 =?us-ascii?Q?EpoxFs7lWLe+SlTQA9TnfCDvURMcHENjJCVtfRbJpc6mb844BvbOJNmX/KLF?=
 =?us-ascii?Q?osutdBblglkLLWjsQ3+tQM2hcyROj74SBcleC3MmyCERtj3hLrfGBM62PDuy?=
 =?us-ascii?Q?zbYjh9m7hrxpxD3FFtzdfJMlQ/v1PhfnfjNTUasI7GfQNk8OwlnrICGwaLLv?=
 =?us-ascii?Q?CPV84sxT5oWxDygbwimOH3C26HF6+Ucn0Xh48wtj4KHOuACCyKezJFcqGu8A?=
 =?us-ascii?Q?lyX9Rz0v6k9rf5vhTCYX5qpQFOHQfCuBG9xVCmTi9j8USL9onr67vJYeaDMi?=
 =?us-ascii?Q?IcyojjBhbn86+Mq3hMP9Z84s8TU8eJUKmWWuNTgqeCj4TjrgflUTMMBCNgbC?=
 =?us-ascii?Q?19jEpVTQLnKyVqYhiWskk38ttk7sj0d+lxqjUWRFEFQzLyVkD2dVP6+GPwjN?=
 =?us-ascii?Q?/DZPK9gllfweEW/gUSuNqQSGWrdqXZ0Jxm6yoSlRh6KYK4AUhsl6ocKGNGKH?=
 =?us-ascii?Q?/mM/SeNcQ6s4Jh60yeBtN+hqld+k2PWgtbj/c99yWCOqKlVzijw2vxi0Ahog?=
 =?us-ascii?Q?YWrmxyxXYYzxdpELjqu7IpY/bSScxdmMMkPgJBXDNn34TSapTOtq1MsXf7Xa?=
 =?us-ascii?Q?UbPNyhCuZwREO1WC8obKX43ut8U0gX+mxdQgNzUTTAzYTaL9oP/XuYEnUaxo?=
 =?us-ascii?Q?dxZEc6eP4k7Jn+zOSBlIO8sZUDfEkleQWpbWYVMgomuJHc3Di5sjY2J8pGx/?=
 =?us-ascii?Q?ojIMpgj3pw0I9J/S4FQSNAob+/pc5zIgrOWj/M3uGCXkB/rgoMvjZEEw4bBY?=
 =?us-ascii?Q?agc4XCg1xJViZDN9EmFAoDcDTc6JfXrcvh61/SsOVE7h0QAKrrT1zBuc81Q6?=
 =?us-ascii?Q?tu/YQ4eArkMujSfJRwCjyx3at1wF1tEjYINMJNQPzTK6BTvu4yXXHCU9AtK2?=
 =?us-ascii?Q?J0J6+K6y4zb+5u+xBf9pj8F44EtlzTuFqEkdMfbLweuM2viP0VX1/rHwwpGU?=
 =?us-ascii?Q?q5kk/4b2DEXB8S+S63zU8x3A1NNFmze2l89WLbFh8J6KWc2M+iCzXsBtTM5Z?=
 =?us-ascii?Q?plf76RSzC2af8FOfuPA+BHZdpoUT3MYBTmvZzGtVD7hxYNa23XlsRnbsb/aq?=
 =?us-ascii?Q?ckfzmI/18YUkeEFHCNFGRi0/5sFmcLDT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hSPI5HnEq3VcK2WydrxKKDdkq9WP6/2oafeCC/50DuOmaZvU9ebVXeJ9KTD4?=
 =?us-ascii?Q?tI+4wN/IhX1dDiYMAWa9m1Vu3gNDRhoIhojMS1+TS6P+gAY06oesRww7nx/J?=
 =?us-ascii?Q?BqZwjdVkavDWKnReqoKM4Q33/qrvH9zSDnTW2gfiDw4ufG1hMOk+ZfrRrK4U?=
 =?us-ascii?Q?TV9z50r3H2qI+W5ItFOSJbBOKmdyXbFNH+XmnaXH196vMWGdRU67CTkHNtGY?=
 =?us-ascii?Q?5mAkNYc51y62HvyRkW2YSM/QxTdnEyWqf+tuL7evL5m6EYIo8wfSTFa5YE+A?=
 =?us-ascii?Q?PAIIcllLHuygQQIYeGfrsrWM+k03fhSrNH7mDFIjQmiiyYjkN1MfmO3B5mNh?=
 =?us-ascii?Q?T9Nsemy5lpAJt0ULiUaIK0AEMlAK/ItbnDKhIIFoVp0lMN4turyK9kXMWfw9?=
 =?us-ascii?Q?mWh2v1uzUxKdRUfSlddSphl+8y1FDJ/oAyu+Wqu7ZgFiqX8y4d0hb59AoX+M?=
 =?us-ascii?Q?fAiicINEhLrOkcN7bxxZT/dCPRYVoVo9ZIlzTQ7MIYgFrX5oUZM2Jm9LyEBI?=
 =?us-ascii?Q?BFQi/WDVIdP04KPVqF+KyGEn56bE5/YREKzfzpXIaEm1t345MpzQpKVVU6LQ?=
 =?us-ascii?Q?NIvesXlPC281yLnMmPqczvg8xsjzo2EviBxNpen2q9gZieRk/PMeNGzqgqe8?=
 =?us-ascii?Q?3nQEDVG6i9AixvuBRhFzasqH8pN+0BPccwt1BM5MWaaj3LvAEd+5vFpZDRIc?=
 =?us-ascii?Q?VlsepoyGEefONhLp49c1o3dU4NY9dGAQUAiAAdEZIZe3tjREK5lyE/pJZsyo?=
 =?us-ascii?Q?WKe+zaZK8KAUjSr+rtBLUCFK9dbeVzTVMt8ZFOVtLrDvTT0iy4IQfqNTzt5r?=
 =?us-ascii?Q?51NnrumzVvGHY6T4ZhXYmaJ95x+nLiOPpg0G/EbyWfAomUPGyThedRlnmWph?=
 =?us-ascii?Q?zqtSQ7v05gi7D6JFaKjKeYWgtsVallRLK7UDFUiib+kqlegVTS3C9Ol8inQl?=
 =?us-ascii?Q?4R7s8HySzEeKntLRFsL1IGY8mB57pbExPZQC4WApz9jajdmgp0qoiJljJwiG?=
 =?us-ascii?Q?UHFLIZUVrcNKRje36ddNlP7REnAdsTlTaeElNWxfYzM58eiNM38J3KPRkkdI?=
 =?us-ascii?Q?WrQVMImrIvh96+iImowr1/EnxTnYn5hnVXv3wMzh4sZTr4rvxhtFRuzbBR3R?=
 =?us-ascii?Q?VfZysdZ48yD1IzU0u0QzNr7SFwR8M6tffkbtfQDVR63IBDDo1t0DKh9Hrkmq?=
 =?us-ascii?Q?ngc2KmBh7rXYQraaXe6Fh2iZuP/oC7cWF6Wc/y2142PuWY5/J8PNNIwypBDh?=
 =?us-ascii?Q?IJ/uvggKTK3E1muSzujzuYNOoceci9ZNZ2BumvEQn+ll1aeaLJcUwyEFP80E?=
 =?us-ascii?Q?7d4C6B4k5L8YPgMiTh/xjy1tmsmSN0ASZV7YaSCWXGBfv5D8pBcG7DSu61P+?=
 =?us-ascii?Q?kGmkTB1ox7o689JuPMvNwCVcT6Nk1q8/e5LxSc2n90Tx85mrSl2gCBmAkd3C?=
 =?us-ascii?Q?eUvo5FxewfrEbXmIstVp0dptc/LobDPbjO8KgrLd1rsrmw/EzyK5Xl3jO92A?=
 =?us-ascii?Q?hSA66RAYl0+M1cDBcPoPvvg9MW9Qe41KhTvGCRn6OZ/OlHMINP2zfGAUeUFy?=
 =?us-ascii?Q?1cMKf6mZp0e8z2Fe1zanqTmCueSI8Eht55B1Rtop1cHK5OwlgRRLw6CN28Wr?=
 =?us-ascii?Q?yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZKH3ITjPRIn+bj80ZEyU+Ha3ps4sWAEiwED0PXG3e8JB5TDErH41QO3GUGKl/vpICEbU5w3L8lpEsjz23+9ljll2ZcjhbbMGTfhQb57M3OL+yDg6dntScGpaGbhQMp+P8HAuVdov8sPnsu4NBLayyU4sJMY38lT1eQ4pVOWpuW95YHCNkeLanf+bhcUJBZc1G3F7MWnPqkRtag9GZn5OwkH59srKE1Ie0FySGqG9HFyY5h2L0eIYIuKPHd+rRk9+vqwQb/nGyTcD5iu0bIdBXI7CSsnHsEGW77dr+l6YbmOJ0V+QSYxsogllsx3QGp5ok+JP8k2pwAclokR9+WlUVmqHwfMb1Shay79NEwGA0O9GFFrZj772STAOWfQkI3N1bWsyh11m/EGC6L5/Grrj/2dHNrHC12fY7N+fDqLZlqKXN1K2Vbnz6JMVh81wWm0zLC2KpWHoy4CQWsPnACNrgGvvy8DbmY70D6jg9RTbshHeb1GFR/8QliLHX0u+rVp1VhJcJNHnVW3/nupnQgpTRYaXbpGvAva7NiGl5ln5vHs9qsHb5Ro4b2X6CyMxoQ6ndpiwwiJW2HE/Dd6S9BzlvblXrbAGYmCodu7HCO3UG7M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d09a4736-e595-4625-6ed9-08de202998f0
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 07:20:16.6698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mGcKQrBczmBeH/2Lk6X+vYUabS3hI4z3cNlSYpxYT08tXRkM8GNKOFRXrnMxOmScIQS7upl2/Ok08PK6ZU04iITQzaaD3Kl3IkvLc+7OCQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4430
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100063
X-Proofpoint-ORIG-GUID: aGihQElIpYkbrPxBcYbd4gOMRpCl4H1Y
X-Proofpoint-GUID: aGihQElIpYkbrPxBcYbd4gOMRpCl4H1Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDA1MSBTYWx0ZWRfX3o5yxI1psrSa
 u5QPp6ddgy1dwtNhRiR1+/LuHUrN/C0R9NaW6lmTdluhesp2TLpCpYByTdWj1NoN/ttiQtRriLc
 Rd79yyoQhvJSL5rzic85y18dBBlx5z1ZmgZ5C5SpO4yimh8gWp5YV7SAbNq1l6u8AYSKjGfCxSD
 wuyPeyaGolL4sBg2C1LOycBaKh9ri9C54bZXFdxqAmobV7pm/5q+Srak4m36jKUngaxiRJ8N8K2
 QmRta8132zo3hlb9G2r70X5TIWD9DVCZ+6haweAxLoXcI4STTMW5OnZm60bApEG82Wk0rh8Lnpp
 K0H7yeELAJqNL5MOj6CHgtzt0CSL+OlSkgT1idQ0ACuYu3vC1BVP/rT/yQz7FzYwl4LYkAG06aw
 AEl1O/xMykniM4f6mcZQIFOuHbVBZMfPzb99/AkrOeIHwT3zGug=
X-Authority-Analysis: v=2.4 cv=DOyCIiNb c=1 sm=1 tr=0 ts=6911929a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=zd2uoN0lAAAA:8 a=wmdhT66umMbkSes6y3QA:9 cc=ntf awl=host:12096
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2683740002
X-Stat-Signature: a3bn7qepxukmu334rcknkzxzeepa416g
X-Rspam-User: 
X-HE-Tag: 1762759344-638533
X-HE-Meta: U2FsdGVkX18sGqqbYzI5Dz1MXbKEpFAOx4IBYrJthO0meVEXP9/ghxKt686jQkZlUaVWBo9TjS5ebugAPn2/EeC5GkVf9cq73MFlSlhqF+KbaUASBxVx5calditnPdILrHZNZKEq6QdbQ4W6Kqn0Fo+/Njot2er9rbV6iOTWrSK48c4ymoem8zE8AKN3tEXeos5ITV6+nzfDxE/dcsbbvHZpw8vmRfrP7PwHrGzRdZZ/oqSdtrRc1aXiuUDOfBsSUOxt3hT1chDT2+Lqp3wEwdW+dUlvIaTQh8SBMndOfLKiaR8fnEV0ibyozt9M7kSq00rijzGS752PurT96g0o45jKoN5FO4MNtwSVZqJwvaxYzzuuGpdWpHJPL/sBz8L0Izkk25WmHq4wzYP9n6OdCJiQJ9zqtzltl0MkycsMadlyYcjg7ZMpVAFNDmNLxEaDpLtoplR+yIhrOUcFJ7D55gRiiXYE0qEmHUhwwveqzg87zA6SDSN+Q+cSDNQ0FQv+3JkfwK92yoiBnb/HgwR2Apv2c5jx7gt3OhIJMuBgAjcDk6GvncaRrkqzZrlNp5Mt/lC6dJqGJKKb9/5q/qAnBaYZg/STVM49G420CtK0ywRyd6w/u+8IV34bX5R9Wu4yWMW1DY0XMWB5w9bVEaGnbrMjZG+J4kz41x6inuVs5EZBFcLrY//6EgQxiLRlGEpY+vo0KlCuNwgAyIILb9AAgfTJRcNDXg43Ajid50CFYR4Dm6dVQ9u/0Dt8Hh9D2CYmyiX+B09K+dprmk8R1eEtpEi3MbhagkE8zKrwG2tdXUeLKJ7aIxs+k7EkqBCNrEoEHHRjskGZigbJ+F89TqcRXKEQo9jB4nvw3UgZdiDvruZ38u0S+fGcILnYhCfvq9v2DdzJq3ymOYKlrPJxG5yhVSJ8qHOBlIGmu5U2TXBqeLgJBYQ/3LCdCRS/pdmJOJIfRxep5eevKgXjHqaHN/x
 tI4PAY2c
 Z0JUSGUTRISrjrbIapPr8Fg7BFROsUcbuIJOVLxKDqYAeJr9vBz2jWvd8F3hDnwqQeBTICi2PUyAfwjaPAC03X8K6ccIl543g6QKc3UffanCIQLWpKO1SOL+rITpxx5xue3aOCSInjizQBiBxig/uWzBDu0Zc9/warrwppqo/o/4oBXqboebYID4W3Mvjxas3/wq34lrx8BdgnJtcUyw3CsUOZSsfMq4d3dZQqpkrPFKzugVID8kB+gDv1y2zs3xEKIJ6JLk+6YcnQ4V8VIPRf4MK5gRaq2fGWrOfr+eEyeAk9cna885IPAzUFOi/bZjwY3VnywYR/Lt4ZPlQEzXmM/LkAX04C9zpAE6U2dD0f5Z6jmJY45COVUaCKQ4t5nr2MZsZjjCjnG3At8pGAzSS+zLH/BKCspnlWW76KH5krjuHxpXMumHcv5dKWO/o4s3wppkNNQhY/GmAY23gNkS6rS3SZooFrnOhM44lcW+pZeNQlaqLiGWEubMOwbKOCyATe9Jl20WaRCD6nnFNULaSXk65qWlJGd0FwQRjllwvPessA/OQLVK17+QyPaVfj0I9lOXls4fQ2plspGlWx2toUV//FoTGDGUQ7R8PMBlY+/+7SWDtymsENRrlAmK0FUSqQY3S6i9ISm2Phkz+J+mIHNC1RobI0Eb8Xyihob1TKAlwn3717T5uGUcO8FuM6/TNH20UkfwynovyTVgctZoFuSIPWIQTQRL4593R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Red Hat) <david@kernel.org> writes:

> On 27.10.25 21:21, Ankur Arora wrote:
>> Clear contiguous page ranges in folio_zero_user() instead of clearing
>> a page-at-a-time. This enables CPU specific optimizations based on
>> the length of the region.
>> Operating on arbitrarily large regions can lead to high preemption
>> latency under cooperative preemption models. So, limit the worst
>> case preemption latency via architecture specified PAGE_CONTIG_NR
>> units.
>> The resultant performance depends on the kinds of optimizations
>> available to the CPU for the region being cleared. Two classes of
>> of optimizations:
>>    - clearing iteration costs can be amortized over a range larger
>>      than a single page.
>>    - cacheline allocation elision (seen on AMD Zen models).
>> Testing a demand fault workload shows an improved baseline from the
>> first optimization and a larger improvement when the region being
>> cleared is large enough for the second optimization.
>> AMD Milan (EPYC 7J13, boost=0, region=64GB on the local NUMA node):
>>   $ perf bench mem map -p $pg-sz -f demand -s 64GB -l 5
>>                      page-at-a-time     contiguous clearing      change
>>                    (GB/s  +- %stdev)     (GB/s  +- %stdev)
>>     pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%
>> preempt=*
>>     pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05% [#]   +  5.2%
>> preempt=none|voluntary
>>     pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21%       +144.3%	preempt=full|lazy
>> [#] AMD Milan uses a threshold of LLC-size (~32MB) for eliding cacheline
>> allocation, which is larger than ARCH_PAGE_CONTIG_NR, so
>> preempt=none|voluntary see no improvement on the pg-sz=1GB.
>> Also as mentioned earlier, the baseline improvement is not specific to
>> AMD Zen platforms. Intel Icelakex (pg-sz=2MB|1GB) sees a similar
>> improvement as the Milan pg-sz=2MB workload above (~30%).
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
>> Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
>> ---
>>   include/linux/mm.h |  6 ++++++
>>   mm/memory.c        | 42 +++++++++++++++++++++---------------------
>>   2 files changed, 27 insertions(+), 21 deletions(-)
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index ecbcb76df9de..02db84667f97 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3872,6 +3872,12 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>   				unsigned int order) {}
>>   #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>   +#ifndef ARCH_PAGE_CONTIG_NR
>> +#define PAGE_CONTIG_NR	1
>> +#else
>> +#define PAGE_CONTIG_NR	ARCH_PAGE_CONTIG_NR
>> +#endif
>
> The name is a bit misleading. We need something that tells us that this is for
> patch-processing (clearing? maybe alter copying?) contig pages. Likely spelling
> out that this is for the non-preemptible case only.
>
> I assume we can drop the "CONTIG", just like clear_pages() doesn't contain it
> etc.
>
> CLEAR_PAGES_NON_PREEMPT_BATCH
>
> PROCESS_PAGES_NON_PREEMPT_BATCH

I think this version is clearer. And would be viable for copying as well.

> Can you remind me again why this is arch specific, and why the default is 1
> instead of, say 2,4,8 ... ?

So, the only use for this value is to decide a reasonable frequency
for calling cond_resched() when operating on hugepages.

And the idea was the arch was best placed to have a reasonably safe
value based on the expected spread of bandwidths it might see across
uarchs. And the default choice of 1 was to keep it close to what we
have now.

Thinking about it now though, maybe it is better to instead do this
in common code. We could have two sets of defines,
PROCESS_PAGES_NON_PREEMPT_BATCH_{LARGE,SMALL}, the first for archs
that define __HAVE_ARCH_CLEAR_PAGES and the second, without.

The first could be 8MB (so with a machine doing ~10GBps, scheduling
latency of ~1ms), the second 512K (with ~512MBps, ~1ms)?

>> +
>>   #ifndef __HAVE_ARCH_CLEAR_PAGES
>>   /**
>>    * clear_pages() - clear a page range for kernel-internal use.
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 74b45e258323..7781b2aa18a8 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -7144,40 +7144,40 @@ static inline int process_huge_page(
>>   	return 0;
>>   }
>>   -static void clear_gigantic_page(struct folio *folio, unsigned long
>> addr_hint,
>> -				unsigned int nr_pages)
>> +/*
>> + * Clear contiguous pages chunking them up when running under
>> + * non-preemptible models.
>> + */
>> +static void clear_contig_highpages(struct page *page, unsigned long addr,
>> +				   unsigned int npages)
>>   {
>> -	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
>> -	int i;
>> +	unsigned int i, count, unit;
>>   -	might_sleep();
>> -	for (i = 0; i < nr_pages; i++) {
>> +	unit = preempt_model_preemptible() ? npages : PAGE_CONTIG_NR;
>> +
>> +	for (i = 0; i < npages; ) {
>> +		count = min(unit, npages - i);
>> +		clear_user_highpages(page + i,
>> +				     addr + i * PAGE_SIZE, count);
>> +		i += count;
>
> Why not
>
> for (i = 0; i < nr_pages; i += count) {
>
> Also, I would leave the cond_resched(); where it was (before the invocation) to
> perform as little change as possible.

Both of those seem like good ideas.


Thanks
--
ankur

