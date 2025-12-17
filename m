Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAB2AD6555F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09FD56B0098; Wed, 17 Dec 2025 07:27:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007B76B0099; Wed, 17 Dec 2025 07:27:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7B36B009B; Wed, 17 Dec 2025 07:27:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCE566B0098
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:27:47 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90761C0ACE
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:47 +0000 (UTC)
X-FDA: 84228889374.14.F5DBCF3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 215FF1C000C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lbfVpLTy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="q2Qu/ljG";
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765974464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7hnZrGo8ZeyIXqyVblTSuV/hz67Fhc+3Q+cOZVrwVO0=;
	b=rVyU8HjlBqMeUeUt7PufFzzFP7vqrrA46un5fWrFJ23TE7/8XoU9Oy1wpB5lifz/r3Y+do
	sqpt6/QjaA+ClOV0SN32thK0X1b4JzkleKXAHCISnlfG+UExgv9pQsIXgpZlOtRVr5UK7m
	pjIIHlZkX+KQM7f8dbGzv0nP/al5Inc=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lbfVpLTy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="q2Qu/ljG";
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765974464; a=rsa-sha256;
	cv=pass;
	b=WPg+712W5hl/T1WiUgrR+y3R0hRui6JYnsdR0T4maHlIJ2ESJaooI7k1zt6qCsfOnP139f
	ihUXIyQu/EVQh6d16F01/EN/ovw5TjG1m1gQCISlD8lL1kzAEV6ekhcz6W3s4bhpj6MYFF
	yAU8gIfUExE4phQPm+6mi+3hUtMyN0E=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH6NWlb2005671;
	Wed, 17 Dec 2025 12:27:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7hnZrGo8ZeyIXqyVblTSuV/hz67Fhc+3Q+cOZVrwVO0=; b=
	lbfVpLTy3mWFdj+WuoDl7DhAFmmddXbtKWnsYRh4uUPixSSaosXQUlDp/ggz6n7W
	akLoqlC4NgINh6M63Pq0wnMw/PNIInHI+HMap7U+GYoEJpqkl8mnFmET4jI3VTSC
	WzMGyqWSUBgASlloMkBlaHFYBSnZ/1YG8QghGeGCYZ1GbbgNfdnTtkxrzQldvSzu
	PjmqRuv8plJMKLbOrTq6LeZCS4tN+7dZit+sP+COsUx6R4jhLK1RpZz4JZwPC44H
	HB6nIreL7mNSxX5U0Vp0uSOPdoMgwi/7q4hRGY4MTNqHXEstQxtuL6HBrLWJhAAr
	xGvw4YN633oxhdbb4Kr7Bw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xqxwv92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHB6AaF016709;
	Wed, 17 Dec 2025 12:27:37 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010029.outbound.protection.outlook.com [52.101.61.29])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkn0rfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W2Rqm4DOeAveirJX5bxgpxcNWrj7BK/2k+1KbNeK2Gey6oVc4EHmOGkhu7bn96zkfa4ozQWag2iStYwyRvDb1nojwIcsnj8bKgfQ0W0DX7aqu3suOYv213CWU/kLcmHOADyBKIG939kBdRSlYYKefqZxWp2GeEMidschRnMuXgJLXjwMCs1fVFtgsRZZZa0fQxRu42mSt8zp5wlTVxr8dTfJsmcy0kOZEjkKRtYoQU9R9E+/1nXjg4ATqqE8BBcU155dVQTYT2/MXGTzbDbVbPh4Hg3xa2MRQho32GqVGjDMSauZ0W48UF5vsBdygXEb46vkabuPeaBh1LM9KIEthA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7hnZrGo8ZeyIXqyVblTSuV/hz67Fhc+3Q+cOZVrwVO0=;
 b=TLukPttZFIEByX9qUMCPdHtNM+akQntq3laCHz5EbtWuSNYGVWrXQpoK43NYbr8lxqs7gUKcSBaM/CtawhZc86vnF3IjdZeu+MbjBlqEt65GmpdgJvFVcCDSsHIZ2F7in24+UraKjWSNC86MrTYHtqYHrnyb7+0EyBVF+UB/YvSrHGz4IWFxFBJR9DIAfv4tv8fI1ofpSITt/U+L3mpK9XXDqFS4wehpxwdQ5jV06mh5AT8I5MdYCc3YfWeaVuwrICJw9okzOHY15ozFW1W+LcaGo3RNtCbzB0YFXvbjwA4dcqt0qQj43PAnrM8AtbkPLoZY9fTwtGfNAZ+Ib/2QLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hnZrGo8ZeyIXqyVblTSuV/hz67Fhc+3Q+cOZVrwVO0=;
 b=q2Qu/ljGhpBR//yEhCkYDVlIi1Z8KV//XxCVEi2kJpyrjF0P717fN0LAX+WydLf5+HTDWs2CXU3mCT5jTsLtp8UBLH3ns2NutYDUczIBRfqluaoBY+KLv5cspgjPGd3ck6lAOK6/DQK8EDjC2wSyxiCleiDJYNRsKd2/fwa1/js=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6253.namprd10.prod.outlook.com (2603:10b6:8:b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 12:27:35 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 12:27:35 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] mm/rmap: separate out fork-only logic on anon_vma_clone()
Date: Wed, 17 Dec 2025 12:27:10 +0000
Message-ID: <175d29b48f7e49ce9a1b19e3a6c72cc80c0c5bb4.1765970117.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0192.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6253:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a51007b-ab37-4232-f629-08de3d67a870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Fne4e4fYgbb/QEWlyVpCFO4PG6J1nXYn3l8S4e2ftIM+MXK6c6ce46GlZB9R?=
 =?us-ascii?Q?Eq5Zfxwjz/plnYX1mYcGkMp16yhvGzBEeiB6T4z6SHnPe7flXsZPsJMUId2o?=
 =?us-ascii?Q?+bxp9HcmAjeUJtIQGRg7MOfa5c4+E/3TwDcGMST7BEzmC1NCWt73OU6H826/?=
 =?us-ascii?Q?oAASDJ/idEyr7n+lfwFUjD9N7W/CDLeP5H1wcK95INMUNIpZcZZ6WPs0gjDa?=
 =?us-ascii?Q?eTz9dZ6nuPgEpHiu36HNLWDB/JKd/ro/rM1UwSATiwdZqM6u7PdaRtqmiLCs?=
 =?us-ascii?Q?yUR6TsRga+P6KSdMX1eroFvFnCjgp8XEYD5H7Ux1zLWPMQ1EaXItNPDsAxov?=
 =?us-ascii?Q?iA3V+U2IZj4l5a0qDYfqYKjup42jcrYVA994Sya9zoqC/DpfSvoPym445JSv?=
 =?us-ascii?Q?BntuqYw0JYWUnLY2Fg1GaGABssvW4ixJw9XKH0EUurrfdROg15uehyOuJQlP?=
 =?us-ascii?Q?ampCYWb+jkXACWH5nJD9O6S7iChS2cmbRvhbKeB7X/FauzmSKUZ8ENHSZrrg?=
 =?us-ascii?Q?EIAapMsGsMImU/0RqaPpHp8Q4wg4XvV7oBYY1XiLAesuEmLwzoaAyVr+C3Ij?=
 =?us-ascii?Q?Qep12aLbE/9phx6HqqkJZAGojm9kM9b1QiDqyksmgmGUoljTBA+5MEvT6Ng6?=
 =?us-ascii?Q?wOkngBZCoytl59Ae0v4Z4mLY7UOYfGLxJIpliqtE5m8ZkLLhi6fLNRv5dHMp?=
 =?us-ascii?Q?bXELCa43CgYYm8Q05YV8APl3Bk3V1bNKT5DJUf8Wz9tVQ3czD9eXTlWhKZaE?=
 =?us-ascii?Q?wWlEmoGPbtUi9ftJlmrCdd6/aIzv8prjR2uBio8cRpboERfHG/sFrXOlU8z5?=
 =?us-ascii?Q?M6rOicimdO3KDpypZpzkapJ9TUJOS4nMnAFIedddgvU6e0In2B4sY9BpMGV/?=
 =?us-ascii?Q?KgrxZZt4hNZbcwvWXCXeiEY7H0Gsmkelt56XgngOS/RmHaYBFzQjRzeBRJyr?=
 =?us-ascii?Q?xob+dFE7MJyc1uoMR5JCZj6/Dg9ooxLm01iW41kY+BAvrrQllncgK0z7KxKk?=
 =?us-ascii?Q?QUvprpVmd7zgOMHxYCbsBZvpZ/yR42n1DJOrXHAyWfSz7Mm/czyxxqNUOSKp?=
 =?us-ascii?Q?OcNpCndFURWZbvoUncXF0ZR5WOIIIkk+AJrHBNRPxPKQaXTOUs9hDKcIUrZS?=
 =?us-ascii?Q?KYxEz8cTOFqCpvTy8dX/yvCXM9W/Sf04+l8xW6Ib5+tcrM991nh8dGIdGwD5?=
 =?us-ascii?Q?LAKu843LD1sYUO/D9YVWhnMWGyyilK7m9WBKXsDKL+3slbdV8QoVJABDoCNi?=
 =?us-ascii?Q?E2bAt6eZJn/cwQHAyejxjyD7DlvWyMBKuKgx3XsLyJ7qBSN/lxS1/aRqxWt6?=
 =?us-ascii?Q?8rLjgzR1muA/nH9tw/jXu3R/M/PsC+AYfwtSsktruwWtvDyth+w3yOAWuSAY?=
 =?us-ascii?Q?9XNIiVUZ3hCohP/noL2jvmGVHaeGF3vHd6eQr9jb7Lqb8rSo2F0J38Q+dxle?=
 =?us-ascii?Q?ugsKsNxGP9vRdLkaLvdlmPuWlCZZlkCP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TGIcxKC6THGJ1e2bRfD1v74wFvEpjeh8VMEo/WkSfOY5uWiZObhtkEHjg3QM?=
 =?us-ascii?Q?OboPlWgcDsQY0XpDRI5laG2jUOIvh8ru/G0eMPLD+Y/7GbyzYFPYllF332uH?=
 =?us-ascii?Q?aIceMkjiagOUDyGpprZ+egTWaHWxjonT87hptjNZpmBcYjGQORpkib1j5feC?=
 =?us-ascii?Q?o7OiEhsIJ1htT1tOB9xkXNtLWRWJVuk7HuKLoe0S2qZVwSo1TnTjUFgJ/HsX?=
 =?us-ascii?Q?/Hyl/AVeWLrwtD5RFVAWI9SOkbxg2wD7YLjjDo72lmZWUfuBWFfTi+EWLvOZ?=
 =?us-ascii?Q?YHYxoG8y0mLejL+PlSU79TiEYzXXDU+8xtHZlK4I4pNUuYu4wrZ7dBbbVR48?=
 =?us-ascii?Q?Z4bV8fvCAvPge5kTNtCda9Z7Y1rnjcC8YnZZy4++MI5urTlpLrZC3LTWkOrB?=
 =?us-ascii?Q?BIZeQfzRISPMw/TCdrY1f7jckg7gMwMXWWi9CnSA9+Ynz0H6TK2LwnySR22A?=
 =?us-ascii?Q?NgEM+YOhIT6JHXmPtt3dDO1656rnnv54nufGgra9xSB0lbOzE1ocI86JmHS8?=
 =?us-ascii?Q?ULMxJsSryQ1FDKBO8b0qbT9tj8FYgPzvo7ENzJzJnxw8/Yh5P5RBQsCUYiH1?=
 =?us-ascii?Q?/tZK9Bu1OGgNXxPzW2LGtTGQxByGU4bUR6zDPqMQ0MDPyx2dJbugyGeFjQav?=
 =?us-ascii?Q?35llWZC9teMnLP2EGTRM4017H/2LPVdQONYOavtOorZ0KWvpPPSD72a/A1qw?=
 =?us-ascii?Q?aTEDHJtTAqmWDNvU6hjYST0zKzh/77/aHSxXQFJKUOmPwoAcTYfQ9zMSAEz6?=
 =?us-ascii?Q?mbISwBDQGc88UnsCyzZ5utrgyWx21CiLiWEf5M26m2wlHxJz6JdIwEjRNziW?=
 =?us-ascii?Q?Bg5xW7C/IJ1NxCkd60EJiS7mno+MIQuvUYPVZZaBHaFjfusMe/D9yBzUbNxo?=
 =?us-ascii?Q?hLulNKHZgG1ZGVUyZbH8VupKdjequQJvwgMngRVu67aMOPERXPsXsl4m+hhr?=
 =?us-ascii?Q?PfEGA7wU/5poyeaxA9rCIId9r89RHfZv8Tb2XNlufFLRFkHDurgCYDndPFzl?=
 =?us-ascii?Q?sBGXVrKP63kLv3r3RyvyW96hStJ+2DVvk3Vg7Dij3mZZjqFV11JZxBJPX9Nf?=
 =?us-ascii?Q?AFfT+sONrNoFQGdg5Rr+wjTPv3tl97Q2Wk0iil1t5UdTbD6W65JhxVJeN58v?=
 =?us-ascii?Q?9O71aqH7PVo+PxAERlqf9FgD4U4H/a0TFX+VkBdv3J8QqMTPz9Aq72oEzj0a?=
 =?us-ascii?Q?iu7tjEPB114mUFnxLtixY6k39T+HMIeVJ5bcjQac45O0ND3KrQRJIkxK0nCg?=
 =?us-ascii?Q?Vwpg5s3Jd2uWom7l1Lf4DcXYgk4P10Z9QHQdfy8Td8ebNRG2MJfAOj4jcHZH?=
 =?us-ascii?Q?Uz7qDTxUqJ/Wu6Mm2MVUlyB692T6+cslw+gJhFy86N89EFW/fWTZi76tsbhZ?=
 =?us-ascii?Q?JoMupn9NSHepL46/GfOpwNVmtLsa6yTI2P0OTcu2a19bDXM4VbmNjfFV7g5d?=
 =?us-ascii?Q?qIZiMJPwp9oj2zBtU/v3+jJxQW4QUxgAxOyPVa4lfvtMemGqAwhBuf32EqEn?=
 =?us-ascii?Q?TYyBSMI6SemUzyTObo5MYRxLfg2+3IOYxANYiVo87ldiAeaCOM9w5TGtOgB6?=
 =?us-ascii?Q?97tMNJvrTGUqT8S+xtF2I3TF1eiYS8SvtBbfi1XZmdFh4lDwW1LkQUce0TAz?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EJNrURFyAREqPI/UJwCgbrq2DQ5RnHCtHmgg4R2xX6iVZmKQW6RzjGyc4D8Rfe+BjQi8EDuMkblzAGBEeypG16q3q9hj8QTcjzShR/aAFw36R+N6zX+N6+5+LYR4juPW1Z6SFTQ5tnJ7WP2Z4if8y69ytcaTKBPkujPvHKjMEyVcYU63Y5JswNUQ9FT2ZsLv7MmcYCEwLvkjkdYqeYUcgkjZzH8nTo42GTLIGFRtmTzf/Hi15GtCMrid4Db5MKhCkCaGjIoPdOcrT4rOIpkBDLSvRYx5rQSPu5lNWO2/mNBnXeAY/KrY7OKyIssve4FMk5i1YCPi2NWxUUvD5xA18qDA+y+NQ4NTjEljqw65pZrTDVGK4nWDaM67WBOcdtFrUA5+jgW9P16uRIntTsgKHzoFrlv+nAGhyukMu5OPBAzduMcwW2/CYOji4TvznpYEvLdFHjvkwxXdszx+mnwfskU5zWporlG4ewuGEGU+sjxAR6VNQE6XjOo8kj2uESnMOpBE+Z/4CCCxgd4sXIOeMd0DCIfDtl9WzSP0KAZU7d4foows39/Ve4NGW1ltljgndehWWJL3Lf1YAYxOEWkP/7cMHhByTAJ9lvZjftqDCyI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a51007b-ab37-4232-f629-08de3d67a870
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 12:27:35.2170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LQ/cE7AdvG7ZWnPlGgafmrqgRhTVmLZ4gEcJGFGS51pwdq6sqd1tS2TanXIPMOZYCLO6qyyz+PyhHg+6Y7+Okzj7U0tI+dI3Dnp7Zgp8lWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6253
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170096
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDA5NyBTYWx0ZWRfX1sf1d43DxZF0
 f+E6u2Z+NgFuSKTiB2iOaN6eDpTfExaMNKMzRgl7C8Z58fgMQJkUOin41UOZHPRn2Pb4pdTRKPb
 iEccfjsjsRktAhkvPPAAemBDNgWsmbWYo5fl8Tbs75EkUrQWkzCw2eYGZrQTOJekGXuiNYU7O1q
 LB4i94eDE5HiKSWUTy5ffDXfvtjp5vGz4ZV6PaxX9PdV9diOVl7/mUi71DDQKsORdES0FNcTrcb
 qG5fJ70y0Nf38M2zQvedRQJCGgsRlUMW1+vX/3VPLWt9kn6jztbudgl+gGXm4iglfHWemCaIo4H
 tS1Qbef6Awbq9exdztc59HUdW6aEXFAgZcREYER1YGt0wfrSi7HvmFjYYCjyl32gBtEYoicMDE+
 vSTYT2fRxpv7i//v61649R8RIZY/Z/pC8Ggt5tLa5C1LYyK5IMs=
X-Proofpoint-GUID: 82cHcUnRYlKV0BUXjr6pTNwDv_ontE1B
X-Proofpoint-ORIG-GUID: 82cHcUnRYlKV0BUXjr6pTNwDv_ontE1B
X-Authority-Analysis: v=2.4 cv=BYDVE7t2 c=1 sm=1 tr=0 ts=6942a1bb b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=67mXQNmqP2celrMn638A:9 cc=ntf awl=host:12110
X-Rspamd-Server: rspam02
X-Stat-Signature: n74z4ectsm84onhngar651bz3mwnidis
X-Rspam-User: 
X-Rspamd-Queue-Id: 215FF1C000C
X-HE-Tag: 1765974463-719912
X-HE-Meta: U2FsdGVkX1/ZKasQMQSFi0xVRNUwEdvnnGpeiBsV3CEQiT4iDreIpjsQjcdUjqGUjRYW1lL2EHkMzr+TOMDmUD6cZMagHZ2K4XB7kQi5lOYDGnCEcZ7U+50m8Vtm7QUhrZtecuF536aiJjg/HwX/KgcW4t4RCTutlo/SSUPBRmE0fmIJntmVsNwuPi31xXCLkbNtZP7jdjlDMaIokTK55KK+9UiJhzUVzpsdmQykH2FpxOQUtgvJhzJ0Id/IM5IZmJpMioQbI6J686311MYqN9qzBeIvf043dxBFD8JBD8j/H1tfw6jzZKGIJEX/nEOdNyNolZnUNfmDSje+ZG6RXjJw3K8Z0sZFQ6FXKWdw7d+Tihn3Q89LFCuR/WurF1YrZevYyysLLPP64I3Y3S329EF74AtuZ75t//5MKMPEUUUyzFlqEL6FHBbmzAl5pB3LjBvfXk+h9VwVh+gj2UoRMgaIicWxRpf/Y8NzmTP5S5aDuurJEHk8FEDnw0f0hjG1cDuUBzY2O6jzsUD6xDDw7dLOHR3H054oJrKy6gXjnuNm1B5dAFT/7Q0oEVFYVBdTY0ZDLT5k46k2oSDExpP6PVOvHWhRZ/BZkWmVBcePeN7IGAVfbUnoiFGnUW7b85AGW13tL78+W35CwQ5oL8anUnL5VuSjd4Ymhkp8Ir9ngzAfi8g4X0tnf8wu3cTFjj4xksFEoLIYskeP4EyxPy2wTSH0JzP6fgSeyQa8lF16+dGHOnQlm20qw0VsMlWtYDk6qR+sQWelScO/tYOoXzGO7nnjuMI61pfkRkUCKhCU756Etke0FaJmV4RXMqWl5H48em2nFjujPmzzJHOsxieDqeqhcjJvSM08dt4QYu3FLPsKIfd/au2MnLr1dskEB2F9jAezgVM6YaNLTOgHyFfvsUNxOhiypKk554zBOf5je3Emh6mAsf8CyTXCXsrCLgVWw6lD6Xdmky4UUSAGT2W
 Lp7oNE1x
 VsI6q7kTSqvfP/v8Ef8LYG0kdqp41RxSSG3zPW/oa6j8c1KRI6p2rE0GT/vbgTkJeimRntfvGM2OdVvN2o06aFhWKsfc0jPjehOEi07wdaY460PzhwTbCx6zafQWqaJ8lszzy0ZsLeXSsKRADHYJKYDkJKW7bGCnQM4ddP9UbGBVKSNalD/VU9nZQAZqgk/7ezuDSms1376am41+aYxqlGZ0VPJzjj8ISG766vydOySgymVjYfD9cMFtRJ+hgnl83OKbVbM6ah3f9sRu391SOl4VBm7nIatLn078f1ScoMBno+fSksi/liXk0BgO5pbDIL1E3r+R++M0uOceQAeNGd0FQosK6vuA1ZI9lMqXQBYFIP/lKfd+M1jDtA5rGAYzfMeDsnxCekPXiFScUSS1H0FcMmz6WYhzKEeCuAU5XupBgjL9Z2jn88VNrJ0+PoojA20Q4E/vrGd8LOaaVUZAxanbSNyFgAwGYuiSYKvpzom4mv6Elq9sGi5bvxddcnwCXKjvPOrUSv80h1hJrvQ8TlDMV/VKOWqBKxx5sowJ6LTOY+PSSwM49NgVmgx2zMiHnWk7zOeZA5ww/vyChp57m8a67UWb8Q5l32WKAh2fQgHNdD4wf6bsCOs98GPPEmSJv6fCEbo+KG+9yUpStzGJlkcjA0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Specify which operation is being performed to anon_vma_clone(), which
allows us to do checks specific to each operation type, as well as to
separate out and make clear that the anon_vma reuse logic is absolutely
specific to fork only.

This opens the door to further refactorings and refinements later as we
have more information to work with.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/internal.h                    | 11 +++++-
 mm/rmap.c                        | 67 ++++++++++++++++++++++----------
 mm/vma.c                         |  6 +--
 tools/testing/vma/vma_internal.h | 11 +++++-
 4 files changed, 69 insertions(+), 26 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 469d4ef1ccc5..b4d4bca0f9a7 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -244,7 +244,16 @@ static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
 
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
-int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src);
+/* Operations which modify VMAs. */
+enum vma_operation {
+	VMA_OP_SPLIT,
+	VMA_OP_MERGE_UNFAULTED,
+	VMA_OP_REMAP,
+	VMA_OP_FORK,
+};
+
+int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
+	enum vma_operation operation);
 int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
 int  __anon_vma_prepare(struct vm_area_struct *vma);
 void unlink_anon_vmas(struct vm_area_struct *vma);
diff --git a/mm/rmap.c b/mm/rmap.c
index de9de6d71c23..f08e6bc57379 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -232,12 +232,13 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 }
 
 static void check_anon_vma_clone(struct vm_area_struct *dst,
-				 struct vm_area_struct *src)
+				 struct vm_area_struct *src,
+				 enum vma_operation operation)
 {
 	/* The write lock must be held. */
 	mmap_assert_write_locked(src->vm_mm);
-	/* If not a fork (implied by dst->anon_vma) then must be on same mm. */
-	VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm != src->vm_mm);
+	/* If not a fork then must be on same mm. */
+	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && dst->vm_mm != src->vm_mm);
 
 	/* No source anon_vma is a no-op. */
 	VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
@@ -249,6 +250,35 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
 	 * must be the same across dst and src.
 	 */
 	VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
+
+	/* For the anon_vma to be compatible, it can only be singular. */
+	VM_WARN_ON_ONCE(operation == VMA_OP_MERGE_UNFAULTED &&
+			!list_is_singular(&src->anon_vma_chain));
+#ifdef CONFIG_PER_VMA_LOCK
+	/* Only merging an unfaulted VMA leaves the destination attached. */
+	VM_WARN_ON_ONCE(operation != VMA_OP_MERGE_UNFAULTED &&
+			vma_is_attached(dst));
+#endif
+}
+
+static void find_reusable_anon_vma(struct vm_area_struct *vma,
+				   struct anon_vma *anon_vma)
+{
+	/* If already populated, nothing to do.*/
+	if (vma->anon_vma)
+		return;
+
+	/*
+	 * We reuse an anon_vma if any linking VMAs were unmapped and it has
+	 * only a single child at most.
+	 */
+	if (anon_vma->num_active_vmas > 0)
+		return;
+	if (anon_vma->num_children > 1)
+		return;
+
+	vma->anon_vma = anon_vma;
+	anon_vma->num_active_vmas++;
 }
 
 /**
@@ -256,6 +286,7 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
  * all of the anon_vma objects contained within @src anon_vma_chain's.
  * @dst: The destination VMA with an empty anon_vma_chain.
  * @src: The source VMA we wish to duplicate.
+ * @operation: The type of operation which resulted in the clone.
  *
  * This is the heart of the VMA side of the anon_vma implementation - we invoke
  * this function whenever we need to set up a new VMA's anon_vma state.
@@ -278,14 +309,16 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
  *
  * Returns: 0 on success, -ENOMEM on failure.
  */
-int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
+int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
+		   enum vma_operation operation)
 {
 	struct anon_vma_chain *avc, *pavc;
+	struct anon_vma *active_anon_vma = src->anon_vma;
 
-	if (!src->anon_vma)
+	if (!active_anon_vma)
 		return 0;
 
-	check_anon_vma_clone(dst, src);
+	check_anon_vma_clone(dst, src, operation);
 
 	/*
 	 * Allocate AVCs. We don't need an anon_vma lock for this as we
@@ -309,22 +342,14 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 		struct anon_vma *anon_vma = avc->anon_vma;
 
 		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
-
-		/*
-		 * Reuse existing anon_vma if it has no vma and only one
-		 * anon_vma child.
-		 *
-		 * Root anon_vma is never reused:
-		 * it has self-parent reference and at least one child.
-		 */
-		if (!dst->anon_vma && src->anon_vma &&
-		    anon_vma->num_children < 2 &&
-		    anon_vma->num_active_vmas == 0)
-			dst->anon_vma = anon_vma;
+		if (operation == VMA_OP_FORK)
+			find_reusable_anon_vma(dst, anon_vma);
 	}
-	if (dst->anon_vma)
+
+	if (operation != VMA_OP_FORK)
 		dst->anon_vma->num_active_vmas++;
-	anon_vma_unlock_write(src->anon_vma);
+
+	anon_vma_unlock_write(active_anon_vma);
 	return 0;
 
  enomem_failure:
@@ -361,7 +386,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	 * First, attach the new VMA to the parent VMA's anon_vmas,
 	 * so rmap can find non-COWed pages in child processes.
 	 */
-	error = anon_vma_clone(vma, pvma);
+	error = anon_vma_clone(vma, pvma, VMA_OP_FORK);
 	if (error)
 		return error;
 
diff --git a/mm/vma.c b/mm/vma.c
index feb4bbd3b259..e297c3a94133 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -525,7 +525,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (err)
 		goto out_free_vmi;
 
-	err = anon_vma_clone(new, vma);
+	err = anon_vma_clone(new, vma, VMA_OP_SPLIT);
 	if (err)
 		goto out_free_mpol;
 
@@ -623,7 +623,7 @@ static int dup_anon_vma(struct vm_area_struct *dst,
 
 		vma_assert_write_locked(dst);
 		dst->anon_vma = src->anon_vma;
-		ret = anon_vma_clone(dst, src);
+		ret = anon_vma_clone(dst, src, VMA_OP_MERGE_UNFAULTED);
 		if (ret)
 			return ret;
 
@@ -1862,7 +1862,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 		vma_set_range(new_vma, addr, addr + len, pgoff);
 		if (vma_dup_policy(vma, new_vma))
 			goto out_free_vma;
-		if (anon_vma_clone(new_vma, vma))
+		if (anon_vma_clone(new_vma, vma, VMA_OP_REMAP))
 			goto out_free_mempol;
 		if (new_vma->vm_file)
 			get_file(new_vma->vm_file);
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 93e5792306d9..7fa56dcc53a6 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -600,6 +600,14 @@ struct mmap_action {
 	bool hide_from_rmap_until_complete :1;
 };
 
+/* Operations which modify VMAs. */
+enum vma_operation {
+	VMA_OP_SPLIT,
+	VMA_OP_MERGE_UNFAULTED,
+	VMA_OP_REMAP,
+	VMA_OP_FORK,
+};
+
 /*
  * Describes a VMA that is about to be mmap()'ed. Drivers may choose to
  * manipulate mutable fields which will cause those fields to be updated in the
@@ -1157,7 +1165,8 @@ static inline int vma_dup_policy(struct vm_area_struct *src, struct vm_area_stru
 	return 0;
 }
 
-static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
+static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
+				 enum vma_operation operation)
 {
 	/* For testing purposes. We indicate that an anon_vma has been cloned. */
 	if (src->anon_vma != NULL) {
-- 
2.52.0


