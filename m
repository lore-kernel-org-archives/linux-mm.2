Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E6CFCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 04:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64DD28E00AC; Thu, 18 Sep 2025 00:01:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7548E00AA; Thu, 18 Sep 2025 00:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497258E00AC; Thu, 18 Sep 2025 00:01:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 321DC8E00AA
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 00:01:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C6D7C1A0750
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:01:00 +0000 (UTC)
X-FDA: 83901020280.09.2E46846
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7B81340013
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:00:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JQ3tf6tZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ONcBjPW9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758168057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Pkqqf58gk5MHLE+ixA68tjpxd4gzySPuoVd4H0ytKk=;
	b=L7r5G8ye+vqC07YKje5g/V1L+U3LdnjBkJHS3c2Wt7z/cTD2H39nq7xMIL+i9jjnpSLHlR
	QO7I0CZD3ZatwcnDM34q2CJwsItjk6mcHmRyu2c0je6CV3BLH+3Zj5Fq1SHxUkw0kz+Oy7
	99zUcvsm58TtogTl46bnIn6Ub/3vtqc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JQ3tf6tZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ONcBjPW9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758168057; a=rsa-sha256;
	cv=pass;
	b=cIyYZBSsmkZIBtqxXXyJpCCUkDBDkynv5VSybhRSLcwMGY1x2eVwgSSvKJFBHlf7MfHtgy
	nacK8dnrEqTp7R18ofndZc/89ONjJuQkGda0inFiPOf6eUtiJmj5qZQzVis9yfj+glyKev
	jBP+rtXUTGe1cVNSuw7ucKpWbaM+kf8=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HMXDxS001797;
	Thu, 18 Sep 2025 04:00:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2Pkqqf58gk5MHLE+ix
	A68tjpxd4gzySPuoVd4H0ytKk=; b=JQ3tf6tZcy85GuQF2vheKZPspfge4Bg5GY
	S2vS8wZhn+7ZA0+U7gSOHjvlsYra3l7KHEIjcQ0rE4cwnpk+8bdpHtE8eFBd0L2J
	WdId8ayhR04YWQK92EkgDEYNM5/yXJVvownHn85YeI4ivUXjIvY7gailDkgfzzHK
	mM9n5lkJMB14JJWRFW9UJlRGN8RqMF5vWUE5fvSDqHqhiOHY/8LEoj8Wx0+rksC5
	d5LsrgNpGKshlmhn1E2mfYabtLKgHmb9bnFwZRxUlDoN7tTmlbACpXEgyWA4YAOP
	2d0fS7NHFjNleeps4AN2NAnHj1VnKEWnPFJMbaudis9JVUEKDeYw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxd2jxj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 04:00:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58I30Ecu036850;
	Thu, 18 Sep 2025 04:00:38 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2ekptr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 04:00:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n1GvxePKMO7mXZtUu4KXpuEmDqnYIamFjdj2BgdMp5Ry1OO8UrCfLDVsQOlvDT/w6hOzUjPNcenujpx4BskJS3YoNJVwLN/FTWhXxAy8QEReAnLkMZxhs1z7c5OEbavMNWuR+uvcsVDZf4AhrpbAAUTazrnVn6usfQzqHFbikipAviLC9XlwuTCeBUlgj41mrtvf0r7cVeEucN975ryxQTUxa2WBLb+fGFUH9pQ4RDZ0duGPX2xs5o3V/bt3z4/Rg6+US+ckG8DrLogHExsI0S3Sv5Cyy+6y1qaDfIsGSrGmq61QzqPw3XcKVsojvMpGf5KshC+ndmt4e3JpsYJz3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Pkqqf58gk5MHLE+ixA68tjpxd4gzySPuoVd4H0ytKk=;
 b=vkegslGe0N8faJ6aV6+j39V5ZYYR0A1GNvY7QlLcNlWcOCXlvOHq93ZakYv/XKqjEBPIs/6VZas4t2zC2K1sNuxbICZOSqdevVSffxWlMQRUG0hYz739uKhd2e3EdSpKDpC1ukyUAy4yviztljnixZ/Vdv7LvVzcZvUdXHyGJd+l0ZwVL4pDNxLF/iwiG2KG3AKLw/u9vxQVscQMTvOoyBVWDTdzKlvIyhJdUtLAUsBNGtWCIwtuGQlRwkMSgrRP2QriVXAWCtkaPMevxAvoFFp2uHqw5PKjJcIqpjD3BqBFxVfGIxQ/GytP0jEuj3mfOLhO/gWjUIvND1gbdDMvfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Pkqqf58gk5MHLE+ixA68tjpxd4gzySPuoVd4H0ytKk=;
 b=ONcBjPW9eldAwX+GreNZT5us4/TB3U931IcfSFWdnhb1xcwvqRj94unjMj5RC14Nw7SqGrfyukvXb/xWoXn4z7l/X3UyRbys+VlOD/qkov1zqhYPH6DS7aGkuo9Eiwg9FYooM/GcHGAokYDzFaImny6/r7C4zdbMDmsQ1ddmaUE=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by MW4PR10MB6509.namprd10.prod.outlook.com (2603:10b6:303:21b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 18 Sep
 2025 04:00:35 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9115.020; Thu, 18 Sep 2025
 04:00:33 +0000
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <aMrh3h1gCIyYz873@x1>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        david@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v7 00/16] mm: folio_zero_user: clear contiguous pages
In-reply-to: <aMrh3h1gCIyYz873@x1>
Date: Wed, 17 Sep 2025 21:00:31 -0700
Message-ID: <87bjn8if4w.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0249.namprd04.prod.outlook.com
 (2603:10b6:303:88::14) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|MW4PR10MB6509:EE_
X-MS-Office365-Filtering-Correlation-Id: 30ee5e65-a813-440c-ffd0-08ddf667e9cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BhWcf/FXCnqVhDHyfBzsepZCJamMChFLFBPhxM1gAN51rZFVdGh4qOSJ4u5J?=
 =?us-ascii?Q?7syWzfBAu1IdZX3Peq4NbGoGOGgcx4GrAJZdAIrPWZ9hqL7zyZDAlDy6b6HN?=
 =?us-ascii?Q?iUrxcB6O+EBsoGqDKfGNxe2UH7PtwQvV3Hl519LzRTI5VzoVCkperrdNadCP?=
 =?us-ascii?Q?nI98rHcwLKYvtYMyEyovjobgEvDo8tTpx76T9fwXwCTdHjZrEwA5InHzmsX/?=
 =?us-ascii?Q?Jpbb9yPqPJbKjnsEIm/TVAjGPSzqZoWmVWcxwT9mQrQHUqLTrOxsBI17OtuF?=
 =?us-ascii?Q?UTlmfiSEcPdl+xIMiLLq2sUpLjK0sAbgHO6LCA/mjNd3N0Yux3mPSzJWTu+F?=
 =?us-ascii?Q?f+Bnqn5L+g0m/P1Yw9bpbckUw11F+4HId4Dtko5UlcmK7H7BHXr6g4CWye0q?=
 =?us-ascii?Q?7moeaMy2sXJULGCZhAc+saOPJN2NkEP7ikfEUtyoUHFsp9nWkrA4KpCfgg0g?=
 =?us-ascii?Q?VLZT3cZMEmHmANZDzMZ1qEfcIvPjulz8UoguEc4fsePwz8NQjyFLTKcCB6u/?=
 =?us-ascii?Q?smIqvrF9CabEyCicSjq+IjCBHLD7q9Y39FRYnB74BUM9SeTb9SHf4zep0ZZS?=
 =?us-ascii?Q?ebfaVlEu4pTiqU/tz8qPYTXJnafRQXOB9K/+fKhdtkgJszgUrnFdECIMyA6n?=
 =?us-ascii?Q?a7okRwTqAi1/KwUiOhR6FAdJEOeVjaGcMwF8WZ0CFcne6YSYEeZVQoO72Rx+?=
 =?us-ascii?Q?jTgFce0QCmJlSNJWPjpVHDDcAQExZR5GBXV0Dr/nCrJIKjBHxZUcL3fvT3xh?=
 =?us-ascii?Q?9/NFn+wO6u/e79vFJeZAR06m/NWrhpYdDXiHriQsN/Ix2+7/ruHdX5GWoVtH?=
 =?us-ascii?Q?fe+WRmZAOfP5kEQySRpo2sZaJulgSRXJEdj43DWEQAW/Sz6qmgLXnMAlZH0G?=
 =?us-ascii?Q?J/1NhkXJuwF+GgxcVtufQUXrN0UrlYHs6uL4kcTvZ1OYd+Rm2ytAoWnyUWX1?=
 =?us-ascii?Q?/GcD0mzaJxzyfpgifOx696O6ex0xaxxEHAg9J3O1Dh2HBa4GXXtq8/Zzto+f?=
 =?us-ascii?Q?mm5f9nG8edc6FUVOf1bEM1taNGNVaT4qAnEOkxxNAkxed60etEO9DDzI3vQB?=
 =?us-ascii?Q?Be0wPTUHKp8/qzaQOeUXIgV8D8NNq7TD+VikT2aOtYSY5Xf7CpUKZ7MOMG+Y?=
 =?us-ascii?Q?Eo12xVaLGIY5V+AF1KY7IMez/FfrHO3yIhfVVYZbQl7GOkcQd0tRVEOFuXNi?=
 =?us-ascii?Q?t3IW/CGHVDcphBDC+NhymbU8RnaLTprDCCivI/kmmEvBnQWRcAT1mtMJz0Mx?=
 =?us-ascii?Q?0pE0LXgvA0IVRKho3NJf7Y/F3sTfCgqviaZimYIzfYvWwggtT44GACMtecuQ?=
 =?us-ascii?Q?05HH54va3idox+n940mfR3lnbLjMVntoErTMmUikelD6bFRkPqJiqTwHJ9cx?=
 =?us-ascii?Q?FR6p5YkFK5oDKm9S9NeDiRGmcnhVhY3RpJyjNVPR322WCi8F4iUWdNWQR3lX?=
 =?us-ascii?Q?V9jj9s4kA9Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NchG7ndACtNZn6Av71vwhIh5eDwgb23PNY5cu5awioWPOlSdCwwxpC1E0aAW?=
 =?us-ascii?Q?Xirg0m9FCDy269uCsh8gwvtC/Uei4tC9II3eqObovrE/zC9M/FWNCm/TnzgJ?=
 =?us-ascii?Q?Oq0OCEe1q1+1DR6YzlXp+t7axb51exev4F/xMv1d+jKjdPwjWUQjHrEZFx9U?=
 =?us-ascii?Q?Mge+BuZCRAn/F3JyaEcN2l+CynXhxXNbBXgAoaJ/5EGkwlztvxctQyhaw5/W?=
 =?us-ascii?Q?KInHh937pqfupeL45eKwv6UBqE80IJSfp0L2YAXTC5wp5yLc2m4yKRwEUDAh?=
 =?us-ascii?Q?IWWw4mzlSVjp3ynQci0Opx8buUHIkpPj6Yg+KZjm+xUVWwdeuC1tvy0+FVFF?=
 =?us-ascii?Q?ooNKU8qxm91Hk65qxxUruT0xdANuWZsyMpYTV+JrSChFPlrmp0K0G6R0pCDu?=
 =?us-ascii?Q?puo2eBDyh5MpJhGomJI47Odf4qehPybTMFSiFlgO1pU4gBERb5Ua3HIzIKUx?=
 =?us-ascii?Q?1kTTQjRXdiEHeH7GaO0lb5D8qWjao3X3qP6eIx3zUSZAgNqKNNa+gcLmYV0G?=
 =?us-ascii?Q?SarjsPJCvgyujdDbcmo813SRe4Rm738JdAKgOvNItEpO5pTUSiuY6r0/XM//?=
 =?us-ascii?Q?aTwBOK2ydppahLSwxk4Y4vKfZpewurzrftG2GpD1KjwB96xFEAAvWHzLVPSe?=
 =?us-ascii?Q?wRjY/S8AVZoW+LxPK8StHfrWrzfpZ4h0ktaUdx0sIad5g3NywFZaA4cTrq/x?=
 =?us-ascii?Q?SxGuH9yDpMYqHOAEpCBDpSaBwsi0ziTs9dmkhsuTYFtZXVZCzm94AuyMJrkJ?=
 =?us-ascii?Q?3vBWkvphrkuK8k+95dfzr3KVF+iA13ZNl3UtqUs2cB+T9F9GRmL8iIyR3age?=
 =?us-ascii?Q?e7L5xug5329R/2/REJWPDkJU8P2bSKyPP26qs8kO7yqrxyfMxQMFSCiwzHp+?=
 =?us-ascii?Q?cgVd07vrijthdvo9cbkhAdqr9+xpSVILxk2Fv4tk1UVaZ5MzHbPJympcVN33?=
 =?us-ascii?Q?yfgQjprhB9ljSyqX0Z9OavXFf7OGF5eJg17mHohTBWTjIZwI+bSBYslNfyH+?=
 =?us-ascii?Q?gDZF0+au0jmsLhQty3r3JnMIl5JSZASc6YObxmGv5XAgaD5zMyxJvPEJkcI9?=
 =?us-ascii?Q?qXlGmu4WXQzKAmh4M8w2ZJrUXL2J23KTdtZoM7xOQ9RsNuiS9mDLFylOMDDp?=
 =?us-ascii?Q?RDpVHlVtdvwHA374LElSqyfQ3q0h/1W9eD8o7OP2yy2KwMIl1sU1TULwaSj4?=
 =?us-ascii?Q?90KiIKafhJ1phAfgHzU9ADZzdSK10oTsKD6iq6ev7w3LO59LkL3/ogilADRu?=
 =?us-ascii?Q?JONUM5StezjU7keNeAfx69pdSU7vGTW76V5bZE4guz6j6OnzK+nWB2VFABq4?=
 =?us-ascii?Q?uvmd//mYZHnWr1CRFL4jMi4RfiuTHcrKiRB+X4saY5P+cqmdUfbhDFCfzstd?=
 =?us-ascii?Q?5hCO3CULmAm/hkvJ7zaNccTR7sNtzH2p7H1Nt9IsAyaQWANI4tres/Euzvl5?=
 =?us-ascii?Q?sWCkhbfkqjFwJCoj5ojDPPvGh0oDuTnBbKsJgn7ja4KCtPH0UEusnwYOOY3L?=
 =?us-ascii?Q?6G9KRc26cJ/pt08tUMgpJA16kiVzrNUPlQ5Bw5wW7Kj3GawimCgisGFMFWci?=
 =?us-ascii?Q?qti1zinFCL24TUDzn0Hd7ucZI+/muQO4XMWJlkmgxiCjzG+6Vm6Z75y8gWA2?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cvEqZh6P6/5RGIDfgVlQgBXyw8hyUwbrs2shwvjRSzHoEQ7YxeWl2u/TB0phnOMlCOG0ub6/h7EC0hLhSILra3Ii8rAG+C6b0EkB3GOio0g2aUljtIp0RcuFW4/Ol0D0esNugmDzPB8ijNXH1JRuwCN9fqjGf06VFJoehdrTrEGIj7Nr9/G2G8Hni9EkSzYy500LKrXDrq3MT0sqgoaz/DmyBU2qsAC4OjxGNH4B5OSb3qZJQfk84QtbpBZnEKysES3/d24g8JkBSpdvqw5fW8QiVyIOrBdGEJJn0+PHlWh67G4LS9QDiZH8UOQ1q7sik/LJEwkNb2UHIMiJUxegYQvq1WOkkCPA6zOPYGb1As4Qa/C2oGKM6YFe4B3MbNKqa/W+wCV1sNDnvdgurGZz7CNqsAVYhqFO1MiF8JJv2tk8cHr50f6M6oZ+ZHKRH7WGfAos1IRLKHBA+g1zFAZT7HR4RCPq/6Lbv9ws6YPH89NqbwAbxFh4408OIZ9VuElUAjyox4dZStaMdKTId4W4W/hEnPvHSmLzvhPci3RRngr+HJvvW7PQ7WZdPxJqLLXoftKEJvleAONIYGGtS7Y855UQRXDEf/xWRpYLxq9PN1Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ee5e65-a813-440c-ffd0-08ddf667e9cc
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 04:00:33.7997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FwZwYIPzpSIlAE8xSBN3lhZl00XwniiyUWDfCgc+U4Wcxe35w/lzQNHVopRf2zaKEBfbSXOKp6TD38sfXqQPv+2lYFe/Wygh8sEBoyJEKB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6509
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180032
X-Proofpoint-GUID: qIXIJUjkswS9eu76ngHGwMrMQBC7Duw5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX5kl/F4CJ9m/N
 C3OK3jYYzLVjN/cV7+ADy3oFNcb2LpKq879xF6F/qm8syfX6dOHlq6C1Xq8mKS3Vg7ck6pBuPt3
 FyqHuCv+wbhgHcH1psIuSfFZS6m1VryhZpvc1+ECklt2beD4MzZ2euAR7jT3E4VmZ+Bw0XI6kiQ
 n79Z2APuTipMmoWruDZ+FxGEhXRvw/5s+M8LjgN5FjF5Dc8C9xkeNNQGZhgBLt1v6nHD2x5K524
 FKy5Sdnzfa3NskYHyesr5eiN7wytGhvk/k0HlRPWLhjTGjkE5E3muJFGrWv1hPcwM4DZ56m0w0+
 QKffiJMAMYS2opUdDQG2fuSqkAn0qr2AIvbQcURXDU9JaXDg4HYd86LjM0EOhE9PklG7YZTcS+o
 FE76K6T8CqSkA2f7hroa3QVODa66nQ==
X-Authority-Analysis: v=2.4 cv=cerSrmDM c=1 sm=1 tr=0 ts=68cb83e6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=wIUMQn-w5GAMDpwLP48A:9 cc=ntf
 awl=host:12084
X-Proofpoint-ORIG-GUID: qIXIJUjkswS9eu76ngHGwMrMQBC7Duw5
X-Rspamd-Queue-Id: 7B81340013
X-Rspamd-Server: rspam05
X-Stat-Signature: peyy4kf8hanga6fwix6kxg1ddzxuyms8
X-Rspam-User: 
X-HE-Tag: 1758168057-902756
X-HE-Meta: U2FsdGVkX1/+UpnMAqRZTOWDCWGNHqjbZy+vRO2+Bla3QrZlUEPZTBfH3K+dCspFFKJjWvqs1ckf/0d0WuozbStdD9maXHQSJv+Az+ZkYu+ABIvYoO48rq4Wd5Cjr91xYJXHBHEItvdxifV1UIjjvHd9wvtis7pzky8Hs2v+WHZdi3l5qWq7O2oAJVSlU7nj4A8mre1wy60K+v+I1KH51hftz8UM7teux9Yns0wvEmmf9IkaVyoMTDWQfp1nQF1r9f7gR3zoNccVMe5qIPk5UlgwwAro+D7I7mJVQnUodjwyF7x31yqnPqZYudJZmDOju5YQJgZHt9Mo5KQhKljRiQiUwGcqgnM9i7CWVcpr1TCdigPrQE2F7IjW08zz2Dqic8MxZmbxNlhSZwTrSRSoDmfJOpd07U3XmSRxZSAhhVI5n6METLyW+G22oikIXYXYz+T9yWcYN0OGAwptpP9m83SwBGcSZAvNGpxXcq30IdGrULSlQEzRxX4M62cC4UPVbmruNyy81JeASB16AsWv0HV1lw9ApUBf2Xv0/bGnkrCTwHPV6M7TbIuNr1E3XIMm2xl/kDPBTJgmtDWWLb0AZmPtTXa68WlXE6jR+eGLXmLLGvkBtG1LDzNhlMqXFKG84CydiCoqN8OreV5mQiz0epXtpOjq7uW/ZwN70ifiZlzd/aOdFbjW43imdp71qGUGb9njs+a36v3dkJkCUiH2AgdL1RW7k/EMavnVHLLsylfj8j/lEJdVzmX/uqNxbKVZyYU/xMWB5g1MD3B+D4PbIB0MXW3eoOpmV1C6MhZmq6XKCb7mqIpsW8tAzf21xTFFQOOg7vBKdAgjsfcwVvH95nEo4lW5zBpIqugW8YD+21WJ9bBvjzPtvqJGPzXfJd0JO61wzTcDDUHkjC3u27/L1bNnPwerJa/PfocmR+vZdPe9D5JghDGRqOHLT+SNB4Hqy/1ybU1C5hLJXscUEg1
 JbEc6sik
 wenuDX9VnbFCP6v5FTIpm9vE4hKvFktNkzAFlrMLI3lnPe+ujfndl6Uaxhe1ke9H5lk7fWGNu+ERJgNgdXqfNNgCzpwLDAuqphkr5CRbA0uET3aNSnuqTlcYUwrgArhDNwxsO8XgRJiEwywfG6woDw4esxXQpeIccyI1Cq59m4omZeduD9+YMR3iSsMVDFiKmczSrDwWLnMh9umHU2KO4F6fOz7GrJiSC1p66L4IELSgtVdRpyOcshkDpU7C0fECZnAdqF5t/mvayJKLNvHtMtL/THSewyZ+97APQALYeTROokMEyEwrNKxfn5YxLekblDSCGhbTcRzEWfOzSA9DKybVO9OwpUa9SIu1xd3f8q994DyLPy0SUBgpaEJAzArrZwCg+e9Fpm97Dt8fd4GVKu9d/kyGp+FuXpl3oTqXUVH3p3YAZRuwnCVk3q3WFnQQv5W88gqhCyLPLIljGDDflsgZm1p4SHfbH+4qgBtm2tIm0bk8xnWebQnM7JaiAwIbNunu+3dZ79HqPKerVl9Gc35G776dWaIzFRLQW/4ep21LYWw7qDBL0+1MsNBEaz3B0cc+s4Du/gaW4BQvQDVxele0OcSOrij1zhpJ+px8wnkQcnXnZFG7lTedgXwxbkltrmEx8+oZ6M7d/4dVHp/NubKKOtuv0evzWyVIqpU3jzxqK6taM3i2MEnSXDu0HEngKu8Wr1i/N1pZDNrQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Arnaldo Carvalho de Melo <acme@kernel.org> writes:

> On Wed, Sep 17, 2025 at 08:24:02AM -0700, Ankur Arora wrote:
>> This series adds clearing of contiguous page ranges for hugepages,
>> improving on the current page-at-a-time approach in two ways:
>>
>>  - amortizes the per-page setup cost over a larger extent
>>
>>  - when using string instructions, exposes the real region size
>>    to the processor.
>>
>> A processor could use a knowledge of the extent to optimize the
>> clearing. AMD Zen uarchs, as an example, elide allocation of
>> cachelines for regions larger than L3-size.
>>
>> Demand faulting a 64GB region shows performance improvements:
>>
>>  $ perf bench mem map -p $pg-sz -f demand -s 64GB -l 5
>>
>>                  mm/folio_zero_user    x86/folio_zero_user       change
>>                   (GB/s  +- %stdev)     (GB/s  +- %stdev)
>>
>>    pg-sz=2MB       11.82  +- 0.67%        16.48  +-  0.30%       + 39.4%	preempt=*
>>
>>    pg-sz=1GB       17.14  +- 1.39%        17.42  +-  0.98% [#]   +  1.6%	preempt=none|voluntary
>>    pg-sz=1GB       17.51  +- 1.19%        43.23  +-  5.22%       +146.8%	preempt=full|lazy
>>
>> [#] Milan uses a threshold of LLC-size (~32MB) for eliding cacheline
>> allocation, which is higher than the maximum extent used on x86
>> (ARCH_CONTIG_PAGE_NR=8MB), so preempt=none|voluntary sees no improvement
>> with pg-sz=1GB.
>
> I'm picking up the tools/perf part for perf-tools-next (v6.18), already
> almost 100% reviewed by Namhyung.

Thanks!

--
ankur

