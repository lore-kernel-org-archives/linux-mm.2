Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9EBAD778AE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 20:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 579F56B055C; Fri, 23 Jan 2026 15:13:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541676B055E; Fri, 23 Jan 2026 15:13:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CDF76B055F; Fri, 23 Jan 2026 15:13:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 282396B055C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:13:00 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E354259C6C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:12:59 +0000 (UTC)
X-FDA: 84364327278.30.04B4F1C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 881D1120004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:12:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qfFWgcZG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nwIffVBh;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769199176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TnK8UCwbs1UCNJjabizfDK4HYEur2xyLX6kiZlAg2sA=;
	b=Opk7k84x4KoUVk5ZsXUQTcd8kKI9G3Gyv6WK5OmErWX0hJROrS1WreqaCGgUd52blIG22f
	MXroDScBixTipdcvhs1dk9P2xxFzQvg3Hpo21XW9VStXZ9BbpOOTGrb4ighIdN8F6HV36p
	+4rLdwyc9P6prw7sYqtRzrveC6EW6+I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769199176; a=rsa-sha256;
	cv=pass;
	b=u1VrEzNQ5L4CwZmOFGAjjr2bJUUrjhuaG0eUxhjOjDG0MyKSOmWxvNVZl0C4jnWZK/TgKz
	LLFmKKxcLAjyIwgH9UTfxGku4Jo9bRvnumUSZQ+gN+VtgBv6FrMo4QzOUA/wPQKcBDlKCo
	+wmuPHNQD4zxZxSzE6t7Hjpz3XsDsxw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qfFWgcZG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nwIffVBh;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NE1Zl02271176;
	Fri, 23 Jan 2026 20:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TnK8UCwbs1UCNJjabizfDK4HYEur2xyLX6kiZlAg2sA=; b=
	qfFWgcZGXtn8sCWKyn6XSZDm+TFALrhAeGdDgkxO3mrnUF5A57b6Ol5xla6CiBwt
	IxaHw+zWFJ0Owp6pV4QxAqRNahBG9xUU15Zp6N0X/WD616poBtw3aRxezjDZeKCQ
	//l2kFD5BcWMMk69PKiD8uMvYvx67nLqz6k7VqsYbTDpH1xjcNtGPnDXCh9MB5TZ
	PXFiUf8GTacqwlqAZ2t7e+/E+i026JKF6x9fWbajkACH8M8Wvv1ZWVd2tqLCeWsV
	ycFz/fZV/Wj1X8yyzxsouCo7E+mKTfAHKw/ykV6vLd8Y79RdObkYDVPTvlCbl/Yu
	y4ocuFrfFBPL0fYcmPd6Rw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9u62t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NJlkOa038344;
	Fri, 23 Jan 2026 20:12:42 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010022.outbound.protection.outlook.com [52.101.61.22])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4buswcgwq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZWWg/KUdSc8dLh7ZO7YFOHcS+4fFrNO3BgRi908U6njmWYpAVAzQ/gtfpukdNPqVZMh7+xBDHuW/2ugj2X281/yH3Oz0ZH/t/lngdruFTjIEDHNTJjSYp95MHCHTi7mn1AFoBxjc+REV/yZ4GML11XgZeF5hWoHVXP5IGjAlcHjKYTf6wcGCsuGr23FG3S4UdCF3Uqdd1a5fuzxkjLh0ICFQb8hZjMRlr/DeR7fOWURrFgYaIgp+STXUi6tQptPQreuCl92zWzNZ+UJSwuJrvR4YKBm6FCYcykn2ewsmPlfEHN1uQzAAcBDhojvbDtdK9Hp1VA7kJQTbFD+petm7gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TnK8UCwbs1UCNJjabizfDK4HYEur2xyLX6kiZlAg2sA=;
 b=svg3TdttXE/8qKtM6yRKCZ44fvZyVAhUyMcD785yLSF8AYomiEuVFw7Ds5nMElljqKF0ESkztBs/rY65YoCOT7Rpr5guM/P24vO04TOlvOup8v+AEmljTQGwdHMfwGPMLaJRjRsE1824lpP+gP4drboscYRJYihesuEJ6Q1QnhZQkj6v5EWnKxvNi8zRTVwCLBXNuEcsSyZ/hjE3vvwYFIntV9eXDa7qjGCwHNamXkNhQQRVyjs1F+0ZceOXbrU6ezl37lg+VEDtnR95PxWxAMivUTlRlROOMEpvq1P/avT7wR1xU3tgB/gEeOVu5QEtlEiJ6iwDIqVlWS6wQy8C2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TnK8UCwbs1UCNJjabizfDK4HYEur2xyLX6kiZlAg2sA=;
 b=nwIffVBh90nxeKob9PgGecFVjJEImhd3idiH3xV1SdlMh2w7cBCC+2zhyazaodH4bTYTtQISW5zJfSOxYI5mnQuCfFxnhz8azxpYZNePj7rToWFXzNbh93xZlFKAiOME+Cv5gOj9uLtfKeHbIGbUCOnc4/zamfriah41c9RsEGw=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB6877.namprd10.prod.outlook.com (2603:10b6:208:423::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 20:12:39 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 20:12:36 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v4 07/10] mm/vma: introduce helper struct + thread through exclusive lock fns
Date: Fri, 23 Jan 2026 20:12:17 +0000
Message-ID: <7d3084d596c84da10dd374130a5055deba6439c0.1769198904.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0074.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::14) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB6877:EE_
X-MS-Office365-Filtering-Correlation-Id: 35ef30a5-1d91-4025-a3cf-08de5abbc02e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CHybtkQua/o7fDYtsajv2jnEKrq/JYjkUDf42yrcfh8QnDfrDGEkfwx+Ldec?=
 =?us-ascii?Q?uCFZx7T2pHE38rq2/YyNsNsRb/4bSo2tuXtxDRM5qHlBJF1Imp5oVmmGTRcl?=
 =?us-ascii?Q?f3wZmAVJR6ZOppITr1wgpxeVMxiBNVYy3kabkJiImWhPKcyx42biFUsPoOOt?=
 =?us-ascii?Q?sHBNNK66uuaSGT5gEdGqzDtu8PzoZnvv1OpPtmE8RS3bjwY+sh6nLtx4Vvfs?=
 =?us-ascii?Q?/2rSUkT2rkVUrQfjaH0Cm3PS8mWWe4gX6zbanY66Q0UUIX9KsEPrHd8DwvGY?=
 =?us-ascii?Q?ch8hMfLnycCWbU5iRi6kKMJ1VeoRqdmYFjSPkypJIIATOO/t3DqSa4P7X4P/?=
 =?us-ascii?Q?FbYsffa7lwvv/M2kMj4yxl9m+Hgwg/lWRRT4oexS0rWCS1m6exKUa0+f0VO3?=
 =?us-ascii?Q?YpcgI0M3sS+CC96knahc8Q7TnfMQpaPKy3q4dlqwQfxMMsVBhr8Bm9ovptDl?=
 =?us-ascii?Q?Px8qis+sVzXe+ugeUpN+4JAeQOziWFmusdeHN70rAQ1ufEwA/LWoGbyk658B?=
 =?us-ascii?Q?7DYHUuwQ3QqjIR7/LZEeMjx2/I/U4fDEQ2qOMHW2HaSuq2Y8MySQBNj70bBv?=
 =?us-ascii?Q?/EQORvIKeneUMU1lR0KkLMFozaEg+oFiZjW5PZRgUzyjmRYBN4ixD6n7+tkW?=
 =?us-ascii?Q?oIVsgSVnY38GdSpG0MdstoGBII2DK6oPqJTbuLvAmm+F7ft/TL3a/Hc2pVzI?=
 =?us-ascii?Q?j/41Msb68rf2oVPfKvM5MiajnFh9OdiJSm79fTnvaTlAQk/VCqIxAh51/C7t?=
 =?us-ascii?Q?BXBjzBt7pOvss2xB5AFCi+GwS+P6gPqFwu0Bwo5iLjMcmgWOVJaImlq9drVY?=
 =?us-ascii?Q?MKeANYcsjTF3UGSiZI8mYesFz7i4V5Wyj9AaWrUh/ftvoyAGM3ThHiFUfvtU?=
 =?us-ascii?Q?+Ryz9j5R6DTiQqZmi4j3tkSN4BpPFqEu+aOOa9fi933ol1oFwvfLcXVW6fQs?=
 =?us-ascii?Q?Q6XtddwV2IxfFtYgNxLya2s31+2ZWmyIKp4iwZkZDEaRwkoID/voEqUDM9wm?=
 =?us-ascii?Q?QhgfFFafOcD3J6MXOkop2ElcbACkn6kpOvs7C8ZpGxAPleBHVFgfdp+hNV4S?=
 =?us-ascii?Q?3fSzmjiQ/84AfrbCmvhTRAt/cKEJyRmicYha1jv1HV9YRWmPVrkEVaxvzl1j?=
 =?us-ascii?Q?hP+iPoD4qvz72KWkIO/GrUPjiVJnt3n89m1h3kHCgSNor/U1oeE9Eyiu0s84?=
 =?us-ascii?Q?M2EpcLn17Y1+jAHy0qmdoZino9EfMfWyAjH+0TwL41E5YcfvmCPDDKQmGuna?=
 =?us-ascii?Q?oVBO3gwX3i51nuJ+chgwmopiu8opzbyHfqP9Eda6+PMeihkrj3+7q23kKsHx?=
 =?us-ascii?Q?sK5u+BQfJORksxEgyjE+Yq/s+qgB8KnxYA3+RfQDZiak2yX7Sdn6342/8uM7?=
 =?us-ascii?Q?EthlYurciIfw1Oq9B0Pi+SGnZq7q+H2GudlVKE1vgQzcB3WS/OseObS9SVl3?=
 =?us-ascii?Q?UNRtCf/i4UPFQK/wrpGJh8XMkXe+rcY9bLDRcmG+vjAjpKRFf36FczwEQHWM?=
 =?us-ascii?Q?Y2i17uEuvySqEuq303xGfqEoE3IsK7ofhGpxkRCnMtxpaoQeIeRGxgl2LFRd?=
 =?us-ascii?Q?cvXGb4fyJ9XQ+83GFqs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rLbEVWBwJinSmKJs3AI1zZ9WnBQ5Ne9mX6jzVbnl6/9q9BDMiywNFtMJIdZj?=
 =?us-ascii?Q?kExINwK+G4E0elWHw76sD3arhbXplpa1uUXr2ehITAToP4SlB23wkozrZgv8?=
 =?us-ascii?Q?rdcRq6F0RSy7tOwabZo2/sVvPPJQHnMjP5Lc4T5xl4Ig4htso7HHtq/dp6E8?=
 =?us-ascii?Q?aPbE7FU0j4E/wd3ZIPIq3AAg6QrxF4PPjyzBM9T3fCNpwSG1GeG6eTaN9bzz?=
 =?us-ascii?Q?qDkUms3G+hN3DCFhKfvz6QxMepGDFyJaxNKc5ybq7Tuva87pkcOUNkTdFkKu?=
 =?us-ascii?Q?m64Bg6N2yXkx9jHrYEIHlZyydeidGQClrNjAc5JEBUbqHdgIeZpAG+u4X/aF?=
 =?us-ascii?Q?kr0V/zgSirhbNkQAaI8j2sIrgKq/MWjCsaXjq1lwlAt8wiPBBWd1AYNbPvpM?=
 =?us-ascii?Q?DakP3OKN4KeKTP7LW5lFm3KSBUCLiXG4zJfW/4YT9bVBC7OoN3TyISO9/naq?=
 =?us-ascii?Q?Sv+4sXq4lEqGfENrnZLhedpGYUh9I0IFcaNCv2iMss4zXxbtOHr8C1eqDqNT?=
 =?us-ascii?Q?6x1ZBIWMvNRKpjLGw0UQOYRsqsjNRjzkUtZOEvqz96PtHw45VA/pKZ3dElDg?=
 =?us-ascii?Q?02+GLvieKtZ7NRudwHzlMvVqmxbQiETZ4UDMzpaFKghoM5T3UajVuoUwH5td?=
 =?us-ascii?Q?as71WymjrTwMhBtFnc6WAHdQFttByUzu+GYQjDRBSIw5r5Ro43xqWjENua6L?=
 =?us-ascii?Q?jnsYmnR2N3wnBXbDx3M6JkPiHdIksqnFPIvuKoyj+1EEWXx/oTFUPDRCMd3I?=
 =?us-ascii?Q?0EHeOFJDVpU9F6JGOIROxxowSHjKGCuZ2JOPSBJX+LH9utfwEV40hZSOHwwN?=
 =?us-ascii?Q?ryG4RwMvj1YvLlDdc5lfCOGf8yuupNkp0plfOPfJxuxBkPvGslaEaYF4afgL?=
 =?us-ascii?Q?3j9wtOx9PZtlyU4dLYK8CDDlGesHG0o4L3farWMqGjiFH+iKWrtcP4/aVRRq?=
 =?us-ascii?Q?EmRLZuTibgqKH0BRJnDfp3uLkq2kMjhzkp+weZXxgNhQZB4OQF+XGjA0RdcQ?=
 =?us-ascii?Q?+yomIOoYnmZS1xZMQWEgY2hlBVGxNFC3VXb9CcrLJwviptAGByK5sAtBT13j?=
 =?us-ascii?Q?8Tlo67Q702KfX7RF6/3iGfHV2Fl6LN/xxf2rwnC+kte4xLHO9xNxjSIh+ugP?=
 =?us-ascii?Q?v4r9Ry2N7l9eoChIdu8px4aGCHLBfYb6NntxY2VXOgXsufZqWjS6emqQiTs3?=
 =?us-ascii?Q?mjqMa8z3EPJdIy+A+winll/Bq37hZr6UheUv5/zBAJHBejEqPr9eclzAuVeG?=
 =?us-ascii?Q?Bo4yde2vrWmuxSGdrpKlny77J8lOoaRiUjrhdQIq/QuFIClDqSInlEXgWsHN?=
 =?us-ascii?Q?lEnHglCd+MbAkcQKfUHBD44O/Px82fAxnm3pKy+MRpC/877kp4X+qDi3DWlQ?=
 =?us-ascii?Q?7UFC+v0xHHrKjOe1Q/yVaOt4p8czAk7iepnqhwrlyktuXD7rP0B0s00FAb8o?=
 =?us-ascii?Q?82ADfLjWyP0NN516upecAkRQ17R9QeiA/5EIoEuIgnwCfEOg3Wpqfm4W7fFO?=
 =?us-ascii?Q?dtfzkpYvRt5BlW8eiSDJJl1ngJXPIWMYQEgQxwMgXBNpvBS8Xu748NyqRpHL?=
 =?us-ascii?Q?enH7EnWTe+5akiflW+or19LUe3b6slsQ5GJb57yTP/sYQSrOBWeGBQ8IKQBv?=
 =?us-ascii?Q?1czhNp5327/NcOExn4BMppjfQEpq8PRqbWuLV83RNpM+Y3TVRBG/VEaom/D9?=
 =?us-ascii?Q?1DfKf+Jc3d0WlrYiTM0XZXWJVehP3ptxLq/eZ8MqNc6IUaayOO0QDCaknJ+r?=
 =?us-ascii?Q?yUppi+xZcxZxE2IBcCeaSXREXUDtRjA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T2Kr2+OrlI0IwZKh+3VL7VrGaHZ32gustSiHiws10kAeYfPTsF7AXvHc9jHoDjZzyDf2eOG3St4Kc+6Fs9KyZ5o3bdPOxg3KosQ3uWzWj9gb4fSd2ThA76ISb9Oa7eBIiSUxN+pwF5Xcrd+yw33SlauaVoVV9eS/kgi+m46ZLwlU5230Jd6Ds2upwSxCd9Z8MT999k2GX7kSaow9BaBwrw8W4dkMFzC6DFRSgNPpCNqcY5DIgKbgutUkiEu8x2yMQk36EGDMTqaRGnW76dCpcniL0Cy+tNeDZWRX8BvVA2qdBHlfwVGYOtg2Yc2fh8O0PXo49TJSDCu9WTdVc+azNkSeTbPtuBfHGk9KVevN6YSG7isk8pZOztdUrnXYfM+l9PdmvrBoLdLVMTRoNJSt4qqgPqk5gs+bM5OUjz+ZWo1OT0Xsc9ZpK737cqKqndJ3rVtkMyf4WnYfuzv/YBqGk2OT6FAYzeYtqGpii7YPBkDoELtmOwMZBmr/y183ZuJ0PuNREDiSRCYqUEM54P2PzFveaH6c+9S089hpOGRubsLdm0qRL7jLfV0pYtEa88LxO5UeeanHw0aOi3Y6ejF3HDjXAw+UnpygFkYeBw++GBA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ef30a5-1d91-4025-a3cf-08de5abbc02e
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 20:12:36.3964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vQMDaXBpisY3hj/Rh4Iy44cSF19DuGl1xA2vznDsFj3yIhFFem1vZ1z23xqV17NDvaU4fldlrX6t9NAdlTSOokzXz7i3CnsHfgEBau/63cc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6877
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601230154
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=6973d63b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=xzpsKmUTARgMkXTVtp0A:9 cc=ntf awl=host:13644
X-Proofpoint-GUID: CetYCZmght7zbC4P9wLHCAENDNId-kc4
X-Proofpoint-ORIG-GUID: CetYCZmght7zbC4P9wLHCAENDNId-kc4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE1NSBTYWx0ZWRfX2eU8LY7R3kJ6
 c3QNoz0h2P1aLfB6I7+tKeb893QZri3Ykff907y3/HTBvJhkZbr6hZNUbdAqCtuhQhCmTELd7VU
 xsPJT2U09e6kEsk5ECbPv/QRxZk514p2qWStz97AdOLUVzZIra0CBAtojz6JfwjR6WOOGE04Cv1
 l3vi05qMcwiTG2xdn/Fn2s/l3igKL/8BJNN7xithPAz+w/pK9X62Zxl0QvD4kaPfstjT2fPQvdM
 PupCBEbRsIaYGQK+2na2iMWn57QlCBI5sSQqAbu2H3iQrP6YpMbf2Pwh7252G7qZiU5nd4u1dq9
 WyjgmxnRpKxcPQ/BxlOWZgT0r9M8dqrLs5JMBcW5J6mYCbNUDVHC/lRralK+4m2MdD/7w5T+qpM
 xNcRYyDaFIthm5AUJYEF1gvJwnAwnGImMTJK+i2YIYxoEN/WVc7N8XYTWqSKVqXcFu9liBzxxQT
 bl8kcjiUMCKLiqWuNv4JsN0Yvj67iZ3Io6ahPLhY=
X-Rspamd-Queue-Id: 881D1120004
X-Stat-Signature: wxeq9jo8diui7q4osh6ha8b4fgdz8gu3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769199176-252608
X-HE-Meta: U2FsdGVkX1+dk9B1o3qVZPvW03nlDDp+pJ7ruwh3espM2vLtD0gZaSPmPQbpFu5q1De2zc5V0Xx47HkXhsyWRcCd+Gtq+VFMGp15+ZbrxHZOK2MKjVvA1chDmMqmnS3o79wJlg20p0OflH2Mw4J0nE4nO7kSXij5XW2XSb6yLg0MQMoE5TXBpXoQBKn5MprDARiMWBk7aedYAeGaI8jwMSTTmv2FqX43aJPdA2PlFLQwqDogcE6rbZNgdqxmrA2ra34sYeHSADfp48OcDlYr9ZIfZkzYeNTtrwYqdNb2OMoSnHK9OuR51kL3VSMBtBoi/o6ekuMZ6Mkj0oBBRxRjkNfYMR8B8l/B/qcb64umztDfkPyqsT/u+giZJBMCnX+SVduWyXohSGovL0SLrMuEpNbg78QozP/k2pBRGNeQXhs5jZCPqo18WgKvTb7WKWPC2eLNcXU9vrAIYW1JSfuGKaorutSF34G8mdXjwHilZ3rJifnkZ3iV8aC0jzJvmlHf6MNruP83HgZLTur+iOV0X56EGx6hcagVdO7PQqxH5VK6K0lKoCaICFiU9v55faGfZbgVU//0WYUTDITP9sV+NTCV34wKktsbq9IBfdMPTbS7K4DJyOD7mBPNtHSVsuhH544rW9oJADAa+KoVakCmaei4/4G4depNnmUSkbfIRofoYZvPAbqSOV4oQyPHwvhR5eYUtz3GbPzDlKsGMeqHkIz7c0DCYFAT9I3SxyVrvQAPjxNB3dI6vTn8YcbKC1taiGZgM90mev1ueJ3E7TwxVP/wt06tRUkdZLsE/f3ZtV1ep69mF4I80t2JW4TQYE1X98McvhMxs4IA+HYuvVZ5bpoxOSAGluYp56iyTY+LGxnDJGsyy7e/Kc+ghuQz5H6tx90QyoszNgyyiFwUpTLBI0Z6LVWMb3pAJptUoCwc/QQYXmD1CQ04rOaF8n6mVM1Pbo/+vLRzw/8r05EGToc
 VzJujv0U
 /fpdh143H8qOt/9Ly7EcSZFWvet9caUYzDf369Av5Mmw1MH7NpnHE141TbMTacprJgTb/LAgnIO+suYwch1iSqGffwyIV8zITZrne/b2IXsvPbFwq7utTvx4+rknQjost8nZMoSZNF4DwIC+tQb4QzWFMpGc+KrIKKR687E+BrOlqp3ZBSAYYFUW8iyOrJTRYHi6Os8Twc9a895wkk9AhLMWTk9lYX+js7XVBUiYQ3She/FGwgzvAJbiQDM2mREdXFIbGtjU+4i0bhH4Jnyw7iBy+EGsW0bHAHGGWXVcqfUCp7XzcfBR3VCJ6x0zHUA+xWeSkVTsGZLKprQHHUsh1ykx4GS8XDCv2INY5eNK4JjZ8k80U6vR8b85CRvFOIa0F8XAlPp3gOJ9nj0Bx5Y70QWceX2eU73Fx2Xvn4AOkOGHTs+BMRnKjsAI+IDZif049MFU/hSnBvnBoRR+w2kWRpJJD381ARudmXD68ppmDFYkUk4HRtRhU1p71bW7CslaPdfRwOnIPF6UaC1dM7kHkPjogkHzGTGrYh2B25BJUSj6+bDl1jXxtNtr4nxBAKcJPLqQjMR8F9Qmrg0S6aKv0pWUbHTcxS3rNg4RD6OKcibUxBxG4/V2Mbsn+ZsLvx/K8rc1UT7oTMnVv9rULUoUMh8sjG0h1SFhDvdVHlguCfwW8fPH4Rbc+ltCNIZabj+W+cFCAvknPz24+fPXT+RrLfRqawQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is confusing to have __vma_enter_exclusive_locked() return 0, 1 or an
error (but only when waiting for readers in TASK_KILLABLE state), and
having the return value be stored in a stack variable called 'locked' is
further confusion.

More generally, we are doing a lock of rather finnicky things during the
acquisition of a state in which readers are excluded and moving out of this
state, including tracking whether we are detached or not or whether an
error occurred.

We are implementing logic in __vma_enter_exclusive_locked() that
effectively acts as if 'if one caller calls us do X, if another then do Y',
which is very confusing from a control flow perspective.

Introducing the shared helper object state helps us avoid this, as we can
now handle the 'an error arose but we're detached' condition correctly in
both callers - a warning if not detaching, and treating the situation as if
no error arose in the case of a VMA detaching.

This also acts to help document what's going on and allows us to add some
more logical debug asserts.

Also update vma_mark_detached() to add a guard clause for the likely
'already detached' state (given we hold the mmap write lock), and add a
comment about ephemeral VMA read lock reference count increments to clarify
why we are entering/exiting an exclusive locked state here.

Finally, separate vma_mark_detached() into its fast-path component and make
it inline, then place the slow path for excluding readers in mmap_lock.c.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm_types.h  |  14 ++--
 include/linux/mmap_lock.h |  23 +++++-
 mm/mmap_lock.c            | 152 +++++++++++++++++++++-----------------
 3 files changed, 112 insertions(+), 77 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 12281a1128c9..ca47a5d3d71e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1011,15 +1011,15 @@ struct vm_area_struct {
 	 * decrementing it again.
 	 *
 	 * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
-	 * __vma_exit_locked() completion which will decrement the reference
-	 * count to zero. IMPORTANT - at this stage no further readers can
-	 * increment the reference count. It can only be reduced.
+	 * __vma_exit_exclusive_locked() completion which will decrement the
+	 * reference count to zero. IMPORTANT - at this stage no further readers
+	 * can increment the reference count. It can only be reduced.
 	 *
 	 * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either write-locking
-	 * an attached VMA and has yet to invoke __vma_exit_locked(), OR a
-	 * thread is detaching a VMA and is waiting on a single spurious reader
-	 * in order to decrement the reference count. IMPORTANT - as above, no
-	 * further readers can increment the reference count.
+	 * an attached VMA and has yet to invoke __vma_exit_exclusive_locked(),
+	 * OR a thread is detaching a VMA and is waiting on a single spurious
+	 * reader in order to decrement the reference count. IMPORTANT - as
+	 * above, no further readers can increment the reference count.
 	 *
 	 * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either
 	 * write-locking or detaching a VMA is waiting on readers to
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index d6df6aad3e24..678f90080fa6 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -358,7 +358,28 @@ static inline void vma_mark_attached(struct vm_area_struct *vma)
 	refcount_set_release(&vma->vm_refcnt, 1);
 }
 
-void vma_mark_detached(struct vm_area_struct *vma);
+void __vma_exclude_readers_for_detach(struct vm_area_struct *vma);
+
+static inline void vma_mark_detached(struct vm_area_struct *vma)
+{
+	vma_assert_write_locked(vma);
+	vma_assert_attached(vma);
+
+	/*
+	 * The VMA still being attached (refcnt > 0) - is unlikely, because the
+	 * vma has been already write-locked and readers can increment vm_refcnt
+	 * only temporarily before they check vm_lock_seq, realize the vma is
+	 * locked and drop back the vm_refcnt. That is a narrow window for
+	 * observing a raised vm_refcnt.
+	 *
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
+	 */
+	if (likely(!__vma_refcount_put_return(vma)))
+		return;
+
+	__vma_exclude_readers_for_detach(vma);
+}
 
 struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 					  unsigned long address);
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 72f15f606093..b523a3fe110c 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -46,20 +46,38 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
 
+/* State shared across __vma_[enter, exit]_exclusive_locked(). */
+struct vma_exclude_readers_state {
+	/* Input parameters. */
+	struct vm_area_struct *vma;
+	int state; /* TASK_KILLABLE or TASK_UNINTERRUPTIBLE. */
+	bool detaching;
+
+	/* Output parameters. */
+	bool detached;
+	bool exclusive; /* Are we exclusively locked? */
+};
+
 /*
  * Now that all readers have been evicted, mark the VMA as being out of the
  * 'exclude readers' state.
- *
- * Returns true if the VMA is now detached, otherwise false.
  */
-static bool __must_check __vma_end_exclude_readers(struct vm_area_struct *vma)
+static void __vma_end_exclude_readers(struct vma_exclude_readers_state *ves)
 {
-	bool detached;
+	struct vm_area_struct *vma = ves->vma;
 
-	detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
-					 &vma->vm_refcnt);
+	VM_WARN_ON_ONCE(ves->detached);
+
+	ves->detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
+					      &vma->vm_refcnt);
 	__vma_lockdep_release_exclusive(vma);
-	return detached;
+}
+
+static unsigned int get_target_refcnt(struct vma_exclude_readers_state *ves)
+{
+	const unsigned int tgt = ves->detaching ? 0 : 1;
+
+	return tgt | VM_REFCNT_EXCLUDE_READERS_FLAG;
 }
 
 /*
@@ -69,32 +87,29 @@ static bool __must_check __vma_end_exclude_readers(struct vm_area_struct *vma)
  * Note that this function pairs with vma_refcount_put() which will wake up this
  * thread when it detects that the last reader has released its lock.
  *
- * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases where we
- * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal signal
- * is permitted to kill it.
+ * The ves->state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases
+ * where we wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal
+ * signal is permitted to kill it.
  *
- * The function will return 0 immediately if the VMA is detached, or wait for
- * readers and return 1 once they have all exited, leaving the VMA exclusively
- * locked.
+ * The function sets the ves->exclusive parameter to true if readers were
+ * excluded, or false if the VMA was detached or an error arose on wait.
  *
- * If the function returns 1, the caller is required to invoke
- * __vma_end_exclude_readers() once the exclusive state is no longer required.
+ * If the function indicates an exclusive lock was acquired via ves->exclusive
+ * the caller is required to invoke __vma_end_exclude_readers() once the
+ * exclusive state is no longer required.
  *
- * If state is set to something other than TASK_UNINTERRUPTIBLE, the function
- * may also return -EINTR to indicate a fatal signal was received while waiting.
+ * If ves->state is set to something other than TASK_UNINTERRUPTIBLE, the
+ * function may also return -EINTR to indicate a fatal signal was received while
+ * waiting.
  */
-static int __vma_start_exclude_readers(struct vm_area_struct *vma,
-		bool detaching, int state)
+static int __vma_start_exclude_readers(struct vma_exclude_readers_state *ves)
 {
-	int err;
-	unsigned int tgt_refcnt = VM_REFCNT_EXCLUDE_READERS_FLAG;
+	struct vm_area_struct *vma = ves->vma;
+	unsigned int tgt_refcnt = get_target_refcnt(ves);
+	int err = 0;
 
 	mmap_assert_write_locked(vma->vm_mm);
 
-	/* Additional refcnt if the vma is attached. */
-	if (!detaching)
-		tgt_refcnt++;
-
 	/*
 	 * If vma is detached then only vma_mark_attached() can raise the
 	 * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
@@ -102,37 +117,39 @@ static int __vma_start_exclude_readers(struct vm_area_struct *vma,
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
 	 * details of possible refcnt values.
 	 */
-	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
+	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt)) {
+		ves->detached = true;
 		return 0;
+	}
 
 	__vma_lockdep_acquire_exclusive(vma);
 	err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
-		   state);
+		   ves->state);
 	if (err) {
-		if (__vma_end_exclude_readers(vma)) {
-			/*
-			 * The wait failed, but the last reader went away
-			 * as well. Tell the caller the VMA is detached.
-			 */
-			WARN_ON_ONCE(!detaching);
-			err = 0;
-		}
+		__vma_end_exclude_readers(ves);
 		return err;
 	}
-	__vma_lockdep_stat_mark_acquired(vma);
 
-	return 1;
+	__vma_lockdep_stat_mark_acquired(vma);
+	ves->exclusive = true;
+	return 0;
 }
 
 int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 		int state)
 {
-	int locked;
+	int err;
+	struct vma_exclude_readers_state ves = {
+		.vma = vma,
+		.state = state,
+	};
 
-	locked = __vma_start_exclude_readers(vma, false, state);
-	if (locked < 0)
-		return locked;
+	err = __vma_start_exclude_readers(&ves);
+	if (err) {
+		WARN_ON_ONCE(ves.detached);
+		return err;
+	}
 
 	/*
 	 * We should use WRITE_ONCE() here because we can have concurrent reads
@@ -142,45 +159,42 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 	 */
 	WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
 
-	if (locked) {
-		bool detached = __vma_end_exclude_readers(vma);
-
-		/* The VMA should remain attached. */
-		WARN_ON_ONCE(detached);
+	if (ves.exclusive) {
+		__vma_end_exclude_readers(&ves);
+		/* VMA should remain attached. */
+		WARN_ON_ONCE(ves.detached);
 	}
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__vma_start_write);
 
-void vma_mark_detached(struct vm_area_struct *vma)
+void __vma_exclude_readers_for_detach(struct vm_area_struct *vma)
 {
-	vma_assert_write_locked(vma);
-	vma_assert_attached(vma);
+	struct vma_exclude_readers_state ves = {
+		.vma = vma,
+		.state = TASK_UNINTERRUPTIBLE,
+		.detaching = true,
+	};
+	int err;
 
 	/*
-	 * This condition - that the VMA is still attached (refcnt > 0) - is
-	 * unlikely, because the vma has been already write-locked and readers
-	 * can increment vm_refcnt only temporarily before they check
-	 * vm_lock_seq, realize the vma is locked and drop back the
-	 * vm_refcnt. That is a narrow window for observing a raised vm_refcnt.
-	 *
-	 * See the comment describing the vm_area_struct->vm_refcnt field for
-	 * details of possible refcnt values.
+	 * Wait until the VMA is detached with no readers. Since we hold the VMA
+	 * write lock, the only read locks that might be present are those from
+	 * threads trying to acquire the read lock and incrementing the
+	 * reference count before realising the write lock is held and
+	 * decrementing it.
 	 */
-	if (unlikely(__vma_refcount_put_return(vma))) {
-		/* Wait until vma is detached with no readers. */
-		if (__vma_start_exclude_readers(vma, true, TASK_UNINTERRUPTIBLE)) {
-			bool detached;
-
-			/*
-			 * Once this is complete, no readers can increment the
-			 * reference count, and the VMA is marked detached.
-			 */
-			detached = __vma_end_exclude_readers(vma);
-			WARN_ON_ONCE(!detached);
-		}
+	err = __vma_start_exclude_readers(&ves);
+	if (!err && ves.exclusive) {
+		/*
+		 * Once this is complete, no readers can increment the
+		 * reference count, and the VMA is marked detached.
+		 */
+		__vma_end_exclude_readers(&ves);
 	}
+	/* If an error arose but we were detached anyway, we don't care. */
+	WARN_ON_ONCE(!ves.detached);
 }
 
 /*
-- 
2.52.0


