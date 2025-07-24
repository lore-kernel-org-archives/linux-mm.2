Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598D5C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 17:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0E868E00A5; Thu, 24 Jul 2025 13:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDF1F8E007C; Thu, 24 Jul 2025 13:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6DB8E00A5; Thu, 24 Jul 2025 13:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AACB38E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E2CF59157
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:56:15 +0000 (UTC)
X-FDA: 83699912310.26.AC4EA80
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id D9036140012
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:56:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bIuIW2kg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xiG4IOzi;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753379772; a=rsa-sha256;
	cv=pass;
	b=1OO2fX+wBx5XKSvcmQT3n4160Og7Sx2t8OJ1I2ePdIvlaffy2Mb9ay1IxK0YCEXtmaQv4t
	Ek7k+zdBt2ZK873b3QKg7Trn8sasFB6AIyayuW8av46R2pp3xJxpB1NM46Zt8FOZMbHmoZ
	v0Zwt3X3lazrEYWYqBajlGrk2KYvQAk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bIuIW2kg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xiG4IOzi;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753379772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fqgjw5evexUZVxzoCEU+b8l7POa0Hx9zGrBEeR2TEps=;
	b=shUniunJj5cIh0VuZO/nqcvClZtn1fit/JFOdvy7GdG/Wcu02MRwM3QElccvOQjPBBy3ej
	LPXDAaQAGLdE5aCmzdlN53SER6GhaIKCCaPGyJSVQJ4NfrX9B4DXkZv8mv4OEjryFeNv12
	MOzyiln7jIV7p26OG9Yy/PKDkhQnulM=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OGisZ3021241;
	Thu, 24 Jul 2025 17:56:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fqgjw5evexUZVxzoCE
	U+b8l7POa0Hx9zGrBEeR2TEps=; b=bIuIW2kgpfJXnRr9f5SDAagt3BSCSLOnlb
	lEOXtf6S726kwFE2EqPY8Aji2uVaDi9HXiqKZ1JgtfQ0rfqKFLneowwPX9lrRpvC
	dK437P63vB30noH6q9GJgxOs9Tw6w10Inu35TBiYKc7TyJgePTuDECM/FfBM8J6e
	mpYZyGn17R2amB/JI2HtPgy05U5h+fq7FNeRXNDfRnmFVl/cjDu8THQKq9cQQgjm
	UhDDV7D5z26Ec+wMYwnxRkYPzwzRh6cdzCIUago/tgoaMfIwwsIROoQladn8i9H1
	bO/iB/Lv/KEWkqMEVGp75xPWzPEAw6/V6ZUmNNLsH0hsrrFs9siA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 482cwhvm8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 17:56:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56OHYhfh014441;
	Thu, 24 Jul 2025 17:56:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tjfyvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 17:56:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h20upuFREywaS325UVDacPLFrpClNRrsooQuqkHND45EILIdnJgXjAbakzh2AVVP2txQaKpnGt/RRGz3/ccjguW0Hwy2+c+ny+5eXlDhNkzEleHPXPfZdfM6j/qBWsPmCmeJJWtSaniH7Hasazuv2VRCGUsFFd8C1oJpMC/5Hb60JEXyK80oS2Ef7ebc+eiORig5+kKu3a5epoLUGcRsbjxOULeOHlhgIRX8mwrD1mDyIiX7MXeEYuJAlt5kmh/XsvUFH3Hs+SgKCIYQlkInGfzb75+xoEKemft+ky633nc1vexTPTqfliYZDWqxRWKgYQ6gmy25L41b/2JRq7qILA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqgjw5evexUZVxzoCEU+b8l7POa0Hx9zGrBEeR2TEps=;
 b=uSUfCY6pYpMzsWBDYHkd5ufnksaLD5LMUhEngeZ8YVjhgAD979OpbFseZvKJhEYtEEUyQ/Uk1X5L58oa+SZPPyuGfTYPLs6TCrNVXDJL6FMFOETIxTRo36juCM+8QfCR7quMHtCAe46SY8ng8wKbETbsvzznIs5pi5IRRLri06YeVVUHNhlaJlJgjfmRBDj2P2cVteVWP6nqDW+KQTtcJo10R1O7vJ8M/hLJFWNlLKXDSRmnvS2gYzeIaRnDdAxrGayf3TDe62Eefzvm7NUopRHqaN1x2vPKsbmFnV56Vhfo3rWgdswftEY4XRbvk8jr3+xPiBXJ0n8JDs6vHKU9Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqgjw5evexUZVxzoCEU+b8l7POa0Hx9zGrBEeR2TEps=;
 b=xiG4IOzie/Wo/XjJW5kFXe/UlTVJVaI186Zpc0Uf3G9yDLA7gYb4+MUGulq2v5RSWghuub3dTIxlnNzXBxK7lIflnePz7OXKF/3yoRL0AsdJiWhi1aejr9e/mt5pB7HMLX99+qpPXb6Ol9XCqAXPUZo3PrC6LYLj2q2a9EIGdic=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB6320.namprd10.prod.outlook.com (2603:10b6:806:253::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Thu, 24 Jul
 2025 17:56:00 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 17:56:00 +0000
Date: Thu, 24 Jul 2025 18:55:56 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] khugepaged: Optimize
 __collapse_huge_page_copy_succeeded() by PTE batching
Message-ID: <83c00fa9-37a3-4024-b3d1-20e7749b06c9@lucifer.local>
References: <20250724052301.23844-1-dev.jain@arm.com>
 <20250724052301.23844-3-dev.jain@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724052301.23844-3-dev.jain@arm.com>
X-ClientProxiedBy: LO6P123CA0034.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB6320:EE_
X-MS-Office365-Filtering-Correlation-Id: 9981cf34-950d-4fdf-5eb6-08ddcadb5950
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4wKSnbY5q4oXUneNhKQhUWiDdH/7Ca6ANBoOxQCA3KE/w6gGRRrnQwY1QfrX?=
 =?us-ascii?Q?gYLu5jQeMOhaleJotkiBk9Kd9DG3U/AEYYsoV++OYclG5pNZXdqAurZuILT8?=
 =?us-ascii?Q?E307QWRcYAA1LDIOqrxnnL2DP1twKxmiTnJ34s99/Tr7QatzLLAtA8rpOrvA?=
 =?us-ascii?Q?l9p4Ghi83Qk3LWkJqbDqYgD+wxJhuCk4LRB5T6CvHnAujbXMhYP06anX+S7E?=
 =?us-ascii?Q?N8ROMtCERXwpJn5jLbgrdkkQnQPhCq7xpefzIgVNPpf40vdBZitNINQgM7GD?=
 =?us-ascii?Q?pbHSYJJanj1zDoaHVbUcNb8wNViM2jINy8RLz1dSDupZAF8sfv9Wz+FbYD19?=
 =?us-ascii?Q?iFExwbrqyzEmng47JOjlmoSPN4Ih1h/TOXS+cAqkOSDax+edenhY1VhJ9OvD?=
 =?us-ascii?Q?FvS3L4Lj9vZ4pqHTO5+756GxWpKW2qRT3udDsB5/sJqbuEmjyo35fTLFuw34?=
 =?us-ascii?Q?A8Syg9B1corCCo48pdUVfgAqURBh+n82uv3v+SkQ69yw76TtQeTEaPwgipIj?=
 =?us-ascii?Q?xY+QUy5w04DqKOPta2MU9uQFJrcDnRQON5D91NADCxG8e2MZngB+gY9h0t2E?=
 =?us-ascii?Q?NGeeP6hRPG8tSGhvRsvPpnT/zbMW8ixdV/93lvoVj4GZ+4FTaT9wBwDf4JXt?=
 =?us-ascii?Q?ugVLnoGLNI6v/Rh0GFfTbJ6KZGxRsDRhLkjKgGLxdi7LbqrBsiT624diU1rf?=
 =?us-ascii?Q?k2NiA2t8QN54lYbUwrmad73sMzHUmfBLuJ1por7MQTcrFU2Em+/6v9RUxpfW?=
 =?us-ascii?Q?awPXsWNcsAVxMB6qTYO4HxPpUIIdMoTCcgsf8sil37M+qR68CtbLhKKKOn1r?=
 =?us-ascii?Q?PqyWpVehOOngUgzNm+JuXPahT9zTFjlvJFN7WDLM9J04cArbazqmsY5tEaEy?=
 =?us-ascii?Q?PzgSQyY9Dm1ZWS+u0zKJldYRdytVeEL9fiY6qHe0qavTqu3/O5fHV+j9Hek8?=
 =?us-ascii?Q?UaPFmFWuqAlW3WyAkOjSViKrVkS5wbIEumlAsnL1HV8QlEU7i+AvSocSSpJ0?=
 =?us-ascii?Q?NZw627j0OwX/1eSqUnFbbmUu7vHHvwBbJjMzHmeKXrRZuFXtpUPF9jpzpHYa?=
 =?us-ascii?Q?hSYXS/pV+F3GgqeFS/sc0DPSZNnQhC8sr1yOhQe2qXsPSvA4pAUbUDnCt5ng?=
 =?us-ascii?Q?43jPoIDXvUtPlt/7xwX9j1XHpnQ8rxaM7bEz0whUJj4cnxj2rMpA6Y5vkn6Q?=
 =?us-ascii?Q?hUZGnGqC/he7SbEkmH5Gs50DzDizfmcyCCFyPgJin4sPxOyw4ns8awyies+H?=
 =?us-ascii?Q?fIbWc3u+EIMUbJOhnwZvTvG0Kzf7x6bE+ycvCuz/ZAmwekJ/3GAncSh7x3Q8?=
 =?us-ascii?Q?L6D8dlcGWVVOTQuAtF9c86QZIJwv5KDJffUuC+UGc3pRDYGuYvD+fBvui+Xp?=
 =?us-ascii?Q?68M4Orm4m1ZZby6bjUp9FgxPd6TqH7ahLIid1PVvw/TiO7IAkg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mkW3h+YCtZ1KeILekx4tKSL12xwCkrlGQ3s9/YgPciBGMLF0O3yHxqxyJPXh?=
 =?us-ascii?Q?RibNwcY3FY8pgz1WN5PlBOR8NMqTHMW/11MEJ+aT+sfaYlG3z9NcMLFOo/fk?=
 =?us-ascii?Q?G8SmVwHWnhNJacyri/ERNyOVeAIMI4/F6EtZq+TAD8WK+05tXtx4hwwtJrDJ?=
 =?us-ascii?Q?6Jq5y4jF8cW8fhxLLyMUO87jkUF1rtOSjitFotjMARMwhF59AZYIRhcbNXmk?=
 =?us-ascii?Q?Uezr7QdeWR3SlFHb/3F59tUtvOP+DrZFNJYY4JoiAT+o9PDhdzmlpYC6VQi9?=
 =?us-ascii?Q?lCKRjcBoR1YcAEGgCGA4meSQgFo2Q3WgZsLOb8S1HdbWbJSDqlprfR76h7Ey?=
 =?us-ascii?Q?BVLqWNlisrckOQVvacWnKvxCbTnn3MMDBSBC3yu1LR761mw1Vv4sUp7QuUli?=
 =?us-ascii?Q?mbTQtm7y1E92030lmnpN2U3h4lqPWgcjYBzEBbyw8O/ebaY27fgRqiSe8MQJ?=
 =?us-ascii?Q?5AmTCOldq/F3fAQSj6LkC0TZVq2ihuTzsIyXPQ10rBjUzhgUNstxK1bAyK+/?=
 =?us-ascii?Q?oywMac3gYMjMMSB2Wv4jdxXALepkpFHPrLCFKVnoV3B8I1ShDMngNyWI8LZn?=
 =?us-ascii?Q?K1Oikn55MeEbFwqfxriK91MvLTBE5DUmSo5cTvfccCgu/AKd6gm1gH3kZ+8j?=
 =?us-ascii?Q?93C8KsG3wGPfCAlfZ+NHpPR9w8QwMQxHFN8n9ikjrVHULEgHQvDzBTmOGv0X?=
 =?us-ascii?Q?UTX3iZwv1kH+uekJgo5u5inSNUgcGWQPiI9W6AhNA/odDWCmw5k54weKJpYf?=
 =?us-ascii?Q?ugWdhuyPIiPZ1fFFHFP9G7KWNpnrN+4V3IWyaH3bIaqzfwqy55k7k4B2FPqd?=
 =?us-ascii?Q?7Jdid48ret6P9hCk9CcSKXsGJ5i45+QuSoKqm2TorpF/JaSY86PXtguTWkRa?=
 =?us-ascii?Q?rq3UYXHMVrrTvlG6ctQ1zgP/CwVfw/lokwuGVmJP7nsh0olH0T6BbMiGVI2s?=
 =?us-ascii?Q?R55NSWOm6B1YFgF8apTAETgNk62N8tN4x93iX+alf0XwL3DPcsHJBB3DM+cD?=
 =?us-ascii?Q?zPtTt0xiQLK6GU6POs7G+GrMPgzmitMIRq4WFVRY/sTwkPUjfb3MpY6KxNSe?=
 =?us-ascii?Q?2j/va1ZMkqc1EqxCELwkHDT691/Ugn4wSEI7oWWnSV3KUl9E640WrHdhQXFF?=
 =?us-ascii?Q?zogOh8vn+YNz/MbH1rnNWYCaNo3Ob17GAMjxpulubP/8SHPLRD1/xkQuKjeJ?=
 =?us-ascii?Q?UG1wbYg3N/GbwuC/9SOxKm1HjSO68gHpKjo/ThwabRKaIiBlirTi6ZOQyer0?=
 =?us-ascii?Q?sv3aIPJfz3UrgulnaOasuHhGeVqnEjrKN/s/aX3wqyuIZAc0cMhdQ04y/KMx?=
 =?us-ascii?Q?NndL5wJb4ENhAUV554ExM+a1nXgQeaerkLhOvtInz4qemkVGjhFEDdET2jxK?=
 =?us-ascii?Q?EOYtaWH4Q3yko/RIM3Mh2vi8QhYsgE0psFUX5c+0tu9Xxw2JWViWFnWhZ9cV?=
 =?us-ascii?Q?bYYbiUF4nn9mcFFUTZ0012M8mquvnkBgVWBTm958+37e2hdwXFYUNYROL5yr?=
 =?us-ascii?Q?DorM9VUK2HTNShZsgGl0r+fgKgKkg4n+RwvH3UB80a/AXMLqd3o2SJMPcHE7?=
 =?us-ascii?Q?qu4c7GbVzaxsNDeyGLIRiD+h8rF8LTEzjilYuPofOiGBCZ9fHsQf5h07+9jc?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xHi+wiDaxCDbFza5qb+M8VqB7gQ92xFHL+y38yaLflgdf9/vHudDB8Gx1RpWRfNCF6G0B1YZtOkX04y93o/QlFHvcRUX8XdsPS8k8FpO942a7bhf2148SeG9GcpTTyD/r21v+QDmtuanjsgSMkWQR3C78owPJfgP1HGpGoSijVi9CDClWKdM/bItr1IbSk/p0MYi1Rj73HwhXev8IQrivJFYA137S733gmI7ne9Mi/2gy2ZhILWRN7RGT24zHvgAIZvccEPNkUhHXbFCSx/yuX5AsbBDNWGlvaLynM7veytrzeQUbMi/XC22Jb7IqiIQt93WbE9XK0wM3p9z6wDCJB8V5LbdJweXxlYPMvQ2BPLPFCiVXZVg9pLsN99ioedky+dXH68IjAKwQjfH50hgLx1U004vxGaCOhsdMG5c13u2+i7nZrIAwrWyHhzv4YTwPXpI+PBThdlOB3kAfRZ8VeHx14IHyvOHQsrxNdNriO5k/0sYWCv20DP3G+Durq5iIF8QAaAdPjMcVpxaFuU1pIByq/w9KxKaWtQB7fTm3tZcJDkaFnY6oVsG1Ba9bPKjCDFFyDEmdsujMQK3YlzmLukjMMl2hlk38JxUr46EKek=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9981cf34-950d-4fdf-5eb6-08ddcadb5950
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 17:56:00.2339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ss6N/SRzwokJvOXhp5h3VLcTc5psQZIWYEnjuVQUJlXEjclrw3L5f/MmiITxMbuJY9sNXhkEj5QqzB72araN/nCCUy2vPuQulSNhv6LYaaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6320
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_04,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507240137
X-Proofpoint-GUID: nu_ct12GM8Uj5JfR1czG6S7kpbcYKCIT
X-Proofpoint-ORIG-GUID: nu_ct12GM8Uj5JfR1czG6S7kpbcYKCIT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDEzOCBTYWx0ZWRfX7ZsHQ4YxYw9Q
 Y1uX9TVdFvlf6Bdbcrch8XeaP3lTaLHtfYmvYPD3LI8n5LvJeUJZ4zge+D+4J5uyTF27TP+eQPV
 fZwZFuG/kcY2SX3+hwg5tc8ucKr2i/4lChmrw7lnAGiewwAvGF2l3HL6OrXmoOhe53qbdVj17vz
 j9+0kMsRdedqmNtqsE9i1uaD9D5UuL+S2uCUBxqkpISTSx3v56PJXoyV3reZTbWacepgoFUZQJq
 H0fJ1uXsULqGrEwxIiFbZRfqzabAymd/tJxeeEWmt0NzHHPou+aWFB7PeXzGusgQ2RR4iQbWXXv
 pfcbYPevpYzQI7afh/FgY2aOupvxWZPi+tuoicMeVCcNd/27Ku0z+es0AwMagwUAUXghENwOW24
 IhC1SC019WzPSQq/L8/T+lFJE4E/rGLVVRbORFK7d1JpRSbLnCKS7u5rFtnosX2PXaPHL0DV
X-Authority-Analysis: v=2.4 cv=IPoCChvG c=1 sm=1 tr=0 ts=688273b5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=20KFwNOVAAAA:8 a=SRrdq9N9AAAA:8 a=7CQSdrXTAAAA:8 a=BnNTnArBTrcTViWL0EwA:9
 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12061
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D9036140012
X-Stat-Signature: k9wtt1uj788odauk89gjjjf5b1g9t6jm
X-HE-Tag: 1753379771-800079
X-HE-Meta: U2FsdGVkX18LAE7NS94Klut6wbuIX3XkGKr/afN4b/6U/yAn3okQ+W1Q+phcTEnaWAi5rb71yol+U2gNs9CC4s0Rt5a8CMhgWqrDKwqXGYmEwNg24qRkHY9fg4Vtls6egXuKAENJKUvj6qSwNbznr1Iinb93SvQt9hA9XB0MpPt3TA2/Ng4AbZR4cNazgw6+5XLbU8u/qtvrzIL8ERY+Co/I5RR3Wil0GKErkSVBpXSbhyo5h2H7O3mmhf6esHrjqocvMwqc34GFm+WZlAhKWnUxSaSr3RtNucqshOCXI1w0/OGuX/HokCVAkPzRf0RMZUb2WEXFg34ZykmxWVA32JDzgF2ZJt4Q5Q9nqJPgubwurzmmc7LFE581du7iPme5pEQbFXHAeH0OXHCxCLn6Ipw5sq/L+SxoxDaZ/IJPGTcZnNqLBwcIiMeSW1zDd0WXDNRq00lyk/yUzeotMiuyqZXVlRwHarV8+pBdRjiBRpT/JACm1wQ+RZViNrXT/7ezZU2h7o8dHn5scqUINMO8OnmQNtYaJW1MSlq2ULKsjOAFWsl6h3PCGjPkE5wYaMXsK1QrigFWbzsSHCsocOgJ0zVja7dFf1RyodEGHpMzxmWI2Z/BzQpX30mcahz1apbbNCr9jn2W1F+gIgg1c47IFOdugW26k2x6bxDBczAj51zIapWsZQnuZcGksPbUw7E4wHQCutgfd4jbpy0nQGRrTa+qBzFnd+sUj9G541YVxVn3wc4fErPR4FQtRDKQzwP/a9wJoARH+fpyDq91NR45SgE6gzxW/KTY4lPabWiQbWYt8KfvDHvNL/4g3LfidPrgu+pXJ0N3dKRC5FbrZaRgWmiTMUbMy1p10aS3MZETDgwdTF6CUsvXBKh24LuV5cE5II9OwdTIe1U9ylXk++3e3ai3RzwnWZy61PFnj5uQGBnSjGW/+qVMHv0ReNShPlUSsNIRY8H1QzmQZuxKkOT
 VxK2orXa
 7HsQL8cDgKYEQJvPRRp3Dvxx+BgMvFA3z44/jY662XGF5vh4V1ziLv/k/iMmqbt5kx+LcUgu8Xgxs3M3uDqq15T4Gj0ds8hCdwL0P1vQBOj1qBJHkHLanQXr4mAVFgSoPHaGd5LeLtby3RUd4G26TMQTgyVjYoOPKfP3WBetzBQh6t14FP0Xs27EUox3iY5T60dECuYd+6c/bcNDsjftZY5nsDOAXp9YZtm4C7B8CVt7rz2qQvE4Z54FzwWdCFB1RNSkzx4Ltg2G7PT2QJ7vAR4dQMklB0XpQv1zzKcVTIZlF6fu1lzl4hGm5eSK8Te0Yo3hGgdKxrhH/XjVAvDANOx3MTStkTtI+6x3oZcRy7k5GbuHlo6BPZOhqNLiYeUay6GZAXS13ukFI11WvYUhQ3JT27SBYkeo4P8Shl07DP7FBmHUGP0cGmxNhugnscWEpTefqF7TipgZDTIVM0R1TH7sAbkhJU6HXcmwHUviHrEqck4OY2QtGAvor7FBDVfVwdmrRHMz4TUG8PNYVshRn9jihacLVkQCyf0j3L5xLbIKTTbQyuQOvC355ybGfBvhR8nPaS9l1doPG88xw+R3kSAkG2JqRvRVgDAw1aL90qeCwfd9mFRDckVxrT59RSxikt0dFBXXTQMIDiiykpMFg8LmA8gsOnRdGBIrPW+lEt39+lt/xyaZcl6F43vfZjS9q1nTj1leXtRHL3/qFYVKXnz2Q01Ki4K9dbm4ayozAWyB7HXxUAfr/I1cCtdXQESVATmoFhfc4qNBDQ7BPO0tDix984aU6RJdPFo+jUTFvZ2xoAHni9t7sYX5AT9JGsZvjiBnO4w69uKn2pL4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Trying this again as my mail client apparently messed this up:


NIT: Please don't capitalise 'Optimize' here.

I think Andrew fixed this for you actually in the repo though :P

On Thu, Jul 24, 2025 at 10:53:00AM +0530, Dev Jain wrote:
> Use PTE batching to batch process PTEs mapping the same large folio. An
> improvement is expected due to batching refcount-mapcount manipulation on
> the folios, and for arm64 which supports contig mappings, the number of
> TLB flushes is also reduced.
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/khugepaged.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index a55fb1dcd224..f23e943506bc 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -700,12 +700,15 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>  						spinlock_t *ptl,
>  						struct list_head *compound_pagelist)
>  {
> +	unsigned long end = address + HPAGE_PMD_SIZE;
>  	struct folio *src, *tmp;
> -	pte_t *_pte;
>  	pte_t pteval;
> +	pte_t *_pte;
> +	unsigned int nr_ptes;
>
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
> -	     _pte++, address += PAGE_SIZE) {
> +	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
> +	     address += nr_ptes * PAGE_SIZE) {
> +		nr_ptes = 1;
>  		pteval = ptep_get(_pte);
>  		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>  			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
> @@ -722,18 +725,26 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>  			struct page *src_page = pte_page(pteval);
>
>  			src = page_folio(src_page);
> -			if (!folio_test_large(src))
> +
> +			if (folio_test_large(src)) {
> +				unsigned int max_nr_ptes = (end - address) >> PAGE_SHIFT;
> +
> +				nr_ptes = folio_pte_batch(src, _pte, pteval, max_nr_ptes);
> +			} else {
>  				release_pte_folio(src);
> +			}
> +
>  			/*
>  			 * ptl mostly unnecessary, but preempt has to
>  			 * be disabled to update the per-cpu stats
>  			 * inside folio_remove_rmap_pte().
>  			 */
>  			spin_lock(ptl);
> -			ptep_clear(vma->vm_mm, address, _pte);
> -			folio_remove_rmap_pte(src, src_page, vma);
> +			clear_ptes(vma->vm_mm, address, _pte, nr_ptes);
> +			folio_remove_rmap_ptes(src, src_page, nr_ptes, vma);
>  			spin_unlock(ptl);
> -			free_folio_and_swap_cache(src);
> +			free_swap_cache(src);
> +			folio_put_refs(src, nr_ptes);

Hm one thing here though is the free_folio_and_swap_cache() does:

        free_swap_cache(folio);
        if (!is_huge_zero_folio(folio))
                folio_put(folio);

Whereas here you unconditionally reduce the reference count. Might this
cause issues with the shrinker version of the huge zero folio?

Should this be:

                        if (!is_huge_zero_folio(src))
                                folio_put_refs(src, nr_ptes);

Or do we otherwise avoid issues with this?


>  		}
>  	}
>
> --
> 2.30.2
>

