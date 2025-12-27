Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0802CE8FDC2
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 07:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE10E6B0005; Sat, 27 Dec 2025 02:19:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8DF36B0089; Sat, 27 Dec 2025 02:19:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B45A26B008A; Sat, 27 Dec 2025 02:19:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A16D16B0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 02:19:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D34DE1A1023
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 07:19:14 +0000 (UTC)
X-FDA: 84264399828.04.80579AE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7D31E100006
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 07:19:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dVqCPt80;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="xf/8FaBW";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766819951; a=rsa-sha256;
	cv=pass;
	b=v+K65MpaXhIXHOIpvxAKkEGRPzNTx4kHIM8Zqc0X4QxlRKq2fvKKUR/SrdSIHglieD3XzB
	C+RczzNkv90GEkKnLWn4hjl4FGKG8YaW1KLMmqJcn7jeit0o1TslI0oTirqCcAvmcK5NNh
	HU8mE2pxvuKPPnMMM7oZ0YCba5wxbRk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dVqCPt80;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="xf/8FaBW";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766819951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e11vXDkCv8R3N2MgkOuf9JYC3Lxpfpn/hg56cqm5yyo=;
	b=eB4WWqBA0h2sVTY/694cjYA8eFAt1FGdWGUqVbC0O7GfTiE3Ti8F9fF8NGnNHpm0b/mkiY
	EFyY0Od9YxZR/5aBiHbng96fh1IHGGhcfHtRY1qNL2bLKW3pDBNtfXcxDbiA7jibpBgus1
	2G2h+4u/PVBRaEO84y5OHcXVjNpA8WQ=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BR6YSqT870676;
	Sat, 27 Dec 2025 07:19:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=e11vXDkCv8R3N2MgkO
	uf9JYC3Lxpfpn/hg56cqm5yyo=; b=dVqCPt80r8IUjfdzsa+7GedcLoY645RDdu
	55qYzubhX7bPpf1ZzbicwiYJsFBO/sa7O7YZVtspj2XJBOwkU8dCwgX+aBUdFd80
	C7XpRb5FdKW+pvmmMzxSZFAD+RB8dQaZX5L8CtSVn3wcsJTPfHKJp5KnNtF0SLhw
	nbyl9dxNc4AodkqRxbzlEbYYWiEOyJm8ACFEU2Jrto2nY+88lxHNub/JSG2GHZ6p
	7+2okiGTZd+d1gNZ9/j97nQvnkZokSejVrDB6e3sFfHtToso4kuFGPXppR+yh8ZI
	X7gy/p9Hx5T26iwFv+kGS3OvDRILfU3hEyaKDBLr5ORAC75FRobw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba80pr20x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 27 Dec 2025 07:19:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BR1YE1c017882;
	Sat, 27 Dec 2025 07:19:01 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010062.outbound.protection.outlook.com [52.101.193.62])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5w9v6c7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 27 Dec 2025 07:19:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zSHsrBzyKmdPq6qarElyU+w1LxOc7pP2/TC7sgkh64iDIcDaTCrCLJnjL5HvAnBNmjY/Oo4ku+3PRiNy/LDAoqafJrO6RjrjMP/qTLRbwxsnQUCh10PW41iKGFvh+wIAgs5G3hxrydeE5MPDbqtmaa4CoTpYLN0ul5weTvTWUYtJW7D6CmmUrZqaDJBh6vIs/dQL2BYzPqr+7SUFFI2LjFHkOI93usj1j4v9u9r84XkYcbU5UvwrH0d3Crc4qL3B1tGHOUqYVS455WqNn9adogGYXmtw7D2dSY53UxKHhlw38J2Rn0TjHWmZKLPI/JdRNK/aq3F/iqELxjTvOxgFbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e11vXDkCv8R3N2MgkOuf9JYC3Lxpfpn/hg56cqm5yyo=;
 b=ThonEpvb/HfCp2Gbi5rlAkg8w0BkvxWNRJNgiTtVXPUEC9yzlEAeKeacZ7aixlfX3oXqyWlDXoXxO1WGPpQ0KWEgAwbVQMYWTeqTeto/8aYjJIbI5SBXeiQoYMcwUit7UellSX08I4A+iOYMfM/6UtYXQawhu29/woO2zICTKW4WtMU4TxBWRj6WHSDLoUGIBUOQq4B5FvjZkhmCmNFW4UTF4DQv2zCSjq5/DP4iJN5ln+0ZfthC5d2IHQfZTnjhS5tfb8ukz2cfprvVuUwlEkASpcux1Sp1CoDftOOuKeAc8OXKHAagLqF5suTvSyjd4BNWmH3gnCCENYtnFZk+1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e11vXDkCv8R3N2MgkOuf9JYC3Lxpfpn/hg56cqm5yyo=;
 b=xf/8FaBWLGlItAXGjrY56SK3xyYws+Sf6/j70H4Sa8X33yAYilOm9g8/lUqwhyd+YR+92Moo37lZ1qHnm0AvQRD/PJ9FmFOFt1otbxYUTty+KEKx8WUH5mtfZErNHP68FL4MDkNrvDtgsa33bzH+VLYl9WnC20KNxQwelxe8x8Y=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB7338.namprd10.prod.outlook.com (2603:10b6:930:7e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Sat, 27 Dec
 2025 07:18:57 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9456.008; Sat, 27 Dec 2025
 07:18:56 +0000
Date: Sat, 27 Dec 2025 16:18:46 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: syzbot <syzbot+5272541ccbbb14e2ec30@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
        jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, riel@surriel.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in
 folio_remove_rmap_ptes
Message-ID: <aU-IVkmsD1IN2joN@hyeyoo>
References: <694e3dc6.050a0220.35954c.0066.GAE@google.com>
 <aU5dA6qq-h-0XszI@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aU5dA6qq-h-0XszI@hyeyoo>
X-ClientProxiedBy: SL2P216CA0124.KORP216.PROD.OUTLOOK.COM (2603:1096:101::21)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB7338:EE_
X-MS-Office365-Filtering-Correlation-Id: eb6859d3-4dfb-42de-5cd8-08de4518328a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2ZDCOlzXkJ1YoAjEhj2U+QXPWg1zWPO7eJLa/teJZPms2nufq08YE1f2btaJ?=
 =?us-ascii?Q?dqHCKLs7/ODRNLdkiq46CVTTyZCd7vaWhoEdOMIA5xuXNJ3RVRCTE6989AVz?=
 =?us-ascii?Q?lW58QwmaFL1Iajd3dgMe6fZlPiRinV/KcsLQmvLlT1tlv7XwZldJ8JjvGMnA?=
 =?us-ascii?Q?7XY7JiBPEO4NFIJbsdQgFwTmexJDSXKLX5+q1g9ULmnKpzkRtLpYo0L/jfvu?=
 =?us-ascii?Q?qjNwQoBqqmfBdihBf8pssG22jdqS1zms7IhLDTuX9FVvEF48O09ANF8n39a7?=
 =?us-ascii?Q?VPBd2tpUpGA2f2a1BB9skAwYYbZne8Ax0/FU4ZvAlvNcRZo4PUQD2sCXcMAP?=
 =?us-ascii?Q?mI2Lbc/l0lCaUdjs3BGnHi9pB5ZV86ymE7SzkzKQ5d7uMDWdPxNSHQQpd9dI?=
 =?us-ascii?Q?DS2+gbl5P28cCiaR3I6VmSVz+n7xB+E6iG1xevdHDEJixzPGwclj529OoCHa?=
 =?us-ascii?Q?6e0oFAsJQEdwsdZIRFLyjQde1mH5ocZJog6Q/d6DTk8hnN1tVjliKngBLHKm?=
 =?us-ascii?Q?NIJr1GNKHRUJtKLn5DWnnYhDO7QW7PZauNvMxowkmdmA0M1Xw0VEinySx7FM?=
 =?us-ascii?Q?mP8bn0k+kCZ3Tx+7Mw4ej2q03grSq5uptr9BPuuo1IOJF5aeFWaeAUPn3IL/?=
 =?us-ascii?Q?UBtdGC72cFoSEVo/l5voAKkNtf9DJcCpwaOOj8xsajmof6imW1xcL6LP2fIv?=
 =?us-ascii?Q?1oJh/QdrJRPmyWOEp84isGTNmaHEamSlxEA0Tl1EUCj1fMdRxOYqDxtDQaV/?=
 =?us-ascii?Q?3XUlFr+v7SDcVmEcF8L/aLYEjTMbWBgNyhdNcfliLzO4kvKA19a1w+HhYlrb?=
 =?us-ascii?Q?B5S8GUhtrxkZ0niNUAlwgLEC/EEr8rj+McmxZY8rwl5rB4XgCyaeNJWnZtDT?=
 =?us-ascii?Q?T4DT+4hfNq+LOpKhXYqgb/SJ1tyoBGubUipTEF/oOW50x68AiakuDxGMBJ8t?=
 =?us-ascii?Q?PdYN/NWArp3w0IqmGkzWAvmRnEjpKvXJmTIpcdZ6P8JVG2C96ei3FEM+KLZf?=
 =?us-ascii?Q?jOnl9bwCOkXKlm85oRN/LOuCenHvkoEwrflc0AasNQTQWrP8oY8TiQ6ofNOj?=
 =?us-ascii?Q?tjI0/Omxl7P1itXm5QWZcCsv6NNcKCH9VEpgT6KDaqexET0AuRErYbIUp+mi?=
 =?us-ascii?Q?8jR6XPM65UyknhdkgDWgrnEdTjLaW3O0PeKWkvMFfJ3mDCT5KorwPe7e6WWg?=
 =?us-ascii?Q?aO0ZM7ugHy3HOcv1UFU0suux/wBLJxAjgMT3RGiBCw7opTx7gbWgn2iMbFr5?=
 =?us-ascii?Q?qu6X+62uWZwEeRX7wepT5N8VHGtUvRoQuuPZuRD81Mn33dCBg8CWIVd4fN3F?=
 =?us-ascii?Q?/mjPbupfopZPBL7HNDXYNfLmFcbhdJTbRs5ESQSyfirAggBgI1vFH3Mw6VIU?=
 =?us-ascii?Q?lvS6wjWE+s5SxTFiCZurq1RAzAAdSfwx+DUFGR+dwueil+qO2kZtP8LvNPdk?=
 =?us-ascii?Q?JJYMBqrXnPNBIlfCJ0eN4RPmEX+VBW45?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AFSMhwhnRhLN6eMmejBCXQgqTDV+CvbbL8MBSof9Kfcw7S+wlMUSgMnEexxM?=
 =?us-ascii?Q?sK44VGm+iFyUmaBnKaUZyYdOf73UhkHZT4AVNCPhaUwpK04Z+OMiJxSTE2mi?=
 =?us-ascii?Q?7ZsFAOj9PgW09vH9QwTgO1T7mrGTtCK8WiB7+XZgnvL7fa/lukavA17TXiPH?=
 =?us-ascii?Q?qAA43ppaaQoDXNDY/QU+2G4G7k2JF6fUQ0zMYQEZNr9Bwf/SATzp8rCrHGet?=
 =?us-ascii?Q?NiJKpge58oP75k2WYUxtxQx04pbvGUeySo0XFdk1Bov3IbrDB5f3skgqnidc?=
 =?us-ascii?Q?k9HMebMyOO4eesxpkyWkXa7ki4HX4UUXPzXAbXQS86pJ72IqxCK8LwMYhuOV?=
 =?us-ascii?Q?VCBais9sPAmF0mdXkod+E4/ZphUgIzXrW5ukeaU9M0kv/6r8cLi+uHlWZlXC?=
 =?us-ascii?Q?R+B8wFHsqEvUXhO6fwwavCWcC8bdRak5gK6ITYwRaiB2V/LRo3PchODp7OUZ?=
 =?us-ascii?Q?gYozmtjvQeSpCZ9IQgvWKCSTggujSvQP0loxHnnAFkOeFfhj9sVwUilXuTzp?=
 =?us-ascii?Q?Sc/b+stb7F5+Y2wk/AMQv/9fF3ZPtNn2OVX+d7X+mHWXnuoD29hsxZ3L7tE9?=
 =?us-ascii?Q?2tYxqMbhATgzOlpfDC6fPKB9KAWyqlovDmxLWABNnkM0CW1pLRaXCRsZVVIj?=
 =?us-ascii?Q?NUZnMmJk4X9JQ/4PQTNAgoE3SumpGc8W7IdkPO8Ec93504WEjRhXJ+roIr1h?=
 =?us-ascii?Q?OhUeooUzXM2jd3Ztb0Y5S4f3leZc7RCOdz75G19L6HIBgvHFGxHXlF1q19zA?=
 =?us-ascii?Q?2XV6XYnHg4U4HzRlHVoNhq6dPksuq0c50XJ5LPB93qq08ZA8bMKAE32RficP?=
 =?us-ascii?Q?QnuS2c75Jf08XYyP5uaBy5/R1G80CGuMwsr2Ynq7Olh2159ohyOpg06T1A9U?=
 =?us-ascii?Q?5L8ADEHWDsYX0bBiyitWbvdyv5g12vZx1hYK4r+YI5rwMehQyec3hwejB5MU?=
 =?us-ascii?Q?PDdqxXCxZrUoApnDPZjcJ17pYA0i42914KhCWaJPVqCvWlnQCW3poS8bXCGu?=
 =?us-ascii?Q?Znc1N5mGpcE/WeQw9wa46VzINeUkd2G4rlYQsKjsXwt2gWX7iT9x/CVLCFWJ?=
 =?us-ascii?Q?Y3lOl9rJs41HB2JxoE+a6cs+7/o/tCHBRylPF0O1S4joDrEhspgLVjBVnOcb?=
 =?us-ascii?Q?qtx2gm9yYKqbIgzLzGEznY8pkIC/wuCQ70It8cal1KGKx2L1kgP3XRI15e8V?=
 =?us-ascii?Q?zd7w1Gx2pT/4mvoUS64dOWAf+26NxuPAm5G063nE6lK2+kln5LrQRuHnbKYR?=
 =?us-ascii?Q?t+6uDy8taj8QaPAqkU+4n2CEmwNhFOkqBL2s9NxvTMBodwKI+h76nscUX8If?=
 =?us-ascii?Q?586LPiBnS/sBHQC9CFDZ5HaPY+ctprQzIMkTjHiyBW0RJYcNtvt4T9DZ2el7?=
 =?us-ascii?Q?o6MkJIaM+mYaZCu+yeTbHgHx7/TJyO04hg2nh9A1pZvRYPUlR3kbSYwBaKl9?=
 =?us-ascii?Q?p6s/X1y2uZrgIq4VAznJn5s0kNTR+3xR0tRr0YT/5fSZPBOlPL5Vu/JJeCQh?=
 =?us-ascii?Q?ER+StCKNLIAi4o4Mm9RQ3PJCGQ95RWzXQQlWT5LjZ/YSH0oTRzJsay45DrM9?=
 =?us-ascii?Q?5nXzy7uF6umhJN3aj5Bs0MPbT/R05jnB4w3HMy+UmqwBKc+zujGWQhgGUFUG?=
 =?us-ascii?Q?z0PEoCXQ5NNl6WTcZr6djEzLx6PPCq1TqYf5zO9B1P69QdTU0gAPoStUCC/z?=
 =?us-ascii?Q?6GUJUNCqdmoLb5Uow9HTweOeeMp27QuN2PSz7DQoIjBdOMWfpWx/fiJo0ah/?=
 =?us-ascii?Q?OPj94owUrQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZNynEyaSnzssbFv+WmXus2wWfEZEgAlbSM8bGYMtcQoYQ5emzPZ8lrCQhOHs5YB0sWO5KRenC8kA6/d1c/YSR5/7uQzATfFxBgX/f/LBsvuFbvyjWySH8j5EgKGKtHrwT6d28uopkoddzF9HCTpCLtXRue5X75gtXj36tQ6BFQvDVkxDe1kuVlvRMnFMO1EdgX7bWSg6inXPBUMQksXgVIcMNI5j5ruwBqk8SC0H9h0MKO6D1sjiiujrlM55PiDFQy24zs3udpLql/+OlTzos5qd2yDRW8VEOaDcCqbfi59Uooc/x3JR+WzGqhMa2VjBxiIjARHq7/k2ohmubHTS4M6WZilfvy+hv4kfiWc5+NtMPfKtNK2zNWvfYWcJSLiJvz5rYb4+av4jg+epU6y5a3SpIsIIrfn6t51Vx5uDqYgXlW60TrVoANuatpdVEqIRAiYLX9eYbwl9iqVZC90iiMbRNARUaxvPb4wpl/ynfljKEjFsWnu+5tQ+x27fk3fYTVqIazpjnv2i31lKISUL+s9/weqtJYDhzs4c97sq0cEg95lnVsc3zn4k4seNN3pC4ntZ1/WzszZ9EgEDEt7sTB9BIYkZ3WVa0QrIfZbjh0U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6859d3-4dfb-42de-5cd8-08de4518328a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2025 07:18:56.7343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qymm/9Z8sHh4b80ercIzo0Onl6fTkKt4Mwdnb4B+mttbQN3rOZTBBBigPdFuXCnvV/CeSdkkuq8dgo2Ze04qMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-27_03,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=842 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512270065
X-Proofpoint-ORIG-GUID: 0ajGMlpQjBx6DVpQIIDm3WlbhKSl91BC
X-Proofpoint-GUID: 0ajGMlpQjBx6DVpQIIDm3WlbhKSl91BC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI3MDA2NSBTYWx0ZWRfX7giao0JQbNui
 Wd4Zn8UW6gG2wVF0CDZGGWI6zE8rCxQQ3A9boXimZScxEGRcEvI35lhAHjKqoImzGpe2yl7CSx4
 MYyM9fSS+tkDdYruhYurMPnZIPDbWqT5asG95XawqnW7tALsG9DKYSeDisNF+FzNgZrOYaVhtB/
 7+wU05dIUOIIq180L18brp+rf1ezmGYioETmpq4+G86pHDm7EnHbfUoJwywkmGEaXtBgHYDspUg
 to9nV0H4VkK07kOVilGBv4YnzviPiaIwCIsNuREX4bPx26p8/kuVddDvgHMQyE/3bk7/pxO/q+x
 ciE+Or8zsdUSgv5kkZ2QfHF3vJ1EmIzvmuAa+zFXBBdoMQvKfLOwP5AYfbjmyWA7jrbcq40jfFO
 I49r7+YneHEh7E6CVV19+R+cKv1bpk1SDRv7Bo/AKmUGdQ2cKuNFKblF0g/kSeaup1jYcytduQU
 r6T9MQbiS69tstKSypYQrYTy26+rtBwBOg8l6Lg0=
X-Authority-Analysis: v=2.4 cv=RY2dyltv c=1 sm=1 tr=0 ts=694f8866 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=wPYjH8FkVe3X-gIrlE8A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12109
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D31E100006
X-Rspamd-Server: rspam10
X-Stat-Signature: 879tjmhmiuc7uzebsuygrdias6344yao
X-HE-Tag: 1766819951-620640
X-HE-Meta: U2FsdGVkX190yZwvT1pvkCYQgFFw6kUQxWLhocRT8l3JN/tDefQhOI3M2OqOnFN9W0uZIRyyUa8XAzD5Gc1wGDEfTyoGLhkF1Ec69F/A0pmxytP2dolyS8MyChO3rsyXryDLHVph3A38cSZaZSaea+J4YdanBlOZ8PFqYrqVOv/bTrmywUds/sX0HiFuBL7p6nIuQC8CpzvU2HxnR293Oy2JgEivFElDPkszHYbPybntCIKYm32pTPSUS753nhkqnR2IQcE/+IfB/EfQ+QapqYBhvY+0s8pSzB8o04OTib1l6y+I/rAEHO7jw3EsXmr/Yka+AX86FoxEyhJc4UjtwovVEmciQ5YmZzq6J+MkL3zr4jKvfDyiWVzUJUJh8KD88OE2V13DNJf7Rj9zEaYdpNy/KqcTlZuBqONSmQw0DMBsbC0rOpoSlVh0V1wTkivIXcvjvjSCaMcJBh1+rPxfw7sNWRyVXCTWGYrjm5T337me6GzNUadvTxRV3pEzEFZflP4tJqT1mncYqmM96DkWDamPYpkGBT2HzTcZejZUAj7T7c3rLeB6lYkJSHatJlSq3hoDK0zJplpad/3omcJXKm0+5S/Mruroa0YHzwkzQ/EW925bnPBdolWFfo56Dhi+Vd/YHiV5X1LkOw+7uwcMYpFnTRKJuwxAINBK6ow2qwPEtfL9koH/1IVlAAuzWHdQ4/gxn1XkEE9NC3VZMqYANp4+j7txG6YG8Y8iwajBFq253QjtMLF65PY+5ItDCLUHOgZfenojuGgtDiId9DPeDGQXswn9BR5F1h4oMw60GvNS7Ch9U3s8yhed0h/Zf7Lw4lJ2EPA0bhVHGJUdvLzoFFnocpsQlsIKpc6uaf41eMwxuy519waMmvXrhxGIiN0fmQ2TXGRp3PLHt+qmXbW5qxRzpRFFMqv0MrhlkZpahGdH71LoR8OCnZMZlP/SggSTXyAJX8WlOjsG/G+27uS
 0xQfxq2U
 8ljwQ4NNfeH3Q3NNyQbMZ4H1EyL4SU0efyP5N83dFCUaPcByJmSehQjoynYBtjT7aT5AzXdz74ayp0m5lNm20YzRi1u38d/LVOKi+uIAiNtWPQDGISGmSJbcPKi3MbSc4BG79NTs0HGOPRpadQ9Ovh026FvgclvApfavvOqStLeZJNxTAB+cSel5NP5R5pZqeuaCKiIOYRfqjImgnk5M6suAPl7PjUAZGePpXYW1cbwMX+4E60FdyWb9GZt5wefISKSMRm7ep7p3Lv2U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 26, 2025 at 07:01:39PM +0900, Harry Yoo wrote:
> On Thu, Dec 25, 2025 at 11:48:22PM -0800, syzbot wrote:
> > Last potentially related work creation:
> >  kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
> >  kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:556
> >  slab_free_hook mm/slub.c:2501 [inline]
> >  slab_free mm/slub.c:6670 [inline]
> >  kmem_cache_free+0x15e/0x770 mm/slub.c:6781
> >  anon_vma_free mm/rmap.c:136 [inline]
> >  __put_anon_vma+0x114/0x3a0 mm/rmap.c:2780
> >  put_anon_vma include/linux/rmap.h:117 [inline]
> >  unlink_anon_vmas+0x58a/0x820 mm/rmap.c:443
> >  dontunmap_complete mm/mremap.c:1265 [inline]
> 
> And then (potentially) it was freed due to MREMAP_DONTUNMAP.
> If it's correct, now we know when the refcount has been dropped to zero!
> 
> In dontunmap_complete():
> > if (new_vma != vrm_vma && start == old_start && end == old_end)
> >        unlink_anon_vmas(vrm->vma)
> 
> It calls unlink_anon_vmas() on the old VMA if the new range is not
> merged into the old VMA.
> 
> Hmm I'm having difficult time understanding how the commit 1583aa278f5
> ("mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success")
> is supposed to work when the new range is merged into an existing
> VMA (that is not the old VMA itself).
> 
> The merge will succeed only if the other VMA doesn't have anon_vma
> or it has the same anon_vma... which means we're reusing anon_vma
> of the old vma, but we're calling put_anon_vma() on it?

Hmm, no. I tried to write a repro but it didn't work because we free
an anon_vma only when its root rb node is empty.

Looks like I'm still missing something; How can it be empty
when it's actually in use?

-- 
Cheers,
Harry / Hyeonggon

