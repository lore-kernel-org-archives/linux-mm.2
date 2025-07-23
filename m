Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B74FC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130B98E0001; Wed, 23 Jul 2025 05:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108776B009A; Wed, 23 Jul 2025 05:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F123E8E0001; Wed, 23 Jul 2025 05:23:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCD766B0098
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:23:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22EA2C057E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:23:17 +0000 (UTC)
X-FDA: 83694990834.04.7EFF162
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id B476D1A000B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:23:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rdZDNpaM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=o71QvLVd;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753262593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w3u5VDONZ/+uB1+4isoiq10WkDRL3InxVnjaRxGVyR4=;
	b=N41stt1ynU5iOgixwi03BioB+4Q6hojZP604z24izj3Dxb6AGfPgnGHteFuIunTxm1de69
	Zkw6cDmu7sa8VkCgVo1K3wbW0XATA8L1ABnXVdq0uspdY2KqmU+bXdnxIq2UG6JqLQ52G4
	XLGD4N3jCXeGq7PIl4LxdsZ769yg8VQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753262594; a=rsa-sha256;
	cv=pass;
	b=c1Jez7HpViXFF43EynYFZoQWZ/RV//HR3tvH6XdveZ7IgSvngaXJ2ojqizqA0q1za6yHcE
	cZf5lDhiQOJ9uMIirjNR3yD+SR1PHIq4zTTyRlVgiFJqNTwEsEHfSiSP0n3K49+/Ny/AJs
	bf63GtvM6v6I4J9JeRxRl03NOC9ci80=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rdZDNpaM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=o71QvLVd;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56N8NKqt023504;
	Wed, 23 Jul 2025 09:22:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=w3u5VDONZ/+uB1+4isoiq10WkDRL3InxVnjaRxGVyR4=; b=
	rdZDNpaM/a2B7r2GKdmnWNFXp1le5LqOIvWn9Ch/DOfAAbw8nVfmpLSP35il7rSq
	0kch8iocE1ItqgVeR1iH26IdsAsxX37aJnjq9gOeKl5JMU3FGCvrUtET2OOP7y41
	xukShZ0PZW+Nvq+o1fxx52RFWJojfMlf4cI8/y0Lk9uV7wolVdvPOyPLMyyLmnr2
	juf6vsVjEoy1qWMZw2uZ5poyqIL2/0iDvb+7SYWWgLvKpVunhWKdZq+VLPC6gGqd
	qS9hhN1yuJYOqrOwp8J/GY8ltT9ut9dOMs/Aqk6y6kq+Doa17sDojFFcDujcnUpH
	HOFbyzSZd0f97lQ9cS0ePw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e9q70d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 09:22:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56N7XKlc037763;
	Wed, 23 Jul 2025 09:22:31 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2043.outbound.protection.outlook.com [40.107.102.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tad2q7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 09:22:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U2Iz0T+ze99zqz7Xw9yaQWu0S5FRymDXdtl56PsECH5r8Rz/k10REgmecZ0ZY/GCX0G4+oSzE51s4jUVO/jrpyNDelsmbFh3Hygm3mukmXIXMjTbd0bKRnku+zi7lsh4TMppveYRpS5Kej9UiKsilADAf/HWEd4Zp8ci6Jk28FPEjshF0vrqbrk2aljhtQ87hpc1BO15XOt/FSGSHd33Hn8DPlrJK8bfiA12CtMTFaIYt0IeB5XZG+S8qcWCRd+iCFPhjrsYnqKxnJFsXDCZWUbLp++Ew1TV1goaj7Hr21d3nr8gjLbxgiuhn8j38/dhg1MSegzvZX1znMJUahVLCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3u5VDONZ/+uB1+4isoiq10WkDRL3InxVnjaRxGVyR4=;
 b=hJ+IhmnHRo+w8KrwZYY4QcCBGiz3nAbU+h3RP3bMz3ht+Lf8D9MV4jk9NHTgU2FJn8BUCZg3NWlWsAzVkzzOCA2v5H7O6ebJBidLujIC7+vtvOH+FlUZpmYoON6giGIIu41DElsXU0+0Tf8Fd5GCYlSMEizQdmZZrZ+mkPN2g1nxE+qMOe0JOaBgj8H52qP8/GVabqsQMr4edCrHJiULXiVl+CNu70MUf6LLSgx/RwzVX1i2Xquns3wtNzJRcocie8lDB0bc2BP67bxgAJt5aADR+V91VhR8hSpFtEgGUWxUkuEfNGKWv4n79oK5lpKCjeYu+Zit0MCifAtBktIVlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3u5VDONZ/+uB1+4isoiq10WkDRL3InxVnjaRxGVyR4=;
 b=o71QvLVdKzncG8QBLoi/dfpqTBYxTCCwhsG3u9YVxLrLXnsmQ/5AsPSxPuhtV5uHL0TIAGFqO5X9c6De3mb1x+GhT0gh+njBvM1aRvongolmheoEhUEo/BcxPLl++na4ldHbV4l2VGUJSMsc1O2zkWtEX+gImwjDrHElCriGNsE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BL3PR10MB6017.namprd10.prod.outlook.com (2603:10b6:208:3b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 09:22:27 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 09:22:27 +0000
Date: Wed, 23 Jul 2025 10:22:25 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Xuanye Liu <liuqiye2025@163.com>
Cc: David Hildenbrand <david@redhat.com>, Kees Cook <kees@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add stack trace when bad rss-counter state is
 detected
Message-ID: <9be97451-dfce-4dd2-a034-284da0f19bfd@lucifer.local>
References: <20250723072350.1742071-1-liuqiye2025@163.com>
 <202507230031.52B5C2B53@keescook>
 <c7a32d87-efbd-47bd-9a18-9eb51e441a7f@163.com>
 <119c3422-0bb1-4806-b81c-ccf1c7aeba4d@redhat.com>
 <8dd1e8f6-f96d-4d36-ac2a-c258ac842f75@redhat.com>
 <5cdd3e44-3e3c-4697-905a-ecc61093f7bc@163.com>
 <270d8240-fb64-46e0-a534-80790c4cc905@163.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <270d8240-fb64-46e0-a534-80790c4cc905@163.com>
X-ClientProxiedBy: LO3P265CA0023.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BL3PR10MB6017:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d8470a7-57ee-4c8e-ba62-08ddc9ca710d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXBMNWw3RDFSWWRMTXhQNEJ6VCtPQi9ndHhIOTd0TzhGOGNrZ2tUYXZoakRp?=
 =?utf-8?B?d2NuRnN6SjBFeFRMUlloMmxmMnNiWHNqd1hYKzlZQ2ZIcFhjeFNmQjJ4UTVX?=
 =?utf-8?B?NWRIM09WdTlmeTZydGRSYlF0cFE2dys1RkU2eXo5YXlvNHUycEM0WWFhRTR1?=
 =?utf-8?B?UmlYSU5SZVNHelpSVXFUR0VDcGFxWHUvdndEajJLeWQvOXlCUnZTRzRmcFYx?=
 =?utf-8?B?MVN2Z24wcU1maytDS3czelQrUzZNcFVsTFNmMmExbnFGbWowTkpsbnFXMStW?=
 =?utf-8?B?SnBDd1JEWVRRQW9qRlgrSWtkUlAzRURZL1pWU2k1enF1T0lDUUFvQUVraEF3?=
 =?utf-8?B?U3ZSVG43aGtMbzVXNEZ0a0tCcnRFR2g3UElkQVZTcmIzUjRtUytYZ1NFWWUr?=
 =?utf-8?B?b2xHRExFaDAzTVlxY2VLWkY3dkJnYWc2ZkRwQ3RQQ3JCZVJRQkw2ZzRzZ3hH?=
 =?utf-8?B?SnowZ256ZVd0MlRaa09uemlpdlpQWkNJZ2wvUG5IclcrZnZhWEI4OG14SGUz?=
 =?utf-8?B?K01xZ2RyN3JtYTgydUZ6eGoyS2UxUEJMbEh4citDKzBQcTdxRGU3QUkyOEpT?=
 =?utf-8?B?RzI5aGxudjZzOWFyTGc3ZkUzU2s2bi90OTArRUdIZkdJNzV0c2JhaG1Mb2Na?=
 =?utf-8?B?WVZlTVg4eUcyeEUyN29JK3p5ek5kK2c0ODk1Vy9PYmZ1Z0poUkFCUzljR2JX?=
 =?utf-8?B?ZFhNc053M2VJSlRlWCt5bVAzeW9naGxVL2xmQmlNZ2d0SitIVkUrTjdxYXhQ?=
 =?utf-8?B?SVlpS3czZ3c0LzRpUm9WWi81VGYvMFVwemVNbVZ5YmY2WW1zc1BXZ2Vjc1dr?=
 =?utf-8?B?RVBFR25JMFBEM0QxTHdLWGk0aUI4YW9qUXhUSHhzYkt1R0VUTTJsNDJOUURY?=
 =?utf-8?B?U2ZYSG5EN1BwZ1RQUHBlYkx6aTkzdTlRQkdldHZNUERXUE9VVWRFbTRvVUxL?=
 =?utf-8?B?bGRKWnVOSmR5eVlQZnlpWE43QWkzcm92NXA0UEllcWxTS1lXeko2ZFVGY24y?=
 =?utf-8?B?aWYxWVJqT0dTUkFtZzhsaWVHQlBwZnU3di80UlUySm1OS3RDTkQ1VmtMQi9I?=
 =?utf-8?B?Z0ZpQi85NmRDMi9RdGlKdytuVGlKUG1FaHcvRCtPNGoxQVVIY1RGZHpOZG96?=
 =?utf-8?B?anFNTDVsWkZUL2FqSkkwdTJTbVZTaHI4bU9pV2cwb2tMQnkwaUJ4SjFzTjdF?=
 =?utf-8?B?b0hTdTN2TjU4RTJoZ3VzSndCVDlmdzFCZ1M1cWZZSmxOWmhReDBIbkNQUjFB?=
 =?utf-8?B?MjVSSUVYQVhSYS9wWFlXdXdmdXRYYVg1VmJVMHBsZ2pYVGh1UVFUMENXTEcx?=
 =?utf-8?B?MldCK2VZb2lwTnN2ZGNLdWh3KzJGNCt0SlVZS2wvQXpGWEZLVFFjbUVWNm42?=
 =?utf-8?B?ajZmRjM1RFZPMVYrS0xUSG5Xa2l1b1h4Z0pOVDhwc2dsTVpmZXFYY2lFYlVh?=
 =?utf-8?B?bXRVMlpkdXdkR3FUZ1phd0ZCaEpEOU43SDB2cGtLZlNOZXY5bGhLUWRDelB5?=
 =?utf-8?B?Y1MzZDRtclA2SVdhMUFycGxkaFdJck5WKzRTR3B3alRGL2NWYURIZkR4eXp2?=
 =?utf-8?B?NERscGhzc0V6T3R5aWtRcndaOUNoc3VKeE9Sc2NUVjFRZFpCL2lDWW5yc1Rk?=
 =?utf-8?B?V2lKU0hzMno1RjdBVk1IQnF3b1BrWGkyNXNnQVVCUllCd0FPUjNGby9McDJG?=
 =?utf-8?B?WmYwMmZVaUtYcWo1czhHN1JPL2JsVVdaTGdyZC9OTUF3c2lmNU42OUZGZDB2?=
 =?utf-8?B?WUZlRzQ0TDJvbVZVYkxYUGVxeTJyNnFUUFVZdDhXR1Z3eVBZMXAxNFp3N0gy?=
 =?utf-8?B?RysvTjliMEVETTlvemhSRGdGM0p5WTdQYlFzTldOTmM0QW1MdTFwWFRRbDc3?=
 =?utf-8?B?c1RIdk9hUzhuSFRCM1g1cjhoT2J3SFBUR2kxamtoRnY4UkRwdGZ0YTBobnc2?=
 =?utf-8?Q?Iqv/M33jkSs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGhoQnpHQWxpM1BWbWVXSVd2d3VSSkdIMmlnTDdKTDIvOXQ1ZG1CRWpoNkdk?=
 =?utf-8?B?WGx6Q3FDRXR2ZGVLVk9LQ0hiS3RkRTNHNk40aFROb3NGZVB2QklkNkNrQ0pB?=
 =?utf-8?B?QUpkMHg5b0dzOGttS1hkeE9OakxRY1VtbVE0RU1YQjhuSzVtc1d2VFZFQ3J6?=
 =?utf-8?B?aURqV21WaWdyd1VQZlhPL1VJLzMrUTF5WmdGSkRvOHlzSFlQNnJIbTN6WDJx?=
 =?utf-8?B?STRXT01kMXN1c0JkNEN5anVmSFFnUXVRYUpJU2NhMlkyZEo2dUJqRW9oa3FU?=
 =?utf-8?B?ekNIWFVFL090c3JlUDFHSXBIVUlhVGhCZkJHb3I1TDJsSG0rWDdxeitRVWc4?=
 =?utf-8?B?T1ZtV3VTSmpKSm5YejF1djRTdHZjQXRYRHNBM1BXYjZXc2JuUUNybzhzQnc4?=
 =?utf-8?B?MFZBSmpSeENveTZLSDJhbXdxY0ZTT285aGkvaEZzeEtxMjhxOVdvOXY1WTdH?=
 =?utf-8?B?aE9acVc5elBUdG5XdkZ3aGhwSUtGK1B4ZjdXZ3ZITWJTTHd0ZUZ1Kzg0Y1pu?=
 =?utf-8?B?Lyt4TUhiSHdMam00dVlKdWcvSE10eFRpUUtMT0xvOGlhU3E4MUNZSGxqYkR5?=
 =?utf-8?B?SWRXT2VSSWxrVXg5KzRkbVpNcjNkTHorb2FsWWZVZVJyNWZ3VVErSjhjYUk1?=
 =?utf-8?B?b2VKQytWNm9RRmNTMGxLU2RMS29LRVh2WitBTjU3OFhpUEF1YTJ0N2dxOFl2?=
 =?utf-8?B?V0xRRGxDK0ZGeFhLc2o1czlWYzdmS1RIOGxFZ1VMdHNjWWlpQnlyQ1NVQ3dM?=
 =?utf-8?B?Y0c1cHplVlhGRHB1clJIYjdsNXZQZXdwSVlNMnBMRG5QY0lqUTk1ZUVzRjYy?=
 =?utf-8?B?Z01EYmpNWWZGR1NNWHFuOUpKL0NSMEloZWFkdnVGWGpiVFBocnRHSVNOUGR4?=
 =?utf-8?B?MHZqbkloanRxN1hDMkFmMFJ3RXRmUFdUS3hGaG10eWhyQXJqV0Jmd2pJZEVy?=
 =?utf-8?B?TFRITlIxU3h3dUJRVWJZZFIvbGFBTWhiSE0rRWExTWh6bGR5dnh6eU9sQTdB?=
 =?utf-8?B?eGhDd1JNeVBYdWtVdmoyQkVtQmZ1YzVXazhpRkJzUmpZcEFrZlcvaDk4R2Q4?=
 =?utf-8?B?Z1c1NzR4SmFsT01rWGRBbUlmd1VRVi9nWHZSS25QRzFOQlVJRGRSejJUcW14?=
 =?utf-8?B?MXlxM1J2a3loNkQ1dGpvZFN6dWk3ZUQvazYzR1BlTkEzaXppUkkvOUptY0ZH?=
 =?utf-8?B?MURKRDBQVDVkNmRjMFJGK3dHTktZZXcyRzMyYWRPZ2d6WGJ0aCtKb1lZNjV5?=
 =?utf-8?B?em9Oa29uOEY2Uk5BanIxVlVLakN6OFp5WWdHaUpvRmRCK3pvb01qY05UVklX?=
 =?utf-8?B?NUtHMmNxSE9FMmczOTVrUTRQOGNzb0w2VWhvTVlzQWQ4ekx5TmE5cTBUMlFN?=
 =?utf-8?B?SEVYUGFUNHdGemY4dFZaMDd1cjVxd051cVhCYzJXOVhGeDNOend2VysxSllB?=
 =?utf-8?B?K0tVWG5PeG1DWXkwQ2s0bkxDMkErNDhLMmZvaGVpMEk1bHd3YzJkSHVhNVZW?=
 =?utf-8?B?dzFtRVFIeDNYL0dLb0hWcHpTUTlMTjNBdHFUemJiaGVGaGFlMEhnTUhMOVhh?=
 =?utf-8?B?WmNmM3BZWEJ2YThVUDBQSFc1YWV4YlM5Tm5ZL3FOZG5URmFRY28zREdVSEI4?=
 =?utf-8?B?REZyblFOOFdoNnVwalNmNG92YXpZbS9vejZ0UmFjRzhIZmwyZENQMXhEWEsz?=
 =?utf-8?B?Q0UyWjd4MHpWSkxRazVjT3pOUnF4ZGFJVFhQQnJGeHNQT2Y1aEtKSittcE11?=
 =?utf-8?B?UXZ2VDRrUkNJOC8xMjNkUnV0TmJUL3kwbGJ1VnVLMXg5Z2VRR3JFSXplR1lh?=
 =?utf-8?B?bE1ObTdQUCsrbzJTbDhQSlQ3ZkxBckwraHloeGlnazFCTk1iUEdkaVIwUStZ?=
 =?utf-8?B?a25tVEZiK3IrODRQRVNHMC9qcGhSR3VlQzJxUURoUG1mRVhWeXpsRHUvTFhU?=
 =?utf-8?B?NGVtWVM3ZTR2UEMwVWpBamZRczJTTWptRHRZQ0sycEFibzVzRmtDTkxwR2tT?=
 =?utf-8?B?ZVhUNlBnUTNkaHdNUC9RNUlZT2JGV1A5SmxTRXAzMmdmUDNzUTlKNmVrbWti?=
 =?utf-8?B?OVNhNFYvUmc0Y2R6aURDcDlLMUErUERYTmozM1VNLzlsRXIzNlRZaFV2R3Zo?=
 =?utf-8?B?cXFLL1JLd3pmNHZ2SzhKZUwwRjhKWVhadDBkQlQzeXRZRVQzUWxEUjl3N2dj?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yqMd0MJhkk3E1EkDdK73ZEAHCmbplbBcsa4kZq2Wvu96OaMLa3bEu0mQvIJJvUMPNZM+JB7DucJK+cxwBLU4ieeIFoR6kNstykRhWnefOdjHO5vP4TaSY9XD53AycYBnJvquyajuCrbM2m4eBjivo4dRfYP2mS+kB2fsW4WfXHDEdxzPe/+j0N7M7VBuFu1H3nwQVaCfCJG/UPxXoGJFbP6QG/z9X/b6O7YtLrCZqYjXptMN1bhIx6wE24LWk9JxioLlY9IOzy/MYGaA9v81R1hx0tcNAJDn06kz348ELC9XeSMt2cjDXh1yjfZ+b2XorJe8ZQFS0LqmJsUWKDEliqOlO9xSzCMcQGtfScZcDScSKLowtfrY9BSmwgz6Bt6cOW+BoQsaR6BC7ZyEgFQ0Q1Ov70SXarC+zQQj0yjfLycTg9i3bwmXZFnEeGc7sL8XYA5phCFeIXsiIK3PCCoHq38P0Ack9xlwmqbTL0Y/+U/BuzRzLuZjzJLPpHtpBIVOBHzef7tWdQRTLMp0f4gn3eQx1W16Bn0BAYqlnX2v73ktybyufNezr47bw6r73/Jq3xHsCsEOeBocS0+gJ13T4MaGwAflnGQ6h5EfYSz259I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8470a7-57ee-4c8e-ba62-08ddc9ca710d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 09:22:27.4895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXglKk2KeNpo1qWNhgIEyjOreJ8ceXO3jWjrFdpbL+uDOfBIbRc5qTaFKNuki71+wazs4TYhD4Km6EWlgPQadutHtPlEAu2qks/oP2nyayU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6017
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_01,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507230078
X-Authority-Analysis: v=2.4 cv=eqbfzppX c=1 sm=1 tr=0 ts=6880a9d8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=xH-5eg9lCkU4znwj824A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12062
X-Proofpoint-GUID: M6JrRtijGckARKkEvXwBLnk_LVxu_TFj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA3NyBTYWx0ZWRfX7Yn7QnQwZVMc
 pa6d+4MRNB2NgkamPxb+An1bHpedoqDlzONoj3WRfup+GTnT9fuPPaVVxM3sElh2ogxp757/Rbt
 AwZ2dKTcUjU/3zxggt/ub16BBtxs1ZXdQOXs9wTq/LPBKiqgfdphIpzNigcaHIMGdyjtMofay5d
 /f3g/R8IfpzrFpyS/SDXZQEMsrAxYn7qQ1Pz5TBI3cQCpBz4/EAFXcfgxQen282NC2eg6AR3++/
 Pe57wc/Bj/ybZJK54LwbBbGxZX2YyT1pEwEtqUWqI1IXYWJ+G9WgMWL2PzxI+Hn+V1o62JC73p8
 4Og5NceJfWmImEJ78doxLpc8kFt3AU4dqNuigVKmixlf9c0dcM0OfBU3Ex4MycRT0aNwkSNP+2i
 DhOEOEn7Itg5eFVUV+eO1+UP2UnVxjTZM/1I+pLnoCYPPorgXgoTdChTwkCGqR43mDuz/D6u
X-Proofpoint-ORIG-GUID: M6JrRtijGckARKkEvXwBLnk_LVxu_TFj
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B476D1A000B
X-Stat-Signature: tw8x67t14o3mfjd6dde1pfejxu5ktwxr
X-Rspam-User: 
X-HE-Tag: 1753262593-169250
X-HE-Meta: U2FsdGVkX18o23wLuqKf0oaTR1pNcB357YxIJh91VORio7TrGmqcmjKtRdPePcBiF4lduF+0npcZ2iUXxBjFK26pYqhpIWdx1giVse8anN/YSCidrB8joI5xqxJGYOAx1pLc673wi5j0z0SM+CFgD6p3ihB47z/7WEefyHPcz3yPhLuruSaqgig851NxR1BVGwmUTm0W6XaYZFtz1OsgFsfO8Xa/UcnXKX3dM30Ar7axGtThlUB7KoVIL6ofpDQFLqMSn7qnpfFChn0CnFAJHUut9VWHkDti5JeduFlXkKPgLAWBUBij+EMQmAdXfUSsJbz0jfYhzjK0EN1oqn3RaoZ5FW1w+57ZNSqYw9fF74aMLegj8lwsoo8UePjGyekENUqtpX44+QORErbw82R+ioSE0GBfzDtGJb5GA0K+l0nFk/OdKNwL0fhQHPcRxXNkIdSttGJwBuLWJzVILA4dVFNIKurX0BJjSLnWZNk7vrpNsNCbAiC3JcLtLNM4VoLAVCkzOEcZ9W7E8nYs9UUsDK4F9Aem89pHh48bypCqwg2MWumKK8iYfXggzynSj0jpWWF6ME7/GJeNEY1WpTiFv2FxKVNNLEX/BlbjcP/eeJhpNKB2nZ+Qpck5dtiQi2/CxnJVVqdcljBtXZrq39w++2dbdBSh7dl6RIOGY6NYyCk+NwFhhTYedjckPJ0pejd8/e73rl33vRMs5+4pW2t6Yd/B+9OT0ZdsN3Vc3/c/rTzfW6OmixnC3inHPz/FDMtmObhtW0cPSg6IydpSTSQX40NuY0P0WdduJSOwqYS18UcP5GUe0wo04/wK2Qs4KPZQbekGggajbpgjqvbKZBHvpkecdKQZSmZkDLNzlXqbzQcEEMsYu583gstG+Henrg4myINVYfodu3ZwI8cjya8tMUtNA0H6TSjkek/sncw5PYxWx5vM5/bi4UlTpXsdtmikAgczCe5CRFE5bg5WbCI
 Zs6PFhSu
 5r9IRCS1qVzFjVWgg6AXGWcKq18+bw4V10EY1x2NHr+giXyQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 05:14:19PM +0800, Xuanye Liu wrote:
>
> 在 2025/7/23 17:10, Xuanye Liu 写道:
> > 在 2025/7/23 16:42, David Hildenbrand 写道:
> >> On 23.07.25 10:05, David Hildenbrand wrote:
> >>> On 23.07.25 09:45, Xuanye Liu wrote:
> >>>> 在 2025/7/23 15:31, Kees Cook 写道:
> >>>>> On Wed, Jul 23, 2025 at 03:23:49PM +0800, Xuanye Liu wrote:
> >>>>>> The check_mm() function verifies the correctness of rss counters in
> >>>>>> struct mm_struct. Currently, it only prints an alert when a bad
> >>>>>> rss-counter state is detected, but lacks sufficient context for
> >>>>>> debugging.
> >>>>>>
> >>>>>> This patch adds a dump_stack() call to provide a stack trace when
> >>>>>> the rss-counter state is invalid. This helps developers identify
> >>>>>> where the corrupted mm_struct is being checked and trace the
> >>>>>> underlying cause of the inconsistency.
> >>>>> Why not just convert the pr_alert to a WARN?
> >>>> Good idea! I'll gather more feedback from others and then update to v2.
> >>> Makes sense to me.
> >> After discussion this with Lorenzo off-list, isn't the stack completely misleading/useless in that case?
> >>
> >> Whatever caused the RSS counter mismatch (e.g., unmapped the wrong pages, missed to unmap pages) quite possibly happened in different context, way way earlier.
> >>
> >> Why would you think the stack trace would be of any value when destroying an MM (__mmdrop)?
> >>
> >> Having that said, I really hate these "pr_*("BUG: ...") with passion. Probably we'd want to invoke the panic_on_warn machinery, because something unexpected happened.
> >>
> > The stack trace dumped here may indeed not reflect the root cause ——
> > the actual error could have occurred much earlier, for example during a
> > failed or missing page map/unmap operation.
> > The current stack (e.g., in __mmdrop() or exit_mmap()) is merely part
> > of the cleanup phase.
>
> Dumping the stack still has some chance of helping identify the issue — at the very least, it
> shows which task triggered the check.

The stack will be actively misleading because it's highly likely to be totally
unrelated.

if you want to know the task, just output current->comm  :)

I think it's not only of no value, it's _ACTIVELY_ misleading. So it's
definitely a no to a dump_stack().

I am also not in favour of a WARN_ON() for the same reason.

Really we should be catching these elsewhere.

If you want to send the patch just outputting thet ask then all good.

>
> >
> > Given that, how should we go about identifying the root cause when such an issue occurs?
> >
> > Is there any existing way to trace it more effectively, or could we introduce a new mechanism
> > to monitor and detect these inconsistencies earlier?
> >
> > Let’s brainstorm possible solutions together.
> >
> --
> Thanks,
> Xuanye
>

