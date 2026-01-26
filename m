Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE88D19501
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 17:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DD9E6B009B; Mon, 26 Jan 2026 12:17:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28BE06B009E; Mon, 26 Jan 2026 12:17:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163A16B009F; Mon, 26 Jan 2026 12:17:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 014BA6B009B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:17:19 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B63688C082
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 17:17:19 +0000 (UTC)
X-FDA: 84374770998.24.67C6B1A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 446B01A000A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 17:17:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rpTCq6lI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Bw+a2xWv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769447836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ziW+yJnGlUjsKeInUTrt66Dd4Un4VoDkr3Mr/+1aSE=;
	b=avt9vGZ9Gy2uA0LrTmAe4H63wmhGkEpEV2V2HrFzQc1eTELWuucCdd1yOxJc0AnesN+n6n
	+U13Gs0GYttNW8nZNJGXwD3Qybjf/3gWY5gqZlNy+n2zSkENVrIIHDFAVjfLbELVXVuIgy
	GoNxZTaHvGQ4GeXvCQUkvE4t7YhJbqs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769447836; a=rsa-sha256;
	cv=pass;
	b=1tE2b5Ar2pQdldaCMC73Fori7BuCXaI95rHwKDkAJjoWPujSAQ4Mft5RBRYuoOndgFRY0X
	d57gUrV1otlWr9Gj9Fg2PHArbZN07s70p5RTuCLv6MJ92tSPj2wji6bf8jvHMG/5HGqD2N
	n8Uqul4RDl26U3foX7ohJF4JOfgg8Yo=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rpTCq6lI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Bw+a2xWv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q4K0g3249820;
	Mon, 26 Jan 2026 17:16:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1ziW+yJnGlUjsKeInU
	Trt66Dd4Un4VoDkr3Mr/+1aSE=; b=rpTCq6lI9txIZQ0qUQ7GuRIR90KJlGdngl
	mrHZlfy/PRKrWD/+QycQAWM0lRt5wtINAVXoNCzRTn6Eldsa83xkPmbqAgsoNxaR
	RfI1+FUdPpRfh1nlokn70+kUYu5bVhEnaTSIMwW0Ztx8Q8b6Xg7MnnSvcaf5n0NP
	VQG9OvjnDrWBjs7CR3eF+aIO+wcvGvA7dZMRsC22mR+cNWSwsaU7qkBa09gjrDVE
	ez7e1J1EjnHQf6or6y8doYv2hKuYALkb5eR+AyK6I74Ww5viR4M2ANNQssEw8kfq
	XyPuMRv5Xm5j0PhaeIdfCEuhz8o9XJq+tcFGIs2QkCfpzk+e2beg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmny2bjk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 17:16:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60QGaPNM012749;
	Mon, 26 Jan 2026 17:16:42 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011066.outbound.protection.outlook.com [40.107.208.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh87wha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 17:16:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tIMOkhadTeiJcriojfkaBMXSAAzlJkjiXiuKg9JW+zDwRIEL85BzVToAF8AgKfHi4IoJe5MOXlW7SSJg0SJXxwXeDErxdPkIvszdzZOGcQa9nxr9dkJKAr5dCWULXDHlblBy0hC9kRnNq7xCzHW3p8C8gyGQyKvOkzQ5XnVF09EYiUXOJum7Af2A9UGCC0spEEGKaS9WXpPcKKjBDyLblu/2zhae7Bgmb+EjeSmtSS9ZPGgoLdGrb/DN9934fZXKJq/dkK6FClUL611soy6Z0cPmdfj84ZFOvjZuf8dEnHV+y9ji3rrIX9hArRVdJgG/00ZfC1dUMLQVNBdDk4ZpjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ziW+yJnGlUjsKeInUTrt66Dd4Un4VoDkr3Mr/+1aSE=;
 b=uZBfgPZxLvat2dpGepoV4EFglLJd6WJtMoTNNnW2wwO0Iksyn+MDYt3d1n6h8QC6+ZWOQR0uGpbPTCduCsGmXDw0gawr4LrQqH4I2QuXKxr7WBwUPN/pmtB8TUoBWccMbT595Ya8oPBgzZbb6/Fd78726Hm6950ffRz5kFc7TzojqYGLMi9zA4KcHGG7UGmyxX/0aaZhzP5/tzHCdqknrwOUi43jFPUcHfSW2b2+wv996ZxhsD6jQb9qB76905gXLKKwqn2AVqUrJ8quXMqCSpWLUGzT82y+KzzI/0wlnW3+jJIC/Z6UtFNFv0nqA9g0mK9OeBPLlg7Xot1tb6gw0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ziW+yJnGlUjsKeInUTrt66Dd4Un4VoDkr3Mr/+1aSE=;
 b=Bw+a2xWvg/C4TTZSC6bMkKcyus+Y8TqLsGDfSPl/gM9rS8eVi6EmkiAmL2uAi+0ohvW6eIQ7/bfHVYQjJTVM1k3O1X3FV57+vSxU4GMmnPwZ0dLT+hQC+JMQVu9erw77lxgsY1opj03MDuq725SN/F+/c0I/V8LMPRuY9Pe9e0U=
Received: from CH3PR10MB8215.namprd10.prod.outlook.com (2603:10b6:610:1f5::7)
 by SN7PR10MB6473.namprd10.prod.outlook.com (2603:10b6:806:2a0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Mon, 26 Jan
 2026 17:16:38 +0000
Received: from CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9]) by CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9%6]) with mapi id 15.20.9499.005; Mon, 26 Jan 2026
 17:16:38 +0000
Date: Mon, 26 Jan 2026 17:16:37 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 09/10] mm/vma: update vma_assert_locked() to use
 lockdep
Message-ID: <72870813-1355-431a-91aa-9b9335e136a5@lucifer.local>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <538762f079cc4fa76ff8bf30a8a9525a09961451.1769198904.git.lorenzo.stoakes@oracle.com>
 <6c4162c5-1703-45db-b9ca-96ecd8ce551f@suse.cz>
 <09ade6a7-0ff9-424e-a4aa-686896c9260f@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09ade6a7-0ff9-424e-a4aa-686896c9260f@lucifer.local>
X-ClientProxiedBy: LO4P265CA0153.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::16) To CH3PR10MB8215.namprd10.prod.outlook.com
 (2603:10b6:610:1f5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB8215:EE_|SN7PR10MB6473:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d5bf5eb-7d0d-415f-a468-08de5cfeaa6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?096rwAdQEBdzp/XEZBQ2FD1e3C48btdIzq508D2sffMdYbrHcHcNM7ixkwBj?=
 =?us-ascii?Q?YEwxfVBxwgFWqCB36AV8fZxxAdCps3RUIV0qcBF25n0bLm92y1e9ZrbsustK?=
 =?us-ascii?Q?LuMGA1qNcwTsVToz/TCalCwl75yezmxFnt0AAVAJW3uhB1dW/btRZ9aowxgX?=
 =?us-ascii?Q?iVML5e/QomIEYNIhcq/pQDV+jYIkLp1ii9XyoBuVQNFtQ2Iil2G6m1k2451I?=
 =?us-ascii?Q?U8vFvd+x5gyj18OYrPul/pCpNAzDvYSYs9rGUad2f822qjoqlszTdIYWfXnE?=
 =?us-ascii?Q?Rxqum8fANUE7BcGtRnMfK7x/tPaceKfneZLTxWTUTD55wxv14QDeb0PXhfKT?=
 =?us-ascii?Q?yvMB55sDxZiHLJ7tlBh6SEkjTfhMocrmWBsco1dlKKCv10REQMaYEzKiOQYG?=
 =?us-ascii?Q?FQO7aid3MVCzSeddF1jBcfaVtpV3hu/QlZ/cb2Hzq7TfjpUM+DO2teZdTHKl?=
 =?us-ascii?Q?Y9cQYX7xrRnYZc27vF4WW13S83sKyMCbptfaY3G86pJxNlqzlRrudlLqkUct?=
 =?us-ascii?Q?27XhtghoWfn2UJYJXoh2VO6lAAdbdsl3ssX0RYOwRmnzri42S9ToegND1Qjh?=
 =?us-ascii?Q?+VnE1UORyGPM8rXZZ4Rc50SbfSWu88xiZ1KO9gbFhf353EPR9INEj8CDM3UG?=
 =?us-ascii?Q?r8y5ngCd2tK/7VI7i3cUAi+mnmDyxIs+tDqg7+EpchmbtZjX3Dqkx9+Nvthp?=
 =?us-ascii?Q?koZm2+Snikk/IOT48jsCdinEa8dONx2r5EZ67WD2MFTvz1GCQCTQYaDKDQGj?=
 =?us-ascii?Q?IyJZcFjmPAffKIY4MJ6ihb0Oh+Cz2xgHxomoWjsbeOdGCTd28csXf7d3oWiN?=
 =?us-ascii?Q?9joMOA5rkfqXz7Kq4S8JFi+I6h13Jus0JYuCx2FLCxNfCoOayxJtuEgFXKJN?=
 =?us-ascii?Q?VxCTtgEbY0wB7mdBC3070iLtepTiWci32VuZDxlwOYBy1gP4GRxw83FkBbjv?=
 =?us-ascii?Q?S0XY6HsRqhTnTkLbCuZm6onnvTWIbjcwNxkBGy1d1mg17xZSlPzunjgKnTwd?=
 =?us-ascii?Q?pZ9T2gA40Dg9uQQcw56IcjKytJwe7qnIXQSdj0fpSDH5bb4UpQmy03WTtxPg?=
 =?us-ascii?Q?rpZkeTcVUAz1kaJrSqL8s/2TQBmPk7+tmrVyCxtTQZAdNX/9O7KDhT4NIot8?=
 =?us-ascii?Q?JeaK9Tevp1Hn3YYXtuMoOH0+X+PgFJoGPVz6iOOx6QE8TK/YhyYL4q6NBfBG?=
 =?us-ascii?Q?lcGZbGl2LjqycQHQTs5BnTIZldHqB0lXLL/etXLgj1gJW/8x/uNI/6qdmoMq?=
 =?us-ascii?Q?Tqgyj/KzVdpZMQVSKvWzOTFAmTAdpZmw5M6ClLlJdps3crw76RP/gqbkdubD?=
 =?us-ascii?Q?9zG8/QaQZyZKJTy57Av6DMvLE0SmTqE+Isx5Z1x/0LNFFE8+01NGJlwkcT3g?=
 =?us-ascii?Q?FfzUX8wR2QkXoFb2CriSxZ0N8fP4WufRWwXBPmQAZ8FP54HMVIPv3lUTE9vh?=
 =?us-ascii?Q?/M6AW5+qDEleblEz4dH4GC8EbqzHJ6B5mrpcE9KqLtsoGEGMd2EsHSIKTXtT?=
 =?us-ascii?Q?y0wa7A0blVqc5nFk9bQBE+5+ZDXsV4p/mI2KANGpSAnl857cEVWbwrykERfw?=
 =?us-ascii?Q?aahUrT3djgJVxs5vVOM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB8215.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SYFspq/1+SYzYv4XXYz/y1Fw3Jct5ASZQkc0zJA0htBCiwFRZyUJBKzw9ybY?=
 =?us-ascii?Q?OpgvWgGC+1xHXYMcrfLm8S0NKyYtujcybeQB7OSIjm/RcH2QkwvDTpp4eSuH?=
 =?us-ascii?Q?fqsEVHT/DZyVNe3D3g5ULUEWFGuSYkESy2fBHT/LUk0WpS3wQRn/CizT0ib/?=
 =?us-ascii?Q?702MRN1P2MQn6IhGTDWfb8Xc81LB4T+bc8uUacwqk2M4yKmicCsLy3J3iEM1?=
 =?us-ascii?Q?p/mdiozRRtyBxaV1V2F5/omIXbRmVUZUGaTnE9Vxx+Moi8SXa3cYEKSxTd7l?=
 =?us-ascii?Q?brgtp60CBfDV4lsQ3xofikyGTodm+3b0v57h+erJFQk5zYoTjaK6fG8yNP7d?=
 =?us-ascii?Q?Rwk4MtQlH1lZBlHDbWQutGZSqyLyhtAciyw7vLe2JkF6ldaWTctuqppwJhSt?=
 =?us-ascii?Q?5cwJa1CNfPI316cg+Yq4jLPNKoOt+zyuZusdttYvP37+QX7+qQe9GlAXE2On?=
 =?us-ascii?Q?x4wZ4RvjATt5RSvmtdZOvUdP/wP/NSRJhUvhSO3e7rfi0KhuA+xdrg47q/BR?=
 =?us-ascii?Q?4E4K0BCHZJttGxxFIQ8jUC4OfUdP6F9QfRvie+vrxc5WK0cty7/pgRC91jVY?=
 =?us-ascii?Q?j+h0Ax3cnuq+6BVaYGlrTU2m/VeAKqe2oqZcRP13U3MopGBh6d0WFa/K39gw?=
 =?us-ascii?Q?geIR586Vl5aHKCAfXubw4jbWdFO6qmRO91EhVqkNSextAhV4lYitpJyutNSE?=
 =?us-ascii?Q?a0uSzwW+oeFyqrR8FSqXsKt/CPX4HTJGelonYfA5wPLL99BmUOs43J+etO7Y?=
 =?us-ascii?Q?NeQwpz9dGmP54hCQHcPiFCI2fdLJH+U0H60dnOipRolFSatDaF0pNeo79JVc?=
 =?us-ascii?Q?+3NOQogrVRuA/z/QPfkeTAmHhzib4ajULOW9nkZ0wvIE+3E6WJqGjIzrg/8v?=
 =?us-ascii?Q?uEo7EfR80BggOTUHEMQUADRJ820adQQQ3T8YU57cWxd0PYqvj0sV/J4Knwz0?=
 =?us-ascii?Q?zX6TItYTzvqt3XOntbkfqG5HoUc0jsnUI1UVB/CdulR0W7y/eYxoSopCp/iF?=
 =?us-ascii?Q?qm5W/n6R8U55SghGK9J1qv3l1jjAHeuw7fOaCIU990li9GYzVAg8w9zg5s7W?=
 =?us-ascii?Q?OYhfd/hZp4lPpdobxnsMd5NLMER49i8OBypRcXU2VVb2zMTdd79ro6KX3b6R?=
 =?us-ascii?Q?Yy+FThTIT5l7m9KZ6LqLfq/cVBIxtfGXSdlDoGHCoLsbcrncX3kCPgSonBWa?=
 =?us-ascii?Q?Qs1UBA7g+4tDLNIDu3F2AOyzAbS6JRn0GPhICuFnecJTFrGSIfAcTvRNvRzr?=
 =?us-ascii?Q?AcHI/1hNYwnKlkZavFqFKyI0lQedZAZXLwU54taZHAEYjMDtmpcMg7Cf25lz?=
 =?us-ascii?Q?SN+m62wz5rStzv7wEm/DcNv7FBxP877v7Q22dblptbKoz2SKTJKyRwRadm0P?=
 =?us-ascii?Q?/XFWMNcknR0CMG6FawNpNCqJa0fmQq44xhDgH9BVu8sRnkx9DNf5oI3zurHS?=
 =?us-ascii?Q?Ue9+RZ4s5tdmp4Uy5BHxp9ZREgLHwo/66mNBAG+zUMJKOFvyPzPquFwbCxZv?=
 =?us-ascii?Q?UIFSZtLK9znOqte7ydTpYhNsbRd1mDCfl5RqO0vI7URvpeL/1630GL7sM8/y?=
 =?us-ascii?Q?pP5iaanO9hGJp/sq2hvu/s9AgWKpG/0SkqhwVJGkl3dl+gVhYaSlMZtkxQuR?=
 =?us-ascii?Q?x2qZJKeh2xC7EqYBMh2/yyT/LH3SP8voA+YzP57Nmz/3KCcBgfP+JnIEzemL?=
 =?us-ascii?Q?8VA36b0agf/xd3tvyrZ+ZJ4wlEAvJ64w8W+O+z7mxcT75LoW4uLVr9VRkXPB?=
 =?us-ascii?Q?3/eU5JnL1yQ8LbkXA41PrR9lXBVG0ZU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YZOxpAJT3+5SMQKY/tRtOB6pReNeV1szl6vITXQxtLvmpc4GDfdmruqzJ/xtJ4KpFs8SvoVd/fjgUUOGlD16AKDELpBMHgUWOZs7a9gK1ihac7es3O6TEtxeuFH60dCxGjYaaoojv1PwMo/siABR5Wi6wihCokA70GhAdL3RYAJVZ0UHU33+WHfVQx85nhpA//jDmS56yIrmDdFF1ZEg8/5s7bLCJhra/I9SYg+323ynvBuu2otReBM3eJE5QjiRDFVlYqNwbZpkfBnn19LmLyIKIZ2EM+713VC/52yUk/taO+6bhsTq/nx+zrPM4LR4oTS+SdnDef+HsZVcVuF6YEl5mwv9b/yOdQtElXLwG8ldgKEtk0jydAJDgaJdf8q13eIqvufm1rTSbiYHm8oWkVRFtIQI1ezMdspu72NwIKFkibK6gRkdieHCT4bZj5VSoc5vwV+uJZ+LLP6D3kzjvafUbxFrncguD2y55lkNwF4dzELuEiG3utcFRZy8n+nOJH+JQRESuTiNEnYZqttQfh04CBlUJX0MnDSOuXbgzQ1faWpWQqbiIkl5jEaFkb6CGm6ZOyhGbMGEL2yJTJ4a1D9rFf4ndOTJIZKXjIVnruY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d5bf5eb-7d0d-415f-a468-08de5cfeaa6d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB8215.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 17:16:38.6014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7QcK706wdZ05ceUK97C5ID5GbEq2/AqB6CMyF3//3b+Gf1GnyL2NLcpV2VjUeSUiAbXCXy21A8z/PI3S/Ij/8OPKPYpaDAjN5fO/4G0tJxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6473
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_04,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601260147
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDE0OCBTYWx0ZWRfXxTA+Pfv07BW0
 kOAFtiWUYPVRHxihyChMuXFF+vaCkg5qanNbMXgkuNPbroDcu7/18St+8xTG6Yfu6znffy3DI1w
 MkZXqGJyRptsNWENXho2FHuBI8gOMfZeGtS348gOaXzwZy/in1m+PSrT2PFffh03iwhpZ2NfmMJ
 YpqztLrBvw3qtXmvZ9/tQ3lQYXmOa0w1KQtKGdChUCQqjx2huXZAW5abpoFUoJXIdxFeptcAC0F
 uGiyEYLfRWqLZ8PsfQPO1Y9s1iZvCnYXH5xZTIG87p9HYJy1FrYcKkQIHSSU+QyspMJmFQZfDVq
 9OKYaieP3UWHSGEn76tkiFec6GXWMQpdz1/RejmcYo5MvmzWbPlJZ1L3gnWjYtOJ3HT3PBHapD6
 PhMnMb6NBerKtnwf5hnMz7jTiOQjd5APCiwc7lhxkCoheeDkePjmpp8TPi4MhdyUT2UiHoYevrg
 VeBqApRZq24ZhL/GLcw==
X-Proofpoint-GUID: ML4UDN5svHtNg4QJ_Xo180eJS0yiWGsD
X-Authority-Analysis: v=2.4 cv=cZrfb3DM c=1 sm=1 tr=0 ts=6977a17b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=wAztU2NzybgsLfc0Qj0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: ML4UDN5svHtNg4QJ_Xo180eJS0yiWGsD
X-Rspamd-Queue-Id: 446B01A000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: f3ntgo9938b8nkcqdiaukpqcq4yb43ep
X-HE-Tag: 1769447836-858872
X-HE-Meta: U2FsdGVkX1/ujtLlE3fBOkBANVQnCTtnPXiHuN4YwLk8MHJz9QbUkLW1IWpzpP3IlAyuHgcCWRS5TtnR1ajTp6KIIqUnYyrWPdxzzX9P4AclIprsKJc+AjNXKs6wSK/AtwtkGYCHFONb3EkazUEg+EK8TtDG3KgFdonE9Tu7uUygNjTR8m631scl86N1umn0dvrDF/P/Cnw3eoFIxk9f5onSLeD3T0TkB1BqDSbM9FFOmo2vz2cuO0uKa51zSmWwZrizWMG38HaUJVBOr7up3VVpuntTg041JzGcxiapnE3sh/lwbRVQ/HW7pBHgnVfw4eLYdGV9kKnAOCcaUmPfsaqlVTzO6vYWZ9kBoYWxe4OLYqVxvDcf8v9qZeId33RA4Q5ln9KzrJ9c9r9P45L/fUQKV9k7kHxorONJXTfcV1p8UYBV0yYDR96CBySFy8EuhiyB0aE3zWahQk4o4sgp5EI266ez9bqT6ur/EjCpVqwro2OmzKwpFcBqLVZMpu9xoLCe+EDLQEyylCajwujZur4xzlYX2MaWreQz7f0xHU2JpUpI1btW1IiHiDhg+4O5Vn6s7PPaDOpYPRt7onKuzVzbRpXKF3vBqaZL/supWF1h6c+po9t+sQRJhsCRgUWBisoa7wVzY2jTIGlguDnHB6QOFkManIPAlsHDobcq0u7FwJSFXqBsWAntxqHpwm5zSTRT2eVXyhMlQXoRF0Jh980F5YeeLNWOSeBTFa7rX0CkjiwSFAKVtPdQBiMRo6Z/iYMyqGHvX2zHK/DYU+vzaJ6oe3mVy1xjeyjD2CAVlC5Ek8X1jlWBVRn8U+nTxXVZVYw6hnnd99mDs5udbnlt9FuEF2gAOWinFC1niaYHEtDzSuuMNbX0dT6rVm2iDLiNv+6nIgKJje4zSmkyefA5RDDihYZw75WMyuEvZ0+45WdXCyEACHAZGoXK4sInQSxhtuRxBoXPVXbqeABEDVB
 CPCnb4i7
 4ZvVbhNu8r20ZRo27Yb63didk1UB0XiP7qigZeIBgfFQ1az4S53xKnJsFD9QInGINOl+CrWzVZG/ZYemdg/5pppSBv1zxXJLw7L/YyUmFrpGCWsoTT0602lPWBcXsb611BXedOBCfUXF2S5PDKRXc9EkPCHzTvJLUcNgLUgri2jKnUuCKa2T9qZrwNxMuZwgsyicwj95hdUxLwmuFWsQjCAL3QGbukGsZUL9lnFJTQsARMXys3oNOJzeRVl2Xypyy/HUQv8QQAkrihTEMFPizQC97Jvo+CIX+TAY8GG72A3DGNGkNkvApid86Lv/K8kTRedAxELmWIMHeWl13NnY0PpeFOORyWAuGJQ0Gd87oVpRoJwMLlCh2/30IfHkGfpJVWe5XcPPo/AdaGvobxpgywjhIQATUEfctvj9NYztISTnIM/7tyWvUUGBKz39nqrGXjUSWOtJ9Qob3uXr7DJjdyhQct4mXUpVxWwT81C2oR4Ty4Fkj1dacxsFoTAQtBI0C9ta1rDDyJoCgN/xi18EDphoknPNMdm9zKoQywOaI+/+2GCSQbtvp0HklrVydAOHP1o+awGGBP1TM9H0ILfFMpJG01MXiDwZPu+qeQlLHQM4EaNE5vbLzOW+ULJDKiwtwEa2PV7ycpxbIdenzM0GHqNf/PsnXK11nNGqeYniKcPIJmNf2sOl4D7xA6h+q5xy9NRwm5tlIdhxWu1QHoBFWRcc7ge9+8YXlvD6rGlssGyzd80yd5NyyvMLAfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 04:44:07PM +0000, Lorenzo Stoakes wrote:
> On Mon, Jan 26, 2026 at 02:42:00PM +0100, Vlastimil Babka wrote:
> > On 1/23/26 21:12, Lorenzo Stoakes wrote:
> > > We can use lockdep to avoid unnecessary work here, otherwise update the
> > > code to logically evaluate all pertinent cases and share code with
> > > vma_assert_write_locked().
> > >
> > > Make it clear here that we treat the VMA being detached at this point as a
> > > bug, this was only implicit before.
> > >
> > > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> > Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>
> Thanks!
>
> >
> > Nit:
> >
> > > ---
> > >  include/linux/mmap_lock.h | 41 +++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 39 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > > index 23bde4bd5a85..4a0aafc66c5d 100644
> > > --- a/include/linux/mmap_lock.h
> > > +++ b/include/linux/mmap_lock.h
> > > @@ -322,19 +322,56 @@ int vma_start_write_killable(struct vm_area_struct *vma)
> > >  	return __vma_start_write(vma, __vma_raw_mm_seqnum(vma), TASK_KILLABLE);
> > >  }
> > >
> > > +/**
> > > + * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
> > > + * @vma: The VMA to assert.
> > > + */
> > >  static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> > >  {
> > >  	VM_WARN_ON_ONCE_VMA(!__is_vma_write_locked(vma), vma);
> > >  }
> > >
> > > +/**
> > > + * vma_assert_locked() - assert that @vma holds either a VMA read or a VMA write
> > > + * lock and is not detached.
> > > + * @vma: The VMA to assert.
> > > + */
> > >  static inline void vma_assert_locked(struct vm_area_struct *vma)
> > >  {
> > > +	unsigned int refcnt;
> > > +
> > > +	/*
> > > +	 * If read-locked or currently excluding readers, then the VMA is
> > > +	 * locked.
> > > +	 */
> > > +#ifdef CONFIG_LOCKDEP
> > > +	if (lock_is_held(&vma->vmlock_dep_map))
> > > +		return;
> >
> > Wouldn't this work a tiny bit better?
> >
> > 	if (!lock_is_held(&vma->vmlock_dep_map))
> > 		vma_assert_write_locked(vma);
> > 	return;
>
> Hm yeah could do, I guess we don't need to mix the 'uncertain' stuff below with
> the lockdep-certainty, at this point we _know_ there is no read lock/readers
> being excluded exclusive lock so it can only be a write lock.
>
> Will test locally to make sure sane then send a fix-patch. :)

Actually I think I can get rid of this #ifdef here, will fold it into patch...

