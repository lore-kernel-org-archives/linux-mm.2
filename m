Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40021CA0ECB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 14:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D280E8E0068; Mon, 11 Aug 2025 10:59:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFFE68E0060; Mon, 11 Aug 2025 10:59:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC78F8E0068; Mon, 11 Aug 2025 10:59:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A45928E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:59:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 619CDC0130
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:59:57 +0000 (UTC)
X-FDA: 83764786434.17.040AF19
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0D969100008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:59:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="J7Yt4Vg/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YhjZxbvj;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754924394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=laIHsk5siNLrZdxdbZJa3zV5c9DYwnjM31rbtKAhiaM=;
	b=wmEcVLIqMhxnECa4qNy1NJjVw3+Olxp0aAa5lo2TMrr8EFlS9harL8n2K5ifD2Pt+/CbLH
	5Ai4jOZ0G9AkPxce/9biBCmkTQr65vO+m++c/LKD9oEKv1JvNCjaDBOdloYRxkEw1exrGN
	2/YxDsNJAuNK0l7FW6sgz2/qlxC8w78=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754924394; a=rsa-sha256;
	cv=pass;
	b=K7MxQEmRM+guQILRDqXKci7bcndkpdVAEAMtWc/2iRSVMA5g3bv5R9kTfPK+kURjIzHBka
	I7MBEsrNsMNds4NyRrO3lcY+y0IYS9ShavLo0aI/kgWbtvHC+D2xxZP2Qm/ZVGzTsiO02w
	8UGrVonTNX3zR+yvWZzvEd3LpIWh/zY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="J7Yt4Vg/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YhjZxbvj;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BEuFXc013098;
	Mon, 11 Aug 2025 14:59:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=laIHsk5siNLrZdxd
	bZJa3zV5c9DYwnjM31rbtKAhiaM=; b=J7Yt4Vg/X1fvNfYp794YuAUauk2s2tDA
	KeAtphhC5HvyHahSOBCz/+S37SpqEsKTkoIkhkwhJcA1rJijb2ZWjOC3i7Jr5MW4
	AJlbKo5SpPtsuZeD8DDZmCXiEN+RJ0zVAvLjzDm71KfhgJjhFrddd/zSMoToKYzA
	pHL8f9GI5j2dNh2sTkxQdNIj6MOgKxMzvY1Rn0e71XsVU22atVUUnsQRZ1Uya1AR
	lPjhwAz/8V/0J04LxraESUFPdrPKHYH8fuXmo74cvyT3PX6v9x0WAPk2Qg1S6CkI
	8K8h/cV8j+lLUv/4Be8nesqPZbwpBfETfHZbyAUKTxswoxRJLQarTg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dwxv2s1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 14:59:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57BDvk7q006371;
	Mon, 11 Aug 2025 14:59:48 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs8h5wt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 14:59:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ao533DuV/zGXwH2WMm4IvMYPB0bv4ziBeCNg56vL1hcL8C/6Re7mNeqsbrT/5QlBu6BxPC6huhYKFbPsC1XQplro7bcPHjx3PVkaM7J02hQLe11RUA7jua5pBG0KMBBEsvFGBT+uOkPQPL/Kil42VM0kkOiqz53rZxSadb0294nLpObZzDXZCLRBgfKe/jTLKVz90TWZvWfuz9t/hkwxApVQgtmXMxL37ZmPxgMe2oigvLzGI3Lo/TwzcW5gP98P6cQmvhD3XBO+kdYE+Mmt4K7E9TkhD0ijT5VQNr8/Ro845c/wLMc1yuOF5ha53fFM1qxUGI961ykedpn3cEB9gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=laIHsk5siNLrZdxdbZJa3zV5c9DYwnjM31rbtKAhiaM=;
 b=patvWDplkayEjAfCRfj+XrVO8X93rJf/vWLdSDTPXdSAK0Xz85wel8FeOBn3imRurMXFpVq36ySdXNzXugV2y4CrAaNcxMbVrpzFCu9v2gT0rXyihNcRWp69FMHOXuKVBHR2L0B6mFuh+Z3ytbDF4XB9ngiXu4hhv+KpgzRNeA/vZcAptrHHEyE5bg9F6owIk2SrmUIc1NjFDVebvPyqGyS/SG5Ebg+XLixINwrHIF0koOBCZHmstinwmV0wnK2l6g20s64MM37567vNlph44gb4Ro8GIMKtj+hVC7I/7IiZobD+43yhLvqeV1D1GJlH+fJSPLEoaXOduGq5HtzbWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=laIHsk5siNLrZdxdbZJa3zV5c9DYwnjM31rbtKAhiaM=;
 b=YhjZxbvjCZVjNPY5bKZQH1YbcyfT6qUavcR2nxI5Gfh2jDoS7KYczKQNWBallS0zXqGDxEnntSm96fBAOe6W5T4RPqHdX+/R7J1ntTDjVHUvCvNL3lkwBCOSawbcvcLYnO+URomAD+LYpe5VdHHoSrBrMhsJVT8X6LbxGGtUF6I=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7553.namprd10.prod.outlook.com (2603:10b6:806:376::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 14:59:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 14:59:44 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH v5 0/3] man/man2/mremap.2: describe multiple mapping move, shrink
Date: Mon, 11 Aug 2025 15:59:36 +0100
Message-ID: <cover.1754924278.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MM0P280CA0071.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::25) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7553:EE_
X-MS-Office365-Filtering-Correlation-Id: 6184459e-4d43-4ae8-b337-08ddd8e7b4d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iYtJOoZnwUEersXFta9dYzmMgWgGnSD1V26zFgLzPrvAa4sksZu9dahwXEhA?=
 =?us-ascii?Q?d+DZEnNVm0aCQSbrUmfunehtdxyRNUkJWvSgqxmwqL7BKmqw9uAyrOi2Hbf7?=
 =?us-ascii?Q?56fwHJy5vUc6AodOmIT3U9rZxupinuZGytOhc/e7BUmA+wVnQiE0HK0qrtZl?=
 =?us-ascii?Q?uRW87vVEkExCOQ2y21qRCa52fDl2miduJda9hDm6AiAqwRSJvhuSWgPuQdA4?=
 =?us-ascii?Q?h1ZMi6WtosmBNDpgNs0O465i22JCmg0hfWfT50JFrscpWagtn4XcmQh9FOy/?=
 =?us-ascii?Q?ZMpfSP9LDnoTRB3DCAKg43e+GKPGrSmnYztpsbmbhdciqW4+ozJ3fDFCod//?=
 =?us-ascii?Q?+R6nBJ1dZGTFCw7fNF3MSNtg5FfHYmvfPBTqdTknHBP4/30NMwJGNFUgAoRc?=
 =?us-ascii?Q?cNejQlibqFJrfFKwqhQcbhYcRKEGrV7NvZmePEDW4hwEv3xacKI543e1vMdC?=
 =?us-ascii?Q?atLQer0pDwX0QZS7Blcl3TPtWqKy0iQSPp7Df7S9yqhD1QjKuEIM6IWjhtQK?=
 =?us-ascii?Q?T98gDgw0m8kpT9sC4pdslWECmWPXU5eNFkmxM6UDMUOOc1G2r43Kv0a7XZN6?=
 =?us-ascii?Q?BdMukfutJFk7ZKkCbn/kfatoiHDfxYp8i6V6YazQCqDgeu+iptI12ZqI51Dq?=
 =?us-ascii?Q?hjskQIyKnbd2NDYzb7ezMyXYHG25V9YmzKSGirorND9vrL6tZ4IF+xBFi9ji?=
 =?us-ascii?Q?CNyVuerpAo88GyKFzuteM9Q+rXqIIEv+C208ehvNXsp+0Lt5ChhAho2euIhI?=
 =?us-ascii?Q?s83qfAXnZhzRzipgSSDAgUFzdsrAabjjbZZGA70bqPy5teo4dmITYqVrydHd?=
 =?us-ascii?Q?6jdOOyCtC3Sd5i7Sh9jqZQy3qnPqmc2CzOu7c3MmSVrD0G7yy3g8AwwJPG8g?=
 =?us-ascii?Q?cTO3sOCvLL43IF53oNCrFyoPUBEOL68lOphD5X/g2b8+/KcQRpzFhfX8+F0d?=
 =?us-ascii?Q?a9bH5IpjAOLm/GiHI2UELB3DGfkdoJSBVoMvs9NcwGtew0BGi2eWN4XIdT7R?=
 =?us-ascii?Q?Dg1ZI/mDkoqgM4wpl+vV8aE4MnYMbbBcCrJq1N4unCo4DpSPu8XbkgRkWGkF?=
 =?us-ascii?Q?1psY5K8Vh5bf+QD920xyiAuf7aJB1n4+0w3zN00mmzWuXb9koqySe4nc3O/7?=
 =?us-ascii?Q?IFWmbZCaIAxWy8Qu9kGnk250PnMbDXC5MMH+H/qn4dZAo+AR9LV6/DFLy9Nj?=
 =?us-ascii?Q?wminY5Q4zo349zIOQUHG0Vi+cQOYrGuqRgjOPcylMyezUeLhkH1BQiQvzT2h?=
 =?us-ascii?Q?TFnnHgymUvs0kC2bZG9p4gYljYPNEn3Os04WTDw7rA5eYcDaRE7EAdq9CBvB?=
 =?us-ascii?Q?yep+yN0IazsrHJlDuYpgdrV+CMfJ/UEGzZ12gGVdM9Vadc/PV03M1CwI/gIx?=
 =?us-ascii?Q?Y3QWN1AFzoebfKE7wzBOdu7UisVyW2golSh2xgmnxwW2bn0+fX9xt8Qn0kXz?=
 =?us-ascii?Q?ZaiXBMnltlo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T4vGmLCGhm+BQbX/auAFAit0lg8h2W4CDakb1WnU8e+aoJRp9vS+/GcjjF02?=
 =?us-ascii?Q?krfqRnPD8nCmw/RdPMolyO3PYhdOn0bS6FEAQpZqlh8H3hD+jPtepXLzok99?=
 =?us-ascii?Q?hAZlEvbjjU65Lh5tSljGM9NEfCm/GMwEjNqUASGlAQOJ9ZTkpEV25tcoHNJc?=
 =?us-ascii?Q?6Uhm6m2X0FL700Vi4E2F7RmjZop239XtAVT1KbRSH+k8XjaTomQgA3Rm2SHA?=
 =?us-ascii?Q?aNyDWbGPnT+P4r/bTSv5WV9hdoXWQs2Z2/m2kLl9N5Znh7rv1UGzMiBFI/EL?=
 =?us-ascii?Q?rXn5uksB2UjJMkWLuGpyS4WhEfIpUpqHRs4DPTq74mERrVSluodsf3BzkAMx?=
 =?us-ascii?Q?vIH/Gh5tB86vNQS7May0THfdtRk1++sH0iZASmc28mQnbJbe7BGJ4sFuIekl?=
 =?us-ascii?Q?Xl56j9MEC6xHN1icZy4KKjnsIBT95K2FJfmzZzMArkRs55ScqkaT6M2vo7P6?=
 =?us-ascii?Q?tYBerBM511InmLtVuUOLcVgw6aB7PpxE5dY0nSv0Sl9hGs+eGRhUR8qBCzZ9?=
 =?us-ascii?Q?q7tLpPRhAcep8HAd5dYu8ZLiNGOE3N8LfUgeJsijsrBN9LnIX3vPR5kZtM06?=
 =?us-ascii?Q?kPWcBifptryDox6qGYKCOJwdWRD+PB2w15pEy598Hs1OzDS3WlioFC/uIpDN?=
 =?us-ascii?Q?B4WGXaBpspjsEn+/ZRy/TFWDHbiKawT5GG97HeGCE7R4Aiqe8Ke8PKuCrIGR?=
 =?us-ascii?Q?Lakv85pgZKU2Q/OjByf0iRi1f5OtADxN/f29GYRYwkegGJ6EXh9yUEaPoE94?=
 =?us-ascii?Q?h+xOWlc+a8CanE93v3OQX3bnXFA8YbYQhW3gMhmajWj5/Qo5t5fER0/QftnX?=
 =?us-ascii?Q?+ng7iWvIV2xzALELvEvVR4jOzLdLS/2y6Y1q75dYC9C5Y7lFSTEjXeMSctCN?=
 =?us-ascii?Q?Di/g5EBHOrdMgGthEVhTqGT2HDVr54eOa+4PMikwZjv3Wkd87UAHyNBBwaql?=
 =?us-ascii?Q?jnZp1p9JrUGzGSphztiUgxAkNlnC4iGBoeFfwIDJQLr7ipNaCHVfl6cu52bo?=
 =?us-ascii?Q?HNG8wgynf3tyNvtrxTDcy4KIArJLvf+IS+Q1MPQ8jUHhfBGLUFvIPoktnAm7?=
 =?us-ascii?Q?woEK5FDOuaqbaSVilLkpjuYCNBMd5JdtbIHN/oIdjqMYHqCyL6GdnhymC8Uu?=
 =?us-ascii?Q?Ntt7smE8k41Awwg8Ft04nwG6ScOVuH7JJLWqPrI8BZTPBt0jjS1x8vQ7iqB2?=
 =?us-ascii?Q?niW1hguniTnP7vCCC2t+VbMMC5Y8P2T24dOr/GO9jXIuC49okxEg/7yWt1mE?=
 =?us-ascii?Q?D5+XBcR50Z3iL+CE9kX7OVzxUv3+JwNImdm1zJVrcI+HaC9xgFtVKm/yc6LT?=
 =?us-ascii?Q?35inxmQ1l0Wj5AJgL64AR9kJvDsYfYyqM7Rfu6I0WT4RpaplL8hnSWQpemlL?=
 =?us-ascii?Q?dIQpJ3IFdZIcMamYH1z7lrSBZtkh5SXHWrmrTPKz3JzvQoAxAQPYhQn4uJLI?=
 =?us-ascii?Q?Bv9UIljKNGGoRdf/4js0RWkzlJrd3MurwchDszPzN1CHgjAeRAL0jvAW3rjO?=
 =?us-ascii?Q?DFeNW1o+hA5P730fDNc2PhJG1zDUht9/lr1uc85H0X28x5YSiSjp8ujOFxbR?=
 =?us-ascii?Q?F8P42+dyrCxUPBmA8vdrMktV8oLBJ82QZ0PvJMA37jIEHw/e79KVSo6TTzD8?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+2uI0TEtgCJiDlABpcBV7dDLx9AHGC+aQO/mch8/mI5gP3a5hzso6qwDPbi30TgNuq7VLjcIx5LRx1TgTZ29bZg3fqgfQZv0CUcsuHhMtI6Skgs8NKAcytDic9NqbDEMqull/7h5dFWzWEGR9n5I4BcsDnIjhaydzpYaMYIZnCj75tPCr47M25GO9qEdus4mOpCa2o0rv3vdSY4CvIKWOnX2cNTFJEq7Lc0IFluqBdUofwNHImIoFCtK6jj3rF+aW/4/Z8A9ti1LropKyfgHllVeDcUNOGjVJvInzecXFoVDkzrn6AILjd6ieEko/s60JfOD+2zqh0QQpvVCmdtz4CeGTmt3F3nQzkjcc4C+LPVuMa+9F2C194rFmj2fV6HoCdw/DJd+b51Dt8Eob7JJqewbSO9blbt7pQ5fn+RfgtSRCWPL4/LuzryKlY260iajOPrDRdXk6S40BPtUDbVdjDEkdhQdIR1ncgvDBiCvfY+PVcuKBqU995oUyp60baxAj0XxilYG53WHbWYUj9bsxfsYO0sS66vCaeF1lOiKxVqZ+9QVC25XkIlb7UOD0OfifylZ1fdVw0R6wou4e5CjCEUbv/M+/Wp6x7V1TLLPFvM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6184459e-4d43-4ae8-b337-08ddd8e7b4d4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 14:59:44.0046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Vd7LDU2VxvaYdBMkWC+dOfvr0AjGUsA28LTvyouTHR8/LsFg+mWspttVaoyFuP0fkDQUzUbkhdRGmy9cwLJBiRDKuqd//Hnx3djzdMpcz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_03,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508110096
X-Proofpoint-GUID: CxuR0wpbtJblqeLvLhkwdhSr_ryzQEAb
X-Proofpoint-ORIG-GUID: CxuR0wpbtJblqeLvLhkwdhSr_ryzQEAb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA5NSBTYWx0ZWRfX8A0PE86R+70n
 terSMypAMmEvCnNBPRJAhxF1Y8QRPiXcIA51yQbT7Cb9ECOZpfrxn7/zkCTQMZaYgqjVGg3FcVu
 Y1LYQ0eGJRVn76ndYTPtMIHXHMDDGuQt5lXSWxZw/bj7UfRU2+NbRL7FMo7qKVTE4IUviDz3aVB
 UbS3bFn+U7CkA58+DPE770PtYaV/FbVRJnviKLZCcTp68smYW6Y5QndNrMOVGM/gDJg83yW2kMS
 ryunR8z4QXAyFZo2RKeK0cA3CboJDTy5mzl9ngTG4MLzhLATj8D7yT4hN8qphC6ILqTZWvHqc2Z
 9E4FlweFLCtEWuieN/cx8+Ab9W7witAQPvkudImpQs6kBNGevi/xuU/fDlZOuUqJA1ebyQ5ELJW
 u0x7Ija15o3nGyjhNjK1LZiiYQZgBeV3E2H03ZWsMAu2QSvP2mTKId383yUsCzhZGmjGMkgj
X-Authority-Analysis: v=2.4 cv=KJZaDEFo c=1 sm=1 tr=0 ts=689a0565 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=hwMHu3XryyH0qopCduQA:9
 cc=ntf awl=host:13600
X-Rspamd-Queue-Id: 0D969100008
X-Stat-Signature: 5yuyad99wxig3ejmhuc74kn5w6y93t91
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754924393-405513
X-HE-Meta: U2FsdGVkX19t8qZi14yCu1+PRJwhn3JwlOItRRjZoB2aCHcmR7NlH9TriTus/DtfS5v0GNkm7Xk9Iz0qXOAE8OcJf8qdD83MLkslEqrxO87Aq5+Msd1MmoKqIwB33afCawz0Fafzwdjz8gTNUWrxIshYTkAxmJi3t2rNufMuJP8Id7MR5Y/qLQR0pA2XgIC44ub3styzcPouWVW9wp+48Fi8Bwidx5Fj2XYmRmASVvr36CI8ioItEr5HSGZQpRLJRVLIGwoUJ98BhL+x5MwOVQ7eR0ggaGKtkdBsGexiu+CSpF0qeKHHNmkJodz8SpOWCNFxIjiC8hRRUFRRBNrLDUkUp4LNjHazgykxymOeHvxXjqDnCI9mF2LuUeSpjJGQG58Sd0nGda1yp7o0LrXzUGed1136VBd5KX+KH0i6DSpcvsmA/8NrhDKxZcByAnwVvQvieKbzWp2Ns7MK3l9I2nsYyCNX2l9NA508GIjBm+z0JOa7rcfpFILkHpcGjy7XHTLc4fsYyK/ThTGYA79GHW8FSmCyKa0+1Py6yLLf45p385D7zR3lWDaJOaOnc117FWn8+jN2k+lJf07TioxP/u6lfAjyzmLqNcIGYGPaKuZqOdpI41RXKmd2fhbbQXPkkZHZKPXODlYmr4z6/aIP6i7I+5Jm3yTlnKhE8tWD2QRH6x6Brkh/OXX/RosTpLIRWfS5p9ebNjFnv5ZTN5V8hflvSuRtcKK/jLvb2oGl6qZ75YEcsWc8XusyXRBaUwrOL6hWqLHXkpNuVCdiandYumyv3A4BZHrxiX5OzkO2tZxXzkG7zi8j6oI2aYCEeiraFza6iOoX2YHRs2NTJCN5KibHdL5fVH71S79lAvjM2tcepSyTD8P2/QNsjp2q7/myklXjgfEecA7DO8ubT+TtD/bLkJBZk85bNtrmmqi1p8V4LRVJ6m3QgaQtGyHdn0MndRK8KbPaiF3vxrtYd48
 YHX0sN7+
 KVjuI7pgDH51JUQPx+bbgNauOgldAnkg2J4Q+xCS/k1ztmpPJDwN0LkStkVnCpw1LqHvkx9bGNk67iC6IuZlsw1i4Wf4tIhx/qrjy0TB08kaOM94XE00FQ4y1lgkjUsr+nB8nxVmop3kgEN+IH0IWVswFU6cVISD6o8jgwDRbr8YmGnkuBbGTW155WtH73yB0mNXmUCPIFDWDO/dyeWbPjfT0tLcJ8jwlrGdb03LLG0p7n7ckJ76plk4v0Eha5gxCztB38op+t6v0b6px4hnyOfg9rIQhwqRkDPuCvD3qKc0T+Kr3hjbOAkOLe5ZYx3I2P+8+y7eF9/blHr2DkATfrLN6+sMOHF7F8bJYn9j8lpjPtif7Yk9SEEd5jdFPxqquPOxRcnRrqSCqn8cssJTg6nnJxn8QHdV71iT8LTmqRwTwzs4+3rt46xhCN6hC3mlBD0+LlHYluaAr3NDo3YhVhj84JQ7XX+7Sdo7FafLuN6XlAoNNw7GKvb4uwQQzfGhKofBkT6ucQ9V4yJrFZg3g/nFrLDewcvj6W1ZZyHdSEED7daw0kWj2Ie0FHIoogg0CN/zsRcAi6MGcqEw6TLX9/f4wREGHMnzloYSeO4HQOU+e6qV9/qokHZQPwUredxu82fmRPmkGoy59RDVkz5Tlp8GYw/8onEhXV7DDeaOe0eOp1lW3zqsmkmQHzjv4xMQio1EAyblgB3nan5nT/BVXeHzCTkdML40t+5rvfRaXZYh54XbFCiFf1LPuVlBm2cKV/r1Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have added new functionality to mremap() in Linux 6.17, permitting the
move of multiple VMAs when performing a move alone (that is - providing
MREMAP_MAYMOVE | MREMAP_FIXED flags and specifying old_size == new_size).

We document this new feature.

Additionally, we document previously undocumented behaviour around
shrinking of input VMA ranges which permits the input range to span
multiple VMAs.

v5:
* Reword point about 'old_address' needing to be in a mapped range more clearly
  as per Alejandro.
* Update wording accordingly around this, e.g. referencing unmapped areas
  between mappings to be consistent.
* Minor wording fixup stating that the MREMAP_DONTUNMAP flag may _also_ be
  specified.
* Separated out adding a section on 'pure' moves and describing the new
  behaviour, as per Alejandro.
* Update the commit message of 2/3 to reflect the above.
* Removed erroneously introduced blank line in 2/3 as per Alejandro.

v4:
* Update description of newly discovered mremap() behaviour to highlight the
  fact that, if in-place, [old_address, old_address + new_length) may span
  multiple VMAs also.
* Fix up commit message for 2/2 to correct typo on specified range.
* Added code sample to 1/2 as per Alejandro.
https://lore.kernel.org/all/cover.1754414738.git.lorenzo.stoakes@oracle.com/

v3:
* Use more precise language around mremap() move description as per Jann.
* Fix some typos in commit messages.
https://lore.kernel.org/all/cover.1753795807.git.lorenzo.stoakes@oracle.com/

v2:
* Split out the two man page changes as requested by Alejandro.
https://lore.kernel.org/all/cover.1753711160.git.lorenzo.stoakes@oracle.com/

v1:
https://lore.kernel.org/all/20250723174634.75054-1-lorenzo.stoakes@oracle.com/

Lorenzo Stoakes (3):
  man/man2/mremap.2: explicitly document the simple move operation
  man/man2/mremap.2: describe multiple mapping move
  man/man2/mremap.2: describe previously undocumented shrink behaviour

 man/man2/mremap.2 | 109 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 98 insertions(+), 11 deletions(-)

--
2.50.1

