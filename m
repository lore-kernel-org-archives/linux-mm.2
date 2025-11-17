Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A338ACEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 16:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34C78E001A; Mon, 17 Nov 2025 11:05:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0C338E0002; Mon, 17 Nov 2025 11:05:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3638E001A; Mon, 17 Nov 2025 11:05:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A50DC8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:05:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54FC61A01BD
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:05:38 +0000 (UTC)
X-FDA: 84120574356.18.8347027
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id A3B6AA001F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:05:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SL55kU5F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HKbmnYqJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763395534; a=rsa-sha256;
	cv=pass;
	b=4ejUjCdLKgXoaxf2yYgaoMNGpVYB79H1e9dqABacOopxC6NLdu6IRS47GFXHF4mFHvhbAW
	Nn60lKbarbRF4qiSct+Iqw/mrFojMo4P3WVVfmq8ZZWArW9gop0iBoPuZoKOzr1nww/1Sp
	Qmsg9fjbt7T32N8ufRzFZDplRKnNb4M=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SL55kU5F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HKbmnYqJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763395534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQdGAQFOo/9Slsi8qLJSDVsJrPzaKeufnk6iQmYarKU=;
	b=Tudb6hYS6CTJytF/TWQepEO/GFATbIeHeKLhjnzwm+Kz2qiv38mP02VaRxlIdxCkVrNRMr
	dPvMXA9klWMOgjPvhwbjHlxVawKixhtGQ2Eb10RCX6tKOo4ttk501V92TYDkIE+znoJ9mU
	CwVEkQpL8+yUAmf0YD+9IBIuDI84C9I=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHC8UwK018673;
	Mon, 17 Nov 2025 16:05:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wQdGAQFOo/9Slsi8qL
	JSDVsJrPzaKeufnk6iQmYarKU=; b=SL55kU5FtPkBlie0GfPGoBVoFJdKwMf4SL
	+nCm7BzYGdyifNqc+tRB+WkN9mfn4sMQHEKBkgXnu0UIMaN+T0lFDiM+Xv2mcAQB
	4++dpu/LFjob7xcPq+1QK7yFz0ITrityc6g535rhyju0HJEOhm5amFy8HrHGCApo
	/RRjV3xace5WF1yTa6RSPO7UeU7lKIZlH2eLpKjQwEiDz5jxQwzmDAS895WxR3yi
	Nb/Ggcbz9Z3VHUUK1IqRaZYf+U4+9N/MHGY1lIpmHgGiXy1NZpKSyka9MpfFV+EJ
	rfp/yX00insLRzaVNEpHzYbft1ThnIf+NxBa8+RR/YWEPj5N+wsw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbptrjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 16:05:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHFwmRZ002488;
	Mon, 17 Nov 2025 16:05:29 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011058.outbound.protection.outlook.com [40.93.194.58])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy7vpca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 16:05:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=siIfsoY6YudnFx7ejIu/UJTUOkXWdcwfKxItBzMvZo4MJ/A/eh1hp/QYYvio3oQ/t9Huu5yjca33PT2m+/U8Ef57YBmgLwBv/1/0vQgBm4AuWGqqjNHMMJzSckFcIHJn61OczY3HFSkYKslqicVDAKXHYZJ6fRjZcSfeL78wUykeCBblQstZUBglj5JrfosyWyFAlaebVbP8XO9ogJjrFXDCX6aoMzm2tpwcWxAciG5zidpqkW8y3UIY7n1wMshrF6kyh41MSTwCcyCgrg5+jBYaDgBGgPO1Gc7Xnmx0mqnWLcLpGdYX3UhfyHRE1bM2zLKUTDF14Ep09KWOK8EsqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wQdGAQFOo/9Slsi8qLJSDVsJrPzaKeufnk6iQmYarKU=;
 b=HLns6N0O9WaFPwHxo6AlhhepnizUCRdm/N2aHlQjg1xdU1bhcVXZLOur0sJkymaSzfVocYbSi6MQwoLTTDcahn+/Hb7pLu13Ph0o37SkDN/ik9CMH3KS2IYW8DSI6rEDX9Irx2zfhzfi+Yb8772Rhk38I5U8/5GUyL+LB5cdQNlD/EE0ShETCWOYPPNtJHISRM2rBh92VXD7YNguay06LRuKuFCka+SknBhgtBaWnpvdh55kEQa5CEH7Lr47IqrswKAfFTRmdw5ShPXkAV3t8hiyfzEk95dgVt4IAORK13/WKekUh6rdvcIGT9VKVGxy6L2LQrrUPZaJnX5hf4kfwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQdGAQFOo/9Slsi8qLJSDVsJrPzaKeufnk6iQmYarKU=;
 b=HKbmnYqJSmwTkN4Ht8xI55oa0UWlVUr7U5dIYldZB2YFGXRJikTm4Fv0JrmSOF8uokbOpohnCd1jqKxJ27iB6bZ+3OGiYuDAPwCjk5Ymmk5ktcBtr23kY1+IZf0cRTNOpkhnb3SPnlVTn5tKBCMlmivXs9q/beQwA9zgG5KfLpA=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH4PR10MB8148.namprd10.prod.outlook.com (2603:10b6:610:244::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Mon, 17 Nov
 2025 16:05:24 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9320.018; Mon, 17 Nov 2025
 16:05:24 +0000
Date: Mon, 17 Nov 2025 11:05:21 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: propagate VM_SOFTDIRTY on merge
Message-ID: <w54nwl4aspss6475kyu2gc6ikpbotfuysja4xr5atyo6fmzjmq@ui2zsjolkq7w>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <addc338c8b33aea3c31202180448ea32ef37956b.1763142412.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <addc338c8b33aea3c31202180448ea32ef37956b.1763142412.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0264.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10f::25) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH4PR10MB8148:EE_
X-MS-Office365-Filtering-Correlation-Id: 221a1a75-73b5-4258-60d8-08de25f31de8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/+Mw1KEFellJr2fjTBkbXgzLtdVAU/wBxH6HPNo9n5LKAAkZV8i8zgOHcSj0?=
 =?us-ascii?Q?bEF94vBcjomlQ2KE9O760mN0AUG/gdRycUTTVy5WIDyRN59ehqAYBoXWRFSx?=
 =?us-ascii?Q?DkAtNb0G60CiDzj97/8ZEw06QltWmBF/Sm9KxrsJldYduJcOtS2EY5sjEhUh?=
 =?us-ascii?Q?9YdUq0VyupRnPjaecRSpuc8qHr0afefhZqM5vPJF8LcPxg1gVyzz6NGwLVUi?=
 =?us-ascii?Q?n9drJ3iVbidZkSfCuzdPf0mlOeeBki6zkKfD94yCIA4gFxgp1rrQ8qvfsQtR?=
 =?us-ascii?Q?b/3339ikKyYdqR6k56K0HWdsn0TFf+XXUX5OWOZXWLb7dUUoBLzecvkaYXYa?=
 =?us-ascii?Q?r8SFHO9mH+F5I9o6RtYrsy/6lwckyprCZRRuKJiX+qQOt64ZycIg8lT9xKtb?=
 =?us-ascii?Q?Wew/mEf3MBSFlxOA8B+buVNpBQAEKelP922t63GIzWbxJaX9XsFu0c5e2rJT?=
 =?us-ascii?Q?asf0aLuI923pMHgrtOZnQ9L1lQKXipczOayc9Xd5Igiz9tzvU5IDJ5oP9SNM?=
 =?us-ascii?Q?+KifpgFzCWbFydbyzxKQxjN9vNtIMzao/0pkonM92bSihafph8+fRW8QCFVq?=
 =?us-ascii?Q?jtuzR5f5FMCHJmYpRDIScJvLJokObQ1nUi4MaeXZy//S3srDr7Pjr7LCyD+D?=
 =?us-ascii?Q?xn1r9iZCaIzM3z3qcD9jpH9/Ie3uaxasf/omuzF65/vK8gnP0LzstpExSk4F?=
 =?us-ascii?Q?T/2qNfqCV5JBnsxzU0Hk3vRx/mnthZZdtsod6aHG6E8gCsS6vp6EBPWi/WJr?=
 =?us-ascii?Q?tmUZvTnyVbNhs1o87lDtNdDHW8A11iFZeweDoZDJ8qkVk4xzH6IHSHUvRXoC?=
 =?us-ascii?Q?Ht7VELmnwLCWb6L0rRdHvgFI+aMpX+BIIdcXhfRoB/v+HTCxLfiTGF5yRbGO?=
 =?us-ascii?Q?0bF2Hk4BFzaKTyu3hwlmfS2F2J0SYXVqAui5s+HmLLL1yFutgp5qnVj3Ea4U?=
 =?us-ascii?Q?LmAJAI74r4RRmGuX7Leh0bcCLLmJUU2VykyzyToU3/gdsMKnMbntb/KzXk6N?=
 =?us-ascii?Q?BcdUOy304ZCdQF2KKoN0pdJuA4Hkq3T4cJPpM3V1S57cSDcRfrsjxyAK9YrE?=
 =?us-ascii?Q?f+H0lIXYe+r/EYkSuYdJbtMC8BgbZxSz7fND0huh3kFm6t9Iy0m3DFsp3kSO?=
 =?us-ascii?Q?laKJU+stVoe99834jPOnE8wnYpGwBqlMIxu422PpGKqBd+aMrcsEvKT/o+Zm?=
 =?us-ascii?Q?Kj/d7M2L6p3IELnhjkTdmOzezbsLFdQ+6hLR+lvb78VvfVKI86CIsJrrKG/z?=
 =?us-ascii?Q?K8UppVfEhirgFPHzhd0qA9dsc9wd0hVxbql0LE4/De5+9dkRzSM6jq/Dv713?=
 =?us-ascii?Q?rqwitW0ROPWOI6ZLsnXnKe5mC3BPvJNWdY73Zgb/rnKkWwpClqiTTvMRqQVc?=
 =?us-ascii?Q?y4vzfB8Ea+2/uG+a3zBGZkqXZ4ax9vPktt8LSXGgquiLP1QgrfHyOP2wZ3ZZ?=
 =?us-ascii?Q?Q50s756CJYjWKK7t4PjwRtYHdiOzBGm6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IUriStBqWEP08QBVTe0y48UH4VXu0/kcZfFMSWN9DNm/mhP0HQqityHEftsK?=
 =?us-ascii?Q?XhTmLRyJE1T6HD/MbmOT/NOEW6CSSid5qaT7y11WUCixVRKoWgaGkBeiuegs?=
 =?us-ascii?Q?frVABES6iOUm+7x3jBjpCutXJ+8jufH8GrjQWwUVQqP20X4XY9dNHsni9oDe?=
 =?us-ascii?Q?BzwIqvtqD8IORN8+hIImvi6MzC5u7gD5GA/85NYvpHEnZLoC1EVkzU99jqHt?=
 =?us-ascii?Q?IODx++OQ8onMHjp/D3vbrnzgZImpxioC/NB1JXDy7zbNTB5tjopGtl/gcQ6h?=
 =?us-ascii?Q?G7iKTyx6GxpqN3gDYdWfaWVs+5UzD9wI5mvnjBzDwA2esp+rNXbFFq4AhWM2?=
 =?us-ascii?Q?/DhkmQ69cG04c1hfqYH6Liy3bqSw56rD4F1K7eYLFvBDJ16xNuextLsZC8BP?=
 =?us-ascii?Q?WuirubY4oKgcSTjgcTyvpUjVcJPEQBc9wzqMeqZqHG9eQ7cR8vMxlRGyn3/X?=
 =?us-ascii?Q?4cd+/T941xddmIYBU+dCexiCUUbwl0focpHInhw/kJ484oUMTB9O+YJFqcAx?=
 =?us-ascii?Q?hPGzHaQBJWWwY4AfigwDNQ2Ezn/Li51/59c2FG6FHyMQCEwe0YZI2ylwLTqu?=
 =?us-ascii?Q?i1iea/Cz/3N4OWsP/S8GUSGWEzSbqF4KkDdmd7hB3OUQWVC6dB/E6OQ7sbYV?=
 =?us-ascii?Q?UyIAbSiN4Q7MwStaLxNYPax+/R1EstKKJeRCcB/Q5DDhluNOA78q2I4MsagJ?=
 =?us-ascii?Q?12KxZauM75dikp3x6dBo4tqNqBzGW9XOEmngITXMLG+hu+elfQopGyXt6kd9?=
 =?us-ascii?Q?UMx8WC2Paj/6X+6DusBquP6m7ZNQm305+DUtkOlKmIleupkhFQLfiSVelRYI?=
 =?us-ascii?Q?5FQMP0w9M9AB1vstZMpqMxMIhGAH3CE19ey5uVHy0icgTbqSbs/rsydReIWN?=
 =?us-ascii?Q?zpIAMIQRWvM7tXvJbvPeiFppngcR8vYXdxLVhbeXg0WEPp8rZcPC2Qf8tM5z?=
 =?us-ascii?Q?Qz9ZYpsHHUw+X/wEQarPS8X520xaZSYqyYJ5JNMXydnVF9Tt8BYcoTVsYwqU?=
 =?us-ascii?Q?sK67iyHvelS3/aY+yBZ4HWSquuoP/CaaYUjk6g3jFp28nAlMKcFO5dUdNanV?=
 =?us-ascii?Q?hmGHMq+0/bo7ESG0O2EN0/rwqXFZfeTSBDrchlsiJZSJytruJ9dR/+6AP+IM?=
 =?us-ascii?Q?fROyBuy/ES0b3TfWjG2F7ykXjzrR2jCOMsSwBEpzlWoNL+y3gqowjyjo897w?=
 =?us-ascii?Q?cweSQtGL9AHOCx3oph7q505QADL+q2XcN4zC8seCbiXGxgWfcPZg1cT4eDts?=
 =?us-ascii?Q?bnhPzEaBHFIYs+6PUqwPAkQ1Ve3NPqfEaOzDIZorKkqpulkIw8mUKb1bNcpO?=
 =?us-ascii?Q?CeTo86yGdQCvy5aH428b/Y46U9V5Ycgh48A/Yyh4Zlr406m3kSNSJmppbRHf?=
 =?us-ascii?Q?xyyvex3+3bx6YdVrTpYw0RDgr6qXOXHYOi9V4d+/+SegJeprXN0CfOU5gSiz?=
 =?us-ascii?Q?+jPRTa8MNzv9Y6LQjSbvC2Nbve3YRXtWJIXcErqiROBD24J+5xUYSZNMgIQr?=
 =?us-ascii?Q?ZIIS4wK3szmKQsCyF9JBjcTtN75wVJUAXe1oav7p9j8PXJStsOpzXxzw/g6e?=
 =?us-ascii?Q?HcHyJUA8hYQ2fplbLb6bZQ3iiDRVM2EwBjDtA+Z0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PWew14bO75XPm8MpRUgsj1hYRt4bXOPeZHhvlmJRc44U3xjjGX375ZOgGMAIH4Un8ZzHfi/YhrfbQQMyCgT2mQ7jL/zR4mZ/vtMR+5NZE/IkTAkG1tLLM2JzJ/oRLF+tEHNNG4pBTkRbV4ZlrUXpVWy9bpCEwd671NE4VvP6cNfTkDxLyyFClk0n3dYbJM0+md3uUPG4AkYtfcjq2IoK0RIYgzHqDmb8j/vhUiUaOrfBMQ0JvTyFj3WBcXh33VjkmHH+ibtAkMXxU9c9AWzbaf6DWwM6Q3b8pniCD4cp6IM7Aw3Dhn/mw5YRObkV+eVALQ0vwOIRdWHrzk9xQqaHQC1P3WK524WVdvwsmFqjRlwBQEaANFFunVe73I8vGZeSe4AWbEiR0Rp4cse5C5+ujt5Gxfu+jb8Wt5fOG51Yw84dp8s0ufQavlrfB6pvzmeUrTlZ3rkS03tkW/jp9z3k9dReJ+FpnJXl16H8TUKvcp7ufOkql3EbkT3aVF1PURm1a49nMmdtFJTF9HCCHn/rnNZzzQCxkNJn5H0fnMnyoFg3ny6fKnsjvPIb3NwsVsbQpUthWVGJI0yJmkbcRJ3wMIH8f1/oQOcqArqBkq99f9I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 221a1a75-73b5-4258-60d8-08de25f31de8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 16:05:24.4129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWGDDDLIPblqFAl9F2d6e7RWw+yvsUb1/au/SCM/78RDvwTzQwGJ/sNGWuLh35hESe54tCDlVVeAEB0ZF0jcDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8148
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511170136
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX+oVuhTaelm7Z
 PnpvxfDoYm7GXmxBphNrJ6H03rv6DQlpEDZKmsLXh8En5NJIq2z+ihGArdQeInIc5cwUjHVCmSP
 Lmm0iBMWQbENAr23QoAkvqQuZnzly2KAomUYmoUpOHFqhDEd7K2thoWJ0xKxeM5xQ2xtrwB54ba
 jMn9TOW8K9Mbu3c3H42mL2a2KPGvB1AYtVBAbzgnC+x9Q7nO6HEkFJTvLxXxs8kGCeDdfYPQkkd
 x14e+q2+2+eN+X5DeL3koLTAJk6StgXhlZ0ziJhwxfkt4emJrzhVHMzvXkrEWr1XRVy840zFYDg
 HEMetyTmW20nTCCdMda4Ph8wIiaXFTFu8gWh6jB/GK2AnxLVjVGC4XouEtOfEjwRgtYLpm3Ubu/
 HhoUVdepEeWQdLNWQ+dXYYjFmhkUPQ==
X-Proofpoint-ORIG-GUID: F8VjluWk9QMqdbSuB6EOsbMGVlIBYjv5
X-Proofpoint-GUID: F8VjluWk9QMqdbSuB6EOsbMGVlIBYjv5
X-Authority-Analysis: v=2.4 cv=a+o9NESF c=1 sm=1 tr=0 ts=691b47c9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=iQW6Zl1UYAPDp3XnM8cA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: A3B6AA001F
X-Rspamd-Server: rspam07
X-Stat-Signature: 1yx3asf5k97ihfuxnyz4ap1wggmnikoi
X-Rspam-User: 
X-HE-Tag: 1763395534-458014
X-HE-Meta: U2FsdGVkX194Pr4SKSg5JxDhuQVqcyeJr33EyGiBbg1/BaYbK+4Ay5+V5CXYuu7qhIvnhtM0RpNSlsCOxHTbZ6hAqPLCSd3izJbPRP+BRZIO7T9RoE80NqBTxDCllnomE+7qR9Ca5MxeZPhmEg373Qv9ziS+N4eJElMmBs7xebsXwnjEPsMlkbnEn+1b/n73waujrTV59F4dVCbIte4BjON4iNMka+qCV2sX56Eo5z+9zHv56xnXlv1nfFutgQgpVJTdTFWcA8PHcWhrhSK+UFO8nHYyFHPGEmW6unFoywkuTxDSBG+GnjcTRi4U+AU81zer9usiWt9Y3fdX5VAVtK/g0GbjWVuJfDkCSv8GJ0qRKVLFDYRo7pgvJvfhoPfFrBDYUNzMHTFVBke3d5NUmV16xLVNwmA8An2W6P4/7ZYAmcdqApkDYdjo5lNbeqEXGC/YkohS1pWyY5lEl8UTYPxsHVQFFCd4Y3o6t8m1vn7HlIUHfRoAvVloejpv7lopZwYviT/XIdBqDbWPRshUvR2Xkt1oq3QTqkGHNr2dahs7CR2SXlL4WcSvYHu+6SEA1VvV9roQ3WxSBiYqd+Dn7LJhOUfR7zfYXY3q2Gcqd1j3L21RBH4MNPB+6LB1nTie2rc8Q+t7IFyve6BeaAEDSjGyf/UbcVk+f92ZFpuTSqitXJXj1PenlzU/afja9wc7THnLCTvLZw7B4EvNUr+CSeZLa9jxQCo8IJoWN2XfIiVidSibuLGe+Ss8AwKEkCfkyOuVM68TBU+dlii2di75oXY7dNQ+cH7YRemWcuVsUGaj2cxv8lImmqjJ5OlbBzgCZiSr7DHJa+mITYpDKPERU0Zw4QiggCgMqaXYnNt6vLjg+uz0JZgZLVRwNmrSl2vX3QQLyV4kI2DlGTfxPSXKODx+Rmy9PA5dLsJge8x+xtAd6dUSz9j/tOqJNPWdiUKlaiFlqqbLZUnpRGVpjQj
 l4TVF7R8
 ZD2TydoqydfPN3OKe3NyJIwugYEo+/mRtsIoe/w/mgVDdAE99ULKySv2BZ9JZElqxnrLs8RiWkQbDoiJ3jl6Ut/MKCV0BG08jEE33AwNFNMXRumFE8wJNstFYRXoNOazgtG3egad4gpkfaVuJq6szs0y8SVbj/ikrKJHjE+wPNWXTRwjLhHKscSvM9jhEpIkwhZZmrbBrPza2B9oTXM+9raL3GRq1lDvAgST51AmSfW7JnTOHv2l0ukCjFgXMLd4YOYBZIq222Sl3FRC2JHG54UDJGuAHjCORhhMO05Vvq6Kzwamb0cSx39v5XnSk0RSRjZb+PfzocMnAYdhFlDBecoO/VA4BuEYSAWc6ob3sPfk/yIVHsEPBPXl3qhKjHDQoVO5sTvCaPepCjI9dbXBxR6K7s7rth9VS2sOCe2kdmW4ttdnvQBd7o7mN469UNA8f68akfsAM3F+HjSUxJVcWwFj8XsHj5VXt6EQoKNvtKBzsQX8zPdQMGUYHpgKopJBq4w+f/MZbI+DXUyUGusvYot7UdJrXdKxCazfcVIzpdpa7VdnIHDYh6BLoBXByV+iMSUW0Lgis5gi3z3EJvU/3d6xhStc/VHIvWktbuv7O79ngZXkzuSsMuqd6XtyBJlx66HMgL63qORhFP3rx8QP+xqYZWJSCDxlicBD7FEXRM+VYhHzF+XU6xLdcdnc1NU2cVMggkOhxPEeKAR0tK1tXf4bJi4KSY+RvQ7BNBIZsO53whio=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251114 12:53]:
> Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> establishing a new VMA, or via merge) as implemented in __mmap_complete()
> and do_brk_flags().
> 
> However, when performing a merge of existing mappings such as when
> performing mprotect(), we may lose the VM_SOFTDIRTY flag.
> 
> This is because currently we simply ignore VM_SOFTDIRTY for the purposes of
> merge, so one VMA may possess the flag and another not, and whichever
> happens to be the target VMA will be the one upon which the merge is
> performed which may or may not have VM_SOFTDIRTY set.
> 
> Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
> which solves this issue.
> 
> Additionally update VMA userland tests to propagate changes.
> 

Nit below on the comment, but looks good.

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/mm.h               | 23 +++++++++++------------
>  tools/testing/vma/vma_internal.h | 23 +++++++++++------------
>  2 files changed, 22 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 43eec43da66a..fd9eeff07eb5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -532,29 +532,28 @@ extern unsigned int kobjsize(const void *objp);
>   * possesses it but the other does not, the merged VMA should nonetheless have
>   * applied to it:
>   *
> + *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
> + *                  references cleared via /proc/$pid/clear_refs, any merged VMA
> + *                  should be considered soft-dirty also as it operates at a VMA
> + *                  granularity.
> + *
>   * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
>   *                  mapped page tables may contain metadata not described by the
>   *                  VMA and thus any merged VMA may also contain this metadata,
>   *                  and thus we must make this flag sticky.
>   */
> -#define VM_STICKY VM_MAYBE_GUARD
> +#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
>  
>  /*
>   * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
>   * of these flags and the other not does not preclude a merge.
>   *
> - * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
> - *                dirty bit -- the caller should mark merged VMA as dirty. If
> - *                dirty bit won't be excluded from comparison, we increase
> - *                pressure on the memory system forcing the kernel to generate
> - *                new VMAs when old one could be extended instead.
> - *
> - *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
> - *                which should propagate to all VMAs, but the other does not,
> - *                the merge should still proceed with the merge logic applying
> - *                sticky flags to the final VMA.
> + * VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
> + *             which should propagate to all VMAs, but the other does not,
> + *             the merge should still proceed with the merge logic applying
> + *             sticky flags to the final VMA.

Nit, could we also fix the wording of this comment when you are fixing
the spacing?

>   */
> -#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
> +#define VM_IGNORE_MERGE VM_STICKY

I also like keeping this for self-documenting code.

Thanks,
Liam


