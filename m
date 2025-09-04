Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B82C4CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 15:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D0E28E0013; Thu,  4 Sep 2025 11:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083098E0001; Thu,  4 Sep 2025 11:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D598E0013; Thu,  4 Sep 2025 11:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCC898E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:41:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45A361A025C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:41:42 +0000 (UTC)
X-FDA: 83851982844.20.2B668D4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id B4B3240012
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:41:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hoKfRtR5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NEwHQ60M;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757000498; a=rsa-sha256;
	cv=pass;
	b=Zme3vReXZNFzYKS4TycvjymhdMdm6tL4KT41hyWC+3bBBeSn59Q2FMMAIGQ9VebwJfFlju
	AMMhl+LmQgovnCagRQFHcc2RZTDPmn3PEe/xpyTk41m17i5gvDsSG8oe5nAVU+9LBHDqJl
	sY80Pj+YmEUDNaXegCZp2FPo9jd44Tc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hoKfRtR5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NEwHQ60M;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757000498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qe44//vJUK9GKjYX4FvwVNl+aGqm/e3fa66GQAExUTk=;
	b=Xk7PtIr6j9DOYO2nANQEKIqmEhKAZW1FNMrqAXt+Id8bhmS7sIv6+Mqd+H+DA/E2LKssHl
	lXXvc/MMXBlmB9lHPfnMgtlTbYSYhBL/HsqdkwFchfAf5UqdEhyp64cLbWYEW5871ekJiA
	4NG7PqSaokEcrBHFU6Qpw5xrirntcnQ=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FOf3T021682;
	Thu, 4 Sep 2025 15:36:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Qe44//vJUK9GKjYX4F
	vwVNl+aGqm/e3fa66GQAExUTk=; b=hoKfRtR5qvaANapGEZSxN6cxnceUIwb4vK
	MQGR/X5MXZWmQH0+HP+OUInyOLEAYpOmAaCdvjfKSzGSy+/EN1bikKnHbNff8cWT
	4w+6dmyhNitiBeYruc6mw9WfX3VSxhsE+H6VWlrGaQqQfXs7UzXqbUTmWHYLBn2x
	iBZfJLkyU1pQVf9fdG/E6Z/8boiF2nCzqAP4iaLRILI/jEhavq9RYRpHz2oM5WvT
	ottOKZjIgjDMN+2qgWTKCE43bBLYMjuNv71u+FinqPEdRPD+Dq9NM+QgXUnSpyJA
	FG+YwvQfsGS05YcoGH53FOke4F6R/+SWwyq1NBE4AXF8DJmobcXQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydcrr0vs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:36:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Dorao032670;
	Thu, 4 Sep 2025 15:36:22 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013037.outbound.protection.outlook.com [40.107.201.37])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrj2444-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:36:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lo5XBJIeX2IP67QxVRS+6Cs6fiXOwhEerRhWT2fqGsDTG+kq/Zkilpp/OJgo12aVqb2YqcEXTZqb0ICkdYjoNpFt4yyN122r+e7OGWt8srQp1sftKRtrtrU4vu4OEy6YoeP+H5cMbiFAAlI8fI3V0O5LK17j4wCdRug0FhIkCCPV9piefliW1Ztgo7GYMvTm0oFtHAGlZnCVb5erfuRa83gSO9nb+30AgOpfDMXMtZPZPzJ1N+L/PBfP02r3vIwd5ns2D6N/sETRlJYelR6+I57pgBD3bXeqBriwb/k4g9lSCDLjwKP8W60XYuuOy7WMXDs88K9T3vn/x57GNbRq0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qe44//vJUK9GKjYX4FvwVNl+aGqm/e3fa66GQAExUTk=;
 b=blJu41LDZHqe9no/Y3UqocO83IstEsJPz7aReyIIjYbQl2Rztq/i98a/4NVK9wLvmHns5ty9puomAMXALgLxpJ4Rx3BRuwgt0fL+OL06xu8lHze2JE8czkm87BcpFtyiDZK0sIh6fDBB6MDZ3w6hwpq3lFXS0+0FmW2aibY7AY/UGaS0LYdhWflrLQfQavT1exiet2B6W9xfUcS82QxoJu3/nGTYDzBxUpjbnQ4RnfQxLYjsz0UiPdXF8OVZjxbDktjZm/pMuzl+YQVhifqIWXa6qnzIiyeBXu4kEOP1F7ppJ/J3sjFFoxeZ/UjjcqCRgtvFqLTRiSWeQIKJsWfXJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qe44//vJUK9GKjYX4FvwVNl+aGqm/e3fa66GQAExUTk=;
 b=NEwHQ60MSnbAnMpyt5kXG/GBZLgAYqtzOef1kD18j7jGxvfmj/mPMzJWzlRYsWTARBhPVwRK94Fs5pvVSSiYBz790MqgOnoBa2I8dKxE2tHmyU+dppw+dJ/S5gjJ/tF/Kdk2/gyI80p5R0ZKaWRv/SciozSNENp0zVekh6+C5P8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH2PR10MB4325.namprd10.prod.outlook.com (2603:10b6:610:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 15:36:20 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 15:36:20 +0000
Date: Thu, 4 Sep 2025 16:36:17 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 4/6] mm/memory: Add tree limit to free_pgtables()
Message-ID: <6b94ec3b-5f03-4201-8e5b-bbf2aec242ff@lucifer.local>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-5-Liam.Howlett@oracle.com>
 <39c46a52-f63a-4f3d-a276-6f59c55680ba@lucifer.local>
 <hs5nuhqzqyt5mp3fzznuaiyyck6b6ovuxoxayvm5ofhoa5324m@gtmezuqareiq>
 <a3777992-21fc-4e55-9a5e-72b17dc86135@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3777992-21fc-4e55-9a5e-72b17dc86135@redhat.com>
X-ClientProxiedBy: LO2P265CA0516.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH2PR10MB4325:EE_
X-MS-Office365-Filtering-Correlation-Id: c0c07592-808c-4618-5b24-08ddebc8cbaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?itQ02c80PvMr6ib/lp//NWWwqap9tRF3xvh5H6ugzT/lWaCV1tIJi50Xn90d?=
 =?us-ascii?Q?DXUqbFhdSFey9kPzukqiTGG7BmIvTMCqAuccjNsx44OWYEdl91z/DhYTtmgb?=
 =?us-ascii?Q?Aw5r4MiV8Ire294s1nHacHsczSPFDzZoboCakjz+2YR1vHfKz7/sOai113xQ?=
 =?us-ascii?Q?uFaeCbYjWgpX40Lo8rCFzrn6Rd2b4QxpSo1sKprcwi8RrfYkLwKVMTM7VVVL?=
 =?us-ascii?Q?V5OwtAiidX15m7wOihnslJOY77SVonUKXJrnyhHvFCzoba9vESalIYPSSUUu?=
 =?us-ascii?Q?JBABBKsGIL/dt94+8DbFfedBfZ96meMhSXWxRPA/aXffvqyorxvuZsZtSiG8?=
 =?us-ascii?Q?R8VP3jSqYfN/PgSewYKaW+tTz3egD4LcVo1SHKEPMLBaZFJxbYu6d6I1yL/4?=
 =?us-ascii?Q?Wsyv8Q63UXOH0TkkZ+V8l8AATK7xRriiQggKky+KUdAIDtt/Xc4SdMJ/y+h8?=
 =?us-ascii?Q?yKC2xV74kiDG0zBMg1kWvAvEksXUvKetwmI56G7iXW7wPuWy0VBSUWv7XkqR?=
 =?us-ascii?Q?5TVAM0m3OJ2yBVSx0KFD3YEA/J3xgWX7brlbkBDRd+XSOzQjaorkysyQKuzX?=
 =?us-ascii?Q?JIKB+Xy1qVUpkOwwrXsrUTzCojN/bp+W5L2/+z3OAiNGELpXXUV6RiYRVG7q?=
 =?us-ascii?Q?Ri18BDBIU7N2iNL5MWX9xEYHHyaxO5np64/VJZECXz88HLISKPrcFqUmC8PV?=
 =?us-ascii?Q?AwK5TyIS+zlQAAC/jkKjh4eoef6iS33Jbwml56532Goa/0VE8qpXJ5Dg13v2?=
 =?us-ascii?Q?P7sIHLWDSnEYu7qN1KxFI05GzytZsZH7/QjSPKxsqZhmS0qvzvnZmdJ5mwcX?=
 =?us-ascii?Q?4vsSqbFeSCy3xUUx8tXg2Cfn98JzN4OMg8UWfbE1pKrUZ/4GljjMSr7Oul9s?=
 =?us-ascii?Q?xXF7ynYIMOaET1WXdGxd4ed6ByR3jjmklN827gVVSFdbds2Rc9FiwT2ALiPm?=
 =?us-ascii?Q?FkNnd12jr36CdO4I8pyRyAEirzivXYNj1+x124+Frr9XxgLPeiv28klEc65E?=
 =?us-ascii?Q?8+F5JMUg6x0RmVg3KSGCwlnoYqkawh2UEwHVM6+AqpEE9Zzlq0/PPtnz/2EN?=
 =?us-ascii?Q?qw9OlZ+nsRwwITJznyBfSQ3KlIdOJ/8hREXkXTfNJnGVvaF0mNl6VP2ySGdh?=
 =?us-ascii?Q?G2wjIUFMHIJ+ArMRz0fQ2a6nLXMa5WR0kHNCPrE7mPv+7VPXegM1SGFA2HEQ?=
 =?us-ascii?Q?PmH/oh+AxoVZapvYN0KKy5nTkfNeodPr/9Ybdku1cgDs8dDRpPvbtOgoVccb?=
 =?us-ascii?Q?VSG4BjrS/KFHRzsQvg1hy8jyVn+8hMDZaaM/IbXb/WgBkL76U+yHpdeiIv/c?=
 =?us-ascii?Q?kdeU5kvozdxMbYbaTRFPWNwhlmNk665cuNRXa34e6V14UNFcvpcdM2E2PZdh?=
 =?us-ascii?Q?SItP8NAiTzo0S/Ag3Ru7VqcwHDF3Xay8UaiaQSu1fCaWhMfOCvoyUsHeBb1Y?=
 =?us-ascii?Q?Mmxlk3Ite4M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QwpxomDprVGBXKVx7+S21S0e8PSsrQLQMcuyvbC9fGwDsUerYkoGQP7KlTjz?=
 =?us-ascii?Q?HmGxr7a4fwZnSzIz4bFu6QMTm/1vPtdQm0o9X67VOzjbLWnD+T4tdRTtHFDp?=
 =?us-ascii?Q?2R8VsG7X0+u74BQ2z6QiMO9l2+Bq76Qi3PcfImPnoZy1/iOa+cua/KR6/RI/?=
 =?us-ascii?Q?LWfVJ1KTT8tTMwbB7oaR+39M4Wozq/ACDu0fAwOUxexMYQ4tOKEzgsGC1JBb?=
 =?us-ascii?Q?ouO9osUJpCt/8XvFiAKgLAgr2Wd8tcSeza3qpBAHqYFp9dxfCLOG/iA8sVUa?=
 =?us-ascii?Q?JtVdP/x8Pzqxd46g6gKkkUEIzx4r5gihGnqwzya5nEotY82EYmSs1m1Y2/5a?=
 =?us-ascii?Q?N0hBhD0dqx9rjZFrU/FNevKsYY318iYCjzwTD0ee5oEbbChfnJMn/vNFnPqB?=
 =?us-ascii?Q?k4I0/kM80CZk4aRxSD/ohLcuuJ+9a2GOai1VytH+d0sqtn5L6p6pbpE3GkA8?=
 =?us-ascii?Q?4iG7lLMZfa5L+g/KDDkMJl/3OldjTKqhqLzUGadp7egXfqWNQw/H021M+tId?=
 =?us-ascii?Q?NgXbOUH9lL4L9wNzORds3VlOKRiBpwtmU6h+W6IzAR9TqQvBjKjzr34LCFBK?=
 =?us-ascii?Q?Fa84+dM9e33i+vQlB0jlBmpU/fH4CHo3QgK1W8qf128xXR+x0hwgqNPX/AiV?=
 =?us-ascii?Q?Bc++fEeEGhftlq1X2PxcWGRtN8OttmGxKmuZF++7lAAr7NEQHhdkIkVi4+4T?=
 =?us-ascii?Q?B5I1171o0J9dLUx1AOOSGBw6NS1RcAn4cgJDTfi3LxF+RkO45FFRNRMFyQYM?=
 =?us-ascii?Q?/NUaba9XycJy8RdRGScQBUDHLHj5Dn4GC6BKiW9N9/advAGUvnBbOvOo7g22?=
 =?us-ascii?Q?ASLXJ0c6sIQ63j3qY8weASVxwvWEbG00Q0zV8l2WtRIUMk/YgAIaAmpIRscA?=
 =?us-ascii?Q?b8NvVjO+ITk1cXrAh3h2M62BnSNlo6oIQwHWcozSRq2Qozj8Ah9RiaEgMh5N?=
 =?us-ascii?Q?P/YyopB7/UD32M/nioa9Om7LC8x5dFV5pYMFSy3joKA6NOQbMCHP0q1Usz1H?=
 =?us-ascii?Q?dAlHa1tyq0YokSNXmuDadFy9hGk34/JKo6PZIp6KSOxc+3dtWpKIBvAhxXS+?=
 =?us-ascii?Q?yRG9BSkXqyATw09GypXSM9/k4/pXGSMnUDx8JESp05M1hdmxxNxXZ3+qVjSf?=
 =?us-ascii?Q?ryKM7QywLXjBaxiec28ltoqiPHmCq/Kt4Au2GwbS84Ox3cUUkTbPaI/Y+ZSu?=
 =?us-ascii?Q?iv/PK0suaftUjaJPSsJ16q+NPRGDI7Xd2/se0C0sOAv1GDq1zSX6BPDDOst5?=
 =?us-ascii?Q?sOupHHtwdu4KNUGye81KXKqScoE/yCAqk4P9Z1TVntZ1d8PTSTXLTomAOKSr?=
 =?us-ascii?Q?94KN9o6+6DnmHi0by10KSGd2f+AffsbG0/CqL/+P0FN3UJwGIXoL1fbOnlSb?=
 =?us-ascii?Q?xwUt029olDHb1zZc75/nzoNwGUgognqqDuUDR4yWY5LmdnQCV4J8BEqMfbVG?=
 =?us-ascii?Q?D6dhlWB23adt1dshbIMXDb8oYe5mXs61Wsdk8Wv/n4QKA3a9lMqOr5PIKGvh?=
 =?us-ascii?Q?hGLfoXiKDl8LAsODEFXk0xa21jkhcpLsSs7uB2cF9sWDMMFNVF5W/OTidazT?=
 =?us-ascii?Q?hxFkHdY5Faec4M7H9RUp2Kp/Q/9VIzCLSGyJeB1TrZn2n15czDuDMICJGF52?=
 =?us-ascii?Q?fQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IeGxQ7unTsQaBhx2Pe7HM7lAXVSkE9yGOldAZx6taiWIWKpL8vzKdiG5FcblV9XVxc5DMzu6NuEwOnIZJinDziSXTydDa1PM5CcfhYq2KT91+ZIyaXDxiJXxEyb6HuL6YUnBWo49i1aFCMaOh4CHSEr8Uc3HKimPtza3lcYjdhslZ8cbkv8MalbWiJqKD1z3ZIH2dXlav/9Q/M/paP+/Buoyky9TwOBj6G0qGhKsOm2mKyzjDtjPERYKk4V32cHqge3vqWOYf6lggV5Ty8s/tq3Ye5MaTQJbWLrORn7xGuY/wei2+cIWqbZ7509szUdUvokHzSuvpTZXfBqj1e2NALijlGAG2e2cCJu2uR25gHU9CFQ9uigsYSldeI6vKPNHYT80l7ARwwQJuFAN6BgwxzeXusiXAMGcp8Q5eQ5GXJWdjBv7zXSMoplcjNuUVMYFu8MJnRsuRHuE/fLkUnIAqv0t4OyoMfC++PNSBiZrCeUttDEAEl/GvtMflEmKVUqoXDb67/qTiUgWNgNHORI1Zff8ItGfPep+Zm01n/VYFfqk77oWF8niawOrkOPQLdbssGrUJiOkQSigAnAIYzsosy/kzjay5iFQnptC1bujfvM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c07592-808c-4618-5b24-08ddebc8cbaf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 15:36:20.0297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6DQGH2d+SEKaKYcPpATsKACcZtT77+ZFtDbf/p2I3UCw6Z5+zkvunYL2YQPe3U/8P+quuhnZfDQpVoqLmFQdkzP8FTgt9bxMsLEABkn+iOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4325
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040153
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MiBTYWx0ZWRfXyZSuegAM0Yp/
 mIlSX1I7NBOlIzbYj3CX7sRv3XBOd+IzGHkL0UB33HxEUbt7TlLUmYQ7iZiaglZYiAVB22PnD+j
 R4cSjUTUVH9ujgY+wnoc/C+KR+0+duIKzHZji0d2JzRXqnr/AkZURqeyD3ZT4FdPUnO1kJYHQOz
 lgniomUSThlbyDL5qDyBrDTmD3hsqzUrihGykRfSAbyLahml63BniZzmoDIFvo12NylVxmO/7Yx
 0av3OLjtu9Af2sTCi8/MbPNRx9sNN8spsu/cJRqaDQu5yrwQIZsMRW89KPRbpg95Uad3Qnaw7y/
 jJbRK3J+5hQD4urbwYnNVwAly3n3kDsRECTbVey3iDjuS8Qws6sjwLDDjNT5Xh04rh7EZUKw1y2
 4vfwsyV2rdQIrW/t5ZGamSCTXCew7Q==
X-Authority-Analysis: v=2.4 cv=YLOfyQGx c=1 sm=1 tr=0 ts=68b9b1f7 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=l3ebZHTYr9fINLM-a3wA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: 6i2c077E5x0l6_QDp-PGUtbsTxafCTNb
X-Proofpoint-GUID: 6i2c077E5x0l6_QDp-PGUtbsTxafCTNb
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B4B3240012
X-Stat-Signature: 4rfcw37yunfosn6u9tqhnycm7ecmmtgf
X-HE-Tag: 1757000498-847994
X-HE-Meta: U2FsdGVkX1+43yiwL8HNvK6pAjLhQX5I1PM0WoNsLVXE7g6LDN4afg9SrEpO8WIFBNErT0WqO4ZLDs4Xmy89WprdAnfCoIdzn88Z6I1/04X9N9KWDaV/87yVwTsnOccsqioVTNmldNluZkaC+daG3ZDzmJAXCXZedZTmSK+RA4Z64KHt/RsjLVfe+BpYVDuQ/TbyxGgFF5mgN67NQokTNj71vLS+cbQBye+XOl1FI3c6IwgxT+YAjSyVLoyco9QCHiTLdVJSUmwrcS7Z7xGLjNamakZQAmAZ+6K8TLtabpO04kD7ceQoIuDtYeuw1zhvzeWmGwlXqr381pLaE0jFdAhdpWfmbA/bUFjrscn74GO/bTLjCSUSm9WWpdsti0OUqq3Yf+thol1DO37+dOHRCWh+CXeCqhxx0rh0U0OC9qNgvCE+lt3DRXV83RXYGwWkRygRFtDPqrh0lPnkieOrUtOUa1C4RaNABAR14Cv/WB+54aNDDElf9sr3T8AhlnQj7x0eJ92VSDQeCxl6Bj40OUc0gHilndeeSu5KPoE1v6nfMHyUrZQp0x1upORr7cx3JgH9KfBRh/vJQj8+tSQyKrmPJrswkNOfIEZA/bUU3QajeRtz0XowR5LqlrLJSM4qRi6rTVtUCSzyOIIer40GR3hlfPA1+bWIF3zD09UvVle+5Q/ijm/E7a/cP8APMWv7xFjEf7g5wSTFbJPwncqr6Q1WBwI+5o52l+Z1KFYMHQ+3Xe2p5chLxlcHx6IiOBVJHdy8sgRri7QGJnIixTesKj3XQfIMgdPW83Z7CIAtU06eZptERlY6IxN/5g9Y/JypwUY2GoZygstfUfbhDm2qFgAz7b2sw/3r62h0bZwtFLLPavlz75VkGKS8mvOKK1ntsoqPK0tquHq/Qmr2D0N0CRdNrsUP7UZR+iBHZes0/JU/yrWxEgM+L57mDK9lr+CCdwUROyEHKvYEwYzmhTr
 OB2uOyvR
 Y5LGYhYs8JFb38msVoNqsAvoKcHjjhhFCOPryD3WeA6Z8xmDmAVNFaEa6llA88SH9OtClJzHF4xyl6WuE3hSZVLLApl1T2BjedCZ+YLjVHI+dMczd09svvSso4Of3DKSoJ9B3ds7K5X1PROX+SshRhfxcS0yyMRjZaiLX3gOsNtV96BV7f01AJ/GcvqN9HZLyw5qVo+U4J95UitQKmthwyLvZO8L8ytYu9vEeiUkPKDJaoA5UUegzirVDbvpeEE/FY17alehJk6cEtV4cuRfYoVfHQQR5PHKxqaIycGQZBNYPdRphBmyVrM9oFjIOi9R9N0NIYnznxUYoAKAN99m0sCKMb9UkpdQnaAoDON2QNgDEekud0k+7ptwwlMOkCbVmBfK4K4hxF18wioTrSLVuJbIGLa0cJKalRWXXznDk681Ns/01Kbv/DpheK//nYkzXa1HHeYMgFJL9/2LuO1BISzvBgDdROuw38AvDIRSA+uJB9gvHp9wejyd+Zl8URxUsw3K19ZCLy38++I3J2peZ0Y9HvHw4WxGz3zK1KMvoZfIsHOCRmktntSj8Cc+P/amcKPHVf0ctblrqUbMWy+Ask3Ffsbfc5ZWwxMN5U6CdVfu/OTbNhdpYAXCODvJ3knZxC6OD1D2sqUcABP/Kgbj3KRYud8rspJlGG4tK2iGDsaO6W8Koc3LDz15Gfs0MHjJF7uGB7I0RxptslnRgJPUnAo+1DpR8MLPXlPhdfQGi5nFXgbXG+1MoqjvJPdcaI1np0zAdhn+hhEj0ApdlY22zkBj8U57MlqwZb6ds
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 12:20:55PM +0200, David Hildenbrand wrote:
> On 03.09.25 22:19, Liam R. Howlett wrote:
> > * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250819 15:14]:
> > > On Fri, Aug 15, 2025 at 03:10:29PM -0400, Liam R. Howlett wrote:
> > > > The ceiling and tree search limit need to be different arguments for the
> > > > future change in the failed fork attempt.
> > > >
> > > > No functional changes intended.
> > > >
> > > > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > >
> > > (Obv. in addition to comment about broken VMA tests :P)
> > >
> > > I guess intent is that if we discover any page tables beyond tree_max then
> > > we ought to just wipe them all out so, in effect, we don't consider
> > > mappings at or past tree_max to be valid?
> >
> > Actually... there are some archs that map outside the vma and they are
> > valid.. I think mips? and I think lower, but yeah.. it's needed.  This
> > is why prev->vm_end and next->vm_start are used as page table limits,
> > afaik.  This is a serious annoyance because it frequently adds walks
> > that are infrequently necessary to the vma tree.
>
> Hm, does that still exist?
>
> I recall something odd ... was it that gate area thingy (in_gate_area) we
> also have to handle in GUP code? The is x86/arm though, not mips.

Isn't gate area the VSYSCALL area so that's basically a kernel mapping address
that we allow userland to access?

>
> --
> Cheers
>
> David / dhildenb
>

