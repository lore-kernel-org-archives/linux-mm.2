Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E837ECFD31C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 07:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AB216B0029; Mon, 24 Nov 2025 02:03:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B4B6B002B; Mon, 24 Nov 2025 02:03:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E136B002C; Mon, 24 Nov 2025 02:03:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D94D26B0029
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 02:03:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E896140268
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:03:10 +0000 (UTC)
X-FDA: 84144608940.21.E198569
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8088F4000C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:03:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VRBssGFM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U8GPSwqs;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763967786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMiEGeO4An1Im7RW5RLPOIv7zOYiow52okc8V3wmBxo=;
	b=MBfMjyC/sydxTyvHoPnMQ7/A1ln33eExO3/2b+8blg6d20LO7TiX/aSVAzlpYR74V1gKBg
	uEpgwxbbYTE0kFZOcoWeY1XZ1atTX3OYZw+yVunVPoqM2dV+f387P1JGMFxbobvtafP0cD
	/k9VxLYD7Y0iMCJqSojbSHQfvm5o4JM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763967786; a=rsa-sha256;
	cv=pass;
	b=jslFKcVnW/QmHS90xcDuU85moMEiP/khP2DESKPG9eQaoy9fhXxxK+FBmGG+KaSQnOrrcm
	Ba3queoijiMWm6Op812HdYU6TV/ZVES7Mzy65x+Br2RG+LvOdmP41h86PJO+edCkGGYHi1
	69Ym/4ck6W4XfVP8FjgqotfrH6HBsWA=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VRBssGFM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U8GPSwqs;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ANMcUJ33943954;
	Mon, 24 Nov 2025 07:02:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xMiEGeO4An1Im7RW5R
	LPOIv7zOYiow52okc8V3wmBxo=; b=VRBssGFMN/107IRDvzoDzf81vaNuQNuL7T
	UJK4xatdOpLIx7tai6CtmTwXyV2HL+jW179Jji9/xOuJVru2PlJRLo+lClz4mXc3
	Glvc4YiJ2qRl73FOXo8q5ddi8jlkfe0s4BeaKOe5ufCEaaBc0JUEHELI/EPFE+l4
	SnOMduNBAp/F02GUEtgqmcdFhjClKHUoavZrz4NsQQh2NU8NSecsm0UMOwohlGSO
	LFsZk/sy3piVsQ9F5vS1VaJhvV6CVHMatMjgot3HbsQUr0tm138C4Ylaz4cny0YR
	tYU8DEIA9UGL92Z+d++HkblgOGhJZsnsrOgUblGgW9IoShcaLjig==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7yc9ge0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 07:02:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO5j7Fk022448;
	Mon, 24 Nov 2025 07:02:47 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012061.outbound.protection.outlook.com [40.107.200.61])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mhsevt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 07:02:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SrCCfbnHR2DRUl+uq8UFogtdP2bEt2kdMmBcBTgGQe1IIfj3p6kpYbN1Y/DvUpBbzkrJeuCMczoRU61sbKrRO/EJOInCbVDjZatS021k1l96V8gPeyuLqwXVDXdrsLYRcKGjLf7zAjv5LUAqDNL7FNqp/mCSDr72He6V3Zmc7Frrf27PlHZwq4dxWMXndlGTUC4OtdKeJ9NeHyJtxu8Ir+xmAFi+yllA0aN9ekzqpGL7uzedC2Ao/AmJI8A73tR2NBejos7LK5b4n7SXIiHkQ0mvbKyStVGursV2g7kqDo3RYEwW60o9eo8S2K6gW6TY3FVcnUY1UGvB6yKnzRlmcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xMiEGeO4An1Im7RW5RLPOIv7zOYiow52okc8V3wmBxo=;
 b=czz00HB3lJuWRMweWmCGb7c28u/n4/5e0ElR6aOyVMJSg1c9UrGM1PD6ytLuF2CZ9jVgavGMvdGClXh90kdEmiwEUdZIsBsps1EvV7wcaCZEtxpAayzJNeEGtkDVmuYdc9bNre32MTLZfyk/J9BPfzrdSFsJQCgRPHCTmSbP0vybOoQqnE8Z4K8SWY9uox0PM62asEO6mHxRwPkCGbpJ8yAouRXh7T0GP6BsyoHcBh3iysaG4oOW+Ie39zogHWwe3Yesxrd0NyQfAs0fKUiww9kWAzUcw2MJ1QoiyoVJqai267f7pndE1iW5c9a8n1Dhr/sQJXm4RAR0WEAdk3LhHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMiEGeO4An1Im7RW5RLPOIv7zOYiow52okc8V3wmBxo=;
 b=U8GPSwqs40sl1apct5GPQdbEby4NynyILm8eXLUfH+oEI0fSaZW7HE58PY6Un0j9uASG5T1LJZJ3O78deIIKZGOqWnkBXZ1Oc6U8iJ6j3zZL3RJGXWfzVsOVxuu/22DQjWt6G7jRsXEqYNr5u4Vyxd4tgwBOIKKQvGeQphmkL9Q=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4629.namprd10.prod.outlook.com (2603:10b6:510:31::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.15; Mon, 24 Nov
 2025 07:02:42 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 07:02:42 +0000
Date: Mon, 24 Nov 2025 16:02:32 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        David Hildenbrand <david@redhat.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH v4 15/16] kasan: Remove references to folio in
 __kasan_mempool_poison_object()
Message-ID: <aSQDCCmqHAYtKkK8@hyeyoo>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-16-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113000932.1589073-16-willy@infradead.org>
X-ClientProxiedBy: SE2P216CA0010.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:117::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4629:EE_
X-MS-Office365-Filtering-Correlation-Id: b551589d-3bcc-48ae-516b-08de2b27762c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/c+B7PXoQq9hKFmxpAPqEPjnRG3MgfGgys8vGza1eooQzDGbKCxgTT+sOoOG?=
 =?us-ascii?Q?W5G46f8Qqdq0RyZ/FStVOIm4zFauGC4OGmre4kzWvR3YFl+0C6+ksCxb90aQ?=
 =?us-ascii?Q?+7v1GLaRGr6w/vckmUsq7dGUCN+55luH8uwj+tYW4sE6bVAO/aG1BiBZm1QQ?=
 =?us-ascii?Q?2HbGoozKbRUqU7oFNkw0Ux+Y/AYxNdOBcaX8cWKq9QpSusBLmWMdShIY7B5w?=
 =?us-ascii?Q?d5IK+5efiFZSNF/KBE6KUHlRlti1WGOM+1g2KBYBy8omlqBZ3QyrJfiUcOEx?=
 =?us-ascii?Q?84r2oEy3GUp7udOilH/r2Of0wzgBQZvsBVfpWLVQQpjTruaOduknGmzS8mWX?=
 =?us-ascii?Q?IkWvfttUiqO99UPeazKXm8O/4Pf0Zupvw4ZCgzWnh+CvZdu0TW/KaDL609vE?=
 =?us-ascii?Q?xuUu8pm/lBWB4WwJ3gT/ZFbK5T9HN8uQqbS4Ppfcpd6k+zvvDLuh+dRCeWfJ?=
 =?us-ascii?Q?n8l2YvPpUTjMqpPi8XgUVS1KWhWiEmDDTSsU+FXtcP1rYr7HgNmj49o2dULf?=
 =?us-ascii?Q?A0ivqhj9G2TJQTEbodAMG3bws4G9EGOgbFD8TbvC3NIdnKKKbWSbi5IvUpvx?=
 =?us-ascii?Q?xmR6szwiavBLxm7sFwykFOIXpm9KaytYP4itMZtGlclDznC8QY4RB5CGHfAn?=
 =?us-ascii?Q?aIr0zicU4FJh1diHsWWGL5OQjnH2b8myQvLddk5dAJ5L4jHJ8hMFu3jxHuck?=
 =?us-ascii?Q?JBla1wVKNRqCixlPrHw5ipjCGLlisdgwYZ8cBadKdjMyZlP3AExkA6LL0NhX?=
 =?us-ascii?Q?ztLnmrg30bwuXXuNJMEkt3NoQBP1qILwQxFZ74xBcrCNF0qe2erCxy7ODAiC?=
 =?us-ascii?Q?VbP7mjlqcC4mcA/rB3OfjlMVFDKuVjyYvGkfxOxbIIZhjAO0u8UPiYV+AAYO?=
 =?us-ascii?Q?ibmjm3+hu3yCGEYNRq1/e7lBiHUHhzG3n4sb0Oo8t6kOqi/aObv49PQr+NCM?=
 =?us-ascii?Q?p+BDgJuM6NeLrHhn+9X21lrfzgptvd5NCzDayxRpyRiIZIUkdS7xixEfM6/u?=
 =?us-ascii?Q?G0EJVEorjW4kWMhYRakqcQzrUFp28rDk1EKoySxGK81oZmia4EhUEhrmQcdC?=
 =?us-ascii?Q?iaEG5TFOkJAw3tniRjCnWufX/JYWissVxf9nwBflai3JoHra1IVIPNQNLPdA?=
 =?us-ascii?Q?PfgMV0eEV7v+1pDoy4B4Qusl9juazko80hoKCGh/dBo3v8Avhdc8onmIqMb2?=
 =?us-ascii?Q?esg5MB9YltOvOYkBvi1tJdL07uyFkwMkJ720Tai0OHqVXaU7E1Aq7ey2Cj6V?=
 =?us-ascii?Q?vDDGxCU1I5s/N+0MHc/v30wIQG4F/q3LE2F+iA98/ZxW+pSY7H51Qe5ndNCV?=
 =?us-ascii?Q?huJBXg/9SRzk9hSIFgCljbLHGpZ7QnxgVaePmyygCN1pEibwNO4Ua/+1AAMQ?=
 =?us-ascii?Q?HylDTIhDD6vjgDd/wTolPF9pXb+/3UrPwUYDGnqWZ4lgrt0O026NYHl6wM1R?=
 =?us-ascii?Q?Bct9yCU55x1soE73yO9GBijmfrV23qh8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZooFiwDSGBFNP4ZpJSluK2l2ar44kL+E8idKf06k9A5kFqSzGqggenLSI00n?=
 =?us-ascii?Q?H3RtQpkh3M+RdzpkonbcdsSaJJN41ziSNUIGQdKmDUQpMbvZp71xBInePeng?=
 =?us-ascii?Q?sstQH6YoCiBxSX27nmSK/3S8ONmJVpNXPcgXHRgJlEDuAq9zCmxhPkFmWwNj?=
 =?us-ascii?Q?QH+ECDvD/WxXdkuL1UzDxpsdTtJTVaBJYRNQb8yf75M+mHFEMyJhktQSxheN?=
 =?us-ascii?Q?/1PTjSvabfcEdOZm/A1ehETltOO9x3aA2BhKaOm93ngySTZBZD8+mfcHS5XG?=
 =?us-ascii?Q?utVMjnHD9yV1MWqgOD0bRHpXM2aFZCO0h7qITulxTG7LmXdfPpD5qnKl2s7A?=
 =?us-ascii?Q?pA7u0yyJcNTn+3K9qj0YP+4RrsprZdgroqKQLREhTtArhaJ2b5g6Ws4oHgMw?=
 =?us-ascii?Q?mOcVGfCgVf8uMKZiekjitObsLNx2v5DYYzG3tz19zj2RwcE48QDD7xRX4179?=
 =?us-ascii?Q?IRtOFdgug8mX9xmHv0UBVSF96mj2KTVth/4a9zp8kLUcI9XWQjJMhwE6CbKE?=
 =?us-ascii?Q?Ec+i8njaGpUfrZeICKZ0WO4CggIeOjjBMuov6d2PCjtMHNiSYP8efrHfgGYh?=
 =?us-ascii?Q?m3B+fiuKZxGS8felV89aqlcUW0I53EBq2F7MNl1JVcFDlhJ2hkT09+VMMDnN?=
 =?us-ascii?Q?oTQHLYwdDxKem2SY9WRuDpGr6TdXpdsSpozQn8yuLXWkhqmykx1Sa2f7xfaT?=
 =?us-ascii?Q?DkKlQCVQsdOvADOsWahacRA3AY9eRKkAtf7firQ0cf+XHijht4jVeFspcfIY?=
 =?us-ascii?Q?DhRtXjmOC011BdWS3eXXrAHBf6y7QXkm/IClrN4/Lc5gpi4B+yZNOJpRbkqF?=
 =?us-ascii?Q?RFDClX0ntHQus0SvfMQ0KL4RseSaSoQJ9nvwuij4L1o7cbeb+QGNk87vb1Bs?=
 =?us-ascii?Q?+doHhHinqFfLhKv2w1OGq88rjYQioiXkFGgNMq1fyiurV/2Do2hk5nUxw7qH?=
 =?us-ascii?Q?1IXkIFScZsvLOVSI7zmrSaXLJIQMgjV/AXqXstZ92wpKyirAqfb5y/ICvTyA?=
 =?us-ascii?Q?1UzpkFxqsUn1pzOK1oiYbn0ITcPYfWO2IWsemjQgKuGzHiK4PmbsIV4AuB1q?=
 =?us-ascii?Q?tOUZ7A+SWd8HxbegzXRvELvhgO9zgOZnCT4kG5+ODKEA8SMEdkAFCHeF/dzA?=
 =?us-ascii?Q?eIPgudVdMfHmbt5zf53+Vr6Qfi6tWCtdkkqMMMl2gDQie3ticn5sDfsK9wSg?=
 =?us-ascii?Q?oUMdHzkGMdsgWw3JEd6HDzvudhLX6ZPqbGluoa9c5zoYE2egHkJeiwa+bybc?=
 =?us-ascii?Q?wbMB/ImBH/e516cF0BHAT7AA2+0zPMK1Oye/amPBv1L/rdt9GR2bDYXLJqsh?=
 =?us-ascii?Q?PUxBUF9coWNIiHIGgrrO+DlRuxyLHJrtxVS0gqY0bqvDHYxzGxKLpZ82U3i4?=
 =?us-ascii?Q?I9Sactb7ILEBLasDpxHiO2iu+N34nxbAY7M9PxOlrXzmgD/OjgO+1jaqZhKD?=
 =?us-ascii?Q?VZtkAAs0xQI5JIp2kPLYbE2b7odCglG/+Kwclzp11ggkb6Zw/+HnpHtpJiMN?=
 =?us-ascii?Q?25QZRI9Rli9wbxscIAw8vm4shFDAmoNgX8Z8tt/pXOs4sPAj0koi1r+Y8IvI?=
 =?us-ascii?Q?lH8X518y3VQ2jomdgGRMLXrMhimLMEO68/LXxJM5?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EMV//hQ/o2ongXKyZrvN/4YInAEfI3+JkfR10mcGNxe/aBmQl4Q6TEU2qo0/te8+7+eOnSaddGrRLw30O9vyY8z7nDdoFNj5MeXV1cV++iZi9gALJFulrFc8h7q9x6hqUR5dISfrNjScs+/HE9FRaq+VYqXS1yeTmxDZOVHIfv4eBaAAI1DOoRQRrVm30myApjLB8Q23kjXdA83Fr1SxzVoBv7K12gt/iQqpvx8FG89lbXaWW40WYeXs4lu3NS2Z9pNHjDh/ITot19P+M1h1j22lnCMNGHE+bbsnIWUljfCEQyvRYdFoNx5EEeuOHfgyOL90XXtVYKaT+cB60J9+B2h6yMpkMBoxrX5U2qfXZFUOVJvQOTjuLj9eEbfVXCRq6VKb8kLmwYyWnHrGPqnWp+ua8YMDFysNMGXTPS92C7ST3TQ6lpLX6xDxFt/T7Nzn1Z+PeaW5kS7zXsvQbdBQoz/LtVmF8srUFMYWY6UYg04asDmOGwRfNOHtwF2U5YhXy0RZD3RLPlTNYeAO91MfGgoioQYw/0quQY6KjfkTyyT78jXP9/IwIeLH0SHW3buBze3mYnE/fGBc/KGBOEoSA3USdPHHaxr3tyWDnSgtSqI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b551589d-3bcc-48ae-516b-08de2b27762c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 07:02:42.2618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N8leEjPw3Qwblu3p5OKuUT9dlIWf/FWGJdLB+QpDmfL61+daem9t0om/Labyl7zidKl5Q6Q/V9f3APpHfL+MJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4629
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_03,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511240061
X-Proofpoint-GUID: kSv3HqwYgNnlhnXbHk952z3ai2zAuAsz
X-Proofpoint-ORIG-GUID: kSv3HqwYgNnlhnXbHk952z3ai2zAuAsz
X-Authority-Analysis: v=2.4 cv=RofI7SmK c=1 sm=1 tr=0 ts=69240318 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8
 a=7CQSdrXTAAAA:8 a=4RBUngkUAAAA:8 a=yPCof4ZbAAAA:8 a=kgNNjo2PNP_B8mUuU0UA:9
 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22 a=a-qgeE7W1pNrGK8U0ZQC:22
 a=_sbA2Q-Kp09kWB8D3iXc:22 cc=ntf awl=host:13642
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA2MSBTYWx0ZWRfX+lhVMTW9NXKL
 Ps7ySgA7j/vcilKlFy/hc1BeEqFJI0eklOM8XBItJX6IC6BsZakltQbc0aomvH6nqZgqsIq9EA/
 TXNfMpZeROUc4XpEnVmcbIJIqOcgGEbqeSJYZCxKjpuPRtUpmubk7E4XQGSnrDZlCTsfwUEeMRH
 lKxLGV1EBAFzLbL2zP4keCzc8eUwqu/3XymFQUL3oFtGcA1XBmSRXLtzigXr/Y2ld2rPKe/rnrO
 ZzG1dTFyF3cYauweBf3oAQSO+HW/uhF1QlXX8k7QOgzzTdcHewL6uErlc6S73v2E52CRPrgj0vS
 M6uGkvNYFxVuO7Iw2iJu4ZlcJxs7H3Ha5RNRtprGjO0R9GYWoI1fA/UWTkw9GCQ54Bn/I+3kR5O
 hr30pxWuEt9d4IQ7+fpESgbHxUghovu37dPJe4mU000RUrVffYk=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8088F4000C
X-Stat-Signature: ywheetii6o7fgnfq4d1ggfqj719aq7yp
X-Rspam-User: 
X-HE-Tag: 1763967786-440452
X-HE-Meta: U2FsdGVkX1/nQy2ot2ASnKx3gIRs1/91O6KEh4oEDxJDCd0YRemzNfCQxX87g7gA3vfFjh0qHhnCLFOTl/pUXb8di+sltEPSWEjGX5exLHW9tZJ6nr4qnJT14bkgGrkVlzexhhbpAH2M2pNJxOectqWWXs5IisEJKscZ8vBcbGrsXs24VffxFy45P22spe9NqG54wHgLCPLZeXt9wwmKzj/gUhlUVlGHwr1bMkjaojTBMhaVx4Gyq6pAcr5HypwfdjRxiakFPbIJdqHZXTiTQVBPQWrLoAWNFUKE2qY1nsVuEbIhNzaok96i7tuDfYihndtfInTupc6FJR4RbOPQt53R8c17doe40buN75jOODptdi6eToxVzbZTnibiVUGQ286LuTbnKAbjHhEFPeXZ8dT8wmFCHetJaF4oUDZBbotifdWj63gxBzBy4qLLXGiAnzlCZonno5FKRP6fcO3Uab5YrwYXsfHBoqLnrJtXzRYNaskx5rp+C/TtI/MDgGAuy3Rk/zJrECgiG0AZznF5eJrYBdw6YQ3U4AJHkQgg/P9ZKLMwCFcVezbIdJGb9rswPnzEceAc/NigWymnCn66hZH+foDdVY9QIYE/+dump/pjxELI9Hs7F8SS5xOhB3oXd0kLb8f0OO7CwclWkqyYKl7pi9dX7XBw7JmR24U47Ve4VtwE9rHca3qcBvEPPM2WypK27f3fOzoHFAshulsqq6gNMX/QRbGypSAACvkga4rMFI5xTXf3gxpyoiIU60v9cyFD5nqZF5sE7vcNnuY+/U5XCJ4nikwf8JQqJ5RrCYGbzc7c/YnvN1UFnEzK4WJJT8IFBc3xU45NDX84G3YP6M4TyL03C+NuCh8MeVILtFMj+NprA/QG1/1o9IRjiiCvtHkG+17qPtXM91F4W6lyQg3n5WvqHH6RI72VtpIfK3xOlgYYI50GhWdV677dsJedYDq1gA2JynK+Ge+KZdA
 m3DS0qTn
 UUV6J3sskEHfeRp/mmE+4ntEzmHmH71EHzNA83h7djACWd+bVCe3DPR0PLHYHHP3D3sYRmKKN7wbuy6ePyqCeLy0KD2YZk2Jl1v0UjkLW8V0s08TiHEfg3qFszNNm1vfNWdhvYtOftSrTSSj1h3sSKpaHSlbDYykiCLB4JfUQ7vQTNWBJeMGs3/DDcDgq/8lpplFFTFOrDc1F8sT0quWgV7vz3Xp7znUcsU71CraSp0accbirZ0FTZdxmDZwtTEP84rxY4erM05Zyjn2g6/yZZ90gTo7+8mn4fXLpC79llVm1r64dmBFHb9aJEC//0OO7cBPNcrU5oAnjZw6qL4kXPo7GXaLvfQ96joNoTZmXlpd8y/niJLs9OF4pLWaSdrPDvGtYBJNcrch6aMHWr0SFCJL3aUvzUbwOoofJ+vh3oX1qNIfhD+6R7CLubwC2YvlECVFA+3ljcIXVaUzBhayj+3OU+/CWxtX3ZQpayPiaZnVHehtIXKGQVAcSrAamLsky0MWdTdTHHBvFVeWx7vOGQlHoBrBc9aXlZAiYjlhCsQtUgfIxymRzRIh++0mhm+utg6hC5+vklbOp2h662MszWL0LGnjnI01oPCZVO/3hoborMJSt4TYsUHJpzao+I+Jy++RB1996S854W3nn74inWBXY5c4TL88omqp3LgaKdQz7+dmGFd/8MCNxyyVIfvIO9TRZeSZqPfHv3kN6qv1UHrPRz/nFESFKkBYR3ltHQ+ACvK2BarbqpSMYMCwruHm4+ShHWRmXF1C6KcVRWF3pqeUEt5dgixJanqP/3lCyH0krOoJYKWTputSDRtKlb3vsEL4fY01IuCI/ntn2Pp1V+AYR4V2vJcgJDnsX/r48WeR6t/CnW5SMDneU6uOnwVOkQiWm23M8pUpnvMsO9PaLDX2qL+yxM4gFBxMZiRSTO299KohGate7KwsR3sy7WoxUONIN6juIrbKzqjiVQzkZzlxle5g2
 D83bIvHk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 12:09:29AM +0000, Matthew Wilcox (Oracle) wrote:
> In preparation for splitting struct slab from struct page and struct
> folio, remove mentions of struct folio from this function.  There is a
> mild improvement for large kmalloc objects as we will avoid calling
> compound_head() for them.  We can discard the comment as using
> PageLargeKmalloc() rather than !folio_test_slab() makes it obvious.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Cc: kasan-dev <kasan-dev@googlegroups.com>
> ---

Acked-by: Harry Yoo <harry.yoo@oracle.com>

>  mm/kasan/common.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 22e5d67ff064..1d27f1bd260b 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -517,24 +517,20 @@ void __kasan_mempool_unpoison_pages(struct page *page, unsigned int order,
>  
>  bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
>  {
> -	struct folio *folio = virt_to_folio(ptr);
> +	struct page *page = virt_to_page(ptr);
>  	struct slab *slab;
>  
> -	/*
> -	 * This function can be called for large kmalloc allocation that get
> -	 * their memory from page_alloc. Thus, the folio might not be a slab.
> -	 */
> -	if (unlikely(!folio_test_slab(folio))) {
> +	if (unlikely(PageLargeKmalloc(page))) {

nit: no strong opinion from me, but maybe KASAN folks still want to catch
!PageLargeKmalloc() && !slab case gracefully, as they care more about
detecting invalid frees than performance.


>  		if (check_page_allocation(ptr, ip))
>  			return false;
> -		kasan_poison(ptr, folio_size(folio), KASAN_PAGE_FREE, false);
> +		kasan_poison(ptr, page_size(page), KASAN_PAGE_FREE, false);
>  		return true;
>  	}
>  
>  	if (is_kfence_address(ptr))
>  		return true;
>  
> -	slab = folio_slab(folio);
> +	slab = page_slab(page);
>  
>  	if (check_slab_allocation(slab->slab_cache, ptr, ip))
>  		return false;
> -- 
> 2.47.2

-- 
Cheers,
Harry / Hyeonggon

