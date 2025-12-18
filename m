Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC63D711C4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 21:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D6916B0088; Thu, 18 Dec 2025 16:24:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6841E6B0089; Thu, 18 Dec 2025 16:24:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53BA56B008A; Thu, 18 Dec 2025 16:24:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39F076B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:24:17 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DBE2C1A02B9
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:24:16 +0000 (UTC)
X-FDA: 84233870112.30.4D7DC4B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5919E40004
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:24:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KSv1Hjmu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="lnLIp/3E";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766093053; a=rsa-sha256;
	cv=pass;
	b=s948/vZMFw86y8Q1ZxchfdJH01pv+xIEgE0pxG4CKsI1llc1OSFsG/FZejFiWhmZu7BLXb
	q4IqMbLcxuf/17aZBrZlUet6d0rvO0AAhNVYA/ORJ9jbsEJqkQy7vTTDWu4RBpigl7VChP
	pz2u9d2UYmAA3rHCVo/05bz89iIOSzQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KSv1Hjmu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="lnLIp/3E";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766093053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60KAu3aj9eIbi7038+5GebUx30xGcEjwqa2k3CxXq3E=;
	b=KWw7P4O25BWUb1iG1RxrtAuvny7q3WIx5aSOM4beShoS0w+C/df04gOh0BEB71y/bbxIcp
	6CLneWttyLbrsSRoGIdxJeAmh95jK2UK2safZb4A0jPOQOHFf5zENS8jesK5w1m7301OZ1
	4i0nbcNUFjl+xXcpmGqE5fhBDlwnJR8=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BIJjpUL1964960;
	Thu, 18 Dec 2025 21:23:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=60KAu3aj9eIbi7038+
	5GebUx30xGcEjwqa2k3CxXq3E=; b=KSv1HjmuLBlGr7sa/g4PLXv2ABzNWJScis
	Sp0UAdFx8BOtA+ey4j6HllKFm3dtj1TD1SRcvVcpbiN5eBzX5dYqsJhOwBd5x5XZ
	JLXpjj3Xxwta3u7rQSfj9RjIWsdzk7854Y4+d3YnuOZ7QAhouzOISK4LxsKfnix5
	X9ybAdpCzDxbrIzdhLnFIyonJL796YrjtzxIwniboU/0CBQU/5lfTW8t/JFt4fPg
	kzKX5uuTHRyW82Q2CBph1aaYkq8c8gQHPkK2n9cVRUh0rYBs7kxXCdkXKJn5RPvE
	Rvs5drIpQhy7WeRZHBCS/Vj1QjP6F7he547TW2RTqxpiZF4kqJXw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r2904p3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 21:23:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIJT1bj035102;
	Thu, 18 Dec 2025 21:23:50 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010024.outbound.protection.outlook.com [52.101.201.24])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtcm1qv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 21:23:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bga59Rc9E0dD+SxFLA3QbzfeKWeHTiP/0zHMCxql68Bw2u8R3VeRDmdAZ+4NcopRZBe2UchE3KHktdPMBF/DnNOpiFisVWcNzM80JLyZ1iE6ube8WkHqsCFsz+OX3HZzyazfFV5CnQTQGjkGvSr4Ya0YwoSi0paeiSUF+tszVFog5CYWGTsRlkbM53SVeLLvNO+Sc2G9o9np/or29jsV1Sps67azWqELOlHl1n47VUUNUVTJ38aWXpVnhSdTAPqovVwTJAQhl2Y23usFdh3IhjHPhRthjyzOiPQMr2GLuNmyIl+8AnweLY6a46m0MYYRNGT1oir1C6BBrwNn3dv8rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60KAu3aj9eIbi7038+5GebUx30xGcEjwqa2k3CxXq3E=;
 b=j5Am1eCwyLGihSDcAHaFOYWcftlB7tiNMrQCTpOL5AC/6kQL5pJVQ9sBF6VkQq1j0WT8b9kAX02moltuGh2FYuFh3te0lw7sPXBjmfSOTsVeLYQmcl5OwIlDZm7F5zcV+o3pb3tBic6HL0DmzKZjRJSPzOwyc+ePBot3eKO37+BsEpGVUzqzjLUVO2SWcEdiEKoLnjSSTS+ZvF/7SjoXI8arUeFbMchPDsoTZr/C8o+7q+nAUAvxBA4xt5lYING/FY3fe6bSpV1DTUTjnjNtB9Jk5/kNQvDUtq9nZQicJbTt1u8NyCQiOQqz6uQ4JF2ppodWjS3nLesVDSUdBPbW1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60KAu3aj9eIbi7038+5GebUx30xGcEjwqa2k3CxXq3E=;
 b=lnLIp/3E6xVNMNwd8P7IhSo+FquBMlUO5QBgrhG/J2kkb37mo7z2FqBUqAz8pmjNxUSBqKKnx7FIFEDt/d4Rp/hOFPnvjbkHI6MCUSFxDkOZfo9T/EhBi+ploAlnfqzVeK3gzvTHZAU0hnwUCIrPL9UJXLMebOwyqPsIFMLkEJw=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS4PR10MB997575.namprd10.prod.outlook.com (2603:10b6:8:31e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 21:23:46 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 21:23:46 +0000
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-9-ankur.a.arora@oracle.com>
 <b34ce151-45d5-4074-a869-de93b2bcdef0@kernel.org>
 <874ipnwlky.fsf@oracle.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v10 8/8] mm: folio_zero_user: cache neighbouring pages
In-reply-to: <874ipnwlky.fsf@oracle.com>
Date: Thu, 18 Dec 2025 13:23:45 -0800
Message-ID: <87jyyjv5zy.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0385.namprd04.prod.outlook.com
 (2603:10b6:303:81::30) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS4PR10MB997575:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f2b27b0-c927-48a2-766e-08de3e7bba3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4yoVhEFZcuBj5iyfiWChymFaTN51zqievEfqvpWNdnxzyxxI5SOmcQaPlUH4?=
 =?us-ascii?Q?5fbMzbBER2vUgo3X77vyOwSpUdSAFDNwRAbhotfOuuT/oMySeYouoFHe7Sqz?=
 =?us-ascii?Q?HryGrRctl2EDbCUPVqnskSGI1gEr5nHEy0asqeqJ5yDJHvEjcUJIrjWnqIme?=
 =?us-ascii?Q?EpSN1XvAz+A7CogkPGy4enFG9hf8JMosHl9fzKllMS3FqD91PanYPBMBp2i3?=
 =?us-ascii?Q?mDrlsX9h8Pg1gAV1lT4tj8Bb1OEweceVI8RNX8OXp0FW+RAhRFku2gewgTVb?=
 =?us-ascii?Q?SeJvX2Ew+3cB/gbjT8NyB5cgjFapZcbnE63MTBRsq3eC5F4dfrRHjNLTjGCI?=
 =?us-ascii?Q?3qQx006nStl9YFjFUBKXz3C2dlnGMy0BvvGoAiuOknPtY8qRGcaUn2PNFpIL?=
 =?us-ascii?Q?F09cSR20wIf9EHsbWvwqzvmdhxyo7PGWyCkIRRADjRuxw1Zy8d5BkBF263ad?=
 =?us-ascii?Q?FLQY+/rQt29g3JUUEba0OXV+MU9PGsGTaqVMA6BXPtW6Did+ffd5lxgDHlQw?=
 =?us-ascii?Q?UHAc2qDWsrkn/wAmbyUong5CoVXKLZBo8measo0CFF6NpTIF9y5idov/LZrE?=
 =?us-ascii?Q?iIfKzgv5q5QGyUQ44UlU3JIfBQZyYoAG0n5nslx/adg8Cu5zBOEHxUT1fgTI?=
 =?us-ascii?Q?KCmRnerfKYXzqL3etvORWcHSuSH8KQai7xRhWRBcEMofL2OJuFMvAFQaeb/7?=
 =?us-ascii?Q?L5z/29VeUJ87+lSuaSmp/Pr/ayjFnX3CIww1BUwppXzAFlggXKanl531CMnO?=
 =?us-ascii?Q?1jvhrIF6uRh24O0wSEi5lNkC4XQ0bt5f4J6BuQTQ6D2CPv0vywOnYCZeNYOj?=
 =?us-ascii?Q?mE/Km7NqSX9Xm4zHaBBYZullqfQ0+MNL76QgTbe35vA38AL94qk3I9PD/zGN?=
 =?us-ascii?Q?pX/JL5/TIdvuD1D9/fC7eIXYio7Jn9vyX7PalntmpezGes8t2jd0aPyCjbY4?=
 =?us-ascii?Q?aF3jjs1hnW2rpNB3bw/iaGpPxjX6wAvHJxVOGW1P5p3TOhieGd7fcnMFtbNq?=
 =?us-ascii?Q?H/hqIs70vYouPBrpwrchLMnSWZdMovgTs6UtiVm8S18GBXbFr5XHimGsTyhQ?=
 =?us-ascii?Q?iKVgcaqtOYp3KVunmxqMpxzTP2T13mNh1R0Lv5D35faSF2e51/A5stJ9w+jS?=
 =?us-ascii?Q?Ju8D59ubZ1fM9UqPt8wnaABzwd67p0ep82ZnG11gM/TKYh4GfqDF1ON0aD/+?=
 =?us-ascii?Q?XQz6kI5FPkHp6tFQpiaL+lkxmHvjeTcyn0/HmOYaVgZurj1KTR/pFLx8PIW3?=
 =?us-ascii?Q?LQkcq2ePDf6+gfFq3wqOJvGG09Mbv68YXapUHdOpYFqeGASxgytHcogTDug7?=
 =?us-ascii?Q?9RnIRKwEW3+zaxIlqXofY5mFzbRLzHYsGvS0J8Q/RCXvLkHw3sv/QeHaZxVT?=
 =?us-ascii?Q?o6BJTqBbPh1QO3i900LCz+AlNZRRUobQD2Nh8KsAPnmRZZvfNLwm895s+Uw+?=
 =?us-ascii?Q?7YEA4CyLOsI1q7W8wtfrl2Zwt5bWPwLa?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wxubQfj3SklSKXu3AGwggWJ5Kxtn8+FYnyCzTmTkSwAYOpLfJ8MTtnCDz7QY?=
 =?us-ascii?Q?z2uuxJXPdObRh4tExqwpqxZM2cQ8a/4gEH1sDl0IIchXTMYihF5w5PGWBQP7?=
 =?us-ascii?Q?JMRbshu9sIx2h4LSqKQ1CyGPbr8syScszstRJY5k8HOgp0VmVyzdAJxepJ3L?=
 =?us-ascii?Q?iTZpWyVrmYDdQXBGH+EqPVKw3hyiA7m5tOlSDMCbHCtKUyiwitNqxAKzB0t8?=
 =?us-ascii?Q?7Yp2C/sYnTJMW3Ljp/754oPOeZxnJ9ONqwFfrGaAMWgwjseAhO6swwSOXSsN?=
 =?us-ascii?Q?p39i3U3Ka8s0cJxw5sDX+aWTSsSoY5bCEhtzg42KPlyPVOmytSxg1lT0Ua3a?=
 =?us-ascii?Q?pI233PAOgq+xlP/OIjuDGGrpgtOTvxwgp76USPSgLkCCiJj2AdoGJWEgcnZL?=
 =?us-ascii?Q?lpTGowTM1q0lGhnK2ctEFMjjnEl9n4F+k+5KsgATICrzuzKA4ftLHDhmTEGL?=
 =?us-ascii?Q?04r8Trfbv9/jlc1Cnzs2aSVw6V3ysTbI5YQTY2HjSESvC0cdwilfTCwj6Gb+?=
 =?us-ascii?Q?yDhcJLx7C6J8qQixvZXB7UoKbSKDJJrYrVAFAz1Yq3k9O6jhyLaZUtlfKFL/?=
 =?us-ascii?Q?rqgY9dLoSVg8oXDtqKFn9qzIG1m/hr1zZPsjI0R/DOqET0SezIiMn9vKyCGA?=
 =?us-ascii?Q?t0M57jGFghCZTpAinTI1L2tcm6G5F4dqBv0qEiK+akybz2FBO4cByX0iwXbl?=
 =?us-ascii?Q?adCyoWw64IIWO2B6o09aJiX+bQTgZEjZTyYiLu9aqZ+bIzv481zgk9ojckrf?=
 =?us-ascii?Q?5SvIuskYptR/Dz5BACiGFzYrFCPVPalb9nUQcqwhrJBarPaZBMQ8BUHdiky/?=
 =?us-ascii?Q?1ZFw7R+uoA62UTDlOPd7FBVyEqvSdcT/qyr3o1H5+Xrycgp4RvS3Skk8dwwJ?=
 =?us-ascii?Q?TVX3vBNrCVb39dS4kcSM47KwxYKZXQPrg87nV/BDL5pLKO6rdUDcXbguNJPE?=
 =?us-ascii?Q?CM2c4j4BjRlJGObsRHkKKj0uEbiRhCFadJbkCNeogUBuZKHK6pGzOP/Ksp4v?=
 =?us-ascii?Q?1qMDxDOmLZiIaCta5Ag39SiMr4rGIMpSgpMMfdPfpr4+OwBP+K8mJZDUIgbD?=
 =?us-ascii?Q?Gjd5CZsMJ4nL5C3c8lcct5MCMZn/VAx7a9DFZ7wgQ2JW2pheQf8M45VR7NrC?=
 =?us-ascii?Q?MOCPBt2BbYoYps30Kd9NymQDKM5t2nz/6Zalqfd7R1u0vQEZWAYDDU31LL1F?=
 =?us-ascii?Q?uphxUAHbLATIiVvYdc6XD5Y2lKQuGz3pf1diaBTHbgJ87KKE0sq3se94AmXm?=
 =?us-ascii?Q?57agLRLdvPybaxQSwxd2gQrwWCl2y+48yCgbwp3UjWAWbQfVVugkF+QOJx5G?=
 =?us-ascii?Q?nGnVH0kRQytkyYn15XaMCUUwn2Cu9nKPFzKidsAYrvBUH2AuH2rBoYHSGSKD?=
 =?us-ascii?Q?yfqieXIA6H+VWpAdhL0Lum0SXK+rnn3MjOY9hhIOFK4JL1SF4UNFMTkXJUc7?=
 =?us-ascii?Q?jThIZjn8n+ApNhZDFsCv9pikxWKyi2/36A3HAhlk3eBnJza7cukMguajMPRj?=
 =?us-ascii?Q?0IOn8QNLl3/n/DVOEO5zVN27s2gOnxfOAbMXDYXYmhlSJtOp2lgBkXhTAnrx?=
 =?us-ascii?Q?NrWslxJ2hckz6VuXgj+g2mR5hUyGkx9AXey5KPEBm4fiWZxAd65MhSNjDNwg?=
 =?us-ascii?Q?UQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	clI3hMXbwIBNZfYWSMZ8COEPcZGPpF5VAsbuJHt3N0Gfc6/w37LHznxBkLZzTkZFN4yaORS+eM+v2QNBAdvJD9qM8ruH5k45bfmdA2X1iveVW97wwK4SWUmdebOZI267IvAvK8VqMsQ/PnqQbshaD7tk00ER4LKE1XZ2r9kUAS6v2xpY9y4lINfPppBR3vrB2ugGyghTSDJm74bydvaWvDsFCZrpr9pDEwdw0occ8W7VkeQ64ENop7LfbKmdsy2pUGtL/wZyrb2EWozcvRu/915mLxl7zVHHvnD8lZHTvjlbVw7hGRSUU/1I7MMdCh0iN0m2NGE5DYsa5uPvH3c9GZcvaUI1VmNeNlYL0UCDVgLLoQ9hRdpdwlVTGVtiw/GliiXSUsMCFQasIchYubzVhBOSr8stVf3YjfO7b8DEaOcW6aZJwPlkwmD6N5kYtQw2CIgSM9YD857Xlg/i7vGyRJkfAccuGawJ2sGGal0t6mmmtOdBdNZOrqT+BsuF0+62GZ0f6Ouhk28A6Ti2PJFzsPxqZPqV+Cr1lTlP6ReDn9+q8/du/1QQ4uLnj7KsCXfOn8BUFrB0/8OPgs1KZqxQKl77qmnmkxAyZrPkN70X6HM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f2b27b0-c927-48a2-766e-08de3e7bba3f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 21:23:46.1018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +D3yFzoEdsmjZcWHk//snvtGrjZYqraEF0OK9Que4Tb16+tb9agoSzoQOmdhdA5JJd/ACKlP6f233VzaYvugnoe1BZ6YpvK7Xhb9RkeO0rQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB997575
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_03,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512180178
X-Proofpoint-ORIG-GUID: wCrj82zcVXWYAFSNYA5OVRzZrx14ODoU
X-Proofpoint-GUID: wCrj82zcVXWYAFSNYA5OVRzZrx14ODoU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE4MDE3NyBTYWx0ZWRfX4jBvTlmopP9E
 6wYEbuo0u2g/3aQ/aiGznsCgtn/lbDzEfmpVsCiFPT0mzPk1P5NjpHCtrIRvWlvTboEvGLxNMtK
 0Sg7oLa2PDbcbw54zn8FMHm6/FXDJBEOt/1IfkfRkvSlZ9AyHvPKBXmxhxco3Dj1cI4c56m+sUb
 hqdANHY693x4DxVyMtPnyID1XM9RAzhsG3AUvwTGvz3LrwnKY6wHskdizbkvSIfJ9TJeaw1TbwP
 kP3ZguZDAJTVgEpkkQwflPd9dF9GDMgDUyilFdw8z9ItWP0y3WCJBwfc5yc9CTgDdR1w4CuFApD
 9uEyrFvE7x/RQw1W2YSNF2xixgIIu4maOIH7XpyIDCQICcQn85HyAVE+aLvSiMBIKgERCSMvQYV
 mpTVA//gDYMNK4239LtfNADLDGc8sY4BlknxDAPYD/n0+zHflHK4Xf4TTgknzwWlazljc/3UIt6
 NK86FaVKaVHwBC/GXIQ==
X-Authority-Analysis: v=2.4 cv=efkwvrEH c=1 sm=1 tr=0 ts=694470e6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=zd2uoN0lAAAA:8 a=GGcGQ-R45-L_OjWqJlAA:9
X-Rspam-User: 
X-Rspamd-Queue-Id: 5919E40004
X-Rspamd-Server: rspam10
X-Stat-Signature: e5wz9exwtwhjrakgx8t4s988jtmy5fkx
X-HE-Tag: 1766093053-467006
X-HE-Meta: U2FsdGVkX1++hkF4gt3P+vNvJJiKn3yl/1O/5aIbYoy/aiB5Yxd7jPxiU/AYd4dS+2eg6J0sQCC930qe+ReYLVSV2KlaubsOhXZOW6DNfDRstveib5Mw8HmdXbxkKaSVEHqLIT0tr5x9kidXMVz7WaCT8n3EIdPLRIfXsIbONFsUMri6lOiQy5jsLUBhdjx/f+lhoud6WAkbsYPPi7bgcSvbvpPr3bBxgUu+3s64h1SdUTH68v4wZuWlfTTmeCiAeuscnnT+RisYESR6Jl8xW+biPW62Dg70+Ge9BHsz9MZbhct8W4OKRcQC8cGqknqaUhhGWX/CMa7NN/jq01m0qxO1cufABlxaPtGmggo5y8j/dguJuSF4sYvmB9HObVW5a3Q+RWzlb0YBskVJv+qp8ZubKKlyAcvN7cjTB4FTAoidZ205RJqKZRVjzZRiv3qMNh2q2aELriI1vRPtbnU6tHelbuXvmCuj1PucEODxp0pJo1yb/DgkSSRapjn6GiKnPtvo14XgYAlvQBikovZXmzpu0d3roYL/LHo2EN3uTEQYlM2yoFLaogpEVafXyB5V+et0b9I6v1c9l4QY56iDM1a3V9+jTuuC/J6k6Ferm9RKXcnhnYT29uGk1FwKluke6pkue0/V7vgP1etJeko7OMulbwDr+BbaHtwnWIX2vKhPhq0MRaXHPakX4DuQVoK0Q2TXkbmv6P4TcHeuUoZhdMtijcA/gW8BhXSE5Cvc1L7VJ7RBypzD7Acqbbxn39pMVC3S/CpyZQ5AB0jxxhVqACq9gWCeK7LFtSTem3ubuc+OgkguQZzokDqnJVLZwGe3JCjdw8Q1sIT6fRQ6Hj7lb4irqdjtQexkv+LGmJ5ztw81adTh0+8ViMhB8eLjDALuwgJ7vHIquXe/TJLlOF8Up3JS1VOQYNfgoWtj4UlSoi4RlxRYGY2XKoUYGNPHq9Sb/EbbBAabJg0VMs9rkmb
 bNWPfAQP
 twm1VNuoEGcsG+3kqrAM9CyMbjMAOebhdEpqWDwCirCZkNJE2Vw53zVxCLhdCl89ZmGGuFpgVzN61UXTSwKC0He7byzeE30JTBKYtg+f3KcHTLEIuETg7kjCgHMCNbEdg0b75LnkmDVJ7sTa2hRZnXVMP61U0sbiGUnN0GtpjATksBIZB1x87m5ojOwxItRsh0L/0Rzcj/P2ynkOnwIJNGryDBMOgh4Q8DeIpDKcCEmu6LSq0ZpYNFPHX5bBFgkK2k5MVvHcBkRlgqOJKfN4xUkpfTzEcY5DbjggNeNvzDAtFeQpkufv04m1TZQe0KVuZB4BQXvxMdMPAMIhv1CBJ7kjjD2hzYrfah9DTQaxzzf1pajRnGOXO04a15ryrfgDsnhH35R5sR7EJ3pJ8ylhMpW8eO669lba68iBISwEshaYaOsRNiNoIYP8Nz0uSM163eXtaX+ax8mYmWcihrwrzqYLTvo3lfzZIfLM+ByUxImi6h3FsXKfg7ZSk1VUr4ZcNW7xEqeadAsUTwm43CKW7jlOtVPw57CWmj9Xv1YYDzvVDRZecAktq7adJudLNNhnMElFVD10xWa/eIxrFS4fdJVLVQ+rpKAfnIZ7UK9IUyGm3FnMedI4w3hZgXqsD3uS1VlOJtHKp/Q9iKKCplOc6Fpqeh4zbHUKol4/r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Ankur Arora <ankur.a.arora@oracle.com> writes:

> David Hildenbrand (Red Hat) <david@kernel.org> writes:
>
>> On 12/15/25 21:49, Ankur Arora wrote:
>>> folio_zero_user() does straight zeroing without caring about
>>> temporal locality for caches.
>>> This replaced commit c6ddfb6c5890 ("mm, clear_huge_page: move order
>>> algorithm into a separate function") where we cleared a page at a
>>> time converging to the faulting page from the left and the right.
>>> To retain limited temporal locality, split the clearing in three
>>> parts: the faulting page and its immediate neighbourhood, and, the
>>> remaining regions on the left and the right. The local neighbourhood
>>> will be cleared last.
>>> Do this only when zeroing small folios (< MAX_ORDER_NR_PAGES) since
>>> there isn't much expectation of cache locality for large folios.
>>> Performance
>>> ===
>>> AMD Genoa (EPYC 9J14, cpus=2 sockets * 96 cores * 2 threads,
>>>    memory=2.2 TB, L1d= 16K/thread, L2=512K/thread, L3=2MB/thread)
>>> anon-w-seq (vm-scalability):
>>>                              stime                  utime
>>>    page-at-a-time      1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
>>>    contiguous clearing 1602.86 ( +- 3.00% )     970.75 ( +- 4.68% )
>>>    neighbourhood-last  1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )
>>> Both stime and utime respond in expected ways. stime drops for both
>>> contiguous clearing (-3.14%) and neighbourhood-last (-1.46%)
>>> approaches. However, utime increases for both contiguous clearing
>>> (+19.7%) and neighbourhood-last (+9.28%).
>>> In part this is because anon-w-seq runs with 384 processes zeroing
>>> anonymously mapped memory which they then access sequentially. As
>>> such this is likely an uncommon pattern where the memory bandwidth
>>> is saturated while also being cache limited because we access the
>>> entire region.
>>> Kernel make workload (make -j 12 bzImage):
>>>                              stime                  utime
>>>    page-at-a-time       138.16 ( +- 0.31% )    1015.11 ( +- 0.05% )
>>>    contiguous clearing  133.42 ( +- 0.90% )    1013.49 ( +- 0.05% )
>>>    neighbourhood-last   131.20 ( +- 0.76% )    1011.36 ( +- 0.07% )
>>> For make the utime stays relatively flat with an up to 4.9% improvement
>>> in the stime.
>>
>> Nice evaluation!
>>
>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>> Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
>>> Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
>>> ---
>>>   mm/memory.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
>>>   1 file changed, 42 insertions(+), 2 deletions(-)
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 974c48db6089..d22348b95227 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -7268,13 +7268,53 @@ static void clear_contig_highpages(struct page *page, unsigned long addr,
>>>    * @addr_hint: The address accessed by the user or the base address.
>>>    *
>>>    * Uses architectural support to clear page ranges.
>>> + *
>>> + * Clearing of small folios (< MAX_ORDER_NR_PAGES) is split in three parts:
>>> + * pages in the immediate locality of the faulting page, and its left, right
>>> + * regions; the local neighbourhood is cleared last in order to keep cache
>>> + * lines of the faulting region hot.
>>> + *
>>> + * For larger folios we assume that there is no expectation of cache locality
>>> + * and just do a straight zero.
>>
>> Just wondering: why not do the same thing here as well? Probably shouldn't hurt
>> and would get rid of some code?
>
> That's a good point. With only a three way split, there's no reason to
> treat large folios specially.

A bit more on this: this change makes sense but I'll retain the current
split between patches-7, 8.

Where patch-7, is used to justify using contiguous clearing (and the
choice of value for PROCESS_PAGES_NON_PREEMPT_BATCH), unit based on
preemption model etc and patch-8, for the neighbourhood optimization.

>>>    */
>>>   void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>>>   {
>>>   	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
>>
>> While at it you could turn that const as well.
>
> Ack.
>
>>> +	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
>>> +	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
>>> +	const int width = 2; /* number of pages cleared last on either side */
>>
>> Is "width" really the right terminology? (the way you describe it, it's more
>> like diameter?)
>
> I like diameter. Will make that a define.

I'll make that radius since that's how I'm using it.

Thanks
Ankur

>> Wondering whether we should turn that into a define to make it clearer that we
>> are dealing with a magic value.
>>
>> Speaking of magic values, why 2 and not 3? :)
>
> I think I had tried both :). The performance was pretty much the same.
>
> But also, this is probably a function of the benchmark used. And I'm
> not sure I have a good one (unless kernel build with THP counts which
> isn't very responsive).
>
>>> +	struct range r[3];
>>> +	int i;
>>>   -	clear_contig_highpages(folio_page(folio, 0),
>>> -				base_addr, folio_nr_pages(folio));
>>> +	if (folio_nr_pages(folio) > MAX_ORDER_NR_PAGES) {
>>> +		clear_contig_highpages(folio_page(folio, 0),
>>> +				       base_addr, folio_nr_pages(folio));
>>> +		return;
>>> +	}
>>> +
>>> +	/*
>>> +	 * Faulting page and its immediate neighbourhood. Cleared at the end to
>>> +	 * ensure it sticks around in the cache.
>>> +	 */
>>> +	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - width, pg.start, pg.end),
>>> +			    clamp_t(s64, fault_idx + width, pg.start, pg.end));
>>> +
>>> +	/* Region to the left of the fault */
>>> +	r[1] = DEFINE_RANGE(pg.start,
>>> +			    clamp_t(s64, r[2].start-1, pg.start-1, r[2].start));
>>
>> "start-1" -> "start - 1" etc.
>>
>>> +
>>> +	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
>>> +	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end+1, r[2].end, pg.end+1),
>>> +			    pg.end);
>>
>> Same here.
>>
>>> +
>>> +	for (i = 0; i <= 2; i++) {
>>
>> Can we use ARRAY_SIZE instead of "2" ?
>
> Ack to all of the these.
>
>>> +		unsigned int npages = range_len(&r[i]);
>>> +		struct page *page = folio_page(folio, r[i].start);
>>> +		unsigned long addr = base_addr + folio_page_idx(folio, page) * PAGE_SIZE;
>>
>> Can't you compute that from r[i].start) instead? The folio_page_idx() seems
>> avoidable unless I am missing something.
>>
>> Could make npages and addr const.
>>
>> const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
>> const unsigned int npages = range_len(&r[i]);
>> struct page *page = folio_page(folio, r[i].start);
>
> Thanks. Yeah, all of this makes sense.
>
> Will fix.
>
>>> +
>>> +		if (npages > 0)
>>> +			clear_contig_highpages(page, addr, npages);
>>> +	}
>>>   }
>>>     static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
>
> Thanks for the review!

--
ankur

