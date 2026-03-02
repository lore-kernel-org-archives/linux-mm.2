Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C54E9B36A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7722A6B008A; Mon,  2 Mar 2026 07:21:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71CF66B008C; Mon,  2 Mar 2026 07:21:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CAE96B0092; Mon,  2 Mar 2026 07:21:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4532A6B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:21:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F03255B963
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:21:21 +0000 (UTC)
X-FDA: 84501033162.03.EAF8043
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7ED4FC000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:21:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TKalsNds;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fvpfLZQ6;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UTwpBQScIptLE1Pa2a3QDxyK4SyKYNDDK8cVh3fLmpU=;
	b=e8i4e6C+vfIX3cbhOSdAs4rmwiIjpQD3bBKatCb7Sc2QDEk9Ts/cPnofwaV2SmeFceSSnc
	BKMy71TA4RPnbrrpX91vr/kfHx01aClDOMqw67U8GDPu7fpQ/JOTHySUqP7H5Er4Cwow/E
	M4vvvvRYan45cR8v9TWi78+8yY4M37Y=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TKalsNds;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fvpfLZQ6;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772454078; a=rsa-sha256;
	cv=pass;
	b=Yq9GyEoJffduKq73Kj4Z79nHHqd33cz+D6y1ne+tx6wxLHUL9aD4vKNXEQHxZtztMzwyQW
	gdx4PeR8ypHLpTnCEeT1LvjKOZIAxjT4ZeDnK+UgBlqK49E/+16+fbKVaDiWsEccr5//vV
	3IainvyMKx9TVxYu3pm+55mJ5xH+U4Q=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622AwMbI878717;
	Mon, 2 Mar 2026 12:21:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=UTwpBQScIptLE1Pa2a
	3QDxyK4SyKYNDDK8cVh3fLmpU=; b=TKalsNdsByr8PJcKwLBO0en4jAIlhK5xIp
	yo+nkJ/R+3O1jklrUP+CnN/SyD3VwbujaVG/+U8pyW/y4W262Ve2N0cc3CYoDajM
	s7W0mrAZvMg/xb6S7/AWVSWKSU9Xl73IVX9XsFyc8jxcuB2+HcjxxwVPTNcDV31V
	DRJVRaYuklW9nMbcKHWOTWQvY6Cb1b0k9+/lmEDHyG6G4zfEGogxO0yqdaNanaKI
	fP70j7utQHVMcHwgsMIxnnHcfwxEcYR1KHz3lS0J3IAb74rXVCorUy2tBFY2t3e4
	frAV5gDyrfZVl5l5BTRbgaAmroKu5aaEuRR6j66aVCQCPssUHN5w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn98v83sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:21:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622BN0mS037704;
	Mon, 2 Mar 2026 12:21:11 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptd589g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:21:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C5EG2pFSsnBfR9Mx2UGvdj1JAOWlH/7bGykuupHdUYDbHLOyg3q3pcgdLwI1IOUCxQuqkYY+0RJe0pi+nzuqN158RXXVE7/3Re7qyr8P3FSZxUEGtfkwvlLJ2Cwmftv61OQ1sYXvaJFEjTK7MNeSuTVi7dULMhfchUBLmy+ajd6yRTQZtVEN0NKcOZLLbbGNsKO7PItzzq82xvfHwTf4vvj6oVz9CRqijIAypr0UJeBe/BYhBRBwDr5h1GF7/0vWKUMr8oc45O/B6pqT6MoFhZok3u4plU/oXPCxOZYWJG+tTm95TnTQlXlXqf5/IH/j6AF8RvbhasSOyCey1s1PuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UTwpBQScIptLE1Pa2a3QDxyK4SyKYNDDK8cVh3fLmpU=;
 b=fiYIrePxSqsOOMNEFLdf2MMioVGP63D7YesDG30rmpDMmYboZLYgfuiEpUiJuF4EFQTcX5Bxv1WCLWZVZxZv/uOdUSUDOrfc/D/ULe4JUqN7e88Suh+Kz1XDRZgZuxu0VV12SaAzPzZICcSgAKiHBR3ynTiOwaNnjWolWzyzsYhGPEsOgIighVEKAGaYSn6PW+nC/wuEjv1FM8VD1HpbPN30hVX90J3Mopa2zDOmFsDyRkqYVAdVgU5WnleYoBYSvNCltEfODwG00bmFqWBb+vsRfoEhBOJwfeFU7U1txoF8G72OJU93Of2OH7dxBTUHXGZ6Fv7Pw0yjuje+SmPraQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UTwpBQScIptLE1Pa2a3QDxyK4SyKYNDDK8cVh3fLmpU=;
 b=fvpfLZQ6zkZRqamAE5iNNeO5QfTP4+l9YrWDopPQM2bro1bsQUR9jwa4ythkJQhKnzetMgQgw4QDYKDiHaf6qIlSlLDihQf3BFYXnEfJ0f7K7IF/JLWImF83GxXh6fAt0AfHsAbak0N0ESALODg7gHJHC1UOa6tINzSpnB/lezA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS4PPF8B03CE791.namprd10.prod.outlook.com (2603:10b6:f:fc00::d30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Mon, 2 Mar
 2026 12:21:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 12:21:08 +0000
Date: Mon, 2 Mar 2026 12:21:03 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Replace READ_ONCE() in pud_trans_unstable()
Message-ID: <6c6b9a0d-987d-435e-a024-e10ea78ea107@lucifer.local>
References: <20260227040300.2091901-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227040300.2091901-1-anshuman.khandual@arm.com>
X-ClientProxiedBy: AS8PR04CA0189.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS4PPF8B03CE791:EE_
X-MS-Office365-Filtering-Correlation-Id: 2842d0a5-e74b-4786-10f7-08de78562eab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	+Hz65A+2r6djXGV/vWJusv054fMmtSakY3LfLM80oHtHDOUKReFPvHbSMIL1E2bw3JBKe1e8j3g3wn8qVSM0+Ld418cmt/gWfTum6GpI8+MhOvJ5P+3Foa7MXFUhVjinegUNi28rIVc0Xx3mRBBovYLJr6V8fu+hBNqaCVwS82wapGlAGJDdkNL0BwMw1+0a1ADz+NS0UgV5H6KDApjwlIpawD56PBCnQJMMBE0Pt4+jl/7xnMx5Rc9SYRz93l5pYJ5naLbKttjFFZA7qIlVCtmlOY5IONKgm7x0UuKuedk0Q0uXfqv546Umhvd19JbCUaRnDcryGESiIIe8hGRjLDGSVmPjPi7qJkcLVGRk6YoKC4oilHYPwWYpEr5N49EIafsoneItBrj3Lc6P7o09UdIblYtjNaa7loeEzy3GbRCDRzNQgg4ng0j0ENVt4git3MgT3JxPXRISUaMuujOOpTucV2CiU3Ot6FGnk9MVNlbKbm3qi9tPdo1jV7Y4vK2Bog5rwkzTl414xbdTckwKVfH6ncco6k8X+0acbj8M1zYe11b0Woz8zt1E3Mrq+N8Lr3iakDcZpSnXxQ0X0E4U0CqR0bIj+bIBCzLWwv0pAjS9bYEg3Jzd0JEx+bA+eBZOA0Ec3U3Q5U07r/C4yBGRTf0ruaLqV1ccNvhlH3pj0oS7jE76ocqDYighSmZ8PsFw4JUxYjJng9aiwfqeZf3Pggq5nwXjhRizvFqs+jME5Ec=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yQfRYk6s8PQpo21aOtxfIfDlxcmfwo48s9zLGVbLMZJO5KhEYOrZFqmCGYd5?=
 =?us-ascii?Q?NGm6yNZceE7rE9nlHkTJP67Tz/kCYBBRrwYSq5h6SBd89PL5VuBJgG4SU6h0?=
 =?us-ascii?Q?DDktdVIXEVRJclYHdRfwdrXURFkdZ4CO7mci58q3H163h4Wr7ymrkfmZBagq?=
 =?us-ascii?Q?QZgm8SZfB05YC+GKTwz+epeZFSqAAuQOSlDLL1OZSXYr+CXomSBBcDxUvMub?=
 =?us-ascii?Q?xTtvCRSdkTnYqDcvI7R/GdpOF6Z5+T6OnQgMeoLCuWGv9VZl026PlZnDPOIN?=
 =?us-ascii?Q?J+CH3zfjFb5D4h5D7YqVnFRrAQ+jo3mEmElJb2ojNxuaenzNJfhLN9EeHrwj?=
 =?us-ascii?Q?PGnJUGSI7JKPpVzDMmL+iri0f33qbdlBatkugRvHtEln3y1q0f9MyNqX5JlO?=
 =?us-ascii?Q?yASXoBOTbELq6eMXIwQP1vFtQQ6wfjLc5aFEtKyiQdUG87/2iLrXDuyK5YM6?=
 =?us-ascii?Q?eR/TOhCxSCPWC8CM9m25S86sZ9i0KNqsrnhvnhriUr5BCcHqd5BzNVU2uyjT?=
 =?us-ascii?Q?Wg1OpbsQ02f6yeM5LgXeQrFN2YV9bP4xlGUkx/iyc90UfETuf1RZSSAnoNyQ?=
 =?us-ascii?Q?0mpBTe+iYqUPFSmIHPmp6xXczu+e6JpJd3ca8RlKOFZxSqH0Lm45dhs7GViO?=
 =?us-ascii?Q?F0TLEkDbgcqxv+RzQDuyOqBgYuS0pjvhvbsXpcSSIB9GQE+PoyIf+ZOak3hS?=
 =?us-ascii?Q?RqFKr97s+/AoUTHBX2zMuCP2/FAo8VdPFrozo73+hNX211LiounlIFyyFRMg?=
 =?us-ascii?Q?BKCsqxxP0zxmhyP1mSy6uzeOVDR7PswbRWdjjnYxMdMd+NT7aFFREFp2GKeC?=
 =?us-ascii?Q?NAj7a8ujWP7o/FMucQPkLLd3A8qp+DMnhV9pPuAzA2yiXTUgs053kCjILbc+?=
 =?us-ascii?Q?a+5llYHjgPk853DULZSZ6ScFfk3CitWQPzqlk8mei50mvp5caxfCMFb7tHtI?=
 =?us-ascii?Q?9KYePnBmQs5uv4T0lPbs3HOaNp/DtilkQpiG7WoYdRUfPpOlZAYc1QDwRchu?=
 =?us-ascii?Q?rQ0eQtdA19JSn3Gi8ScR1VN3tEsRWHoNDGYBOspUwIB/fYbtsuhrmzWZyCRE?=
 =?us-ascii?Q?NyVPT5rN9DMNUXdc/gY89XsQ6bhPlmIqODQIpKA1metIhDMgE2zhzmWdgD8O?=
 =?us-ascii?Q?cFls23fKOYAo8uPEfLWTsHnSLbY2PUbe7+9NqiriKRRuWSyp+c24RUGpCdAw?=
 =?us-ascii?Q?8e74uOEKLFvK5S7BQwVz39YLPdtBzsvt2MaZQW1P2Xfa26itTmFI7z3yQBZv?=
 =?us-ascii?Q?2GFuv/APwwvQUxrmkSkTsufsrRHhgX28LXS2VQ/m2nTk5FE0FC8q0QLN0l+o?=
 =?us-ascii?Q?d9Hji5N8DvvkNEh1jFtFlqBR0yZmdAKJEL3F5Ds5LrAi/oW7EZkpe1fbBJJ5?=
 =?us-ascii?Q?Jmn7cmkq8J4GrS5xaDUlfgo4QugvLcdC6R2yMWiGXnnOXEmE+z6vLGZX8JE3?=
 =?us-ascii?Q?LJvH+h/zkwDOV/BbI6z8B6Or+uoJZk8if/m+3ZA71Xpdr5RyBKZnbMtbLcFp?=
 =?us-ascii?Q?lfvlkVR6EHNljBapt9z4UnINhqHcXTkWVfQASLk+gOzpVKdcSNxCCIlpiBcY?=
 =?us-ascii?Q?FoIB47Z6WS7CFmnLOJ1hC47KDueOjzO8ERsOlHMGtUSt/u5nZfOuzV1zhN3d?=
 =?us-ascii?Q?N3x5fDBJI3F0dgbxdszA6g/c4BIb7ger6Dssw8GTPjGyVq7xIWNMvF8Osb87?=
 =?us-ascii?Q?C+h+NTflipc5ApNM91YPR7lbAynWbtBdmcuxJy5w3Iw2Zgr9h06BbYTD5FcE?=
 =?us-ascii?Q?O64g9qTQgOucQ76EbqOdKncVdcgAzuA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1MU2ve8QuYHEz3p7V20912cn1xULsXTGXC6EJvXZDKtTApt0ruxavDHi4FMEUawlaZyjdeKuThLX791PB8+nfQxWkEwLaonD9JDySBIxzjkPFXzkEyGecPKjvnbGWKHMqVh6kKtex4iIGLRogAcu+MiaKY6izcbQVnvqbU56k2XGQnV4yKDuBOHV4isg88GmE/c3xEDDbEsXwjjeti3DoT9Z/UqQX7Z7q8NfISTnZS3TI8MZNtoaMxnTsTQzJFCJT9NpO6pyHSqEfmzC3eebKCLMx+9HvC4j9fD9WtcEPCCWs9i0Ohb0fqPuB7q1LUwqOIRLNmWnx54uYUOjCas5Wq4nTL/j4fkwGFcOm1ZEnD0aJIG55UTGuXhwdaomHxTCq+0Py3EVmX0m3Sd0xV9T2vdE7pP3g/sWwLXDU07Sa6vioT5UNxUN9rbAGtwcj5une0lVhOihIzLBb0Q1c7aGWM6J1QXOJMiG5LJKiiA4+d7DRAFPEgapfuG+2BCtXe1tdjF/0jaJ9aAGIAHH9nkqhrDinv2SPuuIhHhInoqxPZAbZ6/JbM52YHla78cAQM8TdtlobBnTqaCv7G8rzYiObESK83X3kWLlZhV3nWeNV+E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2842d0a5-e74b-4786-10f7-08de78562eab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 12:21:07.9573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qAnPbivAV1tXBVlc6Y5BuBEStjH4Em2EBqaM8ED5jHJw98fp4EJhUNy2zLxO4AZkAzdpjtJwh6uT3NNi6gMmb9FaG5j98VNijXlptoJmjJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF8B03CE791
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=621 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwMyBTYWx0ZWRfX3WULIRxtMv2K
 SMDABACvflpOgyPf7AH/c9pmc7AKH3bG9nMyNFbWHEv6gADCHIJrkNCxh49dg0D45lANUJ8M6b0
 CD0DlvXNnfzadWaiTa2RvZyhVu8dd5+QriXIIoKIkO8NmC0a3wfxa7RiENCF44WLitrmYKDwMD5
 LDdVOKWoMnL/QaXb3nwZbzBgiSuTQHInwCa+gIKADf98X4oPOz97pHcvdMZf8Wdlz8T3IKMy5SJ
 QPYnbP4Qq5B5MRnED5jK9XbedVah0zeGvVkHhn51J1SZP8kUxs7d/NqH5Sh9z+y7CwxJ5oKnjg9
 VN9qW8KOATYQX/hn3JrMBoi1VXk0W172gimmhnAAziacwIL23e8vR/lsUHW9XKpmJl6YIiUjjEN
 owKwQhFA6ZCzN/Boi4Kx6xsrJoHu/K6O0EIY7dSyugPUqPDlC/LkPBa7Hy/FpNxyur99eK8zdAA
 9HwaXXYJqGodwecDWBWGBIrDX6DlKmy1IDV8QGw4=
X-Authority-Analysis: v=2.4 cv=TY+bdBQh c=1 sm=1 tr=0 ts=69a580b8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=7CQSdrXTAAAA:8 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=37rDS-QxAAAA:8
 a=Hoeh0bdRuDmdmxEvehYA:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=k1Nq6YrhK2t884LQW06G:22 cc=ntf awl=host:13810
X-Proofpoint-ORIG-GUID: yKap1w93X4a64WGFw-K6-AIRDrTl3pKg
X-Proofpoint-GUID: yKap1w93X4a64WGFw-K6-AIRDrTl3pKg
X-Rspamd-Queue-Id: 7ED4FC000A
X-Stat-Signature: cgft9jmxadk94es5txacargzuky3sepi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772454078-704079
X-HE-Meta: U2FsdGVkX1/Jf/loca09V4SGnkmu1AWV9+PAzWdk1mdg4hjEtYk9wik/WbEJmYkwn+3EcPFHarYfI5R39gHYUhNa4gVfdpGfRtJ7uiXrkgm/f3OT6lvJWEg6nPh4VCmdxa58dpar30+gjWploTILYKosGZxsz8izc+EoZHjTGeKUKGume9fiOUv4ortLbP1SPQbRLXX7KAdNUm5aIFKtlyWkBl1RkO+cH8RZ9BrAOwG4RQwguZ/y9e6kX+C4muiN/ubQqvmlcyLmx13a8k9MFDeVSAv5oDUSQQ3794NNAOq1nD8zQ6NNuOqcU2GpQgOcBhQ6Z3rWJ97j6pEYO+vaqx0Z3dAVtF2Aa4GiZu5OLpTQsr9PDwOeocw9ZHUzOrWqT3QHDmDp0ZYtXSUhIYwnH4PSB0i8p+OoEaoesIIecuHbno4DATQ4jK0zHRg0SS4jz07i5ZYNP/rO/l0pAyL1P8JWqUbfxBmMsiKyacvK0A70ILXC02488IllcuGu3ujPaZFHlORuNLSKagMfNvrS1z+2bdXmWE/zkMJ0SD//M6FSei/TW9NnmuNyAIK+lJ8/Xb3Qhpcvf1ofazACr5uNpFRI4/6aJOrH40LiTXRpPUedT8NpsUgRwx+CsxJMqCsvONKixib3b8fj7v7AzNzu3BHZKYxPnVO1Wy/QQOdYdWl3mETRcmyNiEVFc9G7VdSKvpf2KFv28vqzO3HlbmoB/vVWBeBrSrWMk/DWF1bF5pZmwvjHFTGGS3WjlvOLAFJNTg9Odui3O6g5toO8re/i9OldWbOKZ3CsCGD9BTV85+Ks0a2IPhga+MQItm8mJFxf3amDoC0hmyen+33aZtG09ckKYSye9a7TTAryrgmVoGEKyqTkZnuVr/8S5e/EVyE3bZzAX61og6YSyzoUOjT2ItlLoHmG0/108G2oYY76uBjfGxx2kn1XV5Yoahn5YOOZt9etJHVaDDE0tZGVeVm
 j78yF5qq
 IJ0qcWuI/TY4dvrsfzzIlWl230lzNl7C1I0ZqvpjGnLjx3huRESj6K8hfKp8xGfC8Zl9W8DGz0fyVXONFiuYgtz4LoldAIUMuPlbSdUuhKhGksiNwVmH3ckLlA2h/dAfmI/4vefF7b7HBgdSWIVA3uscbupIakBQFLNVhQ/Da66AKmQT96HkhGZRiAoF9DrTjXsermDjCSut8pLswVyVl49k/R/fbGDGTI05mYexjT6LK6z8E2tSMhIpW+W/qmUkDE6B8A6UCpvXOT06qJevo92/vB0VcmLmozewN5/H+xrSNMwuQQFEy9VvBsL0acl5a7ZS8u5rYQCxrdo/jYJDDVWQ/M+MA09kBPbgcntA8zHHmKRmO5GGlj7Tactv1J67azf0tRSxYOOUJ1iLsasYLyQjetg0ZuhbTbe/U5BnqkPexlauLvZJglRW7cnZ4+C2Esc6bww9NdXWSywvh0Nuzzqkx4aZk6tjeYK+nDJY07a9XKJbUfc/0w9SFs6rKCSF/LhNDraTDrUfUCz2LhXx2bl+WLmLKlSK6czNkB47ayeOeV3dQVMEbiquHjHk3NkK1nebLr/rLBtEwTUFPlgR95nVCtZLOq0qAihT/8lzvoGistrwIKir+m0IG/X5qceXHdX3tlO6Yw0pfamFkrpvzd7X+kMbmEMr1jl5e1OgzB7N0bfSFRDkLPvHxLdVcGhB/ehG2itffkL7huF7lL6x2JJcbaUlvPyOivVSp7R7SRYC6rmfvZQuYujhm6UGbOndk0dRA7BJtm+sDyVwY6aC6FfxPlqEhYIf5o085veAmTFR7DcCgYOUzckQuIDtqwwOvTdXoRVUNcF7H3YNdWQhUYTKybKqs/+hFI3PE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 04:03:00AM +0000, Anshuman Khandual wrote:
> Replace READ_ONCE() with the existing standard page table accessor for PUD
> aka pudp_get() in pud_trans_unstable(). This does not create any functional
> change for platforms that do not override pudp_get(), which still defaults
> to READ_ONCE().
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> This patch applies both on v7.0-rc1 and mm-unstable.
>
> Part of the D128 series but independent. Hence could be considered on its own.
>
> https://lore.kernel.org/all/20260224051153.3150613-4-anshuman.khandual@arm.com/
>
>  include/linux/pgtable.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index a50df42a893f..d4826447bc93 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1989,7 +1989,7 @@ static inline int pud_trans_unstable(pud_t *pud)
>  {
>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
>  	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> -	pud_t pudval = READ_ONCE(*pud);
> +	pud_t pudval = pudp_get(pud);
>
>  	if (pud_none(pudval) || pud_trans_huge(pudval))
>  		return 1;
> --
> 2.30.2
>

