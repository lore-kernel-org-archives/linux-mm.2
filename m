Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCBBCD70DF2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 21:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A806B0088; Thu, 18 Dec 2025 16:02:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BCD96B0089; Thu, 18 Dec 2025 16:02:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249DD6B008A; Thu, 18 Dec 2025 16:02:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD3E6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:02:22 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7392B1A035F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:02:21 +0000 (UTC)
X-FDA: 84233814882.10.127C38C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1252C1A001F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:02:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lVR8f8bz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GYQVwPZt;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766091738; a=rsa-sha256;
	cv=pass;
	b=fjo5URLEOfOYRI4FuvQTlsoCc8a5X07qo4l2u8i6IB0MhjzAf00/qrGHa4Rh3/lFsbXfQK
	S+TzHPR2dJ9Dxypv+Ga0VcCbmw+lvcc7NIkvfT/9z4bkrzPT+IuhAGgdy+fRldJ3AyWyrr
	lYHLgkqCBm5Wm81LYsKgeIWatcmK1ms=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lVR8f8bz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GYQVwPZt;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766091738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEEujpfx5lMrALAfzKxni89vzC4+eCI5Va8RAEtaTAo=;
	b=BQAN/tjn74dP1KCjGOFfumJ19q/P5FO+7XFrWw5S9S2OenbeQ+qg3Tj2ujIoGXqoFJ5ugy
	IMc9JQrQriPuAHwkn0eVctvveQ788ywyQb1RQGzeBCaZsf02kePn3FszPkaxbSeUfaISKa
	DKLSo19roxQTmlpuKaVcMD/vGv/XBXU=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BIJkUxl1671135;
	Thu, 18 Dec 2025 21:01:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xEEujpfx5lMrALAfzK
	xni89vzC4+eCI5Va8RAEtaTAo=; b=lVR8f8bze+6NdBqQS0UGoI8iXHQGXROB0C
	Z3T9ROuXuv5g2pwSd+RkEjPh7uv2S6lbZE+xfZgSid+8T5Ujp+hpLCJZbjY1CzoL
	tXafBMBUmAIYVSzxNpoOCYy52S+K5/Hwev3eKv9nOQxj2gjfeERAaypxEeN0aOKj
	BWNbMELSQbSoA4CahMUBDDrG7+/Vl6Euoxvgslwv+Mco9UBFxNIiqzVPtzypMjeS
	kFlbPzTI/hq+KimphB6uRFqvud8IFXy7F1d6VVQnOD6oKS0S+9U0iQAsqbg49LVj
	EwerKJe+sQEfnyDJkCTFBRn4ETtQMAk0MzRRx7oOe9zHX4mycj6A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r2f03ux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 21:01:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIJTWCd014300;
	Thu, 18 Dec 2025 21:01:55 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012062.outbound.protection.outlook.com [52.101.53.62])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qth3d07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 21:01:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lsmOCQPKtHvVuHRdJbWiEvZiFZmrCvpFcTNuYD3J43luzM8R+JupdHhoQJ+ewsLeV6gi3CKJn71X4qMg/w9HbjBKvDJSu0qPbrMl2RvVLt5FfpevvMpW72oEpOyP+WzeyCsJ4LzzWyBGxs3YFpxoeGJ1+uypD1s/DZPKCiyQkhg7eqfyzWxBw4gKgB06e6ILjcHGheHTIfPUfiaqj/pPJ7S5oPSjG+4HS6zvwk5ctNmR8WGyJvdIejHW0swTEbn5sC/n+vin1fkvEV44Xm65ZhpjecA9fhVydsHEqvppTv0c+2fEStZMRjW7bcBCp3s4WDdrr1PYiPq8wsBxDHKQFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEEujpfx5lMrALAfzKxni89vzC4+eCI5Va8RAEtaTAo=;
 b=xw2N1YxgnOV9TjrkfQKI7wvvn0W2vlAs7rvGCeB4DlNw117iO83OzuFm8nYW0agcOT5Mlnxo7EPVl+023nwQaL+La+FHF6b5dmI+K7z3TemfMwfMaApoJGDR5WY0ZDfUQNAublQA9n7bdrjfcmxgppd/35dq/Gwe4UKh4L1WJibV0FYOjjEc/CUzN4RoHVGA9KkMTLA6AJw0SiQ/+zEVX4WuUpxUduWur0XVjT6tZyoh9hAq41CSXuXcQa+rPj7egNAE7nK12E82ZSMNi9LpbfznR2dM50N2vi7pfdkfYBiVhZ6HxyaKqN6xrBZn9tKcVyJxVGEfG4YzzlZz2cIR/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEEujpfx5lMrALAfzKxni89vzC4+eCI5Va8RAEtaTAo=;
 b=GYQVwPZtqRwWtn3W2IbZcDFjnV1oexxHGEJHUgngorggQ3f7RkWH4Yd2l36CHCifVclHS07dRwl598Cl3Egoaz9ZL8G9ubOq8VjLaYhniAJ2MZxeaMJ9naE17HlZ0f2Khu0jx+GOz6s2XVhFf/mzcUHjumWPy/KBKociSOaeiMw=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA1PR10MB5924.namprd10.prod.outlook.com (2603:10b6:208:3d4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 21:01:51 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 21:01:51 +0000
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-9-ankur.a.arora@oracle.com>
 <b34ce151-45d5-4074-a869-de93b2bcdef0@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v10 8/8] mm: folio_zero_user: cache neighbouring pages
In-reply-to: <b34ce151-45d5-4074-a869-de93b2bcdef0@kernel.org>
Date: Thu, 18 Dec 2025 13:01:49 -0800
Message-ID: <874ipnwlky.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0280.namprd04.prod.outlook.com
 (2603:10b6:303:89::15) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA1PR10MB5924:EE_
X-MS-Office365-Filtering-Correlation-Id: fdcc37ed-371f-4703-a562-08de3e78aa5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kuh7T5W43actlVcLgNd057WXIaD2+h2yjXY7mcpX/u9/N7ANMhqoINl8gY4x?=
 =?us-ascii?Q?H1LpeP+N9iK3ej7Z30IS5vcLWiT80ETEdpmD8UoYqXupVRatVOr9lrbqTmWj?=
 =?us-ascii?Q?hO/Ms0U/2AdEs1lmotjdYVZhIpwbtHSy5MiYCUUC3/00cOWmgudg8VHthoq8?=
 =?us-ascii?Q?FixiqQ8opNmtMmETIjWD0ZdRt52rBluNoI2UFMJgpPqTENHQeMqBnT/MDl9H?=
 =?us-ascii?Q?y3TeiaQtzrn/BxWeaj+Le+3MtjFVf7cALmxi+OQjyMgUO1qz2YWJk+5PpnAt?=
 =?us-ascii?Q?Q3m02bmnW8w+G8SMpl/5TdNnhuLbtdtT6jRcrFUpl2h8/GGbs2cd/N5qNjFl?=
 =?us-ascii?Q?Yo+56tH8iBDHlrIGpAdVfsZkMR/R0G8pANJu7L9XGsrUpcYNTZOlg7eGtdP6?=
 =?us-ascii?Q?t9VDnKbFO1K5qQL77pIqjjEeFwbB4coFnhgad/aYizkANpO3ONlWpDZZgG8H?=
 =?us-ascii?Q?eyba0yuxt2Y+pkoZbaDeQ8Psr5qzEhlinZ5ClCY6Zl5Tjp/nN4N1hWSHSNVO?=
 =?us-ascii?Q?ipdmD2NqY9pr0EDLBKJs62qbkSEL4kpb3KyUGvule2PQYE4hlTCxJAsVREus?=
 =?us-ascii?Q?ademAqHsDhqz59q7y4O/p8PDsX2vegQFWQVeTVbrObaT4Y/DZ5aGd9Nyopax?=
 =?us-ascii?Q?G0zKLdlIdDsiMvygxbWlosGXm7KXwKrm4hJTlGy0DM6n834eKeTrQwzoSFlL?=
 =?us-ascii?Q?08p5YZWTzTpXRzvCsQptLLeK4KdECKfG7Bid+u5rvKCw9Y9GbcEW8qf9jkbe?=
 =?us-ascii?Q?ML5RPEJl2i2Zpe3EwK2jbn2reB571pm1lifKP8csXqUbPGa/Ye76RJYvnyW5?=
 =?us-ascii?Q?4OEQW3LexLrXD91cKHwSw/ofS+HGTSmH4DrLLrhl7VdzQK49RRkDFV65i+H1?=
 =?us-ascii?Q?HiK+BupBwKWs3T9CwHwB2+A6e13rpvWe/J5qG+s9ScXCcxz13jNVoZvSZMnT?=
 =?us-ascii?Q?lIrmLwWXSp3GQs2UQilouuXs/4KI/8iPEKjxWGYTFGBJ7/pjzVn1dZkPUVgy?=
 =?us-ascii?Q?G8vt67jEK+2UilwvNyeKQ5efWD7k2dI0FW0fGdqRuYcrnwKoar4eZFQip9CT?=
 =?us-ascii?Q?jN4Q/Jf30vbdOlevrCRCctfjmzwCJ1itP4m/MGMLeJWL+vQqTFmhJWBWL4BN?=
 =?us-ascii?Q?BXB47aOslz7LSVw5sGbWVEYV7CgiZw3/ye6x9gOksd0YGJCpCE2DZZL1P2CS?=
 =?us-ascii?Q?nSq/PmDDm/5hP+fOvUzYZYcLvilli+lsRUQ9gOIpNYkTXQiAQ0JwZaB4umuw?=
 =?us-ascii?Q?q2TMP75LWTXrMefc6FvEX5L54WM5P1E59hb24Qj+ooNMWfmDgkL2rWQeEvB/?=
 =?us-ascii?Q?X6IH0IEuLmuqm1wRxi2DAuHRRUV6IbA/BIQNFArzws+k7vPYcvN9LZBox1Rl?=
 =?us-ascii?Q?bwkmA5Kti70DdrHdQEJqBh6Hq5aFZigvz8FkyQV9Rd00Fu7oZWZTxQhdxi/q?=
 =?us-ascii?Q?2z/zK5prMEBv3rEr5edRN5oheuAUvt1u?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lFKaLlK5fgIlpoMZTMawRkKx/V7VvG8Ci/MIRmS8cdWh09sc1Xzui93VYnV0?=
 =?us-ascii?Q?FparrF+HoYiyHJRdKLrCeshVb9eIxcRa0hAx4MEl7vEJH2A8jkfHG6bKK6sP?=
 =?us-ascii?Q?LtOfYc2qGPxf/OX/VoWip3C0OTsJyZA4qWtpJr8+o/brS4AYixyb0toPbRYm?=
 =?us-ascii?Q?sZwQRFfCoAWQw9ZPruJpcBp1CJKptLMwKFd6bdkKWeF3ookyeSYpVqIRt53c?=
 =?us-ascii?Q?qJfuFtNuvfAEH8hIzJhPcT0kxQVUSWoqUx0Jio6/E4CaQSMrpAmrIqzkXlR8?=
 =?us-ascii?Q?iUuLNH2NbUwFf7K0MlbubtrEDFWaeMKinuqWMwB5whlYswKFaEIs2aZOF64k?=
 =?us-ascii?Q?lmK7s5UTwGJEs8/aV2K7UqXZH+tLlUq8FC9rrSCCU3dAdxvNBopGdEb96QF9?=
 =?us-ascii?Q?pWEK+qiY51Hof2zpaGc679+97BXNDqeYS52eguNzAHuEfEyaIt1OEG5fWpwP?=
 =?us-ascii?Q?Aachin1UbBaPuLyYexUNjMRfkTxCa4VwaiDU7lUgcF51sNVlwUW4ltbokqjL?=
 =?us-ascii?Q?DzNHo0UCyQcbjsm6LmJFsA14kumXoyC063sI6fjGiPnjEKeVur11j+85QvXZ?=
 =?us-ascii?Q?E64sbF0pUiqcVh2KiFrJdONCLQjGY/KIquDl1m/0kuJISQg+CRQh+K/YIxJC?=
 =?us-ascii?Q?BFWkz4J9kkVdg9TXQ/TvNODIMmmjAHINsejsryY/Gp2eKnxtHe7LalaCeLgh?=
 =?us-ascii?Q?4vVtQ8UrY40lCc3F7djsD2ZDEupSH1SMfVraIPRPr+kfh8mHlqwNFEFjuyJb?=
 =?us-ascii?Q?qp6ZDZXxsEFfftccfvJc0RgdaKXvhbKoeDHPsWXNfIQ59g220w52At1RuYnW?=
 =?us-ascii?Q?GvMtTkXLHbcXjcFASnW1uK/gkMNUorN5y8oBGo7n0JKoWAYcVSU+sP6MOo3y?=
 =?us-ascii?Q?2UYohKoI/mUd7iI9iWIDU5akv3l3dxoS8KR6EF2uX4doUXs904p3o2ckxHju?=
 =?us-ascii?Q?4+b30X8U6StFFxlsuMK9n+qP3KoDGhTVqm8ADauAF6wJBWvFgdGagmfwL9bk?=
 =?us-ascii?Q?VNilgSxZg2tVZfmb3l9QcWtoFiLS8s44EZblJlpNDC2szVs52Nbw9O03YbIX?=
 =?us-ascii?Q?TWPJh+MpSRJHoPKkrRwnIvKSfQKLMlhVh4mlm3ksVUrdDHldJryo+0ZwP2Yi?=
 =?us-ascii?Q?nNPp+xdICowwo+HdNC67Kiwq0nloU/QMKi2yJSdUa15CbZJH40ccSto6Jr9M?=
 =?us-ascii?Q?7matg334z7Tr7OSB7cdMVI04vipCPyzgxeC1Q1VQIXleJdZbZhl+VBLupmXQ?=
 =?us-ascii?Q?+ktGOXLF7/6esDaWZAyWzUfgXnBFPoUviKVM0vrQm4ZEYCZjai3RHmgh5Ssy?=
 =?us-ascii?Q?dJ1B4dIPO22NCCkCEfUfHf2covmL8Ue4eTUczyhN3S6tF7mlLPwL6HAs2yjL?=
 =?us-ascii?Q?5+6cC3kHIUaNM45eDfi7eqI48Mu4/7vQMgoeJIxQh7oR83XiNXfeix7ya56O?=
 =?us-ascii?Q?CiRcQpMeF2c+yuRJCid1N1NEzapqkpO+4LRMDVG7YY22ujisd0WgjaoZS1AL?=
 =?us-ascii?Q?UQokkIRkbv9UydRsOKvfb3SXPW0enNUvW+rHBqe8eAavec4mmvX0YSotYpq0?=
 =?us-ascii?Q?ZvbukRMrxP0zMJYVv5qcGKHGp2VERzyqaJVNrmlcQVQIpYGbaVZzGtgDnxe0?=
 =?us-ascii?Q?xA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eGtv1Vl/AtB0KLqZKAwQ/J1lqkiQ+Ic2mKCajXyVMtpEt2oTk38C0jZ1npIMIhKLFt57m12dVarhxa9cxshFx1F/Ki9ZJq/UCao4rPRfN+n7erfqcl6O/1hHAHKhgSXsLo/1t7F04+ys4xpHp00t6BbnXmobeYCio3S2jJN6aGdIuuQ4Jt7LWxVNJ2lFfzhxWhs+mCDLXOd4ZL4lTaXih+pTE4ItkPQBxOD29U7lnGBRemKhTrbIdQMIfaNehfwlRHD7vXcATakV6DMVjhriEAbVgQSD8Hon54tIGs5KildkGwLE76ddMyT4iicc7m6u5zzhK9w1Crv2iAeOcFcMja/ZF8XR2db8iuSVFJ3x6v4ZmSp7f8gvtt0Ra2XAu3K4kG1jf76XU2Lhfuq+3uAfXOiWIwsS3L+/dvFYf6iX+yyULLHg9fbyPxz22OwKDmNeXSL9+2mi6EqBB3Zr1DBEMB8xnBGYVGLEffGxmw9PgYqcuY8ScsaNnQkfxZukIA+k4RLPgsJmg9xTIeFBoFFtPc7K/2uuNMdsNbMXqnoWrHwymwxL1bcOFzgZ/T6rqI/CcLcwanvQcY9EQMfUZTPy2iIQaQZbiZu900TiGVfYXr8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdcc37ed-371f-4703-a562-08de3e78aa5c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 21:01:51.0141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btN8cnatj3cMxlR7kvuGvVe4im1+TPpIdLJfZn1VuZQME7G9pwbaiaG0H+NL69ZK3dncX9+MMyG1M4F4JVPky3UzjiA1ml+HvBK36RQBWpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5924
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_03,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512180174
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE4MDE3NSBTYWx0ZWRfXyBcZB3SlGHyK
 +Sb1wyPOJQ+6ovrETnzGTOLemdPpyszsR9yNFy7mjgqaSOGOz9n61DtJZoZYySx5hD/lAJPm8lw
 Ari14n+E4NH51NpGFirlhNILpTdbH54mFiVhjGNhCQbl9AuXUl5kIF3cWdKYU+X8HNCqSRv/jXi
 ndkhp7R7G5dMkqlUn1/gi7pFnMke/wc7l55pfn3fE7hoceXqZtJIHUnfDfW+ELROgBloTIizzax
 WP5wZzuFFtfiXRL2JNgMBul70a6TfjR5ZTe41Ktc2mDAoqHVgpIvZs5/qci1FbQ9h9mNaau9O67
 X9sHFUUNDaV8mTR/dItXvR7Emo7IINV0RpfWLWKaeo+X2MEg+E6cwyPtmSA+P1kZU0cec5mIgdu
 TW0YGk9EEDIu/6kwqx7YmhDQGhY1OrFm6KoJtCP+1+kmvdiiz5wq3ZQ8sZfNEVnGca5knvkVxty
 elNLiegdj+a0jfb+9e17FsSU0/BHQCqx+5OVrYYo=
X-Proofpoint-ORIG-GUID: nwMYOdl8ZYWZT2IrDSOLuiYYSJ0AAVDG
X-Proofpoint-GUID: nwMYOdl8ZYWZT2IrDSOLuiYYSJ0AAVDG
X-Authority-Analysis: v=2.4 cv=OZGVzxTY c=1 sm=1 tr=0 ts=69446bc3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=zd2uoN0lAAAA:8 a=yRTt31GGoypLxlRcTfYA:9 cc=ntf awl=host:12109
X-Rspamd-Queue-Id: 1252C1A001F
X-Rspamd-Server: rspam03
X-Stat-Signature: 1cqah6yferom5rdxq55kj489g49fyeuh
X-Rspam-User: 
X-HE-Tag: 1766091737-296458
X-HE-Meta: U2FsdGVkX19ZUIoSbA+uW4+UuvAc7S/B5MNxuIjrbvAlm3EBGbAvjoY9JzH/skTA40KoJh21Ip3Hqy0hKf9LfSsfDV4XEZyncq5pYR7Q0OwFwnzAJhw8LjfTbCmYvAT9BPMBzuCH5GF4JOpY54PTaZj0E8MWggjU/q+cP/5OlRTyQMicOwVrpT/S//URfUqGNZA3v5kTGaf1bOAxHAXjK70aAOMPhRQy/oRmArMLHBNLSbR8qoMfPMpyYcvxml/UaIJ/b5cegnzLwANdQO0q5h1iovLAkpol3DI4c/ttpcgDX0XW9u31DMmTdzNdRvlXG61UNR0dQomFZ50FZ1vMBwlQcYsQUpweQ2NLvqbScftdL6uLbjKsDPJc0lKc6G150QtilDc98z9sQ0c260KFprqN/tGv0Y42bmbfTQkE1XLqdKFwxe789qxcZD3BeZ8gHzIBy0Cgd5OHDCkGn+KXqPinjb3XK3lmGiSABitg7USYdvvmneikZBStsiMh6Upame5SGGQswU4hPyEG+rkU9SUeiWo+fUczyzRQhGqYCp+SLc3ofCYNq5Kv6A33XqNA8M8QxVerVf5yFwZjYd72nMrGyWJVQDh6VJ7fgduQdMOFZhSwu2SEkNKBz7wz0i1TQHGqJVvXXTssXLguUVYti7OOEHXQCMk/CBY8d51iSvlYgG/vp2lhuQPJdP4blNuCla4YGCFv0D1rPL+Xe522uMscpK8ytiSdhCRWHQsrLfaAvHyOcuu8qpR0kS5r5kl9CVfzSSY3KuFiUvDW7gM0934wmEB1OmdnO9rTgHLL5qP5sFx9mnV3F9pv7NlgTBKmWcORX+1/PWo25sNbngI2TY9WAcbwrCytkCqIxg9RKOMfk0wKzdyk6bNb5YjrzoDCu/fof6G3Hx5FpckyP66GvlWxoVca+hznb1BLHn2DaWWjFIhqLdIt/vvJGBk0q7+W1m+OJYJ1OvEjys3sk8d
 sr0uqjmk
 jh9Vu6FzmnpSEGJmuS5if+UucBcU17VGiw7WiCnKICRYN+VB4KzqBVTDjtBgMwJdpF9jGjsStPPB//2nX7JbWP9+m6f7VQ5OOZASaPYOYRkHjMyc6ZaMhqdhK9AhPT7KCXoNfmoapS2GVxyB/E3BR7J6w0eAhAhDrcDgKinLI8MzRcakgGVQvDSaTE/XSJc10foE+5SrMKaRGXHnMyEdL+Oe0UWVuJh7z/+4VpX5320v4YXUl++fLYl4TABsK+DRjVbfPe2xN9EtruisqPPtZNblNolbpX6rUt6yw47v6sMnl9UCQB5mO/HTll+XeUp7M3uOVwtbQkI967kamG3WPBA28CoFlvPZFPihA7diDmBAWK6Jb/jDqvkO7QsaPA5zYLSA4bvzlwlx8qf81n0MlQjeSsaQPz5BmNp0H6TLFiFAyUVLYhGRjztHyKHVrkldzcFffRnHujGko47ysqnH57biTdb1D41fN+ttrM9oNVmNulreukaLcrisRuB6T3JlTdBqn4QMAKI3DGDoVEhcsyhdgarb6h9DnLC2fLYiRC8A0MDL4+/d7clqAR1860F4tN2ecvDjLem+eN0VZw68QoCI4A1sqYt1kjTW5jNalFfc76gKSxvHJIIb8/KiAaAE5S+Kpa7Ym/RrOwrTn+EyHIbSSqZTDJTd7LCu047Gj269Yv1Eg+SMHlW7Y9iQ2MFyB96kf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Red Hat) <david@kernel.org> writes:

> On 12/15/25 21:49, Ankur Arora wrote:
>> folio_zero_user() does straight zeroing without caring about
>> temporal locality for caches.
>> This replaced commit c6ddfb6c5890 ("mm, clear_huge_page: move order
>> algorithm into a separate function") where we cleared a page at a
>> time converging to the faulting page from the left and the right.
>> To retain limited temporal locality, split the clearing in three
>> parts: the faulting page and its immediate neighbourhood, and, the
>> remaining regions on the left and the right. The local neighbourhood
>> will be cleared last.
>> Do this only when zeroing small folios (< MAX_ORDER_NR_PAGES) since
>> there isn't much expectation of cache locality for large folios.
>> Performance
>> ===
>> AMD Genoa (EPYC 9J14, cpus=2 sockets * 96 cores * 2 threads,
>>    memory=2.2 TB, L1d= 16K/thread, L2=512K/thread, L3=2MB/thread)
>> anon-w-seq (vm-scalability):
>>                              stime                  utime
>>    page-at-a-time      1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
>>    contiguous clearing 1602.86 ( +- 3.00% )     970.75 ( +- 4.68% )
>>    neighbourhood-last  1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )
>> Both stime and utime respond in expected ways. stime drops for both
>> contiguous clearing (-3.14%) and neighbourhood-last (-1.46%)
>> approaches. However, utime increases for both contiguous clearing
>> (+19.7%) and neighbourhood-last (+9.28%).
>> In part this is because anon-w-seq runs with 384 processes zeroing
>> anonymously mapped memory which they then access sequentially. As
>> such this is likely an uncommon pattern where the memory bandwidth
>> is saturated while also being cache limited because we access the
>> entire region.
>> Kernel make workload (make -j 12 bzImage):
>>                              stime                  utime
>>    page-at-a-time       138.16 ( +- 0.31% )    1015.11 ( +- 0.05% )
>>    contiguous clearing  133.42 ( +- 0.90% )    1013.49 ( +- 0.05% )
>>    neighbourhood-last   131.20 ( +- 0.76% )    1011.36 ( +- 0.07% )
>> For make the utime stays relatively flat with an up to 4.9% improvement
>> in the stime.
>
> Nice evaluation!
>
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
>> Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
>> ---
>>   mm/memory.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 42 insertions(+), 2 deletions(-)
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 974c48db6089..d22348b95227 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -7268,13 +7268,53 @@ static void clear_contig_highpages(struct page *page, unsigned long addr,
>>    * @addr_hint: The address accessed by the user or the base address.
>>    *
>>    * Uses architectural support to clear page ranges.
>> + *
>> + * Clearing of small folios (< MAX_ORDER_NR_PAGES) is split in three parts:
>> + * pages in the immediate locality of the faulting page, and its left, right
>> + * regions; the local neighbourhood is cleared last in order to keep cache
>> + * lines of the faulting region hot.
>> + *
>> + * For larger folios we assume that there is no expectation of cache locality
>> + * and just do a straight zero.
>
> Just wondering: why not do the same thing here as well? Probably shouldn't hurt
> and would get rid of some code?

That's a good point. With only a three way split, there's no reason to
treat large folios specially.

>>    */
>>   void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>>   {
>>   	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
>
> While at it you could turn that const as well.

Ack.

>> +	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
>> +	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
>> +	const int width = 2; /* number of pages cleared last on either side */
>
> Is "width" really the right terminology? (the way you describe it, it's more
> like diameter?)

I like diameter. Will make that a define.

> Wondering whether we should turn that into a define to make it clearer that we
> are dealing with a magic value.
>
> Speaking of magic values, why 2 and not 3? :)

I think I had tried both :). The performance was pretty much the same.

But also, this is probably a function of the benchmark used. And I'm
not sure I have a good one (unless kernel build with THP counts which
isn't very responsive).

>> +	struct range r[3];
>> +	int i;
>>   -	clear_contig_highpages(folio_page(folio, 0),
>> -				base_addr, folio_nr_pages(folio));
>> +	if (folio_nr_pages(folio) > MAX_ORDER_NR_PAGES) {
>> +		clear_contig_highpages(folio_page(folio, 0),
>> +				       base_addr, folio_nr_pages(folio));
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * Faulting page and its immediate neighbourhood. Cleared at the end to
>> +	 * ensure it sticks around in the cache.
>> +	 */
>> +	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - width, pg.start, pg.end),
>> +			    clamp_t(s64, fault_idx + width, pg.start, pg.end));
>> +
>> +	/* Region to the left of the fault */
>> +	r[1] = DEFINE_RANGE(pg.start,
>> +			    clamp_t(s64, r[2].start-1, pg.start-1, r[2].start));
>
> "start-1" -> "start - 1" etc.
>
>> +
>> +	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
>> +	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end+1, r[2].end, pg.end+1),
>> +			    pg.end);
>
> Same here.
>
>> +
>> +	for (i = 0; i <= 2; i++) {
>
> Can we use ARRAY_SIZE instead of "2" ?

Ack to all of the these.

>> +		unsigned int npages = range_len(&r[i]);
>> +		struct page *page = folio_page(folio, r[i].start);
>> +		unsigned long addr = base_addr + folio_page_idx(folio, page) * PAGE_SIZE;
>
> Can't you compute that from r[i].start) instead? The folio_page_idx() seems
> avoidable unless I am missing something.
>
> Could make npages and addr const.
>
> const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
> const unsigned int npages = range_len(&r[i]);
> struct page *page = folio_page(folio, r[i].start);

Thanks. Yeah, all of this makes sense.

Will fix.

>> +
>> +		if (npages > 0)
>> +			clear_contig_highpages(page, addr, npages);
>> +	}
>>   }
>>     static int copy_user_gigantic_page(struct folio *dst, struct folio *src,

Thanks for the review!

--
ankur

