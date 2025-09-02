Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C314DCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6108E0009; Tue,  2 Sep 2025 07:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26F7A8E0001; Tue,  2 Sep 2025 07:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137948E0009; Tue,  2 Sep 2025 07:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F03F58E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:13:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9663E1DE694
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:13:55 +0000 (UTC)
X-FDA: 83844050430.06.A54CCD6
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1E8091C0009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:13:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ONSrSVfI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mZLPfBsb;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756811632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUSabZ2ImtDOc8hQqBEjXnuNo7sTm8kjUlDYbPAGHpM=;
	b=r66zdj+z+eWlTRWwKH1Ig/j+V97YZddaRtBUURR5TElpUZJ3VoLHA8FqwA5+MqXx7UTp6j
	FMYld1WhC+AGK2i/KgbvEnnVkSKrmYmjn82AsNpKN0zewumal3Cfc8tgugAqw00V6P4J9u
	qLzIDcE9284/uUVzIBxU/0NZwDHpeME=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ONSrSVfI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mZLPfBsb;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756811632; a=rsa-sha256;
	cv=pass;
	b=4iH7akMFh1p02f9lfBB01pEcSIkJhg94Xkf5q6REPWXa+kTs1eAbLCFRQLZTDVlfz24bk3
	MlU7XoWW4CyqLZeDUisQiMnWlEbvMtDHAFUTct0psRqiD9qj6Cvu/wjm+37lhtB0jlOEld
	GK2swuEKxf6rqtsZNfFYjnfw7hSg23E=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 582ANVgp015347;
	Tue, 2 Sep 2025 11:13:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qUSabZ2ImtDOc8hQqB
	EjXnuNo7sTm8kjUlDYbPAGHpM=; b=ONSrSVfIpDim2ltVTpGsR+QAwyh8O73mxu
	kWK6fnQ69v6LofAGjBeS8nBOkIP3q2RfSj8C+rf215q46k1a18H70Jv5YuDzoZoa
	bHOcnbog8SmkptEck9aM7NOE0i5RlUUMwL7WD108K0FkvlCgN7Bqcu3GHvrWOKi8
	NmL1m0o/nm1hIZn1nX3ZBt43wFHTa4kU9SadvAp5RM8Enm1LiD5NFqg9kMDJL0h5
	qS+Cf2yjT+Nqa6ef/Gk69vDY/MDSZNDSgy8yjBUD1td6EBZqfDXXHvfw2KxgOqdj
	zcdg0XDfUDpkBB+7i8ueKOdoskDLRUNMaLTXSyg2v58XTzdZms9w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmnbt96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 11:13:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5829f6d0032530;
	Tue, 2 Sep 2025 11:13:46 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrf93er-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 11:13:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eMWdk9x1Qk/osW3U+Qkkk2aeBkvQpr+H3YnztLkQVUgLr3QdenQgxx2PCW97O2jqv/0dO2d0hsbEZq+8WEgDjbeIt14ScTGtR3BVIzAhqPWIQayoJZeNW1veccpnu2+xZZiagDFmZsSlEY3kgW5QBFoZcFSHljNDHHQGlTvJjdWhwaIqX9bdCLSJmbIEt2t1x1c7q9TsDnAEKFzqj4z1/5f7zUZOQcnl1CMmKkQsCMxLBmzi9Gx4qfeqiRm3vSboUBTVY4qzYTpe5x/rYJLFg2Lu6HZ4fRH2Zv8bOKozfp4bj8tTHcs90ibnvuKJgpvxSBWFKm5lVsrOqXkV8LyrZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qUSabZ2ImtDOc8hQqBEjXnuNo7sTm8kjUlDYbPAGHpM=;
 b=JM6CneiSKceZX0o2934fzYY5hMzF+s7C+okMYi5PrfGDM8mHU+JzJ5APxHSprcOZEUSs7j78N5DQbsGJlJJPyyJ+mYj/yQyVsmXZ61hgpSc2xa9r7u35IDYXmhdKZfnYNkR9oKvUDYVSPfmGwzRtXaYVDlPSo5BiHNF10CmAjHXm8KAh6pbee6QPW8geXLs7QDg51PNlop7oVlfctDIRpG/fyvC/2iz9WMVD40Wco43apbmFiY8SPr18RfjKx7pYqlktOdrVp4kuzjOD9OGO/GVBYMmer2Rvwbgx2/Yk8IJonb0TwXVqJ1f10SnMC3A+e5ZW+j8aleQyZTpqf/1Dpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUSabZ2ImtDOc8hQqBEjXnuNo7sTm8kjUlDYbPAGHpM=;
 b=mZLPfBsbSjfc0hUuJIBcmma3V+93stY3yuJmKRoaQ5BhACeXUPFOa3JFus0bEtYa3oxQaObeVJWRsMR+AvTimzqk41FMZMjUfUsxu+g5odsAR2vM9/HCOtmcQrH4kXlTkpkvrvXPA0biE2/aY6Jq8mXetJEgYGWIHooF3zN/RfU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8009.namprd10.prod.outlook.com (2603:10b6:408:285::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.24; Tue, 2 Sep
 2025 11:13:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 11:13:44 +0000
Date: Tue, 2 Sep 2025 12:13:41 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH v6 08/10] mm, vma: use percpu sheaves for vm_area_struct
 cache
Message-ID: <195d00ab-5429-48ff-b5dd-a45b26cd9ea9@lucifer.local>
References: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
 <20250827-slub-percpu-caches-v6-8-f0f775a3f73f@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827-slub-percpu-caches-v6-8-f0f775a3f73f@suse.cz>
X-ClientProxiedBy: LO6P123CA0035.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8009:EE_
X-MS-Office365-Filtering-Correlation-Id: 338ba9f0-3da1-452e-d381-08ddea11c789
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YFzAZRPzbzEtcJonSDzrFZ5JGb2OinBfVU4os8n0hKOrTGkbaLfR0Oqzlz/t?=
 =?us-ascii?Q?E4ILTaOZgTVCOIhoqjwqt77+ZUUw7L70kI0ulbbRH9XcMJZMfoKN0IARXr5U?=
 =?us-ascii?Q?O5TquCfv3AwUbF1Wpc4PJZLy3NXZxw0kGrr7hU6VOprF1We8CcKDFU/jozWV?=
 =?us-ascii?Q?8UbqsP3Nq78zfttaItW0+RxPrJ1aJwi71jKszJcpOy2x7M2KsrEIg354XaCN?=
 =?us-ascii?Q?e8uFuwuUrSItG4JVMKQ8/CZsFfGJ/dGUn5iFCA4s0UStFtrrgN9bE/9+juIR?=
 =?us-ascii?Q?hxyFSfeukQcUl3e1AQLoyj076QeBQNLQMrgttOJG9HelHNm9N70C+LHVb9UE?=
 =?us-ascii?Q?9cyiRQPxGZ9S3am52nZx3pPmDHMM/IPegcdI4BJPM/CXKhSokdIpWcCEOgwU?=
 =?us-ascii?Q?eQ5b9WXqKzrtqCYsy+XLT19pjaI+5U7yYVFWQMs0LVCDNQjYaW641NnWdvj3?=
 =?us-ascii?Q?c8KTqDhqvxl7MVYaWLLh7imiMSGDl096p+cTu15E1FLcWHqlajHVUEXtguu4?=
 =?us-ascii?Q?mXv99nJhL273HHJeVI8eGCeQ7xSzIICM6sFyS01XDnV0kD6Wl1RzWUobnBZo?=
 =?us-ascii?Q?Q/30vhbGpcugeZf5vt7/3pzxB32aasVsTvhog9VfgzoFRZHHUWgn5FRRwrfC?=
 =?us-ascii?Q?oXcqfalQD2yvPle5XmaV/FmhPevWBlj8Tj37XHV8q0y9ESTvXNjYXl2bcYIg?=
 =?us-ascii?Q?in2KYqwh36Cnt28BWAyXM4cvlO4Qyiwlb60kkfXfQbnZYHA/af3w9q1VmaCN?=
 =?us-ascii?Q?0pT77L/p0sAD4i58KgFfT8X84e90DwEkJ8dGSQ+i4FoYvcA0ptaMuMhSuWG4?=
 =?us-ascii?Q?qB9gDWISLM0X7zDMWQMI7xCDPb0gFtr7XrZUXpMWDbsDrZHMqm022B64PNOX?=
 =?us-ascii?Q?JDwlbT1Niimius1aeFUyn9uCjlTzobP5zjwWRKBRVKpe+AVNq71qf5AVhvyO?=
 =?us-ascii?Q?lEKaC81VzXXQNNZpVgoOyvdKqKf4D4AiC6xdnzTgg7fcwxAuIriJJ8ZkTV3e?=
 =?us-ascii?Q?lZTAlILeLB3tAjl4TF9mJXKzFj0pskAWOQxYbRXgHZIGONKgsnBMB7DPr7gd?=
 =?us-ascii?Q?dEZBvIrAxiaSDmZZW+DjGlELSVqNoHI6Ly1rbICIlP1oLjMMFleNcn4RVLTG?=
 =?us-ascii?Q?HZvPeGnYMCymhJMo0s6UxDYHUSz2fWw5Ow4HdsrqHw8Cvcfm5MyP+RFF+jtv?=
 =?us-ascii?Q?K39dIRgl8qCzq6o8fIjLFtBUVfrfmj8g6eJnXub6gDErhR3RhjFKzK3/LhtN?=
 =?us-ascii?Q?+uGnjxE/nhv/ToeS3brttujK/2j/76iBJSKNblf5SiyH7FfAMErhsV1UglMC?=
 =?us-ascii?Q?CvIMC0fd5qX7ADNXOdkGS9xWsN/drlq6uZUL7JzH8ri/5eacluzzza6quHB9?=
 =?us-ascii?Q?6nSPPsCVvyYN1f+h5khh1ICffglC8slvttuEcM3M5TxC8liILNGQ5sArNMR2?=
 =?us-ascii?Q?W/3vLQXkxP0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GxwHQ/dAi6Nek52HWLvoXQSWGT5UKsWnq2lYkhM9DwVw5zP7cMC5F0x150Kt?=
 =?us-ascii?Q?9LTYY/oYPU1WQ3xOJgGu0HJeypKe/8uTgR32iNaKyAyhMjdO1zKOqM4Fpza5?=
 =?us-ascii?Q?drBNHZg/KDLHOJ+beiVbtZoZ+he7+xBrSTLNYV6jPskt/w9LfjmQCUjApIAx?=
 =?us-ascii?Q?zwwwyeWdVpUW4bVfIoxnocWHfgYRg+wO1gpUKBKI6b2F0XGhzevTGfPpDfS3?=
 =?us-ascii?Q?/iITS0hRcFlGfpxOm2V50Ef53ALKbYW6R+5FnmsI0Kp97XTiVv5QZoi48hKt?=
 =?us-ascii?Q?NFK0ogQUUQRa92AARVIIGqH4iJFGyFe9bGUgR/TiWbJTPPJ9D/f6cCkE1Bw1?=
 =?us-ascii?Q?jd8Xdo7rV+upZXupTPP49G2EAN30c9y5N9Mv33oq+7BGeizYWrNDibmAICUI?=
 =?us-ascii?Q?g2csQ/u9YzXJnXcKAJtjGfQ8O3AJsdffZ/Bv3GLpQJ0fRihGa/eqm3dK6TAU?=
 =?us-ascii?Q?DKezOW8qBuy2Gu8uxoeygFDpiLG7qTso60H65WYzrJaXH4t+KMGEOlj2l0hr?=
 =?us-ascii?Q?wIovDWVQEpIh/KB2pDiMlnV8EzUMp3G1r6ziAVfjUASCtg7DwvcdvUkFSB2w?=
 =?us-ascii?Q?B7ESCteZsH0H8k34Uo7qzkTNE6pT3r2HS3dfdZqd2ZZToSDh2mOeJrNY9J/y?=
 =?us-ascii?Q?fm1pLigIJ6Fn0UYT8HuVEvSyx3s1Pc8aX8GHN2ygGK6opEkLjtiEQlpSQBwZ?=
 =?us-ascii?Q?Jsa/cY1wrxKFqe6w0CwWhmLBseC8fSxIAVu08JofyBij8f49sSrwJ8qFVUcd?=
 =?us-ascii?Q?BM+CzsImZJWdsMJXpgYAjzxcr1jDJvQopO9JzpIcgifz3m9yg5SnbtqqlGXL?=
 =?us-ascii?Q?6YqMt9xPem1hr8BHnm+E/XcJNUn77374jVhhyZE9LrpautFhdAYpoKTCiQR7?=
 =?us-ascii?Q?AgmY8S/bJeMOpX2enJdAxPmrs7+GEjypqayFXXrG9kmpoRB4bXNZ1OOM/5Rh?=
 =?us-ascii?Q?nZMskXrCJcsswl1gpTy1ExiCkyolJd/tM7uQDCG6635OGv+kG8vkK+8rd7aB?=
 =?us-ascii?Q?t2EJ57IypXuqd6X2l74o24oVD57GP/iBznfRLlRCupsDXTmT3SY3k8Ypmo2y?=
 =?us-ascii?Q?S+y7DqkCkGRlMhD4lfMhiwCRRog1RIxOy0z69SAUQFJ+fc04FBmuN7UhKy/S?=
 =?us-ascii?Q?TDkbUxFIsm6d52qdeFClVBj2JEgRA6ebmuE+LGUT45mnyOl1yQdlxZQhGpya?=
 =?us-ascii?Q?4OOiK7nqgFoAfEjVTKtAQgleDoT3S1RFZGyrlYJfKfFsp6HeLud9SFWfIHOR?=
 =?us-ascii?Q?vUzEdQ0GvIWAIDI6RBhbmyeykcn5ilzBI9AySIt3bsY6FRiQRv+kCuttVCpb?=
 =?us-ascii?Q?vHQA5n3/UxhC2WZVKqdnU+zknsle1qyB++rHzA71mnpAKOmQteCFyAC7zEjI?=
 =?us-ascii?Q?cFHrQQDKFejATD0VaJ5q4lRh20+rSi/t4AaGaK5z3FhF88mS/8rGkqkbHQVT?=
 =?us-ascii?Q?DOBoQU0rzCThGeqLAPEtus43RG29+aL5WL90rWCpHbUBdD8uIXsOJDlSxrKV?=
 =?us-ascii?Q?e0zmtSEVeKBh6Q/W26DC5HZgp3GMMbVflrZoBOYspDzNzrjbkNBbI0kTJLu/?=
 =?us-ascii?Q?WpC9wwUHSBx1iKKEhQrPBSHZIxqtEvNQEstxNIxOXQ65DxBxhbzL2SQbtYV4?=
 =?us-ascii?Q?mQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vUFTYByj9WIHL4nH1BKn0Jg8+17oQM8jOY4ZGSHWZxQVFZtz4BQgpR+5Rq6+tekDVovGLboQL/yz1Y43fLf8XPgX82zBNN2F56jME1AFpE5xVytOwl1GYW2h1ye1YgyiOOMr9rh40FoxBeYDoYCkd7W+baOpBwQWR8DHR9mw/aOy6qtdvb3JIlf691lUd/uvIW7wmsq+dnasNyPTFY3AI1nxkuCR4q7EDMxfDxradNd6bCK3KJmPti99TGoXDXm64OCni03y7n2utvZeDD2lj1gjz+kEs+wMh7/Q7YdZ5BtobwDCSoNAuq8oQeedFPCplMPyF6E8/QOWe7ucUYikZs8GYuBo3RK52uZG8PzFqk3U7KlEKfs7n/DS4jXiKakNo1NEYWwoX6MwD1j3T8Nd6JeMWJOlalstu4un14vhWIAv/2E6IV2Ioz0+54pmwLIUo5SM4q03rbZcGD6wclDLTXa8YbF3mgjA15EezpDwtplVptmVlk8Ka23bSRIkmEiCPennnIC75JAz+hnx51IdSiDDcKQv4m2MML4qdwDr7QIs4kStD1knbe3bnfFbZU/JuFfrcsa3IBdLwnZm9JcTLeYqXDaAUNADTtL5qrg53PU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 338ba9f0-3da1-452e-d381-08ddea11c789
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 11:13:44.5521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NhtSWVUiBn3y3sx1NKKOAiQ+Vo21dX1wluHAiLb2J90RFQ9n81/SvcMmtFs9H1hb29ve9FsVWCEgy0XwPTUHGQiVMGUEQDT0bPTiGLBQDhw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8009
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509020111
X-Authority-Analysis: v=2.4 cv=D8xHKuRj c=1 sm=1 tr=0 ts=68b6d16c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=HxM71CRb7kdi6uNY8dYA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Proofpoint-GUID: bLURbQzGfWw9ZU3Zbx_JAGu6MTo8hOCO
X-Proofpoint-ORIG-GUID: bLURbQzGfWw9ZU3Zbx_JAGu6MTo8hOCO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX10zswDwMOvkm
 ndhP7WP0w9GEkMPZPZPeHd4GqG0ZkEUF6O35anr4MI7CydUaLTFRrIoeJ5fg5dCG8G9P70Gyvsp
 1RJTW0aruAi/kdJyZsmD31rCaKSfoWeiP9hU5h+wKphYoLZ3CIh33h5m3AMxXD63w3wXwRiNI+k
 RPljNFAHQ+j7Ihfzy+B40z40Uw0dK1FIkw2gZdE4pxHp/ivmJLEWR7to8/CGf75HZES9i4ml6Oy
 CsnYND691Rp3uEJjIpkfWf1UL7LIzvIceSVficArYlxYrt2ZvZAg3wV59QAnO0s4KGBtkA5SuPv
 OkYyNadnBkLLFL/03/3tgzREl+/TAnFuEBgkMVbySf+GKbBAooXHCKfCajBUIDuFZX6caiPmt7k
 t3nLMMLCHy0kxpfugfA+knAmvJI+dw==
X-Rspamd-Queue-Id: 1E8091C0009
X-Rspam-User: 
X-Stat-Signature: wodat1h1fwqcy5t7i1zupnbz5ytjsuza
X-Rspamd-Server: rspam09
X-HE-Tag: 1756811631-641188
X-HE-Meta: U2FsdGVkX18eowpa2ZL/NRwf/KUtOC91XRbg5Hn+ruR0E7fXNe7towQDv7T2eRZMiqvdPdV4EFlFkULKf/cPhPaxZgkjycFlx/eeKPnLBN0RtYr+M+PYRnv2FG+x6f6D8jHDW4jN7TDeorOKbtRLqSRQW4yvyHygZnfXs9JE85TMyUzTHq0s7wq13DFpTNYtpsANsAo0Ar9k4MDDQNrFYe4NgrKhr+9qRWHglH6TU4UEEiZE9r4j1Qs19VuuSU6BZVoUYX0YtNIm9U4y2Ql66N1FxFH5OPz/LToWthL26zPGSZSVmhFs/83pXW/vWI1TECwKYhtrvCoPk5nv+CJgMjZ4YCgWzoSFVei7yZsAEHBEIxmOWlth1+UbtxKhOtjnFAFmkbbbE5iDn+XaJ90ftfyhQLpYDdsNEOAfm54AW3iE6NioPpzY4tYjoRLjH6lF72teYWpWeqZlYWC1rT4Ng+34xseJ8IKWesVA40rW9Cd8R8vHH08twOVwjfKWpQVVSpZPB7SqrAoMu7nt1cmc6iEDbNeE8tVliUcBDltOfN8aHsdprmOT/uxNbqugT5PPr2ng3z2HJfGPNBfo3BmmBxgMa17wL8aagxGsv8YdaSN8p5lYpDxeK3KezCW+o+NQgDeKlNmNdasOdEGQu7n4Odtfvv9WxxkN08rvi9V+ZpUZEAi1gY6UYSMoBGOrnT6tmXNdoOcPmY5jBTuITUVU41g2fffLR6vjqMXN0HbGJaQ8OEZfIM/LrmHT2EPaPDCRThfntX/z/El2TglR42/W0us2JqLCfifhlhQ+xuDLOEny3rwnLOmMzhssijjJ55H9CvrRNFX0Q0PARWRGyqY5j1KBZ1vZaxBq95RgNDD+LPuIu9IdOoM/XjyQKwi4/6L3itXZ92c6tUMOT2zm1i3/4RVBPahxBQxG85RwfeGu1sjUBIB1MKqiF6A22QTGWTvskGBciBW08Hw056GgRrs
 9mmeuZCe
 IR/TU+ci3dscIv/OZIBOFpeaRheEuVL3XOgtjGnUlAiEEEfaTQOzriz2DNQAs2+h4Ts1Sdk7CqI/9QLwdcDI9ANkaLz01MIxI789/Ao+zLd7rBmYWwF4EKmg/0fE8fm7MGnJviy2tr9buC9u4jSgAbza6/XZXYJt5mutTwhFgsWAHciTv0fsR1GIRvw4Cm5RGw7KVk2wUYj9HEildyQZSpTVEGn1n4nzKEkB6PBuyQJTiR6sUoAfZ3p/FJhb3xhkrKslPqYX/FgoFx+VCSwSnH/B+grTkmWYo7HDkTTHjvimdtbQOQpczLAcKqdM0oFrnXaN4B2VKJR0TOdy2ylKvr1HwuUg5a6nEeWP2TrhHAzFxE6VP8irYuSjuNVTk9XI+c/TIMiGOTclTSuAkgpXKa67JJjIHVk5y6gkDlTBab3RII4bDRjcHdbb0XkdTfC8518L33NVZx277ZbT8lPJ3GCi9/KCtaUjWjsBQ2MCv1Tgh3/L8f+8tJxLeNuucafmojzM+JAs2AYlDLVtg5X8hY1/omePHQYPOAYgsWGnwBUCR1tBXj5D8GE3kJpFo05RKmI2A4Gnnl7NEvg7N2BhM5FnSOuBzJJPSSNRvxWcsbP9AtXJ8jPtIGgEm9E8uGFVzgMc/7UWiwCt7GLOCrdzXutrvmvDusfDMibJmD6bXnCYjQYiQ1jl/DunPnFWFc8efKErthddpwIR5n25bMMabm4Tn+iDTAeyrSHbDagCwy9zWzUmWJYZaABJveg+/jE93Kb5gXTHIABiTTtuYpdGjHbAhf/gxSz7NsVeF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 10:26:40AM +0200, Vlastimil Babka wrote:
> Create the vm_area_struct cache with percpu sheaves of size 32 to
> improve its performance.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/vma_init.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/vma_init.c b/mm/vma_init.c
> index 8e53c7943561e7324e7992946b4065dec1149b82..52c6b55fac4519e0da39ca75ad018e14449d1d95 100644
> --- a/mm/vma_init.c
> +++ b/mm/vma_init.c
> @@ -16,6 +16,7 @@ void __init vma_state_init(void)
>  	struct kmem_cache_args args = {
>  		.use_freeptr_offset = true,
>  		.freeptr_offset = offsetof(struct vm_area_struct, vm_freeptr),
> +		.sheaf_capacity = 32,

This breaks the VMA tests.

Please also update tools/testing/vma/vma_internal.h to add this field
(probably actually at the commit that adds the field in mainline :P)

I do wish we could have these tests be run by a bot :/ seems today I am
that bot :)

>  	};
>
>  	vm_area_cachep = kmem_cache_create("vm_area_struct",
>
> --
> 2.51.0
>
>
>

