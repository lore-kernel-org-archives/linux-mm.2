Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4203CE9D42
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C6E6B008A; Tue,  6 Jan 2026 10:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4511B6B0098; Tue,  6 Jan 2026 10:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FC256B0099; Tue,  6 Jan 2026 10:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C78E6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:05:00 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2287B738B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:04:59 +0000 (UTC)
X-FDA: 84301861518.30.BBE69E7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 265504000F
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:04:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WUDXwo9C;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=G+7xuz3u;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767711896; a=rsa-sha256;
	cv=pass;
	b=4TStSmEKOZYTiqeJnQEv7J0g2UIyw7Mn9W2CBRCBh5C2jHD36FY2lgI6KHIghYqpF2+dEW
	UImFYWC3fEBrX7OdotbvvUYdzkjdyhppvAfePfg1/iCB9wcEdqsb/rzrTNONvVtD6BPPYN
	YwHjV9r7a3wCXVE2cmIHPxaur8HBq8o=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WUDXwo9C;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=G+7xuz3u;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767711896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o0UDm9SkkOpni6U8C5QNCM1vV1YWtwNBUbIS6jHkU+c=;
	b=eqDxJCpltBt05shw95iZu8psHrkXocdQ4D3QWIdh5KuBFmOUkCRMmdNVZYcMZBzwfUB2Iq
	PK75jCS5P+H8SSixxZxmTliNbgQ6nlVbau7/P5gqodIp76BmCqUcvBE1SEZYD+OPIFunKs
	iZReCFpOMOzA/RQYLNqEevNWMjuLaXQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606DhwTc3645869;
	Tue, 6 Jan 2026 15:04:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=o0UDm9SkkOpni6U8C5QNCM1vV1YWtwNBUbIS6jHkU+c=; b=
	WUDXwo9CUvHOX1i+7vB9BrXlBfX1phs53bdCvQ+8E/agcGO4FLK2ulfyKjjnLKwd
	NZSrEEtvBY0vDVE0NSnY8Y+DmMaE2Io8JFEDXLQMlIwmw1xWhJe2XLxYEDI9QVpS
	PgvbZYiY5eV9hcxlUkWK4FoQr4WbB3hDAUz5+QqhUq+lT0PV4JjLKCxR/8bavLxq
	wWPGeoQm8zKM3Xr01tHSzVOHL+FMMQSlTRIoRahqGHs0bWLEhDwdmtjV61C1sGkb
	zeqvr7qlnuRanVyqGvukaLacXMK4dmnaNuMH3SwouC/MVrUqsnXpBUYUI0zpcyr8
	doEx4Wh0T3yXafWKx8GtGQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh3hq83u9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:04:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606EZHIR026252;
	Tue, 6 Jan 2026 15:04:49 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012030.outbound.protection.outlook.com [52.101.48.30])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjjy3fd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:04:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n6FYYwOCz9hFYZodYksi0G6MjnDuANvfISnI+lazo1ckedg+o3LeTLDED77xGmSYIyX6N4b/875VRJXOKVVLdM4I+djlK0b3f40H/lqcKu+jbBeClSh73FqzFBzorwR2sVfhfuWAxdJLO4K5VHrh4/v/SRWXwMAe273oFkBwF1+SRrKQwCxY55Q6RBTVcDySpbcPwOql+03CWBd6HaE8Jfp7NQk/VhjxGWaaSK8HbfhJs5CFgSFf1G4G3JRSqBAIlBFsRAl9GlW4JI8GKOLqvnxodp+iCDC2PYCODDCQD/pKygTYIN8sI8eKq7QJhyBgjJQBLJ0s+3krltasPvN5fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o0UDm9SkkOpni6U8C5QNCM1vV1YWtwNBUbIS6jHkU+c=;
 b=DwzCg8r7gqd34YPkyoOKCv0c8RpTXgoz3cjtr3rhHsYroaOZaXB2o0F1B+XDVcsnDUVSEfhQYqHmzNxPHa0cQcGmlcU9lLzhPpHa8DVBv0qJ3UWPwu1nBa2Yo12VNFn2J1rVhjBa3dqc9pzFDr4vxO9ZpjFa7uH3YBE/GiHgAZ3Gtym6PYu9FvPZiO66RMPMRdhy/GztPGd6CENddNwtFAuFCM1oaEpXMTJJvE9FRK0T5pkb0G3HgRlZTTuW/HA/RkaYr2hpoxUpXJadar9Qs46pJ9EM2TNCCuZXKZGbl/gXvKfGWvKjJmp7qb9bnI4wTKa1yWkJWTQU3/hOxTqWkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0UDm9SkkOpni6U8C5QNCM1vV1YWtwNBUbIS6jHkU+c=;
 b=G+7xuz3u8mQtR0eKxJRXvEWhZenoiRjH/HdHCCrX9x7b3GUWDurHDD8rP7lX0NO1qjNfSqWytcywPxuVLeW4D4FEddMPF435lU48A1u/Yx0UuHQH3OKov0TeOkza15TtGKl2ZYh9KWGE372GPP8/grmEvEZW6brurKaMLgSqSlk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6039.namprd10.prod.outlook.com (2603:10b6:8:b7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1; Tue, 6 Jan 2026 15:04:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 15:04:43 +0000
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
Subject: [PATCH v2 3/8] mm/rmap: remove unnecessary root lock dance in anon_vma clone, unmap
Date: Tue,  6 Jan 2026 15:04:28 +0000
Message-ID: <9b5a438237e4ea3b19a986a4f8fddb8848cba54a.1767711638.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0230.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: e5ee5ebe-bf47-423a-8112-08de4d34ec48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G64JiF5DArQqqiSUutFTgJ0q3GNDIaUtVuI5HJD3SY52CWr6Gd0pHg1epo+R?=
 =?us-ascii?Q?HeV9xF3W734aSsHVTQuEYMRyFLr8x326L8iZk3YNEvCmllFVTHhI2L8jH0F4?=
 =?us-ascii?Q?R+wX6BqK9Ms2uWa7AixtAXDK4ui5rzst24ZmZ22iYLvCUoqLJCMoiQSimKG9?=
 =?us-ascii?Q?CB2e+ZwHSCHQYo0XwMEA4EZQ6RFCDY3NYRMVPUJURfok/XG1Q3Fr/zPZsW8F?=
 =?us-ascii?Q?Pck9X72e0EEUY9eAbJNHbOAEM1TKAMsqN3NKyXmVEW42o4/JnQMTTqt5ifI3?=
 =?us-ascii?Q?W2dzVBgu/bFGqG9VEcUYF6i8aiMjnGBP0rqBEhieJ25NhoTutFjr436n+qvs?=
 =?us-ascii?Q?36bEz3Aflmf3CZ2mfvfSzECQ+xKPfPnSAQHhH86YDzn/g+9QBubnZ89DIK/G?=
 =?us-ascii?Q?exP6u6krPPcy0dgVYqN8v6zbs26d03pQ+PGJa+qxJxviNS7yBp8nx3K5lbSM?=
 =?us-ascii?Q?nHShVVPMgHuqoW+95VlCGGsJq+lLMGUmFIf9D+dYM6WtHoNradV3cyiJA3ih?=
 =?us-ascii?Q?4taFk9cvFtFZl8CGtxR3JyGrlFRfcGnQsIjiyn9cDHYQYGKvDnSNn3H27PjO?=
 =?us-ascii?Q?6op1lRFmdQPWtcDXWrEQAiB/UZdKurhT9X1fke3ltsmOFpZTUg5nli+fZklF?=
 =?us-ascii?Q?qqNzlo8EVwYsDECcU3YQ+xvar1Ua8p4LRJ+vr0hTv+strRYAqoLMZIWY4dc7?=
 =?us-ascii?Q?nevMOalj3jsR34GAxfv9+bR7Z1qe9SHWjrbT3NedNKAy+ZWgOUI044zfJRjd?=
 =?us-ascii?Q?2DsahYO9cqfTsqJHAORBqnNAxnMJc3Ft5dVbVxwW1lLtfymkaxnydmMGVzAE?=
 =?us-ascii?Q?KG2dYrZFvvJkx29ilepqX0in0/dTagatjnGFINp03/dkva0atpBZp6hFPnoj?=
 =?us-ascii?Q?RRpbCbXeEM0Ji6P5wJ/hklgHJ+8ht61ndJ/SA8YavL2AXnWAndH2WRbtykRM?=
 =?us-ascii?Q?xfg84fBild61z+/IgWAuJJglFg9aNrknYTxS7L2SpKI8ZhGi/2sM8zPSVa/H?=
 =?us-ascii?Q?H1fpckfvr6g0IQLfZRc4TPbdkTU1OEpMmXNJm5HPdxJrznxDESCdHWhNcrRp?=
 =?us-ascii?Q?C26Qhdkljz5yAmhwysnAKjxqJtgEcA0lBIoz8e99wjN8MFLBok0x3a+YiRkx?=
 =?us-ascii?Q?VNSPZTS5NyJMxq9RGrD2gqXQKuFU9/MhtOHdKCeIXU4R3ESPAaVpkMBTTaPp?=
 =?us-ascii?Q?M9TYPZA10F8Qj5utl8pxGgR1glqPQfXG4iB5jJfWeSLZV7XNZqKyiCpVWK+a?=
 =?us-ascii?Q?0I4o+UnfSKZX+51vlcoqoqpsMfFuyl/OS5s2bHkzwWSAtruu4gYbssAH18vm?=
 =?us-ascii?Q?MBaOQza6nIGichVfNku0Gas6ntzxsDN/Mt7NJGRetKyU/XYGY84Ysed+cvFR?=
 =?us-ascii?Q?zhdf56ivEQWKHkVfXvbL2Dd9d0ahbyBZFGEgs3i4B8axI0osR2RCayfcH/op?=
 =?us-ascii?Q?SHBgdjh7hl5tq7r+jFkDvZBH1Qxykthf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N1Y/ClA8GBc2AcHM5ZAgLXSZiKB5R/i9+NqHbfdRQxlS3TMCcHCDKe5pTlt/?=
 =?us-ascii?Q?WegD0xfX5sajGpODUrLJa6h7jPx6JMCTFcPI6Z78HVkSPDUHREzI0kLiGS8T?=
 =?us-ascii?Q?+ssmNlOg6f6G/KS4LGP/3xNqA1da75+AkcpPDyqQJx3F7iSAvGsm6Jt3EU58?=
 =?us-ascii?Q?/cKW5vwNQHWxKPVGHyTsT5blVZyvRpmdlgGprur+D+z05EzhlvdH2XroJjTc?=
 =?us-ascii?Q?xb5Eb2bzvUeRtmpCdo1Cr968Eenw8bvPD7CXgBROBBB+s7tdUpdtrhMT+oPe?=
 =?us-ascii?Q?GXJ6/r8hM4JpDjN9Aerydybi8w7U2+sKA69jlzbZsXYyAIxl54gMKXCEslMY?=
 =?us-ascii?Q?IamYZeNowmHwmuBIVjeKaM0UAnxol+t3V5HRXxgiHg3DyZ5NDe3G5t4mIzjP?=
 =?us-ascii?Q?ujCh4pf3UykswWvM2Okbwwnv34Z+pwdMysf1Fr//1qbq9ZD8NNs+FeM+jo3U?=
 =?us-ascii?Q?UhfGqnlziWAApyAo/PpWkC0Hk7aGJ8Qm/pNnV0cCiRgM/3L4hxZfAm8BdSwa?=
 =?us-ascii?Q?WyToX5HAhc0Eim0/X4++ilSRMxg0zGAfGN4J3QnUtljVnjk9vcQbDWS3L3IG?=
 =?us-ascii?Q?160XHXzX98dFBuuuogCg6mVeD71TipGPqawiSpqigqi5yCey+UNVXuNQy/VC?=
 =?us-ascii?Q?Q9brHtfOKNZBa0i8ERlP+Ou8U0PFcvOdr0fEmMXFvifYYhd/fukNyr561Hb4?=
 =?us-ascii?Q?fOeEbiaIZ4tveYbj0fSnQ1F/YtY3cmdDoN6HLQ4WvII5EjM69yozMQHRyM8H?=
 =?us-ascii?Q?Z3/kepBTlEdHh89TdL/x+Ldf8XroY1X9g/E30lH1CyK76E7Mkk52KebgYxlT?=
 =?us-ascii?Q?rBMI1ac/NXOU8lPd/PeROdNQcdM1Qs01H1lKSNrIen/svZuETMFifuLGv9JT?=
 =?us-ascii?Q?gdtaE1Meiyu6iHVQcf0ecEUh4+kE/FSxorgxvbB2w8c4RBlyFMpaYEUJvD/j?=
 =?us-ascii?Q?9qKyEgYniiMdC8zUnAlWNWTpyCTvyYZ10qvsjQWQ55hA6S8lBDf+lBpX4H6a?=
 =?us-ascii?Q?9ZPtDzZQr1OuOHth9MVVOBULyvaPKLKkuTJdJJ0Hx/fwJmBcd9NU11/OZOHf?=
 =?us-ascii?Q?zxmVxd9WW8/Gt589u0fKTVD6/39qxnIL/1Oe5io75mt+WoTvkZ41E3RgTB6s?=
 =?us-ascii?Q?TCA7EOfLo8Q/nO4GR3ckiMeL016UFhLW0Hc+BJeqIpeFYOnbU55Kof2Z9b93?=
 =?us-ascii?Q?FkOSmm/ukK8I5OdP3p8riBUIxcLKU3WTsBEeIAI9+CQJTg2qbgPlHKHEelJc?=
 =?us-ascii?Q?bzp3/QzU7vNWpabhnCt+JOgZNM/OdvBvw0IlSRkoKzUZLZ6osmZ35wlFcaTu?=
 =?us-ascii?Q?XQxsztwaQzCHMBhzbbKlmbfFyh2GFrLXjMK/RN03T7Bd+HJBQdpHA1Ycmsx8?=
 =?us-ascii?Q?/ZM/P1KXHbozeHnuP//6dGlELgUUAu3UXbbhO4mjBJnkeVvrM9J6dmUsE1Bh?=
 =?us-ascii?Q?PNF5QeAxo3llGDeAirGHfEB8zcjuGtdPEbL8SDMhhrm/pfGdHf70Z1pL5PbT?=
 =?us-ascii?Q?zUFvW0HFyeZeOPJI+IaKljdjSND82BgLvMNj0E76b4EJm0ytca4ulZD1UgC4?=
 =?us-ascii?Q?7UJJF7V9zTHnQ2uoL2vFfyzzXPKy8HF2fPOJ6fURlB3REwPnRFbstfZxIq+O?=
 =?us-ascii?Q?s3BDTsMoiFcshXuMJ3r3hnrdBnPEF8Seh8lZLWbnafgrRWp/IyQyp+tFMouB?=
 =?us-ascii?Q?kcCtVnp8/2wgJDFVt4Ah7af6ZaWRovyE2vtMpI1eQNu2sj5m18hev3trx+vA?=
 =?us-ascii?Q?3VS3Fi6mzXDPLmu2iZZCtt/jzYVSzxw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i6kIR2uDL+8gyuD9xibnWeiDQN7QCuJe+puAAH0NSj41zt7LlApD2ZPuALC8F0a6J2eknB/6EBD9mzLeYAmJQXTbukIsIQl3cLNtsFb8CdeMeiD8HVAleanMcKWXTZr0VdJAKxewtjbfcGscTA6tlNdoEw+ZK88cT/sOwHTe1NtSEAwu9lz2yXEnSZ8vHFZZ2y1CP62oy6PXxUsAHkfVZ5nu0BdqXwgJpQ58IImpD8v2K8UIP9WA6iWhnmaaGx4M5HRrav8GSlLJwQgswPg9WrIG/RvqBSVgFqyd0t/zM4CbwFWkiVdb4+1UAjabZjh59fMGGjmstOLCh8svragm2WjCrRUJ6odhr7SMBD503nGuFv6J/W9Yg2/5PwWtnTz4rs7xLcnQclhzstqG3GBff2vWccojEBsvb2svlJLtsJA+6qk7q2GWcZIq255aY8DvoNlCDq25aI7w99avz9K+tGHLnlI9Jy+PKLZ96/ULVJt/1Qq9Nsq5wbIW1s7yW1FUjJE/MoopIU+NkeIZalT2AlN5VTzaQQ2tU6iXh0+B0a3uvAeMVr5vhzx1a8QcM8gGrm2EA7wQF6xFSZCORF83MZ9s1nBljpewCJ2a0HBxI0Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ee5ebe-bf47-423a-8112-08de4d34ec48
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 15:04:43.2994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 69fDE7zMMfwqsng3LvJ4QpfXUCl4XzlUfeHb9pRBVWJtXbQA+Tdi0EZOctT948XkPYCwDzMHXHye7d0O/eDbqT8S+bCc9dLqfd/h8vSSo60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6039
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060131
X-Authority-Analysis: v=2.4 cv=Zvzg6t7G c=1 sm=1 tr=0 ts=695d2492 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=QDGw0KozxnkV29ZdokgA:9 cc=ntf awl=host:12110
X-Proofpoint-GUID: m2hsklSfZ0yUbzuhcQbsMDmOaA7OoSee
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzMSBTYWx0ZWRfX8jxedTDdE0B/
 lDhbdOHf62ZRL58PZSKTAVNEXd07fSlupidmXolwQMZ61wzWYNIxo3DMz92P1DAORRgHOfG+fw1
 hb4yyKHZW7ypHsFqVYyjV5OkKN1IZJ1F5tssfedGfuBVXpPHjTEQyF/S2hQUiVPzrEjJyycd3yo
 A5ESBlTYB2NpRk2kD8oyTMQiMO8N1/frW7yNqMWr/BckVSScOq3z1jqrH3UPE6ZKmgQCVMImGtO
 ZDf4OkF6g6hBM18f67LFFebpDmZ3zfb+1MEX6pSew8SUt2kWzTeIGFL6nqCEdCXvMad56XCDEp8
 XQtiEeJ29rqRt/JAQudSeRWLicbhfAOr1h4Ninv7JnQdWOVkBylEvksbNG00G65DeNbylU6nC2N
 uSltMd0TaqQEO+faFt/Bn0aEgzsnNb0ZbDpYNQHtQkfxt62ExWggqbJrUtJG6OE2opeVEYv/UKj
 gMV7S5Ara1ECVxfFoBBhXrjqKHQe5gn20Q1Wqwr8=
X-Proofpoint-ORIG-GUID: m2hsklSfZ0yUbzuhcQbsMDmOaA7OoSee
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 265504000F
X-Stat-Signature: 84riiumjeoojqwf1np3og3q99fq9dytg
X-HE-Tag: 1767711895-83604
X-HE-Meta: U2FsdGVkX1+pkifMfXmVZ6PGEOH88/48U046abjj3CGeD4sEUNKdOpIdXUgZTnDCUUpeShG4EGD9d56VMxW4Yovw6rdF12osEegz8fG12lOMfEwv3TaeScLaKkySdJcYzA0soJf+VRJQ/6BrghhYWlTETmXQP1X+skBZAV1hfEh693nQvzZMCh5TpBSlQxivV8aFwVogNoQZUrSD6IRjiBiubyOgzXCNKlvr0U0ko0494kE9gj61ui8jLrHbl+9m3Ms58GDo1ECwCE6Fo11Ig85WHLy65eKW5zeDFwh71xf6dIvFrVBiHC2nUE5oqhsx5u6ssXPzkWy9knJ3CWF5tQwVKdIzsTiWngAp2PHXjJCaELlZjUs1umoGx3z1WPcbsogm/VlM0QRSL8rf48rHIg8jP02UuQkD423qIZ08RzHD0QHKW/ITyrS2qD6l/k+3khXLEL/xFbSID91E9B3il8gc0mh1zkQBdbqusfb58LseHXyLt7SbNRVKT3lgb/RgP+S+VCCSY7A3vDU4vMUDgdwZgqEt+5sMfE+2E4P3CMsXynNiGFaZikAvhJJZx1PjoebL2dr4hcSEiZRdbjUf3fGLcC/wM6qWF5j+XrAClk9IRI32idC5+ck5J+jDghYWuktWnn+vz0+t38O1vD+eFEjlFy9SR+ZgvH7LIUy4LLLF1nxcuS99s3SXF7BAq3qVZyXajx0D4Ui1qsiKn6jV1/LFdWZJFUP43t5t7ovsAzmSsyybjCG0GBEWprC07ekDofQHnQhMf88gTlFlMOn54Ku2acds+wuZwnun9SaJ4wUM65/WHSnlw/I6QgtybA5ARlrMTsVEOoUCoQ6TYThwIGYfmrSA6rm3lZsWgha83+KxnV1AD9qglgonx7DtlS06E7D7Ip2UESBuHkBSb5I04S6OGNOKbTY75gNfjSqfaOIqUTOqaSY0DyHkVtfGs73W+JIXnxR/BSaCo94ijEE
 P5p6h6Ox
 1+BMnaBBvOFLZgPohGGlv0TNvfBuNZZMCqk4zMQlllwaOLq2EaYNyxZksw1zfI++rEkIggbFWrYfiz7eJvzJ4rvU3Qzv5nYESHeiSsEeYv2vAk/nHephyk0Phj3b1HmgSnmkxVUAhv2s7zHxo+4RzVCZ+wSZWuFcoIUh+73PbHWhpfGifzU8Q38QE+WgUdnq8EKWEQLCWSUTcMFJ/UDLrMNGcQvmQ/k5xo2MwSG4o/FeXIrkDqYMznI+9TKocqeAhEeOBTsYbVyvy+aCq0KHhiA9uYgO0hlh1IXLD6POFegKF/n1hVf4KAzKprr41wi6YbpO2ANDuGwJPtIHMmnVr78OB4nW8JlzBCOTgxQKcuyjYIq+vpj/xNjvoqMV+ekd4DWuQa9WokOVaPfgUSfbowyMyvF+v/KPC7R9WqSdnbQ1k23VGWWk8gTUum7+gWYt9oyWcr19FxThWOFn+3OeiwuT4Ba7QJv23QHVtG6h3SHwjHRWqjLrHq6RoEie/u6A0061oRrLkSH4NSKbOPOE+jfXck4D5ywDA35Oca5WE8t6jK0qailz8HZiXHOei/1zOHirdd4zfaMv1vQ6ba3okaMCru3d+ORhjY6GScmY9b7qLNrUjYlXNenS4Ha1KNQHmkvROlRrewEDep5whDWB7+NdBlo9P+weG+EStiMbAxGVLgqqEVUMYKCx4xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The root anon_vma of all anon_vma's linked to a VMA must by definition be
the same - a VMA and all of its descendants/ancestors must exist in the
same CoW chain.

Commit bb4aa39676f7 ("mm: avoid repeated anon_vma lock/unlock sequences in
anon_vma_clone()") introduced paranoid checking of the root anon_vma
remaining the same throughout all AVC's in 2011.

I think 15 years later we can safely assume that this is always the case.

Additionally, since unfaulted VMAs being cloned from or unlinked are
no-op's, we can simply lock the anon_vma's associated with this rather than
doing any specific dance around this.

This removes unnecessary checks and makes it clear that the root anon_vma
is shared between all anon_vma's in a given VMA's anon_vma_chain.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/rmap.c | 51 +++++++++++++++------------------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index de2cbe860566..6ac42671bedd 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -232,32 +232,6 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	return -ENOMEM;
 }
 
-/*
- * This is a useful helper function for locking the anon_vma root as
- * we traverse the vma->anon_vma_chain, looping over anon_vma's that
- * have the same vma.
- *
- * Such anon_vma's should have the same root, so you'd expect to see
- * just a single mutex_lock for the whole traversal.
- */
-static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *root, struct anon_vma *anon_vma)
-{
-	struct anon_vma *new_root = anon_vma->root;
-	if (new_root != root) {
-		if (WARN_ON_ONCE(root))
-			up_write(&root->rwsem);
-		root = new_root;
-		down_write(&root->rwsem);
-	}
-	return root;
-}
-
-static inline void unlock_anon_vma_root(struct anon_vma *root)
-{
-	if (root)
-		up_write(&root->rwsem);
-}
-
 static void check_anon_vma_clone(struct vm_area_struct *dst,
 				 struct vm_area_struct *src)
 {
@@ -310,26 +284,28 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
 int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
 	struct anon_vma_chain *avc, *pavc;
-	struct anon_vma *root = NULL;
 
 	check_anon_vma_clone(dst, src);
 
 	if (!src->anon_vma)
 		return 0;
 
+	check_anon_vma_clone(dst, src);
+
+	/* All anon_vma's share the same root. */
+	anon_vma_lock_write(src->anon_vma);
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
 		avc = anon_vma_chain_alloc(GFP_NOWAIT);
 		if (unlikely(!avc)) {
-			unlock_anon_vma_root(root);
-			root = NULL;
+			anon_vma_unlock_write(src->anon_vma);
 			avc = anon_vma_chain_alloc(GFP_KERNEL);
 			if (!avc)
 				goto enomem_failure;
+			anon_vma_lock_write(src->anon_vma);
 		}
 		anon_vma = pavc->anon_vma;
-		root = lock_anon_vma_root(root, anon_vma);
 		anon_vma_chain_link(dst, avc, anon_vma);
 
 		/*
@@ -346,7 +322,8 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 	}
 	if (dst->anon_vma)
 		dst->anon_vma->num_active_vmas++;
-	unlock_anon_vma_root(root);
+
+	anon_vma_unlock_write(src->anon_vma);
 	return 0;
 
  enomem_failure:
@@ -471,17 +448,19 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
 void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
-	struct anon_vma *root = NULL;
+	struct anon_vma *active_anon_vma = vma->anon_vma;
 
 	/* Always hold mmap lock, read-lock on unmap possibly. */
 	mmap_assert_locked(vma->vm_mm);
 
 	/* Unfaulted is a no-op. */
-	if (!vma->anon_vma) {
+	if (!active_anon_vma) {
 		VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
 		return;
 	}
 
+	anon_vma_lock_write(active_anon_vma);
+
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
 	 * from newest to oldest, ensuring the root anon_vma gets freed last.
@@ -489,7 +468,6 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		root = lock_anon_vma_root(root, anon_vma);
 		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 
 		/*
@@ -505,13 +483,14 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		anon_vma_chain_free(avc);
 	}
 
-	vma->anon_vma->num_active_vmas--;
+	active_anon_vma->num_active_vmas--;
 	/*
 	 * vma would still be needed after unlink, and anon_vma will be prepared
 	 * when handle fault.
 	 */
 	vma->anon_vma = NULL;
-	unlock_anon_vma_root(root);
+	anon_vma_unlock_write(active_anon_vma);
+
 
 	/*
 	 * Iterate the list once more, it now only contains empty and unlinked
-- 
2.52.0


