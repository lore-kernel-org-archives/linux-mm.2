Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20149E66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 18:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88EBF6B0088; Fri, 19 Dec 2025 13:28:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845476B0089; Fri, 19 Dec 2025 13:28:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3496B008A; Fri, 19 Dec 2025 13:28:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A71B6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:28:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F0076139E60
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:28:35 +0000 (UTC)
X-FDA: 84237056190.23.5DBF2B3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 837F720010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:28:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N3Aa4R47;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Y4comYmF;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766168912; a=rsa-sha256;
	cv=pass;
	b=PUoSwkYKU3svxNeEM+qEz8IXHrmmbnG/NK2LddGkrXvfkiV18O+uF391xCzlMGpVx71W4j
	y3rLX0hrfAlo6O8ejlSZbHZGfn/Tluea68OXPH61rWKHlu5UmhD8dMsGSgEOanM4HmAB3N
	uQJnPKEn+PVJqUCd5wcjvZAr1BjvTCI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N3Aa4R47;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Y4comYmF;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766168912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLx/T2+cby5fBv6vBOjfn1ynuFy17tkaBwajnoK9Jvc=;
	b=U0c3qpEQB0bK6elun2rNIh+JlA2mSrFNmgpeFzZ0EWgJVUVLmG328cLKsFJoMfVrUt3DLD
	/TvLWsSVpQbAA4OTeOa4izfEY6JLNbf4FMaoG51V8rcovVafE0nxN7ReQtG53DiG7Q5ysm
	olgPAQihyNGgxuWGq8YsJuYcEOX313c=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJIRM2s216530;
	Fri, 19 Dec 2025 18:28:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gLx/T2+cby5fBv6vBO
	jfn1ynuFy17tkaBwajnoK9Jvc=; b=N3Aa4R47Teiz7UG+vgbfrstyW2xIZA3ayK
	vzSmyal7jV7ws2ey9N/KZNdLB8Z7v8Y8nMQaYhp+oA5JipIIjf2mEWAjBtBswAHu
	+Zu0XsH4UI/8DzKrVHfRZQzUoYD2du9hT6PjI2sqtVgPY+nP6IDJlwsduGlWQC+f
	rC2ZebIzGKmX6AfJ7mE6PDDrM58UFv79oceGmm5yszAdazgdsXMvM/VI1iYMBrhH
	H/kOOimSKSzbz76/JQLVroblcjRBiE/qV+SrC3oSwaT3TuhgFrPDmOHspbUBkNdX
	thGihPQJyuufUTWhHgvGqJK2t5NZdHhoGeyGHNFu6PbmmZd+3aIA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r2f1hwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 18:28:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BJGWMV9036875;
	Fri, 19 Dec 2025 18:28:27 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010028.outbound.protection.outlook.com [52.101.85.28])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtmtp3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 18:28:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T4Ajcy/fNR0u+qMGLgquVsZ5t0GYV6te5jULPl+KNYzppRAIf92hvE9EsCaF21HVEqUEUlEovFnxIzwcRZEUHQKn1EwI6eBIrFW+uujIQZ3XYVaa+/2GzXNINWUICHcuMrGgR+rvoix/iiQqJ6k0simeTa/p1sFMYjCjJ5KDPIOnJ/DlLbk4TagTSZcozag0VvI/x82lLSHZvC8GaACmmQnmISG1wEZkY/E+eVBGtpcC888XUtRTMl++ItZD3Uda3QwQRupjHVocx1N6D7j8Cg8tKDYOngC4k8LsudquUK8VOrVtgbKLF6iWAqigKv65kqSfFIMiM5Fm0/id57FnEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLx/T2+cby5fBv6vBOjfn1ynuFy17tkaBwajnoK9Jvc=;
 b=gL1r/6DmgcwjhZjEGqNh5/ZaHA0UzZwTqFEM9Z/zqXx98zMVu82FPjAFln3nan9Zjy8gysHg05gg2z5Jd0tyaH6dPEXbruaGltaIGYFCa+QhLDCyG0RFC4IdOnm8mjO5Dqki/jP28ZqErSpG49OfXVRJna8iIep6DpI8+8Kp4U2DOWhAJ8DdTkoXRqtOWmjnwRkajd0GEBMRa3NUVsUWTeZNImUazbxSN2MJC+A48tAEVfM8u41hFUSLZuokmUVjJ/9HnKD+isSUMfYEmvv/XpXitG7UqjLPvK17Ub9maDL4XfsXXvT/X6rv89N4QW7tVCaHFmabaKAhf4uyIgd85g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLx/T2+cby5fBv6vBOjfn1ynuFy17tkaBwajnoK9Jvc=;
 b=Y4comYmF9qlQd+hQQaMgd7fsJpiHL2U4phC/QF5QmUN6Uzxhi7TuIh7Ss9dZt81hPksqctLsWZWrCu/jWu1jBIziEj7ebIV6hOM6OznGOr+nKwdGF+frkde0qZW6lW+aUXvIEBIweVQ+7B0C2lBK2Xsc/SeOhMJZAcbcy3bfWqw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA1PR10MB7540.namprd10.prod.outlook.com (2603:10b6:208:445::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 18:28:07 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 18:28:07 +0000
Date: Fri, 19 Dec 2025 13:28:03 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] mm/rmap: skip unfaulted VMAs on anon_vma clone,
 unlink
Message-ID: <nmflwd25h3zz3vrdpfgaztko2dcascl3bbfyk6slml7n472kms@ysxtp4xlxf6r>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>, 
	Chris Li <chriscli@google.com>, Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <b2b22973f761a97751487144f7726bb0cf868305.1765970117.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2b22973f761a97751487144f7726bb0cf868305.1765970117.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0279.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::17) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA1PR10MB7540:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f432199-ce0e-4bec-9782-08de3f2c5af1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+UxuN7dzoIueawYIy+DWv5aGLMK4n0BbFUf7Q2D+0i/Qbhd8qsXW1+0Xs6mL?=
 =?us-ascii?Q?GUQvYSE6zytGEVTrgGFsPc0+dKv2lNttrH4bpxi/vvMBFcdIS5pplu3XMV2/?=
 =?us-ascii?Q?LJxkv5awwg9HSWpyHZeRTcKmAnpQgXmdSsxTSJC7+0C7YEuAK/FygrVOPy0b?=
 =?us-ascii?Q?nufP05mlIWjfLLiR2dCvoVPK/9Z9mdcFxTqE60AplA38mZk5KNh1x4UUmv/k?=
 =?us-ascii?Q?aNfYtkFvdbIjtcAyK3I89gplh7Iwg/2jvUPy51eK8bq6eDhYdT6iLrmTpxZo?=
 =?us-ascii?Q?KZRuFWzVTrQXZmMVYey6sm3I6B0aGafi27IXggZf/cxmgGngRndt4/x55VrU?=
 =?us-ascii?Q?7vr8KhNh/3QCizJlv4YdrODETlBmd9y7EIdnPqg9hcT1BYGE5JILikUsWpgR?=
 =?us-ascii?Q?H94dkpWBvxcH2sfRXa6fvA/mhTuJHCTzfp2Z8nOB8WbwDd73J9EZSh3NBjtS?=
 =?us-ascii?Q?6LALyaSsQzVKFW/c3bfpA7HglUA8Z1t0IkAq35oCP/o7BPmGZJTC9tNbdzKX?=
 =?us-ascii?Q?m6l74NpnPsDIoJu6n7qJaLY6uQVrhdfyr45vDbMBKENH9pva2rR8zcV8FZQr?=
 =?us-ascii?Q?BAoebqO00X+Sawg1HnHBBr+Mj6KzpWimvGqzODaJonaIPtNG6yQIEJJKeXJj?=
 =?us-ascii?Q?E3ngWSJ6GupA1Y0ypRE/eMZKGjHo0Xrxz9/79fDyUp+ZaUa8Vhr5EMTQ7G51?=
 =?us-ascii?Q?MljGEfRIvo7a0irvpboTW/kqr8jpRIX2nHS5XOJ9frM9IEvmT3NUzgS7ly6k?=
 =?us-ascii?Q?wR3SugtDZwSNR04nHVv1qIFk4qwUeOL1gbse0erWbuyp10E++aJjfysBI+Aj?=
 =?us-ascii?Q?NGR26hJu1noouKYwRoSfAkrpq01EDMp67313djTe95/4LxSTqPC9WobmkqT1?=
 =?us-ascii?Q?tPg8A9kUwfNIw/930QjyT9LVvKppGqYSg4tm2NLQxcXP5KFFtzfaeAl6zqzF?=
 =?us-ascii?Q?gORseJvE1h+JEckVwIXEq2qjdxcf0fiZ2rdvTboIf/jLxHxWkO0l2YguvcpH?=
 =?us-ascii?Q?eo2l4bXI5/Rp5od8j8DN66lQDhRoxx+c6/snSxGWymsJhzHOfL1ckEFNdZVf?=
 =?us-ascii?Q?N2M77g6AfeNaiaiiWTfk0r8aS+vahopJhrcAFnV+rnF99CkceGoGwrchRAOs?=
 =?us-ascii?Q?xQFbrdqWU/uaRXCNVxXwHukycE2u/6RfFRqpZ/h8fbjI/XZ24OYHGa08l34D?=
 =?us-ascii?Q?OLfyR5+Lh3zFzct/ryOCAqzmj9RPcKn1neupbHa7Y7R4t5IIHv6osg/b/MHP?=
 =?us-ascii?Q?lyHeA6Son2vaYjyWLkUslxX2RRfV1m6Gx9F5CMNM+yAev6u6Ecf7kXAc0X/v?=
 =?us-ascii?Q?N27PpGhCK94nD4rPDlOp2edZpU2N9Wn+V99JjwK7/Np6RyR8nbpaHLeeu5c7?=
 =?us-ascii?Q?CcezMLbMq3PlF/jSYHWQ28GlrfiNuZbDns8Er7OIVQW8lJH4TEmNUi7VQUVs?=
 =?us-ascii?Q?iD0H+YzDjcSXsgmbmx1q/Db1Aimp2f59?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bGy2KA/MpbsW8td6qbg6StqUsmGyyKISXJHYSEhjMRHKfvzsdjouVUJHCWeL?=
 =?us-ascii?Q?A+xT0EP8a9aq63opgqUSrvXk9vs7d/VU+3dTShPsrqx9WScDWkwbiRSwZPdX?=
 =?us-ascii?Q?SYW5KNEdRwYrvtgDSFFiEZULhXdQJIu8RQFRfM+/Wyx+/+v6blLOxt3sHJ5f?=
 =?us-ascii?Q?J0QYlmqnarcu7R7XrxAAqm0cd9cGRzoEurF/jgzit8mxlRfdX13z8OjGNZZ2?=
 =?us-ascii?Q?3Y7mDzJ4JQQfpjmhUD00qb10JHbMOxZ4yp+dntpBYDFeSElWEO+3KcJrgcUX?=
 =?us-ascii?Q?78nLvXs0bp1dBuEkVGlsZKpIi5Rx5z5VkTSDziawt5SRU3sZtHDgbiJoXNtX?=
 =?us-ascii?Q?7L9fMNySpCDMQ82sQoUsK+5DKZ0/Ssv5vpLrQIXGTh+yPX3mv4DJ7Nb6mqum?=
 =?us-ascii?Q?c92wbvnNF01VXqwewA2Bp5Erxx8I8Qxi7SAbEUYcfeMJly8xSp1zEjf0gaRq?=
 =?us-ascii?Q?2vbQmqhvR/VGw9kBU6bcms3zn0U8tVhx8Pv8cAdr130f73rPeaTmpGMUKYBB?=
 =?us-ascii?Q?nlL2OKtNhRnj1eZm6RY4wQlSD+ocARbsMh6YS0YmtHqhj/SVH3jSDN5NduBw?=
 =?us-ascii?Q?8FTULvvfUqsErsmBZMwaG5BSkpb0XDcAzI3d/hJEVVd12L3VulyQ8gUZdc5D?=
 =?us-ascii?Q?l3MyZhIDKO1cAxWITuyLzJb47gX9dam4ny9zb+cnHi4x/xOvXySimaybKUhp?=
 =?us-ascii?Q?zHNCYLkas3GTOPNjJyuXtV6HVP2MWpJGdsw7hYvi/OeI5Buw9oaXx81bNF7A?=
 =?us-ascii?Q?q43UwATTsNxWFyVMW0yoo+xFv5IiSdhCAs7nHT4M9RgSTrKcLh4fYcPVYSqP?=
 =?us-ascii?Q?LzXi4w3O116q2uq/LzoTkgEBXrjvi4QxxF8cakyNWVEiC7kaysIQdjaGRI9r?=
 =?us-ascii?Q?v0pzSyzcnTxCm0jBA2nRTJ7tUO7XZshpTL5lIsKy7A5et0E0zXg0IzugRYqk?=
 =?us-ascii?Q?JyJk5jfqPx7SS/sjjbg4yVjhlbgdeToHpQMvDvh+JYoXrWugfFeRKyi2H/e7?=
 =?us-ascii?Q?42fLGrk0FXPAOIiYUhldpT6+rr5KCTL4vkXXpyEktbL7lrBqwrB3MXr1C57U?=
 =?us-ascii?Q?alGfzmleGfUC43wDXRmlp0r+MIGOZY4cj16Jg3udx/oVXVr9UGn1+mMY4f1X?=
 =?us-ascii?Q?IEugxz1rFXF3Q7fnVNALz/A5WvNGShMzyfQCSDuGFfXEFjpJVBQgIq8J6EzM?=
 =?us-ascii?Q?ocsxQlQb2LdX9kkZfj3smbToTfY2sCuQeD2KGttnrkOdsbcckBqVvCngGM0s?=
 =?us-ascii?Q?bDYCtg+JwUBstIqFEx/dq7U2FIluymfzmILC4nqxWx7BDyP4TNbS9LdpsmNU?=
 =?us-ascii?Q?PEKqzn/ICiU9ORzeb9c/RqVrOYJbZsy53ZC+bcubI+XzUB3N+lAK2Kn5Gy+N?=
 =?us-ascii?Q?p5dSDECY+P9O10KL8j/cXt1aVL4WKnhoTItx8SVWv6TuCLkbpim0TrFLrZSQ?=
 =?us-ascii?Q?y2bqtJOMQsvg25aUX9Om+WPF0S/hSe0xV4ivI+Aa2nOcSneUmmnhYZuGgG4R?=
 =?us-ascii?Q?UUS5i7KFM+JLgm4ao6ELKBoshc3hePsbwOEvsbZ1GTyV+IfDv5QFexf1ccg5?=
 =?us-ascii?Q?VAlLJcVDcY9Hm5ouCaflIQiJZnubxxbfnWyDs59SFm8zFQslRLxRr5dRboG4?=
 =?us-ascii?Q?Nt3scB287yIK4J4gUJrbkoPXpxATc8ZnPwHAq8lSh/zZVeqpTfly5lRdsGV1?=
 =?us-ascii?Q?t+yk9ZRfaLEg9Knrc2NBSKBrkLCWOjYBJUgZPDdCl3KupuKpjWYPkvNgNm3R?=
 =?us-ascii?Q?QHKgvlUlDw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I8arlSoikbpjL/Fxxfj+WlFDp2DUmJGjnVahRhWSjnMB6Ja1A6lJMEvYu9GVtffncIvv5lXogcyeQ1sXTob4DLwOGD3hwUtFrBgKVX7GDqFw6QGMjshucrxJC4JkeSNd537+XPpkASYjkvbwwZgaU6fM352L5ZYQdbHZoZWzOPIf7Ng45z1PMPBOBoPbm2mL/SgT0w9lltoE+4xHpsEj5mGXJE4TfB7S5oK0Yr0CaS0sV8qFrHAd7tneP9GQOj66dAIWLV0qHbGRenc0DxDxNXL0PMNxjNxbxrcxr4Jyu8nmnThfTHg/qwPVQHVEQnU0TqHZ/Ejr6qO7HwKRclx60/S8/FcKF/gWycr0FIRcUrNykmu9ytZdKUSAKrJ/aZDWcHNGKnEv15OR8MScS+56IYV3COewIlW9bwl5kXH4XjjWdiTxV+Bp/lvan85QC6BMcifdpGBKaSkOfeeaRkj2Zx6yIJbcHT71v22ICcIXoWxqdSa9MU0K4m9VncP9UXrotLUz0Osaq7gdrsnVMYNFd/pRH9iwplt8QSvawJ0f9TE3BADUA9N8sRLeZdXrlcEfbLGARoyntm4lQPMUd5PkpremYRXYRCjJeVCjGIPw0jA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f432199-ce0e-4bec-9782-08de3f2c5af1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 18:28:07.1505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fXTBF/lvIh8jn4s1JnRnaIrWQyHnKecLb0wYV9ekoF+IbPtgj86sck4c8CJeK2yytfSs1SBYQf502ZUqGnxxqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7540
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_06,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=848 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512190155
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDE1NCBTYWx0ZWRfX1/xsg76k/uUI
 OXVW+7o1JfszzgnjhqQoz+IexWSHNx5w8+XfCuwdeVCzJ8v+1o7pcZXlmnDcVWwv1fe+AxaIWpW
 luE92vMpFAbRWcjL8NLKCkDzeCHkVR/Rr4kXQ7UBiA8BUZiUF/DxwhkqVFMIygzcTHqLjuToEMf
 +5p6fYqioL6Flttt/N8y6MBn/sS1U4Q3ql65BAYzahei3glPB+AwgNgEQTNx54IOREfYHER/dIX
 +F0JEFTg5mVOCFepQ/jEmufE0J0o7FgHmKhSEN5D0sqlq/RWHmbbgkEKDrLAT8/7aj2nvF33F2D
 lO5fr1N/V0FxYi2S2M+fZGr1YgqvPzrZs0P99FX/LG6m07zYiMa+2CdMfhTbfxWQLg+qh8mj2oE
 EL/op+q9qcxQl31o1eybW4pAIIInLfrpDXgEb3Xxh67W1aRAzxDi8Ah1AV2ZjgTTNTDUBFzkXXr
 MVVwIlv4I5gfOFQZt5RMpZFskaGJL7Q8X69m0pxs=
X-Proofpoint-ORIG-GUID: Kyrh1OtZp7CBN9Of8GHMzOOpxNNVwoat
X-Proofpoint-GUID: Kyrh1OtZp7CBN9Of8GHMzOOpxNNVwoat
X-Authority-Analysis: v=2.4 cv=OZGVzxTY c=1 sm=1 tr=0 ts=6945994c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=JPZ_gNkGtFpGg14reR0A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13654
X-Rspamd-Queue-Id: 837F720010
X-Rspamd-Server: rspam03
X-Stat-Signature: qceggocgne9yoou47gt8mewcdhr5rdrd
X-Rspam-User: 
X-HE-Tag: 1766168912-306898
X-HE-Meta: U2FsdGVkX18/mm+Aatw6SJZUW8kGiFz4M1380JtWuAfuToZomZbwDk2Sun1ODAqDGDmnqf4/8ZABkQDO4uUNQxKiVNZFPbEnTo7+wt2765UNBFoCf70X2g6Y8IXbPFysVwv8hHlOX6izpvj1t0lWFdIoTTYyeBxBlnomCbOKLfEFI3ZviVyVDAMGSZ9dpDSFSqtk7tTMHFtnqDX2/3MYTULSmuWORpdBYtHYShTiVNBhXddQIKzYLJBgei4ufZUOh/CQp41GxrmwKpSkK0ASr0Ci/mE2H2Hf//09xic1shRfBuJy46SrcVOn+v8U9yUw3hiJzbkATvmZ8L4zTRRJma/Kh/xC5D35cI8IX9j1pgjpuz8OMxw9Do3sRx48xrwAMu75oX1f4ZYowegHHHwhifWkrQnEtOlKyku+SSio2a7QOPkRtmSCWts8KqHrfllhTMKTt9kyhb224Au9eThkuyxBlRAtuhqmkmtHTE1nd+XR3BlHFPjownTwavS34kLgvJoddBDo8RtvNHk7+EQceO0Ai5BWwER7sXRU5st6TDwzj8ROq463DmCY0OSBqHO64t8D9hDGRDoMqLpnnTlUw4xoAlv3gcJerxYad4CCyldqFZmARUjkHc914FSSyI81oOCxLAUEWk8133Un1EhhRtoQ3qaFiK9OmimAaDeZH4DZk+YqFjIkU9qbL518dSmmx0UXX+wOCZQgXrH34wlKUCAGl8bU/LdRUIHtGT8XC09EmDDNF4NYszRPrZAyI001QsMPZ2IB6mb9BPoyoOspNf0zap89gVBg4Vfq2omcGfApDdKMJarR2xdQzAgLhAwo7aD4ZdO10mnGZ+F1pIuToVcki603w9kh44y8ved+3IZbZzA72+f6yvvgm9T+Im/x2eBK+p4lRonn+LHW/xTsuZj5sms28X/3fC5RXc6Fy1/TNRU9fh6LIDV86sPQxu8KtdF39ZDKrFBmu/hdG3U
 34r81zdu
 wM0cgx6sO70mgd0ruRJNm6n6EF/S8Vg8TK72Dh8bI23iRMbRRlmcZCubtDckwIoaALpAE9xP53s8jcFW7O7DEjZslxSNa5EBuzzYDdDw1Pv/k7JsUaDJH2rPA9PuWWEFKKapRlhcitmq2+u/B3PUsAjJnWkCpuVT+4JucDFAs6vANhNgBZ+jRCebv4OW5HeNPDWxR8OlOPyjomB9buzMZJy2B7/R8a0riM2DjvOlsD2/pjbl9ESb9Z4BGyugNseYxbnNbHcQ7oR+T566kuw5vuFUOQ0Kj0PfEzl+kzaPgDp43iKT7KerYO35l4Nvf9ub5Xs7j6OTDGpgl/G1JWnMMxoWnw/wOXxS7AYUvWoMQhzS7ZZLFiVQkmCe8SkJvqdfrBLAUZD4vERjpjdYyjgzhkdRjkZgXBeK9ML8geu0IVIRk59KhmVDUQ0bCRTvwoXfAu8tpCK0sib0eG7PuKYyvzWv/XaAa5AsAhTajBGLp84sXOs5tFjy9rYmFpveW37l/ZTvcOkOeGjvaGyNFEioUu+L3CCqgLL8Pv3+15ldO2/4KPyKEDzP68JpgsW+GLb2kaRpOMgCccWaBGiJ4vmMsyg8Ai/eZEXtLAoff6iciFy6hULBuG37aUHPUu+LUHchmZisjbPKgOpgcPdeJmgdb56FVmPYlj2MF54t1XS/lyctXspYiwWUCETcMi09pdm9wLWwS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251217 07:27]:
> For both anon_vma_clone() and unlink_anon_vmas(), if the source VMA or the
> VMA to be linked are unfaulted (e.g. !vma->anon_vma), then the functions do
> nothing. Simply exit early in these cases.
> 
> In the unlink_anon_vmas() case we can also remove a conditional that checks
> whether vma->anon_vma is set.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  mm/rmap.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 0e34c0a69fbc..9332d1cbc643 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -309,6 +309,9 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
>  	struct anon_vma_chain *avc, *pavc;
>  	struct anon_vma *root = NULL;
>  
> +	if (!src->anon_vma)
> +		return 0;
> +
>  	check_anon_vma_clone(dst, src);
>  
>  	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
> @@ -441,7 +444,8 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>  	mmap_assert_locked(vma->vm_mm);
>  
>  	/* Unfaulted is a no-op. */
> -	VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
> +	if (!vma->anon_vma)
> +		return;

I guess it doesn't matter because you just added the !list_empty()
check, but did you mean to drop that part?

>  
>  	/*
>  	 * Unlink each anon_vma chained to the VMA.  This list is ordered
> @@ -465,15 +469,13 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>  		list_del(&avc->same_vma);
>  		anon_vma_chain_free(avc);
>  	}
> -	if (vma->anon_vma) {
> -		vma->anon_vma->num_active_vmas--;
>  
> -		/*
> -		 * vma would still be needed after unlink, and anon_vma will be prepared
> -		 * when handle fault.
> -		 */
> -		vma->anon_vma = NULL;
> -	}
> +	vma->anon_vma->num_active_vmas--;
> +	/*
> +	 * vma would still be needed after unlink, and anon_vma will be prepared
> +	 * when handle fault.
> +	 */
> +	vma->anon_vma = NULL;
>  	unlock_anon_vma_root(root);
>  
>  	/*
> -- 
> 2.52.0
> 

