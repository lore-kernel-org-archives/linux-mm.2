Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 807CAD3EE86
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62956B0259; Thu, 22 Jan 2026 11:01:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E306F6B025A; Thu, 22 Jan 2026 11:01:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8B56B025B; Thu, 22 Jan 2026 11:01:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC7E56B0259
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:01:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6FFD1140439
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:01:51 +0000 (UTC)
X-FDA: 84360065622.06.2C851EF
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id C68DA180013
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:01:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ct96gGXL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=B3bNzIn0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769097708; a=rsa-sha256;
	cv=pass;
	b=CXtjNQ/35z6n70e4b3qN6PTf1UIgy5FxhGj8XyOXW6ace6s63DqRSf0qa1q+Hu2m3T6Wcx
	9DJ5dDIIzdopV9yP2/gwnJ7TlStJx0nfOPpxdiePrI3xCsUNucDSPLP7WWIXU1F+wa262T
	0c1tG2KuWWRJB9kk8pb/9Q80vzTKeY8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ct96gGXL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=B3bNzIn0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769097708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sk9PxmW7Rx7d1CUZ1LS8ojPDOAbT0YwCmRHwWd+u2lk=;
	b=LWD35zUyXwFWfJXHPPHzGnf9vtBYIRXJ0SBczIevK4MtdVHr3qtKwdTVeTlx2ETjX/SsBT
	43mt0CnrCWXF9EG+XMYCi2Vbq8NCAVruoy8bH82pvSCaNtRe5Wz33smdjq0YeCS4j6orpA
	4AEVkMx5Y0G06x01U0LzkrdRgWmqWiM=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60MDgJqF596111;
	Thu, 22 Jan 2026 16:01:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Sk9PxmW7Rx7d1CUZ1L
	S8ojPDOAbT0YwCmRHwWd+u2lk=; b=ct96gGXL5n0/K0hxWrKEV43KMrevUIy57Y
	TSudFbeMll9CcnaXukDmVg/3YNQiv6Ak5iEVQ2GlLrM4cpm5/0a2IYvRmmXCVkw4
	ffGn5M41KiA6VKUvhXP2xuxUEmnxbtOl32gv+LlC1Mm4kPjBDq2uC6XL57XChUZj
	WCDQT5jHcRqkv1qxRr/dn85kTbwZiaBt3AqtLYq58A335L3ruw+AVpYggCVdU0YF
	QB9yz1cPVkmas3ssehFz3Hw7TKes3BszZ+U3qVpejRNxfaBXjJ7UkGdLP22qhwsH
	XwvXSLq5eqc3a/zTAdQO3VFKSTEmmIdsDUOk14xPPEXY0mRGGcbw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5qw4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 16:01:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MEeFQD024901;
	Thu, 22 Jan 2026 16:01:23 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010000.outbound.protection.outlook.com [52.101.61.0])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bujd04g2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 16:01:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mfIq4GvDTTpnh+voss/sJ3No8f61jTeq9yeCE4ljo0TqIGsxWcuZ1fPxwiiUh0vvKmhfCdCj0wEh+ljrtKCZek7GmSdI03wIA9fESam3sofQQibV6Ww3YDKMy1iU9vmU0UtOLdfEKivIZEFhFyTbOTT/xc2t5dj7/xTvWucCGUBDJSuZhcEGTq4nvYbS/74Ll2YrjpxloRTPVxnLkIQq1mCy/Qm+GkdlEVuDqVIz1I0gssmyl/2xQVhGKOyM9MjAF+eziv8IVhIbpZJZRlZ0aQ7u87fuXGigLq9m6KfJ+1tpdwaJUBFNaBkpzEJM5k0qYeOFLpuFp3dVlAp37u+Y1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sk9PxmW7Rx7d1CUZ1LS8ojPDOAbT0YwCmRHwWd+u2lk=;
 b=FJmxvCnP3MV9HHSqsSPo1DbgiY4YZq1qPC2RHtDeTMB3LbA+qoDURYpPOdV5ffvl2B/f62cTONgOZWHOAMWj40THdb1Hp6WiE7SV2UrPQn54f73ZzT2xFa7yHbMI7pOtYsDs/44tB6eJnU/8CM9jdaODa5724w7mxbCvfS/9czpdmaLcHirpz/7Vf4AY2YhAQGOMprq7pYM8GDTA5y6chJkWUmUGXtfjDjMazvSwLfkm73xQuq3yefENRyLL47D82ZP76VWHHk429nGXF37NZCUlwSMqcdkF3WAtVgOnMm57OwuuwEAYogYP2CuyddBlDyWN0sA/ZX6xgT0kEEvXrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sk9PxmW7Rx7d1CUZ1LS8ojPDOAbT0YwCmRHwWd+u2lk=;
 b=B3bNzIn0O4m2rSj1neO7u0dYn4VX4QKx4dv1NuYg3XQs14LxoUF4AEKh8X/9PAkyTJ53jNsXvmLFEzOIt1lu9tiG8WFSiNkMI85c/OAacVsXS//kgsTe6QjhNH7QstHp20xH1yxG+PBkPxTlwhmwYsYL2V0NIC7M6r4bYicqBAk=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB7216.namprd10.prod.outlook.com (2603:10b6:208:3f0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 16:01:18 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 16:01:18 +0000
Date: Thu, 22 Jan 2026 16:01:22 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 00/10] mm: add and use vma_assert_stabilised()
 helper
Message-ID: <cf2d4f8e-d225-4715-80a2-975777f49f84@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <20260122074807.eccc6080b8d8ca5fc37b2a62@linux-foundation.org>
 <af4f2048-1176-4b3b-954f-09fdc7275348@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af4f2048-1176-4b3b-954f-09fdc7275348@lucifer.local>
X-ClientProxiedBy: LO4P123CA0390.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB7216:EE_
X-MS-Office365-Filtering-Correlation-Id: de6bebdc-6a77-4a92-90db-08de59cf7ae3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UC06jIWIBGT8/2CerfOBlQJSe8uA4YyNQwcCxdbmBy3RhhPXzj1h4HEPjOC6?=
 =?us-ascii?Q?XFCMMxFjs1l8+5PLKoITkWHzi1q6AP2Iz5PR1YSQkVDiB3mAXu7DyKusw1qn?=
 =?us-ascii?Q?LJMBAibjx0lIyabmBZTJR3E8CEWEA+ynfIqW3eWlb2Wpt1LF7btEem/rVaLo?=
 =?us-ascii?Q?Sd5MhEEsKHTSpF1/NwhlzMD6uOdJdVvUAJkAZ+9I2hlTVciqwZ9wBMMazyEi?=
 =?us-ascii?Q?jlesgujSRrRpzXhUW58a05awbOlLBuJHbeOUueNaTi0XmyYv4hQdqgothVKU?=
 =?us-ascii?Q?XP0T/5PMSKcdiOLoECHkEhEe3L8G7udMAB9/MygDCZFNE3BZXqqeFCswzAAM?=
 =?us-ascii?Q?hlZ+uaEPXcIhSZ6NcBoq2y2OO9RvY1Npo7F1UsZwbe46z4iv3alXO/EJK+TM?=
 =?us-ascii?Q?oGiAhvMc1IArFVYw8PmSSOZpMxnQyVZp0/wC4ieXr1oPylDzkWnVqoUaKaql?=
 =?us-ascii?Q?MSW46UYlOOXRjtyttLxdH3XKbMhfqFFeDC/N0p8Bkrmri77fCjqiMhVgQGWJ?=
 =?us-ascii?Q?vkwGO9PagH57fK9ci8cdIUHMXEFR0Qdz5uaeDf2ZvNNoR9MuoZuQUzJqoYIb?=
 =?us-ascii?Q?uQYWu1jKD8QFGhC4jczPcgaySEXly+fralrFbS2KDJQpVeucKsGkLDU1u/YP?=
 =?us-ascii?Q?b2WqsdsBWzfGsYpeDwDPqPkCvhXXbihNPqzLTkrqa1Lpljz20FQqXL/js6SI?=
 =?us-ascii?Q?76sY0rzMfFSO4RjdJJs82C+0ILjJDf1+CgY3AOx8ZY5laZuIdEFhCDy6I6E9?=
 =?us-ascii?Q?HhJxTR3R9Y6z7ckrlCDRoh4Z9fSnqI5/f1CgCuiJB5uJgxmKHUIz8w+6dAFN?=
 =?us-ascii?Q?LAhMcEpWZeEFHK47beGnZbmSbOJt0lIv3St1X6iYUBxL8hTsWBvbDLSnfCWN?=
 =?us-ascii?Q?W5+ltspQMwXEAGUKQSk1Vbhnq0lLd4qmUyxxjSqVor9NxUUeYwGc+MZaCqSN?=
 =?us-ascii?Q?5dF7EmL+bnwPbWUsDYAYx0RobuXEhC4V5Wmc5xvUKjKQvG8VfgfMxVqIKra/?=
 =?us-ascii?Q?22GM82qOGxUVpmC5kG0FJzqRGyMFJXjMgkQe1H4Krx167Y/E0jK5ahGnKu9s?=
 =?us-ascii?Q?i7HchOH7uIB86rOH9bytYeVon2rj3+3kPAOVgsLSUC0dEWcFRvyzNC7q71Js?=
 =?us-ascii?Q?sW5M9xxF+vZMfC40ZJOsdOkZoliEnw27pZGbcgq8cOtg9QFU3Ofsq+y+Jqd0?=
 =?us-ascii?Q?EDVulhiy/Dl4ECT1HYFDFn6cq/W3ebsF3rp0oYCQY0BNFav1fLJ6y0uKaDgr?=
 =?us-ascii?Q?Gh5Sm/tFZn9YWyi5sNHMxvbbgESQkBdSCB7KhM92jOiEOmfvdC+SqsgoRJa9?=
 =?us-ascii?Q?fiGU6Dm5rhl/2EDTubj7BftqyBnaReB0IuKpwcP6BnctlHjYRBcIDFNC1C0b?=
 =?us-ascii?Q?zcgRo92m9IphAjVreJGY12vMCxwTr0oXnuAZGY3Ll06EkcbVSaXFiX2awT2z?=
 =?us-ascii?Q?Pdy3s02pKCxyZWUvyHyB8gCxtGmht7+MLHxdedKsTbfyccKWB3da1pt4l7fN?=
 =?us-ascii?Q?ER8CmBdVj4M0sq1KAj4rr8AHicTIntrH3GJI5hTJ3js49gClwluzK9iM2Fvi?=
 =?us-ascii?Q?aRLqu+hrHN97XJShEd0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NeBI3TXzxnLQcjg2E5gK2hY7qX1tTD5bcrVwcVn2m03mzcwUIHYqXNN2RK+7?=
 =?us-ascii?Q?o5O6jpm8gsV27Bu7aUJc6pdOdUBFVv0Yrs4mycmt7X5Dza5cn3Yt+W1ZjeHf?=
 =?us-ascii?Q?1HRQkrbor6bVUtkBGBGyPNjCb5DF+CtDxfpjDK7jf69SFoUIaxwWQie6gbkC?=
 =?us-ascii?Q?WUtbp7SFdLVavbQCmboJFgXxlb2ksDIoCjgL89oHOCNW1IhOWLHxjZz935gx?=
 =?us-ascii?Q?4R9wDbIfzeyFYDma8VTlY5E5MxlerVYuUBxfSA8CW56WtYEz3q6ftFn/nsEr?=
 =?us-ascii?Q?SAiAPQlFI+gILYuIWRt9E0jjeT2jDMyGHel7UM8GdZKCWnrUpv+v8SYOPwUD?=
 =?us-ascii?Q?wJemng+c7vns15my3rWuH83QCuleYQmXv3aUvydIOfgBgVsJaQEAG5VwQHI+?=
 =?us-ascii?Q?7uiSBu/NypJws2evgn99ImklA70FGLjrFpFEF5TZyWVYBPSGIbaZZxsyKfS1?=
 =?us-ascii?Q?tBoo3Siwha/KG9jc1Wqzujit/5u7xWBPgctjdyC6xyJlMT3dK9vYUnpUHvb5?=
 =?us-ascii?Q?eLp927MEoLFQJPOb7B9Dtfl0LWD4Xx0bqlwrRozm8yJtkWfj/psyuXCMzUZC?=
 =?us-ascii?Q?URGNArywWzrXoHgvwREDezuXl2UMzfgxB2HGdofLq/H/dBgtk19FZnQMcJKm?=
 =?us-ascii?Q?6rk4bv/NbOYfYUgcPMUBfCY3CxXAsyQvKMsPb/MuGAYe+feACt8/d4Mhb3Hn?=
 =?us-ascii?Q?A2ZAYBO6a2qOTW3LVkn+VVFl0ZyA5chrX/3+sYZYaxff93/l1Ja8ZTkGBV6s?=
 =?us-ascii?Q?DJeOSzb1JuhP2nYoyeBh6GzUMWLc2RPP5zs+kHOQMCt4n/5u9NlJyf38fJ77?=
 =?us-ascii?Q?1P/enojSI7fpQNCRgqo0ZOLCt0VXxbzXK29qWDXNFrSKTrEzYPRUH9E8jmHO?=
 =?us-ascii?Q?5GMbmi0RhhdxX9CIicu0NCXglm1yZ9mhazt1UCtoitA0WHhUxMhmEyM/cfWQ?=
 =?us-ascii?Q?FdFBzVS0PW5BiIjp/PrKRongynMI7v9y/6jbxK/FBIer7zPNxFbE0RTEUpRL?=
 =?us-ascii?Q?/cXdPna4iAkWzyhj4/bH1rhNZUMS1hncp9XGkRdR7fIuekrPqCQtMkWXm6hB?=
 =?us-ascii?Q?cop9Lvrf1WbfTJEcZjVQMHgheh75Q74UynC6B5fK8kcZuRwR2BELI3Tpwz8L?=
 =?us-ascii?Q?uttu7zQ6mu0Cc8AYTHuKtITTRn07DExRh/JaWZtF4BDMsFH60cyYvzlLGg7j?=
 =?us-ascii?Q?QIvvzn6SSsB3+Cs3lhOJAV1yax2qeJUuaGDvafKsFLPbY2mrdAf0II5damSK?=
 =?us-ascii?Q?h8uFP06f54pm0+fVYUZwdyCG8i0iZ2Ewa/MpxjEnaD4cjkBXqvjdIafLg04Z?=
 =?us-ascii?Q?FVznx9n9R7GCZVbSlVJR89ghk7Ld1eWrhzuUJHmIjlJhMMZVMhM+/N2o2JfP?=
 =?us-ascii?Q?5QmRsDYBmOUC9fbQHGhIDXfdJSSMQIasFk8FXvbYj7TJKd3k6Osaqybkr1T3?=
 =?us-ascii?Q?M6ntX78ccmmnpjNLI/m+FiILHQqTgdxDzsrBE5BJl0vMZH6cu/7N3de7juib?=
 =?us-ascii?Q?TUErH1OvPITigooxYZ1oAaBROkz6hBZTja+oJoHy42xb7ZfwTqHTr8Tmyil5?=
 =?us-ascii?Q?y5VcLzov2AXndlIpiMcxV4P1hXONEyhWyVnRrkXOIYC59cs5B0Q70+wH8GS3?=
 =?us-ascii?Q?CQ+yJAjLPKWZsJV2US2D7VXazH1ddwSou0nFvQZEbYE3G43MqXosceQ9plPp?=
 =?us-ascii?Q?/HhLV/Vaj65OTBrwsdncCiZQ5uZ3HY9tg+jzVlnaR8bzyqBeD9kv8KrWeEy2?=
 =?us-ascii?Q?OyWSBL0nmu+XrSd5clS4QKVWidl18Lc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QY1EHW7jC6X+Uh1j48j1Iwv2PV9bPC4l+58TpZSCpjNnQL+fS30qfNT8+88qz2jcn6aYstQnkpfATSfMcF/wzXXy1eqrw2WffpM6IeZvL9OgVx8oKRh/70YDv1TBDkl0O0LwlasQJkgjZsgt5uRPOEjO/aej49gZrp4T9XUByTt9Cr3FNSlLiZS4ee/oxIzexdnr1e/7SUkq5++AuT0o58QNZUSwwVNKIjCt53cdo0SjqYPGoATJ3/S+u5xoGTQtMgWrNf6qvbOTXFW+leczssBzWd62v+UGVpEGvTbFQ8/44whHNEd968fqMWbz6ECucHRO1WOEqsPs/jnCvtUwObO6oZKYi8OiEO31zNGRVnYEtftLl/CWqRws3s2ZDADml0fpd2mP+GcEafv4za0q+xlCcIbpBZMVw0lP0NgTYuAIxHqhJGM5scQNtakeeUBNKcbNeCC9RYS9e62siBCoMQkAVu6q8SjFcwVQRnvFmIg2AcsosFKV/sC1mKSux5uhzd4TGPf9VWmhOyN1u7reDo4eJoV2is4hdCmVcLkIBfXI4r3OzujA+4XOdNZUM/nFF4raJxrSR+sJKiEre8wkyqdaPdtm+wD60VCGGcnuADU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de6bebdc-6a77-4a92-90db-08de59cf7ae3
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 16:01:18.8719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ew9AzuRuytSEFFyWn96rOij2JgAy3HufrfFin9loH+y6NCF1erbhNIOgSRjXVNcCYW04ybNENmPEJ7usa/zb6dyhASKhxy8bmOP1/Wfm858=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7216
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220122
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDEyMyBTYWx0ZWRfX6UYcq6jl2YmS
 Ibqkkd0O0xNg7m9YMBgKsAkRL9f/BBF0LR4UZzN9ZLj3SJpUQuNANcwSDzQocY3ef7iHD5eqrbq
 a2Tbh2GyCdiqIQsb+JV8im46vr5B/EYWv7ONXpT3AF2Imf594yYJwvDsYLu5ygj9/J4eO+tFjcz
 S0cAej6Doa3cBLZD7u8bHDqwzSbjAg/g5F9++RYKVOg5cjF+OGHCNbh8+5Vi3u520ASwhj0mr1D
 aqyBb6au7M0bdDRGgMHwPHoWLc3dc9UspYcCaOP2OVsXqjH4YgWOHqcgf9cwEvAjcfE1FYpdLrU
 5VjwtSVESQhqLamFQyX6QuLGDQ1IebbZqHhDBii8shRY/9vnuHTkSpdc+MsYoCXclhfRLt6Zdks
 fQbk2aQjcoIv9gem6eEmU4YF3DXBEMUYSp/6lkFLvvkfEtIPnFhy6RejqZCn5p6I2b8KLw8stCD
 t/OFmWUxLVz4akIAHn92DN6It4dUrZT41thCwYSM=
X-Proofpoint-GUID: KKyPWI_iGdkXXNXddemsMrtgrdMSOO74
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=697249d4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=f3bcOPbTrJ2geIPdng0A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12104
X-Proofpoint-ORIG-GUID: KKyPWI_iGdkXXNXddemsMrtgrdMSOO74
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C68DA180013
X-Stat-Signature: q7qs57ar4oaxgexc1mmo3f89wkhfxn8i
X-HE-Tag: 1769097707-554850
X-HE-Meta: U2FsdGVkX1/5pbzDKiNlRrKVDyb8SfJ1yLVDFEe6Vjd2aClKI7Rf8+roKakVxpjrLfUABtVtHKb/JISAkezc7lK21UVSpiL0eAfTJYuEONpIP8e7jTgymM3aCd2DMBE6ArnbDO2GSA+FOfMdq7LvB0cJnqqoWLJS6mldcRUWdbo6xGxxjCEyuYEv88ZgTYZ1SiJSZ92mhtRPzI/hd+LmME2HudC6c+CurFy8DX9OKZP4DjC4es/MhsKTamf9UVj1qftr/uN9F+tDJ/Qa9l34oSdRE3xRT/hudtk/Rn+GWnZpUHEx+/6CxJfViy5TMujAsPn4FIWYWgZIL/eOP5NwzINtVlIk6pCr0E+htcB12wsZuvT2N4f9ZnllgPpeEvhynbGfWxqKEu3pJvSj+n4qARwlvZPsG2rU3ppgLhkbA4VpMR+CJwmst6BXwicWsuuIl7rG4GuX00/6gdUN7fLGs4dqgVOvg4arCWApV4jn9AgBqxBNlFt37iTssn9yG8QWuaMqeA5V38pF1XUiJb4trSYJrvUVbLILqmNz7NDyb6DzehGXj1lRR866lAQS2S5dFFEDLpV44slOU322s3qbNaBFxZPAa7u49TiDXfUTs/NTb9j7H0/wG5bEEApOQBCY1G7Fy6Bb/Oak4soCMnubdnypmEV+CowZ4IVr1EO7hFEehXbhLe0lRvtGmTfv/uWxhrCufekwed/C+GMdcxESI5/RVFqrh156llxbW5YVcPk5XU6Txck4O+vCiXWsPy46QXXvfiUnGQZFQ6lykmwvq/f/D0kVHzCJE5EZ88aRYGJBIDtLVOXvagzJBC2eEb4yVW37JAUgpZK+yoIvOk8w1yqtlqeuCU+pVHSkyQfuxa81v0MJ+j6l35FcnfHyLJgAnDD3YKZ/86sPYB+VGBWRuxoG7rwie7FA7RG6nZVOJxOCtAXtMLM2jzEIXX3ZIQL+I62kY3TU9vkSEOpW3oR
 wMZlhzMz
 zwnNzZDbbvGIPk6ebrubTs6hPcq4cGPA5ticW9JoQI/IO7RACP/05vxnRiIQiNhh5bMgxGycXS2V9GKv1ntJkl+WE7kt6bHp95m28AgbgWhHrUx3EN1yIc7VYxAui1Vdn+UgQ9f1qOOI+quk91pJPkSVLeOS9/H6RZB3j6xp9ekROmgltxEIpOh404uTUKq+XYAqL4YG/UK4uAjBIzqLxwzQjZ/D4uMTwwvv6aTYCCk7VAYAGy6i5JaB7mebcNlUrqAbzqR3KaHrLTA07qJS9EfV1KQs+j9unhK6Ma6DeClegdzTdJ94cP0fJva0qjkvZqcoDo1WCOmYE7Xz9doYp5CMe9dO/gjZWZoCurlV8ax3mk0RZp5dyhaGeZJ7xev7nooDj7QA5lgN60CJy0+E/DQsj1fwLXdhmLxqudS2w4jPEHrZyEAHcRwO3zxSr2yXUGcNMkkYuv9691UdcFl9Ehys3O4+DFbMyV/jmLJaoEzGCg6dfIiSlzVB3D4myoRNyW9SUIsVRWCmJOXIKBmIApSJ3SUtPoFlVIcKD5PlIIKZw2JLR63uk5K4xzIqZaXrFUOM7/3Te7fzKKg1Crwp5/a1b9eSF7ksWXRXhd/DwsWfu4802H1Vcfr19nTmIx44H6O121qiFGw2bl4BQBayNdqvZmsw/W0y1zDpuFGJNsGE8QcaGRlcFTVU8ZKqSmiIZQvI1oNcA8fWb/krXu2IUggNNT6nVC9K9nZwC9d+m+uup3cVW27kJ7ov5w9WJ7WrHWLAI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 03:57:35PM +0000, Lorenzo Stoakes wrote:
> On Thu, Jan 22, 2026 at 07:48:07AM -0800, Andrew Morton wrote:
> > On Thu, 22 Jan 2026 13:01:52 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> >
> > > Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
> > > be changed underneath us. This will be the case if EITHER the VMA lock or
> > > the mmap lock is held.
> > >
> > > We already open-code this in two places - anon_vma_name() in mm/madvise.c
> > > and vma_flag_set_atomic() in include/linux/mm.h.
> > >
> > > This series adds vma_assert_stablised() which abstract this can be used in
> > > these callsites instead.
> >
> > Thanks, I added this to mm,git's mm-new branch.
> >
> > It conflicts somewhat with your series "mm: add bitmap VMA flag helpers
> > and convert all mmap_prepare to use them".  I believe that a new
> > version of that series is in the works so I removed it instead of
> > attempting to fix things up.  Please lmk if I should attempt to perform
> > the repairs.
> >
>
> Thanks, I'm about to send that.
>
> The conflicts hopefully shouldn't be too bad, let me know if you need any
> help with conflict resolution!
>
> Cheers, Lorenzo

Actually let me rebase that series on this one to save you the trouble! :)

Cheers, Lorenzo

