Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5988ECAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 06:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 746398E0005; Thu, 25 Sep 2025 02:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71D9D8E0001; Thu, 25 Sep 2025 02:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60BED8E0005; Thu, 25 Sep 2025 02:08:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3A18E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:08:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7191B84CB
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:08:54 +0000 (UTC)
X-FDA: 83926744188.18.28289DE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6809AC0004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:08:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ICLnbHD3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BzvbKA7Z;
	spf=pass (imf28.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758780531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lfF35HRmbou2TZimndmcLbXiJpEMt2atxgXir7pYMig=;
	b=ytBxXk8r1VQ6jjrH7eHdwaNfIA8XzZedKD++UjrXdW/KhMJywNF8Zz+kpk0l29M3WVIWjW
	kbcCA+QEDCUDpFKon9gJH0ty6Z4Z6do44C59A12NjBkkjyvr/0yMMf0SEf3AISWieI2a6Z
	eloOJoKyjah1rNJZW433wNPKq9DOgos=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ICLnbHD3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BzvbKA7Z;
	spf=pass (imf28.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758780531; a=rsa-sha256;
	cv=pass;
	b=5Z6reSe8LY/F95S8YWsO+5K2+o+dth+8cpbhahrO+A0Jlt3BfX8NlH1bQsyPEy6kPkyTzl
	FvKMy7ds73BjbWEOsc/qIgEP5k+Hhw6aJeKY7NeMh90GYwl7g0TWNAvMFlcJ/AGkPSLWwl
	ok2e1aLHYLM5ay+JVSgxebuCtXqe8Qc=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58P4C604013868;
	Thu, 25 Sep 2025 06:08:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lfF35HRmbou2TZimnd
	mcLbXiJpEMt2atxgXir7pYMig=; b=ICLnbHD3h4yUXwMYRg+wUpxSh2AldJZyhi
	jVw1wyjdkhiS3nVakbCO2YBwKpOQu2i3kkCO2gTywJWLAiyA9ICCsUKpe+wcLFW5
	Kvg3SiQwC7FvJFwLv7D+ivomQhatJvQz8wMOEgyU7yGyy3tOwgx0uX50CxZX9lD7
	NGR1H6F7/B2bN+SJSpsTITeZUjNrE0WbMFLrK4hHS1zFFTv2kJqmJcRzEHBXo7LA
	ETMqNzeEgjb7VDe2Wcb8jaEWIpsH+hpR/xZJKqo11+Zyjyok3HvVUuHs29pmLy3l
	F02LnTO8TtvmoHCL/d8iNJgEfENu3p/sJaqZCShUkacP8IfA+wrw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499jv19cu4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 06:08:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58P63aLk040919;
	Thu, 25 Sep 2025 06:08:32 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011025.outbound.protection.outlook.com [52.101.57.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 499jqak0x7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 06:08:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rNq8YVbqWCHgaASBUenYF/JfXjfgJiUfD4tfUIk5+HZkxy6eU77vdlrONLPa3Shm5jm9KwmPI7GrrEiPNyoqwnRGWUrGD1LF2zP8uorlTmN/6OjNF3KvOEILJ4VeeYnsziqTQ9KoUamKZN/HAIBW5oqRjiQsharEiSFfITNU9GsPYoKkcshWH9MWhZRIgJo2EcSW4PeEzTk3MBLaZmr51edJr8OFvgjrvTjdMzHMqagAQB2+VOukg1bvFEAkbmmJ5ipISU3WOI3pUFQ0ZkY80gT2snKmMjGFx0jn0MARHy/jOJDMQTyc2bKZOH/DQmf5aYpT4LzIX9b9MRtoKDHS9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfF35HRmbou2TZimndmcLbXiJpEMt2atxgXir7pYMig=;
 b=KhhL0vbjGC74FJCiKI9keBzJJMGs7755iFdzYeOCPk00yenpoUe6BED5br16YV7gJhKffVMhjrcctcMy0khvTnuyA5lzu5o4r93omHludXux+WT+yxQpnvJzZBs4AESW2W9E0dh68WctwNWdbOreb2a5+D+pEzbtl7NigUWK/ZGFRkCd4FsZbkIV9UbbLAtKx0BqtivhZcU94bFjVbP2Y7sbgvQqZAPnc9wQyxzdQQBs+9NQ9kWdJtU96zBJNDofNhM5C+jOYRNHZ4ER0LA6ut/K740OW4B51wGpewkVNfOm1koWWsx8oikp0C/bFjL6o9HNAIN5aFVjUQgu96B1WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfF35HRmbou2TZimndmcLbXiJpEMt2atxgXir7pYMig=;
 b=BzvbKA7ZCbGPfq3PBNkmOjcSDMpCDtaCD0ZkJFt11GrQa4Yot+EALJq2LfgbgVCpw3jIHK0eF7UYNR0qjzHq9s592PJuGKfeYQBLud13ry6yxIKC4xAiZ/zyJPi76q4PjQllsQJEN4CIQCLE8YQEUXXAB5AOS2XOkYYLmMIdMQk=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SN7PR10MB6522.namprd10.prod.outlook.com (2603:10b6:806:2a5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Thu, 25 Sep
 2025 06:08:19 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 06:08:19 +0000
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-13-ankur.a.arora@oracle.com>
 <d2dca02c-ec5a-4b3d-92fe-2b3a3614b5df@redhat.com>
 <87jz1obyd7.fsf@oracle.com>
 <d03dd7ab-5237-4de6-8872-a8ae2e9b7c5d@redhat.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v7 12/16] arm: mm: define clear_user_highpages()
In-reply-to: <d03dd7ab-5237-4de6-8872-a8ae2e9b7c5d@redhat.com>
Date: Wed, 24 Sep 2025 23:08:17 -0700
Message-ID: <87segb9i9a.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0282.namprd04.prod.outlook.com
 (2603:10b6:303:89::17) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SN7PR10MB6522:EE_
X-MS-Office365-Filtering-Correlation-Id: c19a23ac-1055-467d-85c6-08ddfbf9ec65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XWdu6EoWCBHtFLPNY7kWZ2wk8fytRr4SRdQQnbRZV6kcS6aKZEkATi4oxjXu?=
 =?us-ascii?Q?NtZLtUiRxGDtB82T9gxdu6ZBhHN0dGKVWuOpdlOUg/BXKvP+hhBqg5BhbngD?=
 =?us-ascii?Q?y36SyLkR3Z2uGyAGLfKseHRCFLj90o4Q3Y/HCVJuXsJtSrdiDiUApQoCI6U3?=
 =?us-ascii?Q?CDOasRKKjDF03CCJMXXjTpJ1rS0fwlnjpqq5P+t7tZQoLrJaV14iLf5nKlzJ?=
 =?us-ascii?Q?/iqX4N1K6v0atf84IFQceWib3WSVfTAmb/WMG1+bZLIeM5enKiX/GDjGIi0u?=
 =?us-ascii?Q?sHIZo7I8UlpuLXUWD4M/QPDtx3QmapAvugegoX4sppJqGUq5l95hgCW4wG1x?=
 =?us-ascii?Q?eJiXMH4/OH+3hv99BRW2zcnIlsB9ptwHQYR5vU8lG3GGqdBuF9EDfYIdYP8H?=
 =?us-ascii?Q?nTf130rIfgKRr74QN49TkjzPtfz+SJ/77e4BanjLHzeXusmkVdPsoBV+Fszz?=
 =?us-ascii?Q?NCtyIOGxI50uRyrSwfa9ODZkgzS+hWHwUBunQoHpa6i+kbl1kN0nyqBSJLqG?=
 =?us-ascii?Q?WWu/p0SkTd+3Ce/8W7yhq3Lm7MJ79R7W58FB1gAOVpnMMHm2viIELuSuhuiZ?=
 =?us-ascii?Q?djo7j05DMC2rdTcHkkmEKSgVoaWI/sPqguzYfFXUzkybO2xIl01Y/jVLp5vq?=
 =?us-ascii?Q?SyYGYLq4ipHL4UEae093j1VZGoupcyrLSMxQoLmKej/QC4JyODmrO9S/MGjz?=
 =?us-ascii?Q?Im0RRfCXyMtI6VFKvR/lKOXG6QwTMHCmqlxWN5UuUJWZDP992fTYi6xcJLpf?=
 =?us-ascii?Q?thWawSmiduLS4RH1dN58Tys8O+5aQPMLezKD23EPIq7VXPZkFg/7uy1wsQfv?=
 =?us-ascii?Q?iuVIzYTRQKvjxs6Ap0BBmCIaCjI9AeXvotXFWZLpw9/7/Q1c3hb30a32V0rv?=
 =?us-ascii?Q?bIApMl+ZMVPo3ZkxxU26qy2hXi5hMgpxVVO8pCbAPmacU+hIJoKLppHtaeyd?=
 =?us-ascii?Q?T8tmDnxVFUuNlaPJ0wwDQnRbhuovq7lSZp5fWtRXcaF9LaHgqOqLiQqh2P3y?=
 =?us-ascii?Q?lH52tLt7SS/YuErkdx2e5o7rn+hnnxQIppNqhyHOypsmdL8ob0N1Q7DlSSJH?=
 =?us-ascii?Q?gULEmMYOi8T0R0iZcU6UiMbMmhAO2Kb91NYpdM8juQqPIJZQJj5guaBo/NGR?=
 =?us-ascii?Q?GjBLaS9NMIR9CbUqDzfEq9SICfd1M6/5+MquD4kC3d9+9EpJz8zzkMu99hRF?=
 =?us-ascii?Q?HtQXUKrNGFDHDOKevAp7c9qAQKjGCRsd6DmaLlY//N+k2To1U1fNDsodZkqE?=
 =?us-ascii?Q?pl4zuX6tH0mlGmo4h0NZziU1epVU/fFd2kG25aZXSvySb1e94Pw5R/DMUVqa?=
 =?us-ascii?Q?ULKqDVVgzmT30wsMlRpu0CuCShWof77FRnaijXcpD+/Y7YlKMH6PtgxKGa+P?=
 =?us-ascii?Q?6TJiAo0hUAUNTK9c/Qj7GVnNa/aT+FyFpD+A6GVSrDGv9im24uQgN6gDp5bK?=
 =?us-ascii?Q?+aF2bLQ8Jdg3+vojfVBM4aUmNdKzMPM4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NY76CQ9riNgKfCG7RiuVvdRxkxDhtxKEkm/ugFA05q2PnZOOsDewQR4ioLqd?=
 =?us-ascii?Q?R1zCQjBav1E5VdFvHebxLZEmub6tDaTLJ2cjGiLU29ap3SIItlaS2AuZCtzs?=
 =?us-ascii?Q?ZUArOYTi2rNkP1D07gqmdl9pH/9Jfe7LF/OXtVSBA0paq/9vuJPzy8w/HLmE?=
 =?us-ascii?Q?OFvqMGNY4IzWv7GXOvWoij76Qcp9jvq0cMyVWr3fduay0OloPrugO/prTWnJ?=
 =?us-ascii?Q?+oa2J3o2LtQL0l7U3y5U5kbNLPswe4acta+Cj2tcKntrzAnG3lZ3/wu13cxa?=
 =?us-ascii?Q?ksZTvQET4Fo5azaUHzjn+NZOSHvizl9h0mdJX+1TLEDCx1YpBqcwYF4Dcjer?=
 =?us-ascii?Q?nfN+run0pTEiKIEMY62rHWNOmA/0ZZfT7bP13Bou1Jx1XFl++wX5Y2nTPe41?=
 =?us-ascii?Q?NlWtzzJLsu/I3DtelexE0maIvv9/1MvqYcNBY8c01u9/4wm5kK6A8iehLp+v?=
 =?us-ascii?Q?hK7dyqee8kK50kUGKXdsUHEDNG0YMp984M+57azTt7JfQvF9SoLttD8JqK59?=
 =?us-ascii?Q?OE4jlJTpdWbLjHmFwg8BgoFDGVApjK2E71SCLiATRd/FE2Nn1h2HdQja8Pdf?=
 =?us-ascii?Q?gUUobYoij1MVsZ9W3Kh1zvJ+Df/h6CactDBAYjN3V8ySfahah8mLuhXoroBx?=
 =?us-ascii?Q?uvaWDwP636vxbiIutKvoIjhCzQ8RAlb24lQAA/a9uVahBZIcNbEWq9DZRSct?=
 =?us-ascii?Q?pn7J+E2T5GXJdYqktjf7glKUNUQjf9pK3endlOaw+vq+OdYYofmQdjzCLbig?=
 =?us-ascii?Q?gMXpaejdrlp7YMeV36p/yVBd+5sKl31mazIl1uqphKNR85b20ihjEyUyirwq?=
 =?us-ascii?Q?a24TjMF/cKYh+DtpXexy37zj9ZTUgsIBIAJkgeCWUgy6DCwVxiEYotBmWmGN?=
 =?us-ascii?Q?ng2acONgMHVnJXLBLvo1XI8H92V14sLfyUpVpqgevciJL2Sqtu08ZAFh8Qqd?=
 =?us-ascii?Q?xmBIKJQ68FAwtmPEJXo8RBm1bckGsvple7rBJT5sAsKFmm8/wzlJCEtsCqPm?=
 =?us-ascii?Q?7XzmlrcwilkxYqn9HNzwegC4uaZdFEjvdwlWH1RdDrCqjxK2Yf3Dq6ftrWFr?=
 =?us-ascii?Q?o0NWGxeOY7jwoNE32zanrcWJIX6jq/IWfSoNbHdS1qLbw1hRx82lhMpnGvUC?=
 =?us-ascii?Q?9GLkOzgDSRRmYxe1CRJyapP+UCOOczxQBDG0wn5tf1/tEOkEijXmk9Ws5l4P?=
 =?us-ascii?Q?Q4CZ9so21pqPVrrfDx1N2YxlSLr9zT9s7Zva4Fhnwm2CWrYdwYmtZfQC69Xk?=
 =?us-ascii?Q?qhQrF9dbTyG9nFVU8YJNOdFpDlM14gHgWG3NtASEzFoy+YUnR450a3NxTyf5?=
 =?us-ascii?Q?lNEZD7V/bQyjBFjMUkbiT79V9JVRnCe2u/nfmjAGHnO90NoRT7RhAl6OnCds?=
 =?us-ascii?Q?Xp9R7I55OW9QXlGB3XM8dGzFkBvQ1d8xkXB/M5QDRjx866aqx/WMPwgmpK5e?=
 =?us-ascii?Q?+Pec9THijQ8sBBsv+8YB6phzqA8029S0eYfM/xaL2ZY9WNwpoOsJFPj3Wlpt?=
 =?us-ascii?Q?u+tRxFEvFLrX5azocaVqjWl5sYXCGLly1HcKNOFITxs2k8Fi6AZMCE2fEaKa?=
 =?us-ascii?Q?hZ10OD2fsd8OzVYNEI1FlvSLPFaAkvAIMv1cZYFwgjiqzo8Y5rC4i+bnVGhe?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OptCAi/M53cOpP4Sdr1uiyRykir4UOU4IBMDUSvSf1acPhpgqZTWMwkGlquW4tTYNnehS6deHxGc/tLgOrSchF6GJ/7dy+wxOGy9/YmfJvwqMY8xph11/FaKE8JITubIDrqXJvaqHpgGC2qhP1NzN6EdvUiiKXssIYJ35LIV/kuYRE0l2fpG7vLJ5Zyoh6nquFLshXEbx47ip1YXWLsUFCRDZpey8YaXm9E+whvpUcx2acUuBEyAOnFhEKkJhJw6o5M1NwCkzm/9Elt6JnE/srWZEXe8jHjehjQDMltKq++74ODabBEY47AEuXMZk9OimF9EH9qXT825NGUrQYb7DH6/0rylhdAXP8jUefOjBMj/dFeaH8PBvhcOsqVZXQ7liZpouw2hPn3rBvJ9NOb66rfDy/vZeQqMXqierMigS50YwoBcPrHkkVEH2tsvs/i/5OmFhYb/SiXNJObuj7R65+RE/9ahmcCr35O8uOmA18LWcgVv3ODIrrspkbSkcaN7uUcy2OiTHAR52f9rk8Ai8OG7VHKxUtE4MhPriIyNIfnCTVQQ4ZPh9AI+3MvSQLxi79qIUBXnTqATTz77+GP5rahbo2Jl+ZOQ/cIeIHmMYEo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c19a23ac-1055-467d-85c6-08ddfbf9ec65
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 06:08:19.0555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1cFDnfvNBfNfw28V46KeNAdoy7qcR777PZh1Qn0kNnTf94+eXxskyzlKqg/g/zyWyxF6DbG3UJpNm3MiVf5oFGyI5tIjXita17gtharBOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6522
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=916 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509250057
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxMyBTYWx0ZWRfX3lwsY20gCf/Q
 F0wLTJnNr4njOD2rH5iWfabQiq2Q9dpwEjnFE4qRTUPvbONAnm0grkrWV/s85pz3PB26mkbl/ow
 J8bjoPV4R4JZUJ5XiUPU75PKOv2EfnKKM/44NULc5i9AnoncA2L2zX3mAi4YUr0IFsNzOIC93/d
 xX6brLN6GUQKS1DskEKU+F+j6XKTCONrAqMU8j2MsCPxeWFaP09Xz+gLK+j7F0QwjU186m/TNm4
 Q6WCcUguMvKY+gGIHoNMvwXskvk1ZGMf/RTv/THA2DUn99K+b3GBFpgiJEi7w1ZVjYiOgVmTfAq
 pI0zy47rSn54YQAbfGKUqeGV/F6Om41BAeCgICrORUW7HKpRo5H6g9hiL29Z/qec06QoNMg2qpO
 XkhXVUR1
X-Proofpoint-GUID: 85UihWomq9p2jPdTZ6WUzCJsh80l9_-e
X-Authority-Analysis: v=2.4 cv=YrMPR5YX c=1 sm=1 tr=0 ts=68d4dc61 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=6V2-dC-VEXILK4XbxFEA:9
X-Proofpoint-ORIG-GUID: 85UihWomq9p2jPdTZ6WUzCJsh80l9_-e
X-Rspamd-Queue-Id: 6809AC0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: rji644iu9gxf9kr9tshjnp7tx71xpq1j
X-HE-Tag: 1758780531-688795
X-HE-Meta: U2FsdGVkX1/cb2WWKjQx4eXzJEGypcHjhr1YbO8o0y/+eISCvblQYF5LAyz4q1zNTPwcGUacv4YikGytpSS4Z+t4qcCAzN2oYcmOb7bUi+zBWWZurswzDZmRp2g6Zb7qV9dfx8fERux9M2iKz5Byof6Xs7IKZqtLHR2SxZzd3y9CcVeiFQ/Z0Woni4/3cshzLiAI9tQ7sI/z1ahIZQ3UnWLWH8Wmt+aH0q3rf3E/L8a1Pf87I2AFPreJoI9j95aUl/tc5tK3VfO3A+1ulN8UM+wkB2oAIY/hIHNeK6ZZffB/zduxGlrI944bjmMNJpdQjHj+qrsOspxIz1l9RsglluqytCxDl393IJjnVPAXlproIFBFXBvad35SKxfkmeeRJe/aZXm/AmPnTtdFPf3dOvYNzYKl2QU0wMXAV6TrWSIEvKraapT9DUAUMpbSia2NBXkGuYfwjUmc26EhyTSAqjNfc3eD2t2Htbyeu3fdxL4F+sqRB3nRpvoEQ/r/ix8Ip+yD9JiYvpNUbnhweyHSutglGSFuH3141Rbrl1a6F+vMS/Tb1hpJP9P6tDoDDV7SUIyPE1lHP0agfHsDJfQqAxthm4oTiWcGyDvm7Wy3fiR46zF8ttRmc/gkZa/4PrR1kHLE3mqlXz/qraJEs2mq0OMJ9Uuyb/KeYCMaUAGqSLoAJ24sCDIqH8FYZADazzTzGW3qPRBbjuuXFMictdVVzmtbkyROl4/eGIDRpl6gJG/u7W4TRJOtqgqJBtdyDuwvGof4Lfr06h8IYBVBvXUIF8HOJykZOv7rC4VUNzQDgSnFjoLwgBv3bAx9Z7s7eRAHB5FjO/bo5dRQ3/8fxpPJN0zpiayVAFeV6q1hCD1A//IhaFUV2m9pWC6gbQ0FXiz30H9C251Q4W95fYkqX75qE6028sy0zQPTUgBGoruueSLsEhSnCCqxVxijY2rGfNLCHgw+LIrzElmWV7zLFPn
 PgyEiRcK
 dNSUqh2ZehlseUsHazcMejhQLXFPucLux+paRrrKEPOirKxQ57XDRHnf5qO9AAvqSv6FVXlhImak/Kler9ygNJvRm0nlRLYjkL5PfhIjQhDLQDrdvvLzGkGY9ycrxY3nT0rcllkXm+G/2dsybuwLbt9LJndxmXtxcyl3gyrqt5PDQFFyQK1qqEvQiUMeE78rbalXOlNJyQ6GrRTb2a61nIe9CXbIGkc07w+noATLNcpXKeAq7UYlQ5bAVocZSe5SISL74qPnnw5cvBxiTj6EUFBj9aeEHUF6qkXglDZxYN0/MNwZpHa7qHhidgtPzmIqn6/Lw5A3wR+i4n+ngpdKREYUbYoVQYIZyD8LBeLB1L37c1eR8AujiNp4Bfofwv3RwcyHPESMSaQWeiMwdQQODdB75tsgRxpml7f6pbKEzAzQWE2VWEHS3EGoK82I8rZO7IBxhSfC6RE7HtEuLPpY+sUmCvbwbut3nQMgr06DagD2uOlVxy4NHacpdRwIxqQofmOI0S1uK6C8CHEb3Egc2fSin4xAdmMHHgGkGjOKlfJl2iACIUM5JmBMnSxSzN3TnbgVsINXDvwWU66/clH1/HxZpUNlnTxeWfITrOTCD5TwMNCke0yqdLFU2y4b0vLgYArEEirdJfxRQB0Xrnwrecha9YzjnwNYFED6I4iFW1ziYZ8w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand <david@redhat.com> writes:

> On 24.09.25 00:25, Ankur Arora wrote:
>> David Hildenbrand <david@redhat.com> writes:
>>
>>> On 17.09.25 17:24, Ankur Arora wrote:
>>>> For configurations with CONFIG_MMU we do not define clear_user_page().
>>>> This runs into issues for configurations with !CONFIG_HIGHMEM, because
>>>> clear_user_highpages() expects to clear_user_page() (via a default
>>>> version of clear_user_pages()).
>>>
>>> I'm confused. Can you elaborate once more why we cannot take care of that in
>>> common code?
>> So my definition of clear_user_highpages,
>>      +#ifndef clear_user_highpages
>>      +static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
>>      +					unsigned int npages)
>>      +{
>>      +	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
>>      +		void *base = page_address(page);
>>      +		clear_user_pages(base, vaddr, page, npages);
>>      +		return;
>>      +	}
>>      +
>>      +	do {
>>      +		clear_user_highpage(page, vaddr);
>>      +		vaddr += PAGE_SIZE;
>>      +		page++;
>>      +	} while (--npages);
>>      +}
>>      +#endif
>> assumes one of the following:
>>    1. clear_user_highpages is defined by the architecture or,
>>    2. HIGHMEM => arch defines clear_user_highpage or clear_user_page
>>    3. !HIGHMEM => arch defines clear_user_pages or clear_user_page
>> Case 2 is fine, since ARM has clear_user_highpage().
>> Case 3 runs into a problem since ARM doesn't have clear_user_pages()
>> or clear_user_page() (it does have the second, but only with !CONFIG_MMU).
>
> I think we should look into having a generic fallback version in common code
> instead for that case, and not require the arch to implement such a loop around
> clear_user_highpage().

So, as you suggested, I moved clear_user_pages() to mm/utils.c and
conditioned it on clear_user_page() also existing.

  #if defined(clear_user_page) && !defined(clear_user_pages)
  void clear_user_pages(void *addr, unsigned long vaddr, struct page *page,
                        unsigned int npages) {
                      ...
  }
  #endif

That fixed this issue as well since there's no more bogus reference to
clear_user_page().

Are there cases in which (TRANSPARENT_HUGEPAGE || HUGETLB) might be enabled
on ARM?

--
ankur

