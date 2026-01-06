Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAED6CEFCEC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7DB6B008A; Tue,  6 Jan 2026 13:35:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F3B6B0092; Tue,  6 Jan 2026 13:35:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C8B6B0093; Tue,  6 Jan 2026 13:35:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE2C56B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:35:05 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2CD2D13BC90
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:35:05 +0000 (UTC)
X-FDA: 84302390970.17.7814852
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id B2E4440002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:35:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dCoJasOG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fh+MWK0b;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767724501; a=rsa-sha256;
	cv=pass;
	b=1BCrrOx0ZtVLomKmoJYbEc6H0M9fJyRrlO+pR7bvuUIaSRXGAecwpiZG+Hvha7zcaDayRQ
	hzIEZbNQBAjJBhaJJA6iy/tETmJUOSmUHEtcZ8PBraaNgETc2xtXJZ1CyJw5dvW8MXSSYS
	UF7T45EDTn8acN2lsSGajDvq7w76juI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dCoJasOG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fh+MWK0b;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767724501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJwFV7lY1k2OZXbExaiAFgtOJJWECc7dC6IYJNeu2Qs=;
	b=rcyiX3++m6JFEpeGKVwaI6H2tJETtVyEtO+hiebqSY+CWOiaFtKdw2DBBlI+3gCrySV5AY
	3ubQSTYfpCFG0LrPWU4g6tUKbSWpjiwDiv/m0PiPqcP/OSkgfPIn/Skk019XT6+sxEHDdh
	xUrdTLouI7KctAgZyxrc5LpadzatGDU=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606HtmGx137689;
	Tue, 6 Jan 2026 18:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=UJwFV7lY1k2OZXbExa
	iAFgtOJJWECc7dC6IYJNeu2Qs=; b=dCoJasOGe6MO8MoDFj0x3rTjHw67LN1d1e
	LpM7KN7fW3bPuCz3sf2xXD7aRP6X8ZXOGLPPm5LFMn4JJAwu6rBiJl8kcUasITpq
	Lv/EGZi+CBmNiIujQ/oE8GF1EMTUsJe38THjw+fNKyYvunLoUoc9rXoFclaBkp/r
	B6Rg8WWpI+hvwmQuOwirDPwWEngeqRopF2dRmm9mSB1BOMaxhGnK/AAefSOI0OWF
	1cCYO1QG+7LLdCNuGhc8Vcrj5TpoHw0cV14dKXY+Ifks6s+kgyOroF87QhqTapzq
	q/KtluJzs/dKYjvKrm7n+0mueaQMa07kMl8036vSKeNBFMqQ8T5Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh77qr2a1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 18:34:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606H7ZdI027436;
	Tue, 6 Jan 2026 18:34:56 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010052.outbound.protection.outlook.com [52.101.193.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8p5uj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 18:34:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gEAH0umGf2Qsk2D4hWhQUe1xx0jou1IZB5EG3Kt1GUOjgsoyGz8bAgGsaySU7Z69DDPRyvEpuaFTDmXa/JnrV2rMe/tmYEzKH0qFApiyy4D06C1/LNwzv5ZrUiFuqi0ZxCjiyLQ3FWfHC8imD9wdFu6Cv5rjWxtlvxIJdr5+nbxxa939bVVP6Yeadg32p3i1cB+/wSZtgj1++i9qSjoImMsUmHF0mSWuMKwyn9KxGJ4IPHhdMRYaSMzbu5diVPxfJCwUOb68c6GeiAIg4LwebNDlyqPZNqTzMkfu45PrXFxfETi5qohWSypBYL20NtuOF1mpp6NLj8FXpbuEAWCP3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJwFV7lY1k2OZXbExaiAFgtOJJWECc7dC6IYJNeu2Qs=;
 b=lvUnBPHCmIvW5wyrzTdKvbY7KggPPSDUgQ31vdK/vKM1uLyi5u3kL0uQhjrDbjWsJ4iyilm1xVlbrZZxj89f+ImaiR31CWc23nax0WppjGZQZhoLsBbHRl++FmzZ9RKXnFjtffrr1ZaZNafSl9MasM/ndsF6fDzU8xgSmrhQwC6KCSxurWzi56h1eFph97qWSsGNoR/E0b+ItmTq/9GMALZAcAE8RiT+1+CvzVGeZQcITQHkY2s6mI81I3g9OPQOejXED04Rzfbaa80pgLhnbpygu/jhbR/sSmulZyN8+5/OwcpWttKxdzav3SYW7pJG9oMd+2H1vsZRhllh8eKNBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJwFV7lY1k2OZXbExaiAFgtOJJWECc7dC6IYJNeu2Qs=;
 b=fh+MWK0bdMxUju4TNXCxLGwCnC17U2P9XKkY+u3NbPuglQzVK1iyih0ZoGD2WyKjIquFcr4XesudZziEAxUkkKJzMRGu0u786siqp0rydT1fqSW73P1aZUT6vps5ixS/ZvsiBvOnrqWxM/YwuEvv4zMyXc8m/qjyT1hKSUbNCss=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB6197.namprd10.prod.outlook.com (2603:10b6:8:c3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Tue, 6 Jan 2026 18:34:53 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 18:34:53 +0000
Date: Tue, 6 Jan 2026 13:34:50 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/8] mm/rmap: skip unfaulted VMAs on anon_vma clone,
 unlink
Message-ID: <lig6eozf2jtpyzccgl2rbsq2sinafipogezxhbyyqorelgxbae@ruu2blv4wvi5>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>, 
	Chris Li <chriscli@google.com>, Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <f0855a0b4e68d877baa222a636a8a14c4e820bf0.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0855a0b4e68d877baa222a636a8a14c4e820bf0.1767711638.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0209.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB6197:EE_
X-MS-Office365-Filtering-Correlation-Id: 201f8c78-59b7-442f-d222-08de4d524887
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h2O7uwfegZJuerLkxAcx6GNu5IY/VNW9ZqjMccmW3ZLiLQJuhgw5yMx3jmo9?=
 =?us-ascii?Q?bXFXu4uG6G/9o0EZNg55pfH0HJ1z16zv0Y0PkVHllDwxa47Ll28Jk6MOIfhA?=
 =?us-ascii?Q?YapGR/JJMDFp8vT/patsX10EXcvyR4FBcrmFoCDsl4lJ/dPSZ1fAsNBA2Dvm?=
 =?us-ascii?Q?wqAOAjt24+wrCAmp1O5EvyApgnpSuV/LPk6IbDh+/8UjvibMunCs1CRkxIQS?=
 =?us-ascii?Q?XzJhUKnzBBOW6nXDFKPKREGrUmmLw3FYOTPnBH7Stun4mIS0H+oeoZ0tYKpf?=
 =?us-ascii?Q?2xESJlqebIHRHzAxn8ZWwDjbrF9GBoK8lyv6KcDqJcVlNO+VdqffShew1CAJ?=
 =?us-ascii?Q?eigxnS1VQ+sI0unba7iJE0GC3e1P1hWEqWzLu4NU6woPGueTD4L/kHzbhNz7?=
 =?us-ascii?Q?d4jQ8ZaRl4JPu4hCq8SK/VVBlZpxL8ce5wYDVxBigG4XE3w1Dkv7ap5Hvqxh?=
 =?us-ascii?Q?Lb3hUuYroEZ7U4EjT1GAWt30xa7MmnlH9USGDIa2WJG4nv0ZzCRlpaKWf1fD?=
 =?us-ascii?Q?0twUpyzHVU0KIT9tC+o0p+ip7xfUzkuZ9IqzjFIMu16y1W+d2IqEbrV5qJp3?=
 =?us-ascii?Q?pGoMp53ug+sCH4HMsc5TcQYp3eMa+iqZjd/y4x1uLa+rMEqFF+CN2JT3a0Q0?=
 =?us-ascii?Q?SFVuL4fUz8Bk2CWeYY65c7bDAydUm/lTCx+UlyGeBke1OzLUNTEh+CsJNpLF?=
 =?us-ascii?Q?caSILlP+N0dFQCYel0CArurdLN5Tk0MHPMSupIl6BvPVd8VonOJvRKfOW5kx?=
 =?us-ascii?Q?ED2Il+GYcsaxr/YcuLSvw/nxvA743s7HDMrIKOzL8FIDr9qa589JuSIyDDnL?=
 =?us-ascii?Q?ejGWS3r28hSXkkyyiSKDCfiyHa9XTaKCgLXLw3xY38EffcFSGTptjIrP1tA0?=
 =?us-ascii?Q?YdY+zVdgp4z6IqZR5n4Iu0PWdXBwT16RENf2EXQKohcIwIie9bg3iGZvdRn1?=
 =?us-ascii?Q?2vYa3LxyRMr0gOqVMvI3UVq6QcFwlP6HX0KHk4EBkt81RtbgBQGk5OhZvcfj?=
 =?us-ascii?Q?K9pWwV3FYvf7QmbQ1YBd0PJNW+m3kOfFSKDkQUodkmj4JftkjRGjNVlZCMq6?=
 =?us-ascii?Q?GHJfa6SutM2yh0h0f0iIjJlBrZGSQ1tXY4ob+fyDQ+5GmFFgYiYleP6ihUpR?=
 =?us-ascii?Q?qKqpRpPBrLDKlnuNQnfbc9hXyoQZjuye6gd/Xf6CGesYbwbJ4czKTxHKY96l?=
 =?us-ascii?Q?XtBRhTLgQZmEzK4z/+AK7n1nqau4z7Ih1Onkhrux5w2YnJiSI7sE1eWDMUwb?=
 =?us-ascii?Q?Zx0kCjnFuyw/4b2nxToI19CYtbs6SXKKs2UE5rQyFwDdBZpFImw92yETBEZz?=
 =?us-ascii?Q?XrnFTS7EPNPLOoM2XYr0XRT9StjsenNntvx9OWr38U1rJh9vLAsh4LjmuvbN?=
 =?us-ascii?Q?Fy6xKmMwICc19rOezb/9ScYR5VW5OAN2Ytqn6ZAr20/dYRmIxqgna/S5zWik?=
 =?us-ascii?Q?PUvbOK0HrQKn0c8Pe/vegajhNBZmDpJM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vgoz0A2VwU1SzZm8U7kxzHygi8GYlrIgROIgSefajerNYQdL+I/sLp8DPOey?=
 =?us-ascii?Q?LjbMYpbu2cWPSXTTkvsL70cQl6G9Jjvbw44oUF7e1TfYaAxrtztWaB6PMo7B?=
 =?us-ascii?Q?8v4yZSPaRkiU4jA5o9JsBoLfwBAW1O/mnsFZDVxj5ERk1tqWQvUqXpvLFel6?=
 =?us-ascii?Q?cIZ8xWiVg6MYJKW/Cdd5KAlg9dhCJZML0ZS7FfjxjIKol6HPzZRc59ZxT77s?=
 =?us-ascii?Q?1CgNP4xf/Th9tpuqZaKKrDUHv9J+lRs/zzqGd1uVukN8YUbW7dcEfWanCJdk?=
 =?us-ascii?Q?oi93FoGqE15FSgfGjBvyQDDxh5pZktN10aIV4t1ObWeVq7jBjs76tPdZMjYR?=
 =?us-ascii?Q?jm0B0BIlgVdVJG24FzRgQG9DLfYwRxALUfHPACxewdEWEszjI9E1FGJzEWi4?=
 =?us-ascii?Q?d1Zh+ybfd+jdq2a3USX5wdmFx4b5OsroFfBXqqGoiqWPPgfqtAKIRfPT9Qny?=
 =?us-ascii?Q?OUo6YN0DyLrlKF7tUs6MndHXXj0bng/chLQSZjWexyDF9dHWZLQNZlH+aDQx?=
 =?us-ascii?Q?ZqFQa0xPj5Yr/AzW6boy+rqH22aI+IMgR+stMgTrNKf33jvdVm+3McouD4hg?=
 =?us-ascii?Q?iu4yMNvpJrITcF8Z8ooBkcAYOuQ2eeEaSNOIqN6KOWI6ErVRJwmQfCMhGI85?=
 =?us-ascii?Q?WLq/94e64xnIN1GKEwxYurVwP+ZAFbyJ9N/6i6QnIi7EGA4KYAGua0Hb2myh?=
 =?us-ascii?Q?CuaGFj6OeUUvXVIHIULPR20e4C75NmBb41URVYrvX42iTIsBgEgQhFSxT7kT?=
 =?us-ascii?Q?QXvbS2naMZ60CMxnGV0aaAuJdCZpVmBPZOH4Ka9LU7fEU4/ymN+xTthGnFMO?=
 =?us-ascii?Q?S0KoXN9ES3sqdIghy56SrWNYIFpTP8bkgXdBTX+CwEa7qDUtpOfviX9mcyW5?=
 =?us-ascii?Q?4n0ei0gOZE00yS6HGgcuBmbS/TBBx/KVCXvC3oYqzDpQ+ZVFcgNKRu1NRUoS?=
 =?us-ascii?Q?XUretDPmuMwK6HmIhIhtrcpqYtTew/SPuqYeT63tSsP2LEi5rS5GJfDTh9mk?=
 =?us-ascii?Q?VTbS4ISYegcNiUNGzTb3okwudcTFCUM03sv4brKmxi6i8w95rAprwnO7hPGZ?=
 =?us-ascii?Q?ghU7GTMral/p76SuvydXfhewIwQvDCOBASoBGFCWA7fNQpXp6zkaRGXRLdEo?=
 =?us-ascii?Q?zIpFikOfu7qOlLgH4RmQla2CyV4dcRXu4VlQTwNE7pom5irlWWfnO1YF5Tp7?=
 =?us-ascii?Q?gk+bOe/hSm3PdFhd6DDERTLxS0YMg0m/nRaLUclDh56hkcLUdJlDa0R2mQ7h?=
 =?us-ascii?Q?md3S2j6r3iecd12Jks45iJEjpyFVGADgjv61DdIMA+3MaMdMFjt5rqIfNnu2?=
 =?us-ascii?Q?Z1cHdc/lryDA10uS3PH/Gztc1N1afQi6F2mMyYadU9nZqxn4hweMugIc2Wzl?=
 =?us-ascii?Q?CBamNCGiPtAHplwPmPsU9aw4IDusNUseOukz3pNkysl+cZ69AjeqI63P1SrD?=
 =?us-ascii?Q?b5V9yAcR5Uhoaovv1rFyJKCz/XgIjF/eh/EAIESZOvEIh3z0EHZMJ0ZHCATv?=
 =?us-ascii?Q?umUpoAUQ1oTScEIWQTePpG+D4tLNOU4CoTLDp+XIlOzaHTGWcnP6A7hTnn2L?=
 =?us-ascii?Q?0MYXuaIR+KJqC0ltKLPRMNFAz7lXRcadQY71SxAMrsCq/FRPGQji4EoOFlKZ?=
 =?us-ascii?Q?sLQHEtBFePZsStIbZAFD3seC3IQGAZS6byG2qhDn6V99qmAO24619GRmF15h?=
 =?us-ascii?Q?Ssi+4HDF7QzSpPbYWV/JcF8RBTk0iFAYh4hdQmfbmwTira5HoG2aOhGhtgob?=
 =?us-ascii?Q?a+mCeJwieA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fSST56DYX9r8gWst8kFskrVyK3jWwe6KchXGFHbZxyQrYukdH1jTWUMIaFZJHr+LnaGIiMeYIKP0nZFOLzvp68D9U7/BJbWMT6f94g8aFS8MvLq4FoHNkaheYj+cqmTj1NheNenzPSyR+M2VzzfPB5IEP++6OkGc2is7DKoAbjNPG3Up/bYSSJ/tEV/49lwnjVYxJo7SBQKT35jwJYYTKtervByYjtUkFpCncGE8K3b/km/L1O+Ra6pPRnVHyPVxyOvpqVaEcDlA/Xt9+DU3I+hdQjmmb0xKXIEVtGxcGRMrTKBsam2HWavNXZrkds4QfoGsoJnNl0ti+vln1TsuiFflHiOBpdEk840yIj/zA164hnVoqwm/0WKGxIcM96qPGGQyS/Uv/wj4CNQrY0Onwv3896crqu8UmsYG2GVAD+bTSik8Xz7adxSFDQ8bH+KzqXMfkpPsL5sPfHujq4H/7NTMtghv+7dpteVm0tfogUXJ4vbm41jThN9CLSxPqVAg4iR/IFL9CUvGlazPx5bZGl6odLNLLVN3hI/gbfPkttFlxuLpUwMVuDo+6aaqm4EMVrJ56DZDu2UzbzxmEaLvXi49mhuUc3tEqzpLNugkUpQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 201f8c78-59b7-442f-d222-08de4d524887
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 18:34:53.4586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZsATHoA6uis2K9naObBxSBTrjH6aymm/xAOA6N4U9il84kQA0WweK1+d4CJK6dVl2TQmWQBtnQUaIG/Hti5JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6197
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=854 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060161
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE2MSBTYWx0ZWRfXwAtwAvnD5mYb
 4t67EXZFoTm7hb7Ydve1n5JSDoPfAsu59sVUcYymvSqOrO09bZif+cRY8cLpOpmZvy+SYwROb1f
 df2ov/7BXWw7B6OHguli8n1qrOI7tlyJS7FO4DgcV802MeEV2zR/lRTuaHwuP7NhckN7eq1c3gB
 JNx3r1HMhQ/5gLh6NLEUUuPsLTMDGAle7HkIafL9iotJL0sPQhb7rpsLwlmUF1dbpu8Rc4+MFDs
 P8aALdriRornwaUfmBY6ShOiz9AJoBSc5I57y4KSACR1itlWJhb6OOYwZsleEcftyfpYaI3alUG
 uvRBJG/gQtKixwDgKoK8k2xeZjEY395rLMlYA/nYvEGSqiDhG7pV5xJ9uSUyeB0+TDeEFs0FfIZ
 RkwfdhsLfTfhuks3g7HY/9vCwow91kQnIgyUXq4qL6UiyEzr9pXKUl42VWrNWMb/8bMpFvjCHQ8
 xGMVPSYQnMfHlZhVpDg==
X-Proofpoint-ORIG-GUID: wNt6w7TQfLDTVGITCQMbjCdVGVp3ptDB
X-Authority-Analysis: v=2.4 cv=Zorg6t7G c=1 sm=1 tr=0 ts=695d55d1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=WyJ-SGHNJPiRoI9MkSkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: wNt6w7TQfLDTVGITCQMbjCdVGVp3ptDB
X-Rspam-User: 
X-Rspamd-Queue-Id: B2E4440002
X-Rspamd-Server: rspam10
X-Stat-Signature: rmi6tjuee9s3eu37e9egpjngwppqjodj
X-HE-Tag: 1767724501-291062
X-HE-Meta: U2FsdGVkX1+7NIDtQstPShUi9IsdHVUwbTpD9iAKpzMnU00vrZAmgokXFKoaG+dkyNk3pRWCxDETeTKhc0Mr50DiTSFxuR9aQ2KQN7haPoLBHohI2Ipa+qOX1FrjT1cEY2lkoo3n2NCorvEFseMhKEPDkmxsrDeialgbD+YcoEcG18EO9LedBUNMGQDgOtGUwTBd6mlyO5V+zt+S/mEtrr0Te1nRxIal+nRIM76Y/6qfA3et1633uWH+LbiV87R3debXSq9uciI0xA7L2CbIoRLE709EJ9BJtazOSVPVe+V8gIjRhAvvrLY6/ZSm87wDcI6QktOxDeRE3zrQCauoACEIRGmOcRvIkUJ8K3cgEl3oqfF27hg4y54QVcnwNX5GxSpXn2xpik5hZ/A7puI6NbyBNBZC7ZcqIc6n93k/t0OvJcqoAgr7ktl2Mkrxa7yk57B2VqRZA7o068oh4ooJOHplLrrmENTxHeNXjNp/1SbeQWX1o2RuqcfS1llFhRV3hZwAtXZQ9mUNYLAJVxc2PVDVnl7RnmkpnJxHjCoPPalqTU9khWRvpKM326C0/5FLZwDjv9e18K5ER4dwizx/j+YMGl2qqpyZTkC6f5yISNf0ZnBsud8k+cOdsH67/FJ8aDqEEaddruK+E9sS73UzfbhYk5GzzVENpAHKjwNq87v4pUhBJyHo8h3vkvMw9hWXUCVKr6pttC2XgJIAN7jRr689K2yMm7uxCgf8HxeKXGTrt8UVUsSoBdczy2GpdriwMsg4vQYYUaWzRMM52tpNkbCBK7sCZUzbCKI3YE0xlI26pMIXC5rOckdbR4IIGUvjMKdnuBT58eFwOoqfDNTQQ+Qv4ezf3GHGjKYPB5FsxMZvBSItmCt9A6ClgQ41niCuCna3L5h/Y8RzRfQN/YUdV8ipZJBSc1DTuhO/V1quk+Xy6Rvwm/Ked2Nfl8sRfWq/jp3s3gGqu0HuCcCHm74
 VYGXLHOJ
 q40D0oqeqcS7vVOiE7lYNiwVNPHYL81235F0L6pIgvfOmQUfVIeXO/9nDOf8/kV38IvFhr5VhD5Szt1iRrJMjOo3W9wfvg8HLXIuhbx/c9Dndx1T7NGQ+maSCmNys8FY39nqaQZZ6TzAAkS0u/6v8C5EaqdRYN9PHJU4+aFGVBF7/cZk5SSJzgcJhRlBAxM47a6Bwplq77yWTR0amI6FIpa6JlwOeyr7ZJhPtDkRH8C0IxatB/tAImkT5BgtDTF3X+lMi9mzz4wUoy0BU5ilB97PN/P/HaWxif62wijgOfzZUGch1J9dAvYgB864NvtCpavoofin9dGepSkVRxiEp35xbQoy12AERwe2CsAv8pTlIrPYe/2jn5lu9C7sgbEgDczXg71nBO2v6RAB3sYR8u8AMX53gKdiciJhPNUV2gE47ZMXWdAGN3o8HzcBOqyb/5uB7+93hipeU76r60+lQeh+gZtXXFSymDu1prbyrcY9DiXBWaepmyy9wHStvgvBZ1sNKppyNLR7oMzWpbaNaPHvgd7ozX31lj3VA2Rq9XAzvt15mW0TpUw83jg7+I+Zh7nqJQFIWA15eW8dB+QSuCtntuxaGqjeLuQM65/GE0n8e7k97S+sim+u0fV4IYH8uMsik6btVNmrCSdWwC2EF+cHWJwspRf7fg5ADGvjBobiQOuYCivnTBCN261AlkHFRBeIQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260106 10:04]:
> For both anon_vma_clone() and unlink_anon_vmas(), if the source VMA or the
> VMA to be linked are unfaulted (e.g. !vma->anon_vma), then the functions do
> nothing. Simply exit early in these cases.
> 
> In the unlink_anon_vmas() case we can also remove a conditional that checks
> whether vma->anon_vma is set.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/rmap.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 54ccf884d90a..de2cbe860566 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -314,6 +314,9 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
>  
>  	check_anon_vma_clone(dst, src);
>  
> +	if (!src->anon_vma)
> +		return 0;
> +
>  	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
>  		struct anon_vma *anon_vma;
>  
> @@ -474,7 +477,10 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>  	mmap_assert_locked(vma->vm_mm);
>  
>  	/* Unfaulted is a no-op. */
> -	VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
> +	if (!vma->anon_vma) {
> +		VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
> +		return;
> +	}
>  
>  	/*
>  	 * Unlink each anon_vma chained to the VMA.  This list is ordered
> @@ -498,15 +504,13 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>  		list_del(&avc->same_vma);
>  		anon_vma_chain_free(avc);
>  	}
> -	if (vma->anon_vma) {
> -		vma->anon_vma->num_active_vmas--;
>  
> -		/*
> -		 * vma would still be needed after unlink, and anon_vma will be prepared
> -		 * when handle fault.
> -		 */
> -		vma->anon_vma = NULL;
> -	}
> +	vma->anon_vma->num_active_vmas--;
> +	/*
> +	 * vma would still be needed after unlink, and anon_vma will be prepared
> +	 * when handle fault.
> +	 */
> +	vma->anon_vma = NULL;
>  	unlock_anon_vma_root(root);
>  
>  	/*
> -- 
> 2.52.0
> 

