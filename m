Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4588D1D47B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 15:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25D206B0092; Thu,  8 Jan 2026 10:25:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1366B0093; Thu,  8 Jan 2026 10:25:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064A86B0095; Thu,  8 Jan 2026 10:25:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E84406B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:25:56 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FD57B6A78
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:25:56 +0000 (UTC)
X-FDA: 84309171912.12.C74F27C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5237340017
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:25:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="ElevO/HX";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BMU1EeBE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767885953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4C5f5548Fsh5nWwi4auNcDwLJsWmDQIbA4T0gvdsKNI=;
	b=GR2sewggPnJmWsVVfmdS1KD0pu1ubjRc7bdKLF09IrbbyQYoyDjKsTVOT6hggFNmTLcVjd
	20kE1VqtJMhltVW/0NGnoh7MhjZve0nqONmmqYZRAnQIoP6rConLBdpMHu/EybZik00gle
	vDR//rc+WECASiOq2RZ+5FCGldMU6WQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767885953; a=rsa-sha256;
	cv=pass;
	b=1o8Dmn6H6OQKDm5Pdt/4neHrYX1HyOrDBSK2j68TtCw59UKWVBnCvoclo1xSAzlXfymugB
	zd/2r2+i/aXJT+r3c5Dxxp6Qz3nhDwMJQd8ZYxjhQ4zfkL2GttneBYagjaow0oYR+NCOZf
	0YeUA3NCjVfuBx16JcHz5BqiyWua22Y=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="ElevO/HX";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BMU1EeBE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608EnsOo540425;
	Thu, 8 Jan 2026 15:25:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4C5f5548Fsh5nWwi4a
	uNcDwLJsWmDQIbA4T0gvdsKNI=; b=ElevO/HXBnJnwUJiDLlLFQL5BgL395qNSG
	BNJv4U+YGTcD+YXPDshbYIcKsE8cYo5YFu+GSCE3DpbEWoK1MIOJnn21F87vd5fR
	vrirAhKepgFQiQi//Udl29B1ZDc9O70qVdjreBSgXaf4Cb/mbUSCLnUKKqDUQNm4
	VzVVH7XI3F5CK18X6GybZNEK1PM5VIt1riP04UPLBc9pj9Ul63pmAUfpP6MY4ayf
	FplDseqtVc0Gnfgfv24lHD9OAWJWTEUVw6q6QXxNk1sVxG4O0rf3Y2QQjOhaPISc
	rMQEbTR426B8pFWsqu01RBAqWDfWRjqC2G5ktOxAj/wXlt1VpX5w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjephg1wu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 15:25:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608Egd3c020452;
	Thu, 8 Jan 2026 15:25:41 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010067.outbound.protection.outlook.com [52.101.85.67])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjn7rgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 15:25:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kwuql2viSTRWdnAYi/3VYDNfSrNj0WGiD3epwb2XQp7DsJ6p3EHPKZLP2l1fA0Cd5REsvWyGG5ZhW87B1YnINhQokoVVvi7iwhhIUm3RUNnfv4zUy8DZLsGNUrgvLoji/MyLzZMZIQhiEfuw81T/Ms772ByLtb+8Y5ceZdtjGlCQp6BVO/kVo6aSzmsohfIQExPqZ8Y+VugoOGnC/eAWNuyOGTHI05ixOkRteLypdaG5cSs8yjz5/TQR0SUwlr6Y+th6hb7w/uo/rVldK4NBYeUPgVNUt/wg7AK0MptzOZmyqy0Br/dRZdPH83RDrNVJiFmabVfYbCtiImHkunIn0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4C5f5548Fsh5nWwi4auNcDwLJsWmDQIbA4T0gvdsKNI=;
 b=W0/GdoVK28XmYOo+xtnfiUqbkxHUjup4dxUk6pw+yK6a+vgGqHHUdPOMabx4O5KpkfGeG0v/WJWXq7HwUDJi5LrA8PPgkTd8EfaoVD/6FL3AQSFo2YjHy7qbPYUIslForV94f464H/F7VcuZCwf0Lg+BTdbS30PiHD5lyzIOIF6HoTEx4a/dPc/zi9t6dC/HFlNDDSDJ8jCjjmiFhSUMkV97qALn/YLrQ+3j42Ot/vpm4d8W8FLbykDyfhaztOG9EA2+FRBmlNH25IVYRKlpWz6SPfmfUSDgt8144rnGrJXBT8prQkouedVtD+lg1svqNYGjRb4DhAtBBQ9DyUlfYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4C5f5548Fsh5nWwi4auNcDwLJsWmDQIbA4T0gvdsKNI=;
 b=BMU1EeBE9rHlyxnRlQV9G4hEkjbw1U1QvTiCf3fDfULYjvQ8/jd/O6P5mCiHR08l95Z8ec+ULpzfqYzy2hL+PDFiVRZ7SEime2uVwluNtMaARrZkvqsPT+vaO5HO3PA4dvyXI23aJC4Crs5RxF38M2jc+MqK8NXR0m+qkYHbBCA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB6440.namprd10.prod.outlook.com (2603:10b6:303:218::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 8 Jan
 2026 15:25:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 15:25:33 +0000
Date: Thu, 8 Jan 2026 15:25:36 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pedro Falcato <pfalcato@suse.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mm_take_all_locks: change -EINTR to -ERESTARTSYS
Message-ID: <d76d80a8-64a0-43f8-ae68-8b6461a349b5@lucifer.local>
References: <20260107203113.690118053@debian4.vm>
 <20260107203224.969740802@debian4.vm>
 <aV7IO8-trMSI1twA@casper.infradead.org>
 <d3d77df6-931a-b97c-d551-a69ee5ca9493@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3d77df6-931a-b97c-d551-a69ee5ca9493@redhat.com>
X-ClientProxiedBy: LO4P123CA0554.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f97178-be49-41d2-f7e3-08de4eca2a81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DTL0Fad+UGgk1HUlr8YkNyF7gitemWw2Jq0IrZZIH6ro35jn/8dwTBv/8hOj?=
 =?us-ascii?Q?HpFsHTb+DHZeuPPotHaj1A4Urs0YGuvAswv0jnaR9iPLz5CA84DZnP8PZmB7?=
 =?us-ascii?Q?YFuiKNC3E4jef8FiuYyRP4adC5Z6veDhhUWJFRNAzKMmE2vJBgTs8qg3GTXL?=
 =?us-ascii?Q?A8qaAlFsLIXlCx4dPDNPJSu9laFiXAzULnOqPZChjguk9bv+YuBXN4tYHmuI?=
 =?us-ascii?Q?87JKYgZopqi4IO1F80dd0/ffitMvs1S8+/pyVBStFygjIaa5uAiGt4jtY6kv?=
 =?us-ascii?Q?sCvbd6y1pIysXyuxSuthbpZWbITNLgUD0hmcHpKzN+QKNp8O0Hjl+B27LjLu?=
 =?us-ascii?Q?l0xmMzg8xPG8prghkVOiCuL0xS3koOimQ/3bZFEgyHugbqVigkST6MC+avbj?=
 =?us-ascii?Q?X4VhgIPdq3hWKz7zQUqq4IXCrio7UzkeZwQ280Jj+nWObeNXrGw8b/yX9Xxa?=
 =?us-ascii?Q?MY/v4npU7pwasbwifPqMkekxE01zd6agcNjRcgvDuFVTKSLUsO/FUO10EKM7?=
 =?us-ascii?Q?gs2qAiOND/4LuPsskSrUoFq9A0eond8ZX7yhj2TnaSeNzf0JsGJESoqqu42S?=
 =?us-ascii?Q?hQe9EpKFoEsGC+6GJVideOpjWIt0AjDU8sD7+08JfK3HrPbxU/nInlDktf/q?=
 =?us-ascii?Q?2xJ8bPUtw2oATctHRIz223gMIwHgztnKxBLw6fUvn34JBFJPz0exXhhIABR+?=
 =?us-ascii?Q?XOqxhMiTMEgFb5z3DnkhmpPuP7164tjQIRUGg9+a4hfJodgsDgJmyqs1CBDI?=
 =?us-ascii?Q?U6YarckZB7/y4Pp9hRf2mpwoRclhSt3MfcsNcvjzgRVp3sMHGWCOZPEhGxek?=
 =?us-ascii?Q?9zAZ0QsWdFc9/BH7p7EMOX8Sxp39L5GH2orVyWLkGX8AbD9TIPTLVgyCwZKK?=
 =?us-ascii?Q?q1PVPZHQWhsn4mLQ6/eyfZRJbgwWee0wUWIPkJeuKjJs6+lQeq6ho5doURy/?=
 =?us-ascii?Q?a7b+8dj7rOB47k07GdytQOOfLWKk1ycetXkSymSuqMx1ypZdqbij3H7Tityz?=
 =?us-ascii?Q?KxUX6QAO9Hne8B85BKw3NnhGjcnmr958sQHGX2RD0EFcNHivU23toXCTp9Qf?=
 =?us-ascii?Q?q7ZYnCmZO/Wo3u2F3LWqLjC1Lwvnr7FtBZRA6K9MvlKFtAUDl05/di2R+Cfv?=
 =?us-ascii?Q?MedD1tcFoEWUVo9vX9L+N1F0YRB4IfQ47HYDqNQSv9mThxPMZ68QdSQx6Qm+?=
 =?us-ascii?Q?QuvES0pydxEroyVSJEq6vy3yrzAhOYYpUAzgLUVw1o68JcgmNnG9rPZscgTK?=
 =?us-ascii?Q?g6Z7s3/1cqK4uzaeVV0z0/tQ3gxn3/BiMXTg23+zOpiRtfezy93oi3sExO9K?=
 =?us-ascii?Q?CDjQ1GF+Nae6iqvBBm7KjnKido+cbuJZBizlDFajiychW7ySbmqIlR2421ce?=
 =?us-ascii?Q?hPuVVbiC8LaDFaOnSRbH3tBAF/sV57TwD4FErA46lToJQavDCNyMGcx+TsM4?=
 =?us-ascii?Q?8+v7MfDEvm8u39Yn3eyOuSnFSNqn9p77?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8pIXKkhsipNiz8Tz1nISFpz1if3zg+prYTV0IN8Fnn6Dch9ffKfYyJcAl7mk?=
 =?us-ascii?Q?SGF5nIqJdxtOvJtc+y1gMd46khrqOSh1+/hMYHZ3qlaskNELmb8vKZHau86U?=
 =?us-ascii?Q?Zez3Dr0Ossw1mFkxq6a8whjkjYbQYoNuqQEOwJDz+7yM0+MAWlbp5N6ooO+I?=
 =?us-ascii?Q?ozMqCvzBoT3KXzb5zJu6VijgSOMmyYq3lBXnu3kR7vmVDS736OV7NSrqEDjA?=
 =?us-ascii?Q?mW/SOw5v1zbZfnPTTkJNXiS099OvTlCiXmObdPhh+fy1xxY2rG4tA7L+UJ+H?=
 =?us-ascii?Q?JO2XQV587kHULi/M4OyZNaQKkBAVBZrZzcojXPbTRbBo6AjzaJ0j4RjoteSw?=
 =?us-ascii?Q?tzlUG0bvrIGmP0fS+H5iEvOwokymRC4AhyRPFV8VwTLxatuhCs2hVHhfOWUI?=
 =?us-ascii?Q?n0w7q1qFpxlid7qRjdbuRkOPFBZjDnD/xcalvM1yy3tiXOCCEOKcEjAWUrnf?=
 =?us-ascii?Q?T/+CS/sxaQg7mSakobO/EByKTZGAhcG64VOtD9B4rN9awl4NZ+9/67zVA08A?=
 =?us-ascii?Q?HAIWfgoUvVjRZeRzX93o2O7DCYXoKWSZkm/v9lvrcq/A4Oz4xlp9NZLY0GFS?=
 =?us-ascii?Q?ow9t1sLwlzTccIC/2WlT5nYnCEvCJIpRRPizZF/OB2OK9Z4zUFsZ14DK86cO?=
 =?us-ascii?Q?ovrNDDJD0TGTum4A09wO6BlPcKdehWL5DKCJEBYQWzDhN9s5/HYuxu/W3nBh?=
 =?us-ascii?Q?ALTDwQ8R0XgK+cjBzRvx88aW0c3zZJM9knpSueyYFsGMb5bxAZDMm+lopjEY?=
 =?us-ascii?Q?VJowO9Jq1BC5xoo81D717aQSu01WKXWjpkhrvS9b376LtwW8cUVyJovVUEVo?=
 =?us-ascii?Q?FDI3axRZFbYez+smJOhpdLXLPLsAaX54Yl9SfjaGygRjIX20rF44g1FCxuNh?=
 =?us-ascii?Q?4l7yNlrWEeqd6dIZB9LXM5fY0C03pZVrAsYu2a8cG95LrgFSIFXelEioBatn?=
 =?us-ascii?Q?MM7o41e8NlB8RhD7gHrfrkoG4kQbUYp2X0b6AHh1+H3vGar275bpj2piEWcF?=
 =?us-ascii?Q?2d/XM6mgVGP/ZOHV619mNhnWGIrKYRlJNPo62niDyCJGmQ62xrGpE/1MjL6U?=
 =?us-ascii?Q?cRCA2JztdcXIsvN6ZWq1USmizRXUM1vPz59MNKQy3PjiRPlgkQpvfsv1HJO2?=
 =?us-ascii?Q?Ur09Tb7E2FTtqLsaMekcpBA9WihHBLamlMl8WAHP4wgpPUtH1bj+GWEu3St+?=
 =?us-ascii?Q?snqp4vzludc4R/K+REkIZbCTNH24NwpWRyUzW8+oviFqf57Wxmod5WthgUv0?=
 =?us-ascii?Q?4XkAOjzpMWHLjAbJfb1gLIVJlgr9z7WSS8fdsuZ3As36/CiEZDgAg4EXr0vg?=
 =?us-ascii?Q?ZoVbxxDk0ym46jPSHgmzSEG8EX6S/W4d75INKR6fb1Gbs+BtW3OqbtvQb0cI?=
 =?us-ascii?Q?2QdgYkM2E2bxGPMhZIHI31Wve1995vrK3691z1aviJbMKYPivCzUU5ucT+Pj?=
 =?us-ascii?Q?TCTRMaK0z3/lsqH+op6g4PcOT6dfbUpIIVWt3ceT1E0SlchZWPjn+KWzID57?=
 =?us-ascii?Q?L0QavWRHhofNgz3lhPB3Yr+sAzFngVwgqxc087yjR30wUdq/zx69fCwzmx7W?=
 =?us-ascii?Q?r/upG/FPd5Wmz6JrZMXwWQBbJ1pT148fxlFZkvNzIaq5ZmbVMAKtQLOh+UK8?=
 =?us-ascii?Q?5fgBN1rD6WX+AZMcCVw7iBRE5TvOMD3R1vLcBbTxM4bxJQI4kouWkYHSpoRp?=
 =?us-ascii?Q?N7J0QRQiNS8JSOnoV/1TrQHsdRZMlz5rEpaxs8SYOjtcqja3OBj6yS+6v11F?=
 =?us-ascii?Q?6XXYWeUcN0xzR7SglWNfahJMu9b8QZU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LJ0/0PbVQ05EzNHlr3cgXkt1niOZsmh7JhIT8g3RHFSBoD3fPWtjwwFYr3FTYSgxTUtstjHk9Gz5RsKa2UaTcBLZNjq8vIofDfZX1MWq/pcWZ6Ik54v7htLCqI3Voz/KImjr7sjMT1zpuifIoPryUkmM+Ny1zrwPTCOjuthc4efrLRKlAJIj6SKNkDr7pYTO/shSvKBLvM8Bj0a8OXoAniVzwd/sYpHJpMGi49YHDqFJ8R1IGQAIxkNWZiIbtQbWr8kdkpaqKYBJ68w5LYhCnyECoePrf3lxn0I9xgPFJTYZurGys8j/4ZbBzi7q4YlLuYDRXlr1Y2RQ8cCv4tZrvYQKHbgDlA4tdZ0rK35LnwkD6hFqmbZk5HFQoD8GwzCWb6TRAPQerw3PDCt3eL82RVKw0vcI5jeIJmSOw6SKfrMPZS6U+BZRC/G4SYE6Q9JZzrQbtHaG2R0qslMyQAW8zsxXsHJzmKo0ts5snjMQa6UgjGiYLWdxTcgHaaX0J5Wf9VAF+jvDsrL2aA8ORgUIsTBSHGditIh2dI6fusBP38/cjCITz4yd1tHuchuTLqCfBgazKhCAI2EbngEnriDxZfDE6PbDJ3CKr/K86fogNoQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f97178-be49-41d2-f7e3-08de4eca2a81
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 15:25:33.7793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgTqiYYau+pZ+oBCEx8zpfSXqcWjirI5ykBnHL5+w0LwQTBQcpuDrlt1U0LLak+xDnrkwpqLldAGxdqmBBByec/Q11YDoS9eXQ8VertNces=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6440
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=904 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601080112
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDExMiBTYWx0ZWRfXw6JGSKavaqsl
 sg9IIVhdhFxD63FE+rgB44AF/8wPMxZ/DZaxu3VqJhQXgiv08Gew8GTuETityJzkC+WoLnj6LB0
 ljzU50gB2GruEHkLr9/mznGZCx/eIa8D/Whl1GhT2Rv0ANk4Fcwp05VidpQib6I2yJItBA4gWut
 1FMMS2ESTSeTaxJ1+YfDNbqUuBElsGIiZHJX9IKy81WLu9ICCIT5ES30e5uOlo4OPglXxOk5t+H
 pB621AmhjfkZ5SB8tpKlr2CKBZQvKw8cOTq5WOUcwn1MXfuGw2I9WHdlnG5fUsePGogqQLTfRJP
 UTWtCNeKWJhs1jsdPY8SXRsbniBELKh4wOfntntuJJk5bP6P3vllBY5HxDcLFQ1qHie6H+3znlU
 zM2lnhK+DPZJL5PKcfONGAf5k5nPHjgWVh1pdMUbyN0S+zRru9Mh6TGGYmoagE5j+4TJs3Lrp+F
 GxX67ZCOi4ihG2HMxH8Y5OW38sskuVdxPNBwCKvU=
X-Authority-Analysis: v=2.4 cv=WcIBqkhX c=1 sm=1 tr=0 ts=695fcc77 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=3h__0y5NYsgpCY70QnIA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: efjtspZIC6aP3IcblVNg5F65vEvmt00O
X-Proofpoint-GUID: efjtspZIC6aP3IcblVNg5F65vEvmt00O
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5237340017
X-Stat-Signature: gia3gnkq8xytta8sqbx6kjof7uye6fd3
X-HE-Tag: 1767885953-279132
X-HE-Meta: U2FsdGVkX1+tJ2LGvy6GAmHS2eP6TcTarrDMXEfgDB6i7XEvlIdo5yGXNoKBrvY7a6fMHJq35QNSEsbS9msO3LHDbkBiXTOdBnrOgjX0O5XBxHfaSmpIexaDPv+zgZm43HDpJmSSnstdh3QXT+VmbdupEEo4vRGhZW42hm8T9n5G+5mo3Cz2oh1AnqewSUZzcQyxuWMZQ7nl7gY6AdJutuvbx8DVdPvQvegv9Pao8T1jeA+5vukU2eCZNyx35G6AvOYJQE4FrxoeEz1NTDhN6nm78JYl0REXp9FnN0spnchrzSBHFX2cglPtNC6ydhqvdWlmsAA5QQvM+5bbH4dbsgWndTbowTBUH75UWLSvUXyBiVH8MUpci43uhZ4VW+4DOfOz7aKbfUNemuGWvAAoWKAZ30zinphzy28KsiCRXuoIYCtSbFI3b9MHr+NsTByNfp0RHFVPMgPD1GJoRpWhlIKljJCmuKZ/1JY784IBtGD3ypdPidVF93176pY13f2r85OUd0I3wwSLggI9IbqoG8gS31ph3DB5ZQwnviBKLQpUngJyeH5dZRAn/miITKkJk3DBu3y57s9GRXWkh8nVg/DOm6+re8uMtARZ+FjoslvqRZS3qUk7KNkpXZ8s0rPMs39Wcn1G/qWAEFz7bBuHH7208k39bltfb34Fda02FCxOQTm0dyk3nHsn/PFh447k8sMpDUoiTqT8lYmZpcDN1Ibvx/8Vo94EWQvaG+wT7+V132H7BA3TcSA4RewUn0ZtXQKPTeIoA4sDAIRFytFl17KLlRFNBbLLLj4nqe0JTk/NFXzQJkmFc/cn3wPTUGsjQDTuPNFeL4RsmcgSywJBo6AvCn0O95DBYR5DqoqwCZNMQipFdq6/sm/Vf4dqVgES2lvA/HtVs/nHlE9TefZwLVuTyLCOQ0QZme+/UwM1GmIdyY1CoYOhaybtaYPBIwK3eYMM8XGnth6R0Is2fWQ
 LSfCNXd6
 cpnEkutBN3A0HPAZN8XhXtEpD9gT6H8n903Qi3Q7CNMEIPewYAUWiZuNIOzBVv+gkGCThosSU40OXHsXOKPhWZT/X2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 10:29:44PM +0100, Mikulas Patocka wrote:
>
>
> On Wed, 7 Jan 2026, Matthew Wilcox wrote:
>
> > On Wed, Jan 07, 2026 at 09:31:14PM +0100, Mikulas Patocka wrote:
> > > This commit changes -EINTR to -ERESTARTSYS, so that if the signal handler
> > > was installed with the SA_RESTART flag, the operation is automatically
> > > restarted.
> >
> > No, this is bonkers.  If you get a signal, you return -EINTR.
>
> Why?
>
> fifo_open returns -ERESTARTSYS, so why not here?

This is fundamentally changing what this does for all callers, and we've
simply not encountered this issue elsewhere.

Given how long it might take to work it might be interrupted by another
signal on the next attempt, whose to say that it might not result in a
situation where it can never complete?

I thnk it should stay as it is.

Also the comment above literally has:

 * mm_take_all_locks() and mm_drop_all_locks are expensive operations
 * that may have to take thousand of locks.
 *
 * mm_take_all_locks() can fail if it's interrupted by signals.
 */

Which at any rate would need to be changed even if we were to change it.

I'm more and more inclined to say let's just drop this series in general,
and you should go fix how signals are handled in the driver/userland code.

This is really feeling like the wrong place to fix this.

>
> Mikulas
>

Cheers, Lorenzo

