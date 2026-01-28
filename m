Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A2B7D25B44
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123886B0088; Wed, 28 Jan 2026 06:32:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1136B0089; Wed, 28 Jan 2026 06:32:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA05C6B008A; Wed, 28 Jan 2026 06:32:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4A686B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:32:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FD7013B0DF
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:32:08 +0000 (UTC)
X-FDA: 84381158736.08.3C14EDB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id AB3D2180006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:32:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="hx/qFj02";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jBD3E3SG;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769599924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bBzBEwC6K01ZHY7TvNKjNVoO0kU/Vynb8/6AA3fdCA=;
	b=adwcXBm+8qeJun0Zc4fW+j0E4CQjH2k0OjQbG9yL4MC1gS9eE49J64Pxo3uSD+X08SHYh/
	TQ0q5q9goVVoxZlMKrVrsjcxdRPlkXzJNn31rcGf6EylUvTrFso7y7Z3rABlCd0IWnBpFY
	T806TKQLnJ1FWVFI0Bxdf+lfTvu+Coc=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="hx/qFj02";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jBD3E3SG;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769599924; a=rsa-sha256;
	cv=pass;
	b=Bzm7sOAzfHkiyyry0Mahvtt8a54UFiMQS7w1l+lY0OuIAcTQPpaoEbN0gCVmHdDe599ZKb
	Oyo9+EnOYJ3tP1UnZa9kYWF0NbQXQAIFiqYbfhF5cx4tcVbQu+CTgHIUepAkd4vR2Z/7xv
	HJ+R2/E+EbtKbayzaDWi4PB7iZzeXsw=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60S4DOWT2162471;
	Wed, 28 Jan 2026 11:31:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/bBzBEwC6K01ZHY7Tv
	NKjNVoO0kU/Vynb8/6AA3fdCA=; b=hx/qFj02F03oZFY45i+/6155bt3KcbikdJ
	joU6OBKa4Y7Fg58l7Ue3QWeOPDz03eoli6P18FjuJtvP+iY36gmM9YsJkvzU6N0J
	29HZYsOe5S+RTFZU47N/C150m6yDTT84wm/lDTk4LAygVt2o4kic57wb8BX24dPF
	Uap1KaWN4W+JgKnbt45619OMEJTyeBTfOIBSPiL58TceO9SNa8K8DPjZRkNrJHt2
	UiGiGAsr/lqDqroezeoopy5gA/13R0tJVR2dhrmVpihIaOGL+z3Ng73XzYEeYHIY
	mOWtUu9CpUd74KLYTyhZPVb+ooyGPkWB7/Uo1Q4eTDlv8ujrRNpA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by2xqs88t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 11:31:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60S9O1Ys036089;
	Wed, 28 Jan 2026 11:31:47 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011033.outbound.protection.outlook.com [52.101.52.33])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhq2j96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 11:31:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jBcGhFlZpGTAtfpkBAbhRxsHoYxx76ZpvR9ZG+iFHGfxgsWSoScUqdA7HwpTR8jzERWMM2cqKd9pZIg1qsI2D0rZ4ieacU0l7WbHCJDr7jCynkTHtQUaO25YuOh903yyRSiP0cv6zhLw+3xcFAu1T6jUZpfqki79r/j8AzFTrWsXViLqhmFyAYyYMHk6MQ6ys+wzyjVfjl8VSu7DG4dp4gzVnzTCcIJQRGo9BRDoiIHONyamhmts/6NgKUT0ckvINqTkO+bJmXor5u5vOCU15T32YjOL5mGfeWHs0XXarlSk+RNEVvL9YvkdDLZliJ1qubKDqeF+ydO4gSEHj83hLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/bBzBEwC6K01ZHY7TvNKjNVoO0kU/Vynb8/6AA3fdCA=;
 b=uN3giaIGZFgdCiLa7pHEehU5Cw2c8Uf0ZSCZQGaI69YoDF2LeRnRvzLtyBpldGBV5y44U3XT9pGMOQnQmniOHsd5i4MJkn4hixCcFWHLMU16kPs9Ng5ni01Zd2VIcufFHXprmFa2+vo8I6QuUZ9h7oymIetl1krqdYybcqL1i3Gc6nyNS1ymdEUajetSa2CP8Is0HPvLcgIoxsyeRIZHLAN4cB3dFGtoox03C0MZgiOo9TxI2R54xKRkeDp+i58bQ5TK0aksY/Xb4MLiwN630D21sy1iVlJVDBNEOxNq6F8nu99jixFz5N5MhTQl1nCe6CL28jRsRR4xzbY+6gkrhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bBzBEwC6K01ZHY7TvNKjNVoO0kU/Vynb8/6AA3fdCA=;
 b=jBD3E3SGoztpGljaFsS4qbew2YHVuzcBznJSgyUhE7T4a88edZucfJVsxmB8VPyCmwVJfZ6X94TAl7o2DuDM15cHGDwbmthBsmJK7nNuH4FrvWf0CarrpJcfliDFhuZMff+eyffcy3nBYxOc7/qJTh47ZgC7oLlGVL48sgi9K84=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH0PR10MB5580.namprd10.prod.outlook.com (2603:10b6:510:ff::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 11:31:43 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Wed, 28 Jan 2026
 11:31:43 +0000
Date: Wed, 28 Jan 2026 11:31:41 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 04/10] mm/vma: add+use vma lockdep acquire/release
 defines
Message-ID: <e09d5642-a9c7-4b72-9646-ec994e57170d@lucifer.local>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <fdae72441949ecf3b4a0ed3510da803e881bb153.1769198904.git.lorenzo.stoakes@oracle.com>
 <20260128111832.X9oXdXn8@linutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128111832.X9oXdXn8@linutronix.de>
X-ClientProxiedBy: LO3P123CA0026.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::6) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH0PR10MB5580:EE_
X-MS-Office365-Filtering-Correlation-Id: 0beea812-8c54-4697-b2f3-08de5e60d012
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eas4FCSlPDVJ/mg7DLmSlgo1W3Qb4lNpz9EAcXDRSG+1CHTwLGpwGa34ztED?=
 =?us-ascii?Q?k82xDFEr6drDgaghqxf/OzFF90HOlkz1y7GFT256QnQYnrh7kgLYg70EJ2oH?=
 =?us-ascii?Q?cjy1PWwKPQr2h3xHGMKaSuRgkWmJn0/l3hKT//PZbJa43wx/SV4uniYLeuW6?=
 =?us-ascii?Q?VJrPUh+uw2KL4rx+n7SZcjkadl7TsEYhoOlDf++hsT64i8Q1GpBcDpgwCKj+?=
 =?us-ascii?Q?5d2Qrf7nOuVE7oHNTVk4y8jO0eN/EQPm4ASAKYzgX1JmPFLA2DZ9UuicnumN?=
 =?us-ascii?Q?aouyJWNUTgJNjB0O64vUGnUn/51ZU2MlOBvhiTz5gvcrOH6CKQHBLpsZZxT4?=
 =?us-ascii?Q?Lb+Ta9atyuDYGoiIV0ghhVz67WYVCa3niOfPkb/7yjnKCGg1uUNlX7TCtyCk?=
 =?us-ascii?Q?MHESlZQ+uQA8poWdkhUGfrpkveDKeqt33Yg7zTYsIyYOxwvU+EzNB5zpAVWU?=
 =?us-ascii?Q?msU4dXY2YZPEmIYogayi78HyUg3FPbazCNTvpmTgRnJWQgjYjf6gYtbhkfoF?=
 =?us-ascii?Q?ojmFtHdWfCna61vSHyIKmxNIlq7YKvHzr21W2X4zUe9MnjA3llXEE6z0kYw+?=
 =?us-ascii?Q?Q4GyseOe3wb6g8J+ZsKZyQgUmhfaKTEbxoV/iUKovOwRWA1knzQvpYfRPaoD?=
 =?us-ascii?Q?aBaAfS1oEP0Nmk9RlGYoZbgM8BULHcOQqSphxiVF+s6SErXp1xS4dq5AADbM?=
 =?us-ascii?Q?dL/YT/H4fbfZXdsyV9KbgZYOmw8eSqB72CJBJbrpVxpxeEdj9U4qWnIKbuRh?=
 =?us-ascii?Q?eVB8V8qVtUHjJwR5wTOOi9TDLeAeBdGmDFFnVyWF7UFDvKg0eFdW1qvGuvN0?=
 =?us-ascii?Q?bWarX8UFR138jIQ9vuXBFPf3mdeQoWdZ7J4GffccTM4yp6PrHIOgn7nftmmf?=
 =?us-ascii?Q?kSqFbCZGlKiww+KJmb1xdEIDkiDyLbtW0G9ZCOaG0TDrLW1ilKXb2QNWf2yT?=
 =?us-ascii?Q?y7goLavoVzwlyOuEyHLweYFua+nVADLyhO/IlTaxZd58aF80iXZDcKOZFrg+?=
 =?us-ascii?Q?CcuWBOChu/gpRNlb3L971ZBzQ7jWXIomoHylu2ruIX4ODuobf1hKOsFnOhxY?=
 =?us-ascii?Q?8KE9EmN38Pi+fAVda4rUWtarRWUwSiIFmMNtp3jGwWlajGg18bNIa5NU3g5b?=
 =?us-ascii?Q?8BYIoBOB8v7L271cdY3bPWu4Tix87JtbTHySl/S9d9EfV+orp7/eojsiggnp?=
 =?us-ascii?Q?cTb40otPEqS58hNqS23YAb6vqo74IuiuLjOKod6Ax9YmwwwW866Yn+Y/Egkt?=
 =?us-ascii?Q?+ezHGXKVxKDhEF6duoPY9k/4mtiToornpCpn+8D7ZOPD+fILDGJJsBdFPRrU?=
 =?us-ascii?Q?6/grC0H9L26dhToRnjkYzq/gGUH4EbGDYVuWnCkzmJLNgDKg1NhcD9opurqG?=
 =?us-ascii?Q?HmQkq1g7wwqXQGY476ZhCqy1hxMHtjm0lbKi67eKFjUCvFMQe9WMe7R5NeCu?=
 =?us-ascii?Q?WZEuCAd7SDPp0/KVb+cvCOddF4RLp+Uos41Qo8rZ0IQn3UC8GK3QGc7ZXQ6C?=
 =?us-ascii?Q?X8dPKtlRhpYeaUrFrIB8CASXMxnnBLZNoJoifZkd4+XVxm/cKGxbbMJxicvD?=
 =?us-ascii?Q?pNze4edW5R9cFq10KMQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZDWtjj40fvHMGdmxQO4wCwbgQVu9B4TR7w+BniwW8ClyY0K1RCIHXaj4JEhn?=
 =?us-ascii?Q?WMr6IutyieSThA3aFhrQ1C3zOmkBc2rqXnpmcxquvyPOhN/Ruxn+zNmOtHwP?=
 =?us-ascii?Q?yNbRIEwb60Eo6P8/gslwqeF/mO2vXrZN7Ukl38CoQBHFZt5GTlmC7dSBedH0?=
 =?us-ascii?Q?cAdt9Xsv8+wJza/DiCqF+en1bEY8O3d9Wf+4hlbc8xyIfM9rzvq6/rk5/W7Z?=
 =?us-ascii?Q?BX4pkKjZy4hyxSFURZwLijynbSkqvVKJRIZ/FMVBsP1E5N8KDi7fv2GWYBQd?=
 =?us-ascii?Q?qGuY7o8SH0gBwAs2mGDmp5frmX6q0oX+mj4A22dLbc07nzfpa9eroW7xtScV?=
 =?us-ascii?Q?m1dWWmJ+uzD2L68/uy+lvPTgXhRtZutySQQcqwPuPxuKY6KrP/gYVIjgaIQA?=
 =?us-ascii?Q?ljJodL0qdhagpcWWKUn0XWeMf1toXv+u7L9G7GC3WpisGpUB8s0II2KJqzkh?=
 =?us-ascii?Q?2XkHnz0uO2GS4FOnvaoBvpbFk+JbPEG+9pqq79BnlBUuiKjh0b1zBdNVG602?=
 =?us-ascii?Q?ugH1v7yDygOYUL+kMr+/+DLDN6B6GhrnDC+XPOA6nluUQeMAwC65hau1ryRF?=
 =?us-ascii?Q?DUXf5Kq3+H06L1CWIZujL9msgOMt11jOxkQmta0KpOzgkbo0yd20lkL2hOMR?=
 =?us-ascii?Q?EK3rSwzgnuiIwwjzmVpe4yEVjpfT9m/7hjgDvrOzJw4J5k12VR4KhnAVOFty?=
 =?us-ascii?Q?928+0/NxSiF4deH9mitDNWPTSwAdP0GK2gdltebU4GdO3w/YXARCqswBrXsk?=
 =?us-ascii?Q?5lHGP/X+KhplAHwb87fzI9nB/YjI3AstfUyy7/mRRgWB3CsGwxWcrMNtj3o4?=
 =?us-ascii?Q?//p67QbzriCh65NKGSjUlX76afRWkWuhUn+uus3MA4L65VxnMxo5pwvkNHRw?=
 =?us-ascii?Q?KDJXZXNZZl0G5EIRr31vbzbTWindFhBbUFBXxUHdj/h8zwmdvedZaiSlr0u9?=
 =?us-ascii?Q?5pM+DiwNT3v8aTA+Psw+5+0uhijg8cCbj83OnVtOLyDX1UAEaLruL/NUOc27?=
 =?us-ascii?Q?ZTHDQtebow5kaI/ISu1FrbdKqcb5V3fEeQUN54xh+aVmtvcS5NzNeVzJtsWh?=
 =?us-ascii?Q?PaE0PT8TzoS8j+1/H8279sYzRe1+/H188/UFWJFn73IDa2WZ+I2cDXCLyCHc?=
 =?us-ascii?Q?yWU3GW4Obsu5/7ueLaCrgq6EYUMdAdg+mnRqJDJ3Mnmq3CRJUZg0SjFloSJQ?=
 =?us-ascii?Q?FPv9FwQ3LIDp2Mf8M/nDVcjc2dieL59eLgLz4pbvJ4yIABdzayyr8sG2vNSK?=
 =?us-ascii?Q?TsH3tA2Wqb1h3Ng9xOyTpi0w/TaYM8wVljhwil3mJm8qnqst40D0ds/2EY13?=
 =?us-ascii?Q?nH43GZlY4ldK1n2AHRzRZcP1GkV+tKp5BHuUuKlTnOaKlzJfAFwm8NdweXMa?=
 =?us-ascii?Q?LoYzR/OvuCRZkYZf4HyzyqaqeNr1CjFI99o+vxkYBl20jowsHd30pTmcgypG?=
 =?us-ascii?Q?C3Gx3P3T6EzRg3yj6dFRkFFUR6nT94CoheDCX3NRdqGHALSCvJ2mCCO5QRPF?=
 =?us-ascii?Q?6BCaNBwYQj9RV69DMeA/Ya54MoTCpuLrVy41jCkDqEQIv2YslSpulUI6jPlf?=
 =?us-ascii?Q?XWHaneGpq9joySkb+jsSq2RH9MKHjcPWHJsRLkgjO7T8Y9xPmXtX4VsjuTFI?=
 =?us-ascii?Q?lFI1+Cdf9Yyjrwtr4UK3DBRxdXJXvO00drMyKV3QQGMV+PXKlUUUOaP4fr45?=
 =?us-ascii?Q?T5mw4mHs+taSnAVkjbZJhZ+MhAnkDyoUnNV9+doPhC09533mk8vg6ihWoUbL?=
 =?us-ascii?Q?kfopST7Aaimhdp+F2SiStUW2pe9XmYM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yYbGhVEr1Gu5TUNarPVGsVEyFtF+CIknC3XD8ZH9aA3FTDtaorPr/wGqMG8Z0uFl466M9Lk6jksur6ud5/lQT9kkrWKiR/BWea5b3s6PcnlKMtZsB2br+3wTA8o4mhWRz1EX8hXoqRreKE9o1nI/Ayen6LB8SYYZeLV7f9cbQ1hxGl0dwr15Q4e5pLgAMar9mXnsmOTPB2LH+CNgiist4UqXRTpgOiVkYhq+dZcRok3MuBMSVLGWkxXScA5jUHHy8TX1cR3oEIsRhVW8B7iMhpkzqV4gW00c1U28hukonJLNDmXfuOHGxcPMbnKe4UOTNXl8b80rlDeUPmA1/4lJt3KejqlG17Z+skyjDmlQD9QHlXLxMEmYV4oTFt6vDZaZow8dZ7+DN5HZneCwuTEg6qL+zjxHBTo2cGF/JObOhr4GmoYwITFpgXaSQgxfXxrLT6lb9cRWkeqGKeGMY8jIPj52YICahHkot+VzirHsF2quDWEqDp1LiYSsOiJVOh/nE0uRNiDlEKuft11D0wzeJPtLHgleCuGaA/imD/ktuZCXwyWXwJKwkmto9/3Qc+xpMcSb+8BDvUm4Ajvy/1Us8a3iVjhPh9miPPu+QuJF4LA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0beea812-8c54-4697-b2f3-08de5e60d012
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 11:31:43.4925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EdRpoSI0nZDgWpppFMpD89xay7aUu/KQJXoAj4R6ymOrDL914aGo14sHeBKiUKhoyukbBNmhQnEXA6xk11kJ3LgsWJwq+N7B3JSYYHxwc7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_02,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601280094
X-Proofpoint-GUID: FfFFFUczGqiyEwG8viBg76R80pnSjQ_w
X-Proofpoint-ORIG-GUID: FfFFFUczGqiyEwG8viBg76R80pnSjQ_w
X-Authority-Analysis: v=2.4 cv=UepciaSN c=1 sm=1 tr=0 ts=6979f3a3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=fpcF-2teMqrY8f35BKgA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDA5NCBTYWx0ZWRfX3Q1/6vPKdJGg
 BfYtCyQIUv4yxLo2UyebkCkosiQpoauynoS2rEim+aOBKsbJM83s/gSAW2Rd3Ryia/hVncDhPvv
 dMhaMTa6OEcsDaU84j0a9tMa8CTsox/T2oCjxzu4KB9T7wb6Xu2nLePzBrjPZMUtX3eUkM8CLas
 9MpW5rL+mgilK+lVBrgyVJwQIt/D+FgtRjrmrkc/192T1m+/AZv7mJCJ+nKluCQCqjdYsqzaiIv
 fwZg4vAIjmS6MQMzNEmbwrI4iBCTDjS39OcwqW0K0dVyAVXBv39tDqqIsySi7wJldl7kqMEDq6M
 3mRkMXdNdjGQRjnaoNG8oK+RfPavLTl79xB3RMeU5lZtn628rGAUyNp1Vj0EM1Lvybhj4dkw89q
 t+D3uzEJHjp2MPjX6xiF9KdF/47dWkA1kLsofrefMf1HRdQn7770aay2JmYfIQSRwm016hj7PTP
 cjSTlWqc6O9ZjF1C31SKcVtUsekb1tm4XJrpXt94=
X-Rspamd-Server: rspam12
X-Stat-Signature: tkom9sa9buqn3qfcw8qa3o5h1kbi5zbk
X-Rspamd-Queue-Id: AB3D2180006
X-Rspam-User: 
X-HE-Tag: 1769599924-784716
X-HE-Meta: U2FsdGVkX1/Ux+Zb2oqCXf/VrMN61fVsM20itN/R1sYrGe1wmsecV3aGnZUF62myPDZ94beCHkeYauywUlFIZnNjE6GLXTr+l6wCbFiln1NzKnN2N9pNhOEsZ5S8BtrOTo7HP+yiqS2KW5y+AA0ucmguoCp/fw96I6wCFzxGDj8yFG3NvB8QmU1fdHufAHyxJqhXTsyZBBnQa3QoSqOtz6meyrHgbMBOlYQlcR0F+FR6srSBOQefxK1Y65JUNJGlKyJfWZm408/y7jQDVb7Or25C62A0jAd99ruChHpHEF0eGtxYK1eBTNhg0DEhlVYAM2hM3lNSGtkbzR+6bXetMkC9FuRtAM1W9IhorxIWJPJMFvgeToGix7Vnvg8n6heRAK6Q0poKpccoGx8VdhSvIkC43xi3sS5hmNcOgpKaC55GTXg7X5Cozw9cRKIkU44+V8+AD4eFLPnAWECRA8j11VTX2OKM/1DpjecO5KAUcVPhR95AYYafnQxoO2Jd+0qouGfbRqdtSYiP4/vH1wUfUPjfVZsjMPIDRO1mROlG61UKPPCudqq47jGGLGBWJDrAVxQ6e5/zEt+oS+30/6E2e7pr+1jwDLGD9zmuLda28SmhuxHzBf3/lfwrIEKzAqXY46VuYHp6lyRAC+h0gOBLBzdo3q4/XsnD5UIXpGpSX0cf5PB1ZfiEIK/4//s1K3vXBwMcuVCrQDYNKzG7B1YcmyCOUeHA2wTluf1Wua22a0iwAAVOBF5rdIrMpdHrf3hwnw+P7d5+F2Rpl7OVhcEWAnSuMa9Jd4myTC6GDOIWq3Nh6vuEZmpB71c2Wv1uNcSxibTBW2LuwyzKZEJqenpXivPwsQptedW9SXOGlfXIpXjfwmzh5f8RWsebeVDiflS3TrNHxmALaTOj3EANbPgFnnyA2dJY+fXZcb2Eus70ng0r9j3VBo/Y+Xb77PWkSq/gEZtOAfICzxEwrDLqznv
 BrWCec3u
 x3XqjtD5ZZYFnIK2opS24yHCnMembQZ+xacucMcqiEfF4xV9V/T5eGlrOlV8voGMQ0jZqxoOA0z/0/qAn+1PrWzWZk9/RmDGDlfjsxTLFjM6pgMAJ//xyCmD7Arq2lJdyjZWWB4mTpB0ykYUU9z783LgTDiOkbYgyl5QrgtTFwD4cTnuI5fliLkJ55dZpBl64+QvIhKA5aC1NQmfEihLsGZuqh5GfN3NQ7itwN76D1sRwpagd2IlDx+1YkQSJwDTJ3qIrBZYYSwMCF1fkWEm16pMmE9PkQVE+WHabl2VfSM/HfUegGCUZ4ZcBEaJS3AK2XViYcax6y3f3uct5cdkiyx2jbv4BHfv36XleyzBR8sKX2aqpS8tcXl8KsyV1Qo1+pPjBW+FTWbitvtxj3fjSEzw0W+0s3rDyC6wEei7XDVF/mkC+FaoPN2vtbzw/6HB3bIjM+zSCTOpfNxoZS52xqlCEehequF8d9INcRX1H65RKObEke/ihEQi9OXlZnaVoxamjUr3/TNMt5pEhbIM7xVWBOC2eAAok0PFwjV3wtGx3OEFUpLI/slyMpEtOj/e4PzgvRDGIcwo3d4gIP4Ao8gdsxv3no6c/Jq0/SKib0uUs7HV8mFEzCSNMFExrHd3+82+cR6njlqQMgZS7lwMS5nWZwpnsEVq6bwpK0HnzsXVlmITqPtNttAxLZ4O4y8MOMpTQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 12:18:32PM +0100, Sebastian Andrzej Siewior wrote:
> On 2026-01-23 20:12:14 [+0000], Lorenzo Stoakes wrote:
> > The code is littered with inscrutable and duplicative lockdep incantations,
> > replace these with defines which explain what is going on and add
> > commentary to explain what we're doing.
> >
> > If lockdep is disabled these become no-ops. We must use defines so _RET_IP_
> > remains meaningful.
> >
> > These are self-documenting and aid readability of the code.
> >
> > Additionally, instead of using the confusing rwsem_*() form for something
> > that is emphatically not an rwsem, we instead explicitly use
> > lock_[acquired, release]_shared/exclusive() lockdep invocations since we
> > are doing something rather custom here and these make more sense to use.
> >
> > No functional change intended.
>
> This is just "replace rwsem macro with our own macro" which is fine. The
> subject confused me because I expected something new to see ;)

Haha well yeah, I mean it's been a bit of a journey actually, reminding myself
of how we actually use lockdep with the VMA locks and then, in real time,
realising how broken a 'is held' can be, so in general I think we got to a good
place!

>
> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Thanks!

>
> Sebastian

Cheers, Lorenzo

