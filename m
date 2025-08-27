Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D571BCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3F08E0140; Wed, 27 Aug 2025 07:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153948E0105; Wed, 27 Aug 2025 07:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F008E0140; Wed, 27 Aug 2025 07:38:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5F808E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:38:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAF121DE27F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:38:12 +0000 (UTC)
X-FDA: 83822338824.21.22B0D84
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3CA98140009
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:38:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OMshNvKG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YwA5IHQU;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf09.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756294689; a=rsa-sha256;
	cv=pass;
	b=eILd2BOnGqZ6+0f7+SgPm6aXxySeB4PjBmoz4aHp+RENZSaO/FhDOUewZ+eM6UL3ZMflgp
	7tOIz4UCK2F5XjdvM9bcF1lFpI3CLPPHW0onm0slnRT7Mavt1e8y9CPdZ7SqHDaTxgABuk
	4dRxzkYrVG91LuOPNL6wOu/IBmRMcFI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OMshNvKG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YwA5IHQU;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf09.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756294689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=74Z15Qef9N/CgvDXTXkQehvw8tdgRlfu+PwobYuDG3I=;
	b=jGwv6u2T+1fJ8nLFu35lsXlzL4aM3K6wSkP5Qb3lL8C9NZcP7QJBENEMfo3H3hW906EwDy
	gYIHchErVDvymq7np72zm7cu77AtKsMJ5Y7Fpcv3zdbpRHBBJmhVWvWXdfnP/0cSeZwbdo
	YZx4Jxc+0Ssw1cyCMUCKVJp2YDtYYT4=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57R7tucT001210;
	Wed, 27 Aug 2025 11:38:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=74Z15Qef9N/CgvDXTXkQehvw8tdgRlfu+PwobYuDG3I=; b=
	OMshNvKG2uZ9bP1UjK6XK7SuJx4fyFZm3Id665ChXruMxgV4jFIFq5b5r0sfBMd1
	TtzCIx4qNjLhCgnCvUn/mh1qFZUIlHJRhlOWNFPSudHElGal6Vg3MP9TZD7mvIPb
	d2zG10OBKRuGIoGB8bt074DvxksZxG/SpgKMhY5dbQvcCGGDgAYVOBJBnrrFhoTm
	XGO8kS4ltoqYeWfgEp2j4q9OR8q0o4sXWGF7tHujZU8Vpe9rB8UosgI/03TjwweZ
	HB4FqcXLSsbdFIsad6QOB0wG3wiErUOF1s8AekF4tPpvbQiKmA4a+C7rqui6B8bY
	vTfZB2nmKDY66hAPetJLwQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e26b4t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 11:38:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RBGBND005004;
	Wed, 27 Aug 2025 11:38:01 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8au210-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 11:38:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FCosegmBUo3UirifqrNsndgyNJu0NejSrUzVHSNV7V+hPa3jLCAOiU45mJLI8hp8HLEmJkWIm6hnfbwD+S6lrQK/aHhIVT7f5PwQ045aGZvhIwkY5nD1dtu1sASF11Vs4eXpYOTJ8MpU6BL1fldW8iAk/XE1BC9QHfxzxgvlKHr4BXni2AN8+166I+MhVIYjvPtLhRfw64DJjW+QO2BNpaaM4r18CDxy3gzvP+eD4BV1R3idzQwVXxpFk5JBfUwgJ7Bs7/GhutUDdJoyoKOO+aG5cqlUPWiakP7QGDRYC6bZLm/FFxzuaXEvtSFVWFpoGXGNNzN4cD0KdP1Za7TL4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=74Z15Qef9N/CgvDXTXkQehvw8tdgRlfu+PwobYuDG3I=;
 b=wYNuIkZulTvQvw+5RywrZurCC9+RUJUB9druBLG1/BZATuQQv6t89t1b2NMkmyzbqsKa0wZEiaLhxEnAp5U9GCPxLpGqF7Z57fBmJ8k3BZZ1lKhlRjmiC4w88HLhWUjdl+LS0IQJfV6zOnXYyZhoYVG8cI85gpOf3fLRIcP2PMJZgcCWruZHTZe6NqcMLI8EB7Bd/ntiNvc89cHRDuWo+Z9vtsXfMf3OK1rXFW6/E7KssyAoXEbwSVSZ7xNRNShjAsmiDI2JJnP5jEw2xY9btVTk9vrvH7IBe7gU+WOyYYF7kHOVQX1rT1UOIU6s1mnVO9HOI1OVOAOqOeoi6t6K4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74Z15Qef9N/CgvDXTXkQehvw8tdgRlfu+PwobYuDG3I=;
 b=YwA5IHQUvv7XykfN5MwfEqUppSp33JTVXjTBGhHdDC11o91uw0Tqf8k2sX2lrDxFLjEQziWbVJBAEsady9pXCGoqmdvy4PWknXPkWHpH9mu0rvzwHLg+D7pzp9DQesIbSRpEJwNW8tff+a1tUH9LbJ7oX9Y8iUKECa8IAl9RMqw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB6077.namprd10.prod.outlook.com (2603:10b6:8:cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 11:37:52 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9073.010; Wed, 27 Aug 2025
 11:37:52 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: akpm@linux-foundation.org, vbabka@suse.cz
Cc: andreyknvl@gmail.com, cl@linux.com, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, harry.yoo@oracle.com
Subject: [RFC V2 PATCH 3/5] mm/slab: use stride to access slabobj_ext
Date: Wed, 27 Aug 2025 20:37:16 +0900
Message-ID: <20250827113726.707801-4-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250827113726.707801-1-harry.yoo@oracle.com>
References: <20250827113726.707801-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0110.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: e36b7876-9250-43a9-fe48-08dde55e2822
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xGzve9Mi7oJHVjAyvVduiNgTRhnfPio7U4GfT+bat/B+ZtU5Jsf3bc5PTYKR?=
 =?us-ascii?Q?Zg0XCb7IwoDgaP6k8Zz3xwrDK1VZ+Xu3DuFq1k5yEUtD4LoS/7fssU17elQD?=
 =?us-ascii?Q?Iyhd8LUKPgDd8yIT+qclDoCrNj2TBLfRQhkX2r6q2kSqtYRyKFV+NukKGwmV?=
 =?us-ascii?Q?GiFlgzny714eAhc0J3KY7XhOIB6OfnZ9MsRnHnGE2yVLgGnHLtLBrnV7YETx?=
 =?us-ascii?Q?1/ZzM+bqnnwbBm0R4J3C74d46R4Lu7QiF8QnawdHXNuPP1I8YzJFesMXU7CX?=
 =?us-ascii?Q?NTy16FUOHr4zyCfCMLbcIvXy/mtb72ep3MU9C6OpZ/HRamS0y8CdhTcPGqjC?=
 =?us-ascii?Q?Q6s9YmB8Pf7uXhVsFIAu6llUAJfvySHfSLm/QoDsufyZx0qq3EM+ffLweI8d?=
 =?us-ascii?Q?kXK+2emx60/tuVPYb1JJj0bSn7f+FY/9bfOGVzIBizIUsfNSqtshhXGKf9Fn?=
 =?us-ascii?Q?YKchbs+zQIBRCb17+6CDldh1v662ea+fwqAomzK4dlsAQDhoGQaNyyWLnHNH?=
 =?us-ascii?Q?e61sA8sr3cbVAhhyFiKv2RWCpnjaLqI/s7miTs+zgGy9sc5+RTebgTgdl71d?=
 =?us-ascii?Q?SoGBgY/T2d6Z5XOgRaOb7sMNjs1f3vaJuwkcKpxdxQNNl9geLHHG87YSgXG5?=
 =?us-ascii?Q?hT0Xn4Uy2ynyUJqIGWayO87iXDqOoaQKo0yfp+YyzxDQAgrgEYK+5d6PLSqr?=
 =?us-ascii?Q?hlYA3g8ztEOTWPqAUv7j/j8xACsLwMb5KHAFSxhjGkIyZ5bNY6TpFy8d4ezV?=
 =?us-ascii?Q?Ixo4X8zAsVDCo7SEkXMOU606VMVSMzyX7LDed4Z7MnoDZJTQ2tlIWpbh96v7?=
 =?us-ascii?Q?WQIxA13jn2gSBYKwWcRnYg/DOwqKq7RfKHHiKNrlh7zVGMDY+En8C2jw9Hsw?=
 =?us-ascii?Q?LjAkcRk0WC7DrpPBdLIDfEUUiHLFFioIbGS0oQNO/QlqS6wm7KQBFjOztwZS?=
 =?us-ascii?Q?NgtnByXhsgnOjn3XDvI5I/S8HPQb6pLhyE7SiYjUMAHNK3J8NIFhHfo7i6f+?=
 =?us-ascii?Q?fRpPuhIPpVDxGljIN2z9aM1upQBP8rZ/x/tYtktn0RDMXAhsBAcPLyMJ0rjK?=
 =?us-ascii?Q?koorijp83yqhBlkIby9Zre1W/ZklTUCPr6S4jUdfy/KJERMzlkydkX0j9M6v?=
 =?us-ascii?Q?oPmjviUwteMGsDr2VZcup7FTLa5FK9pol/4ncTEk+jE/aKvzPiunalY+idWK?=
 =?us-ascii?Q?rqeGeCsjcgoiaisuDp5upt0ge5+OWIl5ake52r6o0Ng0JyMtd4ahBlDQN9Pv?=
 =?us-ascii?Q?1eHE5vK0DsozhhYlJIXy3dZvixKulpjx4MnhzJnCgTvBbnxz4R3wA+tGyXu3?=
 =?us-ascii?Q?ADews2JHuUedoTs9z4CVJ4DgCT43dNSSZosRVxeFU4jz7K0c/v7zSpxht2j5?=
 =?us-ascii?Q?s3MC5DW2h8hsuMNNwX3hn8kADxWdoC0ZVoZi1vefiyhRep5J9THEoHtOymeQ?=
 =?us-ascii?Q?odal9qOi36k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZVjG7RQMM3L+DeZveK4PwpLWtADxcf7U3mW7l89zEgqyVBRJh9hOLlw55d6j?=
 =?us-ascii?Q?ZEfeEW1PLtW0IP70ZDSvCEI/D5Q2s7GZFk3NdHOr/pzKmDAeYBEHieHmacFT?=
 =?us-ascii?Q?VRdprej0Sn/sAZVy5Cm/pnotMGHnXXtc0pOzg7ygmJcNuRmDBvk6TidPSMFM?=
 =?us-ascii?Q?EebxlIGvM9RswY+4h/RMd9ZEcKgYNIyWAV4lNwWNGeMhLjw0yDbj1Xe6dtN2?=
 =?us-ascii?Q?1XjwCDziA0ic5Zcb9uXxSE93Ybhd1aggjbgSVL5q9FQ3hr9gu6t34SXzaj6D?=
 =?us-ascii?Q?22FkQT3ohzkxdsjxKUqok4/FKeRmR7rGFes4OAJxIOMUjm9dwyuf0zSQV4Rf?=
 =?us-ascii?Q?q9FXTPM0PNccyBIPKhW1okYfmaMYdTBDJ2GmPmeI85TXhIixAr4cMYNjbc5n?=
 =?us-ascii?Q?ti/oJi8TYRmmzv43rSobpQ0wCEEs6WtOMsTTK/+edeI3MHYVfr9Np0lvlp0F?=
 =?us-ascii?Q?z0w6v/REDaIxAzA3mjDnfC+POs47YvaMiDra8yfJ8bhHv4yz2a3jweN4G7Uf?=
 =?us-ascii?Q?RliTYZIbZXNswhZZsxP69iakCMf/vzYCUXDWsJ4nJybRSLSxpFC5gm8xXqo+?=
 =?us-ascii?Q?1zdaijao0mzTAzD/m+WXIEE9Urrfl91g/X1BJTBcPMKYq7w2fcwpBhIBgpXT?=
 =?us-ascii?Q?LIs97bc+G/zaJhR8NUKk7OGGyW72c6gr838X1+U+c+SAaybmH2Tyif0ezKD7?=
 =?us-ascii?Q?ovMRdDo+X8EZR0hRkTlS8rXWBvBcFSFXEnETw2Zc7wI+UlrN0XbLTWZD9KPI?=
 =?us-ascii?Q?jl43b/eWpHAaG6rkfv3yizb8wP0vBpeLjDnRkOSVxMmwFUrAAEtTr9YVRW58?=
 =?us-ascii?Q?ePy2tKIdNSuIDgRmEGv5lUkoCl0iJJa52Vs8Qe7maEOfKTUHnd9vQLxatFF8?=
 =?us-ascii?Q?kaUcfSgQFEDyomllyf2ddy1xllG5N61Cf1gcQg/l5SXxsmSr5cmELQaNXSbs?=
 =?us-ascii?Q?zyx9oDcmOO6noIiFG7nllRIl+XG3TtC8F50gT/f7cF+oeMtwL6U3QC/rebUn?=
 =?us-ascii?Q?CrIyXGi8Ax+whLz1a7qy6ogXYL5XCmBGXpp9kAes+xikAoqnaT56e46jcc4A?=
 =?us-ascii?Q?Pv4m6PtssddAped0jEhE3HAf37pnT3g0P7JeJsuHY7KcgnSte0KYPfg1m7VM?=
 =?us-ascii?Q?4dDN8sQ++J4Cxw8tlj5rXvnR1CRgWg4r8WtHjFnw8xq8aXqY69uKS3bwAX57?=
 =?us-ascii?Q?I4IBQ8zi+ghJi4TVfhUE+YWWpz4WSNYfKle1U+XIunKyYIRM5cxkX4PwAzv+?=
 =?us-ascii?Q?ba+STwbTsyWJFIEbLFWv8HFsOA0pPmIDwZ+UkJUAx+Kde2HA9VuPKOGCOdSj?=
 =?us-ascii?Q?LXxtIyDnp0rpV0FzQIsc28PXbd2tDAcg6wybuEblo8RrxfCw0eRTM7jcUdg+?=
 =?us-ascii?Q?DHyh4fu6iSKQunpMgNWObBk85GmYadbw6fxrIh4mDmSw+SKFHN0/KZAFtyZB?=
 =?us-ascii?Q?kswZS8FQFHO+OZFsc4CBWTzBdsUtnj0vDF2n7Dtl11EH/FzsD0bvyiMZOcf3?=
 =?us-ascii?Q?ST1QOWYLUNG9ajEJAl0cEiYF3AbivBE1eC438e7B+yxqbFIOvEK7exw1BGuF?=
 =?us-ascii?Q?v7JgWJyg8k0XlBqwJE/WEJrwl8aBUX98wtNi5oRl?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wW+hqI00g/QOQTmmQo/QVccURzF0yj0jmpGu5nRBsEwbVy/++cZEXom5jld//WXr7U+a5QMAuXu7Ek0JguH2tR9RanDQTY7hy4KWXuCXv4n95bQSkwqZb0CmFumVl8JQGtt7r+wBHir2OoR/kFQZ/3zJD7KX2p4tQkZmPtUCsfSC/2SgxO88/7fBsJnwvwXx2gVdsxb/U07YrcQ0TwJvMjlZl15IREAw0nLJ2rlaDNNHu951C81EjadIGjI5R2wW7/otElMlRBN2hAWvuJhTZ2+HMg6qRPDsfcuu3r8w6CKYxkU8dWa7mMifl3OGH78zd1/vk4Y1EbwkDmU76+AXacMrfec3fw2P+tHH2zgb/UKC804k/51Ma1Q0Fe48FIUWsxhEbheiZJDnrkhN+crUDh90hpHe0Bi98eoUG8/OQHKMnWeUnr0yMKecWLf7BEkwDK85SMtGAdCUy7GfLpTH6VAo4hoYaCcEZTzKMU3DbgVg5FTzl73rsZutLdpq+ypT3h/H3Hy9U5dK5J/Qv1gVL/b9Lym1+xU5K6uTp0A05jt198ZFVvNwzaV76JyMsn+RIdz3U3QyuYOtvgqKlmthng1FJip5Se9bi5TfS3sOnnY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e36b7876-9250-43a9-fe48-08dde55e2822
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 11:37:52.1521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UolQECT0jYLEapNrIVHL4Q1XJ1Gn9JHAfEGqv2hb1dKVBW7sZ/orAaVmkJYi95xtq3MxpyMjVmlfsa/VimLp2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508270098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfXwiToow3qXvpk
 47v3lshnBSo6OCvakSS3N72dfOWZLEKdStbhClR4Ul6IdciZ9sjOOossl8sazMcb+Ej474YV26P
 yDr4EgCHWNVw5O5m0Zs9rDJujYmGWacEBajSp2R3cEhV5CclBYJUonSAXfjWShSHOQ2Qa2V8GLR
 HAJFLcs1MWCwYlDK5QZrXuUcLDpN8VoCvchvTbOn1bdhx2NUocFIJ+8xsJnSPMVozYtNuxuqx0J
 rvY900woZ/zvGIGWetoxWKHJxMDIOTLc3Mi0pX2kk18ZKA8Fb8O1u6KQ8JEeoRV8/pdViAo0pPu
 2gu6Yy8SN4jJzpzXti9//XeALTAYwmrHLbFY3/mjkD4fKGO6NiOcVUYypIApFZYV8d2V51y42xJ
 aDiZhCEY/6WGRAjNmlqgFR1mR8tX2A==
X-Proofpoint-ORIG-GUID: RAeeStMK3CrXrPfQudfkVDSnekKyxI0v
X-Proofpoint-GUID: RAeeStMK3CrXrPfQudfkVDSnekKyxI0v
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68aeee1a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=fT7-_g4GsmZmVBC6V5gA:9 cc=ntf
 awl=host:12068
X-Rspamd-Queue-Id: 3CA98140009
X-Stat-Signature: odexsojbn8w5kwqgwzgfpfxzdpu1ffpd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756294689-697738
X-HE-Meta: U2FsdGVkX18bKFfoTy/SmrWu8EdB/jhwfDrKduRpLh181WS0wC0eRX3Kc3KablJ+sXQ6QXItpvGOMyzykj/ZWchPwn067V0AfjKZqkLQsbZ70zJd994M9Tl2HewkduYdIZ2qkoxdhvDW6Mlw+bBollfh3gax/DJQgBfrCeVVM+l5wkWRqn0JR8UT9tojxVmpfyfzO29DN9MlJufO9yoOdBo7DYcj+/qpSoeLirgTkHXCtWxb4bIN+PCnMsTRyY+DBN6cBVLtMolI8auu3YcSq+rR4BZIOcwTnRs5ZzwXlu3Le6BsZgxEBu/tuF8Qw31/8nT1aFHaxweMGkVzC4v8Bi4dHeksPlnTMCdGk/UorxL1sAuFfuq/X0u/Z+ztfASgRiliAZRxBA0dfr11hqTuczJKEGazYxLSaWNcKe/0TozWZyqrRLu8LNJVbsH6sdMO5scZssaZ0cO5RZ5tlj0apXLqdI6eYkaqfVjxaunPsLho5D/9RE56Ig29yFBOjgFE7TduNqfim03pZAThQ8qyi887H5qsFbPOb225H6I8cibNjsJCzMjT4+aKbdihkMBqkneg+hlXDa/O8upNHJuhGx3PRN9C3n2buCiCgNgwlzmJ2qoed77/Jn25UuttCo0iJBDU0t3Jy3wcmq369n90o3JlCiEmxTXhaayaMvEPvhWaVDKhngLh8E8jVLZROaK1tOLPdNAU1aabONPswoBoLRBgdTg8TohYt0Fe+IYhpdlQwi0xJt6adXKHXsykna8saBaoxUMaKho5une/9HR8M7w3+aUMlDf65Yy9BH0XPkiqODTBFl3TSWVa01l4JzheK+fRIK++HWly6TY1CfmTFnemgdWuduylGq+rOAZSm9aenJi2GzYIuiH27YBUgWqR06HlJHvGtHNeEX36Tr4Vm5QYR72QFV7LQ/DONImL28gZnSvCkmRaU43F6XNkuyfKAKZqv3usQQ2Lmt+FBEY
 zMA4cwwV
 HYjNFczUBv0TlyqqV4jWczCtvn2tNBWH3ea84VCTFyV+vwFgp01PGcMY0iOmDupNrw8T8JpFSuRoxpooJeKccmfvUB0rqCrOAQqcKwKaxo6phq5iKlNhqE9vDcUukeBN9GvS3jZx8fG7Qd2z6OCiXIKQXF8m/uA+rMafS5fCzUaHXd9B0Sk9VwMtgKnVMY2jYrCxwz7yjWf5wK6+bSzDP3BGEG5xvUZzA/i4/DM+iSo9XTD+n5FwGtfWONDyrL22SdzOKKOxDBwbauicN2+NHzbaeTu7XE6LD69wGvidZjq9ezDz0QABYJNGGtkBp+TuWbIUguk5+zbZ3swKjnxIVNQWixadJt1ZGN49nFs3Ghsji0ogm6kzszBHMciOGxbdQ1+Ld03wQF0NbnGFn5nU6KT+Yjz9AcIFrzfEhfhW/AeSOuxlChU8rOgHe33hATl3WaGFC8QOD2haK2yGufcv0RIMb2idc3imFkgaMDQadKvkb14BtIirWSuZo/1o41bYd4qu4DqWaQBIJfy4/cj+HgPG3UWY47lT0uaU1uRFfHunJlJCKxIRPFPdc22p6PXw1iJ/y+Ga+6uaNdHEQ2vRMmMfh/7LDc5lvU8CEoxHVwMH4S/mGhMECdaV7mtzIV1ZGZ4phmT/K4KAjHDJL+qgKd/IgF0tqS2DRmoSixkBDmXefZHM7oct1ADUSz8POLZq+CtgKK61mTipgi1EooNvOuUAWsdYbSFeaS5SfnD91e0Y4Zip8AsQm92NZSSyPQG9aeX2rCDw2MZ8kdsTltU8FnrKHBDZI6xaqEBQRmmmNNxKjOCutszwkLOk35/AYubzIWy/Gg/imKSxU9brNiSLhTlkTDMM6eyLNBJga9RRN9YJ28/1fA6O01guE4Zem2LMwj+WR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use a configurable stride value when accessing slab object extension
metadata instead of assuming a fixed sizeof(struct slabobj_ext).
Store stride value in the lower 16 bits of struct slab.__page_type.

This allows for flexibility in cases where the extension is embedded
within slab objects.

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slab.h | 18 ++++++++++++++----
 mm/slub.c |  2 ++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 4eb63360fdb5..3bded6bd0152 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -540,6 +540,15 @@ static inline unsigned long slab_obj_exts(struct slab *slab)
 	return obj_exts & ~OBJEXTS_FLAGS_MASK;
 }
 
+static inline void slab_set_stride(struct slab *slab, unsigned int stride)
+{
+	slab->__page_type |= stride;
+}
+static inline unsigned int slab_get_stride(struct slab *slab)
+{
+	return slab->__page_type & USHRT_MAX;
+}
+
 /*
  * slab_obj_ext - get the pointer to the slab object extension metadata
  * associated with an object in a slab.
@@ -553,13 +562,10 @@ static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
 					       unsigned long obj_exts,
 					       unsigned int index)
 {
-	struct slabobj_ext *obj_ext;
-
 	VM_WARN_ON_ONCE(!slab_obj_exts(slab));
 	VM_WARN_ON_ONCE(obj_exts != slab_obj_exts(slab));
 
-	obj_ext = (struct slabobj_ext *)obj_exts;
-	return &obj_ext[index];
+	return (struct slabobj_ext *)(obj_exts + slab_get_stride(slab) * index);
 }
 
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
@@ -578,6 +584,10 @@ static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
 	return NULL;
 }
 
+static inline void slab_set_stride(struct slab *slab, unsigned int stride) { }
+static inline unsigned int slab_get_stride(struct slab *slab) { return 0; }
+
+
 #endif /* CONFIG_SLAB_OBJ_EXT */
 
 static inline enum node_stat_item cache_vmstat_idx(struct kmem_cache *s)
diff --git a/mm/slub.c b/mm/slub.c
index 33e2692ca618..b80bf3a24ab9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2107,6 +2107,8 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 #endif
 	old_exts = READ_ONCE(slab->obj_exts);
 	handle_failed_objexts_alloc(old_exts, vec, objects);
+	slab_set_stride(slab, sizeof(struct slabobj_ext));
+
 	if (new_slab) {
 		/*
 		 * If the slab is brand new and nobody can yet access its
-- 
2.43.0


