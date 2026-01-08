Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76347D1D486
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 18:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D93416B009D; Thu,  8 Jan 2026 13:52:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D555E6B009F; Thu,  8 Jan 2026 13:52:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7186B00A0; Thu,  8 Jan 2026 13:52:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3D926B009D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:52:30 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C54B1602A0
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:52:30 +0000 (UTC)
X-FDA: 84309692460.12.A8636C9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id B44CC4000E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:52:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fpzUbXSE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="hY/BWaKk";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767898347; a=rsa-sha256;
	cv=pass;
	b=dBhjxJbN4xtT8Ib0Rc26WBlVxd73+gL+Q0w8Wz2LHUPJhtN5srAcgpePELqtoVvy7GX8fs
	soOXvhnXCs0qr62GHELU98DXcuJUSuSy1GNCz31vnNwkrhFII9Kd9/HB4fxzJ/zwgIxzmb
	B8RFDCaf+BjFv0csDm1wZ30IYefTOuQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fpzUbXSE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="hY/BWaKk";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767898346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQOichLor3awFGlQHzzjEQUE21rMmn47X2tAQjkDnmQ=;
	b=7uaMIsd6U1WddCG2yPyqotHErHrjQY9zTbjHySiq4uouVB2lqKNkp6D5p22qKWZDz10X9z
	f2tUt0Y45IqJQk5RGWwBq+9x0kTQHg0iusPPaye8Aa/oIj+pcXfAxjgWZsrans2dxm9BNq
	S4K8qI5nZGr1NBXf/VV1iYvmfcbxcd4=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608HfuoL1128289;
	Thu, 8 Jan 2026 18:52:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BQOichLor3awFGlQHz
	zjEQUE21rMmn47X2tAQjkDnmQ=; b=fpzUbXSEP1lYrh5zLJbibMxkqvorZP8+qN
	621ARR0MDFEa4Svnz1ZUlKDOPE4gXClyd+6Ec555GESt5JQ4F4kHFI3rxVgI1CBE
	SMFKdTFDgGj6aW2b5/mfpBWsXdGZelnFDGSxvH3sYMX6kjUvcuPU6y22EuhD5MH9
	VHj4+Uq2LksdCOBVF/BDGCGYCyhWLeAPiWEJsWTaRm72ojmecPgFu+O4G7oY3oGd
	dDw6jkMVoM8AzaKvBa9YS2v7QTzopsWcUIWqm4i1GR6Fh5HoluoatrGg39dXPe7J
	rWTUfGDN79z2Rj1EqohxeNK5MISg86JmNvjaQHErDcL8Po2CiSBw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjh7003kn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 18:52:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608HXoLo026378;
	Thu, 8 Jan 2026 18:52:20 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010008.outbound.protection.outlook.com [52.101.193.8])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjnpwue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 18:52:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aWMeA2zq/u9Q1SdWmYeWG6DynDl5l7NzhRpvkFUVVfNks2CPjyG9BTvZtQIEl8K0lSkj6/FMePE9JypucQcOrLeEbmOw/jTshfC1k/8nDOSupVJVMLjQPhQ7etLgJJZaxqA2oR2riMod3pkWdL8HqiHscyBKpNwwq5lXqPvyjt96pv7rpocv8WyCYV4GpUjxAh0hS3xj0PXsQNA7VFzAzkgauaLY3xppD7BZpy1hiqw7uMz68BQ7le8zXygExcTbOI99+0LRDMkQaEYyDESvQFQlBaBiOEEN3rioImDRIxJRRKgpCqOkKOxq8tP01HreLsZAkmakUf/wRpvY2Rs1vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQOichLor3awFGlQHzzjEQUE21rMmn47X2tAQjkDnmQ=;
 b=TRPVPK3ZgaXAnD/Ttl9q4+Mf8BHnT+aJKYyskX7IxCmzaj0tmBqWE6Iq6QFWw4HufHRiwLRRL6rGp9eeBwaaPcwQkqwL0Yl5OAk1sEzluzB1w1DM4FZdVc28LYxW3UeGGfCtnTl7fyapkjUABgVHAk3LdzJwDhVv6iSW1j7PeQjtluuLLCWMrpVupOe7k5VH4/K+Ypw0DWBAOhejT+dKNiJcr2uC4fqc3F7QYrePhia2YkhsW6JLgAyLQ3BFDDaHpZoh28Cr/0M0RiGjyURTTA7MpdpVwz82Rwy78/Tpci/X8KEqwztZJHwikhggpj3ttTeOK/qANVgjISN7mQABjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQOichLor3awFGlQHzzjEQUE21rMmn47X2tAQjkDnmQ=;
 b=hY/BWaKkUAQiTEcW6yzePqIqyFpNQRvjdUCuIdfbxCh/VmNnzrC7PSpA2WpJIl0wLUQqN+v2BT1GUUBx2s7PoI/p/ISG8ZmkD1kTVNDy6TWdHnD2zKnrbK1PV+yFzDnMavxJ3XGpz7JO+ddlhRkQkVj2vVRhmrdU5gmhX5mIB0o=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV8PR10MB7776.namprd10.prod.outlook.com (2603:10b6:408:1e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 18:52:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 18:52:17 +0000
Date: Thu, 8 Jan 2026 18:52:19 +0000
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
Subject: Re: [PATCH v2 8/8] mm/rmap: separate out fork-only logic on
 anon_vma_clone()
Message-ID: <e38b8ed2-455f-41f5-8cf9-bfca3915c7c6@lucifer.local>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <a4f87ba914697a47419f12901a995759fd977fdd.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4f87ba914697a47419f12901a995759fd977fdd.1767711638.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO4P302CA0002.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV8PR10MB7776:EE_
X-MS-Office365-Filtering-Correlation-Id: cdbb19b0-27c5-481e-5032-08de4ee70b69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oLSTW/HUst108/1z6TR9K4VMv5m6lToaJWrb4oQqdgH76sP4+AYnRgY9Ubz7?=
 =?us-ascii?Q?iJ/2Pvi7Pmf7hifQCIymbQsZ/Fmqs/MOdbjx3UsrUCm5/sViu+hAQtYPgruk?=
 =?us-ascii?Q?O78XCrLGOvf5b+nvaAvDxGeRTzZ8w2SjQCm3JoIIk62lml8kZEOLge0b4laN?=
 =?us-ascii?Q?/+T3sezJ1/aWDaMGdZT+P3qNkDi5S0H61RjSxZuuX9G6w4xouWr8EfKJ/41d?=
 =?us-ascii?Q?EoMEZixFSCzxH9ljG+0OyHU31ugEOdC6vqht7nKnjsNVG6aaLKWG+NIh8Nmx?=
 =?us-ascii?Q?sayzjk0mDqgxvDfc8Hx/weBVpTVOYtOGIrQtLWPOHHGHPJWxqPYIsjRVqcIX?=
 =?us-ascii?Q?JWKugMiZ+Lw3QzXhV4ar6bF/ADw2NO5IFyDJm9SlZzMNN9BHEkD0A8GFwPuo?=
 =?us-ascii?Q?HBRs+rmMp2C1cYfOOMpFhtRHyBMpABk8hOFTxf49u4CPlVDcW2DYTj7XFlCH?=
 =?us-ascii?Q?fgoHSp83yQuMxfg8tnwQDunck5IG4uLg5110ofIsXCn+Aw0MOvCDmz4cRYDK?=
 =?us-ascii?Q?nb8fNpbfs7CYOReurzDBHKQrL3gK3YqISvVJCh74Tk+Eo1KNKSBq/ISzFHG9?=
 =?us-ascii?Q?y5Jc8QnkWmW84kkNolYFeVg12HiwP2PH86leaSrn3zmhfCh3PbmR5BEO6U/U?=
 =?us-ascii?Q?cGSjAuBV9NfAApnQfd4md7A/d58ZracPVHSHw7J/E92I65D0/nz9ymwHmFvT?=
 =?us-ascii?Q?Tq4MBpZz5AI39wUqzdgu51aDRN8649rIfW9l2FwTXdtmMa+AhGkWNbwT25g5?=
 =?us-ascii?Q?6pUsep7ZlIRMqhcOAisGxlgqYOCv/Eg8As1UAzpUr5ZJAkK5wkjAkjK2bPaZ?=
 =?us-ascii?Q?OJV4Mqi1Ug+pjktW0uZ+8oIt/80ZrlFKrDe1p5Wfoh1ubc09hlhgQZvO5YkN?=
 =?us-ascii?Q?2sVWqnb+fcj111vJ+R7MUoDAy+yvXmWhEivLobuLv+PlLNITVzsilJ4DHiHv?=
 =?us-ascii?Q?L9XUzQYEX602CbQAn+liNw+mLrhgehdcOVQ+O1ov9QD/8Ed2ySvPhzIh7G0R?=
 =?us-ascii?Q?gorLx6rljfVhZR4yTdHzkdoj61KM5z2VV95zjBDgWm4/dOuQamDLpwGmN2Pg?=
 =?us-ascii?Q?LoQru/c3X165tnRRTlzbqbkt1JyXDrUecqZPQmVPGZ4m7Ant1nRjJDSPSDZ2?=
 =?us-ascii?Q?DSmGh5lSiGZ8310E6J+qGPbbwbccxFHoSEnyDvSF+Ir8mOHfVZ7ng5HjeEA0?=
 =?us-ascii?Q?ONYgEtREJCM549xreAtc+YlzlV1YsCE2iE0vaHmIvynCDrL8Cf4NRZz39jJd?=
 =?us-ascii?Q?M/zdaqT8CqWYDt2BfFIEXQvxq20uuAZFL71/kSWdnl1b/oJgoikd3BoPHCCc?=
 =?us-ascii?Q?+sqxQ1rA2/OuZ31m/GHF5RQFuToT5nEuq6g14LlEFYYr7pJqR7TfuYC7m2wi?=
 =?us-ascii?Q?Nq+tlXb9ysvLV4IfEnqXSUtPczpMswY5y762ZqSnAAgOg1ipMFQIQ7Wjq+tI?=
 =?us-ascii?Q?xtRORzx/MhVD6tQu/MSwmuJWWH27fuhQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5dX/hkHI/xSU3701Xjf2GcI2tgpLqv7tAtzjOX7VqR/liIZGj2lIyiEzONmK?=
 =?us-ascii?Q?sQXmBPtFh3jzMX+BeWQiZZXmNl9P2iUuqvKvMZijvgJAuRKks0Z+s15So4kH?=
 =?us-ascii?Q?FmDPsQwK1uXjC1cnsoUBiB/j0Rc8B5S2FKmpTURSx3RQH7hsPArZAwjJf0wY?=
 =?us-ascii?Q?vopN7HXaoSwCKmElk5qO+qoKcM2fVrKcYHzIJW7MUxVyAx1wQEM+vjAaE0oB?=
 =?us-ascii?Q?M6MjzHUKS/COa71+WRuhX91hzvmwniDGB57u2Jkal0RshCFFNBatZixcSDTo?=
 =?us-ascii?Q?K5xjkfIitQfYykmQVGnhyD2ny0FfFJxclIEIi8c2mqtazec67p2zbVTsItEq?=
 =?us-ascii?Q?zW5LiF/e51fb0H0LBCyGyhZMRE53WLb6f4NB9mZlqdL/EMIVz+fke6pWaMou?=
 =?us-ascii?Q?MJYpeGdd5v11yLqdS+52qxE2ust6ooXdR1jzvuYL29JK5eaxDQtWnE0NDe/X?=
 =?us-ascii?Q?qAnan5co8+ahqWU4Hm1oQ+XrXAg5ESzrG3hGZtuTA8XGndiP9DOmQ7myfBau?=
 =?us-ascii?Q?IB6HOhu8J4HoL7fFI7URyjXTMJME2nf9Rp+bcMaEySiFXFYPXJjxxL3lqrlL?=
 =?us-ascii?Q?suvb+Tj4t0dnhFdek3oQihjeltuwARGrSKsGcLpcnmyuQhOUBxU8N/1CZYag?=
 =?us-ascii?Q?ELNZ3s86y6Mn0sXgguGThndcHMVKoeevhAxq/OgEP1JcvrVX7zdZQB1U5DrT?=
 =?us-ascii?Q?yDNCmq5UZqLpsHMYwmUH3q3GmT4buxN2Y7FYWu6eO/hweg4Bs6szw1TRC2wZ?=
 =?us-ascii?Q?pCJ2yKAINIiAoo4C/V/5jEuHPxzuZSjmahmYhU95d/OAf6UlYWYYYNqecJui?=
 =?us-ascii?Q?QBRbY/pqMqxyByYMtuzOqPCMLpGQtesZXy3sDdPTV5u+Ry5FkL+bZ4JNi4HZ?=
 =?us-ascii?Q?qQNeexF9Rd4GDVaWrf4rRAKPMtiglSjiMIMpOcntxRUYvc26q2539tp+ad8l?=
 =?us-ascii?Q?4Kdb5gi23JLR91xqetrrvkJ+homsl8SYfXV1D3NI7tkvwWqm65jqeloNbQYG?=
 =?us-ascii?Q?HdAyKwXwHZLPVyNbiQhjMaa5oW/7RZObJfZAOot4xg+wtoP4Dqe7EW9l82Z8?=
 =?us-ascii?Q?jDzhu6hhtBEuqvIaYsJPOh6/NZOlba7T2GO/ueiCVAGqfcPz11jYRjYpp4OV?=
 =?us-ascii?Q?HTc7fdv/nQ87nS8rOX7nUZNjDpPlKM20zg09ocI7IzCzhaAg6vzW/uhF7Jmj?=
 =?us-ascii?Q?dVrZzIVhWpg9Ah2RijilyGQ2jB5RDaLkxloc3J7LYD0J2EQBojwLGPuIHJXY?=
 =?us-ascii?Q?2WUO+yJlom0kofRov3hi2pEFWm4i4joLmtFqzRZMXmICZXGPNrTjX4ZWyF/U?=
 =?us-ascii?Q?It6uTdQ+jBH2qCwOYu2RUD4O7/GOEndOmaR4xOdAAHBIy6v9euHyZhcFP1Sp?=
 =?us-ascii?Q?6Sz75g+f8fLvcxaz7Vu421x2HhkeclRmxfDrEu1IjyE63Z5ktPElSVLibxQI?=
 =?us-ascii?Q?3ON/y8DwT6o/2CWUpNHm0pi6bm4uI2h1+Dq3Bde5wXq6SqRK7Sv9kU34GQly?=
 =?us-ascii?Q?9cznOTyMpUY8j2lzvCh2Kdi4LiALXq1LFttZL7liT8ea13NFw+q2ISyqZxGX?=
 =?us-ascii?Q?lBxP0sZahrKQZGmuBd/kAUtIUsaB3Ti/OwqpZx+MfU//MlqivQsRTJNaziHE?=
 =?us-ascii?Q?FddzweXoPb4n2rXrM5dJ512iyrSmBxW2NxQyZTbtB4S8ht4ayjoYevIFiZQO?=
 =?us-ascii?Q?B+MqgbL2kWgwZAA8A7VgRnBcPUCOsBbqzjQyTmdSwO5fi9+0HNswHNBMR3Er?=
 =?us-ascii?Q?ARnufET3hRRVfcNd1R9j1mjmCy/Oc64=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O0XG3hh41MHa4xdI4h80nkUBhAqigMScBAEQXudnHHk9/es8fHhNwjw3jCoiVOKTL7DsJRHFc2+ksuVHxvMo3sgUPnN4avZdBjNSonA40xRNytdqvJNLeThhAdpQc/M4qFxeEKI92uRlq/h5bf4YI1xfyC0L65H6GP8bZdbGJAEckucfUbe4IjBXXiHAx9bHjzprsVsURdXisV+zg6/OMMJ7h6sMm81buEEpUtWtYci2iwRDRVd5cGmevJvUsbY8OGcvl3TP5o6zsrpguxB0XAynH8AQWlfcFJY2tQFuwpKFDpjh9T0LNGMjdC20ApJK+oqHwt8AtRgsx9Q/WZI9Uemp9a6HtvTAg7WstoRcvyKqBb9RLtd2ruN51udUoJqQcDYARamKtJZjIwEvRE/W6wKRYPTd/sb6qIn80/sPbtRSsu2TPmq3Qr8yLnnT9/wrutiGsKpb/VkqtXWILweNTyX0y45csk2vjRB9RypXyQok6GyozPnzmPoAIoFalFC3oIMZmt1hHbiqq8ZoHL6DkMVUeN5CyJQEngkc3Y6H5v4imS++KhVJTHVTAPvsFPFcVZw7i3FzYGyDMAFR69d5iItagEzZyYHFsG/Jx5MX7Nw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdbb19b0-27c5-481e-5032-08de4ee70b69
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 18:52:17.0287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5HKhMPz6391R1mnLZQjG0lypl2v5phBe3NgEkZGVAJHLmQLRn3F/8wF9D1QnKQ7Udt7RLKX3gloeD7jScZMv25DBIoW5Y1UzT+tL50itnuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080140
X-Proofpoint-ORIG-GUID: rilY4AzuPg6BNZpn1e94wYADCLpdkXhp
X-Authority-Analysis: v=2.4 cv=Mdlhep/f c=1 sm=1 tr=0 ts=695ffce5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=WEt8dE3zLTS_dxdmVXsA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12110
X-Proofpoint-GUID: rilY4AzuPg6BNZpn1e94wYADCLpdkXhp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDE0MCBTYWx0ZWRfX1cvflObpXsCo
 clZ10fZuzet/3a0gZEybPSF+uPOguFfgehay+EcYqaKBwQWppqnteL3Gf5l/BwcfwiZVQgTjVD0
 u3JMeja/PZo0jz3gaWo5dlz4z0TFTnrg6pZfmd32zE2JhXTuxO3/Ltb6123OlCUkuVFqsAO58yR
 0oGQb4lmyPxHXYH0acsccl8oUEU1Vc4j/NOKoJoEOIabf53gqWbFZV7CENSTYMcxrC9Y+08LYMW
 +Jvk0mhyxbpw6Fp2XXEz9EFJZhP+wd753srpHNr4BlDnT5FR/byjepkb7hUTuFGvxSDkauI+nVR
 kL6HRBnfWEFkDaQ4L4fvCcSBlI7kp6NJIZNud/3a2wLm7WTadkuiW6kHjKori3SXy7R03A4ciuH
 hoMnLrBmzg15M0ML4VR51CszbTQTg503UqskBacj8F7EIlsTmLlMyB4r5/O66dKJkwINEm4KQNw
 GqCZTFPA/CHFk78gcZ5SMMI/9vvvj1Pg6hXFxwak=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B44CC4000E
X-Stat-Signature: g6yuhtk5383itkd465jr4k4dxwxgyt58
X-Rspam-User: 
X-HE-Tag: 1767898346-820077
X-HE-Meta: U2FsdGVkX1+rHQnx9ieu10ZSSR6AIfy547UpoFHn3VPL0AZnSDcMrcWXVmJJn94iJ63Aai07O9Cjz3Qg+6wja7bQH89/e/+s/mfIYxoIy9suf5XIL7br2aQTyHEjk5H4153Wf3b9hD+zaDMMabtC9FQGNbSRDdtqqvKxBxpS2pb6mGfDzCv07OHZh/rQ2nqHI4nCsgaUHw0ydZyQj0EQaUZAEjqSvyKOMKahSwnyQs77AKcYmEjatKA+DflgbawG+03zk3UbwB63EucQ//ymUJkmWFO+4l+jLcXsL+kBNoHR/b/rX8Q5fn6Tj+3p7ywhhNKTr8Ct902ld8R6tocVJruohMe11RtXTuOhADVx0lOJFQnj78OKved7qSbAOndsB1k61jnP0Gy4ZmZwqXGEz78BMYU/HOo6779soGsBjVPePp1EwexhpvFzFYh/FgBbdA4iD8aq4jPXpYYfiGGakUpZwwskwsEY+B1xPrm6w0bUurWqcX70Ai+ews+Bp6e09i1zQIWqNq31nlp0cptmhMtbc4qLQ9RYJNa+FTRMrhDmo4+unusLas0ZnDTRxw2LhuTJzxzSFsBEIoz5VhZkoUuUahfcJidNzfwnaOk+/SAKFasbOpc56u3o0VJBpE5Iz70yAkBx00QxACuVCJiY056uWMk/sLU7dHeoMlbJjBbG7ZvRfrmueUPXkNwF4NXq2/3WO8Hqw8XQy79BqsvkniCiTRQHI735aMpylIpY0ux93izb2NvuDRBZq17pAsqHULZdxdIQ1mlDBO9v0s5Wohm25SZpa0Qw8qv68cZ8TmiYDWLi/WHGeLd3lshuQjpraxOCO7foI9H3zlebusTr2NWF/joeYN4ZTS7CqY8LQUweWM6gKDT/Lu7LXgGFW8972MDlmbabzlYC25ElxH/SwZRXMZppvgH7xIXqWKFAI/IcqKHUuP/PXjPkwoyOMh1Xmx7SqWZXCcnw2sks7NM
 4qPpZj8/
 aU9tbW8v8kGh1gKYmOf4MuixlhcX/XEuUbke5isWD7k+7kuEM35pCfmcG8wIZfA9JY4cywGyHegAq3T41P4gm4kZu9MGgm0ALJyIjMdFNe+DXnPgztidd6y8LTDfHXkgrCKwQUV8TtZfiulqzWoZcbt3y7XMAB1KHPpe/IawDyFdU76t9tDZLNaM4H6IAlu9VZR7Kd+zBAnE51zErKO3JsbyudFZ4pckfNvtdPf3nYxaBei0fTcDjDom9TjGUA1KR+YKY8Zv1X8IdMgIljsZ6c4cRiHdBInb5ft91+0hYL/q5s/aYdjJ2Xov4rMghOVh+nfu7AHJrIibYgCoffHzaSKGWXxWmzMhT+WQWYss6FH95keaueN032byZm5SJZT2toaDY1syHHzsQG4rvOXH26edQhSLGpjAQRpdedOpAqg+aenu4CGYtCGvZiVsmvesm9/dMAnR7ARW6xv/8wYGCBoEa68/GOvzvqCFkC/ZRrDVj/XiEgIY7c1XdomMRXC8oHiy0QSDBPew4oKxm+qFtsyQP2BhoRD+ffMYiyCiqvz9KuTwlGilzSGhA9CPbyHrKB7AgB1hZ6trK0ecrXYLk+IsjQ5y3mFdgsRDXeYcYIylr8jEymWiMjF7Ym9wvZNorha5epGWhiw2eGqkXmC9AXsTt0nW3eDFjqZE3f1AJMqH1XWQsnmJFb23155ajWgvKcQR9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Please apply the below fix-patch to rename try_to_reuse_anon_vma() to
maybe_reuse_anon_vma() to address Liam's concern about this naming.

Thanks, Lorenzo

----8<----
From c2bd360718da23c62a4aaa0addfa48955b2007f9 Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Thu, 8 Jan 2026 18:49:44 +0000
Subject: [PATCH] fix rename try_to_reuse_anon_vma()

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/rmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index f66f98416a7c..5da3b47b1251 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -267,8 +267,8 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
 #endif
 }

-static void try_to_reuse_anon_vma(struct vm_area_struct *dst,
-				 struct anon_vma *anon_vma)
+static void maybe_reuse_anon_vma(struct vm_area_struct *dst,
+		struct anon_vma *anon_vma)
 {
 	/* If already populated, nothing to do.*/
 	if (dst->anon_vma)
@@ -356,7 +356,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,

 		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 		if (operation == VMA_OP_FORK)
-			try_to_reuse_anon_vma(dst, anon_vma);
+			maybe_reuse_anon_vma(dst, anon_vma);
 	}

 	if (operation != VMA_OP_FORK)
--
2.52.0

