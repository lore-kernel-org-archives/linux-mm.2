Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A9AC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 08:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731DE90004A; Wed, 13 Aug 2025 04:20:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709B2900044; Wed, 13 Aug 2025 04:20:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1D190004A; Wed, 13 Aug 2025 04:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3D2900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:20:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 25C8E1353AD
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:20:14 +0000 (UTC)
X-FDA: 83771036748.07.7855068
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id D0476140002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:20:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Y4EITF7S;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="lKdz/+Pl";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755073210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2bm/Gki9DzSvT+MYGBcgUS9qAtU6ei7j7WV4vDAq27s=;
	b=XktLZISX7p5w8cX1CfCW2zo2zz18WeAJfyNs6MqNS20DgSJ/L5hr9X4KmnpuU/6t4vQ9Wc
	jLmUeJq/gu213MGDHQ5VlPzJeLm6HHStckANHwo2JXERr+rKX6N9kQLlTRcHk6bp1CdgtI
	dyiG7h3N103vDEmb+6hpW0hzxxx/f1w=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Y4EITF7S;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="lKdz/+Pl";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755073210; a=rsa-sha256;
	cv=pass;
	b=ZvEjbvXo4Rk1JtW2BumR8vcWguGBdiG2h9MzbfQo5HrbvzKfNZlY+DYn7Oln23vJKJsA8b
	s4X3SDfbw0rumxYcWr9QHcx/+uWdZP+IPS2Gx0LmBDyDysCLsle22NYINhq101I8UniX28
	KDgVhc2ovsfM3Dd65WEtjWd+ot/Mc5E=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57D6u3Rx008497;
	Wed, 13 Aug 2025 08:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2bm/Gki9DzSvT+MYGB
	cgUS9qAtU6ei7j7WV4vDAq27s=; b=Y4EITF7SmxAV58Jusw4QgelpU8ro+NJMVG
	3RXZ4ygkOhUe+FBXeL4oo5YTrPc5rTqUbnVfCLsDmSDsF8iFsxc3hgamZiAFuFZS
	vYMpVb2bj3gDh1SVkB9ln6vHKCu9yUUoyzbJx/0gGuoj4a7KJs4V4LT7B9WULer5
	uDaIm07Ew5PqtOwqcYjhHYSQg1PlJl5bqi6WbpK67qggQk29mGXSsNWFED/NCpsL
	CTyKJxF4dhN/aDmac/bCoGFw5feDf7/u+ujP30Hw+or8MFuWN6p6pwPDcf2Go3ew
	JuNVdY79ai8BwQjJNMfobiEpG8DYmozdNTKhDqSK6dBZBpgY2yLQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw44xtnq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 08:20:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57D746r8017390;
	Wed, 13 Aug 2025 08:20:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsb3b88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 08:20:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uoJ9zIDaO7fBwkSBgFjgogIwgWSCKDJgILAPKj+2XAfYNeMak3KvUylO3b1cJk76ZshSHN8Xvd7T8DkzGMSb5KnLu8IxcF1xNXnV6qtQlELyETH21ZAuWq3GzeiF6hTTibosy9YT0u6DIEnSlvSgK6B5fJ83qA60HbHv5S8pcuJ0ElPtD8gT2iNhAcamvyHMYEMX4APIO4kE49LrseLhQbcSrQxltnMw2sz6SAKsJTTbt48YuCx+lM88mQy1uzZoUuLSiJB1S9MkeRRpaucOMzrP9RuvV3T7dCah+LaUYzEuv+Sdx/UZF8WaWIpeR+OuhpYFLXlLZQqf9+Yvf4JdmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2bm/Gki9DzSvT+MYGBcgUS9qAtU6ei7j7WV4vDAq27s=;
 b=JDLs0wOyslS9nwKx9uU4DMOBVUDlRZ2cN6Pd3NzDGZx5gx4RuZ+JnoFg68ldxD4oou+smTe4vqC5tnH4bR9LGrJGaPgPZRn2wECHRlyh9FcWAkW/dalb06yGGJkByQyAc9xh17nquX76rjNQKZKuRBbwZKM1aN6hhdtInKb5LrKoNJZSVsEAYSzFfXDK3isCd4KJWahW7/PnX3e0lJhASyd1PzKBIAT7+w/t05KUAJlZk9i3UqxMhzGe6VXQIejWswWusSwwCKNsEc+Ahu1LqKMIBiyXWgvMZJpknP8TN0ZMwDZXHx1XL9aBx6rEzDGqN2DeoyYxl0lwhgvsm4DfQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bm/Gki9DzSvT+MYGBcgUS9qAtU6ei7j7WV4vDAq27s=;
 b=lKdz/+PlwOreEOvyZ/c5iMGwk7jI4KczQEh7zj/ZNaG5D5mJ1ZQTi8LH75ggtsQFiruNXbog+7jM321GqJFKSWykvDaGux54Q3idCMTuCjjJeKgY5DRQ+KyYArelwbhRPyh8mjBJAaCH41SdUtFPly+hU8rhUxTbF56E3EyPxPE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB4946.namprd10.prod.outlook.com (2603:10b6:208:323::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Wed, 13 Aug
 2025 08:20:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 08:19:57 +0000
Date: Wed, 13 Aug 2025 09:19:54 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] selftests/mm: Fix spelling mistake "mrmeap" ->
 "mremap"
Message-ID: <3caf3621-c1f9-42d2-9004-7e8660285630@lucifer.local>
References: <20250813081333.1978096-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813081333.1978096-1-colin.i.king@gmail.com>
X-ClientProxiedBy: AS4P189CA0013.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB4946:EE_
X-MS-Office365-Filtering-Correlation-Id: 252b3342-71bf-424d-2470-08ddda4230d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FIpIjkWK35lDbRQrTSfpPv+i2t9Kwi316czQtH2QKasoxpX242MfF1NILQWO?=
 =?us-ascii?Q?ynFYBS/+eXe5cNowon9FOpLhbBdSSHLA0GGnYX/eDwjnQJE/ZLmAzB0n04EA?=
 =?us-ascii?Q?V19S99hu6NcW+n1QyJwwtahQxp+Cpx964yPsBNiiQRXnntP5irf3VAN00IBf?=
 =?us-ascii?Q?9GHmXrK4kbgDGcbAy9GACD+dQU4kuJ1Fg30Aws4CuK4fKMiBuXNQZu3gCHjN?=
 =?us-ascii?Q?ydBo0Nb+39R3tUjbBZAUqw1gww4ZMfuJgo6j5dsOhB6AxJCx9dI3t0CHIS3F?=
 =?us-ascii?Q?7tq2cyCjqj2h82KyR04DbppkrKhey38ReMZx6hHWVOF7/qtZyq10OCdFn9ku?=
 =?us-ascii?Q?baNeOd2RIAVFWlBS9GbDzWqeBlug15S2KLe/dOFN7Jq4peGiKVvzDtUAgD22?=
 =?us-ascii?Q?si+72yOQHA3H9yiZhoWwkMC3ug3O4LrFppVstD41zuQ3lzWvADf8L8HOA1cQ?=
 =?us-ascii?Q?aalRrlsDk2HKySC9dinZ9mclp+uxIqGVy3i34N5tSo87dMyP99ygTffBnsng?=
 =?us-ascii?Q?ISjXZ39pNSlo69C3iAXRYU8ArFwBcedFTqa4hT0ih/Y2YGlnKjlN75THk2lH?=
 =?us-ascii?Q?+S3RMBBYEl4vKJhUb76/iv8ayw9r6VAr9gb1B02n1PWH7M2utOt2H+OcYG4M?=
 =?us-ascii?Q?kyq0II9OFye2CeeRj7uAFmdVPyL36i1S1l/c5TNqraXX45HI4LVmiU9tZbZn?=
 =?us-ascii?Q?0Tfk+K2MSdfu1fOjLuY131whVDfGh/r/qP+spXu1FsOKozCjqc8H1Zk02jWo?=
 =?us-ascii?Q?vvQkPVVssJf1lirNQNewU6uhxclm7kwd48tpcmELiWZTDCAh6Dbt8AH8nGZk?=
 =?us-ascii?Q?ftO87Tdsl5KjS5L7bHmk4MKMxnYEmgEppzqM7beIGDcCqTRdYXTyZ94VGUAx?=
 =?us-ascii?Q?d5SvJDSOXObq55h9e3d5q1RCmZw/Nc5wtPBGRsJvb7VWKpq2dM68xj565/2m?=
 =?us-ascii?Q?+JXgy2883g5VsbT4ddme0PNppkuT6B2fpqlN5kkCXYyQCjxkM4L8rfat3iGb?=
 =?us-ascii?Q?L6DLoYy6W91sGMNfGOWsWocs3o2L1la18CpzKhWhkTlAP7LFk4BDbUlidtr3?=
 =?us-ascii?Q?OxmFs0Ywiuc5DSX5/Q4IfZ9wh4Z/XoJvdxlPXuLnyxzLWJHZ7ryg3y38hdw/?=
 =?us-ascii?Q?YQaJHXhiP9Iyt7O0JgM+exRtc3qCAa8OrcJ+cRZ7th7axJds2HJXl8RdOolC?=
 =?us-ascii?Q?e+N/RX3LTAOCPcoHL0yZrcEmn+zHOcQ1hQyT8sj1avjaIdf6xYdEo0fLUmeo?=
 =?us-ascii?Q?9+tCget3yJT5JWzEssXj3rZoMIF1w/NJr0GCg92cTQxsaXuzkaC5CGf+ZtMP?=
 =?us-ascii?Q?8atmOU0kO0OiNEiICi8BUCswmPpxR6U9TK/uOhy/NHHw1W3jrzXYQzZW+9Rj?=
 =?us-ascii?Q?eCo6rxxeHlTkERvlKD40zobSd9kUNc29Xd+DCmNiwF1GcBGIJF4Qb6Qjs38i?=
 =?us-ascii?Q?bLTXAYULS1k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cWAPLOXDWwDaW4TS5o29jJFkL5EoTCm7tu1kFZo4SzGyOmzvT8/iRfqZUsAe?=
 =?us-ascii?Q?QBO7iV0BOjor+8t6oHdw2k+/UoXP/u64JZIfPIGVrw2W2KkXX1qDbQzyJR9l?=
 =?us-ascii?Q?3l5QG4ZBc6qpR46opW7g55ukMnaWOli5Vb8YEII4w9ZPGmCekp4nkZdKMYKK?=
 =?us-ascii?Q?IMvr4VBcoxWAwSN6bPFonlLiRLJ0INu8xj8NpM/yIV4TRf38jyC7gRaPcpqk?=
 =?us-ascii?Q?/4tLf0JIdqxnYDHCOVgsa53HwvnV0b7KJRqQbhMVUvfSKudeS3nhHEfpe8zI?=
 =?us-ascii?Q?AqCUNlQRpELgiPvblV6+FMcm56ecxzSfsgux9pliXanMxfWbUHrC7dVCm1/C?=
 =?us-ascii?Q?74+UQavedrDMVMI1BuOJfUzq9qW62yp306ExSkkcd65XTPd74OtXTdbW9Q0v?=
 =?us-ascii?Q?5SiwLxoThhMvedbgMvkMr+qNxcAgOMFdRYb+jd4jzORefyDQkn/jq8tPQYoH?=
 =?us-ascii?Q?K4JXKI2o9eVbPaKXKasnjQlWL/BauDi48xKIKWmmGbw109NWHZumkQa+sgha?=
 =?us-ascii?Q?HHCgDdI7TGC9lKwq6ASYAbSxIfDKbMYtQivK1F5um1jM+wgqWuedkCDpfuPM?=
 =?us-ascii?Q?jykBE0gFfAJnB7CwxwDzU5Tq6Z9yozFrEJbdzqyMMXXWLE8VRzZuod1GRz+6?=
 =?us-ascii?Q?K23TcQb1lni/aOtHVTBjuNKvqOZCaV9zE+CVQ15YVmLzW/8gbj4KHq4DgBFv?=
 =?us-ascii?Q?gytxhvxO7tKktfWXGZA/JAcnyCQnTVPhMDmzCSaqKVyCxTp6smRAlxHx2LLO?=
 =?us-ascii?Q?OQ/HfCkEByrb51gBPCE2yfoGgGDUYQUTt0J919DfOphOUmKoyvhUBuj2ln4M?=
 =?us-ascii?Q?I3XiWAWMH27hmU6RmtVj2IN0p9jA2if2WCml9MvkuYZxP4M16WdsXV5WuoMP?=
 =?us-ascii?Q?PT+FSJvuwoBafeWaGso2rs2iWNc4JTuimNJpUVwvdf6KYy4jRfsU7dyDiPcq?=
 =?us-ascii?Q?oLqywyayHn/24IZDsbEsk4OG87qBJnrPMU1Ku90W6052o91/uqe4yi8cq3YG?=
 =?us-ascii?Q?gTKWhWiM+2MaenLCFyLmXmjzWRbXF4yi/vnuxPb63XMjfDm7Yhnk8/WCxgqA?=
 =?us-ascii?Q?ZqvyfSl3krT3U325rjLEs08U8tRLXdPM1YYj3IY5XUWA9/JJEvfMoxc30VCS?=
 =?us-ascii?Q?8wtOq/ON66fZLgW97Q0mQWyGYghckqCGH3YzXtAeab61UR+BqgDR/ul5Tiqn?=
 =?us-ascii?Q?tt8uYwj3lsbIcv868aUneLw95wnQIwlx7qWl2rDLzV2Fq7dwfR0MkITL+E5P?=
 =?us-ascii?Q?iWU7OUrxHOrTs+aALSOOdvzQT3YNpSF9gv+HF+lrkeyukFWpcFvFuiIVRMJU?=
 =?us-ascii?Q?Q4C/QI/r49zMu0Z9Covwascgl9+Il5oY1yRbKNisBtIyXK6+3TiNeX+qvMF3?=
 =?us-ascii?Q?Z2uQIHQHI+0gvFlxGBjcfj7IKO1qnrqJ1xjKuO6dED+jNyhRIVDczXogCWcj?=
 =?us-ascii?Q?uptEsqBPxQrxKIR1umcf0Ffqh9DvtBT2mbKI19rwTYqzxPZWWaTG3wMctHVy?=
 =?us-ascii?Q?OBTgg37GqC8WvZY0fP+gihSpEuRk/FI4Rmq7S5CClYZti9brwvhWWgsny9s2?=
 =?us-ascii?Q?bjeyobpOmNu7YF82ekA4UYJVyLfWHIWb+bVaMWaCr5hrzeV7cseWTXpT3Rew?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kdtUZgYr6m3Rw5SOSYm7JIuScWVu/1E4Z8g0FMJ9k/CuNSdZTsgvXcNtNe/pTUyilX6M8rDH3AGrWT6Qo9Knic9DYL+mPLY7hAxS85FptlxSbFIRbxtxt8u4MtMNO9dcqzY2tEA+dp7z6fBUI/setyeYkIrT/FNQH2N76FIlGYavtzPlzYqCPxKvFTla/iYFpQnTbN1hX6QZH3x+Ul+bzw/4syAfd7PtJnC3FAXIAAVAh1sDVipWEeWZiwaY2eHeEd39dGH9BS3APXUZxAW6EjzMkN4Fih738xTeScP53OkhTrZy2kwvXg7QjGkeGAboywfVy1kugCj874muVOuToOuCKk98f31noI3UR2jnHz1xJ0ebNK9an91hsQKjfWRvzTfi8r0ChMXhgwrNx6hDGLIR87hFbYxnJ4NMOJVkVpvNjXzHvlpaQ9tvVtGaK9CgxTaE3uvHu7NI4k7GsEyUMpNkqz/MGAeYczMjusmrmb1GNP7kaBsM6QKdwZygEaVN5nZHy5YDK7GWAvC/v1vG7dQVe/COs+vP1Acg61kQGsWcmgWMEkfFdqRJN6KwkK5hvJECUD2vHipmwmURjCuqicW20KULPC5a9tx0KHafPb0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 252b3342-71bf-424d-2470-08ddda4230d0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 08:19:57.8758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VmM0/hOqo0HQ8TV5J+VqoUbwziz0eMnwMo0184QKNDKiUa/NDF9Q+KiPCXFk5dV1VdZl2vR44ANeo34oP/50aFqL+vuiq6OT92KtPmnS5oc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4946
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508130080
X-Proofpoint-ORIG-GUID: oINfwoNCEb030gw_VOF6y-D9WeTHOpn6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDA3OSBTYWx0ZWRfX+V+5LwXi3k3G
 f8J5GyhToHIlt4XeKR7uOly6SMXD4Ih/P1HBigRBXU73cJRpcEqwOjg6jgSkP9aQFEwYrK0Y/cr
 Zr9c4oXm+82hjGx5+vTweKCz7SbUiTAu3z7vEBry77/dUES0voi0bBjXJWMCYOHK1Yd+g0ROJs5
 0LjdFoxmPIeCGNyXImnK0LNhRjpQlm2KqInMrVQnARBOBOEo1Hyu5sBGgBwRy8y1Ew/SJKmtXwQ
 uH3ljJfzFDnOqxCUZKTtJcX+BGSiY7ugJJgar3t3nn2K3SCaxKrqrcNDxpMCCSHfckGYrIA+jL7
 oV/LB43cejZXXszeD8I2ytAzqD0ezg6HcZGvLw1BZTOyi1nRl6kAzLU/DQ7AGEM3Iypv5ymOXsp
 brLekZWAqHEbVqQBPiX6sa02259k6yIuo/nrQS/vpxQmfypBsU2tUrSQuycoLyI7AVBSfDpP
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=689c4ab6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8
 a=C3DKd7Il3PkriANctBEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: oINfwoNCEb030gw_VOF6y-D9WeTHOpn6
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0476140002
X-Stat-Signature: drcfi7w68ondk61ytxph6pa3rrc4m5g3
X-Rspam-User: 
X-HE-Tag: 1755073210-135753
X-HE-Meta: U2FsdGVkX1/zaz4NfyUt6EMUaB8nU1cNeFCacqAw7QtxWgYSyxx922nrOJiNZd7SdjUbhZlyDHiE5lLA2K2L9pqWGZKFjnwmUmvdzd4et4J86k13qXIGFdDpoSBw6aiPfso76yu3ICUnukbPZ0dmhwe5Z3j3zOghIubUcKgHNisJt2m+PBz3Bsb6FVjDI98Gw1JGhQ9S33DfRia9KDcqsGN+HkijrctETvMW29kOu3m3IeczLPxk4LhYQCgaBHEsoNwfOklUoa+euJKPk7VYlUzo1bPmT1G9O503z9dUHahgOV3yrBEy6OHC6fbEP3d0iIP0PqE3iuQmDeSm/u1s1lZfE9Nx7TmkLqQIkIv7Ab4Zd0IxsrHwBF4tb3sXH7QqhwTE7c5qxfFO37NjMuMAO1nlCxl+efUzGV6SL4VG6Lxq+ACNQIUd2KVg8eZ6w+6YNPXgGLw0soFpwyE7izIeaf2OCFChK8pMoGZv1akv4uvskM6NaKDkmnHTtQkp0crQTxAzyB//1OgRAge7baZniJy+NdO8l2Ls4QeZjM3HTk3jZrOFpXuzR1IGMRIAyDN0yGC9AkFS+5jG7kNp1FQZEgjpkaDw18KvcPmZer2E3dmk4T7qJw5ymhhYQJKB4ldatmsu9I7uXrRFKxteEVtAEzRymbkK0Qk4VkmV4954uv2aPkB7fHylEZj9rBnWEW7qLm3dbQHJ0dVLE3LJeAfQ8aYh5WCoPo6Fv5DUx8LYuan2/tHBT3Cj7davIDZDtJbzK2CtRZsAGrh3OOnsD+BzKRXKmvLSSF5CvRr+lHbS+Xk7rovNBXJjxIAmDOi1Ogd2JEnrBJ7FkfU5Zgo/JKXTG5I5ogBi56OKhnObh5V1H2lcDXY9ZUZQznC0Jy3J+trq7ZRRztIo0Kt9TSClxd2+hdfH5VmVhWGCU79wPCzrZ19Y4+GuGjmQepihhFc8yD9R3Pic8Zi5p65Jky8Y5Cu
 CMM2Kf1z
 ryjevPqtO3tRQ5X0JJfCoYV5HLy3TL6ycqEiTVrTFSvDOBUZync73rZwbcZlYvD8mRgXsVuCHd+MonC5x59RSy3RfS5Tu2sKu3BbHYEeHuaW19XFsn4JulmCkbKCJYLB+DIRIx+wdK7AIxJesI47tXjwnE14WMPmeKaQUjWzcARdB5hEq1VnnDqVLYVkVL1BRLtLFXoaOIWZdE0+bCaPdCyr0KJ/IC53s3sJBVqw1FRyI4VIgc0bQerZel3ckYvZKLJqF6fXdBIoPbtwODyRbBpfS//TwiDQ8WsVztE3wYJPPwY9dc9rp9U8KL6p56Rm3ya3U8F74fgPCF2DQtNKrOY3RH+vtNcLAGXr6wynM53mmtviQF9GZ2+Sk4pZiHWkB7vr0d5thwswp9QMcGaZz4OTBBdADdJAnJskmVsd4yQz1rMXSnjjXtQRY96v+09y5QQ961GzJC1R+aM/7rq03OtyTc9/kmvFf+pXp7HQXD9cKvj2DZUs9g2PWZWb4Jg9km7+klnxQ9TpZYPn84xpVQmZUtRH/1D9N5C56p0x8sD+RjyxxGEbJRwT9wXv0N8ihiPlT3lnswdGgAKjX3GCoDtkU0k6B6EvOL6HAqASfn1Js+K06aKw6drsOTxOZjwdoPNdNDn4MSbwCq58Jml12sXSVwox8YNaa5YfHodg0D0KVEPKYA6dqi5Mn80wc0ZuBbhbZVEMPMKbMSolf5Iv5tzjbG3WQLh33aiaxBqwrdwSszv4ovFMF+nCoaAGHV/G0vEg6G+t2fhhxRg4ikRj0kn2AUnbhURAByVGUBwquiCb2e3CvBivbwXR0Fcj5m5DV8jI1B2KNSigsSmA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 09:13:33AM +0100, Colin Ian King wrote:
> There are spelling mistakes in perror message. Fix these.
>
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Thanks for this! LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> V2: fix typo fixes, I need more coffee

:)

> ---
>  tools/testing/selftests/mm/mremap_test.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
> index 5bd52a951cbd..e289bb1112db 100644
> --- a/tools/testing/selftests/mm/mremap_test.c
> +++ b/tools/testing/selftests/mm/mremap_test.c
> @@ -846,7 +846,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
>  	}
>  	if (err != EFAULT) {
>  		errno = err;
> -		perror("mrmeap() unexpected error");
> +		perror("mremap() unexpected error");
>  		success = false;
>  		goto out_unmap;
>  	}
> @@ -899,7 +899,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
>  	}
>  	if (err != EFAULT) {
>  		errno = err;
> -		perror("mrmeap() unexpected error");
> +		perror("mremap() unexpected error");
>  		success = false;
>  		goto out_unmap;
>  	}
> @@ -948,7 +948,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
>  	}
>  	if (err != EFAULT) {
>  		errno = err;
> -		perror("mrmeap() unexpected error");
> +		perror("mremap() unexpected error");
>  		success = false;
>  		goto out_unmap;
>  	}
> --
> 2.50.1
>

