Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F65BD778AB
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 18:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C9F6B0530; Fri, 23 Jan 2026 13:18:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964D56B0532; Fri, 23 Jan 2026 13:18:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837E66B0533; Fri, 23 Jan 2026 13:18:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6EE046B0530
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:18:49 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2727658F79
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:18:49 +0000 (UTC)
X-FDA: 84364039578.03.54337A3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id B36E540008
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:18:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MQ8McnMM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xdKTZm7g;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769192325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smgUeChdJAHnh9YLic8OCOGFWF3UiJ88tw+mF8tzSsg=;
	b=ecjNsRi8vRscqlAcQA2D7Mk1QxurUI2RYyeHrHtMWu/J+Vx73eDySAX9ouczKMXWQg3VOB
	Wu7B4ALSfCqYMzSH/N5qmx5Y6m5AA1nu1l59yoncqmRgb/E9Dv4IKsEDo0snqmu8XoTAcc
	GsN9iihLdYg5VS9BtScMKCDvqm6NHJE=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MQ8McnMM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xdKTZm7g;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769192325; a=rsa-sha256;
	cv=pass;
	b=E20xkC6uSi6VgmFjEVD6oJjToa0X3NxyMq+iiMo38iCESwH+GJkxJoftcg3bH6byTAy6ut
	GS0hYlk7eNv84gWR1Aux42WenONHrt2C6m4yocST7rpOQ4enmhgbgiftrrXJwOUsvcQP6L
	3VxSJK6GjZIHyBtemFyDLMOUovp3Jr4=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NFVdVJ1675434;
	Fri, 23 Jan 2026 18:18:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=smgUeChdJAHnh9YLic
	8OCOGFWF3UiJ88tw+mF8tzSsg=; b=MQ8McnMMfAxHO9RwDqxiIMBs2XYGiMy2tK
	qfxSJcCmH4KaTfSgExAHdWcrfht4oBdtpXZKrqt61MHklapPAcDUC+qiSQGMkzi2
	f/Hz1EMo7ZkZxVDeSljaMeAALAXDs8rnpHuVi8eZtT2mAMrHxx72Mh703Yelp0qt
	oop1c+3/TkayDunll70pcXEODBm8QbKO6rYxcj8JgAe61Sjk5SfESy0KSekfFQTf
	ceKQs18Tc1wN865/R3xnGPi8tKT+0UhKZrpVvda0hj3BlAEnWPx0WWaYpZQw/g8G
	XuFlCX/Q9XeERcgvZLU9Yx2nz62fFAyOwjMBJDHQsDOPbDweZJoA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10w2vg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 18:18:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NH0JD5034066;
	Fri, 23 Jan 2026 18:18:32 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012063.outbound.protection.outlook.com [40.107.209.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4buyvf6b45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 18:18:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N9+LCZiKpLX4otQep6zZrWVzchXwSWPionEnsJD4bYSq/2no/9KmfQS6p6c1An/wkZyOcq2S5kGnvFH8uEtLSzgVSOOuksmDTx2Nbb8sPhoITNduRM6j9SD+3/gOuwjWdg/rVDxhQgVx1CbCow5jsypOLIoN2F3hZ45sNN2yCuJi2wYXJVnEEH9K7ehbG6raqS1w1umE4lKzOSPSczZecVOw2gB19yeuiS4gEUBZQ9lVo7fugbn34WWN9aKVYj3lAT1tx3oR3bjAzptq5AceMk/13iWDfDBuxr3uWGHnzb5o9dUwtpWaP9YxJgCylO+JCzR+FDqX3c2gJBXWeosxFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=smgUeChdJAHnh9YLic8OCOGFWF3UiJ88tw+mF8tzSsg=;
 b=KXl+1MOSU5LDW49eVZO+rIrxMfl1ezL39nJKBzg40IWuvBiR7waGIVpZ4PGt4+iDiyPLoYdVfAvPnVWEy6fZ0FFwcjCPBvRCWJda1Y71JffHUqRLcsSLIb8jWW7I0bU8PFIix2EkHgzu67ymxDD+FppP/exTvDU9cJu4kJm5VZVXPbFhqtXdJsgh0TN2IbEo/Ir/jjAIVCGAGRR4z9hB7P0lhO6cUKWHLv7ljp+IVhRmPwwD5ZehsbKSqCOLO5blU1rQgb0sphtFbEuTNPr8Hj9e43X8AIkFA5rqzAlkXGV1jCz3HvyvFL3STPrOFiRoNlEbaiufpOk6PlbbyI2zgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smgUeChdJAHnh9YLic8OCOGFWF3UiJ88tw+mF8tzSsg=;
 b=xdKTZm7gHAWpATkU16/0IdlLVsTR77qkjD04P+ycetrL9p7C+/4WaJ5h5qdoVFR73NOBsmLdebYGyXqwqR5xiPaDPc28GJ55omFjqy2HmbJiccAygpeC7lOzRU2f5AXaL0A88Zo/4uHST+0FrUKpPVHftWz2NiU2ug7CRrdmg8E=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by MW4PR10MB6394.namprd10.prod.outlook.com (2603:10b6:303:1eb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Fri, 23 Jan
 2026 18:18:02 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 18:18:02 +0000
Date: Fri, 23 Jan 2026 18:18:05 +0000
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
Subject: Re: [PATCH RESEND v3 07/10] mm/vma: introduce helper struct + thread
 through exclusive lock fns
Message-ID: <17cfe757-c8a6-4f75-aeab-ee33ef6042a4@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <4f95671feac6b6d4cea3c53426c875f3fd8a8855.1769086312.git.lorenzo.stoakes@oracle.com>
 <76e112da-a8b6-4004-9bce-2dcc29dea7fc@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76e112da-a8b6-4004-9bce-2dcc29dea7fc@suse.cz>
X-ClientProxiedBy: LO4P123CA0025.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::12) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|MW4PR10MB6394:EE_
X-MS-Office365-Filtering-Correlation-Id: 16bcb36d-f7eb-475b-bb3a-08de5aabbed7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RJ3L/5zZjKb5mtU4xAytCEMQfWjGUSwd72le7iakwe2q67kOklkb/qdsUf6f?=
 =?us-ascii?Q?cRXq5mNXUFVVkaGfW73zAmthCw4TV8EqDzR1FgjYZjnm/QbErCll1F+5zwJh?=
 =?us-ascii?Q?HYb8eBKb+RT8CJBbqqxJAV6A4QYiDeBygt3X/NkDJ1wRmhMK3cE7/OA4YwUO?=
 =?us-ascii?Q?SF57gvq4QMTINhDVOkjMxniNMhTaFPSC/Ta0oVcT1QBqrqbad0gN2bPF7QDL?=
 =?us-ascii?Q?dvzvEajzKF3MBCQJs+VD3aLg1GhcUsBUJL9JwwmXMwI/uENbCERvXISYlJ/V?=
 =?us-ascii?Q?ZQoxJnFbwBgu4LsZMaeLMuTSPOKD2wHWVBVYYVC3iKXnBFt4NJjQxfouTD5k?=
 =?us-ascii?Q?FI+4je8c72YM87WtFLkgpwMlp8z0HJpE+37c0m1P/EG5u4xyibUB0QYYKbAT?=
 =?us-ascii?Q?DG5Q8Y4YPD1KirmagT41VpEZcGqURImJtEAUVGekYgi6lTbDV8EwYgpeKalM?=
 =?us-ascii?Q?K6RHkXDQE4xUrPfggLWu6JgMco3iyUg3qsq9Nzn+QR2yyohauXyzUe6qVN6T?=
 =?us-ascii?Q?f8s1aHzC5na8oNc8oBw8b0tLtLscv+ozYICMf3Au2exQZ5qxzZQsJDpA32cU?=
 =?us-ascii?Q?9BD5DCNCKflcaFMjIjEp6Y27YU7+tFopkAWydBlhqNr8POgZq/LhxZAbGBHk?=
 =?us-ascii?Q?+9111yOZrYEZQCnIQGujEdZtWiWQqsubFFMNnDEw8ewCr5BHzgnHzTE2Do5V?=
 =?us-ascii?Q?damzefRZ5wSkovAEeuEbvHvtXoi7whQo2FctGglyRwqi+VdWp3zR/vFGsGZD?=
 =?us-ascii?Q?XFXUdD+MTKgU0nIx4ZsIs9/cSnnNdRYFVQT/AAN4WdU7i9civyr9vPo2+8KR?=
 =?us-ascii?Q?bnPlZAvcR5Py5zCHI9evxX7Gve1v8NWgkutqKmgEqmMQ4LQUJFzFKST9rWdT?=
 =?us-ascii?Q?ETJ/wo/HpL7KGf1KBxtyfFa1BJNtbfAEowaURfJKtIfdGvaJjaeuUpwjXWzU?=
 =?us-ascii?Q?3i7KMa5GHLMNWh4HCEjptfOWQuDNcS32OdEtI+slE6LSBvJI0f4ye8XK2GWW?=
 =?us-ascii?Q?EmYi8iZ82qQSlboKuDLvbPrEix5h3rTCu5xfg2tpDfn3F7U9ZQTvtP+PKusJ?=
 =?us-ascii?Q?6AOgYkF+Lv4TvNt7vfjdfiyD6C1HUxeL4ecQsH7hwF0BYJ5umeGYBL7p298Y?=
 =?us-ascii?Q?Kc8YIeWQMCY+5g7tz7hql6WUOaZCFKQ/1MzsQzlDzf/wf/CfYXeRzaoiABHJ?=
 =?us-ascii?Q?UTYxzVtqVblvzpy79dVhWcXQGIdYtfi3Ra1C7KWZhT4tLPGeHDyrcSKk6B0S?=
 =?us-ascii?Q?yyEn6PlqY6ZmTbWctvoAT0eliWWSlxYX1S/m7Kwqa9jXeDlbVpx+pYeaY9nV?=
 =?us-ascii?Q?Kz13gd+93OhckCst/SHz7JM4CvxaCjJTP0H/UrHLc0Sxf9IuQGiERQ2mkBVj?=
 =?us-ascii?Q?j/lnKBXCK9cYHvJ/bSEAtDTs/7XkcuwTBwv0KBklyEE010Csl5LX/mXbAHjl?=
 =?us-ascii?Q?R00oTMxijZZhmWEr4Gj5Cz4vUUBAQildjEH6DpGwsl4fLwK99315y4cFb2xK?=
 =?us-ascii?Q?kElrwe6rkedy3JPkfOXODVR4bLcjFUX7OVBSTXGBrHb4vuuQmZ5JUlso6HZR?=
 =?us-ascii?Q?J1wbdv8IiKEaf7wa4SM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5Lws5jliXWDdJKfpM3YAJ1cHvwCKS1DwjBccsFuT0GAMtdUw8FBTAhyLJQ9D?=
 =?us-ascii?Q?iM8R06V23r8VOWPjGPutijdlErcPL4QN0iXwMC97tUCwPcHFb4Bp03eeRBdy?=
 =?us-ascii?Q?Dukqw+KOTIEErtn5iTmW0nBIFa9iYkxbsT2Hxe+y/Z5ItGu+lGFhF7k1+6Jr?=
 =?us-ascii?Q?lSsbs+/FTtdxvCrCAEktwfUcel7qhrD5tLa36TvUYoWDvwgdJwzcqCtR3AjW?=
 =?us-ascii?Q?UNAUkiZxUYCq/+hCvkEvl6Cffd8gKUL/LsVl1gTG3UV+GPMFNuA2zkFeV/KA?=
 =?us-ascii?Q?4nk7OGpgA4YCyh1PXKww1ZUoKZv3tsxiUIBu/Kba78manQYqkO3uXuPnC4VY?=
 =?us-ascii?Q?mqUZlIwppbPMS15uWs83jbmaaTAwxVbi73J070y+z/zCd+9rWsVmP6IHRvO3?=
 =?us-ascii?Q?yfntaFcozR0RUB2G2BA7Na+hjCvtNhw8gwcdkn/rL62/77A4iR8WC6jgXocN?=
 =?us-ascii?Q?2JWi5o4KgwNLhD+uasJMcP/Zdpt+WpnDk20rw0eFIMmngIfY8V3jxLzozaFe?=
 =?us-ascii?Q?AYePqe3TVh9p8DRqHUX8sVwjaTzv/DZ54r0+engEb9c1uozFJ4UqlOm5Y4Mj?=
 =?us-ascii?Q?EbtrFotTan5umPZEbXU/dlKMiO07u95+FLp3U7in8AjK3mesuJhzeUNAzjvT?=
 =?us-ascii?Q?smqeZVM0a1SYCHTMsuLR/w3twGIBKhpUHeymmp2xkps0VhQs678nqbvCTFYg?=
 =?us-ascii?Q?EFfSOKf9PxFXwnpPTa+hYe3IxRbew1tOaL51iHBTn/xSddYty56beSAPlgbL?=
 =?us-ascii?Q?OS+yvvOd6LDmD9Kkwk43ucSw0Pbu+hThJ5lWmoZGvrJ1BRfTEiKjcDNHXXrH?=
 =?us-ascii?Q?SYBG33yxJhA5S7LDzIVdGBaRtEnhAJjOfn0LB/H+poXJI6p/Nv+d3te0PctO?=
 =?us-ascii?Q?syL5kdNLOOElRxe6wHqRwBTgYKdxLhXVzDZE/yvmfZ+A2ZPc7cZ6lrPZcpuz?=
 =?us-ascii?Q?BnJHuCeA7tlpXMxZp1tfvLr549np5b0Z4SRnfwOIq4LNz9F19sRlJbAjfbgV?=
 =?us-ascii?Q?+sdQGgXi8pmuc2/l8i5P1+lF2fpZk8WZPt8VQwUErk/DF0V5717DXq/LHbIp?=
 =?us-ascii?Q?3eEQ1JyYYqYSyrCprZgq17nQOecaZ+0FThT1iVqjhEsTqRbNeiTYp2SskEnC?=
 =?us-ascii?Q?pzsPcTTVyDbNFm5h3xhpmmrpBdUhVUKcvzFcGKXH1oTSLnwxRCOZnuHl7dQ2?=
 =?us-ascii?Q?xCaYA46AasqA+1rFYOCpc7jvZNh/TJEpU1qDDybNJpnMX1QlK6g+P2u0zK0v?=
 =?us-ascii?Q?nIA4SulznjwPOKucc8wygqaoPUewfeyAcRDuXnkRz8NXVjaISeoQl0EEMGld?=
 =?us-ascii?Q?mCzn7LzkZeixRIUoHG4K2HwViX6BTwuZe3TOjX5OpwucCYoTQGQmv5p7gYdZ?=
 =?us-ascii?Q?OtWHguouDxyfg38ADxUewUlLUxK7yK91wXlsahO4X1Ty2GDzWawi9jSRGbhy?=
 =?us-ascii?Q?cdTLmX/DrS0pf1TSuVc1aV+uVeSrk+I5q15ZQc354kjoAy4Hn61xExyjcwgZ?=
 =?us-ascii?Q?mPCocXZ4ciyvqkSgVHsT5lPpehlVKKwq3sai3hI6p+siKZb8skX3k2lkJUyE?=
 =?us-ascii?Q?LivRtLhW0yBij0WyNVoHT+D59QtIg5kkcxpHpMDFzPjuePlsrq41pmKHDajX?=
 =?us-ascii?Q?7Gl9YACA/QBgtjyzO88wFQ4PnLXyK8qadpklog2iBIvoNBfxtSB8tDT0l97o?=
 =?us-ascii?Q?Ymfq9JBmsJWLS0nBhWAR1aAlwlnvFQfmGRbXDE9q4iozdv954p67RLkHogEc?=
 =?us-ascii?Q?fNE/6+eJd7PNwBM76Ha8s6kvkiBULNk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8FgUMok4hkqr0O3xmPGtXRPIpDUHB6sJ8m/tzEN+F4yeCarLoQWJB3CoE/9JfJ0syyuYxDVZkR4gbD3D2D4M43dLd3P2NhlGT4W5nFHVEu9Fjur+x1lJk5os6HSXx2MgaxtU84ftg9s1XupcOVRM4aK7q8e3jJykAm2hfjBiGR+qTL0VKo0QTjEKYI9CZ5cw1HsPUX9rQNMJL6FJnaXJd1B3W/XOQst6z7XZqJ0CLwBzNGgvrw+H2PcokH4tXWSV0IJ6SAjXrfSM5f+OK0uvjXSGuB2nMy38I4dhM0q+8kgrLgIYYleK1cOlvPN3LAG/AOQZsR5iXOj1AE1UJtn9B+Pqed6oFe1Dz0Awm1DH5wMcuzhAHoC/C6sEmDzNmQh75QZtsz0/oDsVr0Vnr7Pjrglad72mVG43DKQvatj1wGvJDBDudcEB6TdepgA/Tou+Yt9trgdSlcGzh3/fw1Hj7tio/Q+3ES2DTkpDHzJ6c4YHsdeFGfX0+WeJFrDqIeNtwadRTXOu6Vku1L380dSfMA2tScQc0kT1QntZd/rw7WZqr5N4AQdWU2sa8685zx0fYr6uUv994Ie85qaD7vu4m0DZyHZYQ7riAkwy+mpOBs8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16bcb36d-f7eb-475b-bb3a-08de5aabbed7
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 18:18:02.1637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NKHgHVgYnvU0ibTeb8sAiuS5XikPCoNfJKVvoeDf5rEFH8ImjZxTLdWxMitjCke7FpJsYzSi4i/uDMmKuNmRNsta6RfDfzRUaM4PSFQAVvA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6394
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601230139
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=6973bb78 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=bxG401YevQN01cIeJxEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: uonfLwJHHzAhF2E0sgLoN4kMRaLY09l_
X-Proofpoint-ORIG-GUID: uonfLwJHHzAhF2E0sgLoN4kMRaLY09l_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDEzOSBTYWx0ZWRfX+7ZCHseS50rd
 JpWULL9BIpH6+9Fuxb3AaR9R10/v4o11NLERUDy3++S2cCe+FsYR6Nby30CHUND2UL5WzVmJZLW
 r8a0EGukYIS6Gib4vr3SGND98NXlVJjOsY8uVGxMRrYsNVklWbYJu7GzjEjfNDIvKCok28tUgEm
 FVzW15gVemM0lGV8CxFXDITWuu5dAyo1Jd4MtbKcrN0T4mj8becOCldtuledmFV3SExI1gvCLXT
 yNlQ7iy/b0rm3eKgSaLmOsmSHOgw6pYBrKSROO2la3mwXB61jgK1bfQX8cgQUynJO2iIxYzrVXn
 fqHVxSeVhhiRuCkIMAiS2TUHSj3jbpFA1NJiCqne48AI80n/1rcMDxsoUXBt/ftw2I3gQ+WXl5C
 a+ogpYcpD5///g0Xuk9010vweHfIgKCny1WDlrUAi7oTfF/DVfqVqfYqqXvy2ecc6N225djJ+fI
 VPo8oJhBgyKnq0yiuZg==
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B36E540008
X-Stat-Signature: cfigkb75dofgpeo1boshsx4q8rexnhxj
X-Rspam-User: 
X-HE-Tag: 1769192325-299938
X-HE-Meta: U2FsdGVkX1/i5SY3JYPaxLbenAyElR5JIUoGG7By7j8HHMJRYC1Nez17LmOtOor2YbH3UdzkjYxK31pO0Kqo+wNdCgVx0jPD+pqDYsej10esQDAX3q7SkZrI35vbjL0rHtkRrTW+nm6DyvtPBcEs7BskhCIZpmWr/WCIYjZjf6AoTsST4iBzKd1Jz5lDufz5NhNQJp09zLsN7CcdAUr0GYvy1tUkEpO1iX9sr40mpcldrsFbgs8gqmz1VV8ApZEQYwEAUvQMu3xQGLB0YsX7JLfDWtyeCv0d1K0nO+2iLijtwL3zr9olSwnkkcEyIxw9jdqRzvm2oFvf0631/8kZVQPEpBZewTEdP1AQHZ6jGYJUmrnQwrJdF8VJgQO76RPjb2IrOHidUh25s5L1Ej4PDcJjpLiUlTOjNfX4ltbOj0PTPLRV9+P2/MsJ3thDZ8A9HEC2zQojUMQ4F26fH1edYJVqnTkzASvf4R3kaPgq0VtyXp06gkcGPJ2Yy/q+wm/Tox8kgeTuab4fZEiUOZfyKfmexpBdcl8t48TjOE1QKmiQnKqyJg6mgndyUAn1xq7wk2mMPVXFZL3IE9ELmtwRw2umIO57GmGxJzR+mJK9MVT1R6BfIXAThVznDwdnKh1630gWKaHhYFT2HIu+v5QxPrxCGIld6CUTE2Lqym3lgk40zTIKrHSnuGzTreL1vvepXE7DJwsNM6EeQVt5BJ3zDFJCjv9kJigA6IEGqMiP576jwBLi9ATnOPkWqYCaHfJXKJKr54btD2E75x2uEC0Gi0CDoICl2Fks12VSPpAoJnO6bd+w4BoPhhNWbhnmFbgs35PlK+ec3QCwCsnaMQhzEy5nrrGvtaw5VyMskWa7fpTyfxoUbMvJPQx4Uj3b9pmEiVJ4qcEC1eUEE4XHw3n1jZDiNUP4SC31GkpdZyJhXZzl3cwB+c8280H0m2t7hd7peuZo4I2xEehQ7RKHcRR
 1f2Kc5z/
 27z1fETFJtS26KfVvRgSzQIY1xvici0zOqjVLCLdqBCJZUa3lbuTN+echLkI6N+m1hzYlVf7VMb/1ro2wL7/0MS8xWYaL8nmqZG1Wp8cpjimALVutZxaVw3mEo+O3PRUMIDErS3TIL9priYpLwkTb42yiA7yHK5a6NgXvwW0STir7+5XJ8/OGmP3fHHvezdU+/GLS3cw/Z+wWNjga5mY22g4LDGLD9bLbsLxV2QNHWL96FLuFLPjhF6Sho8i0qXKTLQoRlaoli+IKvF3eD5DcmRsBx8nmI0eGQbZLshK8v5+drFrVpwvJAsUSt48wpuiZHZ6+5Sv6n+yGN/785kaLkdYV6VXU3OTNeCVzk1bvkXbTVutFqVqa6uK9VP465iD7fzqHT57WDsHTMmn/bpWxwHLcQSL8sIYXm9SojRNX9SZZFpzgUI0QEVJJU+LNLCDNs21PU06eDycBWOzFIMYBxf/873aMFho0u4o+mZFvvEjcL6OsUHESpSwpHXDaN4gVFi7SlYMuPhXNnsb6kn9ZVW9j/gcRYjK7bSCMf7V4Sy6CgQpw10jg/QQP9vO9nimYHx61cQi/v08yKUEToHJ89LEGckg31WDXdR46MD0GHNQMJG08uG+TUHcO4BYPq1SymlCQg4YlcOmaT1vYD7w5z0ikJluaAzYVjuRviVsBD9Mg3Vdz8aUBmDqPNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 11:02:04AM +0100, Vlastimil Babka wrote:
> On 1/22/26 14:01, Lorenzo Stoakes wrote:
> > It is confusing to have __vma_enter_exclusive_locked() return 0, 1 or an
> > error (but only when waiting for readers in TASK_KILLABLE state), and
> > having the return value be stored in a stack variable called 'locked' is
> > further confusion.
> >
> > More generally, we are doing a lock of rather finnicky things during the
> > acquisition of a state in which readers are excluded and moving out of this
> > state, including tracking whether we are detached or not or whether an
> > error occurred.
> >
> > We are implementing logic in __vma_enter_exclusive_locked() that
> > effectively acts as if 'if one caller calls us do X, if another then do Y',
> > which is very confusing from a control flow perspective.
> >
> > Introducing the shared helper object state helps us avoid this, as we can
> > now handle the 'an error arose but we're detached' condition correctly in
> > both callers - a warning if not detaching, and treating the situation as if
> > no error arose in the case of a VMA detaching.
> >
> > This also acts to help document what's going on and allows us to add some
> > more logical debug asserts.
> >
> > Also update vma_mark_detached() to add a guard clause for the likely
> > 'already detached' state (given we hold the mmap write lock), and add a
> > comment about ephemeral VMA read lock reference count increments to clarify
> > why we are entering/exiting an exclusive locked state here.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  mm/mmap_lock.c | 144 +++++++++++++++++++++++++++++++------------------
> >  1 file changed, 91 insertions(+), 53 deletions(-)
> >
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index f73221174a8b..75166a43ffa4 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -46,20 +46,40 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
> >  #ifdef CONFIG_MMU
> >  #ifdef CONFIG_PER_VMA_LOCK
> >
> > +/* State shared across __vma_[enter, exit]_exclusive_locked(). */
> > +struct vma_exclude_readers_state {
> > +	/* Input parameters. */
> > +	struct vm_area_struct *vma;
> > +	int state; /* TASK_KILLABLE or TASK_UNINTERRUPTIBLE. */
> > +	bool detaching;
> > +
> > +	bool detached;
> > +	bool exclusive; /* Are we exclusively locked? */
> > +};
> > +
> >  /*
> >   * Now that all readers have been evicted, mark the VMA as being out of the
> >   * 'exclude readers' state.
> >   *
> >   * Returns true if the VMA is now detached, otherwise false.
> >   */
> > -static bool __must_check __vma_exit_exclusive_locked(struct vm_area_struct *vma)
> > +static void __vma_exit_exclusive_locked(struct vma_exclude_readers_state *ves)
> >  {
> > -	bool detached;
> > +	struct vm_area_struct *vma = ves->vma;
> > +
> > +	VM_WARN_ON_ONCE(ves->detached);
> > +	VM_WARN_ON_ONCE(!ves->exclusive);
>
> I think this will triger when called on wait failure from
> __vma_enter_exclusive_locked(). Given the other things Suren raised about
> the field, I wonder if it's worth keeping it?

He was suggesting I use ves->exclusive over ves->detached? I've now actioned
those changes so... yeh not dropping that.

But you're right that assert is wrong, removed.

>
> > -	detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
> > -					 &vma->vm_refcnt);
> > +	ves->detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
> > +					      &vma->vm_refcnt);
> >  	__vma_lockdep_release_exclusive(vma);
> > -	return detached;
> > +}
> > +
>
> > @@ -151,7 +176,12 @@ EXPORT_SYMBOL_GPL(__vma_start_write);
> >
> >  void vma_mark_detached(struct vm_area_struct *vma)
> >  {
> > -	bool detached;
> > +	struct vma_exclude_readers_state ves = {
> > +		.vma = vma,
> > +		.state = TASK_UNINTERRUPTIBLE,
> > +		.detaching = true,
> > +	};
> > +	int err;
> >
> >  	vma_assert_write_locked(vma);
> >  	vma_assert_attached(vma);
> > @@ -160,18 +190,26 @@ void vma_mark_detached(struct vm_area_struct *vma)
> >  	 * See the comment describing the vm_area_struct->vm_refcnt field for
> >  	 * details of possible refcnt values.
> >  	 */
> > -	detached = __vma_refcount_put(vma, NULL);
> > -	if (unlikely(!detached)) {
> > -		/* Wait until vma is detached with no readers. */
> > -		if (__vma_enter_exclusive_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
> > -			/*
> > -			 * Once this is complete, no readers can increment the
> > -			 * reference count, and the VMA is marked detached.
> > -			 */
> > -			detached = __vma_exit_exclusive_locked(vma);
> > -			WARN_ON_ONCE(!detached);
> > -		}
> > +	if (likely(__vma_refcount_put(vma, NULL)))
> > +		return;
>
> Seems to me it would be worthwhile splitting this function to an
> static-inline-in-header vma_mark_detached() that does only the asserts and
> __vma_refcount_put(), and keeping the function here as __vma_mark_detached()
> (or maybe differently named since the detaching kinda already happened with
> the refcount put... __vma_mark_detached_finish()?) handling the rare case
> __vma_refcount_put() returns false.

Yeah good idea, that saves us always having the ves state etc. too and separates
it out nicely.

Have called it __vma_exclude_readers_for_detach(), and made the change.

>
> > +
> > +	/*
> > +	 * Wait until the VMA is detached with no readers. Since we hold the VMA
> > +	 * write lock, the only read locks that might be present are those from
> > +	 * threads trying to acquire the read lock and incrementing the
> > +	 * reference count before realising the write lock is held and
> > +	 * decrementing it.
> > +	 */
> > +	err = __vma_enter_exclusive_locked(&ves);
> > +	if (!err && !ves.detached) {
> > +		/*
> > +		 * Once this is complete, no readers can increment the
> > +		 * reference count, and the VMA is marked detached.
> > +		 */
> > +		__vma_exit_exclusive_locked(&ves);
> >  	}
> > +	/* If an error arose but we were detached anyway, we don't care. */
> > +	WARN_ON_ONCE(!ves.detached);
> >  }
> >
> >  /*
> > --
> > 2.52.0
>

Cheers, Lorenzo

