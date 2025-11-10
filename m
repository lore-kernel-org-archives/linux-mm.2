Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F36CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 17:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0498E0024; Mon, 10 Nov 2025 12:23:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6703C8E0034; Mon, 10 Nov 2025 12:23:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C10D8E0024; Mon, 10 Nov 2025 12:23:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3158E0024
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:23:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECDC95701D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:23:18 +0000 (UTC)
X-FDA: 84095368476.17.A6B49B8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 955D614000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:23:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=P4ikck92;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="VpI1Sm5/";
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762795395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfvnTFgi9kVmRgVGvbjHzuqJeujnO9D+wFKW29D175E=;
	b=ypH4dpIJep8Febcts3RIFNNsNFRlnDiMl+l1vBBl+opnf0aC34f4lIRdJC55AqYMLcTmXi
	p2Vei9aXY2g4Yl8/DIAYVg9Tq242GOGK1n4j+OaHlx7FQewPYPYJ2PkRN9xnWLDriKcJlw
	7D62JR5zOWHqGqu5yLY5tiMZwZFFtCM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=P4ikck92;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="VpI1Sm5/";
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762795395; a=rsa-sha256;
	cv=pass;
	b=se21nGu+xr0j5cj7GTAjQ3yGxhxiDJ/iocFdUraZKiZ9to1hqpSmBK8APvQf0CX0FV5K+b
	8gkrncdWG3DeGH10MkFEMcN0NvkMJhxukzoQeG/P69+TPu4QJsIm5L+1vhsAeEMkkfRk0q
	bYV6JrwpAs9chH3MEYF6vn7E4tQmzY8=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAH8JEE005421;
	Mon, 10 Nov 2025 17:23:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OfvnTFgi9kVmRgVGvbjHzuqJeujnO9D+wFKW29D175E=; b=
	P4ikck92kkReA+vrtMSeWEdmTSawKwxYQm81H3R2d1id7PmDGFPJbj5Ir0MTtgSc
	ES99D37pPxKO86LdJDZSqOLA+mGs/WU8hgqK0m5nyV5YNJeNZLCO2+gnoxwByIkN
	hS5MMgHkTg5Fbuau8mI4lm7OPl2Z9F70x1iOYfEms7rdQ8YcAXjKHRLWrvFdOXCI
	MILECXxo5Kdoc2Xw8FNcLEZdqdQebT335FekMvLpmxfMILsQ0sJKeo5aFOn5Z8qw
	w4exWbBOlthpcuJ2lDtf2AOMN9XkvghPLMOkEDbDP6Ztpfr54ve2HnCCZ9ysslrt
	gWSFT+v8Mqo5+fPnPt/0bw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abkwx82av-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:23:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAFp7vX007474;
	Mon, 10 Nov 2025 17:23:10 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012029.outbound.protection.outlook.com [40.107.209.29])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va8y01a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:23:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LEutJ+n7cFgGwrvxWa6BaChxDt8eQ7ra+BvWthNylq0c+e3eSbOgCq5XFY053Gx6gRBbKjqeJUq41wuHzPWb5Vg3Oc68R6ookQX+d1jaJXd+/TT04/C8fr7eGMZh3efv6VGk88tVxX8DsJf6oYL5iINVw1NeAYiifsmM4C2wz7U7HpKa41xXojzqTCcKQvSHWtxwxvW4uoTKV5g/2tR06qRNOGY6JvzJok4ya+NC1Bg/cly59BuOpB0CeJv/YYxbBnTvjYmaqRiim/gbA2OTFSZjhSItooDGJdZUeMUCyLoRWAzMMB4LljJZpXbkRb/KrutPVHUPOLcXsMdE/Z4iuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OfvnTFgi9kVmRgVGvbjHzuqJeujnO9D+wFKW29D175E=;
 b=zTevwRi4zNP4cwKaEd7WnTtLHpmxcxmE8e6NYbJNX3oownKTNyHihqGQtF6I08VsruLs2UaNNSyIdeATOvOLbZferfOhNeqTjgNF869pBYbDxswWDgcX51ttyvYMXsnRcdt88yrJiTkbLYmUKbMZdEh+ugiwxf61Rm9cuPsYeEh9BQQ8bHphER06R525Bah5kvGh2LHkbtfwU/DYXCELtKHdJdi7k/hy2Pq8ufKi4U3y36ZmbqHyWCUlBhga7QWanTS/LEWEzMqjDQc79E7wCUw5uSkCbpEKg3/x8NU/g7ypn2czxrFaxPHOLfzaKDsa5IOgE3Lq1cGyJ/CG6uj4yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OfvnTFgi9kVmRgVGvbjHzuqJeujnO9D+wFKW29D175E=;
 b=VpI1Sm5/+4ZAxD8KtO3laCEVZzBGP3JMNeGivFPqXrBGbD5/HiRsIftj7YpPcBlsbUzXJzcsiZWa2e29J/XUirOC2Es2GhDy+yy2fDk5b6LGizLFy7CPHoluoDYQlJSUbK56GV2WnaBkV9Z84KIzgIbmUIOg32epxHetxWAxbe0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB5089.namprd10.prod.outlook.com (2603:10b6:208:330::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.9; Mon, 10 Nov
 2025 17:23:06 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 17:23:06 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm: rename walk_page_range_mm()
Date: Mon, 10 Nov 2025 17:22:57 +0000
Message-ID: <c684d91464a438d6e31172c9450416a373f10649.1762795245.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762795245.git.lorenzo.stoakes@oracle.com>
References: <cover.1762795245.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0235.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::31) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB5089:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d575341-af8d-462a-86e9-08de207dcfed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YArd/J5zAA7Gibux2BEyWERWw1RZBMjBi+Tv6vUaKx/4DeSZqOa1mMFnBHxr?=
 =?us-ascii?Q?Oa4FfxWFLH0vTfq8T2bmjPLYfF61xLDiL6iJN2XKq73hpILYKUAoIaxmURiO?=
 =?us-ascii?Q?W+n6qcuBajQNA9OueO8O7qZVffDryqJAtoYqz7AlgODcaMUo3t8nG1t5eH92?=
 =?us-ascii?Q?BJ4vPruu7Ri10fHSigbzDwsYl7JKe9HQxGOrOEHuJx0Wt3lQhV7nKSyU/oif?=
 =?us-ascii?Q?9HubMSveJt53WDu0SiZ0HuEspLhSeXcgEX+1Q+vTH4b4eyrIKlhbVIMhZQJz?=
 =?us-ascii?Q?HYb+LSY46cQuJk6LEbhnon94kDIY+FYyA1XqTCVrQWNd1SVHZmZSM4uRmro+?=
 =?us-ascii?Q?jpCKAkCy2QvJNbpgH0JoGdV35UCoT9p0MwvxJJ2fhsuwAwixbOgP9gj8MNUX?=
 =?us-ascii?Q?ZoyxNL19DuAMkN9Rfs3yBOI7jkJ++eoRAhxaYIBMXC7UEdgrmDhJgZiDSknk?=
 =?us-ascii?Q?vM5O0Itbi04Zp09vDQh9kauZf4poBfX/NEnMT8L3pOh8g4x2APMdW48Sy9Lf?=
 =?us-ascii?Q?Qdfb1it09ftjAkjoHJ0fC8DHmsbBtdZ9CmzjsldN/HryWRsdFAULDx4Sv2he?=
 =?us-ascii?Q?05cMiMSp802dT2S/qC0d4p1coJ7ZLmh7h5EdlcIcR2TMVJNlJ0Hev4/zYO/5?=
 =?us-ascii?Q?1TS0E1YAwQTlUj2fQHdcwdFdFnOimDANMGZ2DSlmnbqStrBCF4hXi4PfCMbS?=
 =?us-ascii?Q?x9O9ZQ9wGfgoXxuVAdXf6AnRX3hmnywgK5GtpuUt+eKaREz0ObKuUJaOpi18?=
 =?us-ascii?Q?B28D2D/FxGwLtNhvz5dVgHrYGe58tynrhqsKQENOzkssEAIRpluJVgnp+mLR?=
 =?us-ascii?Q?HUMjQaZ6dX26s41j6hiTg6ZHHlXGrPc3GFm1eE+rofy/JKs/xtXB//H+sCGq?=
 =?us-ascii?Q?UIU9PiVF2tf+CLOrOcalA/LpkbWqEIRb3fc7Mz2ZiOBdrX1O6eWZ4tWe/hfB?=
 =?us-ascii?Q?+NHcmmW3Oxig1+sGe2CBrZAnRqYDweQT4jz+eE8znJroHSyKyRKD0OwkjIHL?=
 =?us-ascii?Q?Cv1+v0E2iuH3fgGcp4kWmsSsZbz8x9dVr4spfHzpHLWKlRy1KC2WlwB2FM/R?=
 =?us-ascii?Q?5XsDforg+VHjMez2GgYg5B2ylaeUAk3IXC6Wz+5ECm19ONLHJGqB4UHTNroy?=
 =?us-ascii?Q?I04MuT1iMT/nxz+84RDS+qHkN076gicTuiwz0oT6j8h9E0KmnFzfA45xU/4F?=
 =?us-ascii?Q?5acdhtLZ7MsGIADKcd4wBn1K3NJqE/XVIsGgWyIqqkq7kNUfbTf5Y3qFHgb0?=
 =?us-ascii?Q?PwBdASDUfSUvbzymMytkb2gjrBVttZNlG+d5lzQUvHFdWyNxJ77m23+j4Uh1?=
 =?us-ascii?Q?AocBnLeW6ZdPLir6tXKOSyKWpoXDPbO9PzfKhF7kDtsW0RwUe/MARxQ3ocL6?=
 =?us-ascii?Q?ZaDJLKO8x1PfIlbga/dnoOoGCDR0NbcHTv6rGfH22kdS8nwrBQhHLVV1dZPE?=
 =?us-ascii?Q?vZXZsLf73zFxlbGHykQvog8W3mBz49M2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JF98mVGW9U3KOPN2VH4A2GhSSYil9jA1wLPKc7ViWEL6idK5V4425/fIaxuu?=
 =?us-ascii?Q?slLN+vawBGcVymCbQ+EnJbKbEs9f3tVJ9gKo5UeaN7dASq0fEnxUHnK6X3bh?=
 =?us-ascii?Q?fGurUO8u+EWbcCICVPjPSLXfrY5Rz6RUKGvUPSAktg3E7S/Ysc3zBcAkLXmd?=
 =?us-ascii?Q?N105zFLVnUxbVDFmuX+NVXCxDqCEKvdf9Y5Z3sQNLdN/gyEOdTME3pXjUEQa?=
 =?us-ascii?Q?2DSDiAcDP4q+CUTPAvkcFUYxRAUy2j0jfIz905nY4Spq4jpgRPP+yCMIGOQb?=
 =?us-ascii?Q?x+P7At3igm4xCgKfKSwP75uDtoNjfGzty2pNQpl+Tipnvrg/V00Vs+3vQI1Q?=
 =?us-ascii?Q?73YSkZqVGuyL3x0Fg5AnokBu0MkueHOtgvmc9ROXmy4FMQfw/qmXRUg8xu2Z?=
 =?us-ascii?Q?8rin8YWRCDnfM3pot/izXFjMiWzrmB1tP4T6OYlOeytCrbH0L4oE0b0J+0ph?=
 =?us-ascii?Q?1I99Ly8QWa9K70EEBiD4dCVBPtKuiBKdW1B5DGDwMVszJSC9tHAiIvi/qiuU?=
 =?us-ascii?Q?7lJs/wLgmHYLs/DeZUlHRX2EAfjuqMJIWZhGn+1iNzYRbl8hfywrLduQ6dDs?=
 =?us-ascii?Q?0F2i5qXDK4CzpGVNy4RSiJpMGteu5rVpFy20wcbB4bZnCtqAlan6HzktJP5K?=
 =?us-ascii?Q?VpRNsBabo2ZS9dF0uUVTT7GpyXbCcg2xCeckb7MhoTiqn30IvtKP+KXsxg5L?=
 =?us-ascii?Q?91XGvaP2irdSyV5QBONenHji6o8B1m1WfxoSKqeuxSrQWQfAo6bBhMZX/n6y?=
 =?us-ascii?Q?3IKn3XhPuLFzI8qyvniiHUAOHtsiL5l/Jqz5R3deHWQdRcOzSR0AU865lDvG?=
 =?us-ascii?Q?fMi6sz8dPllE0CADy7d9CqWMOk+AEGOZ4rWuxq/8YE6rsT8gxRP0dAM6YaxK?=
 =?us-ascii?Q?sS/VMVPGUnJhDIEBpguYUHDCn1DGkE43njBIBLsxTeODy8T19kd2LWX+gw20?=
 =?us-ascii?Q?Nd9guQMPt15eIhJaEiJrSQKJ8tiEkNwZq6WM40DXdjvAS7USQr2wlQLVQj4E?=
 =?us-ascii?Q?mxkQCPRPgnViS4QKETFcyGudQjnOBoUZ1cPRuqXcsiQagk3z9a9UcbIlEZWg?=
 =?us-ascii?Q?lrx/VBGvoek6IHW63TOmAHKDI+g0BHf53hSbqf5ieyKUKbcEPSvza/uoOW+A?=
 =?us-ascii?Q?sRzCv6d2+D0IaFzx1BIAAqRoFgTiaXimDGTKJhtX1fz2mv/HGSHsdl/Ko6PG?=
 =?us-ascii?Q?vLaRjZFZvf5Sxj4F9ePbhq2VHn5VueK5qV2peisDAhBxe5N46GhDJY+XBMH1?=
 =?us-ascii?Q?rY8ZZkUoUh6T1iUhbomS3PnhhXOdGahL7t8eBcZfMJ3TVMbIMywjx14AFRag?=
 =?us-ascii?Q?ue5x/s/hyBEO6ghZb+TPxEkNEfRy6o1ERZHn8GQr4IOr0UuMLxWH45ICrs1A?=
 =?us-ascii?Q?uvXtAeuDb3vpdVnk+c+22+z8DlEqTT5Vi/MQ/HNOeGUnSxf3NexUDlTNl0C5?=
 =?us-ascii?Q?694cdGdfvv9tupEU77/kapTL2OulieVAj0Fn/+rz4CJ5J0psZDExSSrEsDdO?=
 =?us-ascii?Q?tmJFraxMBlP+f6tgfJFJE+QD5wpXIbu5/jyR38aB0A+sofLF5p/C7dAH6XcG?=
 =?us-ascii?Q?HK/zbGHvrwWRJxK/KYID0VZYEPkYE3wjk/Na3FKGfGzq4FyXJZo5U2P6UPQI?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GADYWqJkdgiPKEcqzqU9OhFrEDzuFq3zAgyFe2ENkQaFQQbwqePSoTOmWDuxeNwWpf5PcaZGRUq/5v4bR6YyqZGQcLbg54uDOc+/xEW1mBNjk1Ozqqtm3eiullbRx3uAmos00uoJ1wbXwyGj8izps0KsKz5wTW87MGXTeQCYNPb7o5Gtis+3ayKV4ouoo7I8cc2bju0TnuiTMquVGLVSwJT93P/VNqyjV3Wl7UP/9i2fzLi2vAztaF8DSFKO0pdo8JAmHLX+16glBzQMfIQYDqxNjOp+iH4gSi70GGUzlJONnwwmFMIV2gbK9jwBcuPnt7UGpYzGq/I0LJfwO2kORX0ghKPcFGNWtHxyip3ewYc1uWOC3K2xXXFYVgv9vhmO/kN+aTioj9LKih13hGNUMaOwEucFogQBxRUVWd/D+joHoTtp5RwOi+GjOSJ+nbb1vdRVGkXoZoovMd2ZFhwuvzMxDqC+eotiuVe9Cdv4fMG7u0Q6/CzTbpyi//7erxmGDxWJQx6N26MCz725I6pL0fzjVG+oZfP+dQtF9zdnnKG7qhG9pcNTQ12UuLeKJSzjPKR4gYrH03OgdZF6Wfn2affi7rTv/IQ/xwAIJCyILRo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d575341-af8d-462a-86e9-08de207dcfed
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 17:23:06.6178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CCzZSUb9IKrU8Zn++q88E1aXupO6T48jG+j0afeF33qxvMqrH72NofsjT8KUk8/h3AfX4kp8nkVDiHyyUP1eGMRWdCrV7urBHSItBErmtVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5089
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100147
X-Authority-Analysis: v=2.4 cv=W8A1lBWk c=1 sm=1 tr=0 ts=69121f7f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=SqmF7T72WtlrkcSyQF8A:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: baVfrGkzSnj_zC8tB6uU9bZgHSMfl3qG
X-Proofpoint-GUID: baVfrGkzSnj_zC8tB6uU9bZgHSMfl3qG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDE0MiBTYWx0ZWRfXy7LLS27vNe5N
 Q0jBR19uh7vsrjhMTNMynQCbA/ai1wr/k9PfWv3IuWdqSiJfW6Ge/umX42X9S+X4jT5zNzWT1ZD
 uLJCYFGW2/TFiY3Gt1Aopt5H/XQt8p4MQiJmQBOyOl27VD1OuW1/ep19yZMNtzivoybPNxDZyBL
 CF0WuJmTd63PZ6tl4f8rj8RIRk2PUtOD4WEvDHld7CdbgY9cQ+2xOCG0Ixfx9Vm36dIpCqJQyVV
 04kfNbC5ifivbmg9vQX6qTynMTekHN5OvV8kaemqICKy6cDVi1tziRpAzAS5mwYnmyXPuKZuyfi
 8uNc9NXVB4krt6fmYtegSubl/md8rMVKiX4IY5oaCqb2lrCDbqR0vhESMHVse3PIZOcGq/me/h/
 ugRVPOnTwy2LlQUnXpMSud7HQERVWg==
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 955D614000A
X-Stat-Signature: abo9amz1jusx9p4u1gnur5a4oi4rz1sd
X-Rspam-User: 
X-HE-Tag: 1762795395-365107
X-HE-Meta: U2FsdGVkX1/9xWJ0ynnnPcd8Gr8WmS6c4/PAxKECesB0TzhT0SuuYBJaUm/U27sNx3Jw4j5KPLaWibN7aFEFMEskEEyiOcgMlFGBGqH6Vvu2tq2ChWTYVDQDNia9Wc77lPxGIsK0An+Sb+MrBpFINMtaSbKPJdFfE4xsxI1uh7V2/BM3SW8yVQyRFK4RHGji9tpElCPmRoBqqvvtwaP6PkwGR+tVtwRMfg4uR81pYHHjTKLfqZU2lqnUc7g0EqLNdOHnuxxJtyNcjdVDflcsgLA94ZnoSJHlrEz5jzhF1Gxz2bDFJytC4yNieNQ2oi5qOQkc/j3WziCjQ9/YC9rzADF7icFFh/msS3iZfxBCubgil6BrTc9hW83gaQpSzuJQtF4wAWPRMGHj7RoPWQHeFwrguCOom2yQOr9AIHlS7isBJlcAi/BNTDB/1Q6zOtKylRWlzrl5u2P3YqPfl8mTkrfQzffMGrZO/m+6hbfV5TkXVWgciYW4easPkuLq7EOkAUah5I8xE7CovQqR48Nc2s99dNmWl1JQFVUEKFY7z11EqwqHzyv8rDoBbnnQ3REwkqkgXi4bqssh0JU002a+UpWgArZBAqAWpKbAmw/4zhlhdsmb/0veaW6zgxLB95Em6wNj/+BSSRzHzZpEpFatl72tDoaHiU9iZIU1n+CzKfpyN4Qf8YPuhsbXbZu7KQmQGOywRLlgjIbgtzLe6RabdkPUNdkaWuZsXCN5Nm+s+35VHR9M1wu6iArNPgnO4zZFGhyD/Y7qwj4nMU89/7znDk2jIul9A+E15h+sJKW0ntpfRIlxUJUZdz0GjEv4mXW8uLaXRbMAo0s5s+1c0O3ibn4g3VrOi0AcT4EJNXv6UqVBHNwSRlhz22sIHmU/Dzhvf4zl8UTDbtMcS5XccX6BDd94JlDwTAlqNJIxZ35jhB/X3iWgqmpFAGRJa6Y+xgjcdm700tzKhcE+vIRV0ah
 nFZ4Dpsi
 l2Z/YV8W54p/nlm9ar7frhGCDpdNRsANcrZAlEa0Hg69E3XLoC4DyU4e+SOZ1OYSyubqxOj3ydGKzIOw99cxZJ8lFL50vaAEy/2oAaQ/PtGca9NNhbyMAeQ+MN9WbjOAxg7x/GNCHvf8GK93wHkTneNeRiTW8g9Mg03VvLE6zqtXqXWYgci1HI4bGG1wt8QjVoKoT5V/iH1MyA12f4LGBnznTSUpk6f33cSwxUi2UtxNps83mEbQ7YRdk+j9MT65HbIVTw5M4o2epViQJ+7APsXAdZoxelYmVGmS4RVqjdZJDpmmaWB8t18rm6UUEiMEfNCDTCwvxTyKdxhIdksASB5JZJoR4YTSvkxEakLEqXId/2eT90OhPPnZgOWk/EgTOaOkisft+NuLBmvIdosdVYCEl+zhLEzOZeWYkDqTaK0FgqxNhKo4cmvSB4Dp2gRj6r9CV/63FjcknwKXWrXNYpT4ni7dAfjnH/qilaE23xJHy5deUAV12wgVTyvTGLU8VcMH6n9wmeJSPSlf5mneJh84P/PSf+ofR/sQ3jjdLQHHH/keglf6G3L4Mk8sUFp0rota3KEq9YxNkIeoxrGGfhGxaf+zwsIdgus/oi0uiZO/pLDU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make it clear we're referencing an unsafe variant of this function
explicitly.

This is laying the foundation for exposing more such functions and
maintaining a consistent naming scheme.

As a part of this change, rename check_ops_valid() to check_ops_safe() for
consistency.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/internal.h |  2 +-
 mm/madvise.c  |  4 ++--
 mm/pagewalk.c | 22 +++++++++++-----------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 0af87f6c2889..479234b39394 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1652,7 +1652,7 @@ static inline void accept_page(struct page *page)
 #endif /* CONFIG_UNACCEPTED_MEMORY */
 
 /* pagewalk.c */
-int walk_page_range_mm(struct mm_struct *mm, unsigned long start,
+int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private);
 int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
diff --git a/mm/madvise.c b/mm/madvise.c
index de918b107cfc..7b938ff44be2 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1171,8 +1171,8 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 		unsigned long nr_pages = 0;
 
 		/* Returns < 0 on error, == 0 if success, > 0 if zap needed. */
-		err = walk_page_range_mm(vma->vm_mm, range->start, range->end,
-					 &guard_install_walk_ops, &nr_pages);
+		err = walk_page_range_mm_unsafe(vma->vm_mm, range->start,
+				range->end, &guard_install_walk_ops, &nr_pages);
 		if (err < 0)
 			return err;
 
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 6cace2c8814a..ab29b16abd2c 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -452,7 +452,7 @@ static inline void process_vma_walk_lock(struct vm_area_struct *vma,
  * We usually restrict the ability to install PTEs, but this functionality is
  * available to internal memory management code and provided in mm/internal.h.
  */
-int walk_page_range_mm(struct mm_struct *mm, unsigned long start,
+int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private)
 {
@@ -518,10 +518,10 @@ int walk_page_range_mm(struct mm_struct *mm, unsigned long start,
  * This check is performed on all functions which are parameterised by walk
  * operations and exposed in include/linux/pagewalk.h.
  *
- * Internal memory management code can use the walk_page_range_mm() function to
- * be able to use all page walking operations.
+ * Internal memory management code can use *_unsafe() functions to be able to
+ * use all page walking operations.
  */
-static bool check_ops_valid(const struct mm_walk_ops *ops)
+static bool check_ops_safe(const struct mm_walk_ops *ops)
 {
 	/*
 	 * The installation of PTEs is solely under the control of memory
@@ -579,10 +579,10 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private)
 {
-	if (!check_ops_valid(ops))
+	if (!check_ops_safe(ops))
 		return -EINVAL;
 
-	return walk_page_range_mm(mm, start, end, ops, private);
+	return walk_page_range_mm_unsafe(mm, start, end, ops, private);
 }
 
 /**
@@ -639,7 +639,7 @@ int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end
 
 	if (start >= end)
 		return -EINVAL;
-	if (!check_ops_valid(ops))
+	if (!check_ops_safe(ops))
 		return -EINVAL;
 
 	return walk_pgd_range(start, end, &walk);
@@ -678,7 +678,7 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 						    pgd, private);
 	if (start >= end || !walk.mm)
 		return -EINVAL;
-	if (!check_ops_valid(ops))
+	if (!check_ops_safe(ops))
 		return -EINVAL;
 
 	/*
@@ -709,7 +709,7 @@ int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
 		return -EINVAL;
 	if (start < vma->vm_start || end > vma->vm_end)
 		return -EINVAL;
-	if (!check_ops_valid(ops))
+	if (!check_ops_safe(ops))
 		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
@@ -729,7 +729,7 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 
 	if (!walk.mm)
 		return -EINVAL;
-	if (!check_ops_valid(ops))
+	if (!check_ops_safe(ops))
 		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
@@ -780,7 +780,7 @@ int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
 	unsigned long start_addr, end_addr;
 	int err = 0;
 
-	if (!check_ops_valid(ops))
+	if (!check_ops_safe(ops))
 		return -EINVAL;
 
 	lockdep_assert_held(&mapping->i_mmap_rwsem);
-- 
2.51.0


