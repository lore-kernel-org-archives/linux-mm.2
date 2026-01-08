Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF5EFD1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63EB76B00B8; Thu,  8 Jan 2026 12:27:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A2A6B00BC; Thu,  8 Jan 2026 12:27:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7DD6B00BE; Thu,  8 Jan 2026 12:27:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3801C6B00B8
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:27:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2BC01401FF
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:27:13 +0000 (UTC)
X-FDA: 84309477546.06.2F5627B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id A77C5C0007
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:27:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=djiWyH50;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nGY3SjaU;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767893230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vyXAEIiwpGTTKMNFpNDixBWFytIN5nCRyoXGJlJeHU=;
	b=3yxkqisuVqtkQ/DuDo+8lb9LX9rEtkT65R/Ej0kGDnV0POsnXU1rgNdqE9ji+EHDdHqt9l
	cDu8laqJep0GVp2xmU8R7DBAX0ZPaORgPd7VwTJxTpzET/bfP0SA/tPjXcuKWZsoUK26HN
	TNHes7XlBZ7TAU6Q6AGDZDiN+RqOpGI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=djiWyH50;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nGY3SjaU;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767893230; a=rsa-sha256;
	cv=pass;
	b=3SPqpTp/YDJsS48QJO6WBVQ2shiRZfrhP/oTbx+8UJRIlmJrpxDfdnSaXF2KbHJ5owcXXR
	sshX9BkEe5suDSDrLm+FpGFWMCSTBTAMVsC+JmBPeWV2gPugy8mfmmP2EKDVBZ9vNMMzY4
	nzbUgAuQN5i4OD1m5Wv+rSKEv6fBZY0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608HM1Wk610061;
	Thu, 8 Jan 2026 17:26:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5vyXAEIiwpGTTKMNFp
	NDixBWFytIN5nCRyoXGJlJeHU=; b=djiWyH50ShgteIlsM5BkygPJq+3uOhSTsO
	D5QywNpfO27qJIaFijarskRPrGMOhW/yCUZsDeSBLYkV7MSvUA91vG9ay9ILtg/s
	HFcXWJJi/F5dVrhWKi1pP1hpOo+hWaN7UcEqWZLi9Nea1onhMV9qy07ewk7Vlrjx
	paOWFLT/f6Mftv3OLbuEYv1kwcaZ6l5d8JS6uTiTwNxEYTtus2kK9NwOfN7S79i8
	W9AASOheHx+tqXiIuRQLbK1YCM/PFu2SegVf1daL0gqV4TACWjWLVlPIWEVyh+CQ
	j1Q0DBG99xRAywX5iip1jxpBX+Es2raSkodekoihd71ZC7WtnJkw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjgwx008q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 17:26:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608HNSsL030640;
	Thu, 8 Jan 2026 17:26:58 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010013.outbound.protection.outlook.com [52.101.46.13])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjfcm9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 17:26:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J4f0wVRC7EOy/MZPQk7HEOodREp0tNZnOK3GdofrQsay6Ebo05q432z4oAoktkPO6hxCUwzOBIP3bijyPvqxGTCizbyOWry/t4nWZrIkDEoJ/OXdDmqNe4cpgKshOiH1X6uMZ9R4n12iY3bmG921QPiQ2iOCuPZ5TsVxR9kiooShVUJGD4MqU+KQ8zmaWddwovgrxqLdnooPA0/+oCm18ngECCIwn86x53fbOaWJP3LLlLEoMC4kRLyZoszSbMmqNlUaLDsHuc1YL/utXjjSMixCaCjZI1qJ9nxFKDmtAVH/SmXB4/+Kys1mB3dpbhuJFa1LCVCCk+rvtiw2AZVCMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vyXAEIiwpGTTKMNFpNDixBWFytIN5nCRyoXGJlJeHU=;
 b=a1p1sIpMUbHXfwJKX15h2SmO6BVVKRwqGUHpVw6OrbnNYW2V3odmCHtXi77VY+AdlgvJZ//bcWQomYlNWngQkJaXYifE1ZDOYryg3WFTljIRx6hcEbWEBuGD1xZaIVUZlwrEPMCLiE8GGd+K7FNBRxBc6vkXoOM9uNMt9ioT9uvvZTEru4ESiYPOloUko44uQoXO9pabvIf0k0822hmZsPUb79AQNgnJbSyB60URnHA0M5toy5kPW/UpmMJQzTZsXKOyJU2IdfFtZDMXQNPH+BPADMPap4zm9/QORl6FtxxaHSeviaU4+NHAG6LDTPpOhYqezZ2njtIwG4+TD5WpAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vyXAEIiwpGTTKMNFpNDixBWFytIN5nCRyoXGJlJeHU=;
 b=nGY3SjaULilC0agDzBcImAlTeo3yGWnd1vaK4LFEJaMErFg2PSqy8TtLsNM9/rEZB7NVE+it8Q2MoFyhHgUseOJH841mZFrrihK12B4vek8JF0nkPPIosnUXdT4SH4ZB1q429phFD6dIgdciaNJGYoV4NDD3GFq1n3WoHdVeA7s=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB5202.namprd10.prod.outlook.com (2603:10b6:208:306::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 17:26:52 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 17:26:52 +0000
Date: Thu, 8 Jan 2026 17:26:55 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] mm/rmap: allocate anon_vma_chain objects unlocked
 when possible
Message-ID: <77544395-0a06-4ca1-a65d-b191ccf14930@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <4ce4ec09b92664091e8935982d83dde3a4c7f898.1765970117.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpHWUj6npkpMsgHmLHMk4NHRzaDyDG2oQk1SuQ53swcMSA@mail.gmail.com>
 <03723727-7fdf-4f06-8117-bbe2d6c2b7f7@lucifer.local>
 <CAJuCfpFvAOBVyv+UaTS+_9scTdPmo2-vsTE98-XSOpZZe=_VhQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpFvAOBVyv+UaTS+_9scTdPmo2-vsTE98-XSOpZZe=_VhQ@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0533.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB5202:EE_
X-MS-Office365-Filtering-Correlation-Id: 301acf28-8064-4042-de67-08de4edb1cfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sF913iQOD+RUKft9lYSrPiv8P1MBEpuj+NXdTCgk5L4KdvbVZcyEDzkhBIZD?=
 =?us-ascii?Q?8XQqvSuFSuFQuCsctpyli3CrhvwTNNlbRfFYf7aeHxNTtzqH5sgwB6WRIs4P?=
 =?us-ascii?Q?XipyDNnqxyBGDwc2Rsc1Mk5GytIp1Y7Y85CSYFLD7HCUH4R4DSWDV3Mv4jXE?=
 =?us-ascii?Q?/koFIWBD+poaG4quryy2ZTA+gQGyJ4FvBChVYHONGPwyT+qFuaahJ5m/h7j4?=
 =?us-ascii?Q?TYnWCY6FO8QexTRQtUa76CiJUzsovSr+EGk9iCkO1+WP2bObpmD/LCPon1tH?=
 =?us-ascii?Q?fYU4WCphm8KwMsE+FbFR3Gjj01O/MwHmY9wp+w68TFF7fHdPOhuAq69Bz43g?=
 =?us-ascii?Q?f0Pi/cM3c1StJL5wF2RvBo2VZovoZO4/VEIJAQJt4ayDmxzUdQA2W8/PI+b4?=
 =?us-ascii?Q?QpgeHOx7yKY5Sr8pPiIPOtM8K0l6UuVRW8z9RigUJPyTCP8DDBanGPqMoiF9?=
 =?us-ascii?Q?p93gKUem4s3h6CBJDmQKM/BzapHzuR3DSjJi6LleycWri2znd3uk51HmQa3w?=
 =?us-ascii?Q?sExnRgjxLDmy3cOpKTq5X1hD1++ozbQGadj7JBJEufvrSc8PbDyuNx6kYF7e?=
 =?us-ascii?Q?Q4Uoa059zauejfOPvw+yNlYiOA/EFHhXrzaai+YPi9oYBrYJJkWV/lq8F5//?=
 =?us-ascii?Q?sjwuRmojl6K4Bod4C5dzjFGO2NAAEzZ+k/6m4TWTs9SOXCn+y5pIHaMCZk4i?=
 =?us-ascii?Q?hqgr5/pa99FIJ6ZQb5//edyeVZtj+Td2G6N/mEV25pkt1Mq4Diz4uK4Vu1v3?=
 =?us-ascii?Q?hMZCHvMp+PcRo6YVAIagdMtX0QUx8Cs8CKR3yF5xog1r1XVB7qPABWYqqNQ7?=
 =?us-ascii?Q?u3E2qF6TH4my+tn962wR2kxBYTfLp5p9L5dphKRQqSXo2B9U4uYcECwcJDA7?=
 =?us-ascii?Q?aIS/9N5dGEA5K6P2pvzah0gI7AyALllxFYmnWH0B9fZ9MVVkeGkoynGFqiDc?=
 =?us-ascii?Q?RX2SLOlThVbA6hnBCpCfaIfLDFD3Kq5pL9YScZrFWw/d93UR7/AerHh2pj7c?=
 =?us-ascii?Q?PJWtMrKHTW8Inovy93EwDSg8GDA3wiHn2FnGaHePlo3siQ1V3ADOE3UdAHgE?=
 =?us-ascii?Q?7TQ1MdGi+NusBtVtijCaGDv+P7I1zCwV6J6AYMuYTEVy6SfTkB1uP/J+LzDK?=
 =?us-ascii?Q?fsDfdoqoS/7lzlGw6P2c/jZwYBVQubWpS+BKDtAr6ITOo/pvNmA3LP7c4FUE?=
 =?us-ascii?Q?xzdo7ILjdi4H80+y9Z1tWm/b4CPtOqM4aX+cEpDVEX+KlJSBBHe9o63PSknQ?=
 =?us-ascii?Q?MB8UMP/Q8b5YWW8vMIT5EJKZYtcxjYhXSHlbJF2+QOqxUD03dsUWwXRi6p9A?=
 =?us-ascii?Q?Bnz2gfZRk7uc6HyNiW9prlYQyERFkX1ku5armGPzmIjo9OGvc/K8eOALTL/J?=
 =?us-ascii?Q?XxQUSqhX39mH8GV3VeDywdPHkYs60Upd13yC7h3KObAtFdp8H5Q834tbn+kJ?=
 =?us-ascii?Q?NlpPYoawkBAhAq0Qo9c3JCPBBYl/B39Ks7ngQQW8GvJBFzoczFNsRQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UrvFn0Rg7PiLLjBz1wHvmG7c+An8sr4HjRaxPiZSRz+6IHSAG4ItYOLcDUI1?=
 =?us-ascii?Q?BtBb+hJIv4oY/DYTDnK2e9x5XWHzYFsFtEty5maFuEFncIdTdUoTMfog2cQj?=
 =?us-ascii?Q?OJjspTJzV+QnVBeVkGHlh1IM7nmuUMEHBxGwBgkUv88Vu3Da59DixyHJj33I?=
 =?us-ascii?Q?4gijQvqYX6yb83xxS+zusy/U6c4xbabAECUN68k19a6/RtEIWcZBKH5Kvr3d?=
 =?us-ascii?Q?tg45e9dpKOv8/uJCX5RGOEuocA7yedgo1DwOLVUuyPKBzOrYNsIkQBHuXdDt?=
 =?us-ascii?Q?v3qGdJqbDP6bkgnVavfVgZG37Gj/FxkQw5zfwqJIsy3uGRg8yvTfIxSlKvAD?=
 =?us-ascii?Q?PfADe8CTfHAI/ykw84xM/75SG8MGng80+i7pVLhodhiT2REnx/1Ns7ovAnwK?=
 =?us-ascii?Q?tDcjl2W6JXRy4M0AfrQSmcIWGgvAysLUsOFSKOB1jGKb2CbTaBaV6JyeIsSH?=
 =?us-ascii?Q?FI1Lfy/PduQqFFrXxk5d4QvhcO8xmjW39J9AGH12uLP3QcjWmorhBzxiOdOx?=
 =?us-ascii?Q?4hsBC4UhRnmY73BXbtz8Ut7lCqgGcnnf2h7jRjBSerrnLcMDGjU58V/3byuH?=
 =?us-ascii?Q?qNFxhr7Ime368Mqi7ScGzX47ZT+AuPO1OtrnjbfwH8+2PLEpmQ12AMEKFhQm?=
 =?us-ascii?Q?giaIixx0/1yp4SZDti2/1JK5ynRwhB1kFksnBXZOxFxtWKumWnAGV4H+3NcD?=
 =?us-ascii?Q?zaKBw0XkoDkdi3FLsUhR/T2S31cMQlY7szwqdL6kJ9NRdSBwShQvydAJJvDG?=
 =?us-ascii?Q?CcxYXEQGhHGtEfpdcbgkLKPnUj+CwCJ+aok7VzX8QSmcxXDrvfuw7mVEjZEL?=
 =?us-ascii?Q?47TOtubSz3TLi1NFVlW1MQCn+GRwUjhodldGwYL6bEyWM1IVXZDwNRPzVfvu?=
 =?us-ascii?Q?hnY2+uxorx0+BZaf9u4TAsFpZPpv1jf7snhAsW1q+XRvHrRPFxA4kaWzt0Yn?=
 =?us-ascii?Q?67Dfg0bZLARUjcSlPv8/QeXG53O8n73cNLehVE+M5rOl2tzbHZjrfN5re+Cz?=
 =?us-ascii?Q?KVIE53scO59jv9nxpNX5sxrBsW30c4zfSl4t3FSjbE/hIUjcJ7YS3tF4QJOg?=
 =?us-ascii?Q?k+v6uPDk0a+6UDFtJTGZv3Y6oNE5wHxxN2I5dXBduoFoJ9FH/KZz83dZo7J8?=
 =?us-ascii?Q?c/XFRZzpt9C0tNV2zS90IEa1gQ6Yjs9K2UsJQONsaobhLII4PqjQhoQSwUKe?=
 =?us-ascii?Q?JvMxHTMvv/n9RzLQVHfyNu8VeppABzu/f3mNS3h6MiPb2OtQ55NMCdUgmuvv?=
 =?us-ascii?Q?ndAiw2jL2qvhvNs1/v1bLDPTGfWxqM/Juf2XVZI0qG5pqu0jSYVnBX87yRDQ?=
 =?us-ascii?Q?z/uZDif5sDFM04TudnvLtPRCwugokdy/fjq3zLSeQTpFjg63VYSgMuR1CRYa?=
 =?us-ascii?Q?j097ImjLGYB7HXno/vylA0WRhT4jMnuExr5V1ex23LWd9UIUhacblIWxZPno?=
 =?us-ascii?Q?hXO2k7D6BbiYqxWambGTFWtjIEtsKoScCtY0Ii9kOOIE4q0EVjElbznVFqyd?=
 =?us-ascii?Q?fSBDfH708lIplqrbAmgcjYCUrdnWaJVsbIXcv3kh3pnFo8gN3RO1irtwpB0+?=
 =?us-ascii?Q?hudj6w83GM5AoPk7WUz49kbgh/wZmkXo6srDTNI/8K+40lYQCFTFLCZbekSM?=
 =?us-ascii?Q?ZXevZQCBrQ6w+lRpK2zfZW/Tgjd/sPxozoyt2xEEPPu9FbE6wH+o8/TB+nXc?=
 =?us-ascii?Q?6bnbawoowUxwfUp0fyYeHHquyF4qqkqKDEsIjuYZz7caC6gTjGWVYK8V1md2?=
 =?us-ascii?Q?rZ325k26cXaQ1ECOURPtXGqE22lnfUg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	81tl3PC2qUX9gA5qPxp4bXwY2H1jSbZaggxL9D2fhCPm8sZcgvmWLNidZp1VAJhrxEFzDIBCdAQyDPlONzffIfCMbkTOSOEI0W8nMMF1E5mhUMmw/9w3q+NzZ1qaMFNrGTOAOfn9YtHcfx1sXFhsY69bDtlL1dY6LW7MZRAnmZednBEx/rMKJhlLO+JP/kiieaiiSKYwuQpqDHJ0A+2pA+8tWwRgGKQy0I7zCkV/CYwknjaHa7TeV8zF5ydVFKYWJI3pE3gY+gkP9v+s7bunXN1MOxEXTFHhnAe3zzm9bzKY2CUiccByPEfXcdEj6f+djDlOdrpFrocLXJ6pKJJt6jawgh82Ivt0qAka8Is/VGNoLklU4Qo8pk4gpeqdCibmxRtbssgDDj91X1xk2e3Vji5prKbGeQz43EZgkhAlyWJGhORPf5cWEDeN1xrxEj3ndLO6SvVBupiOBRmEohlRh6+eRlWJsQMzK5oH+5yKkJN3q9UVXWcuq8r0cVOC1sfZd05qmY9Kjhf3z7E61+E0nxok5LtB4z70aHLBANeuYu+66r2rLdxz+rfym6di0KyFsWfIqk1iUIaBjXrTpg2tbOKDAqqeaMIX7JkVYTF/XCo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 301acf28-8064-4042-de67-08de4edb1cfe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 17:26:52.5742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 71D2XyX7lkLSAhdkBVQr1eOM/FAuEbP01pBJ1PuOl4k47OKECM+/SxzdTx5Y0YO1ZDkndWQcNPoS6hSq1XbzcZ5TDit1uHFQbo1ajc6a4w0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5202
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=859
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080128
X-Proofpoint-GUID: UwInrw8TRqOoRRkScZQaYp4rWNGPgBpP
X-Authority-Analysis: v=2.4 cv=JYSxbEKV c=1 sm=1 tr=0 ts=695fe8e2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=P-IC7800AAAA:8 a=a1ubwJbIoWLsJJgBRC4A:9 a=CjuIK1q_8ugA:10
 a=d3PnA9EDa4IxuAV0gXij:22 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: UwInrw8TRqOoRRkScZQaYp4rWNGPgBpP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDEyOSBTYWx0ZWRfX/AGsL2tiTj8C
 hovykQZpaCyIYSYR3mlzo17USqncmuiCBpibYsyt7tqDQsXFm7AK/qspc0JOwEvozgkQ3QhNm6E
 X5vLzN/K82U270fXOjVQOG6SNCG1pqT+75VBctk4+ZjylScG4ur5DF4qHXITOQh0s/H1/eRWEof
 La3pbsfXiEQ0Q02l5prulxzUBlukucWWj7cdmdce46Ph5TK1M3USkHMYMNt5Z8tFj9s2IJrZufO
 mBmgTIHfKpFwVqgTKZwnpHFPssnWh8uunJXiV71zjm5P0PsWStumZLuM6ekV5zz4LVYkkJQG6lW
 IXhGLwNzeCkHL4SHAAd1q6VcXniYExSf7e0jM0GpE39tYj4f5Lybw+81p5CBbgXq1uUjaPqe0XK
 ygp0hRX/sosBDm6g1wIrjoRt1SCOPYNhUaNL2AVq4PhQcIx9FTu7UaH9/GCg+AfL7vdMgX2YCdf
 lM07VbiMtHso/og0uNAFa+9aoeRkkl4f6xwuBN3E=
X-Rspamd-Queue-Id: A77C5C0007
X-Stat-Signature: 35xah5s1irh48wu5pq1b8r85yxbyjpom
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767893230-13431
X-HE-Meta: U2FsdGVkX18spAoA2OwxzB618+s8Vgd5A3OoXREnvFYNaIva1ey8PO6X49b1m2FUTmELJY9zXSn1mPlifDW98UtKsf9BjEN9C07fVA9nH6DFmIZvdLxO9g4Yzuf5+MQg5WT1x7TTxf/MG7LhGrqWqfPQ7JTWaIv0oMgDfBKR9nw3UwC/ea9Yn8WJ5gu0pptIYGlcnyBobMZRB7cYSihP9iGwZZw4Cw01eHlmkg8sn03YrcFclMndNG6EvGpTwgTeaYxyZHaJTuKc0rtbHo3lWSW8i8IRNeGluRu5xZCU2XIWmdK1etQdRD3B7gDY0t2Yx1/XI8jLfdjHwLakdLh8VRe+zFTB8R7YI2K0U5KiaQvMeQ4jQqNZotZpT0coOpJC9n9Z5kTINioOhajrXqPKXuMKlXXiyTRMN1/oL+JUvdPdmVjbOAVn86WYpLbOQTjOC41yjMEryCe3kRt9qY7B3tp32gullQkVUcB0s3EUJb/fdziEYS4mKDc9GRq7E+f47glzA/Xhh112xSEL0OjzyXS21LUOKnqdQDsbFoW4Ma8PmKNYZEttaCF16SS4bbj34pO70427MmYmuvFt+oGhFgzv41ArhEIb5JUpSi+jbJbp9blDrn4AkNpLEIqSn53FwhCvm6AB/BT4KN+Ywz4pqL5TGRDXPsq6oCxBzG7N0ipd9ApjMgqmMjMWnxQmmMPWHtlU8wrheUmh99RW0xon5WM7PQQhtE8xKyzRP38bCW4IzRn34vQL43eOIz/kru2shKP35QDXzUlhT8Z1X/yXtie7kGDkW7zM7J+Suirn/hemTlINXKNDVEVYXhC1iI1DmlfwwBBEIHQEI6kR4LmMIAF1VMS3taijYAzME0ejzxQveHDa5ROBa/nRT06rOj5hOg0Y4ll4DCigN2E22+UtV7hgmHYf54QRWAxWajBaMHzufXO5+Hvi4N08tQTgVBcEEtXtw776TG89tJ+0p/e
 l+HdGQWc
 pwj/XDfHeAweGvIqv6JK/J6R7qMgChcyXF3RqCO/GYPbIGTuwKKwc+vraePP4/0vyaLm68e/SwrU1sPxapEOAAcQXK7c6/XZYaHCkhs80VvU2/h5vqEvImFLEucT0teAcGCWg9KRa+EPjkSLM2uYr04w38x+PzkVD7e+LF6o1+veLjUqBbHn7S09Rw+FM5TYVgnIbHEnjx7TYoJ58A57YIpPsQIECjQRTcR9jHChgMfVLk5edh9O+md63deHhvW7YJLhCuCmoS5ekZn6gd+BMj0d3c2DU19NOXBm0406T+AZ/1lDusz5GPf3w//vvxiEMGiqlbmuDG1TmEtmCcgsb/qR5G2jWX8qEhsXrdH7k4M7MAD/5mgHE3PlDoVS385g0FIbLeVuQ4m6Rcw5UtjOIfKZEZldM2iqsWL9BDRHSS2viYTpaEG6h8AcgOJ7LuIMtZyRwP0yLyTcFAA96j6GzJ+oIfUxBo/YbQvODaQ7jjBlsfNJfO/oCu8jGrFPRMAW3fW0ZavuX2RXdBq9zSZjVGWRiggZBkqHNeUcS5H6+v5TZS2+2S0+y9sQey7MW22eFaSB9XAKFDTYSowQd0TE4EMwvz+1as14kjVOf6QASBA/GMw06FWSVmSjttjkZ7ygpwKK7OKH6e7wt6onbaaUn2pY4/CPWXntYJ9EEajQ4Gqi7jeaaDxBhCIimekpnilHZkHNGLtmA2/00dXKmuU8Rgh9vrlDdULFH72Ax
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 01:20:29PM -0800, Suren Baghdasaryan wrote:
> > > >  /**
> > > > @@ -210,7 +209,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
> > > >         spin_lock(&mm->page_table_lock);
> > > >         if (likely(!vma->anon_vma)) {
> > > >                 vma->anon_vma = anon_vma;
> > > > -               anon_vma_chain_link(vma, avc, anon_vma);
> > > > +               anon_vma_chain_assign(vma, avc, anon_vma);
> > > > +               anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
> > > >                 anon_vma->num_active_vmas++;
> > > >                 allocated = NULL;
> > > >                 avc = NULL;
> > > > @@ -287,20 +287,28 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> > > >
> > > >         check_anon_vma_clone(dst, src);
> > > >
> > > > +       /*
> > > > +        * Allocate AVCs. We don't need an anon_vma lock for this as we
> > > > +        * are not updating the anon_vma rbtree nor are we changing
> > > > +        * anon_vma statistics.
> > > > +        *
> > > > +        * We hold the mmap write lock so there's no possibliity of
> > >
> > > To be more specific, we are holding src's mmap write lock. I think
> > > clarifying that will avoid any confusion.
> >
> > Well, it's the same mm for both right? :)
>
> Hmm. I think in dup_mmap()->anon_vma_fork()->anon_vma_clone() call
> chain the dst->vm_mm and src->vm_mm are different, no? After
> assignment at https://elixir.bootlin.com/linux/v6.19-rc4/source/mm/mmap.c#L1779
> src->vm_mm is pointing to oldmm while dst->vm_mm is pointing to mm. Am
> I reading this wrong?

Yup that's right sorry, and I even make that clear elsewhere, I'll send a
fix-patch or something on the v2.

Cheers, Lorenzo

