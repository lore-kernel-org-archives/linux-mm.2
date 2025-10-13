Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C998CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 11:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74A78E0032; Mon, 13 Oct 2025 07:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24FD8E0007; Mon, 13 Oct 2025 07:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5EE8E0032; Mon, 13 Oct 2025 07:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B44058E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:33:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DC3DC03B8
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:33:43 +0000 (UTC)
X-FDA: 83992881126.09.8897433
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id D038A14000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:33:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="S0/nl6eY";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pH40VPsk;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760355220; a=rsa-sha256;
	cv=pass;
	b=qJe2aAHpUVBW+pUQ73aZZOuHZpPiQebZcBmEuIUp9rOseI6ol38S0X/zsRPhpt2dom6xeI
	Rps+rNg3flGaefiOVkDbm4xrv6ZspvqQvSxXwd55YLDRz7jRtAlAG5us0/gIrw/nutgN/V
	lPdBztlIetbthskaLjVBUaw9Z8I5jns=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="S0/nl6eY";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pH40VPsk;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760355220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTiyGHYPAC7DBTZZjNkM5rJnHr9NNWkzZID0VveNj6A=;
	b=489YFWk8jEgt+npfr9DBzU3fw6ImxCFi8Ga2RU8kMbTk+62f6kwb5NS6ZjHJJqLmV4bq8l
	sy7TChnELSnKWv9AUgnNMx+hmMAWMUlJYD/l4/DSEBjyXp0K67VoY4Krl37veVBXfd0BWn
	/QDbOHnANgOxpNdYHbarulI1Wj1PihQ=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59D7u6Kf018623;
	Mon, 13 Oct 2025 11:33:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WTiyGHYPAC7DBTZZjN
	kM5rJnHr9NNWkzZID0VveNj6A=; b=S0/nl6eYk4nQSVVGfyisld2sBTbJyRw0Vk
	gPbk7Q0tH6gAmqpTaPH0ic1xF4+kv/u09f3i+GXmRZjz720poDO3HQduvNHtDYed
	vWgRHCgZy/j5m+whQDP/j63Hok580FNwiFvUeGrRrFOIZy0UmFRvRAXSSLa4kC6B
	1OvRyulJNaVu0u/mL/XAPjeW6VGDYRDTJJeg4Q8/fnKzQfsEJhraLkWgFWjlh6oS
	k6F525kJTjyxyd9YahnrGfK0eC6oq4IrzyBv7zuTZHYix34M43HPxNlCBdhxwEUD
	pfLwFarrc03lHo93W3v7CbMpWhLphZchYixX30GziOUwh17L+Uhg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ra1q9503-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 11:33:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59D9YuJO025628;
	Mon, 13 Oct 2025 11:33:34 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010065.outbound.protection.outlook.com [40.93.198.65])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp76043-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 11:33:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yuLImExZFBVrg7/1kYAbc9Sxwy6EV74/dn1RDErzBvOTzAxkR3DPMkmzvg3gB24w6yBtyURTUIFR6xah3LY0vFM30PHoyajexZ20oEeeRWMYcfHoliRT5VJwZxtxquSn2+xwjRKEWsXShEpYeAjMcSQjlxf5iIQVjNurPD6xsWn97eppJM8MnS5LldO6r+g1eDUfSgJCXHsY7DVY/Yo/tPg21ka1B3vk/7QhVMp8o51lnuUPktfJu4c4i40Oo5dy+lfvw6xHCeZU11Sp4j5nYuLjUVhEJp9ipH9fAs9uGHRX6mB/B5CLT4r5sOufCtSzVUK0qzs5XQIJ27An3PTmMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTiyGHYPAC7DBTZZjNkM5rJnHr9NNWkzZID0VveNj6A=;
 b=pjzv8a+fNLVjpULoLrnvTq2yF0zfF1DqAZWj6bmzX6Z/2/r+zjpWQq0pU4dpOsQQPGJ1s9JKXSu21VwFFc10i0GiQbzul1k/sjUl+dLXtPRbGw8GfksDP710nI2bklM2DHZ9FlVVsOFEWY3axn/6YDa/J0dfD6BMAHsYQhu1f+bGfXxyErJoAuwOLU69V0gDTSqBcASDW+XobTp2dGKb7OlbeN/3ZX8Ejvcd3gqEMvL4cdAyEAhKuFFF2Dcy5RCeyhonFe3LnzhYAZldM/kBazd8/AUUUUElPk7wsFbgJSwCcSQvF2iv9Dme43madbRQT9jDj9uiOw3q0aZiDCjA/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTiyGHYPAC7DBTZZjNkM5rJnHr9NNWkzZID0VveNj6A=;
 b=pH40VPskgDeZdETxiVBzEqv1DAhpzF9h1QPAlRO1fnG4nj8JDyKdedyBg3FgUljjwqGVAQtTC0567rbUcdsjvAWgBvtikTpyIoawz+S9kgAGwnaByY1J5HIQ88PUk3RLHTmn/NvEY5a/pQpJYUF1ZDiGbyhRTavvNYR07izOSi8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PR10MB7909.namprd10.prod.outlook.com (2603:10b6:0:45::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 11:33:30 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 11:33:30 +0000
Date: Mon, 13 Oct 2025 12:33:27 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
        Ye Liu <liuye@kylinos.cn>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC RFC PATCH] mm: convert VM flags from macros to enum
Message-ID: <d619784b-b967-4795-aad9-6e79d4191b83@lucifer.local>
References: <20251011093054.886460-1-ye.liu@linux.dev>
 <809f552d-3282-4746-ba49-066d2bd8d44f@lucifer.local>
 <7ca0960f-9d1a-4ba4-b074-a6502578b82e@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ca0960f-9d1a-4ba4-b074-a6502578b82e@redhat.com>
X-ClientProxiedBy: LO4P123CA0567.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PR10MB7909:EE_
X-MS-Office365-Filtering-Correlation-Id: 790115b1-3abd-4662-7267-08de0a4c559d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NQzpPQhpGu7SG9zYIZBWClrA4rF4WuAJigmu+/zSWO2lVZU0V9vplK/ooEBy?=
 =?us-ascii?Q?OWjZ1mpmNHT9nB7y6efJl4qxNm4G/7KXoGY5OifaVHh0SxC3YrcXn3Q52/n/?=
 =?us-ascii?Q?+004C0kBQVGA6yrA1qYhOZe/RRCP/U2klcT41BNgWvbtThgC6AMMq37ssu4X?=
 =?us-ascii?Q?O/JbMCnJItCrJaaYle29Nasyypo5qnTThUvZXZ5U5khXUSu9tRPwbk0VnVhY?=
 =?us-ascii?Q?4j0d1rfCmOeHcu6XVNucs4LLKONy/1q5CptBZCI0rsxP1tW0jDZC/VCoUUmN?=
 =?us-ascii?Q?2o4YPakbqQMSWbxEN0wpUjpedSk1XVU+kevEM7XeSzjWgRH6kOhGifQOanKy?=
 =?us-ascii?Q?4xP0XbsH/puX2cdYkXzfa5Vw4qXfmt2ckzWOcIhguf1ehFP97ZiSqi5abe7Z?=
 =?us-ascii?Q?8Y5XsZaUjYDF4yHy2DI1vUOUX8e2OXXea3SiRwk55Y0VmfJiQXg/C5M3CvO9?=
 =?us-ascii?Q?3WpU7kpSmlgHtzWmQX6HpYYmYlQyBXBzmpLd0vhbrJcJLEK8QUpG5Q73YC+n?=
 =?us-ascii?Q?Mqrtqx2qCH3W/cQcacZIDGRO+ulh7d2tlE4dLP8YTNFRc4t/lM3GryDuH3Vf?=
 =?us-ascii?Q?hkdIrMn8wq9h+9NYXM6p8TQeSGu1Pf1Q9zZzP0zwX4tKgggDyFXYuPzTDXcm?=
 =?us-ascii?Q?YnnqvxSeZOvlvHom0si1sL3WHbDjN7XR3jwVcfzBEQp1gTbfEPxXosST10Na?=
 =?us-ascii?Q?Tck8HC/4l5zKQAK/8/ZJX7+zM37Xy4gHWqPBiyMdk04VS5q8a/qoqZvou5GH?=
 =?us-ascii?Q?DBJLfaxwDzWXvtCUtmfpIIX/1tYnvBzaB1aIll25Lsv4sMI3+9x3kcIBeN+w?=
 =?us-ascii?Q?xeLWtkKGSkh3itAMmjgHgSUOvowqWFXjQaZI6t/AVjSqUGvgChgJdU0G1BqH?=
 =?us-ascii?Q?GeB5hZ3f35+12PRgRlnELJxPlXQcyp9jCyGUfM6WNe8kO7du7swP8+Td1sG8?=
 =?us-ascii?Q?SU/KsSonHmhxoTqi5Vb9yGJB7KmYNoTbsMWELWfJs21wyvf8r7ufUrVrwhLs?=
 =?us-ascii?Q?T8tl3RziZXtVTGH5mMUWt92M0nOobW3WomBnx3ovD4i9Go2HxBRDBdIBHWX/?=
 =?us-ascii?Q?aqucZ/BxPn/PDhqU53v3IVEpk+wHX5YoHh9GYiXyfTVNdSDJAqEBNuFtgN19?=
 =?us-ascii?Q?6QmdO2hqhX4bNvGmG2U2INH54wTufroBAlvwR76dodFV7U8L/CBsZAITGwWx?=
 =?us-ascii?Q?yFvQUDf0xid63Di1xT5QBhPpnxpRUaBRmolHbEWmrghdMiECbM5l6jabwh5S?=
 =?us-ascii?Q?u9ONidMSNmxNuD6vFbuzB271U8GJCEKpxezPgWhsvRn57kI0p9YnMXyWDo5Q?=
 =?us-ascii?Q?yZ3yegltEdqR4cThxP2bmocWX22K7+Dw84nxZkcuSxS6wS4turfm5IqXrp04?=
 =?us-ascii?Q?SbijS5xKaWqYA5KGkILIDLrVRoBKWwVIpBkMp+df2/B832jtUi+DbTkOLtZz?=
 =?us-ascii?Q?peZvmAHjXk4h55gQ/oXC0fchR3WCY7tZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Gt0NhaSzosIixzaWAUjGScxWm/S53LtiPCZBbJDJNPUYOTszomY4SXBeZ+Nm?=
 =?us-ascii?Q?pWFrZYTYMkOxm1s0HmHxfu56llbU4XHuCuEXo6Mr2K6FqjCyjQYFsilQToEt?=
 =?us-ascii?Q?fuK8AEWIVpabNQ3amw8BKacT7+eBEYegubVCJDmUCFQ5tX4gkr0rk45/UmMO?=
 =?us-ascii?Q?H+Rpo978A5oZTfcZ0U2bnudjRje2pi4fSnHGMKSg+ABpjx4XNeKIgUgEwYja?=
 =?us-ascii?Q?SoR70vYE0ZwEzrUJ40PO3dl9Zsj0f8iLcBsh2A6FrSDILMRuKHD+fbLw4HrP?=
 =?us-ascii?Q?4DIYW/oQpcMh+eoy43L2o+45VV1Tg1YgmDvXVENWUgaHpWr5wp80Oif+vU07?=
 =?us-ascii?Q?uK2CmHArrUwTsOGQuuIM+YnJor3jwdJD6BMsoQqlgJsw8lWQzwXTJXDD2c1W?=
 =?us-ascii?Q?fliQE/AaDNV7yoFjL8ASTDXmmq85F9oO/YJ7G3VIxaDq3tVXUGbwnAj2Xm7V?=
 =?us-ascii?Q?hxOq3CEq6peNQJDXGBF3J7bu2A8RvB0g7WVwgIw7c3uInFWR7V3YSSkjKMwy?=
 =?us-ascii?Q?TysBFWSwdnhtrKYDumspmqS5vbSHWpCO08JNyePVhEVvf9wfX6WxTPcKgOEn?=
 =?us-ascii?Q?LLJv70VgIId/jVTqC7bFm3tJeQNjs9yeaRuO5XWkNVqoORN1wIqc66FAs8VA?=
 =?us-ascii?Q?73MeLrzM2EdSBN4tjOMzMXWm2jdFY3VNWOi+XdXV8qMUVQyj/1VDfYpoG+y7?=
 =?us-ascii?Q?6dNkbiB5+E/4obQTfWCUmwFlKr/jvswmgskhgrbtGoLRarkyFFiuabjqRJud?=
 =?us-ascii?Q?ZAZrwH++CDrcAI8B+2wOkAkDuGBH3aicZ29H71/3wFig+C6AQ8J0PbVj2TDN?=
 =?us-ascii?Q?uaE5X+fYMhhwksZLW0NB8J2mhfIUwMMeLbFHYPstZjGdmM8aVgFw5/ncdOCM?=
 =?us-ascii?Q?dwjMpgqLAb2pipS/YD/qhF3X06aYBwBtd9d1n46Y7AuigsRL7bQW0ZrEm9d+?=
 =?us-ascii?Q?hjM/WrbaNDR2AYNVZZ7K/EluWjGOd+cuC5wz+wfHxErCYBfn6BpXB667udLA?=
 =?us-ascii?Q?qxn7TZVY56J4V6MVdlmmod38CB2uiKw9mqR9p7Way/pgn30f85xUIfUPzmN5?=
 =?us-ascii?Q?kHZivSwoFwYj9Jl0Ky8i2PoFJI+VSk9mC7EQ9FQyjLkyqNkFDDLVy3CBMKkg?=
 =?us-ascii?Q?X9Fsty7KDz9w2bnfAU2YR6Cx+Qc/50qmnuW5AJV/kMwla8Bc0G+KYhjzNnYU?=
 =?us-ascii?Q?cOvGA6vxx9xuFtXtfm1XtM85DJ6FAqkjSx+ezG7xBV5rI1E1G+1Z6/ss6/vJ?=
 =?us-ascii?Q?LF7ZTr18cKP5d/zZitYz2G9Di2LxHRqBnPBKB0P5FosUkS157FhU75K//ZHR?=
 =?us-ascii?Q?G22B9LKSjTkPjNN6ADo2S48ap1DgbHkB4iRDlAuAPF5wuRoGIi5+1r0fyUNC?=
 =?us-ascii?Q?TybnUWYiqJm1DwZA5amaSjVEKAcYb02ZR/A2YQqVYU67fnRPvZ/dp0h/FBdG?=
 =?us-ascii?Q?4FT/SEKQrKO4qu+JZFjHY43vP1vRKx0k5rWKykieCs4AxfI9m3zjummQCPT1?=
 =?us-ascii?Q?w7x5U9X/Zwx10wp+ZSN9sHZ26b9n4EqWWZKfEoVqMchWThF56YDGogr2NOsR?=
 =?us-ascii?Q?+qQ2zHrkx14QcK6fJK5DZ85NODOOsags3/giaD5KqnZ7UoF7FC6eL3W5wqso?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	050aaFj4it2DEsaDKqAJ3bWxvUwmvjZVywys9vLZUEbm2zvatGaBiyEN0HztN/N9oSIvrct6biWkFUi5Og0EscCTwfMdcKO3Q1/oZfyL79VyLDYY7UJFRyfKW8rdrTJ4Mt287/m5k3svzAeZx+U9b+ENx32Vk6JpDodEq/F3pc13I/gTeNRmdlbhsGOkXAJCxKh0B+8xQftPeGoGh7DuWp/XwA0lZPuiFvWiBAuzI59B2quhLXBrOtQT/GYz527VZs9Bisz6NwOkW9aI1OaRevKuc2v2nH2gXVpN0S4QTxKphnQk8TxZUmzWFnpgSVKxpYbLP/pXnY5nlcXihJl0vaVe6PpXqKF/X7tcxZfd0gaqhsSblSVFAmR0bTIilBgCvDRGJ7E96spqI1Stn5+3HSR86BTR7rx3T3VHaF1q71ZSCxRVoQelxnNWLeaLiTqm+xlgh6U0LPTaXOhHprF17DMURWdG18IJuQ6IPSJkOrQwvzHg4y+51G90HSPeLIfhKS1DOPuKRSjqPED3dRWyex/hlUWOE/T3VY8/uxpY4S/iSCEbC7jSG/RLRlo9cZUOn6ZTckcO1BcIEo3+eKojfttGHJVql4Lil6a7BQzCBqY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 790115b1-3abd-4662-7267-08de0a4c559d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 11:33:30.3987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TBEgawnuQlyZf+DTheWZcq2RL1cm05nRg0xldgruVXUkHSAYKPs/wI8YONN88muLb55LquSWZhQSe+/Dn+8gtmfxM/XrJ2owbLpniRl+0x0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7909
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_04,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=899 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510130052
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA1MSBTYWx0ZWRfX7XeSzN9pcL+Z
 Nydzy0AIVq8z2SOfA7KivaVXWFgW8rSxrbTJRivL2Gja0OvP3Wf5/IsE6b2IBmXcDl8Wme80L13
 9LMvbI2yRmjNrx4VZfOaHnzZttbmSApKwaVeO3PTQ2BvjO3cBHq4u62kKiLRpCqakF2QI9wtH7h
 cPWUOjZ7xbiMD6EUBgVAgfuvaBEzzG0Sn1sk88UEcaQprxsKqhvsQY8KWam4s6lKlH83WRZSCYe
 ofN4dCHYQF/8V+01baxucl+52GwvqigoBnMwmAyNUq3ATSe2Q8qjv7sBO//G50inDAW5w7kZNM7
 /SqleVs2zNzl460myKZJW+jFAQKYOYgzNJHRnJDwy+a/3gqVtJyrbkaKFevNN+3krUqysZM/Biq
 NDEaILQJiw/mIttQsTK34zWSIeJh7B6R3aWrVixVLljSGD+Vzrs=
X-Proofpoint-GUID: zGvR_E8wwCj9JAmFSb_7jD1sOpX8FKBK
X-Proofpoint-ORIG-GUID: zGvR_E8wwCj9JAmFSb_7jD1sOpX8FKBK
X-Authority-Analysis: v=2.4 cv=GL0F0+NK c=1 sm=1 tr=0 ts=68ece38f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=ucfKf2I3wL2XPFNOwiUA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13624
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D038A14000C
X-Stat-Signature: 7aahbmr5pyyr7cqx5oyhaxwo5ubtugmr
X-HE-Tag: 1760355219-29831
X-HE-Meta: U2FsdGVkX1+qjulqqrfhHYju+xUEFzDVTmeW9xhnUMlWhCAeMfv8kZn2UCcNO9Az8apdewUlE35qdEKust/CvRlK85ib/tusIbDAcp4F/vessverPpJK9Ua9UzNWvv93wy0Z6GL0N/S3wnzjjI6c4Js4BHzKq3lVTkmUIywjS+xuserjCLriqtoV7pQ4A/d9UrMDYW+pu9DdwrRmi31D4ODk9etKPTnYB4x7Pc+3fCN1dEC7jo/RZfrgCRs/C3S8/SEJnSfgIQ+vHmvMS7ixtn0OJM8i9DnHZ+C/KMgqTKWgXyB0L83k+CvyT3pe+BNONF4WHEt4Tgsx8zEP5uSUH1mjdnI0cJjaj5hG2fhxWfQmRBo288jcymFVXFEAqlYjRSJBRC5ix7Mem1njd00BqEn7UGnT7lJOCkQ4p/RFr8hUqzbmSzGfDDPIA+/4rwCqAO91OcEDR3lyJxZrloR0YQPkuLX7OI0hZxq8qRb5ySVzegGnwLN0f+YcAhwAH/fdsgBCRf0agQTrqpcV2G7KwpwpZNVVOT3FPSeqYJ5+SSyVoP1ekheUdIYqU8yauLGy26s+VXajJzJiLfVqPCXNGcqzr+kzWWpgLu+6YT9/V884RjibaAYMyhODMTOM4JjOsNiM9rEegnMCRJ8bbQK9jzEHl0DArt/Fj3tRC5AIibMcjOWHrkuEZp4WzgKP8+B/ArYkgz092PO+LruMCd5Nu2D8Y9WZJIaVIEbwF+COZDSgmyq1D7C0BmhqK0Gyn8V+yq2eAN2y/2NAnM2kY98fWTFV1Jx5YuUZi6IntolMOj2F8X+5NM9/WSNCCZfTzcQKS08MEx+3fCuUonQKivhE7LBsxkTLSP+jnEMr9TJgbUMUa86lTqKhXvKp+jCgj4SO3QEYaZCh2zYE35mTP+A9rEvZixyzQvbU+6bHGxMo0fPLCoVNnrAhWmtLr9ZX7IPfvmAsAl2EtqOmh97Sz2J
 YH+kCam4
 FAV1VSruZ8zU06Gm+yQzcXkfehE7BCe961q3uKmUIQ8F6zmQTZuP7uMG8ON4htGuChuk4L6nB3GxHf+tP+xP20o3o0nlDFYrndO0LB6+jDbO4EGIsDIY1ZqYr0o3YR/HlmRMqIj9myrzOA/nYeH6tEKPZt4tMK4LVJs9geOc3+piWAcX9iIGAlxb4q/JKeoyfQM74nGESL+t7eVyDzPKnP/45ZZOkr7bMBOkaTSxX4f9IxlYHnxZysKohcoh42xMlOHfj6FET4i9CFhqgQt6I2EI3g0U6jOWFTIhDd5674Ob/dE6NFIN5/ZJmDFnkuq4OPJkq7Xcn23bjTmkgRgV5i8fa+91cFDqTqRWLI417QC2RTJiLcEIpq47n2F1hhynEw06cO/3MMBzE5OvjJBUKmODNU0vRsGrhCJ45zb8W6jgeVSNXGBCc2d5IuIibU9uqZp1WKszuX05dRpjetgFwolBq/4w/PHRKFQagO+x7BliZi9CQfGyH+0SibGm4ultmpitlmqWhmPnd9v0HOLy7A/qZWxuwaLUBFva23LSBrp+FV7+DyIenf+dH+CjJeA1OWWjlmaG0nFX3YoMpuzTLifJ1zvyltH2nt2Z+XqgW/QXxgm99DxXBH7sQNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 01:12:20PM +0200, David Hildenbrand wrote:
> On 13.10.25 13:04, Lorenzo Stoakes wrote:
> > On Sat, Oct 11, 2025 at 05:30:52PM +0800, Ye Liu wrote:
> > > From: Ye Liu <liuye@kylinos.cn>
> > >
> > > Hello MM maintainers and drgn community,
> > >
> > > This RFC proposes to convert VM_* flags from #define macros to enum
> > > vm_flags. The motivation comes from recent drgn development where we
> > > encountered difficulties in implementing VM flag parsing due to the
> > > current macro-based approach.
> >
> > This isn't going to work sorry, it's not valid to have flag values as an enum
>
> I don't follow, can you elaborate? IIRC, the compiler will use an integer
> type to back the enum that will fit all values.

switch (flags) {
	case VAL1:
	case VAL2:
	etc.
}

Is broken (compiler will say you cover all cases when you don't...)

An enum implies independent values that exhaustively describe all state, however
these flag values are not that - they're intended to be bit fields.

Also we specifically have the vm_flags_t whose type VMA flags should be, right
now it's an integer type - unsigned long - after my changes it'll be an opaque
type that'll blow up expectations of what this change does altogether.

>
> > (they're distinct) and also - importantly - I'm going to be making significant
> > changes to VMA flags soon (to allow us to have arbitrary number of VMA flags on
> > _all_ architectures as recently done with my series doing something similar with
> > mm flags).
>
> I guess this patch should not really make a big difference regarding your
> upcoming plans?

I don't think it's really useful to do this in any way, and as I said, my change
will allow these tools to have a much better solution, which is to reference the
- actually valid as an enum - bit values.

>
> I do hate the enum stuff to make these tools happy, though :)

Yes, if the tools can't handle standard kernel conventions, the problem is not
in the kernel :)


>
> --
> Cheers
>
> David / dhildenb
>

If it makes life easier - I can prioritise doing the 'make VMA flag bit numbers
an enum' patch as an early part of the upcoming series (and in fact likely to be
multiple series given the scope).

Cheers, Lorenzo

