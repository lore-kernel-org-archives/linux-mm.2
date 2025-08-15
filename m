Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F58CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 19:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5AE28E020D; Fri, 15 Aug 2025 15:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0B3D8E020B; Fri, 15 Aug 2025 15:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95EEB8E020D; Fri, 15 Aug 2025 15:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6DD8E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:11:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41635160266
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:11:07 +0000 (UTC)
X-FDA: 83779934574.28.B6C24E8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id D74FB180006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:11:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=A4s+yTAi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Vx9TBR3H;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755285063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wxnujMoYJWRrFHQRgJs6v/mLYORBDwH2vl1zWyYs74=;
	b=cf73vJb4JKsDVCgvN/9jbFZ5ZzAsp86nsjxENnTXlO39icInzTpERI0lcHvMnAYS1Wc2qb
	oMj27lBo6BkfLe8Y3WYks3KH2ZnveY9RYFUSb0y0XOTYstTFMhV0+bdtVLxtNEFC0lR54r
	eOb90iX1/KMYiCUYU286ef434kkdQrk=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=A4s+yTAi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Vx9TBR3H;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755285064; a=rsa-sha256;
	cv=pass;
	b=JozgdCEpNz0KfG4RBqxTsGPNvBf+r57zdK7+s0O+VEL8rGGvVGAMVxil6kkj0bgPSboiKJ
	ZHF0Ze3WbLuORIRp7mO6n7QsKbOH6QL4813Cu4dP9h7HLCriMlJeYEaQK390goWEu/oLIX
	OybnpzaWKq+FSX372RRBty/a2ySgyKE=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57FHkCVL005059;
	Fri, 15 Aug 2025 19:10:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4wxnujMoYJWRrFHQRgJs6v/mLYORBDwH2vl1zWyYs74=; b=
	A4s+yTAiFaObx79vZRyMWwGZ18PSlDN+GrQy64DhaEEfrziFu3O33A55rhETiGTa
	qExwRkkqCYB7OQq6Qk57FsB6k4GANEDrXxB/zxOeIFQXUr4uIbZtTOj/XX8/8iNU
	ekl7HS5bUcH1FAlwSEy41ALEhmEnOTGAZJuEngHafqAcmxH/TDPSSPkcI7+paY57
	mnsOdCfUu6d2LXvS2Dc2BF8Uoaq0yrJsBhTmxmdI7ZdTdUu8KCp/bXeFouYgdcw2
	ZdKxF2tcR5TpFaokKJljGohbM8U6XQWlLDbi0w4fd6Fz/SSImdGc2EKXVMAEAy09
	jIi05vNr5c3frq7eL8sUxg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48h7rmunet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 19:10:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57FINNY8010424;
	Fri, 15 Aug 2025 19:10:47 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2057.outbound.protection.outlook.com [40.107.96.57])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsmnb68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 19:10:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cX/M+Dy7h+aXnGZePaldl4RmV2Yj5tl2SOKPhI+bkf1U2fHDZ0funA2ZoEAcQ1FiYgSaMwDgRoYFEPP3tDVNwcl2LY3whISJwgbey6k8S3dridxeEZCdvID/pfJye+lTWDNdS3QJ0DvYFFsNMvW7oCItMQadKlo2FKGOrLfP7WMV+x4tgZP93P5yREwm2Hr2BIv/VqNyKGD0n7CzZEjM6PmBiI5Mq5M7BFwSHXvFyT7NS8zoDj1No08kpODyMX9GbVJIE5FCRDj7YUK6HlJ1s+wqU6BKCRn0AfryK1onDMmEhYpkvsd3U6RyUX8mRz5/kloJIP506/7tZ1Aq17wP8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wxnujMoYJWRrFHQRgJs6v/mLYORBDwH2vl1zWyYs74=;
 b=ohts9zuh1DdsdKTlpq3Cc+kF7/Ev64WPjjuCt/3MicC4Hy91Go/uktOhoIfUVbJwannYuyECCBuVkGkoebyXq02UElD6i8eS+C8ScWW3qpKxWeIyAaw09HAUvnmM1jkCc/l68BlficKvQAZNTdj0MJEVr2A0Rw6OTPTIncr8pBJTYCos39daLlDny3+lLGEGMM9zJe0nYPhzsthaZcDurR++U4WTJAziGDgwk3gYHTyoXKu3TB+ONMhGX7RS6k7ah4U1kQnNLw9dMarP4yQMMvXyPJ/kCc/2KPnm0pzWt6Mh9bDZCJOgEjugh9ewNIVowXdr8bQ2n+wBI1Hw4Y9gdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wxnujMoYJWRrFHQRgJs6v/mLYORBDwH2vl1zWyYs74=;
 b=Vx9TBR3HzvShmfsynh19X368cIhxC/eQ8q5sN1qwtrZaLCDmpDB6DtY7NulqeGy6rY0yu++j8pitYDCZE8BvgyrHt74rCrLXfa2Xxa/xF54DLquF+v1tx2QAxPCRZI7o36q++yYleJiJcet/85vnVBshjId93To3msLWMg/55Zw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MW4PR10MB6464.namprd10.prod.outlook.com (2603:10b6:303:222::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Fri, 15 Aug
 2025 19:10:44 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 19:10:44 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [RFC PATCH 3/6] mm/vma: Add limits to unmap_region() for vmas
Date: Fri, 15 Aug 2025 15:10:28 -0400
Message-ID: <20250815191031.3769540-4-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0004.namprd06.prod.outlook.com
 (2603:10b6:303:2a::9) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MW4PR10MB6464:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ae990db-6ee9-4819-dcf6-08dddc2f6f65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?APREwHqEnTgvzhuzD4qzYU76JtB9/jTUrW5ZgpHIAXzC0msPcXA0ZKsFsUp6?=
 =?us-ascii?Q?oggQP3EsrUONtXywlvp5sLmKW+fN8+dGPVbwDcohVtHqYuO2+8fwzV/MQtEB?=
 =?us-ascii?Q?h2Muw7HJpNX2PM64P7KP+CD7sKoUZiPxU7ejirZlcFphODiVoXe/NL1xfBHg?=
 =?us-ascii?Q?EJivEKfkEPTFcnwGg5Zr4/FtInrSN2mT8OrAeIgN4U+r+T1GhYeY6/rVcVfs?=
 =?us-ascii?Q?XRUjWORjWOHPnaLEnJOiJ5BGI5XH3NF/wnUdXOSo3OJXk0WnasaMy7lyO08l?=
 =?us-ascii?Q?urhT0z1+5SPOrzibkikCibF4pYxLO7Thsv0Mzsa//1cD9SilzTy3pICEBQkw?=
 =?us-ascii?Q?4pvyKkH6N/ofQLcFsKfNhxkV7uKAe9Q+u41CJdscv4OteDdfsN6OY5gf5tml?=
 =?us-ascii?Q?HrARE+kJhT76Akvv2u05lNlWvytduXBGPckzGtB5VPncalxTzPzUKXSoawAA?=
 =?us-ascii?Q?vTwhx6BQaCYA1jioSgVUKZZRzMdk/uM5gmdJpkrD1A0B7mxN84d3s+NuQiLl?=
 =?us-ascii?Q?o4/4NcEV1Awl1zDnN9hmuvHpUkGMOYXZc9D/axLro+tJ1BReMR/AKedavdyt?=
 =?us-ascii?Q?b5frPeBZ2/dMFWG2VM1FtSQ9V7aOcOGKojnKM8bs/B8Yb4UC7fopPsaNZnvg?=
 =?us-ascii?Q?IaLZdJbNJEkmCUrG/UUhgfzAj8DLUjoC2eQB6vg2hJ5m6sVJHCPf42v8GcuT?=
 =?us-ascii?Q?epXbzxg6fxuL8ULtBmIgqDTx0l0vDxlgWB4Mna4+uk7I9i1v0TqW71D+NZwO?=
 =?us-ascii?Q?07CED0wSccNkT2nldwQtB6rmtzADeJGuLYaTuC5UuelirBh9gTJS1Kyj6AeH?=
 =?us-ascii?Q?DVVU7zI435f18JYM1bPBRo6OgpmsxRR24l9q1NVqtLRLHkgbTLfee+TmiiaQ?=
 =?us-ascii?Q?qzOoDKzppJe8T1cc7n88zBItC7UhGhfgTC7VnKNSPbK4mnFrNWPRf+HjCLoL?=
 =?us-ascii?Q?Dv1BdkJDHgA6iOO4q/NwzGQZKfY3TSe5nwse9li9I3Bm0eYlRrGphiPB6cGP?=
 =?us-ascii?Q?gVl+KN/8BkE+SppFHMWBZ7JrCNfkFhoK/XTEOzjbTc9/fSAsjUgABWKpHQeD?=
 =?us-ascii?Q?bDQC6SxJue/sUNFDeMhSsX1F9l7qtqerFTbEAntX5nXvMZ23gt/mgh8+kLyQ?=
 =?us-ascii?Q?db25dnND4msgIY40LXcd5EXpT47u9pazscFk52QbKsC8cTXQok55c5ryF/e/?=
 =?us-ascii?Q?LlbyplHb/ZBfvro6fDi/nMRAdlyZa4BVx2dzwWQaPOl+dRS9OZljaF6lVRJN?=
 =?us-ascii?Q?fbGixagpREfY6jQ6MUixBEwAOxoA7tTR+BHPmkMI8gSFqa7Rn1MT+5JeVFsa?=
 =?us-ascii?Q?jQsPmpT83Sk/FkrMMPGXSXZ2qVg93fSKL9B2QnRtSPstowRGCtoUY421Agjv?=
 =?us-ascii?Q?bTT0RFeoYWOC9TVhWqB3TidIoNfrZgU9mWRIevzxSgrZRnDhtQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pFB41GTF387XqHIWQnIKIONlZykl52WHmGVJ7Wnqr1u72zve0RxedHO9B6up?=
 =?us-ascii?Q?geJy7ZZjryBS0LKbd+o51O1CxAtxELNkFolUuIx0dXNwdb6OL0nJGwiYSG9m?=
 =?us-ascii?Q?4kz9GDXrgoDmfF/Pay1IZp/9RGKPfY8HDeHJY3cCTtC9j8NTio01UJghZeO5?=
 =?us-ascii?Q?j7G6wdLIc78wbulJrnGRrl+mWTeirpfiR08wWC90MRDWoWMyMODxezQL47va?=
 =?us-ascii?Q?EWUAfzrwV9HIkTrFtwv50g11u49GKMKSw7IZtteKSESIj1pWCUKEHLcCEZ3s?=
 =?us-ascii?Q?HkQ+Lpog7w9RkYpYiWM0byoOTf0LIskpzRp0CVKWVdXiFNGl2Ps8bDVT1Sx4?=
 =?us-ascii?Q?50MxmapFZMoQGRsIuR9cAlTKnF/uVT6ZRjw5qgXtDOQ5dBwAJlTUFO48CnP6?=
 =?us-ascii?Q?CVWBSdHDLrd3ecW1c1hffoCAwyKWr2U7M5tz0kExBXE6jh+4fWu77pk+Gp5x?=
 =?us-ascii?Q?1yFsr1uVbgZdTkC7JEWtfG6YbnwtqKuAC3wEozsRNi6CNl73D7gy/XGOkP4K?=
 =?us-ascii?Q?hq0G0xUk4OrOVI66OHdMwE60umV96Hw/ulIlkrF8U89RETaNZ7Vl/yf/RhIf?=
 =?us-ascii?Q?garsuqcpr6vrifs4xbprZJ1NszKjtRFAHp2RKZUGpZASSqLmdyapFXzqPFL/?=
 =?us-ascii?Q?gHbSJQjWszDU/CKbXHbE1dowHgfcmzDKvtM1ap8Dq6v9KEOcXaxm2nN+F3Ns?=
 =?us-ascii?Q?pr0Q+ZzdWym2Gk5WljZ80AFYCLt0/8yXmynBkyb2bBCCC1VuHPBNmfWGtSDl?=
 =?us-ascii?Q?k23vOFVna85pFEwofFVNNM5/gZl0i6nYoRiyav/2aCYGi2YcTXgAqEkNkGJ7?=
 =?us-ascii?Q?WF5+4E+nVOYTMZVQEelZIYFFO0ORLwFNLFtyIpNgyDTh95cfl4FBkIdSypNZ?=
 =?us-ascii?Q?Ja4XJU+pCMWls/K9sIj5nOjvsgAsrHTYMgzI/CcRCZb1ureSHEYARaLZGlbV?=
 =?us-ascii?Q?VqwqKSnNPsNnTFtkS83MXf3qbn/HIdB6hCJayg/wx8RW0h2hQIN4DM6W4yOY?=
 =?us-ascii?Q?gCT763km4PFOEqVPD5BJuWMJyN9aRAUsyHvRaz1nTq9u4m9saFsGVmsPEQH1?=
 =?us-ascii?Q?k2gX1xZlOu4YXRrKxbAKt4D+MYT4o5T41AcGSOg9XMJGWNfrchgCEk+C/8TA?=
 =?us-ascii?Q?rSfGdcxuKky7qAWYz/YQIUQXzhRm36/TiqWoeakEMVjlEJ51f4kuxS3L7fPV?=
 =?us-ascii?Q?BizhgvYv+1qBqAXS3/Iz/QxvPLCHzBv5abAWrTBawNvQgh05yULYEoNEfbwF?=
 =?us-ascii?Q?TN4/YgwOlIpFAevflI2rJTB+/oTcETTV32mkV1dty+NlJqsW6Gj/i4oEDcj1?=
 =?us-ascii?Q?62lIjhcFEI5R8V92VSZdRsKRDmPqF/RS7KknOtxeJB+UNdMk2MNIowBFlD71?=
 =?us-ascii?Q?13yhSvoZ7IEKPO3R2wTFfIzUc5dXrt/fJfnIfy2zPiE/96clhz6XJ/WmCkJt?=
 =?us-ascii?Q?CFQEedPFfI1DEVfH7lRlnyb/aoJ/1cKekabNEtJ0s7QIAUhuColxEWpLHB2s?=
 =?us-ascii?Q?TB9/yFiDSPuBvzp/+VjzDBlkHnvUzu7wnq+qxFOpXc+1AmPPu2twGb3I2Jsc?=
 =?us-ascii?Q?BWHDWviX/HC9DRZm9ukUhvw7duT4H0Q8tuxw3Ldb?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZVXQf/9V+hlPUTt3C+sw/9Z2ih79d2l+0G64q6AS/gtDTtZ3xp7Jv/JCnq4mSM3/cYcxdXaXLS4R4s35gY7fcnyEFICZOtFtVhsWFGmpbJz/JKA9UdsaNjjePfhH51aZigVE6HQ+3M/wQdsAT+4cMDrIPZoofMie6hM9z2dMlpL6D6zhHsBIaQKQDLYcfmQ29Nxa1y6dKtgjBmobZ/miWVDxxYKB6lqI3rcXtyHIsrsPYd130sjsDaHwmGwqWcHb+OHLpRjaU2nKFMv5Hz2ymu6k3KQP6gMRPObSTvA2z7or2BvE93DS0f51pA9zAVflJ9QRu1dpWRVbju2cpET67qh89TPoHJLqBO6rZbYX7xmOGEvum0OvJK40zizTkcloHbgwn2cEJW5JH8BWTzFiomlJJjp4t0l425HF/cE4DpacUvfKcT0N74ROYFmk6XkvYMNawq9q0M4UjNNgMcrsn4OLq68bzehvRawZ4AYB1kDtKSKPWqG++LDXWX8wliGo+5MA9CpTo8J1puMikJEfF8kwuJA2bbDpErCBBtaYWGr7Gw9yV/Q4k/4l/ridp9ntebEob5ryLN9EHw8czSANNXVbytt6fueTD724hoPTp4E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ae990db-6ee9-4819-dcf6-08dddc2f6f65
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 19:10:44.8310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rg6Y6T2+rq8wiUGARIMcpHpZRb2m17GD56qpEZfYhho9pWn90QJohBqGXwscI+6tqFZK6RaQ4BFEd0ALr+Lqsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6464
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_06,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=792 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508150162
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDE2MCBTYWx0ZWRfX1vx6gB5M53I4
 tK7tKqbRt1XwSt5LUqfR+1H7BTfH5HqXBlUomQDFMti6ddcwXkCT3Yj/e/3y5uIqBerzgzjYLO5
 CIS39DD/XCK7ot4qxAnWgHUEhFBa8FHad6Q5Nm3STGWQUTXQmFYSUb/rQA2jI2n+pY9HhA12Tup
 pNPyfQnvExDcc1J4GCmd/mHwaLRHwgkZ27/jqoOPkAglKKlojXH6H9bUlwpGMSa8CA40qSpWlyu
 pUYt5E+lgKT6NmkEwE18y2MEU5G9qI9zhkOtVOQWI1/BPppr9jfRSThQTiL1GG1hTiymRElskWu
 VHFV6Gi7cFQUEoGpc9SHmp4omA3uv9iT+dWZUFdpuBIVja8G3+ALKGHMiT7NVudLorsRLOopy4N
 PrA7KaGsIZJQEM8+fo7BzYsm+E2THHlWskm4/Ry5Nk2LCWaIPsX+BOcwe+wajjIoLCJI+03P
X-Proofpoint-ORIG-GUID: Z6NSdjbdvMtBy6SYRqFF9ptsY8CDYLjl
X-Authority-Analysis: v=2.4 cv=UN3dHDfy c=1 sm=1 tr=0 ts=689f8638 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=vRAc46Nucz-5yIst6M8A:9 cc=ntf
 awl=host:12069
X-Proofpoint-GUID: Z6NSdjbdvMtBy6SYRqFF9ptsY8CDYLjl
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D74FB180006
X-Stat-Signature: d5id855seneawj91k3xowtm54bbhumjc
X-Rspam-User: 
X-HE-Tag: 1755285063-646630
X-HE-Meta: U2FsdGVkX19IkO65uW2rAJIvwarXe/bn9evb5k4YP7Mg/Gtd1KhuURiLusWSd+4jgYoUpsUXP2SP8eacDo9H0kOXwLLbE40gS8aLBqxAre9aQNc9pCEYx87XqfvEa/UHeORkTmaQSPdwLmqmbLEwWW6x5mu1yrPIG77P30b7UCTXHjld8gjCeO7MrbPZwT3SbQ61syswvLePQHmvYaMy5OMIry7r+OdeAf9cj269At054cMIKwI/07Wad1iKik8+nMleT2djIalO8i5GOuSs+6jIJFGQ/ajPpkkj0/ZJ9tTGGXcb1OZzFkvPt3G0I7l3dQdRXOuiQoi+x/2IrNZx9epNgNku+0b5ouXJfJ/eS8ea9/7LbSNCb6tkOnAm9F5SyUkbS2/P6LiGSJY5cYCNM5V57Fojl9IQdARRqjblRXqOEdht149zD1JjALP6JvIWUGrU0BTshfvNep5/8XxaTr+WOPW2I/oShc/5DRRsbfrpp11X34K2YvSmZyLRfCI/nJ/zOYiSMCJ9r3ZGXFsGHrKXPtjvSGyEgsWREYnSjKYc+0o41geBwR6bVODu0O+rb72UD+UXb33nHw02Frh5PFZyv/0ZfABa+qyOAR1UMZvPjTIsP+nwZFPECfE7zlkH+lHxK7vv0E56ut6zYTL7Ju+il/5wkGD0zkuba9HRsoJFIuKOPw2a2Jf1b2J3ZG8CAq37z2e0uyYEx1lCh93HnCEPTXOu0UHT3W4Dn0jtvJqtNWtyrB3Fzygck+V0HbOLrp6DrdkT37aZuaXzwcby5tzJGt1lLV2KalsJ1osD+aPLGqdVv8WIH/SUPyZ+3CFO6aHBWUxBcRvJOIAV6eQZAPCeljgxTM/Dm5NSLT4EDDwkkOibRDFPF9tZa+1tHfxgLOBN3l5C8rQrK6a1UvjQ0xOWA2h08YQriIvR+hWUJLJtua7eFHFQvsB2mO6ML4CVSNhJUEwwUFMGRoZtPDx
 40PtmkLT
 LOaqzqGfBRYdQ2fQCcxYJ2uq4Xbfkhya9oAXnZqikrIp5wMiyniuWTEqUkA4V5G+5Mx2ZBM4Fc0aJTINw6c785GHkSVmojSpxp0tzpWNdbdcKvl0sa5tlPkqLSI1SRmbtOk/S9oD7TxxEXP89fqpUF7q67qZVpiLFxHW+Y0KUXHOK3b+a/He7O6WkHeBLxEA5DxBnwQjjxBgMTd6dONR7xFZ/LDrA7u8LgpNSn2+60nXxtPhpP+e6vAfP7+jDrx489ikZTTwTFvd3ZV3QHSga+a5LAGYHmr3pyHvLaucCW/zhlhijL4sBKn3T7nkfBcZ4gYoR9E5nvg0o3KwLwzxgIfmeBjtBAxEg6tIIsBkxmuAk8tJXzjFDp4BZy0Blsv8V9L1DdXc1tP2k6FPSK6lm8L2enXeon0p8FdmC9LDZfTOf9sZSwgN1tUVUe0qJwPxM/5y2OAXxMvjrLJ/wXmXz9jkTxlLWnjuapNQIHBm8vNv41L3S+2yEpSRI9kFycNy4l/C/ZPcHwLlLl++D45Q+tdiptWvSpN5Rdrszez3SeMgJYdl8/VsGtaIlWlFtWF0gOY2Y3TLjW/8iNcWE6uldgwMU2LaVVbU9GTeSsKDu/6EMFH3wNLMF06NNWseCM3P1gJGlg1qAde0QygUvKnJmdSiPJHe7hmyomOL2dJ/+tr+lDw4ibQVzkoiisXBQ8UjQI8LieGnwbfkFxFZNzvNXZupnzIWaIExYcShqbfN7B7AWxMhtaJRsva0MPDZxDUBx0Oc/VUWZnW3xPN0CHH4XNnH0gQYsQYAkoa4FhYqM/sPHDnOFfBy10ixPyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a limit to the vma search instead of using the start and end of the
one passed in.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/vma.c | 6 ++++--
 mm/vma.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 3b12c7579831b..fd270345c25d3 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -474,6 +474,7 @@ void remove_vma(struct vm_area_struct *vma)
  * Called with the mm semaphore held.
  */
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
+		unsigned long vma_min, unsigned long vma_max,
 		struct vm_area_struct *prev, struct vm_area_struct *next)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -481,7 +482,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end,
+	unmap_vmas(&tlb, mas, vma, vma_min, vma_max, vma_max,
 		   /* mm_wr_locked = */ true);
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
@@ -2417,7 +2418,8 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
-		unmap_region(&vmi->mas, vma, map->prev, map->next);
+		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
+			     map->prev, map->next);
 
 		return error;
 	}
diff --git a/mm/vma.h b/mm/vma.h
index b123a9cdedb0d..336dae295853e 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -281,6 +281,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 void remove_vma(struct vm_area_struct *vma);
 
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
+		unsigned long min, unsigned long max,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
 
 /* We are about to modify the VMA's flags. */
-- 
2.47.2


