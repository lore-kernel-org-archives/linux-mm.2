Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46103C44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 20:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69CE86B0005; Wed, 21 Jan 2026 15:32:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D986B0089; Wed, 21 Jan 2026 15:32:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4E36B008A; Wed, 21 Jan 2026 15:32:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 398EB6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:32:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB86014032B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:32:10 +0000 (UTC)
X-FDA: 84357118020.27.B7E0894
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010023.outbound.protection.outlook.com [52.101.201.23])
	by imf18.hostedemail.com (Postfix) with ESMTP id B88E51C0002
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:32:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gAWV4ETh;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769027528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rvRZYX+Xl/bahxWydpUxbjdURGCBdKgedbLW/Efn1CA=;
	b=jHVvGKL2mmZ6look8FWtZz5Vf8UwdlZTuq2ZtkoI05lrYg0tyeP456xjcGy9HE1uCnY0pG
	LH+emGMzOm5TU16ALq85PmjQW/GQPt8ZnCTmsD1htPSaPrlhqvB9/NZUIGQP36qNHjzZK4
	1+uYzNRyQDwWn+fAZxbb8qkA7xObyRY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gAWV4ETh;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769027528; a=rsa-sha256;
	cv=pass;
	b=NbAv8vRWrSxUKUL5hjBI3Pld7dnY5GSWkCwdSJB7NlEnePJ6XIsCXra00vgRjX0yZFF+us
	Cf/HKnfBRhI+DxFFd1ghAEWNN69uaSyzc2p/OO7K8uoeoh+QefXgyEiWqcGuNdJfxTwi4p
	iXRUmV9GpYI70o/LO9GeZJcYICQDSfc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aZEVR6ON7oz4R1+fVzWcnnhZ+um2xKUMJ2e9kmDBz/HPpRKQwuJuf8HEfM6Qq/6k5Qo/Pfau58qoU9eLZ4sqm+aA+0i+vOoBmSt6+mYE8SdoqYHUdK1STZ+xQvIw5jFJ7oVcz1DyR2lxsDCA33MSUUve86EUhg0ENZWGGXY4WPUmZ5a5LxegnAh399tf0dsvnj0WbHEcABRQ7WzMYx69m+R+MLdH+AXStG8WgKHREVWeeSu0sPenC4gfkwD/sXX1USwuu1sCIV9baDVHeSivli2e8Tjbgc+NQx8uJNhHZ47PqCzb0B5SvKHQ9Q4g9y17zCJerGcfbGWBQ6Y/+5DZEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rvRZYX+Xl/bahxWydpUxbjdURGCBdKgedbLW/Efn1CA=;
 b=Gm91OuVtrnxoLB132/l3asQQYkdEDaumF3yRjmCE1TR/Bal6eThc3dUcDX0eh81AVVeztn3uJzv+h6rP8o5uzuZr2wqGL1Ixm04p9U6YL6zlek9nNH8Run2BffSRDrZnkzBztcDODyME2aaTR+d9+4Dh+fnG6Rexjp2KBqvgUn4oZ9xFVNUi8qzDqY9wF/ErpVH23UuWt3UG54kq7mpc8Cx/AZWY4xrJlzRJMuNroL3+SvdIKudhWKdW+bU5a1c1e6ldFOPFviCH9Ur7fmuKBqOe+l7qR+Vm5OAcBxFv/Z0smgpKa1ke8jWudZkxBhWK9UQoKdLqaUZXPnUvCRh8DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvRZYX+Xl/bahxWydpUxbjdURGCBdKgedbLW/Efn1CA=;
 b=gAWV4EThnp8Zbb5pur5TxO3njsPglpNFYx5Igt0coePT33HZ4gXEUVC80MBoPP5gswL6oaGOAzA9lV4YK7XBeFd4O1fjMiOql+g00/6VTbcSMSJ0/mXZBusu5haR10etFyD1JlleHJELruJ5IP9OWRlfXc/E6KB4L7e04tOCNZJ3cRRKa3OJbfiYNKnk+RNUZ9flDQybp1binj2S0ydeKyENSMhO+OtSyUmeoPQk/CSub/b0XkflTdTU7zV5sfPYfVylw5s0bKRSvlML7kbMf1N7kYJLOrQhu8Kk5/vBfg9Mck+odyYRAWwf9yJ/Gsh4CNZuf1URHfmU7cBKLuymVA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH8PR12MB9768.namprd12.prod.outlook.com (2603:10b6:610:260::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.9; Wed, 21 Jan 2026 20:32:04 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 20:32:04 +0000
From: Zi Yan <ziy@nvidia.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 00/14] mm: Eliminate fake head pages from vmemmap
 optimization
Date: Wed, 21 Jan 2026 15:31:59 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <E99A40AF-1535-4FC0-BEE5-6F0F5B3FF840@nvidia.com>
In-Reply-To: <bc7b8c62-a8b3-4407-a69f-30b3fd269566@suse.cz>
References: <20260121162253.2216580-1-kas@kernel.org>
 <bc7b8c62-a8b3-4407-a69f-30b3fd269566@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH8PR12MB9768:EE_
X-MS-Office365-Filtering-Correlation-Id: 248341f7-618e-4d14-a64e-08de592c2363
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWswVW5QdVlsMURVVjFhcElNS2swR0pvNW5CajA5VUMwZUJGZUZWOUxLTkNh?=
 =?utf-8?B?ZlRMdHRFalIzWWd6ZCtLZFJXOVlOcmFVK1ZadmZCbEVVMkVmd1didlBIRXEw?=
 =?utf-8?B?TjhJRkZaWGJJWEZjeFZqSUkzSnRXVHBYSWFDWjBjNkx6SC93RXdzcEJCdngy?=
 =?utf-8?B?VC9VWVJOcEtqaEdJUHYxRjZwUEJZN2ljeEV0OEdHcGtTT3pZekwySFNhVklo?=
 =?utf-8?B?dmhRdDZuM2Z6bVZaWXNnRWVyL0wvdzBmdUREU0gvb05hNUVjZmwyY2VMTnFu?=
 =?utf-8?B?L2s1cjVMWCt3SjdVUittd1dweWF5T3pPb2ZiSG9mZC9WbzBxSVpyd0xYOFlE?=
 =?utf-8?B?OG5Od3M0cFk0alNiRzVYZE95MnZlUVVqL1RyeHY2aVN3YVI5dEhTam1xZXU0?=
 =?utf-8?B?N0lxUWsxUDhzSU5Cd29IWWZsWmczRng4YjNyTTZtQ2g1QU9vSFJ5RHh6dW1w?=
 =?utf-8?B?RTVRWndJOFdNL2hIM3gvN1BROTZKRFZKbnArbVdUL3BwdmI1ZFJ5N2w5cjgz?=
 =?utf-8?B?bU1YMHE0bjR0djR0M1UyNDE5UGgybUNIUThwdE5RSlFRUXJDOTJLZHJ1V0hp?=
 =?utf-8?B?ZGRWVmVrdmYrcHpGUG9ickRwUTl1Tk4ydGU0cDFZTmtKdHV5YnlRZWdYNDF4?=
 =?utf-8?B?VVJiWmdKRmpzckdsTGhDMytGV0pKaGtReWtCVXBvNm9RbDlxSVl5YUVYalZW?=
 =?utf-8?B?MHdrem93L0YxbmRUTzVVS0E5WXp3U2NwUlRONEdNcTNFbmhOZU80TlJORkZs?=
 =?utf-8?B?THlqL2V3Rkh0S0YzTXJwOWl1OVpPaGpzc2w4TG9WY0M5cERRUU1wV2JCQzNq?=
 =?utf-8?B?bTd4U2lXQWhwcnVTS1ZvSHViN0JyMkRSaVhoVDhMdzIydk13eXA1SFdFUzN4?=
 =?utf-8?B?TE10akZMc3ZJOGFPQzdFL0ovb3h3Ri91ZnZmbWlrbzJrNkJmYlRJYnVGSFBC?=
 =?utf-8?B?WXRaeS9lN054SjU1aVVsL0hYWkFVWUNnSWIwMkgzc1NhVVFHNlpNKzh3eEdE?=
 =?utf-8?B?QmwzaUpWbVB6clAwNnVFU3QxZDF1V09HNkI1MlVOUWs2WFJiWXMrRGxUaFlh?=
 =?utf-8?B?a0EzcTdjU282QlU0cTk5TjVzeTRFTFVmaVhrSTBLOXc1YzRTSzl6RDdIMWkv?=
 =?utf-8?B?emNpVWxGNGY2a2R6U0dDd3JoMUdJckJDaEFpTW4xVFliU2JrQjBrTGZqRU1M?=
 =?utf-8?B?MTR1Y3ZPRkxXN2lZSjVxYjdxc1l6V0VVck9xRk44S3Rwb3BJejJFY1VKQ3NE?=
 =?utf-8?B?TXFYUlJJcFdEVGNLVnVvbjIwV1gyc1dXTHdJemIrUjgwdFh1Z04zMENPczFn?=
 =?utf-8?B?UVlRSExzYmxCYm9KQyt3UUNLUDBpNlR5YmlVbHdzSlNISTZrbzV0WXBZdGZo?=
 =?utf-8?B?R2psb3FjM29VcUd1NWJDRTJPeW5SMmlMK2sxQW5JdkxUR2FnbU92RlRvTDMy?=
 =?utf-8?B?UlJRT09YL3MxSkY5NzJ4T3pZUUI5YmdUZHVaelhuaFBlV0ZrWWZ5N1FZSnJv?=
 =?utf-8?B?WkFEaStSSHg4UFEwN0MxQjMvakNtbnIrK0R3RmE5ZTI5bWFSclZobkNXbXB3?=
 =?utf-8?B?MjJIaTFxWkErZXZmRHR2NTJHM3BrWndMY2o1bnphV1JoQ1BSQllBSVVaZWR0?=
 =?utf-8?B?eXp5elJoWlNJaDFDY2ZEZnpDZTFmY0s1azBoWGcxTDdkNzVic0s1b0JNOU10?=
 =?utf-8?B?SXVkOHhUT0o2Mmp6R1kwZmJrbm1rbGE3UHFVd2JFbGMya2lMc3dSNGt5V2kw?=
 =?utf-8?B?S0tEcHo4R3cxV3F4UWgzWkVybTB3c3lKWWEvQk4rd3pURTVMd09lNTZKd2s0?=
 =?utf-8?B?SDZ6RmIrNmpTazZVUmk5c3FDZnI5WlNFZ0g2S0xHS1IvalJsdXNuZkxYWGph?=
 =?utf-8?B?YWZ2UzFmRnJMRS9heUwwYWtRTElpRnJoWWg0bUtSTUpIVEhMUXVJU3NRZnlU?=
 =?utf-8?B?OHlmRHpsbWRxTGxqWUF6dUlkS21TMWN6ejB2RWNCVWxST1ZLSXJFZkwvejJI?=
 =?utf-8?B?Q2RrZXJ2azlYMDJ0RFhacDJuSE9wYVpNTzNEWnJ5QkFjdloyaXlsKzg1Vy9W?=
 =?utf-8?B?bDFkRWowY1JDRlBjdk1uOWVyVXJTSTJ4a3JTOUtTWHBCck01Qjc5MUl3L2kv?=
 =?utf-8?Q?dzXY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTlZcFcxNXRmK29zTTg1ZmtkOEZlVDJnTzN2ZHdZdnFZazVqczNwZ2c2TW0y?=
 =?utf-8?B?SnlZSFZuMzRPSldDYlMxWm9xZml6VVVGSHpnTGtTZEtXdk9DOEpoVnFKV2Zk?=
 =?utf-8?B?NHpFb2lnOE1lR0NJYWNGRm1pMmcwNVB6UmtTMytHZ3ZiVmU4Y3dEekxVNVNS?=
 =?utf-8?B?Y1J4Zmo4Qnc1K29FdXI3QVRFRWw1VGFLOWNUOGhDb0FpY2VqbFVCMDBpYXpy?=
 =?utf-8?B?YUI5UDhnSDJETVdXbTc0STZaZjhMeHJXSFNCaWZ1RHp4QzFWVTU0UGpoYVJK?=
 =?utf-8?B?c2RDbCsxdlY0bEYyWjB5amdBQldtcGdueWlvOTFIc21Dbk9ueXZHeW5kUVE5?=
 =?utf-8?B?UmgvbU1NVTUxK0FrSUJwOG1nRGtrZlRpNDR2NFdIK2JYc25wMlNBdGNmOVlm?=
 =?utf-8?B?QnJIMnIrWDhGeng3K0d4ZkZmUHRjVlNtRnB5M3JqMHoydno0QmxJSlpsdVNz?=
 =?utf-8?B?UEpEbTZtdDh2KzNZTFE0cWpkeW81UklWcW93UnRIcjUvS1c5NUF6SDlkb3Vp?=
 =?utf-8?B?Q0huTU8yUmI4UGpDaCtJRzZWVWNOSnVYclozRTVCSlR3Q08xR0x5TlJFd1pD?=
 =?utf-8?B?SkZmODVCM1ZDMVNaRXVIY0wvNXgxc2JMWXB6ZVllY1hYSkpkMWxDbHdmWktx?=
 =?utf-8?B?b1lrQW5wOFBEU3Y4SE1WMWI0aHlRU28wT3ArRzhTeHF5NndLNmYwSFNPRTFB?=
 =?utf-8?B?WEw2OGpyRjNqTjk4TUtrSnJTTVVSN21VV3JiS2tpUWI2cjgyWU5SR1ZwdGFK?=
 =?utf-8?B?UzBOUVF3UXVLNnZnRGhDRTRmU1JOVWJ2YkhIT0preFFtRDJnRVU4Q1EvWkVq?=
 =?utf-8?B?VDJuR3liUlpoM2NPaTg3R1RyWks0WDJNaWZaU08vdmx5MWNVeUk3SUkydjR6?=
 =?utf-8?B?bEplOFlCM0p3N2NiTFlLN3hLVVJkeFJ2Z1d4OUxiT1JoOVozdHJNaVNHVzdW?=
 =?utf-8?B?NE1vV0VPRWV2anJIZ21EQkFQUWEvWW5nQTk0MEVBS1k4YjBTWDRid0ozVnhH?=
 =?utf-8?B?WkN5cEJVL0dTVjM1VUhYUXhmQktYVlV1andtWjNRU1QyK2VqdkhoR2RNT1dB?=
 =?utf-8?B?bko1OFRNdEsxdXBIS3Q5RXFtQnJ6d21vajFTV0RxYlpPcmNYdkVRaUxKRG5B?=
 =?utf-8?B?RlZENTJva1pSNDV5VWVWVnhUTWcrV3Q3cnNrOXdSNjVOT0lpdDRvYWpQY3Fo?=
 =?utf-8?B?RFR1UkwzRW50cmI4Y25vby9yRG9RdDgzbitHdWJNalZUZUtWV3ZTa1hXV1d1?=
 =?utf-8?B?UkRlRStPeng3SHVEMmxhMnhpZkZBTk85V3ZONTJqeE9YSzZCd1hSZ2tHc3hv?=
 =?utf-8?B?QkNYM1gxWDIrVnJUYzUyaWhNR1g2QjVHbTBLYTVFaURzWWtYS3NsWWdNODh1?=
 =?utf-8?B?Q2pPU0tNMWVOL09qczZObHJETVNyL0ZrZE9GK0tTM0FSTjlueDFrN3RFeWg1?=
 =?utf-8?B?UTFtUkhLYmtXU2tSZWh4bCt6bVpWQk9XVGRqclprOVBxL0FKV0k5VnlCOG1G?=
 =?utf-8?B?TFBqS0lUT3VSZkFHMDVrWTkvY3hqN1QzbjM2YWVKcDRTTlNwblZQdkJyY1pK?=
 =?utf-8?B?VGd1ajM3TnpxbG1BQUNFaThnOHIxcUV4K1hYV3RLeU1jbG5FU0ZGSVNCOWFF?=
 =?utf-8?B?Umg0R01ObmtqSmlZSUdSQThJOVJLL0hML3o1Sy9FV1lhc0FDUUdYTkJKaUNM?=
 =?utf-8?B?aGhRdjE1VkpueUFwRGZjcVhkZ0pBUTlYZWlNcWRBcWFzKzUxRWx4TkpjWkxE?=
 =?utf-8?B?bVJuV24rWjJUclhLZWlRL0pqSXdZYXFUUzhUOTZxUGUxSFpRZGVqeFg2MExj?=
 =?utf-8?B?WkZ0QVJlckdIb1NHNXp1WWNLTmVncXVuRjVFaUdNaUdtSkhHY1FRQ2JNcnhs?=
 =?utf-8?B?UFpXY3oxS3hNdVpjTlRQS0hFa2RUcEIwZlFSU29wNG9QRnJtWUZRQnNCWDBF?=
 =?utf-8?B?KzNFdURCYkxqS1A2cFFuQitUNVhqQ1phRDlNdUFiSTFOZ09GR1g4NnZOY2g0?=
 =?utf-8?B?bUhocTVoRUlWcWRzSVZDTzd3cGNGN3dDNDVIcWVzLzVNeStzby9JTnVjSDlP?=
 =?utf-8?B?bjZmZE83T3lQVkJ1bTIrOFpSb2JlMHpJRjRDeGZpVzJWQkdiTTFkb2Y5aWYy?=
 =?utf-8?B?aVUvZiticTVHZGdsTWdRR2VXeTh1M01qalhDeHJ6d2dVSUFlbDc3SUt3NWp4?=
 =?utf-8?B?bjduMGtoOGhjblpZUkFVYTZuZjBEMWU4QTA4SGkvTXlIcXRXTmFIMWFyQTFY?=
 =?utf-8?B?THpCTWZpbmlmNGdGSHBRdFF3M1pyaXpGem5jMER0Tk1sdjdWVE9PRm9QOVN1?=
 =?utf-8?B?R01nc2xvRHJodnB0VXlOL1laYmRoOXlwMFY3bVB0dzV5dzN0cVBXQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 248341f7-618e-4d14-a64e-08de592c2363
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 20:32:04.2147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GoxqVEJ5iLh2mHbVD4rxCbUc2fQ7M26qjxhA/o3SuCWSplWWExnwliVEFDNY9yXK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9768
X-Stat-Signature: n1s8w7iwrg76zhkoins7frmou7i8fazw
X-Rspamd-Queue-Id: B88E51C0002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769027527-68088
X-HE-Meta: U2FsdGVkX1+wKAwlKKsEg1oOqwkEUNk3/1Q+3Dy0dKG+kbTKKIoQzEQtYEqtde9qMOsjdV+ATib5f/6QWRsUlbo/rnTOEfSqkFaJgMUEG31K6A8t4oW5Vz8v80lVbNssluRp6Bp3vVcEQvBtUZLkhfsMmABVXb3mBiP0I70Hux4Ff22RWoZ7VqwfBi16Kb79PkpBPs/O86bjbnCQ5LfuITUtiPmut2/+9Pdh6N35d+D7kWOeAurY9ARcCgNfeZEi7/wGd0YP29Ko+GXQPdYZbQVlhCGc46DJt4HMZ/wzvgEvlN2B5IKMPEcFsFiikTJ952OwGytHLamUFC0AshJiVBUj4Y7ZaVrbZdk/PT06NgQ368XfDa1OkDJWEVQkzw3EZSJRuNTvJf/f6m7SwChAUKDdEqtnzHtfPGDZ/8SLsPVOnenvNlPbsko8odMjkYt4btDwxg5+tsggjQTluaDjWU8sSrTm8egzf3UEU/Xv0VK9IT5PBCDFif7pfSBKbPDnC8uM9KESakkK/ZSUP7/tUcVTvjxf+n2m+4BefPbSS3zVuSvpH511G1gFZyAcCfQCPM9c5MUrK3OTw7BSNOYyMLTbensGF1yLR0YpnjGuLBHN22Th8mwnnkoPad8Wo0s62A9CwG4pTD6hFleZL/DPKeCtEV+qrkyzmU4XOqQOKz9v98QB5EML62FOgXeQA/Kri1B/nUfSz8e8V1H8ZHsmOB5fqTqs99+Bw8Di3s7wi0Pj24xG+oaPZT69AALiH+sBgALTp4F3EuLbjqGyODrje1j6ITCx+te5UbiB3uWdqfa4KvcAu5beyGfXIi0ttRYZdzr4UV1Pr/TjWkszJ+FClp4aWzPnYaBe3ovXD+3vy+yPCnfInvD+fK4uE8vzKLo8WfVd77BDl1xN6fpaZhF7xcQH0o4EXh2DuC8FSNXZ0D1TA2ifr/N5o1rCh+jN/SE8yDsbT5e1TRXMWf3h0xr
 BV9e3fvE
 bQE+L1IxoBdpN9xq7jckuSgHjNuUaZI6+iHRRC72FUDm1lRg+l86VCE1jZmVOjNSvuw16GaR7AsNstrWrFRWcoux/4bw7ovzEtaBoUCyvwY4tS1lip+fJUMbNQzA4nCZKBDTbunDuiqZuDyASVmQdk8gZVBiQjARsZWF9vliItah2DbZWTnoYpJae5VpCK7aMe1jdAJ87v+eO0BwMw0gzGu+APU5pu98BRHYKyYp/CXea2IyqTUGYz2xCXpDSZACiiVlb3xMWSHg2KXo9Q3nJEiD25k1ts5iGZYwUgU3yDoemR5T53OSVKSNMjqblocbBZAoH33sRxW8oUI1ZflaeltSM5IHr7895W3SuhTVHhc/B+RIzjhdLXz2WSakYUaZTIu69l4yKHv1u053JhDaaUkMzEP0PPVOQSEDxPY/T3LambcM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Jan 2026, at 13:44, Vlastimil Babka wrote:

> On 1/21/26 17:22, Kiryl Shutsemau wrote:
>> This series removes "fake head pages" from the HugeTLB vmemmap
>> optimization (HVO) by changing how tail pages encode their relationship
>> to the head page.
>>
>> It simplifies compound_head() and page_ref_add_unless(). Both are in the
>> hot path.
>
> We never got the definitive answer in the previous version discussions
> whether it's worth to do this now with the upcoming memdesc stuff, right?
>
>> Background
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
>> and remapping the freed virtual addresses to a single physical page.
>> Previously, all tail page vmemmap entries were remapped to the first
>> vmemmap page (containing the head struct page), creating "fake heads" -
>> tail pages that appear to have PG_head set when accessed through the
>> deduplicated vmemmap.
>>
>> This required special handling in compound_head() to detect and work
>> around fake heads, adding complexity and overhead to a very hot path.
>
> So a very stupid question, why did we remap everything to the first page,
> and not instead create two pages, where the first one would contain the h=
ead
> and the first batch of tails, and the second one would be used for the re=
st
> of the tails? I'd expect it wouldn't make the memory savings that much
> worse, and eliminate most of the issues?

I think it was using 2 pages before[1]. The benefit of using one page is:
=E2=80=9C
It further reduces the overhead of struct
page by 12.5% for a 2MB HugeTLB compared to the previous approach,
which means 2GB per 1TB HugeTLB (2MB type).
=E2=80=9C

[1] https://lore.kernel.org/all/20211101031651.75851-1-songmuchun@bytedance=
.com/T/#u

>
>> New Approach
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> For architectures/configs where sizeof(struct page) is a power of 2 (the
>> common case), this series changes how position of the head page is encod=
ed
>> in the tail pages.
>>
>> Instead of storing a pointer to the head page, the ->compound_info
>> (renamed from ->compound_head) now stores a mask.
>>
>> The mask can be applied to any tail page's virtual address to compute
>> the head page address. Critically, all tail pages of the same order now
>> have identical compound_info values, regardless of which compound page
>> they belong to.
>>
>> The key insight is that all tail pages of the same order now have
>> identical compound_info values, regardless of which compound page they
>> belong to. This allows a single page of tail struct pages to be shared
>> across all huge pages of the same order on a NUMA node.
>>
>> Benefits
>> =3D=3D=3D=3D=3D=3D=3D=3D
>>
>> 1. Simplified compound_head(): No fake head detection needed, can be
>>    implemented in a branchless manner.
>>
>> 2. Simplified page_ref_add_unless(): RCU protection removed since there'=
s
>>    no race with fake head remapping.
>>
>> 3. Cleaner architecture: The shared tail pages are truly read-only and
>>    contain valid tail page metadata.
>>
>> If sizeof(struct page) is not power-of-2, there are no functional change=
s.
>> HVO is not supported in this configuration.
>>
>> I had hoped to see performance improvement, but my testing thus far has
>> shown either no change or only a slight improvement within the noise.
>>
>> Series Organization
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> Patch 1: Preparation - move MAX_FOLIO_ORDER to mmzone.h
>> Patches 2-4: Refactoring - interface changes, field rename, code movemen=
t
>> Patch 5: Core change - new mask-based compound_head() encoding
>> Patch 6: Correctness fix - page_zonenum() must use head page
>> Patch 7: Add memmap alignment check for compound_info_has_mask()
>> Patch 8: Refactor vmemmap_walk for new design
>> Patch 9: Eliminate fake heads with shared tail pages
>> Patches 10-13: Cleanup - remove fake head infrastructure
>> Patch 14: Documentation update
>>
>> Changes in v4:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>   - Fix build issues due to linux/mmzone.h <-> linux/pgtable.h
>>     dependency loop by avoiding including linux/pgtable.h into
>>     linux/mmzone.h
>>
>>   - Rework vmemmap_remap_alloc() interface. (Muchun)
>>
>>   - Use &folio->page instead of folio address for optimization
>>     target. (Muchun)
>>
>> Changes in v3:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>   - Fixed error recovery path in vmemmap_remap_free() to pass correct st=
art
>>     address for TLB flush. (Muchun)
>>
>>   - Wrapped the mask-based compound_info encoding within CONFIG_SPARSEME=
M_VMEMMAP
>>     check via compound_info_has_mask(). For other memory models, alignme=
nt
>>     guarantees are harder to verify. (Muchun)
>>
>>   - Updated vmemmap_dedup.rst documentation wording: changed "vmemmap_ta=
il
>>     shared for the struct hstate" to "A single, per-node page frame shar=
ed
>>     among all hugepages of the same size". (Muchun)
>>
>>   - Fixed build error with MAX_FOLIO_ORDER expanding to undefined PUD_OR=
DER
>>     in certain configurations. (kernel test robot)
>>
>> Changes in v2:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> - Handle boot-allocated huge pages correctly. (Frank)
>>
>> - Changed from per-hstate vmemmap_tail to per-node vmemmap_tails[] array
>>   in pglist_data. (Muchun)
>>
>> - Added spin_lock(&hugetlb_lock) protection in vmemmap_get_tail() to fix
>>   a race condition where two threads could both allocate tail pages.
>>   The losing thread now properly frees its allocated page. (Usama)
>>
>> - Add warning if memmap is not aligned to MAX_FOLIO_SIZE, which is
>>   required for the mask approach. (Muchun)
>>
>> - Make page_zonenum() use head page - correctness fix since shared
>>   tail pages cannot have valid zone information. (Muchun)
>>
>> - Added 'const' qualifier to head parameter in set_compound_head() and
>>   prep_compound_tail(). (Usama)
>>
>> - Updated commit messages.
>>
>> Kiryl Shutsemau (14):
>>   mm: Move MAX_FOLIO_ORDER definition to mmzone.h
>>   mm: Change the interface of prep_compound_tail()
>>   mm: Rename the 'compound_head' field in the 'struct page' to
>>     'compound_info'
>>   mm: Move set/clear_compound_head() next to compound_head()
>>   mm: Rework compound_head() for power-of-2 sizeof(struct page)
>>   mm: Make page_zonenum() use head page
>>   mm/sparse: Check memmap alignment for compound_info_has_mask()
>>   mm/hugetlb: Refactor code around vmemmap_walk
>>   mm/hugetlb: Remove fake head pages
>>   mm: Drop fake head checks
>>   hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
>>   mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
>>   mm: Remove the branch from compound_head()
>>   hugetlb: Update vmemmap_dedup.rst
>>
>>  .../admin-guide/kdump/vmcoreinfo.rst          |   2 +-
>>  Documentation/mm/vmemmap_dedup.rst            |  62 ++--
>>  include/linux/mm.h                            |  31 --
>>  include/linux/mm_types.h                      |  20 +-
>>  include/linux/mmzone.h                        |  47 +++
>>  include/linux/page-flags.h                    | 167 +++++-----
>>  include/linux/page_ref.h                      |   8 +-
>>  include/linux/types.h                         |   2 +-
>>  kernel/vmcore_info.c                          |   2 +-
>>  mm/hugetlb.c                                  |   8 +-
>>  mm/hugetlb_vmemmap.c                          | 300 ++++++++----------
>>  mm/internal.h                                 |  12 +-
>>  mm/mm_init.c                                  |   2 +-
>>  mm/page_alloc.c                               |   4 +-
>>  mm/slab.h                                     |   2 +-
>>  mm/sparse-vmemmap.c                           |  44 ++-
>>  mm/sparse.c                                   |   5 +
>>  mm/util.c                                     |  16 +-
>>  18 files changed, 369 insertions(+), 365 deletions(-)
>>


Best Regards,
Yan, Zi

