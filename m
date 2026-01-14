Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CAB6D29FEF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0166B0098; Wed, 14 Jan 2026 06:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3EF6B00A0; Wed, 14 Jan 2026 06:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B856B00A1; Wed, 14 Jan 2026 06:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A12876B0098
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:56:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45850B9844
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:56:30 +0000 (UTC)
X-FDA: 84330416940.05.7F65607
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0436D4000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:56:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rNZu0Y9F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=c04a0avn;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768391787; a=rsa-sha256;
	cv=pass;
	b=eUlj2oGzeD9TVeOmsAy9pHPVb8B5I07nXYKEnLoSD6l0pyhqK+WDQXhlDenkrXn2YsztD2
	MEdsA58T4B6WMM323Lai3l/7m5UcrmEqceiJiWyALSbpBFuPOJEJxzJqmRo+WPxq5+q0+d
	O4Z2BRCeRmS/PDSeqD4CsvYVdzknqmI=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rNZu0Y9F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=c04a0avn;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768391787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AznY/2LNrXsezv2NKzDDEuwlpDxcB6Nq4qkyXB2v5Yo=;
	b=l4YY69eP//lNdaMye6ZO9op5/SNr8VgXYegPxYijSXs9c9tS9vqYGb0I+EN8IwAlcRCbVF
	+ph0azoefXjaoIGJOQlywAiK8yUlft1n7Mtqi9tpLEhNKr+EzR0RE+pqytUYQ5s9+P9Xw8
	z8c6/1VrA3TXjRFBlv3ZbP9EKng0Txs=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60E8Nu3s2753713;
	Wed, 14 Jan 2026 11:56:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=AznY/2LNrXsezv2N
	KzDDEuwlpDxcB6Nq4qkyXB2v5Yo=; b=rNZu0Y9FAtF5etLC2r+fOMdIG2PuqTM0
	UVwKvSq4eqfj0d97l4CLmgKl42iwaFHFqm8rGbc/9GFRzWOnrEYZaTP2PDTJOwYd
	5V5vbeowN04BnxyeAcC0BppvS6KGUGpFHHjHbE0LhWsOBmLIYARhzFECZcvDygJP
	7hCkrA4cjYd4+tRqzWsTcmP/Rsr8Yf4tY/5Qs60+44gA1cePuqxaBq3Cz2DAq2GS
	i21nCpdOAHE955iR9DiiavAI+RoVbJITTKPq28RO/OfTk04DPPDEesHIXzX/vLZl
	oCr5SI1DkGZqH/bF7IjdL3eecVcJUY39NsRBuWFd/0z03p/ekq//1w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgn2j3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 11:56:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60EApKbg004464;
	Wed, 14 Jan 2026 11:56:20 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010038.outbound.protection.outlook.com [52.101.56.38])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7kramp-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 11:56:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I+p7NQwnIaZdnLXdsAE948a3EB+k6YyOOFsNPbnSdkpAn3GoalUQRGwv3mdpv7As7pyjWEGUOMAQypHgEoYR9cHrNzIqLQ+ZvX7zylUZDisw1mmgBAcFSZHbOn1qR85CMuMPs8LAuguD79038M2OCcG+THaOU1OxVH2Kl7pUsgimUK4uo4ghw63t5eMZ+6nelHMxuffHf5KlTkI9I5rTWfCMYO9+KuE8070oqUNZn4bSwOIcXdiRH9UnjtGGlMcdN/suM1zp3llM0jXk/gk6F2qJ55DUmTLR4jkpldBBMoOgmeZhbgDGV+0Dq2xwJ+ToqhzQoXeuAqJE566Atvqe9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AznY/2LNrXsezv2NKzDDEuwlpDxcB6Nq4qkyXB2v5Yo=;
 b=iAtkYkm7Uy2qPrzXVR9CpJwNG8cMJ7P/XwzmB8k2QI7qCMBjM5dpe54176dD5WElzLm5avafPdrxAmoj9NuokjOg+AP22yr79P5qElGlRLM0/tyr9mpGGT3J9nvema9LAc/StGpVYAjtRdbVj93JEWQE81mePWDqCAIgH8S3xoQxA6nlesFmP6pgVhEgppHB3SJS3EKZvrlD5xQ7fZrEYcl18H0br8KfHzVlPZ9/Lc1X7TKZZAoYKmacXru196zeHsxQ4ZjXmV+2LtigXLN/1/fBgKt3qwwI7aKpYR+gTENZNfnsJvgeMzdAHMhU2LWP89OPI5BBVs9ceU7FSCRqrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AznY/2LNrXsezv2NKzDDEuwlpDxcB6Nq4qkyXB2v5Yo=;
 b=c04a0avno1UAGGKTwM36hQ8ABc+rSZo1WV0JOmnX3CDcsJo/3YvyyrrF2XeZguC19KAVF7q2rDLTrSccA6qMrfYDIDzFV6D6qzazJ7Ow2g55FkNwxfrq/Nl9jAc8i4UC3Mtuui8MDRdAnhPKYrGbLZ3l4a2kAW9okewFr1l/x9Q=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB997603.namprd10.prod.outlook.com (2603:10b6:8:314::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 11:56:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 11:56:16 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        SeongJae Park <sj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Chris Mason <clm@meta.com>
Subject: [PATCH mm-hotfixes] mm: remove unnecessary and incorrect mmap lock assert
Date: Wed, 14 Jan 2026 11:56:19 +0000
Message-ID: <20260114115619.1087466-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0273.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB997603:EE_
X-MS-Office365-Filtering-Correlation-Id: 94742da5-d6a8-45b3-f408-08de5363ec79
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?j9nF8jtlsth2MTb7xFSf0WeINN6XbZcdGVQWPu6YYGE4Tzg5Ja99I07mptfc?=
 =?us-ascii?Q?oKiDfOcM83K0sKp0PV1mLM6GdJtmkFaoCtxXYgNi0ydDECL3siTpeVbkF8EE?=
 =?us-ascii?Q?1/KfmVE+rRaLXF7DhjUPdoTB4nc5vP7eTKNhxD1BvTbXvWA6615I+CLx7g3s?=
 =?us-ascii?Q?sJfoVvY0VRdGUJCAdRm8mXJoLixjqHVAlsuo4xIXuE0rleLGgIjut5QCPp4p?=
 =?us-ascii?Q?xR/RbDok/QaUCzI7GptsZNE3M/H8DL1rVPT8ow+wTUgtCN9BzWP6eSZa6xWe?=
 =?us-ascii?Q?ZIg+pmXd2TOZg2B81V1YLOwWyIsa3rux1OabNUGVvKnbn8IV/4WS9QE3fLzZ?=
 =?us-ascii?Q?sGuYKvyETpdRh1t5E7LsIZdJL5W+ILsJBaQRy8ggadvlfGuw8c7sOArRYiTM?=
 =?us-ascii?Q?m0qVNaId0kQHD4++whNyTXE5Py7ymP3orJbQ0a1x+C5UGrXtJHfc3vK8F69V?=
 =?us-ascii?Q?eIeIAqhTPkm+rrRMqk+1BdUyRxbrWHjSZULUcw1f20DIRNX9KscbWODlYnVm?=
 =?us-ascii?Q?zjMUohWeMiMknBrVilRBF9juTcAeCMk97qKLC3kwcormi2LDDOapbjUM+C93?=
 =?us-ascii?Q?pLyP88A2EEhLf4m7nnSxmv/E0bwDQwAyzsEmHpuzV5ZftVUhwYEAbdw9Z4tf?=
 =?us-ascii?Q?XmdsnMno9mzVtKTUf1yeCnHEvd7xL1vz31XpZJhtl9u6KDvZGXqOY7BPo0d/?=
 =?us-ascii?Q?0GEL8xw0wKZTcqYbnTiz2NWU7+ffpmAMcPjK7OLNOC7bfF88ufkdUEIM92Oi?=
 =?us-ascii?Q?EF66Ck4aNowyDVa8PlRS/kR5U2B8bROnHw5bcT5+IgDvIcDbtIPj+hwVWXGA?=
 =?us-ascii?Q?y6nXxHYfVkEbueN/xuBxQ0IzBG+iL3OO7ip0cTzkvoqFrWST0h7v0Re+AQnn?=
 =?us-ascii?Q?uE+7A8OCaWB4uTS7NCNDjTRh25JB4hPHBVbBCBlrBdp49keR0uyvkfaCOoWI?=
 =?us-ascii?Q?MEnimoH5YD8K4H9GSIX2lNepSIpuGmx6qLpX7RkP5o3qQ1xmtH5NklEB/Gxv?=
 =?us-ascii?Q?x7LxLRQ3kD75Z2tvvwiQbUMljc5lu9mcF98B30MAj0rjGWLNs1BDTaLNKmSK?=
 =?us-ascii?Q?f6H/rQ3pG69nrHuLluRn0QBzgIGDRwHKLte9GwfgfaJhjPLK0dNvirG3rZpz?=
 =?us-ascii?Q?H3WoMqA/RHM2ZFvmFdlKhWW74yPNjPGoNIAVXzpdgafRCMm49xnGBS+jlzB4?=
 =?us-ascii?Q?ucV2AQJYR/DwtvtkSsSlpPbK7XPI2bg3bJz0KgZfBa4Aj0h4GCSBK36tkiHg?=
 =?us-ascii?Q?eEoaPfC3wJpbTpYczrO/3iA7w4iPLJiYHO0NOBScvB3BtdqrDQJ2BDr09Hc4?=
 =?us-ascii?Q?XAgbA+gJurUI00CeEnMTZB3gTOMDAwsRN3Ij1gFPgT9MVPkAjBMoRZC1bgt2?=
 =?us-ascii?Q?+patZVOLn9ZPxDEPXYeviak+7lBrEU8Npt56HkfdjFyghS1s6JTXzcOw5XPt?=
 =?us-ascii?Q?Jcc5lfwL7nKMQ2Sj4mg4B1Bck7CoHelyNFp83vC7eEV0A/KMuu0Ko1zec3iS?=
 =?us-ascii?Q?C2vF5bu1eWx1lgRh840e7W9cTf5taGyEbMuJ3+XV8ruRhv4KxDOpf4EzsTLX?=
 =?us-ascii?Q?XTLDZKvu3zNUgzQTz/g=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?fRdvcDOqDLCk7/2nIOsO+3lM9qw8+/4gPnSc/f0RsLpFb2n48oOEjRwHKAQ+?=
 =?us-ascii?Q?d0PYvP7Ei/jGW/jmXHe+p/zpsTx0V/KTP8o0q+QMZttELV+U1vR8j92fwfJJ?=
 =?us-ascii?Q?3GYee+dVXz7V5rBZhZOiS/pm7wB654HQRZkuTlqrnj8lzHpB6Y6OUPgkWuwS?=
 =?us-ascii?Q?t2h8Geq8Gq6j4Wov/ycxTw4cwkLTZfc8BrJcV1JheLkLVXo/lpS5a6P41iww?=
 =?us-ascii?Q?62FQJ129X2u855O3I0Uw5E1djfpcUZNcljipsfSwMA3GlNoN9Q2wyIZNgP+4?=
 =?us-ascii?Q?Rlh987niNhCzk/XQXvAW68b1NlS14gvXiePFNQuQb+73DtD2TcY1ZucWMpG8?=
 =?us-ascii?Q?sDrqRQ5PCZtHHFdoVYgtBoPtJgDvGkC1UFk7GRYJdez3OftjaC5+ZIHp6XL+?=
 =?us-ascii?Q?7ummoiTvecr4vAF9pbVvxKxVEJd+/C3RLwuDY/7D/u8c/uWSBk+CD+6rkB3K?=
 =?us-ascii?Q?tV4ojIZNcWQdP/fImEkjHhHlpQ2AJEjp5TYCLh6gMN6IjHg+IKFQDLf+JdU1?=
 =?us-ascii?Q?UH0/VD7kvO2dQgyWz7ntophs8hK4jEpa3sp3kEFtQZWJSsGzCJTFDWlPYUHW?=
 =?us-ascii?Q?xHoYJqel34uT5oe3ebjZDIdK/diVvi1jt1xrNfNazE7ucYX94SChFbkjzTxw?=
 =?us-ascii?Q?C1huCEGpeHVzBb6tZ6OqqGm0OFtN0xjjd3M9/eklk7SvEAHcSkH0BBiUo87z?=
 =?us-ascii?Q?EO4wLLvWhS72ZHO6WkGNp3MP5faiNbEZLRHv1I0qUv8K7HZQL4pkyz5x+U+Q?=
 =?us-ascii?Q?lU1SojySDmOGFoYcCTdgKXdkH3QDVCmLcy99NCk1jUkRmkPMq//+Vv96CNnj?=
 =?us-ascii?Q?MjXC9LPJG/yke5FWmoXTT7BBq+2CUlEeQVia/fhd0u/1idt5e6xussL3YA9j?=
 =?us-ascii?Q?7szPfSxth22N5QZrp6bNt8uWGnf9B3WKG3tolhCB25dSAGROAvq3nEeWrPe8?=
 =?us-ascii?Q?H78IYSeAC5wyxTvFXxz9QN/KvTCmdOZEdVFoH1wg2AHeBQvOo28Dt97xgwGH?=
 =?us-ascii?Q?fdhmW5xKKkw+zIGQZPYZ5jqXpTm7LUfYfJU7Zas+sRKU72fBjjucFA7xyTlo?=
 =?us-ascii?Q?HOsnF8kci0eggBHe2s5h+JgooZlf+oEGTwNzPeiQmpFNMZCRuj1W9KiXKAop?=
 =?us-ascii?Q?L72lZjrjr1W6nJXBEUSPdHucwHudIxDJjNh/PaRkgrPzjcX1o166/M4Y/HzH?=
 =?us-ascii?Q?ZTUc+eoejKE1kIBLyR6pxw2/hPvSQD1GM4y6O6mlAlOtJ/OxzcU6DR+xjMiy?=
 =?us-ascii?Q?Wd8HLVz+Qg7EeCJnyLctBEN1XvZ0YGjYYfZLhgLlomsIGV5jnniA+Rko27bl?=
 =?us-ascii?Q?hsLcl95ylLzEV2V4VxyJImbX4Quzns7XD2qbcxUTutFFeiNw5CTIAH8PdmPJ?=
 =?us-ascii?Q?hvkmD3uCFXNvatwMU+DjeMKi//H9xIFo6rQmo+aXMWKkPSka4J8aYCCyAGE3?=
 =?us-ascii?Q?v5xhvgDtcrLoUgSM3ffwOZiqfvcy8zhUM+IpQ8s4Wadfpd4mmd7s5MdnSFxr?=
 =?us-ascii?Q?LvDIHhxVH2yreWs5ce1FNRXi74A5kQGWO+fuRgj+rL97jR/HvDwsuFmx6/IC?=
 =?us-ascii?Q?WyYQAj54STkoQO6yEH8JbaPQNx+2oRR3sI8npm8yoJ8fzwTFA58Vvel65Ovg?=
 =?us-ascii?Q?2W2r2W90u/iMD34o5a375HfVJEz2bjjMxLCz7u4HQ/RXC4SjZrgKoF1yqDQ7?=
 =?us-ascii?Q?2a+Yi7B4jkUsMFtsF6qxdQll58qj0TtG1BCOhvSGFYxYp1j8UFKGSvmmJ6ZM?=
 =?us-ascii?Q?OZdo+QovP+ov2P8L0BukspyNgZjHxJE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZjEvJCE+8HhJca7iA/57doeT/EF9++XvNubE+6jD3VD47LavmFSpiqH74c0MX4hEvQkd3TBpGz96/N8M+4Zqv8yW1ChWHveoKJx2Qfl8O433xPsu3lufenFjRiE3PikrBScN5jgcopShtJTEnDcP62+ubvRt9FQkmPXuhtx2DhSKH587av0Swjh7s1Fdg/V6Boc+isALSYLeKmXpIOZB4tc1+YEGmRceSoSC/Ep7+l+tv9Iv9rCUkT3n5mvFsGDPMoB2e8zZ+CIFSmOt+4UBMrH/ixQ5UwcYk5hKcm5w39Cd1hBWpoyASPoWzcjy/JGEOmFcDNepHFWYbmQHa1bJ4v6rtSdd/EjwtVCzUYwzGJpnP5jzsXGke/6bWTLynYlxvYRHhExe6UvUF+v0Hutp260MdYSsxM6SAUSQz9nUvwjfu6aHlRBFJsliZt46lsu9UMJ+s4SsGamtxHKlI7IJIKrnQaRhlvdFeSy6Ok2jkxYRYtU3vaAwbrPfQsNVnV7v+4EmAh4WepLnT2QX4CLS208qoOAI4WhbPXA3T5ucObZe8rnE4sDQamoq/s7l99Ox/qg9+CTgixWbukwpJhaTkIH4M+Us0/6QJmOlOKnXv9M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94742da5-d6a8-45b3-f408-08de5363ec79
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 11:56:16.8350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PImP4pyYGaqb61eVYEt0y5wwHJ4LK8LGirZpEyINb7TJyBYlSaiucT7IEB6GL16bSpar36hUgeihZPG9OjZYgivV+j67LmoiEXT9IOvk6tc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB997603
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_03,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601140098
X-Proofpoint-GUID: oUZQQJ5nEQSrT1I5qLle2dCsv_Vh0kjn
X-Proofpoint-ORIG-GUID: oUZQQJ5nEQSrT1I5qLle2dCsv_Vh0kjn
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=69678466 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=yPCof4ZbAAAA:8 a=Y5ssSvCEXcpx01lOsGwA:9 a=gKebqoRLp9LExxC7YDUY:22 cc=ntf
 awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDA5OSBTYWx0ZWRfX9newrU/RafGO
 23xQ0O7OEMKaOL9jg9XqJqQz/J5/950GKoKIKmN/XsVGIA3BbvKz/q38qMXJI2fP0EzwSYipjIz
 EF5tvWHEHEZk3ukvU836FUp8piZeZqycyjf+GL6Oz4nx2hUJx915xQ2OBzsTIVRp25VpMMuWQrL
 A2Nf5Vm2Z7wTxdGvCHUVE83agHX+n/Sqvqc4177SA7/lhnxhIIR+u+EmyO/JzSirdKbwrdlQKYr
 nrlPA8ljwnh22a9ZWT3iE+XKa6OdMqmZOszMLllVx8L12uWpweyYlvlH0ljU+yWSkoY9FutqDxO
 FYL/WM3MQ9oExsrUIVjukvUW5xCHoHU1PD/W/EVeuhpoNqf17kZhSbwKJOCRuUUO1JnjWtTANPv
 aA7Rt2ucXN13LeLRaMkYflNIM9S2aaqgQPTpy4iqkqdMcuORGc0f2fb6lpUSWWVocteKEQBCg9M
 F1FEb3PqyCDPaMXEt/hrJQthI4kYPul7cA+zFy4Q=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0436D4000B
X-Stat-Signature: qxbu4cgjxkf1af7ihyp593fi13cn5ecn
X-Rspam-User: 
X-HE-Tag: 1768391786-914895
X-HE-Meta: U2FsdGVkX19uz9BtXULNAi39rqQak5GLkd34Tzom8hDUu5WK7VkO76eG/UZbvMvYtOt+RW5bIxzTQA3Yj9pYqZIna5WUB43FiKCraf7xvngciGUgTDd093omvWh222k9ZwvxpNeRNXehORnvBA1+t7ND55aGiGBHdW/JbjZ3dcJxYpv90zvkhvqagBZ+rZ2RIgAT2iAPvn+8Ee8fDWwVZibpfHFn3e+nPJhh3CpbLULTZZ2qq5G0fVhA9C37YB2VFejFkwcwqVW4gPdcaALNx8RpaIyXdNh1dHB4h+MY5ycX+/lcvfqSCAvFNg/DK4DqL7L/WIF5n8Q17jyykvl/dlskOBxixKNPu/JbLVTkCLUFCUNvROEC2VEOERRX9ve4IjfwjfGzPwJOnSY1xS5BkrWNBkQ9xCcjSNx5Q7+NfCHuyu000iUOf6OY3TN2lhEPR3kBwT/Xs4BXR15aLaI7I+PpfEaO7mtTPszWOhUhu7FrtlsaJJDRW9j7xhluT9AjnIl7ggUU5yO4t3EA5h7GVZN2HM0qmJuPvuUBOcWJ5eqmVePtwXl9lOgKtv2eiaHBF5GCH8pZ1UIwFCrH7m5nunXHelP9zqktxq/8TLvOwAmHPR3UG32YIvpbI+/C6Yv1EWZ4RUExfe6AyOT+vrA9CpFm1SseUk5SXuMzQj4TWVVhz4bPMO7SXxmZIGXMPBR0gdpBWlOTHoWcfn+o5+uNJzPpRv6Bz3Hn0DRmemYQlBpqjb7jhccB0q4eID+Dk653Bhn/WXdRDEr0Qr06Z5uLV6si9uu1Xr92Vpse9luQO72LYzUkdX7Uy7ywD7mete9ea4rs2nLzHt7P9/mFbvxACMTR629zKZ7lFiS9AKpf3QLupOFdMhEfxNT/5DgqNI2T0116VjhzGZVcKN+gQCG2+1CrC0/4VoYwdCcnEquhLYNgxVPGXmtxM/ihKMktCwOYNBFf5JsWAKT5afdD16d
 7okTxbjL
 /upIqYzgxbByTKHjqkmsapGKnPY9K7yhOuUzXjrlWGdzS7Ko=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This check was introduced by commit 42fc541404f2 ("mmap locking API: add
mmap_assert_locked() and mmap_assert_write_locked()") which replaced a
VM_BUG_ON_VMA() over rwsem_is_locked from commit a00cc7d9dd93 ("mm, x86:
add support for PUD-sized transparent hugepages"), i.e. the commit that
introduced PUD THPs.

These seem to be careful asserts introduced to ensure that locks are held
in general, however for a zap we require that VMAs are kept stable, and
this is a requirement that has held perfectly well for a long time.

These were long before VMA locks and thus there appears to be no reason to
think this is assert is there for anything other than 'stabilised VMA'.

Asserting that the VMA under examination is stable only in the case of a
THP PUD is strange and unnecessary. If we wish to be careful and assert
such things, we should do so at the zap level.

However in any case the current situation is already simply incorrect - a
VMA lock suffices here.

Remove the assert for now as it is unnecessarily, incorrect and unhelpful,
subsequent work can introduce an assert in general for zapping if required.

Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
Reported-by: Chris Mason <clm@meta.com>
Closes: https://lore.kernel.org/all/20260113220856.2358195-1-clm@meta.com/
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/memory.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 4b0790c8fa48..6b22dd72ebc8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1963,10 +1963,9 @@ static inline unsigned long zap_pud_range(struct mmu_gather *tlb,
 	do {
 		next = pud_addr_end(addr, end);
 		if (pud_trans_huge(*pud)) {
-			if (next - addr != HPAGE_PUD_SIZE) {
-				mmap_assert_locked(tlb->mm);
+			if (next - addr != HPAGE_PUD_SIZE)
 				split_huge_pud(vma, pud, addr);
-			} else if (zap_huge_pud(tlb, vma, pud, addr))
+			else if (zap_huge_pud(tlb, vma, pud, addr))
 				goto next;
 			/* fall through */
 		}
--
2.52.0

