Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E611CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAF9D8E00A4; Tue, 14 Oct 2025 11:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86A08E0090; Tue, 14 Oct 2025 11:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4E298E00A4; Tue, 14 Oct 2025 11:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A02DC8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:57:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5860C1409F8
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:57:33 +0000 (UTC)
X-FDA: 83997174786.04.3119838
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id D0308C0007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:57:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ujo7wo3J;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XpRTwsWW;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760457450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9rH3SP4ILImYiPqoDp5QUO7YlMcZEKJhserFzQyoIQ8=;
	b=EslO64nWhRpFzCB5QR9bWPyRXWE5UAnLmU/RSi9+6+wSJbVvoV4FlYZCOuzdRDOrROYUO/
	TId2umy7hRgKr2s4Ab9EyxYEVejyFoJW/ReD7sRSTkdb+XBR7fW40WmlDrdReK7Z9FEp/q
	7c5iAmX+3i4Xq5/59AJfwaQ4EcxlH00=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ujo7wo3J;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XpRTwsWW;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760457450; a=rsa-sha256;
	cv=pass;
	b=iPAv3e9tS9yOIKF8cHvoAp/NXfLwax4OUkFX9ese7gZgSvKXGq2fRlZVT/ZhxEqnDxny+g
	KEziL7/86TU7rosqlwBfLKnhek0U/CdEtjUIkf9udRzeup0agvwuv6QlKchuE9i4cYaLi+
	FLROxLrjESTm76RmH8aAbpiJBdDdGZg=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EEfR9p002094;
	Tue, 14 Oct 2025 15:57:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9rH3SP4ILImYiPqoDp
	5QUO7YlMcZEKJhserFzQyoIQ8=; b=Ujo7wo3Ja0Z5ArSdJ4q0XcmUhdvGbZVRUv
	Xq8CtjtAeawGshgqm2XRqTglZZVuTAG93qdPrRlMEZ0hOKLAz3Wg1v2PsuBp4ijk
	iVWeOS103DQ0oaLloIKUTsZriy4oTNyGmG7pFkZz5u0P7pFISY6Nv0qHUnRIB1+P
	rFb+lbh/JKTkUbgthnDP2EKoE3vZ02bDRZ8af4TNhMCC3stw/CQYWm6QiwU5ooR5
	pRNsbXXHzlnND5h6MelonuuK51IqWOPAxPKw7yc/PzrPnadX4t/dN/U6v/OTRzr7
	KUfMv68QrjotPTbA72oa0lv9fGKcCXVbr3j/ynraQepCPRAMQS9Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdtymqd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 15:57:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59EFJfoU009784;
	Tue, 14 Oct 2025 15:57:21 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012052.outbound.protection.outlook.com [52.101.53.52])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpf4jfg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 15:57:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IVT5Slp0isqEv1FcbgRy4ySgS6npB1Pl/BQzrPjv42YDAr/qatamungEkMjaLyyrp6+1qdKQAKpcuPlljT0jjc6y1T1bYOaoYYu1Kp40sX//Z+lto1OoaURKX6400i5ujAz6vum/wkZ2hITZYe8aarEUzOvxZOBz6LLNeX21yJvEXccbHOF5TedAGkxGRZg9tzUd/vNAqKwOzcfiKb1/XcQoRRjNXF0IsBCxcwajwDa8kGEiCfhnCbMGjAm4xY/KAUQUUtNx67RsAszTGuOlB5o0cYx6gB92TYwCgxP9sP+eqqjIHNmjW8FgsSUN1z1mN82zXhSABOk8mqU3rZIDag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9rH3SP4ILImYiPqoDp5QUO7YlMcZEKJhserFzQyoIQ8=;
 b=jxTjDmbqdrNTSq/NFCmHWrHmx96Whj5tzle4GoitudmnFmTUjBNnWcvjzFVV3aUYUE5p/nrRmy9EIHt0hVG9S4W5a9mMYfXi5kQir9l9rmtOT7XmNmU2OTLQZG+7CITPUwOpbZlSAi+/fx+q4L5abywPtub9VV8ex/cCUp9+OIaYDtajqqJODC9gWk9QRYyjZJ1aJ4kfQN0edilxntNIFu7qUWVCU2p51j+uA8+zLyXJWbf5R4TIvXOjcuGPKtRbh6Wnu5DDWbktHJarJzMsOCiuYP3FKS9QWnGWOqWI+RFoNBfWWN1SJUO1kOnl7po7N/lALLmEPWDKTYEg03r2pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9rH3SP4ILImYiPqoDp5QUO7YlMcZEKJhserFzQyoIQ8=;
 b=XpRTwsWW/egQ9Ix62GHzUatBeoZIm+i8nZlCNAmSqcLhjyNggMX36c98IUuvShWEe6eNsE0g/R9eLaaDOYr2ZkmwNulHLQ6Ftye2yatu8COteqNM+XAQmDn7djyrmmpWGWpuXCJj8aG6E8bbLsJHSgSCXDyFiC6FpUjKErg3owo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB5159.namprd10.prod.outlook.com (2603:10b6:408:116::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 15:57:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 15:57:19 +0000
Date: Tue, 14 Oct 2025 16:57:17 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
        Liam.Howlett@oracle.com, baohua@kernel.org,
        baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
        ioworker0@gmail.com, kirill@shutemov.name,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpenttil@redhat.com,
        npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com,
        richard.weiyang@gmail.com
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Message-ID: <24b12296-aa82-4269-a9ff-def815c3cef3@lucifer.local>
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <f33735d3-b38d-4b6a-aeba-b415e6b24ea2@lucifer.local>
 <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
 <f7392f43-b8f1-4e6a-b9c8-25ad8a47f82c@lucifer.local>
 <d2e5b099-94bd-444d-9946-182807443539@linux.dev>
 <c44e198d-7d46-491e-adc1-86cc306c27db@redhat.com>
 <b35b649d-5566-4467-8222-e358439b4f84@lucifer.local>
 <89d1f871-54e3-4c66-bd93-e8a08ff640d3@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89d1f871-54e3-4c66-bd93-e8a08ff640d3@redhat.com>
X-ClientProxiedBy: LO4P265CA0171.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB5159:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b033506-5857-413e-fe46-08de0b3a5aac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8UteV6TQpI8LQ/H7bCGYSOE02ejRTVdAlfVHG+XAjdirWvLFYW+6H4sd9fpH?=
 =?us-ascii?Q?aLrX8DV58zDXPkSwiA4iVeQ17aSrTlVLg9oXs7GYkv5kuM7KxfmGJL38Oay4?=
 =?us-ascii?Q?QVEGYj3cHdSebm5UdT8vYQl4Pp4cRhor8GVGN6jfCOPAJ7Q95TL3GuAFnHtQ?=
 =?us-ascii?Q?S3nl0OXoOyuQfOCF4K8TdhACtVKnV2a3P9XbhgC1859iNGRz2GExphOyQWNV?=
 =?us-ascii?Q?tMMRLeBUNE8g41d6eYroOyK895DG+VDJGCE6m+vhK+WsGouR/kRTC+n82gqf?=
 =?us-ascii?Q?eRKP2aOj/2LXfWlscFZF+/fWHJmiLj2RzAu6Pcj4GPEh6BMB7YJA0rdLlaRD?=
 =?us-ascii?Q?5LI7M7mUa7zdX5MSGJMLIkvPeZjD2VJrRzPa8d/pWDSG+DdKSPuIja+LPr6w?=
 =?us-ascii?Q?ya72KZJH3bp37Ug8q2fQza+mJ3f4Q6MOZ+d4UblCFWAAf8uJy+JJtjlug0W7?=
 =?us-ascii?Q?uuTFgNqLfqEfVj5uv1t2aObTgcfYnT+ooqmoxCEW6VtSz4qk+6ooV212Qwcx?=
 =?us-ascii?Q?WqSRNrbI7SJic8FAz6x/8ZXboNIZkZnGng2g/toEysX6ygRF7EfjcRJM4Q7L?=
 =?us-ascii?Q?lq5hQf/25mJD9nlg5BE6A8qeXZX8aoF60WgwKNzEGkDBu6IftxzabfUhjmnV?=
 =?us-ascii?Q?m131ZywfpvwjMMbrpZyxNYEsVN8Aam5gfQUxtJ7JAVGtzh2BWeIrfeBfmJuF?=
 =?us-ascii?Q?77pC1sMfh9rA2L5jL8ue0rTz3ZYAApAJ0+Y1q68SAH7tjnauKP6CRhauOMQJ?=
 =?us-ascii?Q?7TFQKebW/yoqmkfIctuKhC4G/LBEkmAWF5F4Oo//iIDGxW1U2NaO5vGjIXgl?=
 =?us-ascii?Q?bedVDXKxT6SmaELt6X9J7EwtbZ0mkOitTfpFr71KmW3v0Yow1A3cl83c0ZCX?=
 =?us-ascii?Q?V67Qfba3bEaCRvgCaNFeLB9tJqgKP4XAN/61emFPO3Js4aSF4HhJ4ORb7gRT?=
 =?us-ascii?Q?d0cAQCZeGFsRFZKbdL93Rr6mF3eXYAk6YRs7BV+lmIdfwtJ0OAmF8K2fmol8?=
 =?us-ascii?Q?KR44mi2euN566aYlOHnNSMDRLGuUz0EF9T6N0RH2gJTT/4e3WMNmzQt4wxjq?=
 =?us-ascii?Q?Pczx2TlXRugAiASfhxOYvR/d9Mj3x64HuCsOsxlLc3S8H5O9EM11EDoEOMth?=
 =?us-ascii?Q?HxM9sBEvVLnxtHR4DmiDdWWZoLd1w3hJNHVuAqBCjOhjPE7pmooiv7wJhp9r?=
 =?us-ascii?Q?rF4EYQ2ZlFOqzcVKJbpytiGOp/5h14QTw1Eo+iJgQv7LmXaeJ8cty5sys5fG?=
 =?us-ascii?Q?K8SVIqM0+y89wcqMzmwxova05b/eeqdUbnd2WfpoKdNKREDvMuF9g2WZvyOI?=
 =?us-ascii?Q?3B2IK7TPZWRlWk1vtrhYZr4OXGVukAv1K12+36mpv7cFNORj9rUNKoxNMis3?=
 =?us-ascii?Q?WIoAYm+1bImaGKpNJbqk3/NLfAv1JljeO6mfhlRyFTyvzYNsmZTvsBlV6pS1?=
 =?us-ascii?Q?kWas7w2WFZg9a8iDbkiZy58HZWc29YYy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cg4ZmyhTKQ9gcpaWPUKRikdbpjnuKQHA3tFHx80OMV4yvh61+/tNdZdaS4sN?=
 =?us-ascii?Q?KF/zKj+Ecj4h9rS548fbGF3UD4o6b3AsAc14ikmbEH2XcE0PoywHuf5xqHGl?=
 =?us-ascii?Q?6ZTKXTVHLDSmIm6dqennzXyD1yEEYb8iYpdqqvba/BcdTc/T+TucWHDmyWqX?=
 =?us-ascii?Q?cRGLWGktohA/pG0Tvu9xN/vl+lCWw6JV/MjN5e27hEtcTgPDncWWRV4wX9wV?=
 =?us-ascii?Q?DVtL8hi0XCCLKFYJOGCdgqjGzoY5PoACoIVR+1rqvSqHJgViAP5ktczte1ir?=
 =?us-ascii?Q?eCrLS7tOEBEdV1M6Fe+yjS/nkQAAeqXGGAg3SZMGU0zuxQkndulPQ6lK/WUB?=
 =?us-ascii?Q?A6GNxmfKDw0vV2QqzWiROLbcP9m8usA8hKd21N19BDj10E77ERmBjyuu85t0?=
 =?us-ascii?Q?Bvl/SLXzZ261pxaO2qRfu6XalbRSgiv0dym4fLBigywRIJ6nUGRa68lFEqW5?=
 =?us-ascii?Q?JTlZjK36W7E2dKW8ZXTM62+LXG1AdTUAFvTxC4IxLBEmMX7uT1yD22j4WXZs?=
 =?us-ascii?Q?0kr2zXt1Ryru3V1g+EYJR4xCwQO3YGmAGOWsYYyeubgb780xgezJbfp6qRov?=
 =?us-ascii?Q?ZX8sKvfOvCfaJ6QxSIs8qo2HoIWPXRxBP0hV5EsYYZnze5s6Lh0XE5rmnMQM?=
 =?us-ascii?Q?42UoJw8TW1UqsD/hutaahcbd5R5TyuIyLfw1A+ooZvdY6b6gVnUdQbj42mpp?=
 =?us-ascii?Q?P1QpvZ/qQfAxng0dJGqZA3Z0vbt3oURc1EcjXXEDge84SaIW90BZ9staESCL?=
 =?us-ascii?Q?lWrWBAaEPEAYATwzhy3iFXIK9RBFr1EQkY5TWenioeXVmYVsW+aaK1w6jezn?=
 =?us-ascii?Q?YLnQLl/a3BiaMtijdnadsGlPejf4DX8/o5E8mfYqsatZWscxDrfgDdRVApBK?=
 =?us-ascii?Q?ynlYFoqH+weiWjxhP3it0yf7/DaIjVetx5U5spXra/o/KoVEDeyac+1CHFeV?=
 =?us-ascii?Q?Isb1b8MqQnRlf/O1h/9luhnvxwpUF71MmiwynHDqbAU8bE5JoeyjzA5A7iKR?=
 =?us-ascii?Q?RawQCJ9VEWsglq5GUOTKFHW9CA6dg976KtKFbm3MU/zDwq9E7E/EuISnUeuS?=
 =?us-ascii?Q?aIc1V/aL8L2cz/6f6ZLZSY/AO1sb0lXhXOl06RIFkrP0NfcKF0+80InA4wnh?=
 =?us-ascii?Q?+s44n94EikMkYJ3Rnzoy2T2wTQiOIbsKWQx3p4sejeaGxredUg5ReRLvtv85?=
 =?us-ascii?Q?iTmA3omYLQWfkgxFR50DJK6XEDgn4cNcs4KNTi5joWWG6tKQ6DYIaHj41lyv?=
 =?us-ascii?Q?s+7N7IU4UZeEPhVHJ2lXBg5LKLM+LPmWacQFlEOHOT5xFgbWeaJdw3k894/q?=
 =?us-ascii?Q?41ARHic1Qx9pvKC/DpE7BwTyWIgPhztNvMW9c+J9kKdTJ/NoN31v/cgsvipc?=
 =?us-ascii?Q?7D2mfF6zIEoLXbW6nsNBaMSS5lb6ACtGloAX0cIR9Pl96fCWmhznTY95KE5o?=
 =?us-ascii?Q?v+1uIcKESrBm+zFDV5oA0244fOMPKw1k1FP+V5QSl3izp+0yc8862FTCSMpX?=
 =?us-ascii?Q?aAy5broyX7XCEFuRlYdUzmo53yb1rLgJRKd+Y30xWxpy/EOI2aHDb+Ee1zki?=
 =?us-ascii?Q?TTSKNpZSkopKcDbc5JKW/zPjLpe3UAX/fcImRmzngrQhtEXvJzg9lfeZ7T6K?=
 =?us-ascii?Q?JA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fyd7T0yuc6Wk/cju21EaOW2syqSo1A/gdSzruuoFt4H39xExVbKvF7Q/5C+uBPvTiwjHpxGuD7Wp874lJ7P7nadzEgWY6XjMHc/FExCePw9qOWL8l7VmqdBGCzJX4pZJIj/EYY3/vYZicELx/iK5uBBLbydCMZo0Rs4rWgVgM7y1UFHv5967cd5KeBo0STLC3cR1DRt1GYMeI9pIAOkhHccMC/tOFNlra8R+fer5mXp/Fg0ht/JdcgExf9gdfTaCu0kTWlQLSxWCwonsg70zXM41oAXAg1vF9v9JXs79hPEKpCS7A9HLnhWZGwXSotVTh+J8aL5Bmup3iZstCmrs9B8Z0Xk5grKvW9Ix8ejbUR/MKcjmKXCizztNAJ4dIp52MQd56KcCmKmpzJpm5wfSZVGzQUF17uk+9GC1BoA/imyFtVfUUspHqSiKOdWQuaEz3wI5PX8mc5PDK2FAuvJUow3GWEMV/wK9CXePRvOkhckaK+5+WRyEdrJ5rXxrZqi2Mwt/dNZoeHz7DiLITAzQ3Z4ZGH9+5VjIM6oDDMvQhsOEijjiju6M9W1l+r3MQ+LwAo5n0PHjAXHyGzzhjF/X6RmJPNr1D3hT31j7GqBo53Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b033506-5857-413e-fe46-08de0b3a5aac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 15:57:19.1128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WsV301Ea32dzonctoo9o5flkvHbQpP01ZuKX8S0+Ew4r4UQyvcnfaN/c+Anp8kFkrL5GDNr2RTfkEvaHlkEpMIVVCo1lmPaiA/mAHFy66uA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=737 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510140120
X-Proofpoint-GUID: B9gcsRYsqcn-PME0VysZOrRD9m0z4hP5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNyBTYWx0ZWRfX16352lasQaJZ
 TY2OMQj66vAbSmHuwyTSA82Mk1i84U7znKw+3PnVtBGFJydVNWDSA2+5xy8sP0dndcfeq6VDPWL
 eUguFfduUNzeie0M1uuxCsyhe8N5WUlDrK6jUI16uDf8iLZKQOWSCvCRBCbWy4amRZ0xL0ViyXX
 rSRcDpvsroZFMkzuK/AeH0rjjx9wt6eB4AK4ZXyWTtkNMJB4lSJKkWb9jo6QnS9U/FvBuiWXg9W
 UiuVWTvLDK7fGrXnPkvIK4NXC+1iqXBJrg3Y2QRBA7mWGBn1ALQ1w/F9xYMT/tIAp2z66QkO+Dm
 KlO9nUo7zDFyu7X64u26Vxo6jydYRF+ucFZexR3Lo4KsjyaqOVehtZHLLT3skJ8+oEyjal7/DVn
 qunUzciZCipH5R+qJW93VJyJRILvEmxJeLSBuGel4FsniHPT85U=
X-Authority-Analysis: v=2.4 cv=OolCCi/t c=1 sm=1 tr=0 ts=68ee72e2 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=lWvdhc1y6eYD6KExIKMA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12092
X-Proofpoint-ORIG-GUID: B9gcsRYsqcn-PME0VysZOrRD9m0z4hP5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D0308C0007
X-Stat-Signature: gxxzhd8x336sijs4kawqbfg147itbtha
X-Rspam-User: 
X-HE-Tag: 1760457449-66691
X-HE-Meta: U2FsdGVkX19szrqKHqRYveknN3B/QsCXfIKDBSWrahcRl0pv0V4aoNkPcrpnZuYHMs0BZVINbLriykrl7tX4QkbwoK1H71euVVLPyNFQEP4BxbfA4rw+2EyAe9BA92tCWW3HddQpq9dtZeQzdJECKVcKit5NZJQdyhLpeJvTtib5ASxPmBOgy6BxQt+mzQNzdgGEVylRpOqgWcG2ib5tJ9Ou7CDFAUS1oaX+2N5FRACBxoHVDY5Pri2Hm7/80I9yW3CKkPuqCaqy5CPsHJ+W8PXYwQgeCCgbA/bFrFylZl6phhf6AXOAtX6C6X8NB+h/I1WyOKI2NO5sFb9JvdY1ykzNDepFPQVGXgFkhEkW3aYSgk7G5U6ohDnQBveb7dMudN/uyUfvo4p/NHMm6/AKqKhYRP2SGN/nTnYo3Wh9RS8Fhkwav0lsLW+ah3RCTPnupDnH+cSDMWTp38ihe4DxH5x1o6A4jGPUowPqDEsldIxRis9+CQq9b8N6VqDIYUoRySkW+QaHXBIJpPLlTxaBles/msrPbev5qSAhKvUx0ENUDI9uh/Ew2Wh2A2aIE2LCVNYP33VG/D9g06i3tH4hDIQWneYo+U3aGptPBvzifD1eJsKU9kEKbeztD1uQMBIRI2pLVeAzIguNqO9ut06jdcxguVK3KEp2FiooRW2rfBhoz8/yQJDK0YU6NvciA5xvl0gbzdViuOhAyVUw4djya63hecSfPqrXoJj9UkRBs2t7eDiTetVN2EjFUD++valbGL6GO1uP8MZt/SAzXrYe1gwBYh6drdxk+NbIolDCQcIbBiPQvZ8OTYTqGr9Rpsqu4TyOujhioiL1vKnqd3MmVfhjP74ZAbdsPeMN9BSj2F+Y3eJOSO/FZ2pYDXfn9QtEs6Zf7uCvJS6HktFfTxeYvQ7Z33tn4RiUe7J+c091az3/EsejFyFQfu+bNNTZEU6oaz/mZ66oPHJB3HX1pA0
 LiRonuVL
 RHOamLW51FobnV3EmORvFC1RHjeGbFYFt7Tfr1UmjFdET1c6nzq6MZ3DG06EVH/WeG7drxGikkiys/cVeeVxyUdCyQxlrRSilegaZxmvjWSQlA9Rs2mX2/0j2GYgxnDmrnMJ4GYOG5jat+Ka+jqj9B7nsqp+sig3MiwMTbOd96r5X93ZZFB1ykxsv+jTWG1ri1Xuj2GoFUYRu3vRREgkb5FHpbow4nrrSYPJtGPyiYlDvbHgKM8jICqVFJB9lIrAZkWo5REPZzJaAf6dlOZaIl/OcAhtAxIQgK1uQmZg2LKKH+gCnxJqirwFacBkfXbQpiD+t53l52p5TlNdP1c7gF7RS7GduLn6tP7o3wFa1CN3OIqd8Scgfh0/S3o5eb839V2nLpwjtHUsnJTEBD6wBoGFum35t8bfB827SXXG79FW1Tciop7E+sKL+7ZI+acKbX3GFhUiGGPj6ch7hdTKb4fQcxzk+sOmjNQsy2ek+Je2z9Y0qdgduVHZuNpVvXT7L1PGhPneoLrh2grkJQVlBV+kgEd+VIuyFGnxdL0AzriDPUQAK+ODkdvgdHjjvXp9uacEpgzjg6nCMpLQN2ybd8y+emgl01/3vfzGNmP2IruR/rrkPNhabSX0Yja4Wwjh84Wr1qLy3PguJV45T8znQYWShLtfOHcarKy7l9wA3PdfvE9jHQo3IDNejixLyh6nkv6nL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 05:48:04PM +0200, David Hildenbrand wrote:
> On 14.10.25 17:41, Lorenzo Stoakes wrote:
> > On Tue, Oct 14, 2025 at 05:12:18PM +0200, David Hildenbrand wrote:
> > > Can we please take a step back and make sure we are not starting to do stuff
> > > differently than elswehere in the kernel, please?
> >
> > The code already had the is_swap_pte() check in it, so this is not changing
> > anything, it's just avoiding confusion.
>
> Well, in hpage_collapse_scan_pmd(), in __collapse_huge_page_isolate() no :)
>
> And then it's called SCAN_PTE_NON_PRESENT and it all starts being a mess
> TBH.

Yeah ugh. THP code is generally a mess :(

>
> But as raised offline, I don't have the time+energy for that today, so I
> don't care enough.

Time, energy? What are those? :P

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

