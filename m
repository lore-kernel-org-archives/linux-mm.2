Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E4E1CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 19:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9F4C8E0006; Mon, 10 Nov 2025 14:53:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76ED8E0002; Mon, 10 Nov 2025 14:53:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3DD78E0006; Mon, 10 Nov 2025 14:53:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 912B88E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:53:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 31BE912C923
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 19:53:59 +0000 (UTC)
X-FDA: 84095748198.20.C488868
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id C74BBC0005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 19:53:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l53QQO85;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lV6cVfYY;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762804435; a=rsa-sha256;
	cv=pass;
	b=S3QzN1Tikh9+Qt0OhBtZXFo+6eKRvMfMEoMLZGbdxCK4tEvEXHtZyye5ThWpfkfAx1hxUz
	nm79sIseFp0IooA+81EbAIPzGE/UFuo2No9y4+zvwAD92DX2luPS5zJ3HV3/lQF6b8e9hk
	6rwgI9c/JdzWO3DLK59ptNySJWLEH18=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l53QQO85;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lV6cVfYY;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762804435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4iZtjxFsXosRGL4NurQqr9hlhcKceE/L8GALLJ9tWw=;
	b=TD0lq80OuG6h4xjC94Xx8DZMi67EKHxB/LqKJzygSqKyfOJS53rLS4remb/KpRG8sfjx8n
	m+BdJzWi2j+LW6PROePGdP93BUrJAnGU/hjfJpIe2PSh4eIC4IJmxph0+bx96xJy82akUw
	j3wAws4DluLpfrRCR0F0F2yNHthtKgo=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAJaCsH007265;
	Mon, 10 Nov 2025 19:53:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=o4iZtjxFsXosRGL4Nu
	rQqr9hlhcKceE/L8GALLJ9tWw=; b=l53QQO85opofe+neOLDn8+i1btcaigznz9
	EDxRo8TbhP081uV8EwE7rpBk0QZioDfHT3F7Ws5d+bryaLEn7Nu3VhSld+udndz8
	qeyWNJI+/9GARmNuoGmhFD/CAd1/rU5n+6gV3hLmyOdDTy2mTyAC64mXLsWJ3pWU
	4XXgk4mKlHE8pppIkHATSSyQEytMinMVNrol8e9jTOShawfiOuPd+loJNN7SFAOa
	Ti2LYYuFTwq5FZgOOxGPmY37rVYNgvuaSy+dKAns7Ag4wxTCIcnyQDLEVJgmj1HC
	/bUcBLs9B4CxN22LiL/x6Sw0eX2I0rseozkcIRQBPv/i4XXZNPbA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abnaeg681-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 19:53:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAJl2Or007627;
	Mon, 10 Nov 2025 19:53:44 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010042.outbound.protection.outlook.com [52.101.201.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va94bxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 19:53:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MwHAf7qTQjsuYV/QAJ+e9oJXnGMQB4empOg6WQI8Rx0RPGyBiaWKrg9PNlnGA03xHV41Gj3xXXLnNBd9Jk8F3/YLxxidXL52LxXay8fnn51+FilVhCUrrZXjbLYGtgCnRMGQkKyvb81neUZtcFsloWidK/eujemEQU4irrBGpoTw01QI51qaWSDBjmi/lyFMjmxLK51KqSywnWmp18k3jgLaxrMMEFmLBFgNd7gCLoN49EH7k4HEYmhZA+dYfDxYmm/GrSV1U0xjajgHtXwcYW/FONZRg58uwDTpdhzVLVXiEMjhVlYxjsnuAnZizkjU858oUgPB42QR2PrVtFbyyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4iZtjxFsXosRGL4NurQqr9hlhcKceE/L8GALLJ9tWw=;
 b=A2qxHFXwrExZoWtBcl2CNx/N5l/1EGvaBKVgjKZ1PYDW4/MmvyF51wrJECfOz9kRXWC6nxyCldaECkJxgvZQHTHML1QvVaDB3skVKG7SD5ptzVmqOSwiUAKUa1qxb+MY64KxNvfqUVanq8duNyjaEBfngEa75VwoskKjWiBzKw34DwIq1Qa0NQydaMlBUgiUbExZlJTbdAJjd6GxZ4i68K3sHUkM3J7VcNHIFBJ+ppjWPjRv0HXlvnAm3JsFsIg6L9thZG1U4e6dNLd7wXvKGruckU6be1Dx3y7HCIklYKMwyH5hAZUfHrtHDquu//DqY+uuIM81Di9rL8UE6k616w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4iZtjxFsXosRGL4NurQqr9hlhcKceE/L8GALLJ9tWw=;
 b=lV6cVfYYxkScP/ub0k6jO95ey+K9bdR8HcEiO/LY+xK8T8muUCvwz7MHvKX/diREBWYZE3QUIWl7NnS0X5zSLcX2eOXOOcmrV5qO5gO5jnvA7YnV/BgO1+WhwlXXzOgIzh1ao30tDRSXvWtJDQwXCag7peMpSfmneVJLmFStGWE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB5550.namprd10.prod.outlook.com (2603:10b6:a03:3d3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 19:53:41 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 19:53:41 +0000
Date: Mon, 10 Nov 2025 19:53:38 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Branden Moore <Branden.Moore@amd.com>
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
Message-ID: <ec53bd13-42ce-46d5-a1b8-c4157663b60d@lucifer.local>
References: <20251110113254.77822-1-shivankg@amd.com>
 <f21b37bb-7a2b-412b-be76-e8968b4c375d@lucifer.local>
 <3b10d11a-3c75-4c37-8810-e238113ce75d@amd.com>
 <bc07aa10-d8d1-435f-9393-6c4ab63cc179@lucifer.local>
 <e9a0ec60-6e8c-474f-931e-2f97e5bb60c0@lucifer.local>
 <69FF5A7F-1414-4DE5-8A2D-09ECE240711C@nvidia.com>
 <77925a0b-fa06-4200-a967-a66bd93201db@amd.com>
 <27920b64-240d-40f6-a02a-0a8c433ca9e1@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27920b64-240d-40f6-a02a-0a8c433ca9e1@lucifer.local>
X-ClientProxiedBy: LO4P123CA0693.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB5550:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eeedd1c-30b2-41af-c86f-08de2092d911
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?71DE3HyYihJKWNv2oRqXC9bmCy1UY+K8DCjnjgf/IsF33t3ie8k6mj8OWJP3?=
 =?us-ascii?Q?jZIdxedaa9x0HRonp55Ls3kpshPI9ZmAOHXgG9TqW5R6D3Lgu+z0OiifEZ8u?=
 =?us-ascii?Q?0Pf84wKDJaeZospK9NH0oZ9QA6jP5ngFi+wSd1S0vEl/WK3Nx+ZFBz4y52Wy?=
 =?us-ascii?Q?bXuaNNvIZ+fSwEpMEdutYyYmvOfgRyCaOfuiPnkiZCJqGlqxY8DQmN47zv34?=
 =?us-ascii?Q?oTnin29tBLQYd0ZecbQDxEc5TqmvoKHISVaEy9EWqw6x/Zb1RhPGQ2aA3U/M?=
 =?us-ascii?Q?eSoTT1/AYIZl4Vgc80Ozwuk6x5a0qFt9f+3s7X2g7Dfv0fCEHwsSrrEDaIkw?=
 =?us-ascii?Q?DhbYAxgA3MoGtDjsxZKZv8MzyE9JUBX/1XvGxkCFsjmHiW7F65HzRcYbn3bl?=
 =?us-ascii?Q?yuJQv8iDJtrrwX3statycAY0xKfmbfbDtns/Gen4H/B/D0W+lE/X8j3B0Nuu?=
 =?us-ascii?Q?ZOAfqgkQ6PVezHAMnLxnuQlQhezL0HQNqNNeyw3nU371rfzuqysoR0VrlyPp?=
 =?us-ascii?Q?GLvlmGBZpOWBq0N6rhCF4BEJVcb3MpaTtNPBE8v+EGcRgIdSEuy4eMvz8MjC?=
 =?us-ascii?Q?Y2PicXIwDyc+Ehvtw9uOedq99F93pr6Nw+MDksJLntvm7/nB1VNOa+MfVhIO?=
 =?us-ascii?Q?p/yk/wUDY7mLjEOQPRIMoCK5FkLQVw8iEu1zw/IOvjvJk0MhFgRptB2N6U7o?=
 =?us-ascii?Q?axFRnwDbqKFfIrDyx6NA0iJWcWuisJ3l7KrnZyP2EceKthV3twOJj71Qbxc3?=
 =?us-ascii?Q?q47KDBajFqj1tTIRMzDgPINO83gGZm9auekkfF4HacvUGRjHTHIw4zx2J+Qy?=
 =?us-ascii?Q?FVroguZGIDDQcQPO7aiUJ4h82j5TBzN0yER8se2aRiCIfR7lNkihQkIi3i2e?=
 =?us-ascii?Q?JAzawlSXDbwrM9nw8g/noV77VJgIBwFqdhSxav+OCGbwcJy7OTK2TXpYQtNw?=
 =?us-ascii?Q?7GByFZ2kbo+Mr5vaAdipcnJ7kOYVg86yLt2+09IPS3eL+PbVJU8r2mLIOxNP?=
 =?us-ascii?Q?r2h9id2QXQtjZZA5bJWvEw/3ItqrfwOZWMcRqdMYvbcmAo9SPaHcHw0DBMS0?=
 =?us-ascii?Q?uCxj1/unDsFJy5QdIt6bWrDJq1YOJDweccPBnFPrNJ/KLQWvoGtgQMUsdcT8?=
 =?us-ascii?Q?3Ht+98SNTmkrMh0szwkSUWR7OQa+KhTFuPaKZb7/KzRX/wCpz4ze4qAPKvDP?=
 =?us-ascii?Q?/vgU/iAu4UUSfX6zXifCXurl/5n5B34yP445zSlzxYN6UZBHJN0DY/VwJQ1C?=
 =?us-ascii?Q?4j81Gciupx7s85M7Kuzz83WHbywZXT45/RUww/qtgmIiXkyQ+j84nSbxzxDW?=
 =?us-ascii?Q?9pAikrOV/KUFXy5FyYRRrIT7olvA9dNSL+QVbirRHDVoynpCKZvF6/RvRhwT?=
 =?us-ascii?Q?kTWpf22CJIsqWD02G+VZ4j0cvcLwDU5juNOqHmgK8TG38d3bf5V9wJQEboxj?=
 =?us-ascii?Q?fvsA/XrCnmPumjjEP4VIYozBGDYhpjEu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hc+ax+t/sVKBbvtOJlUWo/ILSDlf4c6DjM31RcA4MDvvh65j6HwiorNuEWyG?=
 =?us-ascii?Q?qDxj2V7XHfsvLBJsFVmavBrP7wYjwpWE+J3DbKQl/lUGzemyJXzo0gPHNaXh?=
 =?us-ascii?Q?T0s9Tmide5NKd0afwD1Rq5sQr1+a6ArIIA/YXDDqGQgbjZAL11n4a8TFRmRs?=
 =?us-ascii?Q?89QIEZdZADG0Dr9LpAKPjKxhmvXBVCeRJby8U2Y7hnmcD32K+W96NcI6hCej?=
 =?us-ascii?Q?m0PwDo5Bz1eQo4qIeum9HFruGtDvPny026xsI3RE991CSIqkH5hkUR5fHnVc?=
 =?us-ascii?Q?1mUDNPa6L4cvduRQuAcyq7Axiwz4APwoCLqwMp0BQFl013vY7AozYxyg2/x/?=
 =?us-ascii?Q?JldwtwFNZrgGBxhmni6KrlSO0yL+D1ZbNY2r5jE9ACO0afq8Jzy/3PfwAQ6f?=
 =?us-ascii?Q?VYbX7ai05xTsEjza11skeXbNOCqdCybcolEUI9YFv21w4HEjpt+TyAHHOfbB?=
 =?us-ascii?Q?hYOPzTecH1Dw9j9+ZNbUa+EoPpQLA+MTLjKOAp4673rcZxpGPP30ux0/4+L5?=
 =?us-ascii?Q?96Y/YFysMuvYA3iHdAtq7/iNwttCpobdoqXPP9IuV+Vy5k7Uh8WLqRLE4XRk?=
 =?us-ascii?Q?u+GyGyEz/jgS+/kcmmN70x1FLGRij8Uw01tTwpsEvSvW1L9aqkd0RAJqqhrZ?=
 =?us-ascii?Q?yjVMsB1lCrQzgJ2D4pNVacCA5PdGBTGHgAuBxcUI0clux1koLqSLLhHLDtvK?=
 =?us-ascii?Q?gzws9nsX7uFECWrBgJPY3cq05BqANJNGUsuWjSkvlqdmcLrT2u7EfLupZMHX?=
 =?us-ascii?Q?CWB7SFx2xqUGgdqUmlO1DYaAF3BRryJ63eNJ6sVjN14NnwgKNRv7gmJiGxA3?=
 =?us-ascii?Q?t4/JCZPiokpnQ75mxfo0rHCMuDQUPtrLEiRWsNClLcW2iBditetgRGslq97C?=
 =?us-ascii?Q?T4KJ3GPZ3r86ESolAUi08hNcjsk56lE68D8VO7dxDuARwAzvyoZJUh1vcZOM?=
 =?us-ascii?Q?xRsqYUjrWIZP/GiLmJl++tDuE8V98MDjgH4/K1deNVTwaJspjuWCRWLd7e22?=
 =?us-ascii?Q?weTtQrqiPzZWkJwNj+Da/S2NmpL5AO5zuKzVSbLBmiAHbuTpGmSmyRdrsWNn?=
 =?us-ascii?Q?iayQvHsgdi8SdD4ZROCzVRT7+3ZSt4edWf9CE3AJwPnhJc8GLSn4EZ+jaGgG?=
 =?us-ascii?Q?5436Lfsc68XHQg1Nazdznxyt37JGP/PvAW8K7vtf3y9meXBai1qBImCJw2nd?=
 =?us-ascii?Q?1o8FFcOMLfR8eA4ijr77nkbk6FdJvOP337Gd2wpL8XqMIFOB6lVdRG4hWIjc?=
 =?us-ascii?Q?3qvQrhXYVz4Fj8cqlD1jrHDbqZKYYMQxCQpRl0kP7kN1b3I3P/abJihMIHjP?=
 =?us-ascii?Q?yCDJU7J4wxrECznsbfjSrrx7eq3o7y90NbbUwa1eIX48Ev4CKFXbDsrnF8Ve?=
 =?us-ascii?Q?RfjU+HpDrYrsvaHwoQJw/i53RKgGwp5w6TBaSIavKtXv5Gg3RSjZauawm4Tm?=
 =?us-ascii?Q?jH00jjwzQ3uBlqkPk1YhS2YRyHHIofXkcP/tgamlqY4o78Bqlbfue+f2sy5C?=
 =?us-ascii?Q?WP++BDd/Qp5jGA9Y5ywIq2s7NzOdUD/6m6GKsTA3GYNg564mXLY9GtZ+kOTX?=
 =?us-ascii?Q?IXlc0EmvRRB6a7ogm8CehWwt498+RDK5S89qI0FgRMYx316287pncAh9VhjI?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FyssUJEl8NCFqYNJx2NRgKveEmrztfYm6uf0D4lm+gXM18ww/dB/2rH6dISeOUbHyLl7854a+DU04/y9utnlpIJSROx4suYQ5FxmhqZ3UiumeN2CDRD008Nbmyorca16c74V3VLI3+FJjuVdGa7E3bJxF5Fhe9o83twfezWmfN0btKx3jyXdpZpfvn1tK36BVsrNLI8uacUuQ43Ho9GfoD3mmHGC1ljqfDpJqtYgy82fSiok6/a6yCmn0lS2hjW11VXWYPx3kP9yAI9t6LNaze6InNZpkZMoZxoBLW7RweMdTkwztDup4KEbGIqWwG2BfRtIZ9IXerXflxlrdQ8WaMvktYV1db5BYBJwhMHvJ74qvZuyV6DHKsGA7bul8vOSmIK3NoMX+wBf4UdNXNngv4ppope04czLzVRwg5873NZyp1OcVSr7Aqrs0Hgrjab6RUdpBZovzkndcBnjugxUZvcgjZu0z2vl+86KyR3kl3gfgVb5IL+y80Ypo+zEh26KZScoO4iELkjAzN4fXqcL7SRo+Cpg7+/uOc8PPkyreWjpEco1ZVwQurR9ZvRr4r9ob5MJCRqvzY0UC/LNYisPv3yiJFWq2vhea+Tcz/f9acA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eeedd1c-30b2-41af-c86f-08de2092d911
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 19:53:41.3003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NdZYr0tzpV42PUn7d4VfCe8TLM5KWNZHDLoExijQiuRH7lT3L+WaJqHxkzx2nt6kP3B7W87m4H+NiGhUMA+Ggj3gdFHHsqY9CFg43vdL72I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5550
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=987 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100169
X-Authority-Analysis: v=2.4 cv=NZ3rFmD4 c=1 sm=1 tr=0 ts=691242c9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=s5JDV1NXMDPXgfZcC0YA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDE1NiBTYWx0ZWRfXwYTnDXkVS9/D
 nr/BvdOBq70nDQ+vynGKQVR+NVLlm2ybXyZSKbteXHGm9s+J+1ZNJsONauyoBJY1yvLf/YTZIDq
 VVKbw4m7K1Jwc2z5QXw7GVAqINBU5omxbq+Uex28g9+RTSlogJBoZN54sLZgqEZVuAtxfMj+OTJ
 AT6dwVR2ZrEKDxwe7xAS6J6UTBeJlF08D2A4NsuZCfFlKrZRiV0PuFHXY/cUjE5um52+jWcu0aS
 MPGUoGKkuKvwuxI6teQantPmP8zJD7Pd6gOiLz7s9/5YUw8DQgf2mtXo8SfSvK8DUpkEg8Zqx7X
 Z8UJEzrXxq9WFeNwLneqv5y5y57UFuI5C3PU6IVVzVKRBC9T6XzMkRes21JeS61lkeuycENw0Qr
 1W1AbIW7KIfMtTz/uKXck+CV1AYofA==
X-Proofpoint-GUID: LY1EmBcdfmOqwuwQyxGqPWjpUdi_ORNY
X-Proofpoint-ORIG-GUID: LY1EmBcdfmOqwuwQyxGqPWjpUdi_ORNY
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C74BBC0005
X-Stat-Signature: zwbmfes7tufeot66i4499bfp969h3ogs
X-Rspam-User: 
X-HE-Tag: 1762804435-155923
X-HE-Meta: U2FsdGVkX19kaPbOb5EIu1EthValkSNSyZs9f6KL5eGdGezVtpT4uDpliKgRCEdYKfp6G6CGD/JGE72QC1J76GUb7qvzAnVwkyAZwXc4ekTM4uz+9X/b2b2KGNtuOOaYwF+6Stkn497sWYOnRnJS1LrEOHBG6ZMkmL8peK9io/9BXvI/DTc87Fb8198Jmu1rXuTDE6MChSxIL/W4hBSM8W6aJqIzy3dWqgr8BaayqiV7ntrmhQIWb7l/hKvWHTUNlMWMaLvJir0Pq2ZUjJgGWa6hiu2v+BkpwzKvoEFJkrl8vceTHfwc0tD7AjLbdAEZcT3HWUdGz2GqBb/ew2ZclerGob8QmYXug3hC7DfLvr71ot9qVqKYAevV2h3u4x0zWLfMefUmem/qNerhU2VAdHy+z/NyaLOHYuGVav+RICFt5rutVGt5WhGQcVsXo0cx504asm7bmYJGcLIVic3ul4y7YRdSjheTpJi6A7Q0u3T4gk5MdWBRkYN/bToQmZ8LsWdZX9KAuxU3YpRm7dkSGM02WUvO5GE5YnaN2L4b5oXVKj2tGss8SP8rOqEmuC0O1r5avuZl87j+7LUhTCcO/FFXxVzFET6ZGuhDDIDcT6bK6mYtsmZ1jtFzl9LovZ0VjvBgteJT+W7G+/u+koN9zNn2KK48ay3g5E/GG5/0pd7vTIYeDyTxgSiiEwn4AcFxsgC8l2Y8auxWPpSWskkswXT2uMuNKUSixcno/l+ESIgaJzXtrY86ALFcpm47KWWzBgn8gIfVXm3rLvO5tCFXmXTGn4eK/k5I8u9Uldcva0LR2szY2TGMdmPVwPv9Nnkh/SHa0e9ax3I0Bcnx+39CqQaCDjMRiKdSNbMgzc9rqmTrLNzczcqKBv5MqTjgeNu6rEbYdGrb7e98/06a24IboffGdvDslKZIhFHbdBmCTCbtl/+9/lmJQj8otByg/KrWhaV3myh3TkDKjDZfrZh
 PhpYVNjE
 Hd0tTz+eFvYr4aT+1OJRKUIuxogyA+ayDyV2bJJCmn/6/+pXGgsFAEQ1f/XGWnG547xp1HnrVBQUywrn9oF5BuZ6LbLPkxMyo6jpUPtkNYymKSx6KTEKoH+gLLoKGYw1bt04dK+6aIWZy7q+eWlXyUOtdghzxONlFEtZoBreBhZtPobTphgxaLt19s57Phxt/QY3TKyTSmk8k9AORGtoreNEBceoQ4wH16djkg1vzidspYxPixL0J9ZMAhrCnt62BICT/G2klz0AGhuDbWbpx+/F24uTCosWJWUPTbJSOSJJBda1VdIp6x/3aUm37Ucfd8HBso8nPrbHkMwyJBZ4G8C2OHRtix/UqySYmYzplpGimXTWExviChcCr1IQJAEbzTQdqAOIPjw1fUqSkJdNvYqRfwwdrtl95+lm+XErubTMXSYXanxFOYBS4VeH81jUxAzdrgmmAwfuRqVC7/UiICcv2snbYcndPFbRHMxLZLIdRNj3Ytak2ahlXdlZe/SCeBUNJKGOb63QDveEsuBu16oVoMSLVNEQfXBO5/Avoeg8M1XaUV26/e7ByuRVuZGYo06uTgQacm0VxX75g6ilM+8fcH4Ic3L8Q9dHZF4lUouEJAAET2Gba6b5cMFyioCWdun1c20IfnebKqIERoxTc9Gh6zLAeatmd5TGvqNYMrnYrB7MhwLu0hiOeM2yNT2YnZykC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 07:48:33PM +0000, Lorenzo Stoakes wrote:
> On Tue, Nov 11, 2025 at 01:10:03AM +0530, Garg, Shivank wrote:
> > I bisected the crash on mm-unstable
> >
> > b14d61d8fe442b1cc2d7591cf040a6dcd7fe2dd8 is the first bad commit
> > commit b14d61d8fe442b1cc2d7591cf040a6dcd7fe2dd8
> > Author: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Date:   Sat Nov 8 17:08:18 2025 +0000
> >
> >     mm: eliminate is_swap_pte() when softleaf_from_pte() suffices
> >
> >     In cases where we can simply utilise the fact that softleaf_from_pte()
> >     treats present entries as if they were none entries and thus eliminate
> >     spurious uses of is_swap_pte(), do so.
> >
> >     No functional change intended.
>
> Ah fun :)
>
> Thanks, this is very likely a bug that I am about to fix in the series that
> was reported on review.
>
> Could you try the attached fix-patch please?
>
> Note that this might not apply against mm-unstable, in which case replace
> 'softleaf' with 'leafent' :) as there was a rename in v2.
>
> Cheers, Lorenzo
>
> ----8<----
> From ab4d93d299f0a0ca3f1fa5e75b2ac646695b632e Mon Sep 17 00:00:00 2001
> From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Date: Mon, 10 Nov 2025 19:46:55 +0000
> Subject: [PATCH] fixup
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/leafops.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index a464a7e08c76..325cc87c3363 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -56,7 +56,7 @@ static inline softleaf_t softleaf_from_pte(pte_t pte)
>  {
>  	softleaf_t arch_entry;
>
> -	if (pte_present(pte))
> +	if (pte_present(pte) || pte_none())

Sorry that should be pte_none(pte)... obviously!

It's late here :)

>  		return softleaf_mk_none();
>
>  	pte = pte_swp_clear_flags(pte);
> @@ -95,7 +95,7 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
>  {
>  	softleaf_t arch_entry;
>
> -	if (pmd_present(pmd))
> +	if (pmd_present(pmd) || pmd_none(pmd))
>  		return softleaf_mk_none();
>
>  	if (pmd_swp_soft_dirty(pmd))
> --
> 2.51.0
>
> Thanks, Lorenzo

