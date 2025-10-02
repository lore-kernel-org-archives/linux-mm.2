Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9A75CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 01:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58038E0006; Wed,  1 Oct 2025 21:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2FC48E0002; Wed,  1 Oct 2025 21:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1F258E0006; Wed,  1 Oct 2025 21:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A35768E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 21:15:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67C731A0316
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 01:15:23 +0000 (UTC)
X-FDA: 83951406126.26.1B1E5AD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id EB0F480013
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 01:15:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hBddSyhO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KAAOAY6d;
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759367720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkrTV8MDIYvmnKrgkZQ0xBaYKJw74WFrfzWQ/F980+s=;
	b=yX+eVYr03dv0Czf5pONV41vn9hda+11NnY4GRLcNaPFbauen/xw4Xu78E4xY7ErTQCCY9I
	LNm2Tss5TXVTsQFnQCO5aGTObqKVDTmc26/ey3gzC/iImsTRWxaUxo0h3YXTArW6gMF3wW
	OlqoSsaG9fZZa/WIa0mUUJxuVzVIi5g=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hBddSyhO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KAAOAY6d;
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759367720; a=rsa-sha256;
	cv=pass;
	b=tHsUFxDnQcyuybuC0qLP3yAXqQwErXqLKfF5PhZpQS5PdoiPiBsgRuBxGWYng11hkt+z8U
	xE4sM+o1p/El8DL9JrtChTlNAZhlnzNAhHcnDvdPNsy2CKCuVYgYwTEXcauZ/u1tPbXXuJ
	dWim8JSmz4S3HyUbexwHeLYN3xLk1mQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591Lg3cW016404;
	Thu, 2 Oct 2025 01:15:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wkrTV8MDIYvmnKrgkZ
	Q0xBaYKJw74WFrfzWQ/F980+s=; b=hBddSyhOxeYvc8OaDqCGVYc+jiZvoWQRpM
	mjHcCcV5Q4YgfUA4Oyb+t8jFcxrCFGwxEphnaNPsqQfYrFbZawsufB8U1iNswji3
	019TAvI7p8qHx+m8UB56RXFWercI+p6QTERTzVS7nca9UGcVNhoBBALMeZ4Xk2Zn
	n+IcvogUXH+5RMCoUoDGF199ZL2mLGnX/gltHs0aHv2KJM+RsHxK7BI5Jfmwncwj
	PqhbBApZqFRIGhdDOsj/ri35UTz/qs/mrshpc09Zly1mK//T26xr/KlUM3jCf+oE
	g4+zhH79Ip8pxuUGSjeQ8xp6YLfWZa8pdzykXsZkqYdiNOQ9MYvw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gm3bjkb3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Oct 2025 01:15:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59204RlH000349;
	Thu, 2 Oct 2025 01:15:10 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49e6cgdh8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Oct 2025 01:15:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m/ZmGVvC3g30Nf0o2ruLARes9SEdngxtRqwUZom7kwzi5J98xZktEvXsly0fJuMmYGbaLq3mey5GLuhJrrI+22Z+JWbxih1hW4nJXmkd+MpuT2054LVgySMVDSvvJuslpC91vn4UGwEfk+PUeAG0RGAaqMw7MU/TE1qci3uCsDjky1o6B4rIoa9cVRnz15X2OuDIvWdi6NO2OQv0BnW0vR52CNw+g0wlZUjAsuN/U0NQbGuCM8NNPGjCQA4ObNjdnq5kww89SMwvALPKl8ekCWqQU6oS2wxdRffbSkIZKu3+vB2Be+Q2jm4AN1AC6jYvbK47NL47qpa9RxQKcNC0Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wkrTV8MDIYvmnKrgkZQ0xBaYKJw74WFrfzWQ/F980+s=;
 b=vW51t0LxR+sgTsZRC5jP+Y1rLB84bJn/XTasm8fYp3d6Qbno23Aw++h9PPSw5oMcvEumAw0+Scg8L+/w7wAi9HwXs+btizXPrkBnt+rWNyaOLeDQ0+HS7ebAjF36fXcY+7iYdHRMxpXGktTJ8ZaKyiGrrIg/OT7R1Axy9kSkrWqS4flYUZ3C1GLsoYGzTkF0woCBl80yt1Mp7mnIX0i7IXhgyIYOeKfQkG2X+c5IQ64S8sAi91yDg9NJBex6HPMvRVPgJHukUSN5kg0d9rzyFiFU1sLkCKV1ttqwAkq0gRA3mv94tusuz/fELYuuXJr4TLHhR6DcP44aWaZwEqSiBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wkrTV8MDIYvmnKrgkZQ0xBaYKJw74WFrfzWQ/F980+s=;
 b=KAAOAY6d4FeTMeWkg9JEXpJGce/Vbka20FO5vE3OALmSfdqXOpVZSHLlf3NTk98d7p6xZPoo8DiN0d6U8/PWsDHN0uzPevivL09kSnjoAZ7ut4mHM7SaD+L15Ya44Eeu81Xkn5CyelTkeuPnyiwopDeqcN4vEQ01GTUWHupI+Cg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB6612.namprd10.prod.outlook.com (2603:10b6:930:54::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Thu, 2 Oct
 2025 01:15:07 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 01:15:06 +0000
Date: Thu, 2 Oct 2025 10:14:54 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
        peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        baohua@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com,
        npache@redhat.com, riel@surriel.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, jannh@google.com, matthew.brost@intel.com,
        joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
        gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
        usamaarif642@gmail.com, yuzhao@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, ioworker0@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
Message-ID: <aN3SDmKeVqIXwGfV@hyeyoo>
References: <20250930081040.80926-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930081040.80926-1-lance.yang@linux.dev>
X-ClientProxiedBy: SE2P216CA0193.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c5::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB6612:EE_
X-MS-Office365-Filtering-Correlation-Id: e9a5b411-ebb4-4dfd-e3bb-08de01511f77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WvkcDUrgeJ5AvH2gpMbbuGszbEqjofhVGyhmmNIOzaPsfsiinr1B5BXg2pEm?=
 =?us-ascii?Q?Pp4TsXzkw9RGQbJhrNEpzB3QtrqYGVMNbV3/SSnchxqKcESdDFv0l5jWpWvN?=
 =?us-ascii?Q?G54AUhGlnJpjh7KhOo8R06Oi241E64rlee5nT3GXZXAL4HFJyDDvzZGWXPCQ?=
 =?us-ascii?Q?l7ttvLyUEWpSND/jHWlmxb5GIASlPe3Y3xVF3MGJ+qlvCAT4AUVC2d4D/Y+i?=
 =?us-ascii?Q?nF5vezTFhNaA4fSFBl6rop25MzumUvHyxVvXj7UV42GAhujOmb5G6hK2Ft2Q?=
 =?us-ascii?Q?OfSjS8nmX5vFZdrm1LE4MvcF5offuxMdxKMdBSOB+97Xb/9y3LeVRvwAPjuJ?=
 =?us-ascii?Q?Fy+GNXq8RO40U5LAEBXBaGuv50HHJnYXo0BBFv5VZQlT+Zl3wSmO71c8AQ8o?=
 =?us-ascii?Q?9DIgdiXscfDwhlV8maQ0s0cUy/b8mypmKg6GAj7zOSRKKOGZylMWlZYElDWd?=
 =?us-ascii?Q?B24cpIAeBiE0QZABisBRX701uWDlRSSOF+jWaEx+nNOUAjgL4k1ckvMjcjt0?=
 =?us-ascii?Q?1czda5c3HeDm9jtJIimctmUClAOiRFennaXhEgKrjeJ6rbeRHBlxJlPBi+sF?=
 =?us-ascii?Q?biGloeBsf/sfScdD7KsLJVArX37BsWkCiBWnVj7ZC07NDGLf4fTN85250xE7?=
 =?us-ascii?Q?BBJvaLhOkIUT5OHUU9z6mzmC1syDyxdWD/8KAAji2m/k4+fxMW1lfqXKnhqt?=
 =?us-ascii?Q?P65sJL4EsQl1wvnEnYMCK7K/Y2sNBE/c7OJPkiZhRq2ewDfi+WwnWGZ+oBMC?=
 =?us-ascii?Q?7TZ4dtrLjLXBlH9s91552RcS/JIfDxWxDGKqhbYYiTIaFvioEZf0WDm//uLI?=
 =?us-ascii?Q?ZqzpmTKAbwMOnj4Llwy+7beAZzruHo9LVR12/qSG/z5NER76PVS/IDkYVZM2?=
 =?us-ascii?Q?WibnaCJ9Yy9kjqWNeQ8GywbCbR+4LoglFU6CptRHUoWrcyrAVJvNc6BCyY+e?=
 =?us-ascii?Q?U3tlkuZHw5eWntIIPFjELhbrZlhsi+jChDuDI+Yp8WscfjxM5jVMDpC6oKvj?=
 =?us-ascii?Q?TCIhcFjzmQscaVg++TAiv76EoUtff54qJMW/GhH7vzjxwfSqRNGqHdeJEP+R?=
 =?us-ascii?Q?rRxBH1wbOdzdHgxr7r0XpZ+6MWGJHCUHNVTaGlFoT8Na0f4l2qIchx+EhHPy?=
 =?us-ascii?Q?W8osIx6ScnUf/SXdSxc9pFx+MDafdgpCyKGGaCmzsxFitDh47dCgWtUu7HgR?=
 =?us-ascii?Q?1tSxr97u2fKwcgsBRuoAk4+vUsZmm9swofJhXn4riN586xyT+wTDe4Lu5DzB?=
 =?us-ascii?Q?NbL4i+btNO7jBcge4e/1wc/aF+F/+YcpuaiB4fZ15TLSFOJ7JaAmmtDDXAeB?=
 =?us-ascii?Q?tolAm0Fq9uqPYGx5sNg8jQYZfdhiJkswEURCEjG/FgBGV1MQNugr3Kh8j/Nx?=
 =?us-ascii?Q?N7GCyf0QthCyUYuihXkYlrhr8OVGKC0UywCglvSiXXFDzXN3qH/F4SYexX+x?=
 =?us-ascii?Q?GcoYrcf2aqLy/joAQVpqBz/aXzT4+U1a?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/1/c2sgy97Nn7aitIEUj8tSpu/aoFf3j/SUjmEBbk/5Eu9O7hN+HoPL2Q2O2?=
 =?us-ascii?Q?LnIQ/hrpjLs11JuyNJ3jzyH8wlAFhimXvOA2Sx73OHpE9lDPVsZwFrX9qKY5?=
 =?us-ascii?Q?eaTmas6KQVkja6UF66Kp3psu/EqStb65JkqY0yr2G2/2+AiCg5X6r9IerzAx?=
 =?us-ascii?Q?FaGxKgpaNaEXkTnOgzYBw3uIQ6CooGKa50zyTWD/xibQT4We7jvnpe9uLfgm?=
 =?us-ascii?Q?bS6lSANlsVw7q//W+ne3V55SMPxW1RaTmnB9K/5TC6kPCr/giArx4+3Eatjl?=
 =?us-ascii?Q?sUPAJe+nahPcmDtvFtZUUsBNTVdIZ6sLq1Cimc+rlivtR0SR24+Ht9ej+t/f?=
 =?us-ascii?Q?K+LRbPJHQk15wdJs4koNE76MC7ODkbPXSfupP+KshjYpKjhtHo4loJhWGicN?=
 =?us-ascii?Q?HY2p/WP2ibpPkrZUhe7FZDWkRjOFnzRK8NsVR4AODR+7YNZWIufiwj06hnDy?=
 =?us-ascii?Q?m3nWjH0+nFJT3cVMb3BJogM6O8lYFxoHnYVdDHmsu5zldsNxx8PH7kNm4Sz/?=
 =?us-ascii?Q?9ssgT0iaaCDF+1fmaMUBljXv+lEsKNDAWbGntX2Pa+OV2FBCrFfQcFud5bNj?=
 =?us-ascii?Q?dwwqQQTGNxqjwIJ282hIxN7bT5y5nbAtl7pG/lnfVShIGzPrXGblB8GegqzQ?=
 =?us-ascii?Q?eUcQ6zr5TxQiFaMy/SHEy3YEmpt5SLIqlpmgOCpy550sSChuAOm8nBhCMWlx?=
 =?us-ascii?Q?3KABm1ws714l+tqvEmR7oT03F7mJapgAc4B7yXXFsoTC9MG47wMVPPdCTBmZ?=
 =?us-ascii?Q?cqEgf6rkYlVPF/ix/FF9xZ5wrX+HU/GytaI45fN/PsEvHdYA0WwwyMblezKT?=
 =?us-ascii?Q?NvkxojMQ12EvRHDAltF7PLu+z3jKotIvU/mqW6PMNGfMLuw7cu7cl3+MiPWx?=
 =?us-ascii?Q?6OjlgDF+GRXV55LAqn1OS+vmGHxWlgOtXVT78rnPkOtPPLPPTWXqAYx50XTK?=
 =?us-ascii?Q?SfJOoGX+xRet7s+gFZSKfJuQtPGemxEvESNdH3JLpzwDBEzPm6LFHzfpHzuL?=
 =?us-ascii?Q?8vn+YB3UIEe0gQ0qzBNc5L/eMqpknvy3+aCuN//no8vzVGdBmBM3/bxdWVd6?=
 =?us-ascii?Q?AEbENzFsloPOnkkxLd9h2F6URNAaFPmN06oSr843OCY6tnOw3tBHtuEanU9M?=
 =?us-ascii?Q?8+AnvRPN9lx/0IaT5ebD9oMuN8PDkMJaQjz10wBpf9Rmz8jvUpsyPBVh5nkf?=
 =?us-ascii?Q?e1QHH+9Pu0GAasoqMAja488URM6vW5UqRFImG68y74BB9o3/cDKyrvm4Dmmq?=
 =?us-ascii?Q?hFSyYoovI82v1iyy8LRzHpYwnoWYICKOoPtvOhJ7I6k1NHTOmNdHsSHK9gcU?=
 =?us-ascii?Q?dHTq1mQznqWf5qcCzgEVMkKQ/yjb4TqqO74sjpT9C2vgIXpo6mE5kNXZLvCb?=
 =?us-ascii?Q?rEqUO0ZVWVcazrbXSHtY/2Rj+zBw+L/gU+qFknnbx7jCM7LwxU4Zz5yngNpv?=
 =?us-ascii?Q?AgRIpj6hNF4YN61Q3n4t+j+dj0Shzq4ImwdubOKWt9LcmgB+iGGLWyWPKBNK?=
 =?us-ascii?Q?Z7m97Uadsa+h1jU24ArRJYaC1h6O2ftXpTEV0DoHODnmsrxOayh3u5HPWQIw?=
 =?us-ascii?Q?lPdgS5wSE8Awu6whCVfz11j5mWLIrVMmAQ1OoE2/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BEfT2VwM55XGwYO46Gft8mdhrkb+UWkwA8st5yhMrnDvdM9qzKeuonwwv+aAC/BlE0pYHO5H1hXhPSye4tSssbr0dz1i0ub7cyQSWnwFpnr/xCrAdSkiQWCnjDwp0WPHZUnnTttB66sgPzaYdUainrVv14zM9d2IwVmmRX4KV1WDFvJBCb16zAtU8ftM+XsNkjzlJ9hDjjM/luZHdVCiruLXdUfkiznLz4qzVgX4RCqXZDo9AQn3utGZFLJuingZCooMENpKbgagGN+zBsdfb0v+l0oObqbAqShWc/j4JncGfoTWMoF3IGYNJukJ5AXL5J8SyGrciTjzefCcYtnTEnhlnLJ1IB5xA3xQYdyOybAnhxpcpVRIrLFVjo3IyHrJDuP1cTUjKMWNvq71pD0tps7MRXbIfXRQOZ6ACaBk5W1bd6ZpVqhnTzvjHgvb4lo4QvY5zO/u1KP80tEx14QiXz4pHEJizpx5RHQGYLvInvi2acNs/CKxGJ55Zd8qvEnBXvFVycna3ev/CQaLZXd8xI2Iwt5OMs4ALznfLe0aFtvLKxFzUFk3dcqAB/+9kGIkCw002k9QbGcYioCOf4ggaWEajS06i55X6a9JPDipJz4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a5b411-ebb4-4dfd-e3bb-08de01511f77
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 01:15:06.7867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NmdLomi7iTt8C/zLw4qIFvXCN///CVt2sT/3X8PA+jmtBFHu0gr/WElcENfwERHXcyDk9WzVNUaSTZ1BuR0IOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6612
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_07,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=754
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510020009
X-Proofpoint-GUID: -wegKgRID_kNnutkTgAU_qJpPOYbqu0V
X-Authority-Analysis: v=2.4 cv=GsJPO01C c=1 sm=1 tr=0 ts=68ddd21f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=7CQSdrXTAAAA:8 a=yPCof4ZbAAAA:8 a=bqQlsaOvPmgy4kHRsZoA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12089
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE2MiBTYWx0ZWRfX0Sv9uTvFfIrl
 s0CZyeks1ZfcObgaB6mHZPDAeZ5zJJLufOXqJbAbktgJbaknxh2LkkvnGBIFWrKqxu1noKpxOWa
 xm267yeDKzZYE0hqCbTlJqdzob4Oc4RvgqX7VD076nKaJMYgVu/iFrycWUMIW6cfc+Sl7N2EOJN
 t4QgLHybVYWcWyr+5R7hZ/hR6P8529vRO5AjYV14ail7XKgViUKZdRuwL6KCSXeOCX/rrKFGC24
 7SYrv1ZUwvqPcIOupRhyflFZ8GLZz5uy7ja0pAOydu0P9eXAVkgZXyCXNqvLoEcro79cQ4jfaBi
 EKkPXZ5KKGfGuRNw/qm9RoFsF1aytKSuRHvfwyn3PasyOsBZHJITNiEnYkpVFxt0/TayfM4b9vt
 TmIa5JhLcdN+3YxeXbOPmw4UekRMFKgdaaX2bXWcVy9bhamRz50=
X-Proofpoint-ORIG-GUID: -wegKgRID_kNnutkTgAU_qJpPOYbqu0V
X-Rspamd-Queue-Id: EB0F480013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: os3pixexrn6hatgp4ksuxnemsdn3b14f
X-HE-Tag: 1759367719-116704
X-HE-Meta: U2FsdGVkX1/dbKADTtFdGSVoVfKhR+/bTTVdF+RFVcxJne/sYKqGpf0lCzhA0wNDMz0QghTpKzTyX/3NGj6n9tSXEyoH8AtJ3sVE9ODxPmhy9VO5XXl3TPhaNQO6iAD6d1LgGgzeUra+r0/kVQEwqVAigXYXLKMu/J+/BpZcERWSa9wmvd5BkFDY8HnlAHLqvF2NJheZcPGBe8Vimuz7vK6eTMS0kCwJAZt6uKFQMkdvQiRwd7EqfifhtFIPqaptkCd5Kytfbuh35LmsMynWKrBQMPTs+wLvJdFs3iRRUyVAGX/4yk/b4jAQba74MhCCF1DiyubTCcGbqnT3pUW2AlOcHmFLKtEjlLNnM5lMgiIeBZKpu1I85XdYUGoaGtvSXb4o0D72YWNxa3BXhrCaD16o1Z0RXP6udWBxGpMdw5eqvVnWSxIPxAd0tdA02C8PcrHld0RZkTRTQP/9JWyTVXtSrXfosK6yceMW3eIoLkb3OalJ0Gc3MczFb/Ae4pDT6HMVjE0vktaLFKwTFpDUnx3uFdIBnQvTzDW2iDtXBH+vGEDkANWgUMr6G/0nSWeDLg35bK8qp2DgduSPXrY1YRLe2WmxSOsiUtuqMCmETOO9GwIUh8o/QwWw8tCyywAX/GdS/q5C99yKYtF7+rHM21Fp/sh6AJtxJud6as2z92zZ1hbGq21W1jaqgUKWzz2VcRsa5zxwsCqr4S/TmJQHyDLm1GaetTSH7HvmMTA0Zu8gFzZyHCFtQVcst/tyubKMczlssiti4IXBwnpMyKf5nleODysm4a6p5VuykfDvOdbtB/aJumjbGJ5Ur0l7KTJamUsMQrQBYHSeIjWl/DAhR9kFONqJI7ccN0O15b6cjtQxBb0u5tpmmnL9FvWIRNRSoHJEIVDQZfvAYXjQ0kqttJYdUX6nkirLSQIJ86oVy/6GH2qQbTj7eed3A2o9adAucpJtDxlSHAzn3JiaqKv
 d8GoUeoP
 BWEA/A+wPDbs2mSx85yjmadtsQt/CZxhvFE5G3EBHIRdffnBnejPddDin1vhI29atbRGVE1MHSOPClXtqoZ3OpVnbk1vlN8vJ+R6XyhplBRaaS1koHVmnzyC6ZTD8Xf8M1LfAHXQ3fvAbXii/5juxUsLdoy/VxciA8nK2wzPcN953OAeFW/FRjahKiT4+Y8lYwxCvWUGg8+FnLHhyCUjLhapkvUdhKQcsmVycXORBukGhcNyFjWOV5i43kLCgbuOV/SjOpYuZQ29kQrNIkRoP6xIB1W5AWb6ZpBBg9dKzhLd0GR9orO25eX3fEu1t7uqXfAkoPli4Uy/4JlJXs9/o9Hn7p83pP51QUREtWM56yW3NKwqsHzDIBXBZjQVQRWjfYxZCXSaxMb1XTwGfrnwPkZFeR3zS70AlIEbEiU+ZSoHJanhWke5lF0etmPTsQ2W5VLytqYiwbI3F0ny7zarfRKfaoQBk7lQ1X+KP3bsMftvABmJqauUl5FZ1fc1Vq56u8QRTU1EgZepg4FXwkEEOxr8oiZpiuTtMlGakWGftaTW7PEmjIaQiUU48JJWoAnM4Uq2nssC/OETCeVmWd+iCvmxWGnkEpLOU9the8q5Vf78ItaME8WnN8LnO7+aRD2Ds1EaKb8uMaALWOjfrareqbqsWjd/nbLpf8OfexcKwauCNXDtMxTpx9Q4tho5Fba4MAkobxO9quOUMy0kRvf4eCw7S6yezZByMSuf67hrvvXZvGb751BXBjujfog3VGT6JJQVR/J9AxlErlB636Nkk5ICYQTp/RHx4GyViB0oqS48LEPC7M524X8iMPjLLjErxJRIXMtWDvwaZ5io+I20uybnOzduKPjKpF32dg2V7cbma+Xw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 04:10:40PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When splitting an mTHP and replacing a zero-filled subpage with the shared
> zeropage, try_to_map_unused_to_zeropage() currently drops several important
> PTE bits.
> 
> For userspace tools like CRIU, which rely on the soft-dirty mechanism for
> incremental snapshots, losing the soft-dirty bit means modified pages are
> missed, leading to inconsistent memory state after restore.
> 
> As pointed out by David, the more critical uffd-wp bit is also dropped.
> This breaks the userfaultfd write-protection mechanism, causing writes
> to be silently missed by monitoring applications, which can lead to data
> corruption.
> 
> Preserve both the soft-dirty and uffd-wp bits from the old PTE when
> creating the new zeropage mapping to ensure they are correctly tracked.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

