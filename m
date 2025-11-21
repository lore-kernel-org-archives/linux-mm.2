Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5A72CFA76C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 10:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EB576B0031; Fri, 21 Nov 2025 05:12:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3256B0098; Fri, 21 Nov 2025 05:12:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC486B009E; Fri, 21 Nov 2025 05:12:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D97F36B0031
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:12:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B40C04EE46
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:12:19 +0000 (UTC)
X-FDA: 84134199198.01.ECDF4F2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 394254000E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:12:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iCrsJ+6V;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s740nhBL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763719936; a=rsa-sha256;
	cv=pass;
	b=n8fosmOWTbcP2ONkYt5l9YL36YXyatRZ0qCJD9PeQM+ATR5V16FYNyphJ9HVQeTyWU+ucO
	5fECSeEVqEqOm82ccMKBgNpoY4kEiEwMW0Im9PpmjyyAKpymLGiRl7bAjThnG4vGE0+egp
	euCfSan4kjBK52vzmQWh7QOjWpytY0I=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iCrsJ+6V;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s740nhBL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763719936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H4z9CnoDq2ZTkswA5UzP+oUXZBU8oLUz1fu/6LK9I0s=;
	b=ofSshmnjI8DITB1QSlW2Fp/Q8tsGv6pPhe94nvc1sRICS91jYoxBevj36hygXoe3zd+3sK
	jxyBR2x3D7ngVEAzNeFxkWSNAViXbYnh8PRoDNHHpA0jyDqg8QckPDopNz/sR7HNFJJV8g
	dgexHTZKb1Hfy7s2EOQ+liqNvMnHWnQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AL1uL8P005395;
	Fri, 21 Nov 2025 10:12:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=H4z9CnoDq2ZTkswA5U
	zP+oUXZBU8oLUz1fu/6LK9I0s=; b=iCrsJ+6VFFOUjyAy25oXRjgzMRgxfCnpoU
	iZN6yw+J1W4gF0nGQ+KccimgOWSRyIsFjY59ApdAxG7sTWM//3ChTFLJkUiK+cPS
	DDVuGfb9eo5gSKzo6AOGnsVOOjHuYOTOBmCCGw4PyH8dlRSZfxt4WKAHWayJyO8T
	2+5NTbHW1RO8JyTLesNYGvwt5UKlgeKJwocLeqxzzEYZLRsPzYzrrxte7giuvOpx
	iLgqnglec6eUbHCcizaCG8JSrbVbWlybjLUScOB2noU4EpePE3zz2Vdy7fm+TgG3
	nR/+eByPmrEcJUg5p4fUaK5yNDT6W9mRfjh+WUpDQIIFXlWzFx0w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbq2xh1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 10:12:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AL8K5We007170;
	Fri, 21 Nov 2025 10:12:01 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010012.outbound.protection.outlook.com [52.101.201.12])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefydd9bw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 10:12:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yat7bF+mOMvqc8rU3zlB8EeWPUsKbTIEBWx88cIhFSDSrlng86jJy3hlY1wyl1EYsNQnk9ph5GImaSYR/44K7XB7w9CVL6Pbo3gv+DY8DH3u9lqZSSWBr8svfHHFZ8Tm+UBzaYBEadaiXM7ATPt1uwPnTZr5UftCfw6TxhX8GDvsE9MvLwvqRuqUmAj3L1/7ryqaXM6FJGmAcsM6JiqpdUuZhEH0PJcqiG5bKziqaCuBDYOkkU4cjBkl/oJZQpRmqS8+YDZj8fNk2qA1vo8YzjFzvCc+olYz4T5jiOidsTL/24UOviX2clpLPYo4xT/ntXk0QYtXvR54khlTm7lm3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4z9CnoDq2ZTkswA5UzP+oUXZBU8oLUz1fu/6LK9I0s=;
 b=gCy0qJKBFPWEWNws9FlO/h9DggtWKPughh0o2Bf3CGoKj16ixyoAvGuDVMOvczgZxsXOSIYqGt+8miu4b8apBtj0Ckq4zwSWL2RtsdSnUkhuJCfBha145AwPaS83TG9SaIEKwcycS9y2DlmPfbgEiEjcEGmCppxTixNd44hf475U3fqN+w9ZmeQOf21xzIzsEO0kEBbHjk+hOtcyECdvx6lmfS/jP/XqGMVsR5XlChy8OVtOj7WYGLwvjx5kDI5uyr6HIR6nyb5U1iP2BJC1sn8hDW2XalWNk/MoHd5woN2RMrt/xGQPMdo89SKdxQdYTzbZIU+K49QIB1JL6ayNvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4z9CnoDq2ZTkswA5UzP+oUXZBU8oLUz1fu/6LK9I0s=;
 b=s740nhBL2M9Gk5bhmGdoj3ENsSd75IyzGMLocrHmtUgtuUey+NeAoZK4A76RyeZ4WB5VN0bLoPbkFrUXpZwN01NmR3/RfcbkLOCZJBC3XfOJlDuClTQb8xGJf9v2cyigXRSooN6CETDa1gzZLCbeYxjNvTPlXfZyrpN04UnNQpI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ0PR10MB5835.namprd10.prod.outlook.com (2603:10b6:a03:3ef::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 10:11:58 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 10:11:57 +0000
Date: Fri, 21 Nov 2025 19:11:47 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v1 22/26] mm: vmscan: prepare for reparenting traditional
 LRU folios
Message-ID: <aSA64yzMrILT8sR2@hyeyoo>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <77c64e29b70bad6ca303e0e591624f9cdf2a750b.1761658311.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77c64e29b70bad6ca303e0e591624f9cdf2a750b.1761658311.git.zhengqi.arch@bytedance.com>
X-ClientProxiedBy: SL2P216CA0146.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ0PR10MB5835:EE_
X-MS-Office365-Filtering-Correlation-Id: ac8a481b-7685-4d9f-a63c-08de28e66712
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+QaE5laOcowEt7aGTq+kPrgrGfTbdzU9CoaW9+vYM0tYNxiXYsxOj1kIyPu/?=
 =?us-ascii?Q?Lil5CCvHa9X3klI55ID1xMGl4mnFoYDGYl28IYaiA0D8qOz1ACOtxoiZK/z0?=
 =?us-ascii?Q?nrJdwVp7mayJP5OpAsODddDJxPWUeEaBzGVP+qHtNtOdeQQHX2NG574WB6cZ?=
 =?us-ascii?Q?YPMPX79WnMB7tnHP2TVhS0C4hgAXvP3hI/2vvRHFYzxkwlKX/rIUm8G/uGFO?=
 =?us-ascii?Q?dIAxtDSmoo7zQMktPZQhCD9OOuM0kii9mGjZG0hXlnqR5Ir3DTdg+VEEauoF?=
 =?us-ascii?Q?u8awP07h44SVpE+Nqe8yuknDXm1U8K8uXan9Z1T1lrwwPUK8BRkw5FM/oaJX?=
 =?us-ascii?Q?Yx5GN3B3g8m7qHuHYDjZaUrU4XGJnUQEJANM+SwI069gN34HpfOLPwPLtTTO?=
 =?us-ascii?Q?7tuaGejG1WqG48LFxj1F9NrLm2H9gCj5ggMEROXf3UZtYApWtlnCjxMAEQeH?=
 =?us-ascii?Q?NsI4OXLIF26/aMoGfmJk7NWMYcRWZCicIXwm2bIy6fTh6BlLr5InEun+F6db?=
 =?us-ascii?Q?j+qSRUD7vX6af6/KSTZfiv2W1xnMgfuBRQCot0FEwv233il5Ps86HqBQCJXT?=
 =?us-ascii?Q?K35JPtG9Msk7CnFX6kA8oH0LXeSb6U+qAJHBi8m/TQgPfgbRzymmpcKoMd5F?=
 =?us-ascii?Q?EwTdCy2+nwiQEgF0p9O5mo/QZiXa6fZsWUx87IozkOnk35tsekJATzXhUEmw?=
 =?us-ascii?Q?8l1dIW8bBUvPFuHXG82+G1VG0Q7t9I2pG6b/Jk5jRNvldyHJSVhlHLMR8TGk?=
 =?us-ascii?Q?ot/obety9lnXBrH5Sp6apKaPIt+dMJIUQnUt8PeSYXOlYtLidS0kGvIPxzlK?=
 =?us-ascii?Q?L9iAtYZfphgsjJLlLW1I6R0/txqKSSvciPMBAIjIDfk1VoBKSrLb5Z3FaZxL?=
 =?us-ascii?Q?EbksuPzQDWule2SfXOIuKmxtv2iFv08tH9CRFXY7YU5zThCFMFRnnoBpGBp5?=
 =?us-ascii?Q?owhDNDiyLAznPgYdOXH2UG5efcEsskk3yfuHN465emQ2U3UVeCv8x1mv+shN?=
 =?us-ascii?Q?GX7OVJym3MBO/sUi33BoferabmX2gplOtc6EHtuJp2SdpV5DCoJ7pDxRMvW+?=
 =?us-ascii?Q?a6MfahAzIZH5cGbqLjMWJOljb6ZelKj/VO5Y3RPfljHPXZQ/MmWBOYf4Tady?=
 =?us-ascii?Q?eZpkLgQOaZa5ckLgwHnGUothsaFpVhdxoItC0xx5gYB7dOd6cz+aUs/hmqGu?=
 =?us-ascii?Q?jROYdxZKTlRx7EYLoqZAGndoEsgX/Oyy07l3z2uXe3k3T2f/AT5RCojikSfg?=
 =?us-ascii?Q?15JEvQN4hRrpTHC+zYYaJoXDS+0q2wwAZN/9u5huSti/4PsNLGfEPmlVHHEo?=
 =?us-ascii?Q?4vnIL/FKM7rgSpikxZ0XRcSuDco60ayZ4/jwdxlK0wpIBkoswBmzkivDqQgU?=
 =?us-ascii?Q?ZJnjJfh6T4mLXmDlhJdkCPflCzqWUTo4dh1LmSsIOw87kt1NjUI58Inzq8lm?=
 =?us-ascii?Q?8CQORK1sBHCVfwHVVBCYbLBXHKAA8Z2u?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LcDlbm8a6vEnJ+mp74U+vL+NkwWw1JGRY/mQv/EPk/gkTXUXHXPFiE35BLVS?=
 =?us-ascii?Q?6Ck6KyYsQ55ZIJ+sOtuu6JVLwiEianAUH+Iz4O2fAguHNkIlpb1VePGRfHeV?=
 =?us-ascii?Q?Fmmy9S93s9mUXYP2JTOZiVSOfDoXy68ZgcoNCQarzbau9oiu1ZbatHJ8+f/+?=
 =?us-ascii?Q?q3x/8RWvSJnwYwKhQRjEBpfkvsWmkH+q7wdnHzgUTOVGwQAxm37dAnxgfEKG?=
 =?us-ascii?Q?kiQgkrTLeYWazfmaLmxmrKWyB4FbCH13pxvuqRl879dbBm44PFFMh2W1ZXMp?=
 =?us-ascii?Q?tJku7PpD+LQJvYeJUYS2rchANjQ8hDqHQaIWY6n4S8Ym20u9AJzcl0RPtwBf?=
 =?us-ascii?Q?15mYa7COaTlXX3qi0/X7emo66ch9yXIyKk6ek/MYhv4rjhbW4eo1gfUtk+/w?=
 =?us-ascii?Q?B5MFhSrWSQfxfu42v9acW/n3g2Q2JkQfCY6mPL4Pop6pa+lIrg+8C2eb6dts?=
 =?us-ascii?Q?zTA44PvrdS2x28zQk5IL+zzU5b6BYd+7zAb/zmQJUH9sjnHPDdoOJvN7T4T1?=
 =?us-ascii?Q?XKGGbEm9hTFPnV1P2+7LQtyb2lU0lo8ujDH2oRNvWh8tZt1Xu7sXPuFUBIkV?=
 =?us-ascii?Q?YPkchqDCO+/7gzhwbtXVe+J3cKmNLphyFYXrPHObMp38CNUzBWRQGJJklQtk?=
 =?us-ascii?Q?QvwDMAt7yTkqLMrJcQq4+bIuIezG2ep7quk+EtCsQY1nhHqe0BvnAjNsaD77?=
 =?us-ascii?Q?nU5AiyOmdQvwPdU0c2tC62AftFqOjGzK6lbWsp7d1OxHqQZwPL4YttHENPa3?=
 =?us-ascii?Q?MufH3b5ECYSFOfaZn1lssgAlN0ZKYzSqJb3DFLASIm6SbrqIh+g3sVOM45B4?=
 =?us-ascii?Q?4oW6VQC047XvpRPaANV60SNjNv0TbFcFWKLS9SrKVSm7tqFzlY236Lvq+tlG?=
 =?us-ascii?Q?77CSonltnZwyRaFq/ZdWIvLMgZln6fjBeg9+EhRmdzrmuWJzYFWt3wGg1PWI?=
 =?us-ascii?Q?4wuR/t8sODzplMUX3feMoRX8Ndoq/xbfCWu+RdzNz6KzA4HYqeP4DxjTX+1W?=
 =?us-ascii?Q?Hd1J1+72++56hzhCau8gXJDBfdyh2eGgqYH84KLe8ZImlHwIwQOUgJFqraAh?=
 =?us-ascii?Q?bsfDwnZzuhv1Cgkiaz3Lb4XW9f+7DF0sGuaEWEvK/XSlAmPOvv32cn2yw6br?=
 =?us-ascii?Q?XGF30doZR5r9t8PDUtpMvpl9Y5S1ZEFqS55R/qeX0NFJdycPmNlX4kJ4awGK?=
 =?us-ascii?Q?p22f5O2pDMDTH0MFxdNdsv0iMrDSUiSl8xr75sSO+YVZpbk9mY1rJcEXE99f?=
 =?us-ascii?Q?6nZ2qIlMark3L2p239XvlUCEkaxQmusjJrXbQq+997BqyST0L6rpsUAJYfGC?=
 =?us-ascii?Q?huLFNQSLo6Wj7/CWBVBf6Xc90nnsoVTOCZUGdqLs1rN3SJP/CX/CVABBHEbI?=
 =?us-ascii?Q?T4Yiu5aS9jmezOs1TxgbPNd2XOSuduAin/0zmFxxCPZKt931mNYr0Hqqjm3b?=
 =?us-ascii?Q?oBjnZSOl57MaIl9+c386klE7JF+8rm2jA9vc9jhRnWaKbNGZoAbz5lVI6/7G?=
 =?us-ascii?Q?mFYtOpZeKXVVwLWkbPWciMXyxzi+88hmWyGHhRlHqVXYLKhsZjD11GaQcNj4?=
 =?us-ascii?Q?zCu8+eFOVAw5ApHaGp+CIYH9zYt1pVTHCPGMrud1?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sRkISBCkJ1DEwXNoL54yUkhh/vn2TWFjulwoXuVk9eS35MQ7MzIhfMu7ABhJzJggd2BVa2vFI8SN2G7lxFPsqZYBrIGQp87XComJD4siJVnhqy6Gpp22GKzMe4/7LJDriitfHGUMcDhlaw1Va8gzxvmKkQs9ZKk0R8JM/G5VdTNfGA6TlPfoOVZ33VG4Om9IFsBBBgCJPQrvxQznIbA2otHhlut4ZRdcAQ0b6LZZoO7osRdI69dpDYH3MWM+PqaLr7h2djOBkrQB91ekJELvYxxJoMRLkRyB4OBXZKk1ZEdzXzb3iv3xXeQSpXT9OfYAS1BNQ5VE8Tapm+Jfo6PvHepOmgqzCVwo+eP0qD2gFE93diV/lgzng/qjBhBN8wXZup3wS71YGCcD1/gCOcO6ZIorySna+qCPam1+kXPGObgweQPZU5ERkCtgakCJyuJn3hGh/HKARwzF72PGUedziNrWauSRzmCIh+dGfWKiX1yWIqqsyvyD0Q805uQds1Ggj8s/cOPVMpy1pOX/F5Z5IX3Z2hsI0hldztjv8ErjNcnPk3YH3jjezz1YdVtjnV0u6G8Ee5GaoF0bvwJFJassL/mjGiiX2QLLXKGsqFG9ttw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac8a481b-7685-4d9f-a63c-08de28e66712
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 10:11:57.2576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8pyNey4j9ejYd6azhGT3qZfTk0FeszHB92Eeuug6qYydwZlTB6rMFhvZ1YXNboOddDY+fMG4+umxFfHfxpQqLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5835
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_03,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=835 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511210077
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX5wr+Orv2rH+J
 47SqgIHoN7iuYlvfZoY6KmG3C3J3wI0pURHbA7MRb6wVS4P3RGNreihR07/MKi97L8F8NfkRL8u
 zWnlYjxj445EVd2MdCM/AXUoLEZoOqeXgTIkRCmUKQ11f54cE59LIGuUzXCjfMrt7qHNlByE5KO
 EY6jgKHJX3Q6Q9HCdM+786Nyq6cqzunYsKvSi2Y2HlwQ5uMcDevHDVx6MdC1RVFR/x19dMcUF6Y
 pmOJDDjqSpuyQidhEQeS4w94N2/pKRY6Tlv9xw9pHfOuq8ln4Hjphkl0hgvs2Lq5nAxZrhEQrR2
 jYq6VuSsm8/eSlk+aeYsj2jvyHq6WvPvFgDwPw62TCJC3fpO3a+4iCzDgnVePwYW3F/WVtVdDxV
 SUFr7kvCP81NunRD7twWOeNBsRS27g==
X-Proofpoint-ORIG-GUID: nmsnZWGkFGd5qz4aALwiAs4FeUYlVXDO
X-Proofpoint-GUID: nmsnZWGkFGd5qz4aALwiAs4FeUYlVXDO
X-Authority-Analysis: v=2.4 cv=a+o9NESF c=1 sm=1 tr=0 ts=69203af1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=yPCof4ZbAAAA:8 a=aLw94ItjdiY3oz9hLYsA:9 a=CjuIK1q_8ugA:10
 a=ZXulRonScM0A:10
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 394254000E
X-Stat-Signature: 6utj8a7esaw9ohesrwrfdafmqq7zkcjh
X-HE-Tag: 1763719935-980297
X-HE-Meta: U2FsdGVkX18SFzLeYcT+hBx96d+lVUu2M64d5QBfeTuyy1FxWdWXJKpOCdPIyboJfOC+pO/yki51s2iH3+bPkbD6ATt8LQ3g/YCGekd2A+IO/WYIkVK2uICosb+eBrlTo4u4Qqil3ZDGzZV4JkOPGh0/sOci9r05ps5cKi9M5/pAENWhkQKdUJGZobtLSySg/6JspxFkM4Dyk5P8z7HuEUmezZ9uQprxxYcL3rdd3u0f5K/mKGJpgs/yoXlMGikLFL8jVp83MMNyIBNPEirtNvAPgfHmStUUL42bgMESmCkzGRORsshebjSI710+nWQw4Vlfn7qvCv+s7QeqSVj61zxaXpOQnPbfagS8VybWRXzUIJ4DDcJ5TpfNO44eCBp/CYa/NXALAxIt67mfQ0masiD8qox6/pFfhHZ/ii0CqGO/SAlch4kbmLlE/xoEcP/+C9CFzIWmx+LrdIFFiBhhcAR2sEtWulEVS5slyUmKcAWbP2y3fOSm7mv5tjoHJaNvHi0ijpbe6ncu04alQzo6ER/j2JvudfrEJuRxTJ20ZZyZbfXemgPkyQXfZqpGcmc4xtO3+D6MvspL1qUdszer4rKiU6BY438944DN2H6mimAKTAP5Rrlv+R4mUCWe4GuznDvQ/nhV8iCo3eVeD0DGnRo/wH7pbURBv+ENUp/1Wga4ftCuaNEpYGav2b90LG6oTx9NymP3nA2NYqnohZ7J6zTYV2n9VXC9sXMtqqFBi6LM5tvjKyfUCFiaq8sRT+SDUjzpNKTiC3i7NWJB0xQ6l891qVlL6Cg7LyoBpQVc+rnJLKZaOhYgio8NDQnZuZ1gWvLa5sQWqyhJGLjjlHb1Du+TC6xHUw59EM4Sw99OS1POd5HvWvof04kQvzYqKy+uykvsAY69VKFemjC1J5EhQFQjM+83wdk/T/HRNSe0ztxH5ZH3tkDeIUnnk943BZiK0hMdZBAUCKmco4HqjBp
 oyJN7tQ2
 fDhz9TxqdxGffD+OXJlNtCyRN0ZRgODK8HskLYvbykZikhm+Nm6GYA7z10buqr1j1VmjToAzAQjFx6DweMXSXF//xms4XPU4OuxDyy/6I+Au+9xoUokuSAMVT64hoyjhwPK3/x6Ik7usLcf/bAwp31eM4QRAMoCPrkRiHyTTOXo2DYd32luoYJ4IDPe43SsoBUYd7xxligw6pG7LNSS4Tt8vfiC1zk0MiAMiMIGh7RyMV4Y6Ohk8cCtyk3azsY7tDnH5gskyBd5wPhsDa3goJ2fL6NgVvFEtT1FKDJ/W/9mEIAOTLZWFXupRxQ6hdqVsSnXF8wvzSNgtQNCpmJyftSYj4BdCq2Js6OsbTRGtF6fZIHw5BV4XBsD8A0i9ClYWkk+nHOGVDrUYDisDNzNo0q9bEMnKWudX0se/GpQELzvQR4EcaSctg9zDVoNymj9by2H+pRKGc0lMqSaYE6MWbhRkKjq6X0Pgrkq8kFUFwoK/2rmV8XHKD5ilvTl51fDl4dg50klEsC+We0XoZOGJirFOrP7x/RKdKosflq8vrPbYUrJwJv7ecOUr0YngL9kCSuR1Bd6LQ5qvMCFv8YNgDDI8BTtkDKl6sQiILodCTRAoAur7fBULuVpwyuBqcWGABa1lwCVwp8zd/KaASAZ2Vu5v7vb0AyocGLjowRgl5FD81gxaSCOxr3v7UIIsZxvn/yxX/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 09:58:35PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> To reslove the dying memcg issue, we need to reparent LRU folios of child
> memcg to its parent memcg. For traditional LRU list, each lruvec of every
> memcg comprises four LRU lists. Due to the symmetry of the LRU lists, it
> is feasible to transfer the LRU lists from a memcg to its parent memcg
> during the reparenting process.
> 
> This commit implements the specific function, which will be used during
> the reparenting process.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

I tried my best to find flaws or pathological cases affecting
the memory manager, but I couldn't spot anything, so:

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

