Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41C49EB3625
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9F56B008A; Mon,  2 Mar 2026 12:19:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B5C6B0092; Mon,  2 Mar 2026 12:19:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952BD6B0093; Mon,  2 Mar 2026 12:19:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8430A6B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:19:41 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 445411B705E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:19:41 +0000 (UTC)
X-FDA: 84501784962.03.733F0F2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0D53A80012
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:19:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mvzN2nZA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=e3KR6Ral;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772471978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P05FFqDaPP0nupzQTCFlyKR3+x3C+P0hyYZLL7kcOVk=;
	b=Upe/+h9x7wxq985oX8KrxO4PbYMLa3p+Q3owyOAnd9IjXXLzi3VRU1M42JxqTpqqQSGmxh
	oM5x+6epp8zZH2YHjlhyj3pMbbmZb8Ho2xvjMml2EUPxPvD5dbh/sUjuKuo5NsEtIE5/1a
	++HtD08x3RSVaBGqjGElS/7NMRMrsBU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772471978; a=rsa-sha256;
	cv=pass;
	b=oqTHn8n191u++tqSrJO6rgeeZq8ua9bvv19i2Vez5DkRV+mP/H1LSeztzjUFNjxwNVkam7
	J1WX5swSiEtJNkxTiCFzlmry5GA7ghrP2b9vD1zgu+lduc6u3DR4TcxKoWLsErwmbxVmbz
	G2CNvWVcP6+VGBeSt9ozsH0vBw0n97k=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mvzN2nZA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=e3KR6Ral;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622EX49N1250425;
	Mon, 2 Mar 2026 17:19:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=P05FFqDaPP0nupzQTC
	FlyKR3+x3C+P0hyYZLL7kcOVk=; b=mvzN2nZANcnrGL0JQaZKGl7p6mH8ZuAIEF
	uxtWv+M5bV7B/CgG91R+Yn7oNogOjPTllTtTeLwWCz0lD9C1pa4qLcdGwUy9POIV
	PcjcACEP30FQ19sVoHl4c/5DK9C1ByKN4MiH/8w5gl2EY4fmbdlvAWQ0LMQWQt3M
	wRrnna37jFdphCY2g24vnQRhUjQCVoyhTqgoGy2R/2HzwaqKjzYeFywWrjxp8PEJ
	F8lg1NLG/rdIszi8LpFmUIFG6WvE18IHVjZEiEgGly16B/GD8fDFK+NM6zZ9TbIQ
	+5XSkCShkieAsimE+uH3t6rjevuoUrMLJ/hnOGrp6FjL2d/BpMuQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cncdc09qj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:19:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622H50Or036938;
	Mon, 2 Mar 2026 17:19:22 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012067.outbound.protection.outlook.com [40.93.195.67])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8xp0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:19:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PZ75lqAZB3KsoUgEMD6YucNs6YXQHDMhL7aDbTdSvERhicGzgUsGwkeNqugXIlZD1cFUq/6in6NavucvjDhftmoKeDfCbz6wRPeNN+u1Q3C7oqAootMbVk68ZNL5FhuscqPxCunjYS0KXBs5RZjdsdVn21Zaja0UVKeP4+z3rBieEhhDKj9I6tmdfqvahw4/om/bippCWcUKbjF9nxTNUrjpYbt7nlw/k6n5iGRktXV8sTwE90Uney6afZtCr4PXeuqfYw5SFEBv3GzYRzTgt8+PUMv0nOi/1Eok/BvU+ppUo/QIYJF8RlUvgFIzetH+1SCHEuvVV5nKcqYuc25rGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P05FFqDaPP0nupzQTCFlyKR3+x3C+P0hyYZLL7kcOVk=;
 b=BUhqkAmyNM/av8bx0kWaNiMFCa9I1i0LRDXRGV7nMZPx0UOyC1UWs3UuDIe8xLQ2e3VNVPL7fjA5FHcUIrQVCn7WlzQgpHMYk9zSA3PSmz4faM24La144EegtPl3X0OW65nmt+MSKDHA3x4SzmwimTJr4FuH4OtU9Pv+niuEgLwy7jxUViK4KA4ubNwvVjOVFFT4dCTPmfGPpJ5bHCNdh2h8O56w0cPOKhr9b5UCVODgZQIG2Yop6hiHUgNl4P2ag8zcpJD+heCs9sxiSzlq79S+jRyuJuIy11U7mTFcAlF8W3bD35Uw1SvX3/T9SbYK/LgmWQl/ZiWp/nLcUzWnIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P05FFqDaPP0nupzQTCFlyKR3+x3C+P0hyYZLL7kcOVk=;
 b=e3KR6RalYth6eRarrO0iBGb2Svp4ALWDjB+Ep7JgQQnbg80iTFofsZCn8/45Bm26ZLFP4tn9lBbI771h4voAuTcSv4ZI4LYb3VNSJ9gq6wJOQtryLOJdU87Q9j2bSPLkmfiD1VDIOMFS+Vd7CFttRD8RDDoYFfHvXoWrvPqrckM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8539.namprd10.prod.outlook.com (2603:10b6:208:580::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Mon, 2 Mar
 2026 17:19:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 17:19:19 +0000
Date: Mon, 2 Mar 2026 17:19:15 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Matthew Wilcox <willy@infradead.org>,
        Chris Down <chris@chrisdown.name>,
        Suren Baghdasaryan <surenb@google.com>,
        Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: fix memory corruption on
 huge zero page move
Message-ID: <f11357fa-29ac-436c-a9a9-8406f516ea30@lucifer.local>
References: <20260302170619.867056-1-lorenzo.stoakes@oracle.com>
 <901fec30-c5c2-46c5-b48d-f9a8f5e5c928@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <901fec30-c5c2-46c5-b48d-f9a8f5e5c928@kernel.org>
X-ClientProxiedBy: AS8PR07CA0003.eurprd07.prod.outlook.com
 (2603:10a6:20b:451::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8539:EE_
X-MS-Office365-Filtering-Correlation-Id: ca687d96-9f7d-430a-7006-08de787fd6af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	IjItbg//1yhDQVPEMETc52BTMqq5grVMvhecBrwQ89vKwqzYOdmpfhEHjatDOElGATQj0yKxGRmWLwz/qU6V28mPWJ3oKE8XgH2jZ4eQcN8wE+m4zMi1gtrAusFpbpW84DlhwRgaV/P/lqToDJwFWlIjtRbhSTnOXySdtxNiGBKKwoMB0ALfBwuIJXzOTB+48axnLH9I3uBZJEwdENMUWaqup245t3aTypEJNHm8CKTxZCRRBkRN1GogaZF0ppdte1zoz1OL8HfviskKhQsFpEUdTFdtuYXt8kgCupZd20MBSpekOA/1vn5/fqdnq35bXq4Ahd5bAQvSQqX0VgBxknA+0/XeAb5CorKGup+aCY6T4B2pD+F93OZwRkwzXPhAdFupM3V4Rbv1khfsXxflplnU30uc5M7mdLEQM0/tOo8ATExg3fAHda57mLHyWrEW16Dq6RidI7FLDX2P9RRhG+D239Vm55ng3999IoupxaVjKvnZu6tB95IgRbhaLg6bulxEZtWtts/G039+8UnDVA/T7BLJLIri6OnxsbOXWSI4Pcypr4aJRM7S3MHSb3VKhJMb1iVrprtjPyPhKDL6c1NJ0YmPAY2LZxf7f+FqyncKRNH6FzbyfeV3MFAmR8AXLbTCxWRugfhqNtMbHQh0GeoGWQYrVbFbbGqd3vNKGrrpS2JUR6ceZ2lysRXZ8GfRVhHeyiPj2+K6eZaW9Xw3/bgu8hY6EyiwoUjzE2214N0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AdckxVQFAQHhiGS0S5Vj28Rw3rTFUj9EuMLba3YA9wiUMIlHea3Ld4C4tGGB?=
 =?us-ascii?Q?16OCNKmi4IXfu1oiiUBO1ig/fHYWv7MyrCRFaOXF71oswmaU95j/ii5V6cE4?=
 =?us-ascii?Q?t6wD40H318uhK7B1zK/V3ehEwHmTLkaoFJczesVJR1eTncW72dlTYteujHFy?=
 =?us-ascii?Q?o/1hMaNI5AqBtWu0ZEK7vumtyCpeR1yrKKMJRpLONI+wZqL26itVcP7rQTOV?=
 =?us-ascii?Q?81g4nhLza6m++C2ZMlZZ42v6vBtKFCDilntZNm7J+E1IrwdVP6Eapd0nA3k0?=
 =?us-ascii?Q?rUSOYW62ZvK30xHG1jUSxv9tgJGamcW0/smPh8sxzZhDNTq5n85pIWlLwAVY?=
 =?us-ascii?Q?tTSQ135Rjndr8bQOOMPnjj//+hePfbL/lYChjP4H605e0MiwupPaPC1HrWr1?=
 =?us-ascii?Q?2iXP1oTVrGp22ljZd5nlGqCgpq2HDtbvxJFuetlz/lD323qQ0BqqcN3VcLn5?=
 =?us-ascii?Q?8ByevhT1A67XhBAVl3zavfxUqGjVAKeswOYjNL3pSC5bBrRYPsx/oTogHYXU?=
 =?us-ascii?Q?4dJf965GhOcwqKbtYnZmnon2w76nV6Cz+hjMFRL+r7AW5vP5EupPYizO24T9?=
 =?us-ascii?Q?3RwynQNX7GGZxRJdvHq7cDH3xfxSKflfES2w3QHxUt3VhAg5ivplbeHkrc6f?=
 =?us-ascii?Q?izq+dVocTjlRVVYBM0qC+2zWjOjMX+gduBgASoYv55LV5COn0E8/pDE/cfPD?=
 =?us-ascii?Q?1i53CDpo0Z0GwYZ96nW/BDWRr+cm36yO3Y3/yL302+GhSkrOixQI44QtOODW?=
 =?us-ascii?Q?bOiN+OX1pxtpGnPmbJIJx23msQRYGzkS2X+j6V6HCph8ksHIwGqCDgEGDFyS?=
 =?us-ascii?Q?9XQKLkdfNk0rfdJKT5VEfeaoFYKk1UoyrStggVqkbyh0b540EXqnKXuaLdXD?=
 =?us-ascii?Q?djEfO3619h9etS57+uirtz7IF5AWCE3w4fEmnZglFWXWBeiDLU6p7Y4bFOzC?=
 =?us-ascii?Q?TOL+3/wPdvDCiMHy9U1Lc34xoYF8/vMfAajDNQlVaodZbT+KAaU8xP+ptbXn?=
 =?us-ascii?Q?+/7e8PlU2xMkPjVh1RISEDRLo4HevqLCHYd896nPynEwt4rkmQ98pWm6XziO?=
 =?us-ascii?Q?hYhLuaOs75yn39xz23/QD0I1ANlJdF4rWZwS+HxwMrtoBbrLM/S/9hNtWRje?=
 =?us-ascii?Q?NOebTn9c4ll3G3Igrf9wIhikuJd529IKIlsUWjYIpiENs61GgXZRV3OivSKv?=
 =?us-ascii?Q?rAz2RBYt99FYib8pbgZ4rM/X1ZiuCnf4wRzX23Z60mmfAOfoW7fuHuee+Mly?=
 =?us-ascii?Q?Ulvs61m78cE1RdoXXmdAsMVTxMeLK/ncvDHkXnVkc/mq6KspZRNGqLj875YB?=
 =?us-ascii?Q?fRFpijhww9Rwyn4VP3KFz6UKxpMSt70O6Mr3e8/D+bjDn25jnJY7RF6ua3DC?=
 =?us-ascii?Q?xaL7ox47ISsBgFI5HD2gs5b4KR6CMu88d7jcygXhc1RHGL/xw/XZLFWbC22z?=
 =?us-ascii?Q?yFFvBgSiOhyA4fO35/xlA1QuGhsUVPL086N9Q8uChWzpAWjclQSpYyU+dlb5?=
 =?us-ascii?Q?lNWzsCyVvUExu2MK+CJSxW01mdGaLEWkE+h09Q/VAqBGWCXZ7fR7E1Mp0942?=
 =?us-ascii?Q?IKHx7JNOrAEpXuN7q5ZuiRLpjPzXctmoemRtxIcmUGfVBlvjCy1eahtHOfiQ?=
 =?us-ascii?Q?jKQsCh2nkvKVKhDm1fOXKWxy7WEGXp4LE89MHw6kRYPfM+ZxfcYA6HQNCSbT?=
 =?us-ascii?Q?U+DN7hpUKVGcqSSeGEmc6W45jstQyQIm+GvSHthr7yLS7Y+K6UezB5nQlmXb?=
 =?us-ascii?Q?SOp5vODN9AAblk1mYmmTMYeJivUyZlo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3khbL48ujFknGU7WsXaIGe3wcoEpMRKlguuPbNrE5MDfwSlAdDhX5AC/LTSnkUSHIUkz/7Z5sw2zZlzz1/KQFtLz0O8qXQF6bH/M7o9uVorXqjzqmCNRWsQB3/lDeQCrpbnEYrLe/NDtCWzcZ1/HvpLNMBihX7AAGtQkBxDY8g2QlhC4Xo74EaXdJ9ralF7+F49NQzpGvwD6BiSkFWTL7UI5gronGlR5gbutPaQtUjXLtFkxuJxqywiiAd9B4BJmvebGsaVyt9GWjGLQ2TY5WI+fY94uhxie7nnXBqbtf09hM2/lvIUsyEAJCZRO/io0/7zCa10hQtLyPqLM4W3arjn69U98QblGM+eLXGVQIfi5OgZjXVsGPn2nht90Hc6DYI9w5Q27NURBv8N8gNY+AkdUGFTUtvh4UBFG3N76O4sdi5rMoUg7N4VsYeoRwLvcWRBo4diNjKEuLvg5/8NO+hXcDJeiWrr3oe6XMCcACfyKWlRKFbEcldIcZqfGLsRMTCCAQOc5N0i93xmlL+3vZq/47vOTEfFbJ9z4/nmfm4UZuVbu1jZrCovQN3vVlsxO1+bdAJ8mL4Gz/SkLZ7dRiygbxr7QgJnNqPZwwqFO3tU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca687d96-9f7d-430a-7006-08de787fd6af
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 17:19:19.2900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t69AOmqldsBgBPOXIC5OH+d/XDI1cX4hPngDGBAtb9nipwsLGxKZnxaYQMhLWnaRqSMuU0aJRnq5li9xy6fdg9y4HIz7LYuz2GMCBXRBm/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8539
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_04,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=802 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020141
X-Authority-Analysis: v=2.4 cv=R6kO2NRX c=1 sm=1 tr=0 ts=69a5c69b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=D--XRl2JqjtSGYTABRYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE0MSBTYWx0ZWRfX1+b9qSbTIaT0
 ldJVjmB9I/PUdKwDpw4wWZGljxsmCPvRp6ndfAKQ0SAv3I8nAkATPXyg+wuZLkDFmqXrHg9yrm4
 BHAA3MlMaMQ8kMpK7lZKLA894N/mgbM4StA8ZijqsQcnk1zlOP3ieLm4r89F+x1w3/Ax61oTaKd
 Q9S08VdC+NHHNGJJfzAOnNfySIj6SoZiO3sv7Dkj/qtyUH2NIk7inabUHOJciBlu5Cp3QYZ9aEu
 y1dSDGPU2eG69rXbZBTifFj1Q4g9h30A54H+XYR1IyTQIv7MJKANJufjEG39WVgivz7iHR9cvV4
 b5Y13E/1VImqhbzNB+AEkMYDrAlWHCZLGWP2/TGACAcumXIndUnCSU4M+SFd+Q4+7ZIUrv+zta5
 9+opG5GbSt6IsKTbG2AV5WCv3ux9JFc8hd99rks6TUZyFiHnrvxa8KSS4oppFm+MeYHgs2ywZY+
 x7RzEKSPKRssvX7Dhaw==
X-Proofpoint-GUID: ON0a51pAr98EKSBAUbTx-xYRVFQcaHkW
X-Proofpoint-ORIG-GUID: ON0a51pAr98EKSBAUbTx-xYRVFQcaHkW
X-Stat-Signature: ejjke879wzji64wjz7xxagb38yw38es1
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D53A80012
X-Rspamd-Server: rspam12
X-HE-Tag: 1772471977-943386
X-HE-Meta: U2FsdGVkX19775rTBraqIAuU45c3kj33+vTqjp+p3/kpaLMcLuXGELbQVM49ERmFIwR+to/aCmUJ/9CEjfbyNsfWWOHzarAJ8hJQqlUnO0NDji8P/BsDnw90W3Id98bbPWpZ+7VsxfS70ytvJNvD5jvUxiGFSwRZMpBZBKCzgeqjqjgESaeKuNDbTgFW261kGD/rQ3SQOSQFCE8mq70e/SomfXBdwfd/Wp8H87nqqLIdUWR6QJz51i5oFVrsd+sz9bzy/VABy/f+eyIo99ERN4yEFEtm6bwSS98BXFEts5851JC3GyjmLx2xVemvW7vVP9Lqoc697au6Eu27Sw+gECW62W4Ik2XE/ycmebAIS3Yi7FJZSa7Tm+G/S12gOgwDm2q0aVw8Wp2zBhRHI5VG1hAhrVBXANkXFOpf+MrICXQH6MCsRAwAZ97pNZ9cJUgMG5/omzi/Xdqky5oi/Vc/E0dt7ZzYHVp7OIGVmotFPrAa6Rv76oAneZ+s2oAJ4YDXf/cQAqNs6i/2ksCpz90AAdqP33n6Wc/19v5js3BQCboami9oIrvcol+GRNMb4DW9BJ8ytDNj2P4waxA5SMl5eUx51s+7SeaJHDfOauQO1At5mTisPqL6uowdKQmw7gZjzNwhvf7nvN48A9YO+dJ/XjgYK+1d7ypCEnaW7w0afBXfEIACzC/owcycj94DhvVKaKYiXCHXAfI5gMba0PwQLImeDghjLopzLpP59vCxpZ14lUAqa9D1a+BsZONMZwh8DLYpiEehvqvjx3a3exDjYQgnxGg4kfE2PJuHACJlf/GdgYM+TlTvrR2JwyC+/ayb50NTlRxIxbnHbZb1ZESuj7Tf+63auY0jNpUW9+cMNtnsWe/SGnEkVEBBZh6T8auNgZDjf3UQaTSaibVXnEj7eCHlY+MQLSh6KL2sJlXXXBeAQ8yERVmVFoRzSv05rgpmnvZDhUVkjDIuhItjQRm
 MVR73prO
 mZIefkqpzLDHiivD1MbnbNjkKnasyLoFKsUmdrb4I7+/r3bCXEOAKJo/OU3Oe5bFINM2Ia9UN9v1ELizFXfbXZ0PwBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 06:10:06PM +0100, David Hildenbrand (Arm) wrote:
> There are already patches in flight:
>
> https://lore.kernel.org/r/aaBVaHs8rIkNcwM0@chrisdown.name

Yup, if people would actually cc the right people I'd not have wasted my
afternoon.

Replying there.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

