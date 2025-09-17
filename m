Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A881CAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C56F68E0054; Wed, 17 Sep 2025 12:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29E18E0002; Wed, 17 Sep 2025 12:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1478E0054; Wed, 17 Sep 2025 12:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 98DC28E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:18:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5720759E1A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:18:43 +0000 (UTC)
X-FDA: 83899250526.28.EC882F0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id E2B984000B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:18:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q8nK9drQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Fj0VpwzU;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758125920; a=rsa-sha256;
	cv=pass;
	b=Gl/wIAuVqaWG32eEDgDT5oE58Jn9Tx0Pj5HVtKfdy4GZJ2voBoKb/jswAS2Y5R4WCkKy6Z
	GElDSFYMpwNKBO/mAiYMrjcK/3TH8OIJsxtBRKXSWLd9IkXHEv/c6Wt/I9MgdMt0WPef2E
	tFL8PFt7y5A1PrGQLpgySJg2qvfF8Vw=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q8nK9drQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Fj0VpwzU;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758125920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlwzUlWMMRSMYfV2UGTcVTHX+hPWOFLb6bYmEU1LORA=;
	b=M2PVn4WgRL8i0VoZCEn/4egNJVBNAwhvcjdXRhI4j11+oP1zS0Df/cSxOgot3FuWcLed+1
	72OQtfXPHV+181l285XMZZS0sfvFymzAL01XbodQYRYV5zNQjxCj/eXW3HhTiu0R1ZTIA7
	rLYDomSSox4YZtSJz2lHcG4QHFYiGt8=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEIUaS010081;
	Wed, 17 Sep 2025 15:24:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JlwzUlWMMRSMYfV2UGTcVTHX+hPWOFLb6bYmEU1LORA=; b=
	q8nK9drQSnHgjrJNgtvbtt71ZXX90NoI3wJczEzEeBaagbhP30fi/bKU5XYcnp8S
	zB+Api9s5Axii5RZJwwMe2NN4FB/3UCfWYHU5sF/MF592rZE0btrNBxtQRl1QPIW
	V8AwtUqPhDFoyoC0qNMTjAs1anWaMJ4Ybc5Y1KvCdkjGmWwNhsHVV2iG2ct1AZtU
	MHtz1OAC5k/wWNwPchLKwMacdvDMVu8aJQnJTwrWnyT5mvELoZ8YrYwzj7485VNE
	vG99IAM+vcMTl/5uo6k16T64PgAsMlji8oyW4RaB2FiTgWl2IwPgO6KKiX38sY1a
	ftrmB/zHJpFlA7v3Mh3Uxw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx6hhd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:24:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEm8dK036930;
	Wed, 17 Sep 2025 15:24:50 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011054.outbound.protection.outlook.com [40.107.208.54])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dxufg-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:24:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HROmiQSqlN1NK1qgR5CRc2Ndde+ZQOwUQoNIC5s3gcSJq47vv0On6eV9X/Cl+doFc24Bq/kvSYa/Cn/EE3y9wiQcw90fyY4WFzjJVMmie96w9V+XMTYPGh5QwrDeA4u0l9D+i/KpndgRhg/xlL631422zcH4u4NuuRLi0l1D4PODoW3kSnTyl7hV9lyuXG2Kn9+75GnfM/V/csNuElBR2nSkUcRNZOEgVLiS4dSNpVWNVCqxnrtHaY/X5xVMve/4+lc+9+fOhan/xWHjZ5Swbshs8JzfF185AxYf6etyW+LGW/mNUCZ7F5VoDt7ogRUWnH/3WKfRk6wpO2TN1p+pvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JlwzUlWMMRSMYfV2UGTcVTHX+hPWOFLb6bYmEU1LORA=;
 b=nms+oA5aupPQ8JqB5+2y2CQvnFsiS8C/8m/x/MhTe580aAThZw5COIK8vOVRFVXs/VezIBopJQJZnWLFD1gHIW+QdQ8LOFNthVau2dYwluzUsRPSF9c4yVOKF5TUoaiNmV9lZKi96fjFrRTE1NVKZMsyvZaVld5/7cckN+DaEN+2aiE8moYBwi4bdYh+NKkrlYZceviLoOlr1gP2pmhDNQ9xSF0Q1bLI/kTSBPD7+JMVj9mL5KZ8D67BMsT/NqPx0+2fZcnoboCY94y6EHv6eiMRSkDX4Eih7MSdnmi5cVRDldPkei65448g8G7ZlmYNWuhj9JQW/Y4OMIr/3l/9xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JlwzUlWMMRSMYfV2UGTcVTHX+hPWOFLb6bYmEU1LORA=;
 b=Fj0VpwzUlX3x37etYsD0+kg5mAmSUVK+Mminyhs7MFBb4YYtrtkZsVF7Gn6h3lU5pqbAng6/2ECvN9qU2PIGE+t1EaWwm16ouOkOfAGqQrB4E0jNmRYUuoeEHL2aHptJtzSn7Y5TO17ly25Hq8Htbs3NXfEnvswQjVk1yu3r6Sc=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ5PPFD020A49E6.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Wed, 17 Sep
 2025 15:24:47 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9115.020; Wed, 17 Sep 2025
 15:24:47 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v7 14/16] x86/mm: Simplify clear_page_*
Date: Wed, 17 Sep 2025 08:24:16 -0700
Message-Id: <20250917152418.4077386-15-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0058.namprd16.prod.outlook.com
 (2603:10b6:907:1::35) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ5PPFD020A49E6:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cc8e81f-68fd-4802-8f84-08ddf5fe5615
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sGQRPMo9jTxjneszUG/lRAkbrufuNIT3IprBIYH80B+0uMl7gEFjWi9iOXMc?=
 =?us-ascii?Q?WMClETz9+LKaTaXQi4stOU1Rien5vh5TA85jh4eSbtQWQ8ladEsL6J2hFfg6?=
 =?us-ascii?Q?L7KzB6k6DrPF7mYdQoxlDBaNTXsgxjL7uYTx8g6sFxhOIaRwontclnCyXqlG?=
 =?us-ascii?Q?jLcSZieTghQDXb3kwSA1t33PSA+kHwIL3L+zb8Xzdt/J3JfqiE6gYw0xKUb3?=
 =?us-ascii?Q?4Loqqk7kn6gBde02hTXdqwBD3WB6uBpNduJ5YnYYIlO1cnAgBK5+q8cTrUIA?=
 =?us-ascii?Q?OrOOLwGYSRFbdFbqwqiYUW1HbDan1myhhbj3bsP1as9Fg7q66FEhtnhPD1Gk?=
 =?us-ascii?Q?6g7oukbW3oyLDF64ov7U8o220oOGV/6oefIOQMiIYs4ORUidlGMt0lc0fu8L?=
 =?us-ascii?Q?zZKifiPi96VVXWnshyiZJa3M/pa180dg9JQaB+y2lKHnR1DAq7Yfu6w8Jx1e?=
 =?us-ascii?Q?iWoa0okrOc7AUJ9cPQU7DlsvuLkdd5z76RQgNRs7s5LVNk/lP/D4siXHBkt3?=
 =?us-ascii?Q?rxGVVHH3ArLZRfb3eDrgsEY9XC979hH8x7L2mVBHpVVJ5wW+ye0cQt/qjXn9?=
 =?us-ascii?Q?1U+9zUBwzAfWBc0C9eJG8e+oeJ7FDQT6CIZ9zJXq5RFD720Q9UEorLDefd9K?=
 =?us-ascii?Q?Y7/GSaY1XKobdv7DOnBmBbXlG/N8EDHbyKLfFWoFRoC3/2oQTmJ3jepCO8LJ?=
 =?us-ascii?Q?GIr2S1J2lnoV9E76kO7qeq0Gc9M9ql48B1MleW1ApOLPnwNUvMpY0oh8+QfI?=
 =?us-ascii?Q?2/BG5kXGMCNF1Ym3691adqsx4GuI8mgalLil+KIQ8gnPQbvMDX0MdaXi0e8A?=
 =?us-ascii?Q?I9n2lcD0UZ3v+OvUvFV2T9pvDeQpKH9hg0N4kS/M9z60goHvNsdwA4oGLAVr?=
 =?us-ascii?Q?PzVPl+KaWL7LyI0z+S2wiYi4ge1j/pQTom5uOkMVz7XxF7awZWKYI3a+8MSo?=
 =?us-ascii?Q?gZTnGciwGI+U1f2a0yI1bJlOvQzku9MLTtI2Th3bI13lSx4X0xdrHXnH5E/o?=
 =?us-ascii?Q?FOhNfyqp1Z+BYHehCNcYY7iXhgl/RytoQPY3tPkKoc9fSMPiv0ST5qSyxemt?=
 =?us-ascii?Q?ZjiESyLgE72XbDdT0PfM5TIxO5xyVJbaqdQdPSksjzuQnTUuZoWZ4Vb2y16G?=
 =?us-ascii?Q?RR4KDKOi0sZ9ls90Qa4QwUhNVux37G1fA8l3lRIjIgkSAFCeEPC9sngBrik4?=
 =?us-ascii?Q?lHD1RN8BZN1BLRTQA5a9DMcqNjgmXFe4+DTRZtB1kYdXjh4FbahhaCLFh3fT?=
 =?us-ascii?Q?5O7dRXai504hmEDvDr7V0VCDge1BVJVvMkyW0MHgSF6qV/fAv56awHTMJTL7?=
 =?us-ascii?Q?PfO4s8oMj7o0TVDuhPp6ufRB19uMlGpM0YAOvxCQYZ4NDIiajY/F0aOuTYG1?=
 =?us-ascii?Q?3aodivdmi+Rg2LJfGj/CUVMtxAqlST4/6EnPkTQcfKh27SOfXg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mRa6X1wvK2C+tlb/mw7XFW3KHsAcJ1MukzpN/mE+aNQtwFYFv3p16AF8fBIC?=
 =?us-ascii?Q?Hkc7F3/pdXbIjOuHfISrL8oQlQD6vMy/2AK4tIgPIt6euXRk0hGvm7gYyL51?=
 =?us-ascii?Q?O2ErXWuyAc+ZQKGtOqbhW4pFYP4k1pJfPfjHbYezy6jEYH603ajPKwM3j7nk?=
 =?us-ascii?Q?wKNfYwBST3I2dgWPrShcWxw0/0EPOZYjkLSC+CyLezL0o6s7m5o5wuz4FHvs?=
 =?us-ascii?Q?4wg6ZBi4vlXVRCX+jkmz1dII6d3z0JWilQyBFtQ6fS8ArxnAsAn0YvRUJc44?=
 =?us-ascii?Q?jeLmI+/E7erRoCBB/Ly3ps1rm07kEg+e8qspMFiiXKQBrzW+ZXcOcNEoyD4d?=
 =?us-ascii?Q?Up2LzAJpos57H7CijV1xj7V7jHFOgYlTi+xnI5/RfU+buLUTeCX4Am9y4l3X?=
 =?us-ascii?Q?/4sEvERMs1AcTl5YzndIQXc+4CIar2GdySGyBTnk1U3DBudjDnBEUaLbm5iG?=
 =?us-ascii?Q?Tq0KTm5hzkn2foQI86d9Hpm7j+XVqtFp1irrZ/lM0WVMPAp4UOHxj09pL6OG?=
 =?us-ascii?Q?h0CQ3AgkvyWEfzdjnXIlnoyW8YN3Vz6RMpPYvkFUzDCgJmXutNdpzqjkYd/w?=
 =?us-ascii?Q?QREhN2nqHKN+RUP42oBSaucMDeN8EhtuWi0T3EDRJ+KbDTB3jh1oxox/tuoR?=
 =?us-ascii?Q?C3TllUrULC1MdqmZcPL7bLI2QM+HYj0F52aY4wIJbUy8AJfU7ai+rbGmkzGf?=
 =?us-ascii?Q?CtMfKXIi2YDOOopcX550fcrL76qWDppgffggQAqk+fps0FUszVTI8bGQbTVK?=
 =?us-ascii?Q?1JvsC1UAII4+oNMcmKeFghMTF1Hs5UsrnH6W2sxx+bInrpFs1FNQ2vfUxtIm?=
 =?us-ascii?Q?lUF3GQzPK/geX5hPu2jy6LghRxHIfmq0vv7GZdXYFxMUgDNPQqEwbfCr6DzE?=
 =?us-ascii?Q?5TFVVHQLKCAj10Ir+y1pmp/XzSpNYCP8I8TuMMlkTPjj2Cc6u30LCn/NyEMU?=
 =?us-ascii?Q?wgXQWWzbdZzruFYOFkLfKLCjF8xJXYrDeypPR6RFC1GOal7XqKwO848L9RKG?=
 =?us-ascii?Q?b5w1oKlABVEFqh2rAfbSzUDlGwwJoC31Z30qEXc2QJx/RvaffXe90XsUnTPg?=
 =?us-ascii?Q?uelU+/3sPAkeY/lLe7UdAGn3ZWfaPj1U+BnLxI9VQ+RMIMMGcv71sp045BXF?=
 =?us-ascii?Q?7VHnPijPYCRuUzWRBkv2Z6CPR1Ug+7jA+TsDsg/Z7TeqlPwWLSWaqqf0PDrK?=
 =?us-ascii?Q?lyLDHwJ4HdNjr0lCgtsS9PhQMlV4slmAb4mrKiN9sYefD+UuvpMxSSbNS2aU?=
 =?us-ascii?Q?bn3Sjd/KlnBvfje5R2Sx864n1G8Q5E10LLRVaRBqUqVDzYq/6sFnOu2H/qXo?=
 =?us-ascii?Q?USDbvq61BsThMNz0o9KIBIPb9C2CDGFMj+wKWPxLA6nR9mX5dZ3k7jFs/Z/H?=
 =?us-ascii?Q?EwzjUguzPhSAA0eE3I26xgR7R042CyKTp2m5Jt5ZgzQlWm7IvaBgzUMMOXoJ?=
 =?us-ascii?Q?iJKM0sbtWHX+gku4ZRQCGbFpFbZlfT9xS7XJnoW9Yi3i7/vIVTiUoaBNs4hx?=
 =?us-ascii?Q?NRsmnR0Z48rEpP1R5rr5f+hAOUIc7p5B6fim1i8BZjDiOR+qMlWgGk9vWmUg?=
 =?us-ascii?Q?As6/+umZUvwBp6hRzhcg8AYifcHsGe1ORoBd3cvLs2pbvpnQ6hQOPl4PN+fq?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X6jnZjVXZ/TgeWo3FMu9hx6pgfU+7VVctgn+bjFPuIPDKf07qPN4LIKcQ2HcUqJuAY6KlC9Zez2p5J1IRT3AaI+vBQukZ+dP1/gr8jOSwW9o8+bnrO62qzgFi3JaoXQmuryzqLR0KfJ12tVX2qEM0nyq8HXQmB+QSoJcCQxSQMz4nWi/q5bXaDgSKX6M8Y+910CEpdJ7alHozr1ZFsPD9dLXQCSvXrqYwpUg8ZO/bvjBIS4PYurc4X88VSstzJXgSCl26ANEoLGdK26j2H36UhmqKrFvAb16iAURkTpp7iBrGzbDxQTxMa088aCJts+AOFEd/kY/NfTPoZUdVYP2Pw0n3JRwvRO2oRmk0P7sm8XmaK1NUnbZDUksmoLDUeOTTjwqrHZmG7KrrTT0VBzd5gFAvpO65CRgv2/Qye1BUkneInXOLhpSTxlbvU148ijV64H8GVeIhOZ5dIbU617eBkf8ZrZDhJUepb6NokZXrEvMHulQML0BOCzNsbuBEP544tVtqY5Dr6/1MoFR+ySxPVECuTxXql7i/eHU2vlVw7kYgst40bBevuZDsTnaGCa/889FWwckE6k/ZEoOfuakpp4Yy71SNZ0dmLfCPRXMGtA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cc8e81f-68fd-4802-8f84-08ddf5fe5615
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 15:24:47.2793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CvsN/s5j+Dd5tf+8Zi+9YfjlfKSNqnFbOaCYij7AscQAg9bAOdx1y3ZmdBC7o4m4sSKWuNK1ziKjjh2XcNLWqJR4VaBTOWNK+1oEJTtj8P8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD020A49E6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170150
X-Authority-Analysis: v=2.4 cv=TqbmhCXh c=1 sm=1 tr=0 ts=68cad2c3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=3VxSRnZmKhVynjaijvUA:9 cc=ntf
 awl=host:12084
X-Proofpoint-GUID: OZuB5B5_v-c0Bc_W7UM4GpWesTQsKVDr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX0wKWUPhXbBEd
 iHNYzM6R7NUEDD+Cy1pSxdENrQ/G8Ul3mppSXyGQkjpqM4QJCyM0SoTWbxBAfuNdl52Emv6otIp
 tZiAmTMsQ+SquoqloI2QU5w7/gg0pIzu+iqSjm/m1ahpE5UOJNxejdWUOcEB95037Iyd188pa1C
 BvNbhkLGyI6ujyCU1YWEO+495qx2Jcq3PC/VF+zN2sgN5UiqM2Ikw3mM+FuAG2ynCFfEDtawRS7
 vXNt3d2IZ7fhijb6xoOFDMHu0XWD4Wj9AtybDZJhXOrKxun9YSnlvWI86qMkMJ0co2nxaqqN4bs
 uo4dk+Q57auLgeyOar7Sfldzqt6zJThwNEhXZG4le6BUzfzSgGpQEE4hq0m/BZN7VK8wqptjKPo
 8HDBQtadBlqVHSIxDCK74Z+QTGUaOg==
X-Proofpoint-ORIG-GUID: OZuB5B5_v-c0Bc_W7UM4GpWesTQsKVDr
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E2B984000B
X-Stat-Signature: zou39dikgophwq4bogsms8a5y1muw9r1
X-Rspam-User: 
X-HE-Tag: 1758125919-946300
X-HE-Meta: U2FsdGVkX18g9DKgrQYqvfmlhyxlwmxxXsXb4duat+oyk6dgpx5iWlvHTe6dAudb3w2sn8XbnIR+6jBj6V4rw8C9cyLX+lW1XEkLh0mu+3CkphMfjkDcNw+sqt6zU5WEAoKg7k9K5m44ppvMvbXFEYgzR8UxLFnjNfGM35NNW3YpRI6h6QRqtAFNRfSNWLk9Vs5STGSJ7khNPb4t8rmfd3+oJerwLDNvIlvKvKwvVRq43LGpD5Po59CmYsOTqDs9Njb/fO/JSNvu+a9R7HNTkcwyctTV9/IxaXmo7WJmNcdvZCCfwnaeQ8HbgaJ8WPbBtA1Dd31tCmVH/sPa/TjG4foODi7D79nTCs8P/FYQsXT5C+NLOxNigNuBlsURFBgAhj5WlOqquGtDc/8j5ZN/JUKc6YhBN8FIFtoE8tgN+Yh1+eAZCpHh+hin9xAbVf5j+aElbBOZ5schfnOwS0eDcEN1kQ1WhtvwSsX01Tdzlj6QyGK7pFpRWHehnUFVCautdwQ6VDMBzf2SFX2ClV4x64tIYqnU8vDRhq3Y/Pa3B2fX/oFn2E2IOyb8MJc/8xlcMrgPoH8dmJzjMkhBvgLiWC/Y5MQuOO0kZPbF5S0f0laKExg89l0p9Xwvp0/0soohUXhKoOZcBDlaxEf2NETFOzZ1mmioSTkJMBHH5HzLbCh+HJh7wSJECE4Wm+J5rgaqaJ8rXE3pLnaXI+DZWWUh9LdYYEOy3TuhuuMd7cumG9eRvKly3GrSqdQDHWbCqv5g97slIUmcQMZxSPLkSKAt4NLHYWZBXstgmZjgwR9yVNPC+TA5G2Wimm8j+KE8mRF0GcPrHekPlLWYLEY7pJNN2V5diluWF2qOBvVhXfyUyXrpf91OHAhPeBP29e25F5s98AbEYvpN3yTNpkYvtX+GsG9zYFFLGDML8+cp5RYvd6S+PwmhSQq5rCSsp5Vvg1IPZeQR//OPjUDEF7JqMg5
 bjHMAt7G
 hJ1I/TTJDKy3ySFa0kZh5i003XHAgvSoVNZZZfFuyBE5f1dhVihCZGqYs6ftavKerYDphm2SHiaoNq5CvmheyxPF8KvPeltKvzY+t6OoS/VyvNoPUygvbRuVd+Al/spXr5EfLHEYXvytlQ3LEdTfXtAahd5BevD7/p+m6fMVemwd8YkZGt+92RCyS+DwPDPLJY487wQRWzwIohuqsLPamu1xQmCRr0g4ULn/2vtRz70XrjfhUxtW/iswdNJcPVRDXPNtlnhXNpYm36MzlYW5M+7CJvvZR6hbSS00FcUjnri9OXNXMr1BdaD8I74m7mmLjeYgCSING5ZLzX2EuOqN4QID0SUbvnTIulU0n76vrpWeygzzJ1m6zDWspq1h4+92jRu2IIFa9xufqj7JNilSml8DKimaZUKlQDAyIR4HfB4fQxqFmwIO9jW98+4SWTQyWK+/ZdVJhBN1sg0C8X/YbxIokfyNAQmkH5kbQ0KR3veOW3ZrcvqLacnVQItK1e+y6cf+EIoXMkovfE0dq0xXdW/aS0KkLLkzmt10A1n18yVTSqIcpsFWWbDcRmiln/m0By8nWBTQvlFubOvBuL8Nzatz93XZsu0ZIGxIKtIQZmniNj0r+hYca7WExS4ORzr8QXv6oiO3+yzqiObkJWLsyvw+0pvpwEpl/cUiRS1Dyo014YaBwT2inKy7nT+NheDZN8WzRZeumuQrdsPjQzmbFppdrIhfYylNcZ4vEEPd6KjJ1ejJQrioSiFpyQMpPnkFkO+/+SCD3QnpbiczhC5tQ3tIs2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

clear_page_rep() and clear_page_erms() are wrappers around "REP; STOS"
variations. Inlining gets rid of an unnecessary CALL/RET (which isn't
free when using RETHUNK speculative execution mitigations.)
Fixup and rename clear_page_orig() to adapt to the changed calling
convention.

Also add a comment from Dave Hansen detailing various clearing mechanisms
used in clear_page().

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/page_32.h |  6 +++++
 arch/x86/include/asm/page_64.h | 42 ++++++++++++++++++++++++++--------
 arch/x86/lib/clear_page_64.S   | 39 +++++++------------------------
 3 files changed, 46 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index 0c623706cb7e..19fddb002cc9 100644
--- a/arch/x86/include/asm/page_32.h
+++ b/arch/x86/include/asm/page_32.h
@@ -17,6 +17,12 @@ extern unsigned long __phys_addr(unsigned long);
 
 #include <linux/string.h>
 
+/**
+ * clear_page() - clear a page using a kernel virtual address.
+ * @page: address of kernel page
+ *
+ * Does absolutely no exception handling.
+ */
 static inline void clear_page(void *page)
 {
 	memset(page, 0, PAGE_SIZE);
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 015d23f3e01f..17b6ae89e211 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -40,23 +40,45 @@ extern unsigned long __phys_addr_symbol(unsigned long);
 
 #define __phys_reloc_hide(x)	(x)
 
-void clear_page_orig(void *page);
-void clear_page_rep(void *page);
-void clear_page_erms(void *page);
+void memzero_page_aligned_unrolled(void *addr, u64 len);
 
+/**
+ * clear_page() - clear a page using a kernel virtual address.
+ * @page: address of kernel page
+ *
+ * Switch between three implementations of page clearing based on CPU
+ * capabilities:
+ *
+ *  - memzero_page_aligned_unrolled(): the oldest, slowest and universally
+ *    supported method. Zeroes via 8-byte MOV instructions unrolled 8x
+ *    to write a 64-byte cacheline in each loop iteration..
+ *
+ *  - "rep stosq": really old CPUs had crummy REP implementations.
+ *    Vendor CPU setup code sets 'REP_GOOD' on CPUs where REP can be
+ *    trusted. The instruction writes 8-byte per REP iteration but
+ *    CPUs can internally batch these together and do larger writes.
+ *
+ *  - "rep stosb": CPUs that enumerate 'ERMS' have an improved STOS
+ *    implementation that is less picky about alignment and where
+ *    STOSB (1-byte at a time) is actually faster than STOSQ (8-bytes
+ *    at a time.)
+ *
+ * Does absolutely no exception handling.
+ */
 static inline void clear_page(void *page)
 {
+	u64 len = PAGE_SIZE;
 	/*
 	 * Clean up KMSAN metadata for the page being cleared. The assembly call
 	 * below clobbers @page, so we perform unpoisoning before it.
 	 */
-	kmsan_unpoison_memory(page, PAGE_SIZE);
-	alternative_call_2(clear_page_orig,
-			   clear_page_rep, X86_FEATURE_REP_GOOD,
-			   clear_page_erms, X86_FEATURE_ERMS,
-			   "=D" (page),
-			   "D" (page),
-			   "cc", "memory", "rax", "rcx");
+	kmsan_unpoison_memory(page, len);
+	asm volatile(ALTERNATIVE_2("call memzero_page_aligned_unrolled",
+				   "shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
+				   "rep stosb", X86_FEATURE_ERMS)
+			: "+c" (len), "+D" (page), ASM_CALL_CONSTRAINT
+			: "a" (0)
+			: "cc", "memory");
 }
 
 void copy_page(void *to, void *from);
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index a508e4a8c66a..27debe0c018c 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -6,30 +6,15 @@
 #include <asm/asm.h>
 
 /*
- * Most CPUs support enhanced REP MOVSB/STOSB instructions. It is
- * recommended to use this when possible and we do use them by default.
- * If enhanced REP MOVSB/STOSB is not available, try to use fast string.
- * Otherwise, use original.
+ * Zero page aligned region.
+ * %rdi	- dest
+ * %rcx	- length
  */
-
-/*
- * Zero a page.
- * %rdi	- page
- */
-SYM_TYPED_FUNC_START(clear_page_rep)
-	movl $4096/8,%ecx
-	xorl %eax,%eax
-	rep stosq
-	RET
-SYM_FUNC_END(clear_page_rep)
-EXPORT_SYMBOL_GPL(clear_page_rep)
-
-SYM_TYPED_FUNC_START(clear_page_orig)
-	xorl   %eax,%eax
-	movl   $4096/64,%ecx
+SYM_TYPED_FUNC_START(memzero_page_aligned_unrolled)
+	shrq   $6, %rcx
 	.p2align 4
 .Lloop:
-	decl	%ecx
+	decq	%rcx
 #define PUT(x) movq %rax,x*8(%rdi)
 	movq %rax,(%rdi)
 	PUT(1)
@@ -43,16 +28,8 @@ SYM_TYPED_FUNC_START(clear_page_orig)
 	jnz	.Lloop
 	nop
 	RET
-SYM_FUNC_END(clear_page_orig)
-EXPORT_SYMBOL_GPL(clear_page_orig)
-
-SYM_TYPED_FUNC_START(clear_page_erms)
-	movl $4096,%ecx
-	xorl %eax,%eax
-	rep stosb
-	RET
-SYM_FUNC_END(clear_page_erms)
-EXPORT_SYMBOL_GPL(clear_page_erms)
+SYM_FUNC_END(memzero_page_aligned_unrolled)
+EXPORT_SYMBOL_GPL(memzero_page_aligned_unrolled)
 
 /*
  * Default clear user-space.
-- 
2.43.5


