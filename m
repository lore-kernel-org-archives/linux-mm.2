Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37884C47BF2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 14:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792496B0088; Tue,  6 Jan 2026 09:07:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A196B0093; Tue,  6 Jan 2026 09:07:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EDDD6B0095; Tue,  6 Jan 2026 09:07:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB7F6B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:07:06 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEAB7140160
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:07:05 +0000 (UTC)
X-FDA: 84301715610.02.3D64456
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2FE5B40008
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:07:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cSq+sEzI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K9J4CEPT;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767708422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKurIjqwVu+GLlGbAQV7uvlENezXoagHBdhD8SowWHc=;
	b=oWb0yQSS0lFGGzSwjlGWKTSqfpPRsfoiG/Na9xxbJfMGXJYgAhgqDZW7M6XllCesNGv66N
	X86rODSFxFNfJyRM+kdmiLJpmA1An5tjMhMO7H203AgVs5n4mOePI9n6VO4Of1vZDj0EZk
	64Z90oLDLLBabZM/24+FqUwcDDnb5oo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cSq+sEzI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K9J4CEPT;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767708422; a=rsa-sha256;
	cv=pass;
	b=megXUZ9zUWGDFNjfYlOff02sgEfcwfXHiEGkFOmcz8kVBVVCd9jz8Z12ymLJFNKbvCnHrq
	9XkzOsfBjNmwb1qOkysXTnhH1WGNWxPByosIBla/35O6lf3R5ZS/Q0nPyFSPGc4I/7LgUG
	ftZ2QA/JVArQBByJDdKqL9wsTSwLuH8=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606CoKKL3899068;
	Tue, 6 Jan 2026 14:06:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OKurIjqwVu+GLlGbAQV7uvlENezXoagHBdhD8SowWHc=; b=
	cSq+sEzI75mqCwIiwnGZrpMnCy3kmX7kSmjs2mWO6N8VqrL+e2fCzL4gDD5ASXit
	8LoLq/jzluLAdwgwVTSRVR/ehSpVEc+4kF0nKBT8G+27b/fN76IMGWcHp8PWQ5bu
	U0per+jvpBy+nYX2kVTAirlvagpzEGJ5HjDgKrVdfUD+GSwKIFGVmjiz7XJe2kXe
	JRCfW0J241CZBgIAPsN9uS5F08ptFlT8NJwKVACk/rUHfl0EG2kJkaxyXnXgK/ki
	5SwQRJRHInMewNrRNJN3T0nvP2U0G42XJl9phrwoAT7Kfe3som34gD59bYwBLLJ6
	eBChY4ZpAYP3HPDelOL5ug==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh2rf8303-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 14:06:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606DJL9A015545;
	Tue, 6 Jan 2026 14:06:56 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010052.outbound.protection.outlook.com [40.93.198.52])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8cn58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 14:06:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ldr8/X+7dxyV+SShhP9ddIBpcNt5/6ng+Ols8qgMsZMUEyX+W/EBo9BsmFh2T6yKFzdiotKFJKS+uRqWO5pxr3Zx0s9ZCg6hkxlwjx7s1CuMofftHLwDkP5C3AySCXiIjEd+xbp0lAyJyDO1N9060lBhIwtyf2pgEX4mvoaobnYyCC1vHPMmwKewLjsJqk5cw2XtyxvoJaqJjzUUsyzITzZ6Ifl6/qG8erizhryoNG+jtrKTlNziA0Q0g1WzChaWNpR944xrjsPBO2L5cB0jUkRziMQV0tM8I1WyJlnWuzJQvHNdwkX73vaTFkJzQQBfNqnKGJIaCjrKWZw1Lo1vvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKurIjqwVu+GLlGbAQV7uvlENezXoagHBdhD8SowWHc=;
 b=XzdkAFH10JdwmGCzviGwboIaqznODtA2glnlxycUIePT0LNdemi/Q03MF0gT4hUu8m5YX1hqXujVHUTcmCFUJaeIaogIR9kpJzaFqhhSWhpQUhkD70ItJPc08OKYWJksi6y+l/neaXknsWG8Idr+vG3AIFGyYkJtQkTzVkqXzDnNPGxEJTsym5p7aTl9XgeFUfF58RXCXn9fagrd3tLa8771TRV4uVjgOiwMwT3HUu60cOt+AVukeGC0WSs1fECN4gGfdxwwU1hmHptHkS3rg8gj+UL7nHO7y2QbfNTIlRSFKzRf7rsGla0P8+KnYRIMQB95gZpK2zBGMk+1Z3RW4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKurIjqwVu+GLlGbAQV7uvlENezXoagHBdhD8SowWHc=;
 b=K9J4CEPTXpA5YMbgFjgmAIeJ0CYyEzK24nAb3yiQZHEjh2gjoMympyMJbm1UnvTEfh6pKlDGFsF7y/60P7J2XEEsvdVJQeFpwvfMtzcNukptI/WSbiI2Px6dmnyW/+Owi8ZnY10MC750Iy4qb2SI2z7LHjgSPaZuVRLwe+it/O0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8303.namprd10.prod.outlook.com (2603:10b6:208:567::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 14:06:52 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 14:06:52 +0000
Date: Tue, 6 Jan 2026 14:06:54 +0000
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
Subject: Re: [PATCH 6/8] mm/mmap_lock: add vma_is_attached() helper
Message-ID: <d56776f2-d7bb-4db9-9e32-7cbe7fb9c752@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <d3d98a5fe9ecd0b17acfc359d0c92b9e929cf34c.1765970117.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpHuv44yisSaaiv6F4MnVYvOdRyjSfsXZkwvWYmKvZ3VhQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHuv44yisSaaiv6F4MnVYvOdRyjSfsXZkwvWYmKvZ3VhQ@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0294.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8303:EE_
X-MS-Office365-Filtering-Correlation-Id: be037cee-4ef5-477b-cd0c-08de4d2cd773
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NEFMUzViL210U1BJRWxJbXVqaXhxeFFkbFVTV2ZVY0JlenRVUHRLUUVPbXBD?=
 =?utf-8?B?ZXNIdzIveTZ2Yys2Tml2RWlCcFJLUFJrcTUyVVRTL3BCRjhLUWR0cVBwZmNN?=
 =?utf-8?B?NlRQSFFlSWkyaThpb2EwRHI5U084QnpSOFFxUUxVd24yOHI5UGNRYXFuNGV6?=
 =?utf-8?B?Z01pYVNqNW16dFJBWUZ3SzQyU0VlNm1kWUFsYWltVTE5KzlJdy9XUmp5WWhO?=
 =?utf-8?B?d1lFR1V3MDZOb3VhT1JMOS9iZFRET21QMGNVeHplSW5vWTliWGRrTDZRbzRH?=
 =?utf-8?B?bnRvS242MkNjWjV3SjJtTXFHRzN2NVp4NnJhRitsckhBbkpya1M4NHBYc2R4?=
 =?utf-8?B?cXVaUHlFWEdIUG1CaWQxcWxTcW1HMCtZWkIvT3dodWZ6RzBOc2VwOVQ0b05P?=
 =?utf-8?B?dFBlS2ZrZS8ydVlsbDZsWkF3YVd4VmJUNjk0Wm1RWm5GSHlhcURnczFXZUsx?=
 =?utf-8?B?QVpWdG9rSUZuTXIxcHlZVyttWVQ5NkZGejdockpLbFQrV2d1WWd6QXd1VE5I?=
 =?utf-8?B?Zit5N1daYTd2VEovYzRKZ3N1ZU8zbGJJekkrTlRKaW45czlsSzRZSmloVlFX?=
 =?utf-8?B?Vi9nMENRajRlZEhTQWtmUUVMbTlrSWZBV05hZVBMb2FraUoxOG1PRWxLd2tw?=
 =?utf-8?B?U25ONTd6VkV4NHh3SWJmUWwrbHlUUVVxRVJQWTA5OUxBTzRGOUM5NmhaNEVI?=
 =?utf-8?B?dUIrOVRCVWdMVHJOL25VZktxd1RaZVJJUnJ2U25tYWtUSzkvcmFZUWEzeEpv?=
 =?utf-8?B?OEZjLzBvTnJhVzZLVk8zMzNjZjBPNS9kREcvVUtmUlBwWFdWM0d3YnNKTXFB?=
 =?utf-8?B?L0ZUMmVSSjI3UjEwMmdEaEM1eHdMSlR3UVNsYm9Ra3c0V28yakZ1aDczQUNk?=
 =?utf-8?B?YzFJNlFzUk8xUFNtVDIzV29aVU5jVWM1b21EeGFLVXVIZk5iSDU4VXlRbFY2?=
 =?utf-8?B?VEJPYllBRmp0UUFWb3VUZTRiTnp3bkRObGxOb2EwZFUwMzc3RXAybnNpRXNG?=
 =?utf-8?B?ZUdqZUZJRXNRdHE5TDEvaE9kMGsvVnd4WlhsV3hzVGdVSDNkQ0t3TExMMkdG?=
 =?utf-8?B?dHp3STRScjhPN1pleUV3Zk1qMWFFOVZkZnVyN2UrTkRQTzd6SFQ0amJGZllW?=
 =?utf-8?B?cUlIdklSbjBxTlhHZy8vRkU2NFkxUm1sV3N2TGhkTVMyL1laZThvdlNaSEFQ?=
 =?utf-8?B?bHpGcGxWZmRrWitVMFlCSWc4Uk1Jd2c0WURTYkcra1VaRkM0WDdXSWxqeUFF?=
 =?utf-8?B?MEpuKy9wMzU5Tk05TG1CZXRsak9ZbUoyYStBZ2RYdTVObTAxRFM5NnF5bFZ5?=
 =?utf-8?B?dTYwRXZxZVl4NkJrYWJOUmRnU0YrUzB3VnNQc0hDTklLWXRsaXNoOWdCNFlL?=
 =?utf-8?B?TzJPeWc0VlJ6TTlHSUJpOTNHeEU5OG9Ob2RUUnNEVExzUXIrYkhGMmFtZG05?=
 =?utf-8?B?eTdESUk5N2xhK0pndTY3UEVKSFM5bGRhSmNOcmRzSGFBRWlzc3N2Mm9YMUdl?=
 =?utf-8?B?cXRLb2hNdU5uTm16S2Z1ZkU3QUF6UXdFYWtqWVBBUkZ6M2NpZ0FpT0JEa25K?=
 =?utf-8?B?ZDZOc3lVak42anZjYXJOQ3lIVVNEVTJ6WUNUekczSGowY00wZVZnTmFHRzJz?=
 =?utf-8?B?R0tVTFc3VUptNHRYNTVYT1ByRnZkNXFCcTVyc2liSnRMcUJKVFZZZFJkN1ZV?=
 =?utf-8?B?Vktpb2R3NERkdWJDNm9paTRkOXZOc0VCb0JzMjRQcTU3Sk1BRWgzVDV3aVcr?=
 =?utf-8?B?MnZlYnV5YlRoUW1IL2NhbTYxNDgwY1E5NGVONkxQWjZDS2NkWjZEY2MwMEF3?=
 =?utf-8?B?bFo4SkFuT2dMcFErTlZzT1RBVzV3aGltMjg0bmcxVVVNaTltU0duWXZweWRK?=
 =?utf-8?B?NGFGWm96TDJlVVg1YVpNYWRUZEZ0cTlKTmw3QXBLZmZaNjRiSG5wb3FxeHNo?=
 =?utf-8?Q?pyOl9qbTDUHMJJANwYx+zOoe2eZvTTML?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFVYMnI3ck9rcFpJdjlRQUhnS3lZTzNQajJmNS9YZmE1SUZhT0xLRk13T3h3?=
 =?utf-8?B?clcxTGNGdTBtV3VmY0pPOENNVFpzZVFpRGFsOWNHSVRuTTdaQmVKTWM0RTl4?=
 =?utf-8?B?QXVXc0VsMjJpek1GQWtiOTdCSlB1S2lTY0FObWVIeEozcjNHUE5Kb0pNY0xY?=
 =?utf-8?B?dHVQWmVoQXNsdXNGOEJJVjlpclhBUDBUS05mdVhNaEd5YzZ6VW42ajB3MnMr?=
 =?utf-8?B?UDVEWit2TkZjZDdtNXRqdHZFcXV4RVFtYlQxQ09WUFNrVENTY3F4K042RzVL?=
 =?utf-8?B?Zkt4UGtZSVc4Sk9MWUpHNkhBNmxZMTVDK05xYlN5RW83WVFoRlR4d1BlZmhW?=
 =?utf-8?B?ZStzS2pROTE3SElYckhGdStVSkh0aFE3K3NoQTc2ckp1ZlVhRmVBR0wrd2gr?=
 =?utf-8?B?S0Z4OUllZTM4ajlaK3RpQlh5cm9mek5iL1VFWm11SXFUSXhyMEN2clpNVTcv?=
 =?utf-8?B?aGc5aUxRdTNyMm9OWFgzWWFldFFVRnlvZi9jQUNITVM5YXNDdVcxeGtheVdQ?=
 =?utf-8?B?aHpEaGQvSUZ2ejNUSFBJWHArTnYrMHZnb24xeVo0SWlMS2w0RXhPNkxNRDcx?=
 =?utf-8?B?TUxhdjlQL3BlQmZ4Z0tSYkRmVlZHYWdYcVJPL0o1QjFqY3Nxd1NyMEV6d3pp?=
 =?utf-8?B?R2pyQUc1YzBRNm44QkVjOWIvbm1RSTlsS241ZTl0VGI3WnYzMzIwTXBOd0Ro?=
 =?utf-8?B?UzdRZitFMTVad082NmViM0Z5WHpxRnhhNVR0WWx5QXNPNDJuZVNwb0piTytj?=
 =?utf-8?B?SWc4VWtIanJYUWlqT2pFVE5QVUFzQlpUQnNMTU1IaXRGWjlKcm00OUZnb0VR?=
 =?utf-8?B?cHJkOEJ2LzhlcW5HYzFnMW1LZnhLeDRyeklQRXV6a1c3K2hPclYyWDRyWGVQ?=
 =?utf-8?B?d3ZTZEc2VUlhR0EzK2tDdFF4UXlZdi9OMi8wR1RXbGE5aGNaVkJFNzdoMHk4?=
 =?utf-8?B?ODF1WXhRL295d29sRU1mM2xtUVhSTmRaMnRSL1ZkT2J2bG12UHVsVW9FL0R4?=
 =?utf-8?B?T2VuOEp6bFJ1MVVKbHF0VlZzK2RYUjlOemFJT21mdVg5VmFmZ3RyV1FFaEFa?=
 =?utf-8?B?cjNtL3ZxcHo5SDB2am0xTHliemFBVEswWnAxWVRFRjA4WDBBVFk5ZmkzSkla?=
 =?utf-8?B?Q1RoeDd4M0s2SGJpeVo5cWdteE9sUGg4aDBjcEFIK1pUaWpqL1RReGFrQkhE?=
 =?utf-8?B?bk1kYWFObDRSc0ZneklWSldPWUdwVVhiUHNGZFlRcHRVNWIvVTVhR2kwcWNP?=
 =?utf-8?B?cE95UTQ5dC9mMnBVUHdGa3FrNWhuQjQrUWt3ZlhRd1BWUVdldlZ4RThhLzdl?=
 =?utf-8?B?K3VudHd6WmpldVhPNU9nd3JkOVRxQzJZbjIzcGZZSUgwYzRMZXpXMWYwZ1hL?=
 =?utf-8?B?b1JYVjhtZ3crVy9xMmxHSStnYWNiNy9hdVFJNnkxYnFSRXZQZXlIMGJ3WjZ3?=
 =?utf-8?B?a3cvTHUwNkpkenBMR1VPRDJsZ0ZYV1RRY2RKZS9hRDJkYWtub1ZTd3lYbGM5?=
 =?utf-8?B?MEJCMzdEOGhOYlNtNktSU2x3TklRaHBLYzV3QW02RWcreFhkTldKaTNnRXN5?=
 =?utf-8?B?V1Y5TFFiWlZIMjJZU0dYblhSSzJKWCsxWkhzRkxqdml1V2JHYTRwckdXTGxJ?=
 =?utf-8?B?M2FOcDU2SEpLYTlxMkdxTm5CRWtteFFNQVB1S0lkdGVtbzMyeVIrUjFxVkww?=
 =?utf-8?B?OXgwUEQ3dmRXY3I2SG1KeEpNVis2eTViTUtFejV2VE9xQjJldm55Ti8yYmpk?=
 =?utf-8?B?YlkxaldjeEdrNHRKS3JWMlh3OHdSMy9saXhrSXc1Q3VSR3BDYnh2SzA4blBu?=
 =?utf-8?B?NDdHeTljRDZsWm5LaDZ0Tmd5L3FDNzhTcnlnRTNtRENrVHg5bXp3SGV1NjJL?=
 =?utf-8?B?VjZtTUI1d3BFcU9PelhCelFJaXZhMW5kRDhVWHg0Snp6K1kwYllKTG84cllW?=
 =?utf-8?B?VEpHZnNlVEJsZTJidWZjYktaUnVlenZ1MW80d01oaEJFcjBNWE1YeGY2YjFP?=
 =?utf-8?B?L0g2d2NUdjZoTzZpYldOekNUQnZNTkRQVllPWmpkUkVrNDhyVHBXTkpNZWoz?=
 =?utf-8?B?bFN2MElQNkEvUFBhRlJpc0MzYkFGZERHYytLa1RvQXAxcTA1VS9RUjlVWVA5?=
 =?utf-8?B?OStWWnltUVlyMEJ4TUZ2elYyTzdGSzJEKzZudzh6WU82cmJGQzNQUitDaVdx?=
 =?utf-8?B?Z212NzU1SlpTR1N0L0xHUnpiTmd1RTJXdDR1OFRQc1AyMGRESzFSektBYnp4?=
 =?utf-8?B?NThldUF2Z0JZZVhqOWp3UlhsbWtkK1hpdXI1SzI5ellJRTRQOENhN1hxcUZm?=
 =?utf-8?B?MDVHRzRMQ1FJRVU4NnJHTXRaVkxqa3ZqYnRZR1hrRnk0RE52N0thcHBQaE1q?=
 =?utf-8?Q?+uojKUpQuq+9h9iI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PjXYIlgPgjy7Yq8Ci6Ftw+6HiMDtVSnljRlL3M4u2Od/1LiKr4kcVyEZPTGj4sVg9QrdW+vJQjh1u8qpVhooFKbs/RcUl7EHMFKHh+oX8gZIQjLKGLLwmaI75qTc4IcTFwL1PkvxjRs5MB0zIaR/6U6uGBamQZUffPuRrcZcxyvAr1OVLhrHIGcc4wHEMYwi2uiCbB8hkElxyHg+dQ9XhTFp/ukj4ulrsESFDsUYsP95+tT4rapxqxV9zzJCIzna18ZIen+McBlOEMNkxSHejCc2aNVLOWKtNRaSBrOPBwK2DgKuWUQhpUXNO4iCrYxOakvf25LOb+GoWmcWZLI7Z6K9kLHBFV0CARQamLo1TpCDbO82Ybg5NH30LXDk/Ms/JP42PIdilGEJ92aPmlBDeypdzYOgQSmHE3QDi+vysv9y9tCwJhytSle6OVmnbpWl1wQc+4660DM89fHWm9DDcRMY1QMBNsz2l0kv8c0pECKtmtVGCSClpUWZ3PULAk9z3lB6i5f9f50jKtEyiFDthKTreCK0zGddq8iE6w6z3rJ6ZgnWPghAAKp617hV5QBy+4yrnvgIBlVndAe+hMZrMQerWO2653cvlDAsRkgfJIc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be037cee-4ef5-477b-cd0c-08de4d2cd773
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 14:06:52.4661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K7Sfavtun9oXVdgyeTjDWplfkJC1HQCPgoHzOJX3yLi3L6O4lIOobAtQE9R2E8peAULkfQ6PbriqxYhck0yb20IphxDogrBCPgR8w7Fow5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8303
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060122
X-Proofpoint-GUID: wcOyv6Finy0Qm-564ipRHXruH5Yn1URC
X-Proofpoint-ORIG-GUID: wcOyv6Finy0Qm-564ipRHXruH5Yn1URC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEyMyBTYWx0ZWRfXxPgFBMN8ladI
 +Yqn6HbAOnpsXlTOAXdI9xQMlJq2XG3/JD9/S5nXmzHrYTvhHQbQrnvm8XCnpZaru0nZ6X0h7ve
 DR+l3mg0U1FkkApuoVED4/IKdjyh91b28G2Ffaic2D27W5qAiLY/GnHdE3vsPBkr7LtWs5G7g/K
 lhA0/3AVQSqAwDjj9bE79kSLwRjTJM8kCGFV3e6frfUKjUqugtGx9DMjD67A7WB6GL9aaxz2DTk
 2bwD/0M1sTcDFih1Ya0ORxhX8Voyb2Ur9kBnjxyq28n8o8GydvVp4o3Fe1UvRPx/bCQQsVcDGrC
 jYB+NoBTQrHleUJsSaxu6uVjrrW1AGaAqhIiiuwpxV7mGvf/CUgOKw0qYhVjc2g1/aqByIWsVuo
 6VKg7TJBtzabcjgh38pDVy7YjZa9edfWKeISYPrxoF8uAQ8t5/UUMFC9F55o0LcJXFhKCfcFM1G
 vUSfPwZT7A3IvnqFCjg==
X-Authority-Analysis: v=2.4 cv=OKMqHCaB c=1 sm=1 tr=0 ts=695d1700 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=D7MSYEUSTs77nSsIx8wA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Stat-Signature: yqi48cx6qwq8p8acib5erpwps795huyq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2FE5B40008
X-HE-Tag: 1767708422-83600
X-HE-Meta: U2FsdGVkX19Tt69Qi1RJCVHJ8Pp2wOfbNR7x4occl7pN1u1Qa7bfTXCznMwpfp5uUZoZSKQn+Rx9Laa242k5PjfPJ0Kdd7wE+k+AIfFAoUcp2mr4lozVWHDMhKg5IxyeWPVvU7y1bt385iYsq/YwWidLQ+cxREUStel2jTJhVeTv3G5+dz9+TYmuZXgXNHcLzyIYsC5d4h4Edv5QJAf/ditvW3XaN56c76Kkg3voSyRuYhNYFyjOLvh5YwTZURMFWWMpnhu/c9G2SjPOlQVUrVdiATr4KoO8M/L0nkW8p79U+FKFIabs9lg9NXZN+ApBPD4Xc2RMVSXPCubyBR/43ZPdVAbHlMtEcMpqa/wJpWjZ/D4+xGG2yxaZ+71oK1/1s87Ib5GuhoXuoC8q+j+Ut9Dr/TKXW71sb7SsCczo9AY+ba0RANuMuS7cfLMqgTqjpMjoPDQItJ8bdALDtEN/a3Ne3KGaFi7s4Zq80NLxBWcvuRkNQRW4y6+fxCW0UqzXZjV675ymXWpVmEtQAYkudSs0qVnO4t7VoG7d9TDjUV3pBzYmh86SdrHUY48dWtgpIUDVdrOxMeuxRAQYRJ6z9SOdvBMeGSfwSmZD+iifE6rVyEcYZHxireysr20GYiuM7TwSJk2NPzpHcLL9gMeszjK0ybvciy++GscFb31pCdU3Q/WQwwCcXD2LKZtNeewu4May0Pol2oWHh6zZc/SMq6N/Z0y3Dugl2qbudJj7w73X4KcSmL1OzBv5qqYWTIjtezFMyqoPEfM7qfSR2I9jxm5ZqSFI0dSS59NyWOgfX5gMRBAX51PWwDP/d/wKHRNW1chBRnJ+6IWOXkAzuBlF/hpwet6ebv+v9YcLihWfb1NsRzQiKdam1ykd5T95tskrHCuNslxQ4b0bS+Tb9zDc0OQMprArkFMc1JcRRUV3HSdgZrvWnq52FpzvGJK2V5HW+V4Dkb/ac+3D645F1NZ
 AUcUgL2J
 jMS4oyuJa02K7tikpZrdf3yjA8PTfHU/dv6wt4vYzKM0iScgl8nh1Hda0+Ascz3DpSHxECy1tyK93rDQHN/TRN5LhCv21G4Tze/TfmbJwaAv5lOPCDylXptL/mt8utmOQS1/yShNmj/yJ9VI8E+MMPWdWLgJ28xhGegqa00wKRAlDjV0m9AJBxeqRJtlK45tXPPjiizTLB1t5t6CXojGduEyqLpV8oUO9IcUWBRt569OlVOPB94nEwOoW2BJ7KP53jAOJHC/VuxLNRqKXwGUaR1ubd8n/DlihKqE9a2PI0S0zkxHQoJLp1LufOu+cG/rflCPdx6kJZ6EWlR3cYTyLcn5obF5DSQDH9hN3ZYFxSFm/gElPs8axKZuPAK6gvyDPeiiwhm0slbBCt49ds3gKEDO6DG+GdVT69ibeIfV+rvKuc80alGcxc9xUt7Qp0Tn04ZQkmq6wH+aELvFJJrBmYG4LXY/WJy48WA10vcSAXqCFOxsJ25iXJrK86VIHA22Uq3JWHZmRGBGzbq+mpfCUIJT1XPhvzVE7CjaGFMM+De/+r5zd3qEAuBB96+uM5qUN2TE5HWZSkra55l2lf/B4KK43tr9snwSpE+ZzYUImj69Rw/HeunnxOY1QagC8j+bvkIfHVnkTklEy9SYenoFzSL3nDjOwShRmd59VaXkdJjEYBFooOv7jbXX2YCjrgYqE++ON6XuMTsB9ivt4eWJCvT97sa9uwkMCtrjhDaJPadtkD5Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 11:50:34AM -0800, Suren Baghdasaryan wrote:
> On Wed, Dec 17, 2025 at 4:27 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > This makes it easy to explicitly check for VMA detachment, which is useful
> > for things like asserts.
> >
> > Note that we intentionally do not allow this function to be available
> > should CONFIG_PER_VMA_LOCK be set - this is because vma_assert_attached()
> > and vma_assert_detached() are no-ops if !CONFIG_PER_VMA_LOCK, so there is
> > no correct state for vma_is_attached() to be in if this configuration
> > option is not specified.
> >
> > Therefore users elsewhere must invoke this function only after checking for
> > CONFIG_PER_VMA_LOCK.
> >
> > We rework the assert functions to utilise this.
>
> Thank you! This nicely documents vm_refcnt attached state. Another

You're welcome! :)

> step in this direction is adding:
>
> static inline bool vma_is_read_locked(struct vm_area_struct *vma)
> {
>         return refcount_read(&vma->vm_refcnt) > 1;
> }
>
> and changing vma_assert_locked() to use it.
> But I can do that in a separate patch, so LGTM.

Right, yeah makes sense separately I think as this change was to allow us
to use this for an assert :)

>
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>
> > ---
> >  include/linux/mmap_lock.h | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index d53f72dba7fe..b50416fbba20 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -251,6 +251,11 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
> >                       !__is_vma_write_locked(vma, &mm_lock_seq), vma);
> >  }
> >
> > +static inline bool vma_is_attached(struct vm_area_struct *vma)
> > +{
> > +       return refcount_read(&vma->vm_refcnt);
> > +}
> > +
> >  /*
> >   * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
> >   * assertions should be made either under mmap_write_lock or when the object
> > @@ -258,12 +263,12 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
> >   */
> >  static inline void vma_assert_attached(struct vm_area_struct *vma)
> >  {
> > -       WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
> > +       WARN_ON_ONCE(!vma_is_attached(vma));
> >  }
> >
> >  static inline void vma_assert_detached(struct vm_area_struct *vma)
> >  {
> > -       WARN_ON_ONCE(refcount_read(&vma->vm_refcnt));
> > +       WARN_ON_ONCE(vma_is_attached(vma));
> >  }
> >
> >  static inline void vma_mark_attached(struct vm_area_struct *vma)
> > --
> > 2.52.0

