Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 340E3D5CCA8
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 10:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948906B0005; Tue, 16 Dec 2025 05:31:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5AA6B0089; Tue, 16 Dec 2025 05:31:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AA406B008A; Tue, 16 Dec 2025 05:31:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 666D16B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:31:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7D211405B4
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:30:59 +0000 (UTC)
X-FDA: 84224966238.04.6662ADD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 670BBA000F
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:30:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HSMrIyA1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hF4wUgO5;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765881056; a=rsa-sha256;
	cv=pass;
	b=dMVBvGMGr3KTa/gST3ofacJ+PGVkOpFs1lkCT26hom5CHNpeony1QTOsylTnUisQ87Y8bA
	XPXcWbvLsoXcVapKhSn+Jgp0LMFvdweh3LkZ1ZVXNL2ZqmfkNIKysAqUEDn78smCr3zm1T
	xy458OvJejAvJYUGD4yal9FRvS/PIRE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HSMrIyA1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hF4wUgO5;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765881056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9N6A2FTV3LYANZLXTXIuL5k9Pgpxbpo5pkvcc/gN/pw=;
	b=G0OQ0TfQP3rwJPn6snfEMugngHlg4IgYzlZNyGyLX6a3JS6S0YOtCjDUHuNYzKVdjcV0aM
	m6YWyuLPcxZ53xmfh15uhr0Juo2EKxg7Wrink6TlcyuIKsKOq/XHGFEC+ahkN5HN5J5Otf
	ILj7jOvm8kOtm4wV+lYvBtDqm52vKfE=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BGACD7c173463;
	Tue, 16 Dec 2025 10:30:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9N6A2FTV3LYANZLXTX
	IuL5k9Pgpxbpo5pkvcc/gN/pw=; b=HSMrIyA1E0htFKxC4D4um/Kj2S1qB239Oq
	F4SRbCElE8lMRX+U9ShEbm5YUXZNa+F5YXDkVusOdokDRa11qdq11ggnno2Wwt0I
	gCoCg1b1VJY+XAXSeqDQxmnpVKPvQOZ/u0rJSSDpsuBCPSpJLMqALuWGidxF1pPb
	O6c38gnWaQ1yVZRy99HI4brJxNNRbnZvTl0RULXLnKwgBqQabWf+2S0baBRPLTtV
	1MGSdqyJgUOnn19RrchFMUvaWriI0+O3hx1VNAUtLPQpY4gRnPdpt8me1e0jstL0
	PNJkHYl9AbZbVAvoejSIAaYtZW1U9rAv6Ofc/f0zRukI+R6YPDZg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b1015uq0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 10:30:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BG9Ua30025214;
	Tue, 16 Dec 2025 10:30:53 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012071.outbound.protection.outlook.com [40.107.200.71])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkaatd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 10:30:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VhKyGW9MSQWcXpT50u/ARpM+XwiN/JFRKviqxEwb+qhXPLiO53dQnSVI+dxBh+sFj9DNvookKPo9M5/b9tM1tzTjpNoiFzmqTHOH8jsRqtbw56k1loJT1nOD/2Wa/xuNT4X31QaMke2OgaSkSCQxPQNm7HyB2yrRacbMGCWxa3WQfq7jGIa1l7dYfBhadQYm86s3v68M4WjafKUYx7N0Xa+1N3f9T6Kvx3YO2BIvdfUV+GzGlJcG9U/VrBfBdm4r52ldn4L8Zkb0eYux6oBKQcR4BglscQs8T3JnX/nVJtWMBfNL5jTy8njsN7KbbhOCcoVtaO9crIA4Q0H6GRu+nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9N6A2FTV3LYANZLXTXIuL5k9Pgpxbpo5pkvcc/gN/pw=;
 b=rNma5u4t9R47bOwWmIJD6/8sMyoEDieGMv7lhFXTSJZrj5p2jMgm7U9Cyomy6pJzhnbqaHbKhWGTAvGRVQJ/dX+1YmYPQoBn4h86hZKDNDM1KIfK6o8R3sB2GHa+GFVWJIuD19ftMeKKEVybTx3XKXpAmfVGL6fPKfSbAeNNQIEYHIlEC2orJlMZ1JxL/l3PPH7O6XCccGZw3GRpGX//YXm1If4Xs0K9Df2Ebf2Jv9YsJ87r0iUcvFHZtsUStJkYn15+7qW609zJZIXgqBJEinVt4xcVQr+oJu08QBb79XoJPIRAzAiilND+aiEtPBLGIcj2eftmH+J+JqJ+wfyyEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9N6A2FTV3LYANZLXTXIuL5k9Pgpxbpo5pkvcc/gN/pw=;
 b=hF4wUgO5AF67rWuEAG9wlAnuGb0DhnQz5Kh1DDl0tth9AiU4iId0G6UbgV60dYyRJ63tLRuCGX40+Jg3LGOcYnXjRo4f7zHt3Jc4mlpFXszVsDlbsSzU+8fUXMvBuh2QzbZMlvQj4YAXxH4e1cvPiH3q0ViE3w81FT5d13z/hhM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7585.namprd10.prod.outlook.com (2603:10b6:806:379::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 10:30:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 10:30:49 +0000
Date: Tue, 16 Dec 2025 10:30:48 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Gregory Price <gourry@gourry.net>
Cc: Jayaraj Rajappan <jayarajpr@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Calls to do_swap_page() from handle_pte_fault() on a system
 where swap is not configured
Message-ID: <13508e8a-ef12-4c1f-a3fd-9a8f1f547245@lucifer.local>
References: <CAEJW1wECyPh-wbgnnoOGY460ido=U2A3rPhF1FQAv7txed1-Rw@mail.gmail.com>
 <aS_ycQQh5n1cVIRk@gourry-fedora-PF4VCD3F>
 <776ac4c8-6e55-468e-bb9d-eea49de0ed89@lucifer.local>
 <aUAAidA_0kye7r52@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUAAidA_0kye7r52@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: LO2P123CA0101.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7585:EE_
X-MS-Office365-Filtering-Correlation-Id: a8c25c09-cafb-4125-39c4-08de3c8e2e23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3HbFQau2Zi4KhTANVfQGrgnK/ubUVYXiEF8E7SGapPtlbCjBn6pvPv0K2AW1?=
 =?us-ascii?Q?eJmMNXARw+6JgstD/3WgL+F4yjqKzqdEuVd8uQOm23bBii1xl8W2q8Aa1LTz?=
 =?us-ascii?Q?LJc7NU5eCx4u3UvRbo/EcQImzDsK2RVve+Vh5HslO+x7Srs8TPseTKCGCtzv?=
 =?us-ascii?Q?QgSonA9qyZQiwb1nIwkHF4mXQXBq9tqFAE1NsiMpsx5X1n8PfMjZV4JTCUPF?=
 =?us-ascii?Q?1oVDu7yMrMmG5TNr1m6xG7zVKtiGW3QYco114CWx5h39tAXjycA5gAzmur3D?=
 =?us-ascii?Q?B6IpVUZKfzz5Vi7m1b9nV3tXBIJmcAYNU0oxWp79jNdyoVGaFs7ZadstkCbF?=
 =?us-ascii?Q?yHbOGCKQcaH2gp9AKDK0O+kBVKvkl+Cg9O7vhEihiOnT+3qrp5KRfYCKSk5j?=
 =?us-ascii?Q?Srv0ZVorGEtxOIVKq24oM85sWT3FTKbpgGDcEEYk/KmT5RdcX97M+CiBoXhQ?=
 =?us-ascii?Q?elEsoiWXjuq0Iej8rU3RqApI30ig/ry/Ic78ieVaj7ruSSTgQouXFSIGj/Bt?=
 =?us-ascii?Q?cckvks9CSaSLIP50jFqz0Ri1mA7HZwGdMJag015928Jsc1eWocXcK18Kr3Mm?=
 =?us-ascii?Q?V86w5H+piEcfVDdSP6Xpv852dxQPSggeFPi8+IgPri/g3cwwmKgZD0Mk6GTJ?=
 =?us-ascii?Q?TR5rNSJRrYVoqlK7/eglyiGklUjwOjPpp5LcbsK6I7RhqmvPhqnzXxh2OW18?=
 =?us-ascii?Q?ek2paipWo2Jtbg4Y4BnuVDiZuujQ6ayG7xqLjefWQ0sHA19U3Swn1hLZsGXW?=
 =?us-ascii?Q?kjIT4EfTc+EDKsdxrMzaIS9W0KOXtLRfTA9aFX6nKSQlrvoAnEeYXAIR+Xn5?=
 =?us-ascii?Q?sUcqz0kyXE1/rnNO3kgZ1iRE0T/FKJhR3H8/fW9mLQ/eaxIOjAgcc1VbX7hH?=
 =?us-ascii?Q?bqUupvel0P3R5QCyCiKwVVFScNzea2gN9YfQBpp5al0MktuReTG39QZbHsS4?=
 =?us-ascii?Q?hkjf/RsUJbcSwLaypxGPBbmbq3wR8olUNiXt0Uh0BFBX+yeP6GEiIyF6+E5W?=
 =?us-ascii?Q?asmMgHqXuSOHcztdWFXu3PzgNZ3h3P8DbVoVgYr4+cWJY2vgf2YWc2aAXkcS?=
 =?us-ascii?Q?pdvTFeYW4sZcnziOohNJngUWXYdMnnuhiJQfaT41EOkMS27A+jSwK0IOZ6Lh?=
 =?us-ascii?Q?ktQmPblPQxorTaybHJFFhTs/46ejHviviHD8cwf2JMuHqdoxf+UiHTRwsdkE?=
 =?us-ascii?Q?/RVLINRM4OQJk5y+mBuK1gWsUto1UoDm8kVHKzKEkbFdHf2ie8y4+fi/wetw?=
 =?us-ascii?Q?+Tyvd3e/MfjLi1D02GEJuqX6KpAWVcZxcQ/y2gnmyeFvIrk5JmRjYu4s+IPV?=
 =?us-ascii?Q?15+vPZ/BgT4m2hE4DvDrTQYGfJ1V2OH16aS9B/m0RLvcAs//yG0AJsLaTNNY?=
 =?us-ascii?Q?ok514PpiN1FGYyD0CuPNPUvU8I6nBhZCWtRpZApup5ODHvfpzXtsF0+Dt7Ta?=
 =?us-ascii?Q?5eZx7FD5ufrq6t1hRaMiVV1hKuj54inm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BWSoJzuUfmaIaWifsJypRvI//YKeokqGZJfycsOpU9kxW0E8RknROBSXWqSB?=
 =?us-ascii?Q?D1+mYHvLRDHo3Ge5UpZN43PlSRZyNCocntiC45BnP6cSZ2SoTEaRxEo7CR/J?=
 =?us-ascii?Q?QRwZ1KYEOL2r0eI5D/XuL0uuXb0k7Y1zKhMr5PdodvDR8BSrPYl95pGBcCu6?=
 =?us-ascii?Q?rajm/WUgITmzG7q/nXQAWuXoTNV+QAPowP7cU96qTti4dnEs0B1XTQzfwyaE?=
 =?us-ascii?Q?LhnGPOFIrf05qH2ZQ43VGtO95FJS78Z15OgehA/sj5ifDMSVrJWyPLKNmW/u?=
 =?us-ascii?Q?YbEF/HwwoC3XBcDDnCn6JTKndhAkvgRga/5JJcfDDrohOmY+ZmfwXNDhnKUN?=
 =?us-ascii?Q?HDP9o25z6b+VH9Ub/4bQ6Kov2rzarb5k7MEIQZDZM8yalC9GfJvSu28r8scv?=
 =?us-ascii?Q?fKO40HYuUUslnUhG0USsSNCdmllBl9dfBLtd27lD3gtOZQhmdXVVfz7lZuSD?=
 =?us-ascii?Q?1hPXSd+HicEOhxj8Tsifrpx4M3uHQLATeNyS08rCchiB1qi4nELLPxHFH86a?=
 =?us-ascii?Q?X29dUL6muqhk0nDBfdZKtZwVAkxli+KnP7qT0Y5X8N26UCK7J7eejZTQgMjF?=
 =?us-ascii?Q?JCwlIoR9t2PzMS5kIdP74OgqNnAhGDY6CX50j/0tPjm9YUKOEtiEWQ6vrzAX?=
 =?us-ascii?Q?5jN78ifLZZQ3KcoIOuUHmYcUL/5tiwB1UYk14dSj8ulOp4+lt2Ekd0NdvxnW?=
 =?us-ascii?Q?BSi8nAKxf03Z/9To4aijQrRkzE9DkiiIyyAqcS8EdJo7nWn/hM6QCH6tN0eN?=
 =?us-ascii?Q?h62Vr4nEDabSN1sFEuiaUNUUjJPuwah5ZoxaNauxLZmMJvvtivB+TFlc+9G+?=
 =?us-ascii?Q?eIS4jnvNDxQJ45yOxlkQNrgx9qd1wEVMH4mnL70OaxFbCGFJAw6eGQA458c9?=
 =?us-ascii?Q?bw2iabBM5IrkkNGUM6+VG941007evEz+tJOO2F8HzAjm3zmefGZol+DTKHVC?=
 =?us-ascii?Q?PXrlp0MGuIe7UK11/fVW2XsLrEkaZC0M0j9Hcf+H/2wTVsR61y7iRwTmr5ut?=
 =?us-ascii?Q?6wAkIYcFlXyaXTekTQh0RVXgthSBlDe+wU24Knop69QGZB6VeBpmc+87OrbG?=
 =?us-ascii?Q?tJRNuMtSwVkQ6IAvJwjRq2XlNIJF59y4ODyqoVGYyOs2tseRu+1V8FoSaJtg?=
 =?us-ascii?Q?cowsH+ErsBKbbZmMMRdi2A5R7TmWMj2OPpfl6+rp00T+v199Iy0vA2wT10rt?=
 =?us-ascii?Q?uLwUq1osa/3ZxVSH0J/A6+HIIH6/apEfVnBsElTmbAc/LOZLdlR/FB1tQklg?=
 =?us-ascii?Q?vW+f6KTFhduYdiXje8ALxCKxgdhbvfx6usdGk6S7/RTLB3N/bkPUw0HE4NDR?=
 =?us-ascii?Q?w/Bp6Y4mgHwiXHbpBGKCGNRXpCOTWJ7PZySaLWjlQZolaeWk2W2Gy+iKeJw0?=
 =?us-ascii?Q?PHQGcRwJ/80jJskpUSzKGpYnHDxyTixrMNvdTLZEWt7j2C0uphc6uLC28s/7?=
 =?us-ascii?Q?2wg/WfrSWrrL9E4P2k/26AR75igbsbywxJEhj7Xz3lY2AA5MLR4NPV1qE1Ql?=
 =?us-ascii?Q?+IowJuQtO9JWpdtS5KgIc8+fzEkepcQ8lkY3gSpW5ERr2QWhV3J8FUBCFPfN?=
 =?us-ascii?Q?nSnj9XfFCZi25a6QFAVTRdmG/y2qAmr6n6iZqZ8mvN8Z2tGxGiAdGVcuxHeJ?=
 =?us-ascii?Q?sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZAGdto7C3aXaRWspSD/QQZYovpCt8ZhSj4tQ8cjun7FhLMTIewRRVRtmplnVIJI9XRYc8g/z12a4tteMBNIifYeocY+495/NXAPle8F2YZew/kt7gzj+n67hhGhYckDDP+zirQmJVr3iKd5Bqwf1+xLwbvhp4qie5uXjTAutl/b9tYFe1lZjQ/ajn1nC54OeD5c/gbgBICweNzNYPW9IPVh+Ikzh5uQV7W+aEGHPDuq9PGvDImiEYOb8I+uiaKczLuNIWpOm3LCFuD7UwBywnXMw/bI4qExDq7FyORGvYRTBi5iY3+jT06Ddvmk/rsR+Hl4hXkzM2sDKCd6f5TytM9tGdDDb/x2rSSaoUaODKWQMUSokw3NWPQAefDRlPouMeCXvso1E+JwNQaRe0ufXSe0Aq2K6kmqj554PAed7LwfOJXnlTwEjxzZG57yRjFwpkmNuGtpL6ayLaZ4s1C3qjYCf5XzkM4G/onwOlhFEyQETMdRfIyxFAuy7xwS5/H9Go7ADJRgwtZt/DHte8iEaferuYLjD3x1qeBdliQwhkuK7LMUb8jy+In1N21bUqt22SYMrG2FEEslg1Bc3D9SWAWca2SrMKYok+io2C8cBVU4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8c25c09-cafb-4125-39c4-08de3c8e2e23
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 10:30:49.1291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gVLvqBpt9whs9gEuO7kiq4wiw2hLiqgzd+vJW+OLJHBf2i6VvYGVJ7HJ/ZX1UJLd+vh/zBoY+n9JhaJMHdnKbnC9W5zt3Zh03erEp1FMOUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7585
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_01,2025-12-15_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=975 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512160088
X-Proofpoint-GUID: tYngA_jc0bvF4elzOjJsLeTQJW_d_SYB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE2MDA4OCBTYWx0ZWRfX7dKWMH4VIENK
 wqQy2tCwSBhpMooP3PJ6DfElu1RCkhbK41PqTHOjVkounMBhhv9r/kFMbW/1NlwNu5Lk8/xY8hE
 CbXAEWRwD948b4s3RhLjLWEAsBdgqeg8plrjpBxT4751Xi5q7LICfEXooVKeKWUF8joT+1Bople
 2kFt624mcZfsTLY/tE9EW33QAMq1Dz+NWsc1vemcS5PRoRfffk2fbYUvLlrPfrZkabr3eP3lA7E
 6WyH8B817WIpZ74hQvQViH5T0BoZ1F7r02OTHzsa0SgJxb63BE/yVqotw/HqF7bxcXSe5vEJLv0
 QAKwXdrWtrKwSee/vS26Zvq7wV2LdFPtHl05LMelhwEVJPZ1RsMHYKdJ550xW1tu3CCpvuzvtmI
 KblQY3Dq2ziSP524+LOXaIxsW2al+Q==
X-Authority-Analysis: v=2.4 cv=GbUaXAXL c=1 sm=1 tr=0 ts=694134dd cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=Iw9P69Z2Bi1p_EBo:21 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Q9-yHeuuc9dJ1zrmStsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: tYngA_jc0bvF4elzOjJsLeTQJW_d_SYB
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 670BBA000F
X-Stat-Signature: 53makmx7pu8ynrjessmijincs6cejue1
X-Rspam-User: 
X-HE-Tag: 1765881056-826573
X-HE-Meta: U2FsdGVkX19P0iE6zz1MA5d3KCGhXhvlGHpX/8EhupuMoOqHLuwgLY6kTSh7En/0kr0dFaOqYRf6Udzn7cIMxHAiMibleLfV/vhpC48mGFr+QV5iZOHeG8qtnGIYUeVttmrWZ+2fb8prKFwER1WYx4XHPqErxiwvYjgXhuV/YbFxteAYIgAMKZTC+iIwmMJ1aCgl7zVjqGWN2qDKAzWHpMa+uyftK+2JiRTjd73IE53Gu4TmKjrfnonD/q9j4AEchP3UlowdB7YLkSjFhPG1Zl8HCx87x8Mt6/2/1av3BK7Hz7TFGB2W9kjB2esCWFGw1DO6dtHvfJofF27qcFAuK5/KOj/zhlyfEsYRzLUbj8JPcDF3Qhc+N5Su7ziqz/15GMIs4isH3ufnaIgP1EH3OpOg5CWqsD/fqNNBnd3+rThHuJS0kXLuxM3dRfzMDwu48Xd7KV5llw1nc2stw/Ud2+oyvo3Ibg6mGpcxn0mUX31+e24dsVzwmND/EslQHgSU0+1yENHefKybQlEjIX/EZq14ALd1xVjUDwegnk5gPcXtCuvviNn2d8F+f0g+wK9Aj8XtjlKkP8gVRIQP7IqUpCwtUO4mSime4K3WkGXMgsrQZlBhapH1DfgxXxP1PS5lTwOcrgMbCi2BxKIHm9+3ojUZNOGRA7wvuXa3nIOTFvxcOMb0J7wcZKLLjx+dCRL53vSBYsT2ZCJ4GddonJS+l/12mLr0AnZIaak6Pdzxjd8kMe1knykzYVzQf3iMZd4ROCEjp4R+/eObUk7LhRFTcNPY9XSeb7Vxcghpp3K3oIM6ICaIjX7q6yZ3QfxwbMuPrzQWC/kBcvgSK6YNdquzF1gjg2SBIBiAOfYlHiR8lcPN8DJ4kUotNADYyVVXMVN7g+0GPPfJ9nj5vfRGnaXYUH3KSSk2MD9b5xPKEbeG67iAzNcItsXGgWTJi5EGeqemQvyNVQnyFR1+ZG/f2fH
 p+cENnoW
 rZ5DK6exbEkhb5wwbzoCHz6UbhC37CCBNNJjPG4yEnujbmFnSdZNLhOux8dZxV0C7SOBT9pGgaPFZ8Y1AagXqe/ktng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 05:35:21AM -0700, Gregory Price wrote:
> On Mon, Dec 15, 2025 at 10:16:26AM +0000, Lorenzo Stoakes wrote:
> > >
> > > s/do_swap_page/do_softleaf_page
> > > s/DO_SWAP_PAGE/DO_SOFTLEAF_PAGE
> > >
> > > No clue what's up with the special sparc stuff.
> >
> > :))
> >
> > But in general LGTM, obviously assuming David's points are addressed.
> >
> > Is this a patch you'd like to do? Or I can batch up with the next softleaf
> > series?
> >
>
> I can send you an updated patch this week, just on my way back from
> LPC now so need some R&R.  Feel free to snipe it ahead of that if you're
> that bored :]

I'm too busy to be doing such things :)

>
> Probably better to bring it in with your next softleaf series anyway
> since it's all related.

Yeah happy to put your patch in that series also if that works, or Co-Dev or
whatever works for you! :)

>
> ~Gregory

Cheers, Lorenzo

